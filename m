Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCBB5B610A
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiILSfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiILSeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:06 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0611.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A47C46DBD
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTNsISpfwxd5qKu25HJYb7gY4m66vjT4SJhMTfSSZoS0uu63V/3z0/uLUpUdJ7To+MlzD9ecv9CId1h2b84WVjl7nCit1N5UaiS5qKYL7Gjmh7o04xBXwEZ3MMCBbkbgtC2+Jh/EecrBfU4dhPnUK0ZxXhY3VZDo+m4y0kx2Xp/4ziIBBbyz596nqQXnNRWG5d6FMPzH6AozPgQ/HTP/BSzGNN8RIfi5PQh8m2dNfE4S0yFCgNplsCYYjDc8/9xYUmsXxAjwwIe9kcemw5+SxheVYtJVt1YkM/5rgx1PPkC4jc+g0Nystn9coJDMB2p3yDIAky64wEEx7jqFs0aBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drPh8q3jw7+R3jKZzLjs/AFSvskD1rjLeU2ZsGwnhPM=;
 b=Ms8x+HXuxBbKa3Xkyvhn0f+bLEIofmZ7alGHGhfaNWaOvdD8TjUGk6XO1GwY77qg4PVckK04y3KdAwYTvRDlnsDCrXxsgVqEwwJZGgpMpuEOReOCcJZk/mIq1ZPVhkeMYz/hR7F+irOYhctRqMCGnEfKmReUds+watsXxfSXkphrDJjcIxvq/EJCCYnmQmOOy+nlYD3Wba/NUbLEKeNady9uuQ7f2T7DEOEr1QjNYROSyg2ooRH+kwiW4PpcK88NjJT60y8nQSNL0+XGlZKR7pZN5idkB558/hONnugKcekDZuJRVxBrVh6oRGjKAncsTOqfJKFuCPAclX2NbQ0HJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drPh8q3jw7+R3jKZzLjs/AFSvskD1rjLeU2ZsGwnhPM=;
 b=o3v3qB/BdAlDTJGfltkq+NFlAcqYtNTc9iOS1lE7Pa26qnsuanSeOHnoXBoUxvcvF6xdiWe6t6Aw5AYE8cii1SecAlWpnyIpFNd6Ah6PaEBAue8hB6DsKh7V2HavjPUEHHdGlFjSj4jIm+hDz7X9kZaS7kMdwip5WpSbGbQhcdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:29:09 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 10/12] net: dpaa2-eth: AF_XDP RX zero copy support
Date:   Mon, 12 Sep 2022 21:28:27 +0300
Message-Id: <20220912182829.160715-11-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: f8ceba97-9480-4cc5-a891-08da94ecae5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e++zH25BiGozViNfW0ZifDmCx/68f8yIJ08rOC68P2vGZcj2BLk10gVzcBGOdx8LTUQ+jSkk85DinP0QbO3Rz+13Kd4cQUfqKLA2+lsNX99lB7d2OUOYYXT2KMd45IeoxzgBEwGrLbAuWIHvERK/s5sB9NkxZgMXhsiby8uIhP0Fr3dTdbCzgW4dToSTB+wH2l7Et6l7fldXvHkqB3wzbre1+Tz02w/r7nvkNXstNp6adKRwn20Bal93jYCAaGUSTRoxfsNRpOwrz6lZhELkAU0b7vp13u6TC2sP8fXDU/SZoyNp8XEH7WcG44dwZxPfQFYS9MAPkwBWUGjhAuFAQd6vh35TkGyNP5TSfFkBuWFeFFCGXSHr2wZevDS3p49p45VPtV9t3DY8WOnHsD0+GBYq/ZVMiTLeH4ouFdtnhXh2NXc0TZkVAek4kWHwpEs5HbupoEDGGbWONeS0D7MjJX39//WtzZU8CxQ/AnqPoR5+0LdZGpRRA8NrhUHXZ9wztPVZsbaW48xp2k+CZJAlYiAj8Ke2MSHqTA4FgW8BClW1yxW2YLMn6BDYObqMHOU16Dvbl0oW8LMfTb7Pk3dqQz2mPC5qzxNG9+WpkABCKX+ag/PuUJBP/nIwAhFQ9nXq0ne+ndm6o+WmzyvCx6QBpkJtD532aPdPkI2G7irwJGZ6s3t8hHkXbyyyEhUiIbStHneuxP5WHWB1WJnyBv2aa5HeyDNAatK2FZgsDjdM8wHuJEAZ3eraGtxm0Mhpy51ucF4BCMUuKsCvEZHoMMkMKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(30864003)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B3BArOZLvmXU53w3A+W70H/I6/WzaLe5Y2tWGdAcovoQrFlWqRkHI0IZqBWg?=
 =?us-ascii?Q?EHaOYKfm2RAcenfQb8cOP39x5xbF1XZGFZo/yUIGWraF+tEFIQsqHOdQ1JhY?=
 =?us-ascii?Q?dZ/sI5w995M8v0C8eAUSQLZQywjotC/Vrvs0WnAtAuysFqWZDutrjO37h0lD?=
 =?us-ascii?Q?q0IMCxNevn+vwN8qoWiJvqMuuZ36O9ZULaN+qodRzfiQmw0Cp9Rhv6hfajYB?=
 =?us-ascii?Q?jdTF8ebqAm6Mg+CUtxyEVeXJ/Nl1yAa9yHTfmHcZBHScHZHRxhXf8pA4r4ZZ?=
 =?us-ascii?Q?2qx1qFgRsroUGzHSCz7RR029/Dr0NGnnmEAiVJkzl4xOlnWbpgIbC5ZyNv5q?=
 =?us-ascii?Q?9DO+ryFo03kFWTFIn2AsMnfVdd8Kg/X70fAjvUSNqwonluhiU42zhUP3F6oY?=
 =?us-ascii?Q?ieAQKrGlyV2uOiFDHeHL62TwGOf0Edi8DG590Xt262w0nYK1vesIKVd3VwBZ?=
 =?us-ascii?Q?f3fM++9HRNPLOu4uqQJcojgaopU50s3AkTEID90ECr+AjuRLSkJwC4vvv7NU?=
 =?us-ascii?Q?RpGD0N7foLsnYm7roSxQOWX2sOFMZa4TjW0O8T3SMzbdY/f+HTrrorYp13d9?=
 =?us-ascii?Q?RQbb24qJ/wgqBHLn872mDzE233QcPhBErLd1U55Kyvfp6/OIDvNedFZwlDka?=
 =?us-ascii?Q?O6jrTJBXt6XQfBSoHR3gvzj9Td42eyKvPs7aaWsty8nzY0ONjIU8M5bFQrop?=
 =?us-ascii?Q?Mj95g4byMCpkCT0dogtzxt0nQN33ZtFG1dAFggtLhud9HzaEtm2KgwAPHf9b?=
 =?us-ascii?Q?rN0LxJDdXUe3aIV8+KfZILJ4rIU8xeALDpJSjNeLqOzcudesXnpp4knfvy/z?=
 =?us-ascii?Q?aXVoR+udUMP6lu2oQYv5w8S3s64yIEkbpkfggkft7/SYmwn+VAr3z1VP6DuN?=
 =?us-ascii?Q?l8gUI7vzXDnwH7fTKazBniK4CN8Pop7HpwwbEuGumtdKFKSh57EX2DRrx0N7?=
 =?us-ascii?Q?rOU8heSJsTJaeRS/Mi/zPbx71o7dq/efV4WbGfNS1HTvP7PdWjMAbeYsJQ44?=
 =?us-ascii?Q?NEGFcCCPRywD1KS6bsGmaxGxqMtZGjz4hjqTmSYnJ2taTb0XR2yFfW8Lexb/?=
 =?us-ascii?Q?KfjKwR3ZfrloPAecAr+vHvN9m02+eBo/6NC8nBLjqeHLedhKSohfyUkUeI2X?=
 =?us-ascii?Q?ZbPWNkuw1CoBvofzm+A3wPoSoVL92vcRnpSpw27cVp7ctQypkDx0Xm2517GG?=
 =?us-ascii?Q?Ne7/xaszxjfrOSzJp+DEeInmc3O/W+NbtoGnDu3hpU+K9bItisPN6UUH9Kjp?=
 =?us-ascii?Q?ovi2w3LeqYncDYp37hZ4BJwIjObKjOaQdDewtU/8lF+Un0cspFfG4A39NkGw?=
 =?us-ascii?Q?k1bbx8q1Gbu3Q2YMx/cjvAkdcMNtlhCqcy66CAJDpSvurgHUm+m4LYOxrn+O?=
 =?us-ascii?Q?wt7sRl4bFLh0vGGgTzzwktxGGWmr5Nt+RrFPuXXJH8cRJw777SwuCZsGGS9I?=
 =?us-ascii?Q?5uaroVHtlwvfqMZN2s0gOTJufLt0Gc+zlFCcYBmHAskLoBS4fs0VAhljFAR+?=
 =?us-ascii?Q?BeEYec1fduKGEywT6pNDms/xUWgyHsHAjRt6/zhxdX6wAiCq1mLnyCmE02Fd?=
 =?us-ascii?Q?/QM4AiqKHr/ZkRkzj13OpDpUado3bb3GWhNxr2qIh7iAvVJkzR+o+FDmLhMK?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8ceba97-9480-4cc5-a891-08da94ecae5c
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:08.8284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPRXFss9izD2ZpI3lQw+NJO5W9nus/nYI6Tm+aHedmQX6ogPKQHyzx4sND8Z/qtNEYzqSZpQVcmeApNko/cwIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

This patch adds the support for receiving packets via the AF_XDP
zero-copy mechanism in the dpaa2-eth driver. The support is available
only on the LX2160A SoC and variants because we are relying on the HW
capability to associate a buffer pool to a specific queue (QDBIN), only
available on newer WRIOP versions.

On the control path, the dpaa2_xsk_enable_pool() function is responsible
to allocate a buffer pool (BP), setup this new BP to be used only on the
requested queue and change the consume function to point to the XSK ZC
one.
We are forced to call dev_close() in order to change the queue to buffer
pool association (dpaa2_xsk_set_bp_per_qdbin) . This also works in our
favor since at dev_close() the buffer pools will be drained and at the
later dev_open() call they will be again seeded, this time with buffers
allocated from the XSK pool if needed.

On the data path, a new software annotation type is defined to be used
only for the XSK scenarios. This will enable us to pass keep necessary
information about a packet buffer between the moment in which it was
seeded and when it's received by the driver. In the XSK case, we are
keeping the associated xdp_buff.
Depending on the action returned by the BPF program, we will do the
following:
 - XDP_PASS: copy the contents of the packet into a brand new skb,
   recycle the initial buffer.
 - XDP_TX: just enqueue the same frame descriptor back into the Tx path,
   the buffer will get automatically released into the initial BP.
 - XDP_REDIRECT: call xdp_do_redirect() and exit.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 132 ++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  37 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 325 ++++++++++++++++++
 5 files changed, 451 insertions(+), 46 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 74036b51911d..594a03e2fa22 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6289,6 +6289,7 @@ F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
 F:	drivers/net/ethernet/freescale/dpaa2/Makefile
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-eth*
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
+F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk*
 F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
 F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
 F:	drivers/net/ethernet/freescale/dpaa2/dpni*
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index 3d9842af7f10..1b05ba8d1cbf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
 obj-$(CONFIG_FSL_DPAA2_SWITCH)		+= fsl-dpaa2-switch.o
 
-fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o
+fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o dpaa2-xsk.o
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 651b3ad489b9..2ce5f5605f69 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -19,6 +19,7 @@
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 #include <net/tso.h>
+#include <net/xdp_sock_drv.h>
 
 #include "dpaa2-eth.h"
 
@@ -104,8 +105,8 @@ static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
 	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
 }
 
-static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
-				dma_addr_t iova_addr)
+void *dpaa2_iova_to_virt(struct iommu_domain *domain,
+			 dma_addr_t iova_addr)
 {
 	phys_addr_t phys_addr;
 
@@ -279,23 +280,33 @@ static struct sk_buff *dpaa2_eth_build_frag_skb(struct dpaa2_eth_priv *priv,
  * be released in the pool
  */
 static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
-				int count)
+				int count, bool xsk_zc)
 {
 	struct device *dev = priv->net_dev->dev.parent;
+	struct dpaa2_eth_swa *swa;
+	struct xdp_buff *xdp_buff;
 	void *vaddr;
 	int i;
 
 	for (i = 0; i < count; i++) {
 		vaddr = dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
-		dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
-			       DMA_BIDIRECTIONAL);
-		free_pages((unsigned long)vaddr, 0);
+
+		if (!xsk_zc) {
+			dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
+				       DMA_BIDIRECTIONAL);
+			free_pages((unsigned long)vaddr, 0);
+		} else {
+			swa = (struct dpaa2_eth_swa *)
+				(vaddr + DPAA2_ETH_RX_HWA_SIZE);
+			xdp_buff = swa->xsk.xdp_buff;
+			xsk_buff_free(xdp_buff);
+		}
 	}
 }
 
-static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
-				  struct dpaa2_eth_channel *ch,
-				  dma_addr_t addr)
+void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   dma_addr_t addr)
 {
 	int retries = 0;
 	int err;
@@ -313,7 +324,8 @@ static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
 	}
 
 	if (err) {
-		dpaa2_eth_free_bufs(priv, ch->recycled_bufs, ch->recycled_bufs_cnt);
+		dpaa2_eth_free_bufs(priv, ch->recycled_bufs,
+				    ch->recycled_bufs_cnt, ch->xsk_zc);
 		ch->buf_count -= ch->recycled_bufs_cnt;
 	}
 
@@ -377,10 +389,10 @@ static void dpaa2_eth_xdp_tx_flush(struct dpaa2_eth_priv *priv,
 	fq->xdp_tx_fds.num = 0;
 }
 
-static void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
-				  struct dpaa2_eth_channel *ch,
-				  struct dpaa2_fd *fd,
-				  void *buf_start, u16 queue_id)
+void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   struct dpaa2_fd *fd,
+			   void *buf_start, u16 queue_id)
 {
 	struct dpaa2_faead *faead;
 	struct dpaa2_fd *dest_fd;
@@ -1651,37 +1663,62 @@ static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
 static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 			      struct dpaa2_eth_channel *ch)
 {
+	struct xdp_buff *xdp_buffs[DPAA2_ETH_BUFS_PER_CMD];
 	struct device *dev = priv->net_dev->dev.parent;
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
+	struct dpaa2_eth_swa *swa;
 	struct page *page;
 	dma_addr_t addr;
 	int retries = 0;
-	int i, err;
-
-	for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
-		/* Allocate buffer visible to WRIOP + skb shared info +
-		 * alignment padding
-		 */
-		/* allocate one page for each Rx buffer. WRIOP sees
-		 * the entire page except for a tailroom reserved for
-		 * skb shared info
+	int i = 0, err;
+	u32 batch;
+
+	/* Allocate buffers visible to WRIOP */
+	if (!ch->xsk_zc) {
+		for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
+			/* Also allocate skb shared info and alignment padding */
+			/* There is one page for each Rx buffer. WRIOP sees
+			 * the entire page except for a tailroom reserved for
+			 * skb shared info
+			 */
+			page = dev_alloc_pages(0);
+			if (!page)
+				goto err_alloc;
+
+			addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
+					    DMA_BIDIRECTIONAL);
+			if (unlikely(dma_mapping_error(dev, addr)))
+				goto err_map;
+
+			buf_array[i] = addr;
+
+			/* tracing point */
+			trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
+						 DPAA2_ETH_RX_BUF_RAW_SIZE,
+						 addr, priv->rx_buf_size,
+						 ch->bp->bpid);
+		}
+	} else if (xsk_buff_can_alloc(ch->xsk_pool, DPAA2_ETH_BUFS_PER_CMD)) {
+		/* Allocate XSK buffers for AF_XDP fast path in batches
+		 * of DPAA2_ETH_BUFS_PER_CMD. Bail out if the UMEM cannot
+		 * provide enough buffers at the moment
 		 */
-		page = dev_alloc_pages(0);
-		if (!page)
+		batch = xsk_buff_alloc_batch(ch->xsk_pool, xdp_buffs,
+					     DPAA2_ETH_BUFS_PER_CMD);
+		if (!batch)
 			goto err_alloc;
 
-		addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
-				    DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(dev, addr)))
-			goto err_map;
+		for (i = 0; i < batch; i++) {
+			swa = (struct dpaa2_eth_swa *)(xdp_buffs[i]->data_hard_start +
+						       DPAA2_ETH_RX_HWA_SIZE);
+			swa->xsk.xdp_buff = xdp_buffs[i];
 
-		buf_array[i] = addr;
+			addr = xsk_buff_xdp_get_frame_dma(xdp_buffs[i]);
+			if (unlikely(dma_mapping_error(dev, addr)))
+				goto err_map;
 
-		/* tracing point */
-		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
-					 DPAA2_ETH_RX_BUF_RAW_SIZE,
-					 addr, priv->rx_buf_size,
-					 ch->bp->bpid);
+			buf_array[i] = addr;
+		}
 	}
 
 release_bufs:
@@ -1697,14 +1734,19 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 	 * not much else we can do about it
 	 */
 	if (err) {
-		dpaa2_eth_free_bufs(priv, buf_array, i);
+		dpaa2_eth_free_bufs(priv, buf_array, i, ch->xsk_zc);
 		return 0;
 	}
 
 	return i;
 
 err_map:
-	__free_pages(page, 0);
+	if (!ch->xsk_zc) {
+		__free_pages(page, 0);
+	} else {
+		for (; i < batch; i++)
+			xsk_buff_free(xdp_buffs[i]);
+	}
 err_alloc:
 	/* If we managed to allocate at least some buffers,
 	 * release them to hardware
@@ -1759,8 +1801,13 @@ static void dpaa2_eth_seed_pools(struct dpaa2_eth_priv *priv)
 static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid, int count)
 {
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
+	bool xsk_zc = false;
 	int retries = 0;
-	int ret;
+	int i, ret;
+
+	for (i = 0; i < priv->num_channels; i++)
+		if (priv->channel[i]->bp->bpid == bpid)
+			xsk_zc = priv->channel[i]->xsk_zc;
 
 	do {
 		ret = dpaa2_io_service_acquire(NULL, bpid, buf_array, count);
@@ -1771,7 +1818,7 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid, int coun
 			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
 			return;
 		}
-		dpaa2_eth_free_bufs(priv, buf_array, ret);
+		dpaa2_eth_free_bufs(priv, buf_array, ret, xsk_zc);
 		retries = 0;
 	} while (ret);
 }
@@ -2689,6 +2736,8 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return dpaa2_eth_setup_xdp(dev, xdp->prog);
+	case XDP_SETUP_XSK_POOL:
+		return dpaa2_xsk_setup_pool(dev, xdp->xsk.pool, xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
@@ -2919,6 +2968,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_change_mtu = dpaa2_eth_change_mtu,
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
+	.ndo_xsk_wakeup = dpaa2_xsk_wakeup,
 	.ndo_setup_tc = dpaa2_eth_setup_tc,
 	.ndo_vlan_rx_add_vid = dpaa2_eth_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = dpaa2_eth_rx_kill_vid
@@ -3328,7 +3378,7 @@ static int dpaa2_eth_setup_default_dpbp(struct dpaa2_eth_priv *priv)
 	return 0;
 }
 
-static void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv, struct dpaa2_eth_bp *bp)
+void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv, struct dpaa2_eth_bp *bp)
 {
 	int idx_bp;
 
@@ -4241,8 +4291,8 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_bp *bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 	struct net_device *net_dev = priv->net_dev;
+	struct dpni_pools_cfg pools_params = { 0 };
 	struct device *dev = net_dev->dev.parent;
-	struct dpni_pools_cfg pools_params;
 	struct dpni_error_cfg err_cfg;
 	int err = 0;
 	int i;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 8966470c412f..4ae1adbb4ab8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -130,6 +130,7 @@ enum dpaa2_eth_swa_type {
 	DPAA2_ETH_SWA_SINGLE,
 	DPAA2_ETH_SWA_SG,
 	DPAA2_ETH_SWA_XDP,
+	DPAA2_ETH_SWA_XSK,
 	DPAA2_ETH_SWA_SW_TSO,
 };
 
@@ -151,6 +152,9 @@ struct dpaa2_eth_swa {
 			int dma_size;
 			struct xdp_frame *xdpf;
 		} xdp;
+		struct {
+			struct xdp_buff *xdp_buff;
+		} xsk;
 		struct {
 			struct sk_buff *skb;
 			int num_sg;
@@ -429,12 +433,19 @@ enum dpaa2_eth_fq_type {
 };
 
 struct dpaa2_eth_priv;
+struct dpaa2_eth_channel;
+struct dpaa2_eth_fq;
 
 struct dpaa2_eth_xdp_fds {
 	struct dpaa2_fd fds[DEV_MAP_BULK_SIZE];
 	ssize_t num;
 };
 
+typedef void dpaa2_eth_consume_cb_t(struct dpaa2_eth_priv *priv,
+				    struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd,
+				    struct dpaa2_eth_fq *fq);
+
 struct dpaa2_eth_fq {
 	u32 fqid;
 	u32 tx_qdbin;
@@ -447,10 +458,7 @@ struct dpaa2_eth_fq {
 	struct dpaa2_eth_channel *channel;
 	enum dpaa2_eth_fq_type type;
 
-	void (*consume)(struct dpaa2_eth_priv *priv,
-			struct dpaa2_eth_channel *ch,
-			const struct dpaa2_fd *fd,
-			struct dpaa2_eth_fq *fq);
+	dpaa2_eth_consume_cb_t *consume;
 	struct dpaa2_eth_fq_stats stats;
 
 	struct dpaa2_eth_xdp_fds xdp_redirect_fds;
@@ -486,6 +494,8 @@ struct dpaa2_eth_channel {
 	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
 	int recycled_bufs_cnt;
 
+	bool xsk_zc;
+	struct xsk_buff_pool *xsk_pool;
 	struct dpaa2_eth_bp *bp;
 };
 
@@ -804,4 +814,23 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 		  struct dpaa2_eth_channel *ch,
 		  const struct dpaa2_fd *fd,
 		  struct dpaa2_eth_fq *fq);
+
+struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv,
+			 struct dpaa2_eth_bp *bp);
+
+void *dpaa2_iova_to_virt(struct iommu_domain *domain, dma_addr_t iova_addr);
+void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   dma_addr_t addr);
+
+void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   struct dpaa2_fd *fd,
+			   void *buf_start, u16 queue_id);
+
+int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
+int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool,
+			 u16 qid);
+
 #endif	/* __DPAA2_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
new file mode 100644
index 000000000000..a0f6ea1c5c9f
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -0,0 +1,325 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2022 NXP
+ */
+#include <linux/filter.h>
+#include <linux/compiler.h>
+#include <linux/bpf_trace.h>
+#include <net/xdp.h>
+#include <net/xdp_sock_drv.h>
+
+#include "dpaa2-eth.h"
+
+static void dpaa2_eth_setup_consume_func(struct dpaa2_eth_priv *priv,
+					 struct dpaa2_eth_channel *ch,
+					 enum dpaa2_eth_fq_type type,
+					 dpaa2_eth_consume_cb_t *consume)
+{
+	struct dpaa2_eth_fq *fq;
+	int i;
+
+	for (i = 0; i < priv->num_fqs; i++) {
+		fq = &priv->fq[i];
+
+		if (fq->type != type)
+			continue;
+		if (fq->channel != ch)
+			continue;
+
+		fq->consume = consume;
+	}
+}
+
+static u32 dpaa2_xsk_run_xdp(struct dpaa2_eth_priv *priv,
+			     struct dpaa2_eth_channel *ch,
+			     struct dpaa2_eth_fq *rx_fq,
+			     struct dpaa2_fd *fd, void *vaddr)
+{
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff *xdp_buff;
+	struct dpaa2_eth_swa *swa;
+	u32 xdp_act = XDP_PASS;
+	int err;
+
+	xdp_prog = READ_ONCE(ch->xdp.prog);
+	if (!xdp_prog)
+		goto out;
+
+	swa = (struct dpaa2_eth_swa *)(vaddr + DPAA2_ETH_RX_HWA_SIZE +
+				       ch->xsk_pool->umem->headroom);
+	xdp_buff = swa->xsk.xdp_buff;
+
+	xdp_buff->data_hard_start = vaddr;
+	xdp_buff->data = vaddr + dpaa2_fd_get_offset(fd);
+	xdp_buff->data_end = xdp_buff->data + dpaa2_fd_get_len(fd);
+	xdp_set_data_meta_invalid(xdp_buff);
+	xdp_buff->rxq = &ch->xdp_rxq;
+
+	xsk_buff_dma_sync_for_cpu(xdp_buff, ch->xsk_pool);
+	xdp_act = bpf_prog_run_xdp(xdp_prog, xdp_buff);
+
+	/* xdp.data pointer may have changed */
+	dpaa2_fd_set_offset(fd, xdp_buff->data - vaddr);
+	dpaa2_fd_set_len(fd, xdp_buff->data_end - xdp_buff->data);
+
+	if (likely(xdp_act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(priv->net_dev, xdp_buff, xdp_prog);
+		if (unlikely(err)) {
+			ch->stats.xdp_drop++;
+			dpaa2_eth_recycle_buf(priv, ch, addr);
+		} else {
+			ch->buf_count--;
+			ch->stats.xdp_redirect++;
+		}
+
+		goto xdp_redir;
+	}
+
+	switch (xdp_act) {
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		dpaa2_eth_xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(priv->net_dev, xdp_prog, xdp_act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
+		fallthrough;
+	case XDP_DROP:
+		dpaa2_eth_recycle_buf(priv, ch, addr);
+		ch->stats.xdp_drop++;
+		break;
+	}
+
+xdp_redir:
+	ch->xdp.res |= xdp_act;
+out:
+	return xdp_act;
+}
+
+/* Rx frame processing routine for the AF_XDP fast path */
+static void dpaa2_xsk_rx(struct dpaa2_eth_priv *priv,
+			 struct dpaa2_eth_channel *ch,
+			 const struct dpaa2_fd *fd,
+			 struct dpaa2_eth_fq *fq)
+{
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
+	u8 fd_format = dpaa2_fd_get_format(fd);
+	struct rtnl_link_stats64 *percpu_stats;
+	u32 fd_length = dpaa2_fd_get_len(fd);
+	struct sk_buff *skb;
+	void *vaddr;
+	u32 xdp_act;
+
+	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+
+	if (fd_format != dpaa2_fd_single) {
+		WARN_ON(priv->xdp_prog);
+		/* AF_XDP doesn't support any other formats */
+		goto err_frame_format;
+	}
+
+	xdp_act = dpaa2_xsk_run_xdp(priv, ch, fq, (struct dpaa2_fd *)fd, vaddr);
+	if (xdp_act != XDP_PASS) {
+		percpu_stats->rx_packets++;
+		percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
+		return;
+	}
+
+	/* Build skb */
+	skb = dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, vaddr);
+	if (!skb)
+		/* Nothing else we can do, recycle the buffer and drop the frame */
+		goto err_alloc_skb;
+
+	/* Send the skb to the Linux networking stack */
+	dpaa2_eth_receive_skb(priv, ch, fd, vaddr, fq, percpu_stats, skb);
+
+	return;
+
+err_alloc_skb:
+	dpaa2_eth_recycle_buf(priv, ch, addr);
+err_frame_format:
+	percpu_stats->rx_dropped++;
+}
+
+static void dpaa2_xsk_set_bp_per_qdbin(struct dpaa2_eth_priv *priv,
+				       struct dpni_pools_cfg *pools_params)
+{
+	int curr_bp = 0, i, j;
+
+	pools_params->pool_options = DPNI_POOL_ASSOC_QDBIN;
+	for (i = 0; i < priv->num_bps; i++) {
+		for (j = 0; j < priv->num_channels; j++)
+			if (priv->bp[i] == priv->channel[j]->bp)
+				pools_params->pools[curr_bp].priority_mask |= (1 << j);
+		if (!pools_params->pools[curr_bp].priority_mask)
+			continue;
+
+		pools_params->pools[curr_bp].dpbp_id = priv->bp[i]->bpid;
+		pools_params->pools[curr_bp].buffer_size = priv->rx_buf_size;
+		pools_params->pools[curr_bp++].backup_pool = 0;
+	}
+	pools_params->num_dpbp = curr_bp;
+}
+
+static int dpaa2_xsk_disable_pool(struct net_device *dev, u16 qid)
+{
+	struct xsk_buff_pool *pool = xsk_get_pool_from_qid(dev, qid);
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpni_pools_cfg pools_params = { 0 };
+	struct dpaa2_eth_channel *ch;
+	int err;
+	bool up;
+
+	ch = priv->channel[qid];
+	if (!ch->xsk_pool)
+		return -EINVAL;
+
+	up = netif_running(dev);
+	if (up)
+		dev_close(dev);
+
+	xsk_pool_dma_unmap(pool, 0);
+	err = xdp_rxq_info_reg_mem_model(&ch->xdp_rxq,
+					 MEM_TYPE_PAGE_ORDER0, NULL);
+	if (err)
+		netdev_err(dev, "xsk_rxq_info_reg_mem_model() failed (err = %d)\n",
+			   err);
+
+	dpaa2_eth_free_dpbp(priv, ch->bp);
+
+	ch->xsk_zc = false;
+	ch->xsk_pool = NULL;
+	ch->bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
+
+	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_eth_rx);
+
+	dpaa2_xsk_set_bp_per_qdbin(priv, &pools_params);
+	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
+	if (err)
+		netdev_err(dev, "dpni_set_pools() failed\n");
+
+	if (up) {
+		err = dev_open(dev, NULL);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int dpaa2_xsk_enable_pool(struct net_device *dev,
+				 struct xsk_buff_pool *pool,
+				 u16 qid)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpni_pools_cfg pools_params = { 0 };
+	struct dpaa2_eth_channel *ch;
+	int err, err2;
+	bool up;
+
+	if (priv->dpni_attrs.wriop_version < DPAA2_WRIOP_VERSION(3, 0, 0)) {
+		netdev_err(dev, "AF_XDP zero-copy not supported on devices <= WRIOP(3, 0, 0)\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (priv->dpni_attrs.num_queues > 8) {
+		netdev_err(dev, "AF_XDP zero-copy not supported on DPNI with more then 8 queues\n");
+		return -EOPNOTSUPP;
+	}
+
+	up = netif_running(dev);
+	if (up)
+		dev_close(dev);
+
+	err = xsk_pool_dma_map(pool, priv->net_dev->dev.parent, 0);
+	if (err) {
+		netdev_err(dev, "xsk_pool_dma_map() failed (err = %d)\n",
+			   err);
+		goto err_dma_unmap;
+	}
+
+	ch = priv->channel[qid];
+	err = xdp_rxq_info_reg_mem_model(&ch->xdp_rxq, MEM_TYPE_XSK_BUFF_POOL, NULL);
+	if (err) {
+		netdev_err(dev, "xdp_rxq_info_reg_mem_model() failed (err = %d)\n", err);
+		goto err_mem_model;
+	}
+	xsk_pool_set_rxq_info(pool, &ch->xdp_rxq);
+
+	priv->bp[priv->num_bps] = dpaa2_eth_allocate_dpbp(priv);
+	if (IS_ERR(priv->bp[priv->num_bps])) {
+		err = PTR_ERR(priv->bp[priv->num_bps]);
+		goto err_bp_alloc;
+	}
+	ch->xsk_zc = true;
+	ch->xsk_pool = pool;
+	ch->bp = priv->bp[priv->num_bps++];
+
+	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_xsk_rx);
+
+	dpaa2_xsk_set_bp_per_qdbin(priv, &pools_params);
+	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
+	if (err) {
+		netdev_err(dev, "dpni_set_pools() failed\n");
+		goto err_set_pools;
+	}
+
+	if (up) {
+		err = dev_open(dev, NULL);
+		if (err)
+			return err;
+	}
+
+	return 0;
+
+err_set_pools:
+	err2 = dpaa2_xsk_disable_pool(dev, qid);
+	if (err2)
+		netdev_err(dev, "dpaa2_xsk_disable_pool() failed %d\n", err2);
+err_bp_alloc:
+	err2 = xdp_rxq_info_reg_mem_model(&priv->channel[qid]->xdp_rxq,
+					  MEM_TYPE_PAGE_ORDER0, NULL);
+	if (err2)
+		netdev_err(dev, "xsk_rxq_info_reg_mem_model() failed with %d)\n", err2);
+err_mem_model:
+	xsk_pool_dma_unmap(pool, 0);
+err_dma_unmap:
+	if (up)
+		dev_open(dev, NULL);
+
+	return err;
+}
+
+int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid)
+{
+	return pool ? dpaa2_xsk_enable_pool(dev, pool, qid) :
+		      dpaa2_xsk_disable_pool(dev, qid);
+}
+
+int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpaa2_eth_channel *ch = priv->channel[qid];
+
+	if (!priv->link_state.up)
+		return -ENETDOWN;
+
+	if (!priv->xdp_prog)
+		return -EINVAL;
+
+	if (!ch->xsk_zc)
+		return -EINVAL;
+
+	/* We do not have access to a per channel SW interrupt, so instead we
+	 * schedule a NAPI instance.
+	 */
+	if (!napi_if_scheduled_mark_missed(&ch->napi))
+		napi_schedule(&ch->napi);
+
+	return 0;
+}
-- 
2.33.1

