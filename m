Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1843916D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhJYIg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhJYIg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3FDC061243;
        Mon, 25 Oct 2021 01:34:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so7120583pje.0;
        Mon, 25 Oct 2021 01:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1md3Mevkn+CBLiLByux/J8bl1HeiftdQPKT0KXDTr4s=;
        b=ippqS7oyy/Xxu6ZxvpuafUWSvpsfvfwE/3J3JNAouce3xXBt5wOOlT/RiZpgQ0gzj8
         PKadBOKIY75j0iZuHaUbBgBpNPw5ZbxNYHrf5n2Tsn9IYbPusgJzNUZTTGkGSwjkBp6n
         oK9EKcykGE6fGX+zqXz9NTA+gFaqMFBkTthGhqY2C0RpW4E8fnrfZGLFHgh2pQRJewxw
         2FLLyudFZ5ofXs9aNR1UXn5m5pgHHAflMUH3uYxlOfVxySeAykoWnZCRjhUNXEj0A8Ce
         2/4PFZ/n097pvj+lPKb+n1HLjmSbAFa4LCwkEIn8vMqH689VQmoKK20lbaOX2cjARGm2
         i99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1md3Mevkn+CBLiLByux/J8bl1HeiftdQPKT0KXDTr4s=;
        b=GNQRk2cMCWKQDrr5BC9yvnVQHl1yP/tnlyu9Cv0F50X86gZx1AZQ96cf/3hb44Oa1k
         9ZhMkT98pjyR101E7NtOyFJcBmxkShg3CBvTOf08mxsnaY2tDrWB41B8M2T1TqeKOcwL
         Zgz2uOdgNsBqBkXu/oIpddsJNwtQd5EG+OUA/63hLEz4aTBKKuzAL9xaClHsTrKfbldO
         sN5aM0T4TrEA/mie59OuPQGNJ6r2ge+rr7shr+P+BjI/y1vvCWfpzzuuB1NYF+gt/18W
         KpWMBi6HJVK3DVRPipQtFqs42vQVM6QRMqTzzdjZJrSZvRpPP9NNalmc4iUmtq/vr/FO
         10JQ==
X-Gm-Message-State: AOAM5312YHGJyHD2/p3gJzw9rxy1j8loEyezCwW3B4yXpJmMs8jUVkh8
        JTmlGehexbPXoOt9AuMLMoc=
X-Google-Smtp-Source: ABdhPJwx3ky7vXb/J2lUahfhiiyc2nfJn2hGx6yFG/luHydF3goGPz/vPzvSnaj5EdOe4N7u8ko/aQ==
X-Received: by 2002:a17:90a:284c:: with SMTP id p12mr12363516pjf.95.1635150843340;
        Mon, 25 Oct 2021 01:34:03 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:34:02 -0700 (PDT)
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
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH v6 09/12] tools/perf/test: make perf test adopt to task comm size change
Date:   Mon, 25 Oct 2021 08:33:12 +0000
Message-Id: <20211025083315.4752-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
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

