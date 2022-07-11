Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0525707E2
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiGKQFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGKQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:05:43 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980EC65572;
        Mon, 11 Jul 2022 09:05:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3iWNCixxTv0m8fs7RUQM9nS9PwhHkl0/ABlRyoQEBlLRO+yDXrzV7eTekfwIOgp7RQmlVlo7e+c4k6VcPsmYvx2cu8tzYwGNp7s5DOrAKewFrDk47/DXzEVO5mw00MMkq60KopqByqGJhIHmJMKP60S/GQn1S58Mq+GAxRA5G7tuNFXaEiWZKwWvUDPsIqxCRh3s3vrp9bQCZJFQnhHWhVyjssSJSu8hMrCkSfcP/cu1+xjBGYRWMIlpG63UEnTufuz+Yenva+I3Gq+CeY3ESnEE8/ReQelEPD0TKw5xCFbnnDKpYg3yuXET7Nggni2CYeZQEi3ZoiBua9rrJOY6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUmtofNdeYCBJLbdCb8eHTiJkS1i9/O5L4WOZfZXd+g=;
 b=CKL6W4Na5hdLmFw1H8XL7gQHalY/84Xk0pVzNQECCP8YGSNetEmj4Z7Bf7i3ZuH3t2VdrvdrVZJQHbJn5J00bnYgBGfMGFjBRa6BmDDXR/ScGr34bBM1cFjnEATbalBD4KSr6NHCnSfMvfwpUetixSJJDmCJ4RCDxxkH8CnDShnp8FNVjWjOJQFNb1DnTRQk6hEUvZO/L66hEECOuBKHpyyuwAGORy0GC3Jh369+1cNt8XqMef3cnKCuqn7tkqwIvs6JLp3Lcdbj38w5TSL9pHZtrrqc1Z/tTtD2UViN5hKveKFi8fHQbrb++T9VU7ydf1EWWXKwuPQs+jRuVD/8FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUmtofNdeYCBJLbdCb8eHTiJkS1i9/O5L4WOZfZXd+g=;
 b=GCaFz7QMy++1xue5viRc/6Ii3rJWTWUQSjNlGdKGJZqKBWBH1nUtelRa33i6zLoTVm1ZZV2yhimC9W9qQmGLK5nFVe0gTMiMXOVllhYuxOfBEWkdUR1h6BY0ounQz4bvXzltHyvl5GCn25/CcsZ/qRsYXdcoym2TYx9hrFSZaOz3vvBEtB76/K70NmTIsAuhNnnBgsikzTKLQyi+EPUmYb1Bka0WJvLO9CRTLfIxNXogpQK4rjrWpoaLVgvCVIrf3Rt36DX5F086cdpf5pNHasYyN25vI1F8iMBljEswLjudmGSqN1f7m8QjjPDepvuM80wX0cxrxruKBsBTv8cl+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:39 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:38 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Subject: [RFC PATCH net-next 0/9] net: pcs: Add support for devices probed in the "usual" manner
Date:   Mon, 11 Jul 2022 12:05:10 -0400
Message-Id: <20220711160519.741990-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c916d062-98e4-4cec-5244-08da63573248
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nHBR0Dpf2Qs2jjt3rPMvtqZgttINN3kC34xQHVW8tk0L4gSAFsCRiWdWMZqg70d2gWi9/SX4AabG8UMo7eSTp7UcDusd2j6gRE37Kwqc4hPq4ExyVWaWKP/lt52xN1tcqeZfRsiuLMr97K3FdeKmyCofITfWPREwtrfb1Z4M+CO18ojG0hxI2r25gnh402e9pVjDWzypS+1rw0q9JytepTWR/ty0t/ucRJs1g2R9uPI8DKyACWKoWLg9sKluMElE6Tah9Sdwh6qbZWJ7F1HtQkpoVdd7GsdK37EyZUJ6liGeix9ojMoyacLpblCtq8pNZ6e+M+l/eH81C8NsfAy2XXuXy0texqw+9SLRky7c+EJwBsyNGtlh8dN98JMGgISxr1RRn2G/pOoUAxSAwUlg7TM/ENTvKWMv3lUlbXWOnDAK08YKj8ls5gptDypEvTOUWFwXOkeabwNMEUILKC9sKFmtUc7paTY+I86aoTERcU2pYJzBFgt1gVvWPF5ZDqk/LkpKZZnCp4UTFyhb1TssRchIwDtt1Er6YDqSVwv/y7koXywiDQDiZYJBQQZIMXdl1JSj7q7zqvXFLKwiOkQ1vQGYUPCjzGCXX10FxjPjtCuEioqubTtSXmmc7Lqk/wEX9U3u5213lMiblMEe+CEu5zgDb6B0sqQ/piiOsOOxuAf7x/tRvIx8MGYX9UBduFZGYoZZqXamBw1P2d331vmiFqZX2T+JR/7YSAIRNt9luiMsLxCRSv5/JJZVcaRdKjOpLjzIVQetuHc243j6Mxef9f9ZZeocknNp3BO5ZV7+g3OaFQCos7zvHE7tV4ivgwO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZc8TfzylDUjgDvkcIgMylG5Nsg86h1YD521JYF3Op67QUEbWwn6NOqDIzMM?=
 =?us-ascii?Q?3bxL4puLfGC7JrAZ888xE+Zdsg3Zq3wtoVEl9X9RByFDA1zZBWYh41YSbkuf?=
 =?us-ascii?Q?zt1HJUs96Ow7kMCNUZuHqPts6q4jD5mSjJIAoTfRjxk0AueJbDs/QK8VQCQZ?=
 =?us-ascii?Q?oFSvyKvIUpS6rqZfzYFCu+kXmUqoWtMBYMarmRQHJfl/Sm/GmuKBR9tHmp6/?=
 =?us-ascii?Q?kDfgWhkeo8InDdp0if7EUqAAkpi55z3MmSsuQvoK7D55m3mCuU7e1ogeNJkA?=
 =?us-ascii?Q?ofELB57zUxxMqfAdTnVWTvIp8jDbvCiroyKfojai7Erif5puw+FQR7LAWfhx?=
 =?us-ascii?Q?q/BDPVObxnzSZ25uqyOSJpGyyXHLP91wynVl1UPsHUxINblowSUhGKgss2V7?=
 =?us-ascii?Q?QSn6/T1A2GH8pK6Yr3Db1dks+HXYVTV2DhPwztC40e513JemlDMJWbNHiqxz?=
 =?us-ascii?Q?WHsB1w99qWno4gbvVt1TqqOisybQgTvQmPlasDNA6IZJNrnPasvDz/GjrSZQ?=
 =?us-ascii?Q?L9HDRLh2gBwLN9Gfkqmv/0fHdJUo82jnbiu4h2A/fahq+H1nLsyMc2XQTou4?=
 =?us-ascii?Q?fmcBnjtIy5HV+L+A0O1M7U4vPYq/y1NVPwcbvVZDrMVvJVETIHDZc43dvp8m?=
 =?us-ascii?Q?jBIAPyXez7DJwmuTXeIzy3p2AB7lxhrPOO4GZxFzfEALBuB0f33YfY2pzL6E?=
 =?us-ascii?Q?8ELA9wtacitnOYckNF9QKzeKEYNDUrt576IJn8kHdqkGcf4Su/oovjLay3Iu?=
 =?us-ascii?Q?LMNMVouEiOFVMn+oSKHCg7iRKSTm4Q5pnBBMMclubbqPuA9YpExg8ad1tGgc?=
 =?us-ascii?Q?LpSYWAEW0nbWb+3wfxD1/j7HisSuz4D8TlcDq8mtCVm8updQQOG2FcAb6AFn?=
 =?us-ascii?Q?V5bC6rq65s0iNz3evsw1JxV1wYGvYOeznG48XSiUnYuOyikS90VBPPdMNXow?=
 =?us-ascii?Q?ab3U4694DxnVeMJvebdgKR9MyAbdHhdyUxeRxxP0ShrY9tWDw1ko7Io4qJ7y?=
 =?us-ascii?Q?PrtalWeJ/DJylfY8pw8oGx69e2oqi78VzeMsCOV4tqxra+wpXel9qMOL5thA?=
 =?us-ascii?Q?R8j3SPcYT9LzodJSMB2T2LKckO1VG1YyBpwbQytQQf3kLTuFhk/ZtY8fY4OC?=
 =?us-ascii?Q?1mWyW9+aQ+KZUrpSxwMXzJWWfH7VN6xP/7HrWmVpJjA6e9C0aFQvqwsnk/Bu?=
 =?us-ascii?Q?JU34qgagL8uXac64xOO2YArOJdBjnwX6w/7NUK/oVsGcmBrq0dnz19k8CL/I?=
 =?us-ascii?Q?Q6MMQr7Xx/AEprHC1BWLSOPlWfoceI6gGaBSCggOgoBq2hUlfTQBfdppfpF4?=
 =?us-ascii?Q?22vb5FW7g+MBPD78bLggMuItJ5sBSmQbS9oRXKhw8HbIPqZndOsnc3uuwNzi?=
 =?us-ascii?Q?MTQchQqW9IIMqFJf+EkIKR3c80WIRM65eQpc+yDMzb+Eu6/4FGe1U2VfsYd/?=
 =?us-ascii?Q?X8sEBnOf7vtGlV3sV8gVzOUlad77HRJDGfk9pZvNzmBiOmcTtuBFonsrB+Sk?=
 =?us-ascii?Q?KEJmjlkb3FuSQjIGEOtoeev/WVimeKSSIhsJcojNEygDf8V9F2nhQ9oDIzac?=
 =?us-ascii?Q?G75OdOC3JRNs1dNs8FcVyy+s0ZZef3gQVNBcHIMd3uP2alIoWjUKOLqd7ZJY?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c916d062-98e4-4cec-5244-08da63573248
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:38.5595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkjF6GSlFU1E+d3SPlkJ/vbSdCLVFfJ4G8PKAXzV9MOIPUe2vqWajN/U7NK4t7VrnGMzCw65X0evQcTOCN7tvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

I'm not sure if these are terribly large disadvantages. In fact, I'm not
sure if this series provides any benefit which could not be achieved
with judicious use of helper functions. In any case, here it is.

NB: Several (later) patches in this series should not be applied. See
the notes in each commit for details on when they can be applied.


Sean Anderson (9):
  dt-bindings: net: Add lynx PCS
  dt-bindings: net: Expand pcs-handle to an array
  net: pcs: Add helpers for registering and finding PCSs
  net: pcs: lynx: Convert to an mdio driver
  net: pcs: lynx: Use pcs_get_by_provider to get PCS
  net: pcs: lynx: Remove lynx_get_mdio_device and lynx_pcs_destroy
  arm64: dts: Add compatible strings for Lynx PCSs
  powerpc: dts: Add compatible strings for Lynx PCSs
  net: pcs: lynx: Remove remaining users of lynx_pcs_create

 .../bindings/net/ethernet-controller.yaml     |   7 +-
 .../devicetree/bindings/net/fsl,lynx-pcs.yaml |  47 ++++
 MAINTAINERS                                   |   1 +
 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |  30 ++-
 .../arm64/boot/dts/freescale/fsl-ls208xa.dtsi |  48 ++--
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi |  54 +++--
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
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  26 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  26 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  43 +---
 drivers/net/ethernet/freescale/enetc/Kconfig  |   1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  25 +-
 drivers/net/pcs/Kconfig                       |  23 +-
 drivers/net/pcs/Makefile                      |   2 +
 drivers/net/pcs/core.c                        | 226 ++++++++++++++++++
 drivers/net/pcs/pcs-lynx.c                    |  76 ++++--
 drivers/of/property.c                         |   2 +
 include/linux/pcs-lynx.h                      |   6 +-
 include/linux/pcs.h                           |  33 +++
 include/linux/phylink.h                       |   6 +
 47 files changed, 566 insertions(+), 197 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
 create mode 100644 drivers/net/pcs/core.c
 create mode 100644 include/linux/pcs.h

-- 
2.35.1.1320.gc452695387.dirty

