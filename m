Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352F2447C21
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhKHInA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbhKHImj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:39 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57BBC061570;
        Mon,  8 Nov 2021 00:39:55 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so6128436pjb.1;
        Mon, 08 Nov 2021 00:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yrH87tfprvHWh1UM/Pxd5vb7Nmf3wgq3PePQi/OQ3fM=;
        b=UXeJsykeaTS2gyNy6C+oQj/glOemNbibLh5K9uUAexVW98PENGloN1a1DQBKk79Sfz
         97shWEXQKatj7t9wk3efdtyJuTylV/6D4GHU0LBtL4lvH3+9MqfldW+cxMZG7wHSw7Ty
         JLqnQNmZvMc9EnMjtW5gpgosJOELC0bm0xHfIqED/x296LBWnK2O39c5TcdIQL6syzJs
         lKYZXVvLw8Sof1pb9lqgZlUdGLs32Xc7bpwlrnX91/zOCUhNZuzGTihu/4zP+IG+9zvA
         kFLxPD0E7Jc0wFI8ssDHUG9vbV7+mB0nHoLZw5HfSgwe+1a4TqmO2ejzjJmLS2U3/+EK
         uUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yrH87tfprvHWh1UM/Pxd5vb7Nmf3wgq3PePQi/OQ3fM=;
        b=Vr4hvQM2yvbPRMQXQfzxkWgT7toBVQxNKz8EZsCpRNMY4QUkQvFtUAbaKMnCkXqGsg
         f1PhSztDXhRdP9FH0Fq7PxzD/oqkvI2ZASVknaQ/MLgJnwtLJwyVrWziCF2gXwaT4do6
         VR/gf1q3ox5ACZsPABJdkafQs5DleLuU361WGzufmrFpcNt7sRIetjivV2aK111UbSlk
         SOfJrTo8zoTqpRJ1CpaCIo8rNUdc1N5ZYMhrnJD/tYLxyIUB94iXCSed/nGu3yaFMrbx
         pnMlrOZeF3U0YQiWYJ7+2x3CG7erpKQ4GDvZxFXvHvjU420KQcf2Fq7zoM5WOV+Ov+aY
         845w==
X-Gm-Message-State: AOAM533wW/8Q0r3hoctqKEIM5AjJW3xeZABTdNxbqK9TFETMj4Dhp1MW
        ApKD4ieupJqHfKIfBsEASqI=
X-Google-Smtp-Source: ABdhPJzwe6vL48ZC4bLnBtXKY3tyRaqx6od1EbhiMSxN08dDtV62OsE+sTwHtDjbGUZBdCwHWVvgzg==
X-Received: by 2002:a17:90b:180d:: with SMTP id lw13mr38098294pjb.225.1636360795243;
        Mon, 08 Nov 2021 00:39:55 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:54 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 7/7] tools/testing/selftests/bpf: make it adopt to task comm size change
Date:   Mon,  8 Nov 2021 08:38:40 +0000
Message-Id: <20211108083840.4627-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hard-coded 16 is used in various bpf progs. These progs get task
comm either via bpf_get_current_comm() or prctl() or
bpf_core_read_str(), all of which can work well even if the task comm size
is changed.

In these BPF programs, one thing to be improved is the
sched:sched_switch tracepoint args. As the tracepoint args are derived
from the kernel, we'd better make it same with the kernel. So the macro
TASK_COMM_LEN is converted to type enum, then all the BPF programs can
get it through BTF.

The BPF program which wants to use TASK_COMM_LEN should include the header
vmlinux.h. Regarding the test_stacktrace_map and test_tracepoint, as the
type defined in linux/bpf.h are also defined in vmlinux.h, so we don't
need to include linux/bpf.h again.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
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
index e0454e60fe8f..1c456691f890 100644
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
index 00ed48672620..e9b602a6dc1b 100644
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
index 4b825ee122cf..f21982681e28 100644
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

