Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2299B34A7
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbfIPGSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:18:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42023 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbfIPGSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:18:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 33F9C22022;
        Mon, 16 Sep 2019 02:18:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 02:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YXdDx3pBhMhHT5FXAQgjjGUGac9rcTf/dNTBIeF4+ao=; b=XV4CuVXR
        9nt0ZPojD+XKYLOO/Jr4jeXUsnAjZa7bfBwGcU6b8X6+Cry+W+dP9qXGDkfp6/TJ
        tgGNd54zzyFg/1MTXzU9fi+FE/WVgzGLBUxW8dtJVDbzSAJMkkWtEjqZWOihOPSX
        jDzCXe6u1ArqCV962MVuqIFxnHJuXh7oKofYYD3y0kV+csdR+1NtePlCjr38QAIU
        HSvl/SrWD7di++lK7QJRYujnb9ZwXjjAJtQTj1rGVK75ShxRDvGbySYueKf/fxFG
        aOshd8lg6WyckUkNuTryLnKA43wpVXhGwwZsKy8FkP7Wgx7JJCC3tO3bvNkgsNsJ
        87iFf1izoLgpTg==
X-ME-Sender: <xms:SSl_Xcgce0lNAh9DhBjTfsQR3lLGPjsPRbGGcokcSTcaSBdeetW6kg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:SSl_XcnAODRWM-QrFc2kvYAXywa7i5JRU_O4qzDmX5gpuv18_cPQ1A>
    <xmx:SSl_XTu2VVs2Blis3rk0B0OjR9aVwN5qM8wDdDdxCiyBRfsL0cL5sQ>
    <xmx:SSl_XaD4TsE6a6QmQzgS1aDS3Nfsfpbmd4Fy4pA9fcg0KZ1CmYeRAQ>
    <xmx:SSl_XW99yqx7sp1f7BloBXsgmd21QF-KkvcwJ10DlU5TLV7H_I5Bww>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4294580066;
        Mon, 16 Sep 2019 02:18:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 2/3] mlxsw: spectrum: Register CPU port with devlink
Date:   Mon, 16 Sep 2019 09:17:49 +0300
Message-Id: <20190916061750.26207-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916061750.26207-1-idosch@idosch.org>
References: <20190916061750.26207-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Register CPU port with devlink.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 65 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 46 +++++++++++++
 3 files changed, 107 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 3fa96076e8a5..66354b05fd6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1864,11 +1864,13 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_res_get);
 
-int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
-			 u32 port_number, bool split,
-			 u32 split_port_subnumber,
-			 const unsigned char *switch_id,
-			 unsigned char switch_id_len)
+static int
+__mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
+		       enum devlink_port_flavour flavour,
+		       u32 port_number, bool split,
+		       u32 split_port_subnumber,
+		       const unsigned char *switch_id,
+		       unsigned char switch_id_len)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	struct mlxsw_core_port *mlxsw_core_port =
@@ -1877,17 +1879,17 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 	int err;
 
 	mlxsw_core_port->local_port = local_port;
-	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       port_number, split, split_port_subnumber,
+	devlink_port_attrs_set(devlink_port, flavour, port_number,
+			       split, split_port_subnumber,
 			       switch_id, switch_id_len);
 	err = devlink_port_register(devlink, devlink_port, local_port);
 	if (err)
 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
 	return err;
 }
-EXPORT_SYMBOL(mlxsw_core_port_init);
 
-void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
+static void
+__mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 {
 	struct mlxsw_core_port *mlxsw_core_port =
 					&mlxsw_core->ports[local_port];
@@ -1896,8 +1898,53 @@ void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 	devlink_port_unregister(devlink_port);
 	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
 }
+
+int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
+			 u32 port_number, bool split,
+			 u32 split_port_subnumber,
+			 const unsigned char *switch_id,
+			 unsigned char switch_id_len)
+{
+	return __mlxsw_core_port_init(mlxsw_core, local_port,
+				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				      port_number, split, split_port_subnumber,
+				      switch_id, switch_id_len);
+}
+EXPORT_SYMBOL(mlxsw_core_port_init);
+
+void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
+{
+	__mlxsw_core_port_fini(mlxsw_core, local_port);
+}
 EXPORT_SYMBOL(mlxsw_core_port_fini);
 
+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
+			     void *port_driver_priv,
+			     const unsigned char *switch_id,
+			     unsigned char switch_id_len)
+{
+	struct mlxsw_core_port *mlxsw_core_port =
+				&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
+	int err;
+
+	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
+				     DEVLINK_PORT_FLAVOUR_CPU,
+				     0, false, 0,
+				     switch_id, switch_id_len);
+	if (err)
+		return err;
+
+	mlxsw_core_port->port_driver_priv = port_driver_priv;
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_core_cpu_port_init);
+
+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
+{
+	__mlxsw_core_port_fini(mlxsw_core, MLXSW_PORT_CPU_PORT);
+}
+EXPORT_SYMBOL(mlxsw_core_cpu_port_fini);
+
 void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
 			     void *port_driver_priv, struct net_device *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index b65a17d49e43..5d7d2ab6d155 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -177,6 +177,11 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
+			     void *port_driver_priv,
+			     const unsigned char *switch_id,
+			     unsigned char switch_id_len);
+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
 void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
 			     void *port_driver_priv, struct net_device *dev);
 void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u8 local_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 91e4792bb7e7..dd234cf7b39d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3872,6 +3872,45 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
 }
 
+static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	int err;
+
+	mlxsw_sp_port = kzalloc(sizeof(*mlxsw_sp_port), GFP_KERNEL);
+	if (!mlxsw_sp_port)
+		return -ENOMEM;
+
+	mlxsw_sp_port->mlxsw_sp = mlxsw_sp;
+	mlxsw_sp_port->local_port = MLXSW_PORT_CPU_PORT;
+
+	err = mlxsw_core_cpu_port_init(mlxsw_sp->core,
+				       mlxsw_sp_port,
+				       mlxsw_sp->base_mac,
+				       sizeof(mlxsw_sp->base_mac));
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize core CPU port\n");
+		goto err_core_cpu_port_init;
+	}
+
+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = mlxsw_sp_port;
+	return 0;
+
+err_core_cpu_port_init:
+	kfree(mlxsw_sp_port);
+	return err;
+}
+
+static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port =
+				mlxsw_sp->ports[MLXSW_PORT_CPU_PORT];
+
+	mlxsw_core_cpu_port_fini(mlxsw_sp->core);
+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = NULL;
+	kfree(mlxsw_sp_port);
+}
+
 static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
 	return mlxsw_sp->ports[local_port] != NULL;
@@ -3884,6 +3923,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 	kfree(mlxsw_sp->port_to_module);
 	kfree(mlxsw_sp->ports);
 }
@@ -3908,6 +3948,10 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		goto err_port_to_module_alloc;
 	}
 
+	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
+	if (err)
+		goto err_cpu_port_create;
+
 	for (i = 1; i < max_ports; i++) {
 		/* Mark as invalid */
 		mlxsw_sp->port_to_module[i] = -1;
@@ -3931,6 +3975,8 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	for (i--; i >= 1; i--)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
+err_cpu_port_create:
 	kfree(mlxsw_sp->port_to_module);
 err_port_to_module_alloc:
 	kfree(mlxsw_sp->ports);
-- 
2.21.0

