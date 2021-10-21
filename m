Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F96435947
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhJUDrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhJUDrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:43 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C9C06161C;
        Wed, 20 Oct 2021 20:45:27 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a15-20020a17090a688f00b001a132a1679bso2130747pjd.0;
        Wed, 20 Oct 2021 20:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yf2NA38E7HKQh3ZYZFbNhGoKPtNwpPAehy4wTF5rYbw=;
        b=WVDgEDcA6KG/3I8xJsCT5rM/9VEakGIavjAQJNDeLjTLTQSb+a+nrxflwc7YKGtx8y
         xyD8IFwuTFIMqw4o0L6Q1yGVc1WdMnR4+MJlTUaoGw8IRB+smDqlCnlvjiPB5Bfv6IbG
         arMXnuqzbvvD0+/NYHfkYUbURjxE8zVyqXMixtuBangeQgXt4DsHAnmIfSoxlUGst2w2
         yQuOEJmpvKcdCHRxb2QEiYAhZf3rgRnY0PUtRJ9P4Y6bEWpvEV7EBQi745at1CSic/C2
         t6FkL3l+AH9p459kgn0orPiPFoILcANQm9P9vFkKlDff7hTs1OatRa1pjJjSnLgUteHR
         giZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yf2NA38E7HKQh3ZYZFbNhGoKPtNwpPAehy4wTF5rYbw=;
        b=PTonhinuaJRQgwvomji+L/2+/IflpsIRr/XioZFoRi99N6lT0PzD48E7hfNQyG3Wq0
         8Co3Qrr7fwAyQCTnVzkKn7FYai7dLCmIsK6oAI+F3vXFlLhEQ06cIeogxGH+eIf6FkBy
         Rz+j4bs7EG3alUzRED8z3+/gWj1emnyTERvA0cIldQpaHlzwNfpJwyUsf8IpCEgQ6n9W
         aj/tFO/+RrjjGJrUK69jsywgRKB5E10jHYht7q8z4h0grRf6k/zqMhFZWRexLCDC+SOt
         XNzrZIQtYRW9pYofFYwpuKG3AC9mpvxlr2N0LO3TQMAU+1ZICMkDfDwX+H4FaTmFFcwK
         uCgA==
X-Gm-Message-State: AOAM530kr9IRQ+skDENR7PYERC3pBM2Xpkdooe2+D2mWhAQ2Bh9VwT9P
        YZY0jMo3nPn1oH+Ce2uMjws=
X-Google-Smtp-Source: ABdhPJxz3hWBQRlpWrPqkNFFP9tU24MK5z/srBRYoQg7h3+iIRdWFNb4CHP8AYDtAUhSGM0Ey9N4YA==
X-Received: by 2002:a17:90b:4a4d:: with SMTP id lb13mr2877701pjb.122.1634787927391;
        Wed, 20 Oct 2021 20:45:27 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:27 -0700 (PDT)
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
Subject: [PATCH v5 03/15] sched.h: introduce TASK_COMM_LEN_16
Date:   Thu, 21 Oct 2021 03:45:10 +0000
Message-Id: <20211021034516.4400-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There're many hard-coded 16 used to store task comm in the kernel, that
makes it error prone if we want to change the value of TASK_COMM_LEN. A
new marco TASK_COMM_LEN_16 is introduced to replace these old ones, then
we can easily grep them.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 include/linux/sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c1a927ddec64..62d5b30d310c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -274,6 +274,8 @@ struct task_group;
 
 #define get_current_state()	READ_ONCE(current->__state)
 
+/* To replace the old hard-coded 16 */
+#define TASK_COMM_LEN_16		16
 /* Task command name length: */
 #define TASK_COMM_LEN			16
 
-- 
2.17.1

