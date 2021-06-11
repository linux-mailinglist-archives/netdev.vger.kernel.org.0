Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA573A48D3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 20:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFKSsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 14:48:19 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:33502 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFKSsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 14:48:18 -0400
Received: by mail-pj1-f48.google.com with SMTP id k22-20020a17090aef16b0290163512accedso7701138pjz.0;
        Fri, 11 Jun 2021 11:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ks2AqW9cDJsFT7c7uP3+IJTIHt4mIVoxcBhjJ2KbT6I=;
        b=gopHh/zOTYiyhfqVK/dB9u7LEy0YsPawdh8u/sBuMf9iCIBu5PjMKbWyHLi39JbIGu
         EgEGxA+tdaF69BF4iflulPViRG/+ZvTh6KdsoRNREqZeaCim28yyjkJAzjfMAGj8LHya
         ES8eusN5bPgzm/gI339bDp0RQFZMRv/ZtaI7fxME+2xHmknpBf/IlLIZnMVEo2sqmG3Q
         ApRcJnkjmBfVUGoSP+Odaf1YhX0gmFqrmc+TlCPePuhJQo2jcsY4gD5b2jm9DEnTLVBe
         BgkKVLpBb1s8Kw7PiEp/mETVXnbFyFKPZZt6Uaacwai6s69qouDuLwkjzkGgMJtvvw3e
         FFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ks2AqW9cDJsFT7c7uP3+IJTIHt4mIVoxcBhjJ2KbT6I=;
        b=D3QjPPrwI0GbV2b0OMxw4XgWTBJiyGiXcK6KjyL0v/YVNaVBncV4BlQk8upaGRMIIz
         +9fHUl5/f0HEKmfGGNuSa3olyNKa3jtzVyQflgzy04sXD4EmLtKyLlOsbzBO8WCcz589
         CezwvTZP3V1h9MS2qm9KO0bnTGWc9axMFiLZsP6yKEgNSr6idTYtp0OKWD/+LeYndfEf
         Wm0TxZmP3l4rpHu9Xqcfu8JLmCxP93sYLpkas4IKYlAKuaaHIFMrKPKFLfkokw83Th9B
         mCSlxLQORKTPvcjP1LVx1Udav253kD7Xn0utgv0mIgfMU9RmtPc6/pFVuu1pYnmPdu2W
         6TUw==
X-Gm-Message-State: AOAM533BYJVsRNfcKPBGKND6CE+9wie7dRSOQwBx4XTLER63zv2I8TJF
        KEn8oKCZiUvxGvT36C7vIU8=
X-Google-Smtp-Source: ABdhPJzweqY6YbUF1Q5duWsvMgTHsOjDM0sYYZs5CoOKCvx3pSBzKaLydwMK2vsUMk5dlbl2oijf/A==
X-Received: by 2002:a17:90b:152:: with SMTP id em18mr5820732pjb.96.1623437120301;
        Fri, 11 Jun 2021 11:45:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e168])
        by smtp.gmail.com with ESMTPSA id t143sm6804025pgb.93.2021.06.11.11.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 11:45:19 -0700 (PDT)
Date:   Fri, 11 Jun 2021 11:45:16 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210611184516.tpjvlaxjc4zdeqe6@ast-mbp.dhcp.thefacebook.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
 <CAM_iQpW=a_ukO574qtZ6m4rqo2FrQifoGC1jcrd7yWK=6WWg1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpW=a_ukO574qtZ6m4rqo2FrQifoGC1jcrd7yWK=6WWg1w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 11:42:24PM -0700, Cong Wang wrote:
> On Thu, Jun 10, 2021 at 9:27 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>

Please stick to one email thread in the future, ok?

I'll consolidate them here:

> What is your use case to justify your own code? Asking because
> you deny mine, so clearly my use case is not yours.

I mentioned several use cases in the prior threads.
tldr: any periodic event in tracing, networking, security.
Garbage collection falls into this category as well, but please internalize
that implementing conntrack as it is today in the kernel is an explicit non-goal.

> And more importantly, why not just use BPF_TEST_RUN with
> a user-space timer? Asking because you offer no API to read or
> modify timer expiration, so literally the same with BPF_TEST_RUN
> approach.

a wrapper on top of hrtimer_get_remaining() like bpf_timer_get_remaining()
is trivial to add, but what is the use case?

> >
> > Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> > in hash/array/lru maps as regular field and helpers to operate on it:
> 
> Can be or has to be? Huge difference here.

map elements don't have to use timers.

> In the other thread, you said it is global data, which implies that it does
> not have to be in a map.

global data is a map. That was explained in the prior thread as well.

> 
> In your test case or your example, all timers are still in a map. So what has
> changed since then? Looks nothing to me.

look again?

> Hmm, finally you begin refcounting it, which you were strongly against. ;)

That was already answered in the prior thread.
tldr: there were two options. This is one of them. Another can be added
in the future as well.

> Three questions:
> 
> 1. Can t->prog be freed between bpf_timer_init() and bpf_timer_start()?

yes.

> If the timer subprog is always in the same prog which installs it, then

installs it? I'm not following the quesiton.

> this is fine. But then how do multiple programs share a timer? 

there is only one callback function.

> In the
> case of conntrack, either ingress or egress could install the timer,
> it only depends which one gets traffic first. Do they have to copy
> the same subprog for the same timer?

conntrack is an explicit non-goal.

> 
> 2. Can t->prog be freed between a timer expiration and bpf_timer_start()
> again? 

If it's already armed with the first bpf_timer_start() it won't be freed.

> It gets a refcnt when starting a timer and puts it when cancelling
> or expired, so t->prog can be freed right after cancelling or expired. What
> if another program which shares this timer wants to restart this timer?

There is only one callback_fn per timer. Another program can share
the struct bpf_timer and the map. It might have subprog callback_fn code
that looks exactly the same as callback_fn in the first prog.
For example when libbpf loads progs/timer.c (after it was compiled into .o)
it might share a subprog in the future (when kernel has support for
dynamic linking). From bpf user pov it's a single .c file.
The split into programs and subprograms is an implemenation detail
that C programmer doesn't need to worry about.

> 3. Since you offer no API to read the expiration time, why not just use
> BPF_TEST_RUN with a user-space timer? This is preferred by Andrii.

Andrii point was that there should be no syscall cmds that replicate
bpf_timer_init/start/cancel helpers. I agree with this.


> Thanks.
>
> Another unpopular point of view:
>
> This init() is not suitable for bpf programs, because unlike kernel modules,
> there is no init or exit functions for a bpf program. And timer init
> is typically
> called during module init.

Already answerd this in the prior thread. There will be __init and __fini like
subprograms in bpf progs.

Please apply the patches to your local tree and do few experiments based
on selftests/bpf/progs/timer.c. I think experimenting with the code
will answer all of your questions.
