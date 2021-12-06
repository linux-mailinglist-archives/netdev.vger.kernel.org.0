Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC09646A203
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhLFRID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:03 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348561AbhLFRBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPeCIA3JEXH5JmRsB6+Yogoq3lykQEJyXZ3Rc4gnIrhnSspVoTHRvZ9WQAWaxc19952YXV6ERrAL/vghbGQgqyZLVDzv2bAqfz5hwOzrgUjWfZBN7UZ1gPmcDEbu8ZdE8/zCB74ka8PPZLTkzWOUU4KY48GJ7hbhuNmWbOnHGdhv9FJvVJPpYLLYg+3GbaS5ETY8PZ9yl80DgiWTjP2/fm1Rs/y86orWgtkq8+4sbSQNM9a792voEav0IYze+sryHqhB/2m7zbrkeg5M6vusRpo3hVFpMRYwVciL538p9oRG6CoQ2Maag8JS4rul9WsHGyVOFHeiorEQhrOXevj8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sGI0yLCbLNJevKMKKl5cQ9S812mXZ2uDg9XUALP6wI=;
 b=Lqzt5qDMXNGXYFZtxYqucT0gtvRlrPJoUhggikJyz8iF+XYtk/BcpxXmEgjk8fSkrM2PdWxBAybkGJajVnJReOdo1E+0QfVoICw84hpGuf9rXdUoZGvEOToGyUTpHok3SjjECgy9kujSZ9VEFcVYwsWqnjYVgzbGTuT3IT+F1IEl/4D8CsP0G+0WNtnaGuo2erih4mzjEamg65deTT6tEjDyKaK0nFbGt0ew9BPzFfY6Ihx6o77QMBU6GhYqxuN7TfwlxW87bxQf+EjPvt0Ker99VpK03T8hyVD7OdTftIegs8U/DjAs9Z5GfbMPCjQxdtRkK77COiPzV11t7ZwY7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sGI0yLCbLNJevKMKKl5cQ9S812mXZ2uDg9XUALP6wI=;
 b=Cc4FSLapV/5wrl1iOpApO6j56hczMrMiNa6N78I8aS4jH82BEeEXhxCDIg+Fc/EX8QaeLrbFCBaLxCCXy16WHwhcFTfp2xy0Y4IwQ5zO2pcupxVjS+zWIl+RBlhtssjD8DIbEE7V089iBq9t+zY3PD0q4K/MHvx1LfgXPn/xDlk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 04/12] net: dsa: mv88e6xxx: iterate using dsa_switch_for_each_user_port in mv88e6xxx_port_check_hw_vlan
Date:   Mon,  6 Dec 2021 18:57:50 +0200
Message-Id: <20211206165758.1553882-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6391ab2a-f01b-46bd-867e-08d9b8d99c5f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB49122B4E5BA7C6A86FC4C95EE06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4uw1mhIC/o1TCB0x5RKaIb17lorc8D8ltHScC+jh2eGxr1oBl7NVcvdmBxo/RTH5qddoEfHDZWhMEldhvjfv7BIiYagZPfmzTzmDgwmI+0w+T2UeNQN0daRKPv6DgTqKVQUEaIHmSQUo0oU60EmZJ0i5gGFNiTvijCNf7KSR/K8laf8bhcUDCD6uHPepumFz++fzL26ocShBQFWbxQZ92kSVum/JTZILpTp7EyxClrT9vlIz8ND0IvWEqDlkLt/Z0RqTkFgDNVtEIbS+KEmJt3yGh79Vkw2T5Isj5RfkmM6eoyB+K02C7UR11QcAJot+3MRrkD5AzFU16XEqV1s8pefz6Lly81O28CcHpuopqfTlJ9bJuSKGhod0bj/QBZ0kGTFV0O7N184qFeHOU7uY/z81/hTO5WIlhb7q8v59/0CbXOZaFqV6dh8wHY/BLeOcd08DtTCpK3Kg0nFRBwrjHerR9EW/qSi0nezFdOORnWHEtYMILil70HLl95av96CLVBwOVpqhVlMwofntNJRFj3faGlqg+SbgSbbxxtDzu1qwFikkrYYJwbumZyr6ajIk8U6X03Q3JRHVhJcO9dDdcyW/5257AZQ3bCSW4ZKHDPpgHXZv2WAK8lGvvcoJ7iZMMI/eLUsxBkb7iMd66BR/q0uGmbWv9Dzr25NFLBSLTFHxHPTDDyctPdsm/yyMyJAl48d64evAJtuPeqSLtsvzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GlPV5tsMXbuSiHi9J+Sa2cnwvRUxjZ1Si5yJmk9VOVLR/J0RtuMfXK8Y6aeW?=
 =?us-ascii?Q?HzUfzga6B1BfhZFYMehpQIJ8exSvqTNHHkePxbyNqNTaqHrVr2aQZW0w16eE?=
 =?us-ascii?Q?JDvnqRpVqzrDAXEoRIRseiAWCgVJmbHr7weuIJppeJeLlTFpYjzuDJrgoYvA?=
 =?us-ascii?Q?D7De0EVHl25Q6Qf/NhyUSM1U0Dm9E4NzNWpvyDsJZRnm0aO0464pUJ1wHjRs?=
 =?us-ascii?Q?oqRgLIT6NCVVV+2YQ6ol68k/UyEaWV+IjblWtiXH6GKgGaT70rDst1Bx0uxb?=
 =?us-ascii?Q?U0ieKcgAvbX/2vqNsQ1srU6E6bxp5BJ/50htEuJWDOxSipg4Bj8sTvSwsWsA?=
 =?us-ascii?Q?jUzG8fc5kwY+6zimdN3B7HvM/V+JmFp0iSuZrMXGJkhl01FwytSYngU2wFMY?=
 =?us-ascii?Q?WcDBK1zidGh+D70ggHk60x2p1dFpHa5KE0W7FhOP5XCN917gU/XSJ6fDIOQd?=
 =?us-ascii?Q?aOtQPOqTMBzPC///tCrjf8zBIAFXu/lHkt53oJWQ4a00K5u9wHBgZfOzThcI?=
 =?us-ascii?Q?h08GiyeEV4N7CgBWCQ5lj1F5yIIG7q9t7NlO/3C1zOdcTgrF9BwuiT2cvC0F?=
 =?us-ascii?Q?2N5f5ya84LnyQxIfHnDmfHjUtoqYPw51PkMpM2VEyfMAazYc8H6Vjlcgbl32?=
 =?us-ascii?Q?06ovTh+vKcX8FdDmTmu+KDYJqLBFcg2ELGV3I9xtybaovHA9SZZfJA9c1gbw?=
 =?us-ascii?Q?0mCoJkjjGsfXFZe+L7jzKUlduVFOwb/5/KQoXawmP0WkRTWoJsvBz9Pi1pua?=
 =?us-ascii?Q?/ESsHMIVxntv5/+0VS8eoDTWER301y3sO1ceJypofRnKO6OlyRGPKG61VX6b?=
 =?us-ascii?Q?ALuSEFvMfXAiIkF36S2nr05u9c7KvSTMtQsgmwBXOBkMY8VWBs5wNNoRKzwc?=
 =?us-ascii?Q?VSOTSeZO9l4l33BvKyRASkG42L1XqVOAbK1rYGdpNKPcbmqdAaunbZQwc2ec?=
 =?us-ascii?Q?ZpUpYYGMwsXwv6dMq4Ec+LAvdZ0OSQa+C7109mZ5vV+yOEQ5iAtZogo0T1nx?=
 =?us-ascii?Q?IAldQrFiXlpYHSmqkRu4P7luAvnzOv+ZxbU2JaiLOu4o3ufKRFsrII7xg0nU?=
 =?us-ascii?Q?bxG5viC8EBN6X5NGpri8Yb7UCFYFZLkUzwRzZAYAzYOddTLyu71IShnq+DSI?=
 =?us-ascii?Q?o7/ksP4A3Nu3LDUGLHhrybzP+1mdMJUMmwJp3azf4swqf5zFpmyTR/VqdD8M?=
 =?us-ascii?Q?TNx+jH07WtraID4Ot2PlDZwENRdll4zFhPuDiGquDsPij7z4EO7Ib6x7dbHH?=
 =?us-ascii?Q?+6FOcirMV1RM3O2xQIV5m6T34k1rlNJIIy/kQ84oM/ZdS3eDjgYDIXulD0UC?=
 =?us-ascii?Q?5jykd/IEZf4A/H4f7lAHlKezbua0gRtT1lDIXgNfIUZyuGc7PFGOn8tQu5QU?=
 =?us-ascii?Q?f5rFxsDjVxdNRSDdzrDB2tiLSsAyzaLLB0S1PL0RG/x80PscWFOBVN2hpUnw?=
 =?us-ascii?Q?SzV0hcp6t1L5z1kZTQZFoa9Y92IHA77I7hAC040qhB1SYsGehoYsBpiK/MAx?=
 =?us-ascii?Q?gG6ExB+DhJyZ4Deew2udRig0SSrp4sG5+1ZHSC8tftE9AU05VyheOL6if3Xa?=
 =?us-ascii?Q?KPTtx3s0fuNyFctbmzHrTdkO0JpNkdm7NF0K3BmZPuOJWirvkakulWnmGMEY?=
 =?us-ascii?Q?ZPCwBahjj18nmPRBpb30nvM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6391ab2a-f01b-46bd-867e-08d9b8d99c5f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:22.1962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6cnd+WUCMrAu+sx2GpH4PbEiQbYxFVJoe1GHjeKwHGp8oaZLq/ivXJK9V3S2rXmUkRaEyaTc9vdU/dXhDeS5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a plethora of dsa_to_port() calls (some hidden behind
dsa_is_*_port and some in plain sight) by keeping two struct dsa_port
references: one to the port passed as argument, and another to the other
ports of the switch that we're iterating over.

This isn't called from the DSA initialization path, so there is no risk
that we have user ports without a dp->slave populated. So the combined
checks that a port isn't a DSA port, a CPU port, or doesn't have a slave
net device (therefore is unused), are strictly equivalent to the simple
check that the port is a user port. This is already handled by the DSA
iterator.

i gets replaced by other_dp->index, dsa_is_*_port calls get replaced by
dsa_port_is_*, and dsa_to_port gets replaced by the respective pointer
directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is split out of "net: dsa: hide dp->bridge_dev and
        dp->bridge_num behind helpers"

 drivers/net/dsa/mv88e6xxx/chip.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a818df35b239..2c9569e88fac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1647,12 +1647,13 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_vtu_entry vlan;
-	int i, err;
+	int err;
 
 	/* DSA and CPU ports have to be members of multiple vlans */
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
 		return 0;
 
 	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
@@ -1662,27 +1663,20 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (!vlan.valid)
 		return 0;
 
-	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
-		if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
-			continue;
-
-		if (!dsa_to_port(ds, i)->slave)
-			continue;
-
-		if (vlan.member[i] ==
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		if (vlan.member[other_dp->index] ==
 		    MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 			continue;
 
-		if (dsa_to_port(ds, i)->bridge_dev ==
-		    dsa_to_port(ds, port)->bridge_dev)
+		if (dp->bridge_dev == other_dp->bridge_dev)
 			break; /* same bridge, check next VLAN */
 
-		if (!dsa_to_port(ds, i)->bridge_dev)
+		if (!other_dp->bridge_dev)
 			continue;
 
 		dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
-			port, vlan.vid, i,
-			netdev_name(dsa_to_port(ds, i)->bridge_dev));
+			port, vlan.vid, other_dp->index,
+			netdev_name(other_dp->bridge_dev));
 		return -EOPNOTSUPP;
 	}
 
-- 
2.25.1

