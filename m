Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8061A602E26
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiJROTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJROTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:19:32 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EED6381;
        Tue, 18 Oct 2022 07:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RopzyK2cw9EK74BHYpzP0UoFzE9NxZdfMytCdtGjOLtK5oHakJWFIR+nFpe/QymDCd2zmkYvnxma0+v38/hMkoe6RhFP0TVcGWBP0DZfDUL3X/YH737HVN0WlhR2rA40TI+0pS9TuC28bbW5g2nTMIWRBup9Pgu8tSv4mHGbI6OkMZvsGycjkny6tsX5+zQGz+M4HEs2YXfyfPJsake7VMzz8J/CgPu7akArH7/fGMJoSsxrwZXc+lzOHJVcCK8NIsFkbWNWVnKjaa3F5P9kXXkJCmW22biY53zrS2L3qUQptJZGKHdIovvzh1l2F+cqPd3CdEvMxF9dLEuYcRrkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YOEdiaZrBa8ldk2GguKKDrW0CzlybauoBwfrhCQbrM=;
 b=Q51O5iWwmwuVu/vhdM4wGZc+Mlm+EZXywllzHRryZohMIRwSWxRAr6BP+6Z/I7HRjDxTq2keuJJY0s4pLSbbXbD6QuJ0iXfTp/vQX60aYhw4khHIUBTo8W6fhBSdn0Jr/gcS5k7lgxS6MW4IoAfDOV+OeSA+adPXVLpoPerfWp+Hgb3qzh6eQMdz/jr8CVjJrF5PPcG7IudqB960pGr8ShxkBlNYzVVFvrYE3QKfecMlGYufUQJra/FoN0j2cVnwEWbcag45zqI0kWN3meEftlBP8u8vBmqjXEfypZL3TQ4I+gnfTTDBQpt6FWv1W0SwfbP9Qu6a4t71+Flg2h4Dbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YOEdiaZrBa8ldk2GguKKDrW0CzlybauoBwfrhCQbrM=;
 b=lzTYTQOhVfYe+npSDw8RDB/xl5y1mmr1aB6t2rQOj7S5kloyVbZ2Odmx0YHX5EOQTsF+iSXXRH/odf2FefTkh4jMzn12kZbHNuQvpC3FiTMzjY/CCSGqPBp6QHztJvNL/ahGR7qIWm4T328gOhlAJdVaCqVN4s6+6tYuJxx3oco=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DBAPR04MB7478.eurprd04.prod.outlook.com (2603:10a6:10:1b3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 14:19:28 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 01/12] net: dpaa2-eth: add support to query the number of queues through ethtool
Date:   Tue, 18 Oct 2022 17:18:50 +0300
Message-Id: <20221018141901.147965-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DBAPR04MB7478:EE_
X-MS-Office365-Filtering-Correlation-Id: 28c5bbd6-d733-4358-da57-08dab113c43c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxogBUpVjfIEmi4h+YR9RwJNDufKhPCY7/oZz8PbUZuKdLHxfzFWWlbEWKoPcbO+mfsKPkQteIDx86aSK2/DTDN4j+wQACYq6GigqFk2sCvoMZ/2nVKATfEbMfdZSwY3O8DCceBJ3xfeimED+qdDQQDfyc3rsm3fS1vS6N066ac/l+XQc0C02fUti9uTkMoD2kJd4lpW1if9FNRRrGN1OVNSY/RjBokikMsbwPGA4vUKn0fvDBz2Ty9floFdPAeMwJiUZZPqDyJAMijLYD1ZBN2lyEMhSa3hif5JeAQVDD8J6naYNq7mdhbe7VwxTWrBP5N+DGkE+pJeHpPQlbnprEYVh97mpCh2XQloGrqmwiSDTPWtwgAPVxBZfAp16zDLZVst81BQbTitS0rri9EdTfIEJGzmEIVmqftQjAKwCYQPYfFuQEPa9qmJsrrpJCTw9asKQ61uRll5siV1vGS2sFLYBp4ea2dmsp275rGZcW/OEynSudTdZ1Mx2f52nwIMN9YlYrMzawTgIUnli+LOK3bvKGai3y81NZ8tldzW114qxlbA+Y+WOGzArGTgxTbjJuuXyCQVSYEq3o3N8aYjCYtROdvY0OJSWb48tQHHU1eHw1s3Fig+7f8dwCFbfu0T6VWNU6NKzqSPDso5k4O9L4JNGZ1qn6jnAwiezN0bIaajh28vm8JNqZAiYOCGgfvxRwczzifzRFLMg6IgbiOdL2/LJ+udP5M0NE8timRFKzHoz/xqJ9SQdt1zpCR04nVLCqZhUhQyAls673l5KKySrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199015)(44832011)(7416002)(5660300002)(2906002)(8936002)(316002)(41300700001)(54906003)(66556008)(110136005)(6506007)(478600001)(6666004)(8676002)(66946007)(6486002)(66476007)(36756003)(4326008)(83380400001)(38100700002)(86362001)(52116002)(6512007)(186003)(38350700002)(1076003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RcTqSvVmyoOJr0YZ0TUpfHphTpH/0qd2GV9fN/On6dNKc3nJ2dSOTTlHF6la?=
 =?us-ascii?Q?jOs7J8SpuibDkSOkpl81cWbdx0FeAHGKk+ziUhhn2qkXDwwsDX+GSgDCH7dq?=
 =?us-ascii?Q?793XF6PGlnydNLoY+LQAlkmZIcsvHIkxXOtjIb9Xd8BwXVvaCiAteNXre7y0?=
 =?us-ascii?Q?ZTvwXlk7PERlOBpexocwbmOJuy/e1eLEYdg53wyQ3Tro+HbjCR6YZYHa8PUP?=
 =?us-ascii?Q?y9tD1W8aYrZQXustros7NwGAiyHTx/jIyucsmYGzfz5LYLhr0YXJucegTEG4?=
 =?us-ascii?Q?w9pM0Xkr6PM9tF5uVgBA+Iss/i5JeMI2VPvDmRaPxNloRj+ivcU6EDOdR/o7?=
 =?us-ascii?Q?+HXzzqCIEjALD6P/IM+wW9MEE52OwxyWNep5uaovgOCahc31/rylnksP+GCu?=
 =?us-ascii?Q?lp6SpBvTZlQo4vITQbott9Sxjj1WyMK5P/gTN32BtEgC/qHkPPgNRlzqHPey?=
 =?us-ascii?Q?aB7PXkBWueLJXWNW6aOsjtJPTL4U5i+5r51D2ubbjRAf/TIr9BYKcWUDiABh?=
 =?us-ascii?Q?ZlIq7jhUBA1jWejLWF7cZ6n/otXREA/Zf7cHs2orSq5EXu2RVYOcg0ScmThq?=
 =?us-ascii?Q?wPSHqxxlSUe5Lvp8JHWo7DaSSH60vRN4veTfBTO8emgEQgQJVTZ9Mi2gkCxF?=
 =?us-ascii?Q?NaEDTeWQa3F/eertgQ/g0TcGtWEqx7zDY66RQX2rNS8Y2uk+OqsGNE4kuV4u?=
 =?us-ascii?Q?3g3p0od4247e8g8bz29I6mpoz+esn7b1xC05/OjKyckbaIczNzReQxiK5D2v?=
 =?us-ascii?Q?9bWiCYLOXpdoPWzlw/70KLhIAeE0qyxTk6KVaG+oUqkQ7iO3BM1OUPNNGA3k?=
 =?us-ascii?Q?/JLgZaYlTU0HMWbVbIr0N0YlWrhAMek1FNH4+OsVtNMZx0hWjqL4n/myRXxG?=
 =?us-ascii?Q?fuR4QuLWs5oc5Di3FfK1qzgTPZVTKkOMroV314uNb07a7Bc5d0bMYdZ6tsPU?=
 =?us-ascii?Q?W6828yopMJXJQgyGmeQlsUVVNbqo2KrPUqYPeq8etCV+cTalG/4KhfahBz94?=
 =?us-ascii?Q?Z2W3D+8dwy1Xkcibz1jLZztfRa/LtP0CGO2VdPFqWIiomq9YdE7yyyJd29eQ?=
 =?us-ascii?Q?UyhG3oFjJPwuhVG/5hf7YmwOCU3I9TB9joOz2VjAt19fiBo/o3FqIggbvSyZ?=
 =?us-ascii?Q?cnyOJBW+l7DpWXgQvsPqdouzlTEvrRri9THId+cc7sb/2BNiWoM7SI6TqcaW?=
 =?us-ascii?Q?mWZBd8cSsUBf/LTpAbRRKxrCYfBv+6ykG15Ydj/zldVEWOqr1i6rb15QbDk+?=
 =?us-ascii?Q?HZCMhpLzTk4sOcYjeaLB+VAlAqo575LMMGK3yfkisSDGanSveRNeShw0nfYM?=
 =?us-ascii?Q?tNzK8aJNieEHdTg9kCinjNWYdPMhjinfbdGHeUeBHHVTjgWhc4/9gcvTLgzo?=
 =?us-ascii?Q?35azF3AAzWOxj4tjJHFEgO67pxpfhNdvPF1CqOc/CgFzIfxSV/BkO3k6YOPQ?=
 =?us-ascii?Q?cDBBD08rWm4LDIg/dikEHndcCv1yqYRVcRbdE+186htKMpoTax3NmVcpMA8w?=
 =?us-ascii?Q?HEnZ0lRldNiNAMJExQoXGrRR0Fc7XoD4ouwVXmZC8Inru6OEcHg3WoXn1elO?=
 =?us-ascii?Q?bNBDpXAmFyxgx2IvIp8gNMEEAG9yBIctSIqP/w1o9JjOCB9ChPQhiEX3RCjZ?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c5bbd6-d733-4358-da57-08dab113c43c
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:28.3350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaqfyW335/vHJahiP1dHKqyL8bGKb2GzPId9CgeTmelALdHReZxP5rL9BBg60c+61yKyTwH45vonPZaD71JEvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7478
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

The .get_channels() ethtool_ops callback is implemented and exports the
number of queues: Rx, Tx, Tx conf and Rx err.
The last two ones, Tx confirmation and Rx err, are counted as 'others'.

The .set_channels() callback is not implemented since the DPAA2
software/firmware architecture does not allow the dynamic
reconfiguration of the number of queues.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index eea7d7a07c00..97ec2adf5dc5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
- * Copyright 2016 NXP
- * Copyright 2020 NXP
+ * Copyright 2016-2022 NXP
  */
 
 #include <linux/net_tstamp.h>
@@ -876,6 +875,29 @@ static int dpaa2_eth_set_coalesce(struct net_device *dev,
 	return err;
 }
 
+static void dpaa2_eth_get_channels(struct net_device *net_dev,
+				   struct ethtool_channels *channels)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int queue_count = dpaa2_eth_queue_count(priv);
+
+	channels->max_rx = queue_count;
+	channels->max_tx = queue_count;
+	channels->rx_count = queue_count;
+	channels->tx_count = queue_count;
+
+	/* Tx confirmation and Rx error */
+	channels->max_other = queue_count + 1;
+	channels->max_combined = channels->max_rx +
+				 channels->max_tx +
+				 channels->max_other;
+	/* Tx conf and Rx err */
+	channels->other_count = queue_count + 1;
+	channels->combined_count = channels->rx_count +
+				   channels->tx_count +
+				   channels->other_count;
+}
+
 const struct ethtool_ops dpaa2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
@@ -896,4 +918,5 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.set_tunable = dpaa2_eth_set_tunable,
 	.get_coalesce = dpaa2_eth_get_coalesce,
 	.set_coalesce = dpaa2_eth_set_coalesce,
+	.get_channels = dpaa2_eth_get_channels,
 };
-- 
2.25.1

