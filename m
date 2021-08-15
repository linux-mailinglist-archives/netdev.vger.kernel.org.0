Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8A3EC65E
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 02:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhHOA52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 20:57:28 -0400
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:4858
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233910AbhHOA5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 20:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHCTU74aA6oZKSCAzmKSS1JwCNl53q/SbgS67DbJexsECBYGdp7fwNOg9s8g/sjo2bpuWnoEiB1uGFTz5AXSXO+Kcr6ZCwB4JK1QG9qKNwGig2pFe/MqHXpk/xwG/sRx3jzqQNCNPOiGM2/A1BSj4uF/Xf3r+3jrpSHS3ckcMrZ3CW8lVmwH99KmdmPz/nRxVsMmWjnO2tqfsc6TV5FnojjXSZL3Ee3MQbNVaBI8sdIU8/lAwMKesBkqajG8QbZfxWi6f7pewybi2obtYokf6HjLh+GEJwu/Gv8cnO9b19KtJFNLuV+yzbFceW6M1a3Sd1V5cbLIOgPa7pVBxp4H2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/Ae+4OJiBLNjKCePBvtm4WDEvWCKNQ7OQaOKMAfcKY=;
 b=b7ckRwiPuVqkjBXDOBG4IUK7bTc5gPKSJYX9/JBNDyrliTHpxShezpC1EWA/u34nHafMnDnL1HlJZW4s/utf9yvJ59q4HrFLcUAKEpO12P5sPlQZ3lxb6pPG4Y5BPIUznxxFiDgLPdzG+SXs24dl9Cf0pp9NQWStRpB6PVSDBLQ4iPZcM3cVmJFcqvJUm3nAXb0B2/TQL7EzK1NQ+fKy1i4ykbPbOHakp1/ckS3RW4R0NZQv1oVhf8dENjaitSONftnUqpfkQWe7u2d+gCxr0lwiyOiaqeVIgQgmooj1WFQB/Dvxg3Fd2+WuskC3vFV1Xkuq/UzbNXfwjhpDtEC0sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/Ae+4OJiBLNjKCePBvtm4WDEvWCKNQ7OQaOKMAfcKY=;
 b=Tdo94LNuO4DnA1SYclZ/6X4ndIkbccHr5lqH1kM9/4vvHRASnr/yLOeiB7Lq7JTMIhiSbGIGS32jeZnJOhkKsHMa2kMBOL2nC0KdO4WfQ2kjHdRXkrNCdl8kmufj8JtkuHjtb8AO4FdQUNCXgBsa2NOEEclijUD7guxte+Cs3Bo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Sun, 15 Aug
 2021 00:56:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 00:56:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/2] net: mscc: ocelot: convert to phylink
Date:   Sun, 15 Aug 2021 03:56:22 +0300
Message-Id: <20210815005622.1215653-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210815005622.1215653-1-vladimir.oltean@nxp.com>
References: <20210815005622.1215653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0192.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by PR0P264CA0192.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Sun, 15 Aug 2021 00:56:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c96e80-ffbc-4449-f338-08d95f879070
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301FA97DBF7CD962C9CE49DE0FC9@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82y3N3fwgJHJYYpMj6IJR3myzpSbEoklSLr2MK0PWtetlWMFXWzdu69W/iEufmDW9ZXcbTWUSmkP7UF6R+EECGyC5azPo02NPjcDfpxUHN9OCpsZdq/YohxEeee9oZkQji79l+34grfMW/PYnV7tGWnohI2UTsF17jWxsLZgYum8+AGOZorsS5I5/I1whcRELshZ79smiVTzUXWc+kjvBjuJihN6uE5pP0ff88ggkVp+H0fSHe821ZghH5J6sLxs9mZQcmW9f/aK82lU1xLZ9qPcZwH6cQAGlcFqkbigIQ6Vg/2qEH839m/Ejs2+31yMCldfXfLY7GLSwMa34tKlBwxWbR0jzH5KtoSuLM5yOR2iGJuxyT80lPe02bZoaYY4Q2Iq+g+yMk72nJJDlmZih+qK1/Nn19CNtiWPhIPX3oVpGY9nGzPChDC8SYZc/DIaSN7CrRbP0vaOV67aYBjkq05xRzotEecMtMMSbf6J3h0njdAVl3rJQDGS90TWpz4Jjdl5vaywmiimu0GcG+5+O5pcFotiaujHpTg5tv5awdTLFV8f6080oPwfhhhk17Jv+wD6vC3yGBnd2Md1JALXnPEK+zaxALP7GXYzkwH/EuPx8rVehcY1ZRlGre4Bb/INJbOfPy2BVUSEWGD3B2bnjpTQE72Y96GwR483Z8Pe34yr/VvFKvTQY2geGH9u5/Kt5ump0hsih+w6apqID2wADA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(508600001)(8936002)(186003)(6512007)(6666004)(1076003)(52116002)(86362001)(5660300002)(36756003)(2906002)(6506007)(38100700002)(38350700002)(30864003)(66946007)(83380400001)(44832011)(7416002)(66476007)(66556008)(54906003)(6486002)(110136005)(956004)(26005)(8676002)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ctuw+CDnGjl8cLK7ZeJw3a2Rtzb6J23nNC/tEQfACsyGEFpdj8j1gg0u5KPE?=
 =?us-ascii?Q?zOAosKll6LY0gc5J6LY4z17F8Tk5OXQYJs06Q5MdLwpnkztk/PJjbwfYQk0W?=
 =?us-ascii?Q?PSs9omIt4XcwuxWS3edhxD3PIUQ7xBtmv741P9JXcKnUk6KhR5t/w57/I4tX?=
 =?us-ascii?Q?/6sns07j9dN1/DmbN5jq1X5Jae/BJ0gaVsGmMKNLE7gMBw+RyFQois8J9hqf?=
 =?us-ascii?Q?ht2IStOmNDbGnTrdtmuEad12QC7cz7tSjXy6LESldwK4wxObEfPOjWL0LguE?=
 =?us-ascii?Q?jeRbAayhE+wXTztHqmAtwaKmfFgPuBon0No1B0ZzziaeyVyIbRIwSVLl6gy/?=
 =?us-ascii?Q?sKN0MMqmutEsKtH9ucKAEEwkH3omMCxarIwC5Q7zSxUZTi2mQc67DgN/Ys5b?=
 =?us-ascii?Q?Oq930uV5RJlgm5bypKxN4ygyl1i1acX5RnEXvs+jba9FV9LMeO48vlEgcwNU?=
 =?us-ascii?Q?/oCaPGPsGvOwhkwRGzIn+27Sl3JFgYQYsoA9u9d/qRYYIE8ViTtqIvaVjNUp?=
 =?us-ascii?Q?rfoz3vL8DcBlOyPpI4k+keRWcDa/qEF8DIIfuzxwEaZfikTwnNrWKh21G17b?=
 =?us-ascii?Q?xB/AZN9QYDx8JAq8JQb1YxaAMKnAEINaS/pvhhF+YgCigAqv0VZSqGhC6tlz?=
 =?us-ascii?Q?XA6/xCjQNc42+nbThPduHwbwb7l3dJG82j8zALmfTLJBsY4rAdiQqBX44R6z?=
 =?us-ascii?Q?t1l8x114FLpts3Est8T7Gs3zyJDxG4eWKJ2wr7TS9auMQGC0V3zj7soeoYYe?=
 =?us-ascii?Q?R4LMArna2S4QgyaMasVS39S9OvwNQXzgmBZoYiSXCapNAnKoxFtz/Rxmx3Z0?=
 =?us-ascii?Q?vspvsAA/YQ6Rwcs1tWuZ1FSVKbhZ+0RyCYYSk/PFkG8XRjeIDAmwJo+gjjAg?=
 =?us-ascii?Q?70lvJXorcb1R+blp1eyj5PwgJaf6REEwxrRaVK37s0IvjaHmF/yG3Lale0DK?=
 =?us-ascii?Q?BNdL6jCwc4ijiWROqNB0SPEv+SjkXdK3oGoFT4DbQX//i/XmsXL0/4EvDhWz?=
 =?us-ascii?Q?8Yc0LMj/g+jIeVw/Bx2zP13BAMbprsX9ScIFMQy4fjDPXmM7Dt330pdn3xmT?=
 =?us-ascii?Q?d6KNvEehfmKGmW4Xm9ZWnxLOJMM/ahGXs1rF+bmIwKTEVkRopg9yqA+Tfa2B?=
 =?us-ascii?Q?81AJ+VA8k844a+ivortpVPYn+ORa4QXEIMc5mpGHe2tTYN5BZjqu7+4TpUEp?=
 =?us-ascii?Q?Fq9K3H4m3ykBNGDAUCFjLWPciiveEP0JUn+dNigY7LKwFCt9HDETuZd2lVJl?=
 =?us-ascii?Q?rEdTtAscF+9I5obDqp+dfcPK9I9ai33dQDxRLUFpxO/FQ2J4OyB068+R5KZj?=
 =?us-ascii?Q?gSgYitjqtJAS2wYifGmVnIQU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c96e80-ffbc-4449-f338-08d95f879070
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 00:56:50.1179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0a+lL0Zm/7hJwpiMsA3iK3n0K9wbGgQOOnjw5F3lIaKofpW0lWr57YEjJbUdFWDvSKmn9XBB+0cAo3dCv5KeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix DSA driver, which is a wrapper over the same hardware class as
ocelot, is integrated with phylink, but ocelot is using the plain PHY
library. It makes sense to bring together the two implementations, which
is what this patch achieves.

This is a large patch and hard to break up, but it does the following:

The existing ocelot_adjust_link writes some registers, and
felix_phylink_mac_link_up writes some registers, some of them are
common, but both functions write to some registers to which the other
doesn't.

The main reasons for this are:
- Felix switches so far have used an NXP PCS so they had no need to
  write the PCS1G registers that ocelot_adjust_link writes
- Felix switches have the MAC fixed at 1G, so some of the MAC speed
  changes actually break the link and must be avoided.

The naming conventions for the functions introduced in this patch are:
- vsc7514_phylink_{mac_config,validate} are specific to the Ocelot
  instantiations and placed in ocelot_net.c which is built only for the
  ocelot switchdev driver.
- ocelot_phylink_mac_link_{up,down} are shared between the ocelot
  switchdev driver and the felix DSA driver (they are put in the common
  lib).

One by one, the registers written by ocelot_adjust_link are:

DEV_MAC_MODE_CFG - felix_phylink_mac_link_up had no need to write this
                   register since its out-of-reset value was fine and
                   did not need changing. The write is moved to the
                   common ocelot_phylink_mac_link_up and on felix it is
                   guarded by a quirk bit that makes the written value
                   identical with the out-of-reset one
DEV_PORT_MISC - runtime invariant, was moved to vsc7514_phylink_mac_config
PCS1G_MODE_CFG - same as above
PCS1G_SD_CFG - same as above
PCS1G_CFG - same as above
PCS1G_ANEG_CFG - same as above
PCS1G_LB_CFG - same as above
DEV_MAC_ENA_CFG - both ocelot_adjust_link and ocelot_port_disable
                  touched this. felix_phylink_mac_link_{up,down} also
                  do. We go with what felix does and put it in
                  ocelot_phylink_mac_link_up.
DEV_CLOCK_CFG - ocelot_adjust_link and felix_phylink_mac_link_up both
                write this, but to different values. Move to the common
                ocelot_phylink_mac_link_up and make sure via the quirk
                that the old values are preserved for both.
ANA_PFC_PFC_CFG - ocelot_adjust_link wrote this, felix_phylink_mac_link_up
                  did not. Runtime invariant, speed does not matter since
                  PFC is disabled via the RX_PFC_ENA bits which are cleared.
                  Move to vsc7514_phylink_mac_config.
QSYS_SWITCH_PORT_MODE_PORT_ENA - both ocelot_adjust_link and
                                 felix_phylink_mac_link_{up,down} wrote
                                 this. Ocelot also wrote this register
                                 from ocelot_port_disable. Keep what
                                 felix did, move in ocelot_phylink_mac_link_{up,down}
                                 and delete ocelot_port_disable.
ANA_POL_FLOWC - same as above
SYS_MAC_FC_CFG - same as above, except slight behavior change. Whereas
                 ocelot always enabled RX and TX flow control, felix
                 listened to phylink (for the most part, at least - see
                 the 2500base-X comment).

The registers which only felix_phylink_mac_link_up wrote are:

SYS_PAUSE_CFG_PAUSE_ENA - this is why I am not sure that flow control
                          worked on ocelot. Not it should, since the
                          code is shared with felix where it does.
ANA_PORT_PORT_CFG - this is a Frame Analyzer block register, phylink
                    should be the one touching them, deleted.

Other changes:

- The old phylib registration code was in mscc_ocelot_init_ports. It is
  hard to work with 2 levels of indentation already in, and with hard to
  follow teardown logic. The new phylink registration code was moved
  inside ocelot_probe_port(), right between alloc_etherdev() and
  register_netdev(). It could not be done before (=> outside of)
  ocelot_probe_port() because ocelot_probe_port() allocates the struct
  ocelot_port which we then use to assign ocelot_port->phy_mode to. It
  is more preferable to me to have all PHY handling logic inside the
  same function.
- On the same topic: struct ocelot_port_private :: serdes is only used
  in ocelot_port_open to set the SERDES protocol to Ethernet. This is
  logically a runtime invariant and can be done just once, when the port
  registers with phylink. We therefore don't even need to keep the
  serdes reference inside struct ocelot_port_private, or to use the devm
  variant of of_phy_get().
- Phylink needs a valid phy-mode for phylink_create() to succeed, and
  the existing device tree bindings in arch/mips/boot/dts/mscc/ocelot_pcb120.dts
  don't define one for the internal PHY ports. So we patch
  PHY_INTERFACE_MODE_NA into PHY_INTERFACE_MODE_INTERNAL.
- There was a strategically placed:

	switch (priv->phy_mode) {
	case PHY_INTERFACE_MODE_NA:
	        continue;

  which made the code skip the serdes initialization for the internal
  PHY ports. Frankly that is not all that obvious, so now we explicitly
  initialize the serdes under an "if" condition and not rely on code
  jumps, so everything is clearer.
- There was a write of OCELOT_SPEED_1000 to DEV_CLOCK_CFG for QSGMII
  ports. Since that is in fact the default value for the register field
  DEV_CLOCK_CFG_LINK_SPEED, I can only guess the intention was to clear
  the adjacent fields, MAC_TX_RST and MAC_RX_RST, aka take the port out
  of reset, which does match the comment. I don't even want to know why
  this code is placed there, but if there is indeed an issue that all
  ports that share a QSGMII lane must all be up, then this logic is
  already buggy, since mscc_ocelot_init_ports iterates using
  for_each_available_child_of_node, so nobody prevents the user from
  putting a 'status = "disabled";' for some QSGMII ports which would
  break the driver's assumption.
  In any case, in the eventuality that I'm right, we would have yet
  another issue if ocelot_phylink_mac_link_down would reset those ports
  and that would be forbidden, so since the ocelot_adjust_link logic did
  not do that (maybe for a reason), add another quirk to preserve the
  old logic.

The ocelot driver teardown goes through all ports in one fell swoop.
When initialization of one port fails, the ocelot->ports[port] pointer
for that is reset to NULL, and teardown is done only for non-NULL ports,
so there is no reason to do partial teardowns, let the central
mscc_ocelot_release_ports() do its job.

Tested bind, unbind, rebind, link up, link down, speed change on mock-up
hardware (modified the driver to probe on Felix VSC9959). Also
regression tested the felix DSA driver. Could not test the Ocelot
specific bits (PCS1G, SERDES, device tree bindings).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             |  90 +-------
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/ethernet/mscc/Kconfig          |   2 +-
 drivers/net/ethernet/mscc/ocelot.c         | 152 ++++++++-----
 drivers/net/ethernet/mscc/ocelot.h         |  11 +-
 drivers/net/ethernet/mscc/ocelot_net.c     | 252 +++++++++++++++++----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  59 +----
 include/soc/mscc/ocelot.h                  |  19 +-
 8 files changed, 330 insertions(+), 256 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0050bb5b10aa..cbe23b20f3fa 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -824,25 +824,9 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int err;
-
-	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
-			 DEV_MAC_ENA_CFG);
-
-	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
 
-	err = ocelot_port_flush(ocelot, port);
-	if (err)
-		dev_err(ocelot->dev, "failed to flush port %d: %d\n",
-			port, err);
-
-	/* Put the port in reset. */
-	ocelot_port_writel(ocelot_port,
-			   DEV_CLOCK_CFG_MAC_TX_RST |
-			   DEV_CLOCK_CFG_MAC_RX_RST |
-			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
-			   DEV_CLOCK_CFG);
+	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
+				     FELIX_MAC_QUIRKS);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -853,75 +837,11 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				      bool tx_pause, bool rx_pause)
 {
 	struct ocelot *ocelot = ds->priv;
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct felix *felix = ocelot_to_felix(ocelot);
-	u32 mac_fc_cfg;
-
-	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
-	 * PORT_RST bits in DEV_CLOCK_CFG. Note that the way this system is
-	 * integrated is that the MAC speed is fixed and it's the PCS who is
-	 * performing the rate adaptation, so we have to write "1000Mbps" into
-	 * the LINK_SPEED field of DEV_CLOCK_CFG (which is also its default
-	 * value).
-	 */
-	ocelot_port_writel(ocelot_port,
-			   DEV_CLOCK_CFG_LINK_SPEED(OCELOT_SPEED_1000),
-			   DEV_CLOCK_CFG);
 
-	switch (speed) {
-	case SPEED_10:
-		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(3);
-		break;
-	case SPEED_100:
-		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(2);
-		break;
-	case SPEED_1000:
-	case SPEED_2500:
-		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(1);
-		break;
-	default:
-		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
-			port, speed);
-		return;
-	}
-
-	/* handle Rx pause in all cases, with 2500base-X this is used for rate
-	 * adaptation.
-	 */
-	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
-
-	if (tx_pause)
-		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
-			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
-			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
-			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
-
-	/* Flow control. Link speed is only used here to evaluate the time
-	 * specification in incoming pause frames.
-	 */
-	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
-
-	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-
-	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, tx_pause);
-
-	/* Undo the effects of felix_phylink_mac_link_down:
-	 * enable MAC module
-	 */
-	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
-			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
-
-	/* Enable receiving frames on the port, and activate auto-learning of
-	 * MAC addresses.
-	 */
-	ocelot_write_gix(ocelot, ANA_PORT_PORT_CFG_LEARNAUTO |
-			 ANA_PORT_PORT_CFG_RECV_ENA |
-			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
-			 ANA_PORT_PORT_CFG, port);
-
-	/* Core: Enable port for frame transfer */
-	ocelot_fields_write(ocelot, port,
-			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
+	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
+				   interface, speed, duplex, tx_pause, rx_pause,
+				   FELIX_MAC_QUIRKS);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9da3c6a94c6e..5854bab43327 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -5,6 +5,7 @@
 #define _MSCC_FELIX_H
 
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
+#define FELIX_MAC_QUIRKS		OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION
 
 /* Platform-specific information */
 struct felix_info {
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index b1d68e197258..b6a73d151dec 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -16,7 +16,7 @@ config MSCC_OCELOT_SWITCH_LIB
 	select NET_DEVLINK
 	select REGMAP_MMIO
 	select PACKING
-	select PHYLIB
+	select PHYLINK
 	tristate
 	help
 	  This is a hardware support library for Ocelot network switches. It is
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a948c807349d..2126ec130c99 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -377,7 +377,7 @@ static u32 ocelot_read_eq_avail(struct ocelot *ocelot, int port)
 	return ocelot_read_rix(ocelot, QSYS_SW_STATUS, port);
 }
 
-int ocelot_port_flush(struct ocelot *ocelot, int port)
+static int ocelot_port_flush(struct ocelot *ocelot, int port)
 {
 	unsigned int pause_ena;
 	int err, val;
@@ -429,63 +429,119 @@ int ocelot_port_flush(struct ocelot *ocelot, int port)
 
 	return err;
 }
-EXPORT_SYMBOL(ocelot_port_flush);
 
-void ocelot_adjust_link(struct ocelot *ocelot, int port,
-			struct phy_device *phydev)
+void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
+				  unsigned int link_an_mode,
+				  phy_interface_t interface,
+				  unsigned long quirks)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int speed, mode = 0;
+	int err;
+
+	ocelot_port_rmwl(ocelot_port, 0, DEV_MAC_ENA_CFG_RX_ENA,
+			 DEV_MAC_ENA_CFG);
+
+	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
+
+	err = ocelot_port_flush(ocelot, port);
+	if (err)
+		dev_err(ocelot->dev, "failed to flush port %d: %d\n",
+			port, err);
+
+	/* Put the port in reset. */
+	if (interface != PHY_INTERFACE_MODE_QSGMII ||
+	    !(quirks & OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP))
+		ocelot_port_rmwl(ocelot_port,
+				 DEV_CLOCK_CFG_MAC_TX_RST |
+				 DEV_CLOCK_CFG_MAC_TX_RST,
+				 DEV_CLOCK_CFG_MAC_TX_RST |
+				 DEV_CLOCK_CFG_MAC_TX_RST,
+				 DEV_CLOCK_CFG);
+}
+EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_down);
+
+void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
+				struct phy_device *phydev,
+				unsigned int link_an_mode,
+				phy_interface_t interface,
+				int speed, int duplex,
+				bool tx_pause, bool rx_pause,
+				unsigned long quirks)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int mac_speed, mode = 0;
+	u32 mac_fc_cfg;
+
+	/* The MAC might be integrated in systems where the MAC speed is fixed
+	 * and it's the PCS who is performing the rate adaptation, so we have
+	 * to write "1000Mbps" into the LINK_SPEED field of DEV_CLOCK_CFG
+	 * (which is also its default value).
+	 */
+	if ((quirks & OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION) ||
+	    speed == SPEED_1000) {
+		mac_speed = OCELOT_SPEED_1000;
+		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
+	} else if (speed == SPEED_2500) {
+		mac_speed = OCELOT_SPEED_2500;
+		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
+	} else if (speed == SPEED_100) {
+		mac_speed = OCELOT_SPEED_100;
+	} else {
+		mac_speed = OCELOT_SPEED_10;
+	}
 
-	switch (phydev->speed) {
+	if (duplex == DUPLEX_FULL)
+		mode |= DEV_MAC_MODE_CFG_FDX_ENA;
+	/* Only full duplex supported for now */
+	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
+			   mode, DEV_MAC_MODE_CFG);
+
+	/* Take port out of reset by clearing the MAC_TX_RST, MAC_RX_RST and
+	 * PORT_RST bits in DEV_CLOCK_CFG.
+	 */
+	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),
+			   DEV_CLOCK_CFG);
+
+	switch (speed) {
 	case SPEED_10:
-		speed = OCELOT_SPEED_10;
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(OCELOT_SPEED_10);
 		break;
 	case SPEED_100:
-		speed = OCELOT_SPEED_100;
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(OCELOT_SPEED_100);
 		break;
 	case SPEED_1000:
-		speed = OCELOT_SPEED_1000;
-		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
-		break;
 	case SPEED_2500:
-		speed = OCELOT_SPEED_2500;
-		mode = DEV_MAC_MODE_CFG_GIGA_MODE_ENA;
+		mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(OCELOT_SPEED_1000);
 		break;
 	default:
-		dev_err(ocelot->dev, "Unsupported PHY speed on port %d: %d\n",
-			port, phydev->speed);
+		dev_err(ocelot->dev, "Unsupported speed on port %d: %d\n",
+			port, speed);
 		return;
 	}
 
-	phy_print_status(phydev);
-
-	if (!phydev->link)
-		return;
-
-	/* Only full duplex supported for now */
-	ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
-			   mode, DEV_MAC_MODE_CFG);
-
-	/* Disable HDX fast control */
-	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
-			   DEV_PORT_MISC);
+	/* Handle RX pause in all cases, with 2500base-X this is used for rate
+	 * adaptation.
+	 */
+	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
 
-	/* SGMII only for now */
-	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
-			   PCS1G_MODE_CFG);
-	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+	if (tx_pause)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
+			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
+			      SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
+			      SYS_MAC_FC_CFG_ZERO_PAUSE_ENA;
 
-	/* Enable PCS */
-	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+	/* Flow control. Link speed is only used here to evaluate the time
+	 * specification in incoming pause frames.
+	 */
+	ocelot_write_rix(ocelot, mac_fc_cfg, SYS_MAC_FC_CFG, port);
 
-	/* No aneg on SGMII */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
-	/* No loopback */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, tx_pause);
 
-	/* Enable MAC module */
+	/* Undo the effects of ocelot_phylink_mac_link_down:
+	 * enable MAC module
+	 */
 	ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
@@ -502,26 +558,8 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
-
-	/* Flow control */
-	ocelot_write_rix(ocelot, SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
-			 SYS_MAC_FC_CFG_RX_FC_ENA | SYS_MAC_FC_CFG_TX_FC_ENA |
-			 SYS_MAC_FC_CFG_ZERO_PAUSE_ENA |
-			 SYS_MAC_FC_CFG_FC_LATENCY_CFG(0x7) |
-			 SYS_MAC_FC_CFG_FC_LINK_SPEED(speed),
-			 SYS_MAC_FC_CFG, port);
-	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
-}
-EXPORT_SYMBOL(ocelot_adjust_link);
-
-void ocelot_port_disable(struct ocelot *ocelot, int port)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
-	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
 }
-EXPORT_SYMBOL(ocelot_port_disable);
+EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
 
 static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 					 struct sk_buff *clone)
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index db6b1a4c3926..1952d6a1b98a 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -12,8 +12,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/net_tstamp.h>
-#include <linux/phy.h>
-#include <linux/phy/phy.h>
+#include <linux/phylink.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
@@ -42,11 +41,9 @@ struct ocelot_port_tc {
 struct ocelot_port_private {
 	struct ocelot_port port;
 	struct net_device *dev;
-	struct phy_device *phy;
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
 	u8 chip_port;
-
-	struct phy *serdes;
-
 	struct ocelot_port_tc tc;
 };
 
@@ -107,7 +104,7 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
-		      struct phy_device *phy);
+		      struct device_node *portnp);
 void ocelot_release_port(struct ocelot_port *ocelot_port);
 int ocelot_devlink_init(struct ocelot *ocelot);
 void ocelot_devlink_teardown(struct ocelot *ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 97162e63d8e9..5e8965be968a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -9,10 +9,14 @@
  */
 
 #include <linux/if_bridge.h>
+#include <linux/of_net.h>
+#include <linux/phy/phy.h>
 #include <net/pkt_cls.h>
 #include "ocelot.h"
 #include "ocelot_vcap.h"
 
+#define OCELOT_MAC_QUIRKS	OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP
+
 static struct ocelot *devlink_port_to_ocelot(struct devlink_port *dlp)
 {
 	return devlink_priv(dlp->devlink);
@@ -381,15 +385,6 @@ static int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return 0;
 }
 
-static void ocelot_port_adjust_link(struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	ocelot_adjust_link(ocelot, port, dev->phydev);
-}
-
 static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
 				   bool untagged)
 {
@@ -448,31 +443,8 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 static int ocelot_port_open(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
-	int err;
-
-	if (priv->serdes) {
-		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
-				       ocelot_port->phy_mode);
-		if (err) {
-			netdev_err(dev, "Could not set mode of SerDes\n");
-			return err;
-		}
-	}
 
-	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
-				 ocelot_port->phy_mode);
-	if (err) {
-		netdev_err(dev, "Could not attach to PHY\n");
-		return err;
-	}
-
-	dev->phydev = priv->phy;
-
-	phy_attached_info(priv->phy);
-	phy_start(priv->phy);
+	phylink_start(priv->phylink);
 
 	return 0;
 }
@@ -480,14 +452,8 @@ static int ocelot_port_open(struct net_device *dev)
 static int ocelot_port_stop(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	phy_disconnect(priv->phy);
-
-	dev->phydev = NULL;
 
-	ocelot_port_disable(ocelot, port);
+	phylink_stop(priv->phylink);
 
 	return 0;
 }
@@ -1526,8 +1492,188 @@ struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
 	.notifier_call = ocelot_switchdev_blocking_event,
 };
 
+static void vsc7514_phylink_validate(struct phylink_config *config,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = {};
+
+	if (state->interface != PHY_INTERFACE_MODE_NA &&
+	    state->interface != ocelot_port->phy_mode) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return;
+	}
+
+	phylink_set_port_modes(mask);
+
+	phylink_set(mask, Pause);
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseX_Full);
+	phylink_set(mask, 2500baseT_Full);
+	phylink_set(mask, 2500baseX_Full);
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static void vsc7514_phylink_mac_config(struct phylink_config *config,
+				       unsigned int link_an_mode,
+				       const struct phylink_link_state *state)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot_port *ocelot_port = &priv->port;
+
+	/* Disable HDX fast control */
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+}
+
+static void vsc7514_phylink_mac_link_down(struct phylink_config *config,
+					  unsigned int link_an_mode,
+					  phy_interface_t interface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
+				     OCELOT_MAC_QUIRKS);
+}
+
+static void vsc7514_phylink_mac_link_up(struct phylink_config *config,
+					struct phy_device *phydev,
+					unsigned int link_an_mode,
+					phy_interface_t interface,
+					int speed, int duplex,
+					bool tx_pause, bool rx_pause)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct ocelot_port_private *priv = netdev_priv(ndev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
+				   interface, speed, duplex,
+				   tx_pause, rx_pause, OCELOT_MAC_QUIRKS);
+}
+
+static const struct phylink_mac_ops ocelot_phylink_ops = {
+	.validate		= vsc7514_phylink_validate,
+	.mac_config		= vsc7514_phylink_mac_config,
+	.mac_link_down		= vsc7514_phylink_mac_link_down,
+	.mac_link_up		= vsc7514_phylink_mac_link_up,
+};
+
+static int ocelot_port_phylink_create(struct ocelot *ocelot, int port,
+				      struct device_node *portnp)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_port_private *priv;
+	struct device *dev = ocelot->dev;
+	phy_interface_t phy_mode;
+	struct phylink *phylink;
+	int err;
+
+	of_get_phy_mode(portnp, &phy_mode);
+	/* DT bindings of internal PHY ports are broken and don't
+	 * specify a phy-mode
+	 */
+	if (phy_mode == PHY_INTERFACE_MODE_NA)
+		phy_mode = PHY_INTERFACE_MODE_INTERNAL;
+
+	if (phy_mode != PHY_INTERFACE_MODE_SGMII &&
+	    phy_mode != PHY_INTERFACE_MODE_QSGMII &&
+	    phy_mode != PHY_INTERFACE_MODE_INTERNAL) {
+		dev_err(dev, "unsupported phy mode %s for port %d\n",
+			phy_modes(phy_mode), port);
+		return -EINVAL;
+	}
+
+	/* Ensure clock signals and speed are set on all QSGMII links */
+	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
+		ocelot_port_rmwl(ocelot_port, 0,
+				 DEV_CLOCK_CFG_MAC_TX_RST |
+				 DEV_CLOCK_CFG_MAC_TX_RST,
+				 DEV_CLOCK_CFG);
+
+	ocelot_port->phy_mode = phy_mode;
+
+	if (phy_mode != PHY_INTERFACE_MODE_INTERNAL) {
+		struct phy *serdes = of_phy_get(portnp, NULL);
+
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			dev_err_probe(dev, err,
+				      "missing SerDes phys for port %d\n",
+				      port);
+			return err;
+		}
+
+		err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode);
+		of_phy_put(serdes);
+		if (err) {
+			dev_err(dev, "Could not SerDes mode on port %d: %pe\n",
+				port, ERR_PTR(err));
+			return err;
+		}
+	}
+
+	priv = container_of(ocelot_port, struct ocelot_port_private, port);
+
+	priv->phylink_config.dev = &priv->dev->dev;
+	priv->phylink_config.type = PHYLINK_NETDEV;
+
+	phylink = phylink_create(&priv->phylink_config,
+				 of_fwnode_handle(portnp),
+				 phy_mode, &ocelot_phylink_ops);
+	if (IS_ERR(phylink)) {
+		err = PTR_ERR(phylink);
+		dev_err(dev, "Could not create phylink (%pe)\n", phylink);
+		return err;
+	}
+
+	priv->phylink = phylink;
+
+	err = phylink_of_phy_connect(phylink, portnp, 0);
+	if (err) {
+		dev_err(dev, "Could not connect to PHY: %pe\n", ERR_PTR(err));
+		phylink_destroy(phylink);
+		priv->phylink = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
-		      struct phy_device *phy)
+		      struct device_node *portnp)
 {
 	struct ocelot_port_private *priv;
 	struct ocelot_port *ocelot_port;
@@ -1540,7 +1686,6 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	SET_NETDEV_DEV(dev, ocelot->dev);
 	priv = netdev_priv(dev);
 	priv->dev = dev;
-	priv->phy = phy;
 	priv->chip_port = port;
 	ocelot_port = &priv->port;
 	ocelot_port->ocelot = ocelot;
@@ -1561,15 +1706,23 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 
 	ocelot_init_port(ocelot, port);
 
+	err = ocelot_port_phylink_create(ocelot, port, portnp);
+	if (err)
+		goto out;
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
-		free_netdev(dev);
-		ocelot->ports[port] = NULL;
-		return err;
+		goto out;
 	}
 
 	return 0;
+
+out:
+	ocelot->ports[port] = NULL;
+	free_netdev(dev);
+
+	return err;
 }
 
 void ocelot_release_port(struct ocelot_port *ocelot_port)
@@ -1579,5 +1732,14 @@ void ocelot_release_port(struct ocelot_port *ocelot_port)
 						port);
 
 	unregister_netdev(priv->dev);
+
+	if (priv->phylink) {
+		rtnl_lock();
+		phylink_disconnect_phy(priv->phylink);
+		rtnl_unlock();
+
+		phylink_destroy(priv->phylink);
+	}
+
 	free_netdev(priv->dev);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index aa41c9cde643..18aed504f45d 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/of_net.h>
 #include <linux/netdevice.h>
+#include <linux/phylink.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
 #include <linux/mfd/syscon.h>
@@ -945,13 +946,9 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
-		struct device_node *phy_node;
 		struct devlink_port *dlp;
-		phy_interface_t phy_mode;
-		struct phy_device *phy;
 		struct regmap *target;
 		struct resource *res;
-		struct phy *serdes;
 		char res_name[8];
 
 		if (of_property_read_u32(portnp, "reg", &reg))
@@ -975,15 +972,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			goto out_teardown;
 		}
 
-		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
-		if (!phy_node)
-			continue;
-
-		phy = of_phy_find_device(phy_node);
-		of_node_put(phy_node);
-		if (!phy)
-			continue;
-
 		err = ocelot_port_devlink_init(ocelot, port,
 					       DEVLINK_PORT_FLAVOUR_PHYSICAL);
 		if (err) {
@@ -992,7 +980,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		}
 		devlink_ports_registered |= BIT(port);
 
-		err = ocelot_probe_port(ocelot, port, target, phy);
+		err = ocelot_probe_port(ocelot, port, target, portnp);
 		if (err) {
 			of_node_put(portnp);
 			goto out_teardown;
@@ -1003,49 +991,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 				    port);
 		dlp = &ocelot->devlink_ports[port];
 		devlink_port_type_eth_set(dlp, priv->dev);
-
-		of_get_phy_mode(portnp, &phy_mode);
-
-		ocelot_port->phy_mode = phy_mode;
-
-		switch (ocelot_port->phy_mode) {
-		case PHY_INTERFACE_MODE_NA:
-			continue;
-		case PHY_INTERFACE_MODE_SGMII:
-			break;
-		case PHY_INTERFACE_MODE_QSGMII:
-			/* Ensure clock signals and speed is set on all
-			 * QSGMII links
-			 */
-			ocelot_port_writel(ocelot_port,
-					   DEV_CLOCK_CFG_LINK_SPEED
-					   (OCELOT_SPEED_1000),
-					   DEV_CLOCK_CFG);
-			break;
-		default:
-			dev_err(ocelot->dev,
-				"invalid phy mode for port%d, (Q)SGMII only\n",
-				port);
-			of_node_put(portnp);
-			err = -EINVAL;
-			goto out_teardown;
-		}
-
-		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
-		if (IS_ERR(serdes)) {
-			err = PTR_ERR(serdes);
-			if (err == -EPROBE_DEFER)
-				dev_dbg(ocelot->dev, "deferring probe\n");
-			else
-				dev_err(ocelot->dev,
-					"missing SerDes phys for port%d\n",
-					port);
-
-			of_node_put(portnp);
-			goto out_teardown;
-		}
-
-		priv->serdes = serdes;
 	}
 
 	/* Initialize unused devlink ports at the end */
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2c2dcb954f23..fb5681f7e61b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -589,6 +589,9 @@ enum ocelot_sb_pool {
 	OCELOT_SB_POOL_NUM,
 };
 
+#define OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION	BIT(0)
+#define OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP		BIT(1)
+
 struct ocelot_port {
 	struct ocelot			*ocelot;
 
@@ -798,16 +801,12 @@ void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
 /* DSA callbacks */
-void ocelot_port_disable(struct ocelot *ocelot, int port);
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
-int ocelot_port_flush(struct ocelot *ocelot, int port);
-void ocelot_adjust_link(struct ocelot *ocelot, int port,
-			struct phy_device *phydev);
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
@@ -892,6 +891,18 @@ int ocelot_sb_occ_tc_port_bind_get(struct ocelot *ocelot, int port,
 				   enum devlink_sb_pool_type pool_type,
 				   u32 *p_cur, u32 *p_max);
 
+void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
+				  unsigned int link_an_mode,
+				  phy_interface_t interface,
+				  unsigned long quirks);
+void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
+				struct phy_device *phydev,
+				unsigned int link_an_mode,
+				phy_interface_t interface,
+				int speed, int duplex,
+				bool tx_pause, bool rx_pause,
+				unsigned long quirks);
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp);
-- 
2.25.1

