Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D465E43916C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 10:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhJYIg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 04:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhJYIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 04:36:28 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762DEC061231;
        Mon, 25 Oct 2021 01:34:01 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c4so3517461plg.13;
        Mon, 25 Oct 2021 01:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TS8muz6Ak9DGU3l2L96V+UecMUYveGNsphx64n4dYOI=;
        b=M2FolzUKrmB9JdFI0MSqy5ChbO8Ja0Pf8UZPZm02u3xFvWDKNyZXc8Dym/hG4NIPAA
         4ZpmbwlCuUUeXOEUxchfZH8bRN3iDp6AZUQKd3pXsduzQL8O8nHlQvwfOCN9Flkn1GOl
         pO4FWJRCWhgdfn+6H0Tj7wfb65dY0IkXl43ypxIQ43r8iOzN5hV9R26R/C7mw0Ba27Os
         1WBeZUEUhqNN7swBZp+UXeUn5C/uwh77MU4Emv2Kdba0wtcmAGlRQyFdsd6oKxWfAMOS
         VWr/1XcWd7zxnJOv7N2ncV8aa37dmE9NYCGJXPzYZC+zOL+03zINlyNRqsvOAw4gqU2o
         V0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TS8muz6Ak9DGU3l2L96V+UecMUYveGNsphx64n4dYOI=;
        b=DGZNIDl+VksXdb0i38MIyjUU1AJwKD8WzuaRgQV/cpBPEisXIYce6Xq7LUKeMiy6pY
         NfYVwYEq+J0PfKVnbNzkLX6I6eMGcEGi7Bzh/DXn8bjaaEqqOTmhyw0AmQu/pnh1z9u7
         gfJRPR7fxFKFREiHHAfMOvFE/aEsvQhkCk9KYUN1Shci3imQy1yR41MdifvSI1sYBBGO
         zBuZfCzKjs9uvujW2wQdlhjNKtILBJX4w53LKxf9OVHWzCfn0v5qU7gtQmuDmE7AbQXn
         fg3bOtFOkhu7f5bSuAJSv6uCOtTmAT04tZxg6+O0nqPF/52hHOi7FoTfOwy59mZQUTfl
         P0ug==
X-Gm-Message-State: AOAM531REW7s0EDkk/GrhP67vEoVVCWDvy1CcoFlTv38IKnmtRNfbO74
        T8YA1qnnUWU+9UxsiVgTkW8=
X-Google-Smtp-Source: ABdhPJwksxFE2tQQyrV3PnanxuzSjX04lpr4xzNjspd8MjAGIknTaDm6AMAf9hKdRj7ef0WBXIAmdQ==
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr18897686pjb.49.1635150841055;
        Mon, 25 Oct 2021 01:34:01 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id p13sm2495694pfo.102.2021.10.25.01.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 01:34:00 -0700 (PDT)
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
Subject: [PATCH v6 08/12] tools/bpf/bpftool/skeleton: make it adopt to task comm size change
Date:   Mon, 25 Oct 2021 08:33:11 +0000
Message-Id: <20211025083315.4752-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211025083315.4752-1-laoar.shao@gmail.com>
References: <20211025083315.4752-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_probe_read_kernel_str() will add a nul terminator to the dst, then
we don't care about if the dst size is big enough.

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
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
index d9b420972934..f70702fcb224 100644
--- a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
+++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
@@ -71,8 +71,8 @@ int iter(struct bpf_iter__task_file *ctx)
 
 	e.pid = task->tgid;
 	e.id = get_obj_id(file->private_data, obj_type);
-	bpf_probe_read_kernel(&e.comm, sizeof(e.comm),
-			      task->group_leader->comm);
+	bpf_probe_read_kernel_str(&e.comm, sizeof(e.comm),
+				  task->group_leader->comm);
 	bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
 
 	return 0;
-- 
2.17.1

