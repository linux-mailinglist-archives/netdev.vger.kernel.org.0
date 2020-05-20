Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22C1DBA29
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 18:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgETQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgETQu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 12:50:27 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948F1C05BD43
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 09:50:27 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i16so1310723ybq.9
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 09:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKYd+eEqh94+PPSxeT0mEN4CuPeMB4JjYrAni6yKOek=;
        b=Eh6SNc8kXSnAsUcJ5NDUp1JxID73klNpgan5mB/uvuYRnEWgar9pgqlkZSuIvpsVcJ
         5D5oeNsStNFxA5sYJNZ+t216Rv2BDcgEUT+Mhe6/MaxnYjKFV5VEe6GxiBoERmOmBrSG
         RVtGXez/y2uvR9MXKV3qNOX9QlYr+FXL6PLilyrvR3Ykp4Q2AWMM9PXTjASyVKPeInsW
         Rs9Ery4sW/GeLu7I76XKp55D0+vk0kEAdXO3YC+5xGkPWviutxFd6lHb9qBEYaHV4dPl
         vSyLhhI8q5fbkzAwG2N8Uwip8g5oXJfipPY8OlZN9Q6/Wodsd6B81xf5GdR53xHbKpRO
         qgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKYd+eEqh94+PPSxeT0mEN4CuPeMB4JjYrAni6yKOek=;
        b=oVemsCxDTYE4SXInhe7hURlDTKWQ9TIszNEjv7SuC8UTGaPXaGSlpvVZhWv1edlGyI
         rkPGS+5rDdoMHqNHdbcyuZusNeR9LckfDtdJiTb6Sb5wXa0rcg+YNyiCj7a4bH1YJkx0
         8W16ZfLhIUq/ZqsVLmuenZlUos8v5DEZ7T3a/i7w/gFa7FJjXKKo/4WUGk5Vw+d6YE2O
         EOsAtq+mA3NAPKRW+dJboHuJnE0VVBukmiJNwnXDuLXCou2ILG9qPYd3+NDqpPxoAimj
         9rI+oa11quw19qQYfHoeI1woJEZAWkDHPdGhqaI4JOi2jJbXdWWGsh2Hy6N5RIbS5zd6
         1TLA==
X-Gm-Message-State: AOAM532/pNqh5r/VPQfdKkOM/sQgULOL7wmX9F+zbPlSFiHVrZ2+rE00
        4Jfrx998L8SxqJ/Wpwb8hTVNPaYqcFwSRq95z6uvvg==
X-Google-Smtp-Source: ABdhPJy5M4bW3EQJOtlA1J3fukdU3GsXBm5ahWMZ7f1tynRhLuSFHjlXX7HP519wXpXurP8N9XDEwnsZVT7E1P4g7iM=
X-Received: by 2002:a25:790e:: with SMTP id u14mr8671529ybc.324.1589993426351;
 Wed, 20 May 2020 09:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com> <20200520072814.128267-6-irogers@google.com>
 <20200520134847.GM157452@krava>
In-Reply-To: <20200520134847.GM157452@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 20 May 2020 09:50:13 -0700
Message-ID: <CAP-5=fVGf9i7hvQcht_8mnMMjzhQYdFqPzZFraE-iMR7Vcr1tw@mail.gmail.com>
Subject: Re: [PATCH 5/7] perf metricgroup: Remove duped metric group events
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 6:49 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, May 20, 2020 at 12:28:12AM -0700, Ian Rogers wrote:
>
> SNIP
>
> >
> > @@ -157,7 +183,7 @@ static int metricgroup__setup_events(struct list_head *groups,
> >       int i = 0;
> >       int ret = 0;
> >       struct egroup *eg;
> > -     struct evsel *evsel;
> > +     struct evsel *evsel, *tmp;
> >       unsigned long *evlist_used;
> >
> >       evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
> > @@ -173,7 +199,8 @@ static int metricgroup__setup_events(struct list_head *groups,
> >                       ret = -ENOMEM;
> >                       break;
> >               }
> > -             evsel = find_evsel_group(perf_evlist, &eg->pctx, metric_events,
> > +             evsel = find_evsel_group(perf_evlist, &eg->pctx,
> > +                                     eg->has_constraint, metric_events,
> >                                       evlist_used);
> >               if (!evsel) {
> >                       pr_debug("Cannot resolve %s: %s\n",
> > @@ -200,6 +227,12 @@ static int metricgroup__setup_events(struct list_head *groups,
> >               list_add(&expr->nd, &me->head);
> >       }
> >
> > +     evlist__for_each_entry_safe(perf_evlist, tmp, evsel) {
> > +             if (!test_bit(evsel->idx, evlist_used)) {
> > +                     evlist__remove(perf_evlist, evsel);
> > +                     evsel__delete(evsel);
> > +             }
>
> is the groupping still enabled when we merge groups? could part
> of the metric (events) be now computed in different groups?

By default the change will take two metrics and allow the shorter
metric (in terms of number of events) to share the events of the
longer metric. If the events for the shorter metric aren't in the
longer metric then the shorter metric must use its own group of
events. If sharing has occurred then the bitmap is used to work out
which events and groups are no longer in use.

With --metric-no-group then any event can be used for a metric as
there is no grouping. This is why more events can be eliminated.

With --metric-no-merge then the logic to share events between
different metrics is disabled and every metric is in a group. This
allows the current behavior to be had.

There are some corner cases, such as metrics with constraints (that
don't group) and duration_time that is never placed into a group.

Partial sharing, with one event in 1 weak event group and 1 in another
is never performed. Using --metric-no-group allows something similar.
Given multiplexing, I'd be concerned about accuracy problems if events
between groups were shared - say for IPC, were you measuring
instructions and cycles at the same moment?

> I was wondering if we could merge all the hasmaps into single
> one before the parse the evlist.. this way we won't need removing
> later.. but I did not thought this through completely, so it
> might not work at some point

This could be done in the --metric-no-group case reasonably easily
like the current hashmap. For groups you'd want something like a set
of sets of events, but then you'd only be able to share events if the
sets were the same. A directed acyclic graph could capture the events
and the sharing relationships, it may be possible to optimize cases
like {A,B,C}, {A,B,D}, {A,B} so that the small group on the end shares
events with both the {A,B,C} and {A,B,D} group. This may be good
follow up work. We could also solve this in the json, for example
create a "phony" group of {A,B,C,D} that all three metrics share from.
You could also use --metric-no-group to achieve that sharing now.

Thanks,
Ian

> jirka
>
