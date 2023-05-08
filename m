Return-Path: <netdev+bounces-930-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FAE66FB669
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9F72810B4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C562A1097F;
	Mon,  8 May 2023 18:48:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C754411
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:48:01 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2100.outbound.protection.outlook.com [40.107.20.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D9F5BAE;
	Mon,  8 May 2023 11:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gc+ZBv+g8uQL152Re+o4TKrRBTgVReV8A5RLIIQ8BSxK02xuncumpXYUm1sFWhkY+iiNIt2U0vzExFZPkY6pPqWw8sNzqhSCc1NwO2+TCEJFKuFxw/QLWilghRdZdFw+swXOYSU16zhi60URTdCBCYeLd5v16Wtej+itDZGB8MvCVtnhzXwTMuMeerGpC0h+SJ69mVqz81fifb1D3JdN3OspDo4mNITPRN3LOEyguqxwuA9HKNsHFx9ytgoApLSc2h6Up7zt4rWqj6uN1zSqh690+LkfoQyclQQzi1TNiUsAv5IcSqtm+TWLEgND2oLlJnO409W4xymEF7j2m65dnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dH4Z84DUq1+6gWFrK0a/wGFC91CP4u/W0yaIigK/UWA=;
 b=YJkXcYuEz3wqphc9M/gn+xoCyO/uEexzJ+mNNo6nJ2O9VK8QPPnfeEqFihECZKi5Z5WZXOFcvLt2zTEvhDsgVYellJ+MpIODw4sH9wxxpy5Plc1TbsPLlF8SPeojmReDAVuj5tCL7TxXF4VJivllxX9IyRRRHYlybeXPB5KoVEoL9baZTBTYwigsxgqHIj8aoTFVglXP4dGfPTjOuOQyGCvPpTjV2NIzklMQ3nbZ6ctW1wuBjmy19Ae1kVbVzW/TfZWf2d4uGIGeWENCy8XJnhePg7LgWIqNIsfBECczelFezqtUT8Gdz9xbSRQq4A5/zhBCELTDNWqeDlSkkIHb6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH4Z84DUq1+6gWFrK0a/wGFC91CP4u/W0yaIigK/UWA=;
 b=byFu1T6HcrBx9FrBvLcVH/hMAIueaHRLQWZq5/EvZua5QxFjsbQvR4N2HBnFHEw6QbyQMOsYLYKeW+7QFb+7jxrMvOMth08VPB//OAAvJPydfBWYNt2TqANfTkMMaOs5GFt2xS7ty++JL5tKfZT9Ai/VTLkUml0hC+WSKrdSEsk=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 DU0PR03MB10185.eurprd03.prod.outlook.com (2603:10a6:10:467::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 18:47:51 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::2061:af65:d16c:e414]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::2061:af65:d16c:e414%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 18:47:50 +0000
From: Frank Jungclaus <Frank.Jungclaus@esd.eu>
To: "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC: =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
	"linux-can@vger.kernel.org" <linux-can@vger.kernel.org>, "mkl@pengutronix.de"
	<mkl@pengutronix.de>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"wg@grandegger.com" <wg@grandegger.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] can: esd_usb: Add support for esd CAN-USB/3
Thread-Topic: [PATCH 2/2] can: esd_usb: Add support for esd CAN-USB/3
Thread-Index: AQHZfp9Ps5B/Q8vwtUW0fau+6LORJq9Ol8KAgAImK4A=
Date: Mon, 8 May 2023 18:47:50 +0000
Message-ID: <ff1374d58d98a42d5f78a2685c748730b26926b9.camel@esd.eu>
References: <20230504154414.1864615-1-frank.jungclaus@esd.eu>
	 <20230504154414.1864615-3-frank.jungclaus@esd.eu>
	 <CAMZ6RqKgJs-yJaaqREmN1SkUzE1EkGtjBzXiATKx5WL+=J48dQ@mail.gmail.com>
In-Reply-To:
 <CAMZ6RqKgJs-yJaaqREmN1SkUzE1EkGtjBzXiATKx5WL+=J48dQ@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|DU0PR03MB10185:EE_
x-ms-office365-filtering-correlation-id: 8c24e8da-952f-4ca4-a53b-08db4ff4b97a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 oFSavoGSPxUA/wuXWRLt2C0JzEFDxgA/PC22BPscmMsNkMaUA9OgECKxdFNAevKj+o3lBOCLCnz+KZSLzHS+P32j73hX9eiHPCQ9M03s7pwWPhV9TDi9NnAm1tZuMnxzidAKgDjJxcUgXzZKqpwThihRdxbM7qfKaZvehW3RRGAvK7+tAlEKW1CWSccgYvTLAABO/iOAcQL5F5G48WAkrT237WyepEkz7DB/YaVgy5tUJokMC4H7BMi8+YWzU1boA9CGWApj7ZIkvO7PDCrYpYb4FCIBERQ0SIf+SWOtpyyMKR0/8fCw/uHlk8wEXKUbLUlkW3eGRsTluIp/0oBipkiK/A5iHunkSz8xR2+vCMDdSjBfLzbXuWsMVw6HuRGoHyjUqd2Nio3UhdK92GrYsnT8xrXEkWwDZ57CGST10yMsLPYrB8CiNu5dqlZ2RPXvZ4CJyMq2OGuyUgdPumbquWSSXChQh8tIVNwOH9YCjGn4ucxVllAU+LgR+uGM0cQYr+p+QAIZ8XwNHY0EkUw9krrAyNpDlDsW/8tOGiHNUdJIQudBdEdtv225IjuMLIpFRN0vFlKdp5sRFpraW+H8lSTg7jqLpEOe2+nvhtLaio8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(136003)(376002)(346002)(451199021)(6486002)(6506007)(26005)(6512007)(966005)(83380400001)(2616005)(36756003)(38100700002)(122000001)(86362001)(38070700005)(186003)(30864003)(2906002)(54906003)(316002)(8676002)(8936002)(41300700001)(76116006)(91956017)(6916009)(4326008)(5660300002)(64756008)(66446008)(66946007)(66476007)(66556008)(478600001)(71200400001)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-15?Q?xzYEDQNgOlaTsmPDAynlj4dbUEvOHPUgXOpJxSfAe9BC/oHaylt5+Tmbu?=
 =?iso-8859-15?Q?ROcAtqKXSx8NkMkmY+cKP+87PqPjDXn4DwCStzYv08w0AXEqWRrENZV2Y?=
 =?iso-8859-15?Q?DwtdQWPX4cLG4WNB56emv1gAzpSqBck3RhAjhnDWxEAbFQ2/OfZSfnrsq?=
 =?iso-8859-15?Q?3+WIdXs6LtfpwvDjVY1YZx+/YddAJn4jWkbABmfCnodcBG99Ceo5QclTG?=
 =?iso-8859-15?Q?qUuwBfWakzxAXwVnvTOW8ADsy0FFqlG0YGBFD9p6lu6GfSb8OED5tnwuF?=
 =?iso-8859-15?Q?Zp7KxK4vT85C699qdjz2LJuLRxvgYYNYXNAVeTV3YFKdw7hxktAe96LAi?=
 =?iso-8859-15?Q?5CS1Bp3wb6AU4KKen46YJXHUy0gerbKhi2cRQWN0y1irwNwpEReslwlqD?=
 =?iso-8859-15?Q?+D9TUhkpjojmbaRYiftJbprZb4A7Jbgzvg+Wv2NU1KjJrbGGOnNx87tcl?=
 =?iso-8859-15?Q?VzNuu98NrYl6R6/nopmPFOGj/BnOFDNKsEHAzaeIpJssQlCnC/JpfyWFT?=
 =?iso-8859-15?Q?zNVqAjvfp9uLlKmhfDvSuHmDtadUYGWfllnl2GjeOSKAnJar/ztwwvmHy?=
 =?iso-8859-15?Q?QsRjdIP2vdyQAywK1WxdAqhMnOr8sW726j7X87dCItehqraivX3yoDhAy?=
 =?iso-8859-15?Q?CGlA0Jfrf1IIXa9DvRLS8OXvU1f2tqvUOfqCo/v3fWhMGR/OrQDeeAnFT?=
 =?iso-8859-15?Q?6cJ0I54k+PGzTmjmk1CsrlYxVnsAzLl/Br60A1adJmSo0Fcc35qD3S6MP?=
 =?iso-8859-15?Q?R3YaI+9U/GMjdpjizsuqM7VZ9SasodHPcUfYc4Gx/aq2OAHJg4QWOuOx0?=
 =?iso-8859-15?Q?/fcjwJgVlFsDMVqEWEesw576gRDjMEG1BI51ySCMT1g700f5wkPtsgMJu?=
 =?iso-8859-15?Q?rXDJ4JG2uJlPVgCnZHGYTjgiz8qwcJUDQNEwYdiz52woUy+dDAm2lbriq?=
 =?iso-8859-15?Q?qQ6Ns3270lEN/scwO7xZEw0yT6Qe2bQVO4e1fFhNEqB6ZH8tY+0Zc0dRL?=
 =?iso-8859-15?Q?58NSJUup8WDrmg6GF9W4LwfXSbYRDvRDINBnJqAXEsfVowm5usdSRX9e2?=
 =?iso-8859-15?Q?5/FQ6uBuynhUQ5RqcmdtigZWeJUDS49TgG0cf3DZndoRn3S3rYEYrj3cJ?=
 =?iso-8859-15?Q?mDV9BZNHr+p7QaYKrwminoWafhbwZ4eSsGGN2NUEYyja8bLQ5xWz27pJK?=
 =?iso-8859-15?Q?TRF/koyz3GMo2O0axiHGSvQGtbgDLcrlj0z2TwMahbplOZ7/6WjjyTWg4?=
 =?iso-8859-15?Q?bMtoBMwTgPB+FAjidxgHsuUzHW0nXQdzSGLhn6Yg0P/MXr9Pxdn7wyhQB?=
 =?iso-8859-15?Q?SNisOAGQ71pqqMG0iJon307wpic41c1YqLz6g4htv28u6hPfEDnwjnQO5?=
 =?iso-8859-15?Q?GUBYyHrHX87hVHvcNQzn0mXVr+zNziajrH/V4mHdMA0nhQROFOrgDBMJG?=
 =?iso-8859-15?Q?8+eqq2/04OTe7rqb0V2GXGJlarCvR95Qpt/dTWdVRg56SUCQE1o+KYdxc?=
 =?iso-8859-15?Q?DOiiO2PQqBr/Jhb0wZ8DYkSYABDF3HtvLgZB463GiP0tBGBPo4zisxjZW?=
 =?iso-8859-15?Q?LPOaeuV3mZHP2C79wmt0YwgbHq/pm4JgEOjiUiSsoYL00XCQFsZ4Tpyzq?=
 =?iso-8859-15?Q?rRzA58fnJNHZK8HNn8c71w2gtIU9Sz6FO9FemIGW7Q3Y5wd5HktuTRT0A?=
 =?iso-8859-15?Q?ZCDFperlicCFeHBnUSQcvn++gw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <423BA4680A7A674B8D6A194D94B5CD24@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c24e8da-952f-4ca4-a53b-08db4ff4b97a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 18:47:50.5394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kXk56JjKweNggxj7V9s9moLG8pYOLzXw/p3W9AYfqf5WpxbcG6mZB23N01c9tRz3Mu+WvqslbcDDmFrWywnmaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB10185
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 2023-05-07 at 18:58 +0900, Vincent MAILHOL wrote:
> Hi Frank,
>=20
> Thank you for your patch. Here is my first batch of comments.

Hi Vincent, thanks for your detailed comments.=A0
See my answers below your comments ...

Regards, Frank

> Some comments also apply to the existing code. So you may want to
> address those in separate clean-up patches first.
>=20
> On Fri. 5 May 2023 at 01:16, Frank Jungclaus <frank.jungclaus@esd.eu> wro=
te:
> > Add support for esd CAN-USB/3 and CAN FD to esd_usb.
> >=20
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 282 ++++++++++++++++++++++++++++++----
> >  1 file changed, 249 insertions(+), 33 deletions(-)
> >=20
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index e24fa48b9b42..48cf5e88d216 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -1,6 +1,6 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  /*
> > - * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
> > + * CAN driver for esd electronics gmbh CAN-USB/2, CAN-USB/3 and CAN-US=
B/Micro
> >   *
> >   * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias=
 Fuchs <socketcan@esd.eu>
> >   * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <fran=
k.jungclaus@esd.eu>
> > @@ -18,17 +18,19 @@
> >=20
> >  MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
> >  MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
> > -MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and =
CAN-USB/Micro interfaces");
> > +MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2, CAN=
-USB/3 and CAN-USB/Micro interfaces");
> >  MODULE_LICENSE("GPL v2");
> >=20
> >  /* USB vendor and product ID */
> >  #define USB_ESDGMBH_VENDOR_ID  0x0ab4
> >  #define USB_CANUSB2_PRODUCT_ID 0x0010
> >  #define USB_CANUSBM_PRODUCT_ID 0x0011
> > +#define USB_CANUSB3_PRODUCT_ID 0x0014
> >=20
> >  /* CAN controller clock frequencies */
> >  #define ESD_USB2_CAN_CLOCK     60000000
> >  #define ESD_USBM_CAN_CLOCK     36000000
> > +#define ESD_USB3_CAN_CLOCK     80000000
>=20
> Nitpick: consider using the unit suffixes from linux/units.h:
>=20
>   #define ESD_USB3_CAN_CLOCK (80 * MEGA)

Ok ...

>=20
> >  /* Maximum number of CAN nets */
> >  #define ESD_USB_MAX_NETS       2
> > @@ -43,6 +45,9 @@ MODULE_LICENSE("GPL v2");
> >=20
> >  /* esd CAN message flags - dlc field */
> >  #define ESD_DLC_RTR            0x10
> > +#define ESD_DLC_NO_BRS         0x10
> > +#define ESD_DLC_ESI            0x20
> > +#define ESD_DLC_FD             0x80
>=20
> Use the BIT() macro:

Ok ...

> #define ESD_DLC_NO_BRS BIT(4)
> #define ESD_DLC_ESI BIT(5)
> #define ESD_DLC_FD BIT(7)
>=20
> Also, if this is specific to the ESD_USB3 then add it in the prefix.

No, this is not specific to esd CAN-USB/3. Those are generally
applicable bits within the len element of an esd CAN (FD) message.
See
https://esd.eu/fileadmin/esd/docs/manuals/NTCAN_Part1_Function_API_Manual_e=
n_56.pdf
6.2.3 CMSG and 6.2.5 CMSG_X

Maybe I should rename the PREFIX ESD_DLC_ to ESD_LEN_ or ESD_USB_LEN_?
DLC might by misleading here.

>=20
> >  /* esd CAN message flags - id field */
> >  #define ESD_EXTID              0x20000000
> > @@ -72,6 +77,28 @@ MODULE_LICENSE("GPL v2");
> >  #define ESD_USB2_BRP_INC       1
> >  #define ESD_USB2_3_SAMPLES     0x00800000
> >=20
> > +/* Bit timing CAN-USB/3 */
> > +#define ESD_USB3_TSEG1_MIN     1
> > +#define ESD_USB3_TSEG1_MAX     256
> > +#define ESD_USB3_TSEG2_MIN     1
> > +#define ESD_USB3_TSEG2_MAX     128
> > +#define ESD_USB3_SJW_MAX       128
> > +#define ESD_USB3_BRP_MIN       1
> > +#define ESD_USB3_BRP_MAX       1024
> > +#define ESD_USB3_BRP_INC       1
> > +/* Bit timing CAN-USB/3, data phase */
> > +#define ESD_USB3_DATA_TSEG1_MIN        1
> > +#define ESD_USB3_DATA_TSEG1_MAX        32
> > +#define ESD_USB3_DATA_TSEG2_MIN        1
> > +#define ESD_USB3_DATA_TSEG2_MAX        16
> > +#define ESD_USB3_DATA_SJW_MAX  8
> > +#define ESD_USB3_DATA_BRP_MIN  1
> > +#define ESD_USB3_DATA_BRP_MAX  32
> > +#define ESD_USB3_DATA_BRP_INC  1
>=20
> There is no clear benefit to define macros for some initializers of a
> const struct.
>=20
> Doing as below has zero ambiguity:
>=20
> static const struct can_bittiming_const esd_usb3_bittiming_const =3D {
>          .name =3D "esd_usb3",
>          .tseg1_min =3D 1,
>          .tseg1_max =3D 256,
>          .tseg2_min =3D 1,
>          .tseg2_max =3D 128,
>          .sjw_max =3D 128,
>          .brp_min =3D 1,
>          .brp_max =3D 1024,
>          .brp_inc =3D 1,
> };

I indeed thought about the way you proposed. But I decided against
this, because I wanted to to this the same way as it is already done
for the esd_usb2. Additionally esd_usb2_set_bittiming() as well as
esd_usb3_set_bittiming() is doing some math by means of this macros!
The terms there will become much more lengthy with e.g
using=A0can_bittiming_const esd_usb3_data_bittiming_const.tseg1_max=20
instead of the macro ESD_USB3_DATA_TSEG1_MAX.

>=20
> > +/* Transmitter Delay Compensation */
> > +#define ESD_TDC_MODE_AUTO      0
> > +
> >  /* esd IDADD message */
> >  #define ESD_ID_ENABLE          0x80
> >  #define ESD_MAX_ID_SEGMENT     64
> > @@ -95,6 +122,21 @@ MODULE_LICENSE("GPL v2");
> >  #define MAX_RX_URBS            4
> >  #define MAX_TX_URBS            16 /* must be power of 2 */
> >=20
> > +/* Modes for NTCAN_BAUDRATE_X */
> > +#define ESD_BAUDRATE_MODE_DISABLE      0 /* remove from bus */
> > +#define ESD_BAUDRATE_MODE_INDEX                1 /* ESD (CiA) bit rate=
 idx */
> > +#define ESD_BAUDRATE_MODE_BTR_CTRL     2 /* BTR values (Controller)*/
> > +#define ESD_BAUDRATE_MODE_BTR_CANONICAL        3 /* BTR values (Canoni=
cal) */
> > +#define ESD_BAUDRATE_MODE_NUM          4 /* numerical bit rate */
> > +#define ESD_BAUDRATE_MODE_AUTOBAUD     5 /* autobaud */
> > +
> > +/* Flags for NTCAN_BAUDRATE_X */
> > +#define ESD_BAUDRATE_FLAG_FD   0x0001 /* enable CAN FD Mode */
> > +#define ESD_BAUDRATE_FLAG_LOM  0x0002 /* enable Listen Only mode */
> > +#define ESD_BAUDRATE_FLAG_STM  0x0004 /* enable Self test mode */
> > +#define ESD_BAUDRATE_FLAG_TRS  0x0008 /* enable Triple Sampling */
> > +#define ESD_BAUDRATE_FLAG_TXP  0x0010 /* enable Transmit Pause */
> > +
> >  struct header_msg {
> >         u8 len; /* len is always the total message length in 32bit word=
s */
> >         u8 cmd;
> > @@ -129,6 +171,7 @@ struct rx_msg {
> >         __le32 id; /* upper 3 bits contain flags */
> >         union {
> >                 u8 data[8];
> > +               u8 data_fd[64];
> >                 struct {
> >                         u8 status; /* CAN Controller Status */
> >                         u8 ecc;    /* Error Capture Register */
> > @@ -144,8 +187,11 @@ struct tx_msg {
> >         u8 net;
> >         u8 dlc;
> >         u32 hnd;        /* opaque handle, not used by device */
> > -       __le32 id; /* upper 3 bits contain flags */
> > -       u8 data[8];
> > +       __le32 id;      /* upper 3 bits contain flags */
> > +       union {
> > +               u8 data[8];
> > +               u8 data_fd[64];
>=20
> Nitpick, use the macro:
>=20
>                   u8 data[CAN_MAX_DLEN];
>                   u8 data_fd[CANFD_MAX_DLEN];

Ok, good hint ...

>=20
> > +       };
> >  };
> >=20
> >  struct tx_done_msg {
> > @@ -165,12 +211,37 @@ struct id_filter_msg {
> >         __le32 mask[ESD_MAX_ID_SEGMENT + 1];
> >  };
> >=20
> > +struct baudrate_x_cfg {
> > +       __le16 brp;     /* bit rate pre-scaler */
> > +       __le16 tseg1;   /* TSEG1 register */
> > +       __le16 tseg2;   /* TSEG2 register */
> > +       __le16 sjw;     /* SJW register */
> > +};
> > +
> > +struct tdc_cfg {
>=20
> Please prefix all the structures with the device name. e.g.
>=20
>   struct esd_usb3_tdc_cfg {

I'll change this ...

>=20
> > +       u8 tdc_mode;    /* transmitter Delay Compensation mode  */
> > +       u8 ssp_offset;  /* secondary Sample Point offset in mtq */
> > +       s8 ssp_shift;   /* secondary Sample Point shift in mtq */
> > +       u8 tdc_filter;  /* Transmitter Delay Compensation */
> > +};
> > +
> > +struct baudrate_x {
>=20
> The x in baudrate_x and baudrate_x_cfg is confusing me. Is it meant to
> signify that the structure applies to both nominal and data baudrate?
> In that case, just put a comment and remove the x from the name.

I'd like to leave the _x in BAUDRATE_X, because this is the way it is
named in the reference implementation in the esd NTCAN API. For details
see
https://esd.eu/fileadmin/esd/docs/manuals/NTCAN_Part1_Function_API_Manual_e=
n_56.pdf
6.2.15 NTCAN_BAUDRATE_X

But it should be fine to remove the _x for the arb and data elements.

>=20
> > +       __le16 mode;    /* mode word */
> > +       __le16 flags;   /* control flags */
> > +       struct tdc_cfg tdc;     /* TDC configuration */
> > +       struct baudrate_x_cfg arb;      /* bit rate during arbitration =
phase  */
>=20
> /* nominal bit rate */
>=20
> The comment is incorrect. CAN-FD may use the nominal bitrate for the
> data phase if the bit rate switch (BRS) is not set.
> > +       struct baudrate_x_cfg data;     /* bit rate during data phase *=
/
>=20
> /* data bit rate */
>=20
> Please adjust the field names accordingly.

Ok, I'll change the comments + field names to nom(inal) and data

>=20
> > +};
> > +
> >  struct set_baudrate_msg {
> >         u8 len;
> >         u8 cmd;
> >         u8 net;
> >         u8 rsvd;
> > -       __le32 baud;
> > +       union {
> > +               __le32 baud;
> > +               struct baudrate_x baud_x;
> > +       };
> >  };
> >=20
> >  /* Main message type used between library and application */
> > @@ -188,6 +259,7 @@ union __packed esd_usb_msg {
> >  static struct usb_device_id esd_usb_table[] =3D {
> >         {USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
> >         {USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
> > +       {USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB3_PRODUCT_ID)},
> >         {}
> >  };
> >  MODULE_DEVICE_TABLE(usb, esd_usb_table);
> > @@ -326,11 +398,13 @@ static void esd_usb_rx_event(struct esd_usb_net_p=
riv *priv,
> >  static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
> >                                union esd_usb_msg *msg)
> >  {
> > +       bool is_canfd =3D msg->rx.dlc & ESD_DLC_FD ? true : false;
>=20
> This is redundant. Just this is enough:
>=20
>   bool is_canfd =3D msg->rx.dlc & ESD_DLC_FD;
>=20
> This variable being used only twice, you may want to consider not
> declaring it and simply doing directly:

I'll change to "doing this directly". Initially, while starting to
rework esd_usb_rx_can_msg(), I assumed I'll need to check for is_canfd
much more frequently. But obviously, as you stated, it's only used
twice.

>=20
>           if (msg->rx.dlc & ESD_DLC_FD)
>=20
> >         struct net_device_stats *stats =3D &priv->netdev->stats;
> >         struct can_frame *cf;
> > +       struct canfd_frame *cfd;
> >         struct sk_buff *skb;
> > -       int i;
> >         u32 id;
> > +       u8 len;
> >=20
> >         if (!netif_device_present(priv->netdev))
> >                 return;
> > @@ -340,27 +414,42 @@ static void esd_usb_rx_can_msg(struct esd_usb_net=
_priv *priv,
> >         if (id & ESD_EVENT) {
> >                 esd_usb_rx_event(priv, msg);
> >         } else {
> > -               skb =3D alloc_can_skb(priv->netdev, &cf);
> > +               if (is_canfd) {
> > +                       skb =3D alloc_canfd_skb(priv->netdev, &cfd);
> > +               } else {
> > +                       skb =3D alloc_can_skb(priv->netdev, &cf);
> > +                       cfd =3D (struct canfd_frame *)cf;
> > +               }
> > +
> >                 if (skb =3D=3D NULL) {
> >                         stats->rx_dropped++;
> >                         return;
> >                 }
> >=20
> > -               cf->can_id =3D id & ESD_IDMASK;
> > -               can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_DLC_RTR,
> > -                                    priv->can.ctrlmode);
> > -
> > -               if (id & ESD_EXTID)
> > -                       cf->can_id |=3D CAN_EFF_FLAG;
> > +               cfd->can_id =3D id & ESD_IDMASK;
> >=20
> > -               if (msg->rx.dlc & ESD_DLC_RTR) {
> > -                       cf->can_id |=3D CAN_RTR_FLAG;
> > +               if (is_canfd) {
> > +                       /* masking by 0x0F is already done within can_f=
d_dlc2len() */
> > +                       cfd->len =3D can_fd_dlc2len(msg->rx.dlc);
> > +                       len =3D cfd->len;
> > +                       if ((msg->rx.dlc & ESD_DLC_NO_BRS) =3D=3D 0)
> > +                               cfd->flags |=3D CANFD_BRS;
> > +                       if (msg->rx.dlc & ESD_DLC_ESI)
> > +                               cfd->flags |=3D CANFD_ESI;
> >                 } else {
> > -                       for (i =3D 0; i < cf->len; i++)
> > -                               cf->data[i] =3D msg->rx.data[i];
> > -
> > -                       stats->rx_bytes +=3D cf->len;
> > +                       can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_DLC=
_RTR, priv->can.ctrlmode);
> > +                       len =3D cf->len;
> > +                       if (msg->rx.dlc & ESD_DLC_RTR) {
> > +                               cf->can_id |=3D CAN_RTR_FLAG;
> > +                               len =3D 0;
> > +                       }
> >                 }
> > +
> > +               if (id & ESD_EXTID)
> > +                       cfd->can_id |=3D CAN_EFF_FLAG;
> > +
> > +               memcpy(cfd->data, msg->rx.data_fd, len);
> > +               stats->rx_bytes +=3D len;
> >                 stats->rx_packets++;
> >=20
> >                 netif_rx(skb);
> > @@ -735,7 +824,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buf=
f *skb,
> >         struct esd_usb *dev =3D priv->usb;
> >         struct esd_tx_urb_context *context =3D NULL;
> >         struct net_device_stats *stats =3D &netdev->stats;
> > -       struct can_frame *cf =3D (struct can_frame *)skb->data;
> > +       struct canfd_frame *cfd =3D (struct canfd_frame *)skb->data;
> >         union esd_usb_msg *msg;
> >         struct urb *urb;
> >         u8 *buf;
> > @@ -768,19 +857,28 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_b=
uff *skb,
> >         msg->hdr.len =3D 3; /* minimal length */
> >         msg->hdr.cmd =3D CMD_CAN_TX;
> >         msg->tx.net =3D priv->index;
> > -       msg->tx.dlc =3D can_get_cc_dlc(cf, priv->can.ctrlmode);
> > -       msg->tx.id =3D cpu_to_le32(cf->can_id & CAN_ERR_MASK);
> >=20
> > -       if (cf->can_id & CAN_RTR_FLAG)
> > -               msg->tx.dlc |=3D ESD_DLC_RTR;
> > +       if (can_is_canfd_skb(skb)) {
> > +               msg->tx.dlc =3D can_fd_len2dlc(cfd->len);
> > +               msg->tx.dlc |=3D ESD_DLC_FD;
> > +
> > +               if ((cfd->flags & CANFD_BRS) =3D=3D 0)
> > +                       msg->tx.dlc |=3D ESD_DLC_NO_BRS;
> > +       } else {
> > +               msg->tx.dlc =3D can_get_cc_dlc((struct can_frame *)cfd,=
 priv->can.ctrlmode);
> > +
> > +               if (cfd->can_id & CAN_RTR_FLAG)
> > +                       msg->tx.dlc |=3D ESD_DLC_RTR;
> > +       }
> >=20
> > -       if (cf->can_id & CAN_EFF_FLAG)
> > +       msg->tx.id =3D cpu_to_le32(cfd->can_id & CAN_ERR_MASK);
> > +
> > +       if (cfd->can_id & CAN_EFF_FLAG)
> >                 msg->tx.id |=3D cpu_to_le32(ESD_EXTID);
> >=20
> > -       for (i =3D 0; i < cf->len; i++)
> > -               msg->tx.data[i] =3D cf->data[i];
> > +       memcpy(msg->tx.data_fd, cfd->data, cfd->len);
> >=20
> > -       msg->hdr.len +=3D (cf->len + 3) >> 2;
> > +       msg->hdr.len +=3D (cfd->len + 3) >> 2;
>=20
> I do not get the logic.
>=20
> Assuming cfd->len is 8. Then
>=20
>   hdr.len +=3D (8 + 3) >> 2
>   hdr.len +=3D 2
>=20
> And because hdr.len is initially 3, hdr.len becomes 5. Right? Shouldn't i=
t be 8?

It might be a little confusing, but I think it's fine.=A0
hdr.len is given in units of longwords (4 bytes each)! Therefore we
have 12 bytes (the initial 3 longwords) for struct tx_msg before
tx_msg.data[].=A0
Than (8 + 3)/4=3D2 gives us 2 additional longwords for the 8 data bytes.
So that 3+2=3D5 (equal to 20 bytes) should be ok.

>=20
> >         for (i =3D 0; i < MAX_TX_URBS; i++) {
> >                 if (priv->tx_contexts[i].echo_index =3D=3D MAX_TX_URBS)=
 {
> > @@ -966,6 +1064,108 @@ static int esd_usb2_set_bittiming(struct net_dev=
ice *netdev)
> >         return err;
> >  }
> >=20
> > +static const struct can_bittiming_const esd_usb3_bittiming_const =3D {
> > +       .name =3D "esd_usb3",
> > +       .tseg1_min =3D ESD_USB3_TSEG1_MIN,
> > +       .tseg1_max =3D ESD_USB3_TSEG1_MAX,
> > +       .tseg2_min =3D ESD_USB3_TSEG2_MIN,
> > +       .tseg2_max =3D ESD_USB3_TSEG2_MAX,
> > +       .sjw_max =3D ESD_USB3_SJW_MAX,
> > +       .brp_min =3D ESD_USB3_BRP_MIN,
> > +       .brp_max =3D ESD_USB3_BRP_MAX,
> > +       .brp_inc =3D ESD_USB3_BRP_INC,
> > +};
> > +
> > +static const struct can_bittiming_const esd_usb3_data_bittiming_const =
=3D {
> > +       .name =3D "esd_usb3",
> > +       .tseg1_min =3D ESD_USB3_DATA_TSEG1_MIN,
> > +       .tseg1_max =3D ESD_USB3_DATA_TSEG1_MAX,
> > +       .tseg2_min =3D ESD_USB3_DATA_TSEG2_MIN,
> > +       .tseg2_max =3D ESD_USB3_DATA_TSEG2_MAX,
> > +       .sjw_max =3D ESD_USB3_DATA_SJW_MAX,
> > +       .brp_min =3D ESD_USB3_DATA_BRP_MIN,
> > +       .brp_max =3D ESD_USB3_DATA_BRP_MAX,
> > +       .brp_inc =3D ESD_USB3_DATA_BRP_INC,
> > +};
> > +
> > +static int esd_usb3_set_bittiming(struct net_device *netdev)
> > +{
> > +       struct esd_usb_net_priv *priv =3D netdev_priv(netdev);
> > +       struct can_bittiming *bt   =3D &priv->can.bittiming;
> > +       struct can_bittiming *d_bt =3D &priv->can.data_bittiming;
> > +       union esd_usb_msg *msg;
> > +       int err;
> > +       u16 mode;
> > +       u16 flags =3D 0;
> > +       u16 brp, tseg1, tseg2, sjw;
> > +       u16 d_brp, d_tseg1, d_tseg2, d_sjw;
> > +
> > +       msg =3D kmalloc(sizeof(*msg), GFP_KERNEL);
> > +       if (!msg)
> > +               return -ENOMEM;
> > +
> > +       /* Canonical is the most reasonable mode for SocketCAN on CAN-U=
SB/3 ... */
> > +       mode =3D ESD_BAUDRATE_MODE_BTR_CANONICAL;
> > +
> > +       if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> > +               flags |=3D ESD_BAUDRATE_FLAG_LOM;
> > +
> > +       if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
> > +               flags |=3D ESD_BAUDRATE_FLAG_TRS;
> > +
> > +       brp =3D bt->brp & (ESD_USB3_BRP_MAX - 1);
> > +       sjw =3D bt->sjw & (ESD_USB3_SJW_MAX - 1);
> > +       tseg1 =3D (bt->prop_seg + bt->phase_seg1) & (ESD_USB3_TSEG1_MAX=
 - 1);
> > +       tseg2 =3D bt->phase_seg2 & (ESD_USB3_TSEG2_MAX - 1);
>=20
> I am not convinced by the use of these intermediate variables brp,
> sjw, tseg1 and tseg2. I think you can directly assign them to baud_x.

I chose this way to prevent lengthy terms on the right side of the
following assignments. Also those variables are (still) used in the
netdev_info() below.

>=20
> > +       msg->setbaud.baud_x.arb.brp =3D cpu_to_le16(brp);
> > +       msg->setbaud.baud_x.arb.sjw =3D cpu_to_le16(sjw);
> > +       msg->setbaud.baud_x.arb.tseg1 =3D cpu_to_le16(tseg1);
> > +       msg->setbaud.baud_x.arb.tseg2 =3D cpu_to_le16(tseg2);
>=20
> You may want to declare a local variable
>=20
>   struct baudrate_x *baud_x =3D &msg->setbaud.baud_x;
>=20
> so that you do not have to do msg->setbaud.baud_x each time.

... ok, fine, with this I could gain some space for lengthy terms on
the right side ;)

>=20
> > +       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> > +               d_brp =3D d_bt->brp & (ESD_USB3_DATA_BRP_MAX - 1);
> > +               d_sjw =3D d_bt->sjw & (ESD_USB3_DATA_SJW_MAX - 1);
> > +               d_tseg1 =3D (d_bt->prop_seg + d_bt->phase_seg1) & (ESD_=
USB3_DATA_TSEG1_MAX - 1);
> > +               d_tseg2 =3D d_bt->phase_seg2 & (ESD_USB3_DATA_TSEG2_MAX=
 - 1);
> > +               flags |=3D ESD_BAUDRATE_FLAG_FD;
> > +       } else {
> > +               d_brp =3D 0;
> > +               d_sjw =3D 0;
> > +               d_tseg1 =3D 0;
> > +               d_tseg2 =3D 0;
> > +       }
> > +
> > +       msg->setbaud.baud_x.data.brp =3D cpu_to_le16(d_brp);
> > +       msg->setbaud.baud_x.data.sjw =3D cpu_to_le16(d_sjw);
> > +       msg->setbaud.baud_x.data.tseg1 =3D cpu_to_le16(d_tseg1);
> > +       msg->setbaud.baud_x.data.tseg2 =3D cpu_to_le16(d_tseg2);
> > +       msg->setbaud.baud_x.mode =3D cpu_to_le16(mode);
> > +       msg->setbaud.baud_x.flags =3D cpu_to_le16(flags);
> > +       msg->setbaud.baud_x.tdc.tdc_mode =3D ESD_TDC_MODE_AUTO;
> > +       msg->setbaud.baud_x.tdc.ssp_offset =3D 0;
> > +       msg->setbaud.baud_x.tdc.ssp_shift =3D 0;
> > +       msg->setbaud.baud_x.tdc.tdc_filter =3D 0;
>=20
> It seems that your device supports TDC. What is the reason to not configu=
re it?
Yes, TDC is supported.
The intention was to hand this in by means of a follow-up patch and
until than live with TDC on auto mode. I'm already far beyond any time
schedule for putting CAN-USB/3 into Linux ;)=20


> Please have a look at struct can_tdc:
>=20
>   https://elixir.bootlin.com/linux/v6.2/source/include/linux/can/bittimin=
g.h#L21
>=20
> Please refer to this patch if you want an example of how to use TDC:
>=20
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D1010a8fa9608
>=20

Thanks for that pointers! I'll check ...

> > +       msg->hdr.len =3D 7;
>=20
> What is this magic number? If possible, replace it with a sizeof().

I think each setting of msg->hdr.len in this driver is somewhat hard-
coded ;)=A0
Maybe this has been caused by the ancient documentation for our can-usb
protocol / firmware, that states things like "set len to 2 for
set_baudrate" or "set len to 7 (24 bytes) for set_baudrate_x ;)

>=20
> It seems that this relates to the size of struct set_baudrate_msg, but
> that structure is 8 bytes. Is the last byte of struct set_baudrate_msg
> really used? If not, reflect this in the declaration of the structure.

sizeof(set_baudrate_msg) should be 4 * u8 + sizeof(baudrate_x).
sizeof(baudrate_x) should be 2 * le16  + 4 * u8 + 2 * (4 * le16)
So I'll count 4 * 1 + 2 * 2 + 4 * 1 + 2 * (4 * 2) =3D 28
28 >> 2 gives us 7.
So 7 is fine here. But I agree that a sizeof(struct baudrate_x) would
be much clearer. I'll change this one to sizeof() and leave all other
"msg.hdr.len =3D" expression as they are, until a follow-up cleanup.

>=20
> > +       msg->hdr.cmd =3D CMD_SETBAUD;
> > +
> > +       msg->setbaud.net =3D priv->index;
> > +       msg->setbaud.rsvd =3D 0;
> > +
> > +       netdev_info(netdev,
> > +                   "ctrlmode=3D%#x/%#x, esd-net=3D%u, esd-mode=3D%#x, =
esd-flg=3D%#x, arb: brp=3D%u, ts1=3D%u, ts2=3D%u, sjw=3D%u, data: dbrp=3D%u=
, dts1=3D%u, dts2=3D%u dsjw=3D%u\n",
> > +                   priv->can.ctrlmode, priv->can.ctrlmode_supported,
> > +                   priv->index, mode, flags,
> > +                   brp, tseg1, tseg2, sjw,
> > +                   d_brp, d_tseg1, d_tseg2, d_sjw);
>=20
> Remove this debug message. The bittiming information can be retrieved
> with the ip tool.
>=20
>   ip --details link show canX
Yes, I know. But my intention was to exactly and directly see the
individual values passed to the USB set baudrate command without using
wireshark to sniff the USB, if anybody complains about problems with
the bitrate. This netdev_info is similar to the=A0"netdev_info(netdev,
"setting BTR=3D%#x\n", canbtr);" for CAN-USB/2.

So from my point of view this is an informational message too, and not
a debug message.

>=20
> > +       err =3D esd_usb_send_msg(priv->usb, msg);
> > +
> > +       kfree(msg);
>=20
> esd_usb_send_msg() uses usb_bulk_msg() which does a synchronous call.
> It would be great to go asynchronous and use usb_submit_urb() so that
> you minimize the time spent in the driver.
>=20
> I know that  esd_usb2_set_bittiming() also uses the synchronous call,
> so I am fine to have it as-is for this patch but for the future, it
> would be great to consider refactoring this.

ACK. I'll put this on the todo list for a follow-up patch.

>=20
> > +       return err;
> > +}
> > +
> >  static int esd_usb_get_berr_counter(const struct net_device *netdev,
> >                                     struct can_berr_counter *bec)
> >  {
> > @@ -1023,16 +1223,32 @@ static int esd_usb_probe_one_net(struct usb_int=
erface *intf, int index)
> >                 CAN_CTRLMODE_CC_LEN8_DLC |
> >                 CAN_CTRLMODE_BERR_REPORTING;
> >=20
> > -       if (le16_to_cpu(dev->udev->descriptor.idProduct) =3D=3D
> > -           USB_CANUSBM_PRODUCT_ID)
> > +       switch (le16_to_cpu(dev->udev->descriptor.idProduct)) {
>=20
> Instead of doing a switch on idProduct, you can use the driver_info
> field from struct usb_device_id to store the device quirks.
>=20
> You can pass either a pointer or some flags into driver_info. Examples:
>=20
>   https://elixir.bootlin.com/linux/v6.2/source/drivers/net/can/usb/peak_u=
sb/pcan_usb_core.c#L30
>   https://elixir.bootlin.com/linux/v6.2/source/drivers/net/can/usb/etas_e=
s58x/es58x_core.c#L37
>=20

Yes using flags within .driver_info like es58x_core.c does it, seems to
be a good idea here. But I'd like to leave this for a follow-up patch,
too.


> > +       case USB_CANUSB3_PRODUCT_ID:
> > +               priv->can.clock.freq =3D ESD_USB3_CAN_CLOCK;
> > +               priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_3_SAMPLE=
S;
> > +               priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_FD;
> > +               priv->can.bittiming_const =3D &esd_usb3_bittiming_const=
;
> > +               priv->can.data_bittiming_const =3D &esd_usb3_data_bitti=
ming_const;
> > +               priv->can.do_set_bittiming =3D esd_usb3_set_bittiming;
> > +               priv->can.do_set_data_bittiming =3D esd_usb3_set_bittim=
ing;
> > +               break;
> > +
> > +       case USB_CANUSBM_PRODUCT_ID:
> >                 priv->can.clock.freq =3D ESD_USBM_CAN_CLOCK;
> > -       else {
> > +               priv->can.bittiming_const =3D &esd_usb2_bittiming_const=
;
> > +               priv->can.do_set_bittiming =3D esd_usb2_set_bittiming;
> > +               break;
> > +
> > +       case USB_CANUSB2_PRODUCT_ID:
> > +       default:
> >                 priv->can.clock.freq =3D ESD_USB2_CAN_CLOCK;
> >                 priv->can.ctrlmode_supported |=3D CAN_CTRLMODE_3_SAMPLE=
S;
> > +               priv->can.bittiming_const =3D &esd_usb2_bittiming_const=
;
> > +               priv->can.do_set_bittiming =3D esd_usb2_set_bittiming;
> > +               break;
> >         }
> >=20
> > -       priv->can.bittiming_const =3D &esd_usb2_bittiming_const;
> > -       priv->can.do_set_bittiming =3D esd_usb2_set_bittiming;
> >         priv->can.do_set_mode =3D esd_usb_set_mode;
> >         priv->can.do_get_berr_counter =3D esd_usb_get_berr_counter;
> >=20
> > --
> > 2.25.1
> >=20


