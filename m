Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253586488A
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfGJOil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:38:41 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:34738 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbfGJOik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:38:40 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AEYPRr023172;
        Wed, 10 Jul 2019 07:38:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=b/t1xDWYN6Wu1vgU4OROxD8Q+AptZonT8ZlLOTH1IQA=;
 b=TPR/SGKL9NDL7AFZvg9R05IFS2G6CPxTgZQfEYNT2SF3NVCygYXmeLFiAH8pNtyW8xkN
 nb4QNbwh7Y2J/Gd1BPCl/dFw2Yr6A0P0/bh3yoFuYV8zGRQkTd7pjw48Ropqi6P0zU25
 /LC0BizeWKznSrJJaMoo5XhJA+ABzxg2BI7f8jgpT2odx/JpR2+eQ5/pSWttTeHe8bE6
 eRkjxZ1gJKbTLUCkwGo04MClU4dSH+3cLVkyipDX1LKKZbX27+bQoSS4uAUb8+0BKV+Q
 VUzkl+BnUuhFd5TAVZhoUn/ZSdJGjcflqOOvPcPQy83K0QBCUvKo0GivFjRc6aOrJzTq Lg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2051.outbound.protection.outlook.com [104.47.40.51])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2tjq7wrf5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 07:38:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKy4YqW7y8akurhn1J44JWEx5SwbKl/uphRECljy4Xoa+k+pSodak8NrTHieSpYvZ2ugRKWdjHUH6XoI8DLrA/Y6BlWSFYgb76PWdBTwUVt/DQuLphkVk1aGV8EcduXUVYm/VPwaE4PePtD246rz2BrDbe8vZY+LlO5B0Yae3Cy+9vGDbKwJU3AhfEoduAEJh6x6X7I7bLRqDnpMcu1bN/l0iSVH8dR1d/zdlcaRx0suhWe1wqCW3W7BzbQGiXpmdkAGh9Z1Mlu8ggtHVcdpQKCitfFTa939qpU8MLtz4+LcmQU98AotfjwwcUPt82+ctmh9ig1BuF18H/QktBz4Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/t1xDWYN6Wu1vgU4OROxD8Q+AptZonT8ZlLOTH1IQA=;
 b=c5pdp5moDqY/cJrkZe5f7eby597ofKl6gjvj1ZC6KEQ0HTZ+9XnVk7F9/P3WZhbQnzJ8awNh4A5+oQjeVOdV7IyBqXbHspOLBAwXo6tZrGd1C3bnOj1CrfkLBfUmMcN0w80QtXRbnjw+UkLPZK0xroNP38FrLZxp3jT2J21KY5ioyzTa96+K24YRXfkcGRuMIoGTFtvKZN6KB5ND9hSopt3R2p1lhRqfo08g5lWwtW5dB3FbgH7QvwoZmqXmUuMZTNWnPwHobItkJ1vWgZAttABduq8Ba3duRs+0aDjlpLiIz0Q2p24C7FPfCFdxGSIY6m2bqNkBhNR0YdGyNBf9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=softfail (sender ip is
 199.43.4.28) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=cadence.com;dmarc=fail (p=none sp=none pct=100) action=none
 header.from=cadence.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/t1xDWYN6Wu1vgU4OROxD8Q+AptZonT8ZlLOTH1IQA=;
 b=ohEyEMJUI/fLhiU/fysIMXu2v/boVFQzwnUnfJ27S9IUmIlWo/4XFT+KFxmAOMvDgh5mJ1mjW08TWETTi9E9czapZmPS0kiB9/425t9n13NtrzlpNeHj+lZm3KR+yCMBFBDbHfuLN/hLwIjRnEHwJiQmBsd+BXCIIBGygnBi6dQ=
Received: from BYAPR07CA0045.namprd07.prod.outlook.com (2603:10b6:a03:60::22)
 by CY4PR0701MB3636.namprd07.prod.outlook.com (2603:10b6:910:93::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2073.10; Wed, 10 Jul
 2019 14:38:24 +0000
Received: from CO1NAM05FT031.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::205) by BYAPR07CA0045.outlook.office365.com
 (2603:10b6:a03:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2073.10 via Frontend
 Transport; Wed, 10 Jul 2019 14:38:24 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT031.mail.protection.outlook.com (10.152.96.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2052.8 via Frontend Transport; Wed, 10 Jul 2019 14:38:23 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEcIW3010406
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 10 Jul 2019 10:38:20 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 10 Jul 2019 16:38:18 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 10 Jul 2019 16:38:18 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x6AEcHQI001008;
        Wed, 10 Jul 2019 15:38:17 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <piotrs@cadence.com>, <aniljoy@cadence.com>,
        <arthurm@cadence.com>, <stevenh@cadence.com>,
        <pthombar@cadence.com>, <mparab@cadence.com>
Subject: [PATCH v6 2/4] net: macb: add support for sgmii MAC-PHY interface
Date:   Wed, 10 Jul 2019 15:38:16 +0100
Message-ID: <1562769496-959-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(376002)(2980300002)(189003)(199004)(36092001)(2616005)(486006)(11346002)(476003)(446003)(7126003)(126002)(14444005)(305945005)(69596002)(70206006)(81156014)(4326008)(70586007)(110136005)(47776003)(16586007)(81166006)(8676002)(76130400001)(36756003)(48376002)(50466002)(2906002)(426003)(356004)(336012)(186003)(26005)(107886003)(53936002)(478600001)(5660300002)(26826003)(2201001)(76176011)(50226002)(8936002)(316002)(86362001)(53416004)(51416003)(54906003)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0701MB3636;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:ErrorRetry;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f295a4a2-f883-46fd-3eb6-08d70544432f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:CY4PR0701MB3636;
X-MS-TrafficTypeDiagnostic: CY4PR0701MB3636:
X-Microsoft-Antispam-PRVS: <CY4PR0701MB3636247D56FDD45016371A36C1F00@CY4PR0701MB3636.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-Forefront-PRVS: 0094E3478A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: B72Mpc48q6oRTIrgPIleCcR1rXxeX5hvnyBK7b9m+t+FxBCdMH1gaGRfqTgaWFGjoITtiW5PA/1FCYol3+gemTodnr4yGJ5JhmMcRTEmuHLqx01/HbXibPK72QCYGZGj0oVsdmfAxRJH7uN0uXHECDK0d5ip62zag1HfpwZ+ssarq5/H/ungpwzYUQUOKGsLLyFKWs0EFDBQxIrrx9pogwxFBMklKxDRQs6APPFe806h3ja4k/C/Un4ytAUYKS9fgSNUZZHXvX4y6Aqw4Ig/7Z3z0+bykZ175iRR9rZYcXmc8Tbu4iY0AXP16auI6ya7wpz/MAyya4Hpfx6Ro/HHv+mHOpneTZyHepXF5qOT3D34sb2q3dmzBIm8IAYWxK9AbuzS48QR2yFnSVTkh/O5kcQBJhR6/wPIO9z2mw7HlD8=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2019 14:38:23.5566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f295a4a2-f883-46fd-3eb6-08d70544432f
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
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

This patch add support for SGMII interface and
2.5Gbps MAC in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      | 54 ++++++++++++++++++------
 drivers/net/ethernet/cadence/macb_main.c | 42 +++++++++++++++++-
 2 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index a4007057b35e..301fbcb0df4b 100644
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
@@ -637,19 +652,32 @@
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
index ce064eb9252a..6485fcc0560b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -443,6 +443,10 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		if (!(bp->caps & MACB_CAPS_PCS))
+			goto empty_set;
+		break;
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (!macb_is_gem(bp))
@@ -453,6 +457,8 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 	}
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
@@ -497,8 +503,26 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 
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
@@ -3356,6 +3380,22 @@ static void macb_configure_caps(struct macb *bp,
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
-- 
2.17.1

