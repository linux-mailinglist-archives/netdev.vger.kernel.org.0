Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD16817AD
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbjA3RdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbjA3Rco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:44 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DE829E34
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFxRWO6Lt9JZzTZDsjyYqUHiqjXqVsL9vFwsGCMOk8Y9nC8LDtLvQPoQsfUrOeawl5WKvZAACgyVFFaCxDRh1cqyqGB/XvpFrhnVdlmyhDY5z3fVdsChTTLpDWg901FnyXMFm9zLSoshyiLWC5vs0RrwYRWLU9GB+aa+E9Si/4nswMg2Eu6+gjyABIz7Hm78s3sdpL45v1csRsYDGnRjN6Y2BOrqTzcFzF/xnN05Ia5p8xDTfQh0VWxmOJabxMjoS2k/zOSCvFXxk4zQbAZmYkJk5XVkBFaY8VRtlXhoo0w/CATaVWQ+GRAJdEBoOoQi67NOoPxDZCu2kI8g/1mN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olxEsEjPtAV1qppfnXaXVtQJ3xGOXdT0V68Q+WV/YZ8=;
 b=apjuqbCyjreLnbxQG8bxaCxFYemyFBdPxuVkWql0VkuOssSuVcToyrGifZ/MVG6x01Q5j4GKnNnzF3OwYj17tI0V2Ajm5RgjkcMyVdzvSSQa9Eqk1AZL2FlkH4tembLozhZYOxf13aJiVy2U6lAPpTy14cXZc0yhe0fPvR3wWSUgMwtEOp2xShfVbNqikRMWMaEdQUHxaukJun8Yk+Xf2p9LUB8ZnNOP31UpVrWUCJgbKBUvugWdFBcFukDI+jSG3dCifhL0ioKyl0S6sNrjnDm9n7yGVj4tdhmPGgpSNtsfxZZk4WsTac8ARGVBf8Jj548qdPZTC2KFgU9RNlQxOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olxEsEjPtAV1qppfnXaXVtQJ3xGOXdT0V68Q+WV/YZ8=;
 b=iVxgrEDGpz2AQx30mJBiJCOAye68GddFk05FpMTU7SIlzf03CO/PqO0YbWbRzxNBD4Ie/6SeTdO2L0Zm96y2rwH24ZZbTQIkIB4gEFrQ/OQietEUDC6bEN8rKrNV3B3cZGXmgnM4tt/4co+W4NaNuu8Az5YqeC8izuwTKIpBNmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:21 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:21 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 11/15] net: enetc: act upon the requested mqprio queue configuration
Date:   Mon, 30 Jan 2023 19:31:41 +0200
Message-Id: <20230130173145.475943-12-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 23468be2-167a-4647-afc4-08db02e7f177
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Xqec8rSe4ESPtPMTengdnJUYN2kmjmqs/J0IpbkFFqpMhqLbFsw1c3HbrBROikp/WedTI8du60EMjSR6I791pqChIgxswjLIf0PwRVJ1YxAd+Og83xpCa+hoEVuNswmrs1OmLNgfYKtY0+XRPBTuaVdvZbEl9+PVeBmox5TvW8O/4E+yUbxf8YRfgRoDfx/UlXy5vVsAaAwLO1/JAlTA7rkVRyB54admbGg5r2Ih+ROOTllCCfLptDEb98MRqKzSuTTQc9Yfu8tgmoMkdzxacpwBvFaCwGz1B4I2CekkrR3C2FIzOwC9Mec0ASimhYK3l2frwd3ODAAIjuStojEHTZwppIGgxzk1QbccnIsGPuryC7PADq3teWxGiwjx+j+SYahe14TI4bBbm8u7S3bfBM4rxsj81qT8ideLuL2P9osVzz5ZgLFkjwS+9UjevFrvN0TbVFQicwGp3cvhSAHLoKLuHsVddBLtG1rNmQgK6gpz8puszSd3lMsl84qAcqeCIQyAjUOc7SwWZdSY73+6EpxdJiwlwqSP3PoGUDzPJFcvD9mF0FhXUXOw6YthaK1DsQe724XmoS4J0i0IJhBsbF0zx8cqqC+q2NfA9UnTP4XHM990GIU8ktdGzvUmIJxaAdih+zK0g47R1/JmJ7sRXf733h6CUS1m+d7MyKRmwKSbm4KQ4m4DTIHlDx5cWhbfaRkV3ULjC7uCXrNF7ANwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D/wL4FjXb4I8Zk6LFQoD4WeShax3c3aVD78qiHrLg2NeITRo8Dx3SmL/h5bR?=
 =?us-ascii?Q?Sqsbsy5F+w7DodTWaxIRPF5Apaku1LxwWa95NKKLuHniEzd3YBJXnKIQx6aQ?=
 =?us-ascii?Q?LaZbeFCuuVabPxjGgNcpx5ODsg+YAIxURrU4w9uEZ7CYpDY88wCbn2Trq+TR?=
 =?us-ascii?Q?g9ou13VcWWo4fJ8X3brUiiaZRN4O6Jm11hKcjRpF45hN3PlGCTt+6u+xatfF?=
 =?us-ascii?Q?5N8tJ6Vg8FgMr47nDqxWODCzNNKHoNV9yFMgbsssw47bD9OaMgF+mWR5uQPv?=
 =?us-ascii?Q?lWu2dfOhI6/2PO4hDtnx1X0g1o15sr1YFBxiDUJxi+Nkw3sidVkVvxj5Tuo2?=
 =?us-ascii?Q?ILhKEP6xGfi2nhxfh1VaTwiM6o5wKlNb7AFxVod1Wv5fYj9DqiNvcxlvhutq?=
 =?us-ascii?Q?FAYyJu+yS4MvpInlDHdMoY0IW8gCPp3PBRQrmVR8T2VAq29e78YmvsFyWJhQ?=
 =?us-ascii?Q?I2d81RxT/biPhdb2KGl0R3GJyUqtO34L8/sZoDUVDgc/xEnYLcJhutpIsfUn?=
 =?us-ascii?Q?IIP5K0fEcbjITSRftf92WpSkgzPvBehvZH2RGAKvotmjAskkojzwftrQFvlz?=
 =?us-ascii?Q?zyMJtsI12xcqkiMspvS7tJRSM6mfmTIF2WhJdEkUUAJPNEtIB2aDtZlukqr9?=
 =?us-ascii?Q?5gCE7OdGYZYmysWkG418VqqvDi2XKka2ZR4uNJUsin2YI3h0x6Q+IUeAH9He?=
 =?us-ascii?Q?/ERJpC4hH7zNLt9hVaX1QOAkznQdIVup4BHxrfowOA3eM/Lz4PzCWUxVWUuT?=
 =?us-ascii?Q?YLuyd6Yue2O4u79rladoCqlUPDJc0jAwHeC5ssLNRbrutp6tpB1/7dVBYvN1?=
 =?us-ascii?Q?fACX+AHe+sXuJbRy4vqLUrjz4buy7MBmh+IAF6UnGtbloQbL/ttGDVL1vyqK?=
 =?us-ascii?Q?3M0F51pu3MHzAmyyGwH6hyK1AClqY0zfkyjPSL5CuKSaxqazGnm7RpSDX7h4?=
 =?us-ascii?Q?hum/EijMtRTAEB3d5yW2VklndueysIKXoDPDJ3DF/Bs54H89/JAZblrE1raU?=
 =?us-ascii?Q?wbGJUAcmo18ZduOTZtpGwPHyhrcjtt2tu9I+QVvmz4uWW1jzQlN8lUeGY+Yh?=
 =?us-ascii?Q?OU6VcidFKCk+zR2kIQesH9G4oqv19ZuXSmXTSe3dvxrNDThZAUJbnQbI2Rl0?=
 =?us-ascii?Q?DJFE/8hFwGmLZNDU2Rnab1nPl2AZMt54kQGE+i+DUlBefjU/56X3RX0o5tUl?=
 =?us-ascii?Q?sXyGwGKvz/IhZ0bTjGA/ktFfx/epK8Fg2gqP2DaChmYeJt64dH6BZUUoROCz?=
 =?us-ascii?Q?D/0pzAjFSLWLalyKjadnNDQkIp/fJValhyuv/ltuk/oWYtTbJP4H+Pa9XYrg?=
 =?us-ascii?Q?i+nw66pIApYkXVqMmIazDxVNWYzcHzlixfInbKqPZ0O0z3qUkYPmxZNIUp0M?=
 =?us-ascii?Q?V1YcN8W1gTBWvZJ71oN4ux4ZIuuR+5OLreupWkp6lmpQfVUkY6x/aLOYOLMy?=
 =?us-ascii?Q?hXd2TKSrbdpr4Vm8KvE56JaydKmNdCXWNnvy/mSeC1MvLN3Q2k2w3GsuUOVb?=
 =?us-ascii?Q?coAU4j5YzLC4tjIMTInUpgTQar5euGuNmV1MlOM7iYM0oBM7MaoUT5H9by+i?=
 =?us-ascii?Q?ZaX4PbFY9PMoH+ZKkchCIFqfnxFLR2xRABAKb4Ev8GnMQsfl5hVLt5Tt2vBP?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23468be2-167a-4647-afc4-08db02e7f177
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:21.6785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdUQX6DN1rKfMhq20yR7jeEq7LwLVs6K26KUU7b77ToCGL/9LvYOIfLcZLKj3ManKYkmPIRV09zUVg2hrPDVwQ==
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

Regardless of the requested queue count per traffic class, the enetc
driver allocates a number of TX rings equal to the number of TCs, and
hardcodes a queue configuration of "1@0 1@1 ... 1@max-tc". Other
configurations are silently ignored and treated the same.

Improve that by allowing what the user requests to be actually
fulfilled. This allows more than one TX ring per traffic class.
For example:

$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 4 \
	map 0 0 1 1 2 2 3 3 queues 2@0 2@2 2@4 2@6
[  146.267648] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  146.273451] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
[  146.283280] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 1
[  146.293987] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 1
[  146.300467] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 2
[  146.306866] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 2
[  146.313261] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 3
[  146.319622] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 3
$ tc qdisc del dev eno0 root
[  178.238418] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  178.244369] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 0
[  178.251486] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 0
[  178.258006] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 0
[  178.265038] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 0
[  178.271557] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 0
[  178.277910] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 0
[  178.284281] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 0
$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
[  186.113162] fsl_enetc 0000:00:00.0 eno0: TX ring 0 prio 0
[  186.118764] fsl_enetc 0000:00:00.0 eno0: TX ring 1 prio 1
[  186.124374] fsl_enetc 0000:00:00.0 eno0: TX ring 2 prio 2
[  186.130765] fsl_enetc 0000:00:00.0 eno0: TX ring 3 prio 3
[  186.136404] fsl_enetc 0000:00:00.0 eno0: TX ring 4 prio 4
[  186.142049] fsl_enetc 0000:00:00.0 eno0: TX ring 5 prio 5
[  186.147674] fsl_enetc 0000:00:00.0 eno0: TX ring 6 prio 6
[  186.153305] fsl_enetc 0000:00:00.0 eno0: TX ring 7 prio 7

The driver used to set TC_MQPRIO_HW_OFFLOAD_TCS, near which there is
this comment in the UAPI header:

        TC_MQPRIO_HW_OFFLOAD_TCS,       /* offload TCs, no queue counts */

but I'm not sure who even looks at this field. Anyway, since this is
basically what enetc was doing up until now (and no longer is; we
offload queue counts too), remove that assignment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v4: none
v1->v2: move the mqprio teardown to enetc_reset_tc_mqprio(), and also
        call it on the error path

 drivers/net/ethernet/freescale/enetc/enetc.c | 102 +++++++++++++------
 1 file changed, 71 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e4718b50cf31..2d87deec6e77 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2609,56 +2609,96 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	return err;
 }
 
-int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+static void enetc_debug_tx_ring_prios(struct enetc_ndev_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		netdev_dbg(priv->ndev, "TX ring %d prio %d\n", i,
+			   priv->tx_ring[i]->prio);
+}
+
+static void enetc_reset_tc_mqprio(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct tc_mqprio_qopt *mqprio = type_data;
 	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_bdr *tx_ring;
 	int num_stack_tx_queues;
-	u8 num_tc;
 	int i;
 
 	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
-	num_tc = mqprio->num_tc;
 
-	if (!num_tc) {
-		netdev_reset_tc(ndev);
-		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-		priv->min_num_stack_tx_queues = num_possible_cpus();
-
-		/* Reset all ring priorities to 0 */
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = 0;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+	netdev_reset_tc(ndev);
+	netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	priv->min_num_stack_tx_queues = num_possible_cpus();
+
+	/* Reset all ring priorities to 0 */
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		tx_ring = priv->tx_ring[i];
+		tx_ring->prio = 0;
+		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	}
+
+	enetc_debug_tx_ring_prios(priv);
+}
+
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_hw *hw = &priv->si->hw;
+	int num_stack_tx_queues = 0;
+	u8 num_tc = mqprio->num_tc;
+	struct enetc_bdr *tx_ring;
+	int offset, count;
+	int err, tc, q;
 
+	if (!num_tc) {
+		enetc_reset_tc_mqprio(ndev);
 		return 0;
 	}
 
-	/* For the moment, we use only one BD ring per TC.
-	 *
-	 * Configure num_tc BD rings with increasing priorities.
-	 */
-	for (i = 0; i < num_tc; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = i;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+	err = netdev_set_num_tc(ndev, num_tc);
+	if (err)
+		return err;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		offset = mqprio->offset[tc];
+		count = mqprio->count[tc];
+
+		err = netdev_set_tc_queue(ndev, tc, count, offset);
+		if (err)
+			goto err_reset_tc;
+
+		for (q = offset; q < offset + count; q++) {
+			tx_ring = priv->tx_ring[q];
+			/* The prio_tc_map is skb_tx_hash()'s way of selecting
+			 * between TX queues based on skb->priority. As such,
+			 * there's nothing to offload based on it.
+			 * Make the mqprio "traffic class" be the priority of
+			 * this ring group, and leave the Tx IPV to traffic
+			 * class mapping as its default mapping value of 1:1.
+			 */
+			tx_ring->prio = tc;
+			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
+
+			num_stack_tx_queues++;
+		}
 	}
 
-	/* Reset the number of netdev queues based on the TC count */
-	netif_set_real_num_tx_queues(ndev, num_tc);
-	priv->min_num_stack_tx_queues = num_tc;
+	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+	if (err)
+		goto err_reset_tc;
 
-	netdev_set_num_tc(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_stack_tx_queues;
 
-	/* Each TC is associated with one netdev queue */
-	for (i = 0; i < num_tc; i++)
-		netdev_set_tc_queue(ndev, i, 1, i);
+	enetc_debug_tx_ring_prios(priv);
 
 	return 0;
+
+err_reset_tc:
+	enetc_reset_tc_mqprio(ndev);
+	return err;
 }
 EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 
-- 
2.34.1

