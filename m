Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC794B7BAA
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbiBPANL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:13:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244562AbiBPANF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:13:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55067DD460
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g205-20020a2552d6000000b0061e1843b8edso733551ybb.18
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=REY3pk0BoGNZKX6Lo+KrxmNqWG6NMmzP12YExN8vbiI=;
        b=GlEp4DxMa9Jx4nnFsTCvxILiewnVvUIge+4OoL4D9K9oizrqqmavIizzhq5ImBwBbx
         7nBkKArl6x63laZVyQG/YZgfCdvpd8C3a19tTK+1tcMcVsVHeFc+Sjkx5XQWCU41O5dn
         VtVrDjZ00+KjHaRDd92944AEBrqzEpPwqqWpuiQnlWQ1M7KKpCqD5nHk+kgRSzdTTzMb
         6QxZ5rV0Jv+z8ftunIYwp7Wk/nlAJRBRvIs3duhu0L95oW6d/AQW5i6QfAS9KNIbupbF
         nixXCpcVFFrZQMZpt5+dV9MUpfXTyD9Or885dOhbavq72NUda/RaBm9u4E4C9r6hiCmn
         ObZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=REY3pk0BoGNZKX6Lo+KrxmNqWG6NMmzP12YExN8vbiI=;
        b=X9hqAn0Gbz7mGVjkAkEqr1Syls8rPWWGftrge4qh0L3tdGbU3e8NNtONKXGXQJKs+E
         PUoofiJayAD77YicvWIZ5Adzska6MmPgRcDP0NNaYB0y1p9++XZUEUGs2A/vDGS4gNea
         JYSA+Vn9bw9Xl34+ThnQKdhzHiFSPJf1qwpHcwzHGgEgClftawt+2J0Y15qRuS1TfpLh
         AVv8d5mIWiMDj2yODpz9v9gCLauzIAVab6yaWQbU+Z4NkAZwAGg5c9c4KiFhMigx8D1v
         wUFL29KiG4vOhEf1rFbs966olfXgQwutnx2Sp3IlNvcORzVe0p7T0oksY35A3kZZoYHv
         9dwQ==
X-Gm-Message-State: AOAM530JeM1RZX+bJ8X0kgkhsF6D7BYAUlfnV5y1dGZdougEFOw2PRkZ
        gVgJpEvYVINqb8l8+cn/e27RlvFbP8kXTUy/F85FB2sgj9iVyrGOwf8+P3FNwIliZY92b1h2+DI
        XhxHoZGyPPJpjEbdUT8gxu4RzgaZIShtqL6TQmCVGrFtjDaQQP1NHXw==
X-Google-Smtp-Source: ABdhPJwuVNflF50dIGT2Y+Umaraw2zGd5e8whT4mYPi0KnAc5SppEKwzXDa1jA9L4wysvWVyGjJKwe0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:754a:e17d:48a0:d1db])
 (user=sdf job=sendgmr) by 2002:a25:5f08:0:b0:622:1e92:39ca with SMTP id
 t8-20020a255f08000000b006221e9239camr69826ybb.715.1644970373462; Tue, 15 Feb
 2022 16:12:53 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:12:41 -0800
In-Reply-To: <20220216001241.2239703-1-sdf@google.com>
Message-Id: <20220216001241.2239703-5-sdf@google.com>
Mime-Version: 1.0
References: <20220216001241.2239703-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC bpf-next 4/4] selftest: lsm_cgroup_sock sample usage
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement two things I'd like to get from this:

1. apply default sk_priority policy
2. permit TX-only AF_PACKET socket

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../bpf/prog_tests/lsm_cgroup_sock.c          | 81 +++++++++++++++++++
 .../selftests/bpf/progs/lsm_cgroup_sock.c     | 55 +++++++++++++
 2 files changed, 136 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup_sock.c

diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup_sock.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup_sock.c
new file mode 100644
index 000000000000..4afc40282b15
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup_sock.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <test_progs.h>
+
+#include "lsm_cgroup_sock.skel.h"
+
+void test_lsm_cgroup_sock(void)
+{
+	int post_create_prog_fd = -1, bind_prog_fd = -1;
+	struct lsm_cgroup_sock *skel = NULL;
+	int cgroup_fd, err, fd, prio;
+	socklen_t socklen;
+
+
+	cgroup_fd = test__join_cgroup("/sock_policy");
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		goto close_skel;
+
+	skel = lsm_cgroup_sock__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto close_cgroup;
+
+	err = lsm_cgroup_sock__attach(skel);
+	if (!ASSERT_OK(err, "attach"))
+		goto close_cgroup;
+
+	post_create_prog_fd = bpf_program__fd(skel->progs.socket_post_create);
+	bind_prog_fd = bpf_program__fd(skel->progs.socket_bind);
+
+	err = bpf_prog_attach(post_create_prog_fd, cgroup_fd, BPF_LSM_CGROUP_SOCK, 0);
+	if (!ASSERT_OK(err, "attach post_create_prog_fd"))
+		goto close_cgroup;
+
+	err = bpf_prog_attach(bind_prog_fd, cgroup_fd, BPF_LSM_CGROUP_SOCK, 0);
+	if (!ASSERT_OK(err, "attach bind_prog_fd"))
+		goto detach_cgroup;
+
+	/* AF_INET6 gets default policy (sk_priority).
+	 */
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
+		goto detach_cgroup;
+
+	prio = 0;
+	socklen = sizeof(prio);
+	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0, "getsockopt");
+	ASSERT_EQ(prio, 123, "sk_priority");
+
+	close(fd);
+
+	/* TX-only AF_PACKET is allowed.
+	 */
+
+	ASSERT_LT(socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL)), 0, "socket(AF_PACKET, ..., ETH_P_ALL)");
+
+	fd = socket(AF_PACKET, SOCK_RAW, 0);
+	ASSERT_GE(fd, 0, "socket(AF_PACKET, ..., 0)");
+
+	/* TX-only AF_PACKET can not be rebound.
+	 */
+
+	struct sockaddr_ll sa = {
+		.sll_family = AF_PACKET,
+		.sll_protocol = htons(ETH_P_ALL),
+	};
+	ASSERT_LT(bind(fd, (struct sockaddr *)&sa, sizeof(sa)), 0, "bind(ETH_P_ALL)");
+
+	close(fd);
+
+detach_cgroup:
+	bpf_prog_detach2(post_create_prog_fd, cgroup_fd, BPF_LSM_CGROUP_SOCK);
+	bpf_prog_detach2(bind_prog_fd, cgroup_fd, BPF_LSM_CGROUP_SOCK);
+
+close_cgroup:
+	close(cgroup_fd);
+close_skel:
+	lsm_cgroup_sock__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/lsm_cgroup_sock.c b/tools/testing/selftests/bpf/progs/lsm_cgroup_sock.c
new file mode 100644
index 000000000000..7fe3da5a8dc7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/lsm_cgroup_sock.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#ifndef AF_PACKET
+#define AF_PACKET 17
+#endif
+
+#ifndef EPERM
+#define EPERM 1
+#endif
+
+SEC("lsm_cgroup_sock/socket_post_create")
+int BPF_PROG(socket_post_create, struct socket *sock, int family,
+	     int type, int protocol, int kern)
+{
+	struct sock *sk;
+
+	/* Reject non-tx-only AF_PACKET.
+	 */
+	if (family == AF_PACKET && protocol != 0)
+		return 0; /* EPERM */
+
+	sk = sock->sk;
+	if (!sk)
+		return 1;
+
+	/* The rest of the sockets get default policy.
+	 */
+	sk->sk_priority = 123;
+	return 1;
+}
+
+SEC("lsm_cgroup_sock/socket_bind")
+int BPF_PROG(socket_bind, struct socket *sock, struct sockaddr *address,
+	     int addrlen)
+{
+	struct sockaddr_ll sa = {};
+
+	if (sock->sk->__sk_common.skc_family != AF_PACKET)
+		return 1;
+
+	if (sock->sk->sk_kern_sock)
+		return 1;
+
+	bpf_probe_read_kernel(&sa, sizeof(sa), address);
+	if (sa.sll_protocol)
+		return 0; /* EPERM */
+
+	return 1;
+}
-- 
2.35.1.265.g69c8d7142f-goog

