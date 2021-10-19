Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE9643392A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhJSOvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:51:37 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:41185
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232083AbhJSOve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:51:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH+Wy6KilA17Q48TJxJ9jnqf2nezTEledmQXQDr8MvTtsbed95MIP70MdRw0sXQGYDPTrpkNEhW+/+Db4Lr4NrU33a1VeOLeMQaIJSQOOQN07z3F9QjijJhLeIBJCyLXAbPRM5ZVaorSRMUQoaqEsjhd0M58v7wUw3czambVn1Ir609eJQaGuX+vXjh+7plSl0VKiqPQLxxlupt9wuCIHRcb61MA9gnCUse0JfH4UnSBU8KUO3xh6TQOjN9x7xl4S9fomPgPBaYEIFb3BuSU6uJBBKDJv2dzES4PB2gTSR0Q8bv6YUNE15rRFDOisBAhEMUyS0oXB+FGf96FZ/zleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uo2MfpkL9FH9uFS+cZvNfuJQN29/AiFpT59htLADEnI=;
 b=j5lhgl/wD5BWaqoO/3gR7XW67K6RnSjsIElpWvPPCxRsvVLAYVHXQsM5YZoahQOEmSewj6uT60S5Ig0PY+wS2cVbFEqSeuNU/RpWxdNT++VzV4laSo0RLP7YmQRP6iQYLNB11uSqdUH3Onuq0UtCSu0DfCId5+/3TpiyeKm2I6Rct5SFw2WMKTVszs/XO5hpC2IXVfOwqVN4KQeujad7VL11ziFCpUN8kZkl33Lw76CUfH32308sSBX1UdKH5FZzdsZkgUwlX2BJwqWm6Nmvs3pPBNuon4MhI3G4eBQZ1kJ1AEvBVlctZcg3dnwCaVOv4YBRKmI17R7EDjOGo6BCCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uo2MfpkL9FH9uFS+cZvNfuJQN29/AiFpT59htLADEnI=;
 b=Bkzx7y6ISteSQ6L6GgGXi/6uW4O15yi53gJtG+TRlOh0Sg8Mf9sR/Wm9GlyeYhJxLjiER8DLdtm3lEixKgAzhVZWQw9NJD3QtHfcHGuDmK6YazmbKkNfb8h0tsy5855b3NuayAfrYgPsb/MYUarkWWtzaP8naz9sP3CNVp4BAzMGocRZzNCVhHZnsuwfk6Zy1b749Iy2dP0Sw4NLcMUjYJ0YSYkQs60Sbf73SGw3ZDzJf0gQfg7Mdn/IAPr9Qi7r985OwYuAO/ATj4gfumxArbuSCrx5kRx9uKuUCpEEcM5f/N9lh3godslLhmUdXXr6SEYo9gzmiS9cWyE9hY3L5A==
Received: from CO2PR05CA0100.namprd05.prod.outlook.com (2603:10b6:104:1::26)
 by CY4PR12MB1671.namprd12.prod.outlook.com (2603:10b6:910:c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 14:49:19 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::f4) by CO2PR05CA0100.outlook.office365.com
 (2603:10b6:104:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend
 Transport; Tue, 19 Oct 2021 14:49:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:49:18 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 14:49:17 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:49:05 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        "Lorenz Bauer" <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next 10/10] bpf: Add sample for raw syncookie helpers
Date:   Tue, 19 Oct 2021 17:46:55 +0300
Message-ID: <20211019144655.3483197-11-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 084375a6-913c-4fe2-d922-08d9930fa142
X-MS-TrafficTypeDiagnostic: CY4PR12MB1671:
X-Microsoft-Antispam-PRVS: <CY4PR12MB16716443012B86AF656A934ADCBD9@CY4PR12MB1671.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:127;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sRUvwRbcRXlQ7dqU0aYZicaOatu1sOXDrvD5qCdBzbWyFtZ/QmtM5wA08X7KhbIprJNnnbz/52Q+mspS061H1MJvOdmKe/+ES3g+8slkvWZajfPT+Lg9neaFQaQ8HmqpAir5v4cRM83gs/zXCU5ee77N6infsTcxbzfl6M4NMI7oVRRHSHPEZvAPBmqAyQvSYlhmc56+MTMtO/xhdVDsmrwPhP7g0Wmxxr+Ny8j+OEfY1LXM0V4oxRQ/3VTf6rPUEEpXhLBAkI6zJYcEoB4BZ9bNmur4Z4+SRFs17/SH6VJPXL2EHCBXut3/o4XK4gZAMwE5FtXJpr6lIIP9gsPeoA7m0R04nYtA6yw9XQ8j8Ls1kOu6EzX+953hJTlUUQT2r2761Cczp2QaZnl7o4bLKLP8WlmWgVhJrvpZ2pKwwd/6SqNM1imkCtnxs0J7oAtD0sXzrB01+TNMtonVtJ6NTAnHIWk6+WVvjwmMrRT0VCH4/zx3HgKTloai+JhsSTiKtHm3dxvtdosu9C+UqD3YjE3YTfV5Wd3GU8aqDfgw78+rP9yP+EyFvhdNCK7JERtTQrV08ub5yfs7+gOzgcdPZSqBkVRXpNzGovo7Lt2GxVTYzmrZvhxrRI5g5XWPw8GWo8XdxRAayLI62x43P/9/7FjZaby3qLUYDdQV6v+hB39A6ArO/9FBPEzu8in9ACG33fQI/Ntw81XnDdoFw02XV0ciunMTsEXSnqI2JRczVrn5lC9pi32BbGuhSWycSK5R7JYnfou877KcfopGhN+PKR7cR3H79JpVT6Jbtnt1aNBaXXbsLC7sg2pllMGPrHna
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(6019001)(4636009)(46966006)(36840700001)(26005)(7696005)(356005)(82310400003)(107886003)(30864003)(83380400001)(70586007)(1076003)(186003)(70206006)(2616005)(36756003)(7416002)(86362001)(6666004)(4326008)(47076005)(508600001)(316002)(36906005)(8676002)(110136005)(54906003)(7636003)(2906002)(36860700001)(336012)(426003)(5660300002)(8936002)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:49:18.7601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 084375a6-913c-4fe2-d922-08d9930fa142
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1671
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a sample for the new BPF helpers: bpf_ct_lookup_tcp,
bpf_tcp_raw_gen_syncookie and bpf_tcp_raw_check_syncookie.

samples/bpf/syncookie_kern.c is a BPF program that generates SYN cookies
on allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
iptables module.

samples/bpf/syncookie_user.c is a userspace control application that
allows to configure the following options in runtime: list of allowed
ports, MSS, window scale, TTL.

samples/bpf/syncookie_test.sh is a script that demonstrates the setup of
synproxy with XDP acceleration.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 samples/bpf/.gitignore        |   1 +
 samples/bpf/Makefile          |   3 +
 samples/bpf/syncookie_kern.c  | 591 ++++++++++++++++++++++++++++++++++
 samples/bpf/syncookie_test.sh |  55 ++++
 samples/bpf/syncookie_user.c  | 388 ++++++++++++++++++++++
 5 files changed, 1038 insertions(+)
 create mode 100644 samples/bpf/syncookie_kern.c
 create mode 100755 samples/bpf/syncookie_test.sh
 create mode 100644 samples/bpf/syncookie_user.c

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0e7bfdbff80a..6b74e835d323 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -61,3 +61,4 @@ iperf.*
 /vmlinux.h
 /bpftool/
 /libbpf/
+syncookie
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4c5ad15f8d28..59d90c76bfea 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += syncookie
 
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_redirect_map_multi
@@ -118,6 +119,7 @@ task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
+syncookie-objs := syncookie_user.o
 
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o $(XDP_SAMPLE)
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
@@ -181,6 +183,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += syncookie_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/syncookie_kern.c b/samples/bpf/syncookie_kern.c
new file mode 100644
index 000000000000..b581ae30b650
--- /dev/null
+++ b/samples/bpf/syncookie_kern.c
@@ -0,0 +1,591 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <stdbool.h>
+#include <stddef.h>
+
+#include <uapi/linux/errno.h>
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/pkt_cls.h>
+#include <uapi/linux/if_ether.h>
+#include <uapi/linux/in.h>
+#include <uapi/linux/ip.h>
+#include <uapi/linux/ipv6.h>
+#include <uapi/linux/tcp.h>
+#include <uapi/linux/netfilter/nf_conntrack_common.h>
+#include <linux/minmax.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define DEFAULT_MSS4 1460
+#define DEFAULT_MSS6 1440
+#define DEFAULT_WSCALE 7
+#define DEFAULT_TTL 64
+#define MAX_ALLOWED_PORTS 8
+
+struct bpf_map_def SEC("maps") values = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u64),
+	.max_entries = 2,
+};
+
+struct bpf_map_def SEC("maps") allowed_ports = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u16),
+	.max_entries = MAX_ALLOWED_PORTS,
+};
+
+#define IP_DF 0x4000
+#define IP_MF 0x2000
+#define IP_OFFSET 0x1fff
+
+#define NEXTHDR_TCP 6
+
+#define TCPOPT_NOP 1
+#define TCPOPT_EOL 0
+#define TCPOPT_MSS 2
+#define TCPOPT_WINDOW 3
+#define TCPOPT_SACK_PERM 4
+#define TCPOPT_TIMESTAMP 8
+
+#define TCPOLEN_MSS 4
+#define TCPOLEN_WINDOW 3
+#define TCPOLEN_SACK_PERM 2
+#define TCPOLEN_TIMESTAMP 10
+
+#define IPV4_MAXLEN 60
+#define TCP_MAXLEN 60
+
+static __always_inline void swap_eth_addr(__u8 *a, __u8 *b)
+{
+	__u8 tmp[ETH_ALEN];
+
+	__builtin_memcpy(tmp, a, ETH_ALEN);
+	__builtin_memcpy(a, b, ETH_ALEN);
+	__builtin_memcpy(b, tmp, ETH_ALEN);
+}
+
+static __always_inline __u16 csum_fold(__u32 csum)
+{
+	csum = (csum & 0xffff) + (csum >> 16);
+	csum = (csum & 0xffff) + (csum >> 16);
+	return (__u16)~csum;
+}
+
+static __always_inline __u16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+					       __u32 len, __u8 proto,
+					       __u32 csum)
+{
+	__u64 s = csum;
+
+	s += (__u32)saddr;
+	s += (__u32)daddr;
+#if defined(__BIG_ENDIAN__)
+	s += proto + len;
+#elif defined(__LITTLE_ENDIAN__)
+	s += (proto + len) << 8;
+#else
+#error Unknown endian
+#endif
+	s = (s & 0xffffffff) + (s >> 32);
+	s = (s & 0xffffffff) + (s >> 32);
+
+	return csum_fold((__u32)s);
+}
+
+static __always_inline __u16 csum_ipv6_magic(const struct in6_addr *saddr,
+					     const struct in6_addr *daddr,
+					     __u32 len, __u8 proto, __u32 csum)
+{
+	__u64 sum = csum;
+	int i;
+
+#pragma unroll
+	for (i = 0; i < 4; i++)
+		sum += (__u32)saddr->s6_addr32[i];
+
+#pragma unroll
+	for (i = 0; i < 4; i++)
+		sum += (__u32)daddr->s6_addr32[i];
+
+	// Don't combine additions to avoid 32-bit overflow.
+	sum += bpf_htonl(len);
+	sum += bpf_htonl(proto);
+
+	sum = (sum & 0xffffffff) + (sum >> 32);
+	sum = (sum & 0xffffffff) + (sum >> 32);
+
+	return csum_fold((__u32)sum);
+}
+
+static __always_inline void values_get_tcpipopts(__u16 *mss, __u8 *wscale,
+						 __u8 *ttl, bool ipv6)
+{
+	__u32 key = 0;
+	__u64 *value;
+
+	value = bpf_map_lookup_elem(&values, &key);
+	if (value && *value != 0) {
+		if (ipv6)
+			*mss = (*value >> 32) & 0xffff;
+		else
+			*mss = *value & 0xffff;
+		*wscale = (*value >> 16) & 0xf;
+		*ttl = (*value >> 24) & 0xff;
+		return;
+	}
+
+	*mss = ipv6 ? DEFAULT_MSS6 : DEFAULT_MSS4;
+	*wscale = DEFAULT_WSCALE;
+	*ttl = DEFAULT_TTL;
+}
+
+static __always_inline void values_inc_synacks(void)
+{
+	__u32 key = 1;
+	__u32 *value;
+
+	value = bpf_map_lookup_elem(&values, &key);
+	if (value)
+		__sync_fetch_and_add(value, 1);
+}
+
+static __always_inline bool check_port_allowed(__u16 port)
+{
+	__u32 i;
+
+	for (i = 0; i < MAX_ALLOWED_PORTS; i++) {
+		__u32 key = i;
+		__u16 *value;
+
+		value = bpf_map_lookup_elem(&allowed_ports, &key);
+
+		if (!value)
+			break;
+		// 0 is a terminator value. Check it first to avoid matching on
+		// a forbidden port == 0 and returning true.
+		if (*value == 0)
+			break;
+
+		if (*value == port)
+			return true;
+	}
+
+	return false;
+}
+
+struct header_pointers {
+	struct ethhdr *eth;
+	struct iphdr *ipv4;
+	struct ipv6hdr *ipv6;
+	struct tcphdr *tcp;
+	__u16 tcp_len;
+};
+
+static __always_inline int tcp_dissect(void *data, void *data_end,
+				       struct header_pointers *hdr)
+{
+	hdr->eth = data;
+	if (hdr->eth + 1 > data_end)
+		return XDP_DROP;
+
+	switch (bpf_ntohs(hdr->eth->h_proto)) {
+	case ETH_P_IP:
+		hdr->ipv6 = NULL;
+
+		hdr->ipv4 = (void *)hdr->eth + sizeof(*hdr->eth);
+		if (hdr->ipv4 + 1 > data_end)
+			return XDP_DROP;
+		if (hdr->ipv4->ihl * 4 < sizeof(*hdr->ipv4))
+			return XDP_DROP;
+		if (hdr->ipv4->version != 4)
+			return XDP_DROP;
+
+		if (hdr->ipv4->protocol != IPPROTO_TCP)
+			return XDP_PASS;
+
+		hdr->tcp = (void *)hdr->ipv4 + hdr->ipv4->ihl * 4;
+		break;
+	case ETH_P_IPV6:
+		hdr->ipv4 = NULL;
+
+		hdr->ipv6 = (void *)hdr->eth + sizeof(*hdr->eth);
+		if (hdr->ipv6 + 1 > data_end)
+			return XDP_DROP;
+		if (hdr->ipv6->version != 6)
+			return XDP_DROP;
+
+		// XXX: Extension headers are not supported and could circumvent
+		// XDP SYN flood protection.
+		if (hdr->ipv6->nexthdr != NEXTHDR_TCP)
+			return XDP_PASS;
+
+		hdr->tcp = (void *)hdr->ipv6 + sizeof(*hdr->ipv6);
+		break;
+	default:
+		// XXX: VLANs will circumvent XDP SYN flood protection.
+		return XDP_PASS;
+	}
+
+	if (hdr->tcp + 1 > data_end)
+		return XDP_DROP;
+	hdr->tcp_len = hdr->tcp->doff * 4;
+	if (hdr->tcp_len < sizeof(*hdr->tcp))
+		return XDP_DROP;
+
+	return XDP_TX;
+}
+
+static __always_inline __u8 tcp_mkoptions(__be32 *buf, __be32 *tsopt, __u16 mss,
+					  __u8 wscale)
+{
+	__be32 *start = buf;
+
+	*buf++ = bpf_htonl((TCPOPT_MSS << 24) | (TCPOLEN_MSS << 16) | mss);
+
+	if (!tsopt)
+		return buf - start;
+
+	if (tsopt[0] & bpf_htonl(1 << 4))
+		*buf++ = bpf_htonl((TCPOPT_SACK_PERM << 24) |
+				   (TCPOLEN_SACK_PERM << 16) |
+				   (TCPOPT_TIMESTAMP << 8) |
+				   TCPOLEN_TIMESTAMP);
+	else
+		*buf++ = bpf_htonl((TCPOPT_NOP << 24) |
+				   (TCPOPT_NOP << 16) |
+				   (TCPOPT_TIMESTAMP << 8) |
+				   TCPOLEN_TIMESTAMP);
+	*buf++ = tsopt[0];
+	*buf++ = tsopt[1];
+
+	if ((tsopt[0] & bpf_htonl(0xf)) != bpf_htonl(0xf))
+		*buf++ = bpf_htonl((TCPOPT_NOP << 24) |
+				   (TCPOPT_WINDOW << 16) |
+				   (TCPOLEN_WINDOW << 8) |
+				   wscale);
+
+	return buf - start;
+}
+
+static __always_inline void tcp_gen_synack(struct tcphdr *tcp_header,
+					   __u32 cookie, __be32 *tsopt,
+					   __u16 mss, __u8 wscale)
+{
+	void *tcp_options;
+
+	tcp_flag_word(tcp_header) = TCP_FLAG_SYN | TCP_FLAG_ACK;
+	if (tsopt && (tsopt[0] & bpf_htonl(1 << 5)))
+		tcp_flag_word(tcp_header) |= TCP_FLAG_ECE;
+	tcp_header->doff = 5; // doff is part of tcp_flag_word.
+	swap(tcp_header->source, tcp_header->dest);
+	tcp_header->ack_seq = bpf_htonl(bpf_ntohl(tcp_header->seq) + 1);
+	tcp_header->seq = bpf_htonl(cookie);
+	tcp_header->window = 0;
+	tcp_header->urg_ptr = 0;
+	tcp_header->check = 0; // Rely on hardware checksum offload.
+
+	tcp_options = (void *)(tcp_header + 1);
+	tcp_header->doff += tcp_mkoptions(tcp_options, tsopt, mss, wscale);
+}
+
+static __always_inline void tcpv4_gen_synack(struct header_pointers *hdr,
+					     __u32 cookie, __be32 *tsopt)
+{
+	__u8 wscale;
+	__u16 mss;
+	__u8 ttl;
+
+	values_get_tcpipopts(&mss, &wscale, &ttl, false);
+
+	swap_eth_addr(hdr->eth->h_source, hdr->eth->h_dest);
+
+	swap(hdr->ipv4->saddr, hdr->ipv4->daddr);
+	hdr->ipv4->check = 0; // Rely on hardware checksum offload.
+	hdr->ipv4->tos = 0;
+	hdr->ipv4->id = 0;
+	hdr->ipv4->ttl = ttl;
+
+	tcp_gen_synack(hdr->tcp, cookie, tsopt, mss, wscale);
+
+	hdr->tcp_len = hdr->tcp->doff * 4;
+	hdr->ipv4->tot_len = bpf_htons(sizeof(*hdr->ipv4) + hdr->tcp_len);
+}
+
+static __always_inline void tcpv6_gen_synack(struct header_pointers *hdr,
+					     __u32 cookie, __be32 *tsopt)
+{
+	__u8 wscale;
+	__u16 mss;
+	__u8 ttl;
+
+	values_get_tcpipopts(&mss, &wscale, &ttl, true);
+
+	swap_eth_addr(hdr->eth->h_source, hdr->eth->h_dest);
+
+	swap(hdr->ipv6->saddr, hdr->ipv6->daddr);
+	*(__be32 *)hdr->ipv6 = bpf_htonl(0x60000000);
+	hdr->ipv6->hop_limit = ttl;
+
+	tcp_gen_synack(hdr->tcp, cookie, tsopt, mss, wscale);
+
+	hdr->tcp_len = hdr->tcp->doff * 4;
+	hdr->ipv6->payload_len = bpf_htons(hdr->tcp_len);
+}
+
+static __always_inline int syncookie_handle_syn(struct header_pointers *hdr,
+						struct xdp_md *ctx,
+						void *data, void *data_end)
+{
+	__u32 old_pkt_size, new_pkt_size;
+	// Unlike clang 10, clang 11 and 12 generate code that doesn't pass the
+	// BPF verifier if tsopt is not volatile. Volatile forces it to store
+	// the pointer value and use it directly, otherwise tcp_mkoptions is
+	// (mis)compiled like this:
+	//   if (!tsopt)
+	//       return buf - start;
+	//   reg = stored_return_value_of_bpf_tcp_raw_gen_tscookie;
+	//   if (reg == 0)
+	//       tsopt = tsopt_buf;
+	//   else
+	//       tsopt = NULL;
+	//   ...
+	//   *buf++ = tsopt[1];
+	// It creates a dead branch where tsopt is assigned NULL, but the
+	// verifier can't prove it's dead and blocks the program.
+	__be32 * volatile tsopt = NULL;
+	__be32 tsopt_buf[2];
+	void *ip_header;
+	__u16 ip_len;
+	__u32 cookie;
+	__s64 value;
+
+	if (hdr->ipv4) {
+		// Check the IPv4 and TCP checksums before creating a SYNACK.
+		value = bpf_csum_diff(0, 0, (void *)hdr->ipv4, hdr->ipv4->ihl * 4, 0);
+		if (value < 0)
+			return XDP_ABORTED;
+		if (csum_fold(value) != 0)
+			return XDP_DROP; // Bad IPv4 checksum.
+
+		value = bpf_csum_diff(0, 0, (void *)hdr->tcp, hdr->tcp_len, 0);
+		if (value < 0)
+			return XDP_ABORTED;
+		if (csum_tcpudp_magic(hdr->ipv4->saddr, hdr->ipv4->daddr,
+				      hdr->tcp_len, IPPROTO_TCP, value) != 0)
+			return XDP_DROP; // Bad TCP checksum.
+
+		ip_header = hdr->ipv4;
+		ip_len = sizeof(*hdr->ipv4);
+	} else if (hdr->ipv6) {
+		// Check the TCP checksum before creating a SYNACK.
+		value = bpf_csum_diff(0, 0, (void *)hdr->tcp, hdr->tcp_len, 0);
+		if (value < 0)
+			return XDP_ABORTED;
+		if (csum_ipv6_magic(&hdr->ipv6->saddr, &hdr->ipv6->daddr,
+				    hdr->tcp_len, IPPROTO_TCP, value) != 0)
+			return XDP_DROP; // Bad TCP checksum.
+
+		ip_header = hdr->ipv6;
+		ip_len = sizeof(*hdr->ipv6);
+	} else {
+		return XDP_ABORTED;
+	}
+
+	// Issue SYN cookies on allowed ports, drop SYN packets on
+	// blocked ports.
+	if (!check_port_allowed(bpf_ntohs(hdr->tcp->dest)))
+		return XDP_DROP;
+
+	value = bpf_tcp_raw_gen_syncookie(ip_header, ip_len,
+					  (void *)hdr->tcp, hdr->tcp_len);
+	if (value < 0)
+		return XDP_ABORTED;
+	cookie = (__u32)value;
+
+	if (bpf_tcp_raw_gen_tscookie((void *)hdr->tcp, hdr->tcp_len,
+				     tsopt_buf, sizeof(tsopt_buf)) == 0)
+		tsopt = tsopt_buf;
+
+	// Check that there is enough space for a SYNACK. It also covers
+	// the check that the destination of the __builtin_memmove below
+	// doesn't overflow.
+	if (data + sizeof(*hdr->eth) + ip_len + TCP_MAXLEN > data_end)
+		return XDP_ABORTED;
+
+	if (hdr->ipv4) {
+		if (hdr->ipv4->ihl * 4 > sizeof(*hdr->ipv4)) {
+			struct tcphdr *new_tcp_header;
+
+			new_tcp_header = data + sizeof(*hdr->eth) + sizeof(*hdr->ipv4);
+			__builtin_memmove(new_tcp_header, hdr->tcp, sizeof(*hdr->tcp));
+			hdr->tcp = new_tcp_header;
+
+			hdr->ipv4->ihl = sizeof(*hdr->ipv4) / 4;
+		}
+
+		tcpv4_gen_synack(hdr, cookie, tsopt);
+	} else if (hdr->ipv6) {
+		tcpv6_gen_synack(hdr, cookie, tsopt);
+	} else {
+		return XDP_ABORTED;
+	}
+
+	// Recalculate checksums.
+	hdr->tcp->check = 0;
+	value = bpf_csum_diff(0, 0, (void *)hdr->tcp, hdr->tcp_len, 0);
+	if (value < 0)
+		return XDP_ABORTED;
+	if (hdr->ipv4) {
+		hdr->tcp->check = csum_tcpudp_magic(hdr->ipv4->saddr,
+						    hdr->ipv4->daddr,
+						    hdr->tcp_len,
+						    IPPROTO_TCP,
+						    value);
+
+		hdr->ipv4->check = 0;
+		value = bpf_csum_diff(0, 0, (void *)hdr->ipv4, sizeof(*hdr->ipv4), 0);
+		if (value < 0)
+			return XDP_ABORTED;
+		hdr->ipv4->check = csum_fold(value);
+	} else if (hdr->ipv6) {
+		hdr->tcp->check = csum_ipv6_magic(&hdr->ipv6->saddr,
+						  &hdr->ipv6->daddr,
+						  hdr->tcp_len,
+						  IPPROTO_TCP,
+						  value);
+	} else {
+		return XDP_ABORTED;
+	}
+
+	// Set the new packet size.
+	old_pkt_size = data_end - data;
+	new_pkt_size = sizeof(*hdr->eth) + ip_len + hdr->tcp->doff * 4;
+	if (bpf_xdp_adjust_tail(ctx, new_pkt_size - old_pkt_size))
+		return XDP_ABORTED;
+
+	values_inc_synacks();
+
+	return XDP_TX;
+}
+
+static __always_inline int syncookie_handle_ack(struct header_pointers *hdr)
+{
+	int err;
+
+	if (hdr->ipv4)
+		err = bpf_tcp_raw_check_syncookie(hdr->ipv4, sizeof(*hdr->ipv4),
+						  (void *)hdr->tcp, hdr->tcp_len);
+	else if (hdr->ipv6)
+		err = bpf_tcp_raw_check_syncookie(hdr->ipv6, sizeof(*hdr->ipv6),
+						  (void *)hdr->tcp, hdr->tcp_len);
+	else
+		return XDP_ABORTED;
+	if (err)
+		return XDP_DROP;
+
+	return XDP_PASS;
+}
+
+SEC("xdp/syncookie")
+int syncookie_xdp(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct header_pointers hdr;
+	struct bpf_sock_tuple tup;
+	struct bpf_nf_conn *ct;
+	__u32 tup_size;
+	__s64 value;
+	int ret;
+
+	ret = tcp_dissect(data, data_end, &hdr);
+	if (ret != XDP_TX)
+		return ret;
+
+	if (hdr.ipv4) {
+		// TCP doesn't normally use fragments, and XDP can't reassemble them.
+		if ((hdr.ipv4->frag_off & bpf_htons(IP_DF | IP_MF | IP_OFFSET)) != bpf_htons(IP_DF))
+			return XDP_DROP;
+
+		tup.ipv4.saddr = hdr.ipv4->saddr;
+		tup.ipv4.daddr = hdr.ipv4->daddr;
+		tup.ipv4.sport = hdr.tcp->source;
+		tup.ipv4.dport = hdr.tcp->dest;
+		tup_size = sizeof(tup.ipv4);
+	} else if (hdr.ipv6) {
+		__builtin_memcpy(tup.ipv6.saddr, &hdr.ipv6->saddr, sizeof(tup.ipv6.saddr));
+		__builtin_memcpy(tup.ipv6.daddr, &hdr.ipv6->daddr, sizeof(tup.ipv6.daddr));
+		tup.ipv6.sport = hdr.tcp->source;
+		tup.ipv6.dport = hdr.tcp->dest;
+		tup_size = sizeof(tup.ipv6);
+	} else {
+		// The verifier can't track that either ipv4 or ipv6 is not NULL.
+		return XDP_ABORTED;
+	}
+
+	value = 0; // Flags.
+	ct = bpf_ct_lookup_tcp(ctx, &tup, tup_size, BPF_F_CURRENT_NETNS, &value);
+	if (ct) {
+		unsigned long status = ct->status;
+
+		bpf_ct_release(ct);
+		if (status & IPS_CONFIRMED_BIT)
+			return XDP_PASS;
+	} else if (value != -ENOENT) {
+		return XDP_ABORTED;
+	}
+
+	// value == -ENOENT || !(status & IPS_CONFIRMED_BIT)
+
+	if ((hdr.tcp->syn ^ hdr.tcp->ack) != 1)
+		return XDP_DROP;
+
+	// Grow the TCP header to TCP_MAXLEN to be able to pass any hdr.tcp_len
+	// to bpf_tcp_raw_gen_syncookie and pass the verifier.
+	if (bpf_xdp_adjust_tail(ctx, TCP_MAXLEN - hdr.tcp_len))
+		return XDP_ABORTED;
+
+	data_end = (void *)(long)ctx->data_end;
+	data = (void *)(long)ctx->data;
+
+	if (hdr.ipv4) {
+		hdr.eth = data;
+		hdr.ipv4 = (void *)hdr.eth + sizeof(*hdr.eth);
+		// IPV4_MAXLEN is needed when calculating checksum.
+		// At least sizeof(struct iphdr) is needed here to access ihl.
+		if ((void *)hdr.ipv4 + IPV4_MAXLEN > data_end)
+			return XDP_ABORTED;
+		hdr.tcp = (void *)hdr.ipv4 + hdr.ipv4->ihl * 4;
+	} else if (hdr.ipv6) {
+		hdr.eth = data;
+		hdr.ipv6 = (void *)hdr.eth + sizeof(*hdr.eth);
+		hdr.tcp = (void *)hdr.ipv6 + sizeof(*hdr.ipv6);
+	} else {
+		return XDP_ABORTED;
+	}
+
+	if ((void *)hdr.tcp + TCP_MAXLEN > data_end)
+		return XDP_ABORTED;
+
+	// We run out of registers, tcp_len gets spilled to the stack, and the
+	// verifier forgets its min and max values checked above in tcp_dissect.
+	hdr.tcp_len = hdr.tcp->doff * 4;
+	if (hdr.tcp_len < sizeof(*hdr.tcp))
+		return XDP_ABORTED;
+
+	return hdr.tcp->syn ? syncookie_handle_syn(&hdr, ctx, data, data_end) :
+			      syncookie_handle_ack(&hdr);
+}
+
+SEC("xdp/dummy")
+int dummy_xdp(struct xdp_md *ctx)
+{
+	// veth requires XDP programs to be set on both sides.
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/syncookie_test.sh b/samples/bpf/syncookie_test.sh
new file mode 100755
index 000000000000..923f94a7d6f6
--- /dev/null
+++ b/samples/bpf/syncookie_test.sh
@@ -0,0 +1,55 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+set -e
+
+PORT=8080
+
+DIR="$(dirname "$0")"
+SERVER_PID=
+MONITOR_PID=
+
+cleanup() {
+	set +e
+	[ -n "$SERVER_PID" ] && kill "$SERVER_PID"
+	[ -n "$MONITOR_PID" ] && kill "$MONITOR_PID"
+	ip link del tmp0
+	ip netns del synproxy
+}
+
+trap cleanup EXIT
+
+ip netns add synproxy
+ip netns exec synproxy ip link set lo up
+ip link add tmp0 type veth peer name tmp1
+sleep 1 # Wait, otherwise the IP address is not applied to tmp0.
+ip link set tmp1 netns synproxy
+ip link set tmp0 up
+ip addr replace 198.18.0.1/24 dev tmp0
+ip netns exec synproxy ip link set tmp1 up
+ip netns exec synproxy ip addr replace 198.18.0.2/24 dev tmp1
+ip netns exec synproxy sysctl -w net.ipv4.tcp_syncookies=2
+ip netns exec synproxy sysctl -w net.ipv4.tcp_timestamps=1
+ip netns exec synproxy sysctl -w net.netfilter.nf_conntrack_tcp_loose=0
+ip netns exec synproxy iptables -t raw -I PREROUTING \
+	-i tmp1 -p tcp -m tcp --syn --dport "$PORT" -j CT --notrack
+ip netns exec synproxy iptables -t filter -A INPUT \
+	-i tmp1 -p tcp -m tcp --dport "$PORT" -m state --state INVALID,UNTRACKED \
+	-j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
+ip netns exec synproxy iptables -t filter -A INPUT \
+	-i tmp1 -m state --state INVALID -j DROP
+# When checksum offload is enabled, the XDP program sees wrong checksums and
+# drops packets.
+ethtool -K tmp0 tx off
+# Workaround required for veth.
+ip link set tmp0 xdp object "$DIR/syncookie_kern.o" section xdp/dummy
+ip netns exec synproxy "$DIR/syncookie" --iface tmp1 --ports "$PORT" \
+	--mss4 1460 --mss6 1440 --wscale 7 --ttl 64 &
+MONITOR_PID="$!"
+ip netns exec synproxy python3 -m http.server "$PORT" &
+SERVER_PID="$!"
+echo "Waiting a few seconds for the server to start..."
+sleep 5
+wget 'http://198.18.0.2:8080/' -O /dev/null -o /dev/null
+sleep 1 # Wait for stats to appear.
diff --git a/samples/bpf/syncookie_user.c b/samples/bpf/syncookie_user.c
new file mode 100644
index 000000000000..dcb074405691
--- /dev/null
+++ b/samples/bpf/syncookie_user.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include <stdnoreturn.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <signal.h>
+#include <sys/types.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <net/if.h>
+#include <linux/if_link.h>
+#include <linux/limits.h>
+
+static unsigned int ifindex;
+static __u32 attached_prog_id;
+
+static void noreturn cleanup(int sig)
+{
+	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts);
+	int prog_fd;
+	int err;
+
+	if (attached_prog_id == 0)
+		exit(0);
+
+	prog_fd = bpf_prog_get_fd_by_id(attached_prog_id);
+	if (prog_fd < 0) {
+		fprintf(stderr, "Error: bpf_prog_get_fd_by_id: %s\n", strerror(-prog_fd));
+		err = bpf_set_link_xdp_fd(ifindex, -1, 0);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_set_link_xdp_fd: %s\n", strerror(-err));
+			fprintf(stderr, "Failed to detach XDP program\n");
+			exit(1);
+		}
+	} else {
+		opts.old_fd = prog_fd;
+		err = bpf_set_link_xdp_fd_opts(ifindex, -1, XDP_FLAGS_REPLACE, &opts);
+		close(prog_fd);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_set_link_xdp_fd_opts: %s\n", strerror(-err));
+			// Not an error if already replaced by someone else.
+			if (err != -EEXIST) {
+				fprintf(stderr, "Failed to detach XDP program\n");
+				exit(1);
+			}
+		}
+	}
+	exit(0);
+}
+
+static noreturn void usage(const char *progname)
+{
+	fprintf(stderr, "Usage: %s [--iface <iface>|--prog <prog_id>] [--mss4 <mss ipv4> --mss6 <mss ipv6> --wscale <wscale> --ttl <ttl>] [--ports <port1>,<port2>,...]\n",
+		progname);
+	exit(1);
+}
+
+static unsigned long parse_arg_ul(const char *progname, const char *arg, unsigned long limit)
+{
+	unsigned long res;
+	char *endptr;
+
+	errno = 0;
+	res = strtoul(arg, &endptr, 10);
+	if (errno != 0 || *endptr != '\0' || arg[0] == '\0' || res > limit)
+		usage(progname);
+
+	return res;
+}
+
+static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *prog_id,
+			  __u64 *tcpipopts, char **ports)
+{
+	static struct option long_options[] = {
+		{ "help", no_argument, NULL, 'h' },
+		{ "iface", required_argument, NULL, 'i' },
+		{ "prog", required_argument, NULL, 'x' },
+		{ "mss4", required_argument, NULL, 4 },
+		{ "mss6", required_argument, NULL, 6 },
+		{ "wscale", required_argument, NULL, 'w' },
+		{ "ttl", required_argument, NULL, 't' },
+		{ "ports", required_argument, NULL, 'p' },
+		{ NULL, 0, NULL, 0 },
+	};
+	unsigned long mss4, mss6, wscale, ttl;
+	unsigned int tcpipopts_mask = 0;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	*ifindex = 0;
+	*prog_id = 0;
+	*tcpipopts = 0;
+	*ports = 0;
+
+	while (true) {
+		int opt;
+
+		opt = getopt_long(argc, argv, "", long_options, NULL);
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'h':
+			usage(argv[0]);
+			break;
+		case 'i':
+			*ifindex = if_nametoindex(optarg);
+			if (*ifindex == 0)
+				usage(argv[0]);
+			break;
+		case 'x':
+			*prog_id = parse_arg_ul(argv[0], optarg, UINT32_MAX);
+			if (*prog_id == 0)
+				usage(argv[0]);
+			break;
+		case 4:
+			mss4 = parse_arg_ul(argv[0], optarg, UINT16_MAX);
+			tcpipopts_mask |= 1 << 0;
+			break;
+		case 6:
+			mss6 = parse_arg_ul(argv[0], optarg, UINT16_MAX);
+			tcpipopts_mask |= 1 << 1;
+			break;
+		case 'w':
+			wscale = parse_arg_ul(argv[0], optarg, 14);
+			tcpipopts_mask |= 1 << 2;
+			break;
+		case 't':
+			ttl = parse_arg_ul(argv[0], optarg, UINT8_MAX);
+			tcpipopts_mask |= 1 << 3;
+			break;
+		case 'p':
+			*ports = optarg;
+			break;
+		default:
+			usage(argv[0]);
+		}
+	}
+	if (optind < argc)
+		usage(argv[0]);
+
+	if (tcpipopts_mask == 0xf) {
+		if (mss4 == 0 || mss6 == 0 || wscale == 0 || ttl == 0)
+			usage(argv[0]);
+		*tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
+	} else if (tcpipopts_mask != 0) {
+		usage(argv[0]);
+	}
+
+	if (*ifindex != 0 && *prog_id != 0)
+		usage(argv[0]);
+	if (*ifindex == 0 && *prog_id == 0)
+		usage(argv[0]);
+}
+
+static int syncookie_attach(const char *argv0, unsigned int ifindex)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	char xdp_filename[PATH_MAX];
+	struct bpf_object *obj;
+	int prog_fd;
+	int err;
+
+	snprintf(xdp_filename, sizeof(xdp_filename), "%s_kern.o", argv0);
+	err = bpf_prog_load(xdp_filename, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (err < 0) {
+		fprintf(stderr, "Error: bpf_prog_load: %s\n", strerror(-err));
+		return err;
+	}
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	if (err < 0) {
+		fprintf(stderr, "Error: bpf_obj_get_info_by_fd: %s\n", strerror(-err));
+		goto out;
+	}
+	attached_prog_id = info.id;
+	signal(SIGINT, cleanup);
+	signal(SIGTERM, cleanup);
+	err = bpf_set_link_xdp_fd(ifindex, prog_fd, XDP_FLAGS_UPDATE_IF_NOEXIST);
+	if (err < 0) {
+		fprintf(stderr, "Error: bpf_set_link_xdp_fd: %s\n", strerror(-err));
+		signal(SIGINT, SIG_DFL);
+		signal(SIGTERM, SIG_DFL);
+		attached_prog_id = 0;
+		goto out;
+	}
+	err = 0;
+out:
+	bpf_object__close(obj);
+	return err;
+}
+
+static int syncookie_open_bpf_maps(__u32 prog_id, int *values_map_fd, int *ports_map_fd)
+{
+	struct bpf_prog_info prog_info;
+	__u32 map_ids[3];
+	__u32 info_len;
+	int prog_fd;
+	int err;
+	int i;
+
+	*values_map_fd = -1;
+	*ports_map_fd = -1;
+
+	prog_fd = bpf_prog_get_fd_by_id(prog_id);
+	if (prog_fd < 0) {
+		fprintf(stderr, "Error: bpf_prog_get_fd_by_id: %s\n", strerror(-prog_fd));
+		return prog_fd;
+	}
+
+	prog_info = (struct bpf_prog_info) {
+		.nr_map_ids = 3,
+		.map_ids = (__u64)map_ids,
+	};
+	info_len = sizeof(prog_info);
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
+	if (err != 0) {
+		fprintf(stderr, "Error: bpf_obj_get_info_by_fd: %s\n", strerror(-err));
+		goto out;
+	}
+
+	if (prog_info.type != BPF_PROG_TYPE_XDP) {
+		fprintf(stderr, "Error: BPF prog type is not BPF_PROG_TYPE_XDP\n");
+		err = -ENOENT;
+		goto out;
+	}
+	if (prog_info.nr_map_ids != 2) {
+		fprintf(stderr, "Error: Found %u BPF maps, expected 2\n",
+			prog_info.nr_map_ids);
+		err = -ENOENT;
+		goto out;
+	}
+
+	for (i = 0; i < prog_info.nr_map_ids; i++) {
+		struct bpf_map_info map_info = {};
+		int map_fd;
+
+		err = bpf_map_get_fd_by_id(map_ids[i]);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_map_get_fd_by_id: %s\n", strerror(-err));
+			goto err_close_map_fds;
+		}
+		map_fd = err;
+
+		info_len = sizeof(map_info);
+		err = bpf_obj_get_info_by_fd(map_fd, &map_info, &info_len);
+		if (err != 0) {
+			fprintf(stderr, "Error: bpf_obj_get_info_by_fd: %s\n", strerror(-err));
+			close(map_fd);
+			goto err_close_map_fds;
+		}
+		if (strcmp(map_info.name, "values") == 0) {
+			*values_map_fd = map_fd;
+			continue;
+		}
+		if (strcmp(map_info.name, "allowed_ports") == 0) {
+			*ports_map_fd = map_fd;
+			continue;
+		}
+		close(map_fd);
+		goto err_close_map_fds;
+	}
+
+	err = 0;
+	goto out;
+
+err_close_map_fds:
+	if (*values_map_fd != -1)
+		close(*values_map_fd);
+	if (*ports_map_fd != -1)
+		close(*ports_map_fd);
+	*values_map_fd = -1;
+	*ports_map_fd = -1;
+
+out:
+	close(prog_fd);
+	return err;
+}
+
+int main(int argc, char *argv[])
+{
+	int values_map_fd, ports_map_fd;
+	__u64 tcpipopts;
+	bool firstiter;
+	__u64 prevcnt;
+	__u32 prog_id;
+	char *ports;
+	int err = 0;
+
+	parse_options(argc, argv, &ifindex, &prog_id, &tcpipopts, &ports);
+
+	if (prog_id == 0) {
+		err = bpf_get_link_xdp_id(ifindex, &prog_id, 0);
+		if (err < 0) {
+			fprintf(stderr, "Error: bpf_get_link_xdp_id: %s\n", strerror(-err));
+			goto out;
+		}
+		if (prog_id == 0) {
+			err = syncookie_attach(argv[0], ifindex);
+			if (err < 0)
+				goto out;
+			prog_id = attached_prog_id;
+		}
+	}
+
+	err = syncookie_open_bpf_maps(prog_id, &values_map_fd, &ports_map_fd);
+	if (err < 0)
+		goto out;
+
+	if (ports) {
+		__u16 port_last = 0;
+		__u32 port_idx = 0;
+		char *p = ports;
+
+		fprintf(stderr, "Replacing allowed ports\n");
+
+		while (p && *p != '\0') {
+			char *token = strsep(&p, ",");
+			__u16 port;
+
+			port = parse_arg_ul(argv[0], token, UINT16_MAX);
+			err = bpf_map_update_elem(ports_map_fd, &port_idx, &port, BPF_ANY);
+			if (err != 0) {
+				fprintf(stderr, "Error: bpf_map_update_elem: %s\n", strerror(-err));
+				fprintf(stderr, "Failed to add port %u (index %u)\n",
+					port, port_idx);
+				goto out_close_maps;
+			}
+			fprintf(stderr, "Added port %u\n", port);
+			port_idx++;
+		}
+		err = bpf_map_update_elem(ports_map_fd, &port_idx, &port_last, BPF_ANY);
+		if (err != 0) {
+			fprintf(stderr, "Error: bpf_map_update_elem: %s\n", strerror(-err));
+			fprintf(stderr, "Failed to add the terminator value 0 (index %u)\n",
+				port_idx);
+			goto out_close_maps;
+		}
+	}
+
+	if (tcpipopts) {
+		__u32 key = 0;
+
+		fprintf(stderr, "Replacing TCP/IP options\n");
+
+		err = bpf_map_update_elem(values_map_fd, &key, &tcpipopts, BPF_ANY);
+		if (err != 0) {
+			fprintf(stderr, "Error: bpf_map_update_elem: %s\n", strerror(-err));
+			goto out_close_maps;
+		}
+	}
+
+	if ((ports || tcpipopts) && attached_prog_id == 0)
+		goto out_close_maps;
+
+	prevcnt = 0;
+	firstiter = true;
+	while (true) {
+		__u32 key = 1;
+		__u64 value;
+
+		err = bpf_map_lookup_elem(values_map_fd, &key, &value);
+		if (err != 0) {
+			fprintf(stderr, "Error: bpf_map_lookup_elem: %s\n", strerror(-err));
+			goto out_close_maps;
+		}
+		if (firstiter) {
+			prevcnt = value;
+			firstiter = false;
+		}
+		printf("SYNACKs generated: %llu (total %llu)\n", value - prevcnt, value);
+		prevcnt = value;
+		sleep(1);
+	}
+
+out_close_maps:
+	close(values_map_fd);
+	close(ports_map_fd);
+out:
+	return err == 0 ? 0 : 1;
+}
-- 
2.30.2

