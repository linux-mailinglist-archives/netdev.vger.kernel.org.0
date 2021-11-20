Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C46457D64
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhKTLcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbhKTLcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:32:09 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E73C06175B;
        Sat, 20 Nov 2021 03:29:06 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id np3so9883604pjb.4;
        Sat, 20 Nov 2021 03:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uNX5FE2tZkxpuuqDEFiMRnO2iBatJ2sCTSVf95PnGcE=;
        b=c8gue+ynpuXN2yi3q0IDO2Y0JAfwSXqOX2jol0f2ra5ky3xAAhMluLSC5QUOwOkfN3
         BfB2rLij2g0IAv9NWAhXCEcf0qO/IdSBiv9ikhP43imiqp/ooKm9FcoqgM9oW9zXUyFU
         00v9F1uJuTUT+05/cy5XIYNn/RiSoLzkc3cREnwRtWgGZ6+R/N0kYEllnUsCPVm3yYCu
         FVwB4o0Mr96okvlTxxszIycaxnz5ti8XfkGiTtSSJePuj0SzfgQTnmb/WY7EtIiMaH4H
         /ei6d73j1KfhcT42VuFTqFoQMgcuByIvoE2bIvfzewbsW7/W3yHx/ahxCWfGSEnXnEf/
         7+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uNX5FE2tZkxpuuqDEFiMRnO2iBatJ2sCTSVf95PnGcE=;
        b=TeSTArxjXLFPuOjyy8SlTQuZ4VEliCLXSQM8xyotx1EhOqu5lBBpE1LEBNIjAzK/jQ
         PIk9LZe3KN6CE/wiAvhxWjWBLcARvkULLtxkPmJ2NT0YbLA0c4GaG7VPPmH3zFvpYfan
         xwbavNVn3k7Cjx+ev3+djFbD8NH9voO+TMNGsZq7L5vmMqgnxjT/XubZgURrDWJPuyiX
         f6YpY3Zv+lFoTPIxIWHrjmjQ9WT/Df98kVJzQ1JefZ5IObzM6S+uCYniAQrI74LZB3bx
         r2XOPgPmM8W6R4SZC+5TRjXOiX6QYju3RaGtvpnZnRMROxeCe6KiNQqjupdWfeOBr6/c
         EGcg==
X-Gm-Message-State: AOAM5312H81Qf4v2XN56ltodZT79GKNtVLS8ATPhMqq89FXWFldV1MuU
        n9L9Zk9tdc8KputsighvtoI=
X-Google-Smtp-Source: ABdhPJzCRsH8UL7H3bVFjOBc9LDXDnX2Dy3UE5TX9gb0bv/UzEO6CZxyldqc+7CjJu3BgBtksGH2zw==
X-Received: by 2002:a17:90a:ab17:: with SMTP id m23mr9412621pjq.194.1637407745940;
        Sat, 20 Nov 2021 03:29:05 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id g21sm2851745pfc.95.2021.11.20.03.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:29:05 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] kthread: dynamically allocate memory to store kthread's full name
Date:   Sat, 20 Nov 2021 11:28:50 +0000
Message-Id: <20211120112850.46047-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I was implementing a new per-cpu kthread cfs_migration, I found the
comm of it "cfs_migration/%u" is truncated due to the limitation of
TASK_COMM_LEN. For example, the comm of the percpu thread on CPU10~19 are
all with the same name "cfs_migration/1", which will confuse the user. This
issue is not critical, because we can get the corresponding CPU from the
task's Cpus_allowed. But for kthreads correspoinding to other hardware
devices, it is not easy to get the detailed device info from task comm,
for example,

    jbd2/nvme0n1p2-
    xfs-reclaim/sdf

Currently there are so many truncated kthreads:

    rcu_tasks_kthre
    rcu_tasks_rude_
    rcu_tasks_trace
    poll_mpt3sas0_s
    ext4-rsv-conver
    xfs-reclaim/sd{a, b, c, ...}
    xfs-blockgc/sd{a, b, c, ...}
    xfs-inodegc/sd{a, b, c, ...}
    audit_send_repl
    ecryptfs-kthrea
    vfio-irqfd-clea
    jbd2/nvme0n1p2-
    ...

We can shorten these names to work around this problem, but it may be
not applied to all of the truncated kthreads. Take 'jbd2/nvme0n1p2-' for
example, it is a nice name, and it is not a good idea to shorten it.

One possible way to fix this issue is extending the task comm size, but
as task->comm is used in lots of places, that may cause some potential
buffer overflows. Another more conservative approach is introducing a new
pointer to store kthread's full name if it is truncated, which won't
introduce too much overhead as it is in the non-critical path. Finally we
make a dicision to use the second approach. See also the discussions in
this thread:
https://lore.kernel.org/lkml/20211101060419.4682-1-laoar.shao@gmail.com/

After this change, the full name of these truncated kthreads will be
displayed via /proc/[pid]/comm:

    rcu_tasks_kthread
    rcu_tasks_rude_kthread
    rcu_tasks_trace_kthread
    poll_mpt3sas0_statu
    ext4-rsv-conversion
    xfs-reclaim/sdf1
    xfs-blockgc/sdf1
    xfs-inodegc/sdf1
    audit_send_reply
    ecryptfs-kthread
    vfio-irqfd-cleanup
    jbd2/nvme0n1p2-8

Suggested-by: Petr Mladek <pmladek@suse.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
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

Changes since v1:
1. leave it turncated when out of memory (Kees & Petr)
2. do null check in free_kthread_struct (Petr)
---
 fs/proc/array.c         |  3 +++
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 32 ++++++++++++++++++++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ff869a66b34e..4321aa63835d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -92,6 +92,7 @@
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
+#include <linux/kthread.h>
 
 #include <asm/processor.h>
 #include "internal.h"
@@ -102,6 +103,8 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 
 	if (p->flags & PF_WQ_WORKER)
 		wq_worker_comm(tcomm, sizeof(tcomm), p);
+	else if (p->flags & PF_KTHREAD)
+		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
 		__get_task_comm(tcomm, sizeof(tcomm), p);
 
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 346b0f269161..2a5c04494663 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -33,6 +33,7 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 					  unsigned int cpu,
 					  const char *namefmt);
 
+void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk);
 void set_kthread_struct(struct task_struct *p);
 
 void kthread_set_per_cpu(struct task_struct *k, int cpu);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 7113003fab63..a70cd5dc94e3 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -60,6 +60,8 @@ struct kthread {
 #ifdef CONFIG_BLK_CGROUP
 	struct cgroup_subsys_state *blkcg_css;
 #endif
+	/* To store the full name if task comm is truncated. */
+	char *full_name;
 };
 
 enum KTHREAD_BITS {
@@ -93,6 +95,18 @@ static inline struct kthread *__to_kthread(struct task_struct *p)
 	return kthread;
 }
 
+void get_kthread_comm(char *buf, size_t buf_size, struct task_struct *tsk)
+{
+	struct kthread *kthread = to_kthread(tsk);
+
+	if (!kthread || !kthread->full_name) {
+		__get_task_comm(buf, buf_size, tsk);
+		return;
+	}
+
+	strscpy_pad(buf, kthread->full_name, buf_size);
+}
+
 void set_kthread_struct(struct task_struct *p)
 {
 	struct kthread *kthread;
@@ -118,9 +132,13 @@ void free_kthread_struct(struct task_struct *k)
 	 * or if kmalloc() in kthread() failed.
 	 */
 	kthread = to_kthread(k);
+	if (!kthread)
+		return;
+
 #ifdef CONFIG_BLK_CGROUP
-	WARN_ON_ONCE(kthread && kthread->blkcg_css);
+	WARN_ON_ONCE(kthread->blkcg_css);
 #endif
+	kfree(kthread->full_name);
 	kfree(kthread);
 }
 
@@ -406,12 +424,22 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
 	task = create->result;
 	if (!IS_ERR(task)) {
 		char name[TASK_COMM_LEN];
+		va_list aq;
+		int len;
 
 		/*
 		 * task is already visible to other tasks, so updating
 		 * COMM must be protected.
 		 */
-		vsnprintf(name, sizeof(name), namefmt, args);
+		va_copy(aq, args);
+		len = vsnprintf(name, sizeof(name), namefmt, aq);
+		va_end(aq);
+		if (len >= TASK_COMM_LEN) {
+			struct kthread *kthread = to_kthread(task);
+
+			/* leave it truncated when out of memory. */
+			kthread->full_name = kvasprintf(GFP_KERNEL, namefmt, args);
+		}
 		set_task_comm(task, name);
 	}
 	kfree(create);
-- 
2.17.1

