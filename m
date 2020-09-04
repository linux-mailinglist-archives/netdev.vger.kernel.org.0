Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2720B25D0F0
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 07:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIDFla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 01:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgIDFl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 01:41:28 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B200C061246
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 22:41:27 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v4so4876156wmj.5
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 22:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxEHmah9blk5L82GWsoRPi5EZiYjjH11uscySYlFpC4=;
        b=uYwRCB5kDNzhf606GuU4XzIiuAokdeoihG+bPh6wUT/0YFUOFDMrZqdUb9wBz91MUv
         3ghwwJQBbDTQ9Cli+XHglA+eEp4olBMsHDbTQ/I7V47gct5s29XlGJJl5Z8bXZ8wovuA
         PB3oSidPEgd1HK1btHYp8YcRq3pYkYBMqurbBSl/5LxnMF37z7D+8xFP7osk3kyp4IaG
         5l5HvkaPV7Yi5WbjDLKB/jyYAQZWpTuKc7N5XFpSlTnVhkQzaOX2ny91lTCUp1o1DMmv
         0LbvL+9lKzGeFO859nwN2ez8WdnkPYgfQ53xfKyFLW55LjPdFqUH2QwmbGXMz00L3YFr
         qcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxEHmah9blk5L82GWsoRPi5EZiYjjH11uscySYlFpC4=;
        b=kDea9SpSH0/DcyyFCS278wGV5xSFoLiHIMehW034Q3PGOTOqlV/SXg6JB7S1opaTlU
         13NNh5gZPTECzfxanyLVQqmASRg2WAK8JBcjfH3vhgHNICpLHwvAgm5PoASWMoLdW877
         7GwBbxZ+HKDCQj0KIxhXRk2erEdWcv9yyO3byFBnlrzBezE+hs4JaKvjFoEUxy4cUAHi
         FVds9WY+mSyK6DFYP9RlGUttHgxt6PzAhAbHZpOCKTMc2KpuvCx2tHdYCRbclnNAaDMn
         7spzbLtSsBrJjz0N7dDsykJQkEJEmjzDz6QmUEAjtZY+dijnN8q2Wn3+Cr4+zkC0J4bU
         dUfQ==
X-Gm-Message-State: AOAM532/C8t19ZYrxxDDiGnIz1iqf+sEbC25TDBf0yatZiRTn/H++GSF
        lDYmoTkENSmxg/KYuc9Qp+5Oqz7Co/iRgmh60F6S1g==
X-Google-Smtp-Source: ABdhPJwSXPbM7H8AqFNPB15V4yVaM1G5f3+f/ye53ieg94IdFB/Ad1I8DJEeSI2HAhrh+Kas0Sed8LPWXccTgf6MFNM=
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr5966208wmb.77.1599198085991;
 Thu, 03 Sep 2020 22:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com> <20200728085734.609930-3-irogers@google.com>
 <20200728155940.GC1319041@krava> <20200728160954.GD1319041@krava> <CAP-5=fVqto0LrwgW6dHQupp7jFA3wToRBonBaXXQW4wwYcTreg@mail.gmail.com>
In-Reply-To: <CAP-5=fVqto0LrwgW6dHQupp7jFA3wToRBonBaXXQW4wwYcTreg@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 3 Sep 2020 22:41:14 -0700
Message-ID: <CAP-5=fWNniZuYfYhz_Cz7URQ+2E4T4Kg3DJqGPtDg70i38Er_A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 4:24 PM Ian Rogers <irogers@google.com> wrote:
>
> On Tue, Jul 28, 2020 at 9:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Jul 28, 2020 at 05:59:46PM +0200, Jiri Olsa wrote:
> > > On Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers wrote:
> > > > From: Stephane Eranian <eranian@google.com>
> > > >
> > > > Before:
> > > > $ perf record -c 10000 --pfm-events=cycles:period=77777
> > > >
> > > > Would yield a cycles event with period=10000, instead of 77777.
> > > >
> > > > This was due to an ordering issue between libpfm4 parsing
> > > > the event string and perf record initializing the event.
> > > >
> > > > This patch fixes the problem by preventing override for
> > > > events with attr->sample_period != 0 by the time
> > > > perf_evsel__config() is invoked. This seems to have been the
> > > > intent of the author.
> > > >
> > > > Signed-off-by: Stephane Eranian <eranian@google.com>
> > > > Reviewed-by: Ian Rogers <irogers@google.com>
> > > > ---
> > > >  tools/perf/util/evsel.c | 3 +--
> > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > >
> > > > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > > > index 811f538f7d77..8afc24e2ec52 100644
> > > > --- a/tools/perf/util/evsel.c
> > > > +++ b/tools/perf/util/evsel.c
> > > > @@ -976,8 +976,7 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
> > > >      * We default some events to have a default interval. But keep
> > > >      * it a weak assumption overridable by the user.
> > > >      */
> > > > -   if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> > > > -                                opts->user_interval != ULLONG_MAX)) {
> > > > +   if (!attr->sample_period) {
> > >
> > > I was wondering why this wouldn't break record/top
> > > but we take care of the via record_opts__config
> > >
> > > as long as 'perf test attr' works it looks ok to me
> >
> > hum ;-)
> >
> > [jolsa@krava perf]$ sudo ./perf test 17 -v
> > 17: Setup struct perf_event_attr                          :
> > ...
> > running './tests/attr/test-record-C0'
> > expected sample_period=4000, got 3000
> > FAILED './tests/attr/test-record-C0' - match failure
>
> I'm not able to reproduce this. Do you have a build configuration or
> something else to look at? The test doesn't seem obviously connected
> with this patch.
>
> Thanks,
> Ian

Jiri, any update? Thanks,
Ian

> > jirka
> >
> > >
> > > Acked-by: Jiri Olsa <jolsa@redhat.com>
> > >
> > > thanks,
> > > jirka
> >
