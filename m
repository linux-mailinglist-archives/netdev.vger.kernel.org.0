Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD7D571F90
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbiGLPiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiGLPiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:38:23 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2109.outbound.protection.outlook.com [40.107.21.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0CCC08FC;
        Tue, 12 Jul 2022 08:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJkw7Q4nLBibB54dB7gOBcHQI6a6N1nSWj6t6gYVwmnfSJUbIfV2TBAi2hNRe53J60toBiiLJOqJlgvehkxeexLZD3/9/gmu2FGyryjOh0sXYGr2mSkHz0aPyEx2qfZOz9x/U2LcPbMwOldlsEIQ1Nbq+odZUHb9tDn5YD//QXQbLRA/9K7znygJuPsHWr4XHgAnJBYpGJsTZfGU38ZUgTYPMpMNAeGc/FkZHPVoNl5vXkoYfLbyk/vCODTw6Jil5SvM8sMB5HS9+vEPGV7RAcXbkrOGSkaeRi7HsIK+q3cyUfAzIJzHhKooxnoxiqgGKBVmCmvxBM70a4SwN0vzyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Akm8k/FTr+MdnylAVaAjtPBkziV7G8pw+So6/jz8vI0=;
 b=kNbxiOPjmUXSxv6UZp/CIFHmAA00HanY1hVmSjsAFZY/RPlYhkHxYYG48/Ko25OAXZOmSdnILIznm5sE9s8U4lgT1jFseDUFz4pezvfx7P6sc+G2jwHf86TJRRUitVTyk5f6W6k+rliZWm83urAsV8gRBw8vXEUM+rPgyfFxlqcO1uxVhEpgYEKAupYU1zRigklnidcvpjXxd4QljjMeOQosBEf9R73kZgCVQ5VWaot2I1c5CLWcLYIYnrUBsMOVZbLtD9ndvTDKbRsdN7EMdHVvfv6xC+xuF9KHRus1ASFXD4Q8Ml51biEd0UiMgha63hCGAS/ngu1e3MVFid/eQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Akm8k/FTr+MdnylAVaAjtPBkziV7G8pw+So6/jz8vI0=;
 b=VTUU6ERbIT4QcmUzT7mvn/3cfzj6E9NhIvnyzKja4DfV78wmAnH/JegTxKIHPCVuKoXcC+ZOXfsa8lVkDAKb+GX2H061kj2JIdjPwK7JxCN//g7X+Ac0axUYvgxJVufGc1kXHpzsQg/ZRNE2Si+mzhjig8SNqtAy0Rz/xIxKivI=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 PR3PR03MB6619.eurprd03.prod.outlook.com (2603:10a6:102:7a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.26; Tue, 12 Jul 2022 15:38:19 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::d57a:7f6b:776b:481a]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::d57a:7f6b:776b:481a%3]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:38:19 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Thread-Topic: [PATCH 6/6] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Thread-Index: AQHYkvZ+J6KAwatI2U+kMqczZwhhVa15+MmAgADsGYA=
Date:   Tue, 12 Jul 2022 15:38:18 +0000
Message-ID: <f8f6df9c613d29058b135af0fa24554225bd23bc.camel@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
         <20220708181235.4104943-7-frank.jungclaus@esd.eu>
         <CAMZ6RqLC9a50mbyeaUSE4zqOfwPEVvOeYXcCVefC5EMD5dN6PA@mail.gmail.com>
In-Reply-To: <CAMZ6RqLC9a50mbyeaUSE4zqOfwPEVvOeYXcCVefC5EMD5dN6PA@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 759a0e80-f91f-49b5-116f-08da641c8bbc
x-ms-traffictypediagnostic: PR3PR03MB6619:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uWpk2I9aIozgTqjITgWdjzOwqORfD8ExGNaDU9lWRtH+UXJDaW9Rehm0BtHbAlHFGRhXs66YQHi++abhC77C9LFgSfPwsHfPhBIW7DNTljDABSeFzmNoQbR2qQW7pSm1Hmbcf0kLCL+ynwMY60FHZu9ldZBewE/7nIEKkPB+VddG9/q6WzmacceqGu3mkwk5OMAxYfobS7ZU/mdLTPKPOL+qNppEBZSyadbWYqXdCiNYqAODX8ozt1RUsxPYZa1toVS51LDfe6JoOmeeokQAwc3szFerKVyQNIB6fpAQwVbL2Jkag2r9MwEiqgshcZeQPDowhTWnyesiDhJSQU1unLFyOaYIsl+7/3igQ4C9D4xIdVzcvkl5SsijVim0KO3WgEkyyST/dH1OJ1p/ukPTkrAdca2MI8bAiLDrORp8LFDpDMXP5kFTensv4dP7KEXtJygk0UEdkeNlgv07XoEozeJmLDomHwedrFF1QoOT7WaPbIDh/6OW/VjPtjTPBQiOxZ2rxfnyiQf6cuyvBdQi7n2BQhgUq/IsQaGodGEAmV+VsHY8+TeSFPFueYYhQGOX42csvpFzw8EZgrcE2QZc2HSXClaMhcYn8cQk92bYPKvWkGG9x8olxqjpmSllCB+L0Hp6GHykpyDr/ics594NG4H9yWnakp84KKrx3AcXe5dAf1Lw0NCOKFBCSu/bBlVI86D622PKLGfikSGpvNxlP5fojGlWuh3Xq6OTSiP95U7UKxly0pEFdeJSakg7H1igHVJ0jJILj5Y6x2FD+mpJJPb4UHV12pcyEpZaKfQ47EG8x1yWe9LjVQ9+eZl954u80FImwa/iiNefy2YMqmVFWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(396003)(39840400004)(136003)(26005)(41300700001)(186003)(2906002)(122000001)(2616005)(6506007)(86362001)(38100700002)(6512007)(38070700005)(66476007)(316002)(66946007)(8676002)(83380400001)(54906003)(64756008)(6916009)(71200400001)(66446008)(91956017)(4326008)(36756003)(66556008)(6486002)(8936002)(15650500001)(76116006)(966005)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?XlJ9NRoCh/ObgWp87enXzDZpYsKTrNxaojXxqcQnLrwC9/eiKrv0eK2lw?=
 =?iso-8859-15?Q?I5wqxoQkUl3FkakGE71FXlwpQvmz04v0HNJeY+Ma82GKnpSepTg2K3YtF?=
 =?iso-8859-15?Q?uL6UMqCr1uBvQY9vPw51iCt6BGybSwutWEpxuYKkdViv59SUyPFn8EuPI?=
 =?iso-8859-15?Q?xUHJepqwouH6vMCSmgPAstIcMzqRdyD8PrLUJmZnch8lAVwtok2hMgdCq?=
 =?iso-8859-15?Q?0dgWgLOHqrN2jktBiNqUZpNogaW110bfz2IpORdEvGkMeFELHk6dPTDK1?=
 =?iso-8859-15?Q?eIEOBHGms3IRxIdJQ1UZMKuFY3J/Dhw7vAFv+Fm04laTn7S0D158zpcpH?=
 =?iso-8859-15?Q?Zv0a33NTc/Hr2r4Cz5AWBTjA6kHeFP0xdH6ssGyD3d4KSxN9NnteCMGof?=
 =?iso-8859-15?Q?PWYqkUBFGD5NPb49smKOgZJMGfXyfeNDYFjR6Dv2O/7psfBDTkx3gGFl1?=
 =?iso-8859-15?Q?yAgpcZ6XlWcVgoTxCPRCTu0PcsI9TFnB77padQ9XNM/3q8rjcqS2/6Gsq?=
 =?iso-8859-15?Q?Wz9qSZQdYsz/0+3q8I5OdkgEiaSE0TVnHrHcfvIUUlZGHLljJENWBIcBB?=
 =?iso-8859-15?Q?TcGCOTQGIBADT3YRlGrVoLEDx01m7LtpjfDNe8KM99Bs2gbCgigz5I4ZL?=
 =?iso-8859-15?Q?sFpES7jiEJn4seqbtMKLU3NSwVF0YMW3YX7AsgLU7WZCxsEcOnm1NGXut?=
 =?iso-8859-15?Q?DnoZ1uJ/q+gL0WufXDqeLsMHbIOBYqMBarPGDh7wmvzPrqBgxMbbNWQJU?=
 =?iso-8859-15?Q?niijNP8gY9AZZSSFretPgg64KbRcpgl7e9AehtSXFEMqHYB/IKDac1B2o?=
 =?iso-8859-15?Q?crkPeEE90Syy0yowWm5TyXnbVLu/RUQpEz2zPhZjsNZJEZmCX+PHCi4yg?=
 =?iso-8859-15?Q?pDCFX92pHFSJ4p2rt9/UCho73Gbl5TpUrFoqLHX4K3Wdf74/pC/yqzykJ?=
 =?iso-8859-15?Q?gL+vMqS+r8l0QVaPUGBDULnWHNufvmpRdKF+AdESeiz2NSjrOqLiMFWlW?=
 =?iso-8859-15?Q?AU+od1B+IhKoka2ESjZjc0d/rt8Cbe79dxWywUv/G4eY1X0vc3AXGIR9P?=
 =?iso-8859-15?Q?yerVVUeNHLib4IHr2NxJXI67N38XrWKqczrYgsdsgV5YdoaFrHHZp4aW3?=
 =?iso-8859-15?Q?FvUWmbJ84LpkFoX9eLIvI7/mlBd1AN0htXD3pUO5KU9Iu8VIQXTGVu9EU?=
 =?iso-8859-15?Q?ZTnTqz0L7JEBOx0w3V1obhrt0glHcWNPkz3EU0MqvTSl3cWoH2R5tZwr1?=
 =?iso-8859-15?Q?51N7UR14ILtTYX3N5M1vD0sAuTvQt/xH6+f/r3tDZEfvrZH996MFZ+ta9?=
 =?iso-8859-15?Q?+PrBPdXvZ1PQSDLtrhPVmDymul9yblmpbElTHv+HXBM+LkgBYZbpw1l/4?=
 =?iso-8859-15?Q?UKarTc6uioGrAZvVFgcUAm7CwkSv5qteiGn06SphrzHATTAJk6bvOJ6E4?=
 =?iso-8859-15?Q?TXvCUrvibCAHJiL9DyOOfqhmq08esu94QsUrpXsTiNYLRE+IWuBX/agQJ?=
 =?iso-8859-15?Q?EMlN3tracwVbQHCfo6tzUWWmivnEAs5TlJzG0MjD0IJ3MIjN39A0AOz0x?=
 =?iso-8859-15?Q?r6O61/pnHPFHUrxHhIYmwJdzx0IWrmzDxE+AvBz9iq0pyoLLD+lgOnOhA?=
 =?iso-8859-15?Q?Oz3x3YTSFecO7A/M19qyNLJ8ubfKa7yOeAWKepHfatG0QQLhaRfgjYHtr?=
 =?iso-8859-15?Q?2yBZ3QzOpi51tFB8Dae43fQbvg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <35C827E844FA0D4E87E6E299E3514C10@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759a0e80-f91f-49b5-116f-08da641c8bbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 15:38:19.1941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9c1nrFGFZoPPbftLsssL1+MpStwhAX63ZIyz8A9K+yN1bT3CKqVkcihqUQO09UGJY0+Hv+E889CKCWq4O3BAag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6619
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 10:33 +0900, Vincent MAILHOL wrote:
> On Sat. 9 Jul. 2022 at 03:14, Frank Jungclaus <frank.jungclaus@esd.eu> wr=
ote:
> > As suggested by Vincent I spend a union plus a struct ev_can_err_ext
>=20
> The canonical way to declare that something was suggested by someone
> else is to use the Suggested-by tag.
>=20
> Also, this particular change was suggested by Marc, not by me ;)
> https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutr=
onix.de/

Ops, sorry for mixing up your names. So the kudos goes to Marc ;)
I'll spend a Suggested-by tag and resend patch 6/6.

Best regards,
Frank

>=20
> > for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
> > simply is a rx_msg with some dedicated data).
>=20
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index 09649a45d6ff..2b149590720c 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -126,7 +126,15 @@ struct rx_msg {
> >         u8 dlc;
> >         __le32 ts;
> >         __le32 id; /* upper 3 bits contain flags */
> > -       u8 data[8];
> > +       union {
> > +               u8 data[8];
> > +               struct {
> > +                       u8 status; /* CAN Controller Status */
> > +                       u8 ecc;    /* Error Capture Register */
> > +                       u8 rec;    /* RX Error Counter */
> > +                       u8 tec;    /* TX Error Counter */
> > +               } ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
> > +       };
> >  };
> >=20
> >  struct tx_msg {
> > @@ -134,7 +142,7 @@ struct tx_msg {
> >         u8 cmd;
> >         u8 net;
> >         u8 dlc;
> > -       u32 hnd;        /* opaque handle, not used by device */
> > +       u32 hnd;   /* opaque handle, not used by device */
> >         __le32 id; /* upper 3 bits contain flags */
> >         u8 data[8];
> >  };
> > @@ -228,11 +236,11 @@ static void esd_usb_rx_event(struct esd_usb_net_p=
riv *priv,
> >         u32 id =3D le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
> >=20
> >         if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
> > -               u8 state =3D msg->msg.rx.data[0];
> > -               u8 ecc   =3D msg->msg.rx.data[1];
> > +               u8 state =3D msg->msg.rx.ev_can_err_ext.status;
> > +               u8 ecc   =3D msg->msg.rx.ev_can_err_ext.ecc;
> >=20
> > -               priv->bec.rxerr =3D msg->msg.rx.data[2];
> > -               priv->bec.txerr =3D msg->msg.rx.data[3];
> > +               priv->bec.rxerr =3D msg->msg.rx.ev_can_err_ext.rec;
> > +               priv->bec.txerr =3D msg->msg.rx.ev_can_err_ext.tec;
> >=20
> >                 netdev_dbg(priv->netdev,
> >                            "CAN_ERR_EV_EXT: dlc=3D%#02x state=3D%02x ec=
c=3D%02x rec=3D%02x tec=3D%02x\n",
>=20
> Yours sincerely,
> Vincent Mailhol
