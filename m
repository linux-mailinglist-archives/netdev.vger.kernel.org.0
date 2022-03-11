Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CD04D6A45
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiCKWvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiCKWvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:51:33 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813272D34B7
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 14:25:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEM0ewJeqqzGU9Ngx8hOzZcwun2YJdW7B678MmXMxCQqyPafNDlrLguTIbLGazmx0MAc6rvymYN+s7pGhz7xRoi0FLOlQ1xUjp6+3iHhV512cVU1yVzZ89hHUnJxATLsvSHqO+SoqZF60FO2ZdbTR2wXzqS3hAOaVg/9Hziu3CoVOn6Cm78ibcFopmJRfE4yNQCTcfY3O5oVZblu1i7UVD7idIt8hbXdAJDTtOSnSzU9j6pDj1g0PU0wjm2cFm8IjZULS+EE31W+aFP0mTmwrETeNIdP4280LIqLh0B/HnIJca0XVdFYKPuOqesXVFyjp7I+FbwNUN5mBjuUkmA76A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Vwt9FtCvYzEhXgxr1gv2K9Sv+YQbLtoObEzHClRLIY=;
 b=DN6PtrRMQYSj1ZM8D580rLd4OGZ7FkuFqcGVnnnsUVIgUk7NYH2Nfl+1Pn0nXV0wL+sfgnK0tN24A73D7+vajov7RK+z3ind2LxRpttqqLHNc0Rt7S6z6zvaf9x397/LSbJS+ZjkBkTg0tRRHqJCl/fYoLELs2bk3ihvoEyjWd9Q1ZymHtbdC8lzDxdO2TerldaFgarop5apc/NZVPALDxpSQIKSXQKCiD3ZU0jJ0hFNoB699ogf2w7F4sF5dOqXykNVMpUMUj9wOiknLUpsXDbT3WW2yQflGsGGNweSlapsTiiA8+uON/kI7r/7YcX6CxmzPhYxxucGXTHqArZNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Vwt9FtCvYzEhXgxr1gv2K9Sv+YQbLtoObEzHClRLIY=;
 b=OwheHpl4H0FbjtY0j9k8BR3T2WMZcXRuCCFBdHy08pXkzX6ayZdVzbInEW/GKo16GVf8drUpZeTpLUbkBTMbA5LujDwMCZeTyFIDk4v75XNxXOm8CND1wJv1QpGoJG6t4FnbTKkQ4KH2YYw1iamJ3qNJub/I+jY6C993eD0wuC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8934.eurprd04.prod.outlook.com (2603:10a6:10:2e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 21:15:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 21:15:33 +0000
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
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 3/3] net: dsa: felix: configure default-prio and dscp priorities
Date:   Fri, 11 Mar 2022 23:15:20 +0200
Message-Id: <20220311211520.2543260-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
References: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0188.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a701860-1373-430a-8821-08da03a4478a
X-MS-TrafficTypeDiagnostic: DU2PR04MB8934:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8934952517CDF73DB199188BE00C9@DU2PR04MB8934.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UM970Vb2itfZc94imhf1rnrSPpPg1bMwuK16jp11I2EK2t0W2mHOXOOKN3xWGBsz7Kq9wqrG8XVuI6kySL91kTMnYg6y84Ya3ikbKHwjogrOQABk+4kZ9aiw0oqHs47io9XX+K2keePV35gSx6TJX3gHfcAPm1SsHY3G4pBsXpiJOnbqeU3EaH72rxO4TUpcn9B07J0Y+rplI+wsHrQ/UyZSex/Xy1/WOrXyfkwRpaH4WFsnOcid1GemWJc2hrLWTaljHvcujXs+l7Jg0YCavxJ/kZDt5IcxY5EsO8fE6rYkfw1a4IDWVrpWSENzSgh/pah01C7J98cUxk1XU7R8U2FthUHcRW7jOMtvrXyrfjyt9gHkM6xKqPwGBMnloktVeUT/aD3yUuNi9prUN/z/QUoKcCrSZHXOGJjXtOxbLJlx3eIjUZHOeHjX6o7WbDr4TpifxAmBRJ3gMTgip+96fPOKOCXXnjAlvtzMJwjFLdsB/0HA/Eugg9OstP8KGSitLMmJ1QCQovXUQOfrmZy2Wv2d+x/nnOU+ngrxBBosXaCjk5eG0qxZ8I28ytdyJ4P2yRR4yLZUo9GpqOCJVG3+U0nnd+iz0oIs5LoBkUxa7ICaxtBEHypTHODU3ASOf0wp/cNt68yg3aH8Fof0q0LuRdYS5jG4ObOxBVC4amtGntZVafMrPZkMQcylL3DojDJeSusjpKmrSGAaIoLqd7FbVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(36756003)(38350700002)(1076003)(54906003)(38100700002)(316002)(66476007)(6512007)(83380400001)(86362001)(508600001)(2616005)(2906002)(8936002)(66556008)(7416002)(6666004)(26005)(6506007)(6486002)(4326008)(8676002)(66946007)(5660300002)(44832011)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35k6Cynxma5b4t0eBzpNy2TrSbSsaVb/r0j+4lt34+D9srbuUVW6ewXYcnLj?=
 =?us-ascii?Q?6iKCPRpIIAFfJU9kgNEiXDhDRfSHjjVUv5m1TGJrx3whGTvtUSYzrx9KIyYf?=
 =?us-ascii?Q?zrBmsBi0v6O2KIb6zrfOxxQZJx95KWDVAlzOQ4TWzReVD7wgjw2CIoU7cdQ3?=
 =?us-ascii?Q?hoDXWbC7ThWjkTrgRwlYoS0AovKFdb5Ux6I2ypCNn5ubLighfsXVOzPBpjuD?=
 =?us-ascii?Q?T6zP1hANC4xw2/KmFi3G8uQabQyOntU+g8a7hWS57LEP8oG9pJ46wkfe3dQt?=
 =?us-ascii?Q?R6H1L5mp9LiBSbDO17qwa/wCTlaSfgzYWEZwyNta/9id+F9+nj/nEsDHWCky?=
 =?us-ascii?Q?VsF61WZJkKyKhhWZ/fCILk/Lr7RzeJplNzonCGgcInZGe5qoP8iDpeFhSQdZ?=
 =?us-ascii?Q?ASDf0ErsD9XflHjuZb1P5EwjN/9weu7uC92v7bvTcDz7UnO1nHixYq0hnuOr?=
 =?us-ascii?Q?Bw8Uygq1g7MJaUQVmHACWEUyCPEprXlHj96O8hVMGh3xNiABj02qxQbnXZmG?=
 =?us-ascii?Q?9M2flDPqEM0aI4Ir9KfVH7muh1BPO0Vq7K3A6zdantDBOeqTlEjT6bfzc7Dh?=
 =?us-ascii?Q?K4cZUkC7VvtLChPiIB0PJdWpCjKM4uTxhaoZUr6YjrqVintfBS9wu8d50Yh3?=
 =?us-ascii?Q?2mZ5UDOTWkUOarpDi8nPNCs8IJWzaqwUnR2/SZFdKORbAuxxRrCanYUQWvRG?=
 =?us-ascii?Q?7prw4z8jSNyD68CPodgVRw2gnniI0n++QXRdhc/ZHrazNrSAl2zmzzfyWwo3?=
 =?us-ascii?Q?uo7p7/km2SxpI6EPVCRbJGXtYbhmG1PMaF3p5bOMOs6g4Y39VlmVidtMCezV?=
 =?us-ascii?Q?WU1MJVozQ9KSZwOpfcVN+SJhblVcRIgPygN3pVTYOuPAoOsTpw5sInqrXIsY?=
 =?us-ascii?Q?+trPu+FQgBzY6hqa47lLyGknj58yd6uKJj3/FeKq0hATOIF8+XEJQGNfqWwN?=
 =?us-ascii?Q?OB9Lz5SwDqukMmm0KRtNExA6FOog0hYrzQwoWw+E3lzTkexXoUf2XSpwM2Ro?=
 =?us-ascii?Q?fFPk0NmeRXejQqKTEJQOIoRpKQCiaArnux1gepfTDN8rEQBTbZjjYmcKhJ+W?=
 =?us-ascii?Q?zrTbJ/hfsV01rxQPV4STeTO1UskQOFn08i3N6TRk6tmidXNas+SRPGH4Xw9H?=
 =?us-ascii?Q?/jj8DrKO/gCgC07XJ3GfppGMzpEEZBtualXq4Innfn3ZOb34QZYZ0kfhepIz?=
 =?us-ascii?Q?Irx1nS6BttvM1/tsba6KyWK7Ki1REXa+5hC6f/wHQSZxcKjyA0wmg0Bx6E22?=
 =?us-ascii?Q?w5tbRgNksYEzCaKBEOVLWaaNp/11Y7d+JpGxsLb3nRLQSp66kTqHH0+n3E7X?=
 =?us-ascii?Q?PI+t/NK2VUma4swg8HG5QqD1WTPs5ZQfMzqrkBaxiRV5E4fUxcum+WSiHHjZ?=
 =?us-ascii?Q?ux+6aSN9veD1+Rnvo0iGwHZ4B4ljhUmKTCYbf6Mqe3SVD7wlb9zV2rrCFXjm?=
 =?us-ascii?Q?tKvick861SQJL5PvEqTcgWQ/LZOjnyfNaNIhLrckysMGTlqhgotCrg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a701860-1373-430a-8821-08da03a4478a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:15:33.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeP8SF5lEbmsmLCJOgvYbLIrpJ6v465A9DAMTBND4Ybev8VwE4apHcRhl0S1ofQzNbgqVQyeDNcqcd2JNOveXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8934
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the established programming model for this driver and provide
shims in the felix DSA driver which call the implementations from the
ocelot switch lib. The ocelot switchdev driver wasn't integrated with
dcbnl due to lack of hardware availability.

The switch doesn't have any fancy QoS classification enabled by default.
The provided getters will create a default-prio app table entry of 0,
and no dscp entry. However, the getters have been made to actually
retrieve the hardware configuration rather than static values, to be
future proof in case DSA will need this information from more call paths.

For default-prio, there is a single field per port, in ANA_PORT_QOS_CFG,
called QOS_DEFAULT_VAL.

DSCP classification is enabled per-port, again via ANA_PORT_QOS_CFG
(field QOS_DSCP_ENA), and individual DSCP values are configured as
trusted or not through register ANA_DSCP_CFG (replicated 64 times).
An untrusted DSCP value falls back to other QoS classification methods.
If trusted, the selected ANA_DSCP_CFG register also holds the QoS class
in the QOS_DSCP_VAL field.

The hardware also supports DSCP remapping (DSCP value X is translated to
DSCP value Y before the QoS class is determined based on the app table
entry for Y) and DSCP packet rewriting. The dcbnl framework, for being
so flexible in other useless areas, doesn't appear to support this.
So this functionality has been left out.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     |  43 +++++++++++
 drivers/net/ethernet/mscc/ocelot.c | 116 +++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h          |   5 ++
 3 files changed, 164 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 35b436a491e1..13d6b178777c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1799,6 +1799,44 @@ felix_mrp_del_ring_role(struct dsa_switch *ds, int port,
 	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
 }
 
+static int felix_port_get_default_prio(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_get_default_prio(ocelot, port);
+}
+
+static int felix_port_set_default_prio(struct dsa_switch *ds, int port,
+				       u8 prio)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_set_default_prio(ocelot, port, prio);
+}
+
+static int felix_port_get_dscp_prio(struct dsa_switch *ds, int port, u8 dscp)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_get_dscp_prio(ocelot, port, dscp);
+}
+
+static int felix_port_add_dscp_prio(struct dsa_switch *ds, int port, u8 dscp,
+				    u8 prio)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_add_dscp_prio(ocelot, port, dscp, prio);
+}
+
+static int felix_port_del_dscp_prio(struct dsa_switch *ds, int port, u8 dscp,
+				    u8 prio)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_del_dscp_prio(ocelot, port, dscp, prio);
+}
+
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.change_tag_protocol		= felix_change_tag_protocol,
@@ -1862,6 +1900,11 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_mrp_del_ring_role		= felix_mrp_del_ring_role,
 	.tag_8021q_vlan_add		= felix_tag_8021q_vlan_add,
 	.tag_8021q_vlan_del		= felix_tag_8021q_vlan_del,
+	.port_get_default_prio		= felix_port_get_default_prio,
+	.port_set_default_prio		= felix_port_set_default_prio,
+	.port_get_dscp_prio		= felix_port_get_dscp_prio,
+	.port_add_dscp_prio		= felix_port_add_dscp_prio,
+	.port_del_dscp_prio		= felix_port_del_dscp_prio,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 21134125a6e4..41dbb1e326c4 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2907,6 +2907,122 @@ void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_bridge_flags);
 
+int ocelot_port_get_default_prio(struct ocelot *ocelot, int port)
+{
+	int val = ocelot_read_gix(ocelot, ANA_PORT_QOS_CFG, port);
+
+	return ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL_X(val);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_default_prio);
+
+int ocelot_port_set_default_prio(struct ocelot *ocelot, int port, u8 prio)
+{
+	if (prio >= IEEE_8021QAZ_MAX_TCS)
+		return -ERANGE;
+
+	ocelot_rmw_gix(ocelot,
+		       ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL(prio),
+		       ANA_PORT_QOS_CFG_QOS_DEFAULT_VAL_M,
+		       ANA_PORT_QOS_CFG,
+		       port);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_set_default_prio);
+
+int ocelot_port_get_dscp_prio(struct ocelot *ocelot, int port, u8 dscp)
+{
+	int qos_cfg = ocelot_read_gix(ocelot, ANA_PORT_QOS_CFG, port);
+	int dscp_cfg = ocelot_read_rix(ocelot, ANA_DSCP_CFG, dscp);
+
+	/* Return error if DSCP prioritization isn't enabled */
+	if (!(qos_cfg & ANA_PORT_QOS_CFG_QOS_DSCP_ENA))
+		return -EOPNOTSUPP;
+
+	if (qos_cfg & ANA_PORT_QOS_CFG_DSCP_TRANSLATE_ENA) {
+		dscp = ANA_DSCP_CFG_DSCP_TRANSLATE_VAL_X(dscp_cfg);
+		/* Re-read ANA_DSCP_CFG for the translated DSCP */
+		dscp_cfg = ocelot_read_rix(ocelot, ANA_DSCP_CFG, dscp);
+	}
+
+	/* If the DSCP value is not trusted, the QoS classification falls back
+	 * to VLAN PCP or port-based default.
+	 */
+	if (!(dscp_cfg & ANA_DSCP_CFG_DSCP_TRUST_ENA))
+		return -EOPNOTSUPP;
+
+	return ANA_DSCP_CFG_QOS_DSCP_VAL_X(dscp_cfg);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_dscp_prio);
+
+int ocelot_port_add_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio)
+{
+	int mask, val;
+
+	if (prio >= IEEE_8021QAZ_MAX_TCS)
+		return -ERANGE;
+
+	/* There is at least one app table priority (this one), so we need to
+	 * make sure DSCP prioritization is enabled on the port.
+	 * Also make sure DSCP translation is disabled
+	 * (dcbnl doesn't support it).
+	 */
+	mask = ANA_PORT_QOS_CFG_QOS_DSCP_ENA |
+	       ANA_PORT_QOS_CFG_DSCP_TRANSLATE_ENA;
+
+	ocelot_rmw_gix(ocelot, ANA_PORT_QOS_CFG_QOS_DSCP_ENA, mask,
+		       ANA_PORT_QOS_CFG, port);
+
+	/* Trust this DSCP value and map it to the given QoS class */
+	val = ANA_DSCP_CFG_DSCP_TRUST_ENA | ANA_DSCP_CFG_QOS_DSCP_VAL(prio);
+
+	ocelot_write_rix(ocelot, val, ANA_DSCP_CFG, dscp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_add_dscp_prio);
+
+int ocelot_port_del_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio)
+{
+	int dscp_cfg = ocelot_read_rix(ocelot, ANA_DSCP_CFG, dscp);
+	int mask, i;
+
+	/* During a "dcb app replace" command, the new app table entry will be
+	 * added first, then the old one will be deleted. But the hardware only
+	 * supports one QoS class per DSCP value (duh), so if we blindly delete
+	 * the app table entry for this DSCP value, we end up deleting the
+	 * entry with the new priority. Avoid that by checking whether user
+	 * space wants to delete the priority which is currently configured, or
+	 * something else which is no longer current.
+	 */
+	if (ANA_DSCP_CFG_QOS_DSCP_VAL_X(dscp_cfg) != prio)
+		return 0;
+
+	/* Untrust this DSCP value */
+	ocelot_write_rix(ocelot, 0, ANA_DSCP_CFG, dscp);
+
+	for (i = 0; i < 64; i++) {
+		int dscp_cfg = ocelot_read_rix(ocelot, ANA_DSCP_CFG, i);
+
+		/* There are still app table entries on the port, so we need to
+		 * keep DSCP enabled, nothing to do.
+		 */
+		if (dscp_cfg & ANA_DSCP_CFG_DSCP_TRUST_ENA)
+			return 0;
+	}
+
+	/* Disable DSCP QoS classification if there isn't any trusted
+	 * DSCP value left.
+	 */
+	mask = ANA_PORT_QOS_CFG_QOS_DSCP_ENA |
+	       ANA_PORT_QOS_CFG_DSCP_TRANSLATE_ENA;
+
+	ocelot_rmw_gix(ocelot, 0, mask, ANA_PORT_QOS_CFG, port);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_port_del_dscp_prio);
+
 void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ee3c59639d70..4d51e2a7120f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -869,6 +869,11 @@ int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 			      struct switchdev_brport_flags val);
+int ocelot_port_get_default_prio(struct ocelot *ocelot, int port);
+int ocelot_port_set_default_prio(struct ocelot *ocelot, int port, u8 prio);
+int ocelot_port_get_dscp_prio(struct ocelot *ocelot, int port, u8 dscp);
+int ocelot_port_add_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio);
+int ocelot_port_del_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge, int bridge_num,
 			    struct netlink_ext_ack *extack);
-- 
2.25.1

