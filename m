Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA863F9AB
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiLAVO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiLAVOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:14:49 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED674C1BE0;
        Thu,  1 Dec 2022 13:14:47 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so5007946wmb.2;
        Thu, 01 Dec 2022 13:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/lq/BysFumoaHOqIKSJKxn63dlNYuSVApJedT+jboo=;
        b=ol88mztHva5eC42R5i8rGRyEYv0YyvjS+LnVVcxclPQmlIo+LB0xWtC6Mb4GnuTSEt
         tFLbls/qCdXNaNzX8780uhS9ADKPKgDwRfZm0GVk3aoUknt0Qd1JzBNv2LBqa8P5XmAN
         wgUWN8E/xCr6FVRtr0L4OsqE/WSzOJ4cRyofkNFnGgEFPL6jUe5A1pAqRtyaBtX8XGgn
         Gnz2R78GZCfLgb9h1mUiIA/iPCebqpYPPYeO6OKLF6UYaRyeuukbFU+PZessmXPsRgiQ
         GmDoFHK7jOW3ECWpNxe/14SIH90VEitZyv0vh8mKC9wv5s+fLnWtbktwEa4P4ITs1q4Z
         0h+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/lq/BysFumoaHOqIKSJKxn63dlNYuSVApJedT+jboo=;
        b=Cp16Px/68a74bCi41/Q79YdWbGcsj7T6zlF/Q+JuWCqnFnsa+mTbLNEfiU4WXDgTnm
         VGWiToeQmWLywV5VXB8sjyBDk7zq1gRc2uwIjUPXEEXM6LIs3cJXPywVh82OjRjgwIsI
         dPhEHm5meC0gcPJSG5ZrObRtFKOLAr6o7RgGip1DV2dwZsJ4MuOBpov+ylVi0YEqq8sl
         XmyFRrWoD/tRK9Z0vsdtzH+O4lOBMW2/VNOHDvmucA76+/bci/aQOO4SkFTSAtlCJ7Gz
         ntv9tulWVS5xQAuWdgXAJL9nX3sQFUp+xXWYXVIctcXpk4IOxjKhUunnoo7Rk8iHrDkn
         V44A==
X-Gm-Message-State: ANoB5pn3phtZOOuzhCcrLexclr4HOK8B/zTrwytrK2oEv4oeLrti1j3J
        xpaFUZL/6N5lQFclDQPfxfw=
X-Google-Smtp-Source: AA0mqf5cq1OuMC5uSkNwCLtI2mW1eSl/qJZXOr/8hKQZlp5iVrXQOS1v7aTb12HFNCOMrLZscmxuTQ==
X-Received: by 2002:a05:600c:2119:b0:3d0:77f0:e3f5 with SMTP id u25-20020a05600c211900b003d077f0e3f5mr5407037wml.184.1669929286170;
        Thu, 01 Dec 2022 13:14:46 -0800 (PST)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id m35-20020a05600c3b2300b003b50428cf66sm7508708wms.33.2022.12.01.13.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:14:45 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v3 4/4] selftests/bpf: add xfrm_info tests
Date:   Thu,  1 Dec 2022 23:14:25 +0200
Message-Id: <20221201211425.1528197-5-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201211425.1528197-1-eyal.birger@gmail.com>
References: <20221201211425.1528197-1-eyal.birger@gmail.com>
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
NSs based on a userspace populated bpf global variable and validate
that the return traffic had arrived from the desired NS.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---
v3: changes suggested by Martin KaFai Lau:
  - rename test_xfrm_info{,_kern}.c -> xfrm_info.c
  - avoid running in a separate thread
  - simplify test setup
  - verify underlay/overlay success
  - create NS0 xfrmi external device using netlink to avoid dependency
    on newer iproute2
  - remove use of bpf_trace_printk() in test programs
  - add "preserve_access_index" attribute annotation in test program
    struct definition
  - use bss variables access instead of a map for userspace/bpf interface

v2:
  - use an lwt route in NS1 for testing that flow as well
  - indendation fix
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/xfrm_info.c      | 365 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/xfrm_info.c |  40 ++
 3 files changed, 407 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index f9034ea00bc9..3543c76cef56 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -23,6 +23,7 @@ CONFIG_IKCONFIG_PROC=y
 CONFIG_IMA=y
 CONFIG_IMA_READ_POLICY=y
 CONFIG_IMA_WRITE_POLICY=y
+CONFIG_INET_ESP=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_RAW=y
 CONFIG_IP_NF_TARGET_SYNPROXY=y
@@ -74,3 +75,4 @@ CONFIG_TEST_BPF=y
 CONFIG_USERFAULTFD=y
 CONFIG_VXLAN=y
 CONFIG_XDP_SOCKETS=y
+CONFIG_XFRM_INTERFACE=y
diff --git a/tools/testing/selftests/bpf/prog_tests/xfrm_info.c b/tools/testing/selftests/bpf/prog_tests/xfrm_info.c
new file mode 100644
index 000000000000..bc5badaeb7fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xfrm_info.c
@@ -0,0 +1,365 @@
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
+#include <linux/rtnetlink.h>
+#include <linux/if_link.h>
+
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "xfrm_info.skel.h"
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
+static struct rtattr *rtattr_add(struct nlmsghdr *nh, unsigned short type,
+				 unsigned short len)
+{
+	struct rtattr *rta =
+		(struct rtattr *)((uint8_t *)nh + RTA_ALIGN(nh->nlmsg_len));
+	rta->rta_type = type;
+	rta->rta_len = RTA_LENGTH(len);
+	nh->nlmsg_len = RTA_ALIGN(nh->nlmsg_len) + RTA_ALIGN(rta->rta_len);
+	return rta;
+}
+
+static struct rtattr *rtattr_add_str(struct nlmsghdr *nh, unsigned short type,
+				     const char *s)
+{
+	struct rtattr *rta = rtattr_add(nh, type, strlen(s));
+
+	memcpy(RTA_DATA(rta), s, strlen(s));
+	return rta;
+}
+
+static struct rtattr *rtattr_begin(struct nlmsghdr *nh, unsigned short type)
+{
+	return rtattr_add(nh, type, 0);
+}
+
+static void rtattr_end(struct nlmsghdr *nh, struct rtattr *attr)
+{
+	uint8_t *end = (uint8_t *)nh + nh->nlmsg_len;
+
+	attr->rta_len = end - (uint8_t *)attr;
+}
+
+static int setup_xfrmi_external_dev(const char *ns)
+{
+	struct {
+		struct nlmsghdr nh;
+		struct ifinfomsg info;
+		unsigned char data[128];
+	} req;
+	struct rtattr *link_info, *info_data;
+	struct nstoken *nstoken;
+	int ret = -1, sock = 0;
+	struct nlmsghdr *nh;
+
+	memset(&req, 0, sizeof(req));
+	nh = &req.nh;
+	nh->nlmsg_len = NLMSG_LENGTH(sizeof(req.info));
+	nh->nlmsg_type = RTM_NEWLINK;
+	nh->nlmsg_flags |= NLM_F_CREATE | NLM_F_REQUEST;
+
+	rtattr_add_str(nh, IFLA_IFNAME, "ipsec0");
+	link_info = rtattr_begin(nh, IFLA_LINKINFO);
+	rtattr_add_str(nh, IFLA_INFO_KIND, "xfrm");
+	info_data = rtattr_begin(nh, IFLA_INFO_DATA);
+	rtattr_add(nh, IFLA_XFRM_COLLECT_METADATA, 0);
+	rtattr_end(nh, info_data);
+	rtattr_end(nh, link_info);
+
+	nstoken = open_netns(ns);
+
+	sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_ROUTE);
+	if (!ASSERT_GT(sock, 0, "netlink socket"))
+		goto Exit;
+	ret = send(sock, nh, nh->nlmsg_len, 0);
+	if (!ASSERT_EQ(ret, nh->nlmsg_len, "netlink send length"))
+		goto Exit;
+
+	ret = 0;
+Exit:
+	if (sock)
+		close(sock);
+	close_netns(nstoken);
+	return ret;
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
+	/* Older iproute2 doesn't support this option */
+	if (!ASSERT_OK(setup_xfrmi_external_dev(NS0), "xfrmi"))
+		goto fail;
+
+	SYS("ip -net " NS0 " addr add 192.168.1.100/24 dev ipsec0");
+	SYS("ip -net " NS0 " link set dev ipsec0 up");
+
+	SYS("ip -net " NS1 " link add ipsec0 type xfrm if_id %d", IF_ID_1);
+	SYS("ip -net " NS1 " addr add 192.168.1.200/24 dev ipsec0");
+	SYS("ip -net " NS1 " link set dev ipsec0 up");
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
+static int test_xfrm_ping(struct xfrm_info *skel, u32 if_id)
+{
+	skel->bss->req_if_id = if_id;
+
+	if (test_ping(AF_INET, "192.168.1.200"))
+		return -1;
+
+	if (!ASSERT_EQ(skel->bss->resp_if_id, if_id, "if_id"))
+		return -1;
+
+	return 0;
+}
+
+static void _test_xfrm_info(void)
+{
+	int get_xfrm_info_prog_fd, set_xfrm_info_prog_fd;
+	struct xfrm_info *skel = NULL;
+	struct nstoken *nstoken = NULL;
+	int ifindex = -1;
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
+			    .attach_point = BPF_TC_INGRESS);
+
+	/* load and attach bpf progs to ipsec dev tc hook point */
+	skel = xfrm_info__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "xfrm_info__open_and_load"))
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
+	if (!ASSERT_EQ(test_xfrm_ping(skel, IF_ID_0_TO_1), 0, "ping " NS1))
+		goto done;
+	if (!ASSERT_EQ(test_xfrm_ping(skel, IF_ID_0_TO_2), 0, "ping " NS2))
+		goto done;
+
+done:
+	if (nstoken)
+		close_netns(nstoken);
+	if (skel)
+		xfrm_info__destroy(skel);
+}
+
+void test_xfrm_info(void)
+{
+	cleanup();
+
+	if (!ASSERT_OK(config_underlay(), "config_underlay"))
+		return;
+	if (!ASSERT_OK(config_overlay(), "config_overlay"))
+		return;
+
+	if (test__start_subtest("xfrm_info"))
+		_test_xfrm_info();
+
+	cleanup();
+}
diff --git a/tools/testing/selftests/bpf/progs/xfrm_info.c b/tools/testing/selftests/bpf/progs/xfrm_info.c
new file mode 100644
index 000000000000..908579310bf9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xfrm_info.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+#include <bpf/bpf_helpers.h>
+
+__u32 req_if_id;
+__u32 resp_if_id;
+
+struct bpf_xfrm_info {
+	__u32 if_id;
+	int link;
+} __attribute__((preserve_access_index));
+
+int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
+			  const struct bpf_xfrm_info *from) __ksym;
+int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx,
+			  struct bpf_xfrm_info *to) __ksym;
+
+SEC("tc")
+int set_xfrm_info(struct __sk_buff *skb)
+{
+	struct bpf_xfrm_info info = { .if_id = req_if_id };
+
+	return bpf_skb_set_xfrm_info(skb, &info) ? TC_ACT_SHOT : TC_ACT_UNSPEC;
+}
+
+SEC("tc")
+int get_xfrm_info(struct __sk_buff *skb)
+{
+	struct bpf_xfrm_info info = {};
+
+	if (bpf_skb_get_xfrm_info(skb, &info) < 0)
+		return TC_ACT_SHOT;
+
+	resp_if_id = info.if_id;
+
+	return TC_ACT_UNSPEC;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

