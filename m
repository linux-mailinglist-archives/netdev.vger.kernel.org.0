Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E2276185
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIWT7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIWT7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:59:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DFDC0613D1
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 12:59:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so1359603wrm.2
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 12:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=omNgAU/l78x9UsZx+b4xR6QdpKVoCnKdDvnTd0n4YQI=;
        b=rmzhewfMlVnWB+gyRCJ7IvGeu4ajHptWF+tiTKIDq5wYZuqAGKwdDXotYPvQQN4Aui
         U12mzQ3WR7RmIev6GC3ZLZGp3V9wTyvv5vzbi+wSUdjYCVnFDRcv2ebHjJKUei0bOpzg
         YZy3Ne0R84gwDUuXCiZnxGzwi+0EiQbPZCRUVuUw2yDkHAWSRgYNmD1cUP1FRZ/KZk91
         7aa2XkvoKtXa9Z0Rc9OuhJ7lHEgcDlTxUZhyhDCQC+PXSxdTWib87r4C3CsDd67nOVCO
         /REhNAY+rwEQMCqaFP+qaU5iJ/diloEtW6dMmbblj1siI0dDcJY0g/yh6c8rnnqzWrxX
         BPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=omNgAU/l78x9UsZx+b4xR6QdpKVoCnKdDvnTd0n4YQI=;
        b=IQG2ISE8ZkgUbcDxTZK36/R8FH9M2IIjG6gCT+7KuDMXgMXrSkCYNcgvV2ciMpwsjC
         hPCN148j1K97MoGJKR7JNqwUwZXJUb4B8LEgnVwsETyU/WbJwX5qOLd7ssPsPSwEOXxf
         OyJul60qCg30L7tp1zDAhrU1zYRUfhqIwFxfR1Jk0YQI3Wop8UM3NRziKCAbnr/l1FCY
         fSqnvxECtPA/GL7V2QhEs7uNRm0jSp4KXFbtaQLmMQe5v6E/jethn62A59oMAcy6NLOV
         Vhda+zWyF7/3YCq5/+SdqFQM85JBIvIQvjwDsNlyXBSGm6xN0BXbQ1a1hGrrpYU57+Um
         485g==
X-Gm-Message-State: AOAM5335H3jin24QebP+5qH4qpLh3UrYr6vcntFH4ltB+YfLKhTYZ3Dy
        39+QgInCjbixmjQCuIu5A3T9B/d3Q0ePsA8ok1Z4LQ==
X-Google-Smtp-Source: ABdhPJxM0PgqFXZb8FmQir+7H/etiCWV9Sr4XWWqYNkEyoX5SokG5ZAHSUpGnT1mnxpwTJkKDVFkEPh/Q2995ETBVl4=
X-Received: by 2002:adf:f88b:: with SMTP id u11mr1285857wrp.376.1600891180248;
 Wed, 23 Sep 2020 12:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200917190026.GB1426933@kernel.org> <20200917201807.4090224-1-irogers@google.com>
 <20200917203953.GA1525630@kernel.org> <CAM9d7ciWo301cdQT7=MNB3XDrggjiR=4N4f-6CGaJfAiJO54Lw@mail.gmail.com>
In-Reply-To: <CAM9d7ciWo301cdQT7=MNB3XDrggjiR=4N4f-6CGaJfAiJO54Lw@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 23 Sep 2020 12:59:28 -0700
Message-ID: <CAP-5=fVJMeMhjwbO=ms7k0GsM6L1-uTdHqXUOJSvS4cr8M-Org@mail.gmail.com>
Subject: Re: [PATCH v4] perf metricgroup: Fix uncore metric expressions
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Jin Yao <yao.jin@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 6:47 PM Namhyung Kim <namhyung@kernel.org> wrote:
>
> Hi Arnaldo,
>
> On Fri, Sep 18, 2020 at 5:39 AM Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
> >
> > Em Thu, Sep 17, 2020 at 01:18:07PM -0700, Ian Rogers escreveu:
> > > A metric like DRAM_BW_Use has on SkylakeX events uncore_imc/cas_count_read/
> > > and uncore_imc/case_count_write/. These events open 6 events per socket
> > > with pmu names of uncore_imc_[0-5]. The current metric setup code in
> > > find_evsel_group assumes one ID will map to 1 event to be recorded in
> > > metric_events. For events with multiple matches, the first event is
> > > recorded in metric_events (avoiding matching >1 event with the same
> > > name) and the evlist_used updated so that duplicate events aren't
> > > removed when the evlist has unused events removed.
> >
> > Namhyung, please check if you still Acks this as you provided it for v3.
>
> Sure,
>
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks Namhyung and Arnaldo, could we merge this?

Ian

> Thanks
> Namhyung
>
> >
> > > Before this change:
> > > $ /tmp/perf/perf stat -M DRAM_BW_Use -a -- sleep 1
> > >
> > >  Performance counter stats for 'system wide':
> > >
> > >              41.14 MiB  uncore_imc/cas_count_read/
> > >      1,002,614,251 ns   duration_time
> > >
> > >        1.002614251 seconds time elapsed
> > >
> > > After this change:
> > > $ /tmp/perf/perf stat -M DRAM_BW_Use -a -- sleep 1
> > >
> > >  Performance counter stats for 'system wide':
> > >
> > >             157.47 MiB  uncore_imc/cas_count_read/ #     0.00 DRAM_BW_Use
> > >             126.97 MiB  uncore_imc/cas_count_write/
> > >      1,003,019,728 ns   duration_time
> > >
> > > Erroneous duplication introduced in:
> > > commit 2440689d62e9 ("perf metricgroup: Remove duped metric group events").
> > >
> > > Fixes: ded80bda8bc9 ("perf expr: Migrate expr ids table to a hashmap").
> > > Reported-by: Jin Yao <yao.jin@linux.intel.com>
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > ---
> > >  tools/perf/util/metricgroup.c | 75 ++++++++++++++++++++++++++---------
> > >  1 file changed, 56 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> > > index ab5030fcfed4..d948a7f910cf 100644
> > > --- a/tools/perf/util/metricgroup.c
> > > +++ b/tools/perf/util/metricgroup.c
> > > @@ -150,6 +150,18 @@ static void expr_ids__exit(struct expr_ids *ids)
> > >               free(ids->id[i].id);
> > >  }
> > >
> > > +static bool contains_event(struct evsel **metric_events, int num_events,
> > > +                     const char *event_name)
> > > +{
> > > +     int i;
> > > +
> > > +     for (i = 0; i < num_events; i++) {
> > > +             if (!strcmp(metric_events[i]->name, event_name))
> > > +                     return true;
> > > +     }
> > > +     return false;
> > > +}
> > > +
> > >  /**
> > >   * Find a group of events in perf_evlist that correpond to those from a parsed
> > >   * metric expression. Note, as find_evsel_group is called in the same order as
> > > @@ -180,7 +192,11 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > >       int i = 0, matched_events = 0, events_to_match;
> > >       const int idnum = (int)hashmap__size(&pctx->ids);
> > >
> > > -     /* duration_time is grouped separately. */
> > > +     /*
> > > +      * duration_time is always grouped separately, when events are grouped
> > > +      * (ie has_constraint is false) then ignore it in the matching loop and
> > > +      * add it to metric_events at the end.
> > > +      */
> > >       if (!has_constraint &&
> > >           hashmap__find(&pctx->ids, "duration_time", (void **)&val_ptr))
> > >               events_to_match = idnum - 1;
> > > @@ -207,23 +223,20 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > >                               sizeof(struct evsel *) * idnum);
> > >                       current_leader = ev->leader;
> > >               }
> > > -             if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
> > > -                     if (has_constraint) {
> > > -                             /*
> > > -                              * Events aren't grouped, ensure the same event
> > > -                              * isn't matched from two groups.
> > > -                              */
> > > -                             for (i = 0; i < matched_events; i++) {
> > > -                                     if (!strcmp(ev->name,
> > > -                                                 metric_events[i]->name)) {
> > > -                                             break;
> > > -                                     }
> > > -                             }
> > > -                             if (i != matched_events)
> > > -                                     continue;
> > > -                     }
> > > +             /*
> > > +              * Check for duplicate events with the same name. For example,
> > > +              * uncore_imc/cas_count_read/ will turn into 6 events per socket
> > > +              * on skylakex. Only the first such event is placed in
> > > +              * metric_events. If events aren't grouped then this also
> > > +              * ensures that the same event in different sibling groups
> > > +              * aren't both added to metric_events.
> > > +              */
> > > +             if (contains_event(metric_events, matched_events, ev->name))
> > > +                     continue;
> > > +             /* Does this event belong to the parse context? */
> > > +             if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr))
> > >                       metric_events[matched_events++] = ev;
> > > -             }
> > > +
> > >               if (matched_events == events_to_match)
> > >                       break;
> > >       }
> > > @@ -239,7 +252,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > >       }
> > >
> > >       if (matched_events != idnum) {
> > > -             /* Not whole match */
> > > +             /* Not a whole match */
> > >               return NULL;
> > >       }
> > >
> > > @@ -247,8 +260,32 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > >
> > >       for (i = 0; i < idnum; i++) {
> > >               ev = metric_events[i];
> > > -             ev->metric_leader = ev;
> > > +             /* Don't free the used events. */
> > >               set_bit(ev->idx, evlist_used);
> > > +             /*
> > > +              * The metric leader points to the identically named event in
> > > +              * metric_events.
> > > +              */
> > > +             ev->metric_leader = ev;
> > > +             /*
> > > +              * Mark two events with identical names in the same group (or
> > > +              * globally) as being in use as uncore events may be duplicated
> > > +              * for each pmu. Set the metric leader of such events to be the
> > > +              * event that appears in metric_events.
> > > +              */
> > > +             evlist__for_each_entry_continue(perf_evlist, ev) {
> > > +                     /*
> > > +                      * If events are grouped then the search can terminate
> > > +                      * when then group is left.
> > > +                      */
> > > +                     if (!has_constraint &&
> > > +                         ev->leader != metric_events[i]->leader)
> > > +                             break;
> > > +                     if (!strcmp(metric_events[i]->name, ev->name)) {
> > > +                             set_bit(ev->idx, evlist_used);
> > > +                             ev->metric_leader = metric_events[i];
> > > +                     }
> > > +             }
> > >       }
> > >
> > >       return metric_events[0];
> > > --
> > > 2.28.0.618.gf4bc123cb7-goog
> > >
> >
> > --
> >
> > - Arnaldo
