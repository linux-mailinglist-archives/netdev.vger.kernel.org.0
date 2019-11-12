Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D910F8E13
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfKLLTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:19:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33994 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfKLLSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:18:32 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iUUBO-0000LL-Pi; Tue, 12 Nov 2019 12:18:02 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id AC2901C0483;
        Tue, 12 Nov 2019 12:17:57 +0100 (CET)
Date:   Tue, 12 Nov 2019 11:17:57 -0000
From:   "tip-bot2 for Ian Rogers" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf parse: Add destructors for parse event terms
Cc:     Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191030223448.12930-7-irogers@google.com>
References: <20191030223448.12930-7-irogers@google.com>
MIME-Version: 1.0
Message-ID: <157355747733.29376.2202395677486498086.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     f2a8ecd8b1f4df096d9597388eda1c994c72d373
Gitweb:        https://git.kernel.org/tip/f2a8ecd8b1f4df096d9597388eda1c994c72d373
Author:        Ian Rogers <irogers@google.com>
AuthorDate:    Wed, 30 Oct 2019 15:34:44 -07:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Thu, 07 Nov 2019 08:29:43 -03:00

perf parse: Add destructors for parse event terms

If parsing fails then destructors are ran to clean the up the stack.
Rename the head union member to make the term and evlist use cases more
distinct, this simplifies matching the correct destructor.

Committer notes:

Jiri: "Nice did not know about this.. looks like it's been in bison for some time, right?"

Ian:  "Looks like it wasn't in Bison 1 but in Bison 2, we're at Bison 3 and
       Bison 2 is > 14 years old:
       https://web.archive.org/web/20050924004158/http://www.gnu.org/software/bison/manual/html_mono/bison.html#Destructor-Decl"

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: bpf@vger.kernel.org
Cc: clang-built-linux@googlegroups.com
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191030223448.12930-7-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.y | 69 ++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 545ab7c..035edfa 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -12,6 +12,7 @@
 #include <stdio.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/zalloc.h>
 #include "pmu.h"
 #include "evsel.h"
 #include "parse-events.h"
@@ -37,6 +38,25 @@ static struct list_head* alloc_list()
 	return list;
 }
 
+static void free_list_evsel(struct list_head* list_evsel)
+{
+	struct evsel *evsel, *tmp;
+
+	list_for_each_entry_safe(evsel, tmp, list_evsel, core.node) {
+		list_del_init(&evsel->core.node);
+		perf_evsel__delete(evsel);
+	}
+	free(list_evsel);
+}
+
+static void free_term(struct parse_events_term *term)
+{
+	if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
+		free(term->val.str);
+	zfree(&term->array.ranges);
+	free(term);
+}
+
 static void inc_group_count(struct list_head *list,
 		       struct parse_events_state *parse_state)
 {
@@ -66,6 +86,7 @@ static void inc_group_count(struct list_head *list,
 %type <num> PE_VALUE_SYM_TOOL
 %type <num> PE_RAW
 %type <num> PE_TERM
+%type <num> value_sym
 %type <str> PE_NAME
 %type <str> PE_BPF_OBJECT
 %type <str> PE_BPF_SOURCE
@@ -76,37 +97,43 @@ static void inc_group_count(struct list_head *list,
 %type <str> PE_EVENT_NAME
 %type <str> PE_PMU_EVENT_PRE PE_PMU_EVENT_SUF PE_KERNEL_PMU_EVENT
 %type <str> PE_DRV_CFG_TERM
-%type <num> value_sym
-%type <head> event_config
-%type <head> opt_event_config
-%type <head> opt_pmu_config
+%destructor { free ($$); } <str>
 %type <term> event_term
-%type <head> event_pmu
-%type <head> event_legacy_symbol
-%type <head> event_legacy_cache
-%type <head> event_legacy_mem
-%type <head> event_legacy_tracepoint
+%destructor { free_term ($$); } <term>
+%type <list_terms> event_config
+%type <list_terms> opt_event_config
+%type <list_terms> opt_pmu_config
+%destructor { parse_events_terms__delete ($$); } <list_terms>
+%type <list_evsel> event_pmu
+%type <list_evsel> event_legacy_symbol
+%type <list_evsel> event_legacy_cache
+%type <list_evsel> event_legacy_mem
+%type <list_evsel> event_legacy_tracepoint
+%type <list_evsel> event_legacy_numeric
+%type <list_evsel> event_legacy_raw
+%type <list_evsel> event_bpf_file
+%type <list_evsel> event_def
+%type <list_evsel> event_mod
+%type <list_evsel> event_name
+%type <list_evsel> event
+%type <list_evsel> events
+%type <list_evsel> group_def
+%type <list_evsel> group
+%type <list_evsel> groups
+%destructor { free_list_evsel ($$); } <list_evsel>
 %type <tracepoint_name> tracepoint_name
-%type <head> event_legacy_numeric
-%type <head> event_legacy_raw
-%type <head> event_bpf_file
-%type <head> event_def
-%type <head> event_mod
-%type <head> event_name
-%type <head> event
-%type <head> events
-%type <head> group_def
-%type <head> group
-%type <head> groups
+%destructor { free ($$.sys); free ($$.event); } <tracepoint_name>
 %type <array> array
 %type <array> array_term
 %type <array> array_terms
+%destructor { free ($$.ranges); } <array>
 
 %union
 {
 	char *str;
 	u64 num;
-	struct list_head *head;
+	struct list_head *list_evsel;
+	struct list_head *list_terms;
 	struct parse_events_term *term;
 	struct tracepoint_name {
 		char *sys;
