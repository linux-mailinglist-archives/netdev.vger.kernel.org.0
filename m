Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90F2506AE0
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351594AbiDSLj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351626AbiDSLjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:13 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50046.outbound.protection.outlook.com [40.107.5.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1915533340;
        Tue, 19 Apr 2022 04:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+Nl+XKaqfhdEm6+Rs3J+k3wWMXHeYyQ83lxnYDrYe3REEUhxhxII2BOFlpbe9jQQjFcwj5yI9QFUvTW9q2IwR5mpIbIisXoUZojNCqjjL/JzholBo8jatx8kSpKL1kjWKsufAxP7d0ymWcOraQXIkhXnqW+Pf3ZkMPO9uzxa511c7dMGf0Wwdnqhvyg82QC3PwSAjsErOyoXt/BEeKLQy6koV+H3g6svWcNFL8mfdJMmv4y9x+FFvckPzmVZTpVRwdTvHfdx1kqE7F+dhGFN6+3ce31xaZKpdSiPd0LIhIkzcG8HbrPwyx2rxIDdZtSYYGiVnc9pMo1MU/RY4kkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPRv474xsMFo2sxO3IZnpYcT/ehhFPoteTnA3S638Fg=;
 b=d6TQQq1qx5Bm+LYpIl3OAxvbgkJOmGETazO6XhLR/0itpY1fpoCyBbIXXizy4Tp9awfnUkvbd6FvtMLS4XrnOTigKbEio5X0llJd7h3wY4UQQa95mhv6gdXjlNhrpVuj56XpV0uN+4Fr+MY6xFMD3PUYqKeRooWGYrD0hITpskAr0+OGcpOvtdakp2MJ+5Tjozw4eQa8ArEjBNtcqDDb4zcXHe1E49Z8O40tns7rk9M6dCdZmmvzjLj3mXO3R1onzAvvHmRdqTyjR+ndU/3oZMLdPA6XXM1yRiWk85Ux1R77S8m9dI6Rb/TFhO4hOOP8S8L70Y0jsKE8Au6ivRhBeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPRv474xsMFo2sxO3IZnpYcT/ehhFPoteTnA3S638Fg=;
 b=BDQKy+L+cj2Ag6WjSrTpfSSvh5SsFlBrpbkB8tlv3NjteLW4xs2nA3b/3l51drH4Y/tCEE7z1ZqQWYsW0k2X54fqsyroGaC1+y0oWhIfzo5kAMMdfrVIMZJnZV0k8dm9RORobJMZKv31vGgEA0wKy/eCm8uKMH5hgvvFneq6AT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:37 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:37 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 08/13] dt-bindings: arm: Document i.MX8DXL EVK board binding
Date:   Tue, 19 Apr 2022 14:35:11 +0300
Message-Id: <20220419113516.1827863-9-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419113516.1827863-1-abel.vesa@nxp.com>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5ae44a2-dfff-4111-bffe-08da21f8b943
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB963161D7E57DFBAE19341C2AF6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ljJAP6xuXOalQ8rSXCbADatBGDbq3v95YsDRhY50cuI1pTx/TPidgRC02GyhbSAAYbiOa6HMihmhjKs7p1dKGkOY4VFjgiiw9GEN1vLn2KvTJkLG9xuxTF20NpeAVn5re21pAsvn7KlzyqKbF+CRSYFASqcoDFjd09SXmqMuqGC9dhFUQdtcV9vprmD2eBCesiaG+vLQ4jAxIMj8HEQex2sk2e4h82v21S/WSN9e4YlrtbPe/ZhCFpYCDE9LqHuOHa/KA6EneSdsj69q73Qy0Lbof87ab8LsWrigcJi9ccIk8OICpGyIGqus96nmT3MbepZL8PavpSRxsGBeybVBwiijdgCWHFzqlpNW0Uwrdl+vn/e1CON84ej+9tX329edFd6sj3pwPxhqSrFyvT9/MBWymK4Oicj5UABr9dMLZHovR4uBUlly8NcTGLt5Cz9GxXV+BuP9m+UWD71+JqxyOUWL/ZUxYTwRQze+xS+HO0RvXsO/yMaaVlEoC0MW78WhvfejvV0jTFmcP0GOsfTwr1Kw6zRxAPDkjzLmKLoaGGH024Y9zoT/gwwVHeyHn9uJHbOSJJmXA7aq3Kyc4BUQqJ3mxJdGC2NraEPBN+Ro4eSteoCXV+D3NELTWPp8nIim1VM6liHxLJfsqqNvarzMDAeu8ybH18OZBi4dPQH1xxmCceMeloZ99aCinO3K/ZheYTIr1hjnsxKApRCiwlNfvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(4744005)(6486002)(1076003)(2616005)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uHMJdqKehB5dfI4arw7eSioL7UkhyzbRhEr1+D7A4ljZqa1EAgs1k1mryOY1?=
 =?us-ascii?Q?SHJVZSPkgvrqdsB8huiQ5o7faQoczx2U/3vow/AczygQbYbc9JlT77ZS43F4?=
 =?us-ascii?Q?n3KnSjrLuBoc9/7jn1xGmFlkIwN/Oi89mcoO/YQfA2mUIAtXVbRDMfcyvrK0?=
 =?us-ascii?Q?hkGfEkxZHYkLvhvDMgw1/8lQv1k3dCe3dMUfOQhf6tZfHgjX4ftmr9tql4iG?=
 =?us-ascii?Q?+C8To2g+UJKUKVHq9X+uw50WUFjvxLmir3ttNdoZsTW34+Vk0dbJpuvajAL5?=
 =?us-ascii?Q?hMaYsRnIM9I4RDw7i+LeK5diSW01vy8Db8TvkrtVjm0FC7PP5UgNIUCBcehj?=
 =?us-ascii?Q?yIOGrp+0oaOM9cF19iVvNQaRd8TfN+drZtQTLKhbK2eIhbWrBxzhqerdd909?=
 =?us-ascii?Q?f8ICWl0XtL+xLKBf4n+LYwzxsTsk6oJdV/oea/Rse/iPzVhv4LchWejAtaO/?=
 =?us-ascii?Q?d52rKZk1PIw3DWEkmXr6k+GD1DJb0ECr50Fga/SxcnI55V1B0OoTzIAkRZYC?=
 =?us-ascii?Q?AHFAnCu+x0Y3lC7fRBgyPnzj9QAqivST34W230iecs8olBMw667PY+F9wvmw?=
 =?us-ascii?Q?UM38UdMkOVTSeEJNJXthztwFkXBrNClRpVRF4L692nCxh38uH5qu2rgj4AG9?=
 =?us-ascii?Q?r/wSNXmUdgtyb+ZYCA142FOtZgJlFPc+voUggFwiIvaFg6wAhHFkYiExmLYx?=
 =?us-ascii?Q?2tGUbd/6lnqH4lFndBU4243zd0vh/7rHlpIWxgb1NcJMkFbhvzrP0OqY49Is?=
 =?us-ascii?Q?0bd+Es0r7nqD8k/BKRFEFJkZI5/MQgxF5dYaxgBGLRvP5QgribAIKqVs9xZ4?=
 =?us-ascii?Q?ghIIda6v8Qo0frdj+CHiT2yXhWkf7CFkAQwMKpKSv/s5CihshRnIqaPXeYSz?=
 =?us-ascii?Q?9SmqSquKoOiHQPoIKol4wUK1KdMbpKCVVropGyt1ZmJTxmJE1sQNoEIwiedc?=
 =?us-ascii?Q?dZxA4pvPGHTFw56bM5KJEXqG/f4QFW5svSkv1UgZyKiiyLtXiAeGuuStDYs+?=
 =?us-ascii?Q?V9eGRglT15dm9MIf16SvfOZN+LEVjYjeC2wqashVPqNE2nRd495uH3mGQYO0?=
 =?us-ascii?Q?IRviN226ATPyORYfphj4Q5BBdkiJOgtFYq0Eya+6j/NeLvjvI+j+Rbtl81lU?=
 =?us-ascii?Q?6uDzddtyHswuk2Pt1LHdz1/Y9i9weq3q15PWESOD5jcJscRlBJR446zO2BTl?=
 =?us-ascii?Q?7nxDyzGpN7LplVsj2nqwAOevMKTCWb/QiqUk11vZduYspGDWH/+mWYW02k38?=
 =?us-ascii?Q?ShSq4j1MAm9Vq51w2Ej9jpScucQQ/MNkyEgJMP8fz9Kv9jVuZX3y7FaiFp5r?=
 =?us-ascii?Q?6EiIANEDJo/Ii/UoXDr8W4DUmLmgId/3jFTqBgBOLY28sFIrhH3KlTGixi5O?=
 =?us-ascii?Q?Zic9mgSFHoNSOQtE/O6WcMGAxPe4rg8qTo3gG3EMPGJZb1ACPggl9PlO5AUD?=
 =?us-ascii?Q?vCLcCBpuL/6ZR3AT6KGOVPeb2Jk6a09zjSogB7lLzk9TTFPQWQhLOsVuFgwa?=
 =?us-ascii?Q?bF+UMH4ut5L85Mc1s81rp8S/OIjXyZepmKYwMhi8opuVPOTCMKax/co7U+Br?=
 =?us-ascii?Q?Gjucd8HZD3gCEjA+dM1xNSC4yvD8P42SP/D0p0dh22JUoXSAF9/aht/5GWbe?=
 =?us-ascii?Q?h6UXe6r6GirIKJ+a/djB/dgSpdjrk+Pb0DQcplG1L5t7YA2xNimkl1m0y/Ab?=
 =?us-ascii?Q?+/BGUEdMaAcrGeukEGAgjmdd6xBSvycHm/WrOIsxhKiAWpEkSxoj8lcfCCi6?=
 =?us-ascii?Q?iiYcPoyjhw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ae44a2-dfff-4111-bffe-08da21f8b943
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:37.1583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUX/d50QlhzOUGTA2UbLlLSaYKmmqU7YyN1V51O0A9kgfsUN1gNdysaA2JdfKm5sb7RK0JpTb6x2/zxYTW/QYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9631
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document devicetree binding of i.XM8DXL EVK board.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/arm/fsl.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index 13aee9fe115e..a43f3ba53ac7 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -798,6 +798,12 @@ properties:
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
2.34.1

