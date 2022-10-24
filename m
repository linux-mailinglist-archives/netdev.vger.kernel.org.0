Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17F160B191
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiJXQ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiJXQ1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207BF4C01C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37A2661350
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCBFC43142;
        Mon, 24 Oct 2022 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620024;
        bh=bQN/DYEvltT2yb8lvc8B6iR5BURcov6/IT/dptOT+vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvbH+O+dJSkub2scKDBo8udhZzEXvGFEpieaRz9juqjAU80yv5dqxYDBY89g78VC4
         FAAcWQ8loZQf9lXKr2AA8Hf3wEhypdJmuE4qvEdz+VE1p9G4O3HyQIiebRfoUOJ/8b
         qG44LDPGE8ev9Quu2k1Ne8eDgKODWW3GVL8/Nn6RzFuSqg851V0KcnPTC+BgRsvAxK
         /Ye2UqJcaqEK3c/vvtllnLrQr+Nqku2APvS6sr9bzceMSmqYZ6VeB8C/u8JS57CgkR
         QIY+pcUBxpRo87/1jPYAKOUHjT+4Vga2iGY0J6RF8FtRDf4n94yjkiOtoYMf6Y/Lm6
         MT9Se9FVY/LeQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 04/14] net/mlx5: DR, Remove unneeded argument from dr_icm_chunk_destroy
Date:   Mon, 24 Oct 2022 14:57:24 +0100
Message-Id: <20221024135734.69673-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove an argument that can be extracted in the function.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c         | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 4ca67fa24cc6..4cdc9e9a54e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -203,12 +203,11 @@ get_chunk_icm_type(struct mlx5dr_icm_chunk *chunk)
 	return chunk->buddy_mem->pool->icm_type;
 }
 
-static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk,
-				 struct mlx5dr_icm_buddy_mem *buddy)
+static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
 {
 	enum mlx5dr_icm_type icm_type = get_chunk_icm_type(chunk);
 
-	buddy->used_memory -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
+	chunk->buddy_mem->used_memory -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 	list_del(&chunk->chunk_list);
 
 	if (icm_type == DR_ICM_TYPE_STE)
@@ -299,10 +298,10 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 	struct mlx5dr_icm_chunk *chunk, *next;
 
 	list_for_each_entry_safe(chunk, next, &buddy->hot_list, chunk_list)
-		dr_icm_chunk_destroy(chunk, buddy);
+		dr_icm_chunk_destroy(chunk);
 
 	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
-		dr_icm_chunk_destroy(chunk, buddy);
+		dr_icm_chunk_destroy(chunk);
 
 	dr_icm_pool_mr_destroy(buddy->icm_mr);
 
@@ -376,7 +375,7 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 			num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
 			mlx5dr_buddy_free_mem(buddy, chunk->seg, ilog2(num_entries));
 			pool->hot_memory_size -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
-			dr_icm_chunk_destroy(chunk, buddy);
+			dr_icm_chunk_destroy(chunk);
 		}
 
 		if (!buddy->used_memory && pool->icm_type == DR_ICM_TYPE_STE)
-- 
2.37.3

