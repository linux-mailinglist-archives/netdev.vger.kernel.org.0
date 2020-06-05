Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528001EF9D0
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 16:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgFEOBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 10:01:38 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34278 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgFEOBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 10:01:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 055E1ErC013424;
        Fri, 5 Jun 2020 09:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591365674;
        bh=AypTQ6/e5Qa7oA1xhx1cuNPafjOMIiXTb3HfNLbEzbI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=BgMhjbLkYqWbwUb6nw3eTG+f4QDwMjmgvdUGe79hBttEWu7NGn6vY0/toZiFGNQAT
         rqQ5teTvFXUDXlCwm4YgIqiFdPvzE+ciDOOvKpvIL5DZpnUn6MpPhZXYYzgL/ZEBn3
         MtYIM4HfVFUBSB91fFdZbZq3lKhwPkikJzztHm50=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 055E1Ei7120250;
        Fri, 5 Jun 2020 09:01:14 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 5 Jun
 2020 09:01:14 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 5 Jun 2020 09:01:14 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 055E1EjI090931;
        Fri, 5 Jun 2020 09:01:14 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michael@walle.cc>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net 2/4] net: dp83867: Fix OF_MDIO config check
Date:   Fri, 5 Jun 2020 09:01:05 -0500
Message-ID: <20200605140107.31275-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605140107.31275-1-dmurphy@ti.com>
References: <20200605140107.31275-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_OF_MDIO is set to be a module the code block is not
compiled. Use the IS_ENABLED macro that checks for both built in as
well as module.

Fixes: 2a10154abcb75 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83867.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 4017ae1692d8..f3c04981b8da 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -488,7 +488,7 @@ static int dp83867_verify_rgmii_cfg(struct phy_device *phydev)
 	return 0;
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 static int dp83867_of_init(struct phy_device *phydev)
 {
 	struct dp83867_private *dp83867 = phydev->priv;
-- 
2.26.2

