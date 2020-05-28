Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2FC1E6E9A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437035AbgE1WWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:22:39 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55249 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436993AbgE1WWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:22:16 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Y2Hh0QpTz1qrMY;
        Fri, 29 May 2020 00:22:08 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Y2Hg6w2Kz1qsqH;
        Fri, 29 May 2020 00:22:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id iy-BeagDu6kY; Fri, 29 May 2020 00:22:06 +0200 (CEST)
X-Auth-Info: m+ceFgKrw7g8n1Sr1IYPDx9Xx2UC6+kwBmmEJ4vTYoE=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 29 May 2020 00:22:06 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V7 03/19] net: ks8851: Replace dev_err() with netdev_err() in IRQ handler
Date:   Fri, 29 May 2020 00:21:30 +0200
Message-Id: <20200528222146.348805-4-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_err() instead of dev_err() to avoid accessing the spidev->dev
in the interrupt handler. This is the only place which uses the spidev
in this function, so replace it with netdev_err() to get rid of it. This
is done in preparation for unifying the KS8851 SPI and parallel drivers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: Add RB from Andrew
V3: No change
V4: No change
V5: No change
V6: No change
V7: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 2b85072993c5..0088df970ad6 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -631,7 +631,7 @@ static irqreturn_t ks8851_irq(int irq, void *_ks)
 		handled |= IRQ_RXI;
 
 	if (status & IRQ_SPIBEI) {
-		dev_err(&ks->spidev->dev, "%s: spi bus error\n", __func__);
+		netdev_err(ks->netdev, "%s: spi bus error\n", __func__);
 		handled |= IRQ_SPIBEI;
 	}
 
-- 
2.25.1

