Return-Path: <netdev+bounces-9529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAF1729A09
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F04471C2116C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC93A938;
	Fri,  9 Jun 2023 12:31:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009F1174C6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:31:01 +0000 (UTC)
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1584635B8
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:30:25 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1a28817f70bso642555fac.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 05:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686313816; x=1688905816;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OhY9F426/XZBDfWDG79w1KFjKHgE+TlbQzvvhGcm+pE=;
        b=26w7TL8p4QsaCxqNELPKZl0nf/3DIA4tnu5Z8yBaaMHQs6nJdtoL1/IJwGh8Xnqrul
         ceyIop0m88PtIMieJZNuYYbD/f2aPr+QAgKlDI4QCHaqKwiuAJdXHnqdd/Y4WTeV0kFF
         +cy/Kl06Bx5/Zyi6ieZfFwUmWxzKs65SzA7ozL6+ye7vj6isA71BUY2ZZFcRKUgRZodv
         RI2o0K3tz9AhHI4WOGQfYmNOTK61fDf27e3WzQtyXXB2KJrclrxX2QPz5GKoP1ag2Isg
         Tu+rwCSeuKR7iKJdPxkioShwiSXaONWzCieOz4ysJSPBOlZBj3CblganCvCX44cWRMdj
         aV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686313816; x=1688905816;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OhY9F426/XZBDfWDG79w1KFjKHgE+TlbQzvvhGcm+pE=;
        b=HsFxPRkhBAXO/FVjaWLYrkHkHcMut0N13yQi5yCkEzoMlqntU1qWJrNTeZ274DlrPu
         TwaxzjfhINf2rWEGMpuDjjZha7AF6LmadlF4UMa2MwExOc39dkGvlrGixYBENGjDT9Wa
         xDJYSLyjNwqMaffdeCxblLkBxraRCFRER2q99iKb4A3tLAX//A6LeWphxj+l5QtqHqS6
         jo7HyQn67YZDerjnlsejz9XQhBZvunydR5rbymIamNDtxBBJDEOMPL+bpojdpe3l4UYN
         D2IDs2d597hqhGefVLGJ7OUlu4xJ4AHpcInA75/t/5hY1qbitI6g1WxWpsFeDPBMAhfd
         JWtA==
X-Gm-Message-State: AC+VfDxEXVsBx3Iz2VP2In6MDQz+kZrSpqylfjZGjH6AiunEi4SwFRc/
	KknDFFcb5pO13hwuRkXGadxzHd9ex9/ugEc3U4c=
X-Google-Smtp-Source: ACHHUZ5kvGC2hn93mlIb6ZW+E9FVsA6MSceqqKR66gjoxU7/dFds2zwbY1SlKYDD2PJoR8QyPj03Ww==
X-Received: by 2002:a05:6870:e282:b0:19f:5c37:ab9d with SMTP id v2-20020a056870e28200b0019f5c37ab9dmr1164399oad.43.1686313816386;
        Fri, 09 Jun 2023 05:30:16 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:643a:b27d:4a69:3b94? ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id p14-20020a056870a54e00b0017b21991355sm2052528oal.20.2023.06.09.05.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 05:30:16 -0700 (PDT)
Message-ID: <ce770d0f-20b4-8040-8625-365758351998@mojatatu.com>
Date: Fri, 9 Jun 2023 09:30:11 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net/sched: act_pedit: Use kmemdup() to replace kmalloc +
 memcpy
Content-Language: en-US
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, jhs@mojatatu.com
Cc: xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20230609070117.100507-1-jiapeng.chong@linux.alibaba.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230609070117.100507-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/06/2023 04:01, Jiapeng Chong wrote:
> ./net/sched/act_pedit.c:245:21-28: WARNING opportunity for kmemdup.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5478
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

LGTM,

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   net/sched/act_pedit.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index fc945c7e4123..8c4e7fddddbf 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -242,14 +242,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>   	nparms->tcfp_flags = parm->flags;
>   	nparms->tcfp_nkeys = parm->nkeys;
>   
> -	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
> +	nparms->tcfp_keys = kmemdup(parm->keys, ksize, GFP_KERNEL);
>   	if (!nparms->tcfp_keys) {
>   		ret = -ENOMEM;
>   		goto put_chain;
>   	}
>   
> -	memcpy(nparms->tcfp_keys, parm->keys, ksize);
> -
>   	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
>   		u32 offmask = nparms->tcfp_keys[i].offmask;
>   		u32 cur = nparms->tcfp_keys[i].off;


