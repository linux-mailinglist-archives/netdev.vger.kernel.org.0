Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA77C43597F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhJUDty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhJUDtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:49:24 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900E2C0613E5;
        Wed, 20 Oct 2021 20:46:15 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m26so4705366pff.3;
        Wed, 20 Oct 2021 20:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vw+8P3h/cd/qdfXTUysYQI10wuP/awsRFjFZVZ6oyuo=;
        b=FMk+mSWZRkjJQwseuk8LuJWlfa6hE1iUkD0XgEf2G93U6t3EhkD1LOvFkjrII0gToC
         qV5PZXzAqDzv3bmwtO4AE/iFpFnotRZMWoXEOMIHJbSWOQGqr2c3HXRAlFVTp8Tan0Lt
         619AwmGCWSCchYMMxt9pggqsvFenPNtHj4O+9gjyxy8OjhMV75K+TwT/EbLwxaRG79sp
         aWfOwTBuILzqvVmSxE/axHtuIk7wL+1bQeET+asn9EAI9o8Sua0nP05zbzNTqWWVMgsA
         04tTJlO7/GqiCWGwFxkBy4f47pnK+/K8/Z+9oUSFRnXyo/+PYICBquw9CMXggCqJbw+Y
         1EYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vw+8P3h/cd/qdfXTUysYQI10wuP/awsRFjFZVZ6oyuo=;
        b=z4yRADLnGnjAiWjexUKiDcL6OnWKdcl1Bbqi9EiTtOz36UN+qVuZ7TMcyQFo6yHldv
         6Lg6qxei7foY/48JG70Z7NpT1de8PTTlJfk2YJWh10sqOfId9tMJoCTca4YJP5EDfHCZ
         GJQ8Oqe2ovDxzR/vsYCZYKblMYVBzAlj+sPWV6iVyxMGmThvBmQFCv5Bt5ybslqyL+Gn
         enQNVH21FFmloLxZsg/tUIPFIYCnXwba3xvbWxWKp/jXBGAf7oJYR2PcvfDZg083FJTV
         JNEtyxFQfMLDd5Vyo6IYRnUC7nT71GLvj9M8LhJkZvkN7JOyEoVs4c/nRpm2FOEheG0P
         Scsw==
X-Gm-Message-State: AOAM533kl91Rl7slIfdBCgwmv19c72ljxpjgLwVwqX1b6s94mnCAsxdg
        vtpklM8562KaPGXQAR5ujPk=
X-Google-Smtp-Source: ABdhPJxLAi5Iqc3NxwXMd+0UNO64e2DEucuOsA6dYSg9zt3oOOmStq+k5dJ+9t9vDHwIcwodmylMvg==
X-Received: by 2002:a05:6a00:14cc:b0:44d:ebab:2e16 with SMTP id w12-20020a056a0014cc00b0044debab2e16mr2892729pfu.23.1634787975094;
        Wed, 20 Oct 2021 20:46:15 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id r25sm3454254pge.61.2021.10.20.20.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:46:14 -0700 (PDT)
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
Subject: [PATCH v5 13/15] tools/testing/selftests/bpf: use TASK_COMM_LEN_16 instead of hard-coded 16
Date:   Thu, 21 Oct 2021 03:46:01 +0000
Message-Id: <20211021034603.4458-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034603.4458-1-laoar.shao@gmail.com>
References: <20211021034603.4458-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hard-coded 16 is used in various bpf progs. These progs get task
comm either via bpf_get_current_comm() or prctl() or
bpf_core_read_str(), all of which can work well even if the task comm size
is changed.
Below is the detailed information,

bpf_get_current_comm:
    progs/test_ringbuf.c
    progs/test_ringbuf_multi.c

prctl:
    prog_tests/test_overhead.c
    prog_tests/trampoline_count.c

bpf_core_read_str:
    progs/test_core_reloc_kernel.c
    progs/test_sk_storage_tracing.c

We'd better replace the hard-coded 16 with TASK_COMM_LEN_16 to make it
more grepable.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/testing/selftests/bpf/Makefile                      | 2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c          | 3 ++-
 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c    | 3 ++-
 .../testing/selftests/bpf/prog_tests/sk_storage_tracing.c | 3 ++-
 tools/testing/selftests/bpf/prog_tests/test_overhead.c    | 3 ++-
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c | 3 ++-
 tools/testing/selftests/bpf/progs/profiler.h              | 7 ++++---
 tools/testing/selftests/bpf/progs/profiler.inc.h          | 8 ++++----
 tools/testing/selftests/bpf/progs/pyperf.h                | 4 ++--
 tools/testing/selftests/bpf/progs/strobemeta.h            | 6 +++---
 .../testing/selftests/bpf/progs/test_core_reloc_kernel.c  | 3 ++-
 tools/testing/selftests/bpf/progs/test_ringbuf.c          | 3 ++-
 tools/testing/selftests/bpf/progs/test_ringbuf_multi.c    | 3 ++-
 .../testing/selftests/bpf/progs/test_sk_storage_tracing.c | 5 +++--
 tools/testing/selftests/bpf/progs/test_skb_helpers.c      | 5 ++---
 tools/testing/selftests/bpf/progs/test_stacktrace_map.c   | 5 +++--
 tools/testing/selftests/bpf/progs/test_tracepoint.c       | 5 +++--
 17 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 799b88152e9e..5e72d783d3fe 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -279,7 +279,7 @@ MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
-	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
+	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR) -I${TOOLSINCDIR}	\
 	     -I$(abspath $(OUTPUT)/../usr/include)
 
 CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index 4706cee84360..ac82d57c09dc 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -12,6 +12,7 @@
 #include <sys/sysinfo.h>
 #include <linux/perf_event.h>
 #include <linux/ring_buffer.h>
+#include <linux/sched/task.h>
 #include "test_ringbuf.lskel.h"
 
 #define EDONE 7777
@@ -22,7 +23,7 @@ struct sample {
 	int pid;
 	int seq;
 	long value;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 static int sample_cnt;
diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
index 167cd8a2edfd..f0748305ffd6 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf_multi.c
@@ -2,6 +2,7 @@
 #define _GNU_SOURCE
 #include <test_progs.h>
 #include <sys/epoll.h>
+#include <linux/sched/task.h>
 #include "test_ringbuf_multi.skel.h"
 
 static int duration = 0;
@@ -10,7 +11,7 @@ struct sample {
 	int pid;
 	int seq;
 	long value;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 static int process_sample(void *ctx, void *data, size_t len)
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c b/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
index 2b392590e8ca..f77d3b44ed35 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <linux/sched/task.h>
 #include "test_progs.h"
 #include "network_helpers.h"
 #include "test_sk_storage_trace_itself.skel.h"
@@ -15,7 +16,7 @@
 struct sk_stg {
 	__u32 pid;
 	__u32 last_notclose_state;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 static struct test_sk_storage_tracing *skel;
diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
index 123c68c1917d..133987217f57 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_overhead.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
@@ -4,6 +4,7 @@
 #include <sched.h>
 #include <sys/prctl.h>
 #include <test_progs.h>
+#include <linux/sched/task.h>
 
 #define MAX_CNT 100000
 
@@ -67,7 +68,7 @@ void test_test_overhead(void)
 	struct bpf_object *obj;
 	struct bpf_link *link;
 	int err, duration = 0;
-	char comm[16] = {};
+	char comm[TASK_COMM_LEN_16] = {};
 
 	if (CHECK_FAIL(prctl(PR_GET_NAME, comm, 0L, 0L, 0L)))
 		return;
diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index d7f5a931d7f3..4765b2ebd219 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -3,6 +3,7 @@
 #include <sched.h>
 #include <sys/prctl.h>
 #include <test_progs.h>
+#include <linux/sched/task.h>
 
 #define MAX_TRAMP_PROGS 38
 
@@ -50,7 +51,7 @@ void test_trampoline_count(void)
 	int err, i = 0, duration = 0;
 	struct bpf_object *obj;
 	struct bpf_link *link;
-	char comm[16] = {};
+	char comm[TASK_COMM_LEN_16] = {};
 
 	/* attach 'allowed' trampoline programs */
 	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
diff --git a/tools/testing/selftests/bpf/progs/profiler.h b/tools/testing/selftests/bpf/progs/profiler.h
index 3bac4fdd4bdf..7ffc801d790b 100644
--- a/tools/testing/selftests/bpf/progs/profiler.h
+++ b/tools/testing/selftests/bpf/progs/profiler.h
@@ -2,7 +2,8 @@
 /* Copyright (c) 2020 Facebook */
 #pragma once
 
-#define TASK_COMM_LEN 16
+#include <linux/sched/task.h>
+
 #define MAX_ANCESTORS 4
 #define MAX_PATH 256
 #define KILL_TARGET_LEN 64
@@ -14,7 +15,7 @@
 #define MAX_FILEPATH_LENGTH (MAX_PATH_DEPTH * MAX_PATH)
 #define MAX_CGROUPS_PATH_DEPTH 8
 
-#define MAX_METADATA_PAYLOAD_LEN TASK_COMM_LEN
+#define MAX_METADATA_PAYLOAD_LEN TASK_COMM_LEN_16
 
 #define MAX_CGROUP_PAYLOAD_LEN \
 	(MAX_PATH * 2 + (MAX_PATH * MAX_CGROUPS_PATH_DEPTH))
@@ -25,7 +26,7 @@
 	(MAX_METADATA_PAYLOAD_LEN + MAX_CGROUP_PAYLOAD_LEN + CTL_MAXNAME + MAX_PATH)
 
 #define MAX_KILL_PAYLOAD_LEN \
-	(MAX_METADATA_PAYLOAD_LEN + MAX_CGROUP_PAYLOAD_LEN + TASK_COMM_LEN + \
+	(MAX_METADATA_PAYLOAD_LEN + MAX_CGROUP_PAYLOAD_LEN + TASK_COMM_LEN_16 + \
 	 KILL_TARGET_LEN)
 
 #define MAX_EXEC_PAYLOAD_LEN \
diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
index 4896fdf816f7..fad39075e5ce 100644
--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -344,9 +344,9 @@ static INLINE void* populate_var_metadata(struct var_metadata_t* metadata,
 	metadata->start_time = BPF_CORE_READ(task, start_time);
 	metadata->comm_length = 0;
 
-	size_t comm_length = bpf_core_read_str(payload, TASK_COMM_LEN, &task->comm);
+	size_t comm_length = bpf_core_read_str(payload, TASK_COMM_LEN_16, &task->comm);
 	barrier_var(comm_length);
-	if (comm_length <= TASK_COMM_LEN) {
+	if (comm_length <= TASK_COMM_LEN_16) {
 		barrier_var(comm_length);
 		metadata->comm_length = comm_length;
 		payload += comm_length;
@@ -648,9 +648,9 @@ int raw_tracepoint__sched_process_exit(void* ctx)
 			kill_data->kill_target_name_length = 0;
 			kill_data->kill_target_cgroup_proc_length = 0;
 
-			size_t comm_length = bpf_core_read_str(payload, TASK_COMM_LEN, &task->comm);
+			size_t comm_length = bpf_core_read_str(payload, TASK_COMM_LEN_16, &task->comm);
 			barrier_var(comm_length);
-			if (comm_length <= TASK_COMM_LEN) {
+			if (comm_length <= TASK_COMM_LEN_16) {
 				barrier_var(comm_length);
 				kill_data->kill_target_name_length = comm_length;
 				payload += comm_length;
diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
index 2fb7adafb6b6..05cb40268887 100644
--- a/tools/testing/selftests/bpf/progs/pyperf.h
+++ b/tools/testing/selftests/bpf/progs/pyperf.h
@@ -6,11 +6,11 @@
 #include <stddef.h>
 #include <stdbool.h>
 #include <linux/bpf.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 
 #define FUNCTION_NAME_LEN 64
 #define FILE_NAME_LEN 128
-#define TASK_COMM_LEN 16
 
 typedef struct {
 	int PyThreadState_frame;
@@ -43,7 +43,7 @@ typedef struct {
 typedef struct {
 	uint32_t pid;
 	uint32_t tid;
-	char comm[TASK_COMM_LEN];
+	char comm[TASK_COMM_LEN_16];
 	int32_t kernel_stack_id;
 	int32_t user_stack_id;
 	bool thread_current;
diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 7de534f38c3f..acfe929fd32d 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -8,12 +8,12 @@
 #include <linux/ptrace.h>
 #include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 
 typedef uint32_t pid_t;
 struct task_struct {};
 
-#define TASK_COMM_LEN 16
 #define PERF_MAX_STACK_DEPTH 127
 
 #define STROBE_TYPE_INVALID 0
@@ -189,7 +189,7 @@ struct strobemeta_payload {
 
 struct strobelight_bpf_sample {
 	uint64_t ktime;
-	char comm[TASK_COMM_LEN];
+	char comm[TASK_COMM_LEN_16];
 	pid_t pid;
 	int user_stack_id;
 	int kernel_stack_id;
@@ -520,7 +520,7 @@ int on_event(struct pt_regs *ctx) {
 		return 0; /* this will never happen */
 
 	sample->pid = pid;
-	bpf_get_current_comm(&sample->comm, TASK_COMM_LEN);
+	bpf_get_current_comm(&sample->comm, TASK_COMM_LEN_16);
 	ktime_ns = bpf_ktime_get_ns();
 	sample->ktime = ktime_ns;
 
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
index 145028b52ad8..33bf5b1058e5 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <stdint.h>
 #include <stdbool.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_core_read.h>
 
@@ -26,7 +27,7 @@ struct core_reloc_kernel_output {
 struct task_struct {
 	int pid;
 	int tgid;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 	struct task_struct *group_leader;
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf.c b/tools/testing/selftests/bpf/progs/test_ringbuf.c
index eaa7d9dba0be..15bb2087371e 100644
--- a/tools/testing/selftests/bpf/progs/test_ringbuf.c
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2020 Facebook
 
 #include <linux/bpf.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 
 char _license[] SEC("license") = "GPL";
@@ -10,7 +11,7 @@ struct sample {
 	int pid;
 	int seq;
 	long value;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 struct {
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
index 197b86546dca..88c7f65a8f3f 100644
--- a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2020 Facebook
 
 #include <linux/bpf.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 
 char _license[] SEC("license") = "GPL";
@@ -10,7 +11,7 @@ struct sample {
 	int pid;
 	int seq;
 	long value;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 struct ringbuf_map {
diff --git a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
index 8e94e5c080aa..cd965e9f22f0 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020 Facebook */
 
 #include <vmlinux.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
 #include <bpf/bpf_helpers.h>
@@ -9,7 +10,7 @@
 struct sk_stg {
 	__u32 pid;
 	__u32 last_notclose_state;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 struct {
@@ -27,7 +28,7 @@ struct {
 	__type(value, int);
 } del_sk_stg_map SEC(".maps");
 
-char task_comm[16] = "";
+char task_comm[TASK_COMM_LEN_16] = "";
 
 SEC("tp_btf/inet_sock_set_state")
 int BPF_PROG(trace_inet_sock_set_state, struct sock *sk, int oldstate,
diff --git a/tools/testing/selftests/bpf/progs/test_skb_helpers.c b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
index bb3fbf1a29e3..cbe134eab8fe 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
@@ -1,10 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "vmlinux.h"
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
-#define TEST_COMM_LEN 16
-
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
 	__uint(max_entries, 1);
@@ -18,7 +17,7 @@ SEC("classifier/test_skb_helpers")
 int test_skb_helpers(struct __sk_buff *skb)
 {
 	struct task_struct *task;
-	char comm[TEST_COMM_LEN];
+	char comm[TASK_COMM_LEN_16];
 	__u32 tpid;
 
 	task = (struct task_struct *)bpf_get_current_task();
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
index 00ed48672620..e4938b3cdf7a 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_map.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2018 Facebook
 
 #include <linux/bpf.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 
 #ifndef PERF_MAX_STACK_DEPTH
@@ -41,11 +42,11 @@ struct {
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN_16];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN_16];
 	int next_pid;
 	int next_prio;
 };
diff --git a/tools/testing/selftests/bpf/progs/test_tracepoint.c b/tools/testing/selftests/bpf/progs/test_tracepoint.c
index 4b825ee122cf..eb6e84ebf704 100644
--- a/tools/testing/selftests/bpf/progs/test_tracepoint.c
+++ b/tools/testing/selftests/bpf/progs/test_tracepoint.c
@@ -2,16 +2,17 @@
 // Copyright (c) 2017 Facebook
 
 #include <linux/bpf.h>
+#include <linux/sched/task.h>
 #include <bpf/bpf_helpers.h>
 
 /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
 struct sched_switch_args {
 	unsigned long long pad;
-	char prev_comm[16];
+	char prev_comm[TASK_COMM_LEN_16];
 	int prev_pid;
 	int prev_prio;
 	long long prev_state;
-	char next_comm[16];
+	char next_comm[TASK_COMM_LEN_16];
 	int next_pid;
 	int next_prio;
 };
-- 
2.17.1

