Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE2A66DE78
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbjAQNPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbjAQNPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:15:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86132241DE;
        Tue, 17 Jan 2023 05:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45039B81600;
        Tue, 17 Jan 2023 13:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5534CC433EF;
        Tue, 17 Jan 2023 13:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673961301;
        bh=0CzU6WYZ9ucWGSDGNCHrQ0DjFlwKvKADXN9/JciMsho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+U1YR6oqBcuha4XYi/gEK9zLWK2Z4l9dq6rNoInq7phRt1qy4pkcR1/qLmFZ0inf
         HrvIXPG1bLPZY4jQ+35nDcrrFUbf5eCBuNQ52YIgJDS3jLzVfUTacq42+VqfQ/MH6K
         dcKXnUfGzpf4U//P3hnA3k0P4d/eiXUwZeuumYs3kiO2zhuL/cMa61l15n1cjbBs0H
         89QZ4ZlH0dAVMyCJIGG2EOJMkhQEHcmHdHTorm5lWBxizs9kkhhunSqYuWPISG7rNB
         Rk68DQTzXkVWWJRFtuOOhVEewKPbCsu9F30NblFP/ECJIuxTruvkmqxFugJ2iBtxvF
         9gNbBDtFN2t7w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v2 2/4] net/mlx5: Change define name for 0x100 lkey value
Date:   Tue, 17 Jan 2023 15:14:50 +0200
Message-Id: <3a116dc3fbae4cb6b76a63d27d418830b06ade0c.1673960981.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673960981.git.leon@kernel.org>
References: <cover.1673960981.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Har-Toov <ohartoov@nvidia.com>

Change define of 0x100 lkey value from MLX5_INVALID_LKEY to be
MLX5_TERMINATE_SCATTER_LIST_LKEY as 0x100 is the value of
terminate_scatter_list_mkey.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/odp.c                  | 10 +++++-----
 drivers/infiniband/hw/mlx5/srq.c                  |  2 +-
 drivers/infiniband/hw/mlx5/wr.c                   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 include/linux/mlx5/qp.h                           |  2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e6e021af6aa9..b4ebeadce67c 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -986,7 +986,7 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 {
 	int ret = 0, npages = 0;
 	u64 io_virt;
-	u32 key;
+	__be32 key;
 	u32 byte_count;
 	size_t bcnt;
 	int inline_segment;
@@ -1000,7 +1000,7 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 		struct mlx5_wqe_data_seg *dseg = wqe;
 
 		io_virt = be64_to_cpu(dseg->addr);
-		key = be32_to_cpu(dseg->lkey);
+		key = dseg->lkey;
 		byte_count = be32_to_cpu(dseg->byte_count);
 		inline_segment = !!(byte_count &  MLX5_INLINE_SEG);
 		bcnt	       = byte_count & ~MLX5_INLINE_SEG;
@@ -1014,8 +1014,8 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 		}
 
 		/* receive WQE end of sg list. */
-		if (receive_queue && bcnt == 0 && key == MLX5_INVALID_LKEY &&
-		    io_virt == 0)
+		if (receive_queue && bcnt == 0 &&
+		    key == MLX5_TERMINATE_SCATTER_LIST_LKEY && io_virt == 0)
 			break;
 
 		if (!inline_segment && total_wqe_bytes) {
@@ -1034,7 +1034,7 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 			continue;
 		}
 
-		ret = pagefault_single_data_segment(dev, NULL, key,
+		ret = pagefault_single_data_segment(dev, NULL, be32_to_cpu(key),
 						    io_virt, bcnt,
 						    &pfault->bytes_committed,
 						    bytes_mapped);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 757756c50cc6..bcceb14a07f9 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -447,7 +447,7 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 
 		if (i < srq->msrq.max_avail_gather) {
 			scat[i].byte_count = 0;
-			scat[i].lkey       = cpu_to_be32(MLX5_INVALID_LKEY);
+			scat[i].lkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
 			scat[i].addr       = 0;
 		}
 	}
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 855f3f4fefad..bc44551493e2 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -1252,7 +1252,7 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 
 		if (i < qp->rq.max_gs) {
 			scat[i].byte_count = 0;
-			scat[i].lkey       = cpu_to_be32(MLX5_INVALID_LKEY);
+			scat[i].lkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
 			scat[i].addr       = 0;
 		}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cff5f2e29e1e..db4e66c38395 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -825,7 +825,8 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			/* check if num_frags is not a pow of two */
 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
 				wqe->data[f].byte_count = 0;
-				wqe->data[f].lkey = cpu_to_be32(MLX5_INVALID_LKEY);
+				wqe->data[f].lkey =
+					MLX5_TERMINATE_SCATTER_LIST_LKEY;
 				wqe->data[f].addr = 0;
 			}
 		}
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 4657d5c54abe..df55fbb65717 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -36,7 +36,7 @@
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/driver.h>
 
-#define MLX5_INVALID_LKEY	0x100
+#define MLX5_TERMINATE_SCATTER_LIST_LKEY cpu_to_be32(0x100)
 /* UMR (3 WQE_BB's) + SIG (3 WQE_BB's) + PSV (mem) + PSV (wire) */
 #define MLX5_SIG_WQE_SIZE	(MLX5_SEND_WQE_BB * 8)
 #define MLX5_DIF_SIZE		8
-- 
2.39.0

