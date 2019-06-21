Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72014E1FB
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfFUIfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:35:16 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:25534 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726250AbfFUIfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:35:15 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5L8YA8J005053;
        Fri, 21 Jun 2019 01:35:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=EEtlJ9NdDZNZ2ox5PmRGLJ91F8IzhcpzW3UUTz8EF0w=;
 b=mxADPK/u4b1FvYOy+DEO/SrdPyGzCjheSztcbJnVWJbDnhoGfStyw2vYAQq+MXrQOwOz
 sKeoGEQnA6sQURkPDP4AB+R9bPPFuKoRAZK024cDFjSPwOjZUKRoMqmBKbS8vLD/Rgag
 beFHJHAG2O/RDJ1r99a5QV+xzXlM5lIn1aZvQRXK5yPA0COrPTNziGfJVRYvKRmuA07U
 i+U0HOHX+uf5fBT6w7nLH1T2ajrAgjXvT1ESU4N/bL+O1t594+1/u20N2jTOmgiABLxJ
 OtiSPFYTDzO2B4uX6s7Uu3M4mHzxE28l125UkIyxPM3vQwTxiriWT3yA8bx/0y8HsbxA lg== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2051.outbound.protection.outlook.com [104.47.50.51])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t8cht4h8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 01:35:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEtlJ9NdDZNZ2ox5PmRGLJ91F8IzhcpzW3UUTz8EF0w=;
 b=JOBYRLtaFDr3qRzq+zdl/rsKyA/QZuR3dP4Xdah/iGGirMFZyz+HuByGtzAiIMsII2Hw0OODY/I97xXfWL/CN3Rsz2f/YYYvAnfYEAO7W8lHTDJHpUCqLWp5hy31K43HJjRMlN9lHYuFSuH6w9FE+wu2oL690Cblbob5LDf1N2Y=
Received: from CH2PR07CA0015.namprd07.prod.outlook.com (2603:10b6:610:20::28)
 by BYAPR07MB6824.namprd07.prod.outlook.com (2603:10b6:a03:128::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.11; Fri, 21 Jun
 2019 08:35:05 +0000
Received: from BY2NAM05FT041.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::204) by CH2PR07CA0015.outlook.office365.com
 (2603:10b6:610:20::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.13 via Frontend
 Transport; Fri, 21 Jun 2019 08:35:04 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 BY2NAM05FT041.mail.protection.outlook.com (10.152.100.178) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Fri, 21 Jun 2019 08:35:03 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8Z15c024347
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 21 Jun 2019 01:35:03 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 21 Jun 2019 10:35:01 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 21 Jun 2019 10:35:01 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5L8Z0Zg008872;
        Fri, 21 Jun 2019 09:35:00 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v3 3/5] net: macb: add support for c45 PHY
Date:   Fri, 21 Jun 2019 09:34:59 +0100
Message-ID: <1561106099-8803-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(346002)(396003)(2980300002)(36092001)(199004)(189003)(70586007)(336012)(186003)(126002)(5660300002)(26005)(2201001)(305945005)(70206006)(478600001)(76130400001)(107886003)(4326008)(316002)(426003)(2906002)(54906003)(16586007)(246002)(8936002)(110136005)(86362001)(26826003)(76176011)(8676002)(50226002)(356004)(50466002)(476003)(53416004)(51416003)(486006)(2616005)(36756003)(11346002)(7696005)(77096007)(7636002)(47776003)(48376002)(7126003)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6824;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b3e5cc8-8e84-40be-3490-08d6f6235b90
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6824;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6824:
X-Microsoft-Antispam-PRVS: <BYAPR07MB68243E942A6CF1DB1E19ACB1C1E70@BYAPR07MB6824.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0075CB064E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: OR0Q0dLmSfJvfOVnQPV1ttTO8SL7QxfGabHDU6N8qt6/CApc9wVKG1hDd50JF7m0Xobwz8z5b0z4IixRHnvZEgTKFp1HGbhu3Ovyz5qtge280tVyXqS7Loq+/L5yHFxuZ1SfdkCJkrxWBN5ohmezDoxyUHFDrCAWmMx2LnFCHsAcxgRQQZ/yJrX5eiVqetUq+SDjmEwk89BOJwaluWTGyA1MRJkJOMfZiO9UVKzPXSepvMopwDYykDrAX1Y6pSV8vwDfGC4YeJwmWSdVCGXotpJG6L0Yz+qZCmQcD+Jpm22mSsQ8V8XVvSm+UOydHyHWMvHw+dSL7cf/OR27ulf/X8vn3J4VnLhiNlVoYkMSNOFvxdljcdlii51ZW0Y/K+M+/V4hKymw8CdvYpkanOzQIfc7Ani+exfvqW6d8HSGEj0=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2019 08:35:03.9355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3e5cc8-8e84-40be-3490-08d6f6235b90
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6824
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=760 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210072
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
index 0647689f9796..b59840f5c023 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -645,10 +645,17 @@
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
index f1e58801ccf5..bdb57482644c 100644
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

