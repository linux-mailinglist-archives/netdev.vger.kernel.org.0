Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984C11C61FF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgEEU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729037AbgEEU1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:27:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74FCC061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:27:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z11so16840ybk.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vR6JSXZj19+euZPVSEfIpnQIGh60prv9Ojq+fdLFVQI=;
        b=aUQN3yW1/gLtNfbzGYQpLYcP62xT66Y9HfoAI32RHT9jcmuyKe1slsLFq3JLsV2wL+
         A3y1MXSI+qJmwJyoxyDArylPRxEt+Hav8ahO6I0Be6/sW4fPhPe3bP/CVjWrMk3KdND7
         thb+q3zqoKtugss712hXcyFgki8w3aBShZowLAt8M5/5wOXdXixzranbjVkyZj4DG485
         phlWFoNvX9YbHqHaIFbfIEjB66ULavPTjM54ARiVHIZcLPaYC22jZngYVwyJkaS4hJGH
         i2S6wqNGmoLWMJie0OGk4BR2m5w1sxXn4T5lyqfUY587RVtGlRXMNstLx2aoEoqI/aWy
         lyGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vR6JSXZj19+euZPVSEfIpnQIGh60prv9Ojq+fdLFVQI=;
        b=bg1vpRLUb94G13zNj7iDfUgMuZvp5D24hHa9uizSQ/5H0mO1/sWnLxyJ4kI9PaFxpZ
         c71KsVOcQuj+IsmYh5eaFojR3yj4uEv6peQiUwgc3TcYWSBJZMCieMIdnxvQi80kRkHi
         qKmKajYduNk9pfcHbm7ubDGOwh6tznUvKrFZU//FfdCtajVlEK+/3k2XpX2ZKluY8UNQ
         9EGkxc8w4Koqh+ZLGNKRb8Fd7tflLVU/VYtwTBlVHjExy3UU42P1V/q4yOjKU4kkP9My
         tYxqqnskp5Prj0e/wnDq0mTaWWcxy9i+kl6QipD6+TKWF54pZrYrN3KmHBX+waF5FQ+b
         ik8Q==
X-Gm-Message-State: AGi0Pub5TZ6s7oEdyqPqdrzPq+YEZjxQ4u2cnQp0rtgRzBh8DCGxDoIr
        2kWYMh5Euyw46uDbM0Ai8Lf6ukc+xZ4jq/mta5ZqVQCRxOmyMWm+C8iBPUwY0aFtBd8TvlphSG8
        pY87EjfBev5mk2p+2pBu1C4tTjDYvIQtgi9D/iUpH7WTSfiMkx9CoBw==
X-Google-Smtp-Source: APiQypJvJxyFPgUa+PHZTvcamb1wkUqtGRzQMpJ8g2sDMKmuF8Zklnk7EzN1MfuttgFAyv7yvpwliJE=
X-Received: by 2002:a25:ba81:: with SMTP id s1mr7936893ybg.114.1588710459884;
 Tue, 05 May 2020 13:27:39 -0700 (PDT)
Date:   Tue,  5 May 2020 13:27:29 -0700
In-Reply-To: <20200505202730.70489-1-sdf@google.com>
Message-Id: <20200505202730.70489-5-sdf@google.com>
Mime-Version: 1.0
References: <20200505202730.70489-1-sdf@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v2 4/5] bpf: allow any port in bpf_bind helper
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to have a tighter control on what ports we bind to in
the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
connect() becomes slightly more expensive. The expensive part
comes from the fact that we now need to call inet_csk_get_port()
that verifies that the port is not used and allocates an entry
in the hash table for it.

Since we can't rely on "snum || !bind_address_no_port" to prevent
us from calling POST_BIND hook anymore, let's add another bind flag
to indicate that the call site is BPF program.

v2:
* Update documentation (Andrey Ignatov)
* Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/inet_common.h                     |   2 +
 include/uapi/linux/bpf.h                      |   9 +-
 net/core/filter.c                             |  18 ++-
 net/ipv4/af_inet.c                            |  10 +-
 net/ipv6/af_inet6.c                           |  12 +-
 tools/include/uapi/linux/bpf.h                |   9 +-
 .../bpf/prog_tests/connect_force_port.c       | 104 ++++++++++++++++++
 .../selftests/bpf/progs/connect_force_port4.c |  28 +++++
 .../selftests/bpf/progs/connect_force_port6.c |  28 +++++
 9 files changed, 192 insertions(+), 28 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index c38f4f7d660a..cb2818862919 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -39,6 +39,8 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
 #define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
 /* Grab and release socket lock. */
 #define BIND_WITH_LOCK			(1 << 1)
+/* Called from BPF program. */
+#define BIND_FROM_BPF			(1 << 2)
 int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		u32 flags);
 int inet_getname(struct socket *sock, struct sockaddr *uaddr,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b3643e27e264..14b5518a3d5b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1994,10 +1994,11 @@ union bpf_attr {
  *
  * 		This helper works for IPv4 and IPv6, TCP and UDP sockets. The
  * 		domain (*addr*\ **->sa_family**) must be **AF_INET** (or
- * 		**AF_INET6**). Looking for a free port to bind to can be
- * 		expensive, therefore binding to port is not permitted by the
- * 		helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
- * 		must be set to zero.
+ * 		**AF_INET6**). It's advised to pass zero port (**sin_port**
+ * 		or **sin6_port**) which triggers IP_BIND_ADDRESS_NO_PORT-like
+ * 		behavior and lets the kernel reuse the same source port
+ * 		as long as 4-tuple is unique. Passing non-zero port might
+ * 		lead to degraded performance.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
diff --git a/net/core/filter.c b/net/core/filter.c
index fa9ddab5dd1f..da0634979f53 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4525,32 +4525,28 @@ BPF_CALL_3(bpf_bind, struct bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
 {
 #ifdef CONFIG_INET
 	struct sock *sk = ctx->sk;
+	u32 flags = BIND_FROM_BPF;
 	int err;
 
-	/* Binding to port can be expensive so it's prohibited in the helper.
-	 * Only binding to IP is supported.
-	 */
 	err = -EINVAL;
 	if (addr_len < offsetofend(struct sockaddr, sa_family))
 		return err;
 	if (addr->sa_family == AF_INET) {
 		if (addr_len < sizeof(struct sockaddr_in))
 			return err;
-		if (((struct sockaddr_in *)addr)->sin_port != htons(0))
-			return err;
-		return __inet_bind(sk, addr, addr_len,
-				   BIND_FORCE_ADDRESS_NO_PORT);
+		if (((struct sockaddr_in *)addr)->sin_port == htons(0))
+			flags |= BIND_FORCE_ADDRESS_NO_PORT;
+		return __inet_bind(sk, addr, addr_len, flags);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (addr->sa_family == AF_INET6) {
 		if (addr_len < SIN6_LEN_RFC2133)
 			return err;
-		if (((struct sockaddr_in6 *)addr)->sin6_port != htons(0))
-			return err;
+		if (((struct sockaddr_in6 *)addr)->sin6_port == htons(0))
+			flags |= BIND_FORCE_ADDRESS_NO_PORT;
 		/* ipv6_bpf_stub cannot be NULL, since it's called from
 		 * bpf_cgroup_inet6_connect hook and ipv6 is already loaded
 		 */
-		return ipv6_bpf_stub->inet6_bind(sk, addr, addr_len,
-						 BIND_FORCE_ADDRESS_NO_PORT);
+		return ipv6_bpf_stub->inet6_bind(sk, addr, addr_len, flags);
 #endif /* CONFIG_IPV6 */
 	}
 #endif /* CONFIG_INET */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 68e74b1b0f26..fcf0d12a407a 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -526,10 +526,12 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 			err = -EADDRINUSE;
 			goto out_release_sock;
 		}
-		err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
-		if (err) {
-			inet->inet_saddr = inet->inet_rcv_saddr = 0;
-			goto out_release_sock;
+		if (!(flags & BIND_FROM_BPF)) {
+			err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
+			if (err) {
+				inet->inet_saddr = inet->inet_rcv_saddr = 0;
+				goto out_release_sock;
+			}
 		}
 	}
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 552c2592b81c..771a462a8322 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -407,11 +407,13 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 			err = -EADDRINUSE;
 			goto out;
 		}
-		err = BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk);
-		if (err) {
-			sk->sk_ipv6only = saved_ipv6only;
-			inet_reset_saddr(sk);
-			goto out;
+		if (!(flags & BIND_FROM_BPF)) {
+			err = BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk);
+			if (err) {
+				sk->sk_ipv6only = saved_ipv6only;
+				inet_reset_saddr(sk);
+				goto out;
+			}
 		}
 	}
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b3643e27e264..14b5518a3d5b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1994,10 +1994,11 @@ union bpf_attr {
  *
  * 		This helper works for IPv4 and IPv6, TCP and UDP sockets. The
  * 		domain (*addr*\ **->sa_family**) must be **AF_INET** (or
- * 		**AF_INET6**). Looking for a free port to bind to can be
- * 		expensive, therefore binding to port is not permitted by the
- * 		helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
- * 		must be set to zero.
+ * 		**AF_INET6**). It's advised to pass zero port (**sin_port**
+ * 		or **sin6_port**) which triggers IP_BIND_ADDRESS_NO_PORT-like
+ * 		behavior and lets the kernel reuse the same source port
+ * 		as long as 4-tuple is unique. Passing non-zero port might
+ * 		lead to degraded performance.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
diff --git a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
new file mode 100644
index 000000000000..97104e6410b6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+static int verify_port(int family, int fd, int expected)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	__u16 port;
+
+
+	if (getsockname(fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get server addr");
+		return -1;
+	}
+
+	if (family == AF_INET)
+		port = ((struct sockaddr_in *)&addr)->sin_port;
+	else
+		port = ((struct sockaddr_in6 *)&addr)->sin6_port;
+
+	if (ntohs(port) != expected) {
+		log_err("Unexpected port %d, expected %d", ntohs(port),
+			expected);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int run_test(int cgroup_fd, int server_fd, int family)
+{
+	struct bpf_prog_load_attr attr = {
+		.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+	};
+	struct bpf_object *obj;
+	int expected_port;
+	int prog_fd;
+	int err;
+	int fd;
+
+	if (family == AF_INET) {
+		attr.file = "./connect_force_port4.o";
+		attr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
+		expected_port = 22222;
+	} else {
+		attr.file = "./connect_force_port6.o";
+		attr.expected_attach_type = BPF_CGROUP_INET6_CONNECT;
+		expected_port = 22223;
+	}
+
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	if (err) {
+		log_err("Failed to load BPF object");
+		return -1;
+	}
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, attr.expected_attach_type,
+			      0);
+	if (err) {
+		log_err("Failed to attach BPF program");
+		goto close_bpf_object;
+	}
+
+	fd = connect_to_fd(family, server_fd);
+	if (fd < 0) {
+		err = -1;
+		goto close_bpf_object;
+	}
+
+	err = verify_port(family, fd, expected_port);
+
+	close(fd);
+
+close_bpf_object:
+	bpf_object__close(obj);
+	return err;
+}
+
+void test_connect_force_port(void)
+{
+	int server_fd, cgroup_fd;
+
+	cgroup_fd = test__join_cgroup("/connect_force_port");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	server_fd = start_server_thread(AF_INET);
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
+	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET));
+	stop_server_thread(server_fd);
+
+	server_fd = start_server_thread(AF_INET6);
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
+	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6));
+	stop_server_thread(server_fd);
+
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/connect_force_port4.c b/tools/testing/selftests/bpf/progs/connect_force_port4.c
new file mode 100644
index 000000000000..1b8eb34b2db0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/connect_force_port4.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <string.h>
+
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
+
+SEC("cgroup/connect4")
+int _connect4(struct bpf_sock_addr *ctx)
+{
+	struct sockaddr_in sa = {};
+
+	sa.sin_family = AF_INET;
+	sa.sin_port = bpf_htons(22222);
+	sa.sin_addr.s_addr = bpf_htonl(0x7f000001); /* 127.0.0.1 */
+
+	if (bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)) != 0)
+		return 0;
+
+	return 1;
+}
diff --git a/tools/testing/selftests/bpf/progs/connect_force_port6.c b/tools/testing/selftests/bpf/progs/connect_force_port6.c
new file mode 100644
index 000000000000..8cd1a9e81f64
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/connect_force_port6.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <string.h>
+
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") = "GPL";
+int _version SEC("version") = 1;
+
+SEC("cgroup/connect6")
+int _connect6(struct bpf_sock_addr *ctx)
+{
+	struct sockaddr_in6 sa = {};
+
+	sa.sin6_family = AF_INET;
+	sa.sin6_port = bpf_htons(22223);
+	sa.sin6_addr.s6_addr32[3] = bpf_htonl(1); /* ::1 */
+
+	if (bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)) != 0)
+		return 0;
+
+	return 1;
+}
-- 
2.26.2.526.g744177e7f7-goog

