Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFB9B8B37
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 08:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfITGpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 02:45:32 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:30860 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbfITGpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 02:45:31 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K6gn0T016436;
        Fri, 20 Sep 2019 02:44:42 -0400
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2050.outbound.protection.outlook.com [104.47.50.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v3vb2c80u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 02:44:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6A7nQ1vH0Fg4q6jR3dWf9l1mgUE3Wp77DX+ZsSdNFwl5ZQhIxaRkBKaJ+re9WKJkyBfwvQS0KvV3NI1rlYh1G07qnIyM4jKmtI0XRQXh4yLnfRlYDiAsvEW3jWKkoStsV/Nw/5Lc0I/nZ9GM5dF6PtJ3GL5QreZpS0vrg9bEYeL3/5FMw4bnTcvfLbWJ+nSV4vPlQkPmYFG2DCzqBXA60P360NYQ45O2vM8+8OwExAMqDwOqx6KpjGpAgGdI0t0Nh1dUKCbnOoYQh2tDOzGpdMWRwFJSC1FwcfduYF4yTQUWlIwec1yGGOw4RefaGs/dUUEM9e4fyJOnV2BgvRNsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KTKnb4CistQOC1jAEEpjiAHVFGMl6wK+8OsCT+jHN8=;
 b=nRe2Zt4URF6QsHGsJjIVwPCWQLYpdDYDp6FQvsnfKvfBf4mbOpk9oDRmE5T55NybTs4f7FFk6dESvj2LwPH1/AIN+Iz32nXJO9ooqPOXbU9c8HIW3jYNFanifJ8AVksY8rNNVcv6khKszwmowyVwQtdVLWSLnE/p4DSrSkJpkTrHbqhzRow590OIlimKFaAmUkMfL9hjMDvWu8RTk17BBDbiGFUtouToV3q197FAIyAwDkz/j5sSGOjfJs6KzwBHQg5UsjgI64sqXEgkOd9sj4ETwlnAbFKpxVEaKpAcZrDh8PZLlSHbSSNtwwG51kIP+7iGAyjKeF0G4ENC+YeX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=tuxdriver.com smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KTKnb4CistQOC1jAEEpjiAHVFGMl6wK+8OsCT+jHN8=;
 b=PVzYh9zybwmb44EadxczT9z/ottv2gNeCxQQpUDx7np8TfgNPLgfuw4wNR1MIYdqjZyDjrD2LR+cdVcPW4ew+CPt8mNqorNPiJi0zX8FUtENloxAw5ryhlNx4WRuaQixp13JRMpU3bzsopGJRr9a9trrgngfOBiNbhcW5HECmo4=
Received: from BY5PR03CA0023.namprd03.prod.outlook.com (2603:10b6:a03:1e0::33)
 by BN8PR03MB4945.namprd03.prod.outlook.com (2603:10b6:408:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.19; Fri, 20 Sep
 2019 06:44:40 +0000
Received: from CY1NAM02FT005.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BY5PR03CA0023.outlook.office365.com
 (2603:10b6:a03:1e0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2284.20 via Frontend
 Transport; Fri, 20 Sep 2019 06:44:40 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT005.mail.protection.outlook.com (10.152.74.117) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2284.20
 via Frontend Transport; Fri, 20 Sep 2019 06:44:38 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8K6iW9O010387
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 19 Sep 2019 23:44:32 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 20 Sep 2019 02:44:36 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>
CC:     <linville@tuxdriver.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 1/2][ethtool] ethtool: sync ethtool-copy.h: adds support for EDPD
Date:   Fri, 20 Sep 2019 12:44:30 +0300
Message-ID: <20190920094431.13806-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39860400002)(396003)(54534003)(199004)(189003)(86362001)(2906002)(2870700001)(316002)(36756003)(107886003)(54906003)(4326008)(478600001)(50226002)(8676002)(47776003)(14444005)(5660300002)(6916009)(246002)(19627235002)(70586007)(70206006)(50466002)(8936002)(7636002)(305945005)(426003)(6666004)(486006)(44832011)(356004)(476003)(2616005)(336012)(126002)(48376002)(2351001)(26005)(186003)(106002)(51416003)(7696005)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR03MB4945;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75703023-b0d5-45d6-c929-08d73d960262
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN8PR03MB4945;
X-MS-TrafficTypeDiagnostic: BN8PR03MB4945:
X-Microsoft-Antispam-PRVS: <BN8PR03MB494568AEED01F5204B773550F9880@BN8PR03MB4945.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:261;
X-Forefront-PRVS: 0166B75B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: CtsugdeIJO1vWSP1N7g92xihXqW9FYo3BafQ/ZUCTUBRuzmWog3mBwX8V5Q4qpLhfGUDdLkRqlliqeqMWTJItrV2PKXl9Rzr3yNuJ1CkhblEKBHsumlbveCLOr4EsjZPAKFiafdt4FVncpAGmrNn2W/7d02NCZo9GTiWtvI6bmru/go+GXl+wifXsm4rnnJis/5CcCSh4swJFp+WZvAEM54inD3t5wjDmzhh3VqsrRUzPoYT5zduOeC8U8N5rehLHFeEwwhXSmSpbK4XUJjf3ryr+D506dyyFOcunOmVITSbcnxboqm8yoMgYD0oepjvkBpSlUsk/VTavLRE+ju/xT7xGWfuj82IH+0voALqcWSm32HSaRwyikbAhqexX/Qk8m1PKiDXgoaYLC6kIOdATyGqYpAmbNKDsKnALjbLcls=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2019 06:44:38.9480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75703023-b0d5-45d6-c929-08d73d960262
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4945
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909200072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change syncs the `ethtool-copy.h` file with Linux net-next to add
support for Energy Detect Powerdown control via phy tunable.

net-next commit:
commit 1bab8d4c488be22d57f9dd09968c90a0ddc413bf
Merge: 990925fad5c2 00b368502d18
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Sep 17 23:51:10 2019 +0200

    Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net

    Pull in bug fixes from 'net' tree for the merge window.

    Signed-off-by: David S. Miller <davem@davemloft.net>

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v1 -> v2:
* reworked the parse_named_uint() function to avoid casting to types based
  on Andrew's feedback

 ethtool-copy.h | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/ethtool-copy.h b/ethtool-copy.h
index ad16e8f..9afd2e6 100644
--- a/ethtool-copy.h
+++ b/ethtool-copy.h
@@ -257,10 +257,32 @@ struct ethtool_tunable {
 #define ETHTOOL_PHY_FAST_LINK_DOWN_ON	0
 #define ETHTOOL_PHY_FAST_LINK_DOWN_OFF	0xff
 
+/* Energy Detect Power Down (EDPD) is a feature supported by some PHYs, where
+ * the PHY's RX & TX blocks are put into a low-power mode when there is no
+ * link detected (typically cable is un-plugged). For RX, only a minimal
+ * link-detection is available, and for TX the PHY wakes up to send link pulses
+ * to avoid any lock-ups in case the peer PHY may also be running in EDPD mode.
+ *
+ * Some PHYs may support configuration of the wake-up interval for TX pulses,
+ * and some PHYs may support only disabling TX pulses entirely. For the latter
+ * a special value is required (ETHTOOL_PHY_EDPD_NO_TX) so that this can be
+ * configured from userspace (should the user want it).
+ *
+ * The interval units for TX wake-up are in milliseconds, since this should
+ * cover a reasonable range of intervals:
+ *  - from 1 millisecond, which does not sound like much of a power-saver
+ *  - to ~65 seconds which is quite a lot to wait for a link to come up when
+ *    plugging a cable
+ */
+#define ETHTOOL_PHY_EDPD_DFLT_TX_MSECS		0xffff
+#define ETHTOOL_PHY_EDPD_NO_TX			0xfffe
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
@@ -1481,8 +1503,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT = 64,
 	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT	 = 65,
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
-	ETHTOOL_LINK_MODE_100baseT1_Full_BIT             = 67,
-	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT            = 68,
+	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
+	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -1712,8 +1734,8 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
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

