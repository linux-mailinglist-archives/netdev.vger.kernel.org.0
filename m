Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F1B4AA0E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbfFRSj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:39:29 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:7610 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730046AbfFRSj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:39:28 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IIO0ED029600;
        Tue, 18 Jun 2019 11:39:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=QbD3pspTi2Tqp1F0ygpwG/JJrGYyyMtXHt5Ki0Ukpqg=;
 b=nZJNzgmJ872iMAE/3JTpWdJ1Vy4cS2Jc/4S47h2ftOMSwEoPHqnD5kafmLV6WnmO1jiW
 MZ2FJZdjcwzKEkxMmN4OwBGa2TVfDMu+Dav/WzM4F4jm2WKRL0fDcUXNu9sv+oCA2uZI
 mbHcQByyMweCWJuuJLzzIXeYBSGFnonIj/75n6czgNKPx8dbkHxNrRytZopJBuF1x+pi
 aNLLbJBsXYbkitI/5ek5jHEXA1ijBhTa8M6uh5/Ey9zy8NVqiNRstQWf4QaHoEKw6Ec7
 S5AqLee+bE6aOkZ+74LPJ5RvyFVPemsKfEQ8F1uRfsPzJrqlLbG1EkYTEmhgpsd572e5 eA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2054.outbound.protection.outlook.com [104.47.33.54])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8wdbrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:39:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbD3pspTi2Tqp1F0ygpwG/JJrGYyyMtXHt5Ki0Ukpqg=;
 b=ajEuyVb34ejQno5PDPrw5ODSApkdVYYt2k7SIvta2syVUMkZKK73XdMuPIKALvaf9p3yiDYJKOohjc8dRgcmGJbdqtriDCj/IUtQHJZRLXQVekM2k90/B84b2EkDDbIi7+ftlttARbjdWZdrSTFdPOmn4a6UW02j74uWc58k6aI=
Received: from CY1PR07CA0042.namprd07.prod.outlook.com
 (2a01:111:e400:c60a::52) by DM6PR07MB6827.namprd07.prod.outlook.com
 (2603:10b6:5:159::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.10; Tue, 18 Jun
 2019 18:39:14 +0000
Received: from CO1NAM05FT004.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::208) by CY1PR07CA0042.outlook.office365.com
 (2a01:111:e400:c60a::52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1965.14 via Frontend
 Transport; Tue, 18 Jun 2019 18:39:14 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 CO1NAM05FT004.mail.protection.outlook.com (10.152.96.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Tue, 18 Jun 2019 18:39:14 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5IIdAtv002486
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 18 Jun 2019 11:39:12 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 18 Jun 2019 20:39:09 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 18 Jun 2019 20:39:09 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5IId7QD003347;
        Tue, 18 Jun 2019 19:39:08 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH v2 2/6] net: macb: add support for sgmii MAC-PHY interface
Date:   Tue, 18 Jun 2019 19:39:05 +0100
Message-ID: <1560883145-3289-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560668677-21935-1-git-send-email-pthombar@cadence.com>
References: <1560668677-21935-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(36092001)(189003)(199004)(36756003)(246002)(53416004)(6666004)(107886003)(305945005)(7636002)(50226002)(336012)(478600001)(4326008)(7696005)(76176011)(48376002)(26005)(186003)(77096007)(2906002)(51416003)(110136005)(26826003)(486006)(2201001)(70206006)(30864003)(446003)(426003)(50466002)(47776003)(126002)(7126003)(5660300002)(2616005)(11346002)(476003)(16586007)(316002)(8936002)(356004)(54906003)(14444005)(76130400001)(86362001)(8676002)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6827;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 462088c8-fc68-4bdb-bb38-08d6f41c4339
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR07MB6827;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6827:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6827D10619FDFB2A55A2847DC1EA0@DM6PR07MB6827.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 007271867D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: AktjtsiH2xrtia3wfhcDcW2n9sYUgU6ncbdcW3ksotdxJ5DJpxALPFtWB0QnXSvRw6j+jVPT8PBOog3t/d2WiffmCVCNl3TJYvVmbhI9bSKC1m0Hb0VkFUge04TiRZOvRgW1hIIs0ayJqaev9kyUgNaM2xkn5viWw0OCMadId5fXQIJhqAmfVyQYhWS8wBgGaoHYi/AqlhhZKed7rCN6sG5lmL9N+ueDt7oydri0mT16F+N53EWXHvda0Lt4R71Okz8Ng7VGZnOGNx57gB0bsfDC6lAklGhqvl6MN8EKB0bTcZEd+RQ9CKgCC3xZ4Y+qMQlP9/VfBXOiiYvn0MHQmTkq5tqJVbaDZbwHKzWg4Y1ljr/BXKN/OPyOxVpE6j49NrdcI1+I2v5fyfU1izGbMRJ+fhRduYCtyvfclNf50/4=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2019 18:39:14.0640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 462088c8-fc68-4bdb-bb38-08d6f41c4339
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6827
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for SGMII interface) and
2.5Gbps MAC in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  76 ++++++++++--
 drivers/net/ethernet/cadence/macb_main.c | 151 ++++++++++++++++++++---
 2 files changed, 200 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 35ed13236c8b..d7ffbfb2ecc0 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -80,6 +80,7 @@
 #define MACB_RBQPH		0x04D4
 
 /* GEM register offsets. */
+#define GEM_NCR			0x0000 /* Network Control */
 #define GEM_NCFGR		0x0004 /* Network Config */
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
@@ -159,6 +160,9 @@
 #define GEM_PEFTN		0x01f4 /* PTP Peer Event Frame Tx Ns */
 #define GEM_PEFRSL		0x01f8 /* PTP Peer Event Frame Rx Sec Low */
 #define GEM_PEFRN		0x01fc /* PTP Peer Event Frame Rx Ns */
+#define GEM_PCS_CTRL		0x0200 /* PCS Control */
+#define GEM_PCS_STATUS		0x0204 /* PCS Status */
+#define GEM_PCS_AN_LP_BASE	0x0214 /* PCS AN LP BASE*/
 #define GEM_DCFG1		0x0280 /* Design Config 1 */
 #define GEM_DCFG2		0x0284 /* Design Config 2 */
 #define GEM_DCFG3		0x0288 /* Design Config 3 */
@@ -274,6 +278,10 @@
 #define MACB_IRXFCS_OFFSET	19
 #define MACB_IRXFCS_SIZE	1
 
+/* GEM specific NCR bitfields. */
+#define GEM_TWO_PT_FIVE_GIG_OFFSET	29
+#define GEM_TWO_PT_FIVE_GIG_SIZE	1
+
 /* GEM specific NCFGR bitfields. */
 #define GEM_GBE_OFFSET		10 /* Gigabit mode enable */
 #define GEM_GBE_SIZE		1
@@ -326,6 +334,9 @@
 #define MACB_MDIO_SIZE		1
 #define MACB_IDLE_OFFSET	2 /* The PHY management logic is idle */
 #define MACB_IDLE_SIZE		1
+#define MACB_DUPLEX_OFFSET	3
+#define MACB_DUPLEX_SIZE	1
+
 
 /* Bitfields in TSR */
 #define MACB_UBR_OFFSET		0 /* Used bit read */
@@ -459,11 +470,37 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfields in PCS_CONTROL. */
+#define GEM_PCS_CTRL_RST_OFFSET			15
+#define GEM_PCS_CTRL_RST_SIZE			1
+#define GEM_PCS_CTRL_EN_AN_OFFSET		12
+#define GEM_PCS_CTRL_EN_AN_SIZE			1
+#define GEM_PCS_CTRL_RESTART_AN_OFFSET		9
+#define GEM_PCS_CTRL_RESTART_AN_SIZE		1
+
+/* Bitfields in PCS_STATUS. */
+#define GEM_PCS_STATUS_AN_DONE_OFFSET		5
+#define GEM_PCS_STATUS_AN_DONE_SIZE		1
+#define GEM_PCS_STATUS_AN_SUPPORT_OFFSET	3
+#define GEM_PCS_STATUS_AN_SUPPORT_SIZE		1
+#define GEM_PCS_STATUS_LINK_OFFSET		2
+#define GEM_PCS_STATUS_LINK_SIZE		1
+
+/* Bitfield in PCS_AN_LP_BASE */
+#define GEM_PCS_AN_LP_BASE_LINK_OFFSET		15
+#define GEM_PCS_AN_LP_BASE_LINK_SIZE		1
+#define GEM_PCS_AN_LP_BASE_DUPLEX_OFFSET	12
+#define GEM_PCS_AN_LP_BASE_DUPLEX_SIZE		1
+#define GEM_PCS_AN_LP_BASE_SPEED_OFFSET		10
+#define GEM_PCS_AN_LP_BASE_SPEED_SIZE		2
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
@@ -636,19 +673,32 @@
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
index cb67a15cc9fb..2665758147c3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -393,6 +393,7 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
  */
 static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 {
+	struct macb *bp = netdev_priv(dev);
 	long ferr, rate, rate_rounded;
 
 	if (!clk)
@@ -408,6 +409,12 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
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
@@ -438,15 +445,16 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
+			phylink_set(mask, 2500baseT_Full);
+	/* fallthrough */
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
 			phylink_set(mask, 1000baseT_Full);
-			phylink_set(mask, 1000baseX_Full);
-			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
-				phylink_set(mask, 1000baseT_Half);
+			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
 				phylink_set(mask, 1000baseT_Half);
-			}
 		}
 	/* fallthrough */
 	case PHY_INTERFACE_MODE_MII:
@@ -456,6 +464,16 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 		phylink_set(mask, 100baseT_Half);
 		phylink_set(mask, 100baseT_Full);
 		break;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
+			phylink_set(mask, 2500baseX_Full);
+	/* fallthrough */
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
+			phylink_set(mask, 1000baseX_Full);
+		break;
+
 	default:
 		break;
 	}
@@ -470,13 +488,52 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
 {
 	struct net_device *netdev = to_net_dev(pl_config->dev);
 	struct macb *bp = netdev_priv(netdev);
+	u32 status;
 
-	state->speed = bp->speed;
-	state->duplex = bp->duplex;
-	state->link = bp->link;
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		status = gem_readl(bp, PCS_STATUS);
+		state->an_complete = GEM_BFEXT(PCS_STATUS_AN_DONE, status);
+		status = gem_readl(bp, PCS_AN_LP_BASE);
+		switch (GEM_BFEXT(PCS_AN_LP_BASE_SPEED, status)) {
+		case 0:
+			state->speed = SPEED_10;
+			break;
+		case 1:
+			state->speed = SPEED_100;
+			break;
+		case 2:
+			state->speed = SPEED_1000;
+			break;
+		default:
+			break;
+		}
+		state->duplex = MACB_BFEXT(DUPLEX, macb_readl(bp, NSR));
+		state->link = MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
+	} else if (bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
+		state->speed = SPEED_2500;
+		state->duplex = MACB_BFEXT(DUPLEX, macb_readl(bp, NSR));
+		state->link = MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
+	} else if (bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX) {
+		state->speed = SPEED_1000;
+		state->duplex = MACB_BFEXT(DUPLEX, macb_readl(bp, NSR));
+		state->link = MACB_BFEXT(NSR_LINK, macb_readl(bp, NSR));
+	}
 	return 1;
 }
 
+static void gem_mac_an_restart(struct phylink_config *pl_config)
+{
+	struct net_device *netdev = to_net_dev(pl_config->dev);
+	struct macb *bp = netdev_priv(netdev);
+
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
+		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
+			   GEM_BIT(PCS_CTRL_RESTART_AN));
+	}
+}
+
 static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			   const struct phylink_link_state *state)
 {
@@ -496,18 +553,26 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			reg &= ~GEM_BIT(GBE);
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
+		macb_or_gem_writel(bp, NCFGR, reg);
 
 		switch (state->speed) {
+		case SPEED_2500:
+			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+				   gem_readl(bp, NCFGR));
+			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
+				   gem_readl(bp, NCR));
+			break;
 		case SPEED_1000:
-			reg |= GEM_BIT(GBE);
+			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+				   gem_readl(bp, NCFGR));
 			break;
 		case SPEED_100:
-			reg |= MACB_BIT(SPD);
+			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
+				    macb_readl(bp, NCFGR));
 			break;
 		default:
 			break;
 		}
-		macb_or_gem_writel(bp, NCFGR, reg);
 
 		bp->speed = state->speed;
 		bp->duplex = state->duplex;
@@ -545,6 +610,7 @@ static void gem_mac_link_down(struct phylink_config *pl_config,
 static const struct phylink_mac_ops gem_phylink_ops = {
 	.validate = gem_phylink_validate,
 	.mac_link_state = gem_phylink_mac_link_state,
+	.mac_an_restart = gem_mac_an_restart,
 	.mac_config = gem_mac_config,
 	.mac_link_up = gem_mac_link_up,
 	.mac_link_down = gem_mac_link_down,
@@ -2239,7 +2305,9 @@ static void macb_init_hw(struct macb *bp)
 	macb_set_hwaddr(bp);
 
 	config = macb_mdc_clk_div(bp);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
 		config |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	config |= MACB_BF(RBOF, NET_IP_ALIGN);	/* Make eth data aligned */
 	config |= MACB_BIT(PAE);		/* PAuse Enable */
@@ -2264,6 +2332,17 @@ static void macb_init_hw(struct macb *bp)
 	if (bp->caps & MACB_CAPS_JUMBO)
 		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
+		//Enable PCS AN
+		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
+			   GEM_BIT(PCS_CTRL_EN_AN));
+		//Reset PCS block
+		gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
+			   GEM_BIT(PCS_CTRL_RST));
+	}
+
 	macb_configure_dma(bp);
 
 	/* Initialize TX and RX buffers */
@@ -3355,6 +3434,22 @@ static void macb_configure_caps(struct macb *bp,
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
@@ -3643,7 +3738,9 @@ static int macb_init(struct platform_device *pdev)
 	/* Set MII management clock divider */
 	val = macb_mdc_clk_div(bp);
 	val |= macb_dbw(bp);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
 		val |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	macb_writel(bp, NCFGR, val);
 
@@ -4226,11 +4323,37 @@ static int macb_probe(struct platform_device *pdev)
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

