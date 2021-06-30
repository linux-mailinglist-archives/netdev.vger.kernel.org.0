Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FEE3B87D0
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhF3Rlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbhF3Rl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:41:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFBDC0617AD;
        Wed, 30 Jun 2021 10:39:00 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h6so760497plf.11;
        Wed, 30 Jun 2021 10:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OupyowH9BBI4uttcWt4YzocgT3IPmL5mRDSVQam94G0=;
        b=iYVlVlr6GLpHKyoCyyERuWxb/BmIDC6b6aMbEIlrWqB5EgqM5r3XAoS4WQpOSvSHKt
         hdPqbIVosI54c3Y994ZSiFRmJ4NP7t1gJYSHN6edQ0U94yj4YqL5Rmqa5zp6yNQQX3vJ
         4uyCle6RbEFyhkCMlbz7i+DyreL0fi0b51BCQOBR2XMkpeh435y1XNx8Wi0GvVBaDpvV
         z/McIqtUI3XJ1ecjo4G2aVhX6fE8QW8RzXLEW7xUk5IY+uUWCjMQldoM2sqPmkpcjc9T
         6ils75uTCsTGLo0PeCA5hdJ9NyTFaJrFBYadvl0p5ZPnrASVCXgz0yDV6DcVHzpLzCuV
         T7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OupyowH9BBI4uttcWt4YzocgT3IPmL5mRDSVQam94G0=;
        b=RQqp2X+b4HrkLlMNhr5m30SFAe1UU1wsCwWhJv5TGZWJxPk/r/YfAcDwtyEfYGPsPP
         uYQQE6RGa1ArZ6tpqe4f8yzsazi/YvbqczR01bxh2+O+YoBEq1pIMwYhF1D//mEoMcUY
         4ig+cygMVITr1h1pMMNJergAXA1C4/Lg77ig61Cj5YmHv8c61+pEPanXXn9AcoBhilTF
         MGnicZLmmt9/5/bgkxLIK0GEHfOEwBar8vF4hVcz+gtIVpjs1yZjqkjr4W88mjGwdCzY
         kCuhL8YyzjjqgU3v0Ma19UG4VhC+wGLAhw0APE7ujP9+eyrdZlyI9X62Ph51xjmpdw2/
         QqOg==
X-Gm-Message-State: AOAM53366K6lbnAjv53bDm3/yyYLF6mscIUhow4J5+rN0F1rDO/YPAr0
        cUNQpOEGSAwNhF8lehUtWno=
X-Google-Smtp-Source: ABdhPJybctRw7N1J3e4EImEsxoLZxDgrY7u/y2OtRzDGIRgl79ntJ1d0Y86v5qmK+k+3sm3QE3hGTQ==
X-Received: by 2002:a17:902:b409:b029:114:afa6:7f4a with SMTP id x9-20020a170902b409b0290114afa67f4amr33616399plr.56.1625074739895;
        Wed, 30 Jun 2021 10:38:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:a932])
        by smtp.gmail.com with ESMTPSA id f6sm15805425pfj.28.2021.06.30.10.38.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jun 2021 10:38:59 -0700 (PDT)
Date:   Wed, 30 Jun 2021 10:38:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
Message-ID: <20210630173854.ofe2rvbghmkn4w6k@ast-mbp.dhcp.thefacebook.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
 <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaPPDEUvsx51mEpp_vJoXVwJQrLu5QnL4pSnL9YAPXevw@mail.gmail.com>
 <CAADnVQ+erEuHj_0cy16DBFSu_Otj-+60EZN__9W=vogeNQuBOg@mail.gmail.com>
 <CAEf4BzbpF7S2861ueTHC7u4avzFZU7vXkujNX+bLewd4hN5trw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbpF7S2861ueTHC7u4avzFZU7vXkujNX+bLewd4hN5trw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 01:08:08PM +0300, Andrii Nakryiko wrote:
> On Tue, Jun 29, 2021 at 4:28 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jun 28, 2021 at 11:34 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > Have you considered alternatively to implement something like
> > > bpf_ringbuf_query() for BPF ringbuf that will allow to query various
> > > things about the timer (e.g., whether it is active or not, and, of
> > > course, remaining expiry time). That will be more general, easier to
> > > extend, and will cover this use case:
> > >
> > > long exp = bpf_timer_query(&t->timer, BPF_TIMER_EXPIRY);
> > > bpf_timer_start(&t->timer, new_callback, exp);
> >
> > yes, but...
> > hrtimer_get_remaining + timer_start to that value is racy
> > and not accurate.
> 
> yes, but even though we specify expiration in nanosecond precision, no
> one should expect that precision w.r.t. when callback is actually
> fired. So fetching current expiration, adding new one, and re-setting
> it shouldn't be a problem in practice, IMO.

Just because we're dealing with time? Sounds sloppy. I suspect RT
folks take pride to make nsec precision as accurate as possible.

> I just think the most common case is to set a timer once, so ideally
> usability is optimized for that (so taken to extreme it would be just
> bpf_timer_start without any bpf_timer_init, but we've already
> discussed this, no need to do that again here). Needing bpf_timer_init
> + bpf_timer_set_callbcack + bpf_timer_start for a common case feels
> suboptimal usability-wise.

init+set+start could be one helper. See more below.

> 
> There is also a new race with bpf_timer_set_callback +
> bpf_timer_start. Callback can fire inbetween those two operations, so
> we could get new callback at old expiration or old callback with new
> expiration. 

sure, but that's a different issue.
When XDP prog is being replaced some packets might hit old one
even though there is an atomic replace of the pointer to a prog.
Two XDP progs and two timer callbacks running on different cpus
is an inevitable situation.

> To do full update reliably, you'd need to explicitly
> bpf_timer_cancel() first, at which point separate
> bpf_timer_set_callback() doesn't help at all.
> 
> > hrtimer_get_expires_ns + timer_start(MODE_ABS)
> > would be accurate, but that's an unnecessary complication.
> > To live replace old bpf prog with new one
> > bpf_for_each_map_elem() { bpf_timer_set_callback(new_prog); }
> > is much faster, since timers don't need to be dequeue, enqueue.
> > No need to worry about hrtimer machinery internal changes, etc.
> > bpf prog being replaced shouldn't be affecting the rest of the system.
> 
> That's a good property, but if it was done as a
> bpf_timer_set_callback() in addition to current
> bpf_timer_start(callback_fn) it would still allow to have a simple
> typical use.
> 
> Another usability consideration. With mandatory
> bpf_timer_set_callback(), bpf_timer_start() will need to return some
> error code if the callback wasn't set yet, right? I'm afraid that in
> practice it will be the situation similar to bpf_trace_printk() where
> people expect that it always succeeds and will never check the return
> code. It's obviously debuggable, but a friction point nevertheless.

It sucks that you had this printk experience. We screwed up.
It's definitely something to watch out for in the future.
But this analogy doesn't apply here.
bpf_timer_init/set_callback/start/cancel matches one to one to hrtimer api.
In earlier patches the callback setting was part of 'init' and then later
it was part of 'start'. imo that was 'reinvent the wheel' moment.
Not sure why such simple and elegant solution as indepdent
bpf_timer_set_callback wasn't obvious earlier.
There are tons of examples of hrtimer usage in the kernel
and it's safe to assume that bpf usage will be similar.
Typically the kernel does init + set_callback once and then start/cancel a lot.
Including doing 'start' from the callback.
I found one driver where callback is being selected dynamically.
So even without 'bpf prog live replace' use case there could be
use cases for dynamic set_callback for bpf timers too.
In all cases I've examined the 'start' is the most used function.
Coupling it with setting callback looks quite wrong to me from api pov.
Like there are examples in the kernel where 'start' is done in one .c file
while callback is defined in a different .c file.
Doing 'extern .. callback();' just to pass it into hrimter_start()
would have been ugly. Same thing we can expect to happen with bpf timers.

But if you really really want bpf_timer_start with callback I wouldn't
mind to have:
static inline int bpf_timer_start2(timer, callback, nsec)
{
  int err = bpf_timer_set_callback(timer, callback);
  if (err)...
  err = bpf_timer_start(timer, nsec, 0);
  ...
}
to be defined in libbpf's bpf_helpers.h file.
That could be a beginning of new way of defining helpers.
But based on the kernel usage of the hrimter I suspect that this helper
won't be used too much and people will stick to independent
steps to set callback and start it.

There could be a helper that does init+set+start too.

> >
> > > This will keep common timer scenarios to just two steps, init + start,
> > > but won't prevent more complicated ones. Things like extending
> > > expiration by one second relative that what was remaining will be
> > > possible as well.
> >
> > Extending expiration would be more accurate with hrtimer_forward_now().
> >
> > All of the above points are minor compared to the verifier advantage.
> > bpf_timer_set_callback() typically won't be called from the callback.
> > So verifier's insn_procssed will be drastically lower.
> > The combinatorial explosion of states even for this small
> > selftests/bpf/progs/timer.c is significant.
> > With bpf_timer_set_callback() is done outside of callback the verifier
> > behavior will be predictable.
> > To some degree patches 4-6 could have been delayed, but since the
> > the algo is understood and it's working, I'm going to keep them.
> > It's nice to have that flexibility, but the less pressure on the
> > verifier the better.
> 
> I haven't had time to understand those new patches yet, sorry, so not
> sure where the state explosion is coming from. I'll get to it for real
> next week. But improving verifier internals can be done transparently,
> while changing/fixing BPF UAPI is much harder and more disruptive.

It's not about the inadequate implementation of the async callback
verification in patches 4-6 (as you're hinting).
It's path aware property of the verifier that requires more passes
when callback is set from callback. Even with brand new verifier 2.0
the more passes issue will remain the same (unless it's not path
aware and can merge different branches and states).
