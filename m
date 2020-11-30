Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A62C81F4
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgK3KRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgK3KRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:17:43 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1C4C0613CF;
        Mon, 30 Nov 2020 02:16:57 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id e8so10105081pfh.2;
        Mon, 30 Nov 2020 02:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3xMjSgPQz6CGAoleFFXqRYTZJcd26r+56+BnmttwkJA=;
        b=bY586ArA+mA+U0ZmXqHCEx4MyovGLeW12+APm0ujqisZFufAhK4J/6/PvmtbJmVVfB
         It0IpTt4bRn/qPH4ggKS2ZVBEJxsjXLQXGbvoTY4pZCmTTAkPg1tPOwu0onWhhwpkpnU
         hnhJse8B3nVGV252/ECWxS7x+pDUbwSnNcOt5048NzdJCxx/QzobHM538S2g7AcX9YW/
         hoAX/UgYGdPUHWj4w3rUpCXBT4JutaDjiTFbir1RTcEsrWtbcFTjfVFnH/JjWGnQZpnV
         GJ0Yy0vkENHEJ5rTomR8aOHZhyL5l6uq3nsAG+6/w/LFWvCNDtPGLWp5UpppsY7o+MTf
         YULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3xMjSgPQz6CGAoleFFXqRYTZJcd26r+56+BnmttwkJA=;
        b=Hk5lQQSJUHT7cWmIM09Kqp09xq1z+OKemWTfyrFVs+iiruFO/z0jZF6b/VSMgvzgG4
         U1pGcZK048Jt1bv2stmJtQlzXcSZkjPa6HDxYu8TGNzeCzRfHQjQUjrFDQii2+Oh2Wiq
         5x37een2DXCUZp7b9VSwdLaqf7NDdU6WpOtclbctqW5y5xks81XMxUgtGr7LGRZM/wkV
         426Hv1depxs3R9G2cxG7Hz0kz449ZfsQ2pPRdtNAtQh/YHUolH7wWbrAjCLdE+zv5keO
         4zPpVQPEqEW5aeurFVcUAS+Hl5b9orjyOehPOJetb32TuiP3crXYmEHour1lb5sMUJMp
         K7Vw==
X-Gm-Message-State: AOAM531fIXGmofdY/tl20PLhnOfH0ocAUBhIpXK7HEPi7Y5WzO+c/PiB
        yOFdp4qo2RXG03O5TbYqko2q9QIfXKA=
X-Google-Smtp-Source: ABdhPJy5LHfubxqXIf8BJ5d+6YUrmhp8bzdYId5x3dh2JxT9NAxYJY2OIpjSORXsHXDcUMKhgFhBNw==
X-Received: by 2002:a65:6404:: with SMTP id a4mr5874447pgv.2.1606731417209;
        Mon, 30 Nov 2020 02:16:57 -0800 (PST)
Received: from localhost.localdomain ([8.210.202.142])
        by smtp.gmail.com with ESMTPSA id 10sm11964739pjt.35.2020.11.30.02.16.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 02:16:56 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net: phy: marvell: replace __phy_modify()
Date:   Mon, 30 Nov 2020 18:16:39 +0800
Message-Id: <1606731399-8772-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a set of phy_set_bits() looks more neater

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 drivers/net/phy/marvell.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 587930a..f402e7f 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1132,8 +1132,8 @@ static int m88e1510_config_init(struct phy_device *phydev)
 			return err;
 
 		/* PHY reset is necessary after changing MODE[2:0] */
-		err = phy_modify(phydev, MII_88E1510_GEN_CTRL_REG_1, 0,
-				 MII_88E1510_GEN_CTRL_REG_1_RESET);
+		err = phy_set_bits(phydev, MII_88E1510_GEN_CTRL_REG_1,
+				   MII_88E1510_GEN_CTRL_REG_1_RESET);
 		if (err < 0)
 			return err;
 
@@ -1725,7 +1725,7 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			__phy_read(phydev, MII_M1011_IEVENT);
 
 		/* Enable the WOL interrupt */
-		err = __phy_modify(phydev, MII_88E1318S_PHY_CSIER, 0,
+		err = phy_set_bits(phydev, MII_88E1318S_PHY_CSIER,
 				   MII_88E1318S_PHY_CSIER_WOL_EIE);
 		if (err < 0)
 			goto error;
@@ -1735,10 +1735,10 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			goto error;
 
 		/* Setup LED[2] as interrupt pin (active low) */
-		err = __phy_modify(phydev, MII_88E1318S_PHY_LED_TCR,
-				   MII_88E1318S_PHY_LED_TCR_FORCE_INT,
-				   MII_88E1318S_PHY_LED_TCR_INTn_ENABLE |
-				   MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW);
+		err = phy_modify(phydev, MII_88E1318S_PHY_LED_TCR,
+				 MII_88E1318S_PHY_LED_TCR_FORCE_INT,
+				 MII_88E1318S_PHY_LED_TCR_INTn_ENABLE |
+				 MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW);
 		if (err < 0)
 			goto error;
 
@@ -1764,7 +1764,7 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			goto error;
 
 		/* Clear WOL status and enable magic packet matching */
-		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL, 0,
+		err = phy_set_bits(phydev, MII_88E1318S_PHY_WOL_CTRL,
 				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS |
 				   MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE);
 		if (err < 0)
@@ -1775,9 +1775,9 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			goto error;
 
 		/* Clear WOL status and disable magic packet matching */
-		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL,
-				   MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE,
-				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS);
+		err = phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL,
+				 MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE,
+				 MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS);
 		if (err < 0)
 			goto error;
 	}
@@ -1995,7 +1995,7 @@ static int marvell_cable_test_start_common(struct phy_device *phydev)
 		return bmsr;
 
 	if (bmcr & BMCR_ANENABLE) {
-		ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+		ret =  phy_clear_bits(phydev, MII_BMCR, BMCR_ANENABLE);
 		if (ret < 0)
 			return ret;
 		ret = genphy_soft_reset(phydev);
-- 
1.9.1

