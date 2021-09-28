Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FAF41BAF9
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 01:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243167AbhI1X1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 19:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhI1X1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 19:27:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E08C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 16:25:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id n18so673573pgm.12
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 16:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HFip4R/7tFfWmQjN2xcemyQnqxc3mRoX6ZNukuh1ZI0=;
        b=bO5sU6S6tk7jQNNpAK8aOaN+bznZmVG39iSjGuVYtQyNTW9UCJLvFtjqNiBDH0bAYs
         54QG2NYLEQ+B1EeDX03FMU1o8t+vbjTGO8jUeKDcH/i8Hn6AmNM2Ty/T3aaE2XLV+DF7
         LlZTZhdDkL2EnnTOCkdYyWoRlWuG3NRwO+P7Q41jYDf0d1iqKy1gHWhjPptULvsiRiys
         aRFWti5h9YkQABePn+1w/5yzNabuKXqu3B88ovZXy0VkL/pkrfc8nhZDK6nXAxJs28gC
         ATC9kqRhUejTF2IsYVdjsLXi/BM4uLhvPfzZVfBWZJ76qaOBHIKqjIyS581pYw7ORshU
         YhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HFip4R/7tFfWmQjN2xcemyQnqxc3mRoX6ZNukuh1ZI0=;
        b=N/kfBepRSJfrdvbuQg+zffu7IyyqI/vaDq7FqB/6/olwKfXS/1ApbPJXWVIUNcckzD
         QQPEArVWTWGiOAnbwhATdQenzjet7GHZqdd2m5heAFNHwAkz2vkB/sF0rtEVm51uk6eb
         gf7FVsSpLMchCUIh2RfWAHvvjGLTUa9lxtXip5yzxkEp1n95HjbWUgx/YpTk0Z+HYc3k
         VueADxE7XzIRvEt1cLyzNsgUvcL/Q6rY5l0o+8IRv1BBI1Ghu4CnbI36Hozx4ZPG7/4a
         3O4RpyB/0CLjNvlpxwD8gTQmlc+XcTvDM4ZlAaYIryFjhR+3InOTyfD79TiKNnFppzF8
         LvIg==
X-Gm-Message-State: AOAM532AYGu2PZJC7iNvVVywvxv9LpihN652d4LKK3TZ/b4ffrULw+3d
        1uNjJQduMbAKs9RIGwuUuWx1YLmbY6k=
X-Google-Smtp-Source: ABdhPJw80qZ8ksX/dnf8/13iTzq4E6VM8VMbLXCPZIFQKjLaO//ewFgQrUfU3oEx6hgRHLAJeNK3qw==
X-Received: by 2002:a62:6d86:0:b0:448:152d:83a4 with SMTP id i128-20020a626d86000000b00448152d83a4mr8245472pfc.38.1632871541384;
        Tue, 28 Sep 2021 16:25:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p3sm204290pfq.67.2021.09.28.16.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 16:25:40 -0700 (PDT)
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Ben Greear <greearb@candelatech.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
Date:   Tue, 28 Sep 2021 16:25:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/21 3:00 PM, Ben Greear wrote:
> On 9/27/21 5:16 PM, Ben Greear wrote:
>> On 9/27/21 5:04 PM, Ben Greear wrote:
>>> On 9/27/21 4:49 PM, Eric Dumazet wrote:
>>>>
>>>>
>>>> On 9/27/21 4:30 PM, Ben Greear wrote:
>>>>> Hello,
>>>>>
>>>>> In a hacked upon kernel, I'm getting crashes in fq-codel when doing bi-directional
>>>>> pktgen traffic on top of mac-vlans.  Unfortunately for me, I've made big changes to
>>>>> pktgen so I cannot easily run this test on stock kernels, and there is some chance
>>>>> some of my hackings have caused this issue.
>>>>>
>>>>> But, in case others have seen similar, please let me know.  I shall go digging
>>>>> in the meantime...
>>>>>
>>>>> Looks to me like 'skb' is NULL in line 120 below.
>>>>
>>>>
>>>> pktgen must not be used in a mode where a single skb
>>>> is cloned and reused, if packet needs to be stored in a qdisc.
>>>>
>>>> qdisc of all sorts assume skb->next/prev can be used as
>>>> anchor in their list.
>>>>
>>>> If the same skb is queued multiple times, lists are corrupted.
>>>>
>>>> Please double check your clone_skb pktgen setup.
>>>>
>>>> I thought we had IFF_TX_SKB_SHARING for this, and that macvlan was properly clearing this bit.
>>>
>>> My pktgen config was not using any duplicated queueing in this case.
>>>
>>> I changed to pfifo fast and so far it is stable for ~10 minutes, where before it would crash
>>> within a minute.  I'll let it bake overnight....
>>
>> Still running stable.  I also notice we have been using fq-codel for a while and haven't noticed
>> this problem (next most recent kernel we might have run similar test on would be 5.13-ish).
>>
>> I'll duplicate this test on our older kernels tomorrow to see if it looks like a regression or
>> if we just haven't actually done this exact test in a while...
> 
> We can reproduce this crash as far back as 5.4 using fq-codel, with our pktgen driving mac-vlans.
> We did not try any kernels older than 5.4.
> We cannot reproduce with pfifo on 5.15-rc3 on an overnight run.
> We cannot produce with user-space UDP traffic on any kernel/qdisc combination.
> Our pktgen is configured for multi-skb of 0 (no multiple submits of the same skb)
> 
> While looking briefly at fq-codel, I didn't notice any locking in the code that crashed.
> Any chance that it makes assumptions that would be incorrect with pktgen running multiple
> threads (one thread per mac-vlan) on top of a single qdisc belonging to the underlying NIC?
> 


qdisc are protected by a qdisc spinlock.

fq-codel does not have to lock anything in its enqueue() and dequeue() methods.

I guess your local changes to pktgen might be to blame.

pfifo is much simpler than fq-codel, it uses less fields from skb.
