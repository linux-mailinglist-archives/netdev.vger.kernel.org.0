Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB5466CE11
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbjAPRxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbjAPRwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:52:46 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA053B665
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:08 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id s22so30684236ljp.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IG3bSK8xYQLNtQeDwvBcudzQX24jvHqx7mvJjzT4TmQ=;
        b=NPPSzrmDs8k+ezhrh00GcRf0wAc4JHNJtbo8IqBvhwEOUsIlLvXJcg6xefxvubKk0z
         mSZ9AXHXqbGkWG+FWznlDA3jSo7MjMc4i076oDzdYwIFhttJ21lQkxkttGPDJuoQFNQg
         uVEPVEtC/HACLci+urdlpqjvlo17YyhuZUsMDZjlTV4Ju/KPjrBEoZYGbAJPCsx9Xnyf
         HP5UEyFh4z6xfvbDi+L8oW/vKwzAJS94JjdiyweQE60zv/6YhfzIDfZ3KZy8mW2clk7U
         efsWN+ZLLlJggSP3XWYdqSJC54Fyo1uGmEavCzN0f7DEnGjpbSZFcv9v3lHmGNsyJgfT
         XYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IG3bSK8xYQLNtQeDwvBcudzQX24jvHqx7mvJjzT4TmQ=;
        b=aK+Km97RqXMn6xqM4h0yRU2ahvpZEc5JASZUecEzz8DVOwKcYRqBqmaSviArGfbcPA
         u4QWC/DMaNEtLkXzKAROzjMMMFqzAito9MqxVDofX91Dgg89qUT1kjmFeX0d7wNJnraO
         H6GzGZugNB7nj85bdiT5okWw/zXWhbSqC7xPf8N0jLj7rrI03QPo3+w8SDjwAJJ8eA6X
         BxlcLCuqJNED41/t9LuIUuHu+H/zR7Mc6L9nHgwjuM0FAncrSG0kFzc3eVlGuOoTgzJB
         P+3RA5i1dvcqkNM87f/EihHVIzRb8O8uziaDq5JpNGuVmY6Z5a6BCo+2AfvhzY2S+odY
         M1VQ==
X-Gm-Message-State: AFqh2kpOE3kSJs35WClWlpWNDQAeq+KhbOWWUSn8wWmdSKP6kN357yHn
        Qb9nx3TMiCai5izrh733PwB6Gw==
X-Google-Smtp-Source: AMrXdXszKdh7LiiGRlyW8vhmOXa05ofxdBH4JgcNygyrmsBj7cAG1g74BCMnEDuUK1KWC6MWLYhkcA==
X-Received: by 2002:a05:651c:1592:b0:27f:bede:c748 with SMTP id h18-20020a05651c159200b0027fbedec748mr4008770ljq.35.1673890506496;
        Mon, 16 Jan 2023 09:35:06 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id k20-20020a2e8894000000b0028b7f51414fsm707333lji.80.2023.01.16.09.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:35:06 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, mw@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: [net-next: PATCH v4 7/8] net: mdio: introduce fwnode_mdiobus_register_device()
Date:   Mon, 16 Jan 2023 18:34:19 +0100
Message-Id: <20230116173420.1278704-8-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20230116173420.1278704-1-mw@semihalf.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation patch to extend MDIO capabilities in the ACPI world,
introduce fwnode_mdiobus_register_device() to register non-PHY
devices on the mdiobus.

Use the newly introduced routine instead of of_mdiobus_register_device().

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h    |  3 ++
 drivers/net/mdio/fwnode_mdio.c | 29 +++++++++++++++++
 drivers/net/mdio/of_mdio.c     | 33 +-------------------
 3 files changed, 33 insertions(+), 32 deletions(-)

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
index 56f57381ae69..4d712d8873d0 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -187,6 +187,35 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
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
+		device_set_node(&mdiodev->dev, NULL);
+		mdio_device_free(mdiodev);
+		return rc;
+	}
+
+	dev_dbg(&mdio->dev, "registered mdio device %pfw at address %i\n",
+		child, addr);
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register_device);
+
 /*
  * fwnode_phy_is_fixed_link() and fwnode_phy_register_fixed_link() must
  * support two bindings:
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index e6b3a4e251a1..685ac00f9dee 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -48,37 +48,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
-static int of_mdiobus_register_device(struct mii_bus *mdio,
-				      struct device_node *child, u32 addr)
-{
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
-		device_set_node(&mdiodev->dev, NULL);
-		fwnode_handle_put(fwnode);
-		mdio_device_free(mdiodev);
-		return rc;
-	}
-
-	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
-		child, addr);
-	return 0;
-}
-
 /* The following is a list of PHY compatible strings which appear in
  * some DTBs. The compatible string is never matched against a PHY
  * driver, so is pointless. We only expect devices which are not PHYs
@@ -187,7 +156,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		if (of_mdiobus_child_is_phy(child))
 			rc = of_mdiobus_register_phy(mdio, child, addr);
 		else
-			rc = of_mdiobus_register_device(mdio, child, addr);
+			rc = fwnode_mdiobus_register_device(mdio, of_fwnode_handle(child), addr);
 
 		if (rc == -ENODEV)
 			dev_err(&mdio->dev,
-- 
2.29.0

