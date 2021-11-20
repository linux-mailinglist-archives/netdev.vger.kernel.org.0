Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307E6457DB5
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhKTMCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:02:36 -0500
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:40930
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237208AbhKTMCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:02:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+i/WSJWrUiJAOYLBBH2n5fIUszn/spUq5g2BeqE6MJL55w/zHi9dd4G+GcJsVGzipcaGQRGFPhEaHfyOW5+CcOTc+1Vbrn2yNiqgfI+rZ+nT/d9VbH4Ge6rZFZUeOYtW/RpEJOLIpAM9qne7kfurOghXh3wLUJao/mmZo9iTv+6oh4EFnKeUqXp95f0ji/r9dRBbFbwy4+vhhX5ZXGUb7yztdG3T0repJcHOE3m1/qWxMmrXQXWfMfbipF859ir0JROEaJvMy8n+fzIoC5H7sk0hL6nSjlvEKddDX5rOmWJ+a+7fbG75wcadPC8iFpIPGNSMesHWdNE9gYX1FriaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJ0ATxEarOs4VaeyRh8EvWZKyr/WFNJgn9BI5OmaG1o=;
 b=FKQGupIF9/DZak/7AQXpXzuxWXh9kYwN5RJ6RVVUcC1Y/kFTo0+vpqGvfV/n6Z1gkupXlLsp0I6GWJIbQG3tnNK/vh4j+FlKaMhe5/63g056M0I066w2ggoVPa1KOdC2XBehORA7Bj6BkQ+7mwDQa843wbLMi++23U7Q91mBD2kjkoqGFaMHCZsRzc//4oOl6dbrtpIwpnHi6MBTIA58FvYSw5ML2pTr5d6X5V9fMzfuGJHyvl+h34jUZer8ZvGCxW0szWryNMj5Uq9eKu3KoHBB4HyU7lw8XJHbekIJ6eUd7AJirksUbr/Si+xoOJr2O4z3f+thdMwjURtlzJsZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJ0ATxEarOs4VaeyRh8EvWZKyr/WFNJgn9BI5OmaG1o=;
 b=fRtr68+j+FJltAH3ccQZ8/ZkBLHOnNZQzrr4tqRnti1PvnSpvElwPL4atlKhTrfSmZdmxGFRoxsFpzpWHwmmBnHNP0VI4B+S9vJAVwe55+iktlzuOgkVRVuawnA4lYs3g77r4aKoBXX3lEf1a9Nn3BuasGZEAFdvaXtr1aVCqo8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU2PR04MB9082.eurprd04.prod.outlook.com (2603:10a6:10:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sat, 20 Nov
 2021 11:59:27 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4669.016; Sat, 20 Nov 2021
 11:59:27 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     robh+dt@kernel.org, aisheng.dong@nxp.com, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 2/4] dt-bindings: net: fec: Add imx8ulp compatible string
Date:   Sat, 20 Nov 2021 19:58:23 +0800
Message-Id: <20211120115825.851798-3-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211120115825.851798-1-peng.fan@oss.nxp.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SI2PR04CA0012.apcprd04.prod.outlook.com (2603:1096:4:197::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 11:59:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 953e0fab-65a3-40de-40b5-08d9ac1d336c
X-MS-TrafficTypeDiagnostic: DU2PR04MB9082:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB908294F195AA2D95B93B747CC99D9@DU2PR04MB9082.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MrvUOX17vePoUUQNPIh/mwIJY3jFaO5b/bOJXsXwhveInXWSSXJ43CKksrsFw6Qdfnb9jtBtVNjoZDXGDm9xaqhdi9MPgxHUmBxRrYaNzaKGMp+MpGicUa4f/w5rae2qMAEhQmFj29Wn7AfJTkm6LwwHPjyTYTzmUlKzaYXd3VSEtFu96sGGprCRP09rivRHbRZ5d+iIWnlo8q1T0v1ZB7ZG1XDTpBxDTcm83Yf8KWYdXEA06xzrrmCtGBAYc0HjC+dMxK2ZkjmRofchm5jnsNMMvWKW4vEGx2MuMmxUMWeLO+iiKW5KhCub1UJXki1VsMOtVjICdLwegMieg+TVARgbpRIid6rlpNmzHDLFYQeT3K6DFjlcgVbQTChRy0WOhyBCtWmKyxoMmh5rtpF2+qGsMyEtQfFyxAKSev6BoqVw7b1a+Wr1AK0V6sD3zr3GA4rjMszYHP6T8RmgCDqdnSqFI82gE9Ki0NuvjG7H8AyFg9j2IiIBix++R0CJuT2vMeb3mPf589W8AbFpweSe4QqQi6qFHeDRwLHZZprjlXWhaLFXrjmFUIIHnY/OL+xTKiIuZqQR1939Jst6FeS3vyUHJig0Wq7Vl1hhFO5uGXymEUJB27DDPuih2lAsxWHiNOV8Eo1Jo4FCjLLBnd0O/qOXh2iiLT7reR56qu+YqEwbdrMvOHKTQPxpy/XLzn+sRmNjOMRZHFJhLN7VVcczHgKzuYnyyq3MUaT3W1otZq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6486002)(83380400001)(4326008)(5660300002)(7416002)(66556008)(8936002)(52116002)(2906002)(86362001)(66946007)(4744005)(1076003)(316002)(956004)(186003)(6506007)(2616005)(26005)(38350700002)(6512007)(8676002)(508600001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NZcNH7PWDaQ8TIemrSaRvFx40GNL9/MMcgo5zFY30mnR3i8Nzm86oX5yCr3r?=
 =?us-ascii?Q?qK8fChRIg8WjVPxSLQRIdirqRPDGMns/Ki+XDIiOtxvUf0/Kq18fFe9APC0B?=
 =?us-ascii?Q?xNgrTJBXla3kf1RUEjW8Eg5mhb7j+VndsC0a0yqGbzRjQXppF8zJ+m59S7u1?=
 =?us-ascii?Q?Caow1GVgK8Ed5bL+Br/vY3JvxlCVrDzk/2pq1KAaPUizG8QnTXszK0usG/ay?=
 =?us-ascii?Q?g2KRd1Nee1zVK0AzMgJ++qUUGH+/yEXOewyFRyjjOwJsw+jF6JZYaKRs+r3H?=
 =?us-ascii?Q?0DbijdOJG0FIJFcD03nW77ARldD9WCHi0WzK+zCVQwC5GrkSxTYXb1TbaEGp?=
 =?us-ascii?Q?g95WXxXoTNsDEPrQKaJCYvXk8s3dCxP48nR/B9hjzktOq76tG9C2ZcYID93b?=
 =?us-ascii?Q?Bv+0Rp1OAoHZDQa0/fFE8+10Vj3CU/Svt0zyv6K2cId4ulQxyUJow6qTpqNO?=
 =?us-ascii?Q?gghOgvUhurY2e1SKE8vjM+khg8/5i5XiRquwk4WpXklRm+rz9cn2yoRkj+a5?=
 =?us-ascii?Q?atha0m4VL3lrimMDVckNBOTaP2+sU0EUU7pVXKquc2fWBYXoQE3jcUD5in02?=
 =?us-ascii?Q?rtJHm0xwtzSIwZvFda2J3GWCDArvXLuO8B34js3uurbQZxjzgNK67ohuitqT?=
 =?us-ascii?Q?1qzlmyKLu0EMJ5n5Z9q5fOrgpjC8bwOogvye99R4dgz4ucXF9vf2Gn3FVDsV?=
 =?us-ascii?Q?ne4gmtqSR6aaBozIOhu5FoWeVgkk0MElspkBAZ+cNEmQLptJx59babzVlF3J?=
 =?us-ascii?Q?CE3/CQErDBUIGrWppaZu/5BiW/IKZeCk13lwMh9spYiY33fI6jkmla/az0dl?=
 =?us-ascii?Q?Eu2qscDZ8oXg5R8CoD0JxZ5BaLTt3MgctqfRiItVmv9COhiuw2lxyOaosO5O?=
 =?us-ascii?Q?JRD496jf1vGgWw4YwhVUGvrX2MgH9PoOFrzMwcnu7SVO2tjql+gX9WogN++O?=
 =?us-ascii?Q?gTip7vWfGK9nIlTenV7iheAYGQ0dYvurLznYzaI3wDWaay2GkG7BCcpg2qL8?=
 =?us-ascii?Q?H5CvW3oDgU2PT9LL0mLpjdGxLM6V28SmB6nJSUxzxAEiwgh9I0tOLLjyq4QQ?=
 =?us-ascii?Q?Bn02NHKeTtR4mvwb5Yt9pNdbEMTLkiDA8eOdgydpBp8GJi2cneor8wIL9Ogp?=
 =?us-ascii?Q?0049p+MuDHBtsJbtOBMUZzHEiNH/sbAyKkQ2nBRziWwNP4HOXpgYeGMA3ID2?=
 =?us-ascii?Q?mywRdB0Jlp0f4HlpphTTICKxReiKMW3dLr7xCVwFNJxjriM0JGet9DF2S3EL?=
 =?us-ascii?Q?4cOcuiSUnIcL5lj1qEBfxlmvnaWSPavNCNd9rfE+qKTbhQASbT2jSwAUym3k?=
 =?us-ascii?Q?YyeYtHz9s4GQK+XOC0HgdkD72VqhTHC5PNIo2ltaxLILU8+BjNGx26oPed0m?=
 =?us-ascii?Q?Kq3JMrURZ8eV/gPA49yo9liPcxZ69DY3lJBGZlu+BNzbnOERzYQieNPTBhGt?=
 =?us-ascii?Q?XEfcrnbyaVl8eG67Kq7YmVSp5rnBqgltyjarzVDO3JIWj0bpixkm16PmLzhf?=
 =?us-ascii?Q?jKJttc1deHRO0iUTCdDqnWb/fC7wxfC2H7CWC4l/5kwXljTdKHbjnIfWc+/w?=
 =?us-ascii?Q?O/tXcH2Op5Xl8WcDb93VFHxBMYu9ijqSNLWLwWoLt08jdKNknD12vZE5UfSm?=
 =?us-ascii?Q?PNra2Ez8K0vxpWGX7WmqIvA=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953e0fab-65a3-40de-40b5-08d9ac1d336c
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 11:59:26.9264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJEm2nm9GEVD+Xq+ABplXCh1I0ldTUyuCPPfoJqSE0KnG36Jxw1xJJVm1MtNb+jp6P9DeI2AKvVqW7ganGO3rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

The fec on i.MX8ULP is derived from i.MX6UL, it uses two compatible
strings, so update the compatible string for i.MX8ULP.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index dbf63a9c2a46..979fbc73f0b6 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -55,6 +55,10 @@ properties:
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
 
+      - items:
+          - const: fsl,imx8ulp-fec
+          - const: fsl,imx6ul-fec
+
   reg:
     maxItems: 1
 
-- 
2.25.1

