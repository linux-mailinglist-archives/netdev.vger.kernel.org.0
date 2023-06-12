Return-Path: <netdev+bounces-10129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E9C72C6BB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB6B228113B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D226719E49;
	Mon, 12 Jun 2023 13:59:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A0D10797
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:59:54 +0000 (UTC)
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F571994
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:59:28 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-19fa4346498so2372573fac.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686578367; x=1689170367;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vgqXN9wjdl2WWF703N9tjxJZOrqi0sS6TzVmhRwMPj4=;
        b=uC/m4uh5+/bLnrZ//C+Z12hSW2+CB/KrRNjT7KenHMG/1ccuPpxGzAsPsCuNftjmZv
         w+NujN/AGoG56vHzlgKgRauft8k9mBULXW5RxGMj7YKvwXOfo+bPZwLzEabAeyG0LgZM
         8vzN0XWUtCFFlRI08GoeTRZ1EtPV9HUpoXRgmoEjqwUjLv6n8PyVqWH+8vU/eAn8rH/Q
         wShi3oidk8dpcpgzfAI2OTcIP7PswpFSObpUu/xAW2ajJ2olm117NRwm1iKw6GlTUySu
         dsG52uvLL23CYEf5AKDLEW5T4D+XwhWec0xPZ5VJ70lPDuSobmqnN1VnwubEhVgvTOfQ
         KhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686578367; x=1689170367;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vgqXN9wjdl2WWF703N9tjxJZOrqi0sS6TzVmhRwMPj4=;
        b=bMCFfNf+bVqKkw6HtTl1YZTPqvYQtztdGAg2RXmsP/Y0lgykME5rvuJaCshRGII9ue
         fel9ZmzeFd77q45KJcAlLdOzQg1E6BHEbl4ziOAwEZefHbfzhCuW/GxmBXlRC1LVoqBT
         sgqcmRm6S9eDAZwMiFbz5Ma0F9U6nJyOPGvc7DHHLgLSj7EpI6RdWyen+aCtv2NWpPBv
         owuprQ4ZlAOfImSBOhFpt7Y0iRaFmLfTciZ+TVZwT5FY+0VyeFsqHTX88ifCIMEqjLzd
         OeMcoDcCJVHIREljTnO3bLlkM8FTp/gQOzX0eIM4jFkSPfu4FkDtA/Q5q2S/IRK9XfIL
         KnSg==
X-Gm-Message-State: AC+VfDx8dMvAHNeQjjEBPz96+jjh3p3Z5pcdU407dWUSMM3MLbugXSEp
	CaRBwYDoedXSEA1KUrBPKHvGsA==
X-Google-Smtp-Source: ACHHUZ6iHdXhzVw7fkFY5nRosK2HBFW56YRTVJAISJMi0dnqquw9R7SE096QcXcR7r8eydJFIn7qlg==
X-Received: by 2002:a05:6871:3d2:b0:1a6:4920:d32d with SMTP id a18-20020a05687103d200b001a64920d32dmr3911206oag.42.1686578367371;
        Mon, 12 Jun 2023 06:59:27 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:5ac6:7609:9e55:394c? ([2804:14d:5c5e:44fb:5ac6:7609:9e55:394c])
        by smtp.gmail.com with ESMTPSA id gb18-20020a056870671200b0019ed407a72esm1538408oab.16.2023.06.12.06.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 06:59:26 -0700 (PDT)
Message-ID: <bf500fa8-b835-b697-7fa6-d9087219fa35@mojatatu.com>
Date: Mon, 12 Jun 2023 10:59:21 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net/sched: cls_api: Fix lockup on flushing explicitly
 created chain
To: Vlad Buslov <vladbu@nvidia.com>, pabeni@redhat.com, davem@davemloft.net,
 kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, renmingshuai@huawei.com
Cc: netdev@vger.kernel.org, liaichun@huawei.com, caowangbao@huawei.com,
 yanan@huawei.com, liubo335@huawei.com, simon.horman@corigine.com
References: <20230612093426.2867183-1-vladbu@nvidia.com>
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230612093426.2867183-1-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 12/06/2023 06:34, Vlad Buslov wrote:
> Mingshuai Ren reports:
> 
> When a new chain is added by using tc, one soft lockup alarm will be
>   generated after delete the prio 0 filter of the chain. To reproduce
>   the problem, perform the following steps:
> (1) tc qdisc add dev eth0 root handle 1: htb default 1
> (2) tc chain add dev eth0
> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
> (4) tc filter add dev eth0 chain 0 parent 1:
> 
> Fix the issue by accounting for additional reference to chains that are
> explicitly created by RTM_NEWCHAIN message as opposed to implicitly by
> RTM_NEWTFILTER message.
> 
> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
> Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
> Closes: https://lore.kernel.org/lkml/87legswvi3.fsf@nvidia.com/T/
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>   net/sched/cls_api.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)


Hi Vlad,

Thanks for taking a look.
Could you also carry over the tdc test or ask Ren to post in a separate 
patch?

> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc..e4df96e133cd 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -659,8 +659,8 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
>   {
>   	struct tcf_block *block = chain->block;
>   	const struct tcf_proto_ops *tmplt_ops;
> +	unsigned int refcnt, non_act_refcnt;
>   	bool free_block = false;
> -	unsigned int refcnt;
>   	void *tmplt_priv;
>   
>   	mutex_lock(&block->lock);
> @@ -680,13 +680,15 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
>   	 * save these to temporary variables.
>   	 */
>   	refcnt = --chain->refcnt;
> +	non_act_refcnt = refcnt - chain->action_refcnt;
>   	tmplt_ops = chain->tmplt_ops;
>   	tmplt_priv = chain->tmplt_priv;
>   
> -	/* The last dropped non-action reference will trigger notification. */
> -	if (refcnt - chain->action_refcnt == 0 && !by_act) {
> -		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
> -				       block, NULL, 0, 0, false);
> +	if (non_act_refcnt == chain->explicitly_created && !by_act) {
> +		if (non_act_refcnt == 0)
> +			tc_chain_notify_delete(tmplt_ops, tmplt_priv,
> +					       chain->index, block, NULL, 0, 0,
> +					       false);
>   		/* Last reference to chain, no need to lock. */
>   		chain->flushing = false;
>   	}


