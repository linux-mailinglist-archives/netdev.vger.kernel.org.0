Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27491940B0
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgCZOCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:02:01 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39565 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727910AbgCZOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:02:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E66B5C01E2;
        Thu, 26 Mar 2020 10:01:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Iz7x1SfsZIbrVFT4VVhpuwZgskO1FEbgJoqYdjnCaq0=; b=AzUdg2MG
        IP42Gv2bWWPxWeMg+UZ4MhjEcGM1blvOpcxKGldS/m2rZekn7RBcymySsKeFSZtP
        ghcBSOPLIQH7eULNEXqhD3c0ZzOE+Kyz3qmFDPF/R94SzBvU2iSm0DTfTZI0C27p
        wf9lcxUYkXivzSUCmV56isPa7ni3rz3DdPUwuOSiLzXJLU5w9a8ti+CbnRgI2AWf
        PGbNpyrpcerlQODhcCdi/TQ4xoTpG6bO16ixQSwkpxFwCpeuqST+t4I/QFWpCp7j
        oRQcLmCIJyzvJBXSVXnqz1oLu2WHKGLuAycClyNuIypfU1u9BL6vTERYbCag280D
        +QptFZCP8f27Ng==
X-ME-Sender: <xms:1rV8Xk4l1D9W7DyiC2ttDmL_J1I393e95ipAxmjbfclYBZ0bgDBUOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:1rV8XqLr5G_MArH3O-TnyzEyAQyvtvq-XkPDHCBH3byacEPOypDFtA>
    <xmx:1rV8XufMLscDB0F6AuVxRy-pLD5zGX9VZp85wdlJ8ZwNcNug09qK3w>
    <xmx:1rV8XtfR9yDqTQ5LISjpJmlaJlFZqthqUiBhgGTJ1euGdyaMVppbEg>
    <xmx:1rV8XiI4C1pyr0oQJDZJaapCkJHebf6vfliaBbZCzISo_IB0hH1ijQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02C4530696D4;
        Thu, 26 Mar 2020 10:01:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/6] selftests: forwarding: Add a forwarding test for pedit munge dsfield
Date:   Thu, 26 Mar 2020 16:01:13 +0200
Message-Id: <20200326140114.1393972-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326140114.1393972-1-idosch@idosch.org>
References: <20200326140114.1393972-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a test that runs packets with dsfield set, and test that pedit adjusts
the DSCP or ECN parts or the whole field.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/pedit_dsfield.sh | 238 ++++++++++++++++++
 1 file changed, 238 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_dsfield.sh

diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
new file mode 100755
index 000000000000..b50081855913
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -0,0 +1,238 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends traffic from H1 to H2. Either on ingress of $swp1, or on
+# egress of $swp2, the traffic is acted upon by a pedit action. An ingress
+# filter installed on $h2 verifies that the packet looks like expected.
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
+	test_ip_dsfield
+	test_ip_dscp
+	test_ip_ecn
+	test_ip_dscp_ecn
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
+do_test_pedit_dsfield_common()
+{
+	local pedit_locus=$1; shift
+	local pedit_action=$1; shift
+	local mz_flags=$1; shift
+
+	RET=0
+
+	# TOS 125: DSCP 31, ECN 1. Used for testing that the relevant part is
+	# overwritten when zero is selected.
+	$MZ $mz_flags $h1 -c 10 -d 20msec -p 100 \
+	    -a own -b $h2mac -q -t tcp tos=0x7d,sp=54321,dp=12345
+
+	local pkts
+	pkts=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= 10" \
+			tc_rule_handle_stats_get "dev $h2 ingress" 101)
+	check_err $? "Expected to get 10 packets, but got $pkts."
+	log_test "$pedit_locus pedit $pedit_action"
+}
+
+do_test_pedit_dsfield()
+{
+	local pedit_locus=$1; shift
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
+	do_test_pedit_dsfield_common "$pedit_locus" "$pedit_action" "$mz_flags"
+
+	tc filter del dev $h2 ingress pref 1
+	tc filter del $pedit_locus pref 1
+}
+
+do_test_ip_dsfield()
+{
+	local locus=$1; shift
+	local dsfield
+
+	for dsfield in 0 1 2 3 128 252 253 254 255; do
+		do_test_pedit_dsfield "$locus"				\
+				      "ip dsfield set $dsfield"		\
+				      ip "ip_tos $dsfield"		\
+				      "-A 192.0.2.1 -B 192.0.2.2"
+	done
+}
+
+test_ip_dsfield()
+{
+	do_test_ip_dsfield "dev $swp1 ingress"
+	do_test_ip_dsfield "dev $swp2 egress"
+}
+
+do_test_ip_dscp()
+{
+	local locus=$1; shift
+	local dscp
+
+	for dscp in 0 1 2 3 32 61 62 63; do
+		do_test_pedit_dsfield "$locus"				       \
+				  "ip dsfield set $((dscp << 2)) retain 0xfc"  \
+				  ip "ip_tos $(((dscp << 2) | 1))"	       \
+				  "-A 192.0.2.1 -B 192.0.2.2"
+	done
+}
+
+test_ip_dscp()
+{
+	do_test_ip_dscp "dev $swp1 ingress"
+	do_test_ip_dscp "dev $swp2 egress"
+}
+
+do_test_ip_ecn()
+{
+	local locus=$1; shift
+	local ecn
+
+	for ecn in 0 1 2 3; do
+		do_test_pedit_dsfield "$locus"				\
+				      "ip dsfield set $ecn retain 0x03"	\
+				      ip "ip_tos $((124 | $ecn))"	\
+				      "-A 192.0.2.1 -B 192.0.2.2"
+	done
+}
+
+test_ip_ecn()
+{
+	do_test_ip_ecn "dev $swp1 ingress"
+	do_test_ip_ecn "dev $swp2 egress"
+}
+
+do_test_ip_dscp_ecn()
+{
+	local locus=$1; shift
+
+	tc filter add $locus handle 101 pref 1				\
+	   flower action pedit ex munge ip dsfield set 124 retain 0xfc	\
+		  action pedit ex munge ip dsfield set 1 retain 0x03
+	tc filter add dev $h2 ingress handle 101 pref 1 prot ip		\
+	   flower skip_hw ip_tos 125 action pass
+
+	do_test_pedit_dsfield_common "$locus" "set DSCP + set ECN"	\
+				      "-A 192.0.2.1 -B 192.0.2.2"
+
+	tc filter del dev $h2 ingress pref 1
+	tc filter del $locus pref 1
+}
+
+test_ip_dscp_ecn()
+{
+	do_test_ip_dscp_ecn "dev $swp1 ingress"
+	do_test_ip_dscp_ecn "dev $swp2 egress"
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
2.24.1

