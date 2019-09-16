Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C701B3D40
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388940AbfIPPEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:04:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50559 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730609AbfIPPEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:04:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2AA7121F7D;
        Mon, 16 Sep 2019 11:04:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 11:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0WSfDcaxTDaYKAM0rYPAE1enyWcug7GFb1K9Ed4SmZM=; b=teqb3KJW
        TCeAobiPw+sQE7itN37FQtsI+RfRf/mgppaES7C7/v/m7CdM9hJz1acvxTmthtpm
        jh/wJWcgbcEY2PK2YF7Y9MDThpI+AWeYzfrvLQoynlZ/H3jg0XV2gGsmIVisCJ5t
        PhzYIedemAZXzpcOHs1qFq3BhI1v3e3jogk6jjA5iykIHLbrvr8u2EKJ5QJmxchL
        9NcXULl2JAak9tJvZYA63uVMo+vlOA05VEEo6X/TLDZY4YQeHBWWi7RNnWyJfKbU
        qVP/29oDnRiUPyqbQ44pdFlZYOlqwLefVwXCFawHkkrU7Z/SSkRVWfHq0X9+cpTY
        Kb58rKukM3PtKg==
X-ME-Sender: <xms:kqR_XWJEQClN4RVBBD6OIXCtLkPaJqdbPpzK0QWXaSoo2L5-slfKxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:kqR_XedXAo8LdWrHBcplPvvc02n6g17IAVtfgPnyCPLs69J_N_sEhw>
    <xmx:kqR_XeXad1cTA-weujIis_3ufyEBXUhQwA1F44z06KDQEJjv-N7XJA>
    <xmx:kqR_XWCj_xchH8so6zAKO1mxQNLU-AkenrHJwkQ91r6JDZt4WCkRWA>
    <xmx:k6R_XTpSEQoBR6dBFESVj3K67TBFDpok6oGa2BTRkO3MTRRjB7FcnA>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B47880069;
        Mon, 16 Sep 2019 11:04:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 3/3] mlxsw: spectrum_buffers: Add the ability to query the CPU port's shared buffer
Date:   Mon, 16 Sep 2019 18:04:22 +0300
Message-Id: <20190916150422.28947-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916150422.28947-1-idosch@idosch.org>
References: <20190916150422.28947-1-idosch@idosch.org>
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
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_buffers.c         | 41 +++++++++++++++----
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index f1dbde73fa78..b9eeae37a4dc 100644
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
@@ -1197,6 +1205,11 @@ static void mlxsw_sp_sb_sr_occ_query_cb(struct mlxsw_core *mlxsw_core,
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
@@ -1232,7 +1245,7 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	char *sbsr_pl;
 	u8 masked_count;
 	u8 local_port_1;
-	u8 local_port = 0;
+	u8 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1241,8 +1254,8 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	if (!sbsr_pl)
 		return -ENOMEM;
 
+	local_port = MLXSW_PORT_CPU_PORT;
 next_batch:
-	local_port++;
 	local_port_1 = local_port;
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, false);
@@ -1253,7 +1266,11 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
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
@@ -1274,8 +1291,10 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
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
@@ -1292,7 +1311,7 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	LIST_HEAD(bulk_list);
 	char *sbsr_pl;
 	unsigned int masked_count;
-	u8 local_port = 0;
+	u8 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1301,8 +1320,8 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	if (!sbsr_pl)
 		return -ENOMEM;
 
+	local_port = MLXSW_PORT_CPU_PORT;
 next_batch:
-	local_port++;
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, true);
 	for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++)
@@ -1312,7 +1331,11 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
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
@@ -1329,8 +1352,10 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
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

