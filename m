Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFC93A409D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhFKK6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:58:39 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:40702 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhFKK5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:49 -0400
Received: by mail-ej1-f47.google.com with SMTP id my49so3911851ejc.7;
        Fri, 11 Jun 2021 03:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sBBrNcRcoCL/xpRYwaZsWGPqaxLMrd3sDw+dNrb6tlk=;
        b=dgrwi5Dx58AvRvZeExRcy9xcRGEWSPLe91ZFgy8Z0EeKbwAC1Mfw+qL8ZluZ/OTWmu
         pbb2fRoi+24LTDG78J9RBaLBxmaCC+8ypVbamgosl3IEbe8nCtceRr1PtktUmfemKbqR
         cxeUH237Uz0k40YMd5Fj9MmvDC1EzHO5CmRQWM0pHuc/FmfNKauN1Ae4u035zoqaNQYI
         7BV3/tTHY/O2HJfvYzncg9nSyIqn8n5u9t+8JvfQhFCpa7wpLUTDHhgBNBt4h2ZuYZHm
         9WfOn3Ap1lfq4BcijRrlc9G7itI43eiADL/alHMaJZb2pGCQZQqBoggjpAkjTkfIRklQ
         VviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBBrNcRcoCL/xpRYwaZsWGPqaxLMrd3sDw+dNrb6tlk=;
        b=QeznC6JGYWJ/yUQqHqyoSYKNy90bGl+vyCibZY3391V/66KF/LxgYvBJd4l/EJ1tVg
         mJVxSWJ62okcJq0Ia2Dhmt1GEOeZ1Ib9nN9NSMsMPDfPkD5zT1urBgt1KRbAEvUu+BGV
         3/QyjiX0sX+LzEYkStl4/T3CLfYEmyB6zApzuFpuhcCcMBpjJGtjHcr/PpbkN32qo6zI
         k0ZdrRdgTY3STKd/dC6y+31/afG15cZpNLWucpT5Lj6pJgD+KurNHoOjq07Liq4Z7ioR
         Dm3vPdcIs6Ibo0B8pao8Vt0W8WwLnHRkA7sF7zE/32MT2QoYjbYvxQOAqBkqYiqS16fF
         iTfw==
X-Gm-Message-State: AOAM532t+gUHR079i7sBaNrjltXHayDCq1wHpFp5ZZNs2CsqOXHtXYrI
        6T7fYuI7v57tL/gv+PHT0wQ=
X-Google-Smtp-Source: ABdhPJwv2XuFbrjqhffULRvlVjikuKQ0GRogBk3O1qcHpUz3ePEKS8RMhqKmOQ2Es4/fxoka7QH7OA==
X-Received: by 2002:a17:906:a458:: with SMTP id cb24mr3110665ejb.482.1623408890803;
        Fri, 11 Jun 2021 03:54:50 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:54:50 -0700 (PDT)
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
Subject: [PATCH net-next v9 04/15] of: mdio: Refactor of_phy_find_device()
Date:   Fri, 11 Jun 2021 13:53:50 +0300
Message-Id: <20210611105401.270673-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Refactor of_phy_find_device() to use fwnode_phy_find_device().

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

 drivers/net/mdio/of_mdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 6ef8b6e40189..0ba1158796d9 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -360,18 +360,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct mdio_device *mdiodev;
-
-	mdiodev = of_mdio_find_device(phy_np);
-	if (!mdiodev)
-		return NULL;
-
-	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-		return to_phy_device(&mdiodev->dev);
-
-	put_device(&mdiodev->dev);
-
-	return NULL;
+	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
 }
 EXPORT_SYMBOL(of_phy_find_device);
 
-- 
2.31.1

