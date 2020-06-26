Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30E20A9B5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgFZAJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgFZAJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:09:38 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD837C08C5DD
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:09:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id v15so5324709pgi.3
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JSRT5WaSjm+Hfa8Hv/bWI3Jcjpw/nnAwcs/ZyVl3qZ0=;
        b=ULYvbk8jHkvhogTgP0Bewdx+UlEZwl4wsx48kzZQgc0H+SslgTXOQGeKydMUcmieMh
         QiqxR4DWVeJPevgJyFIWtzhOEO1BEY8HZ+kIJXkddxtINpiulD5F5XPU3lpFKlHuNhn8
         5VSaM1kAnpzvfsHSPhCMryNrbTZ4J0NOOhDVoOhoWKc1dZtiCcsgkucjruB4XBySW0/d
         HaL0bKGVl4LiGeoHjTpebhIQr9CIdBFMfxrM/WXsJFmeUl+FThxOO0PYbmxJcw434vl4
         TpE3tmCYvoW1F/MAdh4Uiy9dwLw0zWqQfOKAPz5d6QORjYbRnu6QMTi4dxnWpFkUBw0z
         D+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JSRT5WaSjm+Hfa8Hv/bWI3Jcjpw/nnAwcs/ZyVl3qZ0=;
        b=G+IkYs2BVW6TP0SjeddZ0+QAsxwH2G/1R089D34B9bnkaXBgfWgu2XOj3fycZ8FcGR
         sNmhtZVZlFikXnSFJyzH1TaqpGT9LFjxfPuh23Zh1cNeE+IpRLUrN7qPxzkZILd5Uvq9
         5LDYBGr2BH48skMNymZg5oUzIG2yGaFmWuj928Q3Th3LI7+Lc+5NjG4s/NF+vQrMj0sA
         Y8GnGky2ds0kG9IwnoWORZ+VseDVNyu8eFyPMmc5l7EVjMWLemhTRt9gp5CgBpLRi5rH
         +LSgUMk/aQq08IAof0kbsjJnyOL+V6QlJRIUbncIr76wSB2R4ZPCZHq/SgcK2UCbKni6
         Gx7Q==
X-Gm-Message-State: AOAM530yhDAhSHeVHjcY9NL2UbJrtRM1cL3hi9O95TdqSMbYDXSzVE2Y
        wFmBp95f+1+0hB9bm18kty0izH5SejSFZ30MnwrZRUP8eN8No81Fp6Q31OvjtJ5D8WfmbKgmfoQ
        vZxvizSy4cChwSgF1Cv8wQqzEIkBcxqq5uXTebxbBlvMqVme+RGzKvw==
X-Google-Smtp-Source: ABdhPJz+s3w2X1rq3a3/wUf8BzyCPL2H7IsK1g+gGI3WBEsyt/NWsqIzFmMm/Ea18lSYJY8HuA/NFoQ=
X-Received: by 2002:a17:90a:6a03:: with SMTP id t3mr550917pjj.174.1593130177216;
 Thu, 25 Jun 2020 17:09:37 -0700 (PDT)
Date:   Thu, 25 Jun 2020 17:09:29 -0700
In-Reply-To: <20200626000929.217930-1-sdf@google.com>
Message-Id: <20200626000929.217930-4-sdf@google.com>
Mime-Version: 1.0
References: <20200626000929.217930-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH bpf-next 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
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
2.27.0.111.gc72c7da667-goog

