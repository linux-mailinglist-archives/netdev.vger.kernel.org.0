Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40DD1472AC
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 03:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfFPBKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 21:10:09 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:38688 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbfFPBKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 21:10:08 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNilM8025954;
        Sat, 15 Jun 2019 16:46:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=N7Eqj6s2lfu9gv2thWZbJ13/QDK2b/oLzQIcZPDvE2A=;
 b=DWa049fPP2fkTjvpI7TUvax+/t2Fx1ZEQyUdZ139BJhGwndgb7jBuks6S/V9BX1PspWj
 kHlxgMvhbc3IMJtO7gwIwvrf1gFbl1JS+2FwU5dqTwqICDzZi8EKBMA/eGbqtfqOxjxA
 jwKHX3hRmOPuPl8nf5k/dBIJmpXdSpBMoZ8IcYROhAFUbIzEMEf160b3wKa3lrzP/6ja
 hKB6qLiXgkhq+8en+cDLYuf7kaRgdSvubpjKi9SL55Im5IchMlYI2Prm9p2OT3lABBji
 sLWGB8KUBX8jbzAGVlZX2a+VAvrgsYngSi1zA1/dWbR6uiivYyNP8b4BX3mfcy03TG63 8A== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t4w7v1r84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:46:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7Eqj6s2lfu9gv2thWZbJ13/QDK2b/oLzQIcZPDvE2A=;
 b=PpzBLhJt13BJxsoW9cM/EhdEQpfckmS53j8cORWCN2QIbwLHvOcPevghgas3nrsxSLZQ+9E2Y0SZv4W/9JpB2LUGA0XhdXy8oNgQJ2vMcg0k1zq51CRnmMhXmjf0g51rS347EFf5W3FkSbShwezejkUg5lzE/piEKW7lmF5In1w=
Received: from BYAPR07CA0045.namprd07.prod.outlook.com (2603:10b6:a03:60::22)
 by BYAPR07MB6824.namprd07.prod.outlook.com (2603:10b6:a03:128::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.11; Sat, 15 Jun
 2019 23:46:18 +0000
Received: from BY2NAM05FT049.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::204) by BYAPR07CA0045.outlook.office365.com
 (2603:10b6:a03:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.13 via Frontend
 Transport; Sat, 15 Jun 2019 23:46:18 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BY2NAM05FT049.mail.protection.outlook.com (10.152.100.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:46:17 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNkBdk024229
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 19:46:12 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:46:10 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:46:10 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNkAtQ026482;
        Sun, 16 Jun 2019 00:46:10 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 1/6] net: macb: add phylink support
Date:   Sun, 16 Jun 2019 00:46:07 +0100
Message-ID: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
References: <1560642311-25585-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(39850400004)(2980300002)(36092001)(189003)(199004)(2906002)(70586007)(305945005)(336012)(69596002)(70206006)(76130400001)(5660300002)(30864003)(2201001)(4326008)(86362001)(6666004)(356004)(68736007)(478600001)(26826003)(53936002)(107886003)(316002)(110136005)(54906003)(36756003)(16586007)(8676002)(14444005)(81166006)(76176011)(50466002)(81156014)(47776003)(5024004)(8936002)(446003)(48376002)(50226002)(7696005)(51416003)(486006)(7126003)(53416004)(2616005)(11346002)(476003)(186003)(426003)(126002)(77096007)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6824;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f35b66-6c68-44c5-b5f6-08d6f1eba958
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6824;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6824:
X-Microsoft-Antispam-PRVS: <BYAPR07MB682406605A94FD631B8CB702C1E90@BYAPR07MB6824.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: MS57IO1wzVNsHMBpVsKiVHWDorKgqbvsTVsOpVT8iydfkSlGDU3s9cQ9ul7ZThO3OWpwfBu8v0G3Kc+NbfbaLhQqoS0+2ZJHWSryPm7qlGA7Ikr9lBwsf8JSTJKn/yVF0X9Q4elsGNOFutBoee3w7ZCO0GKg29Rw6w49BByO/BKzpGwOHSUkUXDF1rv4LAi/AgCVKJMwB5NEsHxwbqlxdnY6ylcNWXCtA2Q6U0cvsOiFbeTlXgD3Yp47RlkyGMdzTaqCkpq1uiYPNVApiHroLNIXm2xiXh9ytrcDcVc3+WzIkZASzhr9DR/71olc8bda6AsKZk/uAwjW76b7LpOHmfBjg0XQ3OMp7ZBbJxsNw5zO/uwnR/QIdswvuSlUctuA0wQ2iuBPqwcoVblASHyDfXy2SnGtG8NQhW2qlTZDdzA=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:46:17.7773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f35b66-6c68-44c5-b5f6-08d6f1eba958
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6824
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replace phylib API's by phylink API's.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/Kconfig     |   2 +-
 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 288 +++++++++++++----------
 3 files changed, 173 insertions(+), 120 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 1766697c9c5a..d71411a71587 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -22,7 +22,7 @@ if NET_VENDOR_CADENCE
 config MACB
 	tristate "Cadence MACB/GEM support"
 	depends on HAS_DMA
-	select PHYLIB
+	select PHYLINK
 	---help---
 	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
 	  AT91 parts.  This driver also supports the Cadence GEM (Gigabit
diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 00ee5e8e0ff0..35ed13236c8b 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -14,6 +14,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/interrupt.h>
+#include <linux/phylink.h>
 
 #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) || defined(CONFIG_MACB_USE_HWSTAMP)
 #define MACB_EXT_DESC
@@ -1227,6 +1228,8 @@ struct macb {
 	u32	rx_intr_mask;
 
 	struct macb_pm_data pm_data;
+	struct phylink *pl;
+	struct phylink_config pl_config;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f825e3960540..52d5e5efe2ad 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -38,6 +38,7 @@
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
 #include <linux/pm_runtime.h>
+#include <linux/phylink.h>
 #include "macb.h"
 
 #define MACB_RX_BUFFER_SIZE	128
@@ -428,115 +429,146 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 		netdev_err(dev, "adjusting tx_clk failed.\n");
 }
 
-static void macb_handle_link_change(struct net_device *dev)
+static void gem_phylink_validate(struct phylink_config *pl_config,
+				 unsigned long *supported,
+				 struct phylink_link_state *state)
 {
-	struct macb *bp = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
+				phylink_set(mask, 1000baseT_Half);
+				phylink_set(mask, 1000baseT_Half);
+			}
+		}
+	/* fallthrough */
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		break;
+	default:
+		break;
+	}
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
+				      struct phylink_link_state *state)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
+
+	state->speed = bp->speed;
+	state->duplex = bp->duplex;
+	state->link = bp->link;
+	return 1;
+}
+
+static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
+			   const struct phylink_link_state *state)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
 	unsigned long flags;
-	int status_change = 0;
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	if (phydev->link) {
-		if ((bp->speed != phydev->speed) ||
-		    (bp->duplex != phydev->duplex)) {
-			u32 reg;
-
-			reg = macb_readl(bp, NCFGR);
-			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
-			if (macb_is_gem(bp))
-				reg &= ~GEM_BIT(GBE);
+	if (bp->speed != state->speed ||
+	    bp->duplex != state->duplex) {
+		u32 reg;
 
-			if (phydev->duplex)
-				reg |= MACB_BIT(FD);
-			if (phydev->speed == SPEED_100)
-				reg |= MACB_BIT(SPD);
-			if (phydev->speed == SPEED_1000 &&
-			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
-				reg |= GEM_BIT(GBE);
+		reg = macb_readl(bp, NCFGR);
+		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
+		if (macb_is_gem(bp))
+			reg &= ~GEM_BIT(GBE);
 
-			macb_or_gem_writel(bp, NCFGR, reg);
+		if (state->duplex)
+			reg |= MACB_BIT(FD);
+		if (state->speed == SPEED_100)
+			reg |= MACB_BIT(SPD);
+		if (state->speed == SPEED_1000 &&
+		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
+			reg |= GEM_BIT(GBE);
 
-			bp->speed = phydev->speed;
-			bp->duplex = phydev->duplex;
-			status_change = 1;
-		}
-	}
+		macb_or_gem_writel(bp, NCFGR, reg);
 
-	if (phydev->link != bp->link) {
-		if (!phydev->link) {
-			bp->speed = 0;
-			bp->duplex = -1;
-		}
-		bp->link = phydev->link;
+		bp->speed = state->speed;
+		bp->duplex = state->duplex;
 
-		status_change = 1;
+		if (state->link)
+			macb_set_tx_clk(bp->tx_clk, state->speed, netdev);
 	}
 
 	spin_unlock_irqrestore(&bp->lock, flags);
+}
 
-	if (status_change) {
-		if (phydev->link) {
-			/* Update the TX clock rate if and only if the link is
-			 * up and there has been a link change.
-			 */
-			macb_set_tx_clk(bp->tx_clk, phydev->speed, dev);
+static void gem_mac_link_up(struct phylink_config *pl_config, unsigned int mode,
+			    phy_interface_t interface, struct phy_device *phy)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
 
-			netif_carrier_on(dev);
-			netdev_info(dev, "link up (%d/%s)\n",
-				    phydev->speed,
-				    phydev->duplex == DUPLEX_FULL ?
-				    "Full" : "Half");
-		} else {
-			netif_carrier_off(dev);
-			netdev_info(dev, "link down\n");
-		}
-	}
+	bp->link = 1;
+	/* Enable TX and RX */
+	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
+}
+
+static void gem_mac_link_down(struct phylink_config *pl_config,
+			      unsigned int mode, phy_interface_t interface)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
+
+	bp->link = 0;
+	/* Disable TX and RX */
+	macb_writel(bp, NCR,
+		    macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE)));
 }
 
+static const struct phylink_mac_ops gem_phylink_ops = {
+	.validate = gem_phylink_validate,
+	.mac_link_state = gem_phylink_mac_link_state,
+	.mac_config = gem_mac_config,
+	.mac_link_up = gem_mac_link_up,
+	.mac_link_down = gem_mac_link_down,
+};
+
 /* based on au1000_eth. c*/
 static int macb_mii_probe(struct net_device *dev)
 {
 	struct macb *bp = netdev_priv(dev);
 	struct phy_device *phydev;
 	struct device_node *np;
-	int ret, i;
+	int ret;
 
 	np = bp->pdev->dev.of_node;
 	ret = 0;
 
-	if (np) {
-		if (of_phy_is_fixed_link(np)) {
-			bp->phy_node = of_node_get(np);
-		} else {
-			bp->phy_node = of_parse_phandle(np, "phy-handle", 0);
-			/* fallback to standard phy registration if no
-			 * phy-handle was found nor any phy found during
-			 * dt phy registration
-			 */
-			if (!bp->phy_node && !phy_find_first(bp->mii_bus)) {
-				for (i = 0; i < PHY_MAX_ADDR; i++) {
-					phydev = mdiobus_scan(bp->mii_bus, i);
-					if (IS_ERR(phydev) &&
-					    PTR_ERR(phydev) != -ENODEV) {
-						ret = PTR_ERR(phydev);
-						break;
-					}
-				}
-
-				if (ret)
-					return -ENODEV;
-			}
-		}
+	bp->pl_config.dev = &dev->dev;
+	bp->pl_config.type = PHYLINK_NETDEV;
+	bp->pl = phylink_create(&bp->pl_config, of_fwnode_handle(np),
+				bp->phy_interface, &gem_phylink_ops);
+	if (IS_ERR(bp->pl)) {
+		netdev_err(dev,
+			   "error creating PHYLINK: %ld\n", PTR_ERR(bp->pl));
+		return PTR_ERR(bp->pl);
 	}
 
-	if (bp->phy_node) {
-		phydev = of_phy_connect(dev, bp->phy_node,
-					&macb_handle_link_change, 0,
-					bp->phy_interface);
-		if (!phydev)
-			return -ENODEV;
-	} else {
+	ret = phylink_of_phy_connect(bp->pl, np, 0);
+	if (ret == -ENODEV && bp->mii_bus) {
 		phydev = phy_find_first(bp->mii_bus);
 		if (!phydev) {
 			netdev_err(dev, "no PHY found\n");
@@ -544,29 +576,18 @@ static int macb_mii_probe(struct net_device *dev)
 		}
 
 		/* attach the mac to the phy */
-		ret = phy_connect_direct(dev, phydev, &macb_handle_link_change,
-					 bp->phy_interface);
+		ret = phylink_connect_phy(bp->pl, phydev);
 		if (ret) {
 			netdev_err(dev, "Could not attach to PHY\n");
 			return ret;
 		}
 	}
 
-	/* mask with MAC supported features */
-	if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
-		phy_set_max_speed(phydev, SPEED_1000);
-	else
-		phy_set_max_speed(phydev, SPEED_100);
-
-	if (bp->caps & MACB_CAPS_NO_GIGABIT_HALF)
-		phy_remove_link_mode(phydev,
-				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-
 	bp->link = 0;
 	bp->speed = 0;
 	bp->duplex = -1;
 
-	return 0;
+	return ret;
 }
 
 static int macb_mii_init(struct macb *bp)
@@ -2412,7 +2433,7 @@ static int macb_open(struct net_device *dev)
 	netif_carrier_off(dev);
 
 	/* if the phy is not yet register, retry later*/
-	if (!dev->phydev) {
+	if (!bp->pl) {
 		err = -EAGAIN;
 		goto pm_exit;
 	}
@@ -2434,7 +2455,7 @@ static int macb_open(struct net_device *dev)
 	macb_init_hw(bp);
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(bp->pl);
 
 	netif_tx_start_all_queues(dev);
 
@@ -2461,8 +2482,8 @@ static int macb_close(struct net_device *dev)
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
 
-	if (dev->phydev)
-		phy_stop(dev->phydev);
+	if (bp->pl)
+		phylink_stop(bp->pl);
 
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
@@ -3151,6 +3172,29 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
+static int gem_ethtool_get_link_ksettings(struct net_device *netdev,
+					  struct ethtool_link_ksettings *cmd)
+{
+	struct macb *bp = netdev_priv(netdev);
+
+	if (!bp->pl)
+		return -ENOTSUPP;
+
+	return phylink_ethtool_ksettings_get(bp->pl, cmd);
+}
+
+static int
+gem_ethtool_set_link_ksettings(struct net_device *netdev,
+			       const struct ethtool_link_ksettings *cmd)
+{
+	struct macb *bp = netdev_priv(netdev);
+
+	if (!bp->pl)
+		return -ENOTSUPP;
+
+	return phylink_ethtool_ksettings_set(bp->pl, cmd);
+}
+
 static const struct ethtool_ops macb_ethtool_ops = {
 	.get_regs_len		= macb_get_regs_len,
 	.get_regs		= macb_get_regs,
@@ -3158,8 +3202,8 @@ static const struct ethtool_ops macb_ethtool_ops = {
 	.get_ts_info		= ethtool_op_get_ts_info,
 	.get_wol		= macb_get_wol,
 	.set_wol		= macb_set_wol,
-	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
+	.get_link_ksettings     = gem_ethtool_get_link_ksettings,
+	.set_link_ksettings     = gem_ethtool_set_link_ksettings,
 	.get_ringparam		= macb_get_ringparam,
 	.set_ringparam		= macb_set_ringparam,
 };
@@ -3172,8 +3216,8 @@ static const struct ethtool_ops gem_ethtool_ops = {
 	.get_ethtool_stats	= gem_get_ethtool_stats,
 	.get_strings		= gem_get_ethtool_strings,
 	.get_sset_count		= gem_get_sset_count,
-	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
+	.get_link_ksettings     = gem_ethtool_get_link_ksettings,
+	.set_link_ksettings     = gem_ethtool_set_link_ksettings,
 	.get_ringparam		= macb_get_ringparam,
 	.set_ringparam		= macb_set_ringparam,
 	.get_rxnfc			= gem_get_rxnfc,
@@ -3182,17 +3226,16 @@ static const struct ethtool_ops gem_ethtool_ops = {
 
 static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	struct phy_device *phydev = dev->phydev;
 	struct macb *bp = netdev_priv(dev);
 
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	if (!phydev)
+	if (!bp->pl)
 		return -ENODEV;
 
 	if (!bp->ptp_info)
-		return phy_mii_ioctl(phydev, rq, cmd);
+		return phylink_mii_ioctl(bp->pl, rq, cmd);
 
 	switch (cmd) {
 	case SIOCSHWTSTAMP:
@@ -3200,7 +3243,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCGHWTSTAMP:
 		return bp->ptp_info->get_hwtst(dev, rq);
 	default:
-		return phy_mii_ioctl(phydev, rq, cmd);
+		return phylink_mii_ioctl(bp->pl, rq, cmd);
 	}
 }
 
@@ -3700,7 +3743,7 @@ static int at91ether_open(struct net_device *dev)
 			     MACB_BIT(HRESP));
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(lp->pl);
 
 	netif_start_queue(dev);
 
@@ -4062,7 +4105,6 @@ static int macb_probe(struct platform_device *pdev)
 	struct clk *tsu_clk = NULL;
 	unsigned int queue_mask, num_queues;
 	bool native_io;
-	struct phy_device *phydev;
 	struct net_device *dev;
 	struct resource *regs;
 	void __iomem *mem;
@@ -4205,8 +4247,6 @@ static int macb_probe(struct platform_device *pdev)
 	if (err)
 		goto err_out_free_netdev;
 
-	phydev = dev->phydev;
-
 	netif_carrier_off(dev);
 
 	err = register_netdev(dev);
@@ -4217,8 +4257,8 @@ static int macb_probe(struct platform_device *pdev)
 
 	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
 		     (unsigned long)bp);
-
-	phy_attached_info(phydev);
+	if (dev->phydev)
+		phy_attached_info(dev->phydev);
 
 	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
@@ -4230,7 +4270,9 @@ static int macb_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_unregister_mdio:
-	phy_disconnect(dev->phydev);
+	rtnl_lock();
+	phylink_disconnect_phy(bp->pl);
+	rtnl_unlock();
 	mdiobus_unregister(bp->mii_bus);
 	of_node_put(bp->phy_node);
 	if (np && of_phy_is_fixed_link(np))
@@ -4263,13 +4305,18 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
-		if (dev->phydev)
-			phy_disconnect(dev->phydev);
+		if (bp->pl) {
+			rtnl_lock();
+			phylink_disconnect_phy(bp->pl);
+			rtnl_unlock();
+		}
 		mdiobus_unregister(bp->mii_bus);
 		if (np && of_phy_is_fixed_link(np))
 			of_phy_deregister_fixed_link(np);
 		dev->phydev = NULL;
 		mdiobus_free(bp->mii_bus);
+		if (bp->pl)
+			phylink_destroy(bp->pl);
 
 		unregister_netdev(dev);
 		pm_runtime_disable(&pdev->dev);
@@ -4311,8 +4358,9 @@ static int __maybe_unused macb_suspend(struct device *dev)
 		for (q = 0, queue = bp->queues; q < bp->num_queues;
 		     ++q, ++queue)
 			napi_disable(&queue->napi);
-		phy_stop(netdev->phydev);
-		phy_suspend(netdev->phydev);
+		phylink_stop(bp->pl);
+		if (netdev->phydev)
+			phy_suspend(netdev->phydev);
 		spin_lock_irqsave(&bp->lock, flags);
 		macb_reset_hw(bp);
 		spin_unlock_irqrestore(&bp->lock, flags);
@@ -4360,9 +4408,11 @@ static int __maybe_unused macb_resume(struct device *dev)
 		for (q = 0, queue = bp->queues; q < bp->num_queues;
 		     ++q, ++queue)
 			napi_enable(&queue->napi);
-		phy_resume(netdev->phydev);
-		phy_init_hw(netdev->phydev);
-		phy_start(netdev->phydev);
+		if (netdev->phydev) {
+			phy_resume(netdev->phydev);
+			phy_init_hw(netdev->phydev);
+		}
+		phylink_start(bp->pl);
 	}
 
 	bp->macbgem_ops.mog_init_rings(bp);
-- 
2.17.1

