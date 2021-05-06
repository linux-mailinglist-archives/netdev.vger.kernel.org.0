Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27162375921
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbhEFRWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:22:01 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:60321
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236227AbhEFRVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 13:21:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROy51RX9mjDf4rxrxL6gQovS7ymnnT0wTjysBSFED6Wpa2t2XIhCMvkX55MgU2/UQEaK+oRJSt/cgYX4vdV5R9GgJcw8TV2CZtX+vine9hyI9RhFYcbys65gx2HFcdX082f7wWZS0L6SHQ1+ATIKhNpZAkHodxB5UTQE9ClwEQxgOmHJF8DcjcowtKedqYPDm2z+lol/5VpZfupIQnhUG/428GQroVnt0tsIGg40prnVbJelzjDKe+Eh1HzhnaqJ0mMs9VtyRqNY+zP8oZhIbiaGyZk2M6dspxLTjzBz70rvFTGDWkUQ0oO7e4gr40ZhuZOK23HrxuNGwcnExX1Jtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MdlXwYz8ajePunYC8vhqddXMAXF2mb+NHXWyp4/LhA=;
 b=ebVupohZgqcDjgwEzrluK3FBqBxqEjusrBDRW3yldTHIbpC56nt5mp8JvdI5oT4KEyO6eeUOc06zFH2GWLlBc52884MbFQ4G68poTb7rL8Oh8s5ovYpKuN92vj4eSi+P8LyNt++2I2YZ+g7ekCQ0cKdH69Q+QuHSy5TCyMwKae/FfifIn3J8bWTZK5lQaj+rwuwuyXN2NoaoF8CjA4dvDdf0V8FMTCok//a4EIQ9DhECt7VT+lmrTUVqxvI+ngm3xNzAPY6w8/hiq/t2rBKPjqlKzxJFRBaOWvWcGYNggKHXiqDzGkZrzzUmnyPsuXic2dkMqZJoZeao64OM/EiO2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MdlXwYz8ajePunYC8vhqddXMAXF2mb+NHXWyp4/LhA=;
 b=NYWV8Y7F0QpVbT5DPF9GSwedJnENIF9e30P7gzMSh3iYqt1kvzXsKy0NlEfPhbDFgwqL8XWWDdy5MS7ZM+dkeK7af9+NcQ36W3prcILHthxISf5KZe5kU3b+XJyYJK9K8rgjKgsfuFIBEdlFPioAiyl7QsgbIypZUkj6KkZfrA0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8581.eurprd04.prod.outlook.com (2603:10a6:10:2d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 17:20:55 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 17:20:55 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC PATCH net-next v1 2/2] net: stmmac: use specific name for each NAPI instance
Date:   Thu,  6 May 2021 19:20:21 +0200
Message-Id: <20210506172021.7327-3-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM3PR07CA0129.eurprd07.prod.outlook.com
 (2603:10a6:207:8::15) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM3PR07CA0129.eurprd07.prod.outlook.com (2603:10a6:207:8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.9 via Frontend Transport; Thu, 6 May 2021 17:20:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 749f218d-d331-478e-6df9-08d910b34eb1
X-MS-TrafficTypeDiagnostic: DU2PR04MB8581:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8581A39867B122AE217C6C06D2589@DU2PR04MB8581.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C4CVacFzudJOMXfW9kFF/jiq0T4EUczh4oQgFU2Bx334Dd70lfTLenrIxFh0a9WdWkec9Fl1AyHBmmOCfutcKKDncCpEuL2WVC3BfDztmh8NSqcqvb221GjGUuZ6Dt4J/1ExVr6xUnFhM+IJXtR9whPsJe2uCu78A2vwO9YnbSQagav1Z40kqmglJcYAWA4rfvStDZNvTVuXB3t8tkUc6DhMJtJU1iKvqcmaGlsq+SrEptZRAfh6KIshCBvo17IDmwVWNk8lRVLuOEjhBUys0slzUr/oTkvNTG3rGju1dAoxy0V+gnlvHBvivMWFggbvPCUDBzQPMSGRhtJv/2psu7Bk2294rYdb5ziLt/FGFOAoMwdq+lCBZl5DYLh0o3pnyO0zaY3VDNK556m1VkrLtX0MmxptG6jlENvTYV/mZf/QURb6KudN6vsPvsVzfphb/oyHbRi9kRV0ktslKT1uEGj0ktHxzbLUcupJSdPeLmDXPtXhguWIcglRi8dD42Qd0A4V8j4mh3/t3OvN/K1LIqaXf20QoeA7AVSOkrjx9Bn5chBEfxy0Av6V7XY6cxlS3VWNnZPJpbYuE+DT48X0X/pPMKdp4AJ3ZnNAgXhrR7QrGNXNjJWHLUAJwfWCH0IMH0j2UTeFHE9KFz9k5FTM8q7nI1MBHUrb7eN65z4d8vw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(86362001)(83380400001)(8676002)(16526019)(6486002)(7416002)(1076003)(6506007)(478600001)(26005)(6666004)(921005)(44832011)(186003)(6512007)(6636002)(2906002)(4326008)(38350700002)(66476007)(5660300002)(316002)(956004)(2616005)(52116002)(8936002)(66946007)(66556008)(38100700002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ROIHFAhxuIua0bD59KGcPNkacXriXKA4AEn3Vdg5fyhvLbkL37A+7G87thsk?=
 =?us-ascii?Q?7b/257HfUHK2YbiNW+1ajtLwuzfRZBXc6ZZ13ZQNjMy+tV44YR5vuR/uUQQa?=
 =?us-ascii?Q?OQquJly3iuIBkpPxMQC+DkIm2V45KAi7+1Iw8+ygaQ5nx2dcocnR13o9oUKL?=
 =?us-ascii?Q?1Vunqtz6oVYAyfV0sA9v2ATPjoPyL8KmiZeTfH+HlRdqcxI1EnqexZdckZ1v?=
 =?us-ascii?Q?n2hA3iRiTA6e+5dRoS8bst7PjAqSXbp8jf7XSQmQZJJ0vDu0m22wxCYXH8Mi?=
 =?us-ascii?Q?HiU/Kd2aQ1LPIFMBSwu8vAmhCQflJmZ7YlGWgJIWkn5LAEBMSLkjrofdoujb?=
 =?us-ascii?Q?Ih7ax4dIIzs7HkIO1CLMOKz7E74XNltCLGROpsmnmPGYuqgsEq9q85MdC/Vw?=
 =?us-ascii?Q?P7NIE0c70MFiNT5Z/SqynV10CH+NyZBJmTGmBOEPQ81n+LI2zLzYSvD8jwKA?=
 =?us-ascii?Q?b6YUYSPmxrTYsuBiHbVwDcko/c6JPc0yW26REzbEOtNCMe0JGFQye6xei1Go?=
 =?us-ascii?Q?Rtkh1CSzNgWnenbHbB3XxVIjROyg6+091TCUw3DU27crxI/wvCtkiNi63fKA?=
 =?us-ascii?Q?nVySgPbmxpyT1SGvlysRhq02D2u43WDEfwplGcWiqgcsX8GSmXE8I3X/E7oP?=
 =?us-ascii?Q?ITd5kxasA/Yf3+aHrz0no7Care2QLoRMovmOn8ymOk2e/Q61ii1yBqaL/94T?=
 =?us-ascii?Q?qnBK96KyWTyUSgeXuf4JTT3IeK6T3xh3cUhJqLMt7p2BJoK3/KRgOSSFiNGg?=
 =?us-ascii?Q?VTub3+P8/d+VeI6bgrS+QBQt1+xVCJ6BAMJYy1lsZoNxISVUWSmFqazaAbOi?=
 =?us-ascii?Q?PypFCzFYT3NqthZC8RZnB4GNz6cTc6itwEJk/cezGUfI7ru0jiiIWPQkwkIh?=
 =?us-ascii?Q?3ALL8GlJZhV7gUp7ybCrMArjCnHNpGt6wiqCcAKWTSMTUz45rsm6mOrzXbXM?=
 =?us-ascii?Q?1SvKK6dNw7z0MhynZlxE/TLo7IldKhNZGWKbEgJNYSy4gRPQxI+4HgrdMyuW?=
 =?us-ascii?Q?SA+vrikC9wp9Ek1QdWZefYubx0BBdV9oRgiyKc8l3KfzqFwwpQDt9TQeCAc4?=
 =?us-ascii?Q?umHvNFqcWaxcidt+rPSQDZF4IghLkiChxYixu7k97Uu9C2UM2d/rhbj7r1O6?=
 =?us-ascii?Q?dRNp9XufMH8ESqIQF8gdJB8bvVnzCJh2LhK7VQqi8zPZoG5NuXiUcrqdxJtf?=
 =?us-ascii?Q?amyZdcE4NctjQHURSkP7shD9orH+4Gvj1DNbuKPsA9Z8zX20R2HrAfOlLXqb?=
 =?us-ascii?Q?/nQFfwsRCkFucNuG8ofkMUEqGZTWTc7py3b5CR3HQjqiQvbtkO9kF0GnpEhF?=
 =?us-ascii?Q?BVhQBRwYS2f4Ng5wS2JZpCZu?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749f218d-d331-478e-6df9-08d910b34eb1
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 17:20:55.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijt8DUgXZDvngb81WJ2ZGiDqseF+soXiC8dWjfRn7yF825iPv48cIJiN/GPaIxlltli1rnCagYc8ScUaxGJX/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8581
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

Use the newly introduced name field of the NAPI struct to identify which
queue each NAPI instance works on.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e0b7eebcb512..d7fc3eddb7b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6615,6 +6615,7 @@ static void stmmac_napi_add(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 queue, maxq;
+	char name[NAPINAMSIZ];
 
 	maxq = max(priv->plat->rx_queues_to_use, priv->plat->tx_queues_to_use);
 
@@ -6626,19 +6627,23 @@ static void stmmac_napi_add(struct net_device *dev)
 		spin_lock_init(&ch->lock);
 
 		if (queue < priv->plat->rx_queues_to_use) {
-			netif_napi_add(dev, &ch->rx_napi, stmmac_napi_poll_rx,
-				       NAPI_POLL_WEIGHT);
+			snprintf(name, NAPINAMSIZ, "rx-%d", queue);
+			netif_napi_add_named(dev, &ch->rx_napi,
+					     stmmac_napi_poll_rx,
+					     NAPI_POLL_WEIGHT, name);
 		}
 		if (queue < priv->plat->tx_queues_to_use) {
-			netif_tx_napi_add(dev, &ch->tx_napi,
-					  stmmac_napi_poll_tx,
-					  NAPI_POLL_WEIGHT);
+			snprintf(name, NAPINAMSIZ, "tx-%d", queue);
+			netif_tx_napi_add_named(dev, &ch->tx_napi,
+						stmmac_napi_poll_tx,
+						NAPI_POLL_WEIGHT, name);
 		}
 		if (queue < priv->plat->rx_queues_to_use &&
 		    queue < priv->plat->tx_queues_to_use) {
-			netif_napi_add(dev, &ch->rxtx_napi,
-				       stmmac_napi_poll_rxtx,
-				       NAPI_POLL_WEIGHT);
+			snprintf(name, NAPINAMSIZ, "rxtx-%d", queue);
+			netif_napi_add_named(dev, &ch->rxtx_napi,
+					     stmmac_napi_poll_rxtx,
+					     NAPI_POLL_WEIGHT, name);
 		}
 	}
 }
-- 
2.17.1

