Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2205782E8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiGRM7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiGRM70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:59:26 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0856460;
        Mon, 18 Jul 2022 05:59:23 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Lmhml4jb1z1M7tB;
        Mon, 18 Jul 2022 20:56:39 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 20:59:20 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 20:59:20 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v2 4/5] samples: bpf: Unify memory address casting operation style
Date:   Mon, 18 Jul 2022 21:29:37 +0800
Message-ID: <20220718132938.1031864-5-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718132938.1031864-1-pulehui@huawei.com>
References: <20220718132938.1031864-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory addresses are conceptually unsigned, (unsigned long) casting
makes more sense, so let's make a change for conceptual uniformity
and there is no functional change.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/parse_simple.c               |  4 +-
 samples/bpf/parse_varlen.c               |  4 +-
 samples/bpf/tc_l2_redirect_kern.c        | 16 ++++----
 samples/bpf/test_cgrp2_tc_kern.c         |  4 +-
 samples/bpf/test_lwt_bpf.c               |  4 +-
 samples/bpf/xdp_adjust_tail_kern.c       | 12 +++---
 samples/bpf/xdp_fwd_kern.c               |  4 +-
 samples/bpf/xdp_redirect.bpf.c           |  4 +-
 samples/bpf/xdp_redirect_cpu.bpf.c       | 48 ++++++++++++------------
 samples/bpf/xdp_redirect_map.bpf.c       |  8 ++--
 samples/bpf/xdp_redirect_map_multi.bpf.c |  4 +-
 samples/bpf/xdp_router_ipv4.bpf.c        |  4 +-
 samples/bpf/xdp_rxq_info_kern.c          |  4 +-
 samples/bpf/xdp_sample_pkts_kern.c       |  4 +-
 samples/bpf/xdp_tx_iptunnel_kern.c       | 20 +++++-----
 15 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/samples/bpf/parse_simple.c b/samples/bpf/parse_simple.c
index 4a486cb1e0df..9a58865079ce 100644
--- a/samples/bpf/parse_simple.c
+++ b/samples/bpf/parse_simple.c
@@ -26,11 +26,11 @@ struct eth_hdr {
 SEC("simple")
 int handle_ingress(struct __sk_buff *skb)
 {
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct eth_hdr *eth = data;
 	struct iphdr *iph = data + sizeof(*eth);
 	struct udphdr *udp = data + sizeof(*eth) + sizeof(*iph);
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 
 	/* single length check */
 	if (data + sizeof(*eth) + sizeof(*iph) + sizeof(*udp) > data_end)
diff --git a/samples/bpf/parse_varlen.c b/samples/bpf/parse_varlen.c
index d8623846e810..54e725efd576 100644
--- a/samples/bpf/parse_varlen.c
+++ b/samples/bpf/parse_varlen.c
@@ -112,9 +112,9 @@ static int parse_ipv6(void *data, uint64_t nh_off, void *data_end)
 SEC("varlen")
 int handle_ingress(struct __sk_buff *skb)
 {
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct ethhdr *eth = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	uint64_t h_proto, nh_off;
 
 	nh_off = sizeof(*eth);
diff --git a/samples/bpf/tc_l2_redirect_kern.c b/samples/bpf/tc_l2_redirect_kern.c
index fd2fa0004330..a3e10e43d560 100644
--- a/samples/bpf/tc_l2_redirect_kern.c
+++ b/samples/bpf/tc_l2_redirect_kern.c
@@ -59,9 +59,9 @@ SEC("l2_to_iptun_ingress_forward")
 int _l2_to_iptun_ingress_forward(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key tkey = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct eth_hdr *eth = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	int key = 0, *ifindex;
 
 	int ret;
@@ -110,9 +110,9 @@ SEC("l2_to_iptun_ingress_redirect")
 int _l2_to_iptun_ingress_redirect(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key tkey = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct eth_hdr *eth = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	int key = 0, *ifindex;
 
 	int ret;
@@ -151,9 +151,9 @@ SEC("l2_to_ip6tun_ingress_redirect")
 int _l2_to_ip6tun_ingress_redirect(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key tkey = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct eth_hdr *eth = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	int key = 0, *ifindex;
 
 	if (data + sizeof(*eth) > data_end)
@@ -206,9 +206,9 @@ SEC("drop_non_tun_vip")
 int _drop_non_tun_vip(struct __sk_buff *skb)
 {
 	struct bpf_tunnel_key tkey = {};
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct eth_hdr *eth = data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 
 	if (data + sizeof(*eth) > data_end)
 		return TC_ACT_OK;
diff --git a/samples/bpf/test_cgrp2_tc_kern.c b/samples/bpf/test_cgrp2_tc_kern.c
index 4dd532a312b9..c1468609ab14 100644
--- a/samples/bpf/test_cgrp2_tc_kern.c
+++ b/samples/bpf/test_cgrp2_tc_kern.c
@@ -41,10 +41,10 @@ struct bpf_elf_map SEC("maps") test_cgrp2_array_pin = {
 SEC("filter")
 int handle_egress(struct __sk_buff *skb)
 {
-	void *data = (void *)(long)skb->data;
+	void *data = (void *)(unsigned long)skb->data;
 	struct eth_hdr *eth = data;
 	struct ipv6hdr *ip6h = data + sizeof(*eth);
-	void *data_end = (void *)(long)skb->data_end;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	char dont_care_msg[] = "dont care %04x %d\n";
 	char pass_msg[] = "pass\n";
 	char reject_msg[] = "reject\n";
diff --git a/samples/bpf/test_lwt_bpf.c b/samples/bpf/test_lwt_bpf.c
index 1b568575ad11..dd1883415931 100644
--- a/samples/bpf/test_lwt_bpf.c
+++ b/samples/bpf/test_lwt_bpf.c
@@ -67,8 +67,8 @@ int do_test_cb(struct __sk_buff *skb)
 SEC("test_data")
 int do_test_data(struct __sk_buff *skb)
 {
-	void *data = (void *)(long)skb->data;
-	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(unsigned long)skb->data;
+	void *data_end = (void *)(unsigned long)skb->data_end;
 	struct iphdr *iph = data;
 
 	if (data + sizeof(*iph) > data_end) {
diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
index ffdd548627f0..7a182e133e6a 100644
--- a/samples/bpf/xdp_adjust_tail_kern.c
+++ b/samples/bpf/xdp_adjust_tail_kern.c
@@ -73,8 +73,8 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
 
 	if (bpf_xdp_adjust_head(xdp, 0 - headroom))
 		return XDP_DROP;
-	void *data = (void *)(long)xdp->data;
-	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
 
 	if (data + (ICMP_TOOBIG_SIZE + headroom) > data_end)
 		return XDP_DROP;
@@ -119,8 +119,8 @@ static __always_inline int send_icmp4_too_big(struct xdp_md *xdp)
 
 static __always_inline int handle_ipv4(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	int pckt_size = data_end - data;
 	int offset;
 
@@ -136,8 +136,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 SEC("xdp_icmp")
 int _xdp_icmp(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct ethhdr *eth = data;
 	__u16 h_proto;
 
diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index 54c099cbd639..022f9fb926b8 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -42,8 +42,8 @@ static __always_inline int ip_decrease_ttl(struct iphdr *iph)
 
 static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct bpf_fib_lookup fib_params;
 	struct ethhdr *eth = data;
 	struct ipv6hdr *ip6h;
diff --git a/samples/bpf/xdp_redirect.bpf.c b/samples/bpf/xdp_redirect.bpf.c
index 7c02bacfe96b..12969f2d58c7 100644
--- a/samples/bpf/xdp_redirect.bpf.c
+++ b/samples/bpf/xdp_redirect.bpf.c
@@ -19,8 +19,8 @@ const volatile int ifindex_out;
 SEC("xdp")
 int xdp_redirect_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	struct datarec *rec;
diff --git a/samples/bpf/xdp_redirect_cpu.bpf.c b/samples/bpf/xdp_redirect_cpu.bpf.c
index 87c54bfdbb70..46261792d74d 100644
--- a/samples/bpf/xdp_redirect_cpu.bpf.c
+++ b/samples/bpf/xdp_redirect_cpu.bpf.c
@@ -96,8 +96,8 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
 static __always_inline
 u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct iphdr *iph = data + nh_off;
 	struct udphdr *udph;
 
@@ -116,8 +116,8 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 static __always_inline
 int get_proto_ipv4(struct xdp_md *ctx, u64 nh_off)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct iphdr *iph = data + nh_off;
 
 	if (iph + 1 > data_end)
@@ -128,8 +128,8 @@ int get_proto_ipv4(struct xdp_md *ctx, u64 nh_off)
 static __always_inline
 int get_proto_ipv6(struct xdp_md *ctx, u64 nh_off)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct ipv6hdr *ip6h = data + nh_off;
 
 	if (ip6h + 1 > data_end)
@@ -167,8 +167,8 @@ int  xdp_prognum0_no_touch(struct xdp_md *ctx)
 SEC("xdp")
 int  xdp_prognum1_touch_data(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	struct datarec *rec;
@@ -209,8 +209,8 @@ int  xdp_prognum1_touch_data(struct xdp_md *ctx)
 SEC("xdp")
 int  xdp_prognum2_round_robin(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct datarec *rec;
 	u32 cpu_dest = 0;
@@ -254,8 +254,8 @@ int  xdp_prognum2_round_robin(struct xdp_md *ctx)
 SEC("xdp")
 int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	u8 ip_proto = IPPROTO_UDP;
@@ -320,8 +320,8 @@ int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
 SEC("xdp")
 int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	u8 ip_proto = IPPROTO_UDP;
@@ -396,8 +396,8 @@ int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 static __always_inline
 u32 get_ipv4_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct iphdr *iph = data + nh_off;
 	u32 cpu_hash;
 
@@ -413,8 +413,8 @@ u32 get_ipv4_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
 static __always_inline
 u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct ipv6hdr *ip6h = data + nh_off;
 	u32 cpu_hash;
 
@@ -437,8 +437,8 @@ u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
 SEC("xdp")
 int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	struct datarec *rec;
@@ -494,8 +494,8 @@ int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
 SEC("xdp/cpumap")
 int xdp_redirect_cpu_devmap(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct ethhdr *eth = data;
 	u64 nh_off;
 
@@ -522,8 +522,8 @@ int xdp_redirect_cpu_drop(struct xdp_md *ctx)
 SEC("xdp/devmap")
 int xdp_redirect_egress_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct ethhdr *eth = data;
 	u64 nh_off;
 
diff --git a/samples/bpf/xdp_redirect_map.bpf.c b/samples/bpf/xdp_redirect_map.bpf.c
index 8557c278df77..df8e9de0833f 100644
--- a/samples/bpf/xdp_redirect_map.bpf.c
+++ b/samples/bpf/xdp_redirect_map.bpf.c
@@ -37,8 +37,8 @@ const volatile __u8 tx_mac_addr[ETH_ALEN];
 
 static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_map)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	struct datarec *rec;
@@ -71,8 +71,8 @@ int xdp_redirect_map_native(struct xdp_md *ctx)
 SEC("xdp/devmap")
 int xdp_redirect_map_egress(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	u8 *mac_addr = (u8 *) tx_mac_addr;
 	struct ethhdr *eth = data;
 	u64 nh_off;
diff --git a/samples/bpf/xdp_redirect_map_multi.bpf.c b/samples/bpf/xdp_redirect_map_multi.bpf.c
index 8b2fd4ec2c76..361b7ed1b34e 100644
--- a/samples/bpf/xdp_redirect_map_multi.bpf.c
+++ b/samples/bpf/xdp_redirect_map_multi.bpf.c
@@ -56,8 +56,8 @@ int xdp_redirect_map_native(struct xdp_md *ctx)
 SEC("xdp/devmap")
 int xdp_devmap_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	u32 key = ctx->egress_ifindex;
 	struct ethhdr *eth = data;
 	__be64 *mac;
diff --git a/samples/bpf/xdp_router_ipv4.bpf.c b/samples/bpf/xdp_router_ipv4.bpf.c
index 0643330d1d2e..5a2a942decf9 100644
--- a/samples/bpf/xdp_router_ipv4.bpf.c
+++ b/samples/bpf/xdp_router_ipv4.bpf.c
@@ -73,8 +73,8 @@ struct {
 SEC("xdp")
 int xdp_router_ipv4_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 	struct ethhdr *eth = data;
 	u64 nh_off = sizeof(*eth);
 	struct datarec *rec;
diff --git a/samples/bpf/xdp_rxq_info_kern.c b/samples/bpf/xdp_rxq_info_kern.c
index 5e7459f9bf3e..0df286e2f30d 100644
--- a/samples/bpf/xdp_rxq_info_kern.c
+++ b/samples/bpf/xdp_rxq_info_kern.c
@@ -74,8 +74,8 @@ void swap_src_dst_mac(void *data)
 SEC("xdp_prog0")
 int  xdp_prognum0(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data     = (void *)(unsigned long)ctx->data;
 	struct datarec *rec, *rxq_rec;
 	int ingress_ifindex;
 	struct config *config;
diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
index 9cf76b340dd7..78a8150ecd33 100644
--- a/samples/bpf/xdp_sample_pkts_kern.c
+++ b/samples/bpf/xdp_sample_pkts_kern.c
@@ -15,8 +15,8 @@ struct {
 SEC("xdp_sample")
 int xdp_sample_prog(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(unsigned long)ctx->data_end;
+	void *data = (void *)(unsigned long)ctx->data;
 
 	/* Metadata will be in the perf event before the packet data. */
 	struct S {
diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
index 0e2bca3a3fff..f3f11ff12858 100644
--- a/samples/bpf/xdp_tx_iptunnel_kern.c
+++ b/samples/bpf/xdp_tx_iptunnel_kern.c
@@ -76,8 +76,8 @@ static __always_inline void set_ethhdr(struct ethhdr *new_eth,
 
 static __always_inline int handle_ipv4(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct iptnl_info *tnl;
 	struct ethhdr *new_eth;
 	struct ethhdr *old_eth;
@@ -112,8 +112,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
 		return XDP_DROP;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 
 	new_eth = data;
 	iph = data + sizeof(*new_eth);
@@ -151,8 +151,8 @@ static __always_inline int handle_ipv4(struct xdp_md *xdp)
 
 static __always_inline int handle_ipv6(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct iptnl_info *tnl;
 	struct ethhdr *new_eth;
 	struct ethhdr *old_eth;
@@ -184,8 +184,8 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
 		return XDP_DROP;
 
-	data = (void *)(long)xdp->data;
-	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(unsigned long)xdp->data;
+	data_end = (void *)(unsigned long)xdp->data_end;
 
 	new_eth = data;
 	ip6h = data + sizeof(*new_eth);
@@ -215,8 +215,8 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
 SEC("xdp.frags")
 int _xdp_tx_iptunnel(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(unsigned long)xdp->data_end;
+	void *data = (void *)(unsigned long)xdp->data;
 	struct ethhdr *eth = data;
 	__u16 h_proto;
 
-- 
2.25.1

