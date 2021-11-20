Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFE2457D52
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhKTLbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237407AbhKTLbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:09 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3450C061574;
        Sat, 20 Nov 2021 03:28:06 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r5so10918093pgi.6;
        Sat, 20 Nov 2021 03:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1oe3mAtCy57SvxrUI35nWEx465krMRGSksc4bk1sFUA=;
        b=a/Ogd1caJnHgyw92yP4+Sy5vg9y3tFva7RDUZp/KgaMgifhmecvr+CS3ys80EQHlnJ
         WZ5u82dkFpOU64C77RDhgKnWORvGO9aASyfYgZ8iECmn91ra5Kui4evt+zXaIhOiozmf
         +VOKAhz2d2SpD4OSdcg36Mh8+Kzb5KpISqIcFB9ZMtOE7ZkeBW9qhktknkE2d8HgFdr4
         +dMx6zIpDr0oBRy+CtHcwSzCqbnPnRhjGbuXLDVguG6jKSN3JFUfPk7YOpD+loAMk8wp
         xo2504Nj2+vqkp8K5xM3isUSUAm8s6VCBfDg9svez5WftmSq7sRq7lllAe4nJSwsgc3h
         HlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1oe3mAtCy57SvxrUI35nWEx465krMRGSksc4bk1sFUA=;
        b=maBjh1kpdFJIWSla4i6ySyZKxaYhnNyigleQtjI0bpUzCnLFaJlo54pgC59u65EOFt
         jhF57UPzFhUlFLQNheqoiK3BrivWTrg/YoZAQKOsmdwbshV/JThYl+wrP8/aVygbnBsk
         nK7ALocv7UOwSlpf3HKxdQDz7PpTMIzReXwHmptl/gG8VxmCUC6WcAjhXa95TDFfmFAi
         y1NCCFoibaz7goTQVobpa2cScpHqWRQBZ/JF+Muin4AblNwcj8Lq+Wl09NY0uPKFQ1zq
         2w290A1Ge0iWjW10zURVv/lbgCrbAcNhARxQ96jhjsmoSBsFdWx2K+ymk8Ys3EH953Y7
         tbOw==
X-Gm-Message-State: AOAM5326oLQJxdbCcHPRh39IUwVDgXAn3RUvoawqiNYEHJKM/GFJDpT5
        a7fv5npxxyMzlPzZnxlngz8=
X-Google-Smtp-Source: ABdhPJw0Uf72DJptZW3n7FKi3LSyrN0KvK2sEAoBl7vohdSAsCWbkjYS+ap+McxE+4c7YPsB0+ZG4g==
X-Received: by 2002:a05:6a00:848:b0:49f:b215:e002 with SMTP id q8-20020a056a00084800b0049fb215e002mr70218451pfk.47.1637407686283;
        Sat, 20 Nov 2021 03:28:06 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:05 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 5/7] samples/bpf/test_overhead_kprobe_kern: replace bpf_probe_read_kernel with bpf_probe_read_kernel_str to get task comm
Date:   Sat, 20 Nov 2021 11:27:36 +0000
Message-Id: <20211120112738.45980-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
we don't care about if the dst size is big enough. This patch also
replaces the hard-coded 16 with TASK_COMM_LEN to make it grepable.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

