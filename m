Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF68B447C28
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbhKHIoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhKHIow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:44:52 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E97C061570;
        Mon,  8 Nov 2021 00:42:08 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id o4so1240415pfp.13;
        Mon, 08 Nov 2021 00:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6++KCKHoOkIdPUGzqDXds0dkuPF6FNB6oWR8oahhSys=;
        b=oNyMzekTY5NND+AscBB2rXg9Zan40WDeRj5HKNAqxUk9AS+OAk0Qq+EBXhjAc8vUuX
         IeoVQnbiZaX9LC5+GYNSpFHqywCYtpMjgjyqiq3a1U/cwmCQWvoV/2riOc1Jkj/MdcdW
         ZjiYeejjt5P8sXrskvffKSFfjsSyCFKUjHjO3XBAdyByj23fB5sThsAakKSfXDS9Kcyt
         FqydpT2z2dD5vmm32Ws9n1Itbe42RtrI/19i0YiveR9vBf0lCgwq+C2kyCdB1ujX1SfA
         L2fB/i8XSM5JAlQgE6hXCdQWxLFEjnRTupof3P2koSqB/L88obzUNkTbWL8wBvj/xY6+
         tQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6++KCKHoOkIdPUGzqDXds0dkuPF6FNB6oWR8oahhSys=;
        b=Li0TifF5+78xSQDxndFDOMaxoiYZK691/raVAlcqno+XpWIgFM0rasYXNGb2fgk08p
         OB9foCLloaGbe801T+XhB/AazXqMcr6M+g/QmhDBQiFXFqN/ZRjRAxRM0dOgWvDeNPeR
         OcoF1eZvHut/legjyRzDzRA6MiyZY8Ss606hqARR16t3MX3vx2SFywhLcnXLAe/QN6ap
         3UjMxQlCn9g7z79HumrvdjyFZtPI3kvGW3zfccUNXE5kLvGJ0IRIlsURPhckm+3Il/TH
         VQCBRSSM4c2esqG1FAa7PGy0hqe8BEn3T1v0BAakQFuc9I8SZHH6vASHoLfdC9xNdRrs
         5YYA==
X-Gm-Message-State: AOAM533yMxKwWfFELew5jSAQxBZx7qOMobpShZuLe25fqqKKCDv9eiho
        P9ayOJPIHNhTu/+tU2Jvmks=
X-Google-Smtp-Source: ABdhPJy0ZP6LFCUQPAEPzR4keRP/tN6tZKYwcyJ8YfHlZTb4UDSMtByuaLHNwBBGrsc9XSSq8w5ooQ==
X-Received: by 2002:a05:6a00:23c4:b0:49f:e054:84cb with SMTP id g4-20020a056a0023c400b0049fe05484cbmr2232530pfc.63.1636360928135;
        Mon, 08 Nov 2021 00:42:08 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id y184sm8416042pfg.175.2021.11.08.00.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:42:07 -0800 (PST)
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
Subject: [PATCH] kthread: dynamically allocate memory to store kthread's full name
Date:   Mon,  8 Nov 2021 08:41:42 +0000
Message-Id: <20211108084142.4692-1-laoar.shao@gmail.com>
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
TODO: will cleanup worker comm in the next step. 

---
 fs/proc/array.c         |  3 +++
 include/linux/kthread.h |  1 +
 kernel/kthread.c        | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 49be8c8ef555..860e4deafa65 100644
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
index 5b37a8567168..ce8258231eea 100644
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
@@ -121,6 +135,7 @@ void free_kthread_struct(struct task_struct *k)
 #ifdef CONFIG_BLK_CGROUP
 	WARN_ON_ONCE(kthread && kthread->blkcg_css);
 #endif
+	kfree(kthread->full_name);
 	kfree(kthread);
 }
 
@@ -399,12 +414,27 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
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
+			char *full_name;
+
+			full_name = kvasprintf(GFP_KERNEL, namefmt, args);
+			if (!full_name) {
+				kfree(create);
+				return ERR_PTR(-ENOMEM);
+			}
+			kthread->full_name = full_name;
+		}
 		set_task_comm(task, name);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
-- 
2.17.1

