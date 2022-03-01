Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1442C4C984A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbiCAWWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbiCAWWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:22:03 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF3F7087E
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 14:21:21 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 195so15441795pgc.6
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 14:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s5EgSNkmoey6N3OT8MtJnSX6E5RLkxtw8gTi4t6ay9Y=;
        b=K/nPp7S1Ed9m9r+Ie6mYaDTd/AWig+HIlFKmdumLZWqHhpiXFRVWHOoYq2hrCiqDKR
         KxQOh8WwAAmFgkHpjdU8mSUDldT2UABJnZVszygE/SF1e8tEiPcUgk981Pq+1CaKfyOF
         2TYNAoNISAOmTjbHrO2sFx30usRaKTgd/cPVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s5EgSNkmoey6N3OT8MtJnSX6E5RLkxtw8gTi4t6ay9Y=;
        b=wcb9+GHbxq9ELP90Py6CUTAf1zC48Vy7nFqImL4S1b4OxGtMWRptaX/GihOXorw4XJ
         l8YheQXYshpiteec2OFTpKy+xkbMwjLC6TUWQQv7ZzY4MHeAjgV1F6V0VvKrj0zgHqwY
         DKErIzcyadmaTh5TLMzw/jc7uVCypcj9VB6yM3JrzDetbnTgwSWEob2WQr4i+E4zzw7k
         5AgWQF6Yhv3amrH7xtqPNergZM/iBlh7fasHbnAzJ/j7XbxnHkd7xNwLzbHwhr3of9vM
         6QwEc46zcJ/wX1RHkxutXKe6rxa5RD6JqaVVMeUnAHk+/ogRFCk6jAre9yWxBWkkcjBm
         NPpA==
X-Gm-Message-State: AOAM533ptEuc7/YSTpZy1DXLBzw9rGqhmPs12joW5HbCzkkLe0+7s3Gs
        /hZhRSeb1A6cqwZGekcxZcWM5264TkWs6Wgm1AQuEsdVO7VszHLyAqDJZgavR/eM8AsRmiQA0Qb
        DCWNfZv3ppMS5rRWclJ24z7XZ3td4gn462ldgRVIPv6QZbJqHYoD70+ONoF0SRmW5fh7z
X-Google-Smtp-Source: ABdhPJzDF48I3vmmSkTFqsKRAXGBs4H3fGw1NY8NU9Ye1smCTXSm4Prv3DtMhHjjQ7wRpEQy3S3cHw==
X-Received: by 2002:a63:1245:0:b0:375:57f0:8798 with SMTP id 5-20020a631245000000b0037557f08798mr23972040pgs.490.1646173280694;
        Tue, 01 Mar 2022 14:21:20 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h22-20020a056a00231600b004e1784925e5sm18819108pfh.97.2022.03.01.14.21.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Mar 2022 14:21:20 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com,
        leon@kernel.org, linux-rdma@vger.kernel.org, saeedm@nvidia.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v8 4/4] mlx5: add support for page_pool_get_stats
Date:   Tue,  1 Mar 2022 14:10:10 -0800
Message-Id: <1646172610-129397-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for the page_pool_get_stats API to mlx5. If the
user has enabled CONFIG_PAGE_POOL_STATS in their kernel, ethtool will
output page pool stats.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 75 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 27 +++++++-
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 3e5d8c7..eb518ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -37,6 +37,10 @@
 #include "en/ptp.h"
 #include "en/port.h"
 
+#ifdef CONFIG_PAGE_POOL_STATS
+#include <net/page_pool.h>
+#endif
+
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
 	return !priv->profile->stats_grps_num ? 0 :
@@ -183,6 +187,19 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
+#ifdef CONFIG_PAGE_POOL_STATS
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_fast) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_slow) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_slow_high_order) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_empty) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_refill) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_waive) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_cached) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_cache_full) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_ring) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_ring_full) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_released_ref) },
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
@@ -349,6 +366,19 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_congst_umr              += rq_stats->congst_umr;
 	s->rx_arfs_err                += rq_stats->arfs_err;
 	s->rx_recover                 += rq_stats->recover;
+#ifdef CONFIG_PAGE_POOL_STATS
+	s->rx_pp_alloc_fast          += rq_stats->pp_alloc_fast;
+	s->rx_pp_alloc_slow          += rq_stats->pp_alloc_slow;
+	s->rx_pp_alloc_empty         += rq_stats->pp_alloc_empty;
+	s->rx_pp_alloc_refill        += rq_stats->pp_alloc_refill;
+	s->rx_pp_alloc_waive         += rq_stats->pp_alloc_waive;
+	s->rx_pp_alloc_slow_high_order		+= rq_stats->pp_alloc_slow_high_order;
+	s->rx_pp_recycle_cached			+= rq_stats->pp_recycle_cached;
+	s->rx_pp_recycle_cache_full		+= rq_stats->pp_recycle_cache_full;
+	s->rx_pp_recycle_ring			+= rq_stats->pp_recycle_ring;
+	s->rx_pp_recycle_ring_full		+= rq_stats->pp_recycle_ring_full;
+	s->rx_pp_recycle_released_ref		+= rq_stats->pp_recycle_released_ref;
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	s->rx_tls_decrypted_packets   += rq_stats->tls_decrypted_packets;
 	s->rx_tls_decrypted_bytes     += rq_stats->tls_decrypted_bytes;
@@ -455,6 +485,35 @@ static void mlx5e_stats_grp_sw_update_stats_qos(struct mlx5e_priv *priv,
 	}
 }
 
+#ifdef CONFIG_PAGE_POOL_STATS
+static void mlx5e_stats_update_stats_rq_page_pool(struct mlx5e_channel *c)
+{
+	struct mlx5e_rq_stats *rq_stats = c->rq.stats;
+	struct page_pool *pool = c->rq.page_pool;
+	struct page_pool_stats stats = { 0 };
+
+	if (!page_pool_get_stats(pool, &stats))
+		return;
+
+	rq_stats->pp_alloc_fast = stats.alloc_stats.fast;
+	rq_stats->pp_alloc_slow = stats.alloc_stats.slow;
+	rq_stats->pp_alloc_slow_high_order = stats.alloc_stats.slow_high_order;
+	rq_stats->pp_alloc_empty = stats.alloc_stats.empty;
+	rq_stats->pp_alloc_waive = stats.alloc_stats.waive;
+	rq_stats->pp_alloc_refill = stats.alloc_stats.refill;
+
+	rq_stats->pp_recycle_cached = stats.recycle_stats.cached;
+	rq_stats->pp_recycle_cache_full = stats.recycle_stats.cache_full;
+	rq_stats->pp_recycle_ring = stats.recycle_stats.ring;
+	rq_stats->pp_recycle_ring_full = stats.recycle_stats.ring_full;
+	rq_stats->pp_recycle_released_ref = stats.recycle_stats.released_refcnt;
+}
+#else
+static void mlx5e_stats_update_stats_rq_page_pool(struct mlx5e_channel *c)
+{
+}
+#endif
+
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 {
 	struct mlx5e_sw_stats *s = &priv->stats.sw;
@@ -465,8 +524,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 	for (i = 0; i < priv->stats_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =
 			priv->channel_stats[i];
+
 		int j;
 
+		mlx5e_stats_update_stats_rq_page_pool(priv->channels.c[i]);
+
 		mlx5e_stats_grp_sw_update_stats_rq_stats(s, &channel_stats->rq);
 		mlx5e_stats_grp_sw_update_stats_xdpsq(s, &channel_stats->rq_xdpsq);
 		mlx5e_stats_grp_sw_update_stats_ch_stats(s, &channel_stats->ch);
@@ -1887,6 +1949,19 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
+#ifdef CONFIG_PAGE_POOL_STATS
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_alloc_fast) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_alloc_slow) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_alloc_slow_high_order) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_alloc_empty) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_alloc_refill) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_alloc_waive) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_recycle_cached) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_recycle_cache_full) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_recycle_ring) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_recycle_ring_full) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, pp_recycle_released_ref) },
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_bytes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 14eaf92..a7a025d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -205,7 +205,19 @@ struct mlx5e_sw_stats {
 	u64 ch_aff_change;
 	u64 ch_force_irq;
 	u64 ch_eq_rearm;
-
+#ifdef CONFIG_PAGE_POOL_STATS
+	u64 rx_pp_alloc_fast;
+	u64 rx_pp_alloc_slow;
+	u64 rx_pp_alloc_slow_high_order;
+	u64 rx_pp_alloc_empty;
+	u64 rx_pp_alloc_refill;
+	u64 rx_pp_alloc_waive;
+	u64 rx_pp_recycle_cached;
+	u64 rx_pp_recycle_cache_full;
+	u64 rx_pp_recycle_ring;
+	u64 rx_pp_recycle_ring_full;
+	u64 rx_pp_recycle_released_ref;
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tx_tls_encrypted_packets;
 	u64 tx_tls_encrypted_bytes;
@@ -352,6 +364,19 @@ struct mlx5e_rq_stats {
 	u64 congst_umr;
 	u64 arfs_err;
 	u64 recover;
+#ifdef CONFIG_PAGE_POOL_STATS
+	u64 pp_alloc_fast;
+	u64 pp_alloc_slow;
+	u64 pp_alloc_slow_high_order;
+	u64 pp_alloc_empty;
+	u64 pp_alloc_refill;
+	u64 pp_alloc_waive;
+	u64 pp_recycle_cached;
+	u64 pp_recycle_cache_full;
+	u64 pp_recycle_ring;
+	u64 pp_recycle_ring_full;
+	u64 pp_recycle_released_ref;
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_decrypted_packets;
 	u64 tls_decrypted_bytes;
-- 
2.7.4

