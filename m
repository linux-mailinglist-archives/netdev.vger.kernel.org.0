Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D34435976
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhJUDtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhJUDtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:49:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8707EC06177E;
        Wed, 20 Oct 2021 20:46:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so3917100pjb.3;
        Wed, 20 Oct 2021 20:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WXJPrQ9678Se3QG+Xzf+zJqr3rYn2faOseef/yOHc9c=;
        b=F9u5C9s3ym5Y6yHJdNnaGcLBjH3jiTPlUN4K6C5NADSio2vbHZjtkjQ7QDQ6WJkxZr
         E1nHY+LOkeDyQkDWJPB9TmDib8PE0wH3eBdSd9/6iqT4ubqDBYp+ncllx2O8gu76QCCC
         XNIeFFaXU2akBiA8Q8DCm0gn0jn4WQ+iZ9Csd6bMtSgR/8y0qTRX12dNrTSjEEDfHQsr
         B6zSum0WYir9tEZjoAusoDDlb6tooQ2c6jo+Vjow6snYDnI574TZ5WKJIshqENQHcVTD
         AiwQ58fZHmrYZY3NPh5yK9cjX/V5j5ccGzc8oMi9Jig0xaHVXtquw1fbQV1GgTPscacg
         iK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WXJPrQ9678Se3QG+Xzf+zJqr3rYn2faOseef/yOHc9c=;
        b=qUvVQYYEHj8Z/4vQ7qa/QBYXTG837aQIaA8I+AkjwzeR+Rd39ay9661Gqb0IFy/jl1
         Od5w0rNdDPyT6Pq9OmA8pi/1SkdlvM2by/Dw6g4botlR7KuP1GoHoI4br5j9YDfcPJgK
         3uGhBHrDaFKZgOuXdprMbLutC9xcF8OPfEwVjswI9Q8Ug9+WdSSp+fcV0dcs2UWLfXQl
         2F0WeWVjYXaPg6yDI8uGkPs0hGVRfRKjcU/VFPhG39KlQOg53heqbKdvtjj7/yP3YTSo
         xCIcr2foaXjF+GQmyTKhRNBGl0AhzCGUctSRvjqVcg/7cbZfdPoXk2ItLXe2Tlne7EAa
         8ehA==
X-Gm-Message-State: AOAM5322aDoqHhjPUK3EtyCtcXI+oxAtq/37LN0107b7PKZtaKeE2cBn
        QQ9/VO6zt3bO7M+AaqXj5YdCN/FuZrM6EaLumYQGoA==
X-Google-Smtp-Source: ABdhPJykQ537g0Oc0Tzo+SeeZAiRW14jcpCkkPvop9JWIPJg+4P2JqkOJYt2+D8aFwudaJZHzI9I/A==
X-Received: by 2002:a17:902:c401:b0:13e:f5f2:f852 with SMTP id k1-20020a170902c40100b0013ef5f2f852mr2939252plk.29.1634787972119;
        Wed, 20 Oct 2021 20:46:12 -0700 (PDT)
Received: from localhost.localdomain ([140.82.17.67])
        by smtp.gmail.com with ESMTPSA id r25sm3454254pge.61.2021.10.20.20.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:46:11 -0700 (PDT)
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
Subject: [PATCH v5 11/15] tools/bpf/bpftool: use TASK_COMM_LEN_16 instead of hard-coded 16
Date:   Thu, 21 Oct 2021 03:45:59 +0000
Message-Id: <20211021034603.4458-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211021034603.4458-1-laoar.shao@gmail.com>
References: <20211021034603.4458-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TASK_COMM_LEN_16 instead of hard-coded 16 to make it more grepable.
It uses bpf_probe_read_kernel() to get task comm, which may return a
string without nul terminator. We should use bpf_probe_read_kernel_str()
instead.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
---
 tools/bpf/bpftool/Makefile                | 1 +
 tools/bpf/bpftool/main.h                  | 3 ++-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c | 4 ++--
 tools/bpf/bpftool/skeleton/pid_iter.h     | 4 +++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index d73232be1e99..33fbde84993c 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -164,6 +164,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
 	$(QUIET_CLANG)$(CLANG) \
 		-I$(if $(OUTPUT),$(OUTPUT),.) \
 		-I$(srctree)/tools/include/uapi/ \
+		-I$(srctree)/tools/include/ \
 		-I$(LIBBPF_PATH) \
 		-I$(srctree)/tools/lib \
 		-g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 90caa42aac4c..5efa27188f68 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/hashtable.h>
+#include <linux/sched/task.h>
 #include <tools/libc_compat.h>
 
 #include <bpf/libbpf.h>
@@ -124,7 +125,7 @@ struct obj_refs_table {
 
 struct obj_ref {
 	int pid;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 struct obj_refs {
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
diff --git a/tools/bpf/bpftool/skeleton/pid_iter.h b/tools/bpf/bpftool/skeleton/pid_iter.h
index 5692cf257adb..675b2916567e 100644
--- a/tools/bpf/bpftool/skeleton/pid_iter.h
+++ b/tools/bpf/bpftool/skeleton/pid_iter.h
@@ -3,10 +3,12 @@
 #ifndef __PID_ITER_H
 #define __PID_ITER_H
 
+#include <linux/sched/task.h>
+
 struct pid_iter_entry {
 	__u32 id;
 	int pid;
-	char comm[16];
+	char comm[TASK_COMM_LEN_16];
 };
 
 #endif
-- 
2.17.1

