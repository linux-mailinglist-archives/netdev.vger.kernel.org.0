Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AB26BDCF1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCPXdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCPXdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:33:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB08AB6914;
        Thu, 16 Mar 2023 16:33:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso3217640pjb.2;
        Thu, 16 Mar 2023 16:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679009609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOe0JtBICGgd0kHSmPmJseRqJi3KmhURQwliZoYk24Q=;
        b=StCFPNTqrsFsKhuQ6IBo+ORNHveCFU0dkHDNam1hij53PajDKUqyUXE+FgSiCffTlE
         EqKPQCVvc6zMytr5/bHD7EyrKO8VRSeGaKvymkxEI0zMZZbMY8lXHwMGHWWEBdIBvA+g
         xthesPI+97Oqegs5JAgXmrntPXXi3L4aeBNIwvX+bcmeQy4DZ9LDckMU04uCBU0EHmoo
         z+htJuy2ztY7qKjKph7PVUSgQyJIcBzdMjP04hNHE6IM8LM6meEMN37p6dM3TKBb0tMG
         +N9fprIeTJS33hFRUPoZLNIB2cFhN8tqb9kQCa27bSygYVYD1mCYpEtx88EBDFPvVVpS
         zt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679009609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOe0JtBICGgd0kHSmPmJseRqJi3KmhURQwliZoYk24Q=;
        b=7UgQ02TfirlaV3cIWwRVRuJel+GNK8tng62R1D7Bmn7ZYdgvblC6tEkUhFH+TMzEKu
         gHYJXi9oUTcH+pLtwJUwt5sObLdrPDBLZl+V9dUtr1Yw2T2C+pZhMvPEloG6D9JL8kA4
         60YX6KinWwBHQOxiW3xPvTlgDJ0zcpu3F5/+XcfOh0DnRLtZOwKi1hVNDyQ8XKrT9VuA
         eq4EV4kIC5xiZhfS+vBs8EhU5lmyZzJ6mOvwH65bsAOthgqnCBI/pJ5x04acJZWEFnjI
         939wbdUoL8Xgo1XWqs0tjtY06xsaZnVP+5RRMex0pmRI9ErGZVAjZUmEJIDb8Z8/T+VO
         lFqw==
X-Gm-Message-State: AO0yUKUxJRudIH9IDvHBQmoFy7mPF1ZCBGrLB4I63mBh3dtOJr08YXcB
        epNN1qTNZWWUEs0oeCdzQLLaklSgjYc=
X-Google-Smtp-Source: AK7set85jjbcM461pGN9xA7RPC6Xk/0ACV0RwV5AcbXKt2AAsUAQMkVyDWdUZvCdRkOo6Ft3fxBzyw==
X-Received: by 2002:a17:903:1c1:b0:1a0:42c0:b2af with SMTP id e1-20020a17090301c100b001a042c0b2afmr6533788plh.33.1679009608667;
        Thu, 16 Mar 2023 16:33:28 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j1-20020a170903024100b0019f3cc3fc99sm260900plh.16.2023.03.16.16.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 16:33:28 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH v2 2/2] net: mdio: fix owner field for mdio buses registered using ACPI
Date:   Thu, 16 Mar 2023 16:33:17 -0700
Message-Id: <20230316233317.2169394-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316233317.2169394-1-f.fainelli@gmail.com>
References: <20230316233317.2169394-1-f.fainelli@gmail.com>
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

Bus ownership is wrong when using acpi_mdiobus_register() to register an
mdio bus. That function is not inline, so when it calls
mdiobus_register() the wrong THIS_MODULE value is captured.

CC: Maxime Bizon <mbizon@freebox.fr>
Fixes: 803ca24d2f92 ("net: mdio: Add ACPI support code for mdio")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/acpi_mdio.c | 10 ++++++----
 include/linux/acpi_mdio.h    |  9 ++++++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index d77c987fda9c..4630dde01974 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -18,16 +18,18 @@ MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
 /**
- * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
+ * __acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
  * @mdio: pointer to mii_bus structure
  * @fwnode: pointer to fwnode of MDIO bus. This fwnode is expected to represent
+ * @owner: module owning this @mdio object.
  * an ACPI device object corresponding to the MDIO bus and its children are
  * expected to correspond to the PHY devices on that bus.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @fwnode.
  */
-int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
+			    struct module *owner)
 {
 	struct fwnode_handle *child;
 	u32 addr;
@@ -35,7 +37,7 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 
 	/* Mask out all PHYs from auto probing. */
 	mdio->phy_mask = GENMASK(31, 0);
-	ret = mdiobus_register(mdio);
+	ret = __mdiobus_register(mdio, owner);
 	if (ret)
 		return ret;
 
@@ -55,4 +57,4 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(acpi_mdiobus_register);
+EXPORT_SYMBOL(__acpi_mdiobus_register);
diff --git a/include/linux/acpi_mdio.h b/include/linux/acpi_mdio.h
index 0a24ab7cb66f..8e2eefa9fbc0 100644
--- a/include/linux/acpi_mdio.h
+++ b/include/linux/acpi_mdio.h
@@ -9,7 +9,14 @@
 #include <linux/phy.h>
 
 #if IS_ENABLED(CONFIG_ACPI_MDIO)
-int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
+int __acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode,
+			    struct module *owner);
+
+static inline int
+acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *handle)
+{
+	return __acpi_mdiobus_register(mdio, handle, THIS_MODULE);
+}
 #else /* CONFIG_ACPI_MDIO */
 static inline int
 acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
-- 
2.34.1

