Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EB64C64ED
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 09:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiB1Ija (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 03:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiB1Ij3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 03:39:29 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4685421E0F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 00:38:50 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id r20so16355772ljj.1
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 00:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/T5/aA282OhZVpVeoBbgrirpqDFKv1amKtNobYkr1X8=;
        b=Ah+Zqq9bbcAWpioCu+0OCxdSCd8+KOyLX+tNfAxlZSyHdVPgLc7E7UjQCqW90ZQoX7
         BosMBDlvjOMk+IDFqrJYbwcCy/SH6t52zTSBC9pT08cnuo4Z6byhFc0aJO3cmlUwLJWY
         6kH2mKBQ3+s4qPrX7gOWy04tvqPosHLj07ryI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/T5/aA282OhZVpVeoBbgrirpqDFKv1amKtNobYkr1X8=;
        b=fH/E7q+3Ujt8tzoyRCeTnEhBagCoxoafNWzUzBuqEhse+y3QfSq6UtSYc1C+CzbwCZ
         eEhj85yO7ITHSAT7QkUjhsxpvZupRWidRzTK75TlIHAz2D9v0wZbNLYx2RHjncUHre7S
         wq665bGBsHQpBQMsDpRwelqrqq0+RWzBXLtj5bbnnIIoqIKj2l4jNp2neKqmuezyoL2o
         WQ5NtfVoiasksXpuIxtl1FPqVY7/+yIIBZs2DjBQelHZkPFfgQd2hcunM7bMP45sgM3M
         ibzPy6xr0r53dENYyJ4w6+jFT8a/Hh6gcmTmVbYGlfzqIy17k4ay3JjN6pt2WwCNOsNu
         ONsA==
X-Gm-Message-State: AOAM531zbJYhmXj0Ab6nUlHvzvcoyqGaKml4xy7a3+NxuRHvXrrAaBIr
        94z3Ktz/qzezeoxTVx/TRnA7CDpDb/q/Pq3nQetF4mwEElfR8A==
X-Google-Smtp-Source: ABdhPJzxOaiTA4oDqTQOe6lZp7zLMM4EZC1Lm5PfRrLjvPlOM2NO3fOCeaXN39p3Bh29uwhJ5UqONi8KMeDrFKJtqhA=
X-Received: by 2002:a2e:90d6:0:b0:246:e44:bcf6 with SMTP id
 o22-20020a2e90d6000000b002460e44bcf6mr13799384ljg.501.1646037528631; Mon, 28
 Feb 2022 00:38:48 -0800 (PST)
MIME-Version: 1.0
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-5-git-send-email-jdamato@fastly.com> <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
In-Reply-To: <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Mon, 28 Feb 2022 00:38:37 -0800
Message-ID: <CALALjgxS0q+Vbg8rgrqTZ+CSV=9tXOTdxE7S4VGGnvsbicLE3A@mail.gmail.com>
Subject: Re: [net-next v7 4/4] mlx5: add support for page_pool_get_stats
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
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

On Sun, Feb 27, 2022 at 11:28 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 25/02/2022 18.41, Joe Damato wrote:
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fast) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow_high_order) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_empty) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_refill) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_waive) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cached) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cache_full) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring_full) },
> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_released_ref) },
> > +#endif
>
> The naming: "page_pool_rec_xxx".
> What does the "rec" stand for?

rec stands for recycle.

ethtool strings have a limited size (ETH_GSTRING_LEN - 32 bytes) and
the full word "recycle" didn't fit for some of the stats once the
queue number is prepended elsewhere in the driver code.

> Users of ethtool -S stats... will they know "rec" is "recycle" ?

I am open to other names or adding documentation to the driver docs to
explain the meaning.

> p.s. we need acks from driver maintainer(s).

I've CC'd Tariq and Saaed; I hope they'll take a look when they have a
chance and weigh in on the naming. I am happy to adjust the names as
they wish and submit a v8, or take this code as-is and then iterate on
the names in a separate change.

I think the latter option would be easiest, but I am happy to do
whatever you all prefer.

Thanks,
Joe
