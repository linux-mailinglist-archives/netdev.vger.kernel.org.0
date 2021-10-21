Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE131435974
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhJUDtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhJUDtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:49:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAC6C0613E3;
        Wed, 20 Oct 2021 20:46:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id np13so3914436pjb.4;
        Wed, 20 Oct 2021 20:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vH95WB7SHuZl+OHfTyscOsIJK4xnc4RRJ6+oOMiH9U0=;
        b=ONN6vvFd0ns96u6331CD6HkkWYCbEU6TjsbPJ/24mbKNA6tr5q7qQotTaj8Mnq0Oy/
         6sHAEY7EqLq8oowlubIxypFZHPuE221IyMHaK3Br1kteZmDSKJJxHc7yShnPNp6y5ert
         DQ9sucfTbC7xUjxwz/uBe8mgDdnYdYwbmICO8PpdsJknN+8LvXa9588A3h1sOOfVddsq
         HJ/QWQ688t81M+UOu/cITaRZppOeIbnp/OdAgruqOESddU5RRuoIjMpHMs4hGex9OcxC
         AnTMUfzgjE3fUID+dc4UxZHTEEpEIryazqNptQ4gjH8lRicgjPg/fqUJna6uq7HSds//
         pShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vH95WB7SHuZl+OHfTyscOsIJK4xnc4RRJ6+oOMiH9U0=;
        b=Tjwni8ZV/O1pdiOrsO17doTuphaq4J6RKG4Er8pz3l4HOIRtad4t/hyqQ1Ub0yi6dX
         +z6Aa1BaqBXNAocJg3POO1yODFd+EWoNGyWLMIhoyVLjiJxtPh8SxjIEEinm+Eoar1LN
         U9+FnUDa8zzJMypm1cwkkpOVqpQ/MwKtt8JYEUV3zsDyXsNPzCcp3w9U0256LwCeSRY0
         kRp6ffMj+XtY72g1gzdoI5WSZtfEQ6xBvarrHcTVYALBfp28msqG3QAm33h/QLiK4fWd
         M5r0Xl6QRqQtpCm05wgB/ketr9FHPK9foRISM8dGOi7G5DGl9mpUDkmMEPklWd68meXe
         AcJA==
X-Gm-Message-State: AOAM533YmK7v7iLyToshWxcvhuYqoiUnX9KGb2cT/+g/pFxynWyl2SlG
        zGC3e/NnM4jbsRFSsWtlMD8=
X-Google-Smtp-Source: ABdhPJzaD6egSTgYDO3PO9pJHsve5z8E67H2laSTVUCwVC2kSTVI+Cy7/6mY2fEzIv/YbfiYagnsDA==
X-Received: by 2002:a17:90b:4a49:: with SMTP id lb9mr3484246pjb.85.1634787973637;
        Wed, 20 Oct 2021 20:46:13 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id r25sm3454254pge.61.2021.10.20.20.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:46:13 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     keescook@chromium.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v5 12/15] tools/perf/test: make perf test adopt to task comm size change
Date:   Thu, 21 Oct 2021 03:46:00 +0000
Message-Id: <20211021034603.4458-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034603.4458-1-laoar.shao@gmail.com>
References: <20211021034603.4458-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot reported a perf-test failure after I extended task comm
size from 16 to 24. The failure as follows,

2021-10-13 18:00:46 sudo /usr/src/perf_selftests-x86_64-rhel-8.3-317419b91ef4eff4e2f046088201e4dc4065caa0/tools/perf/perf test 15
15: Parse sched tracepoints fields                                  : FAILED!

The reason is perf-test requires a fixed-size task comm. If we extend
task comm size to 24, it will not equil with the required size 16 in perf
test.

After some analyzation, I found perf itself can adopt to the size
change, for example, below is the output of perf-sched after I extend
comm size to 24 -

task    614 (            kthreadd:        84), nr_events: 1
task    615 (             systemd:       843), nr_events: 1
task    616 (     networkd-dispat:      1026), nr_events: 1
task    617 (             systemd:       846), nr_events: 1

$ cat /proc/843/comm
networkd-dispatcher

The task comm can be displayed correctly as expected.

Now that task comm can have a different size, then the test should accept
the two sizes as possible and pass if it is 16 or 24. In order to do
that, a new macro TASK_COMM_LEN_24 is introduced.

After this patch, the perf-test succeeds no matter task comm is 16 or
24 -

15: Parse sched tracepoints fields                                  : Ok

This patch is a preparation for the followup patch.

Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/include/linux/sched/task.h  |  1 +
 tools/perf/tests/evsel-tp-sched.c | 26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/include/linux/sched/task.h b/tools/include/linux/sched/task.h
index 7657dd3e0e02..da49ac983ac6 100644
--- a/tools/include/linux/sched/task.h
+++ b/tools/include/linux/sched/task.h
@@ -2,5 +2,6 @@
 #define _TOOLS_PERF_LINUX_SCHED_TASK_H
 
 #define TASK_COMM_LEN_16 16
+#define TASK_COMM_LEN_24 24
 
 #endif  /* _TOOLS_PERF_LINUX_SCHED_TASK_H */
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index f9e34bd26cf3..cf4e0472e29e 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -1,11 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/err.h>
+#include <linux/sched/task.h>
 #include <traceevent/event-parse.h>
 #include "evsel.h"
 #include "tests.h"
 #include "debug.h"
 
-static int evsel__test_field(struct evsel *evsel, const char *name, int size, bool should_be_signed)
+static int evsel__test_field_alt(struct evsel *evsel, const char *name,
+				 int size, int alternate_size, bool should_be_signed)
 {
 	struct tep_format_field *field = evsel__field(evsel, name);
 	int is_signed;
@@ -23,15 +25,24 @@ static int evsel__test_field(struct evsel *evsel, const char *name, int size, bo
 		ret = -1;
 	}
 
-	if (field->size != size) {
-		pr_debug("%s: \"%s\" size (%d) should be %d!\n",
+	if (field->size != size && field->size != alternate_size) {
+		pr_debug("%s: \"%s\" size (%d) should be %d",
 			 evsel->name, name, field->size, size);
+		if (alternate_size > 0)
+			pr_debug(" or %d", alternate_size);
+		pr_debug("!\n");
 		ret = -1;
 	}
 
 	return ret;
 }
 
+static int evsel__test_field(struct evsel *evsel, const char *name,
+			     int size, bool should_be_signed)
+{
+	return evsel__test_field_alt(evsel, name, size, -1, should_be_signed);
+}
+
 int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtest __maybe_unused)
 {
 	struct evsel *evsel = evsel__newtp("sched", "sched_switch");
@@ -42,7 +53,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
 		return -1;
 	}
 
-	if (evsel__test_field(evsel, "prev_comm", 16, false))
+	if (evsel__test_field_alt(evsel, "prev_comm", TASK_COMM_LEN_16,
+				  TASK_COMM_LEN_24, false))
 		ret = -1;
 
 	if (evsel__test_field(evsel, "prev_pid", 4, true))
@@ -54,7 +66,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
 	if (evsel__test_field(evsel, "prev_state", sizeof(long), true))
 		ret = -1;
 
-	if (evsel__test_field(evsel, "next_comm", 16, false))
+	if (evsel__test_field_alt(evsel, "next_comm", TASK_COMM_LEN_16,
+				  TASK_COMM_LEN_24, false))
 		ret = -1;
 
 	if (evsel__test_field(evsel, "next_pid", 4, true))
@@ -72,7 +85,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
 		return -1;
 	}
 
-	if (evsel__test_field(evsel, "comm", 16, false))
+	if (evsel__test_field_alt(evsel, "comm", TASK_COMM_LEN_16,
+				  TASK_COMM_LEN_24, false))
 		ret = -1;
 
 	if (evsel__test_field(evsel, "pid", 4, true))
-- 
2.17.1

