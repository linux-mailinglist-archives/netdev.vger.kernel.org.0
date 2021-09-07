Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D1D402419
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242504AbhIGHWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241232AbhIGHV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:26 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE926C0617AD;
        Tue,  7 Sep 2021 00:20:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q26so11983595wrc.7;
        Tue, 07 Sep 2021 00:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AJ4aDVDczwZqN70zSSNf1aoBcnVfPl/TxOgPtYPbtLw=;
        b=VV0aP1YkcnQLf6HqxRqCKn39E/rYEXlWHT1IW3KFM92AlhMJDC6+z+s+KSP3imKlW0
         Av4irUNezTIH3aT3S14itZ26BiqBvHazDIGtmMqMtheN9rjqDA1QKOflXB+FjY3LFXCf
         UKGQQulmuEDBueFGv2sCpgmmRZM1z9i4jn4tsXuaspMjYT32KzKoBAFHICEUKoqByV04
         5XlBl6i6+aEttFNx/eHPAJjFTHexLw96c00OOnCbsJh2+l0VogQ41NebJMes4DkDig1L
         txbrQNBHWM4Wgmajx1/UcZUJihvfXQeFJGfqopeupGpnSmjzGG//9F9/bexx9GBek6sW
         FKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJ4aDVDczwZqN70zSSNf1aoBcnVfPl/TxOgPtYPbtLw=;
        b=KAG3TXRiRJg0Yd+FoS4A9Hm9d6KBtwKl63CX3hMhcc0GzTkxFLrD2K3mYcATZ+Zhee
         ZkPcJZH6ok3Gh2ED9+inA759w8eJVup9nWJ5wBHW5E8C8/2FYh4ogB7H6o+qM0pG8mbT
         6b+bBCy2Cl8D+24wk+rMJPs8f2JpTB+quvMMv5qSjWFj4naE9AF3CF5b5vXB29ABElwZ
         253nru9zd8QofE8rB85OfUqV+JdBS3FRmP3iigZSLXb3Pd7FMlzAMCPd0+KbFCK5iLgF
         ZPGO67IQjjYuUMLcJxqLtXYxeL88NX5dmIy05YDpcVs/g24YkN25b0q8A38jZj2U+qQq
         u0Ng==
X-Gm-Message-State: AOAM530nbxgRU1shCZxcUgtFQRjQ3H+5Mumd8poBxKQhBLWwZh5jNLyl
        F7s8VdQ0Gkx1jwirnfT2MfnEUUz2oODNS9dnUb4=
X-Google-Smtp-Source: ABdhPJy9VAxIdS4l61Yc/e5hnuHMtQqvTrCEr9Z8stM5cK/vF9g4eiMeAOsfWmv+3uWoxs6PvUWj1Q==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr11543379wre.257.1630999216490;
        Tue, 07 Sep 2021 00:20:16 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:16 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 18/20] selftests: xsk: eliminate test specific if-statement in test runner
Date:   Tue,  7 Sep 2021 09:19:26 +0200
Message-Id: <20210907071928.9750-19-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Eliminate a test specific if-statement for the RX_FILL_EMTPY stats
test that is present in the test runner. We can do this as we now have
the use_addr_for_fill option. Just create and empty Rx packet stream
and indicated that the test runner should use the addresses in that to
populate the fill ring. As there are no packets in the stream, the
fill ring will be empty and we will get the error stats that we want
to test.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 7cc75d1481e2..4d86c4b62aa9 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -458,8 +458,10 @@ static void pkt_stream_delete(struct pkt_stream *pkt_stream)
 
 static void pkt_stream_restore_default(struct test_spec *test)
 {
-	pkt_stream_delete(test->ifobj_tx->pkt_stream);
-	test->ifobj_tx->pkt_stream = test->pkt_stream_default;
+	if (test->ifobj_tx->pkt_stream != test->pkt_stream_default) {
+		pkt_stream_delete(test->ifobj_tx->pkt_stream);
+		test->ifobj_tx->pkt_stream = test->pkt_stream_default;
+	}
 	test->ifobj_rx->pkt_stream = test->pkt_stream_default;
 }
 
@@ -931,8 +933,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	if (test->current_step == 1)
 		thread_common_ops(test, ifobject);
 
-	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
-		xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
+	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
 
 	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds.events = POLLIN;
@@ -1065,7 +1066,14 @@ static void testapp_stats(struct test_spec *test)
 			break;
 		case STAT_TEST_RX_FILL_EMPTY:
 			test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
+			test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem, 0,
+									 MIN_PKT_SIZE);
+			if (!test->ifobj_rx->pkt_stream)
+				exit_with_error(ENOMEM);
+			test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
 			testapp_validate_traffic(test);
+
+			pkt_stream_restore_default(test);
 			break;
 		default:
 			break;
-- 
2.29.0

