Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B897D4737E
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 09:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFPHFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 03:05:30 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:45500 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfFPHFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 03:05:30 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5G722Oo015307;
        Sun, 16 Jun 2019 00:05:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=EUA/s9kp85Ft+Mkd8Ea4YAwNh3wR4ZTBeSnJVMCeo2A=;
 b=nWKU4kqSJLPXcpfOqzCNjYrK3msFhY1NfYMAd4N3KrT4LiN+s6BiOpTxsyPOf0FRl65H
 2nJ/+NMottXNunZ5hSt77qeo9jlOb8oZGvVxhmnpOpxknp41PibKdRT/8PFkjfs5IVYj
 +NP/q/OpdtKar7tE/KxNaKH4MIYOiXc1nuJfLG87BPGppwOkxGcC8EOoah/QINv0ZweB
 FoqrF87lpThytGkzJGdAyF5vygwCE9/MxZoO/EhetKCml7fSU9pfTFefr8GfRVaurpLd
 3vY/bOKKsB9fnENiL05xbXfIMA8larNoqrZ/zHBpbA5yf4LjQRFV+zLfQnBO4YyeBCv0 jQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2059.outbound.protection.outlook.com [104.47.40.59])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t4w7v2gng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Jun 2019 00:05:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUA/s9kp85Ft+Mkd8Ea4YAwNh3wR4ZTBeSnJVMCeo2A=;
 b=TbukwIvhVg84nom289hkD3EdH9t83798O27SyxmrgKHiSp6kgeb36erRyk1ZtLLmtnfzYuKvGgRzoecWgwr55RPmVqBN+jYr9EduOu/u0DiV1Rk43pXmbD10jxb4UOly8/V2H8ij+6I9+zG9jXPhKy+K+4VVPuh37kiih8iAZCM=
Received: from MN2PR07CA0010.namprd07.prod.outlook.com (2603:10b6:208:1a0::20)
 by BN8PR07MB6820.namprd07.prod.outlook.com (2603:10b6:408:b9::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.13; Sun, 16 Jun
 2019 07:05:22 +0000
Received: from CO1NAM05FT063.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::207) by MN2PR07CA0010.outlook.office365.com
 (2603:10b6:208:1a0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1965.14 via Frontend
 Transport; Sun, 16 Jun 2019 07:05:21 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 CO1NAM05FT063.mail.protection.outlook.com (10.152.96.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sun, 16 Jun 2019 07:05:19 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5G75ELE009029
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 16 Jun 2019 03:05:16 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 09:05:14 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 09:05:13 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5G75DXu022539;
        Sun, 16 Jun 2019 08:05:14 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 4/6] net: macb: add support for c45 PHY
Date:   Sun, 16 Jun 2019 08:05:12 +0100
Message-ID: <1560668712-22499-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560639680-19049-1-git-send-email-pthombar@cadence.com>
References: <1560639680-19049-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(136003)(346002)(2980300002)(36092001)(189003)(199004)(478600001)(76176011)(54906003)(69596002)(86362001)(7696005)(51416003)(47776003)(316002)(305945005)(8936002)(16586007)(110136005)(2906002)(48376002)(50466002)(53416004)(2201001)(77096007)(26005)(107886003)(186003)(4326008)(70586007)(70206006)(426003)(486006)(5660300002)(126002)(476003)(2616005)(7126003)(446003)(11346002)(8676002)(50226002)(336012)(26826003)(356004)(53936002)(36756003)(76130400001)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR07MB6820;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:ErrorRetry;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec0f91c3-dd4f-40a4-458d-08d6f228fe4f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN8PR07MB6820;
X-MS-TrafficTypeDiagnostic: BN8PR07MB6820:
X-Microsoft-Antispam-PRVS: <BN8PR07MB68203668758068565736AB0EC1E80@BN8PR07MB6820.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 0070A8666B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: olTkCek0xkTJ2E5Rbipq3VHBEDuTvz66PXzBAr261DChW9Gz+DlBwJ41bcDiakESn3/76qO4C9XWX7KVfYGrgB/nDEm0l4I1Kr6XaGdGfBtpfxg1JOHVwj0pyxERMddUPs637aXzfj7rZGZzMfpQMQgeyYOiOYCHxGpuh00DYsTcPMhJRGqiQfamJBbZkqwuKtuzhRXkxOV/vYF2bRzI2vSBfeFltmik2M8JZ4cf2Z8SkG89uHNA4lvE0jY1KTd3MuJRlIMQxddRM0YsfNKHFrAlfV9T1AoTXywPjd16sNQ2HuWzb+AhuGf1X7vkYmD6FZc/TkeLlZx+gCSalh7mGfO+q/iMrdC4Npf25aeTWQ/9kxBeQqK3LMA2lIVabD4GKZOZxxWTYZ1SMlu/k3RGlS487J8rD0JUjAOQzPYn1io=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2019 07:05:19.4843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec0f91c3-dd4f-40a4-458d-08d6f228fe4f
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB6820
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=810 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906160067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modify MDIO read/write functions to support
communication with C45 PHY.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      | 15 ++++--
 drivers/net/ethernet/cadence/macb_main.c | 61 +++++++++++++++++++-----
 drivers/net/ethernet/cadence/macb_pci.c  | 60 +++++++++++------------
 3 files changed, 91 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 85c7e4cb1057..75f093bc52fe 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -667,10 +667,17 @@
 #define GEM_CLK_DIV96				5
 
 /* Constants for MAN register */
-#define MACB_MAN_SOF				1
-#define MACB_MAN_WRITE				1
-#define MACB_MAN_READ				2
-#define MACB_MAN_CODE				2
+#define MACB_MAN_C22_SOF                        1
+#define MACB_MAN_C22_WRITE                      1
+#define MACB_MAN_C22_READ                       2
+#define MACB_MAN_C22_CODE                       2
+
+#define MACB_MAN_C45_SOF                        0
+#define MACB_MAN_C45_ADDR                       0
+#define MACB_MAN_C45_WRITE                      1
+#define MACB_MAN_C45_POST_READ_INCR             2
+#define MACB_MAN_C45_READ                       3
+#define MACB_MAN_C45_CODE                       2
 
 /* Capability mask bits */
 #define MACB_CAPS_ISR_CLEAR_ON_WRITE		BIT(0)
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5b3e7d9f4384..57ffc4e9d2b9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -334,11 +334,30 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (status < 0)
 		goto mdio_read_exit;
 
-	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_SOF)
-			      | MACB_BF(RW, MACB_MAN_READ)
-			      | MACB_BF(PHYA, mii_id)
-			      | MACB_BF(REGA, regnum)
-			      | MACB_BF(CODE, MACB_MAN_CODE)));
+	if (regnum & MII_ADDR_C45) {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(DATA, regnum & 0xFFFF)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
+		status = macb_mdio_wait_for_idle(bp);
+		if (status < 0)
+			goto mdio_read_exit;
+
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_READ)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+	} else {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
+				| MACB_BF(RW, MACB_MAN_C22_READ)
+				| MACB_BF(PHYA, mii_id)
+				| MACB_BF(REGA, regnum)
+				| MACB_BF(CODE, MACB_MAN_C22_CODE)));
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -367,12 +386,32 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	if (status < 0)
 		goto mdio_write_exit;
 
-	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_SOF)
-			      | MACB_BF(RW, MACB_MAN_WRITE)
-			      | MACB_BF(PHYA, mii_id)
-			      | MACB_BF(REGA, regnum)
-			      | MACB_BF(CODE, MACB_MAN_CODE)
-			      | MACB_BF(DATA, value)));
+	if (regnum & MII_ADDR_C45) {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(DATA, regnum & 0xFFFF)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
+		status = macb_mdio_wait_for_idle(bp);
+		if (status < 0)
+			goto mdio_write_exit;
+
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_WRITE)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)
+			    | MACB_BF(DATA, value)));
+	} else {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
+				| MACB_BF(RW, MACB_MAN_C22_WRITE)
+				| MACB_BF(PHYA, mii_id)
+				| MACB_BF(REGA, regnum)
+				| MACB_BF(CODE, MACB_MAN_C22_CODE)
+				| MACB_BF(DATA, value)));
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 1001e03191a1..23ca4557f45c 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -69,11 +69,11 @@ static int macb_mdiobus_read(void __iomem *macb_base_addr,
 	int status;
 
 	if (regnum < 32) {
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_READ) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_READ) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, regnum) |
-			MACB_BF(CODE, MACB_MAN_CODE);
+			MACB_BF(CODE, MACB_MAN_C22_CODE);
 
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
@@ -84,22 +84,22 @@ static int macb_mdiobus_read(void __iomem *macb_base_addr,
 
 		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_ADDR) |
 				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_REGCR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, reg);
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
 		if (status < 0)
 			return status;
 
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_ADDAR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, regnum);
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
@@ -108,22 +108,22 @@ static int macb_mdiobus_read(void __iomem *macb_base_addr,
 
 		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_DATA) |
 				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_REGCR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, reg);
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
 		if (status < 0)
 			return status;
 
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_READ) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_READ) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_ADDAR) |
-			MACB_BF(CODE, MACB_MAN_CODE);
+			MACB_BF(CODE, MACB_MAN_C22_CODE);
 
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
@@ -141,11 +141,11 @@ static int macb_mdiobus_write(void __iomem *macb_base_addr, u32 phy_id,
 	int status;
 
 	if (regnum < 32) {
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, regnum) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, value);
 
 		writel(i, macb_base_addr + MACB_MAN);
@@ -157,22 +157,22 @@ static int macb_mdiobus_write(void __iomem *macb_base_addr, u32 phy_id,
 
 		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_ADDR) |
 				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_REGCR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, reg);
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
 		if (status < 0)
 			return status;
 
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_ADDAR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, regnum);
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
@@ -181,22 +181,22 @@ static int macb_mdiobus_write(void __iomem *macb_base_addr, u32 phy_id,
 
 		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_DATA) |
 				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_REGCR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, reg);
 		writel(i, macb_base_addr + MACB_MAN);
 		status = macb_mdio_wait_for_idle(macb_base_addr);
 		if (status < 0)
 			return status;
 
-		i = MACB_BF(SOF, MACB_MAN_SOF) |
-			MACB_BF(RW, MACB_MAN_WRITE) |
+		i = MACB_BF(SOF, MACB_MAN_C22_SOF) |
+			MACB_BF(RW, MACB_MAN_C22_WRITE) |
 			MACB_BF(PHYA, phy_id) |
 			MACB_BF(REGA, PHY_ADDAR) |
-			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(CODE, MACB_MAN_C22_CODE) |
 			MACB_BF(DATA, value);
 
 		writel(i, macb_base_addr + MACB_MAN);
-- 
2.17.1

