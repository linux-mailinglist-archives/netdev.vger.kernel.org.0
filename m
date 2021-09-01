Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7B13FD821
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240021AbhIAKts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbhIAKtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:24 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D6CC0617AD;
        Wed,  1 Sep 2021 03:48:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id z9-20020a7bc149000000b002e8861aff59so4448544wmi.0;
        Wed, 01 Sep 2021 03:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E0VDHvF43KRG9qTwuNBsy2uPOJgG0Rgbq3u/fTxBkl8=;
        b=X0lCHdO84ygpA0LlYFrTyhBQNL+wDjtzmkKmT61vpEpeTZJAQK4Y7QEfoBLOJh4kNG
         Rh59lgmqE14CCqePVRBlPw0OZoMRmN1ZeVOsaEBqqElD3hy6DPW+O5c3JI94LguHrJcd
         d5nbjpOpFh0YnWmF+cPgv311i0hJZpbNQdL6sL2MbXmw7ej7hctG/QsvDRzO5yiLHnL3
         8JY+DWLb8/EqVw6YUn7HpJ8L3jaDpysRozp/N66BAtKsM+HhEX6yPHkyasjXVkFRdpRG
         iHyqTb7HF0Xoo5EXSSgQOSWpaHtgFvnKiwe2br3n+m8zU5ZW/nrjBOE8W07ooRWGE3K9
         qggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E0VDHvF43KRG9qTwuNBsy2uPOJgG0Rgbq3u/fTxBkl8=;
        b=BF/3TVZC3btaHDQQMsYeJ3MA8SWn2nzvMnIFGWhgx/lVSTRU7FZ24b7W3ILLWDqENh
         /qTP/3u+SzRHt1mogiDO+V9LONMO6g56qBEfaiXRabDtDLsREqTyMucxQMd5Kzae8w2U
         nmo9OkvcVmbT3na/cBizCC1dC9SjvpUHK4CMuFoyyFLOhZ6xNF4vTzciLfzQhrO284Z2
         nd2NqkNqx5Ng1sKCT+sB07bo5N6FYb2WpRZkT+fUjs+ZmZgGeRkeKo0ZgoIjJHlEWcJ5
         NWzqTuao/OUUw8oG7DY+oaWkgOB66LWWDdsHLZMZHhcV9385i1yvrW4Q9npUeFpjToS5
         HAbw==
X-Gm-Message-State: AOAM533hZ5vdWdrec6LC1rK37Qg54UXaebdNvZKDNAJ6mMJQ5FEE+q0L
        oGRmt24u/wYmWnU/7tQC+gk=
X-Google-Smtp-Source: ABdhPJxCJxObeemEEgip4mCAkGMLZAUztaNjWVRnf1FGaZfnPX7QWEdt4bLO164smdtm00AcdBxOZw==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr8856278wml.127.1630493305353;
        Wed, 01 Sep 2021 03:48:25 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:24 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 18/20] selftests: xsk: eliminate test specific if-statement in test runner
Date:   Wed,  1 Sep 2021 12:47:30 +0200
Message-Id: <20210901104732.10956-19-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
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
index a24068993cc3..d085033afd53 100644
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

