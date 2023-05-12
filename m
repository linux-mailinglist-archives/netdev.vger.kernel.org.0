Return-Path: <netdev+bounces-2092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5987003B5
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 763321C211A0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E41C10791;
	Fri, 12 May 2023 09:21:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913281078F;
	Fri, 12 May 2023 09:21:46 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B793D2DC;
	Fri, 12 May 2023 02:21:44 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-3079b59230eso773849f8f.1;
        Fri, 12 May 2023 02:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683883303; x=1686475303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qpLGphmtmYp9llVxEEqTu82YRnVZuRWAB3QJZbit1Qc=;
        b=BwOPQaqtK++Bjf2wHsZ1C5USn2Sedsrvc33RvjLrLGvenLi/vL29N/4DDoMlx/uJXJ
         RbcPEZYlX0fbrfiKpGHnNHQKBySa/7ICeqM8QcEwHioEc5AEP/ETTm6uWshwLqoKHBmT
         xq0H0FXLP+9l0lU9454DBK47W3FWjk2DqMmxgzzY9sEBb44HWRjYdtB1WvJQ2ZuXucDu
         +6Iizb7onz7suTvzjCa0dVXgqoSV8K82HjIbZsA5SXedzP7qRAg/UcwIpKHX/PlLC9za
         1RertRzuryjqwTzAbp/rfI5oQTXY7+CZ46K93e6kolekwjyaoweM+Wu+wxh/RTmZz4L1
         KOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683883303; x=1686475303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpLGphmtmYp9llVxEEqTu82YRnVZuRWAB3QJZbit1Qc=;
        b=O8ng9sE4v/h4M4EsTSwXzeZ9aYBKQCB68GdfincU0qNJuliyNzct9uKQnrBPiNx6UI
         rxPSm2rLyJSeWkofuoqAb/a+pccCDT3UjwkB1SZkM3NMosa7DQZ9KpAohtcGYFeptZGV
         qzU7kMd2E2T95hQE5nxqQxQMpviYoGZCOL4WvvLv2cO3SjwDOJ3UhQdh3RuQFL7bmkvX
         NwyebhiGkpSCoE7eLeWStxbTh3UtQloS3dpD2eskSzC6PeuWhV9/0Gids/COlJRo54/0
         7i149+NlEIjGdkMmQQKqKXtwZets33OKaf+MhIlC0/PrSxoWZVA1m4F0/mKE2ACw9tJw
         vOIQ==
X-Gm-Message-State: AC+VfDyFp4/ONa0+HycZ/LAU3iqyREu305KwJsx6VRtGPCf4Meb2gcYb
	xYJQzCIsHVn+wFRreqAsN0M=
X-Google-Smtp-Source: ACHHUZ4OK1wc6emfq/bAQf3P68miw8neouIkojzOsNGV8AiKfKzSggVSM78pPugK2dgouJs0kbwdGw==
X-Received: by 2002:a5d:5641:0:b0:305:f3c1:184e with SMTP id j1-20020a5d5641000000b00305f3c1184emr15710811wrw.3.1683883302709;
        Fri, 12 May 2023 02:21:42 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id i14-20020a5d558e000000b003079f2c2de7sm11467789wrv.112.2023.05.12.02.21.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 May 2023 02:21:42 -0700 (PDT)
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
Subject: [PATCH bpf-next 10/10] selftests/xsk: adjust packet pacing for multi-buffer support
Date: Fri, 12 May 2023 11:20:43 +0200
Message-Id: <20230512092043.3028-11-magnus.karlsson@gmail.com>
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

Modify the packet pacing algorithm so that it works with multi-buffer
packets. This algorithm makes sure we do not send too many buffers to
the receiving thread so that packets have to be dropped. The previous
algorithm made the assumption that each packet only consumes one
buffer, but that is not true anymore when multi-buffer support gets
added. Instead, we find out what the largest packet size is in the
packet stream and assume that each packet will consume this many
buffers. This is conservative and overly cautious as there might be
smaller packets in the stream that need fewer buffers per packet. But
it keeps the algorithm simple.

Also simplify it by removing the pthread conditional and just test if
there is enough space in the Rx thread before trying to send one more
batch. Also makes the tests run faster.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 48 ++++++++++++++----------
 tools/testing/selftests/bpf/xskxceiver.h |  2 +-
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index c21c57a1f6e9..1986fb9fe797 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -555,6 +555,11 @@ static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, int offset, u32
 		pkt->valid = true;
 }
 
+static u32 pkt_get_buffer_len(struct xsk_umem_info *umem, u32 len)
+{
+	return ceil_u32(len, umem->frame_size) * umem->frame_size;
+}
+
 static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
 {
 	struct pkt_stream *pkt_stream;
@@ -564,6 +569,8 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
+	pkt_stream->nb_pkts = nb_pkts;
+	pkt_stream->max_pkt_len = pkt_len;
 	for (i = 0; i < nb_pkts; i++) {
 		struct pkt *pkt = &pkt_stream->pkts[i];
 
@@ -661,10 +668,14 @@ static void __pkt_stream_generate_custom(struct ifobject *ifobj,
 		exit_with_error(ENOMEM);
 
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].offset = pkts[i].offset;
-		pkt_stream->pkts[i].len = pkts[i].len;
-		pkt_stream->pkts[i].pkt_nb = i;
-		pkt_stream->pkts[i].valid = pkts[i].valid;
+		struct pkt *pkt = &pkt_stream->pkts[i];
+
+		pkt->offset = pkts[i].offset;
+		pkt->len = pkts[i].len;
+		pkt->pkt_nb = i;
+		pkt->valid = pkts[i].valid;
+		if (pkt->len > pkt_stream->max_pkt_len)
+			pkt_stream->max_pkt_len = pkt->len;
 	}
 
 	ifobj->pkt_stream = pkt_stream;
@@ -926,8 +937,6 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 
 		pthread_mutex_lock(&pacing_mutex);
 		pkts_in_flight -= pkts_sent;
-		if (pkts_in_flight < umem->num_frames)
-			pthread_cond_signal(&pacing_cond);
 		pthread_mutex_unlock(&pacing_mutex);
 		pkts_sent = 0;
 	}
@@ -938,10 +947,18 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeout)
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
+	struct xsk_umem_info *umem = ifobject->umem;
+	u32 i, idx = 0, valid_pkts = 0, buffer_len;
 	bool use_poll = ifobject->use_poll;
-	u32 i, idx = 0, valid_pkts = 0;
 	int ret;
 
+	buffer_len = pkt_get_buffer_len(umem, ifobject->pkt_stream->max_pkt_len);
+	/* pkts_in_flight might be negative if many invalid packets are sent */
+	if (pkts_in_flight >= (int)((umem_size(umem) - BATCH_SIZE * buffer_len) / buffer_len)) {
+		kick_tx(xsk);
+		return TEST_CONTINUE;
+	}
+
 	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
 		if (use_poll) {
 			ret = poll(fds, 1, POLL_TMOUT);
@@ -972,7 +989,7 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 		if (!pkt)
 			break;
 
-		tx_desc->addr = pkt_get_addr(pkt, ifobject->umem);
+		tx_desc->addr = pkt_get_addr(pkt, umem);
 		tx_desc->len = pkt->len;
 		if (pkt->valid) {
 			valid_pkts++;
@@ -982,11 +999,6 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 
 	pthread_mutex_lock(&pacing_mutex);
 	pkts_in_flight += valid_pkts;
-	/* pkts_in_flight might be negative if many invalid packets are sent */
-	if (pkts_in_flight >= (int)(ifobject->umem->num_frames - BATCH_SIZE)) {
-		kick_tx(xsk);
-		pthread_cond_wait(&pacing_cond, &pacing_mutex);
-	}
 	pthread_mutex_unlock(&pacing_mutex);
 
 	xsk_ring_prod__submit(&xsk->tx, i);
@@ -1032,9 +1044,11 @@ static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
 
 	while (pkt_stream->current_pkt_nb < pkt_stream->nb_pkts) {
 		ret = __send_pkts(ifobject, &fds, timeout);
+		if (ret == TEST_CONTINUE && !test->fail)
+			continue;
 		if ((ret || test->fail) && !timeout)
 			return TEST_FAILURE;
-		else if (ret == TEST_PASS && timeout)
+		if (ret == TEST_PASS && timeout)
 			return ret;
 	}
 
@@ -1319,12 +1333,8 @@ static void *worker_testapp_validate_rx(void *arg)
 
 	if (!err && ifobject->validation_func)
 		err = ifobject->validation_func(ifobject);
-	if (err) {
+	if (err)
 		report_failure(test);
-		pthread_mutex_lock(&pacing_mutex);
-		pthread_cond_signal(&pacing_cond);
-		pthread_mutex_unlock(&pacing_mutex);
-	}
 
 	pthread_exit(NULL);
 }
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 00862732e751..aaf27e067640 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -121,6 +121,7 @@ struct pkt_stream {
 	u32 nb_pkts;
 	u32 current_pkt_nb;
 	struct pkt *pkts;
+	u32 max_pkt_len;
 };
 
 struct ifobject;
@@ -173,7 +174,6 @@ struct test_spec {
 
 pthread_barrier_t barr;
 pthread_mutex_t pacing_mutex = PTHREAD_MUTEX_INITIALIZER;
-pthread_cond_t pacing_cond = PTHREAD_COND_INITIALIZER;
 
 int pkts_in_flight;
 
-- 
2.34.1


