Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 999E564888
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfGJOiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:38:00 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:34754 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbfGJOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:38:00 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AEbZEb002915;
        Wed, 10 Jul 2019 07:37:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=BrKZqfKKM2jgKWKO5+SHMdcBctdtDY2DXCmb6oghWKA=;
 b=g5JTfkfVrcfGOhTmzvpPClByAED/l5H+iGEeo1ZAFakOv5oGMHjG4CqY7Kpcf/Arq/QJ
 hicS+M5Ocjt4GOUZJiTFo2daP3dbtpUMQOHzPTOmLo1yziELAfq+jJ5mlorxH6kVV49R
 ZNvL65uhuCrQwj5X/cp5XjUjZNjKjaGemT8b4Kl1G0JV/t9r8atRFCnTm8iN15LQkOj+
 QivozuRvqc702M8K187syihfra6P+5+ZMWSX7/eYu+jMQOdCHPYJxDEtPIZCTqRxH6Da
 EjmQ5MvpiA9v/mm4h3LdYfHD/Ev3YD+VsQjTd/Z2e9jq21p0QODYjVQe6d0qvc1r5MFz 5w== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2056.outbound.protection.outlook.com [104.47.41.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2tjr6vr3t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 07:37:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrKZqfKKM2jgKWKO5+SHMdcBctdtDY2DXCmb6oghWKA=;
 b=qShnICScBflb04l0UHuO9744QJLmMG6BZqBFzn4g3QbCwJ+LpbQKNdCxox9PTrB+WdjiJzjc+o9Ljh9I1fRtUwcY3K4WLobT7lCW4OgBEKpk0uohh2WcfM3M36nnP5P31MHiYxIuOi2kxTXkcwVUuNcYlz7iovzig0mVV4754W0=
Received: from BYAPR07CA0016.namprd07.prod.outlook.com (2603:10b6:a02:bc::29)
 by BL0PR07MB5441.namprd07.prod.outlook.com (2603:10b6:208:26::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2052.19; Wed, 10 Jul
 2019 14:37:43 +0000
Received: from DM3NAM05FT044.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::207) by BYAPR07CA0016.outlook.office365.com
 (2603:10b6:a02:bc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2052.18 via Frontend
 Transport; Wed, 10 Jul 2019 14:37:42 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT044.mail.protection.outlook.com (10.152.98.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2052.8 via Frontend Transport; Wed, 10 Jul 2019 14:37:41 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEbcBY021568
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 10 Jul 2019 07:37:40 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 10 Jul 2019 16:37:37 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 10 Jul 2019 16:37:37 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEbbJJ000417;
        Wed, 10 Jul 2019 15:37:37 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <piotrs@cadence.com>, <aniljoy@cadence.com>,
        <arthurm@cadence.com>, <stevenh@cadence.com>,
        <pthombar@cadence.com>, <mparab@cadence.com>
Subject: [PATCH v6 1/4] net: macb: add phylink support
Date:   Wed, 10 Jul 2019 15:37:34 +0100
Message-ID: <1562769454-351-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(2980300002)(36092001)(199004)(189003)(186003)(26005)(76130400001)(70206006)(76176011)(426003)(30864003)(7126003)(107886003)(446003)(476003)(126002)(11346002)(51416003)(2616005)(2201001)(48376002)(4326008)(486006)(70586007)(86362001)(47776003)(50466002)(336012)(7696005)(5024004)(8676002)(246002)(36756003)(2906002)(50226002)(53416004)(110136005)(54906003)(8936002)(316002)(14444005)(26826003)(6666004)(16586007)(356004)(478600001)(7636002)(305945005)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR07MB5441;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92a93926-928e-49d8-8800-08d705442a68
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BL0PR07MB5441;
X-MS-TrafficTypeDiagnostic: BL0PR07MB5441:
X-Microsoft-Antispam-PRVS: <BL0PR07MB5441AF1EF7AB31A3083C70D6C1F00@BL0PR07MB5441.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-Forefront-PRVS: 0094E3478A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /qoHH2ddDkPe2OT0hVT7IMarOHeQpQ7gAWXzdihPMUWEeVDyT9DOPfxWGlzDu9DIRuEs/GU67fgZT7jMK4cScuHhVOAENNC/68F0ghw+qpPkJLPwS3slJdDzmKoCm6ZnTSFj/ZlQnYNvUpbO/8Ej98olYMQdzFj+zsizLFitPhn7fxazzUHFYteDE98C4Bu0iSMB2GAD91gK7MCCh/Af3fNjI+FNJMhgO52M61BRwGVFxfychHLKNLTP6+NA5DunYTbs1RwfKrbbCx9gjAwg8MEowucGdfj4jXk09ZZvz5XPCXZcRf5OaYMQc5edWp9+YvFIfKq6uK+6w4afyIUtCKRmZDoHs8VphQc76aGMHr0aD5et9/OAJAoA9NR6iw4c1P7UCBjomRtLOAvjR+YnfEvTx8zcnwr20NzavIt46Xw=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2019 14:37:41.8819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a93926-928e-49d8-8800-08d705442a68
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB5441
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=980 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replace phylib API's by phylink API's.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/Kconfig     |   2 +-
 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 332 +++++++++++++----------
 3 files changed, 187 insertions(+), 150 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index f4b3bd85dfe3..53b50c24d9c9 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -22,7 +22,7 @@ if NET_VENDOR_CADENCE
 config MACB
 	tristate "Cadence MACB/GEM support"
 	depends on HAS_DMA && COMMON_CLK
-	select PHYLIB
+	select PHYLINK
 	---help---
 	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
 	  AT91 parts.  This driver also supports the Cadence GEM (Gigabit
diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 03983bd46eef..a4007057b35e 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -11,6 +11,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/interrupt.h>
+#include <linux/phylink.h>
 
 #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) || defined(CONFIG_MACB_USE_HWSTAMP)
 #define MACB_EXT_DESC
@@ -1232,6 +1233,8 @@ struct macb {
 	u32	rx_intr_mask;
 
 	struct macb_pm_data pm_data;
+	struct phylink *pl;
+	struct phylink_config pl_config;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5ca17e62dc3e..ce064eb9252a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -36,6 +36,7 @@
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
 #include <linux/pm_runtime.h>
+#include <linux/phylink.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -433,115 +434,160 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
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
+		if (!macb_is_gem(bp))
+			goto empty_set;
+		break;
+	default:
+		break;
+	}
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_RGMII:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 1000baseT_Full);
+			phylink_set(mask, 1000baseX_Full);
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
+				phylink_set(mask, 1000baseT_Half);
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
+		goto empty_set;
+	}
+
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
+	return;
+
+empty_set:
+	linkmode_zero(supported);
+}
+
+static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
+				      struct phylink_link_state *state)
+{
+	return -EOPNOTSUPP;
+}
+
+static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
+			   const struct phylink_link_state *state)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
+	bool change_interface = bp->phy_interface != state->interface;
 	unsigned long flags;
-	int status_change = 0;
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	if (phydev->link) {
-		if ((bp->speed != phydev->speed) ||
-		    (bp->duplex != phydev->duplex)) {
-			u32 reg;
+	if (change_interface)
+		bp->phy_interface = state->interface;
 
-			reg = macb_readl(bp, NCFGR);
-			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
-			if (macb_is_gem(bp))
-				reg &= ~GEM_BIT(GBE);
+	if (!phylink_autoneg_inband(mode) &&
+	    (bp->speed != state->speed ||
+	     bp->duplex != state->duplex)) {
+		u32 reg;
 
-			if (phydev->duplex)
-				reg |= MACB_BIT(FD);
-			if (phydev->speed == SPEED_100)
-				reg |= MACB_BIT(SPD);
-			if (phydev->speed == SPEED_1000 &&
-			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
-				reg |= GEM_BIT(GBE);
-
-			macb_or_gem_writel(bp, NCFGR, reg);
+		reg = macb_readl(bp, NCFGR);
+		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
+		if (macb_is_gem(bp))
+			reg &= ~GEM_BIT(GBE);
+		if (state->duplex)
+			reg |= MACB_BIT(FD);
 
-			bp->speed = phydev->speed;
-			bp->duplex = phydev->duplex;
-			status_change = 1;
+		switch (state->speed) {
+		case SPEED_1000:
+			reg |= GEM_BIT(GBE);
+			break;
+		case SPEED_100:
+			reg |= MACB_BIT(SPD);
+			break;
+		default:
+			break;
 		}
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
-static int macb_mii_probe(struct net_device *dev)
+static int macb_mii_probe(struct net_device *dev, phy_interface_t phy_mode)
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
+				phy_mode, &gem_phylink_ops);
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
@@ -549,32 +595,22 @@ static int macb_mii_probe(struct net_device *dev)
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
-	bp->speed = 0;
-	bp->duplex = -1;
+	bp->speed = SPEED_UNKNOWN;
+	bp->duplex = DUPLEX_UNKNOWN;
+	bp->phy_interface = PHY_INTERFACE_MODE_MAX;
 
-	return 0;
+	return ret;
 }
 
-static int macb_mii_init(struct macb *bp)
+static int macb_mii_init(struct macb *bp, phy_interface_t phy_mode)
 {
 	struct device_node *np;
 	int err = -ENXIO;
@@ -599,22 +635,12 @@ static int macb_mii_init(struct macb *bp)
 	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
 
 	np = bp->pdev->dev.of_node;
-	if (np && of_phy_is_fixed_link(np)) {
-		if (of_phy_register_fixed_link(np) < 0) {
-			dev_err(&bp->pdev->dev,
-				"broken fixed-link specification %pOF\n", np);
-			goto err_out_free_mdiobus;
-		}
-
-		err = mdiobus_register(bp->mii_bus);
-	} else {
-		err = of_mdiobus_register(bp->mii_bus, np);
-	}
+	err = of_mdiobus_register(bp->mii_bus, np);
 
 	if (err)
 		goto err_out_free_fixed_link;
 
-	err = macb_mii_probe(bp->dev);
+	err = macb_mii_probe(bp->dev, phy_mode);
 	if (err)
 		goto err_out_unregister_bus;
 
@@ -625,7 +651,6 @@ static int macb_mii_init(struct macb *bp)
 err_out_free_fixed_link:
 	if (np && of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
-err_out_free_mdiobus:
 	of_node_put(bp->phy_node);
 	mdiobus_free(bp->mii_bus);
 err_out:
@@ -2418,12 +2443,6 @@ static int macb_open(struct net_device *dev)
 	/* carrier starts down */
 	netif_carrier_off(dev);
 
-	/* if the phy is not yet register, retry later*/
-	if (!dev->phydev) {
-		err = -EAGAIN;
-		goto pm_exit;
-	}
-
 	/* RX buffers initialization */
 	macb_init_rx_buffer_size(bp, bufsz);
 
@@ -2441,7 +2460,7 @@ static int macb_open(struct net_device *dev)
 	macb_init_hw(bp);
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(bp->pl);
 
 	netif_tx_start_all_queues(dev);
 
@@ -2468,8 +2487,7 @@ static int macb_close(struct net_device *dev)
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
 
-	if (dev->phydev)
-		phy_stop(dev->phydev);
+	phylink_stop(bp->pl);
 
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
@@ -3158,6 +3176,23 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 	return ret;
 }
 
+static int gem_ethtool_get_link_ksettings(struct net_device *netdev,
+					  struct ethtool_link_ksettings *cmd)
+{
+	struct macb *bp = netdev_priv(netdev);
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
+	return phylink_ethtool_ksettings_set(bp->pl, cmd);
+}
+
 static const struct ethtool_ops macb_ethtool_ops = {
 	.get_regs_len		= macb_get_regs_len,
 	.get_regs		= macb_get_regs,
@@ -3165,8 +3200,8 @@ static const struct ethtool_ops macb_ethtool_ops = {
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
@@ -3179,8 +3214,8 @@ static const struct ethtool_ops gem_ethtool_ops = {
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
@@ -3189,17 +3224,13 @@ static const struct ethtool_ops gem_ethtool_ops = {
 
 static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	struct phy_device *phydev = dev->phydev;
 	struct macb *bp = netdev_priv(dev);
 
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	if (!phydev)
-		return -ENODEV;
-
 	if (!bp->ptp_info)
-		return phy_mii_ioctl(phydev, rq, cmd);
+		return phylink_mii_ioctl(bp->pl, rq, cmd);
 
 	switch (cmd) {
 	case SIOCSHWTSTAMP:
@@ -3207,7 +3238,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCGHWTSTAMP:
 		return bp->ptp_info->get_hwtst(dev, rq);
 	default:
-		return phy_mii_ioctl(phydev, rq, cmd);
+		return phylink_mii_ioctl(bp->pl, rq, cmd);
 	}
 }
 
@@ -3709,7 +3740,7 @@ static int at91ether_open(struct net_device *dev)
 			     MACB_BIT(HRESP));
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(lp->pl);
 
 	netif_start_queue(dev);
 
@@ -4182,13 +4213,12 @@ static int macb_probe(struct platform_device *pdev)
 	struct clk *tsu_clk = NULL;
 	unsigned int queue_mask, num_queues;
 	bool native_io;
-	struct phy_device *phydev;
 	struct net_device *dev;
 	struct resource *regs;
 	void __iomem *mem;
 	const char *mac;
 	struct macb *bp;
-	int err, val;
+	int err, val, phy_mode;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mem = devm_ioremap_resource(&pdev->dev, regs);
@@ -4309,24 +4339,20 @@ static int macb_probe(struct platform_device *pdev)
 		macb_get_hwaddr(bp);
 	}
 
-	err = of_get_phy_mode(np);
-	if (err < 0)
+	phy_mode = of_get_phy_mode(np);
+	if (phy_mode < 0)
 		/* not found in DT, MII by default */
-		bp->phy_interface = PHY_INTERFACE_MODE_MII;
-	else
-		bp->phy_interface = err;
+		phy_mode = PHY_INTERFACE_MODE_MII;
 
 	/* IP specific init */
 	err = init(pdev);
 	if (err)
 		goto err_out_free_netdev;
 
-	err = macb_mii_init(bp);
+	err = macb_mii_init(bp, phy_mode);
 	if (err)
 		goto err_out_free_netdev;
 
-	phydev = dev->phydev;
-
 	netif_carrier_off(dev);
 
 	err = register_netdev(dev);
@@ -4338,8 +4364,6 @@ static int macb_probe(struct platform_device *pdev)
 	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
 		     (unsigned long)bp);
 
-	phy_attached_info(phydev);
-
 	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
 		    dev->base_addr, dev->irq, dev->dev_addr);
@@ -4350,7 +4374,9 @@ static int macb_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_unregister_mdio:
-	phy_disconnect(dev->phydev);
+	rtnl_lock();
+	phylink_disconnect_phy(bp->pl);
+	rtnl_unlock();
 	mdiobus_unregister(bp->mii_bus);
 	of_node_put(bp->phy_node);
 	if (np && of_phy_is_fixed_link(np))
@@ -4384,13 +4410,18 @@ static int macb_remove(struct platform_device *pdev)
 
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
@@ -4433,8 +4464,9 @@ static int __maybe_unused macb_suspend(struct device *dev)
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
@@ -4482,9 +4514,11 @@ static int __maybe_unused macb_resume(struct device *dev)
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

