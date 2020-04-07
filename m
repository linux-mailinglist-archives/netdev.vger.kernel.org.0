Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0262C1A1601
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 21:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgDGTck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 15:32:40 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:50672 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGTcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 15:32:39 -0400
Received: from localhost.localdomain ([93.22.37.82])
        by mwinf5d42 with ME
        id PvYb220081mLNr903vYbaZ; Tue, 07 Apr 2020 21:32:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 07 Apr 2020 21:32:37 +0200
X-ME-IP: 93.22.37.82
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, kvalo@codeaurora.org,
        davem@davemloft.net, huangfq.daxian@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] qtnfmac: Simplify code in _attach functions
Date:   Tue,  7 Apr 2020 21:32:33 +0200
Message-Id: <20200407193233.9439-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to re-implement 'netdev_alloc_skb_ip_align()' here.
Keep the code simple.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 2 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index dbb241106d8a..eb67b66b846b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -286,7 +286,7 @@ static int pearl_skb2rbd_attach(struct qtnf_pcie_pearl_state *ps, u16 index)
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 
-	skb = __netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE, GFP_ATOMIC);
+	skb = netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE);
 	if (!skb) {
 		priv->rx_skb[index] = NULL;
 		return -ENOMEM;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index dbf3c5fd751f..d1b850aa4657 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -247,7 +247,7 @@ topaz_skb2rbd_attach(struct qtnf_pcie_topaz_state *ts, u16 index, u32 wrap)
 	struct sk_buff *skb;
 	dma_addr_t paddr;
 
-	skb = __netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE, GFP_ATOMIC);
+	skb = netdev_alloc_skb_ip_align(NULL, SKB_BUF_SIZE);
 	if (!skb) {
 		ts->base.rx_skb[index] = NULL;
 		return -ENOMEM;
-- 
2.20.1

