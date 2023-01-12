Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB7666C18
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 09:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbjALIHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 03:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbjALIH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 03:07:28 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23048831;
        Thu, 12 Jan 2023 00:07:25 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z11so25769436ede.1;
        Thu, 12 Jan 2023 00:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CbhF/nnSJPwM2+rbbAW9sDr9asQP06rO56ZNRMmJ5Fk=;
        b=N5FTNt+xG/Sz+q4+gZzkgbPaTj84jHnLeFwdrg5xGbgmr+D9/choE46LyGuu7MisoH
         tgXpWFC7koZU74la0/dgGXayzalbQBa3FaugpO2knQK5KmXR+n/053VCza+ROzE9h1PH
         +JBeTLatPN/v1wUYAlTTOGnDPH5RMu9Gf59kxa55aTuelr/qBmh79kztbW/9/Rwg4q1J
         TYHi0vPxQUXaij0Sw5+7AQd+44ZXn/1GEuK99pfCdwa5vru4eDQN6SrpSsJO6n20caJ8
         ZyeDTsDYz1BJUeYoTvQnVKNc8Dvg+9AvgdxInxlH9OaELRfVPX+pZqBCRNjCq4SC2OC6
         EQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbhF/nnSJPwM2+rbbAW9sDr9asQP06rO56ZNRMmJ5Fk=;
        b=d/zUjD6CCF/Xvj6Wl4TdjjE1db1Zs29LzEfKO/1PmdThstuSzV5eR7vAnmUNrHoUw1
         Vq6vU6kLcGQ582EopNxeUjLXEYp23PO8p5/lySnxkUuOvTF3wyRn2e73t8CJLu2UvycQ
         fgCEJ7o+V+ziwNaF7mOFhI/eNHNqZQE+8nq/vngLPyDI3Chv2Yz2ehchAvQjamYINkCY
         xAJ82VZ1ubTThWJkcMum4kzskNwi3Onu17CLrQqdi1Wg08GqTjDxGWnE37+VgEWggk21
         YlsPDtND80o1g3QDK4AdpxZB0TYN3X4L9m7TF48SAZ0v3FydqOG0Vh7CcSAw8qi6OTuy
         +1ew==
X-Gm-Message-State: AFqh2krAt47GFJ1UsfmlF/4Kf5Rlws218ARwScfyyxQGHgG03WZ9XC+S
        jJ0IHyiCnFZj3Fg1KYOqqvA=
X-Google-Smtp-Source: AMrXdXtGiYH6c1xl+TLPb2WFGew1k2Hk3MAWLvnj/C29vnxGb6+FKKPkbK0tBRDrW+CK7RCnlri0rw==
X-Received: by 2002:a05:6402:528c:b0:48e:c073:9453 with SMTP id en12-20020a056402528c00b0048ec0739453mr30507056edb.15.1673510843900;
        Thu, 12 Jan 2023 00:07:23 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906201100b007bff9fb211fsm7051222ejo.57.2023.01.12.00.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 00:07:23 -0800 (PST)
Message-ID: <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
Date:   Thu, 12 Jan 2023 10:07:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce wrapper for
 xdp_buff
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
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
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230112003230.3779451-16-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/01/2023 2:32, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Preparation for implementing HW metadata kfuncs. No functional change.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
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
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++----------
>   5 files changed, 50 insertions(+), 43 deletions(-)
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

In XSK files below you mix usage of both alloc_units[page_idx].mxbuf and 
alloc_units[page_idx].xsk, while both fields share the memory of a union.

As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just 
need to change the existing xsk field type from struct xdp_buff *xsk 
into struct mlx5e_xdp_buff *xsk and align the usage.

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
> index c8820ab22169..6affdddf5bcf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1575,11 +1575,11 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
>   	return skb;
>   }
>   
> -static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
> -				u32 len, struct xdp_buff *xdp)
> +static void mlx5e_fill_mxbuf(struct mlx5e_rq *rq, void *va, u16 headroom,
> +			     u32 len, struct mlx5e_xdp_buff *mxbuf)
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
> +		struct mlx5e_xdp_buff mxbuf;
>   
>   		net_prefetchw(va); /* xdp_frame data area */
> -		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
> -		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp))
> +		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
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
> +	mlx5e_fill_mxbuf(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf);
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
> +		mlx5e_fill_mxbuf(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
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
