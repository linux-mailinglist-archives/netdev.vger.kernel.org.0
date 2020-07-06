Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FD52161CC
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgGFXBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGFXBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:01:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA559C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:01:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j3so44988699yba.14
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UOfLeSIX/vN48wokU9rUl/nDRnnmynb7K/LiRKTXjzM=;
        b=TihZ8FZljIektigHuHaz5Lc4zSNs42KLqY5hGphgyBeuP9kih3gMiU0tq2KR/eL1Yw
         pk6YrXQfjx25k6nrIxrVhEt2Sh0Zxek9q3zf6/2ki8TkpnaOshNiPrGuJHE9NCtcpIzv
         hMeYZ79GqWYOacs2mVdwDgj2sMqD4kxn+jtD0tfClYRPXGT7f6QYTC1UDDpr7Kd9X01O
         o7n/le+fj3LQA7Sb7fm0xM/TAc3duRRJwafm/NYA07ysM6X/NZ+4qvJPlvIz2e5+JAzs
         k3SyTdCZMW1XP0JSnv/z2qCtRZEOjP2yfRzK/OTPuNE9zTN7r0n7GI4LZKMD6TvXmRJl
         JFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UOfLeSIX/vN48wokU9rUl/nDRnnmynb7K/LiRKTXjzM=;
        b=eTfjph+GdWYs/b6K0S5Nu6nxy8v9gPO+wgYYirBZhqGn57Ovd77sb2a3JuzQ3BQhtu
         YMl6DWPVKxlsi0/D4QeyD0eh1Nc1UDRkMTmE3CvyiO0il6fTz+lbmM7u019qZVvDi8GN
         fuWLi1mvuCoaTi7MuyqlTy95y994HZtydATyFXeZZEF+cu4EEvekJ4+B9k50/dLwuysM
         kNFwLBblNU6hg95LKsib1L1pmmcqdtMV7GOLxTRcUw6X7eXiN+QpA4OE/DuPpjhu9wHN
         hf9f34j2qaYKDcwe9BmlOj8BJUBzgCt4m+xsjiiQk+SjAm35s0AA/pv6H/yzL8iGL35l
         /PzA==
X-Gm-Message-State: AOAM532RFW3M39D6WVBPmkZx2X0Qd4agJb0NN39zPGPMY5y6qkU/38f4
        f8OlXTRIo4o6P1Rqg6xOs0y05ZK63ETucRi65r2GEw65sIEOQNqFjVRNxZ5PvzQJJyPJG9z7W4w
        h5mOl6cyDytrHEhUcGSNJtp3p3XAG8EARkS34uVA3oo3Nm5dbSrXDOg==
X-Google-Smtp-Source: ABdhPJxU8uAHBKnpXVE70pUxqCtMUYzKf6tRJfOWQ4I91xzNcxCgITgO+fVd0v/sBCOBcrsiHUu02sk=
X-Received: by 2002:a25:ae01:: with SMTP id a1mr17679132ybj.119.1594076497898;
 Mon, 06 Jul 2020 16:01:37 -0700 (PDT)
Date:   Mon,  6 Jul 2020 16:01:28 -0700
In-Reply-To: <20200706230128.4073544-1-sdf@google.com>
Message-Id: <20200706230128.4073544-5-sdf@google.com>
Mime-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v4 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
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
 .../selftests/bpf/prog_tests/udp_limit.c      | 75 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
 2 files changed, 117 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
 create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c

diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
new file mode 100644
index 000000000000..2aba09d4d01b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "udp_limit.skel.h"
+
+#include <sys/types.h>
+#include <sys/socket.h>
+
+static int duration;
+
+void test_udp_limit(void)
+{
+	struct udp_limit *skel;
+	int fd1 = -1, fd2 = -1;
+	int cgroup_fd;
+
+	cgroup_fd = test__join_cgroup("/udp_limit");
+	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
+		return;
+
+	skel = udp_limit__open_and_load();
+	if (CHECK(!skel, "skel-load", "errno %d", errno))
+		goto close_cgroup_fd;
+
+	skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock, cgroup_fd);
+	skel->links.sock_release = bpf_program__attach_cgroup(skel->progs.sock_release, cgroup_fd);
+	if (CHECK(IS_ERR(skel->links.sock) || IS_ERR(skel->links.sock_release),
+		  "cg-attach", "sock %ld sock_release %ld",
+		  PTR_ERR(skel->links.sock),
+		  PTR_ERR(skel->links.sock_release)))
+		goto close_skeleton;
+
+	/* BPF program enforces a single UDP socket per cgroup,
+	 * verify that.
+	 */
+	fd1 = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK(fd1 < 0, "fd1", "errno %d", errno))
+		goto close_skeleton;
+
+	fd2 = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK(fd2 >= 0, "fd2", "errno %d", errno))
+		goto close_skeleton;
+
+	/* We can reopen again after close. */
+	close(fd1);
+	fd1 = -1;
+
+	fd1 = socket(AF_INET, SOCK_DGRAM, 0);
+	if (CHECK(fd1 < 0, "fd1-again", "errno %d", errno))
+		goto close_skeleton;
+
+	/* Make sure the program was invoked the expected
+	 * number of times:
+	 * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
+	 * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
+	 * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
+	 * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
+	 */
+	if (CHECK(skel->bss->invocations != 4, "bss-invocations",
+		  "invocations=%d", skel->bss->invocations))
+		goto close_skeleton;
+
+	/* We should still have a single socket in use */
+	if (CHECK(skel->bss->in_use != 1, "bss-in_use",
+		  "in_use=%d", skel->bss->in_use))
+		goto close_skeleton;
+
+close_skeleton:
+	if (fd1 >= 0)
+		close(fd1);
+	if (fd2 >= 0)
+		close(fd2);
+	udp_limit__destroy(skel);
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
new file mode 100644
index 000000000000..edbb30a27e63
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/udp_limit.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <sys/socket.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+int invocations = 0, in_use = 0;
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
+	if (in_use > 0) {
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

