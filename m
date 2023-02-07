Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776FE68D9C5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjBGNzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjBGNzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:55:35 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2089.outbound.protection.outlook.com [40.107.15.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE81B3A588;
        Tue,  7 Feb 2023 05:55:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJ8oKjWW9HRS8oRYaTuYJWFWx4DDY0lFZVbu7uKKEIY2nNvKU8unGqeGfVYtMxIIjUBARssZcTqF/+tHDwy73hS1sUiFr594Tq/ciEg6K17JlqPZgrZyrCStOFA1AlUgYuG52xsnyfLLE1zKm4/BiRxmPlezHv7o4E8sWmCTv7ariLjDdGlFTf3xgTcA3z/u9e/E0x0FuxO6ovA+84FabgW8ffxQF+rQz8TRcHCuM7Q6plQ9KBmnhpBWePAXkKPVQaue9hE5bvAnZY4o7T2u7h6VUz4+vAnFWCPkPJVNBNyn/PE6uC2MOsm7/bQgO2dUiKFxfRzS3TDKytxdH8kWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpi+uPxsjArsBATRINtYEXihuvppWQAER7BReEFj5bI=;
 b=NpW0OmttSe9RnpMtci4HtA3mov8RTE54q+eMzHBljJG+s9Ok9QeA04U60QcHfYpdiTtxKnPCPWG7Ezgkkcl4h3lSCvv/Bi+w0TFI0Z5I/4C75rFNa0lpswitl1MwZ4+MjoPVHXv3YSMiU0k49xXj1OWnJZG1woLkcTFFgsZZxxxv/T6CWZgzNAG6bin448NDVn7mxcr36HPtAOxPtyn54RG4UKRVWmbFFAxmGbn86sPaesQmfmBxhYzYb6C80fr0bVmr7PTopsfYBE394thP262tpga9TuNYk4sTMgVHc6Zqg7IkSpn1Apja22/33+dXvYUwL2NDulw4A3r+pnzLnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpi+uPxsjArsBATRINtYEXihuvppWQAER7BReEFj5bI=;
 b=q0qRqCGcP9kTugeasaDBRLLOInaub6f63dtMKDLZtAvUXQzK9msxo+kpFYQ31CE62CdU/V0rPGobqN1gRjXwV+nQy/IhcnbUhzxP4NbztEII6rzVnrE710EpNvGkjDcPjer7zRRrQC1UCDQgmkEu94+JMzpQExkLq7yHRlbkcO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 05/15] net/sched: taprio: give higher priority to higher TCs in software dequeue mode
Date:   Tue,  7 Feb 2023 15:54:30 +0200
Message-Id: <20230207135440.1482856-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 6496ea75-9382-4132-4b56-08db0912eef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rlq0vXoCVa+AWqk3HZ+K3gZGUOiqb9B455PpP/Od2sDiWGrAT0e02lNulgWkFnsbQF1qDokGJ6IaG/Tuq31s6BaZeOK17obP2pJlFRWRb7RC1cOUIFJ8YyDWVPWZO6Uj8xSEVKd4/1Hqbon9hnR6WY4y+/pUCW23ctTaDiMDMnqXnKFL1h2KFmeptVIC+zk+YZaq0f4zJ8uCMO0LitCe3KagEffLILzC/c6MjO0uXeaYuS2kzuyMZXaWBmaswExmo0exebQZ8wYE1343dxqUESe/9vr1XbwLhnXriP2yWBc/DvUroixC7MXa+kcTq8aki6IQsRLfQc5TqDDHIdjqXwgH2tZs2dP3zciiiAhFI/vhc6Pb3gH6b6RFotJVS15BftpOCc7s9/wkIu/+6TFe1FxH+esfE0sMs4v4K5Pov4rabRK4u7lxXORSvddzVZca9GAdRfvw7iesLj8k4k1gfsjX/US9pT8J+sdeXzo6aaLcy+LjlZfFd4xpMBunj4fivd/Y9qEZWvZc46pCXiUL/087FJIrVVN+FKDZ2lvzWOmrfYd6VpsWw5cymBIHfcLCA8lUr+Tupqk1PTSR1RF6NR8ZTDgAn3te47D1Zaz3oHKhcEIaZPqggDQirlMoNrd+NBm6KN82AM5m+XqxJtFzmsINgA3W5KVbs4IpcI8qQqlGBvJNFxCgQeqJ2FGLY4XQFK36qoiUQXOFebVfVBlwGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(30864003)(5660300002)(7416002)(66946007)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lO+DcU2w9gE3L4kO5mzwodAroKdIS+tX6zjspffNC36yusXMOpG3BHrJ5UIh?=
 =?us-ascii?Q?1oJ6EXMFHYQjZG2j6gZWxZUiMpRzb6OA3GhwfLLAdGTVrT6saG/H0HFdhBaC?=
 =?us-ascii?Q?W4xdg899SvvgLq68phkMcAvaYhmbBkFrV1f/e4a106VbVY3sdRFSyzV0L87O?=
 =?us-ascii?Q?auJOpZANUGGT1K4E5vVkp05Y+w7HteCbAZLao3vc3pFyt1llZ+6g5zKdjJ9X?=
 =?us-ascii?Q?SiT4j7ALGSATP4x9QLcXQRiBOJ1fNAgDqBOv8Myp0y6SUD5Zon6N5GqA5Y/D?=
 =?us-ascii?Q?weQO8La7jhwj5KDdVfcrclQpwFhEeAN8g7JAPwpEQWYQrtvpBR+zrzOJcZtH?=
 =?us-ascii?Q?Hks3hMa8mmw2JtiN+up7Rb0LDu9p5P3hbIFeW3bgAATci0dRv4trsyBE3vyE?=
 =?us-ascii?Q?nsg8Lmz1ZhJj2l9VqwuldLq2KTVd/UIaL+Ly+5bZr2x4VBV3wI66WiJnhwh1?=
 =?us-ascii?Q?SQIuax9p9CtBlbxbEx0//3x6L+9/e9A3dp/I5FftxFgKV40G5YeQur3Le097?=
 =?us-ascii?Q?Vx0XFsAkjoAM3BGFHdjvV3YWwWjDnTANFhk8m3WeRTecUItxLPpfjSNg91hV?=
 =?us-ascii?Q?eYO5qYq2zTqZMET5DjBqyRcTDUQMT2BxyLp7E1jJ9GFLEwR6HyTM6eGvwSbP?=
 =?us-ascii?Q?yQFu2blB7HswIxhbuirF3vgY1+jJfqAfiap8KIb+5IajzyyLCuB2PGFw7dZP?=
 =?us-ascii?Q?yfXEUpYYrDZn9+qzqNtRYynoKUfCybKtu2kFY7c+CZCmSM4lJylXxNwyxFeo?=
 =?us-ascii?Q?WHWwt0paJpg2lvriZiyCJLpJ4xOIEeV9G0c7SK9RsF1HaDEiqtAcCLsqE8WJ?=
 =?us-ascii?Q?DqUrynH3hyO/gRJCtLLO01Pn//JvJLs5gU9YvHID3/IOP/V0BvjiYNXTPEdl?=
 =?us-ascii?Q?rOU4afGG/em65+7Qae9AAXWm7fw8nI/84z4mJk5USu1dGfxPretczW/jxNEV?=
 =?us-ascii?Q?ef2XvLl/Vu5LIYJiS43MrvdY7iN2LUJG2BCpO1aBRV3U8/giEHupr6VLU+Je?=
 =?us-ascii?Q?5O+2ts//oMz69Sdon5zjEHNsf7fmsvkj2M4kImeIR6OsL/sXqk99/YuRuPbu?=
 =?us-ascii?Q?oq+1MKgdG7zviKvKi1Cf/fWtwvmsf6KLUAWqEghA4BoNbH8J4Yu5kejq88vU?=
 =?us-ascii?Q?EQFDMmGFbsLqvRehXW/faMbxBAYY+8xSM+TIO4j32lAwbWHP+g13hIPBCRoc?=
 =?us-ascii?Q?Z1JWh0Dus472CSitg9IZSk3OxLJuITtgHt8KahIq2TIt8BXwTCRK8YxETv7e?=
 =?us-ascii?Q?kdTZ19QvTKN9WZ8+DOGoza9ZpMRNM43hmFCtJkCGuQcsUMfjD+0uKdHzVmp5?=
 =?us-ascii?Q?VUlcwMrWbQ13sEmSQALWSkJmhaXdwQu7JCfMeF6YMJLSkuj0wEO/mTWDcFwr?=
 =?us-ascii?Q?vrOXpEGqWZPsCPG548NFRl01A7Kv3kmSuVkQvQt0xoCUEVojtXujGZYyByp0?=
 =?us-ascii?Q?PiSpqjURgoehGItDDSdGcgsI1ddD0AsiUqQj3+TbiDjcZDoimm2dADbn6j0n?=
 =?us-ascii?Q?3m2uRhMjcq/udBkUICOxFu9ZazXTC9xaw/GQ1kohRPHYRulK1sSuZmpg0Ilz?=
 =?us-ascii?Q?xSihS0Mupzl1iN6D1AzR+u/kgWNtnmKsGVMMQV+HCsLNgR9AKOB48jBDp72N?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6496ea75-9382-4132-4b56-08db0912eef9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:13.0339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cm0jSkkbn4N/ygIM8/eIwodJXlHKpoOd/qeuhG16EDrlHmHaMzVVdBOZ+6uuBFgNmGIH5VFgNkScSbCGjUlARw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current taprio software implementation is haunted by the shadow of the
igb/igc hardware model. It iterates over child qdiscs in increasing
order of TXQ index, therefore giving higher xmit priority to TXQ 0 and
lower to TXQ N. According to discussions with Vinicius, that is the
default (perhaps even unchangeable) prioritization scheme used for the
NICs that taprio was first written for (igb, igc), and we have a case of
two bugs canceling out, resulting in a functional setup on igb/igc, but
a less sane one on other NICs.

To the best of my understanding, taprio should prioritize based on the
traffic class, so it should really dequeue starting with the highest
traffic class and going down from there. We get to the TXQ using the
tc_to_txq[] netdev property.

TXQs within the same TC have the same (strict) priority, so we should
pick from them as fairly as we can. We can achieve that by implementing
something very similar to q->curband from multiq_dequeue().

Since igb/igc really do have TXQ 0 of higher hardware priority than
TXQ 1 etc, we need to preserve the behavior for them as well. We really
have no choice, because in txtime-assist mode, taprio is essentially a
software scheduler towards offloaded child tc-etf qdiscs, so the TXQ
selection really does matter (not all igb TXQs support ETF/SO_TXTIME,
says Kurt Kanzenbach).

To preserve the behavior, we need a capability bit so that taprio can
determine if it's running on igb/igc, or on something else. Because igb
doesn't offload taprio at all, we can't piggyback on the
qdisc_offload_query_caps() call from taprio_enable_offload(), but
instead we need a separate call which is also made for software
scheduling.

Introduce two static keys to minimize the performance penalty on systems
which only have igb/igc NICs, and on systems which only have other NICs.
For mixed systems, taprio will have to dynamically check whether to
dequeue using one prioritization algorithm or using the other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: keep old dequeue algorithm too, gated by a tc qdisc capability
        (requires driver opt-in) and two static keys

 drivers/net/ethernet/intel/igb/igb_main.c |  18 ++++
 drivers/net/ethernet/intel/igc/igc_main.c |   6 +-
 include/net/pkt_sched.h                   |   5 +
 net/sched/sch_taprio.c                    | 125 ++++++++++++++++++++--
 4 files changed, 143 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c56b991fa610..45fbd8346de7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2810,6 +2810,22 @@ static int igb_offload_txtime(struct igb_adapter *adapter,
 	return 0;
 }
 
+static int igb_tc_query_caps(struct igb_adapter *adapter,
+			     struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->broken_mqprio = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static LIST_HEAD(igb_block_cb_list);
 
 static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
@@ -2818,6 +2834,8 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	struct igb_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igb_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index cf7f6a5eea3d..4c626f756a8b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6214,10 +6214,10 @@ static int igc_tc_query_caps(struct igc_adapter *adapter,
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
-		if (hw->mac.type != igc_i225)
-			return -EOPNOTSUPP;
+		caps->broken_mqprio = true;
 
-		caps->gate_mask_per_txq = true;
+		if (hw->mac.type == igc_i225)
+			caps->gate_mask_per_txq = true;
 
 		return 0;
 	}
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index fd889fc4912b..2016839991a4 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -177,6 +177,11 @@ struct tc_mqprio_qopt_offload {
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
 	bool gate_mask_per_txq:1;
+	/* Device expects lower TXQ numbers to have higher priority over higher
+	 * TXQs, regardless of their TC mapping. DO NOT USE FOR NEW DRIVERS,
+	 * INSTEAD ENFORCE A PROPER TC:TXQ MAPPING COMING FROM USER SPACE.
+	 */
+	bool broken_mqprio:1;
 };
 
 struct tc_taprio_sched_entry {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a3770d599a84..5f57dcfafffd 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -29,6 +29,8 @@
 #include "sch_mqprio_lib.h"
 
 static LIST_HEAD(taprio_list);
+static struct static_key_false taprio_have_broken_mqprio;
+static struct static_key_false taprio_have_working_mqprio;
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
@@ -69,6 +71,8 @@ struct taprio_sched {
 	enum tk_offsets tk_offset;
 	int clockid;
 	bool offloaded;
+	bool detected_mqprio;
+	bool broken_mqprio;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
 				    */
@@ -80,6 +84,7 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	int cur_txq[TC_MAX_QUEUE];
 	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
 	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
@@ -568,17 +573,78 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	return skb;
 }
 
+static void taprio_next_tc_txq(struct net_device *dev, int tc, int *txq)
+{
+	int offset = dev->tc_to_txq[tc].offset;
+	int count = dev->tc_to_txq[tc].count;
+
+	(*txq)++;
+	if (*txq == offset + count)
+		*txq = offset;
+}
+
+/* Prioritize higher traffic classes, and select among TXQs belonging to the
+ * same TC using round robin
+ */
+static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
+						  struct sched_entry *entry,
+						  u32 gate_mask)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int num_tc = netdev_get_num_tc(dev);
+	struct sk_buff *skb;
+	int tc;
+
+	for (tc = num_tc - 1; tc >= 0; tc--) {
+		int first_txq = q->cur_txq[tc];
+
+		if (!(gate_mask & BIT(tc)))
+			continue;
+
+		do {
+			skb = taprio_dequeue_from_txq(sch, q->cur_txq[tc],
+						      entry, gate_mask);
+
+			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
+
+			if (skb)
+				return skb;
+		} while (q->cur_txq[tc] != first_txq);
+	}
+
+	return NULL;
+}
+
+/* Broken way of prioritizing smaller TXQ indices and ignoring the traffic
+ * class other than to determine whether the gate is open or not
+ */
+static struct sk_buff *taprio_dequeue_txq_priority(struct Qdisc *sch,
+						   struct sched_entry *entry,
+						   u32 gate_mask)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
+		if (skb)
+			return skb;
+	}
+
+	return NULL;
+}
+
 /* Will not be called in the full offload case, since the TX queues are
  * attached to the Qdisc created using qdisc_create_dflt()
  */
 static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
 	struct sk_buff *skb = NULL;
 	struct sched_entry *entry;
 	u32 gate_mask;
-	int i;
 
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
@@ -588,14 +654,23 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	 * "AdminGateStates"
 	 */
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
-
 	if (!gate_mask)
 		goto done;
 
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
-		if (skb)
-			goto done;
+	if (static_branch_unlikely(&taprio_have_broken_mqprio) &&
+	    !static_branch_likely(&taprio_have_working_mqprio)) {
+		/* Single NIC kind which is broken */
+		skb = taprio_dequeue_txq_priority(sch, entry, gate_mask);
+	} else if (static_branch_likely(&taprio_have_working_mqprio) &&
+		   !static_branch_unlikely(&taprio_have_broken_mqprio)) {
+		/* Single NIC kind which prioritizes properly */
+		skb = taprio_dequeue_tc_priority(sch, entry, gate_mask);
+	} else {
+		/* Mixed NIC kinds present in system, need dynamic testing */
+		if (q->broken_mqprio)
+			skb = taprio_dequeue_txq_priority(sch, entry, gate_mask);
+		else
+			skb = taprio_dequeue_tc_priority(sch, entry, gate_mask);
 	}
 
 done:
@@ -1157,6 +1232,34 @@ static void taprio_sched_to_offload(struct net_device *dev,
 	offload->num_entries = i;
 }
 
+static void taprio_detect_broken_mqprio(struct taprio_sched *q)
+{
+	struct net_device *dev = qdisc_dev(q->root);
+	struct tc_taprio_caps caps;
+
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_TAPRIO,
+				 &caps, sizeof(caps));
+
+	q->broken_mqprio = caps.broken_mqprio;
+	if (q->broken_mqprio)
+		static_branch_inc(&taprio_have_broken_mqprio);
+	else
+		static_branch_inc(&taprio_have_working_mqprio);
+
+	q->detected_mqprio = true;
+}
+
+static void taprio_cleanup_broken_mqprio(struct taprio_sched *q)
+{
+	if (!q->detected_mqprio)
+		return;
+
+	if (q->broken_mqprio)
+		static_branch_dec(&taprio_have_broken_mqprio);
+	else
+		static_branch_dec(&taprio_have_working_mqprio);
+}
+
 static int taprio_enable_offload(struct net_device *dev,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
@@ -1538,10 +1641,12 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		err = netdev_set_num_tc(dev, mqprio->num_tc);
 		if (err)
 			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
+		for (i = 0; i < mqprio->num_tc; i++) {
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
 					    mqprio->offset[i]);
+			q->cur_txq[i] = mqprio->offset[i];
+		}
 
 		/* Always use supplied priority mappings */
 		for (i = 0; i <= TC_BITMASK; i++)
@@ -1676,6 +1781,8 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	if (admin)
 		call_rcu(&admin->rcu, taprio_free_sched_cb);
+
+	taprio_cleanup_broken_mqprio(q);
 }
 
 static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
@@ -1740,6 +1847,8 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		q->qdiscs[i] = qdisc;
 	}
 
+	taprio_detect_broken_mqprio(q);
+
 	return taprio_change(sch, opt, extack);
 }
 
-- 
2.34.1

