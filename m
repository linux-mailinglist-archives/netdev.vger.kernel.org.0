Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398D5189D53
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgCRNtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46649 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727092AbgCRNtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4D4B55C019D;
        Wed, 18 Mar 2020 09:49:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xM1NXhymvuEmmmOpsqXSnzOMbhVcKh95A5b6jbq7L1E=; b=2JWfRQcB
        tHVAhQpdYQXnmpaVJcSEPd8FTcz/eA35I9IAhef4TrG+z+NeVbd13KlPIoTf3ZO9
        c2AkSt6h42bZ2DlGXj1nhLYSFPE5Huq9b1BjLwZnpag+XYTqNKwCKRWtZq2ccZRg
        dfCsVxKFsQY58kQttsvK9G6M28gDGFCoMuBU5QnUST79ZSSVQj8mmhDnsCQ2ENP7
        pHBvEM+5bMqqr9CM8CojNS3ObD6Rgd8WeIkiCFUv9hTNLafp8A32oG8LTzzrFHhz
        b6WyGk7rchHz4ciDrHN2akapxAYzoQ4kkYdQc2b+R9j5431he1zHBQqE2UdcCGDb
        JZ0RT3PLvNH6Vw==
X-ME-Sender: <xms:ACdyXjKrzknN2H-6eLb-YvtmhlINqXe8KcbdWvZNx7vQAVid3MqPhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:ACdyXmD3VUw4FCI-Q9HgikPaVm6PoORsWik-73BghU-OsvQtoFgIXA>
    <xmx:ACdyXsEf0e5BvmiPAAiKu4-G9MPs_wYxiH0xYL1efS4rIWhkbpqQHA>
    <xmx:ACdyXhb0wmDjRK6Rj4R7AGptu9YeEpiSom9h5tPO21sf7BphNxLzOA>
    <xmx:ACdyXjGL8awVyca4W8R9U80mxXJ5V7uAFWGUem5tUXLktxU0ROkrNw>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07FAC3061CB6;
        Wed, 18 Mar 2020 09:49:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_cnt: Expose devlink resource occupancy for counters
Date:   Wed, 18 Mar 2020 15:48:56 +0200
Message-Id: <20200318134857.1003018-9-idosch@idosch.org>
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

Implement occupancy counting for counters and expose over devlink
resource API.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 63 ++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 417c512bc7a2..0268f0a6662a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -15,12 +15,14 @@ struct mlxsw_sp_counter_sub_pool {
 	u64 resource_id; /* devlink resource id */
 	unsigned int entry_size;
 	unsigned int bank_count;
+	atomic_t active_entries_count;
 };
 
 struct mlxsw_sp_counter_pool {
 	u64 pool_size;
 	unsigned long *usage; /* Usage bitmap */
 	spinlock_t counter_pool_lock; /* Protects counter pool allocations */
+	atomic_t active_entries_count;
 	unsigned int sub_pools_count;
 	struct mlxsw_sp_counter_sub_pool sub_pools[];
 };
@@ -40,6 +42,13 @@ static const struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 	}
 };
 
+static u64 mlxsw_sp_counter_sub_pool_occ_get(void *priv)
+{
+	const struct mlxsw_sp_counter_sub_pool *sub_pool = priv;
+
+	return atomic_read(&sub_pool->active_entries_count);
+}
+
 static int mlxsw_sp_counter_sub_pools_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
@@ -62,12 +71,50 @@ static int mlxsw_sp_counter_sub_pools_init(struct mlxsw_sp *mlxsw_sp)
 						sub_pool->resource_id,
 						&sub_pool->size);
 		if (err)
-			return err;
+			goto err_resource_size_get;
+
+		devlink_resource_occ_get_register(devlink,
+						  sub_pool->resource_id,
+						  mlxsw_sp_counter_sub_pool_occ_get,
+						  sub_pool);
 
 		sub_pool->base_index = base_index;
 		base_index += sub_pool->size;
+		atomic_set(&sub_pool->active_entries_count, 0);
 	}
 	return 0;
+
+err_resource_size_get:
+	for (i--; i >= 0; i--) {
+		sub_pool = &pool->sub_pools[i];
+
+		devlink_resource_occ_get_unregister(devlink,
+						    sub_pool->resource_id);
+	}
+	return err;
+}
+
+static void mlxsw_sp_counter_sub_pools_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	struct mlxsw_sp_counter_sub_pool *sub_pool;
+	int i;
+
+	for (i = 0; i < pool->sub_pools_count; i++) {
+		sub_pool = &pool->sub_pools[i];
+
+		WARN_ON(atomic_read(&sub_pool->active_entries_count));
+		devlink_resource_occ_get_unregister(devlink,
+						    sub_pool->resource_id);
+	}
+}
+
+static u64 mlxsw_sp_counter_pool_occ_get(void *priv)
+{
+	const struct mlxsw_sp_counter_pool *pool = priv;
+
+	return atomic_read(&pool->active_entries_count);
 }
 
 int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
@@ -88,11 +135,14 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	       sub_pools_count * sizeof(*sub_pool));
 	pool->sub_pools_count = sub_pools_count;
 	spin_lock_init(&pool->counter_pool_lock);
+	atomic_set(&pool->active_entries_count, 0);
 
 	err = devlink_resource_size_get(devlink, MLXSW_SP_RESOURCE_COUNTERS,
 					&pool->pool_size);
 	if (err)
 		goto err_pool_resource_size_get;
+	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_COUNTERS,
+					  mlxsw_sp_counter_pool_occ_get, pool);
 
 	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
 
@@ -111,6 +161,8 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 err_sub_pools_init:
 	kfree(pool->usage);
 err_usage_alloc:
+	devlink_resource_occ_get_unregister(devlink,
+					    MLXSW_SP_RESOURCE_COUNTERS);
 err_pool_resource_size_get:
 	kfree(pool);
 	return err;
@@ -119,10 +171,15 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 void mlxsw_sp_counter_pool_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 
+	mlxsw_sp_counter_sub_pools_fini(mlxsw_sp);
 	WARN_ON(find_first_bit(pool->usage, pool->pool_size) !=
 			       pool->pool_size);
+	WARN_ON(atomic_read(&pool->active_entries_count));
 	kfree(pool->usage);
+	devlink_resource_occ_get_unregister(devlink,
+					    MLXSW_SP_RESOURCE_COUNTERS);
 	kfree(pool);
 }
 
@@ -158,6 +215,8 @@ int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 	spin_unlock(&pool->counter_pool_lock);
 
 	*p_counter_index = entry_index;
+	atomic_add(sub_pool->entry_size, &sub_pool->active_entries_count);
+	atomic_add(sub_pool->entry_size, &pool->active_entries_count);
 	return 0;
 
 err_alloc:
@@ -180,6 +239,8 @@ void mlxsw_sp_counter_free(struct mlxsw_sp *mlxsw_sp,
 	for (i = 0; i < sub_pool->entry_size; i++)
 		__clear_bit(counter_index + i, pool->usage);
 	spin_unlock(&pool->counter_pool_lock);
+	atomic_sub(sub_pool->entry_size, &sub_pool->active_entries_count);
+	atomic_sub(sub_pool->entry_size, &pool->active_entries_count);
 }
 
 int mlxsw_sp_counter_resources_register(struct mlxsw_core *mlxsw_core)
-- 
2.24.1

