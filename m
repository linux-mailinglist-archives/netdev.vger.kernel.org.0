Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3507A206EDF
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390385AbgFXIUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:34 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:59555 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390376AbgFXIUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0914C58051A;
        Wed, 24 Jun 2020 04:20:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oZ5GhLyDvfr1ZsM0RwpBB/R1BRipWu6NAQ9NUNZ8nJw=; b=j7VVVjm5
        g138BMPgkc7pDvtIt7nhusg4URkB+bKMA1OB49aeEgZY1qpUAKVyLzvQixNy6NsK
        1dqn7DXY+ngJYWqNDC5ZGD2kbQGPZrV2i4YZkzdtGyGrBC/ofiZn2lLMTWW1N+o3
        qpzI/5Q/zW/l67fIv9qZGe9iZ3QhJdsm59tkb7SG/s6xXYpSKVW/rO9t+e59sGkO
        lrpJts3YzgMpHWK5I2vU5j2snPjWSQzWqFVEeQ5twnAMO5nXRWYISqwrIr+hVnvp
        qCYuTqJsoDkoXvfDrbRI9HWd2njAnLyIHK7mEJA0AkblKgBzjdsMUpAWpf++9uFQ
        xYTKwxLzGJTYlw==
X-ME-Sender: <xms:yQzzXiVB7HAlqfQsiHT3xoic-dp0O1uRhG2Q3nvHpnJN02FIfynSRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yQzzXukWMcMDWQ9YHAb8NBxFigbUOe4_c95h1Yyure3477--WednvQ>
    <xmx:yQzzXmZvqFrjko5r07L8vC9l-ZXJIOVlno4OygKlK4K54GxfIUe2jg>
    <xmx:yQzzXpV-uFjUMl0ENIvh0_VFz-uyFmVltwVqe1kaf3u0RxbUZoUyCg>
    <xmx:ygzzXm79iUfk8euAqzI-zoxIWaFLBNAIsf93TbopHwXWcfYyThGmCg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C141430675FA;
        Wed, 24 Jun 2020 04:20:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_ethtool: Move mlxsw_sp_port_type_speed_ops structs
Date:   Wed, 24 Jun 2020 11:19:16 +0300
Message-Id: <20200624081923.89483-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Move mlxsw_sp1_port_type_speed_ops and mlxsw_sp2_port_type_speed_ops
with the relevant code from spectrum.c to spectrum_ethtool.c.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 660 ------------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 658 +++++++++++++++++
 3 files changed, 660 insertions(+), 660 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3f846177b883..feb92df677fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1528,666 +1528,6 @@ static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_do_ioctl		= mlxsw_sp_port_ioctl,
 };
 
-struct mlxsw_sp1_port_link_mode {
-	enum ethtool_link_mode_bit_indices mask_ethtool;
-	u32 mask;
-	u32 speed;
-};
-
-static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100BASE_T,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-		.speed		= SPEED_100,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_SGMII |
-				  MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-		.speed		= SPEED_1000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_T,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
-		.speed		= SPEED_10000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4 |
-				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
-		.speed		= SPEED_10000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KR |
-				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CR |
-				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_SR |
-				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_ER_LR,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-		.speed		= SPEED_10000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_20GBASE_KR2,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
-		.speed		= SPEED_20000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
-		.speed		= SPEED_40000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
-		.speed		= SPEED_40000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_SR4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
-		.speed		= SPEED_40000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_LR4_ER4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
-		.speed		= SPEED_40000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-		.speed		= SPEED_25000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-		.speed		= SPEED_25000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
-		.speed		= SPEED_25000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_CR2,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
-		.speed		= SPEED_50000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_KR2,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
-		.speed		= SPEED_50000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_SR2,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
-		.speed		= SPEED_50000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
-		.speed		= SPEED_100000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
-		.speed		= SPEED_100000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-		.speed		= SPEED_100000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
-		.speed		= SPEED_100000,
-	},
-};
-
-#define MLXSW_SP1_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp1_port_link_mode)
-
-static void
-mlxsw_sp1_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
-				   u32 ptys_eth_proto,
-				   struct ethtool_link_ksettings *cmd)
-{
-	if (ptys_eth_proto & (MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CR |
-			      MLXSW_REG_PTYS_ETH_SPEED_10GBASE_SR |
-			      MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4 |
-			      MLXSW_REG_PTYS_ETH_SPEED_40GBASE_SR4 |
-			      MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4 |
-			      MLXSW_REG_PTYS_ETH_SPEED_SGMII))
-		ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
-
-	if (ptys_eth_proto & (MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KR |
-			      MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4 |
-			      MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4 |
-			      MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4 |
-			      MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX))
-		ethtool_link_ksettings_add_link_mode(cmd, supported, Backplane);
-}
-
-static void
-mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
-{
-	int i;
-
-	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
-			__set_bit(mlxsw_sp1_port_link_mode[i].mask_ethtool,
-				  mode);
-	}
-}
-
-static u32
-mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
-{
-	int i;
-
-	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
-			return mlxsw_sp1_port_link_mode[i].speed;
-	}
-
-	return SPEED_UNKNOWN;
-}
-
-static void
-mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
-{
-	cmd->base.speed = SPEED_UNKNOWN;
-	cmd->base.duplex = DUPLEX_UNKNOWN;
-
-	if (!carrier_ok)
-		return;
-
-	cmd->base.speed = mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
-		cmd->base.duplex = DUPLEX_FULL;
-}
-
-static u32
-mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
-			      const struct ethtool_link_ksettings *cmd)
-{
-	u32 ptys_proto = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (test_bit(mlxsw_sp1_port_link_mode[i].mask_ethtool,
-			     cmd->link_modes.advertising))
-			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
-	}
-	return ptys_proto;
-}
-
-static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
-				   u32 speed)
-{
-	u32 ptys_proto = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (speed == mlxsw_sp1_port_link_mode[i].speed)
-			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
-	}
-	return ptys_proto;
-}
-
-static void
-mlxsw_sp1_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
-			    u8 local_port, u32 proto_admin, bool autoneg)
-{
-	mlxsw_reg_ptys_eth_pack(payload, local_port, proto_admin, autoneg);
-}
-
-static void
-mlxsw_sp1_reg_ptys_eth_unpack(struct mlxsw_sp *mlxsw_sp, char *payload,
-			      u32 *p_eth_proto_cap, u32 *p_eth_proto_admin,
-			      u32 *p_eth_proto_oper)
-{
-	mlxsw_reg_ptys_eth_unpack(payload, p_eth_proto_cap, p_eth_proto_admin,
-				  p_eth_proto_oper);
-}
-
-static const struct mlxsw_sp_port_type_speed_ops
-mlxsw_sp1_port_type_speed_ops = {
-	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
-	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
-	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
-	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
-	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
-	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
-	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
-};
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_sgmii_100m[] = {
-	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_sgmii_100m)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_1000base_x_sgmii[] = {
-	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_1000base_x_sgmii)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii[] = {
-	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_5gbase_r[] = {
-	ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_5gbase_r)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g[] = {
-	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
-	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
-	ETHTOOL_LINK_MODE_10000baseR_FEC_BIT,
-	ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
-	ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
-	ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
-	ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g[] = {
-	ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
-	ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
-	ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
-	ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr[] = {
-	ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
-	ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
-	ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2[] = {
-	ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
-	ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
-	ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr[] = {
-	ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
-	ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
-	ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
-	ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
-	ETHTOOL_LINK_MODE_50000baseDR_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4[] = {
-	ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2[] = {
-	ETHTOOL_LINK_MODE_100000baseKR2_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseSR2_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseCR2_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseLR2_ER2_FR2_Full_BIT,
-	ETHTOOL_LINK_MODE_100000baseDR2_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4[] = {
-	ETHTOOL_LINK_MODE_200000baseKR4_Full_BIT,
-	ETHTOOL_LINK_MODE_200000baseSR4_Full_BIT,
-	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
-	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
-	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4)
-
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_400gaui_8[] = {
-	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT,
-	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT,
-	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT,
-	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT,
-	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_400gaui_8)
-
-#define MLXSW_SP_PORT_MASK_WIDTH_1X	BIT(0)
-#define MLXSW_SP_PORT_MASK_WIDTH_2X	BIT(1)
-#define MLXSW_SP_PORT_MASK_WIDTH_4X	BIT(2)
-#define MLXSW_SP_PORT_MASK_WIDTH_8X	BIT(3)
-
-static u8 mlxsw_sp_port_mask_width_get(u8 width)
-{
-	switch (width) {
-	case 1:
-		return MLXSW_SP_PORT_MASK_WIDTH_1X;
-	case 2:
-		return MLXSW_SP_PORT_MASK_WIDTH_2X;
-	case 4:
-		return MLXSW_SP_PORT_MASK_WIDTH_4X;
-	case 8:
-		return MLXSW_SP_PORT_MASK_WIDTH_8X;
-	default:
-		WARN_ON_ONCE(1);
-		return 0;
-	}
-}
-
-struct mlxsw_sp2_port_link_mode {
-	const enum ethtool_link_mode_bit_indices *mask_ethtool;
-	int m_ethtool_len;
-	u32 mask;
-	u32 speed;
-	u8 mask_width;
-};
-
-static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_SGMII_100M,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_sgmii_100m,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
-				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_100,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_1000BASE_X_SGMII,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_1000base_x_sgmii,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
-				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_1000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_2_5GBASE_X_2_5GMII,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
-				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_2500,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_5gbase_r,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
-				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_5000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XFI_XAUI_1_10G,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
-				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_10000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_40000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_25GAUI_1_25GBASE_CR_KR,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
-				  MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_25000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_2_LAUI_2_50GBASE_CR2_KR2,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
-				  MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_50000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_1_LAUI_1_50GBASE_CR_KR,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X,
-		.speed		= SPEED_50000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_100000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X,
-		.speed		= SPEED_100000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
-				  MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_200000,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8,
-		.mask_ethtool	= mlxsw_sp2_mask_ethtool_400gaui_8,
-		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN,
-		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
-		.speed		= SPEED_400000,
-	},
-};
-
-#define MLXSW_SP2_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp2_port_link_mode)
-
-static void
-mlxsw_sp2_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
-				   u32 ptys_eth_proto,
-				   struct ethtool_link_ksettings *cmd)
-{
-	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Backplane);
-}
-
-static void
-mlxsw_sp2_set_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
-			  unsigned long *mode)
-{
-	int i;
-
-	for (i = 0; i < link_mode->m_ethtool_len; i++)
-		__set_bit(link_mode->mask_ethtool[i], mode);
-}
-
-static void
-mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
-{
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
-	int i;
-
-	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
-			mlxsw_sp2_set_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
-						  mode);
-	}
-}
-
-static u32
-mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
-{
-	int i;
-
-	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
-			return mlxsw_sp2_port_link_mode[i].speed;
-	}
-
-	return SPEED_UNKNOWN;
-}
-
-static void
-mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
-{
-	cmd->base.speed = SPEED_UNKNOWN;
-	cmd->base.duplex = DUPLEX_UNKNOWN;
-
-	if (!carrier_ok)
-		return;
-
-	cmd->base.speed = mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed != SPEED_UNKNOWN)
-		cmd->base.duplex = DUPLEX_FULL;
-}
-
-static bool
-mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
-			   const unsigned long *mode)
-{
-	int cnt = 0;
-	int i;
-
-	for (i = 0; i < link_mode->m_ethtool_len; i++) {
-		if (test_bit(link_mode->mask_ethtool[i], mode))
-			cnt++;
-	}
-
-	return cnt == link_mode->m_ethtool_len;
-}
-
-static u32
-mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
-			      const struct ethtool_link_ksettings *cmd)
-{
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
-	u32 ptys_proto = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((mask_width & mlxsw_sp2_port_link_mode[i].mask_width) &&
-		    mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
-					       cmd->link_modes.advertising))
-			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
-	}
-	return ptys_proto;
-}
-
-static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
-				   u8 width, u32 speed)
-{
-	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
-	u32 ptys_proto = 0;
-	int i;
-
-	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((speed == mlxsw_sp2_port_link_mode[i].speed) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
-			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
-	}
-	return ptys_proto;
-}
-
-static void
-mlxsw_sp2_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
-			    u8 local_port, u32 proto_admin,
-			    bool autoneg)
-{
-	mlxsw_reg_ptys_ext_eth_pack(payload, local_port, proto_admin, autoneg);
-}
-
-static void
-mlxsw_sp2_reg_ptys_eth_unpack(struct mlxsw_sp *mlxsw_sp, char *payload,
-			      u32 *p_eth_proto_cap, u32 *p_eth_proto_admin,
-			      u32 *p_eth_proto_oper)
-{
-	mlxsw_reg_ptys_ext_eth_unpack(payload, p_eth_proto_cap,
-				      p_eth_proto_admin, p_eth_proto_oper);
-}
-
-static const struct mlxsw_sp_port_type_speed_ops
-mlxsw_sp2_port_type_speed_ops = {
-	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
-	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
-	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
-	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
-	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
-	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
-	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
-	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
-};
-
 static int
 mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index fe997afdbbd6..c92a2b3e0f19 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1170,5 +1170,7 @@ static inline struct net *mlxsw_sp_net(struct mlxsw_sp *mlxsw_sp)
 
 /* spectrum_ethtool.c */
 extern const struct ethtool_ops mlxsw_sp_port_ethtool_ops;
+extern const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops;
+extern const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops;
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 7c03c749b563..04e1db604c69 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -839,3 +839,661 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_module_eeprom	= mlxsw_sp_get_module_eeprom,
 	.get_ts_info		= mlxsw_sp_get_ts_info,
 };
+
+struct mlxsw_sp1_port_link_mode {
+	enum ethtool_link_mode_bit_indices mask_ethtool;
+	u32 mask;
+	u32 speed;
+};
+
+static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100BASE_T,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+		.speed		= SPEED_100,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_SGMII |
+				  MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+		.speed		= SPEED_1000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_T,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+		.speed		= SPEED_10000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4 |
+				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+		.speed		= SPEED_10000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KR |
+				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CR |
+				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_SR |
+				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_ER_LR,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+		.speed		= SPEED_10000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_20GBASE_KR2,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
+		.speed		= SPEED_20000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+		.speed		= SPEED_40000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+		.speed		= SPEED_40000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_SR4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+		.speed		= SPEED_40000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_LR4_ER4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+		.speed		= SPEED_40000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+		.speed		= SPEED_25000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+		.speed		= SPEED_25000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+		.speed		= SPEED_25000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_CR2,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
+		.speed		= SPEED_50000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_KR2,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
+		.speed		= SPEED_50000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_50GBASE_SR2,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
+		.speed		= SPEED_50000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+		.speed		= SPEED_100000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+		.speed		= SPEED_100000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+		.speed		= SPEED_100000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+		.speed		= SPEED_100000,
+	},
+};
+
+#define MLXSW_SP1_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp1_port_link_mode)
+
+static void
+mlxsw_sp1_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
+				   u32 ptys_eth_proto,
+				   struct ethtool_link_ksettings *cmd)
+{
+	if (ptys_eth_proto & (MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CR |
+			      MLXSW_REG_PTYS_ETH_SPEED_10GBASE_SR |
+			      MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4 |
+			      MLXSW_REG_PTYS_ETH_SPEED_40GBASE_SR4 |
+			      MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4 |
+			      MLXSW_REG_PTYS_ETH_SPEED_SGMII))
+		ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+
+	if (ptys_eth_proto & (MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KR |
+			      MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4 |
+			      MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4 |
+			      MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4 |
+			      MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX))
+		ethtool_link_ksettings_add_link_mode(cmd, supported, Backplane);
+}
+
+static void
+mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
+			 u8 width, unsigned long *mode)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			__set_bit(mlxsw_sp1_port_link_mode[i].mask_ethtool,
+				  mode);
+	}
+}
+
+static u32
+mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			return mlxsw_sp1_port_link_mode[i].speed;
+	}
+
+	return SPEED_UNKNOWN;
+}
+
+static void
+mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+				 u32 ptys_eth_proto,
+				 struct ethtool_link_ksettings *cmd)
+{
+	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+
+	if (!carrier_ok)
+		return;
+
+	cmd->base.speed = mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
+	if (cmd->base.speed != SPEED_UNKNOWN)
+		cmd->base.duplex = DUPLEX_FULL;
+}
+
+static u32
+mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+			      const struct ethtool_link_ksettings *cmd)
+{
+	u32 ptys_proto = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (test_bit(mlxsw_sp1_port_link_mode[i].mask_ethtool,
+			     cmd->link_modes.advertising))
+			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
+	}
+	return ptys_proto;
+}
+
+static u32 mlxsw_sp1_to_ptys_speed(struct mlxsw_sp *mlxsw_sp, u8 width,
+				   u32 speed)
+{
+	u32 ptys_proto = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (speed == mlxsw_sp1_port_link_mode[i].speed)
+			ptys_proto |= mlxsw_sp1_port_link_mode[i].mask;
+	}
+	return ptys_proto;
+}
+
+static void
+mlxsw_sp1_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
+			    u8 local_port, u32 proto_admin, bool autoneg)
+{
+	mlxsw_reg_ptys_eth_pack(payload, local_port, proto_admin, autoneg);
+}
+
+static void
+mlxsw_sp1_reg_ptys_eth_unpack(struct mlxsw_sp *mlxsw_sp, char *payload,
+			      u32 *p_eth_proto_cap, u32 *p_eth_proto_admin,
+			      u32 *p_eth_proto_oper)
+{
+	mlxsw_reg_ptys_eth_unpack(payload, p_eth_proto_cap, p_eth_proto_admin,
+				  p_eth_proto_oper);
+}
+
+const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
+	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
+	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
+	.from_ptys_speed		= mlxsw_sp1_from_ptys_speed,
+	.from_ptys_speed_duplex		= mlxsw_sp1_from_ptys_speed_duplex,
+	.to_ptys_advert_link		= mlxsw_sp1_to_ptys_advert_link,
+	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
+	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
+	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
+};
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_sgmii_100m[] = {
+	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_sgmii_100m)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_1000base_x_sgmii[] = {
+	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_1000base_x_sgmii)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii[] = {
+	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_5gbase_r[] = {
+	ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_5gbase_r)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g[] = {
+	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseR_FEC_BIT,
+	ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseLR_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g[] = {
+	ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+	ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr[] = {
+	ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2[] = {
+	ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr[] = {
+	ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	ETHTOOL_LINK_MODE_50000baseDR_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4[] = {
+	ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2[] = {
+	ETHTOOL_LINK_MODE_100000baseKR2_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseSR2_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseCR2_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseLR2_ER2_FR2_Full_BIT,
+	ETHTOOL_LINK_MODE_100000baseDR2_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4[] = {
+	ETHTOOL_LINK_MODE_200000baseKR4_Full_BIT,
+	ETHTOOL_LINK_MODE_200000baseSR4_Full_BIT,
+	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT,
+	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT,
+	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4)
+
+static const enum ethtool_link_mode_bit_indices
+mlxsw_sp2_mask_ethtool_400gaui_8[] = {
+	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT,
+	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT,
+};
+
+#define MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN \
+	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_400gaui_8)
+
+#define MLXSW_SP_PORT_MASK_WIDTH_1X	BIT(0)
+#define MLXSW_SP_PORT_MASK_WIDTH_2X	BIT(1)
+#define MLXSW_SP_PORT_MASK_WIDTH_4X	BIT(2)
+#define MLXSW_SP_PORT_MASK_WIDTH_8X	BIT(3)
+
+static u8 mlxsw_sp_port_mask_width_get(u8 width)
+{
+	switch (width) {
+	case 1:
+		return MLXSW_SP_PORT_MASK_WIDTH_1X;
+	case 2:
+		return MLXSW_SP_PORT_MASK_WIDTH_2X;
+	case 4:
+		return MLXSW_SP_PORT_MASK_WIDTH_4X;
+	case 8:
+		return MLXSW_SP_PORT_MASK_WIDTH_8X;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+struct mlxsw_sp2_port_link_mode {
+	const enum ethtool_link_mode_bit_indices *mask_ethtool;
+	int m_ethtool_len;
+	u32 mask;
+	u32 speed;
+	u8 mask_width;
+};
+
+static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_SGMII_100M,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_sgmii_100m,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_SGMII_100M_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_100,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_1000BASE_X_SGMII,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_1000base_x_sgmii,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_1000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_2_5GBASE_X_2_5GMII,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_2500,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_5gbase_r,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_5GBASE_R_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_5000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XFI_XAUI_1_10G,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xfi_xaui_1_10g,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XFI_XAUI_1_10G_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_10000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_xlaui_4_xlppi_4_40g,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_XLAUI_4_XLPPI_4_40G_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_40000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_25GAUI_1_25GBASE_CR_KR,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_25gaui_1_25gbase_cr_kr,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_25GAUI_1_25GBASE_CR_KR_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X |
+				  MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_25000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_2_LAUI_2_50GBASE_CR2_KR2,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_2_laui_2_50gbase_cr2_kr2,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_2_LAUI_2_50GBASE_CR2_KR2_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X |
+				  MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_50000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_50GAUI_1_LAUI_1_50GBASE_CR_KR,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_50gaui_1_laui_1_50gbase_cr_kr,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_50GAUI_1_LAUI_1_50GBASE_CR_KR_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_1X,
+		.speed		= SPEED_50000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_CAUI_4_100GBASE_CR4_KR4,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_caui_4_100gbase_cr4_kr4,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_CAUI_4_100GBASE_CR4_KR4_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_100000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_100GAUI_2_100GBASE_CR2_KR2,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_100gaui_2_100gbase_cr2_kr2,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_100GAUI_2_100GBASE_CR2_KR2_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_2X,
+		.speed		= SPEED_100000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_200GAUI_4_200GBASE_CR4_KR4,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_200gaui_4_200gbase_cr4_kr4,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_200GAUI_4_200GBASE_CR4_KR4_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_4X |
+				  MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_200000,
+	},
+	{
+		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_400GAUI_8,
+		.mask_ethtool	= mlxsw_sp2_mask_ethtool_400gaui_8,
+		.m_ethtool_len	= MLXSW_SP2_MASK_ETHTOOL_400GAUI_8_LEN,
+		.mask_width	= MLXSW_SP_PORT_MASK_WIDTH_8X,
+		.speed		= SPEED_400000,
+	},
+};
+
+#define MLXSW_SP2_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp2_port_link_mode)
+
+static void
+mlxsw_sp2_from_ptys_supported_port(struct mlxsw_sp *mlxsw_sp,
+				   u32 ptys_eth_proto,
+				   struct ethtool_link_ksettings *cmd)
+{
+	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Backplane);
+}
+
+static void
+mlxsw_sp2_set_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
+			  unsigned long *mode)
+{
+	int i;
+
+	for (i = 0; i < link_mode->m_ethtool_len; i++)
+		__set_bit(link_mode->mask_ethtool[i], mode);
+}
+
+static void
+mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
+			 u8 width, unsigned long *mode)
+{
+	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if ((ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) &&
+		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
+			mlxsw_sp2_set_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
+						  mode);
+	}
+}
+
+static u32
+mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
+			return mlxsw_sp2_port_link_mode[i].speed;
+	}
+
+	return SPEED_UNKNOWN;
+}
+
+static void
+mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+				 u32 ptys_eth_proto,
+				 struct ethtool_link_ksettings *cmd)
+{
+	cmd->base.speed = SPEED_UNKNOWN;
+	cmd->base.duplex = DUPLEX_UNKNOWN;
+
+	if (!carrier_ok)
+		return;
+
+	cmd->base.speed = mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
+	if (cmd->base.speed != SPEED_UNKNOWN)
+		cmd->base.duplex = DUPLEX_FULL;
+}
+
+static bool
+mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_port_link_mode *link_mode,
+			   const unsigned long *mode)
+{
+	int cnt = 0;
+	int i;
+
+	for (i = 0; i < link_mode->m_ethtool_len; i++) {
+		if (test_bit(link_mode->mask_ethtool[i], mode))
+			cnt++;
+	}
+
+	return cnt == link_mode->m_ethtool_len;
+}
+
+static u32
+mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+			      const struct ethtool_link_ksettings *cmd)
+{
+	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
+	u32 ptys_proto = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if ((mask_width & mlxsw_sp2_port_link_mode[i].mask_width) &&
+		    mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
+					       cmd->link_modes.advertising))
+			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
+	}
+	return ptys_proto;
+}
+
+static u32 mlxsw_sp2_to_ptys_speed(struct mlxsw_sp *mlxsw_sp,
+				   u8 width, u32 speed)
+{
+	u8 mask_width = mlxsw_sp_port_mask_width_get(width);
+	u32 ptys_proto = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if ((speed == mlxsw_sp2_port_link_mode[i].speed) &&
+		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
+			ptys_proto |= mlxsw_sp2_port_link_mode[i].mask;
+	}
+	return ptys_proto;
+}
+
+static void
+mlxsw_sp2_reg_ptys_eth_pack(struct mlxsw_sp *mlxsw_sp, char *payload,
+			    u8 local_port, u32 proto_admin,
+			    bool autoneg)
+{
+	mlxsw_reg_ptys_ext_eth_pack(payload, local_port, proto_admin, autoneg);
+}
+
+static void
+mlxsw_sp2_reg_ptys_eth_unpack(struct mlxsw_sp *mlxsw_sp, char *payload,
+			      u32 *p_eth_proto_cap, u32 *p_eth_proto_admin,
+			      u32 *p_eth_proto_oper)
+{
+	mlxsw_reg_ptys_ext_eth_unpack(payload, p_eth_proto_cap,
+				      p_eth_proto_admin, p_eth_proto_oper);
+}
+
+const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
+	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
+	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
+	.from_ptys_speed		= mlxsw_sp2_from_ptys_speed,
+	.from_ptys_speed_duplex		= mlxsw_sp2_from_ptys_speed_duplex,
+	.to_ptys_advert_link		= mlxsw_sp2_to_ptys_advert_link,
+	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
+	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
+	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
+};
-- 
2.26.2

