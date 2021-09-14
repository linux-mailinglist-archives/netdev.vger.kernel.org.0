Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83EB40A690
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhINGPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:15:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35921 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239908AbhINGPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:15:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BF615C017E;
        Tue, 14 Sep 2021 02:14:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Sep 2021 02:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mD+w7Du8zZJu/wP0z5jtXI6MwKq4H27SlcWOyPEi/7k=; b=bav/Qcop
        iilYaMUzP0D0imQO3zInc6xT39cUAmFh5hrbDP/GvigifWDm3Gnr1IJWisxY8Nqe
        LuKjmPMFBLIlbQOCz4bUrFe07gTEtWNazzGYkbzrFSxm3U/3Ta+NMFogqBoSaChE
        koW4DG5m8bqbnysPNx/DSVTLrPAlOj4PuZhf+TVFd0R+QAEEbQsUrz+gvfV1I/ar
        Pgkw9NVjL+WAGGifih+BdNK6CpGnsIFLwKfbTW5bjamz19BnsffYT8YgDb2UAD14
        DWy6ENAI21J9QEQCVtkMe2IM9hm0Tq/jVBgBij2qSFRkMIGK3r+yyIRDYxMBhRmD
        5ZMGjmQzJn2V+Q==
X-ME-Sender: <xms:vz1AYX1nh1j1J3aFESNDQaHlsbDDABlgKf1qDceKec-8MLH4ZPrQ-w>
    <xme:vz1AYWF6020fjl5h20shBmXj8eEfanR942UKp5WhW5llRBOszp0GGPmbZAw0h6h5_
    _Gkf7VrAZ2Gn70>
X-ME-Received: <xmr:vz1AYX6Zyqn7UOMcNGkRaw-HgkFE_rVsAVu-s2P72xuJF9S45YnlVbxv8exrmBVPmfgqesuSyIQq1q12MSpqgq4Jy61iI9DMvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wD1AYc36NVoo0nW8wzpE6Y8nwISzWLK_MzLvE3bjNJnTlaTjsfxV0g>
    <xmx:wD1AYaG7jx_jTdX_h36r0wOGdkEf0Qff_fPCeIvO7fBVtHkUl6AtZA>
    <xmx:wD1AYd8lGKoc8bDtOqPmNhf8TT72UtaNQNIo-OnsUwOuuf4fH7tLBg>
    <xmx:wD1AYWDIhcx7qlU_HLVgFiq2FI-ZOe11kcX-VLV6yYRmYRTd4e19aA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 02:14:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum: Move port module mapping before core port init
Date:   Tue, 14 Sep 2021 09:13:24 +0300
Message-Id: <20210914061330.226000-3-idosch@idosch.org>
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
but this requires the port to be mapped to a module.

Therefore, move port mapping before mlxsw_core_port_init().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 35 +++++++++----------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 583b09be92e6..912a7f8f6c1f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -533,14 +533,14 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	return 0;
 }
 
-static int mlxsw_sp_port_module_map(struct mlxsw_sp_port *mlxsw_sp_port)
+static int
+mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+			 const struct mlxsw_sp_port_mapping *port_mapping)
 {
-	struct mlxsw_sp_port_mapping *port_mapping = &mlxsw_sp_port->mapping;
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	int i;
 
-	mlxsw_reg_pmlp_pack(pmlp_pl, mlxsw_sp_port->local_port);
+	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, port_mapping->width);
 	for (i = 0; i < port_mapping->width; i++) {
 		mlxsw_reg_pmlp_module_set(pmlp_pl, i, port_mapping->module);
@@ -550,12 +550,11 @@ static int mlxsw_sp_port_module_map(struct mlxsw_sp_port *mlxsw_sp_port)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
 }
 
-static int mlxsw_sp_port_module_unmap(struct mlxsw_sp_port *mlxsw_sp_port)
+static int mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 
-	mlxsw_reg_pmlp_pack(pmlp_pl, mlxsw_sp_port->local_port);
+	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, 0);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
 }
@@ -1454,6 +1453,13 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	bool splittable;
 	int err;
 
+	err = mlxsw_sp_port_module_map(mlxsw_sp, local_port, port_mapping);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to map module\n",
+			local_port);
+		return err;
+	}
+
 	splittable = lanes > 1 && !split;
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
@@ -1464,7 +1470,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to init core port\n",
 			local_port);
-		return err;
+		goto err_core_port_init;
 	}
 
 	dev = alloc_etherdev(sizeof(struct mlxsw_sp_port));
@@ -1498,13 +1504,6 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	dev->netdev_ops = &mlxsw_sp_port_netdev_ops;
 	dev->ethtool_ops = &mlxsw_sp_port_ethtool_ops;
 
-	err = mlxsw_sp_port_module_map(mlxsw_sp_port);
-	if (err) {
-		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to map module\n",
-			mlxsw_sp_port->local_port);
-		goto err_port_module_map;
-	}
-
 	err = mlxsw_sp_port_swid_set(mlxsw_sp_port, 0);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to set SWID\n",
@@ -1714,13 +1713,13 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_dev_addr_init:
 	mlxsw_sp_port_swid_set(mlxsw_sp_port, MLXSW_PORT_SWID_DISABLED_PORT);
 err_port_swid_set:
-	mlxsw_sp_port_module_unmap(mlxsw_sp_port);
-err_port_module_map:
 	free_percpu(mlxsw_sp_port->pcpu_stats);
 err_alloc_stats:
 	free_netdev(dev);
 err_alloc_etherdev:
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
+err_core_port_init:
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port);
 	return err;
 }
 
@@ -1743,11 +1742,11 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	mlxsw_sp_port_tc_mc_mode_set(mlxsw_sp_port, false);
 	mlxsw_sp_port_buffers_fini(mlxsw_sp_port);
 	mlxsw_sp_port_swid_set(mlxsw_sp_port, MLXSW_PORT_SWID_DISABLED_PORT);
-	mlxsw_sp_port_module_unmap(mlxsw_sp_port);
 	free_percpu(mlxsw_sp_port->pcpu_stats);
 	WARN_ON_ONCE(!list_empty(&mlxsw_sp_port->vlans_list));
 	free_netdev(mlxsw_sp_port->dev);
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port);
 }
 
 static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
-- 
2.31.1

