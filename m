Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C8430832
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 07:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaF4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 01:56:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35793 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfEaF4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 01:56:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so5512217pfd.2;
        Thu, 30 May 2019 22:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UEEj1N/0dSQSstX0EbQLzyc84JuhIAmWzwjh/N3OiY0=;
        b=QaudX2ZdvnUkf2S+RxlUrekkdyZ5yVZ3iDozmDqxhERgER007qvWPEDL6PdvoI2oJM
         vAmb/CXIgvneF/3CgCEf+xIkwk9GDhEsuSQCm+Z+DZyqMDZuqDs56Qr09ywqJurqgQTP
         4crm6IY76M0jlJXLB84x1qeo7c+ShFjGg2b+Rq5yCAwHWhJd5GjUxPyOGnHd8P78Xqb/
         6Fh9DTtQc8BzTyZw0TF6CgJDMYUb3nF5P3gUvvGsISIdHgMYP1cvVUWWqlsnFgpRRskQ
         EZypVRlSG0GczT04J6RpoNt9V8mvns3iPRZIH+5YMZIxAwhQ+tpil2cXHG8oy8axsM4E
         V7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UEEj1N/0dSQSstX0EbQLzyc84JuhIAmWzwjh/N3OiY0=;
        b=jMd3CEN2e/r1ouMb1bp6Zlhz3P8/T0vFlQdzhNMartMZmJpwLpUXWVsdnVgDNfwCf0
         lo5jgdPFlN9Nmgj/+jE1gQO8yPnR4Gn2B5KEws9/tbtCy75IECyPb8weptZ79crgixoU
         3/sOR18hkUYjuiMhfwiGRRFXyH1Rz7Ckqtkea0iqWcc20yohFiMzvKRi+mAdHTUD3Ekv
         2/zZVAf9wKVAWYuSmpQbhbMUTkELzOxEvE7m/5e2CNYxhqTiXULD7LyM+vyb27IEM8O4
         qF2BUGz4ywNmUhS4LognZ/axu/5HRuwvzTlQGcsd/ouRJX+jIPKugmpdg6sYEK5uxLI5
         gVAg==
X-Gm-Message-State: APjAAAWsf21bUjje4oCksOB+hfqAIpKMdT4qX87Qnn020b7qjy/fN7jN
        FNj19DUbCubSVO+PuQ6ip3unHc5k
X-Google-Smtp-Source: APXvYqyIbqearZckdiEMeUvWtPxva3ApBM+LX427N2dtOxJJyIqOQJyzliKwad+LIs3rJEtH/k0w+w==
X-Received: by 2002:a17:90a:a790:: with SMTP id f16mr7168411pjq.27.1559282195823;
        Thu, 30 May 2019 22:56:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u2sm4554184pjv.30.2019.05.30.22.56.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 22:56:35 -0700 (PDT)
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
Subject: [PATCH V5 net-next 5/6] net: mdio: of: Register discovered MII time stampers.
Date:   Thu, 30 May 2019 22:56:25 -0700
Message-Id: <a375c2b73288184fe86155707ba150daaf946943.1559281985.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559281985.git.richardcochran@gmail.com>
References: <cover.1559281985.git.richardcochran@gmail.com>
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
index 055087654b2c..aa06ef33df79 100644
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

