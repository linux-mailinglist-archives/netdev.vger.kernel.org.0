Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2F755203B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbiFTPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243214AbiFTPMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:13 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886B62738
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:53 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id c4so17680624lfj.12
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7RYmX6hwDcKGiQHQEayVLNO5diQlCW4Y4Deqwz4h8T8=;
        b=J7f4T8YnKHMS90UGD6gxXSuB7x2Hg6/2jTVv/VoOmma8k9lrBsmRLZDs8GHCK0fOcV
         BfFrqQlgSLL+Hur5zSzTBp6invCr+HxiGZaurvWwoK5F2vdD/LaRMryeUG1J0nWVAwaI
         ayTBVBxeU+mi5xMt73C8Z5w5Ou16ed5i/fx0KKQA1bPV5gsiMrQvsH3/D0a7QF0jJqrn
         WwyN8zKdC6FGDZN/rEUxI4jp+/KsTZCOOS9ajE5p1A/E47CRd35v+Fb8m/GgZGPeiT3h
         ZrQEcRXcFHkV+2S+f860tEg+zRuu/zxdVoGHNsbBMRHwmdwXW7UU9W+437UcF/GKLUn5
         v8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7RYmX6hwDcKGiQHQEayVLNO5diQlCW4Y4Deqwz4h8T8=;
        b=Y+a24HDMWNekiqJslFHL4I5snLhoo2DQxy8r2BxFcT+oecPBmsDqRNcWs5ep1JToel
         M6WwSvPVNmNJW1OGvHllXxl+qu8IcSsVX05NOsyXENVY1llilMgb7eeA+K0oUExjsPrQ
         oayEAxp3z24XsmSEwN5SLhJx5/BS51sbbCd9iPgHuloz/b1fMpqxxcA8OoLnxaNw/cSz
         VeDSghR6pzMVbC+vETfH2VFt5PdrWL5Tqyrgf42dlrTvfBcoG/KypaUQYIKmRf6U03od
         Y5lFbP7s3khw/KI1/Ri0HX7wB4t8IEsbPXLdDtfxxo9FmrzAoH6weMhIkdj1B0Rna9jy
         fDVg==
X-Gm-Message-State: AJIora+EheKnt5hksyz0fSQ54M1Gn5kd64buSl51y44s+Fi1HF8vCLBb
        h+EhawQ8zI/nDInGhwSeDMA1ug==
X-Google-Smtp-Source: AGRyM1sWO6KOjp1s3p12U7eWklYIpDeYsTWAh5PfOMGJbed42f5P8rcRGwK+1A3uhwLmCbi9uFJtjg==
X-Received: by 2002:a05:6512:1684:b0:47f:5f27:b006 with SMTP id bu4-20020a056512168400b0047f5f27b006mr7010050lfb.225.1655737372485;
        Mon, 20 Jun 2022 08:02:52 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:52 -0700 (PDT)
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
Subject: [net-next: PATCH 07/12] net: mdio: allow registering non-PHY devices in ACPI world
Date:   Mon, 20 Jun 2022 17:02:20 +0200
Message-Id: <20220620150225.1307946-8-mw@semihalf.com>
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

This patch utilizes the newly added fwnode_mdiobus_register_device
function and enables registration of non-PHY MDIO devices.
For that purpose a helper routine is added, allowing to determine,
whether the device associated to ACPI node is a PHY.
In addition to that update, allow matching child devices' drivers
based on their ACPI ID.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/mdio/acpi_mdio.c | 40 +++++++++++++++++++-
 drivers/net/phy/mdio_bus.c   |  4 ++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index d77c987fda9c..b5d7404afc5e 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -17,6 +17,41 @@
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
+/**
+ * acpi_mdiobus_child_is_phy - check if device associated with fwnode is a PHY.
+ * @fwnode: pointer to MDIO bus child fwnode and is expected to represent ACPI
+ * device object.
+ *
+ * The function returns true if the child node is for a PHY.
+ * It must comprise either:
+ * o Compatible string of "ethernet-phy-idX.X"
+ * o Compatible string of "ethernet-phy-ieee802.3-c45"
+ * o Compatible string of "ethernet-phy-ieee802.3-c22"
+ * o No _HID or _CID fields.
+ */
+static bool acpi_mdiobus_child_is_phy(struct fwnode_handle *child)
+{
+	struct acpi_device *adev = to_acpi_device_node(child);
+	u32 phy_id;
+
+	if (fwnode_get_phy_id(child, &phy_id) != -EINVAL)
+		return true;
+
+	if (fwnode_property_match_string(child, "compatible",
+					 "ethernet-phy-ieee802.3-c45") == 0)
+		return true;
+
+	if (fwnode_property_match_string(child, "compatible",
+					 "ethernet-phy-ieee802.3-c22") == 0)
+		return true;
+
+	/* Default to PHY if no _HID or _CID found in the fwnode. */
+	if (list_empty(&adev->pnp.ids))
+		return true;
+
+	return false;
+}
+
 /**
  * acpi_mdiobus_register - Register mii_bus and create PHYs from the ACPI ASL.
  * @mdio: pointer to mii_bus structure
@@ -47,7 +82,10 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 		if (ret || addr >= PHY_MAX_ADDR)
 			continue;
 
-		ret = fwnode_mdiobus_register_phy(mdio, child, addr);
+		if (acpi_mdiobus_child_is_phy(child))
+			ret = fwnode_mdiobus_register_phy(mdio, child, addr);
+		else
+			ret = fwnode_mdiobus_register_device(mdio, child, addr);
 		if (ret == -ENODEV)
 			dev_err(&mdio->dev,
 				"MDIO device at address %d is missing.\n",
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 8a2dbe849866..b3c2f966be4b 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -989,6 +990,9 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 	if (of_driver_match_device(dev, drv))
 		return 1;
 
+	if (acpi_driver_match_device(dev, drv))
+		return 1;
+
 	if (mdio->bus_match)
 		return mdio->bus_match(dev, drv);
 
-- 
2.29.0

