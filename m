Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488974C2D30
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiBXNeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiBXNeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:34:36 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39E33D1EC
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO1CmCmrliQlpsSREfiqKW+KnDfT/3IRNfc7TjmMmJs3zI6wlLnKgniXkEW5ESQjeSu59nVnC0/s7UGbjeH4XDyAnlI9DBYUfO+ROkhe8aUUqHkZSux955OYHx6vK2dq9kYowmvw9qunSM8CR/sbo7NvrAsctHpgzoDADOth7kiAX3w5/8jv3LACeWX/cxPwWAjT50u4W61yj8Nfhree9m3/Y9Mv29+rVRCgvTK3acxj/PY7e2Z1cwF6YDK8GSfZ4cp8HJRhUKGrIGWcxzyULhq76/mzLhGWI+hnMB64YDxyXpW7Dtw2bo6AkOYCQFDEQlWCBm9FET3He4Mj+cZisw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiGt8fndYh6d19TtG42nSQw2AWXWMYNSHSuyQlhVvXQ=;
 b=LMQZSe7hSffRIuovXoWRE5Vhs58kS5cnWSAukUC7cURZ7lHie8EUqPJTSbxg0tc19muIRwuaJgzQCXa2GbjB1MPO9qywORkFCtG9IAna2N5YJNSpytdE1W/b8X14+d/nrovKRs+ucHAO0sIbANX20E9M2PgukNYAXHdNlbToE5q672MxKY4URWi15zyEqcn29ahrwHXuia/5v7ZaqVp/fYlPyHG7uAX+d0M+r8OLGOcMTaFtk3N/7YDUhHsGEnQCv9DEA19c+KSweZ3Yy4EeOn3uAvaBvqOn07TOLNu8IEkHeO2Flpm1MRyT0s8tZ8enAyQ72QjDynx/sJjFpJjdzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiGt8fndYh6d19TtG42nSQw2AWXWMYNSHSuyQlhVvXQ=;
 b=GwAZzKC3ldNU380q9CVm/rzNyk+qwb3IjMQZlG5ikZci5rvqiuHpme/8EzKFJJvdlpcAfCsIhR7dKWxaJFufzlO+f8gtwZ2fD0wgAWf2kd+qtnutA0dNPrdBgm9DgNYJ0hoEMjFXkSlk0eB67UYopg+B34j4QtfaBGChDRYRNtCHsKrMVQ6A8dQ9jk0nhe1VpT5wDv8X/crAywo8SMIOydtsC0XTZueJ1TBgrC2wxfXw+PORw1Y5R/otxydnQtCKq5nmPWGEirOyRD2dZLSMhGIcXttBzJAClrhNZVuF6z+02hP0C681BKbBDodog0ZqCfv6eUMU9JkMc0fuIG+1Fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 13:34:04 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/14] net: rtnetlink: Namespace functions related to IFLA_OFFLOAD_XSTATS_*
Date:   Thu, 24 Feb 2022 15:33:22 +0200
Message-Id: <20220224133335.599529-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0058.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 040902bd-7c84-4c1a-2a6a-08d9f79a5353
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5416D9DE535C784CA7EB8CEDB23D9@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+0YtSGXf0GatrVB/J43+HjC7K4XMRxhwLCI0xTTkPDL/kkLxDZjTOwTnw2Ekr1TP9I926/0mq2q/ULeJ6ZCr6haWX3nfDbZp8t2jjEHKjdNfMv5JRQrx8/LAbrAkryL7qWg69A0m+MwmILbzHNyIPcU1EhxUgcT0Oke7LS+apY9DbTnCbMPfqkI+9zDJMzaJtqCNl8WtGOeRjSqfV4ZMAzQ6oq+Y1oJXcc+umr3H0yVm3CfGFOgwHcAoVl4wVs9cM+71hXVzv/sJKT76EOXAFbdS590qm++fDSKwoN4FJAck6vgJcrA/3PVgFVRbiT304F9pSlLUJ0V6cjzxGWfwabiKKLJE+JmVE+M1F4BZMHtx3Fs2rAf3+YP82PEggzv/eekIoMgTuPi3UTZWw6/fxx096u+xcciQtLvGQ1wpYK+Am+dIyDK+MrN9yS7SwnZxafUZUFxzAv4dSM5CYYVKzJur1XP5uDAPtDoHn3HqMK0/K4XalfpIVzr7ApUDc1NBYjhXhSC3qvzBtBWg3je3QIhStCDF63q6wn2D3RNQVBBBrZLT8QPS+rgTBv8VcbW2h52sLIs2uJoiNdPF37AGCIVopPXHqKFBWby3j+R2vv7spYywm0wzjHkviXcQvgqfp1bDlUJ6gIhYWlcEnBO3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(1076003)(107886003)(186003)(26005)(5660300002)(2616005)(2906002)(36756003)(8936002)(6486002)(38100700002)(508600001)(316002)(6506007)(6666004)(66946007)(66476007)(8676002)(86362001)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I2u/8znrYHm3fg7uskb1D8OtxUypNzWXAT2QPJOb198R+85k//cJSavAeKAo?=
 =?us-ascii?Q?NF3gnDAktN7npoyW0K0Kjap3LuKgSzGQ9aYJwY7ndaFwh9VAdU6QkjkoVsMC?=
 =?us-ascii?Q?wN3kM4F49veLEFJYxDbT6H2f/gFqN1fTZR+Ig9+1JKhPDRw1d3zs270FOIzy?=
 =?us-ascii?Q?Rzc+xgcqnqPD2GGhm76D46cOFNPdHxq19beDJMXYEYQzs7XL7u8t4HYjz4Uc?=
 =?us-ascii?Q?N+E464qEgcmWkh47b0uMosUQ2UIjsWmFVKXXp9vAFGaeygEdd76tgUvyTgPi?=
 =?us-ascii?Q?yAKMy9CvPQTSV8mWCjl/f4JQPMUvKwm93Fe47tNoIBr7l1kRdYcj5h4LzuAG?=
 =?us-ascii?Q?gbYlQiCN0jGjU1dZ67eLTVbWyv/8ihetpR5lnLo6ln3YrTEp3/NdCSPE/2lB?=
 =?us-ascii?Q?Yw4zvrZsGfnUNlUG+sXmjPGl2M7n09wRHixUZk8hlkwIy8mPAa4orwV5GDoY?=
 =?us-ascii?Q?th5d024m22hFbeyqcO0N4EC/i5Tyl2z17Wna5BGi9DqfsCXqm/SO63M4xeg/?=
 =?us-ascii?Q?T1w9Wx18LFCazCm4U6opQvznolatgrNiCXZiQBkdqOA3R6sc83B6RuZsbyxX?=
 =?us-ascii?Q?og6OiOOs9EKuhaYb1J0mSDy0mSK82tWe5xfY5b9KDcKp32jBkcUr1/+ApSbS?=
 =?us-ascii?Q?cNwPFu45I6eut7hgqY5ay9Upd4IJ5IbRLUljIvUbCTQHrcRm7SJ8v+TS68Ns?=
 =?us-ascii?Q?BP/a9T9C6TpnixAD9Rab9uOKRR/f3HENcMoHPmeKsxr1ekZHyxS1qw8tDdI0?=
 =?us-ascii?Q?NI3KxecSwWnZxGjxSqMm8ibhBeBgw64JbtBD4LqNXFRC55ZbgwBnNFNirfZm?=
 =?us-ascii?Q?D6rgcmiWLweU/VcpZXvZ9UTESkn1oogxdiBMpanof+R0Aqi1eMk2GCZxYqak?=
 =?us-ascii?Q?1J+NioLEhEyxUdw1L1ATpxl9pvhg4cb4PR+REvlqCUHSdSvwTy6q94Kc+NF/?=
 =?us-ascii?Q?2OikTMoasxdvEluGOfXm3NlE+DMq9banZIikR8UK44nz/cfCBkD2q9BPzxvD?=
 =?us-ascii?Q?ZNxpTWUmzHIkZvOp9a3iIvRK00pX/bUOao0Xgf7L5s/MdH1rZhjN9iWl0nuQ?=
 =?us-ascii?Q?9jKmad6m+s3JG9mAhBHHqxm9RmiLmDuQj+6PABneGBfsRWyqNAU2J1mnlPkH?=
 =?us-ascii?Q?VUcs/HoUk2hgT6DSFhNBSlgQZuBtTyFQVxpQmLkAITctMviZhStrH3H3X7jv?=
 =?us-ascii?Q?HeLmTmtXAEjNWe9CDBFo8hUUV3vxRsbBEj7zW9b+SQITHajfdNELOYxrZWK0?=
 =?us-ascii?Q?E8O1qWjQpWG39/A8WT8d3AiRUhD1s5WB8K6SMAUCaUhw5BOvFiON0xA0Ki8u?=
 =?us-ascii?Q?neNq4r4fA7a+I3wsdMHNfMhdH/MwF+1ID9XQT1F6q9+N3I4AsoavaiIYW3UK?=
 =?us-ascii?Q?MEiQn/XJpfiKjeByCZFC6Naqjgng+8aRJKgwSRxG8aBaKXrt2fY+1VYWl7f3?=
 =?us-ascii?Q?2tOUrLw02aEFTZUbdExu0ovndf+XK1125zFTgUGNfRnmSk/2FrN33oem3PPR?=
 =?us-ascii?Q?+y488BDlJiZjAWn8yZPztlz8NaUT3fM/y7uxFMqlsBZ6FhZYKGRUIm/hgmzs?=
 =?us-ascii?Q?ZmkXnNFnFKAQs9aQsCXk+PNj5pInDHy12Ed8wc7tfg45BJatO7GA0cS3LbHl?=
 =?us-ascii?Q?WU2GKx/azwClyT02bbHpyLE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040902bd-7c84-4c1a-2a6a-08d9f79a5353
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:04.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDf6VKefPRafCtRpPAfqTmXOmrCnjMzvy/bj/DbSclF/5mKCCc7Qzhd55AqeY75QAtPauwkrTd46johBV2zyUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The currently used names rtnl_get_offload_stats() and
rtnl_get_offload_stats_size() do not clearly show the namespace. The former
function additionally seems to have been named this way in accordance with
the NDO name, as opposed to the naming used in the rtnetlink.c file (and
indeed elsewhere in the netlink handling code). As more and
differently-flavored attributes are introduced, a common clear prefix is
needed for all related functions.

Rename the functions to follow the rtnl_offload_xstats_* naming scheme.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 20a9e1686453..c484bf27f0b4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5059,8 +5059,8 @@ static int rtnl_get_offload_stats_attr_size(int attr_id)
 	return 0;
 }
 
-static int rtnl_get_offload_stats(struct sk_buff *skb, struct net_device *dev,
-				  int *prividx)
+static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
+				    int *prividx)
 {
 	struct nlattr *attr = NULL;
 	int attr_id, size;
@@ -5109,7 +5109,7 @@ static int rtnl_get_offload_stats(struct sk_buff *skb, struct net_device *dev,
 	return err;
 }
 
-static int rtnl_get_offload_stats_size(const struct net_device *dev)
+static int rtnl_offload_xstats_get_size(const struct net_device *dev)
 {
 	int nla_size = 0;
 	int attr_id;
@@ -5219,7 +5219,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		if (!attr)
 			goto nla_put_failure;
 
-		err = rtnl_get_offload_stats(skb, dev, prividx);
+		err = rtnl_offload_xstats_fill(skb, dev, prividx);
 		if (err == -ENODATA)
 			nla_nest_cancel(skb, attr);
 		else
@@ -5323,7 +5323,7 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 	}
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_LINK_OFFLOAD_XSTATS, 0))
-		size += rtnl_get_offload_stats_size(dev);
+		size += rtnl_offload_xstats_get_size(dev);
 
 	if (stats_attr_valid(filter_mask, IFLA_STATS_AF_SPEC, 0)) {
 		struct rtnl_af_ops *af_ops;
-- 
2.33.1

