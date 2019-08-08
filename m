Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5585D861CA
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389742AbfHHMau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:30:50 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:45038 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbfHHMat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:49 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRobN022491;
        Thu, 8 Aug 2019 08:30:39 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2053.outbound.protection.outlook.com [104.47.38.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj3gvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJRwo+0C4rleel2+Nj76lJkEpb3hotqH0uWSfojw6C4IwQNrcieRj7p/9pcCa8eZ6X6bM525uIYry8/BWCGvMO0fMUj+XHkcjkvOhWLVrTbUzUuA5Wy/VBebxf2OAbF+1IeOwAORU+wHNDTsfVv0AS4EuTvENUOxgJbVuArDyFllhOamKDQcFMof9rpCm07eJJW9Eoq0wpNT6f0gKp7Wvxvh6OmSSSkvnNzOHFtG0PJvydYDcerBAvWMgkquyE2jp2zC5GQETb2H7a+gZUGIT76zIXJhn9LSGGxeqARWjTPJbAlytFtkrnlzbM6dgnM9QWPtLAB7kch2BDXP7HQd9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlNnl0XLW34T/QV6J2As0OV9goGnjBVq5rlCqSOFUvE=;
 b=NseqVUWUEHliGWxt4Lo8f+6wVWSAneksTzl52OIxsfp9tnShKov5ohPM34HQyffbtwf1+iMcez0X/GN4vSNI1S4eyAzhc9APXSO8GUpaiQIZIGqbXYRhHC+xdZhALvhbINPvSlU5eOaKVh2KnKdj9QnsSSAFyTSactrz7mvRMoMd1LUX2o0qtJCVykUwCs6SmlVUlCs8YqsguJDu/ssaonK331K3zhr9HD0xJS+mOw7GlQNPifiPIv/jeFueO4AbVASFpA79DxildD9kp4biLxeEv1FkFNX1g+TNzPZoSVgCCzCzzddZUc3hOEUVzecve+9qdu6PwJmXhF5ABKsyDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlNnl0XLW34T/QV6J2As0OV9goGnjBVq5rlCqSOFUvE=;
 b=bsQZN/nyuzfbWElrYTila3E3BhYlhLT/TkyLlMSFwaLdW2hNRf13A8hbp8MpQNKwUqWtlaEAobFGkup4Z+wnYLk9vbRLxXDzwjGMk1/70Fy64vzIZyuBH3uYHcew3KT5HmmWNvLcFQLEeD7qnrH7NDRY+6h0lL35Dqzug5QZuc8=
Received: from DM3PR03CA0010.namprd03.prod.outlook.com (2603:10b6:0:50::20) by
 BYAPR03MB4888.namprd03.prod.outlook.com (2603:10b6:a03:13a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Thu, 8 Aug
 2019 12:30:37 +0000
Received: from CY1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by DM3PR03CA0010.outlook.office365.com
 (2603:10b6:0:50::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:37 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT060.mail.protection.outlook.com (10.152.74.252) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:36 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUaaX021156
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:36 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:35 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 02/15] net: phy: adin: hook genphy_read_abilities() to get_features
Date:   Thu, 8 Aug 2019 15:30:13 +0300
Message-ID: <20190808123026.17382-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(346002)(396003)(2980300002)(199004)(189003)(106002)(26005)(8676002)(70586007)(70206006)(48376002)(50466002)(4326008)(50226002)(110136005)(478600001)(51416003)(76176011)(7696005)(54906003)(8936002)(316002)(107886003)(47776003)(86362001)(7636002)(426003)(1076003)(36756003)(2201001)(336012)(44832011)(2870700001)(476003)(126002)(186003)(246002)(6666004)(486006)(356004)(5660300002)(305945005)(2906002)(11346002)(2616005)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4888;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 785722a6-9663-4457-b83e-08d71bfc3768
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4888;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4888:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4888CD745EF225A8FD68637AF9D70@BYAPR03MB4888.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: XVDZVBK7NQYTbMlnprZFxRsA2hBcuPHkyn7YCOkULNC/bOyJbEfAQtvDIy8IfKnfBPA/jbZEPJhiIHZdpz3O/l5NM6CkJ7dNOMp1w7+v1byPx4Lsk8KKCLvM06eE8xnePOYpDs3qs7mgvFrZy/RWH/NX1CC1J5P7Daf7K2jTYcU8UVo+WlcDdTMIGwTUAv7kyB3g3embS2B2GRHFlMSwrgd84ic0GzLdAa38Y5DWuU3dUgFubo5LhiS4U4n2ue+VvvGtacXwWSEthhi6lTNq80cX+u/JL3rCNNoY2YD3JcQcLW1idpKynXsMsGzSVzo9iAMd+LDsMyqc9hFoz7OYtYa5M5piMLqjaklKg6HP9Dw3FaF7nXZ4LrI3zcQmPFkLrO5aNuhQDOOl+nUeJ4vdcoapy8C7YqWuq0WjYV4AGdE=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:36.5638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 785722a6-9663-4457-b83e-08d71bfc3768
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4888
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs can operate with Clause 45, however they are not typical for
how phylib considers Clause 45 PHYs.

If the `features` field & the `get_features` hook are unspecified, and the
device wants to operate via Clause 45, it would also try to read features
via the `genphy_c45_pma_read_abilities()`, which will try to read PMA regs
that are unsupported.

Hooking the `genphy_read_abilities()` function to the `get_features` hook
will ensure that this does not happen and the PHY features are read
correctly regardless of Clause 22 or Clause 45 operation.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 6d7af4743957..879797d076e0 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -26,6 +26,7 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.get_features	= genphy_read_abilities,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
@@ -33,6 +34,7 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.get_features	= genphy_read_abilities,
 	},
 };
 
-- 
2.20.1

