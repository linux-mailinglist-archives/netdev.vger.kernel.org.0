Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7096F3386
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjEAQZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 12:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjEAQZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 12:25:56 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2C610C8;
        Mon,  1 May 2023 09:25:55 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 87E505C00F3;
        Mon,  1 May 2023 12:25:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 01 May 2023 12:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1682958354; x=
        1683044754; bh=cvplEnShbwb1Rkb4fLE1QUu5yhWBseBlVRLabGxQK3c=; b=D
        +5BgZSOfs6kUa42LTz4z2KJP5t10/yEP6/v+tEOGrCqhIz59nrrSDiJ9GMLXZo/R
        DyEutnf4tOfw9FFXIL/yu2SDmBZqPQ7nfp1bp+TBLm21UrP4pFirYiAJoZrNRfwz
        a+D9jqoowjM31pTEEM9ez950niXQvtGkLSrKSZ/bKvsDI+zni2k1PCYeL+Oz/62C
        Z7u6YeOjmDwhJVQCFBRXob3TJBvORb662riZrMmHmBA9N0wHKWYHIJTI8lfCLqIu
        Gony7g9f8CGiwjLmHyJhv8E4Q7L1jJm9yof5YQyV2tlMIEsKjcvfgy7mfKHZfb0Y
        mbQ5GK5GS7hIXnEr0T75g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1682958354; x=
        1683044754; bh=cvplEnShbwb1Rkb4fLE1QUu5yhWBseBlVRLabGxQK3c=; b=R
        H66ECGpHnr7D5I2VCfgksrqvuNoI2kEcYQ/xPNlsTR9qMCuyYg6LMTOqZQVMAZ9a
        9wKPgAIJc4YPnThZePaS5GIa5y1V6nCC4WS6UIWxGIZFEOozrI3S6dwvV2RXV5YB
        T/NeQ/t/zULBo8OsT1KU/AlJSWouwYaojc3+FU/yhKczYXK3y2qnQ7mYhwulIOmu
        4gnbQJIB9J9F5Gek5OoKAlW5JdNHvkkA15hvdmPEP+kTjR7rb6dv4aDiFkRM+LUC
        21v+TDVueVHpcvDW6PXmn03Ucgn5Wrr3a+rG41WgjllF4TKQh6Mu7KfzVTY5LQET
        IG3Kr9GsVBF9w2pN24V5A==
X-ME-Sender: <xms:EuhPZHby45pehPdYpn2hA_muUbnXZTYAvROFG4rau6yNHQvV7FmnhQ>
    <xme:EuhPZGZcot_6uPiergaJHAL9Z_VBKLsmX6ia2ShxhQgvfWw_1andishJhDCVElxFB
    dro2xg_l5r_zyfClj0>
X-ME-Received: <xmr:EuhPZJ9TjbAB9TFiW3hNZwitHmsXt30ZaYfZ7E6sTpLGPHVD2kA4WhAlGejGBE60L_bBY5wy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvgedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepgghlrgguihhmihhrucfp
    ihhkihhshhhkihhnuceovhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfieqnecugg
    ftrfgrthhtvghrnhepfeefgeefkedugfehkeevffdvleeiudelfedugeevtddvgfehveel
    ffeffeeiveffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepvhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:EuhPZNrgxGLp5IhLoF_FNuD0AhLCZ6h_d5yz0icXx5wIIv5AHeGFjg>
    <xmx:EuhPZCpdE4HDRRpKc_AnmWwyo90_xhOoDcNE9_jt2fwE1s0D2n0uKA>
    <xmx:EuhPZDQDkSpO4jH7sMzKUmvPwm810Y4Ok1LA5FvRPvY-WGf0dSn7ug>
    <xmx:EuhPZH4mywImD_pdqctMl2MGBr-RDkp8HCTFpUjDBhzqxfqeOAziKA>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 May 2023 12:25:50 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
        liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v7 2/2] Add tests for vxlan nolocalbypass option.
Date:   Tue,  2 May 2023 00:25:30 +0800
Message-Id: <20230501162530.26414-2-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
In-Reply-To: <20230501162530.26414-1-vladimir@nikishkin.pw>
References: <20230501162530.26414-1-vladimir@nikishkin.pw>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to make sure that the localbypass option is on by default.

Add test to change vxlan localbypass to nolocalbypass and check
that packets are delivered to userspace.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/test_vxlan_nolocalbypass.sh | 234 ++++++++++++++++++
 2 files changed, 235 insertions(+)
 create mode 100755 tools/testing/selftests/net/test_vxlan_nolocalbypass.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index c12df57d5539..7f3ab2a93ed6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -84,6 +84,7 @@ TEST_GEN_FILES += ip_local_port_range
 TEST_GEN_FILES += bind_wildcard
 TEST_PROGS += test_vxlan_mdb.sh
 TEST_PROGS += test_bridge_neigh_suppress.sh
+TEST_PROGS += test_vxlan_nolocalbypass.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
new file mode 100755
index 000000000000..d8e48ab1e7e0
--- /dev/null
+++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
@@ -0,0 +1,234 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This file is testing that the [no]localbypass option for a vxlan device is
+# working. With the nolocalbypass option, packets to a local destination, which
+# have no corresponding vxlan in the kernel, will be delivered to userspace, for
+# any userspace process to process. In this test tcpdump plays the role of such a
+# process. This is what the test 1 is checking.
+# The test 2 checks that without the nolocalbypass (which is equivalent to the
+# localbypass option), the packets do not reach userspace.
+
+EXIT_SUCCESS=0
+EXIT_FAIL=1
+ksft_skip=4
+nsuccess=0
+nfail=0
+
+ret=0
+
+TESTS="
+changelink_nolocalbypass_simple
+"
+VERBOSE=0
+PAUSE_ON_FAIL=no
+PAUSE=no
+
+
+NETNS_NAME=vxlan_nolocalbypass_test
+
+################################################################################
+# Utilities
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "$VERBOSE" = "1" ]; then
+			echo "    rc=$rc, expected $expected"
+		fi
+
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+		echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	if [ "${PAUSE}" = "yes" ]; then
+		echo
+		echo "hit enter to continue, 'q' to quit"
+		read a
+		[ "$a" = "q" ] && exit 1
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+}
+
+run_cmd()
+{
+	local cmd="$1"
+	local out
+	local stderr="2>/dev/null"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "COMMAND: $cmd\n"
+		stderr=
+	fi
+
+	out=$(eval $cmd $stderr)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "    $out"
+	fi
+
+	return $rc
+}
+
+socat_check_packets()
+{
+  echo TODO
+  exit 1
+}
+
+################################################################################
+# Setup
+
+setup()
+{
+  ip netns add "$NETNS_NAME"
+  ip -n "$NETNS_NAME" link set up lo
+  ip -n "$NETNS_NAME" addr add 127.0.0.1 dev lo
+}
+
+cleanup()
+{
+  ip netns del "$NETNS_NAME"
+}
+
+
+################################################################################
+# Tests
+
+changelink_nolocalbypass_simple()
+{
+  # test 1: by default, packets are dropped
+
+  run_cmd "ip -n $NETNS_NAME link add testvxlan0 type vxlan  \
+     id 100 \
+     dstport 4789 \
+     srcport 4789 4790 \
+     nolearning noproxy"
+  log_test $? 0 "Create vxlan with localbypass by default"
+  run_cmd "ip -n $NETNS_NAME link set up dev testvxlan0"
+  log_test $? 0 "Bring up vxlan device"
+  run_cmd "bridge -n $NETNS_NAME fdb add 00:00:00:00:00:00 dev testvxlan0 dst 127.0.0.1 port 4792"
+  log_test $? 0 "Add the most general fdb entry"
+  run_cmd "ip -n $NETNS_NAME address add 172.16.100.1/24 dev testvxlan0"
+
+  local tmp_file="$(mktemp)"
+  ip netns exec $NETNS_NAME socat UDP4-LISTEN:4792,fork "$tmp_file" &
+
+  run_cmd "ip netns exec $NETNS_NAME timeout 3 ping  172.16.100.2"
+
+  l_size=$(stat -c '%s' "$tmp_file" | tr -d '\n')
+  log_test $l_size 0 "    Packets dropped by default."
+
+  { kill %% && wait %%; } 2>/dev/null
+  rm -rf "$tmp_file"
+  touch "$tmp_file"
+  # test 2: nolocalbypass works
+
+  run_cmd "ip -n $NETNS_NAME link set testvxlan0 type vxlan nolocalbypass"
+
+  ip netns exec $NETNS_NAME socat UDP4-LISTEN:4792,fork "$tmp_file" &
+  sleep 1
+  run_cmd "ip netns exec $NETNS_NAME timeout 3 ping 172.16.100.2"
+
+  l_size=$(stat -c '%s' "$tmp_file" | tr -d '\n')
+  if [[ "$l_size" != 0 ]] ; then
+    log_test 1 1 "    Packets dropped by default."
+  else
+    log_test 0 1 "    Packets dropped by default."
+  fi
+
+  run_cmd "ip -n $NETNS_NAME link del dev testvxlan0 1>/dev/null 2>&1"
+
+  { kill %% && wait %%; } 2>/dev/null
+  rm -rf "$tmp_file"
+
+}
+
+################################################################################
+# Usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+        -p          Pause on fail
+        -P          Pause after each test before cleanup
+        -v          Verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
+# Main
+
+trap cleanup EXIT
+
+while getopts ":t:pPvh" opt; do
+	case $opt in
+		t) TESTS=$OPTARG ;;
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+# Make sure we don't pause twice.
+[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
+
+if [ "$(id -u)" -ne 0 ];then
+  echo "SKIP: Need root privileges"
+  exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+  echo "SKIP: Could not run test without ip tool"
+  exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v bridge)" ]; then
+  echo "SKIP: Could not run test without bridge tool"
+  exit $ksft_skip
+fi
+if [ ! -x "$(command -v socat)" ]; then
+  echo "socat command not found. Skipping test"
+  return 1
+fi
+
+ip link help vxlan 2>&1 | grep -q "localbypass"
+if [ $? -ne 0 ]; then
+   echo "SKIP: iproute2 ip too old, missing VXLAN nolocalbypass support"
+   exit $ksft_skip
+fi
+
+cleanup
+
+for t in $TESTS
+do
+	setup; $t; cleanup;
+done
+
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
+exit $ret
-- 
2.35.7

--
Fastmail.

