Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1028B4CE240
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiCEC0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiCEC0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:18 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D3522C6FE
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:24 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2251xTip028466;
        Fri, 4 Mar 2022 21:25:05 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:25:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXB1x58yCALBWC2wLOCoOOCCo31OJzBFKTjdrhj5h80vkEPi4ndA2NtIUKtnP5aSviOuIEVqmXTYAb1D6q8261ivSgnlXMmBCejFNzU9ejuGFMcACCf7LgsWWyBF2jlxbxFRSCAhsdYao3JNqRt/3UsgIC/orT30wPUDwEr0HOCvkrbDppAKSCH0Ilx29qNdortyAjfN7dw7Vuhwf8GCJ1zhBPTvsWiu13GUdU8exqmUpIDiJcjRsQhWAWZj6I3cHMw8/zuc47i+zs7dOdxtKMTKGCmEZQfNNsHwy3raWhI4uTsdGGiTB9pEtg5/ZqgiGI2AP+xSm6R8Iwz6zZj3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/mhy89Aun6T16vM9L2JncCHXxVTmMnVX8HrwQjnRjg=;
 b=TQmOGr0umf4sEDHnq8xjGsXa3qmz1hxLrN64WWZVUOMc0NlpyX4tBXbhxsE7cvUedK+iHBOwjqaNJK3v2q3AU07yPixEETbJ6HbQmmVrqT+qGQgzQdhg6+5JdpKXUsDxhYgpublRGh0xjrgG28X6HjnLWRiZt1atI/3A8MvCDEpxhe8xN9c5VumWOPDsEDOf2DP2l7SUufMfxkLm2LurcxwNBnaUQEH6MbdzwNKmFP/7BNbBRITIx4DN0jeDZTWRF++iJh2o4J3wkOILMpqMj0Mz8FtC4IxHyJOKOF2Kpnr32DaYZ7AebFiuYma+kqagrfM3lp8/UzRnLxvlmh8F1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/mhy89Aun6T16vM9L2JncCHXxVTmMnVX8HrwQjnRjg=;
 b=0tLRmJBJgO+TIS6iQNijf6QfCN+f6K67ynmZZieXDUEPP36BnmaS0kqaT6aP124XxOaiwdRzOBTwF70QZGWNdarNeLxk/lLCpy86zslDb4JDjSyGUeghuST8SBEAeuHWsRirSatIHfl7Oeen058pigonNHuvLj4qODSsd+JztbQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:25:04 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:25:04 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 7/7] net: axienet: add coalesce timer ethtool configuration
Date:   Fri,  4 Mar 2022 20:24:43 -0600
Message-Id: <20220305022443.2708763-8-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305022443.2708763-1-robert.hancock@calian.com>
References: <20220305022443.2708763-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57b5ca24-c60b-453b-e639-08d9fe4f5b66
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184362A9DC9F728E9FE257BEC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMw2ay8apSkgS0ojARakTDD9lVjUijsIwdUHLk1KSdi8D3Gab+9oUmxyr7vmZLiXviYklbMm1aTlHPFd7+K3SKMtxFbV3fNhDFPBJw62ElWD2VeCJyxXmrtU5VknjiDiOzR7mC4eY9ePDGVGH8a5/Ylhl/26o1qPK6LqpIkbaG/fJpB2dfRoC64bP+rtSyTmiR1FEIr9sc110BS8VXzjH1SVdNj1c/OM5fw/eoSt3NHAyWEqPLrZi57AfKwTjelOdFOy6zl0/xuIQthB5w+BdXHPojxS/mWpBBfYELZJ1yMmSGrYQwnbKQYUcK1ckjJIXIYDxsa5vkWIxD3NHXZjhhdrOe8CMRbtW/7dkY9UfM5zKMsFMfxlwXCYfo/XiZZn074cFtzG/hSC+NPwGmRUM18edgyqXjzZPOP1PebUYJElv7Ou6dz1k8jcmxqf+aLDQbrGo+DwbZ1VfoH2NSM0rxarZZbqHRCKMvblCxexNRCHWvhpkq+Ka6ttD58EtwWHfTzZC+ABcgAKDBfbkV4cgL2Zfc6FKKyrx1jDZh2LFAYL/i5045e1UzeJ1nqSY+613fjiw7wdqBrJekvofI/7wWU5u9xFuvu1ya15iW8EE9KOS0VWNe8IwBGsADeYXV+HhQrjul5mnPqOuFLoDlmyIUs7+E5IN6iqg7FkAvQl0KSJbsch1glD68TZW3OyHI8Xu35Q9W/aypROxBBMI3B2iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?54Q1sjsOGEDW+eUHSE4ios7bJfOUGeiCXjlrLIyy6fjjntc44mWKyzQ0ZqiA?=
 =?us-ascii?Q?cm09fEOcpPf2Hf/M+njId75cSLlt7qrrN9eFJDvbwdFtl1vCqGO3opMPSoE1?=
 =?us-ascii?Q?O89718BHBPOTuOdaWOeIWi28CzKZNarN7eNEYWSrMCZB2cSan+btw6Gmpehy?=
 =?us-ascii?Q?fHgXygJtzDg2qkKO+IVN71h0kLuWoaT2fA86SJCZOs+jfhkzweUzSjMWMccw?=
 =?us-ascii?Q?dQ9xobFRT2InKuyjXbpNLk1S9d/rnaauTycuobcHndRL/Ti1N7tRz0q3RTvk?=
 =?us-ascii?Q?PpbKCgeP2N40N+C3ULB8Ll/sFQu6f+zzx5eQrc8bAeLufT5nJa+fQNhalWZJ?=
 =?us-ascii?Q?w31PApmXhLaRix2xN4b9G17ocZUBzlm5OefkrVYGD1g39pjEGpfBg84+h7II?=
 =?us-ascii?Q?yjmak/MSbl3s9ebHbyirnL3nakqhOKj/+1SfukDUUqOkIP+9hwSc2x6SgeuF?=
 =?us-ascii?Q?6p3F0Y1lXwj5/UW2owfEGgJgW8jpwXE6JqZTwg05SFysHyxvehMbKJDvzrRX?=
 =?us-ascii?Q?2I3sMw+wdGSRZ6pT10afeCI1Q2OmMAXspR6H3hhpL3c8njKV2mwXjx0cucQk?=
 =?us-ascii?Q?hA9Wi+qGryKqyG6N/DCUuyBfBM42+0AnyhYEwRPIbc6V6DW7MyNvN3BxhXVA?=
 =?us-ascii?Q?a/jFREnyVf8/TWNqxML7ChK24hHwXoDAY0z5m+/pTyNG6ISvzw68kU53ZEAk?=
 =?us-ascii?Q?dOmNoMC0pHHl+nrPZGFnEMxcMQv9V3NjqLnrjjQtlpqB4YUqj10GmFMLFZnb?=
 =?us-ascii?Q?KAsKQB1ZcbBCjuYNjZVTsWS3mGGIbSeEKJE2rZaTb3AqUO88ZxJV4D4EosKS?=
 =?us-ascii?Q?PZP7fwzcgTU/S8Vaqg/uZfbQ/XdUatT0WrzNMxAZcS/IL2cCZRZVjAW5oEyr?=
 =?us-ascii?Q?vhrZQJSPvNZMZiSkjQT5BobWACQum6CyjuL486a90hU+Dhv9vEW9oINhlRqg?=
 =?us-ascii?Q?HUD4EZSHIfu+babQyaIr/sH4zEzzFFgte+o8CDL9CySFTrorQQ2kpvggxm1D?=
 =?us-ascii?Q?ShRSVSKQ4hbnFPmFyOrm2CX9BFlsj7WNCung/0TSPh78fvAa27qBjOv3bU5t?=
 =?us-ascii?Q?QbhgYRR5PcWmgzK18C1HCrMiDAS1sN1uPVkxx7ILcyBPiaqksL2sLGg4z7/J?=
 =?us-ascii?Q?MPc/8DghOG7m8MhNULYfPOoYRfGXgnFVEkNe5YEiQJqfvd5w1aNrhqyxQ9hT?=
 =?us-ascii?Q?lphsDFM5vssmQmNDpBHBC1JC9oHpHCZIfKa/Ks47CRSA9ubHOUX96psDayWB?=
 =?us-ascii?Q?ZnDKlkf3Hgg837dD/SVVInNDLclomTlcPJryQt3uZAfvrZvG9CspCT4yMPs5?=
 =?us-ascii?Q?SdvNW+vkY4nntLfdGUyH3gd4MIVbb6VOmNjC3Dy73cTe5ivI1mvArlZWfAwS?=
 =?us-ascii?Q?RzGzXTvHHOU/CFNUh9aoSbETJrfqmdox1q67UlYXLh8jreKiLy6xLJMMiA/4?=
 =?us-ascii?Q?EGRvZMdFdRFLxNvDOeOxwZrg6EtqDpWACXDKiI/atqrCKyUMbBkOMpKlW+9K?=
 =?us-ascii?Q?jmlE1GuLZqmT74ylimnTAZPKbbuPZSUFlw/unFnV60XlkZ/woIV/4rjoiaVQ?=
 =?us-ascii?Q?OYN13aBqP2XoTYMROIXEki1D9kT0WV/LyklVvJNCJwaeWQ35bh7ZVlXXqtY/?=
 =?us-ascii?Q?6gp+K8eB2brlCAFRE/8haMmTcpdzhEYxlVUe35Geww4rPQiukLkH3LCDvfZx?=
 =?us-ascii?Q?egZtvToyAZZIlWoCNSya7MqrLVE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b5ca24-c60b-453b-e639-08d9fe4f5b66
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:25:04.0083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b2ajNBqQOtKlvPwd2uqmQw1G3DaUN//jltaaYGWc11Mk6VCufeMj+V54eNZEYTjE7yOYrPOPKvQTN/exjmONGJ4FQ/pXoZg/7anB1wuPXpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: 0V6nM7LzEIpG6PvTuCKiPPeVf5llldfV
X-Proofpoint-GUID: 0V6nM7LzEIpG6PvTuCKiPPeVf5llldfV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050007
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
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 10 ++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 51 +++++++++++++++----
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 6f0f13b4fb1a..0f9c88dd1a4a 100644
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
@@ -425,7 +425,9 @@ struct axidma_bd {
  * @csum_offload_on_tx_path:	Stores the checksum selection on TX side.
  * @csum_offload_on_rx_path:	Stores the checksum selection on RX side.
  * @coalesce_count_rx:	Store the irq coalesce on RX side.
+ * @coalesce_usec_rx:	IRQ coalesce delay for RX
  * @coalesce_count_tx:	Store the irq coalesce on TX side.
+ * @coalesce_usec_tx:	IRQ coalesce delay for TX
  */
 struct axienet_local {
 	struct net_device *ndev;
@@ -482,7 +484,9 @@ struct axienet_local {
 	int csum_offload_on_rx_path;
 
 	u32 coalesce_count_rx;
+	u32 coalesce_usec_rx;
 	u32 coalesce_count_tx;
+	u32 coalesce_usec_tx;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 860ff0447f71..a51a8228e1b7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -33,7 +33,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/skbuff.h>
-#include <linux/spinlock.h>
+#include <linux/math64.h>
 #include <linux/phy.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
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
+	result = DIV64_U64_ROUND_CLOSEST((u64)coalesce_usec * clk_rate,
+					 (u64)125000000);
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
 
@@ -1488,14 +1512,12 @@ axienet_ethtools_get_coalesce(struct net_device *ndev,
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
 
@@ -1528,8 +1550,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
 
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
@@ -1560,7 +1586,8 @@ static int axienet_ethtools_nway_reset(struct net_device *dev)
 }
 
 static const struct ethtool_ops axienet_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USECS,
 	.get_drvinfo    = axienet_ethtools_get_drvinfo,
 	.get_regs_len   = axienet_ethtools_get_regs_len,
 	.get_regs       = axienet_ethtools_get_regs,
@@ -2047,7 +2074,9 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
+	lp->coalesce_usec_rx = XAXIDMA_DFT_RX_USEC;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
+	lp->coalesce_usec_tx = XAXIDMA_DFT_TX_USEC;
 
 	/* Reset core now that clocks are enabled, prior to accessing MDIO */
 	ret = __axienet_device_reset(lp);
-- 
2.31.1

