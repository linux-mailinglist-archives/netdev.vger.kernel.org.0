Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E581C8E11
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgEGOLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbgEGOLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:11:25 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B29C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:11:25 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b8so3010600ybn.0
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRnl8Tpss8sV+8qAbPp6PP/Ne93Fee+ZUxdVeA7Qh/8=;
        b=nyaiilSdEzsyngYHWVOhJUOYMuLu0nyMP5cn89kuxniR67R7NBMwToctGaWrxwqqx/
         06jAm/rREUhduGB/palaqAV2r4aLiYS7+OPMTCXCmak/8Rm/603lUe8zJ8dKDoW35Ae5
         wmItNoEfivFGxgO9UPISQQAQd6BRTJX47paJy1SXJqGcNNmAC74/BjIOyIhQBSvMCUCV
         GoCqG43ne3wjaqoLGRB0iA3FNBOasOssVuIJytOKKzyGwSXnxk59MSWbFuqiR+3P1iaQ
         GD837db9O4OUEowEvz8KzYeglyvnYej3rgoCzqt4CJgNbkmSadvjcW7rrnhCUCepzPEt
         bWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRnl8Tpss8sV+8qAbPp6PP/Ne93Fee+ZUxdVeA7Qh/8=;
        b=X/niR+JGHChl91ReZ8Bz1Sq1I/LY08xLxlSxtZ8AKyBz03sK/O+3CWJj6DkhZd078R
         dYxPDaAHErOgcrSXCywbFjHld5Z7Epp3fE4tSwcFSHviqkTHghKLoqzRz4AAB8RPeVai
         /BUvsW2iTz2AQ3HF2c1vmAIeJeNPy1poBi5tzU1IbUVO5TT9rxOKlqhZxKXLqJJt4hCD
         TTymiAMzVTDSO7kd2vQ/mYmok2RvpKKQKUFPC1lBEcDZZSZmXVh4fduZV3lDgB1yxze+
         Pp5wG9faTFeSh3xw57VmtN8Ct33oz2Ed+niYxJHqsFt4Axoh3lhxpEvILQJO6rtTaMwa
         cSng==
X-Gm-Message-State: AGi0PuYsWAMDM0uh7gKIcK4OGiZK9aSKKSMn+bQbcMAUPs9lUYx51muo
        JeNBXQeKt1qzXxUVQocAQfOh0OacjCBKYqjgzpXqcQ==
X-Google-Smtp-Source: APiQypJFREC/4DF6ySewOZt6hUFNS7y74v6hNDrlmDlJKMX5CRaZo87v+FDWdm3C6SMfdy6SGnzTQ9kVeDBbR3DdEBk=
X-Received: by 2002:a25:4446:: with SMTP id r67mr1612320yba.41.1588860684521;
 Thu, 07 May 2020 07:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200507081436.49071-1-irogers@google.com> <20200507134939.GA2804092@krava>
In-Reply-To: <20200507134939.GA2804092@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 7 May 2020 07:11:13 -0700
Message-ID: <CAP-5=fWyV_tcEe_zss7HE7u_3JLkkBeJ5JYLVbWWuO3Q2RpRnw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 7, 2020 at 6:49 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, May 07, 2020 at 01:14:29AM -0700, Ian Rogers wrote:
> > Metric groups contain metrics. Metrics create groups of events to
> > ideally be scheduled together. Often metrics refer to the same events,
> > for example, a cache hit and cache miss rate. Using separate event
> > groups means these metrics are multiplexed at different times and the
> > counts don't sum to 100%. More multiplexing also decreases the
> > accuracy of the measurement.
> >
> > This change orders metrics from groups or the command line, so that
> > the ones with the most events are set up first. Later metrics see if
> > groups already provide their events, and reuse them if
> > possible. Unnecessary events and groups are eliminated.
> >
> > RFC because:
> >  - without this change events within a metric may get scheduled
> >    together, after they may appear as part of a larger group and be
> >    multiplexed at different times, lowering accuracy - however, less
> >    multiplexing may compensate for this.
> >  - libbpf's hashmap is used, however, libbpf is an optional
> >    requirement for building perf.
> >  - other things I'm not thinking of.
>
> hi,
> I can't apply this, what branch/commit is this based on?
>
>         Applying: perf expr: migrate expr ids table to libbpf's hashmap
>         error: patch failed: tools/perf/tests/pmu-events.c:428
>         error: tools/perf/tests/pmu-events.c: patch does not apply
>         error: patch failed: tools/perf/util/expr.h:2
>         error: tools/perf/util/expr.h: patch does not apply
>         error: patch failed: tools/perf/util/expr.y:73
>         error: tools/perf/util/expr.y: patch does not apply
>         Patch failed at 0001 perf expr: migrate expr ids table to libbpf's hashmap
>
> thanks,
> jirka

Thanks for trying! I have resent the entire patch series here:
https://lore.kernel.org/lkml/20200507140819.126960-1-irogers@google.com/
It is acme's perf/core tree + metric fix/test CLs + some minor fixes.
Details in the cover letter.

Thanks,
Ian

> >
> > Thanks!
> >
> > Ian Rogers (7):
> >   perf expr: migrate expr ids table to libbpf's hashmap
> >   perf metricgroup: change evlist_used to a bitmap
> >   perf metricgroup: free metric_events on error
> >   perf metricgroup: always place duration_time last
> >   perf metricgroup: delay events string creation
> >   perf metricgroup: order event groups by size
> >   perf metricgroup: remove duped metric group events
> >
> >  tools/perf/tests/expr.c       |  32 ++---
> >  tools/perf/tests/pmu-events.c |  22 ++--
> >  tools/perf/util/expr.c        | 125 ++++++++++--------
> >  tools/perf/util/expr.h        |  22 ++--
> >  tools/perf/util/expr.y        |  22 +---
> >  tools/perf/util/metricgroup.c | 242 +++++++++++++++++++++-------------
> >  tools/perf/util/stat-shadow.c |  46 ++++---
> >  7 files changed, 280 insertions(+), 231 deletions(-)
> >
> > --
> > 2.26.2.526.g744177e7f7-goog
> >
>
