Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5AB4ED18
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFUQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:22:34 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:49370 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfFUQWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:22:33 -0400
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id ADDAE3AB780;
        Fri, 21 Jun 2019 15:30:12 +0000 (UTC)
X-Originating-IP: 90.88.16.156
Received: from localhost (aaubervilliers-681-1-41-156.w90-88.abo.wanadoo.fr [90.88.16.156])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 710BE40012;
        Fri, 21 Jun 2019 15:30:03 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, nicolas.ferre@microchip.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ludovic.desroches@microchip.com, alexandre.belloni@bootlin.com
Subject: [PATCH net-next] net: macb: use NAPI_POLL_WEIGHT
Date:   Fri, 21 Jun 2019 17:28:55 +0200
Message-Id: <20190621152855.30330-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use NAPI_POLL_WEIGHT, the default NAPI poll() weight instead of
redefining our own value (which turns out to be 64 as well).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 163deba244ab..1cd1f2c36d6f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3490,7 +3490,7 @@ static int macb_init(struct platform_device *pdev)
 
 		queue = &bp->queues[q];
 		queue->bp = bp;
-		netif_napi_add(dev, &queue->napi, macb_poll, 64);
+		netif_napi_add(dev, &queue->napi, macb_poll, NAPI_POLL_WEIGHT);
 		if (hw_q) {
 			queue->ISR  = GEM_ISR(hw_q - 1);
 			queue->IER  = GEM_IER(hw_q - 1);
-- 
2.21.0

