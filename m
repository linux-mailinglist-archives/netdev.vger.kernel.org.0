Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890884CAA3D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242163AbiCBQcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbiCBQcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:32:50 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4945FC6255
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:32:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMexoc8FPD74q0VZl5EAbIqyM5TtA8ddus8ii85ufOQnIwKCelPMainffHtVXA9QiDdb9/en7I7qgZiLW9VNCp1rtiO6pv6iERWu7y5NCBoTZ2jyr70T1tvd/9M1GQ7XsIFFEHBBM/+pKX1Ae3AseLolA5q10tIhTteDQRdWGl9krZOihPzwFE8UbnHNgimbW9dsMWNL78dlTqKU2jdqwlHDhLwzKsfJY+RIUqonXbj5+IK2ptkzfLpwg6KAnk4pNYpPMjZvaMlDUdTLy8uoXLyhtE5obqwVOIXmFW3KgFe+WtcuYlKi11x90HFSGthcUKxYXst77tyPgnJUBsNXDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdVn9CNIrqb8EQczWFGD0fpiwKDt9kaDIODFtQdatHs=;
 b=FG6UYcgBmSnc/02w5kkA8wOIj3WV8ZH8jxlZGF0uf9Lx9KoFx1AOYHf0pCVYrAWryNNuXKxbqEZZ2nqI0fZf8cATN8Z4QZE2wVy1BLjpBd22uvjjMWEyUswNUnAliLzNq3+3F0/ukjwVFr85qJ0RYyrB386I0/FOS/qoWwXZ4UaWUHtBQDG3CZbmhYA3oiiFLQDOSRutiSIe0vDvvqfLX4jaWM5oxR29DzvAd4LdiGUSwP6uGGnb7VRT+O2Xl5p4OuGEyl1bAT86m8r1Tk6s1W64mXUG71k+BOvOCnX+m0H4Iu4Z3qlqj6iEajjOOogpeMrNLRHG11kd0AUN5tYrlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdVn9CNIrqb8EQczWFGD0fpiwKDt9kaDIODFtQdatHs=;
 b=F1CHiIClCfKqMKEeKk8u1kGWv9VkMFJpHp2M7TMVO80AoKYQZ7IYehiPAnU6b74mTM7uUkC5JWvR8ey9hZm9UophxnAEU41pAkiF8bfl8lq/omkbJ4AdHZXLDtYeCq2F4Wfqx1PX/2qyXFZFVZeXhVzxznG7KuacTY+rgKIy0KbMH74Ta8eFfv2HPbXh0MNFGwECK7M0aq6gyR0RU2vC7+6idFpfZlFF1t4Pq/gusplXa9Zt+D8cdI78hlTC//UBC5zii+qeCIzbBpr54lKjJU50mB3DOUfnlK3iAxBY26qwjKLh76tEBacSulpmuzxZ4hUSIXQttDU0KwfFBcCTWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:32:05 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:32:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 02/14] net: rtnetlink: Stop assuming that IFLA_OFFLOAD_XSTATS_* are dev-backed
Date:   Wed,  2 Mar 2022 18:31:16 +0200
Message-Id: <20220302163128.218798-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0223.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::44) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 057db0b6-505b-4007-4096-08d9fc6a2fc9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1942A888BC1FE326D824B1C3B2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWz3CoZFLptjL7/KzUvMR5rj88YGx0jBjZ+VrXUj4vQ6ZVKxIZnyVdnXMWMzPtjmAPrxT8FmIipMnIF/nlDCmb8fP021IwszcfqT2C4d5Kd+iF6nwPUDRi4JMpVRKJ7j/2zDMWOmOb37Rkaqfghh3LY2h7iMn/WkYu/Ihxt9JkkQXZBjvDehDGBje0bKFrzgN/+Uf0FzHRo7jv+JYmHhMyu71a3+XCbMkITscr8W0QQhZWNPoSKSh1P/wsjCUzz8TjlqkArQMGSLU2Nim5smnB5TSnKg6b0hwHxCPYuhqUM7rtNU2in4BmiA5xK2RGrZL5eS+NvgTByNmNGsw7W7qbu2kk0pI/OLGMIoIWifyOZNK+rNRxqvXWUlnO+D4f2Z9SEBnco7MdmhRVmx3zxL0WKUr8Ta+gSEPc/tqRXS+PWJm9ywx9TXuzPlJ99GTuCN6HyvqJw73Ae8tkm/M2uLsO1YdZx0MBl/PrsTo8vO+oWvPblNSaeY36DNapfa/csKvX7nEhnedSB2MobqYBp+bpeCSAfHRooRXNWrpRWwYrdmh2A3jb0AzCqYZg0gMVR7nV8CtNurBLR7tyCbDXLdfFCE0oqRMEm4ATucuZNP94d1TkLxS+newGh/fo7/0x3Nzu/+Zu/hoKxGnRPhnj6Byw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(6666004)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(6486002)(508600001)(2906002)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BI5ym2g7HuUFbUiR80vh/mRP0kN5xThdwF+yIUo5ki260GJtCWAIoj/E+WtD?=
 =?us-ascii?Q?7ZUoK9n7rHg3+WtJAPLIHCL/AwWAPAzAFb/HAuyjPcyq6Lsnb1a+RFU1GOU6?=
 =?us-ascii?Q?AXlw9Pv0vq0WfA/UvjOOhD+hN8WqZ1a2p+HsQO1yNV/1u+ckWxXDs+9ZMTXW?=
 =?us-ascii?Q?4GsEGnwa5sjown7yrY0X8gbZQFa3Aq2aXUsWBw0EkysDVAQbFlp+YvrpBG11?=
 =?us-ascii?Q?tq6R757DSb9Ub4Yg0xrBCqfqBHZgFf4oq1WQvYFgsdNUeeB6SSUxlIAmnBh9?=
 =?us-ascii?Q?cuP9ex1kgSsZgixtAxv4eCcRjAJdxrEnTuuv067GaifEONauBorWCyMu92Qv?=
 =?us-ascii?Q?E1ycCjFt7mZribmjI92BV2ysb9YiJh2EwumW9tDjSjAl+YP84o1m6/18PZkC?=
 =?us-ascii?Q?j2KhpX1HgbO9MxKA0GhUZClFZtty/R+ozWDZUURfJV3/bDgPMdrSDu+D/9aR?=
 =?us-ascii?Q?TAj6IR2VOEQLOl1VsYXCmmjiMR5l2krI6LjXUMY27gNhUXx0o0KeFJHA0eFt?=
 =?us-ascii?Q?bhVaEFLwJGgKiGNtldsv7WxVKt1eNKTVYzd3nbCvlU1HOmKxLjjw3628UIRh?=
 =?us-ascii?Q?dvkKWt4ENBfsF4ULsDAuJt440G9dpe8+Sj363cJSxllJJqA0j41XptnvwkMq?=
 =?us-ascii?Q?KRh9ByVH6zGzS8XNZdgPOjNVQW2Ac5h1r7qd3r9oqRayOxBv65E3Ftxg991L?=
 =?us-ascii?Q?l1UAhNb3P9jWwHSyKNhvY7FaYya07IHSpgJmR4giwA/oLeLWIkKZmHvY/dqQ?=
 =?us-ascii?Q?tnUtKCB2aYUOxKY/aEfmeYpHhFvPFSGnjPgDWPv8083iNSHFdNantB+JPflY?=
 =?us-ascii?Q?dLUWO8bhQCADpyJJKx/aLYbVkm5ZNTMf+T0WstgkusHUNlpJc3CZd3bIRBnU?=
 =?us-ascii?Q?qcXu4XYeTg2X43U2gMSwr2vNzqg0rhAVjK3vBODvUP80hIx9Wdf79rkCT/aI?=
 =?us-ascii?Q?45/5AB6TcG3h+LDuJk7STk6kV8z9TkLB/m14rwdRqUuguAxLFEVXVJyAuoWR?=
 =?us-ascii?Q?gfo/qmjwc/kfN7PnIFoVpNEWzak+7SiJBhlUwG0Z2TKqy7dzxQcN1tHs68i4?=
 =?us-ascii?Q?ZmZRuwfcepMt3KOpj5CuXqCiKGsMLShmw2I8xBjFXBQU53Vjwq7TV1uR5jiU?=
 =?us-ascii?Q?TUAz4NsDofiSxdEJDdV+ALGVhb7rIN0FWUjuKOtaPpzqn09mspLpuzf9xNqK?=
 =?us-ascii?Q?Gkr4DY7eZkd8lZv7IvtK1WSUxSAq4R5LhGpc0N9uMpEdL6I5ao6LFuqG5X3Q?=
 =?us-ascii?Q?H7XfdMyhJSA+tTaz/BJG3tHNWST4JiZtHVL63EmK/IixwiCeJf/MktiCa7ue?=
 =?us-ascii?Q?RhafWagVs6QJPsrxQ1cRN1Im9LhgbgGCJCQ8jIQ7Y2xq4aPu2QeFFg/cPRHV?=
 =?us-ascii?Q?ytSatSwryEeb2T+OodPilP5N0iJutauAGMENrtWqGhoI3d991tEchUUtvwb8?=
 =?us-ascii?Q?7CAtQoKvYMgLQWODBToh97iR1Tf6lrmo3Q4GX0nHBLA3vI/UxoIBHwVF+UQi?=
 =?us-ascii?Q?EBGuVMftG8e8vFToGePGnnqgyeMgV36Ob9EIN3H7kX34EtwuGJaw7RcpYZpM?=
 =?us-ascii?Q?anuQe8xSfluckYLZdj9nLetfJjq3A5uBhVKh6MXnGUEfVVUir8O4zf5ihUx6?=
 =?us-ascii?Q?mOrpQz/5j5m9oY9gBRFo6B0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057db0b6-505b-4007-4096-08d9fc6a2fc9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:32:05.0274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LZn0ADo3L0SeHSzVloQp0B2FNBo98N8iU4HesdpvX/H7acshfEQiE+uzajWM2PE4Z4wsn09DgtK80vT3MZprQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The IFLA_STATS_LINK_OFFLOAD_XSTATS attribute is a nest whose child
attributes carry various special hardware statistics. The code that handles
this nest was written with the idea that all these statistics would be
exposed by the device driver of a physical netdevice.

In the following patches, a new attribute is added to the abovementioned
nest, which however can be defined for some soft netdevices. The NDO-based
approach to querying these does not work, because it is not the soft
netdevice driver that exposes these statistics, but an offloading NIC
driver that does so.

The current code does not scale well to this usage. Simply rewrite it back
to the pattern seen in other fill-like and get_size-like functions
elsewhere.

Extract to helpers the code that is concerned with handling specifically
NDO-backed statistics so that it can be easily reused should more such
statistics be added.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 97 +++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 50 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c484bf27f0b4..ad858799fd93 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5048,84 +5048,81 @@ static bool stats_attr_valid(unsigned int mask, int attrid, int idxattr)
 	       (!idxattr || idxattr == attrid);
 }
 
-#define IFLA_OFFLOAD_XSTATS_FIRST (IFLA_OFFLOAD_XSTATS_UNSPEC + 1)
-static int rtnl_get_offload_stats_attr_size(int attr_id)
+static bool
+rtnl_offload_xstats_have_ndo(const struct net_device *dev, int attr_id)
 {
-	switch (attr_id) {
-	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
-		return sizeof(struct rtnl_link_stats64);
-	}
+	return dev->netdev_ops &&
+	       dev->netdev_ops->ndo_has_offload_stats &&
+	       dev->netdev_ops->ndo_get_offload_stats &&
+	       dev->netdev_ops->ndo_has_offload_stats(dev, attr_id);
+}
 
-	return 0;
+static unsigned int
+rtnl_offload_xstats_get_size_ndo(const struct net_device *dev, int attr_id)
+{
+	return rtnl_offload_xstats_have_ndo(dev, attr_id) ?
+	       sizeof(struct rtnl_link_stats64) : 0;
 }
 
-static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
-				    int *prividx)
+static int
+rtnl_offload_xstats_fill_ndo(struct net_device *dev, int attr_id,
+			     struct sk_buff *skb)
 {
+	unsigned int size = rtnl_offload_xstats_get_size_ndo(dev, attr_id);
 	struct nlattr *attr = NULL;
-	int attr_id, size;
 	void *attr_data;
 	int err;
 
-	if (!(dev->netdev_ops && dev->netdev_ops->ndo_has_offload_stats &&
-	      dev->netdev_ops->ndo_get_offload_stats))
+	if (!size)
 		return -ENODATA;
 
-	for (attr_id = IFLA_OFFLOAD_XSTATS_FIRST;
-	     attr_id <= IFLA_OFFLOAD_XSTATS_MAX; attr_id++) {
-		if (attr_id < *prividx)
-			continue;
+	attr = nla_reserve_64bit(skb, attr_id, size,
+				 IFLA_OFFLOAD_XSTATS_UNSPEC);
+	if (!attr)
+		return -EMSGSIZE;
 
-		size = rtnl_get_offload_stats_attr_size(attr_id);
-		if (!size)
-			continue;
+	attr_data = nla_data(attr);
+	memset(attr_data, 0, size);
 
-		if (!dev->netdev_ops->ndo_has_offload_stats(dev, attr_id))
-			continue;
+	err = dev->netdev_ops->ndo_get_offload_stats(attr_id, dev, attr_data);
+	if (err)
+		return err;
 
-		attr = nla_reserve_64bit(skb, attr_id, size,
-					 IFLA_OFFLOAD_XSTATS_UNSPEC);
-		if (!attr)
-			goto nla_put_failure;
+	return 0;
+}
 
-		attr_data = nla_data(attr);
-		memset(attr_data, 0, size);
-		err = dev->netdev_ops->ndo_get_offload_stats(attr_id, dev,
-							     attr_data);
-		if (err)
-			goto get_offload_stats_failure;
+static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
+				    int *prividx)
+{
+	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
+	bool have_data = false;
+	int err;
+
+	if (*prividx <= attr_id_cpu_hit) {
+		err = rtnl_offload_xstats_fill_ndo(dev, attr_id_cpu_hit, skb);
+		if (!err) {
+			have_data = true;
+		} else if (err != -ENODATA) {
+			*prividx = attr_id_cpu_hit;
+			return err;
+		}
 	}
 
-	if (!attr)
+	if (!have_data)
 		return -ENODATA;
 
 	*prividx = 0;
 	return 0;
-
-nla_put_failure:
-	err = -EMSGSIZE;
-get_offload_stats_failure:
-	*prividx = attr_id;
-	return err;
 }
 
 static int rtnl_offload_xstats_get_size(const struct net_device *dev)
 {
+	int attr_id_cpu_hit = IFLA_OFFLOAD_XSTATS_CPU_HIT;
 	int nla_size = 0;
-	int attr_id;
 	int size;
 
-	if (!(dev->netdev_ops && dev->netdev_ops->ndo_has_offload_stats &&
-	      dev->netdev_ops->ndo_get_offload_stats))
-		return 0;
-
-	for (attr_id = IFLA_OFFLOAD_XSTATS_FIRST;
-	     attr_id <= IFLA_OFFLOAD_XSTATS_MAX; attr_id++) {
-		if (!dev->netdev_ops->ndo_has_offload_stats(dev, attr_id))
-			continue;
-		size = rtnl_get_offload_stats_attr_size(attr_id);
-		nla_size += nla_total_size_64bit(size);
-	}
+	size = rtnl_offload_xstats_get_size_ndo(dev, attr_id_cpu_hit);
+	nla_size += nla_total_size_64bit(size);
 
 	if (nla_size != 0)
 		nla_size += nla_total_size(0);
-- 
2.33.1

