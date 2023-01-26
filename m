Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2A67D69B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbjAZUnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjAZUnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:43:08 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB0F5954A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:43:07 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o17-20020a05600c511100b003db021ef437so1985178wms.4
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UtYmz1Hqejl2t30Z3uGKI8KTYHLhehfRh45B7U5gE9w=;
        b=SSenLVb/CkhQoYfJC4Mkjqds2u1SlYSa9zu69ZoxAGujMOxuBz1a65+/6esQZ5TcPM
         i+M2KaRQILmLiAejgpnn7WoSxDUlXxD11B0IxnINNUJTUqAgVQHRNITSTyG9WBic3R6S
         pinr71QMfGyu6o0Uo4PnBhRTdcxHhLTbT+hL3D8DcchiRQP3rXjjM1c8WcVwN/JimvoG
         VWvi/nA1xfXUer4uHiQbWZTe/u5x13QbhVp+7ZbMYxEK9mnukx15lLNJG7c02uM5/Ege
         AUzHh18haYp3QhOzet2GjG+Pv0TJnmH3gEdeJnig5hCQH8/FHxPjr7XAGPYhAj3BAJnR
         w/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtYmz1Hqejl2t30Z3uGKI8KTYHLhehfRh45B7U5gE9w=;
        b=POWsZRYAJVpfGsU65awsqoI6z4hQ85Q+WICOXLOMH+S6EY9NhOLBX8dKfnnQAqHRqG
         gE9K72KIw7DVtwAs0HsCkO7Gr+Sua2XwnqBiKD62L4kKIqqWcknIpbkkgXyZXjG5r/wA
         QKNa/lVSeBzWJ0xIBB9P8Mgev5VTz+03qziaqpytxPpqHEzpTnjsKvhkjedIalHrPWQS
         jphtX+hpUP+GPExfQdn80yRR0ykncMdKrBoubo9Cj+r8TU/UyLS3rbFsSya5YPK37KfP
         OeVXcqXGvslK8YVALTNfiYgT7blEGK5mfbJ71x9XqOMWBZcgW+zoC2TwmTXaJDUW5Jds
         lMJw==
X-Gm-Message-State: AO0yUKWd+wYA09jOtTe1+ARJdtCmUkCdljUzJtGJMsyyWwFXc2Av28IK
        LGOTonFuJxBT2+EUj2ZKTDM=
X-Google-Smtp-Source: AK7set+mEgVN+XFM07r6p1peQvhuHfHuNxptQolaWmzOVLH8M4pgTIgcCWbIFoOd4yHgO/y3YN7Z5Q==
X-Received: by 2002:a05:600c:4fc6:b0:3dc:1f90:35b with SMTP id o6-20020a05600c4fc600b003dc1f90035bmr6563733wmq.34.1674765786359;
        Thu, 26 Jan 2023 12:43:06 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id a13-20020adfeecd000000b002bbedd60a9asm2099162wrp.77.2023.01.26.12.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 12:43:05 -0800 (PST)
Message-ID: <00702df8-5e7b-6177-90c8-e40570245f9f@gmail.com>
Date:   Thu, 26 Jan 2023 22:43:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/2] net/mlx5e: xsk: Set napi_id to support busy
 polling on XSK RQ
Content-Language: en-US
To:     Maxim Mikityanskiy <maxtram95@gmail.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230126191050.220610-1-maxtram95@gmail.com>
 <20230126191050.220610-3-maxtram95@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230126191050.220610-3-maxtram95@gmail.com>
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
> The cited commit missed setting napi_id on XSK RQs, it only affected
> regular RQs. Add the missing part to support socket busy polling on XSK
> RQs.
> 
> Fixes: a2740f529da2 ("net/mlx5e: xsk: Set napi_id to support busy polling")
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> index ff03c43833bb..53c93d1daa7e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> @@ -71,7 +71,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
>   	if (err)
>   		return err;
>   
> -	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
> +	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, c->napi.napi_id);
>   }
>   
>   static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks for your patch!
