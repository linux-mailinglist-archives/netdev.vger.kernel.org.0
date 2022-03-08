Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C824D132A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345317AbiCHJQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238795AbiCHJQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:30 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBCD40A1F
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIPp7aWn44Aj+xcfpjP+qxhMB+7Yi3gunq8XmkWWwDJPare1IrNfvGiv9pC+y4riIq3LArY41/MELhE9UvbZnwhwuQHysFSLOoqag4+2IJwVC91Ci2dSErj/gB6VSU9Mr2AXNZp7FePjOITZKjpHoJEJiGF/8anAcbR7v/J1t1ZKoEMdRPvXQAs9BHGObnj4D7FPhkY53HwuF4Qh1SRj++rZu5CO60H8B6YOPuHmOL2CEZM3eFWI3fo+EKBNO2Cpv3R7ODUaWn38QvG6ygG2iF5PZjteN8VjL3aGT14DgMc6Rm+JtWtl4cmIuLj/AgzQGDunJ5ijIDV6Efygh2udeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgbBQzb5GgBdzgH8vQBgnLRO/XieSshlQdcpXlyiqR0=;
 b=RHbCcHFlW/0t/0G0TuvDeAWefoobAj1jTNWTmJYQpVhyNcNAOR77usU+pxbwj67o594wcS5I/RaQesSbK9Wlb7VSAtll0MaUxWsCvumZ8LYsyYV7swMuiZOPPhTDtZWpUz5BD8wx2N4VbsTyXvwx4UIe4FPYyhU+sdBWpANBBTAIvFclEcy+00iWaTMoX2c6sipU73cSYAkRqtVVz6n9IW0OKweVZ7YEWGVeOHvpBsG8bSLpUnDoI57+9Pae9wYRY3hR+h5QDrAJ4obAHYKYHpVv7dJZJXSXBVU6d+SloRTeCHRPiEoeH0+SD4MogCZCBI058peIOGTRbvP8Cifp/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgbBQzb5GgBdzgH8vQBgnLRO/XieSshlQdcpXlyiqR0=;
 b=E8Iv/+wBTITHwfPc0KiKReTKXdKuVFun9prtEp1k3d0EXpIs2XzT3rX/ZMdqlr3vexaOqM0xCllVmZBNMgN5skKzac/YOVQAXtt/tvWtVj+Hnhaml+pNdwpgKB8GaS+OWXfoC2T5gSdW0hZVYltnxRRiXkM5KPma9yCX5w49CSI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4243.eurprd04.prod.outlook.com (2603:10a6:208:66::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Tue, 8 Mar
 2022 09:15:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 2/6] net: dsa: move port lists initialization to dsa_port_touch
Date:   Tue,  8 Mar 2022 11:15:11 +0200
Message-Id: <20220308091515.4134313-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f21a51a-d51e-4fe0-1a22-08da00e430a6
X-MS-TrafficTypeDiagnostic: AM0PR04MB4243:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4243AF48F1686391935D2B90E0099@AM0PR04MB4243.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEUTaROYnDxB2YzHFQI85KafEIfujd3pmi8SnAdIGw9S8Qp5mfT+Xt+tcN/5VWpX/EYiNEbQmdRKREal1eiP5zQK1f1IkyhIpUQZp+iEbwB6044Ikf6OM4HRaEKcwE2HYh+5X9BRiYrgoWPYzZfT9szlJl4biRrhfxDtO6m5AUrH4dUcQXGiOVYoGLBtM66J80j0Qo7lEuxyNl3pLT5Np5+lwG7zqM3JRqxPNMxAeoClu7gg94uY67Gm6Sm/YwIihZY1rmk4cU4pHBs+/23tBnMQmwvpVh0mgwbuSb3VRFLAabEZ/C2wbeUPByWrcANGOGH/huTL6IT/35BqI6+83YGOFf+NGmv3tacZnv0Ef6YLF8AdzTAdqGo5hPEsndcKaX34mEXqiQjxXf7wJ0ruVZ7w3ueWwrTzemi30iyh4XHvbWLqnftzoNATSKNF87W8FsadCtMGH6RQf0/dd6y3BkLI77qYatD1D5ZDxx777EKnrB6EEdhq71sh5y99DPqSBNHg5hJ3YDLB9zD/+HWt/7nAybC6ppUnIeHyzCo8DlLrjJ3hendliLdkA6gZO4PKOi7FEqZeTl3FrH/VaK+q/Y4DY5GfYU9vX3xkSlexxCl9xLegN5jLJbCfm1N1IiNkCSROGTd4kd1ksyF56GrNxeF12v/3DJ+hafPeeQLnqzhgnT55v///Cg4somwVWIwba2GC6debK3aJ2qh3qgHDHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(44832011)(498600001)(8936002)(7416002)(5660300002)(6666004)(6512007)(6506007)(38350700002)(86362001)(38100700002)(2906002)(4326008)(36756003)(8676002)(52116002)(6916009)(83380400001)(186003)(26005)(54906003)(2616005)(1076003)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f/mJqIIjCbtQkket2jIQgPZn2sbNa2WTGZR3ft5+QYw/T1IpEXk5HZGbd5zS?=
 =?us-ascii?Q?7O23qvyK/i/xHFD3kyN6NMvHf0xAOon0bpAKb4x9vQR1wU7MGIZKHO+tSlLz?=
 =?us-ascii?Q?qWxuJP3zHRcQdCceYBOyTOhW2kXsAzqbsQma6y8+PhNPemVbCTtlX1WGb5el?=
 =?us-ascii?Q?Zr9rLyXNShyIPK3parRUXhmAJDQpO2Od2alGzLXnxWIR8MKDNozPwbeNHK/l?=
 =?us-ascii?Q?p0NGswX8b1M3VlLWTF7wU461iLNFFObDztzE2KLQZkJRAB8HiHNx40Hp2+rB?=
 =?us-ascii?Q?FBEWqCqbUvRLcaU7YQLrq18fXKY4g64O/spkvknklUAi1/hFTIoGsBqtsZwj?=
 =?us-ascii?Q?SV5CxE5QvBccYev3kINcZ2A76qSZm1tqlopOgjojLFjkORoDFIWqY3pHsLkQ?=
 =?us-ascii?Q?XERdXYZedZNMjLTgTrdY5FJuEmMtDSR20UrcK6AkehvGzgnhHVrW9S/LR71L?=
 =?us-ascii?Q?Wth7tlryP2fo7qDAjpC3spClbFdWZj0db2bXkfhjIU3xO3njSqGVqk0UrYUY?=
 =?us-ascii?Q?mLRlrdrH6NBeTvbTkf0ysBJkRkFqayWxWvUAJZj/qYv1f4CipzYx7dVBaSJr?=
 =?us-ascii?Q?Uvl6rjTAnLJOuq2+eE4Sx5HFB0niaDwIeF1M1fbO1GCShD0ShY2xlSVaLyfM?=
 =?us-ascii?Q?WsiLVtef6eEJbICq/8Vnq+13yo7VZuFS6cv5FgQW2G151xCr6F7qkuY37YiL?=
 =?us-ascii?Q?j+H9iWTR/LxcQzYn/J2V9PajYngbE18t+jwK1KPn45224Lpz8uMmj4NP8k3K?=
 =?us-ascii?Q?T/FQ6KC5JloMN+xrSWyhMrPvpnM5VbSQSxxlUudakB5jsxjLKS26zL2semJN?=
 =?us-ascii?Q?y851lcqogyR18mvFJHl2Lf3U59CbmqKIzwztI7OR4tHcz0tAqT6Dl6ni+RF9?=
 =?us-ascii?Q?AnzF0AlRrPndVrcx9m8/05BMGhBooWV5eqCwUMk3grmSaQdeV5kKh8NeJLys?=
 =?us-ascii?Q?BrqOLY3Byosj44yY9htdPZeY8jFFQ7llJVfjXMhSQvTANckRsRiZNtuEpQWL?=
 =?us-ascii?Q?HKTeFcKRishKgDLog6zwvI4octeYFMfWoenN1vn78XpKqKFkZ0ik6VVmk0ue?=
 =?us-ascii?Q?KCFzvaiEk2RTV6DHMhR8RbRXluKLkCN7mzQ6HphaMBcE187rBvv2+WdymanK?=
 =?us-ascii?Q?Q80NYIMurxinynvb7vQ9wwflt195xcRabgcRc9g5iFRe7jZBxwBuIKdcWzhb?=
 =?us-ascii?Q?d1gg1AQlIioShktVhiFOhI5PWROsytrplNCIglN3l4n2gkPgQt+JQXSOqbYG?=
 =?us-ascii?Q?iSQwRUaGXVYe4U9SyK0J/fo4iLUgZhJoP3QV2GHtHEq3ZHtYZuh2K5Cqklqd?=
 =?us-ascii?Q?kz4GCNB4EcyvrkCaTUnHFnYNaqVUf9mUU7NCFTAhirbdtxdhSfsUafA/DhM3?=
 =?us-ascii?Q?hjw0738ljHWvIqTBbXyMO5hcl5+kzqnC37L8meikAsNl8DklDTQSqV/uT/Wy?=
 =?us-ascii?Q?hIEk5ZTOOotpQSvmGi4DxXdlnMeV5EJNgOA17iXr1jv7nNz4HeJQr+dl2Ujr?=
 =?us-ascii?Q?0I31ON3+L/CnOKqu9AvYXMczqKGMXOWnKEkK9u1g7/97Gvl/Bl8zmzsu7Zd2?=
 =?us-ascii?Q?nm4kPbmWpY70kTKwWpu2ZGGT6iiczyV+a16/3IrSNEex0MHanRmBQJ3UsBvU?=
 =?us-ascii?Q?fFWd22kazyubPwQ+etkvLU4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f21a51a-d51e-4fe0-1a22-08da00e430a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:29.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7J/4JTZv49wbEeOFsmFyYR+Ta/GxGqDeVE/ttfeSAYeMo0rOvLdptXcaF3d+PCtwVEnIHceaJn9GKl92Pz7+2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4243
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

&cpu_db->fdbs and &cpu_db->mdbs may be uninitialized lists during some
call paths of felix_set_tag_protocol().

There was an attempt to avoid calling dsa_port_walk_fdbs() during setup
by using a "bool change" in the felix driver, but this doesn't work when
the tagging protocol is defined in the device tree, and a change is
triggered by DSA at pseudo-runtime:

dsa_tree_setup_switches
-> dsa_switch_setup
   -> dsa_switch_setup_tag_protocol
      -> ds->ops->change_tag_protocol
dsa_tree_setup_ports
-> dsa_port_setup
   -> &dp->fdbs and &db->mdbs only get initialized here

So it seems like the only way to fix this is to move the initialization
of these lists earlier.

dsa_port_touch() is called from dsa_switch_touch_ports() which is called
from dsa_switch_parse_of(), and this runs completely before
dsa_tree_setup(). Similarly, dsa_switch_release_ports() runs after
dsa_tree_teardown().

Fixes: f9cef64fa23f ("net: dsa: felix: migrate host FDB and MDB entries when changing tag proto")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 396ea0b4291a..bef1aaa7ec1c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -457,12 +457,6 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (dp->setup)
 		return 0;
 
-	mutex_init(&dp->addr_lists_lock);
-	mutex_init(&dp->vlans_lock);
-	INIT_LIST_HEAD(&dp->fdbs);
-	INIT_LIST_HEAD(&dp->mdbs);
-	INIT_LIST_HEAD(&dp->vlans);
-
 	if (ds->ops->port_setup) {
 		err = ds->ops->port_setup(ds, dp->index);
 		if (err)
@@ -599,10 +593,6 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	}
 
-	WARN_ON(!list_empty(&dp->fdbs));
-	WARN_ON(!list_empty(&dp->mdbs));
-	WARN_ON(!list_empty(&dp->vlans));
-
 	dp->setup = false;
 }
 
@@ -1361,6 +1351,11 @@ static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 	dp->ds = ds;
 	dp->index = index;
 
+	mutex_init(&dp->addr_lists_lock);
+	mutex_init(&dp->vlans_lock);
+	INIT_LIST_HEAD(&dp->fdbs);
+	INIT_LIST_HEAD(&dp->mdbs);
+	INIT_LIST_HEAD(&dp->vlans);
 	INIT_LIST_HEAD(&dp->list);
 	list_add_tail(&dp->list, &dst->ports);
 
@@ -1699,6 +1694,9 @@ static void dsa_switch_release_ports(struct dsa_switch *ds)
 	struct dsa_port *dp, *next;
 
 	dsa_switch_for_each_port_safe(dp, next, ds) {
+		WARN_ON(!list_empty(&dp->fdbs));
+		WARN_ON(!list_empty(&dp->mdbs));
+		WARN_ON(!list_empty(&dp->vlans));
 		list_del(&dp->list);
 		kfree(dp);
 	}
-- 
2.25.1

