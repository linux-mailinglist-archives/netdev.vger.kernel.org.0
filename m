Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B644E1F9
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfFUIfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:35:05 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:10220 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbfFUIfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:35:04 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L8YA8G005053;
        Fri, 21 Jun 2019 01:34:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=FD8cjf2eos5oTMdxlC6zizrltt346WI6xUouSufzyQA=;
 b=jVdm7BWP9s0SayzlO9ZsR48YkNEdN9X23UnnlHkozyCHEJIkUgl2ePRBTlAsKb0iwPbj
 87mTM6enZN9SSzVgE+I/MKKpRCRCfUQ183kU6iur1Zmm8Hh2W82Iwgzgeh0p455sWFkD
 C/5DBlKtw/Di/PYD5x+swWGBoYT+GR0Nwyt8C3dAxcyceNXt9ft0+tz2AuTLHskbi3cy
 cn5C3Dw+f0eNlN+LUxpiZwvZNbehA3MGbG57t6ydhy2jErCfqAAV8S0RNbyxk9RINMqx
 ITaF7qivCscGPm7j6LQFfBsu95N3mO5Vjt9ozeXSP8CJFka6ncw5ZunjaMB7VGD21CFa 1Q== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t8cht4h7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 01:34:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD8cjf2eos5oTMdxlC6zizrltt346WI6xUouSufzyQA=;
 b=JsXOdTRP+AsSMSLwEpIezYx0a1WXjAU/LzgNjbLEEj5QqYnY6qceGkRrIbHTPUu5f4igrrZn7HArMOegFL03anzc/pRe6+57HSR2DOcwKKA4Cj7SXVRgd8HuuBVuHCRflCz4yikMupdEsl7GG0Ij6DCtSrIOMHptlyL4V2ENbjU=
Received: from BYAPR07CA0024.namprd07.prod.outlook.com (2603:10b6:a02:bc::37)
 by CO2PR07MB2486.namprd07.prod.outlook.com (2603:10b6:102:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.15; Fri, 21 Jun
 2019 08:34:50 +0000
Received: from DM3NAM05FT063.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::205) by BYAPR07CA0024.outlook.office365.com
 (2603:10b6:a02:bc::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.17 via Frontend
 Transport; Fri, 21 Jun 2019 08:34:50 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT063.mail.protection.outlook.com (10.152.98.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Fri, 21 Jun 2019 08:34:49 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8Yk02029269
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 21 Jun 2019 01:34:47 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 21 Jun 2019 10:34:46 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 10:34:45 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8Yjr5008320;
        Fri, 21 Jun 2019 09:34:45 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v3 1/5] net: macb: add phylink support
Date:   Fri, 21 Jun 2019 09:34:44 +0100
Message-ID: <1561106084-8241-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39860400002)(136003)(2980300002)(199004)(189003)(36092001)(7636002)(8936002)(86362001)(7696005)(26005)(356004)(426003)(70206006)(77096007)(76176011)(51416003)(186003)(14444005)(5024004)(7126003)(305945005)(30864003)(2616005)(26826003)(126002)(476003)(446003)(11346002)(2201001)(107886003)(336012)(486006)(4326008)(54906003)(16586007)(48376002)(50466002)(50226002)(47776003)(110136005)(53416004)(8676002)(478600001)(36756003)(70586007)(5660300002)(76130400001)(246002)(316002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2486;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fef9b60e-ff28-4947-bb4d-08d6f6235346
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:CO2PR07MB2486;
X-MS-TrafficTypeDiagnostic: CO2PR07MB2486:
X-Microsoft-Antispam-PRVS: <CO2PR07MB24869F0E413C2D3DED588946C1E70@CO2PR07MB2486.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-Forefront-PRVS: 0075CB064E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: f6JVTzfU8s8FCp6o1pbN/HJ5bygzb3ugzPVC3c92eq3eA6/vd03HrpgkckJtgehZgvMXdPuclHGUOyJqziIpznoRR/7sXSrphZeDWQunHbmnxgMeB/6sQWKkNvE8QsMhujRKOtwewZrYk7ujnXlQ4kvx8pNP9N3fgIFIcNQuJt+WIJw5CC0lISO9h49P29f1Dl3kFmX01VMVYXwV2D+QKqAwn6BWgFvf1YvEGYfmAsH/ubZw3JD6An4aENxKE++uLAzH6lD2gdq1Huyfnvd2xMkQ73WKltuNR41tsrydB1Itz0LlOWcpnVf4WqoCKgcUCkvj+CYbqQc9YM+UUJKQWy7xHIWrWEosXMn4DlQABSYif6INiRbIqh0pHrQ55m3Pk7rlWP0eM2fiYwECpbMXNCV0ZKJ7omRtU0o1nvVf8HY=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2019 08:34:49.5028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fef9b60e-ff28-4947-bb4d-08d6f6235346
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2486
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replace phylib API's by phylink API's.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/Kconfig     |   2 +-
 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 304 ++++++++++++-----------
 3 files changed, 166 insertions(+), 143 deletions(-)

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
index c545c5b435d8..97d168dfa873 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -39,6 +39,7 @@
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
 #include <linux/pm_runtime.h>
+#include <linux/phylink.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -438,115 +439,145 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 		netdev_err(dev, "adjusting tx_clk failed.\n");
 }
 
-static void macb_handle_link_change(struct net_device *dev)
+static void gem_phylink_validate(struct phylink_config *pl_config,
+				 unsigned long *supported,
+				 struct phylink_link_state *state)
 {
-	struct macb *bp = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
-	unsigned long flags;
-	int status_change = 0;
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
 
-	spin_lock_irqsave(&bp->lock, flags);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
-	if (phydev->link) {
-		if ((bp->speed != phydev->speed) ||
-		    (bp->duplex != phydev->duplex)) {
-			u32 reg;
+}
 
-			reg = macb_readl(bp, NCFGR);
-			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
-			if (macb_is_gem(bp))
-				reg &= ~GEM_BIT(GBE);
+static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
+				      struct phylink_link_state *state)
+{
+	return -EOPNOTSUPP;
+}
 
-			if (phydev->duplex)
-				reg |= MACB_BIT(FD);
-			if (phydev->speed == SPEED_100)
-				reg |= MACB_BIT(SPD);
-			if (phydev->speed == SPEED_1000 &&
-			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
-				reg |= GEM_BIT(GBE);
+static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
+			   const struct phylink_link_state *state)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
+	unsigned long flags;
 
-			macb_or_gem_writel(bp, NCFGR, reg);
+	spin_lock_irqsave(&bp->lock, flags);
 
-			bp->speed = phydev->speed;
-			bp->duplex = phydev->duplex;
-			status_change = 1;
-		}
-	}
+	if (!phylink_autoneg_inband(mode) &&
+	    (bp->speed != state->speed ||
+	     bp->duplex != state->duplex)) {
+		u32 reg;
 
-	if (phydev->link != bp->link) {
-		if (!phydev->link) {
-			bp->speed = 0;
-			bp->duplex = -1;
+		reg = macb_readl(bp, NCFGR);
+		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
+		if (macb_is_gem(bp))
+			reg &= ~GEM_BIT(GBE);
+		if (state->duplex)
+			reg |= MACB_BIT(FD);
+
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
-		bp->link = phydev->link;
+		macb_or_gem_writel(bp, NCFGR, reg);
+
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
@@ -554,29 +585,18 @@ static int macb_mii_probe(struct net_device *dev)
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
@@ -604,17 +624,7 @@ static int macb_mii_init(struct macb *bp)
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
@@ -630,7 +640,6 @@ static int macb_mii_init(struct macb *bp)
 err_out_free_fixed_link:
 	if (np && of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
-err_out_free_mdiobus:
 	of_node_put(bp->phy_node);
 	mdiobus_free(bp->mii_bus);
 err_out:
@@ -2421,12 +2430,6 @@ static int macb_open(struct net_device *dev)
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
 
@@ -2444,7 +2447,7 @@ static int macb_open(struct net_device *dev)
 	macb_init_hw(bp);
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(bp->pl);
 
 	netif_tx_start_all_queues(dev);
 
@@ -2471,8 +2474,7 @@ static int macb_close(struct net_device *dev)
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
 
-	if (dev->phydev)
-		phy_stop(dev->phydev);
+	phylink_stop(bp->pl);
 
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
@@ -3161,6 +3163,23 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
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
@@ -3168,8 +3187,8 @@ static const struct ethtool_ops macb_ethtool_ops = {
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
@@ -3182,8 +3201,8 @@ static const struct ethtool_ops gem_ethtool_ops = {
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
@@ -3192,17 +3211,13 @@ static const struct ethtool_ops gem_ethtool_ops = {
 
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
@@ -3210,7 +3225,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCGHWTSTAMP:
 		return bp->ptp_info->get_hwtst(dev, rq);
 	default:
-		return phy_mii_ioctl(phydev, rq, cmd);
+		return phylink_mii_ioctl(bp->pl, rq, cmd);
 	}
 }
 
@@ -3710,7 +3725,7 @@ static int at91ether_open(struct net_device *dev)
 			     MACB_BIT(HRESP));
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(lp->pl);
 
 	netif_start_queue(dev);
 
@@ -4183,13 +4198,12 @@ static int macb_probe(struct platform_device *pdev)
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
@@ -4310,12 +4324,12 @@ static int macb_probe(struct platform_device *pdev)
 		macb_get_hwaddr(bp);
 	}
 
-	err = of_get_phy_mode(np);
-	if (err < 0)
+	phy_mode = of_get_phy_mode(np);
+	if (phy_mode < 0)
 		/* not found in DT, MII by default */
 		bp->phy_interface = PHY_INTERFACE_MODE_MII;
 	else
-		bp->phy_interface = err;
+		bp->phy_interface = phy_mode;
 
 	/* IP specific init */
 	err = init(pdev);
@@ -4326,8 +4340,6 @@ static int macb_probe(struct platform_device *pdev)
 	if (err)
 		goto err_out_free_netdev;
 
-	phydev = dev->phydev;
-
 	netif_carrier_off(dev);
 
 	err = register_netdev(dev);
@@ -4339,8 +4351,6 @@ static int macb_probe(struct platform_device *pdev)
 	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
 		     (unsigned long)bp);
 
-	phy_attached_info(phydev);
-
 	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
 		    dev->base_addr, dev->irq, dev->dev_addr);
@@ -4351,7 +4361,9 @@ static int macb_probe(struct platform_device *pdev)
 	return 0;
 
 err_out_unregister_mdio:
-	phy_disconnect(dev->phydev);
+	rtnl_lock();
+	phylink_disconnect_phy(bp->pl);
+	rtnl_unlock();
 	mdiobus_unregister(bp->mii_bus);
 	of_node_put(bp->phy_node);
 	if (np && of_phy_is_fixed_link(np))
@@ -4385,13 +4397,18 @@ static int macb_remove(struct platform_device *pdev)
 
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
@@ -4434,8 +4451,9 @@ static int __maybe_unused macb_suspend(struct device *dev)
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
@@ -4483,9 +4501,11 @@ static int __maybe_unused macb_resume(struct device *dev)
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

