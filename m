Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC88A61335A
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJaKMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiJaKLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:11:47 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E335EDF9A;
        Mon, 31 Oct 2022 03:11:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz7Lq7txrg5/83/qHs3Nsh2dVJGb2GI2lS2krtZHKWPrEI2RPWVAxAOYbkjjqYj4IjaQOuCtbkGybzuPBapGB8xqwvVRFScnXmrHJA6KMNNkB8pVDgZ518gPh1mstDYzZcdxbJx2Ogw0kP37Pudl1sqG9PaTw+x5iqLq/mGyGYc6WosYXcK2bmhOsGpaJB8BP4QNS72T95dOR2qb459wML1Dbl2dWze6cmZmMHDaVz1uFE8KHEUkANSaE/idIsf9aHuf4aqCWId6g14oi2mG1MgFYKV9N9rV0mPEZOqpO6Ff6qtXHSlRukLFAuAtSBuf46G8lCFCnfY0S1v2aCOJhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YrepXqukp2z8UFC9LnQrHM7bZLD01uO3QasyQDVHME=;
 b=Z1AoU1hCXXXIT+88JBzrWGN4KrP7EH15DC+g+4F9Lsj3osiND1JWyi5R+1jYQF/gLbW4HJHNMpNC1G7c39crymTS2D2Lmv5Jxsx2aKy5/1sVPqnWgh/VNsfkmqaj972ZjWw8D2BPguiRZhchncNhKByn7aRg9+eWMPILR5iX0u79GvlR1upp1Vo2+gnb4Pvn2U9RoBsH8dOtwRkYeMqByJGyzLBj3a3BEdDs5yMPpS4lmLDM1kS3KmXoW1yAnwapgBYNLz1bVyWa1Gzh4KRt2EM8+jUgw5ne2wTxg6F5e8Z2nDZRDK8GUfLTgU/sLjj2ztrMs2Sp6Wu48gIhKZUooQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YrepXqukp2z8UFC9LnQrHM7bZLD01uO3QasyQDVHME=;
 b=IP0gVQwvVnVnvJN53wBbkx1OaolcSlW/WVWxLmd0TgNKmhG+a8kwfZFkjTbt7/XSkuzEVsA4i/tsmbFYA6lGmFLSa+fRosR9017sU/WvjyBTKwVMFLi2NU3mVtU2KvYT4PoLOI5WcwOS4xK2BQwvNI+dEV3TPq0fv9v4t7jRSdB6XI2qSQL+RPnlyQzRVhKMkWmIQjpBtG6fkCBJOJC3B2EdAaxuxuMSX0Z3+XxNQKcg8SgNxoztnlufWydCuhkrFpWZhGfI8wWf1s13VhXSj8zyTvtWc+WYhKO/yVCBkz7SzZr/SWziCyK2N68kP1sE9XNAPbgTesljCKcUlG1wsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by VE1PR04MB7261.eurprd04.prod.outlook.com (2603:10a6:800:1a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 10:11:38 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963%7]) with mapi id 15.20.5746.028; Mon, 31 Oct 2022
 10:11:38 +0000
From:   Chester Lin <clin@suse.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Petrous <jan.petrous@nxp.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 3/5] net: stmmac: Add CSR clock 500Mhz/800Mhz support
Date:   Mon, 31 Oct 2022 18:10:50 +0800
Message-Id: <20221031101052.14956-4-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031101052.14956-1-clin@suse.com>
References: <20221031101052.14956-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0205.jpnprd01.prod.outlook.com
 (2603:1096:404:29::25) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|VE1PR04MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 931a5415-bd00-4a43-e811-08dabb284c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JsKlPQ+7NgaZHfo+WcS2Hfc7GFEi75LJOIwfj89Ku3451ph0Ti9vJnwqCI0eEpbfF7uhOeZ4Y8Tk/cvX3Rvgq9KdxmZqgvCP6Y3OUUrhujgIc3XmwFRCwaWOLkO1mXVCfFrZYcS8OQYoBcoS77/4c6yFbTRjU8Unox3K45HeYyVmGaQfvJ4LJj92Y+PhBhqQrrXv3dAIPxpieZI18dWXMSoBCIfEUUXVh5LZkm7zmibzZwXLBEGTRyMcqXihs7GRCYBJQ1ZwmxY2SYkHu/KhXeMl74BDAhuHqQeqX1Eouk51fervNajicxgx0bsqJ4M2unrzUldbbm8MPPahYM9go66z5ATQBwUMEw3h2NFvJd3/wkwbUuns55Ulpe43+5EM8jq1Lj/ANFCv76hPzXhoqkDhisUGF8SAZRxOqzLqODYQ04dMDwzvlQeQMqZNaV/E5ImbljzjZMGU3fEv0jYBLd89rQHuplJmIpjpknCh9UE397fGA9GP13T1KcPl6m+7y4+OL4MrNObEwNUjsOFPZPCfhHZlpGiYYz2FAKQKZcggfq2MDyv9DjsL+1A93wAWTny9VhJScTvVFZko5r6n63DD2/W/9QSiLZyxtyAHmSK8QEN/hzDv4pdG8sgVips+Q6YazlBgrxWoQ68X2ttdeeGKExGwMib5EzcrkELoHBG1Phm8GB9UrgUsd0RyEi1tTsHizWImVMgFbBRZ9AC6Ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39850400004)(376002)(366004)(346002)(451199015)(6486002)(107886003)(478600001)(110136005)(54906003)(316002)(6666004)(86362001)(8676002)(6506007)(4326008)(66476007)(66946007)(66556008)(2906002)(26005)(38100700002)(41300700001)(6512007)(2616005)(186003)(1076003)(83380400001)(8936002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SxAQujihSr3y4d0bRb4dpAzpxXkHywLWzEoSu+UVtDV388Xr7fp+Yycw7Nhg?=
 =?us-ascii?Q?SlVBW/z3e8HGF6N0ca7GxzQyflloUJigSB3q7EjariWS/743/oPdVxYO1GKa?=
 =?us-ascii?Q?50D19chyFIQEnfBs3WzUVX6avHB9WfTeTVC48AZCzL0o7CZFQOrtfgb8Jg5k?=
 =?us-ascii?Q?VdBIixk81KSrhNq3IH69adogphlwMczeBpyEMyNd5D6qC2zgWBlNYTmIaXW1?=
 =?us-ascii?Q?MXMnj5zY+dvSbGmLmAUtL2S12jZIctmLvnBUjxLYvfeNbGPVl3bUjP2t3Nh9?=
 =?us-ascii?Q?3AFPL+yWNjwCdP0Wgr3lLJMxfRf+JeD8FI98/Ikk0lmySweoETDswVsQBLxo?=
 =?us-ascii?Q?JqrI2SLP9VPv7SFP6jOZVECxNn5dJxJjYiadVJm9KNlqFukGMEVtlOKA5yoz?=
 =?us-ascii?Q?mePQpup7HFcqWC8eYUI2v0JRwQhj5QpDuepOSBtp5ZRM/xpCLDF8Ztb7ky3f?=
 =?us-ascii?Q?59QZdbSVs75bkvAW8KWeJPmpTPbsdWlPIm+/iSXoFytnzSEDXQKlPk5I65aV?=
 =?us-ascii?Q?HjpzSRBGvmkxrQl/FoX+A1EJQjRGjjwvpXZwDgF7mGwAksigTlXAgw23qx+q?=
 =?us-ascii?Q?00jKQWTlLX3i6XOi73rorXZ5KVbp0ulOZwt7dux1TsgNsJVPd9V+w/PpVy+Y?=
 =?us-ascii?Q?Wkp47AWf+lrpLMayLm8fQFbm7tJY0wceRgbRvKpY8zJ1dijkSpakQ3qnd+I4?=
 =?us-ascii?Q?p36jKg1i8qXCFW5xIA2MEVUvmqE/1f/z66YmKpzmYGQpjp1C5GSx31DJGuX2?=
 =?us-ascii?Q?FNnwrVyfwIfdG2LlDsOEOxS/ynLfTSwuUr9jO8aV/cEuZmCvU4cBU1WKw5lc?=
 =?us-ascii?Q?Qi0iPlrNrbRiT1jnHCJtcOslrJoTlStfjPke9HKj77eSqpHBT4fU8GiYDthN?=
 =?us-ascii?Q?xRVsRebBWVypn3BkYPUlm7HokkfhL7QXLVU9Twx2/jnvjI2w/rSgw1XaWKDH?=
 =?us-ascii?Q?Zpwa69I9SPUlUn9n/pIoYuPZ1vAt3xGoK3j/NretALAqF3Bwu529TA8PHfDK?=
 =?us-ascii?Q?lAGE96Bs1TmmdPWU6qc8jlEP+QUlCsOA9dVe1tbG133tm2hEvIdjOUDpog0K?=
 =?us-ascii?Q?r+Ohyvxcm3i7HG1UF5sWy4svx7Bi1jG2t6Buks1Epw0O1oyVnrNE5WYOpt4D?=
 =?us-ascii?Q?CzuLLFr9K1v6UW5OUGbs3UlJ8IL2N+4DC3BzxpOGRS4xn1SrkxOn3lx7IcWK?=
 =?us-ascii?Q?rXzztq5aXIDzx70V9koZp9t+fKKlpchDuxU3zesTGKVRWM8Y9QyWxHjSY6+K?=
 =?us-ascii?Q?LpnQPInxZoYVAKcwGiLJBSnHM/E3jgThGpt/MjdTjTtHX7Jq9MDRFErb9wIv?=
 =?us-ascii?Q?ElswsMZPn58nSt1Jt8Z7PMeAM/7NebWWFbuO7MRtWh2y/AOzKVwd3px0eRzs?=
 =?us-ascii?Q?xDc8XoR3iIbFOdBTZNZUAN6+Ol7I1/pKTebbYirXnMJXd0Fkwd6EB4gMN08b?=
 =?us-ascii?Q?efWdvTINm75dgZKBZGP5XyDnpt5u07DgwxSmZEhctI7ydv1CJgxkkKg+sM/Z?=
 =?us-ascii?Q?10CGVSlGi/kpW5r9FItK9o1nJQWTri9aZm+ugNixLbC8UXmGKF++H87TJPWC?=
 =?us-ascii?Q?zRgVCoy0tkG+V1bmvQI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 931a5415-bd00-4a43-e811-08dabb284c66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:11:38.2182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5CDPJHQyexQOBKv57FhsTQgkAFkKGEXWnLPX4cKl2xZkisuEIZcSLcTz+36Knhl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add additional 500Mhz/800Mhz CSR clock ranges since NXP S32CC DWMAC can
support higher frequencies.

Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
Signed-off-by: Chester Lin <clin@suse.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 include/linux/stmmac.h                            | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6b5d96bced47..5b7e8cc70439 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -222,6 +222,8 @@ struct stmmac_safety_stats {
 #define CSR_F_150M	150000000
 #define CSR_F_250M	250000000
 #define CSR_F_300M	300000000
+#define CSR_F_500M	500000000
+#define CSR_F_800M	800000000
 
 #define	MAC_CSR_H_FRQ_MASK	0x20
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8273e6a175c8..68ac3680c04e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -323,6 +323,10 @@ static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 			priv->clk_csr = STMMAC_CSR_150_250M;
 		else if ((clk_rate >= CSR_F_250M) && (clk_rate <= CSR_F_300M))
 			priv->clk_csr = STMMAC_CSR_250_300M;
+		else if ((clk_rate >= CSR_F_300M) && (clk_rate < CSR_F_500M))
+			priv->clk_csr = STMMAC_CSR_300_500M;
+		else if ((clk_rate >= CSR_F_500M) && (clk_rate < CSR_F_800M))
+			priv->clk_csr = STMMAC_CSR_500_800M;
 	}
 
 	if (priv->plat->has_sun8i) {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fb2e88614f5d..307980c808f7 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -34,6 +34,8 @@
 #define	STMMAC_CSR_35_60M	0x3	/* MDC = clk_scr_i/26 */
 #define	STMMAC_CSR_150_250M	0x4	/* MDC = clk_scr_i/102 */
 #define	STMMAC_CSR_250_300M	0x5	/* MDC = clk_scr_i/122 */
+#define	STMMAC_CSR_300_500M	0x6	/* MDC = clk_scr_i/204 */
+#define	STMMAC_CSR_500_800M	0x7	/* MDC = clk_scr_i/324 */
 
 /* MTL algorithms identifiers */
 #define MTL_TX_ALGORITHM_WRR	0x0
-- 
2.37.3

