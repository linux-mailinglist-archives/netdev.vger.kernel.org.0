Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DC14C2D31
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiBXNen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiBXNen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:34:43 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD6C16DAF7
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHbSjZbsWR/8qHZg6FO3a0K8jOJGfPMud8FPlmvmC7X6t/nnmlaNhgQTkonHc5YnKowptLM5X5WSka08oasFWinjjrGtLAQNEV2iFicn5W/JZBH0ByEfg9f994M2niomzshbG63Sb+1hu0OHzgZfR0zM2qL4xaQpw279W7e8Tjv37zPqgf5pg+h/fxdv/ltrAYw1ihJKIZ8M3cnKc+bYT1lhkjV5sGzF0x0q+kbP7vmnLBvNLgP+6pGlyc0INw7nx/8ueWwxHvFd/HfarPegapg1QhJ2vyHUYkPHF7ci0vjpjv1jnopqYfxLC1Qd1yv8VywE7A+BY1qX54htEYzaww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdVn9CNIrqb8EQczWFGD0fpiwKDt9kaDIODFtQdatHs=;
 b=MrIKO8hU2FIFcB7oueiH6ik1C9EoNkixNaJ3P9XY+f21WQDhL779pZpFzOUEa0KfqzxCA4TywXBM1Y+eqn5SlzvkFrWtEOr+Ro4zuj2AjmW58jBm8xhyUe01M6JubvrrDHJ1+TBcOwctcC2GRGoDoye9kDkszhGu2gF+DY7NeSzhgw5XkCM+e6qewiwd6YuityJ/hhuTkd3waZrYX5zhMFxpsPCWw0ngqFtbFvaM1crhOsIFnoRzzmqmvOTL858NhO1KZ51vKHoUmb4DjXEQeIfJHUcH5bG+VHJCKL0B+JWY5LHcAJUzBk92mzNBF4vmBYX1unYxxt03s7kQAPI0cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdVn9CNIrqb8EQczWFGD0fpiwKDt9kaDIODFtQdatHs=;
 b=CAltyR84fD+yB60IvD9HzeCPUxn9TKG1G5+6/b1x6m5yHTseI9ZWuwkMpcGDnhKiFjFZC+MGq6nWHWLCIPqALPMBnQgEPBU3OfHJ9ijj1G8dubwDiFGOGmw8TY9Rc4cX3PlERH2oxHSwwnkMgG+y3Dj/PJTOBI3VVczZuH+A3Av3G2SDmALPh9hJtSWPx+juzq5n3soq4UrFt/iJbJzZ/7i0ck9jzFUbUYpmbcyMV2qSAwN0xud8rK38GAvqAh6xmUpWmNjH88KrSiYDByOGOz4MYwMlzax2uoRNu55/tSusHNfwY2BLI5LfgCmnN+a3dX030khugFFGllKCQslU9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 13:34:11 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/14] net: rtnetlink: Stop assuming that IFLA_OFFLOAD_XSTATS_* are dev-backed
Date:   Thu, 24 Feb 2022 15:33:23 +0200
Message-Id: <20220224133335.599529-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb7af4dd-b817-4c68-e8fa-08d9f79a5734
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5416E6121B98CD3E0966ED5CB23D9@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jxges/ygXUkgrs7tQbdndV0SE5c8oHwgt7QmGZsyO/f0gurVmguy2Ij5qG+r72R3i3YiZK5zeoegsGucllMsZBDPs981VQuA2Jw0MQRCi8Wkl9XeDxPu9J545dYkQCE4eoRYwx+x2cCODGaehFzBkjwB7NtKW3xD+c7V+FRYVhTMQk+NLgOtMvEHzlNFkg1n5SR5rGWZICQXsi3PkXAjDDD1dZk36DDyn5BWoBJb6QOc8hW6DX3J3G27rRYoptnQiKwKkzt2LGiw0F+E/nzFgIS1Pn8xGKZMrVR3rRv3J526QeMG4Q6DmmRe2WgVtuNfdTCGFBHiW7TxDMSRlPBBGusv5KHilC5RC/FmWWaAgSp0WoqfpKbi4kjVr+GJ09jJrTVSlkzKNb88zqlg19ir+ji4TMGSsQ63qIDhmsNH8jPEvhyLezE4+DrwXf28HB7iTRi5l77cTyoe4vuj/Gr0DhQfQnAieqaUxZ94xMgIi8xWTqsrQc9b5D1NMIujGBzz2PljJu0T+zTrsuTKKVSItVe0iW3fqVxbu+RLyFSZBTbHklxNEUIiRFEWSrhEqlurqhVSqPS2ZNzrL0SPp4DBaZRL2bomz3upcgSwpqbYMPX541eJErlgx7s+nX5K5rOyP7FrLFEt+RdpZA7RLhqK9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(1076003)(107886003)(186003)(26005)(5660300002)(2616005)(2906002)(36756003)(8936002)(6486002)(38100700002)(508600001)(316002)(6506007)(6666004)(66946007)(66476007)(8676002)(86362001)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PftOgtCOOZ5SSRbo/C1oy7YoEnjJTPVZrcEySDuXKA6SANVYBKh4GtLJ5rNF?=
 =?us-ascii?Q?K7Xl5ZeG40fc//WxfMK4s/1pPC4Sjh6I5WJvmeJQkAF1UcYDBMGc+6TE3z0O?=
 =?us-ascii?Q?epaNATRgmx+ZDwvOhpxMA/E12fJTEHyFXeGlxTZzlVbtQpYY0zbIvBkVdxHJ?=
 =?us-ascii?Q?3YB6Z3aCms79vuHiAfYw5OekxCpQ60YiJYUIPtShZkhOoBxAYTlVh9ikQkvd?=
 =?us-ascii?Q?GHMW/NDDpd1fYswVP2SJDkI/HoFa2h42fNbuVHuYpJL1FnHHNQvL+l6/BaE2?=
 =?us-ascii?Q?uED1v0uVw3Pbk6t6RPtNqrYZ5b1e0iOvhZxlnV+I7RQuNH8OoR5wT5tKgW4q?=
 =?us-ascii?Q?cMVSxmFRh2pva8wyQscvo9onB4ytVpMALSg3jIleP9sW+7YaUvgBnijssbaQ?=
 =?us-ascii?Q?/LdTW5gRODGkJ0hpuoJUxZbkhEuOJnJ7jFQSTfJNQx4JA0oZnisxSC9Mzzpa?=
 =?us-ascii?Q?cLhyjdVygWVvZlcX3yZkREXdqVMNQYuRkia3x/+Zp4bMnuIR4W0XTVcslz/r?=
 =?us-ascii?Q?tmQ8cwJ+i+pcdlFAC04yAWEpMqZ8oUkj8DojGyXS5p6VEdHeRkqwZBVffUgH?=
 =?us-ascii?Q?vNMRikn3DHCSk9qxE99ojuxTw0jz177/9AJer79w+ANy3VYuGXImNRdyjvGO?=
 =?us-ascii?Q?tEk9mQoygJVYr+VXBZNvFpJCuIF0dt+VEQTlFJGZKF4b+MIpy196UzL0BUQx?=
 =?us-ascii?Q?Cq2VxX1SI6ZL7wGMQkUpb3bk/cKl4gczHS9AGkad9LuvuCSJfSKxju5XCWV3?=
 =?us-ascii?Q?i6+1DiWgT6aJqlUiJYJIY59t1xPTz2II2GXeAW6FqJKe6m+hRFXcWZH3MQ+h?=
 =?us-ascii?Q?jB1ezHBKPWs/pyza3QhSLp2s/dDnuoRhAFrNSbTroanWn40DB8O86FNW6h4o?=
 =?us-ascii?Q?x/T+raUGsCoUipE6pMLWcJKsi169BcPvhlQXRRIusg1qe2O89lq5PgkfvuRS?=
 =?us-ascii?Q?lzv7U7LIB0+l8+OvwB0fC2xPxo8RrrEmIn0gdJcrI5kmh5My6kiDDiAopbgA?=
 =?us-ascii?Q?qK6v36AGfrb5L+kSJmP4RtCIdro3FAvJ1Vue1awbxd3YnCTFRekwBy8pXbyr?=
 =?us-ascii?Q?V4fCojvP2svPd4lbO9/dT1EZX4VL64Lk2wKAMeLno2UxUYEToX4x8lXk6s78?=
 =?us-ascii?Q?2SRubq0pNgeZYRYTJQ+wqkfMgPaUmE32+eSfqV6YFdjWMJb4HAJrTv10JSOM?=
 =?us-ascii?Q?+AWBtrdtcNt33gaDQClWvo5v2Sq1QBTipZVQqKKuGNxufBrfWdpEGsLZaxH0?=
 =?us-ascii?Q?Mvs0T8n2Soe0GCXPnqvOutkYZF4iPmS/zju1tLqYPilzCHWGs0gG8CyDl6kv?=
 =?us-ascii?Q?Djl0z9+yA6i6OiFq7zVf44/RMbw8X8OgWuENrUFpT4R+yTZnE/Xk8n2+IYIr?=
 =?us-ascii?Q?QBPMyS5US+eqxmIF7T3Sy0fGZQd8NoxC3W4yTC3JM1qifqqcMDFUhs41Lfqx?=
 =?us-ascii?Q?vGXtNqbIe1YMeCegJcgqzV2x3YkEAKbFcBqtMQDdd8IEAdqHKGwrYj9Vr9e2?=
 =?us-ascii?Q?B5hHzuZl2I1S1JSldqiTpFnDN2raJR5xZyLIIcvQOCBqW2awqA35WKEmGt8g?=
 =?us-ascii?Q?CMzTZEpY8XryOzotGi08HJ9JBsejELRXTx6i0az+pGTtvA/towi/f9BEj/H7?=
 =?us-ascii?Q?pRMnp61b6sl8w5IXvLNr6ZU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb7af4dd-b817-4c68-e8fa-08d9f79a5734
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:11.1307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2E+oiEsEGjQ+ws0ZwS6xUr36oc+o3ixPfnrD+Z7xzOtOxUvJ/RgpZeSNkz5l6CFtXkgL4GeAZSd2QU2X7K6yg==
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

