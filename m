Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCAB6BF3BC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCQVV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCQVV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:21:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B71C795B
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 14:21:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i6-20020a170902c94600b0019d16e4ac0bso3298430pla.5
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 14:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679088110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PzsBZNbSc5Cbu7o6c4aa6/HqL8bVQjVwQw8nR/BqY10=;
        b=M3pyj4WXzRt5UOa9AGraYYh1SMXzBIrCA12O1wU1pGc3u4z8qivxajOailzHPT20mJ
         bB42c+Ws9X1LLYsiqQD6IZe1BJSIllAIVbN2utQOdT9d1jyqlBDpt99ebpcOKI5zDZpt
         rUqxrV6frBBIY7ISv1P4cvRqIrH3xvBCAiQVFgLxcC9muYMA8LOuBs3AlEIU9lIYtD8y
         kXg8mlfbVKAibTjQ5fdhWcU0ocFMf4zVJhI4nde1oGlTuxESqEml0JFrPQjL5fDA/2s8
         1+ghb9aXrSg8QzQjteR7mPTcQWf4tIH184yf43wOd077i9g8I+P8btQ11XZFGpKU8aIe
         EQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679088110;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PzsBZNbSc5Cbu7o6c4aa6/HqL8bVQjVwQw8nR/BqY10=;
        b=smVaJcPYpPszNXVo1MaGkPVz5H5bz8yxb/4FyXJjwsbx1PQuzuABYLaEm+U4GKiqaq
         KSYszAdTChHwYCKbAKXYO7rLg3fKbxhjsSNaoa/C4lGxbMRZieSQMXGeJPBQp4l9czO8
         t6+AAM8s2+osk2lZxud46I6sEay9QU1YtJA5sawmB8StNWPgdvye0x1kNJORm5R/dL6C
         RENoy5igh34BSFhn1+6teu4XX2wnvkx+53Tps+5zdAgcwkJmXKb47CqTJI18YJqhuxI+
         xbgXdJOwHOx1mOVUJCzPznBEK9oR5Y97Show6mjfqj6jzMOYIWvgGauESTqg5qtla6N6
         RRbg==
X-Gm-Message-State: AO0yUKWFuR74l8acZhTqPkuTDJTeW6P8JTZAHfzgmu/2mPyk3dyw94T/
        tjucAyDcw+NanU9SuQEPPyimQog=
X-Google-Smtp-Source: AK7set9tu9oc1RUjxgzKPCg+fE9JjxddXFmRXUmD2tbjQ8Qh5j337E8HODQsf2FImw0oHf/u/g7DsGE=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:2585:b0:19f:28f4:1db with SMTP id
 jb5-20020a170903258500b0019f28f401dbmr3468766plb.8.1679088110486; Fri, 17 Mar
 2023 14:21:50 -0700 (PDT)
Date:   Fri, 17 Mar 2023 14:21:48 -0700
In-Reply-To: <167906359575.2706833.545256364239637451.stgit@firesoul>
Mime-Version: 1.0
References: <167906343576.2706833.17489167761084071890.stgit@firesoul> <167906359575.2706833.545256364239637451.stgit@firesoul>
Message-ID: <ZBTZ7J9B6yXNJO1m@google.com>
Subject: Re: [PATCH bpf-next V1 1/7] xdp: bpf_xdp_metadata use EOPNOTSUPP for
 no driver support
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/17, Jesper Dangaard Brouer wrote:
> When driver doesn't implement a bpf_xdp_metadata kfunc the fallback
> implementation returns EOPNOTSUPP, which indicate device driver doesn't
> implement this kfunc.

> Currently many drivers also return EOPNOTSUPP when the hint isn't
> available, which is inconsistent from an API point of view. Instead
> change drivers to return ENODATA in these cases.

> There can be natural cases why a driver doesn't provide any hardware
> info for a specific hint, even on a frame to frame basis (e.g. PTP).
> Lets keep these cases as separate return codes.

> When describing the return values, adjust the function kernel-doc layout
> to get proper rendering for the return values.

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

I don't remember whether the previous discussion ended in something?
IIRC Martin was preferring to use xdp-features for this instead?

Personally I'm fine with having this convention, but I'm not sure how well
we'll be able to enforce them. (In general, I'm not a fan of userspace
changing it's behavior based on errno. If it's mostly for
debugging/development - seems ok)

> ---
>   Documentation/networking/xdp-rx-metadata.rst     |    7 +++++--
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c       |    4 ++--
>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    4 ++--
>   drivers/net/veth.c                               |    4 ++--
>   net/core/xdp.c                                   |   10 ++++++++--
>   5 files changed, 19 insertions(+), 10 deletions(-)

> diff --git a/Documentation/networking/xdp-rx-metadata.rst  
> b/Documentation/networking/xdp-rx-metadata.rst
> index aac63fc2d08b..25ce72af81c2 100644
> --- a/Documentation/networking/xdp-rx-metadata.rst
> +++ b/Documentation/networking/xdp-rx-metadata.rst
> @@ -23,10 +23,13 @@ metadata is supported, this set will grow:
>   An XDP program can use these kfuncs to read the metadata into stack
>   variables for its own consumption. Or, to pass the metadata on to other
>   consumers, an XDP program can store it into the metadata area carried
> -ahead of the packet.
> +ahead of the packet. Not all packets will necessary have the requested
> +metadata available in which case the driver returns ``-ENODATA``.

>   Not all kfuncs have to be implemented by the device driver; when not
> -implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
> +implemented, the default ones that return ``-EOPNOTSUPP`` will be used
> +to indicate the device driver have not implemented this kfunc.
> +

>   Within an XDP frame, the metadata layout (accessed via ``xdp_buff``) is
>   as follows::
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c  
> b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 0869d4fff17b..4b5e459b6d49 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -674,7 +674,7 @@ int mlx4_en_xdp_rx_timestamp(const struct xdp_md  
> *ctx, u64 *timestamp)
>   	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;

>   	if (unlikely(_ctx->ring->hwtstamp_rx_filter != HWTSTAMP_FILTER_ALL))
> -		return -EOPNOTSUPP;
> +		return -ENODATA;

>   	*timestamp = mlx4_en_get_hwtstamp(_ctx->mdev,
>   					  mlx4_en_get_cqe_ts(_ctx->cqe));
> @@ -686,7 +686,7 @@ int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32  
> *hash)
>   	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;

>   	if (unlikely(!(_ctx->dev->features & NETIF_F_RXHASH)))
> -		return -EOPNOTSUPP;
> +		return -ENODATA;

>   	*hash = be32_to_cpu(_ctx->cqe->immed_rss_invalid);
>   	return 0;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index bcd6370de440..c5dae48b7932 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -162,7 +162,7 @@ static int mlx5e_xdp_rx_timestamp(const struct xdp_md  
> *ctx, u64 *timestamp)
>   	const struct mlx5e_xdp_buff *_ctx = (void *)ctx;

>   	if (unlikely(!mlx5e_rx_hw_stamp(_ctx->rq->tstamp)))
> -		return -EOPNOTSUPP;
> +		return -ENODATA;

>   	*timestamp =  mlx5e_cqe_ts_to_ns(_ctx->rq->ptp_cyc2time,
>   					 _ctx->rq->clock, get_cqe_ts(_ctx->cqe));
> @@ -174,7 +174,7 @@ static int mlx5e_xdp_rx_hash(const struct xdp_md  
> *ctx, u32 *hash)
>   	const struct mlx5e_xdp_buff *_ctx = (void *)ctx;

>   	if (unlikely(!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH)))
> -		return -EOPNOTSUPP;
> +		return -ENODATA;

>   	*hash = be32_to_cpu(_ctx->cqe->rss_hash_result);
>   	return 0;
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 1bb54de7124d..046461ee42ea 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1610,7 +1610,7 @@ static int veth_xdp_rx_timestamp(const struct  
> xdp_md *ctx, u64 *timestamp)
>   	struct veth_xdp_buff *_ctx = (void *)ctx;

>   	if (!_ctx->skb)
> -		return -EOPNOTSUPP;
> +		return -ENODATA;

>   	*timestamp = skb_hwtstamps(_ctx->skb)->hwtstamp;
>   	return 0;
> @@ -1621,7 +1621,7 @@ static int veth_xdp_rx_hash(const struct xdp_md  
> *ctx, u32 *hash)
>   	struct veth_xdp_buff *_ctx = (void *)ctx;

>   	if (!_ctx->skb)
> -		return -EOPNOTSUPP;
> +		return -ENODATA;

>   	*hash = skb_get_hash(_ctx->skb);
>   	return 0;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 8d3ad315f18d..7133017bcd74 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -705,7 +705,10 @@ __diag_ignore_all("-Wmissing-prototypes",
>    * @ctx: XDP context pointer.
>    * @timestamp: Return value pointer.
>    *
> - * Returns 0 on success or ``-errno`` on error.
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + * * ``-EOPNOTSUPP`` : means device driver does not implement kfunc
> + * * ``-ENODATA``    : means no RX-timestamp available for this frame
>    */
>   __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,  
> u64 *timestamp)
>   {
> @@ -717,7 +720,10 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const  
> struct xdp_md *ctx, u64 *tim
>    * @ctx: XDP context pointer.
>    * @hash: Return value pointer.
>    *
> - * Returns 0 on success or ``-errno`` on error.
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
> + * * ``-ENODATA``    : means no RX-hash available for this frame
>    */
>   __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32  
> *hash)
>   {


