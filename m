Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C021553FD48
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242919AbiFGLR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242742AbiFGLRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:36 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2044.outbound.protection.outlook.com [40.107.104.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF874E65;
        Tue,  7 Jun 2022 04:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7UXZOxPFeTX0swvqp/mleMmJfiKffVFtybmZaD83yeA92jempS8yc9J+Jz63qLKVARhrGgkfT5gs+qmD/ahdSjGcSv/FyJPHgMW41Am3e9kKkj4yDsveXTZBJu3/cN4cOszuv8EkwSzwoVMJB5qu4mWGE9xymK3YkU0JGUmANJvBEv6kXU1wPFE4RFN+j/4O8dSHySoLT75csJmrYCddzyg70c6akUNBOswFgHk6MQ8DzmlY7RiqyUTepCiJoJ3h3Vd3yjpOA3zLBySKm4Id4Sr2vWE6wUuYXmbxcswbZEvOp6WBDHyYIFn4Ib2PG+QzibXA0YbFKqEFfe7LlzQgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gADMoFISxHwJz5KOWkt8Ud0LbOIUJYaVfUQXk6/V0Yk=;
 b=jGH5iS8SCVqp+ohr68EzUJC515BIwFKSlj1deS96dZVCPdwMCL9sJQPQPrT074KO3SoXdOBW1XbR88EDVX8YRx8Y0QJjdKTJ+Pkke5s2Dytfqb4PwEBJnvYou2gqrYA//GLFPPQwXVNPqmuYKKR9wgNsYHLgwilVU/UAFAdv5/deyJzc+25INKXnUIBohOPDiVUVyTBDAXhtWYDBbf1QpnvVCCGpndiEbWGuroTwNxuX+zyk2BqL0c9vTDY7Z9b3OrgQjhYmPEFigSKX5iZW2mMM+a8Tks1jzIrPyn7B2yOVERQeAZTdBcVvkUP7IPwhNNiyu6bkSESx73mSrJaopw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gADMoFISxHwJz5KOWkt8Ud0LbOIUJYaVfUQXk6/V0Yk=;
 b=bDnYe+pTMiu9tt/Z3RQMvBsttikNPfin8wiGkpDE0ZA+5ze9RwUkG17Qc1d4dTJ0XBRWWXnTBMcKg5NQiYpC3DFwR04hQ9Y5ye7vaiE9jkkeuYiZQGDfOD9YZ1Y+jiyyojXEXnEcbmKWDspzEfDgTMD5TOYUp5X/M9m1D3c4Scw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:10 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:10 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v9 06/12] dt-bindings: arm: Document i.MX8DXL EVK board binding
Date:   Tue,  7 Jun 2022 14:16:19 +0300
Message-Id: <20220607111625.1845393-7-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc143d33-e51c-4b33-1733-08da48774401
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB48906C43C55EEBC70D2C7547F6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJY8jWF2a+I5q3E5th++7vVq9+CfP6nxbfUZQGbkJCQMtUq/tIV2Fg6cTPDcokirLXu3fAiJXTE03HCkUb1wolkSGDYTyHP+Nf0yJbrBV2tss+lIODeAFyp6OuP9lyMhzzOgIqGC3CMVSLqWbH1AIZVD6afWOFngowthQqS9JFjumNMnBiFkplBjjks2rFX7+O2fDwSRNE8QSjneBePgwAwsQVBbqflKs1F3TcfNGZ0X5ghzSBoorBCjUo8+3YF8Lc1g7wnvNVxXAbKKzqLZG+cESlP9e11rEB9ZlpGnz7QQySjAeD+S8JYttJoyd9XLuzoIw2u90ynIZ3VOK37nQfRFimaVWHdY92DIX5lDaviXQlguR3ezPNq3G4OeObyeZ/p0oqyo5FRaL37CUkSDf/x0jn5i7hml4Zzaa1NDL1ATcAoFyMdTSyECa+i65Fvx3qDa6LEi5sDgzDCY4qEd3mvc3U8bEHg/z1LsItYaVTE1Zrmn43wpOXmzxVNMW/hgJonmHQ1YOIY7yNFZzWQBLiUKQN8hnxB5TxbsflQR0/b+cbYrOJdV0BWd9IKFkJv3H3ywNnv5VleOZSRTxL/wF41PLpLgmznzTY0wxdScA+uPUNK+ABhbsTGph5YMIgISXekEw3lQ54xjL7f3PS3cAbS4QZ15pnfuK1rioUZGdAIyMt7Ue+GUUJEJEpZypDeL798xncB1KvvpN1LgDW1xk+d8r2DsnaZcYcNRiZfcwxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cyejf1CDb/TKgJ6y5yxk+b3J6XaVKoBIiww5jIXgILR6cETlJrWleJEgQck2?=
 =?us-ascii?Q?caKpoFoqXyUwgLvKQUNmpN9FzftajUfAuIa25AKI8DZIcEMa60xaUd/y9fPj?=
 =?us-ascii?Q?ueOWqkSfdMvHVJQSUIRjKbj5/XGvon7gebi93BXdhweEMNKM+kd+1NOAzgi3?=
 =?us-ascii?Q?baTcjV9oVcFNRBBfrAC7380ITxPwTXiuvqtx3K2T+3eRP9AxMzKYflJfK6PJ?=
 =?us-ascii?Q?Mhx0/jNwwwq+LdeZkgpok0fBZpSgktYes7iRzw6DzuFV2YrF9fz6lkkrfv/s?=
 =?us-ascii?Q?iiLghCVECqVgvBU1TAd3MEYeetrJWoVK7DNZjHEQ4gnp1lBAh29IUyVbBSQP?=
 =?us-ascii?Q?KycrFXLoZj+vEVSvybNfypNvlyc8a31MHuc0g4pv/H2gh3vkG1R97/mfnbsG?=
 =?us-ascii?Q?/bsQz8tG5GxzOZGJPpc9nUAQIJ8FqV4bj1hOZlVy7GuOnqHagPuVXQ0/YpLd?=
 =?us-ascii?Q?2eYnNwbawo/nyEScG8hLkOHTsUGkdnCX6oiDM/6oCygx7Y0wMRl/bjXdLdWf?=
 =?us-ascii?Q?2QTV5j+X41HSqMeEUfl3HkPzSTMy3YeWcJJzg/quaUfyRQqDE6nahWLn2drY?=
 =?us-ascii?Q?X318FXzMOeDLY3ByROVT7W8Ypm8jbXYk3EIB673++CnYyBY4+MRs8z1PN2JO?=
 =?us-ascii?Q?haLUcTWACWLmeLE3f7Q81ThuHeVokZPlAUZBvdJAMqzKVKJbFmB99iCDAWFx?=
 =?us-ascii?Q?2E+JesneE9BOEZuXVETpUH0hZVL/Is9ykeQnM8QvojVo0fsUWGj0D9X2fPQP?=
 =?us-ascii?Q?yy7BN/BeXTexMLQGj1sCvVBycAaQ+rTHDcxzidZkrmiA7gl7GgfXFmtAjOj2?=
 =?us-ascii?Q?NzjtjovL1XlpqXFCZG4UnKx7WT5K479qhASpp0QARPG7FbWJpdW0jNdo+9Xe?=
 =?us-ascii?Q?b0Ob+F5mMwPWK5T684s+dEPtbMw8dNf6TY06V1UxNwxfhc2q1ekGJFnaSKiN?=
 =?us-ascii?Q?RuA872/azFkI4/fXCjOOchdJ3o24cAD7rLrhN5naccsaCGy34wiymsRSraIc?=
 =?us-ascii?Q?g+6JhqrjfRESC69TKaYhC127ipTTYF+DXYqKGtiLS8StNKXuzHrLxENuBfza?=
 =?us-ascii?Q?UZbfcaTTM0STW30kSJEfWlSobYRHEOI7dztUH9HcUmZDfIJF7FMoQxJI2zQz?=
 =?us-ascii?Q?Wvmkl4qEt80U30sWVFgbCQ2wmFZdXXfnKbMbGC45706lmZCKl7YvJgLpjSQH?=
 =?us-ascii?Q?DhIKdX9qC3kNAXSGIO62oZymoTXhA4EF02/y3NRucubYaTu3sT0LAdCooAme?=
 =?us-ascii?Q?kwWvEfANZEYLliG1Lta/BW8o1rRxGnG3rcOikHUfms3sexb3HbUjtYoyWdJN?=
 =?us-ascii?Q?BU6vQb15IEm9C944Gqc/qpZ7GnNObTl94OcXIaAxeyo35YNOufaeSQkX+Cj0?=
 =?us-ascii?Q?2Z4NVnul0ODYH8Go8EGZas1pHbEQoimcMVZvvAYNg+cHA6ah+C3QrmXWB+Pf?=
 =?us-ascii?Q?ZnoGHGiz2TdelNJ+Q1Z0seZPtzBtqTVYbHAmRSQkE2ZPXvR9prVoeNqMZ7GE?=
 =?us-ascii?Q?s1Os5jS976svEz80//mDhd5c7IbANsC8/dIuU8F2K6yltI9cktoMVbdjvGK2?=
 =?us-ascii?Q?/CUpku4W/S8WvUEyLiTZb0YiU6Bsb2GRtRrCPO6uzrX6sEHZg+TXY6XeO7zR?=
 =?us-ascii?Q?lI4YXb4/lZi8+sfOdghpjtVVoNrC5Xm4UN0NNU5+WxazmJTL68/zcCn4A23V?=
 =?us-ascii?Q?HVtYaSWCM5XeGu1uevOZ/GcZLTrzhahQO4dCYmW86q0cRrEvFit6bTFk3qUn?=
 =?us-ascii?Q?Yqb39zLjRg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc143d33-e51c-4b33-1733-08da48774401
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:10.7451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1g6Syz2M8IQE9cNug/lqF3tSEanIG6HKVys/v5rnk7JWkG62zylbv4HHWbzInJkv1ucQ0CfTLoueWv+EyJPxMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document devicetree binding of i.XM8DXL EVK board.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/arm/fsl.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index ef524378d449..451e06a98ca2 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -809,6 +809,12 @@ properties:
               - fsl,imx7ulp-evk           # i.MX7ULP Evaluation Kit
           - const: fsl,imx7ulp
 
+      - description: i.MX8DXL based Boards
+        items:
+          - enum:
+              - fsl,imx8dxl-evk           # i.MX8DXL Evaluation Kit
+          - const: fsl,imx8dxl
+
       - description: i.MX8MM based Boards
         items:
           - enum:
-- 
2.34.3

