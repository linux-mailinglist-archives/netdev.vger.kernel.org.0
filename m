Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7028D3A9170
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 07:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFPF5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 01:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhFPF5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 01:57:11 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47271C061574;
        Tue, 15 Jun 2021 22:54:52 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id b13so1356705ybk.4;
        Tue, 15 Jun 2021 22:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e37uTBOiAthgk6XR/2MHmaquFeMG0KCqR43OSJCrZnk=;
        b=e3Kcy9la4DPQL0RE0hsLh3+39/zrdIM7Z/BLVB6tIwcn6ijxBCO0A5T0ZxOAwrmFG0
         dgXxQ1SeEaMVtUFjo7YmUaLKsKjQL7nfc8vE+gnIkZ55MU1CcEa3WW8F8DYSZGppFoUM
         JT75aJHqtpME31hVoJJ/tu1oMA8LsE19KWVmJQGzSAdUEi9bI8OQVLZAdE0SK+erWsQH
         9FXvFmLTGsQOplIyjjqJIURwdiKT5qT0JZ/vBX97JE2gitZkvtKN0jlb77neaqUBg6mP
         sQHX606bJMIbHsknGxkjX2ontQJQC1heD6IQU966JDhsJPuszgbp0NRn8hW+vOjHBmAe
         /euQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e37uTBOiAthgk6XR/2MHmaquFeMG0KCqR43OSJCrZnk=;
        b=CsYsPGErfjnBHd9GpOYJDvct60qTxojzGwnWgf3mNkK3N9aIj37pPm8jqvwKIs28Bv
         YoPMiU+qMinaGJoYt2ruMo/PbTmGEBVVBCmfEmUoVRzjtjTTEDp0qLXFUU8+0eYp6MhZ
         h/2Lt7DGX9kfFJd+DbpZrZR0Yb7j7zKSUbEUweieyVuCo5etvxZUmx9Lw+WzCoebzRjz
         YoiOzvYc1fyfoUYpKTunokLzz+YsREpS1y/LdwVIW/bogsHUtN2lGPJji5iJsl6TJ5wn
         pMpHvQ9FCDYaevxpKXcCnrAIJUaIXyy7H8wimo+m+YUbfNr4MpDL1jiWNLjwFMbILiOm
         twZQ==
X-Gm-Message-State: AOAM530FniLF9tVbw+yfjrk7yZyeWe/J5Egy4+ncEM9ndEHwjvlXQVIp
        z9BQAlDiL+HZeCKcPSLm49ekddx0d156hVgaFJ4=
X-Google-Smtp-Source: ABdhPJzd0OY8f8eD/3IAgOHCZAT8G1CMhDPBJAgJYkSq3GjCS0t/diURtlkochKumuZjt5ssbGW1QbdGkDrlM1/VqhI=
X-Received: by 2002:a25:4182:: with SMTP id o124mr3859903yba.27.1623822891303;
 Tue, 15 Jun 2021 22:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
 <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
 <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com>
 <CAADnVQJ3CQ=WnsantyEy6GB58rdsd7q=aJv93WPsZZJmXdJGzQ@mail.gmail.com>
 <CAEf4BzZWr7HhKn3opxHeaZqkgo4gsYYhDQ4d4HuNhx-i8XgjCg@mail.gmail.com> <20210616042622.22nzdrrnlndogn5w@ast-mbp>
In-Reply-To: <20210616042622.22nzdrrnlndogn5w@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Jun 2021 22:54:40 -0700
Message-ID: <CAEf4BzZ_=tJGqGS9FKxxQqGfRqAoF_m9r8FW29n9ZqC_u-10DA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 9:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 15, 2021 at 08:24:13AM -0700, Andrii Nakryiko wrote:
> > On Mon, Jun 14, 2021 at 10:41 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Jun 14, 2021 at 10:31 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Mon, Jun 14, 2021 at 8:29 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jun 14, 2021 at 9:51 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > > > +     ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> > > > > > > +                                         (u64)(long)key,
> > > > > > > +                                         (u64)(long)t->value, 0, 0);
> > > > > > > +     WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> > > > > >
> > > > > > I didn't find that next patch disallows callback return value 1 in the
> > > > > > verifier. If we indeed disallows return value 1 in the verifier. We
> > > > > > don't need WARN_ON here. Did I miss anything?
> > > > >
> > > > > Ohh. I forgot to address this bit in the verifier. Will fix.
> > > > >
> > > > > > > +     if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> > > > > > > +             /* If the timer wasn't active or callback already executing
> > > > > > > +              * bump the prog refcnt to keep it alive until
> > > > > > > +              * callback is invoked (again).
> > > > > > > +              */
> > > > > > > +             bpf_prog_inc(t->prog);
> > > > > >
> > > > > > I am not 100% sure. But could we have race condition here?
> > > > > >     cpu 1: running bpf_timer_start() helper call
> > > > > >     cpu 2: doing hrtimer work (calling callback etc.)
> > > > > >
> > > > > > Is it possible that
> > > > > >    !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
> > > > > > may be true and then right before bpf_prog_inc(t->prog), it becomes
> > > > > > true? If hrtimer_callback_running() is called, it is possible that
> > > > > > callback function could have dropped the reference count for t->prog,
> > > > > > so we could already go into the body of the function
> > > > > > __bpf_prog_put()?
> > > > >
> > > > > you're correct. Indeed there is a race.
> > > > > Circular dependency is a never ending headache.
> > > > > That's the same design mistake as with tail_calls.
> > > > > It felt that this case would be simpler than tail_calls and a bpf program
> > > > > pinning itself with bpf_prog_inc can be made to work... nope.
> > > > > I'll get rid of this and switch to something 'obviously correct'.
> > > > > Probably a link list with a lock to keep a set of init-ed timers and
> > > > > auto-cancel them on prog refcnt going to zero.
> > > > > To do 'bpf daemon' the prog would need to be pinned.
> > > >
> > > > Hm.. wouldn't this eliminate that race:
> > > >
> > > > switch (hrtimer_try_to_cancel(&t->timer))
> > > > {
> > > > case 0:
> > > >     /* nothing was queued */
> > > >     bpf_prog_inc(t->prog);
> > > >     break;
> > > > case 1:
> > > >     /* already have refcnt and it won't be bpf_prog_put by callback */
> > > >     break;
> > > > case -1:
> > > >     /* callback is running and will bpf_prog_put, so we need to take
> > > > another refcnt */
> > > >     bpf_prog_inc(t->prog);
> > > >     break;
> > > > }
> > > > hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
>
> Turned out that this approach has the same race as Yonghong mentioned.
> Calling hrtimer_callback_running() directly or through hrtimer_try_to_cancel()
> with extra cpu_base->lock as in above doesn't prevent the race.
> bpf_prog_put could have already happened and above case:
>  case -1:
>      /* callback is running and will bpf_prog_put, so we need to take
>  another refcnt */
>      bpf_prog_inc(t->prog);
>
> would be incrementing refcnt from zero.
>
> > > >
> > > > So instead of guessing (racily) whether there is a queued callback or
> > > > not, try to cancel just in case there is. Then rely on the nice
> > > > guarantees that hrtimer cancellation API provides.
> > >
> > > I haven't thought it through yet, but the above approach could
> > > indeed solve this particular race. Unfortunately there are other races.
> > > There is an issue with bpf_timer_init. Since it doesn't take refcnt
> > > another program might do lookup and bpf_timer_start
> > > while the first prog got to refcnt=0 and got freed.
> >
> > I think it's because of an API design. bpf_timer_init() takes a
> > callback (i.e., bpf_prog) but doesn't really do anything with it (so
> > doesn't take refcnt). It's both problematic, as you point out, and
> > unnecessarily restricting because it doesn't allow to change the
> > callback (e.g., when map is shared and bpf_program has to be changed).
> > If you change API to be:
> >
> > long bpf_timer_init(struct bpf_timer *timer, int flags);
> > long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsecs);
> >
> > You'll avoid this problem because bpf_timer_start will take refcnt
> > when arming (or re-arming) the timer. bpf_timer_init() will only take
> > care of initial memory allocation and hrtimer_init, but will leave
> > timer->prog as NULL until bpf_timer_start(). Wouldn't that solve all
> > the problems and be more flexible/powerful?
>
> Unfortunately no. The race would still be present and I don't see
> a clean way of solving.
>
> > If necessary, we can teach
> > bpf_timer_cb() to take spinlock briefly to avoid races fetching prog
> > pointer, but I haven't thought much about whether that's necessary.
>
> That doesn't help either.
> hrtimer_try_to_cancel() returning -1 (or checking it via
> hrtimer_callback_running) doesn't mean that refcnt > 0.
> It could have reached zero in bpf_timer_cb.
> I thought whether introducing bpf_prog_inc_if_not_zero()
> and using it in bpf_timer_start() could solve it...
> Nope. The prog pointer could be already be freed if processing
> of bpf_timer_cb is slow enough.
> Then I thought whether we can move refcnt from prog into
> 'struct bpf_timer_kern'...
> Then considered ref/uref counting...
> It's slippery slop of wrong turns.
>
> > If we wanted to push this to extreme, btw, we don't really need
> > bpf_timer_init(), bpf_timer_start() can do bpf_hrtimer allocation the
> > very first time (having pre-allocated spinlock makes this non-racy and
> > easy). But I don't know how expensive hrtimer_init() is, so it might
> > still make sense to split those two operations.
>
> hrtimer_init is cheap, but bpf_timer_init() is expensive due
> to memory allocation.
> It's done once, so arguably should be ok,
> but I'd like to avoid reinventing the wheel and stick
> to api-s similar to hrtimer.
>
> > Further, merging
> > bpf_timer_init() and bpf_timer_start() would require 6 input
> > arguments, which is a bit problematic. I have an idea how to get rid
> > of the necessity to pass in bpf_prog (so we'll be fine with just 5
> > explicit arguments), which simplifies other things (like
> > bpf_cgroup_storage implementation) as well, but I don't have patches
> > yet.
> >
> > > Adding refcnt to bpf_timer_init() makes the prog self pinned
> > > and no callback might ever be executed (if there were no bpf_timer_start),
> > > so that will cause a high chance of bpf prog stuck in the kernel.
> > > There could be ref+uref schemes similar to tail_calls to address all that,
> > > but it gets ugly quickly.
> > > imo all these issues and races is a sign that such self pinning
> > > shouldn't be allowed.
> >
> > I think prog refcounting is actually the saner and less surprising
> > approach here and we just need to spend a bit more time thinking how
> > to make everything work reliably. hrtimer API seems to be designed to
> > handle cases like this, which makes everything much easier.
>
> I made two 180 degree turns already. In the beginning I was strongly
> against circular dependencies since old history of tail_call taught us
> a valuable lesson. Then somehow convinced myself that this time around it will
> be different and went with this crazy refcnting scheme. The last couple
> weeks you, me, Yonghong, Toke and others invested countless hours thinking
> through the race conditions. It's a sign that design took the wrong turn.
> Circular dependencies must be avoided if possible. Here it's such case.

It could be the case, of course. But let's try to think this through
to the end before giving up. I think it's mostly because we are trying
to be too clever with lockless synchronization. I'm still not
convinced that it's a bad design.

I had a feeling that bpf_timer_cb needs to take lock as well. But once
we add that, refcounting becomes simpler and more deterministic, IMO.
Here's what I have in mind. I keep only important parts of the code,
so it's not a complete implementation. Please take a look below, I
left a few comments here and there.


struct bpf_hrtimer {
       struct hrtimer timer;
       struct bpf_map *map;
       void *value;

       struct bpf_prog *prog;
       void *callback_fn;

       /* pointer to that lock in struct bpf_timer_kern
        * so that we can access it from bpf_timer_cb()
        */
       struct bpf_spin_lock *lock;
};

BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, int, flags,
           struct bpf_map *, map)
{
       struct bpf_hrtimer *t;
       int ret = 0;

       ____bpf_spin_lock(&timer->lock);
       t = timer->timer;
       if (t) {
               ret = -EBUSY;
               goto out;
       }
       /* allocate hrtimer via map_kmalloc to use memcg accounting */
       t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
       if (!t) {
               ret = -ENOMEM;
               goto out;
       }
       t->value = (void *)timer /* - offset of bpf_timer inside elem */;
       t->map = map;
       t->timer.function = bpf_timer_cb;

       /* we'll init them in bpf_timer_start */
       t->prog = NULL;
       t->callback_fn = NULL;

       hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
       timer->timer = t;
out:
       ____bpf_spin_unlock(&timer->lock);
       return ret;
}


BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs,
           void *, cb, struct bpf_prog *, prog)
{
       struct bpf_hrtimer *t;
       int ret = 0;

       ____bpf_spin_lock(&timer->lock);
       t = timer->timer;
       if (!t) {
               ret = -EINVAL;
               goto out;
       }

       /* doesn't matter what it returns, we just request cancellation */
       hrtimer_try_to_cancel(&t->timer);

       /* t->prog might not be the same as prog (!) */
       if (prog != t->prog) {
            /* callback hasn't yet dropped refcnt */
           if (t->prog) /* if it's null bpf_timer_cb() is running and
will put it later */
               bpf_prog_put(t->prog);

           if (IS_ERR(bpf_prog_inc_not_zero(prog))) {
               /* this will only happen if prog is still running (and
it's actually us),
                * but it was already put to zero, e.g., by closing last FD,
                * so there is no point in scheduling a new run
                */
               t->prog = NULL;
               t->callback_fn = NULL;
               ret = -E_WE_ARE_SHUTTING_DOWN;
               goto out;
           }
       } /* otherwise we keep existing refcnt on t->prog == prog */

       /* potentially new combination of prog and cb */
       t->prog = prog;
       t->callback_fn = cb;

       hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
out:
       ____bpf_spin_unlock(&timer->lock);
       return ret;
}

BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
{
       struct bpf_hrtimer *t;
       int ret = 0;

       ____bpf_spin_lock(&timer->lock);
       t = timer->timer;
       if (!t) {
               ret = -EINVAL;
               goto out;
       }

       /* this part I still worry about due to possibility of cpu migration,
        * we need to think if we should migrate_disable() in bpf_timer_cb()
        * and bpf_timer_* helpers(), but that's a separate topic
        */
       if (this_cpu_read(hrtimer_running) == t) {
               ret = -EDEADLK;
               goto out;
       }

       ret = hrtimer_cancel(&t->timer);

       if (t->prog) {
            /* bpf_timer_cb hasn't put it yet (and now won't) */
            bpf_prog_put(t->prog);
            t->prog = NULL;
            t->callback_fn = NULL;
       }
out:
       ____bpf_spin_unlock(&timer->lock);
       return ret;
}

static enum hrtimer_restart bpf_timer_cb(struct hrtimer *timer)
{
       struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
       struct bpf_map *map = t->map;
       struct bpf_prog *prog;
       void *key, *callback_fn;
       u32 idx;
       int ret;

       /* this is very IMPORTANT  */
       ____bpf_spin_lock(t->lock);

       prog = t->prog;
       if (!prog) {
           /* we were cancelled, prog is put already, exit early */
           ____bpf_spin_unlock(&timer->lock);
           return HRTIMER_NORESTART;
       }
       callback_fn = t->callback_fn;

       /* make sure bpf_timer_cancel/bpf_timer_start won't
bpf_prog_put our prog */
       t->prog = NULL;
       t->callback_fn = NULL;

       ____bpf_spin_unlock(t->lock);

       /* at this point we "own" prog's refcnt decrement */

       this_cpu_write(hrtimer_running, t);

       ...

       ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
                                           (u64)(long)key,
                                           (u64)(long)value, 0, 0);
       WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */

       bpf_prog_put(prog); /* always correct and non-racy */

       this_cpu_write(hrtimer_running, NULL);

       return HRTIMER_NORESTART;
}

bpf_timer_cancel_and_free() is mostly the same with t->prog NULL check
as everywhere else

> There is no need to complicate bpf_timer with crazy refcnting schemes.
> The user space can simply pin the program in bpffs. In the future we might
> introduce a self-pinning helper that would pin the program and create a file.
> Sort-of like syscall prog type would pin self.
> That would be explicit and clean api instead of obscure hacks inside bpf_timer*().

Do I understand correctly that the alternative that you are proposing
is to keep some linked list of all map_values across all maps in the
system that have initialized bpf_hrtimer with that particular bpf_prog
in them? And when bpf_prog is put to zero you'll go and destruct them
all in a race-free way?

I have a bit of a hard time imagining how that will be implemented
exactly, so I might be overcomplicating that in my mind. Will be happy
to see the working code.
