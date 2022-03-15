Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81D04DA301
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244640AbiCOTIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiCOTIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:08:50 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80080.outbound.protection.outlook.com [40.107.8.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB658F78;
        Tue, 15 Mar 2022 12:07:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0Y+kqN2Dy/3fklUsRqp6CB/I39BNwtz934Vq2ppZqoihbSqhFmNu+kSxdmRFCgU/ysrXTIlNuINPOnL+akF/cyrjACTlOiV747LajgRMGrHdrdSabm0iv1oBHb1r2ker/4olsxkXLeIpm8LzjOHIeiBEKC3YN5XHwPareLDXVaDOhkawLZWmHf6Nv4iqPtXXJBtawxdrT3DsIOcRo8Bts3IdxotJ3jUP5QOlVH1Llmr/PCJXhFanhXG6V3YK1O7Dvo2c9Lxn08M4q9DyoOWxYZg7M8QxF1LxlSBr97uF9qiknIi4cFlwr8l/Qq1iPEx3J9/OkRGLyJ4/PJlQsgJnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiHE5aW7Ts7gR5f1cEhVi7lbYWsRdTEdO5A8SLrhbBI=;
 b=maqNZFgcgRxXK4W3RRMW42hToLRPAyH45Oj1BX+JoKjbW4HQ5J5iditPojnjOEUHGHjxfk4Cy++VNFv7uAai4/HZ5Q7ewPKLxTnySMszCk/mN8oAoehFql3ebIc6rVBJxEwoe5n5YU4dDgIOpN2S4z7kfpDfWMXvzFrbsOggjInckaMYIkXToKyPLYpWMdgi/p0KpQh3hV/YG7ldp1Nf7uXvGMY8FS2S37eWEx1A7Fq5yLY9I4qzAtoRofWyUkVx2VP7g+5rC+Qq8vlDQ2MR1EDRzCiFmcgN+NEb/gqfuiSmEq9JZhEQpnu6ihz7jkq8OTsUcjQXQqKummroTVIixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiHE5aW7Ts7gR5f1cEhVi7lbYWsRdTEdO5A8SLrhbBI=;
 b=hsbpFoW1gI9w80Jb1pcV7hWrhvw224Deio2dbwIX4QNGBZ2x4OY2czYAoKK8NF6XWTriVj1bwgzoAQYaRh8NzXZ2bEks1ajdv7sPI9UTkKqDOxA1ihkE3fcvCIs4UJ2H/xQe6KgL2i34DPzJE7NXo5xGj2OWQlcAf4SLEhXt/T8=
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB3054.eurprd04.prod.outlook.com (2603:10a6:802:3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 19:07:34 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 19:07:34 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Thread-Topic: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Thread-Index: AQHYOGjtNze6uoFOtkeaYiQGh4M7eqzAwkyAgAAMu4A=
Date:   Tue, 15 Mar 2022 19:07:34 +0000
Message-ID: <20220315190733.lal7c2xkaez6fz2v@skbuf>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
In-Reply-To: <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6ee5f15-23de-4a50-984f-08da06b71018
x-ms-traffictypediagnostic: VI1PR04MB3054:EE_
x-microsoft-antispam-prvs: <VI1PR04MB305470DDC0B9F40374E0BC40E0109@VI1PR04MB3054.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3BH8v/vyIZJS3d1UuKZIydd0A7CwoR09gKN7hHdAH0xkqq+VDBt/nMU34smNWgHeaVAmANBOD0VkD9dyhMVqeDRG3s30UR2proJkiLbuA399DhV60Rd9mE2bUBHp/Ez/1VmjdQxZU5k2cwla023EVAUojmelwwJe1vX+AHqpR17qysXSrxLqZHvVFoWrsbt6ZC8yDj7q/EB+vIJxBcE71DdYBs4cDQ+yjzsHOYtyL46v59jUC2veMlKcZFt+R1iG5f1NQjUsF7MVNg29t/FrAOFKqlb6lX2kbL+jdZVGfjRLyVf+EoaXF4g6D/jJiOAWRB8SfnEve52M6o3Ix+NneulTiKasXlgGAkjOr3PkvOQ1Xcd3qaonC5OFrbh4a1cQIPhbHXV2Ias2VHNkEa+fi9TRPSTU3dadbMo7kmeFzNIUGfRsYd+QqG7SsJO/9YY/jFUoURMYCci4w4m+fJBkmSOE74MozMQpt+B810iGVpq3Lv5dJU9VCy1/QX71pFQZfPxhbsV2nUHhNtb4VojkrN8MxyGPbQ8wKZjl399+niGWlq+bnkJWALm3BoO+U9j+xK86SMVtPUpnM5QXe+JYZVa+GD+QVlhFBlOGIP2pFqtP9DSS5li2djvQQAF7UwRuk5A6UjUthz7hkrgGiGIbONTpmoavawSDtbOkCGqpfISBYy+6H99HkRIH2xKOvWGfJ3xIlW4Hj/i1gIYkDRyHFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(53546011)(508600001)(9686003)(6512007)(33716001)(76116006)(6486002)(64756008)(66476007)(66556008)(66946007)(38100700002)(6916009)(316002)(83380400001)(54906003)(66446008)(4326008)(186003)(71200400001)(26005)(6506007)(122000001)(38070700005)(2906002)(44832011)(8936002)(86362001)(5660300002)(8676002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vqlbG4EGmIeaFNIJDVv22OhF1aEI4xTRlvMp9SNOopqI6IdaHPZfS39405U2?=
 =?us-ascii?Q?wNeZ5NIqPG1/SoGX+82XOkS+BMtmFulMOEMmgBU8r7/XcKj4vVp9YqHg3MbF?=
 =?us-ascii?Q?AOs6MR6jA5gA/JyH4dbyee1Tw/Oh1pNXbqbU6ntDOluVc3loP+o74FXtSsv7?=
 =?us-ascii?Q?aeePrGzZrFyhuwWCEHFtLtVOVRxShTVspqbZJmbnhMenq+ml1mC+evfRqXBJ?=
 =?us-ascii?Q?H1JGFw2aPlFkHZL6ybmW240XYRedvCJvfn8gsC0O7tCsJJtagGZGgCkEeoaT?=
 =?us-ascii?Q?AV345MBGbfuTKiOW6kFeCh75vVO8q6jbRweww5svWKbGLFb/e3MhDmXFKabY?=
 =?us-ascii?Q?zrUDXuno8Pr7rad2h+9hgQaDDn8eJ7a+igxtoJiphR9NTmj3lgq0tbxG+ylY?=
 =?us-ascii?Q?iJPVo2d8OjUDcTOJ1a5gR/h8CY8KXaAJdYfoRCqD2XiyzqMcLZSsQu9rv1Hi?=
 =?us-ascii?Q?PFRZN9qYg/uSp2In8+9nIc9UAgUQOZOFGXf9mpqltPPbohNEAwIu9+2Lt7dk?=
 =?us-ascii?Q?XYdC3aVBzbkQv63iSgLHd+EREugTS398dgxMPd1H9Ecpsbc5Z0+9kNh+YsfX?=
 =?us-ascii?Q?cQr42lvJmwz/LF/CyJVTIrkv4HfNq3n+3K/UZWJPfLZ9LakOW8Rj78O0i5AA?=
 =?us-ascii?Q?fLXO0zj/jc4gK5LLfeGgtkwWunhLmXOe0AizuFnaJSKcc9Px7m82to1p1yXa?=
 =?us-ascii?Q?5LeJS9o7alPzev236ci5JcUgodjAgfu+C/jy2ktZ2p1JJn3xwCit7VZByDec?=
 =?us-ascii?Q?lkvT99pNHOveozJr10PxBFJZeJcfYtjY8SZ2txsjGbQr7/i4spM/sPEV1gRv?=
 =?us-ascii?Q?yba/AXIeWsVWEg+mOtKdbkmN2OJkmchCjXJAjXsb9pSrNDSuE3VcYbe72W7j?=
 =?us-ascii?Q?UzXCu4pra5KXdbkIpS9Yv8rh46NtCppkj+OsguwbDqYAyg3l4fyWgvIAbRuz?=
 =?us-ascii?Q?P7+WHQ5IKnKsxCFWd1TYAZ9i3RSWBOOZ/yowYIieB6RvwBOpdi2jWoFdhAoR?=
 =?us-ascii?Q?O2sqf3QOgkYh6/88p3AxpiYhkmmI5ttqmP1ezDSscaP8CxAY6TjrOZ46FKvb?=
 =?us-ascii?Q?DesVSFjSJKJhhRLtShLJHzUP+lFwWiKkRVUwkaYizYU/bNcQDgzHl5G1S7zI?=
 =?us-ascii?Q?frrd95nIPWik0R5WKWzifBS5GtbX07HczCGHn7TCohaJSlDL/Xmvizs6uPdw?=
 =?us-ascii?Q?iKDx71VrBIVXisHDMyUsno0dFJL7gGs3f4XZpXI0soh6y/nzhhZdITQ6Qvlq?=
 =?us-ascii?Q?smyi5imNOcWTK+lKnDf7uCjS/7U4guraDkJHHGCQ73kjB9G4EhVaQHNTGWAw?=
 =?us-ascii?Q?z43SR+ZXcDezsSGGqimDFBAJCpXXEfecgiJnh7oALESCsA9/G2zEWvW7Jc/Y?=
 =?us-ascii?Q?F3sMRjZAig/YCY1YEBFBjhG/krLgTb/G0si2X2UK6A2BMCEhcYJoUENuHBGw?=
 =?us-ascii?Q?WCWkoH2n3NhhQOZYL79pX6P3bWbCjgZ5laLw7yRkcygwAqE3ayOhdQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <71234D8A60D9AC4CBBB65E6C7BF11602@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ee5f15-23de-4a50-984f-08da06b71018
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 19:07:34.4395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fLNSvoOhdA/IQJ+aNti5re4ulxvhUWAz9xqXsuDJ+vMbbb69oPDaBbPdkyclUtzifyrTpGTex+aH0et2Gd19vw==
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

On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
> On 15/03/2022 13:33, Ioana Ciornei wrote:
> > Convert the sff,sfp.txt bindings to the DT schema format.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---

(..)

> > +maintainers:
> > +  - Russell King <linux@armlinux.org.uk>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - sff,sfp  # for SFP modules
> > +      - sff,sff  # for soldered down SFF modules
> > +
> > +  i2c-bus:
>=20
> Thanks for the conversion.
>=20
> You need here a type because this does not look like standard property.

Ok.

>=20
> > +    description:
> > +      phandle of an I2C bus controller for the SFP two wire serial
> > +
> > +  maximum-power-milliwatt:
> > +    maxItems: 1
> > +    description:
> > +      Maximum module power consumption Specifies the maximum power con=
sumption
> > +      allowable by a module in the slot, in milli-Watts. Presently, mo=
dules can
> > +      be up to 1W, 1.5W or 2W.
> > +
> > +patternProperties:
> > +  "mod-def0-gpio(s)?":
>=20
> This should be just "mod-def0-gpios", no need for pattern. The same in
> all other places.
>=20

The GPIO subsystem accepts both suffixes: "gpio" and "gpios", see
gpio_suffixes[]. If I just use "mod-def0-gpios" multiple DT files will
fail the check because they are using the "gpio" suffix.

Why isn't this pattern acceptable?

> > +
> > +  "rate-select1-gpio(s)?":
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the Tx Signaling Rate Select (AK=
A RS1)
> > +      output gpio signal (SFP+ only), low - low Tx rate, high - high T=
x rate. Must
> > +      not be present for SFF modules
>=20
> This and other cases should have a "allOf: if: ...." with a
> "rate-select1-gpios: false", to disallow this property on SFF modules.
>=20

Ok, didn't know that's possible.

> > +
> > +required:
> > +  - compatible
> > +  - i2c-bus
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - | # Direct serdes to SFP connection
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    sfp_eth3: sfp-eth3 {
>=20
> Generic node name please, so maybe "transceiver"? or just "sfp"?
>=20

Ok, I can do just "sfp".

> > +      compatible =3D "sff,sfp";
> > +      i2c-bus =3D <&sfp_1g_i2c>;
> > +      los-gpios =3D <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> > +      mod-def0-gpios =3D <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> > +      maximum-power-milliwatt =3D <1000>;
> > +      pinctrl-names =3D "default";
> > +      pinctrl-0 =3D <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> > +      tx-disable-gpios =3D <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> > +      tx-fault-gpios =3D <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> > +    };
> > +
> > +    cps_emac3 {
>=20
> This is not related, so please remove.

It's related since it shows a generic usage pattern of the sfp node.
I wouldn't just remove it since it's just adds context to the example
not doing any harm.

>=20
> > +      phy-names =3D "comphy";
> > +      phys =3D <&cps_comphy5 0>;
> > +      sfp =3D <&sfp_eth3>;
> > +    };
> > +
> > +  - | # Serdes to PHY to SFP connection
> > +    #include <dt-bindings/gpio/gpio.h>
>=20
> Are you sure it works fine? Double define?

You mean that I added a second example? I don't understand the question.

And yes, I checked that the dtschema is ok and also that the DT files
are matching it correctly.
.
>=20
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    sfp_eth0: sfp-eth0 {
>=20
> Same node name - generic.

Ok.

>=20
> > +      compatible =3D "sff,sfp";
> > +      i2c-bus =3D <&sfpp0_i2c>;
> > +      los-gpios =3D <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> > +      mod-def0-gpios =3D <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> > +      pinctrl-names =3D "default";
> > +      pinctrl-0 =3D <&cps_sfpp0_pins>;
> > +      tx-disable-gpios =3D <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> > +      tx-fault-gpios  =3D <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> > +    };
> > +
> > +    mdio {
>=20
> Not related.

See above answer. Russell adding these examples in the original txt file
I suppose just wanted to show how things work together.
Why remove it?

>=20
> > +      #address-cells =3D <1>;
> > +      #size-cells =3D <0>;
> > +
> > +      p0_phy: ethernet-phy@0 {
> > +        compatible =3D "ethernet-phy-ieee802.3-c45";
> > +        pinctrl-names =3D "default";
> > +        pinctrl-0 =3D <&cpm_phy0_pins &cps_phy0_pins>;
> > +        reg =3D <0>;
> > +        interrupt =3D <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> > +        sfp =3D <&sfp_eth0>;
> > +      };
> > +    };
> > +
> > +    cpm_eth0 {
>=20
> Also not related.
>=20
> > +      phy =3D <&p0_phy>;
> > +      phy-mode =3D "10gbase-kr";
> > +    };
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1397a6b039fb..6da4872b4efb 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -17498,6 +17498,7 @@ SFF/SFP/SFP+ MODULE SUPPORT
> >  M:	Russell King <linux@armlinux.org.uk>
> >  L:	netdev@vger.kernel.org
> >  S:	Maintained
> > +F:	Documentation/devicetree/bindings/net/sff,sfp.yaml
>=20
> Mention this in the commit msg, please.

Ok, sure.

Ioana=
