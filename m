Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A60468A43
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 10:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhLEJkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 04:40:49 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:42644 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232727AbhLEJkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 04:40:49 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2057.outbound.protection.outlook.com [104.47.12.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 43C5680071;
        Sun,  5 Dec 2021 09:37:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUqiD4BRFvOeDMnJ9xld/hkx2J/4BO8Ofrs5x36QE/NkNHZlt8VVyyYQZas4dHho+MGjlZzXKk9AoKl0fuojsfXtiF5a4iyRm9ukuUBZmo47ZPZE1yZv0IuNcw/mQ+P5miRgOp15rMMRD+v14asbhux699kXVBwT11qMA9Ta7WETHpGvsLtdefY2IWkvMOaSk5rG4Urcoohz2/CxYtj6v+kuZiT2qLNDURGxveEUQwtw79cIOHjuu3BIxNsQ0xKfvQUYQnWLy8t2eYTRBn3apPcLmzVEeGU3gl90kz5iYdJ5qWp1Lo3XAvwCL+TI1+yItGrSGW7qfnfhamZKJfYCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAVy4cFllSXzrG/qdTgjHQjAbJiTQtOXsRDDwGE1lRk=;
 b=e/txKAQuYn/nSoA+1ugfURd/PntDywpwxSdZ/eHPAeycrzSonaED5r4Z2jQwpd+cpK+M8pD3T1DByf5CMzHh/kh0v0U5GcPC6RUrl400UM1+oTkfLIKevBPM7I5hL3uBOohaCHX+H/qou+mxvjVvRI4cbO8Egx9cR/mOI85RelzL1PqG+Nl3OeyGxV8ztCoIedN/Hje+rdEW0gs2RBH1KAMRTsdob9ynYNhu//tusIDq5pMCvDXc8W/0h9xbBETlX4od7IPkyqum84H1gwgB5awW93LFIn2wUMVyaAJOeXoTVlw1fRafz6my7K7YZDkB4Hig32XkP0Pn43wO7Fr1QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAVy4cFllSXzrG/qdTgjHQjAbJiTQtOXsRDDwGE1lRk=;
 b=VyttVT/R+VppYIyvNPpZGPCynm6lUFV3jXkcC8ybDMlbEyJbsXfKBgOEfOrPONd6SKqyGMW41TY5yprbyEMpBH5vcfh6QwhS/SwW/EpVzf9sNK6o2G2qgZy5atn+QxvgCWutDzk+Bv8Cq2XJERDiFsXGOPqU3/9U+r+6UJRhKCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VE1PR08MB4942.eurprd08.prod.outlook.com (2603:10a6:803:10f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Sun, 5 Dec
 2021 09:37:19 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.021; Sun, 5 Dec 2021
 09:37:19 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com, nikolay@nvidia.com
Subject: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Sun,  5 Dec 2021 11:36:58 +0200
Message-Id: <20211205093658.37107-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0142.eurprd05.prod.outlook.com
 (2603:10a6:207:3::20) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc.dev.drivenets.net (82.166.105.36) by AM3PR05CA0142.eurprd05.prod.outlook.com (2603:10a6:207:3::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sun, 5 Dec 2021 09:37:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b73a280e-4115-4d7c-8d29-08d9b7d2d488
X-MS-TrafficTypeDiagnostic: VE1PR08MB4942:
X-Microsoft-Antispam-PRVS: <VE1PR08MB4942B3F60106CD0C35900F26CC6C9@VE1PR08MB4942.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hhvl0lMdPcIOwrOk6FIqYR98tV/XHVsyVLUt3/jFXFjMT8Dzjzr4e9VwtSBylt0WWyVvtgQxohF8cOua69eolQg6ZTSGIn6ahpnXwX2ElnlR2QvUiYeGmgC8K/WGzLq1wxl9JnkEGjCPrrNgmd/VN73iadxI1L+Pppx2bFSzhokQPTaLHUsDA+HfaXgG6deG/GYumrFE1SAgvdAThBB+Fb13IxYNGeCLOHOPkFIWplvjpB9yl8uQgNerldns61cxPVuMmFYmOtmWWmmskb+y8XC4deeMFu3+fYaHiRGrTV6ds4IYCfgFC3q83nGr5vxU5rOwb1SvMGHV+LKhkxizuVsSrPk3V42BgOnTfblvC2MI1CtQBGISHUgYPH+TiijZ21pJR1REE5S2+HWQ4VJRDxeD0iOGiyuYe0A8CL8KOEz1s31IlXYcfxnBBo4ECdZvUzc/4DTrUZY4E2HgAslUxli8atyGKTs39Jo9hTQtarhsb2eZqsTHld6x0Uvwv8s/oD+21JGXSFGtxrB+VpAUnLRcVkMfKwBZmg1XzgbXvCGpJ3jMyNxspB6prUI7fo5ixERYw0WogTaylN5IAYhzip4azg60bbz2gfuFI+JotavGvbYhwq4znLM8WysCk/QVjGcOmpeiPF5PwaBXDjwKa70pybdAgxh+tKQHKJJVusRjMCrWFl5XHaywSZ0NkwRSSzjFN5qaycoHlesml6SN6GwoY9hhJk+icz5SpzaC+nU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(83380400001)(2616005)(2906002)(6512007)(6486002)(956004)(66556008)(66476007)(38350700002)(38100700002)(36756003)(66946007)(52116002)(5660300002)(66574015)(4326008)(26005)(508600001)(186003)(6506007)(316002)(6666004)(86362001)(8936002)(6916009)(8676002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2nYRVsKfwVw9KMoN4US0AG1G7OsIyJHl0DH8cfFpPsw5g8nkO0fQUyWxyTIS?=
 =?us-ascii?Q?5iRYEmZWQJa3FXnlFjIabca28aJBA+77oKWKA49yO4aDHbO04myKV4BWjWBM?=
 =?us-ascii?Q?QXWHpOn3dmXdD4yOWO03uxwYq5i5M/oa8+YNdfeuN8OworyDBNSC4SrJqOQv?=
 =?us-ascii?Q?htEjgFtOc3+eSZ5KsegxQC/qA78kvhr/pJ+hk7hlaB86vxZtzB2hCXEgUN3d?=
 =?us-ascii?Q?G8a6e7EzGJmGiQC5ZKQFNFx6YwIKj+GOJvOt31HLQmFoJdoH2deOshx1Ee40?=
 =?us-ascii?Q?Ibwx4l6OvN3PLYVdHc6rGMeKlC8bas7xe0vCQw5iiwZweZJonvLY7GVeNMNr?=
 =?us-ascii?Q?vvQLyB3+sGcKcc7+VCCEylwCfoHyiI+TWvCWhFKcYJdjGSz7dskK7IDPCEtO?=
 =?us-ascii?Q?+Rbh4nLH36ybvqViSlqyxwLEe8DQ/OO884LF69nA84X1lCrENdpTIf7ALAa+?=
 =?us-ascii?Q?cC6Rs1D2jHrg+FLP+olUqt+TJfOGuA73yzrwa1SevMvs5D5p0VhkukMgxL2j?=
 =?us-ascii?Q?s08WxkaXIEDCSP11GkmkbLMKDqa2j+uC69ikwOk141xjNC78N/PIJuKmSA0R?=
 =?us-ascii?Q?hqSZ59WwtaOxGIoy8d0Rp7DlMKrbRtl+UBTq2C2l09anRjye8zQpkoN/ae4i?=
 =?us-ascii?Q?BQ8GPPO8dytFdPO78P/NebGqLkNiwU5lIXsE5uGmucDN4W1iSsqk8UNr9wJt?=
 =?us-ascii?Q?shRVbfaXSfdKLoBjxNEdZUC7NZBbVsdPIr/Fo+PGBwiD/7q//Y2NlFftuNZp?=
 =?us-ascii?Q?uGsfrtCFyqh4hhM60wvMtpkKQC71OG2DVeeCYVBXXtHqKX45MIhCjEmJMn0R?=
 =?us-ascii?Q?81f3Q6ENK0GgDTi1U5rm+LGvT7byEqLNMeqy1MWWRdh8clF59fc/WdKkgGh9?=
 =?us-ascii?Q?o9K2XKQ/oPl2bYwuO3VrzVZHKPW+vLJBwl0gQxK7iN16AwkgzFwgJQemh1SA?=
 =?us-ascii?Q?B69cdsSAPPm4hFKcS9/W/XX8n/I2KoSIjYe7/8mQyeprPV53VdvtFZPE5MMe?=
 =?us-ascii?Q?w+NRLM8gjZ0S5l9jJpoPmfE413uQYJv1qszRpF5s0+ggYvOrjN2DYkVq5Kb/?=
 =?us-ascii?Q?POe7E6HHR5DYEske8mI2cRUNo211plE/mZ1kSbhtzgSrqqcnVMrv4l27hFgJ?=
 =?us-ascii?Q?/AVdSK394NaAcUKaxlsvWba4cLwaPBrJ45rZ/vX/A3P5sgKkYHYDPKmYiWNM?=
 =?us-ascii?Q?xIb8z0H1e3YnJ+kQigAI/6l/QDukBb5XPW2+DWODamOC/THcgacsDVZJWCRa?=
 =?us-ascii?Q?UKY4Q9fQpkZObFdDBiiQ3KMC23HzxcN8XGqe/XbJezrdZTUSD5nQzyly03xG?=
 =?us-ascii?Q?HWCi45hwmsMAL1BiY7GprhbtmlUqxr3vuTDW0ORZunL9XavKIrpHvzyjppzg?=
 =?us-ascii?Q?9qOiz9j/+XvzoFtp0XqA/o3j2IXbFB+QRPEmrLR9LmzXgGbKRkrxBXR9aEUE?=
 =?us-ascii?Q?UrRt44BLuFf+VqZHMUZVw+LwZKQwOYmZrItRvjMcl4lUi9sYIF15VbLmpj31?=
 =?us-ascii?Q?e9aRiJ7LtbBhKKviSHYzfPAqksviKwS5veeY87S3xiG0cjpN1ulnKad58Og4?=
 =?us-ascii?Q?M+xLfX51uyVD34To87Nro79GpKTU//RUv8Xrlf5QdMUiBoumC7lHxPuy0+3G?=
 =?us-ascii?Q?RdaysoH/0URPLcUntaP1OF4uVoP5QYFvYJPyxx3IWBh4gBeTiCxBDjeJKlH9?=
 =?us-ascii?Q?CGX5TA=3D=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b73a280e-4115-4d7c-8d29-08d9b7d2d488
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 09:37:18.8478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: og4GY2p7mCHsgLo5x07tfCOY1hV2jmjtwMGHFKrRAJgSsyJbLKp2Bh+IddPLDhMzcSAKQbAHBxzi/IRfdoHYB+DJ+L/1f6vTS/iQ36JOgMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4942
X-MDID: 1638697040-h3iZsaOp8Dlh
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
v4 -> v5
 - Call ->dellink() only once for duplicated devices.

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

 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         | 82 ++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..68fcde9c0c5e 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -348,6 +348,7 @@ enum {
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
 
+	IFLA_IFINDEX,
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index fd030e02f16d..5165cc699d97 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
+#include <linux/sort.h>
 
 #include <linux/uaccess.h>
 
@@ -1880,6 +1881,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_IFINDEX]		= { .type = NLA_S32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3050,6 +3052,78 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
+static int dev_ifindex_cmp(const void *a, const void *b)
+{
+	struct net_device * const *dev1 = a, * const *dev2 = b;
+
+	return (*dev1)->ifindex - (*dev2)->ifindex;
+}
+
+static int rtnl_ifindex_dellink(struct net *net, struct nlattr *head, int len,
+				struct netlink_ext_ack *extack)
+{
+	int i = 0, num_devices = 0, rem;
+	struct net_device **dev_list;
+	const struct nlattr *nla;
+	LIST_HEAD(list_kill);
+	int ret;
+
+	nla_for_each_attr(nla, head, len, rem) {
+		if (nla_type(nla) == IFLA_IFINDEX)
+			num_devices++;
+	}
+
+	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
+	if (!dev_list)
+		return -ENOMEM;
+
+	nla_for_each_attr(nla, head, len, rem) {
+		const struct rtnl_link_ops *ops;
+		struct net_device *dev;
+		int ifindex;
+
+		if (nla_type(nla) != IFLA_IFINDEX)
+			continue;
+
+		ifindex = nla_get_s32(nla);
+		ret = -ENODEV;
+		dev = __dev_get_by_index(net, ifindex);
+		if (!dev) {
+			NL_SET_ERR_MSG_ATTR(extack, nla, "Unknown ifindex");
+			goto out_free;
+		}
+
+		ret = -EOPNOTSUPP;
+		ops = dev->rtnl_link_ops;
+		if (!ops || !ops->dellink) {
+			NL_SET_ERR_MSG_ATTR(extack, nla, "Device cannot be deleted");
+			goto out_free;
+		}
+
+		dev_list[i++] = dev;
+	}
+
+	/* Sort devices, so we could skip duplicates */
+	sort(dev_list, num_devices, sizeof(*dev_list), dev_ifindex_cmp, NULL);
+
+	for (i = 0; i < num_devices; i++) {
+		struct net_device *dev = dev_list[i];
+
+		if (i != 0 && dev_list[i - 1]->ifindex == dev->ifindex)
+			continue;
+
+		dev->rtnl_link_ops->dellink(dev, &list_kill);
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
@@ -3093,6 +3167,11 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return PTR_ERR(tgt_net);
 	}
 
+	if (tb[IFLA_GROUP] && tb[IFLA_IFINDEX]) {
+		NL_SET_ERR_MSG(extack, "Can't pass both IFLA_GROUP and IFLA_IFINDEX");
+		return -EOPNOTSUPP;
+	}
+
 	err = -EINVAL;
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
@@ -3102,6 +3181,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 				   tb[IFLA_ALT_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
+	else if (tb[IFLA_IFINDEX])
+		err = rtnl_ifindex_dellink(tgt_net, nlmsg_attrdata(nlh, sizeof(*ifm)),
+					   nlmsg_attrlen(nlh, sizeof(*ifm)), extack);
 	else
 		goto out;
 
-- 
2.25.1

