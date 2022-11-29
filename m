Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436E863C0EE
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiK2NWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiK2NVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:21:41 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3972E9D6;
        Tue, 29 Nov 2022 05:21:40 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id e27so33691522ejc.12;
        Tue, 29 Nov 2022 05:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knwNxaRn1J4KFV3aRwjgMVhVlU+Yb5hKphe2dmpYA2Q=;
        b=TME3SkvCQfkhKYjqCNKXFxxuLX8Oa8Dtlr7P/EDyUtvFuwMmjieyBLjRhfpN19bBS8
         to+vXxn1EgcT50UIweSM1t0d/nt/9GhusQOkaZbQND53gvThqWId6Jauke+s024UoaiH
         2KJK5Dnt8IoRDyMvaaIrftd8eoLa00IwCwX7+voJnyxlp9JwiIiMjKlzn0LVIjbvMlJv
         112rXU9BJZWNADc3/6W0pLMKm/te7fXXJrsC7Zi9ud3LD9edH227jjMxTaxMMUtEKtJw
         q6mnRJ3zQ1zDOA4Do2Z3FEEBPVCYd6a5QG+DIPd+CYPB1NJfLv599siGtJOfbyG7OeFW
         806A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=knwNxaRn1J4KFV3aRwjgMVhVlU+Yb5hKphe2dmpYA2Q=;
        b=ILJLGJXEx1zI04IFkoqpuzG1DoTlXCm+7lpZVqMo+pFQaEp+/ZXNzy7dtELHjV/mwT
         H6jfj5FIS/W9uExT9HzJOTckeP6OlPA9kfyFlFMe+5cpn2bLm3pBzkyOF7n0QXuHQ8lS
         mQy7SJJjzIR24RnVcYj91J+6WmzhfBN5JvA8UXHSoM+GvewocVN3JNjpc687u1ThyYmH
         pc01djQ6G+8lVpnIx34NYT2KY7cFucLlE5CsgNa6ENSvCgWCpY5jGR6gJcwg37RxUvEk
         7jf7z5vMqr4GEUUYemPCvodfVIwVNa+y1rZQ6JQM9nrNemtvr5TqWjzEYZMBYL3FRgwv
         RGXg==
X-Gm-Message-State: ANoB5pnGRRnHvH9vhiVTtOQvRUtIS9gUULuxLMUCeHgm1/jsi9EFfUYf
        z24/aa9H0uHos/Se3bEcFR8=
X-Google-Smtp-Source: AA0mqf71xGMVZDzSawYiCvKR7rsoqk2IESdTbAruv+mSaIedp4Ur9Bl88OQ4gdvdqF5xu+uEBRvEuA==
X-Received: by 2002:a17:907:8e09:b0:7bc:420d:709f with SMTP id th9-20020a1709078e0900b007bc420d709fmr20067684ejc.658.1669728098303;
        Tue, 29 Nov 2022 05:21:38 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id v25-20020aa7d9d9000000b00458a03203b1sm6252632eds.31.2022.11.29.05.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 05:21:37 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v2 3/3] selftests/bpf: add xfrm_info tests
Date:   Tue, 29 Nov 2022 15:20:18 +0200
Message-Id: <20221129132018.985887-4-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129132018.985887-1-eyal.birger@gmail.com>
References: <20221129132018.985887-1-eyal.birger@gmail.com>
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

Test the xfrm_info kfunc helpers.

Note: the tests require support for xfrmi "external" mode in iproute2.

The test setup creates three name spaces - NS0, NS1, NS2.

XFRM tunnels are setup between NS0 and the two other NSs.

The kfunc helpers are used to steer traffic from NS0 to the other
NSs based on a userspace populated map and validate that the
return traffic had arrived from the desired NS.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v2:
  - use an lwt route in NS1 for testing that flow as well
  - indendation fix
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/test_xfrm_info.c | 343 ++++++++++++++++++
 .../selftests/bpf/progs/test_xfrm_info_kern.c |  74 ++++
 3 files changed, 419 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 9213565c0311..9f39943d6ebd 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -20,6 +20,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_IMA=y
 CONFIG_IMA_READ_POLICY=y
 CONFIG_IMA_WRITE_POLICY=y
+CONFIG_INET_ESP=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_RAW=y
 CONFIG_IP_NF_TARGET_SYNPROXY=y
@@ -71,3 +72,4 @@ CONFIG_TEST_BPF=y
 CONFIG_USERFAULTFD=y
 CONFIG_VXLAN=y
 CONFIG_XDP_SOCKETS=y
+CONFIG_XFRM_INTERFACE=y
diff --git a/tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c b/tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
new file mode 100644
index 000000000000..3aef72540934
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_xfrm_info.c
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+/*
+ * Topology:
+ * ---------
+ *   NS0 namespace         |   NS1 namespace        | NS2 namespace
+ *                         |                        |
+ *   +---------------+     |   +---------------+    |
+ *   |    ipsec0     |---------|    ipsec0     |    |
+ *   | 192.168.1.100 |     |   | 192.168.1.200 |    |
+ *   | if_id: bpf    |     |   +---------------+    |
+ *   +---------------+     |                        |
+ *           |             |                        |   +---------------+
+ *           |             |                        |   |    ipsec0     |
+ *           \------------------------------------------| 192.168.1.200 |
+ *                         |                        |   +---------------+
+ *                         |                        |
+ *                         |                        | (overlay network)
+ *      ------------------------------------------------------
+ *                         |                        | (underlay network)
+ *   +--------------+      |   +--------------+     |
+ *   |    veth01    |----------|    veth10    |     |
+ *   | 172.16.1.100 |      |   | 172.16.1.200 |     |
+ *   ---------------+      |   +--------------+     |
+ *                         |                        |
+ *   +--------------+      |                        |   +--------------+
+ *   |    veth02    |-----------------------------------|    veth20    |
+ *   | 172.16.2.100 |      |                        |   | 172.16.2.200 |
+ *   +--------------+      |                        |   +--------------+
+ *
+ *
+ * Test Packet flow
+ * -----------
+ *  The tests perform 'ping 192.168.1.200' from the NS0 namespace:
+ *  1) request is routed to NS0 ipsec0
+ *  2) NS0 ipsec0 tc egress BPF program is triggered and sets the if_id based
+ *     on a map value. This makes the ipsec0 device in external mode select the
+ *     destination tunnel
+ *  3) ping reaches the other namespace (NS1 or NS2 based on which if_id was
+ *     used) and response is sent
+ *  4) response is received on NS0 ipsec0, tc ingress program is triggered and
+ *     records the response if_id in the map
+ *  5) requested if_id is compared with received if_id
+ */
+
+#include <net/if.h>
+
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "test_xfrm_info_kern.skel.h"
+
+#define NS0 "xfrm_test_ns0"
+#define NS1 "xfrm_test_ns1"
+#define NS2 "xfrm_test_ns2"
+
+#define IF_ID_0_TO_1 1
+#define IF_ID_0_TO_2 2
+#define IF_ID_1 3
+#define IF_ID_2 4
+
+#define IP4_ADDR_VETH01 "172.16.1.100"
+#define IP4_ADDR_VETH10 "172.16.1.200"
+#define IP4_ADDR_VETH02 "172.16.2.100"
+#define IP4_ADDR_VETH20 "172.16.2.200"
+
+#define ESP_DUMMY_PARAMS \
+    "proto esp aead 'rfc4106(gcm(aes))' " \
+    "0xe4d8f4b4da1df18a3510b3781496daa82488b713 128 mode tunnel "
+
+#define PING_ARGS "-i 0.01 -c 3 -w 10 -q"
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
+static int attach_tc_prog(struct bpf_tc_hook *hook, int igr_fd, int egr_fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts1, .handle = 1,
+			    .priority = 1, .prog_fd = igr_fd);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts2, .handle = 1,
+			    .priority = 1, .prog_fd = egr_fd);
+	int ret;
+
+	ret = bpf_tc_hook_create(hook);
+	if (!ASSERT_OK(ret, "create tc hook"))
+		return ret;
+
+	if (igr_fd >= 0) {
+		hook->attach_point = BPF_TC_INGRESS;
+		ret = bpf_tc_attach(hook, &opts1);
+		if (!ASSERT_OK(ret, "bpf_tc_attach")) {
+			bpf_tc_hook_destroy(hook);
+			return ret;
+		}
+	}
+
+	if (egr_fd >= 0) {
+		hook->attach_point = BPF_TC_EGRESS;
+		ret = bpf_tc_attach(hook, &opts2);
+		if (!ASSERT_OK(ret, "bpf_tc_attach")) {
+			bpf_tc_hook_destroy(hook);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void cleanup(void)
+{
+	SYS_NOFAIL("test -f /var/run/netns/" NS0 " && ip netns delete " NS0);
+	SYS_NOFAIL("test -f /var/run/netns/" NS1 " && ip netns delete " NS1);
+	SYS_NOFAIL("test -f /var/run/netns/" NS2 " && ip netns delete " NS2);
+}
+
+static int config_underlay(void)
+{
+	SYS("ip netns add " NS0);
+	SYS("ip netns add " NS1);
+	SYS("ip netns add " NS2);
+
+	/* NS0 <-> NS1 [veth01 <-> veth10] */
+	SYS("ip link add veth01 netns " NS0 " type veth peer name veth10 netns " NS1);
+	SYS("ip -net " NS0 " addr add " IP4_ADDR_VETH01 "/24 dev veth01");
+	SYS("ip -net " NS0 " link set dev veth01 up");
+	SYS("ip -net " NS1 " addr add " IP4_ADDR_VETH10 "/24 dev veth10");
+	SYS("ip -net " NS1 " link set dev veth10 up");
+
+	/* NS0 <-> NS2 [veth02 <-> veth20] */
+	SYS("ip link add veth02 netns " NS0 " type veth peer name veth20 netns " NS2);
+	SYS("ip -net " NS0 " addr add " IP4_ADDR_VETH02 "/24 dev veth02");
+	SYS("ip -net " NS0 " link set dev veth02 up");
+	SYS("ip -net " NS2 " addr add " IP4_ADDR_VETH20 "/24 dev veth20");
+	SYS("ip -net " NS2 " link set dev veth20 up");
+
+	return 0;
+fail:
+	return -1;
+}
+
+static int setup_xfrm_tunnel_ns(const char *ns, const char *ipv4_local,
+				const char *ipv4_remote, int if_id)
+{
+	/* State: local -> remote */
+	SYS("ip -net %s xfrm state add src %s dst %s spi 1 "
+	    ESP_DUMMY_PARAMS "if_id %d", ns, ipv4_local, ipv4_remote, if_id);
+
+	/* State: local <- remote */
+	SYS("ip -net %s xfrm state add src %s dst %s spi 1 "
+	    ESP_DUMMY_PARAMS "if_id %d", ns, ipv4_remote, ipv4_local, if_id);
+
+	/* Policy: local -> remote */
+	SYS("ip -net %s xfrm policy add dir out src 0.0.0.0/0 dst 0.0.0.0/0 "
+	    "if_id %d tmpl src %s dst %s proto esp mode tunnel if_id %d", ns,
+	    if_id, ipv4_local, ipv4_remote, if_id);
+
+	/* Policy: local <- remote */
+	SYS("ip -net %s xfrm policy add dir in src 0.0.0.0/0 dst 0.0.0.0/0 "
+	    "if_id %d tmpl src %s dst %s proto esp mode tunnel if_id %d", ns,
+	    if_id, ipv4_remote, ipv4_local, if_id);
+
+	return 0;
+fail:
+	return -1;
+}
+
+static int setup_xfrm_tunnel(const char *ns_a, const char *ns_b,
+			     const char *ipv4_a, const char *ipv4_b,
+			     int if_id_a, int if_id_b)
+{
+	return setup_xfrm_tunnel_ns(ns_a, ipv4_a, ipv4_b, if_id_a) ||
+		setup_xfrm_tunnel_ns(ns_b, ipv4_b, ipv4_a, if_id_b);
+}
+
+static int config_overlay(void)
+{
+	if (setup_xfrm_tunnel(NS0, NS1, IP4_ADDR_VETH01, IP4_ADDR_VETH10,
+			      IF_ID_0_TO_1, IF_ID_1))
+		goto fail;
+	if (setup_xfrm_tunnel(NS0, NS2, IP4_ADDR_VETH02, IP4_ADDR_VETH20,
+			      IF_ID_0_TO_2, IF_ID_2))
+		goto fail;
+
+	SYS("ip -net " NS0 " link add ipsec0 type xfrm external");
+	SYS("ip -net " NS0 " addr add 192.168.1.100/24 dev ipsec0");
+	SYS("ip -net " NS0 " link set dev ipsec0 up");
+
+	SYS("ip -net " NS1 " link add ipsec0 type xfrm external");
+	SYS("ip -net " NS1 " addr add 192.168.1.200/32 dev ipsec0");
+	SYS("ip -net " NS1 " link set dev ipsec0 up");
+	SYS("ip -net " NS1 " route add 192.168.1.100/32 dev ipsec0 encap xfrm if_id %d", IF_ID_1);
+
+	SYS("ip -net " NS2 " link add ipsec0 type xfrm if_id %d", IF_ID_2);
+	SYS("ip -net " NS2 " addr add 192.168.1.200/24 dev ipsec0");
+	SYS("ip -net " NS2 " link set dev ipsec0 up");
+
+	return 0;
+fail:
+	return -1;
+}
+
+static int test_ping(int family, const char *addr)
+{
+	SYS("%s %s %s > /dev/null", ping_command(family), PING_ARGS, addr);
+	return 0;
+fail:
+	return -1;
+}
+
+static int test_xfrm_ping(int dst_if_id_map_fd, u32 if_id)
+{
+	u32 dst_if_id;
+	int key, err;
+
+	key = 0;
+	dst_if_id = if_id;
+	err = bpf_map_update_elem(dst_if_id_map_fd, &key, &dst_if_id, BPF_ANY);
+	if (!ASSERT_OK(err, "update bpf dst_if_id_map"))
+		return -1;
+
+	if (test_ping(AF_INET, "192.168.1.200"))
+		return -1;
+
+	key = 1;
+	dst_if_id = 0;
+	err = bpf_map_lookup_elem(dst_if_id_map_fd, &key, &dst_if_id);
+	if (!ASSERT_OK(err, "lookup bpf dst_if_id_map"))
+		return -1;
+
+	if (!ASSERT_EQ(dst_if_id, if_id, "if_id"))
+		return -1;
+
+	return 0;
+}
+
+static void test_xfrm_info(void)
+{
+	int get_xfrm_info_prog_fd, set_xfrm_info_prog_fd;
+	struct test_xfrm_info_kern *skel = NULL;
+	struct nstoken *nstoken = NULL;
+	int dst_if_id_map_fd = -1;
+	int ifindex = -1;
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
+			    .attach_point = BPF_TC_INGRESS);
+
+	/* load and attach bpf progs to ipsec dev tc hook point */
+	skel = test_xfrm_info_kern__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_xfrm_info_kern__open_and_load"))
+		goto done;
+	nstoken = open_netns(NS0);
+	ifindex = if_nametoindex("ipsec0");
+	if (!ASSERT_NEQ(ifindex, 0, "ipsec0 ifindex"))
+		goto done;
+	tc_hook.ifindex = ifindex;
+	set_xfrm_info_prog_fd = bpf_program__fd(skel->progs.set_xfrm_info);
+	get_xfrm_info_prog_fd = bpf_program__fd(skel->progs.get_xfrm_info);
+	if (!ASSERT_GE(set_xfrm_info_prog_fd, 0, "bpf_program__fd"))
+		goto done;
+	if (!ASSERT_GE(get_xfrm_info_prog_fd, 0, "bpf_program__fd"))
+		goto done;
+	if (attach_tc_prog(&tc_hook, get_xfrm_info_prog_fd,
+			   set_xfrm_info_prog_fd))
+		goto done;
+	dst_if_id_map_fd = bpf_map__fd(skel->maps.dst_if_id_map);
+	if (!ASSERT_GE(dst_if_id_map_fd, 0, "bpf_map__fd"))
+		goto done;
+
+	if (!ASSERT_EQ(test_xfrm_ping(dst_if_id_map_fd, IF_ID_0_TO_1), 0,
+		       "ping " NS1))
+		goto done;
+	if (!ASSERT_EQ(test_xfrm_ping(dst_if_id_map_fd, IF_ID_0_TO_2), 0,
+		       "ping " NS2))
+		goto done;
+
+done:
+	if (nstoken)
+		close_netns(nstoken);
+	if (dst_if_id_map_fd >= 0)
+		close(dst_if_id_map_fd);
+	if (skel)
+		test_xfrm_info_kern__destroy(skel);
+}
+
+#define RUN_TEST(name)							\
+	({								\
+		if (test__start_subtest(#name)) {			\
+			test_ ## name();				\
+		}							\
+	})
+
+static void *test_xfrm_info_run_tests(void *arg)
+{
+	cleanup();
+
+	config_underlay();
+	config_overlay();
+
+	RUN_TEST(xfrm_info);
+
+	cleanup();
+
+	return NULL;
+}
+
+static int probe_iproute2(void)
+{
+	if (SYS_NOFAIL("ip link add type xfrm help 2>&1 | "
+		       "grep external > /dev/null")) {
+		fprintf(stdout, "%s:SKIP: iproute2 with xfrm external support needed for this test\n", __func__);
+		return -1;
+	}
+	return 0;
+}
+
+void serial_test_xfrm_info(void)
+{
+	pthread_t test_thread;
+	int err;
+
+	if (probe_iproute2()) {
+		test__skip();
+		return;
+	}
+
+	/* Run the tests in their own thread to isolate the namespace changes
+	 * so they do not affect the environment of other tests.
+	 * (specifically needed because of unshare(CLONE_NEWNS) in open_netns())
+	 */
+	err = pthread_create(&test_thread, NULL, &test_xfrm_info_run_tests, NULL);
+	if (ASSERT_OK(err, "pthread_create"))
+		ASSERT_OK(pthread_join(test_thread, NULL), "pthread_join");
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c b/tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c
new file mode 100644
index 000000000000..98991a83c1e9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xfrm_info_kern.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+#include <bpf/bpf_helpers.h>
+
+#define log_err(__ret) bpf_printk("ERROR line:%d ret:%d\n", __LINE__, __ret)
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u32);
+} dst_if_id_map SEC(".maps");
+
+struct bpf_xfrm_info {
+	__u32 if_id;
+	int link;
+};
+
+int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
+			  const struct bpf_xfrm_info *from) __ksym;
+int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx,
+			  struct bpf_xfrm_info *to) __ksym;
+
+SEC("tc")
+int set_xfrm_info(struct __sk_buff *skb)
+{
+	struct bpf_xfrm_info info = {};
+	__u32 *if_id = NULL;
+	__u32 index = 0;
+	int ret = -1;
+
+	if_id = bpf_map_lookup_elem(&dst_if_id_map, &index);
+	if (!if_id) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+
+	info.if_id = *if_id;
+	ret = bpf_skb_set_xfrm_info(skb, &info);
+	if (ret < 0) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+
+	return TC_ACT_UNSPEC;
+}
+
+SEC("tc")
+int get_xfrm_info(struct __sk_buff *skb)
+{
+	struct bpf_xfrm_info info = {};
+	__u32 *if_id = NULL;
+	__u32 index = 1;
+	int ret = -1;
+
+	if_id = bpf_map_lookup_elem(&dst_if_id_map, &index);
+	if (!if_id) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+
+	ret = bpf_skb_get_xfrm_info(skb, &info);
+	if (ret < 0) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+
+	*if_id = info.if_id;
+
+	return TC_ACT_UNSPEC;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

