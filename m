Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305636E97A9
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjDTOv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjDTOvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:51:21 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4F77282;
        Thu, 20 Apr 2023 07:51:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o29-20020a05600c511d00b003f1739de43cso1256655wms.4;
        Thu, 20 Apr 2023 07:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682002273; x=1684594273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KnyPHhlG14bz6EDEVcoWERsXlhJzJCPorj/CGFgJlCg=;
        b=b/SYIujKmEBBS7uc5khOPASaikHn90tU41wjBccD6/9T4KIzYeRk97obV+deMvIuod
         CGsgYUL9x/Zlihr/+56afeCZzIqZ0e0G5VoHKzeBQnrCFzGv/+v7c80Ga4Pu++f5ozAD
         c1yx8Y7pCKJwOS8RSBFGfLinNB0Si94LqFMilOIMvZ21h0RSOW/t+ZZwpUo/9+znUNki
         78uNazdHh0kSjciewk7vaf4nJEjo8NZen35uxNuQ/KIYRRIbxHU2XDM8o10NTrdmHEnU
         czwhfaw+sR3a6uqposj/VAIH28wAitsTK8wEOe5ZLc2otrQxpNm/MWKgqjw+OuqataZN
         Umzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682002273; x=1684594273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KnyPHhlG14bz6EDEVcoWERsXlhJzJCPorj/CGFgJlCg=;
        b=YuPKGtQo+H3ZQ6EasHNhXP+8x1v2cgNLzOFzcQwwi3W4BLnZELXRoFSTzu03LQVicQ
         C6PNcAh9fD2NRVwZvR3vJj53Q9ZgG9Bq5hO5UNiL2cX/pc4xQZo6/IHmsZHZp+SyQ8+y
         jejF6vTsupY13CbhTlIYC3TW6CYk5lNXrjCQlpjZwMXsKIFnIK4y0Z7lx9RaBDEPFYr2
         r/GM6GpfHLee+vxY2JoLtmS45vqUKOoF8Jo6BapIbDCGnnvpaiwU+CzhnH4voqrbNjQF
         cpZt5tUJG0HBZPrkGXoRE8TsX+YciwraLJH0NErRXI8jQ/sDFgxyEJH0bog8lTrKviGe
         ME7w==
X-Gm-Message-State: AAQBX9dgQei3qH6xlvWDa7QGVByv99v/uI2jft043jnRrQOdb/yzW7hj
        uam6jky4OMCZkUnhEBMQBCE=
X-Google-Smtp-Source: AKy350Z8tDn2o/xfiXysAFd7WB5i0oHirLEtfCSvAyCvA/jFKHyu0XI2/okQhh9Dwqi08skAkbYbWA==
X-Received: by 2002:a7b:ce04:0:b0:3f1:6757:6243 with SMTP id m4-20020a7bce04000000b003f167576243mr1369685wmc.35.1682002272513;
        Thu, 20 Apr 2023 07:51:12 -0700 (PDT)
Received: from gsever-Latitude-7400.corp.proofpoint.com ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003f17b96793dsm5534619wmk.37.2023.04.20.07.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:51:12 -0700 (PDT)
From:   Gilad Sever <gilad9366@gmail.com>
To:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz
Cc:     eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Gilad Sever <gilad9366@gmail.com>
Subject: [PATCH bpf,v2 4/4] selftests/bpf: Add tc_socket_lookup tests
Date:   Thu, 20 Apr 2023 17:50:41 +0300
Message-Id: <20230420145041.508434-5-gilad9366@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420145041.508434-1-gilad9366@gmail.com>
References: <20230420145041.508434-1-gilad9366@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that socket lookup via TC with all BPF APIs is VRF aware.

Signed-off-by: Gilad Sever <gilad9366@gmail.com>
---
v2: Fix build by initializing vars with -1
---
 .../bpf/prog_tests/tc_socket_lookup.c         | 341 ++++++++++++++++++
 .../selftests/bpf/progs/tc_socket_lookup.c    |  73 ++++
 2 files changed, 414 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/tc_socket_lookup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c b/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
new file mode 100644
index 000000000000..5dcaf0ea3f8c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
@@ -0,0 +1,341 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+/*
+ * Topology:
+ * ---------
+ *     NS1 namespace         |   NS2 namespace
+ *			     |
+ *     +--------------+      |   +--------------+
+ *     |    veth01    |----------|    veth10    |
+ *     | 172.16.1.100 |      |   | 172.16.1.200 |
+ *     |     bpf      |      |   +--------------+
+ *     +--------------+      |
+ *      server(UDP/TCP)      |
+ *  +-------------------+    |
+ *  |        vrf1       |    |
+ *  |  +--------------+ |    |   +--------------+
+ *  |  |    veth02    |----------|    veth20    |
+ *  |  | 172.16.2.100 | |    |   | 172.16.2.200 |
+ *  |  |     bpf      | |    |   +--------------+
+ *  |  +--------------+ |    |
+ *  |   server(UDP/TCP) |    |
+ *  +-------------------+    |
+ *
+ * Test flow
+ * -----------
+ *  The tests verifies that socket lookup via TC is VRF aware:
+ *  1) Creates two veth pairs between NS1 and NS2:
+ *     a) veth01 <-> veth10 outside the VRF
+ *     b) veth02 <-> veth20 in the VRF
+ *  2) Attaches to veth01 and veth02 a program that calls:
+ *     a) bpf_skc_lookup_tcp() with TCP and tcp_skc is true
+ *     b) bpf_sk_lookup_tcp() with TCP and tcp_skc is false
+ *     c) bpf_sk_lookup_udp() with UDP
+ *     The program stores the lookup result in bss->lookup_status.
+ *  3) Creates a socket TCP/UDP server in/outside the VRF.
+ *  4) The test expects lookup_status to be:
+ *     a) 0 from device in VRF to server outside VRF
+ *     b) 0 from device outside VRF to server in VRF
+ *     c) 1 from device in VRF to server in VRF
+ *     d) 1 from device outside VRF to server outside VRF
+ */
+
+#include <net/if.h>
+
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "tc_socket_lookup.skel.h"
+
+#define NS1 "tc_socket_lookup_1"
+#define NS2 "tc_socket_lookup_2"
+
+#define IP4_ADDR_VETH01 "172.16.1.100"
+#define IP4_ADDR_VETH10 "172.16.1.200"
+#define IP4_ADDR_VETH02 "172.16.2.100"
+#define IP4_ADDR_VETH20 "172.16.2.200"
+
+#define NON_VRF_PORT 5000
+#define IN_VRF_PORT 5001
+
+#define IO_TIMEOUT_SEC	3
+
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto fail;				\
+	})
+
+#define SYS_NOFAIL(fmt, ...)					\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		system(cmd);					\
+	})
+
+static int make_socket(int sotype, const char *ip, int port,
+		       struct sockaddr_storage *addr)
+{
+	struct timeval timeo = { .tv_sec = IO_TIMEOUT_SEC };
+	int err, fd;
+
+	err = make_sockaddr(AF_INET, ip, port, addr, NULL);
+	if (!ASSERT_OK(err, "make_address"))
+		return -1;
+
+	fd = socket(AF_INET, sotype, 0);
+	if (!ASSERT_OK(fd < 0, "socket"))
+		return -1;
+
+	err = setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
+	if (!ASSERT_OK(err, "setsockopt(SO_SNDTIMEO)"))
+		goto fail;
+
+	err = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
+	if (!ASSERT_OK(err, "setsockopt(SO_RCVTIMEO)"))
+		goto fail;
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+static int make_server(int sotype, const char *ip, int port, const char *ifname)
+{
+	struct sockaddr_storage addr = {};
+	const int one = 1;
+	int err, fd = -1;
+
+	fd = make_socket(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	if (sotype == SOCK_STREAM) {
+		err = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one,
+				 sizeof(one));
+		if (!ASSERT_OK(err, "setsockopt(SO_REUSEADDR)"))
+			goto fail;
+	}
+
+	if (ifname) {
+		err = setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
+				 ifname, strlen(ifname) + 1);
+		if (!ASSERT_OK(err, "setsockopt(SO_BINDTODEVICE)"))
+			goto fail;
+	}
+
+	err = bind(fd, (void *)&addr, sizeof(struct sockaddr_in));
+	if (!ASSERT_OK(err, "bind"))
+		goto fail;
+
+	if (sotype == SOCK_STREAM) {
+		err = listen(fd, SOMAXCONN);
+		if (!ASSERT_OK(err, "listen"))
+			goto fail;
+	}
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+static int attach_tc_prog(struct bpf_tc_hook *hook, int prog_fd)
+{
+	LIBBPF_OPTS(bpf_tc_opts, opts1, .handle = 1, .priority = 1,
+		    .prog_fd = prog_fd);
+	int ret;
+
+	ret = bpf_tc_hook_create(hook);
+	if (!ASSERT_OK(ret, "create tc hook"))
+		return ret;
+
+	if (prog_fd >= 0) {
+		hook->attach_point = BPF_TC_INGRESS;
+		ret = bpf_tc_attach(hook, &opts1);
+		if (!ASSERT_OK(ret, "bpf_tc_attach")) {
+			bpf_tc_hook_destroy(hook);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void cleanup(void)
+{
+	SYS_NOFAIL("test -f /var/run/netns/" NS1 " && ip netns delete "
+		   NS1);
+	SYS_NOFAIL("test -f /var/run/netns/" NS2 " && ip netns delete "
+		   NS2);
+}
+
+static int setup(struct tc_socket_lookup *skel)
+{
+	LIBBPF_OPTS(bpf_tc_hook, tc_hook, .attach_point = BPF_TC_INGRESS);
+	struct nstoken *nstoken = NULL;
+	int ifindex, prog_fd, ret = 0;
+
+	SYS("ip netns add " NS1);
+	SYS("ip netns add " NS2);
+
+	/* NS1 <-> NS2 [veth01 <-> veth10] */
+	SYS("ip link add veth01 netns " NS1 " type veth peer name veth10 netns "
+	    NS2);
+	SYS("ip -net " NS1 " addr add " IP4_ADDR_VETH01 "/24 dev veth01");
+	SYS("ip -net " NS1 " link set dev veth01 up");
+	SYS("ip -net " NS2 " addr add " IP4_ADDR_VETH10 "/24 dev veth10");
+	SYS("ip -net " NS2 " link set dev veth10 up");
+
+	/* NS1 <-> NS2 [veth02 <-> veth20] */
+	SYS("ip link add veth02 netns " NS1 " type veth peer name veth20 netns "
+	    NS2);
+	SYS("ip -net " NS1 " addr add " IP4_ADDR_VETH02 "/24 dev veth02");
+	SYS("ip -net " NS1 " link set dev veth02 up");
+	SYS("ip -net " NS2 " addr add " IP4_ADDR_VETH20 "/24 dev veth20");
+	SYS("ip -net " NS2 " link set dev veth20 up");
+
+	/* veth02 -> vrf1  */
+	SYS("ip -net " NS1 " link add vrf1 type vrf table 11");
+	SYS("ip -net " NS1 " route add vrf vrf1 unreachable default metric "
+	    "4278198272");
+	SYS("ip -net " NS1 " link set vrf1 alias vrf");
+	SYS("ip -net " NS1 " link set vrf1 up");
+	SYS("ip -net " NS1 " link set veth02 master vrf1");
+
+	/* Attach prog to veth devices in NS1 */
+	nstoken = open_netns(NS1);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS1))
+		goto fail;
+	prog_fd = bpf_program__fd(skel->progs.test_socket_lookup);
+	if (!ASSERT_GE(prog_fd, 0, "bpf_program__fd"))
+		goto fail;
+
+	ifindex = if_nametoindex("veth01");
+	if (!ASSERT_NEQ(ifindex, 0, "veth01 ifindex"))
+		goto fail;
+	tc_hook.ifindex = ifindex;
+	if (attach_tc_prog(&tc_hook, prog_fd))
+		goto fail;
+
+	ifindex = if_nametoindex("veth02");
+	if (!ASSERT_NEQ(ifindex, 0, "veth02 ifindex"))
+		goto fail;
+	tc_hook.ifindex = ifindex;
+	if (attach_tc_prog(&tc_hook, prog_fd))
+		goto fail;
+	goto close;
+fail:
+	ret = -1;
+close:
+	if (nstoken)
+		close_netns(nstoken);
+	return ret;
+}
+
+static int test_lookup(struct tc_socket_lookup *skel, int sotype,
+		       const char *ip, int port, bool tcp_skc,
+		       int lookup_status_exp)
+{
+	static const char msg[] = "Hello Server";
+	struct sockaddr_storage addr = {};
+	int fd, ret = 0;
+
+	fd = make_socket(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	skel->bss->tcp_skc = tcp_skc;
+	skel->bss->lookup_status = -1;
+
+	if (sotype == SOCK_STREAM)
+		connect(fd, (void *)&addr, sizeof(struct sockaddr_in));
+	else
+		sendto(fd, msg, sizeof(msg), 0, (void *)&addr,
+		       sizeof(struct sockaddr_in));
+
+	if (!ASSERT_EQ(skel->bss->lookup_status, lookup_status_exp,
+		       "lookup_status"))
+		goto fail;
+
+	goto close;
+
+fail:
+	ret = -1;
+close:
+	close(fd);
+	return ret;
+}
+
+static void _test_tc_socket_lookup(struct tc_socket_lookup *skel, int sotype,
+				   bool tcp_skc)
+{
+	int in_vrf_server = -1, non_vrf_server = -1;
+	struct nstoken *nstoken = NULL;
+
+	nstoken = open_netns(NS1);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS1))
+		goto done;
+
+	/* Open sockets in and outside VRF */
+	non_vrf_server = make_server(sotype, "0.0.0.0", NON_VRF_PORT, NULL);
+	if (!ASSERT_GE(non_vrf_server, 0, "make_server__outside_vrf_fd"))
+		goto done;
+
+	in_vrf_server = make_server(sotype, "0.0.0.0", IN_VRF_PORT, "veth02");
+	if (!ASSERT_GE(in_vrf_server, 0, "make_server__in_vrf_fd"))
+		goto done;
+
+	/* Perform test from NS2 */
+	close_netns(nstoken);
+	nstoken = open_netns(NS2);
+	if (!ASSERT_OK_PTR(nstoken, "setns " NS2))
+		goto done;
+
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH02, NON_VRF_PORT,
+				   tcp_skc, 0), "in_to_out"))
+		goto done;
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH02, IN_VRF_PORT,
+				   tcp_skc, 1), "in_to_in"))
+		goto done;
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH01, NON_VRF_PORT,
+				   tcp_skc, 1), "out_to_out"))
+		goto done;
+	if (!ASSERT_OK(test_lookup(skel, sotype, IP4_ADDR_VETH01, IN_VRF_PORT,
+				   tcp_skc, 0), "out_to_in"))
+		goto done;
+
+done:
+	if (non_vrf_server >= 0)
+		close(non_vrf_server);
+	if (in_vrf_server >= 0)
+		close(in_vrf_server);
+	if (nstoken)
+		close_netns(nstoken);
+}
+
+void test_tc_socket_lookup(void)
+{
+	struct tc_socket_lookup *skel;
+
+	cleanup();
+
+	skel = tc_socket_lookup__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "tc_socket_lookup__open_and_load"))
+		return;
+
+	if (!ASSERT_OK(setup(skel), "setup"))
+		goto done;
+
+	if (test__start_subtest("tc_socket_lookup_tcp"))
+		_test_tc_socket_lookup(skel, SOCK_STREAM, false);
+	if (test__start_subtest("tc_socket_lookup_tcp_skc"))
+		_test_tc_socket_lookup(skel, SOCK_STREAM, true);
+	if (test__start_subtest("tc_socket_lookup_udp"))
+		_test_tc_socket_lookup(skel, SOCK_DGRAM, false);
+
+done:
+	tc_socket_lookup__destroy(skel);
+	cleanup();
+}
diff --git a/tools/testing/selftests/bpf/progs/tc_socket_lookup.c b/tools/testing/selftests/bpf/progs/tc_socket_lookup.c
new file mode 100644
index 000000000000..06601eb17807
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tc_socket_lookup.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/ip.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/pkt_cls.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <stdbool.h>
+
+int lookup_status;
+bool tcp_skc;
+
+#define CUR_NS BPF_F_CURRENT_NETNS
+
+SEC("tc")
+int test_socket_lookup(struct __sk_buff *skb)
+{
+	struct bpf_sock_tuple *tp;
+	void *data_end, *data;
+	struct bpf_sock *sk;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+	int tplen;
+
+	if (skb->protocol != bpf_htons(ETH_P_IP))
+		return TC_ACT_UNSPEC;
+
+	tplen = sizeof(tp->ipv4);
+
+	if (bpf_skb_pull_data(skb, sizeof(*eth) + sizeof(*iph) + tplen))
+		return TC_ACT_SHOT;
+
+	data_end = (void *)(long)skb->data_end;
+	data = (void *)(long)skb->data;
+
+	eth = data;
+	if (eth + 1 > data_end)
+		return TC_ACT_SHOT;
+
+	iph = (struct iphdr *)(eth + 1);
+	if (iph + 1 > data_end)
+		return TC_ACT_SHOT;
+
+	tp = (struct bpf_sock_tuple *)&iph->saddr;
+	if ((void *)tp + tplen > data_end)
+		return TC_ACT_SHOT;
+
+	switch (iph->protocol) {
+	case IPPROTO_TCP:
+		if (tcp_skc)
+			sk = bpf_skc_lookup_tcp(skb, tp, tplen, CUR_NS, 0);
+		else
+			sk = bpf_sk_lookup_tcp(skb, tp, tplen, CUR_NS, 0);
+		break;
+	case IPPROTO_UDP:
+		sk = bpf_sk_lookup_udp(skb, tp, tplen, CUR_NS, 0);
+		break;
+	default:
+		return TC_ACT_SHOT;
+	}
+
+	lookup_status = 0;
+
+	if (sk) {
+		bpf_sk_release(sk);
+		lookup_status = 1;
+	}
+
+	return TC_ACT_UNSPEC;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

