Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B884D852E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiCNMq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiCNMq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:46:27 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C18D1F636;
        Mon, 14 Mar 2022 05:38:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qt6so33533710ejb.11;
        Mon, 14 Mar 2022 05:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DHDXfguQf/+0V20Zk/mruH8iTYp9EnY9SZujr9Uh8qY=;
        b=TKtBFa9ixDzFuEWiW6FvgilF1e6EJ1hdGIdyPqxyN9AbC1VUQ7PQFZmTXSJ063AbOe
         Dkk9eSZAeu27C2tw3g164G7EfPumW080ea1Ly0r5Ew6T96agB942zrX5oJ1T57zTvV4O
         fxnkhkzo6Pe3kPzU5Ak2Xuupjvv0ddjwLmJbA6BDLGtEj2XSQG97d26kQ/NcLoCnzcfH
         xAuTFqS7RbJHAqtqErj7Wrxm+t+ba6E8vhko0zL6fILBsjULIg2tM6A/7JD75cwhWb0A
         j5+8XEIRebN08xSz5toCWQhpK9Gra8IsDrVV4CoLTM1ls8O6LJiiLFf6nMsRhcgMb5MX
         Fphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DHDXfguQf/+0V20Zk/mruH8iTYp9EnY9SZujr9Uh8qY=;
        b=nlR/4zlyjIwGJcIRBdluUGmpbFSXURDyBhlI9GFHZsXCL3LLSLt/ywhGA61SzWf0Q3
         UPbhejpdTUIUT6iBSl7SI0nJv4kN/li8F8sveBLNvDFGSmwA7ihxJaUJeHwxlBzitQ0m
         7kRP8cm2sY8UK/KdCWkG0LAldSb/eKVa12YAAli66VfUZ6Wm/nYeTis5GH4ptenXP8oF
         i8PP7/Ioc5ouXv4mvI2YLWXjmnZDQN4hnyAHJmr1frsomzKm3BcZOwGRpI/Gx0P+15NU
         m50c7ObbKa2B/hhisdf7FLM2FT+Go2QRTgJVkFleuiwepY4wqC6cxdKTo8q4e4VsFa8X
         9S4g==
X-Gm-Message-State: AOAM533hMyu3vF1GZ65Oc8irZFPuNOG76/FYJxmDopYYJT4XKGMmr5GC
        1K9nGEi9T9GnO5Py1/umAVg=
X-Google-Smtp-Source: ABdhPJxwELyfsQSJTNq8Sa1l7yiWAs9D0dHvQGP4T1HLkCTbCN50lBERRClcm7Ub9FPMyHuRg9NoSw==
X-Received: by 2002:a17:907:6d82:b0:6d6:da31:e542 with SMTP id sb2-20020a1709076d8200b006d6da31e542mr18590966ejc.135.1647261452616;
        Mon, 14 Mar 2022 05:37:32 -0700 (PDT)
Received: from [192.168.1.116] ([77.124.29.183])
        by smtp.gmail.com with ESMTPSA id k7-20020aa7c047000000b004132d3b60aasm7821888edo.78.2022.03.14.05.37.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 05:37:32 -0700 (PDT)
Message-ID: <66fa1399-cc4b-8bdc-d4bc-ed9befe1803e@gmail.com>
Date:   Mon, 14 Mar 2022 14:37:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 2/6] net/mlx4_en: use kzalloc
Content-Language: en-US
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220312102705.71413-1-Julia.Lawall@inria.fr>
 <20220312102705.71413-3-Julia.Lawall@inria.fr>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220312102705.71413-3-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/12/2022 12:27 PM, Julia Lawall wrote:
> Use kzalloc instead of kmalloc + memset.
> 
> The semantic patch that makes this change is:
> (https://coccinelle.gitlabpages.inria.fr/website/)
> 
> //<smpl>
> @@
> expression res, size, flag;
> @@
> - res = kmalloc(size, flag);
> + res = kzalloc(size, flag);
>    ...
> - memset(res, 0, size);
> //</smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 8cfc649f226b..8f762fc170b3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -1067,7 +1067,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
>   	struct mlx4_qp_context *context;
>   	int err = 0;
>   
> -	context = kmalloc(sizeof(*context), GFP_KERNEL);
> +	context = kzalloc(sizeof(*context), GFP_KERNEL);
>   	if (!context)
>   		return -ENOMEM;
>   
> @@ -1078,7 +1078,6 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
>   	}
>   	qp->event = mlx4_en_sqp_event;
>   
> -	memset(context, 0, sizeof(*context));
>   	mlx4_en_fill_qp_context(priv, ring->actual_size, ring->stride, 0, 0,
>   				qpn, ring->cqn, -1, context);
>   	context->db_rec_addr = cpu_to_be64(ring->wqres.db.dma);
> 

Thanks for your patch.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

