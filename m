Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD1E3D7AAF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhG0QNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhG0QNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:13:43 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040C2C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:13:40 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id l24so9914872qtj.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qdgzUd3PowCb3VGOZd/z0SLZdtdbzj4bi19g1zyGXG0=;
        b=nIyraceI5n0OhGr96/yKNqKWBC02sh6IqRfEizhXmaEiEhLeW+ROVW34aeB3YXN+Sl
         3rHA0ylcjZ5+BsCDvXChahAs+5qan0nvm56wup3VZV0qLsxO0DK+8vs1AZnUJUCnEiTA
         Yk/APelCFeyiTGS38eE4kA0WBmnuVwfDFn6l69rPGX7Jcxe8hhxb/8RdCBEDXJAwB+xW
         fy5ZQkXsdty4F9bKt8jx7txzrxBGFYvFfn8PWjabHwwBkDZfG9CjOUiEb68v28MufXc6
         0svQz55cne1WITXm8AMR6gRTD9mYN6OGnVAaE9e2cqATIuY6TaO6+X/Oa2PHliPCATcX
         PRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qdgzUd3PowCb3VGOZd/z0SLZdtdbzj4bi19g1zyGXG0=;
        b=olEluSoYSHbx9Up3C6GYjLvz7XuOnwegK36QrM3bophIPUqrNobptnoFJS2KJDULnA
         L9igKp9WCD/P5w7cY5EdHWKdRr4EtJkBTLtTmp8YjfEYmdauqlabG2Lcew6nhojRw1d7
         z6V7yqhJFnsbEbtvlgDvMFVrqMc1orHKKtMoF/S2kOPUz5jCsAhhvOekh2xHEysYSm4a
         NbCm4dMy6DIxihB6cCp8HvnXgzZNGIv7QbYxHyXypjlqnAR/L0J8aEFhBHxP7MXb4Iv2
         YSl718VvcQaW03ZHwnXSsUmn4Kn2ty5n1k2P837iHoWyamVNIF6QV+wHRIkNHunXjQ4R
         yVSg==
X-Gm-Message-State: AOAM533CypPgNbO0l+mm81ZEB5sXJT0GKPucZfA27rRDj95CL6LW1ywq
        /Q6JAWBxa5DZOxfGOUiX/jNhnQ==
X-Google-Smtp-Source: ABdhPJz6CroJ0vO+ZwqVgyGiDPFcL2XZzNBTuGAnmK/KG+JZCqX9B1JxEYQ4JRPT8kTuKFr0knigZA==
X-Received: by 2002:ac8:4706:: with SMTP id f6mr20127077qtp.315.1627402419092;
        Tue, 27 Jul 2021 09:13:39 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id x23sm1998378qkf.36.2021.07.27.09.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 09:13:38 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
Date:   Tue, 27 Jul 2021 12:13:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ygnh7dhbrfd0.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
> 
> On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:

>>>
>>> Also showing a tc command line in the cover letter on how one would
>>> ask for a specific action to be offloaded.
>>
>> In practice actions are offloaded when a flow using them is offloaded.
>> So I think we need to consider what the meaning of IN_HW is.
>>
>> Is it that:
>>
>> * The driver (and potentially hardware, though not in our current
>>    implementation) has accepted the action for offload;
>> * That a classifier that uses the action has bee offloaded;
>> * Or something else?
> 
> I think we have the same issue with filters - they might not be in
> hardware after driver callback returned "success" (due to neigh state
> being invalid for tunnel_key encap, for example).
> 

Sounds like we need another state for this. Otherwise, how do you debug
that something is sitting in the driver and not in hardware after you
issued a command to offload it? How do i tell today?
Also knowing reason why something is sitting in the driver would be
helpful.

>> With regards to a counter, I'm not quite sure what this would be:
>>
>> * The number of devices where the action has been offloaded (which ties
>>    into the question of what we mean by IN_HW)
>> * The number of offloaded classifier instances using the action
>> * Something else
> 
> I would prefer to have semantics similar to filters:
> 
> 1. Count number of driver callbacks that returned "success".
> 
> 2. If count > 0, then set in_hw flag.
> 
> 3. Set in_hw_count to success count.
> 
> This would allow user to immediately determine whether action passed
> driver validation.
>

I didnt follow this:
Are we refering to the the "block" semantics (where a filter for
example applies to multiple devices)?

>>
>> Regarding a flag to control offload:
>>
>> * For classifiers (at least the flower classifier) there is the skip_sw and
>>    skip_hw flags, which allow control of placement of a classifier in SW and
>>    HW.
>> * We could add similar flags for actions, which at least in my
>>    world view would have the net-effect of controlling which classifiers can
>>    be added to sw and hw - f.e. a classifier that uses an action marked
>>    skip_hw could not be added to HW.

I guess it depends on the hardware implementation.
In S/W we have two modes:
Approach A: create an action and then 2) bind it to a filter.
Approach B: Create a filter and then bind it to an action.

And #2A can be repeated multiple times for the same action
(would require some index as a reference for the action)
To Simon's comment above that would mean allowing
"a classifier that uses an action marked skip_hw to be added to HW"
i.e
Some hardware is capable of doing both option #A and #B.

Todays offload assumes #B - in which both filter and action are assumed
offloaded.

I am hoping whatever approach we end up agreeing on doesnt limit
either mode.

>> * Doing so would add some extra complexity and its not immediately apparent
>>    to me what the use-case would be given that there are already flags for
>>    classifiers.
> Yeah, adding such flag for action offload seems to complicate things.
> Also, "skip_sw" flag doesn't even make much sense for actions. I thought
> that "skip_hw" flag would be nice to have for users that would like to
> avoid "spamming" their NIC drivers (potentially causing higher latency
> and resource consumption) for filters/actions they have no intention to
> offload to hardware, but I'm not sure how useful is that option really
> is.

Hold on Vlad.
So you are looking at this mostly as an optimization to speed up h/w
control updates? ;->

I was looking at it more as a (currently missing) feature improvement.
We already have a use case that is implemented by s/w today. The feature
mimics it in h/w.

At minimal all existing NICs should be able to support the counters
as mapped to simple actions like drop. I understand for example if some
cant support adding separately offloading of tunnels for example.
So the syntax is something along the lines of:

tc actions add action drop index 15 skip_sw
tc filter add dev ...parent ... protocol ip prio X ..\
u32/flower skip_sw match ... flowid 1:10 action gact index 15

You get an error if counter index 15 is not offloaded or
if skip_sw was left out..

And then later on, if you support sharing of actions:
tc filter add dev ...parent ... protocol ip prio X2 ..\
u32/flower skip_sw match ... flowid 1:10 action gact index 15

cheers,
jamal


