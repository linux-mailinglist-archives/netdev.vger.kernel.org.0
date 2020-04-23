Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33A61B56CA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDWH6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:58:32 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:45974 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgDWH6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:58:31 -0400
Received: from localhost.localdomain ([93.23.15.131])
        by mwinf5d85 with ME
        id W7yS2200m2pfeyd037yTwC; Thu, 23 Apr 2020 09:58:29 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 23 Apr 2020 09:58:29 +0200
X-ME-IP: 93.23.15.131
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ipw2x00: Remove a memory allocation failure log message
Date:   Thu, 23 Apr 2020 09:58:25 +0200
Message-Id: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Axe a memory allocation failure log message. This message is useless and
incorrect (vmalloc is not used here for the memory allocation)

This has been like that since the very beginning of this driver in
commit 43f66a6ce8da ("Add ipw2200 wireless driver.")

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 60b5e08dd6df..30c4f041f565 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3770,10 +3770,9 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
 	struct pci_dev *dev = priv->pci_dev;
 
 	q->txb = kmalloc_array(count, sizeof(q->txb[0]), GFP_KERNEL);
-	if (!q->txb) {
-		IPW_ERROR("vmalloc for auxiliary BD structures failed\n");
+	if (!q->txb)
 		return -ENOMEM;
-	}
+
 
 	q->bd =
 	    pci_alloc_consistent(dev, sizeof(q->bd[0]) * count, &q->q.dma_addr);
-- 
2.20.1

