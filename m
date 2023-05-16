Return-Path: <netdev+bounces-2949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F05C704ABF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472E01C20DA7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30936171BF;
	Tue, 16 May 2023 10:31:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E624EA1;
	Tue, 16 May 2023 10:31:54 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA9D6199;
	Tue, 16 May 2023 03:31:28 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3079b59230eso1312704f8f.1;
        Tue, 16 May 2023 03:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233087; x=1686825087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nYDojFnYPj8dTRcEFTZ5HApJQqIQeVxvZODIsszaj+8=;
        b=pcVgBJUPJdJe0RH0YVFDrTsCmLCsJgnv2xVBQFrPkug1SvA+SEcAbJCap+q1xqBPRk
         rjXCrtRkUQ79a0I4QiDtYKR67UzDmtO+KROi3//mxWFQ6JylHN4+sps7Dm7yUuRBc4PY
         3IuFLqNPjzRmXucDsNP2iewqfU2rTWhETO3bJXWnCZzbccdwRUz4YnEVRabZ6MSE9XkV
         50By5ltI4DwRjBOvoN8SXOsumazhwypU+FBbkRci7hlMmvj/GSRn3gSHv94MuyUah1Jz
         8mbOimmrE7KAyu3J4RNHI9Y5L1Tm9oY9OnK9ExAiBN+hLvCzOhT8uV9rYQ6XGfopsZEG
         pCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233087; x=1686825087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYDojFnYPj8dTRcEFTZ5HApJQqIQeVxvZODIsszaj+8=;
        b=AxyYUW5Nu74IqXZlcozb1/gEGkHRicETnm9NUG0OSU2nboUfV7XlUwSzPJCGaRxzXz
         8Y1dSkMFbZtLjcb0KPwEUuvpOFyli+jB0r7qNTEQpdpBOQGt24w5fmusu7MiZ3+uBx2Z
         o6e7dKBJyJ1MPU531wHyWDQUD/qElqBCvyjB9p9eQeH1kDc/UCo3f+RHY08+UwSFwTFe
         e4EIL29AwdySGzNGuH0/wAC+6fgydlyuBh43lvuWm+u9/SFNCsG1MVVNQzeYTehSbVzQ
         n4XHj/MXgTlSxMFkykSk2mv6NgZ/YPZUsZuWHRJEjnTwFRUBqjky2OSeKiWVDGWE9cY4
         u4Vw==
X-Gm-Message-State: AC+VfDyCPhcydHQlqZ9QXbDdI5ELT8pSDKxTAfNX9E1u3yQijHEpnFOs
	ByMRgjqceDkXaiHp3WFbn7YxGlcTWbc9THzPEqY=
X-Google-Smtp-Source: ACHHUZ7T5+DEdI6hQmMEIqGJqnfK1UN5DTl5TlSUTrDA5b+IF+l44dNEYN/eTlchZhPp/BovREjdpw==
X-Received: by 2002:a5d:4c48:0:b0:302:1af8:3cc0 with SMTP id n8-20020a5d4c48000000b003021af83cc0mr1549988wrt.6.1684233086621;
        Tue, 16 May 2023 03:31:26 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:26 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 05/10] selftests/xsk: add packet iterator for tx to packet stream
Date: Tue, 16 May 2023 12:31:04 +0200
Message-Id: <20230516103109.3066-6-magnus.karlsson@gmail.com>
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
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Convert the current variable rx_pkt_nb to an iterator that can be used
for both Rx and Tx. This to simplify the code and making Tx more like
Rx that already has this feature.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 43 +++++++++++++-----------
 tools/testing/selftests/bpf/xskxceiver.h |  2 +-
 2 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 0a8231ed6626..0823890c0709 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -444,24 +444,24 @@ static void test_spec_set_xdp_prog(struct test_spec *test, struct bpf_program *x
 static void pkt_stream_reset(struct pkt_stream *pkt_stream)
 {
 	if (pkt_stream)
-		pkt_stream->rx_pkt_nb = 0;
+		pkt_stream->current_pkt_nb = 0;
 }
 
-static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
+static struct pkt *pkt_stream_get_next_tx_pkt(struct pkt_stream *pkt_stream)
 {
-	if (pkt_nb >= pkt_stream->nb_pkts)
+	if (pkt_stream->current_pkt_nb >= pkt_stream->nb_pkts)
 		return NULL;
 
-	return &pkt_stream->pkts[pkt_nb];
+	return &pkt_stream->pkts[pkt_stream->current_pkt_nb++];
 }
 
 static struct pkt *pkt_stream_get_next_rx_pkt(struct pkt_stream *pkt_stream, u32 *pkts_sent)
 {
-	while (pkt_stream->rx_pkt_nb < pkt_stream->nb_pkts) {
+	while (pkt_stream->current_pkt_nb < pkt_stream->nb_pkts) {
 		(*pkts_sent)++;
-		if (pkt_stream->pkts[pkt_stream->rx_pkt_nb].valid)
-			return &pkt_stream->pkts[pkt_stream->rx_pkt_nb++];
-		pkt_stream->rx_pkt_nb++;
+		if (pkt_stream->pkts[pkt_stream->current_pkt_nb].valid)
+			return &pkt_stream->pkts[pkt_stream->current_pkt_nb++];
+		pkt_stream->current_pkt_nb++;
 	}
 	return NULL;
 }
@@ -584,9 +584,9 @@ static void pkt_stream_receive_half(struct test_spec *test)
 		pkt_stream->pkts[i].valid = false;
 }
 
-static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
+static struct pkt *pkt_generate(struct ifobject *ifobject)
 {
-	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
+	struct pkt *pkt = pkt_stream_get_next_tx_pkt(ifobject->pkt_stream);
 	struct ethhdr *eth_hdr;
 	void *data;
 
@@ -599,7 +599,7 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 	eth_hdr = data;
 
 	gen_eth_hdr(ifobject, eth_hdr);
-	write_payload(data + PKT_HDR_SIZE, pkt_nb, pkt->len - PKT_HDR_SIZE);
+	write_payload(data + PKT_HDR_SIZE, pkt->pkt_nb, pkt->len - PKT_HDR_SIZE);
 
 	return pkt;
 }
@@ -883,8 +883,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 	return TEST_PASS;
 }
 
-static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fds,
-		       bool timeout)
+static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeout)
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
 	bool use_poll = ifobject->use_poll;
@@ -916,14 +915,13 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 
 	for (i = 0; i < BATCH_SIZE; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
-		struct pkt *pkt = pkt_generate(ifobject, *pkt_nb);
+		struct pkt *pkt = pkt_generate(ifobject);
 
 		if (!pkt)
 			break;
 
 		tx_desc->addr = pkt->addr;
 		tx_desc->len = pkt->len;
-		(*pkt_nb)++;
 		if (pkt->valid)
 			valid_pkts++;
 	}
@@ -970,15 +968,16 @@ static void wait_for_tx_completion(struct xsk_socket_info *xsk)
 
 static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
 {
+	struct pkt_stream *pkt_stream = ifobject->pkt_stream;
 	bool timeout = !is_umem_valid(test->ifobj_rx);
 	struct pollfd fds = { };
-	u32 pkt_cnt = 0, ret;
+	u32 ret;
 
 	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds.events = POLLOUT;
 
-	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
-		ret = __send_pkts(ifobject, &pkt_cnt, &fds, timeout);
+	while (pkt_stream->current_pkt_nb < pkt_stream->nb_pkts) {
+		ret = __send_pkts(ifobject, &fds, timeout);
 		if ((ret || test->fail) && !timeout)
 			return TEST_FAILURE;
 		else if (ret == TEST_PASS && timeout)
@@ -1150,7 +1149,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 		u64 addr;
 
 		if (pkt_stream->use_addr_for_fill) {
-			struct pkt *pkt = pkt_stream_get_pkt(pkt_stream, i);
+			struct pkt *pkt = pkt_stream_get_next_tx_pkt(pkt_stream);
 
 			if (!pkt)
 				break;
@@ -1162,6 +1161,8 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
 	}
 	xsk_ring_prod__submit(&umem->fq, i);
+
+	pkt_stream_reset(pkt_stream);
 }
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
@@ -1339,9 +1340,11 @@ static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *i
 {
 	pthread_t t0, t1;
 
-	if (ifobj2)
+	if (ifobj2) {
 		if (pthread_barrier_init(&barr, NULL, 2))
 			exit_with_error(errno);
+		pkt_stream_reset(ifobj2->pkt_stream);
+	}
 
 	test->current_step++;
 	pkt_stream_reset(ifobj1->pkt_stream);
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 5e0be9685557..7ea28d844007 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -117,7 +117,7 @@ struct pkt {
 
 struct pkt_stream {
 	u32 nb_pkts;
-	u32 rx_pkt_nb;
+	u32 current_pkt_nb;
 	struct pkt *pkts;
 	bool use_addr_for_fill;
 };
-- 
2.34.1


