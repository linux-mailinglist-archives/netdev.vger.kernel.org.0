Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB4268360A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjAaTGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjAaTGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:06:15 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7199577DA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:05:53 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-16332831ed0so20639517fac.10
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=64Qco5b7aLY11Ta0GbjPVk1CtFuDKLkAGPeJl/hlFok=;
        b=ZHa5+FyCc9+GLhEvTNzcB1qzDAc2u6uPWZc3IA6y0NOHyEANhPKrGPD69sc9NwDpJg
         QSQdWrWMdwxVGis5H1tiiwOXmwOjiLKP2RxL75JxUU3tSpWocKZTavBzvLqJVSyQ37vx
         Vq4ZjnL1UxY5nyqppjFrEuS5h2SiXclzW8SUtVZjYr7rm1MEuHmBpgonYKZaOEZ5l9f9
         m867NOPonUZiBXh6osT1RXKws+QzGzte+ft/2N/eMlkad3vtXRekuRYbxGS2WnWhVgEI
         n5Hfwqebz/1SQ3rBiQigFJ/mNiUf/pgmOY0MQzYMqTUMi8awN0c6e2Xt705xcSi0r1QC
         4F0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64Qco5b7aLY11Ta0GbjPVk1CtFuDKLkAGPeJl/hlFok=;
        b=10b3hWHtQ5YP7a5O6WllfrXM+zEhtJZ16ead/KogjRjfDGqgxFpl4SKsbQWUJqV6Pc
         ArQj8iVOrsKWFulHI7E3PeOfP402SA7VYOFWVmVWVd9VEsPXZycKIW8hEv28uNzSGKZZ
         haGn6KhAgV2SX8vWMK8+Pmz483HzdKL7Bmj92cSsU68qsz5KmYUMqVPUUl45HMpnlJHH
         U/QgzPDYLjNOz+ESJemFVpbXCU5gnvVUynCXKLMaKx+ACAECTubWOoTOj4b/KAtYly6J
         lFuUPeROGPjkS3qTxAL1jq1y4npnW5ViH09h79bTBRDsO0bvX+xGsdDuItJeqL+ABKXL
         SFGw==
X-Gm-Message-State: AO0yUKWe+Jw4u6wIL27Mp7HOMXqfZijuh5xquvUFfnZj9kHQoYpPgsP1
        EBAWYOaxANfV5yobK9gWv9PQ2yJcnb12/VDf
X-Google-Smtp-Source: AK7set8jv7x90UKwLiCoerr+mzChMhcajNDAgKAK1M0j3GL2JH4cUMJ6Tlxj/lhOLKcdLsBxwb41Og==
X-Received: by 2002:a05:6870:78a:b0:15e:dbe1:aee3 with SMTP id en10-20020a056870078a00b0015edbe1aee3mr322843oab.51.1675191953029;
        Tue, 31 Jan 2023 11:05:53 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:1d86:b62f:e05b:126b? ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id v10-20020a4a8c4a000000b004f241603c49sm6366947ooj.20.2023.01.31.11.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 11:05:52 -0800 (PST)
Message-ID: <f044ce61-37a5-a159-02fb-6ff14f5e911a@mojatatu.com>
Date:   Tue, 31 Jan 2023 16:05:48 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v5 1/2] net/sched: transition act_pedit to rcu
 and percpu stats
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230131145149.3776656-1-pctammela@mojatatu.com>
 <20230131145149.3776656-2-pctammela@mojatatu.com>
 <Y9k8seDdoS1LHB7L@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <Y9k8seDdoS1LHB7L@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/01/2023 13:07, Simon Horman wrote:
> On Tue, Jan 31, 2023 at 11:51:48AM -0300, Pedro Tammela wrote:
>> The software pedit action didn't get the same love as some of the
>> other actions and it's still using spinlocks and shared stats in the
>> datapath.
>> Transition the action to rcu and percpu stats as this improves the
>> action's performance dramatically on multiple cpu deployments.
>>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> ...
> 
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index a0378e9f0121..674b534be46e 100644
>> --- a/net/sched/act_pedit.c
>> +++ b/net/sched/act_pedit.c
> 
> ...
> 
>> @@ -143,8 +154,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   	bool bind = flags & TCA_ACT_FLAGS_BIND;
>>   	struct nlattr *tb[TCA_PEDIT_MAX + 1];
>>   	struct tcf_chain *goto_ch = NULL;
>> -	struct tc_pedit_key *keys = NULL;
>> -	struct tcf_pedit_key_ex *keys_ex;
>> +	struct tcf_pedit_parms *oparms, *nparms;
> 
> nit: reverse xmas tree
> 
>>   	struct tc_pedit *parm;
>>   	struct nlattr *pattr;
>>   	struct tcf_pedit *p;
> 
> ...
> 
>> @@ -212,48 +228,51 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   		ret = err;
>>   		goto out_release;
>>   	}
>> -	p = to_pedit(*a);
>> -	spin_lock_bh(&p->tcf_lock);
>>   
>> -	if (ret == ACT_P_CREATED ||
>> -	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
>> -		keys = kmalloc(ksize, GFP_ATOMIC);
>> -		if (!keys) {
>> -			spin_unlock_bh(&p->tcf_lock);
>> -			ret = -ENOMEM;
>> -			goto put_chain;
>> -		}
>> -		kfree(p->tcfp_keys);
>> -		p->tcfp_keys = keys;
>> -		p->tcfp_nkeys = parm->nkeys;
>> +	nparms->tcfp_off_max_hint = 0;
>> +	nparms->tcfp_flags = parm->flags;
>> +	nparms->tcfp_nkeys = parm->nkeys;
>> +
>> +	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
> 
> Can ksize be zero?
> 
> ...

Hi Simon,

Thanks for your thorough review.
 From the parsing code on lines 183-188:
           parm = nla_data(pattr);
           if (!parm->nkeys) {
                   NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be 
passed");
                   return -EINVAL;
           }
           ksize = parm->nkeys * sizeof(struct tc_pedit_key);

So it seems ksize can't be zero.
Let me know if you think there are other edge cases, perhaps we can add 
more tests to tdc.

Pedro
