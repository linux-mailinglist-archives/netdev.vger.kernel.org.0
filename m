Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E466426B88
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbhJHNPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49193 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242515AbhJHNPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A2F95C00B2;
        Fri,  8 Oct 2021 09:13:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 09:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=J8qIioi6Jgg0Htvh/DuY9R742NiEuZWUIkhVOv0cHxc=; b=nBBFhgwn
        6PXsOfbxygOGL6ms3ZQh3A09ky/MhaaXJFoBe3zVMpwy+5ZEG+18WMNhxjF/LDtz
        s+x4ZlDYBtjbxfd9bySlWJ1atBlvPZnouwkqCtPqHkjvgE1+Lq2bCdoFBGjYmCFh
        e9xVnDkfjvqyQPnTM8xe121Vbg82REV37ohd8K1aJy466WdcYpprb9yu56fWhdzm
        AXGONz55H0pv126svklT2lcHyAD+vfBwtUIbH0BPyNNbJyrZGhvFBkyeFyR+FPGN
        dsOg9vRQtM8GRhRVN2KbmWIckZ+KbzygxExn/0cC4CtXw5oj9quaGYz/hEBzf/Uo
        UgTQQ90nTymvRg==
X-ME-Sender: <xms:6ENgYcgcEUB_7G29H7WhLnFjEtXvPzV6hRbYTiV1jKKlkkkHD2c4Hw>
    <xme:6ENgYVANe-d7KYPvUl2H4z4HhpsdwnoiTd_K07RDFg5G-LWVDyUaCleyYm9Vp7qL6
    __sQ6RuRSa8WxU>
X-ME-Received: <xmr:6ENgYUHjerqSwub15Ch-iAVu3FHMZu_g2aZBKWUBrG4P0phWHoipYpXSKxhaDnl1xf74m9T2MGxlNTPLQedHXaQL-LVW-gHi-rOsBIu429s3Kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6ENgYdSUTvGdW69C-lwwKShXsc8tg01eQfI6tLBHxNw1sgS_9G-67Q>
    <xmx:6ENgYZya358uQZbo57nFbFDBpkGoTfzgIUqcF8WlOewL1NHCX79MWA>
    <xmx:6ENgYb6Y00fb6cUsLo_qqnAQiWhED4znBl6EfSAplvBoJ_5OsmoImw>
    <xmx:6ENgYbu-ZFBxUeg8WYpWjCFHAe2wY7Pm7eZkjKsx0Qjui1yIqpWf6Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] selftests: forwarding: Add IPv6 GRE flat tests
Date:   Fri,  8 Oct 2021 16:12:36 +0300
Message-Id: <20211008131241.85038-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add tests that check IPv6-in-IPv6, IPv4-in-IPv6 and MTU change of GRE
tunnel. The tests use flat model - overlay and underlay share the same VRF.

These tests can be run with TC_FLAG=skip_sw, so then they will verify
that packets go through hardware as part of enacp and decap phases.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/ip6gre_flat.sh   |  65 +++++
 .../net/forwarding/ip6gre_flat_key.sh         |  65 +++++
 .../net/forwarding/ip6gre_flat_keys.sh        |  65 +++++
 .../selftests/net/forwarding/ip6gre_lib.sh    | 270 ++++++++++++++++++
 4 files changed, 465 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat_key.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat_keys.sh
 create mode 100644 tools/testing/selftests/net/forwarding/ip6gre_lib.sh

diff --git a/tools/testing/selftests/net/forwarding/ip6gre_flat.sh b/tools/testing/selftests/net/forwarding/ip6gre_flat.sh
new file mode 100755
index 000000000000..96c97064f2d3
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_flat.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test IP-in-IP GRE tunnel without key.
+# This test uses flat topology for IP tunneling tests. See ip6gre_lib.sh for
+# more details.
+
+ALL_TESTS="
+	gre_flat
+	gre_mtu_change
+"
+
+NUM_NETIFS=6
+source lib.sh
+source ip6gre_lib.sh
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	ol1=${NETIFS[p2]}
+
+	ul1=${NETIFS[p3]}
+	ul2=${NETIFS[p4]}
+
+	ol2=${NETIFS[p5]}
+	h2=${NETIFS[p6]}
+
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_flat_create $ol1 $ul1
+	sw2_flat_create $ol2 $ul2
+}
+
+gre_flat()
+{
+	test_traffic_ip4ip6 "GRE flat IPv4-in-IPv6"
+	test_traffic_ip6ip6 "GRE flat IPv6-in-IPv6"
+}
+
+gre_mtu_change()
+{
+	test_mtu_change
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	sw2_flat_destroy $ol2 $ul2
+	sw1_flat_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_flat_key.sh b/tools/testing/selftests/net/forwarding/ip6gre_flat_key.sh
new file mode 100755
index 000000000000..ff9fb0db9bd1
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_flat_key.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test IP-in-IP GRE tunnel with key.
+# This test uses flat topology for IP tunneling tests. See ip6gre_lib.sh for
+# more details.
+
+ALL_TESTS="
+	gre_flat
+	gre_mtu_change
+"
+
+NUM_NETIFS=6
+source lib.sh
+source ip6gre_lib.sh
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	ol1=${NETIFS[p2]}
+
+	ul1=${NETIFS[p3]}
+	ul2=${NETIFS[p4]}
+
+	ol2=${NETIFS[p5]}
+	h2=${NETIFS[p6]}
+
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_flat_create $ol1 $ul1 key 233
+	sw2_flat_create $ol2 $ul2 key 233
+}
+
+gre_flat()
+{
+	test_traffic_ip4ip6 "GRE flat IPv4-in-IPv6 with key"
+	test_traffic_ip6ip6 "GRE flat IPv6-in-IPv6 with key"
+}
+
+gre_mtu_change()
+{
+	test_mtu_change
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	sw2_flat_destroy $ol2 $ul2
+	sw1_flat_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_flat_keys.sh b/tools/testing/selftests/net/forwarding/ip6gre_flat_keys.sh
new file mode 100755
index 000000000000..12c138785242
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_flat_keys.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test IP-in-IP GRE tunnel with keys.
+# This test uses flat topology for IP tunneling tests. See ip6gre_lib.sh for
+# more details.
+
+ALL_TESTS="
+	gre_flat
+	gre_mtu_change
+"
+
+NUM_NETIFS=6
+source lib.sh
+source ip6gre_lib.sh
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	ol1=${NETIFS[p2]}
+
+	ul1=${NETIFS[p3]}
+	ul2=${NETIFS[p4]}
+
+	ol2=${NETIFS[p5]}
+	h2=${NETIFS[p6]}
+
+	forwarding_enable
+	vrf_prepare
+	h1_create
+	h2_create
+	sw1_flat_create $ol1 $ul1 ikey 111 okey 222
+	sw2_flat_create $ol2 $ul2 ikey 222 okey 111
+}
+
+gre_flat()
+{
+	test_traffic_ip4ip6 "GRE flat IPv4-in-IPv6 with ikey/okey"
+	test_traffic_ip6ip6 "GRE flat IPv6-in-IPv6 with ikey/okey"
+}
+
+gre_mtu_change()
+{
+	test_mtu_change	gre
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	sw2_flat_destroy $ol2 $ul2
+	sw1_flat_destroy $ol1 $ul1
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+	forwarding_restore
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/ip6gre_lib.sh b/tools/testing/selftests/net/forwarding/ip6gre_lib.sh
new file mode 100644
index 000000000000..2a5b2126b674
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_lib.sh
@@ -0,0 +1,270 @@
+# SPDX-License-Identifier: GPL-2.0
+#!/bin/bash
+
+# Handles creation and destruction of IP-in-IP or GRE tunnels over the given
+# topology.
+#
+# Flat Model:
+# Overlay and underlay share the same VRF.
+# SW1 uses default VRF so tunnel has no bound dev.
+# SW2 uses non-default VRF tunnel has a bound dev.
+# +--------------------------------+
+# | H1                             |
+# |                     $h1 +      |
+# |        198.51.100.1/24  |      |
+# |        2001:db8:1::1/64 |      |
+# +-------------------------|------+
+#                           |
+# +-------------------------|-------------------+
+# | SW1                     |                   |
+# |                    $ol1 +                   |
+# |        198.51.100.2/24                      |
+# |        2001:db8:1::2/64                     |
+# |                                             |
+# |      + g1a (ip6gre)                         |
+# |        loc=2001:db8:3::1                    |
+# |        rem=2001:db8:3::2 --.                |
+# |        tos=inherit         |                |
+# |                            .                |
+# |      .---------------------                 |
+# |      |                                      |
+# |      v                                      |
+# |      + $ul1.111 (vlan)                      |
+# |      | 2001:db8:10::1/64                    |
+# |       \                                     |
+# |        \____________                        |
+# |                     |                       |
+# | VRF default         + $ul1                  |
+# +---------------------|-----------------------+
+#                       |
+# +---------------------|-----------------------+
+# | SW2                 |                       |
+# |                $ul2 +                       |
+# |          ___________|                       |
+# |         /                                   |
+# |        /                                    |
+# |       + $ul2.111 (vlan)                     |
+# |       ^ 2001:db8:10::2/64                   |
+# |       |                                     |
+# |       |                                     |
+# |       '----------------------.              |
+# |       + g2a (ip6gre)         |              |
+# |         loc=2001:db8:3::2    |              |
+# |         rem=2001:db8:3::1  --'              |
+# |         tos=inherit                         |
+# |                                             |
+# |                     + $ol2                  |
+# |                     | 203.0.113.2/24        |
+# | VRF v$ol2           | 2001:db8:2::2/64      |
+# +---------------------|-----------------------+
+# +---------------------|----------+
+# | H2                  |          |
+# |                 $h2 +          |
+# |    203.0.113.1/24              |
+# |    2001:db8:2::1/64            |
+# +--------------------------------+
+
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1 198.51.100.1/24 2001:db8:1::1/64
+	ip route add vrf v$h1 203.0.113.0/24 via 198.51.100.2
+	ip -6 route add vrf v$h1 2001:db8:2::/64 via 2001:db8:1::2
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 2001:db8:2::/64 via 2001:db8:1::2
+	ip route del vrf v$h1 203.0.113.0/24 via 198.51.100.2
+	simple_if_fini $h1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 203.0.113.1/24 2001:db8:2::1/64
+	ip route add vrf v$h2 198.51.100.0/24 via 203.0.113.2
+	ip -6 route add vrf v$h2 2001:db8:1::/64 via 2001:db8:2::2
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 2001:db8:1::/64 via 2001:db8:2::2
+	ip route del vrf v$h2 198.51.100.0/24 via 203.0.113.2
+	simple_if_fini $h2 203.0.113.1/24 2001:db8:2::1/64
+}
+
+sw1_flat_create()
+{
+	local ol1=$1; shift
+	local ul1=$1; shift
+
+	ip link set dev $ol1 up
+        __addr_add_del $ol1 add 198.51.100.2/24 2001:db8:1::2/64
+
+	ip link set dev $ul1 up
+	vlan_create $ul1 111 "" 2001:db8:10::1/64
+
+	tunnel_create g1a ip6gre 2001:db8:3::1 2001:db8:3::2 tos inherit \
+		ttl inherit "$@"
+	ip link set dev g1a up
+        __addr_add_del g1a add "2001:db8:3::1/128"
+
+	ip -6 route add 2001:db8:3::2/128 via 2001:db8:10::2
+	ip route add 203.0.113.0/24 dev g1a
+	ip -6 route add 2001:db8:2::/64 dev g1a
+}
+
+sw1_flat_destroy()
+{
+	local ol1=$1; shift
+	local ul1=$1; shift
+
+	ip -6 route del 2001:db8:2::/64
+	ip route del 203.0.113.0/24
+	ip -6 route del 2001:db8:3::2/128 via 2001:db8:10::2
+
+	__simple_if_fini g1a 2001:db8:3::1/128
+	tunnel_destroy g1a
+
+	vlan_destroy $ul1 111
+	__simple_if_fini $ul1
+	__simple_if_fini $ol1 198.51.100.2/24 2001:db8:1::2/64
+}
+
+sw2_flat_create()
+{
+	local ol2=$1; shift
+	local ul2=$1; shift
+
+	simple_if_init $ol2 203.0.113.2/24 2001:db8:2::2/64
+	__simple_if_init $ul2 v$ol2
+	vlan_create $ul2 111 v$ol2 2001:db8:10::2/64
+
+	tunnel_create g2a ip6gre 2001:db8:3::2 2001:db8:3::1 tos inherit \
+		ttl inherit dev v$ol2 "$@"
+	__simple_if_init g2a v$ol2 2001:db8:3::2/128
+
+	# Replace neighbor to avoid 1 dropped packet due to "unresolved neigh"
+	ip neigh replace dev $ol2 203.0.113.1 lladdr $(mac_get $h2)
+	ip -6 neigh replace dev $ol2 2001:db8:2::1 lladdr $(mac_get $h2)
+
+	ip -6 route add vrf v$ol2 2001:db8:3::1/128 via 2001:db8:10::1
+	ip route add vrf v$ol2 198.51.100.0/24 dev g2a
+	ip -6 route add vrf v$ol2 2001:db8:1::/64 dev g2a
+}
+
+sw2_flat_destroy()
+{
+	local ol2=$1; shift
+	local ul2=$1; shift
+
+	ip -6 route del vrf v$ol2 2001:db8:2::/64
+	ip route del vrf v$ol2 198.51.100.0/24
+	ip -6 route del vrf v$ol2 2001:db8:3::1/128 via 2001:db8:10::1
+
+	__simple_if_fini g2a 2001:db8:3::2/128
+	tunnel_destroy g2a
+
+	vlan_destroy $ul2 111
+	__simple_if_fini $ul2
+	simple_if_fini $ol2 203.0.113.2/24 2001:db8:2::2/64
+}
+
+test_traffic_ip4ip6()
+{
+	RET=0
+
+	h1mac=$(mac_get $h1)
+	ol1mac=$(mac_get $ol1)
+
+	tc qdisc add dev $ul1 clsact
+	tc filter add dev $ul1 egress proto all pref 1 handle 101 \
+		flower $TC_FLAG action pass
+
+	tc qdisc add dev $ol2 clsact
+	tc filter add dev $ol2 egress protocol ipv4 pref 1 handle 101 \
+		flower $TC_FLAG dst_ip 203.0.113.1 action pass
+
+	$MZ $h1 -c 1000 -p 64 -a $h1mac -b $ol1mac -A 198.51.100.1 \
+		-B 203.0.113.1 -t ip -q -d 1msec
+
+	# Check ports after encap and after decap.
+	tc_check_at_least_x_packets "dev $ul1 egress" 101 1000
+	check_err $? "Packets did not go through $ul1, tc_flag = $TC_FLAG"
+
+	tc_check_at_least_x_packets "dev $ol2 egress" 101 1000
+	check_err $? "Packets did not go through $ol2, tc_flag = $TC_FLAG"
+
+	log_test "$@"
+
+	tc filter del dev $ol2 egress protocol ipv4 pref 1 handle 101 flower
+	tc qdisc del dev $ol2 clsact
+	tc filter del dev $ul1 egress proto all pref 1 handle 101 flower
+	tc qdisc del dev $ul1 clsact
+}
+
+test_traffic_ip6ip6()
+{
+	RET=0
+
+	h1mac=$(mac_get $h1)
+	ol1mac=$(mac_get $ol1)
+
+	tc qdisc add dev $ul1 clsact
+	tc filter add dev $ul1 egress proto all pref 1 handle 101 \
+		flower $TC_FLAG action pass
+
+	tc qdisc add dev $ol2 clsact
+	tc filter add dev $ol2 egress protocol ipv6 pref 1 handle 101 \
+		flower $TC_FLAG dst_ip 2001:db8:2::1 action pass
+
+	$MZ -6 $h1 -c 1000 -p 64 -a $h1mac -b $ol1mac -A 2001:db8:1::1 \
+		-B 2001:db8:2::1 -t ip -q -d 1msec
+
+	# Check ports after encap and after decap.
+	tc_check_at_least_x_packets "dev $ul1 egress" 101 1000
+	check_err $? "Packets did not go through $ul1, tc_flag = $TC_FLAG"
+
+	tc_check_at_least_x_packets "dev $ol2 egress" 101 1000
+	check_err $? "Packets did not go through $ol2, tc_flag = $TC_FLAG"
+
+	log_test "$@"
+
+	tc filter del dev $ol2 egress protocol ipv6 pref 1 handle 101 flower
+	tc qdisc del dev $ol2 clsact
+	tc filter del dev $ul1 egress proto all pref 1 handle 101 flower
+	tc qdisc del dev $ul1 clsact
+}
+
+topo_mtu_change()
+{
+	local mtu=$1
+
+	ip link set mtu $mtu dev $h1
+	ip link set mtu $mtu dev $ol1
+	ip link set mtu $mtu dev g1a
+	ip link set mtu $mtu dev $ul1
+	ip link set mtu $mtu dev $ul1.111
+	ip link set mtu $mtu dev $h2
+	ip link set mtu $mtu dev $ol2
+	ip link set mtu $mtu dev g2a
+	ip link set mtu $mtu dev $ul2
+	ip link set mtu $mtu dev $ul2.111
+}
+
+test_mtu_change()
+{
+	RET=0
+
+	ping6_do $h1 2001:db8:2::1 "-s 1800 -w 3"
+	check_fail $? "ping GRE IPv6 should not pass with packet size 1800"
+
+	RET=0
+
+	topo_mtu_change	2000
+	ping6_do $h1 2001:db8:2::1 "-s 1800 -w 3"
+	check_err $?
+	log_test "ping GRE IPv6, packet size 1800 after MTU change"
+}
-- 
2.31.1

