Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9846343596C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhJUDt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhJUDtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:49:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CBCC06177B;
        Wed, 20 Oct 2021 20:46:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id om14so3914384pjb.5;
        Wed, 20 Oct 2021 20:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjJP3DimDgks7hWDrA8JwS8YTX2Y7gTetS5OZvY1EDA=;
        b=XkNolsPY2aLe5iHSBVHU7zuSwZI5K1N6LxW+iNCjIq+Xm8mqishckErEdVXXh8fRPG
         XRpYW8wIiDqOwxBqM1KEHEzQmmW4E7yev9AgMWH9frtneXFcKC8lto0Y7hdLGie0JNtM
         LG8VcQv9D2DrpFEICnrzm/pFMQDq1JMunRAz/Q2U1WEE8G399/shavANVFouAygTX6af
         BuwpOQKBbgS1I1kwl7DART0KFbcbcXlj4XLpDEibwSgpYlhL3HqIyWElt19JIvIU+nHD
         P3CGvkGjuDQ8z9pK10I3yfRCLEgT2qj0n7kIDdNJy441n+sLCMpCPQA+4lcLm3ATEzfO
         XIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjJP3DimDgks7hWDrA8JwS8YTX2Y7gTetS5OZvY1EDA=;
        b=qiisi6wJ4tlESEZ0JNvMjVEnOi0Jnpc/s0bVZWLvCYzeZU0dTT3rUNUzXN3YQmFGQL
         yMmObMzL8oVUGQhm5UgsmWFYDObf1LJ9Z+UbMPD2f9Kv9dic/xnVhrtNG2OKeXXpM1jC
         NkBMZdf1oqarwArDTQzAfkPhyflct26IeH4SGPGsTf5K+ZvhK+cH37NvPXmSI9j0Bh3j
         IyPjhJ6JvYb3+r/DDbFxAxpj13dloIB5S1qJeiP3A7FUSoqPKTkrpT5axVXnP0dI2vwF
         xGnU9MO5JCvuS1ZCC7kEX5lHbwnU5gefKuUaqNnbfKOp2s2/YN2xfgWQJOQ03GNCjEcJ
         hdsw==
X-Gm-Message-State: AOAM533vf9me/86+X9sdWCGyA/f62QQ58cDkLveVcC6WvlLC0CoANqWA
        9HJS1aQ2xZFX3+9rjuVfJls=
X-Google-Smtp-Source: ABdhPJzlXA7n8PGW6KinCgDiW/UW8WlyOKxBrHKKzC/9Qdmta+x5F7RytimxpAqMnXISuer831vMyQ==
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr3684666pjb.144.1634787970627;
        Wed, 20 Oct 2021 20:46:10 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id r25sm3454254pge.61.2021.10.20.20.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:46:10 -0700 (PDT)
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
Subject: [PATCH v5 10/15] tools/lib/perf: use TASK_COMM_LEN_16 instead of hard-coded 16
Date:   Thu, 21 Oct 2021 03:45:58 +0000
Message-Id: <20211021034603.4458-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TASK_COMM_LEN_16 instead of hard-coded 16 to make it more grepable.
The comm is set in perf_event__prepare_comm(), which makes the comm
always a nul terminated string, so we don't worry about whether it will
be truncated or not.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/lib/perf/include/perf/event.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 4d0c02ba3f7d..ab22b4e570c6 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/limits.h>
 #include <linux/bpf.h>
+#include <linux/sched/task.h>
 #include <sys/types.h> /* pid_t */
 
 #define event_contains(obj, mem) ((obj).header.size > offsetof(typeof(obj), mem))
@@ -47,7 +48,7 @@ struct perf_record_mmap2 {
 struct perf_record_comm {
 	struct perf_event_header header;
 	__u32			 pid, tid;
-	char			 comm[16];
+	char			 comm[TASK_COMM_LEN_16];
 };
 
 struct perf_record_namespaces {
@@ -291,7 +292,7 @@ struct perf_record_itrace_start {
 
 struct perf_record_thread_map_entry {
 	__u64			 pid;
-	char			 comm[16];
+	char			 comm[TASK_COMM_LEN_16];
 };
 
 struct perf_record_thread_map {
-- 
2.17.1

