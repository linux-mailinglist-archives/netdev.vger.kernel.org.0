Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB674ED6D8
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiCaJaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiCaJ3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:29:23 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9D51FF205;
        Thu, 31 Mar 2022 02:27:16 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CB1E7E000F;
        Thu, 31 Mar 2022 09:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kVAzqr5qEkiVW+zEGfSJDKuaqlr/tvNfR2dtI854pn4=;
        b=EVi6FWuzBV7PFfbMzBkBpd7Ebu7+qVF5BInbfb9Pm1pgsRpcyFDoiS/fjEo7BCC/iWjsnJ
        h+4wbf2OsPzKyELKwpOg0vDG2gzVQ3gQKv037dgLxpqCmSLpb1/lowCn9ZhiM315IrTb3Y
        J9gVGxIcnKeQnaH1LqoIb4xzSoWZeQHJWXKgkmiT57t78sY30m8vhBwNxxQsyJXFvS46GD
        NNV3flj69eYotlUQJ523MAYZrM8chMYQ5Q5HknOdBCSwrs4iW7TTZFnMKsQeC7+M6RmpQ1
        q2TvNoP1EycW4K5B+IqF4uWT5c2/LklpG1PO0chw1iPHpovv/6nXgB+ypubCLw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC PATCH net-next v2 11/11] net: mdio: mscc-miim: use fwnode_mdiobus_register()
Date:   Thu, 31 Mar 2022 11:25:33 +0200
Message-Id: <20220331092533.348626-12-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331092533.348626-1-clement.leger@bootlin.com>
References: <20220331092533.348626-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use fwnode_mdiobus_register() to be compatible with devices described
with device-tree and software nodes.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index c483ba67c21f..ea79421fcfd4 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -7,12 +7,12 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mdio/mdio-mscc-miim.h>
 #include <linux/module.h>
-#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
@@ -288,7 +288,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	if (!miim->info)
 		return -EINVAL;
 
-	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	ret = fwnode_mdiobus_register(bus, dev_fwnode(&pdev->dev));
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
 		return ret;
-- 
2.34.1

