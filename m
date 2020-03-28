Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D851968C2
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgC1Sz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:55:26 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:40143 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgC1Sz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:55:26 -0400
Received: by mail-pl1-f176.google.com with SMTP id h11so4878757plk.7;
        Sat, 28 Mar 2020 11:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+TITAqbXzJawWQELMMeDE2Akxu70AkM4KZL44jotzx0=;
        b=MODIZ2Hym3l60GzyLo2UGZQT7XsHKs9YikV9y4NV6eNjGkVDCTcqJhRN1CMjg6B3X1
         JYf9rUNYEsskwMJpStECgHMCNuhk7lPGLUn7I4Q24R7yHcefwTxSsma1Kui36cxz1JQr
         wQ8wus5xau6R4nSiuTnnCqlkLD46Ml/nJWmGlbCjfOCrS3vRaN35ZFk+zF8Pi6O7cWMT
         FkgLkfbTIkCMc8CyOEmW+rP8xZI7C4dZeN63vQLVVpmV2stto2DcLo5wNrtoV35fi1h0
         PU79X+PCkk8BZAbS8VY1Eggqgm+lIMRK7k5EDnxiMYJ67+GFpd5kttuk58aT8i4S8w6F
         Ws5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+TITAqbXzJawWQELMMeDE2Akxu70AkM4KZL44jotzx0=;
        b=XPyilMvDTODOeLquZU+C7SJQHhOeX80RcMDkWyYDHRZ4foujAv1/LLal+1jStXw39K
         /K/851Y6gV3T5tdlECwHropGPTDnkiJOX7kLveC6+AJ2H0cxfZHEYvdmISL/JUR83sgQ
         T1hnpqUxi9prmg8g9GuBv7MTU+aQe4yFNeQ8GSUk4XeY93NR5teB51Sp2SW+uHsULWh6
         9gGsRL/KoeWtzzwsJAjZvGCND3Vsi6W01BYkCfcHs/F1rXUqcPYQscAbK/FQHxdrIXhp
         R4NFWz5Gf6ClUWfHwfBoC/qKM4vGfA7wmo/awPWXeI9xfQ7yHNyyL+qbk04GbP9gwr50
         UX+Q==
X-Gm-Message-State: ANhLgQ2rBOx9Kqf8OUeVtfeuGW3tOgq6sybhCC64xG/HQ2RKVmO73HHK
        4j3GUoJ1x1Qx4TOzd060yM8shNHw
X-Google-Smtp-Source: ADFU+vuV/cQiaRvqeC+xSr1e7wu6JNN1z9H1uGMF5AX6ZdSyr2bl9u+O1jnHOzDoNzjDvWpB1YVMrA==
X-Received: by 2002:a17:90b:909:: with SMTP id bo9mr6682004pjb.125.1585421721681;
        Sat, 28 Mar 2020 11:55:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d7sm6682022pfo.86.2020.03.28.11.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:55:21 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, eric.dumazet@gmail.com,
        kafai@fb.com
Subject: [PATCHv4 bpf-next 4/5] selftests: bpf: add test for sk_assign
Date:   Sat, 28 Mar 2020 11:55:07 -0700
Message-Id: <20200328185509.20892-5-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200328185509.20892-1-joe@wand.net.nz>
References: <20200328185509.20892-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

Attach a tc direct-action classifier to lo in a fresh network
namespace, and rewrite all connection attempts to localhost:4321
to localhost:1234 (for port tests) and connections to unreachable
IPv4/IPv6 IPs to the local socket (for address tests). Includes
implementations for both TCP and UDP.

Keep in mind that both client to server and server to client traffic
passes the classifier.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Co-authored-by: Joe Stringer <joe@wand.net.nz>
Signed-off-by: Joe Stringer <joe@wand.net.nz>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
v4: Add acks
v3: Add tests for UDP socket assign
    Fix switching back to original netns after test
    Avoid using signals to timeout connections
    Refactor to iterate through test cases
v2: Rebase onto test_progs infrastructure
v1: Initial commit
---
 .../selftests/bpf/prog_tests/sk_assign.c      | 276 ++++++++++++++++++
 .../selftests/bpf/progs/test_sk_assign.c      | 143 +++++++++
 2 files changed, 419 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
new file mode 100644
index 000000000000..25f17fe7d678
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018 Facebook
+// Copyright (c) 2019 Cloudflare
+// Copyright (c) 2020 Isovalent, Inc.
+/*
+ * Test that the socket assign program is able to redirect traffic towards a
+ * socket, regardless of whether the port or address destination of the traffic
+ * matches the port.
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <signal.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include "test_progs.h"
+
+#define BIND_PORT 1234
+#define CONNECT_PORT 4321
+#define TEST_DADDR (0xC0A80203)
+#define NS_SELF "/proc/self/ns/net"
+
+static const struct timeval timeo_sec = { .tv_sec = 3 };
+static const size_t timeo_optlen = sizeof(timeo_sec);
+static int stop, duration;
+
+static bool
+configure_stack(void)
+{
+	char tc_cmd[BUFSIZ];
+
+	/* Move to a new networking namespace */
+	if (CHECK_FAIL(unshare(CLONE_NEWNET)))
+		return false;
+
+	/* Configure necessary links, routes */
+	if (CHECK_FAIL(system("ip link set dev lo up")))
+		return false;
+	if (CHECK_FAIL(system("ip route add local default dev lo")))
+		return false;
+	if (CHECK_FAIL(system("ip -6 route add local default dev lo")))
+		return false;
+
+	/* Load qdisc, BPF program */
+	if (CHECK_FAIL(system("tc qdisc add dev lo clsact")))
+		return false;
+	sprintf(tc_cmd, "%s %s %s %s", "tc filter add dev lo ingress bpf",
+		       "direct-action object-file ./test_sk_assign.o",
+		       "section classifier/sk_assign_test",
+		       (env.verbosity < VERBOSE_VERY) ? " 2>/dev/null" : "");
+	if (CHECK(system(tc_cmd), "BPF load failed;",
+		  "run with -vv for more info\n"))
+		return false;
+
+	return true;
+}
+
+static int
+start_server(const struct sockaddr *addr, socklen_t len, int type)
+{
+	int fd;
+
+	fd = socket(addr->sa_family, type, 0);
+	if (CHECK_FAIL(fd == -1))
+		goto out;
+	if (CHECK_FAIL(setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo_sec,
+				  timeo_optlen)))
+		goto close_out;
+	if (CHECK_FAIL(bind(fd, addr, len) == -1))
+		goto close_out;
+	if (CHECK_FAIL(listen(fd, 128) == -1))
+		goto close_out;
+
+	goto out;
+close_out:
+	close(fd);
+	fd = -1;
+out:
+	return fd;
+}
+
+static int
+connect_to_server(const struct sockaddr *addr, socklen_t len, int type)
+{
+	int fd = -1;
+
+	fd = socket(addr->sa_family, type, 0);
+	if (CHECK_FAIL(fd == -1))
+		goto out;
+	if (CHECK_FAIL(setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo_sec,
+				  timeo_optlen)))
+		goto close_out;
+	if (CHECK_FAIL(connect(fd, addr, len)))
+		goto close_out;
+
+	goto out;
+close_out:
+	close(fd);
+	fd = -1;
+out:
+	return fd;
+}
+
+static in_port_t
+get_port(int fd)
+{
+	struct sockaddr_storage ss;
+	socklen_t slen = sizeof(ss);
+	in_port_t port = 0;
+
+	if (CHECK_FAIL(getsockname(fd, (struct sockaddr *)&ss, &slen)))
+		return port;
+
+	switch (ss.ss_family) {
+	case AF_INET:
+		port = ((struct sockaddr_in *)&ss)->sin_port;
+		break;
+	case AF_INET6:
+		port = ((struct sockaddr_in6 *)&ss)->sin6_port;
+		break;
+	default:
+		CHECK(1, "Invalid address family", "%d\n", ss.ss_family);
+	}
+	return port;
+}
+
+static int
+run_test(int server_fd, const struct sockaddr *addr, socklen_t len, int type)
+{
+	int client = -1, srv_client = -1;
+	char buf[] = "testing";
+	in_port_t port;
+	int ret = 1;
+
+	client = connect_to_server(addr, len, type);
+	if (client == -1) {
+		perror("Cannot connect to server");
+		goto out;
+	}
+
+	srv_client = accept(server_fd, NULL, NULL);
+	if (CHECK_FAIL(srv_client == -1)) {
+		perror("Can't accept connection");
+		goto out;
+	}
+	if (CHECK_FAIL(write(client, buf, sizeof(buf)) != sizeof(buf))) {
+		perror("Can't write on client");
+		goto out;
+	}
+	if (CHECK_FAIL(read(srv_client, &buf, sizeof(buf)) != sizeof(buf))) {
+		perror("Can't read on server");
+		goto out;
+	}
+
+	port = get_port(srv_client);
+	if (CHECK_FAIL(!port))
+		goto out;
+	if (CHECK(port != htons(CONNECT_PORT), "Expected", "port %u but got %u",
+		  CONNECT_PORT, ntohs(port)))
+		goto out;
+
+	ret = 0;
+out:
+	close(client);
+	if (srv_client != server_fd)
+		close(srv_client);
+	if (ret)
+		WRITE_ONCE(stop, 1);
+	return ret;
+}
+
+static void
+prepare_addr(struct sockaddr *addr, int family, __u16 port, bool rewrite_addr)
+{
+	struct sockaddr_in *addr4;
+	struct sockaddr_in6 *addr6;
+
+	switch (family) {
+	case AF_INET:
+		addr4 = (struct sockaddr_in *)addr;
+		memset(addr4, 0, sizeof(*addr4));
+		addr4->sin_family = family;
+		addr4->sin_port = htons(port);
+		if (rewrite_addr)
+			addr4->sin_addr.s_addr = htonl(TEST_DADDR);
+		else
+			addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		break;
+	case AF_INET6:
+		addr6 = (struct sockaddr_in6 *)addr;
+		memset(addr6, 0, sizeof(*addr6));
+		addr6->sin6_family = family;
+		addr6->sin6_port = htons(port);
+		addr6->sin6_addr = in6addr_loopback;
+		if (rewrite_addr)
+			addr6->sin6_addr.s6_addr32[3] = htonl(TEST_DADDR);
+		break;
+	default:
+		fprintf(stderr, "Invalid family %d", family);
+	}
+}
+
+struct test_sk_cfg {
+	const char *name;
+	int family;
+	struct sockaddr *addr;
+	socklen_t len;
+	int type;
+	bool rewrite_addr;
+};
+
+#define TEST(NAME, FAMILY, TYPE, REWRITE)				\
+{									\
+	.name = NAME,							\
+	.family = FAMILY,						\
+	.addr = (FAMILY == AF_INET) ? (struct sockaddr *)&addr4		\
+				    : (struct sockaddr *)&addr6,	\
+	.len = (FAMILY == AF_INET) ? sizeof(addr4) : sizeof(addr6),	\
+	.type = TYPE,							\
+	.rewrite_addr = REWRITE,					\
+}
+
+void test_sk_assign(void)
+{
+	struct sockaddr_in addr4;
+	struct sockaddr_in6 addr6;
+	struct test_sk_cfg tests[] = {
+		TEST("ipv4 tcp port redir", AF_INET, SOCK_STREAM, false),
+		TEST("ipv4 tcp addr redir", AF_INET, SOCK_STREAM, true),
+		TEST("ipv6 tcp port redir", AF_INET6, SOCK_STREAM, false),
+		TEST("ipv6 tcp addr redir", AF_INET6, SOCK_STREAM, true),
+	};
+	int server = -1;
+	int self_net;
+
+	self_net = open(NS_SELF, O_RDONLY);
+	if (CHECK_FAIL(self_net < 0)) {
+		perror("Unable to open "NS_SELF);
+		return;
+	}
+
+	if (!configure_stack()) {
+		perror("configure_stack");
+		goto cleanup;
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(tests) && !READ_ONCE(stop); i++) {
+		struct test_sk_cfg *test = &tests[i];
+		const struct sockaddr *addr;
+
+		if (!test__start_subtest(test->name))
+			continue;
+		prepare_addr(test->addr, test->family, BIND_PORT, false);
+		addr = (const struct sockaddr *)test->addr;
+		server = start_server(addr, test->len, test->type);
+		if (server == -1)
+			goto cleanup;
+
+		/* connect to unbound ports */
+		prepare_addr(test->addr, test->family, CONNECT_PORT,
+			     test->rewrite_addr);
+		if (run_test(server, addr, test->len, test->type))
+			goto close;
+
+		close(server);
+		server = -1;
+	}
+
+close:
+	close(server);
+cleanup:
+	if (CHECK_FAIL(setns(self_net, CLONE_NEWNET)))
+		perror("Failed to setns("NS_SELF")");
+	close(self_net);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
new file mode 100644
index 000000000000..bde8748799eb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Cloudflare Ltd.
+// Copyright (c) 2020 Isovalent, Inc.
+
+#include <stddef.h>
+#include <stdbool.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/tcp.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";
+
+/* Fill 'tuple' with L3 info, and attempt to find L4. On fail, return NULL. */
+static inline struct bpf_sock_tuple *
+get_tuple(struct __sk_buff *skb, bool *ipv4)
+{
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+	struct bpf_sock_tuple *result;
+	struct ethhdr *eth;
+	__u64 tuple_len;
+	__u8 proto = 0;
+	__u64 ihl_len;
+
+	eth = (struct ethhdr *)(data);
+	if (eth + 1 > data_end)
+		return NULL;
+
+	if (eth->h_proto == bpf_htons(ETH_P_IP)) {
+		struct iphdr *iph = (struct iphdr *)(data + sizeof(*eth));
+
+		if (iph + 1 > data_end)
+			return NULL;
+		if (iph->ihl != 5)
+			/* Options are not supported */
+			return NULL;
+		ihl_len = iph->ihl * 4;
+		proto = iph->protocol;
+		*ipv4 = true;
+		result = (struct bpf_sock_tuple *)&iph->saddr;
+	} else if (eth->h_proto == bpf_htons(ETH_P_IPV6)) {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)(data + sizeof(*eth));
+
+		if (ip6h + 1 > data_end)
+			return NULL;
+		ihl_len = sizeof(*ip6h);
+		proto = ip6h->nexthdr;
+		*ipv4 = false;
+		result = (struct bpf_sock_tuple *)&ip6h->saddr;
+	} else {
+		return (struct bpf_sock_tuple *)data;
+	}
+
+	if (result + 1 > data_end || proto != IPPROTO_TCP)
+		return NULL;
+
+	return result;
+}
+
+static inline int
+handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
+{
+	struct bpf_sock_tuple ln = {0};
+	struct bpf_sock *sk;
+	size_t tuple_len;
+	int ret;
+
+	tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
+	if ((void *)tuple + tuple_len > skb->data_end)
+		return TC_ACT_SHOT;
+
+	sk = bpf_skc_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
+	if (sk) {
+		if (sk->state != BPF_TCP_LISTEN)
+			goto assign;
+		bpf_sk_release(sk);
+	}
+
+	if (ipv4) {
+		if (tuple->ipv4.dport != bpf_htons(4321))
+			return TC_ACT_OK;
+
+		ln.ipv4.daddr = bpf_htonl(0x7f000001);
+		ln.ipv4.dport = bpf_htons(1234);
+
+		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
+					BPF_F_CURRENT_NETNS, 0);
+	} else {
+		if (tuple->ipv6.dport != bpf_htons(4321))
+			return TC_ACT_OK;
+
+		/* Upper parts of daddr are already zero. */
+		ln.ipv6.daddr[3] = bpf_htonl(0x1);
+		ln.ipv6.dport = bpf_htons(1234);
+
+		sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
+					BPF_F_CURRENT_NETNS, 0);
+	}
+
+	/* workaround: We can't do a single socket lookup here, because then
+	 * the compiler will likely spill tuple_len to the stack. This makes it
+	 * lose all bounds information in the verifier, which then rejects the
+	 * call as unsafe.
+	 */
+	if (!sk)
+		return TC_ACT_SHOT;
+
+	if (sk->state != BPF_TCP_LISTEN) {
+		bpf_sk_release(sk);
+		return TC_ACT_SHOT;
+	}
+
+assign:
+	ret = bpf_sk_assign(skb, sk, 0);
+	bpf_sk_release(sk);
+	return ret;
+}
+
+SEC("classifier/sk_assign_test")
+int bpf_sk_assign_test(struct __sk_buff *skb)
+{
+	struct bpf_sock_tuple *tuple, ln = {0};
+	bool ipv4 = false;
+	int tuple_len;
+	int ret = 0;
+
+	tuple = get_tuple(skb, &ipv4);
+	if (!tuple)
+		return TC_ACT_SHOT;
+
+	ret = handle_tcp(skb, tuple, ipv4);
+
+	return ret == 0 ? TC_ACT_OK : TC_ACT_SHOT;
+}
-- 
2.20.1

