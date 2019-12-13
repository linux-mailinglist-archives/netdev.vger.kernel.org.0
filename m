Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E35111E10A
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfLMJlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:41:39 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:16050 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbfLMJli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:41:38 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBD9eTTM009831;
        Fri, 13 Dec 2019 01:41:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=FErCI0CWPnvW0u5dE25M4F3Ih0PbFybydv+n8oBcVmA=;
 b=P327eHKMDh9VnZKB09X7oCgPrBeJlcv59nDHjJkSAJHWoPAffQ6qFl+ZZ0QmqG3XikBj
 iKWDoEFtf4KWohDRphQ/v14NXsIvOtwJ7GfM8sVe58Me+lygDdmVcyGM17N9jznOaZ2e
 zaPaREpNRmBBPJkqIbW8z5u7NI/Z2n07ry8frBQRukmWlsykdUmxU8Iuq0qyBoOuhkN8
 8FIsytK9//CWkhRHC7CxdQfgVZpkzK657DcMkChFpomtAigYGCtwhfz6hU1ROOVEUqiA
 yT8kgh3ef2BsP335bsMxCncu4KtMhHojqTUvoOi+p51Y2IF3oby2MWv6nUERSCFf5JSb 0w== 
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfx4hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 01:41:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enROoi5heeR/4LJBsVmxQfZ3XsAJ8xRBDX6TdNup6cDOwYhUA0boonIp+PcSakcpL+7qvg1uMvqkdznjLZTSxzgA29n/yviILzzbOuo1QLuM9BuSH07hRvqJUXO5+h+RKXBnNYoCtjvfNbZXqGCjVp57ZKr/KzSJA463HO0wsn8yMCblsR28tbfySgn+gjw9DrILidkOhy5g62z7CWA6Z052gApZw0QClykLA10bYClZfk2wGijOqhrBKzn9z8I+rZTtRoXZ9VI4W5D7RaLzAMKzOvtOaThuG58xCWKUurw0n4XVTvxIa9M5ZL6sGQxTFdjEmjZUPObxHUBpKh/wNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FErCI0CWPnvW0u5dE25M4F3Ih0PbFybydv+n8oBcVmA=;
 b=nkRjwNRE7iSLBiFnKVPGRIb9yHV0dDXHGafr+od6zdRRaWdX4+ywqqqYeLJSzwlhke1+EjiBiBMwi+DXiOkwxfXdkipRStdYSpl3nrQjWXCAMzunnFQ6yR2BaYrCrbTLxn/eAHaecotwq1lr6SfEZPAe0kZ817yRshtzv6ZHM1SuI8WhzmeGoFricx4WxHfumLgkWzskyNvbKtNP1OEwVr0AlI6NOk+VDNhCxNZTJ66sbFh0h7NXlKlcjQN+hfu832mipy0yLCy+m8BbEuz93AU8A1e7hu/JIOtpLeCugHQ61kok2MQ3pjIWmUQMy9Hmly9nu+YxBaGkICKnZPfEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FErCI0CWPnvW0u5dE25M4F3Ih0PbFybydv+n8oBcVmA=;
 b=GWx3S3lztqY6o3aYY1E5Ji74WMOipu5vY1orBDDKkLfCYNTZyg1qeaytFqNGmplf/XSG3ElvRkDAOTWx3e/50p10lzgWnTli6X2qDxYRGaqj89CcFl5J0Z/2bEridUtDO/6ffOWZmJSmwNdnqhNqV3NznTDjQ4QJvK1T1a6Kh34=
Received: from BYAPR07CA0088.namprd07.prod.outlook.com (2603:10b6:a03:12b::29)
 by CY4PR07MB3141.namprd07.prod.outlook.com (2603:10b6:903:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.17; Fri, 13 Dec
 2019 09:41:20 +0000
Received: from DM6NAM12FT054.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe59::202) by BYAPR07CA0088.outlook.office365.com
 (2603:10b6:a03:12b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.17 via Frontend
 Transport; Fri, 13 Dec 2019 09:41:20 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.28; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM6NAM12FT054.mail.protection.outlook.com (10.13.178.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16 via Frontend Transport; Fri, 13 Dec 2019 09:41:20 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9fFSB025963
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 13 Dec 2019 01:41:16 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 13 Dec 2019 10:41:14 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 13 Dec 2019 10:41:14 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9fE7n011298;
        Fri, 13 Dec 2019 09:41:14 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <rmk+kernel@armlinux.org.uk>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH v2 1/3] net: macb: fix for fixed-link mode
Date:   Fri, 13 Dec 2019 09:41:01 +0000
Message-ID: <1576230061-11239-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1576230007-11181-1-git-send-email-mparab@cadence.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(396003)(36092001)(199004)(189003)(7416002)(26005)(356004)(2616005)(426003)(70586007)(4326008)(70206006)(2906002)(6666004)(7636002)(107886003)(5660300002)(7126003)(336012)(246002)(110136005)(478600001)(26826003)(8676002)(86362001)(54906003)(7696005)(76130400001)(186003)(316002)(36756003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR07MB3141;H:sjmaillnx2.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c82a75d0-c237-4eec-cbc9-08d77fb09bed
X-MS-TrafficTypeDiagnostic: CY4PR07MB3141:
X-Microsoft-Antispam-PRVS: <CY4PR07MB31412FA0E56BFBE107C2BD7BD3540@CY4PR07MB3141.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0250B840C1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKB+Ry3I6GA3iA6Dc96XCxp4ENupv1zf6IfwUqd3USLk0JSiJ1vsZceHutBg1836KaSdnl4wCu7+XD6u2fH2iI78nIkaD6c9r1DiW9+uNZipIMyDhJo34cewRcYOPST/Rjm9GHIeH1UTEwh0U+jQGo1bLHDlHmCn21KPqF6kBPUAm5udXTlpCtu6YS5MIpQ955wzzoOcxoRhYb4SnJWmQ+gTE0bA5Lm4DCPpDJ8q2kWKQm6ZVC/9WvGescH6uYlmZaS3MUkIjtnkhRHHbGF1fk76RlWhVm3MFTyF2agnRPIu65uddxHCFLZm/gqmUFOPaMT8Q62QLwD02z46nv/CWSiEJOBKGPnO2npnP80qBmrYfCwBmf/mUQklLkwUHVqgcuxM869xcV+mpN92VrZbGcQnHmEHiD4xPXCzMAT1MnktJcLIhszZ6d0pppgf2+4rNaFajmhTLcQq7BZs9F3gQmc8/9tETzIqdClCG6vFRsOnIOuZK1qIe5U7PwCJi69T
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2019 09:41:20.2138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c82a75d0-c237-4eec-cbc9-08d77fb09bed
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR07MB3141
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_02:2019-12-12,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=983
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix the issue with fixed link. With fixed-link
device opening fails due to macb_phylink_connect not
handling fixed-link mode, in which case no MAC-PHY connection
is needed and phylink_connect return success (0), however
in current driver attempt is made to search and connect to
PHY even for fixed-link.

Signed-off-by: Milind Parab <mparab@cadence.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 25 +++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9c767ee252ac..8c1812f39927 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -611,21 +611,25 @@ static const struct phylink_mac_ops macb_phylink_ops = {
 	.mac_link_up = macb_mac_link_up,
 };
 
+static bool macb_phy_handle_exists(struct device_node *dn)
+{
+	dn = of_parse_phandle(dn, "phy-handle", 0);
+	of_node_put(dn);
+	return dn != NULL;
+}
+
+
 static int macb_phylink_connect(struct macb *bp)
 {
 	struct net_device *dev = bp->dev;
 	struct phy_device *phydev;
+	struct device_node *dn = bp->pdev->dev.of_node;
 	int ret;
 
-	if (bp->pdev->dev.of_node &&
-	    of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {
-		ret = phylink_of_phy_connect(bp->phylink, bp->pdev->dev.of_node,
-					     0);
-		if (ret) {
-			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
-			return ret;
-		}
-	} else {
+	if (dn)
+		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
+
+	if (!dn || (ret && !macb_phy_handle_exists(dn))) {
 		phydev = phy_find_first(bp->mii_bus);
 		if (!phydev) {
 			netdev_err(dev, "no PHY found\n");
@@ -638,6 +642,9 @@ static int macb_phylink_connect(struct macb *bp)
 			netdev_err(dev, "Could not attach to PHY (%d)\n", ret);
 			return ret;
 		}
+	} else if (ret) {
+		netdev_err(dev, "Could not attach PHY (%d)\n", ret);
+		return ret;
 	}
 
 	phylink_start(bp->phylink);
-- 
2.17.1

