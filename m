Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F280F6BB42E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCONOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCONOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:14:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BCEA219F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:14:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rv6z6SCHm3qy3bHRLdZHKjCnihQ/kSNrc/CfQBXGjDgmXLnIwm0vcZmR+2YC5gzC9e16Wofe5Jk9Z3iylm4c6tpBw07CrNiBKfYNVsYhw/8113FU1jYURh5crVgreuTHDeyMqGcaulzbvfMODJx1UwbCTi3B2iHvxB0SLeVYMiLURNUCvQIEWn8yAsH/OcDmgxI7es+9skvTNuGDkjrbMnHYW2XbGGnvXMldl846MrBsdeB5kZu5ccWNFLnX6JiAyqr8v7uf9bof85n0ucybAEgykZvTHWeMG+rPlMRSZx+rEstCyj22GKjZIrVKef/67hDoBw2SPLUl4+mGorl7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54uDMNJxw7/OEW6wX+HNc0uXjIgo+T7OylfvyEfI/SA=;
 b=gRrPtg/qT1StcqyWu06OMkYiEi3/ZNhGJNkPqNuMkxrL05MchM0aQna6S9rm+cO+7EqqtICPB7Ff2GrsA69shXbrAU1F+wStWYk0mx1sRY0KA29AH2fbdvgJ7qMX9ppe8My5MVEoXNMU4P96XZKmYFvK7feoGHWib6MzEiuar87WB3OjwPXJ13m3XMLRkGqtROJHThzZv054iZhyNsSLr/L/vCXUgXQnNc7oN7HvL2MJPnMo/iIOwJnqxn6qmBw6a17uwOlLnx+dZphVcGu6D3A0H9xbctb1WP981+qO/ia3XNKOkVBZpheeqmm5DDZV07wU7pp7Wu4VzQlPDIJ4fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54uDMNJxw7/OEW6wX+HNc0uXjIgo+T7OylfvyEfI/SA=;
 b=rIWQUkEhI/efY3HSTnnFU19GFXWNpZlA0fqxABWMh6RQ2wtJP38voDdgY9qG9kjUbhGW2SQU1NH7uOD4YcPm7RRt2KYmsCb54VY2l2YVbQaoIF3fCanL2Hed3BVGRnP/g9K44StyVGh2DbdbepxYXNMo0XNUgSHWDkMrwFFzcODIvbAYiNAmNBWffHiJmeRhjw5oov8EqNBfL9tBfq6ZXoIqt1fYpZXXuH7zFNJ3f1oU/jAa6RmnfinsDV3NlXe7Ymo1LWPPR9bAohGbWiljS4LVAABAhjp3mf7KP8GmO3ddhM0ymCvQif8nkHRjtVHgIFemc7TT3rMluFtrc+EtQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 13:14:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:14:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 09/11] vxlan: Add MDB data path support
Date:   Wed, 15 Mar 2023 15:11:53 +0200
Message-Id: <20230315131155.4071175-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0002.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbd64b6-53c7-4773-962b-08db2557245d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: geL832k2K1f85/WYdwgBOl4/jtc2CcN2HMAjEpr8O/fT5PFo8O+iNY+IInSIOgGV1Q4evNkXwUCnB6fP9sxn5bE17nHZtCqlUa3ddiAQ+jny1H/E7qyiMNw1YJLpvTiVn7eNd1ce9aK8HY/pfyN4hDmU2+hXZmuPsGyze3e/6X0LrwjHyyV5MJkoBKs0NHlgJJTqDdD1CsDe7H2n+jegWfqzXDPx2cRYcT6D4h2Z7sitxFEuWfre4sypS672SCWl/Xrkw8d+rtjThCMtHq1YaaqPU+KlzlAB/X07TJjL+0NwzDVQfMrUZjrU5AtFXAI0RcXJtGggPWxrIoaUTV43pmGmN9wgwLLuhkY9HUYpktJ0ow6aKdHx1ZFyV0mLY+JVZS4KKqhShAkN4nRoHnW3WgqAQDYOB3sraLn5qrApzgdWc0yRLtVUsIX6jqTlEVzupWmvSGzNMYt+WGAKUP98q+WKux1FBdat2BHPV7l0o+Qz5aEY8KAgGLJgwYTBz2m2ktf2vZdq6TwhgHc0OKAuuV3PrM2dyNiyANYWjLLwJlhcB/nl/ztrjqDqcxAP/RVt5qM7+4dMBCuR4q0pJ6mPO9vYzzPoXaXUPhcpi4XiEXRNZKOHFJvBJvfZm8njxpjAwIKz5ssfjygJYzkHo3nDBy6AiaKRJDA9m7AjFf1pJLCiWSffBAVsm0At/mpMfAmo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(86362001)(36756003)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(4326008)(2616005)(1076003)(6512007)(186003)(6506007)(83380400001)(26005)(316002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6486002)(966005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aGgK0nSDt6DyEr1Aq2XFaBFheY+NILMwDdus5z0GI1Urqo+14oUjhlT7yYUy?=
 =?us-ascii?Q?Qoen/cU2OL9Gw+GhgDggIGFhilUhom2zjlJ7+awISOufTpIccENv1XiDts20?=
 =?us-ascii?Q?fMoYbWu9LPRLCYGfUi5HAgQph1kLYWKpSS5lZDS5s+fb8T83l2Ouq9MjByWY?=
 =?us-ascii?Q?rMxZcm7QRgNSWLMz5hUY1H8lVXz6hglqWscfOBrz6klEjGO6su/j69Ry1hcK?=
 =?us-ascii?Q?/X0wa8ZrhBDPYy7ZoF+DsYltMoK/0BqLKp7uT/O1wYbzaZbqxzaHnfI58M/n?=
 =?us-ascii?Q?cqmSe+B6R051nWwnXCo6SXMUqqmvY5cbj2GrrMQg2z3pIx9B/VT8lqtTCBfq?=
 =?us-ascii?Q?860AEG76AR//tRUAAiEOHaSQGSi7T/ge6GHig9DvrJXOrgMCWsdO2/Zd1I7/?=
 =?us-ascii?Q?MUQ/5URvOwRjStSJDxpFHDlbj3Et3QpIqTPvkRVt1avlZTXJEes6l8yXcwz5?=
 =?us-ascii?Q?NbIKJ9F9CGwCQWcTOuclS9XNW7EiZXEU6py8lXmpQPwplaYdG4MPmRNalmGd?=
 =?us-ascii?Q?mxP8D+oLYdxO6WPp0PSX16bGF1egaRR3bdBNxCGhlvE/P6xWG34OJmshfyJn?=
 =?us-ascii?Q?uZIlRVEw9mDGMntt2nYzeRhrkyW7x4uhOuzZ/wOBTpaz01hX/xPMXQF6O8NC?=
 =?us-ascii?Q?a+AJVi253v9St0kmVq1Rdjm/wJefWjkfacBaXOwslqiA6KiUL5YAe3lo/cg7?=
 =?us-ascii?Q?4kCpVyelyhejSm5ZTta+3r7HzrDjKrDJRSXmrCs528Dp1uW3y/UqpGtIJPUv?=
 =?us-ascii?Q?ebG3MFNf+8JZf/Aitjq4fk3rb7jSFCecUjIwrJQlyk26fqP0V/a7BqjYYPjl?=
 =?us-ascii?Q?TTp5ThOR+qAlEKDQW7BoOtZ2vjP+5hjTFytZrfCvTT2T0ULR9I7ZG9ZmjHc6?=
 =?us-ascii?Q?pIhHX4d9F+owO3y63zlvoP9sJEoNug+6RKY4VvndDaR5CbLrc5/Aga16b8v/?=
 =?us-ascii?Q?dwEwJm/npyNd03hF9NNOPFuo18tW/QHAfGKPrudG8PUr3kiG7XUGh6j80S9j?=
 =?us-ascii?Q?yc/FP5lat/T4xKSx5pJfBc0WQo+7ZqoYbTftQBcd+yJgSYoI+Px7rb2IeSQW?=
 =?us-ascii?Q?TxDB8RTugBK7albJPpTxClGzxlRbNcofBwKHYh8sRe3deeN6yPc+PMybtYom?=
 =?us-ascii?Q?mWrzrryZIiAi4xkfgSCRD6IwOl2jfHjJt3+8y3eau13bZC/rLfb7zoOymZ8C?=
 =?us-ascii?Q?8Fr0u1OP5E3jfa5XI/q//XwC8ZyVNwfTK69zGWk6+LcCCtdIuNyHQC2V+HaP?=
 =?us-ascii?Q?MbnX1XpBHWMjq+aoULCZB4B0NnqUmzq55oEm82OaUEWMB+tv1Wf+wMZpheVh?=
 =?us-ascii?Q?hlSD3pIkjb527KJGt7TUqf8gTqwjBkXyNoDpeEGhtm2dXA9Xj+zFxif/6sRq?=
 =?us-ascii?Q?q3Bp0VtoA/XDnfpKp4anryId0eEt3N7esks/BY4xM9KdWtZUjJMPYjo0lyIR?=
 =?us-ascii?Q?SfM8NBC4M0xUOALCAyt0y3m0i00eGd5IqmOBsJsHrbGrhnl5qadaSlIhuK9f?=
 =?us-ascii?Q?4FE72pmen1+/lT7FMzZMPN4a25kmQXdJBs2LO+osZeI4iJiT5OK0rV0fzhZ6?=
 =?us-ascii?Q?lH3hAc7L4is1VMDIAuKDFLrzdV6DNNS3+wJdCJIU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbd64b6-53c7-4773-962b-08db2557245d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:14:00.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTbuPP0bkEa+cLPzqrTrubj6NNwNdGN1CEbKcLItK++E2J/SesAuDGYaCBIV1BZrqJnwbyrrre9I/JizkKHOLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Notes:
    v2:
    * Use htons() in 'case' instead of ntohs() in 'switch'.

 drivers/net/vxlan/vxlan_core.c    |  15 ++++
 drivers/net/vxlan/vxlan_mdb.c     | 114 ++++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h |   6 ++
 3 files changed, 135 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index a8b26d4f76de..8450768d2300 100644
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
index b32b1fb4a74a..5e041622261a 100644
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
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+			return NULL;
+		group.dst.sa.sa_family = AF_INET;
+		group.dst.sin.sin_addr.s_addr = ip_hdr(skb)->daddr;
+		group.src.sa.sa_family = AF_INET;
+		group.src.sin.sin_addr.s_addr = ip_hdr(skb)->saddr;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
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
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		if (ipv4_is_local_multicast(group.dst.sin.sin_addr.s_addr))
+			return NULL;
+		group.dst.sin.sin_addr.s_addr = 0;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
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

