Return-Path: <netdev+bounces-2947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921C5704AAE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 393F82816EB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B751EA92;
	Tue, 16 May 2023 10:31:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA831EA7B;
	Tue, 16 May 2023 10:31:48 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9F63A80;
	Tue, 16 May 2023 03:31:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f475364065so14201775e9.1;
        Tue, 16 May 2023 03:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233081; x=1686825081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wI5IrG29zGd60h1THT8bJGN9y52yIF6sh8o673+osJE=;
        b=SyRiGA+pkt9P/d0x2I/sA4BM1/w/oozeK/zEDnNxa6wtPPgjc8BOgq8KqVeUZL7Hpv
         Q34AcdzthMWYFi6KM+JnOOhKcklE9s/uC3pVW0WIwQxAX2yur/t1qUzEHa0jsFH4tz8N
         DesyvcpHD3sXkBCcH219mIDDpfBTfla/1F1hsGrL6bQaHfzkV86kkFAOW0D1i0d1KfEw
         y9vcDM2HnujBl/eaiH8SfKQhE7sTBmqRWmv19dfVxAYKF6DO/K2Pd8IZSuhXyU/frpB6
         7QgDeOnShw8HCnLoBeZUTXfMTRNVxkWtsSH0Gbc8Y2rarzmZe2lyE4ClMbnIUR4aAhaN
         1/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233081; x=1686825081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wI5IrG29zGd60h1THT8bJGN9y52yIF6sh8o673+osJE=;
        b=KUT8fZJNq2ORB3+6dZG2Nomqm9/Zj93W5Q8O9Gm4fuf/ZX2V6VuJ9qupGBuNxTk/bJ
         u5/9i5LO6SRGRWno2GLMoAhfMPTaR9LC1HJvkaaT4+zdGsgMpw8T/Aw+lw1hNPKLTai8
         iWt0/h9pJSxZYeuSlWFA1YrFoEWv2UOpN+83EcdYDrc+TY9mnIMFHqhnSuuas8YsPSKJ
         EFI/oDoLU2k/ZSwlWz+blRZxSTfdPEsEDm/waaf2TScvnec0CA53bVULiktazzLsRvUr
         IKCfCm/8XZX1miMmD4hiXchH+/cMJKP0+Iq2OS1I6AOKYV8UXSx1Mf6v+qljGsSUinSb
         bUTA==
X-Gm-Message-State: AC+VfDyxMNVwjOv+j3b4862uBdLUPcKd0ZCD6/eC6AljouiRgX9EEG6d
	iaNi3nKEAhw9oLDjKteFqSE=
X-Google-Smtp-Source: ACHHUZ7nNo1qFXaAGe+aoe9aElsfZWzi80sjQCocWXeof4pRRra3atAZai7qeSUsGpDUAO9eLTU80g==
X-Received: by 2002:a05:600c:1e26:b0:3f4:fa4c:a7a4 with SMTP id ay38-20020a05600c1e2600b003f4fa4ca7a4mr2146632wmb.2.1684233080916;
        Tue, 16 May 2023 03:31:20 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:20 -0700 (PDT)
From: Magnus Karlsson <magnus.karlsson@gmail.com>
To: magnus.karlsson@intel.com,
	bjorn@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	netdev@vger.kernel.org,
	maciej.fijalkowski@intel.com,
	bpf@vger.kernel.org,
	yhs@fb.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH bpf-next v2 02/10] selftests/xsk: generate simpler packets with variable length
Date: Tue, 16 May 2023 12:31:01 +0200
Message-Id: <20230516103109.3066-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516103109.3066-1-magnus.karlsson@gmail.com>
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Implement support for generating pkts with variable length. Before
this patch, they were all 64 bytes, exception for some packets of zero
length and some that were too large. This feature will be used to test
multi-buffer support for which large packets are needed.

The packets are also made simpler, just a valid Ethernet header
followed by a sequence number. This so that it will become easier to
implement packet generation when each packet consists of multiple
fragments. There is also a maintenance burden associated with carrying
all this code for generating proper UDP/IP packets, especially since
they are not needed.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 221 ++++-------------------
 tools/testing/selftests/bpf/xskxceiver.h |  17 +-
 2 files changed, 38 insertions(+), 200 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index f7950af576e1..c13478875fb1 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -76,16 +76,13 @@
 #include <asm/barrier.h>
 #include <linux/if_link.h>
 #include <linux/if_ether.h>
-#include <linux/ip.h>
 #include <linux/mman.h>
-#include <linux/udp.h>
 #include <arpa/inet.h>
 #include <net/if.h>
 #include <locale.h>
 #include <poll.h>
 #include <pthread.h>
 #include <signal.h>
-#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -94,10 +91,8 @@
 #include <sys/socket.h>
 #include <sys/time.h>
 #include <sys/types.h>
-#include <sys/queue.h>
 #include <time.h>
 #include <unistd.h>
-#include <stdatomic.h>
 
 #include "xsk_xdp_progs.skel.h"
 #include "xsk.h"
@@ -109,10 +104,6 @@
 
 static const char *MAC1 = "\x00\x0A\x56\x9E\xEE\x62";
 static const char *MAC2 = "\x00\x0A\x56\x9E\xEE\x61";
-static const char *IP1 = "192.168.100.162";
-static const char *IP2 = "192.168.100.161";
-static const u16 UDP_PORT1 = 2020;
-static const u16 UDP_PORT2 = 2121;
 
 static void __exit_with_error(int error, const char *file, const char *func, int line)
 {
@@ -158,101 +149,11 @@ static void memset32_htonl(void *dest, u32 val, u32 size)
 		ptr[i >> 2] = val;
 }
 
-/*
- * Fold a partial checksum
- * This function code has been taken from
- * Linux kernel include/asm-generic/checksum.h
- */
-static __u16 csum_fold(__u32 csum)
-{
-	u32 sum = (__force u32)csum;
-
-	sum = (sum & 0xffff) + (sum >> 16);
-	sum = (sum & 0xffff) + (sum >> 16);
-	return (__force __u16)~sum;
-}
-
-/*
- * This function code has been taken from
- * Linux kernel lib/checksum.c
- */
-static u32 from64to32(u64 x)
-{
-	/* add up 32-bit and 32-bit for 32+c bit */
-	x = (x & 0xffffffff) + (x >> 32);
-	/* add up carry.. */
-	x = (x & 0xffffffff) + (x >> 32);
-	return (u32)x;
-}
-
-/*
- * This function code has been taken from
- * Linux kernel lib/checksum.c
- */
-static __u32 csum_tcpudp_nofold(__be32 saddr, __be32 daddr, __u32 len, __u8 proto, __u32 sum)
-{
-	unsigned long long s = (__force u32)sum;
-
-	s += (__force u32)saddr;
-	s += (__force u32)daddr;
-#ifdef __BIG_ENDIAN__
-	s += proto + len;
-#else
-	s += (proto + len) << 8;
-#endif
-	return (__force __u32)from64to32(s);
-}
-
-/*
- * This function has been taken from
- * Linux kernel include/asm-generic/checksum.h
- */
-static __u16 csum_tcpudp_magic(__be32 saddr, __be32 daddr, __u32 len, __u8 proto, __u32 sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
-}
-
-static u16 udp_csum(u32 saddr, u32 daddr, u32 len, u8 proto, u16 *udp_pkt)
-{
-	u32 csum = 0;
-	u32 cnt = 0;
-
-	/* udp hdr and data */
-	for (; cnt < len; cnt += 2)
-		csum += udp_pkt[cnt >> 1];
-
-	return csum_tcpudp_magic(saddr, daddr, len, proto, csum);
-}
-
 static void gen_eth_hdr(struct ifobject *ifobject, struct ethhdr *eth_hdr)
 {
 	memcpy(eth_hdr->h_dest, ifobject->dst_mac, ETH_ALEN);
 	memcpy(eth_hdr->h_source, ifobject->src_mac, ETH_ALEN);
-	eth_hdr->h_proto = htons(ETH_P_IP);
-}
-
-static void gen_ip_hdr(struct ifobject *ifobject, struct iphdr *ip_hdr)
-{
-	ip_hdr->version = IP_PKT_VER;
-	ip_hdr->ihl = 0x5;
-	ip_hdr->tos = IP_PKT_TOS;
-	ip_hdr->tot_len = htons(IP_PKT_SIZE);
-	ip_hdr->id = 0;
-	ip_hdr->frag_off = 0;
-	ip_hdr->ttl = IPDEFTTL;
-	ip_hdr->protocol = IPPROTO_UDP;
-	ip_hdr->saddr = ifobject->src_ip;
-	ip_hdr->daddr = ifobject->dst_ip;
-	ip_hdr->check = 0;
-}
-
-static void gen_udp_hdr(u32 payload, void *pkt, struct ifobject *ifobject,
-			struct udphdr *udp_hdr)
-{
-	udp_hdr->source = htons(ifobject->src_port);
-	udp_hdr->dest = htons(ifobject->dst_port);
-	udp_hdr->len = htons(UDP_PKT_SIZE);
-	memset32_htonl(pkt + PKT_HDR_SIZE, payload, UDP_PKT_DATA_SIZE);
+	eth_hdr->h_proto = htons(ETH_P_LOOPBACK);
 }
 
 static bool is_umem_valid(struct ifobject *ifobj)
@@ -260,13 +161,6 @@ static bool is_umem_valid(struct ifobject *ifobj)
 	return !!ifobj->umem->umem;
 }
 
-static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
-{
-	udp_hdr->check = 0;
-	udp_hdr->check =
-	    udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE, IPPROTO_UDP, (u16 *)udp_hdr);
-}
-
 static u32 mode_to_xdp_flags(enum test_mode mode)
 {
 	return (mode == TEST_MODE_SKB) ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
@@ -697,9 +591,7 @@ static void pkt_stream_receive_half(struct test_spec *test)
 static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
-	struct udphdr *udp_hdr;
 	struct ethhdr *eth_hdr;
-	struct iphdr *ip_hdr;
 	void *data;
 
 	if (!pkt)
@@ -708,14 +600,10 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 		return pkt;
 
 	data = xsk_umem__get_data(ifobject->umem->buffer, pkt->addr);
-	udp_hdr = (struct udphdr *)(data + sizeof(struct ethhdr) + sizeof(struct iphdr));
-	ip_hdr = (struct iphdr *)(data + sizeof(struct ethhdr));
-	eth_hdr = (struct ethhdr *)data;
+	eth_hdr = data;
 
-	gen_udp_hdr(pkt_nb, data, ifobject, udp_hdr);
-	gen_ip_hdr(ifobject, ip_hdr);
-	gen_udp_csum(udp_hdr, ip_hdr);
 	gen_eth_hdr(ifobject, eth_hdr);
+	memset32_htonl(data + PKT_HDR_SIZE, pkt_nb, pkt->len - PKT_HDR_SIZE);
 
 	return pkt;
 }
@@ -746,18 +634,11 @@ static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts,
 	__pkt_stream_generate_custom(test->ifobj_rx, pkts, nb_pkts);
 }
 
-static void pkt_dump(void *pkt, u32 len)
+static void pkt_dump(void *pkt)
 {
-	char s[INET_ADDRSTRLEN];
-	struct ethhdr *ethhdr;
-	struct udphdr *udphdr;
-	struct iphdr *iphdr;
+	struct ethhdr *ethhdr = pkt;
 	u32 payload, i;
 
-	ethhdr = pkt;
-	iphdr = pkt + sizeof(*ethhdr);
-	udphdr = pkt + sizeof(*ethhdr) + sizeof(*iphdr);
-
 	/*extract L2 frame */
 	fprintf(stdout, "DEBUG>> L2: dst mac: ");
 	for (i = 0; i < ETH_ALEN; i++)
@@ -767,19 +648,10 @@ static void pkt_dump(void *pkt, u32 len)
 	for (i = 0; i < ETH_ALEN; i++)
 		fprintf(stdout, "%02X", ethhdr->h_source[i]);
 
-	/*extract L3 frame */
-	fprintf(stdout, "\nDEBUG>> L3: ip_hdr->ihl: %02X\n", iphdr->ihl);
-	fprintf(stdout, "DEBUG>> L3: ip_hdr->saddr: %s\n",
-		inet_ntop(AF_INET, &iphdr->saddr, s, sizeof(s)));
-	fprintf(stdout, "DEBUG>> L3: ip_hdr->daddr: %s\n",
-		inet_ntop(AF_INET, &iphdr->daddr, s, sizeof(s)));
-	/*extract L4 frame */
-	fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
-	fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
 	/*extract L5 frame */
 	payload = ntohl(*((u32 *)(pkt + PKT_HDR_SIZE)));
 
-	fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
+	fprintf(stdout, "\nDEBUG>> L5: payload: %d\n", payload);
 	fprintf(stdout, "---------------------------------------\n");
 }
 
@@ -818,7 +690,7 @@ static bool is_metadata_correct(struct pkt *pkt, void *buffer, u64 addr)
 static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
 	void *data = xsk_umem__get_data(buffer, addr);
-	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
+	u32 seqnum;
 
 	if (!pkt) {
 		ksft_print_msg("[%s] too many packets received\n", __func__);
@@ -836,21 +708,13 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 		return false;
 	}
 
-	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
-		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
-
-		if (opt_pkt_dump)
-			pkt_dump(data, PKT_SIZE);
+	seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
+	if (opt_pkt_dump)
+		pkt_dump(data);
 
-		if (pkt->payload != seqnum) {
-			ksft_print_msg("[%s] expected seqnum [%d], got seqnum [%d]\n",
-				       __func__, pkt->payload, seqnum);
-			return false;
-		}
-	} else {
-		ksft_print_msg("Invalid frame received: ");
-		ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
-			       iphdr->tos);
+	if (pkt->payload != seqnum) {
+		ksft_print_msg("[%s] expected seqnum [%d], got seqnum [%d]\n",
+			       __func__, pkt->payload, seqnum);
 		return false;
 	}
 
@@ -1606,9 +1470,9 @@ static void testapp_stats_tx_invalid_descs(struct test_spec *test)
 static void testapp_stats_rx_full(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_FULL");
-	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, PKT_SIZE);
+	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
 	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
-							 DEFAULT_UMEM_BUFFERS, PKT_SIZE);
+							 DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
 	if (!test->ifobj_rx->pkt_stream)
 		exit_with_error(ENOMEM);
 
@@ -1621,9 +1485,9 @@ static void testapp_stats_rx_full(struct test_spec *test)
 static void testapp_stats_fill_empty(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
-	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, PKT_SIZE);
+	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
 	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
-							 DEFAULT_UMEM_BUFFERS, PKT_SIZE);
+							 DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
 	if (!test->ifobj_rx->pkt_stream)
 		exit_with_error(ENOMEM);
 
@@ -1659,7 +1523,7 @@ static bool testapp_unaligned(struct test_spec *test)
 	test->ifobj_tx->umem->unaligned_mode = true;
 	test->ifobj_rx->umem->unaligned_mode = true;
 	/* Let half of the packets straddle a buffer boundrary */
-	pkt_stream_replace_half(test, PKT_SIZE, -PKT_SIZE / 2);
+	pkt_stream_replace_half(test, MIN_PKT_SIZE, -MIN_PKT_SIZE / 2);
 	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
 	testapp_validate_traffic(test);
 
@@ -1668,7 +1532,7 @@ static bool testapp_unaligned(struct test_spec *test)
 
 static void testapp_single_pkt(struct test_spec *test)
 {
-	struct pkt pkts[] = {{0x1000, PKT_SIZE, 0, true}};
+	struct pkt pkts[] = {{0x1000, MIN_PKT_SIZE, 0, true}};
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
@@ -1679,25 +1543,25 @@ static void testapp_invalid_desc(struct test_spec *test)
 	u64 umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
 	struct pkt pkts[] = {
 		/* Zero packet address allowed */
-		{0, PKT_SIZE, 0, true},
+		{0, MIN_PKT_SIZE, 0, true},
 		/* Allowed packet */
-		{0x1000, PKT_SIZE, 0, true},
+		{0x1000, MIN_PKT_SIZE, 0, true},
 		/* Straddling the start of umem */
-		{-2, PKT_SIZE, 0, false},
+		{-2, MIN_PKT_SIZE, 0, false},
 		/* Packet too large */
 		{0x2000, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
 		/* Up to end of umem allowed */
-		{umem_size - PKT_SIZE, PKT_SIZE, 0, true},
+		{umem_size - MIN_PKT_SIZE, MIN_PKT_SIZE, 0, true},
 		/* After umem ends */
-		{umem_size, PKT_SIZE, 0, false},
+		{umem_size, MIN_PKT_SIZE, 0, false},
 		/* Straddle the end of umem */
-		{umem_size - PKT_SIZE / 2, PKT_SIZE, 0, false},
+		{umem_size - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, false},
 		/* Straddle a page boundrary */
-		{0x3000 - PKT_SIZE / 2, PKT_SIZE, 0, false},
+		{0x3000 - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, false},
 		/* Straddle a 2K boundrary */
-		{0x3800 - PKT_SIZE / 2, PKT_SIZE, 0, true},
+		{0x3800 - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, true},
 		/* Valid packet for synch so that something is received */
-		{0x4000, PKT_SIZE, 0, true}};
+		{0x4000, MIN_PKT_SIZE, 0, true}};
 
 	if (test->ifobj_tx->umem->unaligned_mode) {
 		/* Crossing a page boundrary allowed */
@@ -1788,24 +1652,13 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
 }
 
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
-		       const char *dst_ip, const char *src_ip, const u16 dst_port,
-		       const u16 src_port, thread_func_t func_ptr)
+		       thread_func_t func_ptr)
 {
-	struct in_addr ip;
 	int err;
 
 	memcpy(ifobj->dst_mac, dst_mac, ETH_ALEN);
 	memcpy(ifobj->src_mac, src_mac, ETH_ALEN);
 
-	inet_aton(dst_ip, &ip);
-	ifobj->dst_ip = ip.s_addr;
-
-	inet_aton(src_ip, &ip);
-	ifobj->src_ip = ip.s_addr;
-
-	ifobj->dst_port = dst_port;
-	ifobj->src_port = src_port;
-
 	ifobj->func_ptr = func_ptr;
 
 	err = xsk_load_xdp_programs(ifobj);
@@ -1855,7 +1708,7 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
 		test->ifobj_tx->umem->frame_size = 2048;
 		test->ifobj_rx->umem->frame_size = 2048;
-		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
+		pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
 		testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_RX_POLL:
@@ -1912,8 +1765,8 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		 */
 		page_size = sysconf(_SC_PAGESIZE);
 		umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
-		assert(umem_size % page_size > PKT_SIZE);
-		assert(umem_size % page_size < page_size - PKT_SIZE);
+		assert(umem_size % page_size > MIN_PKT_SIZE);
+		assert(umem_size % page_size < page_size - MIN_PKT_SIZE);
 		testapp_invalid_desc(test);
 		break;
 	}
@@ -2039,14 +1892,12 @@ int main(int argc, char **argv)
 			modes++;
 	}
 
-	init_iface(ifobj_rx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
-		   worker_testapp_validate_rx);
-	init_iface(ifobj_tx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
-		   worker_testapp_validate_tx);
+	init_iface(ifobj_rx, MAC1, MAC2, worker_testapp_validate_rx);
+	init_iface(ifobj_tx, MAC2, MAC1, worker_testapp_validate_tx);
 
 	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
-	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
-	rx_pkt_stream_default = pkt_stream_generate(ifobj_rx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
+	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
+	rx_pkt_stream_default = pkt_stream_generate(ifobj_rx->umem, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
 	if (!tx_pkt_stream_default || !rx_pkt_stream_default)
 		exit_with_error(ENOMEM);
 	test.tx_pkt_stream_default = tx_pkt_stream_default;
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index c535aeab2ca3..8b094718629d 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -35,17 +35,8 @@
 #define MAX_SOCKETS 2
 #define MAX_TEST_NAME_SIZE 32
 #define MAX_TEARDOWN_ITER 10
-#define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
-			sizeof(struct udphdr))
-#define MIN_ETH_PKT_SIZE 64
-#define ETH_FCS_SIZE 4
-#define MIN_PKT_SIZE (MIN_ETH_PKT_SIZE - ETH_FCS_SIZE)
-#define PKT_SIZE (MIN_PKT_SIZE)
-#define IP_PKT_SIZE (PKT_SIZE - sizeof(struct ethhdr))
-#define IP_PKT_VER 0x4
-#define IP_PKT_TOS 0x9
-#define UDP_PKT_SIZE (IP_PKT_SIZE - sizeof(struct iphdr))
-#define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
+#define PKT_HDR_SIZE (sizeof(struct ethhdr) + 2) /* Just to align the data in the packet */
+#define MIN_PKT_SIZE 64
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
@@ -148,11 +139,7 @@ struct ifobject {
 	struct bpf_program *xdp_prog;
 	enum test_mode mode;
 	int ifindex;
-	u32 dst_ip;
-	u32 src_ip;
 	u32 bind_flags;
-	u16 src_port;
-	u16 dst_port;
 	bool tx_on;
 	bool rx_on;
 	bool use_poll;
-- 
2.34.1


