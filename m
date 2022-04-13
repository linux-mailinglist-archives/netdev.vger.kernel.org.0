Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C601A4FF4B9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiDMKha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiDMKhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4236193CD;
        Wed, 13 Apr 2022 03:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DboKUVIyLtxKAA7OCP9MR5CVXQuHyQe/46K6NPnBmXOm160wlc3lEJv2suNdV99TjzXMCrCltVH3XfvrIz05Pgd/fM/xLc7NBSR7aQSxWq325Cvv8M3Rbt4x/JyJ3KNT6UDqskBL9uCxpP3aYxT7X95PgLnkClebTw7NCCX3syZqlVHvjsQPXYtt0rzSnXF71Go0v8gaEQmcjowwAY7PobYZ2ygx3IDG/B2gAgozKEDuOs6Mj06Kv9t2AcZM+Bng8neNDPQ5GYcJahLFCwnDkeD/NP6KjbWq8dM7/a7gWpzvG8H0mhtQD3qo3GTe0QT8772p8ftjQasSHrqj9SEt2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s7RhVldz+BscL9t9xA4gLRjAwcr420BUYhMuucWwHE=;
 b=BM0WVdvRmNBqs7Tg0d/7nlUJ0HSXtDiaseb1GWPtPps/czkcEmBgg3k+cAjXI/KogV/OicPhQvM8W1fNdz9ynk8ZDVfFegnZljWubIm/nE8CviIvqwZfc7WvqCn+yDiHRB5+vwzxvDHSA3LUvR9Oibdfeer/2Slr+yXVzQ+31cyBMHkcksm11EM9mNUwSs+ydZKwJbPYk38su2yJmeo3595bOngAWJ8XBr4TNjmpvk29cABV8iOb0592e9TZa6y1GBnWCQMCInubAooNHgJ/ibsd4+ZmoSzdLcfpyK8CX/uqTRk0bdYu9mV6/HOrVvnCKi/VB48r7m1xqOOEAZUZZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s7RhVldz+BscL9t9xA4gLRjAwcr420BUYhMuucWwHE=;
 b=fi+BB3SC00YR9NPgN4dC8BDOP3D3NuIUoLykZYbOHT4suPcNdd8qd636gE32C7f7vHgmpdymIsGw3xaKSzZ9p6w95sYfgXZjSvzoLJe0X3dohAWSlJV56118C1UyyuQh8iF0BLpSCscZxYjxPBIy9RGxvHcgb5Sfidq1LLfdp6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:48 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:48 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 08/13] dt-bindings: arm: Document i.MX8DXL EVK board binding
Date:   Wed, 13 Apr 2022 13:33:51 +0300
Message-Id: <20220413103356.3433637-9-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e31ce928-acaa-467c-306c-08da1d393bf4
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB869106D23FC2A2115BD5ADE2F6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJa/alykaYY0+ctuAMVvJvK5/3eEw+b9w5o50bEPQUNHTat+epuZMZJ97rbU3ycPHelhgsTH2+r8otatqCUxGuen3o2LpPYrxxdNPET3WAdg1aaTJwkAgrDlJ3ByeYxDq86IpgT6/ndZXVkJ+eeJCXBgg+CGkVJEtL4mGH4q5HelPhoN0J+UbW3KS9NwHEcWp4jjYYZeyYEOYSVGygTHQoaHJUGQs4c4Tp2aSy+BTUuVCJp5tWjLBPcOrz8aPyfghBHUckIinGCzk2dIM0l8XWDmXYgU7xWo0j0P7vOUZOa0jY5WDxLSVXNZxM2fuLr8idmuKlulgigJWCt6dJfey+rWckYGxNIGCO4o/C6INFuPw8LVtBl2qzlYNMar1O+OUPMGC30t8o140Kd8rBbWuOHgMOLCYJKZapLITrvVh6XFEmpZtX5A9IgyO3YAZihfueL86cjDtBSWF88aqwu0huypsz0nLaCtx/bqAjyxx2IatuKxVQ3gmyedl44fqdCLnW41HgTh4zy9qS5CLTVksCo6yXIM18ogZi5lJCfx7DxkEUcDlPIzpUnADy3BTsQGtgjtcn5VEpZsgVwyrnmrhfQ1G94LEfqkDxKedCi4WstnMhVycvBNkR8Weq+xqBvMkvt5Nsf4PVHlWu2D1+FHwfVEym8SDfGELdutYm6xa32o1Doj4rw0oB6Lh/3lV5cHUUSIksCCTBzhMSdeoiq4jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(6666004)(86362001)(2906002)(4744005)(44832011)(7416002)(5660300002)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?be8z1twvc3c5X7tU/76btyv6vrwz09u7MXPatgyME3kVjk3gyIWA5TcRtwrj?=
 =?us-ascii?Q?a/Ffr/93eTOFmo2i4fomP5k9yhsH9qnOOQl9OWlqVdGhGxqGoFlXsRJbgJ/T?=
 =?us-ascii?Q?mom8hyCCSug6RVAqXHFl0VMMFQAfgCOZBQ8CyHkQfviJm0qIL+iXS+0TYjqF?=
 =?us-ascii?Q?H93waOV7ut+kfx43SICQ1RRTLGS2OuCKI0KaiR3TBerlbubcZuH98+SWqEMJ?=
 =?us-ascii?Q?y5vxL/gEpi7yx/LqHjsjgg/k7ZqhizYuqLCRHlJu9WSXDfX9O3ylSSRNWK4c?=
 =?us-ascii?Q?vUhjW1aCuk+UmAAhi2e7S0AxMYJe3K2sI/GJE5j7bQvfFHiZcUWRjo9g+gRH?=
 =?us-ascii?Q?zTwSrgYorMCBauJLF5zJCocETSLviP4jpVj9aPhtc7gMKg+z9+PTeoKrXHvA?=
 =?us-ascii?Q?wtsKVBD7L6hRunsqtjMRbLdg1eQTPUxIieg6pIVMrMslC6jLjq2l2Qg0LRRG?=
 =?us-ascii?Q?3lM1chiyX20SsOBjw4jI0l1EKAQolY9NOtk7iUCd5JRpxfWHUDg4MWCxD6d9?=
 =?us-ascii?Q?p9CifnOgorWFEDdoTa+Mk6Q6w78Y0LQcaGgPCGjlWBU9TPepi9WT1ro2Gd9Z?=
 =?us-ascii?Q?nb+Po+KfdteP6ydtuPZ68qT2pEgWcu4Z9F1a9WxPwbM5+ZjOxuO473+d+sNh?=
 =?us-ascii?Q?6hO6UdShJxOAxwN4n53L1/A4RQZeqoVJmdT3raDQ3CIjupRZv1tC3SY+3iV3?=
 =?us-ascii?Q?FIMr4+5DuhBgjRmh+F7sKuKgZRfWAjvNJdIpdRAd5VE7TheUsNqDs8tvM6U3?=
 =?us-ascii?Q?hdpqVPmQwpoHomAfbnQ1kFrpxYnhybtwWk67whcI4oAhMm72CHEveZuA5DIT?=
 =?us-ascii?Q?okv2Iitx3ooPyS7wQvU0UCaP3I1Of24rvSWdF80aarNp0nGeO1lnZHk0S+Qf?=
 =?us-ascii?Q?qoAE53mVyUrbfqXk1CE5KxkWOls60PJLBLWAge0+1KcfYUFojZKVE0bUneMc?=
 =?us-ascii?Q?MvmhPx+ehRdAzVT/RHzy5J19fuVi6zvMpV+XfKoL/V1cfzCuTcIIrSoPZb4y?=
 =?us-ascii?Q?coAsy2tQDRg2pDNX2BQ/RzGFEdX/V9P+evzznTenzj4lOFtC1YcFOXfWvmEB?=
 =?us-ascii?Q?kdIQFXFIvdTX4iL9d8h/jbxImle/+u9HkuKThrukmowbx6w+9Koi//GPThjj?=
 =?us-ascii?Q?+nHxJfGCz8QO3L1qyw/ga5yKp7vmYZD6iH0+sGwiCnUQOLjw/VNWLpCGSxB0?=
 =?us-ascii?Q?CZHisAQ47vIg8ynn3/7joCGIdEjQTzv8+8WkPjFw9JAlElM2FemQulBN9H20?=
 =?us-ascii?Q?TBaUUtyn4BPtifG8NA0ygBQbDAezLtPKrnaUGBSPIh61XXO2sHDFRv6I5m4A?=
 =?us-ascii?Q?ZagAdcTvQGe4vVx2jzl+QcLy2/Mw/PvoMDdMEYygquOrPdC5QyE+Gc7CcTk6?=
 =?us-ascii?Q?rm7IOThJeXKcikOlZmfNLmztjYlhRVVvP0rTo2gwKqf0BkIAJ9MlZnek4Qmq?=
 =?us-ascii?Q?NakJcBpYVIt0KoRzcQHA4mFkNtSIozCKSKu3F6CQBuRh7XfAu3yKQUDXVf0w?=
 =?us-ascii?Q?7cAiThIhItZbo13wQfglbghD3UIPlk1xyV7wCnyyHSJxbxzN8gshmRprFz6U?=
 =?us-ascii?Q?Ti+Xs3DsKquIXNSTp1HFzbMJ1YEPsK9kums/WYNiEyciVAeEX4WBuGBcMPZL?=
 =?us-ascii?Q?q8MFmFJG+o9CHkzYevFj0fggPCjOMyU0LDpVC9rlQ1WACOQnyKBM0lPzhvsp?=
 =?us-ascii?Q?bNAl04qyHKm1pztR3SU/BV2XrQIlOk1csZYJ/NyhVfPaHlzXIlY/kydHxngf?=
 =?us-ascii?Q?hpvlkoLpMw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31ce928-acaa-467c-306c-08da1d393bf4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:48.4265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J27W4SJWhwf8nnPMIkYr3eTsSnP9iWFvdabhyJodQuvgtld7cUd08GGF5MuNULBzuH3gCZaBjplQT45vTrxOBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
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
 Documentation/devicetree/bindings/arm/fsl.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index b6cc34115362..c44ce1f6fb98 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -803,6 +803,13 @@ properties:
               - fsl,imx7ulp-evk           # i.MX7ULP Evaluation Kit
           - const: fsl,imx7ulp
 
+      - description: i.MX8DXL based Boards
+        items:
+          - enum:
+              - fsl,imx8dxl-evk           # i.MX8DXL Evaluation Kit
+          - const: fsl,imx8dxl
+
+
       - description: i.MX8MM based Boards
         items:
           - enum:
-- 
2.34.1

