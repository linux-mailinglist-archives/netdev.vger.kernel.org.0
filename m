Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9920E0CD
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbgF2Utv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731485AbgF2TNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BF5C00E3D7
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o2so15872789wmh.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hztYQwCZoivzm5mGWlL7y58+THNI2tIqMQL/obqgBh8=;
        b=wrrcCV/eHtEzwZIw9VBAP2zQ1gydhl0t9E8l473TWC1k05eOBumji4Os1tiblAIJzO
         4wOzef0hZPVEX5d6XcKMyCLmyT1b7YyADt6ahskiop6YYNc4kCYECitUEPTZ2F+fGW7i
         6y8Uvfl5xMLYsCcJdugcnS3YtHoCINKs3ujOoex6Br78sdsqIuKWAPmqQBMdtMgzZc4Z
         IgDmjSTOStUefzpm8hIuT/c2k0/+8rBOE6qocp0QN+rhvRzXyv46oLIUH3XFLdMSc0fo
         EpUTI/q2/srGjYzlHBIkYZyaLKmmyxTE0lK2PPy6VX9gggVCK384yzLHsG9blwPMptuJ
         bl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hztYQwCZoivzm5mGWlL7y58+THNI2tIqMQL/obqgBh8=;
        b=l2MCWeKyiDrPLDuh2kCfURm8iuJoo7Kznb6FejSgSDbqaIrOOOzcH6eur1ZSYElxtS
         PvhzWYf4IPLWdVcY6gRMAT/Q+HDt2ORrJ/iOXxYfAruwB54BkQPtGTbpQXoCrV4paxPa
         vZlFsLjCeRy6UoD5vPooe27JZFQ5hlgjZFIvUPJw6Grmbx8FZUXiuKXbNCrtCHjIeoZH
         TRC6z1evkUQFoQalFJaOQvwL82GMGOfyQraITf7WlCLtCudo+zfNmJpYZkKIGg5c5bsL
         j1/qZU6P5RavB69wpwtNbeqG77oSd01XiNv/GlImE9HQs3pGeIQ1okk5uh3Lv3F7x0HE
         3nUQ==
X-Gm-Message-State: AOAM530qMCXeHTMQ2UqmevVPW8j70U5L0EDoHesA5q+FfW1wMp0Cwfh+
        VV/qUQK6jonBbKdszXL45J2w9w==
X-Google-Smtp-Source: ABdhPJwFYLtezxZPsklmDvGqxvDLuEveoshSgJPr77DKJtvQVHg9COcCXF74kUionqbzZntdIBqycg==
X-Received: by 2002:a7b:cc8b:: with SMTP id p11mr17633011wma.180.1593432258934;
        Mon, 29 Jun 2020 05:04:18 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:18 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 05/10] phy: un-inline devm_mdiobus_register()
Date:   Mon, 29 Jun 2020 14:03:41 +0200
Message-Id: <20200629120346.4382-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Functions should only be static inline if they're very short. This
devres helper is already over 10 lines and it will grow soon as we'll
be improving upon its approach. Pull it into mdio_devres.c.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/Makefile      |  2 +-
 drivers/net/phy/mdio_devres.c | 18 ++++++++++++++++++
 include/linux/phy.h           | 15 ++-------------
 3 files changed, 21 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/phy/mdio_devres.c

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index dc9e53b511d6..896afdcac437 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -3,7 +3,7 @@
 
 libphy-y			:= phy.o phy-c45.o phy-core.o phy_device.o \
 				   linkmode.o
-mdio-bus-y			+= mdio_bus.o mdio_device.o
+mdio-bus-y			+= mdio_bus.o mdio_device.o mdio_devres.o
 
 ifdef CONFIG_MDIO_DEVICE
 obj-y				+= mdio-boardinfo.o
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
new file mode 100644
index 000000000000..f0b4b6cfe5e3
--- /dev/null
+++ b/drivers/net/phy/mdio_devres.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/phy.h>
+
+int __devm_mdiobus_register(struct mii_bus *bus, struct module *owner)
+{
+	int ret;
+
+	if (!bus->is_managed)
+		return -EPERM;
+
+	ret = __mdiobus_register(bus, owner);
+	if (!ret)
+		bus->is_managed_registered = 1;
+
+	return ret;
+}
+EXPORT_SYMBOL(__devm_mdiobus_register);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index b693b609b2f5..4935867f024b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -313,20 +313,9 @@ static inline struct mii_bus *mdiobus_alloc(void)
 }
 
 int __mdiobus_register(struct mii_bus *bus, struct module *owner);
+int __devm_mdiobus_register(struct mii_bus *bus, struct module *owner);
 #define mdiobus_register(bus) __mdiobus_register(bus, THIS_MODULE)
-static inline int devm_mdiobus_register(struct mii_bus *bus)
-{
-	int ret;
-
-	if (!bus->is_managed)
-		return -EPERM;
-
-	ret = mdiobus_register(bus);
-	if (!ret)
-		bus->is_managed_registered = 1;
-
-	return ret;
-}
+#define devm_mdiobus_register(bus) __devm_mdiobus_register(bus, THIS_MODULE)
 
 void mdiobus_unregister(struct mii_bus *bus);
 void mdiobus_free(struct mii_bus *bus);
-- 
2.26.1

