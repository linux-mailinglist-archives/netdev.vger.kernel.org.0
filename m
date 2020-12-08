Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E082D278B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgLHJ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:26:09 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41883 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLHJ0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:26:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AD18F5C01F4;
        Tue,  8 Dec 2020 04:24:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 08 Dec 2020 04:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8M6YRYlCAsdMZyhvLRQzH/MZ/Z/FJMqer2PgkB+wnWA=; b=JzBLTdRP
        kUaZLpGU0/adGurvUo57KlylXEUcoSu3Q1zkhXYhQk2fv7LkCqbKgMnqpX9BQuqe
        fyAOUZCoXEJy3k3kXi5wpPXhotcwbPFJ0oJnOWQMCpWjlXV6bXwaM7fpdbmAyoaL
        XdGNjgi8T48/V7mXsRcXo0v6bFY0sFCbWs74wcBEmODh+mgksUFCdsXm4brxPLO7
        Drl5FNa0Cenmb83T6xrigS7r5eixeCj0gB5ur1j32r4etzXrH40K57pMU5pDud7e
        WBAZ1vqGVeo74u9gsJQM0u4BRHTLXkHzOaUT/MIpPDYvpGFkzFgnTd2PWbW0PHoC
        yVXWbuiv8JPS0A==
X-ME-Sender: <xms:OUbPX9XkQQhuWBzRCsqHqgoIpGCJkl3CNH1iPfbGFznO7Kq7aLAlcA>
    <xme:OUbPX9no96nHTKBPssDxn0bmRwsDL5vFdQvWlWJTUwen6OO4-O4z978x2aE4in0Rk
    LSXDuaM466QZbY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OUbPX5ZyLecZ1-EGnvxWwHnwqT6XxlgCHZ0CPgTJdVmldH666Imwow>
    <xmx:OUbPXwX6dz4s8y8UZ5e5btC-v5EpNW-GYSMNAVf2xqaLp8wwxnflVw>
    <xmx:OUbPX3m2lXIt10YZn6GzG5_WRcIHNiSZQS_5Mi0l4Hg0TxMKU0vqbA>
    <xmx:OUbPXwA-n-UMTHkn-G0A-OfkoeXPnLTPy_gy2wGsVHoyCNcXGIUwMg>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 389501080059;
        Tue,  8 Dec 2020 04:24:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/13] selftests: forwarding: Add Q-in-VNI test
Date:   Tue,  8 Dec 2020 11:22:52 +0200
Message-Id: <20201208092253.1996011-13-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add test to check Q-in-VNI traffic.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/q_in_vni.sh      | 347 ++++++++++++++++++
 1 file changed, 347 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/q_in_vni.sh

diff --git a/tools/testing/selftests/net/forwarding/q_in_vni.sh b/tools/testing/selftests/net/forwarding/q_in_vni.sh
new file mode 100755
index 000000000000..4c50c0234bce
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/q_in_vni.sh
@@ -0,0 +1,347 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                          +------------------------+
+# | H1 (vrf)              |                          | H2 (vrf)               |
+# |  + $h1.10             |                          |  + $h2.10              |
+# |  | 192.0.2.1/28       |                          |  | 192.0.2.2/28        |
+# |  |                    |                          |  |                     |
+# |  | + $h1.20           |                          |  | + $h2.20            |
+# |  \ | 198.51.100.1/24  |                          |  \ | 198.51.100.2/24   |
+# |   \|                  |                          |   \|                   |
+# |    + $h1              |                          |    + $h2               |
+# +----|------------------+                          +----|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|--------------------------------------------------|-----------------+ |
+# | |  + $swp1                   BR1 (802.1ad)            + $swp2           | |
+# | |    vid 100 pvid untagged                              vid 100 pvid    | |
+# | |                                                           untagged    | |
+# | |  + vx100 (vxlan)                                                      | |
+# | |    local 192.0.2.17                                                   | |
+# | |    remote 192.0.2.34 192.0.2.50                                       | |
+# | |    id 1000 dstport $VXPORT                                            | |
+# | |    vid 100 pvid untagged                                              | |
+# | +-----------------------------------------------------------------------+ |
+# |                                                                           |
+# |  192.0.2.32/28 via 192.0.2.18                                             |
+# |  192.0.2.48/28 via 192.0.2.18                                             |
+# |                                                                           |
+# |    + $rp1                                                                 |
+# |    | 192.0.2.17/28                                                        |
+# +----|----------------------------------------------------------------------+
+#      |
+# +----|--------------------------------------------------------+
+# |    |                                             VRP2 (vrf) |
+# |    + $rp2                                                   |
+# |      192.0.2.18/28                                          |
+# |                                                             |   (maybe) HW
+# =============================================================================
+# |                                                             |  (likely) SW
+# |    + v1 (veth)                             + v3 (veth)      |
+# |    | 192.0.2.33/28                         | 192.0.2.49/28  |
+# +----|---------------------------------------|----------------+
+#      |                                       |
+# +----|------------------------------+   +----|------------------------------+
+# |    + v2 (veth)        NS1 (netns) |   |    + v4 (veth)        NS2 (netns) |
+# |      192.0.2.34/28                |   |      192.0.2.50/28                |
+# |                                   |   |                                   |
+# |   192.0.2.16/28 via 192.0.2.33    |   |   192.0.2.16/28 via 192.0.2.49    |
+# |   192.0.2.50/32 via 192.0.2.33    |   |   192.0.2.34/32 via 192.0.2.49    |
+# |                                   |   |                                   |
+# | +-------------------------------+ |   | +-------------------------------+ |
+# | |                 BR2 (802.1ad) | |   | |                 BR2 (802.1ad) | |
+# | |  + vx100 (vxlan)              | |   | |  + vx100 (vxlan)              | |
+# | |    local 192.0.2.34           | |   | |    local 192.0.2.50           | |
+# | |    remote 192.0.2.17          | |   | |    remote 192.0.2.17          | |
+# | |    remote 192.0.2.50          | |   | |    remote 192.0.2.34          | |
+# | |    id 1000 dstport $VXPORT    | |   | |    id 1000 dstport $VXPORT    | |
+# | |    vid 100 pvid untagged      | |   | |    vid 100 pvid untagged      | |
+# | |                               | |   | |                               | |
+# | |  + w1 (veth)                  | |   | |  + w1 (veth)                  | |
+# | |  | vid 100 pvid untagged      | |   | |  | vid 100 pvid untagged      | |
+# | +--|----------------------------+ |   | +--|----------------------------+ |
+# |    |                              |   |    |                              |
+# | +--|----------------------------+ |   | +--|----------------------------+ |
+# | |  |                  VW2 (vrf) | |   | |  |                  VW2 (vrf) | |
+# | |  + w2 (veth)                  | |   | |  + w2 (veth)                  | |
+# | |  |\                           | |   | |  |\                           | |
+# | |  | + w2.10                    | |   | |  | + w2.10                    | |
+# | |  |   192.0.2.3/28             | |   | |  |   192.0.2.4/28             | |
+# | |  |                            | |   | |  |                            | |
+# | |  + w2.20                      | |   | |  + w2.20                      | |
+# | |    198.51.100.3/24            | |   | |    198.51.100.4/24            | |
+# | +-------------------------------+ |   | +-------------------------------+ |
+# +-----------------------------------+   +-----------------------------------+
+
+: ${VXPORT:=4789}
+export VXPORT
+
+: ${ALL_TESTS:="
+	ping_ipv4
+    "}
+
+NUM_NETIFS=6
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	tc qdisc add dev $h1 clsact
+	vlan_create $h1 10 v$h1 192.0.2.1/28
+	vlan_create $h1 20 v$h1 198.51.100.1/24
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 20
+	vlan_destroy $h1 10
+	tc qdisc del dev $h1 clsact
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	tc qdisc add dev $h2 clsact
+	vlan_create $h2 10 v$h2 192.0.2.2/28
+	vlan_create $h2 20 v$h2 198.51.100.2/24
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 20
+	vlan_destroy $h2 10
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2
+}
+
+rp1_set_addr()
+{
+	ip address add dev $rp1 192.0.2.17/28
+
+	ip route add 192.0.2.32/28 nexthop via 192.0.2.18
+	ip route add 192.0.2.48/28 nexthop via 192.0.2.18
+}
+
+rp1_unset_addr()
+{
+	ip route del 192.0.2.48/28 nexthop via 192.0.2.18
+	ip route del 192.0.2.32/28 nexthop via 192.0.2.18
+
+	ip address del dev $rp1 192.0.2.17/28
+}
+
+switch_create()
+{
+	ip link add name br1 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
+		vlan_default_pvid 0 mcast_snooping 0
+	# Make sure the bridge uses the MAC address of the local port and not
+	# that of the VxLAN's device.
+	ip link set dev br1 address $(mac_get $swp1)
+	ip link set dev br1 up
+
+	ip link set dev $rp1 up
+	rp1_set_addr
+
+	ip link add name vx100 type vxlan id 1000		\
+		local 192.0.2.17 dstport "$VXPORT"	\
+		nolearning noudpcsum tos inherit ttl 100
+	ip link set dev vx100 up
+
+	ip link set dev vx100 master br1
+	bridge vlan add vid 100 dev vx100 pvid untagged
+
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	bridge vlan add vid 100 dev $swp1 pvid untagged
+
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+	bridge vlan add vid 100 dev $swp2 pvid untagged
+
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst 192.0.2.34 self
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst 192.0.2.50 self
+}
+
+switch_destroy()
+{
+	bridge fdb del dev vx100 00:00:00:00:00:00 dst 192.0.2.50 self
+	bridge fdb del dev vx100 00:00:00:00:00:00 dst 192.0.2.34 self
+
+	bridge vlan del vid 100 dev $swp2
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	bridge vlan del vid 100 dev $swp1
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev vx100 nomaster
+	ip link set dev vx100 down
+	ip link del dev vx100
+
+	rp1_unset_addr
+	ip link set dev $rp1 down
+
+	ip link set dev br1 down
+	ip link del dev br1
+}
+
+vrp2_create()
+{
+	simple_if_init $rp2 192.0.2.18/28
+	__simple_if_init v1 v$rp2 192.0.2.33/28
+	__simple_if_init v3 v$rp2 192.0.2.49/28
+	tc qdisc add dev v1 clsact
+}
+
+vrp2_destroy()
+{
+	tc qdisc del dev v1 clsact
+	__simple_if_fini v3 192.0.2.49/28
+	__simple_if_fini v1 192.0.2.33/28
+	simple_if_fini $rp2 192.0.2.18/28
+}
+
+ns_init_common()
+{
+	local in_if=$1; shift
+	local in_addr=$1; shift
+	local other_in_addr=$1; shift
+	local nh_addr=$1; shift
+	local host_addr1=$1; shift
+	local host_addr2=$1; shift
+
+	ip link set dev $in_if up
+	ip address add dev $in_if $in_addr/28
+	tc qdisc add dev $in_if clsact
+
+	ip link add name br2 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
+		vlan_default_pvid 0
+	ip link set dev br2 up
+
+	ip link add name w1 type veth peer name w2
+
+	ip link set dev w1 master br2
+	ip link set dev w1 up
+	bridge vlan add vid 100 dev w1 pvid untagged
+
+	ip link add name vx100 type vxlan id 1000 local $in_addr \
+		dstport "$VXPORT"
+	ip link set dev vx100 up
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst 192.0.2.17 self
+	bridge fdb append dev vx100 00:00:00:00:00:00 dst $other_in_addr self
+
+	ip link set dev vx100 master br2
+	tc qdisc add dev vx100 clsact
+
+	bridge vlan add vid 100 dev vx100 pvid untagged
+
+	simple_if_init w2
+        vlan_create w2 10 vw2 $host_addr1/28
+        vlan_create w2 20 vw2 $host_addr2/24
+
+	ip route add 192.0.2.16/28 nexthop via $nh_addr
+	ip route add $other_in_addr/32 nexthop via $nh_addr
+}
+export -f ns_init_common
+
+ns1_create()
+{
+	ip netns add ns1
+	ip link set dev v2 netns ns1
+	in_ns ns1 \
+	      ns_init_common v2 192.0.2.34 192.0.2.50 192.0.2.33 \
+			     192.0.2.3 198.51.100.3
+}
+
+ns1_destroy()
+{
+	ip netns exec ns1 ip link set dev v2 netns 1
+	ip netns del ns1
+}
+
+ns2_create()
+{
+	ip netns add ns2
+	ip link set dev v4 netns ns2
+	in_ns ns2 \
+	      ns_init_common v4 192.0.2.50 192.0.2.34 192.0.2.49 \
+			     192.0.2.4 198.51.100.4
+}
+
+ns2_destroy()
+{
+	ip netns exec ns2 ip link set dev v4 netns 1
+	ip netns del ns2
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
+	rp1=${NETIFS[p5]}
+	rp2=${NETIFS[p6]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	switch_create
+
+	ip link add name v1 type veth peer name v2
+	ip link add name v3 type veth peer name v4
+	vrp2_create
+	ns1_create
+	ns2_create
+
+	r1_mac=$(in_ns ns1 mac_get w2)
+	r2_mac=$(in_ns ns2 mac_get w2)
+	h2_mac=$(mac_get $h2)
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	ns2_destroy
+	ns1_destroy
+	vrp2_destroy
+	ip link del dev v3
+	ip link del dev v1
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.2 ": local->local"
+	ping_test $h1 192.0.2.3 ": local->remote 1"
+	ping_test $h1 192.0.2.4 ": local->remote 2"
+}
+
+test_all()
+{
+	echo "Running tests with UDP port $VXPORT"
+	tests_run
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+test_all
+
+exit $EXIT_STATUS
-- 
2.28.0

