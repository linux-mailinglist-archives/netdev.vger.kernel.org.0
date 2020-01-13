Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CDB1389BD
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 04:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbgAMDbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 22:31:16 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:45306 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732961AbgAMDbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 22:31:16 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00D3U0Fu007514;
        Sun, 12 Jan 2020 19:30:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=rhPR+4mkELiEcoJKlE92xREatymPhp0CrVk12t/4yjw=;
 b=Cd7mm+5xy7gz2Jcq+MBuB7eVhHDS2VR2BbMRAgxnWuTjZKIQpawpuwAK3ri4T9cGvEiC
 UsP4tTX+x0oIpOxc2fOoESWE5lzcoJaqjvNB708AqJVVSF6jdO4RUWe0Z14m0rxUjjzS
 Tv6isv/wJSjHa/GsFv3PIvcAOQ+BUPpk9O9sJJajiuE/Vg6EUgxfn5dCarJx5Ac8gnWR
 eKohOcIHEm154vaHIHk7TRMObGq+OYRYz5yWy4kRtQOrBGYPVSsU8QkjHcnITBAV3E1j
 UNmNZv0kE3DMAuhKjqCPTOQxmAWvAcAK5k9nBp6hHTceZ24ikDvmEMHnGHpUpg+XMnxQ mg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2xfau2c68j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Jan 2020 19:30:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsGNtiWE7uhKbBo2kW/evY6I9CUWa3UiTG3o3uuQxuSfZ53S1XCZhlV58J21q5wMUwnUJ5d0emQ9PQPpLWc0fHdLb1LIS0Rism8FJcysWiewkdmQa2k3Ykv/Yf0umiQmqIITJGQnjarsMYobihvcqHJKfpQsD/f+XB+3kKGcOwtzD4EtjAW+I0gU81TnTaUsFUkJdBj8rxXopFA7rmqsTCke7DzgmOHyd31CKg75KVqYjlc9bhu/FyUBVFRBcHnlIEUm0HKifY4aqJaBIcP1vQalkLBXxMLN8+cSpulEIYw7tjUUao8DpgkG3mFvThmOFgUwRkEYSKmvHrN17Nqhzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhPR+4mkELiEcoJKlE92xREatymPhp0CrVk12t/4yjw=;
 b=Pfh2b+OuBPpoHHT39IQsjJ/ajZsTc93mXBDenwpfFevnxAfnAjsuIubOZMYlpjMC6z5dlIB5wUOj/S2Q6nuuJzYhqhNZHRiVw+Cqv0JcUW8/hr0YiUI/YrAOMpOABEJpiRZgDFIbG18YResBceqsSy5irbfr8gDGByY4MimX/K64F4q2JGfJvwIwSoU5lsCn6N4j4CkRe9N1ySBouoBEVHETMhLn11hh4sallFOmv7+lREVRp+xD/XalDlyCfUBhm5Hh3e5ecOYghIRMM2gEBD0uJscspsLmxCbncpLStkcuHyQgNcexp8mIgpzVdB6Xse4/9D5a4zfrRKXKXvDtpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhPR+4mkELiEcoJKlE92xREatymPhp0CrVk12t/4yjw=;
 b=1ykFJ2Fu2p9rbkVHVdi/yZC+45pNuYXZBSNpyoQGVNl9UZRwwMGurj3YRb8cKBvMkuWjn2nayfRrrSHQQWdv5qT3g85GSjqj3oZyo42B2gB/j1YtZ+Y9TXBzBV7h8i+s/DBFuj65zVbvdOrGPq24VmP2PfxYBqtfxns5r8//hdw=
Received: from DM5PR07CA0100.namprd07.prod.outlook.com (2603:10b6:4:ae::29) by
 DM6PR07MB6716.namprd07.prod.outlook.com (2603:10b6:5:1c9::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 03:30:54 +0000
Received: from BN8NAM12FT065.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::203) by DM5PR07CA0100.outlook.office365.com
 (2603:10b6:4:ae::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.13 via Frontend
 Transport; Mon, 13 Jan 2020 03:30:54 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.28; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BN8NAM12FT065.mail.protection.outlook.com (10.13.182.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.6 via Frontend Transport; Mon, 13 Jan 2020 03:30:53 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 00D3UjUm026667
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 12 Jan 2020 22:30:47 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 13 Jan 2020 04:30:45 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 13 Jan 2020 04:30:45 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id 00D3Uiv0043995;
        Mon, 13 Jan 2020 03:30:44 GMT
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
Subject: [PATCH v3 net] net: macb: fix for fixed-link mode
Date:   Mon, 13 Jan 2020 03:30:43 +0000
Message-ID: <1578886243-43953-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39850400004)(376002)(189003)(199004)(36092001)(7696005)(7416002)(4326008)(356004)(7126003)(86362001)(5660300002)(2616005)(36756003)(8936002)(478600001)(8676002)(81156014)(26826003)(107886003)(54906003)(110136005)(81166006)(316002)(2906002)(26005)(426003)(336012)(186003)(70586007)(70206006)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6716;H:rmmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76d29732-3ddf-4aea-677a-08d797d8feb6
X-MS-TrafficTypeDiagnostic: DM6PR07MB6716:
X-Microsoft-Antispam-PRVS: <DM6PR07MB67166F408226A883E095FE7BD3350@DM6PR07MB6716.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 028166BF91
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sx69ETMTZ5hA21N7i4HM2pA1RKh1V38vVqFFm4ATk0zZTBUFW7KjVQrH2u8ZUurfPEB1BgzgqeKAzqqnxuCGfhxFpNv5VoQsU3N5elj8zsWiXsuTpDItdTHiNEsC8oWLOb2lLI5bvdt+3uNpkhM+V9uDGDZADt6rrWFJW6YV4wl69Q5+oHfNgouk48kjU8sOIHxTrbz+8Oy6IwW0+KdwYYV62erwA8FvTWtJU/7cK3kssKAvCysLbgXQmJ3lSj4ig/CCo2Gmzyu02gzbsdRGSH7eqxxtOuWGkQbaPEupASgJdtY9n1TILIBOJaNZemQW+SxZdggV/F5KajlCGp3zJunaDTtZerLtJDhtqAYaa2jHRHEwtkhcjuJPqePO6C8h1mNIMoNEqLsAXR3CCeWhzMOcusttoEb4qPqyG8PjXZAzUjboTiQg33m39tsxJiVJwjYfKcKLADmC0G8Wrrf1fWbGN/LJhArQR4cuVkVdv80FufMNWe0IWEo3BZzLQM1qB3emFTf0iA5x7kQazN6fig==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2020 03:30:53.8011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76d29732-3ddf-4aea-677a-08d797d8feb6
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6716
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-12_11:2020-01-10,2020-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130026
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

