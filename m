Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26C31940B2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgCZOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:02:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36973 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727920AbgCZOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:02:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DD62B5C01AC;
        Thu, 26 Mar 2020 10:01:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=rhIY3Mg6ICm84tJXf1AMCU4X2eSb5Jpb9n6qvPVF5+0=; b=bbyqQyLt
        Nj/oi5WTUEjLbV26f2dZy/lc6PO2cd0/Sle+iI7HIf+zBGFVrA6NFFTLWA+FtRCH
        3jVji0ORSmWm+VSrtpSj0WTaP0u+yZ6QC021eyRmbKok6uKvUwZVxpvczXv4zrZF
        rybAUmtIF4rvMEXko34uLi96vHT4LMpR2ukeYpg2TgutTd4oNxYcfFDlnaCK4FWN
        rwT/L+uxAF4dG6Z3W4fE0pb+LPCz/3WwIzcRnafTog8qxv/dfLjKEn1vCW/IbNyk
        e0RLgmBAm/FqUzizlXXvewewe7UdtAA/P9GrkA03IS6Xexdbvxi9IzZVY+bRXyaU
        ArG6qJxVAEvE+A==
X-ME-Sender: <xms:17V8XiSwUtoKy47FgvAEPg1641JzqT1F5MXYFu7aEtH8tj1qS21FNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:17V8Xt5B2mScsffQ6ggDb2w-WXh19KHKUcvW9IcY3poqdv8WeMuPpg>
    <xmx:17V8XijQHj_1mAyKApk9u1_gYtIYOdNyoVkG7HLHX48569Bboj41PQ>
    <xmx:17V8Xr2fXXRrA4386tL2Bq_0qCSItGFobHSJTpvmNdkueHr8-YCHwg>
    <xmx:17V8XnoovZVTmHdv3-m1SmmKxyXTqgR_j_81hd7rLmjeI18FIGJsMg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8029D306993E;
        Thu, 26 Mar 2020 10:01:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/6] selftests: mlxsw: qos_dscp_router: Test no DSCP rewrite after pedit
Date:   Thu, 26 Mar 2020 16:01:14 +0200
Message-Id: <20200326140114.1393972-7-idosch@idosch.org>
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

When DSCP is updated through an offloaded pedit action, DSCP rewrite on
egress should be disabled. Add a test that check that it is so.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/qos_dscp_router.sh      | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
index c745ce3befee..4cb2aa65278a 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
@@ -31,6 +31,7 @@ ALL_TESTS="
 	ping_ipv4
 	test_update
 	test_no_update
+	test_pedit_norewrite
 	test_dscp_leftover
 "
 
@@ -56,6 +57,11 @@ zero()
     echo 0
 }
 
+three()
+{
+    echo 3
+}
+
 h1_create()
 {
 	simple_if_init $h1 192.0.2.1/28
@@ -103,6 +109,9 @@ switch_create()
 	simple_if_init $swp1 192.0.2.2/28
 	__simple_if_init $swp2 v$swp1 192.0.2.17/28
 
+	tc qdisc add dev $swp1 clsact
+	tc qdisc add dev $swp2 clsact
+
 	lldptool -T -i $swp1 -V APP $(dscp_map 0) >/dev/null
 	lldptool -T -i $swp2 -V APP $(dscp_map 0) >/dev/null
 	lldpad_app_wait_set $swp1
@@ -115,6 +124,9 @@ switch_destroy()
 	lldptool -T -i $swp1 -V APP -d $(dscp_map 0) >/dev/null
 	lldpad_app_wait_del
 
+	tc qdisc del dev $swp2 clsact
+	tc qdisc del dev $swp1 clsact
+
 	__simple_if_fini $swp2 192.0.2.17/28
 	simple_if_fini $swp1 192.0.2.2/28
 }
@@ -223,18 +235,36 @@ __test_update()
 
 test_update()
 {
+	echo "Test net.ipv4.ip_forward_update_priority=1"
 	__test_update 1 reprioritize
 }
 
 test_no_update()
 {
+	echo "Test net.ipv4.ip_forward_update_priority=0"
 	__test_update 0 echo
 }
 
+# Test that when DSCP is updated in pedit, the DSCP rewrite is turned off.
+test_pedit_norewrite()
+{
+	echo "Test no DSCP rewrite after DSCP is updated by pedit"
+
+	tc filter add dev $swp1 ingress handle 101 pref 1 prot ip flower \
+	    action pedit ex munge ip dsfield set $((3 << 2)) retain 0xfc \
+	    action skbedit priority 3
+
+	__test_update 0 three
+
+	tc filter del dev $swp1 ingress pref 1
+}
+
 # Test that when the last APP rule is removed, the prio->DSCP map is properly
 # set to zeroes, and that the last APP rule does not stay active in the ASIC.
 test_dscp_leftover()
 {
+	echo "Test that last removed DSCP rule is deconfigured correctly"
+
 	lldptool -T -i $swp2 -V APP -d $(dscp_map 0) >/dev/null
 	lldpad_app_wait_del
 
-- 
2.24.1

