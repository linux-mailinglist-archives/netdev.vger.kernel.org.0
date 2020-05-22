Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61641DF12F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbgEVVbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:31:22 -0400
Received: from foss.arm.com ([217.140.110.172]:42408 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbgEVVbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EFB91480;
        Fri, 22 May 2020 14:31:15 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3E9903F68F;
        Fri, 22 May 2020 14:31:15 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 11/11] net: example xgmac enable extended scanning
Date:   Fri, 22 May 2020 16:30:59 -0500
Message-Id: <20200522213059.1535892-12-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522213059.1535892-1-jeremy.linton@arm.com>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we know the xgmac hardware always has a c45
complaint bus, lets try scanning for c45 capable
phys first. If we fail to find any, then it with
fall back to c22 automatically.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 96ee3bd89983..1d7313031be6 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -263,6 +263,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
+	bus->probe_capabilities = MDIOBUS_C45_FIRST;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);
 
 	/* Set the PHY base address */
-- 
2.26.2

