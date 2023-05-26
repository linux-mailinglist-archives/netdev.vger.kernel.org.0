Return-Path: <netdev+bounces-5732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7EC712957
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 422161C210AF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC79271ED;
	Fri, 26 May 2023 15:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CCF848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:23:12 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03553187;
	Fri, 26 May 2023 08:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685114589; x=1716650589;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qrgla/+2XOvTx0c45l7lux957CyaIb6rgNHr3CTEZUM=;
  b=dhTDAP9/YjQ+PeRmC9tUaBfZfVJh6AHAkss1dDWby8fmBzQOGtjY/MAb
   /mgdHeDj4VGkZ8V3DaweaM8LRQSqV86WIW/tHbMi9vdREwOojxEa5wITL
   /3KtN5lThHLJ/sNTjLRY4eWwexNFTD7S3zwg5Hs3X/q4ortTfwgGLD+03
   VnsXWPtLppFJOEeGEyih1OLgYsGGvftmhuX69wuM9CkEaoEKO7gzz5YLR
   OXhMGRXbIKa0GQYda4UH9yi+slXlhPSnAZJBA9ZJgDlTLjXU2lrMJvR6l
   Wg/yxtBkxSwZUJLwyF1SrP3KCVVycOIcwkp2V/YusrPgHfzqeBaxHCJ/5
   A==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="154119493"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 08:23:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 08:23:07 -0700
Received: from CHE-LT-I17164LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 26 May 2023 08:23:03 -0700
From: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>
CC: <horatiu.vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
	"Parthiban Veerasooran" <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next v4 5/6] net: phy: microchip_t1s: remove unnecessary interrupts disabling code
Date: Fri, 26 May 2023 20:53:47 +0530
Message-ID: <20230526152348.70781-6-Parthiban.Veerasooran@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

By default, except Reset Complete interrupt in the Interrupt Mask 2
Register all other interrupts are disabled/masked. As Reset Complete
status is already handled, it doesn't make sense to disable it.

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Tested-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
---
 drivers/net/phy/microchip_t1s.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/phy/microchip_t1s.c b/drivers/net/phy/microchip_t1s.c
index 0ecef87e5882..bcfcec56a6c7 100644
--- a/drivers/net/phy/microchip_t1s.c
+++ b/drivers/net/phy/microchip_t1s.c
@@ -12,8 +12,6 @@
 
 #define PHY_ID_LAN867X_REVB1 0x0007C162
 
-#define LAN867X_REG_IRQ_1_CTL 0x001C
-#define LAN867X_REG_IRQ_2_CTL 0x001D
 #define LAN867X_REG_STS2 0x0019
 
 #define LAN867x_RESET_COMPLETE_STS BIT(11)
@@ -89,17 +87,7 @@ static int lan867x_revb1_config_init(struct phy_device *phydev)
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


