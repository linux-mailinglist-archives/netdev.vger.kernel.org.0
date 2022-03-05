Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72E4CE23E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiCEC0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiCEC0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:18 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BBF22C8B0
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:21 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22526BSA005431;
        Fri, 4 Mar 2022 21:25:03 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:25:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q300Oa98cheG1TWoAg/XyYzKmKfHr6AujYZSaOu7Vbkgl0aPlhM1F2paOfR2l//59qNJR6lEWxSA5MlMrTlrd2nYGEltBOZAQzD29tLda/Wo9cXF/uvFs9r77O4s37wrqBaNEJi8TaxBVgYNVqXY66/Svt4j3tBc7gq0jSVdzdJvOnPi4Ck7AsZtbQHaNJiiSB4AzoAXnHcZXK8L2T3np2XpVKCqr9jNy43TyBAFZ/1UKauoNmPMHIiNMKDgOa7zJruPtsBYVvTDeNVTUjKiqybTDLm2OxkJfbqPNte3CrWjdWhRPI5OyOp+SJV7dnp9hUCY89YWjiDAamLmQqi7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+/J6oXucIYsa77msWCUrXUpK9dfYgzBUL/xyTBcXik=;
 b=Yo+MR4PAdJg7rriXCQc56gnyfKbUZn+GuYiYwsALPwQyngALb/XF0FfCAbo/LbbS+KZGp6NQviSL1qUqGzGI9DaDIt6tBfpXHxv8GK9cxi8hKf1Gvet3Um8NZac4IR1nbz2DXr3bblz/gqv4DGlLqNi/wKsdh1qQVenIXx0o8KjyKkctBGF5qTeIANpBTJ7A7hRnH/Kn4Uvo+FnoPDRmBgDYbVWxD5HMdtZWd5tdQUWlPxNJwcbhXAmm2FUYmgeypIntXWwyZ8qC4RSSDGR8AZP+Pskvx5DWnH1rrbZnYnqLQG1bhTTImnLCHTVSCIUFTQZf6Sp6iEY6CJhJk2Uevw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+/J6oXucIYsa77msWCUrXUpK9dfYgzBUL/xyTBcXik=;
 b=nRKtdMJVOevXCOcq2WEWyIk0kI7ra12S+BdihDeQrE0+U7ymATcQ+Xf65o+prM+Hu6RsnE7yZdkwztZX6+35z0tHEsNU0tWY1zTsr7yrkkYwrSyRuATspyxl1/WwpXMxaQinjIQYgYYwFHtSuoxoZDkPYtWD1H5FdjdIxfKufl4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:25:01 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:25:01 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 5/7] net: axienet: implement NAPI and GRO receive
Date:   Fri,  4 Mar 2022 20:24:41 -0600
Message-Id: <20220305022443.2708763-6-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: a9b7a242-50c2-440a-04bc-08d9fe4f59d4
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184CDBD5F45064B298E8E1FEC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwWJExK296sc/oPY6IhXukbAmFCHihQZ9YuzC2arATXF4yYh+oIofSGlU28cw3q3JpKgpH9zIoNOxZX1Up3NO6mN7id4wdIl6fkdoyeVp8hlV6jg/VwQ/b1wqdc+A3HRj+Y+65SbgA5Q76WCIbjt3BI/GP9vF5Q5GMohXHLAafnFrQm4Xnlj/78eMxtk/rhJvbHBlB9EV21vUWiAXmo7pRxSbD5JUQRFCQsvfVVWDOEKpXu8UX+BCrJmdXqJyeEquHpYbSzWDcvmzuDMX4UY9UK6/NIXR2s7ysHAUHVq5o05o5KVCeKVVvOkke7D1df2o1bE+ilXlHwwL8FZQzkzG2b97R2NEvhu34nIxMh0P+tQJMGHUfsOOeODVfAr6xv6a5+vsO3rXr5UDV0DRtJfTb63P+zn+3IPiAr94LGXdz6KuGR2GoonTjeGQV5hSlZrlOkz+Cx417JwyxYKGcHQ7QUwD+lRQ3enuHd2IsdwgoxWqDdCskQu8Sq8tfPSgtwhu9T0tCqLXywXzbV4DKuzKxNuGUje0aAPpNmiWETGiamDJkVCuIrATS/CEdnEjyz1AKuMFUpPHSRnyGBkj/DsQJyQyoI+J/z05C/AmNWdoDJ8BVVTLC9UPex+28nhFvMRPuWIdPbauUwF/i++6hEClxW39FskGhzIV8k19VrBrXujs3qA5k/Qc/wFSjrQQ2b0P1ACDhPoXN987OcWvEnpGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?msmLkhZaHow2t8n7SblX44PnILBgPy9BssDosF6eiL/N5fIdX09VE+Ym+G4p?=
 =?us-ascii?Q?lBqXnq35Et8pWW0V576Hb0Q3nr90ObJ17dEocNjuFkwZ3IO+tLAHeDumamk9?=
 =?us-ascii?Q?BWxZblp/JBSsk+cW3RZuWVeW/mJuyXQrky34RiVrgM8CmRRA0+awzTiafmSZ?=
 =?us-ascii?Q?IBM1zPwEohRBDNi2rgQEOKTklFRI65fEbCOWa75/251DYdsSNe3SJ38szAB1?=
 =?us-ascii?Q?FdFQ57DCN5OP60jNnYK1QdimOrUk2JZb5rlu2EFgSLMsb0uEVO2Qc/dgbIhm?=
 =?us-ascii?Q?E3+yISjwY5aU027w5EQzR+dcZqLLg1egCRXp1bXLy30FLUI5xuqn4jldW4iH?=
 =?us-ascii?Q?eqo0goc6ujp/FcFVCNfSxnrnxZi9ZNu9SYV7HwslWBlXwctN2C+eo7bfuOIs?=
 =?us-ascii?Q?7g6AoZH+UPju7KWWedhlDn6kB4FofpVwJikLbto5UF0IngX/EIfgc7siRiV1?=
 =?us-ascii?Q?m8yTDHctss4XS7XkUH9guDqlOQ8TeykV++8qqa5izHJiYW58yiqxKvmOI1kA?=
 =?us-ascii?Q?8kInmFawiJQsJkv2H67MH3LdVwJezG+veo72+m7AMCKopklRdmfuTDrIVB7E?=
 =?us-ascii?Q?76iT5hx0Jkm7iLbOoumevICUnLQcO1eaUNSa2LioP23SGKf+bVNi0awnce7w?=
 =?us-ascii?Q?WQlcvgnxSvLm5EyUrmCp+TxffjKWXBybCH/igMB3xNdBCqPwIKA+Fvq1QstB?=
 =?us-ascii?Q?ISNTqkmgxq2GMo7ytKRKdtXzywQml9ue8uuSEDPBTpjy8jH9RIUQRs88M4v1?=
 =?us-ascii?Q?ajl4u1p3KcDrut7Viui687ClZRI4IlWYo0OcXspq9o3HIYjwlL3LO8DZjYcQ?=
 =?us-ascii?Q?u3e5lSlq7NIXQCMlHER5nlhxJ0cPPUroccozeN26yw6WEFNOqM9lRCRbVIte?=
 =?us-ascii?Q?Oe2km0ScbL3kM5vK5+y/w0ycqEyIKQKhHFMd6a6r5KY2xkua6YtGE7wUgJ5z?=
 =?us-ascii?Q?wtTDw0zgyi1s8RgEGvev8jQm3jGeXJohCrXhRmE81Lf2y+7QWidGGBY5xqEK?=
 =?us-ascii?Q?qjPgOnIMaW5gZvLLdix1SuhsxguH1ZHSE+mEN9aLToDKoj3TZIxIpDgQOWTH?=
 =?us-ascii?Q?ib37su+VMPrvXZJUowxLDK8jhpSuo8ezg91W/4F8oyEgohbYKMjWe3FeFmg3?=
 =?us-ascii?Q?EGI3TIoyDcNmFluDF4KG0/RTsUFt/DZccD8U2RRyESQq4NizQA1OHibsnHUY?=
 =?us-ascii?Q?zHRiombQ64NdV5nhpYNhX/royosw+vjsgyPAr4LXtfWdFpaIk26Wx0bWzqjy?=
 =?us-ascii?Q?w3V3b560hh7M8OewMUGmvCAhd4M3CjQb9kRgL7lV6EvpRoZZVIpCLV4FSEJT?=
 =?us-ascii?Q?Rre/WDZyCmwU9qgJE+WnIPW6pyWcSqnb9Yi2sjXkU4IvMA9IfT/ppTn8VIGu?=
 =?us-ascii?Q?Lm4Fo8IdbA3b67kxbTvcCQn2MQeDY+BoWOXP8xwiLeaSZu6jfc/IW9aZeOoS?=
 =?us-ascii?Q?/b5Zu8cGkS1Jm6P+dtJfPJ+yiChn0IXv75CuzGKV5BKPPRXivlgFtF9bbFA4?=
 =?us-ascii?Q?GejH0sEDCAO+b8U9j9iYjDH2HA7jUcvLNYYBRcIBC2g5GVrldVUewi+KOhN6?=
 =?us-ascii?Q?mMJJNnZKeVZXnB8SrwJyV8fnuEPgjBwgPTkyxlwXQLbx6o5Nx3dt/GEZpk75?=
 =?us-ascii?Q?OnRmSToeu8Cz1nBLwE6E8YNTQHyhGtqZciR3y+ZMDdTtibcwRlGMsHNXTs0n?=
 =?us-ascii?Q?YMdkflxqq7dlLM9/nkagjoU+fo0=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b7a242-50c2-440a-04bc-08d9fe4f59d4
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:25:01.3980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJBhhHziGOhfwbsd/0RjkiqXQPTd4W8+Q25bxk/7KI4r3x05K8XmU2qNuvgvZxU7DW8Kn5WESJMa3RT1iz28z5PNkzA61LgCM0VOmq93I70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: V8Nb_v788XeJ2SIOSFL_ATuTResCF2Q1
X-Proofpoint-GUID: V8Nb_v788XeJ2SIOSFL_ATuTResCF2Q1
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

