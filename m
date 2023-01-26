Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69F367D697
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjAZUlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjAZUle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:41:34 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A062DE63
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:41:32 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so4044756wma.1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zyt4/66kcmx0D8t+eK4BTAUUiN+c7StU5dV40A8x/AM=;
        b=qLBU/WLlMffIk5vzbANluis+9ZDViPz7FORSnWMX31iRBgznM6ZA6nuEYvo5MS6VoF
         fhQqoA5Ef/tG/j2M1O3VWBTHYG5u472kHqt30Y8Ycf9yhpTatNLTdjzETFIPa3W5NbXi
         /2OflGoaSVkWR5xUZ+j5f7EfgCsPbWTPrM/iSk45MTFHm2HBDTN0McBvYmfbDauU1C9T
         pnJzS3KIO/vi/wtazbEXisOngHioXayRtX2Vru5S+6xvED6VA/0fZfNgj68HRsWJhHN7
         vNrAGkybeFBcFjRj8fw1FWRXg2q8cdFvD666BghtO8kk382QbLHFi9wVDfC9QlLz9cCR
         pRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zyt4/66kcmx0D8t+eK4BTAUUiN+c7StU5dV40A8x/AM=;
        b=ByifRwoaV8y7XALC7srI6tzWmWOHzApJ2cEGsmmYv8PY7kF4JYgbaX91Vw5mXYwLH7
         qIQFmxVlTG+NpOeTEzzDMEOwaD8Z7/hbIA0Z2sc4DKmO3FChObyyOhQl1UJ7ws5AublQ
         Yon/RyS+OSSrbYZDDVsKHXhLYvFE0Q5mf/KMLwMuexUY3Iq6b+NBtvnVAeVYWZViDZBw
         vLRYsgttmF/rzjHtT6ii3IZY8y9criSIsxHZE8vo/P+dr3rjioUFsNTmTnOwtk66LnPX
         t0eb9oi4O59u45XVGD/xtoX2G4NIpND8bbjeh089Zi4DfBvEiD8LslYWhjoDkbiWp57L
         WG1g==
X-Gm-Message-State: AFqh2kpO0fbMBt8Tn5KUeimXiHYo6LeecQmOn94VDajtujjz/Z5wDbVx
        FqiwWsr/+uFVDNvdjcCSXTA=
X-Google-Smtp-Source: AMrXdXuvSLNlUW5lNGuEYJ4Zt24nwiqjMA1C1HW6Zl7kUN8x2BVEjthwKsDpU6OZAsxyq6ERaadVuA==
X-Received: by 2002:a05:600c:3582:b0:3d3:5c21:dd94 with SMTP id p2-20020a05600c358200b003d35c21dd94mr34304378wmq.9.1674765691417;
        Thu, 26 Jan 2023 12:41:31 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c511100b003dc0d5b4fa6sm12357784wms.3.2023.01.26.12.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 12:41:30 -0800 (PST)
Message-ID: <25a72690-6cae-bc7b-b30c-a0ece4fa0393@gmail.com>
Date:   Thu, 26 Jan 2023 22:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi
 buffer
Content-Language: en-US
To:     Maxim Mikityanskiy <maxtram95@gmail.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230126191050.220610-1-maxtram95@gmail.com>
 <20230126191050.220610-2-maxtram95@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230126191050.220610-2-maxtram95@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/01/2023 21:10, Maxim Mikityanskiy wrote:
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
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index abcc614b6191..cdd1e47e18f9 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -576,9 +576,10 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
>   }
>   
>   static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
> -			     struct mlx5e_rq *rq)
> +			     struct mlx5e_rq_param *rq_params, struct mlx5e_rq *rq)
>   {
>   	struct mlx5_core_dev *mdev = c->mdev;
> +	u32 xdp_frag_size = 0;
>   	int err;
>   
>   	rq->wq_type      = params->rq_wq_type;
> @@ -599,7 +600,11 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>   	if (err)
>   		return err;
>   
> -	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
> +	if (rq->wq_type == MLX5_WQ_TYPE_CYCLIC && rq_params->frags_info.num_frags > 1)

How about a more generic check? like:
if (params->xdp_prog && params->xdp_prog->aux->xdp_has_frags)

So we won't have to maintain this when Stridng RQ support is added.

> +		xdp_frag_size = rq_params->frags_info.arr[1].frag_stride;

Again, in order to not maintain this (frags_info.arr[1].frag_stride not 
relevant for Striding RQ), isn't the value always PAGE_SIZE?

Another idea is to introduce something like
#define XDP_MB_FRAG_SZ (PAGE_SIZE)
use it here and in mlx5e_build_rq_frags_info ::
if (byte_count > max_mtu || params->xdp_prog) {
	frag_size_max = XDP_MB_FRAG_SZ;
Not sure it's worth it...

Both ways we save passing rq_params in the callstack.

> +
> +	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
> +				  xdp_frag_size);
>   }
>   
>   static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
> @@ -2214,7 +2219,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>   {
>   	int err;
>   
> -	err = mlx5e_init_rxq_rq(c, params, &c->rq);
> +	err = mlx5e_init_rxq_rq(c, params, rq_params, &c->rq);
>   	if (err)
>   		return err;
>   
