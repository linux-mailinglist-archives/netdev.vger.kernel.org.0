Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962E02789E9
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgIYNss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgIYNsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:48:47 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478DEC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:48:47 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id bw23so1890005pjb.2
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6xi7l2Bwv0IuJbYNmOCbiDWmMdu8+cEQSuu40wuaof0=;
        b=HlfxXxLnbVyB5DY/teSlwzkTroZy/p8kavMm90cfuo+tT9ImS//J0FNYmo9oUETzZc
         3Ttqvj9AN9D7+S8NSk8kAe93MrMQNDJhxh6unnlEH7QeiakbEv4wl6QOC5vxTT3j4MAb
         qxGr0Duw0HGtlrnO9kQR9T9rvBicHhaCjItCdNvWveNdvfSBJXr02TSZWt1+XHx+J0Di
         a3Zd+77RrcsYirpXEO3xkSs6WrXhTxEs60313PElnm4S8kxwcBiAk8YSqbHaDZgONzks
         EoKmj69hgwkdYk3gm3MmBUNjYuooDLIvXnhivUx7m2FPKLSX1DgoVDta3jOhAf3BJceZ
         kGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6xi7l2Bwv0IuJbYNmOCbiDWmMdu8+cEQSuu40wuaof0=;
        b=JDn0eNiWUsk28DuvyAA4xciSj8+v/xoUiXwfpSCk+uoFUMJ8Tpo+7QrTIRWLSOrk2J
         nQe8kMC0h6R0pwQapNRpsrgBNKq9Z4xNR7UYCGKGEuSTfx9sV4hWP6Y54cWZ35JIFwiB
         49Da2j2y6pOGfV6obHzaGNsnQ7hW8av5MnzMAjmRPuSKvM5Bk65RTY50sj2iNrSOLloR
         YEJikmvmxvIk+7Glh56nD4R5eFh0QiTQK2O7NcinOxzExl/SCAMGhsYdeTwj1z3FlXRs
         K9g1h76D00HRtivG7/LeUIRZAd6iHH+YnujbmXB10ktkFY4ZqdeQigDZ/DUy2oBtfxtV
         HEIA==
X-Gm-Message-State: AOAM532z8u8d2YHrlEFsYdxlb3vIC2qZ+EGdpVwMK8xUWEUOId1r+4E2
        dMRqUI0DaHunK/waMsX9+YKcnR4lCv0tfFHg6E0=
X-Google-Smtp-Source: ABdhPJz2FYVvRaqytr69buFHRIaDcHrfCuaFd6Pn0iKd6SUAo4FZuqfM9F+iuOuHMmXESsEYmzDRHDUS/dWZHzlr6LM=
X-Received: by 2002:a17:90a:e207:: with SMTP id a7mr412825pjz.117.1601041726668;
 Fri, 25 Sep 2020 06:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 25 Sep 2020 15:48:35 +0200
Message-ID: <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 7:26 PM Wei Wang <weiwan@google.com> wrote:
>
> The idea of moving the napi poll process out of softirq context to a
> kernel thread based context is not new.
> Paolo Abeni and Hannes Frederic Sowa has proposed patches to move napi
> poll to kthread back in 2016. And Felix Fietkau has also proposed
> patches of similar ideas to use workqueue to process napi poll just a
> few weeks ago.
>
> The main reason we'd like to push forward with this idea is that the
> scheduler has poor visibility into cpu cycles spent in softirq context,
> and is not able to make optimal scheduling decisions of the user threads.
> For example, we see in one of the application benchmark where network
> load is high, the CPUs handling network softirqs has ~80% cpu util. And
> user threads are still scheduled on those CPUs, despite other more idle
> cpus available in the system. And we see very high tail latencies. In this
> case, we have to explicitly pin away user threads from the CPUs handling
> network softirqs to ensure good performance.
> With napi poll moved to kthread, scheduler is in charge of scheduling both
> the kthreads handling network load, and the user threads, and is able to
> make better decisions. In the previous benchmark, if we do this and we
> pin the kthreads processing napi poll to specific CPUs, scheduler is
> able to schedule user threads away from these CPUs automatically.
>
> And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> entity per host, is that kthread is more configurable than workqueue,
> and we could leverage existing tuning tools for threads, like taskset,
> chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> if we eventually want to provide busy poll feature using kernel threads
> for napi poll, kthread seems to be more suitable than workqueue.
>
> In this patch series, I revived Paolo and Hannes's patch in 2016 and
> left them as the first 2 patches. Then there are changes proposed by
> Felix, Jakub, Paolo and myself on top of those, with suggestions from
> Eric Dumazet.
>
> In terms of performance, I ran tcp_rr tests with 1000 flows with
> various request/response sizes, with RFS/RPS disabled, and compared
> performance between softirq vs kthread. Host has 56 hyper threads and
> 100Gbps nic.
>
>         req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
> softirq   1B/1B   2.19M   284us       987us      1.1ms      1.56ms
> kthread   1B/1B   2.14M   295us       987us      1.0ms      1.17ms
>
> softirq 5KB/5KB   1.31M   869us      1.06ms     1.28ms      2.38ms
> kthread 5KB/5KB   1.32M   878us      1.06ms     1.26ms      1.66ms
>
> softirq 1MB/1MB  10.78K   84ms       166ms      234ms       294ms
> kthread 1MB/1MB  10.83K   82ms       173ms      262ms       320ms
>
> I also ran one application benchmark where the user threads have more
> work to do. We do see good amount of tail latency reductions with the
> kthread model.

I really like this RFC and would encourage you to submit it as a
patch. Would love to see it make it into the kernel.

I see the same positive effects as you when trying it out with AF_XDP
sockets. Made some simple experiments where I sent 64-byte packets to
a single AF_XDP socket. Have not managed to figure out how to do
percentiles on my load generator, so this is going to be min, avg and
max only. The application using the AF_XDP socket just performs a mac
swap on the packet and sends it back to the load generator that then
measures the round trip latency. The kthread is taskset to the same
core as ksoftirqd would run on. So in each experiment, they always run
on the same core id (which is not the same as the application).

Rate 12 Mpps with 0% loss.
              Latencies (us)         Delay Variation between packets
          min    avg    max      avg   max
sofirq  11.0  17.1   78.4      0.116  63.0
kthread 11.2  17.1   35.0     0.116  20.9

Rate ~58 Mpps (Line rate at 40 Gbit/s) with substantial loss
              Latencies (us)         Delay Variation between packets
          min    avg    max      avg   max
softirq  87.6  194.9  282.6    0.062  25.9
kthread  86.5  185.2  271.8    0.061  22.5

For the last experiment, I also get 1.5% to 2% higher throughput with
your kthread approach. Moreover, just from the per-second throughput
printouts from my application, I can see that the kthread numbers are
more stable. The softirq numbers can vary quite a lot between each
second, around +-3%. But for the kthread approach, they are nice and
stable. Have not examined why.

One thing I noticed though, and I do not know if this is an issue, is
that the switching between the two modes does not occur at high packet
rates. I have to lower the packet rate to something that makes the
core work less than 100% for it to switch between ksoftirqd to kthread
and vice versa. They just seem too busy to switch at 100% load when
changing the "threaded" sysfs variable.

Thank you for working on this feature.


/Magnus


> Paolo Abeni (2):
>   net: implement threaded-able napi poll loop support
>   net: add sysfs attribute to control napi threaded mode
> Felix Fietkau (1):
>   net: extract napi poll functionality to __napi_poll()
> Jakub Kicinski (1):
>   net: modify kthread handler to use __napi_poll()
> Paolo Abeni (1):
>   net: process RPS/RFS work in kthread context
> Wei Wang (1):
>   net: improve napi threaded config
>
>  include/linux/netdevice.h |   6 ++
>  net/core/dev.c            | 146 +++++++++++++++++++++++++++++++++++---
>  net/core/net-sysfs.c      |  99 ++++++++++++++++++++++++++
>  3 files changed, 242 insertions(+), 9 deletions(-)
>
> --
> 2.28.0.618.gf4bc123cb7-goog
>
