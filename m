Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8706441AA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiLFK7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiLFK6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:58:52 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C025A2182A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:58:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IP67N64BCYed8aNxnd3Eqd9br8CKm0iQOpNWZUC9rWDWvQRG9/8gMypEkikk0xiIJs8Q0CyAJ6m8nPgUaGPv1pm+kqUoHA4so2ngYxf3xfd8ZIx8yTcA3jw70Kdx+LPrn5MBKmyRgyjPVxVET+L3DcZo+NjfCmMiZtDq3DYVF9HDNGgKG0NcYpJWW0my12zyiS2xsTJxgXm7BfX80nZNHpFjD+f+c0oDmiKCzNmXpW1zOP1idx/XYiY1/BS99yUNPp7+IAzZgdy4+amHDBSpNK0yvLbiUgiL43K2DyDWpYZEX9AU/smWk3wqMhqqLgKzc1qgOy1PD6iuPg4eQsk8eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFRA7drTZfsote0ZE6CeV4KnGMyG1D7ae+0TshoiI18=;
 b=eJZ0GOT9i5gUJjFKY4RJumm2KVoWxP8JFDzO+vBu/DToFeMXUhxiCm9LmqmbYfKu1bKwVfbSMHwBLF01dgsv9yJWDgiW4zwxAI5v96Y3docppFsmaoaTSbfwa9N79FaUmDxz/VgXC8Cp26xSTilcb9jD5Ihdhtizs2C2cJ8ZLWyO5GL93BDa4iepwnRyX5AWa30BlAilrF5QEagAda9FW1OKPgI7C57BTK6VDVZ6O5NYMiMhrN3mHt/vkDMERKLoMMz0Wz0oyhwBJbVVs2R2GOUa5vLw9MaqGqw9ty3Ap/VnY5R2o/79O80sa31lSEXQc5Ps1RgvVINrEy0NRL868A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFRA7drTZfsote0ZE6CeV4KnGMyG1D7ae+0TshoiI18=;
 b=GjEFELGixzPF7pu4KFTgOLQxiNpVPSUBaYBGtSIut+tCNrsK3GNjLyEEvWc705clDClzpx/4zYZaT4jCCgs6Xd5ACs+W/LzXwXFFMJFppyp+mBqi3YhFwM/fwL4NNO06WRZUN7yUpvO9q816V39hc8Mu1AisYCS83lXKxaWS+nDT12rF0I1w4Jtj4FgPndpivdPdS7SY0fv7LPBH6FWi43pNCFQN0f60rj2PcUGGTqUURe9E6L60UAcwJGmUPMBcPCfiv6XdugnDUCVHhoRMpTZHy1sUIYspBpSdqJ5jaNyesCMzeXQRpqn5B7dQnpIVmop/dT8VeJKxSZ2X6v3BYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7100.namprd12.prod.outlook.com (2603:10b6:930:60::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 10:58:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:58:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 2/9] bridge: mcast: Remove redundant checks
Date:   Tue,  6 Dec 2022 12:58:02 +0200
Message-Id: <20221206105809.363767-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0012.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c231937-1d7c-4597-5252-08dad778dab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fsp37Y1p7THTJGJoyLTcOJ9mj6L66Ry/rRTcRcygT2OCpxZI/mhKSIwamO8nPv6lqm9DxMq904wtAiBQgMNgt4iubbWO3JDgz1HqY01O/JfA6pZe++RIfD2i7xEf0oq1F+YIj4EV9nhGDP074u/ItyD90zs8tcdXPNq7K/rVn6FYLc489+U2VqnT6AcOYbz2xyprNTO0AZRW/IilZVfh9WXXYog8jYK6oY+Vz9mubi8m2j4oMqfHl66iN1/egxfKxlkAjl8/guNRdtH2rFKk61Ylx6gMpPwkbzh8Dea17oZOsqTrOqioBV69Y1RMZYY6kHk3WBP+sbABiKJWnNOEu+oQV+34bMkK0Mkc8M+xeE6LePTJAunp9rnQIsf1SdjLXJI1TL0IhBR+A7sl/vkNHxgi3I5vyhh0aJqhxPCyJVTHXFwwn1rjQGuSbhWu2ZQ3dx8y6St6krhZZ/ll6HxoJswkm3UgDhc41g+5nZzSG1hit7aQ3i72UZsyNOP3R6GIaHUXwhAmWhBzXQFElFFrWuv9dDtHReYMlP9ZkPZGKg2jAzFrb8jw+VligxdEP+FsXz1iIUVXEzQxHutSEstWWA4F4cG8jSOmq2m+ByzJu+7YykQ+DPZPROu0PQsHYFU/rTt9Gmv/rQvIHgyHL/JuoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(1076003)(83380400001)(186003)(26005)(6512007)(2616005)(6506007)(6666004)(107886003)(66476007)(478600001)(38100700002)(6486002)(41300700001)(2906002)(316002)(66556008)(66946007)(8676002)(4326008)(8936002)(36756003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ey8i8aklpNeh0oW73fHNNGidtH6MzduC/U7xUW8J9biiYtBnUQAnPujSuwai?=
 =?us-ascii?Q?qNTytypSlRz8KHMozAborv4meOVXoz83KisYBD3K1mr0ZRcTr5SWplWYYz1j?=
 =?us-ascii?Q?1IUAl8MqVcnam+Fxa9/Wab7yQzvrsrRkn3x2U658EsYGi7oxPHp0tatsEv27?=
 =?us-ascii?Q?62Z/+WVeK1JRw62CpDJL5Ix/5ryd9kHi/DEjKoc+BA0a54YIme1Nq4wotNP4?=
 =?us-ascii?Q?t+3hXcb20GPdvDR66g5As/Y3xnbYewcnOH8yeY5kPKWpwyFXNexONnYXgmGQ?=
 =?us-ascii?Q?ZFQMXr4DnZ36jhT8qKzt/aFkarIRJpY+0NZe5DjmRIp4dNpsz/T//eWhE5ti?=
 =?us-ascii?Q?bf3mva9M1uQ8mhArFKgXTBp+X/gVeTzpTUaFf4hJU4vDITTegknf4Wq1QF3L?=
 =?us-ascii?Q?moa0zofP7fKm+qGG1pRMIQD4ohWB5Lns/gdeATroIFumRgdGqUjzAEy0zWGO?=
 =?us-ascii?Q?WG3wHbBmN/SFWdpq6TrGR+ZgNFaVtO2z+q6a8Dj9OlRVFqRLItgPF8cSY/WV?=
 =?us-ascii?Q?XpQFO8VJBOiLimUQfGhm+eP2jwebqKqd13vm88JDCcPovt9U1u0jmJwfNura?=
 =?us-ascii?Q?01Y1h+IzXqI4x/L0s6vmkE9kbao3oRneicdB2lxn0YY21TIUYuYnw0LLW3rY?=
 =?us-ascii?Q?pVTHRu5JimcKtCZvrWrk/ApIztGkElFIQcgH23619LTCJ+AUNH2N6pWEWCF4?=
 =?us-ascii?Q?IMzNRkw1o/NVjisj2UJGwGjH/Q3/Qw+gMGplY4rz1zq0D0TyZQIR+Bgg/D0H?=
 =?us-ascii?Q?T5cZqckgtZ5ICvsruopKGqiZz4OKh5NdRl6gzo/aQ+JO/nCmjhk7VbPTM6H9?=
 =?us-ascii?Q?6sVPi1q2/GciUtqjWZeyAQKqp7daZ5YE8s9s2eoTHId7mTUMrGFTJnlWhJ3u?=
 =?us-ascii?Q?ouK9BVH2lYdlxdpBY1Aq81+JSuO4k4rL4cmiRna4ReSlpFL/vedJ2KoYmo1Q?=
 =?us-ascii?Q?ghgDnHGyK4Zg25f12yAH4k8XK9T2JGY7V3zpvXK5nWOgcwJSvyMRPurRuTev?=
 =?us-ascii?Q?VVn3A/cUsSnWjGtYca1v78R4dsBLTQEaBfveZeZDOnC5uOhk6lSojICf5IyN?=
 =?us-ascii?Q?CaRf2jfKrkxDOvzm++kcGwhrvTw1n/0sAHbyvynHikcILKe0WBySGtuMbcIR?=
 =?us-ascii?Q?OUO0bz7OuQqlt5j/MRUpw0/vuOCBonjTYf6Q1mngrHNC7FZahoRrIXUsOfZP?=
 =?us-ascii?Q?qApYdyRA3xtffNe5GhtaR/FuVoFX1oa94BZCmHlDbR4LtuHKRLOxErgAM6B5?=
 =?us-ascii?Q?WGlH6ItBAWbBC299rOZ40kcmH7x7VGowXSmRFcyT6pWOJbzkeaEjfiyP+gQB?=
 =?us-ascii?Q?3wusXCSDl3LzeUZ+ipdIsFqv7jMjOGwCa5xv5L+NJmwPyAidR+CUDftcFJ93?=
 =?us-ascii?Q?mjtfbJcHU+uKoVD8j6GfEefi/1jnANm18g5v2LofpDBax4EzG2Q0EYV2Fgd/?=
 =?us-ascii?Q?loSuDUQ+Wsvi1k7P5Kkl86drxuVEVSdqM+Ez8ivIMwn1Z1VBVd+D9i1Vo/rA?=
 =?us-ascii?Q?n4hklCYDIiqwDEBaW7bip1VAC0paKHoE6KGlM856I/16wvcZb5YTf3klTSyB?=
 =?us-ascii?Q?qe0O5qQ6qx107wX3fqwnUqsXcnSbdarAJD5L8SOS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c231937-1d7c-4597-5252-08dad778dab1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:58:49.2228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FeDiCRb80qhom+yiAPIia/6DQt2T+p2uo9m4VdxwRm+lJGfY1NNyAQMg5MZfK0dm0PiJy4E8X4AOijCKJFYOmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7100
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 63 +++++++--------------------------------------
 1 file changed, 9 insertions(+), 54 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index bd3a7d881d52..c8d78e4ec94e 100644
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

