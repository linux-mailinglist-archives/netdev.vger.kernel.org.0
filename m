Return-Path: <netdev+bounces-2088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5BDF70039D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E19F71C2112C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E7AD520;
	Fri, 12 May 2023 09:21:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC2D51F;
	Fri, 12 May 2023 09:21:38 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08965D2DC;
	Fri, 12 May 2023 02:21:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3063d724cb9so1086913f8f.1;
        Fri, 12 May 2023 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883295; x=1686475295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xxhp740pvAFYQsExukfowkg2fP/BGl0fQvJiLe9sPxk=;
        b=ckFLBMZ5a1wvjEuI/xE7WP/lzpcQQtVnHczaCk5JIciEPsL1+VbT1NWzwVwqr9STQM
         Dg9vcHL4zHVCwDlUMugPuVECbC5ReHJfrxwNyPhNmULr9tu2puckxEYxntSvlE+7f7j8
         PHcQ1WnZDqhOZ5PPFi1/C91sDeyWYA9Ky9j1dDdWC3oOv3ab3K/J6g2bHaNPCxZBCsA2
         iljx+nfzz0vKXkbTG7OX1WnFT0L9QuH3ns//BLu+spV9vH5CEmP690Pt7W/uvTSLe2qN
         liGhyNdKIdfbFOlLh+9CZHk9Gb3AzCDNEwbWgysXGd7DWDhtc1lDWNUhlZyCZLa3tXK0
         UAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883295; x=1686475295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xxhp740pvAFYQsExukfowkg2fP/BGl0fQvJiLe9sPxk=;
        b=UgfbNeYQY7GHCpysfRdS4Y98dohHI+LwPDDGIus5TJksTOIHTyFMlvk8Kvh/hIQ6we
         9LRItGRLl3Vqiot4bZbnKD6Owp3KkbtNcBS5RiwnCEcxUXy6i2J5fJ3iRyRXj6EJ47mb
         QwwpTvS7uoW88t23tu3YLyNv+NX3Kf7Qqv7cjppsvsorPGN/aYbTKwffhoa9g7+YvnVJ
         40/BMeQKkPLkE8nJW8mmcoedn1nPLGG4Hkz1BuJBEA98FgSF5bfgX4wiGUXU/WGC5mRw
         3iVMKXhNsTXrXNLOCg2MgodYZ/uAYuV9+8oS8WyLGsUMH57kjElOAJU11/0zRGZ29nrI
         Xeww==
X-Gm-Message-State: AC+VfDxH4a9rUdhq2thVmoE2ME9MsI8h1YPGWQ/Uagk/iOUbGHTvs4pM
	24EAClZJIpKJUS33KPfIiT0=
X-Google-Smtp-Source: ACHHUZ7x4BkjqSnJp1Gd6nJ+kBx8aAprlP8Z7PZH95lCJZDoVK3KSmw2g+apNzL6fbl54xrV6eHjTg==
X-Received: by 2002:a5d:6401:0:b0:2f7:dc6a:9468 with SMTP id z1-20020a5d6401000000b002f7dc6a9468mr14141097wru.3.1683883295216;
        Fri, 12 May 2023 02:21:35 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:34 -0700 (PDT)
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
Subject: [PATCH bpf-next 06/10] selftests/xsk: store offset in pkt instead of addr
Date: Fri, 12 May 2023 11:20:39 +0200
Message-Id: <20230512092043.3028-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230512092043.3028-1-magnus.karlsson@gmail.com>
References: <20230512092043.3028-1-magnus.karlsson@gmail.com>
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
index 0823890c0709..4e7892b05d4a 100644
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
+	/* Let half of the packets straddle a 4K buffer boundrary */
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


