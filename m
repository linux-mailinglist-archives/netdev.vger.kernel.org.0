Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B0743B405
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbhJZOav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:51 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:8192
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236545AbhJZOal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2fNsiKtiuGBAYBaU7nMkmR9O4wcfbc8MQfnYdgbC0gt7+Kzdh6cCXQrjkJnrg9bhCwSwj1g1Jdv10DruEDYjt/g4xhtTPnbOhQVk0MOnDm25bnYI5qN9gXXYDdtzetcYJl3ey0IXkPsGBYPMWUxcPC4GupvN0XJMinR1iaffe+47+uby5odM5lH/kX8mfHvKFMY7N6gnWy1hPo8E3npakexpVbkglI785mepvqJ0yHY+PtzFL7sCpR0GlucaC2ybmhPTo+obO3xSoB2TVKNhfpTbo8a06RXu0lDmCHxIb3wg41i3Ffb32eAoVp4OUjwlWVnfQhKcugBqtnghgExIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxKlFG+diSVZsLPFy/Qsy4Wje25azOa8dx6nLBc2jtY=;
 b=JGL2tgUsVpMAnS4SaCOgdqNdlYVV936spQzc7oHFC0ORBLDkXlIKQs9cOT9yU/ZbdpZcfn40Nl+StWwGEuj+8lhmUAYV/WjQtYLusaOyVVPRcj+2yUB80Sia6oXgtwFPn00V2PCByd/cap5kTrhreMG1LikXcGKvDnA2q1VXMa25XtNPdD6B5M3BrXsGHdj/3LWREmFC+4k80N5kmjAn/Rkcuxu0kXvWfL08/HDXok3QUUT+TFvZypibv+JhicdDYTmK69yS4UriewGpLpDYe1hn8Ad4WlfMKQCrBeAXIgrt+Jx8IERGLeoagoiNPJuob1oOXaMcBQi38nqT/PrbHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxKlFG+diSVZsLPFy/Qsy4Wje25azOa8dx6nLBc2jtY=;
 b=D0gvX4UuoOupXGsg+QYB+XmE2EoCVbpSvkz0JHHvjsIMV3Yu0ssz6GHGR6w4B9TKn23kEnLzXlqge8nH785LyFNqSNxwElipY2Ov7AQ45Rq1Ep6aCxwUDiooAR1vnmRvuy9yjF4MEAmE/GEs8BspYTbfHKgD1FuHJQATj5ohMVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 14:28:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:07 +0000
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
Subject: [PATCH net-next 3/8] net: bridge: rename fdb_insert to fdb_add_local
Date:   Tue, 26 Oct 2021 17:27:38 +0300
Message-Id: <20211026142743.1298877-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25b3b1a7-d253-486a-88e8-08d9988cd414
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-Microsoft-Antispam-PRVS: <VI1PR04MB601676290A60CA2C04BA92A4E0849@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E5/Ihx+MvtWxHGXDPHpCgoR2FKGfF4z8B5W/maaRtSbjYBo1o3/VWLcoY9agb15icw4J0avwoIHk5A5ppenW70t2civmkWWYlVyzeYhlCFJnA5rW9/tehsLtaqGAHUf5dXYF+0zMXV9oh7mc35isThHKuS+8uvlCYHSMYnGNN0TePzXA7btz2bXbxMnu/r8T+Udhfo7LgfDfrSkYtpRekU9p3xC1Fo8+VVxibBfAworG8icb1IsLs8pmCHCYyb2YJC2e6ZMKAzEAkc3XPTe1XqwOrSf1VCsOostBjvSfybO/QuQ1N38qp7AiwHdqyeQBUJvHTY/Du4INaxsvj3sUQrMjyWFOgRSGOLb6/D9ulDVaE4ArcZhoYngDUMe0zENhEfCWvumpMoSqKGcnSqkEl2x3CwEHW2GSgQNLhKx8YfNbTfGZl3mRdbFEcLCCB0/MmBvIs9VS2VzfNCh5x5wDRaJUg7AcG5JBh2yL91+smXPHRO1I3WyXZZtx6dr9WDwbn7rDtl8YkGpt64Cosy5F8I9bZRTrAeqtqOHULlQukaNExFTrBSHsKC2HKTO6L+tV2W+moMr0H+KYVid5V8AFSRt9cBnuIanSWYu6UFV+jdQCUwE3VEQQim4gdHX+LIMBew+izMt4LuR6uByOKA6h0CHqz5dxxJd7qoFZeBN/gJfSz34LVurNYZqUX0oYy4tLBbcWFfowf1JdaFUIMRZIGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52116002)(44832011)(66476007)(26005)(38100700002)(54906003)(8676002)(86362001)(5660300002)(2616005)(38350700002)(7416002)(6486002)(6506007)(6666004)(66556008)(316002)(6512007)(956004)(6916009)(36756003)(83380400001)(66946007)(2906002)(186003)(8936002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+DhZehbBdxNT+tUT76GRLz0y1pihaEiubnTnDLdpHEbnrjWG4MqXIBmMj+xX?=
 =?us-ascii?Q?h2Rq2jCgzKOWzrJkluWtTydXBbcaNPc8ZELJsZZD7YcTL0ldC8tKmjsAYItY?=
 =?us-ascii?Q?3YkH44ZX93mf5fbBxmS0DkpEfRATnxt908Z008tBAjCpzV8FZTt4t6IlwKvk?=
 =?us-ascii?Q?cDx6aUy86Dz8HOvN2pOkz9zoXkNcjFM2Pv+ieX4T/EyhursYz6BBH/3Xku3A?=
 =?us-ascii?Q?iIfc13H7/YI0peqEMMIsAVF2i/elVJAW+HpDe/e8AmZ3UyG4mLP5L2Rgdi7H?=
 =?us-ascii?Q?OgNNxm3n/ZOen3vWt5oCze4nxUWZxvUQ34AKOBFzgghg35kyMvY5k/hdb1Zk?=
 =?us-ascii?Q?WPxrGpq2xYs9gmmKx5xePAsa1NIJDQ8kLltRUMeH9rK2KwG8FHJGzRxiU97y?=
 =?us-ascii?Q?0niS0G7rIR3g6eXzKScfd/gLulvLSyCauU56C/YW+V6LuK5h2KeUoKZ1AANI?=
 =?us-ascii?Q?k7KmAo5tKxI3/d1LskF3J9T5J9K77ysfqZLe57k70m/w9npIbvTnTBaNNExP?=
 =?us-ascii?Q?aad0z+yoyPaUgP4Zobwfzs1uWta/KBM2/K22YprAxnD7k89cJ65KUtjw/eNP?=
 =?us-ascii?Q?yCyEqINgGxITkBQZ45Mr0hi+UFjchJCUVBbeZZYzSrOyHr/uVCeodQLw7Qyt?=
 =?us-ascii?Q?Q48DSeY6OgrHliJ6IKBrgABoQ1D+YFogengXws/pO2CbcvaIqd5WpF5KrkdF?=
 =?us-ascii?Q?PesBgf8mD5MV3aWDQ2OqJPm44wkQfSvynGXt/pQeYbnv9xP1+/tMWvbELD1d?=
 =?us-ascii?Q?1gaIfaa8LVqVDywXa4P0Gp9+2ddV6BqbPuYgRlUuNYfFqVgNtjuVAhj/54dl?=
 =?us-ascii?Q?oxlIQ70Wj11U3qVPJE6GqyJS4lDWrpaMP/zPNUacUqQIr3yfL97WT7sN5gh6?=
 =?us-ascii?Q?SNw8bu9S9hclp1pt6NKbUyUclFGycZT65oYlohtkFSPakgc7MRFB4vRwkBwi?=
 =?us-ascii?Q?wM11HAWETSlB7C0yByZMZFPTwjWW/gz3D2RYCS5MR4AnZMqVRAr0lKJ2R5fm?=
 =?us-ascii?Q?7DAAPTkF2ehAdwb7Bb7x/5dgsUCRzMERQP9hjShs9/VafIlNlhGjwpWqfQHE?=
 =?us-ascii?Q?LyWA+WCmroAWsuog8VY4s1uHD4MIUL+Ph8dAS5EYeT9JM/IruSW9x9HEKWsT?=
 =?us-ascii?Q?Mqp696l/Ze624w1IBIBwVGIy27shPXDeQB1yVF0C3oDHbMybrjuLasHHCy9T?=
 =?us-ascii?Q?hKAe8oJjGQJNadX/ajVXpszOmyDJ4fOBLjQtbDfE3SMJ1cPgg2Y96LqjBYdJ?=
 =?us-ascii?Q?CW5NAPm/tTZEJjQ6dwGL+USUrWInCuMwAVegGZ+PU+ODV7/3aBPYcfXNy/Ov?=
 =?us-ascii?Q?QiTeiiFPPQnK+di12oUqKFl0BtZ2jYMzYzzSn85565mEiAMNcywyzQdak0gI?=
 =?us-ascii?Q?yv8uwNTUqxK69zWnGrBFlsCJj6GV1wE1OES4GS2O+DgxJRkayNEXiz5eqosN?=
 =?us-ascii?Q?JwICF0eZzSR30H8I1+emGq+JqAfNzBdnlcBFryw4qwHM3dVHfOEK/dzsEy7v?=
 =?us-ascii?Q?e+tHVTH6hR0RP8lrU544BSkNKNmv4pG1E+kevOL+P37/54WxxRcCFyShFgni?=
 =?us-ascii?Q?pUf+DQexJ+FE7qhc4JJmID49taNnGY9Jrx/Cr8SnPUtyquP3DEjhpuKEZ/zk?=
 =?us-ascii?Q?q2YVm2nzkDMZbCpAyrxMmaQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b3b1a7-d253-486a-88e8-08d9988cd414
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:07.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOV0MCK/sYbgjYRH42TFvtj4W1q2soIalUhBdeAWQAySSS36A+iQQd77CHK2PY0w1IsEECbR++hrpA9xAxW8FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fdb_insert() is not a descriptive name for this function, and also easy
to confuse with __br_fdb_add(), fdb_add_entry(), br_fdb_update().
Even more confusingly, it is not even related in any way with those
functions, neither one calls the other.

Since fdb_insert() basically deals with the creation of a BR_FDB_LOCAL
entry and is called only from functions where that is the intention:

- br_fdb_changeaddr
- br_fdb_change_mac_address
- br_fdb_insert

then rename it to fdb_add_local(), because its removal counterpart is
called fdb_delete_local().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 082e91130677..668f87db7644 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -402,8 +402,8 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 	return fdb;
 }
 
-static int fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		      const unsigned char *addr, u16 vid)
+static int fdb_add_local(struct net_bridge *br, struct net_bridge_port *source,
+			 const unsigned char *addr, u16 vid)
 {
 	struct net_bridge_fdb_entry *fdb;
 
@@ -458,7 +458,7 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 
 insert:
 	/* insert new address,  may fail if invalid address or dup. */
-	fdb_insert(br, p, newaddr, 0);
+	fdb_add_local(br, p, newaddr, 0);
 
 	if (!vg || !vg->num_vlans)
 		goto done;
@@ -468,7 +468,7 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	 * from under us.
 	 */
 	list_for_each_entry(v, &vg->vlan_list, vlist)
-		fdb_insert(br, p, newaddr, v->vid);
+		fdb_add_local(br, p, newaddr, v->vid);
 
 done:
 	spin_unlock_bh(&br->hash_lock);
@@ -488,7 +488,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 	    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 		fdb_delete_local(br, NULL, f);
 
-	fdb_insert(br, NULL, newaddr, 0);
+	fdb_add_local(br, NULL, newaddr, 0);
 	vg = br_vlan_group(br);
 	if (!vg || !vg->num_vlans)
 		goto out;
@@ -503,7 +503,7 @@ void br_fdb_change_mac_address(struct net_bridge *br, const u8 *newaddr)
 		if (f && test_bit(BR_FDB_LOCAL, &f->flags) &&
 		    !f->dst && !test_bit(BR_FDB_ADDED_BY_USER, &f->flags))
 			fdb_delete_local(br, NULL, f);
-		fdb_insert(br, NULL, newaddr, v->vid);
+		fdb_add_local(br, NULL, newaddr, v->vid);
 	}
 out:
 	spin_unlock_bh(&br->hash_lock);
@@ -685,7 +685,7 @@ int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
 	int ret;
 
 	spin_lock_bh(&br->hash_lock);
-	ret = fdb_insert(br, source, addr, vid);
+	ret = fdb_add_local(br, source, addr, vid);
 	spin_unlock_bh(&br->hash_lock);
 	return ret;
 }
-- 
2.25.1

