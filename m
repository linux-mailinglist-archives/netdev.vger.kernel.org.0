Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A9D45DA50
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 13:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348673AbhKYMvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 07:51:52 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:55918 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343676AbhKYMuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 07:50:37 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 433D76C0061;
        Thu, 25 Nov 2021 12:47:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIeXhuAeuhDpS/QpWyKmlHZpdxxw603ZWLk+Gv9tQ5Tj8ksBJd4IvMulmTig8YDp7Fs3PHtLA8Z6bkf1VgPmD/WGEBsiqiuZnTC7GX7WmicVg+RblbYbdrOUcGRTA/WXm/i35xRHsk6gEtwKjNkQvLh0VtTtlqmH4j45LwS6c52spd00Hx5FIaBmfNzCL+Nsa9G1SGtepOQ38EJSCAMA6UpjPAcBqEoG1IU/acMCawDo2eAB34PNiu98QqAfDU1X7EZsSAblLa9F7dgbZlXJN4jSyWrZ3nvBZX4UAlAHFNZ6JoEb0P6oDBARQxdCfB/YNAQMGK4+6SxjH4zc3ijm5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssCcNaUBlAOuRDOyOIPcgKl7BCOTOSxR6/gDHDk9fzM=;
 b=h8Q0AZ/xoWFHVqYmSeDcr3o7+99qayNOHDevXLSZDY/1P9XxQapvcStMw1s8BKEUIrhf3Xzqx56KC23/qw78PhF86+zH7blMjYJaJ/gjMwa47hcRtypX+gHWTuK9w+vtb969iz3PH5bEvWHQcds81cGE+yxDbRnoPzvieX6F7QlExczAWMwsdYoWgszlv2CdrjksTs1pLxBoJszXaHtkry/qoRMnUhtiOkHudgGp6WPCu4sCk4d2CNU7hvOn163oXXw5zCcmZpKeCdBgP8SJ2QdllYmd17m5bJV1lWkUkZxOCreAVvM25TqZj1v2hnnjxjZ+d7nwemMOXF+A4NymGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssCcNaUBlAOuRDOyOIPcgKl7BCOTOSxR6/gDHDk9fzM=;
 b=k1W57Uq/4VwbpjDnXvTz7OP10M+vgsqBQZ3H35d41VXwbrSKCHy/tpBl+Xx/6+Kz1mVKM/DJjyJr8Hx3acCZOJX98SdIXf29DaRW6k2WaQteuQOO0IsyB33PkgvIfY7FZ/bbD3HW0WS/X21zOJQOg95NlkXvDsSBTqMhvY4qb1E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VE1PR08MB5613.eurprd08.prod.outlook.com (2603:10a6:800:1a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Thu, 25 Nov
 2021 12:47:22 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d%6]) with mapi id 15.20.4713.027; Thu, 25 Nov 2021
 12:47:22 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com
Subject: [PATCH net-next v2] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Thu, 25 Nov 2021 14:47:13 +0200
Message-Id: <20211125124713.9410-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AS8P189CA0002.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::21) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc.dev.drivenets.net (82.166.105.36) by AS8P189CA0002.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 25 Nov 2021 12:47:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68547364-e469-40f6-bd69-08d9b011b9ab
X-MS-TrafficTypeDiagnostic: VE1PR08MB5613:
X-Microsoft-Antispam-PRVS: <VE1PR08MB5613876930F0F359957908CACC629@VE1PR08MB5613.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BRLOmHLW8YmgGQnBboQJBaoGY1ydwHL0tIdzH4FThzriBlBE/78hmeFUn2GVxb/gTUmgzoW7H3PxPxYPU2xrDWzEywzaNizYVT/i61dgRAlxE8LJr5T+BqeqKBXov4ACMGGB6GRmDaWRijdzcqWRNjKLVm5JlDPsjQeGqCi7I3spSz2/AYHtAFTvJF6LxIQCZHzxZHjjj78BRIWNjHN4csMBrJUnnm4k1TWtM+a/7nF+5Yns2tuaNBTjc67FrceT1qf0pn3n/7sXNg+iNWnrKkmX3pKbj4bnv1dUuDvCtsJ61ZF7N50aCfwLAZyFDKYOhF+O0tjfdKIg5bmcfPpdgTfgRfKj7gJgAfWNf4qrHdZzCH2yThpd3DLHDJa/+yJQ5at3XfCezkJfQsfV5sVmZ+3sCSUbb4qSINeL3OdI/b+P21s2d92Vk5mGJBMfv68I/U1/UDVVWIbhJjCArSXKLgjkRqNE02qJDuJH71VMx45ejMgNgMMiRC/+i+Ta5c/TjvZgxN3H3YWnpTloCitVYWRKxMXDQLLd3XKIpYeJw/wj6n0g38x2HOX77/oYND+8HMquZVptrIhN9hGxZWvCl4hstau0Atls5CtLAUj4sXAcp+YtY6826SCbEQBRFZJl4KSOCCwZ+gtCwORujP9HvvFq4UAswWHatBgQJmqFiNx+pRG4u0ZGYgLd58Os3ceYR6eHBiILrZvkNpCELVgti/idf3y410btOcyq2IaRzg4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(508600001)(52116002)(6506007)(86362001)(316002)(6666004)(6486002)(66476007)(36756003)(66574015)(26005)(83380400001)(6512007)(38100700002)(66946007)(6916009)(66556008)(1076003)(8676002)(4326008)(186003)(2906002)(956004)(8936002)(38350700002)(2616005)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aAJjAvijgKP8oXJHtzJhq9TruiWFg/rKyeMGW6E4I6SIXTHgAwVZmEwLZZ95?=
 =?us-ascii?Q?Jk4d50U9CoVmYhSg63iY2FHkw/bYGUBiyEsA++1S2u4h6VFwYSC4bUfgVTEz?=
 =?us-ascii?Q?JEGLntFBZibVQSJ8h+cnP9xafBVBvSJICHcnF8kfTsBe2fGIyLRS71dD8r9+?=
 =?us-ascii?Q?Pzp5Oh3Qv3HirzNdvSaUAGoK9tMR2XSdltvRpwPsyuTFI/SznKUu783Zc2Ne?=
 =?us-ascii?Q?Pkd73jH1Q4zxV0tDDwvmTZmcW7sywYyeR6QsABHRRXfkeQIfzDnq2fsj5QZN?=
 =?us-ascii?Q?ovAqffN4pmp4kw5T+7/tJ5lHjrclPiljM/9nessEP7kbr+cQ8E2aqVo3MNzh?=
 =?us-ascii?Q?EapFT5bmao5trCQuzTrE+0qkt+K7MWjmzvzC7rph/bNpemZdR7Cjx7hLR0h0?=
 =?us-ascii?Q?2BQzlbmCEvK2u+TZZGI6aN/nn6xp8W3D2/aebApNeCRmsd7xrcSro06pKE2D?=
 =?us-ascii?Q?FKCyxBR9IwJLcp7NMzG31ikgOF0PYH7GpUvHo2iF6QIHk8JBTQBifDUdHab4?=
 =?us-ascii?Q?QkzOEum1pKO4/tcXiVNukMnSLNHythjdxB8GtolR2hsWxWgLJDnyZML6xsrV?=
 =?us-ascii?Q?BTKH5TDZsWG1kztseAjyxxtTjhLf9Pe6iaZPkhwS/5d6s8D3b6mSQcttorTN?=
 =?us-ascii?Q?i0Tiu6szmPMGD9JO9iNUunsqyZdwyK4rT9jKobaUOGw7opyDyW4TnSSCAjjl?=
 =?us-ascii?Q?u0CP3jXiefrZhxBDyUg7NhaV+cCu/3pE/kxQzPDv5441l6Q+IoaCfIepqtBO?=
 =?us-ascii?Q?4uIaD62pKdmULhOdxYT1lfh93UCsWmR8QGcC6WZsJKvXZKwJpG0PtAOXY+oq?=
 =?us-ascii?Q?EOAq501mkO+uOwZbOIr+3C1iO/VjLPiMCmBNSRMrNU8jX8+X2a1rAEYp1E8t?=
 =?us-ascii?Q?0hnRk9u2lbrJaoo/HNytTPqpH951e4WrljaYMx0uLlPkELmICXUkYZ1QPagH?=
 =?us-ascii?Q?jZgp0MXlvQ8mbs5TsASh46j2SK5YOBb+FVN/MYZyvELNh/5NEBQe6nXm3q9S?=
 =?us-ascii?Q?kB6ksOiH8daHUg7LFWyT7l69FeRfQXHbZ2AeGsgsBAZN9wWoAZkeY1Raqr6E?=
 =?us-ascii?Q?jgUSbf12HUIehcwUxEUfsbbAKGPahVUhh42AYKXxxcaEzMtp0P/vAiwiF6jc?=
 =?us-ascii?Q?3d1X205jcX498UysjQshjs2ezx80NmkfsHghkdno7QbEjBnwZ0EXDtsJUcRs?=
 =?us-ascii?Q?84ksI8uFCCogwiT4tPtCQCyTxVTRKNfu+6CW669dm03kqOyyNSDBwprXZpdD?=
 =?us-ascii?Q?AG8uGjH3DCA6maXPXclW7El6aHBZrKrlBCoiH4x+iszWEhw6ZGtM8Xu7C22n?=
 =?us-ascii?Q?THtmxT9fu26TxjjwV8ENuj+jn45fYHuXF2IUN5kRdznzsUDjw0Fd5t104rWu?=
 =?us-ascii?Q?RhcdURwmv8Y1/bbyNDrh2xV86LrzqQwj7C41v0nUK8ULbrCpaqTUvJ3y5PM7?=
 =?us-ascii?Q?qaSuMyrlAwcim37Vk1tsa2u7jbks8RPA6xRNiEx1CBO5q3PrQsh1UAdUb6Q9?=
 =?us-ascii?Q?nuq9fTM+iXTLHzr+p0qhOLmmiMnCuMSN/gW5qdN0WaMxJbmryF/E3TLcZaz7?=
 =?us-ascii?Q?QJxxB5nGY/ky1iNrw9yJ8p+ZfQVfkUPSAmm/EJl5biQ80ujoOlH9yHnCmmkO?=
 =?us-ascii?Q?vILp+yFNCuMR3Fg908++//W0mnQ+l3XMJSsfRsQrDOzeGuL8XnscdpIkKI09?=
 =?us-ascii?Q?PYntCg=3D=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68547364-e469-40f6-bd69-08d9b011b9ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 12:47:22.7657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lMukUt9tznuK4xDnFdI3rbrWcHXPwIupNHxpAjxBU+6mEHyui/pjLcMW7Lh+ws6lZmqCPRcue+Utlkun/xRIxxco8yuHBigUF5QIJub0vM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5613
X-MDID: 1637844444-oxL1Lrgu2u21
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
devices to delete with a new IFLA_IFINDEX_LIST attribute.
This gives a more fine-grained control over which devices to delete,
while still resulting in rcu_barrier() being called only once.
Indeed, the timings of using this new API to delete 10K devices is
the same as using the existing "group" deletion.

The size constraints on the attribute means the API can delete at most
16382 devices in a single request.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
v1 -> v2
 - Unset 'len' of IFLA_IFINDEX_LIST in policy.
 - Use __dev_get_by_index() instead of n^2 loop.
 - Return -ENODEV if any ifindex is not present.
 - Saved devices in an array.
 - Fix formatting.

 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         | 53 ++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

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
index fd030e02f16d..9cf41de05898 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_IFINDEX_LIST]	= { .type = NLA_BINARY },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3050,6 +3051,55 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
+static int rtnl_list_dellink(struct net *net, void *ifindex_list, int size)
+{
+	const int num_devices = size / sizeof(int);
+	struct net_device **dev_list;
+	LIST_HEAD(list_kill);
+	int i, ret;
+
+	if (size < 0 || size % sizeof(int))
+		return -EINVAL;
+
+	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
+	if (!dev_list)
+		return -ENOMEM;
+
+	for (i = 0; i < num_devices; i++) {
+		const struct rtnl_link_ops *ops;
+		struct net_device *dev;
+
+		ret = -ENODEV;
+		dev = __dev_get_by_index(net, ((int *)ifindex_list)[i]);
+		if (!dev)
+			goto out_free;
+
+		ret = -EOPNOTSUPP;
+		ops = dev->rtnl_link_ops;
+		if (!ops || !ops->dellink)
+			goto out_free;
+
+		dev_list[i] = dev;
+	}
+
+	for (i = 0; i < num_devices; i++) {
+		const struct rtnl_link_ops *ops;
+		struct net_device *dev;
+
+		dev = dev_list[i];
+		ops = dev->rtnl_link_ops;
+		ops->dellink(dev, &list_kill);
+	}
+
+	unregister_netdevice_many(&list_kill);
+
+	ret = 0;
+
+out_free:
+	kfree(dev_list);
+	return ret;
+}
+
 int rtnl_delete_link(struct net_device *dev)
 {
 	const struct rtnl_link_ops *ops;
@@ -3102,6 +3152,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 				   tb[IFLA_ALT_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
+	else if (tb[IFLA_IFINDEX_LIST])
+		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
+					nla_len(tb[IFLA_IFINDEX_LIST]));
 	else
 		goto out;
 
-- 
2.25.1

