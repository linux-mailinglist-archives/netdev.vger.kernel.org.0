Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924853A40A0
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFKK6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:58:48 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:35542 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbhFKK5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:55 -0400
Received: by mail-ej1-f42.google.com with SMTP id h24so3941741ejy.2;
        Fri, 11 Jun 2021 03:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hh+84caZ/SbvSAPRvXHMuFBYO9AZu2WHPl7V2NGTs6s=;
        b=pb73Gf73D7D6NvWB8p0mi1JhyJGABUdlzoBytX/ziA1Gq6zZk0Xv4wHWAo5gQKdHFL
         C+CB+RzJee3wPs0DCw1EciqlXaPqhijBZdFt54jP/yT42ldAJur02VHqNa8DTvBxgm62
         nvcf+6MZ5GdtoGAwNhx5wgjzrHVSk0QO36g2K8OQd46zYxJjBn81kcLY068/NNUZT18e
         mnb4urEZ5iJ6C2eyONtFURvUtCmAx4e3iBMhwVVqS+oRM+yLCNuBwBoaoxSO2Tk5Gimz
         3heY+TmnMPhiC0kMP/u8jzzsYwCkHXaeera+dOgZAARMVOR7wM3PY6d9X7O6oppzZZFF
         fgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hh+84caZ/SbvSAPRvXHMuFBYO9AZu2WHPl7V2NGTs6s=;
        b=HUIG1B0r6P84gwKxjphbyQrhmpVQ9NyQFJoubLEZ/JGEVX/zAXt3rsCY+mAlakrl8w
         sXsNRZqjM1eUXy0qt7cA5U/PdonQ6AN0ivKQukU0ES+m/mQLdz4m1emqQSfe00UCohvm
         Pv5gWW8e+GcE5lzoNAUIy1+gj1fUD+lkBD2l6xk/QATScgENNzR6ktrvxMeY0IP+cO4z
         AGHinINhQ9KWjZaRYQMynmYMdH0Jgk3tTR4i/G47RxUXEcM5lTYo7nXQdPEF4XL7mQQ9
         aha0WL6TF8w3MlhqXrLShnO8z67UCtSksArIY4LMdvEnQgoj0fFfTUx+O2vZ6ErdvcX7
         SoNQ==
X-Gm-Message-State: AOAM530p++C3qWp4di8I5TRwVHWhcMP801ptpGHWgudOYLIwGNNiBJLd
        3VO4Ml5DnJMhAxtjPuUzuGE=
X-Google-Smtp-Source: ABdhPJy7tGoqQG3bkQpAHajqNCmv3hTHD2EUDTzVxj/qz8FBR2hinU/Ctq3vjb+zzMRVAq0j+Bvv1w==
X-Received: by 2002:a17:907:96a1:: with SMTP id hd33mr2090740ejc.68.1623408887167;
        Fri, 11 Jun 2021 03:54:47 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:54:46 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
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
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v9 03/15] net: phy: Introduce phy related fwnode functions
Date:   Fri, 11 Jun 2021 13:53:49 +0300
Message-Id: <20210611105401.270673-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Define fwnode_phy_find_device() to iterate an mdiobus and find the
phy device of the provided phy fwnode. Additionally define
device_phy_find_device() to find phy device of provided device.

Define fwnode_get_phy_node() to get phy_node using named reference.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Add more info on legacy DT properties "phy" and "phy-device"
- Redefine fwnode_phy_find_device() to follow of_phy_find_device()

Changes in v2:
- use reverse christmas tree ordering for local variables


 drivers/net/phy/phy_device.c | 62 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 20 ++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index dca454b5c209..786f464216dd 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -2898,6 +2899,67 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL(fwnode_mdio_find_device);
 
+/**
+ * fwnode_phy_find_device - For provided phy_fwnode, find phy_device.
+ *
+ * @phy_fwnode: Pointer to the phy's fwnode.
+ *
+ * If successful, returns a pointer to the phy_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ */
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	struct mdio_device *mdiodev;
+
+	mdiodev = fwnode_mdio_find_device(phy_fwnode);
+	if (!mdiodev)
+		return NULL;
+
+	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
+		return to_phy_device(&mdiodev->dev);
+
+	put_device(&mdiodev->dev);
+
+	return NULL;
+}
+EXPORT_SYMBOL(fwnode_phy_find_device);
+
+/**
+ * device_phy_find_device - For the given device, get the phy_device
+ * @dev: Pointer to the given device
+ *
+ * Refer return conditions of fwnode_phy_find_device().
+ */
+struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return fwnode_phy_find_device(dev_fwnode(dev));
+}
+EXPORT_SYMBOL_GPL(device_phy_find_device);
+
+/**
+ * fwnode_get_phy_node - Get the phy_node using the named reference.
+ * @fwnode: Pointer to fwnode from which phy_node has to be obtained.
+ *
+ * Refer return conditions of fwnode_find_reference().
+ * For ACPI, only "phy-handle" is supported. Legacy DT properties "phy"
+ * and "phy-device" are not supported in ACPI. DT supports all the three
+ * named references to the phy node.
+ */
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *phy_node;
+
+	/* Only phy-handle is used for ACPI */
+	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
+	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
+		return phy_node;
+	phy_node = fwnode_find_reference(fwnode, "phy", 0);
+	if (IS_ERR(phy_node))
+		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
+	return phy_node;
+}
+EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7aa97f4e5387..f9b5fb099fa6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1378,6 +1378,9 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
+struct phy_device *device_phy_find_device(struct device *dev);
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
@@ -1388,6 +1391,23 @@ struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 	return 0;
 }
 
+static inline
+struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
+{
+	return NULL;
+}
+
+static inline struct phy_device *device_phy_find_device(struct device *dev)
+{
+	return NULL;
+}
+
+static inline
+struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
 static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-- 
2.31.1

