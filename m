Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9922A23C539
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 07:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgHEFrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 01:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEFrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 01:47:35 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ACAC06174A;
        Tue,  4 Aug 2020 22:47:35 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e187so10863082ybc.5;
        Tue, 04 Aug 2020 22:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N9PlJ3Rl6xanzUO3i8UD8cYfGevp2bF1yYiHqvkpnwo=;
        b=fz8E6U86ooXrxj2Ei7lJcJ5Tc9fG44PdK1gCsCSSs9fYrU3DYyLVNfAJzQHlDVH4DC
         2/QeePq0OcK8qBZLW1f3iKHZv3L85WfddK0oR9/JDhWeTuFSSXbapcFJDe3tOBuohEx0
         OB74LPC/wgewf5sgkrQlKf/Sq1zg18AhTHEsrD4KnoHo6BPbrjfgsn+IsDh4W866s6w6
         /N0Ir6GKxT59uFGBbFD3qt6OyAEwEtij1AWt8UqwITAxC2fpRX6X1xrNgZppS3pR3NIC
         0oOn6vUcvbNSesgeGfyTdEkYjPthQJ7fTsoPG7DqXB4hBV789zhNh7GTLkrqtCwd9SRH
         n+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N9PlJ3Rl6xanzUO3i8UD8cYfGevp2bF1yYiHqvkpnwo=;
        b=oOm79UeVzOTsFh77ab7dkOkBo1dNpoSjqtpPOiwx/d97HxuFeNVB6KfPhC0BSR3xfH
         UY961k3cO57ms/DfSfKFX7aRTh34YikmDQ5gulFAmdeclUoCW/t7tndGEkoYDV30DAAY
         omKCP2sfILR66NBY87KAMYBD2maD7jthJlalHqCGWh5zVwgrrrNa5Qwn6m3WGfJFUzPW
         RmN6NxYq3XyQ9R07GLb+zZiOOhmbBNnbVGIayhX2ypSw4R6ho6MGs/OIXZeMMa3vdiEk
         uOLrRMJjJsKEHuxDd6wqS5w2M0Ksxh4wg/2gwsSqzE6e/U6VrEOioUUIottHY8l/RPzu
         rrhA==
X-Gm-Message-State: AOAM530gpPBCJq0XdqEMi7rP7PCVM0WgPdfpxOsLipaYwZif5QGz9AYW
        V4U+c6i69YCWqqv7g0fpg36RNcDJUhXsq+eJ4sXh2g==
X-Google-Smtp-Source: ABdhPJzflcU6Nnw4Y4XcLzADkuammhaX8z0ZLxZzWyciHQRgJrZxebgcXc/M4LAG0o5jDjxM7uvRbw6KesBMm5B2p20=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr2330998ybm.425.1596606454446;
 Tue, 04 Aug 2020 22:47:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com> <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com> <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com> <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
In-Reply-To: <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 22:47:23 -0700
Message-ID: <CAEf4BzZ29G2KexhKY=CffOPK_DiqAXxRHWuVRREHv0dnXgobRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs. user_prog
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 4, 2020, at 6:52 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
> >
> > On Tue, Aug 4, 2020 at 2:01 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Aug 2, 2020, at 10:10 PM, Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
> >>>
> >>> On Sun, Aug 2, 2020 at 9:47 PM Song Liu <songliubraving@fb.com> wrote=
:
> >>>>
> >>>>
> >>>>> On Aug 2, 2020, at 6:51 PM, Andrii Nakryiko <andrii.nakryiko@gmail.=
com> wrote:
> >>>>>
> >>>>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wro=
te:
> >>>>>>
> >>>>>> Add a benchmark to compare performance of
> >>>>>> 1) uprobe;
> >>>>>> 2) user program w/o args;
> >>>>>> 3) user program w/ args;
> >>>>>> 4) user program w/ args on random cpu.
> >>>>>>
> >>>>>
> >>>>> Can you please add it to the existing benchmark runner instead, e.g=
.,
> >>>>> along the other bench_trigger benchmarks? No need to re-implement
> >>>>> benchmark setup. And also that would also allow to compare existing
> >>>>> ways of cheaply triggering a program vs this new _USER program?
> >>>>
> >>>> Will try.
> >>>>
> >>>>>
> >>>>> If the performance is not significantly better than other ways, do =
you
> >>>>> think it still makes sense to add a new BPF program type? I think
> >>>>> triggering KPROBE/TRACEPOINT from bpf_prog_test_run() would be very
> >>>>> nice, maybe it's possible to add that instead of a new program type=
?
> >>>>> Either way, let's see comparison with other program triggering
> >>>>> mechanisms first.
> >>>>
> >>>> Triggering KPROBE and TRACEPOINT from bpf_prog_test_run() will be us=
eful.
> >>>> But I don't think they can be used instead of user program, for a co=
uple
> >>>> reasons. First, KPROBE/TRACEPOINT may be triggered by other programs
> >>>> running in the system, so user will have to filter those noise out i=
n
> >>>> each program. Second, it is not easy to specify CPU for KPROBE/TRACE=
POINT,
> >>>> while this feature could be useful in many cases, e.g. get stack tra=
ce
> >>>> on a given CPU.
> >>>>
> >>>
> >>> Right, it's not as convenient with KPROBE/TRACEPOINT as with the USER
> >>> program you've added specifically with that feature in mind. But if
> >>> you pin user-space thread on the needed CPU and trigger kprobe/tp,
> >>> then you'll get what you want. As for the "noise", see how
> >>> bench_trigger() deals with that: it records thread ID and filters
> >>> everything not matching. You can do the same with CPU ID. It's not as
> >>> automatic as with a special BPF program type, but still pretty simple=
,
> >>> which is why I'm still deciding (for myself) whether USER program typ=
e
> >>> is necessary :)
> >>
> >> Here are some bench_trigger numbers:
> >>
> >> base      :    1.698 =C2=B1 0.001M/s
> >> tp        :    1.477 =C2=B1 0.001M/s
> >> rawtp     :    1.567 =C2=B1 0.001M/s
> >> kprobe    :    1.431 =C2=B1 0.000M/s
> >> fentry    :    1.691 =C2=B1 0.000M/s
> >> fmodret   :    1.654 =C2=B1 0.000M/s
> >> user      :    1.253 =C2=B1 0.000M/s
> >> fentry-on-cpu:    0.022 =C2=B1 0.011M/s
> >> user-on-cpu:    0.315 =C2=B1 0.001M/s
> >>
> >
> > Ok, so basically all of raw_tp,tp,kprobe,fentry/fexit are
> > significantly faster than USER programs. Sure, when compared to
> > uprobe, they are faster, but not when doing on-specific-CPU run, it
> > seems (judging from this patch's description, if I'm reading it
> > right). Anyways, speed argument shouldn't be a reason for doing this,
> > IMO.
> >
> >> The two "on-cpu" tests run the program on a different CPU (see the pat=
ch
> >> at the end).
> >>
> >> "user" is about 25% slower than "fentry". I think this is mostly becau=
se
> >> getpgid() is a faster syscall than bpf(BPF_TEST_RUN).
> >
> > Yes, probably.
> >
> >>
> >> "user-on-cpu" is more than 10x faster than "fentry-on-cpu", because IP=
I
> >> is way faster than moving the process (via sched_setaffinity).
> >
> > I don't think that's a good comparison, because you are actually
> > testing sched_setaffinity performance on each iteration vs IPI in the
> > kernel, not a BPF overhead.
> >
> > I think the fair comparison for this would be to create a thread and
> > pin it on necessary CPU, and only then BPF program calls in a loop.
> > But I bet any of existing program types would beat USER program.
> >
> >>
> >> For use cases that we would like to call BPF program on specific CPU,
> >> triggering it via IPI is a lot faster.
> >
> > So these use cases would be nice to expand on in the motivational part
> > of the patch set. It's not really emphasized and it's not at all clear
> > what you are trying to achieve. It also seems, depending on latency
> > requirements, it's totally possible to achieve comparable results by
> > pre-creating a thread for each CPU, pinning each one to its designated
> > CPU and then using any suitable user-space signaling mechanism (a
> > queue, condvar, etc) to ask a thread to trigger BPF program (fentry on
> > getpgid(), for instance).
>
> I don't see why user space signal plus fentry would be faster than IPI.
> If the target cpu is running something, this gonna add two context
> switches.
>

I didn't say faster, did I? I said it would be comparable and wouldn't
require a new program type. But then again, without knowing all the
details, it's a bit hard to discuss this. E.g., if you need to trigger
that BPF program periodically, you can sleep in those per-CPU threads,
or epoll, or whatever. Or maybe you can set up a per-CPU perf event
that would trigger your program on the desired CPU, etc. My point is
that I and others shouldn't be guessing this, I'd expect someone who's
proposing an entire new BPF program type to motivate why this new
program type is necessary and what problem it's solving that can't be
solved with existing means.

BTW, how frequently do you need to trigger the BPF program? Seems very
frequently, if 2 vs 1 context switches might be a problem?

> > I bet in this case the  performance would be
> > really nice for a lot of practical use cases. But then again, I don't
> > know details of the intended use case, so please provide some more
> > details.
>
> Being able to trigger BPF program on a different CPU could enable many
> use cases and optimizations. The use case I am looking at is to access
> perf_event and percpu maps on the target CPU. For example:
>         0. trigger the program
>         1. read perf_event on cpu x;
>         2. (optional) check which process is running on cpu x;
>         3. add perf_event value to percpu map(s) on cpu x.
>
> If we do these steps in a BPF program on cpu x, the cost is:
>         A.0) trigger BPF via IPI;
>         A.1) read perf_event locally;
>         A.2) local access current;
>         A.3) local access of percpu map(s).
>
> If we can only do these on a different CPU, the cost will be:
>         B.0) trigger BPF locally;
>         B.1) read perf_event via IPI;
>         B.2) remote access current on cpu x;
>         B.3) remote access percpu map(s), or use non-percpu map(2).
>
> Cost of (A.0 + A.1) is about same as (B.0 + B.1), maybe a little higher
> (sys_bpf(), vs. sys_getpgid()). But A.2 and A.3 will be significantly
> cheaper than B.2 and B.3.
>
> Does this make sense?

It does, thanks. But what I was describing is still A, no? BPF program
will be triggered on your desired cpu X, wouldn't it?

>
>
> OTOH, I do agree we can trigger bpftrace BEGIN/END with sys_getpgid()
> or something similar.

Right.

>
> Thanks,
> Song
