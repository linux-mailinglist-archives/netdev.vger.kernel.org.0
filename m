Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2E3C5F30
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhGLPZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:52 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235591AbhGLPZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdhHr/ZP/LIsFRgvreKMEmM/gEdgbUFwQDViTvYd9DzoHOtIkAVsjFpi6aHwNSCTADmUbRKjqRjOHB5nRwZ0WCVjEG+IWtVZ9pT6gKJTfvqaAhLJrEys05elI6G8Wkv80yNBttCz+B2ouKWYG2wUuJwx2WF4zjhyz6o1MQg/NUBxby4NqQmfZhoI5EijJ1zP7WKlvtuubhCu0XopSdXuOu1w04O27qFrAbKkG9v6BmMcz19xYz5hrOcc6TlqWMd0t08vbNrZ3yCI22F2yjpbkIHy83yddDKdMz8DTHc9R127osyd9paEOAVHhoAvxd3gg0pqvp0o8P5ZvUnUjZoxMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3JsJi0Fdu67cMrplilxlLgaVdyEPGu7E5J5biFk0tw=;
 b=K+uKGnK0NbPlnPHmUegNJxlHyVJA63ouoYhxD+PGc1L2vZjjbESII+Mo7PK52eqZWmcitVx23aMvw8+cc8rUqZpVK41wlLqAvBnBcQleQnaJPcJ/8DMKj49VHkDNoFctjaxgXSUbPpF3JH8mJrgJUagWINgZJHf8x/fY6fa97cBTdBW6LnI93kbwfeKfDMBu6f74yG9Bwkk/cbqKJngBodvnI0ILPTDy6iHw06E2TRqUq9phw0E/8vra5pGNDtbrkgZL0vbcZUbjpOFeBBXspjfcAMpUltLSqO2c8WVnns42pdX28p5w+rGPp8Kn5xTGJ9mGszp5fh2w1w5Q7omwxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3JsJi0Fdu67cMrplilxlLgaVdyEPGu7E5J5biFk0tw=;
 b=A9hJL81Go/dIwP04tzrr0snJp/MGyHroRENSnVoUWCTjr+/gdqgjrzmqNQQ7PafEZb6JZhDSRWc6isYczcgIE7wOsMjKMp4fbRZkpLDHVTapxAB8oXuOCCUJOcwN0fJlm4JfeZLeRn6CxxIHfNZ1PWcukHnpF2V8e2Xu/WzMw2s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 20/24] net: bridge: switchdev: allow the TX data plane forwarding to be offloaded
Date:   Mon, 12 Jul 2021 18:21:38 +0300
Message-Id: <20210712152142.800651-21-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c96b9ae-98ed-4a51-5113-08d94548e014
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB62718A5B00AE3CEDD3626689E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6iX8S0QATPLlEOXqMun/6F64TpBpuUJSxPXWA/4j+5bm5R8+q8aS1cF27ltAImc4bF7fO97Q3PBVWXD4xP4ozXrUCo2EdNO0NMoGfLq6ZEcuDGrJ/jFmwkY3EGo4GY7mf1Z4P9qdp16sHhrw1OlweW3GN1reKF2qmukVzpVBwgdRmif0s3uo/19kpbEWhCvC7vbAz3B0spA2mvHdCIMN5Bh3Wst9Wx/RnqdD2z5AmNvU4uX69AjJT3ujLg94jA8gX382VQfXcEGmActf6Vk4TVpPyyReuqVvOMPQCAA7squTN3YTuvEtPIwzAVRzgDmng7B9hadWRsd+Bo4+8nKrkt2w0FPRc4ChhYUxqtUFUDMymnXfdiiPGl+5sAfHeszEezQ/ypQFXDFnaqjl4ldDYwv6mCxsKVNyh6TT8BAe4pCXm/lW3qeczsJpA4MM0TPUAVDSIKOT2yaZT2HZSgUu9zVggriAEi2aXLqzu++QzEo6VpJP/KQTNm5kjxbM07hIuAYQMJrAqLPXWxBvfD7NBQZO4r74tYIFVLVqOTMtfC6+tA4eCO9tIMuO5TmczBnIicW4r/Pyjyil31PaZyXCAJ03jYyFvOGkOLACnElx5Ll53qPubI4c3+t6mZZslyg3SWY0ifBh7A8PHshM2yuTTz0ukKo3iRvKoWMEPdfTUptUWoEY8yJBFAvdO3FviEPbO35Po3UnynwNWpsbq/vd/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(83380400001)(66556008)(38100700002)(8676002)(30864003)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nQfy93Z38gJCI2K1U0J9ozAueVyIVIqP3j8jvhBt1hwsO3qPuy/U4xKdLxoC?=
 =?us-ascii?Q?EO+kisCxFIzOMyi/IVbAiISJq1X5SUSwQpZJz5CboGQ/ifU6vZLZ2J5IwKtz?=
 =?us-ascii?Q?f0LkVouCWgiOKBZ8yPbOTAcrDXzHpBujLuIkJrTWNsGSRO8x+IgL+g3U8V2Y?=
 =?us-ascii?Q?m9KIJ8Nv5KKgwKIUBm0pV4TwgSLPM12Js8QO+vcV+L6w/OIr4iW18MH2bB3e?=
 =?us-ascii?Q?alhsx7xNAcIjsBZfOjDQm1vTXJaN4VzVGNjYLWkeTBTviIpLymbkldLBxML1?=
 =?us-ascii?Q?qj+2Gr+FMyP2XmQ0dOqZOUem581BP4rHTIeG2/ZU5DkSDX4xRBjoFXQIwnSq?=
 =?us-ascii?Q?hNZqEcnUB4cDxsY8q2GNuo/5fwPKG1lw+L43QcPRCpSvZ2p0Z4saxgyO2N5o?=
 =?us-ascii?Q?q7NY+myYrg7VuZV1J21xvu6VDYQ47/C/z7ITLkxdmXHrk8/gmte14VFBiGfw?=
 =?us-ascii?Q?wpQjQ+KdBEdT1WmL+X3JyxBLuT/eFPzc7OYBk00C0PV7L94PIjG4POs4zZ8O?=
 =?us-ascii?Q?YF8RLKBLxEzCYeVEdM+9kczQKJLmdLzVnGNHZggvaViQ0TD6th4udA6BhYU7?=
 =?us-ascii?Q?7zHBmVMqTyiG09zWbiQumV9KITqDyfMrJADkAV7LXukbJb+KpXBXX2do0XKc?=
 =?us-ascii?Q?pBYCbXwmaSGOpDiqBNjFtZlG2ruRdpKwQn3h6Fl1Fqv/xk3MR1A3Y+1UTB9w?=
 =?us-ascii?Q?jPf35CJwn6kNrctlatzK7yJiOYVnj+l+lOiaPklNPTjJtsc/hppJr9aOw2PI?=
 =?us-ascii?Q?ovNAJoUsI6/LhTN+nbPUUJWPnB5bWnZpw3NWARqqWmjgiOVLSPwZKdzDzlsX?=
 =?us-ascii?Q?y0EjR8wsS180sRVW8ZOLp2BFkjmeBF2HDkCPbhJYtsgIbNfp5Yh5TaRvtz0S?=
 =?us-ascii?Q?Yytspf4PC/HhS1gz8p+H34FtFUP12HY6P9QeVliUujQ1GsIUR6gad1+BAXbl?=
 =?us-ascii?Q?giWfPEirrYnLIB+UErk8B07Dmh4QdnDW26dc72+9xsLPNNrRLzJWl02Jd+QZ?=
 =?us-ascii?Q?+wdqLDEXq1ao4DqVmz3iwpRTECu7tyISwbiLKwkIRdyD1jmW7sgeiE3eXcLk?=
 =?us-ascii?Q?t7qNAEV3BGcUUl5SstQsrKC1hgwzOf0Kl3AwGXgP4ZWJcsTwfgrJrwOG34Ib?=
 =?us-ascii?Q?bAouXXSKD0uAc39ReP5s4Im/YHFyuRBI/nTR4E7a8Ih75tmfQwtwlRhd6tMZ?=
 =?us-ascii?Q?O5g1X7ZVZ8kw6ZEZqtD2+ITJ7YT7cyiYuIEYE4Co5rHCkklMAHzBBYW5Aj5X?=
 =?us-ascii?Q?zyjt+sbqRaQQTUpzqHasiEMuKv50W6ExCZ63Q9OxvuYIirmwMjtbJiamN6Aq?=
 =?us-ascii?Q?Lf3iBqWtTY8/Ewh3GFuuv+WM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c96b9ae-98ed-4a51-5113-08d94548e014
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:35.0544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zMOR3jNwSbMjNgmAPRGuSpak61nJef8xR95bLP/2OEypA5eiB/r/mSzP1w+FWj53PmOK0l2P4fJsjPouwBKjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Allow switchdevs to forward frames from the CPU in accordance with the
bridge configuration in the same way as is done between bridge
ports. This means that the bridge will only send a single skb towards
one of the ports under the switchdev's control, and expects the driver
to deliver the packet to all eligible ports in its domain.

Primarily this improves the performance of multicast flows with
multiple subscribers, as it allows the hardware to perform the frame
replication.

The basic flow between the driver and the bridge is as follows:

- When joining a bridge port, the switchdev driver calls
  switchdev_bridge_port_offload() with tx_fwd_offload = true.

- The bridge sends offloadable skbs to one of the ports under the
  switchdev's control using skb->offload_fwd_mark = true.

- The switchdev driver checks the skb->offload_fwd_mark field and lets
  its FDB lookup select the destination port mask for this packet.

v1->v2:
- convert br_input_skb_cb::fwd_hwdoms to a plain unsigned long
- introduce a static key "br_switchdev_fwd_offload_used" to minimize the
  impact of the newly introduced feature on all the setups which don't
  have hardware that can make use of it
- introduce a check for nbp->flags & BR_FWD_OFFLOAD to optimize cache
  line access
- reorder nbp_switchdev_frame_mark_accel() and br_handle_vlan() in
  __br_forward()
- do not strip VLAN on egress if forwarding offload on VLAN-aware bridge
  is being used
- propagate errors from .ndo_dfwd_add_station() if not EOPNOTSUPP

v2->v3:
- replace the solution based on .ndo_dfwd_add_station with a solution
  based on switchdev_bridge_port_offload
- rename BR_FWD_OFFLOAD to BR_TX_FWD_OFFLOAD

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  3 +-
 .../marvell/prestera/prestera_switchdev.c     |  2 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 include/linux/if_bridge.h                     |  3 +
 net/bridge/br_forward.c                       |  9 +++
 net/bridge/br_private.h                       | 29 +++++++++
 net/bridge/br_switchdev.c                     | 59 +++++++++++++++++--
 net/bridge/br_vlan.c                          | 10 +++-
 net/dsa/port.c                                |  2 +-
 14 files changed, 116 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 94f5d47bb400..ce7601527e2c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1930,7 +1930,8 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	if (err)
 		goto err_egress_flood;
 
-	return switchdev_bridge_port_offload(netdev, netdev, NULL, extack);
+	return switchdev_bridge_port_offload(netdev, netdev, NULL, false,
+					     extack);
 
 err_egress_flood:
 	dpaa2_switch_port_set_fdb(port_priv, NULL);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 37df803f93a3..d7c6ab3ec4c6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -502,7 +502,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	}
 
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, port,
-					    extack);
+					    false, extack);
 	if (err)
 		goto err_brport_offload;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index e4c4774dbc2b..5dd3ee581bdb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2385,7 +2385,7 @@ int mlxsw_sp_port_bridge_join(struct mlxsw_sp_port *mlxsw_sp_port,
 		goto err_port_join;
 
 	return switchdev_bridge_port_offload(brport_dev, dev, mlxsw_sp_port,
-					     extack);
+					     false, extack);
 
 err_port_join:
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 51ac1c1ba546..7714d1bdee16 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -116,7 +116,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 	 */
 	__dev_mc_unsync(ndev, sparx5_mc_unsync);
 
-	return switchdev_bridge_port_offload(ndev, ndev, NULL, extack);
+	return switchdev_bridge_port_offload(ndev, ndev, NULL, false, extack);
 }
 
 static int sparx5_port_pre_bridge_leave(struct sparx5_port *port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 7b0e38bfc240..895eafdf646f 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1197,7 +1197,8 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 
 	ocelot_port_bridge_join(ocelot, port, bridge);
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, priv, extack);
+	err = switchdev_bridge_port_offload(brport_dev, dev, priv, false,
+					    extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index e629c58fed66..15462ed6ff91 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2598,7 +2598,7 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 	if (err)
 		return err;
 
-	return switchdev_bridge_port_offload(dev, dev, NULL, extack);
+	return switchdev_bridge_port_offload(dev, dev, NULL, false, extack);
 }
 
 static int ofdpa_port_pre_bridge_leave(struct ofdpa_port *ofdpa_port,
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b342a0dcf55e..22f967bdbe23 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2096,7 +2096,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, NULL, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, false, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 6ae0a7785089..3bd9f09e3c11 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1517,7 +1517,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 			return -EOPNOTSUPP;
 	}
 
-	err = switchdev_bridge_port_offload(ndev, ndev, NULL, extack);
+	err = switchdev_bridge_port_offload(ndev, ndev, NULL, false, extack);
 	if (err)
 		return err;
 
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index d3b8d00c43af..f59db1db5123 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -57,6 +57,7 @@ struct br_ip_list {
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
+#define BR_TX_FWD_OFFLOAD	BIT(20)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
@@ -180,6 +181,7 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
+				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack);
 int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 				    struct net_device *dev, const void *ctx,
@@ -190,6 +192,7 @@ int switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 static inline int switchdev_bridge_port_offload(struct net_device *brport_dev,
 						struct net_device *dev,
 						const void *ctx,
+						bool tx_fwd_offload,
 						struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 07856362538f..4873ecdc6f56 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -48,6 +48,8 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 		skb_set_network_header(skb, depth);
 	}
 
+	skb->offload_fwd_mark = br_switchdev_accels_skb(skb);
+
 	dev_queue_xmit(skb);
 
 	return 0;
@@ -76,6 +78,11 @@ static void __br_forward(const struct net_bridge_port *to,
 	struct net *net;
 	int br_hook;
 
+	/* Mark the skb for forwarding offload early so that br_handle_vlan()
+	 * can know whether to pop the VLAN header on egress or keep it.
+	 */
+	nbp_switchdev_frame_mark_accel(to, skb);
+
 	vg = nbp_vlan_group_rcu(to);
 	skb = br_handle_vlan(to->br, to, vg, skb);
 	if (!skb)
@@ -174,6 +181,8 @@ static struct net_bridge_port *maybe_deliver(
 	if (!should_deliver(p, skb))
 		return prev;
 
+	nbp_switchdev_frame_mark_tx_fwd(p, skb);
+
 	if (!prev)
 		goto out;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3db745d49f4f..3cd9c2465d73 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -518,12 +518,20 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
+	/* Set if TX data plane offloading is used towards at least one
+	 * hardware domain.
+	 */
+	u8 fwd_accel:1;
 	/* The switchdev hardware domain from which this packet was received.
 	 * If skb->offload_fwd_mark was set, then this packet was already
 	 * forwarded by hardware to the other ports in the source hardware
 	 * domain, otherwise it wasn't.
 	 */
 	int src_hwdom;
+	/* Bit mask of hardware domains towards this packet has already been
+	 * transmitted using the TX data plane offload.
+	 */
+	unsigned long fwd_hwdoms;
 #endif
 };
 
@@ -1683,6 +1691,12 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
+bool br_switchdev_accels_skb(struct sk_buff *skb);
+
+void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+				    struct sk_buff *skb);
+void nbp_switchdev_frame_mark_tx_fwd(const struct net_bridge_port *p,
+				     struct sk_buff *skb);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1705,6 +1719,21 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
+static inline bool br_switchdev_accels_skb(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+						  struct sk_buff *skb)
+{
+}
+
+static inline void nbp_switchdev_frame_mark_tx_fwd(const struct net_bridge_port *p,
+						   struct sk_buff *skb)
+{
+}
+
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 70d8e30f6155..48b225d83ae3 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,6 +8,40 @@
 
 #include "br_private.h"
 
+static struct static_key_false br_switchdev_fwd_offload_used;
+
+static bool nbp_switchdev_can_offload_tx_fwd(const struct net_bridge_port *p,
+					     const struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_fwd_offload_used))
+		return false;
+
+	return (p->flags & BR_TX_FWD_OFFLOAD) &&
+	       (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
+}
+
+bool br_switchdev_accels_skb(struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_fwd_offload_used))
+		return false;
+
+	return BR_INPUT_SKB_CB(skb)->fwd_accel;
+}
+
+void nbp_switchdev_frame_mark_accel(const struct net_bridge_port *p,
+				    struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_offload_tx_fwd(p, skb))
+		BR_INPUT_SKB_CB(skb)->fwd_accel = true;
+}
+
+void nbp_switchdev_frame_mark_tx_fwd(const struct net_bridge_port *p,
+				     struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_offload_tx_fwd(p, skb))
+		set_bit(p->hwdom, &BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
+}
+
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
@@ -18,8 +52,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 				  const struct sk_buff *skb)
 {
-	return !skb->offload_fwd_mark ||
-	       BR_INPUT_SKB_CB(skb)->src_hwdom != p->hwdom;
+	struct br_input_skb_cb *cb = BR_INPUT_SKB_CB(skb);
+
+	return !test_bit(p->hwdom, &cb->fwd_hwdoms) &&
+		(!skb->offload_fwd_mark || cb->src_hwdom != p->hwdom);
 }
 
 /* Flags that can be offloaded to hardware */
@@ -166,8 +202,11 @@ static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
 
 static int nbp_switchdev_add(struct net_bridge_port *p,
 			     struct netdev_phys_item_id ppid,
+			     bool tx_fwd_offload,
 			     struct netlink_ext_ack *extack)
 {
+	int err;
+
 	if (p->offload_count) {
 		/* Prevent unsupported configurations such as a bridge port
 		 * which is a bonding interface, and the member ports are from
@@ -191,7 +230,16 @@ static int nbp_switchdev_add(struct net_bridge_port *p,
 	p->ppid = ppid;
 	p->offload_count = 1;
 
-	return nbp_switchdev_hwdom_set(p);
+	err = nbp_switchdev_hwdom_set(p);
+	if (err)
+		return err;
+
+	if (tx_fwd_offload) {
+		p->flags |= BR_TX_FWD_OFFLOAD;
+		static_branch_inc(&br_switchdev_fwd_offload_used);
+	}
+
+	return 0;
 }
 
 static void nbp_switchdev_del(struct net_bridge_port *p,
@@ -212,6 +260,8 @@ static void nbp_switchdev_del(struct net_bridge_port *p,
 
 	if (p->hwdom)
 		nbp_switchdev_hwdom_put(p);
+
+	p->flags &= ~BR_TX_FWD_OFFLOAD;
 }
 
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
@@ -273,6 +323,7 @@ static int nbp_switchdev_unsync_objs(struct net_bridge_port *p,
  */
 int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
+				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
@@ -289,7 +340,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 	if (err)
 		return err;
 
-	err = nbp_switchdev_add(p, ppid, extack);
+	err = nbp_switchdev_add(p, ppid, tx_fwd_offload, extack);
 	if (err)
 		return err;
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0bde36da0e69..282a5a05d648 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -458,7 +458,15 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 		u64_stats_update_end(&stats->syncp);
 	}
 
-	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED)
+	/* If the skb will be sent using forwarding offload, the assumption is
+	 * that the switchdev will inject the packet into hardware together
+	 * with the bridge VLAN, so that it can be forwarded according to that
+	 * VLAN. The switchdev should deal with popping the VLAN header in
+	 * hardware on each egress port as appropriate. So only strip the VLAN
+	 * header if forwarding offload is not being used.
+	 */
+	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
+	    !br_switchdev_accels_skb(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
 	if (p && (p->flags & BR_VLAN_TUNNEL) &&
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c109c358b0bd..fce02db6a845 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -254,7 +254,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	err = switchdev_bridge_port_offload(brport_dev, dev, dp, extack);
+	err = switchdev_bridge_port_offload(brport_dev, dev, dp, false, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
-- 
2.25.1

