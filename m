Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27E243B403
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbhJZOap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:45 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:8192
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233064AbhJZOac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INfrtUxx63vGLbaCh+S+wcIvW0jzuWYbnplyr/N4cb5mJjjN/jXXWjii/x8CX+MIVSqfqCAmBNHRgu9alZPaFeIorxyG2p98Q2KKn4soEJpE33ANx8GonQlfQR6udZWsIYDshutouX+Ck5ZuQAuLG5dbA3Owu9W0kUDmqEAFtYkwEZAayBOseHjqAeYKDGlPRRc+rty0Jhs55Cgp2OrOYn20NVYiCyGr39jbTEmk0Hy0EibwgP2rtQRw/tC7n0TsBZB72+sy04qe9ZzqyLqZRa4wCYgBdu6GsM2RCTz0TtL+zBoKA7Xset80XdEPZwb+d4FAwSEXCsurAqjEPJ1uvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl6NFlOZylOMSyRzFqubwwJcxnNpP5SGFxjzOKXyVWk=;
 b=Fz5CywWba6PbJV9/xW2GD0Bg4GRTZR8CIg6/PHDSWYLk9Uf+G50TeAQ+4UTJ/K8ZlKHiWEi4SrW5gM45AlLNTlltbyZDT4bD5DwHezuoD9XT/DtNEDcNLtREE7Sk35XfE7i7y87Lgzd6Up/4K38gL+SK1KJNtyleLKEWeXnODLHMgf3mWvAX6KZVrDV6r7AsdjBYY2p6yrjnDDDoSjEXUiTcKxlspMoLJHL7ewJZ47FWCeVbzOVq4dPhSyfYegT2U5nHJYloYWOouO4ITL+K3WgO4Upc0G/Hw52xr77gPFwfi+de7ORiSonU9qaSek1gFfO6gColj9FJiSn5CyQv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl6NFlOZylOMSyRzFqubwwJcxnNpP5SGFxjzOKXyVWk=;
 b=jmoXetN6ymnqQ7Tu/SUDjFLXCrZfy0AbVWHC8pW/8z6x3HIS2+b+VqE+YAFbus/Jmt/o0ddldbbtElszde2kwzZnZQfVrKgZRRb/zV2+3r2zdLqk4VWKf2GBqrhwLbuYl8l5puzCx6Wmudt3ZJDAsTA89NDwv9VQpGawD+5x0GY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 14:28:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:06 +0000
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
Subject: [PATCH net-next 2/8] net: bridge: remove fdb_insert forward declaration
Date:   Tue, 26 Oct 2021 17:27:37 +0300
Message-Id: <20211026142743.1298877-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5fcaff-0f29-464f-178b-08d9988cd364
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60160A109A163251E31F0F71E0849@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:215;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rILt96GRXAp2/g5s/ox0Y+xh4cOrDf4pL5BM4srxQUUXK+J57v6zvsv58AkqhzsMaKz/Yi1UbVg73SOa5QX+1jwLLsdb53lGT8S9AWBxJFFaKzSgI1lCKhw0Xw22JQkO74EiHlmSgJzLGHFHbUT+u9W70lqtxVT4hckD9r4veCnuAWyQRVjNbnk4XiSjRHcwMOnGE/S7b4iMhPK9q0sRgbdvSok+XYaFvr78O+X09Gq6uL2cdjDB29z0nsEZgU0g2ed3zBd6isddppfNq+of0KX3DJsHI0Xqxp7S41meTVaSbSr387Atqj38HeGXZWPBh6Hy//e4i1U8CD9FbyNwO78IgvjMuP8RDCNXubGhDq4W+kX+lcVadH9iTmbkVNQSBAMYxEjewu+KtFRWhjRXQZFPLg05LLx/o2wPF7v9xIXrQbGUtL2cYv8FQNzxfISkHbcPWe2Valvbxc2JRQeXXUiwdcK0FZBuoEqJqt+j2dQRxWY7oh/nET7+JA0KsXkxvGtrvKIson+a55eUUNrSHA8Pi01hjDHcdtS06rdf/RlGdgKgvEvl6PFdPOIjABaF/0lue/9UtyIEPb4coVQWZPBFYO5JAEUgtNczyLrbMwyB9OoUj/6+1+8P4mrmikm5a/bjDUxtvFYJO+aE0Sb+pmFOtZ9+BrNhZCXSLXamuYJgdT5KQ07lzNDuSY19p2+nkamBe6TKlefNAQD1lJjqrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52116002)(44832011)(66476007)(26005)(38100700002)(54906003)(8676002)(86362001)(5660300002)(2616005)(38350700002)(7416002)(6486002)(6506007)(6666004)(66556008)(316002)(6512007)(956004)(6916009)(36756003)(83380400001)(66946007)(2906002)(186003)(8936002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RpSGd8FS9WMC58GwMGhkHKBEns3g2Y///xFXyl2LGTNp+uzr/NV0GM6nGfQD?=
 =?us-ascii?Q?zaTnVLy73/O4YIT46Zh8l5CJgeiY9LqQvcIWCoL4G8M4OFPKWa0UGNEKHDmX?=
 =?us-ascii?Q?mD1Emuvk96LT12hvM19kYzJCv7RKOpHFa2abpToP3I1eZz1KhcryIScwq5ph?=
 =?us-ascii?Q?VxOBcivIlD0s3skupM/l0Wk/gocQ8qLm/5oMe/vChqQN2TrQMr8Z5QbubkYc?=
 =?us-ascii?Q?XcAkT2jGMIg6O/3HuTvUN24ocYxpTXnbpSJ5Cg73ErNaH10dnotua3ZUSwTb?=
 =?us-ascii?Q?bw+bTbJsFaG5X/Mm0j24y/lMBr0qk+xJXAdajFIcx+WsgFziX6IgDWMhquoc?=
 =?us-ascii?Q?ti3mWoAs+8On+VUAQDizjYUL3y8ToO0J3NAShIbFKn91VND+HeZdpWAZ5hn8?=
 =?us-ascii?Q?Z2aERnR2jjQJHxl2Q4EfmkSpBHqvXU/G6aoIezUonm48rgdE4F2fXjTFqPEw?=
 =?us-ascii?Q?cIdids2z3lALMCVnDOPEYizyJWvUUmjvWZOBVdmaS5b7nTOez6Lwwync1g9a?=
 =?us-ascii?Q?LG0cWWaBlGaHTbzHC6lLBGynFx/G7ysp5KqfdErTTh4lhLyfqFn1EjGak2/Q?=
 =?us-ascii?Q?Jyss+L4T3F+iZlrJVGWhaeMmSRPipJ5B7R4fOey1iBP+9u2/WJ//1/+m/WbB?=
 =?us-ascii?Q?5/hubHTum/OGXCodsxaX9pRFYadPs96/xfcqgOuNnAwgPSzWPqCVDUYNG5P3?=
 =?us-ascii?Q?Ah3DbYz0ouZkDZel8Wu4zjzi0xFx3o49gwWoGunzfot+/0pcq5bccKSLT72s?=
 =?us-ascii?Q?or3t4LwACGyNtfmT+jHyG2vIc5H9yQ4l22vwSbR3j3fhF7+rbneCtlKi0rIM?=
 =?us-ascii?Q?25mm9M1xJBvsMReO7qT4RX27IBRVU3PVs/a1pjtRhKIQaGhOmj4j/4GuSOsS?=
 =?us-ascii?Q?hjhea0HaQo7Dawazy219iwpH6PMSHpqUGvKR9hDmsDbAqbKqvan3NV0swYKz?=
 =?us-ascii?Q?pmwl0DbYVYDUrS41r6jbIG9xPrSbUWTmAh/v1P7hxD6mgHIEEoR2PPnORpNa?=
 =?us-ascii?Q?r76EDyVkGHWrA/dGibhtfAGnHFi4fjvImFycRm8+YeKL+8QEf8umFinmxlIf?=
 =?us-ascii?Q?0u88rcfTeyiTQQvDEdKNR80NHeATnVJORb/VYXTwhGbPp9vcC3RAC13jT9GV?=
 =?us-ascii?Q?HD71PJ1b+sunUSXoJJMxQRQyxRgVyb3GXjsiw5OgfiijeVMPuSvL3VrQdiS4?=
 =?us-ascii?Q?wcTg0Zs2bi8o+5BoUJx0D/OlmdW8KgNjqkyNwh3mMnm7L9i3322KgkOn6Guw?=
 =?us-ascii?Q?l2YoLozjDlVje0xVakJAQum3TeTUM0ieFgaV8+ZIVSEuF6EnqZXHeq6VMGG3?=
 =?us-ascii?Q?tfrN/myu1zbbo6f09eOhHEKJaJ3Zy8Uhh27x00ZxeZ3MTskNiv3ofON7dQsi?=
 =?us-ascii?Q?s1Z/DAh9Mj+G2wpUxwL6z5PVZPYcgOlwuiX6iE6vgSmHA4V81ECclhobgjcn?=
 =?us-ascii?Q?XMTtxqmXuTu35DEC6IdmkfjJ0Vmzbzb53yHKGz5AZqEvljhPGE61TKhspJRN?=
 =?us-ascii?Q?CPrOXCbp/SMYN1NvW4qH+bAd769qf/B/E5GRmsCQRLjUcFDKr+ZBUi4Fi31c?=
 =?us-ascii?Q?u83vl0SMuFMxLO2DDb0Vq2bXb4ESvHRbyTAblaF3k2SlyQtPlhb9uSWeePGE?=
 =?us-ascii?Q?F3ZyJVmOPGgUvqLq9DAnMDM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5fcaff-0f29-464f-178b-08d9988cd364
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:06.0430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0hovtFmPFoNyQ6vAv0oerQk1OFjh8zVm37WoaEnXbSS4JGQYHoLLrFZvwovSXuiYaJRvg1hB41f6fAu8iBWAnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fdb_insert() has a forward declaration because its first caller,
br_fdb_changeaddr(), is declared before fdb_create(), a function which
fdb_insert() needs.

This patch moves the 2 functions above br_fdb_changeaddr() and deletes
the forward declaration for fdb_insert().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 116 ++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 59 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index bfb28a24ea81..082e91130677 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -32,8 +32,6 @@ static const struct rhashtable_params br_fdb_rht_params = {
 };
 
 static struct kmem_cache *br_fdb_cache __read_mostly;
-static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		      const unsigned char *addr, u16 vid);
 
 int __init br_fdb_init(void)
 {
@@ -377,6 +375,63 @@ void br_fdb_find_delete_local(struct net_bridge *br,
 	spin_unlock_bh(&br->hash_lock);
 }
 
+static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
+					       struct net_bridge_port *source,
+					       const unsigned char *addr,
+					       __u16 vid,
+					       unsigned long flags)
+{
+	struct net_bridge_fdb_entry *fdb;
+
+	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
+	if (fdb) {
+		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
+		WRITE_ONCE(fdb->dst, source);
+		fdb->key.vlan_id = vid;
+		fdb->flags = flags;
+		fdb->updated = fdb->used = jiffies;
+		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
+						  &fdb->rhnode,
+						  br_fdb_rht_params)) {
+			kmem_cache_free(br_fdb_cache, fdb);
+			fdb = NULL;
+		} else {
+			hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
+		}
+	}
+	return fdb;
+}
+
+static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
+		      const unsigned char *addr, u16 vid)
+{
+	struct net_bridge_fdb_entry *fdb;
+
+	if (!is_valid_ether_addr(addr))
+		return -EINVAL;
+
+	fdb = br_fdb_find(br, addr, vid);
+	if (fdb) {
+		/* it is okay to have multiple ports with same
+		 * address, just use the first one.
+		 */
+		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
+			return 0;
+		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
+			source ? source->dev->name : br->dev->name, addr, vid);
+		fdb_delete(br, fdb, true);
+	}
+
+	fdb = fdb_create(br, source, addr, vid,
+			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
+	if (!fdb)
+		return -ENOMEM;
+
+	fdb_add_hw_addr(br, addr);
+	fdb_notify(br, fdb, RTM_NEWNEIGH, true);
+	return 0;
+}
+
 void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 {
 	struct net_bridge_vlan_group *vg;
@@ -623,63 +678,6 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 	return num;
 }
 
-static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
-					       struct net_bridge_port *source,
-					       const unsigned char *addr,
-					       __u16 vid,
-					       unsigned long flags)
-{
-	struct net_bridge_fdb_entry *fdb;
-
-	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
-	if (fdb) {
-		memcpy(fdb->key.addr.addr, addr, ETH_ALEN);
-		WRITE_ONCE(fdb->dst, source);
-		fdb->key.vlan_id = vid;
-		fdb->flags = flags;
-		fdb->updated = fdb->used = jiffies;
-		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
-						  &fdb->rhnode,
-						  br_fdb_rht_params)) {
-			kmem_cache_free(br_fdb_cache, fdb);
-			fdb = NULL;
-		} else {
-			hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
-		}
-	}
-	return fdb;
-}
-
-static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		  const unsigned char *addr, u16 vid)
-{
-	struct net_bridge_fdb_entry *fdb;
-
-	if (!is_valid_ether_addr(addr))
-		return -EINVAL;
-
-	fdb = br_fdb_find(br, addr, vid);
-	if (fdb) {
-		/* it is okay to have multiple ports with same
-		 * address, just use the first one.
-		 */
-		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
-			return 0;
-		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
-		       source ? source->dev->name : br->dev->name, addr, vid);
-		fdb_delete(br, fdb, true);
-	}
-
-	fdb = fdb_create(br, source, addr, vid,
-			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
-	if (!fdb)
-		return -ENOMEM;
-
-	fdb_add_hw_addr(br, addr);
-	fdb_notify(br, fdb, RTM_NEWNEIGH, true);
-	return 0;
-}
-
 /* Add entry for local address of interface */
 int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 		  const unsigned char *addr, u16 vid)
-- 
2.25.1

