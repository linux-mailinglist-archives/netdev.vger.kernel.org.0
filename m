Return-Path: <netdev+bounces-2013-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 373696FFF62
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD0251C21133
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9A3A48;
	Fri, 12 May 2023 03:41:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E375A45
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:41:01 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C624249F3;
	Thu, 11 May 2023 20:40:59 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 3C2595C0F2C;
	Thu, 11 May 2023 23:40:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 11 May 2023 23:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to; s=fm3; t=1683862859; x=
	1683949259; bh=B2sFtVstqv/o2yKpRLJbmwPgh/VymjMjecMI6BJzJdE=; b=C
	9bTDpBhoW4CVJT+vfMUfrr9YzPStsbPpeLpp7qhFkcvfrNDvcRdUyaCJHTaXWYKv
	S3dKCKkROFsbcc2q9IDhE9LMGzvFkbW2ow0+UwIx4RW5fMWPf6d7Zmvd5B+jNFo4
	SQudnkPw1LzsRCK+T9ddr6isGnXpGGHMVCZ39n3D9eQtobkti4Oxcag7vz1VkDuo
	sqppX5xRTIUj9SaU5lSNgPeXKeoWyX5xv4LY0VUqH2pZsrhp88w0n336PF8abumI
	+kszbVoVAiiEA72oUnjSmN1rai41q9NF58lc3YSSL1C5RjVd3NibDX1J5a6LAT/2
	QTN4rSDTPJ2QyxJROZUWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1683862859; x=
	1683949259; bh=B2sFtVstqv/o2yKpRLJbmwPgh/VymjMjecMI6BJzJdE=; b=c
	zlglPUjYNEWq/T5dK3DSFbYBZ8PMM7JY4XUWaqnf6VdzM4s2AvPDlUFAfscsKH2V
	vplvZK+frEhjdA1NlhAYforfzuLpj+MblQTPJNnbor9GfWD4OhtsaJleKUDhMsTa
	Ldk6+PaitTFEU0/uT5Iuq9/Kt9EqU6RcsUyjBRN2b4s9E6w0Z9Y0016EhkreA5HR
	ckvfwSOR4+QH0LhPyxlYkI1UMdkzvHDrJoRFJs5h6lYbzxLBWoA2j+k8RKHp54fR
	j0LITVFLz0qQ2UHOY9+TV4BK4BwH04lyBCmB7BGhJS670Ei1CCoyDjTEoAphmdL3
	yZVMUqVC+5Y2aFIqiT4sQ==
X-ME-Sender: <xms:S7VdZE2_3TUYxKOCra87ADq9kMsJU1r5WLGppdJHoqtaai68_fjcyw>
    <xme:S7VdZPG9O5Lq_PwqiLbSeZIHoWKf57Es4na3uDqWh-4FUQIdw9Q5inQV-9sT0xJGt
    DoHX3jXWWfVQQruSUg>
X-ME-Received: <xmr:S7VdZM69ov_SJaq5-Q2w0xKQdMPDoZnxo8y5pxKufEKm3MgZ6y-xCVPbFdzzoFr5XQa863zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegledgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhi
    khhishhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtf
    frrghtthgvrhhnpeekgffgudeigefhgefftdetheejtdejveekiedvfeejgefhhefggfel
    ueeivdevgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhrvghvihgvfigvugdqsg
    ihrdhtohholhhsnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepvhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:S7VdZN1QnfEV0B2TNzlYS9qXNkvyHfRh_xSIlUwCUfGTyXFpMNRkHw>
    <xmx:S7VdZHHAoaRNbNS_U6EwaIuqs5vixxGHid5id08akFxkgMdFgDdBpg>
    <xmx:S7VdZG8S11L2A1Z018IXGKQhcBxA7y3r_MyLyEQRiH1Sz_sI2NmjJQ>
    <xmx:S7VdZHFmmVc2etFKr4R3v3vosvIjd6nGU3cThOSUNlYJ2r3a5MlrMA>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 May 2023 23:40:54 -0400 (EDT)
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
Subject: [PATCH net-next v9 2/2] selftests: net: vxlan: Add tests for vxlan nolocalbypass option.
Date: Fri, 12 May 2023 11:40:34 +0800
Message-Id: <20230512034034.16778-2-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20230512034034.16778-1-vladimir@nikishkin.pw>
References: <20230512034034.16778-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add test to make sure that the localbypass option is on by default.

Add test to change vxlan localbypass to nolocalbypass and check
that packets are delivered to userspace.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v8=>v9
1. Update "summary phrase" to include net:  as suggested by
https://patchwork.kernel.org/project/netdevbpf/patch/20230510200247.1534793-1-u.kleine-koenig@pengutronix.de/
2. Add reviewer's reviewed-by.

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


