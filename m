Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C7241FD8B
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 19:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhJBSAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhJBSAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:00:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786FAC0613F0;
        Sat,  2 Oct 2021 10:58:24 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y23so17318909lfj.7;
        Sat, 02 Oct 2021 10:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gaRaKrEwRGzaX6BOqH5N99x59hBWZ2AV0k4uy5LgEBg=;
        b=XVjEd3id04JNAEcFq6xWLwCLJBBs9dz7ZxBHHe8ZFV+3zq3Ixc57dzgJVicmiD1gyg
         Rp3Hf6nEGujKg4eAc3kB0FC7qi/DBsVqS2G1KP2HjsisdEDV4n1oVI6Q3GD3TcwEdWCn
         Vso0mHgDlWgjIaZknrRGgqx9HmpQGjGv//IzhFlP/5PxUKjfoEQI4bg9bGr9HHYKmgRy
         uw+JX/TU7/p1EyuxogZ6pgVSCiXmZoBQA3ZUlucrU59e82Irv2+MD78YlPw8gtf/EdUL
         Pi+/Tkcq/8AXpixKc3sv3lbbVxq+0WDUl0xdg4DuN09Ra0AfBdmxB+WyEZaF10K9LHpf
         cjJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gaRaKrEwRGzaX6BOqH5N99x59hBWZ2AV0k4uy5LgEBg=;
        b=2YHvJA2rupJbXN2ydTd4d6pENJ6HfwifED54hnALhrNnCilV6IvKGh+ANNNT8SrA4I
         GsyUkLOWKqKQto6tSUcYAuMddGjQevqP5UAcCrpRmH7V3ZyKSi4FBjGAFmWLZv8SeokD
         RMurqnU754Jz1IW38Wz2t81QP9CYeJSCCIssCx4fgm36Pws8id0o5Z7gN1S8/4dvbtEI
         ii/GyIlGa7ojgJ+gBIkuUEGVZFutXxC5y/vgTHr3YBUPeXUnMhcbetCtluqq2ddG0IAt
         IoDZcTfblHpcGcMsQ8waBrDHsdgrC5gGuCGCS1xw8Wq/BK4vGPiiavHmSgrzRCNPDyNO
         H9Lw==
X-Gm-Message-State: AOAM5337kIvqtpbpxgOi93BaeLpe89YO27gq4IMv90yaE88BMgEtgdWU
        V8RcQnp3Y4ITCCCykg807G8=
X-Google-Smtp-Source: ABdhPJzbVgX6dyWALx2lhYNHzDYPScIyQ0eE4VJQDfdE2jmqtdnaSN17ldCOJ0mJGQ3eP9CjNlyqUA==
X-Received: by 2002:a05:651c:1110:: with SMTP id d16mr4768779ljo.326.1633197502886;
        Sat, 02 Oct 2021 10:58:22 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t26sm1100043lfl.141.2021.10.02.10.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 10:58:22 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 2/2] net: bgmac: support MDIO described in DT
Date:   Sat,  2 Oct 2021 19:58:12 +0200
Message-Id: <20211002175812.14384-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211002175812.14384-1-zajec5@gmail.com>
References: <20211002175812.14384-1-zajec5@gmail.com>
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

This is required for BCM53573 SoC support. That family is sometimes
called Northstar (by marketing?) but is quite different from it. It uses
different CPU(s) and many different hw blocks.

One of shared blocks in BCM53573 is Ethernet controller. Switch however
is not SRAB accessible (as it Northstar) but is MDIO attached.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Update commit message to reference BCM53573. I thought it's worth it
    after Florian's question.
    Florian suggested I may need of_node_put() but it doesn't seem that
    of_get_child_by_name() or of_mdiobus_register() inc. any refcount.
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

