Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26D96E0AE0
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjDMJ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjDMJ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94708A6A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9gqerH4lJIqHXe4zJWkjssCpsQHrSZzVRV7HejFaj1lY2PDI+e0PIK9itCF4EY5gwoBgG5Qg2VkZrMNm4NiF/Gdb9nF/9BytC2SZ5yNqIeyQXIWmaVKU0w6k0idmMcfVFfkFvgzG3cRpBez5A6r/DOVUU+FoXYTqTjFFFUm67HKrn7fvClV2Yvo6ZraZHzKU+me0zq47JFt4Q+nN0xuvKA9+8fhljRzaUENnWtY/mPiWowkRDxMCdSTSg+oLtvzFCojuJjvG8LtrBuLWPFiBfkyYquJUgLQeK9RsuBkmJQddgPyP1aNbt/mR7M8MUDb6jhQJ/NA6fYTYGuTTk99og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvfuZz2RtcNsOMIxkmeqAAvj9pMe3FQETaJUeG4BNv4=;
 b=dxa7iXuM6Td/R1ktJfsJi7jL+tZkYOvsaYZad/7mq9c9Yxe10JwwN3pweO8tFIQarLoVC7VA0UZWFkEy9V2zKuHpSmVqpkRWlTcstzhAZGxYAVyvoHB8yoA5dwgUZtNJP5G2Lg91jT5j68329uH8dxrCASuG873jAbhkMI1K38VJ8jNo2T3j3o864AqKR027lTR1VyIAdcBkwTh1cpQe1znOLMc+8bEoT6/BJ89hdRFtYWW1tN//PyJ/pDYX/DmkAbkE33x6mZW6twOe2AuGhKWKxqsfzUWwmuORiudvilSOVYmRFSMveLkYn9vamWyIG9C3wiTrHxZIcEhaEzjekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvfuZz2RtcNsOMIxkmeqAAvj9pMe3FQETaJUeG4BNv4=;
 b=TJPdct3OCrsuuE0aHPNa2+Zbo3xj0IGgxqTP+XnNTpKjz8XoEHoOq4IaiWDRxRguSN34pk2xHstoG0+2GBRRAiC84qcfcWhcLA+ZWkdLYtO3AEhH6hhkDEwqwz/vq3ftbOug15hYaMtix4nRLfWpTqC567nvxnXvIX8q0bM/xaFS6x9hAFtOqfAdMxE/3/qLidQhGvFV0zol2RdGY2YqgFn1N+KLCfrG/NDoLk7t7649ddNczF5iLa0T4zG77cIJqywV83hNyFGzNCham1ZjI6yxdSRVW9QM1ofPZk1/zNH+b377lhdwgWf+dy8fTg33Xyt/iBvLMn7yQ3OdtAnrgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW6PR12MB7070.namprd12.prod.outlook.com (2603:10b6:303:238::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 09:59:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/9] bridge: Pass VLAN ID to br_flood()
Date:   Thu, 13 Apr 2023 12:58:23 +0300
Message-Id: <20230413095830.2182382-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0170.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::9)
 To CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW6PR12MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: badd7c99-5be0-4b15-4838-08db3c05bf4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGczfbI4r4AOC+tcwVXKmp/6aUe5mCnK8IfR+tnrm9sllkLHj3897chXwisL1vJi41KhP//0me4flDQtLviF0P8H0n+Hta16yb+MS50WV3p1B4nI/VjieR3tVUzwsDhed0KfLZQdopsb8OUw+Y/ZrNdbEbXn7etOG9WK2CCGGK9MMu6+q1N6yp0xnXGCSNFsplCrwq1qrYlCILYq0Oti1SsaoRpUmKxX7Fi/JcC71cecPgPwwvoNy6a1Tpf7jC1kMHDZmjI4XJMKRU+QzMy746iiBRWlpKaHmPUGWME0+ZzMQeqhbRZyzMpyPYDgbNYoUHs6v9geftz6DJ4RcXpAtl4qQ7CxQhp/F4LtinodIbF+Uvbge9EtY+bwlQPaGRegaVW2a95f8TcFy/ag11mq8K0Fk1QHNlJEH7D2BfOfsd9d4XtfTRv8VgiipgXNW+GuJpe3+qxVRhhUd8aVwsn+Oabpa5RxLPAJ3Sg60rdxi63wLzjsZ/C2TwZIIF7dvhE7RRSTQR8n7BzeqS60n7dXGiB5JIJ87jZJXQ7ubyExqUgJfkLzrHEifvOBUb0MPcOX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199021)(36756003)(2906002)(26005)(478600001)(8936002)(38100700002)(2616005)(6486002)(1076003)(6512007)(6506007)(83380400001)(186003)(5660300002)(86362001)(66476007)(4326008)(66946007)(8676002)(66556008)(316002)(107886003)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R59AqoyKWHfoMu9XH5OMwpBCmuXWPXwfztPxAhnFHUEkaUfSyZt/J4kuSNHc?=
 =?us-ascii?Q?SylhD++k5OxBqUpTObdXeBDmA8x9PT5tQnk2u/8UWpgkvlSg6FoIHgYxg5Vq?=
 =?us-ascii?Q?g5hu67LIGDB3cSb8LsQsLeswQ7CMd5xsNEkyCdHTQxqi/puPJuQAaO4oR4Af?=
 =?us-ascii?Q?yAgHmSzgcWFoXYpyWxcJx9pWpcBJqempHB9RJBZm8C2m4OAe9M10IbhJ8BDm?=
 =?us-ascii?Q?EqNEqMa1JJbhKYnvkvGGrxL/ImC1FBtiCFQYI4FB8Cdmk9SamwKZZGkBS2vm?=
 =?us-ascii?Q?/EejQsn0QMMn3UFc+Mgm77H1lbVB1Zifc4LFP/B8K2ZVDi/4k4tE7ofXHDGf?=
 =?us-ascii?Q?tsVcpUgl2DlVG4umripQyAj5TRFum6D7fdC3QmR4kxdROfnHlj4RCb+UVlVI?=
 =?us-ascii?Q?8Hu7nQdlPuRtqYyzgV1yqgpt5JfjC0Ffgi61ZX3CwLm3wquO/5nj7qlGw32i?=
 =?us-ascii?Q?xD2KcJEkNstXWKPehSw4Ye0sKPrxjBdjDIimTrL+/TrfWhd35Nmjpr+7QmHt?=
 =?us-ascii?Q?HdTPkE3WySHco/m0Yizkp7npSPe6Szb2GHFzP0ZwNQRzKRpGiQxj4J2w9jLF?=
 =?us-ascii?Q?Rz9WWzppwRbfjquW+iwetFU2DQv91uK4/ypKd5n+a3Bx+Av8I9Zd0a8Uc+ni?=
 =?us-ascii?Q?2w9WuKu5PSqqlJh32KrcTjDyy2BhZnL2M8dFNvHKS85rty/uF5IwUJWEXMXs?=
 =?us-ascii?Q?Pky7rIIMJY1TSh1PpqI4cuCGdbVfQuQwprvDqes2rG4UwOTnHAassg9Dlmuq?=
 =?us-ascii?Q?zrEJ9Xbt1JztYgXma319+x2TKEBM94+vyKvYiuv4TEQmZUC6vC/fhdRVw/29?=
 =?us-ascii?Q?19fR8W1aJ99luXQWYaroXPXmOUCZ7/zNREgV3GnJTtAAmhsjHqrgz/ISHurv?=
 =?us-ascii?Q?IFtJpFrHJjPhB84OWmYL7fLIkEbTPHrFERn2LN4FiHqEdTIbTA8YZnMiKxPe?=
 =?us-ascii?Q?4mdoNfCF7yRiKRBJKCiXpl8uNWbW6n66GUt5KUQ3cuetHqyc3PgHZ5+TD4HU?=
 =?us-ascii?Q?pVyFYhj58WnlASckop1DKJxeVxA2e0cTdbeylH5Y4cgdxT3+0F3NkkKUtnU6?=
 =?us-ascii?Q?cZVgJDrzXePk/K203KaDUJBSurXDz2rEVsUzH178VVofxoo4sxC27nXGlXA+?=
 =?us-ascii?Q?REiM2aAWX8FFETBTKOC7aXDE3Oba59JFzlNwVtfOMJ/DP16fSmpuQqfw9Ibx?=
 =?us-ascii?Q?1BpqcEnSHly2UAI09pO69jPYsMuFfZuJj4ECSnuyWKQEUPfmhrUYxuyy3XpY?=
 =?us-ascii?Q?1uatzDyvhRyFVSFw4L3CoQ9In6OyBhBnuJPCzUg5mwsHO50/CnU7gZ5+JIyb?=
 =?us-ascii?Q?POSB6OpQZvEUVLmzJIMtDbIPL93AX/QbefvyYJEbziH2xNQ7oUa4+SmBAIw4?=
 =?us-ascii?Q?xfug3TeSowwjM1iizd3CXMjWisGaN1A/NswSGLSXhpmE+Ma/TyqKZv+MlE8Q?=
 =?us-ascii?Q?xjl0DdRhfFE3UQaKhiY6HB2yxjHN8qmJ6nr7VvEO/Qqk8L7F2gRC7JnOqe8D?=
 =?us-ascii?Q?vXo31h0YFPM90kZtt6QN1GsulYXp6Bicl7ffyJoVhDP4EfQXY6APklySmjQ5?=
 =?us-ascii?Q?2xIZBhnwhgfCJpGQrodjex2HO2lHUPE4IACGlCU4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: badd7c99-5be0-4b15-4838-08db3c05bf4b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:18.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UU49rsAP/HIDuvy0YUp6LFUgLbq74qkgMvAFZo2soPW1rU/Znvsb/GJl26/B9gOIqdJ6Yeyj5+P2/ZV+Rxj8oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7070
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patches are going to add per-{Port, VLAN} neighbor
suppression, which will require br_flood() to potentially suppress ARP /
NS packets on a per-{Port, VLAN} basis.

As a preparation, pass the VLAN ID of the packet as another argument to
br_flood().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_device.c  | 8 ++++----
 net/bridge/br_forward.c | 3 ++-
 net/bridge/br_input.c   | 2 +-
 net/bridge/br_private.h | 3 ++-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index df47c876230e..8eca8a5c80c6 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -80,10 +80,10 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dest = eth_hdr(skb)->h_dest;
 	if (is_broadcast_ether_addr(dest)) {
-		br_flood(br, skb, BR_PKT_BROADCAST, false, true);
+		br_flood(br, skb, BR_PKT_BROADCAST, false, true, vid);
 	} else if (is_multicast_ether_addr(dest)) {
 		if (unlikely(netpoll_tx_running(dev))) {
-			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
+			br_flood(br, skb, BR_PKT_MULTICAST, false, true, vid);
 			goto out;
 		}
 		if (br_multicast_rcv(&brmctx, &pmctx_null, vlan, skb, vid)) {
@@ -96,11 +96,11 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		    br_multicast_querier_exists(brmctx, eth_hdr(skb), mdst))
 			br_multicast_flood(mdst, skb, brmctx, false, true);
 		else
-			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
+			br_flood(br, skb, BR_PKT_MULTICAST, false, true, vid);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
 		br_forward(dst->dst, skb, false, true);
 	} else {
-		br_flood(br, skb, BR_PKT_UNICAST, false, true);
+		br_flood(br, skb, BR_PKT_UNICAST, false, true, vid);
 	}
 out:
 	rcu_read_unlock();
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 0fe133fa214c..94a8d757ae4e 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -197,7 +197,8 @@ static struct net_bridge_port *maybe_deliver(
 
 /* called under rcu_read_lock */
 void br_flood(struct net_bridge *br, struct sk_buff *skb,
-	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig)
+	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig,
+	      u16 vid)
 {
 	struct net_bridge_port *prev = NULL;
 	struct net_bridge_port *p;
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 3027e8f6be15..fc17b9fd93e6 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -207,7 +207,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		br_forward(dst->dst, skb, local_rcv, false);
 	} else {
 		if (!mcast_hit)
-			br_flood(br, skb, pkt_type, local_rcv, false);
+			br_flood(br, skb, pkt_type, local_rcv, false, vid);
 		else
 			br_multicast_flood(mdst, skb, brmctx, local_rcv, false);
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7264fd40f82f..1ff4d64ab584 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -849,7 +849,8 @@ void br_forward(const struct net_bridge_port *to, struct sk_buff *skb,
 		bool local_rcv, bool local_orig);
 int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 void br_flood(struct net_bridge *br, struct sk_buff *skb,
-	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig);
+	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig,
+	      u16 vid);
 
 /* return true if both source port and dest port are isolated */
 static inline bool br_skb_isolated(const struct net_bridge_port *to,
-- 
2.37.3

