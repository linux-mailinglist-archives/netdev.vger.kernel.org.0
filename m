Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404BE466EE1
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbhLCA75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56280 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245176AbhLCA7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A52E9B8259E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1774DC53FD1;
        Fri,  3 Dec 2021 00:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492988;
        bh=ueQ2txrGel7nnIZk5q8VoJxBtWzDn7FWbQ7IcbGvLjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIf12hWApuVBOZRTqcZzJtluZv+QwLNlysYvevxVHhEqakxGFQwUxGL9SjTxci6aJ
         puxFd9EujGS2CyRowoxYy3iFroZQmBshh3jtddbUMOkJiVtZXO00RhxxyHHR8WrVqf
         PhAzFlSsXuhEetENT4uHLaRZQyWEStnvyoUXfsEN2QROEZA4f1KpdhZCeKWy7GRt+d
         fGc1FrjyH2SbbySKBSUTMz8s9LEiKrMV5mwhAwMR471YptT6kahnFsmmFW+nzagXzp
         3uKmOHvqCusnqdgPsznY5jo43+mzcyXMn09gS3js2ettzDsi1alD8i6CuG0HMKYjNu
         E6n1Uug/Mxfrg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ben Ben-Ishay <benishay@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 07/14] net/mlx5e: SHAMPO, clean MLX5E_MAX_KLM_PER_WQE macro
Date:   Thu,  2 Dec 2021 16:56:15 -0800
Message-Id: <20211203005622.183325-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This commit reduces unused variable from MLX5E_MAX_KLM_PER_WQE macro that
introduced by commit d7b896acbdcb ("net/mlx5e: Add support to klm_umr_wqe").

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 48b12ee44b8d..1834efa64c1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -173,7 +173,7 @@ struct page_pool;
 #define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
 	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
 
-#define MLX5E_MAX_KLM_PER_WQE(mdev) \
+#define MLX5E_MAX_KLM_PER_WQE \
 	MLX5E_KLM_ENTRIES_PER_WQE(MLX5E_TX_MPW_MAX_NUM_DS << MLX5_MKEY_BSF_OCTO_SIZE)
 
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index f8c29022dbb2..66180ffb4606 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -717,7 +717,7 @@ static u32 mlx5e_shampo_icosq_sz(struct mlx5_core_dev *mdev,
 	int wq_size = BIT(MLX5_GET(wq, wqc, log_wq_sz));
 	u32 wqebbs;
 
-	max_klm_per_umr = MLX5E_MAX_KLM_PER_WQE(mdev);
+	max_klm_per_umr = MLX5E_MAX_KLM_PER_WQE;
 	max_hd_per_wqe = mlx5e_shampo_hd_per_wqe(mdev, params, rq_param);
 	max_num_of_umr_per_wqe = max_hd_per_wqe / max_klm_per_umr;
 	rest = max_hd_per_wqe % max_klm_per_umr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b84ed9a7855c..7e05d7592bce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -619,7 +619,7 @@ static int mlx5e_alloc_rx_hd_mpwqe(struct mlx5e_rq *rq)
 	struct mlx5e_icosq *sq = rq->icosq;
 	int i, err, max_klm_entries, len;
 
-	max_klm_entries = MLX5E_MAX_KLM_PER_WQE(rq->mdev);
+	max_klm_entries = MLX5E_MAX_KLM_PER_WQE;
 	klm_entries = bitmap_find_window(shampo->bitmap,
 					 shampo->hd_per_wqe,
 					 shampo->hd_per_wq, shampo->pi);
-- 
2.31.1

