#!/bin/bash
CKEDITOR_DEV_DIR="$(pwd)/ckeditor-dev"
BUILD_CONFIG="${CKEDITOR_DEV_DIR}/dev/builder/build-config.js"

if [ ! -f "${BUILD_CONFIG}" ]; then
        echo "build config ${BUILD_CONFIG} not found"
        exit 1
fi

if ! grep image "${BUILD_CONFIG}"; then
        echo "Build script should be fixed."
        echo "Plugin image not found in default build config ${BUILD_CONFIG}."
        exit 1
fi

function check_plugin
{
        PLUGIN="${1}"
        PLUGIN_DIR="${CKEDITOR_DEV_DIR}/plugins/${PLUGIN}"
        if [ ! -d "${PLUGIN_DIR}" ]; then
                echo "Build script should be fixed."
                echo "Plugin ${1} not found at ${PLUGIN_DIR}."
                exit 1
        fi
        if grep "${PLUGIN}" "${BUILD_CONFIG}"; then
                echo "Build script should be fixed."
                echo "Plugin ${PLUGIN} found in default build config ${BUILD_CONFIG}."
                exit 1
        fi
}

check_plugin widget
check_plugin lineutils
check_plugin wsc
check_plugin scayt
check_plugin balloontoolbar

# add wsc and scayt plugins in build configuration
# so that they get included in the distro
# also add widget and lineutils plugins, image2 dependencies
echo "Fixing ${BUILD_CONFIG}"
sed -i '/\<image: 1,/awsc: 1,' "${BUILD_CONFIG}"
sed -i '/wsc: 1,/ascayt: 1,' "${BUILD_CONFIG}"
sed -i '/scayt: 1,/awidget: 1,' "${BUILD_CONFIG}"
sed -i '/widget: 1,/alineutils: 1,' "${BUILD_CONFIG}"
sed -i '/lineutils: 1,/aballoontoolbar: 1,' "${BUILD_CONFIG}"
