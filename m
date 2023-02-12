Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925FE693A47
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 22:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjBLVmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 16:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBLVmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 16:42:05 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2055.outbound.protection.outlook.com [40.107.105.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6524DC678;
        Sun, 12 Feb 2023 13:42:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWM2rjMfHX2zbIHge9XwgN4NyEHbItvn79FvOvIRdXZGCa9NiY4vzWaqtvt2wO6Qhy47zhqORuLOLp2UehTww0uBcSZY0ZPH/l2Y5jgxaQSoB7hRXjc3TZ4RTnhI5XxNBceLram6GzSEbB48pcn0CJ3jErvCLdO3/TF2WeNKXoWADKB+hsjJYDzrqTSfb2X3UM0itXguSrghLh4hTkG4WEGHAkUYQgA/qz59UP2DzfNSsqNx5Ji+gr2ekbwM/HIDMgqmN8U8b6X0FdT98cNnWyRkJbvF8jXqUJcT+SPc3Mx9ttK1kULjN7RVpaRPFp7lLLKRq2B8T+vwuA2AWEgp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqEZbnWlQOqLMsymQrXzwDxWrFiiFGuJ1rqroX7iqhg=;
 b=NP6yI4tbIq1hQmLiAItMfTyVoYNNAWyikvkRcKr1PIp7/B96K3nNzgEPsWDK5gbZGJY+FD99xhFWEOJYPcyQX99j1oo/mz3voO7pNp8hNDR+Vpn3o8YVRhmUOMGXZ5m2XHFYv0Sbmfnc+oSxL8iWy+uaW1WwiYD7L/9WZWovG/7DOEOAeodDdh0uQn/vbmop+kGYPJ5ixdoRnhN/TxA0m+lQg5LT7fqL5IxpXDiep/C69ViA4EAnuOXuFQXTHgya1MIcBNEK+qb9cKT2hjqd/pC4zeC3SULvx6S8r5faVoID7VgoqXElwj2hvhbPD/XpExHDMJ3FfYW8xoCE9ag8sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=routerhints.com; dmarc=pass action=none
 header.from=routerhints.com; dkim=pass header.d=routerhints.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=routerhints.com;
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7)
 by VI1PR04MB7149.eurprd04.prod.outlook.com (2603:10a6:800:12e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 21:41:58 +0000
Received: from VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd]) by VE1PR04MB7454.eurprd04.prod.outlook.com
 ([fe80::e4a3:a727:5246:a5cd%9]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 21:41:58 +0000
From:   Richard van Schagen <richard@routerhints.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Arinc Unal <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Richard van Schagen <richard@routerhints.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] Fix setting up CPU and User ports to be in the correct mode during setup and when toggling vlan_filtering on a bridge port.
Date:   Sun, 12 Feb 2023 22:39:49 +0100
Message-Id: <20230212213949.672443-1-richard@routerhints.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: AM0P190CA0001.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::11) To VE1PR04MB7454.eurprd04.prod.outlook.com
 (2603:10a6:800:1a8::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB7454:EE_|VI1PR04MB7149:EE_
X-MS-Office365-Filtering-Correlation-Id: e6621a02-39cb-4f19-31b7-08db0d41f757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Z77X2P7JYrhmvEAlz2AgQ5YLCCAg4hL6immVhj7N1wPQ+qh+rvdT1AYaRvoWyBHtqZngGo7aKYmyHqeFrtJNQlXsDMbDG9HlC80uIKzK0DxMdmgWV2Z4GYTDr6eQ04+bhwLG7tlhkEOqJBvsFBH9rZW4riMUFwXVCtj9FzMjdu3mL1PDt2cmUrgdlrj2FkER1rcFA8Ze3zL3XbXCTxDvE9ruJYScqsUG0MBlUq0/YRj88zbLzvB7R9XKGUM5v7AYmfrbHPkUP9i2pSXRx1i8K4p1iJw/JoaLjlTCWSrFebA01QFEsOj1NW39DQpmLzmPye4ZZK7K6Hf4zZLF87GVUYrIzkWmSwoeD8r9gZyRXyGoLPvj1Evq8HxOiJKU+HXe81sbTaTB5peMklSRhkAOS0/vZksatoZA08CySL2TFj5TbA+eF9Tc34yr/LPx0iawKBJ3T45icQc4ZAZtYdWaKmQY+zHYZdZl/4Xtpg94nSJKfBzZm9IBAyfdyF0gVs1ZAfrB2gTkEQq4JPz3h9KdlX53CIdnz/02w4GoifnQyb4LnC8rXmPt+tpQzO34U9aifCb8O4PFbm+idg+76jDdbLyLXzjBdRE4AG/KfsF5baYHoDjsSSOENnwgUUNngVHLE6r1QutOb4swa02iGt33lbIYoVUmD9dySgBY4YqpNVopozh8TKDXVAOSen6kOXo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB7454.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39830400003)(396003)(366004)(136003)(376002)(451199018)(86362001)(478600001)(2616005)(6512007)(186003)(4326008)(8676002)(66946007)(66556008)(66476007)(6486002)(6666004)(52116002)(1076003)(6506007)(110136005)(316002)(921005)(5660300002)(7416002)(83380400001)(38100700002)(41300700001)(36756003)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wr5qMSBC00GjZjlXSE4blMVMwhsYsaeukgY7XezRYd1JmpnosHBhywI+EC0S?=
 =?us-ascii?Q?ZmEIZo7NZ/zQiNHxc20flAJHP7skSAi0Nb4Kc5TrXe+5QjennkW0T6Yk/cxL?=
 =?us-ascii?Q?ZGy5PpF50bmZ1vTKBHx6MondsLAK7iDQWgniwADj1nwqfngI+v9woRVop2TT?=
 =?us-ascii?Q?quVpiLJQeMJ5qfyV8Oe0bAgeV5tvZ4ORac25e1kbht0vkkFkJFqLLmBpuzTc?=
 =?us-ascii?Q?RSXmiADtYIej4uKOs23PZhk/Y8J/0an7bsG6UxbDOpMGL1wBWU9ccU+U2vjz?=
 =?us-ascii?Q?GIbv7JLmethFp/l7qGeH7f0m/Wa8v9c4ScXvGj9vU9/CIKoJ1GV1IUhurqWe?=
 =?us-ascii?Q?o6AiA0vE/ZAQdUzjNNB11JL00OXwoDdC5mRxP+YSFO3FPbO/MQsRMzLbQ4d9?=
 =?us-ascii?Q?3KzcD/Gn4ZNfkNA1HB13izc4qcGem3kA9jMsaq9GrVk02ZZx63wmrbbX9stC?=
 =?us-ascii?Q?M9drpmsrXIX7DE5cvwmfociJVLS/X+s71iNFBrII/ykm96n+XWAmND2GF/v9?=
 =?us-ascii?Q?O9eTvEIoZgFDqip0obGlwR2I2+jTCAEXzYXBXZL9L50HjWckzLXwR+bCKMlH?=
 =?us-ascii?Q?/qvwT1Spwx8/Bds+MGG35rjpBJmOOGaJ/ggQ6vw+w8rZT/L8JtjlZlPJpI/G?=
 =?us-ascii?Q?z+kCfxycEyfpPGkz71VLhUYjXHHBseYhbu5ipQoCP9Bs3uUrQFMiNc0W1UPY?=
 =?us-ascii?Q?IZmVcmMkMQ/H+r0AgJdJZse5qZBhywHrO9LL9wd5vlnHsL2+fzfWeUtjKMXw?=
 =?us-ascii?Q?aTF/4/4SaVWs0l8T63pyY8nyFCmgVuWEDbrczshezkNTK3O+seHCf1chIsuU?=
 =?us-ascii?Q?bslyb3euZvPgoRjYZmW6sco7x0hn3bWScHKbUdE+D64TfSiNW8BSk+lGOPf/?=
 =?us-ascii?Q?MSjZ78NOIIcob1SzVm43TsHNakhs7FUY2i5xTPBYLTNDUnNi7sVg0exQGzcS?=
 =?us-ascii?Q?FIv5FV/omiG0/uZPo0kTIve9LBp7b1ESeeNjAcrDB8LSZfIJLThLSg+NiKwR?=
 =?us-ascii?Q?/7l1cScCXNjXNKr71xqwykY1ZUKudxhPkTfDf50IHbmxkPEhFjbdoVoJNAmr?=
 =?us-ascii?Q?LJKlQuGKyjSRrx1IxuRTSfL3ld/RWZFAy3Mf4eQUdU5MKvTstNzfLbzhKOFb?=
 =?us-ascii?Q?bY/5Snq6TSkbEyCFm7anp44TTL2/laix+pj5Ex3YfgdsZOeUcab05Gbv3tsV?=
 =?us-ascii?Q?if4zpi0nL3YDjxF76NySU3mEvzT1EOFejbLINiGQSmNbr0qw7i7WeVVa1R2L?=
 =?us-ascii?Q?qpCy139jRwPK5I/OLG4AYPcBBqaiKxdhfShI8/ZuGHUkL5aYYR9YgiawuuhM?=
 =?us-ascii?Q?3nODHz36cD0YPBBgy4FCZbv8JqOt+OitKSlX2Q4mVmTgTNM32Cs0P6OPl8h8?=
 =?us-ascii?Q?0Z6ln9udQbniGQWSCOGM7Wu7cV8r6nBVQQ0IcEJe2a2jVSCQFBepKV4BZeTp?=
 =?us-ascii?Q?gbaJoV9XChei0/In/1vbN/iRgSnp5DKaOGyoAtJBYpWcbo8x8Xe3VfimepoI?=
 =?us-ascii?Q?RAiq/vOlDMIa2k0Q1rMAStkVI4HuW7aSDoFHHh3KZUd+fM8bE5oFIyAaNNsp?=
 =?us-ascii?Q?wYMtZPeX4NOpA6VsLQzw7bJrSIgfhqELrZ8H2hkyDBp0t7LBNWjF3Lc16czJ?=
 =?us-ascii?Q?QWNayFnqPit59Fm9hqZUvP9epOCjzZT/PM13e9iaOxLOOTo0dpb9dzAleG+P?=
 =?us-ascii?Q?xoKFAg=3D=3D?=
X-OriginatorOrg: routerhints.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6621a02-39cb-4f19-31b7-08db0d41f757
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB7454.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 21:41:58.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 28838f2d-4c9a-459e-ada0-2a4216caa4fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qcr/jNfGzAPmCBRvZYxG5aMteZ6mDuo8Ew73jF+pyuDl7oAeuyGtwGeCLrdxRc8npnofPp79ItZ3o+pXzV1KMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7149
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 drivers/net/dsa/mt7530.c | 124 ++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 81 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3a15015bc409..f98a94361c84 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1027,6 +1027,12 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 		   MT7530_PORT_FALLBACK_MODE);
 
+	mt7530_rmw(priv, MT7530_PVC_P(port),
+		VLAN_ATTR_MASK | PVC_EG_TAG_MASK | ACC_FRM_MASK,
+		VLAN_ATTR(MT7530_VLAN_USER) |
+		PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT) |
+		MT7530_VLAN_ACC_ALL);
+
 	return 0;
 }
 
@@ -1229,10 +1235,6 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			   PCR_MATRIX_MASK, PCR_MATRIX(port_bitmap));
 	priv->ports[port].pm |= PCR_MATRIX(port_bitmap);
 
-	/* Set to fallback mode for independent VLAN learning */
-	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-		   MT7530_PORT_FALLBACK_MODE);
-
 	mutex_unlock(&priv->reg_mutex);
 
 	return 0;
@@ -1242,15 +1244,6 @@ static void
 mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
-	bool all_user_ports_removed = true;
-	int i;
-
-	/* This is called after .port_bridge_leave when leaving a VLAN-aware
-	 * bridge. Don't set standalone ports to fallback mode.
-	 */
-	if (dsa_port_bridge_dev_get(dsa_to_port(ds, port)))
-		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-			   MT7530_PORT_FALLBACK_MODE);
 
 	mt7530_rmw(priv, MT7530_PVC_P(port),
 		   VLAN_ATTR_MASK | PVC_EG_TAG_MASK | ACC_FRM_MASK,
@@ -1261,27 +1254,6 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	/* Set PVID to 0 */
 	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
 		   G0_PORT_VID_DEF);
-
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
-		if (dsa_is_user_port(ds, i) &&
-		    dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
-			all_user_ports_removed = false;
-			break;
-		}
-	}
-
-	/* CPU port also does the same thing until all user ports belonging to
-	 * the CPU port get out of VLAN filtering mode.
-	 */
-	if (all_user_ports_removed) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		struct dsa_port *cpu_dp = dp->cpu_dp;
-
-		mt7530_write(priv, MT7530_PCR_P(cpu_dp->index),
-			     PCR_MATRIX(dsa_user_ports(priv->ds)));
-		mt7530_write(priv, MT7530_PVC_P(cpu_dp->index), PORT_SPEC_TAG
-			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
-	}
 }
 
 static void
@@ -1292,36 +1264,24 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 	/* Trapped into security mode allows packet forwarding through VLAN
 	 * table lookup.
 	 */
-	if (dsa_is_user_port(ds, port)) {
-		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
-			   MT7530_PORT_SECURITY_MODE);
-		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
-			   G0_PORT_VID(priv->ports[port].pvid));
+	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
+		   MT7530_PORT_SECURITY_MODE);
+	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
+		   G0_PORT_VID(priv->ports[port].pvid));
 
-		/* Only accept tagged frames if PVID is not set */
-		if (!priv->ports[port].pvid)
-			mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
-				   MT7530_VLAN_ACC_TAGGED);
+	/* Only accept tagged frames if PVID is not set */
+	if (!priv->ports[port].pvid)
+		mt7530_rmw(priv, MT7530_PVC_P(port), ACC_FRM_MASK,
+			   MT7530_VLAN_ACC_TAGGED);
 
-		/* Set the port as a user port which is to be able to recognize
-		 * VID from incoming packets before fetching entry within the
-		 * VLAN table.
-		 */
-		mt7530_rmw(priv, MT7530_PVC_P(port),
-			   VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
-			   VLAN_ATTR(MT7530_VLAN_USER) |
-			   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
-	} else {
-		/* Also set CPU ports to the "user" VLAN port attribute, to
-		 * allow VLAN classification, but keep the EG_TAG attribute as
-		 * "consistent" (i.o.w. don't change its value) for packets
-		 * received by the switch from the CPU, so that tagged packets
-		 * are forwarded to user ports as tagged, and untagged as
-		 * untagged.
-		 */
-		mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-			   VLAN_ATTR(MT7530_VLAN_USER));
-	}
+	/* Set the port as a user port which is to be able to recognize
+	 * VID from incoming packets before fetching entry within the
+	 * VLAN table.
+	 */
+	mt7530_rmw(priv, MT7530_PVC_P(port),
+		   VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_USER) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
 }
 
 static void
@@ -1526,20 +1486,11 @@ static int
 mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			   struct netlink_ext_ack *extack)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct dsa_port *cpu_dp = dp->cpu_dp;
-
-	if (vlan_filtering) {
-		/* The port is being kept as VLAN-unaware port when bridge is
-		 * set up with vlan_filtering not being set, Otherwise, the
-		 * port and the corresponding CPU port is required the setup
-		 * for becoming a VLAN-aware port.
-		 */
+	if (vlan_filtering)
 		mt7530_port_set_vlan_aware(ds, port);
-		mt7530_port_set_vlan_aware(ds, cpu_dp->index);
-	} else {
+	else
 		mt7530_port_set_vlan_unaware(ds, port);
-	}
+
 
 	return 0;
 }
@@ -2225,10 +2176,16 @@ mt7530_setup(struct dsa_switch *ds)
 			/* Set default PVID to 0 on all user ports */
 			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
 				   G0_PORT_VID_DEF);
+
+			mt7530_rmw(priv, MT7530_PVC_P(i),
+				   VLAN_ATTR_MASK | PVC_EG_TAG_MASK | ACC_FRM_MASK,
+				   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
+				   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT) |
+				   MT7530_VLAN_ACC_ALL);
+
+			mt7530_rmw(priv, MT7530_PCR_P(i), PCR_PORT_VLAN_MASK,
+				   MT7530_PORT_MATRIX_MODE);
 		}
-		/* Enable consistent egress tag */
-		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
-			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
@@ -2412,11 +2369,16 @@ mt7531_setup(struct dsa_switch *ds)
 			/* Set default PVID to 0 on all user ports */
 			mt7530_rmw(priv, MT7530_PPBV1_P(i), G0_PORT_VID_MASK,
 				   G0_PORT_VID_DEF);
-		}
 
-		/* Enable consistent egress tag */
-		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
-			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
+			mt7530_rmw(priv, MT7530_PVC_P(i),
+				   VLAN_ATTR_MASK | PVC_EG_TAG_MASK | ACC_FRM_MASK,
+				   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
+				   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT) |
+				   MT7530_VLAN_ACC_ALL);
+
+			mt7530_rmw(priv, MT7530_PCR_P(i), PCR_PORT_VLAN_MASK,
+				   MT7530_PORT_MATRIX_MODE);
+		}
 	}
 
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
-- 
2.30.2

