Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2495370DED
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhEBQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53589 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232374AbhEBQZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A6F7D5C013A;
        Sun,  2 May 2021 12:25:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 May 2021 12:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=p/XT9y9DQqL0Mv3w3jy5WV+m3xOS1V9/y8ZvzRYvkFI=; b=CVl1XYej
        Le4j/pkYQ4+9qvu0XMxtfFranaLq26/+XDMIx+zAM19EaT17HXmvny7snyTRvJWJ
        cwLZOupOB75MQej4jVuzqTi8J7M66ZED4nYBnixkXAwgOzQBK5qI/5+yAgAXFsSj
        kq5sjiv8mlNGX/rZlElZVfyZ/hYZPDmCnguvuB8nv3kpkgW8EUymnhCGBdWtsZoh
        1zZjKwMion60y96ARi7ZcFMtx9Rip0VCeDxhEEKJ2CPBtsw86/vGYpasN7okXc5m
        5q58dlUgD1NebJeFj5IsV2ntxsYR1s0Uo4WesVpTh0K5DEuqG/0I83C4f/Z5A55L
        MBzb58Zc7DsGhw==
X-ME-Sender: <xms:XdKOYCyQmlzpxytSuxKnnNWO5YGZFATwv_BiRP_KeTYk_2gKil_Kog>
    <xme:XdKOYOQG3aNUeyQfNDum0bx3L7gwQ0OnVTbVGqZxRCY-LBJHORfjV5ermLmwlSP3_
    E7ky7axKpeOWmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XdKOYEUf3WKyDjW7ryoFDIhpctKWMR9nmlfLwyqLfA8BNP5DQ5DrHQ>
    <xmx:XdKOYIi6vbCRF-7M8YR2oEW2xX2qXagViBfg4cVIpxkZ03jwmORFEw>
    <xmx:XdKOYEBgAtic2qTGhuEhBnzLAt4r8QAYO0Ja2I6rPzgezolRN4bssg>
    <xmx:XdKOYG1YvDdjAjnC_SgMmeq93O7BtznHgAJK0mNTdq_waeARzwZAlQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 08/10] selftests: forwarding: Add test for custom multipath hash
Date:   Sun,  2 May 2021 19:22:55 +0300
Message-Id: <20210502162257.3472453-9-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502162257.3472453-1-idosch@idosch.org>
References: <20210502162257.3472453-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that when the hash policy is set to custom, traffic is distributed
only according to the outer fields set in the fib_multipath_hash_fields
sysctl.

Each time set a different field and make sure traffic is only
distributed when the field is changed in the packet stream.

The test only verifies the behavior with non-encapsulated IPv4 and IPv6
packets. Subsequent patches will add tests for IPv4/IPv6 overlays on top
of IPv4/IPv6 underlay networks.

Example output:

 # ./custom_multipath_hash.sh
 TEST: ping                                                          [ OK ]
 TEST: ping6                                                         [ OK ]
 INFO: Running IPv4 custom multipath hash tests
 TEST: Multipath hash field: Source IP (balanced)                    [ OK ]
 INFO: Packets sent on path1 / path2: 6353 / 6254
 TEST: Multipath hash field: Source IP (unbalanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 12600
 TEST: Multipath hash field: Destination IP (balanced)               [ OK ]
 INFO: Packets sent on path1 / path2: 6102 / 6502
 TEST: Multipath hash field: Destination IP (unbalanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 12601
 TEST: Multipath hash field: Source port (balanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 16428 / 16345
 TEST: Multipath hash field: Source port (unbalanced)                [ OK ]
 INFO: Packets sent on path1 / path2: 32770 / 2
 TEST: Multipath hash field: Destination port (balanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 16428 / 16345
 TEST: Multipath hash field: Destination port (unbalanced)           [ OK ]
 INFO: Packets sent on path1 / path2: 32770 / 2
 INFO: Running IPv6 custom multipath hash tests
 TEST: Multipath hash field: Source IP (balanced)                    [ OK ]
 INFO: Packets sent on path1 / path2: 6704 / 5903
 TEST: Multipath hash field: Source IP (unbalanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 12600 / 0
 TEST: Multipath hash field: Destination IP (balanced)               [ OK ]
 INFO: Packets sent on path1 / path2: 5551 / 7052
 TEST: Multipath hash field: Destination IP (unbalanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 12603 / 0
 TEST: Multipath hash field: Flowlabel (balanced)                    [ OK ]
 INFO: Packets sent on path1 / path2: 8378 / 8080
 TEST: Multipath hash field: Flowlabel (unbalanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 12603
 TEST: Multipath hash field: Source port (balanced)                  [ OK ]
 INFO: Packets sent on path1 / path2: 16385 / 16388
 TEST: Multipath hash field: Source port (unbalanced)                [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32774
 TEST: Multipath hash field: Destination port (balanced)             [ OK ]
 INFO: Packets sent on path1 / path2: 16386 / 16390
 TEST: Multipath hash field: Destination port (unbalanced)           [ OK ]
 INFO: Packets sent on path1 / path2: 32771 / 2

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/custom_multipath_hash.sh   | 364 ++++++++++++++++++
 1 file changed, 364 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh

diff --git a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
new file mode 100755
index 000000000000..210ebb0b94e4
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
@@ -0,0 +1,364 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test traffic distribution between two paths when using custom hash policy.
+#
+# +--------------------------------+
+# | H1                             |
+# |                     $h1 +      |
+# |   198.51.100.{2-253}/24 |      |
+# |   2001:db8:1::{2-fd}/64 |      |
+# +-------------------------|------+
+#                           |
+# +-------------------------|-------------------------+
+# | SW1                     |                         |
+# |                    $rp1 +                         |
+# |         198.51.100.1/24                           |
+# |        2001:db8:1::1/64                           |
+# |                                                   |
+# |                                                   |
+# |            $rp11 +             + $rp12            |
+# |     192.0.2.1/28 |             | 192.0.2.17/28    |
+# | 2001:db8:2::1/64 |             | 2001:db8:3::1/64 |
+# +------------------|-------------|------------------+
+#                    |             |
+# +------------------|-------------|------------------+
+# | SW2              |             |                  |
+# |                  |             |                  |
+# |            $rp21 +             + $rp22            |
+# |     192.0.2.2/28                 192.0.2.18/28    |
+# | 2001:db8:2::2/64                 2001:db8:3::2/64 |
+# |                                                   |
+# |                                                   |
+# |                    $rp2 +                         |
+# |          203.0.113.1/24 |                         |
+# |        2001:db8:4::1/64 |                         |
+# +-------------------------|-------------------------+
+#                           |
+# +-------------------------|------+
+# | H2                      |      |
+# |                     $h2 +      |
+# |    203.0.113.{2-253}/24        |
+# |   2001:db8:4::{2-fd}/64        |
+# +--------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	custom_hash
+"
+
+NUM_NETIFS=8
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 198.51.100.2/24 2001:db8:1::2/64
+	ip route add vrf v$h1 default via 198.51.100.1 dev $h1
+	ip -6 route add vrf v$h1 default via 2001:db8:1::1 dev $h1
+}
+
+h1_destroy()
+{
+	ip -6 route del vrf v$h1 default
+	ip route del vrf v$h1 default
+	simple_if_fini $h1 198.51.100.2/24 2001:db8:1::2/64
+}
+
+sw1_create()
+{
+	simple_if_init $rp1 198.51.100.1/24 2001:db8:1::1/64
+	__simple_if_init $rp11 v$rp1 192.0.2.1/28 2001:db8:2::1/64
+	__simple_if_init $rp12 v$rp1 192.0.2.17/28 2001:db8:3::1/64
+
+	ip route add vrf v$rp1 203.0.113.0/24 \
+		nexthop via 192.0.2.2 dev $rp11 \
+		nexthop via 192.0.2.18 dev $rp12
+
+	ip -6 route add vrf v$rp1 2001:db8:4::/64 \
+		nexthop via 2001:db8:2::2 dev $rp11 \
+		nexthop via 2001:db8:3::2 dev $rp12
+}
+
+sw1_destroy()
+{
+	ip -6 route del vrf v$rp1 2001:db8:4::/64
+
+	ip route del vrf v$rp1 203.0.113.0/24
+
+	__simple_if_fini $rp12 192.0.2.17/28 2001:db8:3::1/64
+	__simple_if_fini $rp11 192.0.2.1/28 2001:db8:2::1/64
+	simple_if_fini $rp1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $rp2 203.0.113.1/24 2001:db8:4::1/64
+	__simple_if_init $rp21 v$rp2 192.0.2.2/28 2001:db8:2::2/64
+	__simple_if_init $rp22 v$rp2 192.0.2.18/28 2001:db8:3::2/64
+
+	ip route add vrf v$rp2 198.51.100.0/24 \
+		nexthop via 192.0.2.1 dev $rp21 \
+		nexthop via 192.0.2.17 dev $rp22
+
+	ip -6 route add vrf v$rp2 2001:db8:1::/64 \
+		nexthop via 2001:db8:2::1 dev $rp21 \
+		nexthop via 2001:db8:3::1 dev $rp22
+}
+
+sw2_destroy()
+{
+	ip -6 route del vrf v$rp2 2001:db8:1::/64
+
+	ip route del vrf v$rp2 198.51.100.0/24
+
+	__simple_if_fini $rp22 192.0.2.18/28 2001:db8:3::2/64
+	__simple_if_fini $rp21 192.0.2.2/28 2001:db8:2::2/64
+	simple_if_fini $rp2 203.0.113.1/24 2001:db8:4::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 203.0.113.2/24 2001:db8:4::2/64
+	ip route add vrf v$h2 default via 203.0.113.1 dev $h2
+	ip -6 route add vrf v$h2 default via 2001:db8:4::1 dev $h2
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 default
+	ip route del vrf v$h2 default
+	simple_if_fini $h2 203.0.113.2/24 2001:db8:4::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	rp1=${NETIFS[p2]}
+
+	rp11=${NETIFS[p3]}
+	rp21=${NETIFS[p4]}
+
+	rp12=${NETIFS[p5]}
+	rp22=${NETIFS[p6]}
+
+	rp2=${NETIFS[p7]}
+
+	h2=${NETIFS[p8]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	h2_create
+
+	forwarding_enable
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	forwarding_restore
+
+	h2_destroy
+	sw2_destroy
+	sw1_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 203.0.113.2
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:4::2
+}
+
+send_src_ipv4()
+{
+	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_dst_ipv4()
+{
+	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_src_udp4()
+{
+	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+		-d 1msec -t udp "sp=0-32768,dp=30000"
+}
+
+send_dst_udp4()
+{
+	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+		-d 1msec -t udp "sp=20000,dp=0-32768"
+}
+
+send_src_ipv6()
+{
+	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_dst_ipv6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_flowlabel()
+{
+	# Generate 16384 echo requests, each with a random flow label.
+	for _ in $(seq 1 16384); do
+		ip vrf exec v$h1 \
+			$PING6 2001:db8:4::2 -F 0 -c 1 -q >/dev/null 2>&1
+	done
+}
+
+send_src_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+		-d 1msec -t udp "sp=0-32768,dp=30000"
+}
+
+send_dst_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+		-d 1msec -t udp "sp=20000,dp=0-32768"
+}
+
+custom_hash_test()
+{
+	local field="$1"; shift
+	local balanced="$1"; shift
+	local send_flows="$@"
+
+	RET=0
+
+	local t0_rp11=$(link_stats_tx_packets_get $rp11)
+	local t0_rp12=$(link_stats_tx_packets_get $rp12)
+
+	$send_flows
+
+	local t1_rp11=$(link_stats_tx_packets_get $rp11)
+	local t1_rp12=$(link_stats_tx_packets_get $rp12)
+
+	local d_rp11=$((t1_rp11 - t0_rp11))
+	local d_rp12=$((t1_rp12 - t0_rp12))
+
+	local diff=$((d_rp12 - d_rp11))
+	local sum=$((d_rp11 + d_rp12))
+
+	local pct=$(echo "$diff / $sum * 100" | bc -l)
+	local is_balanced=$(echo "-20 <= $pct && $pct <= 20" | bc)
+
+	[[ ( $is_balanced -eq 1 && $balanced == "balanced" ) ||
+	   ( $is_balanced -eq 0 && $balanced == "unbalanced" ) ]]
+	check_err $? "Expected traffic to be $balanced, but it is not"
+
+	log_test "Multipath hash field: $field ($balanced)"
+	log_info "Packets sent on path1 / path2: $d_rp11 / $d_rp12"
+}
+
+custom_hash_v4()
+{
+	log_info "Running IPv4 custom multipath hash tests"
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 3
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv4.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 0
+	custom_hash_test "Source IP" "balanced" send_src_ipv4
+	custom_hash_test "Source IP" "unbalanced" send_dst_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 1
+	custom_hash_test "Destination IP" "balanced" send_dst_ipv4
+	custom_hash_test "Destination IP" "unbalanced" send_src_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 4
+	custom_hash_test "Source port" "balanced" send_src_udp4
+	custom_hash_test "Source port" "unbalanced" send_dst_udp4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 5
+	custom_hash_test "Destination port" "balanced" send_dst_udp4
+	custom_hash_test "Destination port" "unbalanced" send_src_udp4
+
+	sysctl_restore net.ipv4.neigh.default.gc_thresh3
+	sysctl_restore net.ipv4.neigh.default.gc_thresh2
+	sysctl_restore net.ipv4.neigh.default.gc_thresh1
+
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+custom_hash_v6()
+{
+	log_info "Running IPv6 custom multipath hash tests"
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 3
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv6.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0
+	custom_hash_test "Source IP" "balanced" send_src_ipv6
+	custom_hash_test "Source IP" "unbalanced" send_dst_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 1
+	custom_hash_test "Destination IP" "balanced" send_dst_ipv6
+	custom_hash_test "Destination IP" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 3
+	custom_hash_test "Flowlabel" "balanced" send_flowlabel
+	custom_hash_test "Flowlabel" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 4
+	custom_hash_test "Source port" "balanced" send_src_udp6
+	custom_hash_test "Source port" "unbalanced" send_dst_udp6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 5
+	custom_hash_test "Destination port" "balanced" send_dst_udp6
+	custom_hash_test "Destination port" "unbalanced" send_src_udp6
+
+	sysctl_restore net.ipv6.neigh.default.gc_thresh3
+	sysctl_restore net.ipv6.neigh.default.gc_thresh2
+	sysctl_restore net.ipv6.neigh.default.gc_thresh1
+
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+custom_hash()
+{
+	# Test that when the hash policy is set to custom, traffic is
+	# distributed only according to the fields set in the
+	# fib_multipath_hash_fields sysctl.
+	#
+	# Each time set a different field and make sure traffic is only
+	# distributed when the field is changed in the packet stream.
+	custom_hash_v4
+	custom_hash_v6
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.30.2

