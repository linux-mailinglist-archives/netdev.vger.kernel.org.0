Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF911670E19
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjAQXwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjAQXvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:54 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20E34F87E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVAI4sXEWjeeXNHuHr7ElBCBJcMKpS8zR/8i191+iCko6LZ5UNLWoTcadvmL2N/DzmRUUeyPdy46hEbaQqQs98U2zcO6ZfVV92bGXsDDyioaKmPMU8C8HA7RkkBC6VYQTkLcINyCxnJs2+czUFLIfYJ67dTMbL8vxQLj/w4oLavG1408TktS/oeZgY6dsGH0hObz4pobRdKUM7zne18Z8hajFrPTmp7pk9QvW0QBtqmy02s62KwmYAhXVF8vs9VLb+cJYKciewLbnQG2UwdrSsMLUmpvI3Gop8b+xSsH3dODsLgjak4XBNh4CMcG8PWrMe3Cep2cazJl5AFEhw9piw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dW3Gs7BRrxESqAW7lEptUVr/SYQUMNi5I8/NdGIEGTA=;
 b=cqqWixj86d1eOOUic9vuOXUTLasD3wWDkJuHDKXa3SAW5rfw8TUKYdIu+x9DdlFmo84FvuUGt2O8QwLVJLGhXgpsLn9To7bKkrCGW0OUw0sAyTJbkqbe7BAnGTGk0kCZTyUPWtGVkYpUl4RzOu610/0+bkMbFEsM2GgZIq17ezaUB4UY2Vd2B3q6fkSpePM3znhr5rUREpWE43b8p2hBSe8PjLYxZT2G5hU5Yc6DZ0UutROBc6u+tbcJ1gvCJYkXRMEsn9DsURo/PwOOKKZcmdeJXm0TQ4ddxXV8hKJwP3YDacCFcgEv6RClkgvyC9mbJTPZqF4ntz6rhN+7E9xQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dW3Gs7BRrxESqAW7lEptUVr/SYQUMNi5I8/NdGIEGTA=;
 b=WpTHwnD/87OtfD0xdZ+oB8z8xZRrKXIk3KtBFa+7w5KqFGwJRR+VJv/V16V++I9VcFYs/WqRy2w9z7N/inNVKJHT4BAj5uiRVtTNugTZ62vbY35AhNFxxSJ77Vg9YLnFVdxBmgWpGPFAI9EYXoKsbLm6waXVF5Nz9gSP+DOU4VI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 04/12] net: enetc: rx_swbd and tx_swbd are never NULL in enetc_free_rxtx_rings()
Date:   Wed, 18 Jan 2023 01:02:26 +0200
Message-Id: <20230117230234.2950873-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 374be3b4-4031-4d89-bb9a-08daf8df0240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXDloRrojg+NdyHW9j3XanQWiusE0ks86BT/SW0xPER1MoRtc60dovgsovHQkhcEN7EDuMQZYqIo4x8J+JuR6Ho5zNFM19jPCJqTIJgfdOi4VYBajjbAuCeVyF4vjmvf0KsUMHl+4XX9gPfqYzmE7x+FcIpYBygTihAyvptozzjWMuMxe2EP9z/p45IGpuB7iGrlfE7JhNBPK383jJnltCJOGnamDyvw/VFtsPL8LOjxXKxrKqPZ+j5NyYsHhhdEsaulp4GysH/4FQgE7kOOn/iCFSndu8U0yC544bL8W+pykyLhKras4xxChHQqqsr+/jOOMbqVVDSdv1Cpmc4XwTPSw/JokfKB0yNMJzYccsALccWwmofIfBOWSNW474cgfNjZY7irZgiWftKbNJ/NEtb93wjq8be13jVFKfoLN46LJdd8ZuBtd/Rfiv3JLgZG6hCjM+YWsGKXHDeNL60SHCns+hz5dPgjgrwjX8W4fygPgzHTq2oP55/AX3kM4nZUHNKO4xf64Vizrqfn+6rmV1rhP9l6LbVMEHYQ9qiJfZqALO6TOzTIXG9v8Aho33ZfEikMlb3sPj6KwE2ioVA64YhlHyQ2EMdOloV+xnNBRZXWJ4jmTVvkLaCXXBOEsBz562IiJT4Nr4DlLEMJCJB6wZ85JsCGa+nZKKQ4FEmzXZSHLL3IfflFDtTK1HYXURXCuWa5HgxUv0y8TcK7zDoNxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mqCBR+9Ek8fnK+DjKbzklrzuwutVgm6YlMw9NiSpdxwu0v/GYZBxXheupV4u?=
 =?us-ascii?Q?M9xiz/ofZMiS9wymmjdrLjmOqFs9s3nddMDP/ooSvZhFwWUZ1q5iu0nsQxfk?=
 =?us-ascii?Q?vH2AwIYZiDbMQtsSUtAuY8mmzuTc8DCbrB3mTDriGXTj4cz0RzU65m2tBQKJ?=
 =?us-ascii?Q?fRe7HgMMC0dOWWerhXnMX7LYlr3qzzHiA32a/dDteBkLBVRgCVh8tjdUo+Pj?=
 =?us-ascii?Q?bFOWsyEVKe7yN2a2XJ0XDKjgHjBaOb439o/huPhR1U08sJeyDLiAfsFKeXbp?=
 =?us-ascii?Q?LdR2ZFMW26OdKadD6+qOV8Fg1ElT/2XSa9I2n8lof0WTgHfOsiIE0JJ9HPEj?=
 =?us-ascii?Q?JRVwPZzRiYZVRDAFNnjAapswPuNftawHZf6Aaa1GwJJy//5JTYisSVeLsWOE?=
 =?us-ascii?Q?P2HSWyznA8U5EkbLachMiZ7DsccofqPANa3P/NzBjlntSWbfm8Jh1so/RTqo?=
 =?us-ascii?Q?voZSqoYKaxPDiv2U2lMKk2PpOzfPKt8hw2kB3KCeScgZ84LBha7qFrPlZcYK?=
 =?us-ascii?Q?SIjMWOanE/ni5qALg/ss0CRLyJMKS0UnPJKVqZqcIOVSsmJVF22aWdHb/WVG?=
 =?us-ascii?Q?wEF4npBvxrAUtpuK2nlzIFeMZxfb2eF2xRkcV0F0hfvWmoT8SY073kQYS+V+?=
 =?us-ascii?Q?5l2jYh554yWgmS8sEMyt+A3hLrSOon6lzJVwNNt5ykNjUw7LGq0NwuCdYYME?=
 =?us-ascii?Q?wb2Ggi1TW1/id7sN8zLGM+bn62pUHhfmYEk35otp5i/SQPHxtjsRDVTUHWAX?=
 =?us-ascii?Q?UwYbj/Z8Algdbb1ws/3yXE1RmhKfa7UUIRruZsYSzRUFep17t5qtN3e8Yt1w?=
 =?us-ascii?Q?Ef1X409biVyqSUyVjUhUyjjW1GPjaV+TG6A2sEFm6LZ5dM1KYw7w8UCTDZHL?=
 =?us-ascii?Q?tcNdaSYw/T7pEMlmhIVZOwapl7X4R731xG/8LyCfNVATKCHKpZ6b4g2W0RgA?=
 =?us-ascii?Q?6K+6mvx1dwRbQbJHmUmbocTFi0LXcqTLnmfiiGxQSukZrt2N78vdUxhhAMjf?=
 =?us-ascii?Q?VnOuCx3lRd0aP1E81W3mocc7ZmCPfGEBXr//OYx/YRWvWqJjlmaDreFIxgfx?=
 =?us-ascii?Q?1h6VHwl1X8pPn9qPpLasYNvxQunXQ/919xjjPcYyNRyVx8E2c6UUmy2Sfvpa?=
 =?us-ascii?Q?n1VQz8YCqy/xgDoU88merVsrovytOM6rdek5VGjMVwo3J45wSggfnazHfir7?=
 =?us-ascii?Q?9RKlEzLd1acTRW1XA1dyNMNKv6h4gb/Korl7mmTQCWbBdUVGKERS2AQ6QLG5?=
 =?us-ascii?Q?wxyijyC2qt18beSF2Iigd5CxTRddUFNsTo/3hkgXxzSWf6GVCAWj+UiTRTOa?=
 =?us-ascii?Q?AYiwhVyK0t3R/EePKlkAHSpqkalaJXClceay7+YBJG33j42qmhVfgjh4Njei?=
 =?us-ascii?Q?KScmGHfa2+GBvLC6vjEMzss6zbNYNU27S9TeNGOclvOJ1twV9hwpdckG/b7a?=
 =?us-ascii?Q?Jyu5pJ6BSHA8hVOIz+Z/4ag7MZcgQNUcMxbOGmvlvGcML7SzYdy+7/oQ1e/7?=
 =?us-ascii?Q?iNMFP7jgnW7RwZG92UtzeFIOhbfRd9gnu6Tnnice9srsm23GJ35oIcReCNED?=
 =?us-ascii?Q?QOm1FhRvMu4YBS3ulMNiIrQlO7ifXs2fvxlPH2MquuD8bXzC66z747euaGhe?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374be3b4-4031-4d89-bb9a-08daf8df0240
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:12.7882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2Lgfo9n5oc5WNmYQEDUNzeEeqUD6sWEog5PJ9AEplCR4Bn0fxzo/c9rLcYoBU7HlaHZrNRa4u1JqgGbfrKodQ==
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
   -> enetc_free_rx_ring()
      -> tests whether rx_ring->rx_swbd is NULL
   -> enetc_free_tx_ring()
      -> tests whether tx_ring->tx_swbd is NULL
-> enetc_free_rx_resources()
   -> enetc_free_rxbdr()
      -> sets rxr->rx_swbd to NULL
-> enetc_free_tx_resources()
   -> enetc_free_txbdr()
      -> setx txr->tx_swbd to NULL

From the above, it is clear that due to the function ordering, the
checks for NULL are redundant, since the software buffer descriptor
arrays have not yet been set to NULL. Drop these checks.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ca1dacccf9fe..f41a02c2213e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1880,9 +1880,6 @@ static void enetc_free_tx_ring(struct enetc_bdr *tx_ring)
 {
 	int i;
 
-	if (!tx_ring->tx_swbd)
-		return;
-
 	for (i = 0; i < tx_ring->bd_count; i++) {
 		struct enetc_tx_swbd *tx_swbd = &tx_ring->tx_swbd[i];
 
@@ -1894,9 +1891,6 @@ static void enetc_free_rx_ring(struct enetc_bdr *rx_ring)
 {
 	int i;
 
-	if (!rx_ring->rx_swbd)
-		return;
-
 	for (i = 0; i < rx_ring->bd_count; i++) {
 		struct enetc_rx_swbd *rx_swbd = &rx_ring->rx_swbd[i];
 
-- 
2.34.1

