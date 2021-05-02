Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD6370DEE
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhEBQZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:57 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37879 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232372AbhEBQZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 71F305C0139;
        Sun,  2 May 2021 12:25:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 02 May 2021 12:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=bpqUHuy2SMOV6yzr3J1D6H0SgL+BModvT7aDQWC3IYE=; b=lkHRZvZU
        +muQdpmsNwxqmK7P5tAWf2rEIzp2Qaf0kM5LA1JWXYsHYWaAHS5DY0fjobq8o+p5
        AJqU/00K1Fb/g5qp5gB8QSlM/O228vJiWCqqPZQs2vS2XrzYBRTgO7gpSdgTIMx6
        AZtCn1tZsnOjcqf/4bjn/SnEnlGt8C7lPPf9rn8ISre0IuF3n2TudqFtO+GWyH9K
        Xpw8TKYEABTE2Dhmm79J/6UMUoHiVKb+kNSTD35QXfZz2RfwgosMisyEAHV/Pvyu
        9JAOiIdCIKUk844+uIgK5RuvlJEtsdnyz8cWi8ihC+0+hm/LlMwvxKrZdKVJnHfn
        mdNQaoZWE8OOEw==
X-ME-Sender: <xms:YNKOYIdGE9mGoHVwuuMdiQ2ZRMNBzETzLQVLWHBTT3YL_DjTLk6cdA>
    <xme:YNKOYKNt_ByyhtUI177fEQSJVZXagGHNBFTaQYLqeH63sT5W4pIapPUFzUUSkwF7V
    ub4_SzbYmM8ovc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YNKOYJh4n4Wlb1AHB99lw-apBU9ixuxJdDDFSfZrDspww_vvrR3jvQ>
    <xmx:YNKOYN9UQmys_GFJ6J4n3Cki5LTU3LDW1zY6A0B7SuhIhTCqAUtlxw>
    <xmx:YNKOYEtBVoyCisR5ognTMEofiQJJnXeUX824xL89Zhylbm_uz3_CnA>
    <xmx:YNKOYIhbC4X5WgQwFpWiQBJXGQ1ZrJHB-hXMrw8k-Z1VU1NZXEw_cA>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:25:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 09/10] selftests: forwarding: Add test for custom multipath hash with IPv4 GRE
Date:   Sun,  2 May 2021 19:22:56 +0300
Message-Id: <20210502162257.3472453-10-idosch@idosch.org>
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
only according to the inner fields set in the fib_multipath_hash_fields
sysctl.

Each time set a different field and make sure traffic is only
distributed when the field is changed in the packet stream.

The test only verifies the behavior of IPv4/IPv6 overlays on top of an
IPv4 underlay network. A subsequent patch will do the same with an IPv6
underlay network.

Example output:

 # ./gre_custom_multipath_hash.sh
 TEST: ping                                                          [ OK ]
 TEST: ping6                                                         [ OK ]
 INFO: Running IPv4 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6601 / 6001
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 12600
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 6802 / 5802
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12601 / 1
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16430 / 16344
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32772
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16430 / 16343
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 32772
 INFO: Running IPv6 overlay custom multipath hash tests
 TEST: Multipath hash field: Inner source IP (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 6702 / 5900
 TEST: Multipath hash field: Inner source IP (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 0 / 12601
 TEST: Multipath hash field: Inner destination IP (balanced)         [ OK ]
 INFO: Packets sent on path1 / path2: 5751 / 6851
 TEST: Multipath hash field: Inner destination IP (unbalanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 12602 / 1
 TEST: Multipath hash field: Inner flowlabel (balanced)              [ OK ]
 INFO: Packets sent on path1 / path2: 8364 / 8065
 TEST: Multipath hash field: Inner flowlabel (unbalanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 12601 / 0
 TEST: Multipath hash field: Inner source port (balanced)            [ OK ]
 INFO: Packets sent on path1 / path2: 16425 / 16349
 TEST: Multipath hash field: Inner source port (unbalanced)          [ OK ]
 INFO: Packets sent on path1 / path2: 1 / 32770
 TEST: Multipath hash field: Inner destination port (balanced)       [ OK ]
 INFO: Packets sent on path1 / path2: 16425 / 16349
 TEST: Multipath hash field: Inner destination port (unbalanced)     [ OK ]
 INFO: Packets sent on path1 / path2: 2 / 32770

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../forwarding/gre_custom_multipath_hash.sh   | 456 ++++++++++++++++++
 1 file changed, 456 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh

diff --git a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
new file mode 100755
index 000000000000..e381083d8609
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
@@ -0,0 +1,456 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test traffic distribution when there are multiple paths between an IPv4 GRE
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
+# +-------------------------|------------------+
+# | SW1                     |                  |
+# |                    $ol1 +                  |
+# |         198.51.100.1/24                    |
+# |        2001:db8:1::1/64                    |
+# |                                            |
+# |   + g1 (gre)                               |
+# |     loc=192.0.2.1                          |
+# |     rem=192.0.2.2 --.                      |
+# |     tos=inherit     |                      |
+# |                     v                      |
+# |                     + $ul1                 |
+# |                     | 192.0.2.17/28        |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# | SW2                 |                      |
+# |               $ul21 +                      |
+# |       192.0.2.18/28 |                      |
+# |                     |                      |
+# !   __________________+___                   |
+# |  /                      \                  |
+# |  |                      |                  |
+# |  + $ul22.111 (vlan)     + $ul22.222 (vlan) |
+# |  | 192.0.2.33/28        | 192.0.2.49/28    |
+# |  |                      |                  |
+# +--|----------------------|------------------+
+#    |                      |
+# +--|----------------------|------------------+
+# |  |                      |                  |
+# |  + $ul32.111 (vlan)     + $ul32.222 (vlan) |
+# |  | 192.0.2.34/28        | 192.0.2.50/28    |
+# |  |                      |                  |
+# |  \__________________+___/                  |
+# |                     |                      |
+# |                     |                      |
+# |               $ul31 +                      |
+# |       192.0.2.65/28 |                  SW3 |
+# +---------------------|----------------------+
+#                       |
+# +---------------------|----------------------+
+# |                     + $ul4                 |
+# |                     ^ 192.0.2.66/28        |
+# |                     |                      |
+# |   + g2 (gre)        |                      |
+# |     loc=192.0.2.2   |                      |
+# |     rem=192.0.2.1 --'                      |
+# |     tos=inherit                            |
+# |                                            |
+# |                    $ol4 +                  |
+# |          203.0.113.1/24 |                  |
+# |        2001:db8:2::1/64 |              SW4 |
+# +-------------------------|------------------+
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
+	__simple_if_init $ul1 v$ol1 192.0.2.17/28
+
+	tunnel_create g1 gre 192.0.2.1 192.0.2.2 tos inherit dev v$ol1
+	__simple_if_init g1 v$ol1 192.0.2.1/32
+	ip route add vrf v$ol1 192.0.2.2/32 via 192.0.2.18
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
+	ip route del vrf v$ol1 192.0.2.2/32
+	__simple_if_fini g1 192.0.2.1/32
+	tunnel_destroy g1
+
+	__simple_if_fini $ul1 192.0.2.17/28
+	simple_if_fini $ol1 198.51.100.1/24 2001:db8:1::1/64
+}
+
+sw2_create()
+{
+	simple_if_init $ul21 192.0.2.18/28
+	__simple_if_init $ul22 v$ul21
+	vlan_create $ul22 111 v$ul21 192.0.2.33/28
+	vlan_create $ul22 222 v$ul21 192.0.2.49/28
+
+	ip route add vrf v$ul21 192.0.2.1/32 via 192.0.2.17
+	ip route add vrf v$ul21 192.0.2.2/32 \
+	   nexthop via 192.0.2.34 \
+	   nexthop via 192.0.2.50
+}
+
+sw2_destroy()
+{
+	ip route del vrf v$ul21 192.0.2.2/32
+	ip route del vrf v$ul21 192.0.2.1/32
+
+	vlan_destroy $ul22 222
+	vlan_destroy $ul22 111
+	__simple_if_fini $ul22
+	simple_if_fini $ul21 192.0.2.18/28
+}
+
+sw3_create()
+{
+	simple_if_init $ul31 192.0.2.65/28
+	__simple_if_init $ul32 v$ul31
+	vlan_create $ul32 111 v$ul31 192.0.2.34/28
+	vlan_create $ul32 222 v$ul31 192.0.2.50/28
+
+	ip route add vrf v$ul31 192.0.2.2/32 via 192.0.2.66
+	ip route add vrf v$ul31 192.0.2.1/32 \
+	   nexthop via 192.0.2.33 \
+	   nexthop via 192.0.2.49
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
+	ip route del vrf v$ul31 192.0.2.1/32
+	ip route del vrf v$ul31 192.0.2.2/32
+
+	vlan_destroy $ul32 222
+	vlan_destroy $ul32 111
+	__simple_if_fini $ul32
+	simple_if_fini $ul31 192.0.2.65/28
+}
+
+sw4_create()
+{
+	simple_if_init $ol4 203.0.113.1/24 2001:db8:2::1/64
+	__simple_if_init $ul4 v$ol4 192.0.2.66/28
+
+	tunnel_create g2 gre 192.0.2.2 192.0.2.1 tos inherit dev v$ol4
+	__simple_if_init g2 v$ol4 192.0.2.2/32
+	ip route add vrf v$ol4 192.0.2.1/32 via 192.0.2.65
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
+	ip route del vrf v$ol4 192.0.2.1/32
+	__simple_if_fini g2 192.0.2.2/32
+	tunnel_destroy g2
+
+	__simple_if_fini $ul4 192.0.2.66/28
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
+	sysctl_set net.ipv4.fib_multipath_hash_fields 6
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv4
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 7
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv4
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 10
+	custom_hash_test "Inner source port" "balanced" send_src_udp4
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp4
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 11
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
+	sysctl_set net.ipv4.fib_multipath_hash_fields 6
+	custom_hash_test "Inner source IP" "balanced" send_src_ipv6
+	custom_hash_test "Inner source IP" "unbalanced" send_dst_ipv6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 7
+	custom_hash_test "Inner destination IP" "balanced" send_dst_ipv6
+	custom_hash_test "Inner destination IP" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 9
+	custom_hash_test "Inner flowlabel" "balanced" send_flowlabel
+	custom_hash_test "Inner flowlabel" "unbalanced" send_src_ipv6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 10
+	custom_hash_test "Inner source port" "balanced" send_src_udp6
+	custom_hash_test "Inner source port" "unbalanced" send_dst_udp6
+
+	sysctl_set net.ipv4.fib_multipath_hash_fields 11
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
+	sysctl_set net.ipv4.fib_multipath_hash_policy 3
+
+	custom_hash_v4
+	custom_hash_v6
+
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
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

