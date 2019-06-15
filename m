Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4690147297
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfFOXrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:47:06 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46472 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbfFOXrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:47:06 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNicgM020579;
        Sat, 15 Jun 2019 16:47:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=2/bx3m8FETN51Y5DUPgQ1/H96hRuyHuTG8xY+mj1W9U=;
 b=rcRSDrlIBryqqocWQEM7VTvE5L39jE96L9J+RD16WrxjlyzKpr3HqgRfCORUBF7hp/Xv
 fUL2NPqi7zVYQK9aBUJG26ATZ5GF55/N5/EDBHYaCrbbRtFCd3ShVRMYYopjas6+0VUP
 ji263eM/9R38Hlfkny3gm3GJYh5pZTQCCpx6PbNxlSxiZqbpN+8zwnyyeSQIEijJv7Vd
 34hY4iytBTzOWSr3nTV89YEwDKf70oIuPEAfYlkn1fnymQHPNIlDNUl5GNv/OZEcGzkV
 FfEVrVsUsPbaGA9OH+PPWV7AyaqtPJiI39YWuzI9rxfl0kE3n9sh5c2S8WPTCGSZwBe0 Yg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2058.outbound.protection.outlook.com [104.47.33.58])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8w211y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:46:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/bx3m8FETN51Y5DUPgQ1/H96hRuyHuTG8xY+mj1W9U=;
 b=JN7474+OovSGVfhUymZOZKp5QN3EQJMTbu9bH+p2parvX9iV9k7ElImiOgMlMFRElTcd5Sb3SaZUAxitisM7ZgdlF2RYeVJyvUSnlXVJfpeGgXx58N/uOKLHJvdX0J8NSn3BsdyFqsmasR8dS+KEVoN7IgMLx3HJNRW8JD2lD4s=
Received: from DM6PR07CA0003.namprd07.prod.outlook.com (2603:10b6:5:94::16) by
 DM6PR07MB6825.namprd07.prod.outlook.com (2603:10b6:5:158::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Sat, 15 Jun 2019 23:46:56 +0000
Received: from BY2NAM05FT024.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::207) by DM6PR07CA0003.outlook.office365.com
 (2603:10b6:5:94::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1965.14 via Frontend
 Transport; Sat, 15 Jun 2019 23:46:56 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 BY2NAM05FT024.mail.protection.outlook.com (10.152.100.161) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:46:56 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNkrpb031759
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 16:46:54 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:46:52 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:46:52 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNkqDQ027220;
        Sun, 16 Jun 2019 00:46:52 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 2/6] net: macb: add support for sgmii MAC-PHY interface
Date:   Sun, 16 Jun 2019 00:46:49 +0100
Message-ID: <1560642409-27074-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
References: <1560642367-26425-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39850400004)(346002)(396003)(376002)(136003)(2980300002)(199004)(189003)(36092001)(2201001)(5660300002)(8676002)(7636002)(51416003)(7696005)(76176011)(246002)(305945005)(53416004)(14444005)(126002)(54906003)(2616005)(7126003)(8936002)(110136005)(86362001)(11346002)(476003)(446003)(486006)(426003)(478600001)(26826003)(50226002)(77096007)(6666004)(70586007)(356004)(70206006)(4326008)(47776003)(16586007)(36756003)(76130400001)(107886003)(186003)(336012)(50466002)(316002)(2906002)(48376002)(26005)(30864003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6825;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d759ec2-6e68-4ae4-f089-08d6f1ebc01a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR07MB6825;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6825:
X-Microsoft-Antispam-PRVS: <DM6PR07MB682516B5AD6B90B4AFB3BE4BC1E90@DM6PR07MB6825.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 24nacfaPKl6ECFSgPAac1l8M8oMTO5Quxh1SObot8gXjW9dKcM5zMgK1OD1d5DVJBDnrQYfMnDalyhoDDjL2PqKIZ4LXt0puOdjLAsVLyFc6AQRjqjO+ztV2ibUaA4XiB2+FEcxQb0iedqVMmXDtbfve8fMdN3bCxCE+i3oO70EVO5NeRlWWDbKRCYhBdU2ojjrbdYVlaqRJ5YAdwGTVt89ZPUaZfS8me3uV77haMA54XbE5lBL5sdYgavTi4O3sRnqEcUFR7we6FhHzJCoDJMjAbpPAx+NI1FaRaJJJ7hZoR8KhLuB/YxtJ0zJSDS6F74AJL6kOYK1rx5WDImz5AP8L7ZB+EHcfueXULCD+xtbqPDwH28R0Rv3kHYVQcKshENTBUaed6P3JBWWEbOlXq/OMISKLe8Mt0UIza82N3OQ=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:46:56.1512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d759ec2-6e68-4ae4-f089-08d6f1ebc01a
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6825
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

This is version 2 of patch to add support for SGMII interface) and
2.5Gbps MAC in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  76 +++++++++--
 drivers/net/ethernet/cadence/macb_main.c | 157 ++++++++++++++++++++---
 2 files changed, 202 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 35ed13236c8b..85c7e4cb1057 100644
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
+#define GEM_PCS_STATUS          0x0204 /* PCS Status */
+#define GEM_PCS_AN_LP_BASE      0x0214 /* PCS AN LP BASE*/
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
+#define MACB_DUPLEX_OFFSET      3
+#define MACB_DUPLEX_SIZE        1
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
+#define GEM_PCS_STATUS_AN_DONE_OFFSET           5
+#define GEM_PCS_STATUS_AN_DONE_SIZE             1
+#define GEM_PCS_STATUS_AN_SUPPORT_OFFSET        3
+#define GEM_PCS_STATUS_AN_SUPPORT_SIZE          1
+#define GEM_PCS_STATUS_LINK_OFFSET              2
+#define GEM_PCS_STATUS_LINK_SIZE                1
+
+/* Bitfield in PCS_AN_LP_BASE */
+#define GEM_PCS_AN_LP_BASE_LINK_OFFSET          15
+#define GEM_PCS_AN_LP_BASE_LINK_SIZE            1
+#define GEM_PCS_AN_LP_BASE_DUPLEX_OFFSET        12
+#define GEM_PCS_AN_LP_BASE_DUPLEX_SIZE          1
+#define GEM_PCS_AN_LP_BASE_SPEED_OFFSET         10
+#define GEM_PCS_AN_LP_BASE_SPEED_SIZE           2
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
+#define MACB_GEM7014_IDNUM			0x107
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
index 52d5e5efe2ad..5b3e7d9f4384 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -394,6 +394,7 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 {
 	long ferr, rate, rate_rounded;
+	struct macb *bp = netdev_priv(dev);
 
 	if (!clk)
 		return;
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
@@ -468,15 +486,54 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
 				      struct phylink_link_state *state)
 {
+	u32 status;
 	struct net_device *netdev = to_net_dev(pl_config->dev);
 	struct macb *bp = netdev_priv(netdev);
 
-	state->speed = bp->speed;
-	state->duplex = bp->duplex;
-	state->link = bp->link;
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		status = gem_readl(bp, PCS_STATUS);
+		state->an_complete = GEM_BFEXT(PCS_STATUS_AN_DONE, status);
+		status = gem_readl(bp, PCS_AN_LP_BASE);
+		switch (GEM_BFEXT(PCS_AN_LP_BASE_SPEED, status)) {
+		case 0:
+			state->speed = 10;
+			break;
+		case 1:
+			state->speed = 100;
+			break;
+		case 2:
+			state->speed = 1000;
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
@@ -494,17 +551,23 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
 		if (macb_is_gem(bp))
 			reg &= ~GEM_BIT(GBE);
-
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
-		if (state->speed == SPEED_100)
-			reg |= MACB_BIT(SPD);
-		if (state->speed == SPEED_1000 &&
-		    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
-			reg |= GEM_BIT(GBE);
-
 		macb_or_gem_writel(bp, NCFGR, reg);
 
+		if (state->speed == SPEED_2500) {
+			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+				   gem_readl(bp, NCFGR));
+			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
+				   gem_readl(bp, NCR));
+		} else if (state->speed == SPEED_1000) {
+			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+				   gem_readl(bp, NCFGR));
+		} else if (state->speed == SPEED_100) {
+			macb_writel(bp, NCFGR, MACB_BIT(SPD) |
+				    macb_readl(bp, NCFGR));
+		}
+
 		bp->speed = state->speed;
 		bp->duplex = state->duplex;
 
@@ -541,6 +604,7 @@ static void gem_mac_link_down(struct phylink_config *pl_config,
 static const struct phylink_mac_ops gem_phylink_ops = {
 	.validate = gem_phylink_validate,
 	.mac_link_state = gem_phylink_mac_link_state,
+	.mac_an_restart = gem_mac_an_restart,
 	.mac_config = gem_mac_config,
 	.mac_link_up = gem_mac_link_up,
 	.mac_link_down = gem_mac_link_down,
@@ -2245,7 +2309,9 @@ static void macb_init_hw(struct macb *bp)
 	macb_set_hwaddr(bp);
 
 	config = macb_mdc_clk_div(bp);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
 		config |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	config |= MACB_BF(RBOF, NET_IP_ALIGN);	/* Make eth data aligned */
 	config |= MACB_BIT(PAE);		/* PAuse Enable */
@@ -2270,6 +2336,17 @@ static void macb_init_hw(struct macb *bp)
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
@@ -3361,6 +3438,22 @@ static void macb_configure_caps(struct macb *bp,
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
@@ -3649,7 +3742,9 @@ static int macb_init(struct platform_device *pdev)
 	/* Set MII management clock divider */
 	val = macb_mdc_clk_div(bp);
 	val |= macb_dbw(bp);
-	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
+	    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
 		val |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
 	macb_writel(bp, NCFGR, val);
 
@@ -4232,11 +4327,37 @@ static int macb_probe(struct platform_device *pdev)
 	}
 
 	err = of_get_phy_mode(np);
-	if (err < 0)
+	if (err < 0) {
 		/* not found in DT, MII by default */
 		bp->phy_interface = PHY_INTERFACE_MODE_MII;
-	else
+	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
+		u32 interface_supported = 1;
+
+		if (err == PHY_INTERFACE_MODE_SGMII ||
+		    err == PHY_INTERFACE_MODE_1000BASEX ||
+		    err == PHY_INTERFACE_MODE_2500BASEX) {
+			if (!(bp->caps & MACB_CAPS_PCS))
+				interface_supported = 0;
+		} else if (err == PHY_INTERFACE_MODE_GMII ||
+			   err == PHY_INTERFACE_MODE_RGMII) {
+			if (!macb_is_gem(bp))
+				interface_supported = 0;
+		} else if (err != PHY_INTERFACE_MODE_RMII &&
+			   err != PHY_INTERFACE_MODE_MII) {
+			/* Add new mode before this */
+			interface_supported = 0;
+		}
+
+		if (!interface_supported) {
+			netdev_err(dev, "Phy mode %s not supported",
+				   phy_modes(err));
+			goto err_out_free_netdev;
+		}
+
 		bp->phy_interface = err;
+	} else {
+		bp->phy_interface = err;
+	}
 
 	/* IP specific init */
 	err = init(pdev);
-- 
2.17.1

