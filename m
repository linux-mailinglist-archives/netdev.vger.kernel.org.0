Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D55622870C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbgGURQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:16:02 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35036 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729207AbgGURQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595351760; x=1626887760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BmtTMrdJrMBJ7rJs0O3LHTqKK1doUSizTNZocewKz/0=;
  b=VojUCUSuwVNQ7lsxhj4G2QthB8Sb+EWc4UyOfxmgTTtAf380qf4nGDnk
   P++KizFQDJtlzdMyxEgxlQ/tY5qAtUHuOqRkKXi9SubvTVWB/m94rwZPE
   nIRAyrjin+nEfvjsmxtZODLW5kkdI32algycjmY9MFY09y6xmz14po1AQ
   s2FsmhISIrQz80wqVQg1zvSkpLL4KTnV5GZ35ofodbnTu2QPSAeuMbK+V
   1zoUS1OLeEXVRUJiO3fZP1YtW+BGBMKfOyhKnv10dbEdm5rKBZhIv/kgv
   eo1WimRfVbns0OJtShl1F0xBPwCD8Z+L5i6zJ7CeZtDS96xYH4DMhfsbE
   Q==;
IronPort-SDR: LFD9FC8EuYhl6wV/Nqy7EMNDW9oQVfogIP+/eFZci4pAP2V/+Wj5t5I/21ywaTgAxh0PQtJw/X
 z0xPI4NbJtSjOo79ABi57oylBELBfTngziJpKRhuhOSvut+jfBPe6vTOt3KBgFg9rJ1QxxtSsv
 6oklAUXyH7Dz/NrWJ81xTu8lt3vzLAlg3j5nKPcRP2JZLzu6jK1Psn7lzmrxsJkj3eZ4T3eV7n
 3VRDYV+l9mBAHCZl4zeNCa7x8DOusbOlDNi67g3+nTo81akRTuTKyYHsVED/L+KH57TpfBTVQI
 khE=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="82696840"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:15:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:15:59 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:14:02 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 1/7] net: macb: use device-managed devm_mdiobus_alloc()
Date:   Tue, 21 Jul 2020 20:13:10 +0300
Message-ID: <20200721171316.1427582-2-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
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
---

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

