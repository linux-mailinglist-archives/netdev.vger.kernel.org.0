Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92564B34A8
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfIPGSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:18:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50221 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbfIPGSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:18:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D7F52205C;
        Mon, 16 Sep 2019 02:18:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 02:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=osg2+mHHyMRHeTp12En5FEy5RGfU9WtN3rqUbWX52Us=; b=e8oaXPkJ
        1qxVQK/Eof6olciWUbMrfgRcEavASHDVhL0oC0UYYh8qhleYMkqvWB8n0RYIHdyJ
        Mq5Aumo2X2WLoAQemvsc2s/ZhRztQi67usSMv48t2xD7qM2Ut4Gon78jwnx2jEej
        8oxUcROdzsgfOo3KUEk0qmzvzxcGlhKj0DY1EAmo0MWvBBlc2yKv+aT4H1Cy7XcE
        sRtgqQfB/dwjBTFond/40k7qWb/NYtYe3gdFdkTzQEZ/Ccoa7gsBS+bJ3a0WyzLP
        rXm9J3alBhevv3hAURzUQ4SFTveRqo8XdlioBEkfVgryLe3AcEDp1m3j3AYe06GC
        Bha43ya2YoE/Mw==
X-ME-Sender: <xms:Sil_XYKy13STCGuDzWR69B7n55tHJeDsZ0dGJm3-szPy0rQTYvk2mQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:Sil_XR2wnLPkwQCJeIbhHLCC1-JOTUOXL4kAt3OXMHksrja5ANQs3A>
    <xmx:Sil_XYBLDsDSAvXwmGGIwiSXGtvhLNna2Y6zP5lRLogYmTHlfZP1rA>
    <xmx:Sil_XddD7EdOuglIorMQ35a7cvmj8exJZb0uQ0mXfjNVEwoiRVcJxQ>
    <xmx:Syl_XfKG9k-2kwY3WA8-Zfgjm52G0SHvY4GXaj7hNvnIeVJsEz989w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EC9A80069;
        Mon, 16 Sep 2019 02:18:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 3/3] mlxsw: spectrum_buffers: Add the ability to query the CPU port's shared buffer
Date:   Mon, 16 Sep 2019 09:17:50 +0300
Message-Id: <20190916061750.26207-4-idosch@idosch.org>
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

While debugging packet loss towards the CPU, it is useful to be able to
query the CPU port's shared buffer quotas and occupancy.

Since the CPU port has no ingress buffers, all the shared buffers ingress
information will be cleared.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
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

