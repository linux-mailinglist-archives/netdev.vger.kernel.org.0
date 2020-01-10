Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2381366E8
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgAJFrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:47:16 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:15254 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726096AbgAJFrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:47:16 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A5j8YC024945;
        Thu, 9 Jan 2020 21:46:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=6U2c6SnSlFzqeZNcdh/KyvhOlqVD+wwFY6k+5V+kUMI=;
 b=gRyVU+NQ22/VckYqzO+iOC6L+Ng5tTdszUfMk7YiUmUe8SF6Z4T82tOo70S6zFzVyRTT
 Yts5l2+dF2+3iEXo1FQYda+rP6ibt0B2y9vrCghJBKxnu4DfBud3/K16IGHopFzRulTM
 cZ8d+imIyfV1uYZz5sYeuGHBr62sfv6w0uUcAs0b91f8Ox3w4RU5h7yZyAeOUx25h7Fe
 M64KwAjmhYE9EJ+59Xs2qf60t0NF6RoYLr+SAJC1D1AF9JvHARC8zjWDmsD7U+XVO6Vz
 x0kifFD4lUNuTXvasauGOhWw8dONf0V/u5EWim5ISlRs5TIdXaLbG3CsTL5W6LFok0gx DA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2xaq624pfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jan 2020 21:46:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyivsWRfqwNtWBY03Miw6/XPW5ed/GwrGIFzG31MexeGmOJ4mbkjMVfT86X3D6RqR30kLn1V5I7erxkMxpSIKTdl97SUkdbkfmCdWAuA8TpMrMPSdqhXSynBca6cq28G4TqGWPTgBe2iX0LNgibmSDtKH1ToL7/IQqySWfPsL3XZ7MvnX+ra5UDcOl29/CYQPFcd0y1esQ2oErN4Y5EUM4vhrbXQ5NBjIBUMM4PDZdRHGDGqUFdBv+bQ9v40wauaEoDakDQdXrVHatWURYz/yZlMea32Xh/UAebY3czfGf8xcxD8JISyG7xDFhifPd3PHSb7zvfkoG5Nf8eZqyvaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6U2c6SnSlFzqeZNcdh/KyvhOlqVD+wwFY6k+5V+kUMI=;
 b=ac904pjg6MZFtGDfPJfmwNigSBRyfv+46Jb4ARje5583s0xnrfFtutMZ52SL86QxykFYNF9Td2J1aomcePASfYdIkjOsJ0VZxbrQ+hgdI2bFV16iWqONuH1tDP9gkN/FFHBEDdtwNqQjzzBjbSKY0o/IsAVg2TIKMgzhMTpEcWDH/kvcZPhxuNuu77k8/eGIORbHbIkD6ZXlTAsOpKh0h/uf+kHIN/q0LvWdDSHQRuprRz8t/DWsJzBftPSAh8hoLwL9TzDLEO3l3Ra6j6CmiycJLwAf+2pRid/nlo3om7yRytNOnYzJ7X/dL7B2hv0aV4m3JHQsBNI4jDuUzl2xxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6U2c6SnSlFzqeZNcdh/KyvhOlqVD+wwFY6k+5V+kUMI=;
 b=CQjSrsrl50AvXDqUT7Tn/i+QL2HXwJbDTBWAul9KMT7f+7SiKxXx6HNnHf70HdCGiKAYAQVoZ0jnT9WB6Fc/GSpfiCEjptgRg5LMtHns04NcyEOgKy86KFVgRbd0kvKxH9jvWjH3+Y8B2XvUvgKdLNoz9Kd79ln8MKQAxe8yPkA=
Received: from BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18)
 by DM6PR07MB6604.namprd07.prod.outlook.com (2603:10b6:5:1c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10; Fri, 10 Jan
 2020 05:46:41 +0000
Received: from BN8NAM12FT026.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::200) by BYAPR07CA0077.outlook.office365.com
 (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Fri, 10 Jan 2020 05:46:41 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.28; helo=sjmaillnx2.cadence.com;
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 BN8NAM12FT026.mail.protection.outlook.com (10.13.182.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.6 via Frontend Transport; Fri, 10 Jan 2020 05:46:40 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 00A5kVEp006998
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 9 Jan 2020 21:46:33 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 10 Jan 2020 06:46:31 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 10 Jan 2020 06:46:31 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id 00A5kO5h030587;
        Fri, 10 Jan 2020 05:46:25 GMT
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
Subject: [PATCH net] net: macb: fix for fixed-link mode
Date:   Fri, 10 Jan 2020 05:46:23 +0000
Message-ID: <1578635183-30482-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(36092001)(26826003)(7696005)(426003)(110136005)(54906003)(7416002)(478600001)(2616005)(8936002)(7126003)(316002)(336012)(5660300002)(36756003)(8676002)(2906002)(4326008)(86362001)(107886003)(7636002)(26005)(186003)(356004)(70206006)(246002)(70586007)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6604;H:sjmaillnx2.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 759a1bab-f08d-4f96-f66f-08d795907778
X-MS-TrafficTypeDiagnostic: DM6PR07MB6604:
X-Microsoft-Antispam-PRVS: <DM6PR07MB66040C00EAC32765FC51530AD3380@DM6PR07MB6604.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 02788FF38E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ahVfLEpyY6oqdjn+y4QuKXTGbXM0LW/nZFlhN6u9UvIR7xNwanwnn1cU6udWxek+epeu/4seFt/D0SYrr7LY6umFuABduX+hCu03vKmvbmyV6U04aJ97REwOW14ZDHpjyh7fOYlV1DEvJ1cCzCE2sRxMkTJOAT2XW82lshw/IIc0omOhPNaMgX8Iolh5AymosaCcjaFlYtZjef9CV9Zf1qh88apGUZa/aqlEEgrFw8iPHwZO3VhJJLMNQGVVa01rVeYf2fE7Dr1hsF5aQAuSfXyGl0L3bS+TjR0/gYjMTozELpSmloHrAYaFq3P+wL0TNU372cu20Xs2LB6b9Mhb6Nus/lUoXFGjnIf2hXY3SsSxoI0s7d7+6szmdEnkcWXsLpLABwoGTML30IAnx31Nz5PHVssr+8wxM0QaeFiPU7S7BrhhkcEO0c7NUmOwB9fG4OHkwcSSMM1V/TF0SF9xeK+/sZ8VWumrZ6FOORpax8BqCX03WkfMLHWZhEJCL3mHxP0iMtn3fZD4QrXJztAPw==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2020 05:46:40.7068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 759a1bab-f08d-4f96-f66f-08d795907778
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6604
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=923
 impostorscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100048
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
 drivers/net/ethernet/cadence/macb_main.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c5ee363ca5dc..41c485485619 100644
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
@@ -638,6 +641,9 @@ static int macb_phylink_connect(struct macb *bp)
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

