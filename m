Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3A3F8F10
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243507AbhHZTnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:43:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243496AbhHZTnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cg3b6pCUYgk1DCEc/G+FSd+XekVAu5S9ccZ75etSNB8=;
        b=AkYK2YxQHAxyo69U8XHC9X4RwLhXjPp4jzVROzSaIbid0Z3g3Y4q0yFndsblkYhsnSD+6q
        8AO11e0qz1qUtRD2ZjZ1+ICFAfcspdEsSJQzFKwUb5DA5L7PKP/sArUZnIUpqJuiyGV5K3
        +FdQDoPUmCxFIeZIjMB3RUV708AnXYQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-SOk0tu6WOS-8PCV0IIIYXQ-1; Thu, 26 Aug 2021 15:41:54 -0400
X-MC-Unique: SOk0tu6WOS-8PCV0IIIYXQ-1
Received: by mail-wm1-f70.google.com with SMTP id u1-20020a05600c210100b002e74fc5af71so1277544wml.1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cg3b6pCUYgk1DCEc/G+FSd+XekVAu5S9ccZ75etSNB8=;
        b=rqN9n1JfR+mUc8FPVkC97uIQFbX1Uaulen+vkCarLvsx2ZEgr2VS2Tfmn6AKcgXOIU
         1mpoZ9P+MxxrZOo/nkMzJnD25/UAmJ9+Y1yWgIgnSujbmZX6KojcSQ9wXiVJlcUX/DRA
         DjvdQSHla1FYO/kvtqhoRzWlSRRxoRmQQg+DkasypCyYj9Fa2Z84pGXUXQkeKV3sjzM1
         opMtCjcD4ugxE3xzeNg/cAGIOfcmv0zxxWRTeJo0jxYYrIeBBUuPE6aWziwMMDCx/c+o
         Xbmd2jdTaBvcEcGljggCRm3D1jnxTUjLaUQRD2ZWxVvHGABLvK8/qvZANGGlgBdk7V6v
         iTsA==
X-Gm-Message-State: AOAM532jNn9Q/Xx2RQmLQbUNjan0KnQKo2yRd1oQK5+7fHHQDqmeFyiy
        oyjXfdJnRIHqwwwl3Ngf5i5GzgKR03w/29+CXx30XThzS+4iAgrjjpaWiLpj91g10dY9ICujz3O
        4/w1iK/fSnbTz/SzJ
X-Received: by 2002:a7b:cb44:: with SMTP id v4mr5315779wmj.169.1630006913398;
        Thu, 26 Aug 2021 12:41:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9WybcY+dg6NCte2Tc5bpGkGSGSc32LlQkKDXkHz9yizHUZoqK2YAG3KJWGGtS9Cqwax+XXA==
X-Received: by 2002:a7b:cb44:: with SMTP id v4mr5315763wmj.169.1630006913198;
        Thu, 26 Aug 2021 12:41:53 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id l2sm10371542wmi.1.2021.08.26.12.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:52 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 24/27] selftests/bpf: Add fentry/fexit multi func test
Date:   Thu, 26 Aug 2021 21:39:19 +0200
Message-Id: <20210826193922.66204-25-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for fentry/fexit multi func tests that attaches
to bpf_fentry_test* functions and checks argument values based
on the processed function.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  4 ++-
 .../bpf/prog_tests/multi_fentry_fexit_test.c  | 32 +++++++++++++++++++
 .../selftests/bpf/progs/multi_fentry_fexit.c  | 28 ++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fentry_fexit.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 8da3be0972de..6272d9c166f9 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -313,7 +313,8 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h			\
-		multi_fentry_test.skel.h multi_fexit_test.skel.h
+		multi_fentry_test.skel.h multi_fexit_test.skel.h	\
+		multi_fentry_fexit_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
@@ -325,6 +326,7 @@ linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
 linked_maps.skel.h-deps := linked_maps1.o linked_maps2.o
 multi_fentry_test.skel.h-deps := multi_fentry.o multi_check.o
 multi_fexit_test.skel.h-deps := multi_fexit.o multi_check.o
+multi_fentry_fexit_test.skel.h-deps := multi_fentry_fexit.o multi_check.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c b/tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c
new file mode 100644
index 000000000000..d54abf36ab2f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_fentry_fexit_test.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "multi_fentry_fexit_test.skel.h"
+
+void test_multi_fentry_fexit_test(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
+	struct multi_fentry_fexit_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = multi_fentry_fexit_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
+		goto cleanup;
+
+	err = multi_fentry_fexit_test__attach(skel);
+	if (!ASSERT_OK(err, "fentry_fexit_attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test2);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test1_arg_result, 8, "test1_arg_result");
+	ASSERT_EQ(skel->bss->test2_arg_result, 8, "test2_arg_result");
+	ASSERT_EQ(skel->bss->test2_ret_result, 8, "test2_ret_result");
+
+cleanup:
+	multi_fentry_fexit_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_fentry_fexit.c b/tools/testing/selftests/bpf/progs/multi_fentry_fexit.c
new file mode 100644
index 000000000000..aac7df8c9211
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_fentry_fexit.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 test1_arg_result = 0;
+__u64 test2_arg_result = 0;
+__u64 test2_ret_result = 0;
+
+__hidden extern void multi_arg_check(__u64 *ctx, __u64 *test_result);
+__hidden extern void multi_ret_check(void *ctx, int ret, __u64 *test_result);
+
+SEC("fentry.multi/bpf_fentry_test*")
+int BPF_PROG(test1, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	multi_arg_check(ctx, &test1_arg_result);
+	return 0;
+}
+
+SEC("fexit.multi/bpf_fentry_test*")
+int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	multi_arg_check(ctx, &test2_arg_result);
+	multi_ret_check(ctx, ret, &test2_ret_result);
+	return 0;
+}
-- 
2.31.1

