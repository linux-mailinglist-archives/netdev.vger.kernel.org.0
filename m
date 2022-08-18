Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77595984E9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbiHRN4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245441AbiHRNyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:45 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2082.outbound.protection.outlook.com [40.107.105.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C177748CB8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:54:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNpXucNfutHshQMdCFUBVWEKQUZ5W5mT8UgH0R9i21CY0yGR4fuds0aBg0yvIA9WDrVjba8JeNX1D8hQxftBHLJroARzTkH3M9/FtNh6qhRUTte+W/EBox768VRKn1yuAg+0vLExD7kp1+zuR5MDCFVpUtuQ6qcmOqup7/CFeKbCTD5pN9gk54manO/znqrWITr4xXiZ4bH2/05b07xkCUzJG4ySrZ8F9VybbD6UHHYvlQrlfXDzQu7L5SLobwy0plTzc071IFJdnP5uquYNezG53LZV1Iu3u5fFUYvKr7zF7PlTCmvJVl2u9aU9xmnf0FogxQKivbk2a53I043Gjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHVdB2ZhTs/doedGL+2YYe9oxrYb5flL3/o8zc9of6o=;
 b=Ql7iEsF6pfzEvDc1bFw6SDmfYyaUjL8mcwDnQ+B7FV/vS3xrwLPU+a+a0yeogkIY1ZRIE6U27E2NeQ2TA2hjtvLQVzjXX99aCU5YuI0z3kI+SXi8WIzklC8IDbNQP1k8HUGmi7j2smSYVGC0wqNpPmRl4OZsbUPFM8WwZq9UegxF+cNxA7RuhJ4hA1D/Tz2hbk9a56AxxlK9Bs1GoK+/bcb+MYVRtiaNANtJEK94xT5Y8YwQBElRKQ0SMXKr7jmNPWVkVyYYat/8tq4L9gpTBdv7xaGgKTZjD1aHODBKlAvGJbhYZmgQ4ONTKCEb5wVCv058vQgpVMTPIVX0j/+XVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHVdB2ZhTs/doedGL+2YYe9oxrYb5flL3/o8zc9of6o=;
 b=YNiHo5YwTE8FIIe3blpbEnZ58n7y4WhuXgI89fgKD3+C3CFQ65GvhwQZRM++ZgMQ4/lA6HQVQtKNQ0CE4peMGzNk9TL7TNlkrGrJ2XGhLwNNJMgOSwhnKFEAwNg4Fiajj/ILk1+Zhz6v6nFnA9fP3jSE2XfX8mM5PpqESHMLpYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 9/9] net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG
Date:   Thu, 18 Aug 2022 16:52:56 +0300
Message-Id: <20220818135256.2763602-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18b2abe4-6edb-4d24-6f39-08da812103d8
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KdS6RIXDwXDnY1DLGzw5xhmkrJWYTUtyEJxrSXpjcmUu7Sb6BgmwpEuIlqu0kpxytzUyPlmN/d5hTaAYpWj9pDE9d1aVH4fxu4OvJvf2z6Pfnqb5tWUedDal7ja8TDFXsIblCPBgdrvWBZpCutHuCahWvKlo4vHddzKV9Bk0cT9EyR1LZ264Oxy5zNjyQND8N7cvTWC472qWvuDg2oCD0veYlOU1S5B99hTmsgb9+oi+kcK/E8WNOYifxKEoC6vZcm3fRxKhnfBG6LXTbXLOH4cmc6gVsp0fEEz2zIqcAauFAvrMK5H0jpE8FpkG37lEQ+7gFRxI5HHz6dY3WQrASexdHXNSyAdB4e3ar6v5AXSgBgTRO3xO2yNMinCltKT2fu8fU1St4yILYhy91wtnJd63r+9BxR6zCvrjCNok3zXL5COgrmTKlLuc5TjWghhWn7Q9nTm19ko7NREGCCrJ6mPh4PQpHShDwzbNfPbkx4pUHC8yv5xEFkokBDw0dV0YHDVHpXKlJv8v8gg8kmuQgFxDOoFs4VCMIwDSI6NJ43nM90quhwxGe38iiWZAZzjUM166ix16v/0dL6leahBQVU1bwb/0hEKjfEwHnwgeeW2+mJ2HsR1IS7Xjp+PB5az8JMc2Pgg0L1+L3QoapiHrKFuAxCAtJyb+/Ly/+cA5aBpvQ/YmdXS39ypvPo8MzfyzA8FWlo68OxLMr1plhOpNOff0lO4+1dBD8fbmzsNzNg/laPWelA+PmYmoiIyfVVcz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RK3h2RXykHo2uhIb4to6hjYnfBOAqLqWObFpFLimSe7szM6zCP2iaXKaSeG8?=
 =?us-ascii?Q?+3yWQ6/uVAuXbwF4MZo1bLaqMfBKjXBCjCSNYR96QidAZptX0aMeQoDNcj0b?=
 =?us-ascii?Q?00wYlLl8GotcpedS4bqS1sr5xjGP/41sJOp5qwQT4Qj8wh6NZu0zGrZrZezG?=
 =?us-ascii?Q?jV2N2SRfIecfbKUL0TOSzc8pzqwTfTK7phvjf8LQw2xc9h/Oe5jmTfl5npt1?=
 =?us-ascii?Q?jFnZTd04Z0u3YAHgb/6KaVvyvXq/QjGHppZIrcz0Ryj48+iy8rg9utkcjE+k?=
 =?us-ascii?Q?/IyEJgc2l7/ei1KtUNJl1f4tX+LZUNxVFiBSHGZNSFroCUAbwnTZS6xco/3w?=
 =?us-ascii?Q?mqIxXSspgZ/45ZvHnB7DXRKCsicCzSCvU5NmLgfPlQYEk1DyoTotL0uAEUC2?=
 =?us-ascii?Q?ATsKGD6G1zxVMx2n5D7hWSu1fPdjKeK1A48h8H866wIoycnk3DsN0MzrKpSV?=
 =?us-ascii?Q?Rmz5b7pjFJ+3rdp1n0m6eSFYLnYOWPOEK/gUhQ8pxioTNjIOVHp89iZMzly5?=
 =?us-ascii?Q?Hv/LQeHU6F7ajjkyBYMHSZmeoC6Q6ZB0Ym+YqIeD8SlusezhBnFc54ydavdb?=
 =?us-ascii?Q?HOIPLNLLWSwxR6m37vmuXmkqvMiXrX/ZMFMvIf7bMsb9Cbq0dmJM3tUSYsQ4?=
 =?us-ascii?Q?3HWxANuDBJ+GOf5iZb4j3yf8vXRjICFzmdiZ6+yBg5CI/I6zY43xtTsiyqnZ?=
 =?us-ascii?Q?ch9mGpSKulYxwjGVVmf2A+LVEpZFjV5W7G/DrU5H2ifPKYXei9UX4B09yHUW?=
 =?us-ascii?Q?+O2RYIPgeI30xrFPhHLayi8D+L4eDUC36oki5D0Pj57P6/BKCUdq/BjiP/jN?=
 =?us-ascii?Q?0BASbF22E9SgKINZBXVmCLqSjFzcBoLSrbiVBZ3Nwle/22hwJZjx2GubuOby?=
 =?us-ascii?Q?G/og5CS1W7hXxh7yXJpDkXaQaQlE8Pf1ZxaE+Ykve9U3O0jkn9uyiG64eNrq?=
 =?us-ascii?Q?QN49lJFCQ2D9CtRcTaCvuNxVONk2m0LTXZtf56Pa/CnqwTOm+QP0obqmWxW0?=
 =?us-ascii?Q?wGXuM/S7e6h7zJI2+AMtLDdG3qM2vtPXKt/WARr9+U1zi6sffTYltL1EKb5n?=
 =?us-ascii?Q?Q+Sl6I60wqlMVpi13MP8bbFwzBDx820vgggWxbXB4nx5uwx9rRZ5eV0RqsT9?=
 =?us-ascii?Q?TsSHiH8Enc4S58VS8rKiToSgJdQdVln9wx1W793FKZvAzwfxVj8y5CnXDui5?=
 =?us-ascii?Q?y3f4AnqzFj2JwcGCYVbdYMNhO0sTFN4d8XxfQ+zu+SaXfYEvp+vyQJ2XVHW9?=
 =?us-ascii?Q?8xcPRFnZh0M8kxSTf4rc63UI6xlMyhFammz2DKKVZbLUf1WpTItamd5gPvI+?=
 =?us-ascii?Q?MmJDP/xOqkhoZdxlfnaMTYNNUreGSusy4UHxY/gIXddTYIe09VfzmVVcB8lD?=
 =?us-ascii?Q?Ph9LTiEFbtmduXPZmv5lpORDmwLbSh5FYTrqO7hnCWOsbCfZd2aDrFdc9ZzP?=
 =?us-ascii?Q?O9xXlQEab8uYG5CiC7xX/Zy5e/EdJoWxII5fPWtMxH7vnfVzWmQPQgIbm8If?=
 =?us-ascii?Q?Kzg3tSeQ8uMzb1QEpK366MFCsBmLz9halixWaXE7I47ih9ruv+zqXx/iOj2A?=
 =?us-ascii?Q?5OgCmfHMICUIBcA93b395nXpOcYCkIJmzhCvirA+ingBynI3xli0wOgZq8+6?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b2abe4-6edb-4d24-6f39-08da812103d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:22.6797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5xqNhVtsQAmCxrKqUUxCyPvfAK0v1u74GfJbpsuAd92w1UXMoE7ICvB/1/X4GLrXUOv7KDRefWXADGXe1uL/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when we have 2 CPU ports configured for DSA tag_8021q mode and
we put them in a LAG, a PGID dump looks like this:

PGID_SRC[0] = ports 4,
PGID_SRC[1] = ports 4,
PGID_SRC[2] = ports 4,
PGID_SRC[3] = ports 4,
PGID_SRC[4] = ports 0, 1, 2, 3, 4, 5,
PGID_SRC[5] = no ports

(ports 0-3 are user ports, ports 4 and 5 are CPU ports)

There are 2 problems with the configuration above:

- user ports should enable forwarding towards both CPU ports, not just 4,
  and the aggregation PGIDs should prune one CPU port or the other from
  the destination port mask, based on a hash computed from packet headers.

- CPU ports should not be allowed to forward towards themselves and also
  not towards other ports in the same LAG as themselves

The first problem requires fixing up the PGID_SRC of user ports, when
ocelot_port_assigned_dsa_8021q_cpu_mask() is called. We need to say that
when a user port is assigned to a tag_8021q CPU port and that port is in
a LAG, it should forward towards all ports in that LAG.

The second problem requires fixing up the PGID_SRC of port 4, to remove
ports 4 and 5 (in a LAG) from the allowed destinations.

After this change, the PGID source masks look as follows:

PGID_SRC[0] = ports 4, 5,
PGID_SRC[1] = ports 4, 5,
PGID_SRC[2] = ports 4, 5,
PGID_SRC[3] = ports 4, 5,
PGID_SRC[4] = ports 0, 1, 2, 3,
PGID_SRC[5] = no ports

Note that PGID_SRC[5] still looks weird (it should say "0, 1, 2, 3" just
like PGID_SRC[4] does), but I've tested forwarding through this CPU port
and it doesn't seem like anything is affected (it appears that PGID_SRC[4]
is being looked up on forwarding from the CPU, since both ports 4 and 5
have logical port ID 4). The reason why it looks weird is because
we've never called ocelot_port_assign_dsa_8021q_cpu() for any user port
towards port 5 (all user ports are assigned to port 4 which is in a LAG
with 5).

Since things aren't broken, I'm willing to leave it like that for now
and just document the oddity.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/mscc/ocelot.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7d350c944521..af46ea385c31 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2046,6 +2046,16 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 	return __ffs(bond_mask);
 }
 
+/* Returns the mask of user ports assigned to this DSA tag_8021q CPU port.
+ * Note that when CPU ports are in a LAG, the user ports are assigned to the
+ * 'primary' CPU port, the one whose physical port number gives the logical
+ * port number of the LAG.
+ *
+ * We leave PGID_SRC poorly configured for the 'secondary' CPU port in the LAG
+ * (to which no user port is assigned), but it appears that forwarding from
+ * this secondary CPU port looks at the PGID_SRC associated with the logical
+ * port ID that it's assigned to, which *is* configured properly.
+ */
 static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 					       struct ocelot_port *cpu)
 {
@@ -2062,9 +2072,15 @@ static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 			mask |= BIT(port);
 	}
 
+	if (cpu->bond)
+		mask &= ~ocelot_get_bond_mask(ocelot, cpu->bond);
+
 	return mask;
 }
 
+/* Returns the DSA tag_8021q CPU port that the given port is assigned to,
+ * or the bit mask of CPU ports if said CPU port is in a LAG.
+ */
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -2073,6 +2089,9 @@ u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 	if (!cpu_port)
 		return 0;
 
+	if (cpu_port->bond)
+		return ocelot_get_bond_mask(ocelot, cpu_port->bond);
+
 	return BIT(cpu_port->index);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_assigned_dsa_8021q_cpu_mask);
-- 
2.34.1

