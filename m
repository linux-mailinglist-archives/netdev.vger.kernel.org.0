Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12868241E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjAaFqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjAaFqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:46:39 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917702BF28
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:46:37 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r2so13140179wrv.7
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VYLHgOri37gs3oD/KfcmsSJ+vBk/cMS1/JvuOM2x2oA=;
        b=OH4Tki3AE8P3ulf0ZysLHBblwuVq6X85EHDzZaq+9ufEo6pQ+zvnPRGRPBX3zMBFU+
         sFjobhnErYSRHpAPbCO1eHm8KVbjbO+nia5TyNCjbETBiLDwFc3yLAogXrI4o2SddARB
         AYCLjyQ5TvfYLpI3pcogN4onKSzvSdBVecsqNF7ZAYJ/ciw+QJBjZSM+nYFvOdjSD5c7
         ZONnE1mCVQQgusgQuK4brwj6FuGKxrF+ivo3NhV3XKa6PWvpuwGJ9J4H4r/f2Wd+uPMo
         ZyGYdtriR8nJYvbI6l3/5NuXEg0L3YyxK8WXC+wIat0JPo0eCeDhs9PKQ1n54uroI4Pj
         3geQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VYLHgOri37gs3oD/KfcmsSJ+vBk/cMS1/JvuOM2x2oA=;
        b=hLkVODyY+wUlKdi9KXNfDZsbP1bWAeFmVFfx3H/e06iGtuRoMLMMa+c2v6W7sTewqJ
         Zmn/Tp22nLDDsT8GoTWR1R8WJT1+z99HKuTjUucnSFWHzkE5eSATqSXAd7A692dcqVsW
         hyDPLpglxS3/InLqa9mNmyLaHLCJ7mTpkJWaISTkIOFIcGl8fzRvt2RaOzDBKwr+a6t8
         TOBbXtOHdZNxNaA2lXYOpWWLT/dG9ziOmRTkqFWJzSwJ63bm82BVFuRd+xeNdlU5ZXj2
         XW/w/O8SB3a/W19yXpkntDDJ4qS/btgBT81sAiMh0Q7+qRqRCDhr3RKBt8LifJEdQ6IK
         PC+g==
X-Gm-Message-State: AO0yUKVBbvXQ+IZ01E6pn8YvOlOA9tsIY5n66nCLzFH+jtruxszj7jw7
        v3QHWNp/Cf3XiZPfBZ7QmKQ=
X-Google-Smtp-Source: AK7set9La7l93xVmJV2uraMT8cbu7QI6p/9UsdJgzB8ewnhLNn5WUKKtefs+sbJXSETzKlrgaF6QgQ==
X-Received: by 2002:a5d:58e9:0:b0:2bf:b65f:d144 with SMTP id f9-20020a5d58e9000000b002bfb65fd144mr21026120wrd.50.1675143995994;
        Mon, 30 Jan 2023 21:46:35 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id k4-20020a5d66c4000000b002bdc19f8e8asm13710647wrw.79.2023.01.30.21.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 21:46:35 -0800 (PST)
Message-ID: <0960cc04-5fe9-4b02-2be9-76c40c89570f@gmail.com>
Date:   Tue, 31 Jan 2023 07:46:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2 1/2] net/mlx5e: XDP, Allow growing tail for XDP
 multi buffer
Content-Language: en-US
To:     Maxim Mikityanskiy <maxtram95@gmail.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230130201328.132063-1-maxtram95@gmail.com>
 <20230130201328.132063-2-maxtram95@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230130201328.132063-2-maxtram95@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/01/2023 22:13, Maxim Mikityanskiy wrote:
> The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
> is required by bpf_xdp_adjust_tail to support growing the tail pointer
> in fragmented packets. Pass the missing parameter when the current RQ
> mode allows XDP multi buffer.
> 
> Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
> Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 9 +++++++--
>   drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 1 +
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 7 ++++---
>   3 files changed, 12 insertions(+), 5 deletions(-)
> 

Patch is much cleaner now.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> index 4ad19c981294..151585302cd1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -662,7 +662,8 @@ static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size, bool xdp)
>   static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>   				     struct mlx5e_params *params,
>   				     struct mlx5e_xsk_param *xsk,
> -				     struct mlx5e_rq_frags_info *info)
> +				     struct mlx5e_rq_frags_info *info,
> +				     u32 *xdp_frag_size)

Even when returning success, this function does not always provide value 
for xdp_frag_size.

It means that the responsibility of initializing this param is on the 
caller side. But then it gets no indication whether the function 
overwrote it or not. It works, but I prefer a different caller/callee 
communication.

I suggest that the function should provide value for xdp_frag_size on 
every successful flow. Suggestion:

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -782,6 +782,9 @@ static int mlx5e_build_rq_frags_info(struct 
mlx5_core_dev *mdev,

         info->log_num_frags = order_base_2(info->num_frags);

+       *xdp_frag_size =
+               info->num_frags > 1 && params->xdp_prog ? PAGE_SIZE : 0;
+
         return 0;
  }


>   {
>   	u32 byte_count = MLX5E_SW2HW_MTU(params, params->sw_mtu);
>   	int frag_size_max = DEFAULT_FRAG_SIZE;
> @@ -737,6 +738,9 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
>   	}
>   	info->num_frags = i;
>   
> +	if (info->num_frags > 1 && params->xdp_prog)
> +		*xdp_frag_size = PAGE_SIZE;
> +
>   	/* The last fragment of WQE with index 2*N may share the page with the
>   	 * first fragment of WQE with index 2*N+1 in certain cases. If WQE 2*N+1
>   	 * is not completed yet, WQE 2*N must not be allocated, as it's
> @@ -917,7 +921,8 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
>   	}
>   	default: /* MLX5_WQ_TYPE_CYCLIC */
>   		MLX5_SET(wq, wq, log_wq_sz, params->log_rq_mtu_frames);
> -		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info);
> +		err = mlx5e_build_rq_frags_info(mdev, params, xsk, &param->frags_info,
> +						&param->xdp_frag_size);
>   		if (err)
>   			return err;
>   		ndsegs = param->frags_info.num_frags;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> index c9be6eb88012..e5930fe752e5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
> @@ -24,6 +24,7 @@ struct mlx5e_rq_param {
>   	u32                        rqc[MLX5_ST_SZ_DW(rqc)];
>   	struct mlx5_wq_param       wq;
>   	struct mlx5e_rq_frags_info frags_info;
> +	u32                        xdp_frag_size;
>   };
>   
>   struct mlx5e_sq_param {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index abcc614b6191..d02af93035b2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -576,7 +576,7 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
>   }
>   
>   static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
> -			     struct mlx5e_rq *rq)
> +			     u32 xdp_frag_size, struct mlx5e_rq *rq)
>   {
>   	struct mlx5_core_dev *mdev = c->mdev;
>   	int err;
> @@ -599,7 +599,8 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>   	if (err)
>   		return err;
>   
> -	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
> +	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
> +				  xdp_frag_size);
>   }
>   
>   static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
> @@ -2214,7 +2215,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>   {
>   	int err;
>   
> -	err = mlx5e_init_rxq_rq(c, params, &c->rq);
> +	err = mlx5e_init_rxq_rq(c, params, rq_params->xdp_frag_size, &c->rq);
>   	if (err)
>   		return err;
>   
