Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63222878F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbgGURlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbgGURlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:05 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 725C8C0619E1
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8784393B00;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=eklBiWN0qC1KjdCqoBYsZrqkVZmQgGeNkxgNDBzKgqU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2016/29]=20l2tp:=20fix=20up=20incorrect=20comment=20in=20l2tp_
         recv_common|Date:=20Tue,=2021=20Jul=202020=2018:32:08=20+0100|Mess
         age-Id:=20<20200721173221.4681-17-tparkin@katalix.com>|In-Reply-To
         :=20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<202
         00721173221.4681-1-tparkin@katalix.com>;
        b=EwIvdiC3o34Z/on+tALKt3nfCF8xb4AbUpilKIclSMu+CkvDYBrjk8QnP0rpIk2uS
         RJU3qPLgR68CI/+SDtkinuxVOhmDTh6DdiZl4yvCNFbsI4B6mPQShYbeaoG9rAt/p9
         EG6kQBJT8VEpos2wHJTAwSAZKErVWKb869+TjcIbZNmW9Llibuzh9a05wVNkV/ZS6r
         ag6p3rDfzoV70knCleg5YK+uIDOpSQaD0idWqNXyFPp2OkThKl5BHEgS2Byr1juBuO
         a8hDAVZwhq22UXl/kjft/W4jZbUCjg+uyvzK/Ol+0RI+1Al6qMFo49KquGr+2SwTh6
         kgpos/XAzhSsg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 16/29] l2tp: fix up incorrect comment in l2tp_recv_common
Date:   Tue, 21 Jul 2020 18:32:08 +0100
Message-Id: <20200721173221.4681-17-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC2661 section 5.4 states that:

"The LNS controls enabling and disabling of sequence numbers by sending a
data message with or without sequence numbers present at any time during
the life of a session."

l2tp handles this correctly in l2tp_recv_common, but the comment around
the code was incorrect and confusing.  Fix up the comment accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 182386ad20e2..177accb01993 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -678,7 +678,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	}
 
 	if (L2TP_SKB_CB(skb)->has_seq) {
-		/* Received a packet with sequence numbers. If we're the LNS,
+		/* Received a packet with sequence numbers. If we're the LAC,
 		 * check if we sre sending sequence numbers and if not,
 		 * configure it so.
 		 */
-- 
2.17.1

