Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76E4729B
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfFOXsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:48:19 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46754 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbfFOXsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:48:18 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNicgO020579;
        Sat, 15 Jun 2019 16:48:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=EUA/s9kp85Ft+Mkd8Ea4YAwNh3wR4ZTBeSnJVMCeo2A=;
 b=IwKlI1qv6iKt1NaOgqQxyCWSkyVKZWi3p89rF9LLlxA5BEQuJzPlKGzKa0atAcJ4+JzD
 uM7DN6KZs1LNZ/wpW/eH+04Bu4uKWrtYd/zD6clcjmKb0nMfboNT7vxiG02BZOG2cBDZ
 wQjeo+NXO9MA/MN3C4b51HKeY6OuURpPkOxBV8nTrIaPt8xKQX4Xd3XLuujludM0Wh5W
 TDWjOADxR+YXXnAjuPsAZywNLqf9lLifUn2hObEGuHVGZbA6EQ0EHreUupSQB3Ybdrfk
 MMtQ4NbkmfvC2lMXCW/GgeqSk3ope9aTJJboMEC97+WzPnDiR4YxP5Hv7DWPXKpcOIUk 0w== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2055.outbound.protection.outlook.com [104.47.41.55])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8w2146-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:48:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUA/s9kp85Ft+Mkd8Ea4YAwNh3wR4ZTBeSnJVMCeo2A=;
 b=hltF4DBmClZtocoAISpmxnIOi5kwubRk8vo1qWi62gA3aVt+c6jByWF3yJ3RgC6QEtTRyoEkx9QnRDC6M4GpcYx4Yvk/FkR4xVfemnfYjr6Ry0Id5oLs9H7vjyq4+HahPSyxtUrEM99O4SOebxAoOgRoqjOCB1u6Zd2Att0jmG8=
Received: from BN8PR07CA0005.namprd07.prod.outlook.com (2603:10b6:408:ac::18)
 by BYAPR07MB6824.namprd07.prod.outlook.com (2603:10b6:a03:128::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.11; Sat, 15 Jun
 2019 23:48:10 +0000
Received: from DM3NAM05FT019.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::200) by BN8PR07CA0005.outlook.office365.com
 (2603:10b6:408:ac::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12 via Frontend
 Transport; Sat, 15 Jun 2019 23:48:09 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 DM3NAM05FT019.mail.protection.outlook.com (10.152.98.128) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:48:09 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNm445024318
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 19:48:06 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:48:03 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:48:03 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNm3mg028430;
        Sun, 16 Jun 2019 00:48:03 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 4/6] net: macb: add support for c45 PHY
Date:   Sun, 16 Jun 2019 00:48:01 +0100
Message-ID: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642444-27704-1-git-send-email-pthombar@cadence.com>
References: <1560642444-27704-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(396003)(376002)(136003)(346002)(39850400004)(2980300002)(36092001)(189003)(199004)(2906002)(70586007)(305945005)(336012)(69596002)(70206006)(76130400001)(5660300002)(2201001)(4326008)(86362001)(356004)(68736007)(478600001)(26826003)(53936002)(107886003)(316002)(110136005)(54906003)(36756003)(16586007)(8676002)(81166006)(76176011)(50466002)(81156014)(47776003)(8936002)(446003)(48376002)(50226002)(7696005)(51416003)(486006)(7126003)(53416004)(2616005)(11346002)(476003)(186003)(426003)(126002)(77096007)(26005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6824;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a3efa71-87c9-4291-0d82-08d6f1ebebc9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6824;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6824:
X-Microsoft-Antispam-PRVS: <BYAPR07MB6824EF52D893C97B00C97E49C1E90@BYAPR07MB6824.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Poc8y40t+x/8nAzB03WsFvZY8FueoJ+8tV9clKzL8/1vpCfUNalroCV6/zzGNOJI5IGJc6b8CsTewN8ehC7L8tU7mFIIArjvcbivHR9wihSU1pAvWgzcnYTBoEEI+MISwOBWNLl5IhPJXjVm8XGvfhgYKWwfxk65h992OeRB0a0TB6QhZNgdZ9MwTaLA9zvZvmIm8BZmHPLLHtlJU82r35oHfDwZagPTYyUJyNn6RmjkTtGUeR2NuFP+Bd5oqX3ZPSs4+kZ0sBr89WqJXkRLnmAQSCJsS3/ahwqB9kftyw8E7qpXtBgq2zTO4HZKfQhqXCyzWcdG98dVBKchI7pvjipGI2gF8Zj9hv+cb+oRFrschA0/qPdTfKROTfpaH2B58iXcmQ7QZeKVJG6DIty+nZ7Hi+H/qcfrXQFHoKVQ414=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:48:09.0061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3efa71-87c9-4291-0d82-08d6f1ebebc9
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6824
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=810 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150226
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

