Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6839A94D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhFCRh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:37:57 -0400
Received: from mail-yb1-f177.google.com ([209.85.219.177]:35808 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFCRh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:37:56 -0400
Received: by mail-yb1-f177.google.com with SMTP id i4so9974032ybe.2;
        Thu, 03 Jun 2021 10:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fhXTrmiEVYD8RNIr+33wie+6gXkAl42tkhV11H/Xek8=;
        b=koOQMSH2ClflXWmOaQ1UuCknUIzGEUclH0xn/3jthccqoJ4gf8jS3YykpJLwpe1mIm
         qApUJ33f57yAGAEYUUQlcRLh/Qxsd5++LiWtKyjps9odjtzE/mmsmIK7uKGWxSs+zGd4
         CWVUj+xEW3srNkQYQ3pcxaVbw3P6GqNabic1ztNTOPZDKNIFXuQybbALcD011hp+uDdS
         wZfOUuB3cHB+tZFrv/F/jk/9+nKru09uso5331AHjDYlr+pK3BvD4LXTnj2NhUgHjxE9
         fxgLfic5snfpmsWoy6EGEEqhLeXVwiuGy2NJLMbhUu1sgKyN4Myy/Xa3+o1+DJSIcgCl
         AiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fhXTrmiEVYD8RNIr+33wie+6gXkAl42tkhV11H/Xek8=;
        b=uhPD5wks2zn5yjR7E5PUnLrk1xCitUnssapbk+cxHSfwdOl4jOpEcbdxOycPeiF5CP
         aqUc793dVcpgCAYyb4eociCknWxdiJHP5vjjIiLOp6tpxhDldRk5sgOkp3T/8CNcPQlg
         s8RgRvEc3AL1a+2mAipfIb/uWyMOm/OyTPsiN9L08kZy8qEwySC59siCxJcuh14LO8ZE
         drTF7WBogw6a0cAqj41LH5UKYiUs1J/RC5TaAt2etI07rvTv6arWIcmTlTDQMmaesffY
         R6bj3ZeUchBKMP8ZpUz3oZf+rmwSYg1kZx7xgBj2dUn0e/svtOQmhOEvx+htDPc3XeQ3
         Ubwg==
X-Gm-Message-State: AOAM5331Wv+MwlZjgG57ckrxzpP7HEZ6uftwIsBs+wkqe6Sj73+2nXen
        G5Q/Yp5E+vQficneEULFHroTtW5iQw0I1pYN19Q=
X-Google-Smtp-Source: ABdhPJwYsVOmvs9NcJW5ZezwjgY3yzsZ3IpI6Lj+Genk+l845YcdEHtRGopdbtmKi192mlUSACFZDGV1rjA6u70oZis=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr280086ybr.425.1622741711434;
 Thu, 03 Jun 2021 10:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-3-alexei.starovoitov@gmail.com> <CAEf4BzbPkUdsY8XD5n2yMB8CDvakz4jxshjF8xrzqHXQS0ct9g@mail.gmail.com>
 <20210603020419.mhnueugljj5cs3ie@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210603020419.mhnueugljj5cs3ie@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Jun 2021 10:35:00 -0700
Message-ID: <CAEf4BzYgxR38405LoyVrwPAzdiax-Fbu+2hNrqPa_6xSnoGWiA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add verifier checks for bpf_timer.
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

On Wed, Jun 2, 2021 at 7:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jun 02, 2021 at 03:34:29PM -0700, Andrii Nakryiko wrote:
> >
> > >  /* copy everything but bpf_spin_lock */
> > >  static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
> > >  {
> > > +       u32 off = 0, size = 0;
> > > +
> > >         if (unlikely(map_value_has_spin_lock(map))) {
> > > -               u32 off = map->spin_lock_off;
> > > +               off = map->spin_lock_off;
> > > +               size = sizeof(struct bpf_spin_lock);
> > > +       } else if (unlikely(map_value_has_timer(map))) {
> > > +               off = map->timer_off;
> > > +               size = sizeof(struct bpf_timer);
> > > +       }
> >
> > so the need to handle 0, 1, or 2 gaps seems to be the only reason to
> > disallow both bpf_spinlock and bpf_timer in one map element, right?
>
> exactly.
>
> > Isn't it worth addressing it from the very beginning to lift the
> > artificial restriction? E.g., for speed, you'd do:
> >
> > if (likely(neither spinlock nor timer)) {
> >  /* fastest pass */
> > } else if (only one of spinlock or timer) {
> >   /* do what you do here */
> > } else {
> >   int off1, off2, sz1, sz2;
> >
> >   if (spinlock_off < timer_off) {
> >     off1 = spinlock_off;
> >     sz1 = spinlock_sz;
> >     off2 = timer_off;
> >     sz2 = timer_sz;
> >   } else {
> >     ... you get the idea
>
> Not really :)

hm, really? I meant that else will be:

     off1 = timer_off;
     sz1 = timer_sz;
     off2 = spinlock_off;
     sz2 = spinlock_sz;

Just making sure that off1 < off2 always and sz1 and sz2 are matching

> Are you suggesting to support one bpf_spin_lock and one
> bpf_timer inside single map element, but not two spin_locks
> and/or not two bpf_timers?

Yes, exactly. I see bpf_spinlock and bpf_timer as two independent
orthogonal features and I don't understand why we restrict using just
one of them in a given map element. I think those 20 lines of code
that decouples them and removes artificial restriction that users need
to remember (or discover with surprise) is totally worth it.

> Two me it's either one or support any.

I think it's fine to start with supporting one. But one of each. They
are independent of each other.

> Anything in-between doesn't seem worth extra code.

Up to you, but I disagree, obviously. It's possible to work-around
that limitation with extra maps/complexity, so if I ever need to both
lock an element and schedule the timer with it, it's not going to stop
me. :)

>
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index f386f85aee5c..0a828dc4968e 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -3241,6 +3241,15 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
> > >                         return -EACCES;
> > >                 }
> > >         }
> > > +       if (map_value_has_timer(map)) {
> > > +               u32 t = map->timer_off;
> > > +
> > > +               if (reg->smin_value + off < t + sizeof(struct bpf_timer) &&
> >
> > <= ? Otherwise we allow accessing the first byte, unless I'm mistaken.
>
> I don't think so. See the comment above in if (map_value_has_spin_lock(map))
> I didn't copy-paste it, because it's the same logic.

Oh, I didn't realize that this is the interval intersection check I
suggested a long time ago :) yeah, that still looks correct

>
> > > -       if (val) {
> > > -               /* todo: relax this requirement */
> > > -               verbose(env, "bpf_timer field can only be first in the map value element\n");
> >
> > ok, this was confusing, but now I see why you did that...
>
> I'll clarify the comment to say that the next patch fixes it.

ok, thanks
