Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4261C9911
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEGSPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbgEGSPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:15:30 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D02C05BD0B
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 11:15:30 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o198so3395098ybg.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 11:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oaIQdAQSrUuG0PjDzccQj5s6sYJ/9gT4+ty0xekahqc=;
        b=po+Wm3ERBFyL1E8b2GPs9tSfxPdKUxCgVV+2I37m1TITrtgdbLrBkClkQ2HyukHN3i
         7bJSRnJTM7+VgdxygTNFqXHsGtuFhT670WMa2EhTrykmO7GPwCmu2dg1Ala6adbLTe87
         owohOm5FBq580N9autF9wi/HYw8Yo9eakygpwM8+YbuB4dfYAF0Wg1Ds/ITXbC2G1scu
         ZjdjmWc32QeTZmMIJHzRSEgBC/OErcF7lSYnAcApwNfQaotUbWROzGfJbZHLr1CMJ4tb
         YchOEzEkvQnaslnaBrqWg0iNh304HBILZkgJfk6hnT0d0AfsZpifwjxQEV0N+Nfgup3a
         36ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oaIQdAQSrUuG0PjDzccQj5s6sYJ/9gT4+ty0xekahqc=;
        b=rEIH6OcYGemo70byIM0gWkhPnVUmO3RpesX7RvgPn8zVMgfZ7I6le53z2T7ZHGGgYC
         Ji/Dors8mALxL3BIpN5g3HgAMaacBhNlsnGV6v9n+enDIFqwdVw6Dba8uBAsZ5fxQmvE
         C5gKjj55bFVjn3N21dkIpqSJFgJkg5LDe9vCqLm8L4gFCuok0Yfz4JB+QOxFTR8w+1Z/
         ckpxWQm+WTw1Lc67oNoZljVbRamEi6qzScGBvwO1qs1oKiNmFzLVp2ue11oC1YVh468t
         r1M19KyGa7bwp/kSnhTlGKSX6sBBnQQeu8Rr/KmFhqybIVeeZUGQC3pZ1RzW3CGWEiJ2
         DmXg==
X-Gm-Message-State: AGi0PubSd0q8c/v8AMCsQL/hrET7HWQcjkjI0hEmZvrpZYxLFpNSihCE
        h7/EjZgkWJd5UrAnNwA5RcmDkzLdd6mgOzeJVBD+5A==
X-Google-Smtp-Source: APiQypIlVNflOSSqEkrgqNlBDssSyZHCmarHs+oFWjMPoMv0IZA0TufNW/3XK7F7I1sweL/KIyA2+L0kORuP6a431wU=
X-Received: by 2002:a25:4446:: with SMTP id r67mr3385058yba.41.1588875328749;
 Thu, 07 May 2020 11:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200507081436.49071-1-irogers@google.com> <20200507174835.GB3538@tassilo.jf.intel.com>
In-Reply-To: <20200507174835.GB3538@tassilo.jf.intel.com>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 7 May 2020 11:15:17 -0700
Message-ID: <CAP-5=fUdoGJs+yViq3BOcJa7YyF53AD9RGQm8aRW72nMH0sKDA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
To:     Andi Kleen <ak@linux.intel.com>
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

On Thu, May 7, 2020 at 10:48 AM Andi Kleen <ak@linux.intel.com> wrote:
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
>
> Note this actually may make multiplexing errors worse.
>
> For metrics it is often important that all the input values to
> the metric run at the same time.
>
> So e.g. if you have two metrics and they each fit into a group,
> but not together, even though you have more multiplexing it
> will give more accurate results for each metric.
>
> I think you change can make sense for metrics that don't fit
> into single groups anyways. perf currently doesn't quite know
> this but some heuristic could be added.
>
> But I wouldn't do it for simple metrics that fit into groups.
> The result may well be worse.
>
> My toplev tool has some heuristics for this, also some more
> sophisticated ones that tracks subexpressions. That would
> be far too complicated for perf likely.
>
> -Andi

Thanks Andi!

I was trying to be mindful of the multiplexing issue in the description:

> - without this change events within a metric may get scheduled
>   together, after they may appear as part of a larger group and be
>   multiplexed at different times, lowering accuracy - however, less
>   multiplexing may compensate for this.

I agree the heuristic in this patch set is naive and would welcome to
improve it from your toplev experience. I think this change is
progress on TopDownL1 - would you agree?

I'm wondering if what is needed are flags to control behavior. For
example, avoiding the use of groups altogether. For TopDownL1 I see.

Currently:
    27,294,614,172      idq_uops_not_delivered.core #      0.3
Frontend_Bound           (49.96%)
    24,498,363,923      cycles
               (49.96%)
    21,449,143,854      uops_issued.any           #      0.1
Bad_Speculation          (16.68%)
    16,450,676,961      uops_retired.retire_slots
               (16.68%)
       880,423,103      int_misc.recovery_cycles
               (16.68%)
    24,180,775,568      cycles
               (16.68%)
    27,662,201,567      idq_uops_not_delivered.core #      0.5
Backend_Bound            (16.67%)
    25,354,331,290      cycles
               (16.67%)
    22,642,218,398      uops_issued.any
               (16.67%)
    17,564,211,383      uops_retired.retire_slots
               (16.67%)
       896,938,527      int_misc.recovery_cycles
               (16.67%)
    17,872,454,517      uops_retired.retire_slots #      0.2 Retiring
               (16.68%)
    25,122,100,836      cycles
               (16.68%)
    15,101,167,608      inst_retired.any          #      0.6 IPC
               (33.34%)
    24,977,816,793      cpu_clk_unhalted.thread
               (33.34%)
    24,868,717,684      cycles
                                                  # 99474870736.0
SLOTS               (49.98%)

With proposed (RFC) sharing of events over metrics:
    22,780,823,620      cycles
                                                  # 91123294480.0
SLOTS
                                                  #      0.2 Retiring
                                                  #      0.3
Frontend_Bound
                                                  #      0.1
Bad_Speculation
                                                  #      0.4
Backend_Bound            (50.01%)
    26,097,362,439      idq_uops_not_delivered.core
                 (50.01%)
       790,521,504      int_misc.recovery_cycles
               (50.01%)
    21,025,308,329      uops_issued.any
               (50.01%)
    17,041,506,149      uops_retired.retire_slots
               (50.01%)
    22,964,891,526      cpu_clk_unhalted.thread   #      0.6 IPC
               (49.99%)
    14,531,724,741      inst_retired.any
               (49.99%)

No groups:
     1,517,455,258      cycles
                                                  # 6069821032.0 SLOTS
                                                  #      0.1 Retiring
                                                  #      0.3
Frontend_Bound
                                                  #      0.1
Bad_Speculation
                                                  #      0.5
Backend_Bound            (85.64%)
     1,943,047,724      idq_uops_not_delivered.core
                 (85.61%)
        54,257,713      int_misc.recovery_cycles
               (85.63%)
     1,050,787,137      uops_issued.any
               (85.63%)
       881,310,530      uops_retired.retire_slots
               (85.68%)
     1,553,561,836      cpu_clk_unhalted.thread   #      0.5 IPC
               (71.81%)
       742,087,439      inst_retired.any
               (85.85%)

So with no groups there is a lot less multiplexing.

So I'm thinking of two flags:
 - disable sharing of events between metrics - defaulted off - this
keeps the current behavior in case there is a use-case where
multiplexing is detrimental. I'm not sure how necessary this flag is,
if we could quantify it based on experience elsewhere it'd be nice.
Default off as without sharing metrics within a metric group fail to
add to 100%. Fwiw, I can imagine phony metrics that exist just to
cause sharing of events within a group.
 - disable grouping of events in metrics - defaulted off - this would
change the behavior of groups like TopDownL1 as I show above for "no
groups".

I see in toplev:
https://github.com/andikleen/pmu-tools/wiki/toplev-manual
--no-group which is similar to the second flag.
Do you have any pointers in toplev for better grouping heuristics?

Thoughts and better ways to do this very much appreciated! Thanks,

Ian
