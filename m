Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCB327112D
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgISWbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgISWbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:31:03 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269E4C0613CE;
        Sat, 19 Sep 2020 15:31:03 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id t138so10908428qka.0;
        Sat, 19 Sep 2020 15:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k1VC0bLlr113eP4lGbVnwgieBOJkCTeFf8AM/n1gCow=;
        b=oZQRGbmZNIP8xDhXxJXwaTHJ6TcfISf9HwgXXIBR6DVh+PJJWuz4+zS3vF+mv09p/k
         dWXDWjyj8OxpIkMTs4q7d/u4ChjoMpK0IQItLzWJLPJUW4GacQh3+CBqoAlY+XRHEKXM
         Hg8TMPy0//QJk2KfPPfYOXW9ZPyjOiJG767+7rddNrhGhiL33hu8d0mivBq8bAgrX4DA
         FiLr3BI0b+xLGdqp1g4VJTamg1PmqcHORbHWFAlYd8CHz/vieWUhVS54/SiT2ZYC+54T
         OWCP2WTWZKJ5n4fbhNqTMXzVDQQld2zosW5/MO3Cjj6GL1HmHrRt2W0XZpVXSrXPd54v
         bAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1VC0bLlr113eP4lGbVnwgieBOJkCTeFf8AM/n1gCow=;
        b=iX09ZC1X5t8/CISR2Y4G5JNhRX2bomuj7bUNUQtQOQoTA4YN5J7Bf92uNy6dhWbXsr
         CZRF7r7pFD6VIrDNwjYRDCUUWA2yYobJjDUtS1IhFRiXpfzTjq0lRavuYDuB1gp8nSHB
         PaRKTKQ0W/A69eGVmGMR/3VahYmkRTNzqH9lfqHdtRnUND7yFM5mCbJyRpub+BsIpzgM
         LFeHD3b2dicuVO3SBSmyInaBrCOlMzr9t4Wgh3VtrF5Nb25fRa7zZPUdzFXlpSxei0Gy
         XE5SVKFits2MsTyF+wrQvul1V3THcGbUdyYDS/nCdCSwSgzURJV11vR0HY5hXtogRFsU
         vOcw==
X-Gm-Message-State: AOAM531VVvGvCOOAaGQ+6z8ZUBBzrvR7mLyRcXnwTxtYEYv75HI77oJ+
        aZwG6ZILKMfQFFcuAHojtrM=
X-Google-Smtp-Source: ABdhPJxJXbn9HdM+MNqZCyPh8BZb9Hy6VajZ2BR5r+QbZYC7YHCD81iTR8ZRs+LEUGggk18nm5j/Wg==
X-Received: by 2002:a37:51d5:: with SMTP id f204mr38304587qkb.145.1600554662256;
        Sat, 19 Sep 2020 15:31:02 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id f24sm2581139qkk.136.2020.09.19.15.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 15:31:01 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 3/4] of_net: add mac-address-increment support
Date:   Sun, 20 Sep 2020 00:30:22 +0200
Message-Id: <20200919223026.20803-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919223026.20803-1-ansuelsmth@gmail.com>
References: <20200919223026.20803-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lots of embedded devices use the mac-address of other interface
extracted from nvmem cells and increments it by one or two. Add two
bindings to integrate this and directly use the right mac-address for
the interface. Some example are some routers that use the gmac
mac-address stored in the art partition and increments it by one for the
wifi. mac-address-increment-byte bindings is used to tell what byte of
the mac-address has to be increased (if not defined the last byte is
increased) and mac-address-increment tells how much the byte decided
early has to be increased.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/of/of_net.c | 53 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 6e411821583e..171f5ea6f371 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -45,7 +45,7 @@ int of_get_phy_mode(struct device_node *np, phy_interface_t *interface)
 }
 EXPORT_SYMBOL_GPL(of_get_phy_mode);
 
-static const void *of_get_mac_addr(struct device_node *np, const char *name)
+static void *of_get_mac_addr(struct device_node *np, const char *name)
 {
 	struct property *pp = of_find_property(np, name, NULL);
 
@@ -54,26 +54,31 @@ static const void *of_get_mac_addr(struct device_node *np, const char *name)
 	return NULL;
 }
 
-static const void *of_get_mac_addr_nvmem(struct device_node *np)
+static void *of_get_mac_addr_nvmem(struct device_node *np, int *err)
 {
 	int ret;
 	const void *mac;
 	u8 nvmem_mac[ETH_ALEN];
 	struct platform_device *pdev = of_find_device_by_node(np);
 
-	if (!pdev)
-		return ERR_PTR(-ENODEV);
+	if (!pdev) {
+		*err = -ENODEV;
+		return NULL;
+	}
 
 	ret = nvmem_get_mac_address(&pdev->dev, &nvmem_mac);
 	if (ret) {
 		put_device(&pdev->dev);
-		return ERR_PTR(ret);
+		*err = ret;
+		return NULL;
 	}
 
 	mac = devm_kmemdup(&pdev->dev, nvmem_mac, ETH_ALEN, GFP_KERNEL);
 	put_device(&pdev->dev);
-	if (!mac)
-		return ERR_PTR(-ENOMEM);
+	if (!mac) {
+		*err = -ENOMEM;
+		return NULL;
+	}
 
 	return mac;
 }
@@ -98,24 +103,48 @@ static const void *of_get_mac_addr_nvmem(struct device_node *np)
  * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
  * but is all zeros.
  *
+ * DT can tell the system to increment the mac-address after is extracted by
+ * using:
+ * - mac-address-increment-byte to decide what byte to increase
+ *   (if not defined is increased the last byte)
+ * - mac-address-increment to decide how much to increase
+ *
  * Return: Will be a valid pointer on success and ERR_PTR in case of error.
 */
 const void *of_get_mac_address(struct device_node *np)
 {
-	const void *addr;
+	u32 inc_idx, mac_inc;
+	int ret = 0;
+	u8 *addr;
+
+	/* Check first if the increment byte is present and valid.
+	 * If not set assume to increment the last byte if found.
+	 */
+	if (of_property_read_u32(np, "mac-address-increment-byte", &inc_idx))
+		inc_idx = 5;
+	if (inc_idx > 5)
+		return ERR_PTR(-EINVAL);
 
 	addr = of_get_mac_addr(np, "mac-address");
 	if (addr)
-		return addr;
+		goto found;
 
 	addr = of_get_mac_addr(np, "local-mac-address");
 	if (addr)
-		return addr;
+		goto found;
 
 	addr = of_get_mac_addr(np, "address");
 	if (addr)
-		return addr;
+		goto found;
+
+	addr = of_get_mac_addr_nvmem(np, &ret);
+	if (ret)
+		return ERR_PTR(ret);
+
+found:
+	if (!of_property_read_u32(np, "mac-address-increment", &mac_inc))
+		addr[inc_idx] += mac_inc;
 
-	return of_get_mac_addr_nvmem(np);
+	return addr;
 }
 EXPORT_SYMBOL(of_get_mac_address);
-- 
2.27.0

