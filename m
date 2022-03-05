Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3014CE178
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiCEAZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiCEAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:03 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3569972E4
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:14 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224Me5vf015540;
        Fri, 4 Mar 2022 19:23:51 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8phf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIt/Vo5GMWH7OD2ZYDfdubvuBPa1YPIzLbmc2eeVtPD2snDlph+uUPPuZG3/38AXUxy3sWYtFbw7izDTpaBoQchyoILGhjJlinlZO9DwUrNTptrVpMOH/HOa0ED8K4a19logcB980cdEZ90Ww9IZ6pwiG10nBtBQHbi1BXz8ehVU+iIUYgyKZFq1NKWtnHT7GCwbMjDYlIuwZPpufT9Bc8Nq24xZDSxwab1KB3/jgSlvTGl/jm5Y+qxKP7u0C0U8gp1wpuef3sElIeZWrBddoh8S13bMa35MtuzaWsEmmLumrPof+IAdFO2Ju01tuJ4bSKHnp2gRwtyvO3YN4Mcv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eN8cO9YJBuntVYjR4BtMhDOZmxyTXlShRcSun4tunGI=;
 b=Bzc7DbaSnMU43vbWOeXW9cGdsgSYR+u6Rc83x7RKCWY6DJjX/S560UAP4e3UnEuq3rA0vr1adWSHZB24QDNrdQlhxD+QfgXE+Vay07rNQ6grJSb5uaI8+0NBrgocD3R6nVbjqWl0xc9UEOhnUb7vt+Z+mq6uiPyT6jNGnKq9/xEWTeklQN6d/U8IlAQaXmgTvWvNH4qXpGuThOeEauzeXevQMiJQMxBDei2RbLmEsZ6fhcMzBSLPgNObANgXbnc0uSS9wCwbkp/xH4291j4gHASRiDYGKkHDXa/PJH2kYOM7rHpUvuOZo3I5twkLqPvcwWGzuuYzTwJOo1jiCMnq7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eN8cO9YJBuntVYjR4BtMhDOZmxyTXlShRcSun4tunGI=;
 b=4nO6/qnnpLgeIf8zExCgHn/A5u9CnhqYZ/WPS5gfGgg77UBUN4sYBtazMDxg2i56r+O74IDLd5w40EU5auWCHXVejlVKJ8Sxf60q8psPmyxXPTQRMjLMhMSyQsyN/snYbn4nP/qO85AeRurbtGwDa+2yG0qs+OlbbHOReG8qxqY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sat, 5 Mar
 2022 00:23:50 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:50 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 7/7] net: axienet: add coalesce timer ethtool configuration
Date:   Fri,  4 Mar 2022 18:23:05 -0600
Message-Id: <20220305002305.1710462-8-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7199997e-3bdc-428c-8d17-08d9fe3e6b9c
X-MS-TrafficTypeDiagnostic: YQXPR01MB3701:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB370190B1B2CA2B78230216C1EC069@YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w3t4AJDuLsvxj2ZEBh71XkHg83BwtgRTy9iqeC3FGHEQsqRj+uy7VBUr9FKpmckS+ccIYOnnvt0u7L2BQUpsKutFH8EkkBuYYJUKLkny+mqWCOfr8AImiSYn3Y9+XtFvSdOx6NJ1Pw90SGdRBc/iCmNaFBrPTtudQrQtSjVmSM6pnNcFPEZ6M/6mrzcEf122SVG96pFcrY/ABo3CW4IQ/bJZBlA6VyUw0G14k+u4EeK+ww4DwiXoQpx3RdN/GOH6WqFjASYeGTMlsSLGK47egeEaY5T+YKWEPuT8motM5NJ6Dde9Hrg2utUG9q+T+hyts9Yw8CrbWhRGDOxELDadEguCZkiUqCGMKhDKxcQxNaD80LkvQozTgoAUKEqe4oQJ5aKYin2fT2lPr0nZ5w/KokdZ17UA53e7z3vHa+5zZGo/Er2FKSsn5c3i81lBxOamtH8CtzDoUHQXnKgKryOH2O+r3ce6kCwvC4ddfA61zwV63Tv4fJ8oNx+fVFb7MZ+f9cXxy8Kyo57bAPf0PVfQns7RR0eUMfu+U7NnAXXwZm66tGE67LeqKI9UHe7iH2/Fwg3vPKuk0ukhKtEn4znjk/3hMtUfySUGjEOMqM4eCjkp1MfaiJbpH6Ph1EPxFJqKAqphzq2Pj0ciHP+AsC5mx3dzF7FzSAFslzxszCPqVK1x7aAPVRX63X2m3IyAyaIJjNiniWTj9VmKqsQSDmyEWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2616005)(6512007)(5660300002)(52116002)(44832011)(6506007)(6916009)(2906002)(83380400001)(186003)(26005)(107886003)(8936002)(36756003)(1076003)(316002)(6666004)(38350700002)(38100700002)(66946007)(66556008)(508600001)(8676002)(66476007)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a1FZaIIneD0FyyR0oUDT2AHx+eg0dIgPK2zGaHidjjpacLt/Q0yWD1NXpI8v?=
 =?us-ascii?Q?xpz0GiFk74lQITl6loeklvVSRiGJAnBIU8Uclr/iIeFy0Oy5TWpPwOIXsnEs?=
 =?us-ascii?Q?8oVog5g1wYfYgZAg5dt1g6Z2cR3uY8FIJ2vNBDXmyMDDXPxZ7m1Qjv5pfE34?=
 =?us-ascii?Q?+eEtEFJxEu/tMeOPxZNSODrlxOpzyuFVaCJXkY93Y2Uogn7i6tKWKWyKFfDO?=
 =?us-ascii?Q?wJkHJPqxx/hE9LQvSiywsYJ4KLn4CmPXo7KI5MXInqmaIP9DzrQFU19FKDd0?=
 =?us-ascii?Q?nRGKrdlb+uq/rO/lImxc3Nq+MMevE99VN/DMydVJFVm0hja9ta6gKOgBBrLW?=
 =?us-ascii?Q?YwaPxErGN1GBW3UeyiaV475P6VYhaOOug9b7D6m6PZN+zWHhNaiZ1HAPCaHg?=
 =?us-ascii?Q?mgkPqq+sh7r60ukfLD/KPYgFkiOTZNI/KmDbncfIPurOvzK8UKdEgV5Vi7OO?=
 =?us-ascii?Q?rPTtbzVErGSY3/J4+57LCqkh5TG4LuBTZgTHO65ztJuhlNT3T0LyCVnKlLXD?=
 =?us-ascii?Q?UFEX1yDxk0tczR+wRSVI889YNLNV72V/1uSF6IlkaVYFkpv6BL8fNkfS/2f7?=
 =?us-ascii?Q?OM7qWOYky9IzRaKEOuTDoEGtGvCE4SrrPFlgatvcOwaA5ZhgwH2+G26I/Pyo?=
 =?us-ascii?Q?jLAuH5OQvghpJUq/FIiNerQE26WockOPpyZ5vOYd43TOBjJwn4oZAHMe9F8M?=
 =?us-ascii?Q?OiktbcCwZp+05ULLRpyzb69IvBleXR6EZKPMSjVv5Irn+idTTaguOrk4lpjC?=
 =?us-ascii?Q?Uic8y5JT/i5DsepWRPm7JS/1FSNUP7ouRXSJ9DxMfvCZEUZpqYPNgzCQ+m94?=
 =?us-ascii?Q?9TtmiNNihjd/isIyHhE7cBKGM4Bio2BidOo7V+4pV98RowqTaMZjmynPUS6l?=
 =?us-ascii?Q?QNGxtdxyD0dVL1baKwMVz3OgQIxIOZ0e/j7PCw0dLzVVcDuTQr7pr7F6fXv3?=
 =?us-ascii?Q?lkWgpRHmWpgatW2i/KicIfMoFE8w6+YExb+vKR816SX7bnHdkU65nbkIIOe0?=
 =?us-ascii?Q?ZpAvrcZet/OE7JK5w3B63ahpoKO4s09xhLZFLoGFXKJwwe53vVLp+2EEKXlS?=
 =?us-ascii?Q?F8qEUMvfphYr1hAAK8BTP7o8UuXbWSr8lvs+e2hWAFfG6WPfh46UQeqbSHe5?=
 =?us-ascii?Q?SvChNvGIm+MFNhzX0efzrLdyAc9/VxLF8HF0bH+R+RvXQCVlZddYa4gcVPlz?=
 =?us-ascii?Q?X5IHLSmVmHpyKkdT38qKCtGRziDEcReQFxwRx3hhlZQtJ5YMShheHGnB/1HP?=
 =?us-ascii?Q?pXdJ1u7sdXU4donvb/fP19RAsHTIYmNYjcln70HbyDtFvvqY9Z5zldiOYqLV?=
 =?us-ascii?Q?x94Vc66owsxUzrplQtox02PYtZWaLfN4VU7qk870tS+yfU+RKpgCukemm1/G?=
 =?us-ascii?Q?vBzKqDZQm08AL/DtVoq79SzJSovAt68HBWbZDrlFXYqE4WlLwX4JFzwDWvRm?=
 =?us-ascii?Q?FGQVrVWEq6cAoQkvz9ntj81EotJEKQx83eEXa/JO7qiPzFxZxqkWyVoLkqS7?=
 =?us-ascii?Q?WVkLpptqrLYFccG6wCct5EBeavVOoZcnC2lqjz6NIgiDNgDX4Z85KlWLDCEs?=
 =?us-ascii?Q?Jm5ugEsiVCOv+9G5ughYaoVz68CE6oDkVK6z6HqoIri0IRA0MY/ln7dxKh/1?=
 =?us-ascii?Q?/GDRXSLVQ9ZuS7YTFfYO+cJvgo1/j7SQPT3ywqUJ2ubUfzhsAjwugOUjFG0q?=
 =?us-ascii?Q?HBgHYw/c4sX62JvlC2sZmgKVfPU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7199997e-3bdc-428c-8d17-08d9fe3e6b9c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:50.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WYXy3fdTRaz2h7fYmMejnKVPKUFMQlx61IFv1qWjPuSCKdf+3Hb2ImFGL/qeP7hmATh6krMHN7yk21NjOwFky/5RjN2oY8z2/kmCW5nmgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3701
X-Proofpoint-ORIG-GUID: Q8gE4z-P62aINXHFWJV6lV0cdiV38mq5
X-Proofpoint-GUID: Q8gE4z-P62aINXHFWJV6lV0cdiV38mq5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040121
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
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 51 +++++++++++++++----
 2 files changed, 45 insertions(+), 14 deletions(-)

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

