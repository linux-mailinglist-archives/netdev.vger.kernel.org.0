Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68323F8F08
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243501AbhHZTmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243629AbhHZTmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4uQfRC0gVRi3xhE8qT4qNuckZwO4Pkcm7ceoMb3k98=;
        b=ghh22P8zIihrI4MNK0mLuZ/2Gkic5DmGe8gjn7qQ68yZO5OJ/etx5bwk5QqFyCozc4Vav5
        krXNuP2+79t6Xue87pqmQCL6ASEWiFX8Q7CQT9xneq0BuqVO4UcxmDkij4Q02d9xHUqIyZ
        WCZcfmbwhM1SULGCQBZb94qV1maDBBg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-ta6KoC_9OwaDQ3QOOMz98A-1; Thu, 26 Aug 2021 15:41:48 -0400
X-MC-Unique: ta6KoC_9OwaDQ3QOOMz98A-1
Received: by mail-wr1-f70.google.com with SMTP id h14-20020a056000000e00b001575b00eb08so1185378wrx.13
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4uQfRC0gVRi3xhE8qT4qNuckZwO4Pkcm7ceoMb3k98=;
        b=hkuNMEuZCL1iiKvBJ+Kk/HmBWkrIRj+9CrMQqoSEWqcSYAbS6uaV4vutTOzELf3Qz0
         lHN+niVaYp7KVcNwQKtlxI6rIm/0oocBOr880duvlxbOgO2gWdbv+FplpAlYeaPIqnvi
         e+7epRmzjoXGQSO8GQPavAlP2xiSy56EsSmb4WyMo34Vfn++YC3ALHZjzyj7AjvEezFf
         s2fBsw0UiOiOc2E3D8B2+gE2TIqCPsjj/OEvsPZyGjRwf+SiNUu4rUtWKHaZAswss/0B
         JUKIuGYCRXF1jJ9i/bQFG2/GNoItC8/4NRXSBn+1ayexKNuj4x6WkfSrFr8BCNGFT78i
         sGGA==
X-Gm-Message-State: AOAM533Ir4DTET3FrBRL4Efn4k/WxEZs1cU6Io+y4tLNFgtkc7gUfLXw
        pDEXbssuUp9s1ymIybY+J9v3YCyts8H+rlJjj8BEf8h62I0lgFgaeLyIZytThF7DOowwY0Z8M6h
        Tm20lezmJgaf7By3H
X-Received: by 2002:adf:916f:: with SMTP id j102mr2112222wrj.422.1630006907161;
        Thu, 26 Aug 2021 12:41:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVnhRZe4NqfZXpIVeTTiL8K0dGI7pHdPxTHEUchEkXPBEeXA2GfmitEE+opVev1Ae+keafIw==
X-Received: by 2002:adf:916f:: with SMTP id j102mr2112205wrj.422.1630006906931;
        Thu, 26 Aug 2021 12:41:46 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id u10sm4137538wrt.14.2021.08.26.12.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:46 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 23/27] selftests/bpf: Add fexit multi func test
Date:   Thu, 26 Aug 2021 21:39:18 +0200
Message-Id: <20210826193922.66204-24-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for fexit multi func test that attaches
to bpf_fentry_test* functions and checks argument values
based on the processed function.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../bpf/prog_tests/multi_fexit_test.c         | 31 +++++++++++++++++++
 .../testing/selftests/bpf/progs/multi_check.c | 22 +++++++++++++
 .../testing/selftests/bpf/progs/multi_fexit.c | 20 ++++++++++++
 4 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fexit.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 013d41c8edae..8da3be0972de 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -313,7 +313,7 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h			\
-		multi_fentry_test.skel.h
+		multi_fentry_test.skel.h multi_fexit_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ksyms_module.c test_ringbuf.c atomics.c trace_printk.c
@@ -324,6 +324,7 @@ linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
 linked_vars.skel.h-deps := linked_vars1.o linked_vars2.o
 linked_maps.skel.h-deps := linked_maps1.o linked_maps2.o
 multi_fentry_test.skel.h-deps := multi_fentry.o multi_check.o
+multi_fexit_test.skel.h-deps := multi_fexit.o multi_check.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c b/tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c
new file mode 100644
index 000000000000..d9b0eedd9f45
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "multi_fexit_test.skel.h"
+#include "trace_helpers.h"
+
+void test_multi_fexit_test(void)
+{
+	struct multi_fexit_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = multi_fexit_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fexit_multi_skel_load"))
+		goto cleanup;
+
+	err = multi_fexit_test__attach(skel);
+	if (!ASSERT_OK(err, "fexit_attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test_arg_result, 8, "fexit_multi_arg_result");
+	ASSERT_EQ(skel->bss->test_ret_result, 8, "fexit_multi_ret_result");
+
+cleanup:
+	multi_fexit_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_check.c b/tools/testing/selftests/bpf/progs/multi_check.c
index 415c96684a30..80ebbefaa8cd 100644
--- a/tools/testing/selftests/bpf/progs/multi_check.c
+++ b/tools/testing/selftests/bpf/progs/multi_check.c
@@ -61,3 +61,25 @@ void multi_arg_check(__u64 *ctx, __u64 *test_result)
 		*test_result += 1;
 	}
 }
+
+void multi_ret_check(void *ctx, int ret, __u64 *test_result)
+{
+	void *ip = (void *) bpf_get_func_ip(ctx);
+
+	if (ip == &bpf_fentry_test1)
+		*test_result += ret == 2;
+	else if (ip == &bpf_fentry_test2)
+		*test_result += ret == 5;
+	else if (ip == &bpf_fentry_test3)
+		*test_result += ret == 15;
+	else if (ip == &bpf_fentry_test4)
+		*test_result += ret == 34;
+	else if (ip == &bpf_fentry_test5)
+		*test_result += ret == 65;
+	else if (ip == &bpf_fentry_test6)
+		*test_result += ret == 111;
+	else if (ip == &bpf_fentry_test7)
+		*test_result += ret == 0;
+	else if (ip == &bpf_fentry_test8)
+		*test_result += ret == 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_fexit.c b/tools/testing/selftests/bpf/progs/multi_fexit.c
new file mode 100644
index 000000000000..29c49aa3bfc2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_fexit.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__hidden extern void multi_arg_check(__u64 *ctx, __u64 *test_result);
+__hidden extern void multi_ret_check(void *ctx, int ret, __u64 *test_result);
+
+__u64 test_arg_result = 0;
+__u64 test_ret_result = 0;
+
+SEC("fexit.multi/bpf_fentry_test*")
+int BPF_PROG(test, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	multi_arg_check(ctx, &test_arg_result);
+	multi_ret_check(ctx, ret, &test_ret_result);
+	return 0;
+}
-- 
2.31.1

