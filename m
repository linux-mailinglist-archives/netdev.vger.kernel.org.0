Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F353141DEC
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgASNBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:42 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44167 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727586AbgASNBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:40 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E49E621A4B;
        Sun, 19 Jan 2020 08:01:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/oT4AqG70wpqRwqXz2UivkAMO6w2v+Hlvxp1EvBvkiU=; b=CZu8tnOG
        3Qzm9tv4B9Xm7QEMXPtCClT5hkVl/mX0TZv9DphkfXeyOD8IlmFcCX5kNNHoR8oB
        N2x0nlSevWWrAg1A/i9jb7ih4Jf3EjMOS/koHZ3u4dF7hgRIplZf5ZTDzSD04PFg
        7uEuf4U3+zAmsdBxRo3RKIcBplPSu0BXJmxhjFffq22YXaKBaQ0D3iGTJqNTRA59
        oqBSq+raDIIp1VTMppCYAvHKXYj7FKuRSD0SOMpKCiErn2HtNNQf9VFbCubtOih6
        CicznjWEcbP4rFhq1sv2tq0SG2oSalCcKC5QvEy3Rq3aCgO5rwQYmOi2LUz8xh7G
        RduDOOLipiU/jA==
X-ME-Sender: <xms:MlMkXtgeWMTADQOixLKOQXClB0Dg4QtHFPmbO3iG37P2MnyFZqf7IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:MlMkXnOKY-tfLwtC-tZn2gSztPMRPI1-fjfkkVHyWuanHkWrJkqWfA>
    <xmx:MlMkXtobFp8nZip_bywkGNtA4Y7YaTXang0M1TmfLX621NWSnyS_IA>
    <xmx:MlMkXtKv2R7uVPTd1IsLJo4UY1cp9fDx8jLkSoY3U03vIaUwZp00tQ>
    <xmx:MlMkXox3-3mvkYAbGEyQ6RRCITi9IblhFILL0vUA44-QG7kFdHKf4w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 945228005A;
        Sun, 19 Jan 2020 08:01:37 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/15] mlxsw: Add tunnel devlink-trap support
Date:   Sun, 19 Jan 2020 15:00:55 +0200
Message-Id: <20200119130100.3179857-11-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add the trap IDs and trap group used to report tunnel drops. Register
tunnel packet traps and associated tunnel trap group with devlink
during driver initialization.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      |  1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  2 --
 .../ethernet/mellanox/mlxsw/spectrum_trap.c    | 18 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/trap.h     |  1 +
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 47c29776d5d9..0b80e75e87c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5513,6 +5513,7 @@ enum mlxsw_reg_htgt_discard_trap_group {
 	MLXSW_REG_HTGT_DISCARD_TRAP_GROUP_BASE = MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 };
 
 /* reg_htgt_trap_group
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2f0b516ee03f..cc30a69a6df0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4538,8 +4538,6 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			  false),
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPIP_DECAP_ERROR, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(DECAP_ECN0, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_CLASS_E, FORWARD,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 5ae60eb11a2d..b03bb3a54fc8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -81,6 +81,7 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DRIVER_DROP(IRIF_DISABLED, L3_DROPS),
 	MLXSW_SP_TRAP_DRIVER_DROP(ERIF_DISABLED, L3_DROPS),
 	MLXSW_SP_TRAP_DROP(NON_ROUTABLE, L3_DROPS),
+	MLXSW_SP_TRAP_EXCEPTION(DECAP_ERROR, TUNNEL_DROPS),
 };
 
 static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
@@ -116,6 +117,11 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 	MLXSW_SP_RXL_DISCARD(ROUTER_IRIF_EN, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(ROUTER_ERIF_EN, L3_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(NON_ROUTABLE, L3_DISCARDS),
+	MLXSW_SP_RXL_EXCEPTION(DECAP_ECN0, ROUTER_EXP, TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(IPIP_DECAP_ERROR, ROUTER_EXP,
+			       TRAP_EXCEPTION_TO_CPU),
+	MLXSW_SP_RXL_EXCEPTION(DISCARD_DEC_PKT, TUNNEL_DISCARDS,
+			       TRAP_EXCEPTION_TO_CPU),
 };
 
 /* Mapping between hardware trap and devlink trap. Multiple hardware traps can
@@ -152,6 +158,9 @@ static u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_MLXSW_TRAP_ID_IRIF_DISABLED,
 	DEVLINK_MLXSW_TRAP_ID_ERIF_DISABLED,
 	DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE,
+	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
+	DEVLINK_TRAP_GENERIC_ID_DECAP_ERROR,
 };
 
 static int mlxsw_sp_rx_listener(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
@@ -334,7 +343,8 @@ mlxsw_sp_trap_group_policer_init(struct mlxsw_sp *mlxsw_sp,
 
 	switch (group->id) {
 	case DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS: /* fall through */
-	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS:
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS: /* fall through */
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS:
 		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
 		ir_units = MLXSW_REG_QPCR_IR_UNITS_M;
 		is_bytes = false;
@@ -371,6 +381,12 @@ __mlxsw_sp_trap_group_init(struct mlxsw_sp *mlxsw_sp,
 		priority = 0;
 		tc = 1;
 		break;
+	case DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS:
+		group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS;
+		policer_id = MLXSW_SP_DISCARD_POLICER_ID;
+		priority = 0;
+		tc = 1;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 7d07ec8d440b..24f92b157dfb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -93,6 +93,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ROUTER_ERIF_EN = 0x179,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM6 = 0x17C,
+	MLXSW_TRAP_ID_DISCARD_DEC_PKT = 0x188,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_RESERVED_SCOPE = 0x1B0,
 	MLXSW_TRAP_ID_DISCARD_IPV6_MC_DIP_INTERFACE_LOCAL_SCOPE = 0x1B1,
 	MLXSW_TRAP_ID_ACL0 = 0x1C0,
-- 
2.24.1

