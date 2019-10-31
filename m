Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C84EACB7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfJaJmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49681 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727196AbfJaJmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C1BBA2177A;
        Thu, 31 Oct 2019 05:42:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8acazM1MMgcbOkPwd/J2I1ljSjSI1lGcm8ApEJpTFgQ=; b=ItXlEbCi
        O0LTQu0BXNjBL7cVV1u+Mv/Uzv5/GOQQJirdAekXDBC958VORUAUzeH78JzWpjom
        j7RgJ3ZX5LKx/+UUscTg97K5HLrhIUJj7lluuA7y7dyqkcXxncVhYRBLucSFS1sA
        zThWXIba7DWmHbbm6CShTL3czfuwz4svRsnRUDz1DU+yK3ZbEvU2Jop5uqMrI8ab
        M1n43fFIk24Xr6Fi9Kzuk8d1jyx+CeLM62+jUM1z6GYxCC2rulBz2/PPYs3jHMv4
        LyTqSKHFSqBPJYRLhHBUnwnP7K1ee0z34+vbuWEt3gDpwWyklnfUISvuPeRqyp2J
        UWmx1IbBn+5LCQ==
X-ME-Sender: <xms:nKy6XQ7F6ayIbKN8jUGMgpFVvktbN0ygXo-46yRTDhJXiSqxLstOCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:nKy6XSGX0DASwi8civc_XiCcxRjQzE_Bd_J0zleJP_2yPZ5oVGlnoQ>
    <xmx:nKy6XSFk53RERCvQjEzBKQjM3UDhe63seKWoxeOlyt1OSwzzZ6zy3g>
    <xmx:nKy6XQs_Z-0oxD1wnD5gJ-uBz-AQRFu9EbzZjjkqa-7Zuyc-9gzItg>
    <xmx:nKy6Xbaip_i2v3pLWuQ4drPg7znwjYLcYzB1PxCqrhrqn6TMeiWA9Q>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 005908006A;
        Thu, 31 Oct 2019 05:42:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/16] mlxsw: spectrum: Replace port_to_module array with array of structs
Date:   Thu, 31 Oct 2019 11:42:11 +0200
Message-Id: <20191031094221.17526-7-idosch@idosch.org>
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

Store the initial PMLP register configuration into array of structures
instead of just simple array of module numbers.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 105 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  18 ++-
 2 files changed, 84 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3644fca096ac..ee15428ca740 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -748,9 +748,9 @@ mlxsw_sp_port_system_port_mapping_set(struct mlxsw_sp_port *mlxsw_sp_port)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sspr), sspr_pl);
 }
 
-static int mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp,
-					 u8 local_port, u8 *p_module,
-					 u8 *p_width, u8 *p_lane)
+static int
+mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+			      struct mlxsw_sp_port_mapping *port_mapping)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	int err;
@@ -759,9 +759,9 @@ static int mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
 	if (err)
 		return err;
-	*p_module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
-	*p_width = mlxsw_reg_pmlp_width_get(pmlp_pl);
-	*p_lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
+	port_mapping->module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
+	port_mapping->width = mlxsw_reg_pmlp_width_get(pmlp_pl);
+	port_mapping->lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
 	return 0;
 }
 
@@ -3979,14 +3979,13 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
-	kfree(mlxsw_sp->port_to_module);
 	kfree(mlxsw_sp->ports);
 }
 
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
-	u8 module, width, lane;
+	struct mlxsw_sp_port_mapping *port_mapping;
 	size_t alloc_size;
 	int i;
 	int err;
@@ -3996,48 +3995,78 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->ports)
 		return -ENOMEM;
 
-	mlxsw_sp->port_to_module = kmalloc_array(max_ports, sizeof(int),
-						 GFP_KERNEL);
-	if (!mlxsw_sp->port_to_module) {
-		err = -ENOMEM;
-		goto err_port_to_module_alloc;
-	}
-
 	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
 	if (err)
 		goto err_cpu_port_create;
 
 	for (i = 1; i < max_ports; i++) {
-		/* Mark as invalid */
-		mlxsw_sp->port_to_module[i] = -1;
-
-		err = mlxsw_sp_port_module_info_get(mlxsw_sp, i, &module,
-						    &width, &lane);
-		if (err)
-			goto err_port_module_info_get;
-		if (!width)
+		port_mapping = mlxsw_sp->port_mapping[i];
+		if (!port_mapping)
 			continue;
-		mlxsw_sp->port_to_module[i] = module;
 		err = mlxsw_sp_port_create(mlxsw_sp, i, false,
-					   module, width, lane);
+					   port_mapping->module,
+					   port_mapping->width,
+					   port_mapping->lane);
 		if (err)
 			goto err_port_create;
 	}
 	return 0;
 
 err_port_create:
-err_port_module_info_get:
 	for (i--; i >= 1; i--)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 err_cpu_port_create:
-	kfree(mlxsw_sp->port_to_module);
-err_port_to_module_alloc:
 	kfree(mlxsw_sp->ports);
 	return err;
 }
 
+static int mlxsw_sp_port_module_info_init(struct mlxsw_sp *mlxsw_sp)
+{
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
+	struct mlxsw_sp_port_mapping port_mapping;
+	int i;
+	int err;
+
+	mlxsw_sp->port_mapping = kcalloc(max_ports,
+					 sizeof(struct mlxsw_sp_port_mapping *),
+					 GFP_KERNEL);
+	if (!mlxsw_sp->port_mapping)
+		return -ENOMEM;
+
+	for (i = 1; i < max_ports; i++) {
+		err = mlxsw_sp_port_module_info_get(mlxsw_sp, i, &port_mapping);
+		if (err)
+			goto err_port_module_info_get;
+		if (!port_mapping.width)
+			continue;
+
+		mlxsw_sp->port_mapping[i] = kmemdup(&port_mapping,
+						    sizeof(port_mapping),
+						    GFP_KERNEL);
+		if (!mlxsw_sp->port_mapping[i])
+			goto err_port_module_info_dup;
+	}
+	return 0;
+
+err_port_module_info_get:
+err_port_module_info_dup:
+	for (i--; i >= 1; i--)
+		kfree(mlxsw_sp->port_mapping[i]);
+	kfree(mlxsw_sp->port_mapping);
+	return err;
+}
+
+static void mlxsw_sp_port_module_info_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	int i;
+
+	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
+		kfree(mlxsw_sp->port_mapping[i]);
+	kfree(mlxsw_sp->port_mapping);
+}
+
 static u8 mlxsw_sp_cluster_base_port_get(u8 local_port, unsigned int max_width)
 {
 	u8 offset = (local_port - 1) % max_width;
@@ -4072,7 +4101,8 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 					 u8 base_port, unsigned int count,
 					 unsigned int max_width)
 {
-	u8 local_port, module, width = max_width;
+	struct mlxsw_sp_port_mapping *port_mapping;
+	u8 local_port, width = max_width;
 	int i;
 
 	/* Split by four means we need to re-create two ports, otherwise
@@ -4082,12 +4112,12 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 
 	for (i = 0; i < count; i++) {
 		local_port = base_port + i * 2;
-		if (mlxsw_sp->port_to_module[local_port] < 0)
+		port_mapping = mlxsw_sp->port_mapping[local_port];
+		if (!port_mapping)
 			continue;
-		module = mlxsw_sp->port_to_module[local_port];
 
-		mlxsw_sp_port_create(mlxsw_sp, local_port, false, module,
-				     width, 0);
+		mlxsw_sp_port_create(mlxsw_sp, local_port, false,
+				     port_mapping->module, width, 0);
 	}
 }
 
@@ -4951,6 +4981,12 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_dpipe_init;
 	}
 
+	err = mlxsw_sp_port_module_info_init(mlxsw_sp);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to init port module info\n");
+		goto err_port_module_info_init;
+	}
+
 	err = mlxsw_sp_ports_create(mlxsw_sp);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
@@ -4960,6 +4996,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	return 0;
 
 err_ports_create:
+	mlxsw_sp_port_module_info_fini(mlxsw_sp);
+err_port_module_info_init:
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 err_dpipe_init:
 	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
@@ -5052,6 +5090,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
 	mlxsw_sp_ports_remove(mlxsw_sp);
+	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
 	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
 					  &mlxsw_sp->netdevice_nb);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a5fdd84b4ca7..3a823911a9d9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -143,6 +143,12 @@ struct mlxsw_sp_port_type_speed_ops;
 struct mlxsw_sp_ptp_state;
 struct mlxsw_sp_ptp_ops;
 
+struct mlxsw_sp_port_mapping {
+	u8 module;
+	u8 width;
+	u8 lane;
+};
+
 struct mlxsw_sp {
 	struct mlxsw_sp_port **ports;
 	struct mlxsw_core *core;
@@ -150,7 +156,7 @@ struct mlxsw_sp {
 	unsigned char base_mac[ETH_ALEN];
 	const unsigned char *mac_mask;
 	struct mlxsw_sp_upper *lags;
-	int *port_to_module;
+	struct mlxsw_sp_port_mapping **port_mapping;
 	struct mlxsw_sp_sb *sb;
 	struct mlxsw_sp_bridge *bridge;
 	struct mlxsw_sp_router *router;
@@ -259,11 +265,11 @@ struct mlxsw_sp_port {
 		struct ieee_pfc *pfc;
 		enum mlxsw_reg_qpts_trust_state trust_state;
 	} dcb;
-	struct {
-		u8 module;
-		u8 width;
-		u8 lane;
-	} mapping;
+	struct mlxsw_sp_port_mapping mapping; /* mapping is constant during the
+					       * mlxsw_sp_port lifetime, however
+					       * the same localport can have
+					       * different mapping.
+					       */
 	/* TC handles */
 	struct list_head mall_tc_list;
 	struct {
-- 
2.21.0

