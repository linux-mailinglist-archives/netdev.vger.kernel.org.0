Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8763920DFEE
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389304AbgF2UlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731680AbgF2TOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51965C00E3C3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:15 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so15105280wme.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nZJ9RrYkX//UjOI/5YYylQYoHuaDDR4YnVJY1VbZiK8=;
        b=GHZrNXAbixM8hIlftssrgQxdDlC2R8smynvTThHUqsGw3QGlkt8NhoPhAOcQQGzRtw
         8UiJW8UelWWaFm3hR3IBZDUiETIQ4cw/d0cKQJ2t1YCJDD+35seh4iu5J6/ZnfNA9Cf2
         0PVuY8rWNQGb4TJy8iFdvM58AtK7sHgm7tkKp+d8JruntQqh4/uEGDPUikx3v8VCVX/X
         t0nKty1pn7Dat78dI2BiItZ4JxBDOUehXZ0nt2E9AXLK4007faqBTbkxlHvbnLr9M2so
         H+SDo8uHBGYBqIx7PHreVr5lgWWgBQR/mjyFndySyTN3eQfiaXuMtvjj/R5CALJQPX52
         cZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZJ9RrYkX//UjOI/5YYylQYoHuaDDR4YnVJY1VbZiK8=;
        b=plEnoWVD+SmIXxzhBPuiwgUWu/7DQGP/GFo80dBfnYsVRCsXMC5wfRiwwqy+ekw+/M
         zpDwMkJTUKU++itbCKBOqLVazPcWCnGu6vjqXUKgLbjc9A2j7QcRZsNwF1LrR1H2UVJH
         QKstSdtaWUkVlf3D8xnvB8AQGTe50qJxYmKwnyGT5wHYyeCCYoLJsybbpj1sK9y3j+ML
         W4JzPd1iTRXHzyvfcE4bXm6O4ZBFKo47HvNiP7U50UHyGONWbm8wmKsSumKSrv+tm+v1
         xSTrNj8TNZj5CAMDXSu0jwLldCeVeEERTTQiYhk41fSxCQlLT+VDc28oV/udY002sNGS
         KZ7g==
X-Gm-Message-State: AOAM532sN/4Dsj/URDx6BroHCry3lSZVDFxjTrLhxG1trx76EMcE7Tpo
        ZQ+KEX0r9v7DG4mC6ZjrUifTXA==
X-Google-Smtp-Source: ABdhPJxPsnR1q89EpF5XRsu5RI2Mrvn6hFviI2UQaVTUzem4LR886XkHZ07utmAJlfbggOLXkkyVfg==
X-Received: by 2002:a7b:c381:: with SMTP id s1mr17268979wmj.25.1593432254093;
        Mon, 29 Jun 2020 05:04:14 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:13 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 02/10] net: ethernet: ixgbe: don't call devm_mdiobus_free()
Date:   Mon, 29 Jun 2020 14:03:38 +0200
Message-Id: <20200629120346.4382-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The idea behind devres is that the release callbacks are called if
probe fails. As we now check the return value of ixgbe_mii_bus_init(),
we can drop the call devm_mdiobus_free() in error path as the release
callback will be called automatically.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index 2fb97967961c..7980d7265e10 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -905,7 +905,6 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 	struct pci_dev *pdev = adapter->pdev;
 	struct device *dev = &adapter->netdev->dev;
 	struct mii_bus *bus;
-	int err = -ENODEV;
 
 	bus = devm_mdiobus_alloc(dev);
 	if (!bus)
@@ -923,7 +922,7 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 	case IXGBE_DEV_ID_X550EM_A_1G_T:
 	case IXGBE_DEV_ID_X550EM_A_1G_T_L:
 		if (!ixgbe_x550em_a_has_mii(hw))
-			goto ixgbe_no_mii_bus;
+			return -ENODEV;
 		bus->read = &ixgbe_x550em_a_mii_bus_read;
 		bus->write = &ixgbe_x550em_a_mii_bus_write;
 		break;
@@ -948,15 +947,8 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 	 */
 	hw->phy.mdio.mode_support = MDIO_SUPPORTS_C45 | MDIO_SUPPORTS_C22;
 
-	err = mdiobus_register(bus);
-	if (!err) {
-		adapter->mii_bus = bus;
-		return 0;
-	}
-
-ixgbe_no_mii_bus:
-	devm_mdiobus_free(dev, bus);
-	return err;
+	adapter->mii_bus = bus;
+	return mdiobus_register(bus);
 }
 
 /**
-- 
2.26.1

