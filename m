Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C79C6BE849
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCQLgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCQLgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:36:37 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2214855527;
        Fri, 17 Mar 2023 04:35:51 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l15-20020a05600c4f0f00b003ed58a9a15eso3087572wmq.5;
        Fri, 17 Mar 2023 04:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679052907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCxFJ8Y9JBKeW1Td/agI2Q/Ve+uYhi8G9xxdLPJEMjg=;
        b=h/zfKni90XIgqMPwBl6tlyLyYaXLr30bRH38kh4DE5+KjDvYDDd9z8jGN9Iugkonx4
         kN0nFxveKcjTwj2qDkAQ5iWvU75LNIFEAlqu75YLi/Ccu0wFBy3MCzt8Jfb8P4vrSzLh
         kEGKkcBK4n6HDtJcIt8Sgbz38iNFBcjzZDCa6Vi18VPINiIvn769xFeCTRMnHh3sprR8
         gCrwbb/KoCW/XxR1PLSWFry1x3gt2p/Omy+KHLqJitUl7Q4JjvmiEpmUfA/PmeMV5wR+
         dszXyK7Kcs8xplUO92P1txGx8P+LPC3vV24h7ppKU5vHnDQ662dGn3T0NLwzQ8SkiYJj
         q8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCxFJ8Y9JBKeW1Td/agI2Q/Ve+uYhi8G9xxdLPJEMjg=;
        b=1JEgGjo0J3h4YXgNUxgxX/jDa3Oa55m+4dpWgQeeGm0DBX8ko80rur8YdQCZqgvhPo
         x6gUNCLRwDey2aSq9KiMQ8ABrl4XSxOhy/y32natiHnIc6WCgUQ3McOwZkmb2aFQU60O
         qyyZKHFKwfcUgIAI9+WYa3S6dAKf5Dcn50YGyBR9jlh+VtCCqmAAw6PoJkqqsrUiH82M
         5NsbXdPkACiXeF9CxgqwN6UxNWGua7K6yYtTQgWj5LKu4AQAMr8g/wH3qc8/ICqftubV
         RmlDcdu+srLPmbSjVpjINZM2ET66SFTCOm3WiOtKWxY7A2TRFh1t9bJt/bWM3GrupCLr
         coYg==
X-Gm-Message-State: AO0yUKXbr8juUhXJ3YtDcNt5wWhvElIvVUiwquD0juBpVCk0Btls7eQ4
        Q+WK+Tk1vVPtGoAupX2v8mI=
X-Google-Smtp-Source: AK7set8DxyHZm9v+MD+/YcaTjLSpi9wlz3K/gKCpO3qNxX8SzOLHNk4IKToeXXM5eB/3J2quMNBuUw==
X-Received: by 2002:a05:600c:524a:b0:3ed:3e72:3580 with SMTP id fc10-20020a05600c524a00b003ed3e723580mr6584306wmb.26.1679052906946;
        Fri, 17 Mar 2023 04:35:06 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm1763505wrj.47.2023.03.17.04.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:35:06 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
Date:   Fri, 17 Mar 2023 12:34:26 +0100
Message-Id: <20230317113427.302162-3-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317113427.302162-1-noltari@gmail.com>
References: <20230317113427.302162-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

b53 MMAP devices have a MDIO Mux bus controller that must be registered after
properly initializing the switch. If the MDIO Mux controller is registered
from a separate driver and the device has an external switch present, it will
cause a race condition which will hang the device.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/Kconfig    |   1 +
 drivers/net/dsa/b53/b53_mmap.c | 127 ++++++++++++++++++++++++++++++++-
 2 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index ebaa4a80d544..04450ee1ba82 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -26,6 +26,7 @@ config B53_MDIO_DRIVER
 config B53_MMAP_DRIVER
 	tristate "B53 MMAP connected switch driver"
 	depends on B53 && HAS_IOMEM
+	select MDIO_BUS_MUX
 	default BCM63XX || BMIPS_GENERIC
 	help
 	  Select to enable support for memory-mapped switches like the BCM63XX
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index e968322dfbf0..44becbb12bb5 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -18,15 +18,31 @@
 
 #include <linux/bits.h>
 #include <linux/kernel.h>
+#include <linux/mdio-mux.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/of_mdio.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/b53.h>
 
 #include "b53_priv.h"
 
+#define REG_MDIOC		0xb0
+#define  REG_MDIOC_EXT_MASK	BIT(16)
+#define  REG_MDIOC_REG_SHIFT	20
+#define  REG_MDIOC_PHYID_SHIFT	25
+#define  REG_MDIOC_RD_MASK	BIT(30)
+#define  REG_MDIOC_WR_MASK	BIT(31)
+
+#define REG_MDIOD		0xb4
+
 struct b53_mmap_priv {
 	void __iomem *regs;
+
+	/* Internal MDIO Mux bus */
+	struct mii_bus *mbus;
+	int ext_phy;
+	void *mux_handle;
 };
 
 static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8 *val)
@@ -229,6 +245,111 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write64 = b53_mmap_write64,
 };
 
+static int b53_mmap_mdiomux_read(struct mii_bus *bus, int phy_id, int loc)
+{
+	struct b53_device *dev = bus->priv;
+	struct b53_mmap_priv *priv = dev->priv;
+	uint32_t reg;
+	uint16_t val;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
+
+	reg = REG_MDIOC_RD_MASK |
+	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
+	      (loc << REG_MDIOC_REG_SHIFT);
+	if (priv->ext_phy)
+		reg |= REG_MDIOC_EXT_MASK;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
+	udelay(50);
+	b53_mmap_read16(dev, 0, REG_MDIOD, &val);
+
+	return (int) val;
+}
+
+static int b53_mmap_mdiomux_write(struct mii_bus *bus, int phy_id, int loc,
+				  uint16_t val)
+{
+	struct b53_device *dev = bus->priv;
+	struct b53_mmap_priv *priv = dev->priv;
+	uint32_t reg;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
+
+	reg = REG_MDIOC_WR_MASK |
+	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
+	      (loc << REG_MDIOC_REG_SHIFT);
+	if (priv->ext_phy)
+		reg |= REG_MDIOC_EXT_MASK;
+	reg |= val;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
+	udelay(50);
+
+	return 0;
+}
+
+static int b53_mmap_mdiomux_switch_fn(int current_child, int desired_child,
+				      void *data)
+{
+	struct b53_device *dev = data;
+	struct b53_mmap_priv *priv = dev->priv;
+
+	priv->ext_phy = desired_child;
+
+	return 0;
+}
+
+static int b53_mmap_mdiomux_init(struct b53_device *priv)
+{
+	struct b53_mmap_priv *mpriv = priv->priv;
+	struct device *dev = priv->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *mnp;
+	struct mii_bus *mbus;
+	int ret;
+
+	mnp = of_get_child_by_name(np, "mdio-mux");
+	if (!mnp)
+		return 0;
+
+	mbus = devm_mdiobus_alloc(dev);
+	if (!mbus) {
+		of_node_put(mnp);
+		return -ENOMEM;
+	}
+
+	mbus->priv = priv;
+	mbus->name = np->full_name;
+	snprintf(mbus->id, MII_BUS_ID_SIZE, "%pOF", np);
+	mbus->parent = dev;
+	mbus->read = b53_mmap_mdiomux_read;
+	mbus->write = b53_mmap_mdiomux_write;
+	mbus->phy_mask = 0x3f;
+
+	ret = devm_of_mdiobus_register(dev, mbus, mnp);
+	if (ret) {
+		of_node_put(mnp);
+		dev_err(dev, "MDIO mux registration failed\n");
+		return ret;
+	}
+
+	ret = mdio_mux_init(dev, mnp, b53_mmap_mdiomux_switch_fn,
+			    &mpriv->mux_handle, priv, mbus);
+	of_node_put(mnp);
+	if (ret) {
+		mdiobus_unregister(mbus);
+		dev_err(dev, "MDIO mux initialization failed\n");
+		return ret;
+	}
+
+	dev_info(dev, "MDIO mux bus init\n");
+
+	mpriv->mbus = mbus;
+
+	return 0;
+}
+
 static int b53_mmap_probe_of(struct platform_device *pdev,
 			     struct b53_platform_data **ppdata)
 {
@@ -306,7 +427,11 @@ static int b53_mmap_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
-	return b53_switch_register(dev);
+	ret = b53_switch_register(dev);
+	if (ret)
+		return ret;
+
+	return b53_mmap_mdiomux_init(dev);
 }
 
 static int b53_mmap_remove(struct platform_device *pdev)
-- 
2.30.2

