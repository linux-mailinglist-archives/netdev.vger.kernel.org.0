Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14F5F4D4D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbfKHNfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:35:11 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:64238 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKHNfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:35:10 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8DWInf028271;
        Fri, 8 Nov 2019 05:35:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=oKPMiGuP9dG52Svx1Mi/iycbW2+9r0Lvm2L5Esi7L38=;
 b=ZpkZ6ozZfRHyJK1J6ZtmqyO2acFP5gmwcrKpf/tFBhidF2T4vlCTZDEQpSRcVR8I5RUy
 H8ZX5HqPcS24TTfGly7V4JUZlEXl28VMT+jAj5Wma8xu5yXh8JP/F4xDBNd0AME7YPuo
 xh7LWb32D4q4BzQseboMm335MoxaAitIcszE4OXWKh1/yW4oB4kS9mdmy9DO8JmL3C+V
 YYNeiIcvPZX7BXlnvnZav5wPpIGWLK63Tm95iY4ZnqWugk0lE8nX3f0nVbCyn1tBBaJN
 yxLrfsPkC0DnwaY16XqPLDQsFgLvCdVrJrIIT1vxuIDx8txtR6zZU22o96FSajxhjUkY PQ== 
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2055.outbound.protection.outlook.com [104.47.44.55])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2w41ty1bpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 05:35:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Esmg5ErXggaZo3yOlZ4etALYTOnD2Bj9/Y/pPWTNVFp6OiwB/NTta3Cee51Eib9FUvKsuGy27CYCqKlLe7XC43Q6qUVqBsjqmaN+V2cEmG3GhZk4+ykKq3lrIFw/xKKaDoNDt90mqit7g6On06lHO+xoHGstZvG8GvGwIB4SKAqfCfMA5NAsF0/rzdJnr6bQGuE22w4i4nYBGj6+BZTaqnkHx+mM9WrkXAbG8nQu5aIJPRI5ODNf3yPpQn7MAZtZcNk8CU6qg5e/Gb6VNoO26rh/6G1qMEeN5uIuPxK1mtN5SvAO0RWyhwmv7Lw2x37SoOr1331iehrPCKbwsSlzwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKPMiGuP9dG52Svx1Mi/iycbW2+9r0Lvm2L5Esi7L38=;
 b=aRm22R1qGyOQXBdmCyrEppnMHadnzaU35pntgw4OfmTiNiJ1cg8JODVpsXnpVBKFMPTkDIIXM/Gnyo0ce84P+XUeq/Ehg5xDWmn84qIF1J0Z0Tlqd6x0lmSK2ukrWPDGP+Rs/aJNwcQDiak5oEZe4nZbev4eNc1dUCSqtRBIexskpKHyzmOTmALo9EauRWC7/1kQj1Dq3YXFIeEZSE8dLsUazT/QDSC/h8Oc2qExclGf/lUOW+NFzuCT2peUtojMQ/MfmVvMdRRVH5ZdqLNdilDbJ70RAe8NQhx6ktcrrzUfFtVtjKoAbrLM2iBMxG/gnJvn9wVyRu0/hz+w2kYjlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.243) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKPMiGuP9dG52Svx1Mi/iycbW2+9r0Lvm2L5Esi7L38=;
 b=3+vYvq/5E/BQmo5bKrKOyUD/QXMCr50Xswv9V0gbie6k3ihUnIo3LIMts2Kuji3PHAt48+rPfhIBP97Wt2urSotO0Y8euzRB473N5MG6/qi73PWosZVLmqr1xtfTI8VeMv7EBG9bGNbHmuFsdJPz6UXpVx63QNzNqdl0/i1k1RM=
Received: from CH2PR07CA0020.namprd07.prod.outlook.com (2603:10b6:610:20::33)
 by MWHPR07MB2783.namprd07.prod.outlook.com (2603:10b6:300:2b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22; Fri, 8 Nov
 2019 13:34:57 +0000
Received: from CO1NAM05FT010.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::208) by CH2PR07CA0020.outlook.office365.com
 (2603:10b6:610:20::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2430.20 via Frontend
 Transport; Fri, 8 Nov 2019 13:34:57 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.243 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.243; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 CO1NAM05FT010.mail.protection.outlook.com (10.152.96.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2451.15 via Frontend Transport; Fri, 8 Nov 2019 13:34:54 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id xA8DYp7v133768
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 05:34:52 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 8 Nov 2019 14:34:50 +0100
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 8 Nov 2019 14:34:50 +0100
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYo7W019077;
        Fri, 8 Nov 2019 13:34:50 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <piotrs@cadence.com>,
        <dkangude@cadence.com>, <ewanm@cadence.com>, <arthurm@cadence.com>,
        <stevenh@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 4/4] net: macb: add support for high speed interface
Date:   Fri, 8 Nov 2019 13:34:48 +0000
Message-ID: <1573220088-18945-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1573220027-15842-1-git-send-email-mparab@cadence.com>
References: <1573220027-15842-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(36092001)(189003)(199004)(70586007)(5660300002)(446003)(426003)(86362001)(305945005)(7696005)(51416003)(2616005)(476003)(76176011)(356004)(50226002)(486006)(8676002)(2201001)(81166006)(7126003)(81156014)(11346002)(126002)(186003)(4326008)(36756003)(48376002)(107886003)(47776003)(53416004)(478600001)(70206006)(336012)(8936002)(106002)(14444005)(110136005)(316002)(26005)(54906003)(50466002)(2906002)(36906005)(16586007);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR07MB2783;H:wcmailrelayl01.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:ErrorRetry;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7426196-08d4-45f1-b698-08d7645070cf
X-MS-TrafficTypeDiagnostic: MWHPR07MB2783:
X-Microsoft-Antispam-PRVS: <MWHPR07MB27838A50AA60D568880A91E0D37B0@MWHPR07MB2783.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 0215D7173F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPzs1qwMwd/v/BPp5MqEXPSVPrKZPyDvy6FzT/dWd1aaVq7uy1hfKGusMStfGaOXiT7RJC2YytuPosYIIZ8Ht75i3cTPvYMrCKM5xZGfcaxa7ahHtVpepAlV539EQnPIcLY1N3ytKGe8Mzq60oOqZniv5INHAIKfMghOOGMYmdLpH2ZpUismN+IFqMKzxkBZ9FL1JJptAsvBJ5rQaglUoobazZ5WupPTmVcmTgOqdT3nySsbHVKhMMLeewp0LV1wq0VzSWANmppKEbTvE6HEcozzGiealhwDZ68MjqVQOlV86dpVnbTjkw4cM0D5JaKlQTkEGUSDgVRTOTsj1UCqIPwKJtNcGiWYmXndc+NILFZDQ4ADG6tCv0QdDfx5POW1zy0tN3Zy/ITbhhemaSg/gfprsr1nE+nURItR5tSrWVmYD2Ar5Vi4/L17/PHTUGRKQRvl7jjaeaioT1v2aix5fg==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:34:54.8326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7426196-08d4-45f1-b698-08d7645070cf
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB2783
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_04:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911080135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |   40 +++++++++
 drivers/net/ethernet/cadence/macb_main.c |  130 +++++++++++++++++++++++++++---
 2 files changed, 160 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 34136a8..d064d76 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -82,6 +82,7 @@
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
 #define GEM_JML			0x0048 /* Jumbo Max Length */
+#define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
 #define GEM_HRB			0x0080 /* Hash Bottom */
 #define GEM_HRT			0x0084 /* Hash Top */
 #define GEM_SA1B		0x0088 /* Specific1 Bottom */
@@ -167,6 +168,9 @@
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
+#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -274,6 +278,8 @@
 #define MACB_IRXFCS_SIZE	1
 
 /* GEM specific NCR bitfields. */
+#define GEM_ENABLE_HS_MAC_OFFSET	31
+#define GEM_ENABLE_HS_MAC_SIZE		1
 #define GEM_TWO_PT_FIVE_GIG_OFFSET	29
 #define GEM_TWO_PT_FIVE_GIG_SIZE	1
 
@@ -465,6 +471,10 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfield in HS_MAC_CONFIG */
+#define GEM_HS_MAC_SPEED_OFFSET			0
+#define GEM_HS_MAC_SPEED_SIZE			3
+
 /* Bitfields in PCS_CONTROL. */
 #define GEM_PCS_CTRL_RST_OFFSET			15
 #define GEM_PCS_CTRL_RST_SIZE			1
@@ -510,6 +520,34 @@
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
@@ -673,6 +711,7 @@
 #define MACB_CAPS_SG_DISABLED			BIT(30)
 #define MACB_CAPS_MACB_IS_GEM			BIT(31)
 #define MACB_CAPS_PCS				BIT(24)
+#define MACB_CAPS_HIGH_SPEED			BIT(25)
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
@@ -741,6 +780,7 @@
 	})
 
 #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
+#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
 
 /* struct macb_dma_desc - Hardware DMA descriptor
  * @addr: DMA address of data buffer
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index fe107f0..a4c197f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -81,6 +81,18 @@ struct sifive_fu540_macb_mgmt {
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
 
+enum {
+	HS_MAC_SPEED_100M,
+	HS_MAC_SPEED_1000M,
+	HS_MAC_SPEED_2500M,
+	HS_MAC_SPEED_5000M,
+	HS_MAC_SPEED_10000M,
+};
+
+enum {
+	MACB_SERDES_RATE_10G = 1,
+};
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -90,6 +102,8 @@ struct sifive_fu540_macb_mgmt {
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -489,12 +503,32 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 		if (!macb_is_gem(bp))
 			goto empty_set;
 		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		if (!(bp->caps & MACB_CAPS_HIGH_SPEED &&
+		      bp->caps & MACB_CAPS_PCS))
+			goto empty_set;
+		break;
 	default:
 		break;
 	}
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_NA:
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
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
@@ -530,6 +564,80 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
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
+	config = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, config);
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
+static inline void gem_mac_configure(struct macb *bp, int speed)
+{
+	switch (speed) {
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
@@ -572,18 +680,17 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			reg &= ~GEM_BIT(GBE);
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
+		macb_or_gem_writel(bp, NCFGR, reg);
 
-		switch (state->speed) {
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
@@ -3419,6 +3526,9 @@ static void macb_configure_caps(struct macb *bp,
 			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
 		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
 			bp->caps |= MACB_CAPS_PCS;
+		dcfg = gem_readl(bp, DCFG12);
+		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
+			bp->caps |= MACB_CAPS_HIGH_SPEED;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
-- 
1.7.1

