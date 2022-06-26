Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1BC55B1C3
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiFZMFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 08:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiFZMFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 08:05:38 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C21F13D07;
        Sun, 26 Jun 2022 05:05:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkeAcYV9Cac5P74GMtXNor7TH8/HtHAY9D+vRy+SpC4kQNfEGNHvM/fy19NSs/Xu/rT+rHPVWo4TFzYP+1Wx8Toyc2UK0NXsipdkc598GcwiL6Xbkqu/dPAaWwzwPYkQVpSUWNerAY3/KbbcwPhGwYrvtKoYrJMzd7vERJJacSOMfWIN4U8lIWd8DPrLgkPlJ5NA5+w//o46twGCA348IU6BJ7Fk8L4rodBeTSBKXbGRbdldAhYLHB7qXpRcwJNSAOyGEWkCB1NqSlahFMmCkhZRcEKfws9Dw/P9Ac1iRKMdpbBoziEkErHo5SgLDUQc/co8FkHZqAg48t8f2oRb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5zvutlc6JN4gIlSVY0GClzQvJ8NysgJsTwpkCZZkbM=;
 b=D8q3WOfEFdfU62WkI9hR7iSzoSRyUEnNp/XbvQ33/uUqdc7wU5KQc7JUCUxuhoewy1Mut1AB6k2RgNy1goYyIpchUVS/WM7ZVsdf1gV1CN8xk8QWPLYzy6EOIa6mXDUk3Jf0/hI7QdjCyGKGeLJIlht4WesO3vWFOT/WcEWGiPtpB8QSrzG3XzR3koqxXnQ+3ZRzQqBWu4AVaWvcoNZ5gcK2t20dOUlXJvm3i5L+32FhSutQUq45CmFip5JFLGuHJBJaVrJnw1IiIHW4CzRb9ZhljvfbpoBMXsxAcbYER3XgvWhS4GKIHW2JsjlV1KW+CLRH7ESl0pe9QrbXX+HhUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5zvutlc6JN4gIlSVY0GClzQvJ8NysgJsTwpkCZZkbM=;
 b=HP/RAR3KS0g+1IbWPNNbqGC9xwAEu8idXWg/h27TxyBffZXr8G4BZZknXv+3p5LzTXQaiT4Y9OidiuZ0Y/oKPR82qkTVDJopU4FpIArjaO9xdP2MxN53Fo4R9Hpjxbx+wJQ232gqXRrZx6Fxv+oG5CrfHcdofpHeChyHBuQbUtw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Sun, 26 Jun
 2022 12:05:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Sun, 26 Jun 2022
 12:05:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: dsa: felix: keep reference on entire tc-taprio config
Date:   Sun, 26 Jun 2022 15:05:03 +0300
Message-Id: <20220626120505.2369600-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0401.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53e98a5a-e1e0-4cc4-7d2e-08da576c2d2e
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96teevo94FgVh+tIoC0r69Hnxpso76wIunIIDv6HHviviZCUA1eDy6w5rYIsrtpyDN+MjrcildElRBd6+mHhBBGECi9AtTbKgtucEzoWUnDMJ9QGjuAoT5w9STR7VjSnbzIkpYVv2gCpWRCd09HS1prcK/4a1bpo8Je0qi22r+5rd7fNCdGhPTlj813vepCmkdRxe1KzzksiZtGp48ef0yz5ewQQOrZaUx34C4t6WQLNGtkphHyXvjCBug8WxnPWxuKA+FJ0z6pKE/wBT5GO52aUpNV+saMQXGdjuUVMmkI06bbSAd+9XH4Z2rjlCyIkLU14UWLy3XbDL8RNH55tu6HUCO5QZq2g5dlMfqhV9OPudFVBvY+1gCqX0CM10QB/HzqS6BUZY3JmhlPOEBSxYcxnoU9bbN8wV3flb8INRAWxqAE4L8mbShZqHIpN1Nonrt3aYb1sWUBxQ2+YAz2u2gL2+rn7FAzw1zUBZmcB1FGGg19K+SUr5CZPX3EL4mkG0wSM5ojijD+Lh15tC6NKDxVdmsKwx2QNecUQ38J84Jayfr0Wcipa4Ywo17+B4vvCRMfmS6eNrfbemGATPxOiYqxI5wuB5uIXJy3WUFfcJCUiDXajaPYZHvQVMVz7WRMaB65UmOyYeEiSzZTI8+E448Vx33ct0ZhrCuSj4IH6Elfhehivitid9BDM8XMEaekjwJWDGGm/jCw6TWUTNBVHUg1uZsi/JP2TlFpBlwtG3JDCHtiDMnkw4m911wXP/PGGXuLxNETfFrMW+QmyOx/SMyjDcv0lfTNEm6ePK6p8BgM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(38100700002)(316002)(83380400001)(86362001)(52116002)(2616005)(36756003)(6506007)(38350700002)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(8936002)(7416002)(1076003)(186003)(41300700001)(54906003)(2906002)(26005)(478600001)(6512007)(6666004)(6486002)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fUSHaF6nhJ4bP1U2l97uskOD7LLolqZSa3x0sLZfXYxY56AXfIa1p9X7JbW2?=
 =?us-ascii?Q?UmxxXYIh9X3vAHBGEMXMjVdE40oQW3tBy/ViUPpPdUUfP2Wh6h3hNBtefX/4?=
 =?us-ascii?Q?6/JOw2k5bqiDMaZfn8Cq8mX0ZQFu7jBFrFNqsUSCIkY4kIxXvXI209iJBYzj?=
 =?us-ascii?Q?pfKGmKJ8nMMFzrbDqGj00QRKSdVAajnYKBKPMbUlaA91iCOoRiGAVMr/epWW?=
 =?us-ascii?Q?mSF7KE4vCX7NWz4kiOoFMEUEBraBr+E2BvLdX8GrLFREBXEx3ttzbZKVL5N2?=
 =?us-ascii?Q?nbdJaTCyUgsQ0cwTCoMPMYfJcRSiI+nesc/jkUjUD/Bbu5zbBe9OCqIRFRZp?=
 =?us-ascii?Q?M1jMEzJm+cDrzWCST2/y2mfmdvmI6FiavHnZo6DzH3gLTqAmTNQAvK5mHe3L?=
 =?us-ascii?Q?I2899+M76r+Ya+kwHIwMDtTYws4X60hXQqqHbWEsXHHLEIyEZJP6/D/Opye+?=
 =?us-ascii?Q?o3Aa3xB/jJ5OlROWTkZDj/0Tjyck25y7Y88ckXL9uxmJiHH4MbN6zXZEghtJ?=
 =?us-ascii?Q?WXHetwGKelg2IZlFMBQeh1l4B8pBu6tEySnCYorVmi/A/FBOyDL8zYx8KR6H?=
 =?us-ascii?Q?dIGwGp7uQArNQzEOl7H5dQ9CtBLIwin4q1vF73ZFrR87d1ZuCzLmooGttoAw?=
 =?us-ascii?Q?cju/+jH0GvPLZA3GtIjP2NPEeJFOxziGAPmK5pbXRQZOjsnediPtE3a4qOIQ?=
 =?us-ascii?Q?8DC2/1v2UXCdRnphADUrCohne70XsW3echg0MFifbFhfv50PSVvOicDoiXjA?=
 =?us-ascii?Q?zAuFkTPK9WXs1c1+dAFmmCkP5lwAMQjnwSqkjyKxOcy0gmwJv3gNPuzx3MWP?=
 =?us-ascii?Q?cqwQWgP4RVgpcQRPi3qsuIhtVQ8D4JhgucGMn1/qcUVQP1cWfOX9XRBKyihQ?=
 =?us-ascii?Q?Z9jTXNC8jy2wAxVuuNGRd9YTnozLn24oRmROsEoHRZburlZQdhUobVImtobS?=
 =?us-ascii?Q?CXKMdaD/iFrjsjtoODMbyY8h1b+Ss4rvv+dMcVeB9BpzJl+untX6W4bOiK0c?=
 =?us-ascii?Q?J3ZrtIkkQKWkyWBkxiESy6Td3cOj7Z7HKbmpUpIqH5LJ/01w1Oz0uO/Gs9+D?=
 =?us-ascii?Q?LkpJ9E6l8jNJudYOBcH1qXOL+UjBlhd3ZZfkKZ0AlyzWlcQ5SY9gDhlbn14g?=
 =?us-ascii?Q?BKrszW8YMQTEajBbf6TFdbB61DFm4AgSumsAN0RRaHcZp/fp378SGIwZCZNq?=
 =?us-ascii?Q?dzx2fTEcbRCAXs3XmC+FImk3Uiu0RBClA9xLO9pcUqfxfeBfGicg6Exguogl?=
 =?us-ascii?Q?sru2BOeN9o6pxNURrP34bI0jOQVjCQtv6E5Lny+fxpIpLJ+wEPScD41IBi+Q?=
 =?us-ascii?Q?7wTcthikD3XDxK1ED6cxm3UG4eyPe3zvpRoPiZLwNLjrrjtOaApIsNS9hnHw?=
 =?us-ascii?Q?A5giZ0rwMMHVjh6wLX9z1AZ5ro5Q/7KFTLqGldwtL8zSNPgBVApJFSCXGccx?=
 =?us-ascii?Q?vEe2FNXfFJ+X6Ztj8MatkjM6eSmA1Lv+AMXe6dxk+1nOgjq7kznRNAaaIipO?=
 =?us-ascii?Q?sV+iKBjnWMgOABaKIn3XdoWdv9wYx7ans3HYmfF7dAjM/ZiU35OXoNMxpcKU?=
 =?us-ascii?Q?4zkRuiIHZw9fLn4z4ERxOvzevp7PETQ1TuV7MZ3LYci9Fw2S8K7StgeBvMOh?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e98a5a-e1e0-4cc4-7d2e-08da576c2d2e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 12:05:35.3546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSehuEu0/tVpsa/i3VVtuG8U/syB0SOCCV5yXEqrGnatAxsS1b83khJl/B0S7eAeRkzla37av9nd7eFDBwOtQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a future change we will need to remember the entire tc-taprio config
on all ports rather than just the base time, so use the
taprio_offload_get() helper function to replace ocelot_port->base_time
with ocelot_port->taprio.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 23 +++++++++++++----------
 include/soc/mscc/ocelot.h              |  5 ++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dd9085ae0922..44bbbba4d528 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1210,6 +1210,9 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
+		taprio_offload_free(ocelot_port->taprio);
+		ocelot_port->taprio = NULL;
+
 		mutex_unlock(&ocelot->tas_lock);
 		return 0;
 	}
@@ -1258,8 +1261,6 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES_M,
 		       QSYS_TAG_CONFIG, port);
 
-	ocelot_port->base_time = taprio->base_time;
-
 	vsc9959_new_base_time(ocelot, taprio->base_time,
 			      taprio->cycle_time, &base_ts);
 	ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
@@ -1282,6 +1283,10 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
 				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
 				 10, 100000);
+	if (ret)
+		goto err;
+
+	ocelot_port->taprio = taprio_offload_get(taprio);
 
 err:
 	mutex_unlock(&ocelot->tas_lock);
@@ -1291,17 +1296,18 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 
 static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 {
+	struct tc_taprio_qopt_offload *taprio;
 	struct ocelot_port *ocelot_port;
 	struct timespec64 base_ts;
-	u64 cycletime;
 	int port;
 	u32 val;
 
 	mutex_lock(&ocelot->tas_lock);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
-		if (!(val & QSYS_TAG_CONFIG_ENABLE))
+		ocelot_port = ocelot->ports[port];
+		taprio = ocelot_port->taprio;
+		if (!taprio)
 			continue;
 
 		ocelot_rmw(ocelot,
@@ -1315,11 +1321,8 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 
-		cycletime = ocelot_read(ocelot, QSYS_PARAM_CFG_REG_4);
-		ocelot_port = ocelot->ports[port];
-
-		vsc9959_new_base_time(ocelot, ocelot_port->base_time,
-				      cycletime, &base_ts);
+		vsc9959_new_base_time(ocelot, taprio->base_time,
+				      taprio->cycle_time, &base_ts);
 
 		ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
 		ocelot_write(ocelot, lower_32_bits(base_ts.tv_sec),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3737570116c3..ac151ecc7f19 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -670,6 +670,8 @@ struct ocelot_port {
 	/* VLAN that untagged frames are classified to, on ingress */
 	const struct ocelot_bridge_vlan	*pvid_vlan;
 
+	struct tc_taprio_qopt_offload	*taprio;
+
 	phy_interface_t			phy_mode;
 
 	unsigned int			ptp_skbs_in_flight;
@@ -692,9 +694,6 @@ struct ocelot_port {
 	int				bridge_num;
 
 	int				speed;
-
-	/* Store the AdminBaseTime of EST fetched from userspace. */
-	s64				base_time;
 };
 
 struct ocelot {
-- 
2.25.1

