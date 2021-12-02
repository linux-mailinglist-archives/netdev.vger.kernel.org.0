Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915CA46695A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348201AbhLBRsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:48:41 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:38012 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242150AbhLBRsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:48:41 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 731EE80071;
        Thu,  2 Dec 2021 17:45:16 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsmdvCis6CNmMOdjs5dV5HT/inRQmmDlv86ztr+hMSCDIN7AhhgT52sAQqljkqmxdk24fcC4VxN+jCc8C1JTfC3vRpJUDRg7h9DWWqSUZzI6ZVJAPZwowYfia+IKR1KlAmr0jsOvdwUSWDM1nHjobZbEkcWqS3Zszr74CFyxmYWpFXDkqGfjB32+pEDoZPjxXNe0l4ix1KbF8xLpZ87E6sVKTCnNgIhaKhf1F3LBRWlExzjgJgsKE/pVbStf4BRnQ5l6JYkcq9nNjeKBBrfizYnnznfuUouczTLYM8/uLohCGYIH62YS4IRjQ3iL8EuROn/ySHp9eEMu0hWEZEALGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvuv+bO5+0RTeAyT+w/Mwq5vPMpV6JoNLTQwRXs/hxM=;
 b=MQnGGw81myuB+IgcprufEwAjWi2Wc3TRhyycJjAY9ny34Y9e30wC/M5dRFf83kECb73EdvAkxpGHGoOfHoqDGyVRUe70iudgclThgBzpSFB/Yw/06u6Nn18zonhDrNKClE9GVhcqlNyMLeIaEyof1qpkpSNevjMTG+lTxo5uUh9hHJByu2UJIv/o8b1oKUrkLiZV7AiLgD4niwvTAcY8AAWsxyxlkUrwFYL+XNyL7iR54Y+1cfS6V4wd4LVXcmnQd+AkJH0ie4fk0FJ081TyIQLlKS4IG0jFVCb7vNk7rwHQCu2az9/5uqAd95ONg1JXWfDecviwmGED4tMCof7Lgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvuv+bO5+0RTeAyT+w/Mwq5vPMpV6JoNLTQwRXs/hxM=;
 b=WHXURKb4tF9PlBKbQykf+VSzvPlFCvvOuX9lqkLOarJP+Sqjo562olmJRhh2ynW7D1tg/h04W4mtoKW4Jii6MuR0sTBmjClAwFgfFCKiqlAZinu8ucDiAcEJG1mAMnjUlqasFU+YpHgXv3Hch7+UmUrRAhI+VFgTGSTMafKSSw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VE1PR08MB4703.eurprd08.prod.outlook.com (2603:10a6:802:b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 17:45:12 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%5]) with mapi id 15.20.4734.024; Thu, 2 Dec 2021
 17:45:12 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, dsahern@gmail.com
Subject: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Thu,  2 Dec 2021 19:45:02 +0200
Message-Id: <20211202174502.28903-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc.dev.drivenets.net (199.203.244.232) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Thu, 2 Dec 2021 17:45:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9624ce7e-3a07-4d9c-3a03-08d9b5bb7dc4
X-MS-TrafficTypeDiagnostic: VE1PR08MB4703:
X-Microsoft-Antispam-PRVS: <VE1PR08MB4703FEC30B8DDEFC51AFF8EDCC699@VE1PR08MB4703.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+1QZ+VZtqdgjkIJ0gbIlrvyNWgTchkasBnqEnxQMJcH5InVDVM2+j0TDhPJPdPHC9k4EtbiLbTn+FSk9VOU6Ga3gGPmiUVs+Rd0dPK+lyAfyFG69U2gwRDjrnbN54EggvQMWJmoxTOSspZgVbocWsyF1wfXcBdP7bUVas71BSvS6mCHVTMtWxaEWCkjg+cpMLCL6asJgIeHGiProxK8dPIZgFVftVUnF48tlcd0sRmIugwT2hSvhn+t3BIAqJ0CmSw6TGXaMLtgy3CCZrJXoNAUgOPSMJSRMT7LaYW4qJyEHxfnJ8LC9/frw+/L1u1n0xaQaDB5c2fH8pQNqviUaVPJIPrkMMc76UnJCYotOCwYy22qUFnsppkvahtEIGHFL47v0+4KSfN1tjOQZwreR13A9rRmOxoUJcE/3eUqzh3kaaFS2hdV6R8qfEYnRpi0kji8dpeIuyUVlS6WzBifVh6lN2l96dx5LJALC+UNbQae2Dy9hXsxkOTh0+xOuXa6lVzCwQTclmovU+cZVrB1uPTYPkDCAhX5OiELtwU3xyvTFLaCCfS1rP8sPlZtCa8WooveO/TLLMmnxcgfhecVHm+3jtj5QOMN6T/PCneWxqFlP0/CtwHvZ/iikkQjtuD/IUS8N46MMHD1OBrp+bYh82sVgjjPG94zum3OkA2U5EiGdQLfaA6q7snhryTTmOMWTRtn728yhjXeJF5D4upbCqqk3uVj4CbvNAiEnUY6Z9g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2616005)(2906002)(6916009)(6506007)(316002)(6666004)(186003)(38100700002)(38350700002)(6486002)(956004)(508600001)(5660300002)(83380400001)(66946007)(26005)(8936002)(4326008)(6512007)(66556008)(66574015)(66476007)(52116002)(86362001)(1076003)(8676002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gNN3baLuxMOE5mp0Lo+Grk1uN82DHNT29EGSLp/ugLZl7zM3+VtJf38Wi3hP?=
 =?us-ascii?Q?Pa3ZHc8K3dWj7VSsUvSJlYlv4LVfTyTRNKwZfs4BC06B0X2nc/kvvSPT8Xxm?=
 =?us-ascii?Q?Y5bW/3n3/IQZxbLejOln3ZAzKyRKbaq3tt4vdj8c9nnhpKcul8taKAd9/FuJ?=
 =?us-ascii?Q?K2/q15l0jS5/84yxyIW2c/nClu19XGqULpf4WUI9Zywc5biHBObLREJOFBb/?=
 =?us-ascii?Q?ZMAvtATtPlHTRDQOE03yRB3QnYJU6cDs7FQQlyAysEd3plzznNn/WbVu+yYs?=
 =?us-ascii?Q?Rb01yVie9hCgWXvugwYHLzIZQ6uAeDUB2Fk4FID7Qdo1rmxVFE9Ufmf9qflf?=
 =?us-ascii?Q?cXjmRhNmuhUVlq1mszOI82Xi/zWreENkUvm24N4tRBE4CtM5PZytglfSFal+?=
 =?us-ascii?Q?tQP2Zh5sV5J9WuVgKR5ceBI5RZyMakbFZ7xjH1ysuwHcGHZMLojRYZFTVxvv?=
 =?us-ascii?Q?obQ0uuFtFX29nYiA+IUmvO3QrAA7wwNJeuoQQQcNerCSuvlgzDUpjy3gcSOM?=
 =?us-ascii?Q?BaoF0vpBdK2BfjacqL5+od+spYwn1F2XzTyz0DiMJfrlp8fpeK+AntCIcct8?=
 =?us-ascii?Q?c3UOO+hGUIZU6UWTj/hOVgZDiDTGe0ZB5b2nHqFSkd+KmURN2ltN14GN/XOa?=
 =?us-ascii?Q?OPCedduAo5ZsiVJGjoxml/ObjECul3LoOztg7VwXAh8hIuLRAisIwx/7Thvv?=
 =?us-ascii?Q?Euth/bAzGqg5zmxFM65qDZUBkA3qlsDhroGocsemX7jw/VjxRi5a1pMKEzGJ?=
 =?us-ascii?Q?Zofhi+Tx73P5ZkGB4JCo2OCfzEEV6skNBgKfU4Lq2eBX9ioKjvCBb3HCLv3/?=
 =?us-ascii?Q?ODk6PA4YnSCW1U3fA3NiL761v4IvTpIBsFCAj8f6cCgMZ/02qVewqIxjPAg/?=
 =?us-ascii?Q?L5tw+1eds65d2oVVYT8L5In0WRXPLlIWmGQCep7xlC8AxpnPqNCQdosQQjKf?=
 =?us-ascii?Q?fMSICtA34ZU+1q3rQNbWIVtOAF93DL+GE54NkcbJn/sndQ9D5qa0HRpabn/D?=
 =?us-ascii?Q?xGsnunY2Y5q9MOI21F+gir7MhOlbUDitsmRXJ2MFNShBMmbSjtyC0IlrKLpw?=
 =?us-ascii?Q?8oilZOopDRR4G7NSVNa4UMIJSewknJPTvcKZcL4HaVOwUDwb4QeV36KRIF/T?=
 =?us-ascii?Q?wj5zGzXN3akhZA6amkSNGQkyPT8wMIWMbe4eEVJrtqbOW/fj8MKJ0kvH+ng7?=
 =?us-ascii?Q?XHPm3HocM23PIGCcSKHsWodzZK3iynCzD2PIkU7T5usfOCztA+g+CaqBEeF/?=
 =?us-ascii?Q?EKZcn9dTqJWS2KWRIpDzUyvCNjcs4PiHT1V5/XFvM6UitAi9Ki3v4GzprPg1?=
 =?us-ascii?Q?2GpwwtxjN+u/T46gITXKOnf9hs706aqLn/D6JSniGV3+a+MGZPrc6SeBf1Ms?=
 =?us-ascii?Q?OWmHM1KTI3xo9mS6xPm0XiacAVuFCSRGh+wo3vd4iAJm6dBSe8mrP9QKe0kd?=
 =?us-ascii?Q?/isBBvvYkIoA2+wKjqiH7nYqZtHch0uqoCgbcfr3+jx5kxrcHbqFG0xq1AEN?=
 =?us-ascii?Q?nGEsVgPkMHNuTYfjiQi3ZhykTKS8SWt7U3ZWN0pbC2Rbz5evtmhAUbxZgAhm?=
 =?us-ascii?Q?AHUCFMxS8pGtKHelMSYXeJWSCC3wo+VVv5rg84ZSl+Q+ZNdr4AMts7jDC+lD?=
 =?us-ascii?Q?ecTTLOfhoh3RN1xs2+n5wd6KiA2goWlAM09T7N/+P39CHlks1FZ2Pc2afj+s?=
 =?us-ascii?Q?SvTJ56k829lo/rUIm5MdXdXjpb4=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9624ce7e-3a07-4d9c-3a03-08d9b5bb7dc4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 17:45:12.4528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQEdRx/MI+4guBBFuFi2NHNdGem/G5D0n47mf5CrivGU4/M1v5zlVSycJ7y7IgKOFMrdpqZk5SvjoCoOiWXx7sWCgxk+LxQMqHTsmL8K6tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB4703
X-MDID: 1638467117-BEYMGs4OeqqX
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
 net/core/rtnetlink.c         | 68 ++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

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
index fd030e02f16d..9d804866fe72 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_IFINDEX]		= { .type = NLA_S32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3050,6 +3051,65 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
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
+	for (i = 0; i < num_devices; i++) {
+		struct net_device *dev = dev_list[i];
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
@@ -3093,6 +3153,11 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -3102,6 +3167,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
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

