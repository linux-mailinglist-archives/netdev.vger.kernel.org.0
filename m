Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F012EF00F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbhAHJvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:51:40 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:41348 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727924AbhAHJvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:51:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102]) by mx-outbound44-209.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 08 Jan 2021 09:50:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grDWStmmhpOwmg+vTmnOl+sJ6eRC7JcD61C11sm3ijl6Q1FoRnecQfMO0SFuDbu31YBabhEq1/7xq/FG2r7B65ohjeOlu5MxHRurn+NZmvLJM/02P8iidFDoFkPxo2d9v+q50Y+h2hKNfPzhmIL7OAjO4gA1WeEUaOazZYWxRYa+FaWb4c2WKy6CSUzVnAU30uUIaJjESzPeC9pv/7EfTfnWWQ8+RIdwXjKcaFJBquyWOa9Gb40OQLe+9wkR8R0ihrUgRA/Xsr9iqCLvLuXStz/HUkvzh2he0W3KAzCjcGPyG2Tm2cBl+5OldBdguF0HiHPw/2Dpwid45n8XA7RoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2HNnZkgaqJ8LzgJgN56hVdwKZHcQJ7wgzf3YfHNWgw=;
 b=Rs8TAfNjIKuNRBJ3USt0BuLNJ6UyfFjSABYbN93P98zWdLabGDn7uUQzq/RVqskwZd0rItdlhLSISkl5qIyg8dwCaX8hmTrFxMhbfNVpchbZcGY/HJefOfqStkskv+PUQQ3XgFStXsvbg6tgIFJt8Bv2lckFE2OIQt6hqNTCkUPIfP9k3cmb97DRb5zuhLMx7DVqnsafr12PVAzCHDFuEHtWoveBUVSNXYo6Exn/TdxUPovrvVFNh3wSqlEakp2zAqE4+22D2yzbaZyL5Glg3xtr4AWS0R4b38II8C5TRF9n7uEsArIZ8hvYfNIw2g74pCxWgoHEwr8hyDNT6e5u3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2HNnZkgaqJ8LzgJgN56hVdwKZHcQJ7wgzf3YfHNWgw=;
 b=Epd0AX4CfRI+P2/nT2PsM+JitNH5GHoXvCxQRf4RPWSMZEgxNwfPdmqQJUpmPHVr4IM3tYdXuiDoKPCgp9aNkyopcet6O0bu2FyNWO9uMvqfMZhk6VIB1RKIE1A0JQB29orVkVm7fgFbqHzX1LahUTGT33LSvzlIVNTEdhtuWo0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 09:50:04 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.009; Fri, 8 Jan 2021
 09:50:04 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v13 2/4] net: phy: Add 5GBASER interface mode
Date:   Fri,  8 Jan 2021 19:49:28 +1000
Message-Id: <422e3ae61ebbfd85d95201e63663a22c5301f316.1610071984.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1610071984.git.pavana.sharma@digi.com>
References: <cover.1610071984.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [203.194.46.17]
X-ClientProxiedBy: SYAPR01CA0008.ausprd01.prod.outlook.com (2603:10c6:1::20)
 To PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.194.46.17) by SYAPR01CA0008.ausprd01.prod.outlook.com (2603:10c6:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 09:50:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d58147e-b48a-43af-73a5-08d8b3bac665
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47894941AD9E73080C74C67995AE0@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VYMZddvkVS0PHXKmDW5tqEqG57KIuJRlinElcYWaoB9hT2HY9D/zxaGoVw5LU+d79xEs1fTKB1KL5BduRfyhphLhbs5UzUi2uzSS1TlLmfzXfLaLwEFLIfW/53AZz0Rk9nLR7AtQRTLUMYUfvbf+wYwmGygeFqMyqN0N+og4FZ37LdD+ypxKGJaeOfVRAuTPoTqU3MKDNgouVsO9jZhSDzHcawIGshcup5c2du2gjr1Xv0cgP75+QsKRoGYz4ooLv1m9NjKtnZrhlh0uw24V7e/ZENBxSE8SClGl9ifTpPGo0wY88ovy7YQSz9pN6jKmhDS+WwYTXKtuU/+/3VLush1TWjEihrUnomICSeI8RiKXNAFchHVDApKv7OW8Ip70uKh/hhoW4S5h4hJUhMBWDX7u7NltsxLexv/yI9eIAG5PzaUqvOyqma3230q0EauX9cIkXoX87+hRmdb6gCKvwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39850400004)(346002)(2616005)(16526019)(956004)(186003)(6666004)(6506007)(36756003)(26005)(4326008)(6512007)(6486002)(44832011)(5660300002)(66946007)(66476007)(66556008)(6916009)(316002)(86362001)(2906002)(8676002)(69590400011)(8936002)(52116002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A/gyIKk3N33e3EnGczZPoiwuyjoAkFwzKcR2UQYi74WVRrE95pNjNUEmThtB?=
 =?us-ascii?Q?REbFK3T0LXAG/EERxz8oM9+gx4UbrKUptv+hl1mKfM1umFWrEXDJ91LB7Wta?=
 =?us-ascii?Q?A+RCxWyRxFEmPhLJFeDYzZiGQCTfX+VljNrZwEirWirEuf2Q8GzJXeiHvtst?=
 =?us-ascii?Q?UK8TRCz1nVSvP3+9V5pfVuZQSVihui1LCT9VBVZ99lD+rBw2YdRQ3QI6j2yv?=
 =?us-ascii?Q?8VSO1bolQXL7Z5L9ScfKTJ8G3+yKbbWjIOJcANY2rUZXAewQOG9EPmDVqIHu?=
 =?us-ascii?Q?5ClQH6OLEPV1hK5VLoMvhu3q/BSpXihDCcEPD3roTA20VlnOL1lFXi8uFpz4?=
 =?us-ascii?Q?0YByWevCJfHJ71Y37HtQ3Q8qeOzRfwsINP7+gPbMAa7bucFOWyLw2ahaPXDf?=
 =?us-ascii?Q?pW9vAq9hH6YnG3TSvTL4mNn/vIZzwWugusrZPx5RbwUIrWFCWBuFiXH5ZIwj?=
 =?us-ascii?Q?N642gST1JyhZyh1dR9FdsFqjUUpv4zq0ZZ8LUsxwf3ryWcqAcfGtaU+t9Car?=
 =?us-ascii?Q?IBRNNjsw6v9l9EdbQIPlexuHrB1Qv2RXqDe8xZ8xDCwbpOCC47rRiZwJaB+P?=
 =?us-ascii?Q?vITNwEij+q53nfhKiMTOiJ1s67Xm/uyX8Kxst/osIaGMiX6JbWLdpxo/P/Pz?=
 =?us-ascii?Q?d/bP2ou422jv3H57vvKS687WgCr4K6PbtKE3IjmeZM5QBysH1+1/yEaJlWCx?=
 =?us-ascii?Q?hck+/QIvsk8OoY8mxwRjLCqzCbqlFplYvULYwrf114vt3EamN+KdR9CvmCHt?=
 =?us-ascii?Q?7sfTwBweGN/MNE9k0TeY9M0+R1n2a0WSwLu/3aH4hA7zPa18miN2X95oWfVZ?=
 =?us-ascii?Q?mgzdgHsXPIISRCxUYKqafdpGwgYWm/VoqWEgwZcKlN95nAcZ6Y/fjOpw0cEP?=
 =?us-ascii?Q?cy17wyG6mIZI0Ze5dKMhlbUFxL/u/wjZYqMPO+CRiAAWyRScoMx8n6ROHMex?=
 =?us-ascii?Q?bPsd6aO4huS8Uz6OTDU5TXQCtWyKAw+7V3WFgVvMfRkZvw4mFvBNHhZJ1q46?=
 =?us-ascii?Q?H+ce?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 09:50:04.5636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d58147e-b48a-43af-73a5-08d8b3bac665
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BHfiGo6MoA+KvMo8qIpATIkZ1ijrlFADQT+h34qNuu5OgLm5urFfSYVW1DmjHxPf2j0b9f23QDCZt5waMlYfng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-BESS-ID: 1610099440-111473-5637-28430-1
X-BESS-VER: 2019.1_20210107.2235
X-BESS-Apparent-Source-IP: 104.47.70.102
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229399 [from 
        cloudscan8-14.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9effb511acde..548372eb253a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -207,6 +209,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.17.1

