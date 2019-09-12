Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67816B0F92
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731967AbfILNIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:08:22 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40859 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731283AbfILNIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:08:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E63E21E6A;
        Thu, 12 Sep 2019 09:08:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 12 Sep 2019 09:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=J7bAyPXIg509iyx75cVLcNhXiN1FifIGHVfX1YA2sbA=; b=B/RJSE2J
        4DpATS/SoQdvgvg3h3LvLxszE3SeSVRtSe9obrQ4/zcyarhqHSyX65zt0tlokxZp
        iEYSERKQpY03FN3EFIlhZJhn6wBeEZr3Aj81Xa3qtzq6ilqLhijNzOqBurzv4uHT
        Ooe4iznG+qVaxntKAHOFyStyJWRGUhpB4shRZdmehir+z+Qj1IsCGi2nVdHseLvs
        A6j9WjRud/x+uQuVkUSgAMJOn/QZcnU1WXrPEMi3r4RGHR5jnf4903Zfjz4KzC5p
        dLB3b0w0hK9+HyhRw9vhF4C3etWaIjWJBMf+5dA9tbV73yX2qSlyeyfsNIO0IBc0
        RbwA6P49HUUpDg==
X-ME-Sender: <xms:REN6XXMOau0HY28DA3p1F-GlQ7K-CXaTrnNopLbdGJuYeZDoUJuDqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtdehgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:REN6XWNuTAzNf1y5rhZNUAtDATm4XwHcht71rT9N3a6Z37QydLv7Ug>
    <xmx:REN6XRTfpkZkPRbxr26nocJDm6Ukb-7z3s6D0OGZkj0q-7Pa70MvdA>
    <xmx:REN6XQD95w7oGSmfblU9OyROPMGmLi_bWJu6j2KkEL4eknJACY9TaA>
    <xmx:RUN6Xf-Wh_DJrOt3a5xnDXzLgnljeoLUAPP3ljJGaPHJcrQA1tEgAg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40DB0D6005B;
        Thu, 12 Sep 2019 09:08:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: spectrum: Register CPU port with devlink
Date:   Thu, 12 Sep 2019 16:07:39 +0300
Message-Id: <20190912130740.22061-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912130740.22061-1-idosch@idosch.org>
References: <20190912130740.22061-1-idosch@idosch.org>
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
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 33 +++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 47 +++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 963a2b4b61b1..94f83d2be17e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1892,6 +1892,39 @@ void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 }
 EXPORT_SYMBOL(mlxsw_core_port_fini);
 
+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
+			     void *port_driver_priv,
+			     const unsigned char *switch_id,
+			     unsigned char switch_id_len)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct mlxsw_core_port *mlxsw_core_port =
+					&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
+	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
+	int err;
+
+	mlxsw_core_port->local_port = MLXSW_PORT_CPU_PORT;
+	mlxsw_core_port->port_driver_priv = port_driver_priv;
+	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_CPU,
+			       0, false, 0, switch_id, switch_id_len);
+	err = devlink_port_register(devlink, devlink_port, MLXSW_PORT_CPU_PORT);
+	if (err)
+		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_core_cpu_port_init);
+
+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_core_port *mlxsw_core_port =
+					&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
+	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
+
+	devlink_port_unregister(devlink_port);
+	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
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
index 91e4792bb7e7..1fc73a9ad84d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3872,6 +3872,46 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
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
+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = mlxsw_sp_port;
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
+	return err;
+
+err_core_cpu_port_init:
+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = NULL;
+	kfree(mlxsw_sp_port);
+	return err;
+}
+
+static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[0];
+
+	mlxsw_core_cpu_port_fini(mlxsw_sp->core);
+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = NULL;
+	kfree(mlxsw_sp_port);
+}
+
 static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
 	return mlxsw_sp->ports[local_port] != NULL;
@@ -3884,6 +3924,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 	kfree(mlxsw_sp->port_to_module);
 	kfree(mlxsw_sp->ports);
 }
@@ -3908,6 +3949,10 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		goto err_port_to_module_alloc;
 	}
 
+	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
+	if (err)
+		goto err_cpu_port_create;
+
 	for (i = 1; i < max_ports; i++) {
 		/* Mark as invalid */
 		mlxsw_sp->port_to_module[i] = -1;
@@ -3931,6 +3976,8 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
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

