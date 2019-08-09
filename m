Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352FF87B70
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406474AbfHINgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:15 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:57860 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406412AbfHINgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:14 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMwcZ000752;
        Fri, 9 Aug 2019 09:36:07 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2059.outbound.protection.outlook.com [104.47.41.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u8bmpn4hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdFdSYXc/BxbI7N0A2PE/ViRe8kX1wqOjnV4CSYSmjLH/Alw/eC7phNcD5Z7P2jm+RiKqS37yl1XMhBnrB4LA8HS/vMpIA5qScRcxivirztj1vSXnTixsRezI8y/f8XkJ1Wv6UPYZvczzTirJEvEAbtsE1qd9o6uXRBmO1FPFMOwMCrzRRZ2oSJC+WpWhIm7AE+DU+dag6YUCLjpEnsf7h56TSJkAM7zOf5P464M9nJedOaTTuBgrrT+TRDSOvgdi9cu8PqOqnGmqlrSjkrLTRXctjYm7PBYwislrsbQl84nMuzNXRD4bHHBm9QD3efa+PxMZD/Dg4J4jjvbeG2uXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmEY4zNFlwE4v4nX36Fq+XZBsh2MT3fqu10Nta8vl0M=;
 b=I8sNCEWpynPDrgS4U9jo5JyY2hMb8auihP/tUs6vJBIH+L9BnVSapScUC6tB9q6N/q8ShZKD2dH2v1zx0LgZ871V4jBg3TXgo/f0SQBjn0C1LCL/bfZ5lNAbRXY201J78+lEa4UiIyEYsqTOLNW5RoiH4zqDfs4CMQIrn7bUrzdY166uSumNGCFSVUUSHVG+jr3PQ6Jjuwy6ZP1jp1GUpHo5HeTZVKSi4Hi3A9IlTrzc91m8jQd/VK1SmwgRJDrvBO5wA0KZVI/3OyyWB0Y0tbfm3iq2P4WgXX0esCFpqOV/HcVr85vDIXLjehF79JQowmuTIDDifxa14Swt+fFsVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmEY4zNFlwE4v4nX36Fq+XZBsh2MT3fqu10Nta8vl0M=;
 b=Ydl3Km/HqSSqx3I132pncRhscJud4oQvHBtkNadTsdbpxZNxaXJzqXcm5t8aPU1uAi/a8uX7N5o/STFZoLigqIBlbO+TWrTVqzMuzFB9AyfBIKF/zlii7ZrGXVZiQpS0BV1xVjLj08/0xcOWW6ZcTd3CXEWGW5toP6xI32pgUFg=
Received: from MWHPR03CA0053.namprd03.prod.outlook.com (2603:10b6:301:3b::42)
 by DM5PR03MB2489.namprd03.prod.outlook.com (2603:10b6:3:6d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 13:36:04 +0000
Received: from CY1NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by MWHPR03CA0053.outlook.office365.com
 (2603:10b6:301:3b::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:04 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT032.mail.protection.outlook.com (10.152.75.184) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:03 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79Da3nO025644
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:03 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:02 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 03/14] net: phy: adin: add support for interrupts
Date:   Fri, 9 Aug 2019 16:35:41 +0300
Message-ID: <20190809133552.21597-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(39850400004)(2980300002)(189003)(199004)(305945005)(7636002)(107886003)(4326008)(2870700001)(48376002)(2906002)(50466002)(126002)(8936002)(44832011)(50226002)(486006)(47776003)(8676002)(246002)(14444005)(36756003)(316002)(478600001)(426003)(26005)(110136005)(70206006)(70586007)(51416003)(76176011)(7696005)(2616005)(1076003)(2201001)(86362001)(336012)(5660300002)(106002)(11346002)(446003)(186003)(476003)(54906003)(6666004)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB2489;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c31306e-60af-4014-de22-08d71cce868a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM5PR03MB2489;
X-MS-TrafficTypeDiagnostic: DM5PR03MB2489:
X-Microsoft-Antispam-PRVS: <DM5PR03MB24898168A6571F137DCBE308F9D60@DM5PR03MB2489.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: GxRbfMC0eKmS7/Qnofi9vQ3SBexzo3ydcErFqmISJ41LliyWfIMWVOAC+wsy/Ub1RDbIFsTC7t+naViQ2aG1/Gwi3lvufxGIY8XGeI0rbQEp1HhBTHs8oSZxP4PR/n1DyFxBgh2vAN0AURtrXuE9UOjO+W4ksWiR0UPD6QmzI5p/F+Rk8bztXz01LAtFlEK/UuncVe0SqRh2BU8Q89ajh3w72lBqb8JuW9UgM93YBWJwA0QFkOLhHCJI972qlde6VXWLiaBLYlgXWXWk0pViZr80OqybqKzf3+KkShe+rFZa2lLy0Ho3gxKKWCgQo9dHceFaKMUQKxzuWJX1mY3kq+KrzJZP/JFfr1KIfyYHXgUM42kjGZhhSfLVijPBZTAJ0l2y2Ymhjup8j8EjHBqfl0SPXfBjuf/rp46Ge0rNHkw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:03.6508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c31306e-60af-4014-de22-08d71cce868a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB2489
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for enabling PHY interrupts that can be used by
the PHY framework to get signal for link/speed/auto-negotiation changes.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index fc0148ba4b94..91ff26d08fd5 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,11 +14,45 @@
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
 
+#define ADIN1300_INT_MASK_REG			0x0018
+#define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
+#define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
+#define   ADIN1300_INT_ANEG_PAGE_RX_EN		BIT(6)
+#define   ADIN1300_INT_IDLE_ERR_CNT_EN		BIT(5)
+#define   ADIN1300_INT_MAC_FIFO_OU_EN		BIT(4)
+#define   ADIN1300_INT_RX_STAT_CHNG_EN		BIT(3)
+#define   ADIN1300_INT_LINK_STAT_CHNG_EN	BIT(2)
+#define   ADIN1300_INT_SPEED_CHNG_EN		BIT(1)
+#define   ADIN1300_INT_HW_IRQ_EN		BIT(0)
+#define ADIN1300_INT_MASK_EN	\
+	(ADIN1300_INT_ANEG_STAT_CHNG_EN | ADIN1300_INT_ANEG_PAGE_RX_EN | \
+	 ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_SPEED_CHNG_EN | \
+	 ADIN1300_INT_HW_IRQ_EN)
+#define ADIN1300_INT_STATUS_REG			0x0019
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	return genphy_config_init(phydev);
 }
 
+static int adin_phy_ack_intr(struct phy_device *phydev)
+{
+	/* Clear pending interrupts */
+	int rc = phy_read(phydev, ADIN1300_INT_STATUS_REG);
+
+	return rc < 0 ? rc : 0;
+}
+
+static int adin_phy_config_intr(struct phy_device *phydev)
+{
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		return phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
+				    ADIN1300_INT_MASK_EN);
+
+	return phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
+			      ADIN1300_INT_MASK_EN);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
@@ -26,6 +60,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
@@ -35,6 +71,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
-- 
2.20.1

