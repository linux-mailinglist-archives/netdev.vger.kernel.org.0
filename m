Return-Path: <netdev+bounces-5114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B81470FAD2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 182DF281399
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43E219BD4;
	Wed, 24 May 2023 15:52:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C740F19BB9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:52:45 +0000 (UTC)
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A61194
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:52:31 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id a1e0cc1a2514c-7868d32ace2so812036241.3
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684943550; x=1687535550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vr8uCO2pIAbrA9U96g+r92G07hF9QBrSlMFZYQ43XME=;
        b=baTj+FozOR5l+Qj0uL8CVt2Ir3oUDFzYIgP7ypluyR4yRbA53Aj1b8d6B3g0WKhNEi
         ewxYT9+sHPv7JikPAPXuvI1acd1PxTo/M8vTWfwaHaJHgafFGBoSim4QC4OHblA4Avao
         HCmIzi0UPDeDGDfqSxBXKJsoAZ2TIM5kIiA+KCVizBch3btuDprdYEJw4TKm9ag0mnqJ
         Gq3jXLfS77vPsAhjWT2fP03V9R0QELeczgwqQfq3LZ/U66aYlXNzz+Jp0N0HmPtO8JzI
         +FuXyukFJwt0FYHbGXaKynJAv2fVEKt0Bg0LIrUw66MwFkPrpca2JEuEO14sdZ7stNRo
         XRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943550; x=1687535550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vr8uCO2pIAbrA9U96g+r92G07hF9QBrSlMFZYQ43XME=;
        b=HYCf1I9NsBVyDdD9XA8ViEuTfmwjHtEXWKFFX7x2aUb3e0BA542ZR4ZQ0coj9u5Szq
         z+LC2iAUkm74ba6BNzRpkr/6o1KTTVD7ZQfsTa/O7deAanv4T2aJDJImRi8y543qLziF
         1YXVgznugoRr583Wm12q1IG+srmoR04pFQ78Yak1DD2GZ85kM8Pxwop/BU2JjaluRnIQ
         td+G7Ksk6Vu29DsyqYXsAjdJIuz5ifQqgD+WLEtmTL6LOIOH7xfcCfxk7nHwVdGgCg8L
         iAynVnwbwVB2BhC++M1cluDwa9fFpKiuaVZ7RRzSlT6fmYdp//HMibUdJHZ8fUZMsZbg
         QHMg==
X-Gm-Message-State: AC+VfDwTbENOTdqr4AZrfv3BZFipDhJCBkSPk0U78ClHIgMO6uYqDmbf
	8LYBdsDp3qdJHKex5qFOx4vFR7Jaiw5pH0+WZ4Q=
X-Google-Smtp-Source: ACHHUZ7YzpgA/A3liP5vN/6UOehV4zB4M/eC5z+Tuzi8pVtI0+XkBPw4wgNkU6jAyL8f9PHw+1saTg==
X-Received: by 2002:a05:6870:7343:b0:192:597c:1c17 with SMTP id r3-20020a056870734300b00192597c1c17mr162453oal.7.1684942693571;
        Wed, 24 May 2023 08:38:13 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:522c:f73f:493b:2b5? ([2804:14d:5c5e:44fb:522c:f73f:493b:2b5])
        by smtp.gmail.com with ESMTPSA id r18-20020a05683001d200b006af7580c84csm3599958ota.60.2023.05.24.08.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:38:13 -0700 (PDT)
Message-ID: <5fda8703-9220-4abd-7859-0af973d0d1d7@mojatatu.com>
Date: Wed, 24 May 2023 12:38:07 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 net 2/6] net/sched: sch_clsact: Only create under
 TC_H_CLSACT
Content-Language: en-US
To: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Vlad Buslov
 <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
 <0c07bd5b72c67a2edf126cd2c6a9daadddb3ca95.1684887977.git.peilin.ye@bytedance.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <0c07bd5b72c67a2edf126cd2c6a9daadddb3ca95.1684887977.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23/05/2023 22:18, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
> equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
> TC_H_CLSACT.
> 
> Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> change in v5:
>    - avoid underflowing @egress_needed_key in ->destroy(), reported by
>      Pedro
> 
> change in v3, v4:
>    - add in-body From: tag
> 
>   net/sched/sch_ingress.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index f9ef6deb2770..35963929e117 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -225,6 +225,9 @@ static int clsact_init(struct Qdisc *sch, struct nlattr *opt,
>   	struct net_device *dev = qdisc_dev(sch);
>   	int err;
>   
> +	if (sch->parent != TC_H_CLSACT)
> +		return -EOPNOTSUPP;
> +
>   	net_inc_ingress_queue();
>   	net_inc_egress_queue();
>   
> @@ -254,6 +257,9 @@ static void clsact_destroy(struct Qdisc *sch)
>   {
>   	struct clsact_sched_data *q = qdisc_priv(sch);
>   
> +	if (sch->parent != TC_H_CLSACT)
> +		return;
> +
>   	tcf_block_put_ext(q->egress_block, sch, &q->egress_block_info);
>   	tcf_block_put_ext(q->ingress_block, sch, &q->ingress_block_info);
>   


