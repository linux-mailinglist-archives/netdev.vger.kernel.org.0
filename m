Return-Path: <netdev+bounces-6170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A58715068
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC344280F59
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D461078B;
	Mon, 29 May 2023 20:20:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321F010780
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:20:05 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B0CB7;
	Mon, 29 May 2023 13:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOpC5pH/0qSNjr+UXRXcNDJDrAhJN80yuiyulntZzzPDm4fMuvuZbfRtdtmtEN5JeifCJrToMDopIMwlhZeRU3DIyUQj05xPnQp1OcXQFmI7uIw2iEwV/IRSe8B0K7pLGdLMSyoG5QE8YrKwbtbzykyu2Z95lymlP4O+ldLxIe4ujkg1f1fzT5ehRfl3PWVPygVqcfVLwKlZ8LoTG81DW5y4J0SPr8OmdNzXF3fMCS9/abKjx2wtgdbQ2iz5jcy5jGVgeN9PPFweNtAb9NY88sXGzgaDciX7Im1ZWM8EYiD4zIwf0Zgcib8HPxJzwLiph4PAqOa3K7+F9E9sb9HUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6rhKu6B8MykQQnV3BsVHwJJwxznNKpwTwyi45MSWfU=;
 b=XzzzxlMi3LoNPEU1PDhBjirAymL8H0qM9MosVPjngo6bDt6//SKNVlGW8s5ECNfaqi81t8hP6u7Wre74kKMCVd+N0hE+Rgeit91b5noVshna+YT9kBRJEancvHyYa2y5aAG1xFZnnLwmqjI4exux7PAoU2OuxuaB+9b7saV8ljmbm2kNFk/JU4eZlTg21lBEhtbvoq8aEYrOlVcxfS1GWd4UT0nos3Hj/nDt6cw1Elbt6w604HQxccMoAsy84OQccKN6Vh33bCXUkq8Jd7jWg9aI//HvCydmkVRR1orA3asfSSNigcFAoWwQs82cao7AseTrod6Wd07rU58f2m0Blw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6rhKu6B8MykQQnV3BsVHwJJwxznNKpwTwyi45MSWfU=;
 b=aAn8Wqnah3j20D7mPApfuolKaLIsJPeIpwmCoVkVjkM/YUkJ/mRsz/YqAEpGWL7y5EtWlkkaVmyQ+1c+ouUCk0XHvhw+64qk201osCwWJLUxLaNDc8iWRNN3+JtTlTXTMWFPgufCr8vsCFmEuMaadg2yTtBUTqKm9H/PT29fYKObqvFWIwTq3NQyO23WKcQ13Lfpo1ZPH/O4YaCWyyrTMi5IUV9cbdvlp8BUSgVG0Z42Sl39eWeNJUL2XGkeizjIdmJd0LaQI2HZSCb6puD68j4bSoeLDrwnmufGMzVxm5eJ1KCrEqCTWQSzg/ed1TaqA8OPbcyyIkf5OUEhwFPOGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by IA0PR12MB8254.namprd12.prod.outlook.com (2603:10b6:208:408::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 20:20:02 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 20:20:02 +0000
From: Benjamin Poirier <bpoirier@nvidia.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/4] nexthop: Factor out hash threshold fdb nexthop selection
Date: Mon, 29 May 2023 16:19:11 -0400
Message-Id: <20230529201914.69828-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529201914.69828-1-bpoirier@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0284.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::23) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|IA0PR12MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f2f2bbf-9f23-4abb-06ef-08db608214f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qKuTubFa7bkQ6YdEKIGhdUsCsh2GNzrniJI7SAVaWQtpg9zIjDkOvBrTD27A9XXkH6A6qcWga3WQ9xRJr83oIlq1KVWK+6awRCp8TDqjGcpJYrnyr7XZeLyhR7Z76On8+GR5+2pa3+6MpLcG9CAdIjRYjoZLggIcyUqnyYRvcAKwcTg4OzLVQcc/p+KV3l6bIRSyqVt4e1EhUYhjhSASf6/G+zRUysmufiC1+ITALJUiRWF+Z+zbBXyva/dTawK6GoEMUDipgBcW1jKISPhebXbh67R5rULrx0FI7Yk4T5SNniI5qUdaCAJ9MjaqpmKUrV+6Q3Yu6nbuS7HYkQ1aAbUCRf1aXkL095iaVX6dP0qjHP2jWyJRJ+HRNmJS0uP9xMBRcsOmd2qGTwUNCe7dFJLQzrq17hyRAAfi+cO6dmz4w67vxgQHAMoz+LmfApmNouubr6NbAaTsEhZJdcT80yKJpfMoA+omM11dIsPSJhVUK5s13wXLK5Onh/U/tcLlFaGHpZ2PyKMbeGoIwYxfTVsXJzBWcAZUqtYX+ApFxVb+CJLoY2luxkYPMGytdZ+d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(38100700002)(478600001)(2616005)(66556008)(83380400001)(66476007)(66946007)(54906003)(86362001)(4326008)(6916009)(2906002)(6666004)(6512007)(6506007)(186003)(6486002)(26005)(1076003)(316002)(41300700001)(36756003)(5660300002)(107886003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NpRUxTcHNij4y2XlDnfRt+n7msa+X1EEPWXF5iCsnPyMuEJdPBJle4dMkM8A?=
 =?us-ascii?Q?5b3MrRgu1Fuck0OuX0jV0DZZVSYmFIyFGLPkzHRz//SNYqTB+ecZ26sI2QI3?=
 =?us-ascii?Q?ZEg8jwenn2/nArhbeC7nrxFxJFc2SeDmIClfSMHvJN/sHzfcqeEXVE4cF8wX?=
 =?us-ascii?Q?e3dRgJ6oWIRNL/kFAr7t7IITHE3sXsu3oTmanS6GmQH2kogGt6Y/RF9TGcJ9?=
 =?us-ascii?Q?dUsnEm6LYhWG+8FZTbeD23dBViP2o0lneV+/IkWBSX3BB0DFhyM+PHUhHj81?=
 =?us-ascii?Q?dLpFposbdEAJaoLcZfIKMLIaW5zRzEQazSwmsXbxmXPo06a1IpWnclKdfMwf?=
 =?us-ascii?Q?8C1YsPoB2Wcv4T0/RADXSzRQbBiSWGeyjNy678R/JsLd8RAcz/5M/PDskPAn?=
 =?us-ascii?Q?R6lr7C2sjQbaS9QWm67rZlqN0U5hOrxwJOfgirNghmOZRoywKhqmNhcfDazc?=
 =?us-ascii?Q?pO+1tvoxslCIAhFEjw+0ieAa25vthpK5eBkre5hDFyCHIEUzOaQHERVEZmS/?=
 =?us-ascii?Q?n0qXDiq+L71QR/Vj+EQ7urKQSeONwlbV6iNs0M04K61B4N4TeVprfX2kva7l?=
 =?us-ascii?Q?7EaLdna1QG4Y3o9QhLXPPSzeGZLr/aLPqaZPgwH38JcyTsOMv2P9prDpcteV?=
 =?us-ascii?Q?uIq4iwVBay0xv54ImbDaHej60piG+b4EA05E2kvw1b8IOq+epPwwqxJ76s1V?=
 =?us-ascii?Q?W7kYKZvp12WIeiEEk1KxfWWBj5ji/vg60srKMVXa+APnGR6/mBCCV5/ktzcG?=
 =?us-ascii?Q?8SBU+CxtiB6HucL+YWoIipfQ2gKM4s8G9vP9OsUi4A56R8gJHnwIIIi1goKE?=
 =?us-ascii?Q?uBvt03dM+yd/0QbzihHYLEPRp2kRcKQRb6zyjiQHeC7E6j/RXXV7/FP1Owak?=
 =?us-ascii?Q?hRGopuFH5ZHmRRPVy59VoNXOUgIZx0c0H2OjliCbwP2HJ63EUUIxRhfbWLn+?=
 =?us-ascii?Q?PQ3OX0jSqPTo0zo42wfYg7XawPMSJTekuqTiIviKUAgaNzxrg3z3s1VoNvm8?=
 =?us-ascii?Q?dhski0cfslxe1QRGtPJblyjpv2rqdSZVYQ7aFzzTloBYcY8CyxaTsScCxGc3?=
 =?us-ascii?Q?8zGZZAgwWUBkkxhmHYDbah8jYH/zFP8m4U7dnWPtoxT+nLbamVFtgOFyuiMF?=
 =?us-ascii?Q?zSQNt4owm4nZx9FoiQGhkzNL2cz2VDbf4891PJsvQCVHTk/ym6ezTFKPp1Ue?=
 =?us-ascii?Q?7OXBeMHslRL3nglVP1+M5NCJTa61j+BtEHCHGH7Wa29nDQXnfKvEAOE6mSoe?=
 =?us-ascii?Q?LZTEA9oOyz8kDwsqDA0tpenhJ5PecAu/t7eLR+lSUv3F032gRoDiKeTkspMf?=
 =?us-ascii?Q?bDrdN7OBdPdjGh3Pe+nGRKHJ1mzibQ/yCTb3btZYAyAQqbiNfwbDWLzJn4AL?=
 =?us-ascii?Q?GKfbjHlI6SOiSgPcadDWWtynWg7w53p5qwO0GxEsxYaGccqc7PYzu97ZHDvl?=
 =?us-ascii?Q?31BLM+G5aJ9Aa40p5Pl6JHqBebd83H6f9StJu6iF/arh3ZM8VDq8n1ztoaw8?=
 =?us-ascii?Q?DvyBcVH3+HfsZVblBPifekE4BnP/Q16ELh70w6vAZskT2GMYGPTMHhswR1Z2?=
 =?us-ascii?Q?co1HhJR2CztfpKBLFr2L2gzYSYC30fx/30UJhbj4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2f2bbf-9f23-4abb-06ef-08db608214f4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 20:20:01.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Favrc+TY5Z9EAPJaz4S4D0Qqt/QjipjF6upL4oPR75gzIcBg79POQgW3IVOQB03hAkfXWlkR4eLHDc/pMfs0yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8254
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The loop in nexthop_select_path_hthr() includes code to check for neighbor
validity. Since this does not apply to fdb nexthops, simplify the loop by
moving the fdb nexthop selection to its own function.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/ipv4/nexthop.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f95142e56da0..27089dea0ed0 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1152,11 +1152,31 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
+static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
+{
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+
+		if (hash > atomic_read(&nhge->hthr.upper_bound))
+			continue;
+
+		return nhge->nh;
+	}
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
 static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 {
 	struct nexthop *rc = NULL;
 	int i;
 
+	if (nhg->fdb_nh)
+		return nexthop_select_path_fdb(nhg, hash);
+
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 		struct nh_info *nhi;
@@ -1165,8 +1185,6 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 			continue;
 
 		nhi = rcu_dereference(nhge->nh->nh_info);
-		if (nhi->fdb_nh)
-			return nhge->nh;
 
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
-- 
2.40.1


