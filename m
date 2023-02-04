Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B5468AB94
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbjBDROQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjBDROO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:14:14 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B4E72A4
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:13:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpJS36iK5DY+sFyvYtf4tTjsmCQIuSQ5CX2cs5EeRRI6QOVLLQ/oexu6MFAM5r+K2/AcYiFLL57u16wAOQBkCdoBUM1NRo8cSLXofHsWGpzUMKYBEccMRdoIAlNZWfLj5a281yeuxMhsHB+5Y5vtm78Y3yoitLK3+5dYUq+dUu8L74mJbHUjNdlLCcHT6x8W9qmOZ3tB9S76t8MMr+XIpAy0FxkX6hgCiEVtEZ0z8t7WFp+dcIfeITzjoRrIw7UURCfcGcgQiB+ALKJrB1jcys6ZprQM/I6aOiFQ0KswWwBtGYk0LXihO8cClkLz/nnAZLFukZgjS/7e0FVmXqceMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9vIZfjeNZjPD//rZ4qABhtrQ7NtCZ56VecAMZrz9uA=;
 b=Hwxt8x3gJOZZVqqLpKBnT9sldNdAInCtjAk9k996M+V3vSOgTjJvJWQ5Yc9pv4kbpw+0zGeOV9R4uf0l2q9crM/UBIHFJjvrxnrCDU3pDn3TG3Yep3gsrruHKZ6+dXanlo/iFrpe3DXZ62RuHn/cNc68k1QJGNhGH/6OOlewmRpRBdJWqsJt21Et7s6IpcRL12Fl3+2iYyjtqm7XLGlvYQ9kUbL2CMaq+f4bBCG+GW5g9aJ0YziH/Bqmu0qx6iFZdJFjW0FirNsSeYZQSBC9c5sWCcytUkMZD5dEAFMkkX+tErqpNBB3CKoEThrAUWMYhou1ouZYHdRWB3i+jD2yYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9vIZfjeNZjPD//rZ4qABhtrQ7NtCZ56VecAMZrz9uA=;
 b=As65JTzj0hOGgQ/wNH+kEpiKtLB8bX9DYKqV/aVUrVsPwEkadiFmf/mmRZqEz1nb9a4C0oSLsMhq+yTjFT0izlIKKZcneWewzSnMQoFnP8x8wwVL3nHXgEqBc34h8L5VOjLNvk5cgtap3zMq1oFY9otb2EyjuYZncd9znDa2kpgT4IpsR7gOnRAZsEyD0dKCsMzuML2rocAp3wZ83itYbVOqrj/dRpiwpJYUgU8bd99U1d9xTyGXf8fPFb8Si1JDO6PmCbjWaQjoqMh+UlhTOaZlWZdm2+gMBFVPDRv2pUf/K7na4m9vZDB8cGaXpz6YemLDvrm/CaOO0ZGeQz6Ljw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:13:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:13:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 12/13] vxlan: Add MDB data path support
Date:   Sat,  4 Feb 2023 19:08:00 +0200
Message-Id: <20230204170801.3897900-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0261.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 56d1cca9-f6a0-49be-0f0d-08db06d316f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wa/+ws7KHyTex8TtzL4lHQ+cu8UIT62fIrWQRLKhwCLSKNvKMM19Xby7jWuEU5kIwhOD10GwZO9sQHTy73hKyBzc4zAqRMPrBAjbo2gdPR4xkDLvJTV+4QLCZQOIjkGkF8PuJ2NMBDUBQE1VG4JN6FqwyK6kGQKgKPWPSTcIEvh+nCCIP0tOTHd8Q37pHDojUSUgHpaaG5J+9QSE3bKxRUgg4xRwhFXX5arUtLgn6Zk8T5WjctqAKxhMPQI2nDabPhxTyxZjy0ODa4PnaQWZ/k/+EMZbRRoBNzzD8ph3NmUMMG4p/DHq48xq2+dXyQkWUMIUR3GgFOF50wfHZTP+KEhkQuTEoqeXvCfB8FtBPb1B9a/rC9Cd9PHeP9SYD5WKKGi19vuBIPd1KUDsV8/8MeKRaV21JQ6ES5xQh9ojtFDGrXLQf49iCSSMDSyuu6YWBE8PkC3eHF99N0+rYbUlh3JqGrUlxuVnU76q5hAJf/XVo5/JbjRJPGrDDvHqZ4lpsOngwrVtRA+XHuG4UymFkLGy8JuATjNop3el6pjWum+Df/AilERkg9AEgSjkq9IMzVhwy3aPwmAKmI2YmWBkgKW0NtPJ0t0Cs9R/ZXN6kNzbTnpB5oJiPcN/lQfU2zXoYX8QL6rMvcQ9rdHA/w3GsIQvocd5IUFQ412TFd+JgVTMoXWsQ+j3ldgueeA+wmPXQCHHwKZeZJuO3BNqSiB0Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8936002)(36756003)(5660300002)(107886003)(1076003)(6666004)(316002)(6506007)(478600001)(38100700002)(966005)(6486002)(66476007)(4326008)(8676002)(66946007)(2616005)(83380400001)(66556008)(41300700001)(86362001)(186003)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4VAg9F87OLMUnq0F8Zrl0aSyATa+8ck/tU1EfVswiWB+27xD14QvYPzyDC3v?=
 =?us-ascii?Q?C0+RdJX62hRgccTWpVZHJe6ylmYoTKT8cobM4CxxLOEiSeZOq7adWGIBwYuN?=
 =?us-ascii?Q?L5DLZObpT8mT1Po7eeGrc+dOLHmi91a2+TmVH+HxlrgSEIqBB1Xp1t9B4NBp?=
 =?us-ascii?Q?aArZkfZMuLsS6dKIqq6AWNvTUVtGk2fYNZxqURHjkcto8dY518SB+LLrJkCx?=
 =?us-ascii?Q?ZCrTWdBRAjZJgV4M/nByDxwS9jNMUWThvapYZtMiIropWzVxUfyGq5hLG6pN?=
 =?us-ascii?Q?QnUBA5JzpSuX8hdTdZ7iGshk+BiBEqly3lbuixlxDYw6eI4iar01GLygB3vq?=
 =?us-ascii?Q?i7EKDsFC7vREzC2aZfax7gALLuvE92GTK/gZUvDd82eQ1wzRakpx5kWOvN8I?=
 =?us-ascii?Q?Pct1jqfohcmxTFc55og8WqfCkOx66T7Tuy6hUD7/jToba+4Bj62nIGzpzUUI?=
 =?us-ascii?Q?XVm2gznYcRJLDZMf/k6s2vFpUy1tYAZSOuuOovTrUfHQV/bH2HIwRsfBqotj?=
 =?us-ascii?Q?F4v86dhnS4WiEoS5p1vGTjIQkg71UjAcb4dG5x7fUTj1o0ZU3fqjfABW2jKQ?=
 =?us-ascii?Q?qwb42LCUmdtPm0f1vPXtSr0UJjjJHK3+rXg7AQPiwfE8hEOj9eQmAl+vTlqa?=
 =?us-ascii?Q?umEhuk5Og1mJWRyUr2eJtxnJZbSFxvmFQ91Vks3UGtnEsNctZgDIb0XEjSLL?=
 =?us-ascii?Q?hrhf9anYU2aGhgn9MhTQRi9J98crk5mE6ZngcZYY/8p9n6g2AkTio+pbrESm?=
 =?us-ascii?Q?FZ9wX201yev50wkm8LljD8ZbwJJREO3cFtovHLQP/pAkZvh7aXM56n50Xqny?=
 =?us-ascii?Q?VrPCcYv40hyRTlEtN88IXReeoCDVYdZ4AyoMUFR2YHwYFUrmFxTrO+3RMVfk?=
 =?us-ascii?Q?9aJHGuPPIxv7+PgA+ko8NLIZLwjxQqj4eBIsE7+nkhivRmb9KoVUWTfLCBdx?=
 =?us-ascii?Q?jYD/j/8UPDc8PWJRYMpDq1JDKs+Qw0gonic26tUeROTmoIeU4JwixKwBbqnQ?=
 =?us-ascii?Q?OyVzp48Wj0VstozN3/hTEm7OO2lUr68r5sgxNtLQxxqFPkugv23hu6ZPw7Ct?=
 =?us-ascii?Q?MsZGG6Be9TRK63TtG3qq2kzvgB3JVc9Xk7eTboXh+7k6WszZe2hIVy/8uQMV?=
 =?us-ascii?Q?hVhpxh44U0nbVdCSDnyXJmXlPH00zyqJp4gROKzq1J/26677idGlYC2i2c8P?=
 =?us-ascii?Q?TmaQRg7dQ8R6pZFlCVmClNPzYLCKpqh5jLNGAhTZuAQA4UIzpu/vqZa+iyPH?=
 =?us-ascii?Q?waR3+mVWcKZ8ZpA8qwlHl2qTm6DpADeUC/sgYg4P+iLeae3EeqyCWNXc9lZU?=
 =?us-ascii?Q?H25781iDVxx+NGjmgM70sDkgw0l0/+qSsQwpmdyHh6bM+kgZHdjVmjB483eS?=
 =?us-ascii?Q?2h4EcwXxSy/MmtagZNPoL7PC/apd82VcI87JB8KfxMTAD/WFN/koE7Dsgtfy?=
 =?us-ascii?Q?VSU05v3lm4xg6AYLT7L+V5g3sj+K8GMHhDl+xaqTYSewpSLkZuFhkZgJEJdB?=
 =?us-ascii?Q?Skb/0s+u9auR2B/rJzm6dJJDtDNO/g+pVvFv8O6o5NXT2SHIDPq4xgiAwmnF?=
 =?us-ascii?Q?Q/YGd0GQFPiGVDQ0IBfgkTUqusMnqk/vC4FcGckI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d1cca9-f6a0-49be-0f0d-08db06d316f0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:13:09.8254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u19tdOWpUtKMKjZYCt2rFa54PTDHElWqT45y5BDIEzxO1mgNIuE9xscNVNesWGChX5ZjPFCKAM+64D7vT8hmOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 72c922064c02..34ffd77cd466 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1320,6 +1320,120 @@ int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
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

