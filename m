Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4268644138B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhKAGIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhKAGHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F17EC061220;
        Sun, 31 Oct 2021 23:04:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso681469pjb.0;
        Sun, 31 Oct 2021 23:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LvSuBTtzWbrXgjb4RLiUJa0DKbJeUJhJDjpVybnmpmo=;
        b=Mons/lRRxlmoaqOVtmFZnSu86Gkf5r4H5cY0kniY9gdH+szl8upHhpaZR7MR4xQ4tw
         dE2pI6UqL1jzYM4vvLqKghrUPQDn79hRqU7KxiMF+5YggE6jafzi9LymBwddjrin53xA
         DS/vBbsVNijV75Vx09TumG5j4U1GZmxVHVKUrh58sYOCTTMBcRzBvqBQmlqQjnp9UiE6
         CSWjjS2dsqFC7BDjyMH2pF3tVsU6TtlHkUNzoI8cXteZR0F4qZ685VNLWN0UoeXzxvyY
         29Os19nVMJ2skD60ZUbljxErtaiTL7ovw6A0gtYiuQbZsZ494tasBFvKYe9V+eptBdn1
         Gtvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LvSuBTtzWbrXgjb4RLiUJa0DKbJeUJhJDjpVybnmpmo=;
        b=Bz66TtPRSWcDegBj4jP7PKAeZsZxeB7kQy8Vq1BHUwiIVeEA6XTlqbQhwpkU+kmOp5
         xamIhZMa3j3/pEbg8FMu9ssTWMXsbi1qkZRCDTs1BFQgEWk+2GC9VR1QOS6qemtVBE8l
         B90H2Q4k8uH/jqmKDzJlUleAP42DhqZTmDb3pXVT1HMVJ4L4doXgjOJGvfNb3UlkViq5
         TaFTPcvhB6OAFv5cGRrqUucgLh467TgavzWDmKCsrk0dmVLFHnuA5lxwvzgEE9OM3V/U
         ukBmG6BMDTmUwaAkmJ6n4LLQNhcqlODWNw4tVaT24J2P1E/56yfOZvV3ZrU8IVedbqDa
         Fnfg==
X-Gm-Message-State: AOAM532eyZHcHrIS9rE2jNz6K+MdjkMd+8FUs09r9Yq5zKYSnEHJbX9S
        djXgG/VhVI5p42+OKRyUDaU=
X-Google-Smtp-Source: ABdhPJx4c5pscRjAJUsqapKZZ8TRE5l4wRfA5yn4IJZjx67PGHHeSXi7SUSuCfLV4PBYO3mVczta1w==
X-Received: by 2002:a17:90b:3149:: with SMTP id ip9mr33599543pjb.45.1635746692795;
        Sun, 31 Oct 2021 23:04:52 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:52 -0700 (PDT)
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
Subject: [PATCH v7 10/11] sched.h: extend task comm from 16 to 24
Date:   Mon,  1 Nov 2021 06:04:18 +0000
Message-Id: <20211101060419.4682-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
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

We should improve this problem fundamentally by extending comm size to
24 bytes. task_struct is growing rather regularly by 8 bytes.

After this change, the truncated kthreads listed above will be
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

As we have converted all the unsafe copy of task comm to the safe one,
this change won't make any trouble to the kernel or the in-tree tools.
The safe one and unsafe one of comm copy as follows,

  Unsafe                 Safe
  strlcpy                strscpy_pad
  strncpy                strscpy_pad
  bpf_probe_read_kernel  bpf_probe_read_kernel_str
                         bpf_core_read_str
                         bpf_get_current_comm
                         perf_event__prepare_comm
                         prctl(2)

Regarding the possible risk it may take to the out-of-tree user tools, if
the user tools get the task comm through kernel API like prctl(2),
bpf_get_current_comm() and etc, the tools still work well after this
change. While If the user tools get the task comm through direct string
copy, it must make sure the copied string should be with a nul terminator.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
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
 include/linux/sched.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 09ac13e54549..a8822e26653e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -276,10 +276,11 @@ struct task_group;
 
 /*
  * Define the task command name length as enum, then it can be visible to
- * BPF programs.
+ * BPF programs. The TASK_COMM_LEN_16 is kept for backward-compitability.
  */
 enum {
-	TASK_COMM_LEN = 16,
+	TASK_COMM_LEN_16 = 16,
+	TASK_COMM_LEN = 24,
 };
 
 extern void scheduler_tick(void);
-- 
2.17.1

