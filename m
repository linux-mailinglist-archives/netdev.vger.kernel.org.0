Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E122F2E15
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbhALLf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:59 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:58496
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729394AbhALLf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inHBxK/81ZGsg3u2xiJk+jybvBNq1iBwhi/r0tkS260wSTMNeZRSL1RSLO4XN9DuqG/Y8e4JOiryFNh+CJfgJr56GWpW49Sq/AQs4wfM9EdW2+hQsw5/SfkMn//So4F077R05muo9Wg70tuTcEftM6bQFCNcxXaPbvpv3atqxFJm49SvNTojTMz/kOJY2tMOGZqqIF/+nJ6mltJG9WDHGBfMrFV3ZBVeLnMsAcf7HOH+eHB6ADNHk1GnUrcpYjjUJ+aQwQRP4WZuVgASAF5p+RZXn0fiMBhK3nQxigfaUQkAbV2gJgwq1MYAi0EYAxxf2KTN0tYetpYp2Bb4ZhzShA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9r6dKSKW1j+iBWzl2PCLcSJ6KMA1wn770lhsALV4Iw=;
 b=EkWx52pPbRTtS1VTkYg5PtrGSzfx1KPz97Yw5kmqusgPLvyK+c86wIlBxG/dGfsibcgkQj0u6sEBQ6N+i6ATSqicx2hLvqby0BE9HB6q2Dlz8UvQRNBRh1n1oxTdYkJC7i8vvPj1eiZ+JQD2PK+6QpXKYz5XmyLRVNEeMkPE9KM/cuz7cZI05sq9N9T179TiXQsBPdibJzg6C43nTd2ld3+9ZFJrRtoHfEiLQrLLuQ8S5zEkv/ziWWi/3j09Oe+zwYrEGilDdmm5+ECUFAIgpX9iloZiy0G9TqfDe9LqE2xqHpr7q5+Dfb8ug6e54TuZJyjjijAC5lmioEcoFYdsCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9r6dKSKW1j+iBWzl2PCLcSJ6KMA1wn770lhsALV4Iw=;
 b=TPrySEShejHAQrOwxsxfDDx8KmoO7vf0Q4ynKTNjS/xupLc53EZO9cAZOj3fm15EHG5cqpOzCnBQWAO0UVsevH/onTWclj1ghMnlCtxxdlZDpceKVAaeNIM/oY3+RTbxLW7aHoebxPYCNfywX61GetsxVRU7ipRZHCkXNySVw/k=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 11:34:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 1/6] net: stmmac: remove redundant null check for ptp clock
Date:   Tue, 12 Jan 2021 19:33:40 +0800
Message-Id: <20210112113345.12937-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3472918c-62da-46d5-3498-08d8b6edfd50
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB613991BF5E45F174BC46330EE6AA0@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FshZlAaUmVqUfO4xyxH/YMfkt64uBSm1p1XLk6GrWonz9dgWh021WoZFvW9kxgIS/OSHdBPM9qZqTNgVJbOvNRHEZ1KXPDuRqNnZwC12LOKSZ1q1s7nSOgwFfjqoRveZ1PMexiXVmIi6qi+VHd3tHxdMCHqrE6rNTDbGo4xPSgNyBOOoZf6Xi2r+eHDhNuj28eGTNuEcgQrpzyT31hCteSHWEwuf2ntnW728SHmiz7Oqv+27ByZerp9hcNqUB0371jDyJ3aolQA9U6qG7KmpVxz07b/qbuv/WBICok+m4T3oi2hbt79rMXOSuiC+sq6pvAJ5JL7vUuPvtWaHidW/oWTM9C4RyvjCSVBn8+1jHFrVr7FlrWf0BQxd1NTA5O4bfRsQjxMtiRoXrRuK1zTm7EdrtWs5rSn+fRpBpatxcs8sRu2pFwT4rdY+gxY+SIOc0cdLchMNGPgSTbT4W9iO8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(69590400011)(66946007)(8936002)(26005)(8676002)(6666004)(66556008)(66476007)(1076003)(186003)(2616005)(6506007)(498600001)(83380400001)(6512007)(16526019)(956004)(2906002)(86362001)(36756003)(6486002)(4326008)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DWoqU/CFIFXDr3wmYOhxn5ybkeDKZwLQc+IcrKjlGqmeUXKbjynmOkBM/ttJ?=
 =?us-ascii?Q?gJBVxsN5YhbGTOa6dbnMBZ5mkLO+K5qes8xoiZc9VT9+SP8pwN4TGHACgd+T?=
 =?us-ascii?Q?nuVuxvIfQ1WLX5OxgvNLxP+Mjk3m78CrfhUI+8qS00RtqyeEG7px1IJMP2tN?=
 =?us-ascii?Q?/dZRY+/qlCYoOMwQowNQKzkBdTRtaOVcM4VfHddI3gQUqEeykgm5e1EkMqVH?=
 =?us-ascii?Q?iGfvjyMMwBEjRu7ZvDtXR42jjnMj3O3fngTiD823VUzwyFYXnS8YJZ7U8ccm?=
 =?us-ascii?Q?HPgpkn+q+TmRFD5GYt2hHU8DKFh9v32T1/LFg+W/YT0LryR0LLebz2sdoEJh?=
 =?us-ascii?Q?xhmKMechPmOf2B2G6AKMMEXbzoFE3NIN7Bg++KpZ33KFKbXxAgJqSJSO/PsD?=
 =?us-ascii?Q?Go9WB2PlSe1XnFV0EDOvluzl7pXnmvqinm+OVuUvxWLgpgZUqYpVpBIgIJ4H?=
 =?us-ascii?Q?ZnimopjRaus0Sn0EtAumHdnkgk4HvgT5iikx/ebZUZ/oWzMtN7dT1qlCYhwG?=
 =?us-ascii?Q?ZQ150ck9pA7FdDmLbOtzRpSc95eMIyxO9cbe+Kx7OicoJ6+NaMR4O08KspMD?=
 =?us-ascii?Q?bIChvxpnBPAiCN/MPq3FnmYM5hSOU2XWplNHIiiK8lsWiAHFCZ/PO/1+n51L?=
 =?us-ascii?Q?CmH2uSto7eW0e6tW0vWH33vkJssumauP6k4Os1WdcMQRNacv0Sp1ku72+KGj?=
 =?us-ascii?Q?g35Z38PwX92uNwey0FxurLKL4HdwPTVYG17szCgj+PWQtkUNLhPKVFTgFsy7?=
 =?us-ascii?Q?MB/cVPcGRtxLhoFrDT45pvJqvf3XYlFl8QaVrn+DgSu26zo/3Nb4rdvRLRTB?=
 =?us-ascii?Q?swSTLMrWSzzJmnySb5LWvdGDvvb5BQzvxfVm05JkN8J0J3shppqjRYrrfKFx?=
 =?us-ascii?Q?sJ3NEaeuG8sVMbKmHRDDMH05OWQoEYfx076AmEu/jmkjGRCAc1j4VNg+dl5n?=
 =?us-ascii?Q?6dlSIfm/Qkw3ICwPzcGyaK7We1EzLVWqwaHzXtRaQABBVmHnYvfUVVoy4bvV?=
 =?us-ascii?Q?cxo6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:14.5564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 3472918c-62da-46d5-3498-08d8b6edfd50
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RX1/TVnZbsublR3igAYSKQGQqUBj8NkNMICZRho3sakjJ72FNCw4YsU9Kijn7AwE9443RH57jihbXkMh+CKtVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant null check for ptp clock.

Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5b1c12ff98c0..a0bd064a8421 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5290,8 +5290,7 @@ int stmmac_resume(struct device *dev)
 		/* enable the clk previously disabled */
 		clk_prepare_enable(priv->plat->stmmac_clk);
 		clk_prepare_enable(priv->plat->pclk);
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
-- 
2.17.1

