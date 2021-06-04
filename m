Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C3539BF73
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFDSTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:19:31 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:34690 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFDSTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:19:30 -0400
Received: by mail-lf1-f42.google.com with SMTP id f30so15439965lfj.1;
        Fri, 04 Jun 2021 11:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NAjaWyTYv+x+pi7Y0FNiv4m5t12ORw+rlZaX/3xoVHI=;
        b=VXrQpFQs333sknQ4y1ynnjGaglaFfk7vD+QiTUsXQy75BuW9SVH3ES9JUAB/UqZxKy
         q+Qdg5OVZg0laG7vfasY2xIB+PleqtIyBy7awXgvJgQ974XqXBwGLvHvS0TtQ3klz3sX
         T4ed+cgwVO7tysLzk4RrZkn0l7FeCY6PoW8t0kVXasnLojeyQ6ekU5dEqOvuGhBDjEWm
         YG8M6P/DU8UbjRioimtfXFW5iEFat1Wny3pj7Mrk65dT3kgyUAcx8fHSASzXMaM3pVm8
         si2ECitvJyvcHKGZ1qft9lZG6iBonJpw5j2Je8CiMBS8Hc9qMwFBAsM5SVBkaxjbS1ut
         aoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NAjaWyTYv+x+pi7Y0FNiv4m5t12ORw+rlZaX/3xoVHI=;
        b=nyiBIRdWFzjJOvZy12F59iVwz7Pcsb/aaYDS82dJIAsR9pQKvdh1jgOuIHlgJr17N3
         ZZIhUuOGT+DTQhs9j06lzswtpaEfW4IQgEg4mP226PSSdksm0x39ppNbA4VpDO+Dny5Y
         I1OYu8LwwXjHntuVRAS8UQdyV3aGQUJtVV90JiBEuzApM16mHUq8IgwlhqWe72cDVWJp
         ROcq7KG89tdu9LVhItvCFybb0wT8BlytmcnFH93jtCpSYZIZLDvjoCypAaYeJVGSBAbw
         LVgQu+tuG8uqZtpb0HsrumOzMgRmOw8yaTceVw5VYymF/FobChup7opOD8ueYMlvw3sD
         22qQ==
X-Gm-Message-State: AOAM5314n/qEeL9YF53pVu17VPMIdm2cAynHD7HZ5Wb826zrXiSG7Rss
        n6f/6hzWV2UvebjKj6CXXekOseJmeV3VYKXWzec=
X-Google-Smtp-Source: ABdhPJwM39dxxct3M9lVxSMN+/O4alLYLK/kBjyoPrXshMR12vUClBrhgfzZ6yS6H7BZN+gqYGDmLD6jZ9Cw0SJbt0U=
X-Received: by 2002:a05:6512:2010:: with SMTP id a16mr933043lfb.38.1622830602810;
 Fri, 04 Jun 2021 11:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com> <CAEf4BzbyikY1b4vAzb+t88odbqWOR7K4TpwjM1zGF4Nmqu6ysg@mail.gmail.com>
 <20210603015330.vd4zgr5rdishemgi@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzafEP_b7vXT9pTB4mDWWP7N5ACe82V3yq-1doH=awNbUg@mail.gmail.com>
 <20210604011231.p24eb6py7hjhskn3@ast-mbp.dhcp.thefacebook.com> <CAEf4BzY1oL76pMsNW6f8J=MZuM1mroyAFhMxR0OpYdQNaZT13Q@mail.gmail.com>
In-Reply-To: <CAEf4BzY1oL76pMsNW6f8J=MZuM1mroyAFhMxR0OpYdQNaZT13Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Jun 2021 11:16:31 -0700
Message-ID: <CAADnVQJiXNU7O=56U-5RP0MycY4knzi556rzdoBHKp_dZrzZ4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 9:17 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> >
> > > So your idea is to cmpxchg() to NULL while bpf_timer_start() or
> > > bpf_timer_cancel() works with the timer? Wouldn't that cause
> > > bpf_timer_init() believe that that timer is not yet initialized and
> > > not return -EBUSY. Granted that's a corner-case race, but still.
> >
> > Not following.
> > bpf prog should do bpf_timer_init only once.
> > bpf_timer_init after bpf_timer_cancel is a wrong usage.
> > hrtimer api doesn't have any protection for such use.
> > while bpf_timer_init returns EBUSY.
> > 2nd bpf_timer_init is just a misuse of bpf_timer api.
>
> Yes, clearly a bad use of API, but it's not prevented by verifier.

not prevented only because it's hard to do in the verifier.

> > > > Currently thinking to do cmpxchg in bpf_timer_start() and
> > > > bpf_timer_cancel*() similar to bpf_timer_init() to address it.
>
> because that seemed like you were going to exchange (temporarily) a
> pointer to NULL while doing bpf_timer_start() or bpf_timer_cancel(),
> and then setting NULL -> valid ptr back again (this sequence would
> open up a window when bpf_timer_init() can be used twice on the same
> element). But again, with spinlock embedded doesn't matter anymore.

Right, except bpf_timer_start and bpf_timer_cancel would xchg with -1 or similar
and bpf_timer_init won't get confused.
If two bpf_timer_start()s race on the same timer one would receive
-EMISUSEOFAPI right away.
Whereas with spin_lock inside bpf_timer both will be serialized and
both will succeed.
One can argue that bpf_timer_start and bpf_timer_cancel on different cpus
is a realistic scenario. So xchg approach would need two special
pointers -1 and -2
to distinguish start/start bad race vs start/cancel good race.
And everything gets too clever. spin_lock is "obviously correct",
though it doesn't have an advantage of informing users of api misuse.
I coded it up and it's surviving the tests so far :)
