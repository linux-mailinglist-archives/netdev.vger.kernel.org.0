Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30DD6535A8
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 18:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiLURzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 12:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiLURzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 12:55:08 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2133.outbound.protection.outlook.com [40.107.6.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D2C22BDA;
        Wed, 21 Dec 2022 09:55:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwUeqeXCmtSWkBkyiuwSRMMTOmIhVrqgan8AQC79i6rvbosL+jWasBYfjY8qUP2JoAXAyd6bfeiB8WNzHTOHRMMuX4WRUQ7y/nSlAsYrzHmSzk6Z6dkfPLpxgRomkl0WEwzshndYqStCRV8lBnGUho0feNaUVPxVb5n+dG367yuWhkjfxD/ad7qMol8Wulq+jl1GGq6cF4C8ytObrJ53BUWsRszASbLL9RnIGgndT61Q2aFwHaX9jHdQwICDJfe0KxR10Zsfor4ElQXH1tHbEWceIuTuESY6W1QGujmZwQPxMCS2zF4L2x375bjg3kx+PoV9ov2kWukB5vt+YdQUuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJDNygcYTcBbI5h9f6pVt95l/RaQJJbb14KNgXgRLWQ=;
 b=PHNp41auueeHrvkkdPP/OuU6CjCxM7xC8VjLTqxhRp5M27zHxQxqj+pfSYOKeBuRefc1wNt5Y0A1vRxs5tjRZKlERx2RplV86IXVf2xukou1ltfJIOZw6/zwP0h890J0gergBSJmlWiYYD68YPEGB9tl7Mawl/k3vI94y1OB/nZlrox7p/w6UBdquj5JEIDSS4xwVVZC+e9KTB6OuQNv7O9iXuGSQIY3YQ5S/MeRMnVk4wkPKx4BQvZvpKdesmD4of4+DBtuK3BVhx0KI5zmBxRUYrX0npDrI5DKlg2MED5WuF+6mXfvdg3kwgESjY/ZIOfzh3Lmy7lL5xHldg+dmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJDNygcYTcBbI5h9f6pVt95l/RaQJJbb14KNgXgRLWQ=;
 b=RNcbWQKPa8Maz2JOkRAI6izLNCr+18115pBgEceo195wgrvwdZH4lHBBE4gWQr6NrxoGpQZXM5vFUd3+aL/IvuwpkKy4Gzec3TI9ZuGTXJDg/GdN+rinP8+ojGpaPLUoDhrID86+WZnfQPbHrm8lUzJ9XNZHwwebRv/+h/r88/8=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 DB9PR03MB7419.eurprd03.prod.outlook.com (2603:10a6:10:22b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Wed, 21 Dec 2022 17:55:03 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d%3]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 17:55:03 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (1)
Thread-Topic: [PATCH 1/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (1)
Thread-Index: AQHZE+/Gw9n5xn2X/0SIF+I+izATCa52PJqAgAJmOIA=
Date:   Wed, 21 Dec 2022 17:55:02 +0000
Message-ID: <f9c68625149673fec635d64a21608f3b53866cd7.camel@esd.eu>
References: <20221219212013.1294820-1-frank.jungclaus@esd.eu>
         <20221219212013.1294820-2-frank.jungclaus@esd.eu>
         <CAMZ6RqKc0mvfQGEGb7gCE69Mskhzq5YKF88Jhe+1VR=43YW3Xg@mail.gmail.com>
In-Reply-To: <CAMZ6RqKc0mvfQGEGb7gCE69Mskhzq5YKF88Jhe+1VR=43YW3Xg@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|DB9PR03MB7419:EE_
x-ms-office365-filtering-correlation-id: 86e41a1e-c2a5-4c4b-5542-08dae37c7c5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +5hJ4njjs+iAd7QrjiTlKlGFa75RZDMQuR5jT5VbPFEIgJi3EQOMF5NL4sK9LbJQTomcE5EQlIRhQnEJ58DMzW+xviYl66bk0OCkE5IK/x+L4+y4v5ri6ei+2tL+eiIrgVHO2jORh3yhK9l/r2QtNr3xX2wA4yOKXcqzOXY9Yq7Mpg/2jbAKzCt7RpKOpvAYUfuTtSxg1QaExUruIpPz+a4cFOeBzkt8IQe4aXxxJj3ha7xOhnT5RCZMunRKyXUTYdBFqPdyvhB5Btg+O8HwqcsXoezeRypWep8zGDQktGkdr8IOzFP8vw9A9K+BzvCR1EJLKVw+k+Vf6Iwgsc+jFlT0vWBw5O8X0nxcGKktUTgLxkuHLSvAr6YjuPrB2dV9u9VdMkHNVXQTD7JGpSX4dq/N7gf1RoZUDXoackxhSpYdMK3hLtWDJblAl4+TXQdt9pdKk/uzRCGOwshez+gfDW4MjKmPf9nuG4mM3IDoBYtSrGKknae5DQBcKYG9a00V52/IABxjTNHmfBkqAxngGEjvU4kjNJR1NTgpFME+2HachD7vwVEkf+ComDoi9Efm1O6gkYXmhW6G2tpUf8JypD/8X3yrxe3w6PFVuhcpZcKqzkA6TMuf/iHUQaIUaYgyMDSjtHPKzWHnYUev4uklx1u5+rvEamuxhzVF2L7vTdyymuLV0uRm3ErzBrKu/3fLiCVDA6cew4X49WQ9H9Wu3jklhS8hK0fIMqPQ6xHqy5I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(346002)(376002)(39840400004)(451199015)(5660300002)(64756008)(76116006)(36756003)(91956017)(8676002)(66476007)(966005)(66446008)(6486002)(66946007)(478600001)(8936002)(41300700001)(2616005)(6512007)(4326008)(86362001)(66556008)(71200400001)(6916009)(186003)(83380400001)(2906002)(6506007)(26005)(316002)(4001150100001)(122000001)(54906003)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?kEgC/Y8juK1x4XnndrJT3tDJBlD1JibF7jyG0ynFypN/5NQXZ6O9fDugp?=
 =?iso-8859-15?Q?IVJkN4foMay7ygz1cAS1sfW1NIctF9wFoZBiCAEp+qns6+SGLaT+48Dok?=
 =?iso-8859-15?Q?ZDiAZzKFmPhQDnCGmTv/w+1a9JYQK7dQyGtfW9FuGECHB/nGkDNT2JM/e?=
 =?iso-8859-15?Q?uVg0a+XU4SZy/bgvlLMX3nVvnM7oGMEzixIsO5a8DTAfAGJU62fhPyX6G?=
 =?iso-8859-15?Q?25CCs8EglJDXA6/jIWWBQcidJbTLwRD2T2S6D29Mrpcu1iXOjI+9DcZQG?=
 =?iso-8859-15?Q?Mv5wr0NVh7s6URG3nj6O4F8O+/zIN3iO7siktjXjvCmy6v3xTENsiEYAV?=
 =?iso-8859-15?Q?eeFKGSFttz4yoIhJkfDDknmGhVjI1agosnCc8jXrR1ctpoWzXXW41mxy+?=
 =?iso-8859-15?Q?ybL+9fEsOlKClUsl3Ngeh0jq9zk/5hdPuXURncfmAaq5jrf1QUFn4E/G3?=
 =?iso-8859-15?Q?BC1N3yKfdBJcCT4lHHh4BrI4+iDMuAM+6KIJlP7Z7i1aMqKWymIcJlqjo?=
 =?iso-8859-15?Q?4LzbGhDDMgWYtqqHc98qGQEgl6vUoNLgCHf5J07UJWuX9VuIkb9HP04mC?=
 =?iso-8859-15?Q?MiH0ZMsU3IX1soURmMyRH0JaY7Vs9tcjMH/Uk65kMbH4MdTf0C44pNV2w?=
 =?iso-8859-15?Q?QOTyO+p91d0LnU9hS9dLYPaJRuNueAYodeQSqOHQrqj1bBa89UrlYmPd7?=
 =?iso-8859-15?Q?SsIpzAqpLXJRDTkM3D8tMiDJXIy1Q2ZRxEzt8OzI0boE4xHdAUE8sawPj?=
 =?iso-8859-15?Q?Jvp/UB0YhfB/JZ4qd6BSuj27G4zyw9tBPyiEiDIVqf+KWdFzh0gUyGFwF?=
 =?iso-8859-15?Q?eRkBQ7LVOmP+NMm/dcgM59M6ZssGjADJle4sjk60GnVABYNW3i49sB0P5?=
 =?iso-8859-15?Q?IWlch+r41hkKTWGfhwFCz3gOLZhljg5F57FCv4PxVHXctjWTM6IljVzbu?=
 =?iso-8859-15?Q?xjIZKAhLRzHlRx3yPAWaKbfSsOEtKGaOPwzsK/UcTiMqiaRTUo6lNf0Oa?=
 =?iso-8859-15?Q?oTA+AjLGRZvEswfzjdyCd1sGezBM2K8YSKruAAh+Cu7IfmhklCOEGY4Ye?=
 =?iso-8859-15?Q?W19N7Q7cdyltqgTCEEOOHH1QjS9aKL/nOCKicOobNknsc5NAYHTsxQ3Rq?=
 =?iso-8859-15?Q?Wqm0R1mLfN+5+8ls3U83daHrvTO1W4RBVXxLzVvSY2vn7CYFKoX9GG5Ic?=
 =?iso-8859-15?Q?EQp0uX75w/LpxC5i9CmQkd+CkOqmV4bK7JMNWhW2woiaxL8cpblPmuvkW?=
 =?iso-8859-15?Q?w7eZZIEEgffVDHxL3erL2nNlzLVOZhcjned4T5ebFDntk2diuahOa2taO?=
 =?iso-8859-15?Q?woz2IJY+jeTBsKgMypQIlfy4ViV7oPDXkSF5AsmcsHwqerYsSgOsclVo1?=
 =?iso-8859-15?Q?4jWHRPaY2YImB1PD+sKiIdxRYytf+DXH8H1DpxkyFLyZ5N0SQTrJBIcKn?=
 =?iso-8859-15?Q?j5NffySXrmm0BevtuWI3lHykQ9NdLHQRnuOFDfriOVtpoRvoykNTaIvZD?=
 =?iso-8859-15?Q?DfKlqocOwpRvm4JWFhRgGfmfVacnHYBVVqF4yJmuEnXR0hYVnMFQxS1yF?=
 =?iso-8859-15?Q?ucUkPIANi9slCjM7vZkxg17qRf9BMX7LeGZUb5Iib+3SMsfyf5h+LZQRT?=
 =?iso-8859-15?Q?4ctLM9l1Egaa8NvKOLoAiXrdptpQNoWw7Ktt9wLriVRy9Gfsa7Xb5mcp2?=
 =?iso-8859-15?Q?lg2OPVjoHPiTm+J7nMvRM2BrHg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <9A27873C4391A44BB5413039CCB8357D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e41a1e-c2a5-4c4b-5542-08dae37c7c5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 17:55:02.7753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XwoqBj0PgrUpvMW5+mxgAXIftLB6xBw5AmuUHgohMLvftMoTJ3/nRe6DrQm9kMZz6ZMWJg7p+ABKiseByKpi8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 14:16 +0900, Vincent MAILHOL wrote:
> On Tue. 20 Dec. 2022 at 06:25, Frank Jungclaus <frank.jungclaus@esd.eu> w=
rote:
> >=20
> > Moved the supply for cf->data[3] (bit stream position of CAN error)
> > outside of the "switch (ecc & SJA1000_ECC_MASK){}"-statement, because
> > this position is independent of the error type.
> >=20
> > Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index 42323f5e6f3a..5e182fadd875 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -286,7 +286,6 @@ static void esd_usb_rx_event(struct esd_usb_net_pri=
v *priv,
> >                                 cf->data[2] |=3D CAN_ERR_PROT_STUFF;
> >                                 break;
> >                         default:
> > -                               cf->data[3] =3D ecc & SJA1000_ECC_SEG;
> >                                 break;
> >                         }
> >=20
> > @@ -294,6 +293,9 @@ static void esd_usb_rx_event(struct esd_usb_net_pri=
v *priv,
> >                         if (!(ecc & SJA1000_ECC_DIR))
> >                                 cf->data[2] |=3D CAN_ERR_PROT_TX;
> >=20
> > +                       /* Bit stream position in CAN frame as the erro=
r was detected */
> > +                       cf->data[3] =3D ecc & SJA1000_ECC_SEG;
>=20
> Can you confirm that the value returned by the device matches the
> specifications from linux/can/error.h?

The value returned is supposed to be compatible to the SJA1000 ECC
register.

See
https://esd.eu/fileadmin/esd/docs/manuals/NTCAN_Part1_Function_API_Manual_e=
n_56.pdf

Chapter "6.2.10 EV_CAN_ERROR_EXT" (page 185)
and=20
"Annex B: Bus Error Code" table 37 and 38 (page 272 and following).

So this should be compliant with the values given in linux/can/error.h.


>=20
>   https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/e=
rror.h#L90
>=20
> >                         if (priv->can.state =3D=3D CAN_STATE_ERROR_WARN=
ING ||
> >                             priv->can.state =3D=3D CAN_STATE_ERROR_PASS=
IVE) {
> >                                 cf->data[1] =3D (txerr > rxerr) ?
> > --
> > 2.25.1
> >=20

