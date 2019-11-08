Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE024F4D49
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfKHNez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:34:55 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:4772 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKHNez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:34:55 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8DWInd028271;
        Fri, 8 Nov 2019 05:34:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=+4HxCQDs/MDFte4dMzrqaxlyYrIjuNaX5GB0kSKGdeA=;
 b=AccunVA1bs7Yf4q5b/Np21uChlsGebS4gYJ3g0m7k95ZLpUv/NY7dCFHy6zyFHWG/IxY
 sXY6EKgMh7tqY4RAMMJ88RQk7F1Y60AgFHeq+5jEp85JxTmv9MqmM8SnO5pRGuMz5yHL
 1LDb2lcQ+KMR1Z5NjxELCUYqju8ZnB6VNJJ5tq4jBp7WtCCfMuLd7hfU+Yh3a3z9QDmP
 CUwCxm9VjigOvJYRDhbwZZ43Dg0cPAYtiGcdQ7OlMWqr9SSnwU+Vdn4vZNN3QIQodJl4
 qlEl2ykSbBlwtxanK/jHS96vuA1vK+yXsOJUIn44lctDC+g/TeH5108KCb8AgJaEknGn uA== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2051.outbound.protection.outlook.com [104.47.38.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2w41ty1bns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 05:34:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5y/nxwUlyunzo/iwfzWLEVBIWe3zGY1CcCiF2ZiGrrqLgMPoYT89jaN+vv4y8KLv85BQOwUwbCFb0H1qHw6WUsgeM37xH99zRYw1PkShUgHfY5AwLa2ckxkBBBYDmtP+zBJKVSnh366bkDR216GIBeJYvcUqgWj4P1QMT2nLCYIeQ6HqDcsuerj3hy8OhFedpqOAS5r9K+hSmWS1JkSfh+yXYW0RMHvUtNopdvNIroeo2D3ijlajpEFWRLd9mW5dWNFs5s1Hl8N3DqJcrwdL3Q0FdRqDWe036RWdUmbwCEF+9xEzP5kM0WqXf8YCA6Sg+43HYNSP+3Az8yq1B/0pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4HxCQDs/MDFte4dMzrqaxlyYrIjuNaX5GB0kSKGdeA=;
 b=oM+kUM3w8NbeCaGKB4SZyBcKw0dnmkLCJwcQNGYMBpw4XDOVyxKzDStPkb2KM3nkQMiyv+HEBlTNWxgVzjf4V2oUZej9mPH7HCxcw9vpsAUajYX/1tMEcGtp0xGVSslj/eVw4R1jr4FWhrek/q+QNru+hegq8Qy9cAapPq3PS2O3+58EZqTCva9+oEijZq3p0UwYuksUL1XtrnYJNZ4XCGs/gWHtcB/wVKJ0rR57LwJkj4QN/yonm8oIUYPxqtNXVXxMzQmTKm9NuDxtx4IUjLfVd5v13E8sNPqSIAqSkJLydq6SHGve2h1enkgritFUUfE84trzQh6GMPHcjeaeHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4HxCQDs/MDFte4dMzrqaxlyYrIjuNaX5GB0kSKGdeA=;
 b=eHcPHwwKipPFBdV8R1yFyJ4nENNkWxwYJqoKIIFxPsaunmTbpSG7aOs0brxrs3EfmJ8D4P8gqeZXR+305kCu/xncr8Bh4INFM4lOynq+7zdz8DPBFD0/dK1xoUPIWk8D69k8+lqp0uEuBfgME5LVPzAkkAOc4ngpElKh751du+o=
Received: from BYAPR07CA0061.namprd07.prod.outlook.com (2603:10b6:a03:60::38)
 by SN6PR07MB5616.namprd07.prod.outlook.com (2603:10b6:805:e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.24; Fri, 8 Nov
 2019 13:34:46 +0000
Received: from CO1NAM05FT003.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e50::204) by BYAPR07CA0061.outlook.office365.com
 (2603:10b6:a03:60::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.22 via Frontend
 Transport; Fri, 8 Nov 2019 13:34:46 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 CO1NAM05FT003.mail.protection.outlook.com (10.152.96.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.15 via Frontend Transport; Fri, 8 Nov 2019 13:34:45 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYgWP005292
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 8 Nov 2019 05:34:43 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 8 Nov 2019 14:34:42 +0100
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 8 Nov 2019 14:34:42 +0100
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id xA8DYf1F018547;
        Fri, 8 Nov 2019 13:34:41 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <piotrs@cadence.com>,
        <dkangude@cadence.com>, <ewanm@cadence.com>, <arthurm@cadence.com>,
        <stevenh@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 3/4] net: macb: add support for c45 PHY
Date:   Fri, 8 Nov 2019 13:34:40 +0000
Message-ID: <1573220080-18344-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1573220027-15842-1-git-send-email-mparab@cadence.com>
References: <1573220027-15842-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(36092001)(189003)(199004)(76176011)(2201001)(51416003)(110136005)(11346002)(2616005)(7126003)(4326008)(7696005)(446003)(16586007)(76130400001)(8936002)(26005)(8676002)(86362001)(478600001)(54906003)(316002)(36756003)(246002)(50226002)(5660300002)(426003)(107886003)(26826003)(126002)(53416004)(486006)(7636002)(70206006)(70586007)(50466002)(305945005)(186003)(47776003)(356004)(48376002)(476003)(336012)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR07MB5616;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a47cda7-4a14-4ad8-a1a1-08d764506b74
X-MS-TrafficTypeDiagnostic: SN6PR07MB5616:
X-Microsoft-Antispam-PRVS: <SN6PR07MB5616709676E1E4F19CFBB2BCD37B0@SN6PR07MB5616.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0215D7173F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgxF3luo7Ruq3K8dtT+qP26SbCJRBBIFqr2KlUI/oEqRhwIlwVc19CCNtjva22sHwo/qcbtiyqipUDqocSgixbB3wtyssVRjN5u5UsEFtkQaoDqFP1/pizxoUKZTZg4TfXUPwJy5cIn1kkoakePi514uAhslPvvnxA5itclcroXufR2ivYWoM1cN6g5Ks+SmJz9ul33Z0CYfUka70WXA5+18vgp0a1wG1wN62C7R5wus97542AOHpt3cm3wYiwQ1kPbsPaNITsWFv/nvAltCZDp95YfnVXikuY3cAbItxSNzRL2hj/0ydXGHDlxSwEJecA579L2xxNltmjfYxISlkkdxxvzoV12g2clQWn4DB0F1qu9HwUN+YIGMZBe1noiCD2HdKMAclhcLndMvdsmlLJSKIpZmaCmc85hYg1ek2K2HcC2+vX/9tML4Kj1QrWkQoqG1IpIrZr0OyXw1M68Sow==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 13:34:45.8530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a47cda7-4a14-4ad8-a1a1-08d764506b74
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB5616
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_04:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 impostorscore=0 mlxlogscore=811 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911080135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modify MDIO read/write functions to support
communication with C45 PHY.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |   15 +++++--
 drivers/net/ethernet/cadence/macb_main.c |   61 ++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 5e2957d..34136a8 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -646,10 +646,17 @@
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
index 8269d7a..fe107f0 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -337,11 +337,30 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
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
@@ -370,12 +389,32 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
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
1.7.1

