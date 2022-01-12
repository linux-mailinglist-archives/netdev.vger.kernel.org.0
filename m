Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A724548C9E9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbiALRi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:26 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:3752 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240518AbiALRiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:22 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT6xY010893;
        Wed, 12 Jan 2022 12:37:56 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1at-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:37:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4EDMorJalyh2lBmx4YE+SSwzIWLNPZ/ckiv7tQ/AAn76Qmc94tTGpQOT2GhiKguu1gX7GI8kTPLoNZ27L/bTcs9lBaXLowOXZRWJ5oYeKo3aizfdRz6FOO2/bijO4j+ySeWP1aNPXerg1eMO1lp8PE1qldEtBYqawBeJL7FsDnmtWX8GR8xG8Q0CrczraTL9rQwjXQXKJk7CBgi7r7NBZ0QGFESbUKCCfAaFMCB2sJ17drEemhUJI1lcydqFwYuDDtHli+aQPWNbCHJg3Hp6ANuugJdL9WVYi07vJWfD/ZWnpdv0MeSclsNdABxUekBCneJb7eFwOD4zrywiVBnbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYbWVMZqFSpi6EISAGFgudiLlZEKwZLXENRjQIX62Sw=;
 b=XiS8f+S6ZdprdVUjJ4e0dTc2k2B/hBSv2RNG/jVXvVkgPuM1z9u1OIHjgwMv4lIRVIX64SyH74kbc5WTYlLGqNs63LCK4oNobD4b5GGKcAP4wTHiyQv2xHKyMbdRGr9384ZfeKm/x0CRIG8/wJXFpQVRpjd8Hz3u6dk8gwg6yuwb8XsWrLLZfZXnhLMrnX0ppZCuSEIEcriRNGfBf8t6GwDctKIiPdQvEeHo/BGSkp9xvzyslIgUuXv5COOn2dAuBD7fI4h6m5itfok3rgU4yuxlT3KEL73iuFNm4iQ4YNcSCjo6sVNeX/wkvzigIoMHST9KbMgOzyREnG6LbiHTwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYbWVMZqFSpi6EISAGFgudiLlZEKwZLXENRjQIX62Sw=;
 b=xvDULi/qzDo7iTSDNLnJIBW5qDWERZZ+LNhi7HOPdZRqBYe/8B4jnjX5bagbJJZXvjaTSd1gr0Hng8XKlCqex0Hd6fxXg3Gd9w6cKhoUDdcS8CVGHU5sV3giuL/QgERAb1g0qQ9csu3PnrBPpqY6fjiLdUkdXGSIIJ6vvNL8ACo=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 17:37:54 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:37:54 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 1/9] net: axienet: increase reset timeout
Date:   Wed, 12 Jan 2022 11:36:52 -0600
Message-Id: <20220112173700.873002-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c16744f-7885-4638-3a05-08d9d5f243af
X-MS-TrafficTypeDiagnostic: YT2PR01MB5789:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB57893459E2B6445B388D991CEC529@YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bU/muN6lhMdEFUaKW32Hdh/Bb8VkoOisDCuxxGObGZfAPmHYItwMJAf5BNCC6Pp8937PTyZbxfOFbG0WYBLQeXJottApoQF2KHR3GeH02lZpVT6kdLufIZsm2e59j5jetmRSoEDrUknMGHEN/tqtoijKAa0coNOL7KrFIkk0GMqowg/MFNgGIJxaqbkhC8t515rXziwikIQDhUxbUKtx+hwh7wbEEc+9A7Knzb1njq6dWNONh5BSkoMsDiFioCfr05jhJeJS6Hhvlk+WPxTddDUu3UDVo7EBHDK3gzVbEkY5S0EEdfPMbS9aW7DGGnGE1M7NONEpp+Dzmh0MrgXRCG9rUqAmgeanPwDYWJceIwYJLM+1MYnbhxxPqe1yiLshW5MQVesMQkPyIQB4MDejEbtHYq3nt5GdE46SrpWGQTmdZuYaRSwg2pwh6Q4Wgx7TQNVmU9+yWgmzNpXqjnGfwWKTVxL2c0YNtPoNoQ86VOsTI/hqHsGQQjPmC/R1hR2khY4jWTrPmMwAvnJFq+4SFYvzespCgPdH8HAfTDv7u5OEqN/xzTFu3Lk+feyMj3megOols4N/1gNVMnZdL2KMTWw7nY10sP6KXjtgGEmFpaD0fzqBihq6uU8m9KDVJVj0jWakaf984FO/5PywhxDq7+nN6cB46tm6noOXAHlt5VUJxI62H5tyYAepwADHpIQIlvF0ioUCz+tLSlml/G6clA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38100700002)(66556008)(66476007)(5660300002)(38350700002)(44832011)(86362001)(316002)(83380400001)(36756003)(2906002)(2616005)(6506007)(8676002)(186003)(6512007)(1076003)(6916009)(4326008)(508600001)(107886003)(8936002)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uIzPxcdbCE5TMvwwiccxFpqIWkBBzHz1vLirbp6NkNqrXGbtA7mQRZXCwwig?=
 =?us-ascii?Q?nGlLdm0I8kgrJ5355SLgJambYeGXMbfASOtdF+Qf5WWZvuUXRL3MrTk27a6k?=
 =?us-ascii?Q?C7+DP6TeXnuRZdT6XNwUtfVFZ6fnO0hyNnfqgoLvsZ7hn7YYGSUiLzI7Gddg?=
 =?us-ascii?Q?pqK1IAOcPu3YEHYR6j2y2+qw0FAAXqGbdc6x0r7+X/QTTd8HtMVmCYIDAa9S?=
 =?us-ascii?Q?qVi7CuidlMqi0vkmBMyjPLJA44bDRnWp4K0PopatODuOKwVA2t+IHo5+TcxC?=
 =?us-ascii?Q?G/c5Zr10hvW+vsmIShLxEGDFYnA98vEbHL8+olsoO3gnY6faxDQEDDKKn0sO?=
 =?us-ascii?Q?fK/2kMlzvicKDmxctmvhFaab0H0hfIOFjYuuBL2TwjHJDXPX3KuOp5yqx6Cb?=
 =?us-ascii?Q?m8o0+pr7ONvB7vlg2MkHZ91v9mm0QGPr89a5J65d8XVcHGzSY3nB98UsiQs1?=
 =?us-ascii?Q?3MYu2vfT0NEwewvVJtk/6QT8A+4SSf70sHdacKBk5gmTqs2yQbXwOaXId345?=
 =?us-ascii?Q?+X25yW5hJJ+jo9f25E0DDntkiF48dmi3wICgBJjWW9X1lvaVCIoHtZ3COHs8?=
 =?us-ascii?Q?+rHYQs633Uq2ERRNr0SnaBp215p+B4mE3dr3gZY/3NbuIyR7+rYGybi3X17Q?=
 =?us-ascii?Q?MGtaNdhg7GEBrsoi6EdAO9qSSIU02B0yJwuV+YJZ6xkxOztdevd4HQAuhI/a?=
 =?us-ascii?Q?eLlom4bbqDQaLKddyfyE8HMJzCn+V2ea4joF+u97zCHy+myiAK/rOYR9GFMG?=
 =?us-ascii?Q?MOfJ6IBFC73C2tKos6u+KQSnJ+42CtuX7hpCYoo/YNOgcNlyKNkyt6vO5dQc?=
 =?us-ascii?Q?0kTZmKhwtf4aLE9Q+6XRhuvGooIk+Al6ek0HCzIqGfSURkjtttp+8ZqkfXNi?=
 =?us-ascii?Q?3zc9pchsa0uW/0FUzIa3T/Y5xVsA+oIREwIo+KaYbXGX2HPCmPQvF5OGFkwL?=
 =?us-ascii?Q?IF1u5jq8f8VMmHn9OOS/pzo1Gmg+rF+jKUf4e9gE2s5pPc9qZ6YvCE96R6d1?=
 =?us-ascii?Q?5CjzG+jVY8vFQ2LpWdmu7MoCM+l9R7GFURfDh4UpImcUAkCY/pJ1skcpr6Zc?=
 =?us-ascii?Q?NW2mB5lzvtOyC3fHpYqXH/Mn3UaJzNMVKhidyTF2h0m8lC1zDClvTLk5brx2?=
 =?us-ascii?Q?wV8NauzD/ihc3Yr3z47Viuvmf0iadlo73KybQOR0qecL64v/dmvNdd1e+hX9?=
 =?us-ascii?Q?0vsy2P2dZL/jZJcUnbkiXGvtXvxKqDnzkMN4i0F56V1V0dWxbHpdvy/ohYqq?=
 =?us-ascii?Q?2s8pNuqqXrzjmFYr6knnCcFzh24n8rP6oiceMCo1RC5KGLkxC13W+R/PwoGK?=
 =?us-ascii?Q?Sno4+63O6hcVQS2kTvVowwjDVSZfp6X6Zhb4BhLBgodfXZHS/R3U6t+Khthd?=
 =?us-ascii?Q?JqTv2c3spSDLtK3Hvf2o8nis72yLGXgMQtMOO2KLYQWX8Fg8Ob4IAU56vczB?=
 =?us-ascii?Q?5DQndMgg5lKqwHZ5dMLMLE5xDzRIbS+N/Sf+rgAUOQ11DXUFUN4Jwdxz0hPV?=
 =?us-ascii?Q?2GF+URP3DDOHvpDgztbvKhibVll6WL6rq4vCnTv72x17JdHtw1YJK17MFS1Q?=
 =?us-ascii?Q?84l/aI7OqFf27IfdRyAcvlyqu4nPhsj7jtL3zIbKjSo2wSabE1ytAP2TdA5/?=
 =?us-ascii?Q?EhJmr81L0U+inT1hSqDm9lHtbeTO7pgqT5lo+p/gn6+CdB4amrulgHd+XYEK?=
 =?us-ascii?Q?Pl7IYNTcYgHBIzwX36MtWE7AhWo=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c16744f-7885-4638-3a05-08d9d5f243af
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:37:54.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuPBx4f6AtkxI6qq2B7ncqqYh4253kYOyK680a08jIHfVRA435oCNBpGdCzyJwFtqdPd2JJyFQrqt7hcVwD9hXwgiz+zwdfkQa9jLdZ5+6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5789
X-Proofpoint-GUID: uiAKm1FaDGWqYTKn1TisO4-xNnvwm49C
X-Proofpoint-ORIG-GUID: uiAKm1FaDGWqYTKn1TisO4-xNnvwm49C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous timeout of 1ms was too short to handle some cases where the
core is reset just after the input clocks were started, which will
be introduced in an upcoming patch. Increase the timeout to 50ms. Also
simplify the reset timeout checking to use read_poll_timeout.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 90144ac7aee8..f950342f6467 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -496,7 +496,8 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 
 static int __axienet_device_reset(struct axienet_local *lp)
 {
-	u32 timeout;
+	u32 value;
+	int ret;
 
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
@@ -506,15 +507,13 @@ static int __axienet_device_reset(struct axienet_local *lp)
 	 * they both reset the entire DMA core, so only one needs to be used.
 	 */
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
-	timeout = DELAY_OF_ONE_MILLISEC;
-	while (axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET) &
-				XAXIDMA_CR_RESET_MASK) {
-		udelay(1);
-		if (--timeout == 0) {
-			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
-				   __func__);
-			return -ETIMEDOUT;
-		}
+	ret = read_poll_timeout(axienet_dma_in32, value,
+				!(value & XAXIDMA_CR_RESET_MASK),
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAXIDMA_TX_CR_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: DMA reset timeout!\n", __func__);
+		return ret;
 	}
 
 	return 0;
-- 
2.31.1

