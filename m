Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792644BC934
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 16:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242544AbiBSPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 10:46:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiBSPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 10:46:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4771A606DF
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 07:46:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P50pkOmPT/cEVlcDP/pRpV3QZUiZTR7e7pgYyZJY8t6vSnTHLl4lOSwGg7R8wtt6DBAeMUa6p/DuepuPaQDtuWFZekgPcWjK8sjDmchHEpQAt0Oz/hisJJ3Ltt7IbeQkcBvuSpCjYWvRcv6vCwwTpSpAdEiXHPnliXJv0Lejdmx9JE5LmtKkWQ44aVUq5m1ZwsipZjPpwpTV9yS6ODuYiaXrN/ZJi1tmy7zpx+SjgkrQjViDFh2L5LVrl1cb+RX94WN8lWHjk1FC5n35MyWMcKHvaHnB/FP64CEgmyHXIw6zPzVJ9BNZUkecLCSfNNDyqgRJ/Lccdr4dTOH/OF3OCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KO02xwJ2rvu6iTO6VaJ+K12kOcn9oK8JOLR+FElIJ30=;
 b=Ukjn+ayPR73XlcAlOQwH0VOVzoL3p8njPQ+Agow9TS87uaguDcUOZJjZJEGeczmTeDMMQhHpnc13/85W04noT0UJjPc5b/8A0w+ubQqU5MJ2c0iuheDtZm3X5tSsCyM9PewXKwXOeobjFN6mnId0iv65cB9FscGdgzB14YXtun1VqM2r7q6qL3Rqz6YSOBK5C/lIezL558xhHWBTJONpLiCziYxfy2Ub2dIX5yUMqCzqAhGGqPHdTr9ie32IhkRwSeCS6099cga27nTwlBa1SfWmvCihGlvvaI280lhlrTkh1RS0KS066UgtyyYCJijHejwnawou8iHhZ80lBavObg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KO02xwJ2rvu6iTO6VaJ+K12kOcn9oK8JOLR+FElIJ30=;
 b=WMTWCuFYFfoghOU/nPwri1tUmRhvsyTwwXxjtDC0P9v6OApc/Ch+yRaxvJCyXBzQteiH3+srRX6x4D3ECAlDMJ5gNOfD4AAvHahAsEZouJRVyA8F8MEnXo43wy9MffCEqJPz8oQY2jZ7EO6wAUbZj5W3hW2z0IU/HbMMPQ8rGlg6lChap26U/nP0ZNlaRTUATgjBt8kSnnA+bUEudHhakcuvO9RVozP8wMkCuTpBrexS43oKWsjzAag1oqEpeAxewU1LpnWeXOSXyL/V7SiI3NMQRFIgQS7xdSDU1ueWnxuP6LRaW+9E3bLQoh5VXLoOsG0B45mX/3uYdeU2d3qQ1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 15:46:04 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%5]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 15:46:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        wanghai38@huawei.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/2] ipv4: Invalidate neighbour for broadcast address upon address addition
Date:   Sat, 19 Feb 2022 17:45:19 +0200
Message-Id: <20220219154520.344057-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220219154520.344057-1-idosch@nvidia.com>
References: <20220219154520.344057-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0079.eurprd09.prod.outlook.com
 (2603:10a6:802:29::23) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca95fe5d-4d28-4da7-bf86-08d9f3beefaa
X-MS-TrafficTypeDiagnostic: DM6PR12MB4340:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB43409631921BA1C54A4C0324B2389@DM6PR12MB4340.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qle5kEXSY7LiLoIzaiFmc0jAke4+Bj9CR0hErDuDpJrnhTp10a6H4xGnTV0yfHiLpgWFfRctM85LdkO8+AUA78yrn07FqwiA7yIDnRy9JhafzJlk6YPGUqiI5ys/KPerY6YGju/HfE/jjp9V+vlYTxYQhppuUyaX0BDHCJoCTfSE/XPgMLjq+XTl660g/v0Z7ZTnc5w6m0BIF5dzBBhNgGJ6Yxhg5CGCJ6T1t/BVEsKuqMWKUFUwv4IBGUeoPcRbqOi/TtwWlhFpBGwwAEjExn6XKKFGGqX5vMu2tP987cm9kCpUDHmAqoExidf2qRy4sFcdy1BqSVI7qwri4dq+YSDJ9SE6ayl6p1HSfOZcq4cEJvazIWlWJ2FHPX/kXZ/hbcjBdQXjGSKWu76okhtee6MrnTk4eW5ivKxcUoVgfVwavdDJh39dV0MUx07vU0JEbFVbDCnvVaYja0lChtNiY6flYckGAwvDOtEDrbRgCHZhOTQlQrEA1Ig+snGQcjQLy+jJNc2cl5/iJXT7FJ0cGtfS6L663ZvqJT7Ll18ZiTDU3+jhkSl9U53zYB/Av6ujxSlJpOdxLhtKC2Y5sKtERcS66pGTmKX858K/Fanp6wSYiHs8awWy2bHGhJYls+AV25X0PEv7PCD4e+GU5uB/Q2AO0L9xRUtuEz4RqR7JJZhsCPwgvbbRMVz2+hS2yFyo+gE3r87I6yLAMzUvsilmH4s1X9Jmlq5+VPjevn8a5HY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(38100700002)(6486002)(966005)(5660300002)(6916009)(8936002)(66476007)(66946007)(2906002)(66556008)(4326008)(8676002)(83380400001)(107886003)(6666004)(6512007)(6506007)(508600001)(2616005)(1076003)(186003)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J8Hn+ntznq0wj7jSyirlG0ACTLAk7Hmiw8OJDtQc2+kdZGvbasiJZsWxkTBD?=
 =?us-ascii?Q?ZHQHOdwA+6gUUXXXJe2lXEtU9iCJlA3RrEgBPsItoJFjdVZjsSPiX2aral4E?=
 =?us-ascii?Q?npZ53PFwBTJEPRQuYYhlgnzsdbA/+9DF9/HKes+vXEUJI8yc76KCBEpQP9W6?=
 =?us-ascii?Q?3NWRMDPq0DpJk3WpvwJRuIifdqmyhPZ/XfYpovlIHoS4CP/Hs5zZTvB8Kv87?=
 =?us-ascii?Q?hlY2uCPD5hjBCrA+CqNtILUbfhg7qKnLSYIdjZS2tMW5MdK7pgK8kFaUEiMi?=
 =?us-ascii?Q?4upBwMDF18ZKGG9zYExWn9+ySJFOQT2TOaCDEGcqSE3hUDvhmq3RpsOCJIEE?=
 =?us-ascii?Q?S80NAdSp0X1Qcj8lIJkVidMZHfZUPN9n8RF6pL5P2njyszIAKOlX5CiALSHl?=
 =?us-ascii?Q?hKkhcobuHAw06fwdrPiSLS9pfTJ/I8SatoBO/25szgz+basMOsPxhiMq1E7z?=
 =?us-ascii?Q?EXQ/fwxlcIARPv80S4NXKJV7ULPFku+9WyqoD7K2SB1+FNvehUhZ3cc6H5Oa?=
 =?us-ascii?Q?NZgLR/hcFy49v7tho/h1dzxNYx7rfXX6iFqBCUMc/nVRwi163qQr68nile9k?=
 =?us-ascii?Q?ivNx/nC6AEpbZWriq4FOXDIR/FDaxdnOmVUmvJ5Od5gbSmuk0HiJxqBiamKy?=
 =?us-ascii?Q?TK8nWjj00Wu7gs1KV4MnkHmA5E0H5KL6imym3kFVxke33M92BvQx8dM9c/uD?=
 =?us-ascii?Q?vtce/zjmnA6ZysoHSc5y3F6QzkEKJq/vqCn7n71IaHTr75Ml+5g44dKp/tmT?=
 =?us-ascii?Q?a2o1UJBfdvi0jSgsRfIpY1R2xonFKLx9sH23CZipSq6gZcb+w6ipDTY1Mtr1?=
 =?us-ascii?Q?3BftzEOfJOl77D0CSaduIGwRK9IJ4lFVFT/EVLYKX5E7Drq0LuUohLNCG8Dl?=
 =?us-ascii?Q?5K2YwuuwTbpOP35hP5Qgq80fEPWgKDH9Mxbg4GUA/VMjryfJGnhSMvMlCBRO?=
 =?us-ascii?Q?l0GeBH4x367435rHqK7wpdWZ0y0qbAd6+THMSCciTHKRyKqlIR6lNsZeMAXr?=
 =?us-ascii?Q?XkZkF5+wauZ7ZufuEgjaieCKrMyAGXvk5PwdEsBU+bYWcHlIYcGeeFJbSO4i?=
 =?us-ascii?Q?gznbzYdRtUxcPt6XpMdvMqeJjK3W/je2+IseS6AS0ShQCzle/KpT4I1xSzea?=
 =?us-ascii?Q?3ef7YRCkIfK2TczxqtHD9TldIaW7XPT4u+3Nq8qXy6DTCshGrgOUxjZEFWS4?=
 =?us-ascii?Q?iJhLk7pYYJAOtcPOFHeQItuJfTeYH/pP0oFNxdM3Bsvy8Px0mzGdin2SnDVC?=
 =?us-ascii?Q?jjNikLSyDgfggbia5IGvLWTXnHpJFrVvIqe5S/ChLzrtknjhihzjOhF68PkV?=
 =?us-ascii?Q?JLqoY5S+XXFPQAGLxT+E+K7VupZy0s0E7clbsDoPnH+TlmxnLgpnnMqiywLN?=
 =?us-ascii?Q?xxWU12BDeyq4c9nf/sb5pzcbd8e0imUdQSTLSRMZ+KLi5/W+RU0+dzG4dLkT?=
 =?us-ascii?Q?jm8UnxdZph27lib6B3IoxGaxMv/rPP0+UOcLY1UfePt6yVy5GQ76GN1Np+Uk?=
 =?us-ascii?Q?MCBHQLkTi+OeNekZNl7ixYXXV83PpGnjy9zxqVzfE1FtnVUICi2wYQ7D/4p+?=
 =?us-ascii?Q?9bRCLv74NyeMpt7ytj/rdXZ9nIyT4zuZogY7ZGzAJZiAPHxvDupkg+exidzl?=
 =?us-ascii?Q?ru/AtQnxIX12BkU87NmllPY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca95fe5d-4d28-4da7-bf86-08d9f3beefaa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 15:46:04.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: doem/jHNq9K2iIFESoo0tWkVdlBZDZc2A+RkN6L44xggcw6KctOP3W1xc/OpQ4dmuuk6VOcYdhhACnrVHZEkzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case user space sends a packet destined to a broadcast address when a
matching broadcast route is not configured, the kernel will create a
unicast neighbour entry that will never be resolved [1].

When the broadcast route is configured, the unicast neighbour entry will
not be invalidated and continue to linger, resulting in packets being
dropped.

Solve this by invalidating unresolved neighbour entries for broadcast
addresses after routes for these addresses are internally configured by
the kernel. This allows the kernel to create a broadcast neighbour entry
following the next route lookup.

Another possible solution that is more generic but also more complex is
to have the ARP code register a listener to the FIB notification chain
and invalidate matching neighbour entries upon the addition of broadcast
routes.

It is also possible to wave off the issue as a user space problem, but
it seems a bit excessive to expect user space to be that intimately
familiar with the inner workings of the FIB/neighbour kernel code.

[1] https://lore.kernel.org/netdev/55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com/

Reported-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
Wang Hai, please retest as I have changed the patch a bit.
---
 include/net/arp.h       | 1 +
 net/ipv4/arp.c          | 9 +++++++--
 net/ipv4/fib_frontend.c | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 031374ac2f22..d7ef4ec71dfe 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -65,6 +65,7 @@ void arp_send(int type, int ptype, __be32 dest_ip,
 	      const unsigned char *src_hw, const unsigned char *th);
 int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
 void arp_ifdown(struct net_device *dev);
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force);
 
 struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 			   struct net_device *dev, __be32 src_ip,
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 4db0325f6e1a..dc28f0588e54 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1116,13 +1116,18 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 	return err;
 }
 
-static int arp_invalidate(struct net_device *dev, __be32 ip)
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force)
 {
 	struct neighbour *neigh = neigh_lookup(&arp_tbl, &ip, dev);
 	int err = -ENXIO;
 	struct neigh_table *tbl = &arp_tbl;
 
 	if (neigh) {
+		if ((neigh->nud_state & NUD_VALID) && !force) {
+			neigh_release(neigh);
+			return 0;
+		}
+
 		if (neigh->nud_state & ~NUD_NOARP)
 			err = neigh_update(neigh, NULL, NUD_FAILED,
 					   NEIGH_UPDATE_F_OVERRIDE|
@@ -1169,7 +1174,7 @@ static int arp_req_delete(struct net *net, struct arpreq *r,
 		if (!dev)
 			return -EINVAL;
 	}
-	return arp_invalidate(dev, ip);
+	return arp_invalidate(dev, ip, true);
 }
 
 /*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index e0730c4d07d6..7408051632ac 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1124,9 +1124,11 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		return;
 
 	/* Add broadcast address, if it is explicitly assigned. */
-	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF))
+	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF)) {
 		fib_magic(RTM_NEWROUTE, RTN_BROADCAST, ifa->ifa_broadcast, 32,
 			  prim, 0);
+		arp_invalidate(dev, ifa->ifa_broadcast, false);
+	}
 
 	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
 	    (prefix != addr || ifa->ifa_prefixlen < 32)) {
@@ -1140,6 +1142,7 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		if (ifa->ifa_prefixlen < 31) {
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
+			arp_invalidate(dev, prefix | ~mask, false);
 		}
 	}
 }
-- 
2.33.1

