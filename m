Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1458181E3B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfHENzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:32 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:54988 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729483AbfHENzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:31 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqpIV026512;
        Mon, 5 Aug 2019 09:55:17 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2058.outbound.protection.outlook.com [104.47.32.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u576712vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdZZZaPlNM9klFvinh18oktxHN7jEY6iEYkBTWSXl6eiovYfKIG43qhaMMPyanTNR0UeO7jHTcdmnlcigZ0XTuOwMP8TPg9rTuUHMlHzPUH0Z1sYr/rIqSjxV3UfjlcCXo7hFmEaBxaTKpkocEZ356ZPNDT6L2lXWRqZxop9sWwvgUskGqLpRZ225Zl+ygmrF5CIkYbxMKmqI+d0TpVwbJ9pNfP2T+bTGRAkNGqjQHazI3CAths/vTsL5HZS3YxqXql2p9n78LDXtKGSRJGm7zL3oR1/jiwzJgJHPmwJdF/9J381iIl3LpGNtnihUiTI9FcedTdSSVXbXDuIRANyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj8fx8kmqyVB/vj6tk2imRG2sLcSF5tadMa/T4V9wm0=;
 b=Ql4v+nnda1qyjl3J5AbpFb1fd0w2OezsPFyNWAcGMo3U+q+/zOXAVWjodWCrKaSVlUSA9SXZSgfbNHnY54pTW0h3r0HCXoa3+dPcCdJ42T7Xz0228jUjKSHDYygmL7X0sjsRFkWYYA7c0CCi0KO+moCXABRKm78dtVdMNBWZAE7s+N79//F6KJtuLH+huz94XPTJBA2sAfhAqafNm81EVsrPBJxcjhlohyFJsH4d4RewHes6togBv6Yc8Pj61xPliZsfcnEbYDoOzZiijbtSVdnP33KIpdvh3a8xzeC6EKKUd/eRYpLRTw8QBPhF2iFUAsT46jUxKSZ4WwwzBaM9qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj8fx8kmqyVB/vj6tk2imRG2sLcSF5tadMa/T4V9wm0=;
 b=NP5/8KV2ASyTkCZeEkw3DyGCKGkFTpnT/MbfMCCKNZ5zC1ulZQ9uiX8GJRTVbGh/wm0+mZhnGQRTuOa+rzz5/iKYYCcplY0nCXx75fFmiViueiLMgca2yI7e0aZBzy801on+beAksbB4cWOzba43a/SYbvAQ4sJKUxWqF7CG1wA=
Received: from BL0PR03CA0018.namprd03.prod.outlook.com (2603:10b6:208:2d::31)
 by BYAPR03MB4903.namprd03.prod.outlook.com (2603:10b6:a03:13a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16; Mon, 5 Aug
 2019 13:55:14 +0000
Received: from CY1NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by BL0PR03CA0018.outlook.office365.com
 (2603:10b6:208:2d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.12 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:13 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT062.mail.protection.outlook.com (10.152.75.60) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:13 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75Dt9t9016192
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:09 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:11 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 03/16] net: phy: adin: add support for interrupts
Date:   Mon, 5 Aug 2019 19:54:40 +0300
Message-ID: <20190805165453.3989-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(199004)(189003)(2616005)(47776003)(7636002)(76176011)(26005)(186003)(50226002)(8936002)(336012)(246002)(8676002)(426003)(11346002)(44832011)(486006)(446003)(1076003)(126002)(2201001)(51416003)(110136005)(356004)(6666004)(106002)(476003)(14444005)(5660300002)(7696005)(305945005)(2906002)(70586007)(2870700001)(70206006)(54906003)(48376002)(478600001)(50466002)(107886003)(86362001)(4326008)(36756003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4903;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de77fd49-8c5a-4148-7dc5-08d719ac89f5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4903;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4903:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4903EB039D074DFA97631B89F9DA0@BYAPR03MB4903.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: AxudvxswKtD/cg4HbyFnp2XgXv1uHubqjJSIonq06EjsS/D9/Ek16lj/k1fgSgG1MaoZDjQBAYCtHr/SWFzW7S3bMv8L3+xCz6PCCFuJtQ2gfzuEXV5AKPDCFUo5rjmLsXsSffIF1fYhYCjP0lKIckPAY4mIc6J8iR3myEf6mzykYoMvCMQSXSTcRuHWRREJqAX+QlctpWgv+kUG6P4iNqfTelVcZlnhjcNxhiTMxSULNO1hyTsoAws6kU60s9SdRRxStuwdwSoAO3ztl0YYH6Y1H0eTQl4r4a3szF4e9eD2zGDztf7042qmXcC/U37LwzqawV/XXzplVOjBi30hb0waLmaakldQc4eu8BW4ud5AG3JxfjfQnTf918b7e3l9ar6ZVMBLpsjtzs3asGmDAEOtnk+nrjiWK/eicZM7wEA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:13.0466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de77fd49-8c5a-4148-7dc5-08d719ac89f5
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4903
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=869 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for enabling PHY interrupts that can be used by
the PHY framework to get signal for link/speed/auto-negotiation changes.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index c100a0dd95cd..b75c723bda79 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,6 +14,22 @@
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
 	int rc;
@@ -25,15 +41,40 @@ static int adin_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int adin_phy_ack_intr(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Clear pending interrupts.  */
+	ret = phy_read(phydev, ADIN1300_INT_STATUS_REG);
+	if (ret < 0)
+		return ret;
+
+	return 0;
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
 		.phy_id		= PHY_ID_ADIN1200,
 		.name		= "ADIN1200",
 		.phy_id_mask	= 0xfffffff0,
 		.features	= PHY_BASIC_FEATURES,
+		.flags		= PHY_HAS_INTERRUPT,
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
@@ -42,9 +83,12 @@ static struct phy_driver adin_driver[] = {
 		.name		= "ADIN1300",
 		.phy_id_mask	= 0xfffffff0,
 		.features	= PHY_GBIT_FEATURES,
+		.flags		= PHY_HAS_INTERRUPT,
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

