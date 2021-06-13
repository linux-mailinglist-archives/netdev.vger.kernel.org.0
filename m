Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FFE3A5A06
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 20:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhFMShn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 14:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbhFMShl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 14:37:41 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18B6C061766
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 11:35:39 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a1so17164715lfr.12
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 11:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9wa0R9QgN9v6zwyAsN74gAe/lS7c/EyQi0Wo5c88QIQ=;
        b=iYI+X2r9vC0WdhhxW/B+nSHY3HcB7GRQHhtO9ZBFSqg3YeSeN3g3Rj6Z7ZSpn8Wiwk
         pi7HL4M9WlZSkG7na22qtX5Gg48IsNF0jn9BMNnzmPKU7U/s6nUZb64tpg+nXAzJyz+e
         aQlIa1z4OANPNbuxpUIuXoXZn6CNed/dzoLiLsFQdPYduWNz/KZvAjA52KlhiUA9rE03
         DiNp/PON8nmebtr2t1uJef2B3ASDZG5jQAg1v/3ESHFKCx2I5mw8CWwF8rTSxt5DSxpK
         avcrBJW1qvLlpK99LERkH743dbYVdXY3dyasgNwVeMdJGSTYbGnvjfIpXqXt8v0yVXRj
         OH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wa0R9QgN9v6zwyAsN74gAe/lS7c/EyQi0Wo5c88QIQ=;
        b=f0SS3jr8gxLitl+a/pMRogtp6Zykeai2YfjZ9pw6QrE8JxHo1dZDys2r9tpjMiEMrE
         9bVdYrjxVbx8bN6Bz5cpMp4ibfzAc7E8qrXb9iUKozeQCro6XdPYYTLtCOt+K5DXaldh
         Ooa+9Yv3eKgXqxp4OunbysFRgmAvUWq/kzNjzcqpAk4vFImofqe4WZ/e5AEKiywF6cK7
         3BjCRaI0EHUfYPtCiNeQuRzO0kelDx8Ypg3WfpSe1yE3D2mB4ZLXAlTBlfGk3Q+M6BZD
         FugTWkzA0d1RzV6s6Nf4wMPHdqZ1cV1jSHyG00xxagpkwDZ7Q9DLYLh79KtCdF0FL4hE
         yvyw==
X-Gm-Message-State: AOAM531Ibfl5/IYnqYzZ7DSk7i3yXzj0HZU0BPm6hGVGmkA8Udd3Q0Q+
        g8sUNGoxWVhI3g2tPF63hTRDaA==
X-Google-Smtp-Source: ABdhPJyRgYb2OabDhENZ0arUUjep4AQEyA9ug6T2moxifv2eeShG9wz+kLJR0KFHroHWJrXZFiclZw==
X-Received: by 2002:ac2:51b1:: with SMTP id f17mr1906402lfk.592.1623609338137;
        Sun, 13 Jun 2021 11:35:38 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e12sm904984lfs.157.2021.06.13.11.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 11:35:37 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com,
        Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
Date:   Sun, 13 Jun 2021 20:35:18 +0200
Message-Id: <20210613183520.2247415-2-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210613183520.2247415-1-mw@semihalf.com>
References: <20210613183520.2247415-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introducing ACPI support for the mvmdio driver by adding
acpi_match_table with two entries:

* "MRVL0100" for the SMI operation
* "MRVL0101" for the XSMI mode

Also clk enabling is skipped, because the tables do not contain
such data and clock maintenance relies on the firmware.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 27 +++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index d14762d93640..e66355a0f546 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -17,6 +17,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -281,7 +283,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	struct orion_mdio_dev *dev;
 	int i, ret;
 
-	type = (enum orion_mdio_bus_type)of_device_get_match_data(&pdev->dev);
+	type = (enum orion_mdio_bus_type)device_get_match_data(&pdev->dev);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -336,7 +338,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 			dev_warn(&pdev->dev,
 				 "unsupported number of clocks, limiting to the first "
 				 __stringify(ARRAY_SIZE(dev->clk)) "\n");
-	} else {
+	} else if (!has_acpi_companion(&pdev->dev)) {
 		dev->clk[0] = clk_get(&pdev->dev, NULL);
 		if (PTR_ERR(dev->clk[0]) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
@@ -369,7 +371,12 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		goto out_mdio;
 	}
 
-	ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	if (pdev->dev.of_node)
+		ret = of_mdiobus_register(bus, pdev->dev.of_node);
+	else if (is_acpi_node(pdev->dev.fwnode))
+		ret = acpi_mdiobus_register(bus, pdev->dev.fwnode);
+	else
+		ret = -EINVAL;
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus (%d)\n", ret);
 		goto out_mdio;
@@ -383,6 +390,9 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	if (dev->err_interrupt > 0)
 		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
 
+	if (has_acpi_companion(&pdev->dev))
+		return ret;
+
 out_clk:
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		if (IS_ERR(dev->clk[i]))
@@ -404,6 +414,9 @@ static int orion_mdio_remove(struct platform_device *pdev)
 		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
 	mdiobus_unregister(bus);
 
+	if (has_acpi_companion(&pdev->dev))
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		if (IS_ERR(dev->clk[i]))
 			break;
@@ -421,12 +434,20 @@ static const struct of_device_id orion_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, orion_mdio_match);
 
+static const struct acpi_device_id orion_mdio_acpi_match[] = {
+	{ "MRVL0100", BUS_TYPE_SMI },
+	{ "MRVL0101", BUS_TYPE_XSMI },
+	{ },
+};
+MODULE_DEVICE_TABLE(acpi, orion_mdio_acpi_match);
+
 static struct platform_driver orion_mdio_driver = {
 	.probe = orion_mdio_probe,
 	.remove = orion_mdio_remove,
 	.driver = {
 		.name = "orion-mdio",
 		.of_match_table = orion_mdio_match,
+		.acpi_match_table = ACPI_PTR(orion_mdio_acpi_match),
 	},
 };
 
-- 
2.29.0

