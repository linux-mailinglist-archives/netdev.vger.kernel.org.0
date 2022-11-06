Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F3761E1E7
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 12:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiKFLkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 06:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiKFLkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 06:40:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911B1E098
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 03:40:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5xTIiBaowwsM7g8GRM9Q6qgtX+QVfRGfWv3hTlCqW2xhWx0af2Q72av99KGzqIEMDdd5OO/hSLO8yukA77vSO3EdQ1v40PMDI7kwt00qLu+huv8L3rAw6wMt2aiyaQWf4/q631gadLtzJBdcOhugh7tfEnsUMR132n4cCljKZY7Ea3XgZhaRcbIT6OX2ztd7XgLzJgoPqWoV0Dwxfq+s4FyadoO8e4bfXE7V2vBPRJX4g7NsF1V3JCclft+LYXGweQiFEZJeMRm4fOJrSGCm58Z71rOroqwDFEvOFNhUJjsZohpsFlo78JmkugTzbevgHAoHQDuuZoWnGsHRyed+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcAdvibL1moOGRW1c0HhXUHD+eI6M/qRq6sSrJHYSeM=;
 b=ItLHPEB+DgDvlkgxnZ3SkYb9+CA5+eg/tRqjbma9db5QPwi6bWwnmBnHy2F2Z1Zs17Sbz99MhiCfM+RzANXD5PoQ9LlWdP82lq7bEx+Q/zl4FMDWox6n7BBjiSnyYXvSFBWgCxr3S4GZScy/LmlOPHTlyTDUyriCAmdmBU6bkOr+SSHK68XEbs6coSU6l9gdTTv6l4XX8ZGKT6zQAi1aTBNJzVsSNcou99HTkY8t7d/UQPhN1orOn0Rcp2oLBVB9of8GIKsEuwjqUl32bkwLKniToNKVINrT7RO0uYCXV5dsVJvSFmnEXIKRMyxXrW5cyT/E8xaFa2g4QyjM497yZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcAdvibL1moOGRW1c0HhXUHD+eI6M/qRq6sSrJHYSeM=;
 b=nhIJjyS5rAX5r5teXjQ1Aq78qtQHGK3KIFyc62gFuFBk3viA3u6mK8not1rCz3HdUBlf7qS1RSBuNK/RZl181sTJOKKJbXxJlCqLK1oc8Y8VgVLvo8YGAAMPkE0EnLVjFAFkGLTwxDYc0G4FQTCiOEvJ8EnGgFVICXw3e1G/jcZ1QYRhJE+qHF5SJYZgJkl1QJvkXcjtQgVKvqN+xTCTCQxSPzxxu+vniJEBscADKBtocmkGW2ftOAMWwZhPSv/cp4XuqC8Jj/qKHXkMUOeQ9qLqADdo5VUFFsgB2KAOsMGpuqRdnc1UUtxFvkSP3SNuyJK+auUuKkuQrcpjvHXVaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 11:40:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 11:40:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 2/4] bridge: fdb: Add support for locked FDB entries
Date:   Sun,  6 Nov 2022 13:39:55 +0200
Message-Id: <20221106113957.2725173-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221106113957.2725173-1-idosch@nvidia.com>
References: <20221106113957.2725173-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:802:2::44) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 8424679f-0f20-4961-0633-08dabfebb90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqfrOO0/w/3wZdykqL4PUKz2nHDzVFriMtSWMGYhpGBeBj5aT3LaHlErPmMQfvO1EtyJLNA7TsZgWdcO/In5+a7q4X50rnnqLcQnmoWUL4+1XflgEcKa2nYZ5i3RVRgE45qNBqMRl1fYrEaNswbVQmeguoTamU8gDxTTIos/MK/bIFCxPICeq8SzW5zDr07nZgI8r67np9bmgrddxPVKoVPy/PISS1mVigGLsscrQq1h6gQ6TCNm3DbGl8xLj3mT6yZYZ3zk356AUr13CLX7/gPF3Q3QAFcqm0ZLaVJcosDUhPEQVrMMnhraCrCc2bwsAKJCTbn7cDPJFaWSw3Wh5wEPagdhZZifodixio/C4itRpXFDw2197Fw7hvbV4R1aqv/GZv9M9yTWs4Ju4mc6/NaN3IHQPVPEc6BVW+LUyz/1nWfTrGU8eAW66D1/oDr+Di3SQJ0zUyQLkWWgQ9K3hV59Cxyii5Y3kNGR4UY9QyRAJXeihWVKGCHVg8Bg3duOfjD2MIlEdIHxLDfIGsL7AidD3DONpiaVmQwrnlnjsWkJFUNMhIlgX8I0/zLb5OVh6X/VlmCzaCZbFkCpzhza9gwTpADjc/Qd2gkTU5pfxMf3prWAd5VWGMcFBP23VtD6rnwwJo1DOAA4aDkSwn9GDxUMed04Zmv+IfkOWXhOR//cU3aKWm2I+DH5kfUEHfgOTZZako5+cY4LG75BKMXBAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(26005)(41300700001)(6512007)(6916009)(2616005)(38100700002)(107886003)(36756003)(6666004)(6506007)(4326008)(8676002)(86362001)(66476007)(2906002)(66946007)(66556008)(83380400001)(316002)(186003)(1076003)(6486002)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8UR3c6MjXE268sa0LoJiWjInJof8lHsy3gSzJTEYaag2glU335WRPrbRqo8T?=
 =?us-ascii?Q?4lRXqjwZ2iRAmmShK0F34TBDuGVVcwyyGdb/DWuaNftja+bzaqo/YdjgzzoQ?=
 =?us-ascii?Q?OYrVMeM9u+28WQVjf5yhQb4IfvCmQmVF1Kintb3Kt+nH27SuAeQ/6UokUb2R?=
 =?us-ascii?Q?edh5qTQv4cBMnmgM6vUGVrrxFe/AsLDskcbAMBwIoN/pG2Ig468ETwpRa7TC?=
 =?us-ascii?Q?TJmnaK0CvB9eMlNDNYRizxljhxbBRsTo266nSkCC0R2UVEwgDqCI9MA0FAXj?=
 =?us-ascii?Q?mZkwUMP2WzGFzAMC9SSJEQX9y4sCX00+WStuDENcZ6YZhx4YDrSk+FFVytQ3?=
 =?us-ascii?Q?s/LvXPdurtU4VG57AtO8yVz9rzxEGSBmW66B3BcIY+V+SuePe0svYHcUY/M9?=
 =?us-ascii?Q?RRxZvdYuGoCsHA3gp7bghu7Q62Q98jX5K9eiFwRiDnJQXc9rNyYKzjYaTMGF?=
 =?us-ascii?Q?JhtWlcOQ8tbawQCgA+Xbz6KI+nRvbYGf+azqpsqCV9drX6C1+3DreEG0Yxj8?=
 =?us-ascii?Q?R7clMKvGheEfchynH2nZh84xfhTwQkkUL/aj5Rc0g1y0PHXhUgCHDPmPOniB?=
 =?us-ascii?Q?FdCNn2vGOUygTAO2Y9gdW9W+em+PV89aAnFGNFGaH8EgQEXcoQxDb6Dxjydl?=
 =?us-ascii?Q?v7weqCWkrnVWbw9CVxqIlzPTOJThiz2/Zy84dJZ2UGGESzeWq2poYTZOI5Mg?=
 =?us-ascii?Q?XzyfztY77WAQZQ/4OF9cNJIifqgbfC2btQipz7MX4fCCi4TTQ1MA13IOWVrQ?=
 =?us-ascii?Q?9Uy16Ylm6rYsi8aQK8Mq8PwtvSvy8dYPehwQYeTDx1n5WplbpmESkbeDVxLz?=
 =?us-ascii?Q?nI8NKr4wcmz6U/an2X2DG9Kk4k9BYeHvNTmb/0BM6Xo9Q04AqXCk+omvuKai?=
 =?us-ascii?Q?58Efmn/2+RdrmGBR4E2KSq6+5nUpXDfJZat18fel3LIFrs2X6HKF1Pjr3Xk/?=
 =?us-ascii?Q?pNm9O0xKCBS4ih6VXL/YW6bsac1H/ZchkrOKjYoT/CUs92lYAU/YJDA3fmj/?=
 =?us-ascii?Q?B5PE2TmIApQZSF5eNqRj8Z1GJ6hNGK99uBEr8kSQoVSl8hk1t5xUkYE4OgY1?=
 =?us-ascii?Q?Qj6E1g1CipfNf5Uipx2JBhO1JmiNMzWFKS7n+cnKqOy7DnkqaNGpj8pAJzSq?=
 =?us-ascii?Q?DsTWlAf51IyxtnGLqmCHOVPKMBxIvu32k3CYr3c8B/79dEgE4Dx0hJwFgPsS?=
 =?us-ascii?Q?onzzlJhRF66O6OkJdiMsGdBP7z3MjqOBqUDNZ7HeFHI4lbANGMP2RK2sX0tb?=
 =?us-ascii?Q?f03Fn1Xy4xx0tvv8Gbt5568CY/FF8jyBGlNlNBAdfuSxPfnajoUO/jnyFCyS?=
 =?us-ascii?Q?Ya7mxKLKJQL389YJ4oJm193VnpuekMPdpZaMEpQ6Rh3yVeYNQbWyCtmKJNyV?=
 =?us-ascii?Q?Xs9NRwYmQX9OAP3f9nEliTJ+VzROA2m2qTB7ARASqMMswhcHFSld+sL+q0uA?=
 =?us-ascii?Q?fjFh42vxx5Mq4vNuNj4ZaFu/7ri4cWeWS/4J/w83R09ZkyDbjhM4Smm7Msco?=
 =?us-ascii?Q?YOyeRR6D6k8j7wGk6tdB+E2eoGIAU06Cm4d934bhU/hNBUJC4HJM/lIyEn6G?=
 =?us-ascii?Q?6Vxyux7kg0q8iQt2LFx3xQnKWwTU+7bpl01r/Vfc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8424679f-0f20-4961-0633-08dabfebb90b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 11:40:37.0167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oCGn9yfZWGPiS2T2N7Ys3FrsLmPvvYluDn8HsTEkgxfTGOx1f2K1iUrq0h5yab8909lJjedZ2bQgU2ZS1f9icQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Schultz <netdev@kapio-technology.com>

Print the "locked" FDB flag when it is set in the 'NDA_FLAGS_EXT'
attribute. Example output:

 # bridge fdb get 00:11:22:33:44:55 br br0
 00:11:22:33:44:55 dev swp1 locked master br0

 # bridge -j -p fdb get 00:11:22:33:44:55 br br0
 [ {
         "mac": "00:11:22:33:44:55",
         "ifname": "swp1",
         "flags": [ "locked" ],
         "master": "br0",
         "state": ""
     } ]

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    Changes made by me:
    * Use '__u32' instead of '__u8' in fdb_print_flags().
    * Reword commit message.

 bridge/fdb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 775feb1296af..ae8f7b4690f9 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -93,7 +93,7 @@ static int state_a2n(unsigned int *s, const char *arg)
 	return 0;
 }
 
-static void fdb_print_flags(FILE *fp, unsigned int flags)
+static void fdb_print_flags(FILE *fp, unsigned int flags, __u32 ext_flags)
 {
 	open_json_array(PRINT_JSON,
 			is_json_context() ?  "flags" : "");
@@ -116,6 +116,9 @@ static void fdb_print_flags(FILE *fp, unsigned int flags)
 	if (flags & NTF_STICKY)
 		print_string(PRINT_ANY, NULL, "%s ", "sticky");
 
+	if (ext_flags & NTF_EXT_LOCKED)
+		print_string(PRINT_ANY, NULL, "%s ", "locked");
+
 	close_json_array(PRINT_JSON, NULL);
 }
 
@@ -144,6 +147,7 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 	struct ndmsg *r = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
 	struct rtattr *tb[NDA_MAX+1];
+	__u32 ext_flags = 0;
 	__u16 vid = 0;
 
 	if (n->nlmsg_type != RTM_NEWNEIGH && n->nlmsg_type != RTM_DELNEIGH) {
@@ -170,6 +174,9 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 	parse_rtattr(tb, NDA_MAX, NDA_RTA(r),
 		     n->nlmsg_len - NLMSG_LENGTH(sizeof(*r)));
 
+	if (tb[NDA_FLAGS_EXT])
+		ext_flags = rta_getattr_u32(tb[NDA_FLAGS_EXT]);
+
 	if (tb[NDA_VLAN])
 		vid = rta_getattr_u16(tb[NDA_VLAN]);
 
@@ -268,7 +275,7 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 	if (show_stats && tb[NDA_CACHEINFO])
 		fdb_print_stats(fp, RTA_DATA(tb[NDA_CACHEINFO]));
 
-	fdb_print_flags(fp, r->ndm_flags);
+	fdb_print_flags(fp, r->ndm_flags, ext_flags);
 
 
 	if (tb[NDA_MASTER])
-- 
2.37.3

