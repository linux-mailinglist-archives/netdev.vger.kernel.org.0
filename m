Return-Path: <netdev+bounces-5056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CAD70F902
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1858C1C20C93
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5322E18AF6;
	Wed, 24 May 2023 14:45:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDC518C2F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:45:07 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F44186;
	Wed, 24 May 2023 07:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684939503; x=1716475503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+JnK+gMAWYL7Y9fDkARKbdhFSLltEAqTkqmdYXZbRxs=;
  b=EeUwLdvMVbfQNSB4tjDrICEQYLbTjVU0vrKJj6xVKoPTHG4KHPlqJbTk
   jPvm2t7nZxY/cALX4HaxSMklzGkhRqBSfmGcVgI1o2E1jMIJ0gSo7aj7S
   cWHU4+qzRK5K4Bi+HjBK68+JA0jFvjB4Nj10gfTPrDxNp6zE7qVzHE602
   +4BWpiTZ0csLs5uaNz9U4s7bMWsokkH9iYT/VJTS+VQzg2JCfRDqN+iPP
   5KNpy7/DCa3OAbqTFxROMgihhVuK+iQIEK1HwNLXOFJRuauwqjQgr2xjr
   KDQQfBVb03bBQhT6QXNy3aLdZS0G+ZcYCHG0YNq6ipe3kZ4kOw1yRD8zQ
   w==;
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="153726347"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 07:45:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 07:44:59 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 24 May 2023 07:44:54 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v3 5/6] net: phy: microchip_t1s: remove unnecessary interrupts disabling code
Date: Wed, 24 May 2023 20:15:38 +0530
Message-ID: <20230524144539.62618-6-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

By default, except Reset Complete interrupt in the Interrupt Mask 2
Register all other interrupts are disabled/masked. As Reset Complete
status is already handled, it doesn't make sense to disable it.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 05a88b561993..6f9e197d8623 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -12,8 +12,6 @@
 
 #define PHY_ID_LAN867X_REVB1 0x0007C162
 
-#define LAN867X_REG_IRQ_1_CTL 0x001C
-#define LAN867X_REG_IRQ_2_CTL 0x001D
 #define LAN867X_REG_STS2 0x0019
 
 #define LAN867x_RESET_COMPLETE_STS BIT(11)
@@ -106,17 +104,7 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
 			return err;
 	}
 
-	/* None of the interrupts in the lan867x phy seem relevant.
-	 * Other phys inspect the link status and call phy_trigger_machine
-	 * in the interrupt handler.
-	 * This phy does not support link status, and thus has no interrupt
-	 * for it either.
-	 * So we'll just disable all interrupts on the chip.
-	 */
-	err = phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_1_CTL, 0xFFFF);
-	if (err != 0)
-		return err;
-	return phy_write_mmd(phydev, MDIO_MMD_VEND2, LAN867X_REG_IRQ_2_CTL, 0xFFFF);
+	return 0;
 }
 
 static int lan867x_read_status(struct phy_device *phydev)
-- 
2.34.1


