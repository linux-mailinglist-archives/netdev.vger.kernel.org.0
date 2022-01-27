Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9295F49E8CA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiA0RVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:21:30 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:40513
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244507AbiA0RV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 12:21:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2d6lLeiOhBoRfQZqQUjgWKlFBCaDOjVdoUqDSm5eolUIeqK7Idixg4NxRMr6Ede0ziN6hvYtXCFJBCoNiefMHVSyp4UGoqmkJKjE6/zXkGs1XxqjN7YGmVxAlHPI1C5+dM5ujfaj0nMhjkGS0S3X6RfszdLKzyCTzuciMshlkXWjz49XQzBBf1qtyqEtyAvS33ZBSQNq/KC8eywwbIU+5wiuWe49WWvDjHkmo8wr78CwMU48dnIsAGgZnEejctjVLC77HJDv3oj1UPBp78RPINvZkCup1/1i/6hRLu8VLsCU9Ko77PuR/+tiwkeNMkoLX3/KAb0noahppd4LpH/fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQ3qK3JarodzvcSnvidKOjH+gH4kCCIp4vn6isIb1EA=;
 b=SfxUxrkMxmH22QQAYZ+teZ1W6oEH6aA0M2u/wZbMdnAbmkdp9Tc8fRIxBuwXfN+HQvGOSPv8bl3JTjR2ElgZfcVIWV34ahfYdnAhEGRZmeXu4P+atalHze/L1T15f//NdA5tQ4z0wSIkHeaei2u5ZllNMoajHglPJVkqRTs1lwnDChVD+o8MB+dSRiSz+wr7c+2IXanYEo9TOTtORR/nRKkPDf0RmyBpX03+VTqyZnEcn4Mk2sm1OC0rjoGevs+K84MMcyNS+bgeGjgZvMms/o2EoHokmPpar3zaTgfZ7cjUpZrUpXiAz56koKqSYF4l5Z370j7h45t/gMFrUMOU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQ3qK3JarodzvcSnvidKOjH+gH4kCCIp4vn6isIb1EA=;
 b=auX1QnI/vy51m6SSyfuoCCBPqlrnqUbFMBgqGxGTnwiTLk93SM5Zsodw3VAxvwIW+zn2B+fuehxwdXOfi+DQYCGzWJmJ9oVGP+h5cGo1YQBRWlB1pQIEL1pBa9508PjlvFceaF/haMIBUOLOaTyRmoYq98tl0xcn4btzuikuyPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB9017.eurprd04.prod.outlook.com (2603:10a6:10:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 17:21:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.015; Thu, 27 Jan 2022
 17:21:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] dt-bindings: mfd: add "fsl,ls1028a-qds-qixis-i2c" compatible to sl28cpld
Date:   Thu, 27 Jan 2022 19:21:04 +0200
Message-Id: <20220127172105.4085950-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29d44b01-4e06-4312-df3b-08d9e1b9720f
X-MS-TrafficTypeDiagnostic: DU2PR04MB9017:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB901700A47C310DFA682FFF4DE0219@DU2PR04MB9017.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3cqu4z4dpuD6KW1jKTsuHrVvmvfD7l1X2umR7U/lT4p77MtCzyyEhyp1a6IlO5IEkT4gaOIJMM8U+jJgPLcAcrLcCR5vMcAjJLfn1qsmjceglBuCC2KT5woRYQCdm/HTQVpWHb114kKjcRmXvSBc2pYwnbhLDW+gvGyR+J1gT1q6Sr5xKGBWJ/dfAShxtZZBnGS0DUV2/fsKZthCi/AlXfif3ecO+XPGKHLDiH8N1Q1zl9RmodE6Sn+xw40caYFhq3fvOQuQyKnopSQLaL4xq9Flc5Lm5H6QV+dfG6INm9Aej6zDNyRJCciY2SpzbTJg+AACDOkPitkBWG21Yb57hd5iZ4E2J0QQwgiD9gf4rfmOVgLbANC1f8SjuM+28BYQzqTDie7rEzE/FjcSBmZdapeHlHnKOkqqGj8FQ1f4239ZnEkL5mWAf9gjVAXkmE4v2PzeBcMUHomvuSudvX5C/bg9EwFclC091o7zcEhxAkepKtJnK8Vpj4WMYRS21kBw0IJedo+5UZagNwpRG9InlexHglCroeNTFbvZMnh/uQND02PWMlIVYiLFZcjvYehchCFdiMxEdmIhrhdvb5ZqU6G/DUS40GhCOEQAsQNxn2vaD1nSeJif4J74lTXSxEy6ZmE2AIoxKZ8Cg6HVOp9LpOZx1TcfGZT97kgaG1gyrfVtjREBgTQ9ZwmHdytU6HGEAQ31tC+ND+HZGWbY/UC8IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4744005)(38100700002)(83380400001)(6512007)(38350700002)(52116002)(186003)(66556008)(66946007)(1076003)(2616005)(6666004)(6506007)(26005)(66476007)(54906003)(44832011)(7416002)(4326008)(8936002)(5660300002)(8676002)(316002)(6486002)(110136005)(36756003)(508600001)(86362001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a95aHV346kgQD78gEqGy+Y9a9yeTuFlH/gBry5daoVVXvLwQ8XBSV+Q4c0oB?=
 =?us-ascii?Q?M7eTmstW8Jokjf9PyRriJL/+4xntaYNIT8RriaTlNzgjuSRPaIzsGO8YGqhn?=
 =?us-ascii?Q?NEVo717J5UPocsS+9HhPRJXZhiFJjB3mNXZPqots9do82nSnRQcKKqy4jQ6j?=
 =?us-ascii?Q?bj1A4Vz/960iAePNIaF3fzuJCWBM3mrcdObgO1cccApP7ylA2e/5FZ+esUXS?=
 =?us-ascii?Q?OUOoMqxLikx6DeaiSvpO1vUBocxuK7y8cUm4HS9H/emFvAeC96ZvZJgc3oK0?=
 =?us-ascii?Q?lQdLzuQzpXyKnv9L+HI00WbpVgECksFfelQSYfRyL8LeloCMGTYJphCk3sxm?=
 =?us-ascii?Q?HG1/NTlhDWunRyMm3rE6/o8AQmtq+LyRtYghiByZ5Jq84+tBjxcYbkH012Cw?=
 =?us-ascii?Q?ZAvAgbGcmq43cgMVv9bUpHgzHsrSEEmupvXH/NfEENE6zf3NYwE5SkRdTQtm?=
 =?us-ascii?Q?PY9c9PbT6dqyhxNf+cQIy+d4X3GfgraS06PoKUK4MHnu8wPNT8dB8T3MSdqV?=
 =?us-ascii?Q?m/sIfhoOas0lFOEhtT2ZFVLNT7E88OIndXyHhhIHLxxKZozF5OerZHqd5A+G?=
 =?us-ascii?Q?tJwlMaCc6JQGs3g3fqj24h70WaY6i6297gc2qI5L2ock46oT/IVFxGjZMJER?=
 =?us-ascii?Q?X2IZdaVeJc/oNqOmJSntC7swPCRf6+y6tdQlDKrsw/vSO2iBhB5X5M8pu4TV?=
 =?us-ascii?Q?GZ3Jq/nZ4UcPXnNDa4p5+yx6zULKNAKMBVF1T1cEF3gcDu2zP2VYUCXTLNlk?=
 =?us-ascii?Q?0XrO846oz2S3j8QDmHE9IA0gomnW+mOi8ypIksXXfiZYgyYC/Z6RZUqd/xlq?=
 =?us-ascii?Q?8VtoiN6yAvz5P/Gb8bdJqR/hJYcgfE76XdgKGuWmaKVLiGZUi7/+vTKT2tFU?=
 =?us-ascii?Q?fwJ1g81N+F+e+0mcyE3jqf4w7TweChzL+3QuxVssY8yhvaF2lh9XKlj+OZIp?=
 =?us-ascii?Q?IvEx8cuFbFHXAjHOUkxHIWZPF0Uvl0txut32OihKC89VJObjwfWHjiRWLKKQ?=
 =?us-ascii?Q?F/Kh4Eel3tA+0iiFDNK54epqQ0grSpmZwJnxNitQIRTtKOq4JHZ/RpAJOKO+?=
 =?us-ascii?Q?WCNqNW27Kr0BzltxNQOuENWUtvsowLIuJBMy9NbISlmZ+xvbIOKqLnLL3kGK?=
 =?us-ascii?Q?QoswjSqzbUI9h2/eJBneirfl33+NsLcmj3SVNl71mMaV5THblOGmvTe9uUvj?=
 =?us-ascii?Q?dmKWMmxtV3dzMX6S1cEgLAGE8uuDfq01LTvV+Oy8rgLC1MUtphRA8scxXe3f?=
 =?us-ascii?Q?xgW38dSb+eeWgCqbJB1JxrG5GU+a+GhR/1VKO8NM7uauVt6e/0E2SOqFlct2?=
 =?us-ascii?Q?eEM20srMKiwRR20QKlkK7PIucZef7tfvuHr4UtqyXvrOZxsbzvA+aoWFqkRD?=
 =?us-ascii?Q?rJewgGcR0ueKL0IWQo6NWmraM/BPLT4aNdxEUgcD3Fm33T80RRDXfd/Kn7JA?=
 =?us-ascii?Q?jXhybNbM2i3QaXAeKzjwn8q0Lc/79Ry4eCHk2paqNrTLoJ/OiAmnFz2EatKv?=
 =?us-ascii?Q?UieCF1lTG34TI5DIyS1CN48Y/lSRmSaBoPFQ+E2ohCd6xpbt5tG+7XI5M6Vx?=
 =?us-ascii?Q?ynwmP6tGEL44XIShrwtFQqz83NrFXKJBQ4vOYOBwPKYeH6faGNuewcglDv/6?=
 =?us-ascii?Q?6/4NToIAc+cBuLeyXlx1TCs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d44b01-4e06-4312-df3b-08d9e1b9720f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 17:21:25.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMO5mCHhFqA36ZFaQc+uCY6EI48xSIp0G/DBN3ZwsfdPmB3RWA8N2DYEa6neSsVsIqJOz9oOeNM2QkXw7ld14Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LS1028A-QDS QIXIS FPGA has no problem working with the
simple-mfd-i2c.c driver, so extend the list of compatible strings to
include that part.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
index eb3b43547cb6..8c1216eb36ee 100644
--- a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
+++ b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
@@ -16,7 +16,9 @@ description: |
 
 properties:
   compatible:
-    const: kontron,sl28cpld
+    enum:
+      - fsl,ls1028a-qds-qixis-i2c
+      - kontron,sl28cpld
 
   reg:
     description:
-- 
2.25.1

