Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF9713391
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 20:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfECSVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 14:21:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35384 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbfECSVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 14:21:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMcoQ-000793-TG; Fri, 03 May 2019 20:21:35 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net] um: vector netdev: adjust to xmit_more API change
Date:   Fri,  3 May 2019 20:21:33 +0200
Message-Id: <20190503182133.16856-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Replace skb->xmit_more usage by netdev_xmit_more().

Fixes: 4f296edeb9d4 ("drivers: net: aurora: use netdev_xmit_more helper")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 arch/um/drivers/vector_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 596e7056f376..e190e4ca52e1 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1043,7 +1043,7 @@ static int vector_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		vector_send(vp->tx_queue);
 		return NETDEV_TX_OK;
 	}
-	if (skb->xmit_more) {
+	if (netdev_xmit_more()) {
 		mod_timer(&vp->tl, vp->coalesce);
 		return NETDEV_TX_OK;
 	}
-- 
2.17.2

