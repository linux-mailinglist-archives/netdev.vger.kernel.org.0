Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE49C3D191A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhGUUsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhGUUsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:48:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5C3C061575;
        Wed, 21 Jul 2021 14:29:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i16-20020a17090acf90b02901736d9d2218so2561550pju.1;
        Wed, 21 Jul 2021 14:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AyUcJHXtggFP9GeH14iKuvz8UHkWxeYEpcfQbz2akt8=;
        b=WrnCd5RA5tRdqsyTSZkLZSCGgG1uAYMmTVh96iSuCOYv6mJ7NoyHvLMq/n8WO9wmk3
         xySDS+5AO5NTIXIdEOaqTWf4+ntBYfBHvdUQSM/f4MjhTGHUvnLwO+6YL+fT0C3ufgZQ
         82/UxmvPdLlZjba5MiyHTdDU86yLFdq/G6rjSQNrXQ2CphvbpdYHd+Kpo9R4Hhjv2++6
         hM2Mcxff+bgEFajnc7rjAl06oU7Etp7F6KtM1NTNj4YDfNV1aKHPqXblAfn5R79Ff4c5
         /QFZqG5Bydf4SjSBh7MVXrEQyO7rfcJg0zuJVRKNCys3UsoREzzKh5k80SA64pj3JxsY
         BWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AyUcJHXtggFP9GeH14iKuvz8UHkWxeYEpcfQbz2akt8=;
        b=s2aSUkZPGBxKJ7aXAb/l3Va6ODXbr01wcM5ogLCxBu5mx+5gOfOnaLEBD47zrQVrKr
         GcgGqwOSTaOkGlX6PrVbMuTntr3ATPdV9D2YtFZ+KmbsMe26zU5kGYS40nAccG9RT7+J
         VpdchHsUqqDWi1LjcvVfrxjY8k8eWSoNLnTVAx10l63JBhp8g3abFXeZpIqBDWzFyITR
         yPucb9ltKEOujj4CAzoxiDC7pck9341InFZtN/Zn+EV6C3Kex0EVmGoNLi9K67jPeU1U
         JwhVwMgwzGtvhkcEQtGy+fNrNHvkW4DUa9n+2bm6WBErSL4eBLNCtj5yXjvSbhBm2cZi
         DdLw==
X-Gm-Message-State: AOAM532SJJH6w9RoDje3mSnUv+UsnxH1TlsYyHUhnkjY7JWTr6/J5MBG
        AhTNs6lni0BkFa2aYJiqeri9GRgPkAOWKw==
X-Google-Smtp-Source: ABdhPJz5cweFc6Imb1Bl0V+nH5qpU8fFnUSItj8eV/eyJlysZ9NKV5qLlB1Vk+rQzf7Oy3mZypYjZQ==
X-Received: by 2002:aa7:804f:0:b029:334:4951:da88 with SMTP id y15-20020aa7804f0000b02903344951da88mr32298326pfm.29.1626902944774;
        Wed, 21 Jul 2021 14:29:04 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id 125sm369722pge.34.2021.07.21.14.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:29:04 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 8/8] samples: bpf: Convert xdp_redirect_cpu to use XDP samples helpers
Date:   Thu, 22 Jul 2021 02:58:33 +0530
Message-Id: <20210721212833.701342-9-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721212833.701342-1-memxor@gmail.com>
References: <20210721212833.701342-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change converts XDP redirect_cpu tool to use the XDP samples
support introduced in previous changes.

One of the notable changes is removal of options to specify a separate
eBPF program that supplies a redirection program that is attached to the
CPUMAP, so that the packet can be redirected to a device after
redirecting it to a CPU. This is replaced by a program built into the
BPF object file and now the user only needs to specify the out interface
to do the same.

The program also uses devmap to redirect XDP frames, instead of directly
redirecting with bpf_redirect, for performance reasons.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                |  12 +-
 samples/bpf/xdp_redirect_cpu.bpf.c  | 561 +++++++++++++++++
 samples/bpf/xdp_redirect_cpu_kern.c | 730 ----------------------
 samples/bpf/xdp_redirect_cpu_user.c | 916 +++++-----------------------
 4 files changed, 732 insertions(+), 1487 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_cpu.bpf.c
 delete mode 100644 samples/bpf/xdp_redirect_cpu_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 064f16c12ccc..60d3a5ae6630 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -39,7 +39,6 @@ tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
-tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_rxq_info
 tprogs-y += syscall_tp
 tprogs-y += cpustat
@@ -53,6 +52,7 @@ tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
 
+tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
@@ -100,7 +100,6 @@ lwt_len_hist-objs := lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
-xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
@@ -115,6 +114,7 @@ ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
 xdp_sample_user-objs := xdp_sample_user.o $(LIBBPFDIR)/hashmap.o
+xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o $(XDP_SAMPLE)
 xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
@@ -164,7 +164,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
 always-y += syscall_tp_kern.o
@@ -312,6 +311,7 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_redirect_cpu_user.o: $(obj)/xdp_redirect_cpu.skel.h
 $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
 $(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
@@ -358,6 +358,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect_cpu.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map_multi.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
@@ -371,10 +372,11 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect_map_multi.skel.h xdp_redirect_map.skel.h \
-		xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
+		xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect_cpu.skel.h-deps := xdp_redirect_cpu.bpf.o xdp_sample.bpf.o
 xdp_redirect_map_multi.skel.h-deps := xdp_redirect_map_multi.bpf.o xdp_sample.bpf.o
 xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
diff --git a/samples/bpf/xdp_redirect_cpu.bpf.c b/samples/bpf/xdp_redirect_cpu.bpf.c
new file mode 100644
index 000000000000..0ceddf6960e8
--- /dev/null
+++ b/samples/bpf/xdp_redirect_cpu.bpf.c
@@ -0,0 +1,561 @@
+/*  XDP redirect to CPUs via cpumap (BPF_MAP_TYPE_CPUMAP)
+ *
+ *  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
+ */
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
+#include "hash_func01.h"
+
+#if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define bpf_ntohs(x)		__builtin_bswap16(x)
+#define bpf_htons(x)		__builtin_bswap16(x)
+#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define bpf_ntohs(x)		(x)
+#define bpf_htons(x)		(x)
+#else
+# error "Endianness detection needs to be set up for your compiler?!"
+#endif
+
+/* Special map type that can XDP_REDIRECT frames to another CPU */
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__uint(key_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
+	__uint(max_entries, MAX_CPUS);
+} cpu_map SEC(".maps");
+
+/* Set of maps controlling available CPU, and for iterating through
+ * selectable redirect CPUs.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, MAX_CPUS);
+} cpus_available SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, 1);
+} cpus_count SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(max_entries, 1);
+} cpus_iterator SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 1);
+} tx_port SEC(".maps");
+
+char tx_mac_addr[ETH_ALEN];
+
+/* Helper parse functions */
+
+static __always_inline
+bool parse_eth(struct ethhdr *eth, void *data_end,
+	       u16 *eth_proto, u64 *l3_offset)
+{
+	u16 eth_type;
+	u64 offset;
+
+	offset = sizeof(*eth);
+	if ((void *)eth + offset > data_end)
+		return false;
+
+	eth_type = eth->h_proto;
+
+	/* Skip non 802.3 Ethertypes */
+	if (__builtin_expect(bpf_ntohs(eth_type) < ETH_P_802_3_MIN, 0))
+		return false;
+
+	/* Handle VLAN tagged packet */
+	if (eth_type == bpf_htons(ETH_P_8021Q) ||
+	    eth_type == bpf_htons(ETH_P_8021AD)) {
+		struct vlan_hdr *vlan_hdr;
+
+		vlan_hdr = (void *)eth + offset;
+		offset += sizeof(*vlan_hdr);
+		if ((void *)eth + offset > data_end)
+			return false;
+		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
+	}
+	/* Handle double VLAN tagged packet */
+	if (eth_type == bpf_htons(ETH_P_8021Q) ||
+	    eth_type == bpf_htons(ETH_P_8021AD)) {
+		struct vlan_hdr *vlan_hdr;
+
+		vlan_hdr = (void *)eth + offset;
+		offset += sizeof(*vlan_hdr);
+		if ((void *)eth + offset > data_end)
+			return false;
+		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
+	}
+
+	*eth_proto = bpf_ntohs(eth_type);
+	*l3_offset = offset;
+	return true;
+}
+
+static __always_inline
+u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	struct iphdr *iph = data + nh_off;
+	struct udphdr *udph;
+	u16 dport;
+
+	if (iph + 1 > data_end)
+		return 0;
+	if (!(iph->protocol == IPPROTO_UDP))
+		return 0;
+
+	udph = (void *)(iph + 1);
+	if (udph + 1 > data_end)
+		return 0;
+
+	dport = bpf_ntohs(udph->dest);
+	return dport;
+}
+
+static __always_inline
+int get_proto_ipv4(struct xdp_md *ctx, u64 nh_off)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	struct iphdr *iph = data + nh_off;
+
+	if (iph + 1 > data_end)
+		return 0;
+	return iph->protocol;
+}
+
+static __always_inline
+int get_proto_ipv6(struct xdp_md *ctx, u64 nh_off)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	struct ipv6hdr *ip6h = data + nh_off;
+
+	if (ip6h + 1 > data_end)
+		return 0;
+	return ip6h->nexthdr;
+}
+
+SEC("xdp_cpu_map0")
+int  xdp_prognum0_no_touch(struct xdp_md *ctx)
+{
+	u32 key = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 *cpu_selected;
+	u32 cpu_dest = 0;
+	u32 key0 = 0;
+
+	/* Only use first entry in cpus_available */
+	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key0);
+	if (!cpu_selected)
+		return XDP_ABORTED;
+	cpu_dest = *cpu_selected;
+
+	if (key < MAX_CPUS) {
+		/* Count RX packet in map */
+		rec = &sample_data.rx_cnt[key];
+		ATOMIC_INC_NORMW(rec->processed);
+
+		if (cpu_dest >= MAX_CPUS) {
+			ATOMIC_INC_NORMW(rec->issue);
+			return XDP_ABORTED;
+		}
+		return bpf_redirect_map(&cpu_map, cpu_dest, 0);
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp_cpu_map1_touch_data")
+int  xdp_prognum1_touch_data(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct ethhdr *eth = data;
+	struct datarec *rec;
+	u32 *cpu_selected;
+	u32 cpu_dest = 0;
+	u32 key0 = 0;
+	u16 eth_type;
+
+	/* Only use first entry in cpus_available */
+	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key0);
+	if (!cpu_selected)
+		return XDP_ABORTED;
+	cpu_dest = *cpu_selected;
+
+	/* Validate packet length is minimum Eth header size */
+	if (eth + 1 > data_end)
+		return XDP_ABORTED;
+
+	if (key < MAX_CPUS) {
+		/* Count RX packet in map */
+		rec = &sample_data.rx_cnt[key];
+		ATOMIC_INC_NORMW(rec->processed);
+
+		/* Read packet data, and use it (drop non 802.3 Ethertypes) */
+		eth_type = eth->h_proto;
+		if (bpf_ntohs(eth_type) < ETH_P_802_3_MIN) {
+			ATOMIC_INC_NORMW(rec->dropped);
+			return XDP_DROP;
+		}
+
+		if (cpu_dest >= MAX_CPUS) {
+			ATOMIC_INC_NORMW(rec->issue);
+			return XDP_ABORTED;
+		}
+		return bpf_redirect_map(&cpu_map, cpu_dest, 0);
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp_cpu_map2_round_robin")
+int  xdp_prognum2_round_robin(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 cpu_dest = 0;
+	u32 key0 = 0;
+
+	u32 *cpu_selected;
+	u32 *cpu_iterator;
+	u32 *cpu_max;
+	u32 cpu_idx;
+
+	cpu_max = bpf_map_lookup_elem(&cpus_count, &key0);
+	if (!cpu_max)
+		return XDP_ABORTED;
+
+	cpu_iterator = bpf_map_lookup_elem(&cpus_iterator, &key0);
+	if (!cpu_iterator)
+		return XDP_ABORTED;
+	cpu_idx = *cpu_iterator;
+
+	*cpu_iterator += 1;
+	if (*cpu_iterator == *cpu_max)
+		*cpu_iterator = 0;
+
+	cpu_selected = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
+	if (!cpu_selected)
+		return XDP_ABORTED;
+	cpu_dest = *cpu_selected;
+
+	if (key < MAX_CPUS) {
+		/* Count RX packet in map */
+		rec = &sample_data.rx_cnt[key];
+		ATOMIC_INC_NORMW(rec->processed);
+
+		if (cpu_dest >= MAX_CPUS) {
+			ATOMIC_INC_NORMW(rec->issue);
+			return XDP_ABORTED;
+		}
+		return bpf_redirect_map(&cpu_map, cpu_dest, 0);
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp_cpu_map3_proto_separate")
+int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct ethhdr *eth = data;
+	u8 ip_proto = IPPROTO_UDP;
+	struct datarec *rec;
+	u16 eth_proto = 0;
+	u64 l3_offset = 0;
+	u32 cpu_dest = 0;
+	u32 *cpu_lookup;
+	u32 cpu_idx = 0;
+
+	if (key < MAX_CPUS) {
+		/* Count RX packet in map */
+		rec = &sample_data.rx_cnt[key];
+		ATOMIC_INC_NORMW(rec->processed);
+
+		if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
+			return XDP_PASS; /* Just skip */
+
+		/* Extract L4 protocol */
+		switch (eth_proto) {
+		case ETH_P_IP:
+			ip_proto = get_proto_ipv4(ctx, l3_offset);
+			break;
+		case ETH_P_IPV6:
+			ip_proto = get_proto_ipv6(ctx, l3_offset);
+			break;
+		case ETH_P_ARP:
+			cpu_idx = 0; /* ARP packet handled on separate CPU */
+			break;
+		default:
+			cpu_idx = 0;
+		}
+
+		/* Choose CPU based on L4 protocol */
+		switch (ip_proto) {
+		case IPPROTO_ICMP:
+		case IPPROTO_ICMPV6:
+			cpu_idx = 2;
+			break;
+		case IPPROTO_TCP:
+			cpu_idx = 0;
+			break;
+		case IPPROTO_UDP:
+			cpu_idx = 1;
+			break;
+		default:
+			cpu_idx = 0;
+		}
+
+		cpu_lookup = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
+		if (!cpu_lookup)
+			return XDP_ABORTED;
+		cpu_dest = *cpu_lookup;
+
+		if (cpu_dest >= MAX_CPUS) {
+			ATOMIC_INC_NORMW(rec->issue);
+			return XDP_ABORTED;
+		}
+		return bpf_redirect_map(&cpu_map, cpu_dest, 0);
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp_cpu_map4_ddos_filter_pktgen")
+int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct ethhdr *eth = data;
+	u8 ip_proto = IPPROTO_UDP;
+	struct datarec *rec;
+	u16 eth_proto = 0;
+	u64 l3_offset = 0;
+	u32 cpu_dest = 0;
+	u32 *cpu_lookup;
+	u32 cpu_idx = 0;
+	u16 dest_port;
+
+	if (key < MAX_CPUS) {
+		/* Count RX packet in map */
+		rec = &sample_data.rx_cnt[key];
+		ATOMIC_INC_NORMW(rec->processed);
+
+		if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
+			return XDP_PASS; /* Just skip */
+
+		/* Extract L4 protocol */
+		switch (eth_proto) {
+		case ETH_P_IP:
+			ip_proto = get_proto_ipv4(ctx, l3_offset);
+			break;
+		case ETH_P_IPV6:
+			ip_proto = get_proto_ipv6(ctx, l3_offset);
+			break;
+		case ETH_P_ARP:
+			cpu_idx = 0; /* ARP packet handled on separate CPU */
+			break;
+		default:
+			cpu_idx = 0;
+		}
+
+		/* Choose CPU based on L4 protocol */
+		switch (ip_proto) {
+		case IPPROTO_ICMP:
+		case IPPROTO_ICMPV6:
+			cpu_idx = 2;
+			break;
+		case IPPROTO_TCP:
+			cpu_idx = 0;
+			break;
+		case IPPROTO_UDP:
+			cpu_idx = 1;
+			/* DDoS filter UDP port 9 (pktgen) */
+			dest_port = get_dest_port_ipv4_udp(ctx, l3_offset);
+			if (dest_port == 9) {
+				ATOMIC_INC_NORMW(rec->dropped);
+				return XDP_DROP;
+			}
+			break;
+		default:
+			cpu_idx = 0;
+		}
+
+		cpu_lookup = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
+		if (!cpu_lookup)
+			return XDP_ABORTED;
+		cpu_dest = *cpu_lookup;
+
+		if (cpu_dest >= MAX_CPUS) {
+			ATOMIC_INC_NORMW(rec->issue);
+			return XDP_ABORTED;
+		}
+		return bpf_redirect_map(&cpu_map, cpu_dest, 0);
+	}
+
+	return XDP_PASS;
+}
+
+/* Hashing initval */
+#define INITVAL 15485863
+
+static __always_inline
+u32 get_ipv4_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	struct iphdr *iph = data + nh_off;
+	u32 cpu_hash;
+
+	if (iph + 1 > data_end)
+		return 0;
+
+	cpu_hash = iph->saddr + iph->daddr;
+	cpu_hash = SuperFastHash((char *)&cpu_hash, 4, INITVAL + iph->protocol);
+
+	return cpu_hash;
+}
+
+static __always_inline
+u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	struct ipv6hdr *ip6h = data + nh_off;
+	u32 cpu_hash;
+
+	if (ip6h + 1 > data_end)
+		return 0;
+
+	cpu_hash  = ip6h->saddr.in6_u.u6_addr32[0] + ip6h->daddr.in6_u.u6_addr32[0];
+	cpu_hash += ip6h->saddr.in6_u.u6_addr32[1] + ip6h->daddr.in6_u.u6_addr32[1];
+	cpu_hash += ip6h->saddr.in6_u.u6_addr32[2] + ip6h->daddr.in6_u.u6_addr32[2];
+	cpu_hash += ip6h->saddr.in6_u.u6_addr32[3] + ip6h->daddr.in6_u.u6_addr32[3];
+	cpu_hash = SuperFastHash((char *)&cpu_hash, 4, INITVAL + ip6h->nexthdr);
+
+	return cpu_hash;
+}
+
+/* Load-Balance traffic based on hashing IP-addrs + L4-proto.  The
+ * hashing scheme is symmetric, meaning swapping IP src/dest still hit
+ * same CPU.
+ */
+SEC("xdp_cpu_map5_lb_hash_ip_pairs")
+int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct ethhdr *eth = data;
+	struct datarec *rec;
+	u16 eth_proto = 0;
+	u64 l3_offset = 0;
+	u32 cpu_dest = 0;
+	u32 cpu_idx = 0;
+	u32 *cpu_lookup;
+	u32 key0 = 0;
+	u32 *cpu_max;
+	u32 cpu_hash;
+
+	if (key < MAX_CPUS) {
+		/* Count RX packet in map */
+		rec = &sample_data.rx_cnt[key];
+		ATOMIC_INC_NORMW(rec->processed);
+
+		cpu_max = bpf_map_lookup_elem(&cpus_count, &key0);
+		if (!cpu_max)
+			return XDP_ABORTED;
+
+		if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
+			return XDP_PASS; /* Just skip */
+
+		/* Hash for IPv4 and IPv6 */
+		switch (eth_proto) {
+		case ETH_P_IP:
+			cpu_hash = get_ipv4_hash_ip_pair(ctx, l3_offset);
+			break;
+		case ETH_P_IPV6:
+			cpu_hash = get_ipv6_hash_ip_pair(ctx, l3_offset);
+			break;
+		case ETH_P_ARP: /* ARP packet handled on CPU idx 0 */
+		default:
+			cpu_hash = 0;
+		}
+
+		/* Choose CPU based on hash */
+		cpu_idx = cpu_hash % *cpu_max;
+
+		cpu_lookup = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
+		if (!cpu_lookup)
+			return XDP_ABORTED;
+		cpu_dest = *cpu_lookup;
+
+		if (cpu_dest >= MAX_CPUS) {
+			ATOMIC_INC_NORMW(rec->issue);
+			return XDP_ABORTED;
+		}
+		return bpf_redirect_map(&cpu_map, cpu_dest, 0);
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp_cpumap/devmap")
+int xdp_redirect_cpu_devmap(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	swap_src_dst_mac(data);
+	return bpf_redirect_map(&tx_port, 0, 0);
+}
+
+SEC("xdp_devmap/egress")
+int xdp_redirect_egress_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	__builtin_memcpy(eth->h_source, (const char *)tx_mac_addr, ETH_ALEN);
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
deleted file mode 100644
index 8255025dea97..000000000000
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ /dev/null
@@ -1,730 +0,0 @@
-/*  XDP redirect to CPUs via cpumap (BPF_MAP_TYPE_CPUMAP)
- *
- *  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
- */
-#include <uapi/linux/if_ether.h>
-#include <uapi/linux/if_packet.h>
-#include <uapi/linux/if_vlan.h>
-#include <uapi/linux/ip.h>
-#include <uapi/linux/ipv6.h>
-#include <uapi/linux/in.h>
-#include <uapi/linux/tcp.h>
-#include <uapi/linux/udp.h>
-
-#include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
-#include "hash_func01.h"
-
-#define MAX_CPUS NR_CPUS
-
-/* Special map type that can XDP_REDIRECT frames to another CPU */
-struct {
-	__uint(type, BPF_MAP_TYPE_CPUMAP);
-	__uint(key_size, sizeof(u32));
-	__uint(value_size, sizeof(struct bpf_cpumap_val));
-	__uint(max_entries, MAX_CPUS);
-} cpu_map SEC(".maps");
-
-/* Common stats data record to keep userspace more simple */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 issue;
-	__u64 xdp_pass;
-	__u64 xdp_drop;
-	__u64 xdp_redirect;
-};
-
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} rx_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 2);
-	/* TODO: have entries for all possible errno's */
-} redirect_err_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, MAX_CPUS);
-} cpumap_enqueue_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} cpumap_kthread_cnt SEC(".maps");
-
-/* Set of maps controlling available CPU, and for iterating through
- * selectable redirect CPUs.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__type(key, u32);
-	__type(value, u32);
-	__uint(max_entries, MAX_CPUS);
-} cpus_available SEC(".maps");
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__type(key, u32);
-	__type(value, u32);
-	__uint(max_entries, 1);
-} cpus_count SEC(".maps");
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, u32);
-	__uint(max_entries, 1);
-} cpus_iterator SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} exception_cnt SEC(".maps");
-
-/* Helper parse functions */
-
-/* Parse Ethernet layer 2, extract network layer 3 offset and protocol
- *
- * Returns false on error and non-supported ether-type
- */
-struct vlan_hdr {
-	__be16 h_vlan_TCI;
-	__be16 h_vlan_encapsulated_proto;
-};
-
-static __always_inline
-bool parse_eth(struct ethhdr *eth, void *data_end,
-	       u16 *eth_proto, u64 *l3_offset)
-{
-	u16 eth_type;
-	u64 offset;
-
-	offset = sizeof(*eth);
-	if ((void *)eth + offset > data_end)
-		return false;
-
-	eth_type = eth->h_proto;
-
-	/* Skip non 802.3 Ethertypes */
-	if (unlikely(ntohs(eth_type) < ETH_P_802_3_MIN))
-		return false;
-
-	/* Handle VLAN tagged packet */
-	if (eth_type == htons(ETH_P_8021Q) || eth_type == htons(ETH_P_8021AD)) {
-		struct vlan_hdr *vlan_hdr;
-
-		vlan_hdr = (void *)eth + offset;
-		offset += sizeof(*vlan_hdr);
-		if ((void *)eth + offset > data_end)
-			return false;
-		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
-	}
-	/* Handle double VLAN tagged packet */
-	if (eth_type == htons(ETH_P_8021Q) || eth_type == htons(ETH_P_8021AD)) {
-		struct vlan_hdr *vlan_hdr;
-
-		vlan_hdr = (void *)eth + offset;
-		offset += sizeof(*vlan_hdr);
-		if ((void *)eth + offset > data_end)
-			return false;
-		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
-	}
-
-	*eth_proto = ntohs(eth_type);
-	*l3_offset = offset;
-	return true;
-}
-
-static __always_inline
-u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct iphdr *iph = data + nh_off;
-	struct udphdr *udph;
-	u16 dport;
-
-	if (iph + 1 > data_end)
-		return 0;
-	if (!(iph->protocol == IPPROTO_UDP))
-		return 0;
-
-	udph = (void *)(iph + 1);
-	if (udph + 1 > data_end)
-		return 0;
-
-	dport = ntohs(udph->dest);
-	return dport;
-}
-
-static __always_inline
-int get_proto_ipv4(struct xdp_md *ctx, u64 nh_off)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct iphdr *iph = data + nh_off;
-
-	if (iph + 1 > data_end)
-		return 0;
-	return iph->protocol;
-}
-
-static __always_inline
-int get_proto_ipv6(struct xdp_md *ctx, u64 nh_off)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ipv6hdr *ip6h = data + nh_off;
-
-	if (ip6h + 1 > data_end)
-		return 0;
-	return ip6h->nexthdr;
-}
-
-SEC("xdp_cpu_map0")
-int  xdp_prognum0_no_touch(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct datarec *rec;
-	u32 *cpu_selected;
-	u32 cpu_dest;
-	u32 key = 0;
-
-	/* Only use first entry in cpus_available */
-	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key);
-	if (!cpu_selected)
-		return XDP_ABORTED;
-	cpu_dest = *cpu_selected;
-
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
-
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
-		return XDP_ABORTED;
-	}
-
-	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
-}
-
-SEC("xdp_cpu_map1_touch_data")
-int  xdp_prognum1_touch_data(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	struct datarec *rec;
-	u32 *cpu_selected;
-	u32 cpu_dest;
-	u16 eth_type;
-	u32 key = 0;
-
-	/* Only use first entry in cpus_available */
-	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key);
-	if (!cpu_selected)
-		return XDP_ABORTED;
-	cpu_dest = *cpu_selected;
-
-	/* Validate packet length is minimum Eth header size */
-	if (eth + 1 > data_end)
-		return XDP_ABORTED;
-
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
-
-	/* Read packet data, and use it (drop non 802.3 Ethertypes) */
-	eth_type = eth->h_proto;
-	if (ntohs(eth_type) < ETH_P_802_3_MIN) {
-		rec->dropped++;
-		return XDP_DROP;
-	}
-
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
-		return XDP_ABORTED;
-	}
-
-	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
-}
-
-SEC("xdp_cpu_map2_round_robin")
-int  xdp_prognum2_round_robin(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	struct datarec *rec;
-	u32 cpu_dest;
-	u32 *cpu_lookup;
-	u32 key0 = 0;
-
-	u32 *cpu_selected;
-	u32 *cpu_iterator;
-	u32 *cpu_max;
-	u32 cpu_idx;
-
-	cpu_max = bpf_map_lookup_elem(&cpus_count, &key0);
-	if (!cpu_max)
-		return XDP_ABORTED;
-
-	cpu_iterator = bpf_map_lookup_elem(&cpus_iterator, &key0);
-	if (!cpu_iterator)
-		return XDP_ABORTED;
-	cpu_idx = *cpu_iterator;
-
-	*cpu_iterator += 1;
-	if (*cpu_iterator == *cpu_max)
-		*cpu_iterator = 0;
-
-	cpu_selected = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
-	if (!cpu_selected)
-		return XDP_ABORTED;
-	cpu_dest = *cpu_selected;
-
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key0);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
-
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
-		return XDP_ABORTED;
-	}
-
-	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
-}
-
-SEC("xdp_cpu_map3_proto_separate")
-int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	u8 ip_proto = IPPROTO_UDP;
-	struct datarec *rec;
-	u16 eth_proto = 0;
-	u64 l3_offset = 0;
-	u32 cpu_dest = 0;
-	u32 cpu_idx = 0;
-	u32 *cpu_lookup;
-	u32 key = 0;
-
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
-
-	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
-		return XDP_PASS; /* Just skip */
-
-	/* Extract L4 protocol */
-	switch (eth_proto) {
-	case ETH_P_IP:
-		ip_proto = get_proto_ipv4(ctx, l3_offset);
-		break;
-	case ETH_P_IPV6:
-		ip_proto = get_proto_ipv6(ctx, l3_offset);
-		break;
-	case ETH_P_ARP:
-		cpu_idx = 0; /* ARP packet handled on separate CPU */
-		break;
-	default:
-		cpu_idx = 0;
-	}
-
-	/* Choose CPU based on L4 protocol */
-	switch (ip_proto) {
-	case IPPROTO_ICMP:
-	case IPPROTO_ICMPV6:
-		cpu_idx = 2;
-		break;
-	case IPPROTO_TCP:
-		cpu_idx = 0;
-		break;
-	case IPPROTO_UDP:
-		cpu_idx = 1;
-		break;
-	default:
-		cpu_idx = 0;
-	}
-
-	cpu_lookup = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
-	if (!cpu_lookup)
-		return XDP_ABORTED;
-	cpu_dest = *cpu_lookup;
-
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
-		return XDP_ABORTED;
-	}
-
-	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
-}
-
-SEC("xdp_cpu_map4_ddos_filter_pktgen")
-int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	u8 ip_proto = IPPROTO_UDP;
-	struct datarec *rec;
-	u16 eth_proto = 0;
-	u64 l3_offset = 0;
-	u32 cpu_dest = 0;
-	u32 cpu_idx = 0;
-	u16 dest_port;
-	u32 *cpu_lookup;
-	u32 key = 0;
-
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
-
-	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
-		return XDP_PASS; /* Just skip */
-
-	/* Extract L4 protocol */
-	switch (eth_proto) {
-	case ETH_P_IP:
-		ip_proto = get_proto_ipv4(ctx, l3_offset);
-		break;
-	case ETH_P_IPV6:
-		ip_proto = get_proto_ipv6(ctx, l3_offset);
-		break;
-	case ETH_P_ARP:
-		cpu_idx = 0; /* ARP packet handled on separate CPU */
-		break;
-	default:
-		cpu_idx = 0;
-	}
-
-	/* Choose CPU based on L4 protocol */
-	switch (ip_proto) {
-	case IPPROTO_ICMP:
-	case IPPROTO_ICMPV6:
-		cpu_idx = 2;
-		break;
-	case IPPROTO_TCP:
-		cpu_idx = 0;
-		break;
-	case IPPROTO_UDP:
-		cpu_idx = 1;
-		/* DDoS filter UDP port 9 (pktgen) */
-		dest_port = get_dest_port_ipv4_udp(ctx, l3_offset);
-		if (dest_port == 9) {
-			if (rec)
-				rec->dropped++;
-			return XDP_DROP;
-		}
-		break;
-	default:
-		cpu_idx = 0;
-	}
-
-	cpu_lookup = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
-	if (!cpu_lookup)
-		return XDP_ABORTED;
-	cpu_dest = *cpu_lookup;
-
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
-		return XDP_ABORTED;
-	}
-
-	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
-}
-
-/* Hashing initval */
-#define INITVAL 15485863
-
-static __always_inline
-u32 get_ipv4_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct iphdr *iph = data + nh_off;
-	u32 cpu_hash;
-
-	if (iph + 1 > data_end)
-		return 0;
-
-	cpu_hash = iph->saddr + iph->daddr;
-	cpu_hash = SuperFastHash((char *)&cpu_hash, 4, INITVAL + iph->protocol);
-
-	return cpu_hash;
-}
-
-static __always_inline
-u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ipv6hdr *ip6h = data + nh_off;
-	u32 cpu_hash;
-
-	if (ip6h + 1 > data_end)
-		return 0;
-
-	cpu_hash  = ip6h->saddr.s6_addr32[0] + ip6h->daddr.s6_addr32[0];
-	cpu_hash += ip6h->saddr.s6_addr32[1] + ip6h->daddr.s6_addr32[1];
-	cpu_hash += ip6h->saddr.s6_addr32[2] + ip6h->daddr.s6_addr32[2];
-	cpu_hash += ip6h->saddr.s6_addr32[3] + ip6h->daddr.s6_addr32[3];
-	cpu_hash = SuperFastHash((char *)&cpu_hash, 4, INITVAL + ip6h->nexthdr);
-
-	return cpu_hash;
-}
-
-/* Load-Balance traffic based on hashing IP-addrs + L4-proto.  The
- * hashing scheme is symmetric, meaning swapping IP src/dest still hit
- * same CPU.
- */
-SEC("xdp_cpu_map5_lb_hash_ip_pairs")
-int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	u8 ip_proto = IPPROTO_UDP;
-	struct datarec *rec;
-	u16 eth_proto = 0;
-	u64 l3_offset = 0;
-	u32 cpu_dest = 0;
-	u32 cpu_idx = 0;
-	u32 *cpu_lookup;
-	u32 *cpu_max;
-	u32 cpu_hash;
-	u32 key = 0;
-
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
-
-	cpu_max = bpf_map_lookup_elem(&cpus_count, &key);
-	if (!cpu_max)
-		return XDP_ABORTED;
-
-	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
-		return XDP_PASS; /* Just skip */
-
-	/* Hash for IPv4 and IPv6 */
-	switch (eth_proto) {
-	case ETH_P_IP:
-		cpu_hash = get_ipv4_hash_ip_pair(ctx, l3_offset);
-		break;
-	case ETH_P_IPV6:
-		cpu_hash = get_ipv6_hash_ip_pair(ctx, l3_offset);
-		break;
-	case ETH_P_ARP: /* ARP packet handled on CPU idx 0 */
-	default:
-		cpu_hash = 0;
-	}
-
-	/* Choose CPU based on hash */
-	cpu_idx = cpu_hash % *cpu_max;
-
-	cpu_lookup = bpf_map_lookup_elem(&cpus_available, &cpu_idx);
-	if (!cpu_lookup)
-		return XDP_ABORTED;
-	cpu_dest = *cpu_lookup;
-
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
-		return XDP_ABORTED;
-	}
-
-	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
-}
-
-char _license[] SEC("license") = "GPL";
-
-/*** Trace point code ***/
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_redirect_ctx {
-	u64 __pad;	// First 8 bytes are not accessible by bpf code
-	int prog_id;	//	offset:8;  size:4; signed:1;
-	u32 act;	//	offset:12  size:4; signed:0;
-	int ifindex;	//	offset:16  size:4; signed:1;
-	int err;	//	offset:20  size:4; signed:1;
-	int to_ifindex;	//	offset:24  size:4; signed:1;
-	u32 map_id;	//	offset:28  size:4; signed:0;
-	int map_index;	//	offset:32  size:4; signed:1;
-};			//	offset:36
-
-enum {
-	XDP_REDIRECT_SUCCESS = 0,
-	XDP_REDIRECT_ERROR = 1
-};
-
-static __always_inline
-int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
-{
-	u32 key = XDP_REDIRECT_ERROR;
-	struct datarec *rec;
-	int err = ctx->err;
-
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
-
-	rec = bpf_map_lookup_elem(&redirect_err_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->dropped += 1;
-
-	return 0; /* Indicate event was filtered (no further processing)*/
-	/*
-	 * Returning 1 here would allow e.g. a perf-record tracepoint
-	 * to see and record these events, but it doesn't work well
-	 * in-practice as stopping perf-record also unload this
-	 * bpf_prog.  Plus, there is additional overhead of doing so.
-	 */
-}
-
-SEC("tracepoint/xdp/xdp_redirect_err")
-int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_exception_ctx {
-	u64 __pad;	// First 8 bytes are not accessible by bpf code
-	int prog_id;	//	offset:8;  size:4; signed:1;
-	u32 act;	//	offset:12; size:4; signed:0;
-	int ifindex;	//	offset:16; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_exception")
-int trace_xdp_exception(struct xdp_exception_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&exception_cnt, &key);
-	if (!rec)
-		return 1;
-	rec->dropped += 1;
-
-	return 0;
-}
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_enqueue_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int to_cpu;		//	offset:28; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_cpumap_enqueue")
-int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
-{
-	u32 to_cpu = ctx->to_cpu;
-	struct datarec *rec;
-
-	if (to_cpu >= MAX_CPUS)
-		return 1;
-
-	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-
-	/* Record bulk events, then userspace can calc average bulk size */
-	if (ctx->processed > 0)
-		rec->issue += 1;
-
-	/* Inception: It's possible to detect overload situations, via
-	 * this tracepoint.  This can be used for creating a feedback
-	 * loop to XDP, which can take appropriate actions to mitigate
-	 * this overload situation.
-	 */
-	return 0;
-}
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_kthread_ctx {
-	u64 __pad;			// First 8 bytes are not accessible
-	int map_id;			//	offset:8;  size:4; signed:1;
-	u32 act;			//	offset:12; size:4; signed:0;
-	int cpu;			//	offset:16; size:4; signed:1;
-	unsigned int drops;		//	offset:20; size:4; signed:0;
-	unsigned int processed;		//	offset:24; size:4; signed:0;
-	int sched;			//	offset:28; size:4; signed:1;
-	unsigned int xdp_pass;		//	offset:32; size:4; signed:0;
-	unsigned int xdp_drop;		//	offset:36; size:4; signed:0;
-	unsigned int xdp_redirect;	//	offset:40; size:4; signed:0;
-};
-
-SEC("tracepoint/xdp/xdp_cpumap_kthread")
-int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&cpumap_kthread_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-	rec->xdp_pass  += ctx->xdp_pass;
-	rec->xdp_drop  += ctx->xdp_drop;
-	rec->xdp_redirect  += ctx->xdp_redirect;
-
-	/* Count times kthread yielded CPU via schedule call */
-	if (ctx->sched)
-		rec->issue++;
-
-	return 0;
-}
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index d3ecdc18b9c1..68eda4fa4d7d 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -18,110 +18,40 @@ static const char *__doc__ =
 #include <net/if.h>
 #include <time.h>
 #include <linux/limits.h>
-
 #include <arpa/inet.h>
 #include <linux/if_link.h>
-
-/* How many xdp_progs are defined in _kern.c */
-#define MAX_PROG 6
-
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-
 #include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_redirect_cpu.skel.h"
 
-static int ifindex = -1;
-static char ifname_buf[IF_NAMESIZE];
-static char *ifname;
-static __u32 prog_id;
-
-static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static int n_cpus;
-
-enum map_type {
-	CPU_MAP,
-	RX_CNT,
-	REDIRECT_ERR_CNT,
-	CPUMAP_ENQUEUE_CNT,
-	CPUMAP_KTHREAD_CNT,
-	CPUS_AVAILABLE,
-	CPUS_COUNT,
-	CPUS_ITERATOR,
-	EXCEPTION_CNT,
-};
+static int map_fd;
+static int avail_fd;
+static int count_fd;
 
-static const char *const map_type_strings[] = {
-	[CPU_MAP] = "cpu_map",
-	[RX_CNT] = "rx_cnt",
-	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
-	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
-	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
-	[CPUS_AVAILABLE] = "cpus_available",
-	[CPUS_COUNT] = "cpus_count",
-	[CPUS_ITERATOR] = "cpus_iterator",
-	[EXCEPTION_CNT] = "exception_cnt",
-};
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
+		  SAMPLE_CPUMAP_ENQUEUE_CNT | SAMPLE_CPUMAP_KTHREAD_CNT |
+		  SAMPLE_EXCEPTION_CNT;
 
-#define NUM_TP 5
-#define NUM_MAP 9
-struct bpf_link *tp_links[NUM_TP] = {};
-static int map_fds[NUM_MAP];
-static int tp_cnt = 0;
-
-/* Exit return codes */
-#define EXIT_OK		0
-#define EXIT_FAIL		1
-#define EXIT_FAIL_OPTION	2
-#define EXIT_FAIL_XDP		3
-#define EXIT_FAIL_BPF		4
-#define EXIT_FAIL_MEM		5
+DEFINE_SAMPLE_INIT(xdp_redirect_cpu);
 
 static const struct option long_options[] = {
-	{"help",	no_argument,		NULL, 'h' },
-	{"dev",		required_argument,	NULL, 'd' },
-	{"skb-mode",	no_argument,		NULL, 'S' },
-	{"sec",		required_argument,	NULL, 's' },
-	{"progname",	required_argument,	NULL, 'p' },
-	{"qsize",	required_argument,	NULL, 'q' },
-	{"cpu",		required_argument,	NULL, 'c' },
-	{"stress-mode", no_argument,		NULL, 'x' },
-	{"no-separators", no_argument,		NULL, 'z' },
-	{"force",	no_argument,		NULL, 'F' },
-	{"mprog-disable", no_argument,		NULL, 'n' },
-	{"mprog-name",	required_argument,	NULL, 'e' },
-	{"mprog-filename", required_argument,	NULL, 'f' },
-	{"redirect-device", required_argument,	NULL, 'r' },
-	{"redirect-map", required_argument,	NULL, 'm' },
-	{0, 0, NULL,  0 }
+	{ "help", no_argument, NULL, 'h' },
+	{ "dev", required_argument, NULL, 'd' },
+	{ "skb-mode", no_argument, NULL, 'S' },
+	{ "progname", required_argument, NULL, 'p' },
+	{ "qsize", required_argument, NULL, 'q' },
+	{ "cpu", required_argument, NULL, 'c' },
+	{ "stress-mode", no_argument, NULL, 'x' },
+	{ "force", no_argument, NULL, 'F' },
+	{ "redirect-device", required_argument, NULL, 'r' },
+	{ "interval", required_argument, NULL, 'i' },
+	{ "verbose", no_argument, NULL, 'v' },
+	{ "stats", no_argument, NULL, 's' },
+	{}
 };
 
-static void int_exit(int sig)
-{
-	__u32 curr_prog_id = 0;
-
-	if (ifindex > -1) {
-		if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
-			printf("bpf_get_link_xdp_id failed\n");
-			exit(EXIT_FAIL);
-		}
-		if (prog_id == curr_prog_id) {
-			fprintf(stderr,
-				"Interrupted: Removing XDP program on ifindex:%d device:%s\n",
-				ifindex, ifname);
-			bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
-		} else if (!curr_prog_id) {
-			printf("couldn't find a prog id on a given iface\n");
-		} else {
-			printf("program on interface changed, not removing\n");
-		}
-	}
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
-
-	exit(EXIT_OK);
-}
-
 static void print_avail_progs(struct bpf_object *obj)
 {
 	struct bpf_program *pos;
@@ -136,6 +66,8 @@ static void usage(char *argv[], struct bpf_object *obj)
 {
 	int i;
 
+	sample_print_help(mask);
+
 	printf("\nDOCUMENTATION:\n%s\n", __doc__);
 	printf("\n");
 	printf(" Usage: %s (options-see-below)\n", argv[0]);
@@ -150,428 +82,11 @@ static void usage(char *argv[], struct bpf_object *obj)
 				long_options[i].val);
 		printf("\n");
 	}
-	printf("\n Programs to be used for --progname:\n");
+	printf("\n Programs to be used for -p/--progname:\n");
 	print_avail_progs(obj);
 	printf("\n");
 }
 
-/* gettime returns the current time of day in nanoseconds.
- * Cost: clock_gettime (ns) => 26ns (CLOCK_MONOTONIC)
- *       clock_gettime (ns) =>  9ns (CLOCK_MONOTONIC_COARSE)
- */
-#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
-static __u64 gettime(void)
-{
-	struct timespec t;
-	int res;
-
-	res = clock_gettime(CLOCK_MONOTONIC, &t);
-	if (res < 0) {
-		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
-		exit(EXIT_FAIL);
-	}
-	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
-}
-
-/* Common stats data record shared with _kern.c */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 issue;
-	__u64 xdp_pass;
-	__u64 xdp_drop;
-	__u64 xdp_redirect;
-};
-struct record {
-	__u64 timestamp;
-	struct datarec total;
-	struct datarec *cpu;
-};
-struct stats_record {
-	struct record rx_cnt;
-	struct record redir_err;
-	struct record kthread;
-	struct record exception;
-	struct record enq[];
-};
-
-static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec values[nr_cpus];
-	__u64 sum_xdp_redirect = 0;
-	__u64 sum_xdp_pass = 0;
-	__u64 sum_xdp_drop = 0;
-	__u64 sum_processed = 0;
-	__u64 sum_dropped = 0;
-	__u64 sum_issue = 0;
-	int i;
-
-	if ((bpf_map_lookup_elem(fd, &key, values)) != 0) {
-		fprintf(stderr,
-			"ERR: bpf_map_lookup_elem failed key:0x%X\n", key);
-		return false;
-	}
-	/* Get time as close as possible to reading map contents */
-	rec->timestamp = gettime();
-
-	/* Record and sum values from each CPU */
-	for (i = 0; i < nr_cpus; i++) {
-		rec->cpu[i].processed = values[i].processed;
-		sum_processed        += values[i].processed;
-		rec->cpu[i].dropped = values[i].dropped;
-		sum_dropped        += values[i].dropped;
-		rec->cpu[i].issue = values[i].issue;
-		sum_issue        += values[i].issue;
-		rec->cpu[i].xdp_pass = values[i].xdp_pass;
-		sum_xdp_pass += values[i].xdp_pass;
-		rec->cpu[i].xdp_drop = values[i].xdp_drop;
-		sum_xdp_drop += values[i].xdp_drop;
-		rec->cpu[i].xdp_redirect = values[i].xdp_redirect;
-		sum_xdp_redirect += values[i].xdp_redirect;
-	}
-	rec->total.processed = sum_processed;
-	rec->total.dropped   = sum_dropped;
-	rec->total.issue     = sum_issue;
-	rec->total.xdp_pass  = sum_xdp_pass;
-	rec->total.xdp_drop  = sum_xdp_drop;
-	rec->total.xdp_redirect = sum_xdp_redirect;
-	return true;
-}
-
-static struct datarec *alloc_record_per_cpu(void)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec *array;
-
-	array = calloc(nr_cpus, sizeof(struct datarec));
-	if (!array) {
-		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
-		exit(EXIT_FAIL_MEM);
-	}
-	return array;
-}
-
-static struct stats_record *alloc_stats_record(void)
-{
-	struct stats_record *rec;
-	int i, size;
-
-	size = sizeof(*rec) + n_cpus * sizeof(struct record);
-	rec = malloc(size);
-	if (!rec) {
-		fprintf(stderr, "Mem alloc error\n");
-		exit(EXIT_FAIL_MEM);
-	}
-	memset(rec, 0, size);
-	rec->rx_cnt.cpu    = alloc_record_per_cpu();
-	rec->redir_err.cpu = alloc_record_per_cpu();
-	rec->kthread.cpu   = alloc_record_per_cpu();
-	rec->exception.cpu = alloc_record_per_cpu();
-	for (i = 0; i < n_cpus; i++)
-		rec->enq[i].cpu = alloc_record_per_cpu();
-
-	return rec;
-}
-
-static void free_stats_record(struct stats_record *r)
-{
-	int i;
-
-	for (i = 0; i < n_cpus; i++)
-		free(r->enq[i].cpu);
-	free(r->exception.cpu);
-	free(r->kthread.cpu);
-	free(r->redir_err.cpu);
-	free(r->rx_cnt.cpu);
-	free(r);
-}
-
-static double calc_period(struct record *r, struct record *p)
-{
-	double period_ = 0;
-	__u64 period = 0;
-
-	period = r->timestamp - p->timestamp;
-	if (period > 0)
-		period_ = ((double) period / NANOSEC_PER_SEC);
-
-	return period_;
-}
-
-static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static __u64 calc_drop_pps(struct datarec *r, struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->dropped - p->dropped;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static __u64 calc_errs_pps(struct datarec *r,
-			    struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->issue - p->issue;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static void calc_xdp_pps(struct datarec *r, struct datarec *p,
-			 double *xdp_pass, double *xdp_drop,
-			 double *xdp_redirect, double period_)
-{
-	*xdp_pass = 0, *xdp_drop = 0, *xdp_redirect = 0;
-	if (period_ > 0) {
-		*xdp_redirect = (r->xdp_redirect - p->xdp_redirect) / period_;
-		*xdp_pass = (r->xdp_pass - p->xdp_pass) / period_;
-		*xdp_drop = (r->xdp_drop - p->xdp_drop) / period_;
-	}
-}
-
-static void stats_print(struct stats_record *stats_rec,
-			struct stats_record *stats_prev,
-			char *prog_name, char *mprog_name, int mprog_fd)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	double pps = 0, drop = 0, err = 0;
-	bool mprog_enabled = false;
-	struct record *rec, *prev;
-	int to_cpu;
-	double t;
-	int i;
-
-	if (mprog_fd > 0)
-		mprog_enabled = true;
-
-	/* Header */
-	printf("Running XDP/eBPF prog_name:%s\n", prog_name);
-	printf("%-15s %-7s %-14s %-11s %-9s\n",
-	       "XDP-cpumap", "CPU:to", "pps", "drop-pps", "extra-info");
-
-	/* XDP rx_cnt */
-	{
-		char *fmt_rx = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_rx = "%-15s %-7s %'-14.0f %'-11.0f\n";
-		char *errstr = "";
-
-		rec  = &stats_rec->rx_cnt;
-		prev = &stats_prev->rx_cnt;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0)
-				errstr = "cpu-dest/err";
-			if (pps > 0)
-				printf(fmt_rx, "XDP-RX",
-					i, pps, drop, err, errstr);
-		}
-		pps  = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		err  = calc_errs_pps(&rec->total, &prev->total, t);
-		printf(fm2_rx, "XDP-RX", "total", pps, drop);
-	}
-
-	/* cpumap enqueue stats */
-	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
-		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *errstr = "";
-
-		rec  =  &stats_rec->enq[to_cpu];
-		prev = &stats_prev->enq[to_cpu];
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0) {
-				errstr = "bulk-average";
-				err = pps / err; /* calc average bulk size */
-			}
-			if (pps > 0)
-				printf(fmt, "cpumap-enqueue",
-				       i, to_cpu, pps, drop, err, errstr);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		if (pps > 0) {
-			drop = calc_drop_pps(&rec->total, &prev->total, t);
-			err  = calc_errs_pps(&rec->total, &prev->total, t);
-			if (err > 0) {
-				errstr = "bulk-average";
-				err = pps / err; /* calc average bulk size */
-			}
-			printf(fm2, "cpumap-enqueue",
-			       "sum", to_cpu, pps, drop, err, errstr);
-		}
-	}
-
-	/* cpumap kthread stats */
-	{
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *e_str = "";
-
-		rec  = &stats_rec->kthread;
-		prev = &stats_prev->kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0)
-				e_str = "sched";
-			if (pps > 0)
-				printf(fmt_k, "cpumap_kthread",
-				       i, pps, drop, err, e_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		err  = calc_errs_pps(&rec->total, &prev->total, t);
-		if (err > 0)
-			e_str = "sched-sum";
-		printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
-	}
-
-	/* XDP redirect err tracepoints (very unlikely) */
-	{
-		char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-		char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
-
-		rec  = &stats_rec->redir_err;
-		prev = &stats_prev->redir_err;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			if (pps > 0)
-				printf(fmt_err, "redirect_err", i, pps, drop);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		printf(fm2_err, "redirect_err", "total", pps, drop);
-	}
-
-	/* XDP general exception tracepoints */
-	{
-		char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-		char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
-
-		rec  = &stats_rec->exception;
-		prev = &stats_prev->exception;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			if (pps > 0)
-				printf(fmt_err, "xdp_exception", i, pps, drop);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		printf(fm2_err, "xdp_exception", "total", pps, drop);
-	}
-
-	/* CPUMAP attached XDP program that runs on remote/destination CPU */
-	if (mprog_enabled) {
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f\n";
-		double xdp_pass, xdp_drop, xdp_redirect;
-
-		printf("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name);
-		printf("%-15s %-7s %-14s %-11s %-9s\n",
-		       "XDP-cpumap", "CPU:to", "xdp-pass", "xdp-drop", "xdp-redir");
-
-		rec  = &stats_rec->kthread;
-		prev = &stats_prev->kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			calc_xdp_pps(r, p, &xdp_pass, &xdp_drop,
-				     &xdp_redirect, t);
-			if (xdp_pass > 0 || xdp_drop > 0 || xdp_redirect > 0)
-				printf(fmt_k, "xdp-in-kthread", i, xdp_pass, xdp_drop,
-				       xdp_redirect);
-		}
-		calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
-			     &xdp_redirect, t);
-		printf(fm2_k, "xdp-in-kthread", "total", xdp_pass, xdp_drop, xdp_redirect);
-	}
-
-	printf("\n");
-	fflush(stdout);
-}
-
-static void stats_collect(struct stats_record *rec)
-{
-	int fd, i;
-
-	fd = map_fds[RX_CNT];
-	map_collect_percpu(fd, 0, &rec->rx_cnt);
-
-	fd = map_fds[REDIRECT_ERR_CNT];
-	map_collect_percpu(fd, 1, &rec->redir_err);
-
-	fd = map_fds[CPUMAP_ENQUEUE_CNT];
-	for (i = 0; i < n_cpus; i++)
-		map_collect_percpu(fd, i, &rec->enq[i]);
-
-	fd = map_fds[CPUMAP_KTHREAD_CNT];
-	map_collect_percpu(fd, 0, &rec->kthread);
-
-	fd = map_fds[EXCEPTION_CNT];
-	map_collect_percpu(fd, 0, &rec->exception);
-}
-
-
-/* Pointer swap trick */
-static inline void swap(struct stats_record **a, struct stats_record **b)
-{
-	struct stats_record *tmp;
-
-	tmp = *a;
-	*a = *b;
-	*b = tmp;
-}
-
 static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 			    __u32 avail_idx, bool new)
 {
@@ -582,38 +97,40 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(map_fds[CPU_MAP], &cpu, value, 0);
-	if (ret) {
-		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
-		exit(EXIT_FAIL_BPF);
+	ret = bpf_map_update_elem(map_fd, &cpu, value, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Create CPU entry failed: %s\n", strerror(errno));
+		return ret;
 	}
 
 	/* Inform bpf_prog's that a new CPU is available to select
 	 * from via some control maps.
 	 */
-	ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &avail_idx, &cpu, 0);
-	if (ret) {
-		fprintf(stderr, "Add to avail CPUs failed\n");
-		exit(EXIT_FAIL_BPF);
+	ret = bpf_map_update_elem(avail_fd, &avail_idx, &cpu, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Add to avail CPUs failed: %s\n", strerror(errno));
+		return ret;
 	}
 
 	/* When not replacing/updating existing entry, bump the count */
-	ret = bpf_map_lookup_elem(map_fds[CPUS_COUNT], &key, &curr_cpus_count);
-	if (ret) {
-		fprintf(stderr, "Failed reading curr cpus_count\n");
-		exit(EXIT_FAIL_BPF);
+	ret = bpf_map_lookup_elem(count_fd, &key, &curr_cpus_count);
+	if (ret < 0) {
+		fprintf(stderr, "Failed reading curr cpus_count: %s\n",
+			strerror(errno));
+		return ret;
 	}
 	if (new) {
 		curr_cpus_count++;
-		ret = bpf_map_update_elem(map_fds[CPUS_COUNT], &key,
+		ret = bpf_map_update_elem(count_fd, &key,
 					  &curr_cpus_count, 0);
-		if (ret) {
-			fprintf(stderr, "Failed write curr cpus_count\n");
-			exit(EXIT_FAIL_BPF);
+		if (ret < 0) {
+			fprintf(stderr, "Failed write curr cpus_count: %s\n",
+				strerror(errno));
+			return ret;
 		}
 	}
-	/* map_fd[7] = cpus_iterator */
-	printf("%s CPU:%u as idx:%u qsize:%d prog_fd: %d (cpus_count:%u)\n",
+
+	printf("%s CPU:%u as idx:%u qsize:%d cpumap_prog_fd: %d (cpus_count:%u)\n",
 	       new ? "Add-new":"Replace", cpu, avail_idx,
 	       value->qsize, value->bpf_prog.fd, curr_cpus_count);
 
@@ -623,24 +140,29 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 /* CPUs are zero-indexed. Thus, add a special sentinel default value
  * in map cpus_available to mark CPU index'es not configured
  */
-static void mark_cpus_unavailable(void)
+static int mark_cpus_unavailable(void)
 {
-	__u32 invalid_cpu = n_cpus;
-	int ret, i;
+	int ret, i, n_cpus = get_nprocs_conf();
+	__u32 invalid_cpu;
 
 	for (i = 0; i < n_cpus; i++) {
-		ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &i,
+		ret = bpf_map_update_elem(avail_fd, &i,
 					  &invalid_cpu, 0);
-		if (ret) {
-			fprintf(stderr, "Failed marking CPU unavailable\n");
-			exit(EXIT_FAIL_BPF);
+		if (ret < 0) {
+			fprintf(stderr, "Failed marking CPU unavailable: %s\n",
+				strerror(errno));
+			return ret;
 		}
 	}
+
+	return 0;
 }
 
 /* Stress cpumap management code by concurrently changing underlying cpumap */
-static void stress_cpumap(struct bpf_cpumap_val *value)
+static void stress_cpumap(void *ctx)
 {
+	struct bpf_cpumap_val *value = ctx;
+
 	/* Changing qsize will cause kernel to free and alloc a new
 	 * bpf_cpu_map_entry, with an associated/complicated tear-down
 	 * procedure.
@@ -653,142 +175,54 @@ static void stress_cpumap(struct bpf_cpumap_val *value)
 	create_cpu_entry(1, value, 0, false);
 }
 
-static void stats_poll(int interval, bool use_separators, char *prog_name,
-		       char *mprog_name, struct bpf_cpumap_val *value,
-		       bool stress_mode)
-{
-	struct stats_record *record, *prev;
-	int mprog_fd;
-
-	record = alloc_stats_record();
-	prev   = alloc_stats_record();
-	stats_collect(record);
-
-	/* Trick to pretty printf with thousands separators use %' */
-	if (use_separators)
-		setlocale(LC_NUMERIC, "en_US");
-
-	while (1) {
-		swap(&prev, &record);
-		mprog_fd = value->bpf_prog.fd;
-		stats_collect(record);
-		stats_print(record, prev, prog_name, mprog_name, mprog_fd);
-		sleep(interval);
-		if (stress_mode)
-			stress_cpumap(value);
-	}
-
-	free_stats_record(record);
-	free_stats_record(prev);
-}
-
-static int init_tracepoints(struct bpf_object *obj)
+static int set_cpumap_prog(struct xdp_redirect_cpu *skel, char *redir_interface)
 {
-	struct bpf_program *prog;
-
-	bpf_object__for_each_program(prog, obj) {
-		if (bpf_program__is_tracepoint(prog) != true)
-			continue;
-
-		tp_links[tp_cnt] = bpf_program__attach(prog);
-		if (libbpf_get_error(tp_links[tp_cnt])) {
-			tp_links[tp_cnt] = NULL;
-			return -EINVAL;
-		}
-		tp_cnt++;
-	}
-
-	return 0;
-}
-
-static int init_map_fds(struct bpf_object *obj)
-{
-	enum map_type type;
-
-	for (type = 0; type < NUM_MAP; type++) {
-		map_fds[type] =
-			bpf_object__find_map_fd_by_name(obj,
-							map_type_strings[type]);
-
-		if (map_fds[type] < 0)
-			return -ENOENT;
-	}
+	struct bpf_devmap_val val = {};
+	int ifindex_out, err;
+	__u32 key = 0;
 
-	return 0;
-}
+	if (!redir_interface)
+		return 0;
 
-static int load_cpumap_prog(char *file_name, char *prog_name,
-			    char *redir_interface, char *redir_map)
-{
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type		= BPF_PROG_TYPE_XDP,
-		.expected_attach_type	= BPF_XDP_CPUMAP,
-		.file = file_name,
-	};
-	struct bpf_program *prog;
-	struct bpf_object *obj;
-	int fd;
-
-	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &fd))
+	ifindex_out = if_nametoindex(redir_interface);
+	if (!ifindex_out)
 		return -1;
 
-	if (fd < 0) {
-		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n",
-			strerror(errno));
-		return fd;
-	}
-
-	if (redir_interface && redir_map) {
-		int err, map_fd, ifindex_out, key = 0;
-
-		map_fd = bpf_object__find_map_fd_by_name(obj, redir_map);
-		if (map_fd < 0)
-			return map_fd;
-
-		ifindex_out = if_nametoindex(redir_interface);
-		if (!ifindex_out)
-			return -1;
-
-		err = bpf_map_update_elem(map_fd, &key, &ifindex_out, 0);
-		if (err < 0)
-			return err;
+	if (get_mac_addr(ifindex_out, skel->bss->tx_mac_addr) < 0) {
+		printf("get interface %d mac failed\n", ifindex_out);
+		return -1;
 	}
 
-	prog = bpf_object__find_program_by_title(obj, prog_name);
-	if (!prog) {
-		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
-		return EXIT_FAIL;
-	}
+	val.ifindex = ifindex_out;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_redirect_egress_prog);
+	err = bpf_map_update_elem(bpf_map__fd(skel->maps.tx_port), &key, &val, 0);
+	if (err < 0)
+		return err;
 
-	return bpf_program__fd(prog);
+	return bpf_program__fd(skel->progs.xdp_redirect_cpu_devmap);
 }
 
 int main(int argc, char **argv)
 {
-	char *prog_name = "xdp_cpu_map5_lb_hash_ip_pairs";
-	char *mprog_filename = "xdp_redirect_kern.o";
-	char *redir_interface = NULL, *redir_map = NULL;
-	char *mprog_name = "xdp_redirect_dummy";
-	bool mprog_disable = false;
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_UNSPEC,
-	};
-	struct bpf_prog_info info = {};
-	__u32 info_len = sizeof(info);
+	struct xdp_redirect_cpu *skel;
+	char *redir_interface = NULL;
+	char ifname_buf[IF_NAMESIZE];
 	struct bpf_cpumap_val value;
-	bool use_separators = true;
+	int ret = EXIT_FAIL_OPTION;
+	unsigned long interval = 2;
 	bool stress_mode = false;
 	struct bpf_program *prog;
-	struct bpf_object *obj;
-	int err = EXIT_FAIL;
-	char filename[256];
+	const char *prog_name;
+	bool generic = false;
+	bool force = false;
 	int added_cpus = 0;
 	int longindex = 0;
-	int interval = 2;
 	int add_cpu = -1;
-	int opt, prog_fd;
-	int *cpu, i;
+	int ifindex = -1;
+	int *cpu, i, opt;
+	char *ifname;
 	__u32 qsize;
+	int n_cpus;
 
 	n_cpus = get_nprocs_conf();
 
@@ -810,85 +244,79 @@ int main(int argc, char **argv)
 	 */
 	qsize = 2048;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	prog_load_attr.file = filename;
-
-	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
-		return err;
-
-	if (prog_fd < 0) {
-		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n",
+	skel = xdp_redirect_cpu__open_and_load();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_redirect_cpu__open_and_load: %s\n",
 			strerror(errno));
-		return err;
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
 
-	if (init_tracepoints(obj) < 0) {
-		fprintf(stderr, "ERR: bpf_program__attach failed\n");
-		return err;
-	}
+	map_fd = bpf_map__fd(skel->maps.cpu_map);
+	avail_fd = bpf_map__fd(skel->maps.cpus_available);
+	count_fd = bpf_map__fd(skel->maps.cpus_count);
 
-	if (init_map_fds(obj) < 0) {
-		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
-		return err;
+	ret = mark_cpus_unavailable();
+	if (ret < 0) {
+		fprintf(stderr, "Unable to mark CPUs as unavailable\n");
+		goto end_destroy;
 	}
-	mark_cpus_unavailable();
 
-	cpu = malloc(n_cpus * sizeof(int));
+	cpu = calloc(n_cpus, sizeof(int));
 	if (!cpu) {
-		fprintf(stderr, "failed to allocate cpu array\n");
-		return err;
+		fprintf(stderr, "Failed to allocate cpu array\n");
+		goto end_destroy;
 	}
-	memset(cpu, 0, n_cpus * sizeof(int));
 
-	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	prog = skel->progs.xdp_prognum5_lb_hash_ip_pairs;
+	while ((opt = getopt_long(argc, argv, "d:si:Sxp:r:c:q:Fvh",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
 			if (strlen(optarg) >= IF_NAMESIZE) {
 				fprintf(stderr, "ERR: --dev name too long\n");
-				goto error;
+				goto end_cpu;
 			}
 			ifname = (char *)&ifname_buf;
-			strncpy(ifname, optarg, IF_NAMESIZE);
+			safe_strncpy(ifname, optarg, sizeof(ifname));
 			ifindex = if_nametoindex(ifname);
 			if (ifindex == 0) {
 				fprintf(stderr,
 					"ERR: --dev name unknown err(%d):%s\n",
 					errno, strerror(errno));
-				goto error;
+				goto end_cpu;
 			}
 			break;
 		case 's':
-			interval = atoi(optarg);
+			mask |= SAMPLE_REDIRECT_MAP_CNT;
+			break;
+		case 'i':
+			interval = strtoul(optarg, NULL, 0);
 			break;
 		case 'S':
-			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			generic = true;
 			break;
 		case 'x':
 			stress_mode = true;
 			break;
-		case 'z':
-			use_separators = false;
-			break;
 		case 'p':
 			/* Selecting eBPF prog to load */
 			prog_name = optarg;
-			break;
-		case 'n':
-			mprog_disable = true;
-			break;
-		case 'f':
-			mprog_filename = optarg;
-			break;
-		case 'e':
-			mprog_name = optarg;
+			prog = bpf_object__find_program_by_title(skel->obj,
+								 prog_name);
+			if (!prog) {
+				fprintf(stderr,
+					"Failed to find program %s specified by"
+					" option -p/--progname\n",
+					prog_name);
+				usage(argv, skel->obj);
+				goto end_cpu;
+			}
 			break;
 		case 'r':
 			redir_interface = optarg;
-			break;
-		case 'm':
-			redir_map = optarg;
+			mask |= SAMPLE_DEVMAP_XMIT_CNT |
+				SAMPLE_DEVMAP_XMIT_CNT_MULTI;
 			break;
 		case 'c':
 			/* Add multiple CPUs */
@@ -897,91 +325,75 @@ int main(int argc, char **argv)
 				fprintf(stderr,
 				"--cpu nr too large for cpumap err(%d):%s\n",
 					errno, strerror(errno));
-				goto error;
+				goto end_cpu;
 			}
 			cpu[added_cpus++] = add_cpu;
 			break;
 		case 'q':
-			qsize = atoi(optarg);
+			qsize = strtoul(optarg, NULL, 0);
 			break;
 		case 'F':
-			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			force = true;
+			break;
+		case 'v':
+			sample_switch_mode();
 			break;
 		case 'h':
-		error:
 		default:
-			free(cpu);
-			usage(argv, obj);
-			return EXIT_FAIL_OPTION;
+			usage(argv, skel->obj);
+			goto end_cpu;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
-		xdp_flags |= XDP_FLAGS_DRV_MODE;
+	ret = sample_init(skel, mask);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize sample: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_cpu;
+	}
 
 	/* Required option */
 	if (ifindex == -1) {
 		fprintf(stderr, "ERR: required option --dev missing\n");
-		usage(argv, obj);
-		err = EXIT_FAIL_OPTION;
-		goto out;
+		usage(argv, skel->obj);
+		goto end_cpu;
 	}
 	/* Required option */
 	if (add_cpu == -1) {
-		fprintf(stderr, "ERR: required option --cpu missing\n");
-		fprintf(stderr, " Specify multiple --cpu option to add more\n");
-		usage(argv, obj);
-		err = EXIT_FAIL_OPTION;
-		goto out;
+		fprintf(stderr, "ERR: required option --cpu missing\n"
+				"Specify multiple --cpu option to add more\n");
+		usage(argv, skel->obj);
+		ret = EXIT_FAIL_OPTION;
+		goto end_cpu;
 	}
 
-	value.bpf_prog.fd = 0;
-	if (!mprog_disable)
-		value.bpf_prog.fd = load_cpumap_prog(mprog_filename, mprog_name,
-						     redir_interface, redir_map);
+	value.bpf_prog.fd = set_cpumap_prog(skel, redir_interface);
 	if (value.bpf_prog.fd < 0) {
-		err = value.bpf_prog.fd;
-		goto out;
+		fprintf(stderr, "Failed to set cpumap prog to redirect to interface %s\n",
+			redir_interface);
+		ret = EXIT_FAIL_BPF;
+		goto end_cpu;
 	}
 	value.qsize = qsize;
 
 	for (i = 0; i < added_cpus; i++)
 		create_cpu_entry(cpu[i], &value, i, true);
 
-	/* Remove XDP program when program is interrupted or killed */
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
-
-	prog = bpf_object__find_program_by_title(obj, prog_name);
-	if (!prog) {
-		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
-		goto out;
-	}
-
-	prog_fd = bpf_program__fd(prog);
-	if (prog_fd < 0) {
-		fprintf(stderr, "bpf_program__fd failed\n");
-		goto out;
-	}
-
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
-		fprintf(stderr, "link set xdp fd failed\n");
-		err = EXIT_FAIL_XDP;
-		goto out;
-	}
+	ret = EXIT_FAIL_XDP;
+	if (sample_install_xdp(prog, ifindex, generic, force) < 0)
+		goto end_cpu;
 
-	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (err) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		goto out;
+	ret = sample_run(interval, stress_mode ? stress_cpumap : NULL, &value);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_cpu;
 	}
-	prog_id = info.id;
-
-	stats_poll(interval, use_separators, prog_name, mprog_name,
-		   &value, stress_mode);
-
-	err = EXIT_OK;
-out:
+	ret = EXIT_OK;
+end_cpu:
 	free(cpu);
-	return err;
+end_destroy:
+	xdp_redirect_cpu__destroy(skel);
+end:
+	sample_exit(ret);
 }
-- 
2.32.0

