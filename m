Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50051597F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344050AbiD3BJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381908AbiD3BJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:09:49 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6BD3D1C5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:06:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so7267044wmj.1
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7qNaPs3zy12CvBRms+N52lGaX2W8Sk7OZR1Boqjrdfw=;
        b=fzBN4zqk9f0mDBcHDK4k1QHYTJPu7Nknb1EJRsBQ9vMPgx1qb1gj4a1QNmjp32Msnr
         RJ3J3WbmRZphW89zNTBWSESffPrHtPRwikEfblLCdcJuidEcCYTaj6TyNax1wbhf7vYH
         ERG1FUiEJ6TpVqaT7vQah6Xuqa2RHjPIr4JcnOkF6mVYClMtIvpXz5zwhXsD+SwPdHXC
         nCG1vrtSrMk6tM1l8q59jWsEPB4s7F13/XiE/EO/zyw2mqkT5S2ns1sPR4DPXGVFNchh
         WmBqWw5A0g8a8eVJUj18Vt82esUlNyFxEh0sFf5ZHxsCWKAXyiIaRsXkR0Dh37QamZcp
         hIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7qNaPs3zy12CvBRms+N52lGaX2W8Sk7OZR1Boqjrdfw=;
        b=uwLPv67PJYvtDSLnnD/8tqCKgn0lan+um3N+yVOEQZrbEACTq65Iu+Rbud6PEVRhA+
         +QcbmL6u2fRHYO8UdqNlEc/HcVcdVjEQjcJqlnFX+BSWk4m8wBQsLvffbtRGSbcY2mzn
         gF/abpnKxhuhqcE5zxc9PlQrWshyLXMLjEDlYF3X+U8LV52Pe/UAZ2bdLMGSgvD2wCdW
         fJfovAwSxDNn+R0BmTNrAFVtCrtbCJMHIPsKiwZ+E9ocy/czyy+DvFZMmj5kS74STjZ6
         xHbgQTDFebkgNEionDyOFtA70Np7IOvmvIV9WlNylWipeRFc1N8K1KRd6F6VRW9i2bwz
         J7oQ==
X-Gm-Message-State: AOAM533dZiJLedmHTKzH1bKBTQ/laJVc/UkHEWqzUQru2B5t0EhylCoB
        vQ8cOmcKyRvJljjH1+x3+gU7J3ixqnY2EkNn1TJBIw==
X-Google-Smtp-Source: ABdhPJzudrgwMR/5lX5j1Tj7DFcb9c9LBfuylXx7/ABuYasfhoeIqRi9pVrIYxF9lFh02/GDz9pVd8eP3hpF+mYCZp0=
X-Received: by 2002:a1c:a301:0:b0:392:9bc5:203c with SMTP id
 m1-20020a1ca301000000b003929bc5203cmr1363872wme.67.1651280780620; Fri, 29 Apr
 2022 18:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220408035616.1356953-1-irogers@google.com> <20220408035616.1356953-5-irogers@google.com>
 <c9205f19-52bf-43fe-b1ab-b599d5e2cc7a@intel.com> <CAP-5=fVNuQDW+yge897RjaWfE3cfQTD4ufFws6PS2k99Qe05Uw@mail.gmail.com>
 <e82c7ab0-605e-8795-58dd-dc182f80c6b3@intel.com>
In-Reply-To: <e82c7ab0-605e-8795-58dd-dc182f80c6b3@intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 29 Apr 2022 18:06:07 -0700
Message-ID: <CAP-5=fVMHzTfKdpWMXtbtx7t14u2f4WzNak+F0Q93cQ7CZfhbg@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] perf evlist: Respect all_cpus when setting user_requested_cpus
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 4:34 AM Adrian Hunter <adrian.hunter@intel.com> wro=
te:
>
> On 28/04/22 23:49, Ian Rogers wrote:
> > On Thu, Apr 28, 2022 at 1:16 PM Adrian Hunter <adrian.hunter@intel.com =
<mailto:adrian.hunter@intel.com>> wrote:
> >
> >     On 8/04/22 06:56, Ian Rogers wrote:
> >     > If all_cpus is calculated it represents the merge/union of all
> >     > evsel cpu maps. By default user_requested_cpus is computed to be
> >     > the online CPUs. For uncore events, it is often the case currentl=
y
> >     > that all_cpus is a subset of user_requested_cpus. Metrics printed
> >     > without aggregation and with metric-only, in print_no_aggr_metric=
,
> >     > iterate over user_requested_cpus assuming every CPU has a metric =
to
> >     > print. For each CPU the prefix is printed, but then if the
> >     > evsel's cpus doesn't contain anything you get an empty line like
> >     > the following on a 2 socket 36 core SkylakeX:
> >     >
> >     > ```
> >     > $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
> >     >      1.000453137 CPU0                       0.00
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137 CPU18                      0.00
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      1.000453137
> >     >      2.003717143 CPU0                       0.00
> >     > ...
> >     > ```
> >     >
> >     > While it is possible to be lazier in printing the prefix and
> >     > trailing newline, having user_requested_cpus not be a subset of
> >     > all_cpus is preferential so that wasted work isn't done elsewhere
> >     > user_requested_cpus is used. The change modifies user_requested_c=
pus
> >     > to be the intersection of user specified CPUs, or default all onl=
ine
> >     > CPUs, with the CPUs computed through the merge of all evsel cpu m=
aps.
> >     >
> >     > New behavior:
> >     > ```
> >     > $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
> >     >      1.001086325 CPU0                       0.00
> >     >      1.001086325 CPU18                      0.00
> >     >      2.003671291 CPU0                       0.00
> >     >      2.003671291 CPU18                      0.00
> >     > ...
> >     > ```
> >     >
> >     > Signed-off-by: Ian Rogers <irogers@google.com <mailto:irogers@goo=
gle.com>>
> >     > ---
> >     >  tools/perf/util/evlist.c | 7 +++++++
> >     >  1 file changed, 7 insertions(+)
> >     >
> >     > diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> >     > index 52ea004ba01e..196d57b905a0 100644
> >     > --- a/tools/perf/util/evlist.c
> >     > +++ b/tools/perf/util/evlist.c
> >     > @@ -1036,6 +1036,13 @@ int evlist__create_maps(struct evlist *evl=
ist, struct target *target)
> >     >       if (!cpus)
> >     >               goto out_delete_threads;
> >     >
> >     > +     if (evlist->core.all_cpus) {
> >     > +             struct perf_cpu_map *tmp;
> >     > +
> >     > +             tmp =3D perf_cpu_map__intersect(cpus, evlist->core.=
all_cpus);
> >
> >     Isn't an uncore PMU represented as being on CPU0 actually
> >     collecting data that can be due to any CPU.
> >
> >
> > This is correct but the counter is only opened on CPU0 as the all_cpus =
cpu_map will only contain CPU0. Trying to dump the counter for say CPU1 wil=
l fail as there is no counter there. This is why the metric-only output isn=
't displaying anything above.
>
> That's not what happens for me:
>
> $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000 -- sleep 1
> #           time CPU              DRAM_BW_Use
>      1.001114691 CPU0                       0.00
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.001114691
>      1.002265387 CPU0                       0.00
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387
>      1.002265387

Thanks! To be clear, getting rid of the unnecessary spew above is what
this patch set is about.

> perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000 -C 1 -- sleep 1
> #           time CPU              DRAM_BW_Use
>      1.001100827 CPU1                       0.00
>      1.002128527 CPU1                       0.00

So this case I'd not been thinking about. What does it mean? We have a
metric that is computed using uncore_imc that has a cpumask of 0 on
your machine. You are requesting the data for CPU1. This feels like
user error. After this change the behavior is:

$ perf stat -A -M DRAM_BW_Use -a --metric-only -C 1 -- sleep 1
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument)
for event (uncore_imc/cas_count_write/).
/bin/dmesg | grep -i perf may provide additional information.

That kind of goes along with this. What has actually happened is the
intersect has resulted in an empty cpu_map and so we try to program
the events for CPU -1 and that fails.

The existing behavior is to open the event for CPU1 and more than that
it succeeds in the perf_event_open for CPU 1. I find that weird. With
the CPU being 1 we have the user_requested_cpus being {1} and all_cpus
being {0} (I'm using the curlies just to say it is really a set). That
means, for example, the affinity iterator evlist__for_each_cpu [1]
will not iterate over any of the evsels as there is no CPU where the
evsel's cpu_map agrees with the all_cpu cpu_map.

Now, I can imagine it being said the existing behavior is value add.
We can move events away from the crowded CPU0 to some arbitrary CPU
and I'm sympathetic to that. I think the bug this is highlighting is
that in this case all_cpus should be {1} and not {0} as the code
currently computes (hence the empty intersect and death). This would
also fix the evlist__for_each_cpu loop.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/too=
ls/perf/util/evlist.h?h=3Dperf/core#n353

> >
> >
> >     Or for an uncore PMU represented as being on CPU0-CPU4 on a
> >     4 core 8 hyperthread processor, actually 1 PMU per core.
> >
> >
> > In this case I believe the CPU map will be CPU0, CPU2, CPU4, CPU6. To g=
et the core counter for hyperthreads on CPU0 and CPU1 you read on CPU0, the=
re is no counter on CPU1 and trying to read it will fail as the counters ar=
e indexed by a cpu map index into the all_cpus . Not long ago I cleaned up =
the cpu_map code as there was quite a bit of confusion over cpus and indexe=
s which were both of type int.
> >
> >
> >     So I am not sure intersection makes sense.
> >
> >     Also it is not obvious what happens with hybrid CPUs or
> >     per thread recording.
> >
> >
> > The majority of code is using all_cpus, and so is unchanged by this cha=
nge.
>
> I am not sure what you mean.  Every tool uses this code.  It affects ever=
ything when using PMUs with their own cpus.

My point was that because we use iterators on all_cpus then the common
case is the all_cpus case, this code only affects user_requested_cpus.
Looking at raw references there are more to user_requested_cpus than
all_cpus, but I believe the main iterators in the stat code are
largely based on all_cpus. In any case this doesn't matter given what
I found below.

> >  Code that is affected, when it say needs to use counters, needs to che=
ck that the user CPU was valid in all_cpus, and use the all_cpus index. The=
 metric-only output could be fixed in the same way, ie don't display lines =
when the user_requested_cpu isn't in all_cpus. I prefered to solve the prob=
lem this way as it is inefficient  to be processing cpus where there can be=
 no corresponding counters, etc. We may be setting something like affinity =
unnecessarily - although that doesn't currently happen as that code iterate=
s over all_cpus. I also think it is confusing from its name when the variab=
le all_cpus is for a cpu_map that contains fewer cpus than user_requested_c=
pus - albeit that was worse when user_requested_cpus was called just cpus.
> >
> > It could be hybrid or intel-pt have different assumptions on these cpu_=
maps. I don't have access to a hybrid test system. For intel-pt it'd be gre=
at if there were a perf test. Given that most code is using all_cpus and wa=
s cleaned up as part of the cpu_map work, I believe the change to be correc=
t.
>
> Mainly what happens if you try to intersect all_cpus with dummy cpus?

The intersect of two dummy cpu_maps is a dummy cpu_map, as with merge.
When all_cpus is computed during add:
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/l=
ib/perf/evlist.c?h=3Dperf/core#n72
dummy maps are treated as empty and evsel's cpumap is replaced with
the user_requested_cpus which is empty:
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/l=
ib/perf/evlist.c?h=3Dperf/core#n47
It will then merge this empty cpu_map into all_cpus:
https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/l=
ib/perf/evlist.c?h=3Dperf/core#n55
Rather than rely on the copy of an empty user_requested_cpus, I think
the merge and intersect functions should explicitly handle dummy as an
empty cpu_map.

This code then sets user_requested_cpus and it will intersect it with
all_cpus. This is then propagated to the empty cpu_maps in the evsels.
This shows another bug in this change:

Current behavior:
```
$ perf stat -A -M DRAM_BW_Use -e faults -a sleep 1

Performance counter stats for 'system wide':

CPU0                   280.09 MiB  uncore_imc/cas_count_read/ #
0.00 DRAM_BW_Use
CPU18                  184.07 MiB  uncore_imc/cas_count_read/ #
0.00 DRAM_BW_Use
CPU0                   167.29 MiB  uncore_imc/cas_count_write/
CPU18                  149.95 MiB  uncore_imc/cas_count_write/
CPU0            1,002,927,474 ns   duration_time
CPU0                       42      faults
CPU1                        2      faults
CPU2                       19      faults
CPU3                        0      faults
CPU4                        2      faults
CPU5                       88      faults
CPU6                        0      faults
CPU7                        6      faults
CPU8                        2      faults
CPU9                        2      faults
CPU10                       2      faults
CPU11                       0      faults
CPU12                       0      faults
CPU13                      12      faults
CPU14                     158      faults
CPU15                      31      faults
CPU16                       0      faults
CPU17                      18      faults
CPU18                     108      faults
CPU19                      27      faults
CPU20                      23      faults
CPU21                       9      faults
CPU22                      10      faults
CPU23                       0      faults
CPU24                       0      faults
CPU25                       1      faults
CPU26                      38      faults
CPU27                       1      faults
CPU28                      16      faults
CPU29                       0      faults
CPU30                       3      faults
CPU31                       5      faults
CPU32                       2      faults
CPU33                       1      faults
CPU34                       3      faults
CPU35                      41      faults

      1.002927474 seconds time elapsed
```

New behavior:
```
$ /tmp/perf/perf stat -A -M DRAM_BW_Use -e faults -a sleep 1

Performance counter stats for 'system wide':

CPU0                   389.17 MiB  uncore_imc/cas_count_write/ #
0.00 DRAM_BW_Use
CPU18                  158.69 MiB  uncore_imc/cas_count_write/ #
0.00 DRAM_BW_Use
CPU0                   465.99 MiB  uncore_imc/cas_count_read/
CPU18                  242.37 MiB  uncore_imc/cas_count_read/
CPU0            1,003,287,405 ns   duration_time
CPU0                      176      faults
CPU18                     110      faults

      1.003287405 seconds time elapsed
```

So I think I've come around to the idea that user_requested_cpus needs
to be the original non-intersected value for the setting of
empty/dummy evsel's cpu_map. We could add a valid_user_requested_cpus
variable, which would be the intersect of the user_requested_cpus with
all_cpus, but there seems little point.

So I still need to follow this up to fix the bug and the bugs
discovered in this thread. The main follow-up actions are:
1) modify merge to explicitly handle dummy maps - and intersect if we
still need intersect after these changes.
2) document user_requested_cpus, detail why it can have more cpus than
"all_cpus" and the behavior for dummy cpu maps
3) rename all_cpus, to perhaps merged_evsel_cpus - I want to get away
from the implication all_cpus is a super set of cpu maps like
user_requested_cpus.
4) fixup evsel cpu maps when the event will be opened on a cpu that
isn't in the cpu_map.
5) update the stat-display print_no_aggr_metric of user_requested_cpus
so that CPUs not in all_cpus/merged_evsel_cpus don't get new lines
printed.

Thanks,
Ian

> >
> > Thanks,
> > Ian
> >
> >
> >     > +             perf_cpu_map__put(cpus);
> >     > +             cpus =3D tmp;
> >     > +     }
> >     >       evlist->core.has_user_cpus =3D !!target->cpu_list && !targe=
t->hybrid;
> >     >
> >     >       perf_evlist__set_maps(&evlist->core, cpus, threads);
> >
>
