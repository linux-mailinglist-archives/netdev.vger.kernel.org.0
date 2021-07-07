Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F353BF07D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 21:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhGGTtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 15:49:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhGGTtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 15:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625687224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yu/yssvroh5wN9vZzKT4DxZ0/5KDe3VlIF6FttuA20I=;
        b=O9bsZnK7+qv8cOkpRTvCMfenheVTECQhA06bGXkOaX/eK+AEi6I5Pj4A5vBHWz5D27l61s
        KcheVnjE0OrOr8DXXdueC6olOoR1LqsVSG2ba9/g75n0zRBmoYSfnb9I7YwDZgfR5JP/Pc
        7Z+n8MxD+J5V1H+tptLF1q5/auDeqgg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-WvPtYhwoOM-XtB43Cn_Y2A-1; Wed, 07 Jul 2021 15:47:01 -0400
X-MC-Unique: WvPtYhwoOM-XtB43Cn_Y2A-1
Received: by mail-wm1-f72.google.com with SMTP id t12-20020a7bc3cc0000b02901f290c9c44eso1401208wmj.7
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 12:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yu/yssvroh5wN9vZzKT4DxZ0/5KDe3VlIF6FttuA20I=;
        b=WQibmMddriT/b5FIJHdkaACq/BWS1DU90K5KR5HDLLIWsVqTva1hWWGEOrqyI7ZXBh
         YMvm7N5RtHcuefyB5fbJ0+Ez/30oWavWcC9qE4HBxOiAh1sn1zB+A9wMKQVerJMJNtZ/
         nApVuOtvv2XmHBF4EQ2YW+mdqg3NpYoRP/5tFSUiMPZKli9TGuZErg8IvmMOQ17LgfKM
         nurFBFiJdlnY7EeHReeXYVVU07HVtXN0PqcrAMYCKoOX1Rm09SQvrSIqIucBhbP+hQVz
         aWbi1V1aWxT7POAl1kLrXqihQSSDnohvF18kT1lmr5AhesXcbbsTO7b+mGawx/wGvkWT
         hlMw==
X-Gm-Message-State: AOAM532k+vSX5+/7K3dIxuNsDnswh5TpOzAENNn76lzCrd/G7GcrarJa
        dIsF4GbpHAITbK0D56b1WQI0SW1wo5LNgQgDSBwU4OrQAMR92ofGhq8UqAXN6fxP715XrbPjqGG
        2By+iDefuVbpKNhBF
X-Received: by 2002:a7b:c0c6:: with SMTP id s6mr800182wmh.176.1625687220101;
        Wed, 07 Jul 2021 12:47:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4ko4VbSlhXPsLn2IGSoVpTJFVa9bwyIz+SEM80cwEG3J9oL6KvVet35WTjUpZbLWaKDSmkA==
X-Received: by 2002:a7b:c0c6:: with SMTP id s6mr800164wmh.176.1625687219924;
        Wed, 07 Jul 2021 12:46:59 -0700 (PDT)
Received: from krava.redhat.com ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id c16sm19416281wmr.2.2021.07.07.12.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 12:46:59 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 5/7] selftests/bpf: Add test for bpf_get_func_ip helper
Date:   Wed,  7 Jul 2021 21:46:17 +0200
Message-Id: <20210707194619.151676-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707194619.151676-1-jolsa@kernel.org>
References: <20210707194619.151676-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding test for bpf_get_func_ip helper for fentry, fexit,
kprobe, kretprobe and fmod_ret programs.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/get_func_ip_test.c         | 42 +++++++++++++
 .../selftests/bpf/progs/get_func_ip_test.c    | 62 +++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
new file mode 100644
index 000000000000..06d34f566bbb
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "get_func_ip_test.skel.h"
+
+void test_get_func_ip_test(void)
+{
+	struct get_func_ip_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd, i;
+	__u64 *result;
+
+	skel = get_func_ip_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "get_func_ip_test__open_and_load"))
+		goto cleanup;
+
+	err = get_func_ip_test__attach(skel);
+	if (!ASSERT_OK(err, "get_func_ip_test__attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	prog_fd = bpf_program__fd(skel->progs.fmod_ret_test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+
+	ASSERT_OK(err, "test_run");
+
+	result = (__u64 *)skel->bss;
+	for (i = 0; i < sizeof(*skel->bss) / sizeof(__u64); i++) {
+		if (!ASSERT_EQ(result[i], 1, "fentry_result"))
+			break;
+	}
+
+	get_func_ip_test__detach(skel);
+
+cleanup:
+	get_func_ip_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
new file mode 100644
index 000000000000..8ca54390d2b1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+extern const void bpf_fentry_test1 __ksym;
+extern const void bpf_fentry_test2 __ksym;
+extern const void bpf_fentry_test3 __ksym;
+extern const void bpf_fentry_test4 __ksym;
+extern const void bpf_modify_return_test __ksym;
+
+__u64 test1_result = 0;
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test1_result = (const void *) addr == &bpf_fentry_test1;
+	return 0;
+}
+
+__u64 test2_result = 0;
+SEC("fexit/bpf_fentry_test2")
+int BPF_PROG(test2, int a)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test2_result = (const void *) addr == &bpf_fentry_test2;
+	return 0;
+}
+
+__u64 test3_result = 0;
+SEC("kprobe/bpf_fentry_test3")
+int test3(struct pt_regs *ctx)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test3_result = (const void *) addr == &bpf_fentry_test3;
+	return 0;
+}
+
+__u64 test4_result = 0;
+SEC("kretprobe/bpf_fentry_test4")
+int BPF_KRETPROBE(test4)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test4_result = (const void *) addr == &bpf_fentry_test4;
+	return 0;
+}
+
+__u64 test5_result = 0;
+SEC("fmod_ret/bpf_modify_return_test")
+int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
+{
+	__u64 addr = bpf_get_func_ip(ctx);
+
+	test5_result = (const void *) addr == &bpf_modify_return_test;
+	return ret;
+}
-- 
2.31.1

