Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2202081E18
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfHENz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:27 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:3656 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729147AbfHENz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:26 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqjLu018849;
        Mon, 5 Aug 2019 09:55:19 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2051.outbound.protection.outlook.com [104.47.41.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC0tlhyTF+eEZMvuVk68wTkZXpW7XpuWVCmXRusuortoI3all2qfF17KMfnnorj0ENPRsUvyT2RwyKWFRRu2ZiigVra5i7xMcG3JPDUr2+wA2riTwcGQ7fjdvCHK7apU7jdQaoWMpSom0Phvk4r24o08D26Fz+0CApS1biZnjgTGoZ5C8x5v3cun76/kdjfNqbVIYHOXR60h8De4Gxx80A5qHu1Hy/7KfaSGOQRjhzzl+Vz9VPeTCtxWqfAUvmXl3ObHC/UMKlCSA9uxo9ZNz9WJFaZOhBznRHYsSYSDoYMqWTDPivt9tSRVzZOebvhTk9W4gPAqWqFJkgDuaRsU9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvkTzCJCStkWeyCHAoNoB0MkBmdD62Wi3w4lxghg27k=;
 b=kV4e4nGXmUSvB7Bt2A0+ZygEbWTMVupc31QaxQ12fCZbH+N/MqKYmdG5dulUiCJjH4EK3nfCunLF5s2yQhTSeKH60+PvSMZe/PH6uhZnRwrQ0kwVNl5Gfih+Mrc44KuGslQkGCs6Ad8r7b+QQgUkFDsSf2+ecieMoGn80mw+MBY/hQ+Nrq6r5sMn0QvHJpJwXdOq4SvdrqikWwyoLjhVyqjFt8EzyGto+pvQN4nAt8XPsD0b6YEG+LgHy0p8y/04HMcaiEzgYHnoPGZVx823oW85GG4/N7/PHcUtNnAUetlufXmQaIiom6DUPBvTIrxy+YrxO3Gdq2HPW3+ZmPRkuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvkTzCJCStkWeyCHAoNoB0MkBmdD62Wi3w4lxghg27k=;
 b=XVNLnnC5P63AKq1NVNnNXRdviSqkxQnl5K3XuqTEKtgXiyoCS6KHGgBvZaelgdvVSoQ+bI+5nIWWjFP3nN8kEyPO9vy0PxmRtt24YkuTMmKnzmiyOBnreKJYxsmKwqTkMLCV6kgSWCt4E4nHXLaO5pMRrYgdNxJ3uE8DHYWZgPI=
Received: from CY4PR03CA0024.namprd03.prod.outlook.com (2603:10b6:903:33::34)
 by DM6PR03MB4187.namprd03.prod.outlook.com (2603:10b6:5:5d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.13; Mon, 5 Aug
 2019 13:55:11 +0000
Received: from CY1NAM02FT041.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by CY4PR03CA0024.outlook.office365.com
 (2603:10b6:903:33::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:11 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT041.mail.protection.outlook.com (10.152.74.156) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:10 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75Dt7q1016185
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:07 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:09 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 02/16] net: phy: adin: hook genphy_{suspend,resume} into the driver
Date:   Mon, 5 Aug 2019 19:54:39 +0300
Message-ID: <20190805165453.3989-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(39860400002)(2980300002)(199004)(189003)(426003)(14444005)(4744005)(316002)(76176011)(106002)(54906003)(51416003)(7696005)(47776003)(15650500001)(305945005)(4326008)(36756003)(478600001)(110136005)(107886003)(246002)(44832011)(50466002)(48376002)(7636002)(446003)(50226002)(186003)(6666004)(356004)(2906002)(86362001)(2201001)(26005)(5660300002)(126002)(2616005)(486006)(2870700001)(8676002)(70206006)(336012)(11346002)(8936002)(70586007)(476003)(1076003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4187;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18262398-7e6d-4d08-7b4c-08d719ac8870
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB4187;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4187:
X-Microsoft-Antispam-PRVS: <DM6PR03MB4187EDBCE04F62C77977EB81F9DA0@DM6PR03MB4187.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: GeQU6exjVoDLObuNWS3qYnaQwkFBnMxCa5ILjxozqE1XQlstE+p2SgkAOKj8mKXdf1Mh+R16XXV0fp3rNgMKANlZaaYMnSFZGNuO2yrpYXXTUeF8JJM3GC/859Ko8bNhmcVNWhZ9ASyNbVJxo9PeBS15kbnN+WjxBEzgGBRTrjl4ZB0+4fnYEV2q/YzwUiZ78fQz5dk4qTc2qCxuO4E4NZerAOonr6SLsUwIcJxAYKZyrApzpHp10SA2SDfhHLKZiSf8woooX7Yt1cn3fseZCyAGOKeWd5rU88u6dwD6HG5Vwm+Tt2gDDGE4gzVkHaLGu/0P30LOjRo4WANWCIiiXttSQHtErvVgtwk1v+m2Hy+RavNDQelBhqQDzPg2rf11n/6pkMU3XOULvzKenLXXgpFu2XXTvDxmTKmk53mpR70=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:10.4982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18262398-7e6d-4d08-7b4c-08d719ac8870
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4187
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=993 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
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
index 6a610d4563c3..c100a0dd95cd 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -34,6 +34,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.resume		= genphy_resume,
+		.suspend	= genphy_suspend,
 	},
 	{
 		.phy_id		= PHY_ID_ADIN1300,
@@ -43,6 +45,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.resume		= genphy_resume,
+		.suspend	= genphy_suspend,
 	},
 };
 
-- 
2.20.1

