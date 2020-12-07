Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132132D1C6E
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgLGVyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLGVyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:54:45 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA56DC061793;
        Mon,  7 Dec 2020 13:54:04 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id k10so564150wmi.3;
        Mon, 07 Dec 2020 13:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnnTOJZ2HCrYH67G2KR83AyeJlYL24WdGDCLYwDpf6o=;
        b=Nmg9tBT8yFlgD/vBTjUMBXhnbtBYBONvnflrf4FhXgJlAUu1/LxGd82R1ELWso8mmu
         TqBfWGcIPYznlK6VcTBcLJqNH71ZgSnModHPvNNEyC+g6PtJscIHn7t8pRlDf27RLhb7
         5niBV/3aaJXr6xQZegwjQDnNbGKSIhIGlzoAsmBogSq48aiMQhoz3Z+jl0rm67p9q8Z9
         L1ck7J2d9ci4jiYSU3UnmbiK+8I/BYejNfHkJHndYmGp2n8df3i8ak7LCG03xRN5t+XK
         gidpNCpyyUMlwvlF4D+bQHoHJNpRtIbIPIu2cpi4b5pHWBasE8LlxgSyPY8uTYI6beiI
         rjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bnnTOJZ2HCrYH67G2KR83AyeJlYL24WdGDCLYwDpf6o=;
        b=FXBrat10pJjxfZUKQlfGNqtvlLI03OiLIwsbn3uWGuimddPePGH15WE3qzaxMCxQjN
         vDLz7cYWSjTejy7b0t7pogYpuhb54z6s1b93N+OvFKJ0attZKNxKvAnGuCcq261siGzU
         NTo2CPw/gOJVHm++k21fAJZvQMGMxUGyRSDNbsRosSIMAwCb9ZPlexpN/UxFAb5fvrEC
         iBYJOGkYQFEDIohGpbOinNZHKKLq1dqCrZCljlbsUdpKPBGRHKd3CqltTyYUNsD/drLq
         8bSo5PstmYQJkOJPvcjMqzpO4k0COxs5dPZlzbxl84RfOYxLaVyfPyGnLjuoEU4lDyVs
         EQmw==
X-Gm-Message-State: AOAM5315P4MLlibsP6PvgLHd1OZ83Y6G2WtLo06QmJugqmy5hVPoZBu4
        VlvxOgDAEGVFOFnWWLBfQmOU7oAe41QxC1e3
X-Google-Smtp-Source: ABdhPJye2munsdUo1UdQPO8ht0DUtq5g2rL3hkHQ/fGxitA2ajL6SyGOGi7IdoO/M9uDksHhR5bCow==
X-Received: by 2002:a1c:5459:: with SMTP id p25mr821891wmi.19.1607378042749;
        Mon, 07 Dec 2020 13:54:02 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id z15sm1967290wrv.67.2020.12.07.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:54:02 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v4 1/5] selftests/bpf: xsk selftests framework
Date:   Mon,  7 Dec 2020 21:53:29 +0000
Message-Id: <20201207215333.11586-2-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds AF_XDP selftests framework under selftests/bpf.

Topology:
---------
     -----------           -----------
     |  xskX   | --------- |  xskY   |
     -----------     |     -----------
          |          |          |
     -----------     |     ----------
     |  vethX  | --------- |  vethY |
     -----------   peer    ----------
          |          |          |
     namespaceX      |     namespaceY

Prerequisites setup by script test_xsk.sh:

   Set up veth interfaces as per the topology shown ^^:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
       conflict with any existing interface
   * tests the veth and xsk layers of the topology

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/Makefile       |   4 +-
 tools/testing/selftests/bpf/test_xsk.sh    | 152 +++++++++++++++++++++
 tools/testing/selftests/bpf/xsk_prereqs.sh | 119 ++++++++++++++++
 3 files changed, 274 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ac25ba5d0d6c..6a1ddfe68f15 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -46,7 +46,8 @@ endif
 
 TEST_GEN_FILES =
 TEST_FILES = test_lwt_ip_encap.o \
-	test_tc_edt.o
+	test_tc_edt.o \
+	xsk_prereqs.sh
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
@@ -70,6 +71,7 @@ TEST_PROGS := test_kmod.sh \
 	test_bpftool_build.sh \
 	test_bpftool.sh \
 	test_bpftool_metadata.sh \
+	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
new file mode 100755
index 000000000000..cae4c5574c4c
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -0,0 +1,152 @@
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
+# Prerequisites setup by script:
+#
+#   Set up veth interfaces as per the topology shown ^^:
+#   * setup two veth interfaces and one namespace
+#   ** veth<xxxx> in root namespace
+#   ** veth<yyyy> in af_xdp<xxxx> namespace
+#   ** namespace af_xdp<xxxx>
+#   * create a spec file veth.spec that includes this run-time configuration
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
+# Run (full color-coded output):
+#   sudo ./test_xsk.sh -c
+#
+# If running from kselftests:
+#   sudo make colorconsole=1 run_tests
+#
+# Run (full output without color-coding):
+#   sudo ./test_xsk.sh
+
+. xsk_prereqs.sh
+
+while getopts c flag
+do
+	case "${flag}" in
+		c) colorconsole=1;;
+	esac
+done
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
+NS0=root
+NS1=af_xdp${VETH1_POSTFIX}
+MTU=1500
+
+setup_vethPairs() {
+	echo "setting up ${VETH0}: namespace: ${NS0}"
+	ip netns add ${NS1}
+	ip link add ${VETH0} type veth peer name ${VETH1}
+	if [ -f /proc/net/if_inet6 ]; then
+		echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
+	fi
+	echo "setting up ${VETH1}: namespace: ${NS1}"
+	ip link set ${VETH1} netns ${NS1}
+	ip netns exec ${NS1} ip link set ${VETH1} mtu ${MTU}
+	ip link set ${VETH0} mtu ${MTU}
+	ip netns exec ${NS1} ip link set ${VETH1} up
+	ip link set ${VETH0} up
+}
+
+validate_root_exec
+validate_veth_support ${VETH0}
+validate_ip_utility
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
+validate_veth_spec_file
+
+echo "Spec file created: ${SPECFILE}"
+
+test_status $retval "${TEST_NAME}"
+
+## START TESTS
+
+statusList=()
+
+### TEST 1
+TEST_NAME="XSK KSELFTEST FRAMEWORK"
+
+echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Generic mode"
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+retval=$?
+if [ $retval -eq 0 ]; then
+	echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Native mode"
+	vethXDPnative ${VETH0} ${VETH1} ${NS1}
+fi
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+## END TESTS
+
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+for _status in "${statusList[@]}"
+do
+	if [ $_status -ne 0 ]; then
+		test_exit $ksft_fail 0
+	fi
+done
+
+test_exit $ksft_pass 0
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
new file mode 100755
index 000000000000..29762739c21b
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
+			{ echo "removing link $1:$2"; ip netns exec $3 ip link del $2; }
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
+validate_ip_utility()
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

