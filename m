Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A30610105
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 21:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiJ0TA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 15:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiJ0TAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 15:00:33 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFD24AD4A;
        Thu, 27 Oct 2022 12:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQuvqmisZyYvtQNhq0ZbHNjfo7hY23qVwSPxfvdS+j4tq38dX+uRw/k+S3arm8wEJ9LPAThxWAgjQWZipEplxiFqECXbqaz2Mi7IYih9ia7S3I76iZYS36nSPgm0oFoiMMpFYk9Auv/VPSQ5nqanmQpVPvEMI9iCdWxakde9gLqJNlVisU3SL4WaUAxTaaawvgu/naLi7jZlcsWLFJtfdvxEi2DZI3bGSQFBoDusTZZwlGTYQB6uYU0pTEG6INniclHccPmDOYfXtM4gs43cJkoo/dPwzmo1919xMWfvdLM3BcwqeijWF0dr0/pwHl+juZUSgixDBVjj7Y5dhD0akg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKLNp0wxJuITE+K/a0VbNIs+WiWrzSKicWmS3dJEK1s=;
 b=kc9Pw+79reQT24OYBUWmyeOgEviA2U9GBp8nx2BA9DmzM7n1rJeL6lhTiNKRq7mEgMOES7n4d968LQWOwYM9YhA6eRr7FwVSQIsO74sYjix8Ew4miDEorW/j0oyR8T96zYPv/Bj88BgyXHFJaWpkmYZklQTxyNT8cp9RTNJluHwQPYzXaet/qsy5/6O8Xn7gqRMUkSClJ/LFEmbn92vQlbZz47pqwJTG1rhP641io6O6DF1rMcQnE5+vtAVmNua8e3Q/b/DaRA0y1Y6e89+qAfVFQ8BTgDiWw5d6JVdZLMOLOrB3C9giQXgT4nCn47brQgk7aU5PRhjHGUY98Y9zUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKLNp0wxJuITE+K/a0VbNIs+WiWrzSKicWmS3dJEK1s=;
 b=0kRMxsTXUB2z0UHqpaauZT6ZUn6OlrFc3iP1QZNygEH0GmK/JG/P89DnWb6+W5lSCEjHBkiDTeIST7ood0776WVFRJM4neGqeQYfx+j04Jr1p0e+DfCXogiuF21lbUHP6Rw8mlRSCs4QZLV97Q5xog/4eBcAQ15QQ8WJh0spUYkgybbqBD8ELsAJn/zi+eXBbwNZJZsAy/IdGOxxuMJ7n35Vsc561f+mjPlvHigvvy8FGqZca4OHKz2Xz/yLaslu5dOexD9ffUC5DyShDSBzN0uCHEwt0NbckU9CT29ZbVhWh07K16YIJwJ4YyPmyyI78okslQJX6xEHPYQuxcjUMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by PAWPR03MB9786.eurprd03.prod.outlook.com (2603:10a6:102:2e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 27 Oct
 2022 19:00:23 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::3d5c:1e59:4df8:975d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::3d5c:1e59:4df8:975d%6]) with mapi id 15.20.5769.014; Thu, 27 Oct 2022
 19:00:23 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:DPAA2 ETHERNET DRIVER)
Cc:     linux-kernel@vger.kernel.org (open list),
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH] net: dpaa2: Add some debug prints on deferred probe
Date:   Thu, 27 Oct 2022 15:00:05 -0400
Message-Id: <20221027190005.400839-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0161.namprd05.prod.outlook.com
 (2603:10b6:a03:339::16) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR03MB4973:EE_|PAWPR03MB9786:EE_
X-MS-Office365-Filtering-Correlation-Id: d426513e-4a4e-4a07-3e39-08dab84d807c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qawDMXs2C7B00DMgIadgeKsoVq6w3NvXZlK3x4eiGAfpXB7+gDeLpopZvqu2EwEtWzzuBKebLEM2EMB6XrUPKKUjHlnLJcr1r4Z8s4fBjqVKoVlMzYCEONeB01XzE8Q82IPyoKlT/6TZD2Q3wXrxy5ln9/+u+sVfM5uXXA4aZ6aQzlJs5tU8G7WNFmB8usc5zp6eJdfVv4GYRRka6gzfTqDoyEf2YF02Z0eYmp1C3KhZmYfldWqHI+H1zDOT8H+9Jzudf+R2LLutQRKm2Od/04aBTPBwuRqnM+nAxFSBeLjGCoqmHAfVp7PF6mclhsAu+tunHke0x3oJumM08dXtF2DBgiNouyisG1zAujM2rcAJ5PaJmGtuQsdfDFXMCg7gtPAi0EpDakP+kt+bQHhB2P9RllQAxml5/YshaZ4FeS3nd/AWh8B94XimFRD2xrQZHAG4+b5put/dsRr5tp/3Jdan1Dk+rzx3E3xZijDJcqlss68itKM1Y3z+56MhL0HJb/3GkHhLzx58oKqqNC6hfLLMUMScGUbyThcR9P90g0eUwNRocMvNyBaxyXWteAZePCdZczfEPcjCW5/HpgRVY7OR9/ouxzM81fVRDPA/wna3u/mklGa/pAz9TIaTCOR8OTpK+ryGoLhiCROo/oUzF/qlvBeuWP0WWV6/ZMrVKm7mt27KQQ6EkD+fMDEQ1FPt5Q0U7fKX4+nQJ7qwO8t/KvX1Ff9LHvnz6fLKq81fqQLHrWhlNLZyzUErr/e1ZUvJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(366004)(136003)(39850400004)(451199015)(2616005)(36756003)(1076003)(8936002)(38100700002)(5660300002)(44832011)(4326008)(186003)(83380400001)(6512007)(41300700001)(26005)(54906003)(66946007)(6506007)(38350700002)(6666004)(316002)(6486002)(2906002)(107886003)(66556008)(478600001)(8676002)(66476007)(52116002)(86362001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4uoBijkW483Ddx7zeurqAGaRZjxbIdx1MTBU/amMb0JYc50UhNqw1Mv9cvac?=
 =?us-ascii?Q?2esDMPQxMyCG1nl6nKDtLfiGq4h0WCDYhzzypRCKNsgNRN0tVq9MsRGsNztS?=
 =?us-ascii?Q?ecSJTw1g/S9L2oH9bNrr9D7+MYyBvUMqK+kgOZvMxn0gTt7IvsY4Ybn7dk7s?=
 =?us-ascii?Q?VSCIfa3i42XRJTPqHIBFLWaNkyIFXlbE1kKIEhfgUqmeQyzSeQqu35TdAFPA?=
 =?us-ascii?Q?vRDelgqyb2p8d8G1awCFvUh/bSGXuCj51y4Q+CmlWhnoO1kd8D3GHx80h4/w?=
 =?us-ascii?Q?Ho7F118vTlLkNjuCNp6wG+4aPVmCJdhAbe4vdn0wOJgXlmDdC6sBCD1aupG0?=
 =?us-ascii?Q?tOpXVEEvW1bi62tiPs7YzV5gNiFmm2uDWBbMYBRTZ1B9z6H3Dpo0feh5SDh4?=
 =?us-ascii?Q?eaNq8m2GdfcBHztiMLgrYgAjglMhokjtiEJDaCKtseA44ud8Okf/DD8ExY9+?=
 =?us-ascii?Q?TJlngnmy11QoSHwYvsRczX6ohMzPyZUOD4oEYuQj8SaVeJfIGqxlXAPfC5K5?=
 =?us-ascii?Q?IYj23qvTZB5gvUUWZGiy8cD6nwCYuebZwqYxQeNNoe1l7NbUU/0Dk/7P3TOa?=
 =?us-ascii?Q?gWXHy4p6+GV+tbO4kxbLcDBfIBAKgDxCbdtlRj4x9yP8zLcRmUsCo9sASQ3F?=
 =?us-ascii?Q?6bcUXisgOs7/rx+XlwNK/WM/i/elxVQa1P2qnPJuspFo94617c3wMJbq3sVd?=
 =?us-ascii?Q?rYHIUPBbaoqepy9nnLerw5wxWLuZmrJ2YJtGmFOYBpcL2FTjN/JsGhKFOB8O?=
 =?us-ascii?Q?4ug4iQU81Q9qvoNRsS/Gl/X0pD/9K10QvdIqVEk5Vej9b1TjFAMra5e3ITog?=
 =?us-ascii?Q?k8fsId+ALumB/UnSc5T9JCUK00Yc9XTOUMp0u8Tz+SOv64Ng6y5u3XYwLKJZ?=
 =?us-ascii?Q?gfZZm2cMjNLYXVNIoMCenTzSGFB2rwyM02zq7pKDZxHWGg+fqys0RlwfH9XK?=
 =?us-ascii?Q?o0gZDcPAzygtszU0X/aANZyxc8mKCVUfFKsnMfbq2TCk2X7yPIbNG+GG+A+e?=
 =?us-ascii?Q?YDgYjEW5eQ6iBWPgoRu/didI9w0oaVJYh0LMsJ+QUU8GWDg+Bah1ODlVWFwK?=
 =?us-ascii?Q?Isc+Db9K2/6Levj8vtjndCnhNqGwyetZSmosuJRukd8mER/pY/3MwjWE7qP5?=
 =?us-ascii?Q?qMzUmjNxre701VWCnt8+/uVXBtO7BwvHoX331w5ks+jdQC4k1BmQyL9g4BF8?=
 =?us-ascii?Q?VAV4XyUZ3ERISbgT020Of8aO9SZ9vww3vA8sXe4gHe2+xjVFp68H7Q16c/Pt?=
 =?us-ascii?Q?c6VXjOw4YACa9aUqE975dHV5rCIDllJR/BkrhbfkoHaDGUPmSyA3a9d45Lq8?=
 =?us-ascii?Q?hcCiqxMAlLkPdHfkkM5lBzlhZFdJvYtbzVdqH954M67XkUpYnlA338SHNxEp?=
 =?us-ascii?Q?YZ0luJy3QLOEoLjqq8c79jl8tZoCo8VYKH75CWURBPcRMQ2VgmW4uQjp17XO?=
 =?us-ascii?Q?v7PXCsv4ol31KWgqcig9rnQPgejX2gjhyKY3y2U6R4+/OcouM/6tI0dN59Ad?=
 =?us-ascii?Q?Y4GbpfRxePH9R/OtCxXwNOE/266qzTnih2VN/4M20bFgHoJJ182jxc4h8PGY?=
 =?us-ascii?Q?CoFh8xM6e/zcORmGj3KURxNkn8iz3DhRrbLpGyRetLXqOj/C5TClMSbmlBXK?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d426513e-4a4e-4a07-3e39-08dab84d807c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 19:00:23.7089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1co8S1MAFzB54B1hQDXiRs0Shc8jVuoRtdbEjyhQJwBk0wyTTN5usmrO4LYccBjs08J24RfscUoH0i3pWgt5cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9786
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this device is deferred, there is often no way to determine what
the cause was. Add some debug prints to make it easier to figure out
what is blocking the probe.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 33 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  5 ++-
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 281d7e3905c1..892a1403c469 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3038,10 +3038,12 @@ static struct fsl_mc_device *dpaa2_eth_setup_dpcon(struct dpaa2_eth_priv *priv)
 	err = fsl_mc_object_allocate(to_fsl_mc_device(dev),
 				     FSL_MC_POOL_DPCON, &dpcon);
 	if (err) {
-		if (err == -ENXIO)
+		if (err == -ENXIO) {
+			dev_dbg(dev, "Waiting for DPCON\n");
 			err = -EPROBE_DEFER;
-		else
+		} else {
 			dev_info(dev, "Not enough DPCONs, will go on as-is\n");
+		}
 		return ERR_PTR(err);
 	}
 
@@ -3151,7 +3153,9 @@ static int dpaa2_eth_setup_dpio(struct dpaa2_eth_priv *priv)
 		channel = dpaa2_eth_alloc_channel(priv);
 		if (IS_ERR_OR_NULL(channel)) {
 			err = PTR_ERR_OR_ZERO(channel);
-			if (err != -EPROBE_DEFER)
+			if (err == -EPROBE_DEFER)
+				dev_dbg(dev, "waiting for affine channel\n");
+			else
 				dev_info(dev,
 					 "No affine channel for cpu %d and above\n", i);
 			goto err_alloc_ch;
@@ -4605,8 +4609,10 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
 	dpmac_dev = fsl_mc_get_endpoint(dpni_dev, 0);
 
-	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
+	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER) {
+		netdev_dbg(priv->net_dev, "waiting for mac\n");
 		return PTR_ERR(dpmac_dev);
+	}
 
 	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
@@ -4626,11 +4632,16 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 	if (dpaa2_eth_is_type_phy(priv)) {
 		err = dpaa2_mac_connect(mac);
-		if (err && err != -EPROBE_DEFER)
-			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint: %pe",
-				   ERR_PTR(err));
-		if (err)
+		if (err) {
+			if (err == -EPROBE_DEFER)
+				netdev_dbg(priv->net_dev,
+					   "could not connect to MAC\n");
+			else
+				netdev_err(priv->net_dev,
+					   "Error connecting to the MAC endpoint: %pe",
+					   ERR_PTR(err));
 			goto err_close_mac;
+		}
 	}
 
 	return 0;
@@ -4802,10 +4813,12 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	err = fsl_mc_portal_allocate(dpni_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
 				     &priv->mc_io);
 	if (err) {
-		if (err == -ENXIO)
+		if (err == -ENXIO) {
+			dev_dbg(dev, "waiting for MC portal\n");
 			err = -EPROBE_DEFER;
-		else
+		} else {
 			dev_err(dev, "MC portal allocation failed\n");
+		}
 		goto err_portal_alloc;
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 49ff85633783..2bbab28f763d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -105,6 +105,7 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 		 * thus the fwnode field is not yet set. Defer probe if we are
 		 * facing this situation.
 		 */
+		dev_dbg(dev, "dprc not finished probing\n");
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
@@ -264,8 +265,10 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 	mdiodev = fwnode_mdio_find_device(node);
 	fwnode_handle_put(node);
-	if (!mdiodev)
+	if (!mdiodev) {
+		netdev_dbg(mac->net_dev, "missing PCS device\n");
 		return -EPROBE_DEFER;
+	}
 
 	mac->pcs = lynx_pcs_create(mdiodev);
 	if (!mac->pcs) {
-- 
2.35.1.1320.gc452695387.dirty

