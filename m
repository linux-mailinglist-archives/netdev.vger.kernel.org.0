Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638AF447C1C
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbhKHIml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238146AbhKHIma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:30 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A771BC0613B9;
        Mon,  8 Nov 2021 00:39:46 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b68so4649582pfg.11;
        Mon, 08 Nov 2021 00:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQqHvCs2MTZ23pzaDipnjVEuJT5n+/mnDeqlR4J5X1s=;
        b=FBNJQvD8VIJ6uUEzs0CTS/FbDDoXwoxs2R7wK/wQUA0G2/b5AyxLoDfdGh03PKDWoh
         kirsgwnEtgFvH6YXH4cHpV8TPoKMeouBoBiC9HBeYFy6mXZeKNYDruFrgxtOtagUaCHp
         laFxG90tvGykBeri7hkDoLFRwQRQskQEs6ahxhAKpWhI94I8pbssT34fAVk2dErfHPdn
         Xf0SmxbL7jOttaxJa1IyBdg3ONVLHFeSxEz8eeUXOFQyOYVn+s2HEuNodd0VQ6V5JfsJ
         qYDap4v3ZeSpmUjay38ZhsC6COJgO0aa9XaUvqaVMeLsiWjO63ipYlCWpCk6Sng6QqLT
         XycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQqHvCs2MTZ23pzaDipnjVEuJT5n+/mnDeqlR4J5X1s=;
        b=a2AHFc4nCS+UR4fCGywTT3SrkljPYeRKNASRyQtF+78jVbuVLSOQA6DhTPj2RJcbWE
         ToeIhtINIl4rou93yuy9VlIw6wsvnzHFSPJ+nrrDP2Jv9XaeV690MmMit51DpNxZrTMS
         7OEToKfYhSPYgQGl8R9odtNinLHwLxvOXbe10zxXW7n+y5oVEYCeQPZR7/7fmxogmbzH
         GLrpagOHDoEiX3EeEi/SkygmbS1uu9aVwdZTZ7QyWq+kRTyvLLPE6ewrp6SBsdAzEUxV
         1LFE0yG3ahxYvrTxNcn6j9hVfbXIIBz1AB0MOFHO4PtiXS7wVSPYt+xIbWXOX6WuVxtd
         cFmg==
X-Gm-Message-State: AOAM532johcmL5PFwwy20/GniVslMKVwQ/AwwKnbF6BvbT0ZkpIorkJV
        qNXA2S1cJUQw0HS0Ui1D32M=
X-Google-Smtp-Source: ABdhPJzC5TIvVeUxW/sa1XCq0pzyQv39+eD9OWLIs5cika5zyfhxlNpP9FYB8kkiEly2ft4BYkpcVA==
X-Received: by 2002:aa7:96ba:0:b0:49f:c35f:83f8 with SMTP id g26-20020aa796ba000000b0049fc35f83f8mr10317791pfk.47.1636360786296;
        Mon, 08 Nov 2021 00:39:46 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:45 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 5/7] samples/bpf/test_overhead_kprobe_kern: make it adopt to task comm size change
Date:   Mon,  8 Nov 2021 08:38:38 +0000
Message-Id: <20211108083840.4627-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
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

