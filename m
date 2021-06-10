Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6978B3A30E7
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhFJQmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbhFJQmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:36 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F1C0617A6;
        Thu, 10 Jun 2021 09:40:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id w21so33742690edv.3;
        Thu, 10 Jun 2021 09:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j9eHvw1lqfOl6qU0681eRcLN+MHCzmRQcN2E31ftIDo=;
        b=sSybiEKHNkV6oB3gxfZkR+Jicue8rGl58fooPFQAaHFXby18vVnsP8GJ2AWv/WCtTo
         kFftFCtgK7+WmNowlV/xnJOgeAJ7p7zhj8K6EH0+V0DpIRkccTn3W/FRl99dHLYEJPYh
         pJjWOczWQt8gh+i4pQMQPquU2USV2kmM3ODeA5O2o7ryAyqZhGNTBHMsH+qRiPyjec82
         wx1EhfDgHVYliAznWeBsNbh50gyYlxmw1Ox2hMZBcR1MDSByGS5ibrFOUj1xqjp/sGmM
         0qOC6q6H0xZT7kEK5pqxbXDHt219rYrMf37mmBL5KpxkeROGG8gQJCyKqJEFdPYdtzzg
         GodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j9eHvw1lqfOl6qU0681eRcLN+MHCzmRQcN2E31ftIDo=;
        b=sU32CzUqUEIUY3gWf9haLNM17lyLuTxTwv4RSOjmzuRwZhPvqW/d6JJMYa88DWF+Tf
         d0BcaQ1tR3JhxxxBOT4S5LQRbuHhmyAYq9W7bqSCcisFhHt35AHeuR7qV2UTEQv5OZAF
         xVFSIhLcnLjbEGIOwbWFfyYKkqWMU9JrLE40sBruUfL6WKgor05N/dR9rP5THKq/dq72
         bGQgQmmWdnWcqLE37eOjqYCjkxKgiHtse1EMjXbHot4MTeGsHKIlKsFhu+9c3TZ7viL4
         HI3gLPnNWHlPrKYOhYNFoRBDhCySXjM9prTuViNcDadCbbKnBtdrvP+akl8XlV6SNHOt
         KCbQ==
X-Gm-Message-State: AOAM5303JS15JT/dJSlH0KS6deb6V96oRaVE17cm50R1L/dc0JPScHlQ
        47YfTA+5FN7zpXDGwGUJCJw=
X-Google-Smtp-Source: ABdhPJzqqiYvYm4SQUMr+r5gefyTaByZ70DC1vm/F+7Dp8gRQvSaF6tOC/x1yTfVcspDeAYCdk9w/w==
X-Received: by 2002:a05:6402:543:: with SMTP id i3mr342712edx.173.1623343224091;
        Thu, 10 Jun 2021 09:40:24 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:23 -0700 (PDT)
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
Subject: [PATCH net-next v8 04/15] of: mdio: Refactor of_phy_find_device()
Date:   Thu, 10 Jun 2021 19:39:06 +0300
Message-Id: <20210610163917.4138412-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Refactor of_phy_find_device() to use fwnode_phy_find_device().

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

