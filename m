Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7762C767C
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbgK1WzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 17:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgK1WzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 17:55:19 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64979C0613D4;
        Sat, 28 Nov 2020 14:54:39 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 64so9767749wra.11;
        Sat, 28 Nov 2020 14:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+hA6KnCpaVRYBYlmVzT05cPi3Z+v4s6dEdVUnk8Iwns=;
        b=Q0IkrstgoTVsCos1T41nWGErgb54PIxXqqJ8y4HAUTQT+6zk4SLXJX9fOhLaZhaw0Z
         7ywF6hcetO0yNhvhFg65dFmK9fl9EsQzBpAXCiqIQ9V0XSC6sA0HN48ChAtbz0WovLGc
         f6q/RWyAi/bx8/FKacTz4T1w0geZDGdO7MuPq68+mEXpYhoD/hEyu336+dn7WrwNJEnD
         GX9ci424WktGwQAq2JER/rJTe35HoGNZED4z6XVw2eMoaE8mmzLJ86YLI/je6OsLRPy+
         sWj5BmVooUvB9qhgu2xD34AEmJ0MVI8PjDuzve589MnDcsmfGBmgk7C/xj819w63gMT+
         5T3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+hA6KnCpaVRYBYlmVzT05cPi3Z+v4s6dEdVUnk8Iwns=;
        b=R0Ph2woEttebW9h/IOUjtqZv3OsPSGYw5cpkQr9JS9CPjdRBMZjkpSSMWRmtbHX5aH
         q9VK8nxw/jpHNahR3qDlfDDBtTPAR3NwEDkNveEynKBKw/7MONowuFPCrW9dPwT+uXcZ
         Y5Lk5ihJz5Wlf9EukTC+4cRMgJbQy04ZppVkGvDRDofxOzpXHGx53AOMe7rGpYd3Jj0x
         6Caz54sVP5oZfiiEEnxTscTCpCj5Y54S258/eD8swP3lw6eLBFAR0uiv+Qjs4mIn9dyl
         T1gcm7E++9S5Ab2ORTyBdcQDtfYejl4Ng4CHTtPB24AqWTiuy3RUVq2Kq1HDdkjbKruL
         UoJg==
X-Gm-Message-State: AOAM532+PF13r3pRxV1Qo8DCYnNLFuFHsfEXXDe/5rAtEA6P8MJ2jgdI
        +adXqvIH045V65E6DAzDIZI=
X-Google-Smtp-Source: ABdhPJwAN1gb9XhYo7FDh0QLdRDPzVgnoEoZTywB3TVXd2H3+lP2G9LXKdi5XO/fkK/1Pjd0zOFoYA==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr19323582wrx.240.1606604078187;
        Sat, 28 Nov 2020 14:54:38 -0800 (PST)
Received: from adgra-XPS-15-9570.home (lfbn-idf1-1-1007-144.w86-238.abo.wanadoo.fr. [86.238.83.144])
        by smtp.gmail.com with ESMTPSA id d13sm24231506wrb.39.2020.11.28.14.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 14:54:37 -0800 (PST)
From:   Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrien Grassein <adrien.grassein@gmail.com>
Subject: [PATCH 2/3] net: fsl: fec: add mdc/mdio bitbang option
Date:   Sat, 28 Nov 2020 23:54:24 +0100
Message-Id: <20201128225425.19300-2-adrien.grassein@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201128225425.19300-1-adrien.grassein@gmail.com>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the ability for the fec to use the
mdc/mdio bitbang protocol to communicate with its phy.

It adds two new optional parameters in the
devicetree definition for the two needed GPIO (mdc and mdio).

It uses the mdio-bitbang generic implementation.

Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
---
 drivers/net/ethernet/freescale/fec.h      |  5 ++
 drivers/net/ethernet/freescale/fec_main.c | 91 ++++++++++++++++++++---
 2 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index c527f4ee1d3a..84bf9be4c6f5 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -15,6 +15,7 @@
 /****************************************************************************/
 
 #include <linux/clocksource.h>
+#include <linux/mdio-bitbang.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
@@ -590,6 +591,10 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+	struct mdiobb_ctrl fec_main_bb_ctrl;
+	struct gpio_desc *gd_mdc;
+	struct gpio_desc *gd_mdio;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 04f24c66cf36..e5c0a5da9965 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2050,6 +2050,48 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	return 0;
 }
 
+static void fec_main_bb_ctrl_set_mdc(struct mdiobb_ctrl *ctrl, int level)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	if (level)
+		gpiod_direction_input(fep->gd_mdc);
+	else
+		gpiod_direction_output(fep->gd_mdc, 0);
+}
+
+static void fec_main_bb_ctrl_set_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	if (output)
+		gpiod_direction_output(fep->gd_mdio, 0);
+	else
+		gpiod_direction_input(fep->gd_mdio);
+}
+
+static void fec_main_bb_ctrl_set_mdio_data(struct mdiobb_ctrl *ctrl, int value)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	gpiod_direction_output(fep->gd_mdio, value);
+}
+
+static int fec_main_bb_ctrl_get_mdio_data(struct mdiobb_ctrl *ctrl)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	return gpiod_get_value(fep->gd_mdio);
+}
+
+static const struct mdiobb_ops fec_main_bb_ops = {
+	.owner = THIS_MODULE,
+	.set_mdc = fec_main_bb_ctrl_set_mdc,
+	.set_mdio_dir = fec_main_bb_ctrl_set_mdio_dir,
+	.set_mdio_data = fec_main_bb_ctrl_set_mdio_data,
+	.get_mdio_data = fec_main_bb_ctrl_get_mdio_data,
+};
+
 static int fec_enet_mii_init(struct platform_device *pdev)
 {
 	static struct mii_bus *fec0_mii_bus;
@@ -2150,18 +2192,27 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	/* Clear any pending transaction complete indication */
 	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
 
-	fep->mii_bus = mdiobus_alloc();
-	if (fep->mii_bus == NULL) {
-		err = -ENOMEM;
-		goto err_out;
-	}
+	if (fep->gd_mdc && fep->gd_mdio) {
+		fep->fec_main_bb_ctrl.ops = &fec_main_bb_ops;
+		fep->mii_bus = alloc_mdio_bitbang(&fep->fec_main_bb_ctrl);
+		if (!fep->mii_bus) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+	} else {
+		fep->mii_bus = mdiobus_alloc();
+		if (!fep->mii_bus) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+		fep->mii_bus->read = fec_enet_mdio_read;
+		fep->mii_bus->write = fec_enet_mdio_write;
 
-	fep->mii_bus->name = "fec_enet_mii_bus";
-	fep->mii_bus->read = fec_enet_mdio_read;
-	fep->mii_bus->write = fec_enet_mdio_write;
+		fep->mii_bus->priv = fep;
+	}
 	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		pdev->name, fep->dev_id + 1);
-	fep->mii_bus->priv = fep;
+	fep->mii_bus->name = "fec_enet_mii_bus";
 	fep->mii_bus->parent = &pdev->dev;
 
 	err = of_mdiobus_register(fep->mii_bus, node);
@@ -3525,6 +3576,8 @@ fec_probe(struct platform_device *pdev)
 	char irq_name[8];
 	int irq_cnt;
 	struct fec_devinfo *dev_info;
+	struct gpio_desc *gd;
+
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3575,6 +3628,26 @@ fec_probe(struct platform_device *pdev)
 	    !of_property_read_bool(np, "fsl,err006687-workaround-present"))
 		fep->quirks |= FEC_QUIRK_ERR006687;
 
+	gd = devm_gpiod_get_optional(&pdev->dev, "mdc", GPIOD_IN);
+	if (IS_ERR(gd)) {
+		if (PTR_ERR(gd) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get mdc gpio: %ld\n",
+				PTR_ERR(gd));
+		ret = PTR_ERR(gd);
+		goto failed_ioremap;
+	}
+	fep->gd_mdc = gd;
+
+	gd = devm_gpiod_get_optional(&pdev->dev, "mdio", GPIOD_IN);
+	if (IS_ERR(gd)) {
+		if (PTR_ERR(gd) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get mdio gpio: %ld\n",
+				PTR_ERR(gd));
+		ret = PTR_ERR(gd);
+		goto failed_ioremap;
+	}
+	fep->gd_mdio = gd;
+
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
-- 
2.20.1

