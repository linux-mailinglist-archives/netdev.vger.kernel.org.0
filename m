Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325E567CB4D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbjAZMxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjAZMxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:53:42 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2061.outbound.protection.outlook.com [40.107.247.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A044C2B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZjX3FtfdBF4CqqUka5reBO6XWHueKx/QGKBPSTZFhwuwTSHp4KIFlyUwvbXo5etrLlTCXsxPd+f17GISNrpazlnHWqZMTZ8U5zI0pJ+dzxLw7tTRy17xJXpqSSjpCIIzaJfEk+H2hClnoJpVZvTsM4IKRxM20TldXC36Kv4O2eKPF2HgWoQ351VWDvZkYLHna2AMNcbPuxbCpDHmXYAue6v6/BvsU1iZD0k4NpKmWNw89RD5sf9Kn9YdDim6NeEMSxv/OVt+YDp9OG3X/SS3htq3UkIHGEcMnKFzZcdcS8J8gLQfxda4jTM2Xn0DvVBLRIDPuzvX2LQnlGVxRNypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZM5Q78whL98T25i1XGoJiiF0VTcPJpAQH2t7948FdGM=;
 b=Oi3ao4Y44KapSv9+YeZfuu6YSL+b/yXof05cC38f+A8ZRpyykD4tSsh+iBDnJce0gn1kAuI4FaEkaUTHTMbXDe9GMPy1KkwTGtcBv5fihM9axPf/4pagY21ok4abo4YtqzLPM/QMBgcQg3gj2Kyu7iYfQZP9ugbcXUm3Z/B4gK5O8lq9/N4Yqt3HR4y2Y8jTrtXtWJjNWXtnalpi8miNwhyNHVe+ojsGrVmE+3SlPYRjGTNFseawa6eHXUaYgraJiAMu91wXCPuS9Uh8a18bsMnOwOVh9OIbm5Dx3IULMSEgJJQNgTI09qFnEZczrbiZp3UhlvsRk7GGmjH+U1m+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZM5Q78whL98T25i1XGoJiiF0VTcPJpAQH2t7948FdGM=;
 b=NHBcNeoiuIhhmbX+TCmhpNgv6IJN3/qvqXIbZ6uc31UNjg0N4S4VJN2yMeHhDC+6XIRza5qxISvm0nj9K/J2lcONGadqa+jxLk0x5MhCBKxEn1LnVVPPrbzrt+kANYZJh7mfByCJO077qMN69CFioeQjJeRNXQ4+p2t5Uc6m5cw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v2 net-next 00/15] ENETC mqprio/taprio cleanup
Date:   Thu, 26 Jan 2023 14:52:53 +0200
Message-Id: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fa45554-9130-4909-93cf-08daff9c55d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwLj6nmD7YC9ZHASPZs/V6KdhxdTfhFG1c55vZs1DGLXiGSmWArw/FP21P1WR0HVocu6DTjRs2LNXu7/9vrZNDgKON8TmXBVeq667xu/2QdKZ1K2hi5B6QuYatj1AbAeCHycM/VmW3vY7x8HPRdkqCPD25S/o1oqSoIdDn7p3XRiqh0faeng6f31EuiKbU/rZjV36QgUvOjgcDoJ1mOY79AvH28kmYflZ8fVcc6UccPWxak52SjggpKKMx0cd0B9eMFqxjDXCHnnwN8E3Kf7Ye6O3vh0rkPjguIH2E4gWjdVHaCX7cyCUnIaHD7ONHlKGRVS76QITdt5fVd2GhHPXHP4Kqk+Awsf03enqawARU4JTNUz3qkjBdsw9hjJRb6P79DDHcsADnyrPfF09Oi3fb2Pt4FMXX0hGJl9AtcG83xuJdbl1+28ktg2+cj+OUWbfi9uUUrRYrjClTTyb9ICWTa0S8IW5tCnR0nBX4UjfW71GxJ8EnzWpVXcF+xIIeFXFLOJjFVW9GwaR5c2nuBpRlvuHI/VAeYsiIQoW5wDfkDhS3hpMLvbOeuGshiyz64M3BCmZcfl5U/j0gVZQLoQ6mLcLhY4IA8gZPJ/dxYTVe/Qni5GTMylhxcra6N7R0Sx5qdbg/CRMeHe0t7sd6Fap0uHCgZTn2OZvybSsGftI9MEuKuJi1uLqE8ZA4qLizdNA2IRaAMI+bVekLO83Xw+yMWn0TovfEG0l+1mjfJGssU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(966005)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(7416002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/uE35ML5uzZ3ILQy31aXwhMFf9LT1/DnajiviFS6aM7TCnszWQfQAbOrKw0s?=
 =?us-ascii?Q?eTmmJRc8hepfFEr5eSmz/glZr3qNB4eq+B2GzdHiC42RMNSEPO8YRgtm0d3R?=
 =?us-ascii?Q?p/K1nogaXvbeklgMygC51nb+3Kov25STfd7cKJoFAJpDtQT94CDuClOwk3po?=
 =?us-ascii?Q?pXRjGiOZ1jCfNdNSc7qkrgdDvKkL09jFTi4Q6siEmTLnLVzqTBuBUOJ7uB5f?=
 =?us-ascii?Q?FIpexbfwDUUvkSgdU9TNFofyzRSZ1RPTqyLhPuD2a/wvh9Q3S5ppkqUAdyaC?=
 =?us-ascii?Q?St9qok9uApW+TM9fr8n+UIP/JqMbIc+i7KJYn1mTYPhY1Fu5yXRJtGJd5ZNP?=
 =?us-ascii?Q?EnwTJIUWi/TXJsyWQInJ3fsKHzQaXQbEvds8dM0wLDwqZB/DPYwZKC+8/ava?=
 =?us-ascii?Q?fqTMwYvtmui/tfxWHgBKfJV90f29Bu2gZwSJ7seH9B5GcOi1SdVmx7btOVy5?=
 =?us-ascii?Q?0+lHvjo6LYc2A60cFeXFIisJJ2I8j1JGXamUi8MY5IhGMT6kLhnv8FG88d+S?=
 =?us-ascii?Q?CERyU67VpY+zkLpNecNvhXN+8CStbljv2dJaP9zo9QCrR5r31xx0ndxQe9NO?=
 =?us-ascii?Q?URydeEd8a0SaJax7S0HOnB6sfrNLi59STTHwAmWkVodL462Ixf7ZKQHqoopx?=
 =?us-ascii?Q?o9Ei/2DG+Rz7u+WuCkKI0Cv4bMde7B5qDaesZTX606zdWMnnWSox3VKRFoP5?=
 =?us-ascii?Q?hs1AjQxtFjH4y2nupASyNtg74/dn4bL4ZQNMjpIKBKo+ttjoZz+y2BMzty3a?=
 =?us-ascii?Q?xlXNaqjcH4Ci0KRblpSIH91WWxrQPHd9LSwUnyUxy9U+qT1GMJFCmxqUBpzv?=
 =?us-ascii?Q?iMpA+P6YbNhemTtJhMGzcMOMy2c/1AMpfsghF3WOlDFjn3ak9PEzbHSVms+a?=
 =?us-ascii?Q?3uehPdl+SKcmB7rcm41Iv0+a46in5NYrmNf5cXfbS1hx9XKO2b4mPC+5lrEs?=
 =?us-ascii?Q?LTkx+cOYvhDyhnTxlYhbnKr2aZp7B7BePcxmFpsd+/hPBlGw83YYMPJfkgN7?=
 =?us-ascii?Q?Txg7xDCPzbTwd8MyKFY08mGaH1ZHUjNxHbBcx314EKjsYw3GGnZ6BKXNaeOc?=
 =?us-ascii?Q?cxm+l137q4BlvSXfwgQXEeuQh9KTl3SxC+MPeIA07lould4PFrpfr9B8FzxP?=
 =?us-ascii?Q?VgASXUZbH6lZ4zbmhg9viV2pIcorH4xub/ZbTTSwbhFscgNcN6KgDxFJrh9o?=
 =?us-ascii?Q?dBPPxohmAVoXpHiUqSNVddjJ6PRpggyDlLyVqV9KNibou0SsFYbSCcjAwlkE?=
 =?us-ascii?Q?uMaRxXnHoGcerEGrSS0Mk1+HY/LmNto/hk19YAS2xbfwkyxOuBvuDq9lAxQ9?=
 =?us-ascii?Q?9tflQMdu1cUlHHAIm9k68NqT3Vsw+Eqz12dCHRd3Gkjr20JGdR9aaRNk7dKx?=
 =?us-ascii?Q?h1cuUCiudkNUiKQa1MtM+nfoih+9Ftoe4F0gL4dEqrr+kvebIkTrPhXS31/+?=
 =?us-ascii?Q?09j2gBFRu65YWswhSOpKw+bKkyiFIa+tKL2F6rhxnvX11Lcw+85rCNzPtRvR?=
 =?us-ascii?Q?NOGuPP2PR4x0EcSej54+IkPE4xdup/lOkkDtNnLjIGQ0g2mZ3Kf2KCTAD38R?=
 =?us-ascii?Q?YM8Wvbg/01wuPM3QV0HLCKl38mbvPJKDbNNa5B9xXxpeqaRuAtJOM4TUXlML?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa45554-9130-4909-93cf-08daff9c55d1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:34.9875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afW9vNWCvSejK8LJu5KkqsaBBNGipE2pvO6s2mKPMAJxju8YVzRAQZQUq7U6HE9mTQ7tlYHNpp7w4656KWpmsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main goal of this patch set is to make taprio pass the mqprio queue
configuration structure down to ndo_setup_tc() - patch 12/15. But mqprio
itself is not in the best shape currently, so there are some
consolidation patches on that as well.

Next, there are some consolidation patches in the enetc's driver
handling of TX queues and their traffic class assignment. Then, there is
a consolidation between the TX queue configuration for mqprio and
taprio.

Finally, there is a change in the meaning of the gate_mask passed by
taprio through ndo_setup_tc(). We introduce a capability through which
drivers can request the gate mask to be per TXQ. The default is changed
so that it is per TC.

There are people CCed to patches 07/15 and 15/15 whom I kindly ask to
double check that these changes do not introduce compilation regressions
(due to the movement of the mqprio offload structure) or behavioral
regressions (due to the gate_mask change).

v1->v2:
- patches 1->4 are new
- update some header inclusions in drivers
- fix typo (said "taprio" instead of "mqprio")
- better enetc mqprio error handling
- dynamically reconstruct mqprio configuration in taprio offload
- also let stmmac and tsnep use per-TXQ gate_mask
v1 (RFC) at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230120141537.1350744-1-vladimir.oltean@nxp.com/

Cc: Igor Russkikh <irusskikh@marvell.com>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: Daniel Machon <daniel.machon@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>

Vladimir Oltean (15):
  net: enetc: simplify enetc_num_stack_tx_queues()
  net: enetc: allow the enetc_reconfigure() callback to fail
  net: enetc: recalculate num_real_tx_queues when XDP program attaches
  net: enetc: ensure we always have a minimum number of TXQs for stack
  net/sched: mqprio: refactor nlattr parsing to a separate function
  net/sched: mqprio: refactor offloading and unoffloading to dedicated
    functions
  net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
    pkt_sched.h
  net/sched: mqprio: allow offloading drivers to request queue count
    validation
  net/sched: mqprio: add extack messages for queue count validation
  net: enetc: request mqprio to validate the queue counts
  net: enetc: act upon the requested mqprio queue configuration
  net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
  net: enetc: act upon mqprio queue config in taprio offload
  net/sched: taprio: validate that gate mask does not exceed number of
    TCs
  net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac
    and tsnep

 .../net/ethernet/aquantia/atlantic/aq_main.c  |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   2 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |  21 ++
 drivers/net/ethernet/freescale/enetc/enetc.c  | 174 ++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |   3 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  27 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/iavf/iavf.h        |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c     |  23 ++
 drivers/net/ethernet/marvell/mvneta.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 .../ethernet/microchip/lan966x/lan966x_tc.c   |   1 +
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  20 ++
 drivers/net/ethernet/ti/cpsw_priv.c           |   2 +-
 include/net/pkt_cls.h                         |  10 -
 include/net/pkt_sched.h                       |  16 +
 net/sched/sch_mqprio.c                        | 298 +++++++++++-------
 net/sched/sch_taprio.c                        |  72 +++--
 24 files changed, 468 insertions(+), 218 deletions(-)

-- 
2.34.1

