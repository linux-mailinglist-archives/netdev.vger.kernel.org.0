Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BB02A153B
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgJaKaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:30:05 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:21857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbgJaK3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQcE0K4BMIT39pq0qfewWQSR3qOkMwJKOAY3NFg1wGMugTXIWp8ZR9o+xTHFWig6Ec4Qgv8ZVK/NqTVQw3eKgLxU/bCVAA80+NxO4Abz4pOPgzk4zPYxXZehaRWILg0628UlhFIrR/z0FLnw4xFuq0GotMusjq9F4wzBxjZcASBBCp0EMYU2kjyrMiAt9RNvEN8GKR+8dLHNuBsDA7rSQUNMD2m5szl9QQ0at+L6QWliY7Ebhtc2ihFBsavHBaFSSQfZHxvP/4BhqUvnUDyquKIbvg5lwpZwjKnKhMh0ahEAuMZHVkNPLuIQRFWNPJJpQPDuNJL8NCF4m8HWSl0oYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs7h8xl1GgZ+3+5z2el4m3GAbdQj9PdL8h8XkUC8DRU=;
 b=L7y3gA+ziaZfwPVXgNGoClFtIpXw2j1LOw2k08I25FLgXw+QSyjaLBGRCHdRIGgFgHbLm3wdgBixxRr+I8bnoxc9QiEDg7UMBWjHmZyMt9liekrvqQIvr//ezgWHnIKC8C6QiPMT+3C5ZqTi4Uu5m/q4Cv4dIOq5I8W7eOj7J/+vAdG07i4wg7zFfcksKT7QLdn6xW+aAVzP/6/idOcXme+hwff3WA0jJIXzskPhvYyJTyasY1Dk0AoqlbnjlUBcqG+c1QNe6CYuV7G3PuOULrLeDnYSYlf76zJRKUtAjLqZJuKHZebe+pSrT7r4zmb99WpBug6KaJ/psAJrTElHwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs7h8xl1GgZ+3+5z2el4m3GAbdQj9PdL8h8XkUC8DRU=;
 b=goGFVx1gwTMH7ee7tB9nEj/ITqdqgmd8vbuCUSF4ReAV2K68EnqkrjRV+y/ihCF5T1c0WYLGMhy1HLHt0dliCOphNG6TEffgCLToHRRxsT+WUCrxSRIap71WEVKAnUWctKvzbbxe3v93wI0wyobILU4+LUyoMrYb2LN+OIArHmM=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: mscc: ocelot: move the logic to drop 802.1p traffic to the pvid deletion
Date:   Sat, 31 Oct 2020 12:29:14 +0200
Message-Id: <20201031102916.667619-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201031102916.667619-1-vladimir.oltean@nxp.com>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0170.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f15cf324-50d5-4b9a-bead-08d87d87da0f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637DBBFEAE484C8FFE6C9E7E0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhbZ2kmvjR3rk4Ht8JaKvLsvRasKbWqWFA5RnOF6TYh1ghXyt0n32PLL8I5/0gxnYekinaESvOB3Gq9V9/AhAHtwfWfpXzFVVSRYb0HmT5Wsii5gBZ4ZACJs6kE1dUmvt4PSU2dEXfVJ8A4/8J3rZeWzE82otS+su59QnLWeNuqqZOY/fZAPe5O9OQiuyw7McefuIac6OaCbvc8Xru0FDv8j7fCf9yE5uXBKA97J0J82k7LwF+9owbX6RFDR1BDPYz54EemDErskLRZGQLjyDUHc8FLRw30h4R3NSdUnNVkulnWZv1aVrHE/sR2q6tyEeX5RIrccGBYS+ZQOukaQdPDU5/AomlnN5mp0FdmXVbmsn85fRaMrMKmiyahmZyWzVUHUah36J+9zNBnHSmel6NCbB2D7PD3HqJPc7VVqXzxfoWGXOSH764SjKB0fg64+b6YSMPqhS2FgIY9GEX/w+ZS5l4oSnbe2J9qNEnPKrJg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(966005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fs0pnMbYdqGggDB73Y18oQgujrpif9lBd9P9PQhAwKIG6IbqcQ3Ch1qzsTZe6nmd3DyMJqP7EeTl4HOP9eSYKn0dKQC9KQAljRYYalmWgKi7fj3ZMuUMbofVR7KWVmGPzpYXxAim5r/K1IIW5HC+lzJIEhIHPmUbXoULfutnkVQrFdlzqUIq2KiMS5PlPH/qq5bdScDJEOLns3/jI36JLswK+aRFUPU3iHJ8sTDQ1eaE4RatS1lLFFdDkurz12xQTrqPKvfwwQcX65EIkyru6yPUJ9v2KzJ4xuOgZQId+reNn5Tzs5LUoMcRu9GVgnQkJu2fpkcHej9Si2rdIopm7DLo909XHG19avsD+P0zsDB8wk6xdWe2znNg6fLEwxsxVTpd2m/vsT9wHtwRgVvDlEbVFwRXAXyirOm+qkIgtOpMcgyxR56jY9bcPp94G3kjN/+YAB+MpeHm/1LKnk7oe5X1/DmZql6agJ2kE1vlYF98JBc+uQMT0/cZAzpwNUM2KvTTqSQGpTtSa4l+RfLOzmGi+/a9g4k2dxkJ76L+oWn9tIJ/YS31lQF5YF3/qReiawNIlApGs5xc4mwi6t2YOjfZ5QGF/JU/dGU4o3kdORMpYkAae+M0+z05BTMj11YfEPv++/bpIDN/FtWzhiUs2w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15cf324-50d5-4b9a-bead-08d87d87da0f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:30.7316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ws76FFKvOiPWGQ7JzeF1elvlfEsKDK4A0+JO7AIsRjn8e1leZ0NQD2QX36O5UCxs0VtuhkgRGefn/O5f0F/OtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the ocelot_port_set_native_vlan() function starts dropping
untagged and prio-tagged traffic when the native VLAN is removed?

What is the native VLAN? It is the only egress-untagged VLAN that ocelot
supports on a port. If the port is a trunk with 100 VLANs, one of those
VLANs can be transmitted as egress-untagged, and that's the native VLAN.

Is it wrong to drop untagged and prio-tagged traffic if there's no
native VLAN? Yes and no.

In this case, which is more typical, it's ok to apply that drop
configuration:
$ bridge vlan add dev swp0 vid 1 pvid untagged <- this is the native VLAN
$ bridge vlan add dev swp0 vid 100
$ bridge vlan add dev swp0 vid 101
$ bridge vlan del dev swp0 vid 1 <- delete the native VLAN
But only because the pvid and the native VLAN have the same ID.

In this case, it isn't:
$ bridge vlan add dev swp0 vid 1 pvid
$ bridge vlan add dev swp0 vid 100 untagged <- this is the native VLAN
$ bridge vlan del dev swp0 vid 101
$ bridge vlan del dev swp0 vid 100 <- delete the native VLAN

It's wrong, because the switch will drop untagged and prio-tagged
traffic now, despite having a valid pvid of 1.

The confusion seems to stem from the fact that the native VLAN is an
egress setting, while the PVID is an ingress setting. It would be
correct to drop untagged and prio-tagged traffic only if there was no
pvid on the port. So let's do just that.

Background:
https://lore.kernel.org/netdev/CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com/#t

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 35 +++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d49e34430e23..60186fc99280 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -168,19 +168,6 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		       REW_PORT_VLAN_CFG_PORT_VID_M,
 		       REW_PORT_VLAN_CFG, port);
 
-	if (ocelot_port->vlan_aware && !ocelot_port->native_vlan.valid)
-		/* If port is vlan-aware and tagged, drop untagged and priority
-		 * tagged frames.
-		 */
-		val = ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
-		      ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
-		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
-	ocelot_rmw_gix(ocelot, val,
-		       ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
-		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
-		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA,
-		       ANA_PORT_DROP_CFG, port);
-
 	if (ocelot_port->vlan_aware) {
 		if (native_vlan.valid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
@@ -204,6 +191,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 				 struct ocelot_vlan pvid_vlan)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 val = 0;
 
 	ocelot_port->pvid_vlan = pvid_vlan;
 
@@ -214,6 +202,20 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid_vlan.vid),
 		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
 		       ANA_PORT_VLAN_CFG, port);
+
+	/* If there's no pvid, we should drop not only untagged traffic (which
+	 * happens automatically), but also 802.1p traffic which gets
+	 * classified to VLAN 0, but that is always in our RX filter, so it
+	 * would get accepted were it not for this setting.
+	 */
+	if (!pvid_vlan.valid && ocelot_port->vlan_aware)
+		val = ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
+		      ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
+
+	ocelot_rmw_gix(ocelot, val,
+		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
+		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA,
+		       ANA_PORT_DROP_CFG, port);
 }
 
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
@@ -303,6 +305,13 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 	if (ret)
 		return ret;
 
+	/* Ingress */
+	if (ocelot_port->pvid_vlan.vid == vid) {
+		struct ocelot_vlan pvid_vlan = {0};
+
+		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
+	}
+
 	/* Egress */
 	if (ocelot_port->native_vlan.vid == vid) {
 		struct ocelot_vlan native_vlan = {0};
-- 
2.25.1

