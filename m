Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FF939786
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbfFGVP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:15:58 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35935 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731270AbfFGVPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:55 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDJ-00006I-9K; Fri, 07 Jun 2019 23:15:53 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 8/9] can: flexcan: Remove unneeded registration message
Date:   Fri,  7 Jun 2019 23:15:40 +0200
Message-Id: <20190607211541.16095-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

Currently the following message is observed when the flexcan
driver is probed:

flexcan 2090000.flexcan: device registered (reg_base=(ptrval), irq=23)

The reason for printing 'ptrval' is explained at
Documentation/core-api/printk-formats.rst:

"Pointers printed without a specifier extension (i.e unadorned %p) are
hashed to prevent leaking information about the kernel memory layout. This
has the added benefit of providing a unique identifier. On 64-bit machines
the first 32 bits are zeroed. The kernel will print ``(ptrval)`` until it
gathers enough entropy."

Instead of passing %pK, which can print the correct address, simply
remove the entire message as it is not really that useful.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f97c628eb2ad..f2fe344593d5 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1583,9 +1583,6 @@ static int flexcan_probe(struct platform_device *pdev)
 			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
 	}
 
-	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
-		 priv->regs, dev->irq);
-
 	return 0;
 
  failed_register:
-- 
2.20.1

