Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1D50A77
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFXML4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:11:56 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:41576 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726351AbfFXML4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 08:11:56 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OC7V7h029689;
        Mon, 24 Jun 2019 05:11:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=Z8DlpEMq3dP1y76EfH7vBRhXwNApRBly3gWlGvGvUlw=;
 b=axa+zPK4AmVU1oUe1eA2LhxnqDM54n3TcjD+ct5kW+86CtCELl5nAhX18byMVo77dGvZ
 47/uVgQIPZMUedXUyCVYwLZKpbcVQH5Y8qQ49DUs3ZvmJgy3laBJKdAi7hVX87GQWUji
 cTQJFrBw3rXbdoJ0OLKnweAVKMyD3XQw+bu+DW8v5PiDPBUdAbcY8OFETBu4mJqRe2oM
 FGDsi8Jb+gmcATIUADJqT3LybetI+MpB5JUIbR6r5NtFCkFvMfHsqKM1nNmAVu1uS3q+
 Q5HZafz2lDcQ4o6351UU9z6boz/FdHljlu88ewUnQTc3lTTBl52nZpKp7dlMuchvPuoi MA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2059.outbound.protection.outlook.com [104.47.46.59])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs7756-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 05:11:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8DlpEMq3dP1y76EfH7vBRhXwNApRBly3gWlGvGvUlw=;
 b=D85nHJO1jHOuoOad49PekyPw/7uhyNdv8CwQlaBwtmxbo1RNqssI7KZhfAIFV9GMsBoUsGpCam5Jm1kLNf/YRDighv7yk8D0yqoqDxiRoBxbVHU/0aO7ZuUQc0ttzqQS+/tVmTvDf35XKZbyBsJKe3z/fGhBpYoyq6KnvJy83d8=
Received: from DM5PR07CA0035.namprd07.prod.outlook.com (2603:10b6:3:16::21) by
 DM6PR07MB6971.namprd07.prod.outlook.com (2603:10b6:5:1eb::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Mon, 24 Jun 2019 12:11:45 +0000
Received: from BY2NAM05FT029.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::205) by DM5PR07CA0035.outlook.office365.com
 (2603:10b6:3:16::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Mon, 24 Jun 2019 12:11:45 +0000
Received-SPF: PermError (protection.outlook.com: domain of cadence.com used an
 invalid SPF mechanism)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 BY2NAM05FT029.mail.protection.outlook.com (10.152.100.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Mon, 24 Jun 2019 12:11:44 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCBe86005297
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 24 Jun 2019 05:11:42 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 24 Jun 2019 14:11:39 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:11:39 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5OCBdpL013017;
        Mon, 24 Jun 2019 13:11:39 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v5 3/5] net: macb: add support for c45 PHY
Date:   Mon, 24 Jun 2019 13:11:38 +0100
Message-ID: <1561378298-12877-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(39860400002)(2980300002)(448002)(36092001)(189003)(199004)(7126003)(53416004)(186003)(26005)(77096007)(7696005)(51416003)(76176011)(7636002)(47776003)(107886003)(305945005)(8676002)(50466002)(2906002)(478600001)(26826003)(86362001)(8936002)(48376002)(2201001)(246002)(50226002)(70206006)(70586007)(2616005)(36756003)(356004)(4326008)(5660300002)(76130400001)(316002)(476003)(126002)(54906003)(336012)(16586007)(486006)(110136005)(426003)(446003)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6971;H:sjmaillnx2.cadence.com;FPR:;SPF:PermError;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 857ee5ec-c065-4224-c607-08d6f89d2005
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:DM6PR07MB6971;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6971:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6971C85CC487EE0B5690E4D1C1E00@DM6PR07MB6971.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 007814487B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: F7nKiJy8w0/DRApf7U7LXh9UkLGAfTw+e3W0Lhm1JH3MQ2LKDl24dYCvUeVMJ0YJmOygSnPi9miOvOtx9C4hEMeg4S5/1yq2j6f82KtQGOVu/R07xnVuew7CT4fyydnb6uWKosTUByzs+glABuF/YCmLYfH+trBrVD2qSPZLwTxHvCWN22ImYKhq7zIeuT6B0ixISNPZZb5YunhbCEzfEb341izC38ib61e3McpUY9VKBaTuvlpfEw34FInv5H0F+AMDKnfXkHheI1XBEHA4pVJvwJl0CcQYMj3h1pMZmbzqn+i9/dzfjYbFVL5LRO9spZH1WylfWOietS2bMFmX93mfChawVeKIrTm2ql2o8S94C1oiiILbe0ALAvj+wXYLYca+QmjXoAEie1X4saUktyACNGQkKvFFA0JtE7CJvLE=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2019 12:11:44.9706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 857ee5ec-c065-4224-c607-08d6f89d2005
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6971
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=733 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modify MDIO read/write functions to support
communication with C45 PHY.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb.h      | 15 ++++--
 drivers/net/ethernet/cadence/macb_main.c | 61 +++++++++++++++++++-----
 2 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 6d268283c318..330da702b946 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -642,10 +642,17 @@
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
index 572691d948e9..1323f9b4d3b8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -341,11 +341,30 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
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
@@ -374,12 +393,32 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
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

