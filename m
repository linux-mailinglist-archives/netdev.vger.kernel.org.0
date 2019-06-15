Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1C0472A8
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 02:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfFPArq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 20:47:46 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:34018 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbfFPArq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 20:47:46 -0400
X-Greylist: delayed 3677 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Jun 2019 20:47:44 EDT
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNm78c028068;
        Sat, 15 Jun 2019 16:48:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=bnTTUA0ptamDuxmRXW/zfAVOXLr0tETAmjdwULWkSrc=;
 b=XKUGpBn1sLfntPKPyxTrBE9Y++ZUXiKWdPTYjRoyPvOGnmh/lYbSewvBrOr9FHZ9mIgn
 75PjPJnCefV0XjgfzIHzN0sjXmHiUsy+OzZQqIU7vAUdkw/ZYZzqGUjeCo/vDD5CogDo
 xgZkO/10wLMyule7RsvCfqty9TAQLNaFjFPmflMNKGdDwcL4zsbC4LW8OfxR7q3HUN+J
 MgCRHs8RJm4kBLAPT2ITjGsDzp3gv5aYsHU0yemYMXwokz++Z32o4HGCLbVwsXUSxkcr
 uYVYNyRLedzZHStEtMGppCFJOFf+1fprQiYDJHgG9vWQCEpzxApZyx+JbnNWEKkHRJgN fg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2057.outbound.protection.outlook.com [104.47.42.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t4w7v1rc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:48:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnTTUA0ptamDuxmRXW/zfAVOXLr0tETAmjdwULWkSrc=;
 b=rm1asMNclLSslnDBv6M1dN1cVTT2WxijAkDY1Ly69DfGl7nZWkkGCGt7iCuv17VlSlvnsaGIVAb5vIM8ol+Isatzr4x3/7k33d6FiMNMXbtcDKdQsUrxclDHHCI147IhShQLVacrdfyQGZk0Rsa3RLHyETTnAAq6gZAYs8IikaQ=
Received: from DM6PR07CA0035.namprd07.prod.outlook.com (20.176.74.48) by
 DM6PR07MB6828.namprd07.prod.outlook.com (20.179.70.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Sat, 15 Jun 2019 23:48:38 +0000
Received: from BY2NAM05FT024.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::207) by DM6PR07CA0035.outlook.office365.com
 (2603:10b6:5:94::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1965.15 via Frontend
 Transport; Sat, 15 Jun 2019 23:48:38 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 BY2NAM05FT024.mail.protection.outlook.com (10.152.100.161) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:48:38 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNmaBa031884
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 16:48:37 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:48:35 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:48:34 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNmYNO028922;
        Sun, 16 Jun 2019 00:48:34 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 5/6] net: macb: add support for high speed interface
Date:   Sun, 16 Jun 2019 00:48:32 +0100
Message-ID: <1560642512-28765-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
References: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39850400004)(136003)(396003)(2980300002)(199004)(189003)(36092001)(53416004)(478600001)(486006)(126002)(446003)(476003)(76176011)(11346002)(86362001)(5660300002)(7696005)(246002)(48376002)(7126003)(2616005)(107886003)(186003)(2201001)(47776003)(26826003)(426003)(51416003)(336012)(356004)(26005)(14444005)(2906002)(305945005)(50226002)(110136005)(77096007)(316002)(54906003)(16586007)(70586007)(30864003)(8936002)(70206006)(8676002)(76130400001)(4326008)(36756003)(7636002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6828;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fabcd084-9f21-49a7-8da5-08d6f1ebfd1b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR07MB6828;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6828:
X-Microsoft-Antispam-PRVS: <DM6PR07MB68283BF6FAB9F8FA95A488C7C1E90@DM6PR07MB6828.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: LKivYVU301kTM8QQPwohcJ7DvaQK2ElbAnu8xeNc1mfOjBUBzPUdbf9n5ufN2UfGte4f0oEeP3paETykBhG1fV3aqKa76UKTtRoHo2sMsmqJFIbO+HQt7Tw6vBNC3jKE3o1gAiO0nn+GMpneM3HlEoDD+j8tnZl9/rC8kg+mCNsgTBRjcnD7gQVwsKYlwasEy07idyvxVzsehNiucIBU5NC830muLfKgrJSto/E5RHlec2LRB0fvSg3Mnm3pTJ1RSbv8Nwt2uAKBvKjdnx780unbkTMBsPXZ4C49n5kB14Hl9YOcNO1G5nGIezf4gpy2UShbzBehSJNNWnB7zCjb/yV7WXT50oZHULkTOOGfwh6HFhyzhljPixflHoCsL6C+GG1jWK5g45iuwPcwOEwoF/L2EoLqJXHB+mLtvE4jt8E=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:48:38.4823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fabcd084-9f21-49a7-8da5-08d6f1ebfd1b
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6828
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
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150226
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  42 +++++
 drivers/net/ethernet/cadence/macb_main.c | 219 +++++++++++++++++++----
 2 files changed, 228 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 75f093bc52fe..e00b9f647757 100644
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
@@ -172,6 +173,9 @@
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
+#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -279,6 +283,8 @@
 #define MACB_IRXFCS_SIZE	1
 
 /* GEM specific NCR bitfields. */
+#define GEM_ENABLE_HS_MAC_OFFSET	31
+#define GEM_ENABLE_HS_MAC_SIZE		1
 #define GEM_TWO_PT_FIVE_GIG_OFFSET	29
 #define GEM_TWO_PT_FIVE_GIG_SIZE	1
 
@@ -470,6 +476,10 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfield in HS_MAC_CONFIG */
+#define GEM_HS_MAC_SPEED_OFFSET			0
+#define GEM_HS_MAC_SPEED_SIZE			3
+
 /* Bitfields in PCS_CONTROL. */
 #define GEM_PCS_CTRL_RST_OFFSET			15
 #define GEM_PCS_CTRL_RST_SIZE			1
@@ -535,6 +545,34 @@
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
@@ -695,6 +733,7 @@
 #define MACB_CAPS_MACB_IS_GEM			BIT(31)
 #define MACB_CAPS_PCS				BIT(24)
 #define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
+#define MACB_CAPS_HIGH_SPEED			BIT(26)
 
 #define MACB_GEM7010_IDNUM			0x009
 #define MACB_GEM7014_IDNUM			0x107
@@ -774,6 +813,7 @@
 	})
 
 #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
+#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
 
 /* struct macb_dma_desc - Hardware DMA descriptor
  * @addr: DMA address of data buffer
@@ -1287,6 +1327,8 @@ struct macb {
 	struct macb_pm_data pm_data;
 	struct phylink *pl;
 	struct phylink_config pl_config;
+	u32 serdes_rate;
+	u32 fixed_speed;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 57ffc4e9d2b9..4af0b434e818 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -77,6 +77,20 @@
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
+	MACB_SERDES_RATE_5_PT_15625Gbps,
+	MACB_SERDES_RATE_10_PT_3125Gbps,
+};
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -86,6 +100,8 @@
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -438,24 +454,37 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
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
@@ -484,6 +513,22 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
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
+		/* Fall-through */
 	case PHY_INTERFACE_MODE_SGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
 			phylink_set(mask, 2500baseT_Full);
@@ -594,17 +639,55 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			reg |= MACB_BIT(FD);
 		macb_or_gem_writel(bp, NCFGR, reg);
 
-		if (state->speed == SPEED_2500) {
-			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
-				   gem_readl(bp, NCFGR));
-			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
-				   gem_readl(bp, NCR));
-		} else if (state->speed == SPEED_1000) {
-			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
-				   gem_readl(bp, NCFGR));
-		} else if (state->speed == SPEED_100) {
-			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
-				    macb_readl(bp, NCFGR));
+		if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+			u32 speed;
+
+			switch (state->speed) {
+			case SPEED_10000:
+				if (bp->serdes_rate ==
+				    MACB_SERDES_RATE_10_PT_3125Gbps) {
+					speed = HS_MAC_SPEED_10000M;
+				} else {
+					netdev_warn(netdev,
+						    "10G not supported by HW");
+					netdev_warn(netdev, "Setting speed to 1G");
+					speed = HS_MAC_SPEED_1000M;
+				}
+				break;
+			case SPEED_5000:
+				speed = HS_MAC_SPEED_5000M;
+				break;
+			case SPEED_2500:
+				speed = HS_MAC_SPEED_2500M;
+				break;
+			case SPEED_1000:
+				speed = HS_MAC_SPEED_1000M;
+				break;
+			default:
+			case SPEED_100:
+				speed = HS_MAC_SPEED_100M;
+				break;
+			}
+
+			gem_writel(bp, HS_MAC_CONFIG,
+				   GEM_BFINS(HS_MAC_SPEED, speed,
+					     gem_readl(bp, HS_MAC_CONFIG)));
+			gem_writel(bp, USX_CONTROL,
+				   GEM_BFINS(USX_CTRL_SPEED, speed,
+					     gem_readl(bp, USX_CONTROL)));
+		} else {
+			if (state->speed == SPEED_2500) {
+				gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+					   gem_readl(bp, NCFGR));
+				gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
+					   gem_readl(bp, NCR));
+			} else if (state->speed == SPEED_1000) {
+				gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+					   gem_readl(bp, NCFGR));
+			} else if (state->speed == SPEED_100) {
+				macb_writel(bp, NCFGR, MACB_BIT(SPD) |
+					    macb_readl(bp, NCFGR));
+			}
 		}
 
 		bp->speed = state->speed;
@@ -649,6 +732,16 @@ static const struct phylink_mac_ops gem_phylink_ops = {
 	.mac_link_down = gem_mac_link_down,
 };
 
+void gem_usx_fixed_state(struct net_device *dev,
+			 struct phylink_link_state *state)
+{
+	struct macb *bp = netdev_priv(dev);
+
+	state->speed = (bp->fixed_speed == SPEED_UNKNOWN) ? SPEED_1000
+			: bp->fixed_speed;
+	state->duplex = 1;
+}
+
 /* based on au1000_eth. c*/
 static int macb_mii_probe(struct net_device *dev)
 {
@@ -660,6 +753,8 @@ static int macb_mii_probe(struct net_device *dev)
 	np = bp->pdev->dev.of_node;
 	ret = 0;
 
+	bp->pl_config.dev = &dev->dev;
+	bp->pl_config.type = PHYLINK_NETDEV;
 	bp->pl_config.dev = &dev->dev;
 	bp->pl_config.type = PHYLINK_NETDEV;
 	bp->pl = phylink_create(&bp->pl_config, of_fwnode_handle(np),
@@ -670,6 +765,9 @@ static int macb_mii_probe(struct net_device *dev)
 		return PTR_ERR(bp->pl);
 	}
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII)
+		phylink_fixed_state_cb(bp->pl, gem_usx_fixed_state);
+
 	ret = phylink_of_phy_connect(bp->pl, np, 0);
 	if (ret == -ENODEV && bp->mii_bus) {
 		phydev = phy_find_first(bp->mii_bus);
@@ -2337,11 +2435,19 @@ static void macb_configure_dma(struct macb *bp)
 	}
 }
 
-static void macb_init_hw(struct macb *bp)
+static int macb_wait_for_usx_block_lock(struct macb *bp)
+{
+	u32 val;
+
+	return readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
+				  val & GEM_BIT(USX_BLOCK_LOCK),
+				  1, MACB_USX_BLOCK_LOCK_TIMEOUT);
+}
+
+static int macb_init_hw(struct macb *bp)
 {
 	struct macb_queue *queue;
 	unsigned int q;
-
 	u32 config;
 
 	macb_reset_hw(bp);
@@ -2375,6 +2481,25 @@ static void macb_init_hw(struct macb *bp)
 	if (bp->caps & MACB_CAPS_JUMBO)
 		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+		bp->speed = 10000;
+		bp->duplex = 1;
+		gem_writel(bp, NCR, gem_readl(bp, NCR) |
+			   GEM_BIT(ENABLE_HS_MAC));
+		gem_writel(bp, NCFGR, gem_readl(bp, NCFGR) |
+			   MACB_BIT(FD) | GEM_BIT(PCSSEL));
+		config = gem_readl(bp, USX_CONTROL);
+		config = GEM_BFINS(SERDES_RATE, bp->serdes_rate, config);
+		config &= ~GEM_BIT(TX_SCR_BYPASS);
+		config &= ~GEM_BIT(RX_SCR_BYPASS);
+		gem_writel(bp, USX_CONTROL, config |
+			   GEM_BIT(TX_EN));
+		config = gem_readl(bp, USX_CONTROL);
+		gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
+		if (macb_wait_for_usx_block_lock(bp) < 0)
+			return -ETIMEDOUT;
+	}
+
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
 	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
 	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
@@ -2410,6 +2535,7 @@ static void macb_init_hw(struct macb *bp)
 
 	/* Enable TX and RX */
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
+	return 0;
 }
 
 /* The hash address register is 64 bits long and takes up two
@@ -2568,7 +2694,9 @@ static int macb_open(struct net_device *dev)
 		napi_enable(&queue->napi);
 
 	bp->macbgem_ops.mog_init_rings(bp);
-	macb_init_hw(bp);
+	err = macb_init_hw(bp);
+	if (err)
+		goto init_hw_exit;
 
 	/* schedule a link state check */
 	phylink_start(bp->pl);
@@ -2578,6 +2706,9 @@ static int macb_open(struct net_device *dev)
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_init(dev);
 
+init_hw_exit:
+	if (err)
+		macb_free_consistent(bp);
 pm_exit:
 	if (err) {
 		pm_runtime_put_sync(&bp->pdev->dev);
@@ -3493,6 +3624,9 @@ static void macb_configure_caps(struct macb *bp,
 		default:
 			break;
 		}
+		dcfg = gem_readl(bp, DCFG12);
+		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
+			bp->caps |= MACB_CAPS_HIGH_SPEED;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
@@ -3784,7 +3918,12 @@ static int macb_init(struct platform_device *pdev)
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
 	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
 	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
-		val |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
+		val |= GEM_BIT(SGMIIEN);
+	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
+		val |= GEM_BIT(PCSSEL);
 	macb_writel(bp, NCFGR, val);
 
 	return 0;
@@ -4372,7 +4511,21 @@ static int macb_probe(struct platform_device *pdev)
 	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
 		u32 interface_supported = 1;
 
-		if (err == PHY_INTERFACE_MODE_SGMII ||
+		if (err == PHY_INTERFACE_MODE_USXGMII) {
+			if (!(bp->caps & MACB_CAPS_HIGH_SPEED &&
+			      bp->caps & MACB_CAPS_PCS))
+				interface_supported = 0;
+
+			if (of_property_read_u32(np, "serdes-rate",
+						 &bp->serdes_rate)) {
+				netdev_err(dev,
+					   "GEM serdes_rate not specified");
+				interface_supported = 0;
+			}
+			if (of_property_read_u32(np, "fixed-speed",
+						 &bp->fixed_speed))
+				bp->fixed_speed = SPEED_UNKNOWN;
+		} else if (err == PHY_INTERFACE_MODE_SGMII ||
 		    err == PHY_INTERFACE_MODE_1000BASEX ||
 		    err == PHY_INTERFACE_MODE_2500BASEX) {
 			if (!(bp->caps & MACB_CAPS_PCS))
-- 
2.17.1

