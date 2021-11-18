Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49B455A59
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344122AbhKRLca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:32:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344046AbhKRLa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:30:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4w9z59EHFbXqy0WBMfhQAPvo2GwQkbl/oaYCrbS/5SI=;
        b=R5Imxqdok16BEfHDNRWA3hr7aWj/tqdd4tUeLA1UThtyhf9F507/Jc6QYvvB1irGaXD/wz
        QD2nzxD4ZTc+X708WMBEGCDDOsGiz/BaiAzAilsuLIGIp6c40T4/8wysK+I5vRasmA682W
        k2OLoG2RPIicsqUl4hHIKkKSOVYEMBE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-420-j3gFSWhINK--rSMBv8IyBg-1; Thu, 18 Nov 2021 06:27:22 -0500
X-MC-Unique: j3gFSWhINK--rSMBv8IyBg-1
Received: by mail-ed1-f72.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso4954468eds.21
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:27:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4w9z59EHFbXqy0WBMfhQAPvo2GwQkbl/oaYCrbS/5SI=;
        b=Wo8sACKFu5V8vHCWLV23dassSSzXoraj6RV8mb9mO5l0DSZnwK4s8QhB4Ch0eV7sK7
         LnvQis7T3pkYLHZY2QFmLqyNQb0FsVNExwwQsauzg13qPAmKZUAIyymoA6DAPTe97mSg
         SXT8UuGL0D4+ALnpJ4mEfXxedRnWaN6kuYLYLDXwxRcJOREn5ECyLhOAIM4oY7UiZGni
         ZLt8luT11xcmlpYK1vf+IyN45A5lnDdkiFAiLpiDox+V8R4d9xxUYExh/DuZrVruLc/A
         X6nlL0ceHLvUc79L7gs23yF72/k5THRYa1AIgJfncXhaVN72x7apZ8zwbRd1XdjsBAqS
         dTeQ==
X-Gm-Message-State: AOAM530+VGIoQa3JvUhbElwRlY3poHXFvfns7O0i50oPdUkR7cocIwBc
        26SviAyQtBfOCb0naNXnbE7FONvPzlaHXYTmw2p+nS2Nn9fiOTB6VU8hFlFQOGeM9VXb9+xspxw
        IS1VCdZzpldyYRyUB
X-Received: by 2002:a17:907:94d4:: with SMTP id dn20mr32268025ejc.379.1637234841218;
        Thu, 18 Nov 2021 03:27:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpUiSvo4L4FdhFPvzMoyJYHsklqk2A5x6i6r+T8jxcf7dzlN5sh71H1PqoDctmR8fxgzeGzw==
X-Received: by 2002:a17:907:94d4:: with SMTP id dn20mr32267998ejc.379.1637234841044;
        Thu, 18 Nov 2021 03:27:21 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id j3sm1157057ejo.2.2021.11.18.03.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:27:20 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 24/29] selftests/bpf: Add fentry multi func test
Date:   Thu, 18 Nov 2021 12:24:50 +0100
Message-Id: <20211118112455.475349-25-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
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
index 35684d61aaeb..fa29ddd47cbe 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -322,7 +322,8 @@ endef
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
-		linked_vars.skel.h linked_maps.skel.h
+		linked_vars.skel.h linked_maps.skel.h			\
+		multi_fentry_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
@@ -334,6 +335,7 @@ test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
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
index 000000000000..82acc9ee7715
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
+		int a = (int) bpf_arg(ctx, 0);
+		__u64 b = bpf_arg(ctx, 1);
+
+		*test_result += a == 2 && b == 3;
+	} else if (ip == &bpf_fentry_test3) {
+		char a = (int) bpf_arg(ctx, 0);
+		int b = (int) bpf_arg(ctx, 1);
+		__u64 c = bpf_arg(ctx, 2);
+
+		*test_result += a == 4 && b == 5 && c == 6;
+	} else if (ip == &bpf_fentry_test4) {
+		void *a = (void *) bpf_arg(ctx, 0);
+		char b = (char) bpf_arg(ctx, 1);
+		int c = (int) bpf_arg(ctx, 2);
+		__u64 d = bpf_arg(ctx, 3);
+
+		*test_result += a == (void *) 7 && b == 8 && c == 9 && d == 10;
+	} else if (ip == &bpf_fentry_test5) {
+		__u64 a = bpf_arg(ctx, 0);
+		void *b = (void *) bpf_arg(ctx, 1);
+		short c = (short) bpf_arg(ctx, 2);
+		int d = (int) bpf_arg(ctx, 3);
+		__u64 e = bpf_arg(ctx, 4);
+
+		*test_result += a == 11 && b == (void *) 12 && c == 13 && d == 14 && e == 15;
+	} else if (ip == &bpf_fentry_test6) {
+		__u64 a = bpf_arg(ctx, 0);
+		void *b = (void *) bpf_arg(ctx, 1);
+		short c = (short) bpf_arg(ctx, 2);
+		int d = (int) bpf_arg(ctx, 3);
+		void *e = (void *) bpf_arg(ctx, 4);
+		__u64 f = bpf_arg(ctx, 5);
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

