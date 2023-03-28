Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6A6CCBAE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjC1U5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjC1U5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C126D1FFF
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A0BCB81E74
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C8AC433A4;
        Tue, 28 Mar 2023 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037013;
        bh=p0nloBRhd52+nkQZ5nSC5GWKFJqQTgnxEz7sgBqN5Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFX7XE59zPTDX6Aa4y6PDdsvaol1+aqHsGKO8O0DXewEcqSpizk/csyebRlSEUczE
         BWk5rvOuRzqDOtOKXwWbfXZBnWWP+rKKu/0AQ6bHrqhVevRdBgR7BTTUlUDtzk2Ykc
         qigJkkGpq89RPANKUHbeIiiRZQUQhp69UqHZOJmI+D7fSIrAT010LGZWzuSpISW0Mu
         m1K7uZY5atLQtM03FqUxdwsHL8wKJj091ioicKQWKrLLnao6Ny7Zmz2EenLsEkhown
         vKhwl8G5Qeb4iWMqoWKR2zH6p3dcCfsp2FKGg3oqfIjzokXJFmeszZO1pGzI36hcS8
         oEDEsKsP+FImQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: RX, Rename xdp_xmit_bitmap to a more generic name
Date:   Tue, 28 Mar 2023 13:56:16 -0700
Message-Id: <20230328205623.142075-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dragos Tatulea <dtatulea@nvidia.com>

The xdp_xmit_bitmap currently serves only one purpose: to avoid
releasing pages that are still in use due to XDP TX.

A following patch will use this bitmap in a slightly different context
but for the same purpose. So rename the bitmap to a more generic name
that reflects the purpose not the context.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0862556105d5..566ddf7a7aa9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -622,7 +622,7 @@ union mlx5e_alloc_units {
 
 struct mlx5e_mpw_info {
 	u16 consumed_strides;
-	DECLARE_BITMAP(xdp_xmit_bitmap, MLX5_MPWRQ_MAX_PAGES_PER_WQE);
+	DECLARE_BITMAP(skip_release_bitmap, MLX5_MPWRQ_MAX_PAGES_PER_WQE);
 	union mlx5e_alloc_units alloc_units;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index b2c1af07c317..3cde264cbe4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -120,7 +120,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		}
 	}
 
-	bitmap_zero(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
+	bitmap_zero(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 	wi->consumed_strides = 0;
 
 	umr_wqe->ctrl.opmod_idx_opcode =
@@ -289,7 +289,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	prog = rcu_dereference(rq->xdp_prog);
 	if (likely(prog && mlx5e_xdp_handle(rq, prog, mxbuf))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
-			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
+			__set_bit(page_idx, wi->skip_release_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 7724e30ec133..eab8cba33ce4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -439,10 +439,10 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 	int i;
 
 	/* A common case for AF_XDP. */
-	if (bitmap_full(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe))
+	if (bitmap_full(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe))
 		return;
 
-	no_xdp_xmit = bitmap_empty(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
+	no_xdp_xmit = bitmap_empty(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 
 	if (rq->xsk_pool) {
 		struct xdp_buff **xsk_buffs = wi->alloc_units.xsk_buffs;
@@ -452,11 +452,11 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
 		 * the page to the userspace when the interface goes down.
 		 */
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
-			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
+			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap))
 				xsk_buff_free(xsk_buffs[i]);
 	} else {
 		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++) {
-			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap)) {
+			if (no_xdp_xmit || !test_bit(i, wi->skip_release_bitmap)) {
 				struct mlx5e_frag_page *frag_page;
 
 				frag_page = &wi->alloc_units.frag_pages[i];
@@ -687,7 +687,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		       sizeof(*umr_wqe->inline_mtts) * pad);
 	}
 
-	bitmap_zero(wi->xdp_xmit_bitmap, rq->mpwqe.pages_per_wqe);
+	bitmap_zero(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 	wi->consumed_strides = 0;
 
 	umr_wqe->ctrl.opmod_idx_opcode =
@@ -1970,7 +1970,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
-				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
+				__set_bit(page_idx, wi->skip_release_bitmap); /* non-atomic */
 			return NULL; /* page/packet was consumed by XDP */
 		}
 
-- 
2.39.2

