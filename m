Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719FF66B273
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjAOQK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 11:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjAOQKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 11:10:24 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692601AC;
        Sun, 15 Jan 2023 08:10:23 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so2903317wml.0;
        Sun, 15 Jan 2023 08:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JDpZG6R01B4AYaHlUsuLgtOkzpvo1j93zGzi7+X+if8=;
        b=GNODvnwiItuaImNVoAVo5+Vnu3P1V7c7NNJQEvj8/+SoRrNsylZ6h1kUiVGX89t5Tv
         6bMO3enfwpEllvoekkl0AYQ7ijPUXrYVOzfglgsAoHMg1WVjynM7wRnQi56V/AjbJyGb
         Qx9B5u2Y0OCEYwaGSlRgy0fR/C423rYYzZNgq8/PWBpIrfGxlMC86U7dMEtuOphqfkea
         XX13IXwlMbM22CIUYvdLUdgQh5AJAlWR9WMyD7EMU0hy8tgfR76SQ5CBnpAzcLzRCnwX
         WGtgl9ub64tYIcKW+QdOvW7qnAx3JcYS63y4kynJPujUGOjk87/s7d8iEGF8FxTdoNFf
         XKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JDpZG6R01B4AYaHlUsuLgtOkzpvo1j93zGzi7+X+if8=;
        b=AuukvfOj9MVE7WUHnbhqsp4WzIJMtWkElVX+ufuv/Q5EvKyWEJi5aNmBF40vfFIApZ
         4WSHrBgVnjZpcD4rIANJy6S6pcIPkg3JWS73s7gaoKwsCiewdALAfBlAb//PzE5S42im
         dA9WEle24FeVGCeN4Q8H3xEAj8ku0kCgNBxcIwiq1mSPiwkykleRm03VL5YK7WV9CUYj
         aFYRc/moqdPz+sM65VUQOJ38w/nCjMsmYAZJgL1RCqxqu7GUGYmGK71f/1saWagojqyN
         1Y7uTm94yYsIjgGhjHt+hDXYg76j8LJ3S8NXQgwn2DhlOfVnBKpr6JE4qwcI6tEVexbr
         C8KQ==
X-Gm-Message-State: AFqh2kpHv/8ZzYJC/6ZVs5+v2ZnQhu6G93VGFVdFbuSDzSujqE91ZSbs
        Hz9RxzulqDFkPCNeXP6Lvq0=
X-Google-Smtp-Source: AMrXdXvfWxfgXpbfIJZjR8/5lO3j+123FxBICcF4n4vaO8TfoOWKVawUyMWzugJaOKk0fFoMApjx8Q==
X-Received: by 2002:a05:600c:1c21:b0:3d2:2043:9cb7 with SMTP id j33-20020a05600c1c2100b003d220439cb7mr62974377wms.5.1673799021800;
        Sun, 15 Jan 2023 08:10:21 -0800 (PST)
Received: from localhost.localdomain (host-79-51-7-163.retail.telecomitalia.it. [79.51.7.163])
        by smtp.googlemail.com with ESMTPSA id h10-20020a05600c2caa00b003cfd58409desm37246783wmc.13.2023.01.15.08.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 08:10:21 -0800 (PST)
From:   Pierluigi Passaro <pierluigi.passaro@gmail.com>
X-Google-Original-From: Pierluigi Passaro <pierluigi.p@variscite.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: [PATCH] net: mdio: force deassert MDIO reset signal
Date:   Sun, 15 Jan 2023 17:10:06 +0100
Message-Id: <20230115161006.16431-1-pierluigi.p@variscite.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the reset gpio is defined within the node of the device tree
describing the PHY, the reset is initialized and managed only after
calling the fwnode_mdiobus_phy_device_register function.
However, before calling it, the MDIO communication is checked by the
get_phy_device function.
When this happen and the reset GPIO was somehow previously set down,
the get_phy_device function fails, preventing the PHY detection.
These changes force the deassert of the MDIO reset signal before
checking the MDIO channel.
The PHY may require a minimum deassert time before being responsive:
use a reasonable sleep time after forcing the deassert of the MDIO
reset signal.
Once done, free the gpio descriptor to allow managing it later.

Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
Signed-off-by: FrancescoFerraro <francesco.f@variscite.com>
---
 drivers/net/mdio/fwnode_mdio.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b782c35c4ac1..1f4b8c4c1f60 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -8,6 +8,8 @@
 
 #include <linux/acpi.h>
 #include <linux/fwnode_mdio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/pse-pd/pse.h>
@@ -118,6 +120,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	bool is_c45 = false;
 	u32 phy_id;
 	int rc;
+	int reset_deassert_delay = 0;
+	struct gpio_desc *reset_gpio;
 
 	psec = fwnode_find_pse_control(child);
 	if (IS_ERR(psec))
@@ -134,10 +138,31 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	if (rc >= 0)
 		is_c45 = true;
 
+	reset_gpio = fwnode_gpiod_get_index(child, "reset", 0, GPIOD_OUT_LOW, "PHY reset");
+	if (reset_gpio == ERR_PTR(-EPROBE_DEFER)) {
+		dev_dbg(&bus->dev, "reset signal for PHY@%u not ready\n", addr);
+		return -EPROBE_DEFER;
+	} else if (IS_ERR(reset_gpio)) {
+		if (reset_gpio == ERR_PTR(-ENOENT))
+			dev_dbg(&bus->dev, "reset signal for PHY@%u not defined\n", addr);
+		else
+			dev_dbg(&bus->dev, "failed to request reset for PHY@%u, error %ld\n", addr, PTR_ERR(reset_gpio));
+		reset_gpio = NULL;
+	} else {
+		dev_dbg(&bus->dev, "deassert reset signal for PHY@%u\n", addr);
+		fwnode_property_read_u32(child, "reset-deassert-us",
+					 &reset_deassert_delay);
+		if (reset_deassert_delay)
+			fsleep(reset_deassert_delay);
+	}
+
 	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
 		phy = get_phy_device(bus, addr, is_c45);
 	else
 		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+
+	gpiochip_free_own_desc(reset_gpio);
+
 	if (IS_ERR(phy)) {
 		rc = PTR_ERR(phy);
 		goto clean_mii_ts;
-- 
2.37.2

