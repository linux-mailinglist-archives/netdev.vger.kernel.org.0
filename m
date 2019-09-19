Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8F8B73B8
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 09:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388303AbfISHJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 03:09:42 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:6368 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387931AbfISHJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 03:09:42 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8J78KJK020189;
        Thu, 19 Sep 2019 03:08:49 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2052.outbound.protection.outlook.com [104.47.32.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v3vb5sfvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Sep 2019 03:08:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxJBdnpJwMFHRi256yEOuqJO2BGzJ2LiASUvN4buQ4HymjVc4LF069nxYS6/xWdZsnEolT0u30l803br1Y89Kd1otr8TdnLf/HH8NZNZ6AZ5wIv/Y/9tthi9OCOyB87/qmKosDd3axCC62ErLvGRNaBl+NWjyjBy506Y6ybpRHyUj4aARx5e3x7NWkDcQjSNWhTTmv9adoTVXcr2DgWYgnjv/771C4I9qlt3b6e8D9G7wyuHndyeYIjmwhc511GP+zX7ZL+e3LqGIGPUbs1z+BL5LNXzlt4ppdIlVkoCKkeQY5mdQk51NfvpUERWECQy65bhAIKzSqqolqSuzY18kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvcAATv+fDuGicNc8tfcAsjZMzw9c/hPTKqFtX02Lyw=;
 b=B6wnSXez55kt/5NtLv2XkARZDhPVFRKJLXjh6US3iB2pOD0q3ToExnISrSJyfxxD5GxiW4Z9Dx7yuq5/m8NrlzZAhx5cRMSM48nNtByQ6E6A4LkBQbXesZ9mb1gVwM/iS5TnNZUf+FuGFgfc55pCT2rNpyD4otUCKOaEq7imNgW4Sj0tUIhip4Kg4qOrGOLnGxFnvnPI0teG9VRyBiP62cWI0Z/7iEuA/dxFexB6GwBLOGfzMO+O/5pob5AzjqeO2lzjW6NisL3qY+9k5K9paoknemRE1MikTbca1NhVF3xBU4DpbHSJtm//GBlBn7DwCZi1n9Gc6X80DfMj9KrqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=tuxdriver.com smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvcAATv+fDuGicNc8tfcAsjZMzw9c/hPTKqFtX02Lyw=;
 b=XQA7noqypryLWjz4NaBP08UyfYBVNjkGwmn6FpP8F+v1crwm34JAyebUORzhCtQVEeG1vNfZBm02seld/HPmOmKj1x2v5+Nq5+kQSKoe6sSJ1rWbjDgR8hHSIvQrIQEQaQCwYxyJnoZ8TcIgZppu2OsTdDDNbvjUpoE1LS5Ubs0=
Received: from BN3PR03CA0108.namprd03.prod.outlook.com (2603:10b6:400:4::26)
 by SN6PR03MB3488.namprd03.prod.outlook.com (2603:10b6:805:3f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.18; Thu, 19 Sep
 2019 07:08:48 +0000
Received: from SN1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by BN3PR03CA0108.outlook.office365.com
 (2603:10b6:400:4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.18 via Frontend
 Transport; Thu, 19 Sep 2019 07:08:48 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT061.mail.protection.outlook.com (10.152.72.196) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Thu, 19 Sep 2019 07:08:47 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x8J78iVM010703
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 19 Sep 2019 00:08:44 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 19 Sep 2019 03:08:43 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>
CC:     <linville@tuxdriver.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/2][ethtool] ethtool: sync ethtool-copy.h: adds support for EDPD
Date:   Thu, 19 Sep 2019 13:08:32 +0300
Message-ID: <20190919100833.6208-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(6916009)(14444005)(426003)(336012)(5660300002)(305945005)(106002)(126002)(476003)(50466002)(486006)(19627235002)(47776003)(54906003)(1076003)(2616005)(107886003)(316002)(50226002)(8676002)(44832011)(26005)(86362001)(4326008)(478600001)(7696005)(51416003)(8936002)(36756003)(2906002)(48376002)(70206006)(70586007)(7636002)(246002)(6666004)(356004)(2870700001)(186003)(2351001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB3488;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2759b69a-19d7-4a7b-545a-08d73cd03754
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:SN6PR03MB3488;
X-MS-TrafficTypeDiagnostic: SN6PR03MB3488:
X-Microsoft-Antispam-PRVS: <SN6PR03MB3488F7DC3B171A32E3A54CB3F9890@SN6PR03MB3488.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:239;
X-Forefront-PRVS: 016572D96D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: GYTB7Ey6jVPhNcs5ZvIlhTaMZkuioMcsCCYVKRwTD+D1uS7+3Aav32I/74AyK8jeR/p52Ty3Mwl6dHwN5ewUeyk193sKFkyhWXoJEshlQNrZdC+1sZjYMlKV9G1Oy8QFlnOLfPZbYhFLm6q8yicYv7iIif78TP3qP2AjvLjaKylK/MoaRDCStnMD1fheDB10ngtgdL/55nfRYfsmCmfa9q6JSgsXlKRWwF6JAHMxJcdy0j+qXStFh/SAR+/hWOZRzByMBEoy1NCfPKlpIBkIpjDwBsaLXXiqBtvVGk5y5i7x+U1U2Zi6vPcb0ExYWWd+lYeJr7YxcnRHrs2YKRWGrJt96RKmc/vS+Cr5/y+UfvUIJmNi4lckvfqp1RAumpkZErfDEjzqQj1eUYOSBGao8yoh/UX1q4LkCOEd3UKpgVc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2019 07:08:47.4273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2759b69a-19d7-4a7b-545a-08d73cd03754
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3488
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-19_02:2019-09-18,2019-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=1
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909190067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change syncs the `ethtool-copy.h` file with Linux net-next to add
support for Energy Detect Powerdown control via phy tunable.

net-next commit/sync-point:
commit 1bab8d4c488be22d57f9dd09968c90a0ddc413bf
Merge: 990925fad5c2 00b368502d18
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Sep 17 23:51:10 2019 +0200

    Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net

    Pull in bug fixes from 'net' tree for the merge window.

    Signed-off-by: David S. Miller <davem@davemloft.net>

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
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

