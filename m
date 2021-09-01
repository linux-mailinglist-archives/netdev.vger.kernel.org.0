Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860143FD80C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbhIAKtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbhIAKtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D21C0617AE;
        Wed,  1 Sep 2021 03:48:10 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g138so1526420wmg.4;
        Wed, 01 Sep 2021 03:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ixB0LYGzpliqsf1socDA0N46Acr6XB3D+s9pcpc6tY=;
        b=ejEZvm29I27jmqXIm9Roh6ukIF+9mF/t+FBt61jwq80F/1vYRpiepIc/ca6EVgDcDc
         g0ECNHJfsxeLTZESSxiHZmIrg9FHWEyWe0MEAU0yOmOmOveYVOw+QwEkg0m7xZXWqBc8
         QYTUsAUhRGylR0ejmb5Gu8P30r7ytc1xVjN1qNgaObZIu+uHL9M0j9LwnZGhx8JOMvyJ
         rxPJEqmbOIOrHUngygKsRbaUCzWSfMXFq87TL1zKGgJU7YT3YnUzUlnFcj87N9qT2NDr
         UznbqkloEGi4t86LbxCQwsgwFXbr99Q5a+GfxVFimippRNYUDgHx/Ynl2weKOc87iKYN
         PluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ixB0LYGzpliqsf1socDA0N46Acr6XB3D+s9pcpc6tY=;
        b=cx1I2n0Whu+2D/6uxsJYrolTmCFIqTyBIpGQxHr8Znxep6lvb3oQwropJtY47nnz5T
         ELOSqX0EmbJ4SCUSqYjtRhj3L1Dce1Mzk/DtzLv7OtMWyQRDjcPCKuJBLhuFdG/f+dkw
         SfaNS4WZor51/eTSC9bdG/SPY7PQt4rFhy+O/w/ooq6vmUDFD0A6Ki0qhga2kdKNDQ+e
         wRQEgGFVQa54IOsLRPb0Eg3EGFpyMFOBPMSn3cmP7sJ1r2VKmfQJSN61MCsPsNgmhxm9
         ib5RwtPrdT2Xt+TclAKv0m0yW4MBpQLwFEy9hMjGDq0mLGbdQt27YbQYsJOBbeRi9vxJ
         7yIQ==
X-Gm-Message-State: AOAM533/cRE5iuSw39yx81sEnU8+AmLfhP79+YFHK7RNVN4lTf5U0CbP
        /gAWzLUpL+p5fMVQ5ZjW4So=
X-Google-Smtp-Source: ABdhPJyEGQZmh4q+RejPQDBGcBPGxKT2T8irlEVAfEJOnySEOma3MaMVE4pSZ57BxYW2xj4aaQZR6A==
X-Received: by 2002:a05:600c:2256:: with SMTP id a22mr9126822wmm.16.1630493289320;
        Wed, 01 Sep 2021 03:48:09 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:08 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 07/20] selftests: xsx: introduce test name in test spec
Date:   Wed,  1 Sep 2021 12:47:19 +0200
Message-Id: <20210901104732.10956-8-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce the test name in the test specification. This so we can set
the name locally in the test function and simplify the logic for
printing out test results.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 49 ++++++++++++++----------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 79cf082a7581..8ef58081d4d2 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -112,13 +112,9 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
-#define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s%s%s%s\n", configured_mode ? "DRV" : "SKB",\
-			       test_type == TEST_TYPE_POLL ? "POLL" : "NOPOLL",\
-			       test_type == TEST_TYPE_TEARDOWN ? "Socket Teardown" : "",\
-			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : "",\
-			       test_type == TEST_TYPE_STATS ? "Stats" : "",\
-			       test_type == TEST_TYPE_BPF_RES ? "BPF RES" : ""))
+#define print_ksft_result(test)\
+	(ksft_test_result_pass("PASS: %s %s\n", configured_mode ? "DRV" : "SKB", \
+			       (test)->name))
 
 static void memset32_htonl(void *dest, u32 val, u32 size)
 {
@@ -428,6 +424,11 @@ static void test_spec_reset(struct test_spec *test)
 	__test_spec_init(test, test->ifobj_tx, test->ifobj_rx);
 }
 
+static void test_spec_set_name(struct test_spec *test, const char *name)
+{
+	strncpy(test->name, name, MAX_TEST_NAME_SIZE);
+}
+
 static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
 {
 	if (pkt_nb >= pkt_stream->nb_pkts)
@@ -880,8 +881,6 @@ static void testapp_validate_traffic(struct test_spec *test)
 {
 	struct ifobject *ifobj_tx = test->ifobj_tx;
 	struct ifobject *ifobj_rx = test->ifobj_rx;
-	bool bidi = test_type == TEST_TYPE_BIDI;
-	bool bpf = test_type == TEST_TYPE_BPF_RES;
 	struct pkt_stream *pkt_stream;
 
 	if (pthread_barrier_init(&barr, NULL, 2))
@@ -907,21 +906,17 @@ static void testapp_validate_traffic(struct test_spec *test)
 
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
-
-	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi && !bpf && !(test_type == TEST_TYPE_STATS))
-		print_ksft_result();
 }
 
 static void testapp_teardown(struct test_spec *test)
 {
 	int i;
 
+	test_spec_set_name(test, "TEARDOWN");
 	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
 		testapp_validate_traffic(test);
 		test_spec_reset(test);
 	}
-
-	print_ksft_result();
 }
 
 static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
@@ -942,6 +937,7 @@ static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
 
 static void testapp_bidi(struct test_spec *test)
 {
+	test_spec_set_name(test, "BIDIRECTIONAL");
 	for (int i = 0; i < MAX_BIDI_ITER; i++) {
 		print_verbose("Creating socket\n");
 		testapp_validate_traffic(test);
@@ -953,8 +949,6 @@ static void testapp_bidi(struct test_spec *test)
 	}
 
 	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
-
-	print_ksft_result();
 }
 
 static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
@@ -973,6 +967,7 @@ static void testapp_bpf_res(struct test_spec *test)
 {
 	int i;
 
+	test_spec_set_name(test, "BPF_RES");
 	for (i = 0; i < MAX_BPF_ITER; i++) {
 		print_verbose("Creating socket\n");
 		testapp_validate_traffic(test);
@@ -980,8 +975,6 @@ static void testapp_bpf_res(struct test_spec *test)
 			swap_xsk_resources(test->ifobj_tx, test->ifobj_rx);
 		second_step = true;
 	}
-
-	print_ksft_result();
 }
 
 static void testapp_stats(struct test_spec *test)
@@ -992,21 +985,28 @@ static void testapp_stats(struct test_spec *test)
 
 		switch (stat_test_type) {
 		case STAT_TEST_RX_DROPPED:
+			test_spec_set_name(test, "STAT_RX_DROPPED");
 			test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
 				XDP_PACKET_HEADROOM - 1;
 			break;
 		case STAT_TEST_RX_FULL:
+			test_spec_set_name(test, "STAT_RX_FULL");
 			test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
 			break;
 		case STAT_TEST_TX_INVALID:
+			test_spec_set_name(test, "STAT_TX_INVALID");
 			continue;
+		case STAT_TEST_RX_FILL_EMPTY:
+			test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
+			break;
 		default:
 			break;
 		}
 		testapp_validate_traffic(test);
 	}
 
-	print_ksft_result();
+	/* To only see the whole stat set being completed unless an individual test fails. */
+	test_spec_set_name(test, "STATS");
 }
 
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
@@ -1066,10 +1066,19 @@ static void run_pkt_test(struct test_spec *test, int mode, int type)
 	case TEST_TYPE_BPF_RES:
 		testapp_bpf_res(test);
 		break;
-	default:
+	case TEST_TYPE_NOPOLL:
+		test_spec_set_name(test, "RUN_TO_COMPLETION");
+		testapp_validate_traffic(test);
+		break;
+	case TEST_TYPE_POLL:
+		test_spec_set_name(test, "POLL");
 		testapp_validate_traffic(test);
 		break;
+	default:
+		break;
 	}
+
+	print_ksft_result(test);
 }
 
 static struct ifobject *ifobject_create(void)
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index bfd14190abfc..15eab31b3b32 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -22,6 +22,7 @@
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
 #define MAX_SOCKETS 2
+#define MAX_TEST_NAME_SIZE 32
 #define MAX_TEARDOWN_ITER 10
 #define MAX_BIDI_ITER 2
 #define MAX_BPF_ITER 2
@@ -141,6 +142,7 @@ struct ifobject {
 struct test_spec {
 	struct ifobject *ifobj_tx;
 	struct ifobject *ifobj_rx;
+	char name[MAX_TEST_NAME_SIZE];
 };
 
 /*threads*/
-- 
2.29.0

