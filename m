Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6C6EACB9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfJaJm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54123 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727196AbfJaJm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E63C722022;
        Thu, 31 Oct 2019 05:42:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jD380TdYCIcqyi0226M96ZDqd2YSNkfWrtVAqO3MD8g=; b=NWisxt07
        NI1oC6yq86xwsEY36qgUi/6KCv9+0Aoc9QmSjvOOa/Z8vh0TqROr1RjVqx8xXgMR
        WGI0JE3COvYzWaag+DlS7w6q2R+g+Tm8QLK5/fME6OxJOIObXbEai0dqflS+S2yr
        lVDyIHoCmjWRIzQOOJb+LtiUJ/nOsKPDIxH0SLNdbRONR95YGsyXB+OeLE3BW3Vs
        xbzWR8Ha6eZRWt6vA5qPLDDoFET1XtNEIBWT+TzWx7GsXCoQz3PICbVErNrYnDxB
        tIlb9hlhYSH98d6JzxTvGvd9VYmqPeoS0qJxht8qVW8HYV8G4rBnddq/9+9FIoiD
        +AlzJMNMnTHUhg==
X-ME-Sender: <xms:n6y6XWcMmQnalEuDE1Ek3XNX_rBAGS_hzwdbiHxsORksWEcrTNwmRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeej
X-ME-Proxy: <xmx:n6y6Xa0Bw9mSKCbBpI8RGOi9BnbttjVm7AmVjhxpU-84PyO__Kix5w>
    <xmx:n6y6Xdjapo5N-h-Mo5byDKPEVIYpEtCWlp4bRveEi4E8no5PV_C9eQ>
    <xmx:n6y6XTk60H2ACf50RP1ATrBDJHFv8j-eCFunpeki6R7tYIUWvp1TQw>
    <xmx:n6y6XbWHgcMakaGk5A4F9qZcaMkVbceW0CF4ADeUZWdxs56e7q9HJg>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0850E80061;
        Thu, 31 Oct 2019 05:42:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/16] mlxsw: spectrum: Pass mapping values in port mapping structure
Date:   Thu, 31 Oct 2019 11:42:13 +0200
Message-Id: <20191031094221.17526-9-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Pass the port mapping structure down to create, module_map and other
function instead of individual values.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 56 +++++++++----------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2145975af103..68f1461d9919 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -765,18 +765,18 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return 0;
 }
 
-static int mlxsw_sp_port_module_map(struct mlxsw_sp_port *mlxsw_sp_port,
-				    u8 module, u8 width, u8 lane)
+static int mlxsw_sp_port_module_map(struct mlxsw_sp_port *mlxsw_sp_port)
 {
+	struct mlxsw_sp_port_mapping *port_mapping = &mlxsw_sp_port->mapping;
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	int i;
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, mlxsw_sp_port->local_port);
-	mlxsw_reg_pmlp_width_set(pmlp_pl, width);
-	for (i = 0; i < width; i++) {
-		mlxsw_reg_pmlp_module_set(pmlp_pl, i, module);
-		mlxsw_reg_pmlp_tx_lane_set(pmlp_pl, i, lane + i);  /* Rx & Tx */
+	mlxsw_reg_pmlp_width_set(pmlp_pl, port_mapping->width);
+	for (i = 0; i < port_mapping->width; i++) {
+		mlxsw_reg_pmlp_module_set(pmlp_pl, i, port_mapping->module);
+		mlxsw_reg_pmlp_tx_lane_set(pmlp_pl, i, port_mapping->lane + i); /* Rx & Tx */
 	}
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
@@ -3480,7 +3480,7 @@ static const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 };
 
 static int
-mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port, u8 width)
+mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	const struct mlxsw_sp_port_type_speed_ops *ops;
@@ -3496,7 +3496,7 @@ mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port, u8 width)
 				   &base_speed);
 	if (err)
 		return err;
-	upper_speed = base_speed * width;
+	upper_speed = base_speed * mlxsw_sp_port->mapping.width;
 
 	eth_proto_admin = ops->to_ptys_upper_speed(mlxsw_sp, upper_speed);
 	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
@@ -3657,7 +3657,8 @@ static int mlxsw_sp_port_tc_mc_mode_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
-				bool split, u8 module, u8 width, u8 lane)
+				bool split,
+				struct mlxsw_sp_port_mapping *port_mapping)
 {
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	struct mlxsw_sp_port *mlxsw_sp_port;
@@ -3665,7 +3666,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
-				   module + 1, split, lane / width,
+				   port_mapping->module + 1, split,
+				   port_mapping->lane / port_mapping->width,
 				   mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
@@ -3687,9 +3689,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port->local_port = local_port;
 	mlxsw_sp_port->pvid = MLXSW_SP_DEFAULT_VID;
 	mlxsw_sp_port->split = split;
-	mlxsw_sp_port->mapping.module = module;
-	mlxsw_sp_port->mapping.width = width;
-	mlxsw_sp_port->mapping.lane = lane;
+	mlxsw_sp_port->mapping = *port_mapping;
 	mlxsw_sp_port->link.autoneg = 1;
 	INIT_LIST_HEAD(&mlxsw_sp_port->vlans_list);
 	INIT_LIST_HEAD(&mlxsw_sp_port->mall_tc_list);
@@ -3714,7 +3714,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	dev->netdev_ops = &mlxsw_sp_port_netdev_ops;
 	dev->ethtool_ops = &mlxsw_sp_port_ethtool_ops;
 
-	err = mlxsw_sp_port_module_map(mlxsw_sp_port, module, width, lane);
+	err = mlxsw_sp_port_module_map(mlxsw_sp_port);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to map module\n",
 			mlxsw_sp_port->local_port);
@@ -3756,7 +3756,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_port_system_port_mapping_set;
 	}
 
-	err = mlxsw_sp_port_speed_by_width_set(mlxsw_sp_port, width);
+	err = mlxsw_sp_port_speed_by_width_set(mlxsw_sp_port);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to enable speeds\n",
 			mlxsw_sp_port->local_port);
@@ -4003,10 +4003,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		port_mapping = mlxsw_sp->port_mapping[i];
 		if (!port_mapping)
 			continue;
-		err = mlxsw_sp_port_create(mlxsw_sp, i, false,
-					   port_mapping->module,
-					   port_mapping->width,
-					   port_mapping->lane);
+		err = mlxsw_sp_port_create(mlxsw_sp, i, false, port_mapping);
 		if (err)
 			goto err_port_create;
 	}
@@ -4079,15 +4076,17 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 			   struct mlxsw_sp_port_mapping *port_mapping,
 			   unsigned int count, u8 offset)
 {
-	u8 width = port_mapping->width / count;
+	struct mlxsw_sp_port_mapping split_port_mapping;
 	int err, i;
 
+	split_port_mapping = *port_mapping;
+	split_port_mapping.width /= count;
 	for (i = 0; i < count; i++) {
 		err = mlxsw_sp_port_create(mlxsw_sp, base_port + i * offset,
-					   true, port_mapping->module,
-					   width, i * width);
+					   true, &split_port_mapping);
 		if (err)
 			goto err_port_create;
+		split_port_mapping.lane += split_port_mapping.width;
 	}
 
 	return 0;
@@ -4100,11 +4099,10 @@ mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 }
 
 static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
-					 u8 base_port, unsigned int count,
-					 unsigned int max_width)
+					 u8 base_port, unsigned int count)
 {
 	struct mlxsw_sp_port_mapping *port_mapping;
-	u8 local_port, width = max_width;
+	u8 local_port;
 	int i;
 
 	/* Split by four means we need to re-create two ports, otherwise
@@ -4117,9 +4115,7 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 		port_mapping = mlxsw_sp->port_mapping[local_port];
 		if (!port_mapping)
 			continue;
-
-		mlxsw_sp_port_create(mlxsw_sp, local_port, false,
-				     port_mapping->module, width, 0);
+		mlxsw_sp_port_create(mlxsw_sp, local_port, false, port_mapping);
 	}
 }
 
@@ -4216,7 +4212,7 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	return 0;
 
 err_port_split_create:
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, max_width);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
 	return err;
 }
 
@@ -4277,7 +4273,7 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
 			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
-	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count, max_width);
+	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
 
 	return 0;
 }
-- 
2.21.0

