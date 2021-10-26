Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0EC43B409
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhJZOay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:54 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:38305
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235544AbhJZOaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mX2SOf6esdzQxSftKlAOxMncPFe7l6DpPiUez6CbzM2YYipQYw3Gf6pb6xLm/fjQCTW1S03HQv2DOOiCwm4gMxY94C/z3HUPMt7hYfUqsV7vFNrNEra3XikmAn3ghxK5kc/5Xkd6/UjQn5n7JcyUezTRdngi186s9rtsfBtZIRsJfFZa7cnu7BEOl9ASCJILGr0CbXrRkPbPJ5Y9oWj8IYWn6Rri04AN321fVOLUStInQRs6gZSbDI7rF0Aac+KXcYB0Wqr//em+wpljkpNIr0nICychO0W9BVPKeBcZwVR47ZijRAu0QgR4SV3GWgPLQIr0vMG4v5oORimoFr2sKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPwlspgT9hG+7iU7ABgF1KLEhTpYIPq7xYCKS0GYIQE=;
 b=hBwlJQxmpg4Cn5EPU+7WAXe4ma8u019sGm8ejMrEBB8elSN5Wo/VyGCIBV/D37yC4ibMTd+EaiUxbWygPV0XHITYdocn3Dbd9SRL9AQBHCj5/Qez7W5NnjDHfFpft2iWH2HVh+ms9wQdT+LDviXDAXnwpRUN2/VeMZburth87Gf97e2abUKuvGraabUMQNK1iGyoldDIDmnuQGk4UP08Aee/V1KaIIx01DdPT3OHYDQLo/pJO2Or2z/6iN00EF4zm28KcmD3pYKfTv9DEeh6Eh8uzPUiDtdPLAqvNVAyTgp4eBIpA+CaEP7AzqB2rN6C3eY763OZ/Ipx2De+JXTndA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPwlspgT9hG+7iU7ABgF1KLEhTpYIPq7xYCKS0GYIQE=;
 b=Pa1oGgoSRPDBX3XEZOpD5JugXxKoYe1Ee0cTQQwfD0rJyHNdeLMNVCzvSM5j+7oNpDYWsyfKBLLE/tzuClizVWioywVnTfOku3inrIwKIxic6zYm1gWJdbn3FAn7+83wVpOYuMso9tEzNjBgyq92HLk+V+lqzdMHeeXaMufartQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 14:28:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside br_switchdev.c
Date:   Tue, 26 Oct 2021 17:27:41 +0300
Message-Id: <20211026142743.1298877-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a87c0ec7-9b36-46ac-f21c-08d9988cd62d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39679D7F95BA6F922236F93DE0849@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBah1N3YovLXbZUnPvFStoYecHv+q1U4pJbSPTAMJ/2ke05jgpmGjkln4OA4ar92Dv6UbXVvVKWLg5IHBvCV04C+Dy6dXa7Ln3V+1jcYSyaDDi1ttEUcTae0mtLqRyzlScJj4SeexMhQmWyZ77PHohEYAnwQxDMjshinsQu9BFwxoJqjXXfIyse+VUKnxD+SHy+D5EN/1yRDbmG8kFn0NR8nYSRjMXZ6sy2uFqELI7IHw3R7sc7ZunOtws4c9ICNAjyMkmQyC0gaYgWEVgLRzYq49keMHHc2MGpcNt/M6F4eHqHxhxbEIz+jD3WaoEP2Jz+f4EmrOenbuI1Nng41e273lnIzx7sA+lRjy43dJRI0jFcukGFPg2EFTJsZmFVRqa5ylACIUpCvSJebOBvn+UbbqUMdJ4XlynCPbu+ayJOg3aM2dZK0QkIr5znr51BWHiGzNrxR4HzVySsfb12oJpBifmqk2/+eIksqSFXubqyZB7sMblr4KXPGWZMPOlEvGDyNmXi+hJhHNAWLuW51hviOTPdtdMbGwsTlNsm0U0+FE2mT3e0/ehjxYUypiTFTLVg3e3gR0Lvo6HOtlYevcUC6wxG9QnksSujPwxW+M/kZlTujqGkuDfffEu2/8GTwpH8qH8pay/VA/oxOaCNkGH0CjTkHRItqIy8FmthTA31ZgXKHPnI9smaPgeWwOF2j69Dc5Npr2VAyozabzlALAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(186003)(66556008)(83380400001)(8676002)(52116002)(6512007)(6916009)(66476007)(36756003)(508600001)(66946007)(2906002)(5660300002)(316002)(6506007)(6486002)(4326008)(44832011)(8936002)(26005)(38100700002)(38350700002)(54906003)(956004)(1076003)(86362001)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YFtTY3w2U9/LWlFBS8TK5TTpSVSqO8BP6f+mbldRXhxSwyjKx+tQjlOeH64C?=
 =?us-ascii?Q?g/oadOXKXVCRDglxayszQHVWYDh4/nUVPRoSQfyKNnJTa+QlBYh2wFHhNQ2u?=
 =?us-ascii?Q?Bvu5hoO2+0qAqeB/acS5oJD6FnZgnmo8bB/dH8YfY+ecDxv+z+TcMcUqPVNN?=
 =?us-ascii?Q?3Sz3A+9CbciV8lpWTa2O1mlVITBoj7uvzlECOxKtnRCfMGBoB9d0rpSKPSKG?=
 =?us-ascii?Q?/C6vywjLGe3Sy7CKctpuRwsqGlTSP3NPAoeIzFr5MuECX3QOfVAu4ncWmiO/?=
 =?us-ascii?Q?6DTxNtVL0zKVkUPOeknCEIiYRycM72pNb+HJ4PESlBaDcV9e3wHICi7D+ydf?=
 =?us-ascii?Q?Xbd5wx5Xg+Y+i3dHAGcJFtrehJyUNvgbXDFRcVCCyHX25AtxFiX3WNkSGaHv?=
 =?us-ascii?Q?Q2CkL/MJrI6V9g3f/9bUYNr1VT614PxlxQGaNWJQdub69j+90h/EqXMJhJw6?=
 =?us-ascii?Q?/igIb1V8PxjKlZcU08lpovCn7FsLskwMydRz1tSNAtsnsL8CG1rrvy2CfX3F?=
 =?us-ascii?Q?CPXN69Ze+ad4/ooaHFLDAitot/hv3GEoLNcQYyD188q3ACDz6H9sXGppC9Wq?=
 =?us-ascii?Q?7rQkGcMJqgYVx+/26RBFj5lQqBtgIowQ8kRnKX2CCQKfaVsMz7OphOlZbDmA?=
 =?us-ascii?Q?75E6eoABqrorD4KLER4cQmDFsbUs+ezC+F2xdQznO4JgxCFL++CXdLmFI/g9?=
 =?us-ascii?Q?tp7is0T+xx9O0J3T400b2GGoeBDyJB4O8kyVeIKvaPl4RXb8T903X4GkaeN2?=
 =?us-ascii?Q?Bh0ClossyuKuBvQUU2m9gEVLQo2z06gn8lohmuigtTwr+VLVsxUR+GNby+88?=
 =?us-ascii?Q?BHvJFB1u9avrL+Jccv8owi1knxiTXJbQ62yUC3ZW9k3FGKWNyFfqW1XE4ubC?=
 =?us-ascii?Q?N8xUcyvXgKFHx6FAru3S9EebjdPvTe49U72azdDm9NfvBg5NEYQ1gXacRWJ5?=
 =?us-ascii?Q?S+OFmZv4un9z2QHRlCC9cGDdU2YRbkERBcjTVIr9ZlVJ/GCSGtM9SQNag+Bp?=
 =?us-ascii?Q?DFYSs1K2g7ICS7esNcD/AT8qiyFGFhKCAGsP2VJS2eryFs9EBmJ5Fs+QYd1r?=
 =?us-ascii?Q?hLZWU8p0HbN5pDZkBzkqZdUrAXN5M33j76zWTBW6I0V+pALY82Eh6rHUu+4k?=
 =?us-ascii?Q?PaEjqL/MjDr9aH2vDwfg12g4asRfSZwym5QiRcxGjtQx2F87+KVNEvIcThzV?=
 =?us-ascii?Q?2QPAecoP9ahB5/zt0v/30Ecxh69IXSDCea3hfLn5DVoAvV7BKCqjSU1vYCAK?=
 =?us-ascii?Q?iRicN33sr3CsuZewWPB4ereSMmzMGZ1dNTOTwr5Ro3kbq5iiinOnU4hvvmbk?=
 =?us-ascii?Q?5Pog01u1WdDtbBBv/M5jpDHnayshwamnYQ7WnB8dcgciTnhh8Hwpwju92XYq?=
 =?us-ascii?Q?naA0Th8RvVkQraPFdiABnnyKq2rXJ3r61FtRzvO0wdivX1bW/ZB8+cs9jmQT?=
 =?us-ascii?Q?3bsQKFBLKnzsrl82pV0i8hryolSoMxb4h6J5JC+ugLb0qmUP1TRwKliDSObP?=
 =?us-ascii?Q?vDUfmHN0o1vgk72pdKXMqxQsTGQGCFwkA1AicSoFVZHT1opnolITWiNkykyi?=
 =?us-ascii?Q?U/QrNzP/N91kuE0z3kFDAw5DXzHKzZbf6eTkGp2jUHbJq944bpYTLqyGMjaL?=
 =?us-ascii?Q?9pDxxS1sXztyzu/O366oSOs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87c0ec7-9b36-46ac-f21c-08d9988cd62d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:10.7643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UlcOiw81CCg6aFc8kvqdaXvVGsFdGQPoyVuWQd1x67JcrGk8nA7HIu3k/wblmMFzoeFHXgGzMGLZGw+edr+djQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_fdb_replay is only called from switchdev code paths, so it makes
sense to be disabled if switchdev is not enabled in the first place.

As opposed to br_mdb_replay and br_vlan_replay which might be turned off
depending on bridge support for multicast and VLANs, FDB support is
always on. So moving br_mdb_replay and br_vlan_replay inside
br_switchdev.c would mean adding some #ifdef's in br_switchdev.c, so we
keep those where they are.

The reason for the movement is that in future changes there will be some
code reuse between br_switchdev_fdb_notify and br_fdb_replay.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       | 54 ---------------------------------------
 net/bridge/br_private.h   |  2 --
 net/bridge/br_switchdev.c | 54 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index f2b909aedabf..6ccda68bd473 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -759,60 +759,6 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 	}
 }
 
-static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
-			     const struct net_bridge_fdb_entry *fdb,
-			     unsigned long action, const void *ctx)
-{
-	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
-	struct switchdev_notifier_fdb_info item;
-	int err;
-
-	item.addr = fdb->key.addr.addr;
-	item.vid = fdb->key.vlan_id;
-	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
-	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
-	item.info.ctx = ctx;
-
-	err = nb->notifier_call(nb, action, &item);
-	return notifier_to_errno(err);
-}
-
-int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
-		  struct notifier_block *nb)
-{
-	struct net_bridge_fdb_entry *fdb;
-	struct net_bridge *br;
-	unsigned long action;
-	int err = 0;
-
-	if (!nb)
-		return 0;
-
-	if (!netif_is_bridge_master(br_dev))
-		return -EINVAL;
-
-	br = netdev_priv(br_dev);
-
-	if (adding)
-		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
-	else
-		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
-
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
-		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
-		if (err)
-			break;
-	}
-
-	rcu_read_unlock();
-
-	return err;
-}
-
 /* Dump information about entries, in response to GETNEIGH */
 int br_fdb_dump(struct sk_buff *skb,
 		struct netlink_callback *cb,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 705606fc2237..3c9327628060 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -792,8 +792,6 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      bool swdev_notify);
 void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 			  const unsigned char *addr, u16 vid, bool offloaded);
-int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
-		  struct notifier_block *nb);
 
 /* br_forward.c */
 enum br_pkt_type {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..8a45b1cfe06f 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -270,6 +270,60 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 	}
 }
 
+static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
+			     const struct net_bridge_fdb_entry *fdb,
+			     unsigned long action, const void *ctx)
+{
+	const struct net_bridge_port *p = READ_ONCE(fdb->dst);
+	struct switchdev_notifier_fdb_info item;
+	int err;
+
+	item.addr = fdb->key.addr.addr;
+	item.vid = fdb->key.vlan_id;
+	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
+	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
+	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
+	item.info.ctx = ctx;
+
+	err = nb->notifier_call(nb, action, &item);
+	return notifier_to_errno(err);
+}
+
+static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
+			 bool adding, struct notifier_block *nb)
+{
+	struct net_bridge_fdb_entry *fdb;
+	struct net_bridge *br;
+	unsigned long action;
+	int err = 0;
+
+	if (!nb)
+		return 0;
+
+	if (!netif_is_bridge_master(br_dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (adding)
+		action = SWITCHDEV_FDB_ADD_TO_DEVICE;
+	else
+		action = SWITCHDEV_FDB_DEL_TO_DEVICE;
+
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		err = br_fdb_replay_one(br, nb, fdb, action, ctx);
+		if (err)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
-- 
2.25.1

