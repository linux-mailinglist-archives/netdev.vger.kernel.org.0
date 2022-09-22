Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C365E5B46
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiIVGWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiIVGW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:22:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC2251420
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:22:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj9dJ3X+zQFxYhrbo+MyNbNViZKo2gUUVnwqJjkm84HPtO8FqGONo8lqm0SOrXYsF4ni7oesrn2fnxJOYWwJ4u8m2RJ1r8x4/WFA+9BYb1HMYE+TxCrwnF3cuNXuqkhlzh+qqXG18T+NZtxZAJ4WZSTcvJ5pnAq9xhS67Ab9t1Loclzs+F49wkg0DqT9muutxHpA+ycG5h3k+R6fNPn2JbWLidHkW3pF9JLO5T/mATfAuu2JlwkLO7TxPAHStTd0kSKbLY5mx5QqUfIJ4PGZp3nt31Bu+ILeAAP6kQ0n6NMSgmh9gP0zhkbVlsbY0zL6GHcLBxttIvM0tvInjcrr6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL9nHvc5yi7J70zYfUCPVaK6yHXGHw4A+LR/ewfN8ls=;
 b=LWMi+X3MrU4ek0zPHc6+CVgoePruyrWDxUH2vq7ftzqcOE4Xztm+4EhQ43cHio2HgDtiaSt+pdbIMLVHslB/dBTYEyy3+IocYeRxesHYnSKsLAeIWNRmy+l0W0z9fDvc3042p9Xii+pXXjLbLgVqp/DD2PkpWQfXwuNSSIMbbJSdKArKbHnae9WphgceY7z1DwizfnlzkKTXrCttQbOgpYf1rXpp6V/aYSPsfdYmn+XARETK3tdu4rnImUyO5QXj6brVmayrLE3SEFXgT1I39jK3qfXiWehDIJZe7JVCHpYdNLvjV0DXpTU/yXwJHHTNgjobFK2V6H1SN3+tiNd2NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL9nHvc5yi7J70zYfUCPVaK6yHXGHw4A+LR/ewfN8ls=;
 b=ittXIJcedPztfaXlpn4LGAuUaj+gEFHJJw03QMYYQdQxvv1XA6SvhvArhCC8vWroWBDMZi1jU8oQ2Gu5TU9cXl19qf8TirzlbTZXUB8YcGHgMIqY4izG8L4dBUkm2+WmY2qB2qHKrpMdZmnx37C8OJng+H78bp81/sXyuWbKY7oIi3uW9DfyfV/mFj8W28VtUK/aojA6ApG8u9tlaP+vHTzQh9hWH83IMA3v69SF2a8ezIc1I0S7iwz0E4aczKL6/+bqpNGENfmypIlwBqOpMfG8r0a8Ug7AB/XFt1P8NVjBvu4ohu3tocyvAkMs/BxD5RUxU+3PCLP8dMCU2CdDgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Thu, 22 Sep
 2022 06:22:27 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f%4]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 06:22:27 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 3/4] ip-monitor: Include stats events in default and "all" cases
Date:   Thu, 22 Sep 2022 15:19:37 +0900
Message-Id: <20220922061938.202705-4-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220922061938.202705-1-bpoirier@nvidia.com>
References: <20220922061938.202705-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0234.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::30) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|DS7PR12MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: dc70fc35-77a5-4028-95da-08da9c62d210
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +QKeX1sR9AagB54IMEjXUYOiKASnwWTnuTNDYKeRKZshl69Vlt9iQHgnvrAUoc5ppd9k2m060W0faPnf0oaUl6CqUoq1mmoJxxkAuxALf0zkbsLPt128yfCjSpiH6g4UGtfE/rQkjq0jSmCPj8bMq0MJLTwAktra9qDkev0tlV3D8LGUGxk85syUse+OB2vSC1c3AwW8NAND6oEnmI5DopuTTR2U4zCHQRGWxZ9Hee76lvSKyeWwTjDpzyXf54zwcf5KbKrvo0UDWak65TQ3EnGGYgKI2PGAJVOlj6TR7hEDTR+7TQk01uGMS0zzcizgJGLLMPen/JwCrtGJBr7nqaGE41+hEOb/NUax2cGxuUoGPZZoCwgmvgnU04uH4uNiV9h6TRinSHCrvlzYRaYJ+fBW3y7IPYjzWxpVlYp1qn64ftSaY5jtT0Z2rrVhTF/d2vlP5ZT9rpQhEilQkSTWbKO5jfla0PxZlQYwWCbTm/ZltDwyoXOE3MIZXId/0Fz0ytFK2Jkpx+QR0mEUZKFrBo+aD1ulQX2KZVRE3Ht715vFYSM3IEjriMO/TAECGDI+qlW4lfGP78lpgxkGz+/Mu/LkBnyV9I7JbdLsES9HHL9Re6u+ofuYiMwLlWCUWJ8bek2qNC9DfsB4hPF1R0JtPumNSsNUpcVyBHYu63iGPSKCXa2m3NXIIOI/rYUItotcc2lN+FuIA6JhugCMhNInbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(6916009)(54906003)(4326008)(478600001)(316002)(6486002)(86362001)(8676002)(66946007)(66556008)(41300700001)(66476007)(8936002)(83380400001)(26005)(6506007)(186003)(6512007)(6666004)(5660300002)(107886003)(38100700002)(2616005)(1076003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f8Of75NrE7nVlyfbtRU08204k+fNFulP1l+d0Y+9g0D2OQE0lVpqSAERN1Lv?=
 =?us-ascii?Q?BV3T1PHWl/Prxxqbhgk8gogyBfgJecQhM7B/IouDc/aKkoEDRpzpbgQB+la1?=
 =?us-ascii?Q?cnEleg79XhgsdyeNR/FZjLgEDqQOedAud7GyqFd1MG5rVDxK5W3w9WUJPzdE?=
 =?us-ascii?Q?fIpqclwxtDk3O90eGL7viv2Ie5YkKfjvQrWE+6f1Ey3LJebamWdfKqefypap?=
 =?us-ascii?Q?wj+Fu6oRAE1XbHQrZjiEb4QtpZr7KHIVHOei8uztTWossq1o8wsxXv2ZOUUb?=
 =?us-ascii?Q?CruCe9888A0wn/YFRwXXejO/vPJsjCRRGIfUcG+vLDXUSIA1wb+SQqPoDLeg?=
 =?us-ascii?Q?RYnqFapqw/vjv6c9WG9eDIHh7nYeVar7fyqDNzb/ARs2P6Go1vEFYRV6SIhu?=
 =?us-ascii?Q?qr29FP4QSm3zZ8O5o5TPX3PG59aIeGEcN6+l7KYvYbKubkl4jFKb1BpM0m6k?=
 =?us-ascii?Q?0gZ0iY+hBCaZMsRzTFOBt0diZ3uU+PRtvPwLOWx4ohJqngQfwPy5s7RfXyDe?=
 =?us-ascii?Q?nClmQVbrVKRf/JvkwZijvJ+VX0S+yWtwcRtvQP1vZZW2BlVDvVMxyuJAaJjN?=
 =?us-ascii?Q?sofHl8no3syOmpOnWx+FzxNshKFLnglTYUoj76wBudCaki1STC2lpwfO3OvK?=
 =?us-ascii?Q?PwLIOaJ4eXrpC9E3Jfwd/KEdwCfA3B4dYfSSPuovwrIo/8fHmjhIgKsqvQ8I?=
 =?us-ascii?Q?Tt7QofiSwz3nIyUsIqqQJ0OaowKJP2k4kHulpv4fFCWlxw9cnDAzm0M20MYg?=
 =?us-ascii?Q?nbCS6GoqMS0ZA/M0vUqbqu5EqswRv8BzkBfWbG9B+6jdQrQwXxaJqB2wQh/s?=
 =?us-ascii?Q?F7L6aN85eN/riB8h70ZAbYI+9BPWkJbeP/Y2ugPHX82Blw97JJ5uIGTkW/Un?=
 =?us-ascii?Q?eXMJfW9c7gwPTWWtOiLIFKrihoJMfTSqLDmOE9FtYY2Yw0eO6eZncEqv+vWQ?=
 =?us-ascii?Q?q8spAvG10JJLBhnsLHVFQYa6PzBOvc4f4WpHoHUWe6mrfjoeG2A6YYI7SAof?=
 =?us-ascii?Q?E0Mu/OZp3UY0Fn/K6DsS9wQlva0+S8orVt0TIzj6ypxIgI64vSU1MYGyrzcj?=
 =?us-ascii?Q?fftuqw86D3OCNoVb66c1aIDLJrrCp43aaUJaCxDf1O98RJiCsr/v1uE3puPs?=
 =?us-ascii?Q?XQLu7BU08Jn/EOVpkxxq1hpc4Yi4UyktS+kgrmhB7DQiVTXWcdR0TG2SnBFg?=
 =?us-ascii?Q?/gsCWKHT0SOmyc9LcdtNN6InbzIC6thrJgRpdnx372GeDytlMkiMRbvHlpDF?=
 =?us-ascii?Q?1TA7wnT7C7PYdF8/RjMu3ShJ+/6hRfx12tnuk5FWGeJhdMaqWi1bl9lwWNm1?=
 =?us-ascii?Q?gD7jVm8rfdWVu3oIsrc/zR7T0KRE7tps0d6iJKqlsTAYGz83Z7/wRbmIE25u?=
 =?us-ascii?Q?ET546IaDWqrDWqCFHFzKZodIcrjdK7LwaHPQsnt9L8Qm7x6yjeeVU7nb5FBp?=
 =?us-ascii?Q?MFH/J6OylcCBRj15XdoWXE54VnoHpcNT8gTY/K/genTcpqv3BKXg4XfZh3wT?=
 =?us-ascii?Q?XUcjEB2VOpIf8+3VyhZ4UB+A15d2WWN0eyfVJPZ+s/Xlu3kNavYVBl0gm1Su?=
 =?us-ascii?Q?2Wxd1TF4/z2DfNFPD0YkQYJJ+IBno99aqbNJwyn3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc70fc35-77a5-4028-95da-08da9c62d210
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 06:22:27.2954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IIFBrRYGTnvvzgQjJVispitl9DW2jAxs6/4UiWKm3TZesyWpVKoAi5Q3nWBtNTZmUhDepNMQJxhXv+auLUi38w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that stats were omitted from `ip monitor` and `ip monitor all`.
Since all other event types are included, include stats as well. Use the
same logic as for nexthops.

Fixes: a05a27c07cbf ("ipmonitor: Add monitoring support for stats events")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipmonitor.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 380ab526..cb2195d1 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -180,6 +180,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 
 int do_ipmonitor(int argc, char **argv)
 {
+	int lstats = 0, stats_set = 1;
 	int lnexthop = 0, nh_set = 1;
 	char *file = NULL;
 	unsigned int groups = 0;
@@ -190,7 +191,6 @@ int do_ipmonitor(int argc, char **argv)
 	int lprefix = 0;
 	int lneigh = 0;
 	int lnetconf = 0;
-	int lstats = 0;
 	int lrule = 0;
 	int lnsid = 0;
 	int ifindex = 0;
@@ -224,41 +224,51 @@ int do_ipmonitor(int argc, char **argv)
 			llink = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "address") == 0) {
 			laddr = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "route") == 0) {
 			lroute = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "mroute") == 0) {
 			lmroute = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "prefix") == 0) {
 			lprefix = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "neigh") == 0) {
 			lneigh = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "netconf") == 0) {
 			lnetconf = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "rule") == 0) {
 			lrule = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "nsid") == 0) {
 			lnsid = 1;
 			groups = 0;
 			nh_set = 0;
+			stats_set = 0;
 		} else if (matches(*argv, "nexthop") == 0) {
 			lnexthop = 1;
 			groups = 0;
+			stats_set = 0;
 		} else if (strcmp(*argv, "stats") == 0) {
 			lstats = 1;
 			groups = 0;
@@ -336,6 +346,8 @@ int do_ipmonitor(int argc, char **argv)
 	}
 	if (nh_set)
 		lnexthop = 1;
+	if (stats_set)
+		lstats = 1;
 
 	if (file) {
 		FILE *fp;
-- 
2.37.2

