Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F562951FE
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503900AbgJUSIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:08:45 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:9624 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409410AbgJUSIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:08:44 -0400
X-Greylist: delayed 1441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 14:08:43 EDT
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09LHh4Hb009087;
        Wed, 21 Oct 2020 10:44:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=YsF8Ot4+/u6+i3ZkfAVt0Ew6Hj0oAJ8XYDbD6hlqfc8=;
 b=EuyweJgBk8R6TXggSYaX9XJ6J+uQflV+lOSWrXyEPOVDntj0nCb3G8GKqsSrt2Xu38qU
 EY9FTZG7w7Q7f1LiMT1tvIxePUga0eYGlbjFOnucilxvKAljoYNNqskjojpH+nHWc5KL
 /L9CqqhHX0kxMVz1hmE54oT8sHihMiHBRzP61EkOeXF9Cbc5IKtEEfNGDdBYR8okblLv
 OAqLkLJCKpPSSwJjp7FlAfz82V5wYUTJ6d7sv4KOf3eNGVHjQYc6udr4n8nYjkdjllPQ
 2RZ4yebxNCuRVMuoz/uyl/8duFzy+2uWo7rwUrwEQXPSGxeiqkt+XSaSIalQAIiWstLm pA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0014ca01.pphosted.com with ESMTP id 347w5y8d14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 10:44:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bifjiu5MbOfptKJi3cBfEhb1xLUY7RVexFg7CqlYZjjI6bfxQqg0MYJ3MrYg3PV0N2iteedWc16yvWk+lAxbGit840uOcYX7tFWc24Nstb7uiD4x18QKn2gMmTrf1aDJCtzybasceWKEgIRNVoB6v2RD4JBYF0XU8dHVr3g54JiB2NWCNIkI14Omy/Zo970TKuLJbNSVPKc4ow3B+TlYY/GYr6oMYXSrfrsl1Pfk3xhbH2W5dhXaVfdw1h5aXmWZWd6RLYu2HiIeBdgVqoxn7f5xVyiGGdv1Cbhnwsc6nVFI7IOud0xCTnLxHYB+EyssoUh1lZXP++N4rTcZjD3wHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsF8Ot4+/u6+i3ZkfAVt0Ew6Hj0oAJ8XYDbD6hlqfc8=;
 b=J7+XLIWjV50yiCdoZGDPF2RfQFDS0W1yzGVinNvDvLc3DFKWxZe8H+uQI6YC93Jh8mjjX6uzXV/5D7axfqzEoDJhOTFFUKeOHFcL55DgzHQZ/WY2a0TAzqke8Km8dlv20YQ1B6F0EyyGF6yGlhdWP5yzW25fxNVRx6jLoB5/ezc2wFZrqFx22tRvpPEmgufrOri9eDrbS5xOB+6HbU+bOhb84BwHhYH3Vy7HN0T1P1DL3/yxxH7remXUx/htudhXBfCeRI0hGAAY/jucspY82o5xBSk5hvrhL3onvLU6tDHHxGhYUhOTao9bMr/f6a7gZN+AIXaUHMgSTXfFadlo3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=microchip.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsF8Ot4+/u6+i3ZkfAVt0Ew6Hj0oAJ8XYDbD6hlqfc8=;
 b=p0IldNTdvMb1f06c3V//w8aa6tJI7eYobJPB+cKffoC9qYYKvuMb/W0fdLuHo2vobJFOTO3r2aDboVdb4fbvIru0zIU3wvRYpDh5C0vxbjSbfTVKjDjReZKpIcbN41W/zl4NlAtrxde5/FRReKnNBPCk2bxe98O8lzH6e+Q2n48=
Received: from DM3PR03CA0003.namprd03.prod.outlook.com (2603:10b6:0:50::13) by
 CO2PR07MB2584.namprd07.prod.outlook.com (2603:10b6:102:14::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.26; Wed, 21 Oct 2020 17:44:23 +0000
Received: from DM6NAM12FT068.eop-nam12.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::c2) by DM3PR03CA0003.outlook.office365.com
 (2603:10b6:0:50::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Wed, 21 Oct 2020 17:44:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 DM6NAM12FT068.mail.protection.outlook.com (10.13.179.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.7 via Frontend Transport; Wed, 21 Oct 2020 17:44:22 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 09LHiJOg018940
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 21 Oct 2020 10:44:20 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 21 Oct 2020 19:44:16 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 21 Oct 2020 19:44:16 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 09LHiG9B030704;
        Wed, 21 Oct 2020 19:44:16 +0200
Received: (from pthombar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 09LHi8jl030703;
        Wed, 21 Oct 2020 19:44:08 +0200
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <linux@armlinux.org.uk>
CC:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mparab@cadence.com>, Parshuram Thombare <pthombar@cadence.com>
Subject: [PATCH v3] net: macb: add support for high speed interface
Date:   Wed, 21 Oct 2020 19:44:05 +0200
Message-ID: <1603302245-30654-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fca70ff-2165-4fea-bfcf-08d875e8f21b
X-MS-TrafficTypeDiagnostic: CO2PR07MB2584:
X-Microsoft-Antispam-PRVS: <CO2PR07MB258452C30FF4098C8EDE768AC11C0@CO2PR07MB2584.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x7hlUaIVFyY0qx5MvzXgZ0CvniFovPIkxdDCI6XWVba+1vABk79bbzylCO/jE/x6+o+ZFw1ymUCifusHhskf6h2Nb+uyeaifPNBUAXqxiN3KtnOoYXpgfLg57xVqsZn4LrURtTNJotn6AWWsvyXYjibo0IZk1MONQqrKY+CZk/JAe1UMj9sEi3Z0DH1VwzvePhyAwDlwRjp+67Dr6ADWpdF+UzXw5kJSPfVu0vHmGaRxLc2AAUFLFzCCM6Z9lpPvvUkg+8+uXrPetHexm1SCjgrB9qeqjcz9CPxYjyoiFn/1oUAJYlJUJD5RfYXildwE7lFelgJnXPZjMuoiDVklbP5eO1fwchLiZrPPfskrbUf68fXYzuaHl97JL/gXFs+/2vUw96AJolyPUk1NXemu8A6QmhmGoRtC0R6etq51sF4=
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(36092001)(46966005)(47076004)(110136005)(42186006)(82310400003)(82740400003)(54906003)(316002)(36906005)(5660300002)(7636003)(6666004)(4326008)(70586007)(70206006)(30864003)(426003)(83380400001)(107886003)(356005)(336012)(26005)(186003)(2906002)(8936002)(478600001)(8676002)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 17:44:22.6263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fca70ff-2165-4fea-bfcf-08d875e8f21b
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT068.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2584
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_09:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for 10GBASE-R interface to the linux driver for
Cadence's ethernet controller.
This controller has separate MAC's and PCS'es for low and high speed paths.
High speed PCS supports 100M, 1G, 2.5G, 5G and 10G through rate adaptation
implementation. However, since it doesn't support auto negotiation, linux
driver is modified to support 10GBASE-R insted of USXGMII. 

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
Changes between v2 and v3:
1. Replace USXGMII interface by 10GBASE-R interface.
2. Adopted new phylink pcs_ops for high speed PCS.
3. Added pcs_get_state for high speed PCS.

---
 drivers/net/ethernet/cadence/macb.h      |   44 ++++++++++++
 drivers/net/ethernet/cadence/macb_main.c |  112 +++++++++++++++++++++++++++++-
 2 files changed, 155 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 5de47f6..1f5da4e 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -77,10 +77,12 @@
 #define MACB_RBQPH		0x04D4
 
 /* GEM register offsets. */
+#define GEM_NCR			0x0000 /* Network Control */
 #define GEM_NCFGR		0x0004 /* Network Config */
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
 #define GEM_JML			0x0048 /* Jumbo Max Length */
+#define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
 #define GEM_HRB			0x0080 /* Hash Bottom */
 #define GEM_HRT			0x0084 /* Hash Top */
 #define GEM_SA1B		0x0088 /* Specific1 Bottom */
@@ -166,6 +168,9 @@
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_USX_CONTROL		0x0A80 /* High speed PCS control register */
+#define GEM_USX_STATUS		0x0A88 /* High speed PCS status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -272,11 +277,19 @@
 #define MACB_IRXFCS_OFFSET	19
 #define MACB_IRXFCS_SIZE	1
 
+/* GEM specific NCR bitfields. */
+#define GEM_ENABLE_HS_MAC_OFFSET	31
+#define GEM_ENABLE_HS_MAC_SIZE		1
+
 /* GEM specific NCFGR bitfields. */
+#define GEM_FD_OFFSET		1 /* Full duplex */
+#define GEM_FD_SIZE		1
 #define GEM_GBE_OFFSET		10 /* Gigabit mode enable */
 #define GEM_GBE_SIZE		1
 #define GEM_PCSSEL_OFFSET	11
 #define GEM_PCSSEL_SIZE		1
+#define GEM_PAE_OFFSET		13 /* Pause enable */
+#define GEM_PAE_SIZE		1
 #define GEM_CLK_OFFSET		18 /* MDC clock division */
 #define GEM_CLK_SIZE		3
 #define GEM_DBW_OFFSET		21 /* Data bus width */
@@ -461,11 +474,17 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfield in HS_MAC_CONFIG */
+#define GEM_HS_MAC_SPEED_OFFSET			0
+#define GEM_HS_MAC_SPEED_SIZE			3
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
@@ -500,6 +519,28 @@
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
+#define GEM_TX_EN_OFFSET			1
+#define GEM_TX_EN_SIZE				1
+#define GEM_SIGNAL_OK_OFFSET			0
+#define GEM_SIGNAL_OK_SIZE			1
+
+/* Bitfields in USX_STATUS. */
+#define GEM_USX_BLOCK_LOCK_OFFSET		0
+#define GEM_USX_BLOCK_LOCK_SIZE			1
+
 /* Bitfields in TISUBN */
 #define GEM_SUBNSINCR_OFFSET			0
 #define GEM_SUBNSINCRL_OFFSET			24
@@ -663,6 +704,8 @@
 #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
 #define MACB_CAPS_SG_DISABLED			0x40000000
 #define MACB_CAPS_MACB_IS_GEM			0x80000000
+#define MACB_CAPS_PCS				0x01000000
+#define MACB_CAPS_HIGH_SPEED			0x02000000
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
@@ -1201,6 +1244,7 @@ struct macb {
 	struct mii_bus		*mii_bus;
 	struct phylink		*phylink;
 	struct phylink_config	phylink_config;
+	struct phylink_pcs	phylink_pcs;
 
 	u32			caps;
 	unsigned int		dma_burst_length;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 883e47c..8b44876 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -84,6 +84,9 @@ struct sifive_fu540_macb_mgmt {
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
 
+#define HS_SPEED_10000M			4
+#define MACB_SERDES_RATE_10G		1
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -513,6 +516,7 @@ static void macb_validate(struct phylink_config *config,
 	    state->interface != PHY_INTERFACE_MODE_RMII &&
 	    state->interface != PHY_INTERFACE_MODE_GMII &&
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
 	    !phy_interface_mode_is_rgmii(state->interface)) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
@@ -525,10 +529,31 @@ static void macb_validate(struct phylink_config *config,
 		return;
 	}
 
+	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
+	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
+	      bp->caps & MACB_CAPS_PCS)) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
 
+	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
+	    (state->interface == PHY_INTERFACE_MODE_NA ||
+	     state->interface == PHY_INTERFACE_MODE_10GBASER)) {
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseER_Full);
+		phylink_set(mask, 10000baseKR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseT_Full);
+		if (state->interface != PHY_INTERFACE_MODE_NA)
+			goto out;
+	}
+
 	phylink_set(mask, 10baseT_Half);
 	phylink_set(mask, 10baseT_Full);
 	phylink_set(mask, 100baseT_Half);
@@ -545,12 +570,70 @@ static void macb_validate(struct phylink_config *config,
 		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
 			phylink_set(mask, 1000baseT_Half);
 	}
-
+out:
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+				 phy_interface_t interface, int speed,
+				 int duplex)
+{
+	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	u32 config;
+
+	config = gem_readl(bp, USX_CONTROL);
+	config = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, config);
+	config &= ~GEM_BIT(TX_SCR_BYPASS);
+	config &= ~GEM_BIT(RX_SCR_BYPASS);
+	config |= GEM_BIT(TX_EN);
+	gem_writel(bp, USX_CONTROL, GEM_BFINS(USX_CTRL_SPEED, HS_SPEED_10000M,
+					      config));
+}
+
+static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
+				   struct phylink_link_state *state)
+{
+	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	u32 val;
+
+	state->speed = SPEED_10000;
+	state->duplex = 1;
+	state->an_complete = 1;
+
+	val = gem_readl(bp, USX_STATUS);
+	state->link = !!(val & GEM_BIT(USX_BLOCK_LOCK));
+	val = gem_readl(bp, NCFGR);
+	if (val & GEM_BIT(PAE))
+		state->pause = MLO_PAUSE_RX;
+}
+
+static int macb_usx_pcs_config(struct phylink_pcs *pcs,
+			       unsigned int mode,
+			       phy_interface_t interface,
+			       const unsigned long *advertising,
+			       bool permit_pause_to_mac)
+{
+	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	u32 val;
+
+	val = gem_readl(bp, NCFGR);
+	val = GEM_BIT(PCSSEL) | (~GEM_BIT(SGMIIEN) & val);
+	gem_writel(bp, NCFGR, val);
+
+	val = gem_readl(bp, USX_CONTROL);
+	gem_writel(bp, USX_CONTROL, val | GEM_BIT(SIGNAL_OK));
+
+	return 0;
+}
+
+static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
+	.pcs_get_state = macb_usx_pcs_get_state,
+	.pcs_config = macb_usx_pcs_config,
+	.pcs_link_up = macb_usx_pcs_link_up,
+};
+
 static void macb_mac_pcs_get_state(struct phylink_config *config,
 				   struct phylink_link_state *state)
 {
@@ -588,6 +671,9 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_10GBASER)
+		gem_writel(bp, NCR, gem_readl(bp, NCR) | GEM_BIT(ENABLE_HS_MAC));
+
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
@@ -664,6 +750,10 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	macb_or_gem_writel(bp, NCFGR, ctrl);
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_10GBASER)
+		gem_writel(bp, HS_MAC_CONFIG, GEM_BFINS(HS_MAC_SPEED, HS_SPEED_10000M,
+							gem_readl(bp, HS_MAC_CONFIG)));
+
 	spin_unlock_irqrestore(&bp->lock, flags);
 
 	/* Enable Rx and Tx */
@@ -672,9 +762,24 @@ static void macb_mac_link_up(struct phylink_config *config,
 	netif_tx_wake_all_queues(ndev);
 }
 
+static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct macb *bp = netdev_priv(ndev);
+
+	if (interface == PHY_INTERFACE_MODE_10GBASER) {
+		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
+		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
+	}
+
+	return 0;
+}
+
 static const struct phylink_mac_ops macb_phylink_ops = {
 	.validate = macb_validate,
 	.mac_pcs_get_state = macb_mac_pcs_get_state,
+	.mac_prepare = macb_mac_prepare,
 	.mac_an_restart = macb_mac_an_restart,
 	.mac_config = macb_mac_config,
 	.mac_link_down = macb_mac_link_down,
@@ -3523,6 +3628,11 @@ static void macb_configure_caps(struct macb *bp,
 		dcfg = gem_readl(bp, DCFG1);
 		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
 			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
+		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
+			bp->caps |= MACB_CAPS_PCS;
+		dcfg = gem_readl(bp, DCFG12);
+		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
+			bp->caps |= MACB_CAPS_HIGH_SPEED;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
-- 
1.7.1

