Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9953F278F6F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgIYRPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgIYRPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:15:38 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1487C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:15:38 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id m17so3628216ioo.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CbkeH+x71+kZnXzZbjxm42MNEqtZ6/Sb6RAj3jrS+U8=;
        b=LEqILl8w6YXAYUPPEZO7zz41O02ogSIEP9ZQu/aqfkm1jqs4RCnHTNmj1C5vHERFXk
         +gH+uKQLBkar1lxbxgerITa2jYivB+EB6u0BFnNCpKvmX4fWbnQz79RP3RZ+1q4jqmJ5
         rEAQ7Pmx/bRLlevzRdKqx84ApEGijCkpza352saaS4YWeKxqb52dBGqL3CLY5cfsShGn
         O6yTFkWCF30tWIdGs/SF8Fx6ZgNUxjrSWK2Y/Ba+zbnPAUMfAx3R+YHVSeBPkZKMZhVL
         /M9dWSF+CcAjTx/qsbxOwDSPAe1LGrKl3NNpY/zBXQ5WMFBjETUtowcnJcZI4PnVf6ji
         ZPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CbkeH+x71+kZnXzZbjxm42MNEqtZ6/Sb6RAj3jrS+U8=;
        b=NJAU2xs99SujzJvOhVY8wAnJzILKTRRqStRVd+6EU9zoIrcxm8u2O0UYoZhIOmvm4d
         hBk16FayMy0Zbr0IU+1i8MPE6yZ2bbpL6ZbE//1YWN15b4Z9L/sY4JCLWjy5QsHd2Dlc
         +sIERv+JrqNFj7ToSXlKCV6D9CvWgWITnBzMO0ylKTFOcMKjmGb9ldRfGd8EwvjtlTRy
         jtYs3i4MYy9tE/7giamoO+GO7YdjvipYhxXVz4mjbIqXYKsgQcnS9kmwhgYj31Vt4orQ
         YVlbNl8a+8Ran0gD8pZF4vETcQYbore+YPFEsSCEXKwmDbtaARwgG1RMkGpxpSV6MiS0
         hd6A==
X-Gm-Message-State: AOAM533cCrYCUwLM3E4bo5atevDSk5vZVvNcNKFgTisaoM/EvtBpx3Vl
        qbZOmc7cFkackraQ6xDekK30BE1f79LxUyqJwG8SmQ==
X-Google-Smtp-Source: ABdhPJwmP4gyOSnssfo31rBALNs4RmOpYKfZDIKev+ByX+RzmxfsPldwz0ieFj97TKrR9rdC2iKwM97yY1E18BwOxyE=
X-Received: by 2002:a02:a816:: with SMTP id f22mr80607jaj.118.1601054137456;
 Fri, 25 Sep 2020 10:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
In-Reply-To: <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 25 Sep 2020 10:15:25 -0700
Message-ID: <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
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

On Fri, Sep 25, 2020 at 6:48 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Mon, Sep 14, 2020 at 7:26 PM Wei Wang <weiwan@google.com> wrote:
> >
> > The idea of moving the napi poll process out of softirq context to a
> > kernel thread based context is not new.
> > Paolo Abeni and Hannes Frederic Sowa has proposed patches to move napi
> > poll to kthread back in 2016. And Felix Fietkau has also proposed
> > patches of similar ideas to use workqueue to process napi poll just a
> > few weeks ago.
> >
> > The main reason we'd like to push forward with this idea is that the
> > scheduler has poor visibility into cpu cycles spent in softirq context,
> > and is not able to make optimal scheduling decisions of the user threads.
> > For example, we see in one of the application benchmark where network
> > load is high, the CPUs handling network softirqs has ~80% cpu util. And
> > user threads are still scheduled on those CPUs, despite other more idle
> > cpus available in the system. And we see very high tail latencies. In this
> > case, we have to explicitly pin away user threads from the CPUs handling
> > network softirqs to ensure good performance.
> > With napi poll moved to kthread, scheduler is in charge of scheduling both
> > the kthreads handling network load, and the user threads, and is able to
> > make better decisions. In the previous benchmark, if we do this and we
> > pin the kthreads processing napi poll to specific CPUs, scheduler is
> > able to schedule user threads away from these CPUs automatically.
> >
> > And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> > entity per host, is that kthread is more configurable than workqueue,
> > and we could leverage existing tuning tools for threads, like taskset,
> > chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> > if we eventually want to provide busy poll feature using kernel threads
> > for napi poll, kthread seems to be more suitable than workqueue.
> >
> > In this patch series, I revived Paolo and Hannes's patch in 2016 and
> > left them as the first 2 patches. Then there are changes proposed by
> > Felix, Jakub, Paolo and myself on top of those, with suggestions from
> > Eric Dumazet.
> >
> > In terms of performance, I ran tcp_rr tests with 1000 flows with
> > various request/response sizes, with RFS/RPS disabled, and compared
> > performance between softirq vs kthread. Host has 56 hyper threads and
> > 100Gbps nic.
> >
> >         req/resp   QPS   50%tile    90%tile    99%tile    99.9%tile
> > softirq   1B/1B   2.19M   284us       987us      1.1ms      1.56ms
> > kthread   1B/1B   2.14M   295us       987us      1.0ms      1.17ms
> >
> > softirq 5KB/5KB   1.31M   869us      1.06ms     1.28ms      2.38ms
> > kthread 5KB/5KB   1.32M   878us      1.06ms     1.26ms      1.66ms
> >
> > softirq 1MB/1MB  10.78K   84ms       166ms      234ms       294ms
> > kthread 1MB/1MB  10.83K   82ms       173ms      262ms       320ms
> >
> > I also ran one application benchmark where the user threads have more
> > work to do. We do see good amount of tail latency reductions with the
> > kthread model.
>
> I really like this RFC and would encourage you to submit it as a
> patch. Would love to see it make it into the kernel.
>

Thanks for the feedback! I am preparing an official patchset for this
and will send them out soon.

> I see the same positive effects as you when trying it out with AF_XDP
> sockets. Made some simple experiments where I sent 64-byte packets to
> a single AF_XDP socket. Have not managed to figure out how to do
> percentiles on my load generator, so this is going to be min, avg and
> max only. The application using the AF_XDP socket just performs a mac
> swap on the packet and sends it back to the load generator that then
> measures the round trip latency. The kthread is taskset to the same
> core as ksoftirqd would run on. So in each experiment, they always run
> on the same core id (which is not the same as the application).
>
> Rate 12 Mpps with 0% loss.
>               Latencies (us)         Delay Variation between packets
>           min    avg    max      avg   max
> sofirq  11.0  17.1   78.4      0.116  63.0
> kthread 11.2  17.1   35.0     0.116  20.9
>
> Rate ~58 Mpps (Line rate at 40 Gbit/s) with substantial loss
>               Latencies (us)         Delay Variation between packets
>           min    avg    max      avg   max
> softirq  87.6  194.9  282.6    0.062  25.9
> kthread  86.5  185.2  271.8    0.061  22.5
>
> For the last experiment, I also get 1.5% to 2% higher throughput with
> your kthread approach. Moreover, just from the per-second throughput
> printouts from my application, I can see that the kthread numbers are
> more stable. The softirq numbers can vary quite a lot between each
> second, around +-3%. But for the kthread approach, they are nice and
> stable. Have not examined why.
>

Thanks for sharing the results!

> One thing I noticed though, and I do not know if this is an issue, is
> that the switching between the two modes does not occur at high packet
> rates. I have to lower the packet rate to something that makes the
> core work less than 100% for it to switch between ksoftirqd to kthread
> and vice versa. They just seem too busy to switch at 100% load when
> changing the "threaded" sysfs variable.
>

I think the reason for this is when load is high, napi_poll() probably
always exhausts the predefined napi->weight. So it will keep
re-polling in the current context. The switch could only happen the
next time ___napi_schedule() is called.

> Thank you for working on this feature.
>
>
> /Magnus
>
>
> > Paolo Abeni (2):
> >   net: implement threaded-able napi poll loop support
> >   net: add sysfs attribute to control napi threaded mode
> > Felix Fietkau (1):
> >   net: extract napi poll functionality to __napi_poll()
> > Jakub Kicinski (1):
> >   net: modify kthread handler to use __napi_poll()
> > Paolo Abeni (1):
> >   net: process RPS/RFS work in kthread context
> > Wei Wang (1):
> >   net: improve napi threaded config
> >
> >  include/linux/netdevice.h |   6 ++
> >  net/core/dev.c            | 146 +++++++++++++++++++++++++++++++++++---
> >  net/core/net-sysfs.c      |  99 ++++++++++++++++++++++++++
> >  3 files changed, 242 insertions(+), 9 deletions(-)
> >
> > --
> > 2.28.0.618.gf4bc123cb7-goog
> >
