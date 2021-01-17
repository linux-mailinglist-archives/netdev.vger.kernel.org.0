Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEF62F9174
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbhAQIJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:09:42 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:38553 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbhAQIFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:05:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0410D1850;
        Sun, 17 Jan 2021 03:03:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 17 Jan 2021 03:03:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=dGR1xxBGDZBcCuvob6sHIdoulN6qQtnMiwurCzVCh5U=; b=HYl3waA1
        XdSukq+cydbegyFIwlB1nOzqCSonPYBDqhB1iNbrrKKx785I4DJfZM10v5bRQJCC
        okXjoy9DsNFBS7eoZ3C3El6F3RKM3ODD4UG9PJzNVvgyK2dh+qFCbutbtv1edi7M
        djIas6buAkJXWLAfQOQqdv3H3sEbA3e24Bu6jKMZl6Wi2TuPA8E1zDy6o+fF7egM
        d32qhUQRDNn9TIbEart6akV8hR8KklA8sZ3/PCdyK0XJafEbDSqD/dciA4Te6qsr
        HvjtyCL5wYcnJaSA2p2ac7GetIsIiKAHdnTURZOd8YC0VGmYcs7MxwgZGa4cFMJ7
        FeLKB7BTAmsL2Q==
X-ME-Sender: <xms:Ne8DYOkPmK7anSzC4x3KGoR9MJd6XxA9KY1mBXxcU733LftLNTc8Bw>
    <xme:Ne8DYF04zPUK3YDuCQtq7EcKBm4tYJc3hodpH7bwdlK5nb049Sdno0ZsU5BXlUYN_
    MoMBBuMmR1S2Gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdehgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ne8DYMrls7Vr7Gk47E3lILv9OFTn2qPq7EP7CdAChx145d5098bkqA>
    <xmx:Ne8DYCm_J0Vnie99m47YgETKPs5hw9u1LUA7F0b4VlfVjQFBD5vKRQ>
    <xmx:Ne8DYM3-uisLy63CXmrrhqqsSUY4uvhZ0S7xggzu_mzEZI2ZcjqU_g>
    <xmx:Ne8DYPSKVT57Z18EDOUI5LDLJAW1ZxrQbpqvpAA7Bn-bkD3Gb35n8A>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F0BC24005C;
        Sun, 17 Jan 2021 03:02:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] selftests: mlxsw: RED: Add selftests for the mark qevent
Date:   Sun, 17 Jan 2021 10:02:23 +0200
Message-Id: <20210117080223.2107288-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117080223.2107288-1-idosch@idosch.org>
References: <20210117080223.2107288-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add do_mark_test(), which is to do_ecn_test() like do_drop_test() is to
do_red_test(): meant to test that actions on the RED mark qevent block are
offloaded, and executed on ECN-marked packets.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 82 +++++++++++++++++++
 .../drivers/net/mlxsw/sch_red_ets.sh          | 74 +++++++++++++++--
 2 files changed, 151 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index d439ee0eaa8a..6c2ddf76b4b8 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -544,6 +544,51 @@ do_mc_backlog_test()
 	log_test "TC $((vlan - 10)): Qdisc reports MC backlog"
 }
 
+do_mark_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local subtest=$1; shift
+	local fetch_counter=$1; shift
+	local should_fail=$1; shift
+	local base
+
+	RET=0
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) $h3_mac tos=0x01
+
+	# Create a bit of a backlog and observe no mirroring due to marks.
+	qevent_rule_install_$subtest
+
+	build_backlog $vlan $((2 * limit / 3)) tcp tos=0x01 >/dev/null
+
+	base=$($fetch_counter)
+	count=$(busywait 1100 until_counter_is ">= $((base + 1))" $fetch_counter)
+	check_fail $? "Spurious packets ($base -> $count) observed without buffer pressure"
+
+	# Above limit, everything should be mirrored, we should see lots of
+	# packets.
+	build_backlog $vlan $((3 * limit / 2)) tcp tos=0x01 >/dev/null
+	busywait_for_counter 1100 +10000 \
+		 $fetch_counter > /dev/null
+	check_err_fail "$should_fail" $? "ECN-marked packets $subtest'd"
+
+	# When the rule is uninstalled, there should be no mirroring.
+	qevent_rule_uninstall_$subtest
+	busywait_for_counter 1100 +10 \
+		 $fetch_counter > /dev/null
+	check_fail $? "Spurious packets observed after uninstall"
+
+	if ((should_fail)); then
+		log_test "TC $((vlan - 10)): marked packets not $subtest'd"
+	else
+		log_test "TC $((vlan - 10)): marked packets $subtest'd"
+	fi
+
+	stop_traffic
+	sleep 1
+}
+
 do_drop_test()
 {
 	local vlan=$1; shift
@@ -626,6 +671,22 @@ do_drop_mirror_test()
 	tc filter del dev $h2 ingress pref 1 handle 101 flower
 }
 
+do_mark_mirror_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+
+	tc filter add dev $h2 ingress pref 1 handle 101 prot ip \
+	   flower skip_sw ip_proto tcp \
+	   action drop
+
+	do_mark_test "$vlan" "$limit" mirror \
+		     qevent_counter_fetch_mirror \
+		     $(: should_fail=)0
+
+	tc filter del dev $h2 ingress pref 1 handle 101 flower
+}
+
 qevent_rule_install_trap()
 {
 	tc filter add block 10 pref 1234 handle 102 matchall skip_sw \
@@ -653,3 +714,24 @@ do_drop_trap_test()
 	do_drop_test "$vlan" "$limit" "$trap_name" trap \
 		     "qevent_counter_fetch_trap $trap_name"
 }
+
+do_mark_trap_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local should_fail=$1; shift
+
+	do_mark_test "$vlan" "$limit" trap \
+		     "qevent_counter_fetch_trap ecn_mark" \
+		     "$should_fail"
+}
+
+do_mark_trap_test_pass()
+{
+	do_mark_trap_test "$@" 0
+}
+
+do_mark_trap_test_fail()
+{
+	do_mark_trap_test "$@" 1
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 3f007c5f8361..566cad32f346 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -9,6 +9,8 @@ ALL_TESTS="
 	mc_backlog_test
 	red_mirror_test
 	red_trap_test
+	ecn_trap_test
+	ecn_mirror_test
 "
 : ${QDISC:=ets}
 source sch_red_core.sh
@@ -21,28 +23,60 @@ source sch_red_core.sh
 BACKLOG1=200000
 BACKLOG2=500000
 
-install_qdisc()
+install_root_qdisc()
 {
-	local -a args=("$@")
-
 	tc qdisc add dev $swp3 root handle 10: $QDISC \
 	   bands 8 priomap 7 6 5 4 3 2 1 0
+}
+
+install_qdisc_tc0()
+{
+	local -a args=("$@")
+
 	tc qdisc add dev $swp3 parent 10:8 handle 108: red \
 	   limit 1000000 min $BACKLOG1 max $((BACKLOG1 + 1)) \
 	   probability 1.0 avpkt 8000 burst 38 "${args[@]}"
+}
+
+install_qdisc_tc1()
+{
+	local -a args=("$@")
+
 	tc qdisc add dev $swp3 parent 10:7 handle 107: red \
 	   limit 1000000 min $BACKLOG2 max $((BACKLOG2 + 1)) \
 	   probability 1.0 avpkt 8000 burst 63 "${args[@]}"
+}
+
+install_qdisc()
+{
+	install_root_qdisc
+	install_qdisc_tc0 "$@"
+	install_qdisc_tc1 "$@"
 	sleep 1
 }
 
-uninstall_qdisc()
+uninstall_qdisc_tc0()
 {
-	tc qdisc del dev $swp3 parent 10:7
 	tc qdisc del dev $swp3 parent 10:8
+}
+
+uninstall_qdisc_tc1()
+{
+	tc qdisc del dev $swp3 parent 10:7
+}
+
+uninstall_root_qdisc()
+{
 	tc qdisc del dev $swp3 root
 }
 
+uninstall_qdisc()
+{
+	uninstall_qdisc_tc0
+	uninstall_qdisc_tc1
+	uninstall_root_qdisc
+}
+
 ecn_test()
 {
 	install_qdisc ecn
@@ -105,6 +139,36 @@ red_trap_test()
 	uninstall_qdisc
 }
 
+ecn_mirror_test()
+{
+	install_qdisc ecn qevent mark block 10
+
+	do_mark_mirror_test 10 $BACKLOG1
+	do_mark_mirror_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
+ecn_trap_test()
+{
+	install_root_qdisc
+	install_qdisc_tc0 ecn qevent mark block 10
+	install_qdisc_tc1 ecn
+
+	do_mark_trap_test_pass 10 $BACKLOG1
+	do_mark_trap_test_fail 11 $BACKLOG2
+
+	uninstall_qdisc_tc1
+	install_qdisc_tc1 ecn qevent mark block 10
+
+	do_mark_trap_test_pass 10 $BACKLOG1
+	do_mark_trap_test_pass 11 $BACKLOG2
+
+	uninstall_qdisc_tc1
+	uninstall_qdisc_tc0
+	uninstall_root_qdisc
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.29.2

