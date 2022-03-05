Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FEA4CE179
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiCEAZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiCEAZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:05 -0500
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C129972F9
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:15 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224MFFFi026604;
        Fri, 4 Mar 2022 19:23:48 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hw0y01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0BX/9b5qX1sbHOTGyuwEf6P5SPuau4cZ53e3UTT4soL9/NiAtYQHS1BJ9aN75hG407zgee8T/YVBEtwio+mVUjnsiQGkx3ZnTlKSFwdLapUn6U+eGJqXrcbkENHKJjWui+gO6X46+Rrp+ZTFtVRFBH2aYd22gDt3cYYoIXi932IG/ivFfgL8p4RkNTfuvo61r3hyeNv0/dCbPLFDiOtxey+DuNSTEP9SmCKmwAFmn+zdXVtDWH6oEQuWE1sbfmTr7UiUD4EH4m6DQKtUAZixmtLDBgGZ0mywSHYY7k/FysxFw1uWCIGobjYUyWBq9cD1PF3KrbUHH2x2bVEc8HjxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+/J6oXucIYsa77msWCUrXUpK9dfYgzBUL/xyTBcXik=;
 b=m0mpdYuKdytYXa7k3W+Bj6/8vT9EyHP5v0jPf4hBCOZV5hY/u5lmyLE7vSoSp6//454hoHwCCaIv20YnLP0uubEUkO9TrdB9NKE628UOy5cY6IaI7b62Zj65km4xXFRjZa5VuUifU9mkjTGpczjelUss+50Pi4Uf0HlDgGWwzPIreX2gQpkG1PrB+xbPnraQVPg39Xa65+drAl4Rzkve86ZRTSXiUCEuUCAXdQMXiHDb+1UbXHNrzERNsEexfnThMA3QoY/uk4iRAkhFvzZssTIZ/jeA8U4xbm981iuZVFlW5FhIdK8U8Sd8mJ3c4reYMYZR9rAfT1jrWVip1s4f7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+/J6oXucIYsa77msWCUrXUpK9dfYgzBUL/xyTBcXik=;
 b=RaGZip3Oo4gGVjDnVU+8Wii1d9ZCA4Yyv6cGKN9D9hdUWeVJUlmcFcnoQL6KsiTbBLzaFKi6TdMh9Ld0fmrLlvAHySM875g7cfUz+/g/buUYI3D/O4NfC/7U/7btQ73Lr8QyHpi5oMaipifZiO+brXkCGtPUUmSfmKCB9l9aInY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sat, 5 Mar
 2022 00:23:46 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 5/7] net: axienet: implement NAPI and GRO receive
Date:   Fri,  4 Mar 2022 18:23:03 -0600
Message-Id: <20220305002305.1710462-6-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305002305.1710462-1-robert.hancock@calian.com>
References: <20220305002305.1710462-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0011.namprd14.prod.outlook.com
 (2603:10b6:301:4b::21) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84017324-8ba6-4336-cb3c-08d9fe3e693e
X-MS-TrafficTypeDiagnostic: YQXPR01MB3701:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB37015907879576636BEEFF2FEC069@YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cv/UaP1/qedc8FVXjjrWvmePHJPt7GEcXpe6fmIbGifbA0cIGMLwKFBSo3DbeHMKlL7T96WaKzh4/40LvFGNfUEFVL6aApuu0dMYLyfFIMH96XYmCNFPvJlKvYmKGD+KWZ3xWL4WLry8eRg7heQMTzeliOwqldAvr0BcqrOolYOyW/4RBTA1hh/88HeDZpQ9TDjeZ63PjTQpJQtjknuGtp+ply0hD8cPLuq9TTsYSjAq3gj9T8ATEP3hQOvpIpK3TS9gICX/4pMIXhs7btsOGujbuuTOzzdpQ7ZQfwwQ84i20sgFxu2k9earObm8m97Xb8EtzlcgpONZoF/r+A6RCjt4b0jfLIVHSyfj/fm3akZz2RJ68PkuI+m3uUrtNuXJGyYgIdU+AyyAKPw8JxIm+5ipaRnPoGyTzOzvAjW53pVpVUQApudWCdrocNDbtp6VKJx166nBJwTcY06irEv2rsCgMEoZv+qeAfP6OIiZZGjJjHf73Ljai/Fn5qHrTDQd9RuK+nrTAXp+DrGZ/Mz3kmLRzL8l6jCSUgrUIZgIFm1LJm59zw4FeAZI0cTVcudtr7MSmgdDMqurTx0ks8QB+igzGvy8pSgqVXdVONriTTeor7FqL2ydxPn+p6kBX2b8Sx/HbBP8L8hsR0Fmt6muuO73gvbkMKRIXt7GXwnG0DhgozWOYu9uyoU6PNDa3hcRMvqQlGa6AQjSTuS0ckcWhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2616005)(6512007)(5660300002)(52116002)(44832011)(6506007)(6916009)(2906002)(83380400001)(186003)(26005)(107886003)(8936002)(36756003)(1076003)(316002)(6666004)(38350700002)(38100700002)(66946007)(66556008)(508600001)(8676002)(66476007)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8E6KPs3FIA/fjA76x8wUj+JSbejPtaG+8uDEzkjdkfjtlGqGvL3oKU45s5Kl?=
 =?us-ascii?Q?9acc4GpJMiJsybdgRvYXq5hMgqpSJNKGyqnSIKwnONYYKGIsPHqk+IdQqerB?=
 =?us-ascii?Q?LNX+ZjWO6XcXdrCmuQpP4eDetfhBimaIqVDvcsfq9o2y2con8Uu/dPE+OodJ?=
 =?us-ascii?Q?lvOl8bfJO0iarwe6NXRPP7vfAI1Q+BbVS23x0XWRvLNHeTDdXyEO5KeJKDDI?=
 =?us-ascii?Q?4tH1hg0ex7mEQSZu/dNBsb1A9Ps30xSSFmB0c618K/onUflNPEi4iqVVBl5y?=
 =?us-ascii?Q?U0PThLHGUMMPguuwI17qtxZyIv6mqrqavxyQEyaz8DaiT9LcFInxOh/F/ane?=
 =?us-ascii?Q?+pIzCxlt/C48yoq51InVdEYWJOshl39rf/bMOEsI4Kn68v65xK8MlqmYduJY?=
 =?us-ascii?Q?nwj9oh2sr2gOlZ0+q3mKTUp93gfr6Uqy8dDeGxVwUexerJzR2uoC0sGGFOMk?=
 =?us-ascii?Q?dV8LAy2qr8VVQzkFuwW6ILK2XGGHJEietOFiaKR7CxS4rEShkkZkDq7JssJ4?=
 =?us-ascii?Q?8LpiEObiPbIwSqItmOCQYw0LwlDr3GlKJXD2EXk4nVGJ+C86kyZSWj+8tqIi?=
 =?us-ascii?Q?zOPy/vPwAwQdkL/4LTkHLVt6Qr/E2ThPHB86Nv8fuKkXdesB9Ty4aDYAxcDq?=
 =?us-ascii?Q?o/m+UOAlh+/MMN6AwxKEZX4/2A3EPxMZFvvoISiJC0/kI/UNLJYMb8FxvNt8?=
 =?us-ascii?Q?GX65z9UkuhwiJbnBLKlGxFrsmvafvA2vKOCrISl5yHjKO/zy8YxsZuDtzyWJ?=
 =?us-ascii?Q?4RqPvcPN360p/tLfNq6nIoNfJ7bBOF+6XLi9TnbuCxYxjyX6+8XQhI54y27X?=
 =?us-ascii?Q?WuUD2+I7+5wJ40pNSN3AKQ46ZSUKPGt2FNoAe/+2M9OfxZQCluQMgN7UCz2h?=
 =?us-ascii?Q?ci/LMrWFb/C9ubYHOih5N6lHxxLk3qgRDGvyLqtgscFpZjo+B8xPbD7OHlJl?=
 =?us-ascii?Q?PxIR8uZF7PfNzjnOh5Si9ysmgqtYhUXcmKZWheUrZq3HuIra9J75ZOws/oF5?=
 =?us-ascii?Q?puVqN+wAVkKuf+089UPAFHY+nEMY5RCOHrdh7KWDg/biaIN5RUuKwqN58N2v?=
 =?us-ascii?Q?duZx3d67CBJ8xbwGt+50MFsZbt7AiJtr1x+X9BB4IvBVj4n1Hj8UNeIVYjCG?=
 =?us-ascii?Q?jgdgYVCwYRSTkZBLiF+VMKFE1dzRE96W5wjrE1rR4Rm2h6VuhnQE0aCJO+p2?=
 =?us-ascii?Q?ZRele1XL1hmmfcOMsCaiiD3jxb5xR6pfDWFDuV+b9qeMnPysCu+9G23jvlay?=
 =?us-ascii?Q?4vENbPjvz/cfkfP6hR6etQ6QuWjFr8079ML9zYiPOweWn8sEJFBWLPxVM4Vp?=
 =?us-ascii?Q?iO4ucpBK0CkddtlBCGj4riEhDQwlqhyh7lCe05kTM+zCtNVmF0/wKzMrtHEe?=
 =?us-ascii?Q?vBPVOXnVOaGIi2nGJSnq8/0QOc+6DsLZdjkIizkFJjOmb0c3Uy52iqJKJDs1?=
 =?us-ascii?Q?QCMknefxrR8+fcEuYgWQ0qYUU7f9uCnTg2l9JnHKxaQvRHroLz9J6GxGqyBN?=
 =?us-ascii?Q?Ox0ytM9Vhp4T945NJtVorjnhl64NLWNVV4g64KBqmnr8l6CxTCsR+Oz5lnDj?=
 =?us-ascii?Q?eqXk+8i9byEjDhkVbWp3gCXE2aLJLcDx0YEdEcWHLjVpbZByimQ1poepMg6A?=
 =?us-ascii?Q?D/toBSyreSOg99ZyI4zkrXaOyj8sL/P7Q8Yvv85NUcUTVdYvAL1El5qFWCin?=
 =?us-ascii?Q?mmbT1Dx5IM1Re1bAhoiBEz+iYHE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84017324-8ba6-4336-cb3c-08d9fe3e693e
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:46.3207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2EZrY4woEChR/aWtn/9Ij1QD9AMFj9MIm6cy7MIulAVwJs5Z+zSuPkvcEoYM3uE4QBdaZmYw1SN0yVxxKob/xqHPuiDlODHSTWFN0oZhbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3701
X-Proofpoint-GUID: 0HAQZu69JuhfUsg3ryaKJ8IMNv4L5nh4
X-Proofpoint-ORIG-GUID: 0HAQZu69JuhfUsg3ryaKJ8IMNv4L5nh4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040121
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
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 81 ++++++++++++-------
 2 files changed, 59 insertions(+), 28 deletions(-)

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
index b374800279e7..860ff0447f71 100644
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
 
@@ -875,28 +875,26 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 }
 
 /**
- * axienet_recv - Is called from Axi DMA Rx Isr to complete the received
- *		  BD processing.
- * @ndev:	Pointer to net_device structure.
+ * axienet_poll - Triggered by RX ISR to complete the received BD processing.
+ * @napi:	Pointer to NAPI structure.
+ * @budget:	Max number of packets to process.
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
@@ -918,7 +916,7 @@ static void axienet_recv(struct net_device *ndev)
 					 DMA_FROM_DEVICE);
 
 			skb_put(skb, length);
-			skb->protocol = eth_type_trans(skb, ndev);
+			skb->protocol = eth_type_trans(skb, lp->ndev);
 			/*skb_checksum_none_assert(skb);*/
 			skb->ip_summed = CHECKSUM_NONE;
 
@@ -937,13 +935,13 @@ static void axienet_recv(struct net_device *ndev)
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
 
@@ -952,7 +950,7 @@ static void axienet_recv(struct net_device *ndev)
 				      DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(lp->dev, phys))) {
 			if (net_ratelimit())
-				netdev_err(ndev, "RX DMA mapping error\n");
+				netdev_err(lp->ndev, "RX DMA mapping error\n");
 			dev_kfree_skb(new_skb);
 			break;
 		}
@@ -972,11 +970,20 @@ static void axienet_recv(struct net_device *ndev)
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
@@ -1022,7 +1029,7 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
  *
  * Return: IRQ_HANDLED if device generated a RX interrupt, IRQ_NONE otherwise.
  *
- * This is the Axi DMA Rx Isr. It invokes "axienet_recv" to complete the BD
+ * This is the Axi DMA Rx Isr. It invokes NAPI polling to complete the RX BD
  * processing.
  */
 static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
@@ -1045,7 +1052,15 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
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
@@ -1121,6 +1136,8 @@ static int axienet_open(struct net_device *ndev)
 	/* Enable worker thread for Axi DMA error handling */
 	INIT_WORK(&lp->dma_err_task, axienet_dma_err_handler);
 
+	napi_enable(&lp->napi);
+
 	/* Enable interrupts for Axi DMA Tx */
 	ret = request_irq(lp->tx_irq, axienet_tx_irq, IRQF_SHARED,
 			  ndev->name, ndev);
@@ -1146,6 +1163,7 @@ static int axienet_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&lp->napi);
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 	cancel_work_sync(&lp->dma_err_task);
@@ -1169,6 +1187,8 @@ static int axienet_stop(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
 
+	napi_disable(&lp->napi);
+
 	phylink_stop(lp->phylink);
 	phylink_disconnect_phy(lp->phylink);
 
@@ -1704,6 +1724,8 @@ static void axienet_dma_err_handler(struct work_struct *work)
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
 
+	napi_disable(&lp->napi);
+
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
@@ -1768,6 +1790,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	axienet_set_mac_address(ndev, NULL);
 	axienet_set_multicast_list(ndev);
 	axienet_setoptions(ndev, lp->options);
+	napi_enable(&lp->napi);
 }
 
 /**
@@ -1816,6 +1839,8 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
+	netif_napi_add(ndev, &lp->napi, axienet_poll, NAPI_POLL_WEIGHT);
+
 	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
 	if (!lp->axi_clk) {
 		/* For backward compatibility, if named AXI clock is not present,
-- 
2.31.1

