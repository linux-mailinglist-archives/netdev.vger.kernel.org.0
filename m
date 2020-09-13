Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64362268001
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgIMPq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:46:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44653 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbgIMPqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:46:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EE19E5C0109;
        Sun, 13 Sep 2020 11:46:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 11:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5DnjQpH/0X4kbosLc6bXWKl7vjR9tfJd2mPi1ZHnPsY=; b=XCXGJQn5
        8/sRdWAOjwDvr3b7FlJSmLVGDiQxSrRgtJERC+Kl9JkNuUwNjnitnLzZ5ketL1hn
        QTGxQLEobQfi0QuqaJbt2CabTSuYp95LUwZyLagtRfwo1D5rSbEUE3L7ssH3ACwG
        tuYbT6LqDFxR+J2n5LPatMdIXYRleH4M6NqYQKvzrtKplRwwbpsjLjGnTS1HQ1la
        KH1yblZtZEGSYH+hURjThKqxB2J/K5FtoNLT7j7fKuzGemjSSehe40X9U5QPOX6h
        kjEQ7Dcp2nEL/AzfalQTqC645+TYovl21+1VIheN4eWCrJLSarAZNZa/4eIMDidL
        VhadFd46ZvhGJw==
X-ME-Sender: <xms:5D5eX8Mfuzu4x3R0RmUVELayA2v9KruXBW6Iunr7PEBYt6dkOYWgxg>
    <xme:5D5eXy_U7zaT2RRq9-6rtMwqzxOr9YLJeKLtj9f_rqpoQ0UMJs0cbymCvZ7Vv3BSe
    QtCql52Hpo-YZo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeigedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5D5eXzTqczHF6Jjc8m5gas0RKpeNKtTc0PussbR2NaHg0tpmrNSuXw>
    <xmx:5D5eX0vcmHc_ly6Cib-hF4xUBWZ84up6pDcIZDMIDKJfLMmQ73wSQg>
    <xmx:5D5eX0fyaJ2goDE4pD26vDofnOUv_ipRqtmba18UzJvuQ_augf-cWw>
    <xmx:5D5eX85Y-ghv3Qb7HVh0UwbRHvOQ6IGjL8WHj_HVLS-v-lg590KqXg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D00A328005A;
        Sun, 13 Sep 2020 11:46:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/5] mlxsw: spectrum_ethtool: Extract a helper to get Ethernet attributes
Date:   Sun, 13 Sep 2020 18:46:05 +0300
Message-Id: <20200913154609.14870-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200913154609.14870-1-idosch@idosch.org>
References: <20200913154609.14870-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

In order to allow reusing the logic, extract from
mlxsw_sp_port_get_link_ksettings() the code to obtain Ethernet protocol
attributes, mlxsw_sp_port_ptys_query().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 38 ++++++++++++++-----
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index f08cad5b5657..f007e58950da 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -842,6 +842,29 @@ mlxsw_sp_port_connector_port(enum mlxsw_reg_ptys_connector_type connector_type)
 	}
 }
 
+static int mlxsw_sp_port_ptys_query(struct mlxsw_sp_port *mlxsw_sp_port,
+				    u32 *p_eth_proto_cap, u32 *p_eth_proto_admin,
+				    u32 *p_eth_proto_oper, u8 *p_connector_type)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	const struct mlxsw_sp_port_type_speed_ops *ops;
+	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	int err;
+
+	ops = mlxsw_sp->port_type_speed_ops;
+
+	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port, 0, false);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	if (err)
+		return err;
+
+	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, p_eth_proto_cap, p_eth_proto_admin,
+				 p_eth_proto_oper);
+	if (p_connector_type)
+		*p_connector_type = mlxsw_reg_ptys_connector_type_get(ptys_pl);
+	return 0;
+}
+
 static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 					    struct ethtool_link_ksettings *cmd)
 {
@@ -849,21 +872,17 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	const struct mlxsw_sp_port_type_speed_ops *ops;
-	char ptys_pl[MLXSW_REG_PTYS_LEN];
 	u8 connector_type;
 	bool autoneg;
 	int err;
 
-	ops = mlxsw_sp->port_type_speed_ops;
-
-	autoneg = mlxsw_sp_port->link.autoneg;
-	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       0, false);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	err = mlxsw_sp_port_ptys_query(mlxsw_sp_port, &eth_proto_cap, &eth_proto_admin,
+				       &eth_proto_oper, &connector_type);
 	if (err)
 		return err;
-	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
-				 &eth_proto_admin, &eth_proto_oper);
+
+	ops = mlxsw_sp->port_type_speed_ops;
+	autoneg = mlxsw_sp_port->link.autoneg;
 
 	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
 					 mlxsw_sp_port->mapping.width, cmd);
@@ -872,7 +891,6 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
 					 mlxsw_sp_port->mapping.width, cmd);
 
 	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
-	connector_type = mlxsw_reg_ptys_connector_type_get(ptys_pl);
 	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
 	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
 				    eth_proto_oper, cmd);
-- 
2.26.2

