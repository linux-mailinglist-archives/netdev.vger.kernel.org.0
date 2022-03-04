Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA494CE05A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiCDWog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiCDWo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:28 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951505F4FD
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:39 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224MaIDg005553;
        Fri, 4 Mar 2022 17:43:04 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PS06314RhKtVCN5JZXUz/MssTk2L1nltXLI9jqagUttPtfxx49MPY0zT4BifY0CINGMIy8ohJ+zirMMOYSMGUQo/F8eyOcIpyPplYCLkSvJJfrX34Lvzh/bOF3SdeXUXW126lov3+8HoSeM6TFf9EdP5WDIs0ZOXBjGW2JXMlSha7kK10At1DBc/oZge0nHaWikOhuOVZYkNpIG6zzznXipaExK1li/qUeDCsV/tpfk98L+C+hJWl2Gvfg1PQOdoDTsj84nOL6T3pCEhAg5D5VN++KjJyW/8CaIVdeiAB8HrkgS9hAfaalePKqPLLqoXbBhoC+CsWfK1QbdF7DaiYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxpxjxCFXZlWDF24DkzLxeaNSzy9l3DlHkDk+1FV8Lk=;
 b=K3z1SQGpJmzEez2exGVjQrxC3YK9HtaXrjypcn1kLNWztxmI3u2MH7F32VErtU7xe0gOT05fsSciFdG6GWSTS1Q2Pi43UMsk4rvH2nBD2hStvjYA+lAUT/Tvrw3GJDhPtfKUH7711Ltdww7r0obREovUk8io3UaxPkHRpN6jbTEPpdL/EaWefnUldPOEvvuEeWMtmKuaUlnHhm8nKd4NjysuRMg2zhGX1u9VIFBlVZXxQBIxbzzg3lsnh7aoucKBfwVTNR9t5i6cQ+J+MVn89mLozRTE/Nd0BM/9MwctgwQdwILcPFKD+i4qxdFMUpfJQzmKd4tTKLWvuViL35F+Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxpxjxCFXZlWDF24DkzLxeaNSzy9l3DlHkDk+1FV8Lk=;
 b=U1ZESy5G++ggVq2NNUn9U0x1jlw52IwQcFLCHwt760n0LcAZQRhCKTBQ4+RhY6kUoi4ayKG1JESEaegCSm7POJfff2D/NPNsSdwRpVfGR/qI8/ZFCsEbvwpYvr62FcvnkEm456MDg+IrPlrLeepjBs0X/p9DySlzkS++VnmAEA0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:03 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 3/7] net: axienet: Clean up DMA start/stop and error handling
Date:   Fri,  4 Mar 2022 16:42:01 -0600
Message-Id: <20220304224205.3198029-4-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 494fbdc9-6b39-4605-e582-08d9fe305775
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB654083986D13D8B11476D52BEC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZO0dTRTSp1JXPOFNWUS0bSjormL2ot+t9P2UB6ZJMNfp7i2jkh7aKy/CmmtQnndv0CSEqijZwfGtCo0j9KEIJFHY9Dl060FLFl8Iiy9EbU3sn97Lmbp//dKHSz7isr8lHL+ZtJYHubZs/719JRmUGEhue2pKRUuwJTGo76iQwcovXH06gFAxtr2hdIAbuAFpvs37Y5xDRHxsM6ivWEkX36apfjoEKlwYg80fMDnmmOJ5ixTM75+Sz4AfzZ5mJTbsm4f4voLgDA8v2avcQANSUm4x7kNf1r+r+njoD+2ZGUkaX+1uNnYNEEe8wdjcD1MiMyLwFjle8fvq8xxY6DETsLP1ON0JotzE0wOU4RhW+y15FFS0tVUz9buJv3q9GQpEAvDlneZQBiil6ACY3MuHpPIMcay0saEk9m6y+2gSvQVOPEqIlC/tHqtBGk7A1DzJfWz/cahEKT+w/mgvVi1aunVaVu5FosHlWkuilQzPWZg0doXvrHph0AZHwKuQiI7jJ3QkBh83iTYjRsCAJXP3xoUAJSDDN/9HlMgwD5N8GP9MmPF8SWbQipxP4uFsu4iL++F/y26i00QXW3JjL/KRO+dQHnJOgRJpW2fxSFnnOamHdGMnf7aUy4lzPql+tYyzD2rHdp5gcxiGRtOe59WTZYb50lHDIf8NlDzFBIca2GbTtnBZynMCAu0/RJyUfCkwOUDku2+LWpnvKh1Bs/GAkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(30864003)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q6dFKKvmSfc2/XMkrbxbApSsWP4JZTRLEzxAq1rXyG5ZORBQ77UYqikEwJXa?=
 =?us-ascii?Q?Gt2zxuaetq86eQA25tmKfOVscrar9emZ7/WMfrcIbRS+30GbJOSJw0tUS93W?=
 =?us-ascii?Q?ZApgrtkkp4xsUwJu5foB9XRQQ3tpbNLAfsB2+WsRr1eM20X9SUv/0XHCZX6N?=
 =?us-ascii?Q?J1KizKQ9VdDabOR0E7UP+gZCEqjJiEJmL0Sr2PI2hsSA2Mb+bp8NM2OD5IIi?=
 =?us-ascii?Q?bHNwg/1XWC6gdbBIq8II6qnmdIRGtHHUlxoCnbkQwjRl4lfwbi85VKNAc8zr?=
 =?us-ascii?Q?41PX85ulJWMIAAug0s9Y6wT3+3ivTKhBOz1EOJTflMWOBlRoqXN8qA8fS7QY?=
 =?us-ascii?Q?Iovm5/8n7TBQJ+4WhtH7ZnoRbZo0rdjNmI4sJ9gQ1I8c5Bbb8ZPK2WuE5f/B?=
 =?us-ascii?Q?PYLXHo6+f0s+qqMcCxfOeb0/DR3VrlezXbblrrSGISa93HnUJNKxmd7vL1H3?=
 =?us-ascii?Q?I0t5KR3YKp8Dtf9915jkHoXTWjPqBF4lzm/gDbPeIRER6yQunf850nHQtlLJ?=
 =?us-ascii?Q?BR3PAhqSF3KKvMfLVbbilM89ssErJd2t7Ij5chELtHyTVE+MQ8TY+jktevPu?=
 =?us-ascii?Q?/Df6ojhBHeLLJNUvzepJ8bxEI1w4n5Ge4UsnK/83WdxMXQ4hS5WL9NcR4OdR?=
 =?us-ascii?Q?cg5+uURu66U0DZPRgh/7xQFT7yilZJMZXc6DocD7HdIoKzj+gJ/Go97HWWMj?=
 =?us-ascii?Q?kmFzlSYOVF87vFRRkXsfnls7Jy2QGfiZvktKNa9erJaiOty+FBbq+jTkss/+?=
 =?us-ascii?Q?IvDDjJn8mGjiFS5oERdcExJdG/r9ojTRELxCWJwQh+n65c47W/eiz65CIrru?=
 =?us-ascii?Q?bhj6GSwWPPR1p1ZhjJFmXBnqOiAH1Pt0FCw64AQ3xW2i+WWso6+Bue9faCzM?=
 =?us-ascii?Q?lv4wn+hHRFQSwFuAYHvuIo6qIjxP5zSVWyt84OSOrTsHNr0OXnVmxstKNOSt?=
 =?us-ascii?Q?MF/7lAE+l0Y0Pv23la68Uj1islPVF6FfdDPNnFOmHZPyQuv2FwxEhTZOUEVX?=
 =?us-ascii?Q?udjXrriQFXPNo0jpft1Fq0kxeoYCMblTVv9gwCcXPRIAt1iloafRUniJPm24?=
 =?us-ascii?Q?8Qostrv7F8AE+F76YKQNoANChfQAnVlNPx8TWlKKTZm8L2Pp25Wlvd4Mk4zG?=
 =?us-ascii?Q?hXG+XU7GL6EHcxwFcirjG+qKK/FBoQeCzi5HjfJVI0PpfwutlQEVIkwKmqGD?=
 =?us-ascii?Q?tAHObtfE213op5rj1abklXSvLIa38xXxVUzL1pnhcK13oqHNLFq2jqWnHVg3?=
 =?us-ascii?Q?pQ4wlrKNB2oUMRxG1iCrdLjHh8d+97CkztOsvF8cUzwimwNHkq+zA8xRkVf5?=
 =?us-ascii?Q?q8PBPejG2FaTGfVrI235EzLGo5oSSVXDML7SD4t1jrGzwcrwGDwd3e6GuZtG?=
 =?us-ascii?Q?l5QIJieMuZQmkWvXwYR1TblyNBs2M90C+FsSXXiqydv98w3NDxfi6KI9e5gJ?=
 =?us-ascii?Q?u0MQAONBWK2IHTIerZcqaiuqmrX8xaoelNIOKsHXHuW3tywqz+Mdt8Qr6HcI?=
 =?us-ascii?Q?sMa+EoP39P+vljDf1HO3oUiqe+1MUBYYvlXRkMkSw59wcxsLiQQdsdpKiNNo?=
 =?us-ascii?Q?K6JU4NxHYGLO4Ec8OFC0H2SefcxETUvXYJ3ccJvFsg2TIAMa77pR03L3HqmN?=
 =?us-ascii?Q?nwqATrNaWLURdH54jBzp1VH4wsLZrM5RaNOzXQYItyucIecvCJwSGtDdmk7r?=
 =?us-ascii?Q?z8arej6aXJJ7j6GXfWYq7SnI3D8=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494fbdc9-6b39-4605-e582-08d9fe305775
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:03.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiSey+1KcWXfrnJoqsUaUEHjTjHloR14zvT9MvvhEXvapUC5XN9a2YM+Q26g7hYXvCJdHztHaOuamLSSg504X5XwuXbqevKt91hU597aa14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: VNPetA354P-06rbmM5C7b8Lr0BnGtSX0
X-Proofpoint-GUID: VNPetA354P-06rbmM5C7b8Lr0BnGtSX0
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

Simplify the DMA error handling process, and remove some duplicated code
between the DMA error handling and the stop function.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 280 +++++++-----------
 1 file changed, 105 insertions(+), 175 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5a1ffdf9d8f7..d705b62c3958 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -226,6 +226,44 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			  lp->rx_bd_p);
 }
 
+/**
+ * axienet_dma_start - Set up DMA registers and start DMA operation
+ * @lp:		Pointer to the axienet_local structure
+ */
+static void axienet_dma_start(struct axienet_local *lp)
+{
+	u32 rx_cr, tx_cr;
+
+	/* Start updating the Rx channel control register */
+	rx_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
+		(XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		XAXIDMA_IRQ_ALL_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+
+	/* Start updating the Tx channel control register */
+	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
+		(XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		XAXIDMA_IRQ_ALL_MASK;
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
+
+	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
+	 * halted state. This will make the Rx side ready for reception.
+	 */
+	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
+	rx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
+	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
+			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
+
+	/* Write to the RS (Run-stop) bit in the Tx channel control register.
+	 * Tx channel is now ready to run. But only after we write to the
+	 * tail pointer register that the Tx channel will start transmitting.
+	 */
+	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
+	tx_cr |= XAXIDMA_CR_RUNSTOP_MASK;
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
+}
+
 /**
  * axienet_dma_bd_init - Setup buffer descriptor rings for Axi DMA
  * @ndev:	Pointer to the net_device structure
@@ -238,7 +276,6 @@ static void axienet_dma_bd_release(struct net_device *ndev)
  */
 static int axienet_dma_bd_init(struct net_device *ndev)
 {
-	u32 cr;
 	int i;
 	struct sk_buff *skb;
 	struct axienet_local *lp = netdev_priv(ndev);
@@ -296,50 +333,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
 
-	/* Start updating the Rx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = ((cr & ~XAXIDMA_COALESCE_MASK) |
-	      ((lp->coalesce_count_rx) << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = ((cr & ~XAXIDMA_DELAY_MASK) |
-	      (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Write to the Rx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	/* Start updating the Tx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = (((cr & ~XAXIDMA_COALESCE_MASK)) |
-	      ((lp->coalesce_count_tx) << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = (((cr & ~XAXIDMA_DELAY_MASK)) |
-	      (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Write to the Tx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-	 * halted state. This will make the Rx side ready for reception.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
-
-	/* Write to the RS (Run-stop) bit in the Tx channel control register.
-	 * Tx channel is now ready to run. But only after we write to the
-	 * tail pointer register that the Tx channel will start transmitting.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
+	axienet_dma_start(lp);
 
 	return 0;
 out:
@@ -530,6 +524,44 @@ static int __axienet_device_reset(struct axienet_local *lp)
 	return 0;
 }
 
+/**
+ * axienet_dma_stop - Stop DMA operation
+ * @lp:		Pointer to the axienet_local structure
+ */
+static void axienet_dma_stop(struct axienet_local *lp)
+{
+	int count;
+	u32 cr, sr;
+
+	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
+	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
+	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+	synchronize_irq(lp->rx_irq);
+
+	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
+	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
+	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+	synchronize_irq(lp->tx_irq);
+
+	/* Give DMAs a chance to halt gracefully */
+	sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
+		msleep(20);
+		sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
+	}
+
+	sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
+		msleep(20);
+		sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
+	}
+
+	/* Do a reset to ensure DMA is really stopped */
+	axienet_lock_mii(lp);
+	__axienet_device_reset(lp);
+	axienet_unlock_mii(lp);
+}
+
 /**
  * axienet_device_reset - Reset and initialize the Axi Ethernet hardware.
  * @ndev:	Pointer to the net_device structure
@@ -949,41 +981,27 @@ static void axienet_recv(struct net_device *ndev)
  */
 static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 {
-	u32 cr;
 	unsigned int status;
 	struct net_device *ndev = _ndev;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	status = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	if (status & (XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK)) {
-		axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
-		axienet_start_xmit_done(lp->ndev);
-		goto out;
-	}
+
 	if (!(status & XAXIDMA_IRQ_ALL_MASK))
 		return IRQ_NONE;
-	if (status & XAXIDMA_IRQ_ERROR_MASK) {
-		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
-			(lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
-			(lp->tx_bd_v[lp->tx_bd_ci]).phys);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* Write to the Tx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* Write to the Rx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
+	axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
+
+	if (unlikely(status & XAXIDMA_IRQ_ERROR_MASK)) {
+		netdev_err(ndev, "DMA Tx error 0x%x\n", status);
+		netdev_err(ndev, "Current BD is at: 0x%x%08x\n",
+			   (lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
+			   (lp->tx_bd_v[lp->tx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
-		axienet_dma_out32(lp, XAXIDMA_TX_SR_OFFSET, status);
+	} else {
+		axienet_start_xmit_done(lp->ndev);
 	}
-out:
+
 	return IRQ_HANDLED;
 }
 
@@ -999,41 +1017,27 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
  */
 static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 {
-	u32 cr;
 	unsigned int status;
 	struct net_device *ndev = _ndev;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	status = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	if (status & (XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK)) {
-		axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
-		axienet_recv(lp->ndev);
-		goto out;
-	}
+
 	if (!(status & XAXIDMA_IRQ_ALL_MASK))
 		return IRQ_NONE;
-	if (status & XAXIDMA_IRQ_ERROR_MASK) {
-		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
-			(lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
-			(lp->rx_bd_v[lp->rx_bd_ci]).phys);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* Finally write to the Tx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-		/* Disable coalesce, delay timer and error interrupts */
-		cr &= (~XAXIDMA_IRQ_ALL_MASK);
-		/* write to the Rx channel control register */
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
 
+	axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
+
+	if (unlikely(status & XAXIDMA_IRQ_ERROR_MASK)) {
+		netdev_err(ndev, "DMA Rx error 0x%x\n", status);
+		netdev_err(ndev, "Current BD is at: 0x%x%08x\n",
+			   (lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
+			   (lp->rx_bd_v[lp->rx_bd_ci]).phys);
 		schedule_work(&lp->dma_err_task);
-		axienet_dma_out32(lp, XAXIDMA_RX_SR_OFFSET, status);
+	} else {
+		axienet_recv(lp->ndev);
 	}
-out:
+
 	return IRQ_HANDLED;
 }
 
@@ -1151,8 +1155,6 @@ static int axienet_open(struct net_device *ndev)
  */
 static int axienet_stop(struct net_device *ndev)
 {
-	u32 cr, sr;
-	int count;
 	struct axienet_local *lp = netdev_priv(ndev);
 
 	dev_dbg(&ndev->dev, "axienet_close()\n");
@@ -1163,34 +1165,10 @@ static int axienet_stop(struct net_device *ndev)
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
 
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	cr &= ~(XAXIDMA_CR_RUNSTOP_MASK | XAXIDMA_IRQ_ALL_MASK);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+	axienet_dma_stop(lp);
 
 	axienet_iow(lp, XAE_IE_OFFSET, 0);
 
-	/* Give DMAs a chance to halt gracefully */
-	sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
-		msleep(20);
-		sr = axienet_dma_in32(lp, XAXIDMA_RX_SR_OFFSET);
-	}
-
-	sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	for (count = 0; !(sr & XAXIDMA_SR_HALT_MASK) && count < 5; ++count) {
-		msleep(20);
-		sr = axienet_dma_in32(lp, XAXIDMA_TX_SR_OFFSET);
-	}
-
-	/* Do a reset to ensure DMA is really stopped */
-	axienet_lock_mii(lp);
-	__axienet_device_reset(lp);
-	axienet_unlock_mii(lp);
-
 	cancel_work_sync(&lp->dma_err_task);
 
 	if (lp->eth_irq > 0)
@@ -1709,22 +1687,17 @@ static const struct phylink_mac_ops axienet_phylink_ops = {
  */
 static void axienet_dma_err_handler(struct work_struct *work)
 {
+	u32 i;
 	u32 axienet_status;
-	u32 cr, i;
+	struct axidma_bd *cur_p;
 	struct axienet_local *lp = container_of(work, struct axienet_local,
 						dma_err_task);
 	struct net_device *ndev = lp->ndev;
-	struct axidma_bd *cur_p;
 
 	axienet_setoptions(ndev, lp->options &
 			   ~(XAE_OPTION_TXEN | XAE_OPTION_RXEN));
-	/* When we do an Axi Ethernet reset, it resets the complete core
-	 * including the MDIO. MDIO must be disabled before resetting.
-	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
-	 */
-	axienet_lock_mii(lp);
-	__axienet_device_reset(lp);
-	axienet_unlock_mii(lp);
+
+	axienet_dma_stop(lp);
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
@@ -1764,50 +1737,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	lp->tx_bd_tail = 0;
 	lp->rx_bd_ci = 0;
 
-	/* Start updating the Rx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = ((cr & ~XAXIDMA_COALESCE_MASK) |
-	      (XAXIDMA_DFT_RX_THRESHOLD << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = ((cr & ~XAXIDMA_DELAY_MASK) |
-	      (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Finally write to the Rx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-	/* Start updating the Tx channel control register */
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	/* Update the interrupt coalesce count */
-	cr = (((cr & ~XAXIDMA_COALESCE_MASK)) |
-	      (XAXIDMA_DFT_TX_THRESHOLD << XAXIDMA_COALESCE_SHIFT));
-	/* Update the delay timer count */
-	cr = (((cr & ~XAXIDMA_DELAY_MASK)) |
-	      (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT));
-	/* Enable coalesce, delay timer and error interrupts */
-	cr |= XAXIDMA_IRQ_ALL_MASK;
-	/* Finally write to the Tx channel control register */
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-	 * halted state. This will make the Rx side ready for reception.
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
-
-	/* Write to the RS (Run-stop) bit in the Tx channel control register.
-	 * Tx channel is now ready to run. But only after we write to the
-	 * tail pointer register that the Tx channel will start transmitting
-	 */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
-	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
-			  cr | XAXIDMA_CR_RUNSTOP_MASK);
+	axienet_dma_start(lp);
 
 	axienet_status = axienet_ior(lp, XAE_RCW1_OFFSET);
 	axienet_status &= ~XAE_RCW1_RX_MASK;
-- 
2.31.1

