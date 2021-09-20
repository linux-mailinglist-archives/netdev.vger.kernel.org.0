Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC01A411495
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbhITMgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbhITMgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:36:20 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17757C061574;
        Mon, 20 Sep 2021 05:34:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b20so8506203lfv.3;
        Mon, 20 Sep 2021 05:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HpQQkC1AOfzWHJl9ss8L2S0RA1Z9VdPx4YiHlvPnYPk=;
        b=jW9QUFzX611Lorga+kmJBdS+JIGjVmywVW5bBnJGaBpp3+Anh2WycRQICKHYmqpVBN
         U9FYZ1XWoTLI9CIjubM787kA6WYtphzt6V87poWVdLTvXbDTN/JRnFYuXYyt6gIcat3I
         97ukMTN+9Ye/mhLgZQ3D4FcCIpAEJ/YSd8Y48HysBz5VKvMgC61FTfxHTG0nYg2mz1Y1
         YuCgAXqLBLGBhYzz2pyT/PlDrt6qNHnJnPrCw4rYv0OA8bQ0bsmXxySabfg5j2WhLUk3
         0eFius8QQdvVosYEjkrxqF6liOb6fOVjOS9zz6P45Feg0XKPcNoAS0iQnH1h5bvphZul
         8vLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HpQQkC1AOfzWHJl9ss8L2S0RA1Z9VdPx4YiHlvPnYPk=;
        b=JO6x0t4/IBOFzKrdgNojR935QBHg8jD6xAAgbK0AHUFOJdXMYo42OfDf1GIF/RL+D6
         OawEyqDUYqKXXo8y2NIDh+BHBvfXZAXhVq31aJZoS/u3pwhasHAPieL+eOP2DGMw8gKf
         Ef69pIhRhtQXTzXEE6T6E5IknxLSY3PO8Vf941cnv/uneikdgVAr+HZwzP3z6Fvc+NS/
         6TzQimhMDTXSy67EpY9u+ZmhZhPQb6pf8yxRWOyrk2eJ4YYbiLLLDPDHi5YK8Pc+DzCB
         2j7IYXlybGiXYwFEDYIuKnIZ3lGQkUeGopEFejKHpjdEWLRZiOxz/7NhPrV/nRk7k5B/
         py6Q==
X-Gm-Message-State: AOAM532531DbYOfvOuQw60ffzvS89j/VHI36xtSdd52Sa7RvKVRceKTv
        x7Ef1K5s1SXi4znsu9oGvJ8=
X-Google-Smtp-Source: ABdhPJxXbr1B932hVzp57IlvjUhWt3JLlpqlZgVyIKEKjcn7W0FHEUSKK3NsNtRsdaVL+hccgrvEiw==
X-Received: by 2002:a05:6512:1049:: with SMTP id c9mr5237881lfb.283.1632141291208;
        Mon, 20 Sep 2021 05:34:51 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b26sm1748454lji.128.2021.09.20.05.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 05:34:49 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next] net: bgmac: support MDIO described in DT
Date:   Mon, 20 Sep 2021 14:34:41 +0200
Message-Id: <20210920123441.9088-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Check ethernet controller DT node for "mdio" subnode and use it with
of_mdiobus_register() when present. That allows specifying MDIO and its
PHY devices in a standard DT based way.

This is required for BCM53573 SoC support which has an MDIO attached
switch.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
index 6ce80cbcb48e..086739e4f40a 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
@@ -10,6 +10,7 @@
 
 #include <linux/bcma/bcma.h>
 #include <linux/brcmphy.h>
+#include <linux/of_mdio.h>
 #include "bgmac.h"
 
 static bool bcma_mdio_wait_value(struct bcma_device *core, u16 reg, u32 mask,
@@ -211,6 +212,7 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
 {
 	struct bcma_device *core = bgmac->bcma.core;
 	struct mii_bus *mii_bus;
+	struct device_node *np;
 	int err;
 
 	mii_bus = mdiobus_alloc();
@@ -229,7 +231,9 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
 	mii_bus->parent = &core->dev;
 	mii_bus->phy_mask = ~(1 << bgmac->phyaddr);
 
-	err = mdiobus_register(mii_bus);
+	np = of_get_child_by_name(core->dev.of_node, "mdio");
+
+	err = of_mdiobus_register(mii_bus, np);
 	if (err) {
 		dev_err(&core->dev, "Registration of mii bus failed\n");
 		goto err_free_bus;
-- 
2.26.2

