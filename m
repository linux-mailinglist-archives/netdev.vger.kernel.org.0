Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD376E600C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjDRLkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjDRLkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:10 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4351713
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bH8cJzX7FRT26rtAo3D76MfeKzXIV9Q2T9pZo4fo4ijaSvSjHU+W7fDCMcARWV8cEOherlIEPGT5/ymS/4uCnouyOyjaJuDlaHruwSji/CNre3WMLDE+qtE6N9q0GbpgjBUUhBx8uLqdZDpnZUBXBgd48zJ9mLXr4mAfXeP1aQxRZHSARoLgVT2CFotmqMERtjOwGfWfiI8DVTB9QW1e0WDqvR/M/YDH5kjQRJ7lD7MGSAY/MOLDgu+8BRTp2gAtEBvFuwOtaUf5AyqDuwhyAuafXG2WOBVNFXPmD6HTvRBzAz0/1OW/lykV2i+dBunWa0XjJ3CfC3xZ06YO+HMdeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gqb1KsTyfaWKLTemehXFPumS1ecAsJY3Ugv6j/bUJ2A=;
 b=mgqfdXRxf67EZVuDhhwUwWTgGVtTLcDP8dvGyhZJrLVlY36uBno90rprJJF1lTJTuHdSYj3E5MO7w+iAAiWQgnhb4VXNjSadFzA631+l/8DQEqcoLawNLqFOgR8ZRYJvrC9jAUq2+6odWEgKINn+SOwMBaCEciVSQsX5sLD6cAxNd/hXtCvQ3rL8wj6D0xiKBURdPrjaf/IqfIlBkyKB6UeKmyAMozin0WpZ8JxbfCG4W6369RPyu0wu6z1TOO/LWku/XSsPqLZJ3vYuYe6LsWleboFfFkr5Op4dPFWGQa6OD1oyUj/zAOXEqMn3roBwQtBV10++oSvnGg5eC1641w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gqb1KsTyfaWKLTemehXFPumS1ecAsJY3Ugv6j/bUJ2A=;
 b=OpSVgXDRcqISO9Me3ctKFbY+Vq41RPlYYq2ozqsZOcWItZjp097hn3Xp12YhC0+F8GlkgS9+zqDAXRXWCnq4WQC+AfWXjbX4tZovETkdomO1WhBcgu2Sx8r4cRawryJUX6o5dS4N8YxQMbzBKdI+WIH7tenw54UB82Hw8a0XfDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7824.eurprd04.prod.outlook.com (2603:10a6:102:cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:40:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 01/10] tc/taprio: add max-sdu to the man page SYNOPSIS section
Date:   Tue, 18 Apr 2023 14:39:44 +0300
Message-Id: <20230418113953.818831-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f3d56fd-55e1-45e6-9c59-08db4001a844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJEAPKhO7AD/BYmncYcB/LnUNguE5ZZoiSvLvFdqSYuejT+htC1h4lk32Bh4O9tWF/8ZHuk+SCPK1m8+3xsFrlH9bEA9+Zt96OAl5ycZ+ve3Wly21F8ee8eKGD85J4qvq7ad0enw3RrlH763svaCXc1h7jYfWbb4oCVCDCSkrtSTNbx95KnfyQwm3XQsDQTEKt42a8G2Z7WF5zyyH/WQEM5UU6WtDvqyecdcPNHdhTJYcdaVdN/3jqU1FIIKejjVMPGP+lT/Da45ck7XgH1uKpLjHqmoVr5d5wsuhCsfeNRxWSgImXBh3FroL6qduxZLhPYs7BWP20p0t3gwyW56I97o0+xnPC6GAXYwfz8u6Xh3HFe0deIY0Mil5vsFf+gcbua8eUZvbRDbdlI/2ZbQAE0VuRgmkoUge30NpVGbond+X4vuIiRu3SAWcQUe0qzCANPBn19gDxZTnv6g6GEcY9iW3gAMuv8TYkNMqtqUO5hbR+dBTzS7iUwZK8vPqUivQ2HuEr8MRl07e61nKGIxOrOmMamtVeKQicGd11yUPSu20e7Rd4hzRnXLfsV3d5v41SLONewgElH5hyhDSq1LTlABOOaxkDzXq0ZDLDX4PBduKYIubt/okCCyJKyk7Jy9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(6916009)(4326008)(316002)(54906003)(66946007)(66556008)(66476007)(186003)(6506007)(6512007)(1076003)(26005)(38350700002)(38100700002)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(478600001)(52116002)(6486002)(6666004)(8936002)(36756003)(86362001)(2906002)(4744005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?epBvgKyKvxAux11v1QkpYEltP7xg3Ca6TKF5KZjpI0Z2zdnKlV0RUVh21lw9?=
 =?us-ascii?Q?UYeFMwUIct45/R3ADZ44g/D8L03+nVEVSTLx7aDyyax0S6DVbXMk8FE2TAF6?=
 =?us-ascii?Q?cfETcCBiRYfvugSJbwegvKRNTxKRrrseBq1ami1CjoJq6DPZtaPJuCpz3uBo?=
 =?us-ascii?Q?IBZLzo01acWDCthYtcCdpaUfp9oKpdR2N+yfszhXlIK78kFqEql7cnPFcrFr?=
 =?us-ascii?Q?WJo790HuKA/g87mOKdyTQa+xkQb2JfMZmTTUJchiksHv28b67TCACf5PBBP4?=
 =?us-ascii?Q?/Sxom62cIVoh1lSczWfPgf8RMaJzQqH3lXc6cSdpQxEH8p7eEFob5DUKNZU9?=
 =?us-ascii?Q?XvV/jiXxlxjERrZ1Sm++F0p47ZIIdqQ400w037L8cjVtYO/TQAAAJG6ORrCH?=
 =?us-ascii?Q?H4OY1Xn4zU3R0X+hvjbIk+rx/CG0GOxSy3ndr5NJpXg5jfdPWNI9Gjm5nuHU?=
 =?us-ascii?Q?gfrfpVS31yrE6Rj+fy/1XOMlrLLk9bNnGlvmSNvST3vQhyo6Y/aJFvl5EDHV?=
 =?us-ascii?Q?19+7RfQywzlpKy8uEss2J6ny7EE69lcUTIRQNj2eZNBdoC05u72npAEc/MVP?=
 =?us-ascii?Q?/DpMX0XyI1/e2dHEOUnpe2Y9YGqjfqEb6PDtBeeuaPrzM1gebyIq5XkL9bNS?=
 =?us-ascii?Q?S9H+TMoqcqGIwXNONym2ct0n6Y2DS9twojin7NyDBHsRhfLvizDJeKjet4tz?=
 =?us-ascii?Q?VqXyi3dC8q02+H2hwhl/6jm2Dqcz8icp0uV3d/IfLSlu4f/Iq7qo5o/voUXJ?=
 =?us-ascii?Q?0yd5rm7LH51y8rFupn8OL/igGjlt3GLa1kgfxfybx0pQUUumxYyylrGTJypA?=
 =?us-ascii?Q?4P9vaZtNBhalXe/xYrDHzLtssZOZx4eUqtH6bt1xjrjkVCp7MBWGMZG/hMb7?=
 =?us-ascii?Q?CXaNoAiXF9h2VRMS6wT5+99ZDcRM5Cq1XvuxepdcsbCYxY4VVpM4RL+0ZrV5?=
 =?us-ascii?Q?ViZ7RaPa3CmtkDslJwBr5Odyhlq2xohoBW93T/DuExq5SydPnqo6FhoiDldh?=
 =?us-ascii?Q?1edVR2Rv9F9VSPuBn15vF/IZUgSQLbJ2HjQvu8IrlMTwQMP7A1WMEmL2fmeB?=
 =?us-ascii?Q?oNQMR+5WdHd3rVowUMM+uEONMD7VCZHyyIc9GeV0EErAnAdD1iJyH69dQ96p?=
 =?us-ascii?Q?y/QPxEITHGtb32m9Zjci3ZvpRuZULdhdL28fUo3iUivaHm0Ylpr57yXEKc+2?=
 =?us-ascii?Q?KIg4JzAUugRIyaqbn7pdhRtpa0yuAwe4i0O6ylCpa6+TI48i6chAeiG3nDRK?=
 =?us-ascii?Q?1X/Nya2P+ooLeYQaNPavTWUYdc8hROb+qrUE5sXL3gO4x43IquIlKdpwFeCd?=
 =?us-ascii?Q?tS1KAYmGLwOSnD9564VB+wVdmHUsGYSoSpQLPf7U+2Ka7a8WuW44wkYPCl8G?=
 =?us-ascii?Q?/HnMcNuzYXd7bEupPBhOkPgWZ1zIHRTPTKP6RETrN6+IB/K5LL3ON+EIz8oA?=
 =?us-ascii?Q?yXeZTu139leIC41t8RV2WEP0v9XJCcm/RnOcfp34mwgviOesI6A2Y/z9v78X?=
 =?us-ascii?Q?xlhVwynzFx0dsoiYE+ICilUN7TQd1Z7WqaTZMaHkBU+8M9WExck0W1lY1QEe?=
 =?us-ascii?Q?59nWhmz1vBHs7LMiBHa/5salaJ9SMbBtLRBAV7O5WgOTZhzui7svCyYr7NNy?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3d56fd-55e1-45e6-9c59-08db4001a844
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:06.7440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMMegX3xTiLzFbk7whi/SD53b2EYKyeD5YxfkmICsXzuXvXhVj+uiXQ7pMixcUGIv350c5SwR1yNmtcRYourUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7824
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the max-sdu argument is documented in the PARAMETERS section,
it is absent from the SYNOPSIS. Add it there too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 man/man8/tc-taprio.8 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index e1f32e73bab0..9adee7fd8dde 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -32,6 +32,10 @@ clockid
 .ti +8
 .B sched-entry
 <command N> <gate mask N> <interval N>
+.ti +8
+[
+.B max-sdu
+<queueMaxSDU[TC 0]> <queueMaxSDU[TC 1]> <queueMaxSDU[TC N]> ]
 
 .SH DESCRIPTION
 The TAPRIO qdisc implements a simplified version of the scheduling
-- 
2.34.1

