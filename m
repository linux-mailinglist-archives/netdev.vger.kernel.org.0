Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648E6281D15
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgJBUrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBUrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:47:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C09C0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:47:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so3159254wrm.2
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 13:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uXKKFOeSYPG8al9cOaypQaHiMKPA9xxy17Dd4BLJwvc=;
        b=A+1P4SoTB5U034QG0+WmgfcBxp3U+9PRSZ4IhqevphFs61HqRbCJpodggEf2oyNcwe
         nKsqKkz45QhOTuJHkVnHwUfGyhEvIWJGe+3e5sm1JmMEq3413vQyblzchNBI6/IlNWYf
         NHUXuTRp1W3982IMCnOwSPMzpKWPxIN49Bm2uoG2FHacvx7NnRYSJQrrrc9vtRvnI0ha
         GyAtvSxeVmeQHlhSIMMdFoNBOYgz1S65Iq4nxYfoOeYdky7XN3teDdhWacbWFzf7sx94
         w9OVi4MIOnIXEuefoxj4VIyvaLQ7VzWeI1Nojd7f6TvgoBnWkr6u099aHcuvKGurNLbj
         28Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uXKKFOeSYPG8al9cOaypQaHiMKPA9xxy17Dd4BLJwvc=;
        b=NQ0SmIh35NdRwrMsTXxClVdGa3LcRO1ECRDlsyBa0mEg5x/HzI7yx7r0948C1kYwW/
         9VIvCS12tkjcfrvbLjjHkUyzAtS7D5jqz9y2p1Rzx5UatJpC7D3VN20GjH0zgU+/N0t2
         /i4RYEXSScTAy2+RHsHugNZlu2yALZryxO1RlNl0DZ0mbkf8M1ZcnG4h/BYKSvc8Uobr
         1tYQqMQQDDRxh7FWrO+KF+Ko6TO3cROvTt3UUpOAC2ptcvhUG2JLmwLJ1YJTJ/k4bJuN
         CmlL3zjTFwXuj3qI/riptaZ6uNdo7LlsCDsmuv/bVh53459OR1Ij6qjU6hJ9E3yFLZX4
         JYqQ==
X-Gm-Message-State: AOAM53030dRAkXkN9LWu/5IKmYWIyJfazpegngonrmu1KnTC2yF/LIPC
        Ek/9v+7cuGMJgpPaBPC/F8zrozdAc/+LEbMmJeWvfA==
X-Google-Smtp-Source: ABdhPJwf2MahFXb5roCcSXJw39ZF+8aTZAyovTdB7iZgRUUyATSygYlDICmS5UdszlFwdG4hfktZg+aSXxL6iEJknu8=
X-Received: by 2002:adf:f5c1:: with SMTP id k1mr5271207wrp.271.1601671623743;
 Fri, 02 Oct 2020 13:47:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com> <20200507140819.126960-24-irogers@google.com>
 <e3c4f253-e1ed-32f6-c252-e8657968fc42@huawei.com>
In-Reply-To: <e3c4f253-e1ed-32f6-c252-e8657968fc42@huawei.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 2 Oct 2020 13:46:52 -0700
Message-ID: <CAP-5=fXkYQ0ktt5DZYW=PPzgRN4_DeM08_def4Qn-6BPRvKW-A@mail.gmail.com>
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

On Fri, Oct 2, 2020 at 5:00 AM John Garry <john.garry@huawei.com> wrote:
>
> On 07/05/2020 15:08, Ian Rogers wrote:
>
> Hi Ian,
>
> I was wondering if you ever tested commit 2440689d62e9 ("perf
> metricgroup: Remove duped metric group events") for when we have a
> metric which aliases multiple instances of the same uncore PMU in the
> system?

Sorry for this, I hadn't tested such a metric and wasn't aware of how
the aliasing worked. I sent a fix for this issue here:
https://lore.kernel.org/lkml/20200917201807.4090224-1-irogers@google.com/
Could you see if this addresses the issue for you? I don't see the
change in Arnaldo's trees yet.

Thanks,
Ian

> I have been rebasing some of my arm64 perf work to v5.9-rc7, and find an
> issue where find_evsel_group() fails for the uncore metrics under the
> condition mentioned above.
>
> Unfortunately I don't have an x86 machine to which this test applies.
> However, as an experiment, I added a test metric to my broadwell JSON:
>
> diff --git a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> index 8cdc7c13dc2a..fc6d9adf996a 100644
> --- a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> +++ b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> @@ -348,5 +348,11 @@
>          "MetricExpr": "(cstate_pkg@c7\\-residency@ / msr@tsc@) * 100",
>          "MetricGroup": "Power",
>          "MetricName": "C7_Pkg_Residency"
> +    },
> +    {
> +        "BriefDescription": "test metric",
> +        "MetricExpr": "UNC_CBO_XSNP_RESPONSE.MISS_XCORE *
> UNC_CBO_XSNP_RESPONSE.MISS_EVICTION",
> +        "MetricGroup": "Test",
> +        "MetricName": "test_metric_inc"
>      }
> ]
>
>
> And get this:
>
> john@localhost:~/linux/tools/perf> sudo ./perf stat -v -M
> test_metric_inc sleep 1
> Using CPUID GenuineIntel-6-3D-4
> metric expr unc_cbo_xsnp_response.miss_xcore *
> unc_cbo_xsnp_response.miss_eviction for test_metric_inc
> found event unc_cbo_xsnp_response.miss_eviction
> found event unc_cbo_xsnp_response.miss_xcore
> adding
> {unc_cbo_xsnp_response.miss_eviction,unc_cbo_xsnp_response.miss_xcore}:W
> unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_1/umask=0x81,event=0x22/
> unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_0/umask=0x81,event=0x22/
> unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_1/umask=0x41,event=0x22/
> unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_0/umask=0x41,event=0x22/
> Cannot resolve test_metric_inc: unc_cbo_xsnp_response.miss_xcore *
> unc_cbo_xsnp_response.miss_eviction
> task-clock: 688876 688876 688876
> context-switches: 2 688876 688876
> cpu-migrations: 0 688876 688876
> page-faults: 69 688876 688876
> cycles: 2101719 695690 695690
> instructions: 1180534 695690 695690
> branches: 249450 695690 695690
> branch-misses: 10815 695690 695690
>
> Performance counter stats for 'sleep 1':
>
>               0.69 msec task-clock                #    0.001 CPUs
> utilized
>                  2      context-switches          #    0.003 M/sec
>
>                  0      cpu-migrations            #    0.000 K/sec
>
>                 69      page-faults               #    0.100 M/sec
>
>          2,101,719      cycles                    #    3.051 GHz
>
>          1,180,534      instructions              #    0.56  insn per
> cycle
>            249,450      branches                  #  362.112 M/sec
>
>             10,815      branch-misses             #    4.34% of all
> branches
>
>        1.001177693 seconds time elapsed
>
>        0.001149000 seconds user
>        0.000000000 seconds sys
>
>
> john@localhost:~/linux/tools/perf>
>
>
> Any idea what is going wrong here, before I have to dive in? The issue
> seems to be this named commit.
>
> Thanks,
> John
>
> > A metric group contains multiple metrics. These metrics may use the same
> > events. If metrics use separate events then it leads to more
> > multiplexing and overall metric counts fail to sum to 100%.
> > Modify how metrics are associated with events so that if the events in
> > an earlier group satisfy the current metric, the same events are used.
> > A record of used events is kept and at the end of processing unnecessary
> > events are eliminated.
> >
> > Before:
