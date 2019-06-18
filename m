Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED14AA1D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbfFRSnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:43:37 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:7668 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729642AbfFRSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:43:37 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IIgMtS023431;
        Tue, 18 Jun 2019 11:43:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=CbtvLuweCS4AJEAd4g2yUfC0GoCyn3x9tly6BSoOJSk=;
 b=tulz7PWHw9fQc4nPVp5Ctu2PhG+diuCJhEdzDbFdxMfg9TBub6tQT3bKkANjDuY3WfAW
 NeJFSdNZMb+nKsJzL2jRedAqN92hl3tcsVcths7aaGZPXqen0NKFyOXkY+mXXuzfwpcO
 TWA+q6Go2s4WVwPvSG7YGSUmv59mThg7B/Bj/uzHM6pc8yxQRP1m1nciQIsLiMRcYqKy
 moyRLCFm192aap/qeXAFIQgsVHDd2Y6FL55FxuqQDQzluXsMDAALXsffaG9g5wHlmHcU
 y7mfiBeVqRTtaLdfczVxn4r9dmjjClEmbKcPWE3wBcb9LWzOdyoKA1YJc8TUxhiRoVJu iw== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2056.outbound.protection.outlook.com [104.47.32.56])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t6qgsu8b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 11:43:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbtvLuweCS4AJEAd4g2yUfC0GoCyn3x9tly6BSoOJSk=;
 b=jT+Axd4fgw8ZhwhS0AAyb4Hlo6bhXHRwM10UQ71DZtJlKAj2/6FdO9xi8OcRb7u9amaekdTn0iRl+LOmhFeAtqlnBCj6H6Bf11XVtnpESqYkWUZukkD54/kcAkCC5HxcHb6cgxjB0douzbm5Eu+OscdibpTq+xti0rwmSKcM5/0=
Received: from DM6PR07CA0020.namprd07.prod.outlook.com (2603:10b6:5:94::33) by
 MN2PR07MB6832.namprd07.prod.outlook.com (2603:10b6:208:11e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12; Tue, 18 Jun
 2019 18:43:28 +0000
Received: from CO1NAM05FT027.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::205) by DM6PR07CA0020.outlook.office365.com
 (2603:10b6:5:94::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.15 via Frontend
 Transport; Tue, 18 Jun 2019 18:43:28 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 CO1NAM05FT027.mail.protection.outlook.com (10.152.96.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Tue, 18 Jun 2019 18:43:27 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5IIhN4d025033
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 18 Jun 2019 11:43:25 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 18 Jun 2019 20:43:22 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 18 Jun 2019 20:43:22 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5IIhM6a008584;
        Tue, 18 Jun 2019 19:43:22 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH v2 4/6] net: macb: add support for c45 PHY
Date:   Tue, 18 Jun 2019 19:43:21 +0100
Message-ID: <1560883401-8476-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
References: <1560642481-28297-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(136003)(396003)(2980300002)(189003)(36092001)(199004)(476003)(486006)(2616005)(54906003)(305945005)(11346002)(110136005)(7126003)(50466002)(7636002)(356004)(76176011)(50226002)(26005)(8676002)(77096007)(246002)(48376002)(53416004)(16586007)(5660300002)(8936002)(47776003)(2906002)(7696005)(51416003)(186003)(70206006)(86362001)(316002)(70586007)(76130400001)(26826003)(478600001)(446003)(426003)(4326008)(36756003)(126002)(2201001)(336012)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR07MB6832;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1df42186-4152-455b-314c-08d6f41cda5c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:MN2PR07MB6832;
X-MS-TrafficTypeDiagnostic: MN2PR07MB6832:
X-Microsoft-Antispam-PRVS: <MN2PR07MB6832A385FF64F43D80705445C1EA0@MN2PR07MB6832.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 007271867D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ieNI3Y7VbfbGvlNDAH3CysI4K7qV6/jonc4LwpNakQOV1l/sZReaFs3MDM6EW8uWSqEXjb9AEblGlvWJXZBvQBeItjVL37WDzhWF7GIel+GqZQg7HHcQa3tjRawiD7ZRcHRfx1SgsahkCdBFKI+1ZIKd0knyLWJ3pBIxB1zEW0lO4haFfePE45+bGmKDk3A2B3r33UX3CaHsFp46+5Xbqp5qAK/XshZwsyGAgV6n4CU8dqxZtMVqugcfbAImbDxQPVJk4FSjaBCjEEHjGbZr8SB9Fkacy6ZZQiTeYQLpKbvVseZnjLXk79lzeI7E3GYHBV3gxX7K79cSS/6vfcSptyDNd2jYUStdwnn7N+SIFY6Mry8wi1hwFcHWj7R9DOM9+i6ztwsX9Ci47yDRbFQznEAiDRm1ybO41MmeWBMO6PI=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2019 18:43:27.6748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df42186-4152-455b-314c-08d6f41cda5c
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6832
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=773 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180147
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
index 2665758147c3..033c51248884 100644
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
-- 
2.17.1

