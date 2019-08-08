Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1099861E9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389906AbfHHMcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:32:39 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:45550 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728980AbfHHMat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:49 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRobO022491;
        Thu, 8 Aug 2019 08:30:42 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj3gvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0IxaqfSPdaaS36rjdHjGQdO4asAo86tDzDbqhSAW3cL7k8fV+qFKzchtpNMcghe+oM3CmapI54KMRlwHcsrO6rkWahwZyz+t/nTRIiLi4AXIqaRjkZqmFV5P8TeVSZkxWdMpaIDxvXpPQOCDPmIasd8JbrpQ0gmEAUztDauadfvrAknQwfCNOKK2zk8yJswCCHtBAlOd4mvx1AvSzLUHs1TvoqsmErWBfo9uohFmxl0jm8PLLUuCJsoia2KCfluOa+IlSvZSwIG76sztBdYf13nSYwi0C7I+Cp71bp2zfpygTWW7vq4YpMHhMtQ75lIG0iMihgkMpQg9YI6SM/Whg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1vrwbrOrviwYf1w5DV0S5pcUO9N7R7Aew9IDwTEkJI=;
 b=Np7cn1+xFSBe97vqwIdmKF6V2+FJr688qyRaPIpl8ehyfdjdgxov/4QNl0mkKaHNnIqf/4nF2YQSl7OVd7bA8b/O+r/VGfeqxO5uI8uBVivIxblPuNb9oNKQSn/8sSfpqo4+HnhArypSkMH7uwmPcghgDBILn3jhWzfrzheygHwT5w4h+Q5JbDdLXtN6YgQ3SBVYhijbodbPRsAndAUieON3t48Kehiodw/PSh+e5+2hyjCC2tYG+KGLSS2p6FW3MDLr5Q5YSbZxG584NGb7u5/+KD48UTkE8RAZ+NQDTffYxWih4k2qWTmsCmeIdTej1hQLVsPn8tf8qySc7b+zCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1vrwbrOrviwYf1w5DV0S5pcUO9N7R7Aew9IDwTEkJI=;
 b=Vw0ozMRB/QQUH5YWlFspUbTNLs44upBD7x6nhz0y4bYo1vBJ0/CE3Pb/lXPr+MNSkW7tK/dctTkuQ0TEsYUjTfJU/6+64Zn7tjtHvcJCdx1gyDa583ZTGJ7HWQOnkg0HvLla5VCWNiNt5XURja0KW16ZFJe/nq/CGXBxXZDMo38=
Received: from DM3PR03CA0007.namprd03.prod.outlook.com (2603:10b6:0:50::17) by
 SN6PR03MB4189.namprd03.prod.outlook.com (2603:10b6:805:c5::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 8 Aug 2019 12:30:39 +0000
Received: from CY1NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by DM3PR03CA0007.outlook.office365.com
 (2603:10b6:0:50::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:39 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT027.mail.protection.outlook.com (10.152.75.159) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:38 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUc9Q021203
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:38 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:37 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 03/15] net: phy: adin: hook genphy_{suspend,resume} into the driver
Date:   Thu, 8 Aug 2019 15:30:14 +0300
Message-ID: <20190808123026.17382-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(346002)(396003)(2980300002)(189003)(199004)(246002)(86362001)(8676002)(4326008)(4744005)(305945005)(70206006)(70586007)(2201001)(107886003)(7636002)(36756003)(26005)(316002)(186003)(8936002)(110136005)(76176011)(7696005)(51416003)(476003)(50226002)(2616005)(446003)(11346002)(486006)(44832011)(1076003)(126002)(6666004)(356004)(336012)(48376002)(54906003)(426003)(106002)(14444005)(2906002)(50466002)(15650500001)(2870700001)(478600001)(47776003)(5660300002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB4189;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f61bcfb-00de-41e2-b57b-08d71bfc38bb
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN6PR03MB4189;
X-MS-TrafficTypeDiagnostic: SN6PR03MB4189:
X-Microsoft-Antispam-PRVS: <SN6PR03MB418933A113A585AF77F48F1CF9D70@SN6PR03MB4189.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: lCv7buj2/UXMHDvTW0p99o1dKUKvsxnYdE9N0t6pg6iouOSmio6vvkPyBACEHbUf1gei03sTxLBTWjRxgNHTjAQa5AY4JteprDM//sf8kgkxp5vfJUpYXPqqMjx37UDQOBnercov+pqeXQ84W/3OQ8UyMnZsfHDWHNzzyTcL5AuG9/2vZ5KW2mjmA5E1v0RuuB+MLcNfWJRjCvpAezOhNMmbITvV22XXdxcdm+rOFxJvrw8sWVsn1CrdkHDX/puyEEZ2VM1mSsoaK9/eRG71PSOjqSPCs77e8+Wi9ibLyrrmovhSf6dMDw0qyccIIpxh4EF0JSBvdF2p+L2xjmR83WSDa18a1z1G2R7ffzjM2RTYK6i4Wz8fFke+Qv/giAENmy0cYY/xNbvUsn/h2RymNb6kQD7SEdsAV3uuSz8diNs=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:38.8234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f61bcfb-00de-41e2-b57b-08d71bfc38bb
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4189
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=982 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The chip supports standard suspend/resume via BMCR reg.
Hook these functions into the `adin` driver.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 879797d076e0..45490fbe273b 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -27,6 +27,8 @@ static struct phy_driver adin_driver[] = {
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
 		.get_features	= genphy_read_abilities,
+		.resume		= genphy_resume,
+		.suspend	= genphy_suspend,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
@@ -35,6 +37,8 @@ static struct phy_driver adin_driver[] = {
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
 		.get_features	= genphy_read_abilities,
+		.resume		= genphy_resume,
+		.suspend	= genphy_suspend,
 	},
 };
 
-- 
2.20.1

