Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4333F1D76
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhHSQI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:08:29 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:24161
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230305AbhHSQI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:08:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHV+ENG+KcMuKDAo+cNF529Zwf13LlgPr5mvzfZuuEQx6eG0Is0fRmpGEuwJWp92P0/QWlf6HMAS7C+Y7OFkZBgwhMsjb6IeJ/sj6ImYmLnznMQaFBJPUuzHv2ot0Qf5S3jGN0bvSXKkGxDbt1/gRClxUDYB/WORgXzulMoMZxQ9AOeS/eKquKE/j2iBDpc9qT+ttweZ9Hl80VICPS2aGILrSKZJkbKI6FE4K2esUG8LCa43YP3O80n1X1m23zYJcfJyF8M2PCGOdgKVbF+EKLe9GonPLMVhAvFZauSRBBzWJFqkoU2vpAwLbJv5/sJJ9wqPsCaxOsSG9LmqXHDJew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fS1vNUljl5/8lMDXgwKxSXVVO0W+Um0xsrOmXRczSEs=;
 b=YdqMxlUEwEpY+KFqXK+xlpJ3al6q8dBSuGSXjX1Uo9AV2xVAKkuIXUTEP9w6y/Hq11e7ZZKLzdXT7f037S6XHs1F/8xLRf/2LVWetbqy/ky54hotet0DUWBsWjEGTzseuzsnSDd0N08oqXnT6msI+peiVTdBCYcpTpETXd6D/B64aF/KDgB2uaGRbzmln3iOhVCedfJBtlSnI+HVqqgh7Tz+2cKmtTQoiYFLTnisqXnBOHV8LxZhKbNIOtV/AGIYxWiiG7Qdi2Nuj9uPc6YlUpu7slQZZzHssNTzrdg+9K8QvyuA0ENeM/e2D3Ef0KRRyMQG/vxx+27sM1tBRl4wiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fS1vNUljl5/8lMDXgwKxSXVVO0W+Um0xsrOmXRczSEs=;
 b=mwmQAs2o5xk3WPGQMfzqkDT90sp87zg7zFKhXv1pR+PO0nFUu6Jiyt6upamnEz3qMzd1a4kO0N4odNqGVbLCinQvC/d1ZRVkkGB/GVg4yxg4rElvJ/TzuIDtsOtwvaJCRM+BGERLJTYwPRnJRuP5i7QBHeHeOIUWYwyM7GZHkD8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 16:07:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:07:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE blocking
Date:   Thu, 19 Aug 2021 19:07:18 +0300
Message-Id: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:07:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfef60fe-0dc4-40ce-7b1d-08d9632b7d25
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6269903C3EB2612FD38E8CB1E0C09@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+paLhDkQT6flVrXnVZL3q5TQh4IQU8AkPXVEz2fPECkM6kIEfFccIAVsWUReWPaHiHlpXsS9AaHZx31BvS1povYVB5EP8f5glbesI0W7BTZZS2nX0Ng2DzgvfwEuvEVhDwBHmV9Z2d6VINA8+1Jm8tE2cghF45feDFvCjAMyKQOWczSiFfAxM7RWaQTiUExxQv82wVKP73rzH3Ft9+9No+WMTXTG29Wt6Q4PgY2qGjAghroDp4Znn+7z+LIxs1nsQAnzLfDFm/xam8uWBilqGcUdxXCIepNGj1yYM0yvKwGRIH3lcDNs3dLgbWtIqRcB1b3kSnTThKlZZTMZIpzqmWOX1t23Ylf19Ar1zqeJccgE81/JUESZtakKlv3QRNYF03y1SGKokO/1rEHctGBDldycFVKyqNqTXF2pPTGO0W7oc3ESoPcXUKlMLW3ysaVsspVgoonA+8n6TatDF+L0i+blrXIYnFoN3QgkVCCOePUuCDmRQ/VNfqYZudDc5Ys8KZWwVctsthYaR8o/wNivtOk9IewXcv1whEerexjL17TQ+rxtfi15CkrfZCO78p8TGAz+HYpGf1WUWRGIKvxA1uJO8QS1ndqHhgitEoM7G0TJBXzeoNV7X7eYHVReNCpTZV9bSu3iLAiYeOwZRH/wx/PofLwo6rOcDZ3zq8cfTyVWpVaWD4j9zlld9RIb1vZWYEwnfn4xYzNTTT8FbxGAxp+KadbewwJxUgPwoo00EBvq0cAunKyR6CLZid9cQ4NTEXJKun/Wfs3gXQeO+M5cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(7406005)(2616005)(26005)(6486002)(38350700002)(5660300002)(38100700002)(7416002)(4326008)(8676002)(316002)(54906003)(110136005)(6512007)(6506007)(6666004)(478600001)(44832011)(186003)(1076003)(8936002)(956004)(66476007)(966005)(52116002)(2906002)(83380400001)(36756003)(86362001)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZLy8cRwnMZNRjG9+4XijIUwBkA+68BDhiLURjUCtzgqBkBzHt8Te0pbj0kNa?=
 =?us-ascii?Q?yBtp6i6E5bAMTe1o73rU1nkXhI58Nkojce+3aH8iPpn9OPej23NblDVq0UHz?=
 =?us-ascii?Q?6MqlDFLDsjOtVvCqX0aS1pKwhHZ091tcD77UttmTsZRvb6V+xhY92i8TTQJG?=
 =?us-ascii?Q?tx2igr2JK1ZGv8KDWybpsNE7DU/ac6cwQp1yP77kV9hF0Hv6BABEX+T0VIzq?=
 =?us-ascii?Q?YpbCTuCFCHhH2qgGnZQm4sVltUgNM2elP6mWMMZww8SreJ07l65nEljkdpIl?=
 =?us-ascii?Q?gPEyLR8IsRhnXHTOBlm+e6eY5X7NI6SIY3JAoGTVzLj6teKKx5OwR5cHx1sZ?=
 =?us-ascii?Q?H3UspgQ0/UU4LQmjCyg/+4euiT1eUqNVBD2vHjaIX1cdZrYGXyXDPHkHErQ6?=
 =?us-ascii?Q?kyr+pnhZa34cSgdeUXmkHPOAvd0nFDEF0K23adc8vgrERsjjn2VRUiFFyz+V?=
 =?us-ascii?Q?+hfk5hTW7MEfgKmwXj8NQJEqO7alJ5Ox2gtPGnTeXwH3+vN7WBnlMRV+1E7G?=
 =?us-ascii?Q?JRDg58ywTTiN/ALlFJZqg0bZ06PxNqGt7lRbWEEsDvlSiO/FNOE8iNv+17EN?=
 =?us-ascii?Q?SO7cetVdpzSLir3KEqUPYc5efVCozEOxxOa2j4n1fSmpsR5aCzJFok4pInNk?=
 =?us-ascii?Q?eN4sg+W1cyAbqlomA30Qie6UXd/lFuAT7ouw0WwJu6RieLa1JsrlFX/cu06X?=
 =?us-ascii?Q?Bs/thDAOqFY+ZbJfm/FmXz0fVjY942elq0f3OODVsCW0xCcBq6PwRc28Q1Zp?=
 =?us-ascii?Q?wR2WEn1yoOAt3/GRQfzWDTZuZNrvRx8UtjiJv9PeoeIJCOFnXV8d4rhaLH3c?=
 =?us-ascii?Q?qUR1maGS5MiY7m3nUOlNL1/zFv14Z5Pdhi3s+F1xOzth+0aGOPlzuBU2grk8?=
 =?us-ascii?Q?Nn5ctyCzB8OlQ0pcKuBGOa+XJF4H/DuLqDR3Ck3PDRSVZ7klzGezJvLA6TiR?=
 =?us-ascii?Q?U2DywYyy56Yc28BDJTUteVq8pXuPYt+gQXLEQch/Ky9gTVsXGagQJzztupg1?=
 =?us-ascii?Q?3Nlv3i4z76WVGXOJPcID3xggZP6Ly0FYqtWO9agULAh4X8Ax/mbfFbVfHiTQ?=
 =?us-ascii?Q?SNv6IVCWfwEkpemdAapSJ7dZbkDskleWhc7boyQKTAwpkjlOs9qDyFIXgtl+?=
 =?us-ascii?Q?HBcaCDGbkvT0m9dhPxvOPrb1at4zSC3W2sV2qLUfN5g3DdJM0jmRrlNqNcTk?=
 =?us-ascii?Q?abzMs9yGP1ZYnOT0yKgQB+0k26pGFkQ0qEFmochH+f7H4lRfPcKg5hmauOrL?=
 =?us-ascii?Q?GyLRI30fqNSd+Qs8Nmbh/QkVG7TAYdjM4AHAETtGH4yB+B3Sfb1TXYVVvgDN?=
 =?us-ascii?Q?MVODC4ySU0iPby7l6zHqRSSh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfef60fe-0dc4-40ce-7b1d-08d9632b7d25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:07:48.6806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eopzUFqujEMwGrAnmW2jd7Kxe4oDxhrCZIet6pyR8etNQpZJnDEgjk8mWFYe853QLQ2Xr8Yhwy/xFuNSY0+8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Problem statement:

Any time a driver needs to create a private association between a bridge
upper interface and use that association within its
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
entries deleted by the bridge when the port leaves. The issue is that
all switchdev drivers schedule a work item to have sleepable context,
and that work item can be actually scheduled after the port has left the
bridge, which means the association might have already been broken by
the time the scheduled FDB work item attempts to use it.

The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
mechanism to make the FDB notifiers emitted from the fastpath be
scheduled in sleepable context. All drivers are converted to handle
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
handler (or register a blocking switchdev notifier handler if they
didn't have one). This solves the aforementioned problem because the
bridge waits for the switchdev deferred work items to finish before a
port leaves (del_nbp calls switchdev_deferred_process), whereas a work
item privately scheduled by the driver will obviously not be waited upon
by the bridge, leading to the possibility of having the race.

This is a dependency for the "DSA FDB isolation" posted here. It was
split out of that series hence the numbering starts directly at v2.

https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/

Vladimir Oltean (5):
  net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking
    notifier chain
  net: bridge: switchdev: make br_fdb_replay offer sleepable context to
    consumers
  net: switchdev: drop the atomic notifier block from
    switchdev_bridge_port_{,un}offload
  net: switchdev: don't assume RCU context in
    switchdev_handle_fdb_{add,del}_to_device
  net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  86 +++++------
 .../marvell/prestera/prestera_switchdev.c     | 110 +++++++-------
 .../mellanox/mlx5/core/en/rep/bridge.c        |  59 +++++++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  61 +++++++-
 .../microchip/sparx5/sparx5_switchdev.c       |  78 +++++-----
 drivers/net/ethernet/mscc/ocelot_net.c        |   3 -
 drivers/net/ethernet/rocker/rocker_main.c     |  73 ++++-----
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  57 ++++----
 drivers/net/ethernet/ti/cpsw_new.c            |   4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  60 ++++----
 drivers/s390/net/qeth_l2_main.c               |  10 +-
 include/net/switchdev.h                       |  30 +++-
 net/bridge/br.c                               |   5 +-
 net/bridge/br_fdb.c                           |  40 ++++-
 net/bridge/br_private.h                       |   4 -
 net/bridge/br_switchdev.c                     |  18 +--
 net/dsa/dsa.c                                 |  15 --
 net/dsa/dsa_priv.h                            |  15 --
 net/dsa/port.c                                |   3 -
 net/dsa/slave.c                               | 138 ++++++------------
 net/switchdev/switchdev.c                     |  61 +++++++-
 23 files changed, 529 insertions(+), 409 deletions(-)

-- 
2.25.1

