Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF76437773E
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 17:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhEIPTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 11:19:11 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60507 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229828AbhEIPTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 11:19:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 441075C00F4;
        Sun,  9 May 2021 11:18:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 09 May 2021 11:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=1Ye4Ks9B9Sm68o3nInZcAp6UaBJPVLex/VhRHVAMxeI=; b=Tv5l2mhi
        duMIk06Dy+fivSax4WqaRrdAodZEwdQK7+1Z6Cv9FaJGaV3l8lfTdpLs1L65EJJf
        Z5Ag9KdeUfzOrDtX2gi0gyq+hjR5JTvePqQ2U372apKX7+LpSR1ue2jhhz5HmBnK
        dEbNOT2Qdr2VzIRmnko2Ruhcrzhn10d3bMSUHDIfiGXm7toDOm1R9BIp5b8D6ysZ
        37kUOllNjtGysWnKnnyhe2QvjJ91UlpZBy1tSWc6VE43ZUdY8jRyqkkVx8i+qhn6
        rO2s2bRvamHF3u8ey72PVptnq7DL41KEvKTaa3zlxwWlNvIVRMvnGg6nskgYE/UN
        dIUTLDBdLHhrxQ==
X-ME-Sender: <xms:Lf2XYOmdabdQUJBUJNtyEigRqHz_-1r01EOQt4mDWKR0-tM2R8NLWQ>
    <xme:Lf2XYF2umeR98CZXlLQsGcCRxkwMnP6ouNu569YLxYLomO5n7szVFxl7OnjD8AkQJ
    82k2sSKBuKUG1k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Lf2XYMojM8M6Aj44dpno76zouz4agUgW9fyt8AVaFtwp5J328gAI8A>
    <xmx:Lf2XYCklCX6eP1Rxup4t00-cjtIOV_Gj_gg3j2eHtYP51OzKcgscHw>
    <xmx:Lf2XYM1sV-35ftZcCKBS5Fs-PWrVAkg-NxaY6b6HxfMza7xod22IsQ>
    <xmx:Lf2XYGpPDv7SVcVf6a5UHsqZxHXH-cTMY0OMlR26NVPttAvAkxf_VA>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 11:18:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 10/10] selftests: forwarding: Add test for custom multipath hash with IPv6 GRE
Date:   Sun,  9 May 2021 18:16:15 +0300
Message-Id: <20210509151615.200608-11-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509151615.200608-1-idosch@idosch.org>
References: <20210509151615.200608-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that when the hash policy is set to custom, traffic is distributed
only according to the inner fields set in the fib_multipath_hash_fields
sysctl.

Each time set a different field and make sure traffic is only
distributed when the field is changed in the packet stream.

The test only verifies the behavior of IPv4/IPv6 overlays on top of an
IPv6 underlay network. The previous patch verified the same with an IPv4
underlay network.

Example output:

 # ./ip6gre_custom_multipath_hash.sh
 TEST: ping                                                          [ OK ]
 TEST: ping6                                                         [ OK ]
 INFO: Running IPv4 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6602 / 6002
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 12601
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 6802 / 5801
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12602 / 3
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16431 / 16344
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32773
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16431 / 16344
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 32772
 INFO: Running IPv6 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6704 / 5902
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 12600
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 5751 / 6852
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12602 / 0
 TEST: Multipath hash field: Inner flowlabel (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 8272 / 8181
 TEST: Multipath hash field: Inner flowlabel (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 3 / 12602
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16424 / 16351
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 3 / 32774
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16425 / 16350
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 32773

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ip6gre_custom_multipath_hash.sh           | 458 ++++++++++++++++++
 1 file changed, 458 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh

diff --git a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
new file mode 100755
index 000000000000..8fea2c2e0b25
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
@@ -0,0 +1,458 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test traffic distribution when there are multiple paths between an IPv6 GRE
+# tunnel. The tunnel carries IPv4 and IPv6 traffic between multiple hosts.
+# Multiple routes are in the underlay network. With the default multipath
+# policy, SW2 will only look at the outer IP addresses, hence only a single
+# route would be used.
+#
+# +--------------------------------+
+# | H1                             |
+# |                     $h1 +      |
+# |   198.51.100.{2-253}/24 |      |
+# |   2001:db8:1::{2-fd}/64 |      |
+# +-------------------------|------+
+#                           |
+# +-------------------------|-------------------+
+# | SW1                     |                   |
+# |                    $ol1 +                   |
+# |         198.51.100.1/24                     |
+# |        2001:db8:1::1/64                     |
+# |                                             |
+# |+ g1 (ip6gre)                                |
+# |  loc=2001:db8:3::1                          |
+# |  rem=2001:db8:3::2 -.                       |
+# |     tos=inherit     |                       |
+# |                     v                       |
+# |                     + $ul1                  |
+# |                     | 2001:db8:10::1/64     |
+# +---------------------|-----------------------+
+#                       |
+# +---------------------|-----------------------+
+# | SW2                 |                       |
+# |               $ul21 +                       |
+# |   2001:db8:10::2/64 |                       |
+# |                     |                       |
+# !   __________________+___                    |
+# |  /                      \                   |
+# |  |                      |                   |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan)  |
+# |  | 2001:db8:11::1/64    | 2001:db8:12::1/64 |
+# |  |                      |                   |
+# +--|----------------------|-------------------+
+#    |                      |
+# +--|----------------------|-------------------+
+# |  |                      |                   |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan)  |
+# |  | 2001:db8:11::2/64    | 2001:db8:12::2/64 |
+# |  |                      |                   |
+# |  \__________________+___/                   |
+# |                     |                       |
+# |                     |                       |
+# |               $ul31 +                       |
+# |   2001:db8:13::1/64 |                   SW3 |
+# +---------------------|-----------------------+
+#                       |
+# +---------------------|-----------------------+
+# |                     + $ul4                  |
+# |                     ^ 2001:db8:13::2/64     |
+# |                     |                       |
+# |+ g2 (ip6gre)        |                       |
+# |  loc=2001:db8:3::2  |                       |
+# |  rem=2001:db8:3::1 -'                       |
+# |  tos=inherit                                |
+# |                                             |
+# |                    $ol4 +                   |
+# |          203.0.113.1/24 |                   |
+# |        2001:db8:2::1/64 |               SW4 |
+# +-------------------------|-------------------+
+#                           |
+# +-------------------------|------+
+# |                         |      |
+# |                     $h2 +      |
+# |    203.0.113.{2-253}/24        |
+# |   2001:db8:2::{2-fd}/64     H2 |
+# +--------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	custom_hash
+"
+
+NUM_NETIFS=10
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
+	simple_if_init $ol1 198.51.100.1/24 2001:db8:1::1/64
+	__simple_if_init $ul1 v$ol1 2001:db8:10::1/64
+
+	tunnel_create g1 ip6gre 2001:db8:3::1 2001:db8:3::2 tos inherit \
+		dev v$ol1
+	__simple_if_init g1 v$ol1 2001:db8:3::1/128
+	ip route add vrf v$ol1 2001:db8:3::2/128 via 2001:db8:10::2
+
+	ip route add vrf v$ol1 203.0.113.0/24 dev g1
+	ip -6 route add vrf v$ol1 2001:db8:2::/64 dev g1
+}
+
+sw1_destroy()
+{
+	ip -6 route del vrf v$ol1 2001:db8:2::/64
+	ip route del vrf v$ol1 203.0.113.0/24
+
+	ip route del vrf v$ol1 2001:db8:3::2/128
+	__simple_if_fini g1 2001:db8:3::1/128
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 2001:db8:10::1/64
+	simple_if_fini $ol1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 2001:db8:10::2/64
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 2001:db8:11::1/64
+	vlan_create $ul22 222 v$ul21 2001:db8:12::1/64
+
+	ip -6 route add vrf v$ul21 2001:db8:3::1/128 via 2001:db8:10::1
+	ip -6 route add vrf v$ul21 2001:db8:3::2/128 \
+	   nexthop via 2001:db8:11::2 \
+	   nexthop via 2001:db8:12::2
+}
+
+sw2_destroy()
+{
+	ip -6 route del vrf v$ul21 2001:db8:3::2/128
+	ip -6 route del vrf v$ul21 2001:db8:3::1/128
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 2001:db8:10::2/64
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 2001:db8:13::1/64
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 2001:db8:11::2/64
+	vlan_create $ul32 222 v$ul31 2001:db8:12::2/64
+
+	ip -6 route add vrf v$ul31 2001:db8:3::2/128 via 2001:db8:13::2
+	ip -6 route add vrf v$ul31 2001:db8:3::1/128 \
+	   nexthop via 2001:db8:11::1 \
+	   nexthop via 2001:db8:12::1
+
+	tc qdisc add dev $ul32 clsact
+	tc filter add dev $ul32 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul32 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw3_destroy()
+{
+	tc qdisc del dev $ul32 clsact
+
+	ip -6 route del vrf v$ul31 2001:db8:3::1/128
+	ip -6 route del vrf v$ul31 2001:db8:3::2/128
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 2001:db8:13::1/64
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 203.0.113.1/24 2001:db8:2::1/64
+	__simple_if_init $ul4 v$ol4 2001:db8:13::2/64
+
+	tunnel_create g2 ip6gre 2001:db8:3::2 2001:db8:3::1 tos inherit \
+		dev v$ol4
+	__simple_if_init g2 v$ol4 2001:db8:3::2/128
+	ip -6 route add vrf v$ol4 2001:db8:3::1/128 via 2001:db8:13::1
+
+	ip route add vrf v$ol4 198.51.100.0/24 dev g2
+	ip -6 route add vrf v$ol4 2001:db8:1::/64 dev g2
+}
+
+sw4_destroy()
+{
+	ip -6 route del vrf v$ol4 2001:db8:1::/64
+	ip route del vrf v$ol4 198.51.100.0/24
+
+	ip -6 route del vrf v$ol4 2001:db8:3::1/128
+	__simple_if_fini g2 2001:db8:3::2/128
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 2001:db8:13::2/64
+	simple_if_fini $ol4 203.0.113.1/24 2001:db8:2::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 203.0.113.2/24 2001:db8:2::2/64
+	ip route add vrf v$h2 default via 203.0.113.1 dev $h2
+	ip -6 route add vrf v$h2 default via 2001:db8:2::1 dev $h2
+}
+
+h2_destroy()
+{
+	ip -6 route del vrf v$h2 default
+	ip route del vrf v$h2 default
+	simple_if_fini $h2 203.0.113.2/24 2001:db8:2::2/64
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+
+	ol1=${NETIFS[p2]}
+	ul1=${NETIFS[p3]}
+
+	ul21=${NETIFS[p4]}
+	ul22=${NETIFS[p5]}
+
+	ul32=${NETIFS[p6]}
+	ul31=${NETIFS[p7]}
+
+	ul4=${NETIFS[p8]}
+	ol4=${NETIFS[p9]}
+
+	h2=${NETIFS[p10]}
+
+	vrf_prepare
+	h1_create
+	sw1_create
+	sw2_create
+	sw3_create
+	sw4_create
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
+	sw4_destroy
+	sw3_destroy
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
+	ping6_test $h1 2001:db8:2::2
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
+	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_dst_ipv6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
+}
+
+send_flowlabel()
+{
+	# Generate 16384 echo requests, each with a random flow label.
+	for _ in $(seq 1 16384); do
+		ip vrf exec v$h1 \
+			$PING6 2001:db8:2::2 -F 0 -c 1 -q >/dev/null 2>&1
+	done
+}
+
+send_src_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=0-32768,dp=30000"
+}
+
+send_dst_udp6()
+{
+	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
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
+	local t0_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	$send_flows
+
+	local t1_111=$(tc_rule_stats_get $ul32 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul32 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+
+	local diff=$((d222 - d111))
+	local sum=$((d111 + d222))
+
+	local pct=$(echo "$diff / $sum * 100" | bc -l)
+	local is_balanced=$(echo "-20 <= $pct && $pct <= 20" | bc)
+
+	[[ ( $is_balanced -eq 1 && $balanced == "balanced" ) ||
+	   ( $is_balanced -eq 0 && $balanced == "unbalanced" ) ]]
+	check_err $? "Expected traffic to be $balanced, but it is not"
+
+	log_test "Multipath hash field: $field ($balanced)"
+	log_info "Packets sent on path1 / path2: $d111 / $d222"
+}
+
+custom_hash_v4()
+{
+	log_info "Running IPv4 overlay custom multipath hash tests"
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv4.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv4.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0040
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv4
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv4
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0080
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv4
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv4
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0400
+	custom_hash_test "Inner source port" "balanced" send_src_udp4
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp4
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0800
+	custom_hash_test "Inner destination port" "balanced" send_dst_udp4
+	custom_hash_test "Inner destination port" "unbalanced" send_src_udp4
+
+	sysctl_restore net.ipv4.neigh.default.gc_thresh3
+	sysctl_restore net.ipv4.neigh.default.gc_thresh2
+	sysctl_restore net.ipv4.neigh.default.gc_thresh1
+}
+
+custom_hash_v6()
+{
+	log_info "Running IPv6 overlay custom multipath hash tests"
+
+	# Prevent the neighbour table from overflowing, as different neighbour
+	# entries will be created on $ol4 when using different destination IPs.
+	sysctl_set net.ipv6.neigh.default.gc_thresh1 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh2 1024
+	sysctl_set net.ipv6.neigh.default.gc_thresh3 1024
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0040
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv6
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0080
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv6
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0200
+	custom_hash_test "Inner flowlabel" "balanced" send_flowlabel
+	custom_hash_test "Inner flowlabel" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0400
+	custom_hash_test "Inner source port" "balanced" send_src_udp6
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp6
+
+	sysctl_set net.ipv6.fib_multipath_hash_fields 0x0800
+	custom_hash_test "Inner destination port" "balanced" send_dst_udp6
+	custom_hash_test "Inner destination port" "unbalanced" send_src_udp6
+
+	sysctl_restore net.ipv6.neigh.default.gc_thresh3
+	sysctl_restore net.ipv6.neigh.default.gc_thresh2
+	sysctl_restore net.ipv6.neigh.default.gc_thresh1
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
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 3
+
+	custom_hash_v4
+	custom_hash_v6
+
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
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
2.31.1

