Return-Path: <netdev+bounces-6275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB50715798
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B87B28106E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D4C125CC;
	Tue, 30 May 2023 07:51:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCAE125BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:51:27 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08F2F0;
	Tue, 30 May 2023 00:51:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51456392cbbso8008964a12.0;
        Tue, 30 May 2023 00:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685433077; x=1688025077;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQIR5DFpp5iUilrR8vViN4w9K1Mm/gEAPWprW58oW94=;
        b=mertAjHwgLSeKppxYqHSupclimphDdYbropmfjNpp5t30+xS08obLqFKFEO4VOrwau
         OEWmo5WSdLnsGg9Mx6rJ+56p5XZ/h7AOgWdeg7zi1CHSHBh/KSiBNs3V/g1lCSwrWOCi
         0pQWXTu5KdNkhT0Xp5+JwWjD0jkJ5p4ui1ISTOwuR3+ByqqsePBzbNweKpRlRV22Bofu
         aVTeKZmMcQBwtQg+6crMQF7Dsus+IITZ0ebiaYYaEnvW9Advum10LZ5fjKW4vXJVv+C1
         l+t8yG/6saaeQqsaDZCqzR2vlCSBSl7ys21Jyv9KnWTYKAi4vK0L3vuR5O1dhyMt/8NK
         9tuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685433077; x=1688025077;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQIR5DFpp5iUilrR8vViN4w9K1Mm/gEAPWprW58oW94=;
        b=klQdASec1ZFLJYA5zqYop/JHVvv43/ZttH3KuDYhh4GDkhJq9efwEsjsOE7UmIVu66
         v5b0LPMISrZ/IcEampY2OeB+6g36h/PNPa+Sllp0ZHr5sxMNEb5zS5i4H9mTQlDUjEYu
         ZyU8Szp6LQEUawmz+ehnbz4NjIdtwAOLUP/g31DagBYlmuS8edtw0g5MiJet0FJEtyJr
         WusgEHX6ZPtva+EMviy5FWua9bA9pWqtiAYXxJiSeJ7dvGAgQygYwmvGniXHVUgNmU+v
         XOxTOD6ke/V3DDKwNzRnU7gEEq7ldYFl/wyvCNIHvaKy50woH3d+Z8++FJdgkIxya1qr
         F80A==
X-Gm-Message-State: AC+VfDyWLn8DEu7AVFWSwjNasEV6F4QUh6BhcV1UJskrL3g8dHHfJhuQ
	COwbBkCWhpeROMKVSqM/hYw=
X-Google-Smtp-Source: ACHHUZ5mI5B0095JkBMcm/CSudhY8cevl2alHRTR43ikC7Z50gjwwnwyxdYxAtOQV609Kvk+FU2v3w==
X-Received: by 2002:a17:907:930c:b0:973:7096:60c2 with SMTP id bu12-20020a170907930c00b00973709660c2mr9048421ejc.20.1685433077052;
        Tue, 30 May 2023 00:51:17 -0700 (PDT)
Received: from [192.168.0.107] ([77.124.85.177])
        by smtp.gmail.com with ESMTPSA id h27-20020a170906111b00b00969cbd5718asm6907261eja.48.2023.05.30.00.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 00:51:16 -0700 (PDT)
Message-ID: <3e154812-3306-1d04-e7d7-9d1f5aef60b6@gmail.com>
Date: Tue, 30 May 2023 10:51:13 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] net/mlx5e: Remove a useless function call
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>
Content-Language: en-US
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <fc535be629990acef5e2a3dfecd64a5f9661fd25.1685349266.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 29/05/2023 11:34, Christophe JAILLET wrote:
> 'handle' is known to be NULL here. There is no need to kfree() it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
> index 0290e0dea539..4e923a2874ae 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
> @@ -112,10 +112,8 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *po
>   	int err;
>   
>   	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> -	if (!handle) {
> -		kfree(handle);
> +	if (!handle)
>   		return ERR_PTR(-ENOMEM);
> -	}
>   
>   	post_attr->chain = 0;
>   	post_attr->prio = 0;

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.

