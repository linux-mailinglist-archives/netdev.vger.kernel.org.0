Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8642F4F84BB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345672AbiDGQTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345668AbiDGQTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:19:41 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE901E6E99
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 09:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8goan39V2YrrUSJz0gCFad42YnxvcUop5K3pqsIECFuAT6pfk9AWzy1QQeB0XdA3C2g2UajRM4hfRUJ9NUs5yxv60qFC2oa17WAU9iYkhdeIsYtswQtof/qh0qFAenChhkc4Cr1Aa4+90IA3ig86G3VWalUYH4dFjghq2YcwKFLNvjQ3vqTFOlcQ9Y+Jc0hWE0mnilwhhI265crZkAPktSH6cWd2yfn2NAM02E6f5l6G0lpvj3NJAoKpuL0ey2M5GPhrbaYOzXSch1IgzZRXdaVVjEypTg3pRlq29Q6vuL2S4wM2lXAulT5DmP3FzXZWFoLq9HkcPu3Qq4EuK4Nzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaA+zmesJ6qoeYewPK9e883MTCdU59BROVZ5FxNITZA=;
 b=doZRovruchSPl+T0tVdFZhCBqrzLhxO+vcnZTgbmClCwsJyAhWUdV+Wxf53mt19oqLu2tQQiLJZRZ3HGEjFRCbPRboh5bHrDYlvWGFzSFVLDAL0y6+3MPYJAN/uThORWFiSqU291Z5pL5GRtMq7RX6led6zHM/hTmb7v+ebFjVzgBx9L9s+fHIkxQdAQ1jV/D+G2q8fWXx9Peu+h3B+3+Xmm2SwXfuxEZrEeI27CLwLs/sjl30nsoppo8b7Jv8VTqJxMHg7obQjCUVIZp6oF69jPPY9HRph99SsXpr1v+04oh1487cbW6tNx4DJfXM5PjF6L+ljDIDBgUmoX49Cxgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaA+zmesJ6qoeYewPK9e883MTCdU59BROVZ5FxNITZA=;
 b=TOtA/sxnR671/oQwY2kh3SsB8q9opq7qbGq3usqH+4CColBwf4KXM4dunyvY1CQOg2/rguc1fDOwluL5nsJQJHN/xo8xEv2t6E6rpFwNJzF8zQ9+dAdvUsxedM3ehyp6jY/hDzCgX2H4A3qhd/cWAZhjwuC6QhyUnikHd5Weer4POoh9qpAqbVcarsaIpIoPKoaOxMOdUlCJme3MDtM4TXWDXEiyGtJv7YlrFeewKo3jXmLoGGlPgAsuFeUarLEzoBjNH26UoYFPA/4mgluo+ft53eWg8qkMf1bGOEjz9kykmet3je0BjG9YB9UEuTQkLZUZQTrgwK4R/U9NhIhnVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by PR3PR06MB6745.eurprd06.prod.outlook.com (2603:10a6:102:61::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 16:17:18 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::382a:86f3:70e2:e1a0]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::382a:86f3:70e2:e1a0%7]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 16:17:18 +0000
From:   Tomas Melin <tomas.melin@vaisala.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Tomas Melin <tomas.melin@vaisala.com>
Subject: [PATCH v2] net: macb: Restart tx only if queue pointer is lagging
Date:   Thu,  7 Apr 2022 19:16:59 +0300
Message-Id: <20220407161659.14532-1-tomas.melin@vaisala.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR0102CA0038.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:7d::15) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f76bcbc5-93af-4858-fd2a-08da18b2161f
X-MS-TrafficTypeDiagnostic: PR3PR06MB6745:EE_
X-Microsoft-Antispam-PRVS: <PR3PR06MB6745324BF4A4EB19261B71AEFDE69@PR3PR06MB6745.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aE1KDm68QO53xb8AjV023i68KyM++JuxkS1KP+uCkRMy4GWBq8wvIPg1Z7OoJmBJlGxoUj9zqbPT2pTbCGmxrqmcQs9jel5Mcegd+ibgFAGrmQ+b8B5iaV7O0qfMEzEBOoCMFO5P5wsOctSf0UrCIleM3wyU3IOI/bc8AAewv4L9+NR0EDu7XxK9qp2UjhaVPlz3E1PDyoS7NCxWkt44/DfO1RuUCK4nh6jmwO5E+225uRT4cnEMBZjxw1/V4M7okPa4qXlVUE61de1csLmrXj6ozas9KWa2XgrX9FpRp1sCLDi7AvUv7YNYnWNrYeoxVCoWYHIfjGl2V0kLJCUNPJZy7TyJ78tTRVolwryBZ1rPrLizhXS+lTXOXl0VnPe1Pw0HWcfIAVAmgeZV1vWONX3GPGpiD+7LKL4fj6C+3iA63BiaJv+Xya/fsWAPeQYaP8jYFbAEfaFmZiu5qbJeu6qpzRBqLXDHXKD+r0tPek2ROUzIT40pI25XOlQP972c6BQ4IVZb+RrWlxzwNdPO4P97o7CuXcvHdn4GANszavp7KjMxSypFlzLq1NkqqrN8olK0E8if0jNU5NIzNsrvJvjExfe+VziuWkYWXjE1hlY3W+jd9Qzm49AnR0+/+TJO9QVcG16s0P9kgwPi4qWPQziMj6AtTI6fRDBfErSTaGTQyfCHVC4IR+Xz+8nRWAhxM0xrKUxM+1gEFqitOtEIiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(38350700002)(66556008)(38100700002)(316002)(66946007)(8676002)(6486002)(508600001)(66476007)(4326008)(186003)(83380400001)(107886003)(2906002)(44832011)(1076003)(86362001)(6506007)(6666004)(8936002)(26005)(5660300002)(52116002)(36756003)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTKNu2/YPOlMNLqlpCej/ofPtY6Zb5u6NFqWWClwZZEv/7XL6PiKIEj0NES7?=
 =?us-ascii?Q?/hrVP2kZJGV1h4VATjrg+7dFEbYpGnW0q20W5bplxaLmcfPxeuEKFul+khEt?=
 =?us-ascii?Q?6w+YHLsGdoCNgl1PJWiovHfjNyH4oAu43z+j6UXZ0R1r4wcmJvCL3XtzfASI?=
 =?us-ascii?Q?gItdQQK/Z4Uh33qqKEUKVACEMU21ND9V3OrNNw6h++mfdZrGgGR0SgNGiRSg?=
 =?us-ascii?Q?KncfSt8XWaaSyGF15tuzFUwKRdxEmzO1ro7wltlv0SJ/iUotMovsYm2Kvb5a?=
 =?us-ascii?Q?ZldqRnHflQdIUShysPgwe7/O4+ugDM2R0uniB9IV3X8ZMDvV+kq65OAAA/WM?=
 =?us-ascii?Q?Qh0OMvfvaR0Vp2rMAUcumLeWJaPhW3h6crXxJOhHX9djtjZHoFvVS/sWsqMU?=
 =?us-ascii?Q?m3F4lbl1wNtIAhz4ndzjX1iH97n03AOPZtjh7dtUmvx55m7Jo0G9D9QHomnm?=
 =?us-ascii?Q?huM8McFngAKbdPEHrHHGEBCD/0uK7OAVOkKjjQ0bbC46XouHDxTntxIUjX/q?=
 =?us-ascii?Q?KDZ8uxdoZiQE+12HgNh8I66kINCJr+j7+y1bBDqQTlBdIpQV4i1HNh/C/egI?=
 =?us-ascii?Q?evNJfA9hxldgznXSO6Fov4gBF0g3dYCkq6lvnkY07389G3cZYqxv/DnyHcMr?=
 =?us-ascii?Q?ZsDdX9nfUm6tG6A5JVC9yjf80vtYkugQfRU9XGQC9oSzH93brrr4PFJckgI/?=
 =?us-ascii?Q?I6fmCEZ2XPLffB9HhPJYD3AQylrVcS9/XQOi6s0VX1+MPhXYYnmSQHDN+FnO?=
 =?us-ascii?Q?/8fvMiUkWgSAfbvSC0ZPmbTWvr4m8yPOTbom/6liS5iKuAkv4OZs8iGj7IRc?=
 =?us-ascii?Q?jqXo57Mtk3pnILVpVBdIEIhbDXKh5WZBoPLDQLwiRXRSbrgqzoxQsiPLUlt0?=
 =?us-ascii?Q?fbvYv9hmPlov0Ch1joyoMQzu7sI+iDYYvImanU/JxE47YIg1t3OCRVRakWb9?=
 =?us-ascii?Q?ObKyHgLDdYczY6dWoTdjQAGswY6MDLL4PFWWAvGfb2KvDbS+iUjjGZ+HSWmm?=
 =?us-ascii?Q?0s/4V6xV1EvprJ5HGEwOdG8ibNqszfuyJqMq3bhOLqLUhmkg2KntU9p7uHYJ?=
 =?us-ascii?Q?LGejQyONIHFD6ZVY9rRV+l18R4ejHhjwazJ2df3NsPdmWJ/82O/Lz0S3tsEO?=
 =?us-ascii?Q?R+5wrFJj8PW9lv7KUalH2OPJhSP7TxqMBi4QkUBNX4xdZU7AFXQKb/kTH5rz?=
 =?us-ascii?Q?+xT1ePq9aeW1PUj+GADFl+r7JNBXmBxMa4YLoUP6WFEJfVnAp297bhNBNSkT?=
 =?us-ascii?Q?NbHRKzuZk5UKlN488vvVZyiPbkZYajlB0/pZYnF9m/8onghoFJ7+NV7Kd8/d?=
 =?us-ascii?Q?6VPJQTyzkoQ5vMkh17sgyFPI/IgQaxywT1s9FJkCFvR0jBNlg6SXwv+B3Jg2?=
 =?us-ascii?Q?U3H8fh03vxxgUrWvedC+Lf4UG+/sOZtSgcC3DH/O1D7qsCCli7vKDiekRjvW?=
 =?us-ascii?Q?s109gOpgDPUuXmGaakdeB7hQa3TrsUj6HrIwcQI3WStglLplAdGIZn5LvZI7?=
 =?us-ascii?Q?MIFqgpp5rA7FWAn/F/tDPO42j8DPsLzBpBKamuBZb9+bt4GRPYMHcrRrLP1e?=
 =?us-ascii?Q?kaGset9+kT9DiCoAw0jGqTDjIdudXLs+kabAf9IYWLSBR/4NIpIjnp8C4SzK?=
 =?us-ascii?Q?+v7UltL6lgeHZNrHYalWrWSOITgdAvTHLGp89JSpE5PJmJiV5i7HF0jKhgO0?=
 =?us-ascii?Q?9nsMlouScSCKeLrkL6DKGHey3vFeT9NhR7x6CTDj4+xHNY/KkAdU4nPzfEyA?=
 =?us-ascii?Q?ukAfLtRNvxD+RECgilvaJXzrRVMvLxY=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76bcbc5-93af-4858-fd2a-08da18b2161f
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 16:17:18.3286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nvQ81DqFWDtSU4Gm8jNGmH9axLA3tHzLR7pX3f7UrcvBGa7jB9GUvrGqvkWVb9K2FkZ8zLU64pCJbp1+Y5D7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR06MB6745
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 4298388574da ("net: macb: restart tx after tx used bit read")
added support for restarting transmission. Restarting tx does not work
in case controller asserts TXUBR interrupt and TQBP is already at the end
of the tx queue. In that situation, restarting tx will immediately cause
assertion of another TXUBR interrupt. The driver will end up in an infinite
interrupt loop which it cannot break out of.

For cases where TQBP is at the end of the tx queue, instead
only clear TX_USED interrupt. As more data gets pushed to the queue,
transmission will resume.

This issue was observed on a Xilinx Zynq-7000 based board.
During stress test of the network interface,
driver would get stuck on interrupt loop within seconds or minutes
causing CPU to stall.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
---
Changes v2:
- change referenced commit to use original commit ID instead of stable branch ID

 drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 800d5ced5800..e475be29845c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1658,6 +1658,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1665,6 +1666,13 @@ static void macb_tx_restart(struct macb_queue *queue)
 	if (head == tail)
 		return;
 
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
+
+	if (tbqp == head_idx)
+		return;
+
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
-- 
2.35.1

