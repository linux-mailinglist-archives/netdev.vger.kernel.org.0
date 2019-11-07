Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC2DF34D4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389500AbfKGQnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:17 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50967 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389434AbfKGQnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:16 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9DBA421B8B;
        Thu,  7 Nov 2019 11:43:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WKe4wYaBkTMX/bu3cPa6wvWZe2F/quSKZO9lJFqbvuk=; b=VPbEacvR
        YbVUcEpug0NQi4oRZf3Q0yHcFE4SBiJEeSheFnmRBBSCQ8zWeDFjEUo/1wsC8jGZ
        aT5/crKMjSFUTVbXuNSg9CzSO+6CPYGjby53srfRnfwvy8YkjjRB1x7vIp2QR1ZS
        iH5jrwHzU9priLh8FkGYn1cmaV+w04gFb3VMbnhFFgPEApdaNBOOg77gReaZBEsw
        t9ojHxGbi7HMhpHnpIAa/CLrDDouWbnV266VOh26qjt3qbIdW7h6+1QmVPLSDJvH
        rEmVwTrp5S0xI9KRV+DY1baT/Hetvqi6uxharPWBHO4gO1YAXj2SzhJeLCAQLWcq
        nyeCntOKGvbyYA==
X-ME-Sender: <xms:o0nEXdCbX870Gu0y9bk_1oH6tmWzTq1fQSfCeqfp0hmUmiAmuMHeIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:o0nEXdl6RhhKWMn3_wVgcmn8RbphoOa32cDGYHy1XChF_1LpzqPuaw>
    <xmx:o0nEXWtKQo8QBZBhtM3TY-E0qYspGTayujzzrBOhqPuK4_sP5LiR_w>
    <xmx:o0nEXctFj55j-S82d-K5U-tResVbRvplobqJv1I3H1Rd-jWycWwmIg>
    <xmx:o0nEXTnZbda-gY74UnKyL9FAFNPHaNLD1ASrJwE9l58N9QMn5vQ0EQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19C9980066;
        Thu,  7 Nov 2019 11:43:13 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/12] mlxsw: Add layer 3 devlink-trap support
Date:   Thu,  7 Nov 2019 18:42:10 +0200
Message-Id: <20191107164220.20526-3-idosch@idosch.org>
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

Add the trap IDs and trap group used to report layer 3 drops. Register
layer 3 packet traps and associated layer 3 trap group with devlink
during driver initialization.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 37 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    | 11 ++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index bec035ee5349..5294a1622643 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5480,6 +5480,7 @@ enum mlxsw_reg_htgt_trap_group {
 enum mlxsw_reg_htgt_discard_trap_group {
 	MLXSW_REG_HTGT_DISCARD_TRAP_GROUP_BASE = MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 };
 
 /* reg_htgt_trap_group
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 7c03b661ae7e..f0e6811baa1c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -30,6 +30,16 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(INGRESS_STP_FILTER, L2_DROPS),
 	MLXSW_SP_TRAP_DROP(EMPTY_TX_LIST, L2_DROPS),
 	MLXSW_SP_TRAP_DROP(PORT_LOOPBACK_FILTER, L2_DROPS),
+	MLXSW_SP_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(NON_IP_PACKET, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(UC_DIP_MC_DMAC, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(DIP_LB, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(SIP_MC, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(SIP_LB, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(CORRUPTED_IP_HDR, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(IPV4_SIP_BC, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_RESERVED_SCOPE, L3_DROPS),
+	MLXSW_SP_TRAP_DROP(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DROPS),
 };
 
 static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -40,6 +50,16 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 	MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_UC, L2_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_MC_NULL, L2_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(LOOKUP_SWITCH_LB, L2_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ROUTER2, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_NON_IP_PACKET, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_UC_DIP_MC_DMAC, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_DIP_LB, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_SIP_MC, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_SIP_LB, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_CORRUPTED_IP_HDR, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(ING_ROUTER_IPV4_SIP_BC, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_RESERVED_SCOPE, L3_DISCARDS),
+	MLXSW_SP_RXL_DISCARD(IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE, L3_DISCARDS),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -54,6 +74,16 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_EMPTY_TX_LIST,
 	DEVLINK_TRAP_GENERIC_ID_EMPTY_TX_LIST,
 	DEVLINK_TRAP_GENERIC_ID_PORT_LOOPBACK_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_BLACKHOLE_ROUTE,
+	DEVLINK_TRAP_GENERIC_ID_NON_IP_PACKET,
+	DEVLINK_TRAP_GENERIC_ID_UC_DIP_MC_DMAC,
+	DEVLINK_TRAP_GENERIC_ID_DIP_LB,
+	DEVLINK_TRAP_GENERIC_ID_SIP_MC,
+	DEVLINK_TRAP_GENERIC_ID_SIP_LB,
+	DEVLINK_TRAP_GENERIC_ID_CORRUPTED_IP_HDR,
+	DEVLINK_TRAP_GENERIC_ID_IPV4_SIP_BC,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_RESERVED_SCOPE,
+	DEVLINK_TRAP_GENERIC_ID_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
@@ -211,6 +241,7 @@ mlxsw_sp_trap_group_policer_init(struct mlxsw_sp *mlxsw_sp,
 	u32 rate;
 
 	switch (group->id) {
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:/* fall through */
 	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS:
 		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		ir_units = MLXSW_REG_QPCR_IR_UNITS_M;
@@ -242,6 +273,12 @@ __mlxsw_sp_trap_group_init(struct mlxsw_sp *mlxsw_sp,
 		priority = 0;
 		tc = 1;
 		break;
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:
+		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS;
+		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
+		priority = 0;
+		tc = 1;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 7618f084cae9..a4969982fce1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -66,6 +66,7 @@ enum {
 	MLXSW_TRAP_ID_NVE_ENCAP_ARP = 0xBD,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
+	MLXSW_TRAP_ID_DISCARD_ROUTER2 = 0x130,
 	MLXSW_TRAP_ID_DISCARD_ING_PACKET_SMAC_MC = 0x140,
 	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VTAG_ALLOW = 0x148,
 	MLXSW_TRAP_ID_DISCARD_ING_SWITCH_VLAN = 0x149,
@@ -73,6 +74,16 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_UC = 0x150,
 	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_MC_NULL = 0x151,
 	MLXSW_TRAP_ID_DISCARD_LOOKUP_SWITCH_LB = 0x152,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_NON_IP_PACKET = 0x160,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_UC_DIP_MC_DMAC = 0x161,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_DIP_LB = 0x162,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_MC = 0x163,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_LB = 0x165,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_CORRUPTED_IP_HDR = 0x167,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
+	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_RESERVED_SCOPE = 0x1B0,
+	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE = 0x1B1,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
 	/* Multicast trap used for routes with trap action */
 	MLXSW_TRAP_ID_ACL1 = 0x1C1,
-- 
2.21.0

