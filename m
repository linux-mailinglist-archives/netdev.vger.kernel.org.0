Return-Path: <netdev+bounces-6169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A386715063
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 762801C20A88
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53FA10780;
	Mon, 29 May 2023 20:19:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD4BA53
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:19:48 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB59FCF;
	Mon, 29 May 2023 13:19:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HP7d+6L+agk4a+PjU+Op+XEBKchLsLJV42OTL6KPmN2WROxevtlDKyptwk62VVuSG8rY36aLoEE77HpKV/SH5rchg1Hod4ZkN/0aFCN9MtMe9nUMUNFGL3T6aiOA9I7a6FRTrlhaGV3xTfOcEwY+RDbEWGa7L3RUsP4MuUJIvbrQe5SU4kDcuiyRJVkOj5HV030UAfwB7QVsF6/nEGDZoYHPSnDul53Dgou+jen1bR+zIhhrRW/YjmMVPKcrUe9VIx5weF3AIc2+U9wC+wBl1SC5KrCHUB+Oufu5OKEm1yYRj+hkbwZD7Mchyq/L0fzMPqcaKPUPMRuERMaGvPJTTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G94JeCZEPXVuTfPis6gKgswmtsaHQtxgn2reOOQ1Aks=;
 b=atEQy80lLjv4/h6mYc889HQDm5lW9f95+Xyve+wo4teECPmlZ63Y5RXndMca1bvGnegeF5WQskq6eNfesPiaAMj85kLRM6iJrCUdrgcq03nJUInCF6ZcA7fMSrMn3cIP3wQSwGg6H1McItrBT+YWFn3Q57hAOm4t6SK+okbL2FhvvOyJCrgsUi67xF+XqahLqZXkRzYIV6DlfTR/hnDUUiCIjpVNoSKjzyaImQReIdGkaAyQIAJl9LS2gIWIrUB3w+dh+aQoGF5QVnf5g2ex6pgQJ4vhlB9dEM0IANCXzJeWiajoOhEGgwapAVqd/mN8WqdhV4LUul0plqMVgMPtrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G94JeCZEPXVuTfPis6gKgswmtsaHQtxgn2reOOQ1Aks=;
 b=oQie2lwPxFOnwRGIQczQ7jfgcUwi5+zDjGOrXd/FsgboJmVU+8H2lnnlfiv6XaTaVzVWtUM24+WQGHvinWlcPyz+fioAivNQIxWkm0l3+C+rw3zsY81SapNAkp6QnOXvphgNXVAZeAu00+PCL2b5BRF74caXPnUZHY68b6xoSQBKyZzS1CvKy9gfAwlVzF0JVjsUoL+mInvO8157Wf+B+oRp3KpMTxX8J2S2K/XW2EWboZsoFoyDVEvaobRSZf5RVUZaX1l0UUkhRNkvLoI4CGWeISPlIM7MmJdH84jOPWA/KjGXORX7ypvbH/in4qfclviaPqNl0oBhFXyrwNzxWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by IA0PR12MB8254.namprd12.prod.outlook.com (2603:10b6:208:408::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 20:19:44 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 20:19:43 +0000
From: Benjamin Poirier <bpoirier@nvidia.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/4] nexthop: Refactor and fix nexthop selection for multipath routes
Date: Mon, 29 May 2023 16:19:10 -0400
Message-Id: <20230529201914.69828-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0193.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::32) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|IA0PR12MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4228b3-d525-4660-0985-08db608209f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6H2UXcCphaYVxpbera0A8U0L3IEOBYxBlsVVX/pehWkeauasGmLqwhLfF1xsuawAsFa5BCpWBxWxF9mOSFj/m4wyxpL6NxGGwQvZCXfYsJbpuQVS2z89AWYpA1B8PABBNeoGjQTBvmDCSmQE6/Q5n5nn3u0rc9y32AYokLDd7iSa0Jxcgxh0VqiV/6NIoZ42KTA8MeaYjZJppgrgerXZ9ryiFYI4Xl6zm7mLHlls60mXQG+ZQPskvgtewhu83+YinB4I+HjCo97TnNjR2thZaOTrkyzV3jjr4AcWMwhRmKsWRriXH0DTQYujTDLeumi+zKuK/Vt/AtvLrSZhIRwjikrUmAmdGetazdBOKQiFyHzjLDlDED5ZBLlON3BcLz64iMhNP/0BYr90mDymVXQvld1kpPJhabmi7nyhc69cdfOGNR7gj7SMvMYyh4buVoxXNT7stlhC5FtikG2tHz58ObJCRO+XDKTUW9witkdxf4b/Eh2IFzmbIPPCkwsBj6rDnKE2vFKL6go6ELkYBe+8gKk5wU+eU1cGEEUILET06LTnsJZTIpnBoeFPPaW+xaPy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(38100700002)(478600001)(2616005)(66556008)(83380400001)(66476007)(66946007)(54906003)(86362001)(4326008)(6916009)(2906002)(6666004)(6512007)(6506007)(186003)(6486002)(26005)(1076003)(316002)(41300700001)(36756003)(5660300002)(107886003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p+lxEPYDXYt8fNdcRWnut7Z3lvZ+rQdSiXD6E9ZDwS4O6ZQHsTe9BvpNgcoV?=
 =?us-ascii?Q?xH0bph6AcKcQQ2ADP4rFgoSP1FxHrb/h3ZMjfrQgl6NRYmM+kbidbde0zImP?=
 =?us-ascii?Q?Dtcf7s+w2Qba9XcK6btflrDJR7Y4kuWNPYTMBT8tHz27P5i/0RwROF5Hgw2S?=
 =?us-ascii?Q?F92omSgoU9iHz3cM00Li9EzCJbWzhZw8GVR3mZageb0BOX3Mxtp1xGXRtPVy?=
 =?us-ascii?Q?qgx37wOc8L0iULuaeLq4Ca+4HdIgrw9rZL3aeEIVp8GqW4jTdQhU7IYz+srJ?=
 =?us-ascii?Q?OjrlgfJ6OH5DPr4/AUZVYmNB/zGoYyy2EBrJPRl/h8NVWgI44kXCCJb+7RNW?=
 =?us-ascii?Q?SB0FzgeuokweQMiplEdu+3yNj0LygSVoFAtYQolKgFxY/h3SYdL//TYD+ehI?=
 =?us-ascii?Q?VLQG2L66Q0a61Sc4rRKHdnDmpEBQPikHMmFsYsw/1ltgQ8CXbMKUQf1b9G+f?=
 =?us-ascii?Q?qgQbiLVVKWjwAR/mMXRz0tqaDsSGrUu0YEBQk3HbvFHeCjfrTne4b0MgmQJG?=
 =?us-ascii?Q?pGmdjet+5QlDyXU4V3l8z+WdNEWjBlci0zcCiR7PFoOAlzXU6y0c66tV7uXw?=
 =?us-ascii?Q?NvHN/sGrP4lR56YCtgqt+w35LGgMjr2MkeqcLkA6m7rCP1q1uY1H5RITWyGI?=
 =?us-ascii?Q?oudeRJ34jCng/F2xD6KkSUVnj5AvBzJo9y7Min5uxPEXdNeRaX8MlXt7E90W?=
 =?us-ascii?Q?EMSBRtDsn8cCy6eIjNfC8374Ou4WW9wlQj2amVTc4nb7oC3zGlhXeqqK+CET?=
 =?us-ascii?Q?gFm9Uv0xW5s3nFjkFa855LGbNtuCem9QPEoaBB+E65oOkxmvd+jZEmITf/jK?=
 =?us-ascii?Q?orefSMS6DihkRRfZuWfjEbqfHarFgXJn4sdR+sA1MzVT2LOMb1o+kHl6hLUx?=
 =?us-ascii?Q?zwflWRsYLjv8fDwPrVKu556/pqHG5z7LOnECxkjnkYqqC3Vk6mElSHR2g6up?=
 =?us-ascii?Q?nhwqpyPtZn04RYVCr0qqjNR2gMvF8sw1JFD6LVOFbxV3ie1/h46x4nqQaF6E?=
 =?us-ascii?Q?pU6gioPe1SSMcM9iGPgIxSVIIzFGW0xVrAkvi3CjOzDzmMjAViMZy/TH8B/c?=
 =?us-ascii?Q?/RVo5vBhKt9fA4T309sr6GVsrmxHn8MuEiil+YvbbTtUV2zwHqJ1UjqRqYjr?=
 =?us-ascii?Q?9miACyW/+gnjEnfiFtQlfslyR1Uvn0t/qy0Q93QQ0Oei3NpQo6f+1uWUuntq?=
 =?us-ascii?Q?/zHhOYlLys38BNtltQY9tpKihoZ7ACqCn5mBRZbESteVlk0fNctpXqJZ3qHV?=
 =?us-ascii?Q?C60VTdDTY1BKo8AtUmN+KNPLo/PgsYVno7/SAIB2jQAHxff747TGTAVhNiEa?=
 =?us-ascii?Q?cDZ31ICNNeNqOFJDgZo6hvlHrvEVAVppvlGo8/jm+ZleXXP/xyheU/K/+KDU?=
 =?us-ascii?Q?sJMG3esJSBVKjAmccjQ94L1cLDupWR8dmInWbhVJM/YUqKUpSMq7geJqZ1h+?=
 =?us-ascii?Q?wnr/tSs/3P0vDMNA8hc0oKwfw99ERV0oBRpfIEUvPnUNbioxAqDrlo6MDfLS?=
 =?us-ascii?Q?af0ARcfhJWDwDIsGILxR6//TMgxTb7tskuA+wslEVZMCUPJObkiCXxivCZlq?=
 =?us-ascii?Q?zymwvk5sJ/XqhwNlEzLV8fg9ebaKb0eO9Pbn6Lz3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4228b3-d525-4660-0985-08db608209f0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 20:19:43.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aL0biol+j0i+WwdrJVVHMS82eRkQOO9jFL4/s9pQkkr/U5Nb7xbNycfMSuLYS/sKAoMgUVNP+6whaR7VlErnBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8254
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In order to select a nexthop for multipath routes, fib_select_multipath()
is used with legacy nexthops and nexthop_select_path_hthr() is used with
nexthop objects. Those two functions perform a validity test on the
neighbor related to each nexthop but their logic is structured differently.
This causes a divergence in behavior and nexthop_select_path_hthr() may
return a nexthop that failed the neighbor validity test even if there was
one that passed.

Refactor nexthop_select_path_hthr() to make it more similar to
fib_select_multipath() and fix the problem mentioned above.

Benjamin Poirier (4):
  nexthop: Factor out hash threshold fdb nexthop selection
  nexthop: Factor out neighbor validity check
  nexthop: Do not return invalid nexthop object during multipath
    selection
  selftests: net: Add test cases for nexthop groups with invalid
    neighbors

 net/ipv4/nexthop.c                          |  64 +++++++---
 tools/testing/selftests/net/fib_nexthops.sh | 129 ++++++++++++++++++++
 2 files changed, 174 insertions(+), 19 deletions(-)

-- 
2.40.1


