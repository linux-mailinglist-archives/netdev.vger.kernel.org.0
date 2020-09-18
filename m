Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9331026FC3D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIRMNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgIRMMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:12:52 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED1C061788
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:12:52 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i22so7811614eja.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PhrdaTSNLUxlusGwoTxFJq+hrRjF+9y+Lo9/SXLsLig=;
        b=D7qxyxl88Zm4JNH8EYAr81ZO2nm0wNqMvtgtXm3k3y3897CPebHJxgl2XEAAgmLGES
         5GOvqNm1ZAkRTfoBkTJqTpGIrOvVNuIcOeayUSlguuaaICBWSG1ev2cKZKOF+qdAWLpF
         XLOCKUBC2NVPJBQCLVZVxqqzZS9CiNaLzmcmvKL8kMU7UuqdgzwDm1OyR/Ra9zAAhLjd
         Y9SOZmY1WsIc2WF1zk5Pnw30W17vTSqzqpH6+J6KqYQ2K0E1g119uP1JeFXVJZp1cj1W
         IpgOMYdC+/YHGIp+mABUzClQv8+XQcY2JTmj/lZbdLIpgt28FPmuPqCy3riaEQqQhiXb
         37CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PhrdaTSNLUxlusGwoTxFJq+hrRjF+9y+Lo9/SXLsLig=;
        b=GZXbHO0V788FLsXYRonNp3G3k0M2R1Fr/eR3yWurSm91NJ/fvkeN0fy6iDMsqFZ8fW
         XjAaslwgCk5kQBTGr9IvO1OjZ66bl2Db3MZfM9Vmcwi1V9XMYDz8dnuYgwjzTizSmME2
         V5/CJOsdWIFX070ZpxRU8AHMEW7JuTVo1O1X7Ro8P4ksEZ/Oqi+Jm8yOCcdinaaw2H8G
         57HA7Sk3yUkhg2gVTRUaGfnjQrincWT9RFYkJ7jSn4+ZCxbT77t++6i9ukI/ykb+WPCs
         Dt/pWx91usnancU5m/2h7NhbdBxwObbm63Er7F8VsvUfFIzlBQ9vm1k1hNHhBnPQdLHi
         j4sA==
X-Gm-Message-State: AOAM530bNsNyG9wAO7EPZKhjl+tv1OXZ/2P9m9vz+BuDamNdS7ahfLn8
        uUanBGExTouMNgCmUtK+sxhiBg==
X-Google-Smtp-Source: ABdhPJwicqcD55dRU4RYcXE1WqMUhpL0NB2TFr8YAzsTvRTo369mc6CQDlRcEkynYxMjjfsFqgm+pQ==
X-Received: by 2002:a17:906:4107:: with SMTP id j7mr37149022ejk.533.1600431171171;
        Fri, 18 Sep 2020 05:12:51 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id h64sm2084555edd.50.2020.09.18.05.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:12:50 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 4/5] bpf: selftests: add MPTCP test base
Date:   Fri, 18 Sep 2020 14:10:43 +0200
Message-Id: <20200918121046.190240-4-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
References: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a base for MPTCP specific tests.

It is currently limited to the is_mptcp field in case of plain TCP
connection because for the moment there is no easy way to get the subflow
sk from a msk in userspace. This implies that we cannot lookup the
sk_storage attached to the subflow sk in the sockops program.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---

Notes:
    v2 -> v3:
    - remove useless close_client_fd label (Song)
    - remove error count increment (Song)
    
    v1 -> v2:
    - new patch: mandatory selftests (Alexei)

 tools/testing/selftests/bpf/config            |   1 +
 tools/testing/selftests/bpf/network_helpers.c |  37 +++++-
 tools/testing/selftests/bpf/network_helpers.h |   3 +
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 118 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/mptcp.c     |  48 +++++++
 5 files changed, 202 insertions(+), 5 deletions(-)
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
index 000000000000..9accf2cfce36
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -0,0 +1,118 @@
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
+		goto close_bpf_object;
+	}
+
+	err = is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :
+			  verify_sk(map_fd, client_fd, "plain TCP socket", 0);
+
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

