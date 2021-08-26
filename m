Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350103F8F06
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243482AbhHZTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243516AbhHZTmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdiH+hWlAfCXXR5vse4KVzlNX30ztiZTZ3F2EBv6jwY=;
        b=Az8xrVD5yTCgdpUpNxNMD5mWoAHvZRZnzmgTZVqtBLJ4+UWRgLO13flHNs1cmw6IKr+fR4
        C9IAbA+i5iRieQLJBMqwLuMmuUTk6pkxNzVxUXlWSbnOZXDhI9gwejVpRFlFf/h0OkqZ/1
        Cq2ygbCFr21tpD88pqwW/j1R8pJ7Mj8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-we3TE-xTPsKxTTutK41MkA-1; Thu, 26 Aug 2021 15:41:42 -0400
X-MC-Unique: we3TE-xTPsKxTTutK41MkA-1
Received: by mail-wm1-f71.google.com with SMTP id m33-20020a05600c3b2100b002e87a0542efso1134916wms.2
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IdiH+hWlAfCXXR5vse4KVzlNX30ztiZTZ3F2EBv6jwY=;
        b=G2OaoKb9o9vNJPqpgKWDj4AJafqBkjJrWeGIJmfggDsAXve87fpfEn5UpCHnmS3KYL
         5wYk10vusR/lMukUL5MPCL7Uw11YHjMh6Y2DBgy9sPJOPWIUS9OEMxCsFEdTT8xHYwLx
         QGBVOSpdSqDlcAGAsqWVoIzeZKVsX1kETUnJL71w4z0ee88TedZZ+CqsEwhnxaJRZa9u
         jLDhkStkXhblup73MAuvJ0zwzJBB3R1+19KipB43CcMbjKKtESwNK/PUOFqtMFJqEBwT
         P35WfPmjxAPZ7IIxv1n03KSjUQU4iK9qWbgBPs6n4wy/uF/D67nsbN6cav5Z7nsDpzuC
         Q1ZA==
X-Gm-Message-State: AOAM531vHWzqc0NHvKFkOHLgNuN2vQUIsWITZ3GXt50ZN4PdyGpDcjqS
        ALT2ehC41SB40Xucf86WMzDHexkyxRlSbx+YqiqNoapoCq7DZ9HR7BvetTUYL+D9ehME59JJCbv
        3wRyrrtttB7KpVymN
X-Received: by 2002:adf:fa82:: with SMTP id h2mr6021569wrr.195.1630006900895;
        Thu, 26 Aug 2021 12:41:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFG/7XNDG/mpqKRrO1b4pQ3vAuhPnl321lfpkEfEA5CRQvEFWrP8pYl4CQGSc0eHH1sSwbAw==
X-Received: by 2002:adf:fa82:: with SMTP id h2mr6021547wrr.195.1630006900694;
        Thu, 26 Aug 2021 12:41:40 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id v28sm4013930wrv.93.2021.08.26.12.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:40 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 22/27] selftests/bpf: Add fentry multi func test
Date:   Thu, 26 Aug 2021 21:39:17 +0200
Message-Id: <20210826193922.66204-23-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for fentry multi func test that attaches
to bpf_fentry_test* functions and checks argument values
based on the processed function.

We need to cast to real arguments types in multi_arg_check,
because the checked value can be shorter than u64.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  4 +-
 .../bpf/prog_tests/multi_fentry_test.c        | 30 +++++++++
 .../testing/selftests/bpf/progs/multi_check.c | 63 +++++++++++++++++++
 .../selftests/bpf/progs/multi_fentry.c        | 17 +++++
 4 files changed, 113 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fentry.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 866531c08e4f..013d41c8edae 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -312,7 +312,8 @@ endef
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
-		linked_vars.skel.h linked_maps.skel.h
+		linked_vars.skel.h linked_maps.skel.h			\
+		multi_fentry_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
@@ -322,6 +323,7 @@ test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
 linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
 linked_maps.skel.h-deps := linked_maps1.o linked_maps2.o
+multi_fentry_test.skel.h-deps := multi_fentry.o multi_check.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c b/tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c
new file mode 100644
index 000000000000..8dc08c3e715f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_fentry_test.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "multi_fentry_test.skel.h"
+#include "trace_helpers.h"
+
+void test_multi_fentry_test(void)
+{
+	struct multi_fentry_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = multi_fentry_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
+		goto cleanup;
+
+	err = multi_fentry_test__attach(skel);
+	if (!ASSERT_OK(err, "fentry_attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test_result, 8, "test_result");
+
+cleanup:
+	multi_fentry_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_check.c b/tools/testing/selftests/bpf/progs/multi_check.c
new file mode 100644
index 000000000000..415c96684a30
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_check.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+extern const void bpf_fentry_test1 __ksym;
+extern const void bpf_fentry_test2 __ksym;
+extern const void bpf_fentry_test3 __ksym;
+extern const void bpf_fentry_test4 __ksym;
+extern const void bpf_fentry_test5 __ksym;
+extern const void bpf_fentry_test6 __ksym;
+extern const void bpf_fentry_test7 __ksym;
+extern const void bpf_fentry_test8 __ksym;
+
+void multi_arg_check(__u64 *ctx, __u64 *test_result)
+{
+	void *ip = (void *) bpf_get_func_ip(ctx);
+
+	if (ip == &bpf_fentry_test1) {
+		int a = (int) ctx[0];
+
+		*test_result += a == 1;
+	} else if (ip == &bpf_fentry_test2) {
+		int a = (int) ctx[0];
+		__u64 b = ctx[1];
+
+		*test_result += a == 2 && b == 3;
+	} else if (ip == &bpf_fentry_test3) {
+		int a = (int) ctx[0];
+		int b = (int) ctx[1];
+		__u64 c = ctx[2];
+
+		*test_result += a == 4 && b == 5 && c == 6;
+	} else if (ip == &bpf_fentry_test4) {
+		void *a = (void *) ctx[0];
+		int b = (int) ctx[1];
+		int c = (int) ctx[2];
+		__u64 d = ctx[3];
+
+		*test_result += a == (void *) 7 && b == 8 && c == 9 && d == 10;
+	} else if (ip == &bpf_fentry_test5) {
+		__u64 a = ctx[0];
+		void *b = (void *) ctx[1];
+		short c = (short) ctx[2];
+		int d = (int) ctx[3];
+		__u64 e = ctx[4];
+
+		*test_result += a == 11 && b == (void *) 12 && c == 13 && d == 14 && e == 15;
+	} else if (ip == &bpf_fentry_test6) {
+		__u64 a = ctx[0];
+		void *b = (void *) ctx[1];
+		short c = (short) ctx[2];
+		int d = (int) ctx[3];
+		void *e = (void *) ctx[4];
+		__u64 f = ctx[5];
+
+		*test_result += a == 16 && b == (void *) 17 && c == 18 && d == 19 && e == (void *) 20 && f == 21;
+	} else if (ip == &bpf_fentry_test7) {
+		*test_result += 1;
+	} else if (ip == &bpf_fentry_test8) {
+		*test_result += 1;
+	}
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_fentry.c b/tools/testing/selftests/bpf/progs/multi_fentry.c
new file mode 100644
index 000000000000..b78d36772aa6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_fentry.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 test_result = 0;
+
+__hidden extern void multi_arg_check(__u64 *ctx, __u64 *test_result);
+
+SEC("fentry.multi/bpf_fentry_test*")
+int BPF_PROG(test, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	multi_arg_check(ctx, &test_result);
+	return 0;
+}
-- 
2.31.1

