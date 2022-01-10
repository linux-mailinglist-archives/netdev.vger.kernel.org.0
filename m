Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23792488E9F
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiAJCSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:18:21 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46414 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiAJCSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:18:20 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id DF3F320237; Mon, 10 Jan 2022 10:52:04 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Subject: [PATCH net] mctp: test: zero out sockaddr
Date:   Mon, 10 Jan 2022 10:18:06 +0800
Message-Id: <20220110021806.2343023-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MCTP now requires that padding bytes are zero.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: 1e4b50f06d97 ("mctp: handle the struct sockaddr_mctp padding fields")
---
 net/mctp/test/route-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 36fac3daf86a..b6ca88b2510d 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -290,7 +290,7 @@ static void __mctp_route_test_init(struct kunit *test,
 				   struct mctp_test_route **rtp,
 				   struct socket **sockp)
 {
-	struct sockaddr_mctp addr;
+	struct sockaddr_mctp addr = {0};
 	struct mctp_test_route *rt;
 	struct mctp_test_dev *dev;
 	struct socket *sock;
-- 
2.32.0

