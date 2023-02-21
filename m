Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3E69E5AC
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbjBURNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbjBURNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:13:40 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C469B459
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:13:36 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d1-20020a17090a3b0100b00229ca6a4636so5870804pjc.0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nU5vzjl79IVycVRB2OQHoQVSxwNqWlzOBlgs7WDZ1NE=;
        b=MuuvmSIYYlvR4Kz7eX7YQ6CwgrrykVG9erJCdk1/HkLTPsA9IEKUKZFxmRRaBXR++0
         DC2xcsX0BcmptZZ0kS1x6u6m8g6HG9qoVlxAke3p6GrieBDgwi++HyDOClbZvQJo3KjA
         GbrSXylqPQ7yNBMap+FCSH3veJ/YO/8RmU9PP9SrL/ZrMbZ7io+GT4ogdhs7jo3HOASs
         XjAO8h36vzsa5bBqFPkyBEtCLbNXXjO49SjrZsPf6+h/k2RDePihTm25L+PVz+sfkhiU
         upIC9SafDddIY9lO8gk1oY33YNf5CvB+GzYPa95CVbdZ4H9oiKKe6fq3H0ashUG6nt+H
         eYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nU5vzjl79IVycVRB2OQHoQVSxwNqWlzOBlgs7WDZ1NE=;
        b=lS/UGCamWThyWEro3qg2hdp+TnPNF9q+h8ImCyrgG1TLMyZjiJ8t25xm/yax1ai/Aa
         wnOS2C9pmEeeKkTik7q7HAlI9k0M3CJ361isHRvYzbPSBcwVrE4o8tIi8UxvjxC3HF6e
         m7e4MZk8HPEAkd3+CldKHoibTeaFQ/PPO8nJKMwCKoxofuaUXHAwz+/h8egSHR9rQKBc
         W9p073W1Lz0OFVLqwUg0rllbljuiRlDmJDlf1azct9jpvKGYIHGt66fQgsSIbUVbEUgW
         +grhDKZqoJpkKyQKU+a0Ik2iPE1G2nA2jWlYotzVaHu8LTozL/ZtE0HrKGk2jZeXMC+e
         qIRA==
X-Gm-Message-State: AO0yUKVzrFr3ZLm1eKh8USk+dG4DXRiAOPcvQC5kZz0udA+6g+dQ9gd/
        nWqI24tASRmOdXtIFmkBRPK8TVk4iXa5ky8v3YjvOrHwvzg2dV9oFjU=
X-Google-Smtp-Source: AK7set9mN3eV18T71Etlm/MmFnEQeHiiTGY32WKK46KWW9bcLXl6vlrTXBXKQKz0tE4CxYF/z5XDx//6EZ0+Shk36+U=
X-Received: by 2002:a17:90b:3b92:b0:233:e796:7583 with SMTP id
 pc18-20020a17090b3b9200b00233e7967583mr1516977pjb.1.1676999615324; Tue, 21
 Feb 2023 09:13:35 -0800 (PST)
MIME-Version: 1.0
References: <167673444093.2179692.14745621008776172374.stgit@firesoul>
In-Reply-To: <167673444093.2179692.14745621008776172374.stgit@firesoul>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 21 Feb 2023 09:13:23 -0800
Message-ID: <CAKH8qBt-wgiFTjbNfuWXC+CNbnDbVPWuoJFO_H_=tc4e3BZGPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3] xdp: bpf_xdp_metadata use EOPNOTSUPP for no
 driver support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
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

On Sat, Feb 18, 2023 at 7:34 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> When driver doesn't implement a bpf_xdp_metadata kfunc the default
> implementation returns EOPNOTSUPP, which indicate device driver doesn't
> implement this kfunc.
>
> Currently many drivers also return EOPNOTSUPP when the hint isn't
> available. Instead change drivers to return ENODATA in these cases.
> There can be natural cases why a driver doesn't provide any hardware
> info for a specific hint, even on a frame to frame basis (e.g. PTP).
> Lets keep these cases as separate return codes.
>
> When describing the return values, adjust the function kernel-doc layout
> to get proper rendering for the return values.

Acked-by: Stanislav Fomichev <sdf@google.com>

Thanks! ENODATA seems like a better fit for the actual implementation.
Long term probably still makes sense to export this info via xdp-features?
Not sure how long we can 100% ensure EOPNOTSUPP vs ENODATA convention :-)

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  Documentation/networking/xdp-rx-metadata.rst     |    7 +++++--
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c       |    4 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    4 ++--
>  drivers/net/veth.c                               |    4 ++--
>  net/core/xdp.c                                   |   10 ++++++++--
>  5 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> index aac63fc2d08b..25ce72af81c2 100644
> --- a/Documentation/networking/xdp-rx-metadata.rst
> +++ b/Documentation/networking/xdp-rx-metadata.rst
> @@ -23,10 +23,13 @@ metadata is supported, this set will grow:
>  An XDP program can use these kfuncs to read the metadata into stack
>  variables for its own consumption. Or, to pass the metadata on to other
>  consumers, an XDP program can store it into the metadata area carried
> -ahead of the packet.
> +ahead of the packet. Not all packets will necessary have the requested
> +metadata available in which case the driver returns ``-ENODATA``.
>
>  Not all kfuncs have to be implemented by the device driver; when not
> -implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
> +implemented, the default ones that return ``-EOPNOTSUPP`` will be used
> +to indicate the device driver have not implemented this kfunc.
> +
>
>  Within an XDP frame, the metadata layout (accessed via ``xdp_buff``) is
>  as follows::
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 0869d4fff17b..4b5e459b6d49 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -674,7 +674,7 @@ int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>         struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
>
>         if (unlikely(_ctx->ring->hwtstamp_rx_filter != HWTSTAMP_FILTER_ALL))
> -               return -EOPNOTSUPP;
> +               return -ENODATA;
>
>         *timestamp = mlx4_en_get_hwtstamp(_ctx->mdev,
>                                           mlx4_en_get_cqe_ts(_ctx->cqe));
> @@ -686,7 +686,7 @@ int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
>         struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
>
>         if (unlikely(!(_ctx->dev->features & NETIF_F_RXHASH)))
> -               return -EOPNOTSUPP;
> +               return -ENODATA;
>
>         *hash = be32_to_cpu(_ctx->cqe->immed_rss_invalid);
>         return 0;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index f7d52b1d293b..32c444c01906 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -161,7 +161,7 @@ static int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>         const struct mlx5e_xdp_buff *_ctx = (void *)ctx;
>
>         if (unlikely(!mlx5e_rx_hw_stamp(_ctx->rq->tstamp)))
> -               return -EOPNOTSUPP;
> +               return -ENODATA;
>
>         *timestamp =  mlx5e_cqe_ts_to_ns(_ctx->rq->ptp_cyc2time,
>                                          _ctx->rq->clock, get_cqe_ts(_ctx->cqe));
> @@ -173,7 +173,7 @@ static int mlx5e_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
>         const struct mlx5e_xdp_buff *_ctx = (void *)ctx;
>
>         if (unlikely(!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH)))
> -               return -EOPNOTSUPP;
> +               return -ENODATA;
>
>         *hash = be32_to_cpu(_ctx->cqe->rss_hash_result);
>         return 0;
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 1bb54de7124d..046461ee42ea 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1610,7 +1610,7 @@ static int veth_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>         struct veth_xdp_buff *_ctx = (void *)ctx;
>
>         if (!_ctx->skb)
> -               return -EOPNOTSUPP;
> +               return -ENODATA;
>
>         *timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
>         return 0;
> @@ -1621,7 +1621,7 @@ static int veth_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
>         struct veth_xdp_buff *_ctx = (void *)ctx;
>
>         if (!_ctx->skb)
> -               return -EOPNOTSUPP;
> +               return -ENODATA;
>
>         *hash = skb_get_hash(_ctx->skb);
>         return 0;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 26483935b7a4..b71fe21b5c3e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -721,7 +721,10 @@ __diag_ignore_all("-Wmissing-prototypes",
>   * @ctx: XDP context pointer.
>   * @timestamp: Return value pointer.
>   *
> - * Returns 0 on success or ``-errno`` on error.
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + * * ``-EOPNOTSUPP`` : means device driver does not implement kfunc
> + * * ``-ENODATA``    : means no RX-timestamp available for this frame
>   */
>  __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>  {
> @@ -733,7 +736,10 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
>   * @ctx: XDP context pointer.
>   * @hash: Return value pointer.
>   *
> - * Returns 0 on success or ``-errno`` on error.
> + * Return:
> + *  * Returns 0 on success or ``-errno`` on error.
> + *  * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
> + *  * ``-ENODATA``    : means no RX-hash available for this frame
>   */
>  __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
>  {
>
>
