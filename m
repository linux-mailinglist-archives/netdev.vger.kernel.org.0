Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D2AA6953
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfICNGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:06:53 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:5264 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729415AbfICNGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:06:51 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83D33SO010211;
        Tue, 3 Sep 2019 09:06:47 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2056.outbound.protection.outlook.com [104.47.33.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqjrad1kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 09:06:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlUFOi7C/oRMqkgEN49YrQCVNR0JfIwSYxumJEDU6DSOAE2UOmmLC8hVc68G0LqthmT6Un3kzhJcfMkeDumUTSjjkmvXrj0DWz/FYSNITdQ3XTvLb2CjE1FcK8RioZcCR84CLaPeAcK1FaU40kGEk81xSevYsiPzPkg2soF5uRU4/Y9PVRLDmLxCqXxFYWGtxPe44hQCfM6HUjkWxPbtTYu/gMhC15vs/pvfdbAKCwSgNIGwUTyZIi2vGHRZi+mGM2IGcsooxeen0N+5UCGDIdv8rzTBeul9JzIgp7xE+4fPXUlB7CsNNqPQA+xdhMVf02CAiu0Q1obtudijsVqj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ya/l7clJw6vh6zlCmc3x8CghWEV1gLPHER6lGbw8BbA=;
 b=A6aOAF7/ihqZzVeXdpeONbdcokRezxVn7GgHyDe/iEPnagG3H0X6sWMjcYGL5eWT5fg0R5ikbYpDR0ADytuipu5Cbtcy++TESOAZFpivAtGohulshpym/VDwcRn1JV1wXP8KhgfLPf+W2r28RB41wYunwE9qK+45u1xsUyH8S4sspU3nklKgCHIbZRU0mp/0HLg3mXnXGjeDQmjFbzppUrrdK/XcDUtpJYQ5mwbnzYPjvh1rin7jAD9/vIn700bH7QE1+m2Rnor2ao65wZ6L1l71FtdMPx28TvrTvyFfPOZfmEjhQAS2HhzfIX+iBw1Pq3f+QqP8knpAF6pl7Rjt+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ya/l7clJw6vh6zlCmc3x8CghWEV1gLPHER6lGbw8BbA=;
 b=4vfgjxQRQ76TXFGNhUdMFxk7YvMqXuYp7PVxgLrubjGJe4SBeXMUtk3fnoW1Kuu3nR04HCcGwp1bVH4VXERUnb9F5UyolOLUrsxOfntPbBYzmljJ5MKW2B8iphLhQhZ2dTMdiXTY0P1xAbgZrWiakLWqMVho4UrUgeyijwxUO1g=
Received: from BN6PR03CA0071.namprd03.prod.outlook.com (2603:10b6:404:4c::33)
 by DM6PR03MB3675.namprd03.prod.outlook.com (2603:10b6:5:b2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Tue, 3 Sep
 2019 13:06:44 +0000
Received: from BL2NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by BN6PR03CA0071.outlook.office365.com
 (2603:10b6:404:4c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2220.19 via Frontend
 Transport; Tue, 3 Sep 2019 13:06:43 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT064.mail.protection.outlook.com (10.152.77.119) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Tue, 3 Sep 2019 13:06:43 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x83D6boT024865
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Sep 2019 06:06:37 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Tue, 3 Sep 2019 09:06:41 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 3/4] [ethtool] ethtool: sync ethtool-copy.h: adds support for EDPD (3rd Sep 2019)
Date:   Tue, 3 Sep 2019 19:06:25 +0300
Message-ID: <20190903160626.7518-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903160626.7518-1-alexandru.ardelean@analog.com>
References: <20190903160626.7518-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(376002)(396003)(2980300002)(199004)(189003)(5660300002)(186003)(246002)(54906003)(110136005)(106002)(2906002)(7636002)(107886003)(7696005)(51416003)(478600001)(305945005)(8676002)(8936002)(356004)(6666004)(50226002)(26005)(2870700001)(70586007)(426003)(70206006)(126002)(44832011)(476003)(11346002)(486006)(336012)(446003)(36756003)(2616005)(316002)(19627235002)(50466002)(14444005)(48376002)(47776003)(86362001)(1076003)(76176011)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3675;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5484ab4-bd6e-4504-2ec7-08d7306f918d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR03MB3675;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3675:
X-Microsoft-Antispam-PRVS: <DM6PR03MB36756F40FAA2DA9130C12A79F9B90@DM6PR03MB3675.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-Forefront-PRVS: 01494FA7F7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: CL9cYAsPhWHVJRkTjkJjZxITKizh0JgQY3etoshXoYSB1n9wGuu0m7JHCW2ovxH11H/dK0Hu0ICB+iqWyMTynqpdecotL2Lu/IcvnKR7zUsLxJJHXf7V44gPsVxjmMQkIryDYf+XCID2VHxUQwSICP5l7hIk0BcCWCEeMX05qsz9lfwdzWF4vcHqc199yrqQKNN4Yf91sKUErDj8q0shpAFJRW49e5q8no7DkDBHbGK02NWTFPoMVloA0RzNdl0nf+v0GsAPd1gWeAPy41Sl+Pr0FQ8otQctcJANCJ4ig1DgZy3ViSA1fdp7KwmwDD/9VVzCQai04Se2nb1AFBGiZTFg0Tb3uIDq00jdMzocUCYdJTeYoU3xukyPtW+ITy14XyeEoi4i4Ps/wUf7uSSEryCm1o10zV4N+TpbgtXgJdk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2019 13:06:43.6625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5484ab4-bd6e-4504-2ec7-08d7306f918d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3675
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_02:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=968 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change syncs the `ethtool-copy.h` file with Linux net-next to add
support for Energy Detect Powerdown control via phy tunable.

Some formatting also changes with this sync.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 ethtool-copy.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/ethtool-copy.h b/ethtool-copy.h
index ad16e8f..8b9a87d 100644
--- a/ethtool-copy.h
+++ b/ethtool-copy.h
@@ -257,10 +257,15 @@ struct ethtool_tunable {
 #define ETHTOOL_PHY_FAST_LINK_DOWN_ON	0
 #define ETHTOOL_PHY_FAST_LINK_DOWN_OFF	0xff
 
+#define ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL	0x7fff
+#define ETHTOOL_PHY_EDPD_NO_TX			0x8000
+#define ETHTOOL_PHY_EDPD_DISABLE		0
+
 enum phy_tunable_id {
 	ETHTOOL_PHY_ID_UNSPEC,
 	ETHTOOL_PHY_DOWNSHIFT,
 	ETHTOOL_PHY_FAST_LINK_DOWN,
+	ETHTOOL_PHY_EDPD,
 	/*
 	 * Add your fresh new phy tunable attribute above and remember to update
 	 * phy_tunable_strings[] in net/core/ethtool.c
@@ -1481,8 +1486,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT = 64,
 	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT	 = 65,
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
-	ETHTOOL_LINK_MODE_100baseT1_Full_BIT             = 67,
-	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT            = 68,
+	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
+	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -1712,8 +1717,8 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 #define ETH_MODULE_SFF_8436		0x4
 #define ETH_MODULE_SFF_8436_LEN		256
 
-#define ETH_MODULE_SFF_8636_MAX_LEN	640
-#define ETH_MODULE_SFF_8436_MAX_LEN	640
+#define ETH_MODULE_SFF_8636_MAX_LEN     640
+#define ETH_MODULE_SFF_8436_MAX_LEN     640
 
 /* Reset flags */
 /* The reset() operation must clear the flags for the components which
-- 
2.20.1

