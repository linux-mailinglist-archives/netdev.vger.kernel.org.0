Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C8B65365E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiLUS3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLUS32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:29:28 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2118.outbound.protection.outlook.com [40.107.6.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F24E26558;
        Wed, 21 Dec 2022 10:29:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImgwffB1hiwGODwYT35jhJxZ2gEDddfUBrTWGvGKlnpsf04OSJV6trt263s+LxloQommPTZdOgVE8gkNgKPDx8idKhJ6u53jIasdnfT7/M9YNSkeWFgha4f0BjfIbt4SWkyZCNjtflWaEDwUSWexrfODsvjW0cS9czsZIgCQeFU6MTTT0Tqa59ZJuM/bV+q1sCun7s4ayvMS1BnPwH1Tkcjz8hhSkcY35gpsasYC4ZHZHC4QeMWiqHj4ECz0Ewca2VVnn43enTO90j/2nyaLdFVmZlqzYm8yMRqF41/c0O2RWA1/DHFopz63n1G3pPSdoOrWIv6VvOL6w5qGX5c47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lhvZo6epEyyDLS/w86rZJAYmCNJDBkBKyYjQ0cENxs=;
 b=l5eOTIvsKPnZAkSqv3n+XkGRTXUbp353OzcPXabmP/65OCaTeS0HsUZQpyQLXnlVnAwlUym32wi+G1r515OP/++krpJU8RQgWXnhgivH8/S8IiA/l1j7aF7cQuuXjF+greNw0vNDaEGtjCa4BZiM7rhV0FVv1Nta6N7U3udKDdVNPNsNHEtgh2bzsUBmHDsuUJKOcwvBCkpiGjST1wexN9NyWkSVZoa+Qwyrf/6cNri/Got9o6tYcqP0bPsQaHO/cLRxU/FAITHi1fmd51JRGNXVAZ7AgikRXiLYCbf0Hd+IKDBpMKgJXKGX5NLkRMPvscwZXtPF9xrKiofcw3TYlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lhvZo6epEyyDLS/w86rZJAYmCNJDBkBKyYjQ0cENxs=;
 b=YYkH3WAc7bc+SpGC70L6mJacyDRSMr7B/wju5wzsDNsZSpekO7UuGobM2wQ6UEUHU8MdDxwPJU2CaFyBdJLFhr14/J1y47WZdxUhlsVCLb8iAmbOP7JFuMTBiGfEi4QufKdHkelvqy0uXW8jEiDFQ4isQz9hZJLUXw7dUP5X4d0=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 AS2PR03MB9648.eurprd03.prod.outlook.com (2603:10a6:20b:5e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 18:29:24 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d%3]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 18:29:23 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
Thread-Topic: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (2)
Thread-Index: AQHZE/C1wQWkeZ5g50Kutho7W0eaTK52RcWAgAJmpAA=
Date:   Wed, 21 Dec 2022 18:29:23 +0000
Message-ID: <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
         <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
In-Reply-To: <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|AS2PR03MB9648:EE_
x-ms-office365-filtering-correlation-id: d50e37ee-5386-47e9-75f3-08dae38148ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvF0Ln5P6H0LVv09d4jx3En8N0FwQ+zj1d0CIQnkqjnNfP9SZYYkR1xN8nQ47MF9eEyBeGuiBQCJHg1RBLY1lBR55xJ0RzkMIcJbn4d8gccJ9KzTEYnnOfj2Nym3YeEqEJmN33DnRUdhUmf1iZpttiuwq6JBaFKLYgfjwLsOc40sHa8LSdeCCTxEeIkNGjoT4sqyTRkNpxyrVg1T0KMDjwiztkLhM98fCY4sxcbljuFYj/oOxhb5TyNfTDPGw4sxSrpZ99XU/a2VnV41Znt4q90GBFAlDWsyPo1ZYyJDSmvLJkF39hsOJNlwgPUFQ6VHw7DZ1YXTgLMcqc12cK1N2laDsjeiOYYuoew5GG93zyFpUre+2Bh7eNAj7xzYJlWE7gCKiaRpim8IdwpEGqX+5zBCksqrxNNhs919i0eoWrsqVOk/2gVHVdmr1quxnH/bOdtRdDJVv0KIkHgpj7CszxIhYXSLyYm8Nfk8zHzfW3KYPvGGYi8OWmhhYGeN58xIjrIfS4sp7YXjkD5VSZ7o+x3Kr16cYXrHrh5GmABxdDTTMMwz3zDt9n2CQoQqFyxbey4W++BQH2Y2DozjBSRWfoDKGSI42a190ukcJVs2MPc+aR31Lo6hOmtT5eJGDRakKLPTq/yzxDv+3jpJ8Dsfe9fetcED8WnqX3zzkhspRp+958QHv54IasIbKT++RGNEv/GS+wq/slDPMNZO5kxzGPLiMYiZ1xrgPAt1Vq3sGBA/oGbrVpbll6sy/BsYXuYypoY7QDkkymnHHhLOZcM86Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(136003)(366004)(376002)(396003)(346002)(451199015)(38100700002)(122000001)(71200400001)(6486002)(4001150100001)(2906002)(36756003)(5660300002)(6506007)(966005)(38070700005)(478600001)(8936002)(83380400001)(86362001)(4326008)(66556008)(41300700001)(66446008)(76116006)(64756008)(66946007)(8676002)(91956017)(66476007)(316002)(6916009)(54906003)(2616005)(186003)(6512007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?W5tcNt3qaEkmoK7ou/WAmJgjy33SjG9/2xebiE+WZdSGAAnja/c8zefjL?=
 =?iso-8859-15?Q?yduu6M7BDxbgmbrX+TrZNuPxacGIw8CUgQdanZPMY7o5xBnDUccoJbsPE?=
 =?iso-8859-15?Q?Ifo9ShFFno6gK+dedbkgGYn814znR4+EGNFuTBunmnmKBkVxDw6gN3+B4?=
 =?iso-8859-15?Q?iK9DzLVF2AQD3+t63Kym3PdNkJPyH8dgArkV2gVyKo6cLxNV/+vcuRfMG?=
 =?iso-8859-15?Q?YRMxorFYQoFcSlfY1MUKYLoNXFuvVd9aeEIFo0s1qCZpHp25szw8gnF7m?=
 =?iso-8859-15?Q?bR2OBhzEiICGWf9maeJG0PHJzrfCyXJrXaFkCPtmrR8JZ/qIb3/nPw6vz?=
 =?iso-8859-15?Q?XFDAOhQk96Nt9Wy+3LCPOP2r8OES7eJ/OokXfkKw6hDAjF/P1RbiXQXFL?=
 =?iso-8859-15?Q?Xem8DUI4d0kKb50BorCozeIH5TKq7kfMhasyAX0y1k3sCC6zhWi4mcRMS?=
 =?iso-8859-15?Q?2mcxSCzEqc+xM308fGgFV529fdAdMxnnomOXTOl4ZbJKvc/vDDBj+7FIw?=
 =?iso-8859-15?Q?/EIIcyoumow9zCmlxJJz2t8/T9vaQJxcVdBuXjfjOxY/F6Nob2TOLahLK?=
 =?iso-8859-15?Q?hf7c1VE2iReGUUJP1gDp92GfMhcUFnUrlTty/8GWMn5Xy1akPYUn9qyA9?=
 =?iso-8859-15?Q?ixBPl1xX3TDVKJVTGnhYEz7NNjPia3sv1pbKO5avAfUBFGPmgiB46/fbT?=
 =?iso-8859-15?Q?w6pTM9hlCf9I53yhz5O8HvpVo9Sh22HC0iUfpO4T97I9eZ79UgQHexIY7?=
 =?iso-8859-15?Q?QC9WNmGHLBlOv5MIVK9GhgixcjZjTiRJtPc3bAHRyWb+t2VMPwiKpeUaB?=
 =?iso-8859-15?Q?r4UbryJ0Jj+hlibrjrmx0Vk3FefMC86jLoifKXGXmoamKxggzWCgskWDE?=
 =?iso-8859-15?Q?KogoO8g3bZaXLJvfq9Oc6gz208jTel+ujz2nmgPC0Zi2zAANM1o5O2adM?=
 =?iso-8859-15?Q?oHmGrp7IFOmu5hqt7ysTkLLXJWqVsf4FzBmZkDYzpn27OtJHozNXgdvH2?=
 =?iso-8859-15?Q?J+WSbA2HgppXrhwyXJMwqFPrIiZBe54lDQfQuCPeb7klqYVp01qTsTmHF?=
 =?iso-8859-15?Q?nm9jUMYwqP7wlDoNqHRm25MhE6ETakw6S3zMP/8rTXSxpWPAmqG92sczC?=
 =?iso-8859-15?Q?JxGf+zp1vKeGvYx19zJBV6fKNEeVOLkyM1mMWBGWD3K19J6emF0kJYInl?=
 =?iso-8859-15?Q?g7eiicEAgAcHpUv2IJxbt9p4nS3kaisqyqdL0OWW7EUt3ULmHhOvHV0Pw?=
 =?iso-8859-15?Q?n873y3zmj374Rg6ycad+tHdunNxvbPjMpPOBzjf8yEFPSmfEOuRusr2C6?=
 =?iso-8859-15?Q?2V8baRuBZ3h7B1lH9f2JOfLCppGkE9vBRREagfTitLkT4M9MZ/ldMgyNI?=
 =?iso-8859-15?Q?IND6ysu7mqj4/GbeW4Qy+hXJAaJaEFWI4DczjPP4Knq0W0TQknilzg+Yg?=
 =?iso-8859-15?Q?zwnP/EYHmceOquPoM4SZg5QBqe6938qgwo9djcgxdNvhsyXuUZNkSttnw?=
 =?iso-8859-15?Q?Q54EUGA8xhVBQBhBaOucqneSHnyDHPVVQ+W73rN9XnmDoONQESLh0MmYe?=
 =?iso-8859-15?Q?4CwsdtJPfVkS0+Io9JP+HiDIy9lRQVsdN8+mMHyM+LupMsguDlSLCAQtz?=
 =?iso-8859-15?Q?Gs9+meuxmfPmQrZ11cKKAkV2Z0DNBGrDO9xlJnvkeQrgKWvQxPrxqas5T?=
 =?iso-8859-15?Q?Zs+UC/JyN7jOs3EO9TFoyfnABg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <82DF22B19F378845BF77170533C919A9@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50e37ee-5386-47e9-75f3-08dae38148ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 18:29:23.7548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a4e3GlhtOQDZmy8DF/ktfituX78yjSARkIWwGgIfCiLS656KQFHGeVe7ShjXVl4sjx/kpX1xoWXOJ6T7eHZfUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9648
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 14:49 +0900, Vincent MAILHOL wrote:
> On Tue. 20 Dec. 2022 at 06:29, Frank Jungclaus <frank.jungclaus@esd.eu> w=
rote:
> > Started a rework initiated by Vincents remarks "You should not report
> > the greatest of txerr and rxerr but the one which actually increased."
> > [1]
>=20
> I do not see this comment being addressed. You are still assigning the
> flags depending on the highest value, not the one which actually
> changed.


Yes, I'm assigning depending on the highest value, but from my point of
view doing so is analogue to what is done by can_change_state(). And
it should be fine, because e.g. my "case ESD_BUSSTATE_WARN:" is reached
exactly once while the transition from ERROR_ACTIVE to
ERROR_WARN. Than one of rec or tec is responsible for this
transition.
There is no second pass for "case ESD_BUSSTATE_WARN:"
when e.g. rec is already on WARN (or above) and now tec also reaches
WARN.
Man, this is even difficult to explain in German language ;)


>=20
> > and "As far as I understand, those flags should be set only when
> > the threshold is *reached*" [2] .
> >=20
> > Now setting the flags for CAN_ERR_CRTL_[RT]X_WARNING and
> > CAN_ERR_CRTL_[RT]X_PASSIVE regarding REC and TEC, when the
> > appropriate threshold is reached.
> >=20
> > Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQB=
ebSm+1wEzTqHgvmNuw@mail.gmail.com/
> > Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRG=
WDZBS0fs7zbSTy4hmA@mail.gmail.com/
> > ---
> >  drivers/net/can/usb/esd_usb.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index 5e182fadd875..09745751f168 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -255,10 +255,18 @@ static void esd_usb_rx_event(struct esd_usb_net_p=
riv *priv,
> >                                 can_bus_off(priv->netdev);
> >                                 break;
> >                         case ESD_BUSSTATE_WARN:
> > +                               cf->can_id |=3D CAN_ERR_CRTL;
> > +                               cf->data[1] =3D (txerr > rxerr) ?
> > +                                               CAN_ERR_CRTL_TX_WARNING=
 :
> > +                                               CAN_ERR_CRTL_RX_WARNING=
;
>=20
> Nitpick: when a ternary operator is too long to fit on one line,
> prefer an if/else.

AFAIR line length up to 120 chars is tolerated nowadays. So putting
this on a single line might also be an option!(?)
How will this be handled in the CAN sub tree?


>=20
> >                                 priv->can.state =3D CAN_STATE_ERROR_WAR=
NING;
> >                                 priv->can.can_stats.error_warning++;
> >                                 break;
> >                         case ESD_BUSSTATE_ERRPASSIVE:
> > +                               cf->can_id |=3D CAN_ERR_CRTL;
> > +                               cf->data[1] =3D (txerr > rxerr) ?
> > +                                               CAN_ERR_CRTL_TX_PASSIVE=
 :
> > +                                               CAN_ERR_CRTL_RX_PASSIVE=
;
>=20
> Same.
>=20
> >                                 priv->can.state =3D CAN_STATE_ERROR_PAS=
SIVE;
> >                                 priv->can.can_stats.error_passive++;
> >                                 break;
> > @@ -296,12 +304,6 @@ static void esd_usb_rx_event(struct esd_usb_net_pr=
iv *priv,
> >                         /* Bit stream position in CAN frame as the erro=
r was detected */
> >                         cf->data[3] =3D ecc & SJA1000_ECC_SEG;
> >=20
> > -                       if (priv->can.state =3D=3D CAN_STATE_ERROR_WARN=
ING ||
> > -                           priv->can.state =3D=3D CAN_STATE_ERROR_PASS=
IVE) {
> > -                               cf->data[1] =3D (txerr > rxerr) ?
> > -                                       CAN_ERR_CRTL_TX_PASSIVE :
> > -                                       CAN_ERR_CRTL_RX_PASSIVE;
> > -                       }
> >                         cf->data[6] =3D txerr;
> >                         cf->data[7] =3D rxerr;
> >                 }
>=20
> Yours sincerely,
> Vincent Mailhol

