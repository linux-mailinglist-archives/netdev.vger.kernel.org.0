Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530CB22C3B3
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGXKur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:50:47 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55265 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGXKuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595587845; x=1627123845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=faYv4zDljy8BCwm/ZtE+efuxM/WTnpKbumDhZlQt/gw=;
  b=r9kmNSyiG/1zXBuOZsTAtT+wszlagexhKfgotpFP50/irHFQ87bZg1Q7
   5gP4sYb98Cz2DQJQ3ODPC83znEaJZOzFiVI6SrYkQBWfU0Qvb7x1I3I1r
   V76boP0HMmW5SMTrAIacCONbdA0Y7UmiafV6e/m1kCM5SOptnYG8SUqhS
   QBdj+dKRDqJU26QAGAiltezjvUi1c8NGpIZLhxUaShmfppKYRvmtn8h18
   sC/W56j9OTmKmYaeTPl7DkX/IFHuqaXfusUKQlej8P/wbWWZyLNLEhKYR
   NrnDIPwlN/0JeD3RMz/OPpLCku61w3RRA8vZXkHUfOwbuTF7DAxbOZ0HV
   w==;
IronPort-SDR: IpvGd94rCdYvtCoStj5E3VEe1Dt1eU36W7Whi3G8pPBogN5/kCBxKQmoOcj2diT0hKrLs5ccOG
 7qzYOfoGcU5aEby70aDy1hyLyTCsoSdwCePIadwO6lsXueRntU8KULrqFHepT4LSJMytQzV3Rw
 2JgdJMkdiGZ+4r+EAgz5TsRo3eJv/8g5Cvmi1HPgTUbl92ltd2T7PjjAXxDva1AtLCwzA2EdF2
 BDkyLONWbP4wcKeN9VRRv0uVsCkap2By32/pbs2EMW0PIqdUDRFFdXdFOJ+J2aOa8CfQeot7tm
 CP0=
X-IronPort-AV: E=Sophos;i="5.75,390,1589266800"; 
   d="scan'208";a="83152915"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 03:50:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 03:50:01 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 24 Jul 2020 03:50:00 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v3 1/7] net: macb: use device-managed devm_mdiobus_alloc()
Date:   Fri, 24 Jul 2020 13:50:27 +0300
Message-ID: <20200724105033.2124881-2-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the device-managed variant for the allocating the MDIO bus. This
cleans-up the code a little on the remove and error paths.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

Changes in v3:
 - added tags from Claudiu and Florian

Changes in v2:
 - none

 drivers/net/ethernet/cadence/macb_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a6a35e1b0115..89fe7af5e408 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -769,7 +769,7 @@ static int macb_mii_init(struct macb *bp)
 	/* Enable management port */
 	macb_writel(bp, NCR, MACB_BIT(MPE));
 
-	bp->mii_bus = mdiobus_alloc();
+	bp->mii_bus = devm_mdiobus_alloc(&bp->pdev->dev);
 	if (!bp->mii_bus) {
 		err = -ENOMEM;
 		goto err_out;
@@ -787,7 +787,7 @@ static int macb_mii_init(struct macb *bp)
 
 	err = macb_mdiobus_register(bp);
 	if (err)
-		goto err_out_free_mdiobus;
+		goto err_out;
 
 	err = macb_mii_probe(bp->dev);
 	if (err)
@@ -797,8 +797,6 @@ static int macb_mii_init(struct macb *bp)
 
 err_out_unregister_bus:
 	mdiobus_unregister(bp->mii_bus);
-err_out_free_mdiobus:
-	mdiobus_free(bp->mii_bus);
 err_out:
 	return err;
 }
@@ -4571,7 +4569,6 @@ static int macb_probe(struct platform_device *pdev)
 
 err_out_unregister_mdio:
 	mdiobus_unregister(bp->mii_bus);
-	mdiobus_free(bp->mii_bus);
 
 err_out_free_netdev:
 	free_netdev(dev);
@@ -4599,7 +4596,6 @@ static int macb_remove(struct platform_device *pdev)
 	if (dev) {
 		bp = netdev_priv(dev);
 		mdiobus_unregister(bp->mii_bus);
-		mdiobus_free(bp->mii_bus);
 
 		unregister_netdev(dev);
 		tasklet_kill(&bp->hresp_err_tasklet);
-- 
2.25.1

