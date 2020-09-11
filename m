Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2632661AE
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 16:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgIKO7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 10:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIKO6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 10:58:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C4C061365
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z22so14077833ejl.7
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 07:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+i8R58kw/leW4I2M13LKbuHEybfMrzesYwlJiGTgtNk=;
        b=a15BUZJRqua56q81WMjBEDQ3iSAVjqj55mNjlT0LHm7fj8zncIWlNPf3SrHkC/eofS
         MUhGOCYkv34QW1doX+CMNH+ev+OYMNBtjPe9GoTZyrcxRq00tSwp53Z8f4pxs2Jw1udo
         Z6k1oSYZLFfsSuR/MgGY022bxzWljeVKwumPP+KmaGAHP0/7QGVkbf3SA2+C8GzGvjt5
         wDsUMZSigxwNqh19nEEHq3Yn9wkEF05CIk2+FnoopbRLINo3K1qss/pCs8zx7AwKQMhX
         ROL8xgPAq1U794RkujJ3S5Bi024Rd92qVakoS/PyvX/Vv9XhMrkfYcv/0ovX0sczmaHf
         sISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+i8R58kw/leW4I2M13LKbuHEybfMrzesYwlJiGTgtNk=;
        b=rR5DtEkxWIeGeGDd7kBmtK39rdo+sdRq28uhZZrLeAxM5xLHzpJop2OuX/hSJR8p1r
         CyoGE7F0y5pbZ9p9mL3CZp1wpF0ZcP1kAbMC/1X/bwJq3KuvBm0NVAlCiLhXYahCLtDt
         x/S2poP6qfT7GdQ1SLgjJRTZwH88Dgo5JQajkiKBAA1qzc0Sp7j5V3HJwiymdkHuB9BU
         sDvpMbxBfcWLeDdWUVtDNaV8hAsRx9zLLgLi99IAKinHSQ7Tkt5mrfn/a4k9PSaLWRDD
         m8C4rsxT4EvoPJyoQW+9RNEvs+AQ3XJYkO7CRWWAQhfz+DS+ZNtwUN8dY19/S0MfvQtk
         mmKg==
X-Gm-Message-State: AOAM533m21EABI0dNYVb5x2UU/SZZVKnF/haNBMYIDwIN/Aw94QzrnAT
        JJW7Z+m5pQh+WKwb1xvwP8n1VQ==
X-Google-Smtp-Source: ABdhPJy1pF6nMvBpXqraqaRNOATVMTu/betL9JR2wN4Oe0zmBlv0YY5nb7O5C/sfCFUnKtFrAXQASw==
X-Received: by 2002:a17:906:1b55:: with SMTP id p21mr2425207ejg.457.1599834675454;
        Fri, 11 Sep 2020 07:31:15 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id y21sm1716261eju.46.2020.09.11.07.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 07:31:14 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 4/5] bpf: selftests: add MPTCP test base
Date:   Fri, 11 Sep 2020 16:30:19 +0200
Message-Id: <20200911143022.414783-4-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a base for MPTCP specific tests.

It is currently limited to the is_mptcp field in case of plain TCP
connection because for the moment there is no easy way to get the subflow
sk from a msk in userspace. This implies that we cannot lookup the
sk_storage attached to the subflow sk in the sockops program.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---

Notes:
    v1 -> v2:
    - new patch: mandatory selftests (Alexei)

 tools/testing/selftests/bpf/config            |   1 +
 tools/testing/selftests/bpf/network_helpers.c |  37 +++++-
 tools/testing/selftests/bpf/network_helpers.h |   3 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 119 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/mptcp.c     |  48 +++++++
 5 files changed, 203 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
 create mode 100644 tools/testing/selftests/bpf/progs/mptcp.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 2118e23ac07a..8377836ea976 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -39,3 +39,4 @@ CONFIG_BPF_JIT=y
 CONFIG_BPF_LSM=y
 CONFIG_SECURITY=y
 CONFIG_LIRC=y
+CONFIG_MPTCP=y
diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 12ee40284da0..85cbb683965c 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -14,6 +14,10 @@
 #include "bpf_util.h"
 #include "network_helpers.h"
 
+#ifndef IPPROTO_MPTCP
+#define IPPROTO_MPTCP 262
+#endif
+
 #define clean_errno() (errno == 0 ? "None" : strerror(errno))
 #define log_err(MSG, ...) ({						\
 			int __save = errno;				\
@@ -66,8 +70,8 @@ static int settimeo(int fd, int timeout_ms)
 
 #define save_errno_close(fd) ({ int __save = errno; close(fd); errno = __save; })
 
-int start_server(int family, int type, const char *addr_str, __u16 port,
-		 int timeout_ms)
+static int start_server_proto(int family, int type, int protocol,
+			      const char *addr_str, __u16 port, int timeout_ms)
 {
 	struct sockaddr_storage addr = {};
 	socklen_t len;
@@ -76,7 +80,7 @@ int start_server(int family, int type, const char *addr_str, __u16 port,
 	if (make_sockaddr(family, addr_str, port, &addr, &len))
 		return -1;
 
-	fd = socket(family, type, 0);
+	fd = socket(family, type, protocol);
 	if (fd < 0) {
 		log_err("Failed to create server socket");
 		return -1;
@@ -104,6 +108,19 @@ int start_server(int family, int type, const char *addr_str, __u16 port,
 	return -1;
 }
 
+int start_server(int family, int type, const char *addr_str, __u16 port,
+		 int timeout_ms)
+{
+	return start_server_proto(family, type, 0, addr_str, port, timeout_ms);
+}
+
+int start_mptcp_server(int family, const char *addr_str, __u16 port,
+		       int timeout_ms)
+{
+	return start_server_proto(family, SOCK_STREAM, IPPROTO_MPTCP, addr_str,
+				  port, timeout_ms);
+}
+
 int fastopen_connect(int server_fd, const char *data, unsigned int data_len,
 		     int timeout_ms)
 {
@@ -153,7 +170,7 @@ static int connect_fd_to_addr(int fd,
 	return 0;
 }
 
-int connect_to_fd(int server_fd, int timeout_ms)
+static int connect_to_fd_proto(int server_fd, int protocol, int timeout_ms)
 {
 	struct sockaddr_storage addr;
 	struct sockaddr_in *addr_in;
@@ -173,7 +190,7 @@ int connect_to_fd(int server_fd, int timeout_ms)
 	}
 
 	addr_in = (struct sockaddr_in *)&addr;
-	fd = socket(addr_in->sin_family, type, 0);
+	fd = socket(addr_in->sin_family, type, protocol);
 	if (fd < 0) {
 		log_err("Failed to create client socket");
 		return -1;
@@ -192,6 +209,16 @@ int connect_to_fd(int server_fd, int timeout_ms)
 	return -1;
 }
 
+int connect_to_fd(int server_fd, int timeout_ms)
+{
+	return connect_to_fd_proto(server_fd, 0, timeout_ms);
+}
+
+int connect_to_mptcp_fd(int server_fd, int timeout_ms)
+{
+	return connect_to_fd_proto(server_fd, IPPROTO_MPTCP, timeout_ms);
+}
+
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
 {
 	struct sockaddr_storage addr;
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index 7205f8afdba1..336423a789e9 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -35,7 +35,10 @@ extern struct ipv6_packet pkt_v6;
 
 int start_server(int family, int type, const char *addr, __u16 port,
 		 int timeout_ms);
+int start_mptcp_server(int family, const char *addr, __u16 port,
+		       int timeout_ms);
 int connect_to_fd(int server_fd, int timeout_ms);
+int connect_to_mptcp_fd(int server_fd, int timeout_ms);
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
 int fastopen_connect(int server_fd, const char *data, unsigned int data_len,
 		     int timeout_ms);
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
new file mode 100644
index 000000000000..0e65d64868e9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+struct mptcp_storage {
+	__u32 invoked;
+	__u32 is_mptcp;
+};
+
+static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
+{
+	int err = 0, cfd = client_fd;
+	struct mptcp_storage val;
+
+	/* Currently there is no easy way to get back the subflow sk from the MPTCP
+	 * sk, thus we cannot access here the sk_storage associated to the subflow
+	 * sk. Also, there is no sk_storage associated with the MPTCP sk since it
+	 * does not trigger sockops events.
+	 * We silently pass this situation at the moment.
+	 */
+	if (is_mptcp == 1)
+		return 0;
+
+	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
+		perror("Failed to read socket storage");
+		return -1;
+	}
+
+	if (val.invoked != 1) {
+		log_err("%s: unexpected invoked count %d != %d",
+			msg, val.invoked, 1);
+		err++;
+	}
+
+	if (val.is_mptcp != is_mptcp) {
+		log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d != %d",
+			msg, val.is_mptcp, is_mptcp);
+		err++;
+	}
+
+	return err;
+}
+
+static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
+{
+	int client_fd, prog_fd, map_fd, err;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+
+	struct bpf_prog_load_attr attr = {
+		.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+		.file = "./mptcp.o",
+		.expected_attach_type = BPF_CGROUP_SOCK_OPS,
+	};
+
+	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
+	if (err) {
+		log_err("Failed to load BPF object");
+		return -1;
+	}
+
+	map = bpf_map__next(NULL, obj);
+	map_fd = bpf_map__fd(map);
+
+	err = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_SOCK_OPS, 0);
+	if (err) {
+		log_err("Failed to attach BPF program");
+		goto close_bpf_object;
+	}
+
+	client_fd = is_mptcp ? connect_to_mptcp_fd(server_fd, 0) :
+			       connect_to_fd(server_fd, 0);
+	if (client_fd < 0) {
+		err = -1;
+		goto close_client_fd;
+	}
+
+	err += is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :
+			  verify_sk(map_fd, client_fd, "plain TCP socket", 0);
+
+close_client_fd:
+	close(client_fd);
+
+close_bpf_object:
+	bpf_object__close(obj);
+	return err;
+}
+
+void test_mptcp(void)
+{
+	int server_fd, cgroup_fd;
+
+	cgroup_fd = test__join_cgroup("/mptcp");
+	if (CHECK_FAIL(cgroup_fd < 0))
+		return;
+
+	/* without MPTCP */
+	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto with_mptcp;
+
+	CHECK_FAIL(run_test(cgroup_fd, server_fd, false));
+
+	close(server_fd);
+
+with_mptcp:
+	/* with MPTCP */
+	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
+	if (CHECK_FAIL(server_fd < 0))
+		goto close_cgroup_fd;
+
+	CHECK_FAIL(run_test(cgroup_fd, server_fd, true));
+
+	close(server_fd);
+
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/mptcp.c b/tools/testing/selftests/bpf/progs/mptcp.c
new file mode 100644
index 000000000000..be5ee8dac2b3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/mptcp.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
+
+struct mptcp_storage {
+	__u32 invoked;
+	__u32 is_mptcp;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, struct mptcp_storage);
+} socket_storage_map SEC(".maps");
+
+SEC("sockops")
+int _sockops(struct bpf_sock_ops *ctx)
+{
+	struct mptcp_storage *storage;
+	struct bpf_tcp_sock *tcp_sk;
+	int op = (int)ctx->op;
+	struct bpf_sock *sk;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 1;
+
+	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
+				     BPF_SK_STORAGE_GET_F_CREATE);
+	if (!storage)
+		return 1;
+
+	if (op != BPF_SOCK_OPS_TCP_CONNECT_CB)
+		return 1;
+
+	tcp_sk = bpf_tcp_sock(sk);
+	if (!tcp_sk)
+		return 1;
+
+	storage->invoked++;
+	storage->is_mptcp = tcp_sk->is_mptcp;
+
+	return 1;
+}
-- 
2.28.0

