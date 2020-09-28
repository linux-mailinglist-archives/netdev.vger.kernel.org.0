Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393AC27B44A
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgI1SVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgI1SVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:21:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D10C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 11:21:11 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so1577297pgl.9
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xOwqOvhc7n1MwxHIRp39JEG4AQRBzknZ/xKxDeYI3FM=;
        b=SBfVRopgTj7H75hP6ZVnK9krmLN4wKsV3m1J+cw3F0nTss2bfbkiQ28+8Ongjz5KFN
         R7ajBl5NdS8mjiempfiqX4bja9A9826tRDpiACP8BslgOnxPBlZQc4kMkE/nCPbkobP0
         S+3fO+AhGPBX6PdYUqn4nFfcM6IaQ4VxwPa3EaTFqLBBKknkxhq8qnB44z52rtS5YPqd
         pYo4b2UQWfthEUdJBP8SUepMFTRMX9tnK6jPS3zhIk/o67Yqdmt4OcuSHbhKUdPoPVM6
         ZlQpNEVUbdI/kUHel+RnH3haMH0YPCGgRMviflZLsTSNdl7mcT7m8LZ48RhcUGL0jRRe
         zFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xOwqOvhc7n1MwxHIRp39JEG4AQRBzknZ/xKxDeYI3FM=;
        b=QfDLCL3fF8lkvrzDnpw1CpSgfaWNNlPkBwfy2vCejJrT/YLBU3DDL6oE+gZHpIrDUa
         fw0yUCNJHP6vxHDtGpfPiV+/mO4LS1Ay2jXHSgVHp1fjYYQke/SWhTShk0lFE6MI+dgT
         tOqgmm630RsvrYu5YoeywpZB8czi314M+sd5/OoEj1PuO5M0HOs1+/4RHpS5Q/fnNExH
         iusUMe7bBR/LaUAgto1eWZjZECQUJ0eaGiommdc8iYCsiMXX9Gofn67uzA+XjFFbYd40
         GSm4U+0Dh/e/xeKLqloWmXdJzPwKLnOjTN3SrycrNiJP7qw7RKD1wA8MQInlb2pv+RCx
         9YKA==
X-Gm-Message-State: AOAM533YSbsP3vOscHEQfcwoPAKaWuU8OpvAcS/LerDfdYScmpxkWdG/
        AmDm+PUmlaBlC5APtJXcci3foJv5sPBiTOuERPWN0DF/n9n8RQ==
X-Google-Smtp-Source: ABdhPJwD255iGvIAJgzseTSMCPNpTlLfNXz2arLwISrjfMcP04GRik7gmTJKR91kaU6s4IX/RILZtkDfQzcKs42eRNs=
X-Received: by 2002:a92:c94a:: with SMTP id i10mr2348257ilq.267.1601316935628;
 Mon, 28 Sep 2020 11:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
In-Reply-To: <CANn89iJDM97U15Znrx4k4bOFKunQp7dwJ9mtPwvMmB4S+rSSbA@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 28 Sep 2020 11:15:24 -0700
Message-ID: <CAEA6p_Dx8KVjLnBOdrNTqDJBu+4z5bF51yc7KO9OzqjU0Hqy4Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:43 AM Eric Dumazet <edumazet@google.com> wrote:
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
>
>
> Wei, this is a very nice work.
>
> Please re-send it without the RFC tag, so that we can hopefully merge it ASAP.
>
> Thanks !

Thank you Eric! Will prepare the official patch series and send it out soon.
