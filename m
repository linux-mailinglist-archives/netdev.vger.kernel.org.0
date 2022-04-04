Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134714F1667
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358542AbiDDNsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358425AbiDDNsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:48:39 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40040.outbound.protection.outlook.com [40.107.4.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D4255B9;
        Mon,  4 Apr 2022 06:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8aaXFD1xjKF0I7sUpwJqzf6FIEQWdXP4RLyVqVqIu9zJYTgsiD3SK6p3pnCaa4q06hf4gZ9Jx2c84T2i8VctgtakPAtOmI7zHE0bRDqRuyRSUL+sMqoY78ecGVy7r0HebgRnbnLWW3+1G+7JMSDUWfbFxdaw3uAP9ehk/iRrquhV14cvnq+IdFI49muNBeUZDRvNYDNlOykUIl6+FHv8+PKFjpIQG0yc2LmOOmZPcnKIJyqYh8uVjXiq/iJ9LHZKFtmhNAmpU8SA/92bifftildMhy52Qp9fo6SBz+lZCscs5CwQJ0hxArg1APMoKzOmlppGVQ5Hr3fFgEjqRnv3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7orBCiOS031RP3iIrM1GkT9chRaacpZBi0oUVHF6Ps4=;
 b=OQfy3cWFOjIDA/9WbMXTQdRYbQgBGKmlHmL3gbi8A1pSAryBLuqbQfjdAx0PsEeDEPs7yMKqzcyfUknF/MYboK0EFMbNorDbUDB7xR1D7ldeNzKiiBGMNaZ6wWa5oBnRT/q19eWmOsHQ7bTAM10mEuQiLUM95n6szhomyTHK8FwPGrKcZpCS6K01MaC1Kt9vguiHiJ07iwn9Gadh72/udzButxOHQI+HLQOeMmQF+oo9f6lY5gkZE0I0/bdhifElYRyPtohPxzOrmnOOYH3Qux4ScsrubrXdShbV71Ug5DY8D7F95AzxTHO+F8XLlYOPZjD/GpM/S8fGZ1HG3heErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7orBCiOS031RP3iIrM1GkT9chRaacpZBi0oUVHF6Ps4=;
 b=o54WsuOvtlh7OQMtJPYwPIslXl4LQWfKe2rWA9aKSGCOon/iMtJuChDdYAswU2P+zgvEVqnB7D5nSHtfNEhEZBJ4L+8aS5EBjPg0R65xWPSr4xzTmUI1oQkJt1VWsQh13azBVhiJKRhMhOLvf//13nQXZTQfOPjqRqVrXxdVCp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:37 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:37 +0000
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
Subject: [PATCH v5 0/8] arm64: dts: Add i.MX8DXL initial support
Date:   Mon,  4 Apr 2022 16:46:01 +0300
Message-Id: <20220404134609.2676793-1-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::34) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00fd6b2a-9bf2-44e6-701d-08da16418a3c
X-MS-TrafficTypeDiagnostic: PAXPR04MB9218:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9218D2897FA0135728D96912F6E59@PAXPR04MB9218.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKtUn2pNLlC2mp4En+IbFfIf105jo8G3t+88v+JAN7ZciPG5qwig8VAdDkq7vpLt8hK7qB9wGXvVbaqHMMLM8UbO1DT709I9i0LlmSaiYQwKyXJ70bnSrwYYPBCHOenpUal79pGnwJF7QrowYwrVdDbXVCz2hwXzDCJgfp3zA8SW+9tcEocjVWU9CyfuqQedZFH61OrUH+HNKhdqWbQkDSo5YinWWoRQ/LPmbHARx/nBwUA7ErcXV7ISzdupNBQ5DtL83HnXr49Ezk8x9B8NuHGJ5ANL8YSgz1YWDLAjqdkZdHYy2vrFQL9+8ZF+L86WXENNjVG9j02zaqmI+aalan1tFpCgzh5tId6sL+tzOi1wojInt/UKv7sSGuIM4ujZYEF4b33urinv1mAbUIML45h4FtWkNqh3lvBiRvXamsg/Rxk8vvAVU24EoAjzdSlKjcikceG/NOFu8QbQ9vAOzce7CWCjDz5q+jMwIhwDxPOc0TqSvsOztPHASd7tD81F6rRwTeXpjROD/FD1lQin1ZfP+ENSE6D3OMFIiwB2b0gpYxK8pRWTS4iFZWHxsNPFM3dvRxRpzLIxAjEymmkznUqqRcwGWCTg6I3Vy/QRcO3Ze6D2etKHPz4doxkKpTYuILRbsCmvBrdNq+UTXvYgHZdS3ZQKvFQpkG6j8D1Bw66XJlC0fUQdBcFWXSNUeM0xTy4UeBFonYylwz4D8ZLqzQyYlKQOaocSsANNPDNRSHee8gFNtGf4Y85d/UeydYhkpA3eGc3QEL1ZTqjW8QD82IG+UCgFK8kDzP89B3lcRxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(966005)(86362001)(6486002)(2906002)(36756003)(6506007)(6512007)(316002)(66556008)(66946007)(186003)(66476007)(6666004)(5660300002)(44832011)(8676002)(508600001)(110136005)(4326008)(38350700002)(54906003)(8936002)(2616005)(7416002)(1076003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hbicb1oMDhYPH6asjDgqQZghoHna2miDCscZLMnW8P2OdrHVj48jf2iuBpx3?=
 =?us-ascii?Q?PNJXQCtNXZ/LKmBIwaFbAdME1GV4x9UT/gOoTVvo4uBjKUkSP+87Ru88kywH?=
 =?us-ascii?Q?8Xo1xt+mZ49GN4XPVTQIgXrxfyNiNayA8Xyl5WuMcLOsvJt3mHM99g8r9iN6?=
 =?us-ascii?Q?/YVrUGw+mt8ggzAtL9bVBU0RPKQxEgIgNRCzOq7rUyOgu1kfZRYOqIBrCIw7?=
 =?us-ascii?Q?DnPWbP7s4uQPA4O0nN0LJKyIoXtdGMFENYo+mDh48T9w7CJLQ20jCgJkHkSp?=
 =?us-ascii?Q?WBJZXew0etE22u9fUQ0XcF47oyJ6j2U6ZBLFqy0aW/kwrPPhAvjntvrY49wn?=
 =?us-ascii?Q?yJDQAltp8jv6B/hbMFtvfjHKrBt7Jt4oYf1Kc8sx1Ikw/WVDvS42BnNLSkYh?=
 =?us-ascii?Q?4ZtYs0zIE7lsqMzuRU1RztbtHUnPdEQQQK1fI1FnuLS6kYJUcEmFu08KdO43?=
 =?us-ascii?Q?WF46tHu4B4DKv40UU5Db5D8IkEL4/C8uaIWPwZMUgaJe71DxbY446z3Cengn?=
 =?us-ascii?Q?jsatDCgzzA2TBPWuGPJ2qGAHfjjVwbTfarAHORfK44+7pzDMKrVxudW8UUWE?=
 =?us-ascii?Q?SkUANCIdNi7YeYJXMoapYKF5g9YNzrF16/V0erZQjtIZ61LqY0eAwkretu4K?=
 =?us-ascii?Q?KbIvBUZW6x7nyfIR+z2MbH9AMMo5hse0g1K68EVk6ozCVLhDUwgSKS7miM91?=
 =?us-ascii?Q?g3y8834aWliTQ7aEhCjFcJhZ7x3MPgW+G4lRfKcZawyCKt2KmS2YzO6HL3k/?=
 =?us-ascii?Q?jCdlVfefdGVzNgISgLmjRu3UzJIAJsVcYeo5slwE+cVRkYdCJKeUqIKNwSGf?=
 =?us-ascii?Q?uo1wzmPRhvy0u59xL7Cdcv/Bh+DUf4hEQF4MFnSFvfkks7UsdcfatUQdTc7Q?=
 =?us-ascii?Q?qTcRJfBvYf79Il3VtxxgEodIfsg9qA6SySmPQR2YaExOuUNkP0s49tN8DMC0?=
 =?us-ascii?Q?9fDMSLSGCqCemwlQY5XK+rfos+ommqN67ohOLqo+kRz09PVF82VRX9C+txuf?=
 =?us-ascii?Q?S29soSrfwzdRqTmxNvNx/I/wOPdbLcizDsu143gI1PUMIgC2CucMn7KW5oSp?=
 =?us-ascii?Q?SpkiZVZ1w9IkrqZVrLot8rCF2LXR7quuvgcBpk3yq8Ee7ZxnZS5kIE4lyE2C?=
 =?us-ascii?Q?Uc1zqtkGppW8yKDH6VPCcH7zrKySKqtL/3dK+EXeYQD5ErrvDh9NOz+bxUiv?=
 =?us-ascii?Q?OVtDyg5KuPCwyZ8xFF5jaY9aL+/Uk7P2tmxSsl7pURxi7SDcM9lKe4ow5sui?=
 =?us-ascii?Q?iRn7gUaPoAyP0MhUYM4wrZS/RfXjGNEoczH9VoNSomhN8fWpawsnW4oB0x1k?=
 =?us-ascii?Q?GedmBFlfUx9dHwV1egNqPm7aj2/8d3LR+GVq7H4jSesWevXNYUg3fQsiGntp?=
 =?us-ascii?Q?/mXxFFMhfkwlz9UHeMM4i7ctBOLKUZVXJhdmTEomuOrWgiqMiexP6ExC2VUr?=
 =?us-ascii?Q?uIZeiY1gACO/jKBexOH3YYFU+erHKL7/FFMyH+xbSaPYH+QqDxQFUd446rZj?=
 =?us-ascii?Q?pa/BHqtUK1GyNtmsFZN0Is56zM14KAYfkDUfFe7AbL1lDPss+q75wze3z+3x?=
 =?us-ascii?Q?kRtX6t/cUZtVsHU+z3XHrgr3bsosvIxJro0cYTo2vatcocaAqR8l9Ij7imkk?=
 =?us-ascii?Q?+q+44ihbLtQKKKNmR0RVTtT08iWo3A8+6+jT3o7bCx5J7l5jA+0/dUgOimJe?=
 =?us-ascii?Q?nQnZwqIRJ0FA/DxdQ7nMJZtuYGS9E2QTCT0Y4EqtO9mV1gmYB5VgirGMdFaf?=
 =?us-ascii?Q?A2n+wOBAbA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fd6b2a-9bf2-44e6-701d-08da16418a3c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:37.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgsrgZ9xV6EiIF1apEOUqmT3EfCXo26rrO/Vrj6tRPMX9iKlS38sb1708hdfOKuF1/7ybcYB4UUrpQzBdWxHxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9218
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the v4:
https://lore.kernel.org/linux-arm-kernel/1639680494-23183-1-git-send-email-abel.vesa@nxp.com/raw

Abel Vesa (3):
  arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
  dt-bindings: fsl: scu: Add i.MX8DXL ocotp binding
  dt-bindings: net: dwmac-imx: Document clk_csr property

Jacky Bai (5):
  arm64: dts: freescale: Add the top level dtsi support for imx8dxl
  arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
  arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
  arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
  arm64: dts: freescale: Add i.MX8DXL evk board support

 .../bindings/arm/freescale/fsl,scu.txt        |   3 +-
 .../bindings/net/nxp,dwmac-imx.yaml           |   4 +
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   |  52 ++++
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 135 +++++++++
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    |  36 +++
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   |  78 +++++
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi    | 247 ++++++++++++++++
 9 files changed, 821 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

--
2.34.1

