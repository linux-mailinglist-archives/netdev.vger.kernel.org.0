Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C215A63A0E6
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiK1Ftl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK1Ftk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:49:40 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2058.outbound.protection.outlook.com [40.107.15.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D67A13EB7;
        Sun, 27 Nov 2022 21:49:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XId2VGU8Kiu/2QTKDzDIHhroM4PfVPV++ojz1vYAmiVmfq34ROkV4DqQb5jwOXhXjsd4Zro74eD8nxMn+XB6vOyPPTWglc44TljfRBJAaNHA/M+ba9RKDpzrmwl5UpKPDKBuJSUMsv6L9R43MssMs8DpEpXc9LIZKFRM3jbCQ2QzSg+D9IU4/z+/mrGz8spGRhBvAj6jpEOdu7M7CyQipXpIdAWr6Ht3MiYAlQ4yGtTVVIlXG0iZo6AZtHYunUwozJ0/a+1OwCkpqiPmV/PienUX1zliX3hBeIAs64onPKN1AnXiUqNtpvxI39RhkNaY57CGdiGm26G5u/4ZMJdvUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8g2j1DEBPGGaobCBB+WdxuHsbh6N46Zh+l5wnT8WPI=;
 b=C/vPVg8n7bd1Fr3JX7lXQUPhBFoloVD3PpnoPeza8iStgjun+gC946LNbMAdpY7pK6ROh54wVGLGagj2WpCBpC3rWfApVQ0JNWufLlbe0hQ7maeTyHo67OBwxDQEY5baYTaog6JMuHai+K5QiwWHZcCaXtf7oAV4hrR8R9U6WlW+A5XpW7ttuAXW0jtD3BHUQf/rYf2UDTC+JJpwgYeyCFXSc0sTBjW/8o4xHcEyuzw7vHmHpw4NdBigFh33xraggPE2XdWOfeOBzQNTcDjsF/4fQsWK2AAjibnErXhQp9nzjcpJlKCMp5EQbORxGCXj+CeGBJc3oyIxqW09llgUDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8g2j1DEBPGGaobCBB+WdxuHsbh6N46Zh+l5wnT8WPI=;
 b=MpY0pORZi97GzFHul+lMjwH7HKjyE4B9eB3jVmSZGOUf7ensVQFEtcdWkgSG+/FnvIHSDp9elGR7VHgIJZWEa3mzBnAWSzibWUA7S6YIkdG6FPw8SlSQPqalzpmFb/WDjUv/v2i3h/zM7izJkFUfd/baJ64fvm4LkLYSLo+wPvrsmj1idpbwgemuSCa/OntQfQWPo3LdRwBlgBS+XvFNcyfu18ZIY8kSRO2U9pRY5LJhii1xuF66DZQnhg7ohgCLDC9Mm9tuuO4dWrs4OQkFpk/eT3CO46/izjoyyJrRp6CxSkLh2PHRvxTEaRNy0bD3IqvUK2ClL+uoDhIsY2W8FA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AS8PR04MB7655.eurprd04.prod.outlook.com (2603:10a6:20b:292::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Mon, 28 Nov
 2022 05:49:28 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 05:49:28 +0000
From:   Chester Lin <clin@suse.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Ondrej Spacek <ondrej.spacek@nxp.com>,
        Ghennadi Procopciuc <Ghennadi.Procopciuc@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org, s32@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH v2 0/5] Add GMAC support for S32 SoC family
Date:   Mon, 28 Nov 2022 13:49:15 +0800
Message-Id: <20221128054920.2113-1-clin@suse.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0137.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::15) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AS8PR04MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: fb54f2ea-b861-4aee-d3ed-08dad1045020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKUPmmD5RQ/H38ZRtf+LOWewRTybgjHSyjpEOn3DzRhWvgTYoTzhQJwGlR73AcNJ0y9zcmX4MkNexwU7bL1mpG7frAMTf/7HWAZ+Lc2mbcLE4+3Bs7scN+2D17x8bxOvBiITvSG9B2rBwcEjOBUBN48uv3DIAEACDF/sCjfIThJi8lfba/hRhxnvRvgA2Ei3FZrQ0Sm7b2t0GYpS1dJP78AlV+kM6NJOF0h1QJxaogOHvXf2YQiKPLLXONXCEPd38nW4Y44xFp+8/do3ul/LaKoX6MA6pQy2q857b6JQWRFqml1pWbWlKGiE53piKwexYobS/PhHKrwMhlVS6jtGfFzde1PHJswuBTyqNCUznF09WXmzQeTmZBry534NxOtIluROi5qRU6vrEAua9+fYoct/+0L330Z0s+1/kI9ofWHFlZaARypJ7BqSnxKZS+aNLValfkWS0eWPSeH6oEi7hLHK/3j+VnGxpoGK8sgRBY5R9DI1fGaGXcQ1EFfWI1kh1QabcB8VUFpduwgMvfzf0CDSBTZsjairKjA3/lcLaSVWUAcZuxpSuULnzYZG6+fW9r4asR781GnAf1WO4bg324NNg/IJkhkArjpDowIKNp33gzYtv/czooA3J0Po17Z0e84Kst6Co38V8o0TkgmSX6sOhtAoDjbb6Vm0WWayfbgpp4jBVAP54YPTGjixmxvIqo8W9/AxwrYyOFWrInE8sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(2616005)(6506007)(6512007)(36756003)(7416002)(1076003)(186003)(5660300002)(54906003)(86362001)(110136005)(66476007)(8676002)(4326008)(66946007)(66556008)(2906002)(41300700001)(38100700002)(316002)(83380400001)(8936002)(478600001)(6486002)(966005)(66899015)(107886003)(6666004)(921005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K3S0cg5UkjW/YAOdW5oZRVQKZYLktpln4czq+gVpgQg2Hn1G61ZxDLJWkuhM?=
 =?us-ascii?Q?YSuHZErwZQqyfcGbZ7hs7PSuk0MbtIaUvP4tLguuaf3+gkwjrqOimqoU03Ny?=
 =?us-ascii?Q?GePfruxL65hKNb2PnwXL2IFo0dKx/+2w9ReCpgCV1Bkcq6bsHw661pSjNa5U?=
 =?us-ascii?Q?RcsPT6kqnYM11Del3hVVmTXUat6E1ch8odJoNxvjsKblbo9mawKk7jyPwu0n?=
 =?us-ascii?Q?g4hVxXISmsShmwRsNFRZTjaAt/cE+WCBXXinacYxUjX6Xlgn0KcTUwgoHPAF?=
 =?us-ascii?Q?u4UNtNgmsKqaQw1ZHrTFDfXuemKjQxuh57qwc/ssxS2OIogrgTWeLCtr0S3v?=
 =?us-ascii?Q?n+OWVEsMNo/8kiZgfZrj7N0rdW8KCgZfU6OeoURyC2ppJXJX7RpC3gyiuRbp?=
 =?us-ascii?Q?tBEymxw3b+LTQSoYpljnD82XzcNMwA0dISmiNFgE+HvYoTUxLlflzDcOgroo?=
 =?us-ascii?Q?fXU/KR07Jl3s9kkE0tsOS/hiqjl963kLGdw07K3iUheFfb2AunqK3qu4eJI7?=
 =?us-ascii?Q?k39V1jiSr5/IxtDh5qk61aWYVLO7nmWgT30D7fDyPMKEO+XpBkGTBdtiKSZ2?=
 =?us-ascii?Q?KpGJhTdgGQgMqCeJFApqwkZmIv6RfAkGzSTXdEmjiC1pOxTC+OOBo8FuWiM5?=
 =?us-ascii?Q?FL0hPa91z2XKe8LIOvD+G/2tuyn96ZWWgLpONbekdh+JEZfQYmXq8vOhtzXc?=
 =?us-ascii?Q?lBGJrgCDfva34lwYpejmD/4u0FlDiZ8vyGgOhyBaX8ZdTjFh+ZmtGuawzEjt?=
 =?us-ascii?Q?nSSwv89+51taRaVk2RcXI/Xg86y53FNIhqbqrBFoLvGZ1ShcaG6oyjH3hcqr?=
 =?us-ascii?Q?7iYt1V910gKH9d0Ec1/eZNjLUgBtV3634OAsRSFtfx/CTZntoRmdcfI/SaZL?=
 =?us-ascii?Q?zX7I2lI7CMahUF7BiotSKU+iTTNorxDFrDu370loHrKtXAAqKIcNPfqBRQiw?=
 =?us-ascii?Q?uTg8xCT8TqqCFOyYsckSimOSf9p6lZu0bW2aU+E1Sy9B5FM13yqK7QG1Bpuk?=
 =?us-ascii?Q?lx8JYd1CzOMLbkyr5z9iWd/vEN69BJVSyhG7YHxeMznvBawSRCKB5tkBrBYc?=
 =?us-ascii?Q?3pF22J7A210Lz2yUp0X6sSqspll46v50REBq+HLXI6E4VCzul+wBJ4EWUBmq?=
 =?us-ascii?Q?19w/nbZNW7+vIEq4CayY4U0f//x+aIe7L81c66R9QF2IiloYO+M/Er+hKYN4?=
 =?us-ascii?Q?K8kDRhP2VRGerHHXGLbOcGym/tLMU38EuuT381Mk6Y3tKdeICY3oZUPY/m4N?=
 =?us-ascii?Q?zc2/13L1Q84hgtq8Mw4OFZhDI6BiEA5vPAO/RLgioJNoniBsXnvwA/t5GSF0?=
 =?us-ascii?Q?cfXi/F37l1vwBb8n0sd62p2ZjsGldRR/GkJw0wSBPt5m1PlVckflEWKZUisL?=
 =?us-ascii?Q?CY/hKusCwMY8LS6xMubuT87th1Tf+FTgEjLweSRWftOB6Ujja+HLwYqRuIpA?=
 =?us-ascii?Q?8BF/Qfr7kimXCk3rO0X643R/kgegFNS3DLZ1oalKruNpRy9wysTL/URgGEYY?=
 =?us-ascii?Q?7pp4Ljk2rxoIIHsUCeVfpGVMicuGW8gxjbG1A8yki/JxJq8hxRhM5wGBgx1m?=
 =?us-ascii?Q?bbkGJU+OIPS+i8qt1PtfU8mLJNBAAbt9FxX8GOX4kQitroU94k3CbfASx0a/?=
 =?us-ascii?Q?WY2OdUG1vYSXtvIXrs6JjacnI796qL2+GdqAA5khfRfQ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb54f2ea-b861-4aee-d3ed-08dad1045020
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 05:49:28.4030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMLEqk8y5Su4XLZjYViyA7cS0aipEFlmmRlpPRCFwZD4aZ77KK9pj4rlBdky0hjv
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

Hello,

Here I want to introduce a new patch series, which aims to support GMAC
functions on S32 SoCs, such as S32G2. This series is originally from NXP's
implementation on CodeAurora[1] and it will be required by upstream kernel
to configure platform settings at the DWMAC glue layer before activating
the DWMAC core on different S32G boards. In this patchset I also introduce
more register fields needed by S32 SoCs, such as higher CSR clock ranges
and cache coherency settings. For more information please see NXP's
GMACSUBSYS Reference Manual[2].

Currently, the whole architecture relies on FDTs offered by ATF[3] on
CodeAurora to keep the flexibility of handling multiple S32 platforms since
now S32 clks can be triggered via the ARM SCMI clock protocol and clk IDs/
settings can vary according to different board designs. To ensure that the
driver can work properly, the dt-binding schemas in this patchset is still
required as a reference.

Thanks,
Chester

Changes in v2:
- Fix schema issues.
- Add minItems to clocks & clock-names.
- Replace all sgmii/SGMII terms with pcs/PCS.
  - clock-names: tx_sgmii -> tx_pcs, rx_sgmii -> rx_pcs
- Adjust error handlings while calling devm_clk_get().
- Remove redundant dev_info messages.
- Remove unnecessary if conditions.
- Fix the copyright format suggested by NXP.

[1] https://source.codeaurora.org/external/autobsps32/linux/tree/drivers/net/ethernet/stmicro/stmmac?h=bsp34.0-5.10.120-rt
[2] https://www.nxp.com/webapp/Download?colCode=GMACSUBSYSRM
[3] https://source.codeaurora.org/external/autobsps32/arm-trusted-firmware/tag/?h=bsp34.0-2.5

Chester Lin (5):
  dt-bindings: net: snps, dwmac: add NXP S32CC support
  dt-bindings: net: add schema for NXP S32CC dwmac glue driver
  net: stmmac: Add CSR clock 500Mhz/800Mhz support
  net: stmmac: Add AXI4 ACE control support
  net: stmmac: Add NXP S32 SoC family support

 .../bindings/net/nxp,s32cc-dwmac.yaml         | 135 ++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |   5 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-s32cc.c | 304 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  10 +
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   7 +
 include/linux/stmmac.h                        |   9 +
 11 files changed, 492 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c

-- 
2.37.3

