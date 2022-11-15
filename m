Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DAC629E46
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiKOP6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbiKOP62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:58:28 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709BD2ED5C;
        Tue, 15 Nov 2022 07:58:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN6LEdxrXKJGWjyCF2oLiYAnD1FP6l7daF4liXtrzkckIgRFWq6FYNkIq+hAVYQnFm7hB1BDpRE9RqUALvT8hHcPdOoVQCGPRAOc/CoYubcmnfyvNaggDQ7vYUFRZeAl0bIp1ZOHoWfrR6q+3iL6M7v2y79/PISR2PcVO6NqkwNbzAHcwxynQCtyWM1R4OSMbgd3QqPTuq/bXsdEg98ZC9KzhU+qwKSyRTx/LHk2dNYXc3cM0TTfSiZiQ/jKzI44r6QNLG1Kg42m8hzIbD+4adoHXi2Dh+KdoF0q0i4IHVnhaiPMpJ03VIJhlmqegSUfUxfMDyiPxCdoXaDFy087Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25xDlwa8FLh4KnY3G2hZMn4siFAizlq83ldQ6RuVf3o=;
 b=Y9YT2rDVGccXDEDmwPjD4aXI9tSgeP7kmfAxj7nhlTh0mDXom4+qSet/+15OeTE0vdz3olRP/6pquWfvvBqUzcK/aLAE9hnKnhEgedSb5tESbkY+H3mCmzwpROzrBmlL/q78E6j6RDAhBdId+/o3RqQ/5I1WQiyydPWyiWHao0C3cVTwzMEXHCwU28QQA1ig1ochLFZvVxK8fpkr+RJaCPp70y4R6lFIPrK6os6gv3RE/1rmtWSv6wovsSxL0Mraw3vDTyoJd3AI2///85w6Gs/9Kwj00iO17Q34QL78eieSXK1/W3ZpBHahQ3zzXR4g369/tjbfhwNospnnEPzyaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25xDlwa8FLh4KnY3G2hZMn4siFAizlq83ldQ6RuVf3o=;
 b=KOeYfQHcMhI2bvM8hrLykslLTtG5zWottACfTEi1/q2Yu8WZVT5uQUhpdNEK+yF/DrvH+1Rajd41w4bYkL5G2SzDo4cJZ+zF2P9aaNW/Uou0nKQcyDPZPgsU6GozneExbeCfWkQV4Xg2ivhHVjpohXtxjDjMLC9TtFYdtdXz+oE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DBBPR04MB7690.eurprd04.prod.outlook.com (2603:10a6:10:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 15:58:18 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 15:58:17 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v4 1/2] net: page_pool: export page_pool_stats definition
Date:   Tue, 15 Nov 2022 09:57:43 -0600
Message-Id: <20221115155744.193789-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115155744.193789-1-shenwei.wang@nxp.com>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:a03:100::43) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DBBPR04MB7690:EE_
X-MS-Office365-Filtering-Correlation-Id: 60facf98-beb6-4b77-cd9b-08dac7223614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1bJuG8LB9RLuejUKIcfYMcBlhytNwNbmzXUCqRb5q8nwE6lNCyFP+/cLE909/X+Mq5agFkahY4ZoHuNB07IT0iyo3hEpAT8Eoa9UFha3EScaoOd9roZp2VL6sPyaOPYtfVRW5R0kQC7W43En3Nwpp3xuoE8tYa3WsYucHWO7KHNM11FF1oFuix4BwdbDHbQMcRPRNxOkr1beTnvVotOcGkK9oIH6ISI8SsQWuqf27GKnt4vPEDzkABo5PbjOy34+OxKVx/borFpmoC2HIJwYMubKWrkNf5Guz1eOGmUAYuMhTxL55KBcOgjG3oZB+sVBhQH23x1ChqAeEHGpERBESbD63APrwKJOiOi2OsURNU8HZq/g0PFLFHYVh9v/UhZmJgfYVOwgRXmMA6QYdK/6Hpsl7K22el2+075avlt151rCHsitGozrHjnOAJ5TYNgBBK7D2Jg5adFHVcSM6dE7Ibwt7tD3AnyJCankT9lEQgv9xi+RipVtQU6ALApV2mFOsPkBqx4DV4H6dcKJ0MGdTL6IOLtBEylwyIkIcvyFOJhFbB1eOK7yAQWZdo8YkzAXJNdWSZsYIKaaYRHh7D+gtElUROAKWUvMmHKG6LKDnzLadNGtRZHM8K42OEwKM7wdXgV6CPmXUAStaWm9Yu7NqOmBCcIHCSFmeHdqmbXk/2A0bj0E1r6SGDbIEjLGdSiFAlO4gJYgT8VVLGy3tsIvPEYuKF2QULiVYJQno6qEGXvpqaIUeqhgyZpgNdYj058IwPLLRJ30hnQgoSERRkf3dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(6512007)(186003)(83380400001)(26005)(86362001)(2616005)(38350700002)(5660300002)(38100700002)(7416002)(2906002)(44832011)(41300700001)(8936002)(4744005)(478600001)(52116002)(55236004)(6486002)(316002)(1076003)(54906003)(110136005)(66476007)(66946007)(6666004)(6506007)(4326008)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QpmWGvBghVNJSP9rySjTyIzIiFEyHFeJh6YnbG3w1D2n09DKddnz6xRIj9PF?=
 =?us-ascii?Q?Yj1FU+qkhpSW1tPOysCdsoLx7WC+obcJmxKvUyhMvbFZA44U9iJe4//FciVo?=
 =?us-ascii?Q?ORnFxhhlJVTsCHPkcizWdi+0PEmsphNF/I8HNb/CgeiyzCq5JaDwkErKNVHf?=
 =?us-ascii?Q?I0Wr5nj+5dRafMb8Sz7xd+HWKDBLGuYK8S6kPjF5/bxeWY+tUaQ4GBEebihI?=
 =?us-ascii?Q?2H1G+Ng8IfVKV7//ddVRtuj0qFrZATpQecv0nx56Lrg+lgbGPh3g5BAJrRrD?=
 =?us-ascii?Q?HA6GDewpUN6jDPpVR1kZ0MY3xZg6gKBbBWOudMDlhjkP2FIS6hs+A2AOmk8R?=
 =?us-ascii?Q?tF2X2dclTF18ZrW0ZsN1afPbCld3eW14ArRO4rBjCjYR8dw7UIp2wzR/pydl?=
 =?us-ascii?Q?KjXWqQsNnHmrNB32NM0sus9YJ3Kc4u+R1CIiXFJFt4kD4gM1ah307A5EEA7X?=
 =?us-ascii?Q?8CvnAjWY7F+0hJDmqVLYsjZPzUVY8zk+DJrJ75kKLrX1zbBw+3oexOUBWdkJ?=
 =?us-ascii?Q?QTH2isRNmx/jdPN4vCr8zoA/qzqauuJ0OvN9xpYw5PTZxlXKP19y81D8vNu+?=
 =?us-ascii?Q?xqbzXHEDzNoiWABoL9rMxhjfCaDD5vr9GSICQTloddjWTJCnG4itbpLlwhJd?=
 =?us-ascii?Q?vxfhXwsPblSpgP95RXw0VJzQMtQNPZsvImaZtNn+b2VKSkUSWjAYcRBwcNoy?=
 =?us-ascii?Q?MmRrlMAKbKYcQuQI0lVHgDimxKuI78SRkNXcC8nXkgx7BYnnzl9cYzteMsz7?=
 =?us-ascii?Q?E+AkOojkqzqpRLp03/PepXCUWcPm+A8HBAeNobWPDV8j32OayipOBCSe7/4k?=
 =?us-ascii?Q?AA4AGdtoCsu3omS4PhimPpLRou0ydeeWwKkQkSY8Dm8+e3i7X/89H44bow/t?=
 =?us-ascii?Q?E8b4S7Ap12tkrkIJ8M9LVpg7LT5HWweH0R0Pd11gCHpj8hG3QYBr+Z1rF52p?=
 =?us-ascii?Q?h/o9y5T/TRFL1ZPvkXWmeQr3TjVub3hjc/4quWr9oO3V2bl2OBbHAQypHDuN?=
 =?us-ascii?Q?kJ6LM1xeEbuE9vZQt7qELoCmku0EB78/H87vnUGFvkzZ4d7046QlyDVZmwCP?=
 =?us-ascii?Q?bKUnRK9vPRSNDI4ijyLYpZZ10v+Q5xYl/zxUoG1Mtz0qOWPWku72JX9CNlUJ?=
 =?us-ascii?Q?gLxwlGkdj/Jz/luJEuXSKvNOnIlzv0G6cFLkxJWxveulpi0bt/GmOrzbf2PI?=
 =?us-ascii?Q?oP7aMLcSoJS05sfLRdZcuhw2N8+aE67aw6oAZChuwyWdvs1AMq+p/EitHU08?=
 =?us-ascii?Q?ipp3Kk6m+5Bop8KCVj383x3ySaoM3pVO9+IuQFe2FXCaGzJNecEJr8yAGEeq?=
 =?us-ascii?Q?dSYaxkndbJByeKfMQ66RDu2szmbzEC5tdu5+gF/clLkbqxnCnpTvZ6B1KQCi?=
 =?us-ascii?Q?iv/XRXwGDeApt7sNexe0Lz5iNBgYOmmsR80CAZswWRjH5XujlmLQY8IdySIa?=
 =?us-ascii?Q?MjA6db/hb4UpTtDwrPG3lKebNWK00itPC6uOfdCFq2zXvtyDdUtMJ/MxlVnt?=
 =?us-ascii?Q?HUVcQVzEnd5aOUjdkOP1o5QqHvEZHyHsTOE/W7g8foZs3Yt0vo1eyfoOXpZl?=
 =?us-ascii?Q?AWHbnXpbZiM+GSVnzRML/UiPPznI3pjQadOsGKeI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60facf98-beb6-4b77-cd9b-08dac7223614
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 15:58:17.8994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y00TKI3t/Km2r6s2IfS6spYAoooRlpioMq0a198s8NMflZRSdljx13dpXIO/QzPWa9MBNI85kVzaY8KENilaEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7690
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of the 'struct page_pool_stats' is required even when
the CONFIG_PAGE_POOL_STATS is not defined. Otherwise, it is required
the drivers to handle the case of CONFIG_PAGE_POOL_STATS undefined.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 include/net/page_pool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..adfd4bb609a7 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -84,7 +84,6 @@ struct page_pool_params {
 	void *init_arg;
 };
 
-#ifdef CONFIG_PAGE_POOL_STATS
 struct page_pool_alloc_stats {
 	u64 fast; /* fast path allocations */
 	u64 slow; /* slow-path order 0 allocations */
@@ -117,6 +116,7 @@ struct page_pool_stats {
 	struct page_pool_recycle_stats recycle_stats;
 };
 
+#ifdef CONFIG_PAGE_POOL_STATS
 int page_pool_ethtool_stats_get_count(void);
 u8 *page_pool_ethtool_stats_get_strings(u8 *data);
 u64 *page_pool_ethtool_stats_get(u64 *data, void *stats);
-- 
2.34.1

