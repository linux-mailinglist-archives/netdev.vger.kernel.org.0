Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880EE66140A
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 08:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjAHHiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 02:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjAHHiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 02:38:14 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30993BCA9;
        Sat,  7 Jan 2023 23:38:12 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x10so5175030edd.10;
        Sat, 07 Jan 2023 23:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=17E7SNkC4+xZQbZC8pwtldVjcnZXevjU/YksNvVV8SQ=;
        b=W/1355s7epCpttI3iuYmJ+kaBKqzhwjjsFgST5cszWIq1P6aj7XSYtR2dOtmtoX23V
         gYrQpmm6DPjMec4YoQPfy+k9Ij/zqIDQiJWGAV3uJqlJKOFe5tH3wT1Ds0oT/pdYAJK7
         Vo0B+yX2r+ul1w6nLoBy+LqZhTLq3+QWpL1vAF+fKlFx9ed2iG+jdCdXnm7nCcvreOmG
         m6h4K/2+Y1FQZ9kri1qGiq2MYVQJc6co9WC8UCqbj3gSm4MDV2ysI3NiMlU0KyBsbA5A
         O52ya2KS5oqbF0VHw12sqQANmMJ01RDSmveNqvrVmChXSRXFJIr0argxkjwl5FnAH6Gx
         5e7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=17E7SNkC4+xZQbZC8pwtldVjcnZXevjU/YksNvVV8SQ=;
        b=6KIKKTLfZ5LvJ2agv6GkhED0tcdsicyvJqQ79Nlgb23es50NKaqp5kJ4+Qesa3HB1W
         Q8AsBOcObajhQ9AK+2A4tgEWEoTjhzuzXlN1GG5tB/qA3opC/QSWopsPEmK7mbzM2cCF
         KHM8tYiteetE8Vj+XiGbLF6gjrTbslhK1I1d/mlxqSBwiFl2Nv0Pu0K7iLChuOQHU0jB
         hkXjJaVpEvRgIQGIdhAwyMsnxFLW8tOS4xqLNtcda/ADsXpBjfDY4ALh/NNBa/cKIxNc
         ZCEmBT+/GpqE6RG/lyJPY7MUUKvUAViQKD9djbIrOrid/k0yGNMQwVGkSMGb831tDy5y
         I1ng==
X-Gm-Message-State: AFqh2kqv+FVtijfu11GaZslcOyjXnvDgZ/TSvzT9GeWAig/GlCRY3ERy
        7Kxg+s8BH4d7B2HrOBVcgG8=
X-Google-Smtp-Source: AMrXdXtGt7z3a0YlHtF+JxuvS/frNgN0oTnn0vyqeOIzf1jMz/hWAkfv00loglQ5JkNiQG1vPnTDWw==
X-Received: by 2002:a05:6402:1f89:b0:47b:16c7:492c with SMTP id c9-20020a0564021f8900b0047b16c7492cmr59339787edc.25.1673163490648;
        Sat, 07 Jan 2023 23:38:10 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id o7-20020aa7d3c7000000b0045bd14e241csm2235190edr.76.2023.01.07.23.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jan 2023 23:38:10 -0800 (PST)
Message-ID: <c91c22db-a59f-20de-0229-722900f1ce59@gmail.com>
Date:   Sun, 8 Jan 2023 09:38:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v6 15/17] net/mlx5e: Introduce wrapper for
 xdp_buff
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20230104215949.529093-1-sdf@google.com>
 <20230104215949.529093-16-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230104215949.529093-16-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/01/2023 23:59, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Preparation for implementing HW metadata kfuncs. No functional change.
> 
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Thanks for you patch.
Find 1 minor comment below.

>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 +++++----
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 56 +++++++++----------
>   5 files changed, 49 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 2d77fb8a8a01..af663978d1b4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>   union mlx5e_alloc_unit {
>   	struct page *page;
>   	struct xdp_buff *xsk;
> +	struct mlx5e_xdp_buff *mxbuf;
>   };
>   
>   /* XDP packets can be transmitted in different ways. On completion, we need to
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index 20507ef2f956..31bb6806bf5d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -158,8 +158,9 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
>   
>   /* returns true if packet was consumed by xdp */
>   bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> -		      struct bpf_prog *prog, struct xdp_buff *xdp)
> +		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf)
>   {
> +	struct xdp_buff *xdp = &mxbuf->xdp;
>   	u32 act;
>   	int err;
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index bc2d9034af5b..389818bf6833 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -44,10 +44,14 @@
>   	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
>   	 sizeof(struct mlx5_wqe_inline_seg))
>   
> +struct mlx5e_xdp_buff {
> +	struct xdp_buff xdp;
> +};
> +
>   struct mlx5e_xsk_param;
>   int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
>   bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> -		      struct bpf_prog *prog, struct xdp_buff *xdp);
> +		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mlctx);
>   void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
>   bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
>   void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index c91b54d9ff27..9cff82d764e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -22,6 +22,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   		goto err;
>   
>   	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].xsk));
> +	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
>   	batch = xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->alloc_units,
>   				     rq->mpwqe.pages_per_wqe);
>   
> @@ -233,7 +234,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   						    u32 head_offset,
>   						    u32 page_idx)
>   {
> -	struct xdp_buff *xdp = wi->alloc_units[page_idx].xsk;
> +	struct mlx5e_xdp_buff *mxbuf = wi->alloc_units[page_idx].mxbuf;
>   	struct bpf_prog *prog;
>   
>   	/* Check packet size. Note LRO doesn't use linear SKB */
> @@ -249,9 +250,9 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   	 */
>   	WARN_ON_ONCE(head_offset);
>   
> -	xsk_buff_set_size(xdp, cqe_bcnt);
> -	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
> -	net_prefetch(xdp->data);
> +	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
> +	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
> +	net_prefetch(mxbuf->xdp.data);
>   
>   	/* Possible flows:
>   	 * - XDP_REDIRECT to XSKMAP:
> @@ -269,7 +270,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   	 */
>   
>   	prog = rcu_dereference(rq->xdp_prog);
> -	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp))) {
> +	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf))) {
>   		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
>   			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
>   		return NULL; /* page/packet was consumed by XDP */
> @@ -278,14 +279,14 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
>   	/* XDP_PASS: copy the data from the UMEM to a new SKB and reuse the
>   	 * frame. On SKB allocation failure, NULL is returned.
>   	 */
> -	return mlx5e_xsk_construct_skb(rq, xdp);
> +	return mlx5e_xsk_construct_skb(rq, &mxbuf->xdp);
>   }
>   
>   struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>   					      struct mlx5e_wqe_frag_info *wi,
>   					      u32 cqe_bcnt)
>   {
> -	struct xdp_buff *xdp = wi->au->xsk;
> +	struct mlx5e_xdp_buff *mxbuf = wi->au->mxbuf;
>   	struct bpf_prog *prog;
>   
>   	/* wi->offset is not used in this function, because xdp->data and the
> @@ -295,17 +296,17 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>   	 */
>   	WARN_ON_ONCE(wi->offset);
>   
> -	xsk_buff_set_size(xdp, cqe_bcnt);
> -	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
> -	net_prefetch(xdp->data);
> +	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
> +	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
> +	net_prefetch(mxbuf->xdp.data);
>   
>   	prog = rcu_dereference(rq->xdp_prog);
> -	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp)))
> +	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf)))
>   		return NULL; /* page/packet was consumed by XDP */
>   
>   	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
>   	 * will be handled by mlx5e_free_rx_wqe.
>   	 * On SKB allocation failure, NULL is returned.
>   	 */
> -	return mlx5e_xsk_construct_skb(rq, xdp);
> +	return mlx5e_xsk_construct_skb(rq, &mxbuf->xdp);
>   }
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index c8820ab22169..c8a2b26de36e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1576,10 +1576,10 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
>   }
>   
>   static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,

This now acts on an mlx5e_xdp_buff object. How about changing the func 
name accordingly?

The obvious rename to mlx5e_fill_mlx5e_xdp_buff doesn't work here.
Maybe mlx5e_fill_mxbuf ?

> -				u32 len, struct xdp_buff *xdp)
> +				u32 len, struct mlx5e_xdp_buff *mxbuf)
>   {
> -	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
> -	xdp_prepare_buff(xdp, va, headroom, len, true);
> +	xdp_init_buff(&mxbuf->xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
> +	xdp_prepare_buff(&mxbuf->xdp, va, headroom, len, true);
>   }
>   
>   static struct sk_buff *
> @@ -1606,16 +1606,16 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
>   
>   	prog = rcu_dereference(rq->xdp_prog);
>   	if (prog) {
> -		struct xdp_buff xdp;
> +		struct mlx5e_xdp_buff mxbuf >
>   		net_prefetchw(va); /* xdp_frame data area */
> -		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
> -		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp))
> +		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
> +		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
>   			return NULL; /* page/packet was consumed by XDP */
>   
> -		rx_headroom = xdp.data - xdp.data_hard_start;
> -		metasize = xdp.data - xdp.data_meta;
> -		cqe_bcnt = xdp.data_end - xdp.data;
> +		rx_headroom = mxbuf.xdp.data - mxbuf.xdp.data_hard_start;
> +		metasize = mxbuf.xdp.data - mxbuf.xdp.data_meta;
> +		cqe_bcnt = mxbuf.xdp.data_end - mxbuf.xdp.data;
>   	}
>   	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
>   	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, metasize);
> @@ -1637,9 +1637,9 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   	union mlx5e_alloc_unit *au = wi->au;
>   	u16 rx_headroom = rq->buff.headroom;
>   	struct skb_shared_info *sinfo;
> +	struct mlx5e_xdp_buff mxbuf;
>   	u32 frag_consumed_bytes;
>   	struct bpf_prog *prog;
> -	struct xdp_buff xdp;
>   	struct sk_buff *skb;
>   	dma_addr_t addr;
>   	u32 truesize;
> @@ -1654,8 +1654,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   	net_prefetchw(va); /* xdp_frame data area */
>   	net_prefetch(va + rx_headroom);
>   
> -	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &xdp);
> -	sinfo = xdp_get_shared_info_from_buff(&xdp);
> +	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf);
> +	sinfo = xdp_get_shared_info_from_buff(&mxbuf.xdp);
>   	truesize = 0;
>   
>   	cqe_bcnt -= frag_consumed_bytes;
> @@ -1673,13 +1673,13 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
>   					frag_consumed_bytes, rq->buff.map_dir);
>   
> -		if (!xdp_buff_has_frags(&xdp)) {
> +		if (!xdp_buff_has_frags(&mxbuf.xdp)) {
>   			/* Init on the first fragment to avoid cold cache access
>   			 * when possible.
>   			 */
>   			sinfo->nr_frags = 0;
>   			sinfo->xdp_frags_size = 0;
> -			xdp_buff_set_frags_flag(&xdp);
> +			xdp_buff_set_frags_flag(&mxbuf.xdp);
>   		}
>   
>   		frag = &sinfo->frags[sinfo->nr_frags++];
> @@ -1688,7 +1688,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   		skb_frag_size_set(frag, frag_consumed_bytes);
>   
>   		if (page_is_pfmemalloc(au->page))
> -			xdp_buff_set_frag_pfmemalloc(&xdp);
> +			xdp_buff_set_frag_pfmemalloc(&mxbuf.xdp);
>   
>   		sinfo->xdp_frags_size += frag_consumed_bytes;
>   		truesize += frag_info->frag_stride;
> @@ -1701,7 +1701,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   	au = head_wi->au;
>   
>   	prog = rcu_dereference(rq->xdp_prog);
> -	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
> +	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
>   		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
>   			int i;
>   
> @@ -1711,22 +1711,22 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>   		return NULL; /* page/packet was consumed by XDP */
>   	}
>   
> -	skb = mlx5e_build_linear_skb(rq, xdp.data_hard_start, rq->buff.frame0_sz,
> -				     xdp.data - xdp.data_hard_start,
> -				     xdp.data_end - xdp.data,
> -				     xdp.data - xdp.data_meta);
> +	skb = mlx5e_build_linear_skb(rq, mxbuf.xdp.data_hard_start, rq->buff.frame0_sz,
> +				     mxbuf.xdp.data - mxbuf.xdp.data_hard_start,
> +				     mxbuf.xdp.data_end - mxbuf.xdp.data,
> +				     mxbuf.xdp.data - mxbuf.xdp.data_meta);
>   	if (unlikely(!skb))
>   		return NULL;
>   
>   	page_ref_inc(au->page);
>   
> -	if (unlikely(xdp_buff_has_frags(&xdp))) {
> +	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
>   		int i;
>   
>   		/* sinfo->nr_frags is reset by build_skb, calculate again. */
>   		xdp_update_skb_shared_info(skb, wi - head_wi - 1,
>   					   sinfo->xdp_frags_size, truesize,
> -					   xdp_buff_is_frag_pfmemalloc(&xdp));
> +					   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
>   
>   		for (i = 0; i < sinfo->nr_frags; i++) {
>   			skb_frag_t *frag = &sinfo->frags[i];
> @@ -2007,19 +2007,19 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
>   
>   	prog = rcu_dereference(rq->xdp_prog);
>   	if (prog) {
> -		struct xdp_buff xdp;
> +		struct mlx5e_xdp_buff mxbuf;
>   
>   		net_prefetchw(va); /* xdp_frame data area */
> -		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
> -		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
> +		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
> +		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
>   			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
>   				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
>   			return NULL; /* page/packet was consumed by XDP */
>   		}
>   
> -		rx_headroom = xdp.data - xdp.data_hard_start;
> -		metasize = xdp.data - xdp.data_meta;
> -		cqe_bcnt = xdp.data_end - xdp.data;
> +		rx_headroom = mxbuf.xdp.data - mxbuf.xdp.data_hard_start;
> +		metasize = mxbuf.xdp.data - mxbuf.xdp.data_meta;
> +		cqe_bcnt = mxbuf.xdp.data_end - mxbuf.xdp.data;
>   	}
>   	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
>   	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, metasize);
