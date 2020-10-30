Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467342A052C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgJ3MOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3MOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:14:37 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F13C0613D2;
        Fri, 30 Oct 2020 05:14:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i16so810574wrv.1;
        Fri, 30 Oct 2020 05:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rUFViTUnY+kgYImFFGX/ElRXc1tRT3Fz4yeUpO6dpm8=;
        b=eD7q7WNCJwZDteaNeRC0DIwsweHyqHcGhqj4ou3o7ChzlLFIF+44wuZ8wB7g+ynIzW
         cg/SH96s7CWXXLbN6EMBjYk40lTLN5RvYnbkjV3SFPPUuT1iUKlOoF07ZGwzhm03WFFA
         EQe3QazWtNAMY+DoGrQCVatoz9tyYQuAYYbtoJ/zny16Ilf8qzUGLtcJwDpfQJYoGnwL
         Q1sSn2fFl7FicY5O8WP/ucLm1WDU22oqfdstlv7+49bXKfsaxi76DRO8vmpJgxnaVQ+q
         DIbYmE1/Wa6+2+M3rIokXjZr+jk0XkfNusdkUCgsbVwLUzzlTtNEG0sIeYr0kLUbIFkA
         wGiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rUFViTUnY+kgYImFFGX/ElRXc1tRT3Fz4yeUpO6dpm8=;
        b=eCl7EYeF16ND2XDHFrXEiqhBIeAtoVYZQWiY2SyqfH5W8au7K9n3QloikZsaHKXIk2
         MIVuQJfwsI+CA7d/R4ymiXd2Q+aPQyHgIcti6jBRZug95lXzAg0EqA8KK2Z6hwG94ks/
         IVGa2IRnRfDtgOQCS/vlYwrpwZrME+KzIdaV/Mo9TMwXoaHElfLG9vwF/4tzz+jvCOOH
         Y5yEFs3eoNVsrKECw0jT6rMOkfNN81/nzV29Xp44MS0xaH+BQddtfZGdNjxYuJZwarlP
         pxcOKoKrw3IO7dbpBSNUJ8g9ON8BwRjcwY19xWWDu2fW0eDM8Ak5C0W66i5mgcsPV3Jk
         LRdg==
X-Gm-Message-State: AOAM531wDjnAGjxQy2kPi/PXbXaxqyDfZlXwjRWv7apytSj6N4yAKVVp
        Swz6deEUnXiiU4+AF+1FdCsWC9hmPJjJUCkilk0=
X-Google-Smtp-Source: ABdhPJzxJbfPPlECdxc672x63KmTeRs0JMKEC7HxIKbkT92hUID98JsqTTD52jrVrtfpNLux6hhTiw==
X-Received: by 2002:a5d:61c9:: with SMTP id q9mr2791022wrv.395.1604060075004;
        Fri, 30 Oct 2020 05:14:35 -0700 (PDT)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id 90sm10020925wrh.35.2020.10.30.05.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 05:14:34 -0700 (PDT)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 1/5] selftests/xsk: xsk selftests framework
Date:   Fri, 30 Oct 2020 12:13:43 +0000
Message-Id: <20201030121347.26984-2-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
References: <20201030121347.26984-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds AF_XDP selftests framework under selftests/xsk.

Prerequisites setup by script TEST_PREREQUISITES.sh:

   Set up veth interfaces as per the topology shown in README:
   * setup two veth interfaces and one namespace
   ** veth<xxxx> in root namespace
   ** veth<yyyy> in af_xdp<xxxx> namespace
   ** namespace af_xdp<xxxx>
   * create a spec file veth.spec that includes this run-time configuration
     that is read by test scripts - filenames prefixed with TEST_XSK
   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
       conflict with any existing interface

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/xsk/Makefile          |  10 ++
 tools/testing/selftests/xsk/README            |  72 +++++++++++
 .../selftests/xsk/TEST_PREREQUISITES.sh       |  53 ++++++++
 tools/testing/selftests/xsk/TEST_XSK.sh       |  15 +++
 tools/testing/selftests/xsk/config            |   1 +
 tools/testing/selftests/xsk/prereqs.sh        | 119 ++++++++++++++++++
 tools/testing/selftests/xsk/xskenv.sh         |  33 +++++
 9 files changed, 305 insertions(+)
 create mode 100644 tools/testing/selftests/xsk/Makefile
 create mode 100644 tools/testing/selftests/xsk/README
 create mode 100755 tools/testing/selftests/xsk/TEST_PREREQUISITES.sh
 create mode 100755 tools/testing/selftests/xsk/TEST_XSK.sh
 create mode 100644 tools/testing/selftests/xsk/config
 create mode 100755 tools/testing/selftests/xsk/prereqs.sh
 create mode 100755 tools/testing/selftests/xsk/xskenv.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index f281f8077de0..41c214375f9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19127,6 +19127,7 @@ F:	include/uapi/linux/if_xdp.h
 F:	net/xdp/
 F:	samples/bpf/xdpsock*
 F:	tools/lib/bpf/xsk*
+F:	tools/testing/selftests/xsk/
 
 XEN BLOCK SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index d9c283503159..d9b1f7d4313b 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -67,6 +67,7 @@ TARGETS += tpm2
 TARGETS += user
 TARGETS += vm
 TARGETS += x86
+TARGETS += xsk
 TARGETS += zram
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
diff --git a/tools/testing/selftests/xsk/Makefile b/tools/testing/selftests/xsk/Makefile
new file mode 100644
index 000000000000..6e0d657bc5e0
--- /dev/null
+++ b/tools/testing/selftests/xsk/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+TEST_PROGS := TEST_PREREQUISITES.sh \
+	TEST_XSK.sh
+TEST_FILES := prereqs.sh xskenv.sh
+TEST_TRANSIENT_FILES := veth.spec
+
+KSFT_KHDR_INSTALL := 1
+include ../lib.mk
diff --git a/tools/testing/selftests/xsk/README b/tools/testing/selftests/xsk/README
new file mode 100644
index 000000000000..a255b3050afc
--- /dev/null
+++ b/tools/testing/selftests/xsk/README
@@ -0,0 +1,72 @@
+Copyright (c) 2020 Intel Corporation, Weqaar Janjua <weqaar.a.janjua@intel.com>
+
+AF_XDP selftests based on veth
+
+# End-to-end AF_XDP over Veth test
+#
+# Topology:
+# ---------
+#                 -----------
+#               _ | Process | _
+#              /  -----------  \
+#             /        |        \
+#            /         |         \
+#      -----------     |     -----------
+#      | Thread1 |     |     | Thread2 |
+#      -----------     |     -----------
+#           |          |          |
+#      -----------     |     -----------
+#      |  xskX   |     |     |  xskY   |
+#      -----------     |     -----------
+#           |          |          |
+#      -----------     |     ----------
+#      |  vethX  | --------- |  vethY |
+#      -----------   peer    ----------
+#           |          |          |
+#      namespaceX      |     namespaceY
+
+AF_XDP is an address family optimized for high performance packet processing,
+it is XDP’s user-space interface.
+
+An AF_XDP socket is linked to a single UMEM which is a region of virtual
+contiguous memory, divided into equal-sized frames.
+
+Refer to AF_XDP Kernel Documentation for detailed information:
+https://www.kernel.org/doc/html/latest/networking/af_xdp.html
+
+Prerequisites setup by script TEST_PREREQUISITES.sh:
+
+   Set up veth interfaces as per the topology shown ^^:
+   * setup two veth interfaces and one namespace
+   ** veth<xxxx> in root namespace
+   ** veth<yyyy> in af_xdp<xxxx> namespace
+   ** namespace af_xdp<xxxx>
+   * create a spec file veth.spec that includes this run-time configuration
+     that is read by test scripts - filenames prefixed with TEST_XSK_
+   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
+       conflict with any existing interface
+
+Kernel configuration:
+---------------------
+See "config" file for recommended kernel config options.
+
+Turn on XDP sockets and veth support when compiling i.e.
+	Networking support -->
+		Networking options -->
+			[ * ] XDP sockets
+
+Executing Tests:
+----------------
+Must run with CAP_NET_ADMIN capability.
+
+Run (summary only):
+  sudo make summary=1 run_tests
+
+Run (full color-coded output):
+  sudo make colorconsole=1 run_tests
+
+Run (full output without color-coding):
+  sudo make run_tests
+
+Clean:
+  make clean
diff --git a/tools/testing/selftests/xsk/TEST_PREREQUISITES.sh b/tools/testing/selftests/xsk/TEST_PREREQUISITES.sh
new file mode 100755
index 000000000000..cd542dbaf7ac
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_PREREQUISITES.sh
@@ -0,0 +1,53 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
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
diff --git a/tools/testing/selftests/xsk/TEST_XSK.sh b/tools/testing/selftests/xsk/TEST_XSK.sh
new file mode 100755
index 000000000000..ad31b3e38b8f
--- /dev/null
+++ b/tools/testing/selftests/xsk/TEST_XSK.sh
@@ -0,0 +1,15 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+. xskenv.sh
+
+TEST_NAME="XSK FRAMEWORK"
+
+test_status $ksft_pass "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $ksft_pass 0
diff --git a/tools/testing/selftests/xsk/config b/tools/testing/selftests/xsk/config
new file mode 100644
index 000000000000..80311f71266d
--- /dev/null
+++ b/tools/testing/selftests/xsk/config
@@ -0,0 +1 @@
+CONFIG_VETH=m
diff --git a/tools/testing/selftests/xsk/prereqs.sh b/tools/testing/selftests/xsk/prereqs.sh
new file mode 100755
index 000000000000..4c20aec45d99
--- /dev/null
+++ b/tools/testing/selftests/xsk/prereqs.sh
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
+			echo -e "${YELLOW}$2${NC}: ${RED}FAIL${NC}"
+		elif [ $statusval -eq 1 ]; then
+			echo -e "${YELLOW}$2${NC}: ${RED}SKIPPED${NC}"
+		elif [ $statusval -eq 0 ]; then
+			echo -e "${YELLOW}$2${NC}: ${GREEN}PASS${NC}"
+		fi
+	else
+		if [ $statusval -eq 2 ]; then
+			echo -e "$2: FAIL"
+		elif [ $statusval -eq 1 ]; then
+			echo -e "$2: SKIPPED"
+		elif [ $statusval -eq 0 ]; then
+			echo -e "$2: PASS"
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
+		echo "removing spec file:" veth.spec
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
diff --git a/tools/testing/selftests/xsk/xskenv.sh b/tools/testing/selftests/xsk/xskenv.sh
new file mode 100755
index 000000000000..afc10bbdfb50
--- /dev/null
+++ b/tools/testing/selftests/xsk/xskenv.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+. prereqs.sh
+
+XSKDIR=xdpprogs
+XSKOBJ=xdpxceiver
+NUMPKTS=10000
+
+validate_veth_spec_file
+
+VETH0=$(cat ${SPECFILE} | cut -d':' -f 1)
+VETH1=$(cat ${SPECFILE} | cut -d':' -f 2 | cut -d',' -f 1)
+NS1=$(cat ${SPECFILE} | cut -d':' -f 2 | cut -d',' -f 2)
+
+execxdpxceiver()
+{
+	local -a 'paramkeys=("${!'"$1"'[@]}")' copy
+	paramkeysstr=${paramkeys[*]}
+
+	for index in $paramkeysstr;
+		do
+			current=$1"[$index]"
+			copy[$index]=${!current}
+		done
+
+	if [ -f ./${XSKOBJ} ]; then
+		./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS}
+	else
+		./${XSKDIR}/${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS}
+	fi
+}
-- 
2.20.1

