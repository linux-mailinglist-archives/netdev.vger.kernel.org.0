Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573F21CBBE9
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgEIAjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:39:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:33453 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbgEIAjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:39:36 -0400
IronPort-SDR: DlQMED5PG9/bApDPWXnAQZii1JMGNLkksb9dutMsp9aAvxTSLhu+K938jkr+SPv/qwnT5WZbhz
 K/fdGjAqQbHg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 17:39:36 -0700
IronPort-SDR: 6aweANgd2jw2UYAToWycQaYabf94KOq5DMw032Ic41kd5k9VQ+8qWBslqeA2e+rQP9mkAtPpOO
 rZTAf/sMRpTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="435967229"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga005.jf.intel.com with ESMTP; 08 May 2020 17:39:36 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 177F9301C4C; Fri,  8 May 2020 17:39:36 -0700 (PDT)
Date:   Fri, 8 May 2020 17:39:36 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Ian Rogers <irogers@google.com>
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH v3 06/14] perf evsel: fix 2 memory leaks
Message-ID: <20200509003936.GH3538@tassilo.jf.intel.com>
References: <20200508053629.210324-1-irogers@google.com>
 <20200508053629.210324-7-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508053629.210324-7-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 10:36:21PM -0700, Ian Rogers wrote:
> If allocated, perf_pkg_mask and metric_events need freeing.

All these patches at the beginning look like straight forward
bug fixes and are really independent of the new features.

For them

Reviewed-by: Andi Kleen <ak@linux.intel.com>

> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/evsel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 28683b0eb738..05bb46baad6a 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1263,6 +1263,8 @@ void evsel__exit(struct evsel *evsel)
>  	zfree(&evsel->group_name);
>  	zfree(&evsel->name);
>  	zfree(&evsel->pmu_name);
> +	zfree(&evsel->per_pkg_mask);
> +	zfree(&evsel->metric_events);
>  	perf_evsel__object.fini(evsel);
>  }
>  
> -- 
> 2.26.2.645.ge9eca65c58-goog
> 
