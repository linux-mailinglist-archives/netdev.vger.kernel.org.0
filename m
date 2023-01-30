Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9466817AC
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjA3RdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbjA3Rcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:43 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067572BF0E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAEr+FZNILIhqhT6ZbE+t4kRNHoM4O+nG+HbE5YTZBcKcNWcRS4YCQN7JTMHw0tZYvHtHY7sZ9a7EEK6pLCOCdaz/KuIPRC8FfLc7CQAL1gkHINVrb76cnsnx4A2wq7pmsJNd/53fONeDOx1n2wXkHkHFh6LdKcb+FgjWO3fGu+HFKg9oUVSZ6h28yVcllO+TIhYGgEET5IUTV/wY1GTTGlSreFVAybp9jB3bFRYO599bue8K219QYpTBP6TRTllhvH57Ccy66pkgwQp0nje4fXvkLKU0H3oh2LyGnazz4YzpboJHYrU0xbyOoDV6cx1BJjg/LnpPpZRH84znB9z0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SX5/bImZheHFofFZL94rLFTtD5qeX4foATfdv9EsHUk=;
 b=bmX/ycDLAYvR6APdKyq5Q5bXdssTHKkLfG1UC7SP6ML+U70BJQ1zKZme4JUTxYkIyVT9adOhMM2Skendltfd/nrr+eAird1+qHbQn9jR0QiYoG//8iFhLd6Jpo8vHDflEldK2nmXEK2gFkE/yuGxr6EgdT9eC+/MbCR3+Rfst4LIH3raoeuXE3Le1Vt/PzKPj5W6FSx7KxfhLPc5vMK+ZeJzbzx6oMwQe3ayQy0bx+I134WyJ+CNZ3IHSe06FZD4ocq7DcXLiMX0TbRaj+rawW7Nk1S8e05sejvMqSpjD+WdGknFRfFmAsNGajAOKV/NHPPdThYK7yc5/NfUHN68nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SX5/bImZheHFofFZL94rLFTtD5qeX4foATfdv9EsHUk=;
 b=bfvnhXp7tC2Fqlc21dFYPpBERhbYRQALScuwT3i9nRezgNKf9FMyCt7SBdGIK0NfqJvqlcsU7iAPbucmNo60s/aXgiLOg9Wm+uX8EpG9HaWJQX/xyIGtVVPfSYsnBPS7lniagHcp8Hts4ch/thcgo+2QDjPpbSOz9B4FirwB314=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:20 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:20 +0000
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
Subject: [PATCH v4 net-next 10/15] net: enetc: request mqprio to validate the queue counts
Date:   Mon, 30 Jan 2023 19:31:40 +0200
Message-Id: <20230130173145.475943-11-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 758b8449-1697-47a6-827e-08db02e7f0a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAmLmmkZMQwKwdNcawzK+WtvOz0KKN0ncUeUkCEq6RsveeW2hZ+z43b6u8vhWt6+HI8+43F+4hpsd+q+GIQYpetqT/ipCfJ0ujaWOBwUouJyW6NKPXtKMCil5ueuE71+fh03DaNzTXL395YHymAPunwsuaWMNez/5iUE0Un/oXFWcK3BiJ7IpcfZogkCkNumhF4tBAPDpYR2mGRvzSLhSglO23aC9jY5W7PABeij7/jveXZy757EqFcDhJPpK2igDH5Wd0Wl53bZKSC8KnIfBwcZ7oRSibwkCWI1gfHDGghJyhBMhGh98dBoKjqhbsmtxLNCaqa5FgxEA2/873IfBUB6pg9SKH2kD/5MxHQmWHXt2ASv5M+vYxoofEsRd+ABgctnZfS5fxaKzlvvRoIDMxjLWs3OHOpakp+UuTnSDvv5fUDdAS/fL3a3RgMBGAS7qEAn2BxUvLK8CASAIyRpD97VUC2ZbLFCJOlt+/kwJJVHVhQjL5hwi2/y3UBc7JZu6uF8bajGdZgXwAactKUUhZLBnxnI7eT3X3KGvKl8cTNWpU9y/RT/dIyIU++ArX8Dw0JZjZfWp+elUAAJx+3WfkARtympdMuKQuEaS70pFIh5iWrJjNTrn8KOeIMrnDYD3SIBKjyvta3rPa3p4RNJsSmRgNSkEuQFsIGP9mkN561ewx5wEomRhEUDaK/a6xOW5OCuRQjszB+S/Sz6HebOPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(15650500001)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l9U70SYCsVypDsT6mnfvUJ3tvEa4bBW11R/fe67UTgBoppYcWAKF9b9w1IrS?=
 =?us-ascii?Q?BjS0nAFTyCueuWkbpPdaCGFLlon5AoMmvpQ7SLtYE+nGFfji64dFlsqg6pSU?=
 =?us-ascii?Q?rQqXmA+oGRm3y1GoKKZzP8w1u7V3CS8Eb1SM2b3Y64dHLAi67DEnx16YU2a2?=
 =?us-ascii?Q?+7uWxXeVzV8YE+wCCUDkdNEu1BBQxzMBQ8WGlWlL5bRJhzX4C3/jM5e0G2XT?=
 =?us-ascii?Q?sua/y5VNJORhPAHyMXMfyP/ZIB34Yr+UntFL+DuFT8P0KyOsZc3F4NQdhCL/?=
 =?us-ascii?Q?bU3+yO4WOEfWq+K30eI1eqjC6Cc8F8XlhjIOQu3/4MnbrNl8FIJKZXy8oERR?=
 =?us-ascii?Q?TCVq6OmxPdvYcyw+5K9jwhHEcM4YSuIDKux8gaDpXDdfaRy7Onj9YE/2JNLC?=
 =?us-ascii?Q?lXNXm5zPXJT+LXlos9awQisHaiDspNqOtI31P6HyqDGkzTd8sUjGa81IeeSh?=
 =?us-ascii?Q?BTYAeJ3OA2SxRODWUheaTo2ubczw++RRH9nfG8IItt2nKvdX9JnHrtGaSgO9?=
 =?us-ascii?Q?nql3CRby1gwEHdnz5Yj89dHiWJnEQZDzODObPpWps1XtctZLm+pacNzxLHP5?=
 =?us-ascii?Q?ssKd8IugD0X6V8b2Ov99n4/n42F4jl0FFnd7c6tGAuiVyHqTJ3lQkBfpMaaP?=
 =?us-ascii?Q?V4ssqntLgK3Lq7HV+/5HBJ55eIUP799ePNWUhGDgxLSrh1bKqlt5LsKUVt69?=
 =?us-ascii?Q?98vm9mxtNg6jq3wsiu/dWwnX9rYc/tgGfZif17rFklLqp4P8guyzYXQJL0Xz?=
 =?us-ascii?Q?03Piz3P2OHW8wNTXU0QdJQcy/ulfFdH5UBXxb6LstGyep/AHP0/HJ4zBk9Bp?=
 =?us-ascii?Q?cSWpvRlDVDTgidUC29K2Hl6KOZFkKlfto7iPOS0rFOgLTSdbxJuM2dwHHQku?=
 =?us-ascii?Q?0Fgpruf5E7GEjOyaxqU6G1aMsC6wRH7ZX0xc/chu/WqKwqBpOJROJJuqFaF3?=
 =?us-ascii?Q?FtS1K+Vr/Xxbn+bhxMT94BSTnW5OhRhkKX2mgcQzDpzUa6XopQg8WLu/w5Ln?=
 =?us-ascii?Q?fB4Rp/DeT2K6TCH0O+Wnas+3UgKhvoUApEW1pTkp6Y5YP1ZnvV7tWsbKsO6J?=
 =?us-ascii?Q?+Kvt6AMUaRUtVHWiMNHwMGzk9jFA8PyknU4qLmxXFWKWXSuEGBQeeqBW0yKb?=
 =?us-ascii?Q?ofdG0FPZxjDldWed3/9pTEHNgOZqozGG1DfzGx1OBY5SGs27IuJ3mkFc5KLs?=
 =?us-ascii?Q?DWbufkbWmP/slYXdER9hgtA3XXPbw67R/YQXjCfOufkDCEcGJW7wYoSM8M1E?=
 =?us-ascii?Q?2QjhJhOn+aGsMzxXSdbu4joP57JkeBLSvqv2VktZHCdlK1RJtqOC3muJ8UaC?=
 =?us-ascii?Q?iTmSbiXHlVDknkYZBR6fPWOJ2+hiakmzkR5mtUBpg/DQw4fWyOzutM6u9IQ3?=
 =?us-ascii?Q?Bx+rMVGdofpBz+CMakPMis9fz1FkEYvnESVv6QSL8M6yQVmxBTQ+EnFVvQgk?=
 =?us-ascii?Q?vjMyp2dlHVLZMi/MyglHXKF5S4QAqOdf3Q9xTnXFGjQQN1viYAoOv52R3mdM?=
 =?us-ascii?Q?Ybwx/G7BPUgVUSIDlh+jLHnMC1H9M7arhUwcLhWC4owtDYVBUVFfuPQA2p2/?=
 =?us-ascii?Q?t7ynmNKg+Iuvx2SvTG1a4wIL0y/hgM/bdDZfi8sSLOJ00YdIM1qdC/mcouka?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 758b8449-1697-47a6-827e-08db02e7f0a3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:20.6317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRhhzqUG7elgmL2k9rMdnzlSn9KU/fU1HfLUz9DuRyFIuRAszWILtO4zxLi26h5g7urRNkwFlhX0qSux5qbUbQ==
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

The enetc driver does not validate the mqprio queue configuration, so it
currently allows things like this:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1

By requesting validation via the mqprio capability structure, this is no
longer allowed, and needs no custom code in the driver.

The check that num_tc <= real_num_tx_queues also becomes superfluous and
can be dropped, because mqprio_validate_queue_counts() validates that no
TXQ range exceeds real_num_tx_queues. That is a stronger check, because
there is at least 1 TXQ per TC, so there are at least as many TXQs as TCs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v2->v4: none
v1->v2: move the deletion of the num_tc check to this patch, and add an
        explanation for it

 drivers/net/ethernet/freescale/enetc/enetc.c     | 7 -------
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 1c0aeaa13cde..e4718b50cf31 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2638,13 +2638,6 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		return 0;
 	}
 
-	/* Check if we have enough BD rings available to accommodate all TCs */
-	if (num_tc > num_stack_tx_queues) {
-		netdev_err(ndev, "Max %d traffic classes supported\n",
-			   priv->num_tx_rings);
-		return -EINVAL;
-	}
-
 	/* For the moment, we use only one BD ring per TC.
 	 *
 	 * Configure num_tc BD rings with increasing priorities.
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fcebb54224c0..6e0b4dd91509 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1611,6 +1611,13 @@ int enetc_qos_query_caps(struct net_device *ndev, void *type_data)
 	struct enetc_si *si = priv->si;
 
 	switch (base->type) {
+	case TC_SETUP_QDISC_MQPRIO: {
+		struct tc_mqprio_caps *caps = base->caps;
+
+		caps->validate_queue_counts = true;
+
+		return 0;
+	}
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
-- 
2.34.1

