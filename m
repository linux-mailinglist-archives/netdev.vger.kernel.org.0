Return-Path: <netdev+bounces-2952-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C579704ACC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DB9F1C20E32
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC34209BB;
	Tue, 16 May 2023 10:31:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9620F2771A;
	Tue, 16 May 2023 10:31:58 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8104F59D2;
	Tue, 16 May 2023 03:31:32 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f3284dff6cso23047205e9.0;
        Tue, 16 May 2023 03:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233091; x=1686825091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPytWqoAXfqh7Jo+rKpBUBKV76nhOnMH3W8MOn18m5Y=;
        b=eNfV1+gAy6cm/Vxw5oQlKWhvKnkylcqMcyw//aXGhRYeJuhoDmqlBLf+IcLxCsAHIs
         CrceovHPG0+1ZDuYkDRjr/4VT2/WRylq17akDdBsw8bRmKWBI+GaBeziDkwG1fs3gjMg
         GL5GhxkIRhZKfcKPQttmiUjgAc3cOvXjwJDs+5VoJYOndPHn8RZ/CjNXR3qP4q1hrl6E
         r3vLkFKDMzb5ONhmAZuxOl4vEZS7R5ZJVGktw3NOeGGOBGr5Mzheu9yTA1kwpc4bqtF3
         53QyLTvTnnOMRjv3V7IUKS3ou2odGIXD7hOusqeYR6ShIU0c7Ztdi6GFJhqu6YlMezAr
         L8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233091; x=1686825091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPytWqoAXfqh7Jo+rKpBUBKV76nhOnMH3W8MOn18m5Y=;
        b=f3vEqYmWvZ5AS7PmTwPJmFFPEVLulTqtcqkMXiJ3VMGygzT3CNHMbb1JgTg+yX7jW1
         N1x5b9cVNdMvumq3ubSrKIjaYoU91WE/SMjO0jkIAF2fXtxZRzCJobsMJaCw+JYbjWkD
         XBaeI+gs12VymN3dYW1tTQ/oUKf8krreU+09DajZQKsYbZXUZfDQ/GigmG71wA1am0z+
         MhhGwdzr+ZhXqNzqbh16bYn1+izfZloAEVgfgWqphH4NcBV5z2i7rhv5td6DsAbjX4ut
         gPQJ9Gk3D6oM1dzciCa3jBQoRy6fn0YW7pFgVH+LbLBObSOUFZnryFVBUbMt/24/jtmn
         UDFA==
X-Gm-Message-State: AC+VfDzGwRpCZLd7kFKikCsFhnIe22z5H5lT9LVV2heFH+2kx9UC+xVm
	Y9RJoekm4osHmlOiPCDh7b6DT4CCOtjrqGJkoTY=
X-Google-Smtp-Source: ACHHUZ4fouJEGkGqaAXE1xAbWeXk48XfCoxKhrTQj10P1DEUhhnrQQqt2qjJVSflP0CxCycfDh03Cg==
X-Received: by 2002:a05:600c:4f15:b0:3f1:7490:e595 with SMTP id l21-20020a05600c4f1500b003f17490e595mr8181600wmq.2.1684233090658;
        Tue, 16 May 2023 03:31:30 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:30 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 07/10] selftests/xsx: test for huge pages only once
Date: Tue, 16 May 2023 12:31:06 +0200
Message-Id: <20230516103109.3066-8-magnus.karlsson@gmail.com>
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

Test for hugepages only once at the beginning of the execution of the
whole test suite, instead of before each test that needs huge
pages. These are the tests that use unaligned mode. As more unaligned
tests will be added, so the current system just does not scale.

With this change, there are now three possible outcomes of a test run:
fail, pass, or skip. To simplify the handling of this, the function
testapp_validate_traffic() now returns this value to the main loop. As
this function is used by nearly all tests, it meant a small change to
most of them.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 186 +++++++++++------------
 tools/testing/selftests/bpf/xskxceiver.h |   2 +
 2 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index d488d859d3a2..f0d929cb730a 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1413,6 +1413,12 @@ static int testapp_validate_traffic(struct test_spec *test)
 	struct ifobject *ifobj_rx = test->ifobj_rx;
 	struct ifobject *ifobj_tx = test->ifobj_tx;
 
+	if ((ifobj_rx->umem->unaligned_mode && !ifobj_rx->unaligned_supp) ||
+	    (ifobj_tx->umem->unaligned_mode && !ifobj_tx->unaligned_supp)) {
+		ksft_test_result_skip("No huge pages present.\n");
+		return TEST_SKIP;
+	}
+
 	xsk_attach_xdp_progs(test, ifobj_rx, ifobj_tx);
 	return __testapp_validate_traffic(test, ifobj_rx, ifobj_tx);
 }
@@ -1422,16 +1428,18 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 	return __testapp_validate_traffic(test, ifobj, NULL);
 }
 
-static void testapp_teardown(struct test_spec *test)
+static int testapp_teardown(struct test_spec *test)
 {
 	int i;
 
 	test_spec_set_name(test, "TEARDOWN");
 	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
 		if (testapp_validate_traffic(test))
-			return;
+			return TEST_FAILURE;
 		test_spec_reset(test);
 	}
+
+	return TEST_PASS;
 }
 
 static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
@@ -1446,20 +1454,23 @@ static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
 	*ifobj2 = tmp_ifobj;
 }
 
-static void testapp_bidi(struct test_spec *test)
+static int testapp_bidi(struct test_spec *test)
 {
+	int res;
+
 	test_spec_set_name(test, "BIDIRECTIONAL");
 	test->ifobj_tx->rx_on = true;
 	test->ifobj_rx->tx_on = true;
 	test->total_steps = 2;
 	if (testapp_validate_traffic(test))
-		return;
+		return TEST_FAILURE;
 
 	print_verbose("Switching Tx/Rx vectors\n");
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
-	__testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
+	res = __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
 
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
+	return res;
 }
 
 static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
@@ -1476,115 +1487,94 @@ static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj
 		exit_with_error(errno);
 }
 
-static void testapp_bpf_res(struct test_spec *test)
+static int testapp_bpf_res(struct test_spec *test)
 {
 	test_spec_set_name(test, "BPF_RES");
 	test->total_steps = 2;
 	test->nb_sockets = 2;
 	if (testapp_validate_traffic(test))
-		return;
+		return TEST_FAILURE;
 
 	swap_xsk_resources(test->ifobj_tx, test->ifobj_rx);
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_headroom(struct test_spec *test)
+static int testapp_headroom(struct test_spec *test)
 {
 	test_spec_set_name(test, "UMEM_HEADROOM");
 	test->ifobj_rx->umem->frame_headroom = UMEM_HEADROOM_TEST_SIZE;
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_stats_rx_dropped(struct test_spec *test)
+static int testapp_stats_rx_dropped(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_DROPPED");
+	if (test->mode == TEST_MODE_ZC) {
+		ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
+		return TEST_SKIP;
+	}
+
 	pkt_stream_replace_half(test, MIN_PKT_SIZE * 4, 0);
 	test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
 		XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 3;
 	pkt_stream_receive_half(test);
 	test->ifobj_rx->validation_func = validate_rx_dropped;
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_stats_tx_invalid_descs(struct test_spec *test)
+static int testapp_stats_tx_invalid_descs(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_TX_INVALID");
 	pkt_stream_replace_half(test, XSK_UMEM__INVALID_FRAME_SIZE, 0);
 	test->ifobj_tx->validation_func = validate_tx_invalid_descs;
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_stats_rx_full(struct test_spec *test)
+static int testapp_stats_rx_full(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_FULL");
 	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
 	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
 							 DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
-	if (!test->ifobj_rx->pkt_stream)
-		exit_with_error(ENOMEM);
 
 	test->ifobj_rx->xsk->rxqsize = DEFAULT_UMEM_BUFFERS;
 	test->ifobj_rx->release_rx = false;
 	test->ifobj_rx->validation_func = validate_rx_full;
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_stats_fill_empty(struct test_spec *test)
+static int testapp_stats_fill_empty(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
 	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
 	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
 							 DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
-	if (!test->ifobj_rx->pkt_stream)
-		exit_with_error(ENOMEM);
 
 	test->ifobj_rx->use_fill_ring = false;
 	test->ifobj_rx->validation_func = validate_fill_empty;
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-/* Simple test */
-static bool hugepages_present(struct ifobject *ifobject)
+static int testapp_unaligned(struct test_spec *test)
 {
-	size_t mmap_sz = 2 * ifobject->umem->num_frames * ifobject->umem->frame_size;
-	void *bufs;
-
-	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB, -1, 0);
-	if (bufs == MAP_FAILED)
-		return false;
-
-	mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
-	munmap(bufs, mmap_sz);
-	return true;
-}
-
-static bool testapp_unaligned(struct test_spec *test)
-{
-	if (!hugepages_present(test->ifobj_tx)) {
-		ksft_test_result_skip("No 2M huge pages present.\n");
-		return false;
-	}
-
 	test_spec_set_name(test, "UNALIGNED_MODE");
 	test->ifobj_tx->umem->unaligned_mode = true;
 	test->ifobj_rx->umem->unaligned_mode = true;
 	/* Let half of the packets straddle a 4K buffer boundary */
 	pkt_stream_replace_half(test, MIN_PKT_SIZE, -MIN_PKT_SIZE / 2);
-	testapp_validate_traffic(test);
 
-	return true;
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_single_pkt(struct test_spec *test)
+static int testapp_single_pkt(struct test_spec *test)
 {
 	struct pkt pkts[] = {{0, MIN_PKT_SIZE, 0, true}};
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_invalid_desc(struct test_spec *test)
+static int testapp_invalid_desc(struct test_spec *test)
 {
 	struct xsk_umem_info *umem = test->ifobj_tx->umem;
 	u64 umem_size = umem->num_frames * umem->frame_size;
@@ -1626,10 +1616,10 @@ static void testapp_invalid_desc(struct test_spec *test)
 	}
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_xdp_drop(struct test_spec *test)
+static int testapp_xdp_drop(struct test_spec *test)
 {
 	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
 	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
@@ -1639,10 +1629,10 @@ static void testapp_xdp_drop(struct test_spec *test)
 			       skel_rx->maps.xsk, skel_tx->maps.xsk);
 
 	pkt_stream_receive_half(test);
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_xdp_metadata_count(struct test_spec *test)
+static int testapp_xdp_metadata_count(struct test_spec *test)
 {
 	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
 	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
@@ -1663,10 +1653,10 @@ static void testapp_xdp_metadata_count(struct test_spec *test)
 	if (bpf_map_update_elem(bpf_map__fd(data_map), &key, &count, BPF_ANY))
 		exit_with_error(errno);
 
-	testapp_validate_traffic(test);
+	return testapp_validate_traffic(test);
 }
 
-static void testapp_poll_txq_tmout(struct test_spec *test)
+static int testapp_poll_txq_tmout(struct test_spec *test)
 {
 	test_spec_set_name(test, "POLL_TXQ_FULL");
 
@@ -1674,14 +1664,14 @@ static void testapp_poll_txq_tmout(struct test_spec *test)
 	/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
 	test->ifobj_tx->umem->frame_size = 2048;
 	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
-	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
+	return testapp_validate_traffic_single_thread(test, test->ifobj_tx);
 }
 
-static void testapp_poll_rxq_tmout(struct test_spec *test)
+static int testapp_poll_rxq_tmout(struct test_spec *test)
 {
 	test_spec_set_name(test, "POLL_RXQ_EMPTY");
 	test->ifobj_rx->use_poll = true;
-	testapp_validate_traffic_single_thread(test, test->ifobj_rx);
+	return testapp_validate_traffic_single_thread(test, test->ifobj_rx);
 }
 
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
@@ -1698,6 +1688,22 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
 	xsk_xdp_progs__destroy(ifobj->xdp_progs);
 }
 
+/* Simple test */
+static bool hugepages_present(void)
+{
+	size_t mmap_sz = 2 * DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	void *bufs;
+
+	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, MAP_HUGE_2MB);
+	if (bufs == MAP_FAILED)
+		return false;
+
+	mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
+	munmap(bufs, mmap_sz);
+	return true;
+}
+
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
 		       thread_func_t func_ptr)
 {
@@ -1713,94 +1719,87 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 		printf("Error loading XDP program\n");
 		exit_with_error(err);
 	}
+
+	if (hugepages_present())
+		ifobj->unaligned_supp = true;
 }
 
 static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
 {
+	int ret = TEST_SKIP;
+
 	switch (type) {
 	case TEST_TYPE_STATS_RX_DROPPED:
-		if (mode == TEST_MODE_ZC) {
-			ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
-			return;
-		}
-		testapp_stats_rx_dropped(test);
+		ret = testapp_stats_rx_dropped(test);
 		break;
 	case TEST_TYPE_STATS_TX_INVALID_DESCS:
-		testapp_stats_tx_invalid_descs(test);
+		ret = testapp_stats_tx_invalid_descs(test);
 		break;
 	case TEST_TYPE_STATS_RX_FULL:
-		testapp_stats_rx_full(test);
+		ret = testapp_stats_rx_full(test);
 		break;
 	case TEST_TYPE_STATS_FILL_EMPTY:
-		testapp_stats_fill_empty(test);
+		ret = testapp_stats_fill_empty(test);
 		break;
 	case TEST_TYPE_TEARDOWN:
-		testapp_teardown(test);
+		ret = testapp_teardown(test);
 		break;
 	case TEST_TYPE_BIDI:
-		testapp_bidi(test);
+		ret = testapp_bidi(test);
 		break;
 	case TEST_TYPE_BPF_RES:
-		testapp_bpf_res(test);
+		ret = testapp_bpf_res(test);
 		break;
 	case TEST_TYPE_RUN_TO_COMPLETION:
 		test_spec_set_name(test, "RUN_TO_COMPLETION");
-		testapp_validate_traffic(test);
+		ret = testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT:
 		test_spec_set_name(test, "RUN_TO_COMPLETION_SINGLE_PKT");
-		testapp_single_pkt(test);
+		ret = testapp_single_pkt(test);
 		break;
 	case TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME:
 		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
 		test->ifobj_tx->umem->frame_size = 2048;
 		test->ifobj_rx->umem->frame_size = 2048;
 		pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
-		testapp_validate_traffic(test);
+		ret = testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_RX_POLL:
 		test->ifobj_rx->use_poll = true;
 		test_spec_set_name(test, "POLL_RX");
-		testapp_validate_traffic(test);
+		ret = testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_TX_POLL:
 		test->ifobj_tx->use_poll = true;
 		test_spec_set_name(test, "POLL_TX");
-		testapp_validate_traffic(test);
+		ret = testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_POLL_TXQ_TMOUT:
-		testapp_poll_txq_tmout(test);
+		ret = testapp_poll_txq_tmout(test);
 		break;
 	case TEST_TYPE_POLL_RXQ_TMOUT:
-		testapp_poll_rxq_tmout(test);
+		ret = testapp_poll_rxq_tmout(test);
 		break;
 	case TEST_TYPE_ALIGNED_INV_DESC:
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
-		testapp_invalid_desc(test);
+		ret = testapp_invalid_desc(test);
 		break;
 	case TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME:
 		test_spec_set_name(test, "ALIGNED_INV_DESC_2K_FRAME_SIZE");
 		test->ifobj_tx->umem->frame_size = 2048;
 		test->ifobj_rx->umem->frame_size = 2048;
-		testapp_invalid_desc(test);
+		ret = testapp_invalid_desc(test);
 		break;
 	case TEST_TYPE_UNALIGNED_INV_DESC:
-		if (!hugepages_present(test->ifobj_tx)) {
-			ksft_test_result_skip("No 2M huge pages present.\n");
-			return;
-		}
 		test_spec_set_name(test, "UNALIGNED_INV_DESC");
 		test->ifobj_tx->umem->unaligned_mode = true;
 		test->ifobj_rx->umem->unaligned_mode = true;
-		testapp_invalid_desc(test);
+		ret = testapp_invalid_desc(test);
 		break;
 	case TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME: {
 		u64 page_size, umem_size;
 
-		if (!hugepages_present(test->ifobj_tx)) {
-			ksft_test_result_skip("No 2M huge pages present.\n");
-			return;
-		}
 		test_spec_set_name(test, "UNALIGNED_INV_DESC_4K1_FRAME_SIZE");
 		/* Odd frame size so the UMEM doesn't end near a page boundary. */
 		test->ifobj_tx->umem->frame_size = 4001;
@@ -1814,27 +1813,26 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
 		assert(umem_size % page_size > MIN_PKT_SIZE);
 		assert(umem_size % page_size < page_size - MIN_PKT_SIZE);
-		testapp_invalid_desc(test);
+		ret = testapp_invalid_desc(test);
 		break;
 	}
 	case TEST_TYPE_UNALIGNED:
-		if (!testapp_unaligned(test))
-			return;
+		ret = testapp_unaligned(test);
 		break;
 	case TEST_TYPE_HEADROOM:
-		testapp_headroom(test);
+		ret = testapp_headroom(test);
 		break;
 	case TEST_TYPE_XDP_DROP_HALF:
-		testapp_xdp_drop(test);
+		ret = testapp_xdp_drop(test);
 		break;
 	case TEST_TYPE_XDP_METADATA_COUNT:
-		testapp_xdp_metadata_count(test);
+		ret = testapp_xdp_metadata_count(test);
 		break;
 	default:
 		break;
 	}
 
-	if (!test->fail)
+	if (ret == TEST_PASS)
 		ksft_test_result_pass("PASS: %s %s%s\n", mode_string(test), busy_poll_string(test),
 				      test->name);
 	pkt_stream_restore_default(test);
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index be4664a38d74..00862732e751 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -30,6 +30,7 @@
 #define TEST_PASS 0
 #define TEST_FAILURE -1
 #define TEST_CONTINUE 1
+#define TEST_SKIP 2
 #define MAX_INTERFACES 2
 #define MAX_INTERFACE_NAME_CHARS 16
 #define MAX_SOCKETS 2
@@ -148,6 +149,7 @@ struct ifobject {
 	bool release_rx;
 	bool shared_umem;
 	bool use_metadata;
+	bool unaligned_supp;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
 };
-- 
2.34.1


