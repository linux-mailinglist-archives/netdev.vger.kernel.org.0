Return-Path: <netdev+bounces-5343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77243710E57
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1C3D1C20EA2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F50717AC8;
	Thu, 25 May 2023 14:28:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1017727;
	Thu, 25 May 2023 14:28:08 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80BE199;
	Thu, 25 May 2023 07:28:06 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b050b75a1so55776585a.1;
        Thu, 25 May 2023 07:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685024886; x=1687616886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AD//1D+EKljHiggtI3aWMySaEkBz2k0/3EwRWorDH+Q=;
        b=PVColQ25O3qaq6aiKE0Zk9YZkp2U3qmhERvGLrqeb39NQiyBWUPFFAqtq1wDMX3sgE
         zxvlncNg+MIhk8aYwoLXyrXaF/f1182Yd4cMq9O7HgVuO8s+sTC7I+SQgDMzkVvF7HMS
         /VAlwHMfY4gaQasJn5jQ2hhdHy+q7+7D05wIxM4AYWb/6xj6rxwksjLUVswI6fLI3uAP
         UaL3ZJLxnp7ihY0rTM5b4FLXQgwtPszNmq8WfiVaaQvmH5+HeR25yDUcl49BxNIL+Uff
         /ot7D2V9ajU4JDwDAkGL1lTYGy+65A65dA519s6sitlJ9CENa4H3Q8qY7sMWYp/M7X5s
         x3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685024886; x=1687616886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AD//1D+EKljHiggtI3aWMySaEkBz2k0/3EwRWorDH+Q=;
        b=LS6v3K5dEinE+m7dItSRUsq9zPnYP0Uh6qK5bcZCMXvrKlKtVx/sptRt6urTFqqqv4
         sSxQjLasJLlZtrwgE7isZWvCJyT8x6pCRXwCdz/iBAiMnyVYLG6okQl3Ki9nvl7lGS8W
         XraAE56C7DmpcK6/1lj+2qAR4WUuEPkA2GCLXE2swwsNMHVdK0kzO3bI95sA/KhoZCaA
         oHmq+qi2dYiDYDmTYJlJUqP/V/RzIqbIdswna/iS7uloIEDfzpshf8zGFRY/f5zI55Pk
         je+gn0x2XVagWoO0EUikXXarBc4J/b0y3dWzsgbChF9dlkBOaut9ltOVHB/o288KAcn0
         gMRA==
X-Gm-Message-State: AC+VfDyLAN9uRyeidFM1+f35RId2ZdelOkSUK73GLRkMG6jE+nVvXwfx
	ok4FaPLgOElsKuvBJqSchIY=
X-Google-Smtp-Source: ACHHUZ7oIj1uQ0YYwYXDmOySW8fvMW1/Ab4Lt0SIyFRL5zmfls6Anh9pPxQYA9R7Jq5sv9bk8IAcrw==
X-Received: by 2002:a37:b16:0:b0:75b:23a1:402 with SMTP id 22-20020a370b16000000b0075b23a10402mr10134731qkl.24.1685024885717;
        Thu, 25 May 2023 07:28:05 -0700 (PDT)
Received: from localhost (ool-944b8b4f.dyn.optonline.net. [148.75.139.79])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a11b700b00759391e7f7asm417884qkk.90.2023.05.25.07.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 07:28:05 -0700 (PDT)
From: Louis DeLosSantos <louis.delos.devel@gmail.com>
Date: Thu, 25 May 2023 10:28:00 -0400
Subject: [PATCH 2/2] bpf: test table ID fib lookup BPF helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230505-bpf-add-tbid-fib-lookup-v1-2-fd99f7162e76@gmail.com>
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
To: bpf@vger.kernel.org, netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
 Stanislav Fomichev <sdf@google.com>, razor@blackwall.org, 
 Louis DeLosSantos <louis.delos.devel@gmail.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add additional test cases to `fib_lookup.c` prog_test.

These test cases add a new /24 network to the previously unused veth2
device, removes the directly connected route from the main routing table
and moves it to table 100.

The first test case then confirms a fib lookup for a remote address in this
directly connected network, using the main routing table fails.

The second test case ensures the same fib lookup using table 100
succeeds.

An additional pair of tests which function in the same manner are added
for IPv6.

Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  | 58 +++++++++++++++++++---
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
index a1e7121058118..e8d1f35780d75 100644
--- a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2023 Meta Platforms, Inc. and affiliates. */
 
+#include "linux/bpf.h"
+#include <linux/rtnetlink.h>
 #include <sys/types.h>
 #include <net/if.h>
 
@@ -15,14 +17,23 @@
 #define IPV4_IFACE_ADDR		"10.0.0.254"
 #define IPV4_NUD_FAILED_ADDR	"10.0.0.1"
 #define IPV4_NUD_STALE_ADDR	"10.0.0.2"
+#define IPV4_TBID_ADDR		"172.0.0.254"
+#define IPV4_TBID_NET		"172.0.0.0"
+#define IPV4_TBID_DST		"172.0.0.2"
+#define IPV6_TBID_ADDR		"fd00::FFFF"
+#define IPV6_TBID_NET		"fd00::"
+#define IPV6_TBID_DST		"fd00::2"
 #define DMAC			"11:11:11:11:11:11"
 #define DMAC_INIT { 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, }
+#define DMAC2			"01:01:01:01:01:01"
+#define DMAC_INIT2 { 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, }
 
 struct fib_lookup_test {
 	const char *desc;
 	const char *daddr;
 	int expected_ret;
 	int lookup_flags;
+	__u32 tbid;
 	__u8 dmac[6];
 };
 
@@ -43,6 +54,18 @@ static const struct fib_lookup_test tests[] = {
 	{ .desc = "IPv4 skip neigh",
 	  .daddr = IPV4_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
 	  .lookup_flags = BPF_FIB_LOOKUP_SKIP_NEIGH, },
+	{ .desc = "IPv4 TBID lookup failure",
+	  .daddr = IPV4_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_NOT_FWDED,
+	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT },
+	{ .desc = "IPv4 TBID lookup success",
+	  .daddr = IPV4_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
+	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, .tbid = 100, .dmac = DMAC_INIT2, },
+	{ .desc = "IPv6 TBID lookup failure",
+	  .daddr = IPV6_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_NOT_FWDED,
+	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, },
+	{ .desc = "IPv6 TBID lookup success",
+	  .daddr = IPV6_TBID_DST, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
+	  .lookup_flags = BPF_FIB_LOOKUP_DIRECT, .tbid = 100, .dmac = DMAC_INIT2, },
 };
 
 static int ifindex;
@@ -53,6 +76,7 @@ static int setup_netns(void)
 
 	SYS(fail, "ip link add veth1 type veth peer name veth2");
 	SYS(fail, "ip link set dev veth1 up");
+	SYS(fail, "ip link set dev veth2 up");
 
 	err = write_sysctl("/proc/sys/net/ipv4/neigh/veth1/gc_stale_time", "900");
 	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.neigh.veth1.gc_stale_time)"))
@@ -70,6 +94,17 @@ static int setup_netns(void)
 	SYS(fail, "ip neigh add %s dev veth1 nud failed", IPV4_NUD_FAILED_ADDR);
 	SYS(fail, "ip neigh add %s dev veth1 lladdr %s nud stale", IPV4_NUD_STALE_ADDR, DMAC);
 
+	/* Setup for tbid lookup tests */
+	SYS(fail, "ip addr add %s/24 dev veth2", IPV4_TBID_ADDR);
+	SYS(fail, "ip route del %s/24 dev veth2", IPV4_TBID_NET);
+	SYS(fail, "ip route add table 100 %s/24 dev veth2", IPV4_TBID_NET);
+	SYS(fail, "ip neigh add %s dev veth2 lladdr %s nud stale", IPV4_TBID_DST, DMAC2);
+
+	SYS(fail, "ip addr add %s/64 dev veth2", IPV6_TBID_ADDR);
+	SYS(fail, "ip -6 route del %s/64 dev veth2", IPV6_TBID_NET);
+	SYS(fail, "ip -6 route add table 100 %s/64 dev veth2", IPV6_TBID_NET);
+	SYS(fail, "ip neigh add %s dev veth2 lladdr %s nud stale", IPV6_TBID_DST, DMAC2);
+
 	err = write_sysctl("/proc/sys/net/ipv4/conf/veth1/forwarding", "1");
 	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.conf.veth1.forwarding)"))
 		goto fail;
@@ -83,7 +118,7 @@ static int setup_netns(void)
 	return -1;
 }
 
-static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
+static int set_lookup_params(struct bpf_fib_lookup *params, const struct fib_lookup_test *test)
 {
 	int ret;
 
@@ -91,8 +126,9 @@ static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
 
 	params->l4_protocol = IPPROTO_TCP;
 	params->ifindex = ifindex;
+	params->tbid = test->tbid;
 
-	if (inet_pton(AF_INET6, daddr, params->ipv6_dst) == 1) {
+	if (inet_pton(AF_INET6, test->daddr, params->ipv6_dst) == 1) {
 		params->family = AF_INET6;
 		ret = inet_pton(AF_INET6, IPV6_IFACE_ADDR, params->ipv6_src);
 		if (!ASSERT_EQ(ret, 1, "inet_pton(IPV6_IFACE_ADDR)"))
@@ -100,7 +136,7 @@ static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
 		return 0;
 	}
 
-	ret = inet_pton(AF_INET, daddr, &params->ipv4_dst);
+	ret = inet_pton(AF_INET, test->daddr, &params->ipv4_dst);
 	if (!ASSERT_EQ(ret, 1, "convert IP[46] address"))
 		return -1;
 	params->family = AF_INET;
@@ -154,13 +190,12 @@ void test_fib_lookup(void)
 	fib_params = &skel->bss->fib_params;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		printf("Testing %s\n", tests[i].desc);
+		printf("Testing %s ", tests[i].desc);
 
-		if (set_lookup_params(fib_params, tests[i].daddr))
+		if (set_lookup_params(fib_params, &tests[i]))
 			continue;
 		skel->bss->fib_lookup_ret = -1;
-		skel->bss->lookup_flags = BPF_FIB_LOOKUP_OUTPUT |
-			tests[i].lookup_flags;
+		skel->bss->lookup_flags = tests[i].lookup_flags;
 
 		err = bpf_prog_test_run_opts(prog_fd, &run_opts);
 		if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
@@ -175,7 +210,14 @@ void test_fib_lookup(void)
 
 			mac_str(expected, tests[i].dmac);
 			mac_str(actual, fib_params->dmac);
-			printf("dmac expected %s actual %s\n", expected, actual);
+			printf("dmac expected %s actual %s ", expected, actual);
+		}
+
+		// ensure tbid is zero'd out after fib lookup.
+		if (tests[i].lookup_flags & BPF_FIB_LOOKUP_DIRECT) {
+			if (!ASSERT_EQ(skel->bss->fib_params.tbid, 0,
+					"expected fib_params.tbid to be zero"))
+				goto fail;
 		}
 	}
 

-- 
2.40.1


