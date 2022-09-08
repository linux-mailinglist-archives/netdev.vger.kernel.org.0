Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5611C5B23EF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiIHQu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIHQte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:34 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7DDE54;
        Thu,  8 Sep 2022 09:49:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoBrZ/dHJ9uqXfpSxE8pm7CkzbrLNQKhV4bEiT0hOlbqrgGzMcZ8tNHg99DOkczoHn82xQNYpCbyeBodvdmgPXSuxYOhqpGVEsf6L+QqzU2xEzB/q7Suy5mHK0Ga/TbP0tzBmatIXI8NhpkFhNL0GLcwarVEPCoYHW23726kBmZNx2xvLRUaF4y8AJq28GlXFalZX4U+SKiqmNjypP9DX/tRQ1/R6/fWnr6lQVbncLO1lXQdqBaJiQ684d4kx8pO3PxYN5U5ZnlG3ym2ZQBkSCrk2RsF2Xp/nEyWXOJG4Zx3OVe/+mqQToS2VgLSMf/wm32AGPrBrMpgBSxSeN5Ppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34nTt03rCshPh/KGzPIEU3vcwniaxwtbS9f64Bk+RK8=;
 b=E8FeJ9FnhhDsQW1lp7jclJ4SfINZ3nOIHFNgRASOBNh21NtsCKti/NCKT2rtGvI+jz3PpgdTOYSTYiosx7ULP/Mh60PUbqWCTGIXwIazwfb4fH5T0eQ2yK6kia3kLd7RwrXIgd9mBRf9AiGiBopVAkjSg8j+o7R9S65kuPSAudFcp0MoPewzmv6vGJI5/m2bWuhu4cZmlbOYXMPvoKK79Tc+pwcIqbTw+cp4TknYwBDo1RC6+OfRC8MtaW+s8tO6en5aePTOhDK4vgilHC6mpYRv6ZrvLiabIAbjIZ19GgAgFOadxTFWMdNAisjGPYi1HPBoSnbPZwsG4hLPO/D/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34nTt03rCshPh/KGzPIEU3vcwniaxwtbS9f64Bk+RK8=;
 b=sGqrQQMFI8ouAkTjeQTjSv0WX2eqT9FBGlHhjrr3NZpIvT+lPh49mzuFF9u3/C3su2SrU2/JRG6f4BtFd68vyXYMc8GzFpF61Yi3C7ClBD/FLlaG3I+q5OPZAqrQPuzHa0ecGIszGM0OhU3/x13qgOaxnyGKuObRBLr0cl+exJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:15 +0000
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
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 13/14] net: mscc: ocelot: minimize definitions for stats
Date:   Thu,  8 Sep 2022 19:48:15 +0300
Message-Id: <20220908164816.3576795-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eda8af15-8251-43f0-2f61-08da91b9fd81
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: typNsTt0O5Jh2lAnfxOw33xy2+4Cs61BI/H7cUaQ6vNvwNpmZNmEfig1YGS3v7Pzcpk4osi5HY/w8hoJAWz8t4kdmq/OcAYdNCGJX3XQmNl1UskvCywK26bwuPDKrRH2MMCSoSv8tFpGt1713rETsJ4B0qGoq65MbXnUvOasMYVuu/7n74rboVLfD5tnrgi74qXNtm6rnSuK/a+etxNtkGxgU3rDRrSC6/GQHQpeAOW58WcKhOwh4Ekg9Lr2LlPW0AKrCkhaTvSiVRL2sd0HfjNfRRpaEFId6Cz9FxwHzwAHeqbQQsbExueACnS+MUFaVNq2cMa/jPF1slbX6qE0CIXrUMznMqCJGOFHUFDL5S+9vW0n0VZxEYQr8U09j9cl655dIuaKJ16QVvoKA3i7SAEW2pgNtXlA4LpnDIT5EIyf61VMNDaxOdzLZBDmdTSi9A7IWSUKJNrt7OhZBnhvLs9DBtZMoVlA9PLXmIpNDixGgWa9NBlZnn+ilZGCcwbNuN8DPj7nPa+HRgt5AjfGa4cyUPskxkf42zsmHrtcMqAFHvU7RA/lXx0YCGqBPMWJD1FzIBrGqI1df+ak2uohjxtZbMOL9gTu/9bh4Zon3ip/IJhIFMO7efdmyM7CFyg8eybnJlwTKmYlHkSRFWsVEimYR8rtSECABcwjO76JKYw8XNJyDamExpp9OWLmSd7gAgkXgU3p16ogBI82qR2cjnJ9R1ezxKge/ELe94ctHTTXASAb2HvtG5b0UD5gdgwX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(30864003)(7416002)(52116002)(41300700001)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ugl3ahwBj0cMfA9Oht7Jbtunfhl3aIwHqQXYqfn5gHLOOIbqQ7RYJBGBUzfJ?=
 =?us-ascii?Q?rbIpYXa6cg68MMa9VLrYVbU9z7x5CNmxuLsTqEWHuyZzeNOChRQKq9jO7Bn5?=
 =?us-ascii?Q?p4wYvD59CPzxm3uQCxMoLbTapeq+z6LtKpUL5FNBqDxg54BJF1XKk4EihyjQ?=
 =?us-ascii?Q?EKHBAUBGIpJWSG3Wr+TRREy0JGdAsx2dyYN+rHEgw0OmQZyrgJ7JuALZxBAx?=
 =?us-ascii?Q?h9X9zwudYPIzPXdZWsRaHcAlIATLIVLMztEfIJrw0UbfaGlW1KjaiCRB4wpH?=
 =?us-ascii?Q?oYa80XUsz0dKLzj3AkKoofdBoOkFwIXlGU7K+QKQXRTDYMH8OEDuHykc4rFJ?=
 =?us-ascii?Q?xqXt70rDykllBUv8P9+xzOk2lsGRw+rCzXvcdX5W7qv7+JUUQzw49tyBcKMc?=
 =?us-ascii?Q?2Na9Ps4Pwxx+Ry1cGSEMyI3/0RA+86J38MqijVTDnwur4q0JE4ye2y+Ytpeh?=
 =?us-ascii?Q?vtMdXlAqsSd6zdXcLvMnwoKUDusX0TwzN16y31h8T59yrUfu+SB4fjcwqF55?=
 =?us-ascii?Q?r6vo0me/hZauN6A4FVgdPZSfSxThSg9EcT+x1fLpVrZ+VToZ2JhtPHyAGEQD?=
 =?us-ascii?Q?vTHqRrvqJQBChSy1dWhgMuU4fOl3HGlLo83UGh15zePgJ+r5eUh+vPApCiEN?=
 =?us-ascii?Q?Y2G3fcQMzXLcGJHBWtP7syyqOdzgWfOqvrfWGHVctFZW9Wi66M9M5RsCtiGb?=
 =?us-ascii?Q?zt7e+trlrcNModVA/bjq94VRgpbAtpk3BoO3hJpkIB3Uu/NBs8RnZvj+llFa?=
 =?us-ascii?Q?J4/7f46iqick4asBHtTVyQOMN3zGZGtuocqiqb/CYjz/Ipvq0fRvX+d1vC3G?=
 =?us-ascii?Q?TCLfo20ZH4Gokg8CoW1ieAbQlZMbvOR6yA4N6RfZvKqkJF9wGPSF3rdAjXfu?=
 =?us-ascii?Q?yimzQpCe8JFnoGcfJn/JaQawdVocrEKnADdfIn54PgjkldOYv/3iVDxRxItB?=
 =?us-ascii?Q?MkZSojQI5kzAET6VS+nendkO4W/YhZ2CYQCvLSjGsT4deOFvpqKbFvbyxBxh?=
 =?us-ascii?Q?DNhY+hbKDWle1rU8EMtgq9+HQjCixeBjLkQddlxOFtSfTb1b6H1wUUBx3O09?=
 =?us-ascii?Q?8KJCPpBWGsgf9H4731K4WE0BgJVahP7ldmgx/54gWeuj6xLvP8QAJHX/deEJ?=
 =?us-ascii?Q?i0t338FBMafxUe7kYO/FmwmQqazrO1/K1DVgHrgNu5AVtmnxB0oIg8J/cLnt?=
 =?us-ascii?Q?oHyiqnPWg9IXBfnnPxqObbTA7wovlULHu1HobyfrE+RUorqj2V2E/aPvtGeh?=
 =?us-ascii?Q?xlxTvMTo8ISihEf09J8ZyPtc5auK67EAOtZItTu/2E5MDoGMK0Oob3ertC/I?=
 =?us-ascii?Q?OsT9SIr/8yL9TQ2ZnfwHx9L44c4wQlMCiWjdJYvrnnqBqASv2SraEBTc5iEH?=
 =?us-ascii?Q?VGJRQqflHkaaGQIKx2T5NSJHF+bo48QyoiXI1GM6V0iSIxki4EDWHUfSgeHW?=
 =?us-ascii?Q?CLglF64PbZpKLiurfJkkROa21JZR/9hRV5IR431sNWxKtu6cNTSWDEsFnTvR?=
 =?us-ascii?Q?5QxsIOKEGci79pWNNcj0nABtOgrqmPd6hyxQdK25HtNnQK9dEaYog/1Jd6xF?=
 =?us-ascii?Q?IQX9nC9afHu6Jq5ZW+T13ek69TYOsct24Ma4RNIVV4bPXZ+oAVeMhKkitUAk?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda8af15-8251-43f0-2f61-08da91b9fd81
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:43.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6irvKOLZvUTO8vUFX/iCzuVZEZv5YwA6WSBY0JKmn8HmjQzukm6PKt+tWCpJ9xjW2boseGIcq9RVHY5pOkpoWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current definition of struct ocelot_stat_layout is long-winded (4
lines per entry, and we have hundreds of entries), so we could make an
effort to use the C preprocessor and reduce the line count.

Create an implicit correspondence between enum ocelot_reg, which tells
us the register address (SYS_COUNT_RX_OCTETS etc) and enum ocelot_stat
which allows us to index the ocelot->stats array (OCELOT_STAT_RX_OCTETS
etc), and don't require us to specify both when we define what stats
each switch family has.

Create an OCELOT_STAT() macro that pairs only an enum ocelot_stat to an
enum ocelot_reg, and an OCELOT_STAT_ETHTOOL() macro which also contains
a name exported to the unstructured ethtool -S stringset API. For now,
we define all counters as having the OCELOT_STAT_ETHTOOL() kind, but we
will add more counters in the future which are not exported to the
unstructured ethtool -S.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 465 +++++----------------
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 465 +++++----------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 465 +++++----------------
 include/soc/mscc/ocelot.h                  |  11 +
 4 files changed, 290 insertions(+), 1116 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index c8377a79d5ec..07641915fcf0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -622,378 +622,99 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 };
 
 static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] = {
-	[OCELOT_STAT_RX_OCTETS] = {
-		.name = "rx_octets",
-		.reg = SYS_COUNT_RX_OCTETS,
-	},
-	[OCELOT_STAT_RX_UNICAST] = {
-		.name = "rx_unicast",
-		.reg = SYS_COUNT_RX_UNICAST,
-	},
-	[OCELOT_STAT_RX_MULTICAST] = {
-		.name = "rx_multicast",
-		.reg = SYS_COUNT_RX_MULTICAST,
-	},
-	[OCELOT_STAT_RX_BROADCAST] = {
-		.name = "rx_broadcast",
-		.reg = SYS_COUNT_RX_BROADCAST,
-	},
-	[OCELOT_STAT_RX_SHORTS] = {
-		.name = "rx_shorts",
-		.reg = SYS_COUNT_RX_SHORTS,
-	},
-	[OCELOT_STAT_RX_FRAGMENTS] = {
-		.name = "rx_fragments",
-		.reg = SYS_COUNT_RX_FRAGMENTS,
-	},
-	[OCELOT_STAT_RX_JABBERS] = {
-		.name = "rx_jabbers",
-		.reg = SYS_COUNT_RX_JABBERS,
-	},
-	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
-		.name = "rx_crc_align_errs",
-		.reg = SYS_COUNT_RX_CRC_ALIGN_ERRS,
-	},
-	[OCELOT_STAT_RX_SYM_ERRS] = {
-		.name = "rx_sym_errs",
-		.reg = SYS_COUNT_RX_SYM_ERRS,
-	},
-	[OCELOT_STAT_RX_64] = {
-		.name = "rx_frames_below_65_octets",
-		.reg = SYS_COUNT_RX_64,
-	},
-	[OCELOT_STAT_RX_65_127] = {
-		.name = "rx_frames_65_to_127_octets",
-		.reg = SYS_COUNT_RX_65_127,
-	},
-	[OCELOT_STAT_RX_128_255] = {
-		.name = "rx_frames_128_to_255_octets",
-		.reg = SYS_COUNT_RX_128_255,
-	},
-	[OCELOT_STAT_RX_256_511] = {
-		.name = "rx_frames_256_to_511_octets",
-		.reg = SYS_COUNT_RX_256_511,
-	},
-	[OCELOT_STAT_RX_512_1023] = {
-		.name = "rx_frames_512_to_1023_octets",
-		.reg = SYS_COUNT_RX_512_1023,
-	},
-	[OCELOT_STAT_RX_1024_1526] = {
-		.name = "rx_frames_1024_to_1526_octets",
-		.reg = SYS_COUNT_RX_1024_1526,
-	},
-	[OCELOT_STAT_RX_1527_MAX] = {
-		.name = "rx_frames_over_1526_octets",
-		.reg = SYS_COUNT_RX_1527_MAX,
-	},
-	[OCELOT_STAT_RX_PAUSE] = {
-		.name = "rx_pause",
-		.reg = SYS_COUNT_RX_PAUSE,
-	},
-	[OCELOT_STAT_RX_CONTROL] = {
-		.name = "rx_control",
-		.reg = SYS_COUNT_RX_CONTROL,
-	},
-	[OCELOT_STAT_RX_LONGS] = {
-		.name = "rx_longs",
-		.reg = SYS_COUNT_RX_LONGS,
-	},
-	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
-		.name = "rx_classified_drops",
-		.reg = SYS_COUNT_RX_CLASSIFIED_DROPS,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_0] = {
-		.name = "rx_red_prio_0",
-		.reg = SYS_COUNT_RX_RED_PRIO_0,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_1] = {
-		.name = "rx_red_prio_1",
-		.reg = SYS_COUNT_RX_RED_PRIO_1,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_2] = {
-		.name = "rx_red_prio_2",
-		.reg = SYS_COUNT_RX_RED_PRIO_2,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_3] = {
-		.name = "rx_red_prio_3",
-		.reg = SYS_COUNT_RX_RED_PRIO_3,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_4] = {
-		.name = "rx_red_prio_4",
-		.reg = SYS_COUNT_RX_RED_PRIO_4,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_5] = {
-		.name = "rx_red_prio_5",
-		.reg = SYS_COUNT_RX_RED_PRIO_5,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_6] = {
-		.name = "rx_red_prio_6",
-		.reg = SYS_COUNT_RX_RED_PRIO_6,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_7] = {
-		.name = "rx_red_prio_7",
-		.reg = SYS_COUNT_RX_RED_PRIO_7,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
-		.name = "rx_yellow_prio_0",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
-		.name = "rx_yellow_prio_1",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
-		.name = "rx_yellow_prio_2",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
-		.name = "rx_yellow_prio_3",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
-		.name = "rx_yellow_prio_4",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
-		.name = "rx_yellow_prio_5",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
-		.name = "rx_yellow_prio_6",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
-		.name = "rx_yellow_prio_7",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
-		.name = "rx_green_prio_0",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
-		.name = "rx_green_prio_1",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
-		.name = "rx_green_prio_2",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
-		.name = "rx_green_prio_3",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
-		.name = "rx_green_prio_4",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
-		.name = "rx_green_prio_5",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
-		.name = "rx_green_prio_6",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
-		.name = "rx_green_prio_7",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_7,
-	},
-	[OCELOT_STAT_TX_OCTETS] = {
-		.name = "tx_octets",
-		.reg = SYS_COUNT_TX_OCTETS,
-	},
-	[OCELOT_STAT_TX_UNICAST] = {
-		.name = "tx_unicast",
-		.reg = SYS_COUNT_TX_UNICAST,
-	},
-	[OCELOT_STAT_TX_MULTICAST] = {
-		.name = "tx_multicast",
-		.reg = SYS_COUNT_TX_MULTICAST,
-	},
-	[OCELOT_STAT_TX_BROADCAST] = {
-		.name = "tx_broadcast",
-		.reg = SYS_COUNT_TX_BROADCAST,
-	},
-	[OCELOT_STAT_TX_COLLISION] = {
-		.name = "tx_collision",
-		.reg = SYS_COUNT_TX_COLLISION,
-	},
-	[OCELOT_STAT_TX_DROPS] = {
-		.name = "tx_drops",
-		.reg = SYS_COUNT_TX_DROPS,
-	},
-	[OCELOT_STAT_TX_PAUSE] = {
-		.name = "tx_pause",
-		.reg = SYS_COUNT_TX_PAUSE,
-	},
-	[OCELOT_STAT_TX_64] = {
-		.name = "tx_frames_below_65_octets",
-		.reg = SYS_COUNT_TX_64,
-	},
-	[OCELOT_STAT_TX_65_127] = {
-		.name = "tx_frames_65_to_127_octets",
-		.reg = SYS_COUNT_TX_65_127,
-	},
-	[OCELOT_STAT_TX_128_255] = {
-		.name = "tx_frames_128_255_octets",
-		.reg = SYS_COUNT_TX_128_255,
-	},
-	[OCELOT_STAT_TX_256_511] = {
-		.name = "tx_frames_256_511_octets",
-		.reg = SYS_COUNT_TX_256_511,
-	},
-	[OCELOT_STAT_TX_512_1023] = {
-		.name = "tx_frames_512_1023_octets",
-		.reg = SYS_COUNT_TX_512_1023,
-	},
-	[OCELOT_STAT_TX_1024_1526] = {
-		.name = "tx_frames_1024_1526_octets",
-		.reg = SYS_COUNT_TX_1024_1526,
-	},
-	[OCELOT_STAT_TX_1527_MAX] = {
-		.name = "tx_frames_over_1526_octets",
-		.reg = SYS_COUNT_TX_1527_MAX,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
-		.name = "tx_yellow_prio_0",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
-		.name = "tx_yellow_prio_1",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
-		.name = "tx_yellow_prio_2",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
-		.name = "tx_yellow_prio_3",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
-		.name = "tx_yellow_prio_4",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
-		.name = "tx_yellow_prio_5",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
-		.name = "tx_yellow_prio_6",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
-		.name = "tx_yellow_prio_7",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
-		.name = "tx_green_prio_0",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
-		.name = "tx_green_prio_1",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
-		.name = "tx_green_prio_2",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
-		.name = "tx_green_prio_3",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
-		.name = "tx_green_prio_4",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
-		.name = "tx_green_prio_5",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
-		.name = "tx_green_prio_6",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
-		.name = "tx_green_prio_7",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_7,
-	},
-	[OCELOT_STAT_TX_AGED] = {
-		.name = "tx_aged",
-		.reg = SYS_COUNT_TX_AGED,
-	},
-	[OCELOT_STAT_DROP_LOCAL] = {
-		.name = "drop_local",
-		.reg = SYS_COUNT_DROP_LOCAL,
-	},
-	[OCELOT_STAT_DROP_TAIL] = {
-		.name = "drop_tail",
-		.reg = SYS_COUNT_DROP_TAIL,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
-		.name = "drop_yellow_prio_0",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
-		.name = "drop_yellow_prio_1",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
-		.name = "drop_yellow_prio_2",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
-		.name = "drop_yellow_prio_3",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
-		.name = "drop_yellow_prio_4",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
-		.name = "drop_yellow_prio_5",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
-		.name = "drop_yellow_prio_6",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
-		.name = "drop_yellow_prio_7",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
-		.name = "drop_green_prio_0",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
-		.name = "drop_green_prio_1",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
-		.name = "drop_green_prio_2",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
-		.name = "drop_green_prio_3",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
-		.name = "drop_green_prio_4",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
-		.name = "drop_green_prio_5",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
-		.name = "drop_green_prio_6",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
-		.name = "drop_green_prio_7",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_7,
-	},
+	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"),
+	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"),
+	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"),
+	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"),
+	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"),
+	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"),
+	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"),
+	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"),
+	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"),
+	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"),
+	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"),
+	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"),
+	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"),
+	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"),
+	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"),
+	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"),
+	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"),
+	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"),
+	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"),
+	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"),
+	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"),
+	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"),
+	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"),
+	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"),
+	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"),
+	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"),
+	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"),
+	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"),
+	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"),
+	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"),
+	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"),
+	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"),
+	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"),
+	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"),
+	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7"),
 };
 
 static const struct vcap_field vsc9959_vcap_es0_keys[] = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 5799c4e50e36..a8f69d483abf 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -614,378 +614,99 @@ static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
 };
 
 static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STATS] = {
-	[OCELOT_STAT_RX_OCTETS] = {
-		.name = "rx_octets",
-		.reg = SYS_COUNT_RX_OCTETS,
-	},
-	[OCELOT_STAT_RX_UNICAST] = {
-		.name = "rx_unicast",
-		.reg = SYS_COUNT_RX_UNICAST,
-	},
-	[OCELOT_STAT_RX_MULTICAST] = {
-		.name = "rx_multicast",
-		.reg = SYS_COUNT_RX_MULTICAST,
-	},
-	[OCELOT_STAT_RX_BROADCAST] = {
-		.name = "rx_broadcast",
-		.reg = SYS_COUNT_RX_BROADCAST,
-	},
-	[OCELOT_STAT_RX_SHORTS] = {
-		.name = "rx_shorts",
-		.reg = SYS_COUNT_RX_SHORTS,
-	},
-	[OCELOT_STAT_RX_FRAGMENTS] = {
-		.name = "rx_fragments",
-		.reg = SYS_COUNT_RX_FRAGMENTS,
-	},
-	[OCELOT_STAT_RX_JABBERS] = {
-		.name = "rx_jabbers",
-		.reg = SYS_COUNT_RX_JABBERS,
-	},
-	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
-		.name = "rx_crc_align_errs",
-		.reg = SYS_COUNT_RX_CRC_ALIGN_ERRS,
-	},
-	[OCELOT_STAT_RX_SYM_ERRS] = {
-		.name = "rx_sym_errs",
-		.reg = SYS_COUNT_RX_SYM_ERRS,
-	},
-	[OCELOT_STAT_RX_64] = {
-		.name = "rx_frames_below_65_octets",
-		.reg = SYS_COUNT_RX_64,
-	},
-	[OCELOT_STAT_RX_65_127] = {
-		.name = "rx_frames_65_to_127_octets",
-		.reg = SYS_COUNT_RX_65_127,
-	},
-	[OCELOT_STAT_RX_128_255] = {
-		.name = "rx_frames_128_to_255_octets",
-		.reg = SYS_COUNT_RX_128_255,
-	},
-	[OCELOT_STAT_RX_256_511] = {
-		.name = "rx_frames_256_to_511_octets",
-		.reg = SYS_COUNT_RX_256_511,
-	},
-	[OCELOT_STAT_RX_512_1023] = {
-		.name = "rx_frames_512_to_1023_octets",
-		.reg = SYS_COUNT_RX_512_1023,
-	},
-	[OCELOT_STAT_RX_1024_1526] = {
-		.name = "rx_frames_1024_to_1526_octets",
-		.reg = SYS_COUNT_RX_1024_1526,
-	},
-	[OCELOT_STAT_RX_1527_MAX] = {
-		.name = "rx_frames_over_1526_octets",
-		.reg = SYS_COUNT_RX_1527_MAX,
-	},
-	[OCELOT_STAT_RX_PAUSE] = {
-		.name = "rx_pause",
-		.reg = SYS_COUNT_RX_PAUSE,
-	},
-	[OCELOT_STAT_RX_CONTROL] = {
-		.name = "rx_control",
-		.reg = SYS_COUNT_RX_CONTROL,
-	},
-	[OCELOT_STAT_RX_LONGS] = {
-		.name = "rx_longs",
-		.reg = SYS_COUNT_RX_LONGS,
-	},
-	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
-		.name = "rx_classified_drops",
-		.reg = SYS_COUNT_RX_CLASSIFIED_DROPS,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_0] = {
-		.name = "rx_red_prio_0",
-		.reg = SYS_COUNT_RX_RED_PRIO_0,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_1] = {
-		.name = "rx_red_prio_1",
-		.reg = SYS_COUNT_RX_RED_PRIO_1,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_2] = {
-		.name = "rx_red_prio_2",
-		.reg = SYS_COUNT_RX_RED_PRIO_2,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_3] = {
-		.name = "rx_red_prio_3",
-		.reg = SYS_COUNT_RX_RED_PRIO_3,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_4] = {
-		.name = "rx_red_prio_4",
-		.reg = SYS_COUNT_RX_RED_PRIO_4,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_5] = {
-		.name = "rx_red_prio_5",
-		.reg = SYS_COUNT_RX_RED_PRIO_5,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_6] = {
-		.name = "rx_red_prio_6",
-		.reg = SYS_COUNT_RX_RED_PRIO_6,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_7] = {
-		.name = "rx_red_prio_7",
-		.reg = SYS_COUNT_RX_RED_PRIO_7,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
-		.name = "rx_yellow_prio_0",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
-		.name = "rx_yellow_prio_1",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
-		.name = "rx_yellow_prio_2",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
-		.name = "rx_yellow_prio_3",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
-		.name = "rx_yellow_prio_4",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
-		.name = "rx_yellow_prio_5",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
-		.name = "rx_yellow_prio_6",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
-		.name = "rx_yellow_prio_7",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
-		.name = "rx_green_prio_0",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
-		.name = "rx_green_prio_1",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
-		.name = "rx_green_prio_2",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
-		.name = "rx_green_prio_3",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
-		.name = "rx_green_prio_4",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
-		.name = "rx_green_prio_5",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
-		.name = "rx_green_prio_6",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
-		.name = "rx_green_prio_7",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_7,
-	},
-	[OCELOT_STAT_TX_OCTETS] = {
-		.name = "tx_octets",
-		.reg = SYS_COUNT_TX_OCTETS,
-	},
-	[OCELOT_STAT_TX_UNICAST] = {
-		.name = "tx_unicast",
-		.reg = SYS_COUNT_TX_UNICAST,
-	},
-	[OCELOT_STAT_TX_MULTICAST] = {
-		.name = "tx_multicast",
-		.reg = SYS_COUNT_TX_MULTICAST,
-	},
-	[OCELOT_STAT_TX_BROADCAST] = {
-		.name = "tx_broadcast",
-		.reg = SYS_COUNT_TX_BROADCAST,
-	},
-	[OCELOT_STAT_TX_COLLISION] = {
-		.name = "tx_collision",
-		.reg = SYS_COUNT_TX_COLLISION,
-	},
-	[OCELOT_STAT_TX_DROPS] = {
-		.name = "tx_drops",
-		.reg = SYS_COUNT_TX_DROPS,
-	},
-	[OCELOT_STAT_TX_PAUSE] = {
-		.name = "tx_pause",
-		.reg = SYS_COUNT_TX_PAUSE,
-	},
-	[OCELOT_STAT_TX_64] = {
-		.name = "tx_frames_below_65_octets",
-		.reg = SYS_COUNT_TX_64,
-	},
-	[OCELOT_STAT_TX_65_127] = {
-		.name = "tx_frames_65_to_127_octets",
-		.reg = SYS_COUNT_TX_65_127,
-	},
-	[OCELOT_STAT_TX_128_255] = {
-		.name = "tx_frames_128_255_octets",
-		.reg = SYS_COUNT_TX_128_255,
-	},
-	[OCELOT_STAT_TX_256_511] = {
-		.name = "tx_frames_256_511_octets",
-		.reg = SYS_COUNT_TX_256_511,
-	},
-	[OCELOT_STAT_TX_512_1023] = {
-		.name = "tx_frames_512_1023_octets",
-		.reg = SYS_COUNT_TX_512_1023,
-	},
-	[OCELOT_STAT_TX_1024_1526] = {
-		.name = "tx_frames_1024_1526_octets",
-		.reg = SYS_COUNT_TX_1024_1526,
-	},
-	[OCELOT_STAT_TX_1527_MAX] = {
-		.name = "tx_frames_over_1526_octets",
-		.reg = SYS_COUNT_TX_1527_MAX,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
-		.name = "tx_yellow_prio_0",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
-		.name = "tx_yellow_prio_1",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
-		.name = "tx_yellow_prio_2",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
-		.name = "tx_yellow_prio_3",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
-		.name = "tx_yellow_prio_4",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
-		.name = "tx_yellow_prio_5",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
-		.name = "tx_yellow_prio_6",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
-		.name = "tx_yellow_prio_7",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
-		.name = "tx_green_prio_0",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
-		.name = "tx_green_prio_1",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
-		.name = "tx_green_prio_2",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
-		.name = "tx_green_prio_3",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
-		.name = "tx_green_prio_4",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
-		.name = "tx_green_prio_5",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
-		.name = "tx_green_prio_6",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
-		.name = "tx_green_prio_7",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_7,
-	},
-	[OCELOT_STAT_TX_AGED] = {
-		.name = "tx_aged",
-		.reg = SYS_COUNT_TX_AGED,
-	},
-	[OCELOT_STAT_DROP_LOCAL] = {
-		.name = "drop_local",
-		.reg = SYS_COUNT_DROP_LOCAL,
-	},
-	[OCELOT_STAT_DROP_TAIL] = {
-		.name = "drop_tail",
-		.reg = SYS_COUNT_DROP_TAIL,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
-		.name = "drop_yellow_prio_0",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
-		.name = "drop_yellow_prio_1",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
-		.name = "drop_yellow_prio_2",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
-		.name = "drop_yellow_prio_3",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
-		.name = "drop_yellow_prio_4",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
-		.name = "drop_yellow_prio_5",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
-		.name = "drop_yellow_prio_6",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
-		.name = "drop_yellow_prio_7",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
-		.name = "drop_green_prio_0",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
-		.name = "drop_green_prio_1",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
-		.name = "drop_green_prio_2",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
-		.name = "drop_green_prio_3",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
-		.name = "drop_green_prio_4",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
-		.name = "drop_green_prio_5",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
-		.name = "drop_green_prio_6",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
-		.name = "drop_green_prio_7",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_7,
-	},
+	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"),
+	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"),
+	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"),
+	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"),
+	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"),
+	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"),
+	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"),
+	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"),
+	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"),
+	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"),
+	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"),
+	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"),
+	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"),
+	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"),
+	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"),
+	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"),
+	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"),
+	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"),
+	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"),
+	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"),
+	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"),
+	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"),
+	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"),
+	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"),
+	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"),
+	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"),
+	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"),
+	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"),
+	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"),
+	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"),
+	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"),
+	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"),
+	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"),
+	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"),
+	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7"),
 };
 
 static const struct vcap_field vsc9953_vcap_es0_keys[] = {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index fc1c890e3db1..8fe84d753cc9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -97,378 +97,99 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 };
 
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	[OCELOT_STAT_RX_OCTETS] = {
-		.name = "rx_octets",
-		.reg = SYS_COUNT_RX_OCTETS,
-	},
-	[OCELOT_STAT_RX_UNICAST] = {
-		.name = "rx_unicast",
-		.reg = SYS_COUNT_RX_UNICAST,
-	},
-	[OCELOT_STAT_RX_MULTICAST] = {
-		.name = "rx_multicast",
-		.reg = SYS_COUNT_RX_MULTICAST,
-	},
-	[OCELOT_STAT_RX_BROADCAST] = {
-		.name = "rx_broadcast",
-		.reg = SYS_COUNT_RX_BROADCAST,
-	},
-	[OCELOT_STAT_RX_SHORTS] = {
-		.name = "rx_shorts",
-		.reg = SYS_COUNT_RX_SHORTS,
-	},
-	[OCELOT_STAT_RX_FRAGMENTS] = {
-		.name = "rx_fragments",
-		.reg = SYS_COUNT_RX_FRAGMENTS,
-	},
-	[OCELOT_STAT_RX_JABBERS] = {
-		.name = "rx_jabbers",
-		.reg = SYS_COUNT_RX_JABBERS,
-	},
-	[OCELOT_STAT_RX_CRC_ALIGN_ERRS] = {
-		.name = "rx_crc_align_errs",
-		.reg = SYS_COUNT_RX_CRC_ALIGN_ERRS,
-	},
-	[OCELOT_STAT_RX_SYM_ERRS] = {
-		.name = "rx_sym_errs",
-		.reg = SYS_COUNT_RX_SYM_ERRS,
-	},
-	[OCELOT_STAT_RX_64] = {
-		.name = "rx_frames_below_65_octets",
-		.reg = SYS_COUNT_RX_64,
-	},
-	[OCELOT_STAT_RX_65_127] = {
-		.name = "rx_frames_65_to_127_octets",
-		.reg = SYS_COUNT_RX_65_127,
-	},
-	[OCELOT_STAT_RX_128_255] = {
-		.name = "rx_frames_128_to_255_octets",
-		.reg = SYS_COUNT_RX_128_255,
-	},
-	[OCELOT_STAT_RX_256_511] = {
-		.name = "rx_frames_256_to_511_octets",
-		.reg = SYS_COUNT_RX_256_511,
-	},
-	[OCELOT_STAT_RX_512_1023] = {
-		.name = "rx_frames_512_to_1023_octets",
-		.reg = SYS_COUNT_RX_512_1023,
-	},
-	[OCELOT_STAT_RX_1024_1526] = {
-		.name = "rx_frames_1024_to_1526_octets",
-		.reg = SYS_COUNT_RX_1024_1526,
-	},
-	[OCELOT_STAT_RX_1527_MAX] = {
-		.name = "rx_frames_over_1526_octets",
-		.reg = SYS_COUNT_RX_1527_MAX,
-	},
-	[OCELOT_STAT_RX_PAUSE] = {
-		.name = "rx_pause",
-		.reg = SYS_COUNT_RX_PAUSE,
-	},
-	[OCELOT_STAT_RX_CONTROL] = {
-		.name = "rx_control",
-		.reg = SYS_COUNT_RX_CONTROL,
-	},
-	[OCELOT_STAT_RX_LONGS] = {
-		.name = "rx_longs",
-		.reg = SYS_COUNT_RX_LONGS,
-	},
-	[OCELOT_STAT_RX_CLASSIFIED_DROPS] = {
-		.name = "rx_classified_drops",
-		.reg = SYS_COUNT_RX_CLASSIFIED_DROPS,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_0] = {
-		.name = "rx_red_prio_0",
-		.reg = SYS_COUNT_RX_RED_PRIO_0,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_1] = {
-		.name = "rx_red_prio_1",
-		.reg = SYS_COUNT_RX_RED_PRIO_1,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_2] = {
-		.name = "rx_red_prio_2",
-		.reg = SYS_COUNT_RX_RED_PRIO_2,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_3] = {
-		.name = "rx_red_prio_3",
-		.reg = SYS_COUNT_RX_RED_PRIO_3,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_4] = {
-		.name = "rx_red_prio_4",
-		.reg = SYS_COUNT_RX_RED_PRIO_4,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_5] = {
-		.name = "rx_red_prio_5",
-		.reg = SYS_COUNT_RX_RED_PRIO_5,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_6] = {
-		.name = "rx_red_prio_6",
-		.reg = SYS_COUNT_RX_RED_PRIO_6,
-	},
-	[OCELOT_STAT_RX_RED_PRIO_7] = {
-		.name = "rx_red_prio_7",
-		.reg = SYS_COUNT_RX_RED_PRIO_7,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_0] = {
-		.name = "rx_yellow_prio_0",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_1] = {
-		.name = "rx_yellow_prio_1",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_2] = {
-		.name = "rx_yellow_prio_2",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_3] = {
-		.name = "rx_yellow_prio_3",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_4] = {
-		.name = "rx_yellow_prio_4",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_5] = {
-		.name = "rx_yellow_prio_5",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_6] = {
-		.name = "rx_yellow_prio_6",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_RX_YELLOW_PRIO_7] = {
-		.name = "rx_yellow_prio_7",
-		.reg = SYS_COUNT_RX_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_0] = {
-		.name = "rx_green_prio_0",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_1] = {
-		.name = "rx_green_prio_1",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_2] = {
-		.name = "rx_green_prio_2",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_3] = {
-		.name = "rx_green_prio_3",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_4] = {
-		.name = "rx_green_prio_4",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_5] = {
-		.name = "rx_green_prio_5",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_6] = {
-		.name = "rx_green_prio_6",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_RX_GREEN_PRIO_7] = {
-		.name = "rx_green_prio_7",
-		.reg = SYS_COUNT_RX_GREEN_PRIO_7,
-	},
-	[OCELOT_STAT_TX_OCTETS] = {
-		.name = "tx_octets",
-		.reg = SYS_COUNT_TX_OCTETS,
-	},
-	[OCELOT_STAT_TX_UNICAST] = {
-		.name = "tx_unicast",
-		.reg = SYS_COUNT_TX_UNICAST,
-	},
-	[OCELOT_STAT_TX_MULTICAST] = {
-		.name = "tx_multicast",
-		.reg = SYS_COUNT_TX_MULTICAST,
-	},
-	[OCELOT_STAT_TX_BROADCAST] = {
-		.name = "tx_broadcast",
-		.reg = SYS_COUNT_TX_BROADCAST,
-	},
-	[OCELOT_STAT_TX_COLLISION] = {
-		.name = "tx_collision",
-		.reg = SYS_COUNT_TX_COLLISION,
-	},
-	[OCELOT_STAT_TX_DROPS] = {
-		.name = "tx_drops",
-		.reg = SYS_COUNT_TX_DROPS,
-	},
-	[OCELOT_STAT_TX_PAUSE] = {
-		.name = "tx_pause",
-		.reg = SYS_COUNT_TX_PAUSE,
-	},
-	[OCELOT_STAT_TX_64] = {
-		.name = "tx_frames_below_65_octets",
-		.reg = SYS_COUNT_TX_64,
-	},
-	[OCELOT_STAT_TX_65_127] = {
-		.name = "tx_frames_65_to_127_octets",
-		.reg = SYS_COUNT_TX_65_127,
-	},
-	[OCELOT_STAT_TX_128_255] = {
-		.name = "tx_frames_128_255_octets",
-		.reg = SYS_COUNT_TX_128_255,
-	},
-	[OCELOT_STAT_TX_256_511] = {
-		.name = "tx_frames_256_511_octets",
-		.reg = SYS_COUNT_TX_256_511,
-	},
-	[OCELOT_STAT_TX_512_1023] = {
-		.name = "tx_frames_512_1023_octets",
-		.reg = SYS_COUNT_TX_512_1023,
-	},
-	[OCELOT_STAT_TX_1024_1526] = {
-		.name = "tx_frames_1024_1526_octets",
-		.reg = SYS_COUNT_TX_1024_1526,
-	},
-	[OCELOT_STAT_TX_1527_MAX] = {
-		.name = "tx_frames_over_1526_octets",
-		.reg = SYS_COUNT_TX_1527_MAX,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_0] = {
-		.name = "tx_yellow_prio_0",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_1] = {
-		.name = "tx_yellow_prio_1",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_2] = {
-		.name = "tx_yellow_prio_2",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_3] = {
-		.name = "tx_yellow_prio_3",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_4] = {
-		.name = "tx_yellow_prio_4",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_5] = {
-		.name = "tx_yellow_prio_5",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_6] = {
-		.name = "tx_yellow_prio_6",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_TX_YELLOW_PRIO_7] = {
-		.name = "tx_yellow_prio_7",
-		.reg = SYS_COUNT_TX_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_0] = {
-		.name = "tx_green_prio_0",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_1] = {
-		.name = "tx_green_prio_1",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_2] = {
-		.name = "tx_green_prio_2",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_3] = {
-		.name = "tx_green_prio_3",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_4] = {
-		.name = "tx_green_prio_4",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_5] = {
-		.name = "tx_green_prio_5",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_6] = {
-		.name = "tx_green_prio_6",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_TX_GREEN_PRIO_7] = {
-		.name = "tx_green_prio_7",
-		.reg = SYS_COUNT_TX_GREEN_PRIO_7,
-	},
-	[OCELOT_STAT_TX_AGED] = {
-		.name = "tx_aged",
-		.reg = SYS_COUNT_TX_AGED,
-	},
-	[OCELOT_STAT_DROP_LOCAL] = {
-		.name = "drop_local",
-		.reg = SYS_COUNT_DROP_LOCAL,
-	},
-	[OCELOT_STAT_DROP_TAIL] = {
-		.name = "drop_tail",
-		.reg = SYS_COUNT_DROP_TAIL,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_0] = {
-		.name = "drop_yellow_prio_0",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_0,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_1] = {
-		.name = "drop_yellow_prio_1",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_1,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_2] = {
-		.name = "drop_yellow_prio_2",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_2,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_3] = {
-		.name = "drop_yellow_prio_3",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_3,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_4] = {
-		.name = "drop_yellow_prio_4",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_4,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_5] = {
-		.name = "drop_yellow_prio_5",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_5,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_6] = {
-		.name = "drop_yellow_prio_6",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_6,
-	},
-	[OCELOT_STAT_DROP_YELLOW_PRIO_7] = {
-		.name = "drop_yellow_prio_7",
-		.reg = SYS_COUNT_DROP_YELLOW_PRIO_7,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_0] = {
-		.name = "drop_green_prio_0",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_0,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_1] = {
-		.name = "drop_green_prio_1",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_1,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_2] = {
-		.name = "drop_green_prio_2",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_2,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_3] = {
-		.name = "drop_green_prio_3",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_3,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_4] = {
-		.name = "drop_green_prio_4",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_4,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_5] = {
-		.name = "drop_green_prio_5",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_5,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_6] = {
-		.name = "drop_green_prio_6",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_6,
-	},
-	[OCELOT_STAT_DROP_GREEN_PRIO_7] = {
-		.name = "drop_green_prio_7",
-		.reg = SYS_COUNT_DROP_GREEN_PRIO_7,
-	},
+	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"),
+	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"),
+	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"),
+	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"),
+	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"),
+	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"),
+	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"),
+	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"),
+	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"),
+	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"),
+	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"),
+	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"),
+	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"),
+	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"),
+	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"),
+	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"),
+	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"),
+	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"),
+	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"),
+	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"),
+	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"),
+	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"),
+	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"),
+	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"),
+	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"),
+	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"),
+	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"),
+	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"),
+	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"),
+	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"),
+	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"),
+	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"),
+	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"),
+	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"),
+	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"),
+	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"),
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"),
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7"),
 };
 
 static void ocelot_pll5_init(struct ocelot *ocelot)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 860ec592c689..2fd8486bb7f0 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -698,6 +698,17 @@ struct ocelot_stat_layout {
 	char name[ETH_GSTRING_LEN];
 };
 
+/* 32-bit counter checked for wraparound by ocelot_port_update_stats()
+ * and copied to ocelot->stats.
+ */
+#define OCELOT_STAT(kind) \
+	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind }
+/* Same as above, except also exported to ethtool -S. Standard counters should
+ * only be exposed to more specific interfaces rather than by their string name.
+ */
+#define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
+	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind, .name = ethtool_name }
+
 struct ocelot_stats_region {
 	struct list_head node;
 	u32 base;
-- 
2.34.1

