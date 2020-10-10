Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149CE28A20C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388483AbgJJWyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:01 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38789 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730365AbgJJSzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:55:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DC6FB5C009E;
        Sat, 10 Oct 2020 11:41:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 10 Oct 2020 11:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=DZbxl8JIaB+Mi14iiHapwhRaHncmmZWDAriBh7MGB9A=; b=BoC9ATVh
        JW9n5IHi6NtRM4hccVVkXh2vraumnwH9mqMvTP4bJpae6e2posqrixZRzzrYEzIk
        HymK99yKRhkbHx8l5O8jq1+3m27YniYDuEcorc7e8Y3SoY8GGK8s929d/l1NFC2g
        Yna2lbgMpnpGtvQ4QUSjJ5TRYWsHnoYe2U71hDoku0uv9BykGYeh5TqIroSvaiyM
        I9DTOcyyMopBX3uRXmwxD1eSRYu+kh//OcPeA4ONWKjlK9TSSvShWjA44zgcKO/0
        lAy8xNHzdBBw/jJzY8fU6ahxSDTKgGaxItvviL2o6VEa0vu0IIQQIinruNS7PoCa
        A6KqZOYj8JG/IA==
X-ME-Sender: <xms:QtaBX83nlDbv6G-ozaHuGfip4MrCAso2ezMJXSOj0sv2zgapFr-39g>
    <xme:QtaBX3H8msRsRVP4D6Bo008tvRMyrK7RT8kzVEadNfzW21-VNqjFIzDYqidGqvDcy
    4Bf7Bg4vGP6C_c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QtaBX05aV6L875Ier6VxtEIr6F9k-Y3SxYyRVzHo4UtcmeyH5JpwBw>
    <xmx:QtaBX13zHsPxokEVoPX_YlaKARIzQgQwNSNUXXqyi41tadXNNgXLsQ>
    <xmx:QtaBX_Hw0h6ZK69RwHdruR6VSYLIW1VfDmFZ8ISceye4k7H3wqTzEg>
    <xmx:QtaBX07a75kZRXwwqcKYe643kZpS11Nnbnk9v9Gfmsgv5ML1G4Fchw>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 143C93280059;
        Sat, 10 Oct 2020 11:41:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: ethtool: Remove max lanes filtering
Date:   Sat, 10 Oct 2020 18:41:16 +0300
Message-Id: <20201010154119.3537085-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010154119.3537085-1-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, when a speed can be supported by different number of lanes,
the supported link modes bitmask contains only link modes with a single
number of lanes.

This was done in order to prevent auto negotiation on number of
lanes after 50G-1-lane and 100G-2-lanes link modes were introduced.

For example, if a port's max width is 4, only link modes with 4 lanes
will be presented as supported by that port, so 100G is always achieved by
4 lanes of 25G.

After the previous patches that allow selection of the number of lanes,
auto negotiation on number of lanes becomes practical.

Remove that filtering of the maximum number of lanes supported link modes,
so indeed all the supported and advertised link modes will be shown.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 33 ++++++++-----------
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3e26eb6cb140..7fdebecdc1f2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -327,13 +327,13 @@ struct mlxsw_sp_port_type_speed_ops {
 					 u32 ptys_eth_proto,
 					 struct ethtool_link_ksettings *cmd);
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			       u8 width, unsigned long *mode);
+			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
 	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
 				       bool carrier_ok, u32 ptys_eth_proto,
 				       struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_speed);
-	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp, u8 width,
+	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
 	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 2096b6478958..085e5a0cb654 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -858,7 +858,7 @@ static int mlxsw_sp_port_get_sset_count(struct net_device *dev, int sset)
 
 static void
 mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
-				 u8 width, struct ethtool_link_ksettings *cmd)
+				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
 
@@ -869,13 +869,13 @@ mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
 	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 
 	ops->from_ptys_supported_port(mlxsw_sp, eth_proto_cap, cmd);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, width,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_cap,
 			    cmd->link_modes.supported);
 }
 
 static void
 mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
-				 u32 eth_proto_admin, bool autoneg, u8 width,
+				 u32 eth_proto_admin, bool autoneg,
 				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
@@ -886,7 +886,7 @@ mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
 		return;
 
 	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_admin, width,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_admin,
 			    cmd->link_modes.advertising);
 }
 
@@ -960,11 +960,9 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 	ops = mlxsw_sp->port_type_speed_ops;
 	autoneg = mlxsw_sp_port->link.autoneg;
 
-	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
-					 mlxsw_sp_port->mapping.width, cmd);
+	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap, cmd);
 
-	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg,
-					 mlxsw_sp_port->mapping.width, cmd);
+	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg, cmd);
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
@@ -997,8 +995,7 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 
 	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
 	eth_proto_new = autoneg ?
-		ops->to_ptys_advert_link(mlxsw_sp, mlxsw_sp_port->mapping.width,
-					 cmd) :
+		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
 		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
 				   cmd->base.speed);
 
@@ -1198,7 +1195,7 @@ mlxsw_sp1_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
+			 unsigned long *mode)
 {
 	int i;
 
@@ -1260,7 +1257,7 @@ static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_
 }
 
 static u32
-mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 			      const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto = 0;
@@ -1604,14 +1601,12 @@ mlxsw_sp2_set_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 
 static void
 mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
+			 unsigned long *mode)
 {
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
 			mlxsw_sp2_set_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 						  mode);
 	}
@@ -1683,16 +1678,14 @@ mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
 }
 
 static u32
-mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 			      const struct ethtool_link_ksettings *cmd)
 {
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
 	u32 ptys_proto = 0;
 	int i;
 
 	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((mask_width & mlxsw_sp2_port_link_mode[i].mask_width) &&
-		    mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
+		if (mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 					       cmd->link_modes.advertising))
 			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
 	}
-- 
2.26.2

