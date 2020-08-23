Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9605624EC23
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgHWIIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:08:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33207 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbgHWIIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:08:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B65535C00C4;
        Sun, 23 Aug 2020 04:07:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=s6syTB86skR+7DYDuHwTsyuhd8eUUfaUW1YDtRdS3TQ=; b=vStv/JIm
        XreURaIOmgPtEQ2K68/3DViSlEMjkpix4pR4GcTc1dz+Zrs5NuuM3Mo2Jt8Wz3kB
        6w2MJxccPNCUsRsCFqivvwwg+bIaoOC2eNrSqC6inXHoKgHN/SHSovK1Z/2Z4XKj
        MVK6NTx590tEuHyjKenidKTvmBKbf8Xo5zdL5CiGeR+Db58k6Gc3vrdwAIN981rx
        tre53PIV8rq+5kZzBn7DaQRigMoy13Jpbdo2uABpaHfLWue7y/7BHxrxqtLIAcfx
        QZfLr+ClRaVL433oL/JkP9Hvn03Sw87VJdt3GU7MGbM+I1F1V1gSIvaY7Gb+tvW6
        ea3TCrmoozbY9A==
X-ME-Sender: <xms:3yNCXwMZTi3poNY35umpid0aEQahhAjXCGk94ugP3aGAN6QGExguJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgthhhi
    mhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnh
    epudetieevffffveelkeeljeffkefhkeehgfdtffethfelvdejgffghefgveejkefhnecu
    kfhppeejledrudejkedrudefuddrfeehnecuvehluhhsthgvrhfuihiivgepheenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3yNCX290c2Vqpp0rUtv938ea8_6JwzKofqjWNEoYuURPptzfkM-dtw>
    <xmx:3yNCX3SleHyyrZVn6lrBBjhM8BHqAxL_e_eaGzQfzCdNc7mTQVpw1g>
    <xmx:3yNCX4sW2MeJSke4TzvUzYVBo0eqqu2VxViOaSyjZKWT67AgoE3HoQ>
    <xmx:3yNCX5oWtYBhFcOOAjo2Fqka7NMP7VH8-Yw2C8zpSjzxkcChHgU37A>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id B699D3280059;
        Sun, 23 Aug 2020 04:07:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Danielle Ratson <danieller@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/7] mlxsw: spectrum_ethtool: Remove internal speeds from PTYS register
Date:   Sun, 23 Aug 2020 11:06:28 +0300
Message-Id: <20200823080628.407637-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

The PTYS register is used to report and configure the port type and
speed. Currently, internal bits in the register are used the same way
other bits are used.

Using the internal bits can cause bad parameter firmware errors. For
example, trying to write to internal bit 25 returns:

EMAD reg access failed (tid=53e2bffa00004310,reg_id=5004(ptys),type=write,status=7(bad parameter))

Remove the internal bits from the PTYS register, so that it is no longer
possible to pass them to firmware.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  6 ---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 38 -------------------
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 25 +-----------
 3 files changed, 1 insertion(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 079b080de7f7..485e3e02eb70 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4174,7 +4174,6 @@ MLXSW_ITEM32(reg, ptys, an_status, 0x04, 28, 4);
 
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_SGMII_100M				BIT(0)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_1000BASE_X_SGMII			BIT(1)
-#define MLXSW_REG_PTYS_EXT_ETH_SPEED_2_5GBASE_X_2_5GMII			BIT(2)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R				BIT(3)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_XFI_XAUI_1_10G			BIT(4)
 #define MLXSW_REG_PTYS_EXT_ETH_SPEED_XLAUI_4_XLPPI_4_40G		BIT(5)
@@ -4197,7 +4196,6 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_cap, 0x08, 0, 32);
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4		BIT(2)
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4		BIT(3)
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KR		BIT(4)
-#define MLXSW_REG_PTYS_ETH_SPEED_20GBASE_KR2		BIT(5)
 #define MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4		BIT(6)
 #define MLXSW_REG_PTYS_ETH_SPEED_40GBASE_KR4		BIT(7)
 #define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CR		BIT(12)
@@ -4210,10 +4208,6 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_cap, 0x08, 0, 32);
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4		BIT(20)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4		BIT(21)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4		BIT(22)
-#define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4	BIT(23)
-#define MLXSW_REG_PTYS_ETH_SPEED_100BASE_TX		BIT(24)
-#define MLXSW_REG_PTYS_ETH_SPEED_100BASE_T		BIT(25)
-#define MLXSW_REG_PTYS_ETH_SPEED_10GBASE_T		BIT(26)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR		BIT(27)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR		BIT(28)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR		BIT(29)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 14c78f73bb65..f08cad5b5657 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -992,22 +992,12 @@ struct mlxsw_sp1_port_link_mode {
 };
 
 static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100BASE_T,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100baseT_Full_BIT,
-		.speed		= SPEED_100,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_SGMII |
 				  MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
 		.speed		= SPEED_1000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_T,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
-		.speed		= SPEED_10000,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4,
@@ -1022,11 +1012,6 @@ static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
 		.mask_ethtool	= ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
 		.speed		= SPEED_10000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_20GBASE_KR2,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT,
-		.speed		= SPEED_20000,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
@@ -1092,11 +1077,6 @@ static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
 		.speed		= SPEED_100000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
-		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
-		.speed		= SPEED_100000,
-	},
 };
 
 #define MLXSW_SP1_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp1_port_link_mode)
@@ -1236,14 +1216,6 @@ mlxsw_sp2_mask_ethtool_1000base_x_sgmii[] = {
 #define MLXSW_SP2_MASK_ETHTOOL_1000BASE_X_SGMII_LEN \
 	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_1000base_x_sgmii)
 
-static const enum ethtool_link_mode_bit_indices
-mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii[] = {
-	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-};
-
-#define MLXSW_SP2_MASK_ETHTOOL_2_5GBASE_X_2_5GMII_LEN \
-	ARRAY_SIZE(mlxsw_sp2_mask_ethtool_2_5gbase_x_2_5gmii)
-
 static const enum ethtool_link_mode_bit_indices
 mlxsw_sp2_mask_ethtool_5gbase_r[] = {
 	ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
@@ -1407,16 +1379,6 @@ static const struct mlxsw_sp2_port_link_mode mlxsw_sp2_port_link_mode[] = {
 				  MLXSW_SP_PORT_MASK_WIDTH_8X,
 		.speed		= SPEED_1000,
 	},
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
 	{
 		.mask		= MLXSW_REG_PTYS_EXT_ETH_SPEED_5GBASE_R,
 		.mask_ethtool	= mlxsw_sp2_mask_ethtool_5gbase_r,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 6f9a725662fb..5023d91269f4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -550,16 +550,6 @@ struct mlxsw_sx_port_link_mode {
 };
 
 static const struct mlxsw_sx_port_link_mode mlxsw_sx_port_link_mode[] = {
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100BASE_T,
-		.supported	= SUPPORTED_100baseT_Full,
-		.advertised	= ADVERTISED_100baseT_Full,
-		.speed		= 100,
-	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100BASE_TX,
-		.speed		= 100,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_SGMII |
 				  MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX,
@@ -567,12 +557,6 @@ static const struct mlxsw_sx_port_link_mode mlxsw_sx_port_link_mode[] = {
 		.advertised	= ADVERTISED_1000baseKX_Full,
 		.speed		= 1000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_T,
-		.supported	= SUPPORTED_10000baseT_Full,
-		.advertised	= ADVERTISED_10000baseT_Full,
-		.speed		= 10000,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4,
@@ -589,12 +573,6 @@ static const struct mlxsw_sx_port_link_mode mlxsw_sx_port_link_mode[] = {
 		.advertised	= ADVERTISED_10000baseKR_Full,
 		.speed		= 10000,
 	},
-	{
-		.mask		= MLXSW_REG_PTYS_ETH_SPEED_20GBASE_KR2,
-		.supported	= SUPPORTED_20000baseKR2_Full,
-		.advertised	= ADVERTISED_20000baseKR2_Full,
-		.speed		= 20000,
-	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_40GBASE_CR4,
 		.supported	= SUPPORTED_40000baseCR4_Full,
@@ -634,8 +612,7 @@ static const struct mlxsw_sx_port_link_mode mlxsw_sx_port_link_mode[] = {
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4 |
-				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4 |
-				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
+				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4,
 		.speed		= 100000,
 	},
 };
-- 
2.26.2

