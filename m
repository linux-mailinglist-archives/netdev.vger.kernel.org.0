Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAEE5F1338
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiI3UJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiI3UJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:09:52 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D75944578;
        Fri, 30 Sep 2022 13:09:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSB5oD35Hznf7nSJ3M9nx7GcmQ8YSB+1ucVPx7VOWKfDkphPZIqXIlWEnDSHw9rxk40x+i15Hfu/3qH/fzHJOZXcI+9RekG+2Dml9PB7S2sgIw+xUs0sZ6LgyaHxfm90aQKhhT6PWthGb3Wey5oj6GBdbfQ+oBcPTPSO6xupmRnHcE32mJ0uTCu0P6EQfniw1kmQnqoxMabT2ob7M18OrAB5/4+NDm9oIoxosnqzTb6LBPZLCGgq90+zsY8IycPjXXAkBICSB+Sh7ELOO2YO6bJgQ80HvxxV7nMpK37KfkmpJ9t1tePOiUNHVITdYomEQ0sMzanF0p0gVYXZrC87JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wvNN2FOZCZ97c4RCg7SBNLxts/i2L6Hd1FVu3O66Qg=;
 b=KoKKuoNw9Eub2GRE+w4K76iK6Vf0WWdWlcyhQ5IXI/kzU+gTQHMtOdVkyltGlRqMYqL0HWnYbFNkGk7jkw4inpf0/qKxDkheyYWUEJcID3NA66SvwkCOe4fQSSM/WYZMGl5iq0qS6Cyc1ssNDlvCwAQXXKuXOR41fySmVxn8neN7Pkax6RcQ+jxxq0VX2P3Flm9hpdjjzIxK6t+Mjf2r8Ib8isXWniIdexvEDF0AEPlYdWM2hb7gs01mpyprQwg0JG1LHDNYOD8RTWAlvWMgK5zbErCCKGser9NcjOK5M6fGEz7jSesdewI5KrdKloP4KcsU8DhYpVm4R4fOFzh+RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wvNN2FOZCZ97c4RCg7SBNLxts/i2L6Hd1FVu3O66Qg=;
 b=Szw4ACD3NzkCSM7BmVKi9kUsTya7fwxvvmuwXkH0W0Yg0lUFo2t4Pk28UehDUQEp4PjK07W6lWL9k4qTfeTwSdLv1XhAcd8X03MrqYUoXce40GyP6KmCUcAqCOdprOZMLtJW5/W1YcesQv8eW6y8bzOVMhsHh+KOAeZBNjvIhXuQjEecfNgN/A5s/rkNagPdEvm6qSkKzUGwAigMDYBcoJZx4QYXPDu53Rk6skVdDFwq3T3+Ds+2Dk1j3TiKEwtTfQJ+3rSiOw/aqU8mJJ39Ogn4/p/p5bV3bYbujWouTJQC6jkd3jE943ngVA+vL9G8be8D2eJR/Ez6to7sH37jCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:09:47 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:09:47 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v6 0/9] [RFT] net: dpaa: Convert to phylink
Date:   Fri, 30 Sep 2022 16:09:24 -0400
Message-Id: <20220930200933.4111249-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ca6173-193b-410d-c398-08daa31fb92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CsGV3CjpSI++OB6/p162FFC4U9iHEoMev4EUHP6gMGYiTKN+1fFHW7fuqbBsbezUiWJsG22yLdK0o+IUXa2wXJIquGkkCqQ1Y1zMzNXOoBT+xm75scaQKbW2Fk5/KIf8obQ1gN9O/gAsQnTLLlNhctA8K3pP+1pjQRspXwShD/lyqU/sVK0mHiI0dUWe4f4gcOkQDWfeVbion+7JDTQFyj9wAPk0B4b7nAQt1nhr+G31aJdtCzS5MkFKsyhJ0mkRXqQgq8e0UjUQsOksvEzVQ/omE8QZhaVdWmV1q9MTjCDUMkukjzF0/nBc5hfYHNlj/8gI+xu/tX44VuwiCHZH38szei0fu1RFfG3eVe3Zn3XcSZ70xMLfdD7/HjP8EFoMQapylWJIUjFlok5DtTTykCaPU3bm1x5DPDyABDuZUmOq7bC0L9wkusg8jRG9Od7Ripx8EaMkaa+KbGpmrEqcWTZCTAeNJJZ5p/enlbOU2R5zIC8sWmXg6YqwTqgUA/vOesghPo9Ny+Bzg5fBetMhYd1/GckJHKUMTR54ibIN4i/bSVliuoeJo/xnVwdp9wJrtRC+45tnH/cAOtrFqaWA8LzuO+/VQT3Q0fXBBlOjXH+ILJ6Z4+3pfWcqPRzD5NVJAQnqYj+s3y5rAHqcV5nVkVcLkMfCDjvVEpWw8TGQ0gkQLnt1NnP/B3cPjYhy5AjAEb3BlZvYtbcF4KgI3Tga6ViPvQFZ2rTHsHKTugu1+DJXsjArkQOJ2JUWMmHeqT6L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1e4IZuV45uvYHCBRJabSRw0g3/sOHY63l1nYbE6LahUAE8kQKI37aBF4pxun?=
 =?us-ascii?Q?7g5wrEAlunK16qn7zCUTI4hcKZ8AQg/JsVWv3C/MT1DXwfX/9cFKR0xi1MbO?=
 =?us-ascii?Q?UEF/1Cg+ggQ6pku406q++0L4rEbEHAlLZjPBxstxnFWAZmLumi/ytjdFt66j?=
 =?us-ascii?Q?TOcKNroPpcWxWKjodC/k+szh/2TkTs8PwRc3Msxc0kPoT42wzToGTAY/utZI?=
 =?us-ascii?Q?nFEUgvwlexr40yfFmTSwfesuLXXsatBXGPtCPbozuJaH3IKMZ6HS0i6NbT59?=
 =?us-ascii?Q?4CJUGHs0+gcxB/YEXP/6dXHNXf29VOBMYcjVXDQo9ELTwDZw9Q0b8vAqxpam?=
 =?us-ascii?Q?3sJno0gZ1UFXG5NKDn+7DrgzrRyMTuUr0yPDS1+t0ZkQip90R+GRy1yf4Cqw?=
 =?us-ascii?Q?kNub7ZY9EVl+xU3wqoDYBvhkrDNorQZM0FYy/uZ2Wn2/+vu0Lp9B/W98UGWv?=
 =?us-ascii?Q?sCB39YJ2T1BHnhdMp465BRZnujUih7fCxFABc9R/5bUGTvSyDFVUvaFdCHmM?=
 =?us-ascii?Q?v9vx3FV0/gpp+3vPqYZxd3xxgbWiOjtICKvesXohmxtwqgXxTmwA6dQqg2oI?=
 =?us-ascii?Q?Rid0XPh3mIwNbGmcqY6o9Ruxz5QO6IBcCTU0vhrPNUsmziNFHBlPwDM11i4j?=
 =?us-ascii?Q?Yx7Dtv7DQkWSkLy1AZa4vyJAvUNONHsQsI3C2jM+9sv34C86xQJe8Vc/dGIx?=
 =?us-ascii?Q?XvLkd2BMCA98bwca4KbpJPX6ODyM0GcNWQFRkytMc0eLL7NtYQtO7daSSgRi?=
 =?us-ascii?Q?90bStO44lGGzgSNxA7zvceeBaaXh5ytvGLg1a7GEYFsqGmNgdWU8acmfoUSJ?=
 =?us-ascii?Q?omvp/sctd1ozZoKQ8QyjccQZDztPXpuKRwkURQjsLJSugVmdAWZnyqkb09Ck?=
 =?us-ascii?Q?sXED5nXlJ29wy0SqzM2hB0twYglB48G1+uF9WjVf8gJkXzI7DJZF+Uq6erPJ?=
 =?us-ascii?Q?9tzRr33QNZIivolQkUL60ji9GinDqtUi+X3UFoqRVsvhio+t/22Hk2Joau+v?=
 =?us-ascii?Q?dax5YPhnCiBGolCgCXjN5RL8AgAW47CK+q/IzvkRZUqUU5o2rtNhw4XbAQUP?=
 =?us-ascii?Q?lBUpJNh0UdATC93jOr3okbeWPGin/RbSqrYtj4e7PZFR/igfvXcEawpPsRZK?=
 =?us-ascii?Q?qXq0xFYQiqjY8sVG0fSCKwF1cfOpO1UXzLZlD4dfZcE8rBetTprcW4FjSVXr?=
 =?us-ascii?Q?w8Y0lVg7zRTRjsnJbgM4ilAOJrfh4qQEZG3+YdjhxUx9ld2+dnQR05OpwCrV?=
 =?us-ascii?Q?Sf+X49Gu5lEhPfymNnDQi2hsghFaWa3Z4/Hchv37Da9+oqxXVlGUshBFRpN1?=
 =?us-ascii?Q?XE/xrM67jwbfL0GE0IXz/q63UR0b7f0AXpvEmKwNll6ZIMCTddoqBp+ieuqz?=
 =?us-ascii?Q?iLsdrl7kX7+63XPwVawutVnjhcYSwMu9oBPVF0eCR+0a3cEZVN3oED0PXbY2?=
 =?us-ascii?Q?ft2jNfCBFPF0mtTKzY6q66FhAtuzYk1cK0nYfkyE5Hx5kh4CrWVwJe5XiTmr?=
 =?us-ascii?Q?En5UHdJRh2CGZ0xuR8HMFDQwtMcI/W8+u1tD2llQgguL75oTPmjfUaOng4G8?=
 =?us-ascii?Q?kYd9pVQHXM9hIt2NR6VkGOGWYwukCJEyh9iyYxYLjU5XSVV3ob/aN5Jgyh23?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ca6173-193b-410d-c398-08daa31fb92d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:09:47.4319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3MVQy6rUqYl7b8Cnl0TJaKOBm5tuinFxOvagsfqkiCfWanq+R2+Nh1JS2SQxR36BXCeYcAdvqBPczR63vZOAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
 .../net/ethernet/freescale/fman/fman_memac.c  | 747 +++++++++---------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 131 ++-
 drivers/net/ethernet/freescale/fman/mac.c     | 168 +---
 drivers/net/ethernet/freescale/fman/mac.h     |  23 +-
 39 files changed, 1076 insertions(+), 1051 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

-- 
2.35.1.1320.gc452695387.dirty

