Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6754439145
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhJYIgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhJYIgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:07 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5B0C061745;
        Mon, 25 Oct 2021 01:33:45 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id f11so10013309pfc.12;
        Mon, 25 Oct 2021 01:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tb2DLSHt7yEoDSj1xonLMAUM0KyNZsEaGyv5bBEUpu8=;
        b=oYlyi3lonUU6Fa8XZ2e7zj+Xij1FY4rsdKgLByteR1YoxJaXWn0b+9E04KwplgPwen
         Nsyc4c9ZtY3k38kLVKWr4UpYSbaABNZRdpSExH5nuGb3+YWWsIS4+YyBPSUGBFurjTCU
         E0r982qEh5Dd3WP8mqTWX1MQoiNzsPO0G0x9u8jvrqPNkmLCIxRNvLPQQZgXaoOfXaDN
         kaPzNZ1W1O5wHYsrZCyowbYAkbsOKKXpRCd6MsdvrN1ds01r0ejvZnHwygt9j9a35bCk
         Cf2hKPGffK2GWb7AtSjLShunf3C66hJNoQRYhRnelFTTOniybfDGnJeB/MIbgD338RDP
         Pnuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tb2DLSHt7yEoDSj1xonLMAUM0KyNZsEaGyv5bBEUpu8=;
        b=wqckCDcr1jjU34dQC58DeAXjOW9JF+zB9Reuxt3Q2vYidR1dBPL0nJQ9osXfXdY5c9
         iKwS2vin+dPS/ku/5XtYJ7lkYgV5gn3dzrSK3u5+GENINVppXHxTj7T1nPheZ3s9rOgH
         KEQi4HfQhNYEvzkKrhbTTuvAe7vkIiSHU1BXufQBMypbcLIRCf/XSr4fqm1YKoJDZUEi
         TOr3ejRk+XVqDrQUWVRdki3fd8AoJFaRtoaxc63ip2KRuBm0QbX3vENqj7Z4AKTmnYNi
         rpW/a42dGAd9JpKh2tx5/6B0qbD5AAK2igUBcz+6jN2disaf7os0TEEOaRN23cFqByhF
         sbDA==
X-Gm-Message-State: AOAM530tJ04N4Al+m67ayhw9Q8gSAABRKYuOXHlNidq2PMBn95pDN3cc
        f6GsyWfop0/4Ym2vziVrBSU=
X-Google-Smtp-Source: ABdhPJww37Zh1A/cWqYLv8cApefSTpVITM+SVBpIEk1zj0/wZq+xUgY47FOrn91DuZ+bARyzae7T1A==
X-Received: by 2002:a05:6a00:23d3:b0:44c:a67f:49af with SMTP id g19-20020a056a0023d300b0044ca67f49afmr17110818pfc.50.1635150824679;
        Mon, 25 Oct 2021 01:33:44 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:44 -0700 (PDT)
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
Subject: [PATCH v6 01/12] fs/exec: make __set_task_comm always set a nul ternimated string
Date:   Mon, 25 Oct 2021 08:33:04 +0000
Message-Id: <20211025083315.4752-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the string set to task comm is always nul ternimated.

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

