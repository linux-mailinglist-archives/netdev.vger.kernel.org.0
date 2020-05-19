Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52E31DA074
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgESTGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:06:08 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06414C08C5C0;
        Tue, 19 May 2020 12:06:07 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z80so820931qka.0;
        Tue, 19 May 2020 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wPeWB2uZZlMXrat1KPGYz49Pg/cmaGt0tVfETslJ1hE=;
        b=O8qflmVACVLkpRT1Rl6i3K9s8LXuvR4+Ee5DJTsd2DlGoHKSd5zgp5PWNhz1qSob8f
         HW6YyMMSW9hw1zF+j7M6F5IK7GDquIqG7lilHEbZbnaZN4+NJN7Yvvh+nl7Ia4uRieXX
         IEBo2iV+Plpn2M885mp15KaB/LWPdw3r93nVqyZix0e3NToilJGe5Zg+YBzCJPH+lM4c
         M2LAvH3jlsCeoDpshd3YmHXUjvZIVt0HQ5BI5cfcCZoRitgBDRpXjZAd9j7DgHK2186L
         nhasYde8ypE+eBXrnxaDQKLwQafSsWsiD9q4OwDS87kqMebulgERrhmc6/MdlWwKPi45
         5ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wPeWB2uZZlMXrat1KPGYz49Pg/cmaGt0tVfETslJ1hE=;
        b=WBFqTk74yPjuW6c9LPX8tmZZIjUKdLV2OIRuXgZeRZEV5vbt0g48tLSb3EEESRjiox
         lHwbH9thJYspfHlsKupchB5v6y8M4I7+21wEKzMddwyINM9bDJzydk9xH6Op/JSCrmNB
         tMLUzSwPIcVfQE/VFHUgevcBn/3u024+g0QTZnSVBGGxV6tgIvNLmvltH5QwWiWMQJIt
         +d7lk0BxD57PpgCEJLBTjBWWGpGrOj9B1CL2EadXoT/Dyk5sXhfyJaQl0httzkIhi4lq
         I1zeTxzXIm4QTYX61Wv85QHMR5rJtix4kyj6nKMiUfCA4GgSB0sAGocF2wLqAA6ZTGm+
         LREg==
X-Gm-Message-State: AOAM533CdnjMinI85eWUiqlBaxTJC4Wz2Cao98Yy7c2v09T8UMqJ/hvn
        QkMNH3AXRm/GMsCFn4YVjds=
X-Google-Smtp-Source: ABdhPJw/WgXp3coDEPG/OCJLk9DoCE4w7l1xw4atsB/8gnBZGGTf8rViGg26ZMBCSFPK4FGowseRtA==
X-Received: by 2002:a05:620a:a53:: with SMTP id j19mr940312qka.183.1589915166969;
        Tue, 19 May 2020 12:06:06 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id q54sm488669qtj.38.2020.05.19.12.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 12:06:06 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 021AD40AFD; Tue, 19 May 2020 16:06:02 -0300 (-03)
Date:   Tue, 19 May 2020 16:06:02 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Paul Clarke <pc@us.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v3 6/7] perf test: Improve pmu event metric testing
Message-ID: <20200519190602.GB28228@kernel.org>
References: <20200515221732.44078-1-irogers@google.com>
 <20200515221732.44078-7-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515221732.44078-7-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 15, 2020 at 03:17:31PM -0700, Ian Rogers escreveu:
> Break pmu-events test into 2 and add a test to verify that all pmu
> metric expressions simply parse. Try to parse all metric ids/events,
> skip/warn if metrics for the current architecture fail to parse. To
> support warning for a skip, and an ability for a subtest to describe why
> it skips.
> 
> Tested on power9, skylakex, haswell, broadwell, westmere, sandybridge and
> ivybridge.
> 
> May skip/warn on other architectures if metrics are invalid. In
> particular s390 is untested, but its expressions are trivial. The
> untested architectures with expressions are power8, cascadelakex,
> tremontx, skylake, jaketown, ivytown and variants of haswell and
> broadwell.
> 
> v3. addresses review comments from John Garry <john.garry@huawei.com>,
> Jiri Olsa <jolsa@redhat.com> and Arnaldo Carvalho de Melo
> <acme@kernel.org>.
> v2. changes the commit message as event parsing errors no longer cause
> the test to fail.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Jin Yao <yao.jin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Kajol Jain <kjain@linux.ibm.com>
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Clarke <pc@us.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lore.kernel.org/lkml/20200513212933.41273-1-irogers@google.com
> [ split from a larger patch ]
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/tests/builtin-test.c |   7 ++
>  tools/perf/tests/pmu-events.c   | 168 ++++++++++++++++++++++++++++++--
>  tools/perf/tests/tests.h        |   3 +
>  3 files changed, 172 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
> index baee735e6aa5..9553f8061772 100644
> --- a/tools/perf/tests/builtin-test.c
> +++ b/tools/perf/tests/builtin-test.c
> @@ -75,6 +75,13 @@ static struct test generic_tests[] = {
>  	{
>  		.desc = "PMU events",
>  		.func = test__pmu_events,
> +		.subtest = {
> +			.skip_if_fail	= false,
> +			.get_nr		= test__pmu_events_subtest_get_nr,
> +			.get_desc	= test__pmu_events_subtest_get_desc,
> +			.skip_reason	= test__pmu_events_subtest_skip_reason,
> +		},
> +
>  	},
>  	{
>  		.desc = "DSO data read",
> diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
> index d64261da8bf7..e21f0addcfbb 100644
> --- a/tools/perf/tests/pmu-events.c
> +++ b/tools/perf/tests/pmu-events.c
> @@ -8,6 +8,9 @@
>  #include <linux/zalloc.h>
>  #include "debug.h"
>  #include "../pmu-events/pmu-events.h"
> +#include "util/evlist.h"
> +#include "util/expr.h"
> +#include "util/parse-events.h"
>  
>  struct perf_pmu_test_event {
>  	struct pmu_event event;
> @@ -144,7 +147,7 @@ static struct pmu_events_map *__test_pmu_get_events_map(void)
>  }
>  
>  /* Verify generated events from pmu-events.c is as expected */
> -static int __test_pmu_event_table(void)
> +static int test_pmu_event_table(void)
>  {
>  	struct pmu_events_map *map = __test_pmu_get_events_map();
>  	struct pmu_event *table;
> @@ -347,14 +350,11 @@ static int __test__pmu_event_aliases(char *pmu_name, int *count)
>  	return res;
>  }
>  
> -int test__pmu_events(struct test *test __maybe_unused,
> -		     int subtest __maybe_unused)
> +
> +static int test_aliases(void)
>  {
>  	struct perf_pmu *pmu = NULL;
>  
> -	if (__test_pmu_event_table())
> -		return -1;
> -
>  	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
>  		int count = 0;
>  
> @@ -377,3 +377,159 @@ int test__pmu_events(struct test *test __maybe_unused,
>  
>  	return 0;
>  }
> +
> +static bool is_number(const char *str)
> +{
> +	char *end_ptr;
> +
> +	strtod(str, &end_ptr);
> +	return end_ptr != str;
> +}

So, this breaks in some systems:

cc1: warnings being treated as errors
tests/pmu-events.c: In function 'is_number':
tests/pmu-events.c:385: error: ignoring return value of 'strtod', declared with attribute warn_unused_result
mv: cannot stat `/tmp/build/perf/tests/.pmu-events.o.tmp': No such file or director

So I'm changing it to verify the result of strtod() which is, humm,
interesting, please check:

diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index 3de59564deb0..6c58c3a89e6b 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include "math.h"
 #include "parse-events.h"
 #include "pmu.h"
 #include "tests.h"
@@ -381,8 +382,12 @@ static int test_aliases(void)
 static bool is_number(const char *str)
 {
 	char *end_ptr;
+	double v;
 
-	strtod(str, &end_ptr);
+	errno = 0;
+	v = strtod(str, &end_ptr);
+	if ((errno == ERANGE && (v == HUGE_VAL || v == -HUGE_VAL)) || (errno != 0 && v == 0.0))
+		return false;
 	return end_ptr != str;
 }
 
