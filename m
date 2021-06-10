Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4803A3107
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhFJQoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:06 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:36809 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbhFJQnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:37 -0400
Received: by mail-ed1-f42.google.com with SMTP id w21so33743221edv.3;
        Thu, 10 Jun 2021 09:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGYQZXC/NhPdwOiaUJSomKVZ7Ulae3WO3fpWEzXcO0k=;
        b=t+siAVMT3mT+Hwr7+PWLzFq6stbRRymsCcY5eDwBodVZr4+r2ylFc5CCcnRDzreu5W
         mOry5eFoT/Prr/AifIUIeIRVOD6m9Z6Y8k94R15vW+qROBDcWWv9SRwAij5Mtwxua44H
         0ZFT2+96It96Ro1pocjcfTJMOBscl1FSzki/9KlqGNxyrLhF+aK8pfpND1upUUaJgZ+r
         LEOUCPD2LDf2FKZa1iyk2mSzCChZFWH7OappwPFw3MhRvQY/95l7gQDO3v6fY+C+BJwY
         VwWw3kSy50leyhCLYXnLxIFTitsxQtxC3c/pj7ThcEXCmb72xQNqFI9/IwGC8HOUA+ol
         +wVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGYQZXC/NhPdwOiaUJSomKVZ7Ulae3WO3fpWEzXcO0k=;
        b=HVU/v8N1MMudGPvZqxOHF7oxDeG1EkuQhcJMi/hVIHENJ2Q2ffOmGn9aeasWSNzL9K
         CIBYNCJKJs+OR4LhQbPKUXNa3MMG9U4S8cc9FuStI7z5/BKrfve1hEEnD1/tcwAqu0o/
         4X9BFrMQwNWX18BFH1jvZIbu1TXPKeQwB7bFNdygOoukMnIgDkkc9QDRL2m0qsJBIwx8
         yrBOoQhD39zIO9LGTfXT7gdOd5eBQwzzJxkfK4kiRciYIgi+RbbSAm6caMc6hfjnJSZS
         t9VqURWMJwIzWPsY4zKIkZD4Ni0by+H2zbvH/RWiEaD67/kxiA4n8dPc8Y8RBIkqnK7X
         B1vQ==
X-Gm-Message-State: AOAM531HeBLO6ezGEgT0nEba/GEwp6ZPVJyiDJ/Q95UC7IvGNBleODnY
        9IobK9WIQSxaQevRodZBStY=
X-Google-Smtp-Source: ABdhPJxBPcPq2wh+9DGPniGVRDMxk7syTNqaJCS8A6g1PtD6sWxq+CLSZft5xX4PCum1ayk6wdY5cA==
X-Received: by 2002:aa7:da8c:: with SMTP id q12mr358069eds.368.1623343234121;
        Thu, 10 Jun 2021 09:40:34 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:33 -0700 (PDT)
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
Subject: [PATCH net-next v8 09/15] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Thu, 10 Jun 2021 19:39:11 +0300
Message-Id: <20210610163917.4138412-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7:
- include fwnode_mdio.h

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 39 ++------------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9b1cadfd465d..8744b1e1c2b1 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -10,6 +10,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -44,43 +45,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
-	struct mii_timestamper *mii_ts;
-	struct phy_device *phy;
-	bool is_c45;
-	int rc;
-	u32 phy_id;
-
-	mii_ts = of_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
-
-	is_c45 = of_device_is_compatible(child,
-					 "ethernet-phy-ieee802.3-c45");
-
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
-
-	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
-	if (rc) {
-		unregister_mii_timestamper(mii_ts);
-		phy_device_free(phy);
-		return rc;
-	}
-
-	/* phy->mii_ts may already be defined by the PHY driver. A
-	 * mii_timestamper probed via the device tree will still have
-	 * precedence.
-	 */
-	if (mii_ts)
-		phy->mii_ts = mii_ts;
-
-	return 0;
+	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
 static int of_mdiobus_register_device(struct mii_bus *mdio,
-- 
2.31.1

