Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05174447C14
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbhKHIm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhKHImW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F212EC061570;
        Mon,  8 Nov 2021 00:39:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u17so15265491plg.9;
        Mon, 08 Nov 2021 00:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jSlXXIvd0FywhZ4leAmyX2SHSUDRm+0RxBzeZkFzbpI=;
        b=Im28rp9XZJVVYG76ls5CqFtvjq2gljvzbc9rZU3ARBdC5+xQuecNb+Sms+SQDRvOKh
         YSHUapNu+KdWfRyPfBzBFTke/XN8qiPCPenebYiJ2qIGSXPB0GJ42DaNwNFW6LkNI42w
         JEu18GjmyoDXk/SnKYtXdySTbIxRTz0smS5nVNxyziUmQYZY7lpZzO/N64YUP5Kfu9yJ
         AMbvhSghgNadSnz4R7k6XWGiUYvn+r5cFGyuSZ4AHP9W1Yf6fbtDDBLcS1bnDzpJSbgH
         lDlRNItLb1Nvp9GtPa6e0FcpM90k459DZ79L/7Tb9ypPMa0FtgqX4nKb4vfg53LCWHyV
         +PQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jSlXXIvd0FywhZ4leAmyX2SHSUDRm+0RxBzeZkFzbpI=;
        b=aLZxgVkLjR4juXE795B5opGZGVacPD1DQ9sWstn5wZDskTtWMOqsq6ViSTdwRwOMch
         QGuXepSJCzWm0w0uih04DIfamBYWTS2hrKAzpsWJ3dAXzeSfKKsiUvEt9lU4jmc8Gpil
         tBqf1eGw2dfkwVgEAPnWBsCYthU8fm2O0b6CkRnU9T2po57Ouag2FcgTNzbUsoaPRXvx
         O/8qi/yv5R8g2W2ojWY7QjPcbSYSxAyIYLqq8MnCkZCZNwHod9ef8JsYEEIhK5e2QXcT
         D5C3p3cTLalL6+g/5VK+Bbt/fkuR5mjBozm9L2FMFizezsFi8xDvSIhnZODLCpnVbLZ4
         90bg==
X-Gm-Message-State: AOAM530TQutyK5kntK9wQpPfFHH9UHx8DjqGVfAlQ8k5wvzzdVc5dLOS
        q8x3DINaDeZP5E+mPWVahs4=
X-Google-Smtp-Source: ABdhPJwHdtguH7BTx2jF0cGrpR7hI4JYLc1SvyMBQXEVmZZVFrQPprVDTIGCrHOR5Gsk913+KDh2SQ==
X-Received: by 2002:a17:90a:6b0a:: with SMTP id v10mr49960820pjj.130.1636360777605;
        Mon, 08 Nov 2021 00:39:37 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:37 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 3/7] drivers/infiniband: use get_task_comm instead of open-coded string copy
Date:   Mon,  8 Nov 2021 08:38:36 +0000
Message-Id: <20211108083840.4627-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

