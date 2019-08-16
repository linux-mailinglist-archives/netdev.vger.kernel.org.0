Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A369027F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfHPNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:10:42 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:49010 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727240AbfHPNKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:39 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7fAa024758;
        Fri, 16 Aug 2019 09:10:30 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2udnnugxu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni4tvomTviXdz5fWeombzSzJUzVkER2H6zZ4MJX/L9/d3vLlhclbWy5gCYQCpXip40HBtyRGKtSbktVWLSMbqeVbV3CW2DaahUXZu09/8hG1V1DnkWv1SxmHHJAvDxC6KpVbPkLqg2ldl9yZUvHvvmZvBEy+x31fKNO/FwODZF55sVaz3jfZS3Qfafo/HIftMzNsxx0gTyJgCZGbyDRBoEAUIh9Er42jLUcmN3OKRYutED8zHiigSS7G60QYppm49ijVI78v3TnU6XUsqcwFYrwV72fwMe7NBZ3XtSRwT5ntFAXzfFNXIeejzpf/oCTJIEsauiwbr1l7OuJX+rXmJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRhX/0/3WBfBsT5nE9/FmEFTsdBC3BZ0HYQYgPXUVWg=;
 b=ZRe+4e/TPm3iK/tOOUVuwMAFch6bBIZBMtAHy73bwGa8W+fHJQ0qBqIqFV9kY1Ep93fcHCS9JCVl4NH5rXjC3pbYmO+xOw3hYhHC7mZSvatTRMC+9KJa+XZo8KZeIiTHoNsKPhFkp71KVAl8f4km3mIp7MrQsuXHgBjcopoptQon/PfHGcRFgl0Mav005F9dj5Fp/e+RhohsaREsc2UEiSpCjLLloINM0IvrblQv8yMOh/60ub1OmrjtXQ+xo8Yq4kuOjOp44zvz0+cEvOR3g69Y70Nayd172ryuSGtsM+qdFaEoQRV4xKdqBn3NG+6I6HXAPvTzarEvonEuVMhk5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRhX/0/3WBfBsT5nE9/FmEFTsdBC3BZ0HYQYgPXUVWg=;
 b=GDFmqwWgE/O5EynQRMjuc9hyoF9Wfp3NS31bUCDQQm7bWDMG9gPoF5P9WcvDzlrRKLH7upAQlMF2UYL5ItzTMVaASwh0tY1X99NpbR/Jo/OkbAlDUyims1H/cuGcSXxOxmNQDA1XducTPcOSYT5uR2apRDNZdyH8Y8hkB8vH0LE=
Received: from BY5PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:1e0::40)
 by BN7PR03MB3875.namprd03.prod.outlook.com (2603:10b6:408:21::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Fri, 16 Aug
 2019 13:10:28 +0000
Received: from SN1NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by BY5PR03CA0030.outlook.office365.com
 (2603:10b6:a03:1e0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:28 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT062.mail.protection.outlook.com (10.152.72.208) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:27 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDARVI007852
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:27 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:26 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 02/13] net: phy: adin: hook genphy_{suspend,resume} into the driver
Date:   Fri, 16 Aug 2019 16:10:00 +0300
Message-ID: <20190816131011.23264-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(346002)(396003)(2980300002)(189003)(199004)(36756003)(14444005)(5660300002)(8936002)(11346002)(70586007)(246002)(7696005)(70206006)(26005)(186003)(4326008)(426003)(8676002)(76176011)(51416003)(4744005)(1076003)(356004)(6666004)(305945005)(2201001)(50466002)(86362001)(336012)(15650500001)(2906002)(2870700001)(107886003)(44832011)(316002)(126002)(2616005)(486006)(446003)(54906003)(476003)(110136005)(106002)(7636002)(478600001)(48376002)(50226002)(47776003)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB3875;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea153f13-0d1e-4407-8e15-08d7224b1bf2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN7PR03MB3875;
X-MS-TrafficTypeDiagnostic: BN7PR03MB3875:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3875A72E6C23F8CC57A3E4EFF9AF0@BN7PR03MB3875.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4S/roL9P/d/zrluORsPDtwoFr7PaKh0npIvZI7TbboqwaHvgqG4Cjh2x9M+R4l1X3T4y6Eij6454zTazE3Gj0Xg439Zb3iJuA0m2lFmQJzPjBI0IYjEryt7jkezYkM3VjPURSbseHrlryw0kvFgemRt/D05Lfgt5ZMhFlot645w7P18ZSRDScxdCci/keqeSxY4ws2vmlQf6nf+zNIbh/nYVki5NqC7UaF542mJitrMO0zXY2e0q9t2fgzhgO02iDbKAopnAdHMNkm3SXQYsnXJmOXeiiwb6hgbntDUoMJagrkwtoUX4wFX00EQAPFXFsQSYfHTEDDu9gKxgGLehFge8App9c8xlGS71d1Vnmc5b++tfJHSnCapyhi2ta0cBLUD62hZ7+eOy3qArfokEG0puugZWDT8EpE82sy1cvT4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:27.8033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea153f13-0d1e-4407-8e15-08d7224b1bf2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3875
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The chip supports standard suspend/resume via BMCR reg.
Hook these functions into the `adin` driver.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

