Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66B1389B7
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 04:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733203AbgAMD1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 22:27:30 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:13082 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733103AbgAMD1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 22:27:30 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00D3AorD012554;
        Sun, 12 Jan 2020 19:27:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=rhPR+4mkELiEcoJKlE92xREatymPhp0CrVk12t/4yjw=;
 b=mafKBt1mWttmic34ZkpFAePGw2fyQEQTOzs9wcsigEvJqJO1bA9LelL/zVCcA2UwD3tB
 XpztLgu+IjCfreqgN23/aCyRYJBN1dSRL44vF/DYd4CKZTfOoWQZoSY/LK/Ug5uTwdmr
 dXWlC5SIvX5RLWtWZ5t43W6mcv3qtve6hgTiIcZ1eok7MI0l+nYB+b6aEz/oId6Jz+E1
 VPlp+qYYZ5l4b9f5CwZ7PuMwHtvadU8A7dMa7y71EdTEZI1wXNQ+YaojFhBa839a7ILs
 rscl7nrtSkFAeL8AKEeY829jQgM3E8S+VpkGvQb2IAk5WLHx/74NSp5kizFSyGQb07DJ UQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2xfau2c61x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Jan 2020 19:27:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUo9fFwr62OcGxmahXFfGQsuCJ/vm8TifbyzvSFvkdtu3NVI4/dSrCvmRtar1yYhgIoO/Qr+TIZVhRKb/mygybi9HRKN4k8oSyu5xSQAcYoVEbAUx6Z8G8Nv8q1GMx0FXDcm6lYx/HqT5uiMZlxK/XTWcJpTy1HuGF2CU6DUOarJ1Q129pap71ol74XT/w+dKvUx2ZDzJxL+apF2oDRvJ0y+YVbWAy8cVE9OeyhjPHVBkQzNF5aSgmNiTcdvcuS01vhKBhmzLGNJU4/tw0+z+boz7dgYODyVcFGnOcROCi7Z5lYDTjCauyZ5FQkUd6fKHIdNokqkgxzO4Qw9m1ZTwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhPR+4mkELiEcoJKlE92xREatymPhp0CrVk12t/4yjw=;
 b=hGEY0xRxhj3xnEaahd1vhOVd/o+tSvX+EUCSZZlyWvO2ZSm2cO6geaeOA7v8IpiWf+Ok20ZjOPCTG42Y5x0hr4CdaD4ew0wN8s06Zp6EiUiSlYawKy28QZ2afHky8r0bF2ksjlmN4qKd+ojwZppj11733bqkoo/4z6h669wpydciEuXcqjuwkfThpcyAQfaXvM/I4TZXPy2nQdMrV9HVJc+2Fds92hX+xjQWLcyyyAQ3iiOj45/mUpbLst/kF0stnrk4qMWabjcAJ0YM0e49FMHrldet44hU+di6IRQY2xLR2Gx3fNhTu+jMS1Mzxl4xMwvbrfPNorlqfxZD+6B1sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.243) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhPR+4mkELiEcoJKlE92xREatymPhp0CrVk12t/4yjw=;
 b=svMuTxo5dBMjE0P8J9muA0GDQReTTas6lUekiRUkOkkE3jSeYBz4sSTaipl/UoMk94OKi28wnVedj4eTOEMitFEBgSlRfJubbQaE8BjhJvA9VyovbrpDUOz6bH/2sQ72WglH/yGYq/1/pjc+cnGB5efzH6zQJkSQrTFM9zry7Yk=
Received: from CO2PR07CA0069.namprd07.prod.outlook.com (2603:10b6:100::37) by
 BN7PR07MB4897.namprd07.prod.outlook.com (2603:10b6:406:fe::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 03:27:05 +0000
Received: from MW2NAM12FT011.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::206) by CO2PR07CA0069.outlook.office365.com
 (2603:10b6:100::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend
 Transport; Mon, 13 Jan 2020 03:27:05 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.243 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.243; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 MW2NAM12FT011.mail.protection.outlook.com (10.13.180.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.6 via Frontend Transport; Mon, 13 Jan 2020 03:27:04 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 00D3R1op120842
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Sun, 12 Jan 2020 19:27:02 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 13 Jan 2020 04:26:55 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 13 Jan 2020 04:26:55 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id 00D3QnqE042253;
        Mon, 13 Jan 2020 03:26:49 GMT
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
Subject: [PATCH] net: macb: fix for fixed-link mode
Date:   Mon, 13 Jan 2020 03:26:32 +0000
Message-ID: <1578885992-42113-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(36092001)(189003)(199004)(478600001)(7126003)(426003)(70586007)(336012)(2616005)(8676002)(2906002)(7696005)(81156014)(81166006)(5660300002)(26005)(7416002)(316002)(186003)(70206006)(36756003)(110136005)(36906005)(54906003)(6666004)(356004)(8936002)(4326008)(86362001)(107886003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR07MB4897;H:wcmailrelayl01.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:unused.mynethost.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d664d226-2d2d-4389-ca7e-08d797d87649
X-MS-TrafficTypeDiagnostic: BN7PR07MB4897:
X-Microsoft-Antispam-PRVS: <BN7PR07MB489733E950593B6421F92C98D3350@BN7PR07MB4897.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 028166BF91
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GF6MX5xBd2u8HOwu7pNHLrR6CT/y/KH0j3VN13TPhhk8IExLkJDBTUx+na098agQbMs+OGKxOt5OGvJp9mhojFOElomjlrAp0JUOz1mwvzLfjcOmlB7IkCyvn+C8+YY9pVJX4Io7cdht1mJoDzwfGKOdsKR33k+u3p0HF9nkqDlgR8co83bpqzeQTcOiL6SYigN2ZX4BWUXxnE5owE0FC2U3Xqn2sHF7A0ixrkI6y+vE5QPgD5VsfQRW+a0YoB5HdjXzOo7Qz+aa0Co7eIT3U5hv5IN8+WDV6822Q//cD54+MC9jt3mMIIE6yqY4sqQGGkehvoZsOPUzniyxMbGCLsddrH751AI24nNjyXddpgbjQ2UMeFSjEa2KVeYRta8QsxkR0Aljt2XRNpROvOKnKlOP9jF0OfG7si4UTw6DXEzMkpYm0Lte84y9ptGgeTbNwFczie8RBRI9AStLRTesB4+AAQAdK9JTvqgnKbE66O4ot6wp2SB3yDwOgpeskL/HgetCWcHjq4wRBivvNS2tdA==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2020 03:27:04.8911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d664d226-2d2d-4389-ca7e-08d797d87649
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR07MB4897
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-12_11:2020-01-10,2020-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130025
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

Changes in v3:
1. Reverse christmas tree ordering of local variables
---
 drivers/net/ethernet/cadence/macb_main.c | 30 ++++++++++++++----------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1c547ee0d444..7a2fe63d1136 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -650,21 +650,24 @@ static const struct phylink_mac_ops macb_phylink_ops = {
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
+	struct device_node *dn = bp->pdev->dev.of_node;
 	struct net_device *dev = bp->dev;
 	struct phy_device *phydev;
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
@@ -673,10 +676,11 @@ static int macb_phylink_connect(struct macb *bp)
 
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

