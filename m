Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA97343915D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhJYIgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhJYIgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:20 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C21C06122A;
        Mon, 25 Oct 2021 01:33:57 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c4so10185932pgv.11;
        Mon, 25 Oct 2021 01:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0MARTQhRayCcJOXrt50qrZSWHcrTOqEBviMLv+qW86Q=;
        b=XP9d6g5akaizE8xXosLToU+YDFW2+ji6UQwvG9rY0KePWcCtYWku40Pftn6MNFy6ip
         vn2fAFRhM2XEAKVYSUOXMorB9/KfaXT5tIoXXEQO4+QGgcoJMtoUh1GL6ACnYpUx6+3C
         QWv23PsERcEm/e+kNkJeknBljJ82nng5FtIei5wWu5KnnZsjLSmcD0c/G7mOTvMYxc7r
         FDpVDKE+aQraRJ2VZ/WII3FFKGCj75F4Se9RsMn23gkqa7b8qz8f+bE8VohWIdLZDA8L
         r77tFIHw52606BnHROajGx+deZ42CI20qBGSU6LCXqjGc1MuIlzzx5bY9H37DUsYIIvm
         cgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MARTQhRayCcJOXrt50qrZSWHcrTOqEBviMLv+qW86Q=;
        b=egbhd1kOY6kAuHk547oF/0Cp6FXgoF3hKOXX5yC/js2+tGZMYcem87931LOgj+5lYZ
         DfX99U64HXZMg0s0jIcV4HucBkvUedOIRAqDjWDMJ6v8jd37GMFZC0chGPRxW1qsHuS0
         2+KwBH2ku5trnD2ep2ezodCclR1rTjTKfh3KOFE+/uT8ynsMsx304Wgh9YD4YMmCk1dq
         jO7SG/Lx/XHRMumKTFpbbx8utIKtpK4Xb9vo/W4LYg36LZAR/EIi2VJYtKh479yvMWUE
         pV1/R6HYrgoAMhxmvyKKBlvIqKy3iqrOQH+gqd58Jh03TyhAZ9OB8bg5WdFkboyG9qKm
         8cbw==
X-Gm-Message-State: AOAM530NYLosPv2jzL/oWrNWnDNX/usWJOp+ydmI5pf+hCriyyxcSlAd
        Hi2yqVNsoKO7XAcrF/ltf7Q=
X-Google-Smtp-Source: ABdhPJw+MS/fFYKdGRF6+qFNhT0P9QZUUEFfE9dLlDbmgJIuvaqC53bEnXgTwCqGCnrhahx5AU6oUw==
X-Received: by 2002:a63:7504:: with SMTP id q4mr12363197pgc.103.1635150836561;
        Mon, 25 Oct 2021 01:33:56 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:56 -0700 (PDT)
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
Subject: [PATCH v6 06/12] samples/bpf/test_overhead_kprobe_kern: make it adopt to task comm size change
Date:   Mon, 25 Oct 2021 08:33:09 +0000
Message-Id: <20211025083315.4752-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
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
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 samples/bpf/test_overhead_kprobe_kern.c | 11 ++++++-----
 samples/bpf/test_overhead_tp_kern.c     |  5 +++--
 2 files changed, 9 insertions(+), 7 deletions(-)

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

