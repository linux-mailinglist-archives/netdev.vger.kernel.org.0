Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7942863434F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbiKVSIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiKVSIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:08:51 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001442CCAB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:08:45 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l127so16669818oia.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zaxCls2YnixP/+mVX2V2w/QOTiZcMWJ2TjjBK6+PNeA=;
        b=PCho3K/yx0e+sIXMHl+jPB+G3Hq5echJhyIk+pVrAssdC8HFbdNqDiOX6pyktVHLsf
         /Rb2K2v2QoXx1mzMFEDUpwEVZ/dBWmwi9naz0tPWRbvqkSOhmtqpiVcHMFkU+qDOiSOu
         F8jK+MzsDFvxvUx0ryJd9IXHihMx8BaC89ifzdlToMqF2+cbwF28nmFiU59lBNBcutJX
         296PPuPxsSjXKh54RtdOxteoI5UTvmwENDT8a6lMhIwnN83U0krxHSh5a8Xukv3HvOgS
         gYlutGs/Go2NM/H2bXjcX06ZuRsV4oGomv8ASdMnWm+E4URbvx9cJIZMXVNfJ/tDiv4I
         Z13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zaxCls2YnixP/+mVX2V2w/QOTiZcMWJ2TjjBK6+PNeA=;
        b=JCkVVcs/uGPBj0nz5Ver0iiCkxyoFhf4A9f07tReq8NkN8IyTU8v3UW98P3yagPcUJ
         nId1CpBzrs1pFwZ9XmMzn6JEJ43CG1GulTsKD1e+w5Bpti3V7kSH7ND2eCHESdu/S9ap
         GtFoyTdlPBYfxBqRGhUj8mFNiUQ4eCtMpEep2g2c+S3OF20ayQTGHv7bnwzVhJI7zzdD
         +m64fQUZFeOO8ekRw2rinS0y9fZpZi6bwTxIl8cvK6X0Y6wS0qXrd7G1mInk/Rn4qIa/
         W/pxDvmHL2frZS9M1QbEWAUzG/hWtEgraBVsEwaLjA+D9P6jL7EEKqKhjxXrvm+ctotn
         M6XQ==
X-Gm-Message-State: ANoB5pmSLUUzWwn6P2lb8vicxDEN0wIesUw7N9RLMbZNOn71faGF9fsK
        qaPLjcx6a6hRy3TdOz1bQbqJ/zIvuS/v/8FgXly1oA==
X-Google-Smtp-Source: AA0mqf79pIhBy6++Vd9PPoNma0xSWxxVfrOU+xR4DUWinCfU3NfxU3zysoIBdQF78YuSYidvJfcdg1Vemcn5+oiHZXQ=
X-Received: by 2002:a05:6808:f09:b0:354:8922:4a1a with SMTP id
 m9-20020a0568080f0900b0035489224a1amr2192816oiw.181.1669140524869; Tue, 22
 Nov 2022 10:08:44 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-8-sdf@google.com>
 <a692f096-bf81-7974-fa66-afbe3d48fb6e@gmail.com>
In-Reply-To: <a692f096-bf81-7974-fa66-afbe3d48fb6e@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 22 Nov 2022 10:08:34 -0800
Message-ID: <CAKH8qBtGgxUyRcMG+_XvHaTzM49GZnWZUnL6yr0uYhdTXgWHrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 7/8] mxl4: Support RX XDP metadata
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 5:50 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 11/21/2022 8:25 PM, Stanislav Fomichev wrote:
> > RX timestamp and hash for now. Tested using the prog from the next
> > patch.
> >
> > Also enabling xdp metadata support; don't see why it's disabled,
> > there is enough headroom..
> >
> > Cc: Tariq Toukan <tariqt@nvidia.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > Cc: xdp-hints@xdp-project.net
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 ++++
> >   drivers/net/ethernet/mellanox/mlx4/en_rx.c    | 48 ++++++++++++++++++-
> >   include/linux/mlx4/device.h                   |  7 +++
> >   3 files changed, 64 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > index 8800d3f1f55c..1cb63746a851 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > @@ -2855,6 +2855,11 @@ static const struct net_device_ops mlx4_netdev_ops = {
> >       .ndo_features_check     = mlx4_en_features_check,
> >       .ndo_set_tx_maxrate     = mlx4_en_set_tx_maxrate,
> >       .ndo_bpf                = mlx4_xdp,
> > +
> > +     .ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
> > +     .ndo_xdp_rx_timestamp   = mlx4_xdp_rx_timestamp,
> > +     .ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
> > +     .ndo_xdp_rx_hash        = mlx4_xdp_rx_hash,
> >   };
> >
> >   static const struct net_device_ops mlx4_netdev_ops_master = {
> > @@ -2887,6 +2892,11 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
> >       .ndo_features_check     = mlx4_en_features_check,
> >       .ndo_set_tx_maxrate     = mlx4_en_set_tx_maxrate,
> >       .ndo_bpf                = mlx4_xdp,
> > +
> > +     .ndo_xdp_rx_timestamp_supported = mlx4_xdp_rx_timestamp_supported,
> > +     .ndo_xdp_rx_timestamp   = mlx4_xdp_rx_timestamp,
> > +     .ndo_xdp_rx_hash_supported = mlx4_xdp_rx_hash_supported,
> > +     .ndo_xdp_rx_hash        = mlx4_xdp_rx_hash,
> >   };
> >
> >   struct mlx4_en_bond {
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > index 467356633172..fd14d59f6cbf 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -663,8 +663,50 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
> >
> >   struct mlx4_xdp_buff {
> >       struct xdp_buff xdp;
> > +     struct mlx4_cqe *cqe;
> > +     struct mlx4_en_dev *mdev;
> > +     struct mlx4_en_rx_ring *ring;
> > +     struct net_device *dev;
> >   };
> >
> > +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return _ctx->ring->hwtstamp_rx_filter == HWTSTAMP_FILTER_ALL;
> > +}
> > +
> > +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +     unsigned int seq;
> > +     u64 timestamp;
> > +     u64 nsec;
> > +
> > +     timestamp = mlx4_en_get_cqe_ts(_ctx->cqe);
> > +
> > +     do {
> > +             seq = read_seqbegin(&_ctx->mdev->clock_lock);
> > +             nsec = timecounter_cyc2time(&_ctx->mdev->clock, timestamp);
> > +     } while (read_seqretry(&_ctx->mdev->clock_lock, seq));
> > +
>
> This is open-code version of mlx4_en_fill_hwtstamps.
> Better use the existing function.

That one assumes the skb_shared_hwtstamps argument :-(
Should I try to separate the common parts into some new helper function instead?

Or maybe I can just change mlx4_en_fill_hwtstamps to the following?

u64 mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev, u64 timestamp)
{
   ...
   return ns_to_ktime(nsec);
}

And replace existing callers with:

skb_hwtstamps(skb)->hwtstamp = mlx4_en_fill_hwtstamps(priv->mdev, timestamp).

?


> > +     return ns_to_ktime(nsec);
> > +}
> > +
> > +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return _ctx->dev->features & NETIF_F_RXHASH;
> > +}
> > +
> > +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx)
> > +{
> > +     struct mlx4_xdp_buff *_ctx = (void *)ctx;
> > +
> > +     return be32_to_cpu(_ctx->cqe->immed_rss_invalid);
> > +}
> > +
> >   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
> >   {
> >       struct mlx4_en_priv *priv = netdev_priv(dev);
> > @@ -781,8 +823,12 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
> >                                               DMA_FROM_DEVICE);
> >
> >                       xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
> > -                                      frags[0].page_offset, length, false);
> > +                                      frags[0].page_offset, length, true);
> >                       orig_data = mxbuf.xdp.data;
> > +                     mxbuf.cqe = cqe;
> > +                     mxbuf.mdev = priv->mdev;
> > +                     mxbuf.ring = ring;
> > +                     mxbuf.dev = dev;
> >
> >                       act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
> >
> > diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
> > index 6646634a0b9d..d5904da1d490 100644
> > --- a/include/linux/mlx4/device.h
> > +++ b/include/linux/mlx4/device.h
> > @@ -1585,4 +1585,11 @@ static inline int mlx4_get_num_reserved_uar(struct mlx4_dev *dev)
> >       /* The first 128 UARs are used for EQ doorbells */
> >       return (128 >> (PAGE_SHIFT - dev->uar_page_shift));
> >   }
> > +
> > +struct xdp_md;
> > +bool mlx4_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
> > +u64 mlx4_xdp_rx_timestamp(const struct xdp_md *ctx);
> > +bool mlx4_xdp_rx_hash_supported(const struct xdp_md *ctx);
> > +u32 mlx4_xdp_rx_hash(const struct xdp_md *ctx);
> > +
> >   #endif /* MLX4_DEVICE_H */
