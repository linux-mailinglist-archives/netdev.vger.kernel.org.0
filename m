Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF61552057
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbiFTPMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243303AbiFTPMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:13 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BD82644
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:53 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id j22so5610260ljg.0
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/EdxkH4fP0zqJATydAHLXu3mRsR+HclXmov1NWv6EHk=;
        b=SRAAsjAAJry/wEZv46Yv2kZoDW6yLFk+/MU0hcz/UFP8Xv4zTtmkJ4vcKqMOe9yXji
         3DETO2Omf28vecJPHHw/Fr7623f1Locm4Yw//wT56jHgEG1NcFFnR9D5Ukgdu5hSrcF1
         HBGPUoI/6Em9j22nofiO/Go+lz9k+aoHoN5UrWqkq0V79MEgQb56au1V2Si2LLyV8GqP
         +T65+SizTW9QOpqwb4acq7XAEBBFM3v5lOtfNsKJpZT/2g7lsYpxvPQeA0vB4zEels7B
         8QkdtjzAZFlcIHIged0Ox9FX6X3p8cAKagYQwlHChZm9zqAENVkalOXwjY2IsWZxuzUv
         btWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/EdxkH4fP0zqJATydAHLXu3mRsR+HclXmov1NWv6EHk=;
        b=W4210H6JTjIaHnJNevgPNe2faGr82AsuWfRC5HSB9uGEWcg5lYdntbVBuf3/1ExtLv
         zGe0vcGBRuG3LokWDtf0CoUOrt8gA4tsY9My2foKhl7XvGR012XNfof9rNJwmPbPatpY
         Ny/e3mVyaWisH4WCEgDTcc3kdVc3Qv0RRykgXxw6ZHeZbeZgHXByKHiGmO2NnMQq/scw
         mk6ZTIrmAQY2577N7FJWOO/apIVj2UHOK9fiXLLqlg0OEx8n/oWqhe3qH6UhkVlMTE6Z
         n8yKLRNDG3OC7BtTi6YFVl3gWJYDQvoHvdzlx5sgNV30mSgjZs1utjBXKC33Dnsl4lDJ
         PQUw==
X-Gm-Message-State: AJIora+SHIEeSRaEvAp+4NbBZjLmhxovx7dRLz79NoliC7y4aHgg/6B2
        c8U9Pq4ApxYBZJjob8OaUvnStw==
X-Google-Smtp-Source: AGRyM1ucPSh7wwP+2gyt89hjNQtLW/miFV9yXLuoSMYVAKWa4WBZ9gQ6SIX8q98ZpaQMBfD8re+kqg==
X-Received: by 2002:a2e:a268:0:b0:255:9eaf:3422 with SMTP id k8-20020a2ea268000000b002559eaf3422mr11448243ljm.461.1655737371334;
        Mon, 20 Jun 2022 08:02:51 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:50 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 06/12] net: mdio: introduce fwnode_mdiobus_register_device()
Date:   Mon, 20 Jun 2022 17:02:19 +0200
Message-Id: <20220620150225.1307946-7-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation patch to extend MDIO capabilities in the ACPI world,
introduce fwnode_mdiobus_register_device() to register non-PHY
devices on the mdiobus.

While at it, also use the newly introduced fwnode operation in
of_mdiobus_phy_device_register().

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h    |  3 ++
 drivers/net/mdio/fwnode_mdio.c | 29 ++++++++++++++++++++
 drivers/net/mdio/of_mdio.c     | 26 +-----------------
 3 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index 98755b8c6c8a..39d74c5d1bb0 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -16,6 +16,9 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_mdiobus_register_device(struct mii_bus *mdio,
+				   struct fwnode_handle *child, u32 addr);
+
 int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode);
 
 void fwnode_phy_deregister_fixed_link(struct fwnode_handle *fwnode);
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index b1c20c48b6cb..97abfaf88030 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -149,6 +149,35 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
 
+int fwnode_mdiobus_register_device(struct mii_bus *mdio,
+				   struct fwnode_handle *child, u32 addr)
+{
+	struct mdio_device *mdiodev;
+	int rc;
+
+	mdiodev = mdio_device_create(mdio, addr);
+	if (IS_ERR(mdiodev))
+		return PTR_ERR(mdiodev);
+
+	/* Associate the fwnode with the device structure so it
+	 * can be looked up later.
+	 */
+	device_set_node(&mdiodev->dev, child);
+
+	/* All data is now stored in the mdiodev struct; register it. */
+	rc = mdio_device_register(mdiodev);
+	if (rc) {
+		mdio_device_free(mdiodev);
+		fwnode_handle_put(child);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered mdio device %p fwnode at address %i\n",
+		child, addr);
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_device);
+
 /*
  * fwnode_phy_is_fixed_link() and fwnode_phy_register_fixed_link() must
  * support two bindings:
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 409da6e92f7d..522dbee419fe 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -51,31 +51,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 static int of_mdiobus_register_device(struct mii_bus *mdio,
 				      struct device_node *child, u32 addr)
 {
-	struct fwnode_handle *fwnode = of_fwnode_handle(child);
-	struct mdio_device *mdiodev;
-	int rc;
-
-	mdiodev = mdio_device_create(mdio, addr);
-	if (IS_ERR(mdiodev))
-		return PTR_ERR(mdiodev);
-
-	/* Associate the OF node with the device structure so it
-	 * can be looked up later.
-	 */
-	fwnode_handle_get(fwnode);
-	device_set_node(&mdiodev->dev, fwnode);
-
-	/* All data is now stored in the mdiodev struct; register it. */
-	rc = mdio_device_register(mdiodev);
-	if (rc) {
-		mdio_device_free(mdiodev);
-		of_node_put(child);
-		return rc;
-	}
-
-	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
-		child, addr);
-	return 0;
+	return fwnode_mdiobus_register_device(mdio, of_fwnode_handle(child), addr);
 }
 
 /* The following is a list of PHY compatible strings which appear in
-- 
2.29.0

