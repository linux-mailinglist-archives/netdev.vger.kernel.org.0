Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F10F435953
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhJUDsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhJUDro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889A8C06161C;
        Wed, 20 Oct 2021 20:45:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso3936884pjw.2;
        Wed, 20 Oct 2021 20:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pevXqfzk0a9mco3A0IBMgl8TtIgUhm0DLJ2rQWdresY=;
        b=IVwXWPNp0IB5AtbRdxHUftVBA0ZHtHlUfYqroePI4Bxa5n4Ma6otf2aJulMSuhuuKb
         K8CZmXaK9cs+CruHG4RH2qzM1AI1JA7J3iE41C8D4uTvGuWuhzLdhHUJHInTFpK43vKP
         4HtzYVm/t41Lswbr0WKIpitoFeFuNg+ZT8hWSHi9RlVeEfTPxG4kwGtLRTgOzRxJdoUW
         TbA8cDOX3VNZ3RK4zzU/kVAE7BdFLcrYEoFZgBbP6F0bWBvYQ/v0WERZOB7b9vRrcNSM
         GpuyMj2lxGjmoYaFk8k5By37qtykRrLVhcNRViPcofYw1EcA0FQiFE0IwTMvXfX+5e6N
         SzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pevXqfzk0a9mco3A0IBMgl8TtIgUhm0DLJ2rQWdresY=;
        b=YgHQNYIt8nKRln6sxNqEQuJsGtRhltipSkWbUwGytK95ONbyAGiUD8/77tBEt65wbN
         wX2VBDWm8woFIzP2T5xJVa93rWM98uRBc8LlJKqwr3ncJKWkOaMl0Vz4Y+RI59Qb5MzN
         Lvuc95/P3HnzpJoQgr5PM/k/Sm4Vo4z1sSqYt9/QMPDGVADGVCDZ6zl27PZgEH643Ath
         /BgPk3anv8xg/V94g/j8KwHUy820TuK63iTZw22bATwB0SwwvONhFyf5245qIc1RZGw9
         RRpif33ANCHeg4yahtKgNOLgCmsB4kY6sXkUDeYp2axwSp4jaJAcYGceCpRoUuxaB918
         c2rg==
X-Gm-Message-State: AOAM533hmEY7n6F+xQAaFKKZHtV13Uuk7UwPYVibJjOvu/JrhxSdYAN5
        lw8XmjHJ+Q7CmDcnM3+SfwM=
X-Google-Smtp-Source: ABdhPJzp/IAql6drxO3acK8js1zsIW44wduMnkGkdnmstbT+jEsLlxRzHZdGqHVLATuxVGcoPrc6Pg==
X-Received: by 2002:a17:90b:2494:: with SMTP id nt20mr2200494pjb.19.1634787929138;
        Wed, 20 Oct 2021 20:45:29 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:28 -0700 (PDT)
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
        Yafang Shao <laoar.shao@gmail.com>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v5 04/15] cn_proc: make connector comm always nul ternimated
Date:   Thu, 21 Oct 2021 03:45:11 +0000
Message-Id: <20211021034516.4400-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

connector comm was introduced in commit
f786ecba4158 ("connector: add comm change event report to proc connector").
struct comm_proc_event was defined in include/linux/cn_proc.h first and
then been moved into file include/uapi/linux/cn_proc.h in commit
607ca46e97a1 ("UAPI: (Scripted) Disintegrate include/linux").

As this is the UAPI code, we can't change it without potentially breaking
things (i.e. userspace binaries have this size built in, so we can't just
change the size). To prepare for the followup change - extending task
comm, we have to use __get_task_comm() to avoid the BUILD_BUG_ON() in
proc_comm_connector().

__get_task_comm() always get a nul terminated string, so we don't worry
about whether it is truncated or not.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 drivers/connector/cn_proc.c  | 5 ++++-
 include/uapi/linux/cn_proc.h | 7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 646ad385e490..c88ba2dc1eae 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -230,7 +230,10 @@ void proc_comm_connector(struct task_struct *task)
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
-	get_task_comm(ev->event_data.comm.comm, task);
+
+	/* This may get truncated. */
+	__get_task_comm(ev->event_data.comm.comm,
+			sizeof(ev->event_data.comm.comm), task);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
index db210625cee8..4bb7f658fcc0 100644
--- a/include/uapi/linux/cn_proc.h
+++ b/include/uapi/linux/cn_proc.h
@@ -21,6 +21,11 @@
 
 #include <linux/types.h>
 
+/* We can't include <linux/sched.h> directly in this UAPI header. */
+#ifndef TASK_COMM_LEN_16
+#define TASK_COMM_LEN_16 16
+#endif
+
 /*
  * Userspace sends this enum to register with the kernel that it is listening
  * for events on the connector.
@@ -110,7 +115,7 @@ struct proc_event {
 		struct comm_proc_event {
 			__kernel_pid_t process_pid;
 			__kernel_pid_t process_tgid;
-			char           comm[16];
+			char           comm[TASK_COMM_LEN_16];
 		} comm;
 
 		struct coredump_proc_event {
-- 
2.17.1

