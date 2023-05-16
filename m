Return-Path: <netdev+bounces-2955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF0C8704AD7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84FAC281785
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7E329101;
	Tue, 16 May 2023 10:32:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD3124149;
	Tue, 16 May 2023 10:32:11 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCCA5B8A;
	Tue, 16 May 2023 03:31:40 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f42b429290so16463425e9.0;
        Tue, 16 May 2023 03:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233097; x=1686825097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Nhs9KJuMx1UMth2kzO9XHWh1G3F/qNsK0B5qngIh7Y=;
        b=bT2gODEgYpgRpBdxvChutXdSzE5APRsrUlJYgj9pLVE/2FU1y47/ML2LOyigJpTXTL
         1KclUfsuu0KNs3Cx5KbevlGZoRQLlVRGqmL7YMdLB0Wk+bvKrWfoRRKHy5hHZpkFBNUV
         FneSpSq1/oyMvRrSOZskl1Bj8+bHszDtE0U9iqEqZ34EU+EDmD3XUC3RX/KBLLBmJj9N
         r0692X+fZ0tX9gVnmBKjI17l3rnI/RBmmh+MOdFEo8VXIOmtXgZ85tX0QRc05KteVxMG
         fmaNqm8l4vLGOEDo1cEap5glbq9Esm4ZosJF6uXPlLqTBacYBo+L8Mg+tqMblilD75zi
         d/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233097; x=1686825097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Nhs9KJuMx1UMth2kzO9XHWh1G3F/qNsK0B5qngIh7Y=;
        b=Xos4Rhi6L2wxcn8+nwWhLd+WJoGdF1HeQBQUo7WytedQDte+jtm/ZlcpljfX3r/SQ1
         79xFx5s1ziQOaXX3Rjbmcx8RfTV8YM8jRiBZiQyv7t2XVupQeqxQU2gLQmd7xkMBF2Yl
         RBNVZjmn/L0Wmmx8t35C1cPi1GtkuU7z54rsw3CASS0uMRdOgArmd/XXsZPTV+/AI9q+
         2zlYacBe+x6+ZsBXdv2x3LE+ZItWspLamzD4ixjtXJILABiMBnikCEWKd6y+PCmsU7n8
         SitoS7iAhWraepoVZvxSub+1p+NrMMnolBSgNW+RfW8gp1jM3vIOPmw1XR9voA002S75
         wjMg==
X-Gm-Message-State: AC+VfDyLSMOaxbJK2Ww9Mib6KFnYf1dKn5+vY4gZ3BmpgPzDX+n4bkHf
	YuQVcHlVJnrloAlAr6BNjVA=
X-Google-Smtp-Source: ACHHUZ64aW/IkuXx2X9pUusEe8Q/992ObZgOeGbxUUKxxhWioOpd6bWpgz+pjen68+qFfxJRe3g4DQ==
X-Received: by 2002:a05:600c:198d:b0:3f4:26ce:e7be with SMTP id t13-20020a05600c198d00b003f426cee7bemr1848970wmq.3.1684233096613;
        Tue, 16 May 2023 03:31:36 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:36 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 10/10] selftests/xsk: adjust packet pacing for multi-buffer support
Date: Tue, 16 May 2023 12:31:09 +0200
Message-Id: <20230516103109.3066-11-magnus.karlsson@gmail.com>
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
index b48017611499..218d7f694e5c 100644
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


