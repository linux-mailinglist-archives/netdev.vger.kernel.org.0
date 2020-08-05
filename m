Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C794123CDAA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgHERjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbgHERjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:39:32 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99978C061575;
        Wed,  5 Aug 2020 10:39:25 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id c18so16804395ybr.1;
        Wed, 05 Aug 2020 10:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6bCWT90m+exQNL7T3YkjqTWHZL3/pjla0SdPnQEcSjE=;
        b=h6d9ayU8rD7uRA7O7Asg5SlRILgwRCihDPAyG0mmvRm3cYQiDc2KYz8OxWUGkB29kc
         ngD4QUzYihunW8SFC1H4geK8flbV492NRZD9Iv30hNQSLu8besFJ8Ja6ukFFrQ3QITl5
         nMkqVepugob5HO4/s2W05rBC0j/MJguMshXc9QKNHGVZsQrWzh7eI+dz5nZeE0Zhgrtz
         T//Mrcd5z8bI3sOxrz03QZ+uALXiBhIMLI7Wjamtnnn4SRUQYHL2pnTEi3nc/d1a8x2A
         S/i5P0gOPMSucyjcVE0d9HprXKBgBwwfY2dVfsKBy8ec+DGjOcLKyr2SQycq5jkxTOdq
         q/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6bCWT90m+exQNL7T3YkjqTWHZL3/pjla0SdPnQEcSjE=;
        b=Jhu3pWzFPyT7KrOfwiMGSuCuylXW7YmsOF8O97sVzxUlk3g8oU+uFI5zIlYKZ+XAp4
         Z0cB0evrs5ID+0hmLUqXm3kHodHCVErIFxQiScva/Z5RV33lhlxTYrZsc7nIEdkkHaJ/
         4UHdfCbTe29fEUjY8x7yZPBa4zmzk6gcjUy6grGzxajlDItt2MrqoJopS7F9jnow8Um3
         EcHsKEtHC9PAwh3eFOjUQbUszZrlbSxjcG07SxndLghfSE4KwAxwlOiQT7L3EIMVTOo3
         rMSeeNPGWhV+S8z1Th5w23KnFi+iByAL5ipluZRh0Qcv0cXDQgpxo55M+cCdjPFW6x3J
         zBfg==
X-Gm-Message-State: AOAM532KwgnMpJSlCr9ZSekSXnMPxMY22+Q9rjRxEcGlYp7OrwoDZJhP
        qHxzD78rLPdpvDw1+O7Vzs5Gkjy/FSN+mxXTjKKXjw==
X-Google-Smtp-Source: ABdhPJxEiAKm6++XAj2hiUGpV4D578WKfSqcDGi9gLHZTanMHFDVL+qsmbNeKqvBcGqQXt7T7t5kBmsLEMaAsrhXQa4=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr6853153ybg.347.1596649164750;
 Wed, 05 Aug 2020 10:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com> <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com> <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com> <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com> <CAEf4BzZ29G2KexhKY=CffOPK_DiqAXxRHWuVRREHv0dnXgobRQ@mail.gmail.com>
 <BA750BC0-0A3B-488B-806C-90C1B6CDF586@fb.com>
In-Reply-To: <BA750BC0-0A3B-488B-806C-90C1B6CDF586@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Aug 2020 10:39:13 -0700
Message-ID: <CAEf4Bza_P-b2-OXer8NjxQ3vHcY-=jbNaUBPMFUezy=LVOO16A@mail.gmail.com>
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

On Wed, Aug 5, 2020 at 12:01 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 4, 2020, at 10:47 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
> >
> > On Tue, Aug 4, 2020 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Aug 4, 2020, at 6:52 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
> >>>
> >>> On Tue, Aug 4, 2020 at 2:01 PM Song Liu <songliubraving@fb.com> wrote=
:
> >>>>
> >>>>
> >>>>
> >>>>> On Aug 2, 2020, at 10:10 PM, Andrii Nakryiko <andrii.nakryiko@gmail=
.com> wrote:
> >>>>>
> >>>>> On Sun, Aug 2, 2020 at 9:47 PM Song Liu <songliubraving@fb.com> wro=
te:
> >>>>>>
> >>>>>>
> >>>>>>> On Aug 2, 2020, at 6:51 PM, Andrii Nakryiko <andrii.nakryiko@gmai=
l.com> wrote:
> >>>>>>>
> >>>>>>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> w=
rote:
> >>>>>>>>
> >>>>>>>> Add a benchmark to compare performance of
> >>>>>>>> 1) uprobe;
> >>>>>>>> 2) user program w/o args;
> >>>>>>>> 3) user program w/ args;
> >>>>>>>> 4) user program w/ args on random cpu.
> >>>>>>>>
> >>>>>>>
> >>>>>>> Can you please add it to the existing benchmark runner instead, e=
.g.,
> >>>>>>> along the other bench_trigger benchmarks? No need to re-implement
> >>>>>>> benchmark setup. And also that would also allow to compare existi=
ng
> >>>>>>> ways of cheaply triggering a program vs this new _USER program?
> >>>>>>
> >>>>>> Will try.
> >>>>>>
> >>>>>>>
> >>>>>>> If the performance is not significantly better than other ways, d=
o you
> >>>>>>> think it still makes sense to add a new BPF program type? I think
> >>>>>>> triggering KPROBE/TRACEPOINT from bpf_prog_test_run() would be ve=
ry
> >>>>>>> nice, maybe it's possible to add that instead of a new program ty=
pe?
> >>>>>>> Either way, let's see comparison with other program triggering
> >>>>>>> mechanisms first.
> >>>>>>
> >>>>>> Triggering KPROBE and TRACEPOINT from bpf_prog_test_run() will be =
useful.
> >>>>>> But I don't think they can be used instead of user program, for a =
couple
> >>>>>> reasons. First, KPROBE/TRACEPOINT may be triggered by other progra=
ms
> >>>>>> running in the system, so user will have to filter those noise out=
 in
> >>>>>> each program. Second, it is not easy to specify CPU for KPROBE/TRA=
CEPOINT,
> >>>>>> while this feature could be useful in many cases, e.g. get stack t=
race
> >>>>>> on a given CPU.
> >>>>>>
> >>>>>
> >>>>> Right, it's not as convenient with KPROBE/TRACEPOINT as with the US=
ER
> >>>>> program you've added specifically with that feature in mind. But if
> >>>>> you pin user-space thread on the needed CPU and trigger kprobe/tp,
> >>>>> then you'll get what you want. As for the "noise", see how
> >>>>> bench_trigger() deals with that: it records thread ID and filters
> >>>>> everything not matching. You can do the same with CPU ID. It's not =
as
> >>>>> automatic as with a special BPF program type, but still pretty simp=
le,
> >>>>> which is why I'm still deciding (for myself) whether USER program t=
ype
> >>>>> is necessary :)
> >>>>
> >>>> Here are some bench_trigger numbers:
> >>>>
> >>>> base      :    1.698 =C2=B1 0.001M/s
> >>>> tp        :    1.477 =C2=B1 0.001M/s
> >>>> rawtp     :    1.567 =C2=B1 0.001M/s
> >>>> kprobe    :    1.431 =C2=B1 0.000M/s
> >>>> fentry    :    1.691 =C2=B1 0.000M/s
> >>>> fmodret   :    1.654 =C2=B1 0.000M/s
> >>>> user      :    1.253 =C2=B1 0.000M/s
> >>>> fentry-on-cpu:    0.022 =C2=B1 0.011M/s
> >>>> user-on-cpu:    0.315 =C2=B1 0.001M/s
> >>>>
> >>>
> >>> Ok, so basically all of raw_tp,tp,kprobe,fentry/fexit are
> >>> significantly faster than USER programs. Sure, when compared to
> >>> uprobe, they are faster, but not when doing on-specific-CPU run, it
> >>> seems (judging from this patch's description, if I'm reading it
> >>> right). Anyways, speed argument shouldn't be a reason for doing this,
> >>> IMO.
> >>>
> >>>> The two "on-cpu" tests run the program on a different CPU (see the p=
atch
> >>>> at the end).
> >>>>
> >>>> "user" is about 25% slower than "fentry". I think this is mostly bec=
ause
> >>>> getpgid() is a faster syscall than bpf(BPF_TEST_RUN).
> >>>
> >>> Yes, probably.
> >>>
> >>>>
> >>>> "user-on-cpu" is more than 10x faster than "fentry-on-cpu", because =
IPI
> >>>> is way faster than moving the process (via sched_setaffinity).
> >>>
> >>> I don't think that's a good comparison, because you are actually
> >>> testing sched_setaffinity performance on each iteration vs IPI in the
> >>> kernel, not a BPF overhead.
> >>>
> >>> I think the fair comparison for this would be to create a thread and
> >>> pin it on necessary CPU, and only then BPF program calls in a loop.
> >>> But I bet any of existing program types would beat USER program.
> >>>
> >>>>
> >>>> For use cases that we would like to call BPF program on specific CPU=
,
> >>>> triggering it via IPI is a lot faster.
> >>>
> >>> So these use cases would be nice to expand on in the motivational par=
t
> >>> of the patch set. It's not really emphasized and it's not at all clea=
r
> >>> what you are trying to achieve. It also seems, depending on latency
> >>> requirements, it's totally possible to achieve comparable results by
> >>> pre-creating a thread for each CPU, pinning each one to its designate=
d
> >>> CPU and then using any suitable user-space signaling mechanism (a
> >>> queue, condvar, etc) to ask a thread to trigger BPF program (fentry o=
n
> >>> getpgid(), for instance).
> >>
> >> I don't see why user space signal plus fentry would be faster than IPI=
.
> >> If the target cpu is running something, this gonna add two context
> >> switches.
> >>
> >
> > I didn't say faster, did I? I said it would be comparable and wouldn't
> > require a new program type.
>
> Well, I don't think adding program type is that big a deal. If that is
> really a problem, we can use a new attach type instead. The goal is to
> trigger it with sys_bpf() on a different cpu. So we can call it kprobe
> attach to nothing and hack that way. I add the new type because it makes
> sense. The user just want to trigger a BPF program from user space.

I thought we already concluded that it's not really "trigger a BPF
program from user space", because for that you have many existing and
even faster options. After a few rounds of emails, it seems it's more
about triggering the BPF program on another CPU without preempting
whatever is running on that CPU. It would be helpful to be clear and
upfront about the requirements.

>
> > But then again, without knowing all the
> > details, it's a bit hard to discuss this. E.g., if you need to trigger
> > that BPF program periodically, you can sleep in those per-CPU threads,
> > or epoll, or whatever. Or maybe you can set up a per-CPU perf event
> > that would trigger your program on the desired CPU, etc.My point is
> > that I and others shouldn't be guessing this, I'd expect someone who's
> > proposing an entire new BPF program type to motivate why this new
> > program type is necessary and what problem it's solving that can't be
> > solved with existing means.
>
> Yes, there are other options. But they all come with non-trivial cost.
> Per-CPU-per-process threads and/or per-CPU perf event are cost we have
> to pay in production. IMO, these cost are much higher than a new program
> type (or attach type).
>

So for threads I know the costs (a bit of memory for thread stack,
plus some internal book keeping stuff in kernel), which is arguable
how big of a deal is that if those threads do pretty much nothing most
of the time. But what's the exact cost of perf events and why it's
unacceptably high?

The reason I'm asking is that it seems to me that one alternative,
which is more generic (and thus potentially more useful) would be to
have a manually-triggerable perf event. Some sort of software event,
that's triggered from ioctl or some other syscall, that's appropriate
for perf subsystem. You'd pre-create a perf_event for each CPU,
remember their FDs, then would trigger the one you need (corresponding
to desired CPU). From the BPF side, you'd just use a normal perf_event
program to handle perf_event activation. But it could be used even
outside of the BPF ecosystem, which is a good sign for me, because it
allows more flexible composition of building blocks.

> >
> > BTW, how frequently do you need to trigger the BPF program? Seems very
> > frequently, if 2 vs 1 context switches might be a problem?
>
> The whole solution requires two BPF programs. One on each context switch,
> the other is the user program. The user program will not trigger very
> often.

Ok, so performance was never an objective, I wonder why it is put as
the main reason for this new type of BPF program?

>
> >
> >>> I bet in this case the  performance would be
> >>> really nice for a lot of practical use cases. But then again, I don't
> >>> know details of the intended use case, so please provide some more
> >>> details.
> >>
> >> Being able to trigger BPF program on a different CPU could enable many
> >> use cases and optimizations. The use case I am looking at is to access
> >> perf_event and percpu maps on the target CPU. For example:
> >>        0. trigger the program
> >>        1. read perf_event on cpu x;
> >>        2. (optional) check which process is running on cpu x;
> >>        3. add perf_event value to percpu map(s) on cpu x.
> >>
> >> If we do these steps in a BPF program on cpu x, the cost is:
> >>        A.0) trigger BPF via IPI;
> >>        A.1) read perf_event locally;
> >>        A.2) local access current;
> >>        A.3) local access of percpu map(s).
> >>
> >> If we can only do these on a different CPU, the cost will be:
> >>        B.0) trigger BPF locally;
> >>        B.1) read perf_event via IPI;
> >>        B.2) remote access current on cpu x;
> >>        B.3) remote access percpu map(s), or use non-percpu map(2).
> >>
> >> Cost of (A.0 + A.1) is about same as (B.0 + B.1), maybe a little highe=
r
> >> (sys_bpf(), vs. sys_getpgid()). But A.2 and A.3 will be significantly
> >> cheaper than B.2 and B.3.
> >>
> >> Does this make sense?
> >
> > It does, thanks. But what I was describing is still A, no? BPF program
> > will be triggered on your desired cpu X, wouldn't it?
>
> Well, that would be option C, but C could not do step 2, because we conte=
xt
> switch to the dedicated thread.
>

So I think *this* is a real requirement. No preemption of the running
process on a different CPU. That does sound like what perf event does,
doesn't it? See above.
