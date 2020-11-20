Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08CB2BAAB3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgKTNAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgKTNAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:00:47 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0EFC0617A7;
        Fri, 20 Nov 2020 05:00:45 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 1so9734192wme.3;
        Fri, 20 Nov 2020 05:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ibq8GkkXsp3WWp90dPm3zM/0kq3EDWKPWJtqoatfmK4=;
        b=E+Hss2bY7h+bNlJ7QszPDbfwb0HUy01gYNNJVD6Rod4KjcjRjAdWlFu3i7bzmmppsA
         jZZQ4mNoxgsGbsrrbPKiz53AOL8R8a0qwYMvykjTYH009noXTOD8H8odWNRIqoNzVXkC
         mQnG011B1kmMLzDXHVhYtTD8jvohCm3ZsujBOv7DYRP6bM0b3eVwfLmCR0KMmww66oKf
         nmGXEgUxhtrc7NpI20yPCQNNdrUVGw4bzojLr4O+3gK3xBQypmaZy/Rp3v4qMCKDmlfO
         uPc4m2a5z0xAr33pX7eswvoeF7PPEFgPhu1/Du7dYCr/6BtpwMPQSbvApuloY8zpgtSE
         pXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ibq8GkkXsp3WWp90dPm3zM/0kq3EDWKPWJtqoatfmK4=;
        b=Ps5xfTjCZyTvdDzNFBPPF31+hHj+aqwe0VWH+ESYfNM6D4vwI1UNA7YoGezpnVRzMD
         3nMfxgGFsCXyGOhB03SQOeKbJXXcYMXDnX/CFiRA981gDEhnO7P/uQUKTr0waEv5ZjLu
         Dxef9EE0U5uvVJasGYORrVO++lwBE2dzs8zJJBSi15R2cuY8jiZ8Zk/LxWmgN+536gB8
         INHcB/bmW6JmjufvsNmJS/RQIp5EvlTAJWSy5Q4DycbmaYQHbCBzyrXd32ymZQ3VYV9L
         ttDyG/Y0gcBUQ3JIyYXBhK/3nM9fcDul6bEhAc4bXCVUBe3L9pb6S16uCjUcdQRMVRvJ
         48Uw==
X-Gm-Message-State: AOAM532JDm6IvYY5oiJ+H3vyw6pIQr6OCDBdg9RSKN49CVmOt1oXgTWy
        u9ePvGntl0DK8EfeNn4EXamTKONnYnw1jky2WYU=
X-Google-Smtp-Source: ABdhPJzU0mrNVDxr9jRX1efktlKKwpnloqLHBZylbRweAqvmdqjDyU5pcipD1OfPQ90X8OYkPLmRNw==
X-Received: by 2002:a1c:205:: with SMTP id 5mr9409939wmc.7.1605877243518;
        Fri, 20 Nov 2020 05:00:43 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id b8sm4074238wmj.9.2020.11.20.05.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:00:43 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 1/5] selftests/bpf: xsk selftests framework
Date:   Fri, 20 Nov 2020 13:00:22 +0000
Message-Id: <20201120130026.19029-2-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds AF_XDP selftests framework under selftests/bpf.

Prerequisites setup by script test_xsk_prerequisites.sh:

   Set up veth interfaces as per the topology shown ^^:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
     that is read by test scripts - filenames prefixed with test_xsk_
   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
       conflict with any existing interface
   * tests the veth and xsk layers of the topology

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../selftests/bpf/test_xsk_framework.sh       |  17 +++
 .../selftests/bpf/test_xsk_prerequisites.sh   | 116 +++++++++++++++++
 tools/testing/selftests/bpf/xsk_env.sh        |  11 ++
 tools/testing/selftests/bpf/xsk_prereqs.sh    | 119 ++++++++++++++++++
 5 files changed, 268 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk_framework.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_prerequisites.sh
 create mode 100755 tools/testing/selftests/bpf/xsk_env.sh
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3d5940cd110d..51436db24f32 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -46,7 +46,9 @@ endif
 
 TEST_GEN_FILES =
 TEST_FILES = test_lwt_ip_encap.o \
-	test_tc_edt.o
+	test_tc_edt.o \
+	xsk_prereqs.sh \
+	xsk_env.sh
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
@@ -70,6 +72,8 @@ TEST_PROGS := test_kmod.sh \
 	test_bpftool_build.sh \
 	test_bpftool.sh \
 	test_bpftool_metadata.sh \
+	test_xsk_prerequisites.sh \
+	test_xsk_framework.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/test_xsk_framework.sh b/tools/testing/selftests/bpf/test_xsk_framework.sh
new file mode 100755
index 000000000000..2e3f099d001c
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk_framework.sh
@@ -0,0 +1,17 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+# See test_xsk_prerequisites.sh for detailed information on tests
+
+. xsk_prereqs.sh
+. xsk_env.sh
+
+TEST_NAME="XSK FRAMEWORK"
+
+test_status $ksft_pass "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $ksft_pass 0
diff --git a/tools/testing/selftests/bpf/test_xsk_prerequisites.sh b/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
new file mode 100755
index 000000000000..00bfcf53127c
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
@@ -0,0 +1,116 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation, Weqaar Janjua <weqaar.a.janjua@intel.com>
+
+# AF_XDP selftests based on veth
+#
+# End-to-end AF_XDP over Veth test
+#
+# Topology:
+# ---------
+#      -----------           -----------
+#      |  xskX   | --------- |  xskY   |
+#      -----------     |     -----------
+#           |          |          |
+#      -----------     |     ----------
+#      |  vethX  | --------- |  vethY |
+#      -----------   peer    ----------
+#           |          |          |
+#      namespaceX      |     namespaceY
+#
+# AF_XDP is an address family optimized for high performance packet processing,
+# it is XDP’s user-space interface.
+#
+# An AF_XDP socket is linked to a single UMEM which is a region of virtual
+# contiguous memory, divided into equal-sized frames.
+#
+# Refer to AF_XDP Kernel Documentation for detailed information:
+# https://www.kernel.org/doc/html/latest/networking/af_xdp.html
+#
+# Prerequisites setup by script test_xsk_prerequisites.sh:
+#
+#   Set up veth interfaces as per the topology shown ^^:
+#   * setup two veth interfaces and one namespace
+#   ** veth<xxxx> in root namespace
+#   ** veth<yyyy> in af_xdp<xxxx> namespace
+#   ** namespace af_xdp<xxxx>
+#   * create a spec file veth.spec that includes this run-time configuration
+#     that is read by test scripts - filenames prefixed with test_xsk_
+#   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
+#       conflict with any existing interface
+#   * tests the veth and xsk layers of the topology
+#
+# Kernel configuration:
+# ---------------------
+# See "config" file for recommended kernel config options.
+#
+# Turn on XDP sockets and veth support when compiling i.e.
+# 	Networking support -->
+# 		Networking options -->
+# 			[ * ] XDP sockets
+#
+# Executing Tests:
+# ----------------
+# Must run with CAP_NET_ADMIN capability.
+#
+# Run (summary only):
+#  sudo make summary=1 run_tests
+#
+# Run (full color-coded output):
+#   sudo make colorconsole=1 run_tests
+#
+# Run (full output without color-coding):
+#   sudo make run_tests
+#
+# Clean:
+#  sudo make clean
+
+. xsk_prereqs.sh
+
+TEST_NAME="PREREQUISITES"
+
+URANDOM=/dev/urandom
+[ ! -e "${URANDOM}" ] && { echo "${URANDOM} not found. Skipping tests."; test_exit 1 1; }
+
+VETH0_POSTFIX=$(cat ${URANDOM} | tr -dc '0-9' | fold -w 256 | head -n 1 | head --bytes 4)
+VETH0=ve${VETH0_POSTFIX}
+VETH1_POSTFIX=$(cat ${URANDOM} | tr -dc '0-9' | fold -w 256 | head -n 1 | head --bytes 4)
+VETH1=ve${VETH1_POSTFIX}
+NS1=af_xdp${VETH1_POSTFIX}
+IPADDR_VETH0=192.168.222.1/30
+IPADDR_VETH1=192.168.222.2/30
+MTU=1500
+
+setup_vethPairs() {
+	echo "setting up ${VETH0}: root: ${IPADDR_VETH0}"
+	ip netns add ${NS1}
+	ip link add ${VETH0} type veth peer name ${VETH1}
+	ip addr add dev ${VETH0} ${IPADDR_VETH0}
+	echo "setting up ${VETH1}: ${NS1}: ${IPADDR_VETH1}"
+	ip link set ${VETH1} netns ${NS1}
+	ip netns exec ${NS1} ip addr add dev ${VETH1} ${IPADDR_VETH1}
+	ip netns exec ${NS1} ip link set ${VETH1} mtu ${MTU}
+	ip netns exec ${NS1} ip link set ${VETH1} up
+	ip link set ${VETH0} mtu ${MTU}
+	ip link set ${VETH0} up
+}
+
+validate_root_exec
+validate_veth_support ${VETH0}
+validate_configs
+setup_vethPairs
+
+retval=$?
+if [ $retval -ne 0 ]; then
+	test_status $retval "${TEST_NAME}"
+	cleanup_exit ${VETH0} ${VETH1} ${NS1}
+	exit $retval
+fi
+
+echo "${VETH0}:${VETH1},${NS1}" > ${SPECFILE}
+
+echo "Spec file created: ${SPECFILE}"
+
+test_status $retval "${TEST_NAME}"
+
+exit $retval
diff --git a/tools/testing/selftests/bpf/xsk_env.sh b/tools/testing/selftests/bpf/xsk_env.sh
new file mode 100755
index 000000000000..2c41b4284cae
--- /dev/null
+++ b/tools/testing/selftests/bpf/xsk_env.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. xsk_prereqs.sh
+
+validate_veth_spec_file
+
+VETH0=$(cat ${SPECFILE} | cut -d':' -f 1)
+VETH1=$(cat ${SPECFILE} | cut -d':' -f 2 | cut -d',' -f 1)
+NS1=$(cat ${SPECFILE} | cut -d':' -f 2 | cut -d',' -f 2)
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
new file mode 100755
index 000000000000..694c5f5ab5e3
--- /dev/null
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -0,0 +1,119 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+ksft_pass=0
+ksft_fail=1
+ksft_xfail=2
+ksft_xpass=3
+ksft_skip=4
+
+GREEN='\033[0;92m'
+YELLOW='\033[0;93m'
+RED='\033[0;31m'
+NC='\033[0m'
+STACK_LIM=131072
+SPECFILE=veth.spec
+
+validate_root_exec()
+{
+	msg="skip all tests:"
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		test_exit $ksft_fail 2
+	else
+		return $ksft_pass
+	fi
+}
+
+validate_veth_support()
+{
+	msg="skip all tests:"
+	if [ $(ip link add $1 type veth 2>/dev/null; echo $?;) != 0 ]; then
+		echo $msg veth kernel support not available >&2
+		test_exit $ksft_skip 1
+	else
+		ip link del $1
+		return $ksft_pass
+	fi
+}
+
+validate_veth_spec_file()
+{
+	if [ ! -f ${SPECFILE} ]; then
+		test_exit $ksft_skip 1
+	fi
+}
+
+test_status()
+{
+	statusval=$1
+	if [ -n "${colorconsole+set}" ]; then
+		if [ $statusval -eq 2 ]; then
+			echo -e "${YELLOW}$2${NC}: [ ${RED}FAIL${NC} ]"
+		elif [ $statusval -eq 1 ]; then
+			echo -e "${YELLOW}$2${NC}: [ ${RED}SKIPPED${NC} ]"
+		elif [ $statusval -eq 0 ]; then
+			echo -e "${YELLOW}$2${NC}: [ ${GREEN}PASS${NC} ]"
+		fi
+	else
+		if [ $statusval -eq 2 ]; then
+			echo -e "$2: [ FAIL ]"
+		elif [ $statusval -eq 1 ]; then
+			echo -e "$2: [ SKIPPED ]"
+		elif [ $statusval -eq 0 ]; then
+			echo -e "$2: [ PASS ]"
+		fi
+	fi
+}
+
+test_exit()
+{
+	retval=$1
+	if [ $2 -ne 0 ]; then
+		test_status $2 $(basename $0)
+	fi
+	exit $retval
+}
+
+clear_configs()
+{
+	if [ $(ip netns show | grep $3 &>/dev/null; echo $?;) == 0 ]; then
+		[ $(ip netns exec $3 ip link show $2 &>/dev/null; echo $?;) == 0 ] &&
+			{ echo "removing link $2"; ip netns exec $3 ip link del $2; }
+		echo "removing ns $3"
+		ip netns del $3
+	fi
+	#Once we delete a veth pair node, the entire veth pair is removed,
+	#this is just to be cautious just incase the NS does not exist then
+	#veth node inside NS won't get removed so we explicitly remove it
+	[ $(ip link show $1 &>/dev/null; echo $?;) == 0 ] &&
+		{ echo "removing link $1"; ip link del $1; }
+	if [ -f ${SPECFILE} ]; then
+		echo "removing spec file:" ${SPECFILE}
+		rm -f ${SPECFILE}
+	fi
+}
+
+cleanup_exit()
+{
+	echo "cleaning up..."
+	clear_configs $1 $2 $3
+}
+
+validate_configs()
+{
+	[ ! $(type -P ip) ] && { echo "'ip' not found. Skipping tests."; test_exit $ksft_skip 1; }
+}
+
+vethXDPgeneric()
+{
+	ip link set dev $1 xdpdrv off
+	ip netns exec $3 ip link set dev $2 xdpdrv off
+}
+
+vethXDPnative()
+{
+	ip link set dev $1 xdpgeneric off
+	ip netns exec $3 ip link set dev $2 xdpgeneric off
+}
-- 
2.20.1

