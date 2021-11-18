Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91FE455A67
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344160AbhKRLc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:32:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343920AbhKRLaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:30:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXDO1Q0PT1LV+IkN9FZ4WM7egV17pWLfXKegiEUMZIc=;
        b=UC9jJV4le8Wk3oQcsm/r2HqLrvOeXhkSb/yctz4O0VbKCM81OYNi3Zg4zrWI/RCFm11SPQ
        neoPzab+/bZecX3C8lYO34mvo2YlESIF1e6cHNE2qZGoLftIQ8WDdUNtiM+2FMDOvoaKBr
        NldBTg2m18ejduwr/HMQPb3tRLfIbJQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-MWYNFFnAN-6IA39h4yqBIw-1; Thu, 18 Nov 2021 06:27:54 -0500
X-MC-Unique: MWYNFFnAN-6IA39h4yqBIw-1
Received: by mail-ed1-f71.google.com with SMTP id a3-20020a05640213c300b003e7d12bb925so5025110edx.9
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:27:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lXDO1Q0PT1LV+IkN9FZ4WM7egV17pWLfXKegiEUMZIc=;
        b=sdFVkYjUJP+0hrHHDXoU4Z5QaUZXfzsY8Aiopk/4SW7WI72qtkP9aakB8ouz3JxPeJ
         fX7We7UeCJLbpS1iedz/Lkndqgly1rbSqhBI/EYp/3xeDRDhb7AEyjrJD+0d0XqQwDD8
         zan9UBHKgveDfv7FbujpLKv817MstRjIBqjdU3RJxEYyh2PeRR7U/cCYOsg3tY0+M7Mu
         CHNg/X/fi/PYoVZm2yeVJhioNI46f8IvFguhdm6e67ZaHAt2b3/KjpeEmLWec66UnPfE
         DFxDvwY+n0GWdbBoCYU5bi6PaR0fw0sbIxWVO66OqJpInerRuzoYwlyxfxmPX5apvrMl
         LfvQ==
X-Gm-Message-State: AOAM530UGAlbMTyxuMNFTTr0rFiraCq7LAuM0zlsO3luJSdCtOTXOSuR
        CElD2wBK6c3p1VtcWNOIE9asmHLprTD8HSckSuZda2xkF8txVhAicwK7ypUxztViH04KLyi1UJB
        oV4OvmGXxjMgceXvr
X-Received: by 2002:aa7:c3c8:: with SMTP id l8mr10099504edr.278.1637234872726;
        Thu, 18 Nov 2021 03:27:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxp5GicqeoqaM5YlhbpBraXwMCTAKIvVszs2h9J1eZ9tAsFbu6eJl3k82B7jE9zwk0fcFhQQ==
X-Received: by 2002:aa7:c3c8:: with SMTP id l8mr10099379edr.278.1637234872055;
        Thu, 18 Nov 2021 03:27:52 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id em21sm1172772ejc.103.2021.11.18.03.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:27:51 -0800 (PST)
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
Subject: [PATCH bpf-next 29/29] selftests/bpf: Add attach multi func test
Date:   Thu, 18 Nov 2021 12:24:55 +0100
Message-Id: <20211118112455.475349-30-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test code to check on trampolines spliting.

The tests attached various bpf_fetry_* functions in a way
so there's always non trivial IDs intersection, that leads
to trampoline splitting in kenrel code.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../bpf/prog_tests/multi_attach_test.c        | 176 ++++++++++++++++++
 .../selftests/bpf/progs/multi_attach.c        | 105 +++++++++++
 3 files changed, 284 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_attach_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 48970e983250..095d966a747a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -324,7 +324,8 @@ SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
 LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h		\
 		linked_vars.skel.h linked_maps.skel.h			\
 		multi_fentry_test.skel.h multi_fexit_test.skel.h	\
-		multi_fentry_fexit_test.skel.h multi_mixed_test.skel.h
+		multi_fentry_fexit_test.skel.h multi_mixed_test.skel.h	\
+		multi_attach_test.skel.h
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c
@@ -340,6 +341,7 @@ multi_fentry_test.skel.h-deps := multi_fentry.o multi_check.o
 multi_fexit_test.skel.h-deps := multi_fexit.o multi_check.o
 multi_fentry_fexit_test.skel.h-deps := multi_fentry_fexit.o multi_check.o
 multi_mixed_test.skel.h-deps := multi_mixed.o multi_check.o
+multi_attach_test.skel.h-deps := multi_attach.o multi_check.o
 
 LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/tools/testing/selftests/bpf/prog_tests/multi_attach_test.c b/tools/testing/selftests/bpf/prog_tests/multi_attach_test.c
new file mode 100644
index 000000000000..c183941215a6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_attach_test.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <linux/btf_ids.h>
+#include "multi_attach_test.skel.h"
+#include <bpf/btf.h>
+
+static __u32 btf_ids[8];
+
+static int load_btf_ids(void)
+{
+	__u32 i, nr_types, cnt;
+	struct btf *btf;
+
+	btf = btf__load_vmlinux_btf();
+	if (!ASSERT_OK_PTR(btf, "btf__load_vmlinux_btf"))
+		return -1;
+
+	nr_types = btf__get_nr_types(btf);
+
+	for (i = 1, cnt = 0; i <= nr_types && cnt < 8; i++) {
+		const struct btf_type *t = btf__type_by_id(btf, i);
+		const char *name;
+
+		if (!btf_is_func(t))
+			continue;
+
+		name = btf__name_by_offset(btf, t->name_off);
+		if (!name)
+			continue;
+		if (strncmp(name, "bpf_fentry_test", sizeof("bpf_fentry_test") - 1))
+			continue;
+
+		btf_ids[cnt] = i;
+		cnt++;
+	}
+
+	btf__free(btf);
+	return ASSERT_EQ(cnt, 8, "bpf_fentry_test_cnt") ? 0 : -1;
+}
+
+static int link_prog_from_cnt(const struct bpf_program *prog, int from, int cnt)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	enum bpf_attach_type attach_type;
+	int prog_fd, link_fd;
+
+	opts.multi.btf_ids = btf_ids + (from - 1);
+	opts.multi.btf_ids_cnt = cnt;
+
+	prog_fd = bpf_program__fd(prog);
+	if (!ASSERT_GE(prog_fd, 0, "link_from_to_prog_fd"))
+		return -1;
+	attach_type = bpf_program__get_expected_attach_type(prog);
+	link_fd = bpf_link_create(prog_fd, 0, attach_type, &opts);
+	if (!ASSERT_GE(link_fd, 0, "link_from_to_link_fd"))
+		return -1;
+	return link_fd;
+}
+
+static int prog_from_cnt(const struct bpf_program *prog, int *from, int *cnt)
+{
+	const char *sec;
+	int err, to;
+
+	sec = bpf_program__section_name(prog);
+	sec = strchr(sec, '/');
+	if (!sec)
+		return -1;
+	sec++;
+	err = sscanf(sec, "bpf_fentry_test%d-%d", from, &to);
+	if (err != 2)
+		return -1;
+	*cnt = to - *from + 1;
+	return 0;
+}
+
+static int link_test(const struct bpf_program *prog1,
+		     const struct bpf_program *prog2,
+		     __u64 *test_result1, __u64 *test_result2,
+		     bool do_close, int link_fd[2])
+{
+	int from1, cnt1, from2, cnt2, err;
+	__u32 duration = 0, retval;
+
+	if (!ASSERT_OK(prog_from_cnt(prog1, &from1, &cnt1), "prog_from_cnt__prog1"))
+		return -1;
+
+	if (!ASSERT_OK(prog_from_cnt(prog2, &from2, &cnt2), "prog_from_cnt__prog2"))
+		return -1;
+
+	link_fd[0] = link_prog_from_cnt(prog1, from1, cnt1);
+	if (link_fd[0] < 0)
+		return -1;
+
+	link_fd[1] = link_prog_from_cnt(prog2, from2, cnt2);
+	if (link_fd[1] < 0)
+		return -1;
+
+	*test_result1 = 0;
+	*test_result2 = 0;
+
+	err = bpf_prog_test_run(bpf_program__fd(prog1), 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+	ASSERT_EQ(*test_result1, cnt1, "test_result");
+	ASSERT_EQ(*test_result2, cnt2, "test_result");
+
+	if (do_close) {
+		close(link_fd[0]);
+		close(link_fd[1]);
+	}
+	return err;
+}
+
+void test_multi_attach_test(void)
+{
+	struct bpf_link *link7 = NULL, *link8 = NULL;
+	int link_fd[6] = { -1 }, i, err;
+	struct multi_attach_test *skel;
+	__u32 duration = 0, retval;
+
+	for (i = 0; i < 6; i++)
+		link_fd[i] = -1;
+
+	skel = multi_attach_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "multi_attach__load"))
+		return;
+
+	if (!ASSERT_OK(load_btf_ids(), "load_btf_ids"))
+		goto cleanup;
+
+#define LINK_TEST(__prog1, __prog2, __close)			\
+	err = link_test(skel->progs.test ## __prog1,		\
+			skel->progs.test ## __prog2,		\
+			&skel->bss->test_result ## __prog1,	\
+			&skel->bss->test_result ## __prog2,	\
+			__close, link_fd + __prog1 - 1);	\
+	if (err)						\
+		goto cleanup;
+
+	LINK_TEST(1, 2, true);
+	LINK_TEST(3, 4, true);
+	LINK_TEST(1, 3, true);
+	LINK_TEST(2, 4, true);
+
+	LINK_TEST(1, 2, false);
+	LINK_TEST(3, 4, false);
+	LINK_TEST(5, 6, false);
+
+#undef LINK_TEST
+
+	link7 = bpf_program__attach(skel->progs.test7);
+	if (!ASSERT_OK_PTR(link7, "multi_attach_check__test1_attach"))
+		goto cleanup;
+
+	link8 = bpf_program__attach(skel->progs.test8);
+	if (!ASSERT_OK_PTR(link7, "multi_attach_check__test2_attach"))
+		goto cleanup;
+
+	err = bpf_prog_test_run(bpf_program__fd(skel->progs.test7), 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+	ASSERT_EQ(skel->bss->test_result7, 1, "test_result7");
+	ASSERT_EQ(skel->bss->test_result8, 1, "test_result8");
+
+cleanup:
+	bpf_link__destroy(link8);
+	bpf_link__destroy(link7);
+	for (i = 0; i < 6; i++)
+		close(link_fd[i]);
+	multi_attach_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_attach.c b/tools/testing/selftests/bpf/progs/multi_attach.c
new file mode 100644
index 000000000000..d403f5f1f27e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_attach.c
@@ -0,0 +1,105 @@
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
+__u64 test_result1 = 0;
+
+SEC("fentry.multi/bpf_fentry_test1-5")
+int BPF_PROG(test1, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	multi_arg_check(ctx, &test_result1);
+	return 0;
+}
+
+__u64 test_result2 = 0;
+
+SEC("fentry.multi/bpf_fentry_test4-8")
+int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	multi_arg_check(ctx, &test_result2);
+	return 0;
+}
+
+__u64 test_result3 = 0;
+
+SEC("fexit.multi/bpf_fentry_test1-5")
+int BPF_PROG(test3, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	__u64 arg_result = 0, ret_result = 0;
+
+	multi_arg_check(ctx, &arg_result);
+	multi_ret_check(ctx, &ret_result);
+
+	if (arg_result && ret_result)
+		test_result3 += 1;
+	return 0;
+}
+
+__u64 test_result4 = 0;
+
+SEC("fexit.multi/bpf_fentry_test4-8")
+int BPF_PROG(test4, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	__u64 arg_result = 0, ret_result = 0;
+
+	multi_arg_check(ctx, &arg_result);
+	multi_ret_check(ctx, &ret_result);
+
+	if (arg_result && ret_result)
+		test_result4 += 1;
+	return 0;
+}
+
+__u64 test_result5 = 0;
+
+SEC("fentry.multi/bpf_fentry_test1-8")
+int BPF_PROG(test5, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	multi_arg_check(ctx, &test_result5);
+	return 0;
+}
+
+__u64 test_result6 = 0;
+
+SEC("fexit.multi/bpf_fentry_test1-8")
+int BPF_PROG(test6, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	__u64 arg_result = 0, ret_result = 0;
+
+	multi_arg_check(ctx, &arg_result);
+	multi_ret_check(ctx, &ret_result);
+
+	if (arg_result && ret_result)
+		test_result6 += 1;
+	return 0;
+}
+
+__u64 test_result7 = 0;
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test7, int a)
+{
+	multi_arg_check(ctx, &test_result7);
+	return 0;
+}
+
+__u64 test_result8 = 0;
+
+SEC("fexit/bpf_fentry_test2")
+int BPF_PROG(test8, int a, __u64 b, int ret)
+{
+	__u64 arg_result = 0, ret_result = 0;
+
+	multi_arg_check(ctx, &arg_result);
+	multi_ret_check(ctx, &ret_result);
+
+	if (arg_result && ret_result)
+		test_result8 += 1;
+	return 0;
+}
-- 
2.31.1

