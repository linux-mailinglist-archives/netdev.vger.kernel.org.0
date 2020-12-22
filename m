Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5A22E0B11
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgLVNqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:12 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:47547
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727270AbgLVNqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDXkpIMZvr7AEgykRZaYruhFLQYXUmyWXUZt7KhxdkKcvAhtmqMlNKzqpbmfpuUBKPYzYRUFTnzYQGE0mclOHXcajDL09OSjT+k/Gtx6KqCokCrHrx6aHYAlnszkX1PIloVP8pfPXJsgq89Lhntiiz3MSOZlcmlBQOzBJiw75IbvgXSZxYctZwlb3hanLf8AcYHj6D3ZUhEhuo+e1oDUtDWhnsGqeHdT3hAG2Sp1Tc+IXmweFBJG6Yznvfxf3xSyNP8HvdkW7Stc1NSznoUos+iTAYV5o2hFf50+ze3xxotz5OcMH+F30WZGkBSkl7AGPB1eLppW+vw+/oIqj5JBRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0po+oS1iBy7nMuAp63VhLZaTEaQ+8HjK9BjtIbsGP+w=;
 b=dJl94hOfQ3MNeQpQQx/bEvn1/onSe3bHttYZ+LwFCcrbYRoDIJe/6990ANYZjMx/FxFkDZAkoYJkPBQbiVMGawrWm6lYSCQgvBju02oJY28dELgSjIhnO7wmfyIyVgzKCCr6FCkU3vwstLrPe8R/V8/o6ZQNge85hYJxiSZxOcyLz/fkEfZqpK++YbYWoQQ1vl5rLkBzrqvvRSfu+hDFKGdmqfnmsxUoIoVMIB8C6r+NKbnSB9TyuknsPxLYNqV35KWGFU10pCpECpk2dK66V7TpUtAws2V3C/JgCZcp4kz93cxuCBqDbe0Kz4tOhBG+O7je3YXlzjjkmzx92BZI7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0po+oS1iBy7nMuAp63VhLZaTEaQ+8HjK9BjtIbsGP+w=;
 b=hVeDME2W8nRW8qm+eI64fvmiyDRQpmCT2ot+H9Q7fXC4NuZojUzPlYbC/1p7BQj0ohSwL/RO6cqZn4m0Zd0UKSd7+dApIBi/a/miSQkGb4qZxSw+F0R1ziFVb8zeLwIJthxxQ0noU+wEnBaatBrnclk3ZS9TTsEk0zf88FtIk48=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:57 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 04/15] net: dsa: felix: add new VLAN-based tagger
Date:   Tue, 22 Dec 2020 15:44:28 +0200
Message-Id: <20201222134439.2478449-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6c259ee3-a18f-4ac5-1005-08d8a67fc552
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7408F07E3AB2236047B06BD2E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQSRcqHnpCC551PwGq4qkyawhzB4OizsW8bHXy920bUuUBqkO+nRoWLHJhPHFvZzdm/v3dCxfdJDJIQa+cJF/tVjY8GQgPGSMeO209qzgi41vhX5JejwsbDgDQOW73tIorCkmeeJ+C0Bg+AQlYMyoMn4CRoaEzaKKGzJPNlPpEFBy/6RGVwPTF/b3u/U2ET/TAoLbsX79AOVqQlyRy8TS7xM7+m7qmA6N+S/izGEibRYwaMHUML+4WjQVkcV5BMDbcbOY0EpU0DXPXuwPjm9Whvp3EqSm3lUZGXpJxyUShrsqyuhAs8naJZMzlHvHBD75f4XubgE8XOhViQD6huoCbTg5+o2XueXXYpNVHshrzc/KrgHSIbHuv+R9YuB8Hlw8Y72SX8fOb/koiL399ab6MtelG5GXxiw/jCDb4VrPFIINZ6059iGpvaxBbe4COCYnxWIjoc6ds7/xGOJQiERfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(30864003)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7EMId5EyO/m5/aIw/fyP4tWqi0xK0R/b+6Jc+VXCq14It6rH8nz75jd3W46T?=
 =?us-ascii?Q?5eGA1foxJodByBghR66jDP28JXNVnZv4sDiCcP1qgOgMp/G6gkgKFtoKQ/uk?=
 =?us-ascii?Q?XT/JOZbJC6R824VfF8x1SasFdPN3isUF4XtCEiUFQsjZbgbO8ejVxfoZr5J3?=
 =?us-ascii?Q?GkTtffg1d4S8UP2mxxNrVS67Yww0E6K9ti22syNd3LQMAA/BM9/ZepXiN5TB?=
 =?us-ascii?Q?3IhCCiH+snw0zxVJiIHdjrBekU0Is6Af5s8Licl/IMs8kxXl+ETpQbTQoEod?=
 =?us-ascii?Q?6wym1WxjySVuD3mJxLVQ89pvk0iJud3X+q0Z/HiNtfqGyxMljzOgl8lyBbwt?=
 =?us-ascii?Q?SahTEqyQFHQEZ8zlND3rpj1JK3lxG9gaFOQyj8/+01uZWgBVwkkjkoHcE/FN?=
 =?us-ascii?Q?Gb7zt+iK6f5u/KG9I1xExyGTu/KfF0EXmiAwh9QAH76WM+FP3Jis6Cc758Kh?=
 =?us-ascii?Q?ZhnMKWh0QT4+OzE2NlPJVLAKeKZ21qKIAg4S4AK4M+/oJwAvqeDTEMKzp98D?=
 =?us-ascii?Q?RZ6Ld4Gl3Ilm2Y83nzNI5MQtsOikSEQlOPsDqsvc9yKeGHWRE16NxdYq6FJu?=
 =?us-ascii?Q?8Yaz9FLyNrDRrT0GA5PRZlbzTuXJ06MOZnEGjI8djVa5Fyj3aALvsQ9dCS5Y?=
 =?us-ascii?Q?sVCrC8hLA0yCBjekagUQe51/hQXlAscXIGGLc3jLBgrqmBasSN4uBt2rI5Ut?=
 =?us-ascii?Q?JYh/8XIgQ/59t9j7ptP2gGNh2g2PXRsH0DHzJsBm5BHznfJ8DcWFOEywFWUA?=
 =?us-ascii?Q?jzixHgS4ZHVFHKX3Q+Tv2TMl12zqc312LRENV9yHQL5LmBtH3KttMuv44nTn?=
 =?us-ascii?Q?8KqMxehcPZPw8bsVTwObDzI/6ciIe6WVKfTz6xRlpz7awfsgeuJy3+eh5/jd?=
 =?us-ascii?Q?lg/6853w8m2Y2EulTj24c/7bzOU8wMDzqYRMF6AFiGxjJ8TQ1ZFcHB7nKRjK?=
 =?us-ascii?Q?ywj82v/UkFbnf8TWFsvF3capfjG3vpkGQ9fsqKzEDycOfRXc9AJovrlWktX3?=
 =?us-ascii?Q?J+f8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:57.2993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c259ee3-a18f-4ac5-1005-08d8a67fc552
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzD2tkTooV6D1FIGm12KixRxZugcBV+L2ZtM/U24Vrk8+kyalWbjV7FNvjd24P2GdppUDuBa+oL22izLy1cF/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are use cases for which the existing tagger, based on the NPI
(Node Processor Interface) functionality, is insufficient.

Namely:
- Frames injected through the NPI port bypass the frame analyzer, so no
  source address learning is performed, no TSN stream classification,
  etc.
- Flow control is not functional over an NPI port (PAUSE frames are
  encapsulated in the same Extraction Frame Header as all other frames)
- There can be at most one NPI port configured for an Ocelot switch. But
  in NXP LS1028A and T1040 there are two Ethernet CPU ports. The non-NPI
  port is currently either disabled, or operated as a plain user port
  (albeit an internally-facing one). Having the ability to configure the
  two CPU ports symmetrically could pave the way for e.g. creating a LAG
  between them, to increase bandwidth seamlessly for the system.

So, there is a desire to have an alternative to the NPI mode.

This patch brings an implementation of the software-defined tag_8021q.c
tagger format, which also preserves full functionality under a
vlan_filtering bridge (unlike sja1105, the only other user of
tag_8021q).

It does this by using the TCAM engines for:
- pushing the RX VLAN as a second, outer tag, on egress towards the CPU
  port
- redirecting towards the correct front port based on TX VLAN and
  popping that on egress

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Clean up the hardcoding of random VCAP filter IDs and the inclusion of a
private ocelot header.

 MAINTAINERS                              |   1 +
 drivers/net/dsa/ocelot/Kconfig           |   4 +-
 drivers/net/dsa/ocelot/Makefile          |   5 +
 drivers/net/dsa/ocelot/felix.c           | 108 +++++++++++++--
 drivers/net/dsa/ocelot/felix.h           |   1 +
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 166 +++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_tag_8021q.h |  20 +++
 drivers/net/ethernet/mscc/ocelot.c       |  18 ++-
 include/soc/mscc/ocelot.h                |   1 +
 net/dsa/Kconfig                          |  34 +++++
 net/dsa/Makefile                         |   3 +-
 net/dsa/tag_ocelot_8021q.c               |  61 +++++++++
 12 files changed, 399 insertions(+), 23 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.c
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.h
 create mode 100644 net/dsa/tag_ocelot_8021q.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a355db292486..a9cb0b659c00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12736,6 +12736,7 @@ F:	drivers/net/dsa/ocelot/*
 F:	drivers/net/ethernet/mscc/
 F:	include/soc/mscc/ocelot*
 F:	net/dsa/tag_ocelot.c
+F:	net/dsa/tag_ocelot_8021q.c
 F:	tools/testing/selftests/drivers/net/ocelot/*
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index c110e82a7973..ab8de14c4dae 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -2,11 +2,11 @@
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
+	depends on NET_DSA_TAG_OCELOT_NPI || NET_DSA_TAG_OCELOT_8021Q
 	depends on NET_VENDOR_MICROSEMI
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
-	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	select PCS_LYNX
 	help
@@ -16,10 +16,10 @@ config NET_DSA_MSCC_FELIX
 config NET_DSA_MSCC_SEVILLE
 	tristate "Ocelot / Seville Ethernet switch support"
 	depends on NET_DSA
+	depends on NET_DSA_TAG_OCELOT_NPI || NET_DSA_TAG_OCELOT_8021Q
 	depends on NET_VENDOR_MICROSEMI
 	depends on HAS_IOMEM
 	select MSCC_OCELOT_SWITCH_LIB
-	select NET_DSA_TAG_OCELOT
 	select PCS_LYNX
 	help
 	  This driver supports the VSC9953 (Seville) switch, which is embedded
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..e9ea8c0331d8 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -9,3 +9,8 @@ mscc_felix-objs := \
 mscc_seville-objs := \
 	felix.o \
 	seville_vsc9953.o
+
+ifdef CONFIG_NET_DSA_TAG_OCELOT_8021Q
+mscc_felix-objs += felix_tag_8021q.o
+mscc_seville-objs += felix_tag_8021q.o
+endif
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7dc230677b78..77f73c6bad0b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -23,6 +23,7 @@
 #include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
+#include "felix_tag_8021q.h"
 
 static enum dsa_tag_protocol felix_get_tag_protocol(struct dsa_switch *ds,
 						    int port,
@@ -439,6 +440,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
+	enum ocelot_tag_prefix prefix;
 	struct resource res;
 	int port, i, err;
 
@@ -448,6 +450,11 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	if (!ocelot->ports)
 		return -ENOMEM;
 
+	if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_NPI))
+		prefix = OCELOT_TAG_PREFIX_SHORT;
+	else if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q))
+		prefix = OCELOT_TAG_PREFIX_NONE;
+
 	ocelot->map		= felix->info->map;
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
@@ -455,8 +462,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
-	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
-	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->inj_prefix	= prefix;
+	ocelot->xtr_prefix	= prefix;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
 				 GFP_KERNEL);
@@ -578,6 +585,15 @@ static void felix_npi_port_init(struct ocelot *ocelot, int port)
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
 }
 
+static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->dsa_8021q_cpu = port;
+
+	/* Overwrite PGID_CPU with the non-tagging port */
+	ocelot_write_rix(ocelot, BIT(ocelot->dsa_8021q_cpu),
+			 ANA_PGID_PGID, PGID_CPU);
+}
+
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -587,7 +603,7 @@ static int felix_setup(struct dsa_switch *ds)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
-	int port, err;
+	int port, cpu = -1, err;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -607,10 +623,20 @@ static int felix_setup(struct dsa_switch *ds)
 	}
 
 	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
 		ocelot_init_port(ocelot, port);
 
-		if (dsa_is_cpu_port(ds, port))
-			felix_npi_port_init(ocelot, port);
+		cpu = dsa_upstream_port(ds, port);
+		if (port == cpu)
+			continue;
+
+		/* Allow forwarding to and from the CPU port */
+		ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
+			       ANA_PGID_PGID, PGID_SRC + port);
+		ocelot_rmw_rix(ocelot, BIT(port), BIT(port),
+			       ANA_PGID_PGID, PGID_SRC + cpu);
 
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
@@ -618,14 +644,70 @@ static int felix_setup(struct dsa_switch *ds)
 		felix_port_qos_map_init(ocelot, port);
 	}
 
-	/* Include the CPU port module in the forwarding mask for unknown
-	 * unicast - the hardware default value for ANA_FLOODING_FLD_UNICAST
-	 * excludes BIT(ocelot->num_phys_ports), and so does ocelot_init, since
-	 * Ocelot relies on whitelisting MAC addresses towards PGID_CPU.
-	 */
-	ocelot_write_rix(ocelot,
-			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
-			 ANA_PGID_PGID, PGID_UC);
+	if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_NPI)) {
+		unsigned long flood_mask = BIT(ocelot->num_phys_ports);
+
+		felix_npi_port_init(ocelot, cpu);
+
+		/* Include the CPU port module (and indirectly, the NPI port)
+		 * in the forwarding mask for unknown unicast - the hardware
+		 * default value for ANA_FLOODING_FLD_UNICAST excludes
+		 * BIT(ocelot->num_phys_ports), and so does ocelot_init,
+		 * since Ocelot relies on whitelisting MAC addresses towards
+		 * PGID_CPU.
+		 * We do this because DSA does not yet perform RX filtering,
+		 * and the NPI port does not perform source address learning,
+		 * so traffic sent to Linux is effectively unknown from the
+		 * switch's perspective.
+		 */
+		for (port = 0; port < ds->num_ports; port++) {
+			if (dsa_is_unused_port(ds, port))
+				continue;
+
+			flood_mask |= BIT(port);
+		}
+
+		ocelot_write_rix(ocelot, ANA_PGID_PGID_PGID(flood_mask),
+				 ANA_PGID_PGID, PGID_UC);
+	} else if (IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q)) {
+		unsigned long flood_mask = 0;
+
+		felix_8021q_cpu_port_init(ocelot, cpu);
+
+		for (port = 0; port < ds->num_ports; port++) {
+			if (dsa_is_unused_port(ds, port))
+				continue;
+
+			flood_mask |= BIT(port);
+
+			/* This overwrites ocelot_init():
+			 * Do not forward BPDU frames to the CPU port module,
+			 * for 2 reasons:
+			 * - When these packets are injected from the tag_8021q
+			 *   CPU port, we want them to go out, not loop back
+			 *   into the system.
+			 * - STP traffic ingressing on a user port should go to
+			 *   the tag_8021q CPU port, not to the hardware CPU
+			 *   port module.
+			 */
+			ocelot_write_gix(ocelot,
+					 ANA_PORT_CPU_FWD_BPDU_CFG_BPDU_REDIR_ENA(0),
+					 ANA_PORT_CPU_FWD_BPDU_CFG, port);
+		}
+
+		/* In tag_8021q mode, the CPU port module is unused. So we
+		 * want to disable flooding of any kind to the CPU port module
+		 * (which is BIT(ocelot->num_phys_ports)).
+		 */
+		ocelot_write_rix(ocelot, ANA_PGID_PGID_PGID(flood_mask),
+				 ANA_PGID_PGID, PGID_UC);
+		ocelot_write_rix(ocelot, ANA_PGID_PGID_PGID(flood_mask),
+				 ANA_PGID_PGID, PGID_MC);
+
+		err = felix_setup_8021q_tagging(ocelot);
+		if (err)
+			return err;
+	}
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4c717324ac2f..71f343326c00 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -50,6 +50,7 @@ struct felix {
 	struct lynx_pcs			**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
+	struct dsa_8021q_context	*dsa_8021q_ctx;
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.c b/drivers/net/dsa/ocelot/felix_tag_8021q.c
new file mode 100644
index 000000000000..f209273bbf69
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020 NXP Semiconductors
+ *
+ * An implementation of the software-defined tag_8021q.c tagger format, which
+ * also preserves full functionality under a vlan_filtering bridge. It does
+ * this by using the TCAM engines for:
+ * - pushing the RX VLAN as a second, outer tag, on egress towards the CPU port
+ * - redirecting towards the correct front port based on TX VLAN and popping
+ *   that on egress
+ */
+#include <soc/mscc/ocelot_vcap.h>
+#include <linux/dsa/8021q.h>
+#include <linux/if_bridge.h>
+#include "felix.h"
+#include "felix_tag_8021q.h"
+
+static int felix_tag_8021q_rxvlan_add(struct ocelot *ocelot, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	int key_length = vcap->keys[VCAP_ES0_IGR_PORT].length;
+	struct ocelot_vcap_filter *outer_tagging_rule;
+
+	/* We don't need to install the rxvlan into the other ports' filtering
+	 * tables, because we're just pushing the rxvlan when sending towards
+	 * the CPU
+	 */
+	if (!pvid)
+		return 0;
+
+	outer_tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter),
+				     GFP_KERNEL);
+	if (!outer_tagging_rule)
+		return -ENOMEM;
+
+	outer_tagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	outer_tagging_rule->prio = 1;
+	outer_tagging_rule->id.cookie = port;
+	outer_tagging_rule->id.tc_offload = false;
+	outer_tagging_rule->block_id = VCAP_ES0;
+	outer_tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	outer_tagging_rule->lookup = 0;
+	outer_tagging_rule->ingress_port.value = port;
+	outer_tagging_rule->ingress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->egress_port.value = ocelot->dsa_8021q_cpu;
+	outer_tagging_rule->egress_port.mask = GENMASK(key_length - 1, 0);
+	outer_tagging_rule->action.push_outer_tag = OCELOT_ES0_TAG;
+	outer_tagging_rule->action.tag_a_tpid_sel = OCELOT_TAG_TPID_SEL_8021AD;
+	outer_tagging_rule->action.tag_a_vid_sel = 1;
+	outer_tagging_rule->action.vid_a_val = vid;
+
+	return ocelot_vcap_filter_add(ocelot, outer_tagging_rule, NULL);
+}
+
+static int felix_tag_8021q_txvlan_add(struct ocelot *ocelot, int port, u16 vid,
+				      bool pvid, bool untagged)
+{
+	struct ocelot_vcap_filter *untagging_rule;
+	struct ocelot_vcap_filter *redirect_rule;
+	int ret;
+
+	/* tag_8021q.c assumes we are implementing this via port VLAN
+	 * membership, which we aren't. So we don't need to add any VCAP filter
+	 * for the CPU port.
+	 */
+	if (port == ocelot->dsa_8021q_cpu)
+		return 0;
+
+	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!untagging_rule)
+		return -ENOMEM;
+
+	redirect_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
+	if (!redirect_rule) {
+		kfree(untagging_rule);
+		return -ENOMEM;
+	}
+
+	untagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	untagging_rule->ingress_port_mask = BIT(ocelot->dsa_8021q_cpu);
+	untagging_rule->vlan.vid.value = vid;
+	untagging_rule->vlan.vid.mask = VLAN_VID_MASK;
+	untagging_rule->prio = 1;
+	untagging_rule->id.cookie = port;
+	untagging_rule->id.tc_offload = false;
+	untagging_rule->block_id = VCAP_IS1;
+	untagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	untagging_rule->lookup = 0;
+	untagging_rule->action.vlan_pop_cnt_ena = true;
+	untagging_rule->action.vlan_pop_cnt = 1;
+	untagging_rule->action.pag_override_mask = 0xff;
+	untagging_rule->action.pag_val = port;
+
+	ret = ocelot_vcap_filter_add(ocelot, untagging_rule, NULL);
+	if (ret) {
+		kfree(untagging_rule);
+		kfree(redirect_rule);
+		return ret;
+	}
+
+	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
+	redirect_rule->ingress_port_mask = BIT(ocelot->dsa_8021q_cpu);
+	redirect_rule->pag = port;
+	redirect_rule->prio = 1;
+	redirect_rule->id.cookie = port;
+	redirect_rule->id.tc_offload = false;
+	redirect_rule->block_id = VCAP_IS2;
+	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
+	redirect_rule->lookup = 0;
+	redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
+	redirect_rule->action.port_mask = BIT(port);
+
+	ret = ocelot_vcap_filter_add(ocelot, redirect_rule, NULL);
+	if (ret) {
+		ocelot_vcap_filter_del(ocelot, untagging_rule);
+		kfree(redirect_rule);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				    u16 flags)
+{
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
+	struct ocelot *ocelot = ds->priv;
+
+	if (vid_is_dsa_8021q_rxvlan(vid))
+		return felix_tag_8021q_rxvlan_add(ocelot, port, vid, pvid,
+						  untagged);
+
+	if (vid_is_dsa_8021q_txvlan(vid))
+		return felix_tag_8021q_txvlan_add(ocelot, port, vid, pvid,
+						  untagged);
+
+	return 0;
+}
+
+static const struct dsa_8021q_ops felix_tag_8021q_ops = {
+	.vlan_add	= felix_tag_8021q_vlan_add,
+};
+
+int felix_setup_8021q_tagging(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	struct dsa_switch *ds = felix->ds;
+	int ret;
+
+	felix->dsa_8021q_ctx = devm_kzalloc(ds->dev,
+					    sizeof(*felix->dsa_8021q_ctx),
+					    GFP_KERNEL);
+	if (!felix->dsa_8021q_ctx)
+		return -ENOMEM;
+
+	felix->dsa_8021q_ctx->ops = &felix_tag_8021q_ops;
+	felix->dsa_8021q_ctx->proto = htons(ETH_P_8021AD);
+	felix->dsa_8021q_ctx->ds = ds;
+
+	rtnl_lock();
+	ret = dsa_8021q_setup(felix->dsa_8021q_ctx, true);
+	rtnl_unlock();
+
+	return ret;
+}
diff --git a/drivers/net/dsa/ocelot/felix_tag_8021q.h b/drivers/net/dsa/ocelot/felix_tag_8021q.h
new file mode 100644
index 000000000000..47684a18c96e
--- /dev/null
+++ b/drivers/net/dsa/ocelot/felix_tag_8021q.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2020 NXP Semiconductors
+ */
+#ifndef _MSCC_FELIX_TAG_8021Q_H
+#define _MSCC_FELIX_TAG_8021Q_H
+
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q)
+
+int felix_setup_8021q_tagging(struct ocelot *ocelot);
+
+#else
+
+static inline int felix_setup_8021q_tagging(struct ocelot *ocelot)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_OCELOT_8021Q) */
+
+#endif /* _MSCC_FELIX_TAG_8021Q_H */
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0b9992bd6626..be4671bfe95f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -911,8 +911,13 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 	 * a source for the other ports.
 	 */
 	for (p = 0; p < ocelot->num_phys_ports; p++) {
+		unsigned long mask = 0;
+
+		if (p == ocelot->dsa_8021q_cpu)
+			continue;
+
 		if (ocelot->bridge_fwd_mask & BIT(p)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
+			mask = ocelot->bridge_fwd_mask & ~BIT(p);
 
 			for (i = 0; i < ocelot->num_phys_ports; i++) {
 				unsigned long bond_mask = ocelot->lags[i];
@@ -925,13 +930,12 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 					break;
 				}
 			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + p);
 		}
+
+		if (ocelot->dsa_8021q_cpu >= 0)
+			mask |= ocelot->dsa_8021q_cpu;
+
+		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + p);
 	}
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f4cd3288bcc..4cbb7655ef0c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -631,6 +631,7 @@ struct ocelot {
 	u8				num_phys_ports;
 
 	int				npi;
+	int				dsa_8021q_cpu;
 
 	enum ocelot_tag_prefix		inj_prefix;
 	enum ocelot_tag_prefix		xtr_prefix;
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index dfecd7b22fd7..a4ff1385d270 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -111,6 +111,40 @@ config NET_DSA_TAG_OCELOT
 	  Say Y or M if you want to enable support for tagging frames for the
 	  Ocelot switches (VSC7511, VSC7512, VSC7513, VSC7514, VSC9959).
 
+choice
+	prompt "Tagging format"
+	depends on NET_DSA_TAG_OCELOT
+	default NET_DSA_TAG_OCELOT_NPI
+	help
+	  Choose the tagging format for frames delivered by the Ocelot
+	  switches to the CPU.
+
+config NET_DSA_TAG_OCELOT_NPI
+	bool "Native tagging over NPI"
+	help
+	  Say Y if you want to enable NPI tagging for the Ocelot switches.
+	  In this mode, the frames over the Ethernet CPU port are prepended
+	  with a hardware-defined injection/extraction frame header.
+	  Flow control (PAUSE frames) over the CPU port is not supported
+	  when operating in this mode.
+
+	  If unsure, say Y.
+
+config NET_DSA_TAG_OCELOT_8021Q
+	bool "VLAN-based tagging"
+	select NET_DSA_TAG_8021Q
+	help
+	  Say Y if you want to enable support for tagging frames with a custom
+	  VLAN-based header. Frames that require timestamping, such as PTP, are
+	  not delivered over Ethernet but over register-based MMIO. Flow
+	  control over the CPU port is functional in this mode. When using this
+	  mode, less TCAM resources (VCAP IS1, IS2, ES0) are available for use
+	  with tc-flower.
+
+	  If unsure, say N.
+
+endchoice
+
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 0fb2b75a7ae3..0e0d828fec51 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -14,7 +14,8 @@ obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
-obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_NPI) += tag_ocelot.o
+obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
new file mode 100644
index 000000000000..fa89c6a5bb7d
--- /dev/null
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020 NXP Semiconductors
+ */
+#include <linux/dsa/8021q.h>
+#include "dsa_priv.h"
+
+static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(netdev);
+	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
+	u16 queue_mapping = skb_get_queue_mapping(skb);
+	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+
+	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
+			      ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
+}
+
+static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
+				  struct net_device *netdev,
+				  struct packet_type *pt)
+{
+	int src_port, switch_id, qos_class;
+	u16 vid, tci;
+
+	skb_push_rcsum(skb, ETH_HLEN);
+	if (skb_vlan_tag_present(skb)) {
+		tci = skb_vlan_tag_get(skb);
+		__vlan_hwaccel_clear_tag(skb);
+	} else {
+		__skb_vlan_pop(skb, &tci);
+	}
+	skb_pull_rcsum(skb, ETH_HLEN);
+
+	vid = tci & VLAN_VID_MASK;
+	src_port = dsa_8021q_rx_source_port(vid);
+	switch_id = dsa_8021q_rx_switch_id(vid);
+	qos_class = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+
+	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
+	if (!skb->dev)
+		return NULL;
+
+	skb->offload_fwd_mark = 1;
+	skb->priority = qos_class;
+
+	return skb;
+}
+
+static struct dsa_device_ops ocelot_netdev_ops = {
+	.name			= "ocelot",
+	.proto			= DSA_TAG_PROTO_OCELOT,
+	.xmit			= ocelot_xmit,
+	.rcv			= ocelot_rcv,
+	.overhead		= VLAN_HLEN,
+};
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT);
+
+module_dsa_tag_driver(ocelot_netdev_ops);
-- 
2.25.1

