Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95672640F4A
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiLBUqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiLBUqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F18E61EA;
        Fri,  2 Dec 2022 12:46:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf4VvIDxCfxOfUBGzDzEhC+Th4d1XhztTgh5IMJkGTZDRTKbC+7Rh5DT6rm0E1FM4cQoPvS0iMX1fGISXQCeFK8ve5XSIBhq9KsPpLm9adDOcRdfBFBwuuqx2jgRRpkocaZvA3JO/sJWUEVY//fp2uvCW83MoLvgMA3Vd1saKP9LADp66ZKlNKTRdM2/+2D1Waij0utgZdXvbl6zFdcD+qm8tPy1mHNEOc4Hy5k+836Y4B8e1noA3KxW2izWkgOfM9eaRKOgX2PHG083GAwy2qbephw5za0/w5k7R3K4rLhNU3JRuTnxq2C8Lq44T9TYjyeUZxP6jrSnSZaWQmKLYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1HBXXg1r2A4uybuMXNStoqOwoaPoUvQ07N5h0rGmIMA=;
 b=TcT2lyX2BFZl3/dUFoIBbzTHQwN7Q+9hjnNxBhnyR6CbnrKx5eVY4eN3cpjG6LsgNBBGwTEHlPYbmRcm3O7Cu5h6bYz93On3yj8mHN0oNk/6c1BBWqwmCV0O5On8LhHnMuw1AWMoOzxnpkJkTdhSt37Kr/lqzwc4xS3uKSRnvqOw17cp4uR+UmL2gSneFC4h9lYn3BOhTlGgvsqNr1LF51Kz3lHCI3Qu6kIxIgzBmjMY/1BcMvSa05wOzdutnhmWLoadlY86jWYC+ToPDmZ+H4enCcGXFQTBhF3oY+SapwBF3EYOtOnginyLY7FplOTkXmAwCVLdlmVqUuh0vuOxNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HBXXg1r2A4uybuMXNStoqOwoaPoUvQ07N5h0rGmIMA=;
 b=aTZ0uMYWLOKLpP8p2R37PJWK/SYfrLC8FzJS6wXWx7oDjYeOAeFQlT22V/eo1G/S0yX3X3MShBJZa1Yoq2PyNzZ3qg1QJBhekGwEXKI6TYekbHQxgdy7odgzh1iIG93rc3vouRsoBehd8/1D36zz8sM3BJYpFMZAqGlz87mh7QM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BL3PR10MB6258.namprd10.prod.outlook.com
 (2603:10b6:208:38d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:46:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:12 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v4 net-next 0/9] dt-binding preparation for ocelot switches
Date:   Fri,  2 Dec 2022 12:45:50 -0800
Message-Id: <20221202204559.162619-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BL3PR10MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b600fe8-beb5-49b1-23dd-08dad4a63f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNch4x3y/4stmroYJbqItYPaL8GS6o4iLHiYVXPPNOI40ZJc719HY0ED/6Y5MXCcxmAz8MFxt517XcXcckwO8YbFDDCvhxqznBtujlkE+Zh7LpimlpHXNwMTO5ToZTuEmgeBiuhMWhL/20IMNYQHt9LaTMhlRdA/uK3Hp53VysuLpsZe9cHVJs6urXeGl7FaubDf0pX0NGfwgg0r+nHW81YPsvG6dw0YSshou8T1IVI+4QRsLl23DTlXlxeYdtRwHsxV6KT7HmUZTjkLDbUOdSbW/6dBlUHdoXJO7YUhY3obO504p3v5I2E3T8+APtOOiCNo4d3R+Use0EOdkIPdGm5HA5U8G/BD+bPN4JEK5wV4NQW0WHTFMigO/ZZYoxy3Cc6xJoDQ3rDkGOMA6LCZL22Zzas5xLc3X58FOvMScTp8zfrwB0FTmLpCbYOuO/6dD6c2KM17gZHanuVUnfBq79yy4IJj0TRr4V9iul0DMlZxNlvMDyNPNp/t8DvP+dUXptuaRUJM61mkicadQNGReSu2trNsVHcZW9uPaOjBIlsz6j2asxFenMHPSwxQ9soFZaO2QTx7ElnTCtVaQkfswqHvKsdiZQ8CCF/+L1JyUKxUnrNbbfCw2/EeoSjBEFZ0oWgAg3VzuU2AcUvN9OfIeHnmrdL5u5LWRXsROeAOQK0bnVdPNYxOTPUhVallFI+H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39840400004)(346002)(376002)(136003)(366004)(451199015)(36756003)(86362001)(6512007)(54906003)(6486002)(6506007)(52116002)(44832011)(478600001)(7416002)(5660300002)(41300700001)(6666004)(7406005)(66556008)(316002)(4326008)(2906002)(8676002)(66946007)(66476007)(8936002)(38100700002)(38350700002)(1076003)(26005)(186003)(2616005)(83380400001)(66899015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGhMY003NlRybGFrdG9tbE40NGZsaE1IOGhETzhza2Exa2tmYTZJMEsyU0xI?=
 =?utf-8?B?ZTBoYnA0OUVMZXM5b1E1Z09wYU10OXRXVHZ5cTl4U3hVSkNVejZLWm9Bd2ZO?=
 =?utf-8?B?MWYvd3E5UG5QOXYya3hUVmtQalVRelZ3cklCZUdPU01sNFJKNTR1WWFJUE9V?=
 =?utf-8?B?V1ZZZGJoYjFxK2ZsUGVvMVMrQVZ1b1lZNU1CQ0V6czRRK2lTUDZXYTRGMGtV?=
 =?utf-8?B?eVdPRjAyNy8rcXhCdm4zZjhYd2lyblV3TktsdHBiQzNEdXk2Z3V6bG0ya2py?=
 =?utf-8?B?d29VWmZ6aEtERVlPTitBeUdKYTBmbU5tUHh3WHV1U2Qrb0pQTzBZdUZOSEJB?=
 =?utf-8?B?aWNaN3VRTzR5bUNvcHNDdmxZRjVuS080SURzV1NjTmhCL2R3QXhTcFkyTmE0?=
 =?utf-8?B?MTQ3VjVGd1lTVFp4MTQvdWJMcFI3b0JnRW0zL3RDeExrVlZ1TzZvN1hHR0Qr?=
 =?utf-8?B?RnFLWXVGcW8rUlFVQXZkS0dkOEx3RFh4MlJtamRiQ0FWZm5NNkI0S0EzTVh1?=
 =?utf-8?B?YUlOT3dNQk1Va3AyWWxrSGQ0Z3hFOVhXV29VNm54ZG95ZzliT2ZqM2ZreldR?=
 =?utf-8?B?emtsOFBSUjBFTzNob3JZZEJIMmZmNExxdysrcXJORE83Wm45S2kyZWpSVlZn?=
 =?utf-8?B?elNHalFlanFHUS9iVGlGS0crWlR4V1VFS1JwUWhpdnp0OFNvY2U2U0RNbUly?=
 =?utf-8?B?RzcyTU13SDdGdTdBWW9WdThGck52NTFaWEluZitZWFEyb1dGd3JlSHMyU3lt?=
 =?utf-8?B?N1BOZW5rbDhDMmRaODcwYzUzdlZ0TGlKRUltcHRGWEF1TEJMMzBPQmJZV1Jy?=
 =?utf-8?B?eEkzd2VBc3d3bjVDTHRzSDBvOExRb1JOVzc5clhFMjQzbEdCR2RLK01UenNW?=
 =?utf-8?B?Yjl1azVKai9GOXM2cmZWUElkTkxrWjFTbEh2RVVuT2FsQ0hTUnJKZWQ5S21Z?=
 =?utf-8?B?dHFQOGM5YitiWG9Palp5Z2ozWVBqWEFQekh0QklWZ2s4QW1qRjUrL2ZvUFA3?=
 =?utf-8?B?VHBBNmlWeVpaMlhOeERHVlVhRkpPNUhabjBVUmJzRWY4TGpwei9IYWtHWjZZ?=
 =?utf-8?B?aVhKTHdjME5tczVORXFxOVBJNHlkMFRpRndZSVk4em11M0tIWUZxUytudTBI?=
 =?utf-8?B?K3F0TzN0b3FDQTlFb2N2b0tudnByaElnQ2tJODdrK3RyL2E5UDNxcGlWS3NE?=
 =?utf-8?B?aWdabDRrbFNiN0RVL2xFeEtHaldPOXF0M0tiR1dlVEMvTlhieVJTRzFSdVNT?=
 =?utf-8?B?Ukx1R21LY1lYcU5YZEM2QU5uU3RCdFk1aTBYZHlHeTFzcXhjZjdxeDVrY2FD?=
 =?utf-8?B?TUpEdmZJUktZVUJWWWQ2WU5QeG5xa1pEUUNFaFZLUnlwbHpTQ0tuYVNwR3B2?=
 =?utf-8?B?V2Z4MXVJblhKNjdKd0FLbXY1NjhrdXJxeG15WjNTRlRFK2liMHc0L2VKemtQ?=
 =?utf-8?B?QmhGVm5SckNjL080cGNtd3E3WVFlL24rODN1THhGUGU5TVkyQXY5WnlwcHo5?=
 =?utf-8?B?czE1S3pFbExaT3lKaDBLWnpFMzFsWUZMdDNFamkvTnVNQVVFS3dOaml5TDZq?=
 =?utf-8?B?dlpadXE5VmFvOGl1Mzc1ZHg1Wkw2NEVHRk1WMmNsblZ1WHNscWNYdm5iL0Zh?=
 =?utf-8?B?K3NKem1oYkZRSFVDNWNZejhodTBpTThDNGdQU1hGREp2Wi9nTzQyclZFcGJy?=
 =?utf-8?B?TnZibkEyenBBSGZ5NWhLK3B5VUJGeGdHekdlTlpNc0FGYjV4Qzl0cFlCU1BC?=
 =?utf-8?B?V1I5eGsyb2VFb3BSby9hMzNRVXAva3U5VU9NK25pOE1TdE14M21NUlY5RjA5?=
 =?utf-8?B?cHZmaG1xRXVZbUxzYkpiVllwS2s1WXFnUW1pVzNxV0lWRm5BUzI3MFVUellt?=
 =?utf-8?B?QTNHT0dReStuMXhmbmR6Q1poaFlRT3htb1ZCc3l1RktaYlYzRHJwbVRsZWNS?=
 =?utf-8?B?MTlnZmhDdkpDRFY5Ym9QMkRqRGV4Zk9TRUJGT3I3bE54b3IzbTVON2ZSNmc4?=
 =?utf-8?B?c0VSOEI5dlpkV29sa0RkSDgyeHFBaFEwWkt0c2tlV3R0Z2I4aHR1d0o4SFUx?=
 =?utf-8?B?RlhlakN0ajdrbytlU1IrNlF4MDJvamZwSFNTaXp5NGxDMGJ5eTVJY2NzYmly?=
 =?utf-8?B?KzliTm1XbGM0MUpxcjViUVFQaW5mclMybVd1R1dadEI1UWZCRjVrS21UazIz?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b600fe8-beb5-49b1-23dd-08dad4a63f5d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:12.1418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oU0UPrvK7/bYX9FsRY8rrTpGYgXcamszs2uMGF9VKWQv8ThDe8r6txD3oEoi8/TypKTlUrhET+J47WIdUgcZvCl7jExY4yIpPrtp+Sp/iBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6258
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot switches have the abilitiy to be used internally via
memory-mapped IO or externally via SPI or PCIe. This brings up issues
for documentation, where the same chip might be accessed internally in a
switchdev manner, or externally in a DSA configuration. This patch set
is perparation to bring DSA functionality to the VSC7512, utilizing as
much as possible with an almost identical VSC7514 chip.

This patch set changed quite a bit from v2, so I'll omit the background
of how those sets came to be. Rob offered a lot of very useful guidance.
My thanks.

At the end of the day, with this patch set, there should be a framework
to document Ocelot switches (and any switch) in scenarios where they can
be controlled internally (ethernet-switch) or externally (dsa-switch).

---

v3 -> v4
  * Renamed "base" to "ethernet-ports" to avoid confusion with the concept
    of a base class.
  * Squash ("dt-bindings: net: dsa: mediatek,mt7530: fix port description location")
    patch into ("dt-bindings: net: dsa: utilize base definitions for standard dsa
    switches")
  * Corrections to fix confusion about additonalProperties vs unevaluatedProperties.
    See specific patches for details.

v2 -> v3
  * Restructured everything to use a "base" iref for devices that don't
    have additional properties, and simply a "ref" for devices that do.
  * New patches to fix up brcm,sf2, qca8k, and mt7530
  * Fix unevaluatedProperties errors from previous sets (see specific
    patches for more detail)
  * Removed redundant "Device Tree Binding" from titles, where applicable.

v1 -> v2
  * Two MFD patches were brought into the MFD tree, so are dropped
  * Add first patch 1/6 to allow DSA devices to add ports and port
    properties
  * Test qca8k against new dt-bindings and fix warnings. (patch 2/6)
  * Add tags (patch 3/6)
  * Fix vsc7514 refs and properties

---

Colin Foster (9):
  dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
  dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from
    switch node
  dt-bindings: net: dsa: utilize base definitions for standard dsa
    switches
  dt-bindings: net: dsa: allow additional ethernet-port properties
  dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
  dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port
    reference
  dt-bindings: net: add generic ethernet-switch
  dt-bindings: net: add generic ethernet-switch-port binding
  dt-bindings: net: mscc,vsc7514-switch: utilize generic
    ethernet-switch.yaml

 .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml | 15 +++--
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 24 +------
 .../devicetree/bindings/net/dsa/dsa.yaml      | 47 +++++++-------
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 17 ++---
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 14 +----
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 .../bindings/net/ethernet-switch-port.yaml    | 25 ++++++++
 .../bindings/net/ethernet-switch.yaml         | 62 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 +---------
 MAINTAINERS                                   |  2 +
 18 files changed, 142 insertions(+), 113 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

