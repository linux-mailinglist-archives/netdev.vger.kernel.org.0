Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CC01293ED
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLWKD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:03:27 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:51940 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfLWKD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 05:03:27 -0500
Received: from ramsan ([84.195.182.253])
        by xavier.telenet-ops.be with bizsmtp
        id hN3N2100P5USYZQ01N3N9r; Mon, 23 Dec 2019 11:03:24 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1ijKYc-0000eh-Kh; Mon, 23 Dec 2019 11:03:22 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1ijKYc-0001vV-I6; Mon, 23 Dec 2019 11:03:22 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] of: mdio: Add missing inline to of_mdiobus_child_is_phy() dummy
Date:   Mon, 23 Dec 2019 11:03:21 +0100
Message-Id: <20191223100321.7364-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_OF_MDIO=n:

    drivers/net/phy/mdio_bus.c:23:
    include/linux/of_mdio.h:58:13: warning: ‘of_mdiobus_child_is_phy’ defined but not used [-Wunused-function]
     static bool of_mdiobus_child_is_phy(struct device_node *child)
		 ^~~~~~~~~~~~~~~~~~~~~~~

Fix this by adding the missing "inline" keyword.

Fixes: 0aa4d016c043d16a ("of: mdio: export of_mdiobus_child_is_phy")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/of_mdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 79bc82e30c02333d..491a2b7e77c1e906 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -55,7 +55,7 @@ static inline int of_mdio_parse_addr(struct device *dev,
 }
 
 #else /* CONFIG_OF_MDIO */
-static bool of_mdiobus_child_is_phy(struct device_node *child)
+static inline bool of_mdiobus_child_is_phy(struct device_node *child)
 {
 	return false;
 }
-- 
2.17.1

