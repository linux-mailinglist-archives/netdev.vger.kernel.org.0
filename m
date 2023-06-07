Return-Path: <netdev+bounces-8843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF33726019
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50DD41C20CF8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033DFBE72;
	Wed,  7 Jun 2023 12:55:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B2B210A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:54:59 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2072.outbound.protection.outlook.com [40.107.241.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6784310DE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:54:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpJ/vAZAlSIQ0dZMv2dpXaXZn4hR8pD15jo+qUznvAqSBAGhHGdDgN4vQED5spEDvsJGnDKuyxHxUMFnaEvvhVgYMeKPGRGf92XerTtqHJgxT8MiMSLuZ35wruFWib4s6+xP4MtNd8J6gL5uiWkrJTO1pC5Kb0pybPh5hXGJmIoT6vLSY9t7aLg9AgyyJpURMtayQaIg+FboTDZ0yGV47ULxaoMePtBTAjPoVIo5NQVztO3I5BkkR28UdeE4Pt8/VO8J/QlB0q8vWeRBA2U8lL6Z1A+bL8T+ba8KDOQULMvQtyZRXWReA5PzZPnANE6w59SGBewZO+Hb/GZLcpjrcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1aUBm4jlXelQ//RTBq5Ibkidc/aBJpPjbvwG0mv+nQ=;
 b=Sf+oF1Sv0zL2lx6WjvvPywLKvU1gs36YS0d29uAWF15tCBwW2GG8vt5NYeakmPR8YOLN70ufXIxF9mvccqtwMi1On5zkNNLFTtQwBFh8v1e+9lNV3MHgROw9+g1fd/CoTLTjxeAie6tFA/wK1atxyAxjKEZYRJT+ppxu582EH00P0SXLtXbyiP0E0wb1NQSXwCDW6LBZ5V1CUT5+bS40HUwDe7Uz+T5Uv5JDNcGoWFfo6qekmJhISnGWLX4Y9UA6+3qU3FBUwheUaVhTr6nxZjMLTBWwWjF2WxPI6BzJOZDw3ZLuK98DsEblmV9EGT0YV5FICShcmXq7bqZklb2EJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1aUBm4jlXelQ//RTBq5Ibkidc/aBJpPjbvwG0mv+nQ=;
 b=m/MJox+fELPSY4XwEKXbURj1I8bWTU+PVQsQpEQvNKYXIVFN47uMQxsmp4BH+G3I7AFR1DceMVdLDnQ/CS3bOF9yyr/H1iY6f+t58E5bhuh2Ck9hdZqCFNpoyZYq4S8wT1sJamjMYEs3zcTWDJtCUujQgYljJ9JYeY+n+yFNNrY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB8030.eurprd04.prod.outlook.com (2603:10a6:102:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 12:54:55 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 12:54:53 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] tc/taprio: print the offload xstats
Date: Wed,  7 Jun 2023 15:54:41 +0300
Message-Id: <20230607125441.3819767-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b548a6-92ce-49e1-af97-08db67566367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yZaV2Gq/EHSQw2zvh4eE0Si7Q0IvBXk+LQT/ua762qSuCbaT9QdcpY1R6GlvBpxnLSWCDdQBEPm9HkILOLjKcSGnVwdX+AVM1OevCT12Ev9LVZUApmuA20fyphe73fYR7UMuCtW3S2aA4hlpDXaTvrzoUsdWCLYjvEXDZWo+IN/DbDxloFKdpYFlK/9XkPY6FjsIiax+CjMNrbQ3VWXECL677pNUo6SOYUtWIz93HpgvSWO/Capnxd/ml6UvG9LC4ylQhtAqDiA3iJiiQwameaWPDhgSO+X4jaq5sMrk9ZLQSz/LlayNlKOWRJ5KWBhEIzPFJ9Q7JDxXe59aCQer0RnOQ3x4P/VHqk9Fb/79Z6LN8mdSlm63MsHp1xgVQ/OhVRyBLFF0QKnArPVqqwy+TlI3PueZtHE7pdxgKoFewJ+F2AzotA+NsQGfu6w/LIccUlgZ9erggmuyOtUAqygHlnDwMTc00NrWN5xWT67VOx+fFGh0biWcFt7WDXMYXb1uFVFcP8c8hEMrnTYMhnJD85WV2651v0M+/AaDMxU4KWlcBMTJS6As/i86FWq5Eiu846Rx2Y9okbFM9DSja6uwiBPrkaeT5qu3zuGr2vBzCpvG5a5xEgCFw+vxIxz8GLw+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(54906003)(478600001)(5660300002)(44832011)(8936002)(36756003)(2906002)(86362001)(8676002)(66476007)(6916009)(66556008)(66946007)(316002)(4326008)(38100700002)(41300700001)(38350700002)(1076003)(6506007)(2616005)(26005)(6512007)(186003)(52116002)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sbOsnK4qjboLkHxztueUFzXFLqsOiVdS5U3DqnshOwi1cH4BmdOF+uqL0QsH?=
 =?us-ascii?Q?o4cH4wA56KyP+Y+n+TbT8g2+uq65huvtBnlwtD2Q8DXBUVvd/LKsfQnl/ow+?=
 =?us-ascii?Q?f6WqAEvOCfWAEqPDDQRcnpvTgkr6XJorRvDATGMQsU9IZGwnoGhmXTC/zqA+?=
 =?us-ascii?Q?xDwDT9i1CL/niIe4WGhGsfnM+a9BJ7Gd+brhUM/r4PhOkdIw/xb9SZzV7cW5?=
 =?us-ascii?Q?f0cGGRppIdF8CGE/mJGAE+PwH1Qbv7Ys5VUz3ttATxCsJpScerBGADWMPhRr?=
 =?us-ascii?Q?aduP+XYKkVW53r7LfZ1Inn0VFr3NXAH6ZC99obSTsZGChebuqwc2WQbEM8eG?=
 =?us-ascii?Q?sbCYlUnp+xBhRO5yNjgtC+yztcjuCm1iH/uZIuxsiSqCKhxeg1/NMJRCJoQl?=
 =?us-ascii?Q?zbRsvrcdfb2FaUFGSwot4PBp/cAL/ONOZHLerHaejoSrwJoh8wjQtMbHcIdG?=
 =?us-ascii?Q?Vw+dpy1rLsVxcqxhApYPO2Hs9EfBkC/Uy+3zO22tso3xSunCrK2y97DwIS/P?=
 =?us-ascii?Q?l1agdnWIcCREY22Ca4u8lDGYGXkLkEKrKcq2AFgTcEZGFAeda5fhJm2v5T55?=
 =?us-ascii?Q?PDADlZFZR9+Re/Ip2oyb0IpXpdg5zvUYREFJaVEeQc+qyTrHq2VnBFkUJenF?=
 =?us-ascii?Q?1sxKEh0fOu0v4h5xFxU9wKxsaYOT9GG36ZSJoP4Z0q5p00/vyQMRa8jY4PB0?=
 =?us-ascii?Q?vBtlL9Ir7IvYNfWxef+liOVUlLzfyPKQrHsqU3pNcV5Hy3INNm6/YfMfAfcM?=
 =?us-ascii?Q?Nv23bOKHhRP2kOephNNxeTFGKgQAl/I4MUD9qkHV9J3S+nfYqko3FhoPEwgU?=
 =?us-ascii?Q?yVO9IYSAlzKhR803GVrW8PGYtXCnqsU60DWUrHXoW3B9flMdverP7A2Em/2k?=
 =?us-ascii?Q?bbHy/Kwp6+VAr+Tcpu6X4PMzbIZi7MKrmpCOr4Jw9htlhW1/iS2/v2dKR+ms?=
 =?us-ascii?Q?uh/61NkLcQzMIvH3oRWHTl1BJOEFvUApNsP+GPhJGid5yL4bwil/rHkirjSg?=
 =?us-ascii?Q?6DVP5AIHZ3I07d3xlQEic85Nul1OzgUSxm4LecaU3/yKWkCNFM2ROFjwSn6V?=
 =?us-ascii?Q?K+zXeftlpzyqVV5vZ6IEjeztu2YHNPhLCv4oueTaR7EwneNs4Ms9QmtqGfS9?=
 =?us-ascii?Q?nc0cVpxybLwTO7ceCZcTeWWf/1uETPqb+KUt7uz66vV8tckyW6DcmR8IYmO8?=
 =?us-ascii?Q?J/0anOB4P7PO5MEpLXUx60GOBW623DDfWokucINoAVbFrZkC6AgUmNZB5zCQ?=
 =?us-ascii?Q?iG7nx1T3cqYLVQwRY9XQFt0HI0Kx9UmDiFptusPade3/B3oTD7R/sy1JIolL?=
 =?us-ascii?Q?hPUdkrOn8AY06OhP7z3iJgVkI+HsZRTYKjb6EH5yHD2RCXDJ2Y62u+UZA6CQ?=
 =?us-ascii?Q?+jZM3GBhKCyjFWLZl01WoApmD2E6gWL1xJDOtqufM9Wj5RaQBRQkuFrUenoX?=
 =?us-ascii?Q?ThjDjU8zMcU8/r73L8TJsE2agbTu1rN6+8oTYyl70egU4NvnPPd1rGghvQLU?=
 =?us-ascii?Q?Fyu5yyCpLJIHDDVLnMAQRLbZAW1m/BUJK4ICiFzFAsBNCV2d0r5vnI6CqJqD?=
 =?us-ascii?Q?Wax79IUDTDVxM3cJv/uvvrZQh7wXFoYLWqds026zapD29mGaJNnIS5ZKnAr2?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b548a6-92ce-49e1-af97-08db67566367
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 12:54:53.7414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lrzUm/CXmnywXLUCocyo9yTKKPXNHCfhNbzwcPVjrX6vqDR6j8uWc3zcToBAugzkdfcn4uC/rceitqAA1Ovxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8030
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the kernel reports offload counters through TCA_STATS2 ->
TCA_STATS_APP for the taprio qdisc, decode and print them.

Usage:

 # Global stats
 $ tc -s qdisc show dev eth0 root
 # Per-tc stats
 $ tc -s class show dev eth0

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tc/q_taprio.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index bc29710c4686..359c4c03b8c6 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -649,8 +649,32 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	return 0;
 }
 
+static int taprio_print_xstats(struct qdisc_util *qu, FILE *f,
+			       struct rtattr *xstats)
+{
+	struct rtattr *st[TCA_TAPRIO_OFFLOAD_STATS_MAX + 1], *nla;
+
+	if (!xstats)
+		return 0;
+
+	parse_rtattr_nested(st, TCA_TAPRIO_OFFLOAD_STATS_MAX, xstats);
+
+	nla = st[TCA_TAPRIO_OFFLOAD_STATS_WINDOW_DROPS];
+	if (nla)
+		print_lluint(PRINT_ANY, "window-drops", " Window drops: %llu",
+			     rta_getattr_u64(nla));
+
+	nla = st[TCA_TAPRIO_OFFLOAD_STATS_TX_OVERRUNS];
+	if (nla)
+		print_lluint(PRINT_ANY, "tx-overruns", " Transmit overruns: %llu",
+			     rta_getattr_u64(nla));
+
+	return 0;
+}
+
 struct qdisc_util taprio_qdisc_util = {
 	.id		= "taprio",
 	.parse_qopt	= taprio_parse_opt,
 	.print_qopt	= taprio_print_opt,
+	.print_xstats	= taprio_print_xstats,
 };
-- 
2.34.1


