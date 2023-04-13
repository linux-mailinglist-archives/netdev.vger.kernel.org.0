Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292D86E0AE8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjDMJ74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjDMJ7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:47 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF6E7D85
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jH0bQHqujy2j0gXi54OFdTnUonoovA65TALoZehqreQYz3RbTd9Ru5KeML2WzdiZ4QKkpHEeCdBaJuWYMzNQ/5/wjU+tVPsMIE11FR4RFV1OERyzWl+MWx6xd0qiigcJNoCT4H11FBWDGbqnPIj4OUrtYp4lgt9jzlzWK7y92tUJ7R61wNJ3EsCj30dX4eTEqQTpYP4LZPFVDO+DVpD41nsBzyN3zy5QXVtjQ+cHXtwv7igECn1hIDyLAeJbM65Puh6T4S528l0jnRsbVPVbP1dkyXJJNPyet8oOKjmaQQANDodBpYfjgoHeTuDJP4kFDhfa0qkZyz7KAVzX3CaNXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lj90Ut8XMA486m20mHdynKT2IGXrETfyB0ICpCEDQgs=;
 b=nraWY0fNtT3cdD5JkKOqGMta7mr7qr0cVx4PJPtoqi/lcIxzvD9alW4TW4dn0YcosK4BSIXz9rnFC5eEkbVQBCFaPSsfWF+0pibVAwdzLkcpalbO+pex8Tg72IjXTPX/1IjLnsRpmqLI4fuyOxSL7EBax7orTtx1JU7TtFYJuEDXOLLfLkm0H8MFs/hWUACP8ZOxjd7gfQy6pPiPU4ewTNiwNRRhBADyva6DQLEsRK9gUkdORW70UyVeC8/nt/Y4qBU0kb915SbQjeIFUOnZ52vtUP7NIYmzvx8k9mrX6+3uGcSoP3CNS2XGKWNJyRDlFv795hJ9Yv6oMSgS4ncINw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj90Ut8XMA486m20mHdynKT2IGXrETfyB0ICpCEDQgs=;
 b=S+SbjFpFDAm/9468kA89irQBHOMWm3Ky9Gl+M+E0wdxI94r7iYKzzFGDYj/01xSodtzlwuWtS0aIj1oxdc31zH0fJTjRMnbyT5zdU1IK49409HrY/azsU/HrxgrUTFi0JsuUOqs1JD4cGLDCETjdhfN/VKmUX/Rq5NMaOcr3oCoXbvD419N2SeJE/F6kE5R+miQt/KYvNpsi6KJYPDMriXMhOS4m/2++opMG1LJuKmBAy3WTSjX9l/YW571kvo/mW31sXSQYs76JLE9492FvBclsfuUsFn+A7lGfuXy0/NYLL9rFgvm+X2BDPU0jb4SXXc7xlopxaME2M4TF+mDV6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 09:59:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 5/9] bridge: Encapsulate data path neighbor suppression logic
Date:   Thu, 13 Apr 2023 12:58:26 +0300
Message-Id: <20230413095830.2182382-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0243.eurprd07.prod.outlook.com
 (2603:10a6:802:58::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: 53116161-8d04-4401-c04c-08db3c05cbf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ePDOYFAkzwjwUoE+cKDB14W2+zM+fFik7jUmENkmEc3E5UrllaI+OWNCUQ0flzZWoIELETPNh/WH1vJgmj0r0nEr72ap95xV1r4WDM3UNquIvZZmMW/33UgiJ/aow0EemZ9zXp45fF1h1ULkqWBJU3j3NTBMR7U8NoleEPGJ0KC8iSEoG9s7WQ+HkNoPrSpVNLWzRPCZbSbsjKmbbxYrUcC6BTC57qenlPrwrk8NZckjJb40nwZnFTLn554sWhtK4krvb5N3lqjjgK0r0M//XI/HaR5JJUdcPnoz5Ibo8b+PR4jHK6jMG/eWDEEaWjKVvq1l5ewi6KgdD9EvQxZRXzF/RMz3zx7nj5+6qC9LIxCpA0u1WAt6PAmCZdtxQo3CVBddgYxfiIhCHO/2sKboHALHYfPMmizbRv/nQk6bGWgAKqQvYoJMiVAGxtzdJHctzfKpDFQGeA2lHQRSs2LHAUJ2p7PGbn60bdgQ0NovAVQlqeXVL586JPc11XPQMLyK+Mthi/l1ecDeejdHPDk5Uwz/0EWf7aTgTRPH0CdAvwUK5goBNLaNS9DBVdda7WDJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(1076003)(4326008)(66946007)(66476007)(66556008)(6506007)(6512007)(36756003)(107886003)(26005)(2906002)(6666004)(6486002)(2616005)(83380400001)(186003)(86362001)(5660300002)(8936002)(8676002)(38100700002)(478600001)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0JNTbkOoJlC6w7GeHl2WR2wt5WAjnVPca4QyipwXl0xUlu3PvTSGGQnFBrlU?=
 =?us-ascii?Q?MSyrobFZZarOWjbgV4pjjB6fhvWvwGhdraaxgmRfvxL+wAdRiQT0wf1RrP5d?=
 =?us-ascii?Q?FGhmN5QmZgxyfk/TIS6ajr+iP5kM7qUsEYzqMpEMwP2AFRPpw4dkzx9xKebO?=
 =?us-ascii?Q?ug0zcaD/k2zzCS626YkXGFv045a24fcAR4AjSxAPMSdmF9ct7hDZegE46o0l?=
 =?us-ascii?Q?dwvJ4x9q9S9jLuDpayY2sHkUqqLHWMDz/hhwnIKgy3oni23vn+4pWy8qcli3?=
 =?us-ascii?Q?56b+dLSN5ZI9hM4AZEH/FRbATm5zCERZz/fwCMiKjcQw+MvuXy1HMG7XxrYO?=
 =?us-ascii?Q?ky6QryHaVPxJPPU9PsSfd9EoFzOKZZdZvAD1EakLOcbQUGy9SSPUY7b4zr3C?=
 =?us-ascii?Q?/ZV5cyls4+p3NcFJcH4Ysp5MzpQAGqNPZIz0fTvcwkcrKqvD5w4+a4atkqj6?=
 =?us-ascii?Q?kbVb6l+Cy54M9Xkoh3TWueYMUwptuKeBravuNfG/WbfWSz+drmFzlf0G2s5G?=
 =?us-ascii?Q?yfmztmXjdiv1E9/S1vsoWQWKrzhfaGS9okj+IsLHALu2dd5dWwMuGK9Q5rMs?=
 =?us-ascii?Q?+d6yxDyXk1eQySobO4ABYEEuGh/NeQe3Tbx4lpeICz4p3Wnhq1o+/i6LknWQ?=
 =?us-ascii?Q?yS2ChY5nxAxWxxY5EEvbAXNtSF87trVsfaGEeS0W75Lnh08ZuvxIYVSSfHrO?=
 =?us-ascii?Q?MoKHQlDk9MsXBM/1cfauWgbXKar8uwJV+gK60qi50GtCejYPnsfiF6cqNZ/a?=
 =?us-ascii?Q?a5u2odnzdtfoThN3qMXGfqO4GMs+ujU8LAwfd7dWf3wwIdUxEm7MRPc8M9RU?=
 =?us-ascii?Q?D4SR7DbRZiuix9K2VEaTrgUWAzeDiMHO/MKrcPRJsBKL4MIpWHhtEaq4LTJW?=
 =?us-ascii?Q?YvzRDrNV5NK/HioaTTxDVK/NlqmdjACrf10bZvHZ4pJDB5xsoZNoEbNXHNnH?=
 =?us-ascii?Q?3fZnXMBuXteS58BBUP5sJItM0vMkwcr91VmozU3mSnjqBueTWE3sziNcyf6R?=
 =?us-ascii?Q?FPjX+27Y0AivbjpVGOOWUg4VwXxgPxqXrcGyxpMFDJtPmvKAIaASvBg8FPa0?=
 =?us-ascii?Q?g3dJMG4EaWmLgkVu9BnJSd4p1K3NWuSiu/Sn6AP3RU33DSOUZUfgwc8hSpa6?=
 =?us-ascii?Q?ZlBxkCRQkjGroZa3v9OKv3e+tiX4+ebTTfjMXOb6gA6VNENgj+KM8Blg7/bo?=
 =?us-ascii?Q?4aVuqXlIkWQRkWJLTps5e4DOLw4+rORjERMkgF7t3NFkEl8u/M/yEKDbvfN/?=
 =?us-ascii?Q?3eTfRCHmgq5PaaCJr6cQkiykky5eMUzW365dRi9FvQ0j+rPtoI/eZ1CpWwPa?=
 =?us-ascii?Q?AnoDOjozX541wS15nNyZKYWfuYXMN9LzOVtClfMxuS+5mv0jVQssYTHsyS2g?=
 =?us-ascii?Q?ENHabvXzE1nIGD3tXbws1Yp8sxXhYundEXg4tDbYTqd/OHcI1ZepUzkxlRRV?=
 =?us-ascii?Q?5Ta0WC0tzAEQ6D7ppMb1Nq43cVg5C73udZKUvBAz9YJji3tUXgr4LXmOsrAd?=
 =?us-ascii?Q?Z5CRlOgARqkjPXlM3sfGnvAiAODKTInvdeDfPz3rJ2Pl0010sre3nh+bbcOp?=
 =?us-ascii?Q?KAsFJ1Ee7ENAe15yX/chfywO4DM545T6WlITDLwf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53116161-8d04-4401-c04c-08db3c05cbf7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:39.8967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0HhlE0Z+DR8OkXgPAAvvPCkliKOX85Dai2YyewBL2mjvBwjN9uIadnZt3aRPGShMungWR4xKgIrbsL63H4zPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are various places in the bridge data path that check
whether neighbor suppression is enabled on a given bridge port.

As a preparation for per-{Port, VLAN} neighbor suppression, encapsulate
this logic in a function and pass the VLAN ID of the packet as an
argument.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_arp_nd_proxy.c | 15 ++++++++++-----
 net/bridge/br_forward.c      |  3 ++-
 net/bridge/br_private.h      |  1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index 016a25a9e444..16c3a1c5d0ae 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -158,7 +158,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 		return;
 
 	if (br_opt_get(br, BROPT_NEIGH_SUPPRESS_ENABLED)) {
-		if (p && (p->flags & BR_NEIGH_SUPPRESS))
+		if (br_is_neigh_suppress_enabled(p, vid))
 			return;
 		if (parp->ar_op != htons(ARPOP_RREQUEST) &&
 		    parp->ar_op != htons(ARPOP_RREPLY) &&
@@ -202,8 +202,8 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 			bool replied = false;
 
 			if ((p && (p->flags & BR_PROXYARP)) ||
-			    (f->dst && (f->dst->flags & (BR_PROXYARP_WIFI |
-							 BR_NEIGH_SUPPRESS)))) {
+			    (f->dst && (f->dst->flags & BR_PROXYARP_WIFI)) ||
+			    br_is_neigh_suppress_enabled(f->dst, vid)) {
 				if (!vid)
 					br_arp_send(br, p, skb->dev, sip, tip,
 						    sha, n->ha, sha, 0, 0);
@@ -407,7 +407,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 
 	BR_INPUT_SKB_CB(skb)->proxyarp_replied = 0;
 
-	if (p && (p->flags & BR_NEIGH_SUPPRESS))
+	if (br_is_neigh_suppress_enabled(p, vid))
 		return;
 
 	if (msg->icmph.icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT &&
@@ -461,7 +461,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 		if (f) {
 			bool replied = false;
 
-			if (f->dst && (f->dst->flags & BR_NEIGH_SUPPRESS)) {
+			if (br_is_neigh_suppress_enabled(f->dst, vid)) {
 				if (vid != 0)
 					br_nd_send(br, p, skb, n,
 						   skb->vlan_proto,
@@ -483,3 +483,8 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	}
 }
 #endif
+
+bool br_is_neigh_suppress_enabled(const struct net_bridge_port *p, u16 vid)
+{
+	return p && (p->flags & BR_NEIGH_SUPPRESS);
+}
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 94a8d757ae4e..57744704ff69 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -226,7 +226,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 		if (p->flags & BR_PROXYARP)
 			continue;
 		if (BR_INPUT_SKB_CB(skb)->proxyarp_replied &&
-		    (p->flags & (BR_PROXYARP_WIFI | BR_NEIGH_SUPPRESS)))
+		    ((p->flags & BR_PROXYARP_WIFI) ||
+		     br_is_neigh_suppress_enabled(p, vid)))
 			continue;
 
 		prev = maybe_deliver(prev, p, skb, local_orig);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b17fc821ecc8..2119729ded2b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2220,4 +2220,5 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
 struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *m);
+bool br_is_neigh_suppress_enabled(const struct net_bridge_port *p, u16 vid);
 #endif
-- 
2.37.3

