Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3570C3F8EE6
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbhHZTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243547AbhHZTlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjVYZzchk8zj3iEUBSEoZP/smDG6NngufYLxpwikn0s=;
        b=LDNy8AyIgJGgYdCtOnNvu2fbl/YeFgMR2I3CRU7Tv71qk69PxTb0OJykkx/Ly0nFbgo3M5
        fa28TGRKKasUvoCNSuKDyaf37d64uydMzpQXXC0OBar54P1X7TJaW+iRCz2BBpwCZ0jlm4
        B1BlSCz/4adEauXT5+0ivuFGlPaCbDU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-79CX0mMiNGCY5YlJ3sRq7Q-1; Thu, 26 Aug 2021 15:40:14 -0400
X-MC-Unique: 79CX0mMiNGCY5YlJ3sRq7Q-1
Received: by mail-wr1-f71.google.com with SMTP id q11-20020a5d61cb0000b02901550c3fccb5so1192938wrv.14
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AjVYZzchk8zj3iEUBSEoZP/smDG6NngufYLxpwikn0s=;
        b=g4sJ49ylN+ydkRqgLAvbQ4rl2tiVsg7mMLwerQ/DZ19o0DTMsYS/hVqjXFuNir1MJd
         y/iqqPtmlMP2U7Wt4bv2/Lwt4y8ejVLycYdBUev2sR9L7/F4QBz+dHelqPiyXDlxQMGl
         0aNaEwy9L8ffypWgHUuFLkNvQutWXcPPproSaTMM0ZVcv5u98favfzrYCDeHS/6NQviO
         KGNvMDXsQhA0qrSrXoRqViVazXjcycDZ6zGdgKdsFJwbtKuKDsCzcm7wL1uoWePSOe4p
         6QJwbpRFOH3aDEKAhWb6qvvt/1/IQRhuqPwWERRIadPT2bTYC6jZMdgefHY71BHi5R78
         PRrw==
X-Gm-Message-State: AOAM5331HosJ959xekNsOERtZEB/iw2inDDhR9PeNdvxJ+gtrOcFIwaE
        3D+xSeXtkO0jfT4waxdqE6zm6ZDEOGt+FBiHJ0JYFzJ5I8GO4cgvYXqp3yu8i5ciIQULpIZbM5+
        fruVQCEcef8pM0cmK
X-Received: by 2002:adf:82b0:: with SMTP id 45mr6112049wrc.161.1630006813096;
        Thu, 26 Aug 2021 12:40:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXWI8rRU0SR10XdK68IEbBWJLmfDc+ENkRYWVSvF2hIZkTc2PTWjhIOWFCG/NSRX9EmnJFaA==
X-Received: by 2002:adf:82b0:: with SMTP id 45mr6112033wrc.161.1630006812955;
        Thu, 26 Aug 2021 12:40:12 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id z5sm9243836wmp.26.2021.08.26.12.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:12 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 08/27] ftrace/samples: Add multi direct interface test module
Date:   Thu, 26 Aug 2021 21:39:03 +0200
Message-Id: <20210826193922.66204-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding simple module that uses multi direct interface:

  register_ftrace_direct_multi
  unregister_ftrace_direct_multi

The init function registers trampoline for 2 functions,
and exit function unregisters them.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 samples/ftrace/Makefile              |  1 +
 samples/ftrace/ftrace-direct-multi.c | 52 ++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 samples/ftrace/ftrace-direct-multi.c

diff --git a/samples/ftrace/Makefile b/samples/ftrace/Makefile
index 4ce896e10b2e..ab1d1c05c288 100644
--- a/samples/ftrace/Makefile
+++ b/samples/ftrace/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_SAMPLE_FTRACE_DIRECT) += ftrace-direct.o
 obj-$(CONFIG_SAMPLE_FTRACE_DIRECT) += ftrace-direct-too.o
 obj-$(CONFIG_SAMPLE_FTRACE_DIRECT) += ftrace-direct-modify.o
+obj-$(CONFIG_SAMPLE_FTRACE_DIRECT) += ftrace-direct-multi.o
 
 CFLAGS_sample-trace-array.o := -I$(src)
 obj-$(CONFIG_SAMPLE_TRACE_ARRAY) += sample-trace-array.o
diff --git a/samples/ftrace/ftrace-direct-multi.c b/samples/ftrace/ftrace-direct-multi.c
new file mode 100644
index 000000000000..76b34d46d11c
--- /dev/null
+++ b/samples/ftrace/ftrace-direct-multi.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/module.h>
+
+#include <linux/mm.h> /* for handle_mm_fault() */
+#include <linux/ftrace.h>
+#include <linux/sched/stat.h>
+
+void my_direct_func(unsigned long ip)
+{
+	trace_printk("ip %lx\n", ip);
+}
+
+extern void my_tramp(void *);
+
+asm (
+"	.pushsection    .text, \"ax\", @progbits\n"
+"	.type		my_tramp, @function\n"
+"	.globl		my_tramp\n"
+"   my_tramp:"
+"	pushq %rbp\n"
+"	movq %rsp, %rbp\n"
+"	pushq %rdi\n"
+"	movq 8(%rbp), %rdi\n"
+"	call my_direct_func\n"
+"	popq %rdi\n"
+"	leave\n"
+"	ret\n"
+"	.size		my_tramp, .-my_tramp\n"
+"	.popsection\n"
+);
+
+static struct ftrace_ops direct;
+
+static int __init ftrace_direct_multi_init(void)
+{
+	ftrace_set_filter_ip(&direct, (unsigned long) wake_up_process, 0, 0);
+	ftrace_set_filter_ip(&direct, (unsigned long) schedule, 0, 0);
+
+	return register_ftrace_direct_multi(&direct, (unsigned long) my_tramp);
+}
+
+static void __exit ftrace_direct_multi_exit(void)
+{
+	unregister_ftrace_direct_multi(&direct);
+}
+
+module_init(ftrace_direct_multi_init);
+module_exit(ftrace_direct_multi_exit);
+
+MODULE_AUTHOR("Jiri Olsa");
+MODULE_DESCRIPTION("Example use case of using register_ftrace_direct_multi()");
+MODULE_LICENSE("GPL");
-- 
2.31.1

