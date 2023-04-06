Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5EE6D8D34
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbjDFCD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbjDFCDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D403786BD
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CA262D0A
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165D5C433D2;
        Thu,  6 Apr 2023 02:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746575;
        bh=tiqQz0ldwqpyO86Nh/ljYioAvVPRGYJ2jenDCJXHmXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWNA8KaLafCy1hYZ4b30LGC0Eco6JwCHI0il/HZT5fc8/b2W7ig4eOcVfKQTIW5mL
         mlevyYYQGpJgNmFVnDn3VB6f1X7cukxBMUFMKUheW1/0VHQoDodikkBRJ/diaexFod
         klmO/lJGEnjnqLLPMRuIRtvvwBEGbyB6z1zGfemZByu7IVT0nRviOiyODw2akpR0HN
         8HR40PdPwukD1tw47eIqTKBTANI+BMRMwv+1Ar4qAeNigV6jEjNmS4pJR4SOdJXZaI
         dsov9me+XWCaO282C1CacAZPZ6HnC83I09kh3x11C2kmI4Oruyqw3hfS+hNFHfskk2
         aQ8Hygax6g7cg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: Rename misleading skb_pc/cc references in ptp code
Date:   Wed,  5 Apr 2023 19:02:30 -0700
Message-Id: <20230406020232.83844-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

The 'skb_pc/cc' naming is misleading as the values hold the
producer/consumer indices (masked values), not the counters. Rename to
'skb_pi/ci'.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Adham Faris <afaris@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index eb5aeba3addf..eb5abd0e55d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -81,23 +81,23 @@ void mlx5e_skb_cb_hwtstamp_handler(struct sk_buff *skb, int hwtstamp_type,
 
 #define PTP_WQE_CTR2IDX(val) ((val) & ptpsq->ts_cqe_ctr_mask)
 
-static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_ci, u16 skb_id)
 {
-	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
+	return (ptpsq->ts_cqe_ctr_mask && (skb_ci != skb_id));
 }
 
 static bool mlx5e_ptp_ts_cqe_ooo(struct mlx5e_ptpsq *ptpsq, u16 skb_id)
 {
-	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
-	u16 skb_pc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc);
+	u16 skb_ci = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	u16 skb_pi = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc);
 
-	if (PTP_WQE_CTR2IDX(skb_id - skb_cc) >= PTP_WQE_CTR2IDX(skb_pc - skb_cc))
+	if (PTP_WQE_CTR2IDX(skb_id - skb_ci) >= PTP_WQE_CTR2IDX(skb_pi - skb_ci))
 		return true;
 
 	return false;
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
+static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_ci,
 					     u16 skb_id, int budget)
 {
 	struct skb_shared_hwtstamps hwts = {};
@@ -105,13 +105,13 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 
 	ptpsq->cq_stats->resync_event++;
 
-	while (skb_cc != skb_id) {
+	while (skb_ci != skb_id) {
 		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
 		napi_consume_skb(skb, budget);
-		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+		skb_ci = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 }
 
@@ -120,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 				    int budget)
 {
 	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
-	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	u16 skb_ci = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
 	struct sk_buff *skb;
 	ktime_t hwtstamp;
@@ -131,13 +131,13 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_ci, skb_id)) {
 		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
 			/* already handled by a previous resync */
 			ptpsq->cq_stats->ooo_cqe_drop++;
 			return;
 		}
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
+		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_ci, skb_id, budget);
 	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
-- 
2.39.2

