Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB0279E1A
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 06:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgI0Ed4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 00:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgI0Ed4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 00:33:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1E0C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 21:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=AHmTfFc14u0+4dfTY7AVuIbWTYomcjz+rbGnGjXoNCI=; b=DUjixyV8xUvg1udS9dCKRaXNgC
        fuECTSec58LpiM3c/lu3KlU7X6AtVOMlsfaqkVTQR973XXX9fLaCoNPGJHhXvYN1dKGXOnmHOpZKi
        2GFqzosYUj/KGZ/+He5Na5yfqCNSLOktF26S5XkVAlf0jCUPaIa+YVF8ADcCHsjkiSPV8nbUZliPb
        1NhazTNpwk+mFXQZpV9GnVzfyfNedzQ2oEAx0ngPtdtRBy3+mJgnWt5qS98BDvo6qMNNucj51Punn
        3WFpSJvVvPOL5NeNjHsQWzl5oNd67gHbwD0w1i3zEF+ScB5Qs6Qkn//bubcRd8/0FcbJQtQYssAal
        oulFp4Fw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMONe-0000eb-GS; Sun, 27 Sep 2020 04:33:46 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Daney <david.daney@cavium.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] mdio: fix mdio-thunder.c dependency & build error
Message-ID: <5aecbd3f-a489-0738-8249-5e08a6f2766f@infradead.org>
Date:   Sat, 26 Sep 2020 21:33:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error by selecting MDIO_DEVRES for MDIO_THUNDER.
Fixes this build error:

ld: drivers/net/phy/mdio-thunder.o: in function `thunder_mdiobus_pci_probe':
drivers/net/phy/mdio-thunder.c:78: undefined reference to `devm_mdiobus_alloc_size'

Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
---
or applies to drivers/net/phy/Kconfig in mainline (or stable) # v4.6

 drivers/net/mdio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20200925.orig/drivers/net/mdio/Kconfig
+++ linux-next-20200925/drivers/net/mdio/Kconfig
@@ -164,6 +164,7 @@ config MDIO_THUNDER
 	depends on 64BIT
 	depends on PCI
 	select MDIO_CAVIUM
+	select MDIO_DEVRES
 	help
 	  This driver supports the MDIO interfaces found on Cavium
 	  ThunderX SoCs when the MDIO bus device appears as a PCI


