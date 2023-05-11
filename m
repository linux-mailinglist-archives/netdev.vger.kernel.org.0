Return-Path: <netdev+bounces-1658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 339FB6FEA25
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E34BF281642
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE43117749;
	Thu, 11 May 2023 03:22:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9661773C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:22:37 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86B81703;
	Wed, 10 May 2023 20:22:35 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id 5B851320010B;
	Wed, 10 May 2023 23:22:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 10 May 2023 23:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to; s=fm3; t=1683775353; x=
	1683861753; bh=h6Kn4t/nVUikNAo/2Tb4eNstPscor6OoYV0/0PpUjlA=; b=i
	S+OiZK8pn8P3zlaIbbtc6HMjtM0z0OmVrJAZ5aRJmxvpTvpqw0amaSdfiOQq30SK
	02wJkJ/1msYOhe/JmV2rRP1nqFJP7EcZoQK0VA67+cxizI9FkN4x0q/k8KWA1jb3
	UXxPn56Quxhhx9Nm1grNlh+TBDZKHjRMlGaS2Vo6YYkl35T66AMzhpXUej8x+51u
	QCZQgy3LJzKEURqLjiMTuGt7hN7rlUkVoXqv9606cf/3CydtdErnq0IYBHqkndAJ
	1tL1JTGQUe8g41X7y57JX7064rY/X+4lK3Ay69RIrq7GgRuJwTIvmCzPutgLTpTP
	uNaQDoJiQwlxqYxPhy5DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1683775353; x=
	1683861753; bh=h6Kn4t/nVUikNAo/2Tb4eNstPscor6OoYV0/0PpUjlA=; b=D
	esOgYZ61l3Q6O0W4zjiLNc/d72iFAWETDPzo56baEFuPYdReLBEo6+KOgwB3jXEO
	t1zIgItxOB32BoHdFf5vU200iDkNtISDH2JWsnKalDulidoRoX/U0zmgRMfCW1bt
	pmlJTEWg4a7FQdYdnj0tvQE54OLjQeewTRuantJhWjZPlSjvfi0abvMVWnO9VnAg
	TJRb3+pCqYxML76w2EoPlXJZkpzEU92PD1erOe/ZDezVLIvk+vhCK85t6QqCxE8c
	vamUAGHLcQiH37XnWfVZcMFAGdhRK5uOfFVnhHlRp1LF9brJUqi/oNQ47EDE/IDk
	mWbhN6sqLfEO4AYKaZLXw==
X-ME-Sender: <xms:eV9cZOCzHarD3J1eQP_VUEkx8tmngqQXdEpzqLRBOPGLsWaiqT59OQ>
    <xme:eV9cZIjytnh3PnoBBbUVVJ_N5sjXzezGry7Z205qKRXUGnRZNRJVFZz6WZt_b6jHw
    qyM0TUkT3Ysawq09Ug>
X-ME-Received: <xmr:eV9cZBnMi0Ay2OiktjVWeBfMo5Lh48KlVwxe5jcXvg-0WkMnAG_8ofiqAaO4xXyTA6pKmDmJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegjedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhi
    khhishhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtf
    frrghtthgvrhhnpeeffeegfeekudfgheekveffvdelieduleefudegvedtvdfgheevleff
    feefieevffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:eV9cZMzI0y6OtjoH1uWpKfNop9wxXf4xNZqgTUAIGfnjf6rvGrvI9A>
    <xmx:eV9cZDSL53aj6THICfWiAGJhuHN5TV60X5HuINXT6sl-JWnGQfqL4Q>
    <xmx:eV9cZHaZfZRILiTLT4o10PXONeWzvn2vvoXkTMF88u4IKR-SaQ4p5A>
    <xmx:eV9cZBDEEroXSQ1wUwCWypMo7iD9rbv0MiD3W9r08-7TaLAq8hbS1Q>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 May 2023 23:22:29 -0400 (EDT)
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	liuhangbin@gmail.com,
	eyal.birger@gmail.com,
	jtoppins@redhat.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v8 2/2] selftests: vxlan: Add tests for vxlan nolocalbypass option.
Date: Thu, 11 May 2023 11:22:10 +0800
Message-Id: <20230511032210.9146-2-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20230511032210.9146-1-vladimir@nikishkin.pw>
References: <20230511032210.9146-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add test to make sure that the localbypass option is on by default.

Add test to change vxlan localbypass to nolocalbypass and check
that packets are delivered to userspace.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/test_vxlan_nolocalbypass.sh | 240 ++++++++++++++++++
 2 files changed, 241 insertions(+)
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
index 000000000000..46067db53068
--- /dev/null
+++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
@@ -0,0 +1,240 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test is for checking the [no]localbypass VXLAN device option. The test
+# configures two VXLAN devices in the same network namespace and a tc filter on
+# the loopback device that drops encapsulated packets. The test sends packets
+# from the first VXLAN device and verifies that by default these packets are
+# received by the second VXLAN device. The test then enables the nolocalbypass
+# option and verifies that packets are no longer received by the second VXLAN
+# device.
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TESTS="
+	nolocalbypass
+"
+VERBOSE=0
+PAUSE_ON_FAIL=no
+PAUSE=no
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
+tc_check_packets()
+{
+	local ns=$1; shift
+	local id=$1; shift
+	local handle=$1; shift
+	local count=$1; shift
+	local pkts
+
+	sleep 0.1
+	pkts=$(tc -n $ns -j -s filter show $id \
+		| jq ".[] | select(.options.handle == $handle) | \
+		.options.actions[0].stats.packets")
+	[[ $pkts == $count ]]
+}
+
+################################################################################
+# Setup
+
+setup()
+{
+	ip netns add ns1
+
+	ip -n ns1 link set dev lo up
+	ip -n ns1 address add 192.0.2.1/32 dev lo
+	ip -n ns1 address add 198.51.100.1/32 dev lo
+
+	ip -n ns1 link add name vx0 up type vxlan id 100 local 198.51.100.1 \
+		dstport 4789 nolearning
+	ip -n ns1 link add name vx1 up type vxlan id 100 dstport 4790
+}
+
+cleanup()
+{
+	ip netns del ns1 &> /dev/null
+}
+
+################################################################################
+# Tests
+
+nolocalbypass()
+{
+	local smac=00:01:02:03:04:05
+	local dmac=00:0a:0b:0c:0d:0e
+
+	run_cmd "bridge -n ns1 fdb add $dmac dev vx0 self static dst 192.0.2.1 port 4790"
+
+	run_cmd "tc -n ns1 qdisc add dev vx1 clsact"
+	run_cmd "tc -n ns1 filter add dev vx1 ingress pref 1 handle 101 proto all flower src_mac $smac dst_mac $dmac action pass"
+
+	run_cmd "tc -n ns1 qdisc add dev lo clsact"
+	run_cmd "tc -n ns1 filter add dev lo ingress pref 1 handle 101 proto ip flower ip_proto udp dst_port 4790 action drop"
+
+	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+	log_test $? 0 "localbypass enabled"
+
+	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
+
+	tc_check_packets "ns1" "dev vx1 ingress" 101 1
+	log_test $? 0 "Packet received by local VXLAN device - localbypass"
+
+	run_cmd "ip -n ns1 link set dev vx0 type vxlan nolocalbypass"
+
+	run_cmd "ip -n ns1 -d link show dev vx0 | grep 'nolocalbypass'"
+	log_test $? 0 "localbypass disabled"
+
+	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
+
+	tc_check_packets "ns1" "dev vx1 ingress" 101 1
+	log_test $? 0 "Packet not received by local VXLAN device - nolocalbypass"
+
+	run_cmd "ip -n ns1 link set dev vx0 type vxlan localbypass"
+
+	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
+	log_test $? 0 "localbypass enabled"
+
+	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"
+
+	tc_check_packets "ns1" "dev vx1 ingress" 101 2
+	log_test $? 0 "Packet received by local VXLAN device - localbypass"
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
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v bridge)" ]; then
+	echo "SKIP: Could not run test without bridge tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v mausezahn)" ]; then
+	echo "SKIP: Could not run test without mausezahn tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v jq)" ]; then
+	echo "SKIP: Could not run test without jq tool"
+	exit $ksft_skip
+fi
+
+ip link help vxlan 2>&1 | grep -q "localbypass"
+if [ $? -ne 0 ]; then
+	echo "SKIP: iproute2 ip too old, missing VXLAN nolocalbypass support"
+	exit $ksft_skip
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
2.35.8

--
Fastmail.


