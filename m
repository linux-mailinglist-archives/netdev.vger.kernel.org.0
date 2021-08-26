Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C933F8F0C
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243636AbhHZTm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243519AbhHZTm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bokwZZdBG1B1kLTNIjydZjB2m8CruKIWTf2DTwAUs3E=;
        b=i9qKK11CdsE0bvDecLOA8Bi4HJCl/L8viGm5yGD0BENngzRVwt6r47Hn3x3Ff0AzBCMRp/
        3qGMA/mOkPtNrB4rHoyXSBQmdPIEEvIKhhWfYFmW3W6TAtTDLIDcJ6nfCQLbcBZARIXW9S
        AUzhWL+62Jcpk0FS/Sq7D72kVm4+e/M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-y_RyhoCdNoSDeF3xHpZBBw-1; Thu, 26 Aug 2021 15:42:07 -0400
X-MC-Unique: y_RyhoCdNoSDeF3xHpZBBw-1
Received: by mail-wr1-f69.google.com with SMTP id d12-20020a056000186cb02901548bff164dso1190008wri.18
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:42:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bokwZZdBG1B1kLTNIjydZjB2m8CruKIWTf2DTwAUs3E=;
        b=Q4r2oUZHRkxHpZzYyU5nK9vzDEOiXtGUfCSEdSCiiQq98yitljPi1J76ZLp05anLqN
         rxMWQZqeWLzNv/8EskhaRG2Hc4AyqpC2Lz1vDJtwkYJxKCiC4wNUO6RuFiN7xg19ca2Q
         pPtOzFUosKAMgut4tdyDOTg6cJ69guj5EOA43B4IQnV++jbPKZrV0WEDvgbJGQh0ehar
         tRnpYcm7Vn8LMIpIpR4dkhX+8pWSETuTuP4eckM4d1ko0nV+BOrBGZIS2aEAGcTOvpkK
         IIewkmRHQSEJcygJPPJE++isxyh3R+mHv0a98ZjJd4/8hQCnY1KXyW7eAVV57NJyEuf4
         aArQ==
X-Gm-Message-State: AOAM532uW1s3pdQQiXAur62bDXE4VCLxkRl8/SwC2eauZqI0hkgZCiv0
        tlIdzVAbErQD2/2dxD9NSXDB+xkzTwsAUgpdbAb7u33At3LOdfUleqzxJhTT3SxgTwEy2D+4rSF
        r1O3jCaTgqueRxp6L
X-Received: by 2002:adf:e28a:: with SMTP id v10mr5805327wri.289.1630006925723;
        Thu, 26 Aug 2021 12:42:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFN+ZboqGkMatDOw0B/DLmI+FQdpqDxpOj7fXgQ9Xb7hPg5qMWaB/EhxUaqgiLxJEfevUbow==
X-Received: by 2002:adf:e28a:: with SMTP id v10mr5805306wri.289.1630006925500;
        Thu, 26 Aug 2021 12:42:05 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id c1sm9108499wml.33.2021.08.26.12.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:42:05 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 26/27] selftests/bpf: Add attach multi func test
Date:   Thu, 26 Aug 2021 21:39:21 +0200
Message-Id: <20210826193922.66204-27-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest to check attaching rules for multi func programs.

  - attach 2 programs:

    fentry/bpf_fentry_test1
    fexit/bpf_fentry_test2

  - check that we can attach multi func program on top of them:

    fentry.multi/bpf_fentry_test*

  - check that we cannot attach another multi funct program
    that does not cover the same BTF ids (one less):

    fentry.multi/bpf_fentry_test[1-7]
    fexit.multi/bpf_fentry_test[1-7]

  - check that we can no longer attach standard trampoline
    programs (below) on top of attached multi func program:

    fentry/bpf_fentry_test1
    fexit/bpf_fentry_test3

Because the supported wildcards do not allow us to
match just limited set of bpf_fentry_test*, adding
extra code to look it up in kernel's BTF.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/multi_attach_check_test.c  | 115 ++++++++++++++++++
 .../selftests/bpf/progs/multi_attach_check.c  |  36 ++++++
 .../bpf/progs/multi_attach_check_extra1.c     |  12 ++
 .../bpf/progs/multi_attach_check_extra2.c     |  12 ++
 4 files changed, 175 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/multi_attach_check_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach_check_extra1.c
 create mode 100644 tools/testing/selftests/bpf/progs/multi_attach_check_extra2.c

diff --git a/tools/testing/selftests/bpf/prog_tests/multi_attach_check_test.c b/tools/testing/selftests/bpf/prog_tests/multi_attach_check_test.c
new file mode 100644
index 000000000000..32b23718437d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/multi_attach_check_test.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <linux/btf_ids.h>
+#include "multi_attach_check.skel.h"
+#include "multi_attach_check_extra1.skel.h"
+#include "multi_attach_check_extra2.skel.h"
+#include <bpf/btf.h>
+
+static __u32 btf_ids[7];
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
+	for (i = 1, cnt = 0; i <= nr_types && cnt < 7; i++) {
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
+	return ASSERT_EQ(cnt, 7, "bpf_fentry_test_cnt") ? 0 : -1;
+}
+
+void test_multi_attach_check_test(void)
+{
+	struct bpf_link *link1 = NULL, *link2 = NULL, *link3 = NULL;
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	struct multi_attach_check_extra1 *skel_extra1 = NULL;
+	struct multi_attach_check_extra2 *skel_extra2 = NULL;
+	struct multi_attach_check *skel;
+	int link_fd, prog_fd;
+
+	/* Load/attach standard trampolines and on top of it multi
+	 * func program. It should succeed.
+	 */
+	skel = multi_attach_check__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "multi_attach_check__load"))
+		return;
+
+	link1 = bpf_program__attach(skel->progs.test1);
+	if (!ASSERT_OK_PTR(link1, "multi_attach_check__test1_attach"))
+		goto cleanup;
+
+	link2 = bpf_program__attach(skel->progs.test2);
+	if (!ASSERT_OK_PTR(link2, "multi_attach_check__test2_attach"))
+		goto cleanup;
+
+	link3 = bpf_program__attach(skel->progs.test3);
+	if (!ASSERT_OK_PTR(link3, "multi_attach_check__test3_attach"))
+		goto cleanup;
+
+	if (!ASSERT_OK(load_btf_ids(), "load_btf_ids"))
+		goto cleanup;
+
+	/* There's 8 bpf_fentry_test* functions, get BTF ids for 7 of them
+	 * and try to load/link multi func program with them. It should fail
+	 * both for fentry.multi ...
+	 */
+	opts.multi.btf_ids = btf_ids;
+	opts.multi.btf_ids_cnt = 7;
+
+	prog_fd = bpf_program__fd(skel->progs.test4);
+
+	link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FENTRY, &opts);
+	if (!ASSERT_LT(link_fd, 0, "bpf_link_create"))
+		goto cleanup;
+
+	close(link_fd);
+
+	/* ... and fexit.multi */
+	prog_fd = bpf_program__fd(skel->progs.test5);
+
+	link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FEXIT, &opts);
+	if (!ASSERT_LT(link_fd, 0, "bpf_link_create"))
+		goto cleanup;
+
+	close(link_fd);
+
+	/* Try to load/attach extra programs on top of multi func programs,
+	 * it should fail for both fentry ...
+	 */
+	skel_extra1 = multi_attach_check_extra1__open_and_load();
+	if (!ASSERT_ERR_PTR(skel_extra1, "multi_attach_check_extra1__load"))
+		multi_attach_check_extra1__destroy(skel_extra1);
+
+	/* ... and fexit */
+	skel_extra2 = multi_attach_check_extra2__open_and_load();
+	if (!ASSERT_ERR_PTR(skel_extra2, "multi_attach_check_extra2__load"))
+		multi_attach_check_extra2__destroy(skel_extra2);
+
+cleanup:
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link3);
+	multi_attach_check__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_attach_check.c b/tools/testing/selftests/bpf/progs/multi_attach_check.c
new file mode 100644
index 000000000000..cf0f25c69556
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_attach_check.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	return 0;
+}
+
+SEC("fexit/bpf_fentry_test2")
+int BPF_PROG(test2, int a, __u64 b, int ret)
+{
+	return 0;
+}
+
+SEC("fentry.multi/bpf_fentry_test*")
+int BPF_PROG(test3, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
+{
+	return 0;
+}
+
+SEC("fentry.multi/bpf_fentry_test1-7")
+int BPF_PROG(test4, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	return 0;
+}
+
+SEC("fexit.multi/bpf_fentry_test1-7")
+int BPF_PROG(test5, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f, int ret)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_attach_check_extra1.c b/tools/testing/selftests/bpf/progs/multi_attach_check_extra1.c
new file mode 100644
index 000000000000..c1d816a0206a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_attach_check_extra1.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1, int a)
+{
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/multi_attach_check_extra2.c b/tools/testing/selftests/bpf/progs/multi_attach_check_extra2.c
new file mode 100644
index 000000000000..cd66abb4b848
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/multi_attach_check_extra2.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("fexit/bpf_fentry_test3")
+int BPF_PROG(test3, int a, __u64 b, int ret)
+{
+	return 0;
+}
-- 
2.31.1

