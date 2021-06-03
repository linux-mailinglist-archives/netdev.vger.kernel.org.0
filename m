Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6583997C8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 03:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFCB4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 21:56:31 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:44783 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhFCB4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 21:56:30 -0400
Received: by mail-pf1-f178.google.com with SMTP id u18so3658613pfk.11;
        Wed, 02 Jun 2021 18:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BIk0PMoQhOV/x90cI4e2Y7NdRtdEOssK09H6LOQ3mpo=;
        b=MgP7KfdRirgHkNML2wGGa8GfbzYrmhUhfFsoS41PViRkfWVcj+JAx79vhNejkjUBC2
         CZJWgt2NnWfy+hF9YJfPfcmheTMyVJJmojz6UI7gBjwyXWH+njNnA2S1YHnAK4QyQZ0S
         I/7Vue9xSunvzFH/1OE8OGcZENLJMKvCf2UTP2mPo3Ib1SoPCUQTxYQM2eoi0xSF5Tbq
         GVCSselUoWpjIFcC9K+dVxQucaaEVBXIWlfxclgVEDoGQWs0kvM+MkMKWiVhIBKsHAUB
         MmGOTob7u1cFOrvnUIiYcZz8uXjYufm1PxeZeCllykqXObB2XPLQPmKciJu9yyl+e+yW
         KxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BIk0PMoQhOV/x90cI4e2Y7NdRtdEOssK09H6LOQ3mpo=;
        b=R7wsO+zZBIxuPeKz6ixIOg3sx0gL7fT4yu5dTuzPbbEUvuSpFM6XnbL2ff/Luz7mH3
         wYS6pzgR8GPrNu1WE4X344Vo/RHGPDD5y06ZEvpzenPYrUrlipOS7Wxr0orIPDfgh7/I
         pyputGzo/4d+uLCaW+Xke50f+huI/tIfeZJVZbUuV+Wq6SL2mfre1nfnEsWSuX3+9Oc3
         6wpiEyVP+Z8ORlJUU/IxoyDr4XMxq98L94X7nUzLt37UdD0L+d3VCwiklvkxZe+awUAl
         ruBLdJC3GHx6QDRLo3wzn3w5TdISFVlpGd7Pfk7YertgNfTB6DBJ+OMnZGycGjf9ANBn
         QRRw==
X-Gm-Message-State: AOAM532HrG8ZPU1J1HS+NnAm2TqQr0IQbcqOWOL5RMtQbG+DIT16xK6f
        J9NWh0sZxucCg4GFC2pIlUKTGtoM4EI=
X-Google-Smtp-Source: ABdhPJydu+MRC4tjDQ7El0Dd5GPjrb3Zv61pfSD0JthwuS0zCzYxnnD2QKV48Su/1g4XNkSZrxoGaQ==
X-Received: by 2002:aa7:8ec8:0:b029:2ea:32b:9202 with SMTP id b8-20020aa78ec80000b02902ea032b9202mr10684926pfr.36.1622685214110;
        Wed, 02 Jun 2021 18:53:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:27da])
        by smtp.gmail.com with ESMTPSA id s48sm657107pfw.205.2021.06.02.18.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 18:53:33 -0700 (PDT)
Date:   Wed, 2 Jun 2021 18:53:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210603015330.vd4zgr5rdishemgi@ast-mbp.dhcp.thefacebook.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com>
 <CAEf4BzbyikY1b4vAzb+t88odbqWOR7K4TpwjM1zGF4Nmqu6ysg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbyikY1b4vAzb+t88odbqWOR7K4TpwjM1zGF4Nmqu6ysg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:08:08PM -0700, Andrii Nakryiko wrote:
> On Wed, May 26, 2021 at 9:03 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Introduce 'struct bpf_timer { __u64 :64; };' that can be embedded
> > in hash/array/lru maps as regular field and helpers to operate on it:
> > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags);
> > long bpf_timer_start(struct bpf_timer *timer, u64 nsecs);
> > long bpf_timer_cancel(struct bpf_timer *timer);
> >
> > Here is how BPF program might look like:
> > struct map_elem {
> >     int counter;
> >     struct bpf_timer timer;
> > };
> >
> > struct {
> >     __uint(type, BPF_MAP_TYPE_HASH);
> >     __uint(max_entries, 1000);
> >     __type(key, int);
> >     __type(value, struct map_elem);
> > } hmap SEC(".maps");
> >
> > struct bpf_timer global_timer;
> 
> Using bpf_timer as a global variable has at least two problems. We
> discussed one offline but I realized another one reading the code in
> this patch:
>   1. this memory can and is memory-mapped as read-write, so user-space
> can just write over this (intentionally or accidentally), so it's
> quite unsafe

yep.

>   2. with current restriction of having offset 0 for struct bpf_timer,
> you have to use global variable for it, because clang will reorder
> static variables after global variables.

that is addressed in 2nd patch.

> > + * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
> > + *     Description
> > + *             Initialize the timer to call given static function.
> > + *     Return
> > + *             zero
> 
> -EBUSY is probably the most important to mention here, but generally
> the way it's described right now it seems like it can't fail, which is
> not true. Similar for bpf_timer_start() and bpf_timer_cancel().

good point.

> > + *
> > + * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
> > + *     Description
> > + *             Start the timer and set its expiration N nanoseconds from
> > + *             the current time.
> 
> The case of nsecs == 0 is a bit special and interesting, it's useful
> to explain what will happen in that case. I'm actually curious as
> well, in the code you say "call ASAP", but does it mean after the BPF
> program exits? Or can it start immediately on another CPU? Or will it
> interrupt the currently running BPF program to run the callback
> (unlikely, but that might be someone's expectation).

nsecs == 0 is not special. nsecs is a relative expiry time.
1 nanosecond is not much different from zero :)
Most likely this timer will be the first one to run once it's added
to per-cpu rb-tree.

I think going too much into implementation details in the helper
description is unnecessary.
" Start the timer and set its expiration N nanoseconds from
  the current time. "
is probably about right amount of details.
I can add that the time clock is monotonic
and callback is called in softirq.

> > +static enum hrtimer_restart timer_cb(struct hrtimer *timer)
> 
> nit: can you please call it bpf_timer_cb, so it might be possible to
> trace it a bit easier due to bpf_ prefix?

sure.

> > +{
> > +       struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
> > +       unsigned long flags;
> > +       int ret;
> > +
> > +       /* timer_cb() runs in hrtimer_run_softirq and doesn't migrate.
> > +        * Remember the timer this callback is servicing to prevent
> > +        * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
> > +        */
> > +       this_cpu_write(hrtimer_running, t);
> > +       ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)t->map,
> > +                                           (u64)(long)t->key,
> > +                                           (u64)(long)t->value, 0, 0);
> > +       WARN_ON(ret != 0); /* todo: define 0 vs 1 or disallow 1 in the verifier */
> 
> if we define 0 vs 1, what would their meaning be?

How would you define it?
The hrtimer has support for HRTIMER_NORESTART vs HRTIMER_RESTART.
This feature of hrtimer is already exposed into user space via timerfd,
so no concerns there.
But to use HRTIMER_RESTART in a meaningful way the bpf prog
would need to be able to call to hrtimer_forward_now() to set
the new expiry.
That function has an interesting caution comment in hrtimer.h:
 * Can be safely called from the callback function of @timer. If
 * called from other contexts @timer must neither be enqueued nor
 * running the callback and the caller needs to take care of
 * serialization.
I'm not sure how to teach the verifier to enforce that.. yet...

As an alternative we can interpret bpf timer callback return value
inside bpf_timer_cb() kernel function as:
0 - return HRTIMER_NORESTART
N - hrtimer_forward_now(,N); return HRTIMER_RESTART.

but the same can be achieved by calling bpf_timer_start()
from the bpf prog. The speed of re-arming is roughly the same
in both cases.
Doing the same functionality two different ways doesn't seem
necessary.

I couldn't come up with other ways to use the return value
and currently thinking to allow 0 only for now.
Other ideas?

> > +       spin_lock_irqsave(&t->lock, flags);
> > +       if (!hrtimer_is_queued(timer))
> > +               bpf_prog_put(t->prog);
> > +       spin_unlock_irqrestore(&t->lock, flags);
> > +       this_cpu_write(hrtimer_running, NULL);
> 
> Don't know if it's a problem. Above you say that timer_cb doesn't
> migrate, but can it be preempted? 

My understanding that no, it cannot be. Even in RT.

> If yes, and timer_cb is called in
> the meantime for another timer, setting hrtimer_running to NULL will
> clobber the previous value, right? So no nesting is possible. Is this
> a problem?

Based on my current understanding of hrtimer implemention we're safe here.

> Also is there a chance for timer callback to be a sleepable BPF (sub-)program?

Eventually yes. The whole bpf program can be sleepable, but the
timer callback cannot be. So the verifier would need to
treat different functions of the bpf prog as sleepable and non-sleepable.
Easy enough to implement. Eventually.

> What if we add a field to struct bpf_hrtimer that will be inc/dec to
> show whether it's active or not? That should bypass per-CPU
> assumptions, but I haven't thought through races, worst case we might
> need to take t->lock.

You mean to get rid of per-cpu hrtimer_running and replace
with bool flag inside bpf_hrtimer. Like is_callback_fn_running ?
That won't work as-is, since bpf_timer_cancel will be called
sooner or later when another cpu is inside the callback.
Something like:
bpf_timer_cb()
{
  bpf_hrtimer->running_on_cpu = smp_processor_id();
  BPF_CAST_CALL(t->callback_fn)
  bpf_hrtimer->running_on_cpu = -1;
}

bpf_timer_cancel()
{ 
  if (bpf_hrtimer->running_on_cpu == smp_processor_id())
    return -EBUSY;
}

will work, but it's potentially wasting more memory
if there are millions of timers
than single per-cpu hrtimer_running and seems less clean.

> > +BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)
> 
> Not entirely sure, but it feels like adding flags would be good here as well?

Same here. Not entirely sure, but I think it's good without it.
Here is why:
hrtimer_start() has 3rd argument which allows some flexibility
to change the mode of the timer after hrtimer_init.
But I think it's too flexible part of hrtimer api.
Like io_uring is exposing hrtimers, but remembers the mode specified
during hrtimer_init phase and uses it during hrtimer_start.
I think eventually the bpf_hrtimer_init() might support
not only clock_monotonic and relative expiry, but other
features of hrtimer as well, but I think it's better to
follow what io_uring did and remember the mode during bpf_hrtimer_init()
and use the same mode in bpf_hrtimer_start().
Because of that there is nothing extra to pass into hrtimer_start()
and hence no use for 3rd argument in bpf_timer_start.

The flags argument in bpf_timer_init() will eventually
be able to specify monotonic vs boottime and
relative vs absolute expiry.

> > +BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
> > +{
> > +       struct bpf_hrtimer *t;
> > +       unsigned long flags;
> > +
> > +       t = READ_ONCE(timer->timer);
> > +       if (!t)
> > +               return -EINVAL;
> > +       if (this_cpu_read(hrtimer_running) == t)
> > +               /* If bpf callback_fn is trying to bpf_timer_cancel()
> > +                * its own timer the hrtimer_cancel() will deadlock
> > +                * since it waits for callback_fn to finish
> > +                */
> > +               return -EBUSY;
> > +       spin_lock_irqsave(&t->lock, flags);
> > +       /* Cancel the timer and wait for associated callback to finish
> > +        * if it was running.
> > +        */
> > +       if (hrtimer_cancel(&t->timer) == 1)
> > +               /* If the timer was active then drop the prog refcnt,
> > +                * since callback will not be invoked.
> > +                */
> 
> So the fact whether the timer was cancelled or it's active/already
> fired seems useful to know in BPF program (sometimes). I can't recall
> an exact example, but in the past dealing with some timers (in
> user-space, but the point stands) I remember it was important to know
> this, so maybe we can communicate that as 0 or 1 returned from
> bpf_timer_cancel?

Good idea!

> > +void bpf_timer_cancel_and_free(void *val)
> > +{
> > +       struct bpf_timer_kern *timer = val;
> > +       struct bpf_hrtimer *t;
> > +
> > +       t = READ_ONCE(timer->timer);
> > +       if (!t)
> > +               return;
> > +       /* Cancel the timer and wait for callback to complete
> > +        * if it was running
> > +        */
> > +       if (hrtimer_cancel(&t->timer) == 1)
> > +               bpf_prog_put(t->prog);
> > +       kfree(t);
> > +       WRITE_ONCE(timer->timer, NULL);
> 
> this seems to race with bpf_timer_start, no? Doing WRITE_ONCE and then
> kfree() timer would be a bit safer (we won't have dangling pointer at
> any point in time), but I think that still is racy, because
> bpf_start_timer can read timer->timer before WRITE_ONCE(NULL) here,
> then we kfree(t), and then bpf_timer_start() proceeds to take t->lock
> which might explode or might do whatever.

This race is not possible with bpf_timer inside array
and inside non-prealloc htab.
The bpf_timer_cancel_and_free() is called when element being
deleted in htab or the whole array/htab is destroyed.
When element is deleted the bpf prog cannot look it up.
Hence it cannot reach bpf_timer pointer and call bpf_timer_start() on it.
In case of preallocated htab there is race.
The bpf prog can do a lookup then delete an element
while still using earlier value pointer. Since all elements
are preallocated the elem could be reused for another value at that time.
I need to think more about ways to address it.
Currently thinking to do cmpxchg in bpf_timer_start() and
bpf_timer_cancel*() similar to bpf_timer_init() to address it.
Kinda sucks to use atomic ops to address a race by deliberately 
malicious prog. bpf prog writers cannot just stumble on such race.

> A small nit, you added bpf_timer_cancel_and_free() prototype in the
> next patch, but it should probably be done in this patch to avoid
> unnecessary compiler warnings during bisecting.

There is no warning in default build.
It's just an unused (yet) global function. That's why I've sent
the patch this way, but since you asked I've tried few other ways
and found that "make W=1" indeed warns.
I'll move the proto to shut it up.

> > +               if (insn->imm == BPF_FUNC_timer_init) {
> > +
> 
> nit: why empty line here?

no clue. will fix.

Thank you for the review!
