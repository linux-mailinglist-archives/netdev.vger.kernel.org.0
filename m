Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFBD18B858
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCSNsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:48:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34641 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727303AbgCSNsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:48:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6FE155C01B2;
        Thu, 19 Mar 2020 09:48:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 09:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=JnqhB7n2SLcGF4frV624NFsQ4jLyoFnt8P2lB9Fu54c=; b=B82yffnZ
        5LR/ouC610lHVoQPyH5cWr6vJY6xzcxZl4zfnRN7jxRpYtzCqb5AAjy4shdIyPeZ
        8eW3qi37FyJbsVQfFrV5Jqo/WDDjUCPQ6Jx11VvBn64oEF+xa39pR40iAlmnhtut
        27MuP/dMjP4MNzfG6yveG4IlcVp7kKoFaDPaY3hRznCPoRfHUTEYZXpFzoMTxDeE
        GR013g42VtSYIKWKit446zyqaaDMYodRHNscfdVmsnAYw60pUg1xh/S9ak7LFGmJ
        iDudhF8hmE3JASgI9ItQte+0YiluN8yG2phBpXiCjzQG0g0RnAqo1TibRRfPMOKg
        pkQKMHuOepRH9Q==
X-ME-Sender: <xms:JnhzXipcj9kxJWpdpZs0mzwhaMpx2BEZIhtC91jwR2_s7CH-982ArQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedrudeftddrheenucevlhhushhtvghruf
    hiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:JnhzXh7bPc_cmJlenG612eao3tGbFwXlE6xclmB-sHicr9g9j1FsTg>
    <xmx:JnhzXgGT_hD358d3LOmUwq7iDnENMDdCeyFM49j6zwFGifeGmIil3A>
    <xmx:JnhzXo5nHjwXoPCvC0YIDuZdSAs2xudrT4Xu5CA5AG6Z8BS-s1vPXA>
    <xmx:JnhzXk8duJfr_UfYPuny5wDl5W-ABDDgmnRfTIayBuXEtmMBhecMyg>
Received: from splinter.mtl.com (bzq-109-66-130-5.red.bezeqint.net [109.66.130.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id 375FF30618B7;
        Thu, 19 Mar 2020 09:48:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/5] selftests: forwarding: Add an skbedit priority selftest
Date:   Thu, 19 Mar 2020 15:47:24 +0200
Message-Id: <20200319134724.1036942-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add a test that runs traffic through a port such that skbedit priority
action acts on it during forwarding. Test that at egress, it is classified
correctly according to the new priority at a PRIO qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/forwarding/skbedit_priority.sh        | 163 ++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/skbedit_priority.sh

diff --git a/tools/testing/selftests/net/forwarding/skbedit_priority.sh b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
new file mode 100755
index 000000000000..0e7693297765
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
@@ -0,0 +1,163 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends traffic from H1 to H2. Either on ingress of $swp1, or on
+# egress of $swp2, the traffic is acted upon by an action skbedit priority. The
+# new priority should be taken into account when classifying traffic on the PRIO
+# qdisc at $swp2. The test verifies that for different priority values, the
+# traffic ends up in expected PRIO band.
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
+# |  |                                                             PRIO   |   |
+# |  +--------------------------------------------------------------------+   |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	test_ingress
+	test_egress
+"
+
+NUM_NETIFS=4
+source lib.sh
+
+: ${HIT_TIMEOUT:=2000} # ms
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/28
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/28
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 192.0.2.2/28
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
+	tc qdisc add dev $swp2 root handle 10: \
+	   prio bands 8 priomap 7 6 5 4 3 2 1 0
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 root
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
+test_skbedit_priority_one()
+{
+	local locus=$1; shift
+	local prio=$1; shift
+	local classid=$1; shift
+
+	RET=0
+
+	tc filter add $locus handle 101 pref 1 \
+	   flower action skbedit priority $prio
+
+	local pkt0=$(qdisc_parent_stats_get $swp2 $classid .packets)
+	$MZ $h1 -t udp "sp=54321,dp=12345" -c 10 -d 20msec -p 100 \
+	    -a own -b $h2mac -A 192.0.2.1 -B 192.0.2.2 -q
+	local pkt1
+	pkt1=$(busywait "$HIT_TIMEOUT" until_counter_is ">= $((pkt0 + 10))" \
+			qdisc_parent_stats_get $swp2 $classid .packets)
+
+	check_err $? "Expected to get 10 packets on class $classid, but got
+$((pkt1 - pkt0))."
+	log_test "$locus skbedit priority $prio -> classid $classid"
+
+	tc filter del $locus pref 1
+}
+
+test_ingress()
+{
+	local prio
+
+	for prio in {0..7}; do
+		test_skbedit_priority_one "dev $swp1 ingress" \
+					  $prio 10:$((8 - prio))
+	done
+}
+
+test_egress()
+{
+	local prio
+
+	for prio in {0..7}; do
+		test_skbedit_priority_one "dev $swp2 egress" \
+					  $prio 10:$((8 - prio))
+	done
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

