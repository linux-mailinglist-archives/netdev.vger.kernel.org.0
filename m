Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C42CEE38
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgLDMhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:37:12 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:17122 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgLDMhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:37:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085430; x=1638621430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=g1J9PQBnIlV0iQX/uOV1x4ubZU85IwPi2qdU1ENP0lg=;
  b=j33Co4dQww8aAP48ZXkbcr6K2QreS3MVl+l9O+TJ+h92BLYNGtRwQvTy
   oxGQ0uK4PZieBGriYPP0iZ7+tdst92Att4Mokf/1Q+3F6JLvWoYAqFq9+
   U1XhFtLXtS6siFWBFuVPp272gF9faVMVanW7BQPi2EIHhK14ivN9ba0FE
   kTtEvdy/nYiCELhUoRi0uHps41BlUGtMC/ZXLqyZDz4cKwjYdkTCS5L7Q
   3aaDbR04m07ozXwmePxfn6x+jgDXcrn9WRulGdcIN69VRf8MTdHOH2N1Y
   SWUAxAq7R7sdATSKSxQDL821td5jKRf3ClecF4f/yFX0v0jYVH7sjnB/1
   w==;
IronPort-SDR: D2DUSi6LWDPa/lP7TKgXBQhoI/cowMjEzS/ZVxVNk+O1U5si6Nz6305FT8GJ2k2jdtDCsSx56p
 +pedqLfAEItdgwjDrQ8XMwoegq/W/rQo7FNgrn1gdQVEBsIA8QyZUwBnOEJkyEWD+P/82bXnDl
 3mbyoiv2035rn5KZFPhkWIWh0irCIy9aOUiKyFIrv2MkfAKesu+/+6o1xyaTNXR+0sG1ZhfJX7
 r16apTftoiagZfNTpKY3ArYGvzs7fhsnI3wav3t52adL+WZtBLMUpqln6+u0myEMzU/HMEZOce
 TIo=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="106188212"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:35:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:35:18 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:35:12 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 7/7] net: macb: add support for sama7g5 emac interface
Date:   Fri, 4 Dec 2020 14:34:21 +0200
Message-ID: <1607085261-25255-8-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SAMA7G5 10/100Mbps interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 22340e55d4b7..2e1f9b28e388 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4570,6 +4570,14 @@ static const struct macb_config sama7g5_gem_config = {
 	.usrio = &sama7g5_usrio,
 };
 
+static const struct macb_config sama7g5_emac_config = {
+	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_USRIO_HAS_CLKEN,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = macb_init,
+	.usrio = &sama7g5_usrio,
+};
+
 static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,at32ap7000-macb" },
 	{ .compatible = "cdns,at91sam9260-macb", .data = &at91sam9260_config },
@@ -4588,6 +4596,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
+	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.7.4

