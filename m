Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC392FEB44
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbhAUNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:14:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42077 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731553AbhAUNL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:11:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 37DC25C0090;
        Thu, 21 Jan 2021 08:11:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 21 Jan 2021 08:11:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=IhfV5vGjiGBVhnEn3FlwpZhxBrh8LNnllvqzqfsSTm8=; b=LllFotd6
        +AovmVTvc8raNd98fKKyT7iuxib/BPDh0jCp9fk+PmenzkTBi/5x1BtFrzgYql+A
        0djMdnC3NPR3QxB/P3SJhdwgL5X+LRrp8lkvhG/wAoNqX4+s3r/OjTK8kLZVXEzp
        iEfxLHnNJ+4JXarAo0COdjLlDrP2vv4aUfHkXfF2VC/zxLpLOxfzSgKj39mUsKK7
        GU2wEoQ7XJkfxeQxzRKBRJtSgBVqbTGTj7TAB7xn64h0u5A7Y6QBYffdITZqwkkf
        OPZwPyhXTHbnDF+l7Lt4j4VhlAyuav2Cf0gDLxh1YFR73s0xv3rOwsraMKUE5B2Q
        26rHyN6xxMNGXw==
X-ME-Sender: <xms:aX0JYNm6iEIHuMXYZgWii_WFTU_j09L7XnHfT3L_LUgsagfc6AHyzg>
    <xme:aX0JYI2gGOIrxE6VCgXzo5B7hBfYltPobESAU6sIiOu2U4ANj-ZSygxK2lqoZ2Snp
    7HsBBGylB4SkfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:aX0JYDpiF6THBVFNdYmaj75Qux11okyHmbeVytEdpG-aagsKlePQwg>
    <xmx:aX0JYNlakP57iZs0Dh--8o__UxTtoeZ4gKZubFJhrgZS2rkpBPWx6A>
    <xmx:aX0JYL1oZT84_VUAuLZ4PUzjO6SCS2YOACLJqasx6lpavZp5JbBWGw>
    <xmx:aX0JYMzWZTbmM7EXegsbPbsX3aDSrGRjaba3vO6xATgJE_Cj_8JD_A>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC02424005E;
        Thu, 21 Jan 2021 08:11:03 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 1/2] mlxsw: Register physical ports as a devlink resource
Date:   Thu, 21 Jan 2021 15:10:23 +0200
Message-Id: <20210121131024.2656154-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121131024.2656154-1-idosch@idosch.org>
References: <20210121131024.2656154-1-idosch@idosch.org>
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

In addition, add a "Generic Resources" section in devlink-resource
documentation so the different drivers will be aligned by the same resource
name when exposing to user space.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-resource.rst   | 14 ++++
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 77 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 include/net/devlink.h                         |  2 +
 net/core/devlink.c                            |  4 +
 6 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-resource.rst b/Documentation/networking/devlink/devlink-resource.rst
index 93e92d2f0752..3d5ae51e65a2 100644
--- a/Documentation/networking/devlink/devlink-resource.rst
+++ b/Documentation/networking/devlink/devlink-resource.rst
@@ -23,6 +23,20 @@ current size and related sub resources. To access a sub resource, you
 specify the path of the resource. For example ``/IPv4/fib`` is the id for
 the ``fib`` sub-resource under the ``IPv4`` resource.
 
+Generic Resources
+=================
+
+Generic resources are used to describe resources that can be shared by multiple
+device drivers and their description must be added to the following table:
+
+.. list-table:: List of Generic Resources
+   :widths: 10 90
+
+   * - Name
+     - Description
+   * - ``physical_ports``
+     - A limited capacity of physical ports that the switch ASIC can support
+
 example usage
 -------------
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 685037e052af..52fdc34251ba 100644
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
@@ -96,8 +97,36 @@ struct mlxsw_core {
 
 #define MLXSW_PORT_MAX_PORTS_DEFAULT	0x40
 
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
+	return devlink_resource_register(devlink,
+					 DEVLINK_RESOURCE_GENERIC_NAME_PORTS,
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
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f466819cc477..d12ed2854c34 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -380,6 +380,8 @@ struct devlink_resource {
 
 #define DEVLINK_RESOURCE_ID_PARENT_TOP 0
 
+#define DEVLINK_RESOURCE_GENERIC_NAME_PORTS "physical_ports"
+
 #define __DEVLINK_PARAM_MAX_STRING_VALUE 32
 enum devlink_param_type {
 	DEVLINK_PARAM_TYPE_U8,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 738d4344d679..72ea79879762 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8617,6 +8617,10 @@ EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
  *	@resource_id: resource's id
  *	@parent_resource_id: resource's parent id
  *	@size_params: size parameters
+ *
+ *	Generic resources should reuse the same names across drivers.
+ *	Please see the generic resources list at:
+ *	Documentation/networking/devlink/devlink-resource.rst
  */
 int devlink_resource_register(struct devlink *devlink,
 			      const char *resource_name,
-- 
2.29.2

