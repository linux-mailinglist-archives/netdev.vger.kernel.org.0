Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2F365D256
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbjADMUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239309AbjADMT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:19:59 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E54E3B912;
        Wed,  4 Jan 2023 04:19:05 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso16067715wmq.1;
        Wed, 04 Jan 2023 04:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbraEWwn9OFqZn5rYwpgh68BRpWoa8Oii81k+Oyg6QE=;
        b=E4WpZ12ZfYjJsTGGQzdeTOsx0EwZEJUbST4NHHifPg8u15/S8NHYSnCzGHbyf/F5q5
         CvZvJU8prTdHnhS58NiJLbj4+3u6TIrn3PJUS4EVTuX6IctlEIEnitizbyPFcGP/h+ow
         M0RdfchA2LfdgSCL0pAkr1vIkNes4qYgtj7gii8r+N8bAQjEiQRIIt+z/qd3AIAbPyav
         sHFibdFSOxyVck1RyRJz0MWmgl3ok84eDg7MuV8cGg+VJSfud1mqRbeTRF0Fj/uDu4X4
         N0vu/jSjHacK5ohHWKlT6R60HsVsqeDz5ZgFtmcxknITonl1+z3LZL6b6C9V9H6cEY+f
         3DIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YbraEWwn9OFqZn5rYwpgh68BRpWoa8Oii81k+Oyg6QE=;
        b=njG56BeD8LLXvP6ExFnfm3K6rQxy3RdVZgC17ftXW7a37rwEm/V/s1IaG9/zFnWLun
         +eoq1JgMJzveDjy56cLQ6ktaj/CeCzUd84023fDqRdb/iNZ8tMchFq3XJsIX6RQE6lOz
         n0xgH4xjQ2BHhh/MIg3qrW5wjSlcxis2qEDel5IilZMKZCuoP4Tsws2S53UOKlhmgPtl
         n/ZcVRP8Wy6MWnG9FY3z1KRkuCLHIO+6dqSHcnuSa6ZTmInMC3C/2bosVjnmzb7bNWXN
         joYYdJfryvRWKdMITrR8gKfO10LxCzChrYRWvSqfcLtVKF5jgyrP6DrVWmLYtN0vcw5f
         c2ig==
X-Gm-Message-State: AFqh2kobewq7Yk8mEekQ0cnRoQdYjZXs3dzPBc4fZwzfzKbGbqeJmh2M
        gOXSDzaLosBjtN7kx7tRxms=
X-Google-Smtp-Source: AMrXdXsSqgX1eCbByMRspRmpVs443dO6cnoqkgjpcmp7rYGyILs3YJoA5KfD38V8jlouCa38Uz4RtQ==
X-Received: by 2002:a05:600c:26d1:b0:3d1:e907:17c1 with SMTP id 17-20020a05600c26d100b003d1e90717c1mr33793226wmv.38.1672834743649;
        Wed, 04 Jan 2023 04:19:03 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.19.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:19:03 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 14/15] selftests/xsk: automatically restore packet stream
Date:   Wed,  4 Jan 2023 13:17:43 +0100
Message-Id: <20230104121744.2820-15-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
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

