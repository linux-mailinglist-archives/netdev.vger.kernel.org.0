Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93E8457D57
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhKTLbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbhKTLbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:06 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45F7C061574;
        Sat, 20 Nov 2021 03:28:03 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u17so10132458plg.9;
        Sat, 20 Nov 2021 03:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NXvWr7/n/dn/qU7871k4jVbZ4yqRH7KsA6t+jNRxS5w=;
        b=bFQfNI4zaX/cX3ouONrppFc9YKLptBjPxzlAa57/2aqNreSUW7BufmQOVwKb8XlWx9
         MPi+O1PqfJ7sDMHSCZ+uGA/BeAy3Vm7WUNtLXqpgmK1RZH4znPl3WNx6PArY/fqfqi5z
         /7goWOQq36fVMpT4QPfQORv8H2cFJQ6bjnwqc7oDhaBhrPjQYRuG1zR18Dv4Suf7k+vy
         7SUtVnBYXMAW0rCY4p/HVSF01tnp0cDf9IDn4ZHiL2f3rChJWYRTU5YjMJfGvhOPGmUU
         fiaG8RIVrMWrz0TNV5tdYsxQTSY7dgxV+srOM8LSeDpzr4sYQi9aUff9ThJDz87hCR/k
         /gOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NXvWr7/n/dn/qU7871k4jVbZ4yqRH7KsA6t+jNRxS5w=;
        b=kqOCHakA4BHg4KPNFfonbzpe4/6sXkBFjcW/kQLL2Xe3ry7Xn49GKZNzQFEEfM7mZl
         66P148omv/IiuaMBMJmtZxp16xVKiqpkJzdOSbEEwgb21M23YAy73uJYSVfDieJzQa/Q
         Szx5fL/L0YQviHFTAHoT+uuGR+rg0fna+Jug2Sdm9CZYKt/h7U56thfleQ/UPMGCELyi
         XONitXmp1deTAft7iapkNgNQzfX+0puPY8GgGex8JvgT89q93NbTlggwwxDKhFByQPz4
         82D7+2pns1GqWtptj6hd4EMn+Byw/NjoC05mC434OSJNCdf4hM7D2PC08ns+361x6PEq
         FwVg==
X-Gm-Message-State: AOAM531Uzx1mykl/YeRvhuZ8p4eNFnAZOdZFG34fs8PufZwnoT7HLtkE
        tfSvNGhj/dUiY2ihgMjdpY4=
X-Google-Smtp-Source: ABdhPJwckAaKVrEN2V1fZZmajViBaj+hK5R4HtJRF86XY4oxgC2JPhuSPO4Kwsq5pBFTZqBgcv/o9g==
X-Received: by 2002:a17:90b:512:: with SMTP id r18mr9057016pjz.64.1637407683486;
        Sat, 20 Nov 2021 03:28:03 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:03 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 3/7] drivers/infiniband: replace open-coded string copy with get_task_comm
Date:   Sat, 20 Nov 2021 11:27:34 +0000
Message-Id: <20211120112738.45980-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'd better use the helper get_task_comm() rather than the open-coded
strlcpy() to get task comm. As the comment above the hard-coded 16, we
can replace it with TASK_COMM_LEN.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
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

