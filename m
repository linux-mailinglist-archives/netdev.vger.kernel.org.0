Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40687439154
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhJYIg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhJYIgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:14 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C46C061243;
        Mon, 25 Oct 2021 01:33:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so10206201pgc.6;
        Mon, 25 Oct 2021 01:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UmL9mpq7ehorzv6mgqkv4FtNwEi5vXpR3ERUyc8B1Bw=;
        b=f163QO/wIMQJPdoOkjqjFlNKMvqBZPsmaXtbryyYsIponOQR+Wm55Kffl/PqBvwbrX
         2/bBGcHDjPpzSIG3jHCU6R3yJhNS+wQbdOfhoARB4yOocKMk8a+JNUVgk+/tBmA4q/Dk
         l2yEM/9ONmEYqiekXtJh3uOggqoVLCw/FP+bgYRLjIi0LhlqKy097NOWqtKsk6NXpKS3
         DpSR3iN0FMse4S3PFGXm4G87lI8Mmg9ix/Wnyy1UPCWTHShXVchuDPcZwYV22SwmY06V
         niK8f1/1wZOqhierpRxnaj0S4IqCJQpLRQvmAo27zHXjVn6dlNf1WWEL8El50f1yFTzK
         O1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UmL9mpq7ehorzv6mgqkv4FtNwEi5vXpR3ERUyc8B1Bw=;
        b=QH8bpyiTfJQeJIoEZJtyIOb3AZuufBPSn40DcZ3Cp4tti39Xr5X1BctRZGk4AqGU84
         zC1giYJmM6cFC9OiKThr8yxrFfevr8e29gfVXlDhaMNjVBzVo8s9Bg4YkfPfq+L1eJ9u
         suuWwkBHyTSwHYAG/F0GKhxmTvmQe5IvHHf5OaRzhvPBTO5TRtruaT2CmmM3wC3CM/RJ
         +e0W5HZT5SoZYDC0+H0qkyb03nc0TVJ1AvNQzKF4Vyt55g1Eu3C3xNSYPJ9f4lbtDODl
         jH6v5jate7e4h0+SvPSy+IhXHZYuPGgV9PN9zrDXfC7FF03PXeXE2viiA6C4hh+Db369
         SDVw==
X-Gm-Message-State: AOAM530zJCpAJWg5/ZnWTLxu35wyJdrq1hrpJtiB/LBSVgqL0XkDmwZK
        MrnF4wcWq7pPeQNp97Xc+KM=
X-Google-Smtp-Source: ABdhPJwx82IKjZxf23iOo5e3UwoMZbq9DUsUmXnmSmClvglJWBA7mwqyIOKzLfgPYkxV6YLTaw9Few==
X-Received: by 2002:a63:3c5d:: with SMTP id i29mr9097063pgn.59.1635150831602;
        Mon, 25 Oct 2021 01:33:51 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:51 -0700 (PDT)
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
Subject: [PATCH v6 04/12] drivers/infiniband: make setup_ctxt always get a nul terminated task comm
Date:   Mon, 25 Oct 2021 08:33:07 +0000
Message-Id: <20211025083315.4752-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use strscpy_pad() instead of strlcpy() to make the comm always nul
terminated. As the comment above the hard-coded 16, we can replace it
with TASK_COMM_LEN, then it will adopt to the comm size change.

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
 drivers/infiniband/hw/qib/qib.h          | 2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 9363bccfc6e7..a8e1c30c370f 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -196,7 +196,7 @@ struct qib_ctxtdata {
 	pid_t pid;
 	pid_t subpid[QLOGIC_IB_MAX_SUBCTXT];
 	/* same size as task_struct .comm[], command that opened context */
-	char comm[16];
+	char comm[TASK_COMM_LEN];
 	/* pkeys set by this use of this ctxt */
 	u16 pkeys[4];
 	/* so file ops can get at unit */
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 63854f4b6524..7ab2b448c183 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	rcd->tid_pg_list = ptmp;
 	rcd->pid = current->pid;
 	init_waitqueue_head(&dd->rcd[ctxt]->wait);
-	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
+	strscpy_pad(rcd->comm, current->comm, sizeof(rcd->comm));
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
 	dd->freectxts--;
-- 
2.17.1

