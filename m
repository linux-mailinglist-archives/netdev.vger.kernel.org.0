Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A5B136DF7
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgAJN0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:26:09 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:47456 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727553AbgAJN0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 08:26:08 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00AD6eEK019160;
        Fri, 10 Jan 2020 05:25:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=kJKBnH5ilFPBKkf1kjtm5U8yVUmzHj5VuGhVGOYyVVI=;
 b=jigIi9HggT7zrDTwcjGotkp/cFPVxkqqzIaVj+Lf6ZBHaS481CIuIf/svUaQPBjA97u8
 nAp3IduOyp3i8+RdyZe2M+kg3SY1ujwG/TlefeR8w0LY0xCQ86WughMsFPZNtv84fYJf
 WtOi6iXrJ4wj+06ZjFn/kCS5U097Kt4QiSFGjvBlKQj7NOSRij2Zp6kE30/EEGkWBGrc
 K5x2/fh77ORoExH8tQW3/hcQbIeqPv7jOLCZWDM44asBOCMqFCnukoKq8YyUGEcD4zz+
 XXbneyxotvHW7OB+pq92cWRY9767mfODbnvTozs95b45pywHl1/iCtGRRmglDydkEos+ Zw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2xar525f8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jan 2020 05:25:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTK75NKhvFmASUYsKKrFeSnwIApQ0kHIndy5IRWP9k5kJB2uVSVewnhSnnmmPzU4fUlkzSt8zyr/7r0QQVcnjPm9OD5U22qDb9vAU2QbfQvMs2y8mJxTn5XoCv7W2Zy9MM9z4ym66TgN00njesaoR8zsX7cCTlzZiP/q5PBwMf3vkoLP0zm//tOC1Ff53shJkldIPlZlZXKxz+MiTvIUb4wTxjgtrLO4T65rg6Kot8eeyhmfj6v8x1wT13tsVp9PPZMoS22h46QqndbidoeYmFNGDgL8ERnd0fGaPFV6BYPegFoKWighXTPtPRqpnbE/MoDzOThHZ5c+gbJi8kfoAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJKBnH5ilFPBKkf1kjtm5U8yVUmzHj5VuGhVGOYyVVI=;
 b=V9ItBnddO1UJSOr5G/9FfpyvuxnlXhVE9uRntrgWeqYtOEYGhqBxXI5kxjoLumLo6Bc4pidBc16DXJcYqiGhiU2SM+XZmgQ99ruy2eG+V9khv9FzBXOQmBm5cM132aRsv0VET+b0pC/pg2fK/SzUfnpxndh03gSFL7aKOQ7eZhiABBSC9AEGljJgQfyk0Zjn4IWCsoo6YM0aWFW8uFOfqpiBPr5ON8eBSl1TUb65b9E1FoJuMQdoZGoBlqoALXncyxohWKc+1Sz/Zow6xaPIuuz6xvewWJgmQNLmIC3WOd1je717NEC0/cajZTt8/vyGvkqUyUtdwOutCR+xggpKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJKBnH5ilFPBKkf1kjtm5U8yVUmzHj5VuGhVGOYyVVI=;
 b=3MDfc9wQiYiLD1LydIYx/Ezo+cvj5ZzrBjCRrFfzfhOBqkw0z8QUn9+wLieDOOi7Us8rHz7Ztjepog+yoCasSMg8F7wm9AozfaLkkbMWnbyXh11yj1rXXSJC0qZgJz3jgY4pn6f3N03GZxGq06pdr/Xpno5zqoehzph0qwEtMWU=
Received: from CY1PR07CA0013.namprd07.prod.outlook.com
 (2a01:111:e400:c60a::23) by DM6PR07MB6313.namprd07.prod.outlook.com
 (2603:10b6:5:152::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.11; Fri, 10 Jan
 2020 13:25:43 +0000
Received: from MW2NAM12FT067.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::200) by CY1PR07CA0013.outlook.office365.com
 (2a01:111:e400:c60a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Fri, 10 Jan 2020 13:25:43 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.28; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 MW2NAM12FT067.mail.protection.outlook.com (10.13.181.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.6 via Frontend Transport; Fri, 10 Jan 2020 13:25:43 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 00ADPbKe021781
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 10 Jan 2020 05:25:39 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 10 Jan 2020 14:25:37 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 10 Jan 2020 14:25:36 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id 00ADPVXY041466;
        Fri, 10 Jan 2020 13:25:31 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.ferre@microchip.com>, <jakub.kicinski@netronome.com>,
        <andrew@lunn.ch>, <antoine.tenart@bootlin.com>,
        <rmk+kernel@armlinux.org.uk>
CC:     <Claudiu.Beznea@microchip.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH v2 net] net: macb: fix for fixed-link mode
Date:   Fri, 10 Jan 2020 13:25:27 +0000
Message-ID: <1578662727-41429-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(346002)(136003)(189003)(199004)(36092001)(6666004)(356004)(8676002)(26826003)(246002)(2616005)(70206006)(186003)(7696005)(7126003)(26005)(5660300002)(478600001)(7636002)(86362001)(70586007)(36756003)(316002)(7416002)(426003)(336012)(2906002)(54906003)(107886003)(4326008)(8936002)(110136005)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6313;H:sjmaillnx2.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:corp.Cadence.COM;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 718644d1-c45e-47d2-d32a-08d795d097f5
X-MS-TrafficTypeDiagnostic: DM6PR07MB6313:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6313E61E9108110C69F64CE7D3380@DM6PR07MB6313.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 02788FF38E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEaUuZfDZc/kNpyWpDEQDqLADUkZ5ekuwq9bsBw9g/7pjD9bxHD62OYUjNkFNly6k0oFchMb3S5PT+JrykK4ARlcyni8h3WKjkVXxOm05SVQSvQ1drft03OdXSmdjJGbb7U2paz4ENq2u7L6C9+lT6i8+ca/yeztHtW/JqSON/XP5GMfcf6PAP2opF3wBh4GHuIS/6DDh3WB23ym/opQnxFqHfDCv2Phe2Q3d7Zn9sB6NmeJrJHkFy2WkMON7ZepYLYWvMAuRHySRxBDzFIij5aW9fxURJ0zVuRz20xKU+oHJ+xVLFM4jbABffnUwO29lWDB3QJlwfKo8HHraU7ptOJ3YRJ/HtvGXh4iHcGYNdH3Q3tbi/d5RPFSwtxC81ObAFas9Aouz2iNB3ibMadz0rc9Zi4udWlyTopJDqRCQt9O6U6bqeykWZjCSFHZ4OSSxrfMs76og3RncBD6wYfqohjaEC+rCTILJxf6YfRYMkCpA8/yWRiP82BHS0jfDKfDrK6lMkSw7wc0JZUGB6yPIw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2020 13:25:43.0820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 718644d1-c45e-47d2-d32a-08d795d097f5
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6313
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 mlxlogscore=945 priorityscore=1501 impostorscore=0
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001100114
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

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Signed-off-by: Milind Parab <mparab@cadence.com>
---
Changes in v2:
1. Code refactoring to remove extra if condition
---
 drivers/net/ethernet/cadence/macb_main.c | 30 ++++++++++++++----------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c5ee363ca5dc..f8fd45d69e9a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -611,21 +611,24 @@ static const struct phylink_mac_ops macb_phylink_ops = {
 	.mac_link_up = macb_mac_link_up,
 };
 
+static bool macb_phy_handle_exists(struct device_node *dn)
+{
+	dn = of_parse_phandle(dn, "phy-handle", 0);
+	of_node_put(dn);
+	return dn != NULL;
+}
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
@@ -634,10 +637,11 @@ static int macb_phylink_connect(struct macb *bp)
 
 		/* attach the mac to the phy */
 		ret = phylink_connect_phy(bp->phylink, phydev);
-		if (ret) {
-			netdev_err(dev, "Could not attach to PHY (%d)\n", ret);
-			return ret;
-		}
+	}
+
+	if (ret) {
+		netdev_err(dev, "Could not attach PHY (%d)\n", ret);
+		return ret;
 	}
 
 	phylink_start(bp->phylink);
-- 
2.17.1

