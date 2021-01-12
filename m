Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF122F2A2C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392385AbhALIlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:41:13 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54117 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729871AbhALIlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:41:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F6A45C0200;
        Tue, 12 Jan 2021 03:40:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 12 Jan 2021 03:40:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=lSnJ06/tG6l4wYpZrWU37uPrKpNOWbnlrBtvF4KhJBw=; b=Pgo9lqvw
        kUU671qIEBvI8//g+DczOOVrID/NHZgibrAJmDyWu0W81XszkvYGQuS8coohh1mQ
        4FpATkeFdixB6Mr3hKkjNjmz/Vh+eokXQ4jLvY2828vSrE16MxDtnq5GeMrOlvDq
        GNn26ZnZj8AdpkftIh/BbsCLyW3u5T6elO4xbJhqklbaTfDaIFWnmgzPKN28qDfK
        wey6GxB6OsZSfZnnboeEWART3X0oCIKodRRWWmXAaNzFb1Gvn/NYGKj3740LamxX
        wDfmo4rXrWgEi4KPq6uvfCPu+pBmS8Mls+oW1jtiC/oFX1eppXSWE35J0051/5j0
        0fwkVosiXwFpJQ==
X-ME-Sender: <xms:ZmD9XwsgH3Qez0cSAV7pOP-qhQZJClZbRzwRMxDAvZZ9a_YCZ5FEQw>
    <xme:ZmD9X9eiJMQtRHKiG3xDxujkjhR3CbuE5llscUsgnmdWLztokQWArdlODSmdpKLF_
    7qrUa64s0Gx1Pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehvddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZmD9X7zXevV_xRLL8VbvVt-H4MZEAeEmmPGG5O-Yn0J6MlbPea4Xfw>
    <xmx:ZmD9XzMvVBFtxs8y-pWuvwjE7HWjGMoID_flaCd9PvjT3WurgsHz8Q>
    <xmx:ZmD9Xw-vh_xp75pBYZHt6QvnGm0daUaXwJ2Ab3r9SHbRu_--f-GO9Q>
    <xmx:ZmD9X_ZmvuwysylIsq1ITLwDhhgev3yzjLg3vqeE9In0_7FrKZseeA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06A99108005F;
        Tue, 12 Jan 2021 03:40:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] mlxsw: Register physical ports as a devlink resource
Date:   Tue, 12 Jan 2021 10:39:30 +0200
Message-Id: <20210112083931.1662874-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112083931.1662874-1-idosch@idosch.org>
References: <20210112083931.1662874-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The switch ASIC has a limited capacity of physical ('flavour physical'
in devlink terminology) ports that it can support. While each system is
brought up with a different number of ports, this number can be
increased via splitting up to the ASIC's limit.

Expose physical ports as a devlink resource so that user space will have
visibility to the maximum number of ports that can be supported and the
current occupancy.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 77 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 3 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 685037e052af..8e8a5188c3a5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -84,6 +84,7 @@ struct mlxsw_core {
 	struct mlxsw_thermal *thermal;
 	struct mlxsw_core_port *ports;
 	unsigned int max_ports;
+	atomic_t active_ports_count;
 	bool fw_flash_in_progress;
 	struct {
 		struct devlink_health_reporter *fw_fatal;
@@ -95,9 +96,37 @@ struct mlxsw_core {
 };
 
 #define MLXSW_PORT_MAX_PORTS_DEFAULT	0x40
+#define MLXSW_CORE_RESOURCE_NAME_PORTS "physical_ports"
 
-static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core)
+static u64 mlxsw_ports_occ_get(void *priv)
 {
+	struct mlxsw_core *mlxsw_core = priv;
+
+	return atomic_read(&mlxsw_core->active_ports_count);
+}
+
+static int mlxsw_core_resources_ports_register(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_resource_size_params ports_num_params;
+	u32 max_ports;
+
+	max_ports = mlxsw_core->max_ports - 1;
+	devlink_resource_size_params_init(&ports_num_params, max_ports,
+					  max_ports, 1,
+					  DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	return devlink_resource_register(devlink, MLXSW_CORE_RESOURCE_NAME_PORTS,
+					 max_ports, MLXSW_CORE_RESOURCE_PORTS,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP,
+					 &ports_num_params);
+}
+
+static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core, bool reload)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	int err;
+
 	/* Switch ports are numbered from 1 to queried value */
 	if (MLXSW_CORE_RES_VALID(mlxsw_core, MAX_SYSTEM_PORT))
 		mlxsw_core->max_ports = MLXSW_CORE_RES_GET(mlxsw_core,
@@ -110,11 +139,30 @@ static int mlxsw_ports_init(struct mlxsw_core *mlxsw_core)
 	if (!mlxsw_core->ports)
 		return -ENOMEM;
 
+	if (!reload) {
+		err = mlxsw_core_resources_ports_register(mlxsw_core);
+		if (err)
+			goto err_resources_ports_register;
+	}
+	atomic_set(&mlxsw_core->active_ports_count, 0);
+	devlink_resource_occ_get_register(devlink, MLXSW_CORE_RESOURCE_PORTS,
+					  mlxsw_ports_occ_get, mlxsw_core);
+
 	return 0;
+
+err_resources_ports_register:
+	kfree(mlxsw_core->ports);
+	return err;
 }
 
-static void mlxsw_ports_fini(struct mlxsw_core *mlxsw_core)
+static void mlxsw_ports_fini(struct mlxsw_core *mlxsw_core, bool reload)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+
+	devlink_resource_occ_get_unregister(devlink, MLXSW_CORE_RESOURCE_PORTS);
+	if (!reload)
+		devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
+
 	kfree(mlxsw_core->ports);
 }
 
@@ -1897,7 +1945,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_register_resources;
 	}
 
-	err = mlxsw_ports_init(mlxsw_core);
+	err = mlxsw_ports_init(mlxsw_core, reload);
 	if (err)
 		goto err_ports_init;
 
@@ -1986,7 +2034,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 err_emad_init:
 	kfree(mlxsw_core->lag.mapping);
 err_alloc_lag_mapping:
-	mlxsw_ports_fini(mlxsw_core);
+	mlxsw_ports_fini(mlxsw_core, reload);
 err_ports_init:
 	if (!reload)
 		devlink_resources_unregister(devlink, NULL);
@@ -2056,7 +2104,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 		devlink_unregister(devlink);
 	mlxsw_emad_fini(mlxsw_core);
 	kfree(mlxsw_core->lag.mapping);
-	mlxsw_ports_fini(mlxsw_core);
+	mlxsw_ports_fini(mlxsw_core, reload);
 	if (!reload)
 		devlink_resources_unregister(devlink, NULL);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
@@ -2755,16 +2803,25 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len)
 {
-	return __mlxsw_core_port_init(mlxsw_core, local_port,
-				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				      port_number, split, split_port_subnumber,
-				      splittable, lanes,
-				      switch_id, switch_id_len);
+	int err;
+
+	err = __mlxsw_core_port_init(mlxsw_core, local_port,
+				     DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				     port_number, split, split_port_subnumber,
+				     splittable, lanes,
+				     switch_id, switch_id_len);
+	if (err)
+		return err;
+
+	atomic_inc(&mlxsw_core->active_ports_count);
+	return 0;
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 {
+	atomic_dec(&mlxsw_core->active_ports_count);
+
 	__mlxsw_core_port_fini(mlxsw_core, local_port);
 }
 EXPORT_SYMBOL(mlxsw_core_port_fini);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6b3ccbf6b238..8af7d9d03475 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -19,6 +19,11 @@
 #include "cmd.h"
 #include "resources.h"
 
+enum mlxsw_core_resource_id {
+	MLXSW_CORE_RESOURCE_PORTS = 1,
+	MLXSW_CORE_RESOURCE_MAX,
+};
+
 struct mlxsw_core;
 struct mlxsw_core_port;
 struct mlxsw_driver;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a6956cfc9cb1..a3769f95a182 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -52,7 +52,7 @@
 #define MLXSW_SP_RESOURCE_NAME_COUNTERS_RIF "rif"
 
 enum mlxsw_sp_resource_id {
-	MLXSW_SP_RESOURCE_KVD = 1,
+	MLXSW_SP_RESOURCE_KVD = MLXSW_CORE_RESOURCE_MAX,
 	MLXSW_SP_RESOURCE_KVD_LINEAR,
 	MLXSW_SP_RESOURCE_KVD_HASH_SINGLE,
 	MLXSW_SP_RESOURCE_KVD_HASH_DOUBLE,
-- 
2.29.2

