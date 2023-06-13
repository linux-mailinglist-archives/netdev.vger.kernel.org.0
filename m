Return-Path: <netdev+bounces-10352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BAE372DF38
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37A131C20C40
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D9A3ED87;
	Tue, 13 Jun 2023 10:15:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CD03ED83
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:15:10 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6DB19B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:15:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30c4775d05bso3724480f8f.2
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1686651306; x=1689243306;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rrd+oVQwBiLqnLnpd+kxgQqY6NXFWO5dlCZVFiDqXJs=;
        b=dON+bTrbeu4YdnaPb/0E4JBD/k66UBlAuGkGgEM1IT4EBxyQgknhhh9qWXJFqGKRng
         iFcdbQRxNyZMN1tQ2IcfrV/PsxLrlIaEJIrVMMf48yVUKpC42+NOLlZSEmhhixGxfXwI
         CtNwVYiZarmA353WCs5heKR1GTec1S1Ki+HWhZp4OFrEjjJn2JNapjMuc5+UZ7VYewiA
         Wud9nvis58lr75DYbN/5v8sH5x2/DFiDusIW3coumC3DbR0USwALX3qaBX/Y9mnQUh4v
         tqNOl2/qQ+Oz2DHotIRdZ20HD6k4lXVsT3CTA4DTaqmVJdirpieNSR0Hn1EljbemKC+S
         i0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686651306; x=1689243306;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rrd+oVQwBiLqnLnpd+kxgQqY6NXFWO5dlCZVFiDqXJs=;
        b=dUJlBMROa/K+rEpIqrPbUhwAOa0lIknNsAL0M2kaWfJCaSSgd/4faKVHVQzg+NWAsT
         QMVLlwho6AD/JVHQTBkiTYbERyIo58cS9YDR2irfUKdxBKGwbQPOQrcYqKNtP+1HNppL
         q8J7qVmMuBR/motjK6hK965cuozTFrlf3KA329SwbZ8wHiKBBNTSoSsNpU7tpM/TYc4a
         GG+H7WuQUaoEyoMXJshyNevNUFbB+xJ6UXS6qGfwWsJ4RVglf3xgR5+WhvBWvG5Xy6yq
         Om+Ag/mcJNGAuUUQH4Ysgg1asMstWg382eAgkZQxM3wb8p9lhDf4RFjLLl5cqho0Gh/F
         4RtA==
X-Gm-Message-State: AC+VfDzU8Sa2iHM00cw6ljBICMnYa1sYdLZ3eeKqG6jDDFM4BclXbMby
	GKemYP2DIoA6sY9WEZsUKWQ2NQ==
X-Google-Smtp-Source: ACHHUZ5GQ7sIG+N/DYtNauCCoD5it7RXk8FH3aWkE29SOtDbV2w/tlexjvz4Ac9XivlhyLXPHYycTw==
X-Received: by 2002:a5d:55cf:0:b0:2f9:ee8c:a2fa with SMTP id i15-20020a5d55cf000000b002f9ee8ca2famr6402072wrw.64.1686651305914;
        Tue, 13 Jun 2023 03:15:05 -0700 (PDT)
Received: from [192.168.133.193] ([5.148.46.226])
        by smtp.gmail.com with ESMTPSA id k15-20020a5d6e8f000000b0030e6096afb6sm15075020wrz.12.2023.06.13.03.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 03:15:05 -0700 (PDT)
From: Lorenz Bauer <lmb@isovalent.com>
Date: Tue, 13 Jun 2023 11:15:01 +0100
Subject: [PATCH bpf-next v2 6/6] selftests/bpf: Test that SO_REUSEPORT can
 be used with sk_assign helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230613-so-reuseport-v2-6-b7c69a342613@isovalent.com>
References: <20230613-so-reuseport-v2-0-b7c69a342613@isovalent.com>
In-Reply-To: <20230613-so-reuseport-v2-0-b7c69a342613@isovalent.com>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, 
 KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, 
 Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
 Joe Stringer <joe@wand.net.nz>, Mykola Lysenko <mykolal@fb.com>, 
 Shuah Khan <shuah@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Hemanth Malla <hemanthmalla@gmail.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Lorenz Bauer <lmb@isovalent.com>, 
 Joe Stringer <joe@cilium.io>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Daniel Borkmann <daniel@iogearbox.net>

We use two programs to check that the new reuseport logic is executed
appropriately.

The first is a TC clsact program which bpf_sk_assigns
the skb to a UDP or TCP socket created by user space. Since the test
communicates via lo we see both directions of packets in the eBPF.
Traffic ingressing to the reuseport socket is identified by looking
at the destination port. For TCP, we additionally need to make sure
that we only assign the initial SYN packets towards our listening
socket. The network stack then creates a request socket which
transitions to ESTABLISHED after the 3WHS.

The second is a reuseport program which shares the fact that
it has been executed with user space. This tells us that the delayed
lookup mechanism is working.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Co-developed-by: Lorenz Bauer <lmb@isovalent.com>
Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
Cc: Joe Stringer <joe@cilium.io>
---
 tools/testing/selftests/bpf/network_helpers.c      |   3 +
 .../selftests/bpf/prog_tests/assign_reuse.c        | 197 +++++++++++++++++++++
 .../selftests/bpf/progs/test_assign_reuse.c        | 142 +++++++++++++++
 3 files changed, 342 insertions(+)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index a105c0cd008a..8a33bcea97de 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -423,6 +423,9 @@ struct nstoken *open_netns(const char *name)
 
 void close_netns(struct nstoken *token)
 {
+	if (!token)
+		return;
+
 	ASSERT_OK(setns(token->orig_netns_fd, CLONE_NEWNET), "setns");
 	close(token->orig_netns_fd);
 	free(token);
diff --git a/tools/testing/selftests/bpf/prog_tests/assign_reuse.c b/tools/testing/selftests/bpf/prog_tests/assign_reuse.c
new file mode 100644
index 000000000000..622f123410f4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/assign_reuse.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Isovalent */
+#include <uapi/linux/if_link.h>
+#include <test_progs.h>
+
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+
+#include "network_helpers.h"
+#include "test_assign_reuse.skel.h"
+
+#define NS_TEST "assign_reuse"
+#define LOOPBACK 1
+#define PORT 4443
+
+static int attach_reuseport(int sock_fd, int prog_fd)
+{
+	return setsockopt(sock_fd, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+			  &prog_fd, sizeof(prog_fd));
+}
+
+static __u64 cookie(int fd)
+{
+	__u64 cookie = 0;
+	socklen_t cookie_len = sizeof(cookie);
+	int ret;
+
+	ret = getsockopt(fd, SOL_SOCKET, SO_COOKIE, &cookie, &cookie_len);
+	ASSERT_OK(ret, "cookie");
+	ASSERT_GT(cookie, 0, "cookie_invalid");
+
+	return cookie;
+}
+
+static int echo_test_udp(int fd_sv)
+{
+	struct sockaddr_storage addr = {};
+	socklen_t len = sizeof(addr);
+	char buff[1] = {};
+	int fd_cl = -1, ret;
+
+	fd_cl = connect_to_fd(fd_sv, 100);
+	ASSERT_GT(fd_cl, 0, "create_client");
+	ASSERT_EQ(getsockname(fd_cl, (void *)&addr, &len), 0, "getsockname");
+
+	ASSERT_EQ(send(fd_cl, buff, sizeof(buff), 0), 1, "send_client");
+
+	ret = recv(fd_sv, buff, sizeof(buff), 0);
+	if (ret < 0)
+		return errno;
+
+	ASSERT_EQ(ret, 1, "recv_server");
+	ASSERT_EQ(sendto(fd_sv, buff, sizeof(buff), 0, (void *)&addr, len), 1, "send_server");
+	ASSERT_EQ(recv(fd_cl, buff, sizeof(buff), 0), 1, "recv_client");
+	close(fd_cl);
+	return 0;
+}
+
+static int echo_test_tcp(int fd_sv)
+{
+	char buff[1] = {};
+	int fd_cl = -1, fd_sv_cl = -1;
+
+	fd_cl = connect_to_fd(fd_sv, 100);
+	if (fd_cl < 0)
+		return errno;
+
+	fd_sv_cl = accept(fd_sv, NULL, NULL);
+	ASSERT_GE(fd_sv_cl, 0, "accept_fd");
+
+	ASSERT_EQ(send(fd_cl, buff, sizeof(buff), 0), 1, "send_client");
+	ASSERT_EQ(recv(fd_sv_cl, buff, sizeof(buff), 0), 1, "recv_server");
+	ASSERT_EQ(send(fd_sv_cl, buff, sizeof(buff), 0), 1, "send_server");
+	ASSERT_EQ(recv(fd_cl, buff, sizeof(buff), 0), 1, "recv_client");
+	close(fd_sv_cl);
+	close(fd_cl);
+	return 0;
+}
+
+void run_assign_reuse(int family, int sotype, const char *ip, __u16 port)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
+		.ifindex = LOOPBACK,
+		.attach_point = BPF_TC_INGRESS,
+	);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, tc_opts,
+		.handle = 1,
+		.priority = 1,
+	);
+	bool hook_created = false, tc_attached = false;
+	int ret, fd_tc, fd_accept, fd_drop, fd_map;
+	int *fd_sv = NULL;
+	__u64 fd_val;
+	struct test_assign_reuse *skel;
+	const int zero = 0;
+
+	skel = test_assign_reuse__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		goto cleanup;
+
+	skel->rodata->dest_port = port;
+
+	ret = test_assign_reuse__load(skel);
+	if (!ASSERT_OK(ret, "skel_load"))
+		goto cleanup;
+
+	ASSERT_EQ(skel->bss->sk_cookie_seen, 0, "cookie_init");
+
+	fd_tc = bpf_program__fd(skel->progs.tc_main);
+	fd_accept = bpf_program__fd(skel->progs.reuse_accept);
+	fd_drop = bpf_program__fd(skel->progs.reuse_drop);
+	fd_map = bpf_map__fd(skel->maps.sk_map);
+
+	fd_sv = start_reuseport_server(family, sotype, ip, port, 100, 1);
+	if (!ASSERT_NEQ(fd_sv, NULL, "start_reuseport_server"))
+		goto cleanup;
+
+	ret = attach_reuseport(*fd_sv, fd_drop);
+	if (!ASSERT_OK(ret, "attach_reuseport"))
+		goto cleanup;
+
+	fd_val = *fd_sv;
+	ret = bpf_map_update_elem(fd_map, &zero, &fd_val, BPF_NOEXIST);
+	if (!ASSERT_OK(ret, "bpf_sk_map"))
+		goto cleanup;
+
+	ret = bpf_tc_hook_create(&tc_hook);
+	if (ret == 0)
+		hook_created = true;
+	ret = ret == -EEXIST ? 0 : ret;
+	if (!ASSERT_OK(ret, "bpf_tc_hook_create"))
+		goto cleanup;
+
+	tc_opts.prog_fd = fd_tc;
+	ret = bpf_tc_attach(&tc_hook, &tc_opts);
+	if (!ASSERT_OK(ret, "bpf_tc_attach"))
+		goto cleanup;
+	tc_attached = true;
+
+	if (sotype == SOCK_STREAM)
+		ASSERT_EQ(echo_test_tcp(*fd_sv), ECONNREFUSED, "drop_tcp");
+	else
+		ASSERT_EQ(echo_test_udp(*fd_sv), EAGAIN, "drop_udp");
+	ASSERT_EQ(skel->bss->reuseport_executed, 1, "program executed once");
+
+	skel->bss->sk_cookie_seen = 0;
+	skel->bss->reuseport_executed = 0;
+	ASSERT_OK(attach_reuseport(*fd_sv, fd_accept), "attach_reuseport(accept)");
+
+	if (sotype == SOCK_STREAM)
+		ASSERT_EQ(echo_test_tcp(*fd_sv), 0, "echo_tcp");
+	else
+		ASSERT_EQ(echo_test_udp(*fd_sv), 0, "echo_udp");
+
+	ASSERT_EQ(skel->bss->sk_cookie_seen, cookie(*fd_sv),
+		  "cookie_mismatch");
+	ASSERT_EQ(skel->bss->reuseport_executed, 1, "program executed once");
+cleanup:
+	if (tc_attached) {
+		tc_opts.flags = tc_opts.prog_fd = tc_opts.prog_id = 0;
+		ret = bpf_tc_detach(&tc_hook, &tc_opts);
+		ASSERT_OK(ret, "bpf_tc_detach");
+	}
+	if (hook_created) {
+		tc_hook.attach_point = BPF_TC_INGRESS | BPF_TC_EGRESS;
+		bpf_tc_hook_destroy(&tc_hook);
+	}
+	test_assign_reuse__destroy(skel);
+	free_fds(fd_sv, 1);
+}
+
+void test_assign_reuse(void)
+{
+	struct nstoken *tok = NULL;
+
+	SYS(out, "ip netns add %s", NS_TEST);
+	SYS(cleanup, "ip -net %s link set dev lo up", NS_TEST);
+
+	tok = open_netns(NS_TEST);
+	if (!ASSERT_OK_PTR(tok, "netns token"))
+		return;
+
+	if (test__start_subtest("tcpv4"))
+		run_assign_reuse(AF_INET, SOCK_STREAM, "127.0.0.1", PORT);
+	if (test__start_subtest("tcpv6"))
+		run_assign_reuse(AF_INET6, SOCK_STREAM, "::1", PORT);
+	if (test__start_subtest("udpv4"))
+		run_assign_reuse(AF_INET, SOCK_DGRAM, "127.0.0.1", PORT);
+	if (test__start_subtest("udpv6"))
+		run_assign_reuse(AF_INET6, SOCK_DGRAM, "::1", PORT);
+
+cleanup:
+	close_netns(tok);
+	SYS_NOFAIL("ip netns delete %s", NS_TEST);
+out:
+	return;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_assign_reuse.c b/tools/testing/selftests/bpf/progs/test_assign_reuse.c
new file mode 100644
index 000000000000..4f2e2321ea06
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_assign_reuse.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Isovalent */
+#include <stdbool.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/pkt_cls.h>
+
+char LICENSE[] SEC("license") = "GPL";
+
+__u64 sk_cookie_seen;
+__u64 reuseport_executed;
+union {
+	struct tcphdr tcp;
+	struct udphdr udp;
+} headers;
+
+const volatile __u16 dest_port;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} sk_map SEC(".maps");
+
+SEC("sk_reuseport")
+int reuse_accept(struct sk_reuseport_md *ctx)
+{
+	reuseport_executed++;
+
+	if (ctx->ip_protocol == IPPROTO_TCP) {
+		if (ctx->data + sizeof(headers.tcp) > ctx->data_end)
+			return SK_DROP;
+
+		if (__builtin_memcmp(&headers.tcp, ctx->data, sizeof(headers.tcp)) != 0)
+			return SK_DROP;
+	} else if (ctx->ip_protocol == IPPROTO_UDP) {
+		if (ctx->data + sizeof(headers.udp) > ctx->data_end)
+			return SK_DROP;
+
+		if (__builtin_memcmp(&headers.udp, ctx->data, sizeof(headers.udp)) != 0)
+			return SK_DROP;
+	} else {
+		return SK_DROP;
+	}
+
+	sk_cookie_seen = bpf_get_socket_cookie(ctx->sk);
+	return SK_PASS;
+}
+
+SEC("sk_reuseport")
+int reuse_drop(struct sk_reuseport_md *ctx)
+{
+	reuseport_executed++;
+	sk_cookie_seen = 0;
+	return SK_DROP;
+}
+
+static int
+assign_sk(struct __sk_buff *skb)
+{
+	int zero = 0, ret = 0;
+	struct bpf_sock *sk;
+
+	sk = bpf_map_lookup_elem(&sk_map, &zero);
+	if (!sk)
+		return TC_ACT_SHOT;
+	ret = bpf_sk_assign(skb, sk, 0);
+	bpf_sk_release(sk);
+	return ret ? TC_ACT_SHOT : TC_ACT_OK;
+}
+
+static bool
+maybe_assign_tcp(struct __sk_buff *skb, struct tcphdr *th)
+{
+	if (th + 1 > (void *)(long)(skb->data_end))
+		return TC_ACT_SHOT;
+
+	if (!th->syn || th->ack || th->dest != bpf_htons(dest_port))
+		return TC_ACT_OK;
+
+	__builtin_memcpy(&headers.tcp, th, sizeof(headers.tcp));
+	return assign_sk(skb);
+}
+
+static bool
+maybe_assign_udp(struct __sk_buff *skb, struct udphdr *uh)
+{
+	if (uh + 1 > (void *)(long)(skb->data_end))
+		return TC_ACT_SHOT;
+
+	if (uh->dest != bpf_htons(dest_port))
+		return TC_ACT_OK;
+
+	__builtin_memcpy(&headers.udp, uh, sizeof(headers.udp));
+	return assign_sk(skb);
+}
+
+SEC("tc")
+int tc_main(struct __sk_buff *skb)
+{
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+	struct ethhdr *eth;
+
+	eth = (struct ethhdr *)(data);
+	if (eth + 1 > data_end)
+		return TC_ACT_SHOT;
+
+	if (eth->h_proto == bpf_htons(ETH_P_IP)) {
+		struct iphdr *iph = (struct iphdr *)(data + sizeof(*eth));
+
+		if (iph + 1 > data_end)
+			return TC_ACT_SHOT;
+
+		if (iph->protocol == IPPROTO_TCP)
+			return maybe_assign_tcp(skb, (struct tcphdr *)(iph + 1));
+		else if (iph->protocol == IPPROTO_UDP)
+			return maybe_assign_udp(skb, (struct udphdr *)(iph + 1));
+		else
+			return TC_ACT_SHOT;
+	} else {
+		struct ipv6hdr *ip6h = (struct ipv6hdr *)(data + sizeof(*eth));
+
+		if (ip6h + 1 > data_end)
+			return TC_ACT_SHOT;
+
+		if (ip6h->nexthdr == IPPROTO_TCP)
+			return maybe_assign_tcp(skb, (struct tcphdr *)(ip6h + 1));
+		else if (ip6h->nexthdr == IPPROTO_UDP)
+			return maybe_assign_udp(skb, (struct udphdr *)(ip6h + 1));
+		else
+			return TC_ACT_SHOT;
+	}
+}

-- 
2.40.1


