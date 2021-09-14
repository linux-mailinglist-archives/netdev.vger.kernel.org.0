Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3811040A691
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbhINGPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59387 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240042AbhINGPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EA4995C00AC;
        Tue, 14 Sep 2021 02:14:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 14 Sep 2021 02:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=+G2L0kYmVyN0rt27rEAddb2EHZOFSQaAfWpGLi8u6Xo=; b=Pl0CL8Vn
        0OWs5oQRtDGcZwGn+3iY5bnYXSVefcvAVMMHM0jzeOR0vNgsXxXh5dFa9hLekCiE
        k+Ac+06DX1qkCD/5CuOeRqN8gR+VZZDLvKDz5yWk+gpwtsfEEi4jKrc+ziURN2uG
        zVJ/DD1ycDeaWwfRybzjEFvgM8yza0b8QxY8DUsaQNbnkYHGaeFniR3jA/K8bJPh
        qaBlQvH2YIxR2U1+4hNIEEgV9wKbuXnn05aArSphKZ06ePMhDJsf18JY5G2REtHg
        M6ETVUQRnJ6eDX/hW+jt0TNm+4Y+1emjgJCHQLUHHzKoS+lgGOuZgaH+eaEU8GdN
        n2AUUWNiLR3JBQ==
X-ME-Sender: <xms:wT1AYT4odTzBAnZTVxagE-v614nj1CuTYv4Bf3qxQ2JX0G9IcRWpUA>
    <xme:wT1AYY7yJyVNlD6sazGtDh0REpFZPsGw5AMX-5cT3_O_BwTxs922RQG2Q-ZaL46Jo
    uWOAJ7UuH9BDqY>
X-ME-Received: <xmr:wT1AYacyNmzpBfaeD5aO1PLekpMmGWQAAxjH0S6nil-iz_LGio1PVwoctEKQ7TCoNO-Yi0FeV_7QVdC03iKc8gZ_dMDvkqlypg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wT1AYUIHbY0BStDze3vYny41hvLkAc9xivEFyZ_N2i_fOo0WeINQZA>
    <xmx:wT1AYXInDVVdxQZCrxa3BUnDFJseXX1Stemol6t_g1KgqSZ9dzdZRQ>
    <xmx:wT1AYdzTCMIWFEduekLtVGZ63CgK2doAt5r61VT9PPg75IJXr92uQw>
    <xmx:wT1AYf1YLafo8x4JQrK3-X-3HSB4eenjJry8phV6mi--kTtyxpxfBA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum: Move port SWID set before core port init
Date:   Tue, 14 Sep 2021 09:13:25 +0300
Message-Id: <20210914061330.226000-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914061330.226000-1-idosch@idosch.org>
References: <20210914061330.226000-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

During port creation, mlxsw_core_port_init() is called with the front
panel port number and the split port sub-number. Currently, this
information is determined by the driver without firmware assistance.

Subsequent patches are going to query this information from firmware,
but this requires the port to assigned to SWID.

Therefore, move port SWID assignment before mlxsw_core_port_init().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 912a7f8f6c1f..e12232f371c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -351,12 +351,12 @@ static int mlxsw_sp_port_mtu_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmtu), pmtu_pl);
 }
 
-static int mlxsw_sp_port_swid_set(struct mlxsw_sp_port *mlxsw_sp_port, u8 swid)
+static int mlxsw_sp_port_swid_set(struct mlxsw_sp *mlxsw_sp,
+				  u8 local_port, u8 swid)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char pspa_pl[MLXSW_REG_PSPA_LEN];
 
-	mlxsw_reg_pspa_pack(pspa_pl, swid, mlxsw_sp_port->local_port);
+	mlxsw_reg_pspa_pack(pspa_pl, swid, local_port);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pspa), pspa_pl);
 }
 
@@ -1460,6 +1460,13 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		return err;
 	}
 
+	err = mlxsw_sp_port_swid_set(mlxsw_sp, local_port, 0);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to set SWID\n",
+			local_port);
+		goto err_port_swid_set;
+	}
+
 	splittable = lanes > 1 && !split;
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
@@ -1504,13 +1511,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	dev->netdev_ops = &mlxsw_sp_port_netdev_ops;
 	dev->ethtool_ops = &mlxsw_sp_port_ethtool_ops;
 
-	err = mlxsw_sp_port_swid_set(mlxsw_sp_port, 0);
-	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to set SWID\n",
-			mlxsw_sp_port->local_port);
-		goto err_port_swid_set;
-	}
-
 	err = mlxsw_sp_port_dev_addr_init(mlxsw_sp_port);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unable to init port mac address\n",
@@ -1711,14 +1711,15 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_port_speed_by_width_set:
 err_port_system_port_mapping_set:
 err_dev_addr_init:
-	mlxsw_sp_port_swid_set(mlxsw_sp_port, MLXSW_PORT_SWID_DISABLED_PORT);
-err_port_swid_set:
 	free_percpu(mlxsw_sp_port->pcpu_stats);
 err_alloc_stats:
 	free_netdev(dev);
 err_alloc_etherdev:
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
 err_core_port_init:
+	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
+			       MLXSW_PORT_SWID_DISABLED_PORT);
+err_port_swid_set:
 	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port);
 	return err;
 }
@@ -1741,11 +1742,12 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	mlxsw_sp_port_dcb_fini(mlxsw_sp_port);
 	mlxsw_sp_port_tc_mc_mode_set(mlxsw_sp_port, false);
 	mlxsw_sp_port_buffers_fini(mlxsw_sp_port);
-	mlxsw_sp_port_swid_set(mlxsw_sp_port, MLXSW_PORT_SWID_DISABLED_PORT);
 	free_percpu(mlxsw_sp_port->pcpu_stats);
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp_port->vlans_list));
 	free_netdev(mlxsw_sp_port->dev);
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
+	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
+			       MLXSW_PORT_SWID_DISABLED_PORT);
 	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port);
 }
 
-- 
2.31.1

