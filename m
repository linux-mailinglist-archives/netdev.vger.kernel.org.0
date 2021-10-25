Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C9439177
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhJYIhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhJYIgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCDAC061764;
        Mon, 25 Oct 2021 01:34:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t11so7395236plq.11;
        Mon, 25 Oct 2021 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w7dW1iNbq1Wg2WuKYJlcYSndnkowZDcd1bFguHKF6IE=;
        b=U4i0No+EGDrlJQePYnoMIOFXR8R7nulw7jyU+4G06XBewuwtvRrbzHuzPd0qpgHOFA
         pcSNEIYL3ncWLV8C32z/LvGr7OsnV7o61Qie1FqPfkGj7vpzYELToUSZmNo8Ip3dZUhz
         BuCnVkXiLGcsBJG19c95EuFLLvDshR/dOYVCczQwJYqtgiKMU5TCBGR2iKr/JtqfF1vT
         N91zQnWaAmVc1UkEqkyAkH4BeiRGW/2Z9EzoW1rr9B6FWkZMUznOG6iyw/6c14qRkPRl
         kDbqpSwf19sWPYlrUhhTt1F1eI4WPYl7Yt7KKN1smPCDtwaZ03fW7SO6+/A/myUKSpDh
         mMVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7dW1iNbq1Wg2WuKYJlcYSndnkowZDcd1bFguHKF6IE=;
        b=MOQ9s1WrBJhhX6OVSS3MOLQ/1wjPB18rAfdHeFVZz6ktA5PMz7EiLSSBOKjmY4eeaI
         6BqqVLVKT6dx1cGPZZ+9Vgx1r9x6tJ3mdBMhk97vrk4Uz40DJlQszYwYoW3DLkHawHVe
         AXiSRKYmJT3yWq9TseBqMv2UdE08kZ8m+ybLMBBI0NtB91KqrEzMOpM1HKbs5YVR036r
         SM6Q21QN7VArP4zGP83AjWt3KN1+MHUpWaXSNiV5n+pSIjt3L8RzRu4F+8Suo16tRkK0
         cz/yxne34ZuAt/uMOdxmM3uHL9bqIVoDHhOK4cqPQZiTJJjPGaOBYC+oLViNN8KxDq20
         kOuQ==
X-Gm-Message-State: AOAM5328bG048KxIxZWmmyqPKSYfryI9WraC1E86g1fqJ2ddLL4hWMtf
        y4gp1USvtOHjHQUoUxOroh0=
X-Google-Smtp-Source: ABdhPJwFC4zTTp4l0K+QrkkRFDcEYhrKjwwpL/YCU9oKIw4H/35xwZzLIb7TJAj/167JmR/qYIhF5g==
X-Received: by 2002:a17:90a:4890:: with SMTP id b16mr19994866pjh.82.1635150847878;
        Mon, 25 Oct 2021 01:34:07 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:34:07 -0700 (PDT)
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
Subject: [PATCH v6 11/12] sched.h: extend task comm from 16 to 24
Date:   Mon, 25 Oct 2021 08:33:14 +0000
Message-Id: <20211025083315.4752-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
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
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 124538db792c..490d12eabe44 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -279,7 +279,7 @@ struct task_group;
  * BPF programs.
  */
 enum {
-	TASK_COMM_LEN = 16,
+	TASK_COMM_LEN = 24,
 };
 
 extern void scheduler_tick(void);
-- 
2.17.1

