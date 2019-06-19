Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F16E4B43D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbfFSIlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:41:08 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:26160 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730996AbfFSIlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 04:41:07 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5J8ajdn023272;
        Wed, 19 Jun 2019 01:40:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=R19rRSrIJKr/Xlb5QQVRzbpsHN451BHSnshWOGYaVAg=;
 b=XfnQHxvr4Pn/pO1oXO0eQZc8lQ00gdeCaQm5QqggutuOXkuENsm56xsNYCWU0w0RyEzP
 8eq3m7ftIdPx2S1vQSwXagDdM1mRu1nWbkFXfUJu3Etk6CJwnj7JMAtU0di3o9ChdH42
 DQEvUXeUwfsb7NdQ/8XtmPK+j9MkmYdHbykesq394MAvfgEpCb17f4cWTmScwmaC4igh
 JNVFi70hoB21eBtbWeYnGFOAy0u014bKdfHGs/iEUYdmmWpe3gzmQNXakZJqNCLuZYvj
 2W7mlkmEZcXV2bbcmU57Vn/pblTpp2xgvuuTlTqaIsDnvvd0tggnaaDPKi9XgfNhRm1U uQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2052.outbound.protection.outlook.com [104.47.33.52])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t7805afut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 01:40:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R19rRSrIJKr/Xlb5QQVRzbpsHN451BHSnshWOGYaVAg=;
 b=B6VJgXHmw67GAhcHQ/CNQvGk3jLMPE3BUV8GMjBzvbTXBIxiV1inGQa3JMZpo2Y8YCxZP6dIUwwgEUzgjIrbqGjgD5fY8Ge+SyllW+QU1x3cnCXkMxd4deU1a+J2XvYXI3AxqyXf2SXTmiGdampbZ7Paso/HFWso6vfjbz6I7+M=
Received: from MN2PR07CA0010.namprd07.prod.outlook.com (10.255.232.20) by
 DM6PR07MB6827.namprd07.prod.outlook.com (20.179.70.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 19 Jun 2019 08:40:52 +0000
Received: from DM3NAM05FT039.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::204) by MN2PR07CA0010.outlook.office365.com
 (2603:10b6:208:1a0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.14 via Frontend
 Transport; Wed, 19 Jun 2019 08:40:52 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 DM3NAM05FT039.mail.protection.outlook.com (10.152.98.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Wed, 19 Jun 2019 08:40:51 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8emcA008164
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 19 Jun 2019 01:40:49 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 19 Jun 2019 10:40:47 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 19 Jun 2019 10:40:47 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8elTx029898;
        Wed, 19 Jun 2019 09:40:47 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v2 2/5] net: macb: add support for sgmii MAC-PHY interface
Date:   Wed, 19 Jun 2019 09:40:46 +0100
Message-ID: <1560933646-29852-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(36092001)(189003)(199004)(4326008)(246002)(53416004)(107886003)(305945005)(336012)(50226002)(36756003)(7636002)(76176011)(7696005)(48376002)(186003)(26005)(77096007)(2906002)(51416003)(26826003)(486006)(426003)(2201001)(30864003)(70206006)(446003)(47776003)(50466002)(508600001)(126002)(5660300002)(7126003)(2616005)(476003)(11346002)(16586007)(316002)(356004)(76130400001)(8936002)(54906003)(14444005)(110136005)(8676002)(86362001)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6827;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 457a9436-2ff8-4a73-f04b-08d6f491d607
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR07MB6827;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6827:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6827045BDD62C27195EC9E4BC1E50@DM6PR07MB6827.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0073BFEF03
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: UcYyXjJjtmkGbn6IR3LNLhRyaWq8zDKyptt6Bh4NT5TcNYoub/tX5UWFdFLoEVmI9bFQ8XN2bBDVAD8AjpkQ19ORD0hi2gFQXBpAXU/UxwRbFDLeF0FNH8aF8vBJmBPbnmb8Q1KHhs1L6k02z4TjeViUmlzgdzC+eM1DL8WcUhEVx+SVgaqFRL8/Jaq/RfPWUflf3xKp811wQmFAubs0k+n2CSFSZJjA0whFZUzMnO3LE9NbTXZueJtB753BmpJ5zVV1L+FFpLN62m/cgVmut3FfXeoFwVtv87/0Dkhd/1AL0OjjM/N7h7ZWjyvPlw+CkJN17fT+9VL5jY32xsA3kiUtTrd+8h5Vpk5uVbjpjFndaB5InXxQj6EoPo599qpkWxnG4e9bl9e1ucK7W+ifMDTtuEZ++DHHorpVtPt+/bI=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2019 08:40:51.2429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 457a9436-2ff8-4a73-f04b-08d6f491d607
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6827
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190072
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
index 830af86d3c65..884d2a4408ad 100644
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
@@ -448,15 +455,16 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
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
@@ -466,6 +474,16 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
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
@@ -480,13 +498,52 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
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
@@ -506,18 +563,26 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
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
@@ -555,6 +620,7 @@ static void gem_mac_link_down(struct phylink_config *pl_config,
 static const struct phylink_mac_ops gem_phylink_ops = {
 	.validate = gem_phylink_validate,
 	.mac_link_state = gem_phylink_mac_link_state,
+	.mac_an_restart = gem_mac_an_restart,
 	.mac_config = gem_mac_config,
 	.mac_link_up = gem_mac_link_up,
 	.mac_link_down = gem_mac_link_down,
@@ -2248,7 +2314,9 @@ static void macb_init_hw(struct macb *bp)
 	macb_set_hwaddr(bp);
 
 	config = macb_mdc_clk_div(bp);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
 		config |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	config |= MACB_BF(RBOF, NET_IP_ALIGN);	/* Make eth data aligned */
 	config |= MACB_BIT(PAE);		/* PAuse Enable */
@@ -2273,6 +2341,17 @@ static void macb_init_hw(struct macb *bp)
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
@@ -3364,6 +3443,22 @@ static void macb_configure_caps(struct macb *bp,
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
@@ -3652,7 +3747,9 @@ static int macb_init(struct platform_device *pdev)
 	/* Set MII management clock divider */
 	val = macb_mdc_clk_div(bp);
 	val |= macb_dbw(bp);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
 		val |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	macb_writel(bp, NCFGR, val);
 
@@ -4346,11 +4443,37 @@ static int macb_probe(struct platform_device *pdev)
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

