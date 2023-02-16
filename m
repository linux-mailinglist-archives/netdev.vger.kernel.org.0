Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9069A243
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBPXWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjBPXW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:22:27 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2089.outbound.protection.outlook.com [40.107.104.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E8554D50;
        Thu, 16 Feb 2023 15:21:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErxKvLgXnVNRz6lgujfD6ZCHfe/YyPFrxT29GpQ2/C5ZBvwpQNyvO2KRLvfmsEjxPB8D5HzeLgkwjgF7UN0kPfJ74aT1Ttf3/umktoSNXvrAn6y1isDrdtujHHVZmX7MiHODr0jBOHRloZJrMHgbB/9NIsSDOScAKxB8P7hEtZhwmG8TYbk2cHAntlFUP4KZOHeHaKbjfJoBTx/jhWrPrnE3mUmFdsihEakz/i5+G0OTMZS20UAsZoGuUtlketMkYAZ0BnOCsivGOQwaBlqp2hpgnFuecwMhXhe6U2wzcLJZeLqtftgLCuCCkXLiXtS/xPg55fgzxmbX13yMGWzx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahom7zc0vAt42PO8uFVSUdi6HqcyiIxgwgjJivK1p78=;
 b=e2lLA+v49vTldDjI++zDXeTwKWxhYtajhxIUxWxLBAoUWV1TRys9xgDP9FwiC2m1NtBB05i/2wjbOZE8/v1/kaAK3/lcUewdNcTfwTU6Eo2swzU43MDwNl8Sne36h2heVHxsCLsQYhl96YU9HVPA5bzuQsi49YxoJRPI/AgfI5hoD/u9M8D2rEZo/UjZ31NsrlNoG9igy/ZJn1T1qW6BoMsTolfbrRBtCw7nADA+sWRvb1Z3C2dZ+K+87emFH4gvheVARJk+0nR0xYYG9jFRBBeAPFUKfT75VhT+hefzXlFukxW2cBitevdVAHJjgO3PTb8/E9lKq/GaK4Rg7fIDJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahom7zc0vAt42PO8uFVSUdi6HqcyiIxgwgjJivK1p78=;
 b=JSXYc0BRBuIDSoeHdD27FlKS5qrhAW4S5tphPo+1LBf6Fz2gquJ9+PUsI+UBDqqx3PPCJRhdDf5LmA46j/nPIoBJ7F5IK69cJvBZU2PffIIdWBbilnDsz3DM8JDInFT8I2EsxkL2S7PVdx3eE07Z5HNfIL4QL8A0SyyDSuoYWQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:49 +0000
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
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/12] net/sched: mqprio: add an extack message to mqprio_parse_opt()
Date:   Fri, 17 Feb 2023 01:21:22 +0200
Message-Id: <20230216232126.3402975-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: ab0c7b92-7090-4cf2-c3b8-08db1074944c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PEHy+cXGy/Luqn4fMy5ZjGclZBPBlPSsM3FklSPbIGdEsXApdpl477cGJs0ewIaPQEg8OvXoeu+PJiI6ohmR7ZWL37UWPE0YiqAAd4b7WOFlk5KrclMIwWrwRcGyBxpBnibejjBM6f/aN0VZYPeHhvDNzuj0+uGwHerGOfXqdUVTn69GEWpV/4M+O5uud+DRPtGuZfLqcuzBrYIj7UZ2y81JW+YyM/DatBYd/0del4zvCyuGYCwkdgr7bvt6n6ZEtONyqZzWXIvr0RUVGrLNE+wQXIpl/si/Z/GyaLeqE3SanoOvOWuMbkZ6EQ8Ox+5b8nsvkeHv8HCWFqhp8Ci/NXBIq69dY80RZ+9V7cR1oRrGumiZM9tbXCCMJlnCez/+fhcY22EthfNT8Q4TKhIg/hsYGennr7vntEAvqT4IbQgGgA9bK9sUpObhybKaWbO5y1Tv3lsWOhfwUH9BlHF8/T6GB/sPFehEMelKae+6cwyknCqm14Fu4FYevnxjI8g12EezqMCeT1zAQ2QCturzaawzDHMFWuLWOfvFkjxFUCv+hqnjScY5wBCLB5W3D+tEk5nlSaumCrr8vmfML376fxo5uTHZ8Egb9OgzZOeBR1r/AjfI31DkfL7Dr8IPPP4vE2vIvGVau1qZ4U/6Jrip6oaZaqrOWjwVe62V9w//4Wx3sMOgQTl9VImGmBWA/w/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(966005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EED9sLfd8PfFjkI7QWCphD0nShZdLDQsqAFFtCIejKFMwsSBiY4Xz27P+arv?=
 =?us-ascii?Q?p17rvTlVIKFmRwc10j8Yp3iOr4k9atEq+SS+8IVjXQMWdtJLeUlOExgfAVea?=
 =?us-ascii?Q?HVA8aC5PtOQrcyw9p5BKz+2ThQQqPaSpXO60h7fK5VvVsrWoNP/IVPrgjFTk?=
 =?us-ascii?Q?C2e8qSaCDI6TU0e8evdhAQWds6YuqMmjAAktYgB8JupM7hJ4a1EARK85pN7O?=
 =?us-ascii?Q?SGLnDkkBMtQ6rLOupze6HlvlQoBSImbmyIWCsQLYkpGv9vYmOdq/rY4LPtl3?=
 =?us-ascii?Q?YfFOzYqDkGHRJDtO5nhnO1/VUQoeaIAc3swA0WKG47Gclpt3NKEuA7/WZmJ9?=
 =?us-ascii?Q?vTr2B2No/qCPJRX0UwwbIrX3noUzM/zOwswgo0ls68JXDxXCqqdOJMTLtU7A?=
 =?us-ascii?Q?TGFAbvIsVlU13+o/Ocr6zNpSg0Mj3PN0OzE21mQoxPjXCzEI6hNqwO80AXRG?=
 =?us-ascii?Q?s5OxtGFI+k+ZXmAhoyLUBCg9kO7sGYyk0YPHWFGX0IAw/p6zAdwmOsDHE+o2?=
 =?us-ascii?Q?/p4r6mPvIOsdtf+HtbbVyBNiNiMUKLACBlgVlEhRbaB3xXp9zvOEtJM9fubA?=
 =?us-ascii?Q?gAkBLGitVrdESBq1D7HuWYjEF4plswD4ZRGI64aVb4ICvnbm63q4eUruPfGp?=
 =?us-ascii?Q?2aZvET3DKOkeQAnAGxadcncU2b4689KpTn9ftvhGbglPpkjhjlQHlIWBfcMv?=
 =?us-ascii?Q?OqPQ63+WbDEMGznlSLUbc42Yik5lTZJYR9h2+/Ag0n3lXjZ90PKrPwflTrhJ?=
 =?us-ascii?Q?YwYOlMP/6JSWi+xwG6UfrAjJIGdQH8cNt1Kuip3vvcHsnZXG4Odfjuwlaz2N?=
 =?us-ascii?Q?GHFOY6JVc3+rekIrmGmuxYMOir3J0r7+xDAJ4bswInMsqU2yVEGesqgJq5l7?=
 =?us-ascii?Q?m+BiN30PZ6mrieEgOvy8c2fVkIRI5d94U/M928aJTA6gRiy97IhPsSUt18lD?=
 =?us-ascii?Q?Ywc51Ccr5+XA3shOJ94fWnEbKqVjlBuv7U/05JHIVeMABq574xOcUDH+fTDT?=
 =?us-ascii?Q?rZ/GV7ItB3iH5LdyoN5CR03eJBrsI/atLljqtg9EXf6CMz42UAdzIsCeNxSk?=
 =?us-ascii?Q?zm+fpE5BLMorD2T7l9ljpzAiRNZ5zpE2+GEZLr50VTmhZV63I7wMy8IYGT0H?=
 =?us-ascii?Q?yvL/yaVXFcLyvhRtDIuFLGSXCzkYR4kWeAD5Ae3uLBWjWGTEpBiDnNmwR6PP?=
 =?us-ascii?Q?mZol29sjbjZaGa7fgH9vypt4KJ9iSl3MUixZwVaAhjMwvrNJCq/zJhd6k6Wz?=
 =?us-ascii?Q?1+5Fg8bpoQe1w3Bvi69mKZiAl9fhN8fW8shA6uDmwGz00KtBbBT/fmnNvO3l?=
 =?us-ascii?Q?jEbNBm+BIVJjjoCQRNdAALcOr7nu1dZODelh8zMphhKp9jW/7g3c4ul3DnFr?=
 =?us-ascii?Q?mbNFSLivJ8MSuaAAT/ISSh23Soh6e34kVgVQcjkh2Y6c+1V4xO+9q/FCs9OZ?=
 =?us-ascii?Q?5a/071GlC4DLkhuliSGQ4NGH0Km1ur8Cv6tMhHaMuC3DtBv8iogDwr6qy7x3?=
 =?us-ascii?Q?1vAw/Z6uxqZB14mzv6C67hn5jmtTokUnrHyCSIfGUsAB7cXjQGIrildmz8bh?=
 =?us-ascii?Q?TtFTx0iLQIxRtJchpYSQ1SUbrxbWxvarcw/KlqWewVq758EorclwnlSnLRRv?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0c7b92-7090-4cf2-c3b8-08db1074944c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:49.5710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XON40SMMTeM+FxisnyXbs5yoCniowuIGtUqisJ/FHB1YsWgv3MFTC0lJ36003TYy4HhIoeeSvV/uhZ3OdMjHeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ferenc reports that a combination of poor iproute2 defaults and obscure
cases where the kernel returns -EINVAL make it difficult to understand
what is wrong with this command:

$ ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name veth1
$ tc qdisc add dev veth0 root mqprio num_tc 8 map 0 1 2 3 4 5 6 7 \
        queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
RTNETLINK answers: Invalid argument

Hopefully with this patch, the cause is clearer:

Error: Device does not support hardware offload.

This was rejected because iproute2 defaults to "hw 1" if the option is
not specified.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230204135307.1036988-3-vladimir.oltean@nxp.com/#25215636
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_mqprio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 18eda5fade81..52cfc0ec2e23 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -134,8 +134,11 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	/* If ndo_setup_tc is not present then hardware doesn't support offload
 	 * and we should return an error.
 	 */
-	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
+	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support hardware offload");
 		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.34.1

