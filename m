Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD64631BD
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbhK3LFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:05:44 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:35579 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236684AbhK3LFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:05:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=dtcccc@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UysYt4a_1638270135;
Received: from localhost.localdomain(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0UysYt4a_1638270135)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 30 Nov 2021 19:02:23 +0800
From:   Tianchen Ding <dtcccc@linux.alibaba.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: [PATCH] net: mdio: mscc-miim: Add depend of REGMAP_MMIO on MDIO_MSCC_MIIM
Date:   Tue, 30 Nov 2021 19:02:09 +0800
Message-Id: <20211130110209.804536-1-dtcccc@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's build error while CONFIG_REGMAP_MMIO is not set
and CONFIG_MDIO_MSCC_MIIM=m.

ERROR: modpost: "__devm_regmap_init_mmio_clk"
[drivers/net/mdio/mdio-mscc-miim.ko] undefined!

Add the depend of REGMAP_MMIO to fix it.

Fixes: a27a76282837 ("net: mdio: mscc-miim: convert to a regmap implementation")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
---
 drivers/net/mdio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 6da1fcb25847..bfa16826a6e1 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -141,7 +141,7 @@ config MDIO_MVUSB
 
 config MDIO_MSCC_MIIM
 	tristate "Microsemi MIIM interface support"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && REGMAP_MMIO
 	select MDIO_DEVRES
 	help
 	  This driver supports the MIIM (MDIO) interface found in the network
-- 
2.27.0

