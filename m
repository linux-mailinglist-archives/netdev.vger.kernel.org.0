Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECDE63A0F1
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiK1Fue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiK1FuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:50:13 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2087.outbound.protection.outlook.com [40.107.15.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D103F13F6C;
        Sun, 27 Nov 2022 21:50:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AT4CsmJTvzA6XlFHD45EuTi8+htFW6f4OreuHd5hM0NX641QHtMtAhMy0vS0TgCmFPgA/QfQasR2ckXPCVXvEul/+vsVbMlFrtGDNJ9qLVdH4bPFuIKcSCSDpvTSud9nAZEghnXEZrkWgtrE7sljYUlHAzov+fcKkwUlzJC7p3cfcE4VTbJ3K3vqTJZi8iF+dZJ83yUnKuiierPWb39cnTEbgL+z2FuUwcu1idZrmkwFxd5h5wX06TfdTIC/dEUAS3GjLN5+eDfzJT6EpFPTQzMQ2usBwCXERTsEhlOPBA5Yzy5vCrKpDAQ5zO7/jBPc/gOqN8XwzgbDwLJ3GLEh+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wajpRa4Qc6kFuPthEyUrYcTrYe+ifTJ1u2fYtSyGHyg=;
 b=eLl4F8fjWeAJAuGs0QGeV12pxZRdmc9dY+GQg1Pmt+IcB6ZA5NzYHgI6ElfIus+ZkhdndNi3t5JWK23Ae3dA+TZbYdeN0zEym4QCVLvNCnpT0cDt1qT4bCeB8eMZLXfc9zM9PX5mD3IbuHB3vtPsccQbYl6lfQyxeL5YZ7pe7WmNKvL1XxFMh0KDh91dSDwcp+EC7Kc7n1E2FY1piNXWqsyNwySeP3LsD8lOM8U+iTrj06spPaWwNHfTN/R8o7lXvHxRMgazNNYe2w0YAtoIJ9qQYu55JQXn26MjltJT2ldaB1GEJMhc8Y+poaZigdNy+uk+bBfaKE3gMZH/X5RhUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wajpRa4Qc6kFuPthEyUrYcTrYe+ifTJ1u2fYtSyGHyg=;
 b=ltSqnC9qRsbolxXrEaz1mnJ4bs3fnY9kx3I4xaCYEqfcqA6I00Rr7Y+DoXmd1XIP7w/aemlROU1Ddsoiksm1FkN3iEZb5db36liLExs7J9e5MfdmoomqW/diAkZKbIDHYbhQqm7AsHNPW8AF00aGIICaP6elWB5oLsQMmwba0zUpXbPA8/qDk59kxfKbKrIWIJdSk7dSnalsCM61HfhAXKgLPCWhn1FL+THI67V3NadpAQd4WN5MnMkqI+JlaWhN7HZtCrjBw4XN9bdUstnP8hgTtxSntFFZ/a6WCk58FhTO1B77arV0pf+ZSXM71huZsxTVwgFG7OCeyVl1o5x4+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AS8PR04MB7655.eurprd04.prod.outlook.com (2603:10a6:20b:292::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Mon, 28 Nov
 2022 05:50:00 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 05:49:59 +0000
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
Subject: [PATCH v2 3/5] net: stmmac: Add CSR clock 500Mhz/800Mhz support
Date:   Mon, 28 Nov 2022 13:49:18 +0800
Message-Id: <20221128054920.2113-4-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221128054920.2113-1-clin@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0140.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::14) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AS8PR04MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: 6816db6f-9985-47ab-34fb-08dad10462e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0hgLt4fm3GPA2dgvwTafcAYBBvc5aMsSTvtddOYAdzNTqwFBMlo3MEPYUfBRbybS0fIQG7MkV7XAiSQb6Bk/j0O+wu0aVJNcCBnD6/oYNPe0+rBZVFdsZjPFxg6PwMW5lKdS812tSGDm4fwV73e7VDDHIjQY3cE1tsOxUeZp6pPKh8RlIZRNckXkuRtU4miYligHnhaDwHstPbTvBMWRxYL1EzJu9gKakKIYG6D++vI/xMDwdSuOyK2XkT5UiDaFFGXBEDYK5QsfwZq+HiN4oGu9JEs3plA/az7j/HLi5r25y4v3jrnNmSrozQQBoc/KKifogOUJftrt5VoksyE9zJq+ZoP4zSSTlC3LCORhkD0G3M43hrjGhIUQnISJkDqJ9NaJDcV5n7ACqseKG/8SaDLVTuo3zXfe85XHKzgZTs7hgU5HkdevesSHytR2dNI93HC6O6L7BpeFNXdgYZp3be9zKjOypCqG+nuck2okiH/DKeZj2pI55Ra47PvVK0v22IhQOtQiNEFTaQuLp7Zb8s8iNlU4UZc73NYYf2NdEkCN7TxI5EoC8oas8cJAXcmxas1XKRO5+XLU5pZ6UPzBi771LsF5OAG6mgkN0/ODk6HoNW4HpY6iKSOf8QLhLnubhhW9aByOap7cHHa8Rc2zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(2616005)(6506007)(6512007)(36756003)(7416002)(1076003)(186003)(5660300002)(54906003)(86362001)(110136005)(66476007)(8676002)(4326008)(66946007)(66556008)(2906002)(41300700001)(38100700002)(316002)(83380400001)(8936002)(478600001)(6486002)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HST9Y8B9d+fq1D1c1KxS5gzzMpmBJFWyC6480mDF/dBhEJAxwm9X0hIn690G?=
 =?us-ascii?Q?QUqJwLy0saJpqDXV1b5U1ROLS/N3jaqFZVmJDNb+q4/X6DYeXLg69zgf6d04?=
 =?us-ascii?Q?slgfTceNDQxueWOqozKar082wjYsKZ49DY1YzNy8z62XM7Y+sjM3qh6SfCmz?=
 =?us-ascii?Q?1EpnTJl45w3w2jGzUZFBo3m9qsWUrvB11Yi3Ty9cdhGp+XhnRM3118J5c13I?=
 =?us-ascii?Q?xbux+W8sMiJvznl63UzcPjmODwqx/9h5Bdu9TZBafMpRRYlzGoPkpp67R8WW?=
 =?us-ascii?Q?F9kKyhgHmoNFfLHwVgS2mPHhxn8M96FEzKGva3xs0WxCgmeEaGm0ieSYEUgv?=
 =?us-ascii?Q?s+2cOgEYtK8BTswmlaHbx41F/6ccT1fiKYHAjbsN0JW/kgz4urxtExR2lwE8?=
 =?us-ascii?Q?6UqxTVmGwg3Yj2OjEs5P2etVIx1AQp1aG+7bDa+spT1OPFeJalh0QTzfWE3h?=
 =?us-ascii?Q?zLDIH53282BoeI7MkLPe8xR67Fvb5GQ0Nw9pKOea9joD8d2PJNo66A/I+kcZ?=
 =?us-ascii?Q?MNF99sIlAscuEI61GnnBt1OPBXOHc+B/jI0wrI19DRqHo9Xvkcxs8BHZRLVW?=
 =?us-ascii?Q?pjDNwzzn9YSqtStjFfSf/fdKyiMapNvzHqoX0bikPtg8pzlxLMnFyaEghHg5?=
 =?us-ascii?Q?eNYTGtMjLjsSFzN/KKsyNmQXn++NIvV3ianVTfwjABujifM97GLJ34Z9l9Os?=
 =?us-ascii?Q?k7whiQny6qa08kTFFgj+S8L6t2apXeAU92AabDsL1o9Qqm/pYVc80RoZmBLr?=
 =?us-ascii?Q?KClR2/S5oqL545WBOBiRzWAfv7PHu8xttdrHhL1x3547nT/elITnkYxH6nsd?=
 =?us-ascii?Q?DfAe/fe6nufTBkLN7Nb/KNIaP1wJ0LDhsJt69UCLO2M7YZ6dikdz2S1/pwaQ?=
 =?us-ascii?Q?Nug1DiT5osWptaci+zQ+jsze7lFK6pRdy+Aim6JWeW7WD5SoCYRAXdEbwlOr?=
 =?us-ascii?Q?ERC8VKAl4cxW16Lz/xgob2ZEI+DA6MBcfl8DWQ7t0W72+SC78RMm+4A07JIo?=
 =?us-ascii?Q?NOzSAlas+xmR5w/AOMdumC8T67keIOlxBontWDDQRI6lOOJ+Z0MdMXW78lJU?=
 =?us-ascii?Q?1O6RLC6k+CpEaIVsmdTkLR3WzXRSSp2TUI7L5R2NwV5ayE/lKRkfbRq8FUCh?=
 =?us-ascii?Q?I/5aGdS8QTpOYY91JtjKHsaU4enWu7EClVZpv3eGGK00joaRPJnMmLlCBEr7?=
 =?us-ascii?Q?kQ0KWuuBKlZ96EvFVSYokseTsl31KlRD0zJ3x/+SdB/RDKIq2f6ejbegEKAA?=
 =?us-ascii?Q?i+aFDpP4gkPBQvJlq60uFKLcS94GqiA8k66sKoSwy8lPkvrlrlEsfrXTNQfw?=
 =?us-ascii?Q?wt1MMby5TKjIyyLkS3W0Xmnm8lThHUq4gBaEXCP+mld23OpwXwefr1uvI8ss?=
 =?us-ascii?Q?Wy88cSE3vecgLOZ7/6/gHC8ttH/0QM6mvJErqGd27vuhi8tJUpHHOrUy6aA4?=
 =?us-ascii?Q?Evn/pG6ZI75cufHxpifbSoutPwUNLT5zxq8FR9xrzfu1nicUasJH9KbV7l6U?=
 =?us-ascii?Q?BoG0E6JQjyWvPL6rKogZvMrMHXPWDsAA1FkAcS2pDNW+AL7GoSMvGrcG5IX0?=
 =?us-ascii?Q?+VtHTxoHEeXM+Km7UBi8/c16n3+E6tipo48z8GHfPj8EiuQ2HiXxqFEzk3+j?=
 =?us-ascii?Q?Ky8zsSktCfI6fiHCiPI0YlgUz7mU+3PeYy8zG6BoY99Y?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6816db6f-9985-47ab-34fb-08dad10462e2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 05:49:59.9006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NbwEZ+JTQZbPnBlN4yQ7LdtGzdj6fnGC7/isGZQzWhdCMWwhREPvm6ZIG3HtuJP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7655
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

No change in v2.

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
index 6b43da78cdf0..ff0b32c9e748 100644
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

