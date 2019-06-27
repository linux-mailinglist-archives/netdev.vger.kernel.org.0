Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DC5577CE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfF0Ahi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbfF0Ahh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:37 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2FC2080C;
        Thu, 27 Jun 2019 00:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595856;
        bh=5uOb5z/Q++skOYyyLr5o4TsinA66r+bFRq+Giiuvkgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQmhLny0XHs/74p7I9xsl06Qf/0XFmOGQJRruMNGh6HYSOuhN9vkrQisjpOya5KX9
         3ZuutkF0MV1a9Z0a3z9acp6Fi990zJvdXCvJS+wkNJbSFTFiNKagoNFCW7qvyxFhz1
         Nk3Qm8fOmsHXn01NCwju7cWCSrRMkeddTieaHPBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/60] net: phy: rename Asix Electronics PHY driver
Date:   Wed, 26 Jun 2019 20:35:40 -0400
Message-Id: <20190627003616.20767-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

[ Upstream commit a9520543b123bbd7275a0ab8d0375a5412683b41 ]

[Resent to net instead of net-next - may clash with Anders Roxell's patch
series addressing duplicate module names]

Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
introduced a new PHY driver drivers/net/phy/asix.c that causes a module
name conflict with a pre-existiting driver (drivers/net/usb/asix.c).

The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
by that driver via its PHY ID. A rename of the driver looks unproblematic.

Rename PHY driver to ax88796b.c in order to resolve name conflict.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/Kconfig      | 2 +-
 drivers/net/phy/Kconfig                | 2 +-
 drivers/net/phy/Makefile               | 2 +-
 drivers/net/phy/{asix.c => ax88796b.c} | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename drivers/net/phy/{asix.c => ax88796b.c} (100%)

diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index f2f0264c58ba..443b34e2725f 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -49,7 +49,7 @@ config XSURF100
 	tristate "Amiga XSurf 100 AX88796/NE2000 clone support"
 	depends on ZORRO
 	select AX88796
-	select ASIX_PHY
+	select AX88796B_PHY
 	help
 	  This driver is for the Individual Computers X-Surf 100 Ethernet
 	  card (based on the Asix AX88796 chip). If you have such a card,
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 82070792edbb..1f5fd24cd749 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -227,7 +227,7 @@ config AQUANTIA_PHY
 	---help---
 	  Currently supports the Aquantia AQ1202, AQ2104, AQR105, AQR405
 
-config ASIX_PHY
+config AX88796B_PHY
 	tristate "Asix PHYs"
 	help
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 5805c0b7d60e..f21cda9d865e 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -46,7 +46,7 @@ obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
 
 obj-$(CONFIG_AMD_PHY)		+= amd.o
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_ASIX_PHY)		+= asix.o
+obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
diff --git a/drivers/net/phy/asix.c b/drivers/net/phy/ax88796b.c
similarity index 100%
rename from drivers/net/phy/asix.c
rename to drivers/net/phy/ax88796b.c
-- 
2.20.1

