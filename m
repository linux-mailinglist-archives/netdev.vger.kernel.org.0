Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4B646DC58
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbhLHThC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:37:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239614AbhLHTgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:36:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638992002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZLJineiLeYC7a6IEUETbNBO5lKFL+65lIOlXS0MiLo=;
        b=f21of2dg7eIJcRVtco07XkLks4BgaKAfHXwCymj5x+GpXQeS5Sfm89vLB0+Zgf5TSc/w6B
        JsUmxXdg/D0mksv+8oP1PBLqehQoac4ukTEn7YfFAGO9XoEPQzm4eXYob/equN7GNpXPTO
        QlR8kJKl3mih4elxGgUGigo1VvVuVsc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-fw_nQ9bTMySjdWJQI6eotQ-1; Wed, 08 Dec 2021 14:33:21 -0500
X-MC-Unique: fw_nQ9bTMySjdWJQI6eotQ-1
Received: by mail-wm1-f71.google.com with SMTP id a64-20020a1c7f43000000b003335e5dc26bso1787887wmd.8
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 11:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZLJineiLeYC7a6IEUETbNBO5lKFL+65lIOlXS0MiLo=;
        b=pehXFV8UwmrF86toEZRGilSfKppa6aqmi/dS5nHyyLmD2JOfBx/3j8ZIJxWkUaF/02
         SmVXFrwR4x/OXTbMJ/pT3fJFBFJ3I2GnOQmj6gBgwmwvGxQxmc8aFdt0UfZw2vkESEPW
         wkNtn6mIKzI8BfVgVejx/OKcnkLHhBYVx5lS9pUeAYE2kU8g3rynd62VVSzjpnbzE0bO
         RPVktR5U1UEUmi6dcBJcXd4yvXDo1Rl7TvfQCKe5rkl6Jztj7zu/oXNzIC5Tiwe/hybY
         ea9oIfy6R8I8nR5ZP7LFbnpEf9idPRvm7n0iAKXkx7tX1W1zzWqRQF15Kegve0b1fWfi
         vqOA==
X-Gm-Message-State: AOAM531sYRNJXNO6kiFKyycq/K1yfpsmF/O105wPN5u9naQU1TUwfAYJ
        yrXfXAQevKabkLkA8NCEWafWDGBarYdl3T5tqL/gMPOiMrXaTPO3Wg3+87AksYL5ClB/FWA2xeo
        aY6KSQnsYWcJ56GW/
X-Received: by 2002:a05:600c:1d01:: with SMTP id l1mr989853wms.44.1638991999771;
        Wed, 08 Dec 2021 11:33:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuFKnm5tvLByRD3ZTvF7iv9iVHqoo2KTqncJKNwfPo+wU6CWrG5tIV7JfExq23Fj5zOtUrzw==
X-Received: by 2002:a05:600c:1d01:: with SMTP id l1mr989822wms.44.1638991999514;
        Wed, 08 Dec 2021 11:33:19 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id o9sm3582082wrs.4.2021.12.08.11.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:33:19 -0800 (PST)
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
Subject: [PATCHv2 bpf-next 5/5] selftests/bpf: Add tests for get_func_[arg|ret|arg_cnt] helpers
Date:   Wed,  8 Dec 2021 20:32:45 +0100
Message-Id: <20211208193245.172141-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211208193245.172141-1-jolsa@kernel.org>
References: <20211208193245.172141-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding tests for get_func_[arg|ret|arg_cnt] helpers.
Using these helpers in fentry/fexit/fmod_ret programs.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/get_func_args_test.c       |  44 +++++++
 .../selftests/bpf/progs/get_func_args_test.c  | 123 ++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
new file mode 100644
index 000000000000..85c427119fe9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "get_func_args_test.skel.h"
+
+void test_get_func_args_test(void)
+{
+	struct get_func_args_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = get_func_args_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "get_func_args_test__open_and_load"))
+		return;
+
+	err = get_func_args_test__attach(skel);
+	if (!ASSERT_OK(err, "get_func_args_test__attach"))
+		goto cleanup;
+
+	/* This runs bpf_fentry_test* functions and triggers
+	 * fentry/fexit programs.
+	 */
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	/* This runs bpf_modify_return_test function and triggers
+	 * fmod_ret_test and fexit_test programs.
+	 */
+	prog_fd = bpf_program__fd(skel->progs.fmod_ret_test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 1234, "test_run");
+
+	ASSERT_EQ(skel->bss->test1_result, 1, "test1_result");
+	ASSERT_EQ(skel->bss->test2_result, 1, "test2_result");
+	ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
+	ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
+
+cleanup:
+	get_func_args_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/get_func_args_test.c b/tools/testing/selftests/bpf/progs/get_func_args_test.c
new file mode 100644
index 000000000000..e0f34a55e697
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/get_func_args_test.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 test1_result = 0;
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test1_result = cnt == 1;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+
+	/* We need to cast access to traced function argument values with
+	 * proper type cast, because trampoline uses type specific instruction
+	 * to save it, like for 'int a' with 32-bit mov like:
+	 *
+	 *   mov %edi,-0x8(%rbp)
+	 *
+	 * so the upper 4 bytes are not zeroed.
+	 */
+	test1_result &= err == 0 && ((int) a == 1);
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 1, &z);
+	test1_result &= err == -EINVAL;
+
+	/* return value fails in fentry */
+	err = bpf_get_func_ret(ctx, &ret);
+	test1_result &= err == -EOPNOTSUPP;
+	return 0;
+}
+
+__u64 test2_result = 0;
+SEC("fexit/bpf_fentry_test2")
+int BPF_PROG(test2)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, b = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test2_result = cnt == 2;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test2_result &= err == 0 && (int) a == 2;
+
+	err = bpf_get_func_arg(ctx, 1, &b);
+	test2_result &= err == 0 && b == 3;
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 2, &z);
+	test2_result &= err == -EINVAL;
+
+	/* return value */
+	err = bpf_get_func_ret(ctx, &ret);
+	test2_result &= err == 0 && ret == 5;
+	return 0;
+}
+
+__u64 test3_result = 0;
+SEC("fmod_ret/bpf_modify_return_test")
+int BPF_PROG(fmod_ret_test, int _a, int *_b, int _ret)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, b = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test3_result = cnt == 2;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test3_result &= err == 0 && ((int) a == 1);
+
+	err = bpf_get_func_arg(ctx, 1, &b);
+	test3_result &= err == 0 && ((int *) b == _b);
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 2, &z);
+	test3_result &= err == -EINVAL;
+
+	/* return value */
+	err = bpf_get_func_ret(ctx, &ret);
+	test3_result &= err == 0 && ret == 0;
+
+	/* change return value, it's checked in fexit_test program */
+	return 1234;
+}
+
+__u64 test4_result = 0;
+SEC("fexit/bpf_modify_return_test")
+int BPF_PROG(fexit_test, int _a, int *_b, int _ret)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, b = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test4_result = cnt == 2;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test4_result &= err == 0 && ((int) a == 1);
+
+	err = bpf_get_func_arg(ctx, 1, &b);
+	test4_result &= err == 0 && ((int *) b == _b);
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 2, &z);
+	test4_result &= err == -EINVAL;
+
+	/* return value */
+	err = bpf_get_func_ret(ctx, &ret);
+	test4_result &= err == 0 && ret == 1234;
+	return 0;
+}
-- 
2.33.1

