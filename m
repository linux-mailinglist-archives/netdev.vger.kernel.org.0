Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD3B435954
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhJUDsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhJUDrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:46 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A198C061749;
        Wed, 20 Oct 2021 20:45:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f11so4678978pfc.12;
        Wed, 20 Oct 2021 20:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oLYk/nD4kzrtWbwdTYVlHSm8i/eV6joSd3D35BwjCQk=;
        b=aaiMYPCQn+0hi5MXqNtDnJEfzrMZUorhEEnTJ6rfRf0JnQGB8IoIWJEx7LdOiZ8uqY
         8NRxGR0aYJ8ix53+oUUnf2qcs3hWmqA+gt/VWU/a6/1Q9qyGgc9viYz4LFiApzUOmEGA
         MCtOLZC4wEHSiZ2EviisDOKWo8gzv52k2udp1tRaG2lW6mZX/QTQ0h0Bj1hq7tVqRJ62
         d45Mwwlb5p2uEutRRn0PhUogqhXSqODxf04xpfrJQE9oqEclaT2TnMB52ev3OdnjQGLm
         WJuPBvOsCnhIYqFG03W5rHa2+I8/abTa1nFZfDIlyB+u3HVkAemuBA8CzOOJV/F/KwQh
         hrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oLYk/nD4kzrtWbwdTYVlHSm8i/eV6joSd3D35BwjCQk=;
        b=ou2+g7UfOy/b2jOeGWvQ/OK3gemMhiBAJ4D8kcXcnTrWeQxFIlqRd9lIr6xE6mGL9T
         geLfH9GlRfewgMo5biSUTsoN/E6PRZMf4XGA+og+nbXNa/S2wfWucA/Fw7S27mNMD7TW
         dp+hNBtiGcut+wLJ9f2F9Cw2Xka4flTGqQ5LHpWEQ0UtDF/+dypagix+j/HNldcnzhWl
         O5km1OfEwhK5F4OPzjq8QgOo+GHKp9Gu10Ge8FBfpwFxzKN4qdaqSJi5BWd9Bn7v3olS
         rOBHxf/7fxB21gt0PRr5QKkXDqRfHezv5kwhebC/ww9VkiWD/CYaM6ym5xxAU2+rjSax
         0StA==
X-Gm-Message-State: AOAM533UlWoTbFrMgwcv/4Uwb+0gN3sHRnXmHM7VEhWFEt3yNDYDFKfE
        rHcDPRBWv8JE6/ALMqM99m4=
X-Google-Smtp-Source: ABdhPJwjAK6tR17GoaDLDsq/wwuZQycmJQypGuO/d9ZCYYtL/8SMkeO0WSuTCg3UZQT6eNsXzVijxw==
X-Received: by 2002:a63:920b:: with SMTP id o11mr2481210pgd.314.1634787930634;
        Wed, 20 Oct 2021 20:45:30 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:30 -0700 (PDT)
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
Subject: [PATCH v5 05/15] drivers/infiniband: make setup_ctxt always get a nul terminated task comm
Date:   Thu, 21 Oct 2021 03:45:12 +0000
Message-Id: <20211021034516.4400-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TASK_COMM_LEN_16 instead of hard-coded 16 to make it more grepable,
and use strscpy_pad() instead of strlcpy() to make the comm always nul
terminated.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 drivers/infiniband/hw/qib/qib.h          | 4 ++--
 drivers/infiniband/hw/qib/qib_file_ops.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 9363bccfc6e7..8e59f9cbabc8 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -195,8 +195,8 @@ struct qib_ctxtdata {
 	/* pid of process using this ctxt */
 	pid_t pid;
 	pid_t subpid[QLOGIC_IB_MAX_SUBCTXT];
-	/* same size as task_struct .comm[], command that opened context */
-	char comm[16];
+	/* task_struct .comm[], command that opened context */
+	char comm[TASK_COMM_LEN_16];
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

