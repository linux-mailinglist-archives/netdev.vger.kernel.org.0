Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CCB66CE37
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjAPSDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjAPSCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:02:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597D7274B3;
        Mon, 16 Jan 2023 09:47:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjFmo+jtOpIIdiBD9XQt9WKos07PfHVt7oklSs7rSxq02Hv6829B93jLCJD+UhZH9SN3k4ywU1y33fSrnRehMui4u8lkjrhqKp4t0bQEsiDvUNAFFfvDz/q/YQ6sYMCyyinOHt0Ezg2zXpqgI1cPiGeerflEqhg8vOeS3EwX2xTmmUO38cxnFNU291f4l5fc2fa11bKL8FpcjPH1fz0SwULnAICT3VJOdszl0Hb9dRgrG2kuobK0MOJ/XVuF8bqBkHkivMR9N4px3RLV04ayaG9ey4MXtIxFPVhU8l9gnp/i0DLzF+yvRTZC0mOo03D1PStCQ7pHxljDFiHtwS7zgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5f0UBgCPp3tFWqM3s+p8DvuQ09mTPhTTw+4Y7XQLJWk=;
 b=oCMNqPtLxyiLTBYM5wYc5phbkawZDSZt/HpFWeoj8rCEQoM/bsRard0ENlYrFO6GsRRVmQbP5mLzr9wnjhegaqtVcCVxoS0pYbS9dSLuVasxRe0vssY9ZchOXB6x/yp/HArgJ9DoyfetJAiDaa9XWx6P35H983wPLHHn/XDpXVHPwew5Ll6fvn2Hx797ghKaWjC/BM3+lJU1sQW3ASaPWW1wrJrvda24xYHxJaIeY7FsZMpibmqvsVyzQX8nlbFbb2OAmOXvGCf/rqTIsLsnATsTrHNo1a2HBmoR6X5orCVfpN0X0i9inrGUOyA8NXPzfVkZvixgxnva5uvzgyUeqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f0UBgCPp3tFWqM3s+p8DvuQ09mTPhTTw+4Y7XQLJWk=;
 b=zW+iqsqvWJ+nryGLM4izEhyshGplvmS1bomIzVWmsR0Rj2MmUb/NNhufIUIbKrugcaEgCAatzsICtG9GCr+BRBh5pWd3ifFwunDba+fGe1Tv+BNYPKeT3noySjdmSTlsxMTPaNojIB29Dq3W41bw0SH+yXVwSoCidNrS2zUsEVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4151.namprd10.prod.outlook.com
 (2603:10b6:610:aa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 16 Jan
 2023 17:47:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 17:47:01 +0000
Date:   Mon, 16 Jan 2023 07:47:00 -1000
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
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v7 net-next 00/10] dt-binding preparation for ocelot
 switches
Message-ID: <Y8WNlBD+R1J1lAIx@MSI.localdomain>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: BYAPR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH2PR10MB4151:EE_
X-MS-Office365-Filtering-Correlation-Id: 89994719-4834-4a12-f8d3-08daf7e9abb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkxRWVsFibY+VXIc+gQ6zElsP5uQ6yvht1WTMThSMVWM865RqcuzBK0wZH8MrO/zKY4CnQ+7hPvuJJSexd0Jk/TwwXi6vfb6r0sV9rLxEahRghaye5/OJ327Uxsx8JkGq/7RdamaPcTJcEWJLYj4+bcEq4c9/ymJKq4WGdPnzz3yl1z5Px7U67l9um5CX9qGDi8JcFlHR4kYJ9HIKa3ybOXwMI6vDqB8xi9AHwequ9ifPYiZfXsI4Guqxn8uYYlu6ImGpxnYqwodkbQozBJorSJghQPOidWsALaK7V2RX6LTRgFcPK8XPxvA0dOluJEVtDJK54PW6HCCFkqiuvCqPlc8+B2p2i4xE97A/R4YV441ES1TyOyw3V86rloIwrDwY8w8PwJ60ELpyAilSJuoZJWbIWql/3se3fsWLFCBILBd1hJmJOuV+kUlG+deLcNk0kkR5bZSFG3acsGa+j+BjXIoBw5XIdmsIPyYWM4yVhPtNozMi9hbZVTCGjmtEZ5wRHDk+071Bot06XF6YAZS8+pQz8F4d7VI7NNt3mvzk0jo5a8hHn8M6/CS/AN2YJzmXl/uWMIIox37vcA+2RbN3p0XcAUv7btVoHY0L9NSsb9iLTX0E+4/jyOCnTDipKOqK626jgAzbiWQ6/Fk0Ko+dz72lFUMASwrX8AqtcMoUzxbl5vbwLQl4620RggujbXB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39830400003)(396003)(346002)(366004)(136003)(451199015)(6486002)(478600001)(2906002)(38100700002)(86362001)(6512007)(83380400001)(9686003)(6506007)(66899015)(186003)(66946007)(7406005)(5660300002)(4326008)(7416002)(66476007)(66556008)(41300700001)(8676002)(316002)(8936002)(54906003)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Mt/FZjmMD3waVzgCqyU2RGWXLouxqsFRRodjFPX2/jIKjteKbZ+oL98MAnU?=
 =?us-ascii?Q?6vEt3KWuPrJv5k6gh4duDdYIUwjSgCqTFdRcA/pQQaYUulh0dGoi/zQgSWZQ?=
 =?us-ascii?Q?tN0e3IGbzhnPXzFopRrn7ZHEbgWGBqWkmW9l+dUkheYNUVYZ9+qauaPE+Ii7?=
 =?us-ascii?Q?c+UM/u08whvbnmWPpZaYRjsCQ/stAUDzrtB0YqNQhm+DKa0kuKOcXuZ/AvvJ?=
 =?us-ascii?Q?A+aJWJYPMnNxEI+q2zMQyPSnsywXPQbrfzwG7IPzYOXj1FqoxywDZBHlWRji?=
 =?us-ascii?Q?RMa6pvz3+xbKDWh/AhPvE2+Y/bRc0LmYn0SQDq5zKXE8L+0rF9E6oOGj6NGY?=
 =?us-ascii?Q?EbMd2jZZspUr1HMKY1Mw63zJW8SKoA98XRoQddZSV8bpR3JSWT7IW4sY1SqX?=
 =?us-ascii?Q?1YQPI5yBTcwMchw1Pbe027avIKaczmpV0ZtRmXbUa5vPCM044rnX7LM35p8w?=
 =?us-ascii?Q?WGKRQNmeyZvZ2Q5mGRQB4ZIGjXEJj2BUUp5jQKrdVD6HaJlXv2gsT6Yyjs7c?=
 =?us-ascii?Q?D6XF5lVW8VVknOmN+3p1ohOjFGExlj6uooh+DQaE8NCv18u5OiA+VnuorFr9?=
 =?us-ascii?Q?Gx5Isw1xBOw33qT+NwPrq4L+fhSiNXDxh4xzR8P0cf8yIfT2mnz0EOMV4EQ4?=
 =?us-ascii?Q?kmS05zpwCwJDMKblLNxKTDukemlTPsoQFmii2wy506Cr/0IRSi+2HZ3h3Ikd?=
 =?us-ascii?Q?O5xAXa+Hni2wbwewsa0mVgIoudGC4T9qYxAXhAp/ppRidX6Bpvnj8QeZTnzw?=
 =?us-ascii?Q?obZnzQ6kF71Xp2q4Kpq5wRGKQxk2HIpSff2izyTn/whFwnDMhjmVylyp03jl?=
 =?us-ascii?Q?YR1w+vWac/B6fuya/dr6+n7bk9zZ6wLLViAUEF71jI2hEsau+KG9ISFymvbE?=
 =?us-ascii?Q?QZQb50Psd6U70ti7E2RANV+ly63y2WivDCcitVKCGDNdUmGsODByQ77lPQvq?=
 =?us-ascii?Q?QOjW7N1tWVYf+TBQ8Olvq5xI5j8K+wGn7Sx0rG6pI9m2JiKuFIVgWktYUUv6?=
 =?us-ascii?Q?3NfthUAwlbqdKGcMucyT5K1YHbpvUDRKgOt3meH3GdQ/9fmNTqr0SKYddG6a?=
 =?us-ascii?Q?4uJlViEzyGAguY/3KJYNEmh2MbjbMtAf00Og6cavBx9+0dY2jdaj+6LnZ7nu?=
 =?us-ascii?Q?ixzIjVdz7upaVq5R2jfAQ6y/OJDnDn+Noq+eVYkcAMPODLnYpAtvD3YALhOO?=
 =?us-ascii?Q?BwDzMsxwCedM2t1n8MSlKdY9NkDqUwc+7yb5GfYMwVlmnQtICmS1Davu+LCY?=
 =?us-ascii?Q?gR7WT8n8ZTBoFFACmZ21/ffmaGGpQDzi9TY4OeWDikyTBr3bbJLGdzGMDO0+?=
 =?us-ascii?Q?YeSciJeop6CUdeRfsX3tgLAYX7mJIFBQXqQ8E+MS5ysqaKm6kkRCXBCaaB4m?=
 =?us-ascii?Q?fs6DiV80/Ti7GwEQFWNkMB7S+7WH26jjsJ9qR9h/fWBBRKAxsG4HIUvSTf5h?=
 =?us-ascii?Q?cuFG8JV2kfrYQwF0784ELTrGkkIytEZV2zep98d2drE1Wqvqimkc3EJqdvlX?=
 =?us-ascii?Q?iFDKfdd3qWmiZVAwVVM6IuoBw1bKRpKgrP+BL0dTb3uvMgOUbAdUw8tsVRKi?=
 =?us-ascii?Q?Bh1tL+QIJUxq5D1NJkzZRr2lcevuCWIC5cejWO9X3rdgSnIu0a5HnJQlG+mR?=
 =?us-ascii?Q?KZIrWypmiDnkYs5Bik1IJIo/IsgOIhLIffGg5eKSxgUCLkN5dpZWqgd1z0km?=
 =?us-ascii?Q?ZLEAm4SayB+xUDInPwD9GoUkeEs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89994719-4834-4a12-f8d3-08daf7e9abb4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 17:47:01.0457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZUwMgB5k6AJTZ/2F6SHdwEqMu9BMFSRVhqXWXX8kVIz3fTkw2rQ12j2cm1AoggO46cklIkNKGVc/cjp9kHbocXLCzfvINOqY/PIe1EJugM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4151
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I saw on Patchwork I'd missed Krzysztof's CC. Apologies - I missed it
in a copy-paste error.

On Thu, Jan 12, 2023 at 07:56:03AM -1000, Colin Foster wrote:
> Ocelot switches have the abilitiy to be used internally via
> memory-mapped IO or externally via SPI or PCIe. This brings up issues
> for documentation, where the same chip might be accessed internally in a
> switchdev manner, or externally in a DSA configuration. This patch set
> is perparation to bring DSA functionality to the VSC7512, utilizing as
> much as possible with an almost identical VSC7514 chip.
> 
> This patch set changed quite a bit from v2, so I'll omit the background
> of how those sets came to be. Rob offered a lot of very useful guidance.
> My thanks.
> 
> At the end of the day, with this patch set, there should be a framework
> to document Ocelot switches (and any switch) in scenarios where they can
> be controlled internally (ethernet-switch) or externally (dsa-switch).
> 
> ---
> 
> v6 -> v7
>   * Add Reviewed / Acked on patch 1
>   * Clean up descriptions on Ethernet / DSA switch port bindings
> 
> v5 -> v6
>   * Rebase so it applies to net-next cleanly.
>   * No other changes - during the last submission round I said I'd
>     submit v6 with a change to move $dsa-port.yaml to outside the allOf
>     list. In retrospect that wasn't the right thing to do, because later
>     in the patch series the $dsa-port.yaml is removed outright. So I
>     believe the submission in v5 to keep "type: object" was correct.
> 
> v4 -> v5
>   * Sync DSA maintainers with MAINTAINERS file (new patch 1)
>   * Undo move of port description of mediatek,mt7530.yaml (patch 4)
>   * Move removal of "^(ethernet-)?switch(@.*)?$" in dsa.yaml from patch 4
>     to patch 8
>   * Add more consistent capitalization in title lines and better Ethernet
>     switch port description. (patch 8)
> 
> v3 -> v4
>   * Renamed "base" to "ethernet-ports" to avoid confusion with the concept
>     of a base class.
>   * Squash ("dt-bindings: net: dsa: mediatek,mt7530: fix port description location")
>     patch into ("dt-bindings: net: dsa: utilize base definitions for standard dsa
>     switches")
>   * Corrections to fix confusion about additonalProperties vs unevaluatedProperties.
>     See specific patches for details.
> 
> v2 -> v3
>   * Restructured everything to use a "base" iref for devices that don't
>     have additional properties, and simply a "ref" for devices that do.
>   * New patches to fix up brcm,sf2, qca8k, and mt7530
>   * Fix unevaluatedProperties errors from previous sets (see specific
>     patches for more detail)
>   * Removed redundant "Device Tree Binding" from titles, where applicable.
> 
> v1 -> v2
>   * Two MFD patches were brought into the MFD tree, so are dropped
>   * Add first patch 1/6 to allow DSA devices to add ports and port
>     properties
>   * Test qca8k against new dt-bindings and fix warnings. (patch 2/6)
>   * Add tags (patch 3/6)
>   * Fix vsc7514 refs and properties
> 
> ---
> 
> Colin Foster (10):
>   dt-bindings: dsa: sync with maintainers
>   dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
>   dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from
>     switch node
>   dt-bindings: net: dsa: utilize base definitions for standard dsa
>     switches
>   dt-bindings: net: dsa: allow additional ethernet-port properties
>   dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
>   dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port
>     reference
>   dt-bindings: net: add generic ethernet-switch
>   dt-bindings: net: add generic ethernet-switch-port binding
>   dt-bindings: net: mscc,vsc7514-switch: utilize generic
>     ethernet-switch.yaml
> 
>  .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
>  .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
>  .../devicetree/bindings/net/dsa/brcm,sf2.yaml | 15 +++--
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 30 ++-------
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 49 +++++++--------
>  .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
>  .../bindings/net/dsa/mediatek,mt7530.yaml     |  6 +-
>  .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
>  .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
>  .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
>  .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 14 +----
>  .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
>  .../bindings/net/ethernet-switch-port.yaml    | 26 ++++++++
>  .../bindings/net/ethernet-switch.yaml         | 62 +++++++++++++++++++
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 31 +---------
>  MAINTAINERS                                   |  2 +
>  18 files changed, 145 insertions(+), 108 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml
> 
> -- 
> 2.25.1
> 
