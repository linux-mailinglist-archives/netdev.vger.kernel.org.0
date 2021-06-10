Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90133A3119
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhFJQoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:44:44 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:34439 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhFJQn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:43:57 -0400
Received: by mail-ed1-f50.google.com with SMTP id cb9so33856002edb.1;
        Thu, 10 Jun 2021 09:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GEHy85q0SvH7LpLvuhvoCSHDRdNVkwU8DE0B2plpG7c=;
        b=WSAtPKodO4Z5ZkaBgYVJo0XDPRsYxK6DQU3oyGwYxiknYsEJO6EXFxSmAmXtKLoFWA
         7NzUAvAhZqrxtSX9jO5VTlZegCJMMNP12jmANjKyTXxNQk0FN69kwgaD/3vG4NBvLeec
         v3SA60KAvFEizQPGyrjyfB8WWd01y57umXfQjRRgY2xc0GiR8olqpqHJMaH7qrR6NwZ7
         R7o4FzhW6I51C/Z7YpcAY/y0g1uS4jgl1DWcY5jV903rg03J3MDbx/iDyALUIj2DBxji
         k603sVkxt834meOvbcoKzbA3Njp1KgJMbb4vpEQM3BUQ/+f8HczLwwH78xUeseoH/63y
         F4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GEHy85q0SvH7LpLvuhvoCSHDRdNVkwU8DE0B2plpG7c=;
        b=LSvqoVHY7hAjforSu5iNZ2yaOPMZcbwzHqJs8xg6uYQ8ezjhQtnyzjw2IGZ8uGuDDb
         0pJbWqnB0co6x+frlzqdiBFeCNPu94q5qr/nfJqmbuJq1kC5bcR6BaYTWVTGIqemm7EF
         ca8UNDe53ZsOr4dgDB2vft2HPVnEIx3xK0BLYol3RbunS7Xlmqf48S+kk3x5lyQpbMFX
         QAeBmMUnKeT5WjTDQlWEomB1VGQVLcuG9Q7tB7L29Onz3w5UboNAUJlaRYnH1fkjiKaN
         Ooobff86fsWyLXkQhH+lQzK29/qxB4zGCfwH9NYVwIrRatJDBp8NRlDN22JSk1qx1R7q
         QSDQ==
X-Gm-Message-State: AOAM530J3faB6utOsnnaDiXjkAxLyLU8GgkCWoTmYNraW14HqJLfGap9
        IKk9jilHKUzBux8omuLxg1A=
X-Google-Smtp-Source: ABdhPJwQxi77NYWZzwyeBZ6JRxE2Ln77b8EMAjeDOYvdd+ppU/Jd5pu9ZLv4ODCvaH12uzIOI7YheQ==
X-Received: by 2002:aa7:cc87:: with SMTP id p7mr379277edt.82.1623343244520;
        Thu, 10 Jun 2021 09:40:44 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:44 -0700 (PDT)
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
Subject: [PATCH net-next v8 14/15] net: phylink: Refactor phylink_of_phy_connect()
Date:   Thu, 10 Jun 2021 19:39:16 +0300
Message-Id: <20210610163917.4138412-15-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 39 +--------------------------------------
 1 file changed, 1 insertion(+), 38 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9cc0f69faafe..bb9eeb74f70a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1085,44 +1085,7 @@ EXPORT_SYMBOL_GPL(phylink_connect_phy);
 int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 			   u32 flags)
 {
-	struct device_node *phy_node;
-	struct phy_device *phy_dev;
-	int ret;
-
-	/* Fixed links and 802.3z are handled without needing a PHY */
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
-	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_interface)))
-		return 0;
-
-	phy_node = of_parse_phandle(dn, "phy-handle", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy", 0);
-	if (!phy_node)
-		phy_node = of_parse_phandle(dn, "phy-device", 0);
-
-	if (!phy_node) {
-		if (pl->cfg_link_an_mode == MLO_AN_PHY)
-			return -ENODEV;
-		return 0;
-	}
-
-	phy_dev = of_phy_find_device(phy_node);
-	/* We're done with the phy_node handle */
-	of_node_put(phy_node);
-	if (!phy_dev)
-		return -ENODEV;
-
-	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
-				pl->link_interface);
-	if (ret)
-		return ret;
-
-	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
-	if (ret)
-		phy_detach(phy_dev);
-
-	return ret;
+	return phylink_fwnode_phy_connect(pl, of_fwnode_handle(dn), flags);
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
-- 
2.31.1

