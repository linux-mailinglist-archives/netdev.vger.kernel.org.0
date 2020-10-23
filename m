Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ED8297289
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750953AbgJWPji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:39:38 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:33182 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750938AbgJWPjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:39:37 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09NFNJNf026205;
        Fri, 23 Oct 2020 08:39:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=jXU50871J0xlHpyd3+gOvZtlKH8HhccG1Aan5Y+nGqk=;
 b=QXcT/x5IZJ56l6sQr99AUe6mG5I9t4Ra1Sx1fZg0hcRW/waDJ+BY5NYE2N15H6bg+4Tv
 prvYuYGXhLwaIZhuMauG6SB+dsgnzLjnJXFgbHuiESluq9ZyFA6HnRFhf0cqw6heT7fO
 b9Tg2sHuIbQ/q9LoNUbMFEWIbP5iksBIk1XwE0y+ksC58TNgIuBw+iUI0MlKh5mIg/iv
 uoDsmaAHRxq66pMIrP9hY/mekNjRF0nl7MKaS//U8uH/26rjq+KwmqjQPyVZbNCbl80d
 D/XrSnyBAIvrfexV7sB8RGTJRt2nJLtBaiRBynyVGB0snN2sCOq/JZld3YpGOidWf4Hm GA== 
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2051.outbound.protection.outlook.com [104.47.37.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 347w5yh8ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Oct 2020 08:39:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfpCtUayegbLXo4F77P6Oz2onFwQyDZeUTFXt/vNILaL0Oxoevgs7WWJWad+f6fO4LuLlZQqOSoy2KewR+1TK9E1J14u5MsQTps071qH6+uRMOMZDelydW5G1lj1Whckv3JQGi1TGWJ1NZRNynJqZANU252OPuHQZ7HvRIsprL4fGojFRRMSRUPSNOeVDqZqXTIuONROq9yxd0aTjz8qAwSwYKfUTTPGLEvzpyx91E/rQU9iluxSDNjiXdMqsCUjNsarPjMHopEYK93i8ujPU8IB2vOqXaoMo3fqJ1LInB0UIkfo5UYIH6d5ZCsTMcu9fLZRRRxesh3XibS9kaq9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXU50871J0xlHpyd3+gOvZtlKH8HhccG1Aan5Y+nGqk=;
 b=GWACAtrs/zP9KXlaGEYvMHKqstfqtxJSEku+7uBUNTywzVmVlREPPQagVZECbSmyAEuqpAxlTPVeZUB6ogos1JkKGvII8vkaOodYJv5ac8/eAbvIypFnwe9HBAgLqD0V2C8TvsWD//coRsnDRVyycC86qSjKlwX/oa+9i9KGeXbqg/pTblQ3LPeTBsFMU1uM9DBLLjB4fAEM93tQj3p+D2odJRpQrH4NH6ebxLznTAlFv1ejZeru93Y67+NO29y8oTpFZUw6ecEgitKP95JOuXTcJJieO50IIGLrqaV2NDtDAZaZIo+w47Zb6gvxkf9706io3H1q1dal09hgR7i8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=microchip.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXU50871J0xlHpyd3+gOvZtlKH8HhccG1Aan5Y+nGqk=;
 b=eZXj0Uzi6eRoIPLc3uvUQzi8aPHm2M6AXwTAnQs1HLlow0k0im9PLyF4qSbHoJAB4zEbsNFJz4TRAtOiRtUwi2xMMmwYv4+yILdiCyG1nO6KQuNrRXymp2kMW08RoBr6Ys74/lhwQ+SPGzz5fdFhcXpjuIbehW3HyQx0BlxwQh0=
Received: from DM6PR10CA0035.namprd10.prod.outlook.com (2603:10b6:5:60::48) by
 BL0PR07MB8211.namprd07.prod.outlook.com (2603:10b6:208:1c8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 23 Oct
 2020 15:39:22 +0000
Received: from DM6NAM12FT022.eop-nam12.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::a2) by DM6PR10CA0035.outlook.office365.com
 (2603:10b6:5:60::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend
 Transport; Fri, 23 Oct 2020 15:39:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 DM6NAM12FT022.mail.protection.outlook.com (10.13.179.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3520.9 via Frontend Transport; Fri, 23 Oct 2020 15:39:21 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 09NFdEWD020142
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 08:39:16 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 23 Oct 2020 17:39:13 +0200
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 23 Oct 2020 17:39:13 +0200
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 09NFdEDQ027646;
        Fri, 23 Oct 2020 17:39:14 +0200
Received: (from pthombar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 09NFdAK4027645;
        Fri, 23 Oct 2020 17:39:10 +0200
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <linux@armlinux.org.uk>, <andrew@lunn.ch>
CC:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <inux-kernel@vger.kernel.org>,
        <mparab@cadence.com>, Parshuram Thombare <pthombar@cadence.com>
Subject: [PATCH v4] net: macb: add support for high speed interface
Date:   Fri, 23 Oct 2020 17:39:07 +0200
Message-ID: <1603467547-27604-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a00bf8f-d4c3-4a08-c5d8-08d87769cfa0
X-MS-TrafficTypeDiagnostic: BL0PR07MB8211:
X-Microsoft-Antispam-PRVS: <BL0PR07MB8211FDAB854929A17E9D2328C11A0@BL0PR07MB8211.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGA+ISYSm7OUlRqGszqhCITCKfJecy+cNm1s8TmH3Eqb5oic9CR5SkNJceF2suSSIAZhbzQFHyXjGsuL+CLpjpo3DdOISLq+jSgATZxXKMLubG70AMiO0Jlnyd9NDiGn/QNFQFhUT4W8twCMgjLO5cDaReesuBEjE7MhekinOpKpkjsXEB705CRn8W4YMtNr0b0zeQegOTMNDDr0mxrFc3DnUMcUvaXR2kN9fmzUmIFs5oNEF2kp5uCb3uSmCnOsZHK2h6PsuhcTrNfN3yOUjblvo3J53q9O9ABHajoH8OhffFEW721vwEWNsPaLwTzQSGkn4b6bOJ4PrHs0dR6nKlBG4XwjpyDK4XTQCEsTP4er0I64r0iqcMeOzr2NDpUzARKdulZq137M7Q0jiTJtUueafPpa/FmG9JoaFOGOmPQ=
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(36092001)(46966005)(54906003)(8676002)(36756003)(2906002)(107886003)(30864003)(82310400003)(81166007)(83380400001)(356005)(5660300002)(70206006)(70586007)(6666004)(82740400003)(2616005)(336012)(36906005)(26005)(110136005)(186003)(478600001)(47076004)(4326008)(426003)(8936002)(316002)(86362001)(42186006);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2020 15:39:21.0437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a00bf8f-d4c3-4a08-c5d8-08d87769cfa0
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT022.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB8211
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_09:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for 10GBASE-R interface to the linux driver for
Cadence's ethernet controller.
This controller has separate MAC's and PCS'es for low and high speed paths.
High speed PCS supports 100M, 1G, 2.5G, 5G and 10G through rate adaptation
implementation. However, since it doesn't support auto negotiation, linux
driver is modified to support 10GBASE-R instead of USXGMII. 

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
Changes between v3 and v4:
1. Adapted new phylink pcs_ops for low speed PCS.
2. Moved high speed MAC configuration from pcs_config
   to mac_config.

Changes between v2 and v3:
1. Replace USXGMII interface by 10GBASE-R interface.
2. Adapted new phylink pcs_ops for high speed PCS.
3. Added pcs_get_state for high speed PCS.

---
 drivers/net/ethernet/cadence/macb.h      |  44 +++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 123 +++++++++++++++++++++++++++++--
 2 files changed, 162 insertions(+), 5 deletions(-)

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
index 883e47c..90fb78d 100644
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
@@ -545,23 +570,80 @@ static void macb_validate(struct phylink_config *config,
 		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
 			phylink_set(mask, 1000baseT_Half);
 	}
-
+out:
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static void macb_mac_pcs_get_state(struct phylink_config *config,
+static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+				 phy_interface_t interface, int speed,
+				 int duplex)
+{
+	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	u32 config;
+
+	config = gem_readl(bp, USX_CONTROL);
+	config = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, config);
+	config = GEM_BFINS(USX_CTRL_SPEED, HS_SPEED_10000M, config);
+	config &= ~(GEM_BIT(TX_SCR_BYPASS) | GEM_BIT(RX_SCR_BYPASS));
+	config |= GEM_BIT(TX_EN);
+	gem_writel(bp, USX_CONTROL, config);
+}
+
+static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
 				   struct phylink_link_state *state)
 {
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
+
+	gem_writel(bp, USX_CONTROL, gem_readl(bp, USX_CONTROL) |
+		   GEM_BIT(SIGNAL_OK));
+
+	return 0;
+}
+
+static void macb_pcs_get_state(struct phylink_pcs *pcs,
+			       struct phylink_link_state *state)
+{
 	state->link = 0;
 }
 
-static void macb_mac_an_restart(struct phylink_config *config)
+static void macb_pcs_an_restart(struct phylink_pcs *pcs)
 {
 	/* Not supported */
 }
 
+static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
+	.pcs_get_state = macb_usx_pcs_get_state,
+	.pcs_config = macb_usx_pcs_config,
+	.pcs_link_up = macb_usx_pcs_link_up,
+};
+
+static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
+	.pcs_get_state = macb_pcs_get_state,
+	.pcs_an_restart = macb_pcs_an_restart,
+};
+
 static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 			    const struct phylink_link_state *state)
 {
@@ -588,6 +670,13 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_10GBASER) {
+		gem_writel(bp, NCFGR, GEM_BIT(PCSSEL) |
+			   (gem_readl(bp, NCFGR) & ~GEM_BIT(SGMIIEN)));
+		gem_writel(bp, NCR, gem_readl(bp, NCR) |
+			   GEM_BIT(ENABLE_HS_MAC));
+	}
+
 	spin_unlock_irqrestore(&bp->lock, flags);
 }
 
@@ -664,6 +753,10 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	macb_or_gem_writel(bp, NCFGR, ctrl);
 
+	if (bp->phy_interface == PHY_INTERFACE_MODE_10GBASER)
+		gem_writel(bp, HS_MAC_CONFIG, GEM_BFINS(HS_MAC_SPEED, HS_SPEED_10000M,
+							gem_readl(bp, HS_MAC_CONFIG)));
+
 	spin_unlock_irqrestore(&bp->lock, flags);
 
 	/* Enable Rx and Tx */
@@ -672,10 +765,25 @@ static void macb_mac_link_up(struct phylink_config *config,
 	netif_tx_wake_all_queues(ndev);
 }
 
+static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct macb *bp = netdev_priv(ndev);
+
+	if (interface == PHY_INTERFACE_MODE_10GBASER)
+		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
+	else
+		bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
+
+	phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
+
+	return 0;
+}
+
 static const struct phylink_mac_ops macb_phylink_ops = {
 	.validate = macb_validate,
-	.mac_pcs_get_state = macb_mac_pcs_get_state,
-	.mac_an_restart = macb_mac_an_restart,
+	.mac_prepare = macb_mac_prepare,
 	.mac_config = macb_mac_config,
 	.mac_link_down = macb_mac_link_down,
 	.mac_link_up = macb_mac_link_up,
@@ -3523,6 +3631,11 @@ static void macb_configure_caps(struct macb *bp,
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
2.7.4

