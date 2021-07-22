Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC113D271E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhGVPPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:15:33 -0400
Received: from mail-eopbgr40086.outbound.protection.outlook.com ([40.107.4.86]:15366
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232654AbhGVPPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 11:15:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0JWspTbUuMNaazEf27b2FeGYYwXNoILq6GfxRIALp7kTa2SWHTbcBelvd/3opMYWoYzoOrK8/68Js4G1+KfZqgG+yPxWVcbfPuevLbXo0Sb5k46hWV4bqqPU+OcYUzhvPFRDqRUTki0/NTiJQuhoKzBtDNVbg9t7n8N6NkcdZOoLCCvgJI+L2rsE6R5tq7sZsT+JKtVZcHpRaRw1EXpLjFxxfEPpFXbpUJOCJccpD+hN2gvYvkvI3grBpAtHvZ5xvQIOSOiHuVtPPLaNTDMSWcOcn/azsqEQhK+KPbrrEptPCIWltHdP2dQQXmrmusCbpygo3Wf/9vsUKY+ri/5xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQ0Lgp2ShHFERYxxM/ceeNDHOhJDkW+YYNtp+/AnMno=;
 b=gKI6f1kVPmVVZXPGFY5U5oOy0crtP9vgWJSNyKi8jOBW4gtUTHBhtocoa5V5yNTF6darOdIdbURe5xA1cWteAD2OZRdC7DUbrbf/wpBeyYMxee3PkDbZQp1jbPu/mQkpcfqchwZN6yGmlkUVZc6S8d44BgEPOkTsWc9o0nzYlvohRXziE3qpIQj5VZU4155iTPoaSxoY118pzNvyq306JMeHRPCxtaCGHr1yx6DGZAwVntS2SOi7rQbhh4UuG1kPM1aVSsm8Eo2xeHvDGOmjuSLU2ISGaWx0dglqR3rCSVvBR8uw+YBV+790s4b2s5qIdlVzu+NQJLzngIAGM0pR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQ0Lgp2ShHFERYxxM/ceeNDHOhJDkW+YYNtp+/AnMno=;
 b=TVE8JmyZeT/rKVk7FEGTjRamNRrLutBccXs0m+dlXaZoJT9ApZylmoTwd8q7FVLniEqghxY0xqchiQPvyq+dZlQx5ovQBESIQrOhYbSgaT1mwMtxO0j21RiuoI1nxGfUhYD1rQGNqq4HktYu0pfwBAQsoOsNn/1aJXJQiBO0qtI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 15:56:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 15:56:03 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 1/5] net: bridge: switchdev: allow the TX data plane forwarding to be offloaded
Date:   Thu, 22 Jul 2021 18:55:38 +0300
Message-Id: <20210722155542.2897921-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
References: <20210722155542.2897921-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0099.eurprd07.prod.outlook.com
 (2603:10a6:207:6::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR07CA0099.eurprd07.prod.outlook.com (2603:10a6:207:6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Thu, 22 Jul 2021 15:56:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91038525-9339-43cf-ffdc-08d94d293550
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6639E5D0E3B3400693AEE1B3E0E49@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95wM82zpyPdn+dwAHsuwExBHmtvypqa0TDa+1FRruiJaLgbI5zqmENzuUtPQxjrGUrtdBPtWB6p50kk+cgvferOOn90YA5Lhst9Jml48r8F4hfqFGbCICNbH2+daybUlqoRww5XdCjJcDQL3W8CRbHwZ0cr/ymhvI6dGR/McmFBnT6DUNUpmFMZ7ehZucilLLyiX4RJRA0yRzjPFnmphI5g+C9YlaqZ29ymezcF1u3fvto3bt+p+owFjHOzAYNLa9yS16XqI9tHOafXrxjtTLWqWBrLUdNDpFcFvyNE+H5II624DffJXqNtSX4ZbS4b6Cb4tVH9unBBcJyJ/Uwx7TpNBKuADsEsE8+E5Sv1FoCGCgsIRGZEjQSU7iy9kBbPCWGKoK0KOog+rxCMntJOlDEjfRaCtWFwqf+Rx2I/6ylwE+lzUP1786I40EsMYSIpP5r9uWGXhCKImxmz9NDaSHn+bbCW526gsIfTpCww4bZkgfA7Vljn8GEVnJS7TtmXN6afdYD5D0Jv6aZc9Tcc348BR84Z2mHo29DrOMqjoqoFDH/w82coos0Islodwg96t7lXZsy7x5Scdy9xXuEPtFQR1Hq1LX3tgFkIpoWOuPIFoMalorSyC82OMGs+DjEjs8jLCFI6XTd2Jfzm8IZfEeCn74yfT6mMkGZB6Zt6kWzkGlR6WZAnL8Tf1+ieu9jiZEG2yeRiuSx0DvrAGtRbQLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(110136005)(6506007)(1076003)(4326008)(8936002)(478600001)(52116002)(83380400001)(6486002)(6666004)(36756003)(44832011)(66556008)(38350700002)(30864003)(66946007)(316002)(38100700002)(86362001)(5660300002)(8676002)(26005)(7416002)(54906003)(66476007)(956004)(6512007)(2906002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JJXM6vqQvzXzO2/bpmvgE5eLTZbeIfAFBmRHX46ZMwfi14l6YvxGa1CHa1gS?=
 =?us-ascii?Q?+1121IXUzp8l4orySZMaSSV0e5Yw8J0RPiSoqhxTDORJMinPAxQWamMNij7A?=
 =?us-ascii?Q?LGlai81YBwbvr6LrHCmv4hIGf11ZkRuVvOyNxdeKsDScE4CQpDO4b8P4XtpQ?=
 =?us-ascii?Q?J+eGkUyTVN2JCqZ0DWGvoC6luntVrEreckmLX0GAk56RTljxIHEsQDF50kV8?=
 =?us-ascii?Q?wFxHTGiv0THV9ImUiYVSr5TzzJP1CTwkkqmzuMOvgNy53Fj4RcM8l0OfQcs1?=
 =?us-ascii?Q?cOrN/sNXKTrgUQWNZW6yV4l/xGhElsoIEBDRcdRJuDwu/XFrWQO3Dmi0hQY5?=
 =?us-ascii?Q?ipigFNKMl8LLF/m3jYoPEZyakCgw1fktb/uwQ45YK1nvtP4vZvttm3LtzOKf?=
 =?us-ascii?Q?I7rzO/tXs9rvn3bNnesCseeQxowKS1mZyVWhC2oNeraKfcDpgkXyDvhajT8R?=
 =?us-ascii?Q?bXmhd7lk07mphgPXy8sVoJxIlj9l8Jd4iBWg1WZe9kskWnvKeJoP3cyr9Syv?=
 =?us-ascii?Q?11L1k+qLIgVH4BXiVlCFDEeCQO98iZji+RUasgZBE3PL+t2pSbXfsYUp3hIi?=
 =?us-ascii?Q?TsGNW5QAppksjMChNzXy1vMdrooBd9HuSzqbG6RGoe8bZDD3YLVsCftQTAaV?=
 =?us-ascii?Q?IRl4hQxPFSChOW5rUpfz00+740hJvfM3iPBjx9OU4iaXya+EpHx0UDfhnZEU?=
 =?us-ascii?Q?h35sU1dTLqMM9j5CHewxuS0kSsIssJkd5b7gLfngZxfkw9AyOeLoJK+feQC2?=
 =?us-ascii?Q?LtLSaZkA15pM1grCSkXyYjQ9WtuvMlgCE0pQq8EBNavtTNOhSW+fY/CV0FoN?=
 =?us-ascii?Q?yk9Qje7zujX2A9eqt4lOE69BUdEzCJf/jzRvjjd7uhdSrXW0JEm28D9GHZFS?=
 =?us-ascii?Q?I0EA2r1D73NwjEK6PpHGhT8UfhnTlRgyNO82kn+OydqCPlR09wFwJzUgiQzC?=
 =?us-ascii?Q?JYlquApSzZXKfPZmjBGeNNcgnmY5ETVgdSRGKWGDyBWCm6vnqYYkpAdbeVJu?=
 =?us-ascii?Q?dfzitHRivHBt0GugRw+b2+kGtbFHkyJCbX1FEZt3EEq/o7zog0LgGDhPwnQD?=
 =?us-ascii?Q?M6HDT9BdeH4ZnuCF2P+35mCbPt0mkPVt45S2VHfV6jzgmLg1yiCc67SNJO5E?=
 =?us-ascii?Q?Rf7YVwl1m8nxDEyHb2X8scr61hFW5lIPY9UM2cOOtxuQPkSTR4gxvYCD0xyN?=
 =?us-ascii?Q?JiWQjVkuCyk3kxqj3Rh9qip4dAM+FMg6pM19qX8ZLntJkFsIqvgRUIU8xSOg?=
 =?us-ascii?Q?QczwSELfINlnHXouIsRoqoj8RXf+/uzPisWUec1S8+qdoKCSvE2j8jNNPXm1?=
 =?us-ascii?Q?wjO2t/jr4ibk3AH9LseS/xr1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91038525-9339-43cf-ffdc-08d94d293550
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 15:56:03.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMdlW6waFOxg6Njxx0NZpv2aHgQcwy/9GQz2bh1ls9UsnCWZKm1OcAyFl/98t8ddBvikUE3nwm3B7D67onGrAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
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
v3->v4: rebase
v4->v5:
- make sure the static key is decremented on bridge port unoffload
- more function and variable renaming and comments for them:
  br_switchdev_fwd_offload_used to br_switchdev_tx_fwd_offload
  br_switchdev_accels_skb to br_switchdev_frame_uses_tx_fwd_offload
  nbp_switchdev_frame_mark_tx_fwd to nbp_switchdev_frame_mark_tx_fwd_to_hwdom
  nbp_switchdev_frame_mark_accel to nbp_switchdev_frame_mark_tx_fwd_offload
  fwd_accel to tx_fwd_offload

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 +-
 .../marvell/prestera/prestera_switchdev.c     |  2 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  2 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 include/linux/if_bridge.h                     |  3 +
 net/bridge/br_forward.c                       |  9 +++
 net/bridge/br_private.h                       | 31 +++++++++
 net/bridge/br_switchdev.c                     | 68 +++++++++++++++++--
 net/bridge/br_vlan.c                          | 10 ++-
 net/dsa/port.c                                |  2 +-
 14 files changed, 125 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2138239facfd..5a09f85b7742 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1936,7 +1936,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	err = switchdev_bridge_port_offload(netdev, netdev, NULL,
 					    &dpaa2_switch_port_switchdev_nb,
 					    &dpaa2_switch_port_switchdev_blocking_nb,
-					    extack);
+					    false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7fe1287228e5..be01ec8284e6 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -502,7 +502,7 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	}
 
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
-					    NULL, NULL, extack);
+					    NULL, NULL, false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 0a53f1d8e7e1..f5d0d392efbf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -362,7 +362,7 @@ mlxsw_sp_bridge_port_create(struct mlxsw_sp_bridge_device *bridge_device,
 	bridge_port->ref_count = 1;
 
 	err = switchdev_bridge_port_offload(brport_dev, mlxsw_sp_port->dev,
-					    NULL, NULL, NULL, extack);
+					    NULL, NULL, NULL, false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 807dc45cfae4..649ca609884a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -113,7 +113,7 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 	set_bit(port->portno, sparx5->bridge_mask);
 
 	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
-					    extack);
+					    false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 3558ee8d9212..c52f175df389 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1200,7 +1200,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
 					    &ocelot_netdevice_nb,
 					    &ocelot_switchdev_blocking_nb,
-					    extack);
+					    false, extack);
 	if (err)
 		goto err_switchdev_offload;
 
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 03df6a24d0ba..b82e169b7836 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2599,7 +2599,7 @@ static int ofdpa_port_bridge_join(struct ofdpa_port *ofdpa_port,
 		return err;
 
 	return switchdev_bridge_port_offload(dev, dev, NULL, NULL, NULL,
-					     extack);
+					     false, extack);
 }
 
 static int ofdpa_port_bridge_leave(struct ofdpa_port *ofdpa_port)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b285606f963d..229e2f09d605 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2097,7 +2097,7 @@ static int am65_cpsw_netdevice_port_link(struct net_device *ndev,
 	}
 
 	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
-					    extack);
+					    false, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 31030f73840d..4448a91cce54 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1518,7 +1518,7 @@ static int cpsw_netdevice_port_link(struct net_device *ndev,
 	}
 
 	err = switchdev_bridge_port_offload(ndev, ndev, NULL, NULL, NULL,
-					    extack);
+					    false, extack);
 	if (err)
 		return err;
 
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index bbf680093823..f0b4ffbd8582 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -57,6 +57,7 @@ struct br_ip_list {
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
+#define BR_TX_FWD_OFFLOAD	BIT(20)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
@@ -182,6 +183,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
 				  struct notifier_block *atomic_nb,
 				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack);
 void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
 				     const void *ctx,
@@ -195,6 +197,7 @@ switchdev_bridge_port_offload(struct net_device *brport_dev,
 			      struct net_device *dev, const void *ctx,
 			      struct notifier_block *atomic_nb,
 			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
 			      struct netlink_ext_ack *extack)
 {
 	return -EINVAL;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index bfdbaf3015b9..bc14b1b384e9 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -48,6 +48,8 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 		skb_set_network_header(skb, depth);
 	}
 
+	skb->offload_fwd_mark = br_switchdev_frame_uses_tx_fwd_offload(skb);
+
 	dev_queue_xmit(skb);
 
 	return 0;
@@ -76,6 +78,11 @@ static void __br_forward(const struct net_bridge_port *to,
 	struct net *net;
 	int br_hook;
 
+	/* Mark the skb for forwarding offload early so that br_handle_vlan()
+	 * can know whether to pop the VLAN header on egress or keep it.
+	 */
+	nbp_switchdev_frame_mark_tx_fwd_offload(to, skb);
+
 	vg = nbp_vlan_group_rcu(to);
 	skb = br_handle_vlan(to->br, to, vg, skb);
 	if (!skb)
@@ -174,6 +181,8 @@ static struct net_bridge_port *maybe_deliver(
 	if (!should_deliver(p, skb))
 		return prev;
 
+	nbp_switchdev_frame_mark_tx_fwd_to_hwdom(p, skb);
+
 	if (!prev)
 		goto out;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2f32d330b648..86ca617fec7a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -552,12 +552,20 @@ struct br_input_skb_cb {
 #endif
 
 #ifdef CONFIG_NET_SWITCHDEV
+	/* Set if TX data plane offloading is used towards at least one
+	 * hardware domain.
+	 */
+	u8 tx_fwd_offload:1;
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
 
@@ -1871,6 +1879,12 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
+bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb);
+
+void nbp_switchdev_frame_mark_tx_fwd_offload(const struct net_bridge_port *p,
+					     struct sk_buff *skb);
+void nbp_switchdev_frame_mark_tx_fwd_to_hwdom(const struct net_bridge_port *p,
+					      struct sk_buff *skb);
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb);
 bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
@@ -1891,6 +1905,23 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
+static inline bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void
+nbp_switchdev_frame_mark_tx_fwd_offload(const struct net_bridge_port *p,
+					struct sk_buff *skb)
+{
+}
+
+static inline void
+nbp_switchdev_frame_mark_tx_fwd_to_hwdom(const struct net_bridge_port *p,
+					 struct sk_buff *skb)
+{
+}
+
 static inline void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 					    struct sk_buff *skb)
 {
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bfff28ede23..96ce069d0c8c 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -8,6 +8,46 @@
 
 #include "br_private.h"
 
+static struct static_key_false br_switchdev_tx_fwd_offload;
+
+static bool nbp_switchdev_can_offload_tx_fwd(const struct net_bridge_port *p,
+					     const struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_tx_fwd_offload))
+		return false;
+
+	return (p->flags & BR_TX_FWD_OFFLOAD) &&
+	       (p->hwdom != BR_INPUT_SKB_CB(skb)->src_hwdom);
+}
+
+bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb)
+{
+	if (!static_branch_unlikely(&br_switchdev_tx_fwd_offload))
+		return false;
+
+	return BR_INPUT_SKB_CB(skb)->tx_fwd_offload;
+}
+
+/* Mark the frame for TX forwarding offload if this egress port supports it */
+void nbp_switchdev_frame_mark_tx_fwd_offload(const struct net_bridge_port *p,
+					     struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_offload_tx_fwd(p, skb))
+		BR_INPUT_SKB_CB(skb)->tx_fwd_offload = true;
+}
+
+/* Lazily adds the hwdom of the egress bridge port to the bit mask of hwdoms
+ * that the skb has been already forwarded to, to avoid further cloning to
+ * other ports in the same hwdom by making nbp_switchdev_allowed_egress()
+ * return false.
+ */
+void nbp_switchdev_frame_mark_tx_fwd_to_hwdom(const struct net_bridge_port *p,
+					      struct sk_buff *skb)
+{
+	if (nbp_switchdev_can_offload_tx_fwd(p, skb))
+		set_bit(p->hwdom, &BR_INPUT_SKB_CB(skb)->fwd_hwdoms);
+}
+
 void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
 			      struct sk_buff *skb)
 {
@@ -18,8 +58,10 @@ void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
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
@@ -164,8 +206,11 @@ static void nbp_switchdev_hwdom_put(struct net_bridge_port *leaving)
 
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
@@ -189,7 +234,16 @@ static int nbp_switchdev_add(struct net_bridge_port *p,
 	p->ppid = ppid;
 	p->offload_count = 1;
 
-	return nbp_switchdev_hwdom_set(p);
+	err = nbp_switchdev_hwdom_set(p);
+	if (err)
+		return err;
+
+	if (tx_fwd_offload) {
+		p->flags |= BR_TX_FWD_OFFLOAD;
+		static_branch_inc(&br_switchdev_tx_fwd_offload);
+	}
+
+	return 0;
 }
 
 static void nbp_switchdev_del(struct net_bridge_port *p)
@@ -204,6 +258,11 @@ static void nbp_switchdev_del(struct net_bridge_port *p)
 
 	if (p->hwdom)
 		nbp_switchdev_hwdom_put(p);
+
+	if (p->flags & BR_TX_FWD_OFFLOAD) {
+		p->flags &= ~BR_TX_FWD_OFFLOAD;
+		static_branch_dec(&br_switchdev_tx_fwd_offload);
+	}
 }
 
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
@@ -262,6 +321,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 				  struct net_device *dev, const void *ctx,
 				  struct notifier_block *atomic_nb,
 				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
 				  struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
@@ -278,7 +338,7 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 	if (err)
 		return err;
 
-	err = nbp_switchdev_add(p, ppid, extack);
+	err = nbp_switchdev_add(p, ppid, tx_fwd_offload, extack);
 	if (err)
 		return err;
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 382ab992badf..325600361487 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -465,7 +465,15 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
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
+	    !br_switchdev_frame_uses_tx_fwd_offload(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
 	if (p && (p->flags & BR_VLAN_TUNNEL) &&
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d81c283b7358..f2704f101ccf 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -257,7 +257,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
-					    extack);
+					    false, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
-- 
2.25.1

