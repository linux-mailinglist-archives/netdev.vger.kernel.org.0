Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C44C633D29
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiKVNKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKVNKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:10:51 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on060c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::60c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5911013F42;
        Tue, 22 Nov 2022 05:10:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMUYV2uzcgrIjNtY0WKVlyfdDSWqX/t60ZSjC9dc09IvuiwRhEMusTntlQ+xlJcsymaopRtK/DT1mdtEfOTNY6eTzuwbb+HDHPQ6uz7sBFvEWjE7rywZL15WSooocDuLbx5kSrBwyddchzUMYDcxrjP9HZCqk1Mcl4oEY3bfq0Py69CkQBgDwtu4wxkRK5SwPEp+cVS9eYulY+zCq6F0sraSP1DMLkZoXaOB7zRb80XS1mAEl5l8ilOJYC6GGeapEKJW+6i9EtO9iFz4yEJ8f5GV4BsHHKiz24XRioHdQBLOmcrYQ6qlHFS/2OwCcBOw+xAEXXoaBY1LUYydM9XH9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pilCjfNoEN0ona8D5ktY0pwQk/BNrpnLISQymw+qJ0=;
 b=ZqeyBMZv9Xre44SgS7ROuDTewPhzZ8ywa+jwElkF5wrSSQuNyWZgyJkBgqkKfg81sNdYqk2p7VAPE9TRWmPVcWTXP69JyHb22jOL+hOX/SbRdN3lEI9pk73bzzQ+7qLholErXKiBiy7VHBBw5nk7v2eooAgbRmdH5uQ6dv4R+WkBS/6MYmR4dc20QKw7TJOjFCXfMfmknQW0pNUCrPJ5MXPWcG3uzhyJeTNHIGhcMVH2bTj86SQ8lrmqgHFLVaPxd4Sqge/GbFPOWGU9IF5r8nZkSs+FraD2CS7fjrliySHkGy/RPojYlndavpEJVZ33mNlV4bY8NzFfPBR2jrm/NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pilCjfNoEN0ona8D5ktY0pwQk/BNrpnLISQymw+qJ0=;
 b=DZuwNaIzuJxQOe+Kf/hJl9iOvv+y4HIObjtK4YLFkTp4lUq9OywgBJJPApz2tDkD7ldKW7kzQhV+vAxwNxaoSGNy7xyxPgTlWetOopCUWIagwc2LtpYs/hwYQHDgMelr+jzH+Ed+PD/szzmSzq71EcpoawtkfuKz4e9Op5RYhsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB8030.eurprd04.prod.outlook.com (2603:10a6:102:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 13:10:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 13:10:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: preserve TX ring priority across reconfiguration
Date:   Tue, 22 Nov 2022 15:09:36 +0200
Message-Id: <20221122130936.1704151-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0004.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e4ad879-334a-40cf-4bcf-08dacc8af6e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1eZRAf5ecEtGzDoLyqCGZGgcyny82KgdX9lKJ9zDWmJFzPOjkdc55dkhgSfOVNcd9VwplRZn5urp8RZ/W/x5pIRgl7mEqMLRPqdcxH9WNxq+4ucjnE8cWzp9WDwPy0/wINiP1QC/3G8Fzfncwvm//cpDyPM64OrNzIDhsfM5v+WWs+moRghUwdvDPlv+xISayv14ruIcaFs2C6sQXdsn1eRexcl+T5unV7URM95dKq9qMKajkGaINS2Uh5MueuFf0cA4vSx0a2zcR0fh8G+iWUcidhoM3cpnnLPglHx7VuWXDt0mTHDFp7QmofHbk0Sxb3cduXn1L1buQQl66SeOmR5lXyIvmRex3iJRsWegtHvJSEYii/90IqsLaiZ/9Np9DiODsK6/fPcRy5VvnZ7eJHhJj0+DgSZDWDi7453ZWx9qnD9gzfnwpXCxEBX+GA+lthqCr172oUAy8+YiODLQKOqYhq6UUVUePoxxC3tsQVtbNpXvcbmQcY2cNUElwCiVX3s238k+KunFgyK2fu4FyCsZG4a5zSk7kKXu3l8YKUCn6No1/qU/zeIHbByfs8ImJW8H/kj5DN1bt+gfcO8HObdfoBjQFCGLkxtNLk2zu8tfVvKuYMd3tdWtJ6h4C6BZqF7VrYKFn/av6ziOclNxyUzOxnsbZbkbMS8dFDbIOZiezWweyTcktcalWopIkPW9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(36756003)(86362001)(52116002)(44832011)(5660300002)(26005)(2906002)(38100700002)(2616005)(186003)(83380400001)(6512007)(1076003)(38350700002)(54906003)(6486002)(66556008)(6916009)(6506007)(8936002)(41300700001)(66476007)(4326008)(478600001)(6666004)(8676002)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WXMy0CtI07Uk+rW4BCuvXf23FdTDQVZByrd8mKgCq1XGyvLg5rZt9s9VVPGj?=
 =?us-ascii?Q?A0EWD23UheNzEkfeXFIVwsvUEFk0ndbm3d+KK6qkr3bzju9Zt3dqb6pjb/NZ?=
 =?us-ascii?Q?x8zPhlyDehEuiwqaxQPo+jv06ZyiqYfDZtko7RoK4wGa5LHIn34FVN/rGTDB?=
 =?us-ascii?Q?IdVx5P0vUI6RcoO4GqiW7UDhZn7qMg+wYZDarU6qmX4XNlqLiv6FH6l0L7mg?=
 =?us-ascii?Q?0GugrcvpwN9obmoEe5/Vj6d6OnxVBmNYCy02IjgcDrxllgWhtCeP/HAoaQPT?=
 =?us-ascii?Q?buGXk/ofkKVcu0fGi4IbExUwnbcruk1fMBgxVzKpPzTIwzCsGnleHeaqiiFK?=
 =?us-ascii?Q?440dtQe0DahP37byjyX5VkyuMUtM8oQRiz1Yz0Z3Sz5Gzz7eP63uf1I+hbPt?=
 =?us-ascii?Q?xqKVH4fGpS/DVI1VMaZ6Pr0+QTYvnjwROGkz3jOdjSll4BNhRV+ZzKsIRsU6?=
 =?us-ascii?Q?L2NWRGiR259oGigUpM0dRtqQ+ahKYqhHrjPq+8dte8q2vfECklSrM2XLQZjC?=
 =?us-ascii?Q?ynfRHzwCklwbe1ixQNyW0VYTuDEdCbeIS7DzD95RQtS1mvOIbLDhgT3u1A0K?=
 =?us-ascii?Q?x/UBhEJRGpZybapnC5qCWckeexptY3V5vQwooGoXhMymLJWFnbslRwFRJWeg?=
 =?us-ascii?Q?zQKuOs9Kqt1O7cinZfKlxotzE4wlF1iXs7i/e2gekBuarox6lG8uWmq39mpy?=
 =?us-ascii?Q?ISnukoQ9kldNHe7mc7ql9YGbeYey+p47YSCfF19piY4NXLlwnlZDLYcPzR+w?=
 =?us-ascii?Q?Bk6PNCEtVJS85sJKu9udUmBB3j/3Yteg0UkYHvPhT5znGGAO0aShfW4TqjpN?=
 =?us-ascii?Q?RmbxWoISQG/NbInAeFpfIRZRBB5ZiLB0d4LGuICXJooCTz4NzBWBOhubjqla?=
 =?us-ascii?Q?3peSy8ScM1YRnY6R2rBBbKSedRY9QQmkZAnzWJNuf4c2ny1tj4xi4QgMk53i?=
 =?us-ascii?Q?GH//zH3CJa+PP8QZqWDnp3jmCcbRbcYWTuZG+oKn60EOGeNsJI1ByIKtXukQ?=
 =?us-ascii?Q?fN7ite6NEcsxU8kWkBfdctJcKduj+RnxtcoMBxSqEmWWl9hD6TiCR8c/yx9o?=
 =?us-ascii?Q?1F7je63YyQMdTKRM1Yz70sb1s8RBDJe8lOB3E087p8oZ3fd451hbbAxp1BvG?=
 =?us-ascii?Q?70QG653Wp4F02EfdyGzUrfGRnhvbqlNQ/hQ9Sh6+Yw/jhHoZHC81VxA8tug4?=
 =?us-ascii?Q?mmuffp/MkShq5YSJs7M05RgGqKJSctK3+XTESz7GP+VOl+AhVzTQ9KY27nbu?=
 =?us-ascii?Q?iZm+wbefgzh/yoaOlGzpwi5013eva5fSOxticBqNvFfp2pEO0jlw/ENqiJTB?=
 =?us-ascii?Q?Nt9NVQxkXn3wIui8/qWTQxdCv2xuYMSmcYXxL99zO13UGkGKeJoRyzOAAkr+?=
 =?us-ascii?Q?Px77gXHV6kxBj6TX/zQndqnK/rpkqPjE4nixGLLjVRtjbx9LyNBJ9xnwzXNP?=
 =?us-ascii?Q?Z6Fr2AMM2pvJmbnTsyiy16OzvQjQQ6iSBIQ4w6e0nnTbMNkW/pQhi2IV0pvJ?=
 =?us-ascii?Q?twoNfS5RQKHCnc9B/vUxDPFRORgj7jQ5Efp59Tm2cbeHT86NslAztV9bQYH+?=
 =?us-ascii?Q?cisZUyrah6u17mg1qEzS8V9nzKVe3WWYHn6kFDaKqYtrQwVHL6MuqKBjboqB?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4ad879-334a-40cf-4bcf-08dacc8af6e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 13:10:44.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ZoZcwcseY6aTCI6kRNtKGbJdClidHw+z3f1LeTI0tQeT/kzkW2gcozO+M8GovgCxNkpoW6maiRyUio0ch9CqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8030
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the blamed commit, a rudimentary reallocation procedure for RX buffer
descriptors was implemented, for the situation when their format changes
between normal (no PTP) and extended (PTP).

enetc_hwtstamp_set() calls enetc_close() and enetc_open() in a sequence,
and this sequence loses information which was previously configured in
the TX BDR Mode Register, specifically via the enetc_set_bdr_prio() call.
The TX ring priority is configured by tc-mqprio and tc-taprio, and
affects important things for TSN such as the TX time of packets. The
issue manifests itself most visibly by the fact that isochron --txtime
reports premature packet transmissions when PTP is first enabled on an
enetc interface.

Save the TX ring priority in a new field in struct enetc_bdr (occupies a
2 byte hole on arm64) in order to make this survive a ring reconfiguration.

Fixes: 434cebabd3a2 ("enetc: Add dynamic allocation of extended Rx BD rings")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |  8 ++++---
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 21 ++++++++++++-------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index b4988fe6bb93..9c0ab983b6e9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2061,7 +2061,7 @@ static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ring)
 	/* enable Tx ints by setting pkt thr to 1 */
 	enetc_txbdr_wr(hw, idx, ENETC_TBICR0, ENETC_TBICR0_ICEN | 0x1);
 
-	tbmr = ENETC_TBMR_EN;
+	tbmr = ENETC_TBMR_EN | ENETC_TBMR_SET_PRIO(tx_ring->prio);
 	if (tx_ring->ndev->features & NETIF_F_HW_VLAN_CTAG_TX)
 		tbmr |= ENETC_TBMR_VIH;
 
@@ -2464,7 +2464,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
 			tx_ring = priv->tx_ring[i];
-			enetc_set_bdr_prio(hw, tx_ring->index, 0);
+			tx_ring->prio = 0;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 		}
 
 		return 0;
@@ -2483,7 +2484,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	 */
 	for (i = 0; i < num_tc; i++) {
 		tx_ring = priv->tx_ring[i];
-		enetc_set_bdr_prio(hw, tx_ring->index, i);
+		tx_ring->prio = i;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
 	}
 
 	/* Reset the number of netdev queues based on the TC count */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index ea3ceed5bfa9..40bcd68c0c49 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -95,6 +95,7 @@ struct enetc_bdr {
 		void __iomem *rcir;
 	};
 	u16 index;
+	u16 prio;
 	int bd_count; /* # of BDs */
 	int next_to_use;
 	int next_to_clean;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index a842e1999122..fcebb54224c0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -137,6 +137,7 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_bdr *tx_ring;
 	int err;
 	int i;
 
@@ -145,16 +146,20 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
-				   taprio->enable ? i : 0);
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		tx_ring = priv->tx_ring[i];
+		tx_ring->prio = taprio->enable ? i : 0;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	}
 
 	err = enetc_setup_taprio(ndev, taprio);
-
-	if (err)
-		for (i = 0; i < priv->num_tx_rings; i++)
-			enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
-					   taprio->enable ? 0 : i);
+	if (err) {
+		for (i = 0; i < priv->num_tx_rings; i++) {
+			tx_ring = priv->tx_ring[i];
+			tx_ring->prio = taprio->enable ? 0 : i;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+		}
+	}
 
 	return err;
 }
-- 
2.34.1

