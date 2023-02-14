Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC0C6966E8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjBNOb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbjBNOb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:31:27 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31DC1733
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:31:25 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-16a7f5b6882so19185345fac.10
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QvfvaWkfV4BAysVSsnZ+bEuCF4KrDwYHUY59vMXMIUY=;
        b=fPnvg77xN8T2NzVW9snYfy+DGTn9TXg0n0WvQ5zGZXXqqPA4VLRCzuXtCMCTbi1RSo
         Xqs4++VFb4KCLeH1HnODFvQfKjQANhW5nG9Ba2fpPgoWaorbfzQIl+NVBgb+K1MXcjJ5
         BeGmDF8c8q4jfc18uBIFWsIJKkbnh/ybfVE6abzleNxvpBjhTGmk1pPS4VXrJIKKMN+u
         pUBtF4+qyJ1qMXwa0v3+b4TYNF2O34ibpPxr4DDGx1M8gCszyIzw7yYU5tnbUwctCpWf
         g8//thwTtbPdxOZt8pDnslzasqYy/IeHsLYOs5fpRF/cnen5BgDksvVJ2x1sJz2m8lqN
         MCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QvfvaWkfV4BAysVSsnZ+bEuCF4KrDwYHUY59vMXMIUY=;
        b=bohoqRuId/mVJZjLdCWkch754ZmK33y25x5p5XyGl7wHHUYsqGSt0wqikA5RmXqCh3
         TgG0RFwcRA2Y5zR0gQex0ODvkb4vsO5M+TZW1SoJXCUfR7+ZyyJsXc8tDmqXM4SOGkzq
         5KqOXHxpVVQ6DDzHSvbJUuU+8LFO1dimccS+XU5KkQGY72djZnG+ZxUWCQ1noALNZn7t
         g4GXn3HNLch5UYn4n9/aNJzgaWK5Y+m4qxRhsqf4n2AdZh25CTv3H1y/TTcqxZ89ml+B
         GfaeZkh8zJtNtHyMTdYr5h6ZW2ODa6x0bGPGKIEY4qw8/zBrYJy+2AgSTfaNMC6flvSW
         OTGw==
X-Gm-Message-State: AO0yUKUDirGaKaDRlFav2B6dqblmbW8KPfAwyhZpK40TCc9yw+6NbPHH
        D2O8p9Rjr1fI6tJ/d8FRZ+9rng==
X-Google-Smtp-Source: AK7set+WcfSCKqt9ruEwMYdIR2E7APduFxvlD2hfsbS7F1D17oSG3CIDq561nJkWxeVi71gQkfaqfg==
X-Received: by 2002:a05:6870:b14c:b0:16a:9f20:630e with SMTP id a12-20020a056870b14c00b0016a9f20630emr1047333oal.4.1676385084972;
        Tue, 14 Feb 2023 06:31:24 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:565a:c0a1:97af:209b? ([2804:14d:5c5e:4698:565a:c0a1:97af:209b])
        by smtp.gmail.com with ESMTPSA id d39-20020a056870d2a700b0010d7242b623sm2355200oae.21.2023.02.14.06.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 06:31:24 -0800 (PST)
Message-ID: <c763b9f1-93fb-bb20-8908-3b008b3bd9fb@mojatatu.com>
Date:   Tue, 14 Feb 2023 11:31:20 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/3] net/sched: act_connmark: transition to
 percpu stats and rcu
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
References: <20230210202725.446422-1-pctammela@mojatatu.com>
 <20230210202725.446422-3-pctammela@mojatatu.com>
 <09051dd20251cd521c253ed8d133301b03d90f9e.camel@redhat.com>
Content-Language: en-US
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <09051dd20251cd521c253ed8d133301b03d90f9e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 06:03, Paolo Abeni wrote:
> On Fri, 2023-02-10 at 17:27 -0300, Pedro Tammela wrote:
>> The tc action act_connmark was using shared stats and taking the per
>> action lock in the datapath. Improve it by using percpu stats and rcu.
>>
>> perf before:
>> - 13.55% tcf_connmark_act
>>     - 81.18% _raw_spin_lock
>>         80.46% native_queued_spin_lock_slowpath
>>
>> perf after:
>> - 3.12% tcf_connmark_act
>>
>> tdc results:
>> 1..15
>> ok 1 2002 - Add valid connmark action with defaults
>> ok 2 56a5 - Add valid connmark action with control pass
>> ok 3 7c66 - Add valid connmark action with control drop
>> ok 4 a913 - Add valid connmark action with control pipe
>> ok 5 bdd8 - Add valid connmark action with control reclassify
>> ok 6 b8be - Add valid connmark action with control continue
>> ok 7 d8a6 - Add valid connmark action with control jump
>> ok 8 aae8 - Add valid connmark action with zone argument
>> ok 9 2f0b - Add valid connmark action with invalid zone argument
>> ok 10 9305 - Add connmark action with unsupported argument
>> ok 11 71ca - Add valid connmark action and replace it
>> ok 12 5f8f - Add valid connmark action with cookie
>> ok 13 c506 - Replace connmark with invalid goto chain control
>> ok 14 6571 - Delete connmark action with valid index
>> ok 15 3426 - Delete connmark action with invalid index
>>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> ---
>>   include/net/tc_act/tc_connmark.h |   9 ++-
>>   net/sched/act_connmark.c         | 109 ++++++++++++++++++++-----------
>>   2 files changed, 77 insertions(+), 41 deletions(-)
>>
>> diff --git a/include/net/tc_act/tc_connmark.h b/include/net/tc_act/tc_connmark.h
>> index 1f4cb477b..e8dd77a96 100644
>> --- a/include/net/tc_act/tc_connmark.h
>> +++ b/include/net/tc_act/tc_connmark.h
>> @@ -4,10 +4,15 @@
>>   
>>   #include <net/act_api.h>
>>   
>> -struct tcf_connmark_info {
>> -	struct tc_action common;
>> +struct tcf_connmark_parms {
>>   	struct net *net;
>>   	u16 zone;
>> +	struct rcu_head rcu;
>> +};
>> +
>> +struct tcf_connmark_info {
>> +	struct tc_action common;
>> +	struct tcf_connmark_parms __rcu *parms;
>>   };
>>   
>>   #define to_connmark(a) ((struct tcf_connmark_info *)a)
>> diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
>> index 7e63ff7e3..541e1c556 100644
>> --- a/net/sched/act_connmark.c
>> +++ b/net/sched/act_connmark.c
>> @@ -36,13 +36,15 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
>>   	struct nf_conntrack_tuple tuple;
>>   	enum ip_conntrack_info ctinfo;
>>   	struct tcf_connmark_info *ca = to_connmark(a);
>> +	struct tcf_connmark_parms *parms;
>>   	struct nf_conntrack_zone zone;
>>   	struct nf_conn *c;
>>   	int proto;
>>   
>> -	spin_lock(&ca->tcf_lock);
>>   	tcf_lastuse_update(&ca->tcf_tm);
>> -	bstats_update(&ca->tcf_bstats, skb);
>> +	tcf_action_update_bstats(&ca->common, skb);
>> +
>> +	parms = rcu_dereference_bh(ca->parms);
>>   
>>   	switch (skb_protocol(skb, true)) {
>>   	case htons(ETH_P_IP):
>> @@ -64,31 +66,31 @@ TC_INDIRECT_SCOPE int tcf_connmark_act(struct sk_buff *skb,
>>   	c = nf_ct_get(skb, &ctinfo);
>>   	if (c) {
>>   		skb->mark = READ_ONCE(c->mark);
>> -		/* using overlimits stats to count how many packets marked */
>> -		ca->tcf_qstats.overlimits++;
>> -		goto out;
>> +		goto count;
>>   	}
>>   
>> -	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
>> -			       proto, ca->net, &tuple))
>> +	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), proto, parms->net,
>> +			       &tuple))
>>   		goto out;
>>   
>> -	zone.id = ca->zone;
>> +	zone.id = parms->zone;
>>   	zone.dir = NF_CT_DEFAULT_ZONE_DIR;
>>   
>> -	thash = nf_conntrack_find_get(ca->net, &zone, &tuple);
>> +	thash = nf_conntrack_find_get(parms->net, &zone, &tuple);
>>   	if (!thash)
>>   		goto out;
>>   
>>   	c = nf_ct_tuplehash_to_ctrack(thash);
>> -	/* using overlimits stats to count how many packets marked */
>> -	ca->tcf_qstats.overlimits++;
>>   	skb->mark = READ_ONCE(c->mark);
>>   	nf_ct_put(c);
>>   
>> -out:
>> +count:
>> +	/* using overlimits stats to count how many packets marked */
>> +	spin_lock(&ca->tcf_lock);
>> +	ca->tcf_qstats.overlimits++;
>>   	spin_unlock(&ca->tcf_lock);
> 
> I think above you could use tcf_action_inc_overlimit_qstats() and avoid
> acquiring the spin lock in most cases.
> 
> Side note: it looks like pedit could use a similar change, too - sorry
> for missing that point before.
> 

Oh, indeed! I will respin and add the pedit change in this series as well.
Many thanks.
