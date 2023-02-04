Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D4568AA65
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbjBDNyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjBDNxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:55 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F75637B57
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ac8MJcAKJEhtazc/FY2cnlavXlukg3sS3xDUNR56woGS0QrxWoQLpPqJdCjp354MljHm+sn5g6zOJKj4ZymGrmZEn2/De2Am9v7Yh1Tn7CUbE/izMk2ZCkb8T5L2bMCu6Dqg3/3yiw7o5z6W3bgn5blxSGsJdiXMqXle7VIbtIJvTnuPYc1ZAgQX04mXvJjFs7w9niP7xAki885SChVUKNYV7slFv+2FhVtZ6HzXHqA0HJ1ft6GRwiz6AB/0ZZxVBnjvxEjUUK2TILvWBclz8FZhZDOq11gy+PA+zM4uEOklNLHato32T6Mzdk/wNmXjA2fHalNJbq5FlzmbUuD4KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m41dzHH4A6TZOgJg4yBTTHMYDS0g6S1wm8WWZ/AwGyU=;
 b=bg29zMtKg4Omd5DD33lGBnPwWCb6YD32rjR6mlTp/gAvR2OEoBTtf5YZr/Z0xW41stp9uDs6Arbnu1xpm9Qo4QA4i4cVMKBiFljdbyiFpRJGt9CmGTr4H0y31RimqmS5mnCRztlF9xkHYKl3v27ztryCbsNjGCnT6lVJ8wgoYBBP5alFDtBqbwV3Mk8kxSrf+l3mKkKmzGhu3YzeXZ8d0fImQeHtUHRPmse4iPXlusFzs1TuvWYVDHNvNG2CXN6jH0BNCUueMgX2R0aIXnd7RIHf8P6/PxDEylgfJW37GOF7Pf/fk+hbBMnWTleEYzPKH4oQ9dfhlyNQXOrlk0i73w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m41dzHH4A6TZOgJg4yBTTHMYDS0g6S1wm8WWZ/AwGyU=;
 b=qXptIb7Z+KqBoJ1Vt2zd/ul+UqGPAZOZVxk60iPm2ZwIICJQVkcmKwec19FO3LZSkfTE/mLKp1P8gfKTgEkum242ExGRsMDFKoamdSA287jnjM5oln9vO8ZGWL8HPB8rwA7+AFDv34N6IfbDUA5GOMmktsory4Rr+lsPGBxv26U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9047.eurprd04.prod.outlook.com (2603:10a6:20b:442::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:38 +0000
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
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH v6 net-next 10/13] net/sched: taprio: only pass gate mask per TXQ for igc, stmmac, tsnep, am65_cpsw
Date:   Sat,  4 Feb 2023 15:53:04 +0200
Message-Id: <20230204135307.1036988-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: ee321b3c-c798-43e5-6eb1-08db06b7374d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UX0IKyJoQ86t1b5oKShtmL4i6ErFRzzBsG80W3snqz+S9n6FXrhZ/jworxnL+eiEHBBT5gcrGn3tayauZ7KyDzyPAlU7FNf7Jk7C289bMnVskKe7FR2QtiHya8EJ6FqpFjUGADzpWK9rDNekwxCqNc5TyO5G3B9DLMEnAc+7Ia+IfrhaZ1rHUq8tNQPvXt2ZBZlu/t9Zdejl/MTSD4wXwEpGtfdBR7UBEwQbyTBjy+PB3E5vqwGBoDNdWoBTTYMkgcWf5MTpa7jNBCoNsK3YgZ2QV+9XdyNW4mPtrtXbrg+HkA13XeCAdEKjjQcxLVAxlGmpXPKRwolclGS90ynBasIQ69Vc4zR3tLSNqRtSbI5mkhTejGWLGgM3WjkNAU68K90y8JD4jSQdoXeUxHjR5WHzMaVzJpzJ7uxhU6VOTFwBu0wSt7CKbmuPEaIorb+jFddS6Vg7UjsMo8rRt1mltYSJQtSehemYiymT4yJAPClaQrmyo7nywVG7ACUjrrAKQ1QAZNS7bJisXctsicVhrDcNDhC9DsCefMsrxWNnVsscreDcemWYDNYezgen+4BY5YmPHV4luO4SqUnAoKOEERCNO6aeFqRx3S4NFdLhXAPbMmk9PF+rPR2n42wzCvCH9h2NJYpekyZTkaPvhPp7vlD62HwgMl/B5kWJVKUJ52Gy13Wfi033Ygk8mx1oIQnjI8qYai9ri9gMmvwZUag3Ds77t/E8eDXyJxO8lGxVZLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(7416002)(41300700001)(4326008)(8676002)(5660300002)(8936002)(6916009)(66476007)(54906003)(316002)(66946007)(66556008)(2906002)(44832011)(30864003)(2616005)(83380400001)(478600001)(6486002)(966005)(52116002)(186003)(26005)(6512007)(6666004)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JAGSfEXl9/jX2cMXjoLOqMsB++4N0wlbdThU9UhNJF5K+ig9mvKLTk3zWePF?=
 =?us-ascii?Q?qLxSOTC55RUNJzqp86yVFzw+pidTxdeVfJwxQ48+9tqYKBJuwnEIOCWYxD3H?=
 =?us-ascii?Q?DB70SmN80BG8Jsx+r5b6hTUik50HK+uyeRkopeRYg2RdQ41/cH2rmp0vFv9p?=
 =?us-ascii?Q?amSKiFxYOWPpTNWV2pFGtge4YA4hqVe3Ze4yRTgwg3la+MwSfQh5KzOXxIFv?=
 =?us-ascii?Q?3iXePXPwRnBy30aAsv0vZnRtV0QJD7qeMtYDYKvn/Gi6SCAEbqfOVCPYZCgN?=
 =?us-ascii?Q?w4Cpl4+vNzxY3qG3Jr0jiDcn2D4NOESybB5K/9mjIDvzJM8AUFtx7HT9nWbj?=
 =?us-ascii?Q?eqiK19TE2zZYtSw1mgtHYIceOnhIpMpDJ44/YPFusi35PZC+FTHVcQuqo9xF?=
 =?us-ascii?Q?7Gppha1uy4NpDnLaPrC6OG9IvrPDVeGhyUa2xH03bXXidJ1zdIQ3xa+nzlJo?=
 =?us-ascii?Q?MYQP+N9sAtmF9li68Mhty9erOaXu0V4uxLRyxHDiKraVMzBDzd0RHDUrPzVo?=
 =?us-ascii?Q?sCLk8Sb8j7e5twK/QJmBeIEBkyynBpPjmhIG5obYULFRPfYHuVuNLdIwszVq?=
 =?us-ascii?Q?etEm9KFHJ5TCrl+gR7CEQLJ5GHfj2RVXyc4TlZ7xWBm79S6op9gK5zxEK1SY?=
 =?us-ascii?Q?lmJNRxnxt1Kk+oOOOZ9TYnvYA7SpadVFug+0L9AwA9bIMTD9r+k7bL0mgoRr?=
 =?us-ascii?Q?buCJe5SXYvZ9PDen7cjauNGUYSMxWNSeIueIlpFdRFF5E5ZK8v/EhpkyGOdf?=
 =?us-ascii?Q?CYP0rb5SJpsX/YuTvZ5PmHRpc1btXoErilHsh3bAHOccVOiYQCuBT7gp+cbX?=
 =?us-ascii?Q?oikdFcJIW50s2KQB80f6QhgsOsM+op8o/niRc5/eaISMC3wqGUMC+0tSjKLz?=
 =?us-ascii?Q?jJQBpnkM5MdSfYg7N3aKTiiKVLD2lJQAzj46uw17BcQ+QP1FH/X6wJKtymx1?=
 =?us-ascii?Q?BnOzK11YRCIMP76DaxJtVpa9SGsMTqlco45saFd8R6RBvP+uppU2lJXLuC/P?=
 =?us-ascii?Q?M4wsqy+9NSK9uly9wt2ZAG99fERE5Xt1jk5HgCf4kcsv3JQctm6xGLeqGmUA?=
 =?us-ascii?Q?r5iFlwXAUzjzVQ+fOD3mlYe5rt2aixZbtinVrBk+01VrMcNJovQTLIcK4dWq?=
 =?us-ascii?Q?5iztGeiVsOynb2Ugu7fgrl0+qpQDP/4/88s2SU3N8zFLgox8CYCc0TXMAmd4?=
 =?us-ascii?Q?jBRYK/OwV4NFQRWbi4dMXsItW2dlM4iVKlAHY1nPKAsip5Co/Sul1TwITJFF?=
 =?us-ascii?Q?kx+aSpWYv6PNUrgXRUavh8NCEf/6Ni46oe0KsB+XnVsBxDKC3RucYzQBTUSx?=
 =?us-ascii?Q?C0gur8OzMeQr6jWLROl+GK51yAyVmd3ArnSXh9zIiMtVUGoZpcdQEIQmF14s?=
 =?us-ascii?Q?meRLW39i6bTwz+f44NW2MtNJfvwVsRCcvyuPz0t99qhb7MtRQxbm4ZYn2Xkm?=
 =?us-ascii?Q?StMFDlmGueCCtPYynlc42/pfk6pRnx41veiLsKi6rTq8cJQQNRsiMVya1nKp?=
 =?us-ascii?Q?FHWBnBQMMckBZGnfCCGfKYKQDkbfArfAo6QsIvumTPN0cdvSUEt7zt3TrFPP?=
 =?us-ascii?Q?fZmMZcwCSNKI62ia+CGSaxBZhz0CPTfq/jwvsVyM2DZDmu+xj5FLZP/G3BST?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee321b3c-c798-43e5-6eb1-08db06b7374d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:38.2316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uz523UxHKYUA4yHj7+3pOmiCMim/woB+K3IlYYuT1Y6qrM9a6F74TSvekQzFa0+qxQ2KNax4r7bainn4dT307g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9047
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
  This definitely sounds closer to a per-TC gate mask rather than a
  per-TXQ one, and TI documentation does seem to recomment an identity
  mapping between TCs and TXQs. However, Roger Quadros would like to do
  some testing before making changes, so I'm leaving this driver to
  operate as it did before, for now. Link with more details at the end.

Based on this breakdown, we have 5 drivers with a gate mask per TC and
4 with a gate mask per TXQ. So let's make the gate mask per TXQ the
opt-in and the gate mask per TC the default.

Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
query the device driver before calling the proper ndo_setup_tc(), and
figure out if it expects one or the other format.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230202003621.2679603-15-vladimir.oltean@nxp.com/#25193204
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6: add am65_cpsw to the list of drivers with gate mask per TXQ
v3->v5: none
v2->v3: adjust commit message in light of what Kurt has said
v1->v2:
- rewrite commit message
- also opt in stmmac and tsnep

 drivers/net/ethernet/engleder/tsnep_tc.c      | 21 +++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c     | 23 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 ++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.c       | 22 ++++++++++++++++++
 include/net/pkt_sched.h                       |  1 +
 net/sched/sch_taprio.c                        | 11 ++++++---
 8 files changed, 102 insertions(+), 3 deletions(-)

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
index 6ddcbc8b7b6a..cf7f6a5eea3d 100644
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
index 1a5b8dab5e9b..f44e4e4b4f16 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5992,6 +5992,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
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
diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index e162771893af..8dc2c3085dcf 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -585,6 +585,26 @@ static int am65_cpsw_setup_taprio(struct net_device *ndev, void *type_data)
 	return am65_cpsw_set_taprio(ndev, type_data);
 }
 
+static int am65_cpsw_tc_query_caps(struct net_device *ndev, void *type_data)
+{
+	struct tc_query_caps_base *base = type_data;
+
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!IS_ENABLED(CONFIG_TI_AM65_CPSW_TAS))
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
 static int am65_cpsw_qos_clsflower_add_policer(struct am65_cpsw_port *port,
 					       struct netlink_ext_ack *extack,
 					       struct flow_cls_offload *cls,
@@ -765,6 +785,8 @@ int am65_cpsw_qos_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			       void *type_data)
 {
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return am65_cpsw_tc_query_caps(ndev, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return am65_cpsw_setup_taprio(ndev, type_data);
 	case TC_SETUP_BLOCK:
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
index aba8a16842c1..1c95785932b9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1170,7 +1170,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    struct tc_taprio_qopt_offload *offload)
+				    struct tc_taprio_qopt_offload *offload,
+				    const struct tc_taprio_caps *caps)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1184,7 +1185,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
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
@@ -1229,7 +1234,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	}
 	offload->enable = 1;
 	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
-	taprio_sched_to_offload(dev, sched, offload);
+	taprio_sched_to_offload(dev, sched, offload, &caps);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
-- 
2.34.1

