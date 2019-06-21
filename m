Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FEB4E202
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfFUIf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:35:28 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:20420 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbfFUIf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:35:27 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L8Vw1a022718;
        Fri, 21 Jun 2019 01:35:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=Q6EjuuH0I6T7weVed79zuq1FD8nTezN3sF8diBSqZ60=;
 b=mpcNXgRii9FsfG8FOVuFfjMUYp26F5v8FzgwS7phToVvRfQWssVFBvGNLTHdGYbqWVzR
 66tmBQ1vGlzRt5ilO7Xr61Z/5dY1/fJoC8on/Q83QyMv97lahsdAFb6phCXxJ97+dfUz
 S0c5dzH968mcRhopkP/n9nsMIRZfoKKq/WA5u7s9rFbYTF4I9XhsHj3pbJ3Prb6hU29X
 FXzrfP4MTkJG8cDlaEOEF2AviLLLrgLCnClQPn6GC8RUqHNTXfSo7hi+8oNdtoLinOP+
 Y/bMHcJ1bXlgIPaZJJFwPehjyZ2d3xIvekISDb0ZcZnFgvmHdSFKQGo20ZQUZzrPyYo4 Mw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2056.outbound.protection.outlook.com [104.47.36.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t8ctvc3fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 01:35:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6EjuuH0I6T7weVed79zuq1FD8nTezN3sF8diBSqZ60=;
 b=OW4UxH9i8A2VioiWVKGONILqBcoGV6ERN1tYc2iStpE6n2ZhafrTEe6+G6XFfshH/UA+MwvwHgxYTqL05TIiiJdTtuH9Eo2n1XF3sS+zpEVPHMLUQ+4kKBamJKRWcPaNZ9qEYkiPOCPsc/D1QV/1ry/z1JQIK80AxlE9F2I2wig=
Received: from DM5PR07CA0098.namprd07.prod.outlook.com (2603:10b6:4:ae::27) by
 CO2PR07MB2486.namprd07.prod.outlook.com (2603:10b6:102:f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Fri, 21 Jun 2019 08:35:14 +0000
Received: from BY2NAM05FT013.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::207) by DM5PR07CA0098.outlook.office365.com
 (2603:10b6:4:ae::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.12 via Frontend
 Transport; Fri, 21 Jun 2019 08:35:13 +0000
Received-SPF: PermError (protection.outlook.com: domain of cadence.com used an
 invalid SPF mechanism)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 BY2NAM05FT013.mail.protection.outlook.com (10.152.100.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Fri, 21 Jun 2019 08:35:13 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8ZBlr029317
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 21 Jun 2019 01:35:12 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 21 Jun 2019 10:35:10 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 10:35:10 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8Z9hn009173;
        Fri, 21 Jun 2019 09:35:09 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v3 4/5] net: macb: add support for high speed interface
Date:   Fri, 21 Jun 2019 09:35:08 +0100
Message-ID: <1561106108-9103-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39860400002)(136003)(2980300002)(448002)(199004)(189003)(36092001)(7636002)(8936002)(86362001)(7696005)(26005)(356004)(426003)(70206006)(77096007)(76176011)(51416003)(186003)(14444005)(7126003)(305945005)(30864003)(2616005)(26826003)(126002)(476003)(446003)(11346002)(2201001)(107886003)(336012)(486006)(4326008)(54906003)(16586007)(48376002)(50466002)(50226002)(47776003)(110136005)(53416004)(8676002)(478600001)(36756003)(70586007)(5660300002)(76130400001)(246002)(316002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2486;H:sjmaillnx2.cadence.com;FPR:;SPF:PermError;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b99e0099-5c5f-4430-b5d3-08d6f6236122
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:CO2PR07MB2486;
X-MS-TrafficTypeDiagnostic: CO2PR07MB2486:
X-Microsoft-Antispam-PRVS: <CO2PR07MB2486B598DF6C9B0A82C8E550C1E70@CO2PR07MB2486.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0075CB064E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /yiCDvu2LpY+iGNTBhSlPa7to3XHErbuxdvtApSPvqDZ87QFc1tJE2zrJbq1bgZcK/ukPYM6UJIJuhO6SDcAEhYFvY4oGHzMCTymKEUtT+hJst5wZeHk+L5cJ2bd/QpAhdZwRvs0DOTxh28hjU4pwH9fJSnGHKdHJEp1f3BINbU+AuleTI6cI57hXCt/GUwjddGVwxZ2mJtdd+j+wtQRq9RA0BB0lEiO2ExicbpxIU3bteqvXwI/z45kaYTYljptZ4M5DqbTI0ALxy7H9iL126w+3dZnrILqoTlogZtDOcvqGNtBGI/0QrdHBc7mGyFa6B+EdSu14CBaXdLTIA0odrSM+jQ+XWNZwSDWPsT0fyl3Rrczf1oCj/vbF5NZBXSnNaO/12eXa6nkiuRW+ZhpHCkok5D5MiisM8StsY+UW38=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2019 08:35:13.2796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b99e0099-5c5f-4430-b5d3-08d6f6236122
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
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  41 +++++
 drivers/net/ethernet/cadence/macb_main.c | 218 +++++++++++++++++++----
 2 files changed, 220 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index b59840f5c023..a405aeac74e6 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -85,6 +85,7 @@
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
 #define GEM_JML			0x0048 /* Jumbo Max Length */
+#define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
 #define GEM_HRB			0x0080 /* Hash Bottom */
 #define GEM_HRT			0x0084 /* Hash Top */
 #define GEM_SA1B		0x0088 /* Specific1 Bottom */
@@ -170,6 +171,9 @@
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
+#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -277,6 +281,8 @@
 #define MACB_IRXFCS_SIZE	1
 
 /* GEM specific NCR bitfields. */
+#define GEM_ENABLE_HS_MAC_OFFSET	31
+#define GEM_ENABLE_HS_MAC_SIZE		1
 #define GEM_TWO_PT_FIVE_GIG_OFFSET	29
 #define GEM_TWO_PT_FIVE_GIG_SIZE	1
 
@@ -468,6 +474,10 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfield in HS_MAC_CONFIG */
+#define GEM_HS_MAC_SPEED_OFFSET			0
+#define GEM_HS_MAC_SPEED_SIZE			3
+
 /* Bitfields in PCS_CONTROL. */
 #define GEM_PCS_CTRL_RST_OFFSET			15
 #define GEM_PCS_CTRL_RST_SIZE			1
@@ -513,6 +523,34 @@
 #define GEM_RXBD_RDBUFF_OFFSET			8
 #define GEM_RXBD_RDBUFF_SIZE			4
 
+/* Bitfields in DCFG12. */
+#define GEM_HIGH_SPEED_OFFSET			26
+#define GEM_HIGH_SPEED_SIZE			1
+
+/* Bitfields in USX_CONTROL. */
+#define GEM_USX_CTRL_SPEED_OFFSET		14
+#define GEM_USX_CTRL_SPEED_SIZE			3
+#define GEM_SERDES_RATE_OFFSET			12
+#define GEM_SERDES_RATE_SIZE			2
+#define GEM_RX_SCR_BYPASS_OFFSET		9
+#define GEM_RX_SCR_BYPASS_SIZE			1
+#define GEM_TX_SCR_BYPASS_OFFSET		8
+#define GEM_TX_SCR_BYPASS_SIZE			1
+#define GEM_RX_SYNC_RESET_OFFSET		2
+#define GEM_RX_SYNC_RESET_SIZE			1
+#define GEM_TX_EN_OFFSET			1
+#define GEM_TX_EN_SIZE				1
+#define GEM_SIGNAL_OK_OFFSET			0
+#define GEM_SIGNAL_OK_SIZE			1
+
+/* Bitfields in USX_STATUS. */
+#define GEM_USX_TX_FAULT_OFFSET			28
+#define GEM_USX_TX_FAULT_SIZE			1
+#define GEM_USX_RX_FAULT_OFFSET			27
+#define GEM_USX_RX_FAULT_SIZE			1
+#define GEM_USX_BLOCK_LOCK_OFFSET		0
+#define GEM_USX_BLOCK_LOCK_SIZE			1
+
 /* Bitfields in TISUBN */
 #define GEM_SUBNSINCR_OFFSET			0
 #define GEM_SUBNSINCR_SIZE			16
@@ -673,6 +711,7 @@
 #define MACB_CAPS_MACB_IS_GEM			BIT(31)
 #define MACB_CAPS_PCS				BIT(24)
 #define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
+#define MACB_CAPS_HIGH_SPEED			BIT(26)
 
 #define MACB_GEM7010_IDNUM			0x009
 #define MACB_GEM7014_IDNU			0x107
@@ -752,6 +791,7 @@
 	})
 
 #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
+#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
 
 /* struct macb_dma_desc - Hardware DMA descriptor
  * @addr: DMA address of data buffer
@@ -1265,6 +1305,7 @@ struct macb {
 	struct macb_pm_data pm_data;
 	struct phylink *pl;
 	struct phylink_config pl_config;
+	u32 serdes_rate;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index bdb57482644c..3146b97eac25 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -87,6 +87,20 @@ static struct sifive_fu540_macb_mgmt *mgmt;
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
 
+enum {
+	HS_MAC_SPEED_100M,
+	HS_MAC_SPEED_1000M,
+	HS_MAC_SPEED_2500M,
+	HS_MAC_SPEED_5000M,
+	HS_MAC_SPEED_10000M,
+	HS_MAC_SPEED_25000M,
+};
+
+enum {
+	MACB_SERDES_RATE_5_PT_15625Gbps = 5,
+	MACB_SERDES_RATE_10_PT_3125Gbps = 10,
+};
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -96,6 +110,8 @@ static struct sifive_fu540_macb_mgmt *mgmt;
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -448,24 +464,37 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 	if (!clk)
 		return;
 
-	switch (speed) {
-	case SPEED_10:
-		rate = 2500000;
-		break;
-	case SPEED_100:
-		rate = 25000000;
-		break;
-	case SPEED_1000:
-		rate = 125000000;
-		break;
-	case SPEED_2500:
-		if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL)
-			rate = 312500000;
-		else
+	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+		switch (bp->serdes_rate) {
+		case MACB_SERDES_RATE_5_PT_15625Gbps:
+			rate = 78125000;
+			break;
+		case MACB_SERDES_RATE_10_PT_3125Gbps:
+			rate = 156250000;
+			break;
+		default:
+			return;
+		}
+	} else {
+		switch (speed) {
+		case SPEED_10:
+			rate = 2500000;
+			break;
+		case SPEED_100:
+			rate = 25000000;
+			break;
+		case SPEED_1000:
 			rate = 125000000;
-		break;
-	default:
-		return;
+			break;
+		case SPEED_2500:
+			if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL)
+				rate = 312500000;
+			else
+				return;
+			break;
+		default:
+			return;
+		}
 	}
 
 	rate_rounded = clk_round_rate(clk, rate);
@@ -494,6 +523,21 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_10GKR:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 10000baseCR_Full);
+			phylink_set(mask, 10000baseER_Full);
+			phylink_set(mask, 10000baseKR_Full);
+			phylink_set(mask, 10000baseLR_Full);
+			phylink_set(mask, 10000baseLRM_Full);
+			phylink_set(mask, 10000baseSR_Full);
+			phylink_set(mask, 10000baseT_Full);
+			phylink_set(mask, 5000baseT_Full);
+			phylink_set(mask, 2500baseX_Full);
+			phylink_set(mask, 1000baseX_Full);
+		}
+	/* fallthrough */
 	case PHY_INTERFACE_MODE_SGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
 			phylink_set(mask, 2500baseT_Full);
@@ -516,6 +560,7 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 		phylink_set(mask, 100baseT_Half);
 		phylink_set(mask, 100baseT_Full);
 		break;
+
 	case PHY_INTERFACE_MODE_1000BASEX:
 	case PHY_INTERFACE_MODE_2500BASEX:
 		phylink_set(mask, 1000baseT_Full);
@@ -537,6 +582,99 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
 	return -EOPNOTSUPP;
 }
 
+static int macb_wait_for_usx_block_lock(struct macb *bp)
+{
+	u32 val;
+
+	return readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
+				  val & GEM_BIT(USX_BLOCK_LOCK),
+				  1, MACB_USX_BLOCK_LOCK_TIMEOUT);
+}
+
+static inline int gem_mac_usx_configure(struct macb *bp, int spd)
+{
+	u32 speed, config;
+
+	gem_writel(bp, NCFGR, GEM_BIT(PCSSEL) |
+		   (~GEM_BIT(SGMIIEN) & gem_readl(bp, NCFGR)));
+	gem_writel(bp, NCR, gem_readl(bp, NCR) |
+		   GEM_BIT(ENABLE_HS_MAC));
+	gem_writel(bp, NCFGR, gem_readl(bp, NCFGR) |
+		   MACB_BIT(FD));
+	config = gem_readl(bp, USX_CONTROL);
+	config = GEM_BFINS(SERDES_RATE, bp->serdes_rate, config);
+	config &= ~GEM_BIT(TX_SCR_BYPASS);
+	config &= ~GEM_BIT(RX_SCR_BYPASS);
+	gem_writel(bp, USX_CONTROL, config |
+		   GEM_BIT(TX_EN));
+	config = gem_readl(bp, USX_CONTROL);
+	gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
+	if (macb_wait_for_usx_block_lock(bp) < 0) {
+		netdev_warn(bp->dev, "USXGMII block lock failed");
+		return -ETIMEDOUT;
+	}
+
+	switch (spd) {
+	case SPEED_10000:
+		if (bp->serdes_rate >= MACB_SERDES_RATE_10_PT_3125Gbps) {
+			speed = HS_MAC_SPEED_10000M;
+		} else {
+			netdev_warn(bp->dev, "10G speed isn't supported by HW");
+			netdev_warn(bp->dev, "Setting speed to 1G");
+			speed = HS_MAC_SPEED_1000M;
+		}
+		break;
+	case SPEED_5000:
+		speed = HS_MAC_SPEED_5000M;
+		break;
+	case SPEED_2500:
+		speed = HS_MAC_SPEED_2500M;
+		break;
+	case SPEED_1000:
+		speed = HS_MAC_SPEED_1000M;
+		break;
+	default:
+	case SPEED_100:
+		speed = HS_MAC_SPEED_100M;
+		break;
+	}
+
+	gem_writel(bp, HS_MAC_CONFIG, GEM_BFINS(HS_MAC_SPEED, speed,
+						gem_readl(bp, HS_MAC_CONFIG)));
+	gem_writel(bp, USX_CONTROL, GEM_BFINS(USX_CTRL_SPEED, speed,
+					      gem_readl(bp, USX_CONTROL)));
+	return 0;
+}
+
+static inline void gem_mac_configure(struct macb *bp, int speed)
+{
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
+		gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
+			   GEM_BIT(PCSSEL) |
+			   gem_readl(bp, NCFGR));
+
+	switch (speed) {
+	case SPEED_2500:
+		gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+			   gem_readl(bp, NCFGR));
+		gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
+			   gem_readl(bp, NCR));
+		break;
+	case SPEED_1000:
+		gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+			   gem_readl(bp, NCFGR));
+		break;
+	case SPEED_100:
+		macb_writel(bp, NCFGR, MACB_BIT(SPD) |
+			    macb_readl(bp, NCFGR));
+		break;
+	default:
+		break;
+	}
+}
+
 static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			   const struct phylink_link_state *state)
 {
@@ -574,32 +712,20 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			reg &= ~GEM_BIT(GBE);
 		macb_or_gem_writel(bp, NCFGR, reg);
 
-		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
-		    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
-		    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
-			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
-				   GEM_BIT(PCSSEL) |
-				   gem_readl(bp, NCFGR));
-
 		reg = macb_readl(bp, NCFGR);
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
+		macb_or_gem_writel(bp, NCFGR, reg);
 
-		switch (state->speed) {
-		case SPEED_2500:
-			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
-				   gem_readl(bp, NCR));
-			break;
-		case SPEED_1000:
-			reg |= GEM_BIT(GBE);
-			break;
-		case SPEED_100:
-			reg |= MACB_BIT(SPD);
-			break;
-		default:
-			break;
+		if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+			if (gem_mac_usx_configure(bp, state->speed) < 0) {
+				spin_unlock_irqrestore(&bp->lock, flags);
+				phylink_mac_change(bp->pl, false);
+				return;
+			}
+		} else {
+			gem_mac_configure(bp, state->speed);
 		}
-		macb_or_gem_writel(bp, NCFGR, reg);
 
 		bp->speed = state->speed;
 		bp->duplex = state->duplex;
@@ -3446,6 +3572,9 @@ static void macb_configure_caps(struct macb *bp,
 		default:
 			break;
 		}
+		dcfg = gem_readl(bp, DCFG12);
+		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
+			bp->caps |= MACB_CAPS_HIGH_SPEED;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
@@ -4434,7 +4563,18 @@ static int macb_probe(struct platform_device *pdev)
 	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
 		u32 interface_supported = 1;
 
-		if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
+		if (phy_mode == PHY_INTERFACE_MODE_USXGMII) {
+			if (!(bp->caps & MACB_CAPS_HIGH_SPEED &&
+			      bp->caps & MACB_CAPS_PCS))
+				interface_supported = 0;
+
+			if (of_property_read_u32(np, "serdes-rate-gbps",
+						 &bp->serdes_rate)) {
+				netdev_err(dev,
+					   "GEM serdes_rate not specified");
+				interface_supported = 0;
+			}
+		} else if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
 		    phy_mode == PHY_INTERFACE_MODE_1000BASEX ||
 		    phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
 			if (!(bp->caps & MACB_CAPS_PCS))
-- 
2.17.1

