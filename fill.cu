//created by xianglizhi, code follows exactly tensorflow fill example which is below
//compile cmd is nvcc -std=c++11 -O3 -I /usr/local/cuda/include -L /usr/local/cuda/lib64 -L /usr/local/lib fill.cu -o fill
//running ./fill
/*
 * .html# Output tensor has shape [2, 3].
    fill([2, 3], 9) ==> [[9, 9, 9]
                     [9, 9, 9]]

 */
#include <stdio.h>
#include <cuda.h>
#include <malloc.h>
#include <cstdlib>
#include <time.h>
#include <iostream>
#include <sys/types.h>
#include <errno.h>
#include <vector>
template<class T>
__global__ void fill(T *input, T value, unsigned int linear_input_shape){
    unsigned int global_id = blockIdx.x * blockDim.x + threadIdx.x;
    if(global_id >= linear_input_shape){
        return;
    }
    input[global_id] = value;
}
int main(int argc, char *argv[]){
    float *float_matrix;//declared output buffer
    int *int_matrix;//declared output buffer
    // assuming desired matrix shape is 3,4,5, now we malloc the needed buffer in GPU
    cudaMalloc(&float_matrix,3*4*5*sizeof(float));
    cudaMalloc(&int_matrix,3*4*5*sizeof(int));
    //we fix block size to 64, feel free to change
    dim3 block(64);
    //how many blocks we need for this job, for here we need (3*4*5 - 1)/64 + 1 blocks
    dim3 grid((3*4*5 - 1)/64 + 1);
    //fill<float><<<grid,block>>>(float_matrx,1.0f,3*4*5);
    fill<int><<<grid,block>>>(int_matrix,1,3*4*5);
    int *host_buffer = (int *)malloc(3*4*5*sizeof(int));
    cudaMemcpy(host_buffer,int_matrix,3*4*5*sizeof(int),cudaMemcpyDeviceToHost);
    for(unsigned int i = 0; i < 3*4*5; ++i){
        std::cout<<host_buffer[i]<<" ";
    }
    std::cout<<std::endl;
    return 0;
}