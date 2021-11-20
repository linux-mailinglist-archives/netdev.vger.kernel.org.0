Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15723457D61
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhKTLb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbhKTLbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:12 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AA6C061574;
        Sat, 20 Nov 2021 03:28:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so10956077pjb.5;
        Sat, 20 Nov 2021 03:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uISwC7S3YtMXd9NwSu3k9zzcmpaBl9Ur9ZibZHHGTvY=;
        b=AbHPprtqO+jSPttTiHNuKsHBAQ+5yGpG8KFNyWwFOAPmScilI9Nc5E58eQu0FXa2K+
         5lRhY5ZgJ/vUp675NFNJYIEUw21fsKlMkpXITpZwNjOVdhxzhKch266wLSXcQnaFpgpu
         GWruZuhH9zcwumOj/DxIy16mTHkDzEnW9G76RGOLPkrLqCIYn425lljS3usJ+8gVvgvc
         jv/8+tslX2Xzwv5R+Jyp7YjJ6oTDladlQmsX+Cu1H+J1v4/GelbcYJ6DnrMlEE6Czl/M
         fI+0J+gj4XUP+qtuAPcrCgASybOrejTephGU8+uh9YDTx7fr+70bshEGIvYMDm3Xn4Xk
         ftHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uISwC7S3YtMXd9NwSu3k9zzcmpaBl9Ur9ZibZHHGTvY=;
        b=NBLWFgnNuaACi0hi39s0rNvXwfZBTIzbDiPj91rY/etmTc/szabVcwIo0KQM5MWpJx
         2OrlC6qWa1sTo6wkswduttMReViM3Dv/RPtXkVpPs9MlUlseN+/P1sDevv1M0vriEDbS
         bIP1bOv4tM4I/dBV3rs0jlrEmKWcnBeVgDvsmNXVjuxY7xIcRRWcWsIgMVd2HJs6+UEr
         Ckzvw3tnzYradY35ibI0ck23YseQKrC2Bl56jtTKPTca/DqMlj8MvgRJcBiYaTJ7gjAw
         7+IXjsBm2v/c8048N9EfhDmz/rIhMrZdUPTI5z8LrQRJMPFLvPLH/jV4UjKTny2rznDv
         aUDg==
X-Gm-Message-State: AOAM531qI27jPc4ho5PUZcVDem1iU4nht9cGSk+jTRCt7iYQPCtflymm
        gmmtP2R32as9LONwLsVq2oA=
X-Google-Smtp-Source: ABdhPJzCvM4ZOu5jxNVjS5MOuJ+QxxoCh4xHa9VDf6Kty/9IeqDFb9wJ+DFAaNClvGB5ZbqhdnJSPQ==
X-Received: by 2002:a17:903:2004:b0:142:6344:2c08 with SMTP id s4-20020a170903200400b0014263442c08mr86481406pla.51.1637407689212;
        Sat, 20 Nov 2021 03:28:09 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:08 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN
Date:   Sat, 20 Nov 2021 11:27:38 +0000
Message-Id: <20211120112738.45980-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the sched:sched_switch tracepoint args are derived from the kernel,
we'd better make it same with the kernel. So the macro TASK_COMM_LEN is
converted to type enum, then all the BPF programs can get it through BTF.

The BPF program which wants to use TASK_COMM_LEN should include the header
vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
need to include linux/bpf.h again.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 include/linux/sched.h                                   | 9 +++++++--
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c | 6 +++---
 tools/testing/selftests/bpf/progs/test_tracepoint.c     | 6 +++---
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78c351e35fec..cecd4806edc6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,8 +274,13 @@ struct task_group;
 
 #define get_current_state()	READ_ONCE(current->__state)
 
-/* Task command name length: */
-#define TASK_COMM_LEN			16
+/*
+ * Define the task command name length as enum, then it can be visible to
+ * BPF programs.
+ */
+enum {
+	TASK_COMM_LEN = 16,
+};
 
 extern void scheduler_tick(void);
 
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index a8233e7f173b..728dbd39eff0 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2018 Facebook
 
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
 #ifndef PERF_MAX_STACK_DEPTH
@@ -41,11 +41,11 @@ struct {
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN];
 	int next_pid;
 	int next_prio;
 };
diff --git a/tools/testing/selftests/bpf/progs/test_tracepoint.c b/tools/testing/selftests/bpf/progs/test_tracepoint.c
index ce6974016f53..43bd7a20cc50 100644
--- a/tools/testing/selftests/bpf/progs/test_tracepoint.c
+++ b/tools/testing/selftests/bpf/progs/test_tracepoint.c
@@ -1,17 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2017 Facebook
 
-#include <linux/bpf.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN];
 	int next_pid;
 	int next_prio;
 };
-- 
2.17.1

