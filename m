Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66B1CB66D
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgEHR73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHR73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:59:29 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC89C061A0C;
        Fri,  8 May 2020 10:59:29 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j8so2629898iog.13;
        Fri, 08 May 2020 10:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EcE2oeBkibGlIx9hADTVQgESeokhZ/FSwJo+VX1nG8Q=;
        b=AaYZ69azQLuS8C4Nqd6DNnJXADg97oV0H5G+RCICxTTLeUHKG5l+XnmGhRlvTLJ8dn
         mMbAvJzj/qQEZVfEWO6VJoZY52yzvTA7pRMw22iyUVgI91KWASw0ltAGstId3yU+1iiw
         Wq895EL6uABMWm3q/BCbnK/fvTMxN7GWj/fJISlhX50/qgEH/Va76qM41B0lHyUw1xOD
         D6sDi5TWstI56Ut5eIEuqMooWgFXpKCGC3k3iXkcy7ozfLB0LgqB158+rdh9B6Fn3Obx
         TlHavktDdTK6scLfTTRQJxk5JVfNAzKVTXkG40Nc34lv5cD79dVTgKwM+iSNyd3AI24V
         7nbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EcE2oeBkibGlIx9hADTVQgESeokhZ/FSwJo+VX1nG8Q=;
        b=UpCuHjuwxa1yPwjFowxxZzbfTEhdehkXhdP485Uu9VgLlNBz+G608SEU1TuqBmFlhf
         AaZZOZQmmBsElL9vfd9FrUFVScJrC3619kxMF1MEk80TP7MWfmT02+GoxGt948wAEgJv
         qD58RfQrdnxy4oZ4NloWTIgZUpKH+3mVFPOreMHZbDZvzgMseVR359FfMyj7VTRWvVOI
         NS+uG3Cof3gvCXUwHjaiK1COQzifPVB/iTHHPOh+MmMA0biGeRXm+LDECauWzNxvaFs5
         xncDfKWtwzLlAq8ovYyOuDGylcuybPjAFikOIsO1zg35TF1BPRIfnOsTVHlIAMfi5D1g
         hkKA==
X-Gm-Message-State: AGi0PuYv/hHvyPAndbsDlFAhaNPuN2sMpZQdyr9fitY1NPGLHnQjR/zd
        oid6OF4mW7J0r6iUMO2uqy5rIKnf6V8/asF3KXc=
X-Google-Smtp-Source: APiQypKLtlXKHj1wrndLi3bGB/8KbcVyKw3BVkJf074/6sih/uI3nmFAUUzeC1AqZdx74LOFHXo5Yit/sejFjOneSRc=
X-Received: by 2002:a05:6602:164c:: with SMTP id y12mr2946245iow.138.1588960768193;
 Fri, 08 May 2020 10:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200508070548.2358701-1-andriin@fb.com> <20200508070548.2358701-2-andriin@fb.com>
 <5eb57f9a5819c_2a992ad50b5cc5b41@john-XPS-13-9370.notmuch>
In-Reply-To: <5eb57f9a5819c_2a992ad50b5cc5b41@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 10:59:17 -0700
Message-ID: <CAEf4BzbO_Ya7uCcRdrOECnC4rV82OXqE97XoFVyumi8WNBNZMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: add benchmark runner infrastructure
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 8:49 AM John Fastabend <john.fastabend@gmail.com> wr=
ote:
>
> Andrii Nakryiko wrote:
> > While working on BPF ringbuf implementation, testing, and benchmarking,=
 I've
> > developed a pretty generic and modular benchmark runner, which seems to=
 be
> > generically useful, as I've already used it for one more purpose (testi=
ng
> > fastest way to trigger BPF program, to minimize overhead of in-kernel c=
ode).
> >
> > This patch adds generic part of benchmark runner and sets up Makefile f=
or
> > extending it with more sets of benchmarks.
>
> Seems useful.

thanks :)

>
> >
> > Benchmarker itself operates by spinning up specified number of producer=
 and
> > consumer threads, setting up interval timer sending SIGALARM signal to
> > application once a second. Every second, current snapshot with hits/dro=
ps
> > counters are collected and stored in an array. Drops are useful for
> > producer/consumer benchmarks in which producer might overwhelm consumer=
s.
> >
> > Once test finishes after given amount of warm-up and testing seconds, m=
ean and
> > stddev are calculated (ignoring warm-up results) and is printed out to =
stdout.
> > This setup seems to give consistent and accurate results.
> >
> > To validate behavior, I added two atomic counting tests: global and loc=
al.
> > For global one, all the producer threads are atomically incrementing sa=
me
> > counter as fast as possible. This, of course, leads to huge drop of
> > performance once there is more than one producer thread due to CPUs fig=
hting
> > for the same memory location.
> >
> > Local counting, on the other hand, maintains one counter per each produ=
cer
> > thread, incremented independently. Once per second, all counters are re=
ad and
> > added together to form final "counting throughput" measurement. As expe=
cted,
> > such setup demonstrates linear scalability with number of producers (as=
 long
> > as there are enough physical CPU cores, of course). See example output =
below.
> > Also, this setup can nicely demonstrate disastrous effects of false sha=
ring,
> > if care is not taken to take those per-producer counters apart into
> > independent cache lines.
> >
> > Demo output shows global counter first with 1 producer, then with 4. Bo=
th
> > total and per-producer performance significantly drop. The last run is =
local
> > counter with 4 producers, demonstrating near-perfect scalability.
> >
> > $ ./bench -a -w1 -d2 -p1 count-global
> > Setting up benchmark 'count-global'...
> > Benchmark 'count-global' started.
> > Iter   0 ( 24.822us): hits  148.179M/s (148.179M/prod), drops    0.000M=
/s
> > Iter   1 ( 37.939us): hits  149.308M/s (149.308M/prod), drops    0.000M=
/s
> > Iter   2 (-10.774us): hits  150.717M/s (150.717M/prod), drops    0.000M=
/s
> > Iter   3 (  3.807us): hits  151.435M/s (151.435M/prod), drops    0.000M=
/s
> > Summary: hits  150.488 =C2=B1 1.079M/s (150.488M/prod), drops    0.000 =
=C2=B1 0.000M/s
> >
> > $ ./bench -a -w1 -d2 -p4 count-global
> > Setting up benchmark 'count-global'...
> > Benchmark 'count-global' started.
> > Iter   0 ( 60.659us): hits   53.910M/s ( 13.477M/prod), drops    0.000M=
/s
> > Iter   1 (-17.658us): hits   53.722M/s ( 13.431M/prod), drops    0.000M=
/s
> > Iter   2 (  5.865us): hits   53.495M/s ( 13.374M/prod), drops    0.000M=
/s
> > Iter   3 (  0.104us): hits   53.606M/s ( 13.402M/prod), drops    0.000M=
/s
> > Summary: hits   53.608 =C2=B1 0.113M/s ( 13.402M/prod), drops    0.000 =
=C2=B1 0.000M/s
> >
> > $ ./bench -a -w1 -d2 -p4 count-local
> > Setting up benchmark 'count-local'...
> > Benchmark 'count-local' started.
> > Iter   0 ( 23.388us): hits  640.450M/s (160.113M/prod), drops    0.000M=
/s
> > Iter   1 (  2.291us): hits  605.661M/s (151.415M/prod), drops    0.000M=
/s
> > Iter   2 ( -6.415us): hits  607.092M/s (151.773M/prod), drops    0.000M=
/s
> > Iter   3 ( -1.361us): hits  601.796M/s (150.449M/prod), drops    0.000M=
/s
> > Summary: hits  604.849 =C2=B1 2.739M/s (151.212M/prod), drops    0.000 =
=C2=B1 0.000M/s
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> Couple nits but otherwise lgtm. I think it should probably be moved
> into its own directory though ./bpf/bench/

I assume you are talking about benchmark implementations themselve,
all those bench_xxx.c files, right? bench.c probably should stay in
selftests/bpf root.

>
> The other question would be how much stuff do we want to live in
> selftests vs outside selftests/bpf but I think its fine and makes
> it easy to build small benchmark programs in ./bpf/progs/

selftests/bpf Makefile is so convenient for BPF/skeleton/user-space
building, libbpf, vmlinux.h generation, etc, that moving this outside
would be a major pain and lots of extra work. Adding this benchmark
was trivial from Makefile modification point of view (and no debugging
of Makefile either, everything just worked).

>
> >  tools/testing/selftests/bpf/.gitignore    |   1 +
> >  tools/testing/selftests/bpf/Makefile      |  11 +-
> >  tools/testing/selftests/bpf/bench.c       | 364 ++++++++++++++++++++++
> >  tools/testing/selftests/bpf/bench.h       |  74 +++++
> >  tools/testing/selftests/bpf/bench_count.c |  91 ++++++
> >  5 files changed, 540 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/bench.c
> >  create mode 100644 tools/testing/selftests/bpf/bench.h
> >  create mode 100644 tools/testing/selftests/bpf/bench_count.c
> >
> > diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/sel=
ftests/bpf/.gitignore
> > index 3ff031972975..1bb204cee853 100644
> > --- a/tools/testing/selftests/bpf/.gitignore
> > +++ b/tools/testing/selftests/bpf/.gitignore
> > @@ -38,3 +38,4 @@ test_cpp
> >  /bpf_gcc
> >  /tools
> >  /runqslower
> > +/bench
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index 3d942be23d09..ab03362d46e4 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -77,7 +77,7 @@ TEST_PROGS_EXTENDED :=3D with_addr.sh \
> >  # Compile but not part of 'make run_tests'
> >  TEST_GEN_PROGS_EXTENDED =3D test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_=
user \
> > -     test_lirc_mode2_user xdping test_cpp runqslower
> > +     test_lirc_mode2_user xdping test_cpp runqslower bench
> >
> >  TEST_CUSTOM_PROGS =3D urandom_read
> >
> > @@ -405,6 +405,15 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_co=
re_extern.skel.h $(BPFOBJ)
> >       $(call msg,CXX,,$@)
> >       $(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
> >
> > +# Benchmark runner
> > +$(OUTPUT)/bench.o:          bench.h
> > +$(OUTPUT)/bench_count.o:    bench.h
> > +$(OUTPUT)/bench: LDLIBS +=3D -lm
> > +$(OUTPUT)/bench: $(OUTPUT)/bench.o \
> > +              $(OUTPUT)/bench_count.o
> > +     $(call msg,BINARY,,$@)
> > +     $(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
> > +
> >  EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)                  =
 \
> >       prog_tests/tests.h map_tests/tests.h verifier/tests.h           \
> >       feature                                                         \
> > diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selfte=
sts/bpf/bench.c
> > new file mode 100644
> > index 000000000000..a20482bb74e2
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/bench.c
> > @@ -0,0 +1,364 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
> > +#define _GNU_SOURCE
> > +#include <argp.h>
> > +#include <linux/compiler.h>
> > +#include <sys/time.h>
> > +#include <sched.h>
> > +#include <fcntl.h>
> > +#include <pthread.h>
> > +#include <sys/sysinfo.h>
> > +#include <sys/resource.h>
> > +#include <signal.h>
> > +#include "bench.h"
> > +
> > +struct env env =3D {
> > +     .duration_sec =3D 10,
> > +     .warmup_sec =3D 5,
>
> Just curious I'm guessing the duration/warmap are arbitrary here? Seems
> a bit long I would bet 5,1 would be enough for global/local test at
> least.

Yeah, completely arbitrary. I started with just 1 second, but for some
benchmark stabilization came around second 4-5, so I bumped it to 5.
It's easy to modify with -d and -w arguments, but I can bump it down
to 5, 1 for defaults.

>
> > +     .affinity =3D false,
> > +     .consumer_cnt =3D 1,
> > +     .producer_cnt =3D 1,
> > +};
> > +
>
> [...]
>
> > +void hits_drops_report_progress(int iter, struct bench_res *res, long =
delta_ns)
> > +{
> > +     double hits_per_sec, drops_per_sec;
> > +     double hits_per_prod;
> > +
> > +     hits_per_sec =3D res->hits / 1000000.0 / (delta_ns / 1000000000.0=
);
> > +     hits_per_prod =3D hits_per_sec / env.producer_cnt;
>
> Per producer counts would also be useful. Averaging over producer cnt cou=
ld
> hide issues with fairness.

True about hiding fairness issues, but for benchmarks with lots of
producers, it's so many numbres, that it will be hard to interpret it
per-producer. We could probably add stddev calculation across multiple
producers and stuff like that, but I'd defer that to future
enhancements. This benchmarker is a side-product of BPF ringbuf work,
not the goal in itself.

>
> > +     drops_per_sec =3D res->drops / 1000000.0 / (delta_ns / 1000000000=
.0);
> > +
> > +     printf("Iter %3d (%7.3lfus): ",
> > +            iter, (delta_ns - 1000000000) / 1000.0);
> > +
> > +     printf("hits %8.3lfM/s (%7.3lfM/prod), drops %8.3lfM/s\n",
> > +            hits_per_sec, hits_per_prod, drops_per_sec);
> > +}
> > +
>
> [...]
>
> > +const char *argp_program_version =3D "benchmark";
> > +const char *argp_program_bug_address =3D "<bpf@vger.kernel.org>";
> > +const char argp_program_doc[] =3D
> > +"benchmark    Generic benchmarking framework.\n"
> > +"\n"
> > +"This tool runs benchmarks.\n"
> > +"\n"
> > +"USAGE: benchmark <mode>\n"
> > +"\n"
> > +"EXAMPLES:\n"
> > +"    benchmark count-local                # run 'count-local' benchmar=
k with 1 producer and 1 consumer\n"
> > +"    benchmark -p16 -c8 -a count-local    # run 'count-local' benchmar=
k with 16 producer and 8 consumer threads, pinned to CPUs\n";
> > +
> > +static const struct argp_option opts[] =3D {
> > +     { "mode", 'm', "MODE", 0, "Benchmark mode"},
>
> "Benchmark mode" hmm not sure what this is for yet. Only on
> first patch though so maybe I'll become enlightened?

Oh, actually I don't need it, it's just a positional argument, I'll
drop this line.

>
> > +     { "list", 'l', NULL, 0, "List available benchmarks"},
> > +     { "duration", 'd', "SEC", 0, "Duration of benchmark, seconds"},
> > +     { "warmup", 'w', "SEC", 0, "Warm-up period, seconds"},
> > +     { "producers", 'p', "NUM", 0, "Number of producer threads"},
> > +     { "consumers", 'c', "NUM", 0, "Number of consumer threads"},
> > +     { "verbose", 'v', NULL, 0, "Verbose debug output"},
> > +     { "affinity", 'a', NULL, 0, "Set consumer/producer thread affinit=
y"},
> > +     { "b2b", 'b', NULL, 0, "Back-to-back mode"},
> > +     { "rb-output", 10001, NULL, 0, "Set consumer/producer thread affi=
nity"},
> > +     {},
> > +};
>
> [...]
>
> > +
> > +static void set_thread_affinity(pthread_t thread, int cpu)
> > +{
> > +     cpu_set_t cpuset;
> > +
> > +     CPU_ZERO(&cpuset);
> > +     CPU_SET(cpu, &cpuset);
> > +     if (pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset))
> > +             printf("setting affinity to CPU #%d failed: %d\n", cpu, e=
rrno);
> > +}
>
> Should we error out on affinity errors?

Given I made affinity setting optional (in the end), I guess I could
make it fail.

>
> > +
> > +static struct bench_state {
> > +     int res_cnt;
> > +     struct bench_res *results;
> > +     pthread_t *consumers;
> > +     pthread_t *producers;
> > +} state;
>
> [...]
>
> > +
> > +static void setup_benchmark()
> > +{
> > +     int i, err;
> > +
> > +     if (!env.mode) {
> > +             fprintf(stderr, "benchmark mode is not specified\n");
> > +             exit(1);
> > +     }
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(benchs); i++) {
> > +             if (strcmp(benchs[i]->name, env.mode) =3D=3D 0) {
>
> Ah the mode. OK maybe in description call it, "Benchmark mode to run" or
> "Benchmark test"? Or leave it its probably fine.

How about bench_name?


>
> > +                     bench =3D benchs[i];
> > +                     break;
> > +             }
> > +     }
> > +     if (!bench) {
> > +             fprintf(stderr, "benchmark '%s' not found\n", env.mode);
> > +             exit(1);
> > +     }
> > +
> > +     printf("Setting up benchmark '%s'...\n", bench->name);
> > +
> > +     state.producers =3D calloc(env.producer_cnt, sizeof(*state.produc=
ers));
> > +     state.consumers =3D calloc(env.consumer_cnt, sizeof(*state.consum=
ers));
> > +     state.results =3D calloc(env.duration_sec + env.warmup_sec + 2,
> > +                            sizeof(*state.results));
> > +     if (!state.producers || !state.consumers || !state.results)
> > +             exit(1);
> > +
> > +     if (bench->validate)
> > +             bench->validate();
> > +     if (bench->setup)
> > +             bench->setup();
> > +
> > +     for (i =3D 0; i < env.consumer_cnt; i++) {
> > +             err =3D pthread_create(&state.consumers[i], NULL,
> > +                                  bench->consumer_thread, (void *)(lon=
g)i);
> > +             if (err) {
> > +                     fprintf(stderr, "failed to create consumer thread=
 #%d: %d\n",
> > +                             i, -errno);
> > +                     exit(1);
> > +             }
> > +             if (env.affinity)
> > +                     set_thread_affinity(state.consumers[i], i);
> > +     }
> > +     for (i =3D 0; i < env.producer_cnt; i++) {
> > +             err =3D pthread_create(&state.producers[i], NULL,
> > +                                  bench->producer_thread, (void *)(lon=
g)i);
> > +             if (err) {
> > +                     fprintf(stderr, "failed to create producer thread=
 #%d: %d\n",
> > +                             i, -errno);
> > +                     exit(1);
> > +             }
> > +             if (env.affinity)
> > +                     set_thread_affinity(state.producers[i],
> > +                                         env.consumer_cnt + i);
> > +     }
> > +
> > +     printf("Benchmark '%s' started.\n", bench->name);
> > +}
>
> [...]
>
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/bench_count.c
>
> How about a ./bpf/bench/ directory? Seems we are going to get a few
> bench_* tests here.
>

Sounds good to me, I'll move.
