Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE31DBCB3
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgETSWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgETSWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:22:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69134C061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:22:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id a14so4216780ilk.2
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f/GVZd7ESIzgVNhsrJW5PyE298L4FuKCaYaDMiX7tBc=;
        b=dhdeCSjRiWfCTgZHaYc5lDpzJhgGmGznip0fO45gjhoi5zhucoXDkbfvGv2brtwixp
         KdEt3ZgZiavGZdGNv63+iCZwvib0MtVKkON4R8QPVSCxmF2CpJ7gI3ApbefB479r4AU4
         lsFGV5VdbWc6PK4or0M3sSgcWMxjNGSGe6BUMagaZmhk9W9iJCSW09AWBpe/aaY+Sdql
         2Y7i7vQ/oA60WvR+pr48dLv+7uLhlYHD6f4GFpfEinWSlo3wuFNbGluENEJGSa4h7oIy
         LFlkOyJnjYJuktEdan7rhgjrd9RY48nv+6gsYNyAKJSe57aUhbNFZKj22KLxDWmEwugm
         73pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/GVZd7ESIzgVNhsrJW5PyE298L4FuKCaYaDMiX7tBc=;
        b=mrgwnuA7QMf1MuMG7oJP7JEi2MPXqCodNIZW0vFKRZWLYuy633XEc52aX5tdsNIyoL
         fv7R74T18ib+fIVr6nzaoTP5MWZJRzFY1S5IEOy5B6YIsiajtdACkiIAuDyZIOg/F91Z
         xLDIBqcjvg62TDUeU+q5TCAEsW2k0LE5teh8KpUgNTWBr3yJMBi+3SPEmnsVUi3cL+Y+
         Eg7Kqs4hVWLqO5bgW4/ezgcz4jzS+DPdtPuotS2x/Z+2hcOl6neAfNHLQee5x7uM6i1D
         LQ39NLWRl/FLUlArcmcQV3t4hqRlrF0Ooz196JR6NASksgZmQsTQhUMQmdbzVMe/p3Vd
         1pKw==
X-Gm-Message-State: AOAM5304pl1TOgFk6gSeGhglZvQe3xSzXfhSAQjXZTKHuoWlYi9soQo9
        SYZpvD2ix5bJZeBcTxOzJ5PrG8ZjPjEsypf9iNUzWg==
X-Google-Smtp-Source: ABdhPJwJYzklFP1O+ry02hbJTZuRp3l0pIS9xKqKMX71WXe0sCoddPUAuAWbkZyBVf4WMXE/762PZsQB+WOQC/nzEYE=
X-Received: by 2002:a92:1b17:: with SMTP id b23mr5057619ilb.199.1589998953923;
 Wed, 20 May 2020 11:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com> <20200520072814.128267-4-irogers@google.com>
 <20200520131412.GK157452@krava>
In-Reply-To: <20200520131412.GK157452@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 20 May 2020 11:22:22 -0700
Message-ID: <CAP-5=fXHRiahLZjQHcFiWW=zdXc7r+=WdMpzeCj-+xPcqB2khQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] perf metricgroup: Delay events string creation
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

On Wed, May 20, 2020 at 6:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, May 20, 2020 at 12:28:10AM -0700, Ian Rogers wrote:
> > Currently event groups are placed into groups_list at the same time as
> > the events string containing the events is built. Separate these two
> > operations and build the groups_list first, then the event string from
> > the groups_list. This adds an ability to reorder the groups_list that
> > will be used in a later patch.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/metricgroup.c | 38 +++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 13 deletions(-)
> >
> > diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> > index 7a43ee0a2e40..afd960d03a77 100644
> > --- a/tools/perf/util/metricgroup.c
> > +++ b/tools/perf/util/metricgroup.c
> > @@ -90,6 +90,7 @@ struct egroup {
> >       const char *metric_expr;
> >       const char *metric_unit;
> >       int runtime;
> > +     bool has_constraint;
> >  };
> >
> >  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> > @@ -485,8 +486,8 @@ int __weak arch_get_runtimeparam(void)
> >       return 1;
> >  }
> >
> > -static int __metricgroup__add_metric(struct strbuf *events,
> > -             struct list_head *group_list, struct pmu_event *pe, int runtime)
> > +static int __metricgroup__add_metric(struct list_head *group_list,
> > +                                  struct pmu_event *pe, int runtime)
> >  {
> >       struct egroup *eg;
> >
> > @@ -499,6 +500,7 @@ static int __metricgroup__add_metric(struct strbuf *events,
> >       eg->metric_expr = pe->metric_expr;
> >       eg->metric_unit = pe->unit;
> >       eg->runtime = runtime;
> > +     eg->has_constraint = metricgroup__has_constraint(pe);
> >
> >       if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
> >               expr__ctx_clear(&eg->pctx);
> > @@ -506,14 +508,6 @@ static int __metricgroup__add_metric(struct strbuf *events,
> >               return -EINVAL;
> >       }
> >
> > -     if (events->len > 0)
> > -             strbuf_addf(events, ",");
> > -
> > -     if (metricgroup__has_constraint(pe))
> > -             metricgroup__add_metric_non_group(events, &eg->pctx);
> > -     else
> > -             metricgroup__add_metric_weak_group(events, &eg->pctx);
> > -
> >       list_add_tail(&eg->nd, group_list);
> >
> >       return 0;
> > @@ -524,6 +518,7 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
> >  {
> >       struct pmu_events_map *map = perf_pmu__find_map(NULL);
> >       struct pmu_event *pe;
> > +     struct egroup *eg;
> >       int i, ret = -EINVAL;
> >
> >       if (!map)
> > @@ -542,7 +537,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
> >                       pr_debug("metric expr %s for %s\n", pe->metric_expr, pe->metric_name);
> >
> >                       if (!strstr(pe->metric_expr, "?")) {
> > -                             ret = __metricgroup__add_metric(events, group_list, pe, 1);
> > +                             ret = __metricgroup__add_metric(group_list,
> > +                                                             pe, 1);
> >                       } else {
> >                               int j, count;
> >
> > @@ -553,13 +549,29 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
> >                                * those events to group_list.
> >                                */
> >
> > -                             for (j = 0; j < count; j++)
> > -                                     ret = __metricgroup__add_metric(events, group_list, pe, j);
> > +                             for (j = 0; j < count; j++) {
> > +                                     ret = __metricgroup__add_metric(
> > +                                             group_list, pe, j);
> > +                             }
> >                       }
> >                       if (ret == -ENOMEM)
> >                               break;
> >               }
> >       }
> > +     if (!ret) {
>
> could you please do instead:
>
>         if (ret)
>                 return ret;
>
> so the code below cuts down one indent level and you
> don't need to split up the lines

Done, broken out as a separate patch in v2:
https://lore.kernel.org/lkml/20200520182011.32236-3-irogers@google.com/

Thanks,
Ian

> thanks,
> jirka
>
> > +             list_for_each_entry(eg, group_list, nd) {
> > +                     if (events->len > 0)
> > +                             strbuf_addf(events, ",");
> > +
> > +                     if (eg->has_constraint) {
> > +                             metricgroup__add_metric_non_group(events,
> > +                                                               &eg->pctx);
> > +                     } else {
> > +                             metricgroup__add_metric_weak_group(events,
> > +                                                                &eg->pctx);
> > +                     }
> > +             }
> > +     }
> >       return ret;
> >  }
> >
> > --
> > 2.26.2.761.g0e0b3e54be-goog
> >
>
