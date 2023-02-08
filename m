Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B69368EE28
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjBHLnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBHLna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:43:30 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13FC4615B
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:43:28 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 648D520678;
        Wed,  8 Feb 2023 12:43:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zn3H1So7Q9nn; Wed,  8 Feb 2023 12:43:26 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5673920656;
        Wed,  8 Feb 2023 12:43:26 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 453DE80004A;
        Wed,  8 Feb 2023 12:43:26 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 8 Feb 2023 12:43:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 8 Feb
 2023 12:43:25 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 745033182EAD; Wed,  8 Feb 2023 12:43:25 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/6] xfrm: consistently use time64_t in xfrm_timer_handler()
Date:   Wed, 8 Feb 2023 12:43:20 +0100
Message-ID: <20230208114322.266510-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230208114322.266510-1-steffen.klassert@secunet.com>
References: <20230208114322.266510-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For some reason, blamed commit did the right thing in xfrm_policy_timer()
but did not in xfrm_timer_handler()

Fixes: 386c5680e2e8 ("xfrm: use time64_t for in-kernel timestamps")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_state.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 89c731f4f0c7..5f03d1fbb98e 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -577,7 +577,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	if (x->km.state == XFRM_STATE_EXPIRED)
 		goto expired;
 	if (x->lft.hard_add_expires_seconds) {
-		long tmo = x->lft.hard_add_expires_seconds +
+		time64_t tmo = x->lft.hard_add_expires_seconds +
 			x->curlft.add_time - now;
 		if (tmo <= 0) {
 			if (x->xflags & XFRM_SOFT_EXPIRE) {
@@ -594,7 +594,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 			next = tmo;
 	}
 	if (x->lft.hard_use_expires_seconds) {
-		long tmo = x->lft.hard_use_expires_seconds +
+		time64_t tmo = x->lft.hard_use_expires_seconds +
 			(x->curlft.use_time ? : now) - now;
 		if (tmo <= 0)
 			goto expired;
@@ -604,7 +604,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	if (x->km.dying)
 		goto resched;
 	if (x->lft.soft_add_expires_seconds) {
-		long tmo = x->lft.soft_add_expires_seconds +
+		time64_t tmo = x->lft.soft_add_expires_seconds +
 			x->curlft.add_time - now;
 		if (tmo <= 0) {
 			warn = 1;
@@ -616,7 +616,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 		}
 	}
 	if (x->lft.soft_use_expires_seconds) {
-		long tmo = x->lft.soft_use_expires_seconds +
+		time64_t tmo = x->lft.soft_use_expires_seconds +
 			(x->curlft.use_time ? : now) - now;
 		if (tmo <= 0)
 			warn = 1;
-- 
2.34.1

