Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6DB89CAE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfHLLZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:25:23 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:51794 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728204AbfHLLYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:16 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNWV3018760;
        Mon, 12 Aug 2019 07:24:09 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2052.outbound.protection.outlook.com [104.47.37.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w65k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdRGW+I1L3V1/LLK25XI2ffK7b/k5GdnsCWyTy5jWXq13a/AXPQXDWViKQhrARbAaJ0mIxOKNyww2MAHU0O6F1RCjV4bzkOEIiYZCSTbje014Qh0Lq+wdJF+s2RAH1pJlGb132KgxCz1gbBEu8DO9mcEMvRO+wKvsTTjaTscl5ADg005UihSfCBBn7fnFuysQVYVJlBv92tS8S+wjbLsmNk4vNoy5UxyhAN7Km3HkoOzJkTSCh1sdPy5+Eg7Rs3eZtRK8fUJH934f8QNcCVqdjNJtxCIAdIdtae6lK6DIb5mF+a/BLJd2uKCBvQQT1cDaHMzywYtJaCvhNCjO8zEFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kvYZ7nTZwFR5a3p9KRPjYMVm02dBaji4BuxsaEVMK4=;
 b=WqXpWQCyKRgm21X0edssynDVMzArRTNt5pszzEx1EPqD0Rrpt0KQ/FUdXFIhBO0uAjzHjTFDeCUjUs4FqL45Yf4nkMDIBIglUv8LLngejnLUSXSqzKz7SZuti30yHYL4huXGuXxzWrPViGsrgXC/AtBr/9s0oNms5qeCkLDcV8CACETxrfXYgrF2piFyPdwAK1v7hs15piHWYpQ7dhZT4Elzzri1W5yfiqutFBrOW2PnDjuWzMw9AsWglHTVUGbHtXZBpTb73xU9bl9hfeb0b1BzVGLHBAqbUt/xy8iZ4wAytxN5qugM63SErLMKgYEHBryc0bYjmcEuPuADfJgw/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kvYZ7nTZwFR5a3p9KRPjYMVm02dBaji4BuxsaEVMK4=;
 b=lr7cWAe16pvk7MrqU7NiJt4Q07iVjUxhracJq7UdP7e58TtoO6D4IJvq2leLBf0spcwFgAZuUy2OR6/DkaV9TRAGzYnROdJmK9InHN/Ur5w1QXpr7B95roAZZscj6uyaxrKJ/dqRcNvRoNtTY5jGkHLe/5wkXmZTiLqy1IHCcL4=
Received: from MWHPR03CA0043.namprd03.prod.outlook.com (2603:10b6:301:3b::32)
 by BYAPR03MB3832.namprd03.prod.outlook.com (2603:10b6:a03:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 11:24:05 +0000
Received: from CY1NAM02FT046.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by MWHPR03CA0043.outlook.office365.com
 (2603:10b6:301:3b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:05 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT046.mail.protection.outlook.com (10.152.74.232) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:04 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBO2AY004159
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:02 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:02 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 03/14] net: phy: adin: add support for interrupts
Date:   Mon, 12 Aug 2019 14:23:39 +0300
Message-ID: <20190812112350.15242-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(376002)(39860400002)(346002)(2980300002)(199004)(189003)(47776003)(305945005)(7636002)(107886003)(4326008)(48376002)(50466002)(2870700001)(8936002)(126002)(486006)(50226002)(44832011)(8676002)(246002)(14444005)(2906002)(36756003)(426003)(316002)(7696005)(26005)(110136005)(6666004)(70206006)(51416003)(76176011)(70586007)(2616005)(476003)(1076003)(2201001)(336012)(86362001)(478600001)(5660300002)(106002)(11346002)(54906003)(446003)(186003)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3832;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa3383c5-7a93-466f-be47-08d71f1795a0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BYAPR03MB3832;
X-MS-TrafficTypeDiagnostic: BYAPR03MB3832:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3832B96B02C011000C3926E1F9D30@BYAPR03MB3832.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mVcwRgatKYOZ74ujhW64dSB7VeGPXJD0JqAtqTdkLqQFspzj0q8tGOj2FBsFd4CDAMznufhWJb4TVijvntN0BxzXyM7V3oqmC2VG/ZoXutCSYDReYRDieMRoHnuEykmvWN4UmjjXpJ2Vo+gbMvTG8KFRYUxrlXpavaIXQtpdWcxU1nN/dWeglSSPqrjcC6tSKtSh9YIk39PKXMCp46WOi+H9eV5Uq9w6UeRxewBbboJpHSzbHf+FdIEMlF/9En/YJhNWVt3vVPglcMHtIkhjGz7efNUAuCGo4QdPoZVke6nC/XYwNiSpG0OQHLQUBc0+Pe/lh6CXHqtI7z5g2hOh6hFW1lVJ1tpmI8SwO51bKhCDEO+XuSphqQGlbPe9lPD7r5mseqwrnpFA0gYXJHuReBICLlD2PFaAzU/8cNJZdOE=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:04.3006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3383c5-7a93-466f-be47-08d71f1795a0
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3832
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change hooks link-status-change interrupts to phylib.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index fc0148ba4b94..f4ee611e33df 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,11 +14,43 @@
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
+	(ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_HW_IRQ_EN)
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
@@ -26,6 +58,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
@@ -35,6 +69,8 @@ static struct phy_driver adin_driver[] = {
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

