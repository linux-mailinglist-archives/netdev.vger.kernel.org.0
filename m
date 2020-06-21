Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2A2029AC
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgFUIe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:34:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34029 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729576AbgFUIe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:34:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 246CF5C00E6;
        Sun, 21 Jun 2020 04:34:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=iimHJtjM+RWRERNIZ7X/t0BBuzbWj9tUjo3kEhUQqvo=; b=PaV3Gurb
        AhZ+aUjRNIF/K9eyIqbfHym8dihfhziaajgI3M5Jzpx//ibYKaJocQexXSRQt7cn
        Xal+5Y62y8mZOAjfaidpw9kem+yY8rWJVOyXLcYQoDW95Bcl34Wy06ScfPSTg+dh
        5IaEUJVBZfhotYq5JQU+Yy0Xm2WmLUs1cFqMfoSC9WvYt842QyZ1d+i61Hgkkjyz
        X5i/coYmG8wtbkszOnQrjN3SErbiI60xuCzSZ4X+A2eSykYua3eUGbZXvSh70OaC
        j8GyMH0b79v2W1vN04DJWu+ycOqGpEqProP2E0bDoPgi/GIGyLrG+Hi4mr4T0DwN
        LGnjGOgirv0wtA==
X-ME-Sender: <xms:rxvvXpgOPGbeWpm1u93cO3AzvADZuBXQJWgDKU6Mn9RSgIecyJBXEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeijedrkedruddvleen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sBvvXuDixAgYZ59Q3n9jsg-bjiT_2qM_V4ZpjC-aBMqAYxMBqjCFPA>
    <xmx:sBvvXpExiv1PHROntAU66NioGh4u86RNRc2Vi7W4-6aPiJ0oJ-X8kQ>
    <xmx:sBvvXuTM7tAyrZJhr7Xc9p5MAVEnUuRnHt4nHyx5IX1d1GsvpcM8yQ>
    <xmx:sBvvXh8oYg5wyFVjKtDJ4jMN-TQ0mS0E9tE9mlTg20_HAKdNJ8l4HA>
Received: from splinter.mtl.com (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FCE83066D7A;
        Sun, 21 Jun 2020 04:34:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/4] selftests: forwarding: Add a test for pedit munge tcp, udp sport, dport
Date:   Sun, 21 Jun 2020 11:34:36 +0300
Message-Id: <20200621083436.476806-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200621083436.476806-1-idosch@idosch.org>
References: <20200621083436.476806-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a test that checks that pedit adjusts port numbers of tcp and udp
packets.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/pedit_l4port.sh  | 198 ++++++++++++++++++
 1 file changed, 198 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_l4port.sh

diff --git a/tools/testing/selftests/net/forwarding/pedit_l4port.sh b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
new file mode 100755
index 000000000000..5f20d289ee43
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
@@ -0,0 +1,198 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends traffic from H1 to H2. Either on ingress of $swp1, or on egress of $swp2, the
+# traffic is acted upon by a pedit action. An ingress filter installed on $h2 verifies that the
+# packet looks like expected.
+#
+# +----------------------+                             +----------------------+
+# | H1                   |                             |                   H2 |
+# |    + $h1             |                             |            $h2 +     |
+# |    | 192.0.2.1/28    |                             |   192.0.2.2/28 |     |
+# +----|-----------------+                             +----------------|-----+
+#      |                                                                |
+# +----|----------------------------------------------------------------|-----+
+# | SW |                                                                |     |
+# |  +-|----------------------------------------------------------------|-+   |
+# |  | + $swp1                       BR                           $swp2 + |   |
+# |  +--------------------------------------------------------------------+   |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	test_udp_sport
+	test_udp_dport
+	test_tcp_sport
+	test_tcp_dport
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+: ${HIT_TIMEOUT:=2000} # ms
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/28 2001:db8:1::2/64
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2 192.0.2.2/28 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	ip link add name br1 up type bridge vlan_filtering 1
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+
+	tc qdisc add dev $swp1 clsact
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+	tc qdisc del dev $swp1 clsact
+
+	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 nomaster
+	ip link del dev br1
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
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.2
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:1::2
+}
+
+do_test_pedit_l4port_one()
+{
+	local pedit_locus=$1; shift
+	local pedit_prot=$1; shift
+	local pedit_action=$1; shift
+	local match_prot=$1; shift
+	local match_flower=$1; shift
+	local mz_flags=$1; shift
+	local saddr=$1; shift
+	local daddr=$1; shift
+
+	tc filter add $pedit_locus handle 101 pref 1 \
+	   flower action pedit ex munge $pedit_action
+	tc filter add dev $h2 ingress handle 101 pref 1 prot $match_prot \
+	   flower skip_hw $match_flower action pass
+
+	RET=0
+
+	$MZ $mz_flags $h1 -c 10 -d 20msec -p 100 \
+	    -a own -b $h2mac -q -t $pedit_prot sp=54321,dp=12345
+
+	local pkts
+	pkts=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= 10" \
+			tc_rule_handle_stats_get "dev $h2 ingress" 101)
+	check_err $? "Expected to get 10 packets, but got $pkts."
+
+	pkts=$(tc_rule_handle_stats_get "$pedit_locus" 101)
+	((pkts >= 10))
+	check_err $? "Expected to get 10 packets on pedit rule, but got $pkts."
+
+	log_test "$pedit_locus pedit $pedit_action"
+
+	tc filter del dev $h2 ingress pref 1
+	tc filter del $pedit_locus pref 1
+}
+
+do_test_pedit_l4port()
+{
+	local locus=$1; shift
+	local prot=$1; shift
+	local pedit_port=$1; shift
+	local flower_port=$1; shift
+	local port
+
+	for port in 1 11111 65535; do
+		do_test_pedit_l4port_one "$locus" "$prot"			\
+					 "$prot $pedit_port set $port"		\
+					 ip "ip_proto $prot $flower_port $port"	\
+					 "-A 192.0.2.1 -B 192.0.2.2"
+	done
+}
+
+test_udp_sport()
+{
+	do_test_pedit_l4port "dev $swp1 ingress" udp sport src_port
+	do_test_pedit_l4port "dev $swp2 egress"  udp sport src_port
+}
+
+test_udp_dport()
+{
+	do_test_pedit_l4port "dev $swp1 ingress" udp dport dst_port
+	do_test_pedit_l4port "dev $swp2 egress"  udp dport dst_port
+}
+
+test_tcp_sport()
+{
+	do_test_pedit_l4port "dev $swp1 ingress" tcp sport src_port
+	do_test_pedit_l4port "dev $swp2 egress"  tcp sport src_port
+}
+
+test_tcp_dport()
+{
+	do_test_pedit_l4port "dev $swp1 ingress" tcp dport dst_port
+	do_test_pedit_l4port "dev $swp2 egress"  tcp dport dst_port
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
2.26.2

