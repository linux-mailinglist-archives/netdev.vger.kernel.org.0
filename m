Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F52A3A40A7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFKK7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:59:18 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:36373 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhFKK6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:58:20 -0400
Received: by mail-ed1-f51.google.com with SMTP id w21so36534844edv.3;
        Fri, 11 Jun 2021 03:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IXumeaU/tuv+0XHp/UXLWEhOz7NAF+OfSKNx2+99ZF4=;
        b=OaKg3z97NLr7/g+LMdUQqJhgDY4g2szDAyDV8F66pz1iRwyNXTsPIWoHrvz3W3c98U
         l+aawXSLjCjU4Up+jk7g2Fdznqig1aN/PRh1oe8B/TcyXFeli2ZH0VerS2WKBhK5MtWX
         Cf7B9NIdrf7HI+NAbpTtOpriqIXyRi2kwaDoMnoBO2quKdgdjsxl2W1s91+x1plLBPzO
         VhNQuIyhPiKqbxFCqVuxwggsdywjjf1yswpX31SB+6ioae6Fjyg9PHbQ8SglBIs0bMnn
         CuGZ+TkK/e7GEjb1CzsPaelTPP1TGhn9V0+trao+GJAQVaJ+J5kgGVJzc2E/pVeTgRDW
         K/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXumeaU/tuv+0XHp/UXLWEhOz7NAF+OfSKNx2+99ZF4=;
        b=pWUmxchPpP7WvwdvaJCTWFjY3ux77xJ4fK7E3zpctSRln4F0j1EQB+uuMMVPDSCK1M
         mykOduWbEX+MxbAZpuHNknatIZRmQ0SqFvN2+4egaDM2LeVLkteVoh20Pd35tnCPcOhb
         j+NoPU4w66R9TArhThAx3xzEYY+yX8ewN5j4DggoxBbjDlvVVOHpS+A51U0zcKxdl5ol
         9AqC4sGqe1YYUrUb2QzyRcxPefrqgdL7vHKo2Cw3qAhmUQnfA4iBEiksEwohnIQsSnnR
         2Sd7f2SfdEilKE14PI6Y/rPFgikdgWfqPVi015YCDNo/gFpBVGicmiayphfBfYD66HTe
         pGNQ==
X-Gm-Message-State: AOAM530+UpxdWHOQvOqgOIxVS1fr0e/FeN8DnPcF54PFgO+UxikBOjd9
        oARcqYhXtjR6QnsHfEBCtZO65kUC4tMCWAOO
X-Google-Smtp-Source: ABdhPJzC7PlY5bKwxjjp5XtGQaecXn9QRJ3NLd4DhvUV3pbF2B32c3xPwPADXSajyxbrI5jarSiOrg==
X-Received: by 2002:a05:6402:1652:: with SMTP id s18mr2923190edx.131.1623408921956;
        Fri, 11 Jun 2021 03:55:21 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:21 -0700 (PDT)
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
Subject: [PATCH net-next v9 13/15] net: phylink: introduce phylink_fwnode_phy_connect()
Date:   Fri, 11 Jun 2021 13:53:59 +0300
Message-Id: <20210611105401.270673-14-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6:
- remove OF check for fixed-link

Changes in v5: None
Changes in v4:
- call phy_device_free() before returning

Changes in v3: None
Changes in v2: None



 drivers/net/phy/phylink.c | 54 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 57 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 96d8e88b4e46..9cc0f69faafe 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2015 Russell King
  */
+#include <linux/acpi.h>
 #include <linux/ethtool.h>
 #include <linux/export.h>
 #include <linux/gpio/consumer.h>
@@ -1125,6 +1126,59 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
+/**
+ * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @fwnode: a pointer to a &struct fwnode_handle.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified @fwnode to the phylink instance specified
+ * by @pl.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags)
+{
+	struct fwnode_handle *phy_fwnode;
+	struct phy_device *phy_dev;
+	int ret;
+
+	/* Fixed links and 802.3z are handled without needing a PHY */
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+	     phy_interface_mode_is_8023z(pl->link_interface)))
+		return 0;
+
+	phy_fwnode = fwnode_get_phy_node(fwnode);
+	if (IS_ERR(phy_fwnode)) {
+		if (pl->cfg_link_an_mode == MLO_AN_PHY)
+			return -ENODEV;
+		return 0;
+	}
+
+	phy_dev = fwnode_phy_find_device(phy_fwnode);
+	/* We're done with the phy_node handle */
+	fwnode_handle_put(phy_fwnode);
+	if (!phy_dev)
+		return -ENODEV;
+
+	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
+				pl->link_interface);
+	if (ret) {
+		phy_device_free(phy_dev);
+		return ret;
+	}
+
+	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
+	if (ret)
+		phy_detach(phy_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
+
 /**
  * phylink_disconnect_phy() - disconnect any PHY attached to the phylink
  *   instance.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index fd2acfd9b597..afb3ded0b691 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -441,6 +441,9 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
 void phylink_mac_change(struct phylink *, bool up);
-- 
2.31.1

