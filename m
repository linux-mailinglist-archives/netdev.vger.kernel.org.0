Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDD7265D3E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 12:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgIKKAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 06:00:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32138 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbgIKJ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 05:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599818369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VxoWDrTG5yV8ILjFLjzLOABm6GkXZ8lP0vOJBmq5UxE=;
        b=ePMVX90/2ZlMoAV4wDpoo9ZnwsYuEYMBYNvH7aIDqX2kXjj/0eNRKFq/ZwR4zKrijalThu
        /mqpJDonz3i5ZMRk7MUze0czbWPezQTSzUwZz7GsepiTEgMQvbD41NRVKmlaSvYXoxqH+3
        gDEzmO54X2IXVme+CkduGQ8CkdePjJg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-1npx9dwYNdCMubPfPHIh1g-1; Fri, 11 Sep 2020 05:59:27 -0400
X-MC-Unique: 1npx9dwYNdCMubPfPHIh1g-1
Received: by mail-wm1-f72.google.com with SMTP id b14so1170357wmj.3
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 02:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VxoWDrTG5yV8ILjFLjzLOABm6GkXZ8lP0vOJBmq5UxE=;
        b=nx8wwPhmxi1xcnqybC53tY9Y+M5DdWfZ/C7ZLJRNoLvt+t/ZAF6Cjxb9WA6LtnIxLX
         9QiZxNIHzar4DbFIheOKNN0QVk/oPsOQ5UDL8p35IxAgPua1eBl89VRv+YWCQkvxriIu
         nf2TOskeUqD7sgb3GsL9V6vRcWOYDTEpvAM1S4kewnOx1yvZDn9sN9SPM7NzfATBR4e0
         VuE9JfJGXSkLAn41RSs49PgfNSHJqUqhwKKbW98PFYFC0dRD49GIaVSCoz1vfOBJFqnj
         8Jra6PNxyRQjZIsadzx/OnnrpsjQlM1+EoYDTUZPCHGNN2890x8HV0JtrM2bRcZUER0S
         pKTA==
X-Gm-Message-State: AOAM531oj9YtKrCOJxkbPv6ixgDBOZqUAtSuZpyaOrCFGHB9Mi3E3xzr
        k73Zsx0AuPqNs30QTO0szzVP4FzClZrIQTXkfudCr8Jx2cg+AE5VSwnr/ZSHuYNmz1q6QfMcFoP
        AIocASOinJzkkxYLv
X-Received: by 2002:a5d:540e:: with SMTP id g14mr1297654wrv.148.1599818366133;
        Fri, 11 Sep 2020 02:59:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9FS+7iM/FDNUz0LMDExPUt+Os38bHluT0fv5XUITWj8loAhV4JJ3Yx1sEl+rBqY/NPN5JBw==
X-Received: by 2002:a5d:540e:: with SMTP id g14mr1297626wrv.148.1599818365716;
        Fri, 11 Sep 2020 02:59:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t16sm3575929wrm.57.2020.09.11.02.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 02:59:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A197A1829D5; Fri, 11 Sep 2020 11:59:24 +0200 (CEST)
Subject: [PATCH RESEND bpf-next v3 9/9] selftests/bpf: Adding test for arg
 dereference in extension trace
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 11 Sep 2020 11:59:24 +0200
Message-ID: <159981836456.134722.9699480583685238902.stgit@toke.dk>
In-Reply-To: <159981835466.134722.8652987144251743467.stgit@toke.dk>
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding test that setup following program:

  SEC("classifier/test_pkt_md_access")
  int test_pkt_md_access(struct __sk_buff *skb)

with its extension:

  SEC("freplace/test_pkt_md_access")
  int test_pkt_md_access_new(struct __sk_buff *skb)

and tracing that extension with:

  SEC("fentry/test_pkt_md_access_new")
  int BPF_PROG(fentry, struct sk_buff *skb)

The test verifies that the tracing program can
dereference skb argument properly.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |   93 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_trace_ext.c |   18 ++++
 .../selftests/bpf/progs/test_trace_ext_tracing.c   |   25 +++++
 3 files changed, 136 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_ext.c b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
new file mode 100644
index 000000000000..1089dafb4653
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <sys/stat.h>
+#include <linux/sched.h>
+#include <sys/syscall.h>
+
+#include "test_trace_ext.skel.h"
+#include "test_trace_ext_tracing.skel.h"
+
+static __u32 duration;
+
+void test_trace_ext(void)
+{
+	struct test_trace_ext_tracing *skel_trace = NULL;
+	struct test_trace_ext_tracing__bss *bss_trace;
+	const char *file = "./test_pkt_md_access.o";
+	struct test_trace_ext *skel_ext = NULL;
+	struct test_trace_ext__bss *bss_ext;
+	int err, prog_fd, ext_fd;
+	struct bpf_object *obj;
+	char buf[100];
+	__u32 retval;
+	__u64 len;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			    .attach_prog_fd = prog_fd,
+	);
+
+	skel_ext = test_trace_ext__open_opts(&opts);
+	if (CHECK(!skel_ext, "setup", "freplace/test_pkt_md_access open failed\n"))
+		goto cleanup;
+
+	err = test_trace_ext__load(skel_ext);
+	if (CHECK(err, "setup", "freplace/test_pkt_md_access load failed\n")) {
+		libbpf_strerror(err, buf, sizeof(buf));
+		fprintf(stderr, "%s\n", buf);
+		goto cleanup;
+	}
+
+	err = test_trace_ext__attach(skel_ext);
+	if (CHECK(err, "setup", "freplace/test_pkt_md_access attach failed: %d\n", err))
+		goto cleanup;
+
+	ext_fd = bpf_program__fd(skel_ext->progs.test_pkt_md_access_new);
+
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts_trace,
+			    .attach_prog_fd = ext_fd,
+	);
+
+	skel_trace = test_trace_ext_tracing__open_opts(&opts_trace);
+	if (CHECK(!skel_trace, "setup", "tracing/test_pkt_md_access_new open failed\n"))
+		goto cleanup;
+
+	err = test_trace_ext_tracing__load(skel_trace);
+	if (CHECK(err, "setup", "tracing/test_pkt_md_access_new load failed\n")) {
+		libbpf_strerror(err, buf, sizeof(buf));
+		fprintf(stderr, "%s\n", buf);
+		goto cleanup;
+	}
+
+	err = test_trace_ext_tracing__attach(skel_trace);
+	if (CHECK(err, "setup", "tracing/test_pkt_md_access_new attach failed: %d\n", err))
+		goto cleanup;
+
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, &retval, &duration);
+	CHECK(err || retval, "",
+	      "err %d errno %d retval %d duration %d\n",
+	      err, errno, retval, duration);
+
+	bss_ext = skel_ext->bss;
+	bss_trace = skel_trace->bss;
+
+	len = bss_ext->ext_called;
+
+	CHECK(bss_ext->ext_called == 0,
+		"check", "failed to trigger freplace/test_pkt_md_access\n");
+	CHECK(bss_trace->fentry_called != len,
+		"check", "failed to trigger fentry/test_pkt_md_access_new\n");
+	CHECK(bss_trace->fexit_called != len,
+		"check", "failed to trigger fexit/test_pkt_md_access_new\n");
+
+cleanup:
+	test_trace_ext__destroy(skel_ext);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext.c b/tools/testing/selftests/bpf/progs/test_trace_ext.c
new file mode 100644
index 000000000000..a6318f6b52ee
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_trace_ext.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/bpf.h>
+#include <stdbool.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+
+volatile __u64 ext_called = 0;
+
+SEC("freplace/test_pkt_md_access")
+int test_pkt_md_access_new(struct __sk_buff *skb)
+{
+	ext_called = skb->len;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c b/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
new file mode 100644
index 000000000000..9e52a831446f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+volatile __u64 fentry_called = 0;
+
+SEC("fentry/test_pkt_md_access_new")
+int BPF_PROG(fentry, struct sk_buff *skb)
+{
+	fentry_called = skb->len;
+	return 0;
+}
+
+volatile __u64 fexit_called = 0;
+
+SEC("fexit/test_pkt_md_access_new")
+int BPF_PROG(fexit, struct sk_buff *skb)
+{
+	fexit_called = skb->len;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";

