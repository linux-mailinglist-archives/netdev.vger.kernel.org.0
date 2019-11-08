Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E395EF4D45
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfKHNeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:34:44 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:4996 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727431AbfKHNeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:34:44 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8DXtdw020358;
        Fri, 8 Nov 2019 05:34:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=iDLSlne8PL4e02DCPKs2Ygk9vWNrYf4Medsm1RyN+hg=;
 b=TGdIH9SZ6Mj9hTVHrtxqA4A4O0SCT04LgY6lQTMOZZoqql2qNRbTqWhBlbiBg04epKqA
 AYppubgmMv4RjAaQd3//wd3OckIB0wsurrNcJgjPccNtY6diBYbcjiPWh3G5YiM3Bs3Y
 j41Riv/HxmTxC8wKrHyN1I+TCD/Y8D7UWZXbM7Lz4w/wfQteSA9pAuWdr8UO+RLyqbRO
 UjXCzdZ1+8+TXs8tP+F0+J31WljlnqhEnZ0jZlvRLrzbVlA/pBzeXQYFbbiwtwbuWPBe
 kQWVUyWFiw7KYqy6zRCHZ7JCjRTD9lEbKWsPo+//gPtadxvKwSQ8chAwtO9GHGy832MS nw== 
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2052.outbound.protection.outlook.com [104.47.49.52])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2w41txhcku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 05:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB29ncLJ2z+Hn0RhGcBh5EuW752bsE0yVvb2ngZj/QC6b4XOlMorlsfm/M725h0h1zozsUT5uYPbzEZAmaYhxfyPifON/Rl1QODs1ENwkS11znVOKn9xldoOhX7ragxwWsrJKcVcWCPg44ER5ojBD0/WjqkNxopZdvjmROmg7AdTgTu7C459U+wrT6Rdm/VHc6sy4GdI/N3E8PzlrEUR1k+/A1HN5LFWG8OzNUiaSK8Y3dvaAkmdRZSbhqSqpn7H8tl0CuJ3WM6idXyOF3D5LGqx7hUHi2Drt2wSnRp0DFvXbwF1sR/fHHgLjNBYlAqk1Nzyd1+mC7A0xEQ0mOqvQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDLSlne8PL4e02DCPKs2Ygk9vWNrYf4Medsm1RyN+hg=;
 b=ElnKfuAvT83iX/dJVINMwmPlU7waVhkr9ZM+Ste9XkmuoqpWVVzfdcvNxL01bSCKaKHLjSBRc32ueQ2XedDjazjYxP3X+hQKHFPJpcVk5yfHb3PJNcmnfYDoTiuhZV5UfB6Dde6XssiR23NjPPENQMRJO0xJggTiGV/J+B0IrgKtAPxNgfACGReQYbOKT9+BCJhCjOzwSzcUWR1T/Td5IQXQdC6MejW+itugU+8h/DqqCeIQnxyG3aOtXbkwZQlJgfmC+p9vy+rrNPy3c+jNtamIsI7pF27Uj87sYW8TjuX1KV4FkuWTbhVaU+ZU7Tw7tixmBzLebbl7+U5Tc0chAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 199.43.4.28) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDLSlne8PL4e02DCPKs2Ygk9vWNrYf4Medsm1RyN+hg=;
 b=qISR0MCjV3lFc841U/5SkPKfL+R/YXLa4Cm/0/qilI6RBGTBxotke89xge7IKXO1DNHio1Izrg2LrFlJ80bNh1GyTUe/m0rZVw/1ThbvMA1HOohGlUrRkEdmqPF/jW1dNVFk7nxviPYPgihmD/cCzypvs0unSMrAmpF05V3m50k=
Received: from DM5PR07CA0040.namprd07.prod.outlook.com (2603:10b6:3:16::26) by
 SN6PR07MB4446.namprd07.prod.outlook.com (2603:10b6:805:5a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 13:34:29 +0000
Received: from CO1NAM05FT021.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::207) by DM5PR07CA0040.outlook.office365.com
 (2603:10b6:3:16::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.20 via Frontend
 Transport; Fri, 8 Nov 2019 13:34:29 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT021.mail.protection.outlook.com (10.152.96.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2451.15 via Frontend Transport; Fri, 8 Nov 2019 13:34:28 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYPwN028892
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 8 Nov 2019 08:34:27 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 8 Nov 2019 14:34:25 +0100
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 8 Nov 2019 14:34:25 +0100
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYO13017584;
        Fri, 8 Nov 2019 13:34:24 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <piotrs@cadence.com>,
        <dkangude@cadence.com>, <ewanm@cadence.com>, <arthurm@cadence.com>,
        <stevenh@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 1/4] net: macb: add phylink support
Date:   Fri, 8 Nov 2019 13:34:23 +0000
Message-ID: <1573220063-17470-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1573220027-15842-1-git-send-email-mparab@cadence.com>
References: <1573220027-15842-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(36092001)(48376002)(50466002)(356004)(76176011)(51416003)(7696005)(5024004)(14444005)(305945005)(26826003)(478600001)(36756003)(8676002)(81166006)(8936002)(81156014)(50226002)(2906002)(316002)(107886003)(86362001)(16586007)(110136005)(54906003)(53416004)(70206006)(336012)(30864003)(70586007)(76130400001)(26005)(11346002)(186003)(7126003)(426003)(126002)(2201001)(2616005)(486006)(476003)(446003)(4326008)(47776003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR07MB4446;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94ab7d5a-7202-433d-3cf0-08d764506174
X-MS-TrafficTypeDiagnostic: SN6PR07MB4446:
X-Microsoft-Antispam-PRVS: <SN6PR07MB4446954919BE34D61F6BB381D37B0@SN6PR07MB4446.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-Forefront-PRVS: 0215D7173F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJHpLsUbQima1McxPA/zHPeeIO0fiHBkQsbj0bqDJkGeam9yKuF6VKFZvp3XKtk/l2/PkudZfeIj5UMqB8t8UeqGbSMcrITxp9S8FwdinxWUEgPiuberssOfF9t+KVAUJkb7rXsndS1qt7otPxU4ASf0TOoVEq99bfSXSw1soVZLzi++U4TH0cBuCY/wfMrHBGY7ktXwSeaNWcZQEzxWqxYmIdRQp5c4Le7Z57H3qJbGRtpG3+O5v2WFkKPXUuaOBqOt17EIrIle+Tr2b//usi8u1wiMjghu9GkCFyEvah1TSqGwmtu5DqLF7b9QzQyoYPFApi/TPHdhNFbM6NLnGcisPMi9LRzaFpZkvqvNYtiC7zPaBeQRooPZwHl8vgPMRsY3piQ09VO171uAle0tm3Qw1Aj4vnTOirQxaQjil7Q3km/DHB1BuSX2blKc2Wtrkuf16ITXurVyQ9L5F6CuJA==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:34:28.9752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ab7d5a-7202-433d-3cf0-08d764506174
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB4446
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_04:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1015
 phishscore=0 suspectscore=2 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replace phylib API's by phylink API's.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/Kconfig     |    2 +-
 drivers/net/ethernet/cadence/macb.h      |    3 +
 drivers/net/ethernet/cadence/macb_main.c |  326 ++++++++++++++++-------------
 3 files changed, 184 insertions(+), 147 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index f4b3bd8..53b50c2 100644
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
index 03983bd..a400705 100644
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
index b884cf7..15016ff 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -432,115 +432,160 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
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
 }
 
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
+}
+
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
@@ -548,32 +593,22 @@ static int macb_mii_probe(struct net_device *dev)
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
@@ -598,22 +633,12 @@ static int macb_mii_init(struct macb *bp)
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
 
@@ -624,7 +649,6 @@ static int macb_mii_init(struct macb *bp)
 err_out_free_fixed_link:
 	if (np && of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
-err_out_free_mdiobus:
 	of_node_put(bp->phy_node);
 	mdiobus_free(bp->mii_bus);
 err_out:
@@ -2417,12 +2441,6 @@ static int macb_open(struct net_device *dev)
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
 
@@ -2440,7 +2458,7 @@ static int macb_open(struct net_device *dev)
 	macb_init_hw(bp);
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(bp->pl);
 
 	netif_tx_start_all_queues(dev);
 
@@ -2467,8 +2485,7 @@ static int macb_close(struct net_device *dev)
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_disable(&queue->napi);
 
-	if (dev->phydev)
-		phy_stop(dev->phydev);
+	phylink_stop(bp->pl);
 
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
@@ -3157,6 +3174,23 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
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
@@ -3164,8 +3198,8 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
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
@@ -3178,8 +3212,8 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
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
@@ -3188,17 +3222,13 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 
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
@@ -3206,7 +3236,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case SIOCGHWTSTAMP:
 		return bp->ptp_info->get_hwtst(dev, rq);
 	default:
-		return phy_mii_ioctl(phydev, rq, cmd);
+		return phylink_mii_ioctl(bp->pl, rq, cmd);
 	}
 }
 
@@ -3708,7 +3738,7 @@ static int at91ether_open(struct net_device *dev)
 			     MACB_BIT(HRESP));
 
 	/* schedule a link state check */
-	phy_start(dev->phydev);
+	phylink_start(lp->pl);
 
 	netif_start_queue(dev);
 
@@ -4181,7 +4211,7 @@ static int macb_probe(struct platform_device *pdev)
 	struct clk *tsu_clk = NULL;
 	unsigned int queue_mask, num_queues;
 	bool native_io;
-	struct phy_device *phydev;
+	//struct phy_device *phydev;
 	phy_interface_t interface;
 	struct net_device *dev;
 	struct resource *regs;
@@ -4312,21 +4342,17 @@ static int macb_probe(struct platform_device *pdev)
 	err = of_get_phy_mode(np, &interface);
 	if (err)
 		/* not found in DT, MII by default */
-		bp->phy_interface = PHY_INTERFACE_MODE_MII;
-	else
-		bp->phy_interface = interface;
+		interface = PHY_INTERFACE_MODE_MII;
 
 	/* IP specific init */
 	err = init(pdev);
 	if (err)
 		goto err_out_free_netdev;
 
-	err = macb_mii_init(bp);
+	err = macb_mii_init(bp, interface);
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
1.7.1

