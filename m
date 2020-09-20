Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17748271344
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgITJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 05:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgITJ5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 05:57:55 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38061C061755;
        Sun, 20 Sep 2020 02:57:55 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w186so11895694qkd.1;
        Sun, 20 Sep 2020 02:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oGhCCUnRTCTino/zuu9ojrWRDplSxRK5bulENX/nsFs=;
        b=omRBhwApoblQetaK6wIvFMaoNbcKwE3aCrPmkQeTb6VQCcpOrBOB417EIFL4Oyr74e
         pokAqHPb8h2zWULiXuciV+de2+Mc+b9MEtIUx+57Qi7xQyYbsCab64DDMnQzykB9Iyu5
         w87ieJOYwn5g7RPFfPunQhQOcz3Gpv0Y+ppRP36wKDg8oenvP3f7J+Q1OatClKvxbYVP
         iFEUKAhVDbOSXDsqwGyvQ1/4UEHTuR5R1Sfa21IWovwpVCtYVVFvGB0Q/v30fYhyHuVI
         GGLhc89b+QP/NZTZwOD695n857m6u3OprVKfPJv5cqMBqEDPOuKgTZUQY6olaIvniv0Y
         KnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oGhCCUnRTCTino/zuu9ojrWRDplSxRK5bulENX/nsFs=;
        b=uchllN3Fhd+32oZJA/mdBlwv05wKFRU5GRl8uNExyR2v799913+dwBeRFwMfGWoCdo
         hPBdMoEpYDru44V7TYcCPsy6YnR7+PEgLprhj07dTSCQhXZQ9X2do3dXJdezW85Va/st
         k7TbVZov6ocGlJCuAyaSAsevIaBsbOhb4rlD+GeycftjdJ+ms7d2ctsKba0iMILFmnzu
         wWpQZGH9Way87ctOVSR8hHl0401DvxVZslGV9q+/jQqHLU0oWzVCMfqcXbKSM5DB5pRJ
         0GG5O8LnARv8pUMsMW/765l2zjtTQ/iPwPdMlN1NTNVtJOJrSDOfMsuCVe3/Wb09FEMU
         xHHg==
X-Gm-Message-State: AOAM531ly8rpDRamkPTFtqRmZLO0A13tfIetkNkUby0RrQ0tDDE6i6gi
        ZdeEwNQUJcS+fGh3kFFvxw0=
X-Google-Smtp-Source: ABdhPJwKlT3juwz36GeTH9mGGeYK75lJ/GPbrCMq4l3fs1llud3zEd+zx6EVDbFkaIP63Z7MLItNnw==
X-Received: by 2002:a05:620a:145:: with SMTP id e5mr39899279qkn.479.1600595874343;
        Sun, 20 Sep 2020 02:57:54 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w6sm6968323qti.63.2020.09.20.02.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 02:57:53 -0700 (PDT)
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
Subject: [PATCH v3 3/4] of_net: add mac-address-increment support
Date:   Sun, 20 Sep 2020 11:57:21 +0200
Message-Id: <20200920095724.8251-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200920095724.8251-1-ansuelsmth@gmail.com>
References: <20200920095724.8251-1-ansuelsmth@gmail.com>
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
 drivers/of/of_net.c | 57 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index 6e411821583e..bafbc833e659 100644
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
-	const void *mac;
+	void *mac;
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
@@ -98,24 +103,50 @@ static const void *of_get_mac_addr_nvmem(struct device_node *np)
  * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
  * but is all zeros.
  *
+ * DT can tell the system to increment the mac-address after is extracted by
+ * using:
+ * - mac-address-increment-byte to decide what byte to increase
+ *   (if not defined is increased the last byte)
+ * - mac-address-increment to decide how much to increase. The value will
+ *   not overflow to other bytes if the increment is over 255.
+ *   (example 00:01:02:03:04:ff + 1 == 00:01:02:03:04:00)
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
+	if (inc_idx < 3 || inc_idx > 5)
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

