Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28E8415CF2
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbhIWLm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:42:57 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:34875
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238930AbhIWLm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:42:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7J97+lT+P3uxifm9Bc1/CyY/Nu9dFeX1mOu1Dmkd8HviEie7e6pdtuQQMaPqxr4+xCrGGuCYx1XW+OJPJIhuc7r4tfFFdt6gtPAh+O0DzWfqESsTI7+YZz8RmO8NB0oOCUb8ktgq3NO/mBIlmS4SxaJiEUly9L9wePMvw0+DTWB1DNsrC6U79L89S8dFRe55RA0bc2hRPzPbtk0GYT1I3jqj+9JDml3ArtyGGDY0RYWUN1WMZpwSKxlVkMRA/vkz+R4hp0VRarh5mLjZdtD8dd8vUx2p63gSXqkGPgrIsefT7HlvlaGqfyHj/gm/J5MxscwqkOQrWV/Q4nSse8+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rNCyDv5KYccNyZEqEzOpMp6s67scu/5lXHRlBT8uqTE=;
 b=jwlL2C1tVOFFBBaj9tRgOm7XU1L1dXSHfn6Fy4Fs6KqMtzzkvRWo8I6AoH+gROhlnA+QpR1X1v/+uMCL3SRMTStPpauzIeTu+bGlLarM2fgerSbHssg8BcHdLYmInutM4eoIJces8uxOOsP3odnui2wq2dwF2vCcydfzQaNJ7MyB2J04ph/yYebgpERkA+w/mAVia5syJEC6W3cjTJTV53nsQlWiiviYwBFYaHpSuHWb/IL4n9CjM93CvVVxkAp/7bZGVyE0QcPtg9Pn8wsQRHigiyefucz+c6P687TzEcyQCGRJoOXEZdunozHfctnOBw666VKN0maI8HlbHhiaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNCyDv5KYccNyZEqEzOpMp6s67scu/5lXHRlBT8uqTE=;
 b=oYTOH8HTOnm09oUoyKBPvc5PKlgtSuOOX4w2OJtELU0L8hd63ZuqoTGiBrthzEn2CgxNcPl+Z/ix6QMA7iPV5U3JT1dm8BBSj0CDBebzCQymlTGH0LRKhGnJ/4Vv4/cLoDG44YX/cR2cahfnDiUSkQA+8P/tH3OKCyoZxHKnoHk=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5925.jpnprd01.prod.outlook.com (2603:1096:604:c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 11:41:19 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 11:41:19 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>
CC:     Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 3/9] ARM: dts: renesas: Add compatible properties to
 KSZ9031 Ethernet PHYs
Thread-Topic: [PATCH 3/9] ARM: dts: renesas: Add compatible properties to
 KSZ9031 Ethernet PHYs
Thread-Index: AQHXpVerji8qwB+8xEGNtBUGWxV93auxlMhg
Date:   Thu, 23 Sep 2021 11:41:19 +0000
Message-ID: <OS0PR01MB5922C47CEF890322ACB36C3B86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <cover.1631174218.git.geert+renesas@glider.be>
 <ce8ae6b199fa244315a008ae31891a808ca1948d.1631174218.git.geert+renesas@glider.be>
In-Reply-To: <ce8ae6b199fa244315a008ae31891a808ca1948d.1631174218.git.geert+renesas@glider.be>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: glider.be; dkim=none (message not signed)
 header.d=none;glider.be; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a917114-575f-4b48-aef6-08d97e870fc0
x-ms-traffictypediagnostic: OS3PR01MB5925:
x-microsoft-antispam-prvs: <OS3PR01MB592522F87D3F784413DC29E086A39@OS3PR01MB5925.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8gRL7F/BRzciq03qZkITgXebn2DJEWEivlC7jaDJhj5m91HZSISOugMtwsPdrzNem103Fup8yx9J9QgyYz7TJm6A2xBnVM9BRGNTTS410qxNGsRwh6nqHtmplnsEPlC67io7A3EZ6VNAvWoPdZdWP96MBE55SNJHtjmaD5dT4+jyGp4XHZXThTqjPhP6k30xfHJVJR2UyCIbR+BnA+1LqRglMUlzLnvbr4mitUVBgnkEM3X5mU2vNusOzwyntLKvzyD/WcczUg200O9dKyhwXkkkENkKMQCFusWPdPy9sEfxm4mbrKPChrzhSTltxD8pQCJ+zQXfV1IGSZrhI4T9uEZu4iWChDV2h1agvTEoHWIPeJZooXDL5UMwI6GmC1wvls6ywdKWQuQXt1H030QZiEqA428zhgYrewFTTxYO7+DHZHI/ZaRL6bH9FQHD3BZFdxcaQt+SiVtrpQ6PENo52yOUrfZDctdTnF6FBRggJzR0qIT4r6r9W3QnSWRnxYG2o/4tdEbgZ2lfcuIhIAhVsDwcxrZAaX4RmuCLyIt6qAVFzB4pNVAngrRuP+Mel4Rx1LzB02WgH6uxToGzBeuZVGfnVQQ8WL4wJ4j+LsmxT6J5YOre6X3SH+TkSadzCKh8NaBDxRqxWlEavY//PKs0tiIHGNBABqOsNbrdPmIZW7Jk+GJ83hshHd5cTWSvR66NDpOlrLqDYvE6MGWwfz5YXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(55016002)(186003)(8676002)(52536014)(9686003)(71200400001)(5660300002)(54906003)(86362001)(53546011)(8936002)(38100700002)(33656002)(38070700005)(66446008)(122000001)(26005)(6506007)(83380400001)(76116006)(7696005)(4326008)(316002)(7416002)(2906002)(66946007)(64756008)(508600001)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5xjPXTtv4HSG61UEgBaHDnJu4y/rYB2616Vtn5GG1A1V+2Sq9gBCTpJuD9tf?=
 =?us-ascii?Q?KwKu8UQk/z9g3ncYByvjSS3pcVxEmHXeMb13wc9U4w7FrwxLGd3ArsZtMS0o?=
 =?us-ascii?Q?+Md2qW3jrt9JpxFF2GWd1nlwSImp4Knih0N94nz4vQjdZxoIGnyBdmkKKm+6?=
 =?us-ascii?Q?Vy6zIT2o8Jc5u3Gaz534MzRpF5btDkOEL6aig7J7Dj9BLz63Z1xWmopFDrL2?=
 =?us-ascii?Q?EvCEOCcaJkBYXGSeNEHu3P0MWn7T22ilHLjcewAJMzr3jx5fYaSere9tSsO3?=
 =?us-ascii?Q?0FH+YUtw4XfMGSy8CjWcGlXALz0V6MqNOpezeEtUxNjWyRVHizn222bmkUxb?=
 =?us-ascii?Q?zKTfWDyUlUZ1CNt8kQF99BnkbbS/7MolJg/gYh2fizQkh7qW9gI6gas06z4Z?=
 =?us-ascii?Q?eewlCGMXlIzugrfNGE/h6geq/2DYXc7tP+HtlPzPcEQf6cCVAjoY+wEOHIDY?=
 =?us-ascii?Q?QGKwRv9vG28273yS63U/W3NBfCA2/1Wey8YmpDuJ6r6oRVmiLuGlgTKaOA2h?=
 =?us-ascii?Q?yRPKyoodpv3R2U9DPa7DU/Ie6WLum23DIFs34xNRJu5Vh1o5COLUpjPJogq3?=
 =?us-ascii?Q?Unku+MqDr76D4SKebEy2IiojFjP5Hl6Nrq57RvvELkAVcuNS2ONBHMdFJl40?=
 =?us-ascii?Q?b5M9UVF7IXCNfTCyWiu/4zGbBbxnZBNUoy94FDiuxzlktpFL5GK3ZCrzAkPH?=
 =?us-ascii?Q?4+K1+4C1Me2aQrSFbJ9KanQIdXHkVYjfAs2QPpB2qmj4qKgrHLkGgVBXvVxC?=
 =?us-ascii?Q?7jg+quxwJ+9MIWMQ1v5sIpqJ4FPFefjEtYJ3bDxzBWEJqwuFiii1/YFcs2ll?=
 =?us-ascii?Q?pKjzsTHr2HnFlqdOWBYVhrf+RTjiDxGpDINDNDSbio3ZzZjGdfOa8WJOgfS2?=
 =?us-ascii?Q?cP4uBMQ5DQa5M+A1GHbNUFllER9/Maazff+EKp59WPWWUBID1L+bGvQBg/Gs?=
 =?us-ascii?Q?Fb8grPxXhWqFydkOzUE+rIRsJoQPf5mdA/Mq+uUX4da/iRtkyGnq/WXBRF1n?=
 =?us-ascii?Q?Kg5lwxRc33g607oI2QfGMT62d71lYkR6p+8fDZyL5IleRbWqJKVjBf2aJGYq?=
 =?us-ascii?Q?FmR50FMd3V6eN+qTpDdcJ4EblKRSh2Ei3w6XXZkghUSxvrAYlxddYMqWclt/?=
 =?us-ascii?Q?WjtT8ShtDj8zm33G0v+6Ez4ViwNb+p4lh9gP1u2ccwSzZLfK1htPl8E22Fcv?=
 =?us-ascii?Q?/jTkMhhiaNN+IUusdfr/7aFbcIzKQ/KWH3xbY3dI+SfuAPYyKHHWKwUl9jny?=
 =?us-ascii?Q?z7Y94qwovQrytvMVA0ofpu3Tdu+85JkQ/GfzXnfUrpQmU/SNmMs6CaHGQILV?=
 =?us-ascii?Q?KoByRKbsTChzpW/RYOKwEaq5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a917114-575f-4b48-aef6-08d97e870fc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 11:41:19.8282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b+4+WGgj8pY8pn3paAdhULhZoowfFoBWqzZLBzUT95mIQ2/xA3co+JDlTWx2N1JyROqh026N5nXb5+PfMjXUNrdDbrZ5v1hfK+cXSzQ+O/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5925
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for the patch. Tested the patch on iWave RZ/G1N board.

Tested-by: Biju Das <biju.das.jz@bp.renesas.com>

Regards,
Biju

> -----Original Message-----
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Sent: 09 September 2021 09:50
> To: Magnus Damm <magnus.damm@gmail.com>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>; Adam Ford <aford173@gmail.com>=
;
> Florian Fainelli <f.fainelli@gmail.com>; Andrew Lunn <andrew@lunn.ch>;
> Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; Grygorii Strashko <grygorii.strashko@ti.com>;
> linux-renesas-soc@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; Geert Uytterhoeven
> <geert+renesas@glider.be>
> Subject: [PATCH 3/9] ARM: dts: renesas: Add compatible properties to
> KSZ9031 Ethernet PHYs
>=20
> Add compatible values to Ethernet PHY subnodes representing Micrel
> KSZ9031 PHYs on RZ/G1 boards. This allows software to identify the PHY
> model at any time, regardless of the state of the PHY reset line.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I could not verify the PHY revision number (least significant nibble of
> the ID), due to lack of hardware.
> ---
>  arch/arm/boot/dts/iwg20d-q7-common.dtsi     | 2 ++
>  arch/arm/boot/dts/r8a7742-iwg21d-q7.dts     | 2 ++
>  arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts | 2 ++
>  arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts   | 2 ++
>  4 files changed, 8 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/iwg20d-q7-common.dtsi
> b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
> index bc857676d19104a1..849034a49a3f98e2 100644
> --- a/arch/arm/boot/dts/iwg20d-q7-common.dtsi
> +++ b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
> @@ -158,6 +158,8 @@ &avb {
>  	status =3D "okay";
>=20
>  	phy3: ethernet-phy@3 {
> +		compatible =3D "ethernet-phy-id0022.1622",
> +			     "ethernet-phy-ieee802.3-c22";
>  		reg =3D <3>;
>  		micrel,led-mode =3D <1>;
>  	};
> diff --git a/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
> b/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
> index 94bf8a116b5242a9..a5a79cdbcd0ee09b 100644
> --- a/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
> +++ b/arch/arm/boot/dts/r8a7742-iwg21d-q7.dts
> @@ -175,6 +175,8 @@ &avb {
>  	status =3D "okay";
>=20
>  	phy3: ethernet-phy@3 {
> +		compatible =3D "ethernet-phy-id0022.1622",
> +			     "ethernet-phy-ieee802.3-c22";
>  		reg =3D <3>;
>  		micrel,led-mode =3D <1>;
>  	};
> diff --git a/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
> b/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
> index 73bd62d8a929e5da..c105932f642ea517 100644
> --- a/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
> +++ b/arch/arm/boot/dts/r8a7745-iwg22d-sodimm.dts
> @@ -123,6 +123,8 @@ phy3: ethernet-phy@3 {
>  	 * On some older versions of the platform (before R4.0) the phy
> address
>  	 * may be 1 or 3. The address is fixed to 3 for R4.0 onwards.
>  	 */
> +		compatible =3D "ethernet-phy-id0022.1622",
> +			     "ethernet-phy-ieee802.3-c22";
>  		reg =3D <3>;
>  		micrel,led-mode =3D <1>;
>  	};
> diff --git a/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
> b/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
> index 8ac61b50aec03190..b024621c998103b2 100644
> --- a/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
> +++ b/arch/arm/boot/dts/r8a77470-iwg23s-sbc.dts
> @@ -79,6 +79,8 @@ &avb {
>  	status =3D "okay";
>=20
>  	phy3: ethernet-phy@3 {
> +		compatible =3D "ethernet-phy-id0022.1622",
> +			     "ethernet-phy-ieee802.3-c22";
>  		reg =3D <3>;
>  		interrupt-parent =3D <&gpio5>;
>  		interrupts =3D <16 IRQ_TYPE_LEVEL_LOW>;
> --
> 2.25.1

