Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC6483DDE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiADILb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:11:31 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:47308 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232557AbiADILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:11:10 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2054.outbound.protection.outlook.com [104.47.0.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5242F80071;
        Tue,  4 Jan 2022 08:11:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2hLcmyOWlK0xOZsfxuuqV8GJfRhXw/gq48ZenyWr8Dd/R9vsSbPvJU2JxVJJXCtk/ayST88NTpDn/RHdvGFzeEc2ji4EYqY0NOby4keYT055a9Ut0wVKvis5lxZccom9EDPkMpPcci2F3L2ahiCqKEeICns+T8PcaBVn2W7tFwOHBxFo1FR2Gy85044S1czI2LFZT4j1iiw/dd+IsPboN8r7dlB/qXLPbonIxCunql5306BiriiFRW31WlWnXJUTFaHvOJ5KpLoNv8Ur66OjD4+dV6MH2hL07tLtpqv4YDKCVIdg0MTmon3RlTW/CLIlHEW1ZataJV/kmzKK8VeOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKAUE06PpRsWSC7B09vqGeMohgBAb6xRkIRhX769o6o=;
 b=eqPG/VJ8ihz5oMCIQpPAKWJxKd0ukQAU1US+TFXMR6aGwjO8YZ/thLekOkoFGl+iOeBEkE1rGsI2sV1e55ZSpcB1OyN2/3USIV8NFg8ctYnX9Kq8rNKAbxMjmrLXeQU7xio8SlS4m/zD3fP3yf7FQMcXMoyZierskTSbNJ/s1kLSFdFgVucDfkfuRf9rWsed9E8bQ5CZhv0CBgtfqjxDrKK3VIY/Iyv0fsa/T8P/HZufdBbPjwpUApbTL3HeZscgvCJHzQNmW6xGmctwMCCrrlEcdEHpJafPDnR3on5g1cF+sD0RDCNSDo0tm5+H5k0/8oO+RZPhuUTbGXJBULPs0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKAUE06PpRsWSC7B09vqGeMohgBAb6xRkIRhX769o6o=;
 b=bOPB4nBolgeQA7TIP1dzH2IA3BdO7dHpkI7eaJYuLAlAUkqQ49wwPJ8XMmMHEEaqowgx1J1VPptmRkM2tdKAiLuiYXCGhOJgXmbEIm2Eherye0zXnCwPhIGX0rUx32AcKQmi8XKT9IF8MBUy6P48Wb2QYOOlwAUhIngIhEzFKKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0802MB2464.eurprd08.prod.outlook.com (2603:10a6:800:ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 08:11:04 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 08:11:04 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, kuba@kernel.org, idosch@idosch.org,
        nicolas.dichtel@6wind.com, nikolay@nvidia.com
Subject: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Tue,  4 Jan 2022 10:10:53 +0200
Message-Id: <20220104081053.33416-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0111.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::13) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86d018c2-dc06-4596-5312-08d9cf59c085
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2464:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0802MB2464FCBE64DFBFEC5EA0BDE4CC4A9@VI1PR0802MB2464.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:73;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWdshCSuo8Li7hO273VYZacuT362f7Dmh/GGi73+GrWYmSPs7CgXFsXCvb2PEi5z+ng8NVYb8UFtPxAyDvqWkyjXTHEFh+4sVZzt7mFWlNhvJBa8L7jSL9jvmcQQCnBjaMlSLQAulgmwTJ/9V8TiquWIB3UoUk9qoTIpJPs2HLnFKmwwnGYixkiVM66XC7OMVZkZ75V0iNlrvPvVB4cGj5nqmstwUFtPPV+Hq8EKECz50Wn6OqwiiwBJhCxY8QkBegemWMDCt6DBm/4KNIvirA71U3LFaP3zDmyHCzk1NtoputXRLqIZ57kV8Bm5eFTC2/e4jW/col4dTmQem2OO3Ok8aaDTXeEzVNB3yItAVuVgXc9nk7Bsh5hN8k4KQDr74D4mxSGZCaHB2h9kKPOR9RZjn1srmUyZUP8yQj0Oc6OIxACPkYPeoxL+otbSCgUBUbnADA9gdGnGsWFe8UDO5SWj3JEfUZXVMrCx3F9kqZp9qihY7L7H9w6wUsQmG5YhC78ehAoHgW86S7DGFpdnE0Ym9CGmvQN1WT1iO5V1g0cqy48FMxSxdKQfu0PeNLmd0uz87bgGSiMBzsRPYUSRsYFQ/rG789BeWEpwZ0bK2K21eNJPan5mDHGanoJYoKyyZoR4K7FDeDXk8hxPSSV7AEDgzPbSEXb/DsCoh9+y9z/revTBefA9YVatawUGNWPrzgRKdTpBRqP2G6Sa2vkfzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(38350700002)(6506007)(2616005)(52116002)(5660300002)(36756003)(186003)(2906002)(66556008)(66946007)(6486002)(26005)(66476007)(6666004)(6512007)(8936002)(8676002)(66574015)(508600001)(1076003)(316002)(6916009)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VMmd6nFMJYvttwIbG5UUj6I8djtjUs9Fdt2IXrG33OuUVDsF8UA7c3hFo9hi?=
 =?us-ascii?Q?4/ElIcAidmjNMuLHXvsDa20MmBDjcJ2fmYb9aRZWDWdYx2Jtm13hKnznSVDd?=
 =?us-ascii?Q?s0SCNrUGPncKZsq56VDSXDyIKg5EPop1bJSmOmFR4pVJUGuVCo/apd2rQTc9?=
 =?us-ascii?Q?n5r4WgI+w5mY+LKklRtF45lqfxd+SminOcBLMAzlDrjVaXeHpdKgVvLOzxcF?=
 =?us-ascii?Q?DtAVfUQKHabzEGWpFV51xvT33QLStb4lQ1GEmBMJwiBzhGD05GlBqBH5fwFM?=
 =?us-ascii?Q?kADH1qsqyZeksdMPaJ5R/lKi1jeZPnXlmnTRVnXzzzOiSryIfS6Dk7cgACAo?=
 =?us-ascii?Q?HdRDSlmz6CFpWmcg4OFMKlyAJ2QE9Vi+e6KjK2bj35z6kx3ukhfCYgM5Gxl3?=
 =?us-ascii?Q?p8gKgfIgq6s/X9243IOTrVAuA54Nj8YrKI63VHaUClAa8vdookYKwgb0d0pN?=
 =?us-ascii?Q?ig2qjyIg7KbhmsPKIOuknqO0w7vHihrsCtQNUwIO/CpnY/QJ/sPKEpmRpjX0?=
 =?us-ascii?Q?ZKCS0C5sOA63Rn0+ZFyNMiFu3JHqrdBIFDi9rb0d5IwmL8eLU5DlKQRy45VL?=
 =?us-ascii?Q?32ePsubSaNvfdG8M0JBY+dK7sYR+MjwCTp8X2ikc0rKt6pNiL/M4+eF2tqOQ?=
 =?us-ascii?Q?2Iw2YYH8UzPsNGA0uuhdhsvcEkKwwjxtInavI31iQ5Zp0GbOFt21d+BZDbQY?=
 =?us-ascii?Q?ipv8gqSCHJdLJXFyWlJHU9iAFrVr+Eyr93zuhBwwjqn6RH0e2/uOD81aJqFl?=
 =?us-ascii?Q?rpG86/NEcpZfbBWGADrC8g2OhSETLaLOs5nwpH2m2BYgu8M6hYGc2jdiI3B7?=
 =?us-ascii?Q?56ZAswG3d45e1RU8fiohd81MQDgAkQlOijwgtiEYnJXKrprkPtxsom3+PSsy?=
 =?us-ascii?Q?rDcFnCz62AWQl8dgo1zL0KL5JrBEWhYLfkBsVk53pcWHJIXNPvonvBtFWesl?=
 =?us-ascii?Q?WkAqiq61xFldWBlAnrRiSM0bEMcJ99+u1SSsZ3eAgtkxR+z4s9t4g7zUSne+?=
 =?us-ascii?Q?+lftabA8RVgfKG81OwZLteYAJJD19WVOqbTMt4kbJIC3Wlhp41B1E68UNp5y?=
 =?us-ascii?Q?kM9qWnuDAf5bsqtHCFdIzqrzmeiIZuUecfHEiHPYCPrB/5Ue+1d77yVTZeZW?=
 =?us-ascii?Q?ehoQTEEOip6YW2+j8Fa3qt/fKPEpkt2+mAhNNPBoznGjF7kgtDjTwUu3qEzD?=
 =?us-ascii?Q?adJ8aKti88jp2dKqwEYFf2N3ENWZ8yeHfcXP3v9SgIcGPUVrw2U9SnBpiH0W?=
 =?us-ascii?Q?yk88mhKV7tjEEmhpJ9b+ErPyx2hroHlwnU3+/HwKq+Tjr6QC8gS8U1vlsEOd?=
 =?us-ascii?Q?T8Nm6msB1n277ek0wqKrDhyLpBu3sxaks02bXTyRk5mCjRP8MOH3lcx2P/fe?=
 =?us-ascii?Q?viNuR3YGIxoJ8YDXZ7THxHZYBmCxpm3Avc5D4QCofEmBFIrL0Y0t9sWPIg4C?=
 =?us-ascii?Q?JRspjXRXKdz6RtkLjbQTeKkoXsxVR05UzAE/AAjSPvzq6BvHShjUA3uQmqXO?=
 =?us-ascii?Q?2VrjWrdBZ3dN1Y8bGShKH45jZL/3tOXL9/M6a9m6Cbi1JWTj7iSesLj+LGXm?=
 =?us-ascii?Q?9gTaZ2QM776ddFj4wh421J10ghsGB47oG4m0z4M9GU/zjWogtzhhMWiYVAiG?=
 =?us-ascii?Q?Wo4iFOhCjdWP8u6Ye1ettkdF2Sm3yXpnHtLAKjy0dX2Oj8mjMoDpcwpr/Rwh?=
 =?us-ascii?Q?7S0k000mmIj9EcB0EV4RVouUloY=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d018c2-dc06-4596-5312-08d9cf59c085
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 08:11:04.1066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3osse9OsIS4wyNtlJ+JpZlDOHI/zLROZP5WoAXGtZWcUb/X8SaL1w8lTsN3Bf9low3O5o9yobftmmAEZkmG+1FwkIsKaidNoNE50TaF1UE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2464
X-MDID: 1641283868-qMkV-cnA4swZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under large scale, some routers are required to support tens of thousands
of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
vrfs, etc).
At times such routers are required to delete massive amounts of devices
at once, such as when a factory reset is performed on the router (causing
a deletion of all devices), or when a configuration is restored after an
upgrade, or as a request from an operator.

Currently there are 2 means of deleting devices using Netlink:
1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
or by name using IFLA_IFNAME)
2. Delete all device that belong to a group (using IFLA_GROUP)

Deletion of devices one-by-one has poor performance on large scale of
devices compared to "group deletion":
After all device are handled, netdev_run_todo() is called which
calls rcu_barrier() to finish any outstanding RCU callbacks that were
registered during the deletion of the device, then wait until the
refcount of all the devices is 0, then perform final cleanups.

However, calling rcu_barrier() is a very costly operation, each call
taking in the order of 10s of milliseconds.

When deleting a large number of device one-by-one, rcu_barrier()
will be called for each device being deleted.
As an example, following benchmark deletes 10K loopback devices,
all of which are UP and with only IPv6 LLA being configured:

1. Deleting one-by-one using 1 thread : 243 seconds
2. Deleting one-by-one using 10 thread: 70 seconds
3. Deleting one-by-one using 50 thread: 54 seconds
4. Deleting all using "group deletion": 30 seconds

Note that even though the deletion logic takes place under the rtnl
lock, since the call to rcu_barrier() is outside the lock we gain
some improvements.

But, while "group deletion" is the fastest, it is not suited for
deleting large number of arbitrary devices which are unknown a head of
time. Furthermore, moving large number of devices to a group is also a
costly operation.

This patch adds support for passing an arbitrary list of ifindex of
devices to delete with a new IFLA_IFINDEX attribute. A single message
may contain multiple instances of this attribute).
This gives a more fine-grained control over which devices to delete,
while still resulting in rcu_barrier() being called only once.
Indeed, the timings of using this new API to delete 10K devices is
the same as using the existing "group" deletion.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
v5 -> v6
 - Convert back to single IFLA_IFINDEX_LIST attribute instead of
   IFLA_IFINDEX
 - Added struct net_device::bulk_delete to avoid sorting ifindex list,
   in order to call ->dellink() only once per potentially duplicated ifindex
   (no increase in struct size)
 - Make sure IFLA_IFINDEX_LIST cannot be used in
   setlink()/newlink()/getlink()

v4 -> v5
 - Don't call ->dellink() multiple times if device is duplicated.

v3 -> v4
 - Change single IFLA_INDEX_LIST into multiple IFLA_IFINDEX
 - Fail if passing both IFLA_GROUP and at least one IFLA_IFNEX

v2 -> v3
 - Rename 'ifindex_list' to 'ifindices', and pass it as int*
 - Clamp 'ops' variable in second loop.

v1 -> v2
 - Unset 'len' of IFLA_IFINDEX_LIST in policy.
 - Use __dev_get_by_index() instead of n^2 loop.
 - Return -ENODEV if any ifindex is not present.
 - Saved devices in an array.
 - Fix formatting.

 include/linux/netdevice.h    |  3 ++
 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         | 77 ++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index df049864661d..c3cfbfaf7f06 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1926,6 +1926,8 @@ enum netdev_ml_priv_type {
  *
  *	@threaded:	napi threaded mode is enabled
  *
+ *	@bulk_delete:	Device is marked for of bulk deletion
+ *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
  *				to another network namespace.
@@ -2258,6 +2260,7 @@ struct net_device {
 	bool			proto_down;
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
+	unsigned		bulk_delete:1;
 
 	struct list_head	net_notifier_list;
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..f950bf6ed025 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -348,6 +348,7 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 
+	IFLA_IFINDEX_LIST,
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index fd030e02f16d..530371767565 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_IFINDEX_LIST]     = { .type = NLA_BINARY },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3009,6 +3010,11 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
+	if (tb[IFLA_IFINDEX_LIST]) {
+		NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in setlink");
+		goto errout;
+	}
+
 	err = do_setlink(skb, dev, ifm, extack, tb, ifname, 0);
 errout:
 	return err;
@@ -3050,6 +3056,57 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
+static int rtnl_list_dellink(struct net *net, int *ifindices, int size,
+			     struct netlink_ext_ack *extack)
+{
+	const int num_devices = size / sizeof(int);
+	struct net_device *dev;
+	LIST_HEAD(list_kill);
+	int i, j, ret;
+
+	if (size <= 0 || size % sizeof(int))
+		return -EINVAL;
+
+	for (i = 0; i < num_devices; i++) {
+		const struct rtnl_link_ops *ops;
+
+		ret = -ENODEV;
+		dev = __dev_get_by_index(net, ifindices[i]);
+		if (!dev) {
+			NL_SET_ERR_MSG(extack, "Unknown ifindex");
+			goto cleanup;
+		}
+
+		ret = -EOPNOTSUPP;
+		ops = dev->rtnl_link_ops;
+		if (!ops || !ops->dellink) {
+			NL_SET_ERR_MSG(extack, "Device cannot be deleted");
+			goto cleanup;
+		}
+
+		dev->bulk_delete = 1;
+	}
+
+	for_each_netdev(net, dev) {
+		if (dev->bulk_delete) {
+			dev->rtnl_link_ops->dellink(dev, &list_kill);
+			dev->bulk_delete = 0;
+		}
+	}
+
+	unregister_netdevice_many(&list_kill);
+
+	return 0;
+
+cleanup:
+	for (j = 0; j < i; j++) {
+		dev = __dev_get_by_index(net, ifindices[j]);
+		dev->bulk_delete = 0;
+	}
+
+	return ret;
+}
+
 int rtnl_delete_link(struct net_device *dev)
 {
 	const struct rtnl_link_ops *ops;
@@ -3093,6 +3150,11 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return PTR_ERR(tgt_net);
 	}
 
+	if (tb[IFLA_GROUP] && tb[IFLA_IFINDEX_LIST]) {
+		NL_SET_ERR_MSG(extack, "Can't pass both IFLA_GROUP and IFLA_IFINDEX_LIST");
+		return -EOPNOTSUPP;
+	}
+
 	err = -EINVAL;
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
@@ -3102,6 +3164,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 				   tb[IFLA_ALT_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
+	else if (tb[IFLA_IFINDEX_LIST])
+		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
+					nla_len(tb[IFLA_IFINDEX_LIST]), extack);
 	else
 		goto out;
 
@@ -3285,6 +3350,12 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	else
 		ifname[0] = '\0';
 
+	err = -EINVAL;
+	if (tb[IFLA_IFINDEX_LIST]) {
+		NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in newlink");
+		return err;
+	}
+
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(net, ifm->ifi_index);
@@ -3577,6 +3648,12 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
+	err = -EINVAL;
+	if (tb[IFLA_IFINDEX_LIST]) {
+		NL_SET_ERR_MSG(extack, "ifindex list attribute cannot be used in getlink");
+		return err;
+	}
+
 	if (tb[IFLA_TARGET_NETNSID]) {
 		netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
 		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);
-- 
2.25.1

