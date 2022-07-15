Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBB3576979
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiGOWE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiGOWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:46 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60048.outbound.protection.outlook.com [40.107.6.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7EC8E4D5;
        Fri, 15 Jul 2022 15:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHfpZG4WdR/eRqbiS2qDfy+Vk+MZDSQIiysT5g3VQIMeZZf0EX1rWmWNJuBlaQE1q8v2h7Xp3doHqG20DAeGdJVzJOjNOsEFTkTOgy94dG2lKyLXy0Bzq62eaatK0fXi2dKLo1SmPa7Gn3Xd+MiGkGQB0VsE3kp4jqjJEiwT8EjBJ8FKXfGUcckneH4tNw1YuJKJFN3XFyYmg+SqWIqINYNhKllCV3kUFs40ABZ3I4CtHvwP9AhMKV+2qZPDyBz3pnIKcCP8JNi+ZGfc3gdNgNX8MoL+1jaOj4YOiwg7Tmkc28o4D0zrh2mM/KZ+N77q7o3ZMI6SQPw7X1Q1y52vzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T3uvyZKA2uUfGpR/2xNeKPauMOZIDY9wpntyy7jmVs=;
 b=b5x3Mq48DrtV1Rv3XRzknPyeaif8CLyWRS/v85eco351xXH2fioyi/mmYwb1cZEkWzubOGUq+pyglEFsU0S/bNYcuLC4Hjbp8LM4UQGBNGsJWQL3DcldDqG9IGvYaLncCbsZymyfinLYp8L8JdlOD1e9zCH7ML2Af4qdGcopANOrJpwjTw9AinIPDyKil9RmLeMk5C0sBRCHRj8iIY1YarL6Sz9FWQ2eCKHrCLUULzomdCZZbkniSX/1J8p8qR0KibD1qZjn9bBAOoHV2fFrDdf3kX9FPrMLK54ZU6l4ymLO3KBD8b10ay/Emj73lBqMWOROvBt7/0tRTMWdNH2kMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T3uvyZKA2uUfGpR/2xNeKPauMOZIDY9wpntyy7jmVs=;
 b=Q2MS6GjnN33jNWR2NEwsdx/bqLfGta66IAnmcCmyGdY3cW7WFCsjpunzd6tdJOhJtGsLSDAYvCdQi5BKnfZwsVhqPacNwgMaobDQuFQYvPSIjisxo1DfDckXxOf10dK2XwUqX0WvRR8fLw1l1em5uf/UMhUtPlEwtSDeCxinyY3V/cy308uu56lVsuqkaS6ddYXvudsrFdfL/rAM7oeKed4Kd52T4IQh/pnX7tjSjcz4VXaeaAn1XWgMM/nxpHKUhajwunwLHGjh70M/RJnBD649hjW/37Fl/g9c8l2k/1PHEUAf4v4waApDXBfWbeMqknyCn7+yi831OQkG8bfK5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:19 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:19 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 29/47] net: fman: Map the base address once
Date:   Fri, 15 Jul 2022 17:59:36 -0400
Message-Id: <20220715215954.1449214-30-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 804e43d6-3bb5-457c-a79e-08da66ad8be7
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQO3mbi65zf9LNZr62I1eJb+wAOZ9lxIg0Gs7mdku/igKVsN5NEkUHhz7tpf4bmmoLLwKWf85NHFKz4918wASc7RFDm0CKdbt53MY4V0z9uhvM003sWfnQYU9apDH0CiHm9n2LKrY5X1rz9TmTVEWoOy9quvYp5d5Filyi+du6NYqVlazxkUFpbkPVlx4wyyFgFzl2dj5OX8LhdLi947GMSklsMR6VgxOLMQG7gri1xT18pBANfZTe2yF/Z1wbrkERUKanjozgmfVRyb0Us6+RWWufZ9kEX6qb1aHMIGkhjZGsyCdeutnMz7jkQMnxUHjubYj+S4kiXGUJ42FTGRx89x7vHmyG9kmR+HX77uO37jXXJe/x+2No2vJ6OciiyVSbSFJRyboEBLEOZ19/JhMBwtjFpQkO1Ayv1kayl5vnCSmJlA486205cGyIwWMWqTR9a//gQbcfvU7dQtKDaHx4804msUwF7dy1FGpAo3LXmFmLIl4PQgB/Rk13/MYncVzLJ0Ou+KszEb2a8vFuw0chY8x4ZPP9kO7oGuh/Oa0DgAfm2sA2oo/8F7KVzudn1O9D6rWPChAq796tmWc0NzRHxR8/crYuZFXvmbcsMw5KjgJeFOxAe16KKpfIwD6Kai6EJkED2PpB/FiH5v6fpyFi3JeDqJAPxVPD1mt3AKkZYvqFu7awPjWhK0jiIQjnIX65YuwATAraZHkYqUV7DeT/NNEWzj9dkP744MPl/DbaZEy7W/sx+5QTBnGQkKxJqAlE9NQ0IDo0moe+1v2oTMuDZrx4jpSJVuYEelENkzwMxgb8ncYwV2QdGdkajDw3kj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qyh9wrWv8mDqFhXre5aNTgq3ENh6Gh7AZypoEjRlXwy1hgJkj8DUsxAiIX3j?=
 =?us-ascii?Q?Sdn7eUpZ8+cUOJGgDasFYHGvA7csSmUcm/UYw51+xIVxNl7qvKe4/kYkEUjP?=
 =?us-ascii?Q?uO6BaJ7fHmw566Zx5xsMDlIVEhsJg1Nw6Qp+LoU8EqHh1eQ5jUg0HuUuDS94?=
 =?us-ascii?Q?jMIYZy3Gp8aXQKAUxKvVWbu9UAcq/73hK6hLBZL5nZ4b+GDHX+UHXxVMTA0r?=
 =?us-ascii?Q?C7gbsBIQw8fHJCKcPL9Ry4+PVh+NTaARuhbu/eCNB+vOIRpVrUCPXYt4Sdlw?=
 =?us-ascii?Q?Dc+xx8ZkBrA/ve/HSwGQtllPc71xhDpNBlHECgA3E127IJfPVGhBQTAwv2Ux?=
 =?us-ascii?Q?ZOq5kKkrohdlMpGjbN5CMC0UkzsHNzBWoPaKHtKLc3xYtL4MsaxyK5IONb94?=
 =?us-ascii?Q?8NNtJ98D65mvH21WO5SVTW35l0T7DZhaC8W11ui9g3cMnDZ6qo9s57viqcKn?=
 =?us-ascii?Q?ucbKBj0pvid/zinCNzsf1YPogE1Dz9TVC1pR+wqWwfPfr7Ph07qGe7q6abbc?=
 =?us-ascii?Q?6RXIXh7GT47ArlWWe1eHLLCnQfBBTSnDlxeDjW+d49pHjBtKZiuQKuaQBogK?=
 =?us-ascii?Q?LSBFzMCWaNKQQiMd/ttha2xsy5cKmdLR2AL/23O3J0iJrxT1mj27zZY8jnP8?=
 =?us-ascii?Q?z1ghGA3eUkAUICEby3a9u1NnSGYdwbsolXgpiU491WmAbfKSXbVSXxqhf7q9?=
 =?us-ascii?Q?JOZSpXV4BYFBvnaCQ5hamznFYtaE0Tro7w4atBGFdx6ArOAV4P3BJ47fBOPZ?=
 =?us-ascii?Q?nKaQ3sAScL5l0q7oizeaWiMI8kJH2IET76pEOwdVFmCasMB1VL+L1OI1EiqG?=
 =?us-ascii?Q?3Me1smSROjB1pwduZz84AsbD2XCqqb5y8QEmkMtakQ/OPtIcxvEy7mIMC+Qt?=
 =?us-ascii?Q?YR7lulxysg2++sbPrD9myOmTNmSiNcC9sYZiRIVm4c6tVYXGvg+PfmMsZgex?=
 =?us-ascii?Q?K9Mt89/DLh+Qu3tgcggd8fs/zJFGMCIHzjpGJI6NBd8S0nTtd+5onbPc5Laq?=
 =?us-ascii?Q?WSH4qgX/h/KbHQVj1/jJwdFr+wL9k2fo2zMD0oOREjYF3RhkIcry/J7IlhdI?=
 =?us-ascii?Q?HHzOIFUAMxuLeaUhxPBw0aSAy45CPwDYEaD9NRaFlCxY+14qrVhkFyvd9Ddi?=
 =?us-ascii?Q?VQt5bxjJStV4f4HICYsF2BvKdlhkDFLu+m2lqnrBCiqc4qCRGRoDdeKtNq8c?=
 =?us-ascii?Q?UDfSFVh95sEr8irtpjYLzNKHWiVQbAGW0p8Q+L7z0qHfTpgzFB0mYIQ9uNmV?=
 =?us-ascii?Q?x6nW0PHSqQcxwvO5lJPW+GKenu0kYxR/PDnIGZQ2Ag04cHzScAehxZC3fanl?=
 =?us-ascii?Q?PawCgPQ7gROi6qpuybP4zM6qQuuBWR+kBnVUbiHcwFe970NqdUifCYJDIsqt?=
 =?us-ascii?Q?TXGQli9Tv1TElAOVhaaIcBJP/++CnISbA2a1H3WudIrD3FAkSn+ogl9COGzV?=
 =?us-ascii?Q?YvKorYW5oQ1NyLCpb6U6eRR1TPn/zkVYpOPX7/CsRg7jnEIHnU1NHZQwq/yw?=
 =?us-ascii?Q?3YBH5tSOjGMa7e74dcAmXb0mhKrUGYAnjwzfY157O/ndJwQCQLy+AYztGP5L?=
 =?us-ascii?Q?u7jFzx0uXaQkuablna0DmAOyZf+FrF+zzbwQu32CNVicAuZDgkP2D/1RFFHj?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804e43d6-3bb5-457c-a79e-08da66ad8be7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:18.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOUoEqEJBtqXMd8wvi96bG8h/78Vacob/gyr/MU4lB6Dkw1xueoO+vUpJpMUfFs/tEoG35ZXnq226EPqUYo3gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to remap the base address from the resource twice (once in
mac_probe() and again in set_fman_mac_params()). We still need the
resource to get the end address, but we can use a single function call
to get both at once.

While we're at it, use platform_get_mem_or_io and devm_request_resource
to map the resource. I think this is the more "correct" way to do things
here, since we use the pdev resource, instead of creating a new one.
It's still a bit tricy, since we need to ensure that the resource is a
child of the fman region when it gets requested.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v2)

Changes in v2:
- Fix warning if sizeof(void *) != sizeof(resource_size_t)

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  4 +--
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 35 +++++++------------
 drivers/net/ethernet/freescale/fman/mac.h     |  3 +-
 4 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e974d90f15e3..02b588c46fcf 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -218,8 +218,8 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->netdev_ops = dpaa_ops;
 	mac_addr = priv->mac_dev->addr;
 
-	net_dev->mem_start = priv->mac_dev->res->start;
-	net_dev->mem_end = priv->mac_dev->res->end;
+	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
index 4fee74c024bd..258eb6c8f4c0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
@@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
 
 	if (mac_dev)
 		return sprintf(buf, "%llx",
-				(unsigned long long)mac_dev->res->start);
+				(unsigned long long)mac_dev->vaddr);
 	else
 		return sprintf(buf, "none");
 }
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 7afedd4995c9..62af81c0c942 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL FMan MAC API based driver");
 
 struct mac_priv_s {
-	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
 	/* List of multicast addresses */
@@ -63,12 +62,7 @@ int set_fman_mac_params(struct mac_device *mac_dev,
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
-	params->base_addr = (typeof(params->base_addr))
-		devm_ioremap(mac_dev->dev, mac_dev->res->start,
-			     resource_size(mac_dev->res));
-	if (!params->base_addr)
-		return -ENOMEM;
-
+	params->base_addr = mac_dev->vaddr;
 	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
 	params->max_speed	= priv->max_speed;
 	params->phy_if		= mac_dev->phy_if;
@@ -305,7 +299,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
-	struct resource		 res;
+	struct resource		*res;
 	struct mac_priv_s	*priv;
 	u32			 val;
 	u8			fman_id;
@@ -368,30 +362,25 @@ static int mac_probe(struct platform_device *_of_dev)
 	of_node_put(dev_node);
 
 	/* Get the address of the memory mapped registers */
-	err = of_address_to_resource(mac_node, 0, &res);
-	if (err < 0) {
-		dev_err(dev, "of_address_to_resource(%pOF) = %d\n",
-			mac_node, err);
-		goto _return_of_node_put;
+	res = platform_get_mem_or_io(_of_dev, 0);
+	if (!res) {
+		dev_err(dev, "could not get registers\n");
+		return -EINVAL;
 	}
 
-	mac_dev->res = __devm_request_region(dev,
-					     fman_get_mem_region(priv->fman),
-					     res.start, resource_size(&res),
-					     "mac");
-	if (!mac_dev->res) {
-		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
-		err = -EBUSY;
+	err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
+	if (err) {
+		dev_err_probe(dev, err, "could not request resource\n");
 		goto _return_of_node_put;
 	}
 
-	priv->vaddr = devm_ioremap(dev, mac_dev->res->start,
-				   resource_size(mac_dev->res));
-	if (!priv->vaddr) {
+	mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
+	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		err = -EIO;
 		goto _return_of_node_put;
 	}
+	mac_dev->vaddr_end = mac_dev->vaddr + resource_size(res);
 
 	if (!of_device_is_available(mac_node)) {
 		err = -ENODEV;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index da410a7d00c9..7aa71b05bd3e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -19,8 +19,9 @@ struct fman_mac;
 struct mac_priv_s;
 
 struct mac_device {
+	void __iomem		*vaddr;
+	void __iomem		*vaddr_end;
 	struct device		*dev;
-	struct resource		*res;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
 	u32			 if_support;
-- 
2.35.1.1320.gc452695387.dirty

