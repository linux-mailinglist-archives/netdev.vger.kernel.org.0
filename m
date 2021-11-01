Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2AE441371
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhKAGHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhKAGHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 02:07:12 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483DBC0613F5;
        Sun, 31 Oct 2021 23:04:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id h74so1417841pfe.0;
        Sun, 31 Oct 2021 23:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o3r423UmuBw5jHyHMAFihSOkgDAeE6bhihnHvX68874=;
        b=LMNo4W3TjV5llf6jnlGy9NTRwR+hoKt0QLv5GmrPdv3tnhWv9SWc7CJ7IPQ25LBnzk
         bcRtJNIrFLRYdb+nwHDIMCzxk8OcTqZj1+KQoDpEpEyi4CNOYzHG7irT+iMD/qus1bRP
         gJpNr3rEp+9oEiUuNaizI1x0DMWAc3vLy2WnsYbX1+wB63+hqz8QVD8LDeRx0SgfgqKw
         29ejtUEHKc/vPJ8SAql+Fv/wLIFhF7PSo8w1Ydn9qX+mHD0mR9MnwZ+am4lPfe/PBi3u
         mJbBqphRMOFBQ/gfkyGl+Ss6tcUTIXKBTaH7ednulSWrpVWbdBFxaDEy0u77cY4ekOZz
         EDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o3r423UmuBw5jHyHMAFihSOkgDAeE6bhihnHvX68874=;
        b=4kDLVy6fi03MtQMae0GXUuUZGKvT/KUe5XndsaWgvG8i2O87eDUjbWPOpX6LxTt0jP
         L39PQ3+btavrdPpSlpAaTGPoh9cmpfGYYGXWag7ulN1Na12paPJFmQsoAEjca4jxbfni
         5gR490TNwaQFsBWtl9V6D5e5rwSOJsAI0js6JTYwE6UPGb0hlX7K6h39ux6roj6rxaA4
         fDVMahbJXOcTwV/iH21BG5DUL8ERR5hpvNSWsgCGR32QLywTvl5LrLz1V8MO8uTzY5FS
         4OjkHMHYbNtilf+h0RutrCFN1/8mc3Ynf1eRZ83j3eQ/euj6ZKNc6SLqt07qMBv8MlSs
         toAQ==
X-Gm-Message-State: AOAM533SbDH1jvzzb+7nnHfwRjEVtiHAcuG+OdeYTX98zZZOjF6/rM9/
        5lF0+kYk73gOWL9c+r1iMHQ=
X-Google-Smtp-Source: ABdhPJxaybbOZX2waEJCer7qTNlHbiwvvo3L2vD0OkVD9dD70R5sF0i0k+8R93jpwPu6/vpMsOcejw==
X-Received: by 2002:a05:6a00:2311:b0:431:c19f:2a93 with SMTP id h17-20020a056a00231100b00431c19f2a93mr26982527pfh.11.1635746678877;
        Sun, 31 Oct 2021 23:04:38 -0700 (PDT)
Received: from localhost.localdomain ([144.202.123.152])
        by smtp.gmail.com with ESMTPSA id g8sm3277586pfc.65.2021.10.31.23.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 23:04:38 -0700 (PDT)
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
Subject: [PATCH v7 04/11] drivers/infiniband: make setup_ctxt always get a nul terminated task comm
Date:   Mon,  1 Nov 2021 06:04:12 +0000
Message-Id: <20211101060419.4682-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211101060419.4682-1-laoar.shao@gmail.com>
References: <20211101060419.4682-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use get_task_comm() instead of open-coded strlcpy() to make the comm always
nul terminated. As the comment above the hard-coded 16, we can replace it
with TASK_COMM_LEN, then it will adopt to the comm size change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
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
index 63854f4b6524..aa290928cf96 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -1321,7 +1321,7 @@ static int setup_ctxt(struct qib_pportdata *ppd, int ctxt,
 	rcd->tid_pg_list = ptmp;
 	rcd->pid = current->pid;
 	init_waitqueue_head(&dd->rcd[ctxt]->wait);
-	strlcpy(rcd->comm, current->comm, sizeof(rcd->comm));
+	get_task_comm(rcd->comm, current);
 	ctxt_fp(fp) = rcd;
 	qib_stats.sps_ctxts++;
 	dd->freectxts--;
-- 
2.17.1

