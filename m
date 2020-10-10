Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DF428A20B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbgJJWx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57131 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730086AbgJJSzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C28EA5C00ED;
        Sat, 10 Oct 2020 11:41:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=LzFo2ytM4eHRIdZ6NhzimzQFKsYlUzXl0tAK1DirEqg=; b=juZ23cgj
        4Jgze6IkxODbWf90jXGWw8Xclh5jpf8yCdrl9YyudIqT3Xtxo3WKuAKGKpk2NGrb
        J3WjWoaf7E+6dnTSzBj8GhdlmrzO0gG/Skmz/NSdeZpO3gi4Jq3L7Fl5TOifqJNR
        zmt+zUTuxFsGJuyUt5DylRkk/2HBVYHHyFosDLWmrMNy5FCBUISSxVODmiQB6yHO
        EPXvdwPg8SkF5KV9qZmKbR0A7Nv6EFoGxBlm5lFAu8sBgITTpwyj1YsXSl+ysZq1
        RySnsye0t3CzZ4bj5HvYuNEMgEJCO+y9rHzmPrPVxCjB4nse+Q2QiTlYJmq7e1w8
        JsktkrEvWEVBvw==
X-ME-Sender: <xms:RNaBX3Hrm8BE_hgh0JXKDwffElYLwE-4i8TUwP6HO46LAdrtIBd6yA>
    <xme:RNaBX0XhDGoFYdX0VAe72Eja0QO7XuOeoJtzMAceyMcD1bG5R8XEfdr7OC3CVmGBb
    4kiImJ7ZviA14o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RNaBX5JA3DJl6sAhPXp2H2JRptGccid8eB7oixHueCB9lbn1JNKtig>
    <xmx:RNaBX1EWRvEfLzSnda4WTiDQomFkKEKIXq36ezJrEvbXcwYxEkfz8w>
    <xmx:RNaBX9UK1L-NUCCnObXTmgbUDYCBh7GiI7dfevQx_8X8oRXIVLCuMw>
    <xmx:RNaBX_IOD9oXdICpy0goJzWkyZn_F73RVV5qj4EDP1Fn823zZaYCtA>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED1293280059;
        Sat, 10 Oct 2020 11:41:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: ethtool: Add support for setting lanes when autoneg is off
Date:   Sat, 10 Oct 2020 18:41:17 +0300
Message-Id: <20201010154119.3537085-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010154119.3537085-1-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when auto negotiation is set to off, the user can force a
specific speed or both speed and duplex. The user cannot influence the
number of lanes that will be forced.

Add support for setting speed along with lanes so one would be able
to choose how many lanes will be forced. When lanes parameter is not
passed from user space, the default of the lanes is the width of the
port.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 40 +++++++++++++------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 7fdebecdc1f2..b8e91792ac08 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -335,7 +335,8 @@ struct mlxsw_sp_port_type_speed_ops {
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
-	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
+	u32 (*to_ptys_speed_lanes)(struct mlxsw_sp *mlxsw_sp, u8 width,
+				   const struct ethtool_link_ksettings *cmd);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
 				  u8 local_port, u32 proto_admin, bool autoneg);
 	void (*reg_ptys_eth_unpack)(struct mlxsw_sp *mlxsw_sp, char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 085e5a0cb654..8a1b5d437822 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -996,12 +996,12 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
 	eth_proto_new = autoneg ?
 		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
-		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
-				   cmd->base.speed);
+		ops->to_ptys_speed_lanes(mlxsw_sp, mlxsw_sp_port->mapping.width,
+					 cmd);
 
 	eth_proto_new = eth_proto_new & eth_proto_cap;
 	if (!eth_proto_new) {
-		netdev_err(dev, "No supported speed requested\n");
+		netdev_err(dev, "No supported speed or lanes requested\n");
 		return -EINVAL;
 	}
 
@@ -1060,6 +1060,7 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 }
 
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
+	.capabilities           = ETHTOOL_CAP_LINK_LANES_SUPPORTED,
 	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_link_ext_state	= mlxsw_sp_port_get_link_ext_state,
@@ -1271,14 +1272,17 @@ mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 	return ptys_proto;
 }
 
-static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
-				   u32 speed)
+static u32 mlxsw_sp1_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 width,
+					 const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto = 0;
 	int i;
 
+	if (cmd->lanes > width)
+		return ptys_proto;
+
 	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (speed == mlxsw_sp1_port_link_mode[i].speed)
+		if (cmd->base.speed == mlxsw_sp1_port_link_mode[i].speed)
 			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
 	}
 	return ptys_proto;
@@ -1307,7 +1311,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
 	.ptys_max_speed			= mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
-	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
+	.to_ptys_speed_lanes		= mlxsw_sp1_to_ptys_speed_lanes,
 	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
 };
@@ -1692,16 +1696,28 @@ mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 	return ptys_proto;
 }
 
-static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
-				   u8 width, u32 speed)
+static u32 mlxsw_sp2_to_ptys_speed_lanes(struct mlxsw_sp *mlxsw_sp, u8 width,
+					 const struct ethtool_link_ksettings *cmd)
 {
 	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	u32 ptys_proto = 0;
+	u8 mask_cmp;
 	int i;
 
+	if (cmd->lanes > width)
+		return ptys_proto;
+
+	if (cmd->lanes == ETHTOOL_LANES_UNKNOWN)
+		/* If number of lanes was not set by user space, force lanes to
+		 * be width, so the number of lanes won't be negotiated.
+		 */
+		mask_cmp = mask_width;
+	else
+		mask_cmp = mlxsw_sp_port_mask_width_get(cmd->lanes);
+
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((speed == mlxsw_sp2_port_link_mode[i].speed) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
+		if (cmd->base.speed == mlxsw_sp2_port_link_mode[i].speed &&
+		    (mask_cmp & mlxsw_sp2_port_link_mode[i].mask_width))
 			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
 	}
 	return ptys_proto;
@@ -1731,7 +1747,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
 	.ptys_max_speed			= mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
-	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
+	.to_ptys_speed_lanes		= mlxsw_sp2_to_ptys_speed_lanes,
 	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
 };
-- 
2.26.2

