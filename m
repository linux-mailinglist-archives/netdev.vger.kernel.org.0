Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87137109AC3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfKZJKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:10:07 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:14998 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726346AbfKZJKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:10:06 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQ99RbK008880;
        Tue, 26 Nov 2019 01:09:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=PFIaAS9zM/R+yLKoKtxxd6WZ82LJGPBGZBlcW1N6zHU=;
 b=mqHmMz86/VAxS/6/UhosifWZZS6dhDYgD3YSGqOxtmBxctZ5QAscQTkw2FkXL/gJZKir
 3+PpUPAPh/dzK2eRJLsz78q28CZJX/HBLv+L3GoU0lQ/oJxuaC9u7M0V0T8CgxHpKN03
 YCRxZzvJzXec+ACbG9v1Io/qDNmn3lM3nF39QevlbDE/ANOg5jVfFdNcNCi67WUKrnA2
 gA37j+GgblLmz6+8ocpVJ80NPbMdLnH2B5rRLudeM/vEfbfPyv1ugFFqzuPB2tH7uElA
 8gTcgec0JO8rBBPWa0M0YI2efXmlv4iwzTGnUCrU8J7M9eKJ5OksA0+6pqgGwklRyjdp 0g== 
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2059.outbound.protection.outlook.com [104.47.33.59])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wf180bemn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 01:09:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqK8EyFBPFZQZFZf6Na8Uty/eB0WW02Da6figtNN08RCCCte4AWzZpVmhC25poAXBCpZw5E2r6o7trQLJ+0yjDymkbprWu598hkGYNSCkcGq8HG0S7te9+0oy3KSqJ4/WJQeE4NnL7E4vpXPdruMKt4vsCUsxA4g2ba9n22Hsx1KgUyjRaBfP52ndeRgeQ1dOTdZfzjgU7nfDKV6J/6K+LnJhYyfZGdUUzHy3lxnXsVVMGFqLp9ao7mjgrKOdQ8zKn/M5Npk+pfHcyMnyxJJL2ENcfSujwYy6esRzvnPxYk5VNmKONi4Q3O41C7wV3a/9s/zRsJrRaXlTqPc+rqS3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFIaAS9zM/R+yLKoKtxxd6WZ82LJGPBGZBlcW1N6zHU=;
 b=cCmnu7clsulUo7pDCjpnEFnpp8/PfPCfvmWv5b224BCJD4WidHl6uujTjUptxSPz0O0kdVIR499reK3HAUXixeZpf7rALvbJk3VVTrCtC89eGFyh7pQ4tqo63rVxjlx/yQIdPJS/dkLwUYWcbwS0K2/Dv/ZikZRXc4+x4rtJmHI9NgiGj3anb9CpSaI3c0UJkjyVAbAQfS4M06TRwhtVDkzR8Rsh9KDkBH7zE+qfzLNqXGJYnigncOeGw4Sj4w7LwfE+RrJIhr4hEJBFu92FfdpduiWgLqT/vuNXzxoHCAjpnRkig6n8fIFqmQ24fQ4bIPKAnw9UxA2Kzu2hVnAzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.243) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFIaAS9zM/R+yLKoKtxxd6WZ82LJGPBGZBlcW1N6zHU=;
 b=3p3uZBGwAqoWIz8HBEDHhXcPS24keKYn+sxxzveFptZ5fK1ZbW5Oj5sJtXuGeOkbEEThDYRTPXjyjLRkdPW2aYXUHgdqGTCMszpK1j7GJz+7CqQbY1TgU2d/+o0fSEf21DdFiy2VvWnsL2rAFgKgRmIjLiQeCeSWHXFM8pce18Y=
Received: from DM5PR07CA0063.namprd07.prod.outlook.com (2603:10b6:4:ad::28) by
 BY5PR07MB7313.namprd07.prod.outlook.com (2603:10b6:a03:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.16; Tue, 26 Nov
 2019 09:09:51 +0000
Received: from DM6NAM12FT019.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe59::206) by DM5PR07CA0063.outlook.office365.com
 (2603:10b6:4:ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.21 via Frontend
 Transport; Tue, 26 Nov 2019 09:09:50 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.243 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.243; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 DM6NAM12FT019.mail.protection.outlook.com (10.13.178.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18 via Frontend Transport; Tue, 26 Nov 2019 09:09:49 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id xAQ99hr8244616
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 01:09:45 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 26 Nov 2019 10:09:43 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 26 Nov 2019 10:09:43 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99gPt103050;
        Tue, 26 Nov 2019 09:09:42 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <antoine.tenart@bootlin.com>
CC:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH 1/3] net: macb: fix for fixed-link mode
Date:   Tue, 26 Nov 2019 09:09:40 +0000
Message-ID: <1574759380-102986-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1574759354-102696-1-git-send-email-mparab@cadence.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(136003)(36092001)(199004)(189003)(2906002)(81156014)(316002)(7696005)(86362001)(26005)(47776003)(48376002)(8936002)(8676002)(81166006)(16586007)(356004)(186003)(53416004)(70206006)(70586007)(305945005)(5024004)(50466002)(107886003)(426003)(446003)(2616005)(7126003)(11346002)(336012)(50226002)(5660300002)(4326008)(76176011)(478600001)(110136005)(36756003)(54906003)(106002)(36906005)(51416003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR07MB7313;H:wcmailrelayl01.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:ErrorRetry;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41686ef5-09ab-4b1a-db14-08d7725063d3
X-MS-TrafficTypeDiagnostic: BY5PR07MB7313:
X-Microsoft-Antispam-PRVS: <BY5PR07MB7313277593E7F2418B4EEB54D3450@BY5PR07MB7313.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0233768B38
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqELZ0GKchYvGoTRhcjMjCjIzHmIAZBe5prfL7yg9zrjsWhrO0RtkI5WPWwv0w1bDMDdVznnJ/2Lso2+IHYap7vvdFnjDxcMfcp4XP4LZ1Znf1Id7hQ3yZiS7Pjjo0AqXcd7DSbjWgxK0YCSyFrZ1TkJaPLH7QrcoX7C1St6dbcXcssZV3H2eGLAYv30tixldrh3tUau8W4Iglu4YVgOMfMaBsuHjBHF88MjbeO+P+SwnUXCA3A8tG7cjRQ7F1QQ/WUkolzU/9I0IF3WxJ3KUNBUvfjN3ruQijG92/ft9H6yYkpYGk5LK1d4JHZob/WLWsUDX3Zb1wgGC7a4/m3ShjXWPfy49jD700kMLR6onJnmbCWASZLgISorkz6IRd7Ps87VIlPGdwEM4HO5UWbymtXEVI1BQZNeofEQB7atX1+JSNGtyO5Ioc+X9NxsVQMQN6g4o9hR5xNFanHGgmOtAA==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 09:09:49.2897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41686ef5-09ab-4b1a-db14-08d7725063d3
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR07MB7313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_01:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 spamscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911260083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix the issue with fixed link mode in macb.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d5ae2e1e0b0e..5e6d27d33d43 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -617,15 +617,11 @@ static int macb_phylink_connect(struct macb *bp)
 	struct phy_device *phydev;
 	int ret;
 
-	if (bp->pdev->dev.of_node &&
-	    of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {
+	if (bp->pdev->dev.of_node)
 		ret = phylink_of_phy_connect(bp->phylink, bp->pdev->dev.of_node,
 					     0);
-		if (ret) {
-			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
-			return ret;
-		}
-	} else {
+
+	if ((!bp->pdev->dev.of_node || ret == -ENODEV) && bp->mii_bus) {
 		phydev = phy_find_first(bp->mii_bus);
 		if (!phydev) {
 			netdev_err(dev, "no PHY found\n");
@@ -635,7 +631,7 @@ static int macb_phylink_connect(struct macb *bp)
 		/* attach the mac to the phy */
 		ret = phylink_connect_phy(bp->phylink, phydev);
 		if (ret) {
-			netdev_err(dev, "Could not attach to PHY (%d)\n", ret);
+			netdev_err(dev, "Could not attach to PHY\n");
 			return ret;
 		}
 	}
-- 
2.17.1

