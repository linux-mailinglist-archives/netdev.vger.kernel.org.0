Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B7284E33
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgJFOm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJFOmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:42:25 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A4DC0613D2
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 07:42:25 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id d4so3178417wmd.5
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 07:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lLSXyq8geVEgL572mhZwfSsIq9Gg65HnBLRnWd1Y+1U=;
        b=uchN+P/SlvQqmnRGzQSmm/MAyAgLsmwhTdWtBE0OLzv6neOoBO+ynAVeeP5/DHJuz2
         JI+9Z2NoyIFlo775GSxjSV+wruDtGe6JoQa6U2JOi4fthHhEYU67LgOzoF4Pht1apgcc
         T7CkP5DIcDrbsJZZf2VTI8JI9bOSXtyeVoLhhdwVc5JEKuxaLadn5uCl2E9eGyCyAJ2B
         el05CSy/j5ODYnClNnDh3Chwe6e2dMb1M5cNDrHoFfUNpA0jD8l0O9zn2/2Ti/1CDWIe
         RAm0sTtPpO+zCHoF4DkTzlChduYYWcmAo184t+ofiisZ+VFQI6+ILPDGDAx087nD5Mbk
         sPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lLSXyq8geVEgL572mhZwfSsIq9Gg65HnBLRnWd1Y+1U=;
        b=tRIJas4ccmE0Sghnmo1Xp1Up19tLexGsgJ6ZQvFBnxm8w9H7p9pqaLhRCCUnn+iilt
         DCjC8wyBtc0By28AbR39864JLeDjs6thJBeHZkB93J+soPEbzvxtGBDze/6xcPmsY/48
         24gHIw3F1+czobWV6blCmX8Eu3YHVLr5+om09lRlyCvo1rFq+skJ1Wq5NnEOemsHt5os
         n1xnrBXhnQVIuvsVO9pfBPWU5HCblUC3E25YXbkcrRQMA0Q9mXUwyJc3uJE1F5lSIlIo
         iHpEw9mM9weKNUBNN6U1eQB0wxEo2paRuhQ53yisQ/tdNoAJiOQL3RKlb/HKP687fCwP
         JlKQ==
X-Gm-Message-State: AOAM532Wc0s1xvxc5en1dKTXAPYROR1eyBxovBqQIH2AHvI5y8Xzc2nE
        HvGDvjB3EaaO91Dn0EiAJCoHVv8SsWGZjuyUIFLD7A==
X-Google-Smtp-Source: ABdhPJzO4zlEdacKCMEnK6+wlUNgq7IiDijRN/KMpfnHp5dKQDzZ9WVXCEpYJRDB0Op9mL7yirYABbhKaSWz8w+/Rsk=
X-Received: by 2002:a1c:8056:: with SMTP id b83mr5171173wmd.124.1601995343633;
 Tue, 06 Oct 2020 07:42:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com> <20200507140819.126960-24-irogers@google.com>
 <e3c4f253-e1ed-32f6-c252-e8657968fc42@huawei.com> <CAP-5=fXkYQ0ktt5DZYW=PPzgRN4_DeM08_def4Qn-6BPRvKW-A@mail.gmail.com>
 <757974b3-62b0-2822-84fb-1e75907c6cc4@huawei.com> <CAP-5=fXwQZVDxJM4LmEvsKW9h0HYP6t3F0EZfy0+hwAzDmBgGA@mail.gmail.com>
 <248e8d19-8727-b403-4196-59eac1b1f305@huawei.com> <b621fdcb-9af5-bbc2-992a-ebfaa7888dc2@huawei.com>
In-Reply-To: <b621fdcb-9af5-bbc2-992a-ebfaa7888dc2@huawei.com>
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 6 Oct 2020 07:42:11 -0700
Message-ID: <CAP-5=fUy6FOszNRwJF6ZNpqQSSyrnLPV6GbkEcZMqAhUp3X0ZA@mail.gmail.com>
Subject: Re: Issue of metrics for multiple uncore PMUs (was Re: [RFC PATCH v2
 23/23] perf metricgroup: remove duped metric group events)
To:     John Garry <john.garry@huawei.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 7:22 AM John Garry <john.garry@huawei.com> wrote:
>
> On 05/10/2020 19:05, John Garry wrote:
> >> Can you provide a reproduction? Looking on broadwell
> >> this metric doesn't exist.
> >
> > Right, I just added this test metric as my 2x x86 platform has no
> > examples which I can find:
> >
> > diff --git a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> > b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> > index 8cdc7c13dc2a..fc6d9adf996a 100644
> > --- a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> > +++ b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> > @@ -348,5 +348,11 @@
> >          "MetricExpr": "(cstate_pkg@c7\\-residency@ / msr@tsc@) * 100",
> >          "MetricGroup": "Power",
> >          "MetricName": "C7_Pkg_Residency"
> > +    },
> > +    {
> > +        "BriefDescription": "test metric",
> > +        "MetricExpr": "UNC_CBO_XSNP_RESPONSE.MISS_XCORE *
> > UNC_CBO_XSNP_RESPONSE.MISS_EVICTION",
> > +        "MetricGroup": "Test",
> > +        "MetricName": "test_metric_inc"
> >      }
> > ]
> >
>
> It seems that the code in find_evsel_group() does not properly handle
> the scenario of event alias matching different PMUs (as I already said).
>
> So I got it working on top of "perf metricgroup: Fix uncore metric
> expressions" with the following change:
>
> diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> index d948a7f910cf..6293378c019c 100644
> --- a/tools/perf/util/metricgroup.c
> +++ b/tools/perf/util/metricgroup.c
> @@ -213,7 +213,8 @@ static struct evsel *find_evsel_group(struct evlist
> *perf_evlist,
>                 /* Ignore event if already used and merging is disabled. */
>                 if (metric_no_merge && test_bit(ev->idx, evlist_used))
>                         continue;
> -               if (!has_constraint && ev->leader != current_leader) {
> +               if (!has_constraint && (!current_leader ||
> strcmp(current_leader->name, ev->leader->name))) {
>                         /*
>                          * Start of a new group, discard the whole match and
>                          * start again.
> @@ -279,7 +280,8 @@ static struct evsel *find_evsel_group(struct evlist
> *perf_evlist,
>                          * when then group is left.
>                          */
>                         if (!has_constraint &&
> -                           ev->leader != metric_events[i]->leader)
> +                           strcmp(ev->leader->name, metric_events[i]->leader->name))
>                                 break;
>                         if (!strcmp(metric_events[i]->name, ev->name)) {
>                                 set_bit(ev->idx, evlist_used);
>
> which gives for my test metric:
>
> ./perf stat -v -M test_metric_inc sleep 1
> Using CPUID GenuineIntel-6-3D-4
> metric expr unc_cbo_xsnp_response.miss_xcore /
> unc_cbo_xsnp_response.miss_eviction for test_metric_inc
> found event unc_cbo_xsnp_response.miss_eviction
> found event unc_cbo_xsnp_response.miss_xcore
> adding
> {unc_cbo_xsnp_response.miss_eviction,unc_cbo_xsnp_response.miss_xcore}:W
> unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_1/umask=0x81,event=0x22/
> unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_0/umask=0x81,event=0x22/
> unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_1/umask=0x41,event=0x22/
> unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_0/umask=0x41,event=0x22/
> Control descriptor is not initialized
> unc_cbo_xsnp_response.miss_eviction: 595175 1001021311 1001021311
> unc_cbo_xsnp_response.miss_eviction: 592516 1001020037 1001020037
> unc_cbo_xsnp_response.miss_xcore: 39139 1001021311 1001021311
> unc_cbo_xsnp_response.miss_xcore: 38718 1001020037 1001020037
>
> Performance counter stats for 'system wide':
>
>          1,187,691      unc_cbo_xsnp_response.miss_eviction #     0.07
> test_metric_inc
>             77,857      unc_cbo_xsnp_response.miss_xcore
>
>
>        1.001068918 seconds time elapsed
>
> John

Thanks John! I was able to repro the problem, let me investigate what
is happening here as it seems there may be something wrong with the
grouping logic.

Ian
