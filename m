Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7EF1A88E3
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503650AbgDNSOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503639AbgDNSOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:14:15 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EDFC061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:14:14 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id i2so7715512ybk.2
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANLrY4ni7/9H944gaMoVhVUXyiL5aEmRMiwWCB+UJKE=;
        b=iLnREQsqffwaJy3FePccTuETnEVFwlaFpld2yrIrRXQ7A36BwmrE1GlAwupPa5L47g
         VmnZWDR9jqg/phbSSPtf8QcENJgUg7GH8O5O2/NbFIEYHag5LVgk3Wge6H63DxzZd6P9
         MItSwoJezoC7yFPTOHK2U0vX9qFBErGLI9hJ7kPLq6rhbzCAAfwuhsB0p3yilxsr9mpX
         Qai3Q3wqsMvrXZ3kklG5YlM5Um7gWA8NXiJEy3fSFEHoewS5hPrA3R4nORvxYnHvJC+q
         yxcAMO8IPG3pGrXtWLD+zjvnoXEXvf2AALtjJ1UdXw9Dj757IeTV9LfNWmidYc8N+1Yz
         P6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANLrY4ni7/9H944gaMoVhVUXyiL5aEmRMiwWCB+UJKE=;
        b=MNdURqWWanGelygoNfv7zbgoIVPn107+uSU2UoIWY0m8PsZFa07G13gt0yy2mnMPDQ
         EYBIzHzIjJPkVQQhrAtPxjMWR3fXF1YW5VxrQmKzAreCa5ErytvEjRvrlZVn6RdvMyaR
         ZSi2ZZjNRwezAMsUcrufDYrQaVwznPrrnIld6VXUHsY56TMo6nGjWLg1ELI56d0xB8HV
         rMgX/hHaU/6MfZI4lwcY2v1NBfbN9luR4cKwx58SLdnhL0Ibpev4yfqwU9YdJAQokcz0
         bKi2XsJoYKAQ/YCEi5roOvFdlV/zwadPRoQHsdWITS8Y2pfpCbRbKAHlQsDgHuaWlXrQ
         6FRw==
X-Gm-Message-State: AGi0PuY5x8ItzpDYHHM5dnxLs74eEHGCZRBAl/irGklQHVFS1O17CBqo
        zNhvSRXqD9D7z/x7jsu3RB2z37YQDRmBQoJhGDRFHA==
X-Google-Smtp-Source: APiQypJykLo1er/rJmbEdiyFYjwm7+CD4HzCNR2GAZsEgaOKmBtuRhgU0Ng44D7rAjxhNkfFtPyHmipGv/BFzHbg8Nw=
X-Received: by 2002:a25:aaa4:: with SMTP id t33mr2030364ybi.324.1586888053511;
 Tue, 14 Apr 2020 11:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200411074631.9486-1-irogers@google.com> <20200411074631.9486-5-irogers@google.com>
 <20200414152102.GC208694@krava>
In-Reply-To: <20200414152102.GC208694@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 14 Apr 2020 11:14:01 -0700
Message-ID: <CAP-5=fW6LgbEodo0StNXBm+hjEEhrQ8JFBU8tYEfeoCURmakaQ@mail.gmail.com>
Subject: Re: [PATCH v8 4/4] perf tools: add support for libpfm4
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 8:21 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Sat, Apr 11, 2020 at 12:46:31AM -0700, Ian Rogers wrote:
>
> SNIP
>
> >  TAG_FOLDERS= . ../lib ../include
> >  TAG_FILES= ../../include/uapi/linux/perf_event.h
> > diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> > index 965ef017496f..7b64cd34266e 100644
> > --- a/tools/perf/builtin-list.c
> > +++ b/tools/perf/builtin-list.c
> > @@ -18,6 +18,10 @@
> >  #include <subcmd/parse-options.h>
> >  #include <stdio.h>
> >
> > +#ifdef HAVE_LIBPFM
> > +#include "util/pfm.h"
> > +#endif
>
> so we have the HAVE_LIBPFM you could do the:
>
> #ifdef HAVE_LIBPFM
> #else
> #endif
>
> in util/pfm.h and add stubs for libpfm_initialize and others
> in case HAVE_LIBPFM is not defined.. that clear out all the
> #ifdefs in the change
>
>
> SNIP
>
> > diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
> > index b6322eb0f423..8b323151f22c 100644
> > --- a/tools/perf/tests/builtin-test.c
> > +++ b/tools/perf/tests/builtin-test.c
> > @@ -313,6 +313,15 @@ static struct test generic_tests[] = {
> >               .desc = "maps__merge_in",
> >               .func = test__maps__merge_in,
> >       },
> > +     {
> > +             .desc = "Test libpfm4 support",
> > +             .func = test__pfm,
> > +             .subtest = {
> > +                     .skip_if_fail   = true,
> > +                     .get_nr         = test__pfm_subtest_get_nr,
> > +                     .get_desc       = test__pfm_subtest_get_desc,
> > +             }
>
> awesome :)
>
> SNIP
>
> > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > index d23db6755f51..83ad76d3d2be 100644
> > --- a/tools/perf/util/evsel.c
> > +++ b/tools/perf/util/evsel.c
> > @@ -2447,9 +2447,15 @@ bool perf_evsel__fallback(struct evsel *evsel, int err,
> >               const char *sep = ":";
> >
> >               /* Is there already the separator in the name. */
> > +#ifndef HAVE_LIBPFM
> >               if (strchr(name, '/') ||
> >                   strchr(name, ':'))
> >                       sep = "";
> > +#else
> > +             if (strchr(name, '/') ||
> > +                 (strchr(name, ':') && !evsel->is_libpfm_event))
> > +                     sep = "";
> > +#endif
>
>
>   ^^^^^^^^
>
> >
> >               if (asprintf(&new_name, "%s%su", name, sep) < 0)
> >                       return false;
> > diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> > index 53187c501ee8..397d335d5e24 100644
> > --- a/tools/perf/util/evsel.h
> > +++ b/tools/perf/util/evsel.h
> > @@ -76,6 +76,9 @@ struct evsel {
> >       bool                    ignore_missing_thread;
> >       bool                    forced_leader;
> >       bool                    use_uncore_alias;
> > +#ifdef HAVE_LIBPFM
> > +     bool                    is_libpfm_event;
> > +#endif
>
> perhaps we could had this one in unconditionaly,
> because I think we have some members like that
> for aux tracing.. and that would remove the #ifdef
> above
>
>
> SNIP
>
> >
> > +#ifdef HAVE_LIBPFM
> > +struct evsel *parse_events__pfm_add_event(int idx, struct perf_event_attr *attr,
> > +                                     char *name, struct perf_pmu *pmu)
> > +{
> > +     return __add_event(NULL, &idx, attr, false, name, pmu, NULL, false,
> > +                        NULL);
> > +}
> > +#endif
>
> could you instead add parse_events__add_event and call it from pfm code?

I wasn't clear whether this was just a name change given the different
arguments on existing functions. Hopefully everything is addressed in
the v9 set:
https://lore.kernel.org/lkml/20200414181054.22435-2-irogers@google.com/T/#m32fc3e3605e49b01e12418f59ef3977cab0561ed

Thanks,
Ian

> SNIP
>
> > +             pmu = perf_pmu__find_by_type((unsigned int)attr.type);
> > +             evsel = parse_events__pfm_add_event(evlist->core.nr_entries,
> > +                                             &attr, q, pmu);
> > +             if (evsel == NULL)
> > +                     goto error;
> > +
> > +             evsel->is_libpfm_event = true;
> > +
> > +             evlist__add(evlist, evsel);
> > +
> > +             if (grp_evt == 0)
> > +                     grp_leader = evsel;
> > +
> > +             if (grp_evt > -1) {
> > +                     evsel->leader = grp_leader;
> > +                     grp_leader->core.nr_members++;
> > +                     grp_evt++;
> > +             }
> > +
> > +             if (*sep == '}') {
> > +                     if (grp_evt < 0) {
> > +                             ui__error("cannot close a non-existing event group\n");
> > +                             goto error;
> > +                     }
> > +                     evlist->nr_groups++;
> > +                     grp_leader = NULL;
> > +                     grp_evt = -1;
> > +             }
> > +             evsel->is_libpfm_event = true;
>
> seems to be set twice in here
>
>
> > +     }
> > +     return 0;
> > +error:
> > +     free(p_orig);
> > +     return -1;
> > +}
> > +
> > +static const char *srcs[PFM_ATTR_CTRL_MAX] = {
> > +     [PFM_ATTR_CTRL_UNKNOWN] = "???",
> > +     [PFM_ATTR_CTRL_PMU] = "PMU",
> > +     [PFM_ATTR_CTRL_PERF_EVENT] = "perf_event",
> > +};
>
> SNIP
>
> thanks,
> jirka
>
