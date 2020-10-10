Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2D128A43E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbgJJWyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39635 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729832AbgJJSzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9285C5C00EF;
        Sat, 10 Oct 2020 11:41:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=trjzgLH7QB83sIMoewhViMlnwhM7oC54KWjIAFi5mkw=; b=pmKcWd/b
        VINcIDaTMEQPNKW76LYTdEHkBk7PzcI5tXxfZ+G3AqKIBf3+mSY2vnry73Qn1Vwn
        QCo3x+Uzq3vsy+cE6qRq7kQf5I/F+OKFE5Uz+hfFGK2Lqu2jvjN4EnBjITam9i8Z
        f4n3O1uJnWeDkXiNvA6uaxq/xd7/w/C6rSMDmyt4Xmoc8JbEGTuQTMOdwbIul5SK
        VhC2RziXxKwPgw1XqtM/MakPU4/z5ygL+ZguxaQr+8I1yJ4OsOOjRHKwjdlfJWL9
        xQ8BZqPLBToN/xNB+uzyyGsVouzkde0YAcul8/Sg9nimsQ8u4o/LPEqPBO0xsLaE
        cip6uiwEUUW6Uw==
X-ME-Sender: <xms:RtaBX3EKQOinROpVOF-g7N92zP3G_ZK7rV8EhP0Ut2_8M45at_jVpg>
    <xme:RtaBX0UUyFKmT0aN3tMSofiiYLgtzWRLZNDhy5sxGf-2f0EsnwdikYKg5IrS15aah
    c8Ve0wWQNGwh14>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RtaBX5L3Yn6Pyx7l4oP3QhdDG8djOTf0Eeucb8M9pnHkmwLibwKZWg>
    <xmx:RtaBX1EBDNZ_VsgO6zhe_I7tRVwHV98h6ta-9ZPWCujEzAWYngyU2A>
    <xmx:RtaBX9UZO53HCEql9k25XBk6Y7O-uu5eIfHjK4T6ARJJ4kPggmSK9Q>
    <xmx:RtaBX_Lt-D6R-UdBX84nI0vhVWxAW6i3s8U8nhMK5n7CXQsUZakp1A>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1C893280059;
        Sat, 10 Oct 2020 11:41:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: ethtool: Expose the number of lanes in use
Date:   Sat, 10 Oct 2020 18:41:18 +0300
Message-Id: <20201010154119.3537085-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010154119.3537085-1-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the driver does not expose how many lanes are used when the
link is up.

Extract the lanes information from the device and expose it to ethtool.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 83 ++++++++++++++++---
 2 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b8e91792ac08..84aee7d08ab4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -329,9 +329,9 @@ struct mlxsw_sp_port_type_speed_ops {
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
-	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
-				       bool carrier_ok, u32 ptys_eth_proto,
-				       struct ethtool_link_ksettings *cmd);
+	void (*from_ptys_speed_lanes_duplex)(struct mlxsw_sp *mlxsw_sp,
+					     bool carrier_ok, u32 ptys_eth_proto,
+					     struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 8a1b5d437822..6675d5e0d9d4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -966,8 +966,8 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
-	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
-				    eth_proto_oper, cmd);
+	ops->from_ptys_speed_lanes_duplex(mlxsw_sp, netif_carrier_ok(dev),
+					  eth_proto_oper, cmd);
 
 	return 0;
 }
@@ -1081,6 +1081,7 @@ struct mlxsw_sp1_port_link_mode {
 	enum ethtool_link_mode_bit_indices mask_ethtool;
 	u32 mask;
 	u32 speed;
+	u32 width;
 };
 
 static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
@@ -1089,12 +1090,14 @@ static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
 				  MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
 		.speed		= SPEED_1000,
+		.width		= ETHTOOL_LANES_1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
 		.speed		= SPEED_10000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KR |
@@ -1103,71 +1106,85 @@ static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
 				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_ER_LR,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
 		.speed		= SPEED_10000,
+		.width		= ETHTOOL_LANES_1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
 		.speed		= SPEED_40000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
 		.speed		= SPEED_40000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_SR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
 		.speed		= SPEED_40000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_LR4_ER4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
 		.speed		= SPEED_40000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
 		.speed		= SPEED_25000,
+		.width		= ETHTOOL_LANES_1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
 		.speed		= SPEED_25000,
+		.width		= ETHTOOL_LANES_1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
 		.speed		= SPEED_25000,
+		.width		= ETHTOOL_LANES_1,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_CR2,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
 		.speed		= SPEED_50000,
+		.width		= ETHTOOL_LANES_2,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_KR2,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
 		.speed		= SPEED_50000,
+		.width		= ETHTOOL_LANES_2,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_SR2,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
 		.speed		= SPEED_50000,
+		.width		= ETHTOOL_LANES_2,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
 		.speed		= SPEED_100000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
 		.speed		= SPEED_100000,
+		.width		= ETHTOOL_LANES_4,
 	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
 		.speed		= SPEED_100000,
+		.width		= ETHTOOL_LANES_4,
 	},
 };
 
@@ -1220,20 +1237,36 @@ mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
 	return SPEED_UNKNOWN;
 }
 
+static u32
+mlxsw_sp1_from_ptys_lanes(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			return mlxsw_sp1_port_link_mode[i].width;
+	}
+
+	return ETHTOOL_LANES_UNKNOWN;
+}
+
 static void
-mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp1_from_ptys_speed_lanes_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+				       u32 ptys_eth_proto,
+				       struct ethtool_link_ksettings *cmd)
 {
 	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->lanes = ETHTOOL_LANES_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 
 	if (!carrier_ok)
 		return;
 
 	cmd->base.speed = mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
+	if (cmd->base.speed != SPEED_UNKNOWN) {
+		cmd->lanes = mlxsw_sp1_from_ptys_lanes(mlxsw_sp, ptys_eth_proto);
 		cmd->base.duplex = DUPLEX_FULL;
+	}
 }
 
 static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
@@ -1308,7 +1341,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
+	.from_ptys_speed_lanes_duplex	= mlxsw_sp1_from_ptys_speed_lanes_duplex,
 	.ptys_max_speed			= mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed_lanes		= mlxsw_sp1_to_ptys_speed_lanes,
@@ -1629,20 +1662,46 @@ mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
 	return SPEED_UNKNOWN;
 }
 
+static u32
+mlxsw_sp2_from_ptys_lanes(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
+{
+	u8 width;
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
+			width = mlxsw_sp2_port_link_mode[i].mask_width;
+			if (width & MLXSW_SP_PORT_MASK_WIDTH_1X)
+				return ETHTOOL_LANES_1;
+			else if (width & MLXSW_SP_PORT_MASK_WIDTH_2X)
+				return ETHTOOL_LANES_2;
+			else if (width & MLXSW_SP_PORT_MASK_WIDTH_4X)
+				return ETHTOOL_LANES_4;
+			else if (width & MLXSW_SP_PORT_MASK_WIDTH_8X)
+				return ETHTOOL_LANES_8;
+		}
+	}
+
+	return ETHTOOL_LANES_UNKNOWN;
+}
+
 static void
-mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp2_from_ptys_speed_lanes_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+				       u32 ptys_eth_proto,
+				       struct ethtool_link_ksettings *cmd)
 {
 	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->lanes = ETHTOOL_LANES_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 
 	if (!carrier_ok)
 		return;
 
 	cmd->base.speed = mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
+	if (cmd->base.speed != SPEED_UNKNOWN) {
+		cmd->lanes = mlxsw_sp2_from_ptys_lanes(mlxsw_sp, ptys_eth_proto);
 		cmd->base.duplex = DUPLEX_FULL;
+	}
 }
 
 static int mlxsw_sp2_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed)
@@ -1744,7 +1803,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
 	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
+	.from_ptys_speed_lanes_duplex	= mlxsw_sp2_from_ptys_speed_lanes_duplex,
 	.ptys_max_speed			= mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed_lanes		= mlxsw_sp2_to_ptys_speed_lanes,
-- 
2.26.2

