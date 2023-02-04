Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20AF68AA5C
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjBDNxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjBDNx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:29 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230E3AD01
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIN5eA5tChG7BHsOtwQ4UQw5K7j8dZ/A76HESFT9T97mPB2apTG3iXAA5eTRtYhEUb8X4V45xHSCGO9JMKYWKFdh1a864UCyblLtQvLkk5lvKGxXo/4i6lmPkmXH6Ht78MzuCbgiAxe+4ui94tsEmDBUtXSeCmoFvobKqVsdnMyKoXdwlKG+lJ72fcbUhWH/kIfkmneTyve0tYuCIWy9IUahd9E7KgGf6UyHtDQIuIq4fXxepPGR0kU5XIW0wZ5LFSyO5EA+PsoFG7voF4KCQ1FbXR4dt3B0vxzEQe1kfC+3RW9iGsQTR/wryEUm2f70YTrZ270XpsVvl00n9VLkoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+g71ksEdwb2sOoT019uajyrDTNKbrCPgUgMcpUiXV1w=;
 b=TdmpTFpDhI4ZU/oRuXiqxqJfoA90Z5Hpo8oLBfIJd8rO2hdwlPoxo05H6IqTQR7A//GIQ1c5Ymb1+EM3uXn5AoujpInRUS1xDaLDb14/Ul0PnB7fETdytY1Na5XPLt6EjbwWl/K4XhdCa0XntSnFGhtEJ/V7CSNhjxBrYyx3YlKCsyMH5NOUFNx+EYVl1+EXA1Vg6kcurloe+3nW9U5u8cH1K9JYrAXTihPvLlrR+l5tb1WUD4XVyF899IdXKEoLFCZgKYTphW7UnjY7DfV3/tXlRt9DGVvGh+lf0olIuCE4VJPpxsp8XP54ctMKfVezzMrdwISTH7hQD8MeC7p5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g71ksEdwb2sOoT019uajyrDTNKbrCPgUgMcpUiXV1w=;
 b=pTc3vtQ+hIaX9/lChYDvpPMDxBuaNM5u31tNV0sZZRI7GvxCclcV436GOnMHmaMQIG9IRn06uHxFmloy1hta17Vj+2c8w7leSsRFMckP648HAGgk5PVq74fsoyBXZQiBuj0BoFQh7ugE+Dp3dgPDJoRDBMo4/OZdxIqmCpU6b7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:24 +0000
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
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>,
        Igor Russkikh <irusskikh@marvell.com>,
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
Subject: [PATCH v6 net-next 00/13] ENETC mqprio/taprio cleanup
Date:   Sat,  4 Feb 2023 15:52:54 +0200
Message-Id: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: d8124303-c265-4524-577e-08db06b72f14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cg4aO/AiVaNdCVWW9LgsCoGGcAFASF3Hs61ddWC40DGku7YN17EHzD3PLKl270v4chHp/7eoutjFqloC3gIz9ZtHOVHT6/o6fSVooP+FPe/LdL4uiAJ7CIcfPEI4Cis2AbhwL5e9JOREcoNoOUxw4ZEudBgfTgyGCCNclpU7UXlU26QmOD4J3H3XfV9QhvEkVIkArzF8+efyPcURWgtgpIdvb3qzxJOAgz8Qlfe4ap06UVvcfZKp8HW4znKaqDe4+M5a92QhA/qOxqBfgnSUu9BkVMbaq7Vb3eHCjsr6JwDJwnI8ZHJtYvL06kYgL3kaS2Brv3SBG7Bu7YKuxtLW1Y1tWzROB1f1Ytz7ibk4OyVTzsHltliry7TtKyRUdUAfkh1wTPLYweXOqiDpVf+PFfKpQdgfgrr7/k3Q/tnCefEFjeXtdM4tysxK9jfd33VispWBvdiIDf3zeC52JivSv3Emq9be07NKxYQQqobqdFhRvd/79LDYWpXaWNKk1/7xgMRorgJytDnYwBPGIWXc51oneQTH23TPHddEYlaOzNAOKGmS9nzgvB4LythtvfnwbSL7JdBfqUxEGFCJgjcCuLqxTh8xkdNysKOvkJSHoWdFLikKlwAUgaGynLyw5P94OBdidDZ7NAxzh7r5xMu4LXkS0GEx7ZuV5ewzi4JkctKPbODXRH2Zkf16+2emXt2QR/tFDAbQtRcDw9qE2ojcATPYgA1BiFr7p4TgLMzJsTqBtvVLDdRrQ1QFZXapaXKlNzLu2BxEXSu16OfLHHCqkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(966005)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7VKG3CCC03HYDTAx3RlAHiw7frNjh2KA3q7i2C11ZH1Hp1WIwVHIAprmmvQQ?=
 =?us-ascii?Q?y5AivfXvTLeypZxvYLJCZ7FtXfu1CpN08FExhI2IV3Fi48SFThDhyKeJ1fYt?=
 =?us-ascii?Q?G7U9j6kPP+A8ppLHcMTb3KMraMSsO6wkaDoKeCDpYfal639nb5OhnzMyKRBy?=
 =?us-ascii?Q?zj5DZqKRngz/iy8jucKuFjgL/IWL93K4lY94Z+JKcjMfln7OCqlQmcTB8PJk?=
 =?us-ascii?Q?j3qZXWKWGgl8OAP1eYyLUpvyPC8OkW7aapq703FJjkHv8pOZD+HkndX6R4PN?=
 =?us-ascii?Q?9IjLIsJMLzB1HVjxGeouHk6bb+OWDDf4Mwk94Kxa6yF8BK4cdO9YKUNszZgl?=
 =?us-ascii?Q?/8thWLtizNsulVlaSocWoWUEOudRYNv8c7KxmDU5L08wTMEY6LkCaBNIyiX8?=
 =?us-ascii?Q?n4juEY7t0WKQR4ZxHj/qWdLl5cNbhfO277ykERHJ0arj4tmbWSZNqsl8jQBM?=
 =?us-ascii?Q?m8jx2nwtKYxoCYKOt79mDSR1uWthC1v02nINpSiXd+asC+8QK3XqNQc7Kgl3?=
 =?us-ascii?Q?2jHgXcLPJwZICdpUrqdjoN5VcAEQCaA0kK4zKBIhxZ3ohOWKCI3JszKvGSrW?=
 =?us-ascii?Q?ADkncts7kdsDRY9pyAQnoMn5vvtduJ7M117M9vvhQwbW9rnpcJgrKQHqVlnD?=
 =?us-ascii?Q?UBDaKjUUZhSpFauZmu6sX3igZyoTd1m70uWsEz0gxLQ0nTYlYkQ+i5CCgBT/?=
 =?us-ascii?Q?vTuWlRf24FuoFpmAqWE0/jvFhe6hDMH6LWdqIi79luffuBMv1slZgF3kwj1/?=
 =?us-ascii?Q?ShRFdIQQtl5W0np+HNRjjSJg57EPMMGncKc8M4m5mFWy2o62WBshwI5oHtQD?=
 =?us-ascii?Q?76Zzn/Wsh9MvPkfi4ch1dddmke9hdrKdjKfmSUTNgEe63QsIbFtZ/dkDNKFt?=
 =?us-ascii?Q?WSkC+YdOaA0zQDtkdFVEBlG8UxE91aCzRdYyAYzK4mmTptk6a064BXQv4m8y?=
 =?us-ascii?Q?shjPCGqhzWEK5NwWlkDLRBnFPbeOjT+2aHU4TCFkXzQIzSW5kVi8GVkQ1Ly1?=
 =?us-ascii?Q?9qMzG7e6oArScHgyiW9OCOmxLsFd76dvZniCXgyKtMsRaDZOLS1iLMJN7IDd?=
 =?us-ascii?Q?QZzkZFjkm+V2iDWLH1JYICyl4gM83bqfNgueWPGO88JUue6ALBzSOszVcAaL?=
 =?us-ascii?Q?K/DXTaxZD9je5VToFfCH1UTMzFALt+w1lBa/oGPCCxI09Cd+D0OQowKe0g9g?=
 =?us-ascii?Q?ZDbLCsYLkMdKPWR4VIYY2amhERC0+9tivnxA+fJQnRVeU/kiZGNOyo4cfrud?=
 =?us-ascii?Q?rej/g31X5KJgL9pEPehdHpwQcysliVl5rcd+KZHPEvLl7Gt4qT9ANH7P8qZX?=
 =?us-ascii?Q?hFr5rcWSwATQKb8dbZGHszVt2zqfZ49zWLeAP5ULc2oEbS5/EUUurN1owS0C?=
 =?us-ascii?Q?SVq6rRbjtP1F5AdjIpkGB/Z+z/dgAfILeqAp5wD5tJ/lcnQ9Ic4nHgBnyaMq?=
 =?us-ascii?Q?jQaBYi8zSVYSPydRsWzNjpqmO6VYY6RkywlsaR96kjQfb3IL5+WAZtlfSRsl?=
 =?us-ascii?Q?UinWkzWH5Vv1FzkZObKDkRswyT58CurTUIjakuNuPLYvXHIrEPdTdWMXFYzu?=
 =?us-ascii?Q?NnwCEjcCZS6DwXFGwtqKh9UsPJLy1awCqoiVqyE/BDTbkxu0AVG4jnmEGLxb?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8124303-c265-4524-577e-08db06b72f14
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:24.5607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkWcNCVB3lC+45XGHOWnxQ7p2fJPL4mTQk7fCj9uEcZw63I68kM6wH8EsoVvr6CYpWqT9/NPLrnYFM6v5C3DmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5->v6:
- patches 01/17 - 04/17 from previous patch set were merged separately
- small change to a comment in patch 05/13
- bug fix to patch 07/13 where we introduced allow_overlapping_txqs but
  we always set it to false, including for the txtime-assist mode that
  it was intended for
- add am65_cpsw to the list of drivers with gate mask per TXQ (10/13)
v5 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230202003621.2679603-1-vladimir.oltean@nxp.com/

v4->v5:
- new patches:
  "[08/17] net/sched: mqprio: allow reverse TC:TXQ mappings"
  "[11/17] net/sched: taprio: centralize mqprio qopt validation"
  "[12/17] net/sched: refactor mqprio qopt reconstruction to a library function"
- changed patches worth revisiting:
  "[09/17] net/sched: mqprio: allow offloading drivers to request queue
  count validation"
v4 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230130173145.475943-1-vladimir.oltean@nxp.com/

v3->v4:
- adjusted patch 07/15 to not remove "#include <net/pkt_sched.h>" from
  ti cpsw
https://patchwork.kernel.org/project/netdevbpf/cover/20230127001516.592984-1-vladimir.oltean@nxp.com/

v2->v3:
- move min_num_stack_tx_queues definition so it doesn't conflict with
  the ethtool mm patches I haven't submitted yet for enetc (and also to
  make use of a 4 byte hole)
- warn and mask off excess TCs in gate mask instead of failing
- finally CC qdisc maintainers
v2 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20230126125308.1199404-16-vladimir.oltean@nxp.com/

v1->v2:
- patches 1->4 are new
- update some header inclusions in drivers
- fix typo (said "taprio" instead of "mqprio")
- better enetc mqprio error handling
- dynamically reconstruct mqprio configuration in taprio offload
- also let stmmac and tsnep use per-TXQ gate_mask
v1 (RFC) at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230120141537.1350744-1-vladimir.oltean@nxp.com/

The main goal of this patch set is to make taprio pass the mqprio queue
configuration structure down to ndo_setup_tc() - patch 13/17. But mqprio
itself is not in the best shape currently, so there are some
consolidation patches on that as well.

Next, there are some consolidation patches in the enetc driver's
handling of TX queues and their traffic class assignment. Then, there is
a consolidation between the TX queue configuration for mqprio and
taprio.

Finally, there is a change in the meaning of the gate_mask passed by
taprio through ndo_setup_tc(). We introduce a capability through which
drivers can request the gate mask to be per TXQ. The default is changed
so that it is per TC.

Cc: Igor Russkikh <irusskikh@marvell.com>
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

Vladimir Oltean (13):
  net/sched: mqprio: refactor nlattr parsing to a separate function
  net/sched: mqprio: refactor offloading and unoffloading to dedicated
    functions
  net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
    pkt_sched.h
  net/sched: mqprio: allow reverse TC:TXQ mappings
  net/sched: mqprio: allow offloading drivers to request queue count
    validation
  net/sched: mqprio: add extack messages for queue count validation
  net/sched: taprio: centralize mqprio qopt validation
  net/sched: refactor mqprio qopt reconstruction to a library function
  net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
  net/sched: taprio: only pass gate mask per TXQ for igc, stmmac, tsnep,
    am65_cpsw
  net: enetc: request mqprio to validate the queue counts
  net: enetc: act upon the requested mqprio queue configuration
  net: enetc: act upon mqprio queue config in taprio offload

 .../net/ethernet/aquantia/atlantic/aq_main.c  |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   2 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |  21 ++
 drivers/net/ethernet/freescale/enetc/enetc.c  | 106 ++++---
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
 drivers/net/ethernet/ti/am65-cpsw-qos.c       |  22 ++
 drivers/net/ethernet/ti/cpsw_priv.c           |   1 +
 include/net/pkt_cls.h                         |  10 -
 include/net/pkt_sched.h                       |  16 +
 net/sched/Kconfig                             |   7 +
 net/sched/Makefile                            |   1 +
 net/sched/sch_mqprio.c                        | 291 +++++++++---------
 net/sched/sch_mqprio_lib.c                    | 117 +++++++
 net/sched/sch_mqprio_lib.h                    |  18 ++
 net/sched/sch_taprio.c                        |  70 ++---
 28 files changed, 516 insertions(+), 254 deletions(-)
 create mode 100644 net/sched/sch_mqprio_lib.c
 create mode 100644 net/sched/sch_mqprio_lib.h

-- 
2.34.1

