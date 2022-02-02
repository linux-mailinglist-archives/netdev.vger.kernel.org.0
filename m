Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E604A72AB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245271AbiBBOEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:04:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234785AbiBBOEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VEgyf6vtWrsSZoHbU3ig5s3KISu2d50UoRzD9lbCZ4=;
        b=WMgb7/+mQhY7G5sVKpt317qqH/8bsZV90QQw2r4ILkyBF/i+0VxsTN4d1XerdlNacSrV1u
        SNzUm1s6K8EvXO7Om/uZNMzmtU9C4tfc4fN93yxVuuP6Yl6CSEm+UtgTjh8wEMAPRKPZmD
        xnmRqvExjZ3aD3a0wVL4eD8VvEnbjMs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-CPUi7pklO_m8RE_Cq78vFQ-1; Wed, 02 Feb 2022 09:04:38 -0500
X-MC-Unique: CPUi7pklO_m8RE_Cq78vFQ-1
Received: by mail-ed1-f69.google.com with SMTP id w23-20020a50d797000000b00406d33c039dso10453232edi.11
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:04:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=/VEgyf6vtWrsSZoHbU3ig5s3KISu2d50UoRzD9lbCZ4=;
        b=Rmyaw2CzZflHFaw5NUoupGIwPhDhHj9pwIsJnAmiz9nu4FfEXTba9U8B09wr6Cdg2e
         Vo19Sk8r//HE2MsSjS8IpTt7+eigOhEOTZ9NC+MaAYjdduWWXUhH52xnFYDg2sMl7WI8
         ZpN7Wo2awTuAxC9sHy7U6TEibeb5tPAJMJzc2IFEUD9zZ7aoHak35Pccb9+LrLn7O0Cu
         UiEKVrDdzRsTilyUhEURR330YEo3aqvI6rrmqK3exB/b8OLUUghTHO/eibS1hZHS1BDf
         uUF4Be6T8gFk+eYW/uFrM2/xzmZLJCYYLltJSzI0FJyOviWLyRJDfhkzezoul1rVZMLM
         FW8Q==
X-Gm-Message-State: AOAM533mFsCrRKTWzF79bmK7gHV1NA7kn50Nu33CVzQ6EdhumHeiIlcw
        R/e9NzxN42KoZPhrGovPGA+FhI3em8OzLnU0eC2p0Yxr/8sJEAbjQ9oTt4GNjidysmJSDfRaM++
        0u9L23KMXFC/7eX38
X-Received: by 2002:a17:907:6d8f:: with SMTP id sb15mr24210679ejc.7.1643810677522;
        Wed, 02 Feb 2022 06:04:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiazXIxmcI/28KNGvqnEFJIrdQwNBTLf/ThcctbX3P0zMk1BhZEvJ/TodVGpp1myrEzYMQoA==
X-Received: by 2002:a17:907:6d8f:: with SMTP id sb15mr24210656ejc.7.1643810677263;
        Wed, 02 Feb 2022 06:04:37 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id qf6sm15824299ejc.49.2022.02.02.06.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 06:04:34 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <33216f8e-0b9c-c701-0cdf-e96229bc03d6@redhat.com>
Date:   Wed, 2 Feb 2022 15:04:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org, hawk@kernel.org
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
 <c7945726-6d6a-2361-3c5a-1f9e3187683a@redhat.com>
 <CALALjgxwkRBFd86=kcOjeF4uvhCgB52gG7ka_e16=Qf-3LQiFQ@mail.gmail.com>
In-Reply-To: <CALALjgxwkRBFd86=kcOjeF4uvhCgB52gG7ka_e16=Qf-3LQiFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/01/2022 22.08, Joe Damato wrote:
> On Thu, Jan 27, 2022 at 12:51 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>> On 26/01/2022 23.48, Joe Damato wrote:
>>> Greetings:
>>>
>>> This series adds some stat counters for the page_pool allocation path which
>>> help to track:
>>>
>>>        - fast path allocations
>>>        - slow path order-0 allocations
>>>        - slow path high order allocations
>>>        - refills which failed due to an empty ptr ring, forcing a slow
>>>          path allocation
>>>        - allocations fulfilled via successful refill
>>>        - pages which cannot be added to the cache because of numa mismatch
>>>          (i.e. waived)
>>>
>>> Some static inline wrappers are provided for accessing these stats. The
>>> intention is that drivers which use the page_pool API can, if they choose,
>>> use this stats API.
>>
>> You are adding (always on) counters to a critical fast-path, that
>> drivers uses for the XDP_DROP use-case.
> 
> If you prefer requiring users explicitly enable these stats, I am
> happy to add a kernel config option (e.g. CONFIG_PAGE_POOL_DEBUG or
> similar) in a v2.
> 
>> I want to see performance measurements as documentation, showing this is
>> not causing a slow-down.
>>
>> I have some performance tests here[1]:
>>    [1]
>> https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/lib
>>
>> Look at:
>>    - bench_page_pool_simple.c and
>>    - bench_page_pool_cross_cpu.c
>>
>> How to use + build this[2]:
>>    [2]
>> https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/build-process.html
> 
> Thanks for the pointers to the benchmarks.
> 
> In general, I noted that the benchmark results varied fairly
> substantially between repeated runs on the same system.
> 
> Results below suggest that:
>     -  bench_page_pool_simple is faster on the test kernel, and
>     - bench_page_pool_cross_cpu faster on the control
> 
> Subsequent runs of bench_page_pool_cross_cpu on the control, however,
> reveal *much* slower results than shown below.
> 
> Test system:
>    - 2 x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
>    - 2 numa zones, with 18 cores per zone and 2 threads per core
> 
> Control kernel: built from net-next at commit e2cf07654efb ("ptp:
> replace snprintf with sysfs_emit").
> Test kernel: This series applied on top of control kernel mentioned above.
> 
> Raw output from dmesg for control [1] and test [2] kernel summarized below:
> 
> bench_page_pool_simple
>    - run with default options (i.e. "sudo mod probe bench_page_pool_simple").
> 
> Control:
> 
> Type:for_loop Per elem: 0 cycles(tsc) 0.334 ns (step:0)
> Type:atomic_inc Per elem: 13 cycles(tsc) 6.021 ns (step:0)
> Type:lock Per elem: 31 cycles(tsc) 13.514 ns (step:0)
> 
> Type:no-softirq-page_pool01 Per elem: 44 cycles(tsc) 19.549 ns (step:0)
> Type:no-softirq-page_pool02 Per elem: 45 cycles(tsc) 19.658 ns (step:0)
> Type:no-softirq-page_pool03 Per elem: 118 cycles(tsc) 51.638 ns (step:0)
> 
> Type:tasklet_page_pool01_fast_path Per elem: 17 cycles(tsc) 7.472 ns (step:0)
> Type:tasklet_page_pool02_ptr_ring Per elem: 42 cycles(tsc) 18.585 ns (step:0)
> Type:tasklet_page_pool03_slow Per elem: 109 cycles(tsc) 47.807 ns (step:0)
> 
> Test:
> 
> Type:for_loop Per elem: 0 cycles(tsc) 0.334 ns (step:0)
> Type:atomic_inc Per elem: 14 cycles(tsc) 6.195 ns (step:0)
> Type:lock Per elem: 31 cycles(tsc) 13.827 ns (step:0)
> 
> Type:no-softirq-page_pool01 Per elem: 44 cycles(tsc) 19.561 ns (step:0)
> Type:no-softirq-page_pool02 Per elem: 45 cycles(tsc) 19.700 ns (step:0)
> Type:no-softirq-page_pool03 Per elem: 108 cycles(tsc) 47.186 ns (step:0)
> 
> Type:tasklet_page_pool01_fast_path Per elem: 12 cycles(tsc) 5.447 ns (step:0)

Watch out for the: measurement period time:0.054478253 (taken from [2])

If the measurement period becomes too small, you/we cannot use the 
results.  Perhaps I've set the default 'loops' variable too low, for 
these modern systems.  Hint it is adjust as module parameter 'loops'.



> Type:tasklet_page_pool02_ptr_ring Per elem: 42 cycles(tsc) 18.501 ns (step:0)
> Type:tasklet_page_pool03_slow Per elem: 106 cycles(tsc) 46.313 ns (step:0)
> 
> bench_page_pool_cross_cpu
>    - run with default options (i.e. "sudo mod probe bench_page_pool_cross_cpu").
> 
> Control:
> Type:page_pool_cross_cpu CPU(0) 1795 cycles(tsc) 782.567 ns (step:2)
> Type:page_pool_cross_cpu CPU(1) 1921 cycles(tsc) 837.435 ns (step:2)
> Type:page_pool_cross_cpu CPU(2) 960 cycles(tsc) 418.758 ns (step:2)
> Sum Type:page_pool_cross_cpu Average: 1558 cycles(tsc) CPUs:3 step:2
> 
> Test:
> Type:page_pool_cross_cpu CPU(0) 2411 cycles(tsc) 1051.037 ns (step:2)
> Type:page_pool_cross_cpu CPU(1) 2467 cycles(tsc) 1075.204 ns (step:2)
> Type:page_pool_cross_cpu CPU(2) 1233 cycles(tsc) 537.629 ns (step:2)
> Type:page_pool_cross_cpu Average: 2037 cycles(tsc) CPUs:3 step:2

I think the effect you are seeing here is because you placed your stats 
struct on the a cache-line that is also used by remote CPUs 
freeing/recycling page'es back to the page_pool.


> 
> [1]: https://gist.githubusercontent.com/jdamato-fsly/385806f06cb95c61ff8cecf7a3645e75/raw/886e3208f5b9c47abdd59bdaa7ecf27994f477b1/page_pool_bench_control
> [2]: https://gist.githubusercontent.com/jdamato-fsly/385806f06cb95c61ff8cecf7a3645e75/raw/886e3208f5b9c47abdd59bdaa7ecf27994f477b1/page_pool_bench_TESTKERNEL
> 
> 
>>> It assumed that the API consumer will ensure the page_pool is not destroyed
>>> during calls to the stats API.
>>>
>>> If this series is accepted, I'll submit a follow up patch which will export
>>> these stats per RX-ring via ethtool in a driver which uses the page_pool
>>> API.
>>>
>>> Joe Damato (6):
>>>     net: page_pool: Add alloc stats and fast path stat
>>>     net: page_pool: Add a stat for the slow alloc path
>>>     net: page_pool: Add a high order alloc stat
>>>     net: page_pool: Add stat tracking empty ring
>>>     net: page_pool: Add stat tracking cache refills.
>>>     net: page_pool: Add a stat tracking waived pages.
>>>
>>>    include/net/page_pool.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>    net/core/page_pool.c    | 15 +++++++--
>>>    2 files changed, 94 insertions(+), 3 deletions(-)
>>>
>>
> 

