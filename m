Return-Path: <netdev+bounces-2950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6CC704AC6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B132816E7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229AB209A7;
	Tue, 16 May 2023 10:31:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC1124EB1;
	Tue, 16 May 2023 10:31:56 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DDB618F;
	Tue, 16 May 2023 03:31:30 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f50020e0f6so5220275e9.1;
        Tue, 16 May 2023 03:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233089; x=1686825089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9B+iBYIedfcRlw+i8dUwa2XnnygVIIIGyGwiaSncxyo=;
        b=D8zItzkS7SDYPgjXwwOZm9axUgr0PALAP0Btmzh+VKfXzO6o8p/J7AcAUWNx7d70yf
         cTQ5oGqCQYzgFOjzV9iSaoch7FmQhBEJBKXcq63EenCTKKkE7qjGtX8PdX2A5CwB678K
         op5YZvbvX5xPyP5FXtU1tzzJNb55nKPF58jrWi6yYa/nj49mHEvxLpSrMBUet4tlWvwo
         mp6WMiFuu7Ox07lYtPdlOHcGmTOIrNACqTIZ2fU2CYU2YJunqC4ceMHgvOlgIcop20GR
         LVdrKacnC+k4I3c0doTEhC84iUeY12nSpnuPsnivD0a2wgNjCjPt8wYchGSVG4pyU3tT
         f6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233089; x=1686825089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9B+iBYIedfcRlw+i8dUwa2XnnygVIIIGyGwiaSncxyo=;
        b=gy2DKpk764R0+R4dpBepsaXJNbSkTkcVbkEFyV6CDv1jHWSpquobgpqOJn2NOTwZ9m
         8qhVMjbB5myAsE8YsbfSa6gtWQs/8Jp0hpzsm6/nzqOhmrvT/6W7QrbHV8MbG+P0JfCs
         FqDgyFWsngaRRZd9WqYvWwSQx1AjZhLw9VpOrQp9AhcWjjlPNzl3dcZ02hm9iePhg3Ax
         4jDmIxSumZAiBmekbLMdt9dthLUsrPO6qkAqSxb9qQaCsJaqo4ZqBls5/VPQkU0PTB5A
         26932SJatem3habHnQmsPN0VRbsWcIclAK7KNdPxKxEmdoKZRfLOJap+BC7CMkl2BGj9
         nYIg==
X-Gm-Message-State: AC+VfDxMsu+OkC45zpxdoJHwA1Bt4QiZMEGnWMYV8B9rrbTv8raiFzfc
	B4W5AtEHu8UdZfb42e6rGukPoag6r0cCIEfFekE=
X-Google-Smtp-Source: ACHHUZ6yGSw/BVeiWdakbCzQUXMvJCNvKKjhNCBehtGv35IapA+mN5S7+NMgT4FZAGReF5N0wtexiw==
X-Received: by 2002:a05:600c:3541:b0:3f5:c6f:d204 with SMTP id i1-20020a05600c354100b003f50c6fd204mr1851058wmq.2.1684233088652;
        Tue, 16 May 2023 03:31:28 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:28 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 06/10] selftests/xsk: store offset in pkt instead of addr
Date: Tue, 16 May 2023 12:31:05 +0200
Message-Id: <20230516103109.3066-7-magnus.karlsson@gmail.com>
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

Store the offset in struct pkt instead of the address. This is
important since address is only meaningful in the context of a packet
that is stored in a single umem buffer and thus a single Tx
descriptor. If the packet, in contrast need to be represented by
multiple buffers in the umem, storing the address makes no sense since
the packet will consist of multiple buffers in the umem at various
addresses. This change is in preparation for the upcoming
multi-buffer support in AF_XDP and the corresponding tests.

So instead of indicating the address, we instead indicate the offset
of the packet in the first buffer. The actual address of the buffer is
allocated from the umem with a new function called
umem_alloc_buffer(). This also means we can get rid of the
use_fill_for_addr flag as the addresses fed into the fill ring will
always be the offset from the pkt specification in the packet stream
plus the address of the allocated buffer from the umem. No special
casing needed.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 150 +++++++++++++----------
 tools/testing/selftests/bpf/xskxceiver.h |   4 +-
 2 files changed, 90 insertions(+), 64 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 0823890c0709..d488d859d3a2 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -167,7 +167,13 @@ static u32 mode_to_xdp_flags(enum test_mode mode)
 	return (mode == TEST_MODE_SKB) ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
 }
 
-static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size)
+static u64 umem_size(struct xsk_umem_info *umem)
+{
+	return umem->num_frames * umem->frame_size;
+}
+
+static int xsk_configure_umem(struct ifobject *ifobj, struct xsk_umem_info *umem, void *buffer,
+			      u64 size)
 {
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
@@ -187,9 +193,31 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 		return ret;
 
 	umem->buffer = buffer;
+	if (ifobj->shared_umem && ifobj->rx_on) {
+		umem->base_addr = umem_size(umem);
+		umem->next_buffer = umem_size(umem);
+	}
+
 	return 0;
 }
 
+static u64 umem_alloc_buffer(struct xsk_umem_info *umem)
+{
+	u64 addr;
+
+	addr = umem->next_buffer;
+	umem->next_buffer += umem->frame_size;
+	if (umem->next_buffer >= umem->base_addr + umem_size(umem))
+		umem->next_buffer = umem->base_addr;
+
+	return addr;
+}
+
+static void umem_reset_alloc(struct xsk_umem_info *umem)
+{
+	umem->next_buffer = 0;
+}
+
 static void enable_busy_poll(struct xsk_socket_info *xsk)
 {
 	int sock_opt;
@@ -249,7 +277,7 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
 		exit_with_error(ENOMEM);
 	}
 	umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
-	ret = xsk_configure_umem(umem, bufs, umem_sz);
+	ret = xsk_configure_umem(ifobject, umem, bufs, umem_sz);
 	if (ret)
 		exit_with_error(-ret);
 
@@ -372,9 +400,6 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		memset(ifobj->umem, 0, sizeof(*ifobj->umem));
 		ifobj->umem->num_frames = DEFAULT_UMEM_BUFFERS;
 		ifobj->umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
-		if (ifobj->shared_umem && ifobj->rx_on)
-			ifobj->umem->base_addr = DEFAULT_UMEM_BUFFERS *
-				XSK_UMEM__DEFAULT_FRAME_SIZE;
 
 		for (j = 0; j < MAX_SOCKETS; j++) {
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
@@ -506,9 +531,9 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
 	return pkt_stream;
 }
 
-static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, u64 addr, u32 len)
+static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, int offset, u32 len)
 {
-	pkt->addr = addr + umem->base_addr;
+	pkt->offset = offset;
 	pkt->len = len;
 	if (len > umem->frame_size - XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 2 - umem->frame_headroom)
 		pkt->valid = false;
@@ -526,8 +551,7 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 		exit_with_error(ENOMEM);
 
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
-			pkt_len);
+		pkt_set(umem, &pkt_stream->pkts[i], 0, pkt_len);
 		pkt_stream->pkts[i].pkt_nb = i;
 	}
 
@@ -559,8 +583,7 @@ static void __pkt_stream_replace_half(struct ifobject *ifobj, u32 pkt_len,
 
 	pkt_stream = pkt_stream_clone(umem, ifobj->pkt_stream);
 	for (i = 1; i < ifobj->pkt_stream->nb_pkts; i += 2)
-		pkt_set(umem, &pkt_stream->pkts[i],
-			(i % umem->num_frames) * umem->frame_size + offset, pkt_len);
+		pkt_set(umem, &pkt_stream->pkts[i], offset, pkt_len);
 
 	ifobj->pkt_stream = pkt_stream;
 }
@@ -584,24 +607,26 @@ static void pkt_stream_receive_half(struct test_spec *test)
 		pkt_stream->pkts[i].valid = false;
 }
 
-static struct pkt *pkt_generate(struct ifobject *ifobject)
+static u64 pkt_get_addr(struct pkt *pkt, struct xsk_umem_info *umem)
+{
+	if (!pkt->valid)
+		return pkt->offset;
+	return pkt->offset + umem_alloc_buffer(umem);
+}
+
+static void pkt_generate(struct ifobject *ifobject, struct pkt *pkt, u64 addr)
 {
-	struct pkt *pkt = pkt_stream_get_next_tx_pkt(ifobject->pkt_stream);
 	struct ethhdr *eth_hdr;
 	void *data;
 
-	if (!pkt)
-		return NULL;
 	if (!pkt->valid || pkt->len < MIN_PKT_SIZE)
-		return pkt;
+		return;
 
-	data = xsk_umem__get_data(ifobject->umem->buffer, pkt->addr);
+	data = xsk_umem__get_data(ifobject->umem->buffer, addr);
 	eth_hdr = data;
 
 	gen_eth_hdr(ifobject, eth_hdr);
 	write_payload(data + PKT_HDR_SIZE, pkt->pkt_nb, pkt->len - PKT_HDR_SIZE);
-
-	return pkt;
 }
 
 static void __pkt_stream_generate_custom(struct ifobject *ifobj,
@@ -615,7 +640,7 @@ static void __pkt_stream_generate_custom(struct ifobject *ifobj,
 		exit_with_error(ENOMEM);
 
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = pkts[i].addr + ifobj->umem->base_addr;
+		pkt_stream->pkts[i].offset = pkts[i].offset;
 		pkt_stream->pkts[i].len = pkts[i].len;
 		pkt_stream->pkts[i].pkt_nb = i;
 		pkt_stream->pkts[i].valid = pkts[i].valid;
@@ -670,16 +695,16 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "\n---------------------------------------\n");
 }
 
-static bool is_offset_correct(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream, u64 addr,
-			      u64 pkt_stream_addr)
+static bool is_offset_correct(struct xsk_umem_info *umem, struct pkt *pkt, u64 addr)
 {
 	u32 headroom = umem->unaligned_mode ? 0 : umem->frame_headroom;
-	u32 offset = addr % umem->frame_size, expected_offset = 0;
+	u32 offset = addr % umem->frame_size, expected_offset;
+	int pkt_offset = pkt->valid ? pkt->offset : 0;
 
-	if (!pkt_stream->use_addr_for_fill)
-		pkt_stream_addr = 0;
+	if (!umem->unaligned_mode)
+		pkt_offset = 0;
 
-	expected_offset += (pkt_stream_addr + headroom + XDP_PACKET_HEADROOM) % umem->frame_size;
+	expected_offset = (pkt_offset + headroom + XDP_PACKET_HEADROOM) % umem->frame_size;
 
 	if (offset == expected_offset)
 		return true;
@@ -858,7 +883,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 			addr = xsk_umem__add_offset_to_addr(addr);
 
 			if (!is_pkt_valid(pkt, umem->buffer, addr, desc->len) ||
-			    !is_offset_correct(umem, pkt_stream, addr, pkt->addr) ||
+			    !is_offset_correct(umem, pkt, addr) ||
 			    (ifobj->use_metadata && !is_metadata_correct(pkt, umem->buffer, addr)))
 				return TEST_FAILURE;
 
@@ -915,15 +940,16 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 
 	for (i = 0; i < BATCH_SIZE; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
-		struct pkt *pkt = pkt_generate(ifobject);
+		struct pkt *pkt = pkt_stream_get_next_tx_pkt(ifobject->pkt_stream);
 
 		if (!pkt)
 			break;
 
-		tx_desc->addr = pkt->addr;
+		tx_desc->addr = pkt_get_addr(pkt, ifobject->umem);
 		tx_desc->len = pkt->len;
 		if (pkt->valid)
 			valid_pkts++;
+		pkt_generate(ifobject, pkt, tx_desc->addr);
 	}
 
 	pthread_mutex_lock(&pacing_mutex);
@@ -1130,11 +1156,12 @@ static void thread_common_ops_tx(struct test_spec *test, struct ifobject *ifobje
 	ifobject->xsk = &ifobject->xsk_arr[0];
 	ifobject->xskmap = test->ifobj_rx->xskmap;
 	memcpy(ifobject->umem, test->ifobj_rx->umem, sizeof(struct xsk_umem_info));
+	ifobject->umem->base_addr = 0;
 }
 
 static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
 {
-	u32 idx = 0, i, buffers_to_fill;
+	u32 idx = 0, i, buffers_to_fill, nb_pkts;
 	int ret;
 
 	if (umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
@@ -1145,24 +1172,23 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 	ret = xsk_ring_prod__reserve(&umem->fq, buffers_to_fill, &idx);
 	if (ret != buffers_to_fill)
 		exit_with_error(ENOSPC);
+
 	for (i = 0; i < buffers_to_fill; i++) {
+		struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &nb_pkts);
 		u64 addr;
 
-		if (pkt_stream->use_addr_for_fill) {
-			struct pkt *pkt = pkt_stream_get_next_tx_pkt(pkt_stream);
-
-			if (!pkt)
-				break;
-			addr = pkt->addr;
-		} else {
-			addr = i * umem->frame_size;
-		}
-
+		if (!pkt)
+			addr = i * umem->frame_size + umem->base_addr;
+		else if (pkt->offset >= 0)
+			addr = pkt->offset % umem->frame_size + umem_alloc_buffer(umem);
+		else
+			addr = pkt->offset + umem_alloc_buffer(umem);
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
 	}
 	xsk_ring_prod__submit(&umem->fq, i);
 
 	pkt_stream_reset(pkt_stream);
+	umem_reset_alloc(umem);
 }
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
@@ -1183,12 +1209,10 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
 
-	ret = xsk_configure_umem(ifobject->umem, bufs, umem_sz);
+	ret = xsk_configure_umem(ifobject, ifobject->umem, bufs, umem_sz);
 	if (ret)
 		exit_with_error(-ret);
 
-	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
-
 	xsk_configure_socket(test, ifobject, ifobject->umem, false);
 
 	ifobject->xsk = &ifobject->xsk_arr[0];
@@ -1196,6 +1220,8 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifobject->rx_on)
 		return;
 
+	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
+
 	ret = xsk_update_xskmap(ifobject->xskmap, ifobject->xsk->xsk);
 	if (ret)
 		exit_with_error(errno);
@@ -1543,9 +1569,8 @@ static bool testapp_unaligned(struct test_spec *test)
 	test_spec_set_name(test, "UNALIGNED_MODE");
 	test->ifobj_tx->umem->unaligned_mode = true;
 	test->ifobj_rx->umem->unaligned_mode = true;
-	/* Let half of the packets straddle a buffer boundrary */
+	/* Let half of the packets straddle a 4K buffer boundary */
 	pkt_stream_replace_half(test, MIN_PKT_SIZE, -MIN_PKT_SIZE / 2);
-	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
 	testapp_validate_traffic(test);
 
 	return true;
@@ -1553,7 +1578,7 @@ static bool testapp_unaligned(struct test_spec *test)
 
 static void testapp_single_pkt(struct test_spec *test)
 {
-	struct pkt pkts[] = {{0x1000, MIN_PKT_SIZE, 0, true}};
+	struct pkt pkts[] = {{0, MIN_PKT_SIZE, 0, true}};
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
@@ -1561,42 +1586,43 @@ static void testapp_single_pkt(struct test_spec *test)
 
 static void testapp_invalid_desc(struct test_spec *test)
 {
-	u64 umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
+	struct xsk_umem_info *umem = test->ifobj_tx->umem;
+	u64 umem_size = umem->num_frames * umem->frame_size;
 	struct pkt pkts[] = {
 		/* Zero packet address allowed */
 		{0, MIN_PKT_SIZE, 0, true},
 		/* Allowed packet */
-		{0x1000, MIN_PKT_SIZE, 0, true},
+		{0, MIN_PKT_SIZE, 0, true},
 		/* Straddling the start of umem */
 		{-2, MIN_PKT_SIZE, 0, false},
 		/* Packet too large */
-		{0x2000, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
+		{0, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
 		/* Up to end of umem allowed */
-		{umem_size - MIN_PKT_SIZE, MIN_PKT_SIZE, 0, true},
+		{umem_size - MIN_PKT_SIZE - 2 * umem->frame_size, MIN_PKT_SIZE, 0, true},
 		/* After umem ends */
 		{umem_size, MIN_PKT_SIZE, 0, false},
 		/* Straddle the end of umem */
 		{umem_size - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, false},
-		/* Straddle a page boundrary */
-		{0x3000 - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, false},
-		/* Straddle a 2K boundrary */
-		{0x3800 - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, true},
+		/* Straddle a 4K boundary */
+		{0x1000 - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, false},
+		/* Straddle a 2K boundary */
+		{0x800 - MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, true},
 		/* Valid packet for synch so that something is received */
-		{0x4000, MIN_PKT_SIZE, 0, true}};
+		{0, MIN_PKT_SIZE, 0, true}};
 
-	if (test->ifobj_tx->umem->unaligned_mode) {
-		/* Crossing a page boundrary allowed */
+	if (umem->unaligned_mode) {
+		/* Crossing a page boundary allowed */
 		pkts[7].valid = true;
 	}
-	if (test->ifobj_tx->umem->frame_size == XSK_UMEM__DEFAULT_FRAME_SIZE / 2) {
-		/* Crossing a 2K frame size boundrary not allowed */
+	if (umem->frame_size == XSK_UMEM__DEFAULT_FRAME_SIZE / 2) {
+		/* Crossing a 2K frame size boundary not allowed */
 		pkts[8].valid = false;
 	}
 
 	if (test->ifobj_tx->shared_umem) {
-		pkts[4].addr += umem_size;
-		pkts[5].addr += umem_size;
-		pkts[6].addr += umem_size;
+		pkts[4].offset += umem_size;
+		pkts[5].offset += umem_size;
+		pkts[6].offset += umem_size;
 	}
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 7ea28d844007..be4664a38d74 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -91,6 +91,7 @@ struct xsk_umem_info {
 	struct xsk_ring_prod fq;
 	struct xsk_ring_cons cq;
 	struct xsk_umem *umem;
+	u64 next_buffer;
 	u32 num_frames;
 	u32 frame_headroom;
 	void *buffer;
@@ -109,7 +110,7 @@ struct xsk_socket_info {
 };
 
 struct pkt {
-	u64 addr;
+	int offset;
 	u32 len;
 	u32 pkt_nb;
 	bool valid;
@@ -119,7 +120,6 @@ struct pkt_stream {
 	u32 nb_pkts;
 	u32 current_pkt_nb;
 	struct pkt *pkts;
-	bool use_addr_for_fill;
 };
 
 struct ifobject;
-- 
2.34.1


