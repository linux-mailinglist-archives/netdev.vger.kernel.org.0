Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149294AEDEE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiBIJZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:25:17 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiBIJZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:25:12 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0618.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EC2E0AFABD
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:25:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkHKD3qG7CUmYqwndU5PIx0clvbp0HnKK18Q+reM1we8zr4VVDgrvQ3Qr0tlqHecx9PJlRdaUEyB6O8qZV8/IFl4RdiRpCJq1OFPxdzUBXNwYyEOsWu9DPDbjsHG9IDTrKfeQy7ETUq6UTft3iLJ/UH8JQQqeXcO2ESa7jJxJ80f2oca85EoyXqRIdoWyXUTWlNO0gi5nssNhVEPKmwt0ssxBNQn+zHYs56LqiLCXj9zVZftrb03z7Hz091tkAcrt4pqMInMtV2fEEDTOXBupfqwAA8LwCj5dICmzO9FzsbfimAIt1MO4iAbjmUf/8ev67HWffQ7Pa7yUydO4xLvrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/0aFghDfIYwFaUYpFKoORvxIYff2JFHE3Z80R9Pz3pw=;
 b=EVq3/ig218hpV/NNNEASnUxgpmXASGhrHQDTvNsm3XfF/mwPzjwCbucxiYHsuxAwtMbb2bQIr/kuKQPbXe6ccJ0awl4qWDdfk4Wk71+PlXVudMuOVJHfBJ0FkFrYcgeNiaIH1Ou2IXPcugn2PCCJohbkIK88JVylNfwoIa1ihmWzaA/E+s4smcKMtef7JscDXJL1A2EkJ8/bv6RyhfhC8X4WSfgIv40x+A94dqpEN3BJxGsrwnqGMAzHZEWYqDjL/AEBunpv3FY+ye93o3aHLGnQ0NBxPC3w+Mp5Bbs5UobBKmZzI+E47eKlTxTYK85k5fhUm6Ktof06JcIPuEueQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0aFghDfIYwFaUYpFKoORvxIYff2JFHE3Z80R9Pz3pw=;
 b=kEXTmH4RpSu6N8atTrlZuZPKUbGuqIPRAC5qdFGDGsOq5y7tNIU/Q10TUFXAVisCIAkWXETRrRoPAJh+V6+MVIeORMUXexllfZkl8p2n/tukFtgtgHvJRU6z0wGHHoa+RsrB9fNhhgpPjv5A+4MJUN44fBRWDCQa3plWEmqsAlY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM0PR04MB5972.eurprd04.prod.outlook.com (2603:10a6:208:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 09:24:05 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:04 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 6/7] dpaa2-eth: add support for software TSO
Date:   Wed,  9 Feb 2022 11:23:34 +0200
Message-Id: <20220209092335.3064731-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fced7a4f-db6e-4a02-fec6-08d9ebadeaa1
X-MS-TrafficTypeDiagnostic: AM0PR04MB5972:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB5972576508FEBFFDD8D06F7FE02E9@AM0PR04MB5972.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bq/NhxZ6QsPdnSbSU+g2mZRzGhuddNC0qd/YERXImWfm3zJ3Y1eB/4rH5srvmCg6AfK2E+/JkPPgrBaJwu1eFOj7bGZi8WlgZ2iTrkhxEBI8hluiRPOLLMSibyVG/o5UEmpLy8f0wEoGNAZY6Y3ot6/3A8ZS2J651ZOlNPxFmoJp9stYOp0ZGaYT1tuO6A4CpzjXzzL+VJmu5XM3F8BSirRWF4NR9/eK3QyOKvsZ2QoKp9gb+M8UUwLuLtDRn1RWfQsQ6P854uE8GsMM6CvlJOGTFyl11R9neWx5Eej0ToRWsIEHM+xoIy+S0bNeOKaT7ON4RfNq52t1vzOfCkkypbQbYRtec/u93loHgGTRi6p2uKCQjxMbcywmOHOdn5FxwMremHOCBx9I1+HqvsasvyXyaU/VSKhZVT/90jHH8aqTa31KQfBqDP/215FbmpXZ1+NJdfv94kPUYmkGJ+VD9b86JSN/EzG6ckhYqJrPlqRnC3a41iX1+PcB42psC9FsyDBgCyp1psV2qtHciDW/Y2TafuWdOWap3lOAhn5Za44M3FnOIfM6CHmm/nBZ6ChX4k5t2/HFLF93aflYPAVokOdMpN87IjY+imkQ8QOX2kTpPHyRUNnGCkXBOhJbFkTihmU72A9h2DUW/KNZcgntGVlvYLMuZIM0Bo7obwNoAMcDuJkGd2LX/WS6twNixhJwP99GYPXk/ZiG96XZ0CHywA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(38100700002)(2906002)(2616005)(5660300002)(38350700002)(44832011)(83380400001)(52116002)(6506007)(6512007)(36756003)(30864003)(186003)(6666004)(1076003)(316002)(86362001)(66946007)(66556008)(508600001)(4326008)(66476007)(8676002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y19Mt7LNRTA/P68ovVI7eVgdPYe/hEkA7SQwzbstJkOytdLkJXqIQylwwx9Q?=
 =?us-ascii?Q?RhKY/p0lBZDrA8oHJC6/KTpjgMmXPWbZ3sEVGxZlJUkqXZVdDGgRJUSxRM+U?=
 =?us-ascii?Q?Sk/eRusrtYvo18QGp4uFDwr6iBxh3bSyl8uZZuz/aBw9CF5m3Xveqf2OiUTu?=
 =?us-ascii?Q?Wk616ii+Jl093Wo1IjvmHWlofSvNwlgxqxHb7shM5ojVsY0pLE09JK9q+uv0?=
 =?us-ascii?Q?nNTIP0Wrfec6Q6L0i3nbR0b9B+7ZxpsH9bXDfo6rd/la2pRreOqFTWUrjvMo?=
 =?us-ascii?Q?JBQyM6rcgfXduHlcmtUjjj0Lxqnohyyvoyfe1wy2PwAD2EdKwg/1i2pQMSx2?=
 =?us-ascii?Q?eNBzAoHTtL2AQOfo0hxiZOrXB7/1WA7wDGx3+1stfuWCLBGkD3a0puUYUm4G?=
 =?us-ascii?Q?129oVu1XDrcf9JG9aCkH/cwURRUIQ8Zr0mSFWjCIB/dUhIbkesgUN+1xyrl5?=
 =?us-ascii?Q?oh97dwNQHiWiL9Ti/wk8yX3ute3RiOGFPOdhKCdqg2ULwe0xbK/EXGwguMYt?=
 =?us-ascii?Q?FOesI3iS7ps2Gz5Nb/E9so82YnxuzGw8PCVzYsHIvcKoL4U6mMLHv7GNsgCj?=
 =?us-ascii?Q?2AAfNvvuU22zRM2Q5/1/INSnTDPJ5fFeWK/aNJSnfVW4IFvd8x245C/FhyiQ?=
 =?us-ascii?Q?1NBH9VBkykZhFALyxh5E4I8Z8bLtqyDxC1hcRfz7LQQewhYu6Sv7y3x0Ns+f?=
 =?us-ascii?Q?r68xyr72JqpOCUDXH5/womiZfw8XjFbi8iRkkvxUcdElrkCcFA3u9b4M08Yb?=
 =?us-ascii?Q?WyohxV7p0JiXgojH7wtE9/b6RGHUykB3wnDMC8PWUfBpDKSbDjcOixD2899O?=
 =?us-ascii?Q?txbtqVnvm2wz3Q7eeJLQordk+NnTZMz+Kcfgp0WLah235fJpVdlWdK97bZiH?=
 =?us-ascii?Q?yN0CjwPG/Ycg+XiVoIa1A41EgQ5Nr52580lWPzfiaUULV8oyW4nvKn1AqazB?=
 =?us-ascii?Q?BXqkhkDxqTlKz5izJabozxCD4I2XUYF9k4fHrm5gsL5mFo/ITaWMgByyicgR?=
 =?us-ascii?Q?cVKHQk5GOuVz7y85bTtlVks/Fqq1b7mbqJRf9QHZqo+vAXo4yKxEjytrvc/A?=
 =?us-ascii?Q?1h//Fh6FopxAuDt/cuU5MdNSa/9mzVYlxdWGDh1t1Pn8cfFLxjanMyOGvUIS?=
 =?us-ascii?Q?BxdNqmx9vBzUQs3nx9yZBd/esSLUNise4Qss6jDJy+IteYyrWlv0lPk4raav?=
 =?us-ascii?Q?4AuKP4mEWV+lvV41THhpLD36L2yIxBiZZUzpHHvfnaRZ6nik4LXeIpuNUUEB?=
 =?us-ascii?Q?G6GM47EnucQbcGOgd8MqArhxpoD2lMxEPmys6bXxflkE2LQcuCGNMnTQzLVH?=
 =?us-ascii?Q?XC2eiRjxWXJqiq8ny8Sudh9NNaLwaSqkNVrzQNdNPeGj7PE/rsMk6QgQvsU2?=
 =?us-ascii?Q?j5X4vGPYdN2iWQU/bPiIMdy/JO6UwoolgTHjgiOYv7e8NpEvWDI8geOsxs++?=
 =?us-ascii?Q?Ec/fx8qTmlQ2f4QeOhRJEyseNoKVZAGa1+NNoae1zyBHnJeDFipYf9bfi5wK?=
 =?us-ascii?Q?skGryRb95ig7YeliWQ0UbGajgxTp+pKiUKP76KRMG75BWT6XaxKPwJubPR4h?=
 =?us-ascii?Q?3yMgMuqJSmlJlzdg0VJbwjGWVlVWps2FQ1QoPW5Eqh22nMTI1bNm73aLqJzI?=
 =?us-ascii?Q?aRWoTP0DvDXpNssOslfYeJs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fced7a4f-db6e-4a02-fec6-08d9ebadeaa1
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:04.9084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kDOAPg9fbhSGMHScntcyhTvmlnL9dDWpnwTWMmAtwvEFH0Gym7NQHQFYilpXjkRuD5vgYNPBcJQmcxrD1zyIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for driver level TSO in the enetc driver using
the TSO API.

There is not much to say about this specific implementation. We are
using the usual tso_build_hdr(), tso_build_data() to create each data
segment, we create an array of S/G FDs where the first S/G entry is
referencing the header data and the remaining ones the data portion.

For the S/G Table buffer we use the same cache of buffers used on the
other non-GSO cases - dpaa2_eth_sgt_get() and dpaa2_eth_sgt_recycle().

We cannot keep a DMA coherent buffer for all the TSO headers because the
DPAA2 architecture does not work in a ring based fashion so we just
allocate a buffer each time.

Even with these limitations we get the following improvement in TCP
termination on the LX2160A SoC, on a single A72 core running at 2.2GHz.

before: 6.38Gbit/s
after:  8.48Gbit/s

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 214 ++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   9 +
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |   2 +
 3 files changed, 207 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d9871b9c1aad..88534aa29af2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -18,6 +18,7 @@
 #include <linux/ptp_classify.h>
 #include <net/pkt_cls.h>
 #include <net/sock.h>
+#include <net/tso.h>
 
 #include "dpaa2-eth.h"
 
@@ -1029,6 +1030,8 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 	u8 fd_format = dpaa2_fd_get_format(fd);
 	u32 fd_len = dpaa2_fd_get_len(fd);
 	struct dpaa2_sg_entry *sgt;
+	int should_free_skb = 1;
+	int i;
 
 	fd_addr = dpaa2_fd_get_addr(fd);
 	buffer_start = dpaa2_iova_to_virt(priv->iommu_domain, fd_addr);
@@ -1060,6 +1063,28 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 			/* Unmap the SGT buffer */
 			dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
 					 DMA_BIDIRECTIONAL);
+		} else if (swa->type == DPAA2_ETH_SWA_SW_TSO) {
+			skb = swa->tso.skb;
+
+			sgt = (struct dpaa2_sg_entry *)(buffer_start +
+							priv->tx_data_offset);
+
+			/* Unmap and free the header */
+			dma_unmap_single(dev, dpaa2_sg_get_addr(sgt), TSO_HEADER_SIZE,
+					 DMA_TO_DEVICE);
+			kfree(dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt)));
+
+			/* Unmap the other SG entries for the data */
+			for (i = 1; i < swa->tso.num_sg; i++)
+				dma_unmap_single(dev, dpaa2_sg_get_addr(&sgt[i]),
+						 dpaa2_sg_get_len(&sgt[i]), DMA_TO_DEVICE);
+
+			/* Unmap the SGT buffer */
+			dma_unmap_single(dev, fd_addr, swa->sg.sgt_size,
+					 DMA_BIDIRECTIONAL);
+
+			if (!swa->tso.is_last_fd)
+				should_free_skb = 0;
 		} else {
 			skb = swa->single.skb;
 
@@ -1088,26 +1113,172 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 	}
 
 	/* Get the timestamp value */
-	if (skb->cb[0] == TX_TSTAMP) {
-		struct skb_shared_hwtstamps shhwtstamps;
-		__le64 *ts = dpaa2_get_ts(buffer_start, true);
-		u64 ns;
-
-		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-
-		ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
-		shhwtstamps.hwtstamp = ns_to_ktime(ns);
-		skb_tstamp_tx(skb, &shhwtstamps);
-	} else if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
-		mutex_unlock(&priv->onestep_tstamp_lock);
+	if (swa->type != DPAA2_ETH_SWA_SW_TSO) {
+		if (skb->cb[0] == TX_TSTAMP) {
+			struct skb_shared_hwtstamps shhwtstamps;
+			__le64 *ts = dpaa2_get_ts(buffer_start, true);
+			u64 ns;
+
+			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+
+			ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
+			shhwtstamps.hwtstamp = ns_to_ktime(ns);
+			skb_tstamp_tx(skb, &shhwtstamps);
+		} else if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
+			mutex_unlock(&priv->onestep_tstamp_lock);
+		}
 	}
 
 	/* Free SGT buffer allocated on tx */
 	if (fd_format != dpaa2_fd_single)
 		dpaa2_eth_sgt_recycle(priv, buffer_start);
 
-	/* Move on with skb release */
-	napi_consume_skb(skb, in_napi);
+	/* Move on with skb release. If we are just confirming multiple FDs
+	 * from the same TSO skb then only the last one will need to free the
+	 * skb.
+	 */
+	if (should_free_skb)
+		napi_consume_skb(skb, in_napi);
+}
+
+static int dpaa2_eth_build_gso_fd(struct dpaa2_eth_priv *priv,
+				  struct sk_buff *skb, struct dpaa2_fd *fd,
+				  int *num_fds, u32 *total_fds_len)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	int hdr_len, total_len, data_left, fd_len;
+	int num_sge, err, i, sgt_buf_size;
+	struct dpaa2_fd *fd_start = fd;
+	struct dpaa2_sg_entry *sgt;
+	struct dpaa2_eth_swa *swa;
+	dma_addr_t sgt_addr, addr;
+	dma_addr_t tso_hdr_dma;
+	unsigned int index = 0;
+	struct tso_t tso;
+	char *tso_hdr;
+	void *sgt_buf;
+
+	/* Initialize the TSO handler, and prepare the first payload */
+	hdr_len = tso_start(skb, &tso);
+	*total_fds_len = 0;
+
+	total_len = skb->len - hdr_len;
+	while (total_len > 0) {
+		/* Prepare the HW SGT structure for this frame */
+		sgt_buf = dpaa2_eth_sgt_get(priv);
+		if (unlikely(!sgt_buf)) {
+			netdev_err(priv->net_dev, "dpaa2_eth_sgt_get() failed\n");
+			err = -ENOMEM;
+			goto err_sgt_get;
+		}
+		sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
+
+		/* Determine the data length of this frame */
+		data_left = min_t(int, skb_shinfo(skb)->gso_size, total_len);
+		total_len -= data_left;
+		fd_len = data_left + hdr_len;
+
+		/* Prepare packet headers: MAC + IP + TCP */
+		tso_hdr = kmalloc(TSO_HEADER_SIZE, GFP_ATOMIC);
+		if (!tso_hdr) {
+			err =  -ENOMEM;
+			goto err_alloc_tso_hdr;
+		}
+
+		tso_build_hdr(skb, tso_hdr, &tso, data_left, total_len == 0);
+		tso_hdr_dma = dma_map_single(dev, tso_hdr, TSO_HEADER_SIZE, DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, tso_hdr_dma)) {
+			netdev_err(priv->net_dev, "dma_map_single(tso_hdr) failed\n");
+			err = -ENOMEM;
+			goto err_map_tso_hdr;
+		}
+
+		/* Setup the SG entry for the header */
+		dpaa2_sg_set_addr(sgt, tso_hdr_dma);
+		dpaa2_sg_set_len(sgt, hdr_len);
+		dpaa2_sg_set_final(sgt, data_left > 0 ? false : true);
+
+		/* Compose the SG entries for each fragment of data */
+		num_sge = 1;
+		while (data_left > 0) {
+			int size;
+
+			/* Move to the next SG entry */
+			sgt++;
+			size = min_t(int, tso.size, data_left);
+
+			addr = dma_map_single(dev, tso.data, size, DMA_TO_DEVICE);
+			if (dma_mapping_error(dev, addr)) {
+				netdev_err(priv->net_dev, "dma_map_single(tso.data) failed\n");
+				err = -ENOMEM;
+				goto err_map_data;
+			}
+			dpaa2_sg_set_addr(sgt, addr);
+			dpaa2_sg_set_len(sgt, size);
+			dpaa2_sg_set_final(sgt, size == data_left ? true : false);
+
+			num_sge++;
+
+			/* Build the data for the __next__ fragment */
+			data_left -= size;
+			tso_build_data(skb, &tso, size);
+		}
+
+		/* Store the skb backpointer in the SGT buffer */
+		sgt_buf_size = priv->tx_data_offset + num_sge * sizeof(struct dpaa2_sg_entry);
+		swa = (struct dpaa2_eth_swa *)sgt_buf;
+		swa->type = DPAA2_ETH_SWA_SW_TSO;
+		swa->tso.skb = skb;
+		swa->tso.num_sg = num_sge;
+		swa->tso.sgt_size = sgt_buf_size;
+		swa->tso.is_last_fd = total_len == 0 ? 1 : 0;
+
+		/* Separately map the SGT buffer */
+		sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(dev, sgt_addr))) {
+			netdev_err(priv->net_dev, "dma_map_single(sgt_buf) failed\n");
+			err = -ENOMEM;
+			goto err_map_sgt;
+		}
+
+		/* Setup the frame descriptor */
+		memset(fd, 0, sizeof(struct dpaa2_fd));
+		dpaa2_fd_set_offset(fd, priv->tx_data_offset);
+		dpaa2_fd_set_format(fd, dpaa2_fd_sg);
+		dpaa2_fd_set_addr(fd, sgt_addr);
+		dpaa2_fd_set_len(fd, fd_len);
+		dpaa2_fd_set_ctrl(fd, FD_CTRL_PTA);
+
+		*total_fds_len += fd_len;
+		/* Advance to the next frame descriptor */
+		fd++;
+		index++;
+	}
+
+	*num_fds = index;
+
+	return 0;
+
+err_map_sgt:
+err_map_data:
+	/* Unmap all the data S/G entries for the current FD */
+	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
+	for (i = 1; i < num_sge; i++)
+		dma_unmap_single(dev, dpaa2_sg_get_addr(&sgt[i]),
+				 dpaa2_sg_get_len(&sgt[i]), DMA_TO_DEVICE);
+
+	/* Unmap the header entry */
+	dma_unmap_single(dev, tso_hdr_dma, TSO_HEADER_SIZE, DMA_TO_DEVICE);
+err_map_tso_hdr:
+	kfree(tso_hdr);
+err_alloc_tso_hdr:
+	dpaa2_eth_sgt_recycle(priv, sgt_buf);
+err_sgt_get:
+	/* Free all the other FDs that were already fully created */
+	for (i = 0; i < index; i++)
+		dpaa2_eth_free_tx_fd(priv, NULL, &fd_start[i], false);
+
+	return err;
 }
 
 static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
@@ -1123,10 +1294,10 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 	struct netdev_queue *nq;
 	struct dpaa2_fd *fd;
 	u16 queue_mapping;
+	void *swa = NULL;
 	u8 prio = 0;
 	int err, i;
 	u32 fd_len;
-	void *swa;
 
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
@@ -1146,7 +1317,13 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 
 	/* Setup the FD fields */
 
-	if (skb_is_nonlinear(skb)) {
+	if (skb_is_gso(skb)) {
+		err = dpaa2_eth_build_gso_fd(priv, skb, fd, &num_fds, &fd_len);
+		percpu_extras->tx_sg_frames += num_fds;
+		percpu_extras->tx_sg_bytes += fd_len;
+		percpu_extras->tx_tso_frames += num_fds;
+		percpu_extras->tx_tso_bytes += fd_len;
+	} else if (skb_is_nonlinear(skb)) {
 		err = dpaa2_eth_build_sg_fd(priv, skb, fd, &swa);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
@@ -1168,7 +1345,7 @@ static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
 		goto err_build_fd;
 	}
 
-	if (skb->cb[0])
+	if (swa && skb->cb[0])
 		dpaa2_eth_enable_tx_tstamp(priv, fd, swa, skb);
 
 	/* Tracing point */
@@ -4138,7 +4315,8 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->features = NETIF_F_RXCSUM |
 			    NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_SG | NETIF_F_HIGHDMA |
-			    NETIF_F_LLTX | NETIF_F_HW_TC;
+			    NETIF_F_LLTX | NETIF_F_HW_TC | NETIF_F_TSO;
+	net_dev->gso_max_segs = DPAA2_ETH_ENQUEUE_MAX_FDS;
 	net_dev->hw_features = net_dev->features;
 
 	if (priv->dpni_attrs.vlan_filter_entries)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 64e4aaebdcb2..b79831cd1a94 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -122,6 +122,7 @@ enum dpaa2_eth_swa_type {
 	DPAA2_ETH_SWA_SINGLE,
 	DPAA2_ETH_SWA_SG,
 	DPAA2_ETH_SWA_XDP,
+	DPAA2_ETH_SWA_SW_TSO,
 };
 
 /* Must keep this struct smaller than DPAA2_ETH_SWA_SIZE */
@@ -142,6 +143,12 @@ struct dpaa2_eth_swa {
 			int dma_size;
 			struct xdp_frame *xdpf;
 		} xdp;
+		struct {
+			struct sk_buff *skb;
+			int num_sg;
+			int sgt_size;
+			int is_last_fd;
+		} tso;
 	};
 };
 
@@ -354,6 +361,8 @@ struct dpaa2_eth_drv_stats {
 	__u64	tx_conf_bytes;
 	__u64	tx_sg_frames;
 	__u64	tx_sg_bytes;
+	__u64	tx_tso_frames;
+	__u64	tx_tso_bytes;
 	__u64	rx_sg_frames;
 	__u64	rx_sg_bytes;
 	/* Linear skbs sent as a S/G FD due to insufficient headroom */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 3fdbf87dccb1..eea7d7a07c00 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -44,6 +44,8 @@ static char dpaa2_ethtool_extras[][ETH_GSTRING_LEN] = {
 	"[drv] tx conf bytes",
 	"[drv] tx sg frames",
 	"[drv] tx sg bytes",
+	"[drv] tx tso frames",
+	"[drv] tx tso bytes",
 	"[drv] rx sg frames",
 	"[drv] rx sg bytes",
 	"[drv] tx converted sg frames",
-- 
2.33.1

