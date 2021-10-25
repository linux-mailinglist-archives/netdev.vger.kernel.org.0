Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFE143A67F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhJYW1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:35 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233822AbhJYW12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5efSBIYJ+MOHolLVYFqkP41p1IqkmoBuxKNltg75MTCt6JVKM5IpaAW74IOTVjL78k0AsymAkb8bOVAONvHWAR1gfQ3JemZqCP5Q6TtRIkdHIRcFKwQ8bTDI3krMB8oaddtUvl8Lg+/AAZKiAFm6bOsg2cFvUeJuMznGV0lo7vCSbJ16KLTh2ulWnQbFF35aVdFC+rL/O4if/rIpBKWef3bG+DI/VLBfIQcxnVrT2Cvwb42yIy9g9NKoToAggXT0rB9LOWxZDsmQJZKYjcn4dqS807gwLNQynicurKIA2KOG7YAwWOAsBQJ6AmLnSTRJNcFaldAkRLFkUTNAEKIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIhTTPquZn2n1jMvyyVz08Yb1lL2fxKbdDNO14aCC1g=;
 b=ILZW50sisdU6M6erjKYSTBxTfSv8ATpJbFnd6qSglYA4Kjz5ErncccA2ludoEqZ4F0o2TZCoga6v4VKZIjuGXPnisbSM2mqdpZ9SWrGq972NAuVyfvTmNO84s982J0ekMK9sAsTTleZtCq/3wTGhONICJ+CtCTydBkvMcpK8Os2lE7sJH55WXvzJPNk95wnan9ICWj5GKKVRfAL2HLgCXFsttvIFOt7bxaCCaWxAbviORvFBLHuJv6SB4S4/5z/NKL67I4Bfg5g7+R9lY8RjZS04KmA/1yFnrNWUBfJ/kOjIms3GPKzznSVLFRNWWIp3OFvcMZR/q/NZi92pLhFAjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIhTTPquZn2n1jMvyyVz08Yb1lL2fxKbdDNO14aCC1g=;
 b=cfyeN/5Y2FfvBHBzMIGzqKM741JTd0Fp1XprvYK96CQlhWD4waPM/dAbZvF99IjndJv9JMQKvLr6Qe55PkaXjvPzBIa8c0ApxmotOLPQ+pdeAK1DuYkA1bKzoRHvdyn1HUwfnm6qMy7WNqwqDJFA67ds6d3AWjQlDC+/qsOGX7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 13/15] net: bridge: wait for errors from switchdev when deleting FDB entries
Date:   Tue, 26 Oct 2021 01:24:13 +0300
Message-Id: <20211025222415.983883-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b10ba654-5497-460b-2190-08d998063f71
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23044F6C959EC42D0B1C484BE0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drnsxU7k75ldXiy7B8D38kE3j+EAKVkfBgjolS7mW6oGWs5027t91jbuqK7qsREDn8gJqtmTr3j4nN/LN8rbczoZTAuB1lQ/nIIN/m8dwVtvJfmxM0Zn867Uxqo1cFSC9WKhEqOEuNDXfsA9wpx848VVjzvLu/yCdcWTKwZJo28A6tLzW0eiovvrNPR1Rb+r3vxaLb5DrMk1fcCt/nooxq0IqqoOJN74lDp6S2Hc2bsKL8OoBfkXVpT6+uZW0+SLddt7VzbxWqz+1x8stRwyxOtvPX8qrlbQasV96pqHRA/yG3cIfo9feH0F8lNsNoUZt8rE4OPMLp5LN23M1qB7Pu4E13VBoqVxDMOHH4LR+BXQXAbzbED8M4ndKyDyIjOWYDGE5iCj99Flugvr+YSnELKGI+cZ/cn7Tbl0Utfen6gB5Uxt0yUR8e5hVLODSgBeXNgtYqNycMhRD2YJl88w710SanrG6cM2TkPURcD7Uz+Yw8XBf6BW8D8RCKotljjQnI9kxDw3YuAkbVt+PnneM7BI+JhzDBccLMYPsE5iDZ+tIa4mbkux+EO52lZuSX47/HilIuuATgXUpJDMSaz1v/vXOBXcecmvR3LD87flnCrFhqr2Ls3kH0ijU2rg+d9JmuyINgOMWZrZLr/RT48tZqZEb324oWl0aeviKnKv8IJTfuLlCKrd/JnhgvEeRPU5JcJnHfKNF8ACn8yIn4Efjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqQD9uaIvJ2CLkffqiXnpUH5g77mlij+G/9xjX6e8fjijT7QoX82kJvb6K4t?=
 =?us-ascii?Q?et7ZmVNwYDxV3wr5Ku+e41gEcTjfXkk4LGuHfqciSpvAWqZI8ZqS/kd0oZ+6?=
 =?us-ascii?Q?kl6kQc1v4aqjcYU/ftfouJmFryA7atnvYsYdphThQBaTsXk7OUQFZET3r4UV?=
 =?us-ascii?Q?UAkCUIpYLQd5WHAX6i4diw5mS1oLPTYXKsMVplieZnk7Pq29OcB/LP4K8Huy?=
 =?us-ascii?Q?bEoRc4dfhSeOTLpQ2WvBdf9p4gvLzLRnrXEwCjGChi+Gs2g+uFLgY6pDfAwq?=
 =?us-ascii?Q?JjG/9HFHnbyh8cHcb43/X3mYa62anOsYweY6TFcKYjVGemRXHokrkVZdNZ/g?=
 =?us-ascii?Q?FKHOa2bW1Naa57IPPXBrKVuGjnk7MOcjouvIb3MP6uWfP14Zh/X51IQ9v8dJ?=
 =?us-ascii?Q?7bs6L25xsVbSRxkBRjHYKb6CNMxXjAz9qmlGPjf4R4uG7uVMvdx5Y/5qzpzG?=
 =?us-ascii?Q?DbV0Wuemob9RYbnH3KAaDm1OvFVzxjiuOqNAuEieEgUz+9V0TuL0yvzSA0W2?=
 =?us-ascii?Q?Gx66DtP9PafNsEwbaEt49TvTL+StMTjusMyOhbYZbBoqxNhZfDzk7ZO86H/F?=
 =?us-ascii?Q?f7vFypQ3fOzcYi47HxmoJIbXtECTm4R5ecIMu7vsFVNykAp1vFtctrTohwtP?=
 =?us-ascii?Q?dFar0JG8FN9Sr8nQFOnt+hI/GIfi/yozvcsohUhiTc5x2y/ItMwoshJDaenV?=
 =?us-ascii?Q?ARLeKuH4rAQuFhdOfXWAJv2UgmqCaG/CX39NjAjmVszepGzJNzyHa8VufG5/?=
 =?us-ascii?Q?eUiCBPk+Nvs0uvE1oOOuZMNjZWdZlLkO7kPWhsG5kH6fKFKIyRdlsKZDUV4d?=
 =?us-ascii?Q?+8zCHMGNBdQ9+LKqpt6VsS6vbxigofDnJGdC2+c8X5XxlGupbmOCuucIHSO/?=
 =?us-ascii?Q?WW72zRNAp/0UQRW6XV+gRn2EB7egFsX9vNIzKbsDow4R4JgO/wG0umyjUfSL?=
 =?us-ascii?Q?wQU8Y3INeQ2B51CjPOiP+nUPkDyDwG6Cv4x4z9DadgzxtVGODAJwP1d7Nv2s?=
 =?us-ascii?Q?ksoIz00eSCnKcYRTRn5GBkjPR99yC2TrO5McWM4GiUkKNpBHODp/G7/TmLKs?=
 =?us-ascii?Q?Jyvg1Sg5cNCbC+QQkCDx4ZeeTxhAE0bPrWzElm7oYfulVrYI0L2sSa4uAdsg?=
 =?us-ascii?Q?tKTlKIBOQUNgnshKR2PKd5HV3vIa+gNUVRLSOwak6NseleUUIt71LLpahNiF?=
 =?us-ascii?Q?K/nNMmoInKinzlAJ2xm7iHORKx0DPsM4v0YveO2OTjUnLhyksobXA/rJn72G?=
 =?us-ascii?Q?2seYNlKNuHdor/R4nqJoE/xVpgsorwBZwrq3qzcSGHmkDSEBhnqtZ42hRNO3?=
 =?us-ascii?Q?IzsmwI2JYjlmrPU7QqAX894TxbPPU3VrX5ygkaiw6/XqrftsXMwP1D4bQiFV?=
 =?us-ascii?Q?vbT+iu2ZkU1zBN0TE/pPGu04ykJgoLhXslIpmEFW48l0IdCSCpjYmql+kU/O?=
 =?us-ascii?Q?8V/Ia0O3f07C+ZYpP5ax2ASUtWaACbkYWfXpNBnNH08zTRTWulVUfN3lLcY+?=
 =?us-ascii?Q?SmOjSLaxyzHXXSWGCx2cnSdIKjBleYbqMhbIT+ST5vNFVmvH+T4VsfA0Nac+?=
 =?us-ascii?Q?8oY5d9WGq98p/Moh5vH5CPxOvLZ/JrJG3TkQGYVRXi0jAyRS6Zokfs9tKeFI?=
 =?us-ascii?Q?jZqpkngFNyT6F/1ZFS5bzN4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10ba654-5497-460b-2190-08d998063f71
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:45.2469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ivXhStrGd+56mo8mvzOba1XjBSXYnCBEFR38WsVI3SY/e+KdADdK4nWWPY6mVzpP2VtioPzgGJ8PdYs8c2SkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the logic added for RTM_NEWNEIGH, we can make the bridge
RTM_DELNEIGH handler let switchdev veto an FDB entry deletion.

The strategy is:

- get hold of the FDB entry under &br->hash_lock
- notify switchdev of its deletion via the atomic notifier chain
- release the &br->hash_lock, wait for the response
- switchdev vetoes => error out
- switchdev agrees => attempt to get hold again of the FDB entry under
  &br->hash_lock, this time delete it without notifying switchdev _or_
  rtnetlink (we've notified both already).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 82 ++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index ce49e5f914b1..5f9bef6e4472 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -407,7 +407,7 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
 }
 
 static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
-		       bool swdev_notify)
+		       bool notify_rtnl, bool swdev_notify)
 {
 	trace_fdb_delete(br, f);
 
@@ -417,7 +417,8 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 	hlist_del_init_rcu(&f->fdb_node);
 	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
 			       br_fdb_rht_params);
-	br_fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
+	if (notify_rtnl)
+		br_fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
 	call_rcu(&f->rcu, fdb_rcu_free);
 }
 
@@ -453,7 +454,7 @@ static void fdb_delete_local(struct net_bridge *br,
 		return;
 	}
 
-	fdb_delete(br, f, true);
+	fdb_delete(br, f, true, true);
 }
 
 void br_fdb_find_delete_local(struct net_bridge *br,
@@ -514,7 +515,7 @@ static int fdb_add_local(struct net_bridge *br, struct net_bridge_port *source,
 			return 0;
 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
 		       source ? source->dev->name : br->dev->name, addr, vid);
-		fdb_delete(br, fdb, true);
+		fdb_delete(br, fdb, true, true);
 	}
 
 	fdb = fdb_create(br, source, addr, vid,
@@ -639,7 +640,7 @@ void br_fdb_cleanup(struct work_struct *work)
 		} else {
 			spin_lock_bh(&br->hash_lock);
 			if (!hlist_unhashed(&f->fdb_node))
-				fdb_delete(br, f, true);
+				fdb_delete(br, f, true, true);
 			spin_unlock_bh(&br->hash_lock);
 		}
 	}
@@ -659,7 +660,7 @@ void br_fdb_flush(struct net_bridge *br)
 	spin_lock_bh(&br->hash_lock);
 	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
 		if (!test_bit(BR_FDB_STATIC, &f->flags))
-			fdb_delete(br, f, true);
+			fdb_delete(br, f, true, true);
 	}
 	spin_unlock_bh(&br->hash_lock);
 }
@@ -691,7 +692,7 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 		if (test_bit(BR_FDB_LOCAL, &f->flags))
 			fdb_delete_local(br, p, f);
 		else
-			fdb_delete(br, f, true);
+			fdb_delete(br, f, true, true);
 	}
 	spin_unlock_bh(&br->hash_lock);
 }
@@ -931,9 +932,10 @@ int br_fdb_get(struct sk_buff *skb,
 }
 
 /* Delete an FDB entry and don't notify switchdev */
-static void fdb_delete_by_addr_and_port(struct net_bridge *br,
-					const struct net_bridge_port *p,
-					const u8 *addr, u16 vlan)
+static int fdb_delete_by_addr_and_port(struct net_bridge *br,
+				       const struct net_bridge_port *p,
+				       const u8 *addr, u16 vlan,
+				       bool notify_rtnl)
 {
 	struct net_bridge_fdb_entry *fdb;
 
@@ -942,12 +944,14 @@ static void fdb_delete_by_addr_and_port(struct net_bridge *br,
 	fdb = br_fdb_find(br, addr, vlan);
 	if (!fdb || READ_ONCE(fdb->dst) != p) {
 		spin_unlock_bh(&br->hash_lock);
-		return;
+		return -ENOENT;
 	}
 
-	fdb_delete(br, fdb, false);
+	fdb_delete(br, fdb, notify_rtnl, false);
 
 	spin_unlock_bh(&br->hash_lock);
+
+	return 0;
 }
 
 /* returns true if the fdb is modified */
@@ -1079,7 +1083,7 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 
 	err = br_switchdev_fdb_wait(&wait_ctx);
 	if (err)
-		fdb_delete_by_addr_and_port(br, source, addr, vid);
+		fdb_delete_by_addr_and_port(br, source, addr, vid, true);
 
 	return err;
 }
@@ -1208,36 +1212,38 @@ int br_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	return err;
 }
 
-/* Delete an FDB entry and notify switchdev.
- * Caller must hold &br->hash_lock.
- */
-static int
-fdb_delete_by_addr_and_port_switchdev(struct net_bridge *br,
-				      const struct net_bridge_port *p,
-				      const u8 *addr, u16 vlan)
+/* Delete an FDB entry and notify switchdev. */
+static int __br_fdb_delete(struct net_bridge *br,
+			   const struct net_bridge_port *p,
+			   const u8 *addr, u16 vlan,
+			   struct netlink_ext_ack *extack)
 {
+	struct br_switchdev_fdb_wait_ctx wait_ctx;
 	struct net_bridge_fdb_entry *fdb;
+	int err;
 
-	fdb = br_fdb_find(br, addr, vlan);
-	if (!fdb || READ_ONCE(fdb->dst) != p)
-		return -ENOENT;
+	br_switchdev_fdb_wait_ctx_init(&wait_ctx);
 
-	fdb_delete(br, fdb, true);
+	spin_lock_bh(&br->hash_lock);
 
-	return 0;
-}
+	fdb = br_fdb_find(br, addr, vlan);
+	if (!fdb || READ_ONCE(fdb->dst) != p) {
+		spin_unlock_bh(&br->hash_lock);
+		return -ENOENT;
+	}
 
-static int __br_fdb_delete(struct net_bridge *br,
-			   const struct net_bridge_port *p,
-			   const unsigned char *addr, u16 vid)
-{
-	int err;
+	br_fdb_notify_async(br, fdb, RTM_DELNEIGH, extack, &wait_ctx);
 
-	spin_lock_bh(&br->hash_lock);
-	err = fdb_delete_by_addr_and_port_switchdev(br, p, addr, vid);
 	spin_unlock_bh(&br->hash_lock);
 
-	return err;
+	err = br_switchdev_fdb_wait(&wait_ctx);
+	if (err)
+		return err;
+
+	/* We've notified rtnl and switchdev once, don't do it again,
+	 * just delete.
+	 */
+	return fdb_delete_by_addr_and_port(br, p, addr, vlan, false);
 }
 
 /* Remove neighbor entry with RTM_DELNEIGH */
@@ -1273,17 +1279,17 @@ int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 			return -EINVAL;
 		}
 
-		err = __br_fdb_delete(br, p, addr, vid);
+		err = __br_fdb_delete(br, p, addr, vid, extack);
 	} else {
 		err = -ENOENT;
-		err &= __br_fdb_delete(br, p, addr, 0);
+		err &= __br_fdb_delete(br, p, addr, 0, extack);
 		if (!vg || !vg->num_vlans)
 			return err;
 
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			if (!br_vlan_should_use(v))
 				continue;
-			err &= __br_fdb_delete(br, p, addr, v->vid);
+			err &= __br_fdb_delete(br, p, addr, v->vid, extack);
 		}
 	}
 
@@ -1414,7 +1420,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 
 	fdb = br_fdb_find(br, addr, vid);
 	if (fdb && test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
-		fdb_delete(br, fdb, swdev_notify);
+		fdb_delete(br, fdb, true, swdev_notify);
 	else
 		err = -ENOENT;
 
-- 
2.25.1

