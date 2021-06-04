Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B710239AF6D
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhFDBPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:15:31 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:40959 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhFDBPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:15:30 -0400
Received: by mail-pg1-f179.google.com with SMTP id j12so6512344pgh.7;
        Thu, 03 Jun 2021 18:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cyAZd6hKa9HUgtM9DI+wcqUInKkOsq+lYtlBkJdUwEU=;
        b=GXGnQZw9iGluZalhPGuRK6zuNxdzhyLlvwQsogNbu1WPBHiEW1qvZQ77GM/53m1xxt
         olLPzx7VMBUWeNr4ADMdteXe8X5b9thXF3vUwfoRor0VJ+kk2GBRc+zIVqahuk5x1n+H
         qQ9QCvH6OLcSF55Gv4MuFPc7zQU8H30D0Zy9q3u/18ZXLqh8qSavy2jQ5gEoI3a3xqO+
         EUNQPU5mRz0jtEQUqqkOGJNTnnwQZhl44h/7tZnAFoskjCGRfvYdZl3WklNerBF0Lsdu
         iiczrqSoTooE/5JmkvY42vssIo7K/snZkBGUrTvjywSRlD8LLd0amlKXnAUdEYRGa1Sb
         gMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cyAZd6hKa9HUgtM9DI+wcqUInKkOsq+lYtlBkJdUwEU=;
        b=c9+2YshevYqKm2J5SxJrfjcQ/T8XhSY9euJu7yBj6Xo7XGRQyVc9WoF0x0mh7Dlgkx
         +T5VxToLKJJqoxly2d0VQQ7LXAHRYlCX03SV4xgH2U5RL0ijf98xJ4dVZkY+t4bIwW34
         RlpAe1cm+CUy1wWZfLfoVuAwPFGQonyayknR0YiojZZcsjwGetqwKQv8WwdOLmGRDwwU
         9XK364Otos5ZpCMf2xsFm18j4L6BvGE+YzFa6WLHrPVDjku+qaCNotj672gCknS9ZX+i
         oTn+vZPnI1CbsMIZIum0FvB/0z3HavNDRm0V1VvvCLxgPFmWXA9wokLDpPTxRwPmhvg8
         Gfdg==
X-Gm-Message-State: AOAM531JacDcbHqdoWivuytTdIyLz32Yx+SUVgv9k8NEXSSD9uHX2KGZ
        Dntf+mNqCcjpSp1XfVCrqiAWw+Vo6WA=
X-Google-Smtp-Source: ABdhPJxVyC9K2Gn9PkjBzr+unlSk9ypEorIr29+D/AcNtQchsyI01mhdK1/Uox/QB4QvNTB+yPwenQ==
X-Received: by 2002:aa7:92da:0:b029:2e0:461f:2808 with SMTP id k26-20020aa792da0000b02902e0461f2808mr1797802pfa.25.1622769154948;
        Thu, 03 Jun 2021 18:12:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:82fb])
        by smtp.gmail.com with ESMTPSA id y73sm228690pfb.129.2021.06.03.18.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 18:12:34 -0700 (PDT)
Date:   Thu, 3 Jun 2021 18:12:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210604011231.p24eb6py7hjhskn3@ast-mbp.dhcp.thefacebook.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com>
 <CAEf4BzbyikY1b4vAzb+t88odbqWOR7K4TpwjM1zGF4Nmqu6ysg@mail.gmail.com>
 <20210603015330.vd4zgr5rdishemgi@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzafEP_b7vXT9pTB4mDWWP7N5ACe82V3yq-1doH=awNbUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzafEP_b7vXT9pTB4mDWWP7N5ACe82V3yq-1doH=awNbUg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 10:10:38AM -0700, Andrii Nakryiko wrote:
> >
> > I think going too much into implementation details in the helper
> > description is unnecessary.
> > " Start the timer and set its expiration N nanoseconds from
> >   the current time. "
> > is probably about right amount of details.
> > I can add that the time clock is monotonic
> > and callback is called in softirq.
> 
> I think mentioning whether it's going to be run on the same CPU or
> another CPU is the most important part. I'm honestly still not sure
> which one is the case, because I don't completely understand all the
> implications of what "called in softirq" implies.

"called in softirq" means that timer callback will be executing
in softirq context on some cpu. That's all.
The proposed API doesn't provide a way to call a timer on a given cpu
or to pin it to a cpu.
There are few places in the kernel that use ABS_PINNED and REL_PINNED
variants of hrtimer.
One such example is napi timer.
The initial cpu is picked during hrtimer_init and it's always
current cpu. napi is bound to a cpu. So when it calls hrtimer_init(.., _PINNED);
it wants the callback to stay on the same cpu.
The hrtimer doc says that _PINNED is ignored during hrtimer_init :)
It is ignored, kinda, since initial target cpu is picked as current.
Then during hrtimer_start the actual cpu will be selected.
If it's called as hrtimer_start(,_PINNED); then the cpu will stay
as it was during hrtimer_init.
If hrtimer_start() is called without _PINNED the hrtimer algorithm can 
migrate the timer to a more appropriate cpu depending on idle and no_hz. 
See get_nohz_timer_target.
In case of napi it's necessary to stay on the same cpu,
so it's using _PINNED in hrtimer_init and in hrtimer_start.
TCP is using pinned timers for compressed acks and pacing.
I'm guessing it's done to improve performance. I suspect TCP doesn't
need the timers pinned.
All other _PINNED cases of hrtimer are similar to napi.

In bpf world we don't have a way to deterministically
execute on a given cpu and the hrtimer infra won't give us such
possibility.

We can potentailly hack it on top of it. Like
bpf_timer_init(..., int cpu, ...)
{
  smp_call_function_single(cpu, rest_of_bpf_timer_init)
}

rest_of_bpf_timer_init()
{
  hrtimer_init
}

But there are lots of things to consider with such api.
It feels like two building blocks collapsed into one already.
If we do anything like this we should expose smp_call_function_single()
directly as bpf helper instead of side effect of bpf_timer.

> > > Also is there a chance for timer callback to be a sleepable BPF (sub-)program?
> >
> > Eventually yes. The whole bpf program can be sleepable, but the
> > timer callback cannot be. So the verifier would need to
> > treat different functions of the bpf prog as sleepable and non-sleepable.
> > Easy enough to implement. Eventually.
> 
> Ok, so non-sleepable callback is hrtimer's implementation restriction
> due to softirq, right? Too bad, of course, I can imagine sleepable
> callbacks being useful, but it's not a deal breaker.

Sleeping in softirq is no-go. The timer callback will be always
non-sleepable. If it would need to do extra work that requires sleeping
we'd need to create bpf kthreads similar to io_uring worker threads.
bpf program would have to ask for such things explicitly.

> > The flags argument in bpf_timer_init() will eventually
> > be able to specify monotonic vs boottime and
> > relative vs absolute expiry.
> 
> Yeah, I was thinking about relative vs absolute expiry case, but we
> never know what kind of extensibility we'll need, so there might be
> something that we don't see as a possibility yet. Seems simple enough
> to reserve flags argument here (we usually do not regret adding flags
> argument for extensibility), but I'm fine either way.

We cannot predict the future of bpf_timer, but the way it's going
so far there is a certainty that bpf_timer_start will be limited by
what hrtimer_start can do.
If we ever decide to use jiffy based timer as well they most likely
going to be represented as new set of helpers.
May be both hidden in the same 'struct bpf_timer',
but helper names would have to be different not to confuse users.

> > Currently thinking to do cmpxchg in bpf_timer_start() and
> > bpf_timer_cancel*() similar to bpf_timer_init() to address it.
> > Kinda sucks to use atomic ops to address a race by deliberately
> > malicious prog. bpf prog writers cannot just stumble on such race.
> 
> Why deliberately malicious? Just sufficiently sloppy or even just a
> clever concurrent BPF program. 

because hrtimers internals don't have protection for concurrent access.
It's assumed by kernel apis that the same hrtimer is not concurrently
accessed on multiple cpus.
Like doing hrtimer_init in parallel will certainly crash the kernel.
That's why bpf_timer_init() has extra cmpxchg safety builtin.
bpf_timer_start and bpf_timer_cancel don't have extra safety,
because the first thing hrtimer_start and hrtimer_cancel do
is they grab the lock, so everything will be safe even in bpf
programs try to access the same timer in parallel.

The malicicous part comes when bpf prog does bpf_timer_start
on the pointer from a deleted map element. It's clearly a bug.
Concurrent bpf_timer_start and bpf_timer_cancel is ok to do
and it's safe.
The malicious situation is concurrent lookup+bpf_timer_start
with parallel delete of that element.
It's wrong thing to do with map element regardless of timers.

> So your idea is to cmpxchg() to NULL while bpf_timer_start() or
> bpf_timer_cancel() works with the timer? Wouldn't that cause
> bpf_timer_init() believe that that timer is not yet initialized and
> not return -EBUSY. Granted that's a corner-case race, but still.

Not following.
bpf prog should do bpf_timer_init only once.
bpf_timer_init after bpf_timer_cancel is a wrong usage.
hrtimer api doesn't have any protection for such use.
while bpf_timer_init returns EBUSY.
2nd bpf_timer_init is just a misuse of bpf_timer api.

> What if the spinlock was moved out of struct bpf_hrtimer into struct
> bpf_timer instead? Then all that cmpxchg and READ_ONCE/WRITE_ONCE
> could go away and be more "obviously correct" and race-free? We'd just
> need to make sure that the size of that spinlock struct doesn't change
> depending on kernel config (so no diagnostics should be embedded).

We already tackled that concern with bpf_spin_lock.
So moving the lock into 'struct bpf_timer' is easy and it's a great idea.
I suspect it should simplify the code. Thanks!
