Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207CB6423C0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiLEHnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiLEHnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:35 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E580D140EE
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayeQiOS9Z3HG2Ta7WgdNamfVnGMiRkxVEljlbE3U9qZAgGuUS5mavsan1pTagRZZmNsdYqRHGRcTzybgPTLtQXoqytW1DSEg2s7zyP90hrH38/rjR/hfzDFC3ik58kjT/7UvYcYvHaOTi7AF7KqeoEcHu9s6Y3KHGi2cTjRjY6aZDJInrRYW94McxykPkMyMJsJusQefY2AklsWWfxFT3VrZDxhmtWlHqlzS+/ydItkzr/WaQpIydxWPXzR3WSYQNhmDMDt/soRsnNbrOqWvZy1LURbilRx43lS6C99ZA1F6DIZMATWT8jT49PoQ4d45Vih+VQQp+lc8LNGhgRBlvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Yja9VsLnagC72ep9LTUOr8dSAjGOieYh86W4wK44A4=;
 b=jVIIVk8Q8wgQrd6Nr2ZWS550bXaXitK7XKtOjlfxN1SyD+mMv+wbLYdsmSD6NvKTvQeRieYgHHGI1cv5zYDd/brEZ2QPpaVQPgIHsB23MgG35miyWdUb3GFV8M9bBow0LtJmaGStvU5KfV7q7OJBkE48n4+KDGRZ5avbY4L8rf1+Qx9MSxEmpZNNrq+c5HdUEqBvaCADXL5MGkjbDfAZP+SpUh6pDMuv5DFUwyh4BhlUOruMgedFOuTMtRDneb3ogBhEHxSm205WFwqjmEM/ki4rBweid4hALY9aiXOQ1z9X/mVAPYA5Slg15gOYr2M4m7Tt/7afPO8K1Z2Q/DVdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Yja9VsLnagC72ep9LTUOr8dSAjGOieYh86W4wK44A4=;
 b=BRkcklSBIIT0Agbf25y1wUEBF8/6R2Hrurk3TXulCkxyEwXMu3GELkyeAr2PhYSkZBEDY4oMrEeJXKoGiip7yV/17DyJJ6XlUAMy/kZXUXhc0ZlSftuK+wNbz37jLbhx2qqL3JcP6ZNzKIkJ4TWrKrMWWJQx+vN7l1dydORRkdba+5qP4W5ldh4ARZp18LRaMYI89Ed5WoVcGsJqyj3lrFK3ANna274XE7db4bvfjlqvxPE5P7KT0xNNB8StQNM9q8yT8CqO3zNNqlEQCsBQ3JMSVliLhScaENq1Sj2c34kH55dW9aFwSYOpSmZnLB8exT+IZsArRz5suwaEth9a1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SJ1PR12MB6265.namprd12.prod.outlook.com (2603:10b6:a03:458::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 07:43:28 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] bridge: mcast: Remove redundant checks
Date:   Mon,  5 Dec 2022 09:42:45 +0200
Message-Id: <20221205074251.4049275-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0006.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::15) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|SJ1PR12MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: ed56ebb3-2092-4113-952c-08dad69465f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9C4SdzzC25M6aFtPitc98xzTf8mEZ6U2Xc/BXDVDeSuCz3AX8+9gax6yDlMTZ7XFlHqAxg/jo6pc0KKKhrh4p0UQWSmt6VYS9BlypY+oF6xdSxPI7I+d7ZO4cFmYS3eIj/KT3hp/Fnk6cAD0oyVt/6QCO+qXrpzPWlzHzTNfUaUIK6vzEdFKAw/oWZlBCj17Ipk+ln7VQSL2TUWkYmQ720LfiwZ5jWKYYKE3p46qV93QnBJPKEDdJk4wT1ki4ycmLnhV9FN24K1xZBzmKAZ9830/HSIkjyND9CtVerU1IOsyhzzl8/6IHfOZb0ivWq2H3rAnfX55P0cG1gzC2vZdLJA3eSBKsdutDOay89iUbT5xcPqK23qg5ENpE3f+uV0prn8kwilVbofMyzg50/FUgHHTMXvZorrgZYdzjuLoywSl8Itq6xhmwUY0CV3iJYn4eN2eZQGAK4hJGX7zKH1P7J7VlJjLjjpt0leHjgF4FAcM7tNWpqORtDPSTqSIC+CUjivXIWCpde331lmowad8idYTTUdkTKG+1A2T9uTMKkVFiJHPtAmbChMXlmqyjE/AqKbbuWLni8HVfuXth/0B7PQpaOf1Ah4OeQPEh3aD62AKD6xv6KfoxJiuFWaBkaUVBMr04dN3NFs4RtdyQh0LVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(2616005)(1076003)(86362001)(2906002)(6506007)(5660300002)(186003)(6666004)(107886003)(316002)(6486002)(38100700002)(36756003)(8936002)(26005)(478600001)(6512007)(41300700001)(83380400001)(8676002)(4326008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzTRZTR+nzDra2CWa5P3J3BNOFyZnGmvNxm8cafhbMbbkMCJ73l7a+IgEKo6?=
 =?us-ascii?Q?c7kXXqK6EeAkHMOqIHRUmODHl86V9m99Dbeb6v9vYBdkUc2FubhcEw244S3H?=
 =?us-ascii?Q?6GvHGJa2GMGUV6SHW39NXrr0KiZnD2jqiKDV2ygkE75/T0zz3B7e3zFCWE/K?=
 =?us-ascii?Q?rhU45Bpxx58KrVyFY0Y5fsD4BhakLOtsblQLXNhASFT5mPTwGnlrcuWRfyq9?=
 =?us-ascii?Q?4NgQs5+qpJned5pM9PS0x4wXenoRU5gL8TLd/vIu4+MN6GC2rNCg2QxUPjY6?=
 =?us-ascii?Q?sLtiaOAETO9vx8nr/jtbdpfB8zIrRdk3mJT6oBGkt6BDi+b9tXGGX0WaDNte?=
 =?us-ascii?Q?JgdkY/kB/RHB38/FmcRy20T9LIpnWL2XOIqUczcw89Fkc7zas56puJYRbuG7?=
 =?us-ascii?Q?M0Ds01Anpf9Js7xl5/tSxanOpW/miXCBEcyyGxGAIknzUVtmV5YAbTw9BcmN?=
 =?us-ascii?Q?zahnKjpWCE8LYChgqFJdcjrcQbjDli0L49b+bzL2etnfcdrAOThKEQDBxpyb?=
 =?us-ascii?Q?CKJTfBxhFVe/qYhXwtE9/vopidCFBLh7j63pvtcSOvP5FkABolDtnfEgqu50?=
 =?us-ascii?Q?KjJ2L6zEISqal2qQjh/AAkkB6K5k4uwbYYcVJPYovvcYwI7qreKUzwqjZbRV?=
 =?us-ascii?Q?8uhRWj2Cij/GejZ8RGilrFD4po+ubpyObG8W9cn+Hbam7CoaSP2OLhlbD0ou?=
 =?us-ascii?Q?cnJb4QmkShgMVyspALAvdaayKDnhUzONZ2so+IjbvOlvgweYqZbDSk7kqZt1?=
 =?us-ascii?Q?O5Y7mAPjZNZDgH6AlZrp5pbj8eGWpnG4U5JC+VY5Obe1VEd3Zn8xFdMwQPNZ?=
 =?us-ascii?Q?9wMWv61fy5ijq0PdzmrtdriwMxAORAJmcIti/nOux/iVcfwmZnlvPdaigxda?=
 =?us-ascii?Q?575r4nRY3wQPgh0TAbpHZfaoh604Mgy3P+2ag4JSwNmXM1QO7+obV95FoI6B?=
 =?us-ascii?Q?FdSYGVdsG+GCMOYocSCgWP66S2b++iGJFmdghNEZLJo/Y1dmX8i2tcjtAwLL?=
 =?us-ascii?Q?lS1Uddw3g/XjyVexDMwa68HzGgy5Zi/m/4kDPEPhh/tCV0eK0YCyfKwpKp3w?=
 =?us-ascii?Q?WPDpeczICI2VDuvRMkBaiYDD3Ob9c7ORWzCe2YMf75hSjrULiF1r1yKRbzz7?=
 =?us-ascii?Q?Gox9XuiW+TZaus2eE7kdMv1X/C0KtoyzmloYORUgQpq9tGYC4Ly8SIgW5OWb?=
 =?us-ascii?Q?5D8kFsVxHe7f5kPa+r/cxLVRZPMrL+pFbcnRPSdkONFsL9kXP7c17kS8VcuI?=
 =?us-ascii?Q?IbvPadDKUgR39vA526+zQrjuUSx/XawjU32HodCK+WLX+9ixeM4XKF+pN/dV?=
 =?us-ascii?Q?2jUa9CQAsY/KlLjkmD5CVJAe+ls3h43Bv8FtPQqwhPbkLjuHJ/N7oW04ii2Z?=
 =?us-ascii?Q?cSWCqoEYTpYXQUqh23YBfeyA/IqJv0Kgekj1ZPRtSbGHHrMeAqZpc1+0p0iq?=
 =?us-ascii?Q?HorpLZi179hpT97qt9f+QavmysUyJ8i5Bo28rxm4aVEy4bieCde+ovQ1TO8y?=
 =?us-ascii?Q?fcPb9ewiU3svvXhOiai3nQEWnAZjp/6IncjdOK8K55JPxk7Q9L5wiWg3tv6t?=
 =?us-ascii?Q?NyZ2GVYv76XzSFfZVvw0hl5V1MnhhM4f/1EVG9uR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed56ebb3-2092-4113-952c-08dad69465f6
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:28.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMsR69fQoPyI+XDHPQGzbjpdJhOdPS4BnaiRQvkEIVEylzFP1u9P8VOHqyprwQl8yq2ocw9ti2RpXvkijvRatw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6265
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These checks are now redundant as they are performed by
br_mdb_config_init() while parsing the RTM_{NEW,DEL}MDB messages.

Remove them.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 63 +++++++--------------------------------------
 1 file changed, 9 insertions(+), 54 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index c53050e47a0f..68fd34161a40 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1090,11 +1090,10 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
-	struct net_bridge_port *p = NULL;
-	struct net_device *dev, *pdev;
 	struct br_mdb_entry *entry;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
+	struct net_device *dev;
 	struct net_bridge *br;
 	int err;
 
@@ -1108,38 +1107,12 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	if (!netif_running(br->dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "Bridge device is not running");
-		return -EINVAL;
-	}
-
-	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
-		NL_SET_ERR_MSG_MOD(extack, "Bridge's multicast processing is disabled");
-		return -EINVAL;
-	}
-
 	if (entry->ifindex != br->dev->ifindex) {
-		pdev = __dev_get_by_index(net, entry->ifindex);
-		if (!pdev) {
-			NL_SET_ERR_MSG_MOD(extack, "Port net device doesn't exist");
-			return -ENODEV;
-		}
-
-		p = br_port_get_rtnl(pdev);
-		if (!p) {
-			NL_SET_ERR_MSG_MOD(extack, "Net device is not a bridge port");
-			return -EINVAL;
-		}
-
-		if (p->br != br) {
-			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
-			return -EINVAL;
-		}
-		if (p->state == BR_STATE_DISABLED && entry->state != MDB_PERMANENT) {
+		if (cfg.p->state == BR_STATE_DISABLED && entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
 			return -EINVAL;
 		}
-		vg = nbp_vlan_group(p);
+		vg = nbp_vlan_group(cfg.p);
 	} else {
 		vg = br_vlan_group(br);
 	}
@@ -1150,12 +1123,12 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			entry->vid = v->vid;
-			err = __br_mdb_add(net, br, p, entry, mdb_attrs, extack);
+			err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, br, p, entry, mdb_attrs, extack);
+		err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
 	}
 
 	return err;
@@ -1170,9 +1143,6 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry,
 	struct br_ip ip;
 	int err = -EINVAL;
 
-	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		return -EINVAL;
-
 	__mdb_entry_to_br_ip(entry, &ip, mdb_attrs);
 
 	spin_lock_bh(&br->multicast_lock);
@@ -1212,11 +1182,10 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
-	struct net_bridge_port *p = NULL;
-	struct net_device *dev, *pdev;
 	struct br_mdb_entry *entry;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
+	struct net_device *dev;
 	struct net_bridge *br;
 	int err;
 
@@ -1230,24 +1199,10 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	if (entry->ifindex != br->dev->ifindex) {
-		pdev = __dev_get_by_index(net, entry->ifindex);
-		if (!pdev)
-			return -ENODEV;
-
-		p = br_port_get_rtnl(pdev);
-		if (!p) {
-			NL_SET_ERR_MSG_MOD(extack, "Net device is not a bridge port");
-			return -EINVAL;
-		}
-		if (p->br != br) {
-			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
-			return -EINVAL;
-		}
-		vg = nbp_vlan_group(p);
-	} else {
+	if (entry->ifindex != br->dev->ifindex)
+		vg = nbp_vlan_group(cfg.p);
+	else
 		vg = br_vlan_group(br);
-	}
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * delete mdb entry on all vlans configured on the port.
-- 
2.37.3

