Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9537189D52
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCRNtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32821 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgCRNtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EEB445C0297;
        Wed, 18 Mar 2020 09:49:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=fg+Btp4+F0UdwVSt6wcMRS0gHtr1EL0xkq/m3N5sM3g=; b=EgWPcIM2
        Lv3GnoHT43CXejKgLwMwF6Xtzlo3EICizTwWeVP4cPNq1rTj6MB7Vyx9ihcjroXe
        PP0waqggikRK/V7dw2R4kVDKlsBgo8P9fIfruFhVwWEqzumtiCutVsjNUFohsfKf
        911GPD+SQZbAYcU2ssNX53XwEP2bEWGGwkjvcix8aMJnxC8q+S6x65bgaTKtpPSb
        UYdul973yjencNnqlCtBrg5SQwXU8uum1uQhgcQy24V+cHvnKHKaY+61YRlnrVrT
        0DwyapnSRLqfDNKe7DFT8/S01fOZDUWo0siAXRP9kdxH3UB3Pn7JoLSVRIlcZRvU
        js9pjYj2aCF72A==
X-ME-Sender: <xms:_iZyXs64BGLwalBqF-mHqkK5LnLlMyEWVxMBvbYLFX6ol_1wtHYq5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:_iZyXjbjkkYvFBBXBUyfNbKOYFxCjExxWPQJbI-ASwrUxvS8Ra_OlQ>
    <xmx:_iZyXjzZj7B13nDd34bc4nDMvDNrOjnUi7efvBlNsbVT8Ut-jVTL1Q>
    <xmx:_iZyXvMlclG3U-whIe73ovxY6LkeprRt4QVvF3-tOkNLxMLohDOppQ>
    <xmx:_iZyXmFYBGTUf_5ruGB2VLTDVrGPR71gpNQuAaAWVJ0u4VnV4S_8hQ>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5F463060F09;
        Wed, 18 Mar 2020 09:49:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/9] mlxsw: spectrum_cnt: Consolidate subpools initialization
Date:   Wed, 18 Mar 2020 15:48:55 +0200
Message-Id: <20200318134857.1003018-8-idosch@idosch.org>
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

Put all init operations related to subpools into
mlxsw_sp_counter_sub_pools_init().

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_cnt.c    | 38 ++++++++-----------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index d36904143b10..417c512bc7a2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -40,11 +40,14 @@ static const struct mlxsw_sp_counter_sub_pool mlxsw_sp_counter_sub_pools[] = {
 	}
 };
 
-static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
+static int mlxsw_sp_counter_sub_pools_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_counter_pool *pool = mlxsw_sp->counter_pool;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
+	unsigned int base_index = 0;
 	enum mlxsw_res_id res_id;
+	int err;
 	int i;
 
 	for (i = 0; i < pool->sub_pools_count; i++) {
@@ -55,6 +58,14 @@ static int mlxsw_sp_counter_sub_pools_prepare(struct mlxsw_sp *mlxsw_sp)
 			return -EIO;
 		sub_pool->entry_size = mlxsw_core_res_get(mlxsw_sp->core,
 							  res_id);
+		err = devlink_resource_size_get(devlink,
+						sub_pool->resource_id,
+						&sub_pool->size);
+		if (err)
+			return err;
+
+		sub_pool->base_index = base_index;
+		base_index += sub_pool->size;
 	}
 	return 0;
 }
@@ -65,9 +76,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_counter_sub_pool *sub_pool;
 	struct mlxsw_sp_counter_pool *pool;
-	unsigned int base_index;
 	unsigned int map_size;
-	int i;
 	int err;
 
 	pool = kzalloc(struct_size(pool, sub_pools, sub_pools_count),
@@ -80,10 +89,6 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	pool->sub_pools_count = sub_pools_count;
 	spin_lock_init(&pool->counter_pool_lock);
 
-	err = mlxsw_sp_counter_sub_pools_prepare(mlxsw_sp);
-	if (err)
-		goto err_sub_pools_prepare;
-
 	err = devlink_resource_size_get(devlink, MLXSW_SP_RESOURCE_COUNTERS,
 					&pool->pool_size);
 	if (err)
@@ -97,27 +102,16 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 		goto err_usage_alloc;
 	}
 
-	base_index = 0;
-	for (i = 0; i < pool->sub_pools_count; i++) {
-		sub_pool = &pool->sub_pools[i];
-
-		err = devlink_resource_size_get(devlink,
-						sub_pool->resource_id,
-						&sub_pool->size);
-		if (err)
-			goto err_sub_pool_resource_size_get;
-
-		sub_pool->base_index = base_index;
-		base_index += sub_pool->size;
-	}
+	err = mlxsw_sp_counter_sub_pools_init(mlxsw_sp);
+	if (err)
+		goto err_sub_pools_init;
 
 	return 0;
 
-err_sub_pool_resource_size_get:
+err_sub_pools_init:
 	kfree(pool->usage);
 err_usage_alloc:
 err_pool_resource_size_get:
-err_sub_pools_prepare:
 	kfree(pool);
 	return err;
 }
-- 
2.24.1

