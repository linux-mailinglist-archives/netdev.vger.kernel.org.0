Return-Path: <netdev+bounces-1372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82FEE6FD9F7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BA601C20A72
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64CB63E;
	Wed, 10 May 2023 08:50:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA35E364
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:50:59 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591EF7285;
	Wed, 10 May 2023 01:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNfu4EiaWAdqWDJ9T6l705KS8gVkUhUPWP8pMBAwdtkrq+B9pkPsn1lJQYOh3xtGTNWkHc/EGr8Eu9dwe7u3T5R395BcIM8BxkhAlm7+rJzCkZmdYwvam+TzRCoqapHm/5xz5yz2mAVGXxh706pvS31+onnucRLiUkPTtydmHQJ84TkytTfkUMsElF+STWp0JbebkCVC7XCnFIQ4x8XnsixF9xIyUVCY6oo8O29EZ8+pMJNkYHAYNaqDu5joX1pkK+ARHFwadBfYvbVo0C6mgrAPDKBjCDP16/ZF1fTbALKcAL8fBcWxFw4Ey9PUedY0c/f0JN+3Ah0z7WbDLe91BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75qGzBJDopren3E9v8/uUr/QdXlgcI7j6U9QBD1iPIQ=;
 b=XpcKgDXg1llzlNAnkQLUsxHtBgeBEl5rMN8GKIlr0GJnXzrhgOZoeLVnfhF7c4Rl1kQWb84SHGqYI9pYmZOG7zOc1aZsuHWxFt5lChl75wfEQFRiBpTdjLBPibipyHiKusdx+nmSEHdLtwqMXHzea2hi7l2uW1lgmi1s1Uw290RQOGEsGdLDYfFyWm0OxV+BeuRtO0bbBh3AsxgAzRkSLzZcBqRLcLRbXsVktiQNbTbGUgygrcEkHtkrZIUVOjRNGLBJsm1UMNrqv8Whq5VcvEsPUcrTHj6R2OZ9LZSUfZDrao65G3rbyE0EawsZt2VSJkFmNF6syH1U7vfz6PYyNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75qGzBJDopren3E9v8/uUr/QdXlgcI7j6U9QBD1iPIQ=;
 b=470QUWarpJW6GRuMDTbYjyfDcQD8O5gHqiOoqO+0U8Q1PzkJj0VRu5/DznjeyJpT0N0LzpCr+c5AWBnGWh4gjjbdd863n6uc8/DnGJbWgvQ3z0I2wyK2JBasQrMLRQLJSCAn8P+8eOPfLfnb59VqwUcFPFi4YNZ8v3AU0v3m8dk=
Received: from DM6PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:40::35) by
 BL3PR12MB6380.namprd12.prod.outlook.com (2603:10b6:208:3b3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.29; Wed, 10 May 2023 08:50:52 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::3a) by DM6PR03CA0022.outlook.office365.com
 (2603:10b6:5:40::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Wed, 10 May 2023 08:50:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.20 via Frontend Transport; Wed, 10 May 2023 08:50:52 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 10 May
 2023 03:50:51 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 10 May
 2023 01:50:51 -0700
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 10 May 2023 03:50:46 -0500
From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>
CC: <linux@armlinux.org.uk>, <michal.simek@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
	<harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>, <git@amd.com>
Subject: [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine support
Date: Wed, 10 May 2023 14:20:31 +0530
Message-ID: <20230510085031.1116327-4-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT025:EE_|BL3PR12MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: ed7b6cff-8394-4c4e-5aa9-08db5133a8ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E+uZG/s/8JmEFehLBBdf68AKLk4bw/nfgOzKkk3tLGlSm9pKSdHLG0qwA9wGbD+PSst80pqASPRYRck71mvqreaFFlfIQNJvn3G/qwSZhmggUe6/Q42jh/Gb8pKTwg/asvVYOIfZzGGHlK+M9HFG5a4ox0drW2BqAvLJmQNXPnqJbLC/RG12OsiUpxSO8GMi1UGdglv/i3x3ljrJLtwNp0088ok/KnCZs/NKuphmULpDS/t7AhUfJUzXBwP91F5SrPM4R02Oigvll0mubPaSQwPgkmkzNJekPWbfKCNcrz+7z6ulX8UTZc2MjMIp1OLYeBpfSVJm/GKFht/P/KkXPo5Z8c+tWNHfFCLikFBn5lBlBXfNYR2jWV+5ZJD9RHFJQFH4fvb+cujMSMeuJ1+De+i6RD3hUm0wQQ559CAuQ1D2eqOak+gkoSm0E87n7ENXV2k0p2DYb302asJt3pWCy4hmcSgQy0NlVqniOaXC2G3z8SCKUbGxnrAw/X/d1Ze3Ck6mgP/TFRcchkPM5uUw5hea8Ko70y4E1E4qeTjR8uJlHQFK10K2Rf3pyDHmYCzSEa349yCOzwhT6FBGF4P+jhDABFqrEtImvI0ZfMJmz35gcwYaN0QoQQoNr1R6gXPUUjgvX4Az1a5yEAOymcriDIiImZWasAflnh/IGKNNoJzaun+35gjPCgTIMmnf4o2VfBxWNDie69YM+9geaMoDJk3DoJcM/exQlEwqC3GKgto=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(81166007)(356005)(186003)(1076003)(26005)(86362001)(2616005)(103116003)(36756003)(82740400003)(47076005)(36860700001)(426003)(336012)(83380400001)(6666004)(110136005)(316002)(40460700003)(70586007)(70206006)(478600001)(8936002)(4326008)(54906003)(7416002)(966005)(8676002)(5660300002)(41300700001)(82310400005)(40480700001)(30864003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:50:52.1114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7b6cff-8394-4c4e-5aa9-08db5133a8ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6380
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add dmaengine framework to communicate with the xilinx DMAengine
driver(AXIDMA).

Axi ethernet driver uses separate channels for transmit and receive.
Add support for these channels to handle TX and RX with skb and
appropriate callbacks. Also add axi ethernet core interrupt for
dmaengine framework support.

The dmaengine framework was extended for metadata API support during the
axidma RFC[1] discussion. However it still needs further enhancements to
make it well suited for ethernet usecases. The ethernet features i.e
ethtool set/get of DMA IP properties, ndo_poll_controller, trigger
reset of DMA IP from ethernet are not supported (mentioned in TODO)
and it requires follow-up discussion and dma framework enhancement.

[1]: https://lore.kernel.org/lkml/1522665546-10035-1-git-send-email-
radheys@xilinx.com

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
---
Performance numbers(Mbps):

              | TCP | UDP |
         -----------------
         | Tx | 920 | 800 |
         -----------------
         | Rx | 620 | 910 |

Changes in V3:
1) New patch for dmaengine framework support.
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   6 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 331 +++++++++++++++++-
 2 files changed, 335 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 10917d997d27..fbe00c5390d5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -436,6 +436,9 @@ struct axidma_bd {
  * @coalesce_count_tx:	Store the irq coalesce on TX side.
  * @coalesce_usec_tx:	IRQ coalesce delay for TX
  * @has_dmas:	flag to check dmaengine framework usage.
+ * @tx_chan:	TX DMA channel.
+ * @rx_chan:	RX DMA channel.
+ * @skb_cache:	Custom skb slab allocator
  */
 struct axienet_local {
 	struct net_device *ndev;
@@ -501,6 +504,9 @@ struct axienet_local {
 	u32 coalesce_count_tx;
 	u32 coalesce_usec_tx;
 	u8  has_dmas;
+	struct dma_chan *tx_chan;
+	struct dma_chan *rx_chan;
+	struct kmem_cache *skb_cache;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8678fc09245a..662c77ff0e99 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -37,6 +37,9 @@
 #include <linux/phy.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma/xilinx_dma.h>
 
 #include "xilinx_axienet.h"
 
@@ -46,6 +49,9 @@
 #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
+#define DMA_NUM_APP_WORDS		5
+#define LEN_APP				4
+#define RX_BUF_NUM_DEFAULT		128
 
 /* Must be shorter than length of ethtool_drvinfo.driver field to fit */
 #define DRIVER_NAME		"xaxienet"
@@ -56,6 +62,16 @@
 
 #define AXIENET_USE_DMA(lp) ((lp)->has_dmas)
 
+struct axi_skbuff {
+	struct scatterlist sgl[MAX_SKB_FRAGS + 1];
+	struct dma_async_tx_descriptor *desc;
+	dma_addr_t dma_address;
+	struct sk_buff *skb;
+	int sg_len;
+} __packed;
+
+static int axienet_rx_submit_desc(struct net_device *ndev);
+
 /* Match table for of_platform binding */
 static const struct of_device_id axienet_of_match[] = {
 	{ .compatible = "xlnx,axi-ethernet-1.00.a", },
@@ -728,6 +744,108 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	return 0;
 }
 
+/**
+ * axienet_dma_tx_cb - DMA engine callback for TX channel.
+ * @data:       Pointer to the axi_skbuff structure
+ * @result:     error reporting through dmaengine_result.
+ * This function is called by dmaengine driver for TX channel to notify
+ * that the transmit is done.
+ */
+static void axienet_dma_tx_cb(void *data, const struct dmaengine_result *result)
+{
+	struct axi_skbuff *axi_skb = data;
+
+	struct net_device *netdev = axi_skb->skb->dev;
+	struct axienet_local *lp = netdev_priv(netdev);
+
+	u64_stats_update_begin(&lp->tx_stat_sync);
+	u64_stats_add(&lp->tx_bytes, axi_skb->skb->len);
+	u64_stats_add(&lp->tx_packets, 1);
+	u64_stats_update_end(&lp->tx_stat_sync);
+
+	dma_unmap_sg(lp->dev, axi_skb->sgl, axi_skb->sg_len, DMA_MEM_TO_DEV);
+	dev_kfree_skb_any(axi_skb->skb);
+	kmem_cache_free(lp->skb_cache, axi_skb);
+}
+
+/**
+ * axienet_start_xmit_dmaengine - Starts the transmission.
+ * @skb:        sk_buff pointer that contains data to be Txed.
+ * @ndev:       Pointer to net_device structure.
+ *
+ * Return: NETDEV_TX_OK, on success
+ *          NETDEV_TX_BUSY, if any memory failure or SG error.
+ *
+ * This function is invoked from xmit to initiate transmission. The
+ * function sets the skbs , call back API, SG etc.
+ * Additionally if checksum offloading is supported,
+ * it populates AXI Stream Control fields with appropriate values.
+ */
+static netdev_tx_t
+axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct dma_async_tx_descriptor *dma_tx_desc = NULL;
+	struct axienet_local *lp = netdev_priv(ndev);
+	u32 app[DMA_NUM_APP_WORDS] = {0};
+	struct axi_skbuff *axi_skb;
+	u32 csum_start_off;
+	u32 csum_index_off;
+	int sg_len;
+	int ret;
+
+	sg_len = skb_shinfo(skb)->nr_frags + 1;
+	axi_skb = kmem_cache_zalloc(lp->skb_cache, GFP_KERNEL);
+	if (!axi_skb)
+		return NETDEV_TX_BUSY;
+
+	sg_init_table(axi_skb->sgl, sg_len);
+	ret = skb_to_sgvec(skb, axi_skb->sgl, 0, skb->len);
+	if (unlikely(ret < 0))
+		goto xmit_error_skb_sgvec;
+
+	ret = dma_map_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
+	if (ret == 0)
+		goto xmit_error_skb_sgvec;
+
+	/*Fill up app fields for checksum */
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (lp->features & XAE_FEATURE_FULL_TX_CSUM) {
+			/* Tx Full Checksum Offload Enabled */
+			app[0] |= 2;
+		} else if (lp->features & XAE_FEATURE_PARTIAL_RX_CSUM) {
+			csum_start_off = skb_transport_offset(skb);
+			csum_index_off = csum_start_off + skb->csum_offset;
+			/* Tx Partial Checksum Offload Enabled */
+			app[0] |= 1;
+			app[1] = (csum_start_off << 16) | csum_index_off;
+		}
+	} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
+		app[0] |= 2; /* Tx Full Checksum Offload Enabled */
+	}
+
+	dma_tx_desc = lp->tx_chan->device->device_prep_slave_sg(lp->tx_chan, axi_skb->sgl,
+			sg_len, DMA_MEM_TO_DEV,
+			DMA_PREP_INTERRUPT, (void *)app);
+
+	if (!dma_tx_desc)
+		goto xmit_error_prep;
+
+	axi_skb->skb = skb;
+	axi_skb->sg_len = sg_len;
+	dma_tx_desc->callback_param =  axi_skb;
+	dma_tx_desc->callback_result = axienet_dma_tx_cb;
+	dmaengine_submit(dma_tx_desc);
+	dma_async_issue_pending(lp->tx_chan);
+
+	return NETDEV_TX_OK;
+
+xmit_error_prep:
+	dma_unmap_sg(lp->dev, axi_skb->sgl, sg_len, DMA_TO_DEVICE);
+xmit_error_skb_sgvec:
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	return NETDEV_TX_BUSY;
+}
+
 /**
  * axienet_tx_poll - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
@@ -912,7 +1030,42 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (!AXIENET_USE_DMA(lp))
 		return axienet_start_xmit_legacy(skb, ndev);
 	else
-		return NETDEV_TX_BUSY;
+		return axienet_start_xmit_dmaengine(skb, ndev);
+}
+
+/**
+ * axienet_dma_rx_cb - DMA engine callback for RX channel.
+ * @data:       Pointer to the axi_skbuff structure
+ * @result:     error reporting through dmaengine_result.
+ * This function is called by dmaengine driver for RX channel to notify
+ * that the packet is received.
+ */
+static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
+{
+	struct axi_skbuff *axi_skb = data;
+	struct sk_buff *skb = axi_skb->skb;
+	struct net_device *netdev = skb->dev;
+	struct axienet_local *lp = netdev_priv(netdev);
+	size_t meta_len, meta_max_len, rx_len;
+	u32 *app;
+
+	app  = dmaengine_desc_get_metadata_ptr(axi_skb->desc, &meta_len, &meta_max_len);
+	dma_unmap_single(lp->dev, axi_skb->dma_address, lp->max_frm_size,
+			 DMA_FROM_DEVICE);
+	/* TODO: Derive app word index programmatically */
+	rx_len = (app[LEN_APP] & 0xFFFF);
+	skb_put(skb, rx_len);
+	skb->protocol = eth_type_trans(skb, netdev);
+	skb->ip_summed = CHECKSUM_NONE;
+
+	netif_rx(skb);
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	u64_stats_update_begin(&lp->rx_stat_sync);
+	u64_stats_add(&lp->rx_packets, 1);
+	u64_stats_add(&lp->rx_bytes, rx_len);
+	u64_stats_update_end(&lp->rx_stat_sync);
+	axienet_rx_submit_desc(netdev);
+	dma_async_issue_pending(lp->rx_chan);
 }
 
 /**
@@ -1148,6 +1301,134 @@ static irqreturn_t axienet_eth_irq(int irq, void *_ndev)
 
 static void axienet_dma_err_handler(struct work_struct *work);
 
+/**
+ * axienet_rx_submit_desc - Submit the descriptors with required data
+ * like call backup API, skb buffer.. etc to dmaengine.
+ *
+ * @ndev:	net_device pointer
+ *
+ *Return: 0, on success.
+ *          non-zero error value on failure
+ */
+static int axienet_rx_submit_desc(struct net_device *ndev)
+{
+	struct dma_async_tx_descriptor *dma_rx_desc = NULL;
+	struct axienet_local *lp = netdev_priv(ndev);
+	struct axi_skbuff *axi_skb;
+	struct sk_buff *skb;
+	dma_addr_t addr;
+	int ret;
+
+	axi_skb = kmem_cache_alloc(lp->skb_cache, GFP_KERNEL);
+
+	if (!axi_skb)
+		return -ENOMEM;
+	skb = netdev_alloc_skb(ndev, lp->max_frm_size);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto rx_bd_init_skb;
+	}
+
+	sg_init_table(axi_skb->sgl, 1);
+	addr = dma_map_single(lp->dev, skb->data, lp->max_frm_size, DMA_FROM_DEVICE);
+	sg_dma_address(axi_skb->sgl) = addr;
+	sg_dma_len(axi_skb->sgl) = lp->max_frm_size;
+	dma_rx_desc = dmaengine_prep_slave_sg(lp->rx_chan, axi_skb->sgl,
+					      1, DMA_DEV_TO_MEM,
+					      DMA_PREP_INTERRUPT);
+	if (!dma_rx_desc) {
+		ret = -EINVAL;
+		goto rx_bd_init_prep_sg;
+	}
+
+	axi_skb->skb = skb;
+	axi_skb->dma_address = sg_dma_address(axi_skb->sgl);
+	axi_skb->desc = dma_rx_desc;
+	dma_rx_desc->callback_param =  axi_skb;
+	dma_rx_desc->callback_result = axienet_dma_rx_cb;
+	dmaengine_submit(dma_rx_desc);
+
+	return 0;
+
+rx_bd_init_prep_sg:
+	dma_unmap_single(lp->dev, addr, lp->max_frm_size, DMA_FROM_DEVICE);
+	dev_kfree_skb(skb);
+rx_bd_init_skb:
+	kmem_cache_free(lp->skb_cache, axi_skb);
+	return ret;
+}
+
+/**
+ * axienet_setup_dma_chan - request the dma channels.
+ * @ndev:       Pointer to net_device structure
+ *
+ * Return: 0, on success.
+ *          non-zero error value on failure
+ *
+ * This function requests the TX and RX channels. It also submits the
+ * allocated skb buffers and call back APIs to dmaengine.
+ *
+ */
+static int axienet_setup_dma_chan(struct net_device *ndev)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+	int i, ret;
+
+	lp->tx_chan = dma_request_chan(lp->dev, "tx_chan0");
+	if (IS_ERR(lp->tx_chan)) {
+		ret = PTR_ERR(lp->tx_chan);
+		if (ret != -EPROBE_DEFER)
+			netdev_err(ndev, "No Ethernet DMA (TX) channel found\n");
+		return ret;
+	}
+
+	lp->rx_chan = dma_request_chan(lp->dev, "rx_chan0");
+	if (IS_ERR(lp->rx_chan)) {
+		ret = PTR_ERR(lp->rx_chan);
+		if (ret != -EPROBE_DEFER)
+			netdev_err(ndev, "No Ethernet DMA (RX) channel found\n");
+		goto err_dma_request_rx;
+	}
+	lp->skb_cache = kmem_cache_create("ethernet", sizeof(struct axi_skbuff),
+					  0, 0, NULL);
+	if (!lp->skb_cache) {
+		ret =  -ENOMEM;
+		goto err_kmem;
+	}
+	/* TODO: Instead of BD_NUM_DEFAULT use runtime support*/
+	for (i = 0; i < RX_BUF_NUM_DEFAULT; i++)
+		axienet_rx_submit_desc(ndev);
+	dma_async_issue_pending(lp->rx_chan);
+
+	return 0;
+err_kmem:
+	dma_release_channel(lp->rx_chan);
+err_dma_request_rx:
+	dma_release_channel(lp->tx_chan);
+	return ret;
+}
+
+/**
+ * axienet_init_dmaengine - init the dmaengine code.
+ * @ndev:       Pointer to net_device structure
+ *
+ * Return: 0, on success.
+ *          non-zero error value on failure
+ *
+ * This is the dmaengine initialization code.
+ */
+static inline int axienet_init_dmaengine(struct net_device *ndev)
+{
+	int ret;
+
+	ret = axienet_setup_dma_chan(ndev);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 /**
  * axienet_init_legacy_dma - init the dma legacy code.
  * @ndev:       Pointer to net_device structure
@@ -1239,7 +1520,20 @@ static int axienet_open(struct net_device *ndev)
 
 	phylink_start(lp->phylink);
 
-	if (!AXIENET_USE_DMA(lp)) {
+	if (AXIENET_USE_DMA(lp)) {
+		ret = axienet_init_dmaengine(ndev);
+		if (ret < 0)
+			goto error_code;
+
+		/* Enable interrupts for Axi Ethernet core (if defined) */
+		if (lp->eth_irq > 0) {
+			ret = request_irq(lp->eth_irq, axienet_eth_irq, IRQF_SHARED,
+					  ndev->name, ndev);
+			if (ret)
+				goto error_code;
+		}
+
+	} else {
 		ret = axienet_init_legacy_dma(ndev);
 		if (ret)
 			goto error_code;
@@ -1287,6 +1581,12 @@ static int axienet_stop(struct net_device *ndev)
 		free_irq(lp->tx_irq, ndev);
 		free_irq(lp->rx_irq, ndev);
 		axienet_dma_bd_release(ndev);
+	} else {
+		dmaengine_terminate_all(lp->tx_chan);
+		dmaengine_terminate_all(lp->rx_chan);
+
+		dma_release_channel(lp->rx_chan);
+		dma_release_channel(lp->tx_chan);
 	}
 
 	axienet_iow(lp, XAE_IE_OFFSET, 0);
@@ -2136,6 +2436,33 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 		netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
 		netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
+	} else {
+		struct xilinx_vdma_config cfg;
+		struct dma_chan *tx_chan;
+
+		lp->eth_irq = platform_get_irq_optional(pdev, 0);
+		tx_chan = dma_request_chan(lp->dev, "tx_chan0");
+
+		if (IS_ERR(tx_chan)) {
+			ret = PTR_ERR(tx_chan);
+			if (ret != -EPROBE_DEFER)
+				dev_err(&pdev->dev, "No Ethernet DMA (TX) channel found\n");
+			goto cleanup_clk;
+		}
+
+		cfg.reset = 1;
+		/* As name says VDMA but it has support for DMA channel reset*/
+		ret = xilinx_vdma_channel_set_config(tx_chan, &cfg);
+
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Reset channel failed\n");
+			dma_release_channel(tx_chan);
+			goto cleanup_clk;
+		} else {
+			lp->has_dmas = 1;
+		}
+
+		dma_release_channel(tx_chan);
 	}
 
 	/* Check for Ethernet core IRQ (optional) */
-- 
2.25.1


