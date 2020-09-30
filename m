Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD08527F31D
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgI3US2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbgI3US0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64297C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:26 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYS-0002Qt-BX; Wed, 30 Sep 2020 22:18:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 04/13] can: mcp25xxfd: mcp25xxfd_irq(): add missing initialization of variable set_normal mode
Date:   Wed, 30 Sep 2020 22:18:07 +0200
Message-Id: <20200930201816.1032054-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following warning:

    drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c:2155 mcp25xxfd_irq()
    error: uninitialized symbol 'set_normal_mode'.

by adding the missing initialization.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Link: https://lore.kernel.org/r/20200923114726.2704426-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
index b91180b560fd..95d5cb46bc63 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
@@ -2080,7 +2080,7 @@ static irqreturn_t mcp25xxfd_irq(int irq, void *dev_id)
 
 	do {
 		u32 intf_pending, intf_pending_clearable;
-		bool set_normal_mode;
+		bool set_normal_mode = false;
 
 		err = regmap_bulk_read(priv->map_reg, MCP25XXFD_REG_INT,
 				       &priv->regs_status,
-- 
2.28.0

