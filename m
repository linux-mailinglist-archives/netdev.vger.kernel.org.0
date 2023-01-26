Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88B67CB4C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjAZMxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjAZMxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:53:40 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2061.outbound.protection.outlook.com [40.107.247.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FAC2B619
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asA8SJ0Uu0QQutSFRqKhWScgla090MmEw8h9W0uuyFikdWAdcE0DNaVYOQGR0X8ybF0DpHmq0Y9LwxiHV/vXq7fevImautYHXhEbWfAAGCX+6hx+7nEW/IgtXywL7Q2JBlnbQMJyF9FdVS5Kqnu3YOdy0eDeH4IR75g7n/W81MwiT/eune53A5bf/LcTvGEBi9OR7xbBulR02iWLnhOsRvAxiM332uwL5oF+DV8c6fU/laT/cnSLeJ/Eblwqk5FDm5Nxk3iOSv7Hdk/dp4hZf040Znip4+JuSBeMw/icxXpGY+1qYHgeR42ajCYhSiJwM2BdTSnb25ki5Qp4OSRTjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6oSbk28IqTzQyLtqioc/vfCkbFIUAaInlbF+vYYFr6Y=;
 b=SgUbi4wmC9u+T2iIAOncqnxum9EJ8QOcU1e9L4IGC2RuVrgWYJhpXr5ltj0gb8fZRY50EFIHWmEvpnXpJiCYeRdOiYF+9r0HD+JqkEbOv39KG8MtwM6iALlLqstN+owNkEt1ZJo229MUNkwQIhdPyKXJ6vBNaPvLJBmpHTS2xIEfKgPbJ1jw1BnsCmZtmtN7nKkjQGY+h99nmWsfG7+t1vqlmdKW/wXxiTtqbq1/fWDiuFDJthoF6CA240zSEiDNN7BO9LZB1eM/aLbIgMXpLqOmMhKj27WfAQvdEGOEfR0pgWwZE0boOkvlB9ebZ/3Wg5pagRamThAfhq1TW2QVpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6oSbk28IqTzQyLtqioc/vfCkbFIUAaInlbF+vYYFr6Y=;
 b=RlXuVx2ZYwYMSSxAsjQ4Ua1xdhTt+N4I/fkcn/bcpQFI3zVSJizoqcyD1mLLZKVtw++QnLIGaCgZMXSzRoKHbabDyWq9SIZSiNl6EsoOEqt2NsyOdDaepu0C6o3LeBmWByY8wK5+YnucX0B3kB0yRRpmzyrCP1KVfg1WxiLoGIw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 01/15] net: enetc: simplify enetc_num_stack_tx_queues()
Date:   Thu, 26 Jan 2023 14:52:54 +0200
Message-Id: <20230126125308.1199404-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 366657a4-7c30-4b72-9c4e-08daff9c567f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3yFwx9jXMMyeFcQEwyHpGktDGmBsscy0KVdAp4AV8/CEaJoAFEV23OV5paz6qRRzO3C7NY4zurRivXiwLsUB478WPcCuj+kPTsYai6mqy65pDrRlrmBPegnK09OpwVqEyZh3GU4IdJhryXPRbZd/39owYV1RWZal8Xsu/ofbdBnwWudjqdSW0+NyaCVDP6ziSkBY+B1vM1Z+1rMUhZKblhtpVPSuVtcdOFQDpXbY02OthecVni99wTgrwPkW/cahCcFuqjCyvFbsWDArT0aAY2VeHUHGg18ItuZiO+Jzxmyy9cnzEHLx3pgaxrfntViqVZaLYA4PAo/sr4PtVzFzI4Zvm2+2qAUYLKQGfTsO2YfPP018Y6pbRbCoIMEbgujp+VBKLWfPRmLrhvKLfWawSqcjXSb8dFdBAg4e4uOzP184YFIbLDZTyFKwHb4sgrZtlreVg0VmrKjr90KqYdSvBR5QnCqURpiGGpR0XCk6kvOpMPX5Y8hC2+V8v8TJSFmxzwtZ8o69tMY/NBRlnQOL7/4dAzuQvAKdwnuGFsVo8ZMs1nIMagQqTRn3EvQygG5CyAvqrcqwBFGaUggHz4SeAlovq+RDsh/CPnzVtOgJlPN0cP5kkGQY+dGIH+1PN6bklDGkZE3cuwZUacEO2Q4eT2bfFi4SImlNNnEIEFiD+7TkyhujrTWh0Pz9xg1KEBOB/D4TGy9h/D1Bv/VQwaq4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ge7/zax7t337wMsRdyni7mbohBdaN8zqwXjWziGsG9YtEfgmD4U+5hABV5nX?=
 =?us-ascii?Q?VTQBGuSEzIc0hGu0kdYDpCoRs7tMJeg2nfhQ6Y/L+ipghMsrU/sIA9VD4Ok2?=
 =?us-ascii?Q?hPt6Z3Gly1TA05WBDono+7n5qVsLoO5Kz3OJtLfTUv9CCQ94FSgocLlkhYT1?=
 =?us-ascii?Q?a4seeuXCu5cQanYgWvv2SaSsu47znNrPpdvB2Yvx3tFAsvNKegvKhH64O/iT?=
 =?us-ascii?Q?Zsng7VIr+9Er35EdQjQ70ZqYa/pUkd+9O9LcitYPrDx0q4TLrADKhO1wjBU5?=
 =?us-ascii?Q?fwbzFC2B15jdGAVglzUL8gEdp2L3UVFWQSPpqV1/GCrC0r7YRV9e2eqg2VXQ?=
 =?us-ascii?Q?5cVk4y3c+Xoi87zN4lfrVJYL7UCKZIRTx8xXIIShDYU445oNtS2ADwcYHaOF?=
 =?us-ascii?Q?8j7XCtutYE9fQaoRCDh2cWN1oSyseiPiRAGr48pkRgYmEC/wg0aU/DKslbVW?=
 =?us-ascii?Q?emr7pyoAHNq5y5qNV8zTwPapK7UzjO4NfQkonLNjAtiDc+pucxAFygXn7asD?=
 =?us-ascii?Q?IbnJgRsaXMd4mM8XdXHyZ6TcD6TUl1eE+17nL24UQHkIFvMuhYeLJ6rZuu4j?=
 =?us-ascii?Q?kJARg7CBrXNpKIRbMfU/DjEaiPBVkKO0yPdA9MAiWuTGOYL65G+mBEmbobbO?=
 =?us-ascii?Q?gCa2z0ARh0Ls+p/1Yhz2Z4jNEDxrST8fZSCt/mDOqZ0iS3kZYVloUTvJTwRG?=
 =?us-ascii?Q?QdHPTa4Eq1jtGX4LO8oa0O3fvODZJeUueuwsju42CvQ96q+J+XCqPJlaLCy3?=
 =?us-ascii?Q?F9wgHqC4nZSGii+Poj5DJy8CgQHIWC5JHajqdz22WIiTYgQ7K4lF+JDWHSgx?=
 =?us-ascii?Q?5+H7OpvyzY+bSYX67dTZpNP7Vw16YnvD953NiAdFLTfgYo5xI6v2F/XhPdkN?=
 =?us-ascii?Q?rVX7aqUXAX73Ft/wMB1ZjMHuD0LKEJdib0Pb/bfJ7zDT1byR3MqeK1nQi07p?=
 =?us-ascii?Q?xA2OoO4BOsDu2VW5kNNXW6rKycYMELaYPwNvuPtcIDdw9LUfwjvv0trw3Nos?=
 =?us-ascii?Q?XkkfBKmGg8c3jYzRF2wo8E9N/Up7r80G0bYi/PwK/ihTT8JENQ3muKJxTpha?=
 =?us-ascii?Q?/QLkelFbBTLRrYG/NMBn7erj6bKh2yA3UlK0Yb0byaod/0c3vvT2nK/9qgq8?=
 =?us-ascii?Q?Ns/eBHYDwzAqjKDotlGGtD89DnMZtTCYhitQrI7ZXJC4c2zvPpu0VVfzLfqD?=
 =?us-ascii?Q?8tVWzCbDApw5HRAr3+fndojZNJZoo/aAPHMRVVqRBn3cJjQ/Cl3wo+YaCt+k?=
 =?us-ascii?Q?Kiyz1JmPDz9srQJ95GzMTVGQzBiBGbhf2TOT+MUSfICyEfKkI8PDjuVtwr3q?=
 =?us-ascii?Q?L3hY2FgUsA0G3aX4wT4pb+IPWsw3CQuSEn/XBzdUQ8CveCyl73uScRMsGPsd?=
 =?us-ascii?Q?QE4rWR46UK4TCLkNCgGtdzNJxGQ8VxE+JmgsiN9l7500qsk1EAG0gRJGVljL?=
 =?us-ascii?Q?KNWNloC+9q+fyYRgrtNi8DeNAK08WQXipZvXfHeE6rIRkVCVCpvamoQyH5Oq?=
 =?us-ascii?Q?nspzyrTI7uvIJexhgd4fdoBGj2vIDQDAMwZF71UIL979P5MRIKrdr89Jk7rp?=
 =?us-ascii?Q?2yi5Zul05gXqFdx3eNDLr+sJErkJ7UcdrU3JsYxyb3Gm6eRjGnxZeP9ZVDH7?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 366657a4-7c30-4b72-9c4e-08daff9c567f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:36.0187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waNmuXG+85/ZiT6Xnv4GGBfy0FJgshjlDVYldU/g2uHJp/5VsP4WRMJAF1+2s6m2RwZ2y4uPxRkNDmkhs7N4Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We keep a pointer to the xdp_prog in the private netdev structure as
well; what's replicated per RX ring is done so just for more convenient
access from the NAPI poll procedure.

Simplify enetc_num_stack_tx_queues() by looking at priv->xdp_prog rather
than iterating through the information replicated per RX ring.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 159ae740ba3c..3a80f259b17e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -28,11 +28,9 @@ EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
-	int i;
 
-	for (i = 0; i < priv->num_rx_rings; i++)
-		if (priv->rx_ring[i]->xdp.prog)
-			return num_tx_rings - num_possible_cpus();
+	if (priv->xdp_prog)
+		return num_tx_rings - num_possible_cpus();
 
 	return num_tx_rings;
 }
-- 
2.34.1

