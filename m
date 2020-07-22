Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CE22977A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgGVLdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVLdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:33:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9928C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:33:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so835496pls.9
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LlPPi4IBljo6vwCgdkHQwIPFvt3uPdmjNJzd8ENh9oU=;
        b=H3KydOfyLlynUqdxG7jLE0wrYfHIZ/FBuh9OV6B7rVwwD1hppuyvbYGF39V0y9XvEp
         bgoU+tLAAY81TJgzygr6tu/6L7DorB+uOZ0l2Adbr8SqcCZ+pnkvris5Ko+tAi40y6DO
         fg7cYnMnMTFCkV8yVcTaQo4uP2ogcg6vXY/G+TzYV5ug3edWG+DUymJ8Ges9X/Flo9pd
         44QIE3su0iaV3KquaXjORkmWIPGyocrA16D5epZ4ywjr68ro/aPdz+tVPLA0qGf5Q7PI
         Xju18Hlcd6/WbHAmb0wLsfYhHd821KFVJBqzA59A8/0AgbOufBV8DdAja5lvx8p8NtSl
         uxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=LlPPi4IBljo6vwCgdkHQwIPFvt3uPdmjNJzd8ENh9oU=;
        b=Y5czDx6lbNYAEPH+ibHtk6JeQcmDy2hqTCf3JMRggsEcwKuX4oyXfDYjepkoC/R/vN
         VaZbYIzATCyjKRo6uOqLYIMU3NaexUrwDHeGO4Y+H9Xya96gyq+C89YqrTY4rTZar+9S
         pRf+66k670gR+7TvLBd1b3A2pdFQXi8qCHI8Zdzj7bp+cvV8NcozSYErMMeQbAxmEXao
         QlW9PkaoIjeAJ4EKY1DtdxcmKHBzBgz1x9bPHCNgO8s3XWQ3MkVI/a5YTWl7B59eFtdm
         JApr9a7xJXly3s/fEXoF2s1N87+VVMJ9HtD+5NPEkrHsErow11QrEYhladxITeeuY5BX
         q5RQ==
MIME-Version: 1.0
X-Gm-Message-State: AOAM530NaVS129F3qbhpmH0tMZo/5YI5quV3DOrWxW95mIGRhmHH5aUo
        2GkZ/bTXKGszyvWvKoFhlKORzErvTvuj4rMbg5u8jrrMnDNUZdXcSxTIjyIaIUZxSr6nBbtawDy
        pjnBxccSh8w==
X-Google-Smtp-Source: ABdhPJxuKeRy9Zv2i1Bv42vK+3ufmuTnmVKwAA4j3V0/geTvwkC9qpyfzZeHw6NqKiQTwDw2jzBlOA==
X-Received: by 2002:a17:90a:f30c:: with SMTP id ca12mr8034776pjb.143.1595417590507;
        Wed, 22 Jul 2020 04:33:10 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id 66sm24783715pfa.92.2020.07.22.04.33.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 04:33:10 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH 1/2] net: phy: Add fwnode helper functions
Date:   Wed, 22 Jul 2020 17:02:26 +0530
Message-Id: <1595417547-18957-2-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595417547-18957-1-git-send-email-vikas.singh@puresoftware.com>
References: <1595417547-18957-1-git-send-email-vikas.singh@puresoftware.com>
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support of fwnode helper functions to MDIO bus driver.
1. fwnode_phy_find_device() to find phy_device associated to a fwnod
2. fwnode_phy_connect() to attach the mac to the phy

Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>
---
 drivers/net/phy/mdio_bus.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  4 +++
 2 files changed, 70 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7275eff..9457ff5 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -40,6 +40,72 @@
 
 #include "mdio-boardinfo.h"
 
+/* Helper function for fwnode_phy_find_device */
+static int fwnode_phy_match(struct device *dev, const void *phy_fwnode)
+{
+	return dev->fwnode == phy_fwnode;
+}
+
+/**
+ * fwnode_phy_find_device - find the phy_device associated to fwnode
+ * @phy_fwnode: Pointer to the PHY's fwnode
+ *
+ * If successful, returns a pointer to the phy_device with the
+ * embedded struct device refcount incremented by one, NULL on
+ * failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct device *d;
+	struct mdio_device *mdiodev;
+
+	if (!phy_fwnode)
+		return NULL;
+
+	d = bus_find_device(&mdio_bus_type, NULL, phy_fwnode, fwnode_phy_match);
+	if (d) {
+		mdiodev = to_mdio_device(d);
+		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+			return to_phy_device(d);
+		put_device(d);
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(fwnode_phy_find_device);
+
+/**
+ * fwnode_phy_connect - Connect to the phy described in the device tree
+ * @dev: pointer to net_device claiming the phy
+ * @phy_fwnode: Pointer to fwnode for the PHY
+ * @hndlr: Link state callback for the network device
+ * @flags: flags to pass to the PHY
+ * @iface: PHY data interface type
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure. The
+ * refcount must be dropped by calling phy_disconnect() or phy_detach().
+ */
+struct phy_device *fwnode_phy_connect(
+		struct net_device *dev, struct fwnode_handle *phy_fwnode,
+		void (*hndlr)(struct net_device *), u32 flags, u32 iface)
+{
+	struct phy_device *phy_dev;
+
+	phy_dev = fwnode_phy_find_device(phy_fwnode);
+	if (!phy_dev)
+		return NULL;
+
+	phy_dev->dev_flags = flags;
+
+	/* If in case we fail to attach to PHY,then phy_dev must be NULL */
+	if (phy_connect_direct(dev, phy_dev, hndlr, iface))
+		return NULL;
+
+	return phy_dev;
+}
+EXPORT_SYMBOL(fwnode_phy_connect);
+
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
 	/* Deassert the optional reset signal */
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 898cbf0..501da6a 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -362,6 +362,10 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
 struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *fwnode_phy_connect(
+		struct net_device *dev, struct fwnode_handle *phy_fwnode,
+		void (*hndlr)(struct net_device *), u32 flags, u32 iface);
 
 /**
  * mdio_module_driver() - Helper macro for registering mdio drivers
-- 
2.7.4


-- 




*Disclaimer* -The information transmitted is intended solely for the 
individual
or entity to which it is addressed and may contain confidential 
and/or
privileged material. Any review, re-transmission, dissemination or 
other use of
or taking action in reliance upon this information by persons 
or entities other
than the intended recipient is prohibited. If you have 
received this email in
error please contact the sender and delete the 
material from any computer. In
such instances you are further prohibited 
from reproducing, disclosing,
distributing or taking any action in reliance 
on it.As a recipient of this email,
you are responsible for screening its 
contents and the contents of any
attachments for the presence of viruses. 
No liability is accepted for any
damages caused by any virus transmitted by 
this email.
