Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D572B9338
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgKSNJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:41 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:41083 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727417AbgKSNJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:40 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5BCBDED6;
        Thu, 19 Nov 2020 08:09:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ufaTmEE9qlJo/iFLMM4jADRkgZPL8+5P4MDd7DLrXA0=; b=qz+t/Fq/
        5ZCm1XLYSirBz5tzeJMzTKYHovNHuTaz28DsNACq08T7O3MFApaLFQM2GXg8HmHc
        7MM1gpvVnz3gUBdBBLD02SW+tfQ+zaXCqgiYn2jXmC96aIRSTc6lTOci2zYIVcJQ
        uNh30d2kkY0ITVrnBWB81xbp2U7bScMLtHxri5tgv1vdB0noySkMDpJEXjNyqUJq
        tVcKDs65rQ94ZNgCwtHtrwR7mgqX/SNSxh1YnZrCrj+MRcIAS+mEnVPgzjgPi6V4
        6vQD7PQmxjoLDCEGXCV2AybmpfQNCsdzmahk/qoGkUpUKMNtryrIZwDK04jwiAx+
        4sAO+J1tIpvZjA==
X-ME-Sender: <xms:km62X0S4HUrN5_c6xDJ1mWODbAEqyy4f13sOpUdDmMGVk5YQQedT_g>
    <xme:km62Xxyp2mDwsXzG7uhdwIilX883vc2ZneCvrCpwFAJKX0loz3vdv3JE4sq1yA3MN
    LRIDp38-k6KMrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:km62Xx2BOdZzsXkj5bbRW30Bh2z01PwkODcUy-Tvp12kPuZ6bnVGoA>
    <xmx:km62X4BzG1KrRVv2Oyeku8A8U0KNvy4X5oU50lyb8_b7k6SZ89C5sA>
    <xmx:km62X9jxuFVIow7GkqWFHwRw27CSmhmpWVjSX4q0LXLzRJjcSdowpw>
    <xmx:km62XyuqxUdMrFWJlDvAniJ00_9p4hpn9LgM7_Y07G7gxVqQ7uLKTg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2832328006A;
        Thu, 19 Nov 2020 08:09:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] selftests: forwarding: Add multipath tunneling nexthop test
Date:   Thu, 19 Nov 2020 15:08:48 +0200
Message-Id: <20201119130848.407918-9-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a nexthop objects version of gre_multipath.sh. Unlike the original
test, it also tests IPv6 overlay which is not possible with the legacy
nexthop implementation. See commit 9a2ad3623868 ("selftests: forwarding:
gre_multipath: Drop IPv6 tests") for more info.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/gre_multipath_nh.sh        | 356 ++++++++++++++++++
 1 file changed, 356 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_multipath_nh.sh

diff --git a/tools/testing/selftests/net/forwarding/gre_multipath_nh.sh b/tools/testing/selftests/net/forwarding/gre_multipath_nh.sh
new file mode 100755
index 000000000000..d03aa2cab9fd
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/gre_multipath_nh.sh
@@ -0,0 +1,356 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test traffic distribution when a wECMP route forwards traffic to two GRE
+# tunnels.
+#
+# +-------------------------+
+# | H1                      |
+# |               $h1 +     |
+# |      192.0.2.1/28 |     |
+# |  2001:db8:1::1/64 |     |
+# +-------------------|-----+
+#                     |
+# +-------------------|------------------------+
+# | SW1               |                        |
+# |              $ol1 +                        |
+# |      192.0.2.2/28                          |
+# |  2001:db8:1::2/64                          |
+# |                                            |
+# |  + g1a (gre)          + g1b (gre)          |
+# |    loc=192.0.2.65       loc=192.0.2.81     |
+# |    rem=192.0.2.66 --.   rem=192.0.2.82 --. |
+# |    tos=inherit      |   tos=inherit      | |
+# |  .------------------'                    | |
+# |  |                    .------------------' |
+# |  v                    v                    |
+# |  + $ul1.111 (vlan)    + $ul1.222 (vlan)    |
+# |  | 192.0.2.129/28     | 192.0.2.145/28     |
+# |   \                  /                     |
+# |    \________________/                      |
+# |            |                               |
+# |            + $ul1                          |
+# +------------|-------------------------------+
+#              |
+# +------------|-------------------------------+
+# | SW2        + $ul2                          |
+# |     _______|________                       |
+# |    /                \                      |
+# |   /                  \                     |
+# |  + $ul2.111 (vlan)    + $ul2.222 (vlan)    |
+# |  ^ 192.0.2.130/28     ^ 192.0.2.146/28     |
+# |  |                    |                    |
+# |  |                    '------------------. |
+# |  '------------------.                    | |
+# |  + g2a (gre)        | + g2b (gre)        | |
+# |    loc=192.0.2.66   |   loc=192.0.2.82   | |
+# |    rem=192.0.2.65 --'   rem=192.0.2.81 --' |
+# |    tos=inherit          tos=inherit        |
+# |                                            |
+# |              $ol2 +                        |
+# |     192.0.2.17/28 |                        |
+# |  2001:db8:2::1/64 |                        |
+# +-------------------|------------------------+
+#                     |
+# +-------------------|-----+
+# | H2                |     |
+# |               $h2 +     |
+# |     192.0.2.18/28       |
+# |  2001:db8:2::2/64       |
+# +-------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	multipath_ipv4
+	multipath_ipv6
+	multipath_ipv6_l4
+"
+
+NUM_NETIFS=6
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28 2001:db8:1::1/64
+	ip route add vrf v$h1 192.0.2.16/28 via 192.0.2.2
+	ip route add vrf v$h1 2001:db8:2::/64 via 2001:db8:1::2
+}
+
+h1_destroy()
+{
+	ip route del vrf v$h1 2001:db8:2::/64 via 2001:db8:1::2
+	ip route del vrf v$h1 192.0.2.16/28 via 192.0.2.2
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+sw1_create()
+{
+	simple_if_init $ol1 192.0.2.2/28 2001:db8:1::2/64
+	__simple_if_init $ul1 v$ol1
+	vlan_create $ul1 111 v$ol1 192.0.2.129/28
+	vlan_create $ul1 222 v$ol1 192.0.2.145/28
+
+	tunnel_create g1a gre 192.0.2.65 192.0.2.66 tos inherit dev v$ol1
+	__simple_if_init g1a v$ol1 192.0.2.65/32
+	ip route add vrf v$ol1 192.0.2.66/32 via 192.0.2.130
+
+	tunnel_create g1b gre 192.0.2.81 192.0.2.82 tos inherit dev v$ol1
+	__simple_if_init g1b v$ol1 192.0.2.81/32
+	ip route add vrf v$ol1 192.0.2.82/32 via 192.0.2.146
+
+	ip -6 nexthop add id 101 dev g1a
+	ip -6 nexthop add id 102 dev g1b
+	ip nexthop add id 103 group 101/102
+
+	ip route add vrf v$ol1 192.0.2.16/28 nhid 103
+	ip route add vrf v$ol1 2001:db8:2::/64 nhid 103
+}
+
+sw1_destroy()
+{
+	ip route del vrf v$ol1 2001:db8:2::/64
+	ip route del vrf v$ol1 192.0.2.16/28
+
+	ip nexthop del id 103
+	ip -6 nexthop del id 102
+	ip -6 nexthop del id 101
+
+	ip route del vrf v$ol1 192.0.2.82/32 via 192.0.2.146
+	__simple_if_fini g1b 192.0.2.81/32
+	tunnel_destroy g1b
+
+	ip route del vrf v$ol1 192.0.2.66/32 via 192.0.2.130
+	__simple_if_fini g1a 192.0.2.65/32
+	tunnel_destroy g1a
+
+	vlan_destroy $ul1 222
+	vlan_destroy $ul1 111
+	__simple_if_fini $ul1
+	simple_if_fini $ol1 192.0.2.2/28 2001:db8:1::2/64
+}
+
+sw2_create()
+{
+	simple_if_init $ol2 192.0.2.17/28 2001:db8:2::1/64
+	__simple_if_init $ul2 v$ol2
+	vlan_create $ul2 111 v$ol2 192.0.2.130/28
+	vlan_create $ul2 222 v$ol2 192.0.2.146/28
+
+	tunnel_create g2a gre 192.0.2.66 192.0.2.65 tos inherit dev v$ol2
+	__simple_if_init g2a v$ol2 192.0.2.66/32
+	ip route add vrf v$ol2 192.0.2.65/32 via 192.0.2.129
+
+	tunnel_create g2b gre 192.0.2.82 192.0.2.81 tos inherit dev v$ol2
+	__simple_if_init g2b v$ol2 192.0.2.82/32
+	ip route add vrf v$ol2 192.0.2.81/32 via 192.0.2.145
+
+	ip -6 nexthop add id 201 dev g2a
+	ip -6 nexthop add id 202 dev g2b
+	ip nexthop add id 203 group 201/202
+
+	ip route add vrf v$ol2 192.0.2.0/28 nhid 203
+	ip route add vrf v$ol2 2001:db8:1::/64 nhid 203
+
+	tc qdisc add dev $ul2 clsact
+	tc filter add dev $ul2 ingress pref 111 prot 802.1Q \
+	   flower vlan_id 111 action pass
+	tc filter add dev $ul2 ingress pref 222 prot 802.1Q \
+	   flower vlan_id 222 action pass
+}
+
+sw2_destroy()
+{
+	tc qdisc del dev $ul2 clsact
+
+	ip route del vrf v$ol2 2001:db8:1::/64
+	ip route del vrf v$ol2 192.0.2.0/28
+
+	ip nexthop del id 203
+	ip -6 nexthop del id 202
+	ip -6 nexthop del id 201
+
+	ip route del vrf v$ol2 192.0.2.81/32 via 192.0.2.145
+	__simple_if_fini g2b 192.0.2.82/32
+	tunnel_destroy g2b
+
+	ip route del vrf v$ol2 192.0.2.65/32 via 192.0.2.129
+	__simple_if_fini g2a 192.0.2.66/32
+	tunnel_destroy g2a
+
+	vlan_destroy $ul2 222
+	vlan_destroy $ul2 111
+	__simple_if_fini $ul2
+	simple_if_fini $ol2 192.0.2.17/28 2001:db8:2::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.18/28 2001:db8:2::2/64
+	ip route add vrf v$h2 192.0.2.0/28 via 192.0.2.17
+	ip route add vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+}
+
+h2_destroy()
+{
+	ip route del vrf v$h2 2001:db8:1::/64 via 2001:db8:2::1
+	ip route del vrf v$h2 192.0.2.0/28 via 192.0.2.17
+	simple_if_fini $h2 192.0.2.18/28 2001:db8:2::2/64
+}
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
+multipath4_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv4.fib_multipath_hash_policy 1
+	ip nexthop replace id 103 group 101,$weight1/102,$weight2
+
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	ip vrf exec v$h1 \
+	   $MZ $h1 -q -p 64 -A 192.0.2.1 -B 192.0.2.18 \
+	       -d 1msec -t udp "sp=1024,dp=0-32768"
+
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip nexthop replace id 103 group 101/102
+	sysctl_restore net.ipv4.fib_multipath_hash_policy
+}
+
+multipath6_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 0
+	ip nexthop replace id 103 group 101,$weight1/102,$weight2
+
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	# Generate 16384 echo requests, each with a random flow label.
+	for ((i=0; i < 16384; ++i)); do
+		ip vrf exec v$h1 $PING6 2001:db8:2::2 -F 0 -c 1 -q &> /dev/null
+	done
+
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip nexthop replace id 103 group 101/102
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+multipath6_l4_test()
+{
+	local what=$1; shift
+	local weight1=$1; shift
+	local weight2=$1; shift
+
+	sysctl_set net.ipv6.fib_multipath_hash_policy 1
+	ip nexthop replace id 103 group 101,$weight1/102,$weight2
+
+	local t0_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t0_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	ip vrf exec v$h1 \
+		$MZ $h1 -6 -q -p 64 -A 2001:db8:1::1 -B 2001:db8:2::2 \
+		-d 1msec -t udp "sp=1024,dp=0-32768"
+
+	local t1_111=$(tc_rule_stats_get $ul2 111 ingress)
+	local t1_222=$(tc_rule_stats_get $ul2 222 ingress)
+
+	local d111=$((t1_111 - t0_111))
+	local d222=$((t1_222 - t0_222))
+	multipath_eval "$what" $weight1 $weight2 $d111 $d222
+
+	ip nexthop replace id 103 group 101/102
+	sysctl_restore net.ipv6.fib_multipath_hash_policy
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.18
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:2::2
+}
+
+multipath_ipv4()
+{
+	log_info "Running IPv4 multipath tests"
+	multipath4_test "ECMP" 1 1
+	multipath4_test "Weighted MP 2:1" 2 1
+	multipath4_test "Weighted MP 11:45" 11 45
+}
+
+multipath_ipv6()
+{
+	log_info "Running IPv6 multipath tests"
+	multipath6_test "ECMP" 1 1
+	multipath6_test "Weighted MP 2:1" 2 1
+	multipath6_test "Weighted MP 11:45" 11 45
+}
+
+multipath_ipv6_l4()
+{
+	log_info "Running IPv6 L4 hash multipath tests"
+	multipath6_l4_test "ECMP" 1 1
+	multipath6_l4_test "Weighted MP 2:1" 2 1
+	multipath6_l4_test "Weighted MP 11:45" 11 45
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
2.28.0

