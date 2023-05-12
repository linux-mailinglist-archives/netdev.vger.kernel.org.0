Return-Path: <netdev+bounces-2087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3543E70039B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF870281768
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A3AD512;
	Fri, 12 May 2023 09:21:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBC39475;
	Fri, 12 May 2023 09:21:36 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B20BDDA6;
	Fri, 12 May 2023 02:21:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3062d33b5ccso1708171f8f.1;
        Fri, 12 May 2023 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883293; x=1686475293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nYDojFnYPj8dTRcEFTZ5HApJQqIQeVxvZODIsszaj+8=;
        b=B9sEm25yVV8Pp4Ynllr3AdiUuu1no8c77xOOXkSY+MR1d2LOf+ukIkz0O7kAZE36gD
         2Ip/3M/z8ddVan+Ze/SrzXxADmZB+oV/yMNW3JOOXHJ67JD43VZmZTDjWVNEu77bxuBb
         aAQpztmHZOMrHlIXyTETg/4ilUY9LpGToBUNovLzzY1kMNnPGHQ7B6Xck1BP4MKves5s
         FpAUT0mqRz8b8mVFeqUORgO317oPAM8ygNAhihrSMTi9EPtvSrz2qCr9ml/A6X8z8YQ4
         mZEPrjt88BF7DaxVUz9C5kKimvwNac/k4lyNZOw3oHvJXZTs+AT/r3XStvrbfGfS31N9
         6HWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883293; x=1686475293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYDojFnYPj8dTRcEFTZ5HApJQqIQeVxvZODIsszaj+8=;
        b=T8vF9BkgVYZ2TXHC1l/l5/3+LebSorFi5pwdtnSt5yS8av/XSWIEI13pQ5mUqQpjjd
         IswlsELCtj1U+e9EVJNSZtX9fsk/3Ed83lkg/7FL3ycIohkf5EvzCe99bsC+fR5mRAGS
         E3OouvbTfLJHVY0FK4Fk7X4EEi2sZ/C8GNayRSxEjgqNC3D5Jyq0VK43H/U740VtURw1
         9mxtugF4NtfqgipesufyQ86m65dv6E6XbAlBIcAijMoirpH0rgc0JuU49NwxPN/srmqf
         Yq+PdPpzi5H5VIvGZe23eyjgaTBH95/rGtvKs/BtJBjydNrcCabEpwZHX6bVwJVGMQ8y
         DxRg==
X-Gm-Message-State: AC+VfDxyG4sn4f3bIostIT7MgFVeqSos+jHV4mh9XFnOsoIH0BMhpLB9
	bSmX6c4O24Zu4HNHL6hOFx0=
X-Google-Smtp-Source: ACHHUZ5/YMo5e75mal2xc2pbSL/16EpC0xFosghF6C5/rYu5+3JzhY218FnzsAbqLhPURPgj1YTwAA==
X-Received: by 2002:adf:e60e:0:b0:307:5561:5eea with SMTP id p14-20020adfe60e000000b0030755615eeamr14528995wrm.0.1683883293303;
        Fri, 12 May 2023 02:21:33 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:32 -0700 (PDT)
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
Subject: [PATCH bpf-next 05/10] selftests/xsk: add packet iterator for tx to packet stream
Date: Fri, 12 May 2023 11:20:38 +0200
Message-Id: <20230512092043.3028-6-magnus.karlsson@gmail.com>
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


