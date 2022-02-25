Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2BF4C4146
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbiBYJYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239024AbiBYJYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:24:10 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B611A94B2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGPAHjeQus4kKqa2bWCMjn+2P0lP1o3c1LohCamVAy3prvcF60IDuFbqaY/DimS0tOsfUXxPhG4urbXVrbbf64FpKyzcaXxJbppuz7jTkg4z4ntH2MO2qCnGEFcCB0sTMrO9Lfa0eo8o0fr9iDGMBtzfv/cO53g/XP3KwkI1BzRt897Q8Xj099g+Zb/dUjS0B35ca31GJpbQ3j/tXf6CEtftE2+QNO10IcsxJhPFLK/CrLn/AmUsJp5X5fXk1hfOTEs6jUHK/j8vg+dTxVgxjWzmpKxtQlcVReezmAehhhA7P6+d9qs2aP2bFAQ6GmEzfu7sAXfO+nBNCIY2HHcpFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5dYlOUaElpoqBmQCIi9xlblCXb4kZSqY4WI51fn/B4=;
 b=Tui5E2m3qPX5H1x440bVq2PRlXDO1fH8PDHRM/AuEo6Zs1FX+C5szAXfIeodMq1Iu/lMGALiVuZyz5llaN3/HgDwToVlhHR91gASLoV2N5CQ1Zc52yLa6wG48EysR7I9udRHbjrKHo/G5QLnoZ1TjwP3p5yMd5T0zdazqDBzjSH9fBtEu5B+3WU6ukW77d/gWfOHABy0/gMXWstFH4vqRQTypo3vIhrKbOC78rXWuvHYxytr4QrFNVQx60g6pGrk2s32BbdotWbJFXJDCk2plXfEjvFot8MZGdbX2ba6YHtznSTEnLqgcKoOZhPn1qnUtPpwciNuTuuT9NaeWS3w7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5dYlOUaElpoqBmQCIi9xlblCXb4kZSqY4WI51fn/B4=;
 b=Tkx9opRJqekje+xfKlvxODX2Q3WseoFYMVtpO5/czkAcQyzHPmG4j8f7D0QXowGzFMdNgUY27TvH2/IGEX+oRHshKPoX/6s092kzr9LbhGi/SqRuaRq0cF9DoLkL+Hva2wUzqZ55OH6xlqpOXit4cFNoPKsqBeTEdOwbi+FaWiA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 10/10] net: mscc: ocelot: enforce FDB isolation when VLAN-unaware
Date:   Fri, 25 Feb 2022 11:22:25 +0200
Message-Id: <20220225092225.594851-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b87ebc5-5727-4753-3ae2-08d9f840713c
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB76582F74A9CE3539EAF84141E03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlgKwoWWmGStv1JTtuj4G1mmC0NW4W+t94xeBYt+UUfUMxv5T4BDfnESq2adjbf4HyBC4Nvpi3PCHKBEu/SbT2e+A/gQqgwQ5WZuhyd5FJFKgazU2ePMoptsh2d3UnZRbbNPvviG5bQZQOC+YqkRhkSCUymH7Q3i1H4VWK5nysLwnH8egr9fVFtY9mNww9c721h/O1gLIr+dMrTRSYLOuNcC9cyFzhp+f9PY1G3AyMQhCBjzutDkuFPfk9+wU9lj33uqwKd89z7amVm/BA/GsuMpvnZ4MkPGURv563atMJr7d+lBjMboy0+zDrXiZZe621rq5uGSEz8r5skkS3Hxo6gljxykw9JfxPQUq9Cj2Hq+OcfunxeFyvgs6PypN9L8tyeirZ569vm3lqMHwOGfnc0QeV1XnjEvZWtbIle0SmaZ4luwR6AJpkNuHW3DWwEOW6Z/ds3JLjv4q7ft48sQZhzY1DRisguaVOF4M87ybYUTNJWM++Y0SGuGiPv8DrWy8jhzd4ett5HVA44Q53HyEL+bQrUH0eY23rreyNdFMI3Z97LXIUpNYfoCuphloMhmxzx7SRcDfEOAidCOFVtZj8DaH29M0Fx2UGlSo54cDL88xGwAs295ytsL8nvYhCOOkzuT3iwG9HANda3N97iBybrUkfiKyl7bicTiaMXZZWxYBegkrm4JIdhXWi3NlnB9lBkX4XWuhFuxDRZwxqBH6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(30864003)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wa0M+W1tWECwKuLj8Yfv+NGGgYKO1Cg7JF6dBAezrGbQ4cepRREkdxa1wyWt?=
 =?us-ascii?Q?kBUN8R1ydlCEBa1DTVVdga/r/+W8IZ8fTgWj5rT/b335ALBUdE8I0aOd1YaH?=
 =?us-ascii?Q?4wXTSJbLyoJCWVaSn8JzlDRlvPjF5mHn7u82/Ua8q0ehXSEjy70sFzk6w0Z9?=
 =?us-ascii?Q?B5naaRjCqs3RBzqM801s58phrQcEB2Pe+Cc57x/o27zhWRfLut0Z2vUNLNZo?=
 =?us-ascii?Q?HO1yHGhBHWUuURW4nMu4oCwh/Y2Ec6lKQ4I9LAD3Bda1dc0JI13rGJk9fOVv?=
 =?us-ascii?Q?CL4OfdJRQh6O4/YBaJ3+pmqBaoICebmdgQoqFhU9TFoMNZQAyf+giVw9lSA2?=
 =?us-ascii?Q?3iey59pskW8nHUABekBAAr2EFBNNOP39T/p4RYDVQylZinaR5zW1RAsJRj8u?=
 =?us-ascii?Q?ltxX+vh1/z9Lf+0DqIQnDFpzsZiusKurTGaymDejYKaKMVuw1d2wA9QYzsqq?=
 =?us-ascii?Q?sQ9Z+kA3810q9jLl0DX9/qYUEnG2/XT95y1ZZoe6lrrr1RRwd9JQnlqDJ32d?=
 =?us-ascii?Q?8hzxj3pSqW888OrVJhe0pR50rB7Aw4R+cbZQLqRrNuzLLkSs8TJ7B1+A6Xcp?=
 =?us-ascii?Q?hN8FxCkyAEDg1DYRuU58EF0UE/1N9TfN7cWEJPW1Yv3c3S+65KaLcRPn9jUE?=
 =?us-ascii?Q?6xSS/PXC35paOcbnPtWT8Sv7ygHmKR8WglHWMNf8CIqJfakoLLzgOXKQ/hsI?=
 =?us-ascii?Q?w0z8DLfkMjiQkGwNYs84c4Phd9CBjgWxEwybKI+IC35VOhKGYSEV1Pg1aDc+?=
 =?us-ascii?Q?ojzqRgk07t/rm9UKmmEoeLQ95L1rsTeAAplYOMg3P3DSCHFfBbaqVt4R9sTV?=
 =?us-ascii?Q?/cvIAvg5brKurQe5TD5JLO4jutWidixGnXfvayXZKB1J8EOnMLwLUl/1FHYe?=
 =?us-ascii?Q?xfVQl9tnsy9wndymp3pdX/tvtDohmBH0GFlKwNKvTl3zSUREBq/Y9qS63jQd?=
 =?us-ascii?Q?lnTUe7FgC5hnkih7BEZhAOU3khUh3Kw/cN/81hzBHmFmdKFQq0MjAgmDSc/D?=
 =?us-ascii?Q?XX6bpKjWcGoluehnuTxKe7/roi2bVA77Aq6MgxlraUcrMq4jiQ4wtZ9HniPp?=
 =?us-ascii?Q?r+8ZSt5QnrNWO7fMmh5CAGeKjvOe7GiElwESOiFOa4kbXUx6BjCP0Al441Wq?=
 =?us-ascii?Q?rTjzlxP6akW6xggX3ijG2Qf3G0eYG+DyGmDh6tXke+WtPkzb+yKvGeYVvoyc?=
 =?us-ascii?Q?GXp/4MGUsYF6RsOKJoTv29GNDKx5LIfjXzV6BAO87tbEsdoh0K9CM9puBFef?=
 =?us-ascii?Q?mnKNOlYqAbLIUVYG9y0ldKYojGsj3G2FFhv94oGA8vPebzhZ5MJfizX6fwJa?=
 =?us-ascii?Q?q6Lngwa+idB0Dt3GNgLBB2ASuWIMPCd2hI3zATGpb06J3Ka3uReQCrdJsCCM?=
 =?us-ascii?Q?kcXZT/tk8zPenI3NkK6Y6edKRpj1utjPU+wjL4J3Lk9TnFVV2sGBu61WO/CL?=
 =?us-ascii?Q?SZwjWFjEyn5oBUf5f7GvsWoLduDk2luQMz78IPIp3khYmzaTBWAX7FOc8WeR?=
 =?us-ascii?Q?DCPf0pUy4m8MCgTqOnFPXzlYgn2KnE7qvOF3jDEqs8T+LByQthCMD+anvRHI?=
 =?us-ascii?Q?xYSXqY2dv850tLqzGucAcFmUG2Qx2lDWhxejUKzWGPOf2xu1HUbu0j4osVTs?=
 =?us-ascii?Q?e/1od+85xdnAsrViAblWzfw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b87ebc5-5727-4753-3ae2-08d9f840713c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:11.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fh3eUffggn13wetKPoqzN/3W9wzu3A0p7ojZ69ku2SWv14tsqWpkYWB031Uhhk6/X5DpzQhdwKJ0mNLA0eQ3kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ocelot uses a pvid of 0 for standalone ports and ports under a
VLAN-unaware bridge, and the pvid of the bridge for ports under a
VLAN-aware bridge. Standalone ports do not perform learning, but packets
received on them are still subject to FDB lookups. So if the MAC DA that
a standalone port receives has been also learned on a VLAN-unaware
bridge port, ocelot will attempt to forward to that port, even though it
can't, so it will drop packets.

So there is a desire to avoid that, and isolate the FDBs of different
bridges from one another, and from standalone ports.

The ocelot switch library has two distinct entry points: the felix DSA
driver and the ocelot switchdev driver.

We need to code up a minimal bridge_num allocation in the ocelot
switchdev driver too, this is copied from DSA with the exception that
ocelot does not care about DSA trees, cross-chip bridging etc. So it
only looks at its own ports that are already in the same bridge.

The ocelot switchdev driver uses the bridge_num it has allocated itself,
while the felix driver uses the bridge_num allocated by DSA. They are
both stored inside ocelot_port->bridge_num by the common function
ocelot_port_bridge_join() which receives the bridge_num passed by value.

Once we have a bridge_num, we can only use it to enforce isolation
between VLAN-unaware bridges. As far as I can see, ocelot does not have
anything like a FID that further makes VLAN 100 from a port be different
to VLAN 100 from another port with regard to FDB lookup. So we simply
deny multiple VLAN-aware bridges.

For VLAN-unaware bridges, we crop the 4000-4095 VLAN region and we
allocate a VLAN for each bridge_num. This will be used as the pvid of
each port that is under that VLAN-unaware bridge, for as long as that
bridge is VLAN-unaware.

VID 0 remains only for standalone ports. It is okay if all standalone
ports use the same VID 0, since they perform no address learning, the
FDB will contain no entry in VLAN 0, so the packets will always be
flooded to the only possible destination, the CPU port.

The CPU port module doesn't need to be member of the VLANs to receive
packets, but if we use the DSA tag_8021q protocol, those packets are
part of the data plane as far as ocelot is concerned, so there it needs
to. Just ensure that the DSA tag_8021q CPU port is a member of all
reserved VLANs when it is created, and is removed when it is deleted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  63 ++++++--
 drivers/net/ethernet/mscc/ocelot.c     | 200 ++++++++++++++++++++++---
 drivers/net/ethernet/mscc/ocelot.h     |   5 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c |   8 +-
 drivers/net/ethernet/mscc/ocelot_net.c |  66 ++++++--
 include/soc/mscc/ocelot.h              |  31 ++--
 6 files changed, 317 insertions(+), 56 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0b1bcbd230ee..3f2bf73b274f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -234,7 +234,7 @@ static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 {
 	mutex_lock(&ocelot->fwd_domain_lock);
 
-	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+	ocelot_port_set_dsa_8021q_cpu(ocelot, port);
 	ocelot->npi = -1;
 
 	/* Overwrite PGID_CPU with the non-tagging port */
@@ -250,6 +250,7 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
 	mutex_lock(&ocelot->fwd_domain_lock);
 
 	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+	ocelot_port_unset_dsa_8021q_cpu(ocelot, port);
 
 	/* Restore PGID_CPU */
 	ocelot_write_rix(ocelot, BIT(ocelot->num_phys_ports), ANA_PGID_PGID,
@@ -591,58 +592,99 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 	return ocelot_fdb_dump(ocelot, port, cb, data);
 }
 
+/* Translate the DSA database API into the ocelot switch library API,
+ * which uses VID 0 for all ports that aren't part of a bridge,
+ * and expects the bridge_dev to be NULL in that case.
+ */
+static struct net_device *felix_classify_db(struct dsa_db db)
+{
+	switch (db.type) {
+	case DSA_DB_PORT:
+	case DSA_DB_LAG:
+		return NULL;
+	case DSA_DB_BRIDGE:
+		return db.bridge.dev;
+	default:
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+}
+
 static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
 			 struct dsa_db db)
 {
+	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_fdb_add(ocelot, port, addr, vid);
+	if (IS_ERR(bridge_dev))
+		return PTR_ERR(bridge_dev);
+
+	return ocelot_fdb_add(ocelot, port, addr, vid, bridge_dev);
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
 			 struct dsa_db db)
 {
+	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_fdb_del(ocelot, port, addr, vid);
+	if (IS_ERR(bridge_dev))
+		return PTR_ERR(bridge_dev);
+
+	return ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
 }
 
 static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
 			     const unsigned char *addr, u16 vid,
 			     struct dsa_db db)
 {
+	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_lag_fdb_add(ocelot, lag.dev, addr, vid);
+	if (IS_ERR(bridge_dev))
+		return PTR_ERR(bridge_dev);
+
+	return ocelot_lag_fdb_add(ocelot, lag.dev, addr, vid, bridge_dev);
 }
 
 static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
 			     const unsigned char *addr, u16 vid,
 			     struct dsa_db db)
 {
+	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_lag_fdb_del(ocelot, lag.dev, addr, vid);
+	if (IS_ERR(bridge_dev))
+		return PTR_ERR(bridge_dev);
+
+	return ocelot_lag_fdb_del(ocelot, lag.dev, addr, vid, bridge_dev);
 }
 
 static int felix_mdb_add(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_mdb *mdb,
 			 struct dsa_db db)
 {
+	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_mdb_add(ocelot, port, mdb);
+	if (IS_ERR(bridge_dev))
+		return PTR_ERR(bridge_dev);
+
+	return ocelot_port_mdb_add(ocelot, port, mdb, bridge_dev);
 }
 
 static int felix_mdb_del(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_mdb *mdb,
 			 struct dsa_db db)
 {
+	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_mdb_del(ocelot, port, mdb);
+	if (IS_ERR(bridge_dev))
+		return PTR_ERR(bridge_dev);
+
+	return ocelot_port_mdb_del(ocelot, port, mdb, bridge_dev);
 }
 
 static void felix_bridge_stp_state_set(struct dsa_switch *ds, int port,
@@ -679,9 +721,8 @@ static int felix_bridge_join(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_bridge_join(ocelot, port, bridge.dev);
-
-	return 0;
+	return ocelot_port_bridge_join(ocelot, port, bridge.dev, bridge.num,
+				       extack);
 }
 
 static void felix_bridge_leave(struct dsa_switch *ds, int port,
@@ -1191,6 +1232,8 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->assisted_learning_on_cpu_port = true;
+	ds->fdb_isolation = true;
+	ds->max_num_bridges = ds->num_ports;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0e8fa0a4fc69..0af321f6fb54 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -13,6 +13,7 @@
 
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
+#define OCELOT_RSV_VLAN_RANGE_START 4000
 
 struct ocelot_mact_entry {
 	u8 mac[ETH_ALEN];
@@ -221,6 +222,35 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 		       REW_PORT_CFG, port);
 }
 
+static int ocelot_single_vlan_aware_bridge(struct ocelot *ocelot,
+					   struct netlink_ext_ack *extack)
+{
+	struct net_device *bridge = NULL;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port || !ocelot_port->bridge ||
+		    !br_vlan_enabled(ocelot_port->bridge))
+			continue;
+
+		if (!bridge) {
+			bridge = ocelot_port->bridge;
+			continue;
+		}
+
+		if (bridge == ocelot_port->bridge)
+			continue;
+
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only one VLAN-aware bridge is supported");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
 {
 	return ocelot_read(ocelot, ANA_TABLES_VLANACCESS);
@@ -347,12 +377,45 @@ static void ocelot_port_manage_port_tag(struct ocelot *ocelot, int port)
 	}
 }
 
+int ocelot_bridge_num_find(struct ocelot *ocelot,
+			   const struct net_device *bridge)
+{
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (ocelot_port && ocelot_port->bridge == bridge)
+			return ocelot_port->bridge_num;
+	}
+
+	return -1;
+}
+EXPORT_SYMBOL_GPL(ocelot_bridge_num_find);
+
+static u16 ocelot_vlan_unaware_pvid(struct ocelot *ocelot,
+				    const struct net_device *bridge)
+{
+	int bridge_num;
+
+	/* Standalone ports use VID 0 */
+	if (!bridge)
+		return 0;
+
+	bridge_num = ocelot_bridge_num_find(ocelot, bridge);
+	if (WARN_ON(bridge_num < 0))
+		return 0;
+
+	/* VLAN-unaware bridges use a reserved VID going from 4095 downwards */
+	return VLAN_N_VID - bridge_num - 1;
+}
+
 /* Default vlan to clasify for untagged frames (may be zero) */
 static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 				 const struct ocelot_bridge_vlan *pvid_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	u16 pvid = OCELOT_VLAN_UNAWARE_PVID;
+	u16 pvid = ocelot_vlan_unaware_pvid(ocelot, ocelot_port->bridge);
 	u32 val = 0;
 
 	ocelot_port->pvid_vlan = pvid_vlan;
@@ -466,12 +529,29 @@ static int ocelot_vlan_member_del(struct ocelot *ocelot, int port, u16 vid)
 	return 0;
 }
 
+static int ocelot_add_vlan_unaware_pvid(struct ocelot *ocelot, int port,
+					const struct net_device *bridge)
+{
+	u16 vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
+	return ocelot_vlan_member_add(ocelot, port, vid, true);
+}
+
+static int ocelot_del_vlan_unaware_pvid(struct ocelot *ocelot, int port,
+					const struct net_device *bridge)
+{
+	u16 vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
+	return ocelot_vlan_member_del(ocelot, port, vid);
+}
+
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 			       bool vlan_aware, struct netlink_ext_ack *extack)
 {
 	struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vcap_filter *filter;
+	int err;
 	u32 val;
 
 	list_for_each_entry(filter, &block->rules, list) {
@@ -483,6 +563,19 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		}
 	}
 
+	err = ocelot_single_vlan_aware_bridge(ocelot, extack);
+	if (err)
+		return err;
+
+	if (vlan_aware)
+		err = ocelot_del_vlan_unaware_pvid(ocelot, port,
+						   ocelot_port->bridge);
+	else
+		err = ocelot_add_vlan_unaware_pvid(ocelot, port,
+						   ocelot_port->bridge);
+	if (err)
+		return err;
+
 	ocelot_port->vlan_aware = vlan_aware;
 
 	if (vlan_aware)
@@ -521,6 +614,12 @@ int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		}
 	}
 
+	if (vid > OCELOT_RSV_VLAN_RANGE_START) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VLAN range 4000-4095 reserved for VLAN-unaware bridging");
+		return -EBUSY;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_vlan_prepare);
@@ -584,11 +683,11 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	for (vid = 1; vid < VLAN_N_VID; vid++)
 		ocelot_vlant_set_mask(ocelot, vid, 0);
 
-	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
-	 * traffic.  It is added automatically if 8021q module is loaded, but
-	 * we can't rely on it since module may be not loaded.
+	/* We need VID 0 to get traffic on standalone ports.
+	 * It is added automatically if the 8021q module is loaded, but we
+	 * can't rely on that since it might not be.
 	 */
-	ocelot_vlant_set_mask(ocelot, OCELOT_VLAN_UNAWARE_PVID, all_ports);
+	ocelot_vlant_set_mask(ocelot, OCELOT_STANDALONE_PVID, all_ports);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
@@ -1237,21 +1336,27 @@ void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 }
 EXPORT_SYMBOL(ocelot_drain_cpu_queue);
 
-int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid)
+int ocelot_fdb_add(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge)
 {
 	int pgid = port;
 
 	if (port == ocelot->npi)
 		pgid = PGID_CPU;
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
 
-int ocelot_fdb_del(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid)
+int ocelot_fdb_del(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge)
 {
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	return ocelot_mact_forget(ocelot, addr, vid);
 }
 EXPORT_SYMBOL(ocelot_fdb_del);
@@ -1413,6 +1518,12 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 
 			is_static = (entry.type == ENTRYTYPE_LOCKED);
 
+			/* Hide the reserved VLANs used for
+			 * VLAN-unaware bridging.
+			 */
+			if (entry.vid > OCELOT_RSV_VLAN_RANGE_START)
+				entry.vid = 0;
+
 			err = cb(entry.mac, entry.vid, is_static, data);
 			if (err)
 				break;
@@ -2054,6 +2165,28 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 }
 EXPORT_SYMBOL(ocelot_apply_bridge_fwd_mask);
 
+void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+{
+	u16 vid;
+
+	ocelot->ports[port]->is_dsa_8021q_cpu = true;
+
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_add(ocelot, port, vid, true);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_set_dsa_8021q_cpu);
+
+void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
+{
+	u16 vid;
+
+	ocelot->ports[port]->is_dsa_8021q_cpu = false;
+
+	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_del(ocelot, port, vid);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_unset_dsa_8021q_cpu);
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -2198,7 +2331,8 @@ static void ocelot_encode_ports_to_mdb(unsigned char *addr,
 }
 
 int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb)
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge)
 {
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
@@ -2208,6 +2342,9 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
 		/* New entry */
@@ -2254,7 +2391,8 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 EXPORT_SYMBOL(ocelot_port_mdb_add);
 
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb)
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge)
 {
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
@@ -2264,6 +2402,9 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc)
 		return -ENOENT;
@@ -2297,18 +2438,30 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
 
-void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-			     struct net_device *bridge)
+int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			    struct net_device *bridge, int bridge_num,
+			    struct netlink_ext_ack *extack)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int err;
+
+	err = ocelot_single_vlan_aware_bridge(ocelot, extack);
+	if (err)
+		return err;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
 	ocelot_port->bridge = bridge;
+	ocelot_port->bridge_num = bridge_num;
 
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
 
 	mutex_unlock(&ocelot->fwd_domain_lock);
+
+	if (br_vlan_enabled(bridge))
+		return 0;
+
+	return ocelot_add_vlan_unaware_pvid(ocelot, port, bridge);
 }
 EXPORT_SYMBOL(ocelot_port_bridge_join);
 
@@ -2319,7 +2472,11 @@ void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
+	if (!br_vlan_enabled(bridge))
+		ocelot_del_vlan_unaware_pvid(ocelot, port, bridge);
+
 	ocelot_port->bridge = NULL;
+	ocelot_port->bridge_num = -1;
 
 	ocelot_port_set_pvid(ocelot, port, NULL);
 	ocelot_port_manage_port_tag(ocelot, port);
@@ -2544,7 +2701,8 @@ void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active)
 EXPORT_SYMBOL(ocelot_port_lag_change);
 
 int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
-		       const unsigned char *addr, u16 vid)
+		       const unsigned char *addr, u16 vid,
+		       const struct net_device *bridge)
 {
 	struct ocelot_lag_fdb *fdb;
 	int lag, err;
@@ -2553,11 +2711,15 @@ int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
 	if (!fdb)
 		return -ENOMEM;
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	ether_addr_copy(fdb->addr, addr);
 	fdb->vid = vid;
 	fdb->bond = bond;
 
-	mutex_lock(&ocelot->fwd_domain_lock);
 	lag = ocelot_bond_get_id(ocelot, bond);
 
 	err = ocelot_mact_learn(ocelot, lag, addr, vid, ENTRYTYPE_LOCKED);
@@ -2575,12 +2737,16 @@ int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
 EXPORT_SYMBOL_GPL(ocelot_lag_fdb_add);
 
 int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
-		       const unsigned char *addr, u16 vid)
+		       const unsigned char *addr, u16 vid,
+		       const struct net_device *bridge)
 {
 	struct ocelot_lag_fdb *fdb, *tmp;
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
+	if (!vid)
+		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
+
 	list_for_each_entry_safe(fdb, tmp, &ocelot->lag_fdbs, list) {
 		if (!ether_addr_equal(fdb->addr, addr) || fdb->vid != vid ||
 		    fdb->bond != bond)
@@ -2832,7 +2998,7 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 
 	/* Configure the CPU port to be VLAN aware */
 	ocelot_write_gix(ocelot,
-			 ANA_PORT_VLAN_CFG_VLAN_VID(OCELOT_VLAN_UNAWARE_PVID) |
+			 ANA_PORT_VLAN_CFG_VLAN_VID(OCELOT_STANDALONE_PVID) |
 			 ANA_PORT_VLAN_CFG_VLAN_AWARE_ENA |
 			 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
 			 ANA_PORT_VLAN_CFG, cpu);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 5277c4b53af4..f8dc0d75eb5d 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -26,7 +26,7 @@
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
 
-#define OCELOT_VLAN_UNAWARE_PVID 0
+#define OCELOT_STANDALONE_PVID 0
 #define OCELOT_BUFFER_CELL_SZ 60
 
 #define OCELOT_STATS_CHECK_DELAY (2 * HZ)
@@ -81,6 +81,9 @@ struct ocelot_multicast {
 	struct ocelot_pgid *pgid;
 };
 
+int ocelot_bridge_num_find(struct ocelot *ocelot,
+			   const struct net_device *bridge);
+
 int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 142e897ea2af..3ccec488a304 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -107,16 +107,16 @@ static void ocelot_mrp_save_mac(struct ocelot *ocelot,
 				struct ocelot_port *port)
 {
 	ocelot_mact_learn(ocelot, PGID_BLACKHOLE, mrp_test_dmac,
-			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
+			  OCELOT_STANDALONE_PVID, ENTRYTYPE_LOCKED);
 	ocelot_mact_learn(ocelot, PGID_BLACKHOLE, mrp_control_dmac,
-			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
+			  OCELOT_STANDALONE_PVID, ENTRYTYPE_LOCKED);
 }
 
 static void ocelot_mrp_del_mac(struct ocelot *ocelot,
 			       struct ocelot_port *port)
 {
-	ocelot_mact_forget(ocelot, mrp_test_dmac, OCELOT_VLAN_UNAWARE_PVID);
-	ocelot_mact_forget(ocelot, mrp_control_dmac, OCELOT_VLAN_UNAWARE_PVID);
+	ocelot_mact_forget(ocelot, mrp_test_dmac, OCELOT_STANDALONE_PVID);
+	ocelot_mact_forget(ocelot, mrp_control_dmac, OCELOT_STANDALONE_PVID);
 }
 
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e271b6225b72..cfe767d077f8 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -419,7 +419,7 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 	 * with VLAN filtering feature. We need to keep it to receive
 	 * untagged traffic.
 	 */
-	if (vid == OCELOT_VLAN_UNAWARE_PVID)
+	if (vid == OCELOT_STANDALONE_PVID)
 		return 0;
 
 	ret = ocelot_vlan_del(ocelot, port, vid);
@@ -559,7 +559,7 @@ static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_mact_work_ctx w;
 
 	ether_addr_copy(w.forget.addr, addr);
-	w.forget.vid = OCELOT_VLAN_UNAWARE_PVID;
+	w.forget.vid = OCELOT_STANDALONE_PVID;
 	w.type = OCELOT_MACT_FORGET;
 
 	return ocelot_enqueue_mact_action(ocelot, &w);
@@ -573,7 +573,7 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_mact_work_ctx w;
 
 	ether_addr_copy(w.learn.addr, addr);
-	w.learn.vid = OCELOT_VLAN_UNAWARE_PVID;
+	w.learn.vid = OCELOT_STANDALONE_PVID;
 	w.learn.pgid = PGID_CPU;
 	w.learn.entry_type = ENTRYTYPE_LOCKED;
 	w.type = OCELOT_MACT_LEARN;
@@ -608,9 +608,9 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 
 	/* Learn the new net device MAC address in the mac table. */
 	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data,
-			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
+			  OCELOT_STANDALONE_PVID, ENTRYTYPE_LOCKED);
 	/* Then forget the previous one. */
-	ocelot_mact_forget(ocelot, dev->dev_addr, OCELOT_VLAN_UNAWARE_PVID);
+	ocelot_mact_forget(ocelot, dev->dev_addr, OCELOT_STANDALONE_PVID);
 
 	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
@@ -662,10 +662,11 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_add(ocelot, port, addr, vid);
+	return ocelot_fdb_add(ocelot, port, addr, vid, ocelot_port->bridge);
 }
 
 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
@@ -673,10 +674,11 @@ static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       const unsigned char *addr, u16 vid)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_fdb_del(ocelot, port, addr, vid);
+	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
 }
 
 static int ocelot_port_fdb_dump(struct sk_buff *skb,
@@ -988,7 +990,7 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_port_mdb_add(ocelot, port, mdb);
+	return ocelot_port_mdb_add(ocelot, port, mdb, ocelot_port->bridge);
 }
 
 static int ocelot_port_obj_del_mdb(struct net_device *dev,
@@ -999,7 +1001,7 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	return ocelot_port_mdb_del(ocelot, port, mdb);
+	return ocelot_port_mdb_del(ocelot, port, mdb, ocelot_port->bridge);
 }
 
 static int ocelot_port_obj_mrp_add(struct net_device *dev,
@@ -1173,6 +1175,33 @@ static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
 	return 0;
 }
 
+static int ocelot_bridge_num_get(struct ocelot *ocelot,
+				 const struct net_device *bridge_dev)
+{
+	int bridge_num = ocelot_bridge_num_find(ocelot, bridge_dev);
+
+	if (bridge_num < 0) {
+		/* First port that offloads this bridge */
+		bridge_num = find_first_zero_bit(&ocelot->bridges,
+						 ocelot->num_phys_ports);
+
+		set_bit(bridge_num, &ocelot->bridges);
+	}
+
+	return bridge_num;
+}
+
+static void ocelot_bridge_num_put(struct ocelot *ocelot,
+				  const struct net_device *bridge_dev,
+				  int bridge_num)
+{
+	/* Check if the bridge is still in use, otherwise it is time
+	 * to clean it up so we can reuse this bridge_num later.
+	 */
+	if (!ocelot_bridge_num_find(ocelot, bridge_dev))
+		clear_bit(bridge_num, &ocelot->bridges);
+}
+
 static int ocelot_netdevice_bridge_join(struct net_device *dev,
 					struct net_device *brport_dev,
 					struct net_device *bridge,
@@ -1182,9 +1211,14 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
-	int err;
+	int bridge_num, err;
 
-	ocelot_port_bridge_join(ocelot, port, bridge);
+	bridge_num = ocelot_bridge_num_get(ocelot, bridge);
+
+	err = ocelot_port_bridge_join(ocelot, port, bridge, bridge_num,
+				      extack);
+	if (err)
+		goto err_join;
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
 					    &ocelot_switchdev_nb,
@@ -1205,6 +1239,8 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 					&ocelot_switchdev_blocking_nb);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
+err_join:
+	ocelot_bridge_num_put(ocelot, bridge, bridge_num);
 	return err;
 }
 
@@ -1225,6 +1261,7 @@ static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	int bridge_num = ocelot_port->bridge_num;
 	int port = priv->chip_port;
 	int err;
 
@@ -1233,6 +1270,7 @@ static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 		return err;
 
 	ocelot_port_bridge_leave(ocelot, port, bridge);
+	ocelot_bridge_num_put(ocelot, bridge, bridge_num);
 
 	return 0;
 }
@@ -1700,7 +1738,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		eth_hw_addr_gen(dev, ocelot->base_mac, port);
 
 	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
-			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
+			  OCELOT_STANDALONE_PVID, ENTRYTYPE_LOCKED);
 
 	ocelot_init_port(ocelot, port);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index dd4fc34d2992..ee3c59639d70 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -668,6 +668,7 @@ struct ocelot_port {
 	u16				mrp_ring_id;
 
 	struct net_device		*bridge;
+	int				bridge_num;
 	u8				stp_state;
 
 	int				speed;
@@ -713,6 +714,8 @@ struct ocelot {
 	enum ocelot_tag_prefix		npi_inj_prefix;
 	enum ocelot_tag_prefix		npi_xtr_prefix;
 
+	unsigned long			bridges;
+
 	struct list_head		multicast;
 	struct list_head		pgids;
 
@@ -846,6 +849,9 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port);
+void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
@@ -863,21 +869,24 @@ int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
 				 struct switchdev_brport_flags val);
 void ocelot_port_bridge_flags(struct ocelot *ocelot, int port,
 			      struct switchdev_brport_flags val);
-void ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-			     struct net_device *bridge);
+int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			    struct net_device *bridge, int bridge_num,
+			    struct netlink_ext_ack *extack);
 void ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			      struct net_device *bridge);
 int ocelot_mact_flush(struct ocelot *ocelot, int port);
 int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 		    dsa_fdb_dump_cb_t *cb, void *data);
-int ocelot_fdb_add(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid);
-int ocelot_fdb_del(struct ocelot *ocelot, int port,
-		   const unsigned char *addr, u16 vid);
+int ocelot_fdb_add(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge);
+int ocelot_fdb_del(struct ocelot *ocelot, int port, const unsigned char *addr,
+		   u16 vid, const struct net_device *bridge);
 int ocelot_lag_fdb_add(struct ocelot *ocelot, struct net_device *bond,
-		       const unsigned char *addr, u16 vid);
+		       const unsigned char *addr, u16 vid,
+		       const struct net_device *bridge);
 int ocelot_lag_fdb_del(struct ocelot *ocelot, struct net_device *bond,
-		       const unsigned char *addr, u16 vid);
+		       const unsigned char *addr, u16 vid,
+		       const struct net_device *bridge);
 int ocelot_vlan_prepare(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 			bool untagged, struct netlink_ext_ack *extack);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
@@ -901,9 +910,11 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress);
 int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb);
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
-			const struct switchdev_obj_port_mdb *mdb);
+			const struct switchdev_obj_port_mdb *mdb,
+			const struct net_device *bridge);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
 			 struct netdev_lag_upper_info *info);
-- 
2.25.1

