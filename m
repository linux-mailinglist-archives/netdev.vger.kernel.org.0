Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5AB506AE9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351652AbiDSLjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351386AbiDSLiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:38:21 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2073.outbound.protection.outlook.com [40.107.22.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806F531341;
        Tue, 19 Apr 2022 04:35:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoLIV7PkTNfvGz6OUqtd/a8KiNMQWw7qGU/fsJUFu88cMgPeyMah3Afvot8Daa8oFyIRYiKJp8PvaN1S1gVY90QBxLVXAv0O6NhZc3x5xdLmjHT/wF7zYmITCxT1p/rOiM3Y0Wz2u7ks+Lgtlbz4mXgZVx85znkOikLA15l8vS5hpWC4eTqqkcC58W44ibC6Zk79WdoIpfG1oIfE95jfrI7E/NOGlca9qMLhec4Swwbnp2/ZSErMdSDpOrvHUUVW4OVHxQmn0aU5N/TTg/A26WWHM1A1VJypELichr8DtylHwbsRzOcXEJR7TfAvKIw2o0iPNBkVqXiQMzpNXqQoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MI3VSs++a6swmImjpSifoHqNFw8+pyQi/hJCmjShNQs=;
 b=jr6b14vjrN093ZsRjCo7DvX2dUZjdDJLDn6GLAwqHFI9PfHI2rEzwPlsqucxuYeOp7MieyHMf+luM90JY5KJysvYYJVdPuolkbnerG7CBBVHKiaRG5ExR58efDGsnKbLJ2WQ/Ax5cMwo+y4QM58M43xdEGCG6fhZrKwBxw7KZ78WIPL8tclP/ey5a9jXYSDzbzr9kYotO5F/x6VrNZMGHQrLhwdVxP417mbjVVDpkV6Lh6vhTDbEhjfbr0GfD5AIPvUmno7h6QSIzSWfQ146NNklZSXVPcmu9ulEwfWo8KCwkacz32KF0JndnxbDZJHAE/BeYatrhvr/P8nalae3eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MI3VSs++a6swmImjpSifoHqNFw8+pyQi/hJCmjShNQs=;
 b=fNySiSjBqIpnMfEmNnDV9wptckhLSF243oH1xojfBwtU+gpzeP8RNlvRsFqo9XJ+gpuc9DpQfLwEsP12mt7Ed81AvaqEvi48xm3yJOcThl+W1GCZ0UFcXuOJI+F3jmvcmgAh1spB/4dz3IpFvxdHBYn+9sN4DeRQdN3FsRZ3dLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 11:35:30 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:30 +0000
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
Subject: [PATCH v8 00/13] arm64: dts: Add i.MX8DXL initial support
Date:   Tue, 19 Apr 2022 14:35:03 +0300
Message-Id: <20220419113516.1827863-1-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c01dde3c-637c-4ae1-ec56-08da21f8b56f
X-MS-TrafficTypeDiagnostic: VI1PR04MB3054:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB30547CAD6E8D1BFF36C639A0F6F29@VI1PR04MB3054.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nPR4FsfhO0QHOxiFNwzdtnYBhFK7NGQv/DHYsn0eisWdhHowDTUxkFoPV7Uu9GifPe5NSN64Zfqhr20AmP4pkWSPp0PVi/nXREHrRKoUAJadY4b0u3VAy5m/K3Xc7BN9hpRigvUFnSWDp2igh00Ym4tOg8CVPVZOa+DBjyqOUw7SZSlbAq0GDmev/NOeDZnQvDGA6d4ZnGB4NlQRsm0xoncd0e8KemAdHmT0Ng2n9O007gMRyvKfCQD5ukczb3ANiQjjxhnb/4nlQTUdajywwr5h9seDoOL2HSBLvFbuW/NiyZ+8ndcIBXCHdqH3MAyH3TRfg3wHpCVyPJxSNhwagVF8QZWo/mrUSEiV5t75A0vjsbZ/7ypGS1Q3WZJcfsNqP/mAhqxc5TS4U/RRM4kM/IYrd7nUS582bBxutKAp8OnKqTaKEqx8HxhVGUhApXG7Cn3sbf1VajsT6KNpq6U75/Ipkty2NqPlYStQEYRXV2/3PsXc0Nqj3gQW0nERiPoQGzM9Z1NUCIp7ocJ5PPbskNRNi5fFyGIwv3vbSQhn5MUJmTop3mVZQOsWe/NbZRsStil4bQ3FbDibdgVm8XgZ5mtn/WQd0d2pbEJM5JDgTz9FiaYfI1BxVXj977nd1ZjkyUoknj9rk7VQZCwtzGXqoi2hzFfzgQiBCk6MZxACtCWakQ4/MaSR0LKKFjXOED67w340PQo57LTYTbT0lOTlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(38350700002)(38100700002)(54906003)(186003)(7416002)(26005)(8676002)(316002)(110136005)(6512007)(5660300002)(83380400001)(6506007)(4326008)(66946007)(66476007)(66556008)(508600001)(6486002)(8936002)(2616005)(44832011)(6666004)(1076003)(86362001)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ct7ZCwF/IQMFjSTbChXu+T0t8H7IdU66qitcCUEMKjPZSWZYJsD3vg/OkpeZ?=
 =?us-ascii?Q?Q9LSQsP5SbcCv8qAAIIE0eBTwG9AeHPrG01gcS4dUcwuCr0kqs4ZUtooDN5b?=
 =?us-ascii?Q?CZoo0jYVePr3VuIEcAsKigfZuHNDelsExnbIzOgMZEFGlvJNpXPDweHRBmCT?=
 =?us-ascii?Q?WiOjpcy0BiTM7iLuvyH1a/g3J40rm9/5X0Znavr/WsfYw1UJOjq5bR0j5aWQ?=
 =?us-ascii?Q?29MSCjK9sF3gnFFYyasP2l5acOwa/I78hoqIG95El/E2RYp8tlcCWdu2qXwO?=
 =?us-ascii?Q?aGaT3ZChB/Jpjk7TPoKYRaPI6QRawPpKyOmyi8HHnoLoPeGs/Mm0b+rZFpqj?=
 =?us-ascii?Q?lN+nIQU7RWgcEtDFqvK+iaWwo9/wigYwqL/9qkSKKmtqNwn3K+vy/hEZK4gG?=
 =?us-ascii?Q?ignLKGpX+/KjRLI8RnbxqmzwrhpOrSc0aKlYrB/LlB40IWd9fZvhHBl8aPzF?=
 =?us-ascii?Q?YVOb66OWngLhK2CDro/yFf9144DOh8U8i53lGq1ffbDZNtAf36EKpj8tXSIk?=
 =?us-ascii?Q?8Dgfk368HQj6kBiHahXuBXtfhwVAJv6BZaz6DMe9HekvMdK6jLXbeLOpeoYb?=
 =?us-ascii?Q?kXIVpDdgG6IL5EDMeOIVE9uZ4ZcUSs3p9E8yEb0ghp9BxDZeeV3rPrkURAHc?=
 =?us-ascii?Q?noYJDXo7hwLvdX35O3pNh785CNeMuMwpk8XTMou8BYuhoIQw+mB1XGl88i6E?=
 =?us-ascii?Q?N8WALkz2e8Ibekr/12KGZ3fo3YgCZbzUpxPpHLqIjw5InejqPY5xy4LIPnBn?=
 =?us-ascii?Q?hYphqTQ4XxrtcWgYvJKkMqU8sNfFl9qHeHftulWU5okTeXUYU1ax+H2iRbwJ?=
 =?us-ascii?Q?3+eI5EEwNacOqsdX/XVbKKs7yggB1Y6enM65RYdoMHNfd2VgVJLOVPIZjZyQ?=
 =?us-ascii?Q?8FyrF8r2mj1i4yB4CBw3K/nA6KyXuSE0p5L3SrSmpgGWuZPYxrUK9o7dZ6wZ?=
 =?us-ascii?Q?rXWPa93464WQDTq3y1CxHg8IK1HD7t584mMdWEa0OXaFlVPqBaFolAKPy8Yy?=
 =?us-ascii?Q?uIYwnbpXBgxwe8WyAmAKumbWIWjOYT2K4tnIPLBy2j+BLmqUOvyqz2U300+w?=
 =?us-ascii?Q?1qphnLytJwx7Y94/WxhsLdlJSmWzyor4uF9w1jn254AhQoa351ma8lUJRYsk?=
 =?us-ascii?Q?CLnNNfdyDM6745Z8T1+gXAK/Qd6DKj7LOSk5qbgqQdF8PooR7/ainXMgVySk?=
 =?us-ascii?Q?6KU1hepTlQIYmKeHWaFs+M/O5Ra7NcEf9I9lMqdq6J8lU3w9U/Qjcb34d/jU?=
 =?us-ascii?Q?ZCsKSbPYlZC3cR9pV1AwhKLXR2/Oh39OZwrAoAQ3/4buvay7mVbDAlPmFeCP?=
 =?us-ascii?Q?P18Qh5L1wXqeQDGLn1Ip72CQi6leymoJFxiWJjTvqRXWLUn9PZ7fAT4CBSP/?=
 =?us-ascii?Q?vHfC7FPLQn0ok/qHvWdMZ7n72KOzgZQlAgqdEqpEOn8yJIAG7WV0jsdYLFs4?=
 =?us-ascii?Q?AtTowNVeRpnBtA0mk6WJdyNbGHOTl2tW2PvdXi6nu02O9dEzH6TP+E2wLzyj?=
 =?us-ascii?Q?zdQ+7zmxVZseHe7aSynj4GmCBvY1KKx2J69hPZpGs3QM13CqvrmLI7XfVzoJ?=
 =?us-ascii?Q?Aff7AUN1zLojaeRigODlWkhTShm5SUQ/chHLDeB20nvY31B+I/eGOhSLPDPs?=
 =?us-ascii?Q?cIfsukcUDVF3BUQTUAL4I9OuXnG8ZB4iLSarOTPu0qXGZZxy1w3+32HbDkk3?=
 =?us-ascii?Q?1WUwS9YSvwF10CxZekHmgpprevBFh+n0xEw8lP2ANhqwWj1SRIKsfEVQbdkU?=
 =?us-ascii?Q?djdT6uudBw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01dde3c-637c-4ae1-ec56-08da21f8b56f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:30.7213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toDblPq+fnWlWOZFIgjA1K3XVvftKZLAUaGHiSV/hRBEoAJ1DSVaiW9KtjNXMuVddaFNgSpb+3T1uH98ri78Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3054
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v7:
 * added newlines and fixed indentations suggested by Shawn (see v6)

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
 .../devicetree/bindings/arm/fsl.yaml          |   6 +
 .../bindings/mmc/fsl-imx-esdhc.yaml           |   1 +
 .../devicetree/bindings/net/fsl,fec.yaml      |   4 +
 .../devicetree/bindings/phy/mxs-usb-phy.txt   |   1 +
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt  |   1 +
 .../devicetree/bindings/usb/usbmisc-imx.txt   |   1 +
 arch/arm64/boot/dts/freescale/Makefile        |   1 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 269 ++++++++++++++++++
 .../boot/dts/freescale/imx8dxl-ss-adma.dtsi   |  52 ++++
 .../boot/dts/freescale/imx8dxl-ss-conn.dtsi   | 134 +++++++++
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    |  37 +++
 .../boot/dts/freescale/imx8dxl-ss-lsio.dtsi   |  78 +++++
 arch/arm64/boot/dts/freescale/imx8dxl.dtsi    | 241 ++++++++++++++++
 14 files changed, 829 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-adma.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-conn.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-lsio.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl.dtsi

--
2.34.1

