Return-Path: <netdev+bounces-8924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AD87264F5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D39761C20E32
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76A4370E5;
	Wed,  7 Jun 2023 15:45:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9444134D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:45:20 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2044.outbound.protection.outlook.com [40.107.7.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313C5173B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:45:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHVIRAitib+eXZ0REoAZ4iUqWyK3b4OxgP2SGrwNdOdwhxk4jXmA7xAvfRYJieDlFheFMIRgzmCAwFE0sk43EqESZkrfp9ClHH+vKmt7wbxqier9QwZPK4TvMxSmulG5tDQrZ2VdJF7WgHqj3Na++m9KckApSdEiaVMDTts4ujRwIDw9nDoG+fyS6jkqO2nHBo8NGv4frMTGt1D9ozfgb4pD1ZXmzCMlQQSZMwztfiAVBDYebHk4UDd9KM5/7nCGBlk+9JlCQZvUoJX5EIIWjhkcf8aEDeCUd5dbymK3aNvSuTTXuiO97RqvXk5aMEt7F4Dp25LiodHJJL6o4/8voQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dp6ix70vqmc+KX/P1bC9k9tF8UX9OJ/AiYwLgqXKdYE=;
 b=OhggiU7APVewCXCxbxc4r++Y41GPYrol0+NAI44iyuK8vI6iNZMXUoSLw5glf0bFSQAs6N3FkwOGyRPnPwASZ4tNUdj6Ss8tyiLouUJd/reuO4doNESTNYrpu/oVMONeGKqHvkbA0qf1V0+mKj8wpGoozBuSZRYA0yhVvtUEj9eFPjgONPe4IlWOw2gtfmaUguVoJAydv/fIgqVpfNfw7T9t4JPRP4FoWX413xX2G4/s12CYJGmSKKQlPDv6E5nvvY/o6etO+KCoBwdCRz3MFrMEQExrqFRoq1PTiAjqdbytVbK+Zk8ssJRqv5BWRYci0Ybtjl5cVeTRBZoIqxwU2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dp6ix70vqmc+KX/P1bC9k9tF8UX9OJ/AiYwLgqXKdYE=;
 b=HRLhuL3MMqXcimx7iAv1je4V9Gmxsj4lopJ0sOwKhUCfV1yqQmxXmU90sEalU9H4LdinCqP5FaumaT6LJwaZlSLPB+n3rFbHZhpzEWxm4Er+y8+TsFxHtK+PQP1jmOXH+zVuV4DO974mDw3zvBh4YXmDWfpeRFr9/soUup1+Oyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6869.eurprd04.prod.outlook.com (2603:10a6:20b:dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:45:16 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 15:45:16 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next] tc/taprio: print the offload xstats
Date: Wed,  7 Jun 2023 18:45:04 +0300
Message-Id: <20230607154504.4085041-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0136.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: 4942762a-45ce-4980-5988-08db676e30b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+0IoS5FWuuN4Dn4eQHLWE9JUJiXO6uWo1spEXCOw+7IvraoxDsvcxBo4GpLB7kGJOrOrMvAWcaGKkFuFwrQsHSkGbh8NTtyRlf8M5XB2mbMNFf+Xar5tlluG+DMHCMgttQw/XK/D1yzZTKrkPRXigmg7qZ3m5O4nKS5CcXKD/Il+Kvnz00qlXj7QJG84In/Q65oMyoHGnh6/CkmkM7Qm9L/xlZGU9DGn8VZlONDiTPYLGEU+9BNo+eMQHsKsbsokrek+8L/1vCAIu6fWwuQiGDCRO/BGC5wbAM71cMeaI0ElDm1M+QQlOYnJ+PFpq/IeMTIsoNBc6WvL9UwxI/+1/0QVkJ3OV/citsXjiJ/VavcYKCb5doezZ9Bq3RQ+WxSMNr0cQwYnfdqeI6ZlIO025JASrRCvbdTUXWYp1JmFAMDry0fVsSh01rws8EWBJ3+DfkDdGSalykONgqoCronbEhNC1vwVp8nVIfIBoBFdvvc40Ldh7PhIk32JrKXR108Xfl/5UsFfDHrz8zEkXlZ1Ip+6Le/OgYiEv5KzETnJIYLPF2d+/YmvEhFyS9uup3k3qvfBrsy8YdWBb58+Sg1wnXMgh9gYwn2wf9okny4XtLRF4REVnv5z4z/Iz5oSWIF9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(66556008)(66946007)(66476007)(2906002)(38350700002)(186003)(38100700002)(4326008)(5660300002)(36756003)(6486002)(316002)(6666004)(41300700001)(8936002)(8676002)(6916009)(54906003)(478600001)(86362001)(52116002)(1076003)(26005)(6506007)(2616005)(44832011)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gfyhT7omwMjXkwKBCYfd1+wODag8KavrSAt8xul04lby8Wl94OJJQddN1ThM?=
 =?us-ascii?Q?LVKEgqDF+bX0WeWdKBK14UXXMINmfBAFhLAiszni/VMWZ6R/AX9DWJaGyKmr?=
 =?us-ascii?Q?JHwVxOIEdVz+O+HR3YoBT3QcHArxW+C9uCQyLz4/HyISxfVgqdxFuDBwcNDR?=
 =?us-ascii?Q?P0xiUD3Mt/AW8AtT4LFyu+IRaEHZpGcnVfcigUW3/dK2JPdGk6T8eeub7SPp?=
 =?us-ascii?Q?0/pmg2tISMEXoppckqNwLYDpxYw23i3quzcEShCSjUOWx5fdKI2jflRy+y14?=
 =?us-ascii?Q?w+jge0OVDdak8zVejOmsQoFdfVYnjl8p3ikftl73e1Z7B28nQTI7y/aRUYam?=
 =?us-ascii?Q?VmkcSVze3idCcuSM8Yp37KAAFLuBuWaPPkAILfO3n6i5utx4fGdmrWyyP0/2?=
 =?us-ascii?Q?Yu71y5G+WFE914fFBj3WJwjZXHb3lEEDJfkYCzXKN5Ie32VRgKy1o2P83Mlj?=
 =?us-ascii?Q?ZPjNM+mQ6mN2O0UCR7xpl0HHhgdQv5QmqOl0G4NlPjnr+hTwZhbS9W4qSJzf?=
 =?us-ascii?Q?yh32Svfg0gAj70xyZGMr+xGKY3cHOYPbONKvPKTGis+z8mjz8kRak3X0hFb1?=
 =?us-ascii?Q?PastCghFxwNTHqfbu90izIErvwAmQjzuLd9EDQfgaKr9FTfG69z5bcQ5WAEv?=
 =?us-ascii?Q?O2wYsypH0JZvSHxkxKEY0xPhS/K4f/8n/iWOy6ZUU4ihOosHgwiqHOCn1O6U?=
 =?us-ascii?Q?XLDqvgHAfEGjpovp9pa1T3p2/ziFijLyrUFOzbV1hB07SO/PIO4HgbBMXZlf?=
 =?us-ascii?Q?kDOu7Z339I+MOnVnV5qaE1CMVtBcpA0YyQyQ9fegsDEoGx4dAL48dYiZUg/Y?=
 =?us-ascii?Q?zA+Ck1OvgZOQKd0KDsNJ/6eOcYUsExKkmFmW/HcbvGlp2gZ3EXr1u6t3EleO?=
 =?us-ascii?Q?so1OKVIbyJSbMDTHuUcoZYIMTrFsMYM20i0UvxaFImyTbXvTPNxCTLr4MjGv?=
 =?us-ascii?Q?YWM7C8QfnyQlHfncmgVVswx3BziU576BcF/0isJVX46ruwtSDNiuFMu6fd+/?=
 =?us-ascii?Q?fvBGvzNaFosJl71JPJvg4FP/VbpSmoMWhmK3yCduAY7jTkYZaYSfbZR68Jv7?=
 =?us-ascii?Q?6COPj5NoiHB0lm37rEsCRl+vlTlqSE6nw3WNUY+7tqxF9FN7EAnxM1bB/K6g?=
 =?us-ascii?Q?qwxR+iTSpIh6AboyoFuWQm4h6N9CKzRiTn9GSn7e7mgSEjr9khhe2WuWsHHx?=
 =?us-ascii?Q?eK0tb0O0GqF+Ca9VSwv9cdYwq2DD938HcFX44AkoYHyP0i33+tXkXgZbnAI7?=
 =?us-ascii?Q?lop0WfOIZHEFD3HSw6VQNFbRv7C9e8NhyOpZowiAA/kNYHX3Gr+JjAdA1En5?=
 =?us-ascii?Q?cwmkYlqj+BgrMkg3WzV2SKW1WakoRxXT9lKpLvB2NF58U3crvfX3k6nAsmUr?=
 =?us-ascii?Q?52R8Fvpk85Aa9kqVHJw02MlhxTx0acCZB1Ih7UF905O7NEdGAhUYaVeZXDx5?=
 =?us-ascii?Q?asXkWOKnnEhPIdPIWUmJgMKkWNCaeAGw0L5kbpuBbYBnkKyb4jA9cG4P3zH8?=
 =?us-ascii?Q?YJGzcE54jwKzPdhNONqKE+yLnvCI+235pu946U+hM0Px1PfxEEbp9ohnneep?=
 =?us-ascii?Q?aJeI7sE/9Hi+V9b6AEeuwu/esSYDbRKbZhiCcNMyT5m5F6YmdWGcP7CZ+fYi?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4942762a-45ce-4980-5988-08db676e30b1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:45:16.5533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZYOrh1PQdGV95DWUtmB37vIRj4i80Ryy1wRss/lzB1aSn02wyrYgdORHfGREahfN9nygSOg5SWpoeCSU5naSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6869
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
v1->v2:
- s/st/tb/ for consistency with the rest of q_taprio.c
- name counters tx_overruns and window_drops for consistency with the
  printing style of other Qdiscs

 tc/q_taprio.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index bc29710c4686..65d0a30bd67f 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -649,8 +649,32 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	return 0;
 }
 
+static int taprio_print_xstats(struct qdisc_util *qu, FILE *f,
+			       struct rtattr *xstats)
+{
+	struct rtattr *tb[TCA_TAPRIO_OFFLOAD_STATS_MAX + 1], *nla;
+
+	if (!xstats)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_TAPRIO_OFFLOAD_STATS_MAX, xstats);
+
+	nla = tb[TCA_TAPRIO_OFFLOAD_STATS_WINDOW_DROPS];
+	if (nla)
+		print_lluint(PRINT_ANY, "window_drops", " window_drops %llu",
+			     rta_getattr_u64(nla));
+
+	nla = tb[TCA_TAPRIO_OFFLOAD_STATS_TX_OVERRUNS];
+	if (nla)
+		print_lluint(PRINT_ANY, "tx_overruns", " tx_overruns %llu",
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


