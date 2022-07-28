Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FE7584738
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiG1UrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiG1UrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:47:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4A46C108
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4061EB82595
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AC7C433C1;
        Thu, 28 Jul 2022 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041218;
        bh=znTB1eV0VDtHRxwEFMrsl4D/hg0PtiZi/lR7NGWIJXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTDJ2HVIYyenW8Ky5rhwCBncP2ndhE8ZGdoh4b+J4YP1dDW6EU4wyZMHsiDOT2QDf
         5uNHzuSVTn5ShYlXJR+S/b4OMjoK1htBxg4XyhE1n5c3zG1s4dMFUyyvBcejJ2Jw/V
         cXIm8sxOI4+JZN3wKju9fkom/b8Q7I7KAUNWvypmskPWeL8YSQUlyT3tKpNMd0tQ2e
         ZRHvmbzFIct0mw/DUy30GjQkPFGOlDyh+jX9QN00D7taYPiw8B+Pw5lXZ2uCrmiKV1
         5jQGoNa0okCWtuoqt8XFfZBryIkUYmwJddrCbNY0w7qkaMnS/dWDUcjK3HZH0gjwQM
         8pP6CQO/2dYjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [net 7/9] net/mlx5: Adjust log_max_qp to be 18 at most
Date:   Thu, 28 Jul 2022 13:46:38 -0700
Message-Id: <20220728204640.139990-8-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

The cited commit limited log_max_qp to be 17 due to FW capabilities.
Recently, it turned out that there are old FW versions that supported
more than 17, so the cited commit caused a degradation.

Thus, set the maximum log_max_qp back to 18 as it was before the
cited commit.

Fixes: 7f839965b2d7 ("net/mlx5: Update log_max_qp value to be 17 at most")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c9b4e50a593e..95f26624b57c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -524,7 +524,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	/* Check log_max_qp from HCA caps to set in current profile */
 	if (prof->log_max_qp == LOG_MAX_SUPPORTED_QPS) {
-		prof->log_max_qp = min_t(u8, 17, MLX5_CAP_GEN_MAX(dev, log_max_qp));
+		prof->log_max_qp = min_t(u8, 18, MLX5_CAP_GEN_MAX(dev, log_max_qp));
 	} else if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
 			       prof->log_max_qp,
-- 
2.37.1

