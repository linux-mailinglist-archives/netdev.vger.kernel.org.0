Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB954DE2E7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbiCRUyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240875AbiCRUyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DF5DF64
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61A6060DC0
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B746C340F5;
        Fri, 18 Mar 2022 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636796;
        bh=/kqVeaCMXgUWOgGPLz2ewrVQVCF5fxnk2BgIQaV+5Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udWo6sHvrzhyJoQzCJWlkBbcprrYoHrdv+n+k1dCxsISKFCXYGbOCFwQoyHblqthX
         Z+mWjPG6+IsDSeYmQLv3vFddLBNrvYhgseCnVckYcy/v/YlBNHEG1c/b8zTsDX61jm
         7N3UdpwvmAZ9pAn/ekgnrFVMzNv1s2rg8GcZrPnsjusjtLtk7xXTGNbt1uNRox8uCp
         9rIhelT2Yr0snxv9/mvrLYEO0Fe1OmbvreMA8iNCWxdw3zVDXnCS6d3BOLM2ItAELw
         6mp3LrBj1TokX2bLC8odPT8TyAfC/8pzfb9WfBVZxRqiUSFvl7wLUp1pA2s1zCu9uk
         JtnLkbhtpCFsQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Statify function mlx5_cmd_trigger_completions
Date:   Fri, 18 Mar 2022 13:52:47 -0700
Message-Id: <20220318205248.33367-15-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Starting from commit
4cab346bcf74 ("net/mlx5: No command allowed when command interface is not ready"),
no calls to mlx5_cmd_trigger_completions() are external to cmd.c anymore.
Make it a static function.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index c2462d37f1b3..f1329f83f988 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1720,7 +1720,7 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 	}
 }
 
-void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev)
+static void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	unsigned long bitmask;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..3b231e90111d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -176,7 +176,6 @@ int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 					u32 element_id);
 int mlx5_wait_for_pages(struct mlx5_core_dev *dev, int *pages);
 
-void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev);
 void mlx5_cmd_flush(struct mlx5_core_dev *dev);
 void mlx5_cq_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev);
-- 
2.35.1

