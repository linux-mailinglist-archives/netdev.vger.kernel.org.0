Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC910116C16
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfLILOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:14:51 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:55352 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbfLILOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:14:50 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9B5kfp030482;
        Mon, 9 Dec 2019 03:14:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=BXhnLcZxt92K2EkpcJZICYzz7KJI1bNBG3tZkHOctk0=;
 b=H+P8i5Vl2321M9hZ498rFVeidlvYeqpyeiIq5e5p/WZ6J1dJapg83+VDYftt7qd0/U7J
 DulnBqsGof2z75DivpoaLknkTwMtL91rN65+0R2QNpCamQstcr3PLAzuuVEzv+vRuR7O
 ZIA90xlHY5l5Lr3bRcxsCFEby42sofZiRBSNMdLqZI6LobefWtxcRrKIir6iB5bbtcIG
 9TDNPVNHdZyjYB3ztt7+HdgaEh4ulUSFLn2A/ZNfJ5CewQ72PInhXBQddvZpsGImFmYo
 EMm0VFvdybQE1XEONQQ8UB1HlfFJ78LgU8mv8/mnV3lqx464cNYyDHV5mlI7fa/KDONO Zg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfdc0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 03:14:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BScnWZOa0ESC8IDXVTRRfzszcpeTa9Pjpawyfrj0wt8Eb+/FEtN9DIPXlX26hpP2fAtmij8ZHIr64iN52ZNhJ3dkiONVUWSrqfrT5l+SCHS07/M4Aj93mtw88LkRz9XDcZL0GL3OPhvCVgFzfqY3s9hu6nEO7fStP+uSe8/0KTjNbHUHdEmFs6gljCTfs7k31ifANJx19WhNEXnF2jvIqFiBycKZYSEvFsMZFMB/FLpGHkudiNOO9JEcEYV226FYKol+f/BzLZhysFqkKQiKzGuNAoJRUZBlSHLP1SQsJmlYvWlXFYLj3gfhgJvkv8BOSDabjB5r5pAe+0xcLNQUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXhnLcZxt92K2EkpcJZICYzz7KJI1bNBG3tZkHOctk0=;
 b=mIg/08yt+jKbPBva2N19HDkeIA3haz3NgPvIxuvNE9PIFqIIBuBBFaLorJrY1DE4y9RB4Rn0FE7BykR7cBY99Fw+tkKF5ed/8CJrQH3Eif7n22+lwQoeZtbvr8cfVSzYYXIzf2fqCjoCQCt/5IKy8rEiRBcJU9eJLWoPgby/cFUXOckf6TOYZfOBbhbSQvzJWWTeKByyx5L4nG05o5fYOl5wUUn7hpb+HJGMpC3cj5lT5n7FqAzG2QuWYq2KF7w/Vz1LxSs33GvaFJ6fBDpF+iU2HZ3lGzPLkYdtRKZFl6STWJPSJ4r767/bhhDSEAuaGj0wAzj9dtGj3VpHXtevLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.243) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXhnLcZxt92K2EkpcJZICYzz7KJI1bNBG3tZkHOctk0=;
 b=PlCFfg6MDGythwO98Yo/ySMAJD0+5rSJFDDQPLCT1WryIh9AnyeIx9bwxKDSqV+OYzyiXg/g5HVwYRaYVBqs2fMS7i4OqjdfM5SADyw4MQoeR1MDTFr7zTTarDDXY5hChvUI9H/yLv+Bh+pDUXNzGy8tGC+Owb+U+ytEBZqvd8I=
Received: from DM5PR07CA0053.namprd07.prod.outlook.com (2603:10b6:4:ad::18) by
 BN7PR07MB4257.namprd07.prod.outlook.com (2603:10b6:406:b5::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Mon, 9 Dec 2019 11:14:33 +0000
Received: from BN8NAM12FT003.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::207) by DM5PR07CA0053.outlook.office365.com
 (2603:10b6:4:ad::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.14 via Frontend
 Transport; Mon, 9 Dec 2019 11:14:33 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.243 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.243; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 BN8NAM12FT003.mail.protection.outlook.com (10.13.182.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 11:14:31 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id xB9BENK1031311
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Mon, 9 Dec 2019 03:14:24 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 9 Dec 2019 12:14:22 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 9 Dec 2019 12:14:22 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xB9BEM19024300;
        Mon, 9 Dec 2019 11:14:22 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <rmk+kernel@armlinux.org.uk>,
        <pthombar@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 1/3] net: macb: fix for fixed-link mode
Date:   Mon, 9 Dec 2019 11:14:21 +0000
Message-ID: <1575890061-24250-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1575890033-23846-1-git-send-email-mparab@cadence.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(36092001)(7696005)(70206006)(5660300002)(110136005)(54906003)(478600001)(36906005)(70586007)(316002)(86362001)(7416002)(305945005)(4326008)(426003)(336012)(186003)(2616005)(26005)(7126003)(107886003)(2906002)(8936002)(36756003)(8676002)(356004)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR07MB4257;H:wcmailrelayl01.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:ErrorRetry;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48bf3d5d-a446-4a56-59fa-08d77c98f6ca
X-MS-TrafficTypeDiagnostic: BN7PR07MB4257:
X-Microsoft-Antispam-PRVS: <BN7PR07MB42575A05E23F55C6E412534BD3580@BN7PR07MB4257.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u6OSOFp3lXk0k6crYVsd8GE+NT218S4Y2tDWlYPfU7xDSeJF16vPnXN1JuS7QzkkLLrmDcTn9PoFFT+OsYBN5mw8dReJC0s2PHjmlSBBpYe9RjFleblnA959ra9Gq95XMANgSop5Do080GY5G7UTLoCIOwwnWKLya3HX8C0cIqxk1W1jist7ym/OcSR2lO7m4Cfaxnp6Y22GoFASgnQl23Oco8SxvFHwhfoch4sIX3N6TI0/h3G4IwagXy/7Q8238OK/RnUoskCFn4tIhbLpBO62yiCyJmTSl1OkzRL3n3L4qIfO67t4czd7GmYdIyS6APWSUjL/VnHXyHbgOdbakCv6Xt4//+GOfWBBmwjzs3kgJjzaUMsitR3A5Ui8BEUgD8DTb4Ax599WKsYO9Jc7vwB/J8iX0eWgveCfcLjOaWy/jGLZDaoocLhXUb6UcY6IUiwnCDxXUc0s/fhC+lgTUfo8+GmSYmvZWqqJqcIbqwchoOZD3UdfHQtwW1ZGI8ld
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 11:14:31.2022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48bf3d5d-a446-4a56-59fa-08d77c98f6ca
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR07MB4257
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_02:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=937
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090095
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
 drivers/net/ethernet/cadence/macb_main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9c767ee252ac..6b68ef34ab19 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -615,17 +615,13 @@ static int macb_phylink_connect(struct macb *bp)
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
+	if (!dn || (ret && !of_parse_phandle(dn, "phy-handle", 0))) {
 		phydev = phy_find_first(bp->mii_bus);
 		if (!phydev) {
 			netdev_err(dev, "no PHY found\n");
@@ -638,6 +634,9 @@ static int macb_phylink_connect(struct macb *bp)
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

