Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E31F34E0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389709AbfKGQnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:37 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50909 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389585AbfKGQnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BF02621B8B;
        Thu,  7 Nov 2019 11:43:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=C50tj8POiqlfcwr3K4xWkBFPMrk6KtoU38KkkBqR82k=; b=UA8zOZIs
        PC9XDy6a1IczfwhDCwgzjnFJ6I1Sfqeq4Cmg+QqjkG2+YCqTrEwhic9WpliT8Zkb
        Lhw3e/9JcCtE/CwO8WrtosEkjE1ZbtZEIkxC1jHYKN8V3EBntvsIgZgmXtyqGi8D
        xq0gcJ/TsEggTd16ljwo5+6QD5qcruKllJT7Osb50L4nWONMLp5i6OVB5ywqd/et
        jnv9rACiL9Bk+tJIBN7Z4gGAZvmUPdZDfrIXvtJ1Ex+5AkaZb3f7sqzJ9O6hFXhG
        s0UlG1An++7vtqqJsdN0pSicfp+h4TlzzmYA/HkZL22axkv93XjEScKurZxf9P13
        yQTF+BHvEYDRaw==
X-ME-Sender: <xms:sknEXXfWz3r18yn2L1-FBSdd7ZAzc_ivQRflhyZvrtoJJJ1TvIBiKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedutd
X-ME-Proxy: <xmx:sknEXd2qxE2h3mqjVeJR7kiMJnjnrLbBJhuDBlB9atFII4UVIRuL0Q>
    <xmx:sknEXbodjU48cUc_SOZjPD-7OsR9jxEBeOmnXRgwepbGPqwg9eA4CA>
    <xmx:sknEXdjO7QhN-b_fqz8yIXaAm6w3zsHar0w2v59o6mAlwv8WmTCDTw>
    <xmx:sknEXWjoMg-8eT2Nxh5gFhFJylP3wyq_m9BBtAJrTfJMganZyCTcQg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CFA780064;
        Thu,  7 Nov 2019 11:43:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/12] selftests: mlxsw: Add test cases for devlink-trap layer 3 exceptions
Date:   Thu,  7 Nov 2019 18:42:20 +0200
Message-Id: <20191107164220.20526-13-idosch@idosch.org>
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

Test that each supported packet trap exception is triggered under the
right conditions.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   | 557 ++++++++++++++++++
 1 file changed, 557 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
new file mode 100755
index 000000000000..2bc6df42d597
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
@@ -0,0 +1,557 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test devlink-trap L3 exceptions functionality over mlxsw.
+# Check all exception traps to make sure they are triggered under the right
+# conditions.
+
+# +---------------------------------+
+# | H1 (vrf)                        |
+# |    + $h1                        |
+# |    | 192.0.2.1/24               |
+# |    | 2001:db8:1::1/64           |
+# |    |                            |
+# |    |  default via 192.0.2.2     |
+# |    |  default via 2001:db8:1::2 |
+# +----|----------------------------+
+#      |
+# +----|----------------------------------------------------------------------+
+# | SW |                                                                      |
+# |    + $rp1                                                                 |
+# |        192.0.2.2/24                                                       |
+# |        2001:db8:1::2/64                                                   |
+# |                                                                           |
+# |        2001:db8:2::2/64                                                   |
+# |        198.51.100.2/24                                                    |
+# |    + $rp2                                                                 |
+# |    |                                                                      |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|----------------------------+
+# |    |  default via 198.51.100.2  |
+# |    |  default via 2001:db8:2::2 |
+# |    |                            |
+# |    | 2001:db8:2::1/64           |
+# |    | 198.51.100.1/24            |
+# |    + $h2                        |
+# | H2 (vrf)                        |
+# +---------------------------------+
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	mtu_value_is_too_small_test
+	ttl_value_is_too_small_test
+	mc_reverse_path_forwarding_test
+	reject_route_test
+	unresolved_neigh_test
+	ipv4_lpm_miss_test
+	ipv6_lpm_miss_test
+"
+
+NUM_NETIFS=4
+source $lib_dir/lib.sh
+source $lib_dir/tc_common.sh
+source $lib_dir/devlink_lib.sh
+
+require_command $MCD
+require_command $MC_CLI
+table_name=selftests
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
+
+	ip -4 route add default vrf v$h1 nexthop via 192.0.2.2
+	ip -6 route add default vrf v$h1 nexthop via 2001:db8:1::2
+
+	tc qdisc add dev $h1 clsact
+}
+
+h1_destroy()
+{
+	tc qdisc del dev $h1 clsact
+
+	ip -6 route del default vrf v$h1 nexthop via 2001:db8:1::2
+	ip -4 route del default vrf v$h1 nexthop via 192.0.2.2
+
+	simple_if_fini $h1 192.0.2.1/24 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 198.51.100.1/24 2001:db8:2::1/64
+
+	ip -4 route add default vrf v$h2 nexthop via 198.51.100.2
+	ip -6 route add default vrf v$h2 nexthop via 2001:db8:2::2
+}
+
+h2_destroy()
+{
+	ip -6 route del default vrf v$h2 nexthop via 2001:db8:2::2
+	ip -4 route del default vrf v$h2 nexthop via 198.51.100.2
+
+	simple_if_fini $h2 198.51.100.1/24 2001:db8:2::1/64
+}
+
+router_create()
+{
+	ip link set dev $rp1 up
+	ip link set dev $rp2 up
+
+	tc qdisc add dev $rp2 clsact
+
+	__addr_add_del $rp1 add 192.0.2.2/24 2001:db8:1::2/64
+	__addr_add_del $rp2 add 198.51.100.2/24 2001:db8:2::2/64
+}
+
+router_destroy()
+{
+	__addr_add_del $rp2 del 198.51.100.2/24 2001:db8:2::2/64
+	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
+
+	tc qdisc del dev $rp2 clsact
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	rp1=${NETIFS[p2]}
+
+	rp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	rp1mac=$(mac_get $rp1)
+
+	start_mcd
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+
+	router_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	router_destroy
+
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+
+	kill_mcd
+}
+
+ping_check()
+{
+	ping_do $h1 198.51.100.1
+	check_err $? "Packets that should not be trapped were trapped"
+}
+
+trap_action_check()
+{
+	local trap_name=$1; shift
+	local expected_action=$1; shift
+
+	action=$(devlink_trap_action_get $trap_name)
+	if [ "$action" != $expected_action ]; then
+		check_err 1 "Trap $trap_name has wrong action: $action"
+	fi
+}
+
+mtu_value_is_too_small_test()
+{
+	local trap_name="mtu_value_is_too_small"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	# type - Destination Unreachable
+	# code - Fragmentation Needed and Don't Fragment was Set
+	tc filter add dev $h1 ingress protocol ip pref 1 handle 101 \
+		flower skip_hw ip_proto icmp type 3 code 4 action pass
+
+	mtu_set $rp2 1300
+
+	# Generate IP packets bigger than router's MTU with don't fragment
+	# flag on.
+	$MZ $h1 -t udp "sp=54321,dp=12345,df" -p 1400 -c 0 -d 1msec -b $rp1mac \
+		-B 198.51.100.1 -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	tc_check_packets_hitting "dev $h1 ingress" 101
+	check_err $? "Packets were not received to h1"
+
+	log_test "MTU value is too small"
+
+	mtu_restore $rp2
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $h1 ingress protocol ip pref 1 handle 101 flower
+}
+
+__ttl_value_is_too_small_test()
+{
+	local ttl_val=$1; shift
+	local trap_name="ttl_value_is_too_small"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	# type - Time Exceeded
+	# code - Time to Live exceeded in Transit
+	tc filter add dev $h1 ingress protocol ip pref 1 handle 101 \
+		 flower skip_hw ip_proto icmp type 11 code 0 action pass
+
+	# Generate IP packets with small TTL
+	$MZ $h1 -t udp "ttl=$ttl_val,sp=54321,dp=12345" -c 0 -d 1msec \
+		-b $rp1mac -B 198.51.100.1 -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	tc_check_packets_hitting "dev $h1 ingress" 101
+	check_err $? "Packets were not received to h1"
+
+	log_test "TTL value is too small: TTL=$ttl_val"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $h1 ingress protocol ip pref 1 handle 101 flower
+}
+
+ttl_value_is_too_small_test()
+{
+	__ttl_value_is_too_small_test 0
+	__ttl_value_is_too_small_test 1
+}
+
+start_mcd()
+{
+	SMCROUTEDIR="$(mktemp -d)"
+	for ((i = 1; i <= $NUM_NETIFS; ++i)); do
+		 echo "phyint ${NETIFS[p$i]} enable" >> \
+			 $SMCROUTEDIR/$table_name.conf
+	done
+
+	$MCD -N -I $table_name -f $SMCROUTEDIR/$table_name.conf \
+		-P $SMCROUTEDIR/$table_name.pid
+}
+
+kill_mcd()
+{
+	pkill $MCD
+	rm -rf $SMCROUTEDIR
+}
+
+__mc_reverse_path_forwarding_test()
+{
+	local desc=$1; shift
+	local src_ip=$1; shift
+	local dst_ip=$1; shift
+	local dst_mac=$1; shift
+	local proto=$1; shift
+	local flags=${1:-""}; shift
+	local trap_name="mc_reverse_path_forwarding"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	tc filter add dev $rp2 egress protocol $proto pref 1 handle 101 \
+		flower dst_ip $dst_ip ip_proto udp action drop
+
+	$MC_CLI -I $table_name add $rp1 $src_ip $dst_ip $rp2
+
+	# Generate packets to multicast address.
+	$MZ $h2 $flags -t udp "sp=54321,dp=12345" -c 0 -p 128 \
+		-a 00:11:22:33:44:55 -b $dst_mac \
+		-A $src_ip -B $dst_ip -q &
+
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	tc_check_packets "dev $rp2 egress" 101 0
+	check_err $? "Packets were not dropped"
+
+	log_test "Multicast reverse path forwarding: $desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	tc filter del dev $rp2 egress protocol $proto pref 1 handle 101 flower
+}
+
+mc_reverse_path_forwarding_test()
+{
+	__mc_reverse_path_forwarding_test "IPv4" "192.0.2.1" "225.1.2.3" \
+		"01:00:5e:01:02:03" "ip"
+	__mc_reverse_path_forwarding_test "IPv6" "2001:db8:1::1" "ff0e::3" \
+		"33:33:00:00:00:03" "ipv6" "-6"
+}
+
+__reject_route_test()
+{
+	local desc=$1; shift
+	local dst_ip=$1; shift
+	local proto=$1; shift
+	local ip_proto=$1; shift
+	local type=$1; shift
+	local code=$1; shift
+	local unreachable=$1; shift
+	local flags=${1:-""}; shift
+	local trap_name="reject_route"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	tc filter add dev $h1 ingress protocol $proto pref 1 handle 101 flower \
+		skip_hw ip_proto $ip_proto type $type code $code action pass
+
+	ip route add unreachable $unreachable
+
+	# Generate pacekts to h2. The destination IP is unreachable.
+	$MZ $flags $h1 -t udp "sp=54321,dp=12345" -c 0 -d 1msec -b $rp1mac \
+		-B $dst_ip -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	tc_check_packets_hitting "dev $h1 ingress" 101
+	check_err $? "ICMP packet was not received to h1"
+
+	log_test "Reject route: $desc"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	ip route del unreachable $unreachable
+	tc filter del dev $h1 ingress protocol $proto pref 1 handle 101 flower
+}
+
+reject_route_test()
+{
+	# type - Destination Unreachable
+	# code - Host Unreachable
+	__reject_route_test "IPv4" 198.51.100.1 "ip" "icmp" 3 1 \
+		"198.51.100.0/26"
+	# type - Destination Unreachable
+	# code - No Route
+	__reject_route_test "IPv6" 2001:db8:2::1 "ipv6" "icmpv6" 1 0 \
+		"2001:db8:2::0/66" "-6"
+}
+
+__host_miss_test()
+{
+	local desc=$1; shift
+	local dip=$1; shift
+	local trap_name="unresolved_neigh"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	ip neigh flush dev $rp2
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+
+	# Generate packets to h2 (will incur a unresolved neighbor).
+	# The ping should pass and devlink counters should be increased.
+	ping_do $h1 $dip
+	check_err $? "ping failed: $desc"
+
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		check_err 1 "Trap counter did not increase"
+	fi
+
+	log_test "Unresolved neigh: host miss: $desc"
+}
+
+__invalid_nexthop_test()
+{
+	local desc=$1; shift
+	local dip=$1; shift
+	local extra_add=$1; shift
+	local subnet=$1; shift
+	local via_add=$1; shift
+	local trap_name="unresolved_neigh"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	ip address add $extra_add/$subnet dev $h2
+
+	# Check that correct route does not trigger unresolved_neigh
+	ip $flags route add $dip via $extra_add dev $rp2
+
+	# Generate packets in order to discover all neighbours.
+	# Without it, counters of unresolved_neigh will be increased
+	# during neighbours discovery and the check below will fail
+	# for a wrong reason
+	ping_do $h1 $dip
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	ping_do $h1 $dip
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+
+	if [[ $t0_packets -ne $t1_packets ]]; then
+		check_err 1 "Trap counter increased when it should not"
+	fi
+
+	ip $flags route del $dip via $extra_add dev $rp2
+
+	# Check that route to nexthop that does not exist trigger
+	# unresolved_neigh
+	ip $flags route add $dip via $via_add dev $h2
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	ping_do $h1 $dip
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		check_err 1 "Trap counter did not increase"
+	fi
+
+	ip $flags route del $dip via $via_add dev $h2
+	ip address del $extra_add/$subnet dev $h2
+	log_test "Unresolved neigh: nexthop does not exist: $desc"
+}
+
+unresolved_neigh_test()
+{
+	__host_miss_test "IPv4" 198.51.100.1
+	__host_miss_test "IPv6" 2001:db8:2::1
+	__invalid_nexthop_test "IPv4" 198.51.100.1 198.51.100.3 24 198.51.100.4
+	__invalid_nexthop_test "IPv6" 2001:db8:2::1 2001:db8:2::3 64 \
+		2001:db8:2::4
+}
+
+vrf_without_routes_create()
+{
+	# VRF creating makes the links to be down and then up again.
+	# By default, IPv6 address is not saved after link becomes down.
+	# Save IPv6 address using sysctl configuration.
+	sysctl_set net.ipv6.conf.$rp1.keep_addr_on_down 1
+	sysctl_set net.ipv6.conf.$rp2.keep_addr_on_down 1
+
+	ip link add dev vrf1 type vrf table 101
+	ip link set dev $rp1 master vrf1
+	ip link set dev $rp2 master vrf1
+	ip link set dev vrf1 up
+
+	# Wait for rp1 and rp2 to be up
+	setup_wait
+}
+
+vrf_without_routes_destroy()
+{
+	ip link set dev $rp1 nomaster
+	ip link set dev $rp2 nomaster
+	ip link del dev vrf1
+
+	sysctl_restore net.ipv6.conf.$rp2.keep_addr_on_down
+	sysctl_restore net.ipv6.conf.$rp1.keep_addr_on_down
+
+	# Wait for interfaces to be up
+	setup_wait
+}
+
+ipv4_lpm_miss_test()
+{
+	local trap_name="ipv4_lpm_miss"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	# Create a VRF without a default route
+	vrf_without_routes_create
+
+	# Generate packets through a VRF without a matching route.
+	$MZ $h1 -t udp "sp=54321,dp=12345" -c 0 -d 1msec -b $rp1mac \
+		-B 203.0.113.1 -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	log_test "LPM miss: IPv4"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	vrf_without_routes_destroy
+}
+
+ipv6_lpm_miss_test()
+{
+	local trap_name="ipv6_lpm_miss"
+	local group_name="l3_drops"
+	local expected_action="trap"
+	local mz_pid
+
+	RET=0
+
+	ping_check $trap_name
+	trap_action_check $trap_name $expected_action
+
+	# Create a VRF without a default route
+	vrf_without_routes_create
+
+	# Generate packets through a VRF without a matching route.
+	$MZ -6 $h1 -t udp "sp=54321,dp=12345" -c 0 -d 1msec -b $rp1mac \
+		-B 2001:db8::1 -q &
+	mz_pid=$!
+
+	devlink_trap_exception_test $trap_name $group_name
+
+	log_test "LPM miss: IPv6"
+
+	kill $mz_pid && wait $mz_pid &> /dev/null
+	vrf_without_routes_destroy
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

