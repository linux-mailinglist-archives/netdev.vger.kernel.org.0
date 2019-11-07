Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CDDF34D6
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389541AbfKGQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:21 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35907 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389521AbfKGQnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 97C2521B6B;
        Thu,  7 Nov 2019 11:43:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WCZzdFyD+qa7eVFn+zJvdh3u5407NsfysAZUC4DNDck=; b=vkn2gx2I
        q/8QqoXLOjCs2ALcYz+em3gOMWJReulHQqGHYGiqFs44Xl1O1mJpolJd5FCQdz1/
        Iuy+B682UE1YsXmoGf0DWlbaT3DZacIQQrpopaB0i2lov4B5FqgTtaMsdthYC/TV
        Vcu009yFgXjtK3Zk3ZQIogf4cXQW3OJp3yYiDe9Pos7hvTYVIPsX8XowaM3VsuiD
        QgdajSLIiUwvNtiAQgtdBvHzE7GEHZRim3h7k24bxQlSlvwsgxplGCIr22dWCtNs
        NHetCusnhjJ5gwQJ/tu2rbs9zExP4pGAkWefBJ1UryX0OuD6FyVXrhid1bht8omF
        f3REV6T1GC9y0A==
X-ME-Sender: <xms:pknEXUlvs_RA1QzSTbVigiSGaamZDCZHoH4yUDLgykVm7tt2wHFVpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:pknEXdNDFB02bo2A5xSvgXkGz7QP3kPN4COK57h4AzJO4QfOhVmimg>
    <xmx:pknEXbKwE-cA0slo6CzGdTRk1fgrs4ph9DJt__rqtFEkCfzdCkVrkQ>
    <xmx:pknEXQGmcpAYsIqlzoxn1aC7JMbsT_pfYKsmrmEJ82C4S35mxmG4sw>
    <xmx:pknEXUV5lDz18huDkclIxhu1NRN9R_XrinZ-00lFpGHO5_2mtSSycA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 106B58005C;
        Thu,  7 Nov 2019 11:43:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/12] selftests: devlink: Make devlink_trap_cleanup() more generic
Date:   Thu,  7 Nov 2019 18:42:12 +0200
Message-Id: <20191107164220.20526-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add proto parameter in order to enable the use of devlink_trap_cleanup()
in tests that use IPv6 protocol.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/devlink_trap_l2_drops.sh     | 14 +++++++-------
 .../selftests/net/forwarding/devlink_lib.sh        |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
index 192d6f3b0da5..58cdbfb608e9 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -111,7 +111,7 @@ source_mac_is_multicast_test()
 
 	log_test "Source MAC is multicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 }
 
 __vlan_tag_mismatch_test()
@@ -148,7 +148,7 @@ __vlan_tag_mismatch_test()
 
 	devlink_trap_action_set $trap_name "drop"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 }
 
 vlan_tag_mismatch_untagged_test()
@@ -212,7 +212,7 @@ ingress_vlan_filter_test()
 
 	log_test "Ingress VLAN filter"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 
 	bridge vlan del vid $vid dev $swp1 master
 	bridge vlan del vid $vid dev $swp2 master
@@ -254,7 +254,7 @@ __ingress_stp_filter_test()
 
 	devlink_trap_action_set $trap_name "drop"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 
 	bridge vlan del vid $vid dev $swp1 master
 	bridge vlan del vid $vid dev $swp2 master
@@ -326,7 +326,7 @@ port_list_is_empty_uc_test()
 
 	log_test "Port list is empty - unicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 
 	ip link set dev $swp1 type bridge_slave flood on
 }
@@ -372,7 +372,7 @@ port_list_is_empty_mc_test()
 
 	log_test "Port list is empty - multicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 
 	ip link set dev $swp1 type bridge_slave mcast_flood on
 }
@@ -419,7 +419,7 @@ port_loopback_filter_uc_test()
 
 	log_test "Port loopback filter - unicast"
 
-	devlink_trap_drop_cleanup $mz_pid $swp2
+	devlink_trap_drop_cleanup $mz_pid $swp2 ip
 }
 
 port_loopback_filter_test()
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 931ab26b2555..cbc38cc61873 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -393,7 +393,8 @@ devlink_trap_drop_cleanup()
 {
 	local mz_pid=$1; shift
 	local dev=$1; shift
+	local proto=$1; shift
 
 	kill $mz_pid && wait $mz_pid &> /dev/null
-	tc filter del dev $dev egress protocol ip pref 1 handle 101 flower
+	tc filter del dev $dev egress protocol $proto pref 1 handle 101 flower
 }
-- 
2.21.0

