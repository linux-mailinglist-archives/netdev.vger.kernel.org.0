Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80F587B7D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436591AbfHINhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:37:31 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:56314 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbfHINgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:13 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DNAec026401;
        Fri, 9 Aug 2019 09:36:04 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2050.outbound.protection.outlook.com [104.47.49.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqjx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3HL5qw1lAvFC+B17eImfHI8n4t1DKp1BwJD3oifBiKGL7e3bRcS2oqUmIk5shjfYIVnCYx2w2oVZU0qrT1EjHS36C31rkOR0IbPwyl6VBcKICeHeN5O5vmQY1avovRqWycESZRdcMiUw2AA1S3aBfppPZCWkvTZqhsMADgT5LzqCCT4PogURah+lobcGIV53ZRL599MeyjZf6Ad5BmbsqYkazQQAnPuIcVvaity525jwudkKyEMKXLc9unwgbiBCT3uz6K+kFOA4cVQS3s22U0f0Y+aUSXFZhfKzr2EdVYC6MprucUymKRip/c24L8Iobn0AkLv/14wOwJ/SmLEsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrjxvRtCBvH3YgNsCipq3plw/6ll60cR2lNQo14Ia0A=;
 b=NZH/pExR+7dohxp6y0VwYgaztWHya1hxbrqLilTO3kDZgQpIml5rwYR5c62nWFzmRIEP3ODtvfT20hmLVrfKBELAaeMRsfN5lhYvyQlkQ68VNOA9C8cM+Ndcq5ArtAeeQXYwboG0vSyqKd1WDTRD85ly/0LYOaYsZvFDD1yMQg7a9+pVQQflg1eyBxXZI6GAlbe4Dhl8/NwZWJg6t7E6zm8ukAA5Y+GrthfS2Qd6hUy4FKR9qE6VbSaaVK36CIVCfz9u03AfWZczMhD1E2rQzP8dWm2PwbetJ2VZHRnO2fAtlis3Ka50pBOeSAxalO4zcywx8JrTPLtJmGWekIJ58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrjxvRtCBvH3YgNsCipq3plw/6ll60cR2lNQo14Ia0A=;
 b=KP5CaivDCB/1X2ra9NSN0zDHzo08Y59KI6cUvh/k1so9AtgEKBfgA8um8bJyxBqm7HtE+P9TTEfYNNzhDVTsW9W4aL/AaGaSiS7ZawWe+CEk9qREz5ho3vhOTFkOm94MkK69SavE8E3V9uILdVmb1d8GjExoSL73WJC7g9XtcjY=
Received: from BL0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:208:2d::33)
 by CY1PR03MB2347.namprd03.prod.outlook.com (2a01:111:e400:c616::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Fri, 9 Aug
 2019 13:36:02 +0000
Received: from CY1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BL0PR03CA0020.outlook.office365.com
 (2603:10b6:208:2d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT037.mail.protection.outlook.com (10.152.75.77) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:01 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79Da10C025634
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:01 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:00 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 02/14] net: phy: adin: hook genphy_{suspend,resume} into the driver
Date:   Fri, 9 Aug 2019 16:35:40 +0300
Message-ID: <20190809133552.21597-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(136003)(346002)(2980300002)(189003)(199004)(4744005)(15650500001)(2870700001)(26005)(7696005)(51416003)(76176011)(478600001)(5660300002)(316002)(4326008)(106002)(110136005)(356004)(6666004)(36756003)(305945005)(107886003)(246002)(47776003)(8676002)(7636002)(54906003)(44832011)(2201001)(48376002)(486006)(14444005)(426003)(2906002)(50226002)(336012)(476003)(126002)(11346002)(446003)(2616005)(1076003)(186003)(70586007)(70206006)(86362001)(8936002)(50466002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR03MB2347;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26c9ccbf-5914-4d6d-a4ac-08d71cce854c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY1PR03MB2347;
X-MS-TrafficTypeDiagnostic: CY1PR03MB2347:
X-Microsoft-Antispam-PRVS: <CY1PR03MB23476FA8C33D5DF3F4F95B59F9D60@CY1PR03MB2347.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vADP6U56ccKko05t6U/OvDbtFCs5DgKQCHAXFgcDp6d6jGXjPsenTiO+2kdH0zlbA3sdPCuEV2yzkVBZ1ZZnKlhkHcxpLlue+g1kKE7TFGGBM4drVcMt3fuEhhm39TP/lfWGXlh8E6F0KaRWL3+aC14p8oe8nnd/arGaO3ZFEEeABjZjyhymbRN6XAB0oHyA4dPLkJ56TXrbtckpjaEr3CLQZrbADx2QVAgYVeNSmurx4HtZZeGgYsnRNRVZXVfsK+LZib4sB9C8/IhU1lgOHRrygIzGJtyqhkyn1vNBG6Wr4gqjPE4wXGCjOX1UBMyFJMTcZI/QbKM2XhklfS+xLnujwAUcdDglQ30bo8quEzZfQNjb0kGFhTmIdU+3pE+tHteOuAzSErJ2B8KozixiRKqZA4TA1Yr4xYQu02c+JpI=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:01.6113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c9ccbf-5914-4d6d-a4ac-08d71cce854c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2347
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

The chip supports standard suspend/resume via BMCR reg.
Hook these functions into the `adin` driver.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 6d7af4743957..fc0148ba4b94 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -26,6 +26,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.resume		= genphy_resume,
+		.suspend	= genphy_suspend,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
@@ -33,6 +35,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.resume		= genphy_resume,
+		.suspend	= genphy_suspend,
 	},
 };
 
-- 
2.20.1

