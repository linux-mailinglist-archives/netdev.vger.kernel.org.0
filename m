Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599276E2C46
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjDNWJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjDNWJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295D240F1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FC9064A8F
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9D2C433EF;
        Fri, 14 Apr 2023 22:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510183;
        bh=IKuy7ac5vFOHL9oYNz2A94jW6GKIvk7K9+y2yJdKGG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/rshF3sD+veKTXysgAWxUvM8MwfQNtKiWTd1rjY/w3gRmRuPjdAEquK82uycPPJZ
         gwQptVpSI6/ZgCIASVB0W+OR1MQb/zOs7GlD/R8rkHBmX6liBTbSkQmE0EQDlcdIJC
         6R12aX2MkzZqbyILtkjRa2nnSXE3GOw4w8o98yZ2ZfX8mdTgV8E19xg5TJM4LPZFST
         IdlXm42gtrWTzAUYrEvfKIXzYn5gBnjAJeqMeaX97bgiSuSnbaRWKpa8bxLQ3VBtlq
         SIqk+3Uc2BFUGG2UCXDs5PtTfnH9uhve2Zb8bZoVwDoGuZ3UQ+uOxYCKFlzK/UIHXO
         QYUeyV5ckl/lg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 01/15] net/mlx5: DR, Move ACTION_CACHE_LINE_SIZE macro to header
Date:   Fri, 14 Apr 2023 15:09:25 -0700
Message-Id: <20230414220939.136865-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Move ACTION_CACHE_LINE_SIZE macro to header to be used by
the pattern functions as well.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_action.c   | 10 ++++------
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h    |  1 +
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index ee104cf04392..724e4d9e70ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1365,8 +1365,6 @@ dr_action_verify_reformat_params(enum mlx5dr_action_type reformat_type,
 	return -EINVAL;
 }
 
-#define ACTION_CACHE_LINE_SIZE 64
-
 static int
 dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 				 u8 reformat_param_0, u8 reformat_param_1,
@@ -1403,13 +1401,13 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	}
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
 	{
-		u8 hw_actions[ACTION_CACHE_LINE_SIZE] = {};
+		u8 hw_actions[DR_ACTION_CACHE_LINE_SIZE] = {};
 		int ret;
 
 		ret = mlx5dr_ste_set_action_decap_l3_list(dmn->ste_ctx,
 							  data, data_sz,
 							  hw_actions,
-							  ACTION_CACHE_LINE_SIZE,
+							  DR_ACTION_CACHE_LINE_SIZE,
 							  &action->rewrite->num_of_actions);
 		if (ret) {
 			mlx5dr_dbg(dmn, "Failed creating decap l3 action list\n");
@@ -1427,7 +1425,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr
 					  (action->rewrite->chunk) -
 					 dmn->info.caps.hdr_modify_icm_addr) /
-					 ACTION_CACHE_LINE_SIZE;
+					 DR_ACTION_CACHE_LINE_SIZE;
 
 		ret = mlx5dr_send_postsend_action(dmn, action);
 		if (ret) {
@@ -2006,7 +2004,7 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 	action->rewrite->num_of_actions = num_hw_actions;
 	action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr(chunk) -
 				  dmn->info.caps.hdr_modify_icm_addr) /
-				  ACTION_CACHE_LINE_SIZE;
+				  DR_ACTION_CACHE_LINE_SIZE;
 
 	ret = mlx5dr_send_postsend_action(dmn, action);
 	if (ret)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 5b9faa714f42..7453fc6df494 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -21,6 +21,7 @@
 #define DR_NUM_OF_FLEX_PARSERS 8
 #define DR_STE_MAX_FLEX_0_ID 3
 #define DR_STE_MAX_FLEX_1_ID 7
+#define DR_ACTION_CACHE_LINE_SIZE 64
 
 #define mlx5dr_err(dmn, arg...) mlx5_core_err((dmn)->mdev, ##arg)
 #define mlx5dr_info(dmn, arg...) mlx5_core_info((dmn)->mdev, ##arg)
-- 
2.39.2

