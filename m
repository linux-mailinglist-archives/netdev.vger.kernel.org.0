Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5700320B652
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgFZQwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgFZQwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:52:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31EDC03E97A
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m63so10224128ybc.13
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZvkbolhDYPZ077HIxq1Xu+VvR7JsvXtNZjKWk9szn7I=;
        b=lVZlNdrHjJmnHZp1C/Mg4IVHrfILElZYzw0HVZGylOCwI80f3ZVmy78tN1n/g/txMm
         5EXo102ng9XtkGkuDDSMFZdnJVBYW0Ck2BlCaU6lj5aWqMKsQ67afYYBPu0HBEurBOUx
         5vAmqQD8qiKvaxjt0bivJUkg6hx3WhzjVC8C/XeYNfa3Ft2TaKiV6NY+e7RzHKOFOfsA
         5tbvCBmV/obWNPm/5qnixlRs+CJGKulSsQgM3KZjr+lKfIdFbQDSgNfzzAee3/YSidOa
         1b/DFHo+z3dvsZo8x1LxNvTfPCotb89C8SpcadvsdNsOrqQpRA0TkWHgMwBOczMgIlHf
         oFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZvkbolhDYPZ077HIxq1Xu+VvR7JsvXtNZjKWk9szn7I=;
        b=EBXj1fTEYGoZukTNLuKobB7BNP1Supja+xjOprU7Cxj5FaVS+lbkuJFfdgZHbQyNCj
         lmQwo1TlI09GHR7yvY20V3LxqEYyhSc86wh3tNPO3PSpxuTUfx39DjudSzrxvagsGtog
         EeP1VWatTW9GZg+FWqjWoYXqMkaZYdZFQU2y37VvTdDNxaHJxxfBsdbcZIYYz+gioSiq
         4/7o/x8MLIUuPW1OMt8PRQUm5pdngd83G0j3KMtdF6jFV7csn4y+GsEWC2VXOj4IVlGF
         1mtsowB0uArlmFET7lB6jeOfcPmoCP77tsNMsMFS+0bT/Sc6N4yJUign5sFrUdfN/sZp
         CM2A==
X-Gm-Message-State: AOAM5336JwbTELbwh3eSa5ZGk6OurBwwmfXx9bJTzZDm+LIosKYzcZII
        l/wl+WWwyUUINmYTeACg7KYG8dMJSyRNkLqkJpMJDvxnwF9DiSpcelQGzTDfwKkC3+Iyej09uU8
        IwFF6ZHwXJi2JcBdyJt/Zv6arsbH513S7L+1f9yylIrvZyD701J4l9w==
X-Google-Smtp-Source: ABdhPJzf7JX+OydvL4GIEdUgbNsNk/nEcox1xCQ5ruP6iYvqKcxyq+EsHIOXFOvWCaXuAkuwGNQJhe0=
X-Received: by 2002:a25:abd2:: with SMTP id v76mr6280518ybi.111.1593190358970;
 Fri, 26 Jun 2020 09:52:38 -0700 (PDT)
Date:   Fri, 26 Jun 2020 09:52:31 -0700
In-Reply-To: <20200626165231.672001-1-sdf@google.com>
Message-Id: <20200626165231.672001-4-sdf@google.com>
Mime-Version: 1.0
References: <20200626165231.672001-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v2 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple test that enforces a single SOCK_DGRAM socker per cgroup.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/udp_limit.c      | 71 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
 2 files changed, 113 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
 create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c

diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
new file mode 100644
index 000000000000..fe359a927d92
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "udp_limit.skel.h"
+
+#include <sys/types.h>
+#include <sys/socket.h>
+
+void test_udp_limit(void)
+{
+	struct udp_limit *skel;
+	int cgroup_fd;
+	int fd1, fd2;
+	int err;
+
+	cgroup_fd = test__join_cgroup("/udp_limit");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	skel = udp_limit__open_and_load();
+	if (CHECK_FAIL(!skel))
+		goto close_cgroup_fd;
+
+	err = bpf_prog_attach(bpf_program__fd(skel->progs.sock),
+			      cgroup_fd, BPF_CGROUP_INET_SOCK_CREATE, 0);
+	if (CHECK_FAIL(err))
+		goto close_skeleton;
+
+	err = bpf_prog_attach(bpf_program__fd(skel->progs.sock_release),
+			      cgroup_fd, BPF_CGROUP_INET_SOCK_RELEASE, 0);
+	if (CHECK_FAIL(err))
+		goto close_skeleton;
+
+	/* BPF program enforces a single UDP socket per cgroup,
+	 * verify that.
+	 */
+	fd1 = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK_FAIL(fd1 < 0))
+		goto close_skeleton;
+
+	fd2 = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK_FAIL(fd2 != -1))
+		goto close_fd1;
+
+	/* We can reopen again after close. */
+	close(fd1);
+
+	fd1 = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK_FAIL(fd1 < 0))
+		goto close_skeleton;
+
+	/* Make sure the program was invoked the expected
+	 * number of times:
+	 * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
+	 * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
+	 * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
+	 * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
+	 */
+	if (CHECK_FAIL(skel->bss->invocations != 4))
+		goto close_fd1;
+
+	/* We should still have a single socket in use */
+	if (CHECK_FAIL(skel->bss->in_use != 1))
+		goto close_fd1;
+
+close_fd1:
+	close(fd1);
+close_skeleton:
+	udp_limit__destroy(skel);
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
new file mode 100644
index 000000000000..98fe294d9c21
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/udp_limit.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <sys/socket.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+int invocations, in_use;
+
+SEC("cgroup/sock")
+int sock(struct bpf_sock *ctx)
+{
+	__u32 key;
+
+	if (ctx->type != SOCK_DGRAM)
+		return 1;
+
+	__sync_fetch_and_add(&invocations, 1);
+
+	if (&in_use > 0) {
+		/* BPF_CGROUP_INET_SOCK_RELEASE is _not_ called
+		 * when we return an error from the BPF
+		 * program!
+		 */
+		return 0;
+	}
+
+	__sync_fetch_and_add(&in_use, 1);
+	return 1;
+}
+
+SEC("cgroup/sock_release")
+int sock_release(struct bpf_sock *ctx)
+{
+	__u32 key;
+
+	if (ctx->type != SOCK_DGRAM)
+		return 1;
+
+	__sync_fetch_and_add(&invocations, 1);
+	__sync_fetch_and_add(&in_use, -1);
+	return 1;
+}
-- 
2.27.0.212.ge8ba1cc988-goog

