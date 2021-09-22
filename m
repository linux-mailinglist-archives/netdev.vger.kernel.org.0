Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2105F414317
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhIVH6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhIVH6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CFC061757;
        Wed, 22 Sep 2021 00:57:01 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q26so4087053wrc.7;
        Wed, 22 Sep 2021 00:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5j/IuEsHJRpmgARTV2Ke6K0LjHZ6K5CZVPWjjGKacKw=;
        b=WUrvjjNwfX1JtDiuzYJgYqD0CeIztDiN01/YiQhCD7WR4QedIhBQOJBRD1YiVizyFE
         zlG9m/+v1rU7J1ou7OuiiO6vewcwIqV3NyagWUju6TTWcOPV1JYN2t4FMuNQXZZ+XiMn
         x5Bj+hA4ehZ7zxLxDyQy47A+nU+tjpqetnHum8x1Kl0cFgKLMs4EFKNPrMcNrB2CFlmX
         vE+EFdwb13bYnBfLlyLMyUbIcQTv96vgLM3P3p1sjwFwXqpLPZ/71tcURLTcb9qA6Ob3
         HgTUeWyBqpI013CnWS782vfbD9rznmfINOrM6IAahTO9yBMe8LQeneO6GUy2J3UuIwQS
         xjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5j/IuEsHJRpmgARTV2Ke6K0LjHZ6K5CZVPWjjGKacKw=;
        b=sPJYMPs7kotOrUw6d7GzrLzUk/sgBlTNQ50LTSLclEPpcT3Uw/XPSg4IljG1v/hZWk
         O6C1GXKGjCCMsgJTk2COwksJkDkG4eWdSEeHyV8M5ObVVtwKo/1wzPHimRvg4F6/ya1W
         1pQF+RTrKQfEMQjY0cGvvCHCpS80jhmPuGkr+Xy1qZNArfaU3mWQZi908v363W2cq6/e
         8O+DgH4GvViPXn+zEb2nPMFeJdDKsBB/4O8i0JChTQCDLlEypEeaiiqDiYVB1zf69FuG
         bb9G/NIUus/EPgjLxySAuorNS0h0/TStTdM/wUmZ/xgHvfVxOM3XBp29s9CJraBG+EDJ
         YF8w==
X-Gm-Message-State: AOAM530KbdmxdYGgPlnQKOlNn9yUtZ2PxK1s9uecAIYsyBs611yytEf9
        5MR8IZBRt3KGkEbXQ3c2E4Ji5+uH/4YpW3zM
X-Google-Smtp-Source: ABdhPJxp4TZ97F8DL0PdzYBT8nNdO9jre7rOQXj0IGZyCDjjOLzZgaZGuCLW5a709kSa/iwZjjKnFA==
X-Received: by 2002:a1c:7f57:: with SMTP id a84mr8978607wmd.34.1632297420065;
        Wed, 22 Sep 2021 00:57:00 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:59 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 13/13] selftests: xsk: add frame_headroom test
Date:   Wed, 22 Sep 2021 09:56:13 +0200
Message-Id: <20210922075613.12186-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a test for the frame_headroom feature that can be set on the
umem. The logic added validates that all offsets in all tests and
packets are valid, not just the ones that have a specifically
configured frame_headroom.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 52 +++++++++++++++++++-----
 tools/testing/selftests/bpf/xdpxceiver.h |  3 +-
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index fd620f8accfd..6c7cf8aadc79 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -514,8 +514,7 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 
 	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size +
-			DEFAULT_OFFSET;
+		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
 		pkt_stream->pkts[i].len = pkt_len;
 		pkt_stream->pkts[i].payload = i;
 
@@ -642,6 +641,25 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "---------------------------------------\n");
 }
 
+static bool is_offset_correct(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream, u64 addr,
+			      u64 pkt_stream_addr)
+{
+	u32 headroom = umem->unaligned_mode ? 0 : umem->frame_headroom;
+	u32 offset = addr % umem->frame_size, expected_offset = 0;
+
+	if (!pkt_stream->use_addr_for_fill)
+		pkt_stream_addr = 0;
+
+	expected_offset += (pkt_stream_addr + headroom + XDP_PACKET_HEADROOM) % umem->frame_size;
+
+	if (offset == expected_offset)
+		return true;
+
+	ksft_test_result_fail("ERROR: [%s] expected [%u], got [%u]\n", __func__, expected_offset,
+			      offset);
+	return false;
+}
+
 static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
 	void *data = xsk_umem__get_data(buffer, addr);
@@ -724,6 +742,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 			 struct pollfd *fds)
 {
 	struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
+	struct xsk_umem_info *umem = xsk->umem;
 	u32 idx_rx = 0, idx_fq = 0, rcvd, i;
 	u32 total = 0;
 	int ret;
@@ -731,7 +750,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 	while (pkt) {
 		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
 		if (!rcvd) {
-			if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				ret = poll(fds, 1, POLL_TMOUT);
 				if (ret < 0)
 					exit_with_error(-ret);
@@ -739,16 +758,16 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 			continue;
 		}
 
-		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+		ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
-			if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				ret = poll(fds, 1, POLL_TMOUT);
 				if (ret < 0)
 					exit_with_error(-ret);
 			}
-			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
 
 		for (i = 0; i < rcvd; i++) {
@@ -765,14 +784,17 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 
 			orig = xsk_umem__extract_addr(addr);
 			addr = xsk_umem__add_offset_to_addr(addr);
-			if (!is_pkt_valid(pkt, xsk->umem->buffer, addr, desc->len))
+
+			if (!is_pkt_valid(pkt, umem->buffer, addr, desc->len))
+				return;
+			if (!is_offset_correct(umem, pkt_stream, addr, pkt->addr))
 				return;
 
-			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
+			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
 			pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
 		}
 
-		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
+		xsk_ring_prod__submit(&umem->fq, rcvd);
 		xsk_ring_cons__release(&xsk->rx, rcvd);
 
 		pthread_mutex_lock(&pacing_mutex);
@@ -1011,7 +1033,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 				break;
 			addr = pkt->addr;
 		} else {
-			addr = i * umem->frame_size + DEFAULT_OFFSET;
+			addr = i * umem->frame_size;
 		}
 
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
@@ -1134,6 +1156,13 @@ static void testapp_bpf_res(struct test_spec *test)
 	testapp_validate_traffic(test);
 }
 
+static void testapp_headroom(struct test_spec *test)
+{
+	test_spec_set_name(test, "UMEM_HEADROOM");
+	test->ifobj_rx->umem->frame_headroom = UMEM_HEADROOM_TEST_SIZE;
+	testapp_validate_traffic(test);
+}
+
 static void testapp_stats(struct test_spec *test)
 {
 	int i;
@@ -1346,6 +1375,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		if (!testapp_unaligned(test))
 			return;
 		break;
+	case TEST_TYPE_HEADROOM:
+		testapp_headroom(test);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index d075192c95f8..2f705f44b748 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -41,7 +41,7 @@
 #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
 #define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
 #define RX_FULL_RXQSIZE 32
-#define DEFAULT_OFFSET 256
+#define UMEM_HEADROOM_TEST_SIZE 128
 #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
@@ -61,6 +61,7 @@ enum test_type {
 	TEST_TYPE_ALIGNED_INV_DESC,
 	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
 	TEST_TYPE_UNALIGNED_INV_DESC,
+	TEST_TYPE_HEADROOM,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
 	TEST_TYPE_STATS,
-- 
2.29.0

