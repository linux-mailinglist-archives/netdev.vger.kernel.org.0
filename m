Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DD16A1685
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 07:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBXGOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 01:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjBXGOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 01:14:07 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC62D1E29D;
        Thu, 23 Feb 2023 22:14:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k21-20020a17090aaa1500b002376652e160so1690984pjq.0;
        Thu, 23 Feb 2023 22:14:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Epa0bC1v6Jyd8eaZtEgFri/fezN3ve0hokpk4kld/vM=;
        b=ghias2psSfDSsROoy+CdlgdkBL5BSbTj+LapiIBZfq+oXMRAwEMSbmI+6yqsvmfehx
         n0gT/fyATlh8+Evyx//pjp7idwYmNGPjyv3heykYg84RxHtnHwJKBf5pB0K6WdONjEuy
         zqoG0RhJSB0BxOVry5B2vsOsqGXZWifWWPufeHHzpjXj6qxycZg+tRMuAac6VXkeDbgd
         +wfwX088vDpTFL4kmyQJYG7WfQjMO4VUBu3twKPMhnbjSJwdFfxmtv+BENFxiLeedort
         EdLY8RDskWPp6qOUgi6ekmGD/PDpLTWEK6ZcJFt9rWhS7TJY+FipdFRj/9cr8hJ2n9oD
         aNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Epa0bC1v6Jyd8eaZtEgFri/fezN3ve0hokpk4kld/vM=;
        b=5cG8l/XuobpBWv+Qv0WaVNWPni3z1Ha2MOfY6ODdF2UwRI8GI82FdhzwC6VppH7BxG
         4DbufCm0HQAzPu5a8rmrCaGg5tYyEI8qB+o1PLfsIPnut1JkRtPYEZixKu2sc0dreEKz
         27Ij7nZNiUKF2k579NYfNWB2NynGfCTC+pjfPwsME+5UbxA4u5/8O4l4oww/HzrdswD2
         JEJVpCJyNTZrPJbxF9D6cuYNH0gSisCB/B7a9Q1SyLLGj8RG/JUuCvCOd9W7kHqmpd0w
         P0/MqAtP7i7IRdEummDfFI6olrQ9ySFpldfJeOWeY03i31NdqlW8ySNkdKZ15dsEr2vj
         ggPQ==
X-Gm-Message-State: AO0yUKUImJE7w/Cd4fFStrkIZV54Fj5vUmNXGyIDVpbqThR50dnbeDYz
        lXFyb2R+1qL7Qogg5iT2gZ6+jgxqOw8=
X-Google-Smtp-Source: AK7set9zYW5zjDh9Gt4dt9ZtHkjgUNey0AX79RPzr6jC+1gwSRHjlLjr/2LQlXu7+fcEpGw5VOFiHw==
X-Received: by 2002:a05:6a20:3d22:b0:bc:96bd:d701 with SMTP id y34-20020a056a203d2200b000bc96bdd701mr18417140pzi.13.1677219242143;
        Thu, 23 Feb 2023 22:14:02 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e24-20020aa78258000000b005afda149679sm2336071pfn.179.2023.02.23.22.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 22:14:01 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 bpf-next 1/2] selftests/bpf: move SYS() macro into the test_progs.h
Date:   Fri, 24 Feb 2023 14:13:42 +0800
Message-Id: <20230224061343.506571-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230224061343.506571-1-liuhangbin@gmail.com>
References: <20230224061343.506571-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of tests defined SYS() macro to run system calls with goto lable.
Let's move this macro to test_progs.h and add configurable
"goto_label" as the first arg.

Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/prog_tests/decap_sanity.c   |  16 +--
 .../selftests/bpf/prog_tests/empty_skb.c      |  25 ++---
 .../selftests/bpf/prog_tests/fib_lookup.c     |  28 ++---
 .../selftests/bpf/prog_tests/tc_redirect.c    | 100 ++++++++----------
 .../selftests/bpf/prog_tests/test_tunnel.c    |  71 +++++--------
 .../selftests/bpf/prog_tests/xdp_bonding.c    |  40 +++----
 .../bpf/prog_tests/xdp_do_redirect.c          |  30 ++----
 .../selftests/bpf/prog_tests/xdp_metadata.c   |  23 ++--
 .../selftests/bpf/prog_tests/xdp_synproxy.c   |  41 ++++---
 .../selftests/bpf/prog_tests/xfrm_info.c      |  67 +++++-------
 tools/testing/selftests/bpf/test_progs.h      |  15 +++
 11 files changed, 193 insertions(+), 263 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/decap_sanity.c b/tools/testing/selftests/bpf/prog_tests/decap_sanity.c
index 2853883b7cbb..5c0ebe6ba866 100644
--- a/tools/testing/selftests/bpf/prog_tests/decap_sanity.c
+++ b/tools/testing/selftests/bpf/prog_tests/decap_sanity.c
@@ -10,14 +10,6 @@
 #include "network_helpers.h"
 #include "decap_sanity.skel.h"
 
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			goto fail;				\
-	})
-
 #define NS_TEST "decap_sanity_ns"
 #define IPV6_IFACE_ADDR "face::1"
 #define UDP_TEST_PORT 7777
@@ -37,9 +29,9 @@ void test_decap_sanity(void)
 	if (!ASSERT_OK_PTR(skel, "skel open_and_load"))
 		return;
 
-	SYS("ip netns add %s", NS_TEST);
-	SYS("ip -net %s -6 addr add %s/128 dev lo nodad", NS_TEST, IPV6_IFACE_ADDR);
-	SYS("ip -net %s link set dev lo up", NS_TEST);
+	SYS(fail, "ip netns add %s", NS_TEST);
+	SYS(fail, "ip -net %s -6 addr add %s/128 dev lo nodad", NS_TEST, IPV6_IFACE_ADDR);
+	SYS(fail, "ip -net %s link set dev lo up", NS_TEST);
 
 	nstoken = open_netns(NS_TEST);
 	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
@@ -80,6 +72,6 @@ void test_decap_sanity(void)
 		bpf_tc_hook_destroy(&qdisc_hook);
 		close_netns(nstoken);
 	}
-	system("ip netns del " NS_TEST " &> /dev/null");
+	SYS_NOFAIL("ip netns del " NS_TEST " &> /dev/null");
 	decap_sanity__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
index 32dd731e9070..3b77d8a422db 100644
--- a/tools/testing/selftests/bpf/prog_tests/empty_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -4,11 +4,6 @@
 #include <net/if.h>
 #include "empty_skb.skel.h"
 
-#define SYS(cmd) ({ \
-	if (!ASSERT_OK(system(cmd), (cmd))) \
-		goto out; \
-})
-
 void test_empty_skb(void)
 {
 	LIBBPF_OPTS(bpf_test_run_opts, tattr);
@@ -93,18 +88,18 @@ void test_empty_skb(void)
 		},
 	};
 
-	SYS("ip netns add empty_skb");
+	SYS(out, "ip netns add empty_skb");
 	tok = open_netns("empty_skb");
-	SYS("ip link add veth0 type veth peer veth1");
-	SYS("ip link set dev veth0 up");
-	SYS("ip link set dev veth1 up");
-	SYS("ip addr add 10.0.0.1/8 dev veth0");
-	SYS("ip addr add 10.0.0.2/8 dev veth1");
+	SYS(out, "ip link add veth0 type veth peer veth1");
+	SYS(out, "ip link set dev veth0 up");
+	SYS(out, "ip link set dev veth1 up");
+	SYS(out, "ip addr add 10.0.0.1/8 dev veth0");
+	SYS(out, "ip addr add 10.0.0.2/8 dev veth1");
 	veth_ifindex = if_nametoindex("veth0");
 
-	SYS("ip link add ipip0 type ipip local 10.0.0.1 remote 10.0.0.2");
-	SYS("ip link set ipip0 up");
-	SYS("ip addr add 192.168.1.1/16 dev ipip0");
+	SYS(out, "ip link add ipip0 type ipip local 10.0.0.1 remote 10.0.0.2");
+	SYS(out, "ip link set ipip0 up");
+	SYS(out, "ip addr add 192.168.1.1/16 dev ipip0");
 	ipip_ifindex = if_nametoindex("ipip0");
 
 	bpf_obj = empty_skb__open_and_load();
@@ -142,5 +137,5 @@ void test_empty_skb(void)
 		empty_skb__destroy(bpf_obj);
 	if (tok)
 		close_netns(tok);
-	system("ip netns del empty_skb");
+	SYS_NOFAIL("ip netns del empty_skb");
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
index 61ccddccf485..429393caf612 100644
--- a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
@@ -8,14 +8,6 @@
 #include "network_helpers.h"
 #include "fib_lookup.skel.h"
 
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			goto fail;				\
-	})
-
 #define NS_TEST			"fib_lookup_ns"
 #define IPV6_IFACE_ADDR		"face::face"
 #define IPV6_NUD_FAILED_ADDR	"face::1"
@@ -59,16 +51,16 @@ static int setup_netns(void)
 {
 	int err;
 
-	SYS("ip link add veth1 type veth peer name veth2");
-	SYS("ip link set dev veth1 up");
+	SYS(fail, "ip link add veth1 type veth peer name veth2");
+	SYS(fail, "ip link set dev veth1 up");
 
-	SYS("ip addr add %s/64 dev veth1 nodad", IPV6_IFACE_ADDR);
-	SYS("ip neigh add %s dev veth1 nud failed", IPV6_NUD_FAILED_ADDR);
-	SYS("ip neigh add %s dev veth1 lladdr %s nud stale", IPV6_NUD_STALE_ADDR, DMAC);
+	SYS(fail, "ip addr add %s/64 dev veth1 nodad", IPV6_IFACE_ADDR);
+	SYS(fail, "ip neigh add %s dev veth1 nud failed", IPV6_NUD_FAILED_ADDR);
+	SYS(fail, "ip neigh add %s dev veth1 lladdr %s nud stale", IPV6_NUD_STALE_ADDR, DMAC);
 
-	SYS("ip addr add %s/24 dev veth1 nodad", IPV4_IFACE_ADDR);
-	SYS("ip neigh add %s dev veth1 nud failed", IPV4_NUD_FAILED_ADDR);
-	SYS("ip neigh add %s dev veth1 lladdr %s nud stale", IPV4_NUD_STALE_ADDR, DMAC);
+	SYS(fail, "ip addr add %s/24 dev veth1 nodad", IPV4_IFACE_ADDR);
+	SYS(fail, "ip neigh add %s dev veth1 nud failed", IPV4_NUD_FAILED_ADDR);
+	SYS(fail, "ip neigh add %s dev veth1 lladdr %s nud stale", IPV4_NUD_STALE_ADDR, DMAC);
 
 	err = write_sysctl("/proc/sys/net/ipv4/conf/veth1/forwarding", "1");
 	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.conf.veth1.forwarding)"))
@@ -140,7 +132,7 @@ void test_fib_lookup(void)
 		return;
 	prog_fd = bpf_program__fd(skel->progs.fib_lookup);
 
-	SYS("ip netns add %s", NS_TEST);
+	SYS(fail, "ip netns add %s", NS_TEST);
 
 	nstoken = open_netns(NS_TEST);
 	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
@@ -182,6 +174,6 @@ void test_fib_lookup(void)
 fail:
 	if (nstoken)
 		close_netns(nstoken);
-	system("ip netns del " NS_TEST " &> /dev/null");
+	SYS_NOFAIL("ip netns del " NS_TEST " &> /dev/null");
 	fib_lookup__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
index bca5e6839ac4..6ee22c3b251a 100644
--- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
@@ -137,24 +137,16 @@ static int get_ifaddr(const char *name, char *ifaddr)
 	return 0;
 }
 
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			goto fail;				\
-	})
-
 static int netns_setup_links_and_routes(struct netns_setup_result *result)
 {
 	struct nstoken *nstoken = NULL;
 	char veth_src_fwd_addr[IFADDR_STR_LEN+1] = {};
 
-	SYS("ip link add veth_src type veth peer name veth_src_fwd");
-	SYS("ip link add veth_dst type veth peer name veth_dst_fwd");
+	SYS(fail, "ip link add veth_src type veth peer name veth_src_fwd");
+	SYS(fail, "ip link add veth_dst type veth peer name veth_dst_fwd");
 
-	SYS("ip link set veth_dst_fwd address " MAC_DST_FWD);
-	SYS("ip link set veth_dst address " MAC_DST);
+	SYS(fail, "ip link set veth_dst_fwd address " MAC_DST_FWD);
+	SYS(fail, "ip link set veth_dst address " MAC_DST);
 
 	if (get_ifaddr("veth_src_fwd", veth_src_fwd_addr))
 		goto fail;
@@ -175,27 +167,27 @@ static int netns_setup_links_and_routes(struct netns_setup_result *result)
 	if (!ASSERT_GT(result->ifindex_veth_dst_fwd, 0, "ifindex_veth_dst_fwd"))
 		goto fail;
 
-	SYS("ip link set veth_src netns " NS_SRC);
-	SYS("ip link set veth_src_fwd netns " NS_FWD);
-	SYS("ip link set veth_dst_fwd netns " NS_FWD);
-	SYS("ip link set veth_dst netns " NS_DST);
+	SYS(fail, "ip link set veth_src netns " NS_SRC);
+	SYS(fail, "ip link set veth_src_fwd netns " NS_FWD);
+	SYS(fail, "ip link set veth_dst_fwd netns " NS_FWD);
+	SYS(fail, "ip link set veth_dst netns " NS_DST);
 
 	/** setup in 'src' namespace */
 	nstoken = open_netns(NS_SRC);
 	if (!ASSERT_OK_PTR(nstoken, "setns src"))
 		goto fail;
 
-	SYS("ip addr add " IP4_SRC "/32 dev veth_src");
-	SYS("ip addr add " IP6_SRC "/128 dev veth_src nodad");
-	SYS("ip link set dev veth_src up");
+	SYS(fail, "ip addr add " IP4_SRC "/32 dev veth_src");
+	SYS(fail, "ip addr add " IP6_SRC "/128 dev veth_src nodad");
+	SYS(fail, "ip link set dev veth_src up");
 
-	SYS("ip route add " IP4_DST "/32 dev veth_src scope global");
-	SYS("ip route add " IP4_NET "/16 dev veth_src scope global");
-	SYS("ip route add " IP6_DST "/128 dev veth_src scope global");
+	SYS(fail, "ip route add " IP4_DST "/32 dev veth_src scope global");
+	SYS(fail, "ip route add " IP4_NET "/16 dev veth_src scope global");
+	SYS(fail, "ip route add " IP6_DST "/128 dev veth_src scope global");
 
-	SYS("ip neigh add " IP4_DST " dev veth_src lladdr %s",
+	SYS(fail, "ip neigh add " IP4_DST " dev veth_src lladdr %s",
 	    veth_src_fwd_addr);
-	SYS("ip neigh add " IP6_DST " dev veth_src lladdr %s",
+	SYS(fail, "ip neigh add " IP6_DST " dev veth_src lladdr %s",
 	    veth_src_fwd_addr);
 
 	close_netns(nstoken);
@@ -209,15 +201,15 @@ static int netns_setup_links_and_routes(struct netns_setup_result *result)
 	 * needs v4 one in order to start ARP probing. IP4_NET route is added
 	 * to the endpoints so that the ARP processing will reply.
 	 */
-	SYS("ip addr add " IP4_SLL "/32 dev veth_src_fwd");
-	SYS("ip addr add " IP4_DLL "/32 dev veth_dst_fwd");
-	SYS("ip link set dev veth_src_fwd up");
-	SYS("ip link set dev veth_dst_fwd up");
+	SYS(fail, "ip addr add " IP4_SLL "/32 dev veth_src_fwd");
+	SYS(fail, "ip addr add " IP4_DLL "/32 dev veth_dst_fwd");
+	SYS(fail, "ip link set dev veth_src_fwd up");
+	SYS(fail, "ip link set dev veth_dst_fwd up");
 
-	SYS("ip route add " IP4_SRC "/32 dev veth_src_fwd scope global");
-	SYS("ip route add " IP6_SRC "/128 dev veth_src_fwd scope global");
-	SYS("ip route add " IP4_DST "/32 dev veth_dst_fwd scope global");
-	SYS("ip route add " IP6_DST "/128 dev veth_dst_fwd scope global");
+	SYS(fail, "ip route add " IP4_SRC "/32 dev veth_src_fwd scope global");
+	SYS(fail, "ip route add " IP6_SRC "/128 dev veth_src_fwd scope global");
+	SYS(fail, "ip route add " IP4_DST "/32 dev veth_dst_fwd scope global");
+	SYS(fail, "ip route add " IP6_DST "/128 dev veth_dst_fwd scope global");
 
 	close_netns(nstoken);
 
@@ -226,16 +218,16 @@ static int netns_setup_links_and_routes(struct netns_setup_result *result)
 	if (!ASSERT_OK_PTR(nstoken, "setns dst"))
 		goto fail;
 
-	SYS("ip addr add " IP4_DST "/32 dev veth_dst");
-	SYS("ip addr add " IP6_DST "/128 dev veth_dst nodad");
-	SYS("ip link set dev veth_dst up");
+	SYS(fail, "ip addr add " IP4_DST "/32 dev veth_dst");
+	SYS(fail, "ip addr add " IP6_DST "/128 dev veth_dst nodad");
+	SYS(fail, "ip link set dev veth_dst up");
 
-	SYS("ip route add " IP4_SRC "/32 dev veth_dst scope global");
-	SYS("ip route add " IP4_NET "/16 dev veth_dst scope global");
-	SYS("ip route add " IP6_SRC "/128 dev veth_dst scope global");
+	SYS(fail, "ip route add " IP4_SRC "/32 dev veth_dst scope global");
+	SYS(fail, "ip route add " IP4_NET "/16 dev veth_dst scope global");
+	SYS(fail, "ip route add " IP6_SRC "/128 dev veth_dst scope global");
 
-	SYS("ip neigh add " IP4_SRC " dev veth_dst lladdr " MAC_DST_FWD);
-	SYS("ip neigh add " IP6_SRC " dev veth_dst lladdr " MAC_DST_FWD);
+	SYS(fail, "ip neigh add " IP4_SRC " dev veth_dst lladdr " MAC_DST_FWD);
+	SYS(fail, "ip neigh add " IP6_SRC " dev veth_dst lladdr " MAC_DST_FWD);
 
 	close_netns(nstoken);
 
@@ -375,7 +367,7 @@ static void test_tcp(int family, const char *addr, __u16 port)
 
 static int test_ping(int family, const char *addr)
 {
-	SYS("ip netns exec " NS_SRC " %s " PING_ARGS " %s > /dev/null", ping_command(family), addr);
+	SYS(fail, "ip netns exec " NS_SRC " %s " PING_ARGS " %s > /dev/null", ping_command(family), addr);
 	return 0;
 fail:
 	return -1;
@@ -953,7 +945,7 @@ static int tun_open(char *name)
 	if (!ASSERT_OK(err, "ioctl TUNSETIFF"))
 		goto fail;
 
-	SYS("ip link set dev %s up", name);
+	SYS(fail, "ip link set dev %s up", name);
 
 	return fd;
 fail:
@@ -1076,23 +1068,23 @@ static void test_tc_redirect_peer_l3(struct netns_setup_result *setup_result)
 	XGRESS_FILTER_ADD(&qdisc_veth_dst_fwd, BPF_TC_EGRESS, skel->progs.tc_chk, 0);
 
 	/* Setup route and neigh tables */
-	SYS("ip -netns " NS_SRC " addr add dev tun_src " IP4_TUN_SRC "/24");
-	SYS("ip -netns " NS_FWD " addr add dev tun_fwd " IP4_TUN_FWD "/24");
+	SYS(fail, "ip -netns " NS_SRC " addr add dev tun_src " IP4_TUN_SRC "/24");
+	SYS(fail, "ip -netns " NS_FWD " addr add dev tun_fwd " IP4_TUN_FWD "/24");
 
-	SYS("ip -netns " NS_SRC " addr add dev tun_src " IP6_TUN_SRC "/64 nodad");
-	SYS("ip -netns " NS_FWD " addr add dev tun_fwd " IP6_TUN_FWD "/64 nodad");
+	SYS(fail, "ip -netns " NS_SRC " addr add dev tun_src " IP6_TUN_SRC "/64 nodad");
+	SYS(fail, "ip -netns " NS_FWD " addr add dev tun_fwd " IP6_TUN_FWD "/64 nodad");
 
-	SYS("ip -netns " NS_SRC " route del " IP4_DST "/32 dev veth_src scope global");
-	SYS("ip -netns " NS_SRC " route add " IP4_DST "/32 via " IP4_TUN_FWD
+	SYS(fail, "ip -netns " NS_SRC " route del " IP4_DST "/32 dev veth_src scope global");
+	SYS(fail, "ip -netns " NS_SRC " route add " IP4_DST "/32 via " IP4_TUN_FWD
 	    " dev tun_src scope global");
-	SYS("ip -netns " NS_DST " route add " IP4_TUN_SRC "/32 dev veth_dst scope global");
-	SYS("ip -netns " NS_SRC " route del " IP6_DST "/128 dev veth_src scope global");
-	SYS("ip -netns " NS_SRC " route add " IP6_DST "/128 via " IP6_TUN_FWD
+	SYS(fail, "ip -netns " NS_DST " route add " IP4_TUN_SRC "/32 dev veth_dst scope global");
+	SYS(fail, "ip -netns " NS_SRC " route del " IP6_DST "/128 dev veth_src scope global");
+	SYS(fail, "ip -netns " NS_SRC " route add " IP6_DST "/128 via " IP6_TUN_FWD
 	    " dev tun_src scope global");
-	SYS("ip -netns " NS_DST " route add " IP6_TUN_SRC "/128 dev veth_dst scope global");
+	SYS(fail, "ip -netns " NS_DST " route add " IP6_TUN_SRC "/128 dev veth_dst scope global");
 
-	SYS("ip -netns " NS_DST " neigh add " IP4_TUN_SRC " dev veth_dst lladdr " MAC_DST_FWD);
-	SYS("ip -netns " NS_DST " neigh add " IP6_TUN_SRC " dev veth_dst lladdr " MAC_DST_FWD);
+	SYS(fail, "ip -netns " NS_DST " neigh add " IP4_TUN_SRC " dev veth_dst lladdr " MAC_DST_FWD);
+	SYS(fail, "ip -netns " NS_DST " neigh add " IP6_TUN_SRC " dev veth_dst lladdr " MAC_DST_FWD);
 
 	if (!ASSERT_OK(set_forwarding(false), "disable forwarding"))
 		goto fail;
diff --git a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
index 07ad457f3370..47f1d482fe39 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -91,30 +91,15 @@
 
 #define PING_ARGS "-i 0.01 -c 3 -w 10 -q"
 
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			goto fail;				\
-	})
-
-#define SYS_NOFAIL(fmt, ...)					\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		system(cmd);					\
-	})
-
 static int config_device(void)
 {
-	SYS("ip netns add at_ns0");
-	SYS("ip link add veth0 address " MAC_VETH1 " type veth peer name veth1");
-	SYS("ip link set veth0 netns at_ns0");
-	SYS("ip addr add " IP4_ADDR1_VETH1 "/24 dev veth1");
-	SYS("ip link set dev veth1 up mtu 1500");
-	SYS("ip netns exec at_ns0 ip addr add " IP4_ADDR_VETH0 "/24 dev veth0");
-	SYS("ip netns exec at_ns0 ip link set dev veth0 up mtu 1500");
+	SYS(fail, "ip netns add at_ns0");
+	SYS(fail, "ip link add veth0 address " MAC_VETH1 " type veth peer name veth1");
+	SYS(fail, "ip link set veth0 netns at_ns0");
+	SYS(fail, "ip addr add " IP4_ADDR1_VETH1 "/24 dev veth1");
+	SYS(fail, "ip link set dev veth1 up mtu 1500");
+	SYS(fail, "ip netns exec at_ns0 ip addr add " IP4_ADDR_VETH0 "/24 dev veth0");
+	SYS(fail, "ip netns exec at_ns0 ip link set dev veth0 up mtu 1500");
 
 	return 0;
 fail:
@@ -132,23 +117,23 @@ static void cleanup(void)
 static int add_vxlan_tunnel(void)
 {
 	/* at_ns0 namespace */
-	SYS("ip netns exec at_ns0 ip link add dev %s type vxlan external gbp dstport 4789",
+	SYS(fail, "ip netns exec at_ns0 ip link add dev %s type vxlan external gbp dstport 4789",
 	    VXLAN_TUNL_DEV0);
-	SYS("ip netns exec at_ns0 ip link set dev %s address %s up",
+	SYS(fail, "ip netns exec at_ns0 ip link set dev %s address %s up",
 	    VXLAN_TUNL_DEV0, MAC_TUNL_DEV0);
-	SYS("ip netns exec at_ns0 ip addr add dev %s %s/24",
+	SYS(fail, "ip netns exec at_ns0 ip addr add dev %s %s/24",
 	    VXLAN_TUNL_DEV0, IP4_ADDR_TUNL_DEV0);
-	SYS("ip netns exec at_ns0 ip neigh add %s lladdr %s dev %s",
+	SYS(fail, "ip netns exec at_ns0 ip neigh add %s lladdr %s dev %s",
 	    IP4_ADDR_TUNL_DEV1, MAC_TUNL_DEV1, VXLAN_TUNL_DEV0);
-	SYS("ip netns exec at_ns0 ip neigh add %s lladdr %s dev veth0",
+	SYS(fail, "ip netns exec at_ns0 ip neigh add %s lladdr %s dev veth0",
 	    IP4_ADDR2_VETH1, MAC_VETH1);
 
 	/* root namespace */
-	SYS("ip link add dev %s type vxlan external gbp dstport 4789",
+	SYS(fail, "ip link add dev %s type vxlan external gbp dstport 4789",
 	    VXLAN_TUNL_DEV1);
-	SYS("ip link set dev %s address %s up", VXLAN_TUNL_DEV1, MAC_TUNL_DEV1);
-	SYS("ip addr add dev %s %s/24", VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
-	SYS("ip neigh add %s lladdr %s dev %s",
+	SYS(fail, "ip link set dev %s address %s up", VXLAN_TUNL_DEV1, MAC_TUNL_DEV1);
+	SYS(fail, "ip addr add dev %s %s/24", VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
+	SYS(fail, "ip neigh add %s lladdr %s dev %s",
 	    IP4_ADDR_TUNL_DEV0, MAC_TUNL_DEV0, VXLAN_TUNL_DEV1);
 
 	return 0;
@@ -165,26 +150,26 @@ static void delete_vxlan_tunnel(void)
 
 static int add_ip6vxlan_tunnel(void)
 {
-	SYS("ip netns exec at_ns0 ip -6 addr add %s/96 dev veth0",
+	SYS(fail, "ip netns exec at_ns0 ip -6 addr add %s/96 dev veth0",
 	    IP6_ADDR_VETH0);
-	SYS("ip netns exec at_ns0 ip link set dev veth0 up");
-	SYS("ip -6 addr add %s/96 dev veth1", IP6_ADDR1_VETH1);
-	SYS("ip -6 addr add %s/96 dev veth1", IP6_ADDR2_VETH1);
-	SYS("ip link set dev veth1 up");
+	SYS(fail, "ip netns exec at_ns0 ip link set dev veth0 up");
+	SYS(fail, "ip -6 addr add %s/96 dev veth1", IP6_ADDR1_VETH1);
+	SYS(fail, "ip -6 addr add %s/96 dev veth1", IP6_ADDR2_VETH1);
+	SYS(fail, "ip link set dev veth1 up");
 
 	/* at_ns0 namespace */
-	SYS("ip netns exec at_ns0 ip link add dev %s type vxlan external dstport 4789",
+	SYS(fail, "ip netns exec at_ns0 ip link add dev %s type vxlan external dstport 4789",
 	    IP6VXLAN_TUNL_DEV0);
-	SYS("ip netns exec at_ns0 ip addr add dev %s %s/24",
+	SYS(fail, "ip netns exec at_ns0 ip addr add dev %s %s/24",
 	    IP6VXLAN_TUNL_DEV0, IP4_ADDR_TUNL_DEV0);
-	SYS("ip netns exec at_ns0 ip link set dev %s address %s up",
+	SYS(fail, "ip netns exec at_ns0 ip link set dev %s address %s up",
 	    IP6VXLAN_TUNL_DEV0, MAC_TUNL_DEV0);
 
 	/* root namespace */
-	SYS("ip link add dev %s type vxlan external dstport 4789",
+	SYS(fail, "ip link add dev %s type vxlan external dstport 4789",
 	    IP6VXLAN_TUNL_DEV1);
-	SYS("ip addr add dev %s %s/24", IP6VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
-	SYS("ip link set dev %s address %s up",
+	SYS(fail, "ip addr add dev %s %s/24", IP6VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
+	SYS(fail, "ip link set dev %s address %s up",
 	    IP6VXLAN_TUNL_DEV1, MAC_TUNL_DEV1);
 
 	return 0;
@@ -205,7 +190,7 @@ static void delete_ip6vxlan_tunnel(void)
 
 static int test_ping(int family, const char *addr)
 {
-	SYS("%s %s %s > /dev/null", ping_command(family), PING_ARGS, addr);
+	SYS(fail, "%s %s %s > /dev/null", ping_command(family), PING_ARGS, addr);
 	return 0;
 fail:
 	return -1;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
index 5e3a26b15ec6..d19f79048ff6 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
@@ -141,41 +141,33 @@ static const char * const xmit_policy_names[] = {
 static int bonding_setup(struct skeletons *skeletons, int mode, int xmit_policy,
 			 int bond_both_attach)
 {
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			return -1;				\
-	})
-
-	SYS("ip netns add ns_dst");
-	SYS("ip link add veth1_1 type veth peer name veth2_1 netns ns_dst");
-	SYS("ip link add veth1_2 type veth peer name veth2_2 netns ns_dst");
-
-	SYS("ip link add bond1 type bond mode %s xmit_hash_policy %s",
+	SYS(fail, "ip netns add ns_dst");
+	SYS(fail, "ip link add veth1_1 type veth peer name veth2_1 netns ns_dst");
+	SYS(fail, "ip link add veth1_2 type veth peer name veth2_2 netns ns_dst");
+
+	SYS(fail, "ip link add bond1 type bond mode %s xmit_hash_policy %s",
 	    mode_names[mode], xmit_policy_names[xmit_policy]);
-	SYS("ip link set bond1 up address " BOND1_MAC_STR " addrgenmode none");
-	SYS("ip -netns ns_dst link add bond2 type bond mode %s xmit_hash_policy %s",
+	SYS(fail, "ip link set bond1 up address " BOND1_MAC_STR " addrgenmode none");
+	SYS(fail, "ip -netns ns_dst link add bond2 type bond mode %s xmit_hash_policy %s",
 	    mode_names[mode], xmit_policy_names[xmit_policy]);
-	SYS("ip -netns ns_dst link set bond2 up address " BOND2_MAC_STR " addrgenmode none");
+	SYS(fail, "ip -netns ns_dst link set bond2 up address " BOND2_MAC_STR " addrgenmode none");
 
-	SYS("ip link set veth1_1 master bond1");
+	SYS(fail, "ip link set veth1_1 master bond1");
 	if (bond_both_attach == BOND_BOTH_AND_ATTACH) {
-		SYS("ip link set veth1_2 master bond1");
+		SYS(fail, "ip link set veth1_2 master bond1");
 	} else {
-		SYS("ip link set veth1_2 up addrgenmode none");
+		SYS(fail, "ip link set veth1_2 up addrgenmode none");
 
 		if (xdp_attach(skeletons, skeletons->xdp_dummy->progs.xdp_dummy_prog, "veth1_2"))
 			return -1;
 	}
 
-	SYS("ip -netns ns_dst link set veth2_1 master bond2");
+	SYS(fail, "ip -netns ns_dst link set veth2_1 master bond2");
 
 	if (bond_both_attach == BOND_BOTH_AND_ATTACH)
-		SYS("ip -netns ns_dst link set veth2_2 master bond2");
+		SYS(fail, "ip -netns ns_dst link set veth2_2 master bond2");
 	else
-		SYS("ip -netns ns_dst link set veth2_2 up addrgenmode none");
+		SYS(fail, "ip -netns ns_dst link set veth2_2 up addrgenmode none");
 
 	/* Load a dummy program on sending side as with veth peer needs to have a
 	 * XDP program loaded as well.
@@ -194,8 +186,8 @@ static int bonding_setup(struct skeletons *skeletons, int mode, int xmit_policy,
 	}
 
 	return 0;
-
-#undef SYS
+fail:
+	return -1;
 }
 
 static void bonding_cleanup(struct skeletons *skeletons)
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index 2666c84dbd01..856cbc29e6a1 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -12,14 +12,6 @@
 #include <uapi/linux/netdev.h>
 #include "test_xdp_do_redirect.skel.h"
 
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			goto out;				\
-	})
-
 struct udp_packet {
 	struct ethhdr eth;
 	struct ipv6hdr iph;
@@ -126,19 +118,19 @@ void test_xdp_do_redirect(void)
 	 * iface and NUM_PKTS-2 in the TC hook. We match the packets on the UDP
 	 * payload.
 	 */
-	SYS("ip netns add testns");
+	SYS(out, "ip netns add testns");
 	nstoken = open_netns("testns");
 	if (!ASSERT_OK_PTR(nstoken, "setns"))
 		goto out;
 
-	SYS("ip link add veth_src type veth peer name veth_dst");
-	SYS("ip link set dev veth_src address 00:11:22:33:44:55");
-	SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
-	SYS("ip link set dev veth_src up");
-	SYS("ip link set dev veth_dst up");
-	SYS("ip addr add dev veth_src fc00::1/64");
-	SYS("ip addr add dev veth_dst fc00::2/64");
-	SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb");
+	SYS(out, "ip link add veth_src type veth peer name veth_dst");
+	SYS(out, "ip link set dev veth_src address 00:11:22:33:44:55");
+	SYS(out, "ip link set dev veth_dst address 66:77:88:99:aa:bb");
+	SYS(out, "ip link set dev veth_src up");
+	SYS(out, "ip link set dev veth_dst up");
+	SYS(out, "ip addr add dev veth_src fc00::1/64");
+	SYS(out, "ip addr add dev veth_dst fc00::2/64");
+	SYS(out, "ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb");
 
 	/* We enable forwarding in the test namespace because that will cause
 	 * the packets that go through the kernel stack (with XDP_PASS) to be
@@ -151,7 +143,7 @@ void test_xdp_do_redirect(void)
 	 * code didn't have this, so we keep the test behaviour to make sure the
 	 * bug doesn't resurface.
 	 */
-	SYS("sysctl -qw net.ipv6.conf.all.forwarding=1");
+	SYS(out, "sysctl -qw net.ipv6.conf.all.forwarding=1");
 
 	ifindex_src = if_nametoindex("veth_src");
 	ifindex_dst = if_nametoindex("veth_dst");
@@ -225,6 +217,6 @@ void test_xdp_do_redirect(void)
 out:
 	if (nstoken)
 		close_netns(nstoken);
-	system("ip netns del testns");
+	SYS_NOFAIL("ip netns del testns");
 	test_xdp_do_redirect__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index aa4beae99f4f..490e851dc27d 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -34,11 +34,6 @@
 #define PREFIX_LEN "8"
 #define FAMILY AF_INET
 
-#define SYS(cmd) ({ \
-	if (!ASSERT_OK(system(cmd), (cmd))) \
-		goto out; \
-})
-
 struct xsk {
 	void *umem_area;
 	struct xsk_umem *umem;
@@ -298,16 +293,16 @@ void test_xdp_metadata(void)
 
 	/* Setup new networking namespace, with a veth pair. */
 
-	SYS("ip netns add xdp_metadata");
+	SYS(out, "ip netns add xdp_metadata");
 	tok = open_netns("xdp_metadata");
-	SYS("ip link add numtxqueues 1 numrxqueues 1 " TX_NAME
+	SYS(out, "ip link add numtxqueues 1 numrxqueues 1 " TX_NAME
 	    " type veth peer " RX_NAME " numtxqueues 1 numrxqueues 1");
-	SYS("ip link set dev " TX_NAME " address 00:00:00:00:00:01");
-	SYS("ip link set dev " RX_NAME " address 00:00:00:00:00:02");
-	SYS("ip link set dev " TX_NAME " up");
-	SYS("ip link set dev " RX_NAME " up");
-	SYS("ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
-	SYS("ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
+	SYS(out, "ip link set dev " TX_NAME " address 00:00:00:00:00:01");
+	SYS(out, "ip link set dev " RX_NAME " address 00:00:00:00:00:02");
+	SYS(out, "ip link set dev " TX_NAME " up");
+	SYS(out, "ip link set dev " RX_NAME " up");
+	SYS(out, "ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
+	SYS(out, "ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
 
 	rx_ifindex = if_nametoindex(RX_NAME);
 	tx_ifindex = if_nametoindex(TX_NAME);
@@ -405,5 +400,5 @@ void test_xdp_metadata(void)
 	xdp_metadata__destroy(bpf_obj);
 	if (tok)
 		close_netns(tok);
-	system("ip netns del xdp_metadata");
+	SYS_NOFAIL("ip netns del xdp_metadata");
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
index c72083885b6d..8b50a992d233 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
@@ -8,11 +8,6 @@
 
 #define CMD_OUT_BUF_SIZE 1023
 
-#define SYS(cmd) ({ \
-	if (!ASSERT_OK(system(cmd), (cmd))) \
-		goto out; \
-})
-
 #define SYS_OUT(cmd, ...) ({ \
 	char buf[1024]; \
 	snprintf(buf, sizeof(buf), (cmd), ##__VA_ARGS__); \
@@ -69,37 +64,37 @@ static void test_synproxy(bool xdp)
 	char buf[CMD_OUT_BUF_SIZE];
 	size_t size;
 
-	SYS("ip netns add synproxy");
+	SYS(out, "ip netns add synproxy");
 
-	SYS("ip link add tmp0 type veth peer name tmp1");
-	SYS("ip link set tmp1 netns synproxy");
-	SYS("ip link set tmp0 up");
-	SYS("ip addr replace 198.18.0.1/24 dev tmp0");
+	SYS(out, "ip link add tmp0 type veth peer name tmp1");
+	SYS(out, "ip link set tmp1 netns synproxy");
+	SYS(out, "ip link set tmp0 up");
+	SYS(out, "ip addr replace 198.18.0.1/24 dev tmp0");
 
 	/* When checksum offload is enabled, the XDP program sees wrong
 	 * checksums and drops packets.
 	 */
-	SYS("ethtool -K tmp0 tx off");
+	SYS(out, "ethtool -K tmp0 tx off");
 	if (xdp)
 		/* Workaround required for veth. */
-		SYS("ip link set tmp0 xdp object xdp_dummy.bpf.o section xdp 2> /dev/null");
+		SYS(out, "ip link set tmp0 xdp object xdp_dummy.bpf.o section xdp 2> /dev/null");
 
 	ns = open_netns("synproxy");
 	if (!ASSERT_OK_PTR(ns, "setns"))
 		goto out;
 
-	SYS("ip link set lo up");
-	SYS("ip link set tmp1 up");
-	SYS("ip addr replace 198.18.0.2/24 dev tmp1");
-	SYS("sysctl -w net.ipv4.tcp_syncookies=2");
-	SYS("sysctl -w net.ipv4.tcp_timestamps=1");
-	SYS("sysctl -w net.netfilter.nf_conntrack_tcp_loose=0");
-	SYS("iptables-legacy -t raw -I PREROUTING \
+	SYS(out, "ip link set lo up");
+	SYS(out, "ip link set tmp1 up");
+	SYS(out, "ip addr replace 198.18.0.2/24 dev tmp1");
+	SYS(out, "sysctl -w net.ipv4.tcp_syncookies=2");
+	SYS(out, "sysctl -w net.ipv4.tcp_timestamps=1");
+	SYS(out, "sysctl -w net.netfilter.nf_conntrack_tcp_loose=0");
+	SYS(out, "iptables-legacy -t raw -I PREROUTING \
 	    -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
-	SYS("iptables-legacy -t filter -A INPUT \
+	SYS(out, "iptables-legacy -t filter -A INPUT \
 	    -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
 	    -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
-	SYS("iptables-legacy -t filter -A INPUT \
+	SYS(out, "iptables-legacy -t filter -A INPUT \
 	    -i tmp1 -m state --state INVALID -j DROP");
 
 	ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 \
@@ -170,8 +165,8 @@ static void test_synproxy(bool xdp)
 	if (ns)
 		close_netns(ns);
 
-	system("ip link del tmp0");
-	system("ip netns del synproxy");
+	SYS_NOFAIL("ip link del tmp0");
+	SYS_NOFAIL("ip netns del synproxy");
 }
 
 void test_xdp_synproxy(void)
diff --git a/tools/testing/selftests/bpf/prog_tests/xfrm_info.c b/tools/testing/selftests/bpf/prog_tests/xfrm_info.c
index 8b03c9bb4862..d37f5394e199 100644
--- a/tools/testing/selftests/bpf/prog_tests/xfrm_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/xfrm_info.c
@@ -69,21 +69,6 @@
     "proto esp aead 'rfc4106(gcm(aes))' " \
     "0xe4d8f4b4da1df18a3510b3781496daa82488b713 128 mode tunnel "
 
-#define SYS(fmt, ...)						\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		if (!ASSERT_OK(system(cmd), cmd))		\
-			goto fail;				\
-	})
-
-#define SYS_NOFAIL(fmt, ...)					\
-	({							\
-		char cmd[1024];					\
-		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
-		system(cmd);					\
-	})
-
 static int attach_tc_prog(struct bpf_tc_hook *hook, int igr_fd, int egr_fd)
 {
 	LIBBPF_OPTS(bpf_tc_opts, opts1, .handle = 1, .priority = 1,
@@ -126,23 +111,23 @@ static void cleanup(void)
 
 static int config_underlay(void)
 {
-	SYS("ip netns add " NS0);
-	SYS("ip netns add " NS1);
-	SYS("ip netns add " NS2);
+	SYS(fail, "ip netns add " NS0);
+	SYS(fail, "ip netns add " NS1);
+	SYS(fail, "ip netns add " NS2);
 
 	/* NS0 <-> NS1 [veth01 <-> veth10] */
-	SYS("ip link add veth01 netns " NS0 " type veth peer name veth10 netns " NS1);
-	SYS("ip -net " NS0 " addr add " IP4_ADDR_VETH01 "/24 dev veth01");
-	SYS("ip -net " NS0 " link set dev veth01 up");
-	SYS("ip -net " NS1 " addr add " IP4_ADDR_VETH10 "/24 dev veth10");
-	SYS("ip -net " NS1 " link set dev veth10 up");
+	SYS(fail, "ip link add veth01 netns " NS0 " type veth peer name veth10 netns " NS1);
+	SYS(fail, "ip -net " NS0 " addr add " IP4_ADDR_VETH01 "/24 dev veth01");
+	SYS(fail, "ip -net " NS0 " link set dev veth01 up");
+	SYS(fail, "ip -net " NS1 " addr add " IP4_ADDR_VETH10 "/24 dev veth10");
+	SYS(fail, "ip -net " NS1 " link set dev veth10 up");
 
 	/* NS0 <-> NS2 [veth02 <-> veth20] */
-	SYS("ip link add veth02 netns " NS0 " type veth peer name veth20 netns " NS2);
-	SYS("ip -net " NS0 " addr add " IP4_ADDR_VETH02 "/24 dev veth02");
-	SYS("ip -net " NS0 " link set dev veth02 up");
-	SYS("ip -net " NS2 " addr add " IP4_ADDR_VETH20 "/24 dev veth20");
-	SYS("ip -net " NS2 " link set dev veth20 up");
+	SYS(fail, "ip link add veth02 netns " NS0 " type veth peer name veth20 netns " NS2);
+	SYS(fail, "ip -net " NS0 " addr add " IP4_ADDR_VETH02 "/24 dev veth02");
+	SYS(fail, "ip -net " NS0 " link set dev veth02 up");
+	SYS(fail, "ip -net " NS2 " addr add " IP4_ADDR_VETH20 "/24 dev veth20");
+	SYS(fail, "ip -net " NS2 " link set dev veth20 up");
 
 	return 0;
 fail:
@@ -153,20 +138,20 @@ static int setup_xfrm_tunnel_ns(const char *ns, const char *ipv4_local,
 				const char *ipv4_remote, int if_id)
 {
 	/* State: local -> remote */
-	SYS("ip -net %s xfrm state add src %s dst %s spi 1 "
+	SYS(fail, "ip -net %s xfrm state add src %s dst %s spi 1 "
 	    ESP_DUMMY_PARAMS "if_id %d", ns, ipv4_local, ipv4_remote, if_id);
 
 	/* State: local <- remote */
-	SYS("ip -net %s xfrm state add src %s dst %s spi 1 "
+	SYS(fail, "ip -net %s xfrm state add src %s dst %s spi 1 "
 	    ESP_DUMMY_PARAMS "if_id %d", ns, ipv4_remote, ipv4_local, if_id);
 
 	/* Policy: local -> remote */
-	SYS("ip -net %s xfrm policy add dir out src 0.0.0.0/0 dst 0.0.0.0/0 "
+	SYS(fail, "ip -net %s xfrm policy add dir out src 0.0.0.0/0 dst 0.0.0.0/0 "
 	    "if_id %d tmpl src %s dst %s proto esp mode tunnel if_id %d", ns,
 	    if_id, ipv4_local, ipv4_remote, if_id);
 
 	/* Policy: local <- remote */
-	SYS("ip -net %s xfrm policy add dir in src 0.0.0.0/0 dst 0.0.0.0/0 "
+	SYS(fail, "ip -net %s xfrm policy add dir in src 0.0.0.0/0 dst 0.0.0.0/0 "
 	    "if_id %d tmpl src %s dst %s proto esp mode tunnel if_id %d", ns,
 	    if_id, ipv4_remote, ipv4_local, if_id);
 
@@ -274,16 +259,16 @@ static int config_overlay(void)
 	if (!ASSERT_OK(setup_xfrmi_external_dev(NS0), "xfrmi"))
 		goto fail;
 
-	SYS("ip -net " NS0 " addr add 192.168.1.100/24 dev ipsec0");
-	SYS("ip -net " NS0 " link set dev ipsec0 up");
+	SYS(fail, "ip -net " NS0 " addr add 192.168.1.100/24 dev ipsec0");
+	SYS(fail, "ip -net " NS0 " link set dev ipsec0 up");
 
-	SYS("ip -net " NS1 " link add ipsec0 type xfrm if_id %d", IF_ID_1);
-	SYS("ip -net " NS1 " addr add 192.168.1.200/24 dev ipsec0");
-	SYS("ip -net " NS1 " link set dev ipsec0 up");
+	SYS(fail, "ip -net " NS1 " link add ipsec0 type xfrm if_id %d", IF_ID_1);
+	SYS(fail, "ip -net " NS1 " addr add 192.168.1.200/24 dev ipsec0");
+	SYS(fail, "ip -net " NS1 " link set dev ipsec0 up");
 
-	SYS("ip -net " NS2 " link add ipsec0 type xfrm if_id %d", IF_ID_2);
-	SYS("ip -net " NS2 " addr add 192.168.1.200/24 dev ipsec0");
-	SYS("ip -net " NS2 " link set dev ipsec0 up");
+	SYS(fail, "ip -net " NS2 " link add ipsec0 type xfrm if_id %d", IF_ID_2);
+	SYS(fail, "ip -net " NS2 " addr add 192.168.1.200/24 dev ipsec0");
+	SYS(fail, "ip -net " NS2 " link set dev ipsec0 up");
 
 	return 0;
 fail:
@@ -294,7 +279,7 @@ static int test_xfrm_ping(struct xfrm_info *skel, u32 if_id)
 {
 	skel->bss->req_if_id = if_id;
 
-	SYS("ping -i 0.01 -c 3 -w 10 -q 192.168.1.200 > /dev/null");
+	SYS(fail, "ping -i 0.01 -c 3 -w 10 -q 192.168.1.200 > /dev/null");
 
 	if (!ASSERT_EQ(skel->bss->resp_if_id, if_id, "if_id"))
 		goto fail;
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index d5d51ec97ec8..9fbdc57c5b57 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -376,6 +376,21 @@ int test__join_cgroup(const char *path);
 	___ok;								\
 })
 
+#define SYS(goto_label, fmt, ...)					\
+	({								\
+		char cmd[1024];						\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);		\
+		if (!ASSERT_OK(system(cmd), cmd))			\
+			goto goto_label;				\
+	})
+
+#define SYS_NOFAIL(fmt, ...)						\
+	({								\
+		char cmd[1024];						\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);		\
+		system(cmd);						\
+	})
+
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
-- 
2.38.1

