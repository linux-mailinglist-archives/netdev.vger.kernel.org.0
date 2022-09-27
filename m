Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396255ECEB3
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiI0UhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiI0Ugp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB8C6069F
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85D8EB81C19
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FBEC433C1;
        Tue, 27 Sep 2022 20:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311001;
        bh=hsQdeOCJ32gadO5QnYA++jRN+vAo3ebjt6Swvmvb4Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTLwbm5rV9oRFT/3QSh9EPhnSK7kI8HjF+ouqSWPzgfViCCNaVkZreRDnqUxuE0aN
         AZm35Jp8rBJOsB13eNm0FC/wAGHJRp4i4UZOv8bPMx0IF5lMD39lMOWK0iOM64PPo7
         Smoq34vXFuyhwmWAoxOcGbb7ngTb+dp3gipKth2jPiy2pWGDOAjd4vDHh9g3LVj+M8
         0Z/rMJzg8P99i/jFqFAectye018VNp+yaBVgsxHpjlG6CH+eHUVCRUJGM0vepv3Gmp
         cDhFhVnY121KiCssbD3IC7FZtfm0E10RtSc8qwFo7U+/4b48ngFmh5xGP/UVQssIFQ
         Dk5kqTuR7rqbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 03/16] net/mlx5e: Remove unused fields from datapath structs
Date:   Tue, 27 Sep 2022 13:35:58 -0700
Message-Id: <20220927203611.244301-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

No need to keep max_sq_wqebbs in mlx5e_txqsq and mlx5e_xdpsq, as it's
only used when allocating the queues. Removing an extra field reduces
the struct size.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 05126c6ae13d..881e406d8757 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -478,7 +478,6 @@ struct mlx5e_txqsq {
 	struct work_struct         recover_work;
 	struct mlx5e_ptpsq        *ptpsq;
 	cqe_ts_to_ns               ptp_cyc2time;
-	u16                        max_sq_wqebbs;
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_dma_info {
@@ -582,7 +581,6 @@ struct mlx5e_xdpsq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
-	u16                        max_sq_wqebbs;
 } ____cacheline_aligned_in_smp;
 
 struct mlx5e_ktls_resync_resp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4503de92ac80..47d0bd6ab98e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1155,9 +1155,9 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 		is_redirect ?
 			&c->priv->channel_stats[c->ix]->xdpsq :
 			&c->priv->channel_stats[c->ix]->rq_xdpsq;
-	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
-	sq->stop_room = MLX5E_STOP_ROOM(sq->max_sq_wqebbs);
-	sq->max_sq_mpw_wqebbs = mlx5e_get_sw_max_sq_mpw_wqebbs(sq->max_sq_wqebbs);
+	sq->stop_room = MLX5E_STOP_ROOM(mlx5e_get_max_sq_wqebbs(mdev));
+	sq->max_sq_mpw_wqebbs =
+		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev));
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -1318,8 +1318,8 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->max_sq_wqebbs = mlx5e_get_max_sq_wqebbs(mdev);
-	sq->max_sq_mpw_wqebbs = mlx5e_get_sw_max_sq_mpw_wqebbs(sq->max_sq_wqebbs);
+	sq->max_sq_mpw_wqebbs =
+		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev));
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (!MLX5_CAP_ETH(mdev, wqe_vlan_insert))
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
-- 
2.37.3

