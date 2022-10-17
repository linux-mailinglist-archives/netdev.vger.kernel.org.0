Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4631B601949
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiJQUXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJQUXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DD712629;
        Mon, 17 Oct 2022 13:23:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXX9GnXAMmF6Cawi5cpQQRm3qES6Ud+9u+Nyk+2P++JyPok9spADZJ+MCHaHlYCJgYrZW5KDfbdKFx7TXP15mJcyoPG5ei1aZqPNlN1maEmmEUcqD1L9xkwhxMXXAdQUZh+jSXg9FN+qVSmVmyapT8TdQ011kQl2aC076ZqEqDTldlrJ2aXQ0GAi55KAf1XJh8396YKFVUUGcXS+bcdl57MC+1bvGZSnhptX68aTzLnwMaL8he7SZ3pytslBmyx2ISqYX5f4VIFeVsHRLYtqgTX+gFS6MrRVuBF4Q1/pn2LKlfzs/PzsOVp7DLvZ9uIdFjnJoZ9C87UXmZRHhNAIJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Zz7eR4m/h2jh3NrSu/D3jtj9GlJ6LQaxQjxyWZ6X4w=;
 b=ARyeJUHYF21tZgPEs3kEYX2v1yN4V+uA12foMygcACzgxqoFa42oLJk8NdC/K0tsEjxthZ/qahNWAhtZtgx2GWZehUMDuIxFwKVztQu7PgojeqfJrwXV+gn29b/C/rb5BFj+sOjycFHoEk5yx4F1dcpqRxckG1AZuRWQqrHtegMBnq583uqHY5hdhrvy2HAwjUJhSXu30o2fEgL9LRAHAYbcAa0FEGgg1gUcLk/iotoRmF2AD9n9uNcJ7ITFQTF6jEQrk8X7CU1CckReQJbt/1gOIYSPoQk3eAW1yQVzqEWvMqEXhi4Yi/upqvV9AzzrOqa8So58cff4yV9urvvraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Zz7eR4m/h2jh3NrSu/D3jtj9GlJ6LQaxQjxyWZ6X4w=;
 b=c34XtSCg62S8V+FnZsaRyxkn16+gU/XpWy2nbgdLfdAS1iib2bVuUx0vbGv1KlBNdznaDlFpZIMUZxTYi6ca8UtH29uXjnHj0BOeXqkeeiJJTNzsVTj8S3hjXz3qjLLTswKoKGaHKa+C+EpffKBmVhvH+/X8+N7TGFOP4+zJ4jm0XJXfPE7vdyBUapHWITa/ET7PItb2tL4G7UJ4XZeCdbKvSLj7/zWzTcrhv4EZktFGTlmEt4NqdcbexOzmoZ0tA+gQBBTz3D2OjAhGqXDmMgNkw5sjM3WFqIwmyacBDHRpRcC6r6ApfC+7qmxbaAQdoNXQSx5Oiuw4fmrYbq7rxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB9510.eurprd03.prod.outlook.com (2603:10a6:20b:5a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 20:23:00 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:00 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v7 00/10] net: dpaa: Convert to phylink
Date:   Mon, 17 Oct 2022 16:22:31 -0400
Message-Id: <20221017202241.1741671-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3052b6-1732-47e4-d04f-08dab07d62dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Ua8ZgFVyC7Pe+G14AFsoaXVfHUbWWF2wxSttG6bs7XC3KAiK2qHpSZCQoRIpujVeWZ1IWuyTk3cEGikS1SZ6sVyp5fB0TC30TE3l5/nDeTT+MME1u74aCL82TjYOzemGpU/9WFH8u2FaiZdXOSbiKrD/bh3YtxaE0gQK0k/2sB+QvbfZ1Z3zagjZ+wsofDH64gsamou2m7LpYAPK29CnF7N3elMmdD+3wRrxXMdrXSILLXrhDhtY68dEcFtM1hOw2tHxzcgZvQVtZir5YFKSRJ7jep43zmWPgAFMPp+cURPT1AjzlqnWzZ+NYA3QGJZAdH585+JQxrnGW3F+IBK017AhAPobcqdrhy4bF7dkGVedLQroULBg4znQfQ5tBd+QUL2QY5LW5sPpc0k1KF6F36PQtGPTQqiqLfWsGX7ixJjME/JP+foDr+zRAvyeY/ptPwARUkyQjfx2FACTvtxT58+9dVFMXoCtMmOh73pOfQ9zscKoAmiCgZ+2w+41w+gN6JTqIrqqJx458pzLzrRghcibkWR7m7M1UyZEb6F5mkSf32I3kZMMZZKCKI1Pjj2tg2PLpsNKxJupMqrmj9K9E0y9Tu2tIEJxYyieL0LvHz4VRUSeFUGD0oZCNZFAltaofMVbSqfnRKoKD8lPD7WFL60HZowRWHUXvCpLdBQxFYsaFPzLcI4y3+4hyJ047IWjFwo7+t3sOJj8v6xvDp+3EYhOP4L/izqmXcjYuiEx7bR7E+7QkurCO8ODJ2QngiNQyz0eYM/vRj4nDdSWxcLTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39850400004)(346002)(376002)(396003)(136003)(451199015)(4326008)(66946007)(86362001)(8936002)(5660300002)(8676002)(38100700002)(66556008)(66476007)(83380400001)(110136005)(54906003)(1076003)(2616005)(2906002)(316002)(6506007)(36756003)(26005)(6512007)(186003)(7416002)(6666004)(38350700002)(44832011)(478600001)(41300700001)(6486002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pAe37MIGNaWML+m+SjWXisO31t9LbqVHW/xHLYaWmp3UiJa8FMnmRDCkOJxw?=
 =?us-ascii?Q?YQjSFyZ+oeCklaRoTcxjg83Yn/vNcjEkD4jXuqAfF9HdkhYJb5Xm1/RiX0Il?=
 =?us-ascii?Q?fG/wY8FvBxa45Dj9e+wldmHRv7IRUtnfhy3YEWJg8IbJD0MYVx8nnEqns+uM?=
 =?us-ascii?Q?BuUctisXmBcXk1LAZzLCfev7vykdzc9JwBE4HAvA/L6scFQSm6srIlpQjZrn?=
 =?us-ascii?Q?Id9WstD7GpqIng8MSJm/ntBSyy5/ScGi2fhWzffF0Lo+5rQYOQdeo+7V3cFY?=
 =?us-ascii?Q?MNEObF4m18RoG4zNmQeLhXWg344+1CJdqMhlPg1Ro+L7ydGMxmJaihbwXE/w?=
 =?us-ascii?Q?98khRG2MBN6sxDfBLtDY+2qdh2ryMljpCaF8TrcMaqS6KNRRTwenWXxB1dhe?=
 =?us-ascii?Q?meLZdoXATxLqrhrr86PGAMU2abELurZCKj9vFDq+yf03trPq9/bT7j/R2CQX?=
 =?us-ascii?Q?izC7LTbn827YZeKPVrFo9wDfi03ozPm207WHX9X6xsbQEggG+x1KLt0dfMYf?=
 =?us-ascii?Q?vA5qrxqJvV0iEWCeJJxb1Sug34OoJCAN7q7JLPfjbxnZYxhkeKHKeBuhasbp?=
 =?us-ascii?Q?IK/BLiE5b/9BEvTHDQvG+cI/Wpsp61WLufj0RTOhsCiROy6Ck3tCUgXCGU7Y?=
 =?us-ascii?Q?1NqUhYpuRPU8AVq6RgfaWr+LLCBjxtcLcWCA/yXHJh3ybf1J7H72uHRL0oJs?=
 =?us-ascii?Q?lb030iFQ4IuZ7tRLaF+Hy1OxPBPK8qyd0iwAsiK3A3XFzGxDpCrVu2ZZABRb?=
 =?us-ascii?Q?8Fhs/SZriND246VjU/GNrW1KNX4Ix6QAU9WmfVOqPdF0y6czgwfIkT3Jmjbj?=
 =?us-ascii?Q?z+1v7ekfK4tAIeAVnQSEfGsOK/s3uWCla6SsDLY0S90sV/2HanlVpU3er3MN?=
 =?us-ascii?Q?HxK/Kt8a4mjy1SzUc9fDGTTAYgjsf0d+LG+XNudByKv++KIGH0Oy/N7A6acE?=
 =?us-ascii?Q?je8lnQ7994R8wdBUM2ZPoSF6Zs8Y2Q+rxSoOUIkyPEBT9oBfHy31rmJdKiF6?=
 =?us-ascii?Q?3CD3c5RDWwesDYsJbw/EvFCxW/AFBTmJScgTsfotcAEVOXBb/mfdEu10qc3h?=
 =?us-ascii?Q?vu5q+LewulPrlfGPZaCEGC6oKZqC7tZKOzLsUQWhIm1Cay0k7bjY5jCielZV?=
 =?us-ascii?Q?wJEAkkriGuOSToNkU3uyX1pw93THPN8Zm8x7IgawYl7kBx6JVahImo95ew/U?=
 =?us-ascii?Q?U1qAY/AUh/i5NZRik4+t3ZG+VnKtputkyCDxbCGuFPu2lQW73oSxbRgfS411?=
 =?us-ascii?Q?gtwQTFQ0zy8xPUOKczqG5MjQrqfL0cUXYEm8H1T9I5/i9LjLk0lyLLUQ0tqy?=
 =?us-ascii?Q?TxBUKNRwWHJv7D8sY1UtW+reKCu+TGh7nVk7qd6P989gFrsQaZXQ10qbfd+R?=
 =?us-ascii?Q?XMQbU/XZ6lws0GsPdChHbf6+FDLAjEg3YcqZ2e1WubyC7oFfBwdYxk3avUqn?=
 =?us-ascii?Q?RJES9KskN2P8+HwF5ABjN7195QrqRPkM367F6NiLdUNdwzHbaQMpl/Ly1rDG?=
 =?us-ascii?Q?iP9/4pOx4CBQbrzq3WVQUjUbP9aknruOI/uAvoyzMlHLFYqhlRdznEwkM2pr?=
 =?us-ascii?Q?0bFuNSywqdUcdYY04F2Bw2BCAcbE/kk0lP1oFLJeChgOvXqlQgdK49v7XEpR?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3052b6-1732-47e4-d04f-08dab07d62dd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:00.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gp6wrmtf0TI0F5L6qnlNXRbZwAyKsWLEqDg7f/oH8nkSd6KCAXbhUMtwtXe6yPFTC6s1pBDzxyF5/YteA+KM0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9510
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series converts the DPAA driver to phylink.

I have tried to maintain backwards compatibility with existing device
trees whereever possible. However, one area where I was unable to
achieve this was with QSGMII. Please refer to patch 2 for details.

All mac drivers have now been converted. I would greatly appreciate if
anyone has T-series or P-series boards they can test/debug this series
on. I only have an LS1046ARDB. Everything but QSGMII should work without
breakage; QSGMII needs patches 7 and 8. For this reason, the last 4
patches in this series should be applied together (and should not go
through separate trees).

Changes in v7:
- provide phylink_validate_mask_caps() helper
- Fix oops if memac_pcs_create returned -EPROBE_DEFER
- Fix using pcs-names instead of pcs-handle-names
- Fix not checking for -ENODATA when looking for sgmii pcs
- Fix 81-character line
- Simplify memac_validate with phylink_validate_mask_caps

Changes in v6:
- Remove unnecessary $ref from renesas,rzn1-a5psw
- Remove unnecessary type from pcs-handle-names
- Add maxItems to pcs-handle
- Fix 81-character line
- Fix uninitialized variable in dtsec_mac_config

Changes in v5:
- Add Lynx PCS binding

Changes in v4:
- Use pcs-handle-names instead of pcs-names, as discussed
- Don't fail if phy support was not compiled in
- Split off rate adaptation series
- Split off DPAA "preparation" series
- Split off Lynx 10G support
- t208x: Mark MAC1 and MAC2 as 10G
- Add XFI PCS for t208x MAC1/MAC2

Changes in v3:
- Expand pcs-handle to an array
- Add vendor prefix 'fsl,' to rgmii and mii properties.
- Set maxItems for pcs-names
- Remove phy-* properties from example because dt-schema complains and I
  can't be bothered to figure out how to make it work.
- Add pcs-handle as a preferred version of pcsphy-handle
- Deprecate pcsphy-handle
- Remove mii/rmii properties
- Put the PCS mdiodev only after we are done with it (since the PCS
  does not perform a get itself).
- Remove _return label from memac_initialization in favor of returning
  directly
- Fix grabbing the default PCS not checking for -ENODATA from
  of_property_match_string
- Set DTSEC_ECNTRL_R100M in dtsec_link_up instead of dtsec_mac_config
- Remove rmii/mii properties
- Replace 1000Base... with 1000BASE... to match IEEE capitalization
- Add compatibles for QSGMII PCSs
- Split arm and powerpcs dts updates

Changes in v2:
- Better document how we select which PCS to use in the default case
- Move PCS_LYNX dependency to fman Kconfig
- Remove unused variable slow_10g_if
- Restrict valid link modes based on the phy interface. This is easier
  to set up, and mostly captures what I intended to do the first time.
  We now have a custom validate which restricts half-duplex for some SoCs
  for RGMII, but generally just uses the default phylink validate.
- Configure the SerDes in enable/disable
- Properly implement all ethtool ops and ioctls. These were mostly
  stubbed out just enough to compile last time.
- Convert 10GEC and dTSEC as well
- Fix capitalization of mEMAC in commit messages
- Add nodes for QSGMII PCSs
- Add nodes for QSGMII PCSs

Russell King (Oracle) (1):
  net: phylink: provide phylink_validate_mask_caps() helper

Sean Anderson (9):
  dt-bindings: net: Expand pcs-handle to an array
  dt-bindings: net: Add Lynx PCS binding
  dt-bindings: net: fman: Add additional interface properties
  net: fman: memac: Add serdes support
  net: fman: memac: Use lynx pcs driver
  net: dpaa: Convert to phylink
  powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
  powerpc: dts: qoriq: Add nodes for QSGMII PCSs
  arm64: dts: layerscape: Add nodes for QSGMII PCSs

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |   2 +-
 .../bindings/net/ethernet-controller.yaml     |  11 +-
 .../bindings/net/fsl,fman-dtsec.yaml          |  53 +-
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |   2 +-
 .../devicetree/bindings/net/fsl-fman.txt      |   5 +-
 .../bindings/net/pcs/fsl,lynx-pcs.yaml        |  40 +
 .../boot/dts/freescale/fsl-ls1043-post.dtsi   |  24 +
 .../boot/dts/freescale/fsl-ls1046-post.dtsi   |  25 +
 .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |  10 +-
 .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     |  45 ++
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     |  45 ++
 .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |  10 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |   3 +-
 .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |  10 +-
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |   4 +-
 drivers/net/ethernet/freescale/dpaa/Kconfig   |   4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  89 +--
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  90 +--
 drivers/net/ethernet/freescale/fman/Kconfig   |   4 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 460 +++++------
 .../net/ethernet/freescale/fman/fman_mac.h    |  10 -
 .../net/ethernet/freescale/fman/fman_memac.c  | 744 +++++++++---------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 131 ++-
 drivers/net/ethernet/freescale/fman/mac.c     | 168 +---
 drivers/net/ethernet/freescale/fman/mac.h     |  23 +-
 drivers/net/phy/phylink.c                     |  43 +-
 include/linux/phylink.h                       |   3 +
 41 files changed, 1106 insertions(+), 1064 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

-- 
2.35.1.1320.gc452695387.dirty

