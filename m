Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E700284D84
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgJFOWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:22:21 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2960 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbgJFOWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:22:20 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 44BB4C97F0EE94ABF5FB;
        Tue,  6 Oct 2020 15:22:18 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.159) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 6 Oct 2020
 15:22:16 +0100
Subject: Re: Issue of metrics for multiple uncore PMUs (was Re: [RFC PATCH v2
 23/23] perf metricgroup: remove duped metric group events)
From:   John Garry <john.garry@huawei.com>
To:     Ian Rogers <irogers@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
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
References: <20200507140819.126960-1-irogers@google.com>
 <20200507140819.126960-24-irogers@google.com>
 <e3c4f253-e1ed-32f6-c252-e8657968fc42@huawei.com>
 <CAP-5=fXkYQ0ktt5DZYW=PPzgRN4_DeM08_def4Qn-6BPRvKW-A@mail.gmail.com>
 <757974b3-62b0-2822-84fb-1e75907c6cc4@huawei.com>
 <CAP-5=fXwQZVDxJM4LmEvsKW9h0HYP6t3F0EZfy0+hwAzDmBgGA@mail.gmail.com>
 <248e8d19-8727-b403-4196-59eac1b1f305@huawei.com>
Message-ID: <b621fdcb-9af5-bbc2-992a-ebfaa7888dc2@huawei.com>
Date:   Tue, 6 Oct 2020 15:19:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <248e8d19-8727-b403-4196-59eac1b1f305@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.170.159]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2020 19:05, John Garry wrote:
>> Can you provide a reproduction? Looking on broadwell
>> this metric doesn't exist.
> 
> Right, I just added this test metric as my 2x x86 platform has no 
> examples which I can find:
> 
> diff --git a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json 
> b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> index 8cdc7c13dc2a..fc6d9adf996a 100644
> --- a/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> +++ b/tools/perf/pmu-events/arch/x86/broadwell/bdw-metrics.json
> @@ -348,5 +348,11 @@
>          "MetricExpr": "(cstate_pkg@c7\\-residency@ / msr@tsc@) * 100",
>          "MetricGroup": "Power",
>          "MetricName": "C7_Pkg_Residency"
> +    },
> +    {
> +        "BriefDescription": "test metric",
> +        "MetricExpr": "UNC_CBO_XSNP_RESPONSE.MISS_XCORE * 
> UNC_CBO_XSNP_RESPONSE.MISS_EVICTION",
> +        "MetricGroup": "Test",
> +        "MetricName": "test_metric_inc"
>      }
> ]
> 

It seems that the code in find_evsel_group() does not properly handle 
the scenario of event alias matching different PMUs (as I already said).

So I got it working on top of "perf metricgroup: Fix uncore metric 
expressions" with the following change:

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index d948a7f910cf..6293378c019c 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -213,7 +213,8 @@ static struct evsel *find_evsel_group(struct evlist 
*perf_evlist,
  		/* Ignore event if already used and merging is disabled. */
  		if (metric_no_merge && test_bit(ev->idx, evlist_used))
  			continue;
-		if (!has_constraint && ev->leader != current_leader) {
+		if (!has_constraint && (!current_leader || 
strcmp(current_leader->name, ev->leader->name))) {
  			/*
  			 * Start of a new group, discard the whole match and
  			 * start again.
@@ -279,7 +280,8 @@ static struct evsel *find_evsel_group(struct evlist 
*perf_evlist,
  			 * when then group is left.
  			 */
  			if (!has_constraint &&
-			    ev->leader != metric_events[i]->leader)
+			    strcmp(ev->leader->name, metric_events[i]->leader->name))
  				break;
  			if (!strcmp(metric_events[i]->name, ev->name)) {
  				set_bit(ev->idx, evlist_used);

which gives for my test metric:

./perf stat -v -M test_metric_inc sleep 1
Using CPUID GenuineIntel-6-3D-4
metric expr unc_cbo_xsnp_response.miss_xcore / 
unc_cbo_xsnp_response.miss_eviction for test_metric_inc
found event unc_cbo_xsnp_response.miss_eviction
found event unc_cbo_xsnp_response.miss_xcore
adding 
{unc_cbo_xsnp_response.miss_eviction,unc_cbo_xsnp_response.miss_xcore}:W
unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_1/umask=0x81,event=0x22/
unc_cbo_xsnp_response.miss_eviction -> uncore_cbox_0/umask=0x81,event=0x22/
unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_1/umask=0x41,event=0x22/
unc_cbo_xsnp_response.miss_xcore -> uncore_cbox_0/umask=0x41,event=0x22/
Control descriptor is not initialized
unc_cbo_xsnp_response.miss_eviction: 595175 1001021311 1001021311
unc_cbo_xsnp_response.miss_eviction: 592516 1001020037 1001020037
unc_cbo_xsnp_response.miss_xcore: 39139 1001021311 1001021311
unc_cbo_xsnp_response.miss_xcore: 38718 1001020037 1001020037

Performance counter stats for 'system wide':

         1,187,691      unc_cbo_xsnp_response.miss_eviction #     0.07 
test_metric_inc
            77,857      unc_cbo_xsnp_response.miss_xcore 


       1.001068918 seconds time elapsed

John
