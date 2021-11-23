Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1789B45ABE1
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 19:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhKWS6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 13:58:48 -0500
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:24470
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230026AbhKWS6r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 13:58:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpgqdB9GbsOZhsp9k6MQUTg4Cw87N9FH1/OpcKnPkFbe7qmk9WTIDTTmIH+vraNH4eg6ZJJ/JcR9laYExU3JnUM8CFkCmg/x7j3XHEcWsRYzhWVWdwPA1/QL60VTXuFWsmO3tRXhZiAuExTj2bKjl7AlV9hoqts+lC+lAjAzA1FT7WLR2Ap4cj3qlaNpqA9APu3beh/Eyd2HSIfSxgg2iD/zMGcbfugKaG//Tii8/M24keaH6TM7rMx2dqab1DyBwoO6xj3z4+2cm4BvX9Bmf6UxhQDkmfzrlKC7k43T1kCbbnSz5e/amb3lFwi4nazQPAPABevzcoHtSjR37hYklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v14jD8CoKx/WexifwqMs2n3CVqxyMvz8fsI8O9THTps=;
 b=LE3pAfquWvN2lNIUp0UhoOSSj6NK61sKzmRkyAaqaoSkVdf14WfCo2GsgA9xir1zvlF4/YYdqldYOXULXebFLuuK8ytGU5cIU9MXkK7OkMo/p8e4oh5XjSnR2AFjcHzaY/RqpKAn9FoZJQm0powur6HWss8KFhwXXi/Yh4gGIgCwM6gqgu/BGNvNdQDzzdsFxXu64qJ6smhRYt201R0zQToEwNZ4yfGtkKw5ma1Hk6+s9EKK1BeIxP9WUTCq0gAiOPkcXxZhYapznHzgDDFFkku7UZjtwRJ0G3J8SwzMxtP4i66LgceMsg59hSlZeY6TrgO06kMTcA1IcWaLR91Mhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v14jD8CoKx/WexifwqMs2n3CVqxyMvz8fsI8O9THTps=;
 b=SEuyCAJfPAYQdRSxO4/4Z5CuZWcGeCEVwNhL7SorBpk4lpKaFqSJKpouQqNxExtpJ/gPoG9Yb9/WHCR1WdMuANovgdNM6C7+Jc87KG+Ts7fOfEP27+SndH6HpivUiTsOA8RUO+C9Sgj03YV+OmUOQNnQQOUbk3MIS87H4inYcm0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DB9PR04MB9451.eurprd04.prod.outlook.com (2603:10a6:10:368::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 18:55:36 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::59d5:83c8:cb6a:a115%5]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 18:55:36 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring the interface
Date:   Tue, 23 Nov 2021 19:54:48 +0100
Message-Id: <20211123185448.335924-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0145.eurprd05.prod.outlook.com
 (2603:10a6:207:3::23) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM3PR05CA0145.eurprd05.prod.outlook.com (2603:10a6:207:3::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Tue, 23 Nov 2021 18:55:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38c364de-166c-4909-3a6c-08d9aeb2d557
X-MS-TrafficTypeDiagnostic: DB9PR04MB9451:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <DB9PR04MB94516742A1F5A53262C6994BD2609@DB9PR04MB9451.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sX26wpPrp8No++OywKn+FL960Hem3WM+9TO7cN9FeKKO9G+kgUW7QOkbCAAH+1Bcas3zZBagfxhcoWf169uAziyiAwad/wMGaUHJxr17zeV8gaC24JLbYAkSgbZ/YFLZJD/t7m+m9ronvPhduExovUN0EVdKi6If1NP6oll6HoXy5NV6AyHa5YuWnXTI5WQ3k8W6f+W4VfY+kKM1cd3wDoKDZSD5sXjoMH+sPlRj8vQnU4M5/JdYvIORVi0NDm9yh+/s3hsJIoaAi+qfMf3k0JVJujdwC1nCekESA3OSLXe839+99OxBbnldf9CHgnpqfMt85bp0NU+A953RJbE7T/Rcax4TJDiFqL8JSegVx4EHhm2YNLF5Z8e8dyVOaR5/9M1IPwu47PL3EobqnOT0ZK7Gh2Q+9Bl8hNK1cqqmig5Fjmo/mUDWPYL5Mhbzx1yR9K57jPy41zE1KVVSZ2wqVz0O86NaBHOyAbOjplb60QELyZvsZcPSYX/iMP9gJkrYRzuAY/GRhbqA9nuCgKOcCGW6E465ubJXvtOrv4YqjGvsHvJK9wMvCn1eCHPXoFEOyx28V8mbW/ohYPCBOLq2eDZryYb+mvZKcHinc5+TvizMKePyKyKOT7YSDwydDT+Z90Skxad/hOrCvyQs7oo9pfAp3oNHAdTwnkeXYUzg/6b9SdANOdopT26sdHQfwlUEOlomjGwZokefVdcdeUYxkuColstkeBzAVwMHFpAlPk4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(316002)(26005)(4326008)(508600001)(38350700002)(186003)(8676002)(52116002)(1076003)(110136005)(38100700002)(44832011)(6512007)(6636002)(8936002)(66476007)(66556008)(2906002)(83380400001)(5660300002)(86362001)(6486002)(6666004)(956004)(2616005)(921005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XVs3ylZiEHvHk2xvxg3zkHuzp5jSaDk2tUbxZjBN6o9Ch9JLTrilztAdTgqn?=
 =?us-ascii?Q?WRKgAwVMup0+nRfdJrdi7N1b3C+apla/HemJ7vdKkexK1GN5hQV+HqeeDpb9?=
 =?us-ascii?Q?lZlhIpL4x9rkzo/mgvL0V2HbXixYZ0IDZ0FVQjRSkUW7nTAmNNyXKoiq4U1e?=
 =?us-ascii?Q?+vW07ICLCwNwmjDrfl7Nhnu/yjqeVIpLh9U5wOGb/4Q2OzASmQE4uo5pxh6i?=
 =?us-ascii?Q?/q//FOjMf0Yp6PnnHI+3rnDjZM/Lub0EJZ8zdEG2IcMoC9GPUxGYcpU1MFp8?=
 =?us-ascii?Q?tlTNXvI0YNksFkPTRS/ofLGcDnYsP4MRqGzssHqGO9CdJmvR7S3km41S4zhI?=
 =?us-ascii?Q?0qjTWBMnz4x9CaREOGaKw5jXfr2gADZXGtPdhw7se99KQK8t38Ye8bLNVfm5?=
 =?us-ascii?Q?ECGI3j595NmLKca185tyG/GPYelr/fYW8h7rmdPs/d0T1D7zMigTkgb/6Ngy?=
 =?us-ascii?Q?rIMBDiB6KR8JieJeGFe3WqFjJXHop1aIE4N/oOorc65/jM1dGZY3oR+lNpF0?=
 =?us-ascii?Q?loFYdP04N9fZTiOrhBttKY2OGwmAsVyqhPNV+m6HCoCAxTInnG0fJPUqmvtU?=
 =?us-ascii?Q?ZFVsRYpmXLCCIruXF0SAMMyYQtXwkGr7zGfeEFcqNH/Ulb0CP8KHlED8uD3C?=
 =?us-ascii?Q?RoBO7u564DknsZKH5CX/2qvenF4IWJGLLixRi9bOX6OpknUzOlroLquOBdyR?=
 =?us-ascii?Q?9Bk46d6+JqQxck4rdorSOccIR9Fd3JvTKCOKN1122bp/Ebo73SJBLyfyp/r5?=
 =?us-ascii?Q?BSugRz+HHbkNIU6a/e0/SVdWrbecnKkrQdR7y11PocAoUPKeXkgGAw8km/F7?=
 =?us-ascii?Q?Ptj9jRm7e1ONPCSU3kvyL1PV8xD6r8ciwYjMt8OsqAgzy0Jk8svyAP+HsLz3?=
 =?us-ascii?Q?VbIni/wwiNO1BID3IQRJXluhtnb9wMF3p6jQq48kh57i1W1gD6cyaRhaikPu?=
 =?us-ascii?Q?J3rgVuBDWq7naGvtzXPjn9k4Sq22cWiyt1S+CxJWB+mqlQ+y/iHlnOBiGnXE?=
 =?us-ascii?Q?kmUsh7pCx3uKKIggqd8J8NQiDFMpudAocMDpe847/0gDIuITUbqeGISOqfXm?=
 =?us-ascii?Q?xy3FiokXc3Fopi0vpnfugHxNLzjpWIXvhkvQ4NoyvBbv8+Q5u7bnW2ZcN1sd?=
 =?us-ascii?Q?F11QNRhPtEQQ1JPp4l70A9L3dMXg1KWzuLr3EdVx3G0hQ056psfdg6cqn+wS?=
 =?us-ascii?Q?iEpVHlGWCtIURPgN4vqhODmj/Ypc3LlOfR1ZELKVUIYNTnarvPB+PnT5A7sQ?=
 =?us-ascii?Q?VVRUiopZciS6h2EF2MQ82ruJS/flj6jNDs2/7YsvA/XBNHRFdxmUklBSjIAV?=
 =?us-ascii?Q?zR77iMKVcIZUc9VSlumkZqJ2GQD7V38GHCC+CrzFEyFW31/WH9FwgzhWlFmG?=
 =?us-ascii?Q?kYAA9AEyQ3Rpli29ApMaXKwpubXY6MyN8f3JU0uZ0hFAHXU9nXiJ/0gxywPL?=
 =?us-ascii?Q?s7fktJI/9r7BHXIWTGdd7k3nk0qBURrIhBmSTZ2NBpGH8VU6WvguNT/Z0T6r?=
 =?us-ascii?Q?FxTxotYnilzgbixB24FG4JF8QvFJ66BgN4CBB8RRtom4UOMwQuAZtXPXIx6j?=
 =?us-ascii?Q?/t8IsmQQRw9YyMdiq4+73GsgDDPsYr+QAc+VWGnDjsSj/o0vb4gLEULQXgAj?=
 =?us-ascii?Q?QLlowgFBgC6sKVYd4qneW74=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c364de-166c-4909-3a6c-08d9aeb2d557
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 18:55:35.8083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9/S8Obdz32SKEL0Fd5CiHQyCyTcnv7qwCe5vEOQdFuNvULa3abi5YhGTaPEhXF45PKasL1JKfFcrWwi6mt4CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9451
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

The Tx queues were not disabled in cases where the driver needed to stop
the interface to apply a new configuration. This could result in a kernel
panic when doing any of the 3 following actions:
* reconfiguring the number of queues (ethtool -L)
* reconfiguring the size of the ring buffers (ethtool -G)
* installing/removing an XDP program (ip l set dev ethX xdp)

Prevent the panic by making sure netif_tx_disable is called when stopping
an interface.

Without this patch, the following kernel panic can be observed when loading
an XDP program:

Unable to handle kernel paging request at virtual address ffff80001238d040
[....]
 Call trace:
  dwmac4_set_addr+0x8/0x10
  dev_hard_start_xmit+0xe4/0x1ac
  sch_direct_xmit+0xe8/0x39c
  __dev_queue_xmit+0x3ec/0xaf0
  dev_queue_xmit+0x14/0x20
[...]
[ end trace 0000000000000002 ]---

Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f12097c8a485..748195697e5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3802,6 +3802,8 @@ int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	netif_tx_disable(dev);
+
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
-- 
2.25.1

