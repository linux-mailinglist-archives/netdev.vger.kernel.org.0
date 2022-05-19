Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1324752CA4A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiESDVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbiESDUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:20:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD1DD9EAA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:20:23 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f4dfd09d7fso36283897b3.0
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zOPOwprRKTfkv2cXPwTUV+M8mGP7sAVRSfOVmHTlIYc=;
        b=WgulU1MbbPm1ebPPVzee939RrLS/wfdClBy6WBsf9AxICbC5Jn4XjlZn2jzTFpNpCt
         cA1TFPFpox6xAhSvd2pr2XEpxu+K5vMcfO471UGnyxPePEvaDERSfh+RSH8uolfL4XN1
         9ROqphMUPAw44LRD7MTSe+0oUcTe8FJrSqLGkhYJY2xh30dCJnUNpzxU1q+uv81GirGh
         V3QH3DRXWAd1GenJoyU54JsP8CHQfayRQyyvyTKb7W/+a5lrSYHTm830EF/Av3Ob4u4j
         VvQQ7p5q0HdTP/gcguhnhukM3bfWOVBjwoyVJrGIXLqO8vRMtVmNEwjcEaRq6Yb5GAW2
         dGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zOPOwprRKTfkv2cXPwTUV+M8mGP7sAVRSfOVmHTlIYc=;
        b=c4JrFGW96sR8RsbHWdXjV9eAaVJQLJZB2c7E1A8A6AV+gq/XiSD5IEHFxZ0fAdMMJN
         sYazunOD95HIyEEblhFOYqORD4D/66ms2r4wns/ToZKjGOhwx0CRAU8WcX1hwKY3TIt5
         sBxAbjwxEog8L4mXj0bUsL1RJwOfWgi4ypISlZY3UAufIRgCdnCI/T4Ha4bZ/rXlbrss
         GmxtObXXdmfJoXJk7DCRyeGBSXgM/dTYwTWyVw8OPf+2Wh0MX4z07qjRSoU8NkMGMl6p
         q/SYwQUHkCsC3c4CLQQuNdFlgT5fmKbNOuI6KLwdJHNIi9vaGsyI1C0SsiNXgRcCIEKM
         pvMg==
X-Gm-Message-State: AOAM5319KkoBLwNjOfTS/WOxef7idnYltxFJy4O2upM7v8PTW1sDYeY+
        XnijopyHnnAM3j3Hw+M/2cnxPOUrVVFA
X-Google-Smtp-Source: ABdhPJy7PWcWfvRRE3C2+0YljTgf2w/TKm+iAAXYj/ISK6hEj7VzZa35KP78WgH+HVtPpjpMIzDkfvY/bJ53
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:a233:bf3c:6ac:2a98])
 (user=irogers job=sendgmr) by 2002:a81:dd07:0:b0:2eb:f701:286e with SMTP id
 e7-20020a81dd07000000b002ebf701286emr2483795ywn.341.1652930422878; Wed, 18
 May 2022 20:20:22 -0700 (PDT)
Date:   Wed, 18 May 2022 20:20:05 -0700
In-Reply-To: <20220519032005.1273691-1-irogers@google.com>
Message-Id: <20220519032005.1273691-6-irogers@google.com>
Mime-Version: 1.0
References: <20220519032005.1273691-1-irogers@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 5/5] perf stat: Make use of index clearer with perf_counts
From:   Ian Rogers <irogers@google.com>
To:     Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        James Clark <james.clark@arm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Try to disambiguate further when perf_counts is being accessed it is
with a cpu map index rather than a CPU.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/stat-display.c | 22 ++++++++++++----------
 tools/perf/util/stat.c         | 10 ++++------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 98669ca5a86b..606f09b09226 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -764,11 +764,11 @@ static int cmp_val(const void *a, const void *b)
 
 static struct perf_aggr_thread_value *sort_aggr_thread(
 					struct evsel *counter,
-					int nthreads, int ncpus,
 					int *ret,
 					struct target *_target)
 {
-	int cpu, thread, i = 0;
+	int nthreads = perf_thread_map__nr(counter->core.threads);
+	int i = 0;
 	double uval;
 	struct perf_aggr_thread_value *buf;
 
@@ -776,13 +776,17 @@ static struct perf_aggr_thread_value *sort_aggr_thread(
 	if (!buf)
 		return NULL;
 
-	for (thread = 0; thread < nthreads; thread++) {
+	for (int thread = 0; thread < nthreads; thread++) {
+		int idx;
 		u64 ena = 0, run = 0, val = 0;
 
-		for (cpu = 0; cpu < ncpus; cpu++) {
-			val += perf_counts(counter->counts, cpu, thread)->val;
-			ena += perf_counts(counter->counts, cpu, thread)->ena;
-			run += perf_counts(counter->counts, cpu, thread)->run;
+		perf_cpu_map__for_each_idx(idx, evsel__cpus(counter)) {
+			struct perf_counts_values *counts =
+				perf_counts(counter->counts, idx, thread);
+
+			val += counts->val;
+			ena += counts->ena;
+			run += counts->run;
 		}
 
 		uval = val * counter->scale;
@@ -817,13 +821,11 @@ static void print_aggr_thread(struct perf_stat_config *config,
 			      struct evsel *counter, char *prefix)
 {
 	FILE *output = config->output;
-	int nthreads = perf_thread_map__nr(counter->core.threads);
-	int ncpus = perf_cpu_map__nr(counter->core.cpus);
 	int thread, sorted_threads;
 	struct aggr_cpu_id id;
 	struct perf_aggr_thread_value *buf;
 
-	buf = sort_aggr_thread(counter, nthreads, ncpus, &sorted_threads, _target);
+	buf = sort_aggr_thread(counter, &sorted_threads, _target);
 	if (!buf) {
 		perror("cannot sort aggr thread");
 		return;
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
index a77c28232298..37ea2d044708 100644
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -237,14 +237,12 @@ void evlist__reset_prev_raw_counts(struct evlist *evlist)
 
 static void evsel__copy_prev_raw_counts(struct evsel *evsel)
 {
-	int ncpus = evsel__nr_cpus(evsel);
-	int nthreads = perf_thread_map__nr(evsel->core.threads);
+	int idx, nthreads = perf_thread_map__nr(evsel->core.threads);
 
 	for (int thread = 0; thread < nthreads; thread++) {
-		for (int cpu = 0; cpu < ncpus; cpu++) {
-			*perf_counts(evsel->counts, cpu, thread) =
-				*perf_counts(evsel->prev_raw_counts, cpu,
-					     thread);
+		perf_cpu_map__for_each_idx(idx, evsel__cpus(evsel)) {
+			*perf_counts(evsel->counts, idx, thread) =
+				*perf_counts(evsel->prev_raw_counts, idx, thread);
 		}
 	}
 
-- 
2.36.1.124.g0e6072fb45-goog

