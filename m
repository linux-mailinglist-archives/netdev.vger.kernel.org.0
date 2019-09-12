Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9722FB0F93
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfILNIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:08:24 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40035 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731283AbfILNIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:08:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E021021C57;
        Thu, 12 Sep 2019 09:08:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 12 Sep 2019 09:08:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EVytBCD451gjCfmFQvtm73a2+oiaFF3ZkhDNWjHQsnQ=; b=Yc5RZeVE
        BiSOIy6KdNI47mhlabZesRGeZ9N/VzUZn7o/n4v5k6CZB164iFyKvL02SnsGId/n
        ZVtPRehlho86hE6CFKvFtSZop6eOrUjZMV1+e2nTKoI7ZmQxFsC6Ohj55z7knki1
        vLfceBtZvtjVTnKtWzOGhSAE13F4O4B4gcwL6RmCpB9h9CUEceUnRV9+7n02Wdm3
        2TaVC/FEOgGmIKwmWtPhbLrKJJzjym0ayiZcM/xZDFa2SL+1HkVC0QhrPFjDKJEZ
        3FXmsvX6KMq0vwVvSXfGsxm6V8MzZsFIWGyAXeMqKpJ6p5fADOOl6L+EtZGS+Fbc
        4wtznY2nEwJ3pw==
X-ME-Sender: <xms:RkN6XaANtHgaPWTUCbzq3HInKsxaN8oPxIxBlpSUPyThz9F7dsslng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtdehgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:RkN6XYfUkUZub6njyjzPuVM4pJJfdgXcpzYg99Jhuipq7p1CTFD8xQ>
    <xmx:RkN6XWEHOlgAfLd5LzfNU9o15i8cTWUnIUlssIR6r9duKdR-r9ifLw>
    <xmx:RkN6XSVbnhCtPSZNtCCC8NtCAvYHuku7QyvIpHj8ZGmqixVih2RfVg>
    <xmx:RkN6XQecIc8dpyhD69awedYfUK7e2-k0r_Go6HQjpGiWpxrh2B9ylw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D079D6005B;
        Thu, 12 Sep 2019 09:08:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum_buffers: Add the ability to query the CPU port's shared buffer
Date:   Thu, 12 Sep 2019 16:07:40 +0300
Message-Id: <20190912130740.22061-3-idosch@idosch.org>
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

While debugging packet loss towards the CPU, it is useful to be able to
query the CPU port's shared buffer quotas and occupancy.

Since the CPU port has no ingress buffers, all the shared buffers ingress
information will be cleared.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_buffers.c         | 51 ++++++++++++++++---
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 888ba4300bcc..b9eeae37a4dc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -250,6 +250,10 @@ static int mlxsw_sp_sb_pm_occ_clear(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		&mlxsw_sp->sb_vals->pool_dess[pool_index];
 	char sbpm_pl[MLXSW_REG_SBPM_LEN];
 
+	if (local_port == MLXSW_PORT_CPU_PORT &&
+	    des->dir == MLXSW_REG_SBXX_DIR_INGRESS)
+		return 0;
+
 	mlxsw_reg_sbpm_pack(sbpm_pl, local_port, des->pool, des->dir,
 			    true, 0, 0);
 	return mlxsw_reg_trans_query(mlxsw_sp->core, MLXSW_REG(sbpm), sbpm_pl,
@@ -273,6 +277,10 @@ static int mlxsw_sp_sb_pm_occ_query(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	char sbpm_pl[MLXSW_REG_SBPM_LEN];
 	struct mlxsw_sp_sb_pm *pm;
 
+	if (local_port == MLXSW_PORT_CPU_PORT &&
+	    des->dir == MLXSW_REG_SBXX_DIR_INGRESS)
+		return 0;
+
 	pm = mlxsw_sp_sb_pm_get(mlxsw_sp, local_port, pool_index);
 	mlxsw_reg_sbpm_pack(sbpm_pl, local_port, des->pool, des->dir,
 			    false, 0, 0);
@@ -1085,6 +1093,11 @@ int mlxsw_sp_sb_port_pool_set(struct mlxsw_core_port *mlxsw_core_port,
 	u32 max_buff;
 	int err;
 
+	if (local_port == MLXSW_PORT_CPU_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's threshold is forbidden");
+		return -EINVAL;
+	}
+
 	err = mlxsw_sp_sb_threshold_in(mlxsw_sp, pool_index,
 				       threshold, &max_buff, extack);
 	if (err)
@@ -1130,6 +1143,11 @@ int mlxsw_sp_sb_tc_pool_bind_set(struct mlxsw_core_port *mlxsw_core_port,
 	u32 max_buff;
 	int err;
 
+	if (local_port == MLXSW_PORT_CPU_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's binding is forbidden");
+		return -EINVAL;
+	}
+
 	if (dir != mlxsw_sp->sb_vals->pool_dess[pool_index].dir) {
 		NL_SET_ERR_MSG_MOD(extack, "Binding egress TC to ingress pool and vice versa is forbidden");
 		return -EINVAL;
@@ -1187,6 +1205,11 @@ static void mlxsw_sp_sb_sr_occ_query_cb(struct mlxsw_core *mlxsw_core,
 	     local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
 		if (!mlxsw_sp->ports[local_port])
 			continue;
+		if (local_port == MLXSW_PORT_CPU_PORT) {
+			/* Ingress quotas are not supported for the CPU port */
+			masked_count++;
+			continue;
+		}
 		for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++) {
 			cm = mlxsw_sp_sb_cm_get(mlxsw_sp, local_port, i,
 						MLXSW_REG_SBXX_DIR_INGRESS);
@@ -1222,7 +1245,7 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	char *sbsr_pl;
 	u8 masked_count;
 	u8 local_port_1;
-	u8 local_port = 0;
+	u8 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1231,8 +1254,8 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	if (!sbsr_pl)
 		return -ENOMEM;
 
+	local_port = MLXSW_PORT_CPU_PORT;
 next_batch:
-	local_port++;
 	local_port_1 = local_port;
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, false);
@@ -1243,7 +1266,11 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	for (; local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
 		if (!mlxsw_sp->ports[local_port])
 			continue;
-		mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl, local_port, 1);
+		if (local_port != MLXSW_PORT_CPU_PORT) {
+			/* Ingress quotas are not supported for the CPU port */
+			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
+							     local_port, 1);
+		}
 		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl, local_port, 1);
 		for (i = 0; i < mlxsw_sp->sb_vals->pool_count; i++) {
 			err = mlxsw_sp_sb_pm_occ_query(mlxsw_sp, local_port, i,
@@ -1264,8 +1291,10 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 				    cb_priv);
 	if (err)
 		goto out;
-	if (local_port < mlxsw_core_max_ports(mlxsw_core))
+	if (local_port < mlxsw_core_max_ports(mlxsw_core)) {
+		local_port++;
 		goto next_batch;
+	}
 
 out:
 	err2 = mlxsw_reg_trans_bulk_wait(&bulk_list);
@@ -1282,7 +1311,7 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	LIST_HEAD(bulk_list);
 	char *sbsr_pl;
 	unsigned int masked_count;
-	u8 local_port = 0;
+	u8 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1291,8 +1320,8 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	if (!sbsr_pl)
 		return -ENOMEM;
 
+	local_port = MLXSW_PORT_CPU_PORT;
 next_batch:
-	local_port++;
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, true);
 	for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++)
@@ -1302,7 +1331,11 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	for (; local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
 		if (!mlxsw_sp->ports[local_port])
 			continue;
-		mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl, local_port, 1);
+		if (local_port != MLXSW_PORT_CPU_PORT) {
+			/* Ingress quotas are not supported for the CPU port */
+			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
+							     local_port, 1);
+		}
 		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl, local_port, 1);
 		for (i = 0; i < mlxsw_sp->sb_vals->pool_count; i++) {
 			err = mlxsw_sp_sb_pm_occ_clear(mlxsw_sp, local_port, i,
@@ -1319,8 +1352,10 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 				    &bulk_list, NULL, 0);
 	if (err)
 		goto out;
-	if (local_port < mlxsw_core_max_ports(mlxsw_core))
+	if (local_port < mlxsw_core_max_ports(mlxsw_core)) {
+		local_port++;
 		goto next_batch;
+	}
 
 out:
 	err2 = mlxsw_reg_trans_bulk_wait(&bulk_list);
-- 
2.21.0

