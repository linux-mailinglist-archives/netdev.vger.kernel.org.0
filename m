Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5243914A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhJYIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbhJYIgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:09 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC5FC061767;
        Mon, 25 Oct 2021 01:33:47 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t21so7414299plr.6;
        Mon, 25 Oct 2021 01:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7jKAATsl3Or1OXSx7HWzFCkHaZKf4EVahxCQwpQ+O5E=;
        b=TJLriZ5mdvjw59l3C40lhg68iy+fuuT/jguhTtjAocwEu+c8nhtiZgl51JsEcljfGU
         DB3lnJ+73ti9a7qpfCexwR+yJUi+FzWhAy/Jg0rkrHZb/wKiwVwjQbRFtHrD1sxqyLMB
         OusVpdCEsgFi/hiqfbaX0zl8ZaPLsq2cj5n0WWCGk1NvjnK0R8M+Y1OL61mO+BYHAQXo
         MRuuBVIY4v15HGw/VXe3XNBcdznsFM48gmgaB7qVcGfRpToafeCXSEZUlYNfYgwMdBcd
         OD9KcTYFsc9oIwkU6T+9hZWmv0cvSRpaQAB/pmkMdO5QHPU55muhXcsNQaKMj+pjvDmV
         RdTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7jKAATsl3Or1OXSx7HWzFCkHaZKf4EVahxCQwpQ+O5E=;
        b=ka7pVgEobO+88Ww/l/FLPIMDqxn4hSsurEj+JczBFi/STIwD7ySk+T6k2UMbust6e+
         E3lneSMo14kE4VAabdFUo5pp9nAzFHAFBlh+rbJNq9HrgE21dYFfnr3O6r1mRJ7A8ZvX
         zajhblX0FJpzhPbNxkAutQFrfJfJoo2ujjDzmBgMLJP2zSYB4MdXb4O8SVryByArEDag
         RmowrEPmmCWWa79tF4j14TYJZEy30r7+EzwtAr+a0KBXY39ACM5910kd/yYT44jj06wr
         dFuO6FZUrZUxOiN+Jc1bBpviyaAjq+qyO3MmmnBkgAIUsSs5YawB8FCy4pds+qytfdrQ
         96Dg==
X-Gm-Message-State: AOAM531D56anvOxY8WGcBBJlTv2RYx7AY7QBWRBYAUGwQxiMyhkw6qPd
        LDyBACyPlz4NFhHzlKUT6YQ=
X-Google-Smtp-Source: ABdhPJzYTnld7M84SDgJqip1ULz6qBYAnLfyifxnrJWJrcZvxH4N4k1/v119JIj2PZtcu7zZWBQaxA==
X-Received: by 2002:a17:90a:6788:: with SMTP id o8mr23634231pjj.53.1635150826928;
        Mon, 25 Oct 2021 01:33:46 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:33:46 -0700 (PDT)
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
Subject: [PATCH v6 02/12] fs/exec: make __get_task_comm always get a nul terminated string
Date:   Mon, 25 Oct 2021 08:33:05 +0000
Message-Id: <20211025083315.4752-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
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
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
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

