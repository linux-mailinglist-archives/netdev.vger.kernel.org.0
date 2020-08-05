Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1395A23C32A
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 03:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHEBwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 21:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEBwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 21:52:45 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6616FC06174A;
        Tue,  4 Aug 2020 18:52:45 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 2so22955570ybr.13;
        Tue, 04 Aug 2020 18:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f5vWovwwL6FVRfpowsNb43860ihjb6YS2LAtVZgCvT8=;
        b=n3dyElIxcSrBm7/2UaBZBRAMktVFD7ZjGdTKk8r8b4jx6UIZCDZfNDX+9Sr5kyp93H
         ADb+qKMJkRwrWPFTqx+6iKg4HR/AxmWgWiLY1+ryKLNSDHiXBigsCwMED/X+KbDWbpS8
         4l95ZaTkxuA1cy3cF4L7DbbX/1k8p2OUtZJYtCcLdl8mJMfPLyV1sVOuSFCZ9a+Dfy+T
         6riLnu3W0Ou+pCAIDXJkXjBNb9V9eqA94lGGeyMXFftxnvq10HA38EPk3kTgMOumEyel
         FiQrb8RR9aRM+jP92uIJvye4aDvJbCmLaT+IglMzXjYV1Bs7scgv7qZcHfq9iSXcLOLm
         xiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f5vWovwwL6FVRfpowsNb43860ihjb6YS2LAtVZgCvT8=;
        b=INiaf+Xi3Vh8BEpqm22XrsXUeuTRNfe8IPOTxvyv6FyoX57ZMPWvQbyCxqb9+7zSnd
         jPaJhaLvHxix3P4oqnNOP3svoLIF+siKBYGX5pYHvuxNrwnm4PAjpN7XMfq6b6zckz59
         nTrPPft/HOy09pG7C9TFevJZ2kyMDJwaa4N+a2QjFHmt38H4TMtgCcvmKURQxE2or2/t
         wt+9ixxL4F/507yJe0C1Z41IT/3kg0WX41Jn2ydsMCjXG3acUMn32FLyiul3+1qcib0t
         6nSTRZozIEqO+PLFuxdK/7QtxkYEHF5IfZM+9VBLjdHM0fhxeifU1CED9KFDUHDr9aZ3
         cbSw==
X-Gm-Message-State: AOAM531ODvQH2q/uTiwNSeQVjDjw1ccPMLwTmGxK3rbPJB8h7XQskvVj
        T/r19I+EeDQs/p1rDgnCU+C4sazSWFdfO4Fc75o=
X-Google-Smtp-Source: ABdhPJxKVJJYL0V0ORifsBd/k8iQrFdHSIT/Fp3Dn1ywH2UIvtoqoSECcmEo4+HRovneUPeo0y9mtVcN41LH91lLQ2A=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr1363384ybg.459.1596592364540;
 Tue, 04 Aug 2020 18:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com> <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com> <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
In-Reply-To: <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 18:52:32 -0700
Message-ID: <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
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

On Tue, Aug 4, 2020 at 2:01 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 2, 2020, at 10:10 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
> >
> > On Sun, Aug 2, 2020 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>> On Aug 2, 2020, at 6:51 PM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
> >>>
> >>> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote=
:
> >>>>
> >>>> Add a benchmark to compare performance of
> >>>> 1) uprobe;
> >>>> 2) user program w/o args;
> >>>> 3) user program w/ args;
> >>>> 4) user program w/ args on random cpu.
> >>>>
> >>>
> >>> Can you please add it to the existing benchmark runner instead, e.g.,
> >>> along the other bench_trigger benchmarks? No need to re-implement
> >>> benchmark setup. And also that would also allow to compare existing
> >>> ways of cheaply triggering a program vs this new _USER program?
> >>
> >> Will try.
> >>
> >>>
> >>> If the performance is not significantly better than other ways, do yo=
u
> >>> think it still makes sense to add a new BPF program type? I think
> >>> triggering KPROBE/TRACEPOINT from bpf_prog_test_run() would be very
> >>> nice, maybe it's possible to add that instead of a new program type?
> >>> Either way, let's see comparison with other program triggering
> >>> mechanisms first.
> >>
> >> Triggering KPROBE and TRACEPOINT from bpf_prog_test_run() will be usef=
ul.
> >> But I don't think they can be used instead of user program, for a coup=
le
> >> reasons. First, KPROBE/TRACEPOINT may be triggered by other programs
> >> running in the system, so user will have to filter those noise out in
> >> each program. Second, it is not easy to specify CPU for KPROBE/TRACEPO=
INT,
> >> while this feature could be useful in many cases, e.g. get stack trace
> >> on a given CPU.
> >>
> >
> > Right, it's not as convenient with KPROBE/TRACEPOINT as with the USER
> > program you've added specifically with that feature in mind. But if
> > you pin user-space thread on the needed CPU and trigger kprobe/tp,
> > then you'll get what you want. As for the "noise", see how
> > bench_trigger() deals with that: it records thread ID and filters
> > everything not matching. You can do the same with CPU ID. It's not as
> > automatic as with a special BPF program type, but still pretty simple,
> > which is why I'm still deciding (for myself) whether USER program type
> > is necessary :)
>
> Here are some bench_trigger numbers:
>
> base      :    1.698 =C2=B1 0.001M/s
> tp        :    1.477 =C2=B1 0.001M/s
> rawtp     :    1.567 =C2=B1 0.001M/s
> kprobe    :    1.431 =C2=B1 0.000M/s
> fentry    :    1.691 =C2=B1 0.000M/s
> fmodret   :    1.654 =C2=B1 0.000M/s
> user      :    1.253 =C2=B1 0.000M/s
> fentry-on-cpu:    0.022 =C2=B1 0.011M/s
> user-on-cpu:    0.315 =C2=B1 0.001M/s
>

Ok, so basically all of raw_tp,tp,kprobe,fentry/fexit are
significantly faster than USER programs. Sure, when compared to
uprobe, they are faster, but not when doing on-specific-CPU run, it
seems (judging from this patch's description, if I'm reading it
right). Anyways, speed argument shouldn't be a reason for doing this,
IMO.

> The two "on-cpu" tests run the program on a different CPU (see the patch
> at the end).
>
> "user" is about 25% slower than "fentry". I think this is mostly because
> getpgid() is a faster syscall than bpf(BPF_TEST_RUN).

Yes, probably.

>
> "user-on-cpu" is more than 10x faster than "fentry-on-cpu", because IPI
> is way faster than moving the process (via sched_setaffinity).

I don't think that's a good comparison, because you are actually
testing sched_setaffinity performance on each iteration vs IPI in the
kernel, not a BPF overhead.

I think the fair comparison for this would be to create a thread and
pin it on necessary CPU, and only then BPF program calls in a loop.
But I bet any of existing program types would beat USER program.

>
> For use cases that we would like to call BPF program on specific CPU,
> triggering it via IPI is a lot faster.

So these use cases would be nice to expand on in the motivational part
of the patch set. It's not really emphasized and it's not at all clear
what you are trying to achieve. It also seems, depending on latency
requirements, it's totally possible to achieve comparable results by
pre-creating a thread for each CPU, pinning each one to its designated
CPU and then using any suitable user-space signaling mechanism (a
queue, condvar, etc) to ask a thread to trigger BPF program (fentry on
getpgid(), for instance). I bet in this case the  performance would be
really nice for a lot of practical use cases. But then again, I don't
know details of the intended use case, so please provide some more
details.

>
> Thanks,
> Song
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D 8< =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
> diff --git c/tools/testing/selftests/bpf/bench.c w/tools/testing/selftest=
s/bpf/bench.c
> index 944ad4721c83c..5394a1d2dfd21 100644
> --- c/tools/testing/selftests/bpf/bench.c
> +++ w/tools/testing/selftests/bpf/bench.c
> @@ -317,7 +317,10 @@ extern const struct bench bench_trig_tp;
>  extern const struct bench bench_trig_rawtp;
>  extern const struct bench bench_trig_kprobe;
>  extern const struct bench bench_trig_fentry;
> +extern const struct bench bench_trig_fentry_on_cpu;
>  extern const struct bench bench_trig_fmodret;
> +extern const struct bench bench_trig_user;
> +extern const struct bench bench_trig_user_on_cpu;
>  extern const struct bench bench_rb_libbpf;
>  extern const struct bench bench_rb_custom;
>  extern const struct bench bench_pb_libbpf;
> @@ -338,7 +341,10 @@ static const struct bench *benchs[] =3D {
>         &bench_trig_rawtp,
>         &bench_trig_kprobe,
>         &bench_trig_fentry,
> +       &bench_trig_fentry_on_cpu,
>         &bench_trig_fmodret,
> +       &bench_trig_user,
> +       &bench_trig_user_on_cpu,
>         &bench_rb_libbpf,
>         &bench_rb_custom,
>         &bench_pb_libbpf,
> @@ -462,4 +468,3 @@ int main(int argc, char **argv)
>
>         return 0;
>  }
> -
> diff --git c/tools/testing/selftests/bpf/benchs/bench_trigger.c w/tools/t=
esting/selftests/bpf/benchs/bench_trigger.c
> index 49c22832f2169..a1ebaebf6070c 100644
> --- c/tools/testing/selftests/bpf/benchs/bench_trigger.c
> +++ w/tools/testing/selftests/bpf/benchs/bench_trigger.c
> @@ -1,5 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2020 Facebook */
> +#define _GNU_SOURCE
> +#include <sched.h>
>  #include "bench.h"
>  #include "trigger_bench.skel.h"
>
> @@ -39,6 +41,22 @@ static void *trigger_producer(void *input)
>         return NULL;
>  }
>
> +static void *trigger_on_cpu_producer(void *input)
> +{
> +       cpu_set_t set;
> +       int i =3D 0, nr_cpu;
> +
> +       nr_cpu =3D libbpf_num_possible_cpus();
> +       while (true) {
> +               CPU_ZERO(&set);
> +               CPU_SET(i, &set);
> +               sched_setaffinity(0, sizeof(set), &set);
> +               (void)syscall(__NR_getpgid);
> +               i =3D (i + 1) % nr_cpu;
> +       }
> +       return NULL;
> +}
> +
>  static void trigger_measure(struct bench_res *res)
>  {
>         res->hits =3D atomic_swap(&ctx.skel->bss->hits, 0);
> @@ -96,6 +114,39 @@ static void trigger_fmodret_setup()
>         attach_bpf(ctx.skel->progs.bench_trigger_fmodret);
>  }
>
> +static void trigger_user_setup()
> +{
> +       setup_ctx();
> +}
> +
> +static void *trigger_producer_user(void *input)
> +{
> +       struct bpf_prog_test_run_attr attr =3D {};
> +
> +       attr.prog_fd =3D bpf_program__fd(ctx.skel->progs.bench_trigger_us=
er);
> +
> +       while (true)
> +               (void)bpf_prog_test_run_xattr(&attr);
> +       return NULL;
> +}
> +
> +static void *trigger_producer_user_on_cpu(void *input)
> +{
> +       struct bpf_prog_test_run_attr attr =3D {};
> +       int i =3D 0, nr_cpu;
> +
> +       nr_cpu =3D libbpf_num_possible_cpus();
> +
> +       attr.prog_fd =3D bpf_program__fd(ctx.skel->progs.bench_trigger_us=
er);
> +
> +       while (true) {
> +               attr.cpu_plus =3D i + 1;
> +               (void)bpf_prog_test_run_xattr(&attr);
> +               i =3D (i + 1) % nr_cpu;
> +       }
> +       return NULL;
> +}
> +
>  static void *trigger_consumer(void *input)
>  {
>         return NULL;
> @@ -155,6 +206,17 @@ const struct bench bench_trig_fentry =3D {
>         .report_final =3D hits_drops_report_final,
>  };
>
> +const struct bench bench_trig_fentry_on_cpu =3D {
> +       .name =3D "trig-fentry-on-cpu",
> +       .validate =3D trigger_validate,
> +       .setup =3D trigger_fentry_setup,
> +       .producer_thread =3D trigger_on_cpu_producer,
> +       .consumer_thread =3D trigger_consumer,
> +       .measure =3D trigger_measure,
> +       .report_progress =3D hits_drops_report_progress,
> +       .report_final =3D hits_drops_report_final,
> +};
> +
>  const struct bench bench_trig_fmodret =3D {
>         .name =3D "trig-fmodret",
>         .validate =3D trigger_validate,
> @@ -165,3 +227,25 @@ const struct bench bench_trig_fmodret =3D {
>         .report_progress =3D hits_drops_report_progress,
>         .report_final =3D hits_drops_report_final,
>  };
> +
> +const struct bench bench_trig_user =3D {
> +       .name =3D "trig-user",
> +       .validate =3D trigger_validate,
> +       .setup =3D trigger_user_setup,
> +       .producer_thread =3D trigger_producer_user,
> +       .consumer_thread =3D trigger_consumer,
> +       .measure =3D trigger_measure,
> +       .report_progress =3D hits_drops_report_progress,
> +       .report_final =3D hits_drops_report_final,
> +};
> +
> +const struct bench bench_trig_user_on_cpu =3D {
> +       .name =3D "trig-user-on-cpu",
> +       .validate =3D trigger_validate,
> +       .setup =3D trigger_user_setup,
> +       .producer_thread =3D trigger_producer_user_on_cpu,
> +       .consumer_thread =3D trigger_consumer,
> +       .measure =3D trigger_measure,
> +       .report_progress =3D hits_drops_report_progress,
> +       .report_final =3D hits_drops_report_final,
> +};
> diff --git c/tools/testing/selftests/bpf/benchs/run_bench_trigger.sh w/to=
ols/testing/selftests/bpf/benchs/run_bench_trigger.sh
> index 78e83f2432946..f10b7aea76aa3 100755
> --- c/tools/testing/selftests/bpf/benchs/run_bench_trigger.sh
> +++ w/tools/testing/selftests/bpf/benchs/run_bench_trigger.sh
> @@ -2,7 +2,7 @@
>
>  set -eufo pipefail
>
> -for i in base tp rawtp kprobe fentry fmodret
> +for i in base tp rawtp kprobe fentry fmodret user fentry-on-cpu user-on-=
cpu
>  do
>         summary=3D$(sudo ./bench -w2 -d5 -a trig-$i | tail -n1 | cut -d'(=
' -f1 | cut -d' ' -f3-)
>         printf "%-10s: %s\n" $i "$summary"
> diff --git c/tools/testing/selftests/bpf/progs/trigger_bench.c w/tools/te=
sting/selftests/bpf/progs/trigger_bench.c
> index 8b36b6640e7e9..a6ac11e68d287 100644
> --- c/tools/testing/selftests/bpf/progs/trigger_bench.c
> +++ w/tools/testing/selftests/bpf/progs/trigger_bench.c
> @@ -45,3 +45,10 @@ int bench_trigger_fmodret(void *ctx)
>         __sync_add_and_fetch(&hits, 1);
>         return -22;
>  }
> +
> +SEC("user")
> +int BPF_PROG(bench_trigger_user)
> +{
> +       __sync_add_and_fetch(&hits, 1);
> +       return 0;
> +}
> ~
>
>
>
>
