Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802722D106A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgLGMRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:17:51 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39750 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgLGMRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343469; x=1638879469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=7c4o9HTAPU/FWDNBRxOIP9hZ2d9X8oAOdvZ31rPTtNA=;
  b=uNVy+iBIMa/xCIZfDOPT5gofwmUOfzhpvFWJg/+aOjj0HajEt3uqmC3E
   YcKOHf2io9tBDixPO4EmFdCqFxLy/JMANAHUD82TjICxSfAuemvertrHu
   88Z5InIWbOrWpLKxgGoBSMTygtRf0WgP4ZvLm2mTCyLhuJa/CvkHlQcVf
   xQiXe3hF8Npmkd9BikdpOul/HuAZo4HVrFWFyRegYl/wai4pxEm7ezX8d
   SpkVabvkgwpD8zN2BMt6DWXXcDF+YKx0+P+x+T+0EYGCbxeapfIPD1XzV
   Lfu8qBVx80aiB2OJ84wyQH5OPcmTgQACbxiqFkkHMeQvUI5oLYoCXxBoo
   Q==;
IronPort-SDR: JpSfP/AgQp80I2E07mROSc85GO+IM9hwMHoqsZw22CNZUSZa2rNq0wbldfGl20okQ6sKRVGJlH
 L8ic9lS44WkFgjY1jRzRmbTJZcL+MBOwvETWrXcLHviyJJ7Bhg8rO7WSZMvFl0zznu4sqVjDrh
 d4oMlrBUzPgluv4nzd7+GMgIMFSCa13Ly+nMkkbu1KEekqvzDai/YQt/kAE1WN475DXBIJ00in
 tBKdxDoZIeVVPwd+/jpBSz5srUkvomlpVvZjn2eJhsr4nBmxQFp99z8KJ4JePOLrjxENiwujr5
 oAw=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="106497590"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:16:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:16:43 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:16:37 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 8/8] net: macb: add support for sama7g5 emac interface
Date:   Mon, 7 Dec 2020 14:15:33 +0200
Message-ID: <1607343333-26552-9-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for SAMA7G5 10/100Mbps interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ca56476b3a04..bb280c55c4b3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4574,6 +4574,14 @@ static const struct macb_config sama7g5_gem_config = {
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
@@ -4592,6 +4600,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
+	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.7.4

