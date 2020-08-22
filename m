Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795BD24E933
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 20:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgHVSGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 14:06:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgHVSG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 14:06:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9XuI-00AoMR-9S; Sat, 22 Aug 2020 20:06:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 3/5] net: xgene: Move shared header file into include/linux
Date:   Sat, 22 Aug 2020 20:06:09 +0200
Message-Id: <20200822180611.2576807-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200822180611.2576807-1-andrew@lunn.ch>
References: <20200822180611.2576807-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This header file is currently included into the ethernet driver via a
relative path into the PHY subsystem. This is bad practice, and causes
issues for the upcoming move of the MDIO driver. Move the header file
into include/linux to clean this up.

v2:
Move header to include/linux/mdio

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h     | 2 +-
 drivers/net/phy/mdio-xgene.c                         | 2 +-
 {drivers/net/phy => include/linux/mdio}/mdio-xgene.h | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {drivers/net/phy => include/linux/mdio}/mdio-xgene.h (100%)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
index d35a338120cf..643f5e646740 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.h
@@ -18,6 +18,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
+#include <linux/mdio/mdio-xgene.h>
 #include <linux/module.h>
 #include <net/ip.h>
 #include <linux/prefetch.h>
@@ -26,7 +27,6 @@
 #include "xgene_enet_hw.h"
 #include "xgene_enet_cle.h"
 #include "xgene_enet_ring2.h"
-#include "../../../phy/mdio-xgene.h"
 
 #define ETHER_MIN_PACKET	64
 #define ETHER_STD_PACKET	1518
diff --git a/drivers/net/phy/mdio-xgene.c b/drivers/net/phy/mdio-xgene.c
index 34990eaa3298..461207cdf5d6 100644
--- a/drivers/net/phy/mdio-xgene.c
+++ b/drivers/net/phy/mdio-xgene.c
@@ -11,6 +11,7 @@
 #include <linux/efi.h>
 #include <linux/if_vlan.h>
 #include <linux/io.h>
+#include <linux/mdio/mdio-xgene.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
@@ -18,7 +19,6 @@
 #include <linux/prefetch.h>
 #include <linux/phy.h>
 #include <net/ip.h>
-#include "mdio-xgene.h"
 
 static bool xgene_mdio_status;
 
diff --git a/drivers/net/phy/mdio-xgene.h b/include/linux/mdio/mdio-xgene.h
similarity index 100%
rename from drivers/net/phy/mdio-xgene.h
rename to include/linux/mdio/mdio-xgene.h
-- 
2.28.0

