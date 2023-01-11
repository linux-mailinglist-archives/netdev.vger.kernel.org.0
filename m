Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF59666036
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbjAKQSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbjAKQRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:51 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2054.outbound.protection.outlook.com [40.107.13.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2606F1C121;
        Wed, 11 Jan 2023 08:17:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQXeAxE+7wBReQsk4WQ8recoc9AcngyK1VjtMUZ1SY/jMbPGShZxVnC6wlehhH8b/q1qG4A8m9XOGVMNWAoQKCiWWVXqclq6ytRmYQ8U69Ny2/V9Rjli1m30bnGch/zNe5XTeCpFRRT+wZ9IthqwaDYxg4U0wHZ0gYokwAnp0aEnqFkFZFRR4NDmu2MUO6xWha/nUKUofkK84wwVnJeA+imoEfCYfhtYVhdstEGBEb0tVdOC2kl3tBR4sV41bSUpOM9noakbIiWlKV4curxmklLZdjjfKyyTrtOrjNx6f9sZUf1bKDutS8K5zxivGQwsTzuPwjM00+Dbbf8ybqYY/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kpme7pSuwhxEiksw5G/NA7rrKyj4XaDOf58Tita2gg=;
 b=jtDeUVGTbyqlk/W1v+lh+zpRzQiodkDvB1xhSKKdigid2Lq380Hl/urnFwB6dZsho3dZXk6D/qoZlOb+c575nRZzhLOGy4v6/RnlccI2/47BPeqCrLU35Vwk4OnJhmw5b7WsEEV/EyUYEO8oVAjV1EDmQ83yRVdC8WiX6VEXBioP4ahrjMi7AI8tU4qfUGoKhkuRIYuvvr24EIVPDKZps6wI0KvK1ZNf1o9Mbrd3kvSelFoa4vt+OABdEh4KEtNcs5DV7eEcbmpXYRTjqlb4ztIgY4GLy5RtcSRjxOXP+H6sentA5VULoe1bCBqTkhFWBlZHMCtMxVbsG/XVqB34Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kpme7pSuwhxEiksw5G/NA7rrKyj4XaDOf58Tita2gg=;
 b=TIq5v7fa6cSlE+J1zVIvuoDmB8siWW96i3GyPt3u3V4YGu4LQIPf/miKqrAEcj4S+amxdVUFKUY0euw8mNXWKxWpJPh8W7mj/uyWjhD6DEcOsEI6pSGUy/TaJrcomhB0FpiH47sOPEYdCGJez21ax4rHZV3SfDuVO2SMygNXAcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7549.eurprd04.prod.outlook.com (2603:10a6:102:e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 11/12] net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
Date:   Wed, 11 Jan 2023 18:17:05 +0200
Message-Id: <20230111161706.1465242-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: 42a3d1d8-dbb3-4d8f-593c-08daf3ef57fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ocwwRbRLqhQGs5480uxHR2Op6OUDb49yBrMtw6XCuuUKZf6Y/CP4SRiw+FnqLssnDKMRBzx8/kQFXPvuQ4gGm6rbMmT32AapwrdT3BULijSpwzzvmE5CEN4r4Qv6BR3H6vZdaGKo+e8EoMnnMLOn8tYqa3SaENoj778wHhld4Oz5MAxFhXBeYV1wlv44YxnNiQsRUJun9UiLw36w9PkffNO42PfSevB9WmXj8aoEB3OzRXlcxVnjESHulGHslhv54f62RCuuHAeJdUTM9s+3/x3MIKYT8WdXQ2qjpKAUXy3jwW//2aB0YKtEdjvsYolC1/nzPH8OgYsxsJyBrQ4m/z0DrbDhBM+fNyLb1xnZR6mFaDlzcgTUTen1/mbRohlnycBNp4nvvL6Soxo/xYvkJxq4XIkCt88k1yycJBRWVWzzpwid3x/6zMafvBHnh1/VCoVeZUQPt0BcvM4RBjMJMo28j8GoNXwHRnvFQx/gRDBkBnzRrDRBQWphRk/IgZ326spOR0ERaGGj/tAloH32HINrBToIGBzigavW2U71sg/3MjQpForYeXU/vTyqyblE9VWjSylTeHDaGnZAi1cqKG7jHfGlr4CpjWaJ9zssH3G6d0PBFTXSBtDvMrN/+eqEeuaQAlGL6tJBX5wvyr/6o1Hp+ba4lFOY+QNCms+PFuG0tgPNmohQgzG5Z3tihnl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(36756003)(38100700002)(8936002)(186003)(2906002)(41300700001)(7416002)(5660300002)(52116002)(6916009)(4326008)(66476007)(8676002)(66556008)(66946007)(316002)(54906003)(44832011)(38350700002)(6512007)(30864003)(26005)(2616005)(1076003)(86362001)(83380400001)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t1HuV3SJ6cjQCp6W1/z5sr+FHWzhyfjXa3JyXeDEcLPJrOomaeRj4DLOYojG?=
 =?us-ascii?Q?b5XOZQ+K3SDCVysaxf+9gHSRq/823r9T3uvdZ+/C4PBAA0qLXjQOsBZ6u9UY?=
 =?us-ascii?Q?8Un6ijSVWGDliXo2a9Gg3e05bhg/gTWby9WFgRpcBEoPwSxe85Mes2SKTUNf?=
 =?us-ascii?Q?evnRQ4ffqDIWaE3AIXyBDR/qrVitHyM1638aD6hex6CQcG4bjvZND+b8KQmI?=
 =?us-ascii?Q?beDf4pUWpC6hgWGa4/3AhyglFQT8s3lUoIIBKDRoVqgQUbzG6248dEJAjW7N?=
 =?us-ascii?Q?YskFNOqvzOzAYjLAjrv9EbLfsady0kI+wttp5vAjm/Lf1vgQXlFne1BbkicG?=
 =?us-ascii?Q?e9Kz3MiZwk2t5ZyIsaRJX/WHPSPyVw2zDjI2iLCxclyhW+yiLD8F+Y2WmHzI?=
 =?us-ascii?Q?/qGWAiSCsjwTzzcFsS2dJq/47dUAedrfZFD2OSkgTnl1HVAsr/dpPMUAPgHg?=
 =?us-ascii?Q?Ess04bA9kLOrI6NkUiDT8hMNPkIeNoC+AzHU8HKvgUibcIOCWyzmuym4Yd0+?=
 =?us-ascii?Q?qLBqufHYqZ2gXIhpLR3lHfn4vmvFs67sQlqjZXQTrCFSTOghFeDkjZYjyFnq?=
 =?us-ascii?Q?sSansogESzlzrVWjeECARYD3mzX2DXnLC3LEyLfhNDHW8HSohV12wIEkwqK/?=
 =?us-ascii?Q?bydd4lQyhrS/Hz3T9D0eOHaCnIddbPo9xBsTjRDx0zIARQgchlj3VrPCgL2M?=
 =?us-ascii?Q?0sv9DfUxhxOP2hJblXUGOuIUGIEtr4rY6NMiv2SODis/TclmGkG1K6wjWPXq?=
 =?us-ascii?Q?kU+bDtTtGj8R4Etj4QiiMTImgwC7u+/7SXeODeiVs6X7SsWm32vx5kkgAAkv?=
 =?us-ascii?Q?vpN+pPNRG3oypTbWMOLkNJd/bDCRxjUG0RlUl1ab3DUZp+F088DhnNxmpgUE?=
 =?us-ascii?Q?ciONgsqWzZdWCizYAzO+VAAT/6VGkFW8A8O62XrUmZLaH430fiuTtbQODgUQ?=
 =?us-ascii?Q?VW8Hx2FFRl8m7tUgqdb/V9JXAC57nWeumElmoedq2lHivjElg50cRgKVCwxD?=
 =?us-ascii?Q?EGtdsn5chQ54fGFE2ut6kpeqTi6zCMTGOveNPPYU/+TbLOiOZImczMtKsteg?=
 =?us-ascii?Q?9uzXbVzaR8Deq5bsmLDrumW8NM6qrGzsBvs0HnXii7bPUEXi+9yeYv4wFQol?=
 =?us-ascii?Q?8B+chSDTjQQIKeyXp+h83O5VHOCOcy9VhTJl2vcxmYUIsAzzNES7Z5ikZGa/?=
 =?us-ascii?Q?w99sU0RTgsVr5SMmzOihgxZNBDXvumlyh5ScuI92yXaZ7xR9itS4xa88y5PE?=
 =?us-ascii?Q?3tIs6EgdQUu1HoZnlnpxMatn/NhDA8c+nQeQV+rnP4OVBMpqKth2jpZxZO8j?=
 =?us-ascii?Q?x19rlxF/lQPAiN1Y2+EH1Cu54vep6BDXXWsHeSGrXH/Ahft282WbnIwVtyUE?=
 =?us-ascii?Q?3x3tQDQiWv/Bb06vWHejN8WY664A254ljFbrdaS8Z3MVnciNfK1LOKNeCxej?=
 =?us-ascii?Q?LhaULhEIk5g8NCqmPIunH96Zp4CMDxQPDz4jPjSVgsme9fIhRrJrSI5qjqs4?=
 =?us-ascii?Q?msICT0eaBibDG8KdyazhMX5pKLld/ZnOJGlSn+Sfvr0AP2lZtIE8Mv3DYZAA?=
 =?us-ascii?Q?w18P5a3BHBmrPdusDE1eCnymt9Pvwjlw5GS5ecrIAyk4DQrYwokrM8j/lHxy?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a3d1d8-dbb3-4d8f-593c-08daf3ef57fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:32.7982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAtjM2/oqbuB7Rtb+jkjKdfxrXOjfJnall+AT53G8yfNn7Sqv98mox/XygU14fvfPMpsVYShOvXAEwaYEDeDow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix VSC9959 switch supports frame preemption and has a MAC Merge
layer. In addition to the structured stats that exist for the eMAC,
export the counters associated with its pMAC (pause, RMON, MAC, PHY,
control) plus the high-level MAC Merge layer stats. The unstructured
ethtool counters, as well as the rtnl_link_stats64 were left to report
only the eMAC counters.

Because statistics processing is quite self-contained in ocelot_stats.c
now, I've opted for introducing an ocelot->mm_supported bool, based on
which the common switch lib does everything, rather than pushing the
TSN-specific code in felix_vsc9959.c, as happens for other TSN stuff.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new (v1 was written for enetc)

 drivers/net/dsa/ocelot/felix.c           |   9 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  38 +++
 drivers/net/ethernet/mscc/ocelot_stats.c | 289 ++++++++++++++++++++++-
 include/soc/mscc/ocelot.h                |  40 ++++
 4 files changed, 366 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 00dda0e07d4b..09f839dc9e64 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2066,6 +2066,14 @@ static int felix_port_del_dscp_prio(struct dsa_switch *ds, int port, u8 dscp,
 	return ocelot_port_del_dscp_prio(ocelot, port, dscp, prio);
 }
 
+static void felix_get_mm_stats(struct dsa_switch *ds, int port,
+			       struct ethtool_mm_stats *stats)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_get_mm_stats(ocelot, port, stats);
+}
+
 const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol		= felix_get_tag_protocol,
 	.change_tag_protocol		= felix_change_tag_protocol,
@@ -2073,6 +2081,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.setup				= felix_setup,
 	.teardown			= felix_teardown,
 	.set_ageing_time		= felix_set_ageing_time,
+	.get_mm_stats			= felix_get_mm_stats,
 	.get_stats64			= felix_get_stats64,
 	.get_pause_stats		= felix_get_pause_stats,
 	.get_rmon_stats			= felix_get_rmon_stats,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index ccdc25d47fe1..260d861c7072 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -318,6 +318,29 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_RX_GREEN_PRIO_5,		0x0000a4),
 	REG(SYS_COUNT_RX_GREEN_PRIO_6,		0x0000a8),
 	REG(SYS_COUNT_RX_GREEN_PRIO_7,		0x0000ac),
+	REG(SYS_COUNT_RX_ASSEMBLY_ERRS,		0x0000b0),
+	REG(SYS_COUNT_RX_SMD_ERRS,		0x0000b4),
+	REG(SYS_COUNT_RX_ASSEMBLY_OK,		0x0000b8),
+	REG(SYS_COUNT_RX_MERGE_FRAGMENTS,	0x0000bc),
+	REG(SYS_COUNT_RX_PMAC_OCTETS,		0x0000c0),
+	REG(SYS_COUNT_RX_PMAC_UNICAST,		0x0000c4),
+	REG(SYS_COUNT_RX_PMAC_MULTICAST,	0x0000c8),
+	REG(SYS_COUNT_RX_PMAC_BROADCAST,	0x0000cc),
+	REG(SYS_COUNT_RX_PMAC_SHORTS,		0x0000d0),
+	REG(SYS_COUNT_RX_PMAC_FRAGMENTS,	0x0000d4),
+	REG(SYS_COUNT_RX_PMAC_JABBERS,		0x0000d8),
+	REG(SYS_COUNT_RX_PMAC_CRC_ALIGN_ERRS,	0x0000dc),
+	REG(SYS_COUNT_RX_PMAC_SYM_ERRS,		0x0000e0),
+	REG(SYS_COUNT_RX_PMAC_64,		0x0000e4),
+	REG(SYS_COUNT_RX_PMAC_65_127,		0x0000e8),
+	REG(SYS_COUNT_RX_PMAC_128_255,		0x0000ec),
+	REG(SYS_COUNT_RX_PMAC_256_511,		0x0000f0),
+	REG(SYS_COUNT_RX_PMAC_512_1023,		0x0000f4),
+	REG(SYS_COUNT_RX_PMAC_1024_1526,	0x0000f8),
+	REG(SYS_COUNT_RX_PMAC_1527_MAX,		0x0000fc),
+	REG(SYS_COUNT_RX_PMAC_PAUSE,		0x000100),
+	REG(SYS_COUNT_RX_PMAC_CONTROL,		0x000104),
+	REG(SYS_COUNT_RX_PMAC_LONGS,		0x000108),
 	REG(SYS_COUNT_TX_OCTETS,		0x000200),
 	REG(SYS_COUNT_TX_UNICAST,		0x000204),
 	REG(SYS_COUNT_TX_MULTICAST,		0x000208),
@@ -349,6 +372,20 @@ static const u32 vsc9959_sys_regmap[] = {
 	REG(SYS_COUNT_TX_GREEN_PRIO_6,		0x000270),
 	REG(SYS_COUNT_TX_GREEN_PRIO_7,		0x000274),
 	REG(SYS_COUNT_TX_AGED,			0x000278),
+	REG(SYS_COUNT_TX_MM_HOLD,		0x00027c),
+	REG(SYS_COUNT_TX_MERGE_FRAGMENTS,	0x000280),
+	REG(SYS_COUNT_TX_PMAC_OCTETS,		0x000284),
+	REG(SYS_COUNT_TX_PMAC_UNICAST,		0x000288),
+	REG(SYS_COUNT_TX_PMAC_MULTICAST,	0x00028c),
+	REG(SYS_COUNT_TX_PMAC_BROADCAST,	0x000290),
+	REG(SYS_COUNT_TX_PMAC_PAUSE,		0x000294),
+	REG(SYS_COUNT_TX_PMAC_64,		0x000298),
+	REG(SYS_COUNT_TX_PMAC_65_127,		0x00029c),
+	REG(SYS_COUNT_TX_PMAC_128_255,		0x0002a0),
+	REG(SYS_COUNT_TX_PMAC_256_511,		0x0002a4),
+	REG(SYS_COUNT_TX_PMAC_512_1023,		0x0002a8),
+	REG(SYS_COUNT_TX_PMAC_1024_1526,	0x0002ac),
+	REG(SYS_COUNT_TX_PMAC_1527_MAX,		0x0002b0),
 	REG(SYS_COUNT_DROP_LOCAL,		0x000400),
 	REG(SYS_COUNT_DROP_TAIL,		0x000404),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_0,	0x000408),
@@ -2626,6 +2663,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	}
 
 	ocelot->ptp = 1;
+	ocelot->mm_supported = true;
 
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
 	if (!ds) {
diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 551e3cbfae79..1932cea46cd0 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -54,6 +54,29 @@ enum ocelot_stat {
 	OCELOT_STAT_RX_GREEN_PRIO_5,
 	OCELOT_STAT_RX_GREEN_PRIO_6,
 	OCELOT_STAT_RX_GREEN_PRIO_7,
+	OCELOT_STAT_RX_ASSEMBLY_ERRS,
+	OCELOT_STAT_RX_SMD_ERRS,
+	OCELOT_STAT_RX_ASSEMBLY_OK,
+	OCELOT_STAT_RX_MERGE_FRAGMENTS,
+	OCELOT_STAT_RX_PMAC_OCTETS,
+	OCELOT_STAT_RX_PMAC_UNICAST,
+	OCELOT_STAT_RX_PMAC_MULTICAST,
+	OCELOT_STAT_RX_PMAC_BROADCAST,
+	OCELOT_STAT_RX_PMAC_SHORTS,
+	OCELOT_STAT_RX_PMAC_FRAGMENTS,
+	OCELOT_STAT_RX_PMAC_JABBERS,
+	OCELOT_STAT_RX_PMAC_CRC_ALIGN_ERRS,
+	OCELOT_STAT_RX_PMAC_SYM_ERRS,
+	OCELOT_STAT_RX_PMAC_64,
+	OCELOT_STAT_RX_PMAC_65_127,
+	OCELOT_STAT_RX_PMAC_128_255,
+	OCELOT_STAT_RX_PMAC_256_511,
+	OCELOT_STAT_RX_PMAC_512_1023,
+	OCELOT_STAT_RX_PMAC_1024_1526,
+	OCELOT_STAT_RX_PMAC_1527_MAX,
+	OCELOT_STAT_RX_PMAC_PAUSE,
+	OCELOT_STAT_RX_PMAC_CONTROL,
+	OCELOT_STAT_RX_PMAC_LONGS,
 	OCELOT_STAT_TX_OCTETS,
 	OCELOT_STAT_TX_UNICAST,
 	OCELOT_STAT_TX_MULTICAST,
@@ -85,6 +108,20 @@ enum ocelot_stat {
 	OCELOT_STAT_TX_GREEN_PRIO_6,
 	OCELOT_STAT_TX_GREEN_PRIO_7,
 	OCELOT_STAT_TX_AGED,
+	OCELOT_STAT_TX_MM_HOLD,
+	OCELOT_STAT_TX_MERGE_FRAGMENTS,
+	OCELOT_STAT_TX_PMAC_OCTETS,
+	OCELOT_STAT_TX_PMAC_UNICAST,
+	OCELOT_STAT_TX_PMAC_MULTICAST,
+	OCELOT_STAT_TX_PMAC_BROADCAST,
+	OCELOT_STAT_TX_PMAC_PAUSE,
+	OCELOT_STAT_TX_PMAC_64,
+	OCELOT_STAT_TX_PMAC_65_127,
+	OCELOT_STAT_TX_PMAC_128_255,
+	OCELOT_STAT_TX_PMAC_256_511,
+	OCELOT_STAT_TX_PMAC_512_1023,
+	OCELOT_STAT_TX_PMAC_1024_1526,
+	OCELOT_STAT_TX_PMAC_1527_MAX,
 	OCELOT_STAT_DROP_LOCAL,
 	OCELOT_STAT_DROP_TAIL,
 	OCELOT_STAT_DROP_YELLOW_PRIO_0,
@@ -228,9 +265,52 @@ static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
 
+static const struct ocelot_stat_layout ocelot_mm_stats_layout[OCELOT_NUM_STATS] = {
+	OCELOT_COMMON_STATS,
+	OCELOT_STAT(RX_ASSEMBLY_ERRS),
+	OCELOT_STAT(RX_SMD_ERRS),
+	OCELOT_STAT(RX_ASSEMBLY_OK),
+	OCELOT_STAT(RX_MERGE_FRAGMENTS),
+	OCELOT_STAT(TX_MERGE_FRAGMENTS),
+	OCELOT_STAT(RX_PMAC_OCTETS),
+	OCELOT_STAT(RX_PMAC_UNICAST),
+	OCELOT_STAT(RX_PMAC_MULTICAST),
+	OCELOT_STAT(RX_PMAC_BROADCAST),
+	OCELOT_STAT(RX_PMAC_SHORTS),
+	OCELOT_STAT(RX_PMAC_FRAGMENTS),
+	OCELOT_STAT(RX_PMAC_JABBERS),
+	OCELOT_STAT(RX_PMAC_CRC_ALIGN_ERRS),
+	OCELOT_STAT(RX_PMAC_SYM_ERRS),
+	OCELOT_STAT(RX_PMAC_64),
+	OCELOT_STAT(RX_PMAC_65_127),
+	OCELOT_STAT(RX_PMAC_128_255),
+	OCELOT_STAT(RX_PMAC_256_511),
+	OCELOT_STAT(RX_PMAC_512_1023),
+	OCELOT_STAT(RX_PMAC_1024_1526),
+	OCELOT_STAT(RX_PMAC_1527_MAX),
+	OCELOT_STAT(RX_PMAC_PAUSE),
+	OCELOT_STAT(RX_PMAC_CONTROL),
+	OCELOT_STAT(RX_PMAC_LONGS),
+	OCELOT_STAT(TX_PMAC_OCTETS),
+	OCELOT_STAT(TX_PMAC_UNICAST),
+	OCELOT_STAT(TX_PMAC_MULTICAST),
+	OCELOT_STAT(TX_PMAC_BROADCAST),
+	OCELOT_STAT(TX_PMAC_PAUSE),
+	OCELOT_STAT(TX_PMAC_64),
+	OCELOT_STAT(TX_PMAC_65_127),
+	OCELOT_STAT(TX_PMAC_128_255),
+	OCELOT_STAT(TX_PMAC_256_511),
+	OCELOT_STAT(TX_PMAC_512_1023),
+	OCELOT_STAT(TX_PMAC_1024_1526),
+	OCELOT_STAT(TX_PMAC_1527_MAX),
+};
+
 static const struct ocelot_stat_layout *
 ocelot_get_stats_layout(struct ocelot *ocelot)
 {
+	if (ocelot->mm_supported)
+		return ocelot_mm_stats_layout;
+
 	return ocelot_stats_layout;
 }
 
@@ -410,14 +490,63 @@ static void ocelot_port_pause_stats_cb(struct ocelot *ocelot, int port, void *pr
 	pause_stats->rx_pause_frames = s[OCELOT_STAT_RX_PAUSE];
 }
 
+static void ocelot_port_pmac_pause_stats_cb(struct ocelot *ocelot, int port,
+					    void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_pause_stats *pause_stats = priv;
+
+	pause_stats->tx_pause_frames = s[OCELOT_STAT_TX_PMAC_PAUSE];
+	pause_stats->rx_pause_frames = s[OCELOT_STAT_RX_PMAC_PAUSE];
+}
+
+static void ocelot_port_mm_stats_cb(struct ocelot *ocelot, int port,
+				    void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_mm_stats *stats = priv;
+
+	stats->MACMergeFrameAssErrorCount = s[OCELOT_STAT_RX_ASSEMBLY_ERRS];
+	stats->MACMergeFrameSmdErrorCount = s[OCELOT_STAT_RX_SMD_ERRS];
+	stats->MACMergeFrameAssOkCount = s[OCELOT_STAT_RX_ASSEMBLY_OK];
+	stats->MACMergeFragCountRx = s[OCELOT_STAT_RX_MERGE_FRAGMENTS];
+	stats->MACMergeFragCountTx = s[OCELOT_STAT_TX_MERGE_FRAGMENTS];
+	stats->MACMergeHoldCount = s[OCELOT_STAT_TX_MM_HOLD];
+}
+
 void ocelot_port_get_pause_stats(struct ocelot *ocelot, int port,
 				 struct ethtool_pause_stats *pause_stats)
 {
-	ocelot_port_stats_run(ocelot, port, pause_stats,
-			      ocelot_port_pause_stats_cb);
+	struct net_device *dev;
+
+	switch (pause_stats->src) {
+	case ETHTOOL_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, pause_stats,
+				      ocelot_port_pause_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, pause_stats,
+					      ocelot_port_pmac_pause_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_pause_stats(dev, pause_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_pause_stats);
 
+void ocelot_port_get_mm_stats(struct ocelot *ocelot, int port,
+			      struct ethtool_mm_stats *stats)
+{
+	if (!ocelot->mm_supported)
+		return;
+
+	ocelot_port_stats_run(ocelot, port, stats, ocelot_port_mm_stats_cb);
+}
+EXPORT_SYMBOL_GPL(ocelot_port_get_mm_stats);
+
 static const struct ethtool_rmon_hist_range ocelot_rmon_ranges[] = {
 	{   64,    64 },
 	{   65,   127 },
@@ -456,14 +585,57 @@ static void ocelot_port_rmon_stats_cb(struct ocelot *ocelot, int port, void *pri
 	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_1024_1526];
 }
 
+static void ocelot_port_pmac_rmon_stats_cb(struct ocelot *ocelot, int port,
+					   void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_rmon_stats *rmon_stats = priv;
+
+	rmon_stats->undersize_pkts = s[OCELOT_STAT_RX_PMAC_SHORTS];
+	rmon_stats->oversize_pkts = s[OCELOT_STAT_RX_PMAC_LONGS];
+	rmon_stats->fragments = s[OCELOT_STAT_RX_PMAC_FRAGMENTS];
+	rmon_stats->jabbers = s[OCELOT_STAT_RX_PMAC_JABBERS];
+
+	rmon_stats->hist[0] = s[OCELOT_STAT_RX_PMAC_64];
+	rmon_stats->hist[1] = s[OCELOT_STAT_RX_PMAC_65_127];
+	rmon_stats->hist[2] = s[OCELOT_STAT_RX_PMAC_128_255];
+	rmon_stats->hist[3] = s[OCELOT_STAT_RX_PMAC_256_511];
+	rmon_stats->hist[4] = s[OCELOT_STAT_RX_PMAC_512_1023];
+	rmon_stats->hist[5] = s[OCELOT_STAT_RX_PMAC_1024_1526];
+	rmon_stats->hist[6] = s[OCELOT_STAT_RX_PMAC_1527_MAX];
+
+	rmon_stats->hist_tx[0] = s[OCELOT_STAT_TX_PMAC_64];
+	rmon_stats->hist_tx[1] = s[OCELOT_STAT_TX_PMAC_65_127];
+	rmon_stats->hist_tx[2] = s[OCELOT_STAT_TX_PMAC_128_255];
+	rmon_stats->hist_tx[3] = s[OCELOT_STAT_TX_PMAC_128_255];
+	rmon_stats->hist_tx[4] = s[OCELOT_STAT_TX_PMAC_256_511];
+	rmon_stats->hist_tx[5] = s[OCELOT_STAT_TX_PMAC_512_1023];
+	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_PMAC_1024_1526];
+}
+
 void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
 				struct ethtool_rmon_stats *rmon_stats,
 				const struct ethtool_rmon_hist_range **ranges)
 {
+	struct net_device *dev;
+
 	*ranges = ocelot_rmon_ranges;
 
-	ocelot_port_stats_run(ocelot, port, rmon_stats,
-			      ocelot_port_rmon_stats_cb);
+	switch (rmon_stats->src) {
+	case ETHTOOL_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, rmon_stats,
+				      ocelot_port_rmon_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, rmon_stats,
+					      ocelot_port_pmac_rmon_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_rmon_stats(dev, rmon_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_rmon_stats);
 
@@ -475,11 +647,35 @@ static void ocelot_port_ctrl_stats_cb(struct ocelot *ocelot, int port, void *pri
 	ctrl_stats->MACControlFramesReceived = s[OCELOT_STAT_RX_CONTROL];
 }
 
+static void ocelot_port_pmac_ctrl_stats_cb(struct ocelot *ocelot, int port,
+					   void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_ctrl_stats *ctrl_stats = priv;
+
+	ctrl_stats->MACControlFramesReceived = s[OCELOT_STAT_RX_PMAC_CONTROL];
+}
+
 void ocelot_port_get_eth_ctrl_stats(struct ocelot *ocelot, int port,
 				    struct ethtool_eth_ctrl_stats *ctrl_stats)
 {
-	ocelot_port_stats_run(ocelot, port, ctrl_stats,
-			      ocelot_port_ctrl_stats_cb);
+	struct net_device *dev;
+
+	switch (ctrl_stats->src) {
+	case ETHTOOL_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, ctrl_stats,
+				      ocelot_port_ctrl_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, ctrl_stats,
+					      ocelot_port_pmac_ctrl_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_ctrl_stats(dev, ctrl_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_eth_ctrl_stats);
 
@@ -525,11 +721,60 @@ static void ocelot_port_mac_stats_cb(struct ocelot *ocelot, int port, void *priv
 	mac_stats->AlignmentErrors = s[OCELOT_STAT_RX_CRC_ALIGN_ERRS];
 }
 
+static void ocelot_port_pmac_mac_stats_cb(struct ocelot *ocelot, int port,
+					  void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_mac_stats *mac_stats = priv;
+
+	mac_stats->OctetsTransmittedOK = s[OCELOT_STAT_TX_PMAC_OCTETS];
+	mac_stats->FramesTransmittedOK = s[OCELOT_STAT_TX_PMAC_64] +
+					 s[OCELOT_STAT_TX_PMAC_65_127] +
+					 s[OCELOT_STAT_TX_PMAC_128_255] +
+					 s[OCELOT_STAT_TX_PMAC_256_511] +
+					 s[OCELOT_STAT_TX_PMAC_512_1023] +
+					 s[OCELOT_STAT_TX_PMAC_1024_1526] +
+					 s[OCELOT_STAT_TX_PMAC_1527_MAX];
+	mac_stats->OctetsReceivedOK = s[OCELOT_STAT_RX_PMAC_OCTETS];
+	mac_stats->FramesReceivedOK = s[OCELOT_STAT_RX_PMAC_64] +
+				      s[OCELOT_STAT_RX_PMAC_65_127] +
+				      s[OCELOT_STAT_RX_PMAC_128_255] +
+				      s[OCELOT_STAT_RX_PMAC_256_511] +
+				      s[OCELOT_STAT_RX_PMAC_512_1023] +
+				      s[OCELOT_STAT_RX_PMAC_1024_1526] +
+				      s[OCELOT_STAT_RX_PMAC_1527_MAX];
+	mac_stats->MulticastFramesXmittedOK = s[OCELOT_STAT_TX_PMAC_MULTICAST];
+	mac_stats->BroadcastFramesXmittedOK = s[OCELOT_STAT_TX_PMAC_BROADCAST];
+	mac_stats->MulticastFramesReceivedOK = s[OCELOT_STAT_RX_PMAC_MULTICAST];
+	mac_stats->BroadcastFramesReceivedOK = s[OCELOT_STAT_RX_PMAC_BROADCAST];
+	mac_stats->FrameTooLongErrors = s[OCELOT_STAT_RX_PMAC_LONGS];
+	/* Sadly, C_RX_CRC is the sum of FCS and alignment errors, they are not
+	 * counted individually.
+	 */
+	mac_stats->FrameCheckSequenceErrors = s[OCELOT_STAT_RX_PMAC_CRC_ALIGN_ERRS];
+	mac_stats->AlignmentErrors = s[OCELOT_STAT_RX_PMAC_CRC_ALIGN_ERRS];
+}
+
 void ocelot_port_get_eth_mac_stats(struct ocelot *ocelot, int port,
 				   struct ethtool_eth_mac_stats *mac_stats)
 {
-	ocelot_port_stats_run(ocelot, port, mac_stats,
-			      ocelot_port_mac_stats_cb);
+	struct net_device *dev;
+
+	switch (mac_stats->src) {
+	case ETHTOOL_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, mac_stats,
+				      ocelot_port_mac_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, mac_stats,
+					      ocelot_port_pmac_mac_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_mac_stats(dev, mac_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_eth_mac_stats);
 
@@ -541,11 +786,35 @@ static void ocelot_port_phy_stats_cb(struct ocelot *ocelot, int port, void *priv
 	phy_stats->SymbolErrorDuringCarrier = s[OCELOT_STAT_RX_SYM_ERRS];
 }
 
+static void ocelot_port_pmac_phy_stats_cb(struct ocelot *ocelot, int port,
+					  void *priv)
+{
+	u64 *s = &ocelot->stats[port * OCELOT_NUM_STATS];
+	struct ethtool_eth_phy_stats *phy_stats = priv;
+
+	phy_stats->SymbolErrorDuringCarrier = s[OCELOT_STAT_RX_PMAC_SYM_ERRS];
+}
+
 void ocelot_port_get_eth_phy_stats(struct ocelot *ocelot, int port,
 				   struct ethtool_eth_phy_stats *phy_stats)
 {
-	ocelot_port_stats_run(ocelot, port, phy_stats,
-			      ocelot_port_phy_stats_cb);
+	struct net_device *dev;
+
+	switch (phy_stats->src) {
+	case ETHTOOL_STATS_SRC_EMAC:
+		ocelot_port_stats_run(ocelot, port, phy_stats,
+				      ocelot_port_phy_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_PMAC:
+		if (ocelot->mm_supported)
+			ocelot_port_stats_run(ocelot, port, phy_stats,
+					      ocelot_port_pmac_phy_stats_cb);
+		break;
+	case ETHTOOL_STATS_SRC_AGGREGATE:
+		dev = ocelot->ops->port_to_netdev(ocelot, port);
+		ethtool_aggregate_phy_stats(dev, phy_stats);
+		break;
+	}
 }
 EXPORT_SYMBOL_GPL(ocelot_port_get_eth_phy_stats);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index df62be80a193..6de909d79896 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -362,6 +362,29 @@ enum ocelot_reg {
 	SYS_COUNT_RX_GREEN_PRIO_5,
 	SYS_COUNT_RX_GREEN_PRIO_6,
 	SYS_COUNT_RX_GREEN_PRIO_7,
+	SYS_COUNT_RX_ASSEMBLY_ERRS,
+	SYS_COUNT_RX_SMD_ERRS,
+	SYS_COUNT_RX_ASSEMBLY_OK,
+	SYS_COUNT_RX_MERGE_FRAGMENTS,
+	SYS_COUNT_RX_PMAC_OCTETS,
+	SYS_COUNT_RX_PMAC_UNICAST,
+	SYS_COUNT_RX_PMAC_MULTICAST,
+	SYS_COUNT_RX_PMAC_BROADCAST,
+	SYS_COUNT_RX_PMAC_SHORTS,
+	SYS_COUNT_RX_PMAC_FRAGMENTS,
+	SYS_COUNT_RX_PMAC_JABBERS,
+	SYS_COUNT_RX_PMAC_CRC_ALIGN_ERRS,
+	SYS_COUNT_RX_PMAC_SYM_ERRS,
+	SYS_COUNT_RX_PMAC_64,
+	SYS_COUNT_RX_PMAC_65_127,
+	SYS_COUNT_RX_PMAC_128_255,
+	SYS_COUNT_RX_PMAC_256_511,
+	SYS_COUNT_RX_PMAC_512_1023,
+	SYS_COUNT_RX_PMAC_1024_1526,
+	SYS_COUNT_RX_PMAC_1527_MAX,
+	SYS_COUNT_RX_PMAC_PAUSE,
+	SYS_COUNT_RX_PMAC_CONTROL,
+	SYS_COUNT_RX_PMAC_LONGS,
 	SYS_COUNT_TX_OCTETS,
 	SYS_COUNT_TX_UNICAST,
 	SYS_COUNT_TX_MULTICAST,
@@ -393,6 +416,20 @@ enum ocelot_reg {
 	SYS_COUNT_TX_GREEN_PRIO_6,
 	SYS_COUNT_TX_GREEN_PRIO_7,
 	SYS_COUNT_TX_AGED,
+	SYS_COUNT_TX_MM_HOLD,
+	SYS_COUNT_TX_MERGE_FRAGMENTS,
+	SYS_COUNT_TX_PMAC_OCTETS,
+	SYS_COUNT_TX_PMAC_UNICAST,
+	SYS_COUNT_TX_PMAC_MULTICAST,
+	SYS_COUNT_TX_PMAC_BROADCAST,
+	SYS_COUNT_TX_PMAC_PAUSE,
+	SYS_COUNT_TX_PMAC_64,
+	SYS_COUNT_TX_PMAC_65_127,
+	SYS_COUNT_TX_PMAC_128_255,
+	SYS_COUNT_TX_PMAC_256_511,
+	SYS_COUNT_TX_PMAC_512_1023,
+	SYS_COUNT_TX_PMAC_1024_1526,
+	SYS_COUNT_TX_PMAC_1527_MAX,
 	SYS_COUNT_DROP_LOCAL,
 	SYS_COUNT_DROP_TAIL,
 	SYS_COUNT_DROP_YELLOW_PRIO_0,
@@ -814,6 +851,7 @@ struct ocelot {
 	struct workqueue_struct		*owq;
 
 	u8				ptp:1;
+	u8				mm_supported:1;
 	struct ptp_clock		*ptp_clock;
 	struct ptp_clock_info		ptp_info;
 	struct hwtstamp_config		hwtstamp_config;
@@ -937,6 +975,8 @@ void ocelot_port_get_stats64(struct ocelot *ocelot, int port,
 			     struct rtnl_link_stats64 *stats);
 void ocelot_port_get_pause_stats(struct ocelot *ocelot, int port,
 				 struct ethtool_pause_stats *pause_stats);
+void ocelot_port_get_mm_stats(struct ocelot *ocelot, int port,
+			      struct ethtool_mm_stats *stats);
 void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
 				struct ethtool_rmon_stats *rmon_stats,
 				const struct ethtool_rmon_hist_range **ranges);
-- 
2.34.1

