Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A1B120EFD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLPQNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:13:45 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44679 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfLPQNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:13:43 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so3963942pgl.11;
        Mon, 16 Dec 2019 08:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fk/lAz5u5bTeJiWcjJdAG/l6a+xrgXpxo5OO1ZyVlo4=;
        b=dBKnQl7hrtQJmTgHYGzc9Ccm9OlOj4DOTY/exGh+k4rkvpkAK4o4pTyDNktQ4/Dfnq
         Dfb6IrvzBB/Qn7vGK0Fi1+ijsyRk3WQR4NjgXA/BZAFLQVWBbbOD3HiYC7Rx7UCr3NFI
         9n04V4pTaBsni4kjNnAkNcdqxszJXjXkBMgd0+QeA0GvCZ6Lk5k1lqLmmxowLvqWv0iS
         pC/94h6bP+DPTZo6JgThVda7pTpSjP3jK6uXEAv90kSsyadRQC+O3UOcV4OsvYD0rI1C
         4bnwu++hEHIouOb1NeDq/+UWirOJwOzKfH99VReb7w7Jmxtm9fkBAiB+H0C4EybyA5UP
         pKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fk/lAz5u5bTeJiWcjJdAG/l6a+xrgXpxo5OO1ZyVlo4=;
        b=o8+ub9VJnua5D5IWKAKGlhzyayh7Mck0uf4+oARsp36Hwvg9fGpsEOzqMRQdM3CRHb
         y1na9D/GM0e8mCXFwlESZxOLAy6cDWstf8jYexA4Xxs1pzJWjBUgD8adgPzN5g3CEnm6
         xkWiNdx8peaBC+9mUrrUi83Lt7xqGLTargC11xCHoqtPChKzZCRHCNxx7D7CKBEweAQK
         Ja5iH6+n9hfAUu9bRhNV5eYhciDEnrhMNbf8HAsiMYpqZ6tEDbgKHRjx/rt/v7WwJIy8
         eBDRzeCdGdoWyviOp/t0PSmtf5P/y8PXzDm/492SMNe34KJFejJNgNaknqr5xY61WNli
         ZNiw==
X-Gm-Message-State: APjAAAWwFo958yzYU5/8jbsxbQfq+6QfwOqHdJ52fObcGmpG/y7/MQ7X
        7wAzG7dKGIxu26L3MmZDvHp7UUwr
X-Google-Smtp-Source: APXvYqzuH4umZLW6ZjzbkvhW7NDnBSOaKSW01dp0BrTUWqQnElGKYV0bxLnleSIhKf6wEz0cMnRNlg==
X-Received: by 2002:a63:c250:: with SMTP id l16mr18591819pgg.38.1576512822069;
        Mon, 16 Dec 2019 08:13:42 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 83sm23478433pgh.12.2019.12.16.08.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:13:41 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V6 net-next 09/11] net: mdio: of: Register discovered MII time stampers.
Date:   Mon, 16 Dec 2019 08:13:24 -0800
Message-Id: <4abb37f501cb51bf84cb5512f637747d73dcd3cc.1576511937.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576511937.git.richardcochran@gmail.com>
References: <cover.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing a PHY node, register its time stamper, if any, and attach
the instance to the PHY device.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/phy_device.c |  3 +++
 drivers/of/of_mdio.c         | 30 +++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ee45838f90c9..debbda61e12b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -881,6 +881,9 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
+	if (phydev->mii_ts)
+		unregister_mii_timestamper(phydev->mii_ts);
+
 	device_del(&phydev->mdio.dev);
 
 	/* Assert the reset signal */
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index c6b87ce2b0cc..0b7aee235813 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -42,14 +42,37 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return -EINVAL;
 }
 
+static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
+{
+	struct of_phandle_args arg;
+	int err;
+
+	err = of_parse_phandle_with_fixed_args(node, "timestamper", 1, 0, &arg);
+
+	if (err == -ENOENT)
+		return NULL;
+	else if (err)
+		return ERR_PTR(err);
+
+	if (arg.args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	return register_mii_timestamper(arg.np, arg.args[0]);
+}
+
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
+	struct mii_timestamper *mii_ts;
 	struct phy_device *phy;
 	bool is_c45;
 	int rc;
 	u32 phy_id;
 
+	mii_ts = of_find_mii_timestamper(child);
+	if (IS_ERR(mii_ts))
+		return PTR_ERR(mii_ts);
+
 	is_c45 = of_device_is_compatible(child,
 					 "ethernet-phy-ieee802.3-c45");
 
@@ -57,11 +80,14 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy))
+	if (IS_ERR(phy)) {
+		unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
+	}
 
 	rc = of_irq_get(child, 0);
 	if (rc == -EPROBE_DEFER) {
+		unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		return rc;
 	}
@@ -90,10 +116,12 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	 * register it */
 	rc = phy_device_register(phy);
 	if (rc) {
+		unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		of_node_put(child);
 		return rc;
 	}
+	phy->mii_ts = mii_ts;
 
 	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
 		child, addr);
-- 
2.20.1

