Return-Path: <netdev+bounces-5111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5CB770FAC6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A99941C20DEE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BCB19BCE;
	Wed, 24 May 2023 15:51:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57A819BAA
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:51:54 +0000 (UTC)
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C1B97
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:51:52 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-78676ca8435so2162252241.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684943512; x=1687535512;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FiwwEzM2zwzPOa0pdz6xPz0Iuhy4Xj5GAVQ6YsEKRa0=;
        b=EY/xKqS2oifl3or1piv5Rw3hVJ6OCcjFYHn2Y7o3tRIAwlm1z8nO89808wXHwDOvGA
         WefGvvZ4b1t9ZOgejt1uKoKUx0FWybDETrOvR6/CM7D4myYTrlxKPUJEAo+hcxnoHgDa
         UCAO4jfRCasAcZG52bIkh5nIZ4WnLMtBOvzS9PQNVDAROIOAVOFXJL9MMHAAC8YlIDVS
         GJsRmSuRWgQxs6ws8feBz1Na2qT2rmN+ofOxGc6I7+GeumAZyDDoX7lR3Srmz+WdBCRo
         +oq7FolrktDT0/m0cp3FXw1SgQ/AsO+eaylElolVVIUhzdtAcS+vDeICW8f5kLcwo/4t
         ppoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943512; x=1687535512;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FiwwEzM2zwzPOa0pdz6xPz0Iuhy4Xj5GAVQ6YsEKRa0=;
        b=ThhG0LUacdc+AAUzwb//TbU8swqya62BHm3UkI1bJaEMS+2lwYSgs51llnFSSw9QP/
         chQcmhXnxPFkYs6TxL8bzlz+cvg0221i77mveAP1BTKmTUnBiTI9aSpq2HHM6nCA3IKT
         uUlRFjO63UF9qGe1YRiHd2bE+7NNpyTsoyuaE3ZSXhekJO4NmwdAsN1cTa1BKxthmLuo
         tb2+Do6IPW1LG/BLf9Q/OzgtW/dlAUk3Lw7/3/HWF1hkRbkomrkYJTWpUpErMls7swSR
         Z4fESZRT7KMKVRuIXqw9m/MyV/f2+0ebdMKY5KClO+Sy0AM/kFBdpWaQP1isyp9MYNcl
         1LJw==
X-Gm-Message-State: AC+VfDyWYnzGMpF0bPFg3TAaXv599n7l3/JdijUkfxquAltvmENLTK8H
	S2QX9ADFb2HSyxIVpovaK9fMON/rvVHToVv06m4=
X-Google-Smtp-Source: ACHHUZ7lQhfwy/GTTooW+vutbJghj2N0BwAcdPNN2blNsQcLRkIgxuJpMGelWZNCNZSVpSGxVD9rXg==
X-Received: by 2002:a05:6808:5da:b0:398:1304:5bf0 with SMTP id d26-20020a05680805da00b0039813045bf0mr4328839oij.10.1684942670007;
        Wed, 24 May 2023 08:37:50 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:522c:f73f:493b:2b5? ([2804:14d:5c5e:44fb:522c:f73f:493b:2b5])
        by smtp.gmail.com with ESMTPSA id bh24-20020a056808181800b0038eeba6fce1sm5003983oib.55.2023.05.24.08.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:37:49 -0700 (PDT)
Message-ID: <f261171c-7915-fc0d-84f1-4d7827c43119@mojatatu.com>
Date: Wed, 24 May 2023 12:37:44 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 net 1/6] net/sched: sch_ingress: Only create under
 TC_H_INGRESS
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
 <b0dcc6677248210348f08d9cb4e93013e7c95262.1684887977.git.peilin.ye@bytedance.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <b0dcc6677248210348f08d9cb4e93013e7c95262.1684887977.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23/05/2023 22:17, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
> Return -EOPNOTSUPP if 'parent' is not TC_H_INGRESS, similar to
> mq_init().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> change in v5:
>    - avoid underflowing @ingress_needed_key in ->destroy(), reported by
>      Pedro
> 
> change in v3, v4:
>    - add in-body From: tag
> 
>   net/sched/sch_ingress.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 84838128b9c5..f9ef6deb2770 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -80,6 +80,9 @@ static int ingress_init(struct Qdisc *sch, struct nlattr *opt,
>   	struct net_device *dev = qdisc_dev(sch);
>   	int err;
>   
> +	if (sch->parent != TC_H_INGRESS)
> +		return -EOPNOTSUPP;
> +
>   	net_inc_ingress_queue();
>   
>   	mini_qdisc_pair_init(&q->miniqp, sch, &dev->miniq_ingress);
> @@ -101,6 +104,9 @@ static void ingress_destroy(struct Qdisc *sch)
>   {
>   	struct ingress_sched_data *q = qdisc_priv(sch);
>   
> +	if (sch->parent != TC_H_INGRESS)
> +		return;
> +
>   	tcf_block_put_ext(q->block, sch, &q->block_info);
>   	net_dec_ingress_queue();
>   }


