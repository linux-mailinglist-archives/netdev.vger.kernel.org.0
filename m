Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC10564965
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 20:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiGCSy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 14:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiGCSy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 14:54:26 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2137.outbound.protection.outlook.com [40.107.113.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8812E558D;
        Sun,  3 Jul 2022 11:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhNL5aaKT9LL0qiI//chcR+17OmgXr5gBOVXFUqJbU9sMq2RlwRnIerZrfqEr6T6OuaLWf+CC7GELGbX0cON8sfadJ0UhIhliBMvVzRNPhzrJsbqB3UAGaPhNknLbJSD9BVlm4Omfsak/fZG/cm+V49TVSnH9FXFns59MrKj5qqOBrfq3IyPCwnrMohGkz7yLpsEDIFOBV7ppF5Zv/UFJMWtIT5ieJKhGjA37b3vCZQp0W4s6LFYiCDKZlkx5NeDcn4AqxLpqxrRt5nFBxonkALQGcTSLIqKCIvPpVAaRT1p5Wv2ETsfZSFzM3NzvAXAlJpXbRDdihbRfkFZGV1EUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qaI85lEs+mUfEiLY+PxBoIJ8EoNMpqzgjgiphGzwN4=;
 b=Ljlz/QtAevbnmvMqfdu4L6lxcPQSZVDhp+KYUF5GijLCkrZXN6WxbqwTrxvB/AJQGpyurJu101din/YjTO/zv8Oyx62E9sZXGjR8Y+aTRl2HVuQb3lrswbZzAtOhU8EVc2JlJHKVBnW+iW0g1W4kDMw3RKQypw+VO04f7waomyEKFDtve1FmzWN6H4P49iXJUf5MHmndVy13mUy1n3w7wf0R+oV0BdTGshXYwJwL7Ju+3iIQsXlGpa9cfzMiz6poN78YIB8SdCMNd5kCngEaF7Kkie/HWIjqvthfNVCxX3R/y4PTdxoAN6BG7ON0ywrRDMjnGH1AB3GmH2yRjVyZXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qaI85lEs+mUfEiLY+PxBoIJ8EoNMpqzgjgiphGzwN4=;
 b=bsyEH8hwj5qxKh05BN77E1ibu/Q5uFpFinTVSA3/zxJ1WyYOCJqLl/nbgGS+GLtDcOm9CUnWjruR4Y8YW/I8tAghc+VQXaTsSiswozO/oFsdPv0RJ6HYq8Llyc3H8V+GuQHW+V1TXt9ukwJgIRxH9wGAJfpQOSX8RShxvU/m494=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYAPR01MB2799.jpnprd01.prod.outlook.com (2603:1096:404:84::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sun, 3 Jul
 2022 18:54:21 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.020; Sun, 3 Jul 2022
 18:54:19 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Paolo Abeni <pabeni@redhat.com>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: [PATCH v2 1/6] dt-bindings: can: sja1000: Convert to json-schema
Thread-Topic: [PATCH v2 1/6] dt-bindings: can: sja1000: Convert to json-schema
Thread-Index: AQHYjspH1cfXzfkP4EGwyQCTDaGvJa1s7/OAgAAIx3A=
Date:   Sun, 3 Jul 2022 18:54:19 +0000
Message-ID: <OS0PR01MB5922F27CE118110DAA7686D386BF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220703104705.341070-1-biju.das.jz@bp.renesas.com>
 <20220703104705.341070-2-biju.das.jz@bp.renesas.com>
 <1656871223.903187.1705437.nullmailer@robh.at.kernel.org>
In-Reply-To: <1656871223.903187.1705437.nullmailer@robh.at.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3556749e-4af9-4aba-f10e-08da5d256fce
x-ms-traffictypediagnostic: TYAPR01MB2799:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HFdJ6+XJaogppRZfhOek/AwWuNQ8XjGU3toZTEgMqr5mWZWaRJsn9R56H9NQv5nWrWzjW4LztGMtY1TOup3DiYU3hqKhwh3/0sjvZhfVTMZm/DrYzSqw6J/JWVjpgX1aOEbKR94pUEJgzXy7fw9Cal5GA8ABBExJL7Vd6jrR10vRloQ4S9b5YvjA8zz1NDXHYMs3seoJ10cHV797B+zqJUcatuJW8oKl8MVzoZJoqkMbxNc8Vw6sJEgvx4oeMvyUXbds+QNfdnTxGs0b9PF3Ri5n9JuJkFBeTY99QDVb41tFcqe/QnCWp7ss3jXBUzthSAq6e2O6E1LuDxKUdoWirfCNE/vO7exejM7ddU3g6JvuJVF6yoY+VtcUrFtRH+Xd9h6adru1bUmX5raLfxCRxTlGaYwRiGyvQ2mEsANM+tRDmhpTt01P7muynKfxGaQXPWXtmD0JT9/vHroC2p0J0TNKhAZiiMblpGLS2XweNbRTd9enqnLdmkrNTcyWQ8Qfj11ij+2Nu11u+Ntlqdo80r+f5C+taG4aWxDJNFuh7uMdy81d5nwxIlGFQu6/R05LhtqxXx+lFRoeXrgIHnCYc6DYiVG0gE/5SgD4W/rXBYp9cmD9BU4vwL8CTUPO2Vmt6DJtkLzv6aECtZtTNpHQSW9DUJmbrbOCRTIgVBhAh4X1HEQs/U7VAV1o53XES3iMnETWA5uE+eig7xPYfmwaqH6H2ewPOJdd/b9wN8Co/52KxPEHf5g+bKKO2Gnl0Z2BDTAqAsNCb2FwrId/czyRAPtuV3ytj898v+gQMRlFZExIHHj1J6dGybCidaaw5NlE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(52536014)(66476007)(5660300002)(6916009)(8936002)(54906003)(4326008)(8676002)(86362001)(76116006)(66446008)(66556008)(64756008)(66946007)(316002)(7696005)(41300700001)(6506007)(26005)(9686003)(38100700002)(71200400001)(38070700005)(122000001)(478600001)(83380400001)(2906002)(33656002)(7416002)(55016003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WA+CQCfBGySUJ9MjOUQ9tnTRR0jsJZv5kmahu0zZd1Y6Oma0mcgoKX78jr?=
 =?iso-8859-1?Q?CnCmWJ0HpTLSSkeDwJAxC3kLCocrPW6TS0oZTx80LG10lMEUhQOl1/rRs5?=
 =?iso-8859-1?Q?10ujzstmdtMD1z/UwHfxzwuQkCWRhG8AaEt/eT9ta7I3bgEDGlFynl7Jdb?=
 =?iso-8859-1?Q?WgXF/q6UFO0SiIMvWObe8GS2R3CziuHSMmWqU4ZoZSVuDygGEWe1WE8sHx?=
 =?iso-8859-1?Q?aPnW/WKsgVBK46sEbab5boI8hnYWiagcpjkc1uh3uE3bIS2OFMoaRW50vI?=
 =?iso-8859-1?Q?P5jUkqBqDL3J9DPf8w6i4oWR/RP1AaFmHbpyyMLI7mljd8iRGyPyOgAr2z?=
 =?iso-8859-1?Q?fBzLTNu4dz3D+MHcAbeG1JxgLBK3LceJ8aAyVO+kd3wzQF/YSvIIzWxtO2?=
 =?iso-8859-1?Q?rlLqEv+nR/8wgdTX9l2oTwqDr+2AxsoqIgVylCpXdbnBBwtpEsx5cm4qlA?=
 =?iso-8859-1?Q?VYV5yroMNnCaG7W52eRbqhttlGe1tWHeYkCEi953UwZZdD+kuCNj2ao13s?=
 =?iso-8859-1?Q?pXh0Orc6J2f8XQ8XYov6tEPwAsot/WiwtKLzNACfSGvnndl7FAQbem9Gd9?=
 =?iso-8859-1?Q?bBJWI8BlNaVvQTghjvmZ7vT5p2KBGSEzWUM+wUp22SC0vwTg7Xjc7Rcp6G?=
 =?iso-8859-1?Q?74ZieYxRBT/7awEH5ytLN/hGcVTsl8FGc2Ck3LdaKsjuxRcAAXLXW0u73t?=
 =?iso-8859-1?Q?VhSUuSyomqDL4Ky59hRuOzBjDIaHUFjLYryQ2hPnIn//XPMXOUWYjJoaD/?=
 =?iso-8859-1?Q?fBVHwwelevMYzovbYEc8kKIGItOEvM8rYBISBWvji+vZrS1s6T0ZLqy6QW?=
 =?iso-8859-1?Q?KErk+0B9jQn5gOruwFIUKbaw6jbXewHHlnaTTjvlhpBGBcmTIi5CCQAh1d?=
 =?iso-8859-1?Q?a/wKVWyEAoO06/B+riB+eyKOko91icEvL2m9zd5UFldTKwIwN4R4oZV8z4?=
 =?iso-8859-1?Q?PGCnCwI3JOeS/5YMqmqV+4wchuX2yJha4o9O2jgpbWmBFkKcK3HBMKafAW?=
 =?iso-8859-1?Q?93QeLoFUnz8fONE0NveMQE3oXzVZH5INA9/7j5Yy01JemWPNnvYXVVhtee?=
 =?iso-8859-1?Q?vlMv3uNJDDMhzbIXGkJQ7lWqcM8ByWEvWCmeTpRgqTivAPMAgARuPxMppN?=
 =?iso-8859-1?Q?p/HnpSEHUUietgc0hlhE9iCBFVFWkEQG9Nvbs1QHX4lyw7I+ZokauJourQ?=
 =?iso-8859-1?Q?RH704eO0fVpAOgUMV4xK9XX2u0uEn4jBoeMa72dLRC95hlTLZUj+5rgxJT?=
 =?iso-8859-1?Q?lKI9hFHyBLQk3WdGfymIuIflqD5YF/20ROHzN0V4R8DLa6bdAUwm5Fh4lm?=
 =?iso-8859-1?Q?KFx5udYWSnWPcNdAMK9rQSmJptrT6h5TbzHYWtrRascezbTdfN0QH397JY?=
 =?iso-8859-1?Q?TOSs5nOtXQvbr4pAqpVSihiwCkvq1dXfOVmQbl0feTizrFTEiitVq6r433?=
 =?iso-8859-1?Q?ZuYp34DXOrf/foY0Fxw++eeMaOb0FGSJITW/fIiFpaGV34IByzy3P7iXrW?=
 =?iso-8859-1?Q?w+y1vGNTit+Hx0oFDNCfMfTFmAuOVE6GHfnx0Wq7SWiPhn9YHeNTLtlSrC?=
 =?iso-8859-1?Q?851XruA3fLAJhjXxwN0GkZfgMnowU5SjtXGDUCoWu2A0OZdY4SuN0Ci2ll?=
 =?iso-8859-1?Q?sf9wX1UG7WKSidujh2wMc0TJSIMp3kSiILsubOPy8pU4BLzfEmMk1+NA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3556749e-4af9-4aba-f10e-08da5d256fce
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2022 18:54:19.7185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c4zOZI3aTAmfcMgZXC08m/ixa8LDh3bf1A+iR6VyQdEMKGKJqn+LT4DzRvnEb88J/fe96VwLrV9JOC93EsCdwGwMfAXjWdVCnrpx25pENDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2799
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thanks for the feedback.

> Subject: Re: [PATCH v2 1/6] dt-bindings: can: sja1000: Convert to json-
> schema
>=20
> On Sun, 03 Jul 2022 11:47:00 +0100, Biju Das wrote:
> > Convert the NXP SJA1000 CAN Controller Device Tree binding
> > documentation to json-schema.
> >
> > Update the example to match reality.
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> > v1->v2:
> >  * Moved $ref: can-controller.yaml# to top along with if conditional
> > to =C2=A0 =C2=A0avoid multiple mapping issues with the if conditional i=
n the
> subsequent
> >    patch.
> > ---
> >  .../bindings/net/can/nxp,sja1000.yaml         | 102
> ++++++++++++++++++
> >  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
> >  2 files changed, 102 insertions(+), 58 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> >  delete mode 100644
> > Documentation/devicetree/bindings/net/can/sja1000.txt
> >
>=20
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
>=20
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
>

OK.
=20
>=20
> can@4,0: nxp,tx-output-config:0:0: 22 is not one of [1, 2, 4, 6, 8, 16,
> 32, 48]
> 	arch/arm/boot/dts/imx27-phytec-phycore-rdk.dtb

Looks like this property is not enum, as combination possible with tx-outpu=
t-config values for TX0 and TX1.=20

22 =3D 6 + 16 -> TX0 push-pull + TX1 pull-down

I will remove enums definition from the next version.
which will fix this error.=20

Also please let me know, is there any better way to handle
combination of enum values like above.

>=20
> can@4,0: 'reg-io-width' is a required property
> 	arch/arm/boot/dts/imx27-phytec-phycore-rdk.dtb

I have added this as per original documentation[1], it is ignored only for
Technologic. But after checking [2] none of them except Technologic is usin=
g reg-io
I will send V3 with fixing this.

[1] snippet from original bindings.
Optional properties:
reg-io-width : Specify the size (in bytes) of the IO accesses that
	should be performed on the device.  Valid value is 1, 2 or 4.
	This property is ignored for technologic version.
	Default to 1 (8 bits).

[2]
biju@biju-VirtualBox:~/linux-next$ fgrep -r "sja1000" arch
arch/powerpc/boot/dts/digsy_mtc.dts:			compatible =3D "nxp,sja1000";
arch/powerpc/boot/dts/digsy_mtc.dts:			compatible =3D "nxp,sja1000";
arch/powerpc/boot/dts/socrates.dts:			compatible =3D "philips,sja1000";
Binary file arch/arm/boot/dts/imx51-ts4800.dtb matches
arch/arm/boot/dts/imx51-ts4800.dts:			compatible =3D "technologic,sja1000";
arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts:		compatible =3D "nxp,sja100=
0";

Cheers,
Biju
