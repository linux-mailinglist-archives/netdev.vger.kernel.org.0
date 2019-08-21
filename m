Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED197340
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 09:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfHUHUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 03:20:38 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40285 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728216AbfHUHUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 03:20:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B4D0C2205E;
        Wed, 21 Aug 2019 03:20:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 21 Aug 2019 03:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=o9M/A78Mi6yEPQ9AP7plcWkdrnmrn5ZAkNA+b25iYuY=; b=crSHvoMo
        CfKXbTpsqvqnTTZ2hgjqDpNEv3mzMU3gQ4yt0Znv5BPy5SaF6+rYfffFXy7/nLr0
        OKlNuLBp8hn0KwgVjGc04Fo+vSfMD+Wqddrx9AkUjN2ivoSO1EbzkZpAFNiPsoGJ
        DP8yrMYrBpuznimP0CfYLGEbjZhPOzmkb2cLXLQ21qkelJDu5VSn8zw97jubWoZc
        XzecKkGTKkFR2Ot//Mg5NgLzS2oc5I+zmC9mQKtlrLbQKxS9nQuGJ5wMTDh0F0W3
        MOiUol3itotwxJvhkbbxmGO3oIVocagADWCBwLyLW3MRCE9p22TMGsna60hDsYTF
        YCx+s+JICaSS+g==
X-ME-Sender: <xms:w_BcXUHHYc7AEfus9ZOub0j2UUkIhcaAYPChTqxQMrvl5bsCE4jmzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegvddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepfe
X-ME-Proxy: <xmx:w_BcXUlGcd46OD6SArHc-hJrA1lsZtXxOVDwAMzLKTCAis2Nbr3mXw>
    <xmx:w_BcXS0CtGqAcwyfaK4_jV8D5XFuaDhsgtDRYuxs85atBxthtAkWDQ>
    <xmx:w_BcXSw7cdnVMCFyD-e_hvnkrmlcXoGBY-ktqmEnWDXu9nYZEL5UzA>
    <xmx:w_BcXUb2v5911vG5VwQSAwZ_zvLoemER1sE4rFJVkNwL_phhIfthrg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67947D60057;
        Wed, 21 Aug 2019 03:20:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/7] selftests: mlxsw: Add test cases for devlink-trap L2 drops
Date:   Wed, 21 Aug 2019 10:19:36 +0300
Message-Id: <20190821071937.13622-7-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Test that each supported packet trap is triggered under the right
conditions and that packets are indeed dropped and not forwarded.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 484 ++++++++++++++++++
 1 file changed, 484 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
new file mode 100755
index 000000000000..5dcdfa20fc6c
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -0,0 +1,484 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap L2 drops functionality over mlxsw. Each registered L2 drop
+# packet trap is tested to make sure it is triggered under the right
+# conditions.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	source_mac_is_multicast_test
+	vlan_tag_mismatch_test
+	ingress_vlan_filter_test
+	ingress_stp_filter_test
+	port_list_is_empty_test
+	port_loopback_filter_test
+"
+NUM_NETIFS=4
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2
+}
+
+switch_create()
+{
+	ip link add dev br0 type bridge vlan_filtering 1 mcast_snooping 0
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+l2_drops_test()
+{
+	local trap_name=$1; shift
+	local group_name=$1; shift
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
+	devlink_trap_action_set $trap_name "trap"
+
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
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_err $? "Packets were not dropped"
+}
+
+l2_drops_cleanup()
+{
+	local mz_pid=$1; shift
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $swp2 egress protocol ip pref 1 handle 101 flower
+}
+
+source_mac_is_multicast_test()
+{
+	local trap_name="source_mac_is_multicast"
+	local smac=01:02:03:04:05:06
+	local group_name="l2_drops"
+	local mz_pid
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower src_mac $smac action drop
+
+	$MZ $h1 -c 0 -p 100 -a $smac -b bcast -t ip -d 1msec -q &
+	mz_pid=$!
+
+	RET=0
+
+	l2_drops_test $trap_name $group_name
+
+	log_test "Source MAC is multicast"
+
+	l2_drops_cleanup $mz_pid
+}
+
+__vlan_tag_mismatch_test()
+{
+	local trap_name="vlan_tag_mismatch"
+	local dmac=de:ad:be:ef:13:37
+	local group_name="l2_drops"
+	local opt=$1; shift
+	local mz_pid
+
+	# Remove PVID flag. This should prevent untagged and prio-tagged
+	# packets from entering the bridge.
+	bridge vlan add vid 1 dev $swp1 untagged master
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_mac $dmac action drop
+
+	$MZ $h1 "$opt" -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
+	mz_pid=$!
+
+	l2_drops_test $trap_name $group_name
+
+	# Add PVID and make sure packets are no longer dropped.
+	bridge vlan add vid 1 dev $swp1 pvid untagged master
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle when packets should not be dropped"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with when packets should not be dropped"
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_fail $? "Packets not forwarded when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	l2_drops_cleanup $mz_pid
+}
+
+vlan_tag_mismatch_untagged_test()
+{
+	RET=0
+
+	__vlan_tag_mismatch_test
+
+	log_test "VLAN tag mismatch - untagged packets"
+}
+
+vlan_tag_mismatch_vid_0_test()
+{
+	RET=0
+
+	__vlan_tag_mismatch_test "-Q 0"
+
+	log_test "VLAN tag mismatch - prio-tagged packets"
+}
+
+vlan_tag_mismatch_test()
+{
+	vlan_tag_mismatch_untagged_test
+	vlan_tag_mismatch_vid_0_test
+}
+
+ingress_vlan_filter_test()
+{
+	local trap_name="ingress_vlan_filter"
+	local dmac=de:ad:be:ef:13:37
+	local group_name="l2_drops"
+	local mz_pid
+	local vid=10
+
+	bridge vlan add vid $vid dev $swp2 master
+	# During initialization the firmware enables all the VLAN filters and
+	# the driver does not turn them off since the traffic will be discarded
+	# by the STP filter whose default is DISCARD state. Add the VID on the
+	# ingress bridge port and then remove it to make sure it is not member
+	# in the VLAN.
+	bridge vlan add vid $vid dev $swp1 master
+	bridge vlan del vid $vid dev $swp1 master
+
+	RET=0
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_mac $dmac action drop
+
+	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
+	mz_pid=$!
+
+	l2_drops_test $trap_name $group_name
+
+	# Add the VLAN on the bridge port and make sure packets are no longer
+	# dropped.
+	bridge vlan add vid $vid dev $swp1 master
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle when packets should not be dropped"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with when packets should not be dropped"
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_fail $? "Packets not forwarded when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	log_test "Ingress VLAN filter"
+
+	l2_drops_cleanup $mz_pid
+
+	bridge vlan del vid $vid dev $swp1 master
+	bridge vlan del vid $vid dev $swp2 master
+}
+
+__ingress_stp_filter_test()
+{
+	local trap_name="ingress_spanning_tree_filter"
+	local dmac=de:ad:be:ef:13:37
+	local group_name="l2_drops"
+	local state=$1; shift
+	local mz_pid
+	local vid=20
+
+	bridge vlan add vid $vid dev $swp2 master
+	bridge vlan add vid $vid dev $swp1 master
+	ip link set dev $swp1 type bridge_slave state $state
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_mac $dmac action drop
+
+	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
+	mz_pid=$!
+
+	l2_drops_test $trap_name $group_name
+
+	# Change STP state to forwarding and make sure packets are no longer
+	# dropped.
+	ip link set dev $swp1 type bridge_slave state 3
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle when packets should not be dropped"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with when packets should not be dropped"
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_fail $? "Packets not forwarded when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	l2_drops_cleanup $mz_pid
+
+	bridge vlan del vid $vid dev $swp1 master
+	bridge vlan del vid $vid dev $swp2 master
+}
+
+ingress_stp_filter_listening_test()
+{
+	local state=$1; shift
+
+	RET=0
+
+	__ingress_stp_filter_test $state
+
+	log_test "Ingress STP filter - listening state"
+}
+
+ingress_stp_filter_learning_test()
+{
+	local state=$1; shift
+
+	RET=0
+
+	__ingress_stp_filter_test $state
+
+	log_test "Ingress STP filter - learning state"
+}
+
+ingress_stp_filter_test()
+{
+	ingress_stp_filter_listening_test 1
+	ingress_stp_filter_learning_test 2
+}
+
+port_list_is_empty_uc_test()
+{
+	local trap_name="port_list_is_empty"
+	local dmac=de:ad:be:ef:13:37
+	local group_name="l2_drops"
+	local mz_pid
+
+	# Disable unicast flooding on both ports, so that packets cannot egress
+	# any port.
+	ip link set dev $swp1 type bridge_slave flood off
+	ip link set dev $swp2 type bridge_slave flood off
+
+	RET=0
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_mac $dmac action drop
+
+	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
+	mz_pid=$!
+
+	l2_drops_test $trap_name $group_name
+
+	# Allow packets to be flooded to one port.
+	ip link set dev $swp2 type bridge_slave flood on
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle when packets should not be dropped"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with when packets should not be dropped"
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_fail $? "Packets not forwarded when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	log_test "Port list is empty - unicast"
+
+	l2_drops_cleanup $mz_pid
+
+	ip link set dev $swp1 type bridge_slave flood on
+}
+
+port_list_is_empty_mc_test()
+{
+	local trap_name="port_list_is_empty"
+	local dmac=01:00:5e:00:00:01
+	local group_name="l2_drops"
+	local dip=239.0.0.1
+	local mz_pid
+
+	# Disable multicast flooding on both ports, so that packets cannot
+	# egress any port. We also need to flush IP addresses from the bridge
+	# in order to prevent packets from being flooded to the router port.
+	ip link set dev $swp1 type bridge_slave mcast_flood off
+	ip link set dev $swp2 type bridge_slave mcast_flood off
+	ip address flush dev br0
+
+	RET=0
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_mac $dmac action drop
+
+	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -B $dip -d 1msec -q &
+	mz_pid=$!
+
+	l2_drops_test $trap_name $group_name
+
+	# Allow packets to be flooded to one port.
+	ip link set dev $swp2 type bridge_slave mcast_flood on
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle when packets should not be dropped"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with when packets should not be dropped"
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_fail $? "Packets not forwarded when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	log_test "Port list is empty - multicast"
+
+	l2_drops_cleanup $mz_pid
+
+	ip link set dev $swp1 type bridge_slave mcast_flood on
+}
+
+port_list_is_empty_test()
+{
+	port_list_is_empty_uc_test
+	port_list_is_empty_mc_test
+}
+
+port_loopback_filter_uc_test()
+{
+	local trap_name="port_loopback_filter"
+	local dmac=de:ad:be:ef:13:37
+	local group_name="l2_drops"
+	local mz_pid
+
+	# Make sure packets can only egress the input port.
+	ip link set dev $swp2 type bridge_slave flood off
+
+	RET=0
+
+	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
+		flower dst_mac $dmac action drop
+
+	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
+	mz_pid=$!
+
+	l2_drops_test $trap_name $group_name
+
+	# Allow packets to be flooded.
+	ip link set dev $swp2 type bridge_slave flood on
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_idle_test $trap_name
+	check_err $? "Trap stats not idle when packets should not be dropped"
+	devlink_trap_group_stats_idle_test $group_name
+	check_err $? "Trap group stats not idle with when packets should not be dropped"
+
+	tc_check_packets "dev $swp2 egress" 101 0
+	check_fail $? "Packets not forwarded when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	log_test "Port loopback filter - unicast"
+
+	l2_drops_cleanup $mz_pid
+}
+
+port_loopback_filter_test()
+{
+	port_loopback_filter_uc_test
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.0

