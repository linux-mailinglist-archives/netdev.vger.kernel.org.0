Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7182618A32
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiKCVHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKCVHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:08 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E436B4AC;
        Thu,  3 Nov 2022 14:07:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jllPExm3RcVNhY6b9a5idDdx8wYwmCh4uSX41MXRvEwmYvxU28p8cqQIhSqqULHaJg8KMRBpnSLRiRTgevEoGSTyOPIgKjrapjpXKhQX7ml36JdaHdDXB6wVJBjBUQvhu/YR6G7TcVEzuC0sT2k3Ywhu+RoVknWohFhhnjhSgJRKXFQsnVwDjWfTb17Y+XbuHdWPtq9Ts73VNidw6x/W1T76HnR0RjZO6eGoj93CSaGmqQjwy+fsVu3Js+ipUrnBmQazvKwoBikJkiT6RuypYIYjK9r4MXcTYWc4H825K20MdYjy9ywo2VN2w+GuLUHMykP4Y19SS2+gaN+13VtqdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aWFpvKdRzDQ6VfdGXlua6p5sRcVU+x/NlwHCOb99dY=;
 b=ZlMLwSnZN9R3AKW4e/jfneaqqQ1+VBDUB3cThyZQRs4Uv0cHj+sBaKg7EUtplI98uJ0lVr+zwFmIGGoEd1T8PbHgKTtTi9A4fg44sICH08jr0Ivvp1kImkLipwSAICkLDmcGXaQ6ZZnwou6mkIVbsRrCTmSjxlPsMt0DUgGkIJJ+3IxRWL68vjAIa3R3nnXAu/j5kdkbYb5CXWQX8hGEk4IOF9ZIQPickZrVG9d/HYOnasOTrBoBNh184KO1qWJwGAfdzbHv3mhj6s4atb3Wal5Vr90Bxm4h+RYwyS1eS1frXe/NTOafy2Gq5GTR04ug2Unu+DBqPv7EktKQuBVABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aWFpvKdRzDQ6VfdGXlua6p5sRcVU+x/NlwHCOb99dY=;
 b=w9P+xS+9GrOSx4vqAjE0TTvPlyUyS1xaG5wROkpZCJ0YrGGg0bnrzV/uxdvltJnUitlPZhvI+PU8ttv5YfKsK4Oz1HqgtUaF6yE6OQ57/DYVtcGe42+nsZjrX6YvCftiAmx8anSIC36AN0szB0PBv0z52lcecsJkPcSSN7/24u4W45+sc83gEhxIqshwjO5v1Wahjku5gX/6GWscQut9PIKLOtqORES9V0u3kpD1wVJc1r/2fbwwP3cBKTRBXb+3JrPqsm9VKGP7vFGBHhyQr9/ilGEGVr+64zaGM6/H/5Ara4vxS16mRW6/mTdeovZU5Sh6Ot9XQWcKqm7dx2Hjqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:03 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:02 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 00/11] net: pcs: Add support for devices probed in the "usual" manner
Date:   Thu,  3 Nov 2022 17:06:39 -0400
Message-Id: <20221103210650.2325784-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aab1b63-6efb-4238-570d-08dabddf5add
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09btDTIzlLeBlMDKz4YE8ZGXnp9YQ6nt3MdGzEn0ZvI1CA0jJ9VkODaQZ1ykVJZiA5llNBtdUuyRdDxToZI6WwU6IBIB0E838XXMxYZWEcW3z1oBqWNSU/tVRBjpBQAULcuTDpWGYcUwOWeoR8BD2lhqqFljkvZ1eNZFuC9XIUwjLb0rcm6S0HGXWwGSA7rWT2Mu/bpco8v952mhT5VYbVvufCw0PvSoHmQ7Lqm0ABvNhVWDtME05bKQwY82X5ct4Pz4Ep/tirAsOQMhA67dr4YX92n2lXFdA8D6lpq1RwVQ73XWzwBRpILbZPcVXNW8/7yjsAtSCjptCB/ufE12NJiWs3VFtE32H9vz4r6NohwAyViQ5Th/oKDTBClOSDPMCsV1kYAvsQPs21h0TUR5NSSMYfhNvuB/Xt+kMQEc0bCkl1IaarSjYYHkN5zLnwCnD5m+QzkPqgCUYl3dWJrZ6DPR6F7ScgPaUK18eY29I3cUeLKjiu7SsJDnlALYH1XONOGjfxsJw/X9qoMJfSToa5WFO+JmEENsMEzlg3K6jv2r57I6k+4/PTsSy8E0a9aRnkRKHSLyegiA5E47cF7NRTODnvvUVvn27uhBoaxhWVIg8nAI0lcYlGki/MoRq4aNOFG9HAoLlPX8o0FrFEZEFryb9rcP1VqLfFnSeT+Iw7hu1+30nJ8x4E0Oh5Eb7LGs/z1WvEI31uhy8DfzIqlPTfYCT1wKhI6GeP/EFV5xBuLJveWV8p5jbFLzAn1pOvZVpW9L6Ux2ChIKF5H249MdFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(7406005)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQ3I6ZLZqIYQ9WDB6qjiaQIj8w0wyzcVJPOZ0LcMyjgtGPqKPOrdMK0XGZHi?=
 =?us-ascii?Q?gHWvxJxJIWmhPe+woqvR4ByeXVFAbW6rirnp5PJJ/pIPxbmxwvehUC0tVHxV?=
 =?us-ascii?Q?pXJjfctBfYZ9sXnOFM8P31pjiEyETZ0C4gn5SLqjyeJy1+C4wRdWzfofprb5?=
 =?us-ascii?Q?W8r66UnTbb1m6JPR6J2f3I6mR01bS4uyguVFOoVG8rHoc+PA0BmQBgM5e5sW?=
 =?us-ascii?Q?AEGYHOBk3Lyk9Xld/Gm8APZD7qxgeQAX5IgQbmhyR4kqCqGVq3QbRHwep7D9?=
 =?us-ascii?Q?kqntRLdCZLPBjfRD6ynKz7jz+T0HEZKTX+NK/6VI55cXTl/Y1tIpcnC0KMOw?=
 =?us-ascii?Q?MgcyQIbn6VoOh6UWihX0PQIzfAyKAGEEsbCxpO2XJ5s6rhM8bd8i2m6RGfbD?=
 =?us-ascii?Q?FWbRGxPizybh5zVG+exT3SGcGrdkZF7FCUGJr7kYQ15ayAsW/R/wqO9QXVqZ?=
 =?us-ascii?Q?XwCVBdTRXB35btFnBWS/ioNmtWHqlpv2r1V0/lt+ZB+5t/iuSi0ZdSy0F+4C?=
 =?us-ascii?Q?VlVWby4KvinSsVeQ5gQV5VTiyE2exRsT9Gpf1/Ftig7SaZk0yni6+Q9jULRT?=
 =?us-ascii?Q?5L/EXlGW38uI6kZmEdbJl+DvhiUuzsGlaL9VzJHeCwSwlQDzVIeRZjTL2+Om?=
 =?us-ascii?Q?4OQ538qe4WNh35Xwd5nODq9TnuJgiOteGotXghZGbiWVihZmzQb2ay0++zJN?=
 =?us-ascii?Q?+w5MwA1qJjE7fYSSPjKda1L0NHzKj4HrvDBAgX3x/aEYJqDDMEibMLqEbP1w?=
 =?us-ascii?Q?G4XEGCOpUyaEsU2Uzp4crfXD0dWTdpjEGhSgjF0BK7USiMEz1L0pvy2KVFhN?=
 =?us-ascii?Q?zxHyTkZMt+c6NasgUc/9i2JLY9TvMIm6xlOChqJpXmWXzlDGZESaLhzYYX20?=
 =?us-ascii?Q?eSVOVRPBnPO3m6/dtI+T/KB84aLvTyHyWs2fi0CbX/o/xSekDpyCktQ2WxWS?=
 =?us-ascii?Q?4xcRd91wpstYYUpmX7B0ogkNEJ/ftGC6HRSfuu7LpyHVgbo+iLzW4KsYZ3e+?=
 =?us-ascii?Q?99BV2iTxYqq9zZD6OgD1myqjTKIBfHKkAEcBcHIa6iRIyeWFb7G/OTo+vaNk?=
 =?us-ascii?Q?kfF5j3fTvmKAfvvUVR822Gv45shYIDb9TYmkFASk/wWXKcbrvA5q0/Gehb3r?=
 =?us-ascii?Q?uoZuYjESrUP1dYQvLDnrNIf//EhVNVNRrT3/Lb8FHszPifizQuwYxZ5ZLTui?=
 =?us-ascii?Q?1eYezyZJjqzKfZ0ViqlKbC3Q8oTSZylZax0KGKkvmJ/AKAcNNkDwv7xq71J/?=
 =?us-ascii?Q?rqzuMT9upcktc4RZGvq/w8DcND6OTT+MdMewqyQEyqyt+jXE4I8H+6w05KUO?=
 =?us-ascii?Q?TFJ8FjpXCq2xfSjIO9l3c2lfm25TVI1DmniOFTHDRgP4aVVdT8WVy3YyyXWb?=
 =?us-ascii?Q?HaDaKMkeu0uVWwGNTDYdH64TM6q38kSBKE5KMdd8HN+Dc5CdrNfTyvNQI5lT?=
 =?us-ascii?Q?ZK5oLSxE/meP/akDVo5AO6BusopklNIutg/vh8bi/r3AqOC2rDm9b9shHoCC?=
 =?us-ascii?Q?KRMKFl0qpf2CEnv6+u3SEpZ7yC0jq+H2++f1pYjKgpqZQCFsJu1ATg2HPwoQ?=
 =?us-ascii?Q?OGaP0LM/mMWfua5Fi78xhJ5hhr11YyazvIo0APDXDJ+KiwTgmmMCsMJh22ea?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aab1b63-6efb-4238-570d-08dabddf5add
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:02.8189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VBecs0aoIO1LN7Yqo1ZHJ75wpIS78/JRfimgIDzCn/WuCg4s1V6hI0XWs2Xg2f+F9vTJVzMFG5gyzGiT6BAbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For a long time, PCSs have been tightly coupled with their MACs. For
this reason, the MAC creates the "phy" or mdio device, and then passes
it to the PCS to initialize. This has a few disadvantages:

- Each MAC must re-implement the same steps to look up/create a PCS
- The PCS cannot use functions tied to device lifetime, such as devm_*.
- Generally, the PCS does not have easy access to its device tree node

This series adds a PCS subsystem which MDIO drivers can use to register
PCSs. It then converts the Lynx PCS library to use this subsystem.

Several (later) patches in this series cannot be applied until a stable
release has occured containing the dts updates. The DTS updates are
fairly straightforward (and should not affect existing systems), so I
encourage them to be applied, even if the rest of the series still needs
review.

Changes in v2:
- Add compatibles for qoriq-fman3-0-10g-2/3.dtsi as well
- Fix export of _pcs_get_by_fwnode
- Add device links to ensure correct probe/removal ordering
- Remove module_get/put, since this is ensured by the device_get/put
- Reorganize some of the control flow for legibility
- Add basic documentation
- Call mdio_device_register
- Squash in lynx parts of "use pcs_get_by_provider to get PCS"
- Rewrite probe/remove functions to use create/destroy. This lets us
  convert existing drivers one at a time, instead of needing a flag day.
- Split off driver conversions into their own commits
- Reorder and rework commits for clarity

Sean Anderson (10):
  arm64: dts: Add compatible strings for Lynx PCSs
  powerpc: dts: Add compatible strings for Lynx PCSs
  net: pcs: Add subsystem
  net: pcs: lynx: Convert to an MDIO driver
  net: enetc: Convert to use PCS subsystem
  net: dsa: felix: Convert to use PCS driver
  of: property: Add device link support for PCS
  [DO NOT MERGE] net: dpaa: Convert to use PCS subsystem
  [DO NOT MERGE] net: dpaa2: Convert to use PCS subsystem
  [DO NOT MERGE] net: pcs: lynx: Remove non-device functionality

Vladimir Oltean (1):
  net: dsa: ocelot: suppress PHY device scanning on the internal MDIO
    bus

 Documentation/networking/index.rst            |   1 +
 Documentation/networking/pcs.rst              | 109 ++++++++
 MAINTAINERS                                   |   2 +
 .../arm64/boot/dts/freescale/fsl-ls208xa.dtsi |  48 ++--
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi |  54 ++--
 .../dts/freescale/qoriq-fman3-0-10g-0.dtsi    |   3 +-
 .../dts/freescale/qoriq-fman3-0-10g-1.dtsi    |   3 +-
 .../dts/freescale/qoriq-fman3-0-1g-0.dtsi     |   3 +-
 .../dts/freescale/qoriq-fman3-0-1g-1.dtsi     |   3 +-
 .../dts/freescale/qoriq-fman3-0-1g-2.dtsi     |   3 +-
 .../dts/freescale/qoriq-fman3-0-1g-3.dtsi     |   3 +-
 .../dts/freescale/qoriq-fman3-0-1g-4.dtsi     |   3 +-
 .../dts/freescale/qoriq-fman3-0-1g-5.dtsi     |   3 +-
 .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |   3 +-
 .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |   3 +-
 drivers/net/dsa/ocelot/Kconfig                |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  31 +--
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  33 +--
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  43 +---
 drivers/net/ethernet/freescale/enetc/Kconfig  |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  23 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 118 +++------
 drivers/net/pcs/Kconfig                       |  23 +-
 drivers/net/pcs/Makefile                      |   2 +
 drivers/net/pcs/core.c                        | 243 ++++++++++++++++++
 drivers/net/pcs/pcs-lynx.c                    |  76 ++++--
 drivers/of/property.c                         |   4 +
 include/linux/pcs-lynx.h                      |  12 +-
 include/linux/pcs.h                           | 111 ++++++++
 include/linux/phylink.h                       |   5 +
 49 files changed, 758 insertions(+), 268 deletions(-)
 create mode 100644 Documentation/networking/pcs.rst
 create mode 100644 drivers/net/pcs/core.c
 create mode 100644 include/linux/pcs.h

-- 
2.35.1.1320.gc452695387.dirty

