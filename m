Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787FDF4D47
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfKHNeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:34:50 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:50672 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKHNeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:34:50 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8DWIn2028274;
        Fri, 8 Nov 2019 05:34:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=gAUgVZNcJPyJBNce97YENWPxvH+mPpFT8yndWUgt970=;
 b=CX+7NAwYt77CqLtQ3TS/ZaPMwiqTgudYk2KmZRRfEBWspFXvk0zrvDEPTELn7Rx0jQb9
 NFQu1rSs7oMTlfuMCFyAlCGAqa7EehTwIe6gq91grycZvbJfVX49RlXl3x+3xrGxF/Su
 PqsGCHu6Uq83jiOwSeWEnmz09OFEoNTH0MQ821eVgjA9w8Asq3yZIcgFwUEgACcA6z9t
 V8bWLnDQaQKXXpLblEMEK+fYaumbvZPOlmYteDwUuAYi4dcqK3jQqLHdS56MO2KpBQdO
 whMp2RBmdjrywytiKLzbjmXOR/nczaIPCrOlGfVztIMBs6UHPIaCQevjBBEhU0JrSOYG iQ== 
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2058.outbound.protection.outlook.com [104.47.48.58])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2w41ty1bnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 05:34:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHLshpxmuLnNB+NiE1rHL0AJr0KXycK0UgRqlx8UpxpTNwDKSWOotMiWA5NOBS87sncOco+j3lLs/T7tGGNqsiQ1kjiohQQk/7t2FXic2i8ErWHnFsSsu1XPKrH46WsjM/ZC4d83eru764QfdiWc17GDzYEfOhoOwKt/Vv8guIDv6dQ/so5y+PXlgG/2sRGNNmFTzZOooU+L0ow4IeuqYHAc6xMvT90LCFVVNz7WRqBMejVANVryFgBYRdEl40tFxEDYxcG0aTTbQLa1G5VZvlVay3fy4RWhgSUhtCgsf+ZHhznn7UaoYAGLrRh7TCxOfILQ+/FQLkQ9sw9HhcKaKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAUgVZNcJPyJBNce97YENWPxvH+mPpFT8yndWUgt970=;
 b=MP+eN5pdwVW3LwWE9i7TKZpYBB0oUZE0P6NG/MMpHm2prf6KR8cMAiCGijMyR8PxGx4XupSPIlhvtynQF9dwpbK8peguQMaaa5xYaXrH3DSy1/hJPcLVrulTzumphKuNQxORB+ESdlzpY796xSJKIB/Qqs4vvGZUtHVbHh/J3nGjV65PZt+YaGGBpnlIOmH3x4Ob+Ia0DpXQ55blDL+GRH8QBMmoU9IIFaUvdsEgEv2LY9wFqq878I7mu6B1asbz93nivBuh3RHJ3+v/KyNk/P5K8AXvl77sVfsu562Us7XhyfRYxr8QeKoPo8GgI29zi6tB6xymlRUPlgyr8dABEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAUgVZNcJPyJBNce97YENWPxvH+mPpFT8yndWUgt970=;
 b=Lky7kKtyNUoStYQ/mLBJpxhZJ5KKfn9Ex/oMxWLchl6TR5wZKRhMhH/oibgrYbvA2oV3ONX3bu9mPvl/OSRjUQOYtfGz5/VTYIAJJ5mPU5hQwO2ekDMemIRn2F5rd34+cdURH8dSBuIT3rAY1J2wK219KIRGn/r5xO1QPS/9W9A=
Received: from BYAPR07CA0085.namprd07.prod.outlook.com (2603:10b6:a03:12b::26)
 by SN6PR07MB5504.namprd07.prod.outlook.com (2603:10b6:805:e6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.24; Fri, 8 Nov
 2019 13:34:38 +0000
Received: from CO1NAM05FT005.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::208) by BYAPR07CA0085.outlook.office365.com
 (2603:10b6:a03:12b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22 via Frontend
 Transport; Fri, 8 Nov 2019 13:34:37 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 CO1NAM05FT005.mail.protection.outlook.com (10.152.96.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.15 via Frontend Transport; Fri, 8 Nov 2019 13:34:37 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYYwD021916
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 8 Nov 2019 05:34:35 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 8 Nov 2019 14:34:34 +0100
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 8 Nov 2019 14:34:34 +0100
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYX2r018134;
        Fri, 8 Nov 2019 13:34:33 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <piotrs@cadence.com>,
        <dkangude@cadence.com>, <ewanm@cadence.com>, <arthurm@cadence.com>,
        <stevenh@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 2/4] net: macb: add support for sgmii MAC-PHY interface
Date:   Fri, 8 Nov 2019 13:34:32 +0000
Message-ID: <1573220072-17861-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1573220027-15842-1-git-send-email-mparab@cadence.com>
References: <1573220027-15842-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(36092001)(189003)(199004)(70586007)(336012)(356004)(316002)(16586007)(110136005)(54906003)(70206006)(478600001)(4326008)(14444005)(2906002)(8936002)(5660300002)(53416004)(246002)(26826003)(26005)(36756003)(486006)(50226002)(76130400001)(86362001)(126002)(11346002)(107886003)(446003)(7696005)(51416003)(48376002)(8676002)(76176011)(50466002)(7126003)(2201001)(426003)(476003)(2616005)(305945005)(47776003)(186003)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR07MB5504;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93e9d81-ad73-4863-fd80-08d764506695
X-MS-TrafficTypeDiagnostic: SN6PR07MB5504:
X-Microsoft-Antispam-PRVS: <SN6PR07MB55049CDB85E3CB3C9665FE7DD37B0@SN6PR07MB5504.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-Forefront-PRVS: 0215D7173F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2JO8LRyYbciwwi9i3JnZj1T3s/63MIgVKg3PDv05xoDCO/J4BONaFQnFKnCCqTYsA6ufRZGgAPEIwfjgIs2izJ1/OXSLxVsovlSC/kPj56qpyhsmL68m+QUtJSuzveF7C1hfNzip4cWhBnl/kCe33FXVuSyhodqxN/3s6WP1v7R/t9N3m0+Y32OipGFL/HwCdANc3XV0dqGhV+7pv3fFEsMByh+5Vf+82ffWOsK9L5Z55uhYh0j/byqclG+GaR7j/O90Hti5LSuvzUU0o5ZrSnDP6XtRkMDgBDmHnXpvhtKdD+O3xMCY5V8i/43cPAEI2ASTK9vD6DNNbugO0aUV1fZr1ru8XhvbQ4v9zRyJNaAQzNdmUuEICpVCV2LqNuPCaosC2ebXil+Da8vZ56uZom5K6KeaSE8jz9X2wEtxJ+Seg4G3aerF1Um6u0CcbjQvUB9fTOgywO2QygpHFb8fIw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:34:37.6851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e93e9d81-ad73-4863-fd80-08d764506695
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB5504
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

This patch add support for SGMII interface and
2.5Gbps MAC in Cadence ethernet controller driver.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |   42 ++++++++++++++++++++---------
 drivers/net/ethernet/cadence/macb_main.c |   28 +++++++++++++++++++-
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index a400705..5e2957d 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -77,6 +77,7 @@
 #define MACB_RBQPH		0x04D4
 
 /* GEM register offsets. */
+#define GEM_NCR			0x0000 /* Network Control */
 #define GEM_NCFGR		0x0004 /* Network Config */
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
@@ -156,6 +157,7 @@
 #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
 #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
 #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
+#define GEM_PCS_CTRL		0x0200 /* PCS Control */
 #define GEM_DCFG1		0x0280 /* Design Config 1 */
 #define GEM_DCFG2		0x0284 /* Design Config 2 */
 #define GEM_DCFG3		0x0288 /* Design Config 3 */
@@ -271,6 +273,10 @@
 #define MACB_IRXFCS_OFFSET	19
 #define MACB_IRXFCS_SIZE	1
 
+/* GEM specific NCR bitfields. */
+#define GEM_TWO_PT_FIVE_GIG_OFFSET	29
+#define GEM_TWO_PT_FIVE_GIG_SIZE	1
+
 /* GEM specific NCFGR bitfields. */
 #define GEM_GBE_OFFSET		10 /* Gigabit mode enable */
 #define GEM_GBE_SIZE		1
@@ -323,6 +329,9 @@
 #define MACB_MDIO_SIZE		1
 #define MACB_IDLE_OFFSET	2 /* The PHY management logic is idle */
 #define MACB_IDLE_SIZE		1
+#define MACB_DUPLEX_OFFSET	3
+#define MACB_DUPLEX_SIZE	1
+
 
 /* Bitfields in TSR */
 #define MACB_UBR_OFFSET		0 /* Used bit read */
@@ -456,11 +465,17 @@
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
@@ -637,19 +652,20 @@
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
 
 /* LSO settings */
 #define MACB_LSO_UFO_ENABLE			0x01
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 15016ff..8269d7a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -441,6 +441,10 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		if (!(bp->caps & MACB_CAPS_PCS))
+			goto empty_set;
+		break;
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (!macb_is_gem(bp))
@@ -451,6 +455,8 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	}
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
@@ -495,8 +501,26 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	if (change_interface)
+	if (change_interface) {
 		bp->phy_interface = state->interface;
+		/* 2.5G mode not supported */
+		gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
+			   gem_readl(bp, NCR));
+
+		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
+				   GEM_BIT(PCSSEL) |
+				   gem_readl(bp, NCFGR));
+		} else {
+			/* Disable SGMII mode and PCS */
+			gem_writel(bp, NCFGR, ~(GEM_BIT(SGMIIEN) |
+				   GEM_BIT(PCSSEL)) &
+				   gem_readl(bp, NCFGR));
+			/* Reset PCS */
+			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
+				   GEM_BIT(PCS_CTRL_RST));
+		}
+	}
 
 	if (!phylink_autoneg_inband(mode) &&
 	    (bp->speed != state->speed ||
@@ -3354,6 +3378,8 @@ static void macb_configure_caps(struct macb *bp,
 		dcfg = gem_readl(bp, DCFG1);
 		if (GEM_BFEXT(IRQCOR, dcfg) == 0)
 			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
+		if (GEM_BFEXT(NO_PCS, dcfg) == 0)
+			bp->caps |= MACB_CAPS_PCS;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
-- 
1.7.1

