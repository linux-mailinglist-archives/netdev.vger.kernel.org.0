Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33B1DA25B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgESUPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgESUPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 16:15:55 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AD5C08C5C2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 13:15:54 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s1so1068887qkf.9
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 13:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TO5dMGuoi1kCRRb/+6qO1E4s7zpB8nWv0o7765YzP7M=;
        b=tFpDa+SIF8J9hbLHG5GILLdJuWlP+vg72DAqF3ts8lf8v3hE4zugMieXVzFQflly/V
         TQAbRleTds+7OpbV0WPkI5sAWD9OKkAdjXJj7KakwQwWxf5dYRGRooPRl58kdcFySBKS
         Wx1lNQN604Mr6KzIv+ObErS6SOS6mpzTkW2TQ8g1D/sk6B62pLByagTT9UCqaE/rUd53
         RXEyBeLTNqIPBFPJRWmocmSu92fWIWMMUY4aEdywN+mnjw7+HiDv6045xix+LFM4wvk2
         ggFvva9bzwu20lIl+F+Exs+l5PyeF01FayycjxF5hfXLMIHBg2+/OU7tzpW6wxPLPLXN
         VbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TO5dMGuoi1kCRRb/+6qO1E4s7zpB8nWv0o7765YzP7M=;
        b=cOeGLyskHzgrCvnumooYtIQx4oFZ5gn7v9vJ7+83Ota1uGHghCODWLM87iQ6EoqnEp
         wE+LxI3xHoEMyGPCWrfP74sxOUmDqciKBbPSsizeF/eiV34B/rZoV+XHkG7UDQT7+bo2
         vu+EV7/Ux4fTD+QWEohmKnaqw5TbfRC0DSLCySKcGN3Zt62F6qNrV+ZlRQ9poNuTyNPj
         VpfyjtL8Xm+Qbd7xjk/FnOSOvCqMOt5SpdQXG3Sq4y56XgS4KN8K8tZh93ncTbRPdj6F
         pYc38rKTs77Lig2xHYsOhq1ju3unW4WqlJ1QPEy4sDZzgi+qkM1KUEEOB/mmG49QrhsN
         phZA==
X-Gm-Message-State: AOAM532qEcRQOwZWoww8u6xSBiyCKoOu4F22gs+bE7sCnMPNAFx/crbQ
        sWM54uvj298Auqce3CVKGdduZPwAS8fz3saMAwrUfw==
X-Google-Smtp-Source: ABdhPJyn2v4e6S+RNRBx13hLKpD3vGX1DVudWBoUdwMBu5NoaK5swkGvyds93T0lv3JKzDVZMnnKMw8fCOiZm3FUDow=
X-Received: by 2002:a25:be81:: with SMTP id i1mr1771591ybk.184.1589919353706;
 Tue, 19 May 2020 13:15:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200515221732.44078-1-irogers@google.com> <20200515221732.44078-7-irogers@google.com>
 <20200519190602.GB28228@kernel.org>
In-Reply-To: <20200519190602.GB28228@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 19 May 2020 13:15:41 -0700
Message-ID: <CAP-5=fVdDjazSdzfTXeuWwqCSh0zURp3M8QZpYK=qd92GeyrRw@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] perf test: Improve pmu event metric testing
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Paul Clarke <pc@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 12:06 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Fri, May 15, 2020 at 03:17:31PM -0700, Ian Rogers escreveu:
> > Break pmu-events test into 2 and add a test to verify that all pmu
> > metric expressions simply parse. Try to parse all metric ids/events,
> > skip/warn if metrics for the current architecture fail to parse. To
> > support warning for a skip, and an ability for a subtest to describe why
> > it skips.
> >
> > Tested on power9, skylakex, haswell, broadwell, westmere, sandybridge and
> > ivybridge.
> >
> > May skip/warn on other architectures if metrics are invalid. In
> > particular s390 is untested, but its expressions are trivial. The
> > untested architectures with expressions are power8, cascadelakex,
> > tremontx, skylake, jaketown, ivytown and variants of haswell and
> > broadwell.
> >
> > v3. addresses review comments from John Garry <john.garry@huawei.com>,
> > Jiri Olsa <jolsa@redhat.com> and Arnaldo Carvalho de Melo
> > <acme@kernel.org>.
> > v2. changes the commit message as event parsing errors no longer cause
> > the test to fail.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: Jin Yao <yao.jin@linux.intel.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: John Garry <john.garry@huawei.com>
> > Cc: Kajol Jain <kjain@linux.ibm.com>
> > Cc: Kan Liang <kan.liang@linux.intel.com>
> > Cc: Leo Yan <leo.yan@linaro.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Clarke <pc@us.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > Link: http://lore.kernel.org/lkml/20200513212933.41273-1-irogers@google.com
> > [ split from a larger patch ]
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/perf/tests/builtin-test.c |   7 ++
> >  tools/perf/tests/pmu-events.c   | 168 ++++++++++++++++++++++++++++++--
> >  tools/perf/tests/tests.h        |   3 +
> >  3 files changed, 172 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
> > index baee735e6aa5..9553f8061772 100644
> > --- a/tools/perf/tests/builtin-test.c
> > +++ b/tools/perf/tests/builtin-test.c
> > @@ -75,6 +75,13 @@ static struct test generic_tests[] = {
> >       {
> >               .desc = "PMU events",
> >               .func = test__pmu_events,
> > +             .subtest = {
> > +                     .skip_if_fail   = false,
> > +                     .get_nr         = test__pmu_events_subtest_get_nr,
> > +                     .get_desc       = test__pmu_events_subtest_get_desc,
> > +                     .skip_reason    = test__pmu_events_subtest_skip_reason,
> > +             },
> > +
> >       },
> >       {
> >               .desc = "DSO data read",
> > diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
> > index d64261da8bf7..e21f0addcfbb 100644
> > --- a/tools/perf/tests/pmu-events.c
> > +++ b/tools/perf/tests/pmu-events.c
> > @@ -8,6 +8,9 @@
> >  #include <linux/zalloc.h>
> >  #include "debug.h"
> >  #include "../pmu-events/pmu-events.h"
> > +#include "util/evlist.h"
> > +#include "util/expr.h"
> > +#include "util/parse-events.h"
> >
> >  struct perf_pmu_test_event {
> >       struct pmu_event event;
> > @@ -144,7 +147,7 @@ static struct pmu_events_map *__test_pmu_get_events_map(void)
> >  }
> >
> >  /* Verify generated events from pmu-events.c is as expected */
> > -static int __test_pmu_event_table(void)
> > +static int test_pmu_event_table(void)
> >  {
> >       struct pmu_events_map *map = __test_pmu_get_events_map();
> >       struct pmu_event *table;
> > @@ -347,14 +350,11 @@ static int __test__pmu_event_aliases(char *pmu_name, int *count)
> >       return res;
> >  }
> >
> > -int test__pmu_events(struct test *test __maybe_unused,
> > -                  int subtest __maybe_unused)
> > +
> > +static int test_aliases(void)
> >  {
> >       struct perf_pmu *pmu = NULL;
> >
> > -     if (__test_pmu_event_table())
> > -             return -1;
> > -
> >       while ((pmu = perf_pmu__scan(pmu)) != NULL) {
> >               int count = 0;
> >
> > @@ -377,3 +377,159 @@ int test__pmu_events(struct test *test __maybe_unused,
> >
> >       return 0;
> >  }
> > +
> > +static bool is_number(const char *str)
> > +{
> > +     char *end_ptr;
> > +
> > +     strtod(str, &end_ptr);
> > +     return end_ptr != str;
> > +}
>
> So, this breaks in some systems:
>
> cc1: warnings being treated as errors
> tests/pmu-events.c: In function 'is_number':
> tests/pmu-events.c:385: error: ignoring return value of 'strtod', declared with attribute warn_unused_result
> mv: cannot stat `/tmp/build/perf/tests/.pmu-events.o.tmp': No such file or director
>
> So I'm changing it to verify the result of strtod() which is, humm,
> interesting, please check:

Thanks Arnaldo and sorry for the difficulty. This looks like a good fix.

> diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
> index 3de59564deb0..6c58c3a89e6b 100644
> --- a/tools/perf/tests/pmu-events.c
> +++ b/tools/perf/tests/pmu-events.c
> @@ -1,4 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
> +#include "math.h"
>  #include "parse-events.h"
>  #include "pmu.h"
>  #include "tests.h"
> @@ -381,8 +382,12 @@ static int test_aliases(void)
>  static bool is_number(const char *str)
>  {
>         char *end_ptr;
> +       double v;
>
> -       strtod(str, &end_ptr);
> +       errno = 0;
> +       v = strtod(str, &end_ptr);
> +       if ((errno == ERANGE && (v == HUGE_VAL || v == -HUGE_VAL)) || (errno != 0 && v == 0.0))

errno can either be 0 or ERANGE here, but we test both. Perhaps use
errno != 0 for both cases as the man page notes suggest doing this.
The tests using v are necessary to avoid the unused result, but
presumably any errno case should return false here? I guess testing
that is redundant as the return below will catch it. Perhaps this
should be:

errno = 0;
v = strtod(str, &end_ptr);
(void)v;  /* We don't care for the value of the double, just that it
converts. Avoid unused result warnings. */
return errno == 0 && end_ptr != str;

Thanks,
Ian

> +               return false;
>         return end_ptr != str;
>  }
>
