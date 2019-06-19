Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDD94B43E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfFSIlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:41:11 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:61800 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730996AbfFSIlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 04:41:11 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5J8XXb4026447;
        Wed, 19 Jun 2019 01:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=rQG7q4RE7w0TD0yhpI9kg3F5KH8wRjKzi4AgCAlxvxY=;
 b=lueOm572rZwOeKz8bGXI6kEzRrYJkxMnz03A/ow11D0OHPk3z3SVO+Z5klRKf6BdiA8c
 JQcHx0aLY97Ul6RTbBsgDFP04gP3n1mEf7ZPktX8PhHINUIcT8Sjq3i9C/xX8pG6sq8i
 1hULGe3dd+DAqvaIxrmmdc2XxqlSpFb4YBrbYm1wuiAWF1byVevZVn+5IiCDVgHPEZCT
 t7KKuh3MHqzJZfT3iOVbgK6IesjyahEIimjpAVAXxw0yzVQcgqz8Tl8xTpos4j7KyWu/
 qIhcCF1gcLrNFlv9bqs3IyGCLf30Usbnf54DdEoMwSiP9es9w+DW7ElLz9lewBcUM9Yx tg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2053.outbound.protection.outlook.com [104.47.36.53])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t7byx1gxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 01:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQG7q4RE7w0TD0yhpI9kg3F5KH8wRjKzi4AgCAlxvxY=;
 b=Aen9UoJqWbysfJ1WoyoiQdFNKMDPNllquDaJ7eUkVo/UTS2K8NUN1VAX0KTBFISzXNFkKAzWZt1ZVEtby2x5yVitWeZArB3eUC+bMf8v+Yvfmys7tirGsx5wDvYirT3l9caGRQDk7Q5hEsZwwdZ2u2DVUgD3oXKjm4paIu3ilsI=
Received: from DM6PR07CA0036.namprd07.prod.outlook.com (2603:10b6:5:94::49) by
 BN8PR07MB6961.namprd07.prod.outlook.com (2603:10b6:408:d6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 08:40:58 +0000
Received: from BY2NAM05FT035.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::204) by DM6PR07CA0036.outlook.office365.com
 (2603:10b6:5:94::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.17 via Frontend
 Transport; Wed, 19 Jun 2019 08:40:58 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 BY2NAM05FT035.mail.protection.outlook.com (10.152.100.172) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Wed, 19 Jun 2019 08:40:58 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8euM2017071
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 19 Jun 2019 01:40:57 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Wed, 19 Jun 2019 10:40:54 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 19 Jun 2019 10:40:54 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5J8etp1030086;
        Wed, 19 Jun 2019 09:40:55 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v2 3/5] net: macb: add support for c45 PHY
Date:   Wed, 19 Jun 2019 09:40:53 +0100
Message-ID: <1560933653-30043-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(346002)(136003)(2980300002)(199004)(189003)(36092001)(107886003)(48376002)(508600001)(5660300002)(356004)(70206006)(305945005)(7636002)(36756003)(70586007)(26826003)(8676002)(86362001)(76130400001)(2201001)(26005)(16586007)(2906002)(426003)(4326008)(316002)(54906003)(486006)(50466002)(76176011)(53416004)(110136005)(126002)(7126003)(7696005)(11346002)(47776003)(476003)(246002)(446003)(77096007)(50226002)(186003)(51416003)(8936002)(2616005)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR07MB6961;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 011a3caa-1617-4549-fd85-08d6f491d9cf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BN8PR07MB6961;
X-MS-TrafficTypeDiagnostic: BN8PR07MB6961:
X-Microsoft-Antispam-PRVS: <BN8PR07MB6961A921AB970E42752393C0C1E50@BN8PR07MB6961.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0073BFEF03
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: f4Pn4x1J8xGCaJGtOCvKtK3nfIjon3XCeuGBvIHJIag03LEsKIUDdcltuOb6uVV4zEfa9JrfinigK3OKJ8BhiJYh2z0ykzE59ZMh9aJqm1QYi04quoJHnGgb6Iv7ihD6N1q0wMZCOjtxnNZAwQ1SOtFZ8ES4NyVNOV5hdC/D0Sl9zcc3Zpofj1YgBcTyG/k64bdPYYyGMXLcdIxh5U7kplMiM6o7PBbT5+Ag50XfWthhZQeAd3KsylnFnngy9tfE7OEKEG1iI028KlHhUFDdcMvpje6bdN7akFPLo4F8bZANkAasaF9B5sitAQWW6OxrETIdWICYOIAT6TTvBxq/CpYlIrGwm7FC6Kj5bzuVP7nksvRG9z2QwRygY790/3sb/jAZPMpAomkVRVn23hkvN9gOJuEAwtcdzlb5XcmWK5I=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2019 08:40:58.0625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 011a3caa-1617-4549-fd85-08d6f491d9cf
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR07MB6961
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=785 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190072
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
 2 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index d7ffbfb2ecc0..34768d35aea1 100644
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
index 884d2a4408ad..cf63381d54ee 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -344,11 +344,30 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
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
@@ -377,12 +396,32 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
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
-- 
2.17.1

