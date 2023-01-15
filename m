Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBAB66B348
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 18:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjAORt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjAORt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:49:26 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1092CC39;
        Sun, 15 Jan 2023 09:49:24 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so20669144wms.2;
        Sun, 15 Jan 2023 09:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1pHnSVvnYc1fuLFjMyl2/Ut5FQtAdStr7PJnGlkXIg8=;
        b=f1HqlTEwMw3oWjQEXhDxelkjzhaEGD/x80ZF65JZU32scgLJaf55oqHaBNdGL/SOfG
         EDvpJ+hpeFQPV/IMFD4Te5GtgLhSuLzjzGVn5Pi02500Gpwi3GBkcz63VEg31kNlzpCM
         VEQ/8Vdi27WZgpYLskgcIvv9UC9WvuGtRrlMXZg32kFA2+LwUQuniERkGh+aETdhIfsJ
         Z1/4Gz+U98BIXVW6iGsFs74S5cEuCLHSXAb48k8kv7RR5A89eGQA36iHQptwwcDG3JfM
         CLYuVero+HSegxFVpm6R7eu4MfJowJj3+p2rDdzNX8T52Rb040z0WdC3LnOK6oVx+ixe
         4xbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1pHnSVvnYc1fuLFjMyl2/Ut5FQtAdStr7PJnGlkXIg8=;
        b=6Z5WDtD6fxOJiAkyRbiv2QhkvlHz91YjnDzzW2DckaFWmqE0Sr4gqhP7SPdscdFK6J
         NcBTGOm56D0gY5sVj9jPMRWoQyChnbKeXK6C5pGjDdddFmPz55GpyW8OO+6fgaTQ8vSF
         ZiEazwhikNSUagZ8SAnKzuvJTk7QvJVVfD0cBPRQM+nxGYq+r29C9ahvEXev8FInud6n
         laH0J2KGirgup6lygADuh9y/ehNW8usruINclqMaql+cwcWrLzVujCWJg8D3brVQCTjN
         4nEvz2dj2uSJOVXgMej/zMTyor09sziHta9DqxIbJLWpCNornuXZym953R2upG+6dupn
         3T8w==
X-Gm-Message-State: AFqh2krpMM28e2b5+LOrSZ+hQ4IlEORxZw7T7filttPgMYSIvQIM3Uqq
        PSxqoVPYOQOn8zLHdqe9P70=
X-Google-Smtp-Source: AMrXdXsctyXdBH88WErUJebev9bY0+Jw1yhrw4IZYTH5rFkbjPPsVwyVGVJp7Rqo4EVVvPyCtQcUBQ==
X-Received: by 2002:a05:600c:4aa8:b0:3d1:cee0:46d0 with SMTP id b40-20020a05600c4aa800b003d1cee046d0mr64068100wmp.25.1673804963344;
        Sun, 15 Jan 2023 09:49:23 -0800 (PST)
Received: from localhost.localdomain (host-79-51-7-163.retail.telecomitalia.it. [79.51.7.163])
        by smtp.googlemail.com with ESMTPSA id iv14-20020a05600c548e00b003b47b80cec3sm41186261wmb.42.2023.01.15.09.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 09:49:23 -0800 (PST)
From:   Pierluigi Passaro <pierluigi.passaro@gmail.com>
X-Google-Original-From: Pierluigi Passaro <pierluigi.p@variscite.com>
To:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: [PATCH] net: fec: manage corner deferred probe condition
Date:   Sun, 15 Jan 2023 18:49:10 +0100
Message-Id: <20230115174910.18353-1-pierluigi.p@variscite.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For dual fec interfaces, external phys can only be configured by fec0.
When the function of_mdiobus_register return -EPROBE_DEFER, the driver
is lately called to manage fec1, which wrongly register its mii_bus as
fec0_mii_bus.
When fec0 retry the probe, the previous assignement prevent the MDIO bus
registration.
Use a static boolean to trace the orginal MDIO bus deferred probe and
prevent further registrations until the fec0 registration completed
succesfully.

Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 644f3c963730..b4ca3bd4283f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2284,6 +2284,18 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	int err = -ENXIO;
 	u32 mii_speed, holdtime;
 	u32 bus_freq;
+	static bool wait_for_mdio_bus = false;
+
+	bus_freq = 2500000; /* 2.5MHz by default */
+	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
+	if (node) {
+		wait_for_mdio_bus = false;
+		of_property_read_u32(node, "clock-frequency", &bus_freq);
+		suppress_preamble = of_property_read_bool(node,
+							  "suppress-preamble");
+	}
+	if (wait_for_mdio_bus)
+		return -EPROBE_DEFER;
 
 	/*
 	 * The i.MX28 dual fec interfaces are not equal.
@@ -2311,14 +2323,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	bus_freq = 2500000; /* 2.5MHz by default */
-	node = of_get_child_by_name(pdev->dev.of_node, "mdio");
-	if (node) {
-		of_property_read_u32(node, "clock-frequency", &bus_freq);
-		suppress_preamble = of_property_read_bool(node,
-							  "suppress-preamble");
-	}
-
 	/*
 	 * Set MII speed (= clk_get_rate() / 2 * phy_speed)
 	 *
@@ -2389,6 +2393,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	fep->mii_bus->parent = &pdev->dev;
 
 	err = of_mdiobus_register(fep->mii_bus, node);
+	if (err == -EPROBE_DEFER)
+		wait_for_mdio_bus = true;
 	if (err)
 		goto err_out_free_mdiobus;
 	of_node_put(node);
-- 
2.37.2

