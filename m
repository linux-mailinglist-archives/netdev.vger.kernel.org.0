Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F904CE23F
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiCEC0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiCEC0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:08 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDAC22B959
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:19 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22524xXq004654;
        Fri, 4 Mar 2022 21:25:01 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:25:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QErzwdhDo9bqsDzBXCY3dJ2riorFPd0itJ71NwxaCzUCd8DyD8+GL4zNWx9GEapD5dZYDHy0VhD7kTCAX6q6IvZt8S43amVNl1tYIH3FurDPibOlKPH5Nvz82q2lnmQNXL5GhPvU3h0LoaJL1Y3x99OIXzIT24Ayw35aXMUguwvUKcvmh+ZPT8dwtAcIx2AbQ+hbzhU/URu/grRvFNn8nVeyvd1f39mCdVUnX2CeTXA5PQjUdWYEk6siyjrKat0VAq+qTzHBQija3nlhB/nsvNl5DpPMwWMlILb5rVCnd+6wSWMzx//Kz05/FphUThtQsECDICCIjbt1qe+NdldnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmGF+PECeuzxRb/Bym8EaMgnscDUXKqiVlYkBMd5pHc=;
 b=nui4CyG1wn5S9euckrarGeJmn8JjetSfvt/fa5rv7Nfdiqevc65eYWRTRlFFhjQQgDfxkT3MQa3TrQRSGSUBjsplxq9a6avK3fcdOs3fGvN1noXVBZ5Nnie0KEj5fOv4q61hYcT558jx2WGyMTWM6cxIAGQk9c0gTzyw4wRGKNwZbhgk5Dvw7czY5V3HYnY3cdEroLvGX2H29l5hUTR5XiBNje6ZZhm1PCNIqTEFLLrH60aRSM+Lp2npYeZMh3kLOtwXALKVI0+74niOs3Zhm0dUD9DD9Bxk9dtZgYVOYEYVrdAIbA1Vwbws7WD+9aFYibQSORMRLbvUfHc2/VaiDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmGF+PECeuzxRb/Bym8EaMgnscDUXKqiVlYkBMd5pHc=;
 b=JAM5i4fih9JYoAcB/HeOPAPhGJDC8BP3+HggCVH3NbmPJD4zTFU3a0anc1M4fBIq2jgVDevgiKXifqX08zxxgafMZxSmIbtZvom9xrkq7OiP6Rt8PEDyfTpGnbeQX23DDJfa6vNe5McBGT2xuMFDl+d0BzImiqEVXD7+zVgxZUY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:25:00 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:25:00 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 4/7] net: axienet: don't set IRQ timer when IRQ delay not used
Date:   Fri,  4 Mar 2022 20:24:40 -0600
Message-Id: <20220305022443.2708763-5-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1b0ec5f1-4808-42a1-c0d9-08d9fe4f5912
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB318424ADA215B0B96F07819CEC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y664+KSzNNsNTqvL99o/O7Kw0CU3D4fvp6a6f7iYCvD2w4/UOh4Peqsgt9zDFA5hoK0xn8qDt1ltliVDLCTz0ggA0w9dtmXSJDdT1iL6YKX4IYeMrc9tvSHc3Qk4F18L9ODw+WyDcIHRuQWBJ+G+NA4A+GDQVAuCD9aIZ+8QiBSKz+CrdVnItiZDAsMXM8kYCr+k9kk7OytFUa/J0bMfsxn2em6oa1H2daFRquiePhJnFq0xwSuN954CdK4wMXy+I0zwmOYKUItBL9236Jjz3w6Ww5Q7scGXHdJq7XSM2Gngeg0WwZ0WWgAr9VRTOxhx0J8hyEIx0wp7lw+FAUrnmk6Vm/92g0Irqx2SWflFkC2wmqVEF/o8KSjLA2/9zdcP54Uv+za54UsLEdAJDGS++k5GQLT+/vgGlk8hF2yEoymjEiVtsuiluKWirfBI15jLDwMVnVEaOmSBay2zmmhQcYtgGKiXfi38DdcbV5PC1+2de+zfyKhQEYlPMAB+QPS1Eg49U6/JQBx4CE944099YQtg1TwkbBkV3ZvZV/iyyZFQPCNTa9mIM6r3b8c14Tj9Ybch4gJicHx3TUN/pXB5pT+LeGgEU6YQvpDBI6buEW/ceZL4z8guMMetWFQTebm81rzkJ0mbuJaI1ATAr5x+tl0vOm5mJ+4OU2vVWoML6M0ZzrB8eA5Nsfo8mbvPBfPVP8OWYQ2Zv1Hz6wcW0OQT3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IsNsz2baAdQbZM/55fKZRKftrs04P+NzbtD0SBhrL5EPpYKPyn5moswAJWyV?=
 =?us-ascii?Q?jJU7nwjc7CXACukwXhpfBybbO7HuE7qzzFINeb5ld3RRBexd0hBGFFWApkTa?=
 =?us-ascii?Q?3bWEZypLUtAYLHqbHjSiaB3J4Jy6DMvYT8M7ivqttYotDcKTkzxcIyOIiY0Z?=
 =?us-ascii?Q?MwQsTUFQjcwqMzvsarjJOGUVOLgGBZ+wqsF7m9Bfl8EDfJi4ow3bZhHnSAlt?=
 =?us-ascii?Q?qLwvD7bYfpKiek0HbNmQTQ99mAGUyLvnQM2pTHC5oKrh4XqiOUxQfbOuBOEz?=
 =?us-ascii?Q?Uu5ORR0TUnr6Jm5r+BTiU6xypgx5rAZbtZ6QUCF8b7M/156Px58KgoSLS+Zs?=
 =?us-ascii?Q?q0o/BzOff9QNFnsrliwcO7PpGskHEG6Utpt4TQHUIbvCizP4eBt78Hp5OVOH?=
 =?us-ascii?Q?LPNNxHNCScfYyHVZJlmt7z71OafFDWyE061Pb3PybxDEP0CJWOQXph3Z82Gg?=
 =?us-ascii?Q?ipv0j0xxdDCkc8/vjiRZoDEiv9fWOeE96mo+W4k7sPR7RX5C7U3pizByxKqs?=
 =?us-ascii?Q?RVezocls4F62qAsvFUndlpJ4FAhlEg2thxMfQ+xU+Xr3l1ezNdF6mzZGRIml?=
 =?us-ascii?Q?Q3pEbq0IopXXupoHtmG3Dv3cmyA2F/tIKwZDagEQwSYJIBb4r4zr4LYIt7JT?=
 =?us-ascii?Q?mHn3gfu3SFSOrxXpAbVRL829r4hfPeal+haw8dXOcyKJzaEz4iQEpywiJkEa?=
 =?us-ascii?Q?wlRkDE4jHsNM9+dmUUpBcBz2ni4M1TOUDO5pegplLJL7czN//ew1zofcurGt?=
 =?us-ascii?Q?/wHVqCWdEg3XdPoiSJs5NBnPi7aGq4XYUfor4TpV5RhbfZ4HOSJOKf0pE/DM?=
 =?us-ascii?Q?UnS1fIgNLi0fq/M8Y4pBkDVFN3jq/ea5RUaYdaAXOQfxgc9zxi+rCsibGvDC?=
 =?us-ascii?Q?wNcl9OQLbZE0Pqv882MNz+mKfBQBWizGG5vWkPuQ4t95tBnOxEZxH4RsjedA?=
 =?us-ascii?Q?z3AovwayQq/YqC4IB+GJmVYFR+weX9QZzAcI+TiW+bOiDOi+bDQvUhUZAfkn?=
 =?us-ascii?Q?+BXtCNztyJcyAxguX2ke/QBudbaNpxoa4DG/hJbSJR4zs1qGmYEz3/kfvhYe?=
 =?us-ascii?Q?dCumXmowT/dH4lQrYS7NHjvwG5VJRMdKMYSQ3NreGsduvCeK+DyOHVL1bU0U?=
 =?us-ascii?Q?jqMZsfiTThX2XuolTqKNDUKS3A65Ykpzin2pLTuacTVsPb9/oo4SzEsqJsOZ?=
 =?us-ascii?Q?M15zNmut3ZhTUAKRS76SyKy5KRuGINQlEGur60P0YMfA/i4JhtlDzX+483UU?=
 =?us-ascii?Q?AepZjEQLdHecLuSZkHkiqIomzS8nNu2VxoCeUITHlreQhLmLrQvSz5UGkk6I?=
 =?us-ascii?Q?p3WwBGArKxEtKxZZKhxQjs4ifsfdmCPiUtLP9bflCbbNgJRhV3r3cy140Vvz?=
 =?us-ascii?Q?Xv1NIpbd9ndympEi9Ghfw4Hcgnou9bVIpz7E2FB4/sc6coYoE3UcDwAs4XJs?=
 =?us-ascii?Q?6dHPz2dren0Qyag0EgTv/fLSwKk4N2MvTlMfbg/M+AzgWcGRg2WyRp7lUs0r?=
 =?us-ascii?Q?8iP03dQFU9erM+ALGo2zRvCpUnuBgTCjOCL3/PqPxfW5txXrCLCwOUWwmZIZ?=
 =?us-ascii?Q?5qipfjYO0krOV3Ns99ju5jIxAfNQ5sG68TNstejiMIViIX5RDpZ/K9JkDtkP?=
 =?us-ascii?Q?zkbIwFHCwLThaC9IJbL8v4mMIEwewF2ZACuzAyIE4qKPRldheSuDzfxnBVOa?=
 =?us-ascii?Q?FJB7opI8B9QKXl2HpD367V+C8Oc=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b0ec5f1-4808-42a1-c0d9-08d9fe4f5912
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:25:00.1159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKRxKNMLBijfZ//65A9mSzBdNhMbnl6JFwIbGgjIs4hf9J/7ytps7rKQe4HugicJEoQC3LSXQyS8fHsc9pLyl70JAc+1mxiOcdNnPkolJ0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: TW2GYK-UbEkt428WuF424NyFBbbBSBmX
X-Proofpoint-GUID: TW2GYK-UbEkt428WuF424NyFBbbBSBmX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=854 phishscore=0
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

