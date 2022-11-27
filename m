Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC23E639DA5
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiK0Wrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK0Wru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:47:50 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45581DEA5;
        Sun, 27 Nov 2022 14:47:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqsDrH3CK+CCLyjDxDQ5GHZjKskl33SKwRgFtVNtxm0HlXpFHa9EKi/n2zHGgGuDT9dA5ZcQdEsEOM47/CsNi0H2OzKzpDFMqKq4GjP/rj+RbWuCNwlWGiGJeUeVsXoopVeb+Llmqeq86CbZU4ABy8pRAkm2/UrowYTpRaGaq8XVgNaJ+gE+TBpJIro59VVfUNMIaXjh79DNcNk8ZmlvmfGzPTNqWXuYwxqwgeXZvgGTbcagayuIyBaS+DzO5hgbLdf0TL85/ouHKwA2YyURX7Nvf/2UYIkODbX/Y1oK5Yu8WG//ns/hr3bU1youBVlrx0ZR/yN7KedmK+7FBf/UnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWqmAsxGEqCHpnf5VYOCyVMh+tFsVdWiQUD69klJ4yM=;
 b=LHi4aqxlSBtcK3e+lYR5IHQxmfxWgXiu3ciXlynHzIt1gzv48DNxm0KGCteXFCbJlle3p7xSFwKot5Lne1jhYZTdMK0WTSfObdh0hKIFpyOUcO13k/geT9NI6DqRy5K4ntoT6/niX1l/x99O+62KYeelVZJswmByujlQZLT9JFLksARgSMTL9oYPdnsrH2r4Ad1bjzP2aevRrpo/QTMmBOUPTkxtD63NByWegczpUa22lpxWME+8EnuBxc2VHqDoP6gUAzIYtzaPsMoZ0a/GMZkz8DC9EX9elHoy3VHr24Q5Y+1CZ/1jOUh2qBoc63Uy4ZlGNZ7hsfP/sH0onGA/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWqmAsxGEqCHpnf5VYOCyVMh+tFsVdWiQUD69klJ4yM=;
 b=AZ67X7p0haHyHYVODn/MH05UJh2C1STi+6Vn86/N54kSikuUpqqiFZ6UaNUV2hxjv332COzccSBZzPrtoA1TogvDH72541saaJbHR8fmzXk6glyukj/j/3X4nLqmDhSgSrAgtrwK0CdP/Bzvj+yOgAGPFN/C66cN6M0z6pP1q2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:46 +0000
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
Subject: [PATCH v3 net-next 00/10] dt-binding preparation for ocelot switches
Date:   Sun, 27 Nov 2022 14:47:24 -0800
Message-Id: <20221127224734.885526-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: 0207d6c2-2448-4bb3-85ed-08dad0c966f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2wvTFUzjNytosAcIieJlJiROOmsfrn0OtCUjQMHzW6Y8t6QS+n3t7B7/rg9aDKqIxqe6AKJucIqEaSS9hYb7sQYBZMzkuNqNj38VB9x2JBoOS+WVlCXTqwh9lbOTb9fCv3snnoX50tEry8BhMsnv3M+ziqVhu/RqHTG05XDKQWLdRDyLi6dvKKV5q/vEBaGLqORRmK0EE3RwdurQ6fkfpVASMsuu1A7BMJIVVT7R2VqptAwG9/K52/3gLPGc1oF+xrOqmJBwwK3xRRULsKUHSxJJJMjioV7ayqqOV3zT47K+PtzUosTDGzDMgYUVx1DEMNqu1hY7+Lkv39DU/fWG9d8Evf5BoBDaMudh+LLMrmqyQIoOsmPfVZGepFCQDTHJavxKJ+MVNF/Z5DxBb95br5QiaiRmrLC9R/JEWr4Fum++hb1P8buUd4LqaSxusmlEnyaikIHcXbWQ001BcCMHeEQwXEw4k5i6ltI8qHUPl9qcE361jSr2IR89EC3WrTIqgk8t7bhQwIj+x4o5mlZxZW5pTMtH2DiqFQoAp1xQ91JsVqefADRcO3xG/VrKow0BYdaipUBEkmWSIfSTDGq8adH1DPMFp/XccXHgCgvjsj3b64q5WMPU6JKxlDUgEICPZxLuE/ve9hcGbJDi0ywChTrnlmvkSsCZ8GckT91Qxq4HdX5Lws1/fmU2luhlvZqNmaKGkyFUnjXk1t2I5o+7pUs0YZsIduXDOsZNKYoSe0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(966005)(6486002)(478600001)(52116002)(53546011)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(66899015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TCt4TitTc0I1NUZTMmxZNkNwN0ljTzJ1MytPenhtZ2xUSjZmWFhmRktpK1o3?=
 =?utf-8?B?YVpiaFQ0cUVkMXlmV0V0SmpZNzJlUkNGSkcwTkVFTWhCMTRwajBvNS9IclhQ?=
 =?utf-8?B?eS9jaTVUSVBzQXVodFUzRXpZSzNsbWN3QWZPMXNKeW4vdzAyZ29pUkRnd0l4?=
 =?utf-8?B?TUZsY1ZCM08xMkx6SFRtNHZncklTM0IzdjVZVWltRkMyeWpjVGhxYS9LSGpM?=
 =?utf-8?B?RlhvRUdnQnFKdXFRamt0NTZ0WE9WMm45dDhQQUc2Zzk0c0p5Z2l4SUYvbGpN?=
 =?utf-8?B?L2c1RTBITHh2TzBueHVsZEVUZjNGb0dkcEQ0THUrNDJQODlac240SHdiQzRN?=
 =?utf-8?B?NEY2Z2tJYkMzdFJ0UlpqQ1BTMGhSVThKSDlYMHdpSHNxYWpHdGM0aDc3NDBp?=
 =?utf-8?B?RWg3eGZmTmQraUFCVEZ1alR5RmgrR3ZWR3BZWEx3NHFrbXJTWW55UEtNRmt4?=
 =?utf-8?B?ZENtV29BL1FkRTVvSEd0QnRpZFZaZWp4aHI2amora0RZTVFaZjduTTBRb0Iy?=
 =?utf-8?B?Rm1xM29QejlaWlU1dzg5MXd3Qnp4RDBmQTlGRUxSTWpSQTZIWjRkZmNwb3lF?=
 =?utf-8?B?WmpyWXRPcWhaKy9vZktQOXFnN2c5cEQzU3lrcWl3eG5CMXpMZTlzSGVKbkRH?=
 =?utf-8?B?ai9hVkx6VllzNUxPVnlnUmtUaHBhTnVCcnF2c1FFNnBpaG96VlVQZ25ZMFFr?=
 =?utf-8?B?UVNqdlQrY3BodWRSTExzYTkxRWFsREIwOStrYWx4TWhBK1JTd1BmdGxJalFU?=
 =?utf-8?B?NnlPNTRMOTE2MWZnWWZoUmFockdUamdFNFAzaE5vMGsxanVHTnhINGx5dEpp?=
 =?utf-8?B?c3dCSEtWVjZiWDFNK2I0NG5tdnY0MTFSSTVEQzF4TXdFcnA3Y3lRWXZyWnVE?=
 =?utf-8?B?Y2VIb05OMUdpN2h0NVc3U2pEWkRsUit2anRCWTRwWFNOOVNIejlmYVZKcCtX?=
 =?utf-8?B?UVJ1MWNXcm5NR0NaZW9zOHpjd3ptaHExT1dDV1JvUWY2ZmdDdUJ0aWhnNU1D?=
 =?utf-8?B?MkFxL0Q2cTkwbzZ6SlRHTGhTczFnUUphWnNhZStsU1pLNTBwKzhNM0FhZjhh?=
 =?utf-8?B?Q3J5QnhGTEQ1bjMzZnZMYWxmNW5aZGxFYzZSbnRkdWxFVnhkWVFMc3hIUE5n?=
 =?utf-8?B?dUZzSlViV3E4SHI1a3RiZlpyaTVGN2l3QjVwblJ6UFVqY2MvR2VYK2lKdlNo?=
 =?utf-8?B?b1F5ckZHL21TcldPS3NzeWhGZU5vOUFDbC84WUt4Smp2eDljeEFRYUYzTXla?=
 =?utf-8?B?WWQ1amR3bUg1TlY1QzVKbThxaE4yMjRRRThjcGNpUmk3S0NuWW11dmxRRklO?=
 =?utf-8?B?R0diVmgrSTl6Yi8xd2tTbHRlSFMrVElleVpRd1VNL2JSSHVVaytxL0pKaDI2?=
 =?utf-8?B?anZ3RnhnaEFPRUpEQXVzZEozT2R4aDcrQUdoNWhpUkZPN2tnWFdnRU5abkcx?=
 =?utf-8?B?VVc0dEtzOGNYTVljSHhUejVvOEdaekY1Rll3WWVEUWFaSkRhUStkc0tvdUxt?=
 =?utf-8?B?c2VKRDRyU3RtTk5pMHFibWlocE90ZWRpbThTMXRxblRKOGptZThJRVV4eVcz?=
 =?utf-8?B?OGg5cE1UN3dUYlc2YnpiWnlMbWlsdTlGTEhHMVluSmpGREd3K3BiUTMrVjBF?=
 =?utf-8?B?UjMyT01KRjAvWFlXeE13RjlWVGZBcDl3MEVuUTcxVDVrMXhBZ0duczNEU0lh?=
 =?utf-8?B?ZzdPUGFXdHRubTQrajVwZmNGY0wxRDVDbjVGdm80N0ZOZk0wdjFzYk1hN2NM?=
 =?utf-8?B?U2RuWTRlVFFSeUMvdTB0eWRqZ2xDNzBQRFgvRytiWFdqeGl5VmRNanJsUFZ6?=
 =?utf-8?B?ZFlFN0xjdXFxZVI2eElTNkVtYmlpR1NmNTJ6b1lzTENNTmtnVnpYTWtSdURv?=
 =?utf-8?B?amJpMmpKWVd4Z1o5K1d6Nk93WjV0aTFRRDJKY2N5V1cwQnk5a3FwZy8rOGMy?=
 =?utf-8?B?bEFnc2pDcW5iSDBGdThDOWNJeFlpVkgrbWptNnZ0UGh3L3g4RzZoWXl1a0Jq?=
 =?utf-8?B?K2R5L1NJajJWWEpZOEN0eTQ1TCsyWExMMUxHSThJanlOU3JJZkNnZHgwZ0l5?=
 =?utf-8?B?RzZ2cEEyMEE1WW8vN2RQWXk2Ujcwenl4QXM4VHl4bnhzeDBiejB2NURWL1Y0?=
 =?utf-8?B?WEo5S1gxYk1OUzhpV2U2a0xpeW9TWXFLL2hnUWdZYnliOUlOMG53dTdMRFBS?=
 =?utf-8?B?TXc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0207d6c2-2448-4bb3-85ed-08dad0c966f6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:46.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFIVrosDCTWyQr8z1S+BhwyL7dVf5C/f7j86RzI/hkAn2wSTZnkoTJnjI3yjWiZMATr+FeXH77lsnIsvB4WfU106Tfl5Z3/9MkgCUgQfjMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
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

Colin Foster (10):
  dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
  dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from
    switch node
  dt-bindings: net: dsa: utilize base definitions for standard dsa
    switches
  dt-bindings: net: dsa: allow additional ethernet-port properties
  dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
  dt-bindings: net: dsa: mediatek,mt7530: fix port description location
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
 .../devicetree/bindings/net/dsa/dsa.yaml      | 37 +++++------
 .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 17 ++---
 .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
 .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
 .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 15 +----
 .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
 .../bindings/net/ethernet-switch-port.yaml    | 25 ++++++++
 .../bindings/net/ethernet-switch.yaml         | 62 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 +---------
 MAINTAINERS                                   |  2 +
 18 files changed, 134 insertions(+), 112 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

From 20867224faa46fc375f31b11aece705af091151a Mon Sep 17 00:00:00 2001
From: Colin Foster <colin.foster@in-advantage.com>
Date: Thu, 3 Nov 2022 21:10:02 -0700
Subject: [PATCH v2 net-next 0/6] dt-binding preparation for ocelot switches
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ocelot switches have the abilitiy to be used internally via
memory-mapped IO or externally via SPI or PCIe. This brings up issues
for documentation, where the same chip might be accessed internally in a
switchdev manner, or externally in a DSA configuration. This patch set
is perparation to bring DSA functionality to the VSC7512, utilizing as
much as possible with an almost identical VSC7514 chip.

During the most recent RFC for internal ethernet switch functionality to
the VSC7512, there were 10 steps laid out to adequately prepare
documentation:

https://lore.kernel.org/all/20221010174856.nd3n4soxk7zbmcm7@skbuf/

The full context is quoted below. This patch set represents steps 1-7 of
the 10 steps, with the remaining steps to likely be part of what was the
original RFC.

The first two patches are specifically rewording and fixing of the MFD
bindings. I kept them in this patch set since they might cause conflicts
with future documentation changes that will be part of the net-next
tree. I can separate them if desired.



Context:

```
To end the discussion on a constructive note, I think if I were Colin,
I would do the following, in the following order, according to what was
expressed as a constraint:

1. Reword the "driver" word out of mscc,vsc7514-switch.yaml and express
   the description in terms of what the switch can do, not what the
   driver can do.

2. Make qca8k.yaml have "$ref: dsa.yaml#". Remove "$ref: dsa-port.yaml#"
   from the same schema.

3. Remove "- $ref: dsa-port.yaml#" from mediatek,mt7530.yaml. It doesn't
   seem to be needed, since dsa.yaml also has this. We need this because
   we want to make sure no one except dsa.yaml references dsa-port.yaml.

4. Move the DSA-unspecific portion from dsa.yaml into a new
   ethernet-switch.yaml. What remains in dsa.yaml is "dsa,member".
   The dsa.yaml schema will have "$ref: ethernet-switch.yaml#" for the
   "(ethernet-)switch" node, plus its custom additions.

5. Move the DSA-unspecific portion from dsa-port.yaml into a new
   ethernet-switch-port.yaml. What remains in dsa-port.yaml is:
   * ethernet phandle
   * link phandle
   * label property
   * dsa-tag-protocol property
   * the constraint that CPU and DSA ports must have phylink bindings

6. The ethernet-switch.yaml will have "$ref: ethernet-switch-port.yaml#"
   and "$ref: dsa-port.yaml". The dsa-port.yaml schema will *not* have
   "$ref: ethernet-switch-port.yaml#", just its custom additions.
   I'm not 100% on this, but I think there will be a problem if:
   - dsa.yaml references ethernet-switch.yaml
     - ethernet-switch.yaml references ethernet-switch-port.yaml
   - dsa.yaml also references dsa-port.yaml
     - dsa-port.yaml references ethernet-switch-port.yaml
   because ethernet-switch-port.yaml will be referenced twice. Again,
   not sure if this is a problem. If it isn't, things can be simpler,
   just make dsa-port.yaml reference ethernet-switch-port.yaml, and skip
   steps 2 and 3 since dsa-port.yaml containing just the DSA specifics
   is no longer problematic.

7. Make mscc,vsc7514-switch.yaml have "$ref: ethernet-switch.yaml#" for
   the "mscc,vsc7514-switch.yaml" compatible string. This will eliminate
   its own definitions for the generic properties: $nodename and
   ethernet-ports (~45 lines of code if I'm not mistaken).

8. Introduce the "mscc,vsc7512-switch" compatible string as part of
   mscc,vsc7514-switch.yaml, but this will have "$ref: dsa.yaml#" (this
   will have to be referenced by full path because they are in different
   folders) instead of "ethernet-switch.yaml". Doing this will include
   the common bindings for a switch, plus the DSA specifics.

9. Optional: rework ti,cpsw-switch.yaml, microchip,lan966x-switch.yaml,
   microchip,sparx5-switch.yaml to have "$ref: ethernet-switch.yaml#"
   which should reduce some duplication in existing schemas.

10. Question for future support of VSC7514 in DSA mode: how do we decide
    whether to $ref: ethernet-switch.yaml or dsa.yaml? If the parent MFD
    node has a compatible string similar to "mscc,vsc7512", then use DSA,
    otherwise use generic ethernet-switch?
```

Colin Foster (6):
  dt-bindings: net: dsa: allow additional ethernet-port properties
  dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
  dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port
    reference
  dt-bindings: net: add generic ethernet-switch
  dt-bindings: net: add generic ethernet-switch-port binding
  dt-bindings: net: mscc,vsc7514-switch: utilize generic
    ethernet-switch.yaml

 .../devicetree/bindings/net/dsa/dsa-port.yaml | 27 +---------
 .../devicetree/bindings/net/dsa/dsa.yaml      | 26 +---------
 .../bindings/net/dsa/mediatek,mt7530.yaml     |  3 --
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 18 +++----
 .../bindings/net/ethernet-switch-port.yaml    | 44 ++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         | 51 +++++++++++++++++++
 .../bindings/net/mscc,vsc7514-switch.yaml     | 40 ++-------------
 MAINTAINERS                                   |  2 +
 8 files changed, 112 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

-- 
2.25.1

