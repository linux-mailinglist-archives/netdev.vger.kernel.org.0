Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB904AD6BB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356802AbiBHL3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347234AbiBHJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:52:46 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4E5C03FEC1;
        Tue,  8 Feb 2022 01:52:44 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 7428E2029F; Tue,  8 Feb 2022 17:46:33 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH net-next 1/5] mctp: tests: Rename FL_T macro to FL_TO
Date:   Tue,  8 Feb 2022 17:46:13 +0800
Message-Id: <20220208094617.3675511-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208094617.3675511-1-jk@codeconstruct.com.au>
References: <20220208094617.3675511-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a definition for the tag-owner flag, which has TO as a standard
abbreviation. We'll want to add a helper for the actual tag value in a
future change.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/route-test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 750f9f9b4daf..5862f7fea01f 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -369,14 +369,14 @@ static void mctp_test_route_input_sk(struct kunit *test)
 
 #define FL_S	(MCTP_HDR_FLAG_SOM)
 #define FL_E	(MCTP_HDR_FLAG_EOM)
-#define FL_T	(MCTP_HDR_FLAG_TO)
+#define FL_TO	(MCTP_HDR_FLAG_TO)
 
 static const struct mctp_route_input_sk_test mctp_route_input_sk_tests[] = {
-	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_T), .type = 0, .deliver = true },
-	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_T), .type = 1, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_TO), .type = 0, .deliver = true },
+	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_TO), .type = 1, .deliver = false },
 	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E), .type = 0, .deliver = false },
-	{ .hdr = RX_HDR(1, 10, 8, FL_E | FL_T), .type = 0, .deliver = false },
-	{ .hdr = RX_HDR(1, 10, 8, FL_T), .type = 0, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, FL_E | FL_TO), .type = 0, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, FL_TO), .type = 0, .deliver = false },
 	{ .hdr = RX_HDR(1, 10, 8, 0), .type = 0, .deliver = false },
 };
 
@@ -436,7 +436,7 @@ static void mctp_test_route_input_sk_reasm(struct kunit *test)
 	__mctp_route_test_fini(test, dev, rt, sock);
 }
 
-#define RX_FRAG(f, s) RX_HDR(1, 10, 8, FL_T | (f) | ((s) << MCTP_HDR_SEQ_SHIFT))
+#define RX_FRAG(f, s) RX_HDR(1, 10, 8, FL_TO | (f) | ((s) << MCTP_HDR_SEQ_SHIFT))
 
 static const struct mctp_route_input_sk_reasm_test mctp_route_input_sk_reasm_tests[] = {
 	{
-- 
2.34.1

