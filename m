Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FDB11E113
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfLMJnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:43:31 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:42626 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbfLMJnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:43:31 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBD9fw5H016784;
        Fri, 13 Dec 2019 01:43:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=LkRgv6k5Q2qVKk151d5nc3Csyk7Qtq3Mgq94mtBNqNo=;
 b=RxTDLvdZfyUVS0pMaYrJfy4ITJFOeqZMxkGj43vv+fYOBKXRTHP+myVpSa8Y+Fpv2yEL
 7qwUrukLQbCXJB5we/eCr8f0HKR/N2mgFSFSLlvYXnqmAqnAkTKEwMdvlyuoz2edIqcu
 u995lacIstUiam9FGJbxD63aneDKTYAOMtcU6X32th5WSK9S4lbyOdUeL5yiRHUfmrFe
 bqzDDVJ/+FOWMqa00cDj8C0hWBAQ0bjsFc/c6jpKnQZ+lS7kwAi3u0z86aLuNbs4sJnP
 eVJFW6cWwKMmJiimnIuyu/OnX7Ima9IhhxWqlh+6klbjq5AP8K9bluaEN3WkqyuYlE6Q sQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wra70nw7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 01:43:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAE8jrcqw/G5eXz7gsaQIWLYgUyok6kjdNAqvKcvTgmLrhTkWv6NhryNi7kPtFfmOHQrw63WvMmNA0rVSHDm1UOlioGE1O7hCYx9c9kMOu8u8WT08B0jEsi1qQrw8JdP4wdU4QzS42XLSx/LtwOpM5HjW7vtWTgUnJJKjhWIPSFCN+Aik3K9V01uoTKm1vAPr0SA9iqlI+fw8GEKHJHir0a9MHqM2wSbJLgVXvC+o99pDjnsS1VbEy6uj1pYSXDXXLn/DvBHalPg0/P6re+Z+o0F8X+acZvPM9R47xe0U9DTsUtJ3e8eeIhCOxQdHdu4HUJMQ+KrkbVqizdDW0m1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkRgv6k5Q2qVKk151d5nc3Csyk7Qtq3Mgq94mtBNqNo=;
 b=l8q0uWHjzkbjI24T9kpzTfIbjzYZUmDKHl/elCjXNVHDm4Ky6Qa7UVqc+13dKvtPDYEckwKGqi75c1MdZXnVSfPkWkT2Ga3UwKiZ3onQQmuhnpv5pMYFtMDJL9QaZU2GlgwN00vSiUPvl7qyhg/PoR1rt1xglIjXj1MDq1D3uvPVg0azckD9PR7k1xI3PoSTb5vFDYwL6uBNSrK2mrOIk0aq1zBoFcUkQrEp1qHIgm5HrcbSwH6Re+/0hX16qvhnoOr4ykaK6IB3zWs99wwEHaT1Io0zuqUuvF4BihV6wF3R2Dx685QzZ/BWqu1e8Nsj7FdmNy0K5TZpXap01iv0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkRgv6k5Q2qVKk151d5nc3Csyk7Qtq3Mgq94mtBNqNo=;
 b=Dn2948FhX7LKx23wbFBofkSVYcxofQTWK8cAoFLBM1n5vHDILT6ltfh9jfGhTyr3x7R+2X/FpNDdX9mfWtsUkt+Q+mVRvezd9duRlU4F+rj/sM3ONv6joXA/YdFQ0R/Qxd1mtPdopkfLee+0UALbQ+DoeLdFCc2R4J3sZiTJJQU=
Received: from CO2PR07CA0080.namprd07.prod.outlook.com (2603:10b6:100::48) by
 BY5PR07MB6643.namprd07.prod.outlook.com (2603:10b6:a03:1a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.14; Fri, 13 Dec
 2019 09:43:04 +0000
Received: from BN8NAM12FT034.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::203) by CO2PR07CA0080.outlook.office365.com
 (2603:10b6:100::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.15 via Frontend
 Transport; Fri, 13 Dec 2019 09:43:04 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.28; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BN8NAM12FT034.mail.protection.outlook.com (10.13.183.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16 via Frontend Transport; Fri, 13 Dec 2019 09:43:03 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9gx0O012318
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 13 Dec 2019 04:43:01 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 13 Dec 2019 10:42:59 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 13 Dec 2019 10:42:59 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9gwTS011439;
        Fri, 13 Dec 2019 09:42:58 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <rmk+kernel@armlinux.org.uk>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH v2 3/3] net: macb: add support for high speed interface
Date:   Fri, 13 Dec 2019 09:42:57 +0000
Message-ID: <1576230177-11404-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1576230007-11181-1-git-send-email-mparab@cadence.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(189003)(199004)(36092001)(7696005)(2616005)(30864003)(4326008)(7126003)(336012)(5660300002)(426003)(7416002)(478600001)(76130400001)(86362001)(36756003)(26005)(26826003)(186003)(356004)(70586007)(8676002)(81156014)(2906002)(81166006)(54906003)(110136005)(316002)(70206006)(107886003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB6643;H:rmmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 495a0ba9-272b-4712-c7b8-08d77fb0d960
X-MS-TrafficTypeDiagnostic: BY5PR07MB6643:
X-Microsoft-Antispam-PRVS: <BY5PR07MB66434A6A64B4E759604BA480D3540@BY5PR07MB6643.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0250B840C1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DaDFSuNAo6OT3lNoTPY0KxcvX7t14pHlDF5gePy7fBxudlZPg4XDWhQdeBGTrAdh1Ggjf/gadGBdYFf1XBZF3umhevAsRCMkPaYPmDhJbxpk3f+FeJrbJD2Fpu2w3Ck+GAOI+0ZwfY3K0RS+xzOsjhJylH+fH09DtHzbpX2xHUJZnVV+ygKibdJcTOg1O/xcq1vlIchvgwFYhLX7mQXtmDH/68BvjUIdawbxW3Tjirw/7ozwzwEJe+hoL208ZE2HGxWzvuvmazTIHr3Q3Vhl91i1NDjn8GMuLGbXeE5223fNvlqTj6agJ1oh/d0iNgjm41fXYe/qazSKQYhYXUmbfpAhnESVYHWrLx9NPQ/qHZIHg5opOE+IlWJxVEI4qExvhU3ZRMyOE1JwMTH8j9qmvd0GzLRU1jSdjPOZChO0l8Rs3yY8fZZq20uhB6kowEsKlfjwnnOZNNB8xOXXWkuASeoII1nkiKqAWYtRIreW40wQXIZEm3/iEDba6zf0tgQi
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2019 09:43:03.3894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 495a0ba9-272b-4712-c7b8-08d77fb0d960
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB6643
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_02:2019-12-12,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  50 ++++++++
 drivers/net/ethernet/cadence/macb_main.c | 138 ++++++++++++++++++++---
 2 files changed, 170 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index dbf7070fcdba..b731807d1c49 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -76,10 +76,12 @@
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
@@ -164,6 +166,9 @@
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
+#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -270,11 +275,19 @@
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
@@ -455,11 +468,17 @@
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
@@ -494,6 +513,34 @@
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
 #define GEM_SUBNSINCRL_OFFSET			24
@@ -656,6 +703,8 @@
 #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
 #define MACB_CAPS_SG_DISABLED			0x40000000
 #define MACB_CAPS_MACB_IS_GEM			0x80000000
+#define MACB_CAPS_PCS				0x01000000
+#define MACB_CAPS_HIGH_SPEED			0x02000000
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
@@ -724,6 +773,7 @@
 	})
 
 #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
+#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
 
 /* struct macb_dma_desc - Hardware DMA descriptor
  * @addr: DMA address of data buffer
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ced32d2a85e1..5963a60d54b9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -81,6 +81,14 @@ struct sifive_fu540_macb_mgmt {
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
 
+#define HS_MAC_SPEED_100M	0
+#define HS_MAC_SPEED_1000M	1
+#define HS_MAC_SPEED_2500M	2
+#define HS_MAC_SPEED_5000M	3
+#define HS_MAC_SPEED_10000M	4
+
+#define MACB_SERDES_RATE_10G	1
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -90,6 +98,8 @@ struct sifive_fu540_macb_mgmt {
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -506,6 +516,7 @@ static void macb_validate(struct phylink_config *config,
 	    state->interface != PHY_INTERFACE_MODE_RMII &&
 	    state->interface != PHY_INTERFACE_MODE_GMII &&
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    state->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    !phy_interface_mode_is_rgmii(state->interface)) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
@@ -518,6 +529,13 @@ static void macb_validate(struct phylink_config *config,
 		return;
 	}
 
+	if (state->interface == PHY_INTERFACE_MODE_USXGMII &&
+	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
+	      bp->caps & MACB_CAPS_PCS)) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Asym_Pause);
@@ -527,6 +545,22 @@ static void macb_validate(struct phylink_config *config,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
+	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
+	    (state->interface == PHY_INTERFACE_MODE_NA ||
+	     state->interface == PHY_INTERFACE_MODE_USXGMII)) {
+		phylink_set(mask, 10000baseCR_Full);
+		phylink_set(mask, 10000baseER_Full);
+		phylink_set(mask, 10000baseKR_Full);
+		phylink_set(mask, 10000baseLR_Full);
+		phylink_set(mask, 10000baseLRM_Full);
+		phylink_set(mask, 10000baseSR_Full);
+		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 5000baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+		phylink_set(mask, 1000baseX_Full);
+		phylink_set(mask, 1000baseT_Full);
+	}
+
 	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
 	    (state->interface == PHY_INTERFACE_MODE_NA ||
 	     state->interface == PHY_INTERFACE_MODE_GMII ||
@@ -544,6 +578,60 @@ static void macb_validate(struct phylink_config *config,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static int gem_mac_usx_configure(struct macb *bp,
+				 const struct phylink_link_state *state)
+{
+	u32 speed, config, val;
+	int ret;
+
+	val = gem_readl(bp, NCFGR);
+	val = GEM_BIT(PCSSEL) | (~GEM_BIT(SGMIIEN) & val);
+	if (state->pause & MLO_PAUSE_TX)
+		val |= GEM_BIT(PAE);
+	gem_writel(bp, NCFGR, val);
+	gem_writel(bp, NCR, gem_readl(bp, NCR) | GEM_BIT(ENABLE_HS_MAC));
+	gem_writel(bp, NCFGR, gem_readl(bp, NCFGR) | GEM_BIT(FD));
+	config = gem_readl(bp, USX_CONTROL);
+	config = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, config);
+	config &= ~GEM_BIT(TX_SCR_BYPASS);
+	config &= ~GEM_BIT(RX_SCR_BYPASS);
+	gem_writel(bp, USX_CONTROL, config | GEM_BIT(TX_EN));
+	config = gem_readl(bp, USX_CONTROL);
+	gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
+	ret = readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
+				 val & GEM_BIT(USX_BLOCK_LOCK),
+				 1, MACB_USX_BLOCK_LOCK_TIMEOUT);
+	if (ret < 0) {
+		netdev_warn(bp->dev, "USXGMII block lock failed");
+		return -ETIMEDOUT;
+	}
+
+	switch (state->speed) {
+	case SPEED_10000:
+		speed = HS_MAC_SPEED_10000M;
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
 static void macb_mac_pcs_get_state(struct phylink_config *config,
 				   struct phylink_link_state *state)
 {
@@ -565,30 +653,39 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
+	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+		if (gem_mac_usx_configure(bp, state) < 0) {
+			spin_unlock_irqrestore(&bp->lock, flags);
+			phylink_mac_change(bp->phylink, false);
+			return;
+		}
+	} else {
+		old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
 
-	/* Clear all the bits we might set later */
-	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
-		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
+		/* Clear all the bits we might set later */
+		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) |
+			  MACB_BIT(FD) | MACB_BIT(PAE) |
+			  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
 
-	if (state->speed == SPEED_1000)
-		ctrl |= GEM_BIT(GBE);
-	else if (state->speed == SPEED_100)
-		ctrl |= MACB_BIT(SPD);
+		if (state->speed == SPEED_1000)
+			ctrl |= GEM_BIT(GBE);
+		else if (state->speed == SPEED_100)
+			ctrl |= MACB_BIT(SPD);
 
-	if (state->duplex)
-		ctrl |= MACB_BIT(FD);
+		if (state->duplex)
+			ctrl |= MACB_BIT(FD);
 
-	/* We do not support MLO_PAUSE_RX yet */
-	if (state->pause & MLO_PAUSE_TX)
-		ctrl |= MACB_BIT(PAE);
+		/* We do not support MLO_PAUSE_RX yet */
+		if (state->pause & MLO_PAUSE_TX)
+			ctrl |= MACB_BIT(PAE);
 
-	if (state->interface == PHY_INTERFACE_MODE_SGMII)
-		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
+		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 
-	/* Apply the new configuration, if any */
-	if (old_ctrl ^ ctrl)
-		macb_or_gem_writel(bp, NCFGR, ctrl);
+		/* Apply the new configuration, if any */
+		if (old_ctrl ^ ctrl)
+			macb_or_gem_writel(bp, NCFGR, ctrl);
+	}
 
 	bp->speed = state->speed;
 
@@ -3407,6 +3504,11 @@ static void macb_configure_caps(struct macb *bp,
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
2.17.1

