Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3210443917E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhJYIhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhJYIgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD5CC079783;
        Mon, 25 Oct 2021 01:34:10 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so10840189pjl.2;
        Mon, 25 Oct 2021 01:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3b5F5wGACMd69eL0I262MHV9xwxefmfYtcns+//hWu4=;
        b=EJ9gWHO/qDcGuCu2SsMmuJNFlQLwRCArk3fC9JGAfPmJ1R7j5Doski35qo1J9+YIyB
         xm9NVqk3GU9iu5jlaYJd0V9e7a6g2K/LS84Mg+54kw+yNvxF/aPBJ/k8tmCnuCjj8i1L
         LSU4qsZWYuEqhvhDGrqCW4TDzQIH1JQ58AeWQEgGKhJT8vza2qe/RJAzwOqkq11UUZjB
         PQz8nUzZNSW2Mr2C5W/gi2FvezUTcVW7PkRR84kUj4ri6G/5MYAdMVtDdLwezMSAw71C
         XedSRr/v//YmFqHoVS7TB3a0uqwPUD/gTPFY+yihxS6er+pf7khcm+JZC+5nn3DksKlg
         Fq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3b5F5wGACMd69eL0I262MHV9xwxefmfYtcns+//hWu4=;
        b=e9gycdtl5okXe99qzeBWeKgGI/SQfabpIDyNn5lt9edDvFpxS1/UMAx7xaly99FT/j
         VuMGNi5rOALKZV14F5n//DKQ990r00liclX0nwl0SF9NHJNrD8eAioQTZy3wKcHcYvNE
         QoIJS9SOi00q7/G60MIIWwjEjasc82qSdcPEdD72bAGuVPu0jPKid5JntbVfD/ElxLaT
         UQIGk9auPfUodRQTOBCB2DNbGmPXiVndpATxhYNhZlRwgtLP9r9stgcbxEYl4ibyfaFP
         Voim6FWR5MKhrA+RasZ4iQBB9GOZiEUC0sBDKycW8kY72f8UDVCVsrIewi0aB9wiEPw2
         YZNw==
X-Gm-Message-State: AOAM533hqUsDypp1IetCPIWTVNqD67ZjTqgN9pfGj1c26m8WLOxb38qZ
        U24JLBg8YNb6sLHD8yWodUs=
X-Google-Smtp-Source: ABdhPJyB546Sceoy6Mmun969JkLWcczoY+I0vjocLtE6F0/dLsge5k71yHQdO2hurNXalyhHA+nS/A==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr19162609pjb.1.1635150850050;
        Mon, 25 Oct 2021 01:34:10 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:34:09 -0700 (PDT)
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
Subject: [PATCH v6 12/12] kernel/kthread: show a warning if kthread's comm is truncated
Date:   Mon, 25 Oct 2021 08:33:15 +0000
Message-Id: <20211025083315.4752-13-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show a warning if task comm is truncated. Below is the result
of my test case:

truncated kthread comm:I-am-a-kthread-with-lon, pid:14 by 6 characters

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 kernel/kthread.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5b37a8567168..46b924c92078 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -399,12 +399,17 @@ struct task_struct *__kthread_create_on_node(int (*threadfn)(void *data),
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
 		char name[TASK_COMM_LEN];
+		int len;
 
 		/*
 		 * task is already visible to other tasks, so updating
 		 * COMM must be protected.
 		 */
-		vsnprintf(name, sizeof(name), namefmt, args);
+		len = vsnprintf(name, sizeof(name), namefmt, args);
+		if (len >= TASK_COMM_LEN) {
+			pr_warn("truncated kthread comm:%s, pid:%d by %d characters\n",
+				name, task->pid, len - TASK_COMM_LEN + 1);
+		}
 		set_task_comm(task, name);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
-- 
2.17.1

