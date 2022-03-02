Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC31D4C9AB5
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiCBBvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiCBBvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:51:03 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80302A2531
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 17:50:20 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id t13so247289lfd.9
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 17:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6CDgDe+fGoaVQpiu99+i6UmDH/5/8iEjkUhZabzSYWc=;
        b=YQAWqK8wpMQgPQ0Wxft7Fo8RokTuetmAdFRVK7XW5OkeUnMk6Zoi/yJMXWIedHm1ko
         n+9ep8eMqHCfvWDojwpuwbIxKgvEqPM+WSH3eF9U78MumqjpPVBpSf0LteQ8KMcmXbPs
         hYpFOJiUhxFMABGRNjWo9p5qD41TfFeg9BpAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6CDgDe+fGoaVQpiu99+i6UmDH/5/8iEjkUhZabzSYWc=;
        b=NjrqSCoh08XG2H3NHidLWz15J3mZNhvBOnrleOKeUFE2ChylaSLbS1aMHAlLRhH06K
         TcT9bSeM5D6g6ZIFNZfEE0mA/qtRjQLSDlm7xq6nqwAxce6iqAL3ZRBosRynKCfAxAGa
         mR/o8KMDMr7t8WvDiIMyCZFURQjKke7OVpXhur7hjws8YC9cyLiovAjUtaMoBjpuPFt9
         O2PU7ErEu8UvAdZra7SwWDOtS2vcCXEGMSF1m+ziKIt+M5erHM3Ei9s0KXt9771DgGPW
         9uxTcZwfJcz1WB4pUyNMi3/ujLOXXFEUBzyK3gjZx/c5RhptsdNL3Av0RRsQt9cfq8QD
         kLeQ==
X-Gm-Message-State: AOAM533v94s/iUUdlCtJlLzbr1ZVE+5c2cNsHLzw5rxEiuknIqb1s0da
        bc4T6pPLDAbjDlYN6ke2++yZ5RVEemANKF8QrlzEZA==
X-Google-Smtp-Source: ABdhPJx7OKJ76M8Afh6/2WeokE0S97lla0JeBVY32S+nLg1a82BfNIt9sZdcDWFWuV3CtY2KsSQm4VDYKo6jBk6qj7o=
X-Received: by 2002:ac2:5b4b:0:b0:43c:795a:25a6 with SMTP id
 i11-20020ac25b4b000000b0043c795a25a6mr17475739lfp.268.1646185818868; Tue, 01
 Mar 2022 17:50:18 -0800 (PST)
MIME-Version: 1.0
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-5-git-send-email-jdamato@fastly.com> <20220302010225.dlhj3mtikog63zxz@sx1>
In-Reply-To: <20220302010225.dlhj3mtikog63zxz@sx1>
From:   Joe Damato <jdamato@fastly.com>
Date:   Tue, 1 Mar 2022 17:50:07 -0800
Message-ID: <CALALjgzEerMcHnbEGcrsDPdeO5RPp3TpdZP40RD+Qd7MCv03JQ@mail.gmail.com>
Subject: Re: [net-next v8 4/4] mlx5: add support for page_pool_get_stats
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 5:02 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On 01 Mar 14:10, Joe Damato wrote:
> >This change adds support for the page_pool_get_stats API to mlx5. If the
> >user has enabled CONFIG_PAGE_POOL_STATS in their kernel, ethtool will
> >output page pool stats.
> >
>
> I was hoping to see something other than ethtool, a driver-less approach,
> page_pool is a first class citizen, it collects own stats and should be
> able to report own stats without the need for driver help.
>
> I understand these stats are per driver ring, but we can always come up with
> a naming convention in the page pool to allow correlating page-pool stats
> with per ring driver stats.
>
> Anyway i can't think of a simple hack, so this patch is a good temporary
> compromise until we come up with the right approach.
>
> >Signed-off-by: Joe Damato <jdamato@fastly.com>
> >---
> > drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 75 ++++++++++++++++++++++
> > drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 27 +++++++-
> > 2 files changed, 101 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> >index 3e5d8c7..eb518ec 100644
> >--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> >+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> >@@ -37,6 +37,10 @@
> > #include "en/ptp.h"
> > #include "en/port.h"
> >
> >+#ifdef CONFIG_PAGE_POOL_STATS
> >+#include <net/page_pool.h>
> >+#endif
> >+
> > static unsigned int stats_grps_num(struct mlx5e_priv *priv)
> > {
> >       return !priv->profile->stats_grps_num ? 0 :
> >@@ -183,6 +187,19 @@ static const struct counter_desc sw_stats_desc[] = {
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
> >+#ifdef CONFIG_PAGE_POOL_STATS
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_fast) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_slow) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_slow_high_order) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_empty) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_refill) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_alloc_waive) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_cached) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_cache_full) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_ring) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_ring_full) },
> >+      { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_pp_recycle_released_ref) },
> >+#endif
> > #ifdef CONFIG_MLX5_EN_TLS
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_packets) },
> >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_decrypted_bytes) },
> >@@ -349,6 +366,19 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
> >       s->rx_congst_umr              += rq_stats->congst_umr;
> >       s->rx_arfs_err                += rq_stats->arfs_err;
> >       s->rx_recover                 += rq_stats->recover;
> >+#ifdef CONFIG_PAGE_POOL_STATS
> >+      s->rx_pp_alloc_fast          += rq_stats->pp_alloc_fast;
> >+      s->rx_pp_alloc_slow          += rq_stats->pp_alloc_slow;
> >+      s->rx_pp_alloc_empty         += rq_stats->pp_alloc_empty;
> >+      s->rx_pp_alloc_refill        += rq_stats->pp_alloc_refill;
> >+      s->rx_pp_alloc_waive         += rq_stats->pp_alloc_waive;
> >+      s->rx_pp_alloc_slow_high_order          += rq_stats->pp_alloc_slow_high_order;
> >+      s->rx_pp_recycle_cached                 += rq_stats->pp_recycle_cached;
> >+      s->rx_pp_recycle_cache_full             += rq_stats->pp_recycle_cache_full;
> >+      s->rx_pp_recycle_ring                   += rq_stats->pp_recycle_ring;
> >+      s->rx_pp_recycle_ring_full              += rq_stats->pp_recycle_ring_full;
> >+      s->rx_pp_recycle_released_ref           += rq_stats->pp_recycle_released_ref;
> >+#endif
> > #ifdef CONFIG_MLX5_EN_TLS
> >       s->rx_tls_decrypted_packets   += rq_stats->tls_decrypted_packets;
> >       s->rx_tls_decrypted_bytes     += rq_stats->tls_decrypted_bytes;
> >@@ -455,6 +485,35 @@ static void mlx5e_stats_grp_sw_update_stats_qos(struct mlx5e_priv *priv,
> >       }
> > }
> >
> >+#ifdef CONFIG_PAGE_POOL_STATS
> >+static void mlx5e_stats_update_stats_rq_page_pool(struct mlx5e_channel *c)
> >+{
> >+      struct mlx5e_rq_stats *rq_stats = c->rq.stats;
> >+      struct page_pool *pool = c->rq.page_pool;
> >+      struct page_pool_stats stats = { 0 };
> >+
> you can drop the 0, just {} should be enough.
>
> >+      if (!page_pool_get_stats(pool, &stats))
> >+              return;
> >+
>
> you can contain the whole page_pool_stats objects inside rq_stats object,
> and avoid all the assignments below.
>
> just do:
>     page_pool_get_stats(pool, &rq_stats.pp);
>     return;

I don't think I can because the maximum stat name size is 32 bytes
(ETH_GSTRING_LEN).

If I do what you are suggesting, I would need to do something like:

{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats,
pp.recycle_stats.released_refcnt) }

which will generate a string of the form:
"rx%d_pp.recycle_stats.released_refcnt" which is well over 32 bytes,
especially with double-digit queue numbers.

The only options I see are:
  - A new define that allows setting a custom field name
(MLX5E_DECLARE_RX_STAT_NAME_OVERRIDE ?), or
  - Leaving the code as-is

Can you let me know what you prefer for the v9?

Thanks,
Joe
