Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A3E4FF4B5
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiDMKhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiDMKhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:01 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2B6B7E0;
        Wed, 13 Apr 2022 03:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPpNrDKb4RIvqcIIOQf7mMj/eN73DpDzPeT/nZJ5asstzG8ZE9SZAZd6k8I0MW1dqpDJ0H0NpC+vu5beyCvdJ0cSrQSQLw3yXN31bi1I0+U4n9tMRdlRuVQ1a5U3VNW/ch6Xb5A4s6w7x0lgWG+kfA6y7Z5kXrrf0MMtk3I5L1aF2vHPR/cBj/IZecBat7RylYsZCUDZczgS+S8TuHqt8+tGN4yIOn4qKjiLVyA3hCPkQp5pG1poKs8rnH/hbPue8P+hxWeQrbGkh6iFGhqlHNUulGTX4CQxN9kXINU2Q6swJYhF3+4tYAScAsuGAuXYavYXaKT/MEeEawM4Sjm6aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zH0fBmJ8vS9g/T/kqTLSX8mj95ftY43JlQ2jZM5/v6k=;
 b=kud2+eNW/rYWJ8ku6XfaMMg2FEuovt/aNF7PDEnTRMSAPK/F5hWFWxUtUfpuYMXzHxPwX684JGjCLNYt0CSbRHONhL9VKlnaYIUhz8ol5b5nYzictBYKmwp3zfH5KNMOy0LvFJS63QiRPdKNc8styJdm+MM8tpWEXS/YrBx4m58S5NDgKX/7+lMdnR3Wlweg388/eKlImAhdDwwiT/wUYNIyGjGwUO84Qw2fE36EuJp7+BRpsh+/FZ/b9lBNZkHP+pkKf/G79yrMjuzFH0djiT9gUPvnz5uS0HnmFKVIrA0JRNqNJIYhQMXUjewZWzP8LYZ9C9ZP+6akRyUnGekmsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zH0fBmJ8vS9g/T/kqTLSX8mj95ftY43JlQ2jZM5/v6k=;
 b=kqaAYLjgZc2xhGsiRBx9qEWLRI1sdmCDJdzPBolePZOJ6nwp1Oxn4lBO6Bi1QNGNmIoIKxQPAO6+IXOAuZ9yNjJP2/UgQl7CPig+zr25JIy7H6M7yJBsVsNRHLQDZwisROXVNgKjvhm8bpI1YP/fExORtBksAdUFMS62uoVitCM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:36 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:36 +0000
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
Subject: [PATCH v6 00/13] arm64: dts: Add i.MX8DXL initial support
Date:   Wed, 13 Apr 2022 13:33:43 +0300
Message-Id: <20220413103356.3433637-1-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 389b128d-e6bd-4478-438a-08da1d3934ec
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8691266C6BECD4C89C23968BF6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vh9CmFf+C7HUVYsmiOe+PSybltQkWTgoiWZE/cODsafx9CbLbNeMgeYx4Zn41sKrx7pWM8zxHwJ0CBheU62SninlGjf7UWfVKDA9royQ4xD1U3nwa7uzWuMW1BvZ5UN0CXTEck6G217ydcfcKC4D/xGhqmnoQm0QSjTJBKKD/xQF63pZoG5lEC/VBGJEKLi3q92esCwaW03tAzI5skIKYNg00z91lZD0Fq+902wE4MUkB6oIBXfKAdgHWARgbf7hHzNEcPMXt3RKGtvKb22RDqtB/NIPS/6BhOzZ70otgbD6Pl/+aEKQhdwDm/34N6IB/yiO8KMbXlhgJjUVahBx739MuBbcPtiWTAoFoAVXLP27OiVDERam6J/hCPfucT9sXIitNCxuP3YhUJvqDcabx+oFpTQ+sA2GHuZyXoGLXBfbeB1A3skzM6d9YZIKZIm7rbb6W/w8YYuyvW9GVNRHmlvmx1KJRChAZFu1A25oNmbVPd9ueymXF25ASGOODNBrGyPnJeEwLiYGeit05qcNaz+Pgi3XrJ/NpRhPbrga6DyIKOrhReVQQpF+XBlrcTLl5bKmU9k8tccmPHYnJT5bjpv7J+4LhsgtexZlOQwEOukUAELMdz3UXPJpbswY2GHkiFIMLPPV9ZOpcXao3lxX32DCTM5O3+MLQg3h6XBJlOCfmXb49mKwbse4/ZTC+fO8X1XDAbf3W+E7MevT0O2/Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(6666004)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uU/slZoP7lQAnJLfWkesxIugvFfP6P9IIQHWuxl/PVpDgBvqPfesS+bA/I5Y?=
 =?us-ascii?Q?u16ZtuBElaHe2Am6PLB1pd1o/qV+VvVcY3MI7qUh2dobOq8E7Hw60NXwrA0W?=
 =?us-ascii?Q?33A+cAI38c52id4IaU9BkJAnxPKnBye9PopCeYuHjrBq91BOI7cO9BZlwv9x?=
 =?us-ascii?Q?QQYrr1ldMRGYlp7PiQXbYAz3/Q74PbJgA9twrkOn3YSbwXYQ5Zl9ZbUyJtzG?=
 =?us-ascii?Q?gWxAMpPKPm5H5jWoqFx01FV8YF8Nff9uCBQDUaRG4uiOUismnXZ078ozkSZd?=
 =?us-ascii?Q?6YgBPAfaW0I8GPO5vhG3pS08n5dfbkej6hD6RTQSFeFk9hKqdE7iuTCjZrry?=
 =?us-ascii?Q?zUX+A+CTjHQYhPuVcd6Y34O9g5CZTZnV9mWCRfr3pM7VigI2LZlDStepQpGl?=
 =?us-ascii?Q?Gwg7YePj4TNzOnQxOjh9X5NOMT6t76YuBnfsRaoq5agEHKokwYmbQQ73MUPO?=
 =?us-ascii?Q?SgMwT+2eZrHJjw1HI7DcrdNV/1ZT5+xb1PAsWby6XVMOsn44n0x5XY19rmem?=
 =?us-ascii?Q?2PQX6M4DceDHZANeAW0kWY/IVhX1Cv1PvwYIIIHaWpvU/XBjQC9reqpZDdqG?=
 =?us-ascii?Q?a7STQ2wW+AtdbJaZD90sl4OFJpXXFl9wIx87gwU8ip0pNgXlbCYRzgJuVCs8?=
 =?us-ascii?Q?uomz+hCPm1EDNz3latpuDkKLvKOmqE0pUVCZWGf2OpVmehuMhMoRYPVJ8JlR?=
 =?us-ascii?Q?b7bgL/1mixHgPRIB3CyuZFuWF1mMM/N0z/LPi3d8/M/MStOJhZo/WkmOdes1?=
 =?us-ascii?Q?NPnGuBKAVNM7i9gepo+JtYY/DI9+MVopRr9LoYtZ925/+GoTEKyonfHQUTA5?=
 =?us-ascii?Q?AhmG1tFRRhrxtWxEJQpnsW3e6nWo/fgyraEyaXsvENbIACnLHVAS1cNsOcQ4?=
 =?us-ascii?Q?msE5fEeQJX6ARONDr6th8/POcquV1eVBLhbe2x1vyZ8NBpcsP13Z/lF8yTno?=
 =?us-ascii?Q?yXfWw8b7d01dWkffI8I0/DKXG89Awc5pgLqXz1uaio5Ewz2YgsJn1zw99KD2?=
 =?us-ascii?Q?oAoJ3Rnxvv69UIqy1Zm8pEmTWedYo9lb2B8W6RkCIOoDsyQ+7XBX0FW+p3KB?=
 =?us-ascii?Q?qOcjO6CVZtgIfT7svcS2ITcMDqVr0LSDsXfR6OUmV2JK+vi1G0kuN0PcFRZ9?=
 =?us-ascii?Q?K3WsHtOrFJgZIuRRAKHZMU7G38ZYecPjbiPgq6BuieqdelcZCxSZSKEXDLmd?=
 =?us-ascii?Q?JtftvxHurT+lB/uTk+ff/EGbmLCtdDTRUMkcHGN64J521z86rGd64mVoC/Kw?=
 =?us-ascii?Q?HbfBbPTyrwkdh/EVlxzQSnGNcwMFeai8TMGLwWAF3YjKE1tDa4oDfyVMQHHk?=
 =?us-ascii?Q?jdmW441j4M9Q5g18CQMqH0Zt/3/aI0gw4J9r8xUQTX6RiyAqayAzhqzXsSda?=
 =?us-ascii?Q?qZHzi00/txhC9fMzB162nnmrfteuUqkcBMzvAM1bQxSSz/uIUz7lxFlFvUGs?=
 =?us-ascii?Q?XLNTkwKbY3TpyUggperYtmbdPRI0a1XpPN6SfBfeEZCNFo1ptJhVVZAWpZ44?=
 =?us-ascii?Q?n2/9lOLhm+uZoP1IuoAfU8EIt7IJRl9aD67vlVDz0cGZ+pv8zwKxFjhM7u+8?=
 =?us-ascii?Q?4/CUSzxoECS/JgIaJZzkJbTOcCIVV3LcHa4+LBIHNAGVbXJbm/G9xHVVQz3j?=
 =?us-ascii?Q?JWRo9DnKMVSTeYA3FNjCQygpWqQFbbUtQjGRRQpm3HcACzS4nbGxh7CC84IY?=
 =?us-ascii?Q?QvfETqrugiOJtgzGupEb7rgIwap2I9dMhTj6hf/xTQEXzQ1PEHsJLJYc6+P3?=
 =?us-ascii?Q?BEDbmTZyTw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389b128d-e6bd-4478-438a-08da1d3934ec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:36.6461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBsNLr3K0pehVvG8i+Qf/TmnVeB0uS2F2FChFM57elx833WTHSEBBCxBSZLJ0fKXKR1NLsNz3SGXkUu/3FQ2Vw==
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

Changes since v5:
 * dropped clk_csr from bindings docs and devicetree node
 * added bindings docs for EVK board, ocotp, scu-pd, eshc, fec
   mxs-usb-phy, ci-hdrc-usb2 and usbmisc
 * the fsl,imx8dxl-db-pmu compatible will be documented once the
   driver will be sent upstream

Abel Vesa (8):
  arm64: dts: freescale: Add adma subsystem dtsi for imx8dxl
  dt-bindings: fsl: scu: Add i.MX8DXL ocotp and scu-pd binding
  dt-bindings: arm: Document i.MX8DXL EVK board binding
  dt-bindings: mmc: imx-esdhc: Add i.MX8DXL compatible string
  dt-bindings: net: fec: Add i.MX8DXL compatible string
  dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
  dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
  dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string

Jacky Bai (5):
  arm64: dts: freescale: Add the top level dtsi support for imx8dxl
  arm64: dts: freescale: Add the imx8dxl connectivity subsys dtsi
  arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
  arm64: dts: freescale: Add lsio subsys dtsi for imx8dxl
  arm64: dts: freescale: Add i.MX8DXL evk board support

 .../bindings/arm/freescale/fsl,scu.txt        |   4 +-
 .../devicetree/bindings/arm/fsl.yaml          |   7 +
 .../bindings/mmc/fsl-imx-esdhc.yaml           |   1 +
 .../devicetree/bindings/net/fsl,fec.yaml      |   4 +
 .../devicetree/bindings/phy/mxs-usb-phy.txt   |   1 +
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt  |   1 +
 .../devicetree/bindings/usb/usbmisc-imx.txt   |   1 +
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 266 ++++++++++++++++++
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   |  52 ++++
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 +++++++++
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    |  36 +++
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   |  78 +++++
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi    | 241 ++++++++++++++++
 14 files changed, 826 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

--
2.34.1

