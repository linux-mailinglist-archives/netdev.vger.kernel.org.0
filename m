Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C504CE058
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiCDWoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiCDWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:27 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2538760ABF
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:37 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224LSl4W027177;
        Fri, 4 Mar 2022 17:43:07 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj2HlrjZ4X8hNbaAW/oDYgpf/2SOIqVllEl+kQPJg/i2bBxhzJQ6+rxIocShp7ntwxmxaleKHR3XjEFm6jtahajkifVj5cFYRosUXzjYeDjxwqjAqgZ8BNRGnl1sLhTxp66VEdbc0oRY/aZrrJmz+HHQ5jRiJiE5f+sImmWQBYu/Xa8Kfgq5HAFB5vR8bDHts8i0lAQc8kUagYkmZ6m+jcX9OcrhEhNqxjjo8EtAc/t4sphbYMSEcfhZ4SGQ4mZ1rKRYzCYCcozol6k8vwbcZsrBzTuvx6pzj8LO/lxSWTYRFKSBByqu3SfWHaBm29f/Xzs9CoH5OWE5AV6l8VRE6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZUXRyPwF/A4DsVbLLd3qDbkRarWy6Sfv3TI1cbFoP8=;
 b=Y0M+STTJNsl847U+qAKYXnhuxfNQt+Efknbwq+QCv3xrefliwW0GTw+BuY6c4qF4sNVBLWm8igyoRu+5TAZbayswXIOzSPjBuGh/UpQyUCbhcgFxepP70MXvwDND87ondI9/Ro5kRJTyUNliUHfueHSB9zYqFUUOG8Z3lbWwDET/NLaEPhx5UmCVqsNk4fUP/xjDQ0Ys8KtrzwjTKutllHlixv0I3PQnDnopuOgRvbowGiWRtVj5PITtyayuEvhKW8A15BUNLNNuWQp1SVbbuKbRHeUYvjt3N+6DSuKwiKr/YfH21d3FmfeiYwECLRhP93yGgz9Nt9xW6PpU9OOBdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZUXRyPwF/A4DsVbLLd3qDbkRarWy6Sfv3TI1cbFoP8=;
 b=IkYdGUzPEuio60VSWvQaLNNKY27OIjxqn7smhZEgYm4+RpbiEM8+DI+gNFM1EhaODPiqHBwv7XO/wFt8JkDGvkm6w+Fgq9TfR/LSt0zpKlvKCt0biadH8wiEQ97bE/Mps60vSbAkAVILX05eSRpBKSOeVMdTNuDqjo6gUVzLiSM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:06 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:06 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 7/7] net: axienet: add coalesce timer ethtool configuration
Date:   Fri,  4 Mar 2022 16:42:05 -0600
Message-Id: <20220304224205.3198029-8-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220304224205.3198029-1-robert.hancock@calian.com>
References: <20220304224205.3198029-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:610:b1::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c34d08d7-09f3-4840-6fc5-08d9fe305976
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB65409383C331B0016D5481DAEC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VxuGnxJFfCcORoh+ZarPpj7EpIifb/rVg9+B/LEXPEuT66WbvWeVDyYoSkF1g1196jjpn2nOAGx+blpL8nw7uiIrx1NUjxxvNo1fh+9d75lotKbw7tDswJr3KEfiJPwVr6eVruSNdARRwkfmhPifJdOZxR1Tl7zROEpMofF2YH3mP8X+M82kt0zS6n5NpZqW84wJ/kaehcdMsh6LyorMe87UD1NociHIPxU1R0xpEMLJFR240221S1i0jFYsgFR200iSvETq+1npFY5tyM0SJIkO2vN7hf/J60dxYGX7KVhhNxPNBE1+RlSdzyMwvXZ4qTcgh6z+Y8bI6Dq2NdW6+cvPNmA6IJrk79+IzMdW3UvwB3SkkcWx4mtdlNIjzfVxCTGhRIEhbv1jBkKQRWxyCsz8MdloPSa09OvAHLAUGMAk4i/rh1Be17lFwIIy3WsktgjP4i+7hkKFbcNWUBUaIhDACG1jXuB5mxAF8OIuPjGj/u3o2CpBgTJ1iYB91h2fdFgkQY5aGxsRnqKpjsC4junl+4VxJyHVoDsmD6aqP9bCdiQtlge0jMHOfzq3PQNeqj/uE3ika99+/r6hiRVxC8CjulAmSZWAvTsLLGVtAlPBwwXXbnGfcaCMqiir/nYYDwNwZNGQMzpzO4gWLt/59+MtrcZcPUbg+vtC4I2X2xOehX8wHJ34x7jP3xjzNG4+LSFqRLQGObVS6n/thZSZKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sbVznQ3WswYAtxZaehYyLs9ktb2bBjuMC13EHwzbD12THqgFWg8pDJyLEE6o?=
 =?us-ascii?Q?pA1JA1N+aNQlLX4py4SIYsQGgR9Ok0oeibuxv9UhNzALgi8AYj5WOt6BoeZq?=
 =?us-ascii?Q?3zkD/vEkFyXI/XONyZRpzD3RLE6MfGzPXYPPJ+woCWR1UPmatGSBSz9m+TLq?=
 =?us-ascii?Q?lKquJI/ium2S0IvyKZ5LKjSyE31XFltX5EBth4lqWTyiGIhanztEQZOo5wnD?=
 =?us-ascii?Q?9d8ZfPZryCFab2J96E0hx5DrmhjtIpMpmRP/dEgMFiooJMJhtn5hFqY/aFe8?=
 =?us-ascii?Q?6Sxsn3Fux43S83favnQZ0acMox28C6Fyly1axw0ghN3tcl5upJGcsZUk9npF?=
 =?us-ascii?Q?qXfEAOSuh7IPEEyUnldlsNbgNt4RMw2DP7Q+SD8P3R6UwDOWF1Gs2CHYyvgS?=
 =?us-ascii?Q?YcR6xDTMS7OTK7Ser4NqnnMA8ptX5IT+4XTGMILKKaUZbX/3nJXCVPkq5lTA?=
 =?us-ascii?Q?/4LQZLQyYXnSdVWfVKI7L9/T8V3WKSmOKxg+6eLcPxmQKgXy1Qm+E+NZpIZq?=
 =?us-ascii?Q?tLFwIMQ1Dkwa7O5m9rSKrsTBIa4oUl8jCR7CLXhlcH0/t0gYzbCeRgdYojFf?=
 =?us-ascii?Q?A3d78RL60xzrJDAxnLjWpcMQy0VxGTMjRDXNe/hLvZYSmnrabbeLE+N/1ARp?=
 =?us-ascii?Q?2Sz3Lh5uNlum8gAfCCLehoHMyYroVrQYAyTPHrtt/eJ5p6DntF6/pVUzVQhN?=
 =?us-ascii?Q?AlCZQuzKfXk5HY0jh+SP96GjiuTXnnkhFTjKUwS/sPvfW5u8vyJJxcT1D6+a?=
 =?us-ascii?Q?v8Hz6LuWTF+2otpaV0TP5BWMBJty4ecdEFb/TFHrZXA2o6lBQX0QYFTPkftG?=
 =?us-ascii?Q?fXfqMtqxj0j0v/K/WYWMWZ1puxYBTeVYtyiI9CcvwLjYGab+6+sF4FaKzq25?=
 =?us-ascii?Q?3n9pyt+i96SRl+YSr0CFXYRlJuW9vb48djA4GODd76k3NWgOViBeBCRgngZ3?=
 =?us-ascii?Q?NX8O9vjj+PygIFzWIPyTKnDezN7jW3D27M2XzHTUbiJUPOS0lWLH+9RVhxUz?=
 =?us-ascii?Q?DhV4MuxOuIsacz3F/CgdhlXQRH3Pk2FWRa+JHdVlmu48UB6d5XJgCFmX2MVp?=
 =?us-ascii?Q?mMmUvqlI52ZDo6DUsSvgaQz4DYL40Gm0Si4TntlE9lFzg91V9A5oyE2f3BPM?=
 =?us-ascii?Q?Xs/RNZZa5ErS6SS4KCx6v73Y+K9q6U9AVOTKcYTjdKt46AUUwiIjww45Q0iO?=
 =?us-ascii?Q?cu2W8j0Unsv6L/mOwDAjfFPcSUnvoRWF8h4yzLFMDHAhjDunCoHtEMsaqYb3?=
 =?us-ascii?Q?xc8x6B3eViVuINDBIF9Rq8cRTB2fcgXpEO5y/jKkgrhMy+BJwRiV5PF04YrM?=
 =?us-ascii?Q?TLScjlpl77bXyipsi4Y88H3eljy4t2sptliAkW9gGklmoQN6CSt7c5nqSdvb?=
 =?us-ascii?Q?gHoX2nQmY1u7D9Xr5BvYtnyR8ESSQuh7Jigz6KzYMbBI/xg/22mD4arEf1NR?=
 =?us-ascii?Q?/V7lloaHOkPMkTRsEKz03jfxnzqE3VOzySjVczquBDizowHFdXKtZvk2Zn0r?=
 =?us-ascii?Q?UGsH2DR6SDPPfvK4wpdP8lW6XbvFOv9YCjjrY9hG+JlaU5PTec+BoA3PQcbt?=
 =?us-ascii?Q?c1LDONUYVApSdZNWV5BtjF0MV/7WxJChHbwDB/GSpJg6IMzuGta3+yXOfj4E?=
 =?us-ascii?Q?hclW0ETEAxkEaczXojieA008QNpI1PA/CNp1Scnt7K1L/wfXAom25OvLhD1c?=
 =?us-ascii?Q?ody4aXA/6r/AUd5M1WWQxwHcvxI=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c34d08d7-09f3-4840-6fc5-08d9fe305976
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:06.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXKISek+TEKoHM4EOwu37WGMvLLQKOjZL3rQxcxdgZF4GxPr7dJdV5mu3Lfr3jwJ62n68GmgTFQvEGOP78H1YgQlFClxe2TcHP9HsiHCZ/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: QcXxYJHU6zw68rjCYtlcrLTaiJzhYF8w
X-Proofpoint-GUID: QcXxYJHU6zw68rjCYtlcrLTaiJzhYF8w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040112
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to configure the RX/TX coalesce timer with ethtool.
Change default setting to scale with the clock rate rather than being a
fixed number of clock cycles.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 49 +++++++++++++++----
 2 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6f0f13b4fb1a..f6d365cb57de 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -119,11 +119,11 @@
 #define XAXIDMA_IRQ_ERROR_MASK		0x00004000 /* Error interrupt */
 #define XAXIDMA_IRQ_ALL_MASK		0x00007000 /* All interrupts */
 
-/* Default TX/RX Threshold and waitbound values for SGDMA mode */
+/* Default TX/RX Threshold and delay timer values for SGDMA mode */
 #define XAXIDMA_DFT_TX_THRESHOLD	24
-#define XAXIDMA_DFT_TX_WAITBOUND	254
+#define XAXIDMA_DFT_TX_USEC		50
 #define XAXIDMA_DFT_RX_THRESHOLD	1
-#define XAXIDMA_DFT_RX_WAITBOUND	254
+#define XAXIDMA_DFT_RX_USEC		50
 
 #define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
 #define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
@@ -482,7 +482,9 @@ struct axienet_local {
 	int csum_offload_on_rx_path;
 
 	u32 coalesce_count_rx;
+	u32 coalesce_usec_rx;
 	u32 coalesce_count_tx;
+	u32 coalesce_usec_tx;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 828ab7a81797..8d908a5feea2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -226,6 +226,28 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			  lp->rx_bd_p);
 }
 
+/**
+ * axienet_usec_to_timer - Calculate IRQ delay timer value
+ * @lp:		Pointer to the axienet_local structure
+ * @coalesce_usec: Microseconds to convert into timer value
+ */
+static u32 axienet_usec_to_timer(struct axienet_local *lp, u32 coalesce_usec)
+{
+	u32 result;
+	u64 clk_rate = 125000000; /* arbitrary guess if no clock rate set */
+
+	if (lp->axi_clk)
+		clk_rate = clk_get_rate(lp->axi_clk);
+
+	/* 1 Timeout Interval = 125 * (clock period of SG clock) */
+	result = DIV_ROUND_CLOSEST((u64)coalesce_usec * clk_rate,
+				   (u64)125000000);
+	if (result > 255)
+		result = 255;
+
+	return result;
+}
+
 /**
  * axienet_dma_start - Set up DMA registers and start DMA operation
  * @lp:		Pointer to the axienet_local structure
@@ -241,7 +263,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_rx > 1)
-		lp->rx_dma_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		lp->rx_dma_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_rx)
+					<< XAXIDMA_DELAY_SHIFT) |
 				 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 
@@ -252,7 +275,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_tx > 1)
-		tx_cr |= (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		tx_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_tx)
+				<< XAXIDMA_DELAY_SHIFT) |
 			 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
 
@@ -1487,14 +1511,12 @@ axienet_ethtools_get_coalesce(struct net_device *ndev,
 			      struct kernel_ethtool_coalesce *kernel_coal,
 			      struct netlink_ext_ack *extack)
 {
-	u32 regval = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
-	regval = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	ecoalesce->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
-					     >> XAXIDMA_COALESCE_SHIFT;
-	regval = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	ecoalesce->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
-					     >> XAXIDMA_COALESCE_SHIFT;
+
+	ecoalesce->rx_max_coalesced_frames = lp->coalesce_count_rx;
+	ecoalesce->rx_coalesce_usecs = lp->coalesce_usec_rx;
+	ecoalesce->tx_max_coalesced_frames = lp->coalesce_count_tx;
+	ecoalesce->tx_coalesce_usecs = lp->coalesce_usec_tx;
 	return 0;
 }
 
@@ -1527,8 +1549,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
 
 	if (ecoalesce->rx_max_coalesced_frames)
 		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
+	if (ecoalesce->rx_coalesce_usecs)
+		lp->coalesce_usec_rx = ecoalesce->rx_coalesce_usecs;
 	if (ecoalesce->tx_max_coalesced_frames)
 		lp->coalesce_count_tx = ecoalesce->tx_max_coalesced_frames;
+	if (ecoalesce->tx_coalesce_usecs)
+		lp->coalesce_usec_tx = ecoalesce->tx_coalesce_usecs;
 
 	return 0;
 }
@@ -1559,7 +1585,8 @@ static int axienet_ethtools_nway_reset(struct net_device *dev)
 }
 
 static const struct ethtool_ops axienet_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USECS,
 	.get_drvinfo    = axienet_ethtools_get_drvinfo,
 	.get_regs_len   = axienet_ethtools_get_regs_len,
 	.get_regs       = axienet_ethtools_get_regs,
@@ -2046,7 +2073,9 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
+	lp->coalesce_usec_rx = XAXIDMA_DFT_RX_USEC;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
+	lp->coalesce_usec_tx = XAXIDMA_DFT_TX_USEC;
 
 	/* Reset core now that clocks are enabled, prior to accessing MDIO */
 	ret = __axienet_device_reset(lp);
-- 
2.31.1

