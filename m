Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADC4E1FC
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfFUIfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:35:18 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:31996 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbfFUIfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:35:17 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L8VwvO022715;
        Fri, 21 Jun 2019 01:35:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=i2UJaMT3cR0hg/4iiN2u51y+Gwun4FsxjmYIxA7I+Zc=;
 b=VXcpvaeJkPXQaSuMgZY6VgperK3C8/hvZ3EcQvkGofZ9jnAV5/MVd8/Z8Y5r7BaHJGHe
 z1SfXaTWKMJL6np/imsacai4IR2gdtSSY3e9AIR/8O0X1YSed9oWOeZABJyIeNxWEq5y
 jfyFa+3Z3/RlsoHCV0MO0Co22kjt/QisCKHsG687Pa/LZKehN6RAOx1FPnq9Lzfo0m1Z
 aV1ITRQ/qVJAa+e/3copGNSDba9+hQ7O898acbVjEP+KDC7U/cpErnPfRl9d0douB6OD
 IVYB8NOGCvE+mLg8ZIFaZmTeu307Z8IoDul7gV5+tz5G+0HvL8e6kCrlnT7yqljUQaID /Q== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2056.outbound.protection.outlook.com [104.47.49.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t8ctvc3ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 01:35:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2UJaMT3cR0hg/4iiN2u51y+Gwun4FsxjmYIxA7I+Zc=;
 b=RbYesvd592jbplFGssf6yXv1fBui1JGGT1TSmLNjmce/95RBPrz3mTnPp6iObGBRoRdeXkY1QUpIiPsIr9LU5C3KXgd6EKUSfNr6OUFeI5ssXNLEqOybNwCVEM1y0Dj23FP6R16CRH4n8QkxuSD142JeaR6Xi9PkPYVFKeraEEE=
Received: from DM6PR07CA0043.namprd07.prod.outlook.com (2603:10b6:5:74::20) by
 SN2PR07MB2496.namprd07.prod.outlook.com (2603:10b6:804:11::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Fri, 21 Jun 2019 08:35:01 +0000
Received: from CO1NAM05FT064.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::201) by DM6PR07CA0043.outlook.office365.com
 (2603:10b6:5:74::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.16 via Frontend
 Transport; Fri, 21 Jun 2019 08:35:01 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT064.mail.protection.outlook.com (10.152.96.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Fri, 21 Jun 2019 08:34:59 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8YraB002522
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 21 Jun 2019 04:34:54 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 21 Jun 2019 10:34:53 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 10:34:52 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8YqKQ008541;
        Fri, 21 Jun 2019 09:34:52 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v3 2/5] net: macb: add support for sgmii MAC-PHY interface
Date:   Fri, 21 Jun 2019 09:34:50 +0100
Message-ID: <1561106090-8465-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(396003)(2980300002)(189003)(199004)(36092001)(107886003)(48376002)(70586007)(8936002)(2906002)(7126003)(336012)(478600001)(4326008)(356004)(47776003)(2616005)(53416004)(110136005)(426003)(77096007)(76176011)(16586007)(186003)(11346002)(26005)(316002)(7696005)(53936002)(5660300002)(51416003)(486006)(126002)(305945005)(76130400001)(446003)(54906003)(50466002)(8676002)(81156014)(14444005)(70206006)(26826003)(50226002)(476003)(36756003)(69596002)(86362001)(81166006)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2496;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:ErrorRetry;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58d79b2a-80c7-4801-33ba-08d6f62358fa
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:SN2PR07MB2496;
X-MS-TrafficTypeDiagnostic: SN2PR07MB2496:
X-Microsoft-Antispam-PRVS: <SN2PR07MB24961CC940F5B574D5E06136C1E70@SN2PR07MB2496.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0075CB064E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: AchRQPoCEEyLxKLA2j7YWhx7uYt0lFv5wZSTF5fo7VjB/BVnhpuLByUsok03gHXiyaBhC6fkGraOIbnRBGOqD2xbWAgfUr/MmSRBg9mgLscpa5XZp82Q1oBxe1p4FhOvKe2j1yS2HsRQCkZRGPbG5MkrfyAqZMbXX6eloO9SiOHqdodamPzyDtT1U4j0VFoP3RsWKC1cpGVXb6qX/Kx6EIz5R12ysGfxMPR0evmvFUjnEhtxymHMjhlf5aLxcn+7D/NItoHYztQlEfOkQGPpVkl1bXZAfRBnZBEMvWnkp85xGpwMGJixOV2Z4zFRKxhmD9NVTbhDvrIqYYcUCekGWMrFBy1QiIueyg2cqTYyVm5UfAFrNnUyOf4peGSz6YIMMHy/LgBtRVUQEhY5+wtiGu8zMRFdmeu+CxdBN/W1tz0=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2019 08:34:59.2991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d79b2a-80c7-4801-33ba-08d6f62358fa
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2496
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

This patch add support for SGMII interface) and
2.5Gbps MAC in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  54 +++++++++---
 drivers/net/ethernet/cadence/macb_main.c | 108 +++++++++++++++++++++--
 2 files changed, 140 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 35ed13236c8b..0647689f9796 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -80,6 +80,7 @@
 #define MACB_RBQPH		0x04D4
 
 /* GEM register offsets. */
+#define GEM_NCR			0x0000 /* Network Control */
 #define GEM_NCFGR		0x0004 /* Network Config */
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
@@ -159,6 +160,7 @@
 #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
 #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
 #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
+#define GEM_PCS_CTRL		0x0200 /* PCS Control */
 #define GEM_DCFG1		0x0280 /* Design Config 1 */
 #define GEM_DCFG2		0x0284 /* Design Config 2 */
 #define GEM_DCFG3		0x0288 /* Design Config 3 */
@@ -274,6 +276,10 @@
 #define MACB_IRXFCS_OFFSET	19
 #define MACB_IRXFCS_SIZE	1
 
+/* GEM specific NCR bitfields. */
+#define GEM_TWO_PT_FIVE_GIG_OFFSET	29
+#define GEM_TWO_PT_FIVE_GIG_SIZE	1
+
 /* GEM specific NCFGR bitfields. */
 #define GEM_GBE_OFFSET		10 /* Gigabit mode enable */
 #define GEM_GBE_SIZE		1
@@ -326,6 +332,9 @@
 #define MACB_MDIO_SIZE		1
 #define MACB_IDLE_OFFSET	2 /* The PHY management logic is idle */
 #define MACB_IDLE_SIZE		1
+#define MACB_DUPLEX_OFFSET	3
+#define MACB_DUPLEX_SIZE	1
+
 
 /* Bitfields in TSR */
 #define MACB_UBR_OFFSET		0 /* Used bit read */
@@ -459,11 +468,17 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfields in PCS_CONTROL. */
+#define GEM_PCS_CTRL_RST_OFFSET			15
+#define GEM_PCS_CTRL_RST_SIZE			1
+
 /* Bitfields in DCFG1. */
 #define GEM_IRQCOR_OFFSET			23
 #define GEM_IRQCOR_SIZE				1
 #define GEM_DBWDEF_OFFSET			25
 #define GEM_DBWDEF_SIZE				3
+#define GEM_NO_PCS_OFFSET			0
+#define GEM_NO_PCS_SIZE				1
 
 /* Bitfields in DCFG2. */
 #define GEM_RX_PKT_BUFF_OFFSET			20
@@ -636,19 +651,32 @@
 #define MACB_MAN_CODE				2
 
 /* Capability mask bits */
-#define MACB_CAPS_ISR_CLEAR_ON_WRITE		0x00000001
-#define MACB_CAPS_USRIO_HAS_CLKEN		0x00000002
-#define MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII	0x00000004
-#define MACB_CAPS_NO_GIGABIT_HALF		0x00000008
-#define MACB_CAPS_USRIO_DISABLED		0x00000010
-#define MACB_CAPS_JUMBO				0x00000020
-#define MACB_CAPS_GEM_HAS_PTP			0x00000040
-#define MACB_CAPS_BD_RD_PREFETCH		0x00000080
-#define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
-#define MACB_CAPS_FIFO_MODE			0x10000000
-#define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
-#define MACB_CAPS_SG_DISABLED			0x40000000
-#define MACB_CAPS_MACB_IS_GEM			0x80000000
+#define MACB_CAPS_ISR_CLEAR_ON_WRITE		BIT(0)
+#define MACB_CAPS_USRIO_HAS_CLKEN		BIT(1)
+#define MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII	BIT(2)
+#define MACB_CAPS_NO_GIGABIT_HALF		BIT(3)
+#define MACB_CAPS_USRIO_DISABLED		BIT(4)
+#define MACB_CAPS_JUMBO				BIT(5)
+#define MACB_CAPS_GEM_HAS_PTP			BIT(6)
+#define MACB_CAPS_BD_RD_PREFETCH		BIT(7)
+#define MACB_CAPS_NEEDS_RSTONUBR		BIT(8)
+#define MACB_CAPS_FIFO_MODE			BIT(28)
+#define MACB_CAPS_GIGABIT_MODE_AVAILABLE	BIT(29)
+#define MACB_CAPS_SG_DISABLED			BIT(30)
+#define MACB_CAPS_MACB_IS_GEM			BIT(31)
+#define MACB_CAPS_PCS				BIT(24)
+#define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
+
+#define MACB_GEM7010_IDNUM			0x009
+#define MACB_GEM7014_IDNU			0x107
+#define MACB_GEM7014A_IDNUM			0x207
+#define MACB_GEM7016_IDNUM			0x10a
+#define MACB_GEM7017_IDNUM			0x00a
+#define MACB_GEM7017A_IDNUM			0x20a
+#define MACB_GEM7020_IDNUM			0x003
+#define MACB_GEM7021_IDNUM			0x00c
+#define MACB_GEM7021A_IDNUM			0x20c
+#define MACB_GEM7022_IDNUM			0x00b
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 97d168dfa873..f1e58801ccf5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -403,6 +403,7 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
  */
 static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 {
+	struct macb *bp = netdev_priv(dev);
 	long ferr, rate, rate_rounded;
 
 	if (!clk)
@@ -418,6 +419,12 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 	case SPEED_1000:
 		rate = 125000000;
 		break;
+	case SPEED_2500:
+		if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL)
+			rate = 312500000;
+		else
+			rate = 125000000;
+		break;
 	default:
 		return;
 	}
@@ -448,15 +455,19 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 2500baseT_Full);
+			phylink_set(mask, 2500baseX_Full);
+		}
+	/* fallthrough */
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
 			phylink_set(mask, 1000baseT_Full);
 			phylink_set(mask, 1000baseX_Full);
-			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
 				phylink_set(mask, 1000baseT_Half);
-				phylink_set(mask, 1000baseT_Half);
-			}
 		}
 	/* fallthrough */
 	case PHY_INTERFACE_MODE_MII:
@@ -466,13 +477,19 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 		phylink_set(mask, 100baseT_Half);
 		phylink_set(mask, 100baseT_Full);
 		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		phylink_set(mask, 1000baseT_Full);
+		phylink_set(mask, 1000baseX_Full);
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+		break;
 	default:
 		break;
 	}
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
 }
 
 static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
@@ -486,23 +503,54 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 {
 	struct net_device *netdev = to_net_dev(pl_config->dev);
 	struct macb *bp = netdev_priv(netdev);
+	bool change_interface = bp->phy_interface != state->interface;
 	unsigned long flags;
 
 	spin_lock_irqsave(&bp->lock, flags);
 
+	if (change_interface) {
+		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+		    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+		    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
+			gem_writel(bp, NCFGR, ~GEM_BIT(SGMIIEN) &
+				   ~GEM_BIT(PCSSEL) &
+				   gem_readl(bp, NCFGR));
+			gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
+				   gem_readl(bp, NCR));
+			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
+				   GEM_BIT(PCS_CTRL_RST));
+		}
+		bp->phy_interface = state->interface;
+	}
+
 	if (!phylink_autoneg_inband(mode) &&
 	    (bp->speed != state->speed ||
-	     bp->duplex != state->duplex)) {
+	     bp->duplex != state->duplex ||
+	     change_interface)) {
 		u32 reg;
 
 		reg = macb_readl(bp, NCFGR);
 		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
 		if (macb_is_gem(bp))
 			reg &= ~GEM_BIT(GBE);
+		macb_or_gem_writel(bp, NCFGR, reg);
+
+		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+		    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+		    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
+			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
+				   GEM_BIT(PCSSEL) |
+				   gem_readl(bp, NCFGR));
+
+		reg = macb_readl(bp, NCFGR);
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
 
 		switch (state->speed) {
+		case SPEED_2500:
+			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
+				   gem_readl(bp, NCR));
+			break;
 		case SPEED_1000:
 			reg |= GEM_BIT(GBE);
 			break;
@@ -593,8 +641,8 @@ static int macb_mii_probe(struct net_device *dev)
 	}
 
 	bp->link = 0;
-	bp->speed = 0;
-	bp->duplex = -1;
+	bp->speed = SPEED_UNKNOWN;
+	bp->duplex = DUPLEX_UNKNOWN;
 
 	return ret;
 }
@@ -3343,6 +3391,22 @@ static void macb_configure_caps(struct macb *bp,
 		dcfg = gem_readl(bp, DCFG1);
 		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
 			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
+		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
+			bp->caps |= MACB_CAPS_PCS;
+		switch (MACB_BFEXT(IDNUM, macb_readl(bp, MID))) {
+		case MACB_GEM7016_IDNUM:
+		case MACB_GEM7017_IDNUM:
+		case MACB_GEM7017A_IDNUM:
+		case MACB_GEM7020_IDNUM:
+		case MACB_GEM7021_IDNUM:
+		case MACB_GEM7021A_IDNUM:
+		case MACB_GEM7022_IDNUM:
+			bp->caps |= MACB_CAPS_USRIO_DISABLED;
+			bp->caps |= MACB_CAPS_MACB_IS_GEM_GXL;
+			break;
+		default:
+			break;
+		}
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
@@ -4325,11 +4389,37 @@ static int macb_probe(struct platform_device *pdev)
 	}
 
 	phy_mode = of_get_phy_mode(np);
-	if (phy_mode < 0)
+	if (phy_mode < 0) {
 		/* not found in DT, MII by default */
 		bp->phy_interface = PHY_INTERFACE_MODE_MII;
-	else
+	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
+		u32 interface_supported = 1;
+
+		if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
+		    phy_mode == PHY_INTERFACE_MODE_1000BASEX ||
+		    phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
+			if (!(bp->caps & MACB_CAPS_PCS))
+				interface_supported = 0;
+		} else if (phy_mode == PHY_INTERFACE_MODE_GMII ||
+			   phy_mode == PHY_INTERFACE_MODE_RGMII) {
+			if (!macb_is_gem(bp))
+				interface_supported = 0;
+		} else if (phy_mode != PHY_INTERFACE_MODE_RMII &&
+			   phy_mode != PHY_INTERFACE_MODE_MII) {
+			/* Add new mode before this */
+			interface_supported = 0;
+		}
+
+		if (!interface_supported) {
+			netdev_err(dev, "Phy mode %s not supported",
+				   phy_modes(phy_mode));
+			goto err_out_free_netdev;
+		}
+
 		bp->phy_interface = phy_mode;
+	} else {
+		bp->phy_interface = phy_mode;
+	}
 
 	/* IP specific init */
 	err = init(pdev);
-- 
2.17.1

