Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4347439150
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhJYIgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhJYIgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3012C061764;
        Mon, 25 Oct 2021 01:33:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m21so10178681pgu.13;
        Mon, 25 Oct 2021 01:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rF1WxMESVJWbA0KjHUw1EAC/hqp6WgyH56B9+/ool+Y=;
        b=csPDI4HJ67TdymQQcsFexEUPoDgg26NWwNi/rwWaHt/rnz379QkpJRSIHuq8TVEgYg
         ZhbZz64XqUIshqzzWpYvuq3gi3XxxDhHFGfddtvJpFHmPX4Ut0V3sSa/Q8tOv+R7Q/pp
         +iHi5bc3UQLFoHCxJWLvyS2xNk9NzBIV0OY66qa2bm4wUd2q2xY8k4OtVhtaks7dMIO8
         KipeoYrJONCg77Yq+PAf7OmcVgY+dj6VBfnQMPDFXd9jjOWbgVTwxjQHhPU0in18pnyS
         1LQLX3U+daG5LZVaEJyKTVgal4lNpD8KR1aG2Jy0XkNCJs+RLlFcIaBscjzcwQwCX8Ql
         KcXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rF1WxMESVJWbA0KjHUw1EAC/hqp6WgyH56B9+/ool+Y=;
        b=1gRDNdSvV0YdmoredQpeq3yrhZJlgpYG1o8iCs1bXm62nbsMq2jJA48l8tH4suDH0G
         D9b3iVgY7W5OUyt7NiITry5Yj769xBNyxTw075WlqIArqS1jKfFvkHz3tl96lHMm0oNQ
         aUhTJS79krY3i9PDUJ2l+Q6Nuzx3/p4BllWmjXyNqIQZrWV7uhw4k6RgZN/R879QDd9W
         D2yWYIXViRr75pT16UGrxiNzslaeQ9G5Z2QVvX82ou1ix11YbWJIOVlpWx4FJdexC0s2
         R6CyLu5FhMxjuohsR46ZgllYYo6RRY/zd27EY3H9XNWrUdm2ho+gDDzLEFRps5t6XRzO
         5F8A==
X-Gm-Message-State: AOAM533NDU6wBCSMPmGcqjjmzWlAR8H8GHQiNF/PoeNhIWuoZ4ubNQxv
        Sbjkci9zjoDut4nrmBdc3c0=
X-Google-Smtp-Source: ABdhPJzmR7B3F/oDzpPz7UArNu9RJcw2YYz6E4xdldXe9GqTF0sfz89yReHIXFFjXn32SUShtQ07fg==
X-Received: by 2002:a63:1a0e:: with SMTP id a14mr12821120pga.195.1635150829344;
        Mon, 25 Oct 2021 01:33:49 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:48 -0700 (PDT)
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
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v6 03/12] drivers/connector: make connector comm always nul ternimated
Date:   Mon, 25 Oct 2021 08:33:06 +0000
Message-Id: <20211025083315.4752-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
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
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 drivers/connector/cn_proc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
-- 
2.17.1

