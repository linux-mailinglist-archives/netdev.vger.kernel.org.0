Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3FD460EB4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhK2GX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:23:28 -0500
Received: from mail-mw2nam08on2061.outbound.protection.outlook.com ([40.107.101.61]:34272
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232366AbhK2GVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 01:21:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyfLdG6UnopFFOYkbjPHgFOr3/taGVIUqNcULyJ/Rf1WGkQWTmy5dAxuNKynDSEzIE1mbDbwp1neMoMg+oQPENc207p+93V8bDOfgnfMZliDvYPhGmA7s/BYfetyYUzdiqJRx8N6UlAI3IjTjeL8/6Uhf97TygAdsf3OZXQghnhla92olC0e3tr+aMPNm9DeLYjUm1hW174DHarAglLiz3niCBdaAYbthF0w5hxoQkxxdk69ETKVSBsPKifVZwx28MIptAkEuQ9n1dk9p+M0U4O2mrimF3tPhz5Ucin4BgCya2vrxRyluiHfBJlWVkOVMGMGhHwxuFdkRvUUB/mDnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7w5ByUaggz00hWUVDNfiPyyOEKUxC/BWXmXI1/D5n8=;
 b=mryZ3Kdq9+aC3AEMPhCLRJhDxuM4rlVTX4h2VvCNc0ttHQ7ls7WgAKXOgPD1Vpll/BK7t/n9NYXEHVaox6+Fjw23gvg73pRh3evwHcKYUUY9xSieOhAwVnLZ18b7dQ5ObAFjFi9+rd571z4Hn02F+ypGQhKp7UG++6AwG2EKV6vo7px6FVYwlhkqD+KbEMkoUYO9oIy0zIidkizZsm7J6iD0tiLETSnip/yoqn55PziZ89tdChqWsINf1QSnjWYaCy93rVUQD1JnfHOz9f4hKWYpUXhRIFZjDKdMHhi8q6P2hcR/oCdZNOKWIvuoemFmHDNpFmYWIfRvyN10tfDN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7w5ByUaggz00hWUVDNfiPyyOEKUxC/BWXmXI1/D5n8=;
 b=IvX8/mcL8og4o8TcfY4K+leyKWdqNtrWF4p//BHU5l8y1BfPscGWmToZmh5YxOCt+Aqx0ziQOe9PoyLdWshdBM+0CU/otX6x59InHkNTzKb+qEb/tTT/YLLKY74nf6eyD2gkYJT+TE1niRnqnHeObfHVFw8WwkDD3NaXOYhtXCoO5Kj4MwrAndLub98mqRYsdLU2Tucj2tkevpLnllsN0DRQoymZ+MJAjPC3Ehw1AGR6ARN/nog1zJKFlw7qyzIj2OZwgFwnTJoTtH2vhu5jVz5EXHRcIY2/xLIXVePH6NCpvK63OfTcMDIJkJt4R5gngOXwpv1fzRS+HmGOZie3Ng==
Received: from DS7PR03CA0032.namprd03.prod.outlook.com (2603:10b6:5:3b5::7) by
 DM4PR12MB5101.namprd12.prod.outlook.com (2603:10b6:5:390::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.24; Mon, 29 Nov 2021 06:18:07 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::6) by DS7PR03CA0032.outlook.office365.com
 (2603:10b6:5:3b5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Mon, 29 Nov 2021 06:18:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 06:18:07 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 06:18:06 +0000
Received: from d3.nvidia.com (172.20.187.5) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 29
 Nov 2021 06:18:05 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Kangmin Park <l4stpr0gr4m@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "Robert Shearman" <rshearma@brocade.com>, <netdev@vger.kernel.org>
Subject: [PATCH net 1/2] net: mpls: Fix notifications when deleting a device
Date:   Mon, 29 Nov 2021 15:15:05 +0900
Message-ID: <20211129061506.221430-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211129061506.221430-1-bpoirier@nvidia.com>
References: <20211129061506.221430-1-bpoirier@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae052cd5-ba45-46e9-9427-08d9b3000284
X-MS-TrafficTypeDiagnostic: DM4PR12MB5101:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5101DC5D59F2DBB43E033299B0669@DM4PR12MB5101.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wp3tSxtDrvAA2WZhF1vuEOveWnDpCNBU4DlVHDmSH9RBZjepO179r8PqbKDk49TR4wYVOce20YU60qqiZ+XRDHwuGgC6LFap7vMS0LTdj/yGidhtAhYCrqqA4/2cHTganT0UAoyEkJgUvViXBKTwBZ3B/knaLFPkWufN+XETH50Sn175r2HF87yOSjSAvS0VbEzRQcf21R7oF9syck1pVvTM6hLtDxAm21otxWByG14sF5RR/JUqQDIUIIwajUJH2s11+1vt9GUMh+lOkM/F9YUbB6Z2kpPfJjF+fZz+euJRV3s7rQLYjzeX9Ib3sPTox5tYU5ieObOAOmZRlj1h5ecCBfFwUso+jecA3ZE7A0I0fJ4UDQ5HbCN477XhCebrCxpq1k4hKvnG4nj5n9/UsLSfnCpWCi0gqvJqhthee8hlft+n45UOtMBiQchp6RmbLVwcBowBDsXhCLp4zsobXua0YyK+VFNKnP2jg6bpImK4dDi6zPImR+UQMjGtET7BxWgPiigqwDtAgggSmL+Lcl2cdgXMCgzf4TfU1NWNGW1oY+tcwgzA/D5+zAMEuby3YqplA8/JXN0m4dXa9lh7uBwMfmJA7JvysD+uC61F4cMF3i3Q/OYg2PWQG2iGyL2EnteNr7VhITHRe0nPfE3CMtUwsAfX19o2ZIDslRk2Dr7m1jgZJu6wTv+Sx3fNfh2A5murjq0TnKxU1NRETH1cwg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(26005)(186003)(54906003)(110136005)(70206006)(7636003)(5660300002)(15650500001)(70586007)(7696005)(508600001)(316002)(4326008)(336012)(8676002)(86362001)(82310400004)(8936002)(36860700001)(2906002)(1076003)(36756003)(83380400001)(356005)(2616005)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:18:07.2111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae052cd5-ba45-46e9-9427-08d9b3000284
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are various problems related to netlink notifications for mpls route
changes in response to interfaces being deleted:
* delete interface of only nexthop
	DELROUTE notification is missing RTA_OIF attribute
* delete interface of non-last nexthop
	NEWROUTE notification is missing entirely
* delete interface of last nexthop
	DELROUTE notification is missing nexthop

All of these problems stem from the fact that existing routes are modified
in-place before sending a notification. Restructure mpls_ifdown() to avoid
changing the route in the DELROUTE cases and to create a copy in the
NEWROUTE case.

Fixes: f8efb73c97e2 ("mpls: multipath route support")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/mpls/af_mpls.c | 68 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index ffeb2df8be7a..6e587feb705c 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1491,22 +1491,52 @@ static void mpls_dev_destroy_rcu(struct rcu_head *head)
 	kfree(mdev);
 }
 
-static void mpls_ifdown(struct net_device *dev, int event)
+static int mpls_ifdown(struct net_device *dev, int event)
 {
 	struct mpls_route __rcu **platform_label;
 	struct net *net = dev_net(dev);
-	u8 alive, deleted;
 	unsigned index;
 
 	platform_label = rtnl_dereference(net->mpls.platform_label);
 	for (index = 0; index < net->mpls.platform_labels; index++) {
 		struct mpls_route *rt = rtnl_dereference(platform_label[index]);
+		bool nh_del = false;
+		u8 alive = 0;
 
 		if (!rt)
 			continue;
 
-		alive = 0;
-		deleted = 0;
+		if (event == NETDEV_UNREGISTER) {
+			u8 deleted = 0;
+
+			for_nexthops(rt) {
+				struct net_device *nh_dev =
+					rtnl_dereference(nh->nh_dev);
+
+				if (!nh_dev || nh_dev == dev)
+					deleted++;
+				if (nh_dev == dev)
+					nh_del = true;
+			} endfor_nexthops(rt);
+
+			/* if there are no more nexthops, delete the route */
+			if (deleted == rt->rt_nhn) {
+				mpls_route_update(net, index, NULL, NULL);
+				continue;
+			}
+
+			if (nh_del) {
+				size_t size = sizeof(*rt) + rt->rt_nhn *
+					rt->rt_nh_size;
+				struct mpls_route *orig = rt;
+
+				rt = kmalloc(size, GFP_KERNEL);
+				if (!rt)
+					return -ENOMEM;
+				memcpy(rt, orig, size);
+			}
+		}
+
 		change_nexthops(rt) {
 			unsigned int nh_flags = nh->nh_flags;
 
@@ -1530,16 +1560,15 @@ static void mpls_ifdown(struct net_device *dev, int event)
 next:
 			if (!(nh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)))
 				alive++;
-			if (!rtnl_dereference(nh->nh_dev))
-				deleted++;
 		} endfor_nexthops(rt);
 
 		WRITE_ONCE(rt->rt_nhn_alive, alive);
 
-		/* if there are no more nexthops, delete the route */
-		if (event == NETDEV_UNREGISTER && deleted == rt->rt_nhn)
-			mpls_route_update(net, index, NULL, NULL);
+		if (nh_del)
+			mpls_route_update(net, index, rt, NULL);
 	}
+
+	return 0;
 }
 
 static void mpls_ifup(struct net_device *dev, unsigned int flags)
@@ -1597,8 +1626,12 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		return NOTIFY_OK;
 
 	switch (event) {
+		int err;
+
 	case NETDEV_DOWN:
-		mpls_ifdown(dev, event);
+		err = mpls_ifdown(dev, event);
+		if (err)
+			return notifier_from_errno(err);
 		break;
 	case NETDEV_UP:
 		flags = dev_get_flags(dev);
@@ -1609,13 +1642,18 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		break;
 	case NETDEV_CHANGE:
 		flags = dev_get_flags(dev);
-		if (flags & (IFF_RUNNING | IFF_LOWER_UP))
+		if (flags & (IFF_RUNNING | IFF_LOWER_UP)) {
 			mpls_ifup(dev, RTNH_F_DEAD | RTNH_F_LINKDOWN);
-		else
-			mpls_ifdown(dev, event);
+		} else {
+			err = mpls_ifdown(dev, event);
+			if (err)
+				return notifier_from_errno(err);
+		}
 		break;
 	case NETDEV_UNREGISTER:
-		mpls_ifdown(dev, event);
+		err = mpls_ifdown(dev, event);
+		if (err)
+			return notifier_from_errno(err);
 		mdev = mpls_dev_get(dev);
 		if (mdev) {
 			mpls_dev_sysctl_unregister(dev, mdev);
@@ -1626,8 +1664,6 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 	case NETDEV_CHANGENAME:
 		mdev = mpls_dev_get(dev);
 		if (mdev) {
-			int err;
-
 			mpls_dev_sysctl_unregister(dev, mdev);
 			err = mpls_dev_sysctl_register(dev, mdev);
 			if (err)
-- 
2.33.1

