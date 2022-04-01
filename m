Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C434EEBF7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345315AbiDALEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345314AbiDALEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:04:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF2F2706C4;
        Fri,  1 Apr 2022 04:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648810975; x=1680346975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iQO9f8iaENIV19XBT+seKvipVsM/1nu/lvqiaWsIUus=;
  b=s45eiVSDw4JEOknXnf6TZcNTaF8qgM8UuvXeIZWTLn+GssNGAaX1C8iU
   r55WEOWtjdvli12q0uYBQmhz+FYMK0mfu6sSRu3EyBvBd6ogXSbicS6Ex
   1AZX602N0m6SjRpD+wfjq0NjQnK60mXOm0Lx3tmj4HwPKodvs1DV2QxWi
   v2TXEQ18nvLMDFIt7Z96SubcspWdkcNcSChBTmyxicn/aAAROFxDPoAJm
   5PUURhx6FkeWrVt01jbirOpmdhx2+qdPGhRfAE+qgIk/gnceV7zHXsbJZ
   Sc7Jt11xW85PIvXLB26mJKF0vSQLTn0mJeV62wTyJKwJt/ZqO3b2+p/R+
   w==;
X-IronPort-AV: E=Sophos;i="5.90,227,1643698800"; 
   d="scan'208";a="158520209"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2022 04:02:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Apr 2022 04:02:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Apr 2022 04:02:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <Divya.Koppera@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 3/3] net: phy: micrel: Remove DT option lan8814,ignore-ts
Date:   Fri, 1 Apr 2022 13:05:22 +0200
Message-ID: <20220401110522.3418258-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the PHY and the MAC are capable of doing timestamping, the PHY has
priority. Therefore the DT option lan8814,ignore-ts was added such that
the PHY will not expose a PHC so then the timestamping was done in the
MAC. This is not the correct approach of doing it, therefore remove
this.

Fixes: ece19502834d84 ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a873df07ad24..fc53b71dc872 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2616,7 +2616,6 @@ static int lan8814_config_init(struct phy_device *phydev)
 
 static int lan8814_probe(struct phy_device *phydev)
 {
-	const struct device_node *np = phydev->mdio.dev.of_node;
 	struct kszphy_priv *priv;
 	u16 addr;
 	int err;
@@ -2630,8 +2629,7 @@ static int lan8814_probe(struct phy_device *phydev)
 	phydev->priv = priv;
 
 	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
-	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING) ||
-	    of_property_read_bool(np, "lan8814,ignore-ts"))
+	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
 		return 0;
 
 	/* Strap-in value for PHY address, below register read gives starting
-- 
2.33.0

