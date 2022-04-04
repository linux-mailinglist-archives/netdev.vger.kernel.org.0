Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114F34F166A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376645AbiDDNtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358692AbiDDNtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:49:04 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB083EA8E;
        Mon,  4 Apr 2022 06:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGJQY79Q6qqxwoENp/POgGT9F+M8FUiuhA1qEr1txAglETj65PNjkUooibK7Sm2bK3P57yAh3paZ+ApYsloSv0HuOvjd8JAWJBuJIrYg1JWKvgfri8BGbfATCp6nAoXAeeT1oM2zR7cmnxKIK8K+Vn4HFxv1SPbq93u2TdHy/Lq59STMo+/3Qos193syimjSfLaU7Qauj1c25FoXm2uzHWzhuF4Vsc7Anc5qz2C9A0+dthgyzJtxdjMZezmZPRxJPSov2/MzlL1xkxC2WzlMeqX+u0byy/dZYPu20KSBKA0iEdJZrGWzvkw1PRK36esiv440Rczlnr17msl/vjJ8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCPPMMOhAn7S9S52hnc0StccHNDqmtTZ8G3N3JNlkTE=;
 b=gBYqSCSKiV4gZrAAFHkXSbv+FlIZDkFI7i1lgB2ycxAYQIp2vD7wuD8MUNXxdqKwRz50PDsVOreOCRpyAeliPMXy2kbxp7atLOrIGc5tPOOTP7sidY/mG/0hQNk7DU5/YHcsIvMclCvJ44UyBF4XMpsm5k6MPhp7k2wnonjJ2bElFXyaOqCCPGadz4wQKPtSlfwyAlFN2Gx+MmJ/YAVbyF6I0fQ1T6bLkvA+XPX6O+6Z1KYeoG6uvW/ERrMjUkKfDEm8yk2XnHhsTUBVL9r+130xkGEzZM//v6aYIEsf2LZR9oYF7unTVf5LUeNukWx4x5jzPwAdBqi7Tiww82mFhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCPPMMOhAn7S9S52hnc0StccHNDqmtTZ8G3N3JNlkTE=;
 b=dqTa64FtYoKBM7Ll/sUUNS9yUepoZ6O7hN+swgr2NP1BALqzgUALRcxOgeaSWALbJhZnYDJELs/KE/b0px1k6OME6giNJOslfCi35ycJh41QvgN+34dpDf+U+0HasKVV0xTWJnOMmSOnKt2DSz+p0FAwXZfL9utcu3k86us03YA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB5889.eurprd04.prod.outlook.com (2603:10a6:208:127::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:44 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:44 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>, Dong Aisheng <aisheng.dong@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 8/8] dt-bindings: net: dwmac-imx: Document clk_csr property
Date:   Mon,  4 Apr 2022 16:46:09 +0300
Message-Id: <20220404134609.2676793-9-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404134609.2676793-1-abel.vesa@nxp.com>
References: <20220404134609.2676793-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::34) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f897ad14-3fed-4840-7d13-08da16418e2a
X-MS-TrafficTypeDiagnostic: AM0PR04MB5889:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB588979C0178E40FC5306529DF6E59@AM0PR04MB5889.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZQFaNU5pMWRDiDt8SLbUcEIvVJrHO2nbjCqa9ac/U4i//jSzORbo28/7HcAZMu4v/ykJy+ix6iilme+L/lLFRpDlYDenqDJGMUC8nxubsP+ufbWScqw3zz2KyD2zwHTzUU6wXZ2RvNBmU7AqyPVwCiJTTW2R4tYy8195eNYGBXFNYA02zWyZYkHMZg6/37iUORPZp4PLAHWHtzFdXeKwNsacUtWF1hts1YakLhSG4X+s3ZrsDsG5o0OVpx9jmQ3REVKnbdlBz2BeC2njOER9GgSnVUjY099EXMFhKaDUvA6W+Ex67PTcgWSNvf/cSyh5PGFXEyIH30BlaMgn9yxh3JADh/W3XSw9trv+DVQCzV150L5CjmJfO1g8/3Vj/an7fAjVjJs9ayDh4Vz6CrSVjXIdSX5OXpZFcohk0OhAZ2Sg+ydhEf2C2joC99hRrO/aFW2ZK96UGNa0cE03wwW0MP04T0dByEpgj7IrgSF00RLF1HxO+UI8/f/uCcf81RZbBQIJAFTb+eds8guPWCyA7XcRBMbJA01c62cMt4z5ScuYYi95UsvfmOVnomd0TyOImPXsa0kfQ0tVF/ixSN8XsH2lQd70iVJX+H3J3qgIuw572xoHIJ+JfAcTmHrr3wSjlu8BhE7mm+C61gcdRjZj3PQ6Qk78CGZCkw88WLmMc+L+i7sV0bBh0u/i2LeNbIWVZ7U6scnOGcMbXdKp7DR3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(38350700002)(38100700002)(54906003)(6486002)(110136005)(6512007)(6506007)(44832011)(4744005)(8936002)(4326008)(7416002)(86362001)(8676002)(5660300002)(316002)(66946007)(66556008)(66476007)(36756003)(26005)(508600001)(6666004)(52116002)(186003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQgUMd4ARqOQDtd1usEb7RDLhyfhgQfa9keTMKjGVW6dAgev3Ah2l8YVxVUK?=
 =?us-ascii?Q?YGVaNg//GUfCqHtwP2qEolb/2lq6l/Q4fJ3u9oB/9FzZIz3a8GdAEMRMYiiA?=
 =?us-ascii?Q?u94vahxD98gOdIhi+fQ7I+n3Jbo4EkZX6jyAMem/Z/lk13EQlkgKsj4SvLjJ?=
 =?us-ascii?Q?+C7aNKYXhxNBZET4MU2d/auD3T7Qm/pzqISM5UzKA+jkjaupDrC6Tq+fMB9t?=
 =?us-ascii?Q?gkplNRn0idQWbJc2S81l+vJ5UEs1ZdaGhYxtp6Mw7i6gaE2/taCmCK+eU8ma?=
 =?us-ascii?Q?VYfnaXlDeb3+2ynjZ1YnSELYizdovYjBJBEHhnUEmxMBdnEehpUqs1x68gpH?=
 =?us-ascii?Q?f4MLyZ43OD8wvVMsp7RzuqyD+4EUDCP6HxSOo9HexL82Yxf3ra6fcRgXJlEU?=
 =?us-ascii?Q?FBMREJCEUDBfVC449x3gxOCLguj44GC1bJU5cpbnm/ICa9LYoK6rK6Aqvf3B?=
 =?us-ascii?Q?GdiiK7xce8WLv8WHcfAXGRXKfUGnW5BQNstvl/C4x5p0CZfdLZybcSToENEe?=
 =?us-ascii?Q?0X7rpLjBRX+UdPapvXCm/JT4Odw2+5HSgiuj71FC8u7iDf4vaEnnEQukJ6fF?=
 =?us-ascii?Q?xCwdvgGrziq4nHoxiewUIWvO4sdd91n3qZiXSvKdOI3/zAQJ6+MdVwxKKOWm?=
 =?us-ascii?Q?8Z2jPFtGAaTQpYhCf2hNA/IIw71nhXeYppqO5F0pyjd8vLmif0W9NMj4Oqj0?=
 =?us-ascii?Q?z1Hs3z5kruY7K369ilpi+0hYgWejE97nWHrhcsGHklAo5rOGRSyNyS6kC59m?=
 =?us-ascii?Q?LQ7IEA8t1jEf0mo4alkA8iPNBvUlThjl79yfmY13HyCQLW47Disb4Fwt6XyJ?=
 =?us-ascii?Q?46IqYhnE8hHfGLqeOe9PsvkxiH1ExNh2437e86vO+S+NoecDEPx3u9ywJzvj?=
 =?us-ascii?Q?9Dd7INpIZhP8BzhYM4FBj8ndmeP8YB2UxehM4VZ5k0tFL7a5/yPMmdhlnkRk?=
 =?us-ascii?Q?ma6vU7hAmgEuimjjom3UWM834vBxyvp3mv8WrvSvy9HfZfImg+qVOJU1UHah?=
 =?us-ascii?Q?F/dcz5F4CHKQ1kRjQoW5WQHDkw825OVNFx490PxM/C+tJLW4lqzTUQ8GGLgu?=
 =?us-ascii?Q?xJWuya1dWqfDsH0+Jf1/PaGFrQx0rHZVJ0WyrfmC+xHMNIghPaJN51e6bPrV?=
 =?us-ascii?Q?qlxxzrVcmAN0EqudROT84Bhxf9WQT9sBbUcKcBhIBjFlcuiUXZpAkQlGpz/V?=
 =?us-ascii?Q?G0Wph4bZx2RNwssFgrKB6FkNnExe5jaF6JBQ4bO6EgpJVu6qVdU0NXz64Cme?=
 =?us-ascii?Q?je029SGhsjTH+pHYIqGEYHBBRIfTWbhRpKrzvUxVVnvuMdqqoAU6XvpW95Jh?=
 =?us-ascii?Q?jgNT93QG55moF0nS+DVe/GKO9oBVXixQ4u88Td0cPawcJRdfaprFKmKiyDA+?=
 =?us-ascii?Q?CXInv2qBEGRsLixj9VL/itkNjC9sKyojzm47MnSydaQ7gJcB1fOcjay+T4FU?=
 =?us-ascii?Q?OR4CWpKVJyTUhb88v7wQsqJxSJHUyg6i0GqtNa38ukWx8iK8MwPB9PGuW15H?=
 =?us-ascii?Q?DikZY+LuFcV15SjzMLNPs4qCOXSQ36zYZi19dWkFueQ/laPEvU6VSqOZKQGm?=
 =?us-ascii?Q?jHjYiC88a7BmuCc7+TXx87HnE8g/I0ec5XvRXtr0RSlyBvC+BMTjF1/UPmTa?=
 =?us-ascii?Q?RLt4TuIDRzOA4j5cBOrAk7GkWYAlwKPpfW6QRs9jZdHIcbQtZgEduCzH5TZL?=
 =?us-ascii?Q?jr19FcAkCn9BTpHwZuaZKEzAlTLFmcoadE7vZtUZGvEWpHowSEQP1lLPOQVK?=
 =?us-ascii?Q?ZWKM+LpqhA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f897ad14-3fed-4840-7d13-08da16418e2a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:44.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HD0xCzFbB2wsWUXF21S/8UrAnKVM8FbzxePndEqaPtELFKtsX6z93ZDhcUWIcYfMq7ASTH77Gu7NdD+1YkW/mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5889
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clk_csr property is used for CSR clock range selection.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 011363166789..1556d95943f6 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -32,6 +32,10 @@ properties:
               - nxp,imx8dxl-dwmac-eqos
           - const: snps,dwmac-5.10a
 
+  clk_csr:
+    description: |
+      Fixed CSR Clock Range selection
+
   clocks:
     minItems: 3
     items:
-- 
2.34.1

