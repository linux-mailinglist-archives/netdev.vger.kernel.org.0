Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49874249995
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHSJsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHSJsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:48:06 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2865BC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:48:06 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o22so17263717qtt.13
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sm/1uLfsGcjxMLrPqn6lO0y9A8dInMG+i0H65RHmeWY=;
        b=aMWDidovh/aTmMB3X77AJBSHL1CFffRevthXKSFbSSZlqqxIv+mLqU6RF2AfUxx8CO
         jmm/CNcLGHw+Dvd3uHGyYrEBQfu/gWz7ZM5/2MbKscedpozgWxFXcwNZbIhYtpsXLSEo
         6r2oGJ1O6CvGlxnGE+/04hs99/xyui7uJlBXtk2DRERv9HD1ZZr1Y+RwDJQ8kuGBIhOQ
         vyMZLwwNAJ8IKM69zWaRe60StcMGeriG558Jdp9aFMRTQcTisjbTYK8jq2tzMxnnk/nP
         2ADExNOTc7GtvYymsX/a8vZc3IYHHxscf+c9SI5sST7TnQwSYDElfk6elRsT+KK4w2cc
         kxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sm/1uLfsGcjxMLrPqn6lO0y9A8dInMG+i0H65RHmeWY=;
        b=ioK5onWfNxy+EFtEoAPnJZYjqUw7Ne6LL4xsj1POy7tz4PJ1tDWUTEXbD47Nsf2T15
         PZv2DtYbbqhBq0v7aswq6Rl3kV6rXLPv7IT04yYKZkLew+qP8O5NGo2AnA8jWSOFqsJj
         LWU+Ey1Q7BPCGzZpVEpeiTNfTPJMeuEZ1q9A/eBJ7pEjzhKarSuqVvRile84WtzxM0YO
         ycLsTd4bwz/3FtOZCOoAhmWpoKVVufmS5vZ4lC3rGi3P8omCEMQ3RoOlHiSEgFk3Z4pk
         SzwET3lXNlxbz2/WFQfm6GGpbt5zgP7xVaAMcgMpvD6CP82H8LV2fVD+WKBapkDd0jgx
         TwDA==
X-Gm-Message-State: AOAM531x9sRB/Fwd/o4DFhJzg7j0K0t8ZOAcaiE4q+Clh6c7g11y56a0
        IxYg2CS7Fj7sdYrbyaZUKsrjHg==
X-Google-Smtp-Source: ABdhPJzPobpXVpdq3eDc7aVe4J+O6dZqYzufqYqzSaBQwObPeQ6LDcplB+lPrpQ8Qx6MWM8p414jXA==
X-Received: by 2002:ac8:fc2:: with SMTP id f2mr21458552qtk.342.1597830485295;
        Wed, 19 Aug 2020 02:48:05 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id x5sm25572021qtp.76.2020.08.19.02.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 02:48:04 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
References: <20200807222816.18026-1-jhs@emojatatu.com>
 <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
 <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
 <64844778-a3d5-7552-df45-bf663d6498b6@mojatatu.com>
 <CAM_iQpVBs--KBGe4ZDtUJ0-FsofMOkfnUY=bWJjE0_dFYmv5SA@mail.gmail.com>
 <c8722128-71b7-ad83-b142-8d53868dafc6@mojatatu.com>
 <CAM_iQpX71-jFUddZoSQrXWpd0KRpi0ueoK=h3ugBh5ufYvqLEQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b7460988-1f9c-5693-f09c-729453c1e58a@mojatatu.com>
Date:   Wed, 19 Aug 2020 05:48:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX71-jFUddZoSQrXWpd0KRpi0ueoK=h3ugBh5ufYvqLEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-17 3:47 p.m., Cong Wang wrote:
> On Mon, Aug 17, 2020 at 4:19 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>

[..]
>> There is no ambiguity of intent in the fw case, there is only one field.
>> In the case of having multiple fields it is ambigious if you
>> unconditionally look.
>>
>> Example: policy says to match skb mark of 5 and hash of 3.
>> If packet arrives with skb->mark is 5 and skb->hash is 3
>> very clearly matched the intent of the policy.
>> If packet arrives withj skb->mark 7 and hash 3 it clearly
>> did not match the intent. etc.
> 
> This example clearly shows no ambiguous, right? ;)
> 

Ambigious only from the perspective of relational AND vs OR
(your original pseudo code had it in OR relation).

> 
>>
>>> But if filters were put in a global hashtable, the above would be
>>> much harder to implement.
>>>
>>
>> Ok, yes. My assumption has been you will have some global shared
>> structure where all filters will be installed on.
> 
> Sure, if not hashtable, we could simply put them in a list:
> 
> list_for_each_filter {
>    if (filter_parameter_has_hash) {
>      match skb->hash with cls->param_hash
>    }
>    if (filter_parameter_has_mark) {
>      match skb->mark with cls->param_mark
>    }
> }
> 

Yes, that would work - but iteration is linear.

> 
>>
>> I think i may have misunderstood all along what you were saying
>> which is:
>>
>> a) add the rules so they are each _independent with different
>>      priorities_ in a chain.
> 
> Yes, because this gives users freedom to pick a different prio
> from its value (hash or mark).
>

ok.

> 
>>
>> b)  when i do lookup for packet arrival, i will only see a filter
>>    that matches "match mark 5 and hash 3" (meaning there is no
>>    ambiguity on intent). If packet data doesnt match policy then
>>    i will iterate to another filter on the chain list with lower
>>    priority.
> 
> Right. Multiple values mean AND, not OR, so if you specify
> mark 5 and hash 3, it will match skb->mark==5 && skb->hash==3.
> If not matched, it will continue the iteration until the end.
>

That would remove the ambiguity (assuming iteration with "continue"
to create the AND effect).

>>
>> Am i correct in my understanding?
>>
>> If i am - then we still have a problem with lookup scale in presence
>> of a large number of filters since essentially this approach
>> is linear lookup (similar problem iptables has). I am afraid
>> a hash table or something with similar principle goals is needed.
> 
> Yeah, this is why I asked you whether we have to put them in a
> hashtable in previous emails, as hashtable organizes them with
> a key, it is hard to combine multiple fields in one key and allow
> to extend easily in the future. But other people smarter than me
> may have better ideas here.

To achieve reasonable performance (with many filters) I dont think
there is escape from having something that is centralized
(per priority) - sort of what fw, u32 or flower do. A hash table is
the most common approach; i was hoping that IDR maybe useful since the
skb->hash maps nicely to "32 bit key" but Vlad was saying at the
tc workshop that he was seeing bottlenecks with IDR.

I will test a few hash algorithms (including common one like jenkins)
for this use case.
Problem right now is we have that rcu-inspired upper bucket limit
(which exists) in fw as well: If i have 1M entries which can only be
spread to 256 buckets perfectly then i have ~4K entries per bucket
which are a linked list. So we are still not doing so well. Do you have
time to make that better for fw (since you are an rcu maestro).

cheers,
jamal
