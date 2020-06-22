Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DE720343D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgFVKBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgFVKB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:01:26 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E88C061798
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y20so15095420wmi.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7pEL+pOqyLTkwaRij99JSBZiVqVmOtzJ61ge9c76alE=;
        b=eaQDTmoIva7YgqUT7n4mmFYcgVR8tYbiSv+EsIHLIkQIJviMpTReLXYVtvFOol2q0e
         LdphqNn3acWhpQSuesmQgbP86SDv2CFnYiE9kY21eMu86QB0XYrJByJRId49gHAlMstK
         B4PEF9TayTWp8MPD7056GMzylW6Q4ubJ6zSD88ao0ofMVT8s1OPaucGSs+G1NKXCU30e
         StG0ZCrSCfsoa1hh3rlMOqh0cMq2OsJKG43o3A8mXuwgeMr2MQBldeFEmmaxo9KTVZVr
         OFBWf0C3jGOzn1RbJXOwkVbboUkef6zzBQaj44aHFBunXxesBGFG26tktECmHQNvp0dY
         2sXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pEL+pOqyLTkwaRij99JSBZiVqVmOtzJ61ge9c76alE=;
        b=dMV3Bh7r1j1qwy84wjVD6YQKLYlp/PG2Z4oRXJPdbFqog6zlJ0Iy0KBcGy4o4RCx9x
         wfn2q/rA0bIO0YjikkAiq3hPaBOrcaMM1E5AmxH8QTeMF/mcCL3J6DwnNng0h0lee+BZ
         U8rapamOepfBa5y5uLZ8D/muvlHEjqf4rLBKg7H7lBXteRDWYO07KdqDe0815uq2t8xd
         DE3Lh4F24PBJfw5koLZdehUw17LYsK1kIxHjd/C/ThYQimRKLkRbwS/XqrPmJTetwEIQ
         CSNmXSXDMPM9kL20RO0X7IwTO8M2WDbW9K7TCh+WhsIU8wMjnqjXezk52eaieyoY6wZ5
         CZ7w==
X-Gm-Message-State: AOAM531HuJ+WT0vGOa005flBzRcGUvqU7QZG+ZzYEzdoMLiR1OWs+Hol
        xe2OQdtNxVxBtNAAZfzRnLr3Gw==
X-Google-Smtp-Source: ABdhPJzbn3QUtTBkSaHKKRlQD+NAcxXoZjCO6pjuNjVVzgSeYV529/r6h+a5y21qbFYnMCH6f96pIg==
X-Received: by 2002:a1c:804c:: with SMTP id b73mr699546wmd.59.1592820083830;
        Mon, 22 Jun 2020 03:01:23 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id x205sm16822187wmx.21.2020.06.22.03.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:01:23 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 11/11] net: ethernet: mtk-star-emac: use devm_of_mdiobus_register()
Date:   Mon, 22 Jun 2020 12:00:56 +0200
Message-Id: <20200622100056.10151-12-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622100056.10151-1-brgl@bgdev.pl>
References: <20200622100056.10151-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Shrink the code by using the managed variant of of_mdiobus_register().

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 3e765bdcf9e1..13250553263b 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1389,7 +1389,7 @@ static int mtk_star_mdio_init(struct net_device *ndev)
 	priv->mii->write = mtk_star_mdio_write;
 	priv->mii->priv = priv;
 
-	ret = of_mdiobus_register(priv->mii, mdio_node);
+	ret = devm_of_mdiobus_register(dev, priv->mii, mdio_node);
 
 out_put_node:
 	of_node_put(mdio_node);
@@ -1441,13 +1441,6 @@ static void mtk_star_clk_disable_unprepare(void *data)
 	clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 }
 
-static void mtk_star_mdiobus_unregister(void *data)
-{
-	struct mtk_star_priv *priv = data;
-
-	mdiobus_unregister(priv->mii);
-}
-
 static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
@@ -1549,10 +1542,6 @@ static int mtk_star_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(dev, mtk_star_mdiobus_unregister, priv);
-	if (ret)
-		return ret;
-
 	ret = eth_platform_get_mac_address(dev, ndev->dev_addr);
 	if (ret || !is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
-- 
2.26.1

