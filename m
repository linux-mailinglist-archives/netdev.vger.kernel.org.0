Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C861B7A77
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgDXPpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:45:45 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:36107 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgDXPpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 11:45:45 -0400
Received: from localhost.localdomain ([92.148.159.11])
        by mwinf5d39 with ME
        id WflZ2200F0F2omL03fldWL; Fri, 24 Apr 2020 17:45:42 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 24 Apr 2020 17:45:42 +0200
X-ME-IP: 92.148.159.11
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2] ipw2x00: Remove a memory allocation failure log message
Date:   Fri, 24 Apr 2020 17:45:27 +0200
Message-Id: <20200424154527.27309-1-christophe.jaillet@wanadoo.fr>
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
v2: remove a useless empty line
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 60b5e08dd6df..30c4f041f565 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3770,10 +3770,8 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
 	struct pci_dev *dev = priv->pci_dev;
 
 	q->txb = kmalloc_array(count, sizeof(q->txb[0]), GFP_KERNEL);
-	if (!q->txb) {
-		IPW_ERROR("vmalloc for auxiliary BD structures failed\n");
+	if (!q->txb)
 		return -ENOMEM;
-	}
 
 	q->bd =
 	    pci_alloc_consistent(dev, sizeof(q->bd[0]) * count, &q->q.dma_addr);
-- 
2.20.1

