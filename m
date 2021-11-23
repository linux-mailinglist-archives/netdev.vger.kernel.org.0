Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0581D45A30D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhKWMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:49:01 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:37488 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233097AbhKWMtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:49:00 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 07:48:59 EST
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 964DB2C0AE
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 12:39:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01lp2057.outbound.protection.outlook.com [104.47.1.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F29747C0081;
        Tue, 23 Nov 2021 12:39:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0hiPeAn6/ZRZDh1Isa0/UHCwE0gZzeqD3smcfS38LB8dzm9N91VnOXD4hAfetziqf87KCpWSXkZWNTrwb8ih/gbR2vHJiMbNUBMST1bWku3w3l3OO5MRteYt4eoYR26cK1CXHnc8gL5H8hkPMv4/+VaDE3XEEUgG9PpVHdMPUvYZuTpbI58w8wF9CKyq6PuEmG3hHxxgmmrhlz8n0JKj8miRQzvjuiHaBvFPpv2It2Q4kLqW5BxHMi8hAI1AqMaBqZZUCXSpFGXUvhykiH01kYdlnfvM2E1TjodwPnL/DD2d7oN58qIXeZ33nlkoqLtMnxLqGggfnJEQ06NbKwAQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pe5pxH9woBv9CWjNJjMMZnUYLe9ubpVhvkxWnFPt3iA=;
 b=glJH9JXgDnwEGH9JIX1myBJ2Nt1nzjd/P24v/P0Db3W5te72MUk/kVWSEfkoRBhlRDBn5KhvpHM5q7CfkqNB4ssiD3ZHSl1fkLfuiaOVgJoPdEhOH7DBrmDqPeaMTznAX/DnZzIaG3LHw30oTlbaTlNBs8l8RHNOJuacEvNdeoDiqOcPbU1YIgSakCDV6sMz/GLsMK7y5VaQ5OXxLYMsUFc6pLlVqlnsLL1vV/Owc5+bmum9exsWng/2oSmuf0O5jHDTmQMWtk83vLM2cCZBD3xuKUpGHnZbvvDoo0qsGI6EOcJBDoPs+UM5Y7o9bOoby0dAOBNdAxNWY88n9N8j5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pe5pxH9woBv9CWjNJjMMZnUYLe9ubpVhvkxWnFPt3iA=;
 b=QUZfXHYvyW6+FhnEDAP5TcHw7F0zVquXI28Fm7G6Wu8XFotC+TlZ/TrfhzwreiT70ZvMEV4D01OFXeuTDGTKxX97lh8E06gkMdDzwEsQGKpeVioW5NpG7OxFDn4VfJotnJmzyXrc944lIggXrgmN2X3ZzUwuc97quNqFc4A+kYM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0802MB2462.eurprd08.prod.outlook.com (2603:10a6:800:ad::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 12:39:16 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::7484:9ec:6c6e:752d%6]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 12:39:16 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com
Subject: [PATCH net-next] rtnetlink: Support fine-grained netdevice bulk deletion
Date:   Tue, 23 Nov 2021 14:39:00 +0200
Message-Id: <20211123123900.27425-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::15) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc.dev.drivenets.net (199.203.244.232) by AM8P190CA0010.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 12:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 852fc56c-cbce-4bc3-2a14-08d9ae7e4303
X-MS-TrafficTypeDiagnostic: VI1PR0802MB2462:
X-Microsoft-Antispam-PRVS: <VI1PR0802MB246278AE37DE366216B6CBBACC609@VI1PR0802MB2462.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kS0VOJ33WR0VDiZ0OOyPxjomaIEB187cQcNIV9ZyWimzTTuE655L/dUL1ty2ByWr+/XZXuo3Cu7hIISBnEp3ACo+o8CJZnv/OBDkYKT6rxZv/6pM4wUkrhLT/sRvcG7uDE20x/lMkb0SryGASGYt5dW/NCm7jT8e/kwdVcUn3pFZwj9Gm8EeZcjduXb5fQx+M8l1jmS5KZWwkTzNMJeVaKhb/RiX95AhsnMLI+UgrHGFBRUfTtvTCNW1V3L0NzIgl3dSO6vDCnN2jh7Lsc9OpDaEWqZhUHjBKyIBDNHYAtarLMaO6j6EfYw/lpOk4ty64JcupT3XFepln6GL9yqfOBo/JBJQ0M9GgT2N7x20/dl1VMG2t0GaGgumsDXYjzSwjAVTI5puxFgZ7Ocux5FVZkNG9ncCR6Aej/I9e5SgD5EbmVHComkTk6R+n1MYjnfdyJg0C8YREBMMqqyeT1WpAsAY1BDhGE/hdZK2bXQUTfEhIZXJkyAvl+dI26HsbXbM8aXJ1BIyrJrCfFAb2Uufu6PJZqDGp1q1CMB9H0PHDi7C4DuftF/sjA3kZs/ykCnM6LB6UfKue4XSRBQwFJIRQoehXsTTdST/da1XPr8IOYKkPxTIjMXFWvwE2DnRCuOhKw9RYx1Wn2o8AObT1a+W1qp3HSitNpuTq/rTavCgpLl+LQHO0afqBpCPsKForFOuwA62ASa5Os++SX+U7FvJV1t3/JNnRDfi8704KK12cqA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(52116002)(6506007)(83380400001)(26005)(316002)(956004)(38100700002)(86362001)(8676002)(38350700002)(2616005)(6512007)(6486002)(1076003)(6916009)(5660300002)(508600001)(8936002)(4326008)(66556008)(36756003)(6666004)(66476007)(66946007)(2906002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sV741V3LZhZKBg0IVw75TKwMGDZuEPoXkd0xpUp5nnWcV0uL/vSlINEhZGiI?=
 =?us-ascii?Q?P6IeilMCt0Kq4JAgdQRDeQtC5oCyR/IXsjYd2hRGw+OsNDl/L2SJ6tImI4bR?=
 =?us-ascii?Q?VUzCteMQhjAnuqlgQwg+ln9w1GLArxrTQCtvrJpb8ft5gKAWE5oEg+eFeWGK?=
 =?us-ascii?Q?wZFRatRrIDjXKOZKS8eRUaS6J8jfMCznGHSfD+8d5HbPPnpCVHTqf/as3hlV?=
 =?us-ascii?Q?TQ49cM7cLiuQxL4JOeIsqYBz2cb0ONpgBTRJfGD8byWqBpu8XWCd53hbU3lg?=
 =?us-ascii?Q?fdht/FxqZ6oQ/Ozav78k7iYbhVKvYGI/wjyab/2H1M5DYnatzC1lx3dWLgOe?=
 =?us-ascii?Q?1g/4F1HfENE6XTf+50UQTJjB9vbD5pEx+JNCkDo9Pxuyisnc9xk/Kxkn+CcO?=
 =?us-ascii?Q?k0vqYO0rVyAz8hZ930x2O9I8mNk/MvK7IlQ67orUihsVGmuY8hqKdbnuNiYI?=
 =?us-ascii?Q?piwD+s3xjI04cUgVbafmB0zRaeuouL/cxDJynyvLbFHzWx3GF8aGmfJpj0cV?=
 =?us-ascii?Q?uFJGSZny3PEPRGWu2Hgl2fEyacAbRmJ/vxHpNBBO1w1i9N+mYVG3fNMtj0z6?=
 =?us-ascii?Q?ovDQN+51bZ2kzAF0m+80U0cZc7i/777791sibXAfSvNvc7iVniGxHHlCqMnq?=
 =?us-ascii?Q?S+HCFWf0yUFr9AALwXp6/NoBPvmog98yuQbroToaosJwSlXyxYA134kysNxS?=
 =?us-ascii?Q?GjsNZMzzyjksXPuQtnUX3j04Pgc8D8PRK8r6UqJe4Zlbd5PEhWAZJq7uGIUk?=
 =?us-ascii?Q?vxa8Dxa2umDEAXEEWx9A6CzLMsldlPTRH/H/D7jN5odUi6kQWEV+IKD75MOI?=
 =?us-ascii?Q?cCwBHzUdem7FgxIQgqeAJeQy+e0wzpRWm/dNgL4d2PmNJ4YKgxbVGGbkdYGh?=
 =?us-ascii?Q?ieBKAEzgN+Z8mCqP+hc17aaBDNMQIBWYCGSelqvhTr5i4sh0+vL618RhQQkB?=
 =?us-ascii?Q?wxFFCVjKHJgoRZGTs+Z/duNuQZO5z8DG+Jnp44kWDJpGeeWIMDWFKk7QesjU?=
 =?us-ascii?Q?Isq8Xef+Vtk5Jfa2NjlLAZSLaVdhZkinFCmBJ3A8js+NckzS7RcpofAfs4fQ?=
 =?us-ascii?Q?VSEBKQnduwfqX3DucfTzlACcnW9BLxHyr1oHjZLc5wHS2Q3TA0bAyTmt0Mn1?=
 =?us-ascii?Q?bFIGZATlVz16Vm80ZFt2Emqs8tWXjirsn0nJ/2hccdZUdvfFpmULa9CU9VlO?=
 =?us-ascii?Q?EBcL0ZYLMc3uY60EQ5RkbwiMazo2hQ0BQW7af0H8KNd83NlYltePvp6qdA9p?=
 =?us-ascii?Q?nFn25646Ows1EzCHpGxmhGRtZZh4KtI708Q4SWHDb4D7hPbPV9orVlnqXNzW?=
 =?us-ascii?Q?As7doh419+LBk2yssGBRX4CkdOxUBoqbZBO1sQnSPPogBsXQPjtiZpHfA9rT?=
 =?us-ascii?Q?lW4blf/gaV9vjBjQohLjN1MxQuh7rbb9R3PVXRDZFdi7mcLex4ASj63Csri4?=
 =?us-ascii?Q?ds0aLsWTGwqSrsfG3wARX2ku9W4raFhqt8IJxSiGkZdrsXqI35LSGmANEO4w?=
 =?us-ascii?Q?jZM2Gj0fsiorBa8F6XPNh/Kqo+vsb8FTQV53+IS4WJEYBw0bDhwrKsQVtdYy?=
 =?us-ascii?Q?SABVpsvzxzc/UeafkC3gAit/rOBvoITBOz4f+E7DUWzXC4lQPXA09VaTUpCV?=
 =?us-ascii?Q?7zJ1TKbZyXA7XbW+uQVev0g8dcKvvGi5XueTyeQ/KiGh9o4G9vTWPt8uBX6F?=
 =?us-ascii?Q?Y37N8h8FmjD2YPln1TGM1Yktk+k=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852fc56c-cbce-4bc3-2a14-08d9ae7e4303
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 12:39:16.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1a68BHnmCNfPsv/uJuh25tVsrP4sHn4fInNfurHM+FZpryKB8oNLY5FQerP+JcXb/T2qioGfJ5+CBQJ+5kGPmw9FHlJ07RJnwLkVubI0iM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2462
X-MDID: 1637671159-Y7OXFpeZNr5c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there are 2 means of deleting a netdevice using Netlink:
1. Deleting a single netdevice (either by ifindex using
ifinfomsg::ifi_index, or by name using IFLA_IFNAME)
2. Delete all netdevice that belong to a group (using IFLA_GROUP)

After all netdevice are handled, netdev_run_todo() is called, which
calls rcu_barrier() to finish any outstanding RCU callbacks that were
registered during the deletion of the netdevice, then wait until the
refcount of all the devices is 0 and perform final cleanups.

However, calling rcu_barrier() is a very costly operation, which takes
in the order of ~10ms.

When deleting a large number of netdevice one-by-one, rcu_barrier()
will be called for each netdevice being deleted, causing the whole
operation taking a long time.

Following results are from benchmarking deleting 10K loopback devices,
all of which are UP and with only IPv6 LLA being configured:

1. Deleting one-by-one using 1 thread : 243 seconds
2. Deleting one-by-one using 10 thread: 70 seconds
3. Deleting one-by-one using 50 thread: 54 seconds
4. Deleting all using "group deletion": 30 seconds

Note that even though the deletion logic takes place under the rtnl
lock, since the call to rcu_barrier() is outside the lock we gain
improvements.

Since "group deletion" calls rcu_barrier() only once, it is indeed the
fastest.
However, "group deletion" is too crude as means of deleting large number
of devices

This patch adds support for passing an arbitrary list of ifindex of
netdevices to delete. This gives a more fine-grained control over
which devices to delete, while still resulting in only one rcu_barrier()
being called.
Indeed, the timings of using this new API to delete 10K netdevices is
the same as using the existing "group" deletion.

The size constraints on the list means the API can delete at most 16382
netdevices in a single request.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
 include/uapi/linux/if_link.h |  1 +
 net/core/rtnetlink.c         | 46 ++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

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
index fd030e02f16d..150587b4b1a4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_IFINDEX_LIST] 	= { .type = NLA_BINARY, .len = 65535 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3050,6 +3051,49 @@ static int rtnl_group_dellink(const struct net *net, int group)
 	return 0;
 }
 
+static int rtnl_list_dellink(struct net *net, void *dev_list, int size)
+{
+	int i;
+	struct net_device *dev, *aux;
+	LIST_HEAD(list_kill);
+	bool found = false;
+
+	if (size < 0 || size % sizeof(int))
+		return -EINVAL;
+
+	for_each_netdev(net, dev) {
+		for (i = 0; i < size/sizeof(int); ++i) {
+			if (dev->ifindex == ((int*)dev_list)[i]) {
+				const struct rtnl_link_ops *ops;
+
+				found = true;
+				ops = dev->rtnl_link_ops;
+				if (!ops || !ops->dellink)
+					return -EOPNOTSUPP;
+				break;
+			}
+		}
+	}
+
+	if (!found)
+		return -ENODEV;
+
+	for_each_netdev_safe(net, dev, aux) {
+		for (i = 0; i < size/sizeof(int); ++i) {
+			if (dev->ifindex == ((int*)dev_list)[i]) {
+				const struct rtnl_link_ops *ops;
+
+				ops = dev->rtnl_link_ops;
+				ops->dellink(dev, &list_kill);
+				break;
+			}
+		}
+	}
+	unregister_netdevice_many(&list_kill);
+
+	return 0;
+}
+
 int rtnl_delete_link(struct net_device *dev)
 {
 	const struct rtnl_link_ops *ops;
@@ -3102,6 +3146,8 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 				   tb[IFLA_ALT_IFNAME], NULL);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
+	else if (tb[IFLA_IFINDEX_LIST])
+		err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]), nla_len(tb[IFLA_IFINDEX_LIST]));
 	else
 		goto out;
 
-- 
2.25.1

