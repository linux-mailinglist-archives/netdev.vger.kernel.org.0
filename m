Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B08854FEA3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377564AbiFQUhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382413AbiFQUhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:37:13 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E72761606;
        Fri, 17 Jun 2022 13:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuD2uTDDxAeMIkk7P8/TcTXqVjsQltgOObX/DeRKkGgRQFGJ9H4lK+ATYUKk+9zGjuOMvokG3Mz0dtixfzOIFxoej8SALnsJWcSZKTvuSJK3nfKBoZ68DvTr/3Vx+w00+zeMx7dSDFqTM4qFLGNi8PZDUgaOY8ym2IZ2XLfI1nKsi9jUnwiBy+SzIohM4sJRmxZ40RLi+BoRCSccdGcGnz27iiYBjWfXfukshuwIN0O787WS/swMa019GM4lrRAta5KqIRTxK1eSHqECcC/x5YUudD9wHIgeMSO8h5IZZJU+H3vaq1f6xG7ug3d9w2Rgrosipftemzs2LHX7ls+DCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQXApiIb94gYMeEkQjb9lf3tpQFZ+5mR6l2VgM1pkI4=;
 b=oSsnntycE39OMY1m279KNDSzxYucbLHkOI9rABTm+vEz+C/C4scFeYgP3w+OlSgS3050GllGEUIHWGlUuvdEY+j8ySgLTuf4yi1AfaOr8lCt7wRDB2ovR1lM2jijWI7Mwtm6A+OFeQTCmgi9LYFBiDhG0CV2LbsIH8B+d4ZXCszj9bwa8s6uhl8KAmWejfpXh9zLrR1PF/lyY0dqn4lRrQQ0kweXTutKbpvLQT96KfgKe1LQuhoP3+2/xywszH2j0Isd1qc5EEfdFgvAX7Odz5z9Fx/2iytDbk5xTbi09ntR+l+izlPEJcbnrim4zkDjcDkLt3dYesOTvl+Ibjs7PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQXApiIb94gYMeEkQjb9lf3tpQFZ+5mR6l2VgM1pkI4=;
 b=zQYj5rhpTUimq8Z7DfkTIIqoV+Q1NOMFL6rBt60Wt9bpAXOpeKr1G6ujTOoe2btGg2zZcG05YOcvxXqP+0oVf2Pxp79uVNH4eRR9W8xCtHfKP+YB9HUNl6+q4Usd9sVco0Syce4nS5gBgbwPYlq2NSDNQRvoFB7WOlYADB4KrEncP4bp4VJMC4CLYN00N8unBRrJfsZJDYPdIj7x5jYT0S/UfnEQKJNDCXXJb4I9CGMzzG32Kh9SKGUNrAdRu/U7tc2xF0wXSCZy1UhrDT49UtxkjjHjVsW3vy2NMkGsHj0y9CEQH9pLCrsoufEFY9nawKcyCNEr9T3652w/P7co3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:21 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 24/28] net: dpaa: Use mac_dev variable in dpaa_netdev_init
Date:   Fri, 17 Jun 2022 16:33:08 -0400
Message-Id: <20220617203312.3799646-25-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb06326d-9a39-4680-61dc-08da50a0c26f
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB68389003EA95335158F39DFA96AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0uaUhESixR9c8K3i1G9uiKrXox/bezV4ofg/2jnFkCIdHfwE2vX1LYcUjs2kiUCt+PxbjChDZz17DSRyU7agLlk3DEpRcyFSVlKnctz1jL1G/r6dDw8plcbFqPhApXL7QprMI0QI/V7UDLyFpD369x8B1/shPwQRB6fZNrKbmGEcDWoMKnJnkfjpiBzBnP1UAdpEQg1CRY+bKeBM+biNnIn4wljkyevkaaSd1Ibgx/uooTKhrfW1UQF2TPVgz5wekoDHqXQk7IpMzjVQnd2WQMnS/QD1cwV9TReckZyqa6yiOnNo3SVa1T7CZySWrc7vigyaalQd5bzYCSNW1RfY+dShNwuO/CWPg9nhyF/Lm1OhQWHbsb/9olyJX7fp9m3KkIEk/WdB4rCzYkUaIIeorgetYjgKCaCz6Y+J1H6dmq8xgI2Ma4S44atdEOGxKCPU5D/rW/J9GzvEppTnNsAzL2ssawjrDb7CLKukloq8NWn/POk4HXhm6HgpvLZzo9kd/nMzBlK0/FBboZ/8wawzQAa9dR0V0ZbKn6buX+3pw7kGNr8NyvsUEkJ+QIoWV/zF22Iga8GuL2ehP5BlI7XufKSalhxrIVtqQZ4MDjVWXH5UgF/Lqolz2bwjS/FHJYg+aJ0Xx4ns5UlNr3Nsr/hciepeAdjRsN5d37qodJ0oK8Ds1Ot6ohKOPRvEtByj3QFbFfIaelHCtbMUCxX/kBrs1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R/magzXLFLSMruEULtZF/UbMkOfqDSPzIoYJw97ty5b+LI38t/zoHYHgsYCV?=
 =?us-ascii?Q?WAVreEdkUodm0IHao6GBvrDv8q+08lZJ7X4Sx3IcdKnGfa2u6UDvef+Fh89w?=
 =?us-ascii?Q?5VZJLDgR4uWQ9qLnor2SWHOfgsgq5JG3Fb/rkiPPTmDX6o3bDbqSst4pgoSV?=
 =?us-ascii?Q?J5JfwzbnSxa2gdgUI4T/379m8FiXAIqqRp4R0+6B0EunncVu9knq9Q9qGeq6?=
 =?us-ascii?Q?5JNw9wb0n8ZKR/fEGiDpvkYrY8xtdthGuv2tR8cOdfGzYMPzjIXt+mBRxEwZ?=
 =?us-ascii?Q?E6xLMZkr489iUFwxInjWBO8r6Qla4Qd2G+QcdcrS/GrX+PGC27n0FM4QK/Xw?=
 =?us-ascii?Q?VT1P2ZUkhU5eG97dvdcZRLFQgER/qhV1xzcUbReTDYvfffoTibXyzdlt+um4?=
 =?us-ascii?Q?w7smCxcJbBPrVqzDDUzyqWDqCIZ/GWwtmsFZUCK1Q8pzNSIpMu9C0aqCr7vE?=
 =?us-ascii?Q?dgbH5MndBAd3PkahuMve0ThtpMpAjDoN2r9uS0BQ8CzrbX/PGuHkdXDdtL+4?=
 =?us-ascii?Q?JrkalbHERZWwYVtEXtIcPoiPaNFnUvtSPt6iqI9bEy2YN1Xo2CN8u9KkV5N8?=
 =?us-ascii?Q?KWJfVh3AzUZzo41YQoaYYvjiD01e5IBHB7hunpZ6oweZFqwA1Yp+Hl3G38Zf?=
 =?us-ascii?Q?iVYtc/LoC0qrTW4Pgre0XS75YuZeOxl0gIgdxVA7H/Yy1JVBskTIsrYUWeWk?=
 =?us-ascii?Q?PpmUoB4ayzB99tAU9X3bx/PSr6sY0xtXMBepcBiSt4vcg0XBtOIIvMY9ZE+S?=
 =?us-ascii?Q?lwlO5FOy/7zGh1pButbv89sOQyE/2IbFl1HRUa/WJJnvj1ozA777xg/kydhG?=
 =?us-ascii?Q?c0EACUF4bMcU3CiYApehsf1MfiqLEhdz8JY7ZY5/zCCTGAqlekrizeGqR3MG?=
 =?us-ascii?Q?yPrK0NhaA0cS1mJbjiPA8mxy2yP4loapzYWS6Y45vxJVXwv/QdMQwdD26mYU?=
 =?us-ascii?Q?f4F+iHVvH+Io1qTR3KLHwebXKTpjHtX4gGfnWB+E6ukE30gYa0YOfPk1tQ5t?=
 =?us-ascii?Q?+Ucs0UAYLDsN347QWqd0I3Fj6cy2O80KPIEit43p4mWAfGqWSbJCz3BRNIEB?=
 =?us-ascii?Q?Twe7JDEJlRcTolLLjmlG57bqygGBHkEF0QI2UH7QiVhdSu6aFaA1NbS+BgxO?=
 =?us-ascii?Q?xIa8sPloCK+KlyFhwwgQptzlIMOp99TIjEdINiu0mx1iNOiO0T7simbRoXb1?=
 =?us-ascii?Q?cKZy9oTK7/fh1ka5BJhWau0VzAw90n/ERHFDXDOa/RhhLBsRwZhixf3gOWwh?=
 =?us-ascii?Q?EySVUQX5FVNSAniGm92wB3Hz48CwC/CVPex+GxUwz4bxp0j73gPtn4TGDo2P?=
 =?us-ascii?Q?t63/ovHJN4YSnwI1UohbGfgo4Z+zWfU23iayfn0RQQ6qoVs8HHa91CSwgNlZ?=
 =?us-ascii?Q?GG4wBafkQuR1VCxmKUHVxnuW65OSbrobBKAX+/TKJkH2ah6zg8rmz/olTPgD?=
 =?us-ascii?Q?/AgcwMZA6Huw+eC0NaNlevWpZWZOm90u36CdY5nuyIDrQ/ag1O74w/CvtCQK?=
 =?us-ascii?Q?D6l3ra2fOgopYXTcloN1ChWZxFnNlZRm1KE8P8k7RXJh/W4iCYNBludpwIp/?=
 =?us-ascii?Q?zt+euJ0PtCtCmtbBg64L20R52hIFvyOI7gsN/1XEHJek9dH+lc0VibvL98lH?=
 =?us-ascii?Q?k2y/Q0z+xfxcLTgu98vDMfPsKB9vL50nFryEsveKjqzVu9BayRFcp87NSti+?=
 =?us-ascii?Q?hgK49ncYShVPb4xMnSC5Zf+5DeTKc19JaewQ85IjtjExPrZgZ1fnND3nJET4?=
 =?us-ascii?Q?OLdGBBwTAv2XAxKwrwsTMkWkNvt8tiA=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb06326d-9a39-4680-61dc-08da50a0c26f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:21.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsO6pl1K7JSYzPJ12TccOzCV87Vvcf5w9Q9ZGXgtb9txsAZ7EnZvoMs3UFryxiiGVTbEoaGnopThkdhI1dla2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several references to mac_dev in dpaa_netdev_init. Make things a
bit more concise by adding a local variable for it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d443d53c4504..9d31fd1d8ad0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
+	struct mac_device *mac_dev = priv->mac_dev;
 	struct dpaa_percpu_priv *percpu_priv;
 	const u8 *mac_addr;
 	int i, err;
@@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	}
 
 	net_dev->netdev_ops = dpaa_ops;
-	mac_addr = priv->mac_dev->addr;
+	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
@@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		eth_hw_addr_random(net_dev);
-		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
+		err = priv->mac_dev->change_addr(mac_dev->fman_mac,
 			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
-- 
2.35.1.1320.gc452695387.dirty

