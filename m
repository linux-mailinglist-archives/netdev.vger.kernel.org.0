Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7B3A30F5
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhFJQnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:33 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:33382 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhFJQnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:17 -0400
Received: by mail-ed1-f41.google.com with SMTP id f5so28804474eds.0;
        Thu, 10 Jun 2021 09:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KaDg6gQwiNbYQ/n+/AJXeEJZNxoDx4UiMVm3rtxhM28=;
        b=UHYZrSeAQMnPEqKw9Yu1yjR6f8crKDxB0QKCJUw/qyyC7dvFfrO/CGQIAqee8f1PlG
         bhM5fU/2JgbtIgfP+wiN2adwzCDBXnooeSBx6uQCulbemwY58oyPAZuqosXWz90YE8nD
         TpQMDXGv4OHl5KI34uKDpOvbUGPYhh3iTuv+zXV3zsvSG6ndCDzm0MRfbLxMzfgvlXHo
         7FVFV2KfjxdikU5QLfpamLN/wz4LmbLj0aUucsw/zgwl4Nuh4yigaiJkHhqqAzLe9jet
         2tlqDpEJiumXFst6m2Vy0pMpHvRDB6n+7JRG7Rb3M9ufVrR+Q6ugz5Ml+0eKrhZdDc7x
         6Ejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KaDg6gQwiNbYQ/n+/AJXeEJZNxoDx4UiMVm3rtxhM28=;
        b=HORXkDjRp6XHlMGe4xbGFV32RNDeCt8tS9zAkfT0P5pEIaiFZXiTbDUcL1/JTbliku
         EtZOn/RJuBUGCMYXE36Irhq5OtObeo6KCfpPpDKxGK6xVtMKIWdoTIEz2H3+plWQOUyI
         2FCKYEKockV3iFlQGo7Nfe/zmFA6aiNvsAOXKZc/39eSDLKvQ9u0/oFMcPziW8lmQS7C
         O/lgG/6hNYU048VPywncc9SPL4LpNgxbyAhx7bZ9gShJjdEuOH9yDvPrjVJHYggUNrdH
         93OqkG7QZ1VVAp+ylZsmExVGh0xesySQZb4f17g6lTLnku1dHWL2gOQNAfbp0Vf8+tG4
         p6dw==
X-Gm-Message-State: AOAM530cN8P7+r+gg/RpT2K3/vakk9mLGVwvsYqIoy+UfSDyasGHuSMM
        Ls1qrZ9c59fqeK4WmKaQuc8=
X-Google-Smtp-Source: ABdhPJwV5RxjQIJKGTTFuMRHC1yAz5oZtEGMCwmSVSL7QWpJwoalTw1VHdLa4/3G2Moi2Q06OIkSGg==
X-Received: by 2002:a05:6402:204:: with SMTP id t4mr387873edv.34.1623343220068;
        Thu, 10 Jun 2021 09:40:20 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:19 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 02/15] net: phy: Introduce fwnode_mdio_find_device()
Date:   Thu, 10 Jun 2021 19:39:04 +0300
Message-Id: <20210610163917.4138412-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Refactor of_mdio_find_device() to use fwnode_mdio_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7:
- correct fwnode_mdio_find_device() description

Changes in v6:
- fix warning for function parameter of fwnode_mdio_find_device()

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  7 +++++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 8e97d5b825f5..6ef8b6e40189 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
-	struct device *d;
-
-	if (!np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&mdio_bus_type, np);
-	if (!d)
-		return NULL;
-
-	return to_mdio_device(d);
+	return fwnode_mdio_find_device(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdio_find_device);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1539ea021ac0..363cc70d00ca 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2863,6 +2863,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @fwnode: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use.
+ */
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	struct device *d;
+
+	if (!fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(fwnode_mdio_find_device);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ed332ac92e25..7aa97f4e5387 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1377,10 +1377,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+
 static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.31.1

