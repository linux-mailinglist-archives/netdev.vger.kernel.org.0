Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E786657C8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjAKJjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjAKJhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:40 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0521A197;
        Wed, 11 Jan 2023 01:36:26 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t5so10005691wrq.1;
        Wed, 11 Jan 2023 01:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9WQnXLxAMYcqcOkxF19WA5j5RhbP2sqRguVHkWeBRM=;
        b=n5QsgVjxdiKnTojiBJ2XEa3msbqIhe8Wsrm8GTKvI1UsjkRavOilVTuI4i+UcweF3V
         yA+UupBpITGfmvFHvOsTHjZC2I4TgHQiXGun3LkNW3G/y5ZveEbKs/bfWR+DZVxmw2AH
         JRSLkCD6T1XVhRsK0ffLDg+6/3+IHIXrjyG6dhs6YNOkirjDuTtjo/08pFcaVsJza+2T
         s1uPlfWFLr8enUSZJUHKQm3xnN61ASm/aTAVXecwM7fK+S94FSMPN/CchcdbT/AuGCIU
         zHZYR6/o8hukM2x3WW8OjGFM8cg4+rQDDeGUJdkO+nTPYCZeRqg+koKnktPFT3rt0HJ0
         KHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9WQnXLxAMYcqcOkxF19WA5j5RhbP2sqRguVHkWeBRM=;
        b=x2Sr1hCOOUwbhPryWG7kzpYPMG8WhxgbxzwlX4E2HqH6aN3ishUZfDVIC+rkSTaT8W
         X0d8Hz5b2nk/mv5CRP3uaok3Rfyp70OAb+AUodPesFPOGsOz9vHck/Edy7rFn1kQIpMF
         +41q9zyRYG6bmZ5Wkg4gJNmd15SUAJMDusWqPYb7Hf/KklPW59y9CBtS+/zGMRp+qMjp
         URFfrSfoINkkYrlVfFHRF1xk+B5M3SXPWryOMbYo2F/9r3FK3CjiD3P8CrzXIVfN1f84
         pDLaqaKFoHYlQuNcIJmuOrgzQqOHZRnnjm6zpmcKB5eoRGnRV/JfICAuopHg1Q4oPM8y
         AKVg==
X-Gm-Message-State: AFqh2kqk+61+WERY6CY/dsvdo7jLxyoZ4tvUb2vApRtROl1RytfVBLBD
        OfUjLmlUYqqgloJkNMfL3rQ=
X-Google-Smtp-Source: AMrXdXs5zN0Qw8wF0ZSGENV7ACKKaUT1d9NaPr4OKw7dFBuMFktBYoKK5wv2H9htgEba3pWitx9/7g==
X-Received: by 2002:a05:6000:12c2:b0:2bc:5e1:6ff1 with SMTP id l2-20020a05600012c200b002bc05e16ff1mr7055541wrx.10.1673429785208;
        Wed, 11 Jan 2023 01:36:25 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:24 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 14/15] selftests/xsk: automatically restore packet stream
Date:   Wed, 11 Jan 2023 10:35:25 +0100
Message-Id: <20230111093526.11682-15-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Automatically restore the default packet stream if needed at the end
of each test. This so that test writers do not forget to do this.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 11e4f29d40f7..66863504c76a 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1501,8 +1501,6 @@ static void testapp_stats_tx_invalid_descs(struct test_spec *test)
 	pkt_stream_replace_half(test, XSK_UMEM__INVALID_FRAME_SIZE, 0);
 	test->ifobj_tx->validation_func = validate_tx_invalid_descs;
 	testapp_validate_traffic(test);
-
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_stats_rx_full(struct test_spec *test)
@@ -1518,8 +1516,6 @@ static void testapp_stats_rx_full(struct test_spec *test)
 	test->ifobj_rx->release_rx = false;
 	test->ifobj_rx->validation_func = validate_rx_full;
 	testapp_validate_traffic(test);
-
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_stats_fill_empty(struct test_spec *test)
@@ -1534,8 +1530,6 @@ static void testapp_stats_fill_empty(struct test_spec *test)
 	test->ifobj_rx->use_fill_ring = false;
 	test->ifobj_rx->validation_func = validate_fill_empty;
 	testapp_validate_traffic(test);
-
-	pkt_stream_restore_default(test);
 }
 
 /* Simple test */
@@ -1568,7 +1562,6 @@ static bool testapp_unaligned(struct test_spec *test)
 	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
 	testapp_validate_traffic(test);
 
-	pkt_stream_restore_default(test);
 	return true;
 }
 
@@ -1578,7 +1571,6 @@ static void testapp_single_pkt(struct test_spec *test)
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_invalid_desc(struct test_spec *test)
@@ -1619,7 +1611,6 @@ static void testapp_invalid_desc(struct test_spec *test)
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_xdp_drop(struct test_spec *test)
@@ -1640,7 +1631,6 @@ static void testapp_xdp_drop(struct test_spec *test)
 	pkt_stream_receive_half(test);
 	testapp_validate_traffic(test);
 
-	pkt_stream_restore_default(test);
 	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
 	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
 				     ifobj->xdp_flags);
@@ -1659,8 +1649,6 @@ static void testapp_poll_txq_tmout(struct test_spec *test)
 	test->ifobj_tx->umem->frame_size = 2048;
 	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
 	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
-
-	pkt_stream_restore_default(test);
 }
 
 static void testapp_poll_rxq_tmout(struct test_spec *test)
@@ -1766,8 +1754,6 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test->ifobj_rx->umem->frame_size = 2048;
 		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
 		testapp_validate_traffic(test);
-
-		pkt_stream_restore_default(test);
 		break;
 	case TEST_TYPE_RX_POLL:
 		test->ifobj_rx->use_poll = true;
@@ -1822,6 +1808,7 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 	if (!test->fail)
 		ksft_test_result_pass("PASS: %s %s%s\n", mode_string(test), busy_poll_string(test),
 				      test->name);
+	pkt_stream_restore_default(test);
 }
 
 static struct ifobject *ifobject_create(void)
-- 
2.34.1

