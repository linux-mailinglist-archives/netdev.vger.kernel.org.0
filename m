Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54D5435979
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhJUDtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhJUDtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:49:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC8BC0613E6;
        Wed, 20 Oct 2021 20:46:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i1so958921plr.13;
        Wed, 20 Oct 2021 20:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0yM3sBzVJixym6Pyyba7mfqYZoAEZb2k8KizyPSP7kg=;
        b=RBw5omD4rTgpJrDE/tF+65u3aiUUhbDOjoxYbOUTHLFsfzRCE1qLcza3dSQSuVNI9x
         yF4Rv2/3XR1+nsVOwkxJWIeuqgR8C3VcwQcCdU+q+hrFIAEEkfojFwHV5SSDlODMV7wD
         Mg5hYwDDJUQS44dzlc46KJxWu33Q+ADcSFvpUJBAomHNtUFnd8YHwF+ThysyEXXq9PJf
         BemE8OTfob3ebmojHzE0pKT/udvY799lkaP2MVbPwq7KVGJQ1w03aj0fSkmeod98u3Om
         gIH2TvQtYBYmddoWcGYRYg8zpNyFg0MTuSO4IRoDXuzXdLDJcsFbabi0At9po1agLjxj
         gNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0yM3sBzVJixym6Pyyba7mfqYZoAEZb2k8KizyPSP7kg=;
        b=izgIHKy7yJ4Nzs6J5w9kzu8lnBFIax+A6dO3vMqwLXedzP690Fgin6hcmsvwFtZ218
         +h5z/mK0N2+mgO8EWyEBf8HBi/1enSmUUY8q9RfAx6+B0sFtgg4AAepLGzobKYpIlXrU
         HrdksSQBJmOHOsqVQQc63DgEQ2o3BY5uq9KGl8p+ifusB4Ac7F+n13D7eIx0Cj8l3uMZ
         UnKb4xk37WeAaTBxEBmrmo011cjSlPW+WJHLF0IUoxbO2n5FH4ma4xcYpLwSqUSUldDm
         FMHKbxjkpziAZcOo75LDlWCPsNcLTR81f/w1FaAKGj2J9VMd85A9DU5Vwi6oTuC9HVEw
         YHTQ==
X-Gm-Message-State: AOAM530qiLSdCq1ZM9ZMZMWa+SM1hVVb0jJU3INahcsSTNcZ+cISL/0x
        eraDNHWPG+4k3oTVUN2L/VE=
X-Google-Smtp-Source: ABdhPJxUL9qjB7igAdeOyZKwIJlugL1A0condl4sE5mTHamDXIGLy5/Lf+hpbqa+DOy9OirQoWCv4A==
X-Received: by 2002:a17:90a:2a0d:: with SMTP id i13mr3517622pjd.166.1634787976727;
        Wed, 20 Oct 2021 20:46:16 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id r25sm3454254pge.61.2021.10.20.20.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:46:16 -0700 (PDT)
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
Subject: [PATCH v5 14/15] sched.h: extend task comm from 16 to 24 for CONFIG_BASE_FULL
Date:   Thu, 21 Oct 2021 03:46:02 +0000
Message-Id: <20211021034603.4458-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034603.4458-1-laoar.shao@gmail.com>
References: <20211021034603.4458-1-laoar.shao@gmail.com>
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

We can also shorten the name to work around this problem, but I find
there are so many truncated kthreads:

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

We should improve this problem fundamentally.

This patch extends the size of task comm to 24 bytes, which is the
same length with workqueue's, for the CONFIG_BASE_FULL case. And for the
CONFIG_BASE_SMALL case, the size of task comm is still kept as 16 bytes.

After this patchset, the truncated kthreads listed above will be
displayed as:

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
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 include/linux/sched.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 62d5b30d310c..fcb4bc97f95c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,10 +274,17 @@ struct task_group;
 
 #define get_current_state()	READ_ONCE(current->__state)
 
-/* To replace the old hard-coded 16 */
-#define TASK_COMM_LEN_16		16
+/* Also to replace the old hard-coded 16 */
+#define TASK_COMM_LEN_16	16
+#define TASK_COMM_LEN_24	24
+
+
 /* Task command name length: */
-#define TASK_COMM_LEN			16
+#if CONFIG_BASE_SMALL
+#define TASK_COMM_LEN		TASK_COMM_LEN_16
+#else
+#define TASK_COMM_LEN		TASK_COMM_LEN_24
+#endif
 
 extern void scheduler_tick(void);
 
-- 
2.17.1

