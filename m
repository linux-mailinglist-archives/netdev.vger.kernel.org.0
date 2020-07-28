Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57B62309BA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgG1MNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgG1MNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:13:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81699C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:13:43 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w126so10683831pfw.8
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Q7Jr0+bPHkU8ftNeZpKa3KTFQgwP6uinanbk/ZSZ5Y=;
        b=WAdt5nZAHs0w+S08Jpibt7r+Z0y0lkOjs0VoaCVnKfn+7JFCre6kASZhAoD/0lzPz6
         P48DXZsJA3S8IP2B6m384YFq219PccMnD1F7Z4yQ9Zn8jZdiGxtPHda/27Rlo6BMpkxt
         jlikQbBxET4vdsTrgRGZD/zoYX3a1FqNrejtoHIvkErWXy61T8bQgtS85V6uG5dHhpr2
         Yr3QTAayCIm+3ox8UC8N9LZQuC8utRyW0yBpLuW2+M6cChshvgQhT/DkfsFLMNBWzDga
         yMvnRyLdVsmgXuypsDJk0F2EU/oG1as+NrglQpzpKTSfDQz7Mb8TohUnXpKf+vsXkvuK
         2g9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Q7Jr0+bPHkU8ftNeZpKa3KTFQgwP6uinanbk/ZSZ5Y=;
        b=ObS35O6qM4/ZP1TWS58wqVGH+eihlCLNIipRGR+6VEwkkpcyvLef5LxHKDkSrzWEZD
         6T/VShtJIvtT7HaCE+/lnNe1uYn64HkFu8Y4LxgWfGcv2Abp1GtyGwagtGpAHfPc2kkE
         eRxOUHc9Jk6v49sUIr+/lcMxKnXmgmc/CwXVM2ZOeyjzEnKNgrKKRvXiWzTpV6FiGdUZ
         lKSQWhYfdePek6V3Uz/nyTzYHff7B9JineNkjIKexnFolX9VD+PNOZJGXZXz602XeMSK
         pKEPcvDLO4lr2+d4FZEtzube1FALgFhx7TdAKKDkVUEqCmnM6Ja5Rbtcm5mehyj8wO36
         NpXA==
X-Gm-Message-State: AOAM532BFbCMviqwsfyS2aO/aXL/tCxpxcvMkCC0u3cqsftA2buT0aCM
        5o4KofQFf9EqhF6NXWpsaF4Y9Q==
X-Google-Smtp-Source: ABdhPJyGomo1KE3dr6wE+c/lE9bV1bSTOoSxs/a0BD5j16Ej011VoEDsrXKg3ISXnCr0oVgI20rXYA==
X-Received: by 2002:a62:7546:: with SMTP id q67mr7433128pfc.210.1595938423067;
        Tue, 28 Jul 2020 05:13:43 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id f29sm18203612pga.59.2020.07.28.05.13.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 05:13:42 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH 1/2] net: phy: Add fwnode helper functions
Date:   Tue, 28 Jul 2020 17:43:19 +0530
Message-Id: <1595938400-13279-2-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
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
index 46b3370..ab8fcea 100644
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

