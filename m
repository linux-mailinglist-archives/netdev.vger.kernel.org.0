Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B141E1F3EE9
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 17:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgFIPKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 11:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730716AbgFIPKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 11:10:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC56EC05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 08:10:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ne5so1527017pjb.5
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 08:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PXfAZe2TGiKznSQP1Z7YTwG8e3nY5UXZVsjd9QJWMQo=;
        b=c+jtFosOlOFUjO6pPCJ2N9Pqap9zrzT7r+DrOD4VgIrm0G5czHPCMw9d4D0UORPrG2
         4CVQowOtVGoobQEs6MyhTaRkdEdGvQDGxUHDlN2u9f6MJx0ZnADQ31T4oT8YwB58HWjw
         BKIfpaGq1YICbdY62JC2AHycx7uLm4kiTB9bk8pHzPrcmCeHQSAH3jw56U3ZV/EFyDvl
         gu1g9OTksRtNZGsOuRctFk7JQQHk1LhRI6mqRewvZqVl7lmAbSU6t0fg6vnELiP7i/CW
         DLQ/JqKtigvV9y7UScl/Og2bArJMwg3oi6cfAwYHHlF1hj08bImACyXkk7lAjSETB18i
         68SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXfAZe2TGiKznSQP1Z7YTwG8e3nY5UXZVsjd9QJWMQo=;
        b=eieMp7QvpMgBNL3Fv2kHqfMmq1JEu0JU1SYduQK7unKGocLePvJiF6+6Qhx9paUSZP
         hctIetrC3zI0k9oqmHwZvpvOoauRKd18oWNSV6eGgH2b0rqNn6SRgzimc4DEKhqLNeGR
         YfJd70l6VA5OUPvdPdOQPgVxsiwJWBJbD/GJe/h2kpzsnug1LFFwuebDcyYFmN6s3pfc
         0GziK+ZPg14rwoOhAwF3M3xorOzHVka2u6FD2EVdpJdQI8ewWNWpkI3CWz3macl3LCCV
         XImGlzbbPOf8Vyex4AdSP6P5xq/1bmga44v/jMwHAfW0EHjG/09XHxDuZ4zSgEn8yRFz
         cL0g==
X-Gm-Message-State: AOAM531R6wmk3ICbgw78gz8V+vZcvGOM36pLxeuLAQfyh7ECf+ZkqXnp
        7ihi2eHXCMNTMaZOEjg6gg9WdMPl
X-Google-Smtp-Source: ABdhPJwl7cjuA6y8WsJROtZ/KjwLKN8+R+47F2JGbdx1z/BTvTww8cOS+nAM+v8U1IhlRzrUcbt1tw==
X-Received: by 2002:a17:90b:3105:: with SMTP id gc5mr5299769pjb.36.1591715436514;
        Tue, 09 Jun 2020 08:10:36 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h13sm10238392pfk.25.2020.06.09.08.10.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 08:10:35 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 3/6] net_sched: sch_fq: multiple release time
 support
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
 <20200609140934.110785-4-willemdebruijn.kernel@gmail.com>
 <e145e4c1-3a58-d183-c6ed-cd34c1c2de8a@gmail.com>
Message-ID: <06d7b5d0-8da4-ca0b-85a9-daacb2fa7c6d@gmail.com>
Date:   Tue, 9 Jun 2020 08:10:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e145e4c1-3a58-d183-c6ed-cd34c1c2de8a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/20 8:00 AM, Eric Dumazet wrote:
> 
> 
> On 6/9/20 7:09 AM, Willem de Bruijn wrote:
>> From: Willem de Bruijn <willemb@google.com>
>>
>> Optionally segment skbs on FQ enqueue, to later send segments at
>> their individual delivery time.
>>
>> Segmentation on enqueue is new for FQ, but already happens in TBF,
>> CAKE and netem.
>>
>> This slow patch should probably be behind a static_branch.
>>
>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>> ---
>>  net/sched/sch_fq.c | 33 +++++++++++++++++++++++++++++++--
>>  1 file changed, 31 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
>> index 8f06a808c59a..a5e2c35bb557 100644
>> --- a/net/sched/sch_fq.c
>> +++ b/net/sched/sch_fq.c
>> @@ -439,8 +439,8 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
>>  	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
>>  }
>>  
>> -static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>> -		      struct sk_buff **to_free)
>> +static int __fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>> +			struct sk_buff **to_free)
>>  {
>>  	struct fq_sched_data *q = qdisc_priv(sch);
>>  	struct fq_flow *f;
>> @@ -496,6 +496,35 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>  	return NET_XMIT_SUCCESS;
>>  }
>>  
>> +static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>> +		      struct sk_buff **to_free)
>> +{
>> +	struct sk_buff *segs, *next;
>> +	int ret;
>> +
>> +	if (likely(!skb_is_gso(skb) || !skb->sk ||
> 
> You also need to check sk_fullsock(skb->sk), otherwise KMSAN might be unhappy.
> 
>> +		   !skb->sk->sk_txtime_multi_release))
>> +		return __fq_enqueue(skb, sch, to_free);
>> +
>> +	segs = skb_gso_segment_txtime(skb);
>> +	if (IS_ERR(segs))
>> +		return qdisc_drop(skb, sch, to_free);
>> +	if (!segs)
>> +		return __fq_enqueue(skb, sch, to_free);
>> +
>> +	consume_skb(skb);
> 
>    This needs to be qdisc_drop(skb, sch, to_free) if queue is full, see below.
> 
>> +
>> +	ret = NET_XMIT_DROP;
>> +	skb_list_walk_safe(segs, segs, next) {
>> +		skb_mark_not_on_list(segs);
>> +		qdisc_skb_cb(segs)->pkt_len = segs->len;
> 
> This seems to under-estimate bytes sent. See qdisc_pkt_len_init() for details.
> 
>> +		if (__fq_enqueue(segs, sch, to_free) == NET_XMIT_SUCCESS)
>> +			ret = NET_XMIT_SUCCESS;
>> +	}
> 
>         if (unlikely(ret == NET_XMIT_DROP))
>             qdisc_drop(skb, sch, to_free);

Maybe not qdisc_drop() (qdisc drop counters are already updated)
but at least kfree_skb() so that drop monitor is not fooled.

>         else
>             consume_skb(skb);
> 
>> +
>> +	return ret;
>> +}
>> +
>>  static void fq_check_throttled(struct fq_sched_data *q, u64 now)
>>  {
>>  	unsigned long sample;
>>
> 
> 
