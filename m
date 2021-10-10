Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428124280E5
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJJLmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46655 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232013AbhJJLms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C8BE5C0102;
        Sun, 10 Oct 2021 07:40:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 10 Oct 2021 07:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=kcDJprAcylzAJyJaymzS6SJvseWgS77vWOUnZXVDxvs=; b=gxDT3Yjf
        ej46HYgKVok4YWck1olwRUFQYn7XhQSq1klHm3VX6Lm/qfuUkN6GkV14tI5lD7BW
        SfgAerQnQH9WQwYUvpGzEOQQyiIX/Ebpcp/oUMSy0X5UkrTsp4M8hhfJJdkDNSyA
        6pdKzo5/aP5xwum0y+FTAOvLpknAXzrC5L95iwoVbiJPzKjUAh5eZtVUe8dP+764
        nEdc6xaWOf2/qY1J1Mk6Oy3ue8q0++l8mKrivfThLLgOg5W6ssSzWufRy0S2vSGe
        NUciaKH3CXeplWXLqz16NtpELZne53xbvViR60I9oJj9RX+NGqv9vgGDtrMp22HY
        WuF+s80F9PX97A==
X-ME-Sender: <xms:QtFiYW694jTaACD1GCFt1Ygcy5Y9nPwgGlit3zIfzuVKctc0XS03hw>
    <xme:QtFiYf6XGYiAS5ui1e4JxdkvJMpuSZmVP8e-RwOxwQyzGVi3FoQu2boHI5MaiSF6Q
    fJ2EW8AvrXYs7A>
X-ME-Received: <xmr:QtFiYVdD_ErsrGhD2CJZdE7f2izXtSCO3_pJ2bTJX6pVAcqdupSWcHo4a1577ZBG-nR7h_71XBrNb8Pzs3XPBBzjrlVNI48aDUiNdGyRIzg8Ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QtFiYTJCAF2Dmhqy1c77vqcVjR97MAwP_P734HayPNraNF2yULZZjg>
    <xmx:QtFiYaLf8HL_BsG5LBr7DDjHreATEc-Z41XKfvWjkv9Xh674fShD6Q>
    <xmx:QtFiYUxguX9K1CAkf1QshzqJnvh85u-KLqPmBuB6ob6xHGoX2RDQqA>
    <xmx:QtFiYfECCuxwpO3dcU-HpkpegnLGvU7IuPtZSlU4TazdWRXGGH6x3Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] selftests: mlxsw: RED: Add selftests for the mark qevent
Date:   Sun, 10 Oct 2021 14:40:18 +0300
Message-Id: <20211010114018.190266-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
References: <20211010114018.190266-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add do_mark_test(), which is to do_ecn_test() like do_drop_test() is to
do_red_test(): meant to test that actions on the RED mark qevent block are
offloaded, and executed on ECN-marked packets.

The test splits install_qdisc() into its constituents, install_root_qdisc()
and install_qdisc_tcX(). This is in order to test that when mirroring is
enabled on one TC, the other TC does not mirror.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 74 +++++++++++++++++++
 .../drivers/net/mlxsw/sch_red_ets.sh          | 53 +++++++++++--
 2 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 88053f8dfd12..eea3e5ad3f38 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -544,6 +544,53 @@ do_mc_backlog_test()
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
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+
+	# Create a bit of a backlog and observe no mirroring due to marks.
+	qevent_rule_install_$subtest
+
+	build_backlog $vlan $((2 * limit / 3)) tcp tos=0x01 >/dev/null
+
+	base=$($fetch_counter)
+	count=$(busywait 1100 until_counter_is ">= $((base + 1))" \
+		$fetch_counter)
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
@@ -626,6 +673,22 @@ do_drop_mirror_test()
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
@@ -653,3 +716,14 @@ do_drop_trap_test()
 	do_drop_test "$vlan" "$limit" "$trap_name" trap \
 		     "qevent_counter_fetch_trap $trap_name"
 }
+
+qevent_rule_install_trap_fwd()
+{
+	tc filter add block 10 pref 1234 handle 102 matchall skip_sw \
+	   action trap_fwd hw_stats disabled
+}
+
+qevent_rule_uninstall_trap_fwd()
+{
+	tc filter del block 10 pref 1234 handle 102 matchall
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index f3ef3274f9b3..b58b4cf9dc13 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -9,6 +9,7 @@ ALL_TESTS="
 	mc_backlog_test
 	red_mirror_test
 	red_trap_test
+	ecn_mirror_test
 "
 : ${QDISC:=ets}
 source sch_red_core.sh
@@ -21,28 +22,60 @@ source sch_red_core.sh
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
@@ -112,6 +145,16 @@ red_trap_test()
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
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

