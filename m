Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD803A3105
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhFJQoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:05 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:38831 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhFJQnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:37 -0400
Received: by mail-ed1-f47.google.com with SMTP id d13so20287112edt.5;
        Thu, 10 Jun 2021 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ag0yKOvBPz35E774qJinec6gzeqAN1dw4dMLgUS0S0M=;
        b=k00Eyg+KNHcp27L9EngtjAxDEAM+/ChWX41ETeDr8WHFFmX4JsyY8t/hSC77O9lWQ+
         9VM9AHyXSD237yUvDoPoXsnB0h5wYpd1u8EkE7lx182RzfbB1qudjDTPDegA3cuZFzNg
         +KmC+hV7Qjop6MYodqml4ciy+FrAmkEvhZz9REpd3rShUXLAViF7FwP7WqfGoNer5MwC
         Wo5mZxTZlevAF1Zt68eHFqow/q7cwpcUQC5AojPx7HG7ds3KeHgoGSOcD/jNPBYeKxw3
         X50qhJr6hVw5O+S7TD0GruqRaB9+yqCNhv9Z9wn/+fQg4spYP/i4GSO/EBmZZgmeNS8B
         W8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ag0yKOvBPz35E774qJinec6gzeqAN1dw4dMLgUS0S0M=;
        b=jW7vLKdNl2kpaqYxJ0rKYUmnCkIBHtkmbKVcSksPgrK8F6WgyDI5Ik42zrIchBfOaI
         zks6o8SOE2z5QsMEWXYsUkvdlptKiR39h6mLyh44gEBYZ+lv5QgwS0KUt3a9PE1p+9xa
         m1kiHO3rdKQCy3webTtftoXV0IBDgucXFE3t7LDapfewFBF0xtvql9fKnE8AqJPcdn0U
         LqWtcj30Kq4QTqYqv6E0R/Hif8qkrbgVzxNYGYX2TUIYH8X5DUVShcbSE9uvSkIwWTCD
         r7ImCE2mVJ4ng0yawv2AmvlZI3gove8PIOYELoCQhuZ1837hezpkKThA1kACVoV0SUiE
         Togw==
X-Gm-Message-State: AOAM5322PZJ0zz3qSzgf2gss+I2R9socC/J0kNC6hw5u7c02Y5FMqZpd
        tzKLAZWpyt2kzg30WBBHwWY=
X-Google-Smtp-Source: ABdhPJwR1do5Z1sT8Bu5N6QMCgvOOFKrRwMNFrJ0YWcL3LVcwX4TCoNIMAIhLP9VO1YUdzDASrx+Vg==
X-Received: by 2002:a05:6402:1d0c:: with SMTP id dg12mr340543edb.155.1623343226010;
        Thu, 10 Jun 2021 09:40:26 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:25 -0700 (PDT)
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
Subject: [PATCH net-next v8 05/15] net: phy: Introduce fwnode_get_phy_id()
Date:   Thu, 10 Jun 2021 19:39:07 +0300
Message-Id: <20210610163917.4138412-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Use traditional comparison pattern
- Use GENMASK

Changes in v2: None

 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f651c4feb49f..0ce5c7274930 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -834,6 +834,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 	return 0;
 }
 
+/* Extract the phy ID from the compatible string of the form
+ * ethernet-phy-idAAAA.BBBB.
+ */
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	unsigned int upper, lower;
+	const char *cp;
+	int ret;
+
+	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
+	if (ret)
+		return ret;
+
+	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) != 2)
+		return -EINVAL;
+
+	*phy_id = ((upper & GENMASK(15, 0)) << 16) | (lower & GENMASK(15, 0));
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_get_phy_id);
+
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index f9b5fb099fa6..b60694734b07 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1377,6 +1377,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
@@ -1385,6 +1386,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	return 0;
+}
 static inline
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 {
-- 
2.31.1

