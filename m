Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CB63A4083
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFKK5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhFKK5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A9C061574;
        Fri, 11 Jun 2021 03:55:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id u24so36580205edy.11;
        Fri, 11 Jun 2021 03:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eoEA0ne+e+Uq92kZIc2aEzTZghhWH4bSeSYhHLqXXxM=;
        b=sHqKdDjFsA1hnSBUEmEiHIUdBEHbS1nZ+f18RdWCwvjfPZZspcwa+AuBN0TVjSGkKY
         5EhZYOSOKc4RHtdYuqt+dfb+1VRUp/aKRdw2vGei2B6HDL8+QoNgZRbjVFrKqSAE8ilj
         AKf+5o6HVnSlWp0oyR+rDWcAyOEfT9/EGLlrlgZpWZmdxmJwlz7Dek/4AcYyjNHX3qQy
         lEAkYoAaOfujma9x2KBt49CdkKOW9nYjR2lJaC9taulnP1nyqDGTQsjuN9Cwb9wNz0Ex
         BuBHvNV8bKH3EIt6Y/GpJO/7eaRbHe9p3cZSGmLzlVXQybOMrpMGfJpAQRsfoIoDwQce
         3o4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eoEA0ne+e+Uq92kZIc2aEzTZghhWH4bSeSYhHLqXXxM=;
        b=cl/qjvSvaKqNLMNp7TrMk9t/QY4o/Ua2/D86GagrJdV6/60p4oEN7LW6RChqZL4+wQ
         Lgqzp9ZZJlpPrKl9dUszkDlJZlVF2yGq2KmGpRZdECfcgCE28lwlqyvgtlQngE4h5LGK
         QfEAjXt/SU2jgwgmGEF+jaTayXOIjyO5KQd6iuif4qyZQtwr73yiWeeSRVTgM9tPxQOX
         lXqZOqDY3+vcwQOYq9F9g8CMDARFN/3kJfWPLkAryuE1V/Wk6qv9afMfjPiVZYhu8x0U
         LrJ1EBNqfe6fd8aG7OQaY2AfanOscsVCiHTB6zzRQyHFUTNO2Cn2rI+5E20hvIRFalCB
         crpQ==
X-Gm-Message-State: AOAM533Be7HkV9HuQeUyqWBWGxUXqaefQ7i0+fmwgoTkrRZeheB+WM5Y
        fIImuqE/xAC6Ue+zb7ifp7N5ARWQd8Nv/jVb
X-Google-Smtp-Source: ABdhPJwno1eLmZq0bmkqOnuc4EzzY7g2QH6QliaI53d1oVjBS9p6U1b9rwsanyvPYg8GEW2SMRoJDQ==
X-Received: by 2002:a05:6402:781:: with SMTP id d1mr3193416edy.32.1623408898584;
        Fri, 11 Jun 2021 03:54:58 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:54:58 -0700 (PDT)
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
Subject: [PATCH net-next v9 06/15] of: mdio: Refactor of_get_phy_id()
Date:   Fri, 11 Jun 2021 13:53:52 +0300
Message-Id: <20210611105401.270673-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

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
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 0ba1158796d9..29f121cba314 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.31.1

