Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACCE455A5B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344124AbhKRLcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:32:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344052AbhKRLaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ErIJJtuMRUhbIPvfUeZOmACetWYxDXUh4cGQYrVEag4=;
        b=BKQOu9ViWFTJFIA8DdrtQrEasyCndVq49GlFV8DEWEMbIDpoU+3MO/8dD8nbIFPnB+PKXy
        a0gCOZttg4FtnJEm+88PCLCoKGjo7U6J43SnZUPTHhpZsWEG7x7WDZxwbDxppb8a0uk8C4
        F1bTmha7JDuniM3h98nZ9lvXkESGENk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-DyE4iWjYOo6ev42Rk1nlMw-1; Thu, 18 Nov 2021 06:27:28 -0500
X-MC-Unique: DyE4iWjYOo6ev42Rk1nlMw-1
Received: by mail-ed1-f69.google.com with SMTP id f4-20020a50e084000000b003db585bc274so4962337edl.17
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ErIJJtuMRUhbIPvfUeZOmACetWYxDXUh4cGQYrVEag4=;
        b=t4JVAXTsp/e8viqIg+9csjW2ZmIeOtOQM2nNJlH7n8K/0u8myrmvHZZsOG8pa59N8R
         2SQpbnaYyNi2dvdGkuk94jOWYacy6P+xPrdDBHT9wP5ZqfGJc/nfaUypu6Ysxbd7sild
         vbvMRtBS2m1O4XVZZR2PE+nBWVyI9U31XpMzcS9oVwxi1no6SL9SjG9Lo4k32WMp8gY9
         MoKMp/tWcnsHJjOU6QxiDiWDyH6pK5Phk0RP+bpXXk5MIHyzrg/IUyuheSrv1QFLLPW5
         ivjhWLjSidJd6ZDKsTmOC6FcBMsEoxSIhkDbW1cMdcctBs4IqkxRC5ex7bb6lIs7qdJq
         qPrQ==
X-Gm-Message-State: AOAM532uBBPBJv1WpvE99ZhCdwX8oxg/LrWSm2ZRcmhfoqquYIhQJ7AH
        9SyQkG3jDquHGpQcJdSlLQTAa4Z6Xv5IZZ6IuOZ0eTKZOmGKF+2GzczbQ7eUBAIqzyAVB+dbxiT
        1x/c0DBA/W7ZlywS/
X-Received: by 2002:a50:9eca:: with SMTP id a68mr9846455edf.127.1637234847328;
        Thu, 18 Nov 2021 03:27:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVH4BLqavpth5rV3X5MI3BbxRqmLyd3X53WvVpD0g4ofqtUoGZrAXTWYLTfvCekr4fdXLXoQ==
X-Received: by 2002:a50:9eca:: with SMTP id a68mr9846425edf.127.1637234847146;
        Thu, 18 Nov 2021 03:27:27 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id hd18sm1109071ejc.84.2021.11.18.03.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:27:26 -0800 (PST)
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
Subject: [PATCH bpf-next 25/29] selftests/bpf: Add fexit multi func test
Date:   Thu, 18 Nov 2021 12:24:51 +0100
Message-Id: <20211118112455.475349-26-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
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
 .../testing/selftests/bpf/progs/multi_check.c | 23 ++++++++++++++
 .../testing/selftests/bpf/progs/multi_fexit.c | 20 ++++++++++++
 4 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_fexit.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index fa29ddd47cbe..42b67834d803 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -323,7 +323,7 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h			\
-		multi_fentry_test.skel.h
+		multi_fentry_test.skel.h multi_fexit_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
@@ -336,6 +336,7 @@ linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
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
index 82acc9ee7715..2f14d232dd77 100644
--- a/tools/testing/selftests/bpf/progs/multi_check.c
+++ b/tools/testing/selftests/bpf/progs/multi_check.c
@@ -61,3 +61,26 @@ void multi_arg_check(__u64 *ctx, __u64 *test_result)
 		*test_result += 1;
 	}
 }
+
+void multi_ret_check(void *ctx, __u64 *test_result)
+{
+	void *ip = (void *) bpf_get_func_ip(ctx);
+	int ret = (int) bpf_ret_value(ctx);
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
index 000000000000..54624acc7071
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
+__hidden extern void multi_ret_check(void *ctx, __u64 *test_result);
+
+__u64 test_arg_result = 0;
+__u64 test_ret_result = 0;
+
+SEC("fexit.multi/bpf_fentry_test*")
+int BPF_PROG(test)
+{
+	multi_arg_check(ctx, &test_arg_result);
+	multi_ret_check(ctx, &test_ret_result);
+	return 0;
+}
-- 
2.31.1

