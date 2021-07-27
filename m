Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0757A3D75D8
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbhG0NTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbhG0NSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:34 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEBAC061796;
        Tue, 27 Jul 2021 06:18:33 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id m20-20020a05600c4f54b029024e75a15716so2326500wmq.2;
        Tue, 27 Jul 2021 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q4WMPAYqH31h8i0ApGoh11auPoZJH0Za1mJKZeaXraM=;
        b=FTOcwLTNAAq7XJvHz9TxDAz2jK1C7TUbYrc31Ojx0TFwGHWmjGe271kpqvr4UUBIWI
         PJV1ZhUz7bZ/3nfTvW50bOSnlLvjmPP6eUkP9hD/3V8KSMmquoUVuL6KCuWFeAkG40jc
         B9bc1ozBCAgepXLZuVPc8vVSj5qnuQwRdBbT7qrv4gghGU4LkNq2NZYV0JjZkbJshEa3
         pYgNdfiVyO2BtLd4TvqOg5fWh0uh3buxsQTY/ur7FBC6y5Ecz/qdYWY7bHiJabPTWFxn
         Y3TQjmvjtneTsRqrDF96MsgtRg+E4Yr0G8+S6EioYvmCIq5GC0JQmPDQPw5DAXVF/M5a
         I6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q4WMPAYqH31h8i0ApGoh11auPoZJH0Za1mJKZeaXraM=;
        b=MEKipAtQYwfnhHtElvF3dClx3V7CKCs7R2Aho0bLNyIvjgTvbUpKm7GbHrlLDeukXy
         HLunyizxOdkF3a8TsRJv9ZLDAzTtK8mG4PD6KuR9ikaqQ77juV9w+0yK/95eTjGBoqET
         Q70TwdXC4kXssPOdIX4wxvLehhp6G1iHMomxkql63sXaOmMcEnGGm4kXPEWDAGsZmOTk
         8e+cfM3v7EewMR8RfPcgy5klP593XNNO5SGT9253Ykq41OQdXZPtP0TZKyAVesW3uhZ1
         QZ4l3bqNti5y8qpA0tW6Q+803/EIhPHdYcXHx6+98TWC5artPMw33IZH3UUFkNyItYds
         w6mA==
X-Gm-Message-State: AOAM533eLLY29hnvQNzpaTYpKYkBWbtgvzLXsfC4ion2F9Sio2Lm3LNm
        MtN48cZChkdqxo4IiqeeQRk=
X-Google-Smtp-Source: ABdhPJx5BBydBlcCVoydYa0U2XTneMS26BQixjcjHlaPOfcbZZww9TTZGGE3tVvRHO9yyjhxI+bE0A==
X-Received: by 2002:a1c:4c06:: with SMTP id z6mr4100123wmf.163.1627391912430;
        Tue, 27 Jul 2021 06:18:32 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:31 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 15/17] selftests: xsk: generate packets from specification
Date:   Tue, 27 Jul 2021 15:17:51 +0200
Message-Id: <20210727131753.10924-16-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Generate packets from a specification instead of something hard
coded. The idea is that a test generates one or more packet
specifications and provides it/them to both Tx and Rx. The Tx thread
will generate from this specification and Rx will validate that it
receives what is in the specification. The specification can be the
same on both ends, meaning that everything that was sent should be
received, or different which means that Rx will only receive part of
the sent packets.

Currently, the packet specification is the same for both Rx and Tx and
the same for each test. This will change in later patches as features
and tests are added.

The data path functions are also renamed to better reflect what
actions they are performing after introducing this feature.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 254 +++++++++++++----------
 tools/testing/selftests/bpf/xdpxceiver.h |  15 +-
 2 files changed, 152 insertions(+), 117 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 285151cbe5fe..422b34b5afcc 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -422,18 +422,52 @@ static void parse_command_line(int argc, char **argv)
 	}
 }
 
-static void pkt_generate(struct ifobject *ifobject, u32 pkt_nb, u64 addr)
+static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
 {
-	void *data = xsk_umem__get_data(ifobject->umem->buffer, addr);
+	return &pkt_stream->pkts[pkt_nb];
+}
+
+static struct pkt_stream *pkt_stream_generate(u32 nb_pkts, u32 pkt_len)
+{
+	struct pkt_stream *pkt_stream;
+	u32 i;
+
+	pkt_stream = malloc(sizeof(*pkt_stream));
+	if (!pkt_stream)
+		exit_with_error(ENOMEM);
+
+	pkt_stream->pkts = calloc(DEFAULT_PKT_CNT, sizeof(*pkt_stream->pkts));
+	if (!pkt_stream->pkts)
+		exit_with_error(ENOMEM);
+
+	pkt_stream->nb_pkts = nb_pkts;
+	for (i = 0; i < nb_pkts; i++) {
+		pkt_stream->pkts[i].addr = (i % num_frames) * XSK_UMEM__DEFAULT_FRAME_SIZE;
+		pkt_stream->pkts[i].len = pkt_len;
+		pkt_stream->pkts[i].payload = i;
+	}
+
+	return pkt_stream;
+}
+
+static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
+{
+	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
+	void *data = xsk_umem__get_data(ifobject->umem->buffer, pkt->addr);
 	struct udphdr *udp_hdr =
 		(struct udphdr *)(data + sizeof(struct ethhdr) + sizeof(struct iphdr));
 	struct iphdr *ip_hdr = (struct iphdr *)(data + sizeof(struct ethhdr));
 	struct ethhdr *eth_hdr = (struct ethhdr *)data;
 
+	if (pkt_nb >= ifobject->pkt_stream->nb_pkts)
+		return NULL;
+
 	gen_udp_hdr(pkt_nb, data, ifobject, udp_hdr);
 	gen_ip_hdr(ifobject, ip_hdr);
 	gen_udp_csum(udp_hdr, ip_hdr);
 	gen_eth_hdr(ifobject, eth_hdr);
+
+	return pkt;
 }
 
 static void pkt_dump(void *pkt, u32 len)
@@ -473,33 +507,38 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "---------------------------------------\n");
 }
 
-static void pkt_validate(void *buffer, u64 addr)
+static bool pkt_validate(struct pkt *pkt, void *buffer, const struct xdp_desc *desc)
 {
-	void *data = xsk_umem__get_data(buffer, addr);
+	void *data = xsk_umem__get_data(buffer, desc->addr);
 	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
 
 	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
-		u32 expected_seqnum = pkt_counter % num_frames;
 
 		if (debug_pkt_dump && test_type != TEST_TYPE_STATS)
 			pkt_dump(data, PKT_SIZE);
 
-		if (expected_seqnum != seqnum) {
+		if (pkt->len != desc->len) {
 			ksft_test_result_fail
-				("ERROR: [%s] expected seqnum [%d], got seqnum [%d]\n",
-					__func__, expected_seqnum, seqnum);
-			sigvar = 1;
+				("ERROR: [%s] expected length [%d], got length [%d]\n",
+					__func__, pkt->len, desc->len);
+			return false;
 		}
 
-		if (++pkt_counter == opt_pkt_count)
-			sigvar = 1;
+		if (pkt->payload != seqnum) {
+			ksft_test_result_fail
+				("ERROR: [%s] expected seqnum [%d], got seqnum [%d]\n",
+					__func__, pkt->payload, seqnum);
+			return false;
+		}
 	} else {
 		ksft_print_msg("Invalid frame received: ");
 		ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
 			       iphdr->tos);
-		sigvar = 1;
+		return false;
 	}
+
+	return true;
 }
 
 static void kick_tx(struct xsk_socket_info *xsk)
@@ -512,7 +551,7 @@ static void kick_tx(struct xsk_socket_info *xsk)
 	exit_with_error(errno);
 }
 
-static void complete_tx_only(struct xsk_socket_info *xsk, int batch_size)
+static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 {
 	unsigned int rcvd;
 	u32 idx;
@@ -530,116 +569,106 @@ static void complete_tx_only(struct xsk_socket_info *xsk, int batch_size)
 	}
 }
 
-static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
+static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *xsk,
+			 struct pollfd *fds)
 {
-	unsigned int rcvd, i;
-	u32 idx_rx = 0, idx_fq = 0;
+	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkt_count = 0;
 	int ret;
 
-	rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
-	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
-			ret = poll(fds, 1, POLL_TMOUT);
-			if (ret < 0)
-				exit_with_error(-ret);
+	while (1) {
+		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
+		if (!rcvd) {
+			if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+				ret = poll(fds, 1, POLL_TMOUT);
+				if (ret < 0)
+					exit_with_error(-ret);
+			}
+			continue;
 		}
-		return;
-	}
 
-	ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
-	while (ret != rcvd) {
-		if (ret < 0)
-			exit_with_error(-ret);
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
-			ret = poll(fds, 1, POLL_TMOUT);
+		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
+			if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+				ret = poll(fds, 1, POLL_TMOUT);
+				if (ret < 0)
+					exit_with_error(-ret);
+			}
+			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 		}
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
-	}
 
-	for (i = 0; i < rcvd; i++) {
-		u64 addr, orig;
+		for (i = 0; i < rcvd; i++) {
+			const struct xdp_desc *desc = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
+			u64 addr = desc->addr, orig;
+
+			orig = xsk_umem__extract_addr(addr);
+			addr = xsk_umem__add_offset_to_addr(addr);
+			if (!pkt_validate(pkt_stream_get_pkt(pkt_stream, pkt_count++),
+					  xsk->umem->buffer, desc))
+				return;
 
-		addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
-		xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
-		orig = xsk_umem__extract_addr(addr);
+			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
+		}
 
-		addr = xsk_umem__add_offset_to_addr(addr);
-		pkt_validate(xsk->umem->buffer, addr);
+		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
+		xsk_ring_cons__release(&xsk->rx, rcvd);
 
-		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
+		if (pkt_count >= pkt_stream->nb_pkts)
+			return;
 	}
-
-	xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
-	xsk_ring_cons__release(&xsk->rx, rcvd);
 }
 
-static void tx_only(struct ifobject *ifobject, u32 *frameptr, int batch_size)
+static u32 __send_pkts(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
-	u32 idx = 0;
-	unsigned int i;
-	bool tx_invalid_test = stat_test_type == STAT_TEST_TX_INVALID;
-	u32 len = tx_invalid_test ? XSK_UMEM__DEFAULT_FRAME_SIZE + 1 : PKT_SIZE;
+	u32 i, idx;
 
-	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) < batch_size)
-		complete_tx_only(xsk, batch_size);
+	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE)
+		complete_pkts(xsk, BATCH_SIZE);
 
-	for (i = 0; i < batch_size; i++) {
+	for (i = 0; i < BATCH_SIZE; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
+		struct pkt *pkt = pkt_generate(ifobject, pkt_nb);
 
-		tx_desc->addr = (*frameptr + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
-		tx_desc->len = len;
-		pkt_generate(ifobject, *frameptr + i, tx_desc->addr);
-	}
+		if (!pkt)
+			break;
 
-	xsk_ring_prod__submit(&xsk->tx, batch_size);
-	if (!tx_invalid_test) {
-		xsk->outstanding_tx += batch_size;
-	} else if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
-		kick_tx(xsk);
+		tx_desc->addr = pkt->addr;
+		tx_desc->len = pkt->len;
+		pkt_nb++;
 	}
-	*frameptr += batch_size;
-	*frameptr %= num_frames;
-	complete_tx_only(xsk, batch_size);
-}
 
-static int get_batch_size(int pkt_cnt)
-{
-	if (pkt_cnt + BATCH_SIZE <= opt_pkt_count)
-		return BATCH_SIZE;
+	xsk_ring_prod__submit(&xsk->tx, i);
+	if (stat_test_type != STAT_TEST_TX_INVALID)
+		xsk->outstanding_tx += i;
+	else if (xsk_ring_prod__needs_wakeup(&xsk->tx))
+		kick_tx(xsk);
+	complete_pkts(xsk, i);
 
-	return opt_pkt_count - pkt_cnt;
+	return i;
 }
 
-static void complete_tx_only_all(struct ifobject *ifobject)
+static void wait_for_tx_completion(struct xsk_socket_info *xsk)
 {
-	bool pending;
-
-	do {
-		pending = false;
-		if (ifobject->xsk->outstanding_tx) {
-			complete_tx_only(ifobject->xsk, BATCH_SIZE);
-			pending = !!ifobject->xsk->outstanding_tx;
-		}
-	} while (pending);
+	while (xsk->outstanding_tx)
+		complete_pkts(xsk, BATCH_SIZE);
 }
 
-static void tx_only_all(struct ifobject *ifobject)
+static void send_pkts(struct ifobject *ifobject)
 {
 	struct pollfd fds[MAX_SOCKS] = { };
-	u32 frame_nb = 0;
-	int pkt_cnt = 0;
-	int ret;
+	u32 pkt_cnt = 0;
 
 	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds[0].events = POLLOUT;
 
-	while (pkt_cnt < opt_pkt_count) {
-		int batch_size = get_batch_size(pkt_cnt);
+	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
+		u32 sent;
 
 		if (test_type == TEST_TYPE_POLL) {
+			int ret;
+
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret <= 0)
 				continue;
@@ -648,16 +677,16 @@ static void tx_only_all(struct ifobject *ifobject)
 				continue;
 		}
 
-		tx_only(ifobject, &frame_nb, batch_size);
-		pkt_cnt += batch_size;
+		sent = __send_pkts(ifobject, pkt_cnt);
+		pkt_cnt += sent;
 	}
 
-	complete_tx_only_all(ifobject);
+	wait_for_tx_completion(ifobject->xsk);
 }
 
 static bool rx_stats_are_valid(struct ifobject *ifobject)
 {
-	u32 xsk_stat = 0, expected_stat = opt_pkt_count;
+	u32 xsk_stat = 0, expected_stat = ifobject->pkt_stream->nb_pkts;
 	struct xsk_socket *xsk = ifobject->xsk->xsk;
 	int fd = xsk_socket__fd(xsk);
 	struct xdp_statistics stats;
@@ -713,11 +742,11 @@ static void tx_stats_validate(struct ifobject *ifobject)
 		return;
 	}
 
-	if (stats.tx_invalid_descs == opt_pkt_count)
+	if (stats.tx_invalid_descs == ifobject->pkt_stream->nb_pkts)
 		return;
 
 	ksft_test_result_fail("ERROR: [%s] tx_invalid_descs incorrect. Got [%u] expected [%u]\n",
-			      __func__, stats.tx_invalid_descs, opt_pkt_count);
+			      __func__, stats.tx_invalid_descs, ifobject->pkt_stream->nb_pkts);
 }
 
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
@@ -786,8 +815,9 @@ static void *worker_testapp_validate_tx(void *arg)
 	if (!second_step)
 		thread_common_ops(ifobject, bufs);
 
-	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
-	tx_only_all(ifobject);
+	print_verbose("Sending %d packets on interface %s\n", ifobject->pkt_stream->nb_pkts,
+		      ifobject->ifname);
+	send_pkts(ifobject);
 
 	if (stat_test_type == STAT_TEST_TX_INVALID)
 		tx_stats_validate(ifobject);
@@ -813,19 +843,11 @@ static void *worker_testapp_validate_rx(void *arg)
 
 	pthread_barrier_wait(&barr);
 
-	while (1) {
-		if (test_type != TEST_TYPE_STATS) {
-			rx_pkt(ifobject->xsk, fds);
-		} else {
-			if (rx_stats_are_valid(ifobject))
-				break;
-		}
-		if (sigvar)
-			break;
-	}
-
-	print_verbose("Received %d packets on interface %s\n",
-		      pkt_counter, ifobject->ifname);
+	if (test_type == TEST_TYPE_STATS)
+		while (!rx_stats_are_valid(ifobject))
+			continue;
+	else
+		receive_pkts(ifobject->pkt_stream, ifobject->xsk, fds);
 
 	if (test_type == TEST_TYPE_TEARDOWN)
 		print_verbose("Destroying socket\n");
@@ -838,10 +860,20 @@ static void testapp_validate(void)
 {
 	bool bidi = test_type == TEST_TYPE_BIDI;
 	bool bpf = test_type == TEST_TYPE_BPF_RES;
+	struct pkt_stream *pkt_stream;
 
 	if (pthread_barrier_init(&barr, NULL, 2))
 		exit_with_error(errno);
 
+	if (stat_test_type == STAT_TEST_TX_INVALID) {
+		pkt_stream = pkt_stream_generate(DEFAULT_PKT_CNT,
+						 XSK_UMEM__DEFAULT_FRAME_SIZE + 1);
+	} else {
+		pkt_stream = pkt_stream_generate(DEFAULT_PKT_CNT, PKT_SIZE);
+	}
+	ifdict_tx->pkt_stream = pkt_stream;
+	ifdict_rx->pkt_stream = pkt_stream;
+
 	/*Spawn RX thread */
 	pthread_create(&t0, NULL, ifdict_rx->func_ptr, ifdict_rx);
 
@@ -864,8 +896,6 @@ static void testapp_teardown(void)
 	int i;
 
 	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
-		pkt_counter = 0;
-		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
 	}
@@ -891,8 +921,6 @@ static void swap_vectors(struct ifobject *ifobj1, struct ifobject *ifobj2)
 static void testapp_bidi(void)
 {
 	for (int i = 0; i < MAX_BIDI_ITER; i++) {
-		pkt_counter = 0;
-		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
 		if (!second_step) {
@@ -924,8 +952,6 @@ static void testapp_bpf_res(void)
 	int i;
 
 	for (i = 0; i < MAX_BPF_ITER; i++) {
-		pkt_counter = 0;
-		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
 		if (!second_step)
@@ -953,6 +979,8 @@ static void testapp_stats(void)
 		case STAT_TEST_RX_FULL:
 			rxqsize = RX_FULL_RXQSIZE;
 			break;
+		case STAT_TEST_TX_INVALID:
+			continue;
 		default:
 			break;
 		}
@@ -998,9 +1026,7 @@ static void run_pkt_test(int mode, int type)
 
 	/* reset defaults after potential previous test */
 	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-	pkt_counter = 0;
 	second_step = 0;
-	sigvar = 0;
 	stat_test_type = -1;
 	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 	frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index b3087270d837..f5b46cd3d8df 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -74,13 +74,10 @@ static u32 num_frames = DEFAULT_PKT_CNT / 4;
 static bool second_step;
 static int test_type;
 
-static u32 opt_pkt_count = DEFAULT_PKT_CNT;
 static u8 opt_verbose;
 
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
-static u32 pkt_counter;
-static int sigvar;
 static int stat_test_type;
 static u32 rxqsize;
 static u32 frame_headroom;
@@ -107,6 +104,17 @@ struct flow_vector {
 	} vector;
 };
 
+struct pkt {
+	u64 addr;
+	u32 len;
+	u32 payload;
+};
+
+struct pkt_stream {
+	u32 nb_pkts;
+	struct pkt *pkts;
+};
+
 struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
@@ -116,6 +124,7 @@ struct ifobject {
 	struct xsk_umem_info *umem;
 	void *(*func_ptr)(void *arg);
 	struct flow_vector fv;
+	struct pkt_stream *pkt_stream;
 	int ns_fd;
 	int ifdict_index;
 	u32 dst_ip;
-- 
2.29.0

