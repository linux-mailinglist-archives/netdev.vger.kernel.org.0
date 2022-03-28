Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC694E8E12
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbiC1G0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238408AbiC1G0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:26:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788124EA25
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b11-20020a5b008b000000b00624ea481d55so10185369ybp.19
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DsGPUblhs6jgawOdjH7k+Ssh4HZcDt3nLqv+p577Wb4=;
        b=eZkm6L1DipR0tE3RTEJnRvsu3BnrSNidljK1XHaeA1XZ7JoUtJVffDmKKyYFYMJ4q8
         IMopLcE2U2i0992lngXzYSGXe6rnWUymiRAwLvtxkrZZMZU1Z3A95aWH3MwyJjkfR3G/
         KK3gqHF3T/9D3JY7BHVMdVbcoS2Oc4MBQ1PsJi4B4DoSs3ihMyQQm8oSXErEuoW+HteF
         N26U7EhKemq0BdhbuNKe9mnvjOB3aguR9owFwNZS92XIL2Y1nIM+kcydC7ymw6Hl+psr
         Rag0fbB1VvMsEDiIGoyvseywMY9Y246EXCzwcUcYHEj2zSNoqLjSaM4lK2xKBRHw3gOY
         BgHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DsGPUblhs6jgawOdjH7k+Ssh4HZcDt3nLqv+p577Wb4=;
        b=ZVcWJd2LXwnGYVnthiBvdSlyBt2/2NXEolZ/ZpOFWIqSn80k9pvFbK+CQkvmdo5V7m
         YySe7EtMQJEUduTSUpSD0NtVlsolNHjnTpkgBG4HL5eaoWRPD5+uuZzcTLbFJuooNI3C
         K2IuIZIk1Wwu/3igpE/sYBswccX5aPDHCYqXu5kGHPQsTxej1ndvi3+56OXSW6NgAdmi
         +uET7Z3kLL2flzBwd7aeRqVjNl50V7JChX+El+wz4D0E82XMT5ghrtRmlsogPLewNAYk
         SwYcS1X0QfLQVU6Ho2/5fLc98Ggx+Rr0Kj44CgSFKmf7VunPCzwydfUlSIc0ZU2y76PV
         9WZg==
X-Gm-Message-State: AOAM5329B9Jrcc+7kWvoqoO29RkFiinN8DInoITwwv/qH53TUMuZBODP
        0hbmZl6eYb0OYMYWSEwDJZwamaymzH5K
X-Google-Smtp-Source: ABdhPJw73Kv3NBNNWXSKzmHSm18phLJ3zwJLTRUyYZoaRW3OKqDL8lGu6vLpWujhaO3V7sYsTlpJnGyuxuiM
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:ef08:ed1b:261f:77fa])
 (user=irogers job=sendgmr) by 2002:a25:a541:0:b0:628:75d5:1982 with SMTP id
 h59-20020a25a541000000b0062875d51982mr20773011ybi.520.1648448663656; Sun, 27
 Mar 2022 23:24:23 -0700 (PDT)
Date:   Sun, 27 Mar 2022 23:24:10 -0700
In-Reply-To: <20220328062414.1893550-1-irogers@google.com>
Message-Id: <20220328062414.1893550-2-irogers@google.com>
Mime-Version: 1.0
References: <20220328062414.1893550-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 1/5] perf evlist: Rename cpus to user_cpus
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

evlist contains cpus and all_cpus. all_cpus is the union of the cpu maps
of all evsels. cpus is set to be cpus required from the command line,
defaulting to all online cpus if no cpus are specified. For something
like an uncore event, all_cpus may just be CPU 0, however, all_cpus may
be every online CPU. This causes all_cpus to have fewer values than the
cpus variable which is confusing given the 'all' in the name. To try to
make the behavior clearer, rename cpus to user_cpus and add comments on
the two struct variables.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/perf/evlist.c                  | 28 ++++++++++++------------
 tools/lib/perf/include/internal/evlist.h |  4 +++-
 tools/perf/arch/arm/util/cs-etm.c        |  8 +++----
 tools/perf/arch/arm64/util/arm-spe.c     |  2 +-
 tools/perf/arch/x86/util/intel-bts.c     |  2 +-
 tools/perf/arch/x86/util/intel-pt.c      |  4 ++--
 tools/perf/bench/evlist-open-close.c     |  2 +-
 tools/perf/builtin-ftrace.c              |  2 +-
 tools/perf/builtin-record.c              |  6 ++---
 tools/perf/builtin-stat.c                |  8 +++----
 tools/perf/builtin-top.c                 |  2 +-
 tools/perf/util/auxtrace.c               |  2 +-
 tools/perf/util/bpf_ftrace.c             |  4 ++--
 tools/perf/util/evlist.c                 | 14 ++++++------
 tools/perf/util/record.c                 |  6 ++---
 tools/perf/util/sideband_evlist.c        |  2 +-
 tools/perf/util/stat-display.c           |  2 +-
 tools/perf/util/synthetic-events.c       |  2 +-
 tools/perf/util/top.c                    |  7 +++---
 19 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index 9a770bfdc804..e29dc229768a 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -41,10 +41,10 @@ static void __perf_evlist__propagate_maps(struct perf_evlist *evlist,
 	 */
 	if (!evsel->own_cpus || evlist->has_user_cpus) {
 		perf_cpu_map__put(evsel->cpus);
-		evsel->cpus = perf_cpu_map__get(evlist->cpus);
-	} else if (!evsel->system_wide && perf_cpu_map__empty(evlist->cpus)) {
+		evsel->cpus = perf_cpu_map__get(evlist->user_cpus);
+	} else if (!evsel->system_wide && perf_cpu_map__empty(evlist->user_cpus)) {
 		perf_cpu_map__put(evsel->cpus);
-		evsel->cpus = perf_cpu_map__get(evlist->cpus);
+		evsel->cpus = perf_cpu_map__get(evlist->user_cpus);
 	} else if (evsel->cpus != evsel->own_cpus) {
 		perf_cpu_map__put(evsel->cpus);
 		evsel->cpus = perf_cpu_map__get(evsel->own_cpus);
@@ -123,10 +123,10 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
-	perf_cpu_map__put(evlist->cpus);
+	perf_cpu_map__put(evlist->user_cpus);
 	perf_cpu_map__put(evlist->all_cpus);
 	perf_thread_map__put(evlist->threads);
-	evlist->cpus = NULL;
+	evlist->user_cpus = NULL;
 	evlist->all_cpus = NULL;
 	evlist->threads = NULL;
 	fdarray__exit(&evlist->pollfd);
@@ -155,9 +155,9 @@ void perf_evlist__set_maps(struct perf_evlist *evlist,
 	 * original reference count of 1.  If that is not the case it is up to
 	 * the caller to increase the reference count.
 	 */
-	if (cpus != evlist->cpus) {
-		perf_cpu_map__put(evlist->cpus);
-		evlist->cpus = perf_cpu_map__get(cpus);
+	if (cpus != evlist->user_cpus) {
+		perf_cpu_map__put(evlist->user_cpus);
+		evlist->user_cpus = perf_cpu_map__get(cpus);
 	}
 
 	if (threads != evlist->threads) {
@@ -294,7 +294,7 @@ int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
-	int nr_cpus = perf_cpu_map__nr(evlist->cpus);
+	int nr_cpus = perf_cpu_map__nr(evlist->user_cpus);
 	int nr_threads = perf_thread_map__nr(evlist->threads);
 	int nfds = 0;
 	struct perf_evsel *evsel;
@@ -426,7 +426,7 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 	       int idx, struct perf_mmap_param *mp, int cpu_idx,
 	       int thread, int *_output, int *_output_overwrite)
 {
-	struct perf_cpu evlist_cpu = perf_cpu_map__cpu(evlist->cpus, cpu_idx);
+	struct perf_cpu evlist_cpu = perf_cpu_map__cpu(evlist->user_cpus, cpu_idx);
 	struct perf_evsel *evsel;
 	int revent;
 
@@ -536,7 +536,7 @@ mmap_per_cpu(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 	     struct perf_mmap_param *mp)
 {
 	int nr_threads = perf_thread_map__nr(evlist->threads);
-	int nr_cpus    = perf_cpu_map__nr(evlist->cpus);
+	int nr_cpus    = perf_cpu_map__nr(evlist->user_cpus);
 	int cpu, thread;
 
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
@@ -564,8 +564,8 @@ static int perf_evlist__nr_mmaps(struct perf_evlist *evlist)
 {
 	int nr_mmaps;
 
-	nr_mmaps = perf_cpu_map__nr(evlist->cpus);
-	if (perf_cpu_map__empty(evlist->cpus))
+	nr_mmaps = perf_cpu_map__nr(evlist->user_cpus);
+	if (perf_cpu_map__empty(evlist->user_cpus))
 		nr_mmaps = perf_thread_map__nr(evlist->threads);
 
 	return nr_mmaps;
@@ -576,7 +576,7 @@ int perf_evlist__mmap_ops(struct perf_evlist *evlist,
 			  struct perf_mmap_param *mp)
 {
 	struct perf_evsel *evsel;
-	const struct perf_cpu_map *cpus = evlist->cpus;
+	const struct perf_cpu_map *cpus = evlist->user_cpus;
 	const struct perf_thread_map *threads = evlist->threads;
 
 	if (!ops || !ops->get || !ops->mmap)
diff --git a/tools/lib/perf/include/internal/evlist.h b/tools/lib/perf/include/internal/evlist.h
index 4cefade540bd..5f95672662ae 100644
--- a/tools/lib/perf/include/internal/evlist.h
+++ b/tools/lib/perf/include/internal/evlist.h
@@ -19,7 +19,9 @@ struct perf_evlist {
 	int			 nr_entries;
 	int			 nr_groups;
 	bool			 has_user_cpus;
-	struct perf_cpu_map	*cpus;
+	/** The list of cpus passed from the command line. */
+	struct perf_cpu_map	*user_cpus;
+	/** The union of all evsel cpu maps. */
 	struct perf_cpu_map	*all_cpus;
 	struct perf_thread_map	*threads;
 	int			 nr_mmaps;
diff --git a/tools/perf/arch/arm/util/cs-etm.c b/tools/perf/arch/arm/util/cs-etm.c
index cbc555245959..405d58903d84 100644
--- a/tools/perf/arch/arm/util/cs-etm.c
+++ b/tools/perf/arch/arm/util/cs-etm.c
@@ -199,7 +199,7 @@ static int cs_etm_set_option(struct auxtrace_record *itr,
 			     struct evsel *evsel, u32 option)
 {
 	int i, err = -EINVAL;
-	struct perf_cpu_map *event_cpus = evsel->evlist->core.cpus;
+	struct perf_cpu_map *event_cpus = evsel->evlist->core.user_cpus;
 	struct perf_cpu_map *online_cpus = perf_cpu_map__new(NULL);
 
 	/* Set option of each CPU we have */
@@ -299,7 +299,7 @@ static int cs_etm_recording_options(struct auxtrace_record *itr,
 				container_of(itr, struct cs_etm_recording, itr);
 	struct perf_pmu *cs_etm_pmu = ptr->cs_etm_pmu;
 	struct evsel *evsel, *cs_etm_evsel = NULL;
-	struct perf_cpu_map *cpus = evlist->core.cpus;
+	struct perf_cpu_map *cpus = evlist->core.user_cpus;
 	bool privileged = perf_event_paranoid_check(-1);
 	int err = 0;
 
@@ -522,7 +522,7 @@ cs_etm_info_priv_size(struct auxtrace_record *itr __maybe_unused,
 {
 	int i;
 	int etmv3 = 0, etmv4 = 0, ete = 0;
-	struct perf_cpu_map *event_cpus = evlist->core.cpus;
+	struct perf_cpu_map *event_cpus = evlist->core.user_cpus;
 	struct perf_cpu_map *online_cpus = perf_cpu_map__new(NULL);
 
 	/* cpu map is not empty, we have specific CPUs to work with */
@@ -713,7 +713,7 @@ static int cs_etm_info_fill(struct auxtrace_record *itr,
 	u32 offset;
 	u64 nr_cpu, type;
 	struct perf_cpu_map *cpu_map;
-	struct perf_cpu_map *event_cpus = session->evlist->core.cpus;
+	struct perf_cpu_map *event_cpus = session->evlist->core.user_cpus;
 	struct perf_cpu_map *online_cpus = perf_cpu_map__new(NULL);
 	struct cs_etm_recording *ptr =
 			container_of(itr, struct cs_etm_recording, itr);
diff --git a/tools/perf/arch/arm64/util/arm-spe.c b/tools/perf/arch/arm64/util/arm-spe.c
index 5860bbaea95a..83ad05613321 100644
--- a/tools/perf/arch/arm64/util/arm-spe.c
+++ b/tools/perf/arch/arm64/util/arm-spe.c
@@ -144,7 +144,7 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
 			container_of(itr, struct arm_spe_recording, itr);
 	struct perf_pmu *arm_spe_pmu = sper->arm_spe_pmu;
 	struct evsel *evsel, *arm_spe_evsel = NULL;
-	struct perf_cpu_map *cpus = evlist->core.cpus;
+	struct perf_cpu_map *cpus = evlist->core.user_cpus;
 	bool privileged = perf_event_paranoid_check(-1);
 	struct evsel *tracking_evsel;
 	int err;
diff --git a/tools/perf/arch/x86/util/intel-bts.c b/tools/perf/arch/x86/util/intel-bts.c
index 4a76d49d25d6..c9d73ecfd795 100644
--- a/tools/perf/arch/x86/util/intel-bts.c
+++ b/tools/perf/arch/x86/util/intel-bts.c
@@ -110,7 +110,7 @@ static int intel_bts_recording_options(struct auxtrace_record *itr,
 			container_of(itr, struct intel_bts_recording, itr);
 	struct perf_pmu *intel_bts_pmu = btsr->intel_bts_pmu;
 	struct evsel *evsel, *intel_bts_evsel = NULL;
-	const struct perf_cpu_map *cpus = evlist->core.cpus;
+	const struct perf_cpu_map *cpus = evlist->core.user_cpus;
 	bool privileged = perf_event_paranoid_check(-1);
 
 	if (opts->auxtrace_sample_mode) {
diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 8c31578d6f4a..58bf24960273 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -382,7 +382,7 @@ static int intel_pt_info_fill(struct auxtrace_record *itr,
 			ui__warning("Intel Processor Trace: TSC not available\n");
 	}
 
-	per_cpu_mmaps = !perf_cpu_map__empty(session->evlist->core.cpus);
+	per_cpu_mmaps = !perf_cpu_map__empty(session->evlist->core.user_cpus);
 
 	auxtrace_info->type = PERF_AUXTRACE_INTEL_PT;
 	auxtrace_info->priv[INTEL_PT_PMU_TYPE] = intel_pt_pmu->type;
@@ -632,7 +632,7 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 	struct perf_pmu *intel_pt_pmu = ptr->intel_pt_pmu;
 	bool have_timing_info, need_immediate = false;
 	struct evsel *evsel, *intel_pt_evsel = NULL;
-	const struct perf_cpu_map *cpus = evlist->core.cpus;
+	const struct perf_cpu_map *cpus = evlist->core.user_cpus;
 	bool privileged = perf_event_paranoid_check(-1);
 	u64 tsc_bit;
 	int err;
diff --git a/tools/perf/bench/evlist-open-close.c b/tools/perf/bench/evlist-open-close.c
index de56601f69ee..5bdc6b476a4d 100644
--- a/tools/perf/bench/evlist-open-close.c
+++ b/tools/perf/bench/evlist-open-close.c
@@ -151,7 +151,7 @@ static int bench_evlist_open_close__run(char *evstr)
 
 	init_stats(&time_stats);
 
-	printf("  Number of cpus:\t%d\n", perf_cpu_map__nr(evlist->core.cpus));
+	printf("  Number of cpus:\t%d\n", perf_cpu_map__nr(evlist->core.user_cpus));
 	printf("  Number of threads:\t%d\n", evlist->core.threads->nr);
 	printf("  Number of events:\t%d (%d fds)\n",
 		evlist->core.nr_entries, evlist__count_evsel_fds(evlist));
diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index ad9ce1bfffa1..642cbc6fdfc5 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -301,7 +301,7 @@ static int set_tracing_cpumask(struct perf_cpu_map *cpumap)
 
 static int set_tracing_cpu(struct perf_ftrace *ftrace)
 {
-	struct perf_cpu_map *cpumap = ftrace->evlist->core.cpus;
+	struct perf_cpu_map *cpumap = ftrace->evlist->core.user_cpus;
 
 	if (!target__has_cpu(&ftrace->target))
 		return 0;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0b4abed555d8..28ab3866802c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -987,7 +987,7 @@ static int record__thread_data_init_maps(struct record_thread *thread_data, stru
 	int m, tm, nr_mmaps = evlist->core.nr_mmaps;
 	struct mmap *mmap = evlist->mmap;
 	struct mmap *overwrite_mmap = evlist->overwrite_mmap;
-	struct perf_cpu_map *cpus = evlist->core.cpus;
+	struct perf_cpu_map *cpus = evlist->core.user_cpus;
 
 	thread_data->nr_mmaps = bitmap_weight(thread_data->mask->maps.bits,
 					      thread_data->mask->maps.nbits);
@@ -1881,7 +1881,7 @@ static int record__synthesize(struct record *rec, bool tail)
 		return err;
 	}
 
-	err = perf_event__synthesize_cpu_map(&rec->tool, rec->evlist->core.cpus,
+	err = perf_event__synthesize_cpu_map(&rec->tool, rec->evlist->core.user_cpus,
 					     process_synthesized_event, NULL);
 	if (err < 0) {
 		pr_err("Couldn't synthesize cpu map.\n");
@@ -3675,7 +3675,7 @@ static int record__init_thread_default_masks(struct record *rec, struct perf_cpu
 static int record__init_thread_masks(struct record *rec)
 {
 	int ret = 0;
-	struct perf_cpu_map *cpus = rec->evlist->core.cpus;
+	struct perf_cpu_map *cpus = rec->evlist->core.user_cpus;
 
 	if (!record__threads_enabled(rec))
 		return record__init_thread_default_masks(rec, cpus);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 4ee40de698a4..5bee529f7656 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -804,7 +804,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (group)
 		evlist__set_leader(evsel_list);
 
-	if (!cpu_map__is_dummy(evsel_list->core.cpus)) {
+	if (!cpu_map__is_dummy(evsel_list->core.user_cpus)) {
 		if (affinity__setup(&saved_affinity) < 0)
 			return -1;
 		affinity = &saved_affinity;
@@ -1458,7 +1458,7 @@ static int perf_stat_init_aggr_mode(void)
 	aggr_cpu_id_get_t get_id = aggr_mode__get_aggr(stat_config.aggr_mode);
 
 	if (get_id) {
-		stat_config.aggr_map = cpu_aggr_map__new(evsel_list->core.cpus,
+		stat_config.aggr_map = cpu_aggr_map__new(evsel_list->core.user_cpus,
 							 get_id, /*data=*/NULL);
 		if (!stat_config.aggr_map) {
 			pr_err("cannot build %s map", aggr_mode__string[stat_config.aggr_mode]);
@@ -1472,7 +1472,7 @@ static int perf_stat_init_aggr_mode(void)
 	 * taking the highest cpu number to be the size of
 	 * the aggregation translate cpumap.
 	 */
-	nr = perf_cpu_map__max(evsel_list->core.cpus).cpu;
+	nr = perf_cpu_map__max(evsel_list->core.user_cpus).cpu;
 	stat_config.cpus_aggr_map = cpu_aggr_map__empty_new(nr + 1);
 	return stat_config.cpus_aggr_map ? 0 : -ENOMEM;
 }
@@ -1627,7 +1627,7 @@ static int perf_stat_init_aggr_mode_file(struct perf_stat *st)
 	if (!get_id)
 		return 0;
 
-	stat_config.aggr_map = cpu_aggr_map__new(evsel_list->core.cpus, get_id, env);
+	stat_config.aggr_map = cpu_aggr_map__new(evsel_list->core.user_cpus, get_id, env);
 	if (!stat_config.aggr_map) {
 		pr_err("cannot build %s map", aggr_mode__string[stat_config.aggr_mode]);
 		return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9b08e44a31d9..4cfa112292d0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1021,7 +1021,7 @@ static int perf_top__start_counters(struct perf_top *top)
 
 	evlist__for_each_entry(evlist, counter) {
 try_again:
-		if (evsel__open(counter, top->evlist->core.cpus,
+		if (evsel__open(counter, top->evlist->core.user_cpus,
 				     top->evlist->core.threads) < 0) {
 
 			/*
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 9e48652662d4..b138dd6bdefc 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -174,7 +174,7 @@ void auxtrace_mmap_params__set_idx(struct auxtrace_mmap_params *mp,
 	mp->idx = idx;
 
 	if (per_cpu) {
-		mp->cpu = perf_cpu_map__cpu(evlist->core.cpus, idx);
+		mp->cpu = perf_cpu_map__cpu(evlist->core.user_cpus, idx);
 		if (evlist->core.threads)
 			mp->tid = perf_thread_map__pid(evlist->core.threads, 0);
 		else
diff --git a/tools/perf/util/bpf_ftrace.c b/tools/perf/util/bpf_ftrace.c
index 4f4d3aaff37c..69481b28b885 100644
--- a/tools/perf/util/bpf_ftrace.c
+++ b/tools/perf/util/bpf_ftrace.c
@@ -38,7 +38,7 @@ int perf_ftrace__latency_prepare_bpf(struct perf_ftrace *ftrace)
 
 	/* don't need to set cpu filter for system-wide mode */
 	if (ftrace->target.cpu_list) {
-		ncpus = perf_cpu_map__nr(ftrace->evlist->core.cpus);
+		ncpus = perf_cpu_map__nr(ftrace->evlist->core.user_cpus);
 		bpf_map__set_max_entries(skel->maps.cpu_filter, ncpus);
 	}
 
@@ -63,7 +63,7 @@ int perf_ftrace__latency_prepare_bpf(struct perf_ftrace *ftrace)
 		fd = bpf_map__fd(skel->maps.cpu_filter);
 
 		for (i = 0; i < ncpus; i++) {
-			cpu = perf_cpu_map__cpu(ftrace->evlist->core.cpus, i).cpu;
+			cpu = perf_cpu_map__cpu(ftrace->evlist->core.user_cpus, i).cpu;
 			bpf_map_update_elem(fd, &cpu, &val, BPF_ANY);
 		}
 	}
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9bb79e049957..d335fb713f5e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -440,7 +440,7 @@ static void __evlist__disable(struct evlist *evlist, char *evsel_name)
 	bool has_imm = false;
 
 	// See explanation in evlist__close()
-	if (!cpu_map__is_dummy(evlist->core.cpus)) {
+	if (!cpu_map__is_dummy(evlist->core.user_cpus)) {
 		if (affinity__setup(&saved_affinity) < 0)
 			return;
 		affinity = &saved_affinity;
@@ -500,7 +500,7 @@ static void __evlist__enable(struct evlist *evlist, char *evsel_name)
 	struct affinity saved_affinity, *affinity = NULL;
 
 	// See explanation in evlist__close()
-	if (!cpu_map__is_dummy(evlist->core.cpus)) {
+	if (!cpu_map__is_dummy(evlist->core.user_cpus)) {
 		if (affinity__setup(&saved_affinity) < 0)
 			return;
 		affinity = &saved_affinity;
@@ -565,7 +565,7 @@ static int evlist__enable_event_cpu(struct evlist *evlist, struct evsel *evsel,
 static int evlist__enable_event_thread(struct evlist *evlist, struct evsel *evsel, int thread)
 {
 	int cpu;
-	int nr_cpus = perf_cpu_map__nr(evlist->core.cpus);
+	int nr_cpus = perf_cpu_map__nr(evlist->core.user_cpus);
 
 	if (!evsel->core.fd)
 		return -EINVAL;
@@ -580,7 +580,7 @@ static int evlist__enable_event_thread(struct evlist *evlist, struct evsel *evse
 
 int evlist__enable_event_idx(struct evlist *evlist, struct evsel *evsel, int idx)
 {
-	bool per_cpu_mmaps = !perf_cpu_map__empty(evlist->core.cpus);
+	bool per_cpu_mmaps = !perf_cpu_map__empty(evlist->core.user_cpus);
 
 	if (per_cpu_mmaps)
 		return evlist__enable_event_cpu(evlist, evsel, idx);
@@ -1301,10 +1301,10 @@ void evlist__close(struct evlist *evlist)
 	struct affinity affinity;
 
 	/*
-	 * With perf record core.cpus is usually NULL.
+	 * With perf record core.user_cpus is usually NULL.
 	 * Use the old method to handle this for now.
 	 */
-	if (!evlist->core.cpus || cpu_map__is_dummy(evlist->core.cpus)) {
+	if (!evlist->core.user_cpus || cpu_map__is_dummy(evlist->core.user_cpus)) {
 		evlist__for_each_entry_reverse(evlist, evsel)
 			evsel__close(evsel);
 		return;
@@ -1367,7 +1367,7 @@ int evlist__open(struct evlist *evlist)
 	 * Default: one fd per CPU, all threads, aka systemwide
 	 * as sys_perf_event_open(cpu = -1, thread = -1) is EINVAL
 	 */
-	if (evlist->core.threads == NULL && evlist->core.cpus == NULL) {
+	if (evlist->core.threads == NULL && evlist->core.user_cpus == NULL) {
 		err = evlist__create_syswide_maps(evlist);
 		if (err < 0)
 			goto out_err;
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 007a64681416..ff326eba084f 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -106,7 +106,7 @@ void evlist__config(struct evlist *evlist, struct record_opts *opts, struct call
 	if (opts->group)
 		evlist__set_leader(evlist);
 
-	if (perf_cpu_map__cpu(evlist->core.cpus, 0).cpu < 0)
+	if (perf_cpu_map__cpu(evlist->core.user_cpus, 0).cpu < 0)
 		opts->no_inherit = true;
 
 	use_comm_exec = perf_can_comm_exec();
@@ -244,7 +244,7 @@ bool evlist__can_select_event(struct evlist *evlist, const char *str)
 
 	evsel = evlist__last(temp_evlist);
 
-	if (!evlist || perf_cpu_map__empty(evlist->core.cpus)) {
+	if (!evlist || perf_cpu_map__empty(evlist->core.user_cpus)) {
 		struct perf_cpu_map *cpus = perf_cpu_map__new(NULL);
 
 		if (cpus)
@@ -252,7 +252,7 @@ bool evlist__can_select_event(struct evlist *evlist, const char *str)
 
 		perf_cpu_map__put(cpus);
 	} else {
-		cpu = perf_cpu_map__cpu(evlist->core.cpus, 0);
+		cpu = perf_cpu_map__cpu(evlist->core.user_cpus, 0);
 	}
 
 	while (1) {
diff --git a/tools/perf/util/sideband_evlist.c b/tools/perf/util/sideband_evlist.c
index 748371ac22be..9f58c68a25f7 100644
--- a/tools/perf/util/sideband_evlist.c
+++ b/tools/perf/util/sideband_evlist.c
@@ -114,7 +114,7 @@ int evlist__start_sb_thread(struct evlist *evlist, struct target *target)
 	}
 
 	evlist__for_each_entry(evlist, counter) {
-		if (evsel__open(counter, evlist->core.cpus, evlist->core.threads) < 0)
+		if (evsel__open(counter, evlist->core.user_cpus, evlist->core.threads) < 0)
 			goto out_delete_evlist;
 	}
 
diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 9cbe351b141f..634dd9ea2b35 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -929,7 +929,7 @@ static void print_no_aggr_metric(struct perf_stat_config *config,
 	int all_idx;
 	struct perf_cpu cpu;
 
-	perf_cpu_map__for_each_cpu(cpu, all_idx, evlist->core.cpus) {
+	perf_cpu_map__for_each_cpu(cpu, all_idx, evlist->core.user_cpus) {
 		struct evsel *counter;
 		bool first = true;
 
diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index b654de0841f8..591afc6c607b 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -2127,7 +2127,7 @@ int perf_event__synthesize_stat_events(struct perf_stat_config *config, struct p
 		return err;
 	}
 
-	err = perf_event__synthesize_cpu_map(tool, evlist->core.cpus, process, NULL);
+	err = perf_event__synthesize_cpu_map(tool, evlist->core.user_cpus, process, NULL);
 	if (err < 0) {
 		pr_err("Couldn't synthesize thread map.\n");
 		return err;
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index c1ebfc5d2e0c..e98422f3ff17 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -95,15 +95,16 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 
 	if (target->cpu_list)
 		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
-				perf_cpu_map__nr(top->evlist->core.cpus) > 1 ? "s" : "",
+				perf_cpu_map__nr(top->evlist->core.user_cpus) > 1 ? "s" : "",
 				target->cpu_list);
 	else {
 		if (target->tid)
 			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
 			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
-					perf_cpu_map__nr(top->evlist->core.cpus),
-					perf_cpu_map__nr(top->evlist->core.cpus) > 1 ? "s" : "");
+					perf_cpu_map__nr(top->evlist->core.user_cpus),
+					perf_cpu_map__nr(top->evlist->core.user_cpus) > 1
+					? "s" : "");
 	}
 
 	perf_top__reset_sample_counters(top);
-- 
2.35.1.1021.g381101b075-goog

