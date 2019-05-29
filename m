Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10F2D54F
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfE2F6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:58:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35243 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfE2F6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 01:58:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id t1so688180pgc.2;
        Tue, 28 May 2019 22:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ywGuL0fpUea38Yh+FrqxMHJ7Fe55qCxRV0TOKh6JKvA=;
        b=QAEWPzo0JQUGRXf15PCgKyal6lXWNFrhIxVwJVdXSi8caUBTTZzSNg4FJzajFUEVLC
         7TIcgjZz/y7DzUjHnLO7a8JsM5JB3uRoJOY1d/zsft2fHBfWLOt8+hhnqj4WkjXGvDtE
         1yT4qp7EEA5HmibdkFuRzVHNd1Rcs7ZEFd/xkBdAhmtzjIqySkT5j44F65d7vuEblqLg
         8qfO3YnawgijMi38F/f0t3hpuZUyOpQAOBexeUM94SqDidJWPZAClxfPY/BBU/0rXeUt
         3yF3b6nVQA+LaitbWckiAlHe2Tc3zt7Q69rSW8FvfqdKXwOavCyxa9mce71qVPtH0NNI
         G9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ywGuL0fpUea38Yh+FrqxMHJ7Fe55qCxRV0TOKh6JKvA=;
        b=DiFL55QPMs4x4GCBLkdmMGCGz7amXmGrQ6FlI6GKIeg2R6pqU3tEEhT0ylIjzv/ZfG
         sXt3EjfxulgUthhJYHNHhjaOunO7Bsguke/S4dCk6LqPUdANresxCjtYEkPlutaqY3QG
         GvtRb9T0948lPX/24AH+39ExPOMxpD9kAlu8fY6UuuFHPHXLSpo0MGVmGUpPYcVGu8CK
         oCaJ0AlltG+LvX/sk+B8zrZHf0qi3D1c6eu2+vHVMxMZJEOgiISugHLpipoVd+T7Qqec
         gIaITnKYfPpQBhu5rIl9AUWcGhMhH9/Eic3gdw26gAvjx4nqaVhriHFpOJhUYxjMSFY+
         y+bQ==
X-Gm-Message-State: APjAAAVpVyq90GSBdk5+fD0xHpRQHQ4168n246HS3I46F3ZZGHbslHpr
        fckvq0LpNvsEvcr9lThZo3T1FjEd
X-Google-Smtp-Source: APXvYqzrsC1NVHB9aWQgp7LDPtRhn6QtaAYEQauxrFsgSLXbNM8vECX4kfVkLSURH0bgXQuiaUxD7A==
X-Received: by 2002:a17:90a:9382:: with SMTP id q2mr10151976pjo.131.1559109496612;
        Tue, 28 May 2019 22:58:16 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w1sm19093127pfg.51.2019.05.28.22.58.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 22:58:15 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V4 net-next 5/6] net: mdio: of: Register discovered MII time stampers.
Date:   Tue, 28 May 2019 22:58:06 -0700
Message-Id: <6fd9f36ef91204739dce146c0c1e03c127c6617a.1559109077.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559109076.git.richardcochran@gmail.com>
References: <cover.1559109076.git.richardcochran@gmail.com>
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
index 5e5ab359f6ed..4d0bb9d25018 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -877,6 +877,9 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
+	if (phydev->mii_ts)
+		unregister_mii_timestamper(phydev->mii_ts);
+
 	device_del(&phydev->mdio.dev);
 
 	/* Assert the reset signal */
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index fcf25e32b1ed..98f2516ec3ba 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -43,14 +43,37 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return -EINVAL;
 }
 
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
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
 
@@ -58,11 +81,14 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
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
@@ -91,10 +117,12 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
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
2.11.0

