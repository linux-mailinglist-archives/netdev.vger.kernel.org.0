Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9329E44138F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhKAGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhKAGHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D41DC06120E;
        Sun, 31 Oct 2021 23:04:48 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q187so16345025pgq.2;
        Sun, 31 Oct 2021 23:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2AOLQynizUK/9ub+MV3+x/PqsjWBik6Y2qklqSq5kvM=;
        b=l0EIvzonzcNlCGT6TjXsysXA3uAstk65U4vdn7q433mY6i9VaZO0ffvw4f0T7ELy+H
         v5u+ZBM7SAyqPzYBN8O3x3hA2xIUlUhwyCu+BC5V53HvycjI8Hi1umyK7IQJacmk7i6o
         khFyYXCW5nWroZrXjJsWFekl96dq67dFeaypF802J/p4iwuZyg6Sdmu4rhSJT2qJi5Xn
         00XpVbToRKPbkrTugqQahtpW6uED5b5mo1TqnqCLLEU/0vh43M+JEmJ14r4WejDOBaEu
         +jeAFO9mXb76Vk4n5De0pRxb2KCQFi3+BU1G2dJDHO+QI+K2i7tRGETK7bbMtOtDZjJV
         Xahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2AOLQynizUK/9ub+MV3+x/PqsjWBik6Y2qklqSq5kvM=;
        b=7TDhLvw507GCM14b7tNxqC1cWY3cs4ODkGLJYvBQjiso4MeLSyR4wUsb2v++OqdhQd
         +CI5b6GPE7yrORxCCU8cl+TpGbGoz4T+hRb3N2BllWiDIo1waMVWG5t81wXtwz1a2kdZ
         9tWI2HJy3vJHAF67PTIh6Mm4lv5ICfPJMiW6d9lxSn9M+bAdHjyvHtnsIcLPPf/U4Q7J
         UTWXj32nBWuPsuXLBdRfBDJNoLaelRAB09tWks2SaM4kmfeIqIxqu0KzWG8Eqe2QxaAb
         MYjxhKwujd7SP7tiIEt9NXM/jLkcANhjztlLk1pBWXbn8Wwod5R1Q+hWbwk+uwSXA2Wz
         /cDA==
X-Gm-Message-State: AOAM530MQHR+Fie1l5v6z0lVc6GT2ZabVV9h7hGTzTr82TuHSsiWfOhg
        8+uCBt1VOPmf+hBNXHUj2L0=
X-Google-Smtp-Source: ABdhPJyam8xih1Z6tKYYGpuiGMnnmxuj4/L4ZJpVlE3q5S3rpYWdBTOmUb41H+/yZOg+DA2kjkENOw==
X-Received: by 2002:a63:8f4a:: with SMTP id r10mr20105733pgn.337.1635746688077;
        Sun, 31 Oct 2021 23:04:48 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:47 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        arnaldo.melo@gmail.com, pmladek@suse.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, valentin.schneider@arm.com,
        qiang.zhang@windriver.com, robdclark@chromium.org,
        christian@brauner.io, dietmar.eggemann@arm.com, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, dennis.dalessandro@cornelisnetworks.com,
        mike.marciniszyn@cornelisnetworks.com, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v7 08/11] tools/perf/test: make perf test adopt to task comm size change
Date:   Mon,  1 Nov 2021 06:04:16 +0000
Message-Id: <20211101060419.4682-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
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

Replace old hard-coded 16 with the new one can fix the warning, but we'd
better make the test accept both old and new sizes, then it can be
backward compatibility.

After this patch, the perf-test succeeds no matter task comm is 16 or
24 -

15: Parse sched tracepoints fields                                  : Ok

This patch is a preparation for the followup patch.

Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/include/linux/sched.h       | 11 +++++++++++
 tools/perf/tests/evsel-tp-sched.c | 26 ++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)
 create mode 100644 tools/include/linux/sched.h

diff --git a/tools/include/linux/sched.h b/tools/include/linux/sched.h
new file mode 100644
index 000000000000..0d575afd7f43
--- /dev/null
+++ b/tools/include/linux/sched.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_SCHED_H
+#define _TOOLS_LINUX_SCHED_H
+
+/* Keep both length for backward compatibility */
+enum {
+	TASK_COMM_LEN_16 = 16,
+	TASK_COMM_LEN = 24,
+};
+
+#endif  /* _TOOLS_LINUX_SCHED_H */
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index f9e34bd26cf3..029f2a8c8e51 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -1,11 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/err.h>
+#include <linux/sched.h>
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
+				  TASK_COMM_LEN, false))
 		ret = -1;
 
 	if (evsel__test_field(evsel, "prev_pid", 4, true))
@@ -54,7 +66,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
 	if (evsel__test_field(evsel, "prev_state", sizeof(long), true))
 		ret = -1;
 
-	if (evsel__test_field(evsel, "next_comm", 16, false))
+	if (evsel__test_field_alt(evsel, "next_comm", TASK_COMM_LEN_16,
+				  TASK_COMM_LEN, false))
 		ret = -1;
 
 	if (evsel__test_field(evsel, "next_pid", 4, true))
@@ -72,7 +85,8 @@ int test__perf_evsel__tp_sched_test(struct test *test __maybe_unused, int subtes
 		return -1;
 	}
 
-	if (evsel__test_field(evsel, "comm", 16, false))
+	if (evsel__test_field_alt(evsel, "comm", TASK_COMM_LEN_16,
+				  TASK_COMM_LEN, false))
 		ret = -1;
 
 	if (evsel__test_field(evsel, "pid", 4, true))
-- 
2.17.1

