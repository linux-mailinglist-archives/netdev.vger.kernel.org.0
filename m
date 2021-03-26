Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820A834A53C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhCZKDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhCZKDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616753012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1aHJVxe6uoiZMEQjmNfP9XIXtXVFqt+4EqtqxEvdyy8=;
        b=ZbGIryEZi9oqom7TWZNoM59NCSxU1sZDCTHMCNgBCJNNu4dcflLrDASLupGjcLsi+JN5Zw
        BQc1VZJf48MYvgA0yShWGwY4ZTllNcAGvDsX1avTTzhUsFxcrqNKafA4D1ttfvxhLLJzPC
        bDwKlzxUYIzJXPZ6mbNQ/gmh7H9qfSE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-n0tIJCDBOrulYPAhWIq36Q-1; Fri, 26 Mar 2021 06:03:30 -0400
X-MC-Unique: n0tIJCDBOrulYPAhWIq36Q-1
Received: by mail-ej1-f71.google.com with SMTP id gn30so3867108ejc.3
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 03:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1aHJVxe6uoiZMEQjmNfP9XIXtXVFqt+4EqtqxEvdyy8=;
        b=XpDXV/7UyvmS19JmPbor7D9EU1HPzC+lseJ8qRVhWoPHmPTofY58GcTVZHqJ6lBE5g
         fRhDZJbDOE//oOEarB7wT4UI+UJI+HS9FcSZLjqTnc/Ru32ppFIgttWetLEDWwSWSoNi
         bYQv2Nd7XQsNAW+QGf6hEXTbuBacEr3S7kbvWhr6Ehq9CSUVUoUGbXg8D4VGMWXQ/mb2
         bFkCbUhbaV+mm9Sja9RJdSHEwE7e6dOpq2p5ngrYdUeOHrt3F+yA/WE8Y9pCZ2v7oYGW
         ELnNktrgKdRd2bRxu4cB6ab/lO8ELTQ2vNDYovcNL2V6CUrKUdHjbKyyp/N+DNiDtgom
         OZWw==
X-Gm-Message-State: AOAM5331x3F30o56z61nB+TiivZRPAdqDV4rEFQMC74XQEOockzPmhBE
        9ppe8atK+1fc7hpmVZAATtQKn9pKH7VzjfZdJO3XS6mLihPfUn7YedGHxyPaqHhIFlEEGjA++/f
        CWbXs/7jU1fGPFsdx
X-Received: by 2002:a05:6402:30a2:: with SMTP id df2mr13726761edb.29.1616753008907;
        Fri, 26 Mar 2021 03:03:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb5MKbcXT1DxlGqWXsp03h4Wp2942dAkC02B5NcAWh+ValK3Ii7qW6U4P+GYnG/0O2VD3F8A==
X-Received: by 2002:a05:6402:30a2:: with SMTP id df2mr13726723edb.29.1616753008628;
        Fri, 26 Mar 2021 03:03:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v22sm3629988ejj.103.2021.03.26.03.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 03:03:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AA4CE1801A3; Fri, 26 Mar 2021 11:03:27 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v3 2/2] bpf/selftests: test that kernel rejects a TCP CC with an invalid license
Date:   Fri, 26 Mar 2021 11:03:14 +0100
Message-Id: <20210326100314.121853-2-toke@redhat.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326100314.121853-1-toke@redhat.com>
References: <20210326100314.121853-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a selftest to check that the verifier rejects a TCP CC struct_ops
with a non-GPL license.

v3:
- Rename prog to bpf_tcp_nogpl
- Use ASSERT macros instead of CHECK
- Skip unneeded initialisation, unconditionally close skeleton
v2:
- Use a minimal struct_ops BPF program instead of rewriting bpf_dctcp's
  license in memory.
- Check for the verifier reject message instead of just the return code.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 44 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_tcp_nogpl.c       | 19 ++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 37c5494a0381..e25917f04602 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -6,6 +6,7 @@
 #include <test_progs.h>
 #include "bpf_dctcp.skel.h"
 #include "bpf_cubic.skel.h"
+#include "bpf_tcp_nogpl.skel.h"
 
 #define min(a, b) ((a) < (b) ? (a) : (b))
 
@@ -227,10 +228,53 @@ static void test_dctcp(void)
 	bpf_dctcp__destroy(dctcp_skel);
 }
 
+static char *err_str;
+static bool found;
+
+static int libbpf_debug_print(enum libbpf_print_level level,
+			      const char *format, va_list args)
+{
+	char *log_buf;
+
+	if (level != LIBBPF_WARN ||
+	    strcmp(format, "libbpf: \n%s\n")) {
+		vprintf(format, args);
+		return 0;
+	}
+
+	log_buf = va_arg(args, char *);
+	if (!log_buf)
+		goto out;
+	if (err_str && strstr(log_buf, err_str) != NULL)
+		found = true;
+out:
+	printf(format, log_buf);
+	return 0;
+}
+
+static void test_invalid_license(void)
+{
+	libbpf_print_fn_t old_print_fn;
+	struct bpf_tcp_nogpl *skel;
+
+	err_str = "struct ops programs must have a GPL compatible license";
+	found = false;
+	old_print_fn = libbpf_set_print(libbpf_debug_print);
+
+	skel = bpf_tcp_nogpl__open_and_load();
+	ASSERT_NULL(skel, "bpf_tcp_nogpl");
+	ASSERT_EQ(found, true, "expected_err_msg");
+
+	bpf_tcp_nogpl__destroy(skel);
+	libbpf_set_print(old_print_fn);
+}
+
 void test_bpf_tcp_ca(void)
 {
 	if (test__start_subtest("dctcp"))
 		test_dctcp();
 	if (test__start_subtest("cubic"))
 		test_cubic();
+	if (test__start_subtest("invalid_license"))
+		test_invalid_license();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c b/tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c
new file mode 100644
index 000000000000..2ecd833dcd41
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_tcp_nogpl.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") = "X";
+
+void BPF_STRUCT_OPS(nogpltcp_init, struct sock *sk)
+{
+}
+
+SEC(".struct_ops")
+struct tcp_congestion_ops bpf_nogpltcp = {
+	.init           = (void *)nogpltcp_init,
+	.name           = "bpf_nogpltcp",
+};
-- 
2.31.0

