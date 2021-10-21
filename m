Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8890A435981
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhJUDt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhJUDtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:49:24 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFB9C061753;
        Wed, 20 Oct 2021 20:46:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r2so24361012pgl.10;
        Wed, 20 Oct 2021 20:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mg/W5W6l0pcytUDlQ1aNCJcnr1/VYvxAUJDYpkY9L/c=;
        b=nCBNOEdF81o2V/ZOVUdV514sp3NllC5LbtK99UBMXWooz5rjDlFETHpYTA8A8T88Ip
         tAQjqAfaNMXWgtSyT+9Lje7Sn6b/fM6dUq96+o8dZ6TEn+3fpaggTvmtiO1ptoCNfgw+
         manf4GP+UAzTMRty33VBcUTjT6fxv2Xfusd7xEWkaShtHDiiTZ+OgCuVcCLaZDPYnhig
         YQFosMyYmS+c3bfNM/Y/F+aoj9wESBVhLNcV4mRJ3Wv1OuxxPQJDbga588ePtif5m3KI
         QT68h9quKWtAvhhjk2DwlXE7M3Zvj6Vxbhf4F3KyOiAEpX+Wk/Wr6LvMD2TrccAaHZjq
         JPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mg/W5W6l0pcytUDlQ1aNCJcnr1/VYvxAUJDYpkY9L/c=;
        b=m8EsTHcWtPm9nsIlZ9TaVxwdDb+x7Gm1qD3mVrugivc1OwSdwXkFfABM2n+//Hbmp9
         kSRpWWA8bUWg+PNJs2FmZVxQNI1JF/NNFSf3DzIria6Da3WjViMRUO8OsVp9dRldjCds
         F8Qr2+/JBXniN6q681szsKnnU/dyyp8BZAbmionzFjK0rtQU/yRfjW167FKuUtsD26z7
         T6y7mLikcODPm7tQiO9yolECChFfngJkMY5IUVm6QYZIKWUKLwvsTdvX0CmZEY+zfuyQ
         CDlINzjmc/vGyHYVX+xmkcT2HPfntGveYWFrJjP2EDOoYM1q4wgWjMx4M7zsIfSg82xS
         /9Yg==
X-Gm-Message-State: AOAM531dRpDTcoFv/BB0E3T9NAGtO7/3YLWN7sbbh6YY6vobIE6BDuad
        P3g2qtgEmoCzZcnV+rS2uks=
X-Google-Smtp-Source: ABdhPJw5Fj3ty7sa//4egXRyvTSsUWdMNkokVd4ZY+8Yz400yvz6Ngl1ciRpem81fOw6ilYWzxyVRQ==
X-Received: by 2002:a05:6a00:23d6:b0:44d:8426:e2bb with SMTP id g22-20020a056a0023d600b0044d8426e2bbmr2824167pfc.30.1634787978484;
        Wed, 20 Oct 2021 20:46:18 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id r25sm3454254pge.61.2021.10.20.20.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:46:17 -0700 (PDT)
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
Subject: [PATCH v5 15/15] kernel/kthread: show a warning if kthread's comm is truncated
Date:   Thu, 21 Oct 2021 03:46:03 +0000
Message-Id: <20211021034603.4458-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034603.4458-1-laoar.shao@gmail.com>
References: <20211021034603.4458-1-laoar.shao@gmail.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

