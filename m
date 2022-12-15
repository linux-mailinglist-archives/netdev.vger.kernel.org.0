Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C9A64E011
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiLORz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLORzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:55:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024B446678
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:55:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZJ47OIMfvDlmTpYkLtsLpMJPougeQPfo2z3iEXQqmCFQQL2jFxHj+CPOlheUUTYjJ1pRGy+pw8M+0j5OV27WH65RNEDm/a8P0m275J0JoWKu22fVlf8+YnXd1My3X974Wb/xS/4wULOEjdV5Ri5lixw706ABnMyoN38FbztEDGODWFQ+IV1LcuzJiOAM+bdjRhqRzdESU2zQOJVJa3Wxprjq4VRxqJVo/pJAevNsTi86pbk1+W5MqTMJha7X6UyzqyREYdOyNWdIs4jtP7d4kLuIo/brmW5SyDuHUSdQAlc+ulDJhJCkOU1lRrmO/vcS6RLcm00toCXnpH57kNblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPXMHPAIew2zmB0QuSopnSNB+C1jOYeYPtaVPQWQ0/8=;
 b=fJokZSYhbSoQyN0G4E6fuWHxyy9MV8MTVQneGXTgFgMe5AL7+UWkFkPmYreQSFexEuaAVhLmMf1VAq9qpNQMWTaJDP7xOZMklORZDX1bghp8Z+15W4ER8T6lvZpSi7q4enY1izmj/8DwV5wvCj8KNkxVGrf0QSDEifuqOBTnu7xvRpjncQFR8fGWHugsK1cQ1NzHvc1KU16TrU7PF540stMnbSkBWIPrQU9GthCY0bRHJ7HQ1n4BZzcNNtPU+P8I+LEhThrcUzsmLjeFvzQJ2zVZInjxgvWBhvvDbRvK7V6N2EOgOeokMMwZYpKGxswrLdr0dK2NOCxjKyOwYzAvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPXMHPAIew2zmB0QuSopnSNB+C1jOYeYPtaVPQWQ0/8=;
 b=VMSqOTbBglq/cQmWzGpIQrLtucB99jl3XzY+Y0m3Cu8dmfJaZ/lyujgIO/d96FGGdXlHcl0Je6qk/qXaJOdIx5R8iPj3ER/DaMrSt/bBSQTVxhVmwhI9HLUcJiI73rdn6d+//YUmAU8H8FEomOrcC8LKksOYsK+/SEOXeg5zP+A1kxJAV6EHp4GFPOIk/appa3Ix53rPUIkAZSyL4NH97ngJlEjWnWskfoxogxR1g7BAILZdWksOqBzH5+uuHikaT4csM5kYwFb9qlHjZg5d7KMAE7J9PQTWjXEw2HjUn/mUHVekyhmGOrzwsyhZRXkVqtLu94x6RgG4abBs3Q685Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:55:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:55:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 6/6] bridge: mdb: Add replace support
Date:   Thu, 15 Dec 2022 19:52:30 +0200
Message-Id: <20221215175230.1907938-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
References: <20221215175230.1907938-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::41) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: cb09e16b-de98-433a-924e-08dadec580da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZndbRyWQN66UzYnoZVl4lHgjr5+ARhVfnUaAOW3JacR/sMzCTOlC5HXApV68D8lR1l/sa2rLamIbVElEsR78zgz3oczIeiIvcOzdgb5NElnM7/oaQQ868LNa0UuhoF5u89RWe+1+nOJe6okLNrNiQnns9Ll6FXWwvr2+qxiapo84h0XzdF65K/zKWTX983kj0G+Od6P7TQOguraQafarXNcG7nGu8sdWPQFHAujuqCsJiS9aeKKDIq7OG1kixVlREzPBeYeAtFG3iRka0lM1iF0IthHJjbzmxh/WZKPir9e0dwfs4Q1BmxSekJ5Ck4GWT5hQVzHHQc6G8Y1aL8WjP7FuWvuOHSO7XWcB5GDXQUHO7xBO09VQLX7gCBnnNHffTsW7n+8TeIlNeQSoE6/uIYIiVs9zqqWvCVzEk+5aRz93KncQcanPl7DI1XLbWCQN+ot9b5fGCyMxHGvRTmuug/So9bi2tHz8xNCfO4AyfPCccxwa+KNJ9enUNnCgAHvuxkpmOBP9Py7JpWaECnEdp9llP1G1LBoKPXU3eG6lUJR5YK2ObRmH+Aha7MfK5+IBO/3oB8RYFxG88ipQuBscwTuyZNVX4j6LxRnjVX9tLRSmqzcc5gfaWefRQ32WKOcTwCtpdAB9xck5Pvw3P3IcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(6486002)(316002)(6506007)(26005)(186003)(6512007)(38100700002)(478600001)(6916009)(107886003)(6666004)(41300700001)(1076003)(8936002)(83380400001)(5660300002)(2616005)(8676002)(66556008)(66946007)(2906002)(4326008)(36756003)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ArxUYYbT6fnQ0X/csUA4HeUAj+cI+X51X/xtYBlUCOHq5AJyOfezjETSJi+?=
 =?us-ascii?Q?iSqMQQ6hExrDc03Zcbp7V45lldrpSVo6Zpn+9U0VR3weJMYNpdIV05BM20ku?=
 =?us-ascii?Q?KuyNdH/c/Tah1A1Bg7HuRV+1+aD5owYZgRMkc2YWknYIetanQFD+nOO3Ecmo?=
 =?us-ascii?Q?S7ZsUMBoQ52ubUbcfOwgaYShcomwFgFgGGD7IzIJ3W7WywODgLvPVer+mehK?=
 =?us-ascii?Q?f8ZDaKDNGNNU2FCybGRSS+FWwt0AxYi3EKGVZkudcejYCM7RVp9EHlSR5QMf?=
 =?us-ascii?Q?fgRLi80BI7CK+v3Q+O53vHGC7gBl0w/HCdHFvtwr9bw3BysrBsXY8ZpvsNWA?=
 =?us-ascii?Q?5dknJkdAAsM81dK/7IHZtHrQFg3m721ZL18xBsJPwjlGCctVkPozYA2vwANp?=
 =?us-ascii?Q?KLW/zBfDr/UNVxQ4By5Y37kst8JLhnucAq109AIwYz62WLGvRyC2duS95Blw?=
 =?us-ascii?Q?c3MNy/W172rtApPIJUU87Znzj0rx+moIQ9MiJdsMRyHSH/vbL7Mt6jhECSYI?=
 =?us-ascii?Q?4o/XbtS5J3f4ekneVaHl2NrofXcsopOLRjvMSXZKMyZ3dqdb6JVOdTcBNtbQ?=
 =?us-ascii?Q?lLeZBfgyVA9yadD+mMFDoPiRdxWR3jTHhWdgkHqYIW5S5SJr9ImUoGRtzbCq?=
 =?us-ascii?Q?xhanEOywyem3UMOtYfRhpp79OrA6YDV2DdrDgpo5Fsv+gSSGuPsNQZxjcxGf?=
 =?us-ascii?Q?OCVAkOkzz8Vva9nJxsrTQcWwqbF2y8GFszyPtbL38sYmZC0roryGPvVjVg/B?=
 =?us-ascii?Q?uZG+BnyyhsRlBKbgeDixzp5RPXGCTdk71JQwGmgz/ci9pi39H0S2j4hX/H+d?=
 =?us-ascii?Q?vOl1VJSh20oW99XM0/xPLuZM2cwNCSrnzT362d2PM6lfNxag6Xn2mzlZ608s?=
 =?us-ascii?Q?f++MKZMFRN7GFBIbQx1Ruun2m1CNg1DhBLS9IcS+GB8DM+uw9P3+hUQQifhn?=
 =?us-ascii?Q?sb5O1Y7MOkZk+dlI/ET5WEQRxPfDzSFl8cpp4iZst7F3MUNy43lPesYajV2N?=
 =?us-ascii?Q?2HrtUdS7w5i0+cSFOplZloz8KR/s5r9Ysc/EsXYGx9JUTY1z82Utowfb6ekT?=
 =?us-ascii?Q?HzrcQmmrnFPxOy165s9S4oW+0DkQEB2SjfL4YvRt12au//1tSAuPb+GVDKx/?=
 =?us-ascii?Q?4eyPdLCxf/8XJbhXK153JIcdhEmyz/JHX3AtbRmlijSa0RWAsb41ZgQDygfo?=
 =?us-ascii?Q?ku9LgrV3GyymMukzCOHpgWLB8HYZ3pFqKlmezHNVHeNnEZtigvrh19ggOkZ6?=
 =?us-ascii?Q?pQhzepB2904ckuKj4PHlx87Xws41LyukJxIBoZoaHs8Bb8JHkGaRE2/QyJ37?=
 =?us-ascii?Q?nMCRmmBrH72ONNwq3XXkm+99SsVu2iaEuUZINNjmLuDcx8JIb/dlLiQl1dES?=
 =?us-ascii?Q?gk/hyPYdH6INw8wNGsaRo9nIYB6zApmXMzW1ZNFstuTtR6kktnbm/yAW2hhe?=
 =?us-ascii?Q?nvpEhsjMziIdkbFVlySxtQBnQT04ET6vLlwk7N5QPnB3zPdHjbFm1CQkvmOe?=
 =?us-ascii?Q?QnbbKNtGvusMJJhOVadrEHHbFGSxKGvKxNv+9CH0ukGnxcqzNzYsUTnRr+ob?=
 =?us-ascii?Q?VEII01U1NKqBpr/MYypWHV9SxhiFN8HcDcUqcO0T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb09e16b-de98-433a-924e-08dadec580da
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:55:07.9015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcp2v4YG9ZdDfT0+QmyupcfYFx/PH0XUyGE3hv9+HKsRu4bm2eZc1xk4Rfh2J3pAdtRYG1o34wKfPsPQ5aNI4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user space to replace MDB port group entries by specifying the
'NLM_F_REPLACE' flag in the netlink message header.

Examples:

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.2 filter_mode include
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.2 permanent filter_mode include proto static     0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto static     0.00
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode include source_list 192.0.2.2/0.00,192.0.2.1/0.00 proto static     0.00

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.3 filter_mode exclude proto zebra
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 permanent filter_mode include proto zebra  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude source_list 192.0.2.3/0.00,192.0.2.1/0.00 proto zebra     0.00

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 temp source_list 192.0.2.4,192.0.2.3 filter_mode include proto bgp
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.4 temp filter_mode include proto bgp     0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 temp filter_mode include proto bgp     0.00
 dev br0 port dummy10 grp 239.1.1.1 temp filter_mode include source_list 192.0.2.4/259.44,192.0.2.3/259.44 proto bgp     0.00

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c      |  4 +++-
 man/man8/bridge.8 | 13 ++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 195a032c211b..f323cd091fcc 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -31,7 +31,7 @@ static unsigned int filter_index, filter_vlan;
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
+		"Usage: bridge mdb { add | del | replace } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
 		"              [ filter_mode { include | exclude } ] [ source_list SOURCE_LIST ] [ proto PROTO ]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
@@ -692,6 +692,8 @@ int do_mdb(int argc, char **argv)
 	if (argc > 0) {
 		if (matches(*argv, "add") == 0)
 			return mdb_modify(RTM_NEWMDB, NLM_F_CREATE|NLM_F_EXCL, argc-1, argv+1);
+		if (strcmp(*argv, "replace") == 0)
+			return mdb_modify(RTM_NEWMDB, NLM_F_CREATE|NLM_F_REPLACE, argc-1, argv+1);
 		if (matches(*argv, "delete") == 0)
 			return mdb_modify(RTM_DELMDB, 0, argc-1, argv+1);
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 3e6e928c895f..f73e538a3536 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -127,7 +127,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR [no]sticky " ] [ " [no]offloaded " ]"
 
 .ti -8
-.BR "bridge mdb" " { " add " | " del " } "
+.BR "bridge mdb" " { " add " | " del " | " replace " } "
 .B dev
 .I DEV
 .B port
@@ -898,8 +898,8 @@ if "no" is prepended then only entries without offloaded flag will be deleted.
 objects contain known IP or L2 multicast group addresses on a link.
 
 .P
-The corresponding commands display mdb entries, add new entries,
-and delete old ones.
+The corresponding commands display mdb entries, add new entries, replace
+entries and delete old ones.
 
 .SS bridge mdb add - add a new multicast group database entry
 
@@ -964,6 +964,13 @@ This command removes an existing mdb entry.
 The arguments are the same as with
 .BR "bridge mdb add" .
 
+.SS bridge mdb replace - replace a multicast group database entry
+If no matching entry is found, a new one will be created instead.
+
+.PP
+The arguments are the same as with
+.BR "bridge mdb add" .
+
 .SS bridge mdb show - list multicast group database entries
 
 This command displays the current multicast group membership table. The table
-- 
2.37.3

