Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30963643F73
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiLFJKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiLFJJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:31 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3861E3F2;
        Tue,  6 Dec 2022 01:09:28 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h12so22472473wrv.10;
        Tue, 06 Dec 2022 01:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PNAKC/c1wYQ9/vlR01X9BOfPviXVVVveassJe2Lsy0=;
        b=XwwZRVlCxmkJ7oUm0TZMj28Qrn9eYQV1Q1crJe6bTGSNfncWKwxHpr5+joA27afSln
         vyQA/6rTjpqya3Jh4V93UbZmWXMcjFtF4HW/sOJRv8InryyQUfLqEdF4qTrHo8xQB9Sc
         1vP6C6v/nyynDg9lZkB9wxTRK3XA5XKYM8eCOie2eMquylJ5+th8yQFLQIiWw45ziDN7
         Zt3fV/HMf/IM82IQCa1dM6JRG8/5HfdYHkNKyD1sO8Qcktk4TDV7GS2fNmxj05O+AV4D
         K9uzMYiAAybcjGVuhoF7x9UeGovpAAuNGUnclKbJ12qgB8lvvyag20fJvu6JgF9sGeKt
         SLCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PNAKC/c1wYQ9/vlR01X9BOfPviXVVVveassJe2Lsy0=;
        b=fKQqlwSYOES3wOF8Q/NKJJRIOgjVQuNI32pt+4wfqwKTGCG6VFZZn5CNv9qgKO2mwn
         xjBUqvP+yoC/z9J7azj05Ultf1NgRdN0WWbo4Ht9na+dG7a+cY7n0GsTymq07iRjm+TA
         rTm4uxBkBIknem5TsGpgX6Qx+CRx/AEzKXRCz/A6v+jUVeyPIuPJt2u+f9de5sXjhjm6
         PPOEB4kzSzy5+RRwQnzieW5mLDv1hfVsqwqpHc0KTTJBbrbGhbpQOojh/nk/X2ufy2Y5
         qxuXln5lhyECPPQfItWlmW/nikrCc81U55mMhD30YdasPvpw/e6glIxAIZCMcZd1cxNr
         rQIQ==
X-Gm-Message-State: ANoB5pkSQTKGfwo7rejtiZGSemjZKt2X3BULFPyQaHfC+XSZAoq7qhoU
        HmzGhY/8QZdNF5xpTbIiWRQvnO6wdfxKhbo+wyk=
X-Google-Smtp-Source: AA0mqf4VEG9vP9iWsKjwR0SVHTc5stZb01ECJnIXQeo+z3AVTDExo1UzcnQwTCjrP0OR4LFiPXgBoQ==
X-Received: by 2002:adf:fd03:0:b0:242:5361:54ee with SMTP id e3-20020adffd03000000b00242536154eemr7369679wrr.667.1670317767329;
        Tue, 06 Dec 2022 01:09:27 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:26 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 13/15] selftests/xsk: merge dual and single thread dispatchers
Date:   Tue,  6 Dec 2022 10:08:24 +0100
Message-Id: <20221206090826.2957-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make the thread dispatching code common by unifying the dual and
single thread dispatcher code. This so we do not have to add code in
two places in upcoming commits.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 120 ++++++++++-------------
 1 file changed, 54 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 522dc1d69c17..0457874c0995 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1364,85 +1364,61 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
-static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
-						  enum test_type type)
+static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj_rx,
+				      struct ifobject *ifobj_tx)
 {
-	bool old_shared_umem = ifobj->shared_umem;
-	pthread_t t0;
-
-	if (pthread_barrier_init(&barr, NULL, 2))
-		exit_with_error(errno);
-
-	test->current_step++;
-	if (type == TEST_TYPE_POLL_RXQ_TMOUT)
-		pkt_stream_reset(ifobj->pkt_stream);
-	pkts_in_flight = 0;
-
-	test->ifobj_rx->shared_umem = false;
-	test->ifobj_tx->shared_umem = false;
-
-	signal(SIGUSR1, handler);
-	/* Spawn thread */
-	pthread_create(&t0, NULL, ifobj->func_ptr, test);
-
-	if (type != TEST_TYPE_POLL_TXQ_TMOUT)
-		pthread_barrier_wait(&barr);
-
-	if (pthread_barrier_destroy(&barr))
-		exit_with_error(errno);
-
-	pthread_kill(t0, SIGUSR1);
-	pthread_join(t0, NULL);
-
-	if (test->total_steps == test->current_step || test->fail) {
-		xsk_socket__delete(ifobj->xsk->xsk);
-		xsk_clear_xskmap(ifobj->xskmap);
-		testapp_clean_xsk_umem(ifobj);
-	}
-
-	test->ifobj_rx->shared_umem = old_shared_umem;
-	test->ifobj_tx->shared_umem = old_shared_umem;
-
-	return !!test->fail;
-}
-
-static int testapp_validate_traffic(struct test_spec *test)
-{
-	struct ifobject *ifobj_tx = test->ifobj_tx;
-	struct ifobject *ifobj_rx = test->ifobj_rx;
 	pthread_t t0, t1;
 
-	if (pthread_barrier_init(&barr, NULL, 2))
-		exit_with_error(errno);
+	if (ifobj_tx)
+		if (pthread_barrier_init(&barr, NULL, 2))
+			exit_with_error(errno);
 
 	test->current_step++;
 	pkt_stream_reset(ifobj_rx->pkt_stream);
 	pkts_in_flight = 0;
 
+	signal(SIGUSR1, handler);
 	/*Spawn RX thread */
 	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
 
-	pthread_barrier_wait(&barr);
-	if (pthread_barrier_destroy(&barr))
-		exit_with_error(errno);
+	if (ifobj_tx) {
+		pthread_barrier_wait(&barr);
+		if (pthread_barrier_destroy(&barr))
+			exit_with_error(errno);
 
-	/*Spawn TX thread */
-	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
+		/*Spawn TX thread */
+		pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
 
-	pthread_join(t1, NULL);
-	pthread_join(t0, NULL);
+		pthread_join(t1, NULL);
+	}
+
+	if (!ifobj_tx)
+		pthread_kill(t0, SIGUSR1);
+	else
+		pthread_join(t0, NULL);
 
 	if (test->total_steps == test->current_step || test->fail) {
-		xsk_socket__delete(ifobj_tx->xsk->xsk);
+		if (ifobj_tx)
+			xsk_socket__delete(ifobj_tx->xsk->xsk);
 		xsk_socket__delete(ifobj_rx->xsk->xsk);
 		testapp_clean_xsk_umem(ifobj_rx);
-		if (!ifobj_tx->shared_umem)
+		if (ifobj_tx && !ifobj_tx->shared_umem)
 			testapp_clean_xsk_umem(ifobj_tx);
 	}
 
 	return !!test->fail;
 }
 
+static int testapp_validate_traffic(struct test_spec *test)
+{
+	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
+}
+
+static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
+{
+	return __testapp_validate_traffic(test, ifobj, NULL);
+}
+
 static void testapp_teardown(struct test_spec *test)
 {
 	int i;
@@ -1684,6 +1660,26 @@ static void testapp_xdp_drop(struct test_spec *test)
 	ifobj->xskmap = ifobj->def_prog->maps.xsk;
 }
 
+static void testapp_poll_txq_tmout(struct test_spec *test)
+{
+	test_spec_set_name(test, "POLL_TXQ_FULL");
+
+	test->ifobj_tx->use_poll = true;
+	/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
+	test->ifobj_tx->umem->frame_size = 2048;
+	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
+	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
+
+	pkt_stream_restore_default(test);
+}
+
+static void testapp_poll_rxq_tmout(struct test_spec *test)
+{
+	test_spec_set_name(test, "POLL_RXQ_EMPTY");
+	test->ifobj_rx->use_poll = true;
+	testapp_validate_traffic_single_thread(test, test->ifobj_rx);
+}
+
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->def_prog = xsk_def_prog__open_and_load();
@@ -1799,18 +1795,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_POLL_TXQ_TMOUT:
-		test_spec_set_name(test, "POLL_TXQ_FULL");
-		test->ifobj_tx->use_poll = true;
-		/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
-		test->ifobj_tx->umem->frame_size = 2048;
-		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
-		testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
-		pkt_stream_restore_default(test);
+		testapp_poll_txq_tmout(test);
 		break;
 	case TEST_TYPE_POLL_RXQ_TMOUT:
-		test_spec_set_name(test, "POLL_RXQ_EMPTY");
-		test->ifobj_rx->use_poll = true;
-		testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
+		testapp_poll_rxq_tmout(test);
 		break;
 	case TEST_TYPE_ALIGNED_INV_DESC:
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
-- 
2.34.1

