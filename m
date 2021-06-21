Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507B03AF205
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhFURdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhFURde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:33:34 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC73C061787
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:31:17 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p7so31340525lfg.4
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNpW+sLWCmrbUh1r/DSV8Y7jUML0YXJCEAVWQZMs+PY=;
        b=WMeAwcgKrWkfyW/M19Kl6IEgSno6E56auNOFqg5/IEkeSNsSZwAu6+3YK3ehCZdnwu
         NfRa+mJ2m/8SnC4B5yF7Rh+2uvMThmBj1ExsrzTu0oUIyxM8xcwVzkifmyzO4moc4fBE
         Z0UQ1X6bilkW11743K8VP5nUxBKqFTS0ukAnvYRVLHimwFAuIKM3Vb4r+wepVDsSlP2D
         kRc5GGez9jJ9Ww36a1jJg/3qRd9rLnnVcMYtTSuLASWnM+Kf/momVz2wXHY8il6xcrvn
         KZ7UUHT8//N43PlxaG01Ek3Dj8Hmw8k9H+MQXg0CNU1jxjv3MyqDuWN5QqKfy4neTpQm
         ftfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNpW+sLWCmrbUh1r/DSV8Y7jUML0YXJCEAVWQZMs+PY=;
        b=aVl5eo+SULwtpUcYYJ/Fwy8+vDobVVNayir12ZjVMfoT8ztcrVcY4glEYGKFEzQ9BS
         bANw3kdFDu0eHcoVXjCT1vNVTue5oPdO/4dr3t9FGCwmUjYoC/Z290J/UqDxQerIHWlk
         cePo1GWFRao+ccuU3SH3U9ALPdSoijGy6q6rVXvbdJzFsVVKs+HkbQR/bMgZvxk0AI6/
         99kSCylfIpA08pPPUkyFz4FAZOxEr0SebT6xOiNxznyS12XwaX9bAwFS8fblBC/8wuYH
         t0Q7EuUQD4wVOUXaType9a4RAPq0aS/NQjBuiWH9IfoGEug3Z4FyuRSp47HW8xS6EAv1
         Kelw==
X-Gm-Message-State: AOAM532jgr+nTiMp+DT6QoIWDbjSuDNhek8FU7NVicDg+gvQ0f35dEGA
        gH8hw7nv6vBa2+x7gJRLhF7EfA==
X-Google-Smtp-Source: ABdhPJz1hoTxm5sH6sxaZYFo4H8a1qR8SYrT7Bc5r7ocPtv7T7s8KW77JJHgMmWv26cK8kZPBgMseA==
X-Received: by 2002:a05:6512:3e28:: with SMTP id i40mr3036126lfv.417.1624296674179;
        Mon, 21 Jun 2021 10:31:14 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id u11sm1926380lfs.257.2021.06.21.10.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:31:13 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v3 3/6] net/fsl: switch to fwnode_mdiobus_register
Date:   Mon, 21 Jun 2021 19:30:25 +0200
Message-Id: <20210621173028.3541424-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210621173028.3541424-1-mw@semihalf.com>
References: <20210621173028.3541424-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the newly added helper routine
for registering the MDIO bus via fwnode_
interface.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 11 ++---------
 drivers/net/ethernet/freescale/Kconfig      |  4 +---
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 0b68852379da..2d99edc8a647 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/acpi.h>
-#include <linux/acpi_mdio.h>
+#include <linux/fwnode_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mdio.h>
@@ -246,7 +246,6 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
 {
-	struct fwnode_handle *fwnode;
 	struct mdio_fsl_priv *priv;
 	struct resource *res;
 	struct mii_bus *bus;
@@ -291,13 +290,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 
-	fwnode = pdev->dev.fwnode;
-	if (is_of_node(fwnode))
-		ret = of_mdiobus_register(bus, to_of_node(fwnode));
-	else if (is_acpi_node(fwnode))
-		ret = acpi_mdiobus_register(bus, fwnode);
-	else
-		ret = -EINVAL;
+	ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register MDIO bus\n");
 		goto err_registration;
diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 2d1abdd58fab..92a390576b88 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -67,9 +67,7 @@ config FSL_PQ_MDIO
 
 config FSL_XGMAC_MDIO
 	tristate "Freescale XGMAC MDIO"
-	select PHYLIB
-	depends on OF
-	select OF_MDIO
+	depends on FWNODE_MDIO
 	help
 	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and
 	  on the FMan mEMAC (which supports both Clauses 22 and 45)
-- 
2.29.0

