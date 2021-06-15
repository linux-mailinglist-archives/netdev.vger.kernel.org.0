Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC4C3A83DE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhFOP0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFOP03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:26:29 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA058C061574;
        Tue, 15 Jun 2021 08:24:24 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g142so21058464ybf.9;
        Tue, 15 Jun 2021 08:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=go8etVUSPam/RXp59SVNeV7o5Rn0KajVHY1f4pDfNlk=;
        b=A0Ncg5Lsp/PS8idHp/dZVKajipn/f3yHSfdDZkoVDOZy8E1vds17Ih3k3B7yDmQaTK
         z91qaLGVyFByLGla5TDpFXGrYeQndPApJCx5MNBBF5JcIYL05jBY4OfNKwkLVA0Zj6Xz
         140VjMrVU3ChW+5yZCUfB8sq3CafwIpjncJcQOXgGyQ0vmfK5nr5zGC5oUK39WYg3zed
         su4xHF8yTsoD9Md8G04o400al4LEHiM8XP5wAON3I1fTAMQxpIDTxgFVMwzh8eMmxGJP
         t8NF9B0Eqvnjk8XpmNndMwN3ZVmw+HG1Scf7lMEUqqG5LRICJsVoAoZRd9dW8AYC8hzi
         6viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=go8etVUSPam/RXp59SVNeV7o5Rn0KajVHY1f4pDfNlk=;
        b=dudPGxtd8qzFWq1UcciLFLWiuqi7dRCAdaWXylZ9BcEqwhHUe7jkvcCX4GdfQxwZxU
         ivJdhDRDGdN1rXdMe+LViO3XjDZvRgOuI24b+ILr4z4+Ircq06KOfcfUaFw7OMnKW+96
         gNnvyXH+bVhAYECKIE/CvmkYOtYn99JBr21bWtnVvrCYzy7Ze43ojDlFB6w+oTK4P/+S
         H/Kr0uarNvifvMcWP9sZelqi2F8KYCCuMEOCMM//Nw+bTFNUP7lFVU+4tUCtGte1gTiB
         UKrj+9trtG16FyIdZF9FXJuCuaLdUAloVvHvYWu1IP/UtoRJE9dZTrzQc38Hs9DKlxvB
         pyIQ==
X-Gm-Message-State: AOAM5305/DXjwhiT+aRJoZiiMO0eGAxwJxQobGSHcghqYZzkwcYqIrcx
        9eFZncqQnpT5s9RgBJwQFVZPQ2a+SNXcT53VOmA=
X-Google-Smtp-Source: ABdhPJxIDNod+NIOzr0ojDDE5Pob+v8E1Q4Km6DXzcHWIqgMx17DhKlDE3g/V6gTj0Eye0oO21VFy20vboY4s+YIzsQ=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr32077463ybg.459.1623770663989;
 Tue, 15 Jun 2021 08:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
 <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
 <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com> <CAADnVQJ3CQ=WnsantyEy6GB58rdsd7q=aJv93WPsZZJmXdJGzQ@mail.gmail.com>
In-Reply-To: <CAADnVQJ3CQ=WnsantyEy6GB58rdsd7q=aJv93WPsZZJmXdJGzQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Jun 2021 08:24:13 -0700
Message-ID: <CAEf4BzZWr7HhKn3opxHeaZqkgo4gsYYhDQ4d4HuNhx-i8XgjCg@mail.gmail.com>
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

On Mon, Jun 14, 2021 at 10:41 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 14, 2021 at 10:31 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jun 14, 2021 at 8:29 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Jun 14, 2021 at 9:51 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > +     ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> > > > > +                                         (u64)(long)key,
> > > > > +                                         (u64)(long)t->value, 0, 0);
> > > > > +     WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> > > >
> > > > I didn't find that next patch disallows callback return value 1 in the
> > > > verifier. If we indeed disallows return value 1 in the verifier. We
> > > > don't need WARN_ON here. Did I miss anything?
> > >
> > > Ohh. I forgot to address this bit in the verifier. Will fix.
> > >
> > > > > +     if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> > > > > +             /* If the timer wasn't active or callback already executing
> > > > > +              * bump the prog refcnt to keep it alive until
> > > > > +              * callback is invoked (again).
> > > > > +              */
> > > > > +             bpf_prog_inc(t->prog);
> > > >
> > > > I am not 100% sure. But could we have race condition here?
> > > >     cpu 1: running bpf_timer_start() helper call
> > > >     cpu 2: doing hrtimer work (calling callback etc.)
> > > >
> > > > Is it possible that
> > > >    !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
> > > > may be true and then right before bpf_prog_inc(t->prog), it becomes
> > > > true? If hrtimer_callback_running() is called, it is possible that
> > > > callback function could have dropped the reference count for t->prog,
> > > > so we could already go into the body of the function
> > > > __bpf_prog_put()?
> > >
> > > you're correct. Indeed there is a race.
> > > Circular dependency is a never ending headache.
> > > That's the same design mistake as with tail_calls.
> > > It felt that this case would be simpler than tail_calls and a bpf program
> > > pinning itself with bpf_prog_inc can be made to work... nope.
> > > I'll get rid of this and switch to something 'obviously correct'.
> > > Probably a link list with a lock to keep a set of init-ed timers and
> > > auto-cancel them on prog refcnt going to zero.
> > > To do 'bpf daemon' the prog would need to be pinned.
> >
> > Hm.. wouldn't this eliminate that race:
> >
> > switch (hrtimer_try_to_cancel(&t->timer))
> > {
> > case 0:
> >     /* nothing was queued */
> >     bpf_prog_inc(t->prog);
> >     break;
> > case 1:
> >     /* already have refcnt and it won't be bpf_prog_put by callback */
> >     break;
> > case -1:
> >     /* callback is running and will bpf_prog_put, so we need to take
> > another refcnt */
> >     bpf_prog_inc(t->prog);
> >     break;
> > }
> > hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
> >
> > So instead of guessing (racily) whether there is a queued callback or
> > not, try to cancel just in case there is. Then rely on the nice
> > guarantees that hrtimer cancellation API provides.
>
> I haven't thought it through yet, but the above approach could
> indeed solve this particular race. Unfortunately there are other races.
> There is an issue with bpf_timer_init. Since it doesn't take refcnt
> another program might do lookup and bpf_timer_start
> while the first prog got to refcnt=0 and got freed.

I think it's because of an API design. bpf_timer_init() takes a
callback (i.e., bpf_prog) but doesn't really do anything with it (so
doesn't take refcnt). It's both problematic, as you point out, and
unnecessarily restricting because it doesn't allow to change the
callback (e.g., when map is shared and bpf_program has to be changed).
If you change API to be:

long bpf_timer_init(struct bpf_timer *timer, int flags);
long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsecs);

You'll avoid this problem because bpf_timer_start will take refcnt
when arming (or re-arming) the timer. bpf_timer_init() will only take
care of initial memory allocation and hrtimer_init, but will leave
timer->prog as NULL until bpf_timer_start(). Wouldn't that solve all
the problems and be more flexible/powerful? If necessary, we can teach
bpf_timer_cb() to take spinlock briefly to avoid races fetching prog
pointer, but I haven't thought much about whether that's necessary.

If we wanted to push this to extreme, btw, we don't really need
bpf_timer_init(), bpf_timer_start() can do bpf_hrtimer allocation the
very first time (having pre-allocated spinlock makes this non-racy and
easy). But I don't know how expensive hrtimer_init() is, so it might
still make sense to split those two operations. Further, merging
bpf_timer_init() and bpf_timer_start() would require 6 input
arguments, which is a bit problematic. I have an idea how to get rid
of the necessity to pass in bpf_prog (so we'll be fine with just 5
explicit arguments), which simplifies other things (like
bpf_cgroup_storage implementation) as well, but I don't have patches
yet.

> Adding refcnt to bpf_timer_init() makes the prog self pinned
> and no callback might ever be executed (if there were no bpf_timer_start),
> so that will cause a high chance of bpf prog stuck in the kernel.
> There could be ref+uref schemes similar to tail_calls to address all that,
> but it gets ugly quickly.
> imo all these issues and races is a sign that such self pinning
> shouldn't be allowed.

I think prog refcounting is actually the saner and less surprising
approach here and we just need to spend a bit more time thinking how
to make everything work reliably. hrtimer API seems to be designed to
handle cases like this, which makes everything much easier.
