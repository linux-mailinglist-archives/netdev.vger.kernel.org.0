Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B1059895A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344962AbiHRQtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345100AbiHRQsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:48:51 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60089.outbound.protection.outlook.com [40.107.6.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC093910B8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:48:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQNja5kPX6s+Q4s1GB1ufQVK0R9GT17euuE3lxqgcU/C31Lc86xTFi2c0kjkzO9CaqPmv71DMbsgX4ozlGzsCGv9pByZfCA4IOCqa+nEgXi8CtL40k8Hk8E9KjeIQQxv85q7Q3SJKPE8CT+HYeov8GxB6+L/psEQOZWG52TFgFHxZkV8nvpSqy/Wr75RGlFVh+R2FQsLHERHfizkF7AlZIAa7r5N5qqrZ9hmjVZGFxGXMBrayT2uWtHuXrkWPJu8aJ39RXhiXp2GBvsuJ49D3ZWFzMaXOLa64sgcCB0L2QxG1Dn9QCOaqRfMS/FsbPfs5+s9b8yqQOumaAgcbDIemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vREwjeuOGJPR7CBNf9GDWYdzQCgpd3OCuQXApURgkjU=;
 b=AGatdMWxzbseRZ+SW6VvCX7zUAolOTKYqvrbYZZVcjiXII91ubhL7XyFsct0OUe8ck7lmCwJ8kNBj8dOJ/GtGvGmFpZ1QhuQhsgOmIEHw10ZlSRL05j/MkIVq0fuJOpRsg5Sss99lxTJKXjKoh2jXKIjiXRmed27XqQ7ZCB8PhTo+2RqhynazQbIVRsra62PIQMbgoCP4wmTZ+nSKUS8gc8jjZnywZCnaHdsdt0C3ttURkeuApi0GuCuenuTfvOss6fqj0whafseJbuAm1XFjuYIF8FZCjVLZlIqCJCyVwLcVAq9R5S4vt331hfh78SYFOtoqTdsbZYx6+GkhjCroQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vREwjeuOGJPR7CBNf9GDWYdzQCgpd3OCuQXApURgkjU=;
 b=qg+NbjCgtmPB9hY3NDaOMnD8ErXG5nZX/C05Zpf6MRDj02LceCQgZ46dK8q0gbQK/0FKDKxurYbTSvI/Qz/lF3Uryyz/B6rS8zU3mMR32st5f0IHu+O9cZE13WDyBqwy2ig/opGQh2wMKKKL0ttb1NlSQQYYUvMFTiJzFQihswE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB2780.eurprd04.prod.outlook.com (2603:10a6:3:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:48:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 16:48:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: [PATCH v2 net] net: dsa: microchip: make learning configurable and keep it off while standalone
Date:   Thu, 18 Aug 2022 19:48:09 +0300
Message-Id: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7d263ef-e3d6-47d4-d10d-08da81397795
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2780:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYbgMzxkTvhuJdntl0N+m45o8m3frRS/EhX+OGeFbw0uC6sOBXpElMaxXywH9xMFhM3xfiDBO/57oDEFWkklqLXLmJMqbkcU3Qu79RvOisp3lZ3ayz/xF1F7NrNnyBueVSpdV6pOU/SqKvf34P4cQnCZfYJUS1GlQ+49OymJnSJoGcS5NezcWpU4AVls/UzjrqkFRsqbWLsV4HE5k6Sv2vWQC+EwwmHeG0APSelGMHfA7Qd3bwEBrWHkeb75PqBh40eKrGNP75sEpwQzgugJyhiTIk8FLAweegDhs6cUriEYD4qlw3omuPL+peVCj+GbI8JkwOxd82NG4KL70zhnNYmNprQ47KQp5UEUQ8Up3igsUXcnzJnAdcogdDrGGTt/bD+h84SS8CZg1GAGDBw1B0LKw4td+cJRCZR8cRai0nLhTCoBxIPqwO03P2KG+6DtRYn8tvyKfIOvTNOlb2DP7+VLYKb4e7OJMzX5yNlG6vrlYwdy+omP0pcDixvMNNcHV3YT6DWwUmmEEAvs7UV6Qlcw7bx+TA0jZzbTfy7era/d3VahiSwATC7UOUaNGnRfXCuMuzfVG8Z/wPBiIFptwyf1n11mXclG9BgsDfASmWNVWSSumHuyo3gFbjp4o+zsLhxM8SGc9bOAknNN37PZOCym9hj2Ruj63yG+iMaYs6x4YoYlgRV88doQL+fam2MBBRxKTFQqV8CSvkepCZgEP3PXJrnkjZ8GvcXYkBlKZnDY2AQ5XnZhGVTVYa7UXzrUSP7jYsh/ws4VzI4XKFHuyPd9cqxYBVe5Y5h+4FyqxXc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(6486002)(966005)(478600001)(6666004)(2906002)(54906003)(6916009)(36756003)(41300700001)(316002)(86362001)(1076003)(186003)(38100700002)(38350700002)(26005)(6506007)(6512007)(52116002)(83380400001)(8936002)(5660300002)(4326008)(66476007)(7416002)(66946007)(8676002)(44832011)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RAoWaE9K0oiCFLF+UAV6oQM9Kx4RUIqFAMfSf2IeD56Xz9XE1X31wy8+fbLt?=
 =?us-ascii?Q?crUnoAFpsCpgB6KpVSbrgV+4FOEABpr0qCWi5F3cR1LvBQHBBi+xhCaUZIG+?=
 =?us-ascii?Q?9w3Jquz22H4GOqg7LY+sLidY1bi/Rghqn4cjIBJuGd/3HTzjaENn7/90m0vF?=
 =?us-ascii?Q?+1AMBNfA3kygBFru1WD7b/nelwZMT9GAA8npgE+hHbJuwlEAqsjNvZKMuzcT?=
 =?us-ascii?Q?ISo2EqgH8atdj1CQDao8JEKI38R6a4Tn0wZArcCsOAMOgzDIprNtR+Habn5A?=
 =?us-ascii?Q?Jm+JSjsoROgMpyBFv4Va5kjCo4RwgFOoaQ7FDF3LeRRQNFJ2wHlN+bZI73Xy?=
 =?us-ascii?Q?ccNMIfA5irssFfHOrW43QQ/69y9W5DnwtFPb3QhlfyCdQ3eaEi5+g0FBgyW5?=
 =?us-ascii?Q?y7NYbAbdtH2aDp4gUFiQ6zqnjMbdQRkgW/DX784QUisFtTPDQ7s8acrtfyZY?=
 =?us-ascii?Q?3traY7Kru5OzXRIBes41IB8BnftgIHvw9w9pYBufHbPxBzlnxdGXbYCy2zgh?=
 =?us-ascii?Q?5nWf4u9jVaZy6s9Ct7zxZLNLR5mFLsa49ZsyUNT30FGTtdB7cgwiCJTEIEHk?=
 =?us-ascii?Q?v6GkHp5xf8V+B9DEoz6XQgksIHMQAeygok2XLfRuOgenxd7xrQIcRtmQrCEl?=
 =?us-ascii?Q?VaTiMivwJTpgO4GFvJLi6JW5LFYmzRFutCFfA20aI3mFX8aV7/C6FvuxfqIf?=
 =?us-ascii?Q?t+I7IJCDu6Xeht1PN1kCWYCf+B40QSGcF7412GQMY+sxcN62dwqB6xRVNRTk?=
 =?us-ascii?Q?FO4QzTYJ+eWvzelKgpsCgR7GlNjMy9fKLQS/3ug7RT2oFo2uY9j/+y2svMZw?=
 =?us-ascii?Q?H+llUm7NdhTJIiqMnVDmn6w1/3R24G1c7rLsYkKefflATAI2KSeGB45zqXNo?=
 =?us-ascii?Q?/qiQlGaW9eCNyyZuv9TgOsQOropWR17NlwxtTCBMhESAlmG/geLdyRi6uv2P?=
 =?us-ascii?Q?7juMVMcj9IqDnpWAbepfiggZzaHACtHNHli1CJrb+OHKpg6txtZ1dMCDoHUI?=
 =?us-ascii?Q?xJc0PUJ58vdyO+sgS8O2ZUV8/LZv9rZDzI3ej3eMl6eOJtY9soUqrAkVOzMg?=
 =?us-ascii?Q?LFD4PzfZS5z9n2t559axLAGhgKfa1llOrZgChMtIhXoBZjOqe5mpDpQAlMJd?=
 =?us-ascii?Q?WElgWbL4xdc5DtgKf//v/37PsV2qT97JhvuZUa3d7Qkf+fyfjKvgw16mi5Kh?=
 =?us-ascii?Q?AdG14W4OcrSsPnU77AjsD9WzZ/8iCfcG1IvQOGVF/K9gE4+cpOXW8jU1vQgP?=
 =?us-ascii?Q?qQrZg6VdT8hYUzJ59vrFXGkOtnN8r+cfiecBE0ChsGUouVO6f4VY//5hG0mB?=
 =?us-ascii?Q?1qUTPkTmzuJBN7nxT5VMLZxekhUMqehnA0PshhojxTsGvluUPJAe1Kze0uPV?=
 =?us-ascii?Q?SnU5/KsLqZIG69T3Of66Yt6hN78TmxXZxjhfwEAfBr6K0bxDt9VMyMg2JieW?=
 =?us-ascii?Q?BWyPKZ6vrnItPRt738f7umBDOpg3uzv5M7VII7Q4ZqL9KOOoabQmKu/f/L0l?=
 =?us-ascii?Q?GbcYtEvrt1AgpaPNeNTZMl3zyIC55L3sTFwZcnP1iOCukFH9i3OqJJt5Ul9k?=
 =?us-ascii?Q?2RE8bhaB5m/CjuB6Nn49xnlfBaV7Uncb3hvZ+ONmaDJaWvRUpeGvMZnXe0Jr?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d263ef-e3d6-47d4-d10d-08da81397795
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:48:24.7334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5YSFYWt5TE4a0TlSS2kHgYW8pSW0gqvjnlYLDrL3L62LISwN4UxyCFXoJOlp4y5DGvl0aLNlMjBKbIIRp5TeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2780
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address learning should initially be turned off by the driver for port
operation in standalone mode, then the DSA core handles changes to it
via ds->ops->port_bridge_flags().

Leaving address learning enabled while ports are standalone breaks any
kind of communication which involves port B receiving what port A has
sent. Notably it breaks the ksz9477 driver used with a (non offloaded,
ports act as if standalone) bonding interface in active-backup mode,
when the ports are connected together through external switches, for
redundancy purposes.

This fixes a major design flaw in the ksz9477 and ksz8795 drivers, which
unconditionally leave address learning enabled even while ports operate
as standalone.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Link: https://lore.kernel.org/netdev/CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com/
Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: targeting the 6.0 release candidates as opposed to the 5.19 rc's
        from v1.

Again, this is compile-tested only, but the equivalent change was
confirmed by Brian as working on a 5.10 kernel.

@maintainers: when should I submit the backports to "stable", for older
trees?

 drivers/net/dsa/microchip/ksz_common.c | 45 +++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ed7d137cba99..b23241ccbc5a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -962,6 +962,7 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 static int ksz_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
 	const u16 *regs;
 	int ret;
 
@@ -1001,6 +1002,14 @@ static int ksz_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
+	/* Start with learning disabled on standalone user ports, and enabled
+	 * on the CPU port. In lack of other finer mechanisms, learning on the
+	 * CPU port will avoid flooding bridge local addresses on the network
+	 * in some cases.
+	 */
+	p = &dev->ports[dev->cpu_port];
+	p->learning = true;
+
 	/* start switch */
 	regmap_update_bits(dev->regmap[0], regs[S_START_CTRL],
 			   SW_START, SW_START);
@@ -1277,6 +1286,8 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 	ksz_pread8(dev, port, regs[P_STP_CTRL], &data);
 	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
 
+	p = &dev->ports[port];
+
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
@@ -1286,9 +1297,13 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	case BR_STATE_LEARNING:
 		data |= PORT_RX_ENABLE;
+		if (!p->learning)
+			data |= PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_FORWARDING:
 		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
+		if (!p->learning)
+			data |= PORT_LEARN_DISABLE;
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
@@ -1300,12 +1315,38 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 
 	ksz_pwrite8(dev, port, regs[P_STP_CTRL], data);
 
-	p = &dev->ports[port];
 	p->stp_state = state;
 
 	ksz_update_port_member(dev, port);
 }
 
+static int ksz_port_pre_bridge_flags(struct dsa_switch *ds, int port,
+				     struct switchdev_brport_flags flags,
+				     struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~BR_LEARNING)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ksz_port_bridge_flags(struct dsa_switch *ds, int port,
+				 struct switchdev_brport_flags flags,
+				 struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
+
+	if (flags.mask & BR_LEARNING) {
+		p->learning = !!(flags.val & BR_LEARNING);
+
+		/* Make the change take effect immediately */
+		ksz_port_stp_state_set(ds, port, p->stp_state);
+	}
+
+	return 0;
+}
+
 static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 						  int port,
 						  enum dsa_tag_protocol mp)
@@ -1719,6 +1760,8 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= ksz_port_stp_state_set,
+	.port_pre_bridge_flags	= ksz_port_pre_bridge_flags,
+	.port_bridge_flags	= ksz_port_bridge_flags,
 	.port_fast_age		= ksz_port_fast_age,
 	.port_vlan_filtering	= ksz_port_vlan_filtering,
 	.port_vlan_add		= ksz_port_vlan_add,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 764ada3a0f42..0d9520dc6d2d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -65,6 +65,7 @@ struct ksz_chip_data {
 
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
+	bool learning;
 	int stp_state;
 	struct phy_device phydev;
 
-- 
2.34.1

