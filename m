Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515A267DA9C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbjA0ASU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjA0AR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:59 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E24B9778
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LULKEeAr4mUUeaZRMJL5uxyWOEuUdqfZNlNKAHdms9PKZqzV8x2xmsaFqe36Jz1HuJOtTLo1ljLTTp/QnSz2F/sRDKX1dmLj8gdIO+8eObVfT6CxtAbBLAebWQLAySYrTamjpd506l+zb3gW8IBQAb7eNKaSl7GbIlV86AkLP2X72FPJqdtoLnh5J5h7TcIdoVBCQa8106JKQxJe/XFq6sFBluArBB3++RNdiVC63xk6cr5GCQhGIcxvhO3PACE7oSWQkHEU5xsWnRp+tyCeyy3a6f04RWT+1lWD9QvVQIylYfZh7+GmTQU38H4b5vMoieCOGAZRPBqYpjrFB2TFHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jz3aGKTkNYLlFEHR2oJrmJcwI4KcMPoZyglPlzJFPOI=;
 b=TwsN5pCFPVGc+CL5jS7rlFhRPiiEeeDMWwjIX/Dl3aKZpB/ysmtQs9co3nHZ1dy5T+Ug29ybTPvkQRTDzALH9gfpOxcPXQECUSuFhkYbqugwhegQMeNkPIK47qI/lCpYeQNmJecQMdmsCoB461IMZImkhNVmWBgQLITvcOgweJ0UXXsaLmrnTUhgvcjwDu2u9LAAavXs4ogBgpaO8I+tYkD29PiBL1ow6ljdAttI7tzDaEVoviTuvOp55FEoKdhehvzpiiaqNlOWtbNpC1iM8UxY5eWKF9ds7XzRFal4rOlYNz0QskNfzUuszLF3/3e0iYGmky+Cy00X8gJoSburcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jz3aGKTkNYLlFEHR2oJrmJcwI4KcMPoZyglPlzJFPOI=;
 b=fgAp2Uc8I4hE0t2KteYARqqYMRjGutLb1qNfdKWMXgRD8eHcTbNDtwf/cDFyRp4gvA8yVRSKiDeKPOSyHGdDUvPTnwC2wlH7r5qUVHi2tk0AJGv+Qq8Q4jDedkHjbGTDKj5O2MlKOg0YIPVOoMaaVcLLwIEDBQ8qAXQGsqDLWN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:06 +0000
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
Subject: [PATCH v3 net-next 09/15] net/sched: mqprio: add extack messages for queue count validation
Date:   Fri, 27 Jan 2023 02:15:10 +0200
Message-Id: <20230127001516.592984-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de5bc8f-cd16-4a70-5aa8-08dafffbaf0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRPD6m+wDaAUexeNJ4dZ4t3ore+v5sR1ANM/IL7zoXvE3j8Qf1t1b48x7JoDJ6tcM5UL9T5F8RbtV189iuQLKBG/dxcF7VvNX3/6evJxsxULKr9RnEC+kThoyL9o+8yEBVGZKv21IYYkq+BGBityBz3R8d28Hnw+Ir7Gz7BRFT9bOGbVGa1y7L7K+T9ck1sww1giFha+Xd2+I+v+TTDdvU90+mZnms/dOpe8VkPlFVrSWDuT5szX8vtmjAx3al0qAnpyzznRM1bbxy0/tyBqqRYkrRpleEARFywmYADRSG4XQjcm6nLNhDT4v3r5TBrrIWNHLEFua3nGp/ewp+yHAXCNPi/kCARSJqPhYqB5+qdYNNw/atl3UozUX2vxPe5WxQyR97aZGHwK2wBgVrH9zDdpKDGCTq2LJuumbMbHApe/L+6zzNqxztpgAnb+ORLC8xj3zS1owHtuf9hO3bmAmyk2nbKalvEGKlaI1al/+nq0zKx/q46njuOeWkDHnJtBMU3V3o82OG97G0ejG+RXZB19DovjKlZxzqhg7ToyEL8pZccdiBpUMT07vrTQxzWbfkIIxeMN2rO4q4FS0c+lkqA4v102AGqWcwg/VBK03OBGD/sFF3wIvHMcdaPKD8xJXXWALRJIPbqGijieGGiwEVPnM7VFdIYnkrthU30y0o9AghUYPz1XS7L/AwdKNRBAoxAkGknrP0Uz8q/gydh8pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(15650500001)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VHcQCGdDtV0Vzjv9jWJJrvrxK6Bu3HxB19NFRYdrCgZnQmQufmhRP09D+zr9?=
 =?us-ascii?Q?6QAd9x1T2ZzKHZip9E/f6LnX4pCFGcJYSy98ioOUFgzbl3ttErkTlfPSsMzW?=
 =?us-ascii?Q?MqXrGUyCuUF0CkphiSakcBhhorBKCD4TGFI+0ASnnTtC+hCwFUNsf9iNFg7T?=
 =?us-ascii?Q?Xzg/utjNwcM2r0+d/kEpahGCJi/GhtjJf0rwvnciwq+oRBmqDFpJpGC+XWWg?=
 =?us-ascii?Q?02Ak5tn1iItBLX8K/dXGbHC8vaKT5pw3JiOtKuieWj5T3zKfztCztpq0uSid?=
 =?us-ascii?Q?Di4ox9mSKFk9RiCWbHgp8yk9K8B/+pJ8GigB/GXaiXHCL4taaLn/eCLfgVO0?=
 =?us-ascii?Q?hKk/psDHXwEit0LK38sClWf19OYhQqylbR3fquo+r/4kSgA533lGLaQMm7e6?=
 =?us-ascii?Q?W7JjakRYY+CRLCfthByFkebktBp25yoXtxxYwbDgCNi+ZNQCuONoJRq8eRTV?=
 =?us-ascii?Q?CNtV4H2jCpJtmNskuTeGm9aLIfSSmDZ3HIaficY0vCijclaASN9f8DXq9on8?=
 =?us-ascii?Q?9yBPG+xksK+TY8U0Udgu/v8Yhyk2J1UbDvqY3Ha2/zbvpGlvRzfd/g15EAMq?=
 =?us-ascii?Q?ylOdlAznodV823fEpkhuPXLjN0b8zX5U9qNCE8VwJAUa4uiEky49fqDzjtwY?=
 =?us-ascii?Q?QhCx7kxvGD1cME/BWQAu8Mym3XWcToqz6jvDHjGH8h9LfgHlzgTZV76jgrsV?=
 =?us-ascii?Q?dnfIFfzKnT+vU6+g6HjnilKKS5R0tY17MLNhVuoUdrnW2DIC8qabqb7R1S3q?=
 =?us-ascii?Q?H15vL5FiFzacYc/jCb8XGpyuwFG/mgKXU6JrMPppL2NshWK/iwPiJXDG5+X3?=
 =?us-ascii?Q?v+W1zhSsOYCIdb6cOfa/I+hT8ZA3QElDPBe0Y8ZkYzIkRJJYiolldHCUNlc9?=
 =?us-ascii?Q?RmB+QFTck1OvNuNhb/mDAjwfP5JzgT9PA1DCD6n0AxxvC+XXGim1mS4sqqbT?=
 =?us-ascii?Q?5NBczkpGVmMOzAhHjcCp9RfiO2mOHfFRtchfgz/sAKM3B7J1KyOaUlpwfZnz?=
 =?us-ascii?Q?UNYUxQF772mU7aYyfSXDTyKyIBOvvfQBCQArO1b0FEa1jDTrN1YXvXNSyDD/?=
 =?us-ascii?Q?1hTfkuoFDg6ftelZXktFFvMZjbvllWHeaL6cqtXzsAOjXiN8vRvaUwYy84Ep?=
 =?us-ascii?Q?OXJfrZUFFC0vzoN3nyq4xXj26X7ppzD6eD7Uu5wRSTobT2kYJ8iuPaxBq52N?=
 =?us-ascii?Q?YtfOjtAymwp3MxrpAsLIws/BCpToizzoUoFrQO1zZJfYRp35L73gy5U/I/Z2?=
 =?us-ascii?Q?FsuCifWEkV+apMfwrJF8X93JmcI0AmCLXLdWAGey8PiPG+g2BPejkFiVKcoU?=
 =?us-ascii?Q?0mimm1Fbi6SIBhEqR8SB2uqm6pbVnADgCEMW6pDRnnzSlnZQvRzlsoyyi+tx?=
 =?us-ascii?Q?J7v8K0wI5Rxm12rR8jc1UTB3R5DFB0kwPEgnDi1OGcUSFciSFZQEHGUKDHPw?=
 =?us-ascii?Q?E94DIdGkeStPUR4DYUFhHR7pF9gDthLRnTa1WlUUwLftUhhI0SMNJo0xe8GM?=
 =?us-ascii?Q?6QJh4aGoC/16vxRUsvArHT/VmU256v835IjEcxvl2Q+ibBMXMtoIZByyhJPU?=
 =?us-ascii?Q?LEkSWYaLp5YpBkXCLn26WJieVJji7/Jl2+9+QFeltiTCxJ5hNBIzhbFq5HHo?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de5bc8f-cd16-4a70-5aa8-08dafffbaf0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:06.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXe3c/6zeLn+6vGE7+vxGVUnjjbpzpjZESnKlCwbfVOHVTLqk6pzNqYfWBc4Cx/J637GhiJExDfmaBp4Mb4kNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make mqprio more user-friendly, create netlink extended ack messages
which say exactly what is wrong about the queue counts. This uses the
new support for printf-formatted extack messages.

Example:

$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
Error: sch_mqprio: Queues 1:1 for TC 1 overlap with last TX queue 3 for TC 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v3: none

 net/sched/sch_mqprio.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 5fdceab82ea1..4cd6d47cc7a1 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -28,25 +28,42 @@ struct mqprio_sched {
 };
 
 static int mqprio_validate_queue_counts(struct net_device *dev,
-					const struct tc_mqprio_qopt *qopt)
+					const struct tc_mqprio_qopt *qopt,
+					struct netlink_ext_ack *extack)
 {
 	int i, j;
 
 	for (i = 0; i < qopt->num_tc; i++) {
 		unsigned int last = qopt->offset[i] + qopt->count[i];
 
+		if (!qopt->count[i]) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "No queues for TC %d",
+					       i);
+			return -EINVAL;
+		}
+
 		/* Verify the queue count is in tx range being equal to the
 		 * real_num_tx_queues indicates the last queue is in use.
 		 */
 		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues)
+		    last > dev->real_num_tx_queues) {
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Queues %d:%d for TC %d exceed the %d TX queues available",
+					       qopt->count[i], qopt->offset[i],
+					       i, dev->real_num_tx_queues);
 			return -EINVAL;
+		}
 
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
+			if (last > qopt->offset[j]) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "Queues %d:%d for TC %d overlap with last TX queue %d for TC %d",
+						       qopt->count[j],
+						       qopt->offset[j],
+						       j, last, i);
 				return -EINVAL;
+			}
 		}
 	}
 
@@ -54,7 +71,8 @@ static int mqprio_validate_queue_counts(struct net_device *dev,
 }
 
 static int mqprio_enable_offload(struct Qdisc *sch,
-				 const struct tc_mqprio_qopt *qopt)
+				 const struct tc_mqprio_qopt *qopt,
+				 struct netlink_ext_ack *extack)
 {
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
@@ -66,7 +84,7 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 				 &caps, sizeof(caps));
 
 	if (caps.validate_queue_counts) {
-		err = mqprio_validate_queue_counts(dev, qopt);
+		err = mqprio_validate_queue_counts(dev, qopt, extack);
 		if (err)
 			return err;
 	}
@@ -138,7 +156,9 @@ static void mqprio_destroy(struct Qdisc *sch)
 		netdev_set_num_tc(dev, 0);
 }
 
-static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
+static int mqprio_parse_opt(struct net_device *dev,
+			    struct tc_mqprio_qopt *qopt,
+			    struct netlink_ext_ack *extack)
 {
 	int i;
 
@@ -167,7 +187,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw)
 		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
 
-	return mqprio_validate_queue_counts(dev, qopt);
+	return mqprio_validate_queue_counts(dev, qopt, extack);
 }
 
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
@@ -280,7 +300,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 
 	qopt = nla_data(opt);
-	if (mqprio_parse_opt(dev, qopt))
+	if (mqprio_parse_opt(dev, qopt, extack))
 		return -EINVAL;
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -314,7 +334,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * supplied and verified mapping
 	 */
 	if (qopt->hw) {
-		err = mqprio_enable_offload(sch, qopt);
+		err = mqprio_enable_offload(sch, qopt, extack);
 		if (err)
 			return err;
 	} else {
-- 
2.34.1

