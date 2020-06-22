Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF01A203444
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgFVKBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgFVKBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:01:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A901C061799
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:23 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r9so14264243wmh.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0OwWR9e+WLqXjj7DZkBsabU1u86Gybrt82xzuKAKe9o=;
        b=PF+tNOmBYUtaXR59mgLImt5cydyQjc6gCPHU2lpTFbbnauDrYket1vtlbvya1ZFFaX
         gZcWbJjIa4v6QOhEmbOEpsuz/BzHnaMKaiIZawDoROmh5HVGhBYs/wDzYWqAlUjdnSUP
         UknHwa2e8E7lmYaNQ2ZInYopleBTBrQXkM3owc7xyhGa+IPJhFae9afW+yTnTVvNJVHO
         noPcA8CyypW5+/8+u8UidiqF8N8uVszPjCDi1HZeV9HdAcrfhH1rHUd12HGSNxazdHuY
         1nHtMg93+nwFp/9FA+D2PC82dYeE4jCIN7biofp8SUU38ZY+Mu2iypl7deFI/1IGlFYE
         BSsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0OwWR9e+WLqXjj7DZkBsabU1u86Gybrt82xzuKAKe9o=;
        b=PvbnUKzkKEDhbM+HDduCdMTTsrnF3N1KooJWnCbgrzHNIG1mziZYSBocZ2o0tWdEw2
         sHQLqB2uZSzGpoO+ERBSiDmZmsnS9kBF0jCGLkyn14+fi8xUu+Z23SDLOiwYNCeG3J2d
         W1DCgm1zuzjgZ0RKil2+TZf2KJeAiqSfD4A8VUnxdSBniezFIErcDyBcM1m1oOIJHVE9
         beKTd/lk91CN0a6XZN1U0EjJjicB5S7UotAE0fPJwQbnCY+qDbaXs1lRMkL6dSxcMP5W
         0IpKo7QJxZctuRPoYgq+PxMgYLCbo7uaQ6sRbs6uk2HuT3G9ulEOW8WYYdBsWblRfE5o
         JvSA==
X-Gm-Message-State: AOAM533+qhSF6XY61nOW1lptXPamHpgaG8bK10TQfse41eD7txkBSlTQ
        X00HWavdPym9YT5vGMiLoW6hjw==
X-Google-Smtp-Source: ABdhPJwvA59r+zUadSM89AyF+H+fxT/nf2nvFkXIaFeBdOLpCsO/8Bm7rv3uF+bD/IjDwAb9EKnqCw==
X-Received: by 2002:a05:600c:21d7:: with SMTP id x23mr18471470wmj.95.1592820082109;
        Mon, 22 Jun 2020 03:01:22 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id x205sm16822187wmx.21.2020.06.22.03.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:01:21 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 10/11] of: mdio: provide devm_of_mdiobus_register()
Date:   Mon, 22 Jun 2020 12:00:55 +0200
Message-Id: <20200622100056.10151-11-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622100056.10151-1-brgl@bgdev.pl>
References: <20200622100056.10151-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Implement a managed variant of of_mdiobus_register(). We need to
reimplement the devres structure and the release callback because we
can't put this function in drivers/net/phy/mdio_devres.c or we'd hit
circular dependencies between module symbols. We also don't want to
build this bit if OF is not selected in Kconfig.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../driver-api/driver-model/devres.rst        |  1 +
 drivers/of/of_mdio.c                          | 43 +++++++++++++++++++
 include/linux/of_mdio.h                       |  3 ++
 3 files changed, 47 insertions(+)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index e0333d66a7f4..eaaaafc21134 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -343,6 +343,7 @@ MDIO
   devm_mdiobus_alloc()
   devm_mdiobus_alloc_size()
   devm_mdiobus_register()
+  devm_of_mdiobus_register()
 
 MEM
   devm_free_pages()
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index a04afe79529c..83e98c6ec96b 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -330,6 +330,49 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 }
 EXPORT_SYMBOL(of_mdiobus_register);
 
+/* This duplicates the devres code from drivers/net/phy/mdio_devres.c but
+ * if we put devm_of_mdiobus_register() over there we'd hit circular symbol
+ * dependencies between the libphy and of_mdio modules.
+ */
+struct mdiobus_devres {
+	struct mii_bus *mii;
+};
+
+static void devm_mdiobus_unregister(struct device *dev, void *this)
+{
+	struct mdiobus_devres *dr = this;
+
+	mdiobus_unregister(dr->mii);
+}
+
+/**
+ * devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
+ * @dev:	Device to register mii_bus for
+ * @mdio:	MII bus structure to register
+ * @np:		Device node to parse
+ */
+int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			     struct device_node *np)
+{
+	struct mdiobus_devres *dr;
+	int ret;
+
+	dr = devres_alloc(devm_mdiobus_unregister, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	ret = of_mdiobus_register(mdio, np);
+	if (ret) {
+		devres_free(dr);
+		return ret;
+	}
+
+	dr->mii = mdio;
+	devres_add(dev, dr);
+	return 0;
+}
+EXPORT_SYMBOL(devm_of_mdiobus_register);
+
 /**
  * of_phy_find_device - Give a PHY node, find the phy_device
  * @phy_np: Pointer to the phy's device tree node
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index ba8e157f24ad..1efb88d9f892 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -8,12 +8,15 @@
 #ifndef __LINUX_OF_MDIO_H
 #define __LINUX_OF_MDIO_H
 
+#include <linux/device.h>
 #include <linux/phy.h>
 #include <linux/of.h>
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 bool of_mdiobus_child_is_phy(struct device_node *child);
 int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
+int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			     struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
 of_phy_connect(struct net_device *dev, struct device_node *phy_np,
-- 
2.26.1

