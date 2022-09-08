Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E11F5B23E7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiIHQtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIHQtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:19 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3D61223B8;
        Thu,  8 Sep 2022 09:49:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrO6ev7Y0hjNugYCU79YgWLxQkp/SfiCTHxCwQXnUdoqREfz0ZL1EuCucDoNM6SSvAdmuSanVIt8ktZMqgCNTXKlpA85tByNKqd4eA/0KACUMDzMl+qvcaF8aFYllo0IT88yWotPJ7RTpoOfUhnlgfxmcLOhcUBV3vhjtB8uvXh7DI50PhJh4ivRzM+rbwvKWEqQzRZnXse/W8cteS6VPOyxmTP5mxzcWsAdIkGLsPTGB5EzVLG5kHVSh5SXzof2pOBVszWyCobcpuO77Z1oe6VEOUlcIU+3kNtInrrv71mpVrZUEJlFSdXosY2w33da8wzkD5BmLg8QRfF7NgnDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScpUIvhkbmuddD4iIitniuiLIpelSyPuQxtPKCGEYFs=;
 b=JX9fH0VGOgWoQ+Rg9OhHq7gCEXH8uMJ5q7CE+lEs5mdZiWwSss08i0HqRKUOvOx9l0AOwWbG2MzXqGOXTSCyY/5s+CxqSHQTEuY5bHeVBiijKVq79c2uYYGQAAgRSLJO06lm4xob968DusuJ9T2nBGxQNorrsqRx0VAxmhyV91F3VLKQMd9KO7yuODLBd4IvHtyDEm/XmaDcTr7V2w40awCbk601zaU12MPSdOviM8WGLi4GBGRglCSXTrjZoZ8t2QrEjKB3JF3s7zruUFi52vcHAq0mDAESqjWfqOyEdG3Fa+hFNj1VZl0T5ZW26sdlS0kbArCBbKzv9MQsC+TkHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScpUIvhkbmuddD4iIitniuiLIpelSyPuQxtPKCGEYFs=;
 b=a6QMuGafOakaes7oK/9jXiL0sjOoKyoUuZ5KwQVkHz67VUVFp3w6lgLSv8cA1JAceYBh93L5a3zG45LfBS9pe/JRpsHoeiU2K/2AkIy1bESXbkc39QXJX+qV9xoeui7eVtX5ir8Whc5BNvtoylh1LotWathRi/CIXAzr8QXOuUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/14] net: mscc: ocelot: exclude stats from bulk regions based on reg, not name
Date:   Thu,  8 Sep 2022 19:48:12 +0300
Message-Id: <20220908164816.3576795-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8592f36-2477-432d-a300-08da91b9fb42
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kO28bRERMBDdDt7na0O+TO4JDYtkxcJoUTvsAM/kosD0+nXBEuGaX9tNjNprMxsbyKxVbdEhcuk4+UgDCknfJqnxSInpdWLYmsov8o8ZGg7OuuknHEAw3AT1tU7FyJMSNF3x9Z8NJFnrkZ4UKeNqVxCA8dhk5E1e9EvGSdLB2ZQ+JQQXfa/x/G6ldAnZOORQRteTgfTQg1617V2uOsJe6qHJKWsMaEWSpcTTLohq1RQOCqoJwOrOht+fOjocRoBa/JOSPTha9ojg/rci014Vk51LQ2gIFgP0LsQ14M22yWhSfvkLBTJmcKkh55cffizEt9mX6OnCDf6NFZHuHCj8CecEV8OK4MkA1mw8VunvQF3jXZnfyfgG5lyWQ3F0esz3wejw9ZzSHuQCWJiQLBPpywuiEQy8YIhxjM6CTTPB0XuYlWjp3G94VzXc58cU71FGhoLbljU+N1S9pdPLpfLMVwW0fDBHQiPmY/6EelyCrYGmkNXF8QDjLNmAfgcdhLIy4d14y3vowKIBqwfzfrmP4wMZKDy1IpqRoG2nWDAtfexB3h4T0wSXCMtHcLEdGD/42YgNUQb6SNI5wbPyfcSrzHSXYU9umXU071YC+sCl8xxWTtT+Ue86guH8ZiUUE3ENDZFg/ujnpyMQeAAjL23VuPVW/klApLORF4JXTNUJT+e2gsJ6O7u2cp+0Z4Knf0z8SR91HoDC9oweAyXNXmU7tCdOBbLwwpKe2mXdpkPnFt7M63l6rRRxyTjnDKRhVvM5kX4xOkeu+TVw5B7XU/GYHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(7416002)(52116002)(41300700001)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BAgI2q24GWK9HDnZoGzp13Ka/cSfcx2EG3O4B0EQ7odtAXlwv39BJslC6bd8?=
 =?us-ascii?Q?+KCOJd+8aO5VFZ3DK92+sizb+6Ka1TvQEC1AACfDHvP7MASsngkSKq69Vgi+?=
 =?us-ascii?Q?d4gX8ja1noLWZOMabSGM6p6o8/+uCIzkOZpn4gPzfEjWhUDwVE4UUflvK8Rs?=
 =?us-ascii?Q?6WiyqUhqqAMMr0ghHdF6oST1r5RwiupiMb/YmiRoXJX6sWJ06GFMyA4aPgsa?=
 =?us-ascii?Q?PqHVMeKrsoTDwmQLIs5XxguWKW3cVxO2fJ09sZkk4qB/g3iiMGpP6ES63zoV?=
 =?us-ascii?Q?zYLb7Pf4Z4MS2FPLmyJswYC6DB2hlAzpIqjZcO/A45qcIpPjd7NUog9FeXZr?=
 =?us-ascii?Q?WPv3ITNFoH0vW+uyaJDqpE1MP6iSCInpeKzrANyYtJ/yZ2rQ0ruhejea2Boo?=
 =?us-ascii?Q?Gr5bb1eQv8cWsqAsmKroOX1g7PyO3wVGreHJtHCMhXKMYDMPtO29DVieHpuL?=
 =?us-ascii?Q?E6vYpZHUlzhNPScVbJ+RyVzM9do7Y9mvpjymcFeWrSASZ9AmcINHTvk28Q60?=
 =?us-ascii?Q?vD58kIJhcblrKQLNyyTqxQ9mqBiPyONElL/q2mCv0Qw1mqV7xv5Q0peJV+vi?=
 =?us-ascii?Q?p/et/Ka09w/dpMZSO9vnT6Fi7XKM7sBCmd0BVr+VqBhdOdcqZj+7diLjZSLy?=
 =?us-ascii?Q?uf6SRZMcyQgHCnd+zDN3OBz983/haK7m0OITY5tNo5Agv9/Nb1h/8ThWx+CC?=
 =?us-ascii?Q?WES5hMgnfqGUOwpsIxHlg1s7FLo96zkFu2nsNYYv1RByWqEOZVnVpE6FA9we?=
 =?us-ascii?Q?rmtpznTu7up3CdQGhHBu3DfP5c8rIwJIKLR7kuYyS77x8PS1/fkkhRlnfx7v?=
 =?us-ascii?Q?QB+oBjP+PCWxcVcnVYAWaGf4vkkc+FCQrea2LfMfHBG4L2YcntXNg0v/ELyR?=
 =?us-ascii?Q?XIDlPLF3xQGa+FIMlao/rFAf2Yi4/R50yZt6GIKbAJpmzOTv08k7mtNWeUM8?=
 =?us-ascii?Q?J5kN0QnbyFPSDRG6Vj5mxC0ZBUNMTgxUApy/px0M/ohdr83DZsEh4H4WlMLD?=
 =?us-ascii?Q?PUCgGTcaqsweUBf8vMLGMx45r8Hla8DA9HEihK1+HTgVUTTqUlEnNyqEoycx?=
 =?us-ascii?Q?7T0ohdp9bc39JgBt2FG9f/eQSRgbKAnX/EKJJVwQMTdupZdAPe1ExLLdmO2B?=
 =?us-ascii?Q?ge95yRbRgsKM1U4d1b+aX6Cj6eAeYcWQ8wSn7cTLVQcH2RD0ssOtKwjfDvgF?=
 =?us-ascii?Q?k1FyvLO4CimZxUFljEBEQYgjGzOazc8ym1ANFdrNxwz8y0LJH4JEZbNOzq2B?=
 =?us-ascii?Q?h3OQnkl2pelVd5yBxb2H8ojNiUA/0hPaKvDA+z6Zl0rgZj9C/cM3aKFwWZ8d?=
 =?us-ascii?Q?aYg+JyNWKI7R3Cfd71VWR+KtKSV4bXwbV/geAPNCNtlY8MnbDadalmEhkx9B?=
 =?us-ascii?Q?ub+eZGaYaTEZemWZccq3OuXL7o4gVWW3kCzhBSDCgm/W8/HQ3T2RWWbalqT2?=
 =?us-ascii?Q?pfYDPxw2AZX0ghQiYhLqKdmW76OltbdrGPQ7MZ2pSJ8DIxY4RpZ+a/H8sQh4?=
 =?us-ascii?Q?WNZ01vuEfXJSpJTuqNX1EQPp6/hy8cvNotPifyMc2WaA+5zWK/ta9P8QFteA?=
 =?us-ascii?Q?kD68lS4P4DNi/sNsN+QmsxMShVAEbNH7CgAVo/PJNKXMZtElIR7GFbBJPE0G?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8592f36-2477-432d-a300-08da91b9fb42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:39.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXG7KUmaFLgR9jkuGxW3rUAy3KvspS6NV0hgBaW0Kj3TaOnpnxJbp8p3T27E7vCuOV++EZKWTYc/Fwup++Tc8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to introduce elements kept in ocelot->stats that aren't exposed
to the unstructured ethtool -S (so they won't have their name populated),
but are otherwise checked for 32-bit wraparounds by
ocelot_port_update_stats().

This isn't possible today because ocelot_prepare_stats_regions() skips
over ocelot_stat_layout elements with no name. Now that we've changed
struct ocelot_stat_layout to keep the absolute register address rather
than the offset relative to SYS_CNT, we can make use of the unpopulated
"reg" value of 0 to mean that the counter isn't present on the current
switch revision, and skip it from the preparation of bulk regions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 64356614e69a..2926d2661af4 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -222,7 +222,7 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 	INIT_LIST_HEAD(&ocelot->stats_regions);
 
 	for (i = 0; i < OCELOT_NUM_STATS; i++) {
-		if (ocelot->stats_layout[i].name[0] == '\0')
+		if (!ocelot->stats_layout[i].reg)
 			continue;
 
 		if (region && ocelot->stats_layout[i].reg == last + 4) {
-- 
2.34.1

