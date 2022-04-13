Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87BD4FF069
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiDMHRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiDMHQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:16:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407EE29829;
        Wed, 13 Apr 2022 00:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649834079; x=1681370079;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Mb5sTyKPIpaCpRuYb3xPgCASWTnlSQ2irNU2fo4JGwg=;
  b=DVj2lR4xrkrrQP36QXGWlL9IWLRgoGjmii24vWwv1aS2fGu10aUJ0ZqR
   7oexm/9VUEv5L/q4jhCgazqH3nnjE58GJxrNctdRO54Quncr3defm9kwz
   b1m2miWpnf6fqEC4ZdIeN+zYd0zDtKlOOZoJfk1E4o2f+Ufq9yYA4fLhH
   59dMGlo4yU8Ek1Bk5SakcMwUCE6w2w8u/rsPe7WhBA6iwvLyvaV+e3Kh5
   C/Ia5SeXT32pGXGYmbtYqsXOCuvzGGZoJDtUrXb8CxLvo6DfwFFHtZ7NT
   ApJ+omaCF3JUOFRqUPhQHyxXGQUvlWDPfxJAwajtglYMggTY7f6jUbbjG
   g==;
X-IronPort-AV: E=Sophos;i="5.90,256,1643698800"; 
   d="scan'208";a="152485273"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2022 00:14:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 13 Apr 2022 00:14:37 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 13 Apr 2022 00:14:34 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Russell King" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>
Subject: [Patch net] net: phy: LAN937x: added PHY_POLL_CABLE_TEST flag
Date:   Wed, 13 Apr 2022 12:44:09 +0530
Message-ID: <20220413071409.13530-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
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

Added the phy_poll_cable_test flag for the lan937x phy driver.
Tested using command -  ethtool --cable-test <dev>

Fixes: 680baca546f2 ("net: phy: added the LAN937x phy support")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/microchip_t1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 389df3f4293c..363bfbfa182b 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -748,6 +748,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_LAN937X),
 		.name		= "Microchip LAN937x T1",
+		.flags          = PHY_POLL_CABLE_TEST,
 		.features	= PHY_BASIC_T1_FEATURES,
 		.config_init	= lan87xx_config_init,
 		.suspend	= genphy_suspend,

base-commit: f45ba67eb74ab4b775616af731bdf8944afce3f1
-- 
2.33.0

