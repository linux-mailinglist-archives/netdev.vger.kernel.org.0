Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31B3A909A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 06:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhFPE2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 00:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhFPE2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 00:28:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98825C061574;
        Tue, 15 Jun 2021 21:26:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o10-20020a17090aac0ab029016e92770073so972014pjq.5;
        Tue, 15 Jun 2021 21:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IGPnQR0DXxW9KGv86dscHuYz3Hnuvg1X8HOetxIIh1Y=;
        b=uatP2MlS0ta/TNem5phkbzTebgoJUSFf1ajsTvQR14f5vF81WdPH9HBmvCP8w1fkee
         A5Kmgpw1keSbeE1biiIpvrH8EldNV7MgwvqHKDJ+fbMskLJxlEKweFttMLlfSpFVw+F4
         T46BlednFnONROxJHgRsiMmK4hAfmIOaMi3CNdxDp2bkeq/+9u6BgPQ21o3gwVUbU5Ly
         +U75NnD6HHgvdFjypvVbWkFt9MYCWtLxr9opzeGR0TBiTN+W5Une4egUIkqsKxljWd/f
         1EjVB6fQf3x3wkjdIs7mZt8OMhliqMbYXtLFESCyzJvJloq2j/ce5LBC0KdWRJK52UoU
         g+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IGPnQR0DXxW9KGv86dscHuYz3Hnuvg1X8HOetxIIh1Y=;
        b=jmRgI9bdF/queQv1sIdUIvwgNBy4C7g/9mcTLmMWfg3hCbOlvuASYDDrvsub+hyrFF
         ZeXrqFDlDRNDkkZvobdY1xRYtKGZjFdwQymDa7aD4rz8uAwkftS+4zLX9WILMw0xIEcH
         /fBd+Iczdb11s9Fu+MYpyTQHHWxrqbMTaixoY2yQ37WMd4ZAmaZbyvYnWMDt0BBTk7JU
         L02fX9dYuGZqS3/7lJIbkVpognva15dImskZ9EV1+Lvk/hE3iL74EIexMrUdR7v3oLJE
         /qFuW0w0iPo9jqU74x0KhWOoA9Uw+dkWbJsRaFpEV1aQ5D2ftrwrYQP5ozsw4yxUYrub
         CrKw==
X-Gm-Message-State: AOAM531NichhhqjboMznS55fiEFYBcdJurRQcpU1fC+CwzkPRJInbHqJ
        Jh+u7FCHUXslzUfeq58xR1U=
X-Google-Smtp-Source: ABdhPJwQNPVCoPqat6fa9lfA3whRCD31NC/ZwStqanammPLg3Mg0+KO80Jr+KdHN2/CpvBomyTTuuw==
X-Received: by 2002:a17:902:748c:b029:119:653b:a837 with SMTP id h12-20020a170902748cb0290119653ba837mr7378118pll.68.1623817585986;
        Tue, 15 Jun 2021 21:26:25 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:621])
        by smtp.gmail.com with ESMTPSA id r4sm634842pja.41.2021.06.15.21.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 21:26:25 -0700 (PDT)
Date:   Tue, 15 Jun 2021 21:26:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210616042622.22nzdrrnlndogn5w@ast-mbp>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
 <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
 <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
 <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com>
 <CAADnVQJ3CQ=WnsantyEy6GB58rdsd7q=aJv93WPsZZJmXdJGzQ@mail.gmail.com>
 <CAEf4BzZWr7HhKn3opxHeaZqkgo4gsYYhDQ4d4HuNhx-i8XgjCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZWr7HhKn3opxHeaZqkgo4gsYYhDQ4d4HuNhx-i8XgjCg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 08:24:13AM -0700, Andrii Nakryiko wrote:
> On Mon, Jun 14, 2021 at 10:41 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jun 14, 2021 at 10:31 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jun 14, 2021 at 8:29 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Jun 14, 2021 at 9:51 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > > +     ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> > > > > > +                                         (u64)(long)key,
> > > > > > +                                         (u64)(long)t->value, 0, 0);
> > > > > > +     WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> > > > >
> > > > > I didn't find that next patch disallows callback return value 1 in the
> > > > > verifier. If we indeed disallows return value 1 in the verifier. We
> > > > > don't need WARN_ON here. Did I miss anything?
> > > >
> > > > Ohh. I forgot to address this bit in the verifier. Will fix.
> > > >
> > > > > > +     if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> > > > > > +             /* If the timer wasn't active or callback already executing
> > > > > > +              * bump the prog refcnt to keep it alive until
> > > > > > +              * callback is invoked (again).
> > > > > > +              */
> > > > > > +             bpf_prog_inc(t->prog);
> > > > >
> > > > > I am not 100% sure. But could we have race condition here?
> > > > >     cpu 1: running bpf_timer_start() helper call
> > > > >     cpu 2: doing hrtimer work (calling callback etc.)
> > > > >
> > > > > Is it possible that
> > > > >    !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
> > > > > may be true and then right before bpf_prog_inc(t->prog), it becomes
> > > > > true? If hrtimer_callback_running() is called, it is possible that
> > > > > callback function could have dropped the reference count for t->prog,
> > > > > so we could already go into the body of the function
> > > > > __bpf_prog_put()?
> > > >
> > > > you're correct. Indeed there is a race.
> > > > Circular dependency is a never ending headache.
> > > > That's the same design mistake as with tail_calls.
> > > > It felt that this case would be simpler than tail_calls and a bpf program
> > > > pinning itself with bpf_prog_inc can be made to work... nope.
> > > > I'll get rid of this and switch to something 'obviously correct'.
> > > > Probably a link list with a lock to keep a set of init-ed timers and
> > > > auto-cancel them on prog refcnt going to zero.
> > > > To do 'bpf daemon' the prog would need to be pinned.
> > >
> > > Hm.. wouldn't this eliminate that race:
> > >
> > > switch (hrtimer_try_to_cancel(&t->timer))
> > > {
> > > case 0:
> > >     /* nothing was queued */
> > >     bpf_prog_inc(t->prog);
> > >     break;
> > > case 1:
> > >     /* already have refcnt and it won't be bpf_prog_put by callback */
> > >     break;
> > > case -1:
> > >     /* callback is running and will bpf_prog_put, so we need to take
> > > another refcnt */
> > >     bpf_prog_inc(t->prog);
> > >     break;
> > > }
> > > hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);

Turned out that this approach has the same race as Yonghong mentioned.
Calling hrtimer_callback_running() directly or through hrtimer_try_to_cancel()
with extra cpu_base->lock as in above doesn't prevent the race.
bpf_prog_put could have already happened and above case:
 case -1:
     /* callback is running and will bpf_prog_put, so we need to take
 another refcnt */
     bpf_prog_inc(t->prog);

would be incrementing refcnt from zero.

> > >
> > > So instead of guessing (racily) whether there is a queued callback or
> > > not, try to cancel just in case there is. Then rely on the nice
> > > guarantees that hrtimer cancellation API provides.
> >
> > I haven't thought it through yet, but the above approach could
> > indeed solve this particular race. Unfortunately there are other races.
> > There is an issue with bpf_timer_init. Since it doesn't take refcnt
> > another program might do lookup and bpf_timer_start
> > while the first prog got to refcnt=0 and got freed.
> 
> I think it's because of an API design. bpf_timer_init() takes a
> callback (i.e., bpf_prog) but doesn't really do anything with it (so
> doesn't take refcnt). It's both problematic, as you point out, and
> unnecessarily restricting because it doesn't allow to change the
> callback (e.g., when map is shared and bpf_program has to be changed).
> If you change API to be:
> 
> long bpf_timer_init(struct bpf_timer *timer, int flags);
> long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsecs);
> 
> You'll avoid this problem because bpf_timer_start will take refcnt
> when arming (or re-arming) the timer. bpf_timer_init() will only take
> care of initial memory allocation and hrtimer_init, but will leave
> timer->prog as NULL until bpf_timer_start(). Wouldn't that solve all
> the problems and be more flexible/powerful?

Unfortunately no. The race would still be present and I don't see
a clean way of solving.

> If necessary, we can teach
> bpf_timer_cb() to take spinlock briefly to avoid races fetching prog
> pointer, but I haven't thought much about whether that's necessary.

That doesn't help either.
hrtimer_try_to_cancel() returning -1 (or checking it via
hrtimer_callback_running) doesn't mean that refcnt > 0.
It could have reached zero in bpf_timer_cb.
I thought whether introducing bpf_prog_inc_if_not_zero()
and using it in bpf_timer_start() could solve it...
Nope. The prog pointer could be already be freed if processing
of bpf_timer_cb is slow enough.
Then I thought whether we can move refcnt from prog into
'struct bpf_timer_kern'...
Then considered ref/uref counting...
It's slippery slop of wrong turns.

> If we wanted to push this to extreme, btw, we don't really need
> bpf_timer_init(), bpf_timer_start() can do bpf_hrtimer allocation the
> very first time (having pre-allocated spinlock makes this non-racy and
> easy). But I don't know how expensive hrtimer_init() is, so it might
> still make sense to split those two operations.

hrtimer_init is cheap, but bpf_timer_init() is expensive due
to memory allocation.
It's done once, so arguably should be ok,
but I'd like to avoid reinventing the wheel and stick
to api-s similar to hrtimer.

> Further, merging
> bpf_timer_init() and bpf_timer_start() would require 6 input
> arguments, which is a bit problematic. I have an idea how to get rid
> of the necessity to pass in bpf_prog (so we'll be fine with just 5
> explicit arguments), which simplifies other things (like
> bpf_cgroup_storage implementation) as well, but I don't have patches
> yet.
> 
> > Adding refcnt to bpf_timer_init() makes the prog self pinned
> > and no callback might ever be executed (if there were no bpf_timer_start),
> > so that will cause a high chance of bpf prog stuck in the kernel.
> > There could be ref+uref schemes similar to tail_calls to address all that,
> > but it gets ugly quickly.
> > imo all these issues and races is a sign that such self pinning
> > shouldn't be allowed.
> 
> I think prog refcounting is actually the saner and less surprising
> approach here and we just need to spend a bit more time thinking how
> to make everything work reliably. hrtimer API seems to be designed to
> handle cases like this, which makes everything much easier.

I made two 180 degree turns already. In the beginning I was strongly
against circular dependencies since old history of tail_call taught us
a valuable lesson. Then somehow convinced myself that this time around it will
be different and went with this crazy refcnting scheme. The last couple
weeks you, me, Yonghong, Toke and others invested countless hours thinking
through the race conditions. It's a sign that design took the wrong turn.
Circular dependencies must be avoided if possible. Here it's such case.
There is no need to complicate bpf_timer with crazy refcnting schemes.
The user space can simply pin the program in bpffs. In the future we might
introduce a self-pinning helper that would pin the program and create a file.
Sort-of like syscall prog type would pin self.
That would be explicit and clean api instead of obscure hacks inside bpf_timer*().
