Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29D46817AF
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbjA3RdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbjA3Rcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:47 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560692BF0E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7iauxAV6AxMkKNxfRNqEHScXS0PRODd9JDKg3iWi5tWC0J4KQAcGkTLylJ2ThRRtObKiT7qZ0NO9eD7bV07SWqBjZs95x7W6cSiUnY835lAo9TIS+aTm7QJIoxCUEIkTALGGmpjIJ2y/yssG6nI+h6FIQ88S1D9U93xWzD5pRZw+XzFBqHzzZIH3JfhoAFy7dUrejIXVnwK09ICkMJe6cBlqhqcCpTrHQ/nMxlVFuJoDuetbULRD7DXR9xs6GkvTOUV0Vw2JTOP4EbaitRIRGRKed8e5/7zhH59yrzvHWn3WjIBfui/L3sNgCso45pcTFco+tcPN5hcG7mA1AUWDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PD9d4vU1QP2lFxGVnFPFw/eMxgHJfCC06u4F0eHQDlA=;
 b=UmGbgVmSSfxlDCUJ0CsOV+TO/pQnFKHFLeL+vErOLfVMuhxKqoTGilvTDVupMntrtWH2Qpx4Wmz8Ro6VkedC/6cW740sPV8g7CcRHPhH2zV+iRFDYR3ucE7y2DNgURJVt6h88e49DFHrroX63dRH3BcIFHjfXbPC4DIC+RHdpfktQH3wB9MOL5k3dDJr/gwmbBQyFKATzh3LFrMsBrVoHkpwhfH+SjIcNIuoE9hmWH12ka8uJJF1Z2wlaSW1WcNmlbHyjRYEZuPRR9ckJ1gtMHeP0VwoKqsntHNyBsLnx0Ns3net/WGUg6YATpVNC+/ZLgq+MH1TFzY5igYKAlTmaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PD9d4vU1QP2lFxGVnFPFw/eMxgHJfCC06u4F0eHQDlA=;
 b=P2ZQixoi/pl5TY8Hs5sqWvCJDQW0y3UbNvuH1N4zZluwxJsQqdWiZq5wbcUM8miN8ccaXy7q0wOYjyNDFnaCXlc+BwmAYe5sT5SX/UENVUGvW+BqPocG4Drs75Bj5LPwKKiphlu53kXOgr+wCU+XJ/jvU0/DgoRXdkBx1gEaUwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:26 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:26 +0000
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
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH v4 net-next 15/15] net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac and tsnep
Date:   Mon, 30 Jan 2023 19:31:45 +0200
Message-Id: <20230130173145.475943-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: c1d3455b-7ddf-4648-417f-08db02e7f483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XlEgsOBV7Oogc7WVSn07wKTdaNcTJRteoP2WBRIa4GhpwXzaG0q6kfE0xdwrEPpg7Bv3WePhWw6O/BRLkFtxslxZglKRCKfQ5qmuuXw7zsoQM75OO2QxE5I8xrK38T/VqNQeY6CelvZbEVX6UDYGy8MebAqoYfgVMgcYUIueTK6AQNbwC8dzYxYxT14qx+JP3uHRS2m5FW0RkWqRLlVxEkh8TktNP4rJ4hMeqbGhTN4R3YTEnRQwMmmvYrnpPjxSaZ+jp74dEV301LEzGQLqu/JEuadhnBKNrMvMaOWB76kuV1SctiNSoHs4M21qzdE6YP3o3Kb+YqrLV9ks8jx/71Vty5anAJ2TrHIkj0RSe7xu8WginZJ4yfmZIgThLPF/0WMrxcpd3lFE0ny5ALs8EFKM9qgN3vZHr8cvJb0IOwS+bN0xQKUD/nHJYEF7CfdU6FoFRc3ol1VQF7T5+m0uEJW9b1KhlWS2G/i2EhysjvGmRIkXptG9UvrQoczHd0KYwwDT05Sdw/NUC/KuLEcFnHtQFxZ2so1bsYy121YwMevTYE4vYpuW+Nxc+oILfzRQmoNVeKXt5iLD+6o5lrPH5QnWynj+ioHALvS10dj8SkI8sM3S4H7oP3qFS2RO+1UzGG2hlsFf8gCx6WQN8IFUWyHhhB7HYaMHkFf8BuXKwMKFMOBZCGzWynhDrFYZnUjpyY6v65KYA8G0AKNQ/eUiCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(30864003)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eoMPLfB2wtTqVYwQ4HZnZdlXmZ5xc2+Lk5C/tmRdEUatMOtLRSxSNabYLe70?=
 =?us-ascii?Q?3iSc7irGcwqi7/fUzy/7ZoZeXqao2A4Xd01ZsQgrnjHGT3hH8uQN3b6X1i65?=
 =?us-ascii?Q?J+G3v8pJ1Vp67Z4tHT4iBmUThjutiR2Kq7wi8qe8I3sCkLOJEnNsvfcme7Hp?=
 =?us-ascii?Q?cTGhAhwDF/F+NjEq37G7la9+/e0Liueuf1U/ndeK8rYIZ/wGDw7Nxb9ctc0L?=
 =?us-ascii?Q?uTunKCHs2ISE1rGtTNMpo5G47JYKsvvKhspTbhzgsA3K0JAVqdQDHcAhIPk8?=
 =?us-ascii?Q?D1Nd21LGYKtOy9TxGm70PF4P17i4xudFD7GMxGSgVvtLLjoqavVFk6g3OspD?=
 =?us-ascii?Q?/Gvw9nSCWih29Z86O4/s0sbQ7Wk75idxFoLB92yZYfbaMz1/7zqQRfLznHxy?=
 =?us-ascii?Q?zYvOd2/NXUPPxY/ec+imCyhKHMxntemP7AfsUY/00BKb90TROhyfuOwU8aga?=
 =?us-ascii?Q?WwSh4d0HY1SRPx6L5bLMm7vefp4kuIu7SlvnIys63zYay5TdVKgJ5whbehCy?=
 =?us-ascii?Q?qB7B2wGRKof72nj81jTZ8+WLDrVeCkE8ObrR7duAl5t1xLFdV1MjEe/lloaB?=
 =?us-ascii?Q?QKjPkueRqkrchDCO89zqXixoc209ygSEq6KjcKf5OIZERh7pdBO+qsrtalAv?=
 =?us-ascii?Q?VhyrboD33GaCXduYI5fAAIOVZF9EQQ0JkC+GOJp55kqv/XE3OcAR1aKrgH1j?=
 =?us-ascii?Q?m/EBvilzruDqR1pIaHEHtVRJGxk49KPJ0hXpobQyzViYb3N47yZqZ7BPth0S?=
 =?us-ascii?Q?FeaD6IlU+43n0DECmSbspdytLTH47HmHqs62OgHBYVOWR7pc8PTIw9dumjoW?=
 =?us-ascii?Q?02LunPIzRHowpvfel6qnCG4fK8Ttd+R1X89GKqiGZcsioOcUw/KgwYhX3zD6?=
 =?us-ascii?Q?/1xTI6XeYmqXA/3mqIyU5OHyHo2ZVRFg00HpJPs/gh9RoVz4GWK0vLThkQ5X?=
 =?us-ascii?Q?0EIAKLCcPJCOQLpSNBJEk8uDpsYxIZ9awHZI+kuX4/vQoOLopvGZNkNSkdk9?=
 =?us-ascii?Q?uUNmnnBwfFLZ9HeZsgh1cJsiNOeadZJc9R8BCNfcj1TXuaPcJkHjy7kgof2P?=
 =?us-ascii?Q?6fGs1iFMx3w6gygsdi49U/Q2j6j5QYDPucFLhoMRsqN01Se8pwfoAnvevaKU?=
 =?us-ascii?Q?+MNiwu/T+3mu2o0C+FuAsf3i1dhRqJp4teJJ6Vln9lxAvhFIK7xeagj/oMWf?=
 =?us-ascii?Q?9b5DLCi/4Hr9n/6T7TR0S8mb+yHLO6yjhOzFaDAXxX/hwvvfJIu+4AXLSiCv?=
 =?us-ascii?Q?TwCgaI7qCH84SN9N16JGaeGI/ayppo0Gx6hQ2TeRe0ajLXO9B0QLSBrd+OOq?=
 =?us-ascii?Q?vFfcbaX3+KkIRWLE2LaNLFBDlOF00cQwDT9/QrE5NMm+T1XtUw7j0U9CJ4i5?=
 =?us-ascii?Q?EaAiIzwujMytIMM4S5TyIUwX5dl5Mn9ZWD6S9BSb6KNYMK6dm0410edcpsow?=
 =?us-ascii?Q?+/6zQv1O/ARsQbRPWmi4srCJORXd108NHCMbS4DQZgY7MzQfhyzhvm1laK6Z?=
 =?us-ascii?Q?6XfOdZsahD4Gj3p6NDytEauPxm+dZ2d47MmAzi+vv0ntLgEqUnh10UvYbkTX?=
 =?us-ascii?Q?B9UFpAaK8y8b4ak5FuzC9uFEZTSt1p4ZsqdOqOOdXMIIfRbRE1cKqKFNBpXZ?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d3455b-7ddf-4648-417f-08db02e7f483
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:26.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfyNEeJi6C4TAOFwbAx+BJIqUJmGrweHzVb72tj0OW7AXPdlEMUcb9ODj5SzaDRriAy4abljRMqLdd/1GnqFGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 classes of in-tree drivers currently:

- those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
  holds a bit mask of TXQs

- those who act upon the gate_mask as if it holds a bit mask of TCs

When it comes to the standard, IEEE 802.1Q-2018 does say this in the
second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:

| A gate control list associated with each Port contains an ordered list
| of gate operations. Each gate operation changes the transmission gate
| state for the gate associated with each of the Port's traffic class
| queues and allows associated control operations to be scheduled.

In typically obtuse language, it refers to a "traffic class queue"
rather than a "traffic class" or a "queue". But careful reading of
802.1Q clarifies that "traffic class" and "queue" are in fact
synonymous (see 8.6.6 Queuing frames):

| A queue in this context is not necessarily a single FIFO data structure.
| A queue is a record of all frames of a given traffic class awaiting
| transmission on a given Bridge Port. The structure of this record is not
| specified.

i.o.w. their definition of "queue" isn't the Linux TX queue.

The gate_mask really is input into taprio via its UAPI as a mask of
traffic classes, but taprio_sched_to_offload() converts it into a TXQ
mask.

The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:

- hellcreek, felix, sja1105: these are DSA switches, it's not even very
  clear what TXQs correspond to, other than purely software constructs.
  Only the mqprio configuration with 8 TCs and 1 TXQ per TC makes sense.
  So it's fine to convert these to a gate mask per TC.

- enetc: I have the hardware and can confirm that the gate mask is per
  TC, and affects all TXQs (BD rings) configured for that priority.

- igc: in igc_save_qbv_schedule(), the gate_mask is clearly interpreted
  to be per-TXQ.

- tsnep: Gerhard Engleder clarifies that even though this hardware
  supports at most 1 TXQ per TC, the TXQ indices may be different from
  the TC values themselves, and it is the TXQ indices that matter to
  this hardware. So keep it per-TXQ as well.

- stmmac: I have a GMAC datasheet, and in the EST section it does
  specify that the gate events are per TXQ rather than per TC.

- lan966x: again, this is a switch, and while not a DSA one, the way in
  which it implements lan966x_mqprio_add() - by only allowing num_tc ==
  NUM_PRIO_QUEUES (8) - makes it clear to me that TXQs are a purely
  software construct here as well. They seem to map 1:1 with TCs.

- am65_cpsw: from looking at am65_cpsw_est_set_sched_cmds(), I get the
  impression that the fetch_allow variable is treated like a prio_mask.
  I haven't studied this driver's interpretation of the prio_tc_map, but
  that definitely sounds closer to a per-TC gate mask rather than a
  per-TXQ one.

Based on this breakdown, we have 6 drivers with a gate mask per TC and
3 with a gate mask per TXQ. So let's make the gate mask per TXQ the
opt-in and the gate mask per TC the default.

Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
query the device driver before calling the proper ndo_setup_tc(), and
figure out if it expects one or the other format.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
v3->v4: none
v2->v3: adjust commit message in light of what Kurt has said
v1->v2:
- rewrite commit message
- also opt in stmmac and tsnep

 drivers/net/ethernet/engleder/tsnep_tc.c      | 21 +++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c     | 23 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 ++++++++++++++++
 include/net/pkt_sched.h                       |  1 +
 net/sched/sch_taprio.c                        | 11 ++++++---
 7 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
index c4c6e1357317..d083e6684f12 100644
--- a/drivers/net/ethernet/engleder/tsnep_tc.c
+++ b/drivers/net/ethernet/engleder/tsnep_tc.c
@@ -403,12 +403,33 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
 	return 0;
 }
 
+static int tsnep_tc_query_caps(struct tsnep_adapter *adapter,
+			       struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!adapter->gate_control)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
 		   void *type_data)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return tsnep_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return tsnep_taprio(adapter, type_data);
 	default:
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e86b15efaeb8..cce1dea51f76 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6205,12 +6205,35 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tc_query_caps(struct igc_adapter *adapter,
+			     struct tc_query_caps_base *base)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (hw->mac.type != igc_i225)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igc_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 592b4067f9b8..16a7421715cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -567,6 +567,7 @@ struct tc_cbs_qopt_offload;
 struct flow_cls_offload;
 struct tc_taprio_qopt_offload;
 struct tc_etf_qopt_offload;
+struct tc_query_caps_base;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -580,6 +581,8 @@ struct stmmac_tc_ops {
 			    struct tc_taprio_qopt_offload *qopt);
 	int (*setup_etf)(struct stmmac_priv *priv,
 			 struct tc_etf_qopt_offload *qopt);
+	int (*query_caps)(struct stmmac_priv *priv,
+			  struct tc_query_caps_base *base);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -594,6 +597,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_taprio, __args)
 #define stmmac_tc_setup_etf(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_etf, __args)
+#define stmmac_tc_query_caps(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, query_caps, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b7e5af58ab75..17a7ea1cb961 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5991,6 +5991,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return stmmac_tc_query_caps(priv, priv, type_data);
 	case TC_SETUP_BLOCK:
 		return flow_block_cb_setup_simple(type_data,
 						  &stmmac_block_cb_list,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 2cfb18cef1d4..9d55226479b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1107,6 +1107,25 @@ static int tc_setup_etf(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int tc_query_caps(struct stmmac_priv *priv,
+			 struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!priv->dma_cap.estsel)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
@@ -1114,4 +1133,5 @@ const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.setup_cls = tc_setup_cls,
 	.setup_taprio = tc_setup_taprio,
 	.setup_etf = tc_setup_etf,
+	.query_caps = tc_query_caps,
 };
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index ace8be520fb0..fd889fc4912b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -176,6 +176,7 @@ struct tc_mqprio_qopt_offload {
 
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
+	bool gate_mask_per_txq:1;
 };
 
 struct tc_taprio_sched_entry {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a9873056ea97..72271bf8cd8b 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1217,7 +1217,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    struct tc_taprio_qopt_offload *offload)
+				    struct tc_taprio_qopt_offload *offload,
+				    const struct tc_taprio_caps *caps)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1231,7 +1232,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+		if (caps->gate_mask_per_txq)
+			e->gate_mask = tc_map_to_queue_mask(dev,
+							    entry->gate_mask);
+		else
+			e->gate_mask = entry->gate_mask;
 
 		i++;
 	}
@@ -1295,7 +1300,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	}
 	offload->enable = 1;
 	taprio_mqprio_qopt_reconstruct(dev, &offload->mqprio);
-	taprio_sched_to_offload(dev, sched, offload);
+	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
-- 
2.34.1

