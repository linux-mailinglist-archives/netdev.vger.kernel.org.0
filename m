Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E177D1CEB71
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgELDaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728115AbgELDaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:30:01 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A8C061A0C;
        Mon, 11 May 2020 20:30:01 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z90so9939393qtd.10;
        Mon, 11 May 2020 20:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m1fW+UHaacfwXC05NUa/o+jf/5wSzDPWaKy5Pf3FN+8=;
        b=ZovqGhDMpe0z26Rz3CaabqVupHSZWwEsAUqTlRk1fUXaLMqIYwJ7ex/6rOvpoVQTP6
         PG7CIZV2YG8zp4X1YnbqObFwDnnSLAFUNNNOPrQGEd5qyUZ1N8VD2zvbmxuglhVzJ2Si
         ewmigLjICzXPVFlCUluQI/UmLEXNLG9v5Kz3f5sYquaO2k6hq2hpN9hKE3GAAgoCfi6z
         QkOKlYwlQ5nr2Qz2e9JHerEfWpQpmYpc/95PnarbJoQY1oECHrBInvhjpwXQrlyla4P2
         kMeESAUrUuQIfiGjFej7919VlZHwhSOPpOz5fZpKVGHSg3ziIqQHKP4afwlvoHCLc+yZ
         up3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m1fW+UHaacfwXC05NUa/o+jf/5wSzDPWaKy5Pf3FN+8=;
        b=pKI6MR1fzoTQvGBD12sEGa/rjhb+LIQ731urULLjc+BzygAzPjQVU8uWv58QQEOPOh
         /eDHB3pwLDvYVBDmLbSTGGyl2w6u9hBCLFbdPIjJDlcQ7gpDuh2d+ZedscLp75uacvOr
         jT0PvmYTlkc7c7iDqObvcEqhxDWXLNJ1rMzDq+SuXnX49wc8H7/j3phGYJveEAI+grHY
         i8L5qDasJG+XLMFyPRvJ3Yx9pUkKWCVN45X9FXfzMH3ahxS9J0B0Lkged82nfQzBOOa9
         qxv9d4TKjcIgA+IueFIFpmu9IR5cyRl1KHhOBXcFzVCMi94/0cPvR3MO00yq2bGpvJDX
         bIMA==
X-Gm-Message-State: AGi0PuYSGtnEr7g25gvxptHY5j6RKE2YAiPrfPQZGSKtv9k/RkfETr9M
        1PWQpE6k/Ze1UfjiuNzFChLEcOnXH7Eud9/+R8A=
X-Google-Smtp-Source: APiQypL/aBljpzhvrALGs+c0yz4b1znl9jK7TMRAhTyfeXyjU3bnPYmPNxWAhlmUfh4XONGDHUEkj4ESfJOIPnteMQc=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr6347610qtc.93.1589254200748;
 Mon, 11 May 2020 20:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200508232032.1974027-1-andriin@fb.com> <20200508232032.1974027-2-andriin@fb.com>
 <3fc4af5c-739a-35c3-c649-03eef18a3144@fb.com>
In-Reply-To: <3fc4af5c-739a-35c3-c649-03eef18a3144@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 May 2020 20:29:49 -0700
Message-ID: <CAEf4BzYkbsd3EUXoH8M80+udtz-owN6gAb-Hpp==bNU2Pk6x+A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] selftests/bpf: add benchmark runner infrastructure
To:     Yonghong Song <yhs@fb.com>
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

On Sat, May 9, 2020 at 10:10 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
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
> >   tools/testing/selftests/bpf/.gitignore        |   1 +
> >   tools/testing/selftests/bpf/Makefile          |  13 +-
> >   tools/testing/selftests/bpf/bench.c           | 372 +++++++++++++++++=
+
> >   tools/testing/selftests/bpf/bench.h           |  74 ++++
> >   .../selftests/bpf/benchs/bench_count.c        |  91 +++++
> >   5 files changed, 550 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/bench.c
> >   create mode 100644 tools/testing/selftests/bpf/bench.h
> >   create mode 100644 tools/testing/selftests/bpf/benchs/bench_count.c
> >

[...]

trimming is good :)

> > +
> > +void hits_drops_report_final(struct bench_res res[], int res_cnt)
> > +{
> > +     int i;
> > +     double hits_mean =3D 0.0, drops_mean =3D 0.0;
> > +     double hits_stddev =3D 0.0, drops_stddev =3D 0.0;
> > +
> > +     for (i =3D 0; i < res_cnt; i++) {
> > +             hits_mean +=3D res[i].hits / 1000000.0 / (0.0 + res_cnt);
> > +             drops_mean +=3D res[i].drops / 1000000.0 / (0.0 + res_cnt=
);
> > +     }
> > +
> > +     if (res_cnt > 1)  {
> > +             for (i =3D 0; i < res_cnt; i++) {
> > +                     hits_stddev +=3D (hits_mean - res[i].hits / 10000=
00.0) *
> > +                                    (hits_mean - res[i].hits / 1000000=
.0) /
> > +                                    (res_cnt - 1.0);
> > +                     drops_stddev +=3D (drops_mean - res[i].drops / 10=
00000.0) *
> > +                                     (drops_mean - res[i].drops / 1000=
000.0) /
> > +                                     (res_cnt - 1.0);
> > +             }
> > +             hits_stddev =3D sqrt(hits_stddev);
> > +             drops_stddev =3D sqrt(drops_stddev);
> > +     }
> > +     printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",
> > +            hits_mean, hits_stddev, hits_mean / env.producer_cnt);
> > +     printf("drops %8.3lf \u00B1 %5.3lfM/s\n",
> > +            drops_mean, drops_stddev);
>
> The unicode char \u00B1 (for +|-) may cause some old compiler (e.g.,
> 4.8.5) warnings as it needs C99 mode.
>
> /data/users/yhs/work/net-next/tools/testing/selftests/bpf/bench.c:91:9:
> warning: universal character names are only valid in C++ and C99
> [enabled by default]
>    printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",
>
> "+|-" is alternative, but not as good as \u00B1 indeed. Newer
> compiler may already have the default C99. Maybe we can just add
> C99 for build `bench`?

I think I'm fine with ancient compiler emitting harmless warning for
code under selftests/bpf, honestly...

>
> > +}
> > +
> > +const char *argp_program_version =3D "benchmark";
> > +const char *argp_program_bug_address =3D "<bpf@vger.kernel.org>";
> > +const char argp_program_doc[] =3D
> > +"benchmark    Generic benchmarking framework.\n"
> > +"\n"
> > +"This tool runs benchmarks.\n"
> > +"\n"
> > +"USAGE: benchmark <bench-name>\n"
> > +"\n"
> > +"EXAMPLES:\n"
> > +"    # run 'count-local' benchmark with 1 producer and 1 consumer\n"
> > +"    benchmark count-local\n"
> > +"    # run 'count-local' with 16 producer and 8 consumer thread, pinne=
d to CPUs\n"
> > +"    benchmark -p16 -c8 -a count-local\n";
>
> Some of the above global variables probably are statics.
> But I do not have a strong preference on this.

Oh, it's actually global variables argp library expects, they have to be gl=
obal.

>
> > +
> > +static const struct argp_option opts[] =3D {
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
>
> I did not see b2b and rb-output options are processed in this file.

Slipped through the rebasing cracks from the future ringbuf
benchmarks, will remove it. I also figured out a way to do this more
modular anyways (child parsers in argp).

>
> > +     {},
> > +};
> > +

[...]

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
>
> Here, we bind consumer threads first and then producer threads, I think
> this is probably just arbitrary choice?

yep, almost arbitrary. Most of my cases have 1 consumer and >=3D1
producers, so it was convenient to have consumer pinned to same CPU,
regardless of how many producers I have.

>
> In certain cases, I think people may want to have more advanced binding
> scenarios, e.g., for hyperthreading, binding consumer and producer on
> the same core or different cores etc. One possibility is to introduce
> -c option similar to taskset. If -c not supplied, you can have
> the current default. Otherwise, using -c list.
>

well, taskset's job is simpler, it takes a list of CPUs for single
PID, if I understand correctly. Here we have many threads, each might
have different CPU or even CPUs. But I agree that for some benchmarks
it's going to be critical to control this precisely. Here's how I'm
going to allows most flexibility without too much complexity.

--prod-affinity 1,2,10-16,100 -- will specify a set of CPUs for
producers. First producer will use CPU with least index form that
list. Second will take second, and so on. If there are less CPUs
provided than necessary - it's an error. If more - it's fine.

Then for consumers will add independent --cons-affinity parameters,
which will do the same for consumer threads.

Having two independent lists will allow to test scenarios where we
want producers and consumers to fight for the same CPU.

Does this sound ok?

> > +     }
> > +
> > +     printf("Benchmark '%s' started.\n", bench->name);
> > +}
> > +

[...]

> > diff --git a/tools/testing/selftests/bpf/bench.h b/tools/testing/selfte=
sts/bpf/bench.h
> > new file mode 100644
> > index 000000000000..08aa0c5b1177
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/bench.h
> > @@ -0,0 +1,74 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#pragma once
> > +#include <stdlib.h>
> > +#include <stdbool.h>
> > +#include <linux/err.h>
> > +#include <errno.h>
> > +#include <unistd.h>
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +#include <math.h>
> > +#include <time.h>
> > +#include <sys/syscall.h>
> > +
> > +struct env {
> > +     char *bench_name;
> > +     int duration_sec;
> > +     int warmup_sec;
> > +     bool verbose;
> > +     bool list;
> > +     bool back2back;
>
> seems not used.

yep, cleaning up

>
> > +     bool affinity;
> > +     int consumer_cnt;
> > +     int producer_cnt;
> > +};
> > +

[...]
