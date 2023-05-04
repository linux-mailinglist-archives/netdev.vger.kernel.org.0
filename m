Return-Path: <netdev+bounces-332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAE56F71DE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B960280D94
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344FCBE6C;
	Thu,  4 May 2023 18:21:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EBDBA36
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:21:31 +0000 (UTC)
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A9F6A72
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:21:29 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-192adab8f0eso738923fac.2
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 11:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683224489; x=1685816489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cH146kBq5tGDwGlMfHStcSePjRBn5Pd4S2x8wbLQlaA=;
        b=1gJ1XEIMcqlAkxjfgvUrA6rTDoVRyPif8+JJEPG0qupdPvQ8YfpR0OWpNTbrOViOBu
         TR/3Zo8mlLk4OGSFMIe8q5kT4dICBx9EalYrcsXVmp42MasWn8zWU4f+qvkBdky9ZJhF
         dKzH6WOqlmMvXOR6P04yGL48SH+y6TqB8rq38nDcTcb9vy2iq2Wg2lYkuPGiuTP0UfTK
         vPQUDaBEHys5ejsk24YfcOFdk9AIYVdy10z24RH2jQQts3Ln1EVLqxDwKwOAoMHV9nh4
         T2b7SkVkwMCYbTI9q4oNgP6cTuGGVhLNXNAEV8IHBL+UlO3GRXIF3BMSs7txuLbZbWOZ
         ohTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683224489; x=1685816489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cH146kBq5tGDwGlMfHStcSePjRBn5Pd4S2x8wbLQlaA=;
        b=N7RIIpr828q4vHCG+qapfDdC3pe4ZdSR7AKAhzNgcLCCtHhDQldVrEaxVdIKLYrAhh
         wd8wj2kWxfBlrM2uQEkFvMAbVWzIuaJba+Pzjlxfr2mX45jmV1urFj2Q9SSa5uiSTGcE
         CeSjAxadKb1BDAGKzJKk5KNiWcUj1u6/KK02xYa8yMFxeOQck7SeFjptOuuWV4uP0laZ
         iIfpuLiS/tQeL+OTP1LJDU9OG7FPhe6uOvt7Aql5pUArdqjoKvsXwpnzw35h4QEQupCi
         MVgLsObSUGK76Zwhh1cR314jc02QCDNTQfTkgGhkA5o/HUK6NaKoxIJ4fphRKYfwxhOz
         4jJA==
X-Gm-Message-State: AC+VfDx/ma6Ei8zRN1+lpF8IJSD68avN/SXuvwetKthk2nD8qLya2sh5
	q5xaV3gy4cBpAtAe+4a8WREgAZvNv7ragDnaJaU=
X-Google-Smtp-Source: ACHHUZ5HsppDh9Vk6jRjs/fJMT777FkTNKvx61UjfWZl8yu8zoywscMeFz9eM20JH4XdI7ItEfoMRw==
X-Received: by 2002:a05:6870:4504:b0:17e:a21c:8983 with SMTP id e4-20020a056870450400b0017ea21c8983mr1094772oao.57.1683224489083;
        Thu, 04 May 2023 11:21:29 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:1f7c:197f:18de:768b? ([2804:14d:5c5e:44fb:1f7c:197f:18de:768b])
        by smtp.gmail.com with ESMTPSA id o5-20020a05687072c500b00183f77dcdadsm901727oak.33.2023.05.04.11.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 11:21:28 -0700 (PDT)
Message-ID: <32445b61-a0f9-4211-5784-1285188a3ecf@mojatatu.com>
Date: Thu, 4 May 2023 15:21:24 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2 3/3] net/sched: flower: fix error handler on
 replace
Content-Language: en-US
To: Vlad Buslov <vladbu@nvidia.com>, pabeni@redhat.com, davem@davemloft.net,
 kuba@kernel.org
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, marcelo.leitner@gmail.com, paulb@nvidia.com,
 simon.horman@corigine.com, ivecera@redhat.com
References: <20230504181616.2834983-1-vladbu@nvidia.com>
 <20230504181616.2834983-4-vladbu@nvidia.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230504181616.2834983-4-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 04/05/2023 15:16, Vlad Buslov wrote:
> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
> new filter to idr is postponed until later in code since handle is already
> provided by the user. However, the error handling code in fl_change()
> always assumes that the new filter had been inserted into idr. If error
> handler is reached when replacing existing filter it may remove it from idr
> therefore making it unreachable for delete or dump afterwards. Fix the
> issue by verifying that 'fold' argument wasn't provided by caller before
> calling idr_remove().
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   net/sched/cls_flower.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index ac4f344c52e0..9dbc43388e57 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>   errout_mask:
>   	fl_mask_put(head, fnew->mask);
>   errout_idr:
> -	idr_remove(&head->handle_idr, fnew->handle);
> +	if (!fold)
> +		idr_remove(&head->handle_idr, fnew->handle);
>   	__fl_put(fnew);
>   errout_tb:
>   	kfree(tb);


