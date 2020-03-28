Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50291968C3
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgC1Sz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:55:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45362 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbgC1SzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:55:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id b9so4875078pls.12;
        Sat, 28 Mar 2020 11:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NDVGlRAeM13C8KfCj3zWdaO8zw4xeNG2F+otqJaRSEg=;
        b=bkJ2ZNCm0EK8pq1e6mY+2HJwiNqXMFSnDI2OoF3Obuo7s27KuqFqj5UFko+L7UB8Ny
         qAqCa8geY88/XXTUfFAorfS7Za9Y0dNxHdlZKVWvoXj+siC82uIuu26+767RnG9aqmRf
         lbxcmhFqFH4KtCDg43jCLohb+WJm86cBJYoE0wFapl/3WYXYyIIKRmln3gJu7sLCubnc
         JZXvfAySWys2Tk/PAuUQ3kYqOTyazPjoNOooWHgRAgqRYWQL3YJo+oZi3yeEPgFcKtfg
         Flu6ONzPielusIwOC75rnRBeNvbwAkxuyZHO6gykTmJ4lNuphVHu2MU30eAEQGvUmcbi
         IHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=NDVGlRAeM13C8KfCj3zWdaO8zw4xeNG2F+otqJaRSEg=;
        b=VxBkA5bT+Q6PpOIT3kfCis3FSFGphCsIj+GazJydZ/qq5NxTYl+AjlQJIe5IZriVwe
         V6IPvXfFvGFP43a7IWkn6+Yr+NjDEkrJA3dljdEsL8JmkpkFgfnK2sR28YJX9VLVXxdv
         MX8Zkka2xfnTs9pRl1wkUyZ6Xj/vjXnJfbez5XzEh3YPtvClZFpfbYEIerWburtCUVz9
         tUyIWRRq1Mf92NRRSmm92EpmMUGetR8wBXqT8nA3BvEA9oFz1ywpMN9vbMfAoxd5YEFy
         P0FbftNTg1tsn1EcZRVjTVk03/obsnqlKXD1Nl2L+TRnEgBQl30CVXYJe5HzUjZSoPgg
         UPHQ==
X-Gm-Message-State: ANhLgQ1ex3cnPEZfkLLy4lNjUumgu8lp4SvumB+IyQwoiS8IeSD0PJrv
        rgyvrrKqrS8y2fXjQF5FAYTr5hhT
X-Google-Smtp-Source: ADFU+vulhgK7fSZC2t0/B+UepVQzihA080ZOjHp2X++JtOT96tcvmXrRWQcquQF/nTDlglYUPjGBEQ==
X-Received: by 2002:a17:902:d895:: with SMTP id b21mr4952404plz.118.1585421722947;
        Sat, 28 Mar 2020 11:55:22 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d7sm6682022pfo.86.2020.03.28.11.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:55:22 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv4 bpf-next 5/5] selftests: bpf: Extend sk_assign tests for UDP
Date:   Sat, 28 Mar 2020 11:55:08 -0700
Message-Id: <20200328185509.20892-6-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200328185509.20892-1-joe@wand.net.nz>
References: <20200328185509.20892-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for testing UDP sk_assign to the existing tests.

Signed-off-by: Joe Stringer <joe@wand.net.nz>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
v4: Acked
v3: Initial post
---
 .../selftests/bpf/prog_tests/sk_assign.c      | 47 +++++++++++--
 .../selftests/bpf/progs/test_sk_assign.c      | 69 +++++++++++++++++--
 2 files changed, 105 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
index 25f17fe7d678..d572e1a2c297 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -69,7 +69,7 @@ start_server(const struct sockaddr *addr, socklen_t len, int type)
 		goto close_out;
 	if (CHECK_FAIL(bind(fd, addr, len) == -1))
 		goto close_out;
-	if (CHECK_FAIL(listen(fd, 128) == -1))
+	if (type == SOCK_STREAM && CHECK_FAIL(listen(fd, 128) == -1))
 		goto close_out;
 
 	goto out;
@@ -125,6 +125,20 @@ get_port(int fd)
 	return port;
 }
 
+static ssize_t
+rcv_msg(int srv_client, int type)
+{
+	struct sockaddr_storage ss;
+	char buf[BUFSIZ];
+	socklen_t slen;
+
+	if (type == SOCK_STREAM)
+		return read(srv_client, &buf, sizeof(buf));
+	else
+		return recvfrom(srv_client, &buf, sizeof(buf), 0,
+				(struct sockaddr *)&ss, &slen);
+}
+
 static int
 run_test(int server_fd, const struct sockaddr *addr, socklen_t len, int type)
 {
@@ -139,16 +153,20 @@ run_test(int server_fd, const struct sockaddr *addr, socklen_t len, int type)
 		goto out;
 	}
 
-	srv_client = accept(server_fd, NULL, NULL);
-	if (CHECK_FAIL(srv_client == -1)) {
-		perror("Can't accept connection");
-		goto out;
+	if (type == SOCK_STREAM) {
+		srv_client = accept(server_fd, NULL, NULL);
+		if (CHECK_FAIL(srv_client == -1)) {
+			perror("Can't accept connection");
+			goto out;
+		}
+	} else {
+		srv_client = server_fd;
 	}
 	if (CHECK_FAIL(write(client, buf, sizeof(buf)) != sizeof(buf))) {
 		perror("Can't write on client");
 		goto out;
 	}
-	if (CHECK_FAIL(read(srv_client, &buf, sizeof(buf)) != sizeof(buf))) {
+	if (CHECK_FAIL(rcv_msg(srv_client, type) != sizeof(buf))) {
 		perror("Can't read on server");
 		goto out;
 	}
@@ -156,9 +174,20 @@ run_test(int server_fd, const struct sockaddr *addr, socklen_t len, int type)
 	port = get_port(srv_client);
 	if (CHECK_FAIL(!port))
 		goto out;
-	if (CHECK(port != htons(CONNECT_PORT), "Expected", "port %u but got %u",
+	/* SOCK_STREAM is connected via accept(), so the server's local address
+	 * will be the CONNECT_PORT rather than the BIND port that corresponds
+	 * to the listen socket. SOCK_DGRAM on the other hand is connectionless
+	 * so we can't really do the same check there; the server doesn't ever
+	 * create a socket with CONNECT_PORT.
+	 */
+	if (type == SOCK_STREAM &&
+	    CHECK(port != htons(CONNECT_PORT), "Expected", "port %u but got %u",
 		  CONNECT_PORT, ntohs(port)))
 		goto out;
+	else if (type == SOCK_DGRAM &&
+		 CHECK(port != htons(BIND_PORT), "Expected",
+		       "port %u but got %u", BIND_PORT, ntohs(port)))
+		goto out;
 
 	ret = 0;
 out:
@@ -230,6 +259,10 @@ void test_sk_assign(void)
 		TEST("ipv4 tcp addr redir", AF_INET, SOCK_STREAM, true),
 		TEST("ipv6 tcp port redir", AF_INET6, SOCK_STREAM, false),
 		TEST("ipv6 tcp addr redir", AF_INET6, SOCK_STREAM, true),
+		TEST("ipv4 udp port redir", AF_INET, SOCK_DGRAM, false),
+		TEST("ipv4 udp addr redir", AF_INET, SOCK_DGRAM, true),
+		TEST("ipv6 udp port redir", AF_INET6, SOCK_DGRAM, false),
+		TEST("ipv6 udp addr redir", AF_INET6, SOCK_DGRAM, true),
 	};
 	int server = -1;
 	int self_net;
diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
index bde8748799eb..99547dcaac12 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_assign.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
@@ -21,7 +21,7 @@ char _license[] SEC("license") = "GPL";
 
 /* Fill 'tuple' with L3 info, and attempt to find L4. On fail, return NULL. */
 static inline struct bpf_sock_tuple *
-get_tuple(struct __sk_buff *skb, bool *ipv4)
+get_tuple(struct __sk_buff *skb, bool *ipv4, bool *tcp)
 {
 	void *data_end = (void *)(long)skb->data_end;
 	void *data = (void *)(long)skb->data;
@@ -60,12 +60,64 @@ get_tuple(struct __sk_buff *skb, bool *ipv4)
 		return (struct bpf_sock_tuple *)data;
 	}
 
-	if (result + 1 > data_end || proto != IPPROTO_TCP)
+	if (proto != IPPROTO_TCP && proto != IPPROTO_UDP)
 		return NULL;
 
+	*tcp = (proto == IPPROTO_TCP);
 	return result;
 }
 
+static inline int
+handle_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
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
+	sk = bpf_sk_lookup_udp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
+	if (sk)
+		goto assign;
+
+	if (ipv4) {
+		if (tuple->ipv4.dport != bpf_htons(4321))
+			return TC_ACT_OK;
+
+		ln.ipv4.daddr = bpf_htonl(0x7f000001);
+		ln.ipv4.dport = bpf_htons(1234);
+
+		sk = bpf_sk_lookup_udp(skb, &ln, sizeof(ln.ipv4),
+					BPF_F_CURRENT_NETNS, 0);
+	} else {
+		if (tuple->ipv6.dport != bpf_htons(4321))
+			return TC_ACT_OK;
+
+		/* Upper parts of daddr are already zero. */
+		ln.ipv6.daddr[3] = bpf_htonl(0x1);
+		ln.ipv6.dport = bpf_htons(1234);
+
+		sk = bpf_sk_lookup_udp(skb, &ln, sizeof(ln.ipv6),
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
+assign:
+	ret = bpf_sk_assign(skb, sk, 0);
+	bpf_sk_release(sk);
+	return ret;
+}
+
 static inline int
 handle_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, bool ipv4)
 {
@@ -130,14 +182,23 @@ int bpf_sk_assign_test(struct __sk_buff *skb)
 {
 	struct bpf_sock_tuple *tuple, ln = {0};
 	bool ipv4 = false;
+	bool tcp = false;
 	int tuple_len;
 	int ret = 0;
 
-	tuple = get_tuple(skb, &ipv4);
+	tuple = get_tuple(skb, &ipv4, &tcp);
 	if (!tuple)
 		return TC_ACT_SHOT;
 
-	ret = handle_tcp(skb, tuple, ipv4);
+	/* Note that the verifier socket return type for bpf_skc_lookup_tcp()
+	 * differs from bpf_sk_lookup_udp(), so even though the C-level type is
+	 * the same here, if we try to share the implementations they will
+	 * fail to verify because we're crossing pointer types.
+	 */
+	if (tcp)
+		ret = handle_tcp(skb, tuple, ipv4);
+	else
+		ret = handle_udp(skb, tuple, ipv4);
 
 	return ret == 0 ? TC_ACT_OK : TC_ACT_SHOT;
 }
-- 
2.20.1

