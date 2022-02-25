Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6C4C4CC7
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbiBYRni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243973AbiBYRnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:43:35 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19C5888F8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:43:02 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so5492653pjb.0
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B9rx5xp18pDRfJ+m+9jsqxPiJs7lmmKiX4Q7XUwW1Bk=;
        b=hFfKZCtR7BOF40yS8yrpu6rln0Mw4JOUWTXMJN4J/k5RC4/rA6DDK4fatywc8Ri5pt
         dG5IyRSV3bOrAqzVULEPE6aL4XYBCSAKu/C/JH0SR2voLOrGSzP9WrgooeBt6JFHNneR
         sROFHbzXsIqNegn0a8ROhO3tGAvbuOh6ErE0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B9rx5xp18pDRfJ+m+9jsqxPiJs7lmmKiX4Q7XUwW1Bk=;
        b=6KYzrX4zqQ66aWSE/LB3jU7vLjfs4wM4GnsIrTdpHMYDAuknfENgUQUC5Dv6kNd0RR
         4ll0ZW2fKOE7Zyb27IKXfhlkTBFEs3tVKrJTukX1uJhmL23qXf13zz68Bbu/On5oOI/e
         6c4ADbE1cL7ksAAvyHfsIBvr6hkVVAXALFior2lnb44oEn4K0N5CC4x0m9veCOT1cDbB
         NALN3r1g/ZKrpwaFQG1nF8r8WhI0vXha/LrmY5gQtLAWRe5v9Lst+dprynuXwMkptiQJ
         0DyGRn4mJ2rkrIFFUgx39wO5aId4osSNbUpsx8A6ra+c0qn8RFWyD8KZQOnUd60Blniw
         o6BQ==
X-Gm-Message-State: AOAM533VpBxroO51DCFTstEUv21vKVNkKHBo55mGRKY04cxoXzjWm5lG
        n7ZEbsAFu5eL51x5+cntOffe7kXuN0pjZjFxuho0+anPdTz1lWLQf+zRlVF8liCf9QlncyqfI8e
        DySr/Yzwc0G2fHLBH7Yn2syJEO0gzEpVYN8r3UVfBRHL+6I+lYpNFW3geuXh3A0Yj06Vo
X-Google-Smtp-Source: ABdhPJz5rstHCDvczZaiMF3lpEweoFRe2Eqk12u3J0yHCuDASb2uIoMY3pP+62TF6uSLXCOnWwlPcg==
X-Received: by 2002:a17:90a:9f90:b0:1bc:7e7c:2ea7 with SMTP id o16-20020a17090a9f9000b001bc7e7c2ea7mr4165873pjp.64.1645810981036;
        Fri, 25 Feb 2022 09:43:01 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id h2-20020a656382000000b00370648d902csm3203805pgv.4.2022.02.25.09.42.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 09:43:00 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v7 4/4] mlx5: add support for page_pool_get_stats
Date:   Fri, 25 Feb 2022 09:41:54 -0800
Message-Id: <1645810914-35485-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 76 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 27 +++++++-
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 3e5d8c7..56eedf5 100644
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
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_fast) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_slow) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_slow_high_order) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_empty) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_refill) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_waive) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_rec_cached) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_rec_cache_full) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_rec_ring) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_rec_ring_full) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_page_pool_rec_released_ref) },
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
@@ -349,6 +366,20 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_congst_umr              += rq_stats->congst_umr;
 	s->rx_arfs_err                += rq_stats->arfs_err;
 	s->rx_recover                 += rq_stats->recover;
+#ifdef CONFIG_PAGE_POOL_STATS
+	s->rx_page_pool_fast          += rq_stats->page_pool_fast;
+	s->rx_page_pool_slow          += rq_stats->page_pool_slow;
+	s->rx_page_pool_empty         += rq_stats->page_pool_empty;
+	s->rx_page_pool_refill        += rq_stats->page_pool_refill;
+	s->rx_page_pool_waive         += rq_stats->page_pool_waive;
+
+	s->rx_page_pool_slow_high_order		+= rq_stats->page_pool_slow_high_order;
+	s->rx_page_pool_rec_cached		+= rq_stats->page_pool_rec_cached;
+	s->rx_page_pool_rec_cache_full		+= rq_stats->page_pool_rec_cache_full;
+	s->rx_page_pool_rec_ring		+= rq_stats->page_pool_rec_ring;
+	s->rx_page_pool_rec_ring_full		+= rq_stats->page_pool_rec_ring_full;
+	s->rx_page_pool_rec_released_ref	+= rq_stats->page_pool_rec_released_ref;
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	s->rx_tls_decrypted_packets   += rq_stats->tls_decrypted_packets;
 	s->rx_tls_decrypted_bytes     += rq_stats->tls_decrypted_bytes;
@@ -455,6 +486,35 @@ static void mlx5e_stats_grp_sw_update_stats_qos(struct mlx5e_priv *priv,
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
+	rq_stats->page_pool_fast = stats.alloc_stats.fast;
+	rq_stats->page_pool_slow = stats.alloc_stats.slow;
+	rq_stats->page_pool_slow_high_order = stats.alloc_stats.slow_high_order;
+	rq_stats->page_pool_empty = stats.alloc_stats.empty;
+	rq_stats->page_pool_waive = stats.alloc_stats.waive;
+	rq_stats->page_pool_refill = stats.alloc_stats.refill;
+
+	rq_stats->page_pool_rec_cached = stats.recycle_stats.cached;
+	rq_stats->page_pool_rec_cache_full = stats.recycle_stats.cache_full;
+	rq_stats->page_pool_rec_ring = stats.recycle_stats.ring;
+	rq_stats->page_pool_rec_ring_full = stats.recycle_stats.ring_full;
+	rq_stats->page_pool_rec_released_ref = stats.recycle_stats.released_refcnt;
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
@@ -465,8 +525,11 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
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
@@ -1887,6 +1950,19 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
+#ifdef CONFIG_PAGE_POOL_STATS
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fast) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow_high_order) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_empty) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_refill) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_waive) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cached) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cache_full) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring_full) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_released_ref) },
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_decrypted_bytes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 14eaf92..9f66425 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -205,7 +205,19 @@ struct mlx5e_sw_stats {
 	u64 ch_aff_change;
 	u64 ch_force_irq;
 	u64 ch_eq_rearm;
-
+#ifdef CONFIG_PAGE_POOL_STATS
+	u64 rx_page_pool_fast;
+	u64 rx_page_pool_slow;
+	u64 rx_page_pool_slow_high_order;
+	u64 rx_page_pool_empty;
+	u64 rx_page_pool_refill;
+	u64 rx_page_pool_waive;
+	u64 rx_page_pool_rec_cached;
+	u64 rx_page_pool_rec_cache_full;
+	u64 rx_page_pool_rec_ring;
+	u64 rx_page_pool_rec_ring_full;
+	u64 rx_page_pool_rec_released_ref;
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tx_tls_encrypted_packets;
 	u64 tx_tls_encrypted_bytes;
@@ -352,6 +364,19 @@ struct mlx5e_rq_stats {
 	u64 congst_umr;
 	u64 arfs_err;
 	u64 recover;
+#ifdef CONFIG_PAGE_POOL_STATS
+	u64 page_pool_fast;
+	u64 page_pool_slow;
+	u64 page_pool_slow_high_order;
+	u64 page_pool_empty;
+	u64 page_pool_refill;
+	u64 page_pool_waive;
+	u64 page_pool_rec_cached;
+	u64 page_pool_rec_cache_full;
+	u64 page_pool_rec_ring;
+	u64 page_pool_rec_ring_full;
+	u64 page_pool_rec_released_ref;
+#endif
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_decrypted_packets;
 	u64 tls_decrypted_bytes;
-- 
2.7.4

