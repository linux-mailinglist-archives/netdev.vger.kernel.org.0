Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5151B78D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbiEEFsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243701AbiEEFru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C0F34B97
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAL3PosY9LHSaO2a23n6ItTYtKDU1ERkkXCEoUKJD2eSjFDmkhYRNLMRxDtcmAbPfRUAsoxY239oHANv1pegjMuF03cklriwWLzxiFjZAHAtD9twKlkHic1nAsYOdIoc2pAOsQs8DgLzvS4Pcmwj5VV1+2cpFLGH8SS/f/Rmp8tQiwBVf5znFzSRDZuT/i9XEx06DdgpOfWme7+1kpbc/t89/WztFoeyxSC6Hz3CMNc8if31CTW9U3RD4SYQnga3NHIOv2T6VPFtDx7IhZK5Y1SPrm/Gzf3lrFmxrWCS/mY0ZN4j9XsZVzQF+51eQyqNVie3Clud8a+gRhWVhySYCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peyrhIeKw+L9kGwHX9lh7TLDN8mFvNolTus/mNAwO9I=;
 b=WWEUHAR9+6VYIsmXE8P4wBT+EK6M66sKyFiLqRtwI3bEtK+rVUSSHOuLCKfsSF884d7TRkA4ilPYoYKmGx49JP0l7oTqkCODelMa8HNFnJ/rOtqU9P58SkyXVbZ+ONABX1uguIxrgVmf6uDdsP01x5/yMgArrpsK88K+5Nuh53voPnE7v2X8uMUQW2OKmqP09deDZtmL71116a8mR6eSljnvfY3/gc2bw/4IDeQP9B5Cv5YjQWFtSv3YX8f2t3p5dHpx84zXcmxvDJJ8zUb6ON6cdaBDjLVpJ9f69Zm/qcg2tTlGn1CJLiGOiQZ8L9GYsZi5HF4a6A20XKfvzExnFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peyrhIeKw+L9kGwHX9lh7TLDN8mFvNolTus/mNAwO9I=;
 b=nXiJZ/IU8bAvNkE+vy7HzZ6NOvkrNywYLDIH8jhtSBPQ8mDg/rd1awQMm/mpXFnNmq/HhW58iyljBokfTqIVDky5fHGqYalNDNymMIwu1lJ0wLiUIGFqOCKzRUoBguuCJLxC/Ed/SRjeNREbxERMY5eO3Qk1eo7hCruDwbkExgk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1257.namprd13.prod.outlook.com (2603:10b6:3:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.16; Thu, 5 May
 2022 05:44:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:09 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 4/9] nfp: flower: fixup ipv6/ipv4 route lookup for neigh events
Date:   Thu,  5 May 2022 14:43:43 +0900
Message-Id: <20220505054348.269511-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b5399a1-76ca-4d24-0d72-08da2e5a4657
X-MS-TrafficTypeDiagnostic: DM5PR13MB1257:EE_
X-Microsoft-Antispam-PRVS: <DM5PR13MB12573B0CE86A10DACFCB8904E8C29@DM5PR13MB1257.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkrQVe4KvMcHirX7/n/bj3sJQNL6DlJzsbmvB06gxhQIMuhpU9W4JSnJtbgdHODWL6lPrF8jlV4JsFgw5uJHi6JCUMv6gi7pp+t/sYoHy5j1Z8Z9VEo1IReLLqFaMcYogsEXSFucmK2+d1zYvS2Ku77zxzUMoobV8Xqib1IBieHLTThm5Dh2qnXiU0DP1BksaWhwQFJyqFxWryaQiwFYpkrQbqowa8nD1+muFjvgRSwG4+5lUkvXjyVdQHOnH+ETAjuuJclvUWDWff/oJWXc+FkekfB+AGF9FA8z0awsZPNrS13P9RMGRQCPOr0lbZZ/JgOLWDkBWJTk7HdjdsJ3D7kk571xmWnw5By6cLDqcCHjdnEi4dKLwTXAtxaKMXnR8/YzuGdcNvVXqs5kYaOlLcgPkcJjkAiuMean747ef2GSTStWi2BMTW/NS9Tmk6DwzGfkk/OSVKGVwBSMJZAuOY025pyDgz+spt2leUIXEPfn8LIQDoO9sVPCe7lFv9MEaEuDwQhErNPsHbtberFqmZkszTsjGi6kEpMRTDGS+EbFKXxhOPkBdqn5HTA5OFYK/TxqNXEmeciE4bDcsnX2Qk2rFrmAo7CthyOVWz+CYF3l61klbFBhN5JQQWQLt0zMUp73v8wup7P1aNhb9Jca/tKdK05DrM3dTqEzM1kzVa/Cggw4x9N7w1AyLFRHC0+pvG7lBO4bn0Mgo3L7qL1O6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(136003)(396003)(39830400003)(66556008)(66946007)(6506007)(8676002)(4326008)(5660300002)(52116002)(1076003)(186003)(6486002)(36756003)(2616005)(316002)(110136005)(83380400001)(107886003)(66476007)(6512007)(8936002)(38100700002)(38350700002)(86362001)(508600001)(26005)(6666004)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z3HO0Xmv0lDKAAnRYOdahDPAG7avdXCUG15bOyeV+l0hXFDecPOUl0fSBiYQ?=
 =?us-ascii?Q?0IWa2tV40MVPhxOhq405vl9piOiDrDbD8GGar6qgoKVLgw7hHsJDrI5gET3S?=
 =?us-ascii?Q?D91UaCIReTvUvVld4qrfZJ7V1NKZ0A5UMWFHBO4eEjGZXpYbybBZBiM7cv/V?=
 =?us-ascii?Q?dmBd/H12i5IV7GGwxnRSiia1KUYRWO6HL6APN24Lxz1w0XJXpCdOIAZA78o1?=
 =?us-ascii?Q?ig6Mtq6Gki4s462jyWaj5lTaPXVpyWg+iP774P4r1nLMpc1wayrBI1F7tL52?=
 =?us-ascii?Q?40jpap1/P7ZOa6UOX1NoSadEYmMRcXcJapBd57za662JOSLJVutD5VH0rGRt?=
 =?us-ascii?Q?SfcpBkz1B0mK/DY/P5SGukGKl4IRUc2Z+1dFjzWUir4mrCZl/sA3cX12b5mo?=
 =?us-ascii?Q?dLCSg4b4S3Pl0VtjznjPUS2RbNxMmyrtzSZXPhwSRtLdhU1koY78LwugSzlj?=
 =?us-ascii?Q?tgFOui68oRe9Kxc/5BVkB7JHSWCK0HzEkitkhB1y70RaOzIHCh0mOGOVD+/x?=
 =?us-ascii?Q?pT+l+ZoghLzYW4hy7scMf+3mnWiGVyFb9KgHRytMk5iwkl0jZxTrZJNBhjS/?=
 =?us-ascii?Q?wSDZmVIS86eg3hKkld+Xc3upGUcjMsw9Tya1gy2BghT44MP3D6YscaBg978R?=
 =?us-ascii?Q?f9xJ6/HuqrTdEiko7uyUhBzlMAm5FKSU84zpYTbm2RXOBp8YlwuO9vIVdScU?=
 =?us-ascii?Q?y0fiXpahUBdeLx+VdLHPRCKVaMarM0CB/l5eE374JlU07K27D0O7esD2U1Wo?=
 =?us-ascii?Q?5DXzjZCnxeq0YoVz1xI987RUNv6AKe0dTtKxMfr+BwoicJR2VybmJYuTB1dn?=
 =?us-ascii?Q?hkKVTd/ecvyLFsRoS4/HmKjpfwXjViaWT8Sozo1mwtA2a9U+JR6xso0ci2S4?=
 =?us-ascii?Q?XWUkPIGUF5dA2M7Y/diAqh0FEMsoSfbkHIm2YIZkwb8nTlgLzasu66QWXujr?=
 =?us-ascii?Q?ygZNKal66V2tjKYbe+auk77Y2fjr5q9hZVSiQAM4nqt99cooM9FGK0n9PPqs?=
 =?us-ascii?Q?QklLP+E8vr7tH6nJhuMyMvxSTrDjR5nTn0CJ8N0kB3XHBVZtG5YNxHUvUxTB?=
 =?us-ascii?Q?VnsqQPwEnLaePzKv4h3B9vMdyRXtAXkSPOsCe/bKUMu3hAIH4wuinqd18H3m?=
 =?us-ascii?Q?3P16mQUagFOyYGPOV0LGoVxxrXXcNYs8WfkeuHfrhQCq9ISKFUxNUD67jsOn?=
 =?us-ascii?Q?91FcpG0chExWI2Jt3OfqTdXeaG6XXanszI+cGVwpqDkTOxF8yeglzhL/J+7m?=
 =?us-ascii?Q?1uF0GjZ7KeEimswxMOXIj7o51CWionfcziyks9R2xk7ZcpEGTvss3sIRL4vx?=
 =?us-ascii?Q?MBTXJpV/hejXAk9JMKg5Gy4Bz/Kp80HM/oGUrmuHDQT5WVPslZbg84N0JIcL?=
 =?us-ascii?Q?bF1BwxFY2hovud8WXy9i/83V6dvcSIdBQWx6LVAB6WJclxyOAinuTxXXpKr/?=
 =?us-ascii?Q?WZN8xvJQxIimHkf/jBTXpjOlW6eCCAgCXL9U9/Xn9lR/m+GSeQq69WStTZ9z?=
 =?us-ascii?Q?rZb9e0M5i3Z3bloCANCx4dnwlYN9fSYnCIoIH6BdIAXR/cdAGytNc4+1HNSy?=
 =?us-ascii?Q?Bai2P8gCWlBXuMQ7NBYkMFbNTc1MEvwWmC1f1va8Mt14fykPG6lt4CBcvAXU?=
 =?us-ascii?Q?0mZkadpWK3mJXANX7Es0kuMB9qQ43YipmjR2dtUfLJEr6115tUnuTj3W3eWc?=
 =?us-ascii?Q?+//yGctrypLDYnc3dGjior3xLozAH/RjsybgR/qmfrR0oZAWCgLeBrrRKn9t?=
 =?us-ascii?Q?isbtKatvbGnck581jz9wsZ9VPCGIfyE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5399a1-76ca-4d24-0d72-08da2e5a4657
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:08.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fmrPO449OIa3RSs2Mv8tp0tfSI2RMBTWXDBGr3MvbkelmJuV2RNaGpiTy2HVAcL+Aihw40f9bkItbGd227o5uXcT/6ILGmjhfssHy4YmvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1257
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

When a callback is received to invalidate a neighbour entry
there is no need to try and populate any other flow information.
Only the flowX->daddr information is needed as lookup key to delete
an entry from the NFP neighbour table. Fix this by only doing the
lookup if the callback is for a new entry.

As part of this cleanup remove the setting of flow6.flowi6_proto, as
this is not needed either, it looks to be a possible leftover from a
previous implementation.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../netronome/nfp/flower/tunnel_conf.c        | 52 ++++++++++++-------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index f5e8ed14e517..0cb016afbab3 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -494,7 +494,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 	struct flowi6 flow6 = {};
 	struct neighbour *n;
 	struct nfp_app *app;
-	struct rtable *rt;
+	bool neigh_invalid;
 	bool ipv6 = false;
 	int err;
 
@@ -513,6 +513,8 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 	if (n->tbl->family == AF_INET6)
 		ipv6 = true;
 
+	neigh_invalid = !(n->nud_state & NUD_VALID) || n->dead;
+
 	if (ipv6)
 		flow6.daddr = *(struct in6_addr *)n->primary_key;
 	else
@@ -533,29 +535,41 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 #if IS_ENABLED(CONFIG_INET)
 	if (ipv6) {
 #if IS_ENABLED(CONFIG_IPV6)
-		struct dst_entry *dst;
-
-		dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(n->dev), NULL,
-						      &flow6, NULL);
-		if (IS_ERR(dst))
-			return NOTIFY_DONE;
-
-		dst_release(dst);
-		flow6.flowi6_proto = IPPROTO_UDP;
+		if (!neigh_invalid) {
+			struct dst_entry *dst;
+			/* Use ipv6_dst_lookup_flow to populate flow6->saddr
+			 * and other fields. This information is only needed
+			 * for new entries, lookup can be skipped when an entry
+			 * gets invalidated - as only the daddr is needed for
+			 * deleting.
+			 */
+			dst = ip6_dst_lookup_flow(dev_net(n->dev), NULL,
+						  &flow6, NULL);
+			if (IS_ERR(dst))
+				return NOTIFY_DONE;
+
+			dst_release(dst);
+		}
 		nfp_tun_write_neigh_v6(n->dev, app, &flow6, n, GFP_ATOMIC);
 #else
 		return NOTIFY_DONE;
 #endif /* CONFIG_IPV6 */
 	} else {
-		/* Do a route lookup to populate flow data. */
-		rt = ip_route_output_key(dev_net(n->dev), &flow4);
-		err = PTR_ERR_OR_ZERO(rt);
-		if (err)
-			return NOTIFY_DONE;
-
-		ip_rt_put(rt);
-
-		flow4.flowi4_proto = IPPROTO_UDP;
+		if (!neigh_invalid) {
+			struct rtable *rt;
+			/* Use ip_route_output_key to populate flow4->saddr and
+			 * other fields. This information is only needed for
+			 * new entries, lookup can be skipped when an entry
+			 * gets invalidated - as only the daddr is needed for
+			 * deleting.
+			 */
+			rt = ip_route_output_key(dev_net(n->dev), &flow4);
+			err = PTR_ERR_OR_ZERO(rt);
+			if (err)
+				return NOTIFY_DONE;
+
+			ip_rt_put(rt);
+		}
 		nfp_tun_write_neigh_v4(n->dev, app, &flow4, n, GFP_ATOMIC);
 	}
 #else
-- 
2.30.2

