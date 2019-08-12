Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF489CB7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfHLLYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:14 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:50326 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728204AbfHLLYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:13 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNLCk018325;
        Mon, 12 Aug 2019 07:24:05 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2058.outbound.protection.outlook.com [104.47.38.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w65f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l57i1QMdqU2+YwANinConnCSnjMtMvWlD3kYwAIZOC5or0VNfzlpXUmQ0klpgSFiI/GmfVVHkV8j/4vPNGXOqjfdTPUaG6Au+F7M2gzZhLexvzwBPrQWWw6AfAxvx2IQaGeR7qRbSZMGx6l3Mq5roIpOjiOAh0adQuhhdnNyBl+tKprmFpnxGSFYq4AKTju6ss+mKm8wpKBMILyuXCFTpZG83eaozze7EGj/YcGpeNjFQSNAdXGJcfFkQGaNPQ7+BrrX4GYKT6e2atF6z5IJTW/vCp5ckUuAk9cqg/rI/TxeHK2twNfxKZ+PR3KY7ds1A4gPnZ8zu4zEDIRImnR+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrjxvRtCBvH3YgNsCipq3plw/6ll60cR2lNQo14Ia0A=;
 b=oEsGDBEnZH4Mr/KPcZhdD69masSIr8I/7N3cydMIeDrav/44kBW44EQ1fHo4Aarcn7kOTk8XznAg7XvOSz267QRo9JWHcUMDwzwYMvF8CKKxpgF3pWhz/Tav/XxeVyuTB2DrGjXJjCzUnJI5CkO9Qq5oby/XvRxdrEVTlqc2L63TwfSFAC8QYffbzXZxpDK967cdU/a1yiZZgoHdc6M1QL+i5ReO9F5MItDpRJKFgK+lnYJyF29plL9yQ+XYk1Z2cMZCT7Sll2KhSqLzJrlPLqHawCrOlzvcUlM1aGWB6QvwKe3OAGZy4BWHkNbBljJfCtfcn6ZvMoyzG2E06ElfTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrjxvRtCBvH3YgNsCipq3plw/6ll60cR2lNQo14Ia0A=;
 b=C+2SBeHJ6GkSo3zkDxNxr2Fz/V/qBKJWAHNCHfX6jUn+KRWQ1n/YvTHnFKt4VwcUg6W5vy0FKI/BXzqjmUJUl1bU/HvmWqwOPUFfgQRm9GgLIKLXre0VWi6SP/lnEZKD9nNWKDiNxsEL9MH+ejIV5hof15GthBWdVIPSwdKwCtE=
Received: from DM6PR03CA0008.namprd03.prod.outlook.com (2603:10b6:5:40::21) by
 MWHPR03MB2431.namprd03.prod.outlook.com (2603:10b6:300:11::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Mon, 12 Aug 2019 11:24:02 +0000
Received: from CY1NAM02FT006.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by DM6PR03CA0008.outlook.office365.com
 (2603:10b6:5:40::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT006.mail.protection.outlook.com (10.152.74.104) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:01 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBO0AM004156
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:00 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:00 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 02/14] net: phy: adin: hook genphy_{suspend,resume} into the driver
Date:   Mon, 12 Aug 2019 14:23:38 +0300
Message-ID: <20190812112350.15242-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(376002)(346002)(2980300002)(199004)(189003)(305945005)(316002)(1076003)(246002)(86362001)(478600001)(50466002)(26005)(186003)(426003)(48376002)(7636002)(76176011)(336012)(51416003)(7696005)(8936002)(356004)(106002)(8676002)(110136005)(54906003)(14444005)(15650500001)(2201001)(6666004)(70206006)(4326008)(70586007)(5660300002)(107886003)(50226002)(2906002)(44832011)(2870700001)(4744005)(47776003)(36756003)(486006)(446003)(476003)(2616005)(126002)(11346002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR03MB2431;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32a681a4-b5e5-47b0-e0d2-08d71f1793bf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MWHPR03MB2431;
X-MS-TrafficTypeDiagnostic: MWHPR03MB2431:
X-Microsoft-Antispam-PRVS: <MWHPR03MB2431C4020EFC7F600E4A0DF3F9D30@MWHPR03MB2431.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Ne3kgnBd2gv+kJKWHrBupQzmFYukQpbmvrGXFlRFXxxasBGwoj7QfmmaDTSYEeJuf7Btdsxn8ABMfaz2JP3gNiGxRk4vVXa70qndC/4sgQwDw1k4nN2DNYnVM+AzOwrqD7BIYS5tqnfqgBpIL1WNP2yD3UFQjDbPnPCEmCMCcpWriZiwVR8ZmThkp1NqnKJFNbNF/Ye3oYxgakyia5lGesh5s6lKATw7+JBqAti9drOkcB6NUGUBnHsZLhSuvnnkjsbkr//3p/PV66pajaL/m5ZQCYidjZ9CQSXqDyXWMOcCqz1uP5zyE1NHQZzjnawgkkNUwhV3P3cjObvVrDZXIVFgyZnSzm6JIO+OMd4OesLtfxXszElrSXYIRmSe1YJBOoSuUl9YH5xRIhWs/AwGMGtSjb0LOZjo1w5rafzuYYw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:01.4474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a681a4-b5e5-47b0-e0d2-08d71f1793bf
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB2431
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

