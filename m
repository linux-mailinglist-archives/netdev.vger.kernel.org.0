Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395F64B783C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbiBORCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242106AbiBORCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:47 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539611ACE3
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lX/BbXzyxzvB3GOO5j2zh8gTaaJ0VuTFSag+1Q2a0+D/qdSxUdxpDjNVFCOdCyP4uj04sXCquxRDI7taWHLXvYXQ49HnTrv7vdxEUhYLhBGHxm3gjGTnoMhffHv7f77iVeWd+y2RxzUhRPpECq1vEnwRyWykWM6DsQLUydZtsMqlTaa5c8UzwsanpWNkgCamws7wMZl3Od9ElYqsKLMYzb05KZXpm+askryepE0MGO8WdedjIfiC8NiS/nWNPmjyj0htAmiu8nzQjNJpIPp+1BgXGfzgQTVsvCrEO6f9/hq8o2PNcPJHq/bRWNRPhlNb6b4kbsNzTc/ifVWMqok2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gvapi7VR4X9nTqqeJ9t7U/Rob6ToJLgOzLUVurbRpmc=;
 b=Ed7ShqaGdZPD4FTOEJdP3aEFtUNuqrxRTOaO/YiI78K9yE3IjbEC/HC2RVq3Qpx5kyCIkDKo358UAzCGy+epMyGPQiMSTdLp23N/uv67rZRj47kZtnaV1UnjeQikwzLvgi8ZzV+n8zESPUdJm7kr+WHrv4HT4frmN8U0KBJ7y+vOfh1pTm0bnbvL8hHT5GxoVzTGKBYyeG8MLgwho1szA67IaDZ1kD60wHvSO86DyREgswYcyP9MkRsWOAmeyJoQ0dxikHFd9f3Zllu88oIdVT4SidkqHiID5E50nCGM7JT/2CHENkEhg5yedYfZpgBEfN//yUCoN1gnGz/Khb3lUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gvapi7VR4X9nTqqeJ9t7U/Rob6ToJLgOzLUVurbRpmc=;
 b=HrbA3RQWDBs1L1cbPoNmj5ETOD/j23m22pqOYVIMY96DKsCGy6f336rtOUpO+yG2hQtAoANlchJ5s0t7Syzc6thY6pqeE3yNqvXPlnbabhO97xN4YtkDvJQGxxdMSGCwelor81yKbuwPT+8tDm/XbLUxTK4zfdx6j+pFiEaKQfU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 03/11] net: bridge: vlan: make __vlan_add_flags react only to PVID and UNTAGGED
Date:   Tue, 15 Feb 2022 19:02:10 +0200
Message-Id: <20220215170218.2032432-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ccbf636-6da8-4d60-9656-08d9f0a4f2d0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342972CF23B53CCE4452260E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5p6ynHAouXg7wV04Hya3ttlzPOFliwOgwwjLOdfJQRCNDqSnSosSGuZeFZFROHkcKYhRidUkgr/ARIc0wPLTRtXdP9Wt4cKoseKeXSuNwXFnDnek5T0Qsc3NXAvICWBir02PuYNvWacAKdr+dOSg8amE66kmk7WqCZxTCjZWsQgZw6eNPkZw2KtdTIEHuUt7t7pEqhQAhL1Ve/cHz8/U9/mjd/v54LXF93I3OLgxOPC2Xqt2OiqSO5lYCqWsy4i3plDDuta/FhTaHqw7velrkZcUVJjHnY+C2kz8Axgz6zsR4xJZ4XYyc1dvoVz8G/UGZeQRrtqHVyhIh8AjGOtZTyZUb07P3pt0QCjy341KNLISgjp8uArU4H6bYCDz6nav0zRsPoyAl+y3yBianLM3F6Bjn8dsdmL6KhH3bJAS0e9//T3mRyp0SHknOUTBb9RMJ/sBTiDCeDs25Qgy6euj1DOJFELej4nUqH2uq3gjtN9tC8MJWiQNOxVkj5pgDcjIElp5sVAf7eHmAmRFvyrz/pCFaZNCPM+qjl92FI0BH8P/IyvZVBtPnMzwKQK1FHWLvD83x9AeI2Cxy5zEMtFMu4RlAYwYUhrn5CMX3eMg8ulrPriSq9V2C5mfzP5Rbc+ZM8F9rP0EdJQpFpAVDaKgcdTPYrsIP8kIlgwojkp3l7PR8drgYViEkc0HOe+U9+00urHV2TEuGzONViB4eM555g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BvZUWa75xC75MgWKqbY5GlirOv6JMbWlutJt/HAJeWBxBaxLokvXGNEROymN?=
 =?us-ascii?Q?7oTpgKjoKxRD7/S7n9lu8Zp8tEr/LmnElXhZGjiUu/3+3bCTkU6wpiQIKBBV?=
 =?us-ascii?Q?pYh+82x2+vR5305kCOA8aGS9ZEczLfV57OoAoZjFaM62qt7aX08ieR1B+3Y4?=
 =?us-ascii?Q?QIGsEzmLjMzuw16s7dyVy2GR6ISjHDnPL4843g/hz84qyp7FuXOqcUKWh7BR?=
 =?us-ascii?Q?ECtqSaqOAyXV4tCyp9VI5gVIdqRwnZTEF90PujIM7fpn/Zk+ZglxBRlPwGX3?=
 =?us-ascii?Q?KdXTD/cODC+HOBVywuKeD0La3GlUkFCpE0OLG91HXXZWqZQDFgOeN6nofvHg?=
 =?us-ascii?Q?famINF+PUiMJGrPpNm7ySqE8UYOahqioEWhF6KkQyqWU4RRM5TJM7k6qTINe?=
 =?us-ascii?Q?RYi3woUUSfRazelIA/Y5jy7M64+PjviGwEhyi4uThWSU0ieXf2DGQfltXNnD?=
 =?us-ascii?Q?reUE+p0vBKHMyVou/G/XYRDKF3FLEFrtTdbU8s6zAEmCeUzRfAIHSe3yJMAv?=
 =?us-ascii?Q?vb2BAE+PiN4lmQa85pvLVcUX7kJgw1q/o3ftqWp85QRf2pldMQHqAzznYXCV?=
 =?us-ascii?Q?NqN9g58qAm/aXDGKCeLNOPsU39fvhBCYrG0Y84mDosG+wb//n46FeGOGwmkD?=
 =?us-ascii?Q?Jkry75jJgv/y1UZh1I8LijwaleJuDCU5a+LNLvuLW/dTr71D9NLhBdO+okka?=
 =?us-ascii?Q?Tg0wXLlIo6ZPKHzkZQsCCkaWF97EhNuSL2g3+cb9hr9e9rA+6KxnM9oDlXIk?=
 =?us-ascii?Q?yaDs9LW79v4jg0SlYqS8oqcaBYNn0qQ27vrgfdx3mwI1pM1VVUkcBARVzuDG?=
 =?us-ascii?Q?+qRI5bcB2d08V46YB1kFDABK3ZMEQgCqieujVZ9ZByxYAQuDuTz6Pvu7ysR+?=
 =?us-ascii?Q?2eQ4/nVdA4HC9+CWa8oXlH9+UseTEIYiX9qDXbkXglQjpORhkgifjIXj70Qt?=
 =?us-ascii?Q?t6+LOKCzo3SEFFpZ4kvC3Z5+BmkHa43CEVFSZms9n3OnAfH2ynssR1fxCrqk?=
 =?us-ascii?Q?uptio7P4S2G2DaM8Vsnnr0SlIOW9+Hn9eiv2+GPAJsyNeWJLfWb+kVIPYQTv?=
 =?us-ascii?Q?BLYBN3fnneRZyEgj3A+Gd7+AsJVddSfmKAY6nMSh6CmOAvfDDZo9bEwgaHf6?=
 =?us-ascii?Q?ib6NGfwbfGbzNooZWMvUCVos4nw4Sn1CaoXGUj91/m/GiZ7So61h2qe1d9GX?=
 =?us-ascii?Q?7jHgorYHWV1HuDPCdgtX5Qh2HMMtM6EBMOvlB//0MoWpK3pCXxbYKSpI4yAz?=
 =?us-ascii?Q?7VWnT1Darq1oMVK3B4x+LBop375gSzQqdvj+2SzL8cJDTwpud2fQSmUDggKk?=
 =?us-ascii?Q?hhsyGYPCDPqZNAT7nApQUzKLT8wAtfCFFevEDpuEvLoT4uPrTadZ4gBqG3OV?=
 =?us-ascii?Q?oDrVfvfocIh5vKIf8ZIyIxsV2BAwh8PpJRo6srI8e22hFbYbY3lOX69Vjo2u?=
 =?us-ascii?Q?Jv63CYcEwzL9gbtVYVRdbDUfuA1RgEeh6Z7fFKqOzrzy99rcsUYQRb5Ke8II?=
 =?us-ascii?Q?/3mxljGMgsgfCKX6FS97ykzUWkNWJ6gQwXf3aWU1sgY0GjfXvuYaZ2gq2PIs?=
 =?us-ascii?Q?xovvZMJY/XZNM0OIOYLwJUdFiGrbLVi6z0u3W2q6qw7DpMCRX/jlZTQyWuMr?=
 =?us-ascii?Q?Mwa72UMTqXj8ksQnBMnOoqQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccbf636-6da8-4d60-9656-08d9f0a4f2d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:29.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwAzaA67wFR6/9fk7D6GOagE9cNzBddfKgh/tSeI6iBtr2jK+TFRkwRWDhOiNExUYt1JS8xiv0AJhqnGco0+xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there is a very subtle aspect to the behavior of
__vlan_add_flags(): it changes the struct net_bridge_vlan flags and
pvid, yet it returns true ("changed") even if none of those changed,
just a transition of br_vlan_is_brentry(v) took place from false to
true.

This can be seen in br_vlan_add_existing(), however we do not actually
rely on this subtle behavior, since the "if" condition that checks that
the vlan wasn't a brentry before had a useless (until now) assignment:

	*changed = true;

Make things more obvious by actually making __vlan_add_flags() do what's
written on the box, and be more specific about what is actually written
on the box. This is needed because further transformations will be done
to __vlan_add_flags().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 net/bridge/br_vlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 498cc297b492..89e2cfed7bdb 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -58,7 +58,9 @@ static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
 	return true;
 }
 
-/* return true if anything changed, false otherwise */
+/* Returns true if the BRIDGE_VLAN_INFO_PVID and BRIDGE_VLAN_INFO_UNTAGGED bits
+ * of @flags produced any change onto @v, false otherwise
+ */
 static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
 {
 	struct net_bridge_vlan_group *vg;
@@ -80,7 +82,7 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
 	else
 		v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
 
-	return ret || !!(old_flags ^ v->flags);
+	return ret || !!((old_flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
 static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
-- 
2.25.1

