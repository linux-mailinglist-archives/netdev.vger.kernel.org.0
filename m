Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B42E6488E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfGJOjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:39:37 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:59556 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbfGJOjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:39:36 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AEbZEp002915;
        Wed, 10 Jul 2019 07:39:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=AfaOySIi0kq+v9Mc/YjPG3b9YPqJTaXFgOTtHGAJ850=;
 b=ewHja4vRGV6vSrKt7M442hDT3kKJdZFBKMX3pdn7+zxI8QDBDNhI2t7gCJ0M/LVG+jT6
 x1MqEjLnHitrVk5MAsKoJwOadoi/LNbkasS065DfweHn317lgdcr70WiExhvBDD0LRgt
 g5e0FEVlaW/hkg6Oeya09ykbdDOQHVXy1ikuLRyJzuZFi7OsYusUSuDTwIiRGT3pHOXX
 6ZF62FYdEfL/d47p2/dE6DlQjFg5LLUv1q92S3RUwMxYuqvWYTfiRzyB4xBRf6i2xa+B
 VaWNgl29lIvSec/7Ope07pYqWgZ8hn5422ZlnFtXds1RRWoydAgvCUfabqa8gg69c5e2 Ag== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2058.outbound.protection.outlook.com [104.47.40.58])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2tjr6vr3yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 07:39:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Agk1LJxa5a8KMWrbeO2hXButFI2NfBsTXCLuOs3NEgQf3MX3G/3PU10ZuMp1Oc3znYP5LS78++s/9uxDTA8wkjVMX28Y0p8sWb1L804QGrMou2yBZQ7iGUPHaykPiE1JPyDMqQxk+9NGT62kyPHrqena3EH781bBzGyoramSC/zGteNdH8uh3egPGaog1dLYt/LwGn9PojM3A2ybb5Ye4DSe8XQ/czMPw0ZqICgLqMoav9XswuYimgad5MScZzdqRYUflmJoAOfHRE53YY7n4VWDuLPbWGY/Du2CKjGA4q/PojZBafFppzVdjzhVnGYNhF4hagLu10QYd/WsRg/GKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfaOySIi0kq+v9Mc/YjPG3b9YPqJTaXFgOTtHGAJ850=;
 b=fXVFHavRMjihjV7cBdmktdO4sFRJz8CTY/xLRfpZioVm4tOrxIpAdjhFXnklQ+PcciuEAJ8JOfwU64TCpr+/QfDrJzyu3ow9bJKjDipovtM/J2kAHxd9cg7E0vMBYxuWCOhhia3rzB+RZbhXAgG8+BT0NbP5B/xPc/i2V/G+ASosEnUoH5RPglimneW/XE5+zdc627npG9v3wRrzJ27eaX2wHf+ezFcaL9ve/MIqKUpVDFaHuV9inKGZY1KCGyiv6Nhl9zcrUvswVMk9sSCWq7oRja7dAKAFIiMrXVoE43IqrvO3ulOsJ8pP/DkUD7mIA/LS88b6oluSmWP7+m3mbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=softfail (sender ip is
 158.140.1.28) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cadence.com;dmarc=fail (p=none sp=none pct=100) action=none
 header.from=cadence.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfaOySIi0kq+v9Mc/YjPG3b9YPqJTaXFgOTtHGAJ850=;
 b=FDu0LpP0xOmdr+kEhJwpnMNyiVnTFI09U2zJmd1OmX4eEgCcmQlE3e7ea92xhtRp/OB8bGR35ff3ln9ep3zVsKWJ8qPhMC+d7izq9qF0WNg83x6kBcdi9WpAZB7X14oIPwz2VU12udHlU9LyIEdvDAdglIRl2w28cKzxP9b2AKo=
Received: from DM5PR07CA0051.namprd07.prod.outlook.com (2603:10b6:4:ad::16) by
 CY4PR0701MB3636.namprd07.prod.outlook.com (2603:10b6:910:93::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2073.10; Wed, 10 Jul
 2019 14:39:24 +0000
Received: from DM3NAM05FT046.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::208) by DM5PR07CA0051.outlook.office365.com
 (2603:10b6:4:ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2052.19 via Frontend
 Transport; Wed, 10 Jul 2019 14:39:24 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT046.mail.protection.outlook.com (10.152.98.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2052.8 via Frontend Transport; Wed, 10 Jul 2019 14:39:23 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEdLo9021793
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 10 Jul 2019 07:39:22 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 10 Jul 2019 16:39:20 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 10 Jul 2019 16:39:20 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEdKS7002023;
        Wed, 10 Jul 2019 15:39:20 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <piotrs@cadence.com>, <aniljoy@cadence.com>,
        <arthurm@cadence.com>, <stevenh@cadence.com>,
        <pthombar@cadence.com>, <mparab@cadence.com>
Subject: [PATCH v6 4/4] net: macb: add support for high speed interface
Date:   Wed, 10 Jul 2019 15:39:19 +0100
Message-ID: <1562769559-1958-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(376002)(2980300002)(189003)(199004)(36092001)(2616005)(486006)(11346002)(476003)(446003)(7126003)(126002)(14444005)(305945005)(70206006)(4326008)(70586007)(110136005)(47776003)(16586007)(8676002)(246002)(76130400001)(36756003)(48376002)(50466002)(2906002)(426003)(356004)(336012)(186003)(26005)(107886003)(478600001)(5660300002)(26826003)(2201001)(76176011)(50226002)(8936002)(316002)(7636002)(86362001)(53416004)(51416003)(54906003)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0701MB3636;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98a81bd4-44b1-4da5-4d8d-08d70544673e
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:CY4PR0701MB3636;
X-MS-TrafficTypeDiagnostic: CY4PR0701MB3636:
X-Microsoft-Antispam-PRVS: <CY4PR0701MB363659D339D4D101A4D4018AC1F00@CY4PR0701MB3636.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 0094E3478A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: wo/ZKAK3/6fK+ti4OhBHeT6dudcgPMKjXmEmnwqQdGr8jrMUkLWodZzywx/4ZCzQADemATO5fg+FP/DRirlfURS6Mr0OYiDa0CE608SiYIsg/rJAamOcMojLWNFzX6Kl8EnGqDO5DXNcmGpMS2eJj320YQ9gTqDbg9h8xZR8/yprlUbLEKLGB76Z7K9582ajaOlKm+pTVVuVA1n4FMITOuFbtf1i+B4o+E5Zju9V1SM7V8vmpYVxC0usCKIudnYaCDVz9IGOhEG1k1qZIPF39kEQeKRKDyKsN3GFlJGsy+kHgf3TQS2sDDxdmK/sJfFxLziBvkASLAwhRqP5HdKlsk8/HvPKo8dvmnyxiZav9YsT2CKmxkQ26UsJkLFnRGZvQY/ToX4o5tbzx9/j5V31a4VZGoTVcsqkGwJ/3uZ8e6o=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2019 14:39:23.9323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a81bd4-44b1-4da5-4d8d-08d70544673e
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0701MB3636
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  43 ++++++++
 drivers/net/ethernet/cadence/macb_main.c | 132 +++++++++++++++++++++--
 2 files changed, 165 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 3ed5bffb735b..e3ec224ffc2a 100644
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
@@ -166,7 +167,13 @@
 #define GEM_DCFG6		0x0294 /* Design Config 6 */
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
+#define GEM_DCFG9		0x02A0 /* Design Config 9 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG11		0x02A8 /* Design Config 11 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_DCFG13		0x02B0 /* Design Config 13 */
+#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
+#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -274,6 +281,8 @@
 #define MACB_IRXFCS_SIZE	1
 
 /* GEM specific NCR bitfields. */
+#define GEM_ENABLE_HS_MAC_OFFSET	31
+#define GEM_ENABLE_HS_MAC_SIZE		1
 #define GEM_TWO_PT_FIVE_GIG_OFFSET	29
 #define GEM_TWO_PT_FIVE_GIG_SIZE	1
 
@@ -465,6 +474,10 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfield in HS_MAC_CONFIG */
+#define GEM_HS_MAC_SPEED_OFFSET			0
+#define GEM_HS_MAC_SPEED_SIZE			3
+
 /* Bitfields in PCS_CONTROL. */
 #define GEM_PCS_CTRL_RST_OFFSET			15
 #define GEM_PCS_CTRL_RST_SIZE			1
@@ -510,6 +523,34 @@
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
@@ -674,6 +715,7 @@
 #define MACB_CAPS_MACB_IS_GEM			BIT(31)
 #define MACB_CAPS_PCS				BIT(24)
 #define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
+#define MACB_CAPS_HIGH_SPEED			BIT(26)
 
 #define MACB_GEM7010_IDNUM			0x009
 #define MACB_GEM7014_IDNU			0x107
@@ -753,6 +795,7 @@
 	})
 
 #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
+#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
 
 /* struct macb_dma_desc - Hardware DMA descriptor
  * @addr: DMA address of data buffer
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 792073d1b5c3..6551c03e7628 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -82,6 +82,20 @@ struct sifive_fu540_macb_mgmt {
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
+	MACB_SERDES_RATE_5G,
+	MACB_SERDES_RATE_10G,
+};
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -91,6 +105,8 @@ struct sifive_fu540_macb_mgmt {
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -491,12 +507,32 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
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
@@ -532,6 +568,80 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
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
@@ -574,18 +684,17 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
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
@@ -3435,6 +3544,9 @@ static void macb_configure_caps(struct macb *bp,
 		default:
 			break;
 		}
+		dcfg = gem_readl(bp, DCFG12);
+		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
+			bp->caps |= MACB_CAPS_HIGH_SPEED;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
-- 
2.17.1

