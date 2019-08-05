Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A5C81E39
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbfHENzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:35 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:9552 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729494AbfHENzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:32 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqrI5019294;
        Mon, 5 Aug 2019 09:55:26 -0400
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2058.outbound.protection.outlook.com [104.47.50.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6Ul4xRNrHgWIz9jec68RMgtNaYrfZOcN2EiiNP7O8WY5vYInHyilMG+35EdsR/KqmZWxSenG0R+WNr2FPtCKFBlhRlpF+W4IP0mbiaJ2lUlJwRWX05FTpMpE9q3B0pyl44rkCX8TasN0TX/1F7ZOxsUqiM94tf5GEKJ1Jq1zAw983WlFXGIeQOMzLOwlPunekAhwDgftOT9F/d0fNob/SPBVILRZUqBzjbWwAaxK6OLRd6PyR5qWW2YVOzBQGBVUibh+8vv0958CZ4suF2DoVimJ4inDpEa1qwkwL95JjWunVp0SBCTH4dSh8wKIVEeWhTG3JbRRQ72ylBj7gh7Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKJYzhjMtIN/OdLdSwLoo0yBsMiaCODJ2FWPNtB9o60=;
 b=FnMzjVzUcp3AztHXvApSIGN/6pAcY3aPsuejhO7B+NSbMAvz1r8CnmI3DFPgaYH6xNpGwCoYr42ss7ocGk7HqRKo1VXYdUJ1oPM3a2suhqDawFqSmi9V+kWcggQm/Z/CSbYGEfO3//XiAJdW31gZTcGaMZ6xk6EFlFCVasA0YJ5Zoj8k3f+mgT+4r1wv0L8cwCmwwdyAxtW10zd3pSQ8fV4Kfp0k2Z4yv3wK8ZwneWJtBoQZHWpGKtztgUaRlz/5wQ22lVmC1Wu2C5ryHfi2giHwAUSyRxHANWzVG9lW2T0J+4m+Xk74EB+AiH2KwgoV/5kfhl47SGw4w1hpRdlogg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKJYzhjMtIN/OdLdSwLoo0yBsMiaCODJ2FWPNtB9o60=;
 b=DcPU210lruPw2zl6iNirZIJVZNy0GWYPnGifLKzon2Px8IbF0PTDK0DgPge7Gz5S1+pxZHd3jWkT4qxm1Fctxi8cjk50ZMHjuzebl6HrgxjdAhb5WgsAsIx6KmVxJYO3OijUXyoMqVZB29b361h0RYV7Hk4TMl9uA4B7p2ZgOHQ=
Received: from DM3PR03CA0016.namprd03.prod.outlook.com (2603:10b6:0:50::26) by
 CY4PR03MB2968.namprd03.prod.outlook.com (2603:10b6:903:12f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:23 +0000
Received: from BL2NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by DM3PR03CA0016.outlook.office365.com
 (2603:10b6:0:50::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:23 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT064.mail.protection.outlook.com (10.152.77.119) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:23 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtKet016213
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:20 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:22 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 08/16] net: phy: adin: make RMII fifo depth configurable
Date:   Mon, 5 Aug 2019 19:54:45 +0300
Message-ID: <20190805165453.3989-9-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(376002)(346002)(2980300002)(199004)(189003)(26005)(36756003)(2201001)(110136005)(186003)(54906003)(486006)(44832011)(50466002)(70586007)(48376002)(4326008)(70206006)(2906002)(5660300002)(2870700001)(426003)(126002)(86362001)(446003)(2616005)(336012)(1076003)(246002)(305945005)(478600001)(356004)(47776003)(476003)(11346002)(107886003)(316002)(50226002)(6666004)(7636002)(106002)(7696005)(51416003)(8936002)(8676002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2968;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d253401-7227-49aa-2467-08d719ac8fb4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY4PR03MB2968;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2968:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2968F45F4F80C1382E08751DF9DA0@CY4PR03MB2968.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Dp7AHlqj4Rx2MJkgsJcT1vAKDNRnvxxzJXG3l+dXwDXMWnpBuPH8EoCtMhUHOYKpn2Zja2zLeFhje9jjGOoiUl0IjBb8zSurMXaz8PjqxXQA9UMHOFaE1wtlM9mhi4a7jpFhAO0KsLJFg4Kc1areQCMzBQ0vuQo57khSzZqJ5VJSkpL2Q+kVVAI8Qr1Ne6HAKZPYQyGdpMOFxyPr9NZnmZjJRW75OZxMfciHkOSC+qeSbpJlbCQzk0Gmb+7hfy9/PGEb0c4+Si3wSlnNP53PgExFNejyX5VzeYoE6tbsi0Isl7RjAEqqqkEJD3vqyrVmOqbkm9HdZUuNf4L7N9roIJ7afoPkmnu5bxk6jFWC23ufUkLRgNQ5KnQIjuc0LtiFWyTiMvBCdtCdXKgsSn1kYE/mldXAOesmv5mWXzuxBr4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:23.1190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d253401-7227-49aa-2467-08d719ac8fb4
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2968
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=753 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIFO depth can be configured for the RMII mode. This change adds
support for doing this via device-tree (or ACPI).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index cb96d47d457e..2e27ffd403b4 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -49,6 +49,9 @@
 #define   ADIN1300_GE_RGMII_EN			BIT(0)
 
 #define ADIN1300_GE_RMII_CFG_REG		0xff24
+#define   ADIN1300_GE_RMII_FIFO_DEPTH_MSK	GENMASK(6, 4)
+#define   ADIN1300_GE_RMII_FIFO_DEPTH_SEL(x)	\
+		FIELD_PREP(ADIN1300_GE_RMII_FIFO_DEPTH_MSK, x)
 #define   ADIN1300_GE_RMII_EN			BIT(0)
 
 static int adin_get_phy_internal_mode(struct phy_device *phydev)
@@ -142,6 +145,8 @@ static int adin_config_rgmii_mode(struct phy_device *phydev,
 static int adin_config_rmii_mode(struct phy_device *phydev,
 				 phy_interface_t intf)
 {
+	struct device *dev = &phydev->mdio.dev;
+	u32 val;
 	int reg;
 
 	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RMII_CFG_REG);
@@ -155,6 +160,12 @@ static int adin_config_rmii_mode(struct phy_device *phydev,
 
 	reg |= ADIN1300_GE_RMII_EN;
 
+	if (device_property_read_u32(dev, "adi,fifo-depth", &val))
+		val = ADIN1300_RMII_8_BITS;
+
+	reg &= ~ADIN1300_GE_RMII_FIFO_DEPTH_MSK;
+	reg |= ADIN1300_GE_RMII_FIFO_DEPTH_SEL(val);
+
 write:
 	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
 			     ADIN1300_GE_RMII_CFG_REG, reg);
-- 
2.20.1

