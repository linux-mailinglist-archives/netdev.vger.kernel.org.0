Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7CF34D5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389524AbfKGQnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:18 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41217 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728965AbfKGQnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2C52F21AD2;
        Thu,  7 Nov 2019 11:43:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=S/ni8b95n3uLAki6KpfUHyGMbd2RiwFF2M2kI0fN14Y=; b=nynNzs9U
        wgZuPPxoqCrAwagwx1923hjs2d3JhF9FCsUfsWXcudi9VvcIOr4sbjjAxmfkDE9K
        vE8AVfg6Ah96V4Wl5GSXeIuW+Jwlp7Kbdrxy3DkXqQs4eIioXP/takvuFrGRmnCW
        KqAdpWk/ZUMUXKdiu1qIeLgawdW9KzTDnTJH2TqF0RfVcCWI0yDto385n3dHMZWz
        v4JYYITH+EuSF7MzO7j2n8pSE93ALqX2RYXhEnqo5F4vCoSHSDbDa/MWNo6euYLv
        58HWUHohPudNgzuWTOuzhtI7ULC6UBZsqqEaW5GKEaXeGTMaAwHRH/sVu2leZR3d
        G45YA9RON7psuA==
X-ME-Sender: <xms:pEnEXT2qgYmVx2zvPlYuGg_Aq6ac4VwGjWFs2aKNfUJvz02F8gt6Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:pUnEXejK88R1h7Xx5ysIK_LvIFQlTag12UE4tmg3QPXT3bynq-eJvw>
    <xmx:pUnEXbIf2Cx0qcVjG9MepgCjw_OD863SAlZ-lEsq_bA8SqKXRIm90Q>
    <xmx:pUnEXfWG7JVCNsz6W8Fy85PeTAJNILKjtjKjI-CMGax6PQwPb1j8Fg>
    <xmx:pUnEXXocsUadqsUPRrk5z9FCgGPa54gjk1YqQxUL4XGrSi1WsjaHhw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 907C88005B;
        Thu,  7 Nov 2019 11:43:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/12] selftests: devlink: Export functions to devlink library
Date:   Thu,  7 Nov 2019 18:42:11 +0200
Message-Id: <20191107164220.20526-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

l2_drops_test() is used to check that drop traps are functioning as
intended. Currently it is only used in the layer 2 test, but it is also
useful for the layer 3 test introduced in the subsequent patch.

l2_drops_cleanup() is used to clean configurations and kill mausezahn
proccess.

Export the functions to the common devlink library to allow it to be
re-used by future tests.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 68 ++++---------------
 .../selftests/net/forwarding/devlink_lib.sh   | 42 ++++++++++++
 2 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
index 126caf28b529..192d6f3b0da5 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -92,46 +92,6 @@ cleanup()
 	vrf_cleanup
 }
 
-l2_drops_test()
-{
-	local trap_name=$1; shift
-	local group_name=$1; shift
-
-	# This is the common part of all the tests. It checks that stats are
-	# initially idle, then non-idle after changing the trap action and
-	# finally idle again. It also makes sure the packets are dropped and
-	# never forwarded.
-	devlink_trap_stats_idle_test $trap_name
-	check_err $? "Trap stats not idle with initial drop action"
-	devlink_trap_group_stats_idle_test $group_name
-	check_err $? "Trap group stats not idle with initial drop action"
-
-	devlink_trap_action_set $trap_name "trap"
-
-	devlink_trap_stats_idle_test $trap_name
-	check_fail $? "Trap stats idle after setting action to trap"
-	devlink_trap_group_stats_idle_test $group_name
-	check_fail $? "Trap group stats idle after setting action to trap"
-
-	devlink_trap_action_set $trap_name "drop"
-
-	devlink_trap_stats_idle_test $trap_name
-	check_err $? "Trap stats not idle after setting action to drop"
-	devlink_trap_group_stats_idle_test $group_name
-	check_err $? "Trap group stats not idle after setting action to drop"
-
-	tc_check_packets "dev $swp2 egress" 101 0
-	check_err $? "Packets were not dropped"
-}
-
-l2_drops_cleanup()
-{
-	local mz_pid=$1; shift
-
-	kill $mz_pid && wait $mz_pid &> /dev/null
-	tc filter del dev $swp2 egress protocol ip pref 1 handle 101 flower
-}
-
 source_mac_is_multicast_test()
 {
 	local trap_name="source_mac_is_multicast"
@@ -147,11 +107,11 @@ source_mac_is_multicast_test()
 
 	RET=0
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	log_test "Source MAC is multicast"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 }
 
 __vlan_tag_mismatch_test()
@@ -172,7 +132,7 @@ __vlan_tag_mismatch_test()
 	$MZ $h1 "$opt" -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	# Add PVID and make sure packets are no longer dropped.
 	bridge vlan add vid 1 dev $swp1 pvid untagged master
@@ -188,7 +148,7 @@ __vlan_tag_mismatch_test()
 
 	devlink_trap_action_set $trap_name "drop"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 }
 
 vlan_tag_mismatch_untagged_test()
@@ -233,7 +193,7 @@ ingress_vlan_filter_test()
 	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	# Add the VLAN on the bridge port and make sure packets are no longer
 	# dropped.
@@ -252,7 +212,7 @@ ingress_vlan_filter_test()
 
 	log_test "Ingress VLAN filter"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 
 	bridge vlan del vid $vid dev $swp1 master
 	bridge vlan del vid $vid dev $swp2 master
@@ -277,7 +237,7 @@ __ingress_stp_filter_test()
 	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	# Change STP state to forwarding and make sure packets are no longer
 	# dropped.
@@ -294,7 +254,7 @@ __ingress_stp_filter_test()
 
 	devlink_trap_action_set $trap_name "drop"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 
 	bridge vlan del vid $vid dev $swp1 master
 	bridge vlan del vid $vid dev $swp2 master
@@ -348,7 +308,7 @@ port_list_is_empty_uc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	# Allow packets to be flooded to one port.
 	ip link set dev $swp2 type bridge_slave flood on
@@ -366,7 +326,7 @@ port_list_is_empty_uc_test()
 
 	log_test "Port list is empty - unicast"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 
 	ip link set dev $swp1 type bridge_slave flood on
 }
@@ -394,7 +354,7 @@ port_list_is_empty_mc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	# Allow packets to be flooded to one port.
 	ip link set dev $swp2 type bridge_slave mcast_flood on
@@ -412,7 +372,7 @@ port_list_is_empty_mc_test()
 
 	log_test "Port list is empty - multicast"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 
 	ip link set dev $swp1 type bridge_slave mcast_flood on
 }
@@ -441,7 +401,7 @@ port_loopback_filter_uc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	l2_drops_test $trap_name $group_name
+	devlink_trap_drop_test $trap_name $group_name $swp2
 
 	# Allow packets to be flooded.
 	ip link set dev $swp2 type bridge_slave flood on
@@ -459,7 +419,7 @@ port_loopback_filter_uc_test()
 
 	log_test "Port loopback filter - unicast"
 
-	l2_drops_cleanup $mz_pid
+	devlink_trap_drop_cleanup $mz_pid $swp2
 }
 
 port_loopback_filter_test()
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 13d03a6d85ba..931ab26b2555 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -355,3 +355,45 @@ devlink_trap_group_stats_idle_test()
 		return 1
 	fi
 }
+
+devlink_trap_drop_test()
+{
+	local trap_name=$1; shift
+	local group_name=$1; shift
+	local dev=$1; shift
+
+	# This is the common part of all the tests. It checks that stats are
+	# initially idle, then non-idle after changing the trap action and
+	# finally idle again. It also makes sure the packets are dropped and
+	# never forwarded.
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle with initial drop action"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with initial drop action"
+
+
+	devlink_trap_action_set $trap_name "trap"
+	devlink_trap_stats_idle_test $trap_name
+	check_fail $? "Trap stats idle after setting action to trap"
+	devlink_trap_group_stats_idle_test $group_name
+	check_fail $? "Trap group stats idle after setting action to trap"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle after setting action to drop"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle after setting action to drop"
+
+	tc_check_packets "dev $dev egress" 101 0
+	check_err $? "Packets were not dropped"
+}
+
+devlink_trap_drop_cleanup()
+{
+	local mz_pid=$1; shift
+	local dev=$1; shift
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $dev egress protocol ip pref 1 handle 101 flower
+}
-- 
2.21.0

