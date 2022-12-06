Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED16643F75
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiLFJKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiLFJJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:32 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A21E712;
        Tue,  6 Dec 2022 01:09:30 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so8337938wmb.5;
        Tue, 06 Dec 2022 01:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6FmAkgE7v72RLOGGEFBqBj64r3HZ/zaMjlJDWPg7aoI=;
        b=UR+o4s3/m2ZHRi8NhhgKBD5qZKj8bysiGOaIOnLeSfaEYJDGk3aZtglJs3ChLooGTu
         mjjLZKgFvbfzQCVfRyNSNjoKBBXDy2G9QyD939Ipt0WwORVQKJZNaEmwGmn9zhaGCR/5
         SdVUWuf5z2BPsC0NpIPivKmjmKQqQP6z+sRT7ML1H4yvfkTSVoYDY9Xr4HRwocV9Y6sn
         DUqZo8RjNTkr0KytrlANRW6FUFSfN9ojg/kT2cncAFVTqRZRomjy9HDqIFp6nLBUxPRc
         KOfHoMgXxnKhuwbiEhRpWy09mbPWgMvmAiReCaSOdKLooqdTaZIShM7cC8+TW04hk+nx
         9v5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6FmAkgE7v72RLOGGEFBqBj64r3HZ/zaMjlJDWPg7aoI=;
        b=ADuhZlxnRkmTBZvQbMYs9EbgPnfJqLdfsk/8/jtDEIE3VgJ3THjWKAKq0/kMpzITGU
         6OQgHFVexgRXXfRaw+KZx1j2ACivgUvDkZxi25ZCpMnHT+8xRG4KIH89ASM57WwPwuDh
         RUWQaJsBFpVFdk++LzQ115mhAqCPPz+P2i6m6LK1QP5cKgcVzptlLk53QRHnK3w0aG29
         V3mssVu4Wqu0fhjobtL2ghy1COThGDl65Or5j1HiA+ITpDbl6QigjUCFjsS9vk3FntuG
         9wslDKHA35M3d7HsN14pBI6nX1B99RABe3wNr0KmMrnfP40M5Fav8oR1M0pzI1tJt2wo
         j0gQ==
X-Gm-Message-State: ANoB5pm1fjomufKfFuGi+U26D5hwVUpdVl1O7zIGXkgnC8BRZgxkp6RM
        4UaLoJwtyTNncNqVUX5kenQ=
X-Google-Smtp-Source: AA0mqf6WvM2/z25/J5/7aG14sEnb3VtswdTzaxNRHMtfJpVGWhMQ8a2L1DCrKvLGXHGUUH1M8KnYLQ==
X-Received: by 2002:a1c:6a02:0:b0:3cf:71e4:75b with SMTP id f2-20020a1c6a02000000b003cf71e4075bmr52130722wmc.114.1670317769798;
        Tue, 06 Dec 2022 01:09:29 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:29 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 14/15] selftests/xsk: automatically restore packet stream
Date:   Tue,  6 Dec 2022 10:08:25 +0100
Message-Id: <20221206090826.2957-15-magnus.karlsson@gmail.com>
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

Automatically restore the default packet stream if needed at the end
of each test. This so that test writers do not forget to do this.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 0457874c0995..26cd64d4209f 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1509,8 +1509,6 @@ static void testapp_stats_tx_invalid_descs(struct test_spec *test)
 	pkt_stream_replace_half(test, XSK_UMEM__INVALID_FRAME_SIZE, 0);
 	test->ifobj_tx->validation_func = validate_tx_invalid_descs;
 	testapp_validate_traffic(test);
-
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_stats_rx_full(struct test_spec *test)
@@ -1526,8 +1524,6 @@ static void testapp_stats_rx_full(struct test_spec *test)
 	test->ifobj_rx->release_rx = false;
 	test->ifobj_rx->validation_func = validate_rx_full;
 	testapp_validate_traffic(test);
-
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_stats_fill_empty(struct test_spec *test)
@@ -1542,8 +1538,6 @@ static void testapp_stats_fill_empty(struct test_spec *test)
 	test->ifobj_rx->use_fill_ring = false;
 	test->ifobj_rx->validation_func = validate_fill_empty;
 	testapp_validate_traffic(test);
-
-	pkt_stream_restore_default(test);
 }
 
 /* Simple test */
@@ -1576,7 +1570,6 @@ static bool testapp_unaligned(struct test_spec *test)
 	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
 	testapp_validate_traffic(test);
 
-	pkt_stream_restore_default(test);
 	return true;
 }
 
@@ -1586,7 +1579,6 @@ static void testapp_single_pkt(struct test_spec *test)
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_invalid_desc(struct test_spec *test)
@@ -1627,7 +1619,6 @@ static void testapp_invalid_desc(struct test_spec *test)
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_xdp_drop(struct test_spec *test)
@@ -1649,7 +1640,6 @@ static void testapp_xdp_drop(struct test_spec *test)
 	pkt_stream_receive_half(test);
 	testapp_validate_traffic(test);
 
-	pkt_stream_restore_default(test);
 	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
 	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
 				     ifobj->xdp_flags);
@@ -1669,8 +1659,6 @@ static void testapp_poll_txq_tmout(struct test_spec *test)
 	test->ifobj_tx->umem->frame_size = 2048;
 	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
 	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
-
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_poll_rxq_tmout(struct test_spec *test)
@@ -1781,8 +1769,6 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test->ifobj_rx->umem->frame_size = 2048;
 		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
 		testapp_validate_traffic(test);
-
-		pkt_stream_restore_default(test);
 		break;
 	case TEST_TYPE_RX_POLL:
 		test->ifobj_rx->use_poll = true;
@@ -1837,6 +1823,7 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 	if (!test->fail)
 		ksft_test_result_pass("PASS: %s %s%s\n", mode_string(test), busy_poll_string(test),
 				      test->name);
+	pkt_stream_restore_default(test);
 }
 
 static struct ifobject *ifobject_create(void)
-- 
2.34.1

