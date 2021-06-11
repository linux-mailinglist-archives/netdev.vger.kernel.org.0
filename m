Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F633A3F7F
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhFKJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:53:06 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:42734
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230334AbhFKJxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 05:53:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKzDk6gE0Na9KnXJn7sOyED2RHmxFgSL9PsT7ZFN/WBM7Da9c7zIsXfYJev9xKqCsm15NzhCWGTXqHlxRl1xeDZGa4YRaJMKnKm3gyodlcuUmnBVLNtBOHQXl91zRFqEqBe7bQKNkZ0WxMRrXt3NC4vf/I9rydXXuTJVuzoICTE2lVLcFC6f6lLF3GO2IgqSh5Cngcags9OjYbwCAOEFpgTJwaLBjB9XD4Y3ZBWeBf5FJXD5Rw1rfzwCacpWJIxlr/zuYqOSt4+UbqJnU2bo+qFRN0PYOmG+HcCRy1sHb/GZ0y2uEcQGjrLtOKDG1jVekNquHSlT2N5qHEBPJbRoLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnTSPsImtecW9CGV7Y0P0sEHtZY7xWlte6cO0d5re7I=;
 b=I1hOjw/3z0Qli1O2ayZ34Rqm3jgTsrlfXvfTL36zNfQn/lGdHTJdIgRSu3zzT8Vq4AuUXI5zdq+gpAcD1ki8kH8eW53sW0s02ylJ3dFum5It1db8tzSaSyvxSvnby6eer7Cq1KXqcUqNmEIP4Xss/ms1ZANWGIO7qeVhNjWsIrx7GkFxn4O2fZvSYO9PyNwGqEHG6xp6YQ2nlQsLWBSdtEIyqInHW4a14o2ScZVrgvvSdRLOIB5EujHvB/IxgRO7Kf4u/MEOf24nUtwgbRn2bsD/g6jt+PhIraVI1+A4P7e9ILcBgfLgslsvUryA+3WVSdmoNCx748R35GD75yPw2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnTSPsImtecW9CGV7Y0P0sEHtZY7xWlte6cO0d5re7I=;
 b=M4YX/brhDVE1cvOGf1u2vHUUUaU074YbhMgi2/XKVZ8fBLaQViDtNARnAGdHN2/mi/jzJayEHSVt0KV6OkFvtVWWX4o5ko20aP5vrKnouY+81JpxtFtSnriCPOvAEClnRai6+EfVsfJBcgfBXQ9bEYpM4jf5gTTdfiD996W0dM8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Fri, 11 Jun
 2021 09:51:04 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Fri, 11 Jun 2021
 09:51:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/2] net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP
Date:   Fri, 11 Jun 2021 17:50:04 +0800
Message-Id: <20210611095005.3909-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 09:51:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffc3f374-9bd2-48e5-50e6-08d92cbe6d66
X-MS-TrafficTypeDiagnostic: DB8PR04MB5787:
X-Microsoft-Antispam-PRVS: <DB8PR04MB5787D35E5CFFD4D5D13A8EBAE6349@DB8PR04MB5787.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEdCkZrKkuQNn3fYoTHq5dkTtgwIdVd2K48F9u/XhgPnMn+wM+4ZFInmq1qPbOHHwH9wETkIA4AXxLREq1EThwPzkCu9v57lpSaq2ps9eDYeBQ09PA1K+Ct3rJN6ByWH6smsZMpbc/flfqrhymR4urfzsbJ9YIjFT2TxtQtcUtLvjr+348flHn8iaYdFajarP21UKP/CNAssb/2xeBdDbkp0BT+TJl61ltU2mqaCcV2AWwSPqRkUQ2aQ+KuQ3/ggRWPera5rvaNDi2zHToCv5fxMvSiHjQbhwrLNEcTQvJxKetEG1G3j0ZM9NPLiOVSQWfJfoyF/30gH3M3a2MA3/auoOczdI5Yy8GyxCo/Oj9RqanbEMwdSJP7wIqsnJqYQPoTq7xM6O+f6RzmH3xGuYe5YyAgiQnk22kDYjR+y3sW2tfon0dL87ijoloMY7RD1RGgZRxj8Qpzi9giwYWOFcxcgnBSrSreOv22jnvb/yy3X2it5V/7rLzyFJmDeGaXVhpMWYYQc07QaIpPvoQzyot6oLRALIrxZJF1VYEiYFKdVsYX5sE5aLLtuqTfs9l/eFLFleg2vNOtoF8sSG+ybQhx5B21thpdUc+AYJEeKNGG52yrDTzIhLUwm76/h8T7zuaHAGyKPH6hkvVb/eKb77Z0aGO/LYiDkeKMOZnQ+m5ODZ1U6g6kCXNCk4G5V74/5pfzIvJxHmpH9SSdXTWqaai2oeFxCsYg2g9PMgaKjaXWF9nDMEYvf/YRHkdPWrw3Yrpn/OZanpmsXGWb3hGBn3Rs5zSftPYHrOeAixUYfya8MQa5MUjeFCnHDU7o6yg+w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39850400004)(376002)(6512007)(966005)(66476007)(52116002)(86362001)(478600001)(186003)(2906002)(16526019)(6486002)(38100700002)(6506007)(36756003)(38350700002)(5660300002)(2616005)(956004)(83380400001)(26005)(4326008)(316002)(1076003)(8936002)(8676002)(66946007)(66556008)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5j8X3wZ+flBfSrLtdzY4HlnltGJXrDXBksMOevXRAFhhAxBP044Nh4/L+GJq?=
 =?us-ascii?Q?undClaOqY7KPBG6Xc9zxaPJlMEdcM1hzJYlI0Fqr4VvlNl3S+oZjv7C7NNUH?=
 =?us-ascii?Q?P6HS+AbShJtS361BzWIxaTOfUn0lpCMYELRJv9yIWIrveAtXFrIQ+KLEHdcr?=
 =?us-ascii?Q?KaZ32l7VQnyCEdVJ4zWi/NPueaJSdgDhtk+05OqaYveOzKDYK2YkF52ZrO5C?=
 =?us-ascii?Q?0Pv7ctnzPu+E0AC5ehJp4xWmp1enHHanrqg/j+VBNtQukGY+nIM1SRSh+nKM?=
 =?us-ascii?Q?ANQMTngoO/oN7pli2T8mRkCQWkG9kssSOZgI4r3TNGi6yzA8mR4LOPr+opry?=
 =?us-ascii?Q?c1sgnxtdB1U1/bb/n6iDt4AoqjgkCusMCRJbnHlA5DJjaup+vRBwvyK0k4Dm?=
 =?us-ascii?Q?8cfALh6/dwe/ccAPwebU4Iz7YUtnnUM5ceH5uzT5osdaIYSSpI8NQQw0R9qi?=
 =?us-ascii?Q?X6jFoYZu9AEY0gDajJzLw4AK0MIbccuLgIZ74eG/w1cZdxtueJaeupv0joQS?=
 =?us-ascii?Q?R3p/AyQk2sbXWxck6eGAn7f9ZeTJZQVGd6RrsWbwIlOfdFH/mZ7EVJIGeoKM?=
 =?us-ascii?Q?uTZPp344HTerUJkUHaokN4QwY1FGWerK317XWptG599mmlxWKB6gTB4xjgeB?=
 =?us-ascii?Q?cRggqb1H8wtgaUwegZmLIIJNg/IuOMtsuXhE3Fmpw2VvErJ/do7h7ilOWukq?=
 =?us-ascii?Q?NtrXyuf6DGMv4wKHJY6+6q+0TY16yMkhtCc5+LWZ916X3lUm6bm+R6MNH9NN?=
 =?us-ascii?Q?2eNgUIICd85j0m6f8vegttdqT43P8OjDF+bGrQXPCZEV7I30dIk9iSpPMhN3?=
 =?us-ascii?Q?NGpl0+1FvrplNVQSP1xjfOdKqOyEehfBHfVJpE1dkd+gkWCTmXGVsEBF4lmc?=
 =?us-ascii?Q?G7vOFNDWT+2RSPIU8QjFCnXpbUCOKK6/TB6t1bDChNdH4AtPpMe14JOlM0S4?=
 =?us-ascii?Q?6EtcBaJSq5PcWzfCI5QkW44VqXd46YVt5mbmRm8K+gHz7Cn9S2AQXAqJfTlC?=
 =?us-ascii?Q?KhaXLWVh7XT4y9cfEd3+FSevdJ1GMUFOhPnmRJlW+yxZbiaZUM40hOYCQEq4?=
 =?us-ascii?Q?m6U3umm3/DBqnR0v8PvYxjwCCNEoaHRLGs4yDq/6S15NHtGSWoCmebfYj9KU?=
 =?us-ascii?Q?ZErQKxRFKRH52FKYiLFa5vTjQuiLZl9WK0Ez2SU3JT0L/demHvT3gFPdRuNe?=
 =?us-ascii?Q?zLgqhuxpQYGeufXBOs4JYixFW/kCToSOD9wCnq170fkeGCZnFvKCSc/auUgL?=
 =?us-ascii?Q?rIlqHQZd1NsbKpfnS8jTHj7gchi4l3HY0bF0u3D2q97nPDhGosMaE7OkDEr5?=
 =?us-ascii?Q?8fAtzHFMxmpY9HAQJvc8iDZD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc3f374-9bd2-48e5-50e6-08d92cbe6d66
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 09:51:04.2975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/dbUyERkwr1y2Em1Ixuf0iofpkwLD1f3PN0nDP3K+jF/sZbZRBRWVnkQvYBMM+wf053WQD8ej7JGzmDpD7M6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
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

