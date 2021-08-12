Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC5C3E9FAC
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhHLHo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:44:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:33196 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhHLHo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 03:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628754271; x=1660290271;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=LR8LWE1CYZvg3jg13iK01DDmUkN7vvjsZ05D6kFuE2c=;
  b=nSr88czzact6X7+INpa6SGnUswWUP4U/rNmWnxiCEwu+nRCYwTq/TifY
   M066vECcwHIfADEzhN3ZB+iDPDHeDiOSGbeSyNRTzX/e0mSCmLQbtS4MW
   GoTaPIqKzkpzYZUFHKp9SJyUjrMJmGdg5knIogHZvxFF7lLWTbdc2FwA7
   PJrbpabEUB4bmkp58OrPjf5GvkfBT2cEY/sLSmjJlUFLoHGuSELWniEEt
   0APzZIE1bWD3mM+kGMso8Nh1RinWs9XTjyqABq/08IqpVnANb3KKVbK0J
   19RCXGziM/SoFPLsWXeIVGNCFKYlfZqsfhK5r9P2VaBWD4DcMi9PtcCu+
   A==;
IronPort-SDR: JR9/pWOEuAoC9x+PzmZbeGeGU9f25/AAKXPRjHw2Ctg4P4PXKCrYZqz39n7T+GVSlf7gD4DFuk
 RJ93ki3TYKS68R4UZUsSy51Y3j8Jy+ui2uxm6XCbXvtu2o4MAeh3GwsNye3f64s0stG2gGUZ+c
 iV+AlFfyCB6ZLrYRWkF9r6SA+ee7Nkde47zVjdFRVDBRxef1TPSScatthU9qBY7YfXQ4tCDoVN
 zmC0sdocUUsidsu86ZaGoXTQMCwHuNYMas0ga4t5uvW8JBuvKZ8fQ6L0zWivnp2peOxpSf2O7m
 3MysDY+1jcy5bs43nD5x4dt9
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="139788973"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2021 00:44:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 00:44:30 -0700
Received: from che-lt-i63539u.amer.actel.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 12 Aug 2021 00:44:25 -0700
From:   Hari Prasath <Hari.PrasathGE@microchip.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>,
        <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <mpuswlinux@microchip.com>, <Hari.PrasathGE@microchip.com>
Subject: [PATCH net-next 1/2] net: macb: Add PTP support for SAMA5D29
Date:   Thu, 12 Aug 2021 13:14:21 +0530
Message-ID: <20210812074422.13487-1-Hari.PrasathGE@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PTP capability to the macb config object for sama5d29.

Signed-off-by: Hari Prasath <Hari.PrasathGE@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 181ebc235925..d13fb1d31821 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4533,6 +4533,14 @@ static const struct macb_config sama5d2_config = {
 	.usrio = &macb_default_usrio,
 };
 
+static const struct macb_config sama5d29_config = {
+	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_GEM_HAS_PTP,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = macb_init,
+	.usrio = &macb_default_usrio,
+};
+
 static const struct macb_config sama5d3_config = {
 	.caps = MACB_CAPS_SG_DISABLED | MACB_CAPS_GIGABIT_MODE_AVAILABLE
 	      | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_JUMBO,
@@ -4610,6 +4618,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,gem", .data = &pc302gem_config },
 	{ .compatible = "cdns,sam9x60-macb", .data = &at91sam9260_config },
 	{ .compatible = "atmel,sama5d2-gem", .data = &sama5d2_config },
+	{ .compatible = "atmel,sama5d29-gem", .data = &sama5d29_config },
 	{ .compatible = "atmel,sama5d3-gem", .data = &sama5d3_config },
 	{ .compatible = "atmel,sama5d3-macb", .data = &sama5d3macb_config },
 	{ .compatible = "atmel,sama5d4-gem", .data = &sama5d4_config },
-- 
2.17.1

