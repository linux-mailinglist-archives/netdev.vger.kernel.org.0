Return-Path: <netdev+bounces-5028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B54A670F759
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B35E1C20BB5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21DFC182C7;
	Wed, 24 May 2023 13:08:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D98C2E4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:08:25 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3116611D;
	Wed, 24 May 2023 06:08:22 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 8319CFF81B;
	Wed, 24 May 2023 13:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4D5lsCQdMV5bn+ConuzmhAuf/2BinjGQGLYdd0T0GGc=;
	b=DcfnsAUiMBd0WPx1kYTJiaRqypl607ONJGdZNgrApIjSZRc6PSYVxik1EPY7w/mViExJkC
	gGlF8hjtdOze8KOsg2RLaMErFlgy9uASifzCm9bP4FAso+8Z3rG1/BP0tMkdiIizUQHG4Q
	YEZ8Jppoy5KJ6AguvmA/A4YJMOHnPsoGey9vgU8jLRNcpyMog6KSXk/SFuSJZXyj+6wOt/
	da7dUsaYvTsUDxjT3OypDuH8uZSCUdyTltILb3LMvfFkLX8tOrq5XtF/i6gRRVQ7Dt+yZs
	6YZ9Q8XeSqIZKVyCkrhFttNYsg2kBDV6D8i5LAc8h/l3n3UKp3Rb35MTpwktAQ==
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Mark Brown <broonie@kernel.org>,
	davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH net-next 3/4] net: pcs: Drop the TSE PCS driver
Date: Wed, 24 May 2023 15:08:06 +0200
Message-Id: <20230524130807.310089-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
References: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now that we can easily create a mdio-device that represents a
memory-mapped device that exposes an MDIO-like register layout, we don't
need the Altera TSE PCS anymore, since we can use the Lynx PCS instead.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 MAINTAINERS                      |   7 --
 drivers/net/pcs/Kconfig          |   6 --
 drivers/net/pcs/Makefile         |   1 -
 drivers/net/pcs/pcs-altera-tse.c | 160 -------------------------------
 include/linux/pcs-altera-tse.h   |  17 ----
 5 files changed, 191 deletions(-)
 delete mode 100644 drivers/net/pcs/pcs-altera-tse.c
 delete mode 100644 include/linux/pcs-altera-tse.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ef8362aa93b3..629f18fcac42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -909,13 +909,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/altera/
 
-ALTERA TSE PCS
-M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	drivers/net/pcs/pcs-altera-tse.c
-F:	include/linux/pcs-altera-tse.h
-
 ALTERA UART/JTAG UART SERIAL DRIVERS
 M:	Tobias Klauser <tklauser@distanz.ch>
 L:	linux-serial@vger.kernel.org
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 7c34fb7cbf7b..87cf308fc6d8 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -33,10 +33,4 @@ config PCS_RZN1_MIIC
 	  on RZ/N1 SoCs. This PCS converts MII to RMII/RGMII or can be set in
 	  pass-through mode for MII.
 
-config PCS_ALTERA_TSE
-	tristate
-	help
-	  This module provides helper functions for the Altera Triple Speed
-	  Ethernet SGMII PCS, that can be found on the Intel Socfpga family.
-
 endmenu
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 9b9afd6b1c22..ea662a7989b2 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -7,4 +7,3 @@ obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
 obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
 obj-$(CONFIG_PCS_MTK_LYNXI)	+= pcs-mtk-lynxi.o
 obj-$(CONFIG_PCS_RZN1_MIIC)	+= pcs-rzn1-miic.o
-obj-$(CONFIG_PCS_ALTERA_TSE)	+= pcs-altera-tse.o
diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
deleted file mode 100644
index d616749761f4..000000000000
--- a/drivers/net/pcs/pcs-altera-tse.c
+++ /dev/null
@@ -1,160 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (C) 2022 Bootlin
- *
- * Maxime Chevallier <maxime.chevallier@bootlin.com>
- */
-
-#include <linux/netdevice.h>
-#include <linux/phy.h>
-#include <linux/phylink.h>
-#include <linux/pcs-altera-tse.h>
-
-/* SGMII PCS register addresses
- */
-#define SGMII_PCS_LINK_TIMER_0	0x12
-#define SGMII_PCS_LINK_TIMER_1	0x13
-#define SGMII_PCS_IF_MODE	0x14
-#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
-#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
-#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
-#define   PCS_IF_MODE_SGMI_PHY_AN	BIT(5)
-#define SGMII_PCS_SW_RESET_TIMEOUT 100 /* usecs */
-
-struct altera_tse_pcs {
-	struct phylink_pcs pcs;
-	void __iomem *base;
-	int reg_width;
-};
-
-static struct altera_tse_pcs *phylink_pcs_to_tse_pcs(struct phylink_pcs *pcs)
-{
-	return container_of(pcs, struct altera_tse_pcs, pcs);
-}
-
-static u16 tse_pcs_read(struct altera_tse_pcs *tse_pcs, int regnum)
-{
-	if (tse_pcs->reg_width == 4)
-		return readl(tse_pcs->base + regnum * 4);
-	else
-		return readw(tse_pcs->base + regnum * 2);
-}
-
-static void tse_pcs_write(struct altera_tse_pcs *tse_pcs, int regnum,
-			  u16 value)
-{
-	if (tse_pcs->reg_width == 4)
-		writel(value, tse_pcs->base + regnum * 4);
-	else
-		writew(value, tse_pcs->base + regnum * 2);
-}
-
-static int tse_pcs_reset(struct altera_tse_pcs *tse_pcs)
-{
-	u16 bmcr;
-
-	/* Reset PCS block */
-	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
-	bmcr |= BMCR_RESET;
-	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
-
-	return read_poll_timeout(tse_pcs_read, bmcr, (bmcr & BMCR_RESET),
-				 10, SGMII_PCS_SW_RESET_TIMEOUT, 1,
-				 tse_pcs, MII_BMCR);
-}
-
-static int alt_tse_pcs_validate(struct phylink_pcs *pcs,
-				unsigned long *supported,
-				const struct phylink_link_state *state)
-{
-	if (state->interface == PHY_INTERFACE_MODE_SGMII ||
-	    state->interface == PHY_INTERFACE_MODE_1000BASEX)
-		return 1;
-
-	return -EINVAL;
-}
-
-static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
-			      phy_interface_t interface,
-			      const unsigned long *advertising,
-			      bool permit_pause_to_mac)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u32 ctrl, if_mode;
-
-	ctrl = tse_pcs_read(tse_pcs, MII_BMCR);
-	if_mode = tse_pcs_read(tse_pcs, SGMII_PCS_IF_MODE);
-
-	/* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
-	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_0, 0x0D40);
-	tse_pcs_write(tse_pcs, SGMII_PCS_LINK_TIMER_1, 0x03);
-
-	if (interface == PHY_INTERFACE_MODE_SGMII) {
-		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
-	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
-		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
-	}
-
-	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
-
-	tse_pcs_write(tse_pcs, MII_BMCR, ctrl);
-	tse_pcs_write(tse_pcs, SGMII_PCS_IF_MODE, if_mode);
-
-	return tse_pcs_reset(tse_pcs);
-}
-
-static void alt_tse_pcs_get_state(struct phylink_pcs *pcs,
-				  struct phylink_link_state *state)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u16 bmsr, lpa;
-
-	bmsr = tse_pcs_read(tse_pcs, MII_BMSR);
-	lpa = tse_pcs_read(tse_pcs, MII_LPA);
-
-	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
-}
-
-static void alt_tse_pcs_an_restart(struct phylink_pcs *pcs)
-{
-	struct altera_tse_pcs *tse_pcs = phylink_pcs_to_tse_pcs(pcs);
-	u16 bmcr;
-
-	bmcr = tse_pcs_read(tse_pcs, MII_BMCR);
-	bmcr |= BMCR_ANRESTART;
-	tse_pcs_write(tse_pcs, MII_BMCR, bmcr);
-
-	/* This PCS seems to require a soft reset to re-sync the AN logic */
-	tse_pcs_reset(tse_pcs);
-}
-
-static const struct phylink_pcs_ops alt_tse_pcs_ops = {
-	.pcs_validate = alt_tse_pcs_validate,
-	.pcs_get_state = alt_tse_pcs_get_state,
-	.pcs_config = alt_tse_pcs_config,
-	.pcs_an_restart = alt_tse_pcs_an_restart,
-};
-
-struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
-				       void __iomem *pcs_base, int reg_width)
-{
-	struct altera_tse_pcs *tse_pcs;
-
-	if (reg_width != 4 && reg_width != 2)
-		return ERR_PTR(-EINVAL);
-
-	tse_pcs = devm_kzalloc(&ndev->dev, sizeof(*tse_pcs), GFP_KERNEL);
-	if (!tse_pcs)
-		return ERR_PTR(-ENOMEM);
-
-	tse_pcs->pcs.ops = &alt_tse_pcs_ops;
-	tse_pcs->base = pcs_base;
-	tse_pcs->reg_width = reg_width;
-
-	return &tse_pcs->pcs;
-}
-EXPORT_SYMBOL_GPL(alt_tse_pcs_create);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Altera TSE PCS driver");
-MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
diff --git a/include/linux/pcs-altera-tse.h b/include/linux/pcs-altera-tse.h
deleted file mode 100644
index 92ab9f08e835..000000000000
--- a/include/linux/pcs-altera-tse.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2022 Bootlin
- *
- * Maxime Chevallier <maxime.chevallier@bootlin.com>
- */
-
-#ifndef __LINUX_PCS_ALTERA_TSE_H
-#define __LINUX_PCS_ALTERA_TSE_H
-
-struct phylink_pcs;
-struct net_device;
-
-struct phylink_pcs *alt_tse_pcs_create(struct net_device *ndev,
-				       void __iomem *pcs_base, int reg_width);
-
-#endif /* __LINUX_PCS_ALTERA_TSE_H */
-- 
2.40.1


