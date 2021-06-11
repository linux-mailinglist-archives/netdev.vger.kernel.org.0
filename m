Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD783A4080
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFKK4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhFKK4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:56:54 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D6CC061574;
        Fri, 11 Jun 2021 03:54:56 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r11so36552000edt.13;
        Fri, 11 Jun 2021 03:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKKxZivIvAKQuHFldXmal3K8gS92b3IVawUyF0IfTDQ=;
        b=RJtdyL3OSC65yGTb/24BXUyBne2A3WnFSGzwORRigI7x9mM8YrUGW+85Pb0hD4PA1M
         VARNR4Y4WBHzvQ0dPT0kxd3Qtw5accaGbq1PoVGZZfDug7KO83mI94S1aph497HglHRT
         nzXvgEsI3AuAKx1L2gCYnnBeEOrt4VH/awWN57rvKfHdBKcVPI6qa4nxJzsIWsAPirU6
         QseAg9mgcfKxFXbJ7J5wHIzF4/HdMJIpSp0q66UUII5cdvcMKHA8ACLilozGFXmC0x6A
         PKs9BIsGhPTwocv9ssjjiKhJkuZAv6T+TinjdNygIrnGwH5N9w7dmdmtkwAXTB2aEwF1
         B01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKKxZivIvAKQuHFldXmal3K8gS92b3IVawUyF0IfTDQ=;
        b=LaGjqlEsdee/Q75oC4WGE6ZuAcDZd2SMsbTY8pz41FwGqG6p4ytgvSNixs1uLB+pok
         /EIKHbaftcJIc8TnqavX0jYzYYeRY+voKiCqRT2/UULjaeLiQ2ExH4+tc2+N2lGic8yk
         tbxgms6K1OsNKYcB04iFldTBLS0HTSqFRQ4RVEn1FowhoeWGj9wN1clUWosORDTQXnpL
         XYu3181TTsGciRJ+P6mKDslk+HRS9z7hjk1M5+2UC76BVpgZnNSeuGg0HptoxaFkCrBi
         9O6O3DE9tmHeUyvLEAroCpxP9KPGQhBWDXcJs/0gVTR/7yscl4YWb5Ip+VlrY39pACyG
         idxw==
X-Gm-Message-State: AOAM530ezKLXR1staSKTlbHW8RH3DBJXmNBP89EYZUNrEaeHthPBlB3Z
        wnXary6/nVi5iSko+SpIlyw=
X-Google-Smtp-Source: ABdhPJyFIxh8LYKNd+bGH273tYpbvYApRzqcuVvYgBZM6Uzm+Gb4CjZRpdu2Akpby0pXDbQ8ExoKcg==
X-Received: by 2002:aa7:d304:: with SMTP id p4mr3025567edq.29.1623408894872;
        Fri, 11 Jun 2021 03:54:54 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:54:54 -0700 (PDT)
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
Subject: [PATCH net-next v9 05/15] net: phy: Introduce fwnode_get_phy_id()
Date:   Fri, 11 Jun 2021 13:53:51 +0300
Message-Id: <20210611105401.270673-6-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
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
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Use traditional comparison pattern
- Use GENMASK

 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 786f464216dd..f7472a0cf771 100644
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

