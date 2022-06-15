Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF45654CA42
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353605AbiFONtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353431AbiFONts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:49:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF20B3EF3E;
        Wed, 15 Jun 2022 06:49:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeMHTXXQxeyU1R7Ua96vk6pZM4OPcBenQiJWUYygiOLiUqZ5duiARCDclzPm0Qrx4r1JYGBOnFJ4RJVDbwmH7yxRO/A9mxWOZ6MHK4AjIQBWakMUxDGJ3/nrndkMcr+aVHk8b7TlU7gsrji9xjteECKm0MyTLCuF0edXUvZCGMMkVBq0DiqTniRcfVJas4KaDH3mdawCyTC9IVSejZonJwh+Q0JioNhSaMDKCIxzgcdnwD+C21Pe8h/h5Fge53xz6kwHJfGxlK/MtE29gm1HY4fZErkpUosMgQDWcxYaHztxO4O+OHaKghRIk+Xo0pp6zgao8n/jKayuLF0YimeosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEMr/HKgFtzZGKvvxJi8s4nGXUBeoHW/QqXDtkseprg=;
 b=dPpUA9HFz2e7pVpMQBzTmmaLGsZe4TL3PWd/mziwsPz6J96yPFqQDbMP/IclUCPk2Jm/pIw8prGyh6weEQAAmZNyVsaiqEkksCv+5KiC1Ms6HdCWZyb/mHHZiRFdVgF6WVv4IlFXwu7LUp02l7JxvoT5ITUqfBhuBAYnzebtwUe2Or0Hp1m3o3DAPxrsTMUF0f9W4YdeamdVbAV0KRa/ovmhSk4Gj3ffdRUPLN23XQAHiem4GXUoNlKONFQ2sUQihhJH9UzA+IQbUK3lZb0fB8lEzj3UG/2naJUlrW5fd9PEwg9xU06huYaSiTEYGVrPen6Tjy66c/EOksqyjb9qtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEMr/HKgFtzZGKvvxJi8s4nGXUBeoHW/QqXDtkseprg=;
 b=LAjQhsSgJqYaVtriL2x6em5UsPgj4ySmsY5+XYDdZQq6YttNzKWS5CIPETAz/3PvqGkVtmkUFfQ3XhxIrNFWPBbdo5rL8/BmBizZ7CP3R+9thodH+M2Q7777sAs3ftoch2w8HqJAlJKJUsiUUpwh722ZY21KHZshyBzvgC5PZUK6Me7DZ6o+SBazKaLOnTwTs43VrFRBw9UnzNZNDvEg6i22EvfHk18YUbbyLWe1K5K2fej2laKb2Vg2xoCKrvOplXwTRJXxvFpqCk++74NES5w7JgVahuQ3hx9EyXDONaHHLQOdr65Xx/kKDqVguZK81zR98ZqoybAswfyvhQvUNg==
Received: from MW4PR03CA0050.namprd03.prod.outlook.com (2603:10b6:303:8e::25)
 by CH2PR12MB5563.namprd12.prod.outlook.com (2603:10b6:610:6a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 13:49:41 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::2d) by MW4PR03CA0050.outlook.office365.com
 (2603:10b6:303:8e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Wed, 15 Jun 2022 13:49:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Wed, 15 Jun 2022 13:49:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 13:49:40 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 06:49:40 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 06:49:34 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        "Florent Revest" <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v10 6/6] selftests/bpf: Add selftests for raw syncookie helpers in TC mode
Date:   Wed, 15 Jun 2022 16:48:47 +0300
Message-ID: <20220615134847.3753567-7-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
References: <20220615134847.3753567-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b709d30-1afa-4408-635d-08da4ed5e59b
X-MS-TrafficTypeDiagnostic: CH2PR12MB5563:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB55636F024EDD8C2D0EB82784DCAD9@CH2PR12MB5563.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBU9wHZV/tOkRRAhj4QbOiGbSrOphWmgBNh/c1QJUaHSHIAZ4RB696/jdPprchPcR2ylE51+bNNp/PfSfOMd0YPHQKcRvwkR4s9DvvX6XHtjNImg+0WDwNKsWeYmZGQKBlpetFlaFao6YlR4Hjxi9cqC1C8ui6wDbo3txcWqa6/In4sij4aNsH87/Fsu2O9qg1Wv6Cj1Mw180YqOcStIYEzBoieVcW5JsnG4ivQ17ymnfKAPT3nuHOzI71pu2YRgs294QoV41OvWBGSrynNTkStosL5p9tBRTXaSkSqDfMryE5DCx7O/ItVVqTCtivhs5ySb16ENWxrPovw8iMPRpL0spPrtA20wX8JU5PtwyVUfePDL1awNWKPN2VhUFEkj2aACwoBErg9XntDRXuLMkgB71br4+SvgZjQCd13vF4wFQRyZ8oLpwc1/eWPJPfELonNYQx9XXiWKnJtYissm+4pA7oPaDNllfSixMTRYEjbKx4rptlIAAyape7YEpPlHpE00fR51AlkGx/WuEuk3zSK3HAxlZ5MxinSgs0bKDATAMpdutrYTN6+/oCENNtq0tsVrNFSUHOTeg3BTF25Ngl89WIOHRn2ijZgo5NNa6y60FdZjJBeHbanNJ2e9Qzz4jTUO20bJxOVGH+0cP6eNSXVsoi4Rd6Jn2IKBX7cnqFebINLZV/GOXroItnPUIATjzuIHnyx/LNQD/INsx/1VnQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(8676002)(36860700001)(82310400005)(107886003)(36756003)(86362001)(1076003)(83380400001)(7416002)(8936002)(2616005)(30864003)(47076005)(70206006)(54906003)(2906002)(316002)(4326008)(5660300002)(110136005)(6666004)(336012)(70586007)(356005)(7696005)(426003)(186003)(40460700003)(81166007)(26005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:49:41.2263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b709d30-1afa-4408-635d-08da4ed5e59b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5563
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit extends selftests for the new BPF helpers
bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6} to also test the TC BPF
functionality added in the previous commit.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../selftests/bpf/prog_tests/xdp_synproxy.c   |  55 +++++--
 .../selftests/bpf/progs/xdp_synproxy_kern.c   | 142 +++++++++++++-----
 tools/testing/selftests/bpf/xdp_synproxy.c    |  96 +++++++++---
 3 files changed, 224 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
index d9ee884c2a2b..fb77a123fe89 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1 OR BSD-2-Clause
 /* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
 
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
 #include <ctype.h>
@@ -12,9 +13,11 @@
 		goto out; \
 })
 
-#define SYS_OUT(cmd) ({ \
-	FILE *f = popen((cmd), "r"); \
-	if (!ASSERT_OK_PTR(f, (cmd))) \
+#define SYS_OUT(cmd, ...) ({ \
+	char buf[1024]; \
+	snprintf(buf, sizeof(buf), (cmd), ##__VA_ARGS__); \
+	FILE *f = popen(buf, "r"); \
+	if (!ASSERT_OK_PTR(f, buf)) \
 		goto out; \
 	f; \
 })
@@ -57,9 +60,10 @@ static bool expect_str(char *buf, size_t size, const char *str, const char *name
 	return ok;
 }
 
-void test_xdp_synproxy(void)
+static void test_synproxy(bool xdp)
 {
 	int server_fd = -1, client_fd = -1, accept_fd = -1;
+	char *prog_id, *prog_id_end;
 	struct nstoken *ns = NULL;
 	FILE *ctrl_file = NULL;
 	char buf[CMD_OUT_BUF_SIZE];
@@ -76,8 +80,9 @@ void test_xdp_synproxy(void)
 	 * checksums and drops packets.
 	 */
 	SYS("ethtool -K tmp0 tx off");
-	/* Workaround required for veth. */
-	SYS("ip link set tmp0 xdp object xdp_dummy.o section xdp 2> /dev/null");
+	if (xdp)
+		/* Workaround required for veth. */
+		SYS("ip link set tmp0 xdp object xdp_dummy.o section xdp 2> /dev/null");
 
 	ns = open_netns("synproxy");
 	if (!ASSERT_OK_PTR(ns, "setns"))
@@ -97,14 +102,34 @@ void test_xdp_synproxy(void)
 	SYS("iptables -t filter -A INPUT \
 	    -i tmp1 -m state --state INVALID -j DROP");
 
-	ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 --single \
-			    --mss4 1460 --mss6 1440 --wscale 7 --ttl 64");
+	ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 \
+			    --single --mss4 1460 --mss6 1440 \
+			    --wscale 7 --ttl 64%s", xdp ? "" : " --tc");
 	size = fread(buf, 1, sizeof(buf), ctrl_file);
 	pclose(ctrl_file);
 	if (!expect_str(buf, size, "Total SYNACKs generated: 0\n",
 			"initial SYNACKs"))
 		goto out;
 
+	if (!xdp) {
+		ctrl_file = SYS_OUT("tc filter show dev tmp1 ingress");
+		size = fread(buf, 1, sizeof(buf), ctrl_file);
+		pclose(ctrl_file);
+		prog_id = memmem(buf, size, " id ", 4);
+		if (!ASSERT_OK_PTR(prog_id, "find prog id"))
+			goto out;
+		prog_id += 4;
+		if (!ASSERT_LT(prog_id, buf + size, "find prog id begin"))
+			goto out;
+		prog_id_end = prog_id;
+		while (prog_id_end < buf + size && *prog_id_end >= '0' &&
+		       *prog_id_end <= '9')
+			prog_id_end++;
+		if (!ASSERT_LT(prog_id_end, buf + size, "find prog id end"))
+			goto out;
+		*prog_id_end = '\0';
+	}
+
 	server_fd = start_server(AF_INET, SOCK_STREAM, "198.18.0.2", 8080, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_server"))
 		goto out;
@@ -124,7 +149,11 @@ void test_xdp_synproxy(void)
 	if (!ASSERT_OK_PTR(ns, "setns"))
 		goto out;
 
-	ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
+	if (xdp)
+		ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --single");
+	else
+		ctrl_file = SYS_OUT("./xdp_synproxy --prog %s --single",
+				    prog_id);
 	size = fread(buf, 1, sizeof(buf), ctrl_file);
 	pclose(ctrl_file);
 	if (!expect_str(buf, size, "Total SYNACKs generated: 1\n",
@@ -144,3 +173,11 @@ void test_xdp_synproxy(void)
 	system("ip link del tmp0");
 	system("ip netns del synproxy");
 }
+
+void test_xdp_synproxy(void)
+{
+	if (test__start_subtest("xdp"))
+		test_synproxy(true);
+	if (test__start_subtest("tc"))
+		test_synproxy(false);
+}
diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
index 53b9865276a4..9fd62e94b5e6 100644
--- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
@@ -7,6 +7,9 @@
 #include <bpf/bpf_endian.h>
 #include <asm/errno.h>
 
+#define TC_ACT_OK 0
+#define TC_ACT_SHOT 2
+
 #define NSEC_PER_SEC 1000000000L
 
 #define ETH_ALEN 6
@@ -80,6 +83,12 @@ extern struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx,
 					 struct bpf_ct_opts *opts,
 					 __u32 len_opts) __ksym;
 
+extern struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *skb_ctx,
+					 struct bpf_sock_tuple *bpf_tuple,
+					 u32 len_tuple,
+					 struct bpf_ct_opts *opts,
+					 u32 len_opts) __ksym;
+
 extern void bpf_ct_release(struct nf_conn *ct) __ksym;
 
 static __always_inline void swap_eth_addr(__u8 *a, __u8 *b)
@@ -382,7 +391,7 @@ static __always_inline int tcp_dissect(void *data, void *data_end,
 	return XDP_TX;
 }
 
-static __always_inline int tcp_lookup(struct xdp_md *ctx, struct header_pointers *hdr)
+static __always_inline int tcp_lookup(void *ctx, struct header_pointers *hdr, bool xdp)
 {
 	struct bpf_ct_opts ct_lookup_opts = {
 		.netns_id = BPF_F_CURRENT_NETNS,
@@ -416,7 +425,10 @@ static __always_inline int tcp_lookup(struct xdp_md *ctx, struct header_pointers
 		 */
 		return XDP_ABORTED;
 	}
-	ct = bpf_xdp_ct_lookup(ctx, &tup, tup_size, &ct_lookup_opts, sizeof(ct_lookup_opts));
+	if (xdp)
+		ct = bpf_xdp_ct_lookup(ctx, &tup, tup_size, &ct_lookup_opts, sizeof(ct_lookup_opts));
+	else
+		ct = bpf_skb_ct_lookup(ctx, &tup, tup_size, &ct_lookup_opts, sizeof(ct_lookup_opts));
 	if (ct) {
 		unsigned long status = ct->status;
 
@@ -529,8 +541,9 @@ static __always_inline void tcpv6_gen_synack(struct header_pointers *hdr,
 }
 
 static __always_inline int syncookie_handle_syn(struct header_pointers *hdr,
-						struct xdp_md *ctx,
-						void *data, void *data_end)
+						void *ctx,
+						void *data, void *data_end,
+						bool xdp)
 {
 	__u32 old_pkt_size, new_pkt_size;
 	/* Unlike clang 10, clang 11 and 12 generate code that doesn't pass the
@@ -666,8 +679,13 @@ static __always_inline int syncookie_handle_syn(struct header_pointers *hdr,
 	/* Set the new packet size. */
 	old_pkt_size = data_end - data;
 	new_pkt_size = sizeof(*hdr->eth) + ip_len + hdr->tcp->doff * 4;
-	if (bpf_xdp_adjust_tail(ctx, new_pkt_size - old_pkt_size))
-		return XDP_ABORTED;
+	if (xdp) {
+		if (bpf_xdp_adjust_tail(ctx, new_pkt_size - old_pkt_size))
+			return XDP_ABORTED;
+	} else {
+		if (bpf_skb_change_tail(ctx, new_pkt_size, 0))
+			return XDP_ABORTED;
+	}
 
 	values_inc_synacks();
 
@@ -693,71 +711,123 @@ static __always_inline int syncookie_handle_ack(struct header_pointers *hdr)
 	return XDP_PASS;
 }
 
-SEC("xdp")
-int syncookie_xdp(struct xdp_md *ctx)
+static __always_inline int syncookie_part1(void *ctx, void *data, void *data_end,
+					   struct header_pointers *hdr, bool xdp)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
-	struct header_pointers hdr;
-	__s64 value;
-	int ret;
-
 	struct bpf_ct_opts ct_lookup_opts = {
 		.netns_id = BPF_F_CURRENT_NETNS,
 		.l4proto = IPPROTO_TCP,
 	};
+	int ret;
 
-	ret = tcp_dissect(data, data_end, &hdr);
+	ret = tcp_dissect(data, data_end, hdr);
 	if (ret != XDP_TX)
 		return ret;
 
-	ret = tcp_lookup(ctx, &hdr);
+	ret = tcp_lookup(ctx, hdr, xdp);
 	if (ret != XDP_TX)
 		return ret;
 
 	/* Packet is TCP and doesn't belong to an established connection. */
 
-	if ((hdr.tcp->syn ^ hdr.tcp->ack) != 1)
+	if ((hdr->tcp->syn ^ hdr->tcp->ack) != 1)
 		return XDP_DROP;
 
-	/* Grow the TCP header to TCP_MAXLEN to be able to pass any hdr.tcp_len
+	/* Grow the TCP header to TCP_MAXLEN to be able to pass any hdr->tcp_len
 	 * to bpf_tcp_raw_gen_syncookie_ipv{4,6} and pass the verifier.
 	 */
-	if (bpf_xdp_adjust_tail(ctx, TCP_MAXLEN - hdr.tcp_len))
-		return XDP_ABORTED;
+	if (xdp) {
+		if (bpf_xdp_adjust_tail(ctx, TCP_MAXLEN - hdr->tcp_len))
+			return XDP_ABORTED;
+	} else {
+		/* Without volatile the verifier throws this error:
+		 * R9 32-bit pointer arithmetic prohibited
+		 */
+		volatile u64 old_len = data_end - data;
 
-	data_end = (void *)(long)ctx->data_end;
-	data = (void *)(long)ctx->data;
+		if (bpf_skb_change_tail(ctx, old_len + TCP_MAXLEN - hdr->tcp_len, 0))
+			return XDP_ABORTED;
+	}
+
+	return XDP_TX;
+}
 
-	if (hdr.ipv4) {
-		hdr.eth = data;
-		hdr.ipv4 = (void *)hdr.eth + sizeof(*hdr.eth);
+static __always_inline int syncookie_part2(void *ctx, void *data, void *data_end,
+					   struct header_pointers *hdr, bool xdp)
+{
+	if (hdr->ipv4) {
+		hdr->eth = data;
+		hdr->ipv4 = (void *)hdr->eth + sizeof(*hdr->eth);
 		/* IPV4_MAXLEN is needed when calculating checksum.
 		 * At least sizeof(struct iphdr) is needed here to access ihl.
 		 */
-		if ((void *)hdr.ipv4 + IPV4_MAXLEN > data_end)
+		if ((void *)hdr->ipv4 + IPV4_MAXLEN > data_end)
 			return XDP_ABORTED;
-		hdr.tcp = (void *)hdr.ipv4 + hdr.ipv4->ihl * 4;
-	} else if (hdr.ipv6) {
-		hdr.eth = data;
-		hdr.ipv6 = (void *)hdr.eth + sizeof(*hdr.eth);
-		hdr.tcp = (void *)hdr.ipv6 + sizeof(*hdr.ipv6);
+		hdr->tcp = (void *)hdr->ipv4 + hdr->ipv4->ihl * 4;
+	} else if (hdr->ipv6) {
+		hdr->eth = data;
+		hdr->ipv6 = (void *)hdr->eth + sizeof(*hdr->eth);
+		hdr->tcp = (void *)hdr->ipv6 + sizeof(*hdr->ipv6);
 	} else {
 		return XDP_ABORTED;
 	}
 
-	if ((void *)hdr.tcp + TCP_MAXLEN > data_end)
+	if ((void *)hdr->tcp + TCP_MAXLEN > data_end)
 		return XDP_ABORTED;
 
 	/* We run out of registers, tcp_len gets spilled to the stack, and the
 	 * verifier forgets its min and max values checked above in tcp_dissect.
 	 */
-	hdr.tcp_len = hdr.tcp->doff * 4;
-	if (hdr.tcp_len < sizeof(*hdr.tcp))
+	hdr->tcp_len = hdr->tcp->doff * 4;
+	if (hdr->tcp_len < sizeof(*hdr->tcp))
 		return XDP_ABORTED;
 
-	return hdr.tcp->syn ? syncookie_handle_syn(&hdr, ctx, data, data_end) :
-			      syncookie_handle_ack(&hdr);
+	return hdr->tcp->syn ? syncookie_handle_syn(hdr, ctx, data, data_end, xdp) :
+			       syncookie_handle_ack(hdr);
+}
+
+SEC("xdp")
+int syncookie_xdp(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct header_pointers hdr;
+	int ret;
+
+	ret = syncookie_part1(ctx, data, data_end, &hdr, true);
+	if (ret != XDP_TX)
+		return ret;
+
+	data_end = (void *)(long)ctx->data_end;
+	data = (void *)(long)ctx->data;
+
+	return syncookie_part2(ctx, data, data_end, &hdr, true);
+}
+
+SEC("tc")
+int syncookie_tc(struct __sk_buff *skb)
+{
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+	struct header_pointers hdr;
+	int ret;
+
+	ret = syncookie_part1(skb, data, data_end, &hdr, false);
+	if (ret != XDP_TX)
+		return ret == XDP_PASS ? TC_ACT_OK : TC_ACT_SHOT;
+
+	data_end = (void *)(long)skb->data_end;
+	data = (void *)(long)skb->data;
+
+	ret = syncookie_part2(skb, data, data_end, &hdr, false);
+	switch (ret) {
+	case XDP_PASS:
+		return TC_ACT_OK;
+	case XDP_TX:
+		return bpf_redirect(skb->ifindex, 0);
+	default:
+		return TC_ACT_SHOT;
+	}
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c b/tools/testing/selftests/bpf/xdp_synproxy.c
index 4653d4655b5f..d874ddfb39c4 100644
--- a/tools/testing/selftests/bpf/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/xdp_synproxy.c
@@ -18,16 +18,31 @@
 
 static unsigned int ifindex;
 static __u32 attached_prog_id;
+static bool attached_tc;
 
 static void noreturn cleanup(int sig)
 {
-	DECLARE_LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
+	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
 	int prog_fd;
 	int err;
 
 	if (attached_prog_id == 0)
 		exit(0);
 
+	if (attached_tc) {
+		LIBBPF_OPTS(bpf_tc_hook, hook,
+			    .ifindex = ifindex,
+			    .attach_point = BPF_TC_INGRESS);
+
+		err = bpf_tc_hook_destroy(&hook);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_tc_hook_destroy: %s\n", strerror(-err));
+			fprintf(stderr, "Failed to destroy the TC hook\n");
+			exit(1);
+		}
+		exit(0);
+	}
+
 	prog_fd = bpf_prog_get_fd_by_id(attached_prog_id);
 	if (prog_fd < 0) {
 		fprintf(stderr, "Error: bpf_prog_get_fd_by_id: %s\n", strerror(-prog_fd));
@@ -55,7 +70,7 @@ static void noreturn cleanup(int sig)
 
 static noreturn void usage(const char *progname)
 {
-	fprintf(stderr, "Usage: %s [--iface <iface>|--prog <prog_id>] [--mss4 <mss ipv4> --mss6 <mss ipv6> --wscale <wscale> --ttl <ttl>] [--ports <port1>,<port2>,...] [--single]\n",
+	fprintf(stderr, "Usage: %s [--iface <iface>|--prog <prog_id>] [--mss4 <mss ipv4> --mss6 <mss ipv6> --wscale <wscale> --ttl <ttl>] [--ports <port1>,<port2>,...] [--single] [--tc]\n",
 		progname);
 	exit(1);
 }
@@ -74,7 +89,7 @@ static unsigned long parse_arg_ul(const char *progname, const char *arg, unsigne
 }
 
 static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *prog_id,
-			  __u64 *tcpipopts, char **ports, bool *single)
+			  __u64 *tcpipopts, char **ports, bool *single, bool *tc)
 {
 	static struct option long_options[] = {
 		{ "help", no_argument, NULL, 'h' },
@@ -86,6 +101,7 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 		{ "ttl", required_argument, NULL, 't' },
 		{ "ports", required_argument, NULL, 'p' },
 		{ "single", no_argument, NULL, 's' },
+		{ "tc", no_argument, NULL, 'c' },
 		{ NULL, 0, NULL, 0 },
 	};
 	unsigned long mss4, mss6, wscale, ttl;
@@ -143,6 +159,9 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 		case 's':
 			*single = true;
 			break;
+		case 'c':
+			*tc = true;
+			break;
 		default:
 			usage(argv[0]);
 		}
@@ -164,7 +183,7 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
 		usage(argv[0]);
 }
 
-static int syncookie_attach(const char *argv0, unsigned int ifindex)
+static int syncookie_attach(const char *argv0, unsigned int ifindex, bool tc)
 {
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
@@ -188,9 +207,9 @@ static int syncookie_attach(const char *argv0, unsigned int ifindex)
 		return err;
 	}
 
-	prog = bpf_object__find_program_by_name(obj, "syncookie_xdp");
+	prog = bpf_object__find_program_by_name(obj, tc ? "syncookie_tc" : "syncookie_xdp");
 	if (!prog) {
-		fprintf(stderr, "Error: bpf_object__find_program_by_name: program syncookie_xdp was not found\n");
+		fprintf(stderr, "Error: bpf_object__find_program_by_name: program was not found\n");
 		return -ENOENT;
 	}
 
@@ -201,21 +220,50 @@ static int syncookie_attach(const char *argv0, unsigned int ifindex)
 		fprintf(stderr, "Error: bpf_obj_get_info_by_fd: %s\n", strerror(-err));
 		goto out;
 	}
+	attached_tc = tc;
 	attached_prog_id = info.id;
 	signal(SIGINT, cleanup);
 	signal(SIGTERM, cleanup);
-	err = bpf_xdp_attach(ifindex, prog_fd, XDP_FLAGS_UPDATE_IF_NOEXIST, NULL);
-	if (err < 0) {
-		fprintf(stderr, "Error: bpf_set_link_xdp_fd: %s\n", strerror(-err));
-		signal(SIGINT, SIG_DFL);
-		signal(SIGTERM, SIG_DFL);
-		attached_prog_id = 0;
-		goto out;
+	if (tc) {
+		LIBBPF_OPTS(bpf_tc_hook, hook,
+			    .ifindex = ifindex,
+			    .attach_point = BPF_TC_INGRESS);
+		LIBBPF_OPTS(bpf_tc_opts, opts,
+			    .handle = 1,
+			    .priority = 1,
+			    .prog_fd = prog_fd);
+
+		err = bpf_tc_hook_create(&hook);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_tc_hook_create: %s\n",
+				strerror(-err));
+			goto fail;
+		}
+		err = bpf_tc_attach(&hook, &opts);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_tc_attach: %s\n",
+				strerror(-err));
+			goto fail;
+		}
+
+	} else {
+		err = bpf_xdp_attach(ifindex, prog_fd,
+				     XDP_FLAGS_UPDATE_IF_NOEXIST, NULL);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_set_link_xdp_fd: %s\n",
+				strerror(-err));
+			goto fail;
+		}
 	}
 	err = 0;
 out:
 	bpf_object__close(obj);
 	return err;
+fail:
+	signal(SIGINT, SIG_DFL);
+	signal(SIGTERM, SIG_DFL);
+	attached_prog_id = 0;
+	goto out;
 }
 
 static int syncookie_open_bpf_maps(__u32 prog_id, int *values_map_fd, int *ports_map_fd)
@@ -248,11 +296,6 @@ static int syncookie_open_bpf_maps(__u32 prog_id, int *values_map_fd, int *ports
 		goto out;
 	}
 
-	if (prog_info.type != BPF_PROG_TYPE_XDP) {
-		fprintf(stderr, "Error: BPF prog type is not BPF_PROG_TYPE_XDP\n");
-		err = -ENOENT;
-		goto out;
-	}
 	if (prog_info.nr_map_ids < 2) {
 		fprintf(stderr, "Error: Found %u BPF maps, expected at least 2\n",
 			prog_info.nr_map_ids);
@@ -319,17 +362,22 @@ int main(int argc, char *argv[])
 	char *ports;
 	bool single;
 	int err = 0;
+	bool tc;
 
-	parse_options(argc, argv, &ifindex, &prog_id, &tcpipopts, &ports, &single);
+	parse_options(argc, argv, &ifindex, &prog_id, &tcpipopts, &ports,
+		      &single, &tc);
 
 	if (prog_id == 0) {
-		err = bpf_xdp_query_id(ifindex, 0, &prog_id);
-		if (err < 0) {
-			fprintf(stderr, "Error: bpf_get_link_xdp_id: %s\n", strerror(-err));
-			goto out;
+		if (!tc) {
+			err = bpf_xdp_query_id(ifindex, 0, &prog_id);
+			if (err < 0) {
+				fprintf(stderr, "Error: bpf_get_link_xdp_id: %s\n",
+					strerror(-err));
+				goto out;
+			}
 		}
 		if (prog_id == 0) {
-			err = syncookie_attach(argv[0], ifindex);
+			err = syncookie_attach(argv[0], ifindex, tc);
 			if (err < 0)
 				goto out;
 			prog_id = attached_prog_id;
-- 
2.30.2

