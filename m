Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B99561B25
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbiF3NSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3NR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:17:59 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2044.outbound.protection.outlook.com [40.107.22.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7EA23BE4;
        Thu, 30 Jun 2022 06:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRx8WTwJJpRLeVbJVlsIFgeHoxtXFmF9TH/kNZbmX2AK8OfoP/5BjxC/6LiI+9xqcsLQ6EzUW+5r14FAR5S9mY70RRLIQiZJ88oyIL2aEI3rlFaP3rycJNHZQI5VPT+GukTtqhAkNI7Zaj6G09TuAPfu9IiO3gI/AzHH4d3c+rGTker5YW9yrZ0AxNFTfMOV1AfcJJGp4WgNtCrx7nuFvFei9bNwCZ9qIsxdseQUr6hRyrY1YVhjk0zeLwLSh+HrmDitW8KJm4378J76ZhbD+bRuSXTvO19kwOPlFod1HVQPHlDN6dR8CRnxg2RWe7x9A/goUieM4dPA8Y1XZ9gQ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3kJC0F4dzI270l1oBNriMcuZWzLafESZ7zNWb6XWAFc=;
 b=lXrHTdYDrTL/EMe7ZazujchydKGhAvvM5+nYUWweVnihEB26bgSeFKcthzB5KH4C2tsGTB9zj3oEd93WppWJFjQmI0Mkot3pS3dOvc3jdQ6rjpEl2BytmlbYbHI9WCqavK1tDEtmqGxDXJLNR7ny3Lkn/oA064X4ZpB5bITTBcn4Y/y6rJH/f6pwo6jui1SlwSwSUDO6OBCfMBraV35QpD6/IPjFZwp2W2AJ+WotpF50nNLVEbj+FqNnYctOk0AiRVVM20GccdGp5IaEENHh2GCAgaQYbiZKHQJowbDHyZXcR8kKVIZILYRNMZfJBIF8gXw1C80BI0/2cGrXkpwjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kJC0F4dzI270l1oBNriMcuZWzLafESZ7zNWb6XWAFc=;
 b=kp9j+4GPk+aXlSEOdiyjQh7xsDmfhvTIhHNSTDcn8eEBfTccyGkjpIqZaFY6TXDptzvqjtpCzx7i26tjZmTb5Xe0OddVeY4sFEHYBk38ll+gSKje8+1Solth8rwo+HrpfbesqUmnk8GA54dj27ZMJt5cWvkeXCeuAW46ZzfgwQ4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0402MB2705.eurprd04.prod.outlook.com (2603:10a6:203:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 13:17:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 13:17:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v11 net-next 8/9] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Thread-Topic: [PATCH v11 net-next 8/9] dt-bindings: mfd: ocelot: add bindings
 for VSC7512
Thread-Index: AQHYiseI5Ejf1g0+MkWBDpn74utZPa1n8gyA
Date:   Thu, 30 Jun 2022 13:17:54 +0000
Message-ID: <20220630131753.sjy4jjrdfqzfdk4n@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-9-colin.foster@in-advantage.com>
In-Reply-To: <20220628081709.829811-9-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88827cb3-c52d-41b2-1294-08da5a9af184
x-ms-traffictypediagnostic: AM5PR0402MB2705:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vIvzhGRGx0kFwdRtStNEecNUWAgyai9Nz+Ev82l9weqea/V/R8z4r46QwePReE7Y4TaRAlydj/Ql6yFBVIWtMd2+ow2Fj2sunIftlEA4A9WxfT4gs6ktdQf9Bpzk40VeztwcIj3QExi0iwFy9nVYb+OcVpi0jJu5jrMm+e2aiTE4wukzjezz0ywW6wqTDTkNAfHtVVlceArYX4FhDY3g4gNL5WKnXUj58+Ws9Yakn3i66LlSO5DkJ8TD7uI6USQnbQp7qZis4oddKt2F8ULb/JatKHDwx2wpyMkBaXVH4tW5s6SysNHQXSwksfFxj45pZ8L16XbPCkak5fb0EKzOOf8tZxqlLjoAQvgNtSc4wTSAI92zTJOEauTcRLOn0kIpqM6V4B9m5u21j1h9Ui5Sd2V/YpfbFtqsdTA+jGOuiiOK5H2336101SZflmuHLO0uTqtZDhrv7Wb8BBv3Y62N7Tv1b/KQpg2xq7bQLO0CSvwEVjV/Xhr9Pk14eLj1lN3nCDbddSxqbYpQFudLu8aI6N6Oa0akQ/cdA3/XAPP7SKc8mW2O2bPNgB8dfS6qldrC0ffjKvRjeFpu5w685vxJjjcDMEHJsvMvwmSknCyfEyhBGn67xZz/2A1zVEVn1Sw4I4FEnVNAXyR0cTgHhSiXkaWWOuy/N4E+BZeM4XILS8AgBDQ+/jT5h73laLghPayrVJKQf87cDKN3JDmlOeIWHm00RQQ0+RY91NfwQpSjrZ2l9ohtru7bA0iJ4nq8vBkr54GHUZ3F6GCx1vEMXaSVP8NgzI6GtToPlnECBONhUjZpWFlynG4WNGHQeCE6O/cZPAl13mFHu2NyYCqG8EMqeSvcxOKLkcijLYBkC6faWyRIiuxe9wseYmZdxYbchPmO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(966005)(478600001)(6486002)(91956017)(38100700002)(8676002)(86362001)(64756008)(71200400001)(6512007)(41300700001)(66946007)(6506007)(9686003)(26005)(54906003)(66446008)(186003)(66476007)(76116006)(6916009)(316002)(66556008)(1076003)(122000001)(33716001)(8936002)(44832011)(2906002)(5660300002)(7416002)(83380400001)(38070700005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jtXcmJZuM8yNt07bdLxeaQxdUWBKPwphb4Ck+/MgTtHgu+uqwAA0sGQvY+0T?=
 =?us-ascii?Q?3EDTZe1tRL7Eqco5pE+QFCkAefxcdyjTQWmQ9qFpzMXB3Vq5Zn9ZNgV0wMTe?=
 =?us-ascii?Q?MY7hi7nrsQiLtvkXRUEtSEOpdQTrrcacA8qvK2QoSxYtpOcymT48l3EG34Cf?=
 =?us-ascii?Q?UQcDg66JMoYSp8PUO6+y/AVogqqCk/zLwaQeRk6YMvDPC5y4juImYnahbuxJ?=
 =?us-ascii?Q?7TrKagcb8gP6HT0EmPUpR43J7nEJ5rKQe4FsFmykJkwFuSNsYDCzczuDDnYX?=
 =?us-ascii?Q?I0nT6e6b0CCgk1rGMmuuWO3flWGa7ESgYwnbeEUBjYvn7gutaP9fHhh6tTIe?=
 =?us-ascii?Q?dRoa9dq6P+Tyd5rTTurnv22AOjjYetO90hX/UHgU26qCFrnwcSjEIieEQfsq?=
 =?us-ascii?Q?uy8llMZngYUDGmqBddbla3Kz8VqYHaGx8KaFA6k2Hs1V+U2MYFAD5SA+Zs/4?=
 =?us-ascii?Q?H5mNfl1+jks2R0l8V9ILYRVxxKytVsNoFFovgO1W3slAwS1h3rbMIGAAnPfB?=
 =?us-ascii?Q?I0IcPwMCm1RNWthrVO9n6+cHbsC0nY7vTV2FH7u2D6kFTX3xoatGeEn9FUC9?=
 =?us-ascii?Q?XcERg9Q3CHQ+W3xpZBexK/eALy/qKInpdEoZY+6VPNQ3r+G4LPLIjPwaTsqU?=
 =?us-ascii?Q?eLL8MUI1CXL7W57K09zvm8xh76j0NRQw0IVQ1jhJL6t/+qh3ePSbH26pFAJO?=
 =?us-ascii?Q?YtnceY8C36du3s3yyXBMmMtV0hgELTA2Ldn/Zvx8ybOl+JJMUvhywi7Lo49V?=
 =?us-ascii?Q?L/Am8mDyXGI/xwoPF7Mc5+bDd4xxV506yRqGu5wWjezFsCS1t9D+YLz+7/jL?=
 =?us-ascii?Q?laRmCJyBz0BtmcnzYH2ux0WZdAILB2TmJIRRXlfyJeekJNkOruXwwaJAmTeS?=
 =?us-ascii?Q?Ly3pzHK/aIqRc2/Bn/w2BVnBztwa347weWv/pQcIGlJ5xo7yg9LZMbXXspkU?=
 =?us-ascii?Q?R4XXOuHKssqft5KYS5kkw7+sh8p0m/MhVo64eYu3wujaHLlaeuCSVtKlb1X6?=
 =?us-ascii?Q?Ze0I4QYE+MVTuWxQimfH/WkyOz6/d33ZmRmhBnQ1KrTyvVpqWMjKlwUkM5++?=
 =?us-ascii?Q?gaygGA1jqMqWxSGfjnYZNfktG2HIAEcLPF2X8qBpaDbXhDYZuIgxNqX20uwE?=
 =?us-ascii?Q?LLhenqNQ08YiDOK51zOgFBe2muEYhC5+dyW1dqQTl8n3DWI6yVZLR9DbwS9R?=
 =?us-ascii?Q?j7994Vnf/M29GOlcxRtwyr/jnbScv0dIlF+7i29wOilNdv0Ww0/Ws1tJhEAw?=
 =?us-ascii?Q?jtvge+C0F/FZ6MaxczcJtC5Ehw4i1tHB267Ke8CpiV+PkCnQT04ECCKZ+47V?=
 =?us-ascii?Q?v7Th2ZtzfAjyHSk+ta6niozVG9vb9qU/7KLHf3rwDtqR7gRO5uZN+LNZmo+i?=
 =?us-ascii?Q?1/SEA93lcyt2C/fzQBO+0fJ1SKH4xRoOZxu7S7VgQO1J2kz41bek+MagKMaT?=
 =?us-ascii?Q?dVYRtWWHsgmURxngkoqX0+fry2CNDAIkHpoFGgVj0s5FpNFqkR4hIqISoqi7?=
 =?us-ascii?Q?23tK/mjZ6NPx+tCyiikX8/qbW2yCFWLStrW1SvLomqax9iF9O7Xs8ZxmFwLS?=
 =?us-ascii?Q?8/ZLkh217vYoKJitDi9ezFMRc1R6qhyWzSovW4ghOvBlyBuUW2qm/dhdAYNN?=
 =?us-ascii?Q?Iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC42A0E4DF33414DB6D81E19409FCCF2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88827cb3-c52d-41b2-1294-08da5a9af184
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 13:17:54.9618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrw2sRsOzefQaB7arj5ZCqq3G5HV7GL4CMiY0SDeWqmlNC7Ukv+lqpmQKLnt8O/tRvsziagN+AUjEWhOJ/VLNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2705
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 01:17:08AM -0700, Colin Foster wrote:
> Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
> VSC7512.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 161 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yam=
l
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Doc=
umentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> new file mode 100644
> index 000000000000..24fab9f5e319
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> @@ -0,0 +1,160 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/mfd/mscc,ocelot.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ocelot Externally-Controlled Ethernet Switch
> +
> +maintainers:
> +  - Colin Foster <colin.foster@in-advantage.com>
> +
> +description: |
> +  The Ocelot ethernet switch family contains chips that have an internal=
 CPU
> +  (VSC7513, VSC7514) and chips that don't (VSC7511, VSC7512). All switch=
es have
> +  the option to be controlled externally, which is the purpose of this d=
river.
> +
> +  The switch family is a multi-port networking switch that supports many
> +  interfaces. Additionally, the device can perform pin control, MDIO bus=
es, and
> +  external GPIO expanders.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mscc,vsc7512-spi
> +
> +  reg:
> +    maxItems: 1
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 1
> +
> +  spi-max-frequency:
> +    maxItems: 1
> +
> +patternProperties:
> +  "^pinctrl@[0-9a-f]+$":
> +    type: object
> +    $ref: /schemas/pinctrl/mscc,ocelot-pinctrl.yaml
> +
> +  "^gpio@[0-9a-f]+$":
> +    type: object
> +    $ref: /schemas/pinctrl/microchip,sparx5-sgpio.yaml
> +    properties:
> +      compatible:
> +        enum:
> +          - mscc,ocelot-sgpio
> +
> +  "^mdio@[0-9a-f]+$":
> +    type: object
> +    $ref: /schemas/net/mscc,miim.yaml
> +    properties:
> +      compatible:
> +        enum:
> +          - mscc,ocelot-miim
> +
> +required:
> +  - compatible
> +  - reg
> +  - '#address-cells'
> +  - '#size-cells'
> +  - spi-max-frequency
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    ocelot_clock: ocelot-clock {
> +          compatible =3D "fixed-clock";
> +          #clock-cells =3D <0>;
> +          clock-frequency =3D <125000000>;
> +      };
> +
> +    spi {
> +        #address-cells =3D <1>;
> +        #size-cells =3D <0>;
> +
> +        switch@0 {

I wonder if "switch" is the best name for the top-level node, since
there should also be another "switch" child node inside for the _actual_
DSA bindings, which this example is not showing (leading to further
confusion IMO).

Hmm, would "soc" be an exaggerated name? It's a SPI-controlled SoC after
all.

> +            compatible =3D "mscc,vsc7512";
> +            spi-max-frequency =3D <2500000>;
> +            reg =3D <0>;
> +            #address-cells =3D <1>;
> +            #size-cells =3D <1>;
> +
> +            mdio@7107009c {
> +                compatible =3D "mscc,ocelot-miim";
> +                #address-cells =3D <1>;
> +                #size-cells =3D <0>;
> +                reg =3D <0x7107009c 0x24>;
> +
> +                sw_phy0: ethernet-phy@0 {
> +                    reg =3D <0x0>;
> +                };
> +            };
> +
> +            mdio@710700c0 {
> +                compatible =3D "mscc,ocelot-miim";
> +                pinctrl-names =3D "default";
> +                pinctrl-0 =3D <&miim1_pins>;
> +                #address-cells =3D <1>;
> +                #size-cells =3D <0>;
> +                reg =3D <0x710700c0 0x24>;
> +
> +                sw_phy4: ethernet-phy@4 {
> +                    reg =3D <0x4>;
> +                };
> +            };
> +
> +            gpio: pinctrl@71070034 {
> +                compatible =3D "mscc,ocelot-pinctrl";
> +                gpio-controller;
> +                #gpio-cells =3D <2>;
> +                gpio-ranges =3D <&gpio 0 0 22>;
> +                reg =3D <0x71070034 0x6c>;
> +
> +                sgpio_pins: sgpio-pins {
> +                    pins =3D "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
> +                    function =3D "sg0";
> +                };
> +
> +                miim1_pins: miim1-pins {
> +                    pins =3D "GPIO_14", "GPIO_15";
> +                    function =3D "miim";
> +                };
> +            };
> +
> +            gpio@710700f8 {
> +                compatible =3D "mscc,ocelot-sgpio";
> +                #address-cells =3D <1>;
> +                #size-cells =3D <0>;
> +                bus-frequency =3D <12500000>;
> +                clocks =3D <&ocelot_clock>;
> +                microchip,sgpio-port-ranges =3D <0 15>;
> +                pinctrl-names =3D "default";
> +                pinctrl-0 =3D <&sgpio_pins>;
> +                reg =3D <0x710700f8 0x100>;
> +
> +                sgpio_in0: gpio@0 {
> +                    compatible =3D "microchip,sparx5-sgpio-bank";
> +                    reg =3D <0>;
> +                    gpio-controller;
> +                    #gpio-cells =3D <3>;
> +                    ngpios =3D <64>;
> +                };
> +
> +                sgpio_out1: gpio@1 {
> +                    compatible =3D "microchip,sparx5-sgpio-bank";
> +                    reg =3D <1>;
> +                    gpio-controller;
> +                    #gpio-cells =3D <3>;
> +                    ngpios =3D <64>;
> +                };
> +            };
> +        };
> +    };
> +
> +...
> +
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4d9ccec78f18..03eba7fd2141 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14416,6 +14416,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
>  OCELOT EXTERNAL SWITCH CONTROL
>  M:	Colin Foster <colin.foster@in-advantage.com>
>  S:	Supported
> +F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
>  F:	include/linux/mfd/ocelot.h
> =20
>  OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
> --=20
> 2.25.1
>=
