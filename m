Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C193C39A864
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhFCRPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:15:31 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:46020 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhFCRNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:13:44 -0400
Received: by mail-yb1-f182.google.com with SMTP id g38so9794820ybi.12;
        Thu, 03 Jun 2021 10:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o0+/Ig9KOjvikRraP0uv+9p3UR4+L7BV3ykUg6yAHk4=;
        b=da9vXynAWiDtenDFABKxXG+0HSf++4kbblRUF1lMbM+X+3wxVL1uZPJtkrlNCG+Gp5
         mzishCApd5qnzOCETNTjwIvPQwNvu3rhHMN5uQVMjFmpDEHkSvPwSTQp0BEeHxACTtbA
         7nWE9KYS3xENMXqyN3EW+a2g+QKS3I2OEVFF1QVbKiDxfxebokkHKX1d5FVvby+7XORA
         TwYVo0pYWqWi93KIQWp0n3Q6JAAq/1wj+0Qldy1UjgT4Jt4uQ/S1gRA2h6kePXpQWPSO
         Xa21MFVTeN8u8anFSStArDcXIekTGzcDoFCeQVvSXcBdxDrOyEHF6YMSkYFkDkf5Z/AP
         HBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o0+/Ig9KOjvikRraP0uv+9p3UR4+L7BV3ykUg6yAHk4=;
        b=eWfTbHFS8ImJ7J9tAOIBZvtR5I9pRo808VXVHHIGPiONqGNPVaYfPKvNhVhDLp2sD6
         e5JzkaKwK/ppCanldcFnJ4yq9baUwyWnFXFSSRhSl4PBrTm0WFzXleDZfBSbaecOcp4a
         NJhgu/UZK6lHsvC+9gURocKye+QOHhYTKko5fR7Wll11aHBPL7wpxQPcXE4j5uc4D6Fu
         vozUIHq56CwGqs97q1c8P48R71qGeqxMKmr2RGcxNx/qLME8U+sQ2pV45YqojkWsBguf
         RzdnzyL7RbEatAw91/jP4Ob6/bb1LLvRKQgQvQyLoBdun0TA7HX9aK2W2XzkRWrRMqMe
         V2XQ==
X-Gm-Message-State: AOAM531/1/YBo7VoBapo6udL+qhZtE1l6uNfpOMZkn0+Uq2pLiEXjZfZ
        1HQ1pBlWb5GhP6EtYvyuRubx61lTePXI6vINObc=
X-Google-Smtp-Source: ABdhPJzyzdvEo8SxVstbsNCgWzbyiYB42m9zAXfin0opyj9SGomVPGn0J545ifVmpSxDUsN69YAoTpTbno7szF6Mhbs=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr140067ybr.425.1622740249519;
 Thu, 03 Jun 2021 10:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com> <CAEf4BzbyikY1b4vAzb+t88odbqWOR7K4TpwjM1zGF4Nmqu6ysg@mail.gmail.com>
 <20210603015330.vd4zgr5rdishemgi@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210603015330.vd4zgr5rdishemgi@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Jun 2021 10:10:38 -0700
Message-ID: <CAEf4BzafEP_b7vXT9pTB4mDWWP7N5ACe82V3yq-1doH=awNbUg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 6:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jun 02, 2021 at 03:08:08PM -0700, Andrii Nakryiko wrote:
> > On Wed, May 26, 2021 at 9:03 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Introduce 'struct bpf_timer { __u64 :64; };' that can be embedded
> > > in hash/array/lru maps as regular field and helpers to operate on it:
> > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags);
> > > long bpf_timer_start(struct bpf_timer *timer, u64 nsecs);
> > > long bpf_timer_cancel(struct bpf_timer *timer);
> > >
> > > Here is how BPF program might look like:
> > > struct map_elem {
> > >     int counter;
> > >     struct bpf_timer timer;
> > > };
> > >
> > > struct {
> > >     __uint(type, BPF_MAP_TYPE_HASH);
> > >     __uint(max_entries, 1000);
> > >     __type(key, int);
> > >     __type(value, struct map_elem);
> > > } hmap SEC(".maps");
> > >
> > > struct bpf_timer global_timer;
> >
> > Using bpf_timer as a global variable has at least two problems. We
> > discussed one offline but I realized another one reading the code in
> > this patch:
> >   1. this memory can and is memory-mapped as read-write, so user-space
> > can just write over this (intentionally or accidentally), so it's
> > quite unsafe
>
> yep.
>
> >   2. with current restriction of having offset 0 for struct bpf_timer,
> > you have to use global variable for it, because clang will reorder
> > static variables after global variables.
>
> that is addressed in 2nd patch.
>
> > > + * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
> > > + *     Description
> > > + *             Initialize the timer to call given static function.
> > > + *     Return
> > > + *             zero
> >
> > -EBUSY is probably the most important to mention here, but generally
> > the way it's described right now it seems like it can't fail, which is
> > not true. Similar for bpf_timer_start() and bpf_timer_cancel().
>
> good point.
>
> > > + *
> > > + * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
> > > + *     Description
> > > + *             Start the timer and set its expiration N nanoseconds from
> > > + *             the current time.
> >
> > The case of nsecs == 0 is a bit special and interesting, it's useful
> > to explain what will happen in that case. I'm actually curious as
> > well, in the code you say "call ASAP", but does it mean after the BPF
> > program exits? Or can it start immediately on another CPU? Or will it
> > interrupt the currently running BPF program to run the callback
> > (unlikely, but that might be someone's expectation).
>
> nsecs == 0 is not special. nsecs is a relative expiry time.
> 1 nanosecond is not much different from zero :)
> Most likely this timer will be the first one to run once it's added
> to per-cpu rb-tree.
>
> I think going too much into implementation details in the helper
> description is unnecessary.
> " Start the timer and set its expiration N nanoseconds from
>   the current time. "
> is probably about right amount of details.
> I can add that the time clock is monotonic
> and callback is called in softirq.

I think mentioning whether it's going to be run on the same CPU or
another CPU is the most important part. I'm honestly still not sure
which one is the case, because I don't completely understand all the
implications of what "called in softirq" implies.

>
> > > +static enum hrtimer_restart timer_cb(struct hrtimer *timer)
> >
> > nit: can you please call it bpf_timer_cb, so it might be possible to
> > trace it a bit easier due to bpf_ prefix?
>
> sure.
>
> > > +{
> > > +       struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
> > > +       unsigned long flags;
> > > +       int ret;
> > > +
> > > +       /* timer_cb() runs in hrtimer_run_softirq and doesn't migrate.
> > > +        * Remember the timer this callback is servicing to prevent
> > > +        * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
> > > +        */
> > > +       this_cpu_write(hrtimer_running, t);
> > > +       ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)t->map,
> > > +                                           (u64)(long)t->key,
> > > +                                           (u64)(long)t->value, 0, 0);
> > > +       WARN_ON(ret != 0); /* todo: define 0 vs 1 or disallow 1 in the verifier */
> >
> > if we define 0 vs 1, what would their meaning be?
>
> How would you define it?
> The hrtimer has support for HRTIMER_NORESTART vs HRTIMER_RESTART.
> This feature of hrtimer is already exposed into user space via timerfd,
> so no concerns there.
> But to use HRTIMER_RESTART in a meaningful way the bpf prog
> would need to be able to call to hrtimer_forward_now() to set
> the new expiry.
> That function has an interesting caution comment in hrtimer.h:
>  * Can be safely called from the callback function of @timer. If
>  * called from other contexts @timer must neither be enqueued nor
>  * running the callback and the caller needs to take care of
>  * serialization.
> I'm not sure how to teach the verifier to enforce that.. yet...
>
> As an alternative we can interpret bpf timer callback return value
> inside bpf_timer_cb() kernel function as:
> 0 - return HRTIMER_NORESTART
> N - hrtimer_forward_now(,N); return HRTIMER_RESTART.
>
> but the same can be achieved by calling bpf_timer_start()
> from the bpf prog. The speed of re-arming is roughly the same
> in both cases.
> Doing the same functionality two different ways doesn't seem
> necessary.
>
> I couldn't come up with other ways to use the return value
> and currently thinking to allow 0 only for now.
> Other ideas?

Yeah, I was thinking to enforce 0 always, unless we have a strong case
for this HRTIMER_RESTART. But if you can achieve the same with
bpf_timer_start() from the callback, I don't think that's necessary.
So I'd force 0.

>
> > > +       spin_lock_irqsave(&t->lock, flags);
> > > +       if (!hrtimer_is_queued(timer))
> > > +               bpf_prog_put(t->prog);
> > > +       spin_unlock_irqrestore(&t->lock, flags);
> > > +       this_cpu_write(hrtimer_running, NULL);
> >
> > Don't know if it's a problem. Above you say that timer_cb doesn't
> > migrate, but can it be preempted?
>
> My understanding that no, it cannot be. Even in RT.
>
> > If yes, and timer_cb is called in
> > the meantime for another timer, setting hrtimer_running to NULL will
> > clobber the previous value, right? So no nesting is possible. Is this
> > a problem?
>
> Based on my current understanding of hrtimer implemention we're safe here.
>
> > Also is there a chance for timer callback to be a sleepable BPF (sub-)program?
>
> Eventually yes. The whole bpf program can be sleepable, but the
> timer callback cannot be. So the verifier would need to
> treat different functions of the bpf prog as sleepable and non-sleepable.
> Easy enough to implement. Eventually.

Ok, so non-sleepable callback is hrtimer's implementation restriction
due to softirq, right? Too bad, of course, I can imagine sleepable
callbacks being useful, but it's not a deal breaker.

>
> > What if we add a field to struct bpf_hrtimer that will be inc/dec to
> > show whether it's active or not? That should bypass per-CPU
> > assumptions, but I haven't thought through races, worst case we might
> > need to take t->lock.
>
> You mean to get rid of per-cpu hrtimer_running and replace
> with bool flag inside bpf_hrtimer. Like is_callback_fn_running ?
> That won't work as-is, since bpf_timer_cancel will be called
> sooner or later when another cpu is inside the callback.
> Something like:
> bpf_timer_cb()
> {
>   bpf_hrtimer->running_on_cpu = smp_processor_id();
>   BPF_CAST_CALL(t->callback_fn)
>   bpf_hrtimer->running_on_cpu = -1;
> }
>
> bpf_timer_cancel()
> {
>   if (bpf_hrtimer->running_on_cpu == smp_processor_id())
>     return -EBUSY;
> }
>
> will work, but it's potentially wasting more memory
> if there are millions of timers
> than single per-cpu hrtimer_running and seems less clean.

I disagree about less clean, but given there is no way we have
sleepable timer callbacks it doesn't matter. Per-cpu will work.

>
> > > +BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)
> >
> > Not entirely sure, but it feels like adding flags would be good here as well?
>
> Same here. Not entirely sure, but I think it's good without it.
> Here is why:
> hrtimer_start() has 3rd argument which allows some flexibility
> to change the mode of the timer after hrtimer_init.
> But I think it's too flexible part of hrtimer api.
> Like io_uring is exposing hrtimers, but remembers the mode specified
> during hrtimer_init phase and uses it during hrtimer_start.
> I think eventually the bpf_hrtimer_init() might support
> not only clock_monotonic and relative expiry, but other
> features of hrtimer as well, but I think it's better to
> follow what io_uring did and remember the mode during bpf_hrtimer_init()
> and use the same mode in bpf_hrtimer_start().
> Because of that there is nothing extra to pass into hrtimer_start()
> and hence no use for 3rd argument in bpf_timer_start.
>
> The flags argument in bpf_timer_init() will eventually
> be able to specify monotonic vs boottime and
> relative vs absolute expiry.

Yeah, I was thinking about relative vs absolute expiry case, but we
never know what kind of extensibility we'll need, so there might be
something that we don't see as a possibility yet. Seems simple enough
to reserve flags argument here (we usually do not regret adding flags
argument for extensibility), but I'm fine either way.

>
> > > +BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
> > > +{
> > > +       struct bpf_hrtimer *t;
> > > +       unsigned long flags;
> > > +
> > > +       t = READ_ONCE(timer->timer);
> > > +       if (!t)
> > > +               return -EINVAL;
> > > +       if (this_cpu_read(hrtimer_running) == t)
> > > +               /* If bpf callback_fn is trying to bpf_timer_cancel()
> > > +                * its own timer the hrtimer_cancel() will deadlock
> > > +                * since it waits for callback_fn to finish
> > > +                */
> > > +               return -EBUSY;
> > > +       spin_lock_irqsave(&t->lock, flags);
> > > +       /* Cancel the timer and wait for associated callback to finish
> > > +        * if it was running.
> > > +        */
> > > +       if (hrtimer_cancel(&t->timer) == 1)
> > > +               /* If the timer was active then drop the prog refcnt,
> > > +                * since callback will not be invoked.
> > > +                */
> >
> > So the fact whether the timer was cancelled or it's active/already
> > fired seems useful to know in BPF program (sometimes). I can't recall
> > an exact example, but in the past dealing with some timers (in
> > user-space, but the point stands) I remember it was important to know
> > this, so maybe we can communicate that as 0 or 1 returned from
> > bpf_timer_cancel?
>
> Good idea!
>
> > > +void bpf_timer_cancel_and_free(void *val)
> > > +{
> > > +       struct bpf_timer_kern *timer = val;
> > > +       struct bpf_hrtimer *t;
> > > +
> > > +       t = READ_ONCE(timer->timer);
> > > +       if (!t)
> > > +               return;
> > > +       /* Cancel the timer and wait for callback to complete
> > > +        * if it was running
> > > +        */
> > > +       if (hrtimer_cancel(&t->timer) == 1)
> > > +               bpf_prog_put(t->prog);
> > > +       kfree(t);
> > > +       WRITE_ONCE(timer->timer, NULL);
> >
> > this seems to race with bpf_timer_start, no? Doing WRITE_ONCE and then
> > kfree() timer would be a bit safer (we won't have dangling pointer at
> > any point in time), but I think that still is racy, because
> > bpf_start_timer can read timer->timer before WRITE_ONCE(NULL) here,
> > then we kfree(t), and then bpf_timer_start() proceeds to take t->lock
> > which might explode or might do whatever.
>
> This race is not possible with bpf_timer inside array
> and inside non-prealloc htab.
> The bpf_timer_cancel_and_free() is called when element being
> deleted in htab or the whole array/htab is destroyed.
> When element is deleted the bpf prog cannot look it up.
> Hence it cannot reach bpf_timer pointer and call bpf_timer_start() on it.
> In case of preallocated htab there is race.
> The bpf prog can do a lookup then delete an element
> while still using earlier value pointer. Since all elements
> are preallocated the elem could be reused for another value at that time.
> I need to think more about ways to address it.

Yep, this is the case I was suspicious about. We can have multiple BPF
programs (or same program on multiple CPUs) working with the same
value pointer while some other CPU is attempting to delete it.

> Currently thinking to do cmpxchg in bpf_timer_start() and
> bpf_timer_cancel*() similar to bpf_timer_init() to address it.
> Kinda sucks to use atomic ops to address a race by deliberately
> malicious prog. bpf prog writers cannot just stumble on such race.

Why deliberately malicious? Just sufficiently sloppy or even just a
clever concurrent BPF program. I suspect BPF map iterators can further
make it more probable, no?

So your idea is to cmpxchg() to NULL while bpf_timer_start() or
bpf_timer_cancel() works with the timer? Wouldn't that cause
bpf_timer_init() believe that that timer is not yet initialized and
not return -EBUSY. Granted that's a corner-case race, but still.

What if the spinlock was moved out of struct bpf_hrtimer into struct
bpf_timer instead? Then all that cmpxchg and READ_ONCE/WRITE_ONCE
could go away and be more "obviously correct" and race-free? We'd just
need to make sure that the size of that spinlock struct doesn't change
depending on kernel config (so no diagnostics should be embedded).

>
> > A small nit, you added bpf_timer_cancel_and_free() prototype in the
> > next patch, but it should probably be done in this patch to avoid
> > unnecessary compiler warnings during bisecting.
>
> There is no warning in default build.
> It's just an unused (yet) global function. That's why I've sent
> the patch this way, but since you asked I've tried few other ways
> and found that "make W=1" indeed warns.
> I'll move the proto to shut it up.

yeah, I didn't see it, just remember from experience running into this
warning sometimes

>
> > > +               if (insn->imm == BPF_FUNC_timer_init) {
> > > +
> >
> > nit: why empty line here?
>
> no clue. will fix.
>
> Thank you for the review!
