Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E8C64F24F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 21:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiLPUSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 15:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiLPUR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 15:17:59 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AE372608;
        Fri, 16 Dec 2022 12:17:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c66so5203148edf.5;
        Fri, 16 Dec 2022 12:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BGjv+/8zXr7odTppy9wSy02S+MVGH5glcnXAYdtKnUc=;
        b=TV8HbEnKDq2YkTWyFgt4+EyfU3FKhaukBCAlB0FyymvKxMNDX6WeHg+RrH5t+u+HNU
         L3081LjK7hrro0SmZuUw8hNedvKHeTZy9CFO9ppQxNdBT8UmvS07/mdNG3Scn/T4OQxH
         tD61mf4lF2aj9R/5ve6y22MM/JcWpnFbz5reRI7c5f3aOW3faJKpkUZUUYhuyLXuQ1zb
         M0AifqQmijt8NQG5+hSuNtZmqtfxN8ueFKVL2CH8fflaRPRYjCe0kzmcQlfdNnXKq3lg
         vRU+68yM8cwuJib9Nd0BVdEDVfb4wXiUL8ewMNf/gsqmenfWZFhDJ+/PP0eVwPaXZ4q4
         iSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGjv+/8zXr7odTppy9wSy02S+MVGH5glcnXAYdtKnUc=;
        b=tDX6Hp3kAAo564AIDZlbsa8q0AmUSYAxds+7J0WH8DuteimR+QVngqe4Esl9DKdsgB
         cYZtJCeEQGJ8SVetdSWrF0uIQwDvG/J0Yj5asdLXNgWWkwW+gfal0hCUWVDkAZJxDSjq
         ruXVU3TDigsxpMp7jta5X2cYwWzBoB5maIH8P8iHOx1FFvCcvl9d23ShsGuu7Xqbxia2
         1grA7qaIjAzSHOK5iYxjXNuv6vwkxW7nDQ3VcTo9vG1+lYIdZBQ6FlAmJ4eBrw+y1DQn
         0uRIQZg3MkqCw22gxJSSNtI0CWyQysrIPh52zZDlXrdiolzjZtMSsmxDfBmzQXVcfdp+
         D1PA==
X-Gm-Message-State: ANoB5pnrI0csG4+BqpOB7cgUNzXNehVk5sNX7QblJFp1IDxu3ueZcRrh
        qqRg3V8ou6B5LMSV5GZSTI8=
X-Google-Smtp-Source: AA0mqf6d8xSqVNDYrjAMV+P3X5ndNEIKHb5m7mAEQC87Kre5WPjHKKPVfkDGDmsP7VMUuy5T/PjdeQ==
X-Received: by 2002:a05:6402:378c:b0:45c:835b:ac66 with SMTP id et12-20020a056402378c00b0045c835bac66mr27764643edb.33.1671221855988;
        Fri, 16 Dec 2022 12:17:35 -0800 (PST)
Received: from [192.168.1.101] ([141.136.89.211])
        by smtp.gmail.com with ESMTPSA id z7-20020aa7d407000000b0046b531fcf9fsm1231417edq.59.2022.12.16.12.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:17:35 -0800 (PST)
Message-ID: <f6b1a1d6-699b-5740-6aa1-6285d673286a@gmail.com>
Date:   Sat, 17 Dec 2022 00:17:30 +0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v1 02/13] net: wwan: tmi: Add buffer management
Content-Language: en-US
To:     =?UTF-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        "linuxwwan@mediatek.com" <linuxwwan@mediatek.com>,
        =?UTF-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        =?UTF-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?UTF-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        =?UTF-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        =?UTF-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        =?UTF-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?UTF-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        =?UTF-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>,
        =?UTF-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?UTF-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
 <20221122111152.160377-3-yanchao.yang@mediatek.com>
 <14db8809-6144-1d10-59e7-298079b2e6e2@gmail.com>
 <a9d4eebb99d53224366c387ae314173b870d134c.camel@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
In-Reply-To: <a9d4eebb99d53224366c387ae314173b870d134c.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Yanchao,

sorry for late response, please find some thoughts below.

On 09.12.2022 14:26, Yanchao Yang (杨彦超) wrote:
> On Sun, 2022-12-04 at 22:58 +0400, Sergey Ryazanov wrote:
>> On 22.11.2022 15:11, Yanchao Yang wrote:
>>> From: MediaTek Corporation <linuxwwan@mediatek.com>
>>>
>>> To malloc I/O memory as soon as possible, buffer management comes
>>> into being.
>>> It creates buffer pools that reserve some buffers through deferred
>>> works when
>>> the driver isn't busy.
>>>
>>> The buffer management provides unified memory allocation/de-
>>> allocation
>>> interfaces for other modules. It supports two buffer types of SKB
>>> and page.
>>> Two reload work queues with different priority values are provided
>>> to meet
>>> various requirements of the control plane and the data plane.
>>>
>>> When the reserved buffer count of the pool is less than a threshold
>>> (default
>>> is 2/3 of the pool size), the reload work will restart to allocate
>>> buffers
>>> from the OS until the buffer pool becomes full. When the buffer
>>> pool fills,
>>> the OS will recycle the buffer freed by the user.
>>>
>>> Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
>>> Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
>>> ---
>>>    drivers/net/wwan/mediatek/Makefile  |   3 +-
>>>    drivers/net/wwan/mediatek/mtk_bm.c  | 369
>>> ++++++++++++++++++++++++++++
>>>    drivers/net/wwan/mediatek/mtk_bm.h  |  79 ++++++
>>>    drivers/net/wwan/mediatek/mtk_dev.c |  11 +-
>>>    drivers/net/wwan/mediatek/mtk_dev.h |   1 +
>>>    5 files changed, 461 insertions(+), 2 deletions(-)
>>>    create mode 100644 drivers/net/wwan/mediatek/mtk_bm.c
>>>    create mode 100644 drivers/net/wwan/mediatek/mtk_bm.h
>>
>> Yanchao, can you share some numbers, how this custom pool is
>> outperform
>> the regular kernel allocator?
> Prepare 2 drivers *.ko for comparison.
> Driver A (following named A):  enable pre-allocate buffer pool.
> Driver B (following named A):  disenable pre-allocate buffer pool. It
> uses kernel API directly (__dev_alloc_skb and netdev_alloc_frag)
> 
> Test Instrument: Keysight UXM TA
> Iperf command:
> Server Command: iperf3 -s -p 5002 -i 1
> Client Command: iperf3 -c 192.168.2.1 -p 5002 -i 1 -w 8M -t 30 -R -P 5
> 
> Test result: Fig 1. A’s TCP DL throughput Fig 2. B’s TCP DL throughput
> (Ref attachment)
> 
>  From the results, it represents that the A’s IP packets throughput
> reaches 7Gbits/sec, while B’s throughput is 4.7Gbits/sec. A’s
> throughput is up about 50% compared with B.
> 
> In addition, from ftrace, it represents following results.
> A: it takes 14.241828s for allocating 33211099 buffers. The average
> time is about 0.4us.
> B: it takes 7.677069s for allocating 10890789 buffers. The average time
> is about 0.7us.

Thank you for this impressive comparison test. There is something to 
think about here.

In a common case, the kernel memory API is fast enough to guarantee 
multi-gigabit throughput. So if some custom code outperforms it, then 
either (a) you have found some corner case where the kernel memory API 
is deadly slow and should be improved, or (b) there is something wrong 
with a driver code. My point is that a driver should not implement 
custom memory management since that leads to a driver complexity without 
any real performance improvement.

The test shows the really significant difference between the custom 
memory pool and the direct kernel API calling. So let's try to figure 
out what is going on.

I assume that the control path (CLDMA) could not cause that much 
performance degradation due to the low control messages traffic. So most 
probably the root cause is somewhere in the data path (DPMAIF). Correct 
me if my assumption is wrong.

Digging deeper into the driver code, I noticed that there actually two 
types of pools (buffers). One pool type contains ready-made skbs, and 
the other contains just page fragments. And both types of pools are 
utilized in the data Rx path. Have you tried measuring which type of 
pool improves performance more significantly?

I also noticed that neither allocated skb nor allocated page fragments 
are freed in the DPMAIF code. So the improvement is not connected to 
optimal caching (i.e. memory reuse). Thus memory allocation improvement 
is most likely caused by avoiding of some contention.

The pool reload is performed in the context of work. And if I am not 
mistaken, then skbs and fragments are also taken from preallocated pools 
in the context of work to reinitialize the BAT (Rx) ring buffer. There 
is no difference in the matter of priority. Both the pool reload and the 
Rx ring buffer reload functions are called with the same priority on an 
arbitrary CPU in the absence of other high priority tasks (e.g. 
tasklets, irq). The only obvious difference is the invocation rate. The 
pool reload operation is triggered as soon as the pool level falls below 
the predefined threshold (currently 67%). While the Rx ring reload 
operation is called on each NAPI poll. Have you considered introducing a 
threshold similar to the pool reload threshold and calling the rx ring 
reload less frequently?

--
Sergey
