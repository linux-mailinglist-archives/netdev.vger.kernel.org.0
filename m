Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41F53FD822
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbhIAKtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238584AbhIAKt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:26 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A419AC061760;
        Wed,  1 Sep 2021 03:48:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i3so1526611wmq.3;
        Wed, 01 Sep 2021 03:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w/EUsXdij3lSByOwN7tFJbAP26Euxi8J8qCeyd1PWMU=;
        b=qlb0H+nTRnwBTgGZDO4SUQ59o1cPMiA25U3w2BRdVFQdNw62AB1Rrbn/N1o9B0v5T6
         /VfkV89FeqEwmJDI1WEhHL1CCUll+SKQK+9xnSVWPFFCbOEo0twTk3/vBtauQoYWx3H8
         TpjrT30m9+L1QWCzBoTCt+ZOB3dSzbQ7A2cAv3DrzjSFTcerSVxetbhORcalXd4GCQ7D
         Uv2RfgHNsY5lYo9gP4oRtgXhUKXMhWnWXy/SuDTrYbRCDMQTy/SzEF6Y69s94vtaKqjC
         3hD19uC18nTSKw3o8ZgzObPx1NatPlHAfWMus/jwJgA75dBbpzTHJviP4n3mQaN4Zvng
         zexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w/EUsXdij3lSByOwN7tFJbAP26Euxi8J8qCeyd1PWMU=;
        b=bwhxzrHEwrdMZEE71fckzpj61NePV5O/NPoZjALR+obIIbPDBE/21U+mGfAbPYH8br
         v1JgDf0RvPvP4m8JWADM/QkgY1oXVSbBDVnPC86y17/odeX3UqUozaoJFZ6s/0KNQc3J
         Sc562fN6qEf3y+EEH3nF7IND0tOH5rt5Kw1gaOTQUom6w63B5P85eeWmc2CMmYElZ4BD
         PnUU7+5+kkc/QGiFkSwL/qjHmVrMtxydoahG6ZCHjd1RO7yshfE7LT5KoZidllCGs5CW
         kaFBxtJ8YJSsc/HiWuCCS8OJQ3xm9bkomVg0huXIciAV2ni3yrNlq0J5Xhh4dtNDVwn5
         GjBw==
X-Gm-Message-State: AOAM530CJEJDX9kvK5gEDUCYQh7M2c28sf8Y9cdtNRTxFY3T7gezUzqG
        svLHP0fTRvkl13FX78I/m20pRXT4U0dCy+gu
X-Google-Smtp-Source: ABdhPJwi7+GmyjMmJkxgvGpjXP/yyjCa74pcsuZA//4/w0AjBXvrnrnIlx8PXa/S8s6VIczmSqaGwA==
X-Received: by 2002:a05:600c:350d:: with SMTP id h13mr8776634wmq.38.1630493308309;
        Wed, 01 Sep 2021 03:48:28 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:27 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 20/20] selftests: xsk: add tests for 2K frame size
Date:   Wed,  1 Sep 2021 12:47:32 +0200
Message-Id: <20210901104732.10956-21-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add tests for 2K frame size. Both a standard send and receive test and
one testing for invalid descriptors when the frame size is 2K.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 23 +++++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index a4f6ce3a6b14..8e4cb781a3e3 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -48,6 +48,7 @@
  *    g. unaligned mode
  *    h. tests for invalid and corner case Tx descriptors so that the correct ones
  *       are discarded and let through, respectively.
+ *    i. 2K frame size tests
  *
  * Total tests: 12
  *
@@ -1203,6 +1204,8 @@ static void testapp_inv_desc(struct test_spec *test)
 			     {UMEM_SIZE - PKT_SIZE / 2, PKT_SIZE, 0, false},
 		/* Straddle a page boundrary */
 			     {0x3000 - PKT_SIZE / 2, PKT_SIZE, 0, false},
+		/* Straddle a 2K boundrary */
+			     {0x3800 - PKT_SIZE / 2, PKT_SIZE, 0, true},
 		/* Valid packet for synch so that something is received */
 			     {0x4000, PKT_SIZE, 0, true}};
 
@@ -1210,6 +1213,11 @@ static void testapp_inv_desc(struct test_spec *test)
 		/* Crossing a page boundrary allowed */
 		pkts[6].valid = true;
 	}
+	if (test->ifobj_tx->umem->frame_size == XSK_UMEM__DEFAULT_FRAME_SIZE / 2) {
+		/* Crossing a 2K frame size boundrary not allowed */
+		pkts[7].valid = false;
+	}
+
 	pkt_stream_set(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
 	pkt_stream_restore_default(test);
@@ -1260,6 +1268,15 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "RUN_TO_COMPLETION");
 		testapp_validate_traffic(test);
 		break;
+	case TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME:
+		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
+		test->ifobj_tx->umem->frame_size = 2048;
+		test->ifobj_rx->umem->frame_size = 2048;
+		pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
+		testapp_validate_traffic(test);
+
+		pkt_stream_restore_default(test);
+		break;
 	case TEST_TYPE_POLL:
 		test->ifobj_tx->use_poll = true;
 		test->ifobj_rx->use_poll = true;
@@ -1270,6 +1287,12 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
 		testapp_inv_desc(test);
 		break;
+	case TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME:
+		test_spec_set_name(test, "ALIGNED_INV_DESC_2K_FRAME_SIZE");
+		test->ifobj_tx->umem->frame_size = 2048;
+		test->ifobj_rx->umem->frame_size = 2048;
+		testapp_inv_desc(test);
+		break;
 	case TEST_TYPE_UNALIGNED_INV_DESC:
 		test_spec_set_name(test, "UNALIGNED_INV_DESC");
 		test->ifobj_tx->umem->unaligned_mode = true;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 2d9efb89ea28..5ac4a5e64744 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -54,9 +54,11 @@ enum test_mode {
 
 enum test_type {
 	TEST_TYPE_RUN_TO_COMPLETION,
+	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
 	TEST_TYPE_POLL,
 	TEST_TYPE_UNALIGNED,
 	TEST_TYPE_ALIGNED_INV_DESC,
+	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
 	TEST_TYPE_UNALIGNED_INV_DESC,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
-- 
2.29.0

