Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C42F46305C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 10:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhK3KA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:00:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:14446 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240710AbhK3KA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638266228; x=1669802228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ke/qlUb9GZx2zEENvrUAFkCCY38r5VXqdPGEFDpg3ck=;
  b=hs+6N+sOfUy2JF+UqQz0PzmxCr3PEuuGRfpAhFjanvYQbj8kJe8dsZNy
   IXLpqwKaHBXrz/mJ9ygKS+TU39CufRVg1aef/0eezfh+NobqZQPHPCuza
   HyPhtVNC9naWeK5AF/h5DDgB7FpcKqOpu+12Q+QhYQNAdGQjRcfLbBQZl
   EyqgYn4xHNefCFs281RlrZPEg+VM68QKlG6Xi9g7q6f61kbxAvrlYg+cL
   6Oty4izUNPEzcnuTaa6iJMWhu/RJ3nqYjmGcJ+KLuR98Tb0DUweEUgN/f
   0GvnxRbKtm3hSvx3b7uPtMPI/1uiLZvgWHHyx/v/4SOrObCd4H4KgJuV3
   g==;
IronPort-SDR: Oy3CVSc9T86+KuTcartVCkXllYjcdG8iJu6G7gtH1LJWHDzKUJi2fuHjHj8eVjFb73eT1Z/2dr
 PPvZBZgcxxEkCK5x4j0KmcITa47GirbZpjBV70KYm0jvAB3pEJjab6zbAMpcji9FTvneCaXlyN
 Wj4o6d0TCFZzlxLNlmQCb+wr9/x7gVb1ZJxnlJKRqcd8zx9iApU0E0NgqYrcgYbMXp3olONjSU
 aWznAs+U7aIdFAfCFcquvYj3uRUnBTN5RqEVAHb3IMDmCBxahMjlLgQQrjz0P39McAofYAyO2l
 /ZhgDuu5krMbUZ1nFQTkmbbU
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="153662645"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2021 02:57:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 30 Nov 2021 02:57:07 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 30 Nov 2021 02:57:05 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <colin.foster@in-advantage.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: mdio: mscc-miim: Set back the optional resource.
Date:   Tue, 30 Nov 2021 10:57:45 +0100
Message-ID: <20211130095745.163287-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the blamed commit, the second memory resource was not considered
anymore as optional. On some platforms like sparx5 the second resource
is optional. So add it back as optional and restore the comment that
says so.

Fixes: a27a762828375a ("net: mdio: mscc-miim: convert to a regmap implementation")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 2d420c9d7520..7d2abaf2b2c9 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -219,9 +219,10 @@ EXPORT_SYMBOL(mscc_miim_setup);
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct regmap *mii_regmap, *phy_regmap;
+	struct regmap *mii_regmap, *phy_regmap = NULL;
 	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
+	struct resource *res;
 	struct mii_bus *bus;
 	int ret;
 
@@ -239,17 +240,21 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(mii_regmap);
 	}
 
-	phy_regs = devm_platform_ioremap_resource(pdev, 1);
-	if (IS_ERR(phy_regs)) {
-		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-		return PTR_ERR(phy_regs);
-	}
+	/* This resource is optional */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res) {
+		phy_regs = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(phy_regs)) {
+			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+			return PTR_ERR(phy_regs);
+		}
 
-	phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
-					   &mscc_miim_regmap_config);
-	if (IS_ERR(phy_regmap)) {
-		dev_err(&pdev->dev, "Unable to create phy register regmap\n");
-		return PTR_ERR(phy_regmap);
+		phy_regmap = devm_regmap_init_mmio(&pdev->dev, phy_regs,
+						   &mscc_miim_regmap_config);
+		if (IS_ERR(phy_regmap)) {
+			dev_err(&pdev->dev, "Unable to create phy register regmap\n");
+			return PTR_ERR(phy_regmap);
+		}
 	}
 
 	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0);
-- 
2.33.0

