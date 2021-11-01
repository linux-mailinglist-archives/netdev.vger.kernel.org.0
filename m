Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D2441361
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhKAGHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhKAGHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3937FC061714;
        Sun, 31 Oct 2021 23:04:32 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so8469706pjc.4;
        Sun, 31 Oct 2021 23:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jvb/C5XEaJIeXrLXfpoEk1LkH8WdHTYd7IpTBiq7fdU=;
        b=QzDoHhHVbtF/bMpHfWbGSlGfWhrLJ3uom/bYNboWDxPau83NZSUbxcsyS3VC0UFwNm
         IYFWwZxp+p4qvZ5D2tK0osULt9fSRrn39+6+qRP+w8MHRqyPsENAX3Qbce93XloeW0b7
         bhZt0u3DwNeykH6ljwHZncNhJdpGAHRDhJ+vIJ5DBB7n6lBWqcVSVnF3oo2IyGW0E2kq
         JGcTLy1m5V0sKMiuH0G7VtSf8DXS60yNBtgOiW7rsb0a+93/1HmKSOD1N4EI+UEMmIzY
         d2ig8smuUy3ycMA8HdA6saon+W6X9JZ04Wu2GeG9I6XPzrEbZl3+/fmY4uZ51gpf30GP
         lfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jvb/C5XEaJIeXrLXfpoEk1LkH8WdHTYd7IpTBiq7fdU=;
        b=plSWlPFiegA4DXLYdGmQ8H80+yBa1zLZs5rjg3FgYMVG7uI/I22dj0ai88yHMtoafA
         OvjuS3vqLgDqYGJPmI8DsvvOr+qnQRRTSYI7+DfNYDu7TwTOu5zYOQW3bS3q3mxGY3cp
         SzRB/gBgwgW88o24spqvA4dmT+cgq4ojjfUPfSKi9xeXKgthMBRiUNoWbVAX3RJmOuj5
         UMXE/M8LnTCjCScjI9vCzRstnG/4HQxwoCEfT7ODUa6A7PIvhMuD0Ldd/V3cEtyUSk2X
         aHtujJJntasDmcvHeMKOJXgeQRBwAcxeRvLGngS0BoNpgr9iehD8T2HUKQrkuczkOjC8
         fsLA==
X-Gm-Message-State: AOAM532768AUKzgzYetxW2Z0V7SgcOKFGlJFScaVAf7Ixfx7NmWJCcpV
        iw+cK9IeclNM6PvuJGC3HzI=
X-Google-Smtp-Source: ABdhPJz8UISjP4gb7nXyp0XisjyBJXUE5NhjaTe21LGX2ejW8wzAuI9dQOwUx1G/kySMdPO2jta5Ag==
X-Received: by 2002:a17:90b:30c6:: with SMTP id hi6mr16797530pjb.201.1635746671810;
        Sun, 31 Oct 2021 23:04:31 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:31 -0700 (PDT)
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
Subject: [PATCH v7 01/11] fs/exec: make __set_task_comm always set a nul terminated string
Date:   Mon,  1 Nov 2021 06:04:09 +0000
Message-Id: <20211101060419.4682-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the string set to task comm is always nul terminated.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index a098c133d8d7..404156b5b314 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1224,7 +1224,7 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk, exec);
 }
-- 
2.17.1

