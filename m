Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38492D42B9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbgLINGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:06:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:57523 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732115AbgLINGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:06:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607519160; x=1639055160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ZvYFBB8ivPG0I/9gZKADhoJJmyIbdT5JdB9YJlFilKY=;
  b=Hx4I4gl3pfoyImpf3dIOtmR6rndM3lmVIUjPwUVrg98l7Uq2a0G6ZQmD
   P/GptMkdusTrzifK6K5FhakAysHshhSYr2wE/GU4NbpEuetcOPcn8/q0c
   6ypwGFFjQKxQWjBQWUkEn0mYYPwCCcvoADFEHme0JfCf3sQZaOFs+IcFe
   PgzJK23+0DqOvm/G1jU8oWITag2/ar1B5UKYmwXGvQXcZf0TsIqXBzxN0
   wbQI79+5bPOXTtl3cpu4FfwBP3b7AQAUwN4ovrZO2BkiwwdGiY1tymhsM
   6IZSrf3mBWX7FULa5il0O1K1R/pvGjrkqJbST+uS2nROKeJKThbdn5QH0
   Q==;
IronPort-SDR: ehnk1o90Rn984rGliBSnqW0a98J3fMIDnclBEqmLXT2eQExp371dB3fidwu+IHzECHmLCJSe9m
 L51hIVe7eK2adsFS+CfOkaDNOigA7mCRgylfJQU6zQZMqWJD4cAMztHC+VW6vR7/z1dwNh0ppQ
 qLU6Hwd6RLl0GzkKx0gKkJstDLkZCDkKEfCmaRsW6JVMODaqgSDWLjMYU09aSHUcPVkAbSXkQI
 /2Hk2VKhoIX2mj/PjHLhTRhzwPEVrWkdbTo8g1PCkwCESZM3TALpQrngIUM57nsj5zZsS9dN2w
 238=
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="102102729"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2020 06:04:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 06:04:34 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 9 Dec 2020 06:04:28 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 8/8] net: macb: add support for sama7g5 emac interface
Date:   Wed, 9 Dec 2020 15:03:39 +0200
Message-ID: <1607519019-19103-9-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
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
index 5bae44931282..995a13489276 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4581,6 +4581,14 @@ static const struct macb_config sama7g5_gem_config = {
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
@@ -4599,6 +4607,7 @@ static const struct of_device_id macb_dt_ids[] = {
 	{ .compatible = "cdns,zynq-gem", .data = &zynq_config },
 	{ .compatible = "sifive,fu540-c000-gem", .data = &fu540_c000_config },
 	{ .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
+	{ .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
-- 
2.7.4

