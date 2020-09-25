Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A3278F9F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgIYRa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgIYRa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:30:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC83C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:30:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k15so4465650wrn.10
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cVCi5U5UDi+O6E7dwZje87schtHTk4EklzUmV7uiVVY=;
        b=iq0mTrIGOyNVugbYOHheGhfC7a5i/A71Vh0oD1bfXuvWHpjTcfnLdjidtDIsBqt964
         c6+GTSy5JJbf+WylcgxQV9Wtk6mKT+i4rorxH1TsxYFXo6kXfla1fUpTl1XT0oPY+USi
         vyZuq3JbVJHDcVFCngNF3rp+jR6wGsZkJKq9R6hhQSAE6NhmWSngTMU731GTNuzHRdPw
         KUasOYuHAhahXAMT+B+wZ135Sg5zWXDAhnn7NLRHGAR51yb7Fe8Ptwn1OjkF31qZFaVn
         TjwCKbmRNf31COdjxFEWTGu9i7jrm9luesOooc8Rri+edV6j7vV8wVopU1/V2hZ7vyWb
         5HFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cVCi5U5UDi+O6E7dwZje87schtHTk4EklzUmV7uiVVY=;
        b=Y92c2NoVpgvkr2HY9oUYWUAi7hrcfUl0KMsMZX0cDPQfLFSJbR7oxudbcQMwQKdPKE
         RBND45LKs6bT0vMaSAvPcyvuaoaWKi1A/LNTdArl3AZ5Jnp0GI0uy8PCAYp6M0SI78cZ
         +t6LSnIJUTY3l+j/vLhYxIcAvdxF8+W2vamXa+wh/JJQcYmBEGQKkSbvu3qjqUG1mvGe
         9xhpl1X8GJ8pizQrEAJV0X0CeVKzGAreX8u6eiReWR2oJrajX4L5PYXy9fXl/Hsao12z
         W0dBdUuoeCVz4zsMKwAfXQWZnP+wLY/p3G1xGB+hqysj6EwJPooJQSBhXpAvMQOGqmww
         HpmA==
X-Gm-Message-State: AOAM532yQWZlBVzk7FlcYFFW/8GtX0JPl2Y0Ht3YUiK8FLD15a/H0n3+
        S1F1cxXQIPOzNsXCrAEOzKA=
X-Google-Smtp-Source: ABdhPJxKb6jA+pWmKQUezM4dVUvunOcKkA6Z8oEJAmCA1B6VwrfCr2t7miL+7tBo/rhuwHrLqJUHRw==
X-Received: by 2002:adf:ef45:: with SMTP id c5mr5478844wrp.37.1601055024191;
        Fri, 25 Sep 2020 10:30:24 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.173.126])
        by smtp.gmail.com with ESMTPSA id v9sm4044266wrv.35.2020.09.25.10.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 10:30:23 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Wei Wang <weiwan@google.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <20200914172453.1833883-1-weiwan@google.com>
 <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
 <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e8371549-30e9-b6cb-7d44-3325f9311c24@gmail.com>
Date:   Fri, 25 Sep 2020 19:30:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/20 7:15 PM, Wei Wang wrote:
> On Fri, Sep 25, 2020 at 6:48 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
>>
>> On Mon, Sep 14, 2020 at 7:26 PM Wei Wang <weiwan@google.com> wrote:
>>>
>>> The idea of moving the napi poll process out of softirq context to a
>>> kernel thread based context is not new.
>>> Paolo Abeni and Hannes Frederic Sowa has proposed patches to move napi
>>> poll to kthread back in 2016. And Felix Fietkau has also proposed
>>> patches of similar ideas to use workqueue to process napi poll just a
>>> few weeks ago.
>>>
>>> The main reason we'd like to push forward with this idea is that the
>>> scheduler has poor visibility into cpu cycles spent in softirq context,
>>> and is not able to make optimal scheduling decisions of the user threads.
>>> For example, we see in one of the application benchmark where network
>>> load is high, the CPUs handling network softirqs has ~80% cpu util. And
>>> user threads are still scheduled on those CPUs, despite other more idle
>>> cpus available in the system. And we see very high tail latencies. In this
>>> case, we have to explicitly pin away user threads from the CPUs handling
>>> network softirqs to ensure good performance.
>>> With napi poll moved to kthread, scheduler is in charge of scheduling both
>>> the kthreads handling network load, and the user threads, and is able to
>>> make better decisions. In the previous benchmark, if we do this and we
>>> pin the kthreads processing napi poll to specific CPUs, scheduler is
>>> able to schedule user threads away from these CPUs automatically.
>>>
>>> And the reason we prefer 1 kthread per napi, instead of 1 workqueue
>>> entity per host, is that kthread is more configurable than workqueue,
>>> and we could leverage existing tuning tools for threads, like taskset,
>>> chrt, etc to tune scheduling class and cpu set, etc. Another reason is
>>> if we eventually want to provide busy poll feature using kernel threads
>>> for napi poll, kthread seems to be more suitable than workqueue.
>>>
>>> In this patch series, I revived Paolo and Hannes's patch in 2016 and
>>> left them as the first 2 patches. Then there are changes proposed by
>>> Felix, Jakub, Paolo and myself on top of those, with suggestions from
>>> Eric Dumazet.
>>>
>>> In terms of performance, I ran tcp_rr tests with 1000 flows with
>>> various request/response sizes, with RFS/RPS disabled, and compared
>>> performance between softirq vs kthread. Host has 56 hyper threads and
>>> 100Gbps nic.
>>>
>>>         req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
>>> softirq   1B/1B   2.19M   284us       987us      1.1ms      1.56ms
>>> kthread   1B/1B   2.14M   295us       987us      1.0ms      1.17ms
>>>
>>> softirq 5KB/5KB   1.31M   869us      1.06ms     1.28ms      2.38ms
>>> kthread 5KB/5KB   1.32M   878us      1.06ms     1.26ms      1.66ms
>>>
>>> softirq 1MB/1MB  10.78K   84ms       166ms      234ms       294ms
>>> kthread 1MB/1MB  10.83K   82ms       173ms      262ms       320ms
>>>
>>> I also ran one application benchmark where the user threads have more
>>> work to do. We do see good amount of tail latency reductions with the
>>> kthread model.
>>
>> I really like this RFC and would encourage you to submit it as a
>> patch. Would love to see it make it into the kernel.
>>
> 
> Thanks for the feedback! I am preparing an official patchset for this
> and will send them out soon.
> 
>> I see the same positive effects as you when trying it out with AF_XDP
>> sockets. Made some simple experiments where I sent 64-byte packets to
>> a single AF_XDP socket. Have not managed to figure out how to do
>> percentiles on my load generator, so this is going to be min, avg and
>> max only. The application using the AF_XDP socket just performs a mac
>> swap on the packet and sends it back to the load generator that then
>> measures the round trip latency. The kthread is taskset to the same
>> core as ksoftirqd would run on. So in each experiment, they always run
>> on the same core id (which is not the same as the application).
>>
>> Rate 12 Mpps with 0% loss.
>>               Latencies (us)         Delay Variation between packets
>>           min    avg    max      avg   max
>> sofirq  11.0  17.1   78.4      0.116  63.0
>> kthread 11.2  17.1   35.0     0.116  20.9
>>
>> Rate ~58 Mpps (Line rate at 40 Gbit/s) with substantial loss
>>               Latencies (us)         Delay Variation between packets
>>           min    avg    max      avg   max
>> softirq  87.6  194.9  282.6    0.062  25.9
>> kthread  86.5  185.2  271.8    0.061  22.5
>>
>> For the last experiment, I also get 1.5% to 2% higher throughput with
>> your kthread approach. Moreover, just from the per-second throughput
>> printouts from my application, I can see that the kthread numbers are
>> more stable. The softirq numbers can vary quite a lot between each
>> second, around +-3%. But for the kthread approach, they are nice and
>> stable. Have not examined why.
>>
> 
> Thanks for sharing the results!
> 
>> One thing I noticed though, and I do not know if this is an issue, is
>> that the switching between the two modes does not occur at high packet
>> rates. I have to lower the packet rate to something that makes the
>> core work less than 100% for it to switch between ksoftirqd to kthread
>> and vice versa. They just seem too busy to switch at 100% load when
>> changing the "threaded" sysfs variable.
>>
> 
> I think the reason for this is when load is high, napi_poll() probably
> always exhausts the predefined napi->weight. So it will keep
> re-polling in the current context. The switch could only happen the
> next time ___napi_schedule() is called.

A similar problem happens when /proc/irq/{..}/smp_affinity is changed.

Few drivers actually detect the affinity has changed (and does not include
current cpu), and force an napi poll complete/exit, so that a new hardware
interrupt is allowed and routed to another cpu.

Presumably the softirq -> kthread transition could be enforced if really needed.
