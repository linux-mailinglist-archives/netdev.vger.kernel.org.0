Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35026458E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIJLxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbgIJLwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 07:52:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2359C06179A
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 04:52:35 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w7so4495778pfi.4
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 04:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=RlW6veRu6Xirp/k0Bt4ZRbq2wJIM5u3P4H+PGBgZ3Wk=;
        b=jbZCZGEUF7G1BWA7gYTqCALc/XwTOw/GXbi3oV62Z0PdFNsLi5KcVZInkAwJk1L8KX
         v7BRKI8qdxV+YkLbrhNJfMXrkJ2RK+hdAHNq0m1yKuAcghdFMZqMrzUrBzYZYymcpMm9
         81aZecCD6RTddtINT80UC0UH8C7CJj+2aB7wnoscbEIOqEfk4yudelqYHuNGL+1ZEv27
         dE3XiUivgVb6FdV0YvZMl2sBIBUfPXYMhhdk3WDwpjH6JzwSjMnIRjk7PHsIdz3fN38k
         T2OxNugf1NIyO+ycaoZFKrQTWMEZ5w6x6eWrx1RL11NXN3D07CuyEAV7yZQGXT+YlBSG
         AuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RlW6veRu6Xirp/k0Bt4ZRbq2wJIM5u3P4H+PGBgZ3Wk=;
        b=Dl51R/0SH6gjWO8QP2MoYqdotrEO5bahicpFHQXuY7F9U+gu0tNwop2XD9BR/95F4/
         l9ddYp5Iuah4IWNyQEsmQchazb7N+RlbUYXuEc65qsgoM8FQL2lqh9tPyUbO3LYK75Ie
         whciZPLLusP6d4YNxwPoCMH70dPbzzREu7bp5aQuoEaAQ6Bccq2+nnVS12G14Ox8XWrL
         cwN6b29K/D/92X4BQFxwfJpZFawDGAXt708gsjQA39IbR8UXBQWrayY35dayKlN7WQUV
         dYJMNkbxp9pxILS+0RFkwvu1+F6xcN5RbBBXg77y1eYhUahJr5k6pxsWLU6MrsqMmHc0
         YMkg==
X-Gm-Message-State: AOAM530Hpz8VJiyY/TCuxMtc1fZZREHs0/IqVua7efCiFH7BKBlSXe7+
        vywM3xcOqsvsaa1l7iVCB3VRxw==
X-Google-Smtp-Source: ABdhPJxYn3Pv4D2VvLWutMXQ7OPbH2UA4N1zYUCy7vF5bqvqZgxERnbpbRRoZI5dFs+Liubf84g8gg==
X-Received: by 2002:a63:5b05:: with SMTP id p5mr4160718pgb.154.1599738755525;
        Thu, 10 Sep 2020 04:52:35 -0700 (PDT)
Received: from prashant-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id gd17sm2009783pjb.6.2020.09.10.04.52.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 04:52:35 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     madalin.bucur@oss.nxp.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        vikas.singh@nxp.com, Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH] net: ethernet: freescale: Add device "fwnode" while MDIO bus get registered
Date:   Thu, 10 Sep 2020 17:22:10 +0530
Message-Id: <1599738730-27080-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For DT case, auto-probe of c45 devices with extended scanning in xgmac_mdio
works well but scanning and registration of these devices (PHY's) fails in
case of ACPI mainly because of MDIO bus "fwnode" is not set appropriately.
This patch is based on https://www.spinics.net/lists/netdev/msg662173.html

This change will update the "fwnode" while MDIO bus get registered and allow
lookup for registered PHYs on MDIO bus from other drivers while probing.

Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 98be51d..8217d17 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -268,6 +268,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
+
+	if (!is_of_node(pdev->dev.fwnode))
+		bus->dev.fwnode = bus->parent->fwnode;
+
 	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
-- 
2.7.4

