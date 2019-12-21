Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4811128B23
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfLUTg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:59 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52976 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfLUTg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:56 -0500
Received: by mail-pj1-f66.google.com with SMTP id w23so5626595pjd.2;
        Sat, 21 Dec 2019 11:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0xNn8rOhvQ0q/eVsblgqPKWbsQdxuQgNbseY+ebe5zk=;
        b=uq0WKq1xfqlvfbOs4ZEc3axSxXF+JMndyqB3W5jlkV/S4kNeEf0rhkHQgbiw/+K7OG
         W2dj5oqOBo+71/xGfByUNzFy6PjUO2xgvNGDCbg4R2GwV0cnvKnrx1qbC8J2A+n+1Yhj
         NU+mAAEGBbsTqdWolWNhK2vVKBJ+RQeRAMooyVcaLCySQuapyrfGUWzEo3ErNzgRl0Av
         XDg9VGh1+8G1aNT3NpwCO3V74VauSNYV5+D5A/0cFdWJ+CDyaPVomAFDbHyULKw1byTF
         wLXRMfdJ7QIopVEVUxh2dzdNTFloDum5wQ/heHwsFwyrMbF3t5/CuCTtvysxdjJmY3tL
         nLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xNn8rOhvQ0q/eVsblgqPKWbsQdxuQgNbseY+ebe5zk=;
        b=RCyewUMA5ae/u26wJi43DbbdEhoB0m494x9iWpVq3aRub5vsUW512mw5X3oO7X4FrR
         VBITr5lthio+Y4/6k+aZ+z4uwzTtKrhDfjwM8gvKpEWatmJlqTuwHnqN0lIJAcfwfmFS
         Qz7TvvlZ5FQfCNaOHxzceVTmkW7Ghjt11RsqpB3g8NtioXpdJlg4DGAxquCPR+neA+C6
         gZte3KZPOGynCibfqXJoSBo+q3usufyWzyVD7435YgTZ9AChJVJgLX9CDVc1CsLejcpc
         ZHtt3eJlXgXLSQFVIqv3pA1dGI4nnz7U1Uc8vFQmHcNIICctvbg2rmelvNX4HE3e36w3
         ZiRA==
X-Gm-Message-State: APjAAAWbLwAc29Dv14GGMU2QBBPUxcWYGvR3Qf7PKOXmvdP/v7HrdLlO
        qur3TLc/4UWm6dWooz3sKBS+pX1v
X-Google-Smtp-Source: APXvYqz1s+kvIKDz2ke6NAyqf+OTruYcjql/eZIGGmRQDi1kH5J/Dq128Qx2hAPA+A7rilSV10eB0A==
X-Received: by 2002:a17:902:760e:: with SMTP id k14mr22849124pll.238.1576957015667;
        Sat, 21 Dec 2019 11:36:55 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:54 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH V8 net-next 10/12] net: mdio: of: Register discovered MII time stampers.
Date:   Sat, 21 Dec 2019 11:36:36 -0800
Message-Id: <a9d1e2e89205be6b55f05afcba61b9e32a9b7ff4.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing a PHY node, register its time stamper, if any, and attach
the instance to the PHY device.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
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

