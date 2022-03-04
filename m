Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947644CE056
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiCDWo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiCDWoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:25 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAB15FF35
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:36 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224MaIDh005553;
        Fri, 4 Mar 2022 17:43:05 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBbQxCsNwEkgpHkgXefhpSf4YxBgKSOfm5eafMfwmzlNjeB1gsiTf5FfwZIZ9HGdz301OiAOfSwBOfpc6oBwmvEcUyH+0dJKd7h7sFtwcifYOLazqwjq6pFEdiNqZlrYYghfrfnuL1VETpFfMvgEWnLKAmkARoOA38YrnBJ0R43N01jsjfu6vWM2wBg0QFV4OEkZNZFSr08j3+XTDZfYM4ae2SgbunIRBHVadqqqNonLqta55tXajp+HgraPcFpMEoUvzjcNqyA16GhtcfMzWyWD2E4kNIvR0R8hnINBuRKlZk3ZTUOoTWPVqw7ThK9T7FCQo4TnckJG7jERGOWRxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmGF+PECeuzxRb/Bym8EaMgnscDUXKqiVlYkBMd5pHc=;
 b=e0PgORuM6D99du2IygQeyqH77wxLYdbgZqbZnoGhZjGnUv2G3v97skjhz6iSD7+BEYQe+/MppFPwQe5FGKEthi2Gm27FDX6tN7JJjxft9ideXS+iEdPuGETNUtoXysnKSVEdZJNp2T4ijOYJD0PKXgesKwONu7jajY2VODssx7ckdnnShXXICFJbz6u0KD4e9qH0332O/GfQJJrP1Cscvd5r9oBLv3BYAzkNpaKFulzXuXTF3WMp4F4CVgaqyARg4RuMKf8ew4ZLP694MWNz0wgNqMHZWzZpoLbOuUCxp1e1CjPp9Um4UoZuLEJpTqkz1sUhOcHL0pYE9tuECHG68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmGF+PECeuzxRb/Bym8EaMgnscDUXKqiVlYkBMd5pHc=;
 b=36JlKSEOIThioLmz4hpdwnBDWw1MhnNTw38tngCYaLzzJqm6zfAZIh7PCbuQgpQWZAC5sTERRYSzVL1xrTddJItMSCpEd1TZrYQH6N1GWof4mWt5kmRtqAKsA1wLJqJ7Cal4lzfQ228kZz6tlKeEzfnxr/D0Qde8TFoGHe33n1w=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:04 +0000
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
Subject: [PATCH net-next 4/7] net: axienet: don't set IRQ timer when IRQ delay not used
Date:   Fri,  4 Mar 2022 16:42:02 -0600
Message-Id: <20220304224205.3198029-5-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8edf53cf-d6d2-4b8d-95b2-08d9fe3057fb
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB6540EAA8AAB8F17E7E57E848EC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QuSre7KMDEq4sQHR0JUTa8EBnCNgypEwCMRidOkpHY4vNN+9wjxx+gvdfPHscz5R1U+XQavFuVySwYnqOvGoEigSyUz4PQQhH0+bZlHwWKIgoqmRx98O8BqMcUBTxqJcVplx/8JANDns1Wqp+Vcp9UYwedNs/16tVq/m8JFY8v/K+6uJMDAvlqvU27Y/i+7y+hcC/o/890aM2sfXu/IGn+r/BAPcLpVs0P0tDrnmFOjAGVWQBcR2Bywga4rut6uSAto87zK0yGlp9eRKqR6i/zA20aMUw2eF44vgTRYPWPGiXQWD8kJkjdGSCW2CHRvojLXlRMqUY+sag8AU+OIa5id6i09ygTCxBPEuyWKkAhy/gM418yGtBsk6I1hntRzRamrnd9sIkmw2ldQ78uyxFW627xA/hGHt5NDbXjMe158bvFM6Lg7OG0NNweSOD5+2yyrZsXm1MLnGlwN6mlMRR5m8qDyp5+DuFHkaM5DeKHmC5F3wp28sYbkHGBEm/VaHdyO8kKzZ+ckK4AN/Zw2vRb0vi/iExOTut4LfCAu30KeGGlFLshvVQVikl1N2pakg7NDMKsVCg/PLO19HkSJmHiK5qqC3DLKgqykOjm4JgJzSpPvcZed/f5W/WxWOPSE9MguRvfcbYYUmvL0tME+w3FZu4FMv79lM8bhMnMCBFbQBcCm2S/iiyb0JGa8UP2Tk7c6xvh4/+hZvPig+14dpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JLv3nf9mFjWnNHp7dYI6yGooIVhZ8Rm7Xk0+lk7Ej46pr9gK9qvXSSlS5o0T?=
 =?us-ascii?Q?pARwuy8UOLYJi8rG2glysEqOxWNKnemAKk0VlTvsbd2/FKHltMrxMvTl+TYM?=
 =?us-ascii?Q?YtpKPCDSvm9xbiDL0jRwL/fkWcYxk5XOf76ZiLYBoP4enw19ggIUrXr1Xa/9?=
 =?us-ascii?Q?ShdgyS1BJyJhOeXoO43G0WiCWCn2A+6J1LMX6vF3n/8E/8GdD+BDVrDCLJEW?=
 =?us-ascii?Q?S3OP42LzxOEEUerJmfPMXu/sq0uP+VhCTMIvvWoH7bksaitz/Yy/WzXXdDBh?=
 =?us-ascii?Q?7murxFfNHRmo0aPVSGdC9K3kBiXOD3byp+rzwMcmvL+cfVsGn65XsKe7o9ri?=
 =?us-ascii?Q?9QW5QrRwoHBZk8KINs+7TLq3mK9LFrrxpUy4TME2R7r42qd/dEBbGrp17+55?=
 =?us-ascii?Q?nRqz+uHMuJrcJomVQHFwNHS04E+IMf7SdDw9pDRNvz1JMl5oJ2bqhhYKo5R+?=
 =?us-ascii?Q?ERL11j+b23TPlYYWlBtxhu7kz/qqnoSnjrKmReZONqae+7jC8KJtyVMxtrZS?=
 =?us-ascii?Q?D8PLOviOV7DlDZ0GqtFutc+kCmKyuw1bS4dQot0KEYkEffOujK5WPCUlFmZp?=
 =?us-ascii?Q?rBAzzcQTIA5NfQroYmakw8nef0/vVeN+DL2HDzuYX62MudKFz1KKI8lfFuk0?=
 =?us-ascii?Q?k2nX/Ms2MYDQv0f16Ue9uFccIrs3hejnW1SmhXS/wE/Gth54fPTlqfOjvhtQ?=
 =?us-ascii?Q?x3f0PuDdQVla+4gLWLwEhBdqjUBrR4L2SfEHFUlJqXabnxLXr1vEOtbXHpPI?=
 =?us-ascii?Q?ZH0aap/t24lvRutOn1XzZ/7h3dcAMn4SuRyY/UT4LFLc09ooa7wnPe+tqBa2?=
 =?us-ascii?Q?5yU/D9C3Lq3VZxcl32bku2YU1NQddd2ox9PMZVvaK1N5T+Ev3q1NJt1RJhj7?=
 =?us-ascii?Q?xCnmP31AEOzKWMb5HGCHtVqFFfaImwwwlb7FZTIjbV7a8WlWyuWhjSIf6gX9?=
 =?us-ascii?Q?Rt8e/CdykeBDeXaOsA5H3A/oeJ8+5yp5K5booCSZcKHnx3lRYi3FwGXL8Cja?=
 =?us-ascii?Q?19i9YlTxIsZCSDAaI/AiNRlRw1JPwtgQfPUMqxHv9LBwPpcerFfMnK11UnzQ?=
 =?us-ascii?Q?ClS3oJP3mpJDci0dipqB74j+tkQ0UR90Ey8mCbME7+uduFdkU+K1Sfr5sUzQ?=
 =?us-ascii?Q?KF8BbNLybFsfzZ5I9ZzLRPC3gWYzciM7w29/T0GgKpCxn0ci3GSQS/hlKMuF?=
 =?us-ascii?Q?6pUtRZLVmZEXBMzgDu6JVWdQrQBQuL1sawRL+wzmWiq1LAW2CqEB7aK8MR1E?=
 =?us-ascii?Q?cWb2Gkqb5va//Eedp8Z/h08gDrgPD43/vbzMyDX12CWsu6kiR7+NQxkFX1fW?=
 =?us-ascii?Q?HKvc1dIEDGeIb6A7o0fkOvc9sU5tZMBDpb9x+rBecj81Pinbbc2kGo0Ma+fj?=
 =?us-ascii?Q?x6z7JJB3+aM8FAbkNDFcJfXiGyGN+z0g+bWyglHwm8tig5hTpS3ouS3oGGZZ?=
 =?us-ascii?Q?jzXsPy3s7Hgk/u20DRl/d98pzN3ImnCP6b6oxTMpi4CuDKY5TkcPzpsYFrNW?=
 =?us-ascii?Q?jlsWab4TCWAQ0AkZYCgCFYS+lvpZGHxht9YlhJ6gwPWAxRjLVQXUt2+pjaRl?=
 =?us-ascii?Q?ss6etpQaUCxyUsw0I5QFD/zAayhDE7aIEMokVwTe2rd3QGgmaQ1Dcq1xf/cv?=
 =?us-ascii?Q?V6PrsIKhB+jMBgUvw0fSv7uibuqT3/OUlRZh3y12/Kvz4nZGFE6WgrzigsSr?=
 =?us-ascii?Q?VGcKbuhdlmXqSmDJ3SsIsChkIzw=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edf53cf-d6d2-4b8d-95b2-08d9fe3057fb
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:03.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOBGPAHtVuNenaFarRIswSWH1uoAX9OnaRjJmJAY2e4FDn6Azgiaj3j75kWP2CrOnZUcKST9T2FQ6B34R0ecUY7TMarnuNdaYmWW6KdS1rU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: qs3oUk7M7s5yCV5Epry3XQsO2OpQH91o
X-Proofpoint-GUID: qs3oUk7M7s5yCV5Epry3XQsO2OpQH91o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=836 phishscore=0
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

When the RX or TX coalesce count is set to 1, there's no point in
setting the delay timer value since an interrupt will already be raised
on every packet, and the delay interrupt just causes extra pointless
interrupts.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c  | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d705b62c3958..b374800279e7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -236,14 +236,24 @@ static void axienet_dma_start(struct axienet_local *lp)
 
 	/* Start updating the Rx channel control register */
 	rx_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
-		(XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
-		XAXIDMA_IRQ_ALL_MASK;
+		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	/* Only set interrupt delay timer if not generating an interrupt on
+	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
+	 */
+	if (lp->coalesce_count_rx > 1)
+		rx_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+			 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
 
 	/* Start updating the Tx channel control register */
 	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
-		(XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
-		XAXIDMA_IRQ_ALL_MASK;
+		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	/* Only set interrupt delay timer if not generating an interrupt on
+	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt.
+	 */
+	if (lp->coalesce_count_tx > 1)
+		tx_cr |= (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+			 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
 
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-- 
2.31.1

