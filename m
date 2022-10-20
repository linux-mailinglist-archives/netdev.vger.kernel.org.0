Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49E60650E
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJTPvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiJTPvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:51:01 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20083.outbound.protection.outlook.com [40.107.2.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFC0198475;
        Thu, 20 Oct 2022 08:51:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hpi1XmlgNurp3rGZxymTpzNLmZT/21odps90koTgvjdimkVTvc6yXkpL4BJIm4n70YmKhxJwH4FHhXFIbYkInlfPKK8whP9PQu3cjEjr0lfAJDUc0TRc5dz1NGJgxSJbyx6zsHGLRWAkOsSne1n8/LFZTcYd0mELRo9srg8vHumck3lENQwtLqKNhlCgH8ITjcTuUHj2m8BXR4/0Webh63vsmQckMrM4neZR7No1qxToyzTE3iBV9Z7uHZRyK7Nw716fmMoaLPM3Ad29C8I0OwPWqxijOmm/tCedDRPdQ2zC3yzxqtxTcoXHthp4xg3kybOcrkS0r2M6yjDvi8PM7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKqHhVweNUf3jrqf91DaOF7iBzflFnfI94xTTqyDyn0=;
 b=MlT7odiJ9dheQEl/xQ8v6A1NE51znaxF5EAP8rFOEE+IJuSv82L5uGamjlhqvJTqfKHldn1tV/qCKyWx5doBTiWoGJoqbgU+omysiBEH+9xU0ftSH6dnCSPAumrqw8TUIPlriVpTdGridnXLkIoHBbxa637dKMnVU56OfHLqSB8RZeVeNVqXxBZ1KISvMovFzAHXO4d+VghGAPdpNEqXX6GM/FJmAR/SJt+xMZAh+N0rC6lWMZzqyUWDNUIqWUNws8AjBCYxgWoIVKiDpKOmxDPV5wnZcfgN09ZP0sjV1kTtZlHCeuxTv8S5snh5CiC87AHw8WLLW15jUiaM7a7C3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKqHhVweNUf3jrqf91DaOF7iBzflFnfI94xTTqyDyn0=;
 b=YNwx9dnIhlnL9S+QoUtj2ZaeGFoFCERlT//Kp1dkHUY77eZRxWZmy58F9GJzU68JhH77wdhXJV4yXEgpgeq1OEN0K+q/U70lyAGOVXViJ5uifjXWzKl1gs2njkiy3IdEhgybxnaWHtuxSmr/nefO82dK2/FP9jE7q8pFGxT3P6haZB86PUje3XTXX5I7ltA7+NpvR8yIEj0nq2hxqSuLr0A6uMafs+j0lDxyqzvyTdRPJOvQZ5mxsmgfVKxCwjYdOeAo+r3zQroJQKEM+WA7uvYJOj7DkSWM1I3yC/zUw3qxTfD3MxwD/lGdE2GopTYuidG8wk3287XTe6onSrAmIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS2PR03MB9561.eurprd03.prod.outlook.com (2603:10a6:20b:59a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 15:50:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 15:50:57 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Davis <afd@ti.com>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net v2] net: fman: Use physical address for userspace interfaces
Date:   Thu, 20 Oct 2022 11:50:41 -0400
Message-Id: <20221020155041.2448668-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::35) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS2PR03MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: beaf01a5-672a-434b-48d3-08dab2b2e0de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQnIkLlDr1o0+H+tkkLDjK8BOLBKRMw07PNb/AQKGFCyF8jbVMiOq0TOzxOI9FN1YvR9fraaQfl4zDRmBCgq5DmFQjNYrBQT4De4IUX5pNx2EOqoNrgo6ZI5ze4HC+9p4omcc+fO5ggxFzAHonX9rnOp/Y2bCsmY45zZeM2EYrdXdKQfNcWfp91oQ7osb8SV8kVdjpaO/1BJmDjqITuKPOYB1HoB6NEwxiwBB/ETNl/3kwCFv9E26YVzVLccnPJWcIz3bz8jdfduKSA5L+frQV/0v9nrCZZUkkKgQq1ZioytBNaMLdnCvs+T76Z1qUgYb97WgtwgvwOzj/zSkiBnBOdH8FcOajehiYJCa6oj0f94gjb5te1mTqk5I9DS97UJTaUiN7vzr5ci5TppIWCeRHk220/lsChyP9Med5tdpzEt+jqCy//IVmc0IMmm3iOS1/UaKfmjEdgJXnbm04fKfjF3BfTEBiMdQQSCRPkUhcVpQ2oW2eOj37FElllhzBXZ1zynCEDxlF+Fg5vtk/PCZcxlwpgdB5fERuPPMSV1GI5tqQO/lZ/Ah8GsZnSSzVCZ7O6t/kzob/st3NyKE6bEzkUaq8z8mmjeztKuWP9/VSRswITwJT4TMr9KlpN8I7Yrt9iySTElmz7+VRcvmKYNdc6AH7Md3PJkAMi2VloM5XBAs1EvJVozTB9kPLCg5NkC3nA2cd/fNfQl5TpOxq0vRLALgtOILESwn3RPjcy9SjcG0oST4NKQICo490G/O4GjNsj8ML/ONXcjKS/upYE3Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(136003)(396003)(346002)(366004)(376002)(451199015)(44832011)(26005)(6512007)(186003)(2616005)(316002)(6666004)(83380400001)(2906002)(1076003)(52116002)(8936002)(5660300002)(6506007)(478600001)(54906003)(66946007)(6486002)(4326008)(66556008)(41300700001)(8676002)(7416002)(66476007)(36756003)(86362001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GdDKG2xrctS02H1ynNh0VkVqJUVt4ATTR85cVxIDekSnX19GtvEuwNr3DoJU?=
 =?us-ascii?Q?OAvp1JLe2qOfLVurLs3vbrs3xdePQ00qyq6inlvu9agDWPYVUnPTLiGwzssI?=
 =?us-ascii?Q?5KoK8kLXPKbrvk0cvJGT5SY4KqatJCt4fSQwRaKX6W/fXs3o3PzmvOyliy8o?=
 =?us-ascii?Q?qVnKvjB6KWZWU5FFWI0xEGb5rlcaU2ZI1OqdPZHrjdB/gcs5bFWOBkPn4qKg?=
 =?us-ascii?Q?K2NrciD+1AdZbhWgqXkW/VSlKqb2Cxja3s4bIz3ZgQ2rRQ/ZNR0BoezqL+91?=
 =?us-ascii?Q?CUy+dmadkBSBppn4LBv7u+MyDmRMV1pI+urQxPPHZ3wfB4QlplrB1B/l3KXB?=
 =?us-ascii?Q?vzvhxWCb+0X5oDYnqOjhPkITDp8NMi9hm5fYJ4LSL0yofPuK2Kg5aHhKYWlP?=
 =?us-ascii?Q?htk2g74TAdj6POSigDH9TCifTz9QqwgumQUhTBSb7lSmIBdNdVe+4SmPT284?=
 =?us-ascii?Q?nczSXRIkla5IJBLKRjklkslLgNn5mK9ZcFUfI3OdxLUbof73dL2aosdyMaVB?=
 =?us-ascii?Q?6+KHBqHyPWGklxKM7zehF1AIXWIPy6qWjBxpgLtMGd3+bRoWkIvJXLGLfh9d?=
 =?us-ascii?Q?+UVdzwTBjxop4Act+sOYsBgYk8ie+xWa3ZGZCKRDJEdRFohVm0OtWzeKVLjs?=
 =?us-ascii?Q?5b1+kmEgP3UUGxGbW1D5HxygVCAW4rRYdKkPD9cEmuVhsgdCbAsEvL0Z5xnU?=
 =?us-ascii?Q?4JUascI60JAOLjDAUEmJnVYTle8wN5mbUv8d4D4ZLpsz9jhK1zo2iUpgJnQY?=
 =?us-ascii?Q?0CFAGUc7iXEl9nBbjX20dR3blcfPB4wEtw43L99ppL4xbG3Zz50bbWJVQv7B?=
 =?us-ascii?Q?CItZTmFzbDXQiZRCa1cKQgsg+NW7kcCQLyi2HMV0cft4o/0c41V77eOyz+ln?=
 =?us-ascii?Q?aj8Qh7TPa8oUANEU8H+JgKBIMg8/NFUOWhe9slviPkOK2vHh6rsAvzUKPVgO?=
 =?us-ascii?Q?xdHsKj+QHTtRBnOi/UCFni8dNzJctsLegH1N04op3HflMv7xZqmnlOeMpJ3y?=
 =?us-ascii?Q?pI0Igl/uVMxhvWO4vgCGH3w/GUtD4h2cLcP7VBfTl+nfkDUoMyInIgUxfT7R?=
 =?us-ascii?Q?olLJd24+xWn3CLCy5kixpOYRIQGn/2yLwGmkP8BfG6aYoaws7oD2nC3cKI1L?=
 =?us-ascii?Q?zfC5D5WSi6JBa+UbcK5AF+twSg/NOACA4IW6E9xrbA7UUcVv7bT2vPXZTkp/?=
 =?us-ascii?Q?Z/ziM8PhcG9GNbKDkvuNu2zBJNBkYX8w7o7F300pZSPqYdTXNbe27BsWcJ3q?=
 =?us-ascii?Q?VbAEW4banjSxRCEVG9/EE2waec1RKe5wnvWxQ7Qe1LPmTvT7kcRk8OzGb8Dz?=
 =?us-ascii?Q?NM+Om09yvotAfrbpGgzUkzPLKccZ/ALmD94fasBky2/r4sZOmtDMN3Q3TWAs?=
 =?us-ascii?Q?qIL4GDY/0n6wcWcEBaUjCUsYWLy/VcnTtpMe2KBiHRusEZGU176y4YfoGUZw?=
 =?us-ascii?Q?XxPweNXR5byv45fb/aITUYhHZ/pmLI+3HzoJnUfBrhoOu4Izy/qWuwk7ohcK?=
 =?us-ascii?Q?JAM9xbkn0WBgMwbPqg029wE4WKeqkzHE1Z/9JlsQ+BPQTQoBF+aMWNsrWeq6?=
 =?us-ascii?Q?5VOA9l4MpCB7MuljMKIZieKiMhNgkIBxrO1Kh8QNSguyaGpQ1n4EAfq6kYH/?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beaf01a5-672a-434b-48d3-08dab2b2e0de
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:50:57.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMdFwMZoVKreXmK3mI0Bbb8sAlUHFMp9rkSyUscjqaaKvW1P/7xvd05or9Vmcq9UEq+ffZ+idbu9aCvUfwRedw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9561
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before 262f2b782e25 ("net: fman: Map the base address once"), the
physical address of the MAC was exposed to userspace in two places: via
sysfs and via SIOCGIFMAP. While this is not best practice, it is an
external ABI which is in use by userspace software.

The aforementioned commit inadvertently modified these addresses and
made them virtual. This constitutes and ABI break.  Additionally, it
leaks the kernel's memory layout to userspace. Partially revert that
commit, reintroducing the resource back into struct mac_device, while
keeping the intended changes (the rework of the address mapping).

Fixes: 262f2b782e25 ("net: fman: Map the base address once")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---

Changes in v2:
- Expand and clarify commit message

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c       |  4 ++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c |  2 +-
 drivers/net/ethernet/freescale/fman/mac.c            | 12 ++++++------
 drivers/net/ethernet/freescale/fman/mac.h            |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 31cfa121333d..fc68a32ce2f7 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -221,8 +221,8 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->netdev_ops = dpaa_ops;
 	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)priv->mac_dev->res->start;
+	net_dev->mem_end = (unsigned long)priv->mac_dev->res->end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
index 258eb6c8f4c0..4fee74c024bd 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
@@ -18,7 +18,7 @@ static ssize_t dpaa_eth_show_addr(struct device *dev,
 
 	if (mac_dev)
 		return sprintf(buf, "%llx",
-				(unsigned long long)mac_dev->vaddr);
+				(unsigned long long)mac_dev->res->start);
 	else
 		return sprintf(buf, "none");
 }
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 7b7526fd7da3..65df308bad97 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -279,7 +279,6 @@ static int mac_probe(struct platform_device *_of_dev)
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
-	struct resource		*res;
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	u32			 val;
@@ -338,24 +337,25 @@ static int mac_probe(struct platform_device *_of_dev)
 	of_node_put(dev_node);
 
 	/* Get the address of the memory mapped registers */
-	res = platform_get_mem_or_io(_of_dev, 0);
-	if (!res) {
+	mac_dev->res = platform_get_mem_or_io(_of_dev, 0);
+	if (!mac_dev->res) {
 		dev_err(dev, "could not get registers\n");
 		return -EINVAL;
 	}
 
-	err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
+	err = devm_request_resource(dev, fman_get_mem_region(priv->fman),
+				    mac_dev->res);
 	if (err) {
 		dev_err_probe(dev, err, "could not request resource\n");
 		return err;
 	}
 
-	mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
+	mac_dev->vaddr = devm_ioremap(dev, mac_dev->res->start,
+				      resource_size(mac_dev->res));
 	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		return -EIO;
 	}
-	mac_dev->vaddr_end = mac_dev->vaddr + resource_size(res);
 
 	if (!of_device_is_available(mac_node))
 		return -ENODEV;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index b95d384271bd..13b69ca5f00c 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -20,8 +20,8 @@ struct mac_priv_s;
 
 struct mac_device {
 	void __iomem		*vaddr;
-	void __iomem		*vaddr_end;
 	struct device		*dev;
+	struct resource		*res;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
 	u32			 if_support;
-- 
2.35.1.1320.gc452695387.dirty

