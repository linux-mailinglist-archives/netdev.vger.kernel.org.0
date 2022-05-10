Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5EB521476
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbiEJMBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241381AbiEJMBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:01:07 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F267124EA09;
        Tue, 10 May 2022 04:57:02 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u3so23476055wrg.3;
        Tue, 10 May 2022 04:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hwswGezRygKMF5aesl0YIOClootFiCitW6j/Wf2pgKA=;
        b=KaHYpBSM2kWmvgTNhw9SOvb00ooQreAXZ21mgG9gBCRNIe0IOobjm33kTgh6aWO6qf
         kZXkrG8XdKlaB/wk4fsLd4CSl86SR/V9bvwRTkLibaXTQKXCuUnWh+5/UjVp+fgW63Tm
         3dNtDFzgwkKoijwABZ/SbngXNpgmIaVmQUOPn/Hg38tSup04jcUetrp20VhZZh0Qp0r+
         wMq0u4UBiwBE5dkf0sY3CjACy84gK3/txAddENE2w0uAapkYMEtxX+W6kHT+E58J1pfh
         M6stFhjAwQJtchZURz1APJAzUHUEQw7XzS90XYk6uCGa7RcgwH8JoltsuGr4NJKjxGsa
         85vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwswGezRygKMF5aesl0YIOClootFiCitW6j/Wf2pgKA=;
        b=rn2W6BLtr1wBd83m239Xybrc55hQHaXFRp6hwZ+I4iHTcgKvK0EQl8RMhXbgblel8s
         Vnpa8lUGNUNRxn3Njs5R2k2HWs3qaS1bQiCpZD1gM6qJMUfRlNN5AdetxCc7qo9CnaA6
         rCBTMeeXBNRQazgxWM0c6r8z7dudeew42ARsPyLaMd3QbyHhzkNT4I/1Gv9ui90m98Ej
         iId+l7vlfGxMTgxHdBi3CxxUZSillbPFy2VBb2IV577o6vvoWDfqkpJJzfqQpQxSXXw/
         Eg5Usl77t8LM0rGHriCM4jvVo4//Beq/yhd3zYscAiEjRaDZqAF8f6cRZuI354Pr2BDo
         9QTg==
X-Gm-Message-State: AOAM531PSaRvmyctuu2491EUhPZeLKEfq4QFL3wQdLFHQDjfpft1u0F+
        Bcabe3DK25IQ/VaxyCP8smI=
X-Google-Smtp-Source: ABdhPJwBFXWOtWCjLEDFaK+NrSWlsdvlHcqqo9nTS5ePHSyVxGRLvXPwhtEjkRhD59BXur4FwL4RuQ==
X-Received: by 2002:a05:6000:1acd:b0:20c:811c:9f39 with SMTP id i13-20020a0560001acd00b0020c811c9f39mr17777994wry.482.1652183821015;
        Tue, 10 May 2022 04:57:01 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:57:00 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 8/9] selftests: xsk: make the stats tests normal tests
Date:   Tue, 10 May 2022 13:56:03 +0200
Message-Id: <20220510115604.8717-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make the stats tests look and feel just like normal tests instead of
bunched under the umbrella of TEST_STATS. This means we will always
run each of them even if one fails. Also gets rid of some special case
code.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 106 +++++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h |  16 +---
 2 files changed, 53 insertions(+), 69 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 3eef29cacf94..a75af0ea19a3 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1324,60 +1324,48 @@ static void testapp_headroom(struct test_spec *test)
 	testapp_validate_traffic(test);
 }
 
-static void testapp_stats(struct test_spec *test)
+static void testapp_stats_rx_dropped(struct test_spec *test)
 {
-	int i;
+	test_spec_set_name(test, "STAT_RX_DROPPED");
+	test->ifobj_tx->pacing_on = false;
+	test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
+		XDP_PACKET_HEADROOM - 1;
+	test->ifobj_rx->validation_func = validate_rx_dropped;
+	testapp_validate_traffic(test);
+}
 
-	for (i = 0; i < STAT_TEST_TYPE_MAX; i++) {
-		test_spec_reset(test);
-		stat_test_type = i;
-		/* No or few packets will be received so cannot pace packets */
-		test->ifobj_tx->pacing_on = false;
-
-		switch (stat_test_type) {
-		case STAT_TEST_RX_DROPPED:
-			test_spec_set_name(test, "STAT_RX_DROPPED");
-			test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
-				XDP_PACKET_HEADROOM - 1;
-			test->ifobj_rx->validation_func = validate_rx_dropped;
-			testapp_validate_traffic(test);
-			break;
-		case STAT_TEST_RX_FULL:
-			test_spec_set_name(test, "STAT_RX_FULL");
-			test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
-			test->ifobj_rx->validation_func = validate_rx_full;
-			testapp_validate_traffic(test);
-			break;
-		case STAT_TEST_TX_INVALID:
-			test_spec_set_name(test, "STAT_TX_INVALID");
-			pkt_stream_replace(test, DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
-			test->ifobj_tx->validation_func = validate_tx_invalid_descs;
-			testapp_validate_traffic(test);
+static void testapp_stats_tx_invalid_descs(struct test_spec *test)
+{
+	test_spec_set_name(test, "STAT_TX_INVALID");
+	test->ifobj_tx->pacing_on = false;
+	pkt_stream_replace(test, DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
+	test->ifobj_tx->validation_func = validate_tx_invalid_descs;
+	testapp_validate_traffic(test);
 
-			pkt_stream_restore_default(test);
-			break;
-		case STAT_TEST_RX_FILL_EMPTY:
-			test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
-			test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem, 0,
-									 MIN_PKT_SIZE);
-			if (!test->ifobj_rx->pkt_stream)
-				exit_with_error(ENOMEM);
-			test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
-			test->ifobj_rx->validation_func = validate_fill_empty;
-			testapp_validate_traffic(test);
-
-			pkt_stream_restore_default(test);
-			break;
-		default:
-			break;
-		}
+	pkt_stream_restore_default(test);
+}
 
-		if (test->fail)
-			break;
-	}
+static void testapp_stats_rx_full(struct test_spec *test)
+{
+	test_spec_set_name(test, "STAT_RX_FULL");
+	test->ifobj_tx->pacing_on = false;
+	test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
+	test->ifobj_rx->validation_func = validate_rx_full;
+	testapp_validate_traffic(test);
+}
 
-	/* To only see the whole stat set being completed unless an individual test fails. */
-	test_spec_set_name(test, "STATS");
+static void testapp_stats_fill_empty(struct test_spec *test)
+{
+	test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
+	test->ifobj_tx->pacing_on = false;
+	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem, 0, MIN_PKT_SIZE);
+	if (!test->ifobj_rx->pkt_stream)
+		exit_with_error(ENOMEM);
+	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
+	test->ifobj_rx->validation_func = validate_fill_empty;
+	testapp_validate_traffic(test);
+
+	pkt_stream_restore_default(test);
 }
 
 /* Simple test */
@@ -1482,14 +1470,18 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 
 static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
 {
-	test_type = type;
-
-	/* reset defaults after potential previous test */
-	stat_test_type = -1;
-
-	switch (test_type) {
-	case TEST_TYPE_STATS:
-		testapp_stats(test);
+	switch (type) {
+	case TEST_TYPE_STATS_RX_DROPPED:
+		testapp_stats_rx_dropped(test);
+		break;
+	case TEST_TYPE_STATS_TX_INVALID_DESCS:
+		testapp_stats_tx_invalid_descs(test);
+		break;
+	case TEST_TYPE_STATS_RX_FULL:
+		testapp_stats_rx_full(test);
+		break;
+	case TEST_TYPE_STATS_FILL_EMPTY:
+		testapp_stats_fill_empty(test);
 		break;
 	case TEST_TYPE_TEARDOWN:
 		testapp_teardown(test);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index f271c7b35a2c..bf18a95be48c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -77,24 +77,16 @@ enum test_type {
 	TEST_TYPE_HEADROOM,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
-	TEST_TYPE_STATS,
+	TEST_TYPE_STATS_RX_DROPPED,
+	TEST_TYPE_STATS_TX_INVALID_DESCS,
+	TEST_TYPE_STATS_RX_FULL,
+	TEST_TYPE_STATS_FILL_EMPTY,
 	TEST_TYPE_BPF_RES,
 	TEST_TYPE_MAX
 };
 
-enum stat_test_type {
-	STAT_TEST_RX_DROPPED,
-	STAT_TEST_TX_INVALID,
-	STAT_TEST_RX_FULL,
-	STAT_TEST_RX_FILL_EMPTY,
-	STAT_TEST_TYPE_MAX
-};
-
 static bool opt_pkt_dump;
-static int test_type;
-
 static bool opt_verbose;
-static int stat_test_type;
 
 struct xsk_umem_info {
 	struct xsk_ring_prod fq;
-- 
2.34.1

