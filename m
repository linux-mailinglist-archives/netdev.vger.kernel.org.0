Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E596229D2B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbgGVQct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbgGVQcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:32:36 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F526C0619E2
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:32:36 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id BDFBC93AD8;
        Wed, 22 Jul 2020 17:32:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=39QN97kelwNR4cQwhD9I1Bi8jZtPSZnI5otFExZvl4k=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2010/10]=20l2tp:=20avoid=20preci
         dence=20issues=20in=20L2TP_SKB_CB=20macro|Date:=20Wed,=2022=20Jul=
         202020=2017:32:14=20+0100|Message-Id:=20<20200722163214.7920-11-tp
         arkin@katalix.com>|In-Reply-To:=20<20200722163214.7920-1-tparkin@k
         atalix.com>|References:=20<20200722163214.7920-1-tparkin@katalix.c
         om>;
        b=I8o2tywg90IW6VWxehuMFvyRSJ+HBM9pCKdyPdfOgeGNNoWCVb3dmPmHepu9Rlebe
         vQ9STPKd5BOSTBep+dTZeFmqm3fzpCuSwBLhqL0OL1vmnq6KoHW5NIez6rII2beGbd
         /ILVFdCWqouAJQvoF2b6b7mSbUHcG69CR4Y5XqXnCxxgP+rZuYNq9iNqL5tUiQlSoo
         wt4C7Ckl67OPXUbSNhhFNfSB2/P7v16i6ClXVeYvHOezqEGOT5qP4xo5rCd7bmJbUi
         dnZDuBDMs1/iLQyvY/avYOxMNCyBYENDvw01KjlB2NNLGdC480i3fGbClf3FQ8awb+
         +hpgxAhseNrSQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 10/10] l2tp: avoid precidence issues in L2TP_SKB_CB macro
Date:   Wed, 22 Jul 2020 17:32:14 +0100
Message-Id: <20200722163214.7920-11-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warned about the L2TP_SKB_CB macro's use of its argument: add
braces to avoid the problem.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 3dc712647f34..6871611d99f2 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -93,7 +93,7 @@ struct l2tp_skb_cb {
 	unsigned long		expires;
 };
 
-#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&skb->cb[sizeof(struct inet_skb_parm)])
+#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&(skb)->cb[sizeof(struct inet_skb_parm)])
 
 static struct workqueue_struct *l2tp_wq;
 
-- 
2.17.1

