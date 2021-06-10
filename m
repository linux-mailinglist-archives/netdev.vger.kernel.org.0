Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690933A30F2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhFJQnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFJQmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:55 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2200EC0617AF;
        Thu, 10 Jun 2021 09:40:44 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ci15so174042ejc.10;
        Thu, 10 Jun 2021 09:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OP4A8JlGO2Dl0G4k2AQZx6BKD9WAdkVxy5GnYXxTceM=;
        b=Haz8Rvxk0LJKNvGhRutlpDPeXm316Wy2zEnVdHdcnw51FRnoU2177kL99J02Los+Mj
         D28c1hMiJ+wR6LBiQ5VLY4MKmeuwFKD0BCQUj2CjVTxmAEyxj8JWfObyrC2GkNZbehW2
         u+LmOef1Bjiy01qhpI/epZ3AnTRKBnflmlKBqUkCbk1wr7bXsGoW0zqz48ufww0HlOXZ
         7cPj8S27hzgp7wy1AoSnE+b4PlF8OFj+eR8QnczREi5nRuuiBzI4YUAjucjNTn7N97ck
         737yYA1JcjMJ2CwXGVrnaddKR234jKwm5nxiw45pUoagy/fObrpoAeDEWxb94eG8r6SC
         oM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OP4A8JlGO2Dl0G4k2AQZx6BKD9WAdkVxy5GnYXxTceM=;
        b=Ag08yXuqvt9dmhXmcjj1ouFfGFjeH7Duv2i2X9tKW4hdJB2dbhs8MN5TIkUln7AjRL
         B4/d7+4z1/eIL8r1o0RmUgV9SfLZvhDGxkvxrUf6uUWaPSfeQBdfVIbpCxPfcE3fw9Pk
         apy2j6bxtJ7nB2CFXUm+G7le9WI4tq5caFGI/lxUaYsVLxezti7TSIa3g3iC4GLp9Ykq
         3+w/xmbMx/W325bWF18Vlubnt4UpTtuyXAARBCf2DMFgDWhb8ndJ2XlGYSjNnoUMSvls
         kRdvqk+YL+h1Kpv4hQ0JPRJXXFuHd4kBxxpMoyR4FZNSnkaJIOd+TlPknN9OOPxg2WsB
         /+rw==
X-Gm-Message-State: AOAM533ibhIIRTFkCKjqn4FYV5VcMj+QmSs0pAl8xMGXVmPN0dpTYIPM
        tcYFVmmivXo7PRqX36BgaBw=
X-Google-Smtp-Source: ABdhPJzZW5gzrfQuuDI152iey6UWe7uJ1Wa+K7+hykGv7xDljoQY+QU7h5SfzfJ6fJ1/O8f4Hiz+kQ==
X-Received: by 2002:a17:906:7052:: with SMTP id r18mr445919ejj.449.1623343242563;
        Thu, 10 Jun 2021 09:40:42 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:42 -0700 (PDT)
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
Subject: [PATCH net-next v8 13/15] net: phylink: introduce phylink_fwnode_phy_connect()
Date:   Thu, 10 Jun 2021 19:39:15 +0300
Message-Id: <20210610163917.4138412-14-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
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
---

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

