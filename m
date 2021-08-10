Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D004A3E5E45
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbhHJOrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbhHJOrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:47:17 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07146C0613C1;
        Tue, 10 Aug 2021 07:46:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d1so21348514pll.1;
        Tue, 10 Aug 2021 07:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wFe4BczhXR3k/+mmFy5lD0VLxMw5jgWEOO680ak8REI=;
        b=lq5uqTUrCf1zhHo2WCLOu5K4XkyHKwAL91OTcrYf5JLS1QqGnBnh4ZslqlwGHtrvm3
         xKsAa0YxD2bnD1bBZdvB527pGbadW1OQ4IWVebZAJ4qybZjynEdjz0UOdga7D3kYHy6A
         d40KfwsOcvLZ/XmE69uvtGgMaMG3IcPod1z9isiQh9XHgbRFKuCCn+9WR51oLIB7CinM
         j3MYrDj0JX3fhiNR9qeMf531Y9GcfLaUKuNelDZ3yZZQIrbn6CFAP6/pbSBhN1bAmuJ5
         QdhF6NvKmrYYHRKY7vyv+O/YkAZnqxUznvVvmE+LDgUhpJYSpbDHldaGTXJ3dmQTK6MN
         X8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wFe4BczhXR3k/+mmFy5lD0VLxMw5jgWEOO680ak8REI=;
        b=j6gOMK++d0CW6h0MuZIqjqNcU7tmHZuJZmgJSvpbpBdny4ZTRmbsAvkR3HWTanME0E
         On/YYQkqTeL19Ah4cmsUCuevX3PSVefHz7zzTHVbRxGxnA714j1iLaP6xBCeWSsEfm0N
         jwGTwPqEv/U4rDFTquEB4UUEa8mVw6ZxXcqNpntf81XI3Dgm0R1wt72a8j0D5A3eOpzR
         XGpd8D3q6HtgcfZPxnxk8zV0D7KmTAUFkVcVD4jVDnRC0vIRS6Ddob/9HL50eiQO2J/J
         Vv/GVEZnL9D7po4jrXvHDggJQ+0kZOAq6YGY+oW+nO+9DS9NedssyN4rMCy4tC2JvVPb
         3+Ig==
X-Gm-Message-State: AOAM532EStBv7JcaYFl4+QLIfKwMefI+tb5E1M9J+jFc1BlKurIBCkmR
        ssWCcPEvrVnp8JTYbP0kiw3eyieMgvORN1pL
X-Google-Smtp-Source: ABdhPJzdvZxjlWRwL7McZjfZOAoXUYwFYCRKyUnKpa6GcY5o8JXYs1dmPLML/KRZdf6OvCoSzExdJQ==
X-Received: by 2002:a17:90a:fa3:: with SMTP id 32mr5564938pjz.68.1628606814326;
        Tue, 10 Aug 2021 07:46:54 -0700 (PDT)
Received: from localhost.localdomain ([123.20.118.31])
        by smtp.gmail.com with ESMTPSA id y4sm3479034pjg.9.2021.08.10.07.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 07:46:54 -0700 (PDT)
From:   Bui Quang Minh <minhquangbui99@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, pabeni@redhat.com,
        avagin@gmail.com, alexander@mihalicyn.com,
        minhquangbui99@gmail.com, lesedorucalin01@gmail.com
Subject: [PATCH 2/2] selftests: Add udp_repair test
Date:   Tue, 10 Aug 2021 21:45:50 +0700
Message-Id: <20210810144550.40546-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a simple test for UDP_REPAIR in 3 cases:
 - Socket is an udp4 socket
 - Socket is an udp6 socket with pending ipv4 packets
 - Socket is an udp6 socket with pending ipv6 packets

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 tools/testing/selftests/net/.gitignore   |   1 +
 tools/testing/selftests/net/Makefile     |   1 +
 tools/testing/selftests/net/udp_repair.c | 218 +++++++++++++++++++++++
 3 files changed, 220 insertions(+)
 create mode 100644 tools/testing/selftests/net/udp_repair.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 19deb9cdf72f..c9daab1721d5 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -31,3 +31,4 @@ rxtimestamp
 timestamping
 txtimestamp
 so_netns_cookie
+udp_repair
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 79c9eb0034d5..cd20eae9275c 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -38,6 +38,7 @@ TEST_GEN_FILES += hwtstamp_config rxtimestamp timestamping txtimestamp
 TEST_GEN_FILES += ipsec
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
+TEST_GEN_PROGS += udp_repair
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/udp_repair.c b/tools/testing/selftests/net/udp_repair.c
new file mode 100644
index 000000000000..1b2c53129c71
--- /dev/null
+++ b/tools/testing/selftests/net/udp_repair.c
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <string.h>
+#include <unistd.h>
+#include <error.h>
+#include <errno.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+#include <netinet/udp.h>
+
+#define PORT 5000
+#define BUF_SIZE 256
+
+#define UDP_REPAIR	2
+
+char send_buf[BUF_SIZE];
+struct udp_dump {
+	union {
+		struct sockaddr_in addr_v4;
+		struct sockaddr_in6 addr_v6;
+	};
+	char buf[BUF_SIZE];
+};
+
+struct sockaddr_in addr_v4;
+struct sockaddr_in6 addr_v6;
+
+int udp_server(int is_udp4)
+{
+	int sock, ret;
+	unsigned short family;
+	struct sockaddr *server_addr;
+	unsigned int addr_len;
+
+	if (is_udp4) {
+		family = AF_INET;
+		server_addr = (struct sockaddr *) &addr_v4;
+		addr_len = sizeof(addr_v4);
+	} else {
+		family = AF_INET6;
+		server_addr = (struct sockaddr *) &addr_v6;
+		addr_len = sizeof(addr_v6);
+	}
+
+	sock = socket(family, SOCK_DGRAM, IPPROTO_UDP);
+	if (sock < 0)
+		error(1, errno, "socket server");
+
+	ret = bind(sock, server_addr, addr_len);
+	if (ret < 0)
+		error(1, errno, "bind server socket");
+
+	return sock;
+}
+
+void server_recv(int sock)
+{
+	char recv_buf[BUF_SIZE];
+	int ret;
+
+	ret = recv(sock, recv_buf, sizeof(recv_buf), 0);
+	if (ret < 0)
+		error(1, errno, "recv in server");
+
+	if (memcmp(recv_buf, send_buf, BUF_SIZE))
+		error(1, 0, "recv: data mismatch");
+}
+
+int create_corked_udp_client(int is_udp4)
+{
+	int sock, ret, val = 1;
+	unsigned short family = is_udp4 ? AF_INET : AF_INET6;
+
+	sock = socket(family, SOCK_DGRAM, IPPROTO_UDP);
+	if (sock < 0)
+		error(1, errno, "socket client");
+
+	ret = setsockopt(sock, SOL_UDP, UDP_CORK, &val, sizeof(val));
+	if (ret < 0)
+		error(1, errno, "setsockopt cork udp");
+
+	return sock;
+}
+
+struct udp_dump *checkpoint(int sock, int is_udp4)
+{
+	int ret, val;
+	unsigned int addr_len;
+	struct udp_dump *dump;
+	struct sockaddr *addr;
+
+	dump = malloc(sizeof(*dump));
+	if (!dump)
+		error(1, 0, "malloc");
+
+	if (is_udp4) {
+		addr = (struct sockaddr *) &dump->addr_v4;
+		addr_len = sizeof(dump->addr_v4);
+	} else {
+		addr = (struct sockaddr *) &dump->addr_v6;
+		addr_len = sizeof(dump->addr_v6);
+	}
+
+	val = 1;
+	ret = setsockopt(sock, SOL_UDP, UDP_REPAIR, &val, sizeof(val));
+	if (ret < 0)
+		error(1, errno, "setsockopt udp_repair");
+
+	val = 0;
+	ret = setsockopt(sock, SOL_SOCKET, SO_PEEK_OFF, &val, sizeof(val));
+	if (ret < 0)
+		error(1, errno, "setsockopt so_peek_off");
+
+	ret = recvfrom(sock, dump->buf, BUF_SIZE / 2, MSG_PEEK,
+		       addr, &addr_len);
+	if (ret < 0)
+		error(1, errno, "dumping send queue");
+
+	ret = recvfrom(sock, dump->buf + BUF_SIZE / 2,
+		       BUF_SIZE - BUF_SIZE / 2, MSG_PEEK,
+		       addr, &addr_len);
+	if (ret < 0)
+		error(1, errno, "dumping send queue");
+
+	if (memcmp(dump->buf, send_buf, BUF_SIZE))
+		error(1, 0, "dump: data mismatch");
+
+	return dump;
+}
+
+void restore(int sock, struct udp_dump *dump, int is_udp4)
+{
+	struct sockaddr *addr;
+	int val;
+	unsigned int addr_len;
+
+	if (is_udp4) {
+		addr = (struct sockaddr *) &dump->addr_v4;
+		addr_len = sizeof(dump->addr_v4);
+	} else {
+		addr = (struct sockaddr *) &dump->addr_v6;
+		addr_len = sizeof(dump->addr_v6);
+	}
+
+	if (sendto(sock, dump->buf, BUF_SIZE, 0, addr, addr_len) < 0)
+		error(1, errno, "send data");
+
+	val = 0;
+	if (setsockopt(sock, SOL_UDP, UDP_CORK, &val, sizeof(val)) < 0)
+		error(1, errno, "setsockopt un-cork udp");
+}
+
+void run_test(int is_udp4_sock, int is_udp4_packet)
+{
+	int server_sock, client_sock, ret, val;
+	struct udp_dump *dump;
+	struct sockaddr *addr;
+	unsigned int addr_len;
+
+	if (is_udp4_packet) {
+		addr = (struct sockaddr *) &addr_v4;
+		addr_len = sizeof(addr_v4);
+	} else {
+		addr = (struct sockaddr *) &addr_v6;
+		addr_len = sizeof(addr_v6);
+	}
+
+	server_sock = udp_server(is_udp4_packet);
+	client_sock = create_corked_udp_client(is_udp4_sock);
+
+	ret = sendto(client_sock, send_buf, sizeof(send_buf), 0,
+	       addr, addr_len);
+	if (ret < 0)
+		error(1, errno, "send data");
+
+	dump = checkpoint(client_sock, is_udp4_sock);
+	close(client_sock);
+
+	client_sock = create_corked_udp_client(is_udp4_sock);
+	restore(client_sock, dump, is_udp4_sock);
+
+	val = 0;
+	setsockopt(client_sock, SOL_UDP, UDP_CORK, &val, sizeof(val));
+	server_recv(server_sock);
+
+	close(server_sock);
+	close(client_sock);
+}
+
+void init(void)
+{
+	addr_v4.sin_family	= AF_INET;
+	addr_v4.sin_port	= htons(PORT);
+	addr_v4.sin_addr.s_addr	= inet_addr("127.0.0.1");
+
+	addr_v6.sin6_family	= AF_INET6;
+	addr_v6.sin6_port	= htons(PORT);
+	inet_pton(AF_INET6, "::1", &addr_v6.sin6_addr);
+
+	memset(send_buf, 'A', BUF_SIZE / 2);
+	memset(send_buf + BUF_SIZE / 2, 'B', BUF_SIZE - BUF_SIZE / 2);
+}
+
+int main(void)
+{
+	init();
+	fprintf(stderr, "Test udp4 socket\n");
+	run_test(1, 1);
+	fprintf(stderr, "Test udp6 socket sending udp4 packet\n");
+	run_test(0, 1);
+	fprintf(stderr, "Test udp6 socket sending udp6 packet\n");
+	run_test(0, 0);
+	fprintf(stderr, "Ok\n");
+	return 0;
+}
-- 
2.17.1

