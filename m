Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DFF435943
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhJUDro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhJUDrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:41 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537E6C061749;
        Wed, 20 Oct 2021 20:45:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e65so21954956pgc.5;
        Wed, 20 Oct 2021 20:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mDqWI6DfAAoDrLo3HMtLvXltC73eryXlWAxq3memVRQ=;
        b=oQDNAwXWou41LOl80lo8mym0MDCLiuHjXO7v9kWV3cgDj69RcxN4Fqi/YudxpJ4JvP
         4pLuXYNMaqjt43GVYo3zEp/KhSW3inmk6rKcfH6RjMgIiAiCV4ACc88Zm7UKGy19fXKr
         oEJtYq3eUQ4TSR0lEQ96UVlsitDmgApqgujoQi57xKjYI3qEjXO1AOVhhMGgYBvQPyA2
         H9Rz/OJ4XIOxXrsUUqKtijGWQRZYt7eBPr04TKafbfBYE/mYK4+9io4dd/tVMwcCMA1t
         pJlJfvxQEhus0IFpNSu/p3E42PGM+pbOokwU4nf/D8lMJ4mUXlQtMVGzQhDJeTA7H/gV
         HGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mDqWI6DfAAoDrLo3HMtLvXltC73eryXlWAxq3memVRQ=;
        b=ZOMoDemTgGoJJlNpH9HphLa3DOeHkkmglTOo3QU28JRZXVb4KFLC8VRJxUGRrdEnrL
         EQrb3FGQyzMb+2F7Q9NewkWRVMcWG5BN8jeOKDYhqu+XwugEZqsbW9IEH0XvUbAHcKUi
         mxZL/y9U7V8mIaEmm0JgY0wXlxGQ4cfdfV3R5drqIcYOhzQ+Xf6nlh1O0YWrxDVnzA8R
         dxKeoT0yJ1TAa5o6vyHqa4k6GMnN31D2877YfwYBum2i1RSsQfWXsACa1vtWF0YbdeZK
         h+d/UPEqje6bDGfTf6iHRi1MU921MwtJclSqNNJ7gyJAWACV8JhMIZMA2iyl5RPF2kZI
         kRuw==
X-Gm-Message-State: AOAM531cfImUqcWBQmN2ziiIyXthn0VDpj8Fq9/G9xX8lWA7UsfvP8/X
        cB0lGEVsmMfKwe53xbA7LWo=
X-Google-Smtp-Source: ABdhPJzt12FbvYv0cicHz5ns1lHPJX4II4BhTrW6My4SGjQ6OedpZBZQ+woR9E5vRQ1Xp8+0MpZ2Sg==
X-Received: by 2002:a05:6a00:1686:b0:44d:50e:de9e with SMTP id k6-20020a056a00168600b0044d050ede9emr3012092pfc.4.1634787925875;
        Wed, 20 Oct 2021 20:45:25 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id bp19sm3651077pjb.46.2021.10.20.20.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:45:25 -0700 (PDT)
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
Subject: [PATCH v5 02/15] fs/exec: make __get_task_comm always get a nul terminated string
Date:   Thu, 21 Oct 2021 03:45:09 +0000
Message-Id: <20211021034516.4400-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034516.4400-1-laoar.shao@gmail.com>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the dest buffer size is smaller than sizeof(tsk->comm), the buffer
will be without null ternimator, that may cause problem. We can make sure
the buffer size not smaller than comm at the callsite to avoid that
problem, but there may be callsite that we can't easily change.

Using strscpy_pad() instead of strncpy() in __get_task_comm() can make
the string always nul ternimated.

Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 fs/exec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 404156b5b314..bf2a7a91eeea 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1209,7 +1209,8 @@ static int unshare_sighand(struct task_struct *me)
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, buf_size);
+	/* The copied value is always null terminated */
+	strscpy_pad(buf, tsk->comm, buf_size);
 	task_unlock(tsk);
 	return buf;
 }
-- 
2.17.1

