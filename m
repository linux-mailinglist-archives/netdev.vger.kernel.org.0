Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98150A75
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbfFXMLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:11:36 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:52534 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbfFXMLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 08:11:35 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OC8rtH004739;
        Mon, 24 Jun 2019 05:11:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=MUfnPVEMv3aqkkgS44qVBMU6uouASQZMG6/XGbQf6wg=;
 b=kRYW3SvX1raQnC9znh/ptefpf3am7ELROfu0e4IJ4AzoA19enY5jQ8QRRenFDfaS30WY
 tjjSDXfG3S2BeBSY9OS0m5dlP72TIAO3pBSib/eeNUV1HH3Qcmi0z9bM2mVIXvNIECm6
 CL0O0kHA58hxNpXaLcdUKgwXCL3CURk1JTJSaeoPZuirgQ66cvNNBQcto3f+hL9da7lQ
 IS+mUA23tkhVuqy8dFYEIO2K0jYEtpMp1JF2g50mh5phrWhM0o1xSzsc4k/JCX/gSape
 4anBxlY8V/JRSBkgyswB6fp1XYKwtjjmKWbQYMKayBzNlb8E39hYym+E44TZjFZpAvZ/ Vw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2056.outbound.protection.outlook.com [104.47.45.56])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t9fwtqu3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 05:11:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUfnPVEMv3aqkkgS44qVBMU6uouASQZMG6/XGbQf6wg=;
 b=hcSbP2aHlprYhA7Kmr+MK33sFlMtVjMZS28ezdLaR1gQ3HS9eqbznZcI0Vcr88CQEfiv2E+fMCdU0yKXzhZCzvlSKv+56o0NsZClWMyf2Euf0tU80/2WBPugqeL+U4TUqgM/Z6uXWovIqj0RzG8AMXJ8qZBpON6T4C/bdC7YR8A=
Received: from DM5PR07CA0050.namprd07.prod.outlook.com (2603:10b6:4:ad::15) by
 DM6PR07MB6969.namprd07.prod.outlook.com (2603:10b6:5:1eb::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Mon, 24 Jun 2019 12:11:21 +0000
Received: from DM3NAM05FT016.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::203) by DM5PR07CA0050.outlook.office365.com
 (2603:10b6:4:ad::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Mon, 24 Jun 2019 12:11:21 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 DM3NAM05FT016.mail.protection.outlook.com (10.152.98.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Mon, 24 Jun 2019 12:11:21 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCBHaH031108
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 24 Jun 2019 05:11:18 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 24 Jun 2019 14:11:16 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:11:16 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCBG6a012428;
        Mon, 24 Jun 2019 13:11:16 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v5 2/5] net: macb: add support for sgmii MAC-PHY interface
Date:   Mon, 24 Jun 2019 13:11:14 +0100
Message-ID: <1561378274-12357-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(376002)(396003)(2980300002)(189003)(199004)(36092001)(356004)(36756003)(4326008)(5660300002)(2616005)(50226002)(70206006)(70586007)(76130400001)(16586007)(486006)(316002)(54906003)(336012)(126002)(476003)(11346002)(446003)(110136005)(426003)(14444005)(7126003)(76176011)(51416003)(7696005)(53416004)(77096007)(26005)(186003)(478600001)(86362001)(26826003)(2906002)(50466002)(8676002)(2201001)(246002)(48376002)(8936002)(7636002)(107886003)(305945005)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6969;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e70fee04-a962-4c2b-bdd1-08d6f89d120d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:DM6PR07MB6969;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6969:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6969D1F0485F97C7A6D66AB7C1E00@DM6PR07MB6969.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 007814487B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: eT0vifSwKQejNjNeK2jCVcVKTdJyHELgq7UK6MUvboVgBsOqucKtSEK6EENdx2CwYN6f27xet71qEhOuRlsTugzrKnfV4Y2KY7Y2Hmk8sdcZRu84eiLr6M1J54OzRc8iv6nzNEVLJSZlaq+J9Z31VL8gZu+S7V24PzHxplNO88AKlCT3sGX8DVtC1f0Dt2m3GYT/xFcF7i5zjQVewCs4sfvjE8E+LhCnIeSY4Su6dqnZae3HCAw4VcXnjvIBO0jrTqUnwQ45kgej7ezTDP5mYWu0TZ/vJ591RWtapjdl97lCBSJUPLG1NBecM4mwPVGGjjIccclBuafNhjBm/en9LggXNahzzwlJsQGQuakVycePTQ9mxmZOOAMxZNkAkxO83kVkW7bnxn1By0eNarLCOhQl1LZDewapveY5dxqPs50=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2019 12:11:21.0333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e70fee04-a962-4c2b-bdd1-08d6f89d120d
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6969
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for SGMII interface) and
2.5Gbps MAC in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      | 54 +++++++++++++-----
 drivers/net/ethernet/cadence/macb_main.c | 72 ++++++++++++++++++++++--
 2 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 8629d345af31..6d268283c318 100644
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
@@ -633,19 +648,32 @@
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
index ac5b233cd2e5..572691d948e9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -445,6 +445,8 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
@@ -480,10 +482,31 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 {
 	struct net_device *netdev = to_net_dev(pl_config->dev);
 	struct macb *bp = netdev_priv(netdev);
+	bool change_interface = bp->phy_interface != state->interface;
 	unsigned long flags;
 
 	spin_lock_irqsave(&bp->lock, flags);
 
+	if (change_interface) {
+		bp->phy_interface = state->interface;
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
+
 	if (!phylink_autoneg_inband(mode) &&
 	    (bp->speed != state->speed ||
 	     bp->duplex != state->duplex)) {
@@ -493,6 +516,7 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
 		if (macb_is_gem(bp))
 			reg &= ~GEM_BIT(GBE);
+
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
 
@@ -587,8 +611,8 @@ static int macb_mii_probe(struct net_device *dev)
 	}
 
 	bp->link = 0;
-	bp->speed = 0;
-	bp->duplex = -1;
+	bp->speed = SPEED_UNKNOWN;
+	bp->duplex = DUPLEX_UNKNOWN;
 
 	return ret;
 }
@@ -3337,6 +3361,22 @@ static void macb_configure_caps(struct macb *bp,
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
@@ -4319,11 +4359,35 @@ static int macb_probe(struct platform_device *pdev)
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
+		if (phy_mode == PHY_INTERFACE_MODE_SGMII) {
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
+		bp->phy_interface = phy_mode;
+	} else {
 		bp->phy_interface = phy_mode;
+	}
 
 	/* IP specific init */
 	err = init(pdev);
-- 
2.17.1

