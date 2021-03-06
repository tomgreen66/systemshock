#!/bin/bash
set -e

SDL_version=2.0.8
SDL2_mixer_version=2.0.2

if [ -d ./build_ext/ ]; then
	echo A directory named build_ext already exists.
	echo Please remove it if you want to recompile.
	exit
fi

mkdir ./build_ext/
cd ./build_ext/

install_dir=$(pwd)

function build_sdl {
	curl -O https://www.libsdl.org/release/SDL2-${SDL_version}.tar.gz
	tar xvf SDL2-${SDL_version}.tar.gz
	pushd SDL2-${SDL_version}

	./configure "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32" --prefix=${install_dir}/built_sdl
	make
	make install

	popd
}

function build_sdl_mixer {
	curl -O https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-${SDL2_mixer_version}.tar.gz
	tar xvf SDL2_mixer-${SDL2_mixer_version}.tar.gz
	pushd SDL2_mixer-${SDL2_mixer_version}
	curl -O https://github.com/SDL-mirror/SDL_mixer/commit/7cad09d4d479df2b21b3e489f8e155bdf8254fd4.patch
	patch < 7cad09d4d479df2b21b3e489f8e155bdf8254fd4.patch

  export SDL2_CONFIG="${install_dir}/built_sdl/bin/sdl2-config"
	./configure "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32" --prefix=${install_dir}/built_sdl_mixer
	make
	make install

	popd
}

build_sdl
build_sdl_mixer
