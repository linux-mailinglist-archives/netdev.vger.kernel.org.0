Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2D345F30A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhKZRgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:36:00 -0500
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:5310
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232983AbhKZRd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:33:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BN4SXGiGR4YoH0URGsLn3lHggutmaL/onyBpFOXXjQ8uu/jCHSLuBzwywzg9XWWvKcKy7wksEXrIZjpah1RQlI+f2KcSpM03wpevt0p81uNRmF4LeaS0CAonLhzp5YjcEWnRuAiccsewU9exaaIv1fSE2SYgpJe6msKWyh05y/XFGsGYSEH9dn1PDvEFAM9JnHTnmedvLj1fjeVQYYvCPgSVurvX6Y1xEFCF2LwcY0Mhdc2LLhMM4FsAnXbQBKiWWCyo0+8UyeHQGIf5AnEAW8BmYckajpzmZbNHV7rTGxTgqqz6KCNurgWWMlvsTvSMHF9mYxy08l3U6LD+MwMgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQswjS3EbR8tXFPiKTNSGjUlLWyL0bvEvXVprHx7rRI=;
 b=nq5GwylgTtuCsIoaipZZKOUNdk3g86ZE624i2W1xnKCC7LrgkgCiS8VeEpAiCVh/889kSSW0t2zY8KzexEsgxxdkhOHHzwOj0L55ZQihe/KGinVmS+7r//CPmJdy6IV6Rlzx2m9Agce+XMsDlunfD9Iy3rOkBdJwBtEFCOX3Y4kxMdVG/3S9RAkHD3WRwKhLplNIpaNGQ7EQhpg3jmdqGGV4cY2uBXcIXapdwYWfM09fnSoJaP8Lh/+rvhARMUn7J4ZZUE6W+bAQd9BRBPeYrdeakQ4fL06yUIc0wMYbtZqD/RpRdEUP673dw+6jhQ2QloDi9GykxXXaxgV6+L3oCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQswjS3EbR8tXFPiKTNSGjUlLWyL0bvEvXVprHx7rRI=;
 b=gOg4W1RowHziNelBO6lGVTgVh98zckDHsdciBsoS1pVuMW6a5Vlxu9p3/1u3DqF/gobgmDlqW8ssRGaLajbbbQKkX2whI5/rHjhQjQKwKItSJz8L+sWO1+QKDDEfWGFTnZvzJM+2zBdJbDGcs9ww9W5IUpu04Z2BouXsqvXwGXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 26 Nov
 2021 17:29:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:29:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH v2 net 4/5] net: mscc: ocelot: set up traps for PTP packets
Date:   Fri, 26 Nov 2021 19:28:44 +0200
Message-Id: <20211126172845.3149260-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
References: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 17:29:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c0f3836-69cb-43b6-44d5-08d9b10240a3
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6639186157703BD12E970C42E0639@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3eb3STnN21tgB+ZRkgod5nBg+VKASH+7pww5OiJvM8108effEaPD3rG2dnF1U6etKQJb49WejME5NNjOgHljX93gVtGV7ot5Amg6DLGsIAWFZu/fJhSwz111dzKzrL9MxdK8WgNUY41fxg2wLb3Lcl/Vk8hhNHj437s3QZVXykYJqqG8U3i+mZEpuwBF41ljZkyErpd2XSbov4otOen11sjJuprWlUixgGi1L6HjvcTZGmsDjY7hdqWZ0efG8TN9GPs2hyTXyicT88e6kNfAHp4n1tiIv/x0NCz0fXSqClgXhZM4wsIRFdgjJj4IiXMu4OV0r9nAlEHXSSsETDwJp8Obh54d1krhhV2CuS73kAqwU5Ohzg8qZo+XI7hVavcm7UuUnyTOPAVb/yzMwToF7ZxfeAP4wPLqNQb1pjj4tncQrK+XLrIUG8AWCefh0GufABTOBo6MQM7dYzAiq3QKmUHOYwWolIIrcO4jOqC6zGdzVNaeehA27857Otm4ZYzQm+I9ZjDFzyXnHFWdxS4fHUyLmleK2k2/3NLoHhgtKBqGxw8wb34SR614rCd8kJMRUuHXP+3jaDaG1e2QcGdbRPpM+vGR9t2zisB2Ban1HJa4YxZgirkMQ7isVXeofeN8btL1RdywPgSwfB8brKH3UAqeak/mt++nPbwza84ifaMV57wD52IXA8mI12Or/QTQUY56LNKZ4y6r5sZMyPbAH+3bW4+UGN1irfqyWyk/K074IR3hZfsBx09NQVM+ka/Af8QiMufsptl884s4mpA9SFoAzrE/TC7Y8oss/vD4Prgdsdjwq5jN6aBWwqAZxxuF9EAZULdY9nS0OBH8O/fGLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6512007)(7416002)(86362001)(508600001)(956004)(26005)(8936002)(44832011)(6506007)(6486002)(8676002)(52116002)(66476007)(966005)(66556008)(83380400001)(2616005)(5660300002)(30864003)(54906003)(36756003)(38100700002)(37006003)(186003)(6862004)(38350700002)(6666004)(316002)(2906002)(4326008)(6636002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7fuH61jYaj7cEhx1ORCigXT0ZY7hx7oO1LK3M1Miosp5XtGN8LiCg5wPCUvx?=
 =?us-ascii?Q?WLbE9xu8DQjV2bwJudK7UWBiJiF7ypEc1ITxnIBXWVjYXQtYF26lH7Y3rv+W?=
 =?us-ascii?Q?KZtXD4Q7JijphcOvhOhS//15kRRnhmemm7D8SWLnlmSTE8xDlKw6zHAquVMC?=
 =?us-ascii?Q?ndtrAvFVoXtBD+Sr13SVREzkk0nCBQm7HnW1rYlpwGHBoZ91PkFBAuieIsbF?=
 =?us-ascii?Q?4r+lXK0ADbBycsv/omijcln26AmPl+ldE96bkesV52Zw6/9tYBAApgWbMun0?=
 =?us-ascii?Q?MsWJOT1oSsxKuNdflBUJvXBVLbHZjZZckigQ2g6wpb1tFbhtooHAuq66/q6w?=
 =?us-ascii?Q?LL8DJSJ12JkX/TIFC3oWBXNoGC1zmA4ETNOE2UdcgAtdcbHjMgkz5prr4VEj?=
 =?us-ascii?Q?030H2M7fUDqAyJG9QJp6yPXYUyk/ZVg0xKhI/x+5FlPy3A7sktaRddNY5hS6?=
 =?us-ascii?Q?P/M6oKGvWFpRMzHQTYEYcrTMXaw5Uc4VXhu5IgEUrvKbJWzLxiyRokZV5I9H?=
 =?us-ascii?Q?hwPM92Fk79kSzqOZqkYyq7/77wJedNjHxgBfyC/SF/aTX9KEptnhrRHusb/E?=
 =?us-ascii?Q?v9HO9Xf/W5ddvKtR3vgnFRZSKRHPpBO4xNpLk97BQe08I8QJx5q9KcoOjGp/?=
 =?us-ascii?Q?8MqYcxH08Yxv45lZphFXRTsfXYXeZYGrd52pBiL0+s7v6LIFUL3fpqfwKOA5?=
 =?us-ascii?Q?V5X6qxis5pw7CLZIjEeajseY8Mi3uVTzUECMDb3GJtlE4MUNjMQkqU51juc5?=
 =?us-ascii?Q?NMzxf414UrGE1PalmKZoJ2JRlBSvC8U/DncN6m8uVSN1aJgdiQPJRIOlbyyO?=
 =?us-ascii?Q?UQkSKnHXE/tvSdNNaIMtN+Z5KQWIA4uK/m2o7D+/Hbmx87803Kha8Kyj7G1B?=
 =?us-ascii?Q?SUHK4har0XG3F80nNZZXR8/0Uhi5d1XhIbnJp8ZI85vDYxOdtu6VSnRgm1Ac?=
 =?us-ascii?Q?xjl6gIOx6+vAp3OGg/GpSmyuHAUu69PWkaw5+L7cYWRp1pYwPz/G6elPYrRp?=
 =?us-ascii?Q?ex/SdfEle2nUnJuih5zYeCiNFKSjJcIR4rbwJUJpQfd25VQ/QZK4ZSJySFl8?=
 =?us-ascii?Q?E6/tNKYq6vi1o3bCUizskIWQ1UJJ5kwT6DyzaKBQOz5zbbZ3x7r+iDELuL/G?=
 =?us-ascii?Q?x/hVNPx0DEGYnTHzFWm7TapSVaGUPpNkB1f9xK5xWDpC+Zou1swxLEZ/kzd1?=
 =?us-ascii?Q?7QVXuKMEy2itVLrAncYlwE2borySwQ25nO5a5BZKxnKJ3vFZoLgooJBgE9bt?=
 =?us-ascii?Q?3RgkyBfENX7wnaRnIDp2T5S51VWwidmE14O9iPGYkzhY/2HicotvmKR3tFg3?=
 =?us-ascii?Q?VySicE3jUhei7YjSeztj1xtyCrMN3TJ5/vUllLNAO0YgzB2CxPuEANpnhJbj?=
 =?us-ascii?Q?PHubZPHfr/J4ikHTiFrVpJX8lRhfViTM335j4z9LUlhMXFev7IPUa/J8I1/y?=
 =?us-ascii?Q?XXqq+TMYYkP3GZ6Jp7HJYDg6EVpQQE6otHfLpBdZm1ai7s0NaH8wI11TwY1H?=
 =?us-ascii?Q?p3iDMgBPuCJ7v6wPEFzG04fB3Za3cLv6xBx4h6cntBFKhEDeXhV4opEcuETF?=
 =?us-ascii?Q?1AXNqLch5Pm/2KAUZ9v1gJOQdbKRy+lNMYed9G1VHlWDsk8lViOtM5d85vwQ?=
 =?us-ascii?Q?OdAKNEnjqLCa6gC7Sv7bzE4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0f3836-69cb-43b6-44d5-08d9b10240a3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:29:08.5896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bm3AM86aXrmOCGs19qlqT3XHmRX9yOMiUyQ/024AR5ccLIckjZqdx7uA4/AiNjw1QUqQhh6Hflk6CjkKVslPfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 1588 support was declared too soon for the Ocelot switch. Out of
reset, this switch does not apply any special treatment for PTP packets,
i.e. when an event message is received, the natural tendency is to
forward it by MAC DA/VLAN ID. This poses a problem when the ingress port
is under a bridge, since user space application stacks (written
primarily for endpoint ports, not switches) like ptp4l expect that PTP
messages are always received on AF_PACKET / AF_INET sockets (depending
on the PTP transport being used), and never being autonomously
forwarded. Any forwarding, if necessary (for example in Transparent
Clock mode) is handled in software by ptp4l. Having the hardware forward
these packets too will cause duplicates which will confuse endpoints
connected to these switches.

So PTP over L2 barely works, in the sense that PTP packets reach the CPU
port, but they reach it via flooding, and therefore reach lots of other
unwanted destinations too. But PTP over IPv4/IPv6 does not work at all.
This is because the Ocelot switch have a separate destination port mask
for unknown IP multicast (which PTP over IP is) flooding compared to
unknown non-IP multicast (which PTP over L2 is) flooding. Specifically,
the driver allows the CPU port to be in the PGID_MC port group, but not
in PGID_MCIPV4 and PGID_MCIPV6. There are several presentations from
Allan Nielsen which explain that the embedded MIPS CPU on Ocelot
switches is not very powerful at all, so every penny they could save by
not allowing flooding to the CPU port module matters. Unknown IP
multicast did not make it.

The de facto consensus is that when a switch is PTP-aware and an
application stack for PTP is running, switches should have some sort of
trapping mechanism for PTP packets, to extract them from the hardware
data path. This avoids both problems:
(a) PTP packets are no longer flooded to unwanted destinations
(b) PTP over IP packets are no longer denied from reaching the CPU since
    they arrive there via a trap and not via flooding

It is not the first time when this change is attempted. Last time, the
feedback from Allan Nielsen and Andrew Lunn was that the traps should
not be installed by default, and that PTP-unaware switching may be
desired for some use cases:
https://patchwork.ozlabs.org/project/netdev/patch/20190813025214.18601-5-yangbo.lu@nxp.com/

To address that feedback, the present patch adds the necessary packet
traps according to the RX filter configuration transmitted by user space
through the SIOCSHWTSTAMP ioctl. Trapping is done via VCAP IS2, where we
keep 5 filters, which are amended each time RX timestamping is enabled
or disabled on a port:
- 1 for PTP over L2
- 2 for PTP over IPv4 (UDP ports 319 and 320)
- 2 for PTP over IPv6 (UDP ports 319 and 320)

The cookie by which these filters (invisible to tc) are identified is
strategically chosen such that it does not collide with the filters used
for the ocelot-8021q tagging protocol by the Felix driver, or with the
MRP traps set up by the Ocelot library.

Other alternatives were considered, like patching user space to do
something, but there are so many ways in which PTP packets could be made
to reach the CPU, generically speaking, that "do what?" is a very valid
question. The ptp4l program from the linuxptp stack already attempts to
do something: it calls setsockopt(IP_ADD_MEMBERSHIP) (and
PACKET_ADD_MEMBERSHIP, respectively) which translates in both cases into
a dev_mc_add() on the interface, in the kernel:
https://github.com/richardcochran/linuxptp/blob/v3.1.1/udp.c#L73
https://github.com/richardcochran/linuxptp/blob/v3.1.1/raw.c

Reality shows that this is not sufficient in case the interface belongs
to a switchdev driver, as dev_mc_add() does not show the intention to
trap a packet to the CPU, but rather the intention to not drop it (it is
strictly for RX filtering, same as promiscuous does not mean to send all
traffic to the CPU, but to not drop traffic with unknown MAC DA). This
topic is a can of worms in itself, and it would be great if user space
could just stay out of it.

On the other hand, setting up PTP traps privately within the driver is
not new by any stretch of the imagination:
https://elixir.bootlin.com/linux/v5.16-rc2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c#L833
https://elixir.bootlin.com/linux/v5.16-rc2/source/drivers/net/dsa/hirschmann/hellcreek.c#L1050
https://elixir.bootlin.com/linux/v5.16-rc2/source/include/linux/dsa/sja1105.h#L21

So this is the approach taken here as well. The difference here being
that we prepare and destroy the traps per port, dynamically at runtime,
as opposed to driver init time, because apparently, PTP-unaware
forwarding is a use case.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Reported-by: Po Liu <po.liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 241 ++++++++++++++++++++++++++++-
 1 file changed, 240 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index bcc4f2f74ccc..9b7be93cbb0d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1278,6 +1278,225 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_fdb_dump);
 
+static void ocelot_populate_l2_ptp_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_ETYPE;
+	*(__be16 *)trap->key.etype.etype.value = htons(ETH_P_1588);
+	*(__be16 *)trap->key.etype.etype.mask = htons(0xffff);
+}
+
+static void
+ocelot_populate_ipv4_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.dport.value = PTP_EV_PORT;
+	trap->key.ipv4.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv6.dport.value = PTP_EV_PORT;
+	trap->key.ipv6.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv4_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.dport.value = PTP_GEN_PORT;
+	trap->key.ipv4.dport.mask = 0xffff;
+}
+
+static void
+ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
+{
+	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv6.dport.value = PTP_GEN_PORT;
+	trap->key.ipv6.dport.mask = 0xffff;
+}
+
+static int ocelot_trap_add(struct ocelot *ocelot, int port,
+			   unsigned long cookie,
+			   void (*populate)(struct ocelot_vcap_filter *f))
+{
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot_vcap_filter *trap;
+	bool new = false;
+	int err;
+
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	trap = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, cookie,
+						   false);
+	if (!trap) {
+		trap = kzalloc(sizeof(*trap), GFP_KERNEL);
+		if (!trap)
+			return -ENOMEM;
+
+		populate(trap);
+		trap->prio = 1;
+		trap->id.cookie = cookie;
+		trap->id.tc_offload = false;
+		trap->block_id = VCAP_IS2;
+		trap->type = OCELOT_VCAP_FILTER_OFFLOAD;
+		trap->lookup = 0;
+		trap->action.cpu_copy_ena = true;
+		trap->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
+		trap->action.port_mask = 0;
+		new = true;
+	}
+
+	trap->ingress_port_mask |= BIT(port);
+
+	if (new)
+		err = ocelot_vcap_filter_add(ocelot, trap, NULL);
+	else
+		err = ocelot_vcap_filter_replace(ocelot, trap);
+	if (err) {
+		trap->ingress_port_mask &= ~BIT(port);
+		if (!trap->ingress_port_mask)
+			kfree(trap);
+		return err;
+	}
+
+	return 0;
+}
+
+static int ocelot_trap_del(struct ocelot *ocelot, int port,
+			   unsigned long cookie)
+{
+	struct ocelot_vcap_block *block_vcap_is2;
+	struct ocelot_vcap_filter *trap;
+
+	block_vcap_is2 = &ocelot->block[VCAP_IS2];
+
+	trap = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, cookie,
+						   false);
+	if (!trap)
+		return 0;
+
+	trap->ingress_port_mask &= ~BIT(port);
+	if (!trap->ingress_port_mask)
+		return ocelot_vcap_filter_del(ocelot, trap);
+
+	return ocelot_vcap_filter_replace(ocelot, trap);
+}
+
+static int ocelot_l2_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long l2_cookie = ocelot->num_phys_ports + 1;
+
+	return ocelot_trap_add(ocelot, port, l2_cookie,
+			       ocelot_populate_l2_ptp_trap_key);
+}
+
+static int ocelot_l2_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long l2_cookie = ocelot->num_phys_ports + 1;
+
+	return ocelot_trap_del(ocelot, port, l2_cookie);
+}
+
+static int ocelot_ipv4_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv4_gen_cookie = ocelot->num_phys_ports + 2;
+	unsigned long ipv4_ev_cookie = ocelot->num_phys_ports + 3;
+	int err;
+
+	err = ocelot_trap_add(ocelot, port, ipv4_ev_cookie,
+			      ocelot_populate_ipv4_ptp_event_trap_key);
+	if (err)
+		return err;
+
+	err = ocelot_trap_add(ocelot, port, ipv4_gen_cookie,
+			      ocelot_populate_ipv4_ptp_general_trap_key);
+	if (err)
+		ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
+
+	return err;
+}
+
+static int ocelot_ipv4_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv4_gen_cookie = ocelot->num_phys_ports + 2;
+	unsigned long ipv4_ev_cookie = ocelot->num_phys_ports + 3;
+	int err;
+
+	err = ocelot_trap_del(ocelot, port, ipv4_ev_cookie);
+	err |= ocelot_trap_del(ocelot, port, ipv4_gen_cookie);
+	return err;
+}
+
+static int ocelot_ipv6_ptp_trap_add(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv6_gen_cookie = ocelot->num_phys_ports + 4;
+	unsigned long ipv6_ev_cookie = ocelot->num_phys_ports + 5;
+	int err;
+
+	err = ocelot_trap_add(ocelot, port, ipv6_ev_cookie,
+			      ocelot_populate_ipv6_ptp_event_trap_key);
+	if (err)
+		return err;
+
+	err = ocelot_trap_add(ocelot, port, ipv6_gen_cookie,
+			      ocelot_populate_ipv6_ptp_general_trap_key);
+	if (err)
+		ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
+
+	return err;
+}
+
+static int ocelot_ipv6_ptp_trap_del(struct ocelot *ocelot, int port)
+{
+	unsigned long ipv6_gen_cookie = ocelot->num_phys_ports + 4;
+	unsigned long ipv6_ev_cookie = ocelot->num_phys_ports + 5;
+	int err;
+
+	err = ocelot_trap_del(ocelot, port, ipv6_ev_cookie);
+	err |= ocelot_trap_del(ocelot, port, ipv6_gen_cookie);
+	return err;
+}
+
+static int ocelot_setup_ptp_traps(struct ocelot *ocelot, int port,
+				  bool l2, bool l4)
+{
+	int err;
+
+	if (l2)
+		err = ocelot_l2_ptp_trap_add(ocelot, port);
+	else
+		err = ocelot_l2_ptp_trap_del(ocelot, port);
+	if (err)
+		return err;
+
+	if (l4) {
+		err = ocelot_ipv4_ptp_trap_add(ocelot, port);
+		if (err)
+			goto err_ipv4;
+
+		err = ocelot_ipv6_ptp_trap_add(ocelot, port);
+		if (err)
+			goto err_ipv6;
+	} else {
+		err = ocelot_ipv4_ptp_trap_del(ocelot, port);
+
+		err |= ocelot_ipv6_ptp_trap_del(ocelot, port);
+	}
+	if (err)
+		return err;
+
+	return 0;
+
+err_ipv6:
+	ocelot_ipv4_ptp_trap_del(ocelot, port);
+err_ipv4:
+	if (l2)
+		ocelot_l2_ptp_trap_del(ocelot, port);
+	return err;
+}
+
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
@@ -1288,7 +1507,9 @@ EXPORT_SYMBOL(ocelot_hwstamp_get);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	bool l2 = false, l4 = false;
 	struct hwtstamp_config cfg;
+	int err;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
@@ -1323,19 +1544,37 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		l4 = true;
+		break;
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		l2 = true;
+		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		l2 = true;
+		l4 = true;
 		break;
 	default:
 		mutex_unlock(&ocelot->ptp_lock);
 		return -ERANGE;
 	}
 
+	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
+	if (err)
+		return err;
+
+	if (l2 && l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+	else if (l2)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else if (l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+	else
+		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+
 	/* Commit back the result & save it */
 	memcpy(&ocelot->hwtstamp_config, &cfg, sizeof(cfg));
 	mutex_unlock(&ocelot->ptp_lock);
-- 
2.25.1

