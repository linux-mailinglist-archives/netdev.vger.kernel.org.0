Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26490391C18
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhEZPfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbhEZPfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:35:38 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B4CC061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:34:07 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id t17so1168179qta.11
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NctmoWs8tLUvGWlpFwF5tdeAyBbyMzRUvFfUG7aqzEU=;
        b=Txf7OUJcOzDUzoa1IPdnaAzZT/nz45uqHFWcn7jBbIdL8EhyLLFr9Sa/l7aRwMURyH
         pZh3Azr9TIbBYgk+WX08xeweTbUb5OArr4dKkPDLPwiitXB1lS1+Ic3Qq1bRk60w/uX+
         jnf0cK5BihddvDSaXUZEc5L8unCHf647TFHk32rhuxM2gd232UMaetwgJQuDUU0ki85p
         WOizgS44T39EoAjUoYxTO177nN/GKh4ZKDnyHPUk4RJMBEw3bszmI9dUHDhGC/vAZl7t
         rtxEUIDhuN1O/+DqvnyKwCwWXRqNxP4SOw+Q+eAWGM9MwB4T60wgXJunVaS8D7y/oS7i
         ZDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NctmoWs8tLUvGWlpFwF5tdeAyBbyMzRUvFfUG7aqzEU=;
        b=WVEER1M5gU8miUdyDjD1UStPWuz96Pey2fTtHAPFNskoPh4ykU/+S13uleDJYsy69d
         azb8pkLyHGWVU2eCPOvGZRKyuSKoBQdAiz8ZWDC8XKi0qMb52DC2sbGO5ZwXFYEjqtEB
         2LHiDKp7y07B+UoCwG2BHg2xmnlwQA2qyA5pKXA2n9W/TfV9EYdr3xFzzptjx2YjRF7Z
         H5/29Z4/aU4f81nBHzHhiJgteRjYBx2UOsjHpMC/k2QeEp37LcmEMGaw7ddW8ibQmPCH
         t8hcY34z3ncBvu8MxYUYR1tvcoT6DCCsFu1EzaVti7OvaRjIipIQjZM5g6l9IpWt1yZ4
         Z9UQ==
X-Gm-Message-State: AOAM533/efx64oQk77DRn2bICXcEEynILg94IXa7McGJUE6jrPyq2c8f
        arKRDhDYVSYfdwJbb9FiU/ebJg==
X-Google-Smtp-Source: ABdhPJwpIhVTy2xUHL/jiUCnDO/QVUEneEXfVN/xPxO4/avILHpXWn4PqNR1l/BA63+vYKdQRN8eJQ==
X-Received: by 2002:ac8:7194:: with SMTP id w20mr37767833qto.363.1622043246421;
        Wed, 26 May 2021 08:34:06 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id j15sm1659361qtv.11.2021.05.26.08.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:34:05 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Pedro Tammela <pctammela@gmail.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <bcbf76c3-34d4-d550-1648-02eda587ccd7@mojatatu.com>
 <CAADnVQLWj-=B2TfJp7HEsiUY3rqmd6-YMDAGdyL6RgZ=_b2CXg@mail.gmail.com>
 <27dae780-b66b-4ee9-cff1-a3257e42070e@mojatatu.com>
 <CAADnVQJq37Xi2bHBG5L+DmMq6dJvFUCE3tt+uC-oAKX3WxcCQg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <2dfc5180-40df-ae4c-7146-d64130be9ad4@mojatatu.com>
Date:   Wed, 26 May 2021 11:34:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJq37Xi2bHBG5L+DmMq6dJvFUCE3tt+uC-oAKX3WxcCQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-25 6:08 p.m., Alexei Starovoitov wrote:
> On Tue, May 25, 2021 at 2:09 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>

>> This is certainly a useful feature (for other reasons as well).
>> Does this include create/update/delete issued from user space?
> 
> Right. Any kind of update/delete and create is a subset of update.
> The lookup is not included (yet or may be ever) since it doesn't
> have deterministic start/end points.
> The prog can do a lookup and update values in place while
> holding on the element until prog execution ends.
> 
> While update/delete have precise points in hash/lru/lpm maps.
> Array is a different story.
> 

Didnt follow why this wouldnt work in the same way for Array?

One interesting concept i see come out of this is emulating
netlink-like event generation towards user space i.e a user
space app listening to changes to a map.

>>
>> The challenge we have in this case is LRU makes the decision
>> which entry to victimize. We do have some entries we want to
>> keep longer - even if they are not seeing a lot of activity.
> 
> Right. That's certainly an argument to make LRU eviction
> logic programmable.
> John/Joe/Daniel proposed it as a concept long ago.
> Design ideas are in demand to make further progress here :)
> 

would like to hear what the proposed ideas are.
I see this as a tricky problem to solve - you can make LRU
programmable to allow the variety of LRU replacement algos out
there but not all encompansing for custom or other types of algos.
The problem remains that LRU is very specific to evicting
entries that are least used. I can imagine that if i wanted to
do a LIFO aging for example then it can be done with some acrobatics
as an overlay on top of LRU with all sorts of tweaking.
It is sort of fitting a square peg into a round hole - you can do
it, but why the torture when you have a flexible architecture.

We need to provide the mechanisms (I dont see a disagreement on
need for timers at least).

>> You could just notify user space to re-add the entry but then
>> you have sync challenges.
>> The timers do provide us a way to implement custom GC.
> 
> My point is that time is always going to be a heuristic that will
> break under certain traffic conditions.
> I recommend to focus development effort on creating
> building blocks that are truly great instead of reimplementing
> old ideas in bpf with all of their shortcomings.
> 

There are some basic mechanisms i dont think that we can avoid.
Agreed on the general sentiment of what you are saying.

>> So a question (which may have already been discussed),
>> assuming the following setup:
>> - 2 programs a) Ingress b) egress
>> - sharing a conntrack map which and said map pinned.
>> - a timer prog (with a map with just timers;
>>      even a single timer would be enough in some cases).
>>
>> ingress and egress do std stuff like create/update
>> timer prog does the deletes. For simplicity sake assume
>> we just have one timer that does a foreach and iterates
>> all entries.
>>
>> What happens when both ingress and egress are ejected?
> 
> What is 'ejected'? Like a CD? ;)

I was going to use other verbs to describe this; but
may have sounded obscene ;->

> I think you mean 'detached' ?

Yes.

> and then, I assume, the user space doesn't hold to prog FD?

Right. The pinning may still exist on the maps (therefore a ref
count). Note, this may be design intent.

> The kernel can choose to do different things with the timer here.
> One option is to cancel the outstanding timers and unload
> .text where the timer callback lives
 >
> Another option is to let the timer stay armed and auto unload
> .text of bpf function when it finishes executing.
 >
> If timer callback decides to re-arm itself it can continue
> executing indefinitely.
> This patch is doing the latter.
> There could be a combination of both options.
> All options have their pros/cons.

A reasonable approach is to let the policy be defined
from user space. I may want the timer to keep polling
a map that is not being updated until the next program
restarts and starts updating it.
I thought Cong's approach with timerids/maps was a good
way to achieve control.

cheers,
jamal

