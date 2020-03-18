Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22664189D51
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCRNtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57945 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgCRNtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 395595C0293;
        Wed, 18 Mar 2020 09:49:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vKwBPBCFFnDqDv5YkP6WtTlf08rLKtZqcQ0PRxpuAdM=; b=vyxP4Rdb
        3TUloqIIPFcGtPiHzrnM5j9lXpWSiSMI9xB54X10iGj6FlOhz/BySZfHxxnK5fbJ
        9yHe7b3ViL20ZW7atxVAuXqJdDYk93wRYcUlDDkwBjLveHamiKe7jqOJrHswQEO5
        rd7Zc4OZlUKRBZfKs+nwbY5t2bO3fsT1U9kjwTn53qbH3Qw0RpdA3CHgONtzSjre
        Cx/i428Mz26+hDdCj8wrCfvpv+Zm+UAiYH/lgvE7+z/r7E3iG9hSgdxyXBEu92hj
        rY2blN6kHJNE6rnsMe1hyF6j9sT6PiyU2rsM0hm1yf+pYr60FoRpcuIMyP4gR1dg
        rT0nvLLk9N797g==
X-ME-Sender: <xms:_CZyXt0FmtXvBiNsi1-5Tn6Sev_6si5tS0T7jddXdEt8_nOPoOLZfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:_CZyXk4xsVSRVHXuzTacYg1VIA0YezxF9vw6krBYK5Hfck_3RkmuiQ>
    <xmx:_CZyXsdS7v9iHZO6e7_HaZw3dOdZm4pEyY5mkMjzkFt5DWBI4fEp7A>
    <xmx:_CZyXgo11WlvY6IFKQIz5OMWHeNL3vYxCbNkQzjqeu3jvB76jpKPGw>
    <xmx:_CZyXhBuGvIOGY-nJyDzLBjf-M1L1V1g1PNxcGRqA26DSY7hbK4X8A>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id C323B30618C1;
        Wed, 18 Mar 2020 09:49:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_cnt: Expose subpool sizes over devlink resources
Date:   Wed, 18 Mar 2020 15:48:53 +0200
Message-Id: <20200318134857.1003018-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement devlink resources support for counter pools. Move the subpool
sizes calculations into the new resources register function.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 10 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  7 ++
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 99 +++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_cnt.h    |  2 +
 4 files changed, 101 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 51709012593e..35d3a68ef4fd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5421,8 +5421,13 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_resources_span_register;
 
+	err = mlxsw_sp_counter_resources_register(mlxsw_core);
+	if (err)
+		goto err_resources_counter_register;
+
 	return 0;
 
+err_resources_counter_register:
 err_resources_span_register:
 	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
 	return err;
@@ -5440,8 +5445,13 @@ static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_resources_span_register;
 
+	err = mlxsw_sp_counter_resources_register(mlxsw_core);
+	if (err)
+		goto err_resources_counter_register;
+
 	return 0;
 
+err_resources_counter_register:
 err_resources_span_register:
 	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 81801c6fb941..57d8c95e4f9f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -46,6 +46,10 @@
 
 #define MLXSW_SP_RESOURCE_NAME_SPAN "span_agents"
 
+#define MLXSW_SP_RESOURCE_NAME_COUNTERS "counters"
+#define MLXSW_SP_RESOURCE_NAME_COUNTERS_FLOW "flow"
+#define MLXSW_SP_RESOURCE_NAME_COUNTERS_RIF "rif"
+
 enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_KVD = 1,
 	MLXSW_SP_RESOURCE_KVD_LINEAR,
@@ -55,6 +59,9 @@ enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_KVD_LINEAR_CHUNKS,
 	MLXSW_SP_RESOURCE_KVD_LINEAR_LARGE_CHUNKS,
 	MLXSW_SP_RESOURCE_SPAN,
+	MLXSW_SP_RESOURCE_COUNTERS,
+	MLXSW_SP_RESOURCE_COUNTERS_FLOW,
+	MLXSW_SP_RESOURCE_COUNTERS_RIF,
 };
 
 struct mlxsw_sp_port;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index ef2c6c5c8b72..629355cf52a9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -8,15 +8,17 @@
 #include "spectrum_cnt.h"
 
 struct mlxsw_sp_counter_sub_pool {
+	u64 size;
 	unsigned int base_index;
-	unsigned int size;
 	enum mlxsw_res_id entry_size_res_id;
+	const char *resource_name; /* devlink resource name */
+	u64 resource_id; /* devlink resource id */
 	unsigned int entry_size;
 	unsigned int bank_count;
 };
 
 struct mlxsw_sp_counter_pool {
-	unsigned int pool_size;
+	u64 pool_size;
 	unsigned long *usage; /* Usage bitmap */
 	spinlock_t counter_pool_lock; /* Protects counter pool allocations */
 	unsigned int sub_pools_count;
@@ -26,10 +28,14 @@ struct mlxsw_sp_counter_pool {
 static const struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 	[MLXSW_SP_COUNTER_SUB_POOL_FLOW] = {
 		.entry_size_res_id = MLXSW_RES_ID_COUNTER_SIZE_PACKETS_BYTES,
+		.resource_name = MLXSW_SP_RESOURCE_NAME_COUNTERS_FLOW,
+		.resource_id = MLXSW_SP_RESOURCE_COUNTERS_FLOW,
 		.bank_count = 6,
 	},
 	[MLXSW_SP_COUNTER_SUB_POOL_RIF] = {
 		.entry_size_res_id = MLXSW_RES_ID_COUNTER_SIZE_ROUTER_BASIC,
+		.resource_name = MLXSW_SP_RESOURCE_NAME_COUNTERS_RIF,
+		.resource_id = MLXSW_SP_RESOURCE_COUNTERS_RIF,
 		.bank_count = 2,
 	}
 };
@@ -74,18 +80,14 @@ static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
 int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int sub_pools_count = ARRAY_SIZE(mlxsw_sp_counter_sub_pools);
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
 	struct mlxsw_sp_counter_pool *pool;
 	unsigned int base_index;
-	unsigned int bank_size;
 	unsigned int map_size;
 	int i;
 	int err;
 
-	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_POOL_SIZE) ||
-	    !MLXSW_CORE_RES_VALID(mlxsw_sp->core, COUNTER_BANK_SIZE))
-		return -EIO;
-
 	pool = kzalloc(struct_size(pool, sub_pools, sub_pools_count),
 		       GFP_KERNEL);
 	if (!pool)
@@ -104,10 +106,12 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_sub_pools_prepare;
 
-	pool->pool_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_POOL_SIZE);
-	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
+	err = devlink_resource_size_get(devlink, MLXSW_SP_RESOURCE_COUNTERS,
+					&pool->pool_size);
+	if (err)
+		goto err_pool_resource_size_get;
 
-	bank_size = MLXSW_CORE_RES_GET(mlxsw_sp->core, COUNTER_BANK_SIZE);
+	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
 
 	pool->usage = kzalloc(map_size, GFP_KERNEL);
 	if (!pool->usage) {
@@ -115,23 +119,26 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_usage_alloc;
 	}
 
-	/* Allocation is based on bank count which should be
-	 * specified for each sub pool statically.
-	 */
 	base_index = 0;
 	for (i = 0; i < pool->sub_pools_count; i++) {
 		sub_pool = &pool->sub_pools[i];
-		sub_pool->size = sub_pool->bank_count * bank_size;
+
+		err = devlink_resource_size_get(devlink,
+						sub_pool->resource_id,
+						&sub_pool->size);
+		if (err)
+			goto err_sub_pool_resource_size_get;
+
 		sub_pool->base_index = base_index;
 		base_index += sub_pool->size;
-		/* The last bank can't be fully used */
-		if (sub_pool->base_index + sub_pool->size > pool->pool_size)
-			sub_pool->size = pool->pool_size - sub_pool->base_index;
 	}
 
 	return 0;
 
+err_sub_pool_resource_size_get:
+	kfree(pool->usage);
 err_usage_alloc:
+err_pool_resource_size_get:
 err_sub_pools_prepare:
 err_pool_validate:
 	kfree(pool);
@@ -203,3 +210,61 @@ void mlxsw_sp_counter_free(struct mlxsw_sp *mlxsw_sp,
 		__clear_bit(counter_index + i, pool->usage);
 	spin_unlock(&pool->counter_pool_lock);
 }
+
+int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
+{
+	static struct devlink_resource_size_params size_params;
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	const struct mlxsw_sp_counter_sub_pool *sub_pool;
+	u64 sub_pool_size;
+	u64 base_index;
+	u64 pool_size;
+	u64 bank_size;
+	int err;
+	int i;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, COUNTER_POOL_SIZE) ||
+	    !MLXSW_CORE_RES_VALID(mlxsw_core, COUNTER_BANK_SIZE))
+		return -EIO;
+
+	pool_size = MLXSW_CORE_RES_GET(mlxsw_core, COUNTER_POOL_SIZE);
+	bank_size = MLXSW_CORE_RES_GET(mlxsw_core, COUNTER_BANK_SIZE);
+
+	devlink_resource_size_params_init(&size_params, pool_size,
+					  pool_size, bank_size,
+					  DEVLINK_RESOURCE_UNIT_ENTRY);
+	err = devlink_resource_register(devlink,
+					MLXSW_SP_RESOURCE_NAME_COUNTERS,
+					pool_size,
+					MLXSW_SP_RESOURCE_COUNTERS,
+					DEVLINK_RESOURCE_ID_PARENT_TOP,
+					&size_params);
+	if (err)
+		return err;
+
+	/* Allocation is based on bank count which should be
+	 * specified for each sub pool statically.
+	 */
+	base_index = 0;
+	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_counter_sub_pools); i++) {
+		sub_pool = &mlxsw_sp_counter_sub_pools[i];
+		sub_pool_size = sub_pool->bank_count * bank_size;
+		/* The last bank can't be fully used */
+		if (base_index + sub_pool_size > pool_size)
+			sub_pool_size = pool_size - base_index;
+		base_index += sub_pool_size;
+
+		devlink_resource_size_params_init(&size_params, sub_pool_size,
+						  sub_pool_size, bank_size,
+						  DEVLINK_RESOURCE_UNIT_ENTRY);
+		err = devlink_resource_register(devlink,
+						sub_pool->resource_name,
+						sub_pool_size,
+						sub_pool->resource_id,
+						MLXSW_SP_RESOURCE_COUNTERS,
+						&size_params);
+		if (err)
+			return err;
+	}
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
index 81465e267b10..a68d931090dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
@@ -4,6 +4,7 @@
 #ifndef _MLXSW_SPECTRUM_CNT_H
 #define _MLXSW_SPECTRUM_CNT_H
 
+#include "core.h"
 #include "spectrum.h"
 
 enum mlxsw_sp_counter_sub_pool_id {
@@ -19,5 +20,6 @@ void mlxsw_sp_counter_free(struct mlxsw_sp *mlxsw_sp,
 			   unsigned int counter_index);
 int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_counter_pool_fini(struct mlxsw_sp *mlxsw_sp);
+int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core);
 
 #endif
-- 
2.24.1

