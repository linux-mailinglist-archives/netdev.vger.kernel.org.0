Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7E670E1E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAQXw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjAQXvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FB84FAC2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+T2aAjMuJ90vdAt9cwcoytdi/sCVxVzVSNN/Q6k/draJWftFEebVgPuKoO2EnyBvSjq4gEpqjwV1+Mp+LGXemDozdTggPq3wOHurcGkt+Dfw2O0h60udCZPJpB47Ry1avH4iy30YKNAXMOb4d7vlnuoA39wuYdm4tbtXJDt3Zn6jAPp+wuHK8T9ZIjsivjsijXtKEOTX/6GlzPBY6QTOuAu+gsZ/rGDRyI6etWD9zROqW8RwVwLtU6Rhdkh5mu4v4AGoBDVTdbBkEWtux+9hDoH8woFnZh9Zb5vY3plDbKCJWM6F8OidSA2vPHzHuSc5sM4GMN+R6Gz9fsFyYBWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4CTMyRT1eqM1nY4JKGVrHw9wr+yh6CvUWsDxOSbFOLw=;
 b=FCl3s/WgKQinXPRetngWem+Vv/PYYlRWHA/MiP4OT9zYu/ageS/BSV7ToG60NOBcl/4JRP+KZUcb7f/vnJSGBsvrq9tOK4C1uqaUTDkOxQu9qhLdVy82iPfXbxrK34kAdvOZ0Y5JTdoFsiQA70Bm7FVAAqXFeSgn4KFSxBy5v6AywPEYR1E4Yeq7wJSjEDXiHvg9x+4f+IQfpA5/MW6yhXQoC9zqYUTUv5CGwk0tYjLWn9FsMrrMqe1dL/TSmn4MZYes/ROM9Q3GykalOjY0FUJ79FRUdKShQSF0oCiwKSlpTi/YaIwwlV41cHlLGcqdMSJasZuwpbGDmuxVov4fEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CTMyRT1eqM1nY4JKGVrHw9wr+yh6CvUWsDxOSbFOLw=;
 b=ct6R8aielxcUjuAs5YRmEMfI/goHx/JfQ1sUQfwceJEXHka/O2SCHd0LKSDRW1FQWXoAlf+C0wk+xDQPDzDubZUKX5xto4XgkWBCP7ewxAWWjb0F/ukYoDmJcexUXqTMkSEAWvaN0nCEz7pzuNrU8BItRwSXvJwYajLM2KMAbmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 05/12] net: enetc: drop redundant enetc_free_tx_frame() call from enetc_free_txbdr()
Date:   Wed, 18 Jan 2023 01:02:27 +0200
Message-Id: <20230117230234.2950873-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 61efba4a-7d2d-41e8-4f51-08daf8df02d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PIBkNMBlL3OmeQ2AfXwRYupXZ1VkkuPkeEfUU5DNRsC972sf667j0BCKXO6D67YmcwdKfs9IqxRy1tYfOrn2uVVP4LNucNbxIG12J35wdIpwgRQ+cDuS1qcrOcyceKWjNbyJ/h7w0rJ2x6l0WX9A2Rqjg15BdbgNnoAhhjRjTQUOWexzer3ugsjyenvFSiZI3Zg3cjuCrAM7yaHMO5JXKiYTftjkPMzfoFE0Z5UqczslBSHrViTvu8+VWt4ODtBJq2dgkcK+16swaYSblQ8xvhWCx4tROXiVBprKQTx21enMQ2X4/NhbIyp/P0ttKOQxFmr077Z+f43yHOJ0l4BiRAKUNWYXM00u9LKVcAyr7ZZAqd3rQqm+CmQGh/+lfVEcYPZ5mdpy6JdPcoAkjS8UOR2D1hQ8H7F1wRoOJbWa6Cq6jAQOpsCnm6qcfN+MPNYsPFo0++Pq37yYWW844vnJHfGXfTdYTEdmJXSqde+pYS/CoRMeW6hS4FpufO2eqnNmEQRXelVYULSCzZTW+MrDzbu9qW+eB0UtBiSkqzO6OGVH6zDMWU0E0nLSpyyRlS7ZHzpuolIRSNT6BDABl6Dg2djXlrDoIn95Bu+vB0721TyCKHlStP8n5LwfkEykZaLTOItk8XM5w4yyvawO5520zv/bPfDIfYeXsgvuPBwtM+Tcexov+31g6g7/uu8mhCpwlgUzIf5OrmIif0XZijIX6d6r2aGiDwKRp7EQLwVUg8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(43170500006)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jALGtohIK/LLcPYqdx04XQ8oVLDMio2rUALSByXwXkJjv2I6YNC+RvPAy45p?=
 =?us-ascii?Q?b8aaKrELTG28vHl4Zuuj5+4odtwS8Q/crlCoTWLDEgwxGJGN7PhHvzfLFeN3?=
 =?us-ascii?Q?L57Xu7AK5BWIBEHP/gV1V4IyzGWl0ecXA0ZCYplU8gCKu3dDY5e7xOKKK1Mk?=
 =?us-ascii?Q?LFt20Upj3HTS1ipulrskz8W7slI6g12QP9BuaoBr5wz+ZuK7oI4yZUIfTPx5?=
 =?us-ascii?Q?SgiAn7nE6DpMiCteGI8nIZyOYBVsJ8NeuBFVXZwvWEvEajpq751+HeV36TOq?=
 =?us-ascii?Q?amy5EMWnVg/AwxGAy+koMrzvzZC4x3w5f2Pl6Ut69b1XAykzG22B1jytGsLX?=
 =?us-ascii?Q?cWTKFGb9+leCO21jBWigGp+ceifCG0a4ISOF6wA3NPuUzdPH/Sjjwa1n45ae?=
 =?us-ascii?Q?77m1bc4DAiqMptmeCemFPAe9MSHF4kMYJ//n2ZxKl5mvMWm4+IZOLEtaMKWe?=
 =?us-ascii?Q?Nbz20swyjncgtLW/kWoTvVDyjS/KTCWvkBwhhJW8jl+x9KMPQWrRrYAdqH7M?=
 =?us-ascii?Q?Vs4GiIYe5nk8BtVDmG0nSuPDKvrmjkd2zCEfQmkzmctn9CF+7Ap/EZxf1xX1?=
 =?us-ascii?Q?GjyqRv5eQlLYKKAPNOtdAxOGiWBD+InDNoZjEgeREGUbFq9oL23xq2zSIFWK?=
 =?us-ascii?Q?ehZmrxVMxVSzhsHlF5SbNCgLzX8CJh/0lc4+OLUdNASc2OOfjZkzOpwSLviO?=
 =?us-ascii?Q?5enm/sjq+URCPrwyvgihxRCescuoPxLgPKQ7BxwSRyudp2T2MGSWa30VcTXI?=
 =?us-ascii?Q?oWolUA+sJN9e80WFF+95+DJG6uZezocd2GegyzHPFIDJzxRg00aiG5ZAjLTM?=
 =?us-ascii?Q?mSIvu/VJyGSylYGANWp0Mvi1eDSQSWhgS+kLVXAtye3tEqfC9q5ytgX5SQIW?=
 =?us-ascii?Q?vn0aF+TDLK5T3Cxv/Szd+VNhPkeIyYE7Ba8QID7a8S9IytTJOTeNddRUOeQg?=
 =?us-ascii?Q?ydjYUgqAk/cacc+JzHTYtDyWwi4/3pX+HrAAkwDh6i2nPZ2O0b8TW6J1rlNG?=
 =?us-ascii?Q?3NRm+miXDvcpS7E2CtHMyffa0m+a7ACWok6lVaEkCQjnvm9/FjeCzo/YTjGV?=
 =?us-ascii?Q?//vsK8qpE8UF2gk4QGyBzqN+uIZUonidIvATEDbZ5hSDBpOHkasetqwomAmo?=
 =?us-ascii?Q?HjPv/WWu2JqsxgUm/owE0ldRn7rgqHODz937UoO47uMZgtg+1UW5FWytLjO7?=
 =?us-ascii?Q?qCmswqvO1FlCHwZVMEc9LrWU3WGZO3E/DJsDyMkxcEIkoMgWPmYpXCfwcb8g?=
 =?us-ascii?Q?ft/acgnvR5JjDLnbrHh7fqJQZ015FC1OpoA6G6fdQTEILgjStXRJpGL73qWy?=
 =?us-ascii?Q?vxAdKqhLVQd7cOdiHooTGl73sTBGi4Q5e30hbJFlckUvZpF5PF7HsbTwuWpO?=
 =?us-ascii?Q?v+H/SHbGc+SOsrHNKENDGdO2B2apTCoJti8DWL2GBrvRkEB/X6xnfXolbJcu?=
 =?us-ascii?Q?uq+hqbn85F1ur/GDZjXsKY2zX/gxMY9v/taXKes65lLk0qDjRfjBEcYVk+U7?=
 =?us-ascii?Q?g0cUA5Z6sqtkx6lkU428g0MyPRB5TLIy1kSqQAuBKbF5XDpIegOC0IXrARKp?=
 =?us-ascii?Q?HJ0FvnUS/vy3OSELLiOo1/WMQunABRDzVXljzN3rREQn4CA5D4YxfmIZLown?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61efba4a-7d2d-41e8-4f51-08daf8df02d9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:13.8350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3ipN9UfBrb8TuEkWrr9/7Njuj5tfOEtSyAEKjf8ZXSx+Zbi2qihyIaubKX8/1jYvs8DGIbp+h8ssNfAA599yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call path in enetc_close() is:

enetc_close()
-> enetc_free_rxtx_rings()
   -> enetc_free_tx_ring()
      -> enetc_free_tx_frame()
-> enetc_free_tx_resources()
   -> enetc_free_txbdr()
      -> enetc_free_tx_frame()

The enetc_free_tx_frame() function is written such that the second call
exits without doing anything, but nonetheless, it is completely
redundant. Delete it. This makes the TX teardown path more similar to
the RX one, where rx_swbd freeing is done in enetc_free_rx_ring(), not
in enetc_free_rxbdr().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f41a02c2213e..94580496ef64 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1773,11 +1773,6 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 
 static void enetc_free_txbdr(struct enetc_bdr *txr)
 {
-	int i;
-
-	for (i = 0; i < txr->bd_count; i++)
-		enetc_free_tx_frame(txr, &txr->tx_swbd[i]);
-
 	dma_free_coherent(txr->dev, txr->bd_count * TSO_HEADER_SIZE,
 			  txr->tso_headers, txr->tso_headers_dma);
 	txr->tso_headers = NULL;
-- 
2.34.1

