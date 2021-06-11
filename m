Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701083A408D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhFKK5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhFKK50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:57:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0499C061574;
        Fri, 11 Jun 2021 03:55:09 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a11so3941636ejf.3;
        Fri, 11 Jun 2021 03:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eTXR698wQqI/RILj8csRCRkZjEulpfeWyg79yrkt0a4=;
        b=N6UNfGvBJ1wiAZ/dz+ijh9nlCkPWV1bxVKvXBDG30XojAE7QupHEoxzKJHhxzsZz5f
         O9ZY5womMHxVhbjIFu2YDmSpBk3IAPyX46JvzOalnmaG3LRyBS8tXDbDIyZ06NrNOhoz
         kPNbXoZ+7MzdAQjRiLZfnqP+FVDn/vMCqMfXEMWIAkTSrU8KujHy3mYr+B7tJUm50QZJ
         txyndrhiXc6pyKOPxaW3P2EyRGG/jYu4rUEoaAR5fDIe7vua79CH+Cqwvf7TZWomDPXq
         fTt1pa2r/wVmiNfMFtXdj8t32++Pr1U3OkHzdfHuNJ+YlfdYLb2o30Y7D99XQXmmF60L
         pDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eTXR698wQqI/RILj8csRCRkZjEulpfeWyg79yrkt0a4=;
        b=BfBeENs5S4ZQ03iFTOZ26gZPACTuslz2MqQ4K0fmEWrCBtiOIkCPpF2M0yFcCAuj1d
         0pMKibjzjG3VGQsT2rGOYatlNsE5YTxgwl4T8CqCBqSLPb+i+MQhLqLEbyGYyISCfo2J
         +YDVAYaiJcR55jgsLMyKpVMPhZOm2hekUKR6K25/STkML+U6VmUqIaMt+dRrWSnPBgSB
         6aHxYcjVOJbeSDruZg71qiZYfyY2xX0E7KqqoRyLqixFDLNy17ZvJYzOS6FyyjV4Bmzr
         P0YCWjht+Zw0Zc248BvDm+kY8J7tF0QY6a3fIpuhzfMTUnbL+8Ntr+6ccHUbk6gysZvy
         Yaww==
X-Gm-Message-State: AOAM531HEc0WOjdaHgJXD+vMqpLzgYv4iXDT74mNF8Cjadh7Ba6Bno3O
        djg3Zyb3gRcSsA4M7o70C08=
X-Google-Smtp-Source: ABdhPJz3+vgvLPxy6yt8cqNVf3CsMK0AgpofdGqlBcDP3dxXPG9Vlwe+/PIThK4WIWa0mvSZ64VFbA==
X-Received: by 2002:a17:906:498b:: with SMTP id p11mr3154008eju.295.1623408908484;
        Fri, 11 Jun 2021 03:55:08 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r19sm2492051eds.75.2021.06.11.03.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 03:55:08 -0700 (PDT)
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
Subject: [PATCH net-next v9 09/15] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Fri, 11 Jun 2021 13:53:55 +0300
Message-Id: <20210611105401.270673-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210611105401.270673-1-ciorneiioana@gmail.com>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().
Also, remove the of_find_mii_timestamper() since the fwnode variant is
used instead.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Grant Likely <grant.likely@arm.com>
---

Changes in v9:
- remove the of_find_mii_timestamper() in this patch rather the previous
  one

Changes in v8: None
Changes in v7:
- include fwnode_mdio.h

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None



 drivers/net/mdio/of_mdio.c | 56 +-------------------------------------
 1 file changed, 1 insertion(+), 55 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 17327bbc1de4..8744b1e1c2b1 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -33,24 +33,6 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
-static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-{
-	struct of_phandle_args arg;
-	int err;
-
-	err = of_parse_phandle_with_fixed_args(node, "timestamper", 1, 0, &arg);
-
-	if (err == -ENOENT)
-		return NULL;
-	else if (err)
-		return ERR_PTR(err);
-
-	if (arg.args_count != 1)
-		return ERR_PTR(-EINVAL);
-
-	return register_mii_timestamper(arg.np, arg.args[0]);
-}
-
 int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
 				   struct device_node *child, u32 addr)
 {
@@ -63,43 +45,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
-	struct mii_timestamper *mii_ts;
-	struct phy_device *phy;
-	bool is_c45;
-	int rc;
-	u32 phy_id;
-
-	mii_ts = of_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
-
-	is_c45 = of_device_is_compatible(child,
-					 "ethernet-phy-ieee802.3-c45");
-
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
-
-	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
-	if (rc) {
-		unregister_mii_timestamper(mii_ts);
-		phy_device_free(phy);
-		return rc;
-	}
-
-	/* phy->mii_ts may already be defined by the PHY driver. A
-	 * mii_timestamper probed via the device tree will still have
-	 * precedence.
-	 */
-	if (mii_ts)
-		phy->mii_ts = mii_ts;
-
-	return 0;
+	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
 static int of_mdiobus_register_device(struct mii_bus *mdio,
-- 
2.31.1

