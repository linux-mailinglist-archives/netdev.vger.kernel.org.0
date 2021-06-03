Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8614239A912
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFCRXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFCRXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:23:33 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7853C06174A;
        Thu,  3 Jun 2021 10:21:39 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n133so9882819ybf.6;
        Thu, 03 Jun 2021 10:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7PnhWU883KxevJCSzYlL17xLw6t03PdAUgdOsMONsd4=;
        b=uRDY8Os4DcjWrNUA7xh+f+zXOFFT3Ara0PqWHJP0FQK3czX5ChvsPw3BlZDaF7YvJD
         JbuChJNuxiQEOBql3m8lmkepS22ez1l2+1ec9BfgiOVIK1u9tRLczxaYk79Izxfx0fcs
         ZnZrZxFl4RwGYWPcWvHu+HrWDZ6QWSPAQXmoOTsAbnLBG4F7EU0gjmDizORI0TDkurKA
         u22KFqWsh+MzEjFwE9mi31+hdG+3mgVQp01ZEqRpk0sCGjd5IMNhVWYqgoIHxQ+YlkSL
         JSPNkgVdASCbYCo1puBYy9DwBHwOK/jDdygyAgm7F2o2tk0SOMjm1e3HPj3mnKy+8pZc
         Cx5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7PnhWU883KxevJCSzYlL17xLw6t03PdAUgdOsMONsd4=;
        b=sZzLFjyu3cese/NNImGZTNys5czqbecLPYSHe08ZYrqJaP/IUGKwOllEhKgbMoLmXK
         WgfXFALrNSkRNFoF/PZ1y7wbZBXvgXJW2JBsKT7qRhAgArvDgoW0z75T8R92NyIqASAM
         1KDWPNoEBMJGiBxvr7bLuzam6FCtPFZtQo4tzEe7GpsGA+p3KBP38KKnDjbQ3zgeRkbg
         2qTsilPUgMuyf58H09l0iYgAq6M1oKQnY+qlreN71O1vTVVq4t6P5ackIN/kx34zt7Cm
         Xua3vkcyBZFWjROxqtJPFz9knH0MXQf+Nmtw62VwHEOS5zXDhjFJdegxtxxSyCALQCna
         2Olw==
X-Gm-Message-State: AOAM5322TxZnEydRop9YA1jqKDziFsaFTWiEAU05o0CHLL9wdhMdDpYs
        2siRmIeAxu6YjW6H1Rb+GvFfytuYXF3M6CQTY9g=
X-Google-Smtp-Source: ABdhPJybk7tvmPrXi1+U/N7ly+vf8AENbWi9Q/a8cte3HOIamxIzqfJ9Zf0SIJ5NObdxjlKGyON1sN5WNbHLWCNFftA=
X-Received: by 2002:a25:1455:: with SMTP id 82mr210329ybu.403.1622740897497;
 Thu, 03 Jun 2021 10:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com> <87r1hsgln6.fsf@toke.dk>
 <20210602014608.wxzfsgzuq7rut4ra@ast-mbp.dhcp.thefacebook.com>
 <87a6o7aoxa.fsf@toke.dk> <20210603015809.l2dez754vzxjueew@ast-mbp.dhcp.thefacebook.com>
 <874kef9pth.fsf@toke.dk>
In-Reply-To: <874kef9pth.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Jun 2021 10:21:26 -0700
Message-ID: <CAEf4BzZYd02+TZRE1rya=SmGL5Jf9Ff+VebivsjCYLVWyETRhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 3:59 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Jun 03, 2021 at 12:21:05AM +0200, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Thu, May 27, 2021 at 06:57:17PM +0200, Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
> >> >> >     if (val) {
> >> >> >         bpf_timer_init(&val->timer, timer_cb2, 0);
> >> >> >         bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 =
msec */);
> >> >>
> >> >> nit: there are 1M nanoseconds in a millisecond :)
> >> >
> >> > oops :)
> >> >
> >> >> >     }
> >> >> > }
> >> >> >
> >> >> > This patch adds helper implementations that rely on hrtimers
> >> >> > to call bpf functions as timers expire.
> >> >> > The following patch adds necessary safety checks.
> >> >> >
> >> >> > Only programs with CAP_BPF are allowed to use bpf_timer.
> >> >> >
> >> >> > The amount of timers used by the program is constrained by
> >> >> > the memcg recorded at map creation time.
> >> >> >
> >> >> > The bpf_timer_init() helper is receiving hidden 'map' and 'prog' =
arguments
> >> >> > supplied by the verifier. The prog pointer is needed to do refcnt=
ing of bpf
> >> >> > program to make sure that program doesn't get freed while timer i=
s armed.
> >> >> >
> >> >> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> >>
> >> >> Overall this LGTM, and I believe it will be usable for my intended =
use
> >> >> case. One question:
> >> >>
> >> >> With this, it will basically be possible to create a BPF daemon, wo=
n't
> >> >> it? I.e., if a program includes a timer and the callback keeps re-a=
rming
> >> >> itself this will continue indefinitely even if userspace closes all=
 refs
> >> >> to maps and programs? Not saying this is a problem, just wanted to =
check
> >> >> my understanding (i.e., that there's not some hidden requirement on
> >> >> userspace keeping a ref open that I'm missing)...
> >> >
> >> > That is correct.
> >> > Another option would be to auto-cancel the timer when the last refer=
ence
> >> > to the prog drops. That may feel safer, since forever
> >> > running bpf daemon is a certainly new concept.
> >> > The main benefits of doing prog_refcnt++ from bpf_timer_start are ea=
se
> >> > of use and no surprises.
> >> > Disappearing timer callback when prog unloads is outside of bpf prog=
 control.
> >> > For example the tracing bpf prog might collect some data and periodi=
cally
> >> > flush it to user space. The prog would arm the timer and when callba=
ck
> >> > is invoked it would send the data via ring buffer and start another
> >> > data collection cycle.
> >> > When the user space part of the service exits it doesn't have
> >> > an ability to enforce the flush of the last chunk of data.
> >> > It could do prog_run cmd that will call the timer callback,
> >> > but it's racy.
> >> > The solution to this problem could be __init and __fini
> >> > sections that will be invoked when the prog is loaded
> >> > and when the last refcnt drops.
> >> > It's a complementary feature though.
> >> > The prog_refcnt++ from bpf_timer_start combined with a prog
> >> > explicitly doing bpf_timer_cancel from __fini
> >> > would be the most flexible combination.
> >> > This way the prog can choose to be a daemon or it can choose
> >> > to cancel its timers and do data flushing when the last prog
> >> > reference drops.
> >> > The prog refcnt would be split (similar to uref). The __fini callbac=
k
> >> > will be invoked when refcnt reaches zero, but all increments
> >> > done by bpf_timer_start will be counted separately.
> >> > The user space wouldn't need to do the prog_run command.
> >> > It would detach the prog and close(prog_fd).
> >> > That will trigger __fini callback that will cancel the timers
> >> > and the prog will be fully unloaded.
> >> > That would make bpf progs resemble kernel modules even more.
> >>
> >> I like the idea of a "destructor" that will trigger on refcnt drop to
> >> zero. And I do think a "bpf daemon" is potentially a useful, if novel,
> >> concept.
> >
> > I think so too. Long ago folks requested periodic bpf progs to
> > do sampling in tracing. All these years attaching bpf prog
> > to a perf_event was a workaround for such feature request.
> > perf_event bpf prog can be pinned in perf_event array,
> > so "bpf daemon" kinda exist today. Just more convoluted.
>
> Right, agreed - triggering periodic sampling directly from BPF does seem
> like the right direction.

This is one of the cases where knowing (or being able to specify) the
CPU to run on is very important, btw.

Which made me think about scheduling timeout on a specific CPU from
another CPU. Is it possible with hrtimer? If yes, should it be done
through bpf_timer_init() or bpf_timer_start()?

>
> >> The __fini thing kinda supposes a well-behaved program, though, right?
> >> I.e., it would be fairly trivial to write a program that spins forever
> >> by repeatedly scheduling the timer with a very short interval (whether
> >> by malice or bugginess).
> >
> > It's already possible without bpf_timer.
>
> Hmm, fair point.
>
> >> So do we need a 'bpfkill' type utility to nuke
> >> buggy programs, or how would resource constraints be enforced?
> >
> > That is possible without 'bpfkill'.
> > bpftool can delete map element that contains bpf_timer and
> > that will cancel it. I'll add tests to make sure it's the case.
>
> Ah, right, of course! Thanks, LGTM then :)
>
> -Toke
>
