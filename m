Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29E325431
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhBYQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:59:52 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38715 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233745AbhBYQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:58:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B8389B26;
        Thu, 25 Feb 2021 11:58:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 25 Feb 2021 11:58:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Zw5Pn/oIUrseXSHONbxomUd58oEEGufUeIO7NNxAItM=; b=vZbV2YSj
        P894odij3JYnOPTl1t1/poQei/pCbQ/ScAoSjvL90byxCArKXAIQlR9QWIDwupCu
        Py8elYuuBlqcAEj5nXUMWM4JsJxd9/HHo58tTInRbGD/3RE5cehLRyYnqNdlOzZV
        1+DQYg+Ak8CzIsslLY3UEvbi3FjikRooBxzVvzUeBGQXbDNE6XtSJ6d6ACEtTsaQ
        O0YSGCYOHFMUjqsAzDnsMQIa5j+YXp6j0TqEACgkRFdzvNP9fDqEXVAwBbp21mJH
        sw3RDK4UvMpusr7bPCp07FcnX1Ps7NE8Va2CRTVs+u/CD+DIu8mwZqutWyarBJW4
        S9K5pOMjfmZ+Cg==
X-ME-Sender: <xms:I9c3YKeX7oN0BqunQQQCd5SOyZhrKRgJ_9ARdgN_ZWHbxfO0akn3TA>
    <xme:I9c3YCLlpFCw7l48hwwxyQAfSnDVYDR2Djq02uNnCUvIZ4o4mOJGGnu4C1xjWCObo
    giMCG0XPhIapL8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:I9c3YDGZMB3LlCP1fSUWMBrpprWbFiooDdmiNow0D_Yz5il4quEeAg>
    <xmx:I9c3YEorF2wtRiCmwCxgp_6PZ0pDBnEisIEtyAasYgzfymnJ3vrqMQ>
    <xmx:I9c3YESdjsaG8AbHnegQh6mVoSUMddbsGIrePu0zLxH0_oAF7sTKbQ>
    <xmx:I9c3YLZ22Vp6Qu-dXVotz6aPX1F4RmcOPOkFIA4drvw3beBva3l2kg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6CD24240057;
        Thu, 25 Feb 2021 11:58:09 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/3] mlxsw: spectrum_ethtool: Add an external speed to PTYS register
Date:   Thu, 25 Feb 2021 18:57:20 +0200
Message-Id: <20210225165721.1322424-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225165721.1322424-1-idosch@idosch.org>
References: <20210225165721.1322424-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, only external bits are added to the PTYS register, whereas
there is one external bit that is wrongly marked as internal, and so was
recently removed from the register.

Add that bit to the PTYS register again, as this bit is no longer
internal.

Its removal resulted in '100000baseLR4_ER4/Full' link mode no longer
being supported, causing a regression on some setups.

Fixes: 5bf01b571cf4 ("mlxsw: spectrum_ethtool: Remove internal speeds from PTYS register")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reported-by: Eddie Shklaer <eddies@nvidia.com>
Tested-by: Eddie Shklaer <eddies@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h              | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 5 +++++
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c         | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 16e2df6ef2f4..c4adc7f740d3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4430,6 +4430,7 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_cap, 0x08, 0, 32);
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4		BIT(20)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4		BIT(21)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4		BIT(22)
+#define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4	BIT(23)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR		BIT(27)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR		BIT(28)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR		BIT(29)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index bd7f873f6290..0bd64169bf81 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1169,6 +1169,11 @@ static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
 		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
 		.speed		= SPEED_100000,
 	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT,
+		.speed		= SPEED_100000,
+	},
 };
 
 #define MLXSW_SP1_PORT_LINK_MODE_LEN ARRAY_SIZE(mlxsw_sp1_port_link_mode)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 40e2e79d4517..131b2a53d261 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -613,7 +613,8 @@ static const struct mlxsw_sx_port_link_mode mlxsw_sx_port_link_mode[] = {
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100GBASE_CR4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4 |
-				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4,
+				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4 |
+				  MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4,
 		.speed		= 100000,
 	},
 };
-- 
2.29.2

