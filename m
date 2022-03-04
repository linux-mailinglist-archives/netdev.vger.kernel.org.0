Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836C24CE059
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiCDWod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiCDWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:27 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2541162103
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:37 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224LSl4U027177;
        Fri, 4 Mar 2022 17:43:06 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvNiwLIE6qVrxtnjLz5jClq8BVjjTPAMb762TVoY62wY5W7Rnk2MxxFcj4mQe3GmuOWdG8mhQd/LZIhs0Ms7s4doMWNBjORVi9DMNv0NXOtfqubGfLehWKrZuOkKXBFiLWWfdsVrPRp1pcxZfwHGlJWdKc+I74fUBXrJ6z0wOZFmfFClYbqzTAdFIlhWehw543631KiXmGdAOscLq8RdohDSiY8/pURB3s2840beGvhqDWpmMUOz4HxrCTx0RgSmYGqXnPeo8E35g5B48ZX3I62jY11FHir4kfB2hXFpUQUCMNoXJEumM6564267eVffeEAPV9gsCkKpjYCxP1bwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djpgoEig26gaUh6KjQ1Pe6J81LBlkVvrNWaYPkm5YZA=;
 b=aH8pR3pT76MdcPB+CD+D0SgCjuKIuQ6OB84TlbnJ0gyEcP52rkqqa6D4FZuF/mfgPpRTcQMVhgC0UWL+T/Eg3FLSN2RPI13i6tTpRaiCqt0+nEYf9gN1f9tAOseHVnO+zVchDcyKLuCXEassffCQVWoslmDTzhbk471r+4OwqQKB3ysuI9PgY2mlVT0unrPNcLdbvV3+bTt26nzOGGrkOYjOznTal+c01v2cdIe2rIfceFua6jnQGGJEA+JRBRtaGdZ+zuoDQfb6nNABY3CXzHOL7CdODz6BULpXzhSA0aFcFErMv1u8oXbbY9cRa3FGZZc9YqxyIlyQD5STC7wy1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djpgoEig26gaUh6KjQ1Pe6J81LBlkVvrNWaYPkm5YZA=;
 b=AWKSKHCdPmP8nJClpEnc1+79SAz4e36Abfz0+la8Ps07Z/YFwVIRN9Ow07QYykGAA2YE/qkQv/I+P5urbWIzUUGYCztXnQXf4WcAo+LKm4vSaw0eRm2YlYmYMNrI0wWaGdmWQlPCx89b7+Ci3ga3m9JgPT4SRi8SbECs6npbbAg=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:04 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:04 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 5/7] net: axienet: implement NAPI and GRO receive
Date:   Fri,  4 Mar 2022 16:42:03 -0600
Message-Id: <20220304224205.3198029-6-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9426922a-2a90-4266-ec64-08d9fe305879
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB6540AD4F3B06B4AF66326863EC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OUm1oQ0CbeZBV8wnpvsrWbLyNf+c9pbVzZn/aTUi00biOb2qVIxNsFCvqF91E/NPIn1N/cLXTEst2mAvyRm36bjqGP9iM4E51RIWRj/LBYgGdYehG66omB0QKRylm5kwigNv/Og1Z1JdNcvb33pUCpQMSg4cnVHvb9B6h/+/7SuDO3VdUCx+tjzrn/esm5qT233Jg2k3/U+9PQ57V8X4wm17M5Y3lMwqt4731fdsMCByHPcZw8EtlhyazZ1kv+jvOG8behst+79/7vqdLjd8gl5S+uxEILfvtIfiFCHOBzPT5q3wlxZl6xje9JIlDM83SSoatS0rxkZVip9EWWeK1vkM8zsnyhqY5vs0YhYyci4Kz+xBvbqn0iEKSIrPIJk3WZGhRtOppit3Gg2K/mel8ylnswmxbDCeoomP00BHcGSN5v+cmRqHdJ/kn+nS0JJfF+GpDU8gJceHXv8ZpNar5CIRl6nBwXqmwOG1X3RTmiyVbJbaFnlz6B5xtrkK8GrZGYXVkzEp9SO9AlFW4nT6suXUs18tSflpnZhIfSfcvjEJtDtHEAGYanoFpYxO/Uyg6jRcbFbTHP4+1lGC1j2Z/9JAYfQUV2Rn1WhcUKSONn5mS9s9BajfHpyGQKFvh/u9O5O9q28x6+7BZftYabooxlBVdr2uXyxCRa+gWiRiCs9HIpwVforp8P32bhOtTzBAgv+qZ4sHl7l8sOx6elz+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R07S5u+CsWUF3JtfK3Yw7wm5yQ/Okz3FTUoC6xZqu9fpvvi9bVUX3HN+CHB1?=
 =?us-ascii?Q?r+hIW7I9OISToR/7tpZrfvjFy0RvfbayrnsAm0PJS1rlqqWbsXC45iQTjacF?=
 =?us-ascii?Q?RAvr6MWqFSNACmiBf0+kqRt8BjN9t33XnllKQY5ShyrPc4O4jmFjWnPP3Ma3?=
 =?us-ascii?Q?HYIW7IpVIc2v19qFe+e8WdS7xvqg4aIFCe0WFmzS3d+/MVTTL7+scHB+jlz+?=
 =?us-ascii?Q?uTQcl4tSgtcivkUH8+bIXVzM7wF4HTjyBllrF1yRjJA/VfHaXaktmIHFVuoe?=
 =?us-ascii?Q?nzQG2WIZKTBAyW5N3CaHXdIGXHSANKDbG7bAvIt63rRi50Ux6xnXRPbIbXjY?=
 =?us-ascii?Q?c1G64y1b4DS0d96SrRcS+RdmUlrjHZ908b4gMUh4kC7XrMssRv+T0Uhum+FX?=
 =?us-ascii?Q?0ih2QREEAth17NrRe7vmmU+fjs9CoThPRqPPGfDnlMG0OGMkZ2AzoTo+9RHt?=
 =?us-ascii?Q?e+hV6hehLRBV2nscmPAqIR3MtZw6pVJ7kzyp9+my8R//6qdqrQB1VpLWZTNE?=
 =?us-ascii?Q?13zcE+mUxwpysHaTkKVrU3d+xBhevk0QmoorMYVLK/25LqcMGGbso/L5ghCX?=
 =?us-ascii?Q?/QXgahn/NfhRMazx9QmJMGma41y0vqSDx42FPyT1TzM8gyKKryyNRGCxf0UO?=
 =?us-ascii?Q?Hd6pz23fCqgKgnyyo9b3iSbtZCw0OZSA+2CATQkVCESTRVSC6kGiLbkcDw3R?=
 =?us-ascii?Q?i+uZ8TshjeD4EXVwuiIzKh5hxlVkbtG9ruU4kcChsu2C1pW0qO8ORbzjKQr5?=
 =?us-ascii?Q?Gei5an4BnIrtmEzgbuSufUTQLZWMfHxWCqzaskg/ypNUyi4khDDtSMedahkc?=
 =?us-ascii?Q?bHcTbl/njhYRpa9A9f9R5YFioCPE+xBZGEwLImUGPmnK72o/+RD0FW5IO5C0?=
 =?us-ascii?Q?Lxy36vmXTscHKKHAOmFlKtz1d7YdOhCRCunONYhwdkL5coCSTLNz1z2nC7ch?=
 =?us-ascii?Q?VSgxBRwQdNnPMxVKCYkoRd4uQBJMnAiSVx3DuXGeC5XM28/QAEBmXV0xdiSy?=
 =?us-ascii?Q?RjOSWWQ9G0s4Bu564L49Pfr8fe9nSVv9s3HVB4/7ZKQ6O3Xge2t5RifHSj0p?=
 =?us-ascii?Q?VcBOxZCKLQyWQGq0z4VeyHlMMjsRKnsQOT7jsTnKgCF38Kc3xCCLlCdM5Eq1?=
 =?us-ascii?Q?N7jBshSuXvsS2/K5SSjiqna+WnkJ9PR2C7Eon+S+ybyFPBwUGW8u5Af/Mn+p?=
 =?us-ascii?Q?hXSxbkGVYdAHRrj+b4LovzS3ix61umX2nEdstXtc7L8oragGCDmddQhPZWyv?=
 =?us-ascii?Q?a4kTK9JNxNiqR7wfRL7sPV9l1iq3Zo6P/8JBIgXy/mxIb/L9IDEOLqPrucDN?=
 =?us-ascii?Q?OSnzkbqtSUqGkOAU82SBy4Gb8xO7wpKzd7YuRVhUDu6D/AMHaKzUZYinf83P?=
 =?us-ascii?Q?R2ha2XQK63cDcEjsrMl5RlgbGJC41IpQyhE8bQOdWJg9kysd7yL3v4EBeWJx?=
 =?us-ascii?Q?T9sd7GVH80WV5HdMJPUXtbtbrpZNDtcRZRwr56e2gGTXGirXO5hhOWu8pqBq?=
 =?us-ascii?Q?1s42I8QnZz7HqHJSXhMatCHFCp94ghCtplxTw9hB35B5X+dP9e+i0R0wEuRc?=
 =?us-ascii?Q?nvb3RzB0hX4zOlAHr055HnbUSWHhWMhQjsgt770j48Qvjad4jCq8CLY0XkK0?=
 =?us-ascii?Q?U11aq6I2d6bIkydEyxVE790CT4gMnBQQRpxbBm34c7RVfrYDMNZamDCK3D9Y?=
 =?us-ascii?Q?R4z+D/EfyVveYp1ON0hQpNCio1Q=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9426922a-2a90-4266-ec64-08d9fe305879
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:04.6972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gp686k+KvRxzQCBJ6P9H1fLM+9rWAiGAuAXL1Y3X6sHty5Zr4c4aatZ/wR5ExMsbXu77W28rEr5B5NcgVvFbbBK5H4toAoHa5lFU98kllUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: 02q2gFLqjTnoms3aPbwiRk3iqbiui164
X-Proofpoint-GUID: 02q2gFLqjTnoms3aPbwiRk3iqbiui164
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

Implement NAPI and GRO receive. In addition to better performance, this
also avoids handling RX packets in hard IRQ context, which reduces the
IRQ latency impact to other devices.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  6 ++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 80 ++++++++++++-------
 2 files changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 40108968b350..c771827587b3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -385,6 +385,7 @@ struct axidma_bd {
  * @phy_node:	Pointer to device node structure
  * @phylink:	Pointer to phylink instance
  * @phylink_config: phylink configuration settings
+ * @napi:	NAPI control structure
  * @pcs_phy:	Reference to PCS/PMA PHY if used
  * @pcs:	phylink pcs structure for PCS PHY
  * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
@@ -395,6 +396,7 @@ struct axidma_bd {
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
+ * @rx_dma_cr:  Nominal content of RX DMA control register
  * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
@@ -434,6 +436,8 @@ struct axienet_local {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
+	struct napi_struct napi;
+
 	struct mdio_device *pcs_phy;
 	struct phylink_pcs pcs;
 
@@ -449,6 +453,8 @@ struct axienet_local {
 	void __iomem *regs;
 	void __iomem *dma_regs;
 
+	u32 rx_dma_cr;
+
 	struct work_struct dma_err_task;
 
 	int tx_irq;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b374800279e7..828ab7a81797 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -7,7 +7,7 @@
  * Copyright (c) 2008-2009 Secret Lab Technologies Ltd.
  * Copyright (c) 2010 - 2011 Michal Simek <monstr@monstr.eu>
  * Copyright (c) 2010 - 2011 PetaLogix
- * Copyright (c) 2019 SED Systems, a division of Calian Ltd.
+ * Copyright (c) 2019 - 2022 Calian Advanced Technologies
  * Copyright (c) 2010 - 2012 Xilinx, Inc. All rights reserved.
  *
  * This is a driver for the Xilinx Axi Ethernet which is used in the Virtex6
@@ -232,18 +232,18 @@ static void axienet_dma_bd_release(struct net_device *ndev)
  */
 static void axienet_dma_start(struct axienet_local *lp)
 {
-	u32 rx_cr, tx_cr;
+	u32 tx_cr;
 
 	/* Start updating the Rx channel control register */
-	rx_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
-		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	lp->rx_dma_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
+			XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
 	/* Only set interrupt delay timer if not generating an interrupt on
 	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_rx > 1)
-		rx_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
-			 XAXIDMA_IRQ_DELAY_MASK;
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+		lp->rx_dma_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+				 XAXIDMA_IRQ_DELAY_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 
 	/* Start updating the Tx channel control register */
 	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
@@ -260,8 +260,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * halted state. This will make the Rx side ready for reception.
 	 */
 	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	rx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+	lp->rx_dma_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
 			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
@@ -875,28 +875,25 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 }
 
 /**
- * axienet_recv - Is called from Axi DMA Rx Isr to complete the received
- *		  BD processing.
- * @ndev:	Pointer to net_device structure.
+ * axienet_poll - Triggered by RX ISR to complete the received BD processing.
+ * @napi:	Pointer to NAPI structure.
  *
- * This function is invoked from the Axi DMA Rx isr to process the Rx BDs. It
- * does minimal processing and invokes "netif_rx" to complete further
- * processing.
+ * Return: Number of RX packets processed.
  */
-static void axienet_recv(struct net_device *ndev)
+static int axienet_poll(struct napi_struct *napi, int budget)
 {
 	u32 length;
 	u32 csumstatus;
 	u32 size = 0;
-	u32 packets = 0;
+	int packets = 0;
 	dma_addr_t tail_p = 0;
-	struct axienet_local *lp = netdev_priv(ndev);
-	struct sk_buff *skb, *new_skb;
 	struct axidma_bd *cur_p;
+	struct sk_buff *skb, *new_skb;
+	struct axienet_local *lp = container_of(napi, struct axienet_local, napi);
 
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
-	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
+	while (packets < budget && (cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
 		dma_addr_t phys;
 
 		/* Ensure we see complete descriptor update */
@@ -918,7 +915,7 @@ static void axienet_recv(struct net_device *ndev)
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
-			skb->protocol = eth_type_trans(skb, ndev);
+			skb->protocol = eth_type_trans(skb, lp->ndev);
 			/*skb_checksum_none_assert(skb);*/
 			skb->ip_summed = CHECKSUM_NONE;
 
@@ -937,13 +934,13 @@ static void axienet_recv(struct net_device *ndev)
 				skb->ip_summed = CHECKSUM_COMPLETE;
 			}
 
-			netif_rx(skb);
+			napi_gro_receive(napi, skb);
 
 			size += length;
 			packets++;
 		}
 
-		new_skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
+		new_skb = netdev_alloc_skb_ip_align(lp->ndev, lp->max_frm_size);
 		if (!new_skb)
 			break;
 
@@ -952,7 +949,7 @@ static void axienet_recv(struct net_device *ndev)
 				      DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
-				netdev_err(ndev, "RX DMA mapping error\n");
+				netdev_err(lp->ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
 			break;
 		}
@@ -972,11 +969,20 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 	}
 
-	ndev->stats.rx_packets += packets;
-	ndev->stats.rx_bytes += size;
+	lp->ndev->stats.rx_packets += packets;
+	lp->ndev->stats.rx_bytes += size;
 
 	if (tail_p)
 		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
+
+	if (packets < budget && napi_complete_done(napi, packets)) {
+		/* Re-enable RX completion interrupts. This should
+		 * cause an immediate interrupt if any RX packets are
+		 * already pending.
+		 */
+		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
+	}
+	return packets;
 }
 
 /**
@@ -1022,7 +1028,7 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
  *
  * Return: IRQ_HANDLED if device generated a RX interrupt, IRQ_NONE otherwise.
  *
- * This is the Axi DMA Rx Isr. It invokes "axienet_recv" to complete the BD
+ * This is the Axi DMA Rx Isr. It invokes NAPI polling to complete the RX BD
  * processing.
  */
 static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
@@ -1045,7 +1051,15 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 			   (lp->rx_bd_v[lp->rx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
 	} else {
-		axienet_recv(lp->ndev);
+		/* Disable further RX completion interrupts and schedule
+		 * NAPI receive.
+		 */
+		u32 cr = lp->rx_dma_cr;
+
+		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
+		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+
+		napi_schedule(&lp->napi);
 	}
 
 	return IRQ_HANDLED;
@@ -1121,6 +1135,8 @@ static int axienet_open(struct net_device *ndev)
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
+	napi_enable(&lp->napi);
+
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
 			  ndev->name, ndev);
@@ -1146,6 +1162,7 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&lp->napi);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
@@ -1169,6 +1186,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
+	napi_disable(&lp->napi);
+
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 
@@ -1704,6 +1723,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
+	napi_disable(&lp->napi);
+
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
@@ -1768,6 +1789,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
 	axienet_setoptions(ndev, lp->options);
+	napi_enable(&lp->napi);
 }
 
 /**
@@ -1816,6 +1838,8 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	netif_napi_add(ndev, &lp->napi, axienet_poll, NAPI_POLL_WEIGHT);
+
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
 		/* For backward compatibility, if named AXI clock is not present,
-- 
2.31.1

