Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F861543D48
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiFHUFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiFHUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76111374EEB;
        Wed,  8 Jun 2022 13:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1266661C5E;
        Wed,  8 Jun 2022 20:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D3DC34116;
        Wed,  8 Jun 2022 20:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718729;
        bh=pdxv8fPnJR9QcNRfmvbcq1nieY8myrWQmFjIeQniGjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUoKwSqVZjUW6Rs2/GAsUgOfrdcAMHShcQ+wdKrsP6CP+rvu+YEBYqR0dRqcAv2yx
         O4+298seRdH4q56YYZAPS5akaDV+6lIWxhc1czMgK8TS9nyoIExtM4igFJRz/zq/nS
         7uUCFDqzM+6pSPio0b7O4k/v7rvsBGa6mEWOctzXZ6fORKquKFq42eMw4aXBAU2HtW
         pAzP/07zS0MKnmE1KK7n4le9RyjuD40jMnqf3T3FuTK5tDJsbk/3KH57ouP8SRnFej
         Ry3h4fzOrfnUfL4P2RBsKXqLKS+F+/g1t93B/wEPoOSV7g6XyaDWL1Be1pQpeO5RUr
         V3cGU/v7OBBIw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 5/6] net/mlx5: Remove not used MLX5_CAP_BITS_RW_MASK
Date:   Wed,  8 Jun 2022 13:04:51 -0700
Message-Id: <20220608200452.43880-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
References: <20220608200452.43880-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Remove not used MLX5_CAP_BITS_RW_MASK.
While at it, remove CAP_MASK, MLX5_CAP_OFF_CMDIF_CSUM
and MLX5_DEV_CAP_FLAG_*, since MLX5_CAP_BITS_RW_MASK
was their only user.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  7 -------
 include/linux/mlx5/device.h                   | 19 -------------------
 2 files changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c9b4e50a593e..2078d9f03a5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -314,13 +314,6 @@ struct mlx5_reg_host_endianness {
 	u8      rsvd[15];
 };
 
-#define CAP_MASK(pos, size) ((u64)((1 << (size)) - 1) << (pos))
-
-enum {
-	MLX5_CAP_BITS_RW_MASK = CAP_MASK(MLX5_CAP_OFF_CMDIF_CSUM, 2) |
-				MLX5_DEV_CAP_FLAG_DCT,
-};
-
 static u16 to_fw_pkey_sz(struct mlx5_core_dev *dev, u32 size)
 {
 	switch (size) {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 15ac02eeed4f..95a4fa0fd40a 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -386,21 +386,6 @@ enum {
 	MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG	= 9,
 };
 
-enum {
-	MLX5_DEV_CAP_FLAG_XRC		= 1LL <<  3,
-	MLX5_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1LL <<  8,
-	MLX5_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1LL <<  9,
-	MLX5_DEV_CAP_FLAG_APM		= 1LL << 17,
-	MLX5_DEV_CAP_FLAG_ATOMIC	= 1LL << 18,
-	MLX5_DEV_CAP_FLAG_BLOCK_MCAST	= 1LL << 23,
-	MLX5_DEV_CAP_FLAG_ON_DMND_PG	= 1LL << 24,
-	MLX5_DEV_CAP_FLAG_CQ_MODER	= 1LL << 29,
-	MLX5_DEV_CAP_FLAG_RESIZE_CQ	= 1LL << 30,
-	MLX5_DEV_CAP_FLAG_DCT		= 1LL << 37,
-	MLX5_DEV_CAP_FLAG_SIG_HAND_OVER	= 1LL << 40,
-	MLX5_DEV_CAP_FLAG_CMDIF_CSUM	= 3LL << 46,
-};
-
 enum {
 	MLX5_ROCE_VERSION_1		= 0,
 	MLX5_ROCE_VERSION_2		= 2,
@@ -496,10 +481,6 @@ enum {
 	MLX5_MAX_PAGE_SHIFT		= 31
 };
 
-enum {
-	MLX5_CAP_OFF_CMDIF_CSUM		= 46,
-};
-
 enum {
 	/*
 	 * Max wqe size for rdma read is 512 bytes, so this
-- 
2.36.1

