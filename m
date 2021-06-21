Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E013AE324
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhFUGbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:31:10 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:33280
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230061AbhFUGbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 02:31:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7BkM1K7x4ehNcEazj7ZI7Iz5B+H8NB+Lkctw3qKEWc0rUsphURZt8PK550CgPUEQcZJwYDTNBT9lNXbycbE9VDTjn7P5sL0YcNCE/zZUV3B7+qBs0fuj9WsIAvpoie9OasXtWbrl3Y+gWkP6ud3N44tYXs8fLN1RC3v7/i/laYFd745wTQiqQ44UURC6IBMNVtT88sVwFhP5TIrEtopJ4vZOoXxY5H+Lv9khRxUL6OxuPWNdn+26j126E4Mb/bOOBkENF+y0PvACI3aJeKcGSkGmH4qXwo/dM2cqh2JQfvLoYQf9aL9o64oU0dG6qR2j0qlcRs11AjAw/7G7gUbOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnTSPsImtecW9CGV7Y0P0sEHtZY7xWlte6cO0d5re7I=;
 b=R+uFaZMlxzIe2vVLppw2E9O+DwTNjJhIT+mzoUAxJAlGrgnT52VWXsqNz+XYjOuMWrv9kx6hNCpYlSqJTxOoeastj0v27P223QpzrVbn0y8ZwuAJ8kR6wb9nd+wUBH5XrLloSxB/NHMX+SQU2QfqBcPr9ZRXvt94W1VBwr2isgJVAweT/h9XfI0gF4ewFC/V4RzzS+JrPKsBJ0PW9vbIAKWljvvx2sFTBFeqGvxxTHBEu6byg2W04LKDxCuSxsAANjCTtRwPdh1T3qtznkRKa+eZpUURRFbt5at5eR+at8svmmyu2AKK/kYf90xRJuvrBY9rR5g3FPohmNOPVz602g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnTSPsImtecW9CGV7Y0P0sEHtZY7xWlte6cO0d5re7I=;
 b=haR75KNVJeLU5pmm1bXnq2d/49BkUc7XvoqMfwRWDHY/4RioSFXFmaHzLWI0Clm5hEpJtJRt/PsRXEILk2NNq8eO0dlFuXuKc5RKsyorOx6NyIxlcBFqcB/qiMiUFTSkPDJPwxYYNsvXbVg8o7zn9MxGTt2BeS16p1lSGg9BjYk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5883.eurprd04.prod.outlook.com (2603:10a6:10:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Mon, 21 Jun
 2021 06:28:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 06:28:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V3 1/2] net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP
Date:   Mon, 21 Jun 2021 14:27:36 +0800
Message-Id: <20210621062737.16896-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
References: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Mon, 21 Jun 2021 06:28:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f924e6d2-47ff-46c4-3dae-08d9347dd6c0
X-MS-TrafficTypeDiagnostic: DB8PR04MB5883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB588398F904CCB44F70F092FFE60A9@DB8PR04MB5883.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vKugeQ6WDJFJxEL4J7RDlawgS/AxmsRUv920pDrm3xPTCIofhnV7KkmNnt1eNcX0zEDVSt5Yq1WE1k4umlzvNvqWxqlRGddYiyFOftJHZQYKoS99TE6AVO9YoTWVN2uEZyE++ZdRYVk86BkdQIrBtYuL/LjEXV9/0kndPkw70cJb5ZCgcGUtWC9fGtoO+RDpn2F1Mix+juujsz/6tTs/OPkxfnkjjOQwlQYI05fA80nnFeWYnNoYwJmpVBBpCoSVdV5Ypeg8R6wAWPUco7ZpbE4tQKEL+Y7MbB8zDnFWn5e8HFDkD2euxVxy2L7ZpXHe2GZGpwlsWPxJSq27ySegOpUmlfWCoYigmt8H8nYOMw2Y9D9eT/Nl1ujhB4QeIxBOK3BVKHCAwlmf+2mm2tr92XEjcK1tZ4zHAz7PdXvh6lOQdpr2UWdy1eTTgNRM06gwjV2nZ7wq/9HORET7+mJlu9KovycuKvYpD5D4LBarKDpSqNs6g9aVtIEN5HmDg+88ZhbqRm55pjvoYhUR58mvTsM94aUxjJ7xXZGCLbVU1/gl6F4ByX65kerFIalT+qWEdrJ+sHskMCDPJ0LMj6AIvj5AXPhyKdZxPV8K1XfIkY4o3O/9azQpZLReHqEzsKiMLFm21SA1uw98uIW9yKFS6+qJ7PQV5b3DotLT1DrXUvlX0BqEudv2I+HEWe5qlX3CNne6q75LzVMdZx2VQI+U/WQkS9ESC2jqTJYH1B17aEFqVUxIqWtNdKZvkcL40lPsqBjS6sbpKU3T1VQpV+8c4P9cM60xvXYwDoEKbJKeI3cdY/sF24SkiOGFwFtiwg1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(66946007)(66556008)(66476007)(36756003)(6512007)(956004)(2616005)(966005)(478600001)(4326008)(86362001)(83380400001)(16526019)(6486002)(186003)(6666004)(38350700002)(316002)(5660300002)(8676002)(2906002)(8936002)(6506007)(38100700002)(26005)(1076003)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QyTUx21fm2kQ6QIW0GNZOqrc2zEB9OvDocZ07v/63xvR5OJwNwkquM7T4X0r?=
 =?us-ascii?Q?Yd+RSAoRswLVzIy9B7WapBmK6YNwy/YHOzyS5pfMzrOtjG/ofZmMlioCS9yD?=
 =?us-ascii?Q?Ty2KdjA0nBeHxVf56ymjTJUiKChohycOc2iG7GBku7AifVWmbn0GCyGyKccV?=
 =?us-ascii?Q?Da6YrFxpvwIhoKEhy4OtEiYaxW5k5CNcG1yPp0SoP9S6paDBjaWPuNynQJDh?=
 =?us-ascii?Q?hSxzEgfIPPZg34ae8Oaii1c7R7vmB1ZwAPF6yuKGYru7d2EH/Z0eTCO1NUe+?=
 =?us-ascii?Q?glfEV5keWG4vDF96vqK1TOkAymS7hSVapzFk1zJAcVxV7A84GZ8jMj2XOcd3?=
 =?us-ascii?Q?+4UF2YqIQyyXcFH00L1v9SUY90/OpupVtsVLwxijTGGZtjiBDVsGFIj2bpQK?=
 =?us-ascii?Q?UeCD6MvEKFFw7zjw/M5rgh7FU19oGHydVXIwQfjuYUbzXj1olxIOEqsDjmG+?=
 =?us-ascii?Q?krT3WxEszI1wT/2lGGyVe+oaJEmHBRyDYz2ybZNxhzyL4Wb72TaOQIpwh5+o?=
 =?us-ascii?Q?p1hyb5nAlyTM+aPzam/U/xYhGO3uMaxwBUhvAX10putP17XLwhyXpg1CYvRf?=
 =?us-ascii?Q?UjP/m1h0ZLb0+LAdnO9gVL+xux+rEOfGsOjvwAw3XdRdG3uDPN0NkAKFXxEr?=
 =?us-ascii?Q?VioKKs4C9oj5Slyn32nd7HbWeZiakLkBTY8sHBOGdI6FCmqRPkkD35WGP9zH?=
 =?us-ascii?Q?wYv/cUbsqS1N+Du0ZREhawFLjOdFJKZ3AL2G8SjoA5I4ue8XIhe314w3Ga0H?=
 =?us-ascii?Q?cEqI+nKzC7siD7FtpHg8jhwegXih+uX5xJv+yvP7OIOxgdrUwRQ2rKQcA1dh?=
 =?us-ascii?Q?PF0vf6xHnpJmlajkkHDjmVCMNM5kzu/xNkCYChIbNPBtbMciwFlSvmMybe1B?=
 =?us-ascii?Q?nq0kL/NOuHHVxrld+EKYgtLTjlTHU4QavFlnFfSz0ssYBAIWflkwAUFDL9eu?=
 =?us-ascii?Q?m9CHeAPWMt/iKuwVIxhu0GvoyZHmFWd7RD+9ys8Q5AcNZ68bWSUUl6P1NHwI?=
 =?us-ascii?Q?gTuYbCHif7n7Msjc1iaEejIAq+N2dQ0pLruetYNPh82VvScjOVT/knlH2XJd?=
 =?us-ascii?Q?a0NMlMiuK+jlseRnlqYOzj2Ob+FxOYcIBUEZtjS6SZWEqDvr1CmmkyiJce0c?=
 =?us-ascii?Q?70X6NCHcAtc0m39uIOW9HwgCKP5DkBlEkXhDAaKat2oOkdhRwJNp6v/mf/KH?=
 =?us-ascii?Q?blOR6ysgaErtRrAhQQFJUN3gckJ9ZRE3h3cvLdXdjraYKJP6NlKx5n13l3fp?=
 =?us-ascii?Q?4RVdAIfUnLKXGPZ1WClItXcDoDD7wggJwEmxd0IYh0GW8Tq6VWRQvf+cE6E+?=
 =?us-ascii?Q?wKzSaXRQaNTq8aYk+QFiUEmE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f924e6d2-47ff-46c4-3dae-08d9347dd6c0
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 06:28:52.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gg/ZhsNMAJuIhNcs0f4eat+w8okybEEW3NY74aArM61Blode7JktvQOGDD9l8Fk1cHlK0CDuiZ9Uxx3Cp25BAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frieder Schrempf reported a TX throuthput issue [1], it happens quite often
that the measured bandwidth in TX direction drops from its expected/nominal
value to something like ~50% (for 100M) or ~67% (for 1G) connections.

[1] https://lore.kernel.org/linux-arm-kernel/421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de/

The issue becomes clear after digging into it, Net core would select
queues when transmitting packets. Since FEC have not impletemented
ndo_select_queue callback yet, so it will call netdev_pick_tx to select
queues randomly.

For i.MX6SX ENET IP with AVB support, driver default enables this
feature. According to the setting of QOS/RCMRn/DMAnCFG registers, AVB
configured to Credit-based scheme, 50% bandwidth of each queue 1&2.

With below tests let me think more:
1) With FEC_QUIRK_HAS_AVB quirk, can reproduce TX bandwidth fluctuations issue.
2) Without FEC_QUIRK_HAS_AVB quirk, can't reproduce TX bandwidth fluctuations issue.

The related difference with or w/o FEC_QUIRK_HAS_AVB quirk is that, whether we
program FTYPE field of TxBD or not. As I describe above, AVB feature is
enabled by default. With FEC_QUIRK_HAS_AVB quirk, frames in queue 0
marked as non-AVB, and frames in queue 1&2 marked as AVB Class A&B. It's
unreasonable if frames in queue 1&2 are not required to be time-sensitive.
So when Net core select tx queues ramdomly, Credit-based scheme would work
and lead to TX bandwidth fluctuated. On the other hand, w/o
FEC_QUIRK_HAS_AVB quirk, frames in queue 1&2 are all marked as non-AVB, so
Credit-based scheme would not work.

Till now, how can we fix this TX throughput issue? Yes, please remove
FEC_QUIRK_HAS_AVB quirk if you suffer it from time-nonsensitive networking.
However, this quirk is used to indicate i.MX6SX, other setting depends
on it. So this patch adds a new quirk FEC_QUIRK_HAS_MULTI_QUEUES to
represent i.MX6SX, it is safe for us remove FEC_QUIRK_HAS_AVB quirk
now.

FEC_QUIRK_HAS_AVB quirk is set by default in the driver, and users may
not know much about driver details, they would waste effort to find the
root cause, that is not we want. The following patch is a implementation
to fix it and users don't need to modify the driver.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 11 ++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0602d5d5d2ee..2e002e4b4b4a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -467,6 +467,11 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_NO_HARD_RESET		(1 << 18)
 
+/* i.MX6SX ENET IP supports multiple queues (3 queues), use this quirk to
+ * represents this ENET IP.
+ */
+#define FEC_QUIRK_HAS_MULTI_QUEUES	(1 << 19)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ad82cffc6f3f..98cd38379275 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -122,7 +122,7 @@ static const struct fec_devinfo fec_imx6x_info = {
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
-		  FEC_QUIRK_CLEAR_SETUP_MII,
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -421,6 +421,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 				estatus |= FEC_TX_BD_FTYPE(txq->bd.qid);
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				estatus |= BD_ENET_TX_PINS | BD_ENET_TX_IINS;
+
 			ebdp->cbd_bdu = 0;
 			ebdp->cbd_esc = cpu_to_fec32(estatus);
 		}
@@ -954,7 +955,7 @@ fec_restart(struct net_device *ndev)
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
 	 */
-	if (fep->quirks & FEC_QUIRK_HAS_AVB ||
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES ||
 	    ((fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link)) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
@@ -1165,7 +1166,7 @@ fec_stop(struct net_device *ndev)
 	 * instead of reset MAC itself.
 	 */
 	if (!(fep->wol_flag & FEC_WOL_FLAG_SLEEP_ON)) {
-		if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+		if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 			writel(0, fep->hwp + FEC_ECNTRL);
 		} else {
 			writel(1, fep->hwp + FEC_ECNTRL);
@@ -2570,7 +2571,7 @@ static void fec_enet_itr_coal_set(struct net_device *ndev)
 
 	writel(tx_itr, fep->hwp + FEC_TXIC0);
 	writel(rx_itr, fep->hwp + FEC_RXIC0);
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 		writel(tx_itr, fep->hwp + FEC_TXIC1);
 		writel(rx_itr, fep->hwp + FEC_RXIC1);
 		writel(tx_itr, fep->hwp + FEC_TXIC2);
@@ -3371,7 +3372,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 	}
 
-	if (fep->quirks & FEC_QUIRK_HAS_AVB) {
+	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES) {
 		fep->tx_align = 0;
 		fep->rx_align = 0x3f;
 	}
-- 
2.17.1

