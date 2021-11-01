Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F0344137F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhKAGH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhKAGHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:33 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6897C06120B;
        Sun, 31 Oct 2021 23:04:43 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 75so16328164pga.3;
        Sun, 31 Oct 2021 23:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CZbW1Aleg8hcQ6oriKfCOVzwEMQjjmsZLoOFChfxiOE=;
        b=hLIVcr6CSGMn7q+duUxCWW0eGrpmQBAmB6Wq4FCLbLyQvr2Upd8TZDDWhXwETwIru5
         gVsFVTteDomWNPaucmxRqkCCuS8WRWbKXTXFS4O738YFeGYfE7jLWgBhWcP5Wyl3Ixx1
         e9YODtfNTOnD4iIYhMk9WCAiID1UqwO6uuIqcXKNmu7EhFjFVJ/VFfeT8r6Dr1npBbY7
         zyuY/z7kwCaKGMOzNmsXif+LtjafxWuoctWRkorVboIJqLwC2HTMPIEGJO5cyPXEJAeh
         sgohILu4rfKSjNpvEjhK4xvo6H+wsmaaOY6Ipo4srFpfRbzLHJNYJVKU90aLM7DlOEJ/
         4Qrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CZbW1Aleg8hcQ6oriKfCOVzwEMQjjmsZLoOFChfxiOE=;
        b=uwrfkDDJuATNgmtGsB8YLWZ2e20Hg1M+FUgUeoLyPC4LRzN+vM/No+LykePhwvGpDF
         m9pk49EyFROd3T+k4z89+ZCR3PQ5kpcv7zkQnbMBbVPJUr8xhATBGZd6hSHEaWYo0Aix
         a/KsgUPXv4XwjyDbHU/2C6rYe+7AVVgl8ebGJjuSAKRtThzKykEuZvRAz0MNODoqCd/3
         +i99jy0FqWiOK3NdCjCZr/o10Xyq5SX+mA+ZvzHBVl3Ip0DVBFr5ceIWsOhbP6mHOXQa
         r9q1uTnWaL6Hw63A+v2Dcf6Qdw/m3AaChis8bGUuJycoYzJSWcNRYcMG033iQk3HMa4n
         2Alg==
X-Gm-Message-State: AOAM532r06wRdBecCggO9q/ygmu7Sl1r6cSheTAWn1WnI+sjyLYnODWJ
        7TWof55FHSV/URUY2gzErLQ=
X-Google-Smtp-Source: ABdhPJy5ahFUxXTC3lwrjdq2rffkJFK0bqTnEW/fg2sOG/fpUs8BcRn22EW5Z/8v2ha5HNBZ374p9Q==
X-Received: by 2002:a62:e510:0:b0:44c:e06e:80dd with SMTP id n16-20020a62e510000000b0044ce06e80ddmr27033507pff.48.1635746683498;
        Sun, 31 Oct 2021 23:04:43 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:43 -0700 (PDT)
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
Subject: [PATCH v7 06/11] samples/bpf/test_overhead_kprobe_kern: make it adopt to task comm size change
Date:   Mon,  1 Nov 2021 06:04:14 +0000
Message-Id: <20211101060419.4682-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
we don't care about if the dst size is big enough. This patch also
replaces the hard-coded 16 with TASK_COMM_LEN to make it adopt to task
comm size change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
 samples/bpf/offwaketime_kern.c          |  4 ++--
 samples/bpf/test_overhead_kprobe_kern.c | 11 ++++++-----
 samples/bpf/test_overhead_tp_kern.c     |  5 +++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/offwaketime_kern.c b/samples/bpf/offwaketime_kern.c
index 4866afd054da..eb4d94742e6b 100644
--- a/samples/bpf/offwaketime_kern.c
+++ b/samples/bpf/offwaketime_kern.c
@@ -113,11 +113,11 @@ static inline int update_counts(void *ctx, u32 pid, u64 delta)
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
diff --git a/samples/bpf/test_overhead_kprobe_kern.c b/samples/bpf/test_overhead_kprobe_kern.c
index f6d593e47037..8fdd2c9c56b2 100644
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
+	char oldcomm[TASK_COMM_LEN] = {};
+	char newcomm[TASK_COMM_LEN] = {};
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
index eaa32693f8fc..80edadacb692 100644
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
+	char oldcomm[TASK_COMM_LEN];
+	char newcomm[TASK_COMM_LEN];
 	__u16 oom_score_adj;
 };
 SEC("tracepoint/task/task_rename")
-- 
2.17.1

