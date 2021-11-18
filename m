Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D11D455A5F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344134AbhKRLcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:32:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344056AbhKRLal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:30:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTnzLZH9St4nm5Qk+Gny9wdik+W3lc006QLR20VAmVI=;
        b=a2VegWR8rNeqATS/hdBDJbeaSK9ocFVUFfJMBTTjDtr1xPkbdffq93E5XrcNtsBD7mqnqH
        mMwQELuZdSx4hxGEA8df2xu3rnjiA6QTImsVKhNPOKPL6vlcnk3mAQHhv4v45rYy74PXFh
        tv3yLJkiawul07geucwXKn8FDE5Fv8w=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-IvOL1dThNfik-beEiQKdUQ-1; Thu, 18 Nov 2021 06:27:40 -0500
X-MC-Unique: IvOL1dThNfik-beEiQKdUQ-1
Received: by mail-ed1-f71.google.com with SMTP id d13-20020a056402516d00b003e7e67a8f93so5041529ede.0
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rTnzLZH9St4nm5Qk+Gny9wdik+W3lc006QLR20VAmVI=;
        b=zUG45TS82WQt2Daz0Z2YX7re2XJyYq0uSAIbxRZeWrOo0sO/NiDRqDgwCuDjppw4NC
         7Yzo6tdWBJ+U8MNZ0ckrco1MqSmPHPvQK0R+s7zmS8CODcgbTWaDKGFzVMOf40DcKiI0
         oV4Np1qfzCIIG0DR076EzX9Tzsxh9lrl5bkzKTOhqNyyJ9/USwH6v9CgHQeWDWBvN3WD
         cWsmRNG5FCTio00zeLqPZox7040Wljc5FU17aiB9Ry6MpjLPveJ8P/1Sw0Wz3U0WStWd
         kGbHw+uvByE6fcHlbkvWi3ETCqmv6rK3oAwqgH4YXhTdl+xUe2eRZJ553m4mQT93GybQ
         QPlw==
X-Gm-Message-State: AOAM530eW7RqPWCN8ZStPD+Vd379oDSyRBB4KWqcwkU8XvI3Llfl+3rf
        MTCxgxfcLKWcvdccsZDWlrNszX8LAzJ4TWLtsM+jyX4A1urWQeFpa1ou5h2D2771Ob9n90crHvB
        Kfy17wQ7dnUv73ZqB
X-Received: by 2002:a05:6402:40d1:: with SMTP id z17mr10061168edb.340.1637234859290;
        Thu, 18 Nov 2021 03:27:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx34DKK1KicjwV0TlyXuE5zjue5xGNZ1DzlmaqJ8kIYKUGgW+EPe+5dluSTRQEa46z5KmYAvg==
X-Received: by 2002:a05:6402:40d1:: with SMTP id z17mr10061137edb.340.1637234859120;
        Thu, 18 Nov 2021 03:27:39 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id lk22sm1163424ejb.83.2021.11.18.03.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:27:38 -0800 (PST)
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
Subject: [PATCH bpf-next 27/29] selftests/bpf: Add mixed multi func test
Date:   Thu, 18 Nov 2021 12:24:53 +0100
Message-Id: <20211118112455.475349-28-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for fentry/fexit multi func tests that attaches
to bpf_fentry_test* functions, where some of them have already
attached trampoline.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../bpf/prog_tests/multi_mixed_test.c         | 34 +++++++++++++++
 .../testing/selftests/bpf/progs/multi_mixed.c | 43 +++++++++++++++++++
 3 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_mixed.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 236b6e0a36de..48970e983250 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -324,7 +324,7 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h			\
 		multi_fentry_test.skel.h multi_fexit_test.skel.h	\
-		multi_fentry_fexit_test.skel.h
+		multi_fentry_fexit_test.skel.h multi_mixed_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
@@ -339,6 +339,7 @@ linked_maps.skel.h-deps := linked_maps1.o linked_maps2.o
 multi_fentry_test.skel.h-deps := multi_fentry.o multi_check.o
 multi_fexit_test.skel.h-deps := multi_fexit.o multi_check.o
 multi_fentry_fexit_test.skel.h-deps := multi_fentry_fexit.o multi_check.o
+multi_mixed_test.skel.h-deps := multi_mixed.o multi_check.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c b/tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c
new file mode 100644
index 000000000000..c9395b4eb5ac
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_mixed_test.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "multi_mixed_test.skel.h"
+
+void test_multi_mixed_test(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
+	struct multi_mixed_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = multi_mixed_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "fentry_multi_skel_load"))
+		goto cleanup;
+
+	err = multi_mixed_test__attach(skel);
+	if (!ASSERT_OK(err, "fentry_attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	ASSERT_EQ(skel->bss->test1_result, 1, "test1_result");
+	ASSERT_EQ(skel->bss->test2_result, 1, "test2_result");
+	ASSERT_EQ(skel->bss->test3_arg_result, 8, "test3_arg_result");
+	ASSERT_EQ(skel->bss->test4_arg_result, 8, "test4_arg_result");
+	ASSERT_EQ(skel->bss->test4_ret_result, 8, "test4_ret_result");
+
+cleanup:
+	multi_mixed_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_mixed.c b/tools/testing/selftests/bpf/progs/multi_mixed.c
new file mode 100644
index 000000000000..468a044753e9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_mixed.c
@@ -0,0 +1,43 @@
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
+__u64 test1_result = 0;
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	test1_result += a == 1;
+	return 0;
+}
+
+__u64 test2_result = 0;
+SEC("fexit/bpf_fentry_test2")
+int BPF_PROG(test2, int a, __u64 b, int ret)
+{
+	test2_result += a == 2 && b == 3;
+	return 0;
+}
+
+__u64 test3_arg_result = 0;
+SEC("fentry.multi/bpf_fentry_test*")
+int BPF_PROG(test3, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	multi_arg_check(ctx, &test3_arg_result);
+	return 0;
+}
+
+__u64 test4_arg_result = 0;
+__u64 test4_ret_result = 0;
+SEC("fexit.multi/bpf_fentry_test*")
+int BPF_PROG(test4, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	multi_arg_check(ctx, &test4_arg_result);
+	multi_ret_check(ctx, &test4_ret_result);
+	return 0;
+}
-- 
2.31.1

