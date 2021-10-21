Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F87A435959
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhJUDsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhJUDrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15838C061768;
        Wed, 20 Oct 2021 20:45:34 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h193so8968890pgc.1;
        Wed, 20 Oct 2021 20:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QORRqOHwrTwPIk1mXEbyzyPg28H9YEY40+Pmmc8asE=;
        b=V1HK9LH74t5jFt8aC0mQynUQ0OO5jCHgGHTNpaWFQ7MvGI6et/N8hKxn+fo0ROPbxI
         X24+vc6jVTq7SBPM7lpRMdzSkXXDvUvwkAEB9Ca288nYX+jdpV20GIBDRvxFJ3OadNKf
         cc0c+VBrnYfcHYSUxdpLpvNMRLxVlNewekDxhtpJtvYrKLskikR5v+I2CueBT4+hDeKV
         nLLDLVzSqdX+/mObPaUOvHrS2E481ot8B5QnnlaEgy7kf0DQZKK3cCnoQsfJgpfCzzSw
         HXQBpcQxdRBDH5PVrxFQ2PMsS2qk34pUvloDV4jFrL4TDJUkfWEytihrp1r8NFYlEww6
         SUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QORRqOHwrTwPIk1mXEbyzyPg28H9YEY40+Pmmc8asE=;
        b=3Uvqyb/GyCAbzq8aRqwoDIMCK8K/9qK1LrRzECf5TniaN5UMVxBVK5LW4N4QpP6DW1
         WPSIJ5AzjiRZbCyuBgGbapgUvlVNt5u4MfD4eW7R0ZqJRXnEYiErT8/MsogUBMbxpG6K
         WWEEOW1rouxwEKrhgasnDrEISYyM1bf4O9yauk7X47f7hVBYuhMO+dWeMOoZcBXE9aiY
         DYPWr2P3XQfEuovYr64HkWnkP37+vWo2eaAmx+esSD01pR4hOKjlBzOwoBEa5CnMLArK
         OiFrLWFdshDTpbQCwzmLm/UoPHLU7Eneqt4QDTrGNdXjFDNladSeRgj1i8Fc0BC/DIgG
         dE+A==
X-Gm-Message-State: AOAM530UquiW7qy6BhqIbeV/aLrGhZDJEAKycdcIIZArMPDLx5+uUyU2
        rVQKTjSgn4pSwwkKvrblUtQ=
X-Google-Smtp-Source: ABdhPJxgXH9/K7GGbnXQUIV8CFm64OPrsn3DTVS6Gg2yOvNluWfyUyQctqdOIdAI0ETLuFsED+j9yw==
X-Received: by 2002:a63:7d55:: with SMTP id m21mr2488194pgn.436.1634787933676;
        Wed, 20 Oct 2021 20:45:33 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:33 -0700 (PDT)
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
Subject: [PATCH v5 07/15] samples/bpf/kern: use TASK_COMM_LEN instead of hard-coded 16
Date:   Thu, 21 Oct 2021 03:45:14 +0000
Message-Id: <20211021034516.4400-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The linux/sched.h is visible to the bpf kernel modules, so we can use
TASK_COMM_LEN_16 to replace the hard-coded 16 in these bpf kernel
modules to make it more grepable.

In these bpf modules, someone gets task comm via bpf_get_current_comm(),
which always get a nul terminated string. While someone gets task comm via
bpf_probe_read_kernel(), which is unsafe, we should use
bpf_probe_read_kernel_str() instead.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 samples/bpf/offwaketime_kern.c          | 10 +++++-----
 samples/bpf/test_overhead_kprobe_kern.c | 11 ++++++-----
 samples/bpf/test_overhead_tp_kern.c     |  5 +++--
 samples/bpf/tracex2_kern.c              |  3 ++-
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index 4866afd054da..c0fd04497eea 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -23,8 +23,8 @@
 #define MAX_ENTRIES	10000
 
 struct key_t {
-	char waker[TASK_COMM_LEN];
-	char target[TASK_COMM_LEN];
+	char waker[TASK_COMM_LEN_16];
+	char target[TASK_COMM_LEN_16];
 	u32 wret;
 	u32 tret;
 };
@@ -44,7 +44,7 @@ struct {
 } start SEC(".maps");
 
 struct wokeby_t {
-	char name[TASK_COMM_LEN];
+	char name[TASK_COMM_LEN_16];
 	u32 ret;
 };
 
@@ -113,11 +113,11 @@ static inline int update_counts(void *ctx, u32 pid, u64 delta)
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
diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
index f6d593e47037..31e8c5ee0cdc 100644
--- a/samples/bpf/test_overhead_kprobe_kern.c
+++ b/samples/bpf/test_overhead_kprobe_kern.c
@@ -6,6 +6,7 @@
  */
 #include <linux/version.h>
 #include <linux/ptrace.h>
+#include <linux/sched.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
@@ -22,17 +23,17 @@ int prog(struct pt_regs *ctx)
 {
 	struct signal_struct *signal;
 	struct task_struct *tsk;
-	char oldcomm[16] = {};
-	char newcomm[16] = {};
+	char oldcomm[TASK_COMM_LEN_16] = {};
+	char newcomm[TASK_COMM_LEN_16] = {};
 	u16 oom_score_adj;
 	u32 pid;
 
 	tsk = (void *)PT_REGS_PARM1(ctx);
 
 	pid = _(tsk->pid);
-	bpf_probe_read_kernel(oldcomm, sizeof(oldcomm), &tsk->comm);
-	bpf_probe_read_kernel(newcomm, sizeof(newcomm),
-			      (void *)PT_REGS_PARM2(ctx));
+	bpf_probe_read_kernel_str(oldcomm, sizeof(oldcomm), &tsk->comm);
+	bpf_probe_read_kernel_str(newcomm, sizeof(newcomm),
+				  (void *)PT_REGS_PARM2(ctx));
 	signal = _(tsk->signal);
 	oom_score_adj = _(signal->oom_score_adj);
 	return 0;
diff --git a/samples/bpf/test_overhead_tp_kern.c b/samples/bpf/test_overhead_tp_kern.c
index eaa32693f8fc..a6d5b3301af2 100644
--- a/samples/bpf/test_overhead_tp_kern.c
+++ b/samples/bpf/test_overhead_tp_kern.c
@@ -4,6 +4,7 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
+#include <linux/sched.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
@@ -11,8 +12,8 @@
 struct task_rename {
 	__u64 pad;
 	__u32 pid;
-	char oldcomm[16];
-	char newcomm[16];
+	char oldcomm[TASK_COMM_LEN_16];
+	char newcomm[TASK_COMM_LEN_16];
 	__u16 oom_score_adj;
 };
 SEC("tracepoint/task/task_rename")
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index 5bc696bac27d..d70ce59055cb 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -7,6 +7,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/version.h>
+#include <linux/sched.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
@@ -65,7 +66,7 @@ static unsigned int log2l(unsigned long v)
 }
 
 struct hist_key {
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 	u64 pid_tgid;
 	u64 uid_gid;
 	u64 index;
-- 
2.17.1

