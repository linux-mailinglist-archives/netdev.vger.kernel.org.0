Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6852B109AC6
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfKZJKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:10:13 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:47186 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727527AbfKZJKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:10:13 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQ96kr1021725;
        Tue, 26 Nov 2019 01:10:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=i8AscXUge/Z5yPfqQIBBQmfcMW3nlZoMiLI4ZQJfA9s=;
 b=UJJw5CleK48+c9NerMacRjpd/UZnn4SP8lGDx/RbJLyzLqrUj+bRzG9o2oFkJt1fFy4p
 Lwlu5pt8XXCrAY5V4MVUoTH3Mz9u5cTjqt10tPkd4QOfnYVVpIs9Gv0gA7+E9ET24IZg
 ox502E2FrA09IPpzmoSkEyHvh7z8076J/7TI3Fan5Elus90ylw5pWGJCTTsgLatSyHFZ
 hyjWgO2cm9wZAwSKKgThzZCvUk9rkgo3um93/UezYnlZsmCOoHAEdkk+WD+X9up74X5D
 BoSCeHXRG3CnIXsVX7IOzR41B+e65nG+X2UJmDTjsuTBURqT7zSkujyKfAudCFB3GzK/ JA== 
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2055.outbound.protection.outlook.com [104.47.49.55])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wf26y2y3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 01:10:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixpvRYRKoQnAf39o6JWwnFkmKTDfjaIOsXgykQwNZJ2zzz+8zt9+ZNdq0/U5fkjyEfJMNc/9mpJ5+G43UQwtrFXJT7jxq0zyhEgEAgRgjj2hh9+ZHGezS3JQxWa5AJrWQrdebpdNcpPtDdkI3SInmk/bABjA/hxRerAQHuD+N178ZHUEoFbgL665s6GoKt5U8ckaWK4yJ/kQmL5E1UilIMSxdEh4kqMyFpt8YmWG5kyYjEPMYa8ZsbnIa1dNvF3bcxwD8vUPgG2NU9oxgIIAh928zVzg3FPhXy6jAzNURlDxEKIqQ+cEGc25W/oTNQLL8/74J91KcBj1rzRFam5SPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8AscXUge/Z5yPfqQIBBQmfcMW3nlZoMiLI4ZQJfA9s=;
 b=TuctB24jtBid/2KiuiDJc3GFIy2/6Tzla6i+nK+ssaj/6quF6OEjDhYeBvHm6MM1FfiqK1OAjk8zVmJ2iY+8tg+OgzJPxLcmisMrlCTEH5zjhd2Xi0MTF1dS6/bELcOSwjWzjDvTt1dNpRxCvf+ridhn6REGZ6KNDs+QCcm6/Fx9Hi5X3FoqIqK0BINUU+wB2EKssbW8opHVPq7ujx4uyxuJx0pj0TZiimW9Mko246yfCcl4Z1xMqwmXe2GhkhrQWQ9DpWb92ZPmkY+kTYIM2TohnboiAwSZ9sYRx4CeOZt5KU19KgtfOuPJNuKNzSh6Gs74Bx4ltszGfFba79iV+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8AscXUge/Z5yPfqQIBBQmfcMW3nlZoMiLI4ZQJfA9s=;
 b=OOf/il7UjIROTAubIhgN1Pp7zwB603onqvw9ptTJNgwKBiLShveVuBxH3xjtcTN4wweeFCWvHhvP22Y2TS1W/tH513AE5A/OWeoG6JUs0/vYRNsoeJYkhcrMweQHKGa9XXavn8cXDZE6NcGdf2dZMY+mI1Li1vpi9QlJ4KagWpA=
Received: from BN8PR07CA0028.namprd07.prod.outlook.com (2603:10b6:408:ac::41)
 by MN2PR07MB5869.namprd07.prod.outlook.com (2603:10b6:208:105::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.21; Tue, 26 Nov
 2019 09:10:01 +0000
Received: from MW2NAM12FT034.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::206) by BN8PR07CA0028.outlook.office365.com
 (2603:10b6:408:ac::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17 via Frontend
 Transport; Tue, 26 Nov 2019 09:10:01 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 MW2NAM12FT034.mail.protection.outlook.com (10.13.180.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18 via Frontend Transport; Tue, 26 Nov 2019 09:10:00 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99wHv018590
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 26 Nov 2019 01:09:59 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 26 Nov 2019 10:09:57 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 26 Nov 2019 10:09:57 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99vbd103209;
        Tue, 26 Nov 2019 09:09:57 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <antoine.tenart@bootlin.com>
CC:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH 3/3] net: macb: add support for high speed interface
Date:   Tue, 26 Nov 2019 09:09:56 +0000
Message-ID: <1574759396-103169-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1574759354-102696-1-git-send-email-mparab@cadence.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(36092001)(199004)(189003)(47776003)(48376002)(50466002)(305945005)(8936002)(50226002)(7636002)(11346002)(7126003)(8676002)(246002)(2616005)(446003)(478600001)(86362001)(16586007)(54906003)(26005)(110136005)(5660300002)(53416004)(356004)(76176011)(4326008)(30864003)(2906002)(7696005)(76130400001)(107886003)(186003)(14444005)(70206006)(36756003)(336012)(316002)(426003)(70586007)(51416003)(26826003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB5869;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17ff0f42-7ab0-4659-2f52-08d772506aa0
X-MS-TrafficTypeDiagnostic: MN2PR07MB5869:
X-Microsoft-Antispam-PRVS: <MN2PR07MB5869FFD7B850D1DB09FC57ECD3450@MN2PR07MB5869.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0233768B38
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdFOzRwPvJfPFrY4OsDhgFD/j1fXAHQjPDHAnEhhQ4MQZSfhIaYYeZvHh7+uFLAmz16CTxVEUFGQmkMN0yjtKiZ0fU8DD5VOpuSTrXNcF8WoCkb2HFWFRWM2XRfuLGJfgHT499NpHSfYNLj0nIW4kAp0x+Udh0iosovZw5aNBuGWWrvSA7Uk/oDyVNq0Neqi+K1utCh8Fckp8g6ZCCHFORIksCFOUm1XUt+uGZLM9vO23XlHLyaro56XQThl/D/Hz+nN5gaQwY9bLYTAw0i/J3rLhve3iZxzR+jJC8E8GFGVIJyuACXgZ0F7RzyGxDiKTUq/NXW+8hvlUXkUboLkNxWh6pQV55J0R9wyORnVt4kiTIepa8nNhWyef7KA7AoE33EXP49m91kIN2OMnX0ebApNrxyuN0tkI1mXtXlRy4dlV9za0odPfIcVN7EtbGT5dkamZmLu174F6qS8enDJVw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 09:10:00.7487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ff0f42-7ab0-4659-2f52-08d772506aa0
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB5869
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_01:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911260082
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  50 ++++++++
 drivers/net/ethernet/cadence/macb_main.c | 142 ++++++++++++++++++++---
 2 files changed, 174 insertions(+), 18 deletions(-)

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
index 7cdadc200c28..832d4481c337 100644
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
@@ -506,6 +520,7 @@ static void macb_validate(struct phylink_config *config,
 	    state->interface != PHY_INTERFACE_MODE_RMII &&
 	    state->interface != PHY_INTERFACE_MODE_GMII &&
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
+	    state->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    !phy_interface_mode_is_rgmii(state->interface)) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
@@ -518,6 +533,13 @@ static void macb_validate(struct phylink_config *config,
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
@@ -527,6 +549,22 @@ static void macb_validate(struct phylink_config *config,
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
@@ -544,6 +582,60 @@ static void macb_validate(struct phylink_config *config,
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
@@ -565,30 +657,39 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 
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
 
@@ -3396,6 +3497,11 @@ static void macb_configure_caps(struct macb *bp,
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

