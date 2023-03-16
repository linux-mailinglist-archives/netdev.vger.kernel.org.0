Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B0C6BDA90
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCPVEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCPVEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:04:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EC0B0B82;
        Thu, 16 Mar 2023 14:04:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so2943169pjb.0;
        Thu, 16 Mar 2023 14:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679000662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOe0JtBICGgd0kHSmPmJseRqJi3KmhURQwliZoYk24Q=;
        b=ltu1q9+eulMW/jIuTR65uUHp2RW+ACSq7mcFLJeBq7DkiHbDKWboao+WwQhlyj+nMm
         i9JvD5pwJfx8sTJNrOCZTw47MTIIEoCVfxpY4wrDRAOAVG6eBsfhe78OzWC42tHXF8PS
         jbfKidii8Ws/odV83Md/T+InZgGduhhk5BkaPkU5ldYxm6s+MXZMDiWvNc4rCIqcsmZZ
         7n7slsWNCDBdwUjeE1e2JrXuyKKb7XVRH8K4udA0AOAjpakXKLR7mtG0go56JTnp2Wjb
         N6XLdoCWF3Blm1bD0nh/sAOdiAKXrJKHFBvVbCzxijixG1fWNHrTs/RzhzRPDMr+SAju
         mjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679000662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOe0JtBICGgd0kHSmPmJseRqJi3KmhURQwliZoYk24Q=;
        b=t1G1Zk54n4VGP5+h9JdIcoYgRBwAptLRMs61t8g7AgD0gEmDVFmHNhliqV5w5xmZi6
         SX8eon1TYl4JBRTenbsFy04tr8kJyd9/Ae5uT69Eym7cDoEIBiGX0HNHOFVNbczb9A+g
         BarLTsGE85vOQhaEDjjjWIY3KHYf2Zv0rSWID/9aO5DOlWYWrreJxl37JD3l2YkeHZoW
         JlQ5neKVHdVaPdxeCfyUiXnMzuXtpYxIB2mY5cLt37Cy3IGiAANjQBUj9q4bkx766eM8
         jv4UIRyX9MoblrORMkvpPLHzmdd1NFYHNZWAbJJVC6fe+YcRhS41cqE7Zb4ePzueavK2
         6VeQ==
X-Gm-Message-State: AO0yUKXDmyAgpuPIW92ciEg6oiCKJmjvVdfREeWPF3BksAXAM+wsN+Hi
        UjwLzJP2SJ7jvRTnkGh6cMjbUn5K71Y=
X-Google-Smtp-Source: AK7set9XZKa3jx+DqXzYjS+S5cqJMkq8pt7PhT4c4S+B5n0mw5LX2hOW1LjRolZ8hR/duFD1fK/DGA==
X-Received: by 2002:a05:6a20:4408:b0:cd:3069:28cd with SMTP id ce8-20020a056a20440800b000cd306928cdmr5448704pzb.39.1679000662449;
        Thu, 16 Mar 2023 14:04:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14-20020aa7914e000000b005e099d7c30bsm106599pfi.205.2023.03.16.14.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 14:04:21 -0700 (PDT)
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
Subject: [PATCH 2/2] net: mdio: fix owner field for mdio buses registered using ACPI
Date:   Thu, 16 Mar 2023 13:53:01 -0700
Message-Id: <20230316205301.2087667-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316205301.2087667-1-f.fainelli@gmail.com>
References: <20230316205301.2087667-1-f.fainelli@gmail.com>
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

