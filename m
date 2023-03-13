Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA166B7B4D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjCMO7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjCMO63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:58:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFBB74DE0
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:57:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFWW5oqzXLQwBpzI3bCycQxS+3iBjXn0/C44hs3XZYN5dEFWYIGCbS6E4+VY5cfltXFaiBCyAnqEqfE/Ux59QHFrUKar1ENrczIAWy91ui6i/Q2Zb/D5ypzrEfhtT/ipZJYLRylTCZXzaUgPjhtdQ4R2i+8rqft6lZWC5tzfueedeZwRQCzJ3sTEhAAyFs9kHyRHv450kwqcCbD6On3V7RNViuadc/CZdgAncLXD+T+gaxP3MP7NHhwv9GK5fIXRtAN+h6mNnw+PWwurRdNavJKOm4CykNjvzI+bUWSJiCl3HnSs86YSsgi8EbTGAZlx8Ymq3H7gPdeG2dZr+uQGKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBh/Y+LnmR1DnahT0mCyA+/2KVkOUKCdcm71fiWlTt4=;
 b=ibkDDgRdn1qG/kdAHjqRpNQDrQsbCbpKUfRJ93emWsBy7auNmnEmXdoXTxOAeblQFf4yEK5vaDMxMyitlzTP4UW0bkACKXLo1dJAgfU6akA0kLJGkId58kFw2RgeD7LY9giNgJF8s6qPJghU9phRdibyfKnhCCzzdJsNgEf+9aYZJ9RIryLUKD3o4L9ftEWTuG22FcFUahIyGOUkwdya9rnyzXmho6LNE8jzK1dL4weTFzcj1qovrSX6m3cszoTQKWqNbBmhv8oMARAScvs/NA0iQ4wJnabGcfPTO0BS2Oue1NjXlY5MiDzVbf1PWRe1RwpdMaC4JBYp6mb6PPwPkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBh/Y+LnmR1DnahT0mCyA+/2KVkOUKCdcm71fiWlTt4=;
 b=te9+VAtU63LG4Twr8ILPnshrxuqptpqKwA3QqC9lXSKi+l7s1tb3XyI7MyF4fm4Ux9rfpQpI1Gu79a9SDunnc/lb6oDT9ky/Flguq24Lj+ek+Vq01NHnaDTMbKMQQ9VdfeExZDiIq2J90GZjvQRU+F6v1/7xlEdSiQE9PinBPTF7aqWzi8eZjPj4WaZVvKYlnufRn2a1Xi4ZrCWNPj886EROSi6xeIzSQvYnvKP/pJuXkw7C0y2qiMUiAFjwKOzziC4uEt6qXg2F6bnkkjcI74Fwy80yM5+Zz4gIMDwgXH8dFIPhGzkAq3TTPlySbtkCFm2I4TlCLbcxnll/vrKVIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:56:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:56:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/11] vxlan: Add MDB data path support
Date:   Mon, 13 Mar 2023 16:53:47 +0200
Message-Id: <20230313145349.3557231-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0201.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: f4954acc-150b-4641-4301-08db23d31464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k19QivhTGbXiwyvQtR2iWfRXJ+MLUlFGcx5qvkF6lVHeXZ0g/QLUkm4uZ2aAC1DcyYhCWi5YFByl4TbiaafmiCMYy5oVRDVLdyBa4dnqp2vkIwUqDOuwLk42LcdJmjTT/oNNCpgDXTs/FSkBtN4CwegIh4cDPHBelbYGxn+xLsiuplxQKdIG9lS0ugr3lnQ7MQ5yOrgPHTtokmcihxg0ml38ymA4gNNNldc4Fvz6Qc6FqOuxQt35vUWSIGIYpLCpRJ+bgoAEoSjTMlkbsZ0+IZCPXiaHeHQz4k7ULXuZ9CowoXo0t7PksO/vxwwB0PiUJ+UJZ9485p7M2XB1uQZHXsJ4nge1jsIWdwBuHm+KqMBnmcTaiZBYHaDDLY9Chjj1QxVP1ZQn7M6wfE7qFw7ThKCEmPYgZGox7bI56PNclBsfVYHO9HBTWN4jx41xRW2ja/acCRwC/7unW5+RhCkDDiipJkmnJ9MENnNLbb+Xqp/gyiXUv1HfljkFOIUWcnbE3wB317HcNjNJHEUfb9eokne441aMiVsTTXBrh7smF7mU29ULY03vsTDlUaUm8P64MY4+u92+GEEHr69HvrohQBF6jbhOvR8urAQ7dn01MpqBCBs4a2HfK1M16d35NlKUfKkzb26cTnDlB84zcGk8HjrQDgrcWO+rzgxFRFC84eBeK4uHh1sf4EjXCE4NC/S9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(26005)(6506007)(6666004)(107886003)(6512007)(1076003)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M6Vff8HCXiViKfNyfBmR+oT3sQMy/VGz3YYAgwB4xdb9SYtTlDG+ClDdLYdV?=
 =?us-ascii?Q?EQT/IQlat1oD/XEnKLN1PtagrpqeIQqWjhF4vLnpCir/PBX4KrrxXbJ+689+?=
 =?us-ascii?Q?mFxnMPcQgPd+E7kiIOa1glYfy2Ot0prMbAr7XaCANpl1Z1crIltRD9bDhCWv?=
 =?us-ascii?Q?anJhLybzQjM4VnOv8fjW943DDCizOtPNWdgxWIOza3Q4kdxYe95s27asovqE?=
 =?us-ascii?Q?cJtL/Wd4gmSO931l8rOhglaSlz19w9AAF3loaoDJ4VWylaMyOR09xDuW+7R2?=
 =?us-ascii?Q?FavU39FhvyQyhCBNbhBf40LgIbhtcv5IYSXKL/PkjUNDXfDHimRNaiLjf75M?=
 =?us-ascii?Q?qn05dV1TWytGWMAIyY4I/RpUbsyAGW1DXZDr5Vt3tw/Otxj7CE+GIV1Br1Ps?=
 =?us-ascii?Q?RZfPS2uqeNY4AJAZogwu6KGvGGfKeEnhcXDKWVmquBh2Ewdzo5zSCjdMGXYi?=
 =?us-ascii?Q?/OGze2piPtjbL65E5/IMf3oZEoFLXaSmqdvH3b2NOaDNuNscthpc8aQSIcBq?=
 =?us-ascii?Q?fC4myDQm43LdYrqlbfTuHr2ql9Xl0j6J79E/U8n+yJdzoVm27DkIzOQ3CEdF?=
 =?us-ascii?Q?frmIGDLIo4kRr828MT/hLK90hhwN4fKyVF2A3W4eudEOe+dEKHJZ7eRD2q29?=
 =?us-ascii?Q?pTkYRg9SmMb0rCeowA/z+5IiVP1tK9xiM/kjw7ViQ5/P1U4FiYrbYR8mafDt?=
 =?us-ascii?Q?IOJ42/03sxIB0Nl88vTLaclyk0RYVV2r1l2+/84sknzBdq64DmHJrD9EyTYP?=
 =?us-ascii?Q?kfNX/Lhg12hG7O8hONWZkJvsZ7zLauhUAJa0q6FT4Pg4jDMG7a4t4kq4LEiv?=
 =?us-ascii?Q?+PHYeOepuvLG0VRz95yI9EKWvHqR++QICTSJrPcWmVAu4wUaL0kezNWl6bwH?=
 =?us-ascii?Q?ZlyyeulDF4XWpkPYSbqU0itI/3iF7oLq5bXJS1WyL5yy6v1dxJdNmtz0ppXl?=
 =?us-ascii?Q?BNXrr/fUsmLN4ton+ohHO3NbjHVVpfW3ejYKK1JdSb2vx7nkqr+Z21kMaE/8?=
 =?us-ascii?Q?hHP16jhW4P/VMMAzWwJQZnJ33mm0loen02WNu1TtGwwjesafPi633iHY6Ptp?=
 =?us-ascii?Q?rcnmp0hHOyYk/8EOn4P7drINw1yCbiD2FX2zdLffaRgj2wEnbm+TKm376xp0?=
 =?us-ascii?Q?LMZYikx5RUHf5F4CdF+EULmyMuergn3SkfahVZSHN1bhIoGgz8LlOPMkm42l?=
 =?us-ascii?Q?myed6COi2Dyp3o4gvSd2KvYnUaY7x8N4JaYA0j1oyMjKoM+ur4dgsdhOKDNv?=
 =?us-ascii?Q?kE5+nrv1CRxSblWYVLIp+ak3Y4vQRdye38kK3HC5cnxyhA2mCD4cHhM+bVnv?=
 =?us-ascii?Q?rc+pmfowl1/PpnuIXtmxbhHHpLmK1aTF2n+QrEgeVH7iawWB//UlayZkcX2+?=
 =?us-ascii?Q?G/Ya+OH8t5r+SAO908OyjLzeWmQX0o4YalNGCJHH8Woz18gFcbOBavv+wahs?=
 =?us-ascii?Q?rj8ueqxWdqlSp4RXtSeazzPmlSuWmKhKjwJf6+cV6Pelp7li5xKhqmHNX+QZ?=
 =?us-ascii?Q?hClBooox7XpcpPKS0eOJ5YvChloeXYOvbtcwha35G1ahyfJ+nqhrcB1/AauW?=
 =?us-ascii?Q?1O5JwX93DGc5UXdkxwlCPOGE3uEji5D6Og10JiTm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4954acc-150b-4641-4301-08db23d31464
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:56:09.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flvJ8Srk3eHziAF85kCzCk6rUu1AW5/jN6Q/QnDnVGb3na53j0qo+eNjAG9vccqxjc1w85fv9sBPIaJGhxf2aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Integrate MDB support into the Tx path of the VXLAN driver, allowing it
to selectively forward IP multicast traffic according to the matched MDB
entry.

If MDB entries are configured (i.e., 'VXLAN_F_MDB' is set) and the
packet is an IP multicast packet, perform up to three different lookups
according to the following priority:

1. For an (S, G) entry, using {Source VNI, Source IP, Destination IP}.
2. For a (*, G) entry, using {Source VNI, Destination IP}.
3. For the catchall MDB entry (0.0.0.0 or ::), using the source VNI.

The catchall MDB entry is similar to the catchall FDB entry
(00:00:00:00:00:00) that is currently used to transmit BUM (broadcast,
unknown unicast and multicast) traffic. However, unlike the catchall FDB
entry, this entry is only used to transmit unregistered IP multicast
traffic that is not link-local. Therefore, when configured, the catchall
FDB entry will only transmit BULL (broadcast, unknown unicast,
link-local multicast) traffic.

The catchall MDB entry is useful in deployments where inter-subnet
multicast forwarding is used and not all the VTEPs in a tenant domain
are members in all the broadcast domains. In such deployments it is
advantageous to transmit BULL (broadcast, unknown unicast and link-local
multicast) and unregistered IP multicast traffic on different tunnels.
If the same tunnel was used, a VTEP only interested in IP multicast
traffic would also pull all the BULL traffic and drop it as it is not a
member in the originating broadcast domain [1].

If the packet did not match an MDB entry (or if the packet is not an IP
multicast packet), return it to the Tx path, allowing it to be forwarded
according to the FDB.

If the packet did match an MDB entry, forward it to the associated
remote VTEPs. However, if the entry is a (*, G) entry and the associated
remote is in INCLUDE mode, then skip over it as the source IP is not in
its source list (otherwise the packet would have matched on an (S, G)
entry). Similarly, if the associated remote is marked as BLOCKED (can
only be set on (S, G) entries), then skip over it as well as the remote
is in EXCLUDE mode and the source IP is in its source list.

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c    |  15 ++++
 drivers/net/vxlan/vxlan_mdb.c     | 114 ++++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h |   6 ++
 3 files changed, 135 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 1c98ddd38bc4..1e55c5582e67 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2743,6 +2743,21 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif
 	}
 
+	if (vxlan->cfg.flags & VXLAN_F_MDB) {
+		struct vxlan_mdb_entry *mdb_entry;
+
+		rcu_read_lock();
+		mdb_entry = vxlan_mdb_entry_skb_get(vxlan, skb, vni);
+		if (mdb_entry) {
+			netdev_tx_t ret;
+
+			ret = vxlan_mdb_xmit(vxlan, mdb_entry, skb);
+			rcu_read_unlock();
+			return ret;
+		}
+		rcu_read_unlock();
+	}
+
 	eth = eth_hdr(skb);
 	f = vxlan_find_mac(vxlan, eth->h_dest, vni);
 	did_rsc = false;
diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index b32b1fb4a74a..ea63c5178718 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1298,6 +1298,120 @@ int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
 	return err;
 }
 
+struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
+						struct sk_buff *skb,
+						__be32 src_vni)
+{
+	struct vxlan_mdb_entry *mdb_entry;
+	struct vxlan_mdb_entry_key group;
+
+	if (!is_multicast_ether_addr(eth_hdr(skb)->h_dest) ||
+	    is_broadcast_ether_addr(eth_hdr(skb)->h_dest))
+		return NULL;
+
+	/* When not in collect metadata mode, 'src_vni' is zero, but MDB
+	 * entries are stored with the VNI of the VXLAN device.
+	 */
+	if (!(vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA))
+		src_vni = vxlan->default_dst.remote_vni;
+
+	memset(&group, 0, sizeof(group));
+	group.vni = src_vni;
+
+	switch (ntohs(skb->protocol)) {
+	case ETH_P_IP:
+		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+			return NULL;
+		group.dst.sa.sa_family = AF_INET;
+		group.dst.sin.sin_addr.s_addr = ip_hdr(skb)->daddr;
+		group.src.sa.sa_family = AF_INET;
+		group.src.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case ETH_P_IPV6:
+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			return NULL;
+		group.dst.sa.sa_family = AF_INET6;
+		group.dst.sin6.sin6_addr = ipv6_hdr(skb)->daddr;
+		group.src.sa.sa_family = AF_INET6;
+		group.src.sin6.sin6_addr = ipv6_hdr(skb)->saddr;
+		break;
+#endif
+	default:
+		return NULL;
+	}
+
+	mdb_entry = vxlan_mdb_entry_lookup(vxlan, &group);
+	if (mdb_entry)
+		return mdb_entry;
+
+	memset(&group.src, 0, sizeof(group.src));
+	mdb_entry = vxlan_mdb_entry_lookup(vxlan, &group);
+	if (mdb_entry)
+		return mdb_entry;
+
+	/* No (S, G) or (*, G) found. Look up the all-zeros entry, but only if
+	 * the destination IP address is not link-local multicast since we want
+	 * to transmit such traffic together with broadcast and unknown unicast
+	 * traffic.
+	 */
+	switch (ntohs(skb->protocol)) {
+	case ETH_P_IP:
+		if (ipv4_is_local_multicast(group.dst.sin.sin_addr.s_addr))
+			return NULL;
+		group.dst.sin.sin_addr.s_addr = 0;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case ETH_P_IPV6:
+		if (ipv6_addr_type(&group.dst.sin6.sin6_addr) &
+		    IPV6_ADDR_LINKLOCAL)
+			return NULL;
+		memset(&group.dst.sin6.sin6_addr, 0,
+		       sizeof(group.dst.sin6.sin6_addr));
+		break;
+#endif
+	default:
+		return NULL;
+	}
+
+	return vxlan_mdb_entry_lookup(vxlan, &group);
+}
+
+netdev_tx_t vxlan_mdb_xmit(struct vxlan_dev *vxlan,
+			   const struct vxlan_mdb_entry *mdb_entry,
+			   struct sk_buff *skb)
+{
+	struct vxlan_mdb_remote *remote, *fremote = NULL;
+	__be32 src_vni = mdb_entry->key.vni;
+
+	list_for_each_entry_rcu(remote, &mdb_entry->remotes, list) {
+		struct sk_buff *skb1;
+
+		if ((vxlan_mdb_is_star_g(&mdb_entry->key) &&
+		     READ_ONCE(remote->filter_mode) == MCAST_INCLUDE) ||
+		    (READ_ONCE(remote->flags) & VXLAN_MDB_REMOTE_F_BLOCKED))
+			continue;
+
+		if (!fremote) {
+			fremote = remote;
+			continue;
+		}
+
+		skb1 = skb_clone(skb, GFP_ATOMIC);
+		if (skb1)
+			vxlan_xmit_one(skb1, vxlan->dev, src_vni,
+				       rcu_dereference(remote->rd), false);
+	}
+
+	if (fremote)
+		vxlan_xmit_one(skb, vxlan->dev, src_vni,
+			       rcu_dereference(fremote->rd), false);
+	else
+		kfree_skb(skb);
+
+	return NETDEV_TX_OK;
+}
+
 static void vxlan_mdb_check_empty(void *ptr, void *arg)
 {
 	WARN_ON_ONCE(1);
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 7bcc38faae27..817fa3075842 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -235,6 +235,12 @@ int vxlan_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
 		  struct netlink_ext_ack *extack);
 int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
 		  struct netlink_ext_ack *extack);
+struct vxlan_mdb_entry *vxlan_mdb_entry_skb_get(struct vxlan_dev *vxlan,
+						struct sk_buff *skb,
+						__be32 src_vni);
+netdev_tx_t vxlan_mdb_xmit(struct vxlan_dev *vxlan,
+			   const struct vxlan_mdb_entry *mdb_entry,
+			   struct sk_buff *skb);
 int vxlan_mdb_init(struct vxlan_dev *vxlan);
 void vxlan_mdb_fini(struct vxlan_dev *vxlan);
 #endif
-- 
2.37.3

