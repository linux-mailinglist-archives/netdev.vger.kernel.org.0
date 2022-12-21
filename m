Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D366535C1
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLUSB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUSBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:01:55 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2119.outbound.protection.outlook.com [40.107.21.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AD4119;
        Wed, 21 Dec 2022 10:01:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjG6ErEN+STH5fzsUPdm40h7Ku+kKmu8J4d+sXjKMenZFNQbjTolM2JA+NzPi1EhKDfPYvb5KEtVSsvZH7v+dh4Do/L2hDFXtuhsFL0CarZ6Kfrzr89O4fxvZQVp9OdbmzqJH2wqtbXfFYEbyKdP4sv08ws8uYlgQc5/uUiXzHRwNEhqgjKwbQZJVSqit9XffNY2kuFYO5s5oLFvSXpjE8BEdvb7dtMA7ewXspVrKRj0Ygpg0Yo1f/rldzga+nzqzELQxSNqJpV7zW57l8w51vcsNmUCeB03ww5S7zuvsXk3l9fCOpKzThRcxpaLrPNIfdq6YjAmgU1vlieqol2kYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ME0g0i8kpm7IMvu3YWUHx/VYVKQuY0+xqx75nf9rdU=;
 b=aXaHTRP0trWSEndkyAvRYzKyMiODQ2m4XM6iS4RyhkZq3L0eiQfQOMKikBFc8Rp9gYr2Zdz5ztn3ZbQgzFgw+kSg4UAFUHGH+ExhVyiIdmqxomzBE9lCKTUaKZWo//+8Fhwto7c5Y04SDX8+1Wcjbjqq39dxuPqkzOPmCgrSoBtbFs1xC2yh4LiMEX1eih4IVDhKGlnIR/T58YoduL0y84OiYIf1t3VZdhjgK9EW0qDEMgcMZdeVnkXxCovV7MPQCtCquu6B9xMDZFWcqIeT3Lw6obeIhepq7SpagfMYEeNz3aYtZGr8ps6TQjZamNfLU6M/XUA2jeTtyuxYZRK68w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ME0g0i8kpm7IMvu3YWUHx/VYVKQuY0+xqx75nf9rdU=;
 b=fNsv5HqrH6C6B7ICJ/o857Z0lq0GTaENJSXmhuZkalRJZ4yo77P2oY4hPde8fGlFls8tlkdXdnyfXU+oF2Skwh95FoOuXk5NsD9wW7mflCpARh3JN6wg9jqS+Kz3TePaJZKZ/O+ZRZkBsnpxJG8XOxWTXnSm7pZ1IMaYeEW2s3c=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 DU0PR03MB9151.eurprd03.prod.outlook.com (2603:10a6:10:467::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Wed, 21 Dec 2022 18:01:50 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d%3]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 18:01:50 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Thread-Topic: [PATCH 3/3] can: esd_usb: Improved decoding for
 ESD_EV_CAN_ERROR_EXT messages
Thread-Index: AQHZE/C023IBXwmcgEW0dqi5txYJI652P5GAgAA5mwCAAiuKgA==
Date:   Wed, 21 Dec 2022 18:01:50 +0000
Message-ID: <0c585aefd4c5d4961980e41c7c4857bfafba921c.camel@esd.eu>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
         <20221219212717.1298282-2-frank.jungclaus@esd.eu>
         <CAMZ6RqKMSGpxBbgfD6Q4DB9V0EWmzXknUW6btWudtjDu=uF4iQ@mail.gmail.com>
         <CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com>
In-Reply-To: <CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjhRBsP=12QYpfA@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|DU0PR03MB9151:EE_
x-ms-office365-filtering-correlation-id: 80087a40-38d7-432a-a0a9-08dae37d6f5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W2fl8lXZhDm1IfY0QNIwoXHg5j00RegXpQ4TDLsfrXvVQACeI81q8ZKbadjkbDxowfApAzPxShrYcIPxPO2ux9Y0DzmTIUVOisz1aCV8leQ2RSCL0wIM+ynavS1zN4aiJSlZOpKe09ZrEEHeunXKagt+beDH+gx+33MUgz8qwHF8Z8cM5ItswdI1qVzjFK2uIhKTeppWl8XDhEtjZwuNIs+AdiMGBdPfVWunPX0E47OGnanOFT1Y42oFM27QB4H2FCEOGJSZHZQAIE8EMphZgxCIS8i+x9wb9Ps6g2MSUXF6LDWrbMfl1rrDsIIfiY59QL9WCUYpM3tjoZUYKc2DNbRfjIRUcdBbd2aqfitECkJEIVdt+YtefGSPNQsWtpcp0j938qdCFEQely6SFp3/tRDpNgVGbxUY/uifvYf5rY+F8SMG/kHy+s1LQN0KNCu+IvC4JuUS1EPBMizN5DiTBzEy2HMlZTylngLPP73FGkXqnALlDxJ3pQ1t8XO8kKx/ZtVj2Z8uLIwtF2hPdqCaeke0fShopEnw0ZpaGN7dx7Ow4VMdi1/dFXMlGmHFSURei/5CFdnwt0Ig3LRsuBwuFkWmmy/2IttWhRyd8O+BJhpej3F5s/ehvZg3kPwU2STG1gF39nRQhVDti2QLiy+bltr8GrFZT9mDxKlQP69ZbXgoGH50elWg3XCkX/KAYHf5gnXzOptd4hPVFgKuQD/eRGCojWZG3ap5ysAJjHUVxX0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39840400004)(136003)(376002)(346002)(451199015)(6512007)(6506007)(41300700001)(26005)(186003)(2906002)(38100700002)(478600001)(15650500001)(6486002)(66556008)(966005)(66946007)(8676002)(64756008)(122000001)(86362001)(66446008)(4326008)(316002)(36756003)(2616005)(91956017)(66476007)(4001150100001)(76116006)(38070700005)(54906003)(71200400001)(6916009)(83380400001)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?CGSSkhW28mtZRH1g4zMIg2ve1R6IQvPMCe9sOqIwC7CLCkL4plj+DWYUW?=
 =?iso-8859-15?Q?upebOy4rP56Rtufj51aQSFo51dmX8dCyAuxG0TUZRYGuFGYSyXNCC1N3W?=
 =?iso-8859-15?Q?S1tyNhVoSwwucDodiZrKr+dDfY13mYlMjsXEk5tcwN6tf3//D1KyQQRJT?=
 =?iso-8859-15?Q?rJ7FvnnOux/HLACnLRzxaYzN0a5+cb8N/n5nfMb+q7+GdlW40R9hHoQri?=
 =?iso-8859-15?Q?KittY+BS6Cr1V5mnxKBs5dpxV7EIuhx4TIikn4eb0q3MT8VffoJjHGSJN?=
 =?iso-8859-15?Q?D2Tt5Hj2U7s1Z0w1zFBh50qwKJR/U9tsrZwvVLhQYD7IOfayEE4mcEEMs?=
 =?iso-8859-15?Q?7ewHKs4HZwzCdQCbyDae1Gog55VClVCRPJMKUcFTliZaehTLAuPyz6W+d?=
 =?iso-8859-15?Q?heQU+DWTI34t3i+1KwoESMmCFTyeoo3TpibSOg718cZMl18qBXE7PM53l?=
 =?iso-8859-15?Q?98BCeTz2VXHAuaBYDEUe7iGpZI2RwUaRbMRDRS9S32NWDULEbp/qNZGL9?=
 =?iso-8859-15?Q?DZeubaD6m5z1FVD+Lv4Ag2JccMDmMl2qa2T5Ec1GiSYVUNcEhRs7kwFF2?=
 =?iso-8859-15?Q?ODdo3Qv1crThcBDi35BqkF6heSomp17Tp36eq6HDgx+rBw/Q5+uzxIM5r?=
 =?iso-8859-15?Q?WHhSG/h1BqWCOxBXQ+ptD8IqYeZWk2AIB8i4s5J9VD/4tomEApJv0Qwwo?=
 =?iso-8859-15?Q?ISJocUm79pJ0HYPwWHw0l5OkSRYT8FE4RZuxROFDVMVq3i0Urn5GUsWzY?=
 =?iso-8859-15?Q?Tr62HdV3X1tpRBXJdXqcj6UGhx9LjonDPc5H7tjepnXl0Hcj+lxxqxOE0?=
 =?iso-8859-15?Q?F8PPD3PR3y+y6z66bYuYtSD+3BkFidD8WA96qOcYHdBuvvh8EgDsS/x0Q?=
 =?iso-8859-15?Q?kCpYsIRNy2gU29uMfB/C0XWnJ/MMzQBXNEzF1waHwm/X8mykAnTQwiAYz?=
 =?iso-8859-15?Q?8XNeXEwdL6IKeIQhBTNHAMmLN7sWHZ7gHuYnPGk7JT1ubE3FfjizKc0QE?=
 =?iso-8859-15?Q?vWeAJjrYpFlpvUBglHIGLMn4UVZJsZqYP6c4QlvbBZilrfEHWxUwVGkrz?=
 =?iso-8859-15?Q?WIVHxAVe2WNaWCmK7DuER55jpZi3VeQkWXRoMKKFiGNJrHHD+/BzgRr8i?=
 =?iso-8859-15?Q?LJBJ1bEugteJyyMWFlP5PRitp9OYcZ8Z1Osr1LWiapQ5O9p0wH6nPHYB5?=
 =?iso-8859-15?Q?dV75+B9sRKj/bWFIIO9PKu0+RiKEmlX9wC0vd39TToEt//02UZU+wvSuj?=
 =?iso-8859-15?Q?85LP2IF9eBgLeus0Dl5Da+FcX6QTpKgDqdHK3qVNmvDRvEzowQtIwje06?=
 =?iso-8859-15?Q?KYEuUl/+f1TR16Z8mOe8yQy4AKc8y8rUORs53ZlZNwchf6zgMKDCTV+Qa?=
 =?iso-8859-15?Q?Q68+yI5UCto8Tsyf0xeT+kI1mT2IAVxtyM5bUf5ZZtQsAWXLyDrSJ7FQf?=
 =?iso-8859-15?Q?UYP3mjBGVSfKOhRn4aQk8wg1i1yFRnflAJiD4/Ffy3jrXhJx+2SaWjogX?=
 =?iso-8859-15?Q?2DLbYlxFjrrOm4p65zV6JIBPojO/tyyPFCjpW1A38hSwoM2eV0avKn71E?=
 =?iso-8859-15?Q?n9RWsvLY5Bu75OBOlSVWjvRP0DKe5r8Su5e6tfYascdBfh9at2IXZ8xQc?=
 =?iso-8859-15?Q?qti4zXEzFVqu5aB6bl3X1Qckei8AOwEbq7TcrNE7mCb8cJ94enM57sLSV?=
 =?iso-8859-15?Q?82DHM0V2HCyaQlNAihsHv0qgng=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <B4BD59D45D8692458987CA501B265103@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80087a40-38d7-432a-a0a9-08dae37d6f5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 18:01:50.5144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5asbMBuT6U+0i2zr1M5/Sb7cKIVjZRGOgxEnf5Ga6/TtRfp8XdB55mVPVV4iwfelmjMQOD9UxDC9e5tGdZS0Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9151
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-12-20 at 17:53 +0900, Vincent MAILHOL wrote:
> On Tue. 20 Dec. 2022 at 14:27, Vincent MAILHOL
> <mailhol.vincent@wanadoo.fr> wrote:
> > Le mar. 20 d=E9c. 2022 =E0 06:28, Frank Jungclaus <frank.jungclaus@esd.=
eu> a =E9crit :
> > > As suggested by Marc there now is a union plus a struct ev_can_err_ex=
t
> > > for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
> > > simply is a rx_msg with some dedicated data).
> > >=20
> > > Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > > Link: https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpk=
px@pengutronix.de/
> > > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > > ---
> > >  drivers/net/can/usb/esd_usb.c | 18 +++++++++++++-----
> > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_=
usb.c
> > > index 09745751f168..f90bb2c0ba15 100644
> > > --- a/drivers/net/can/usb/esd_usb.c
> > > +++ b/drivers/net/can/usb/esd_usb.c
> > > @@ -127,7 +127,15 @@ struct rx_msg {
> > >         u8 dlc;
> > >         __le32 ts;
> > >         __le32 id; /* upper 3 bits contain flags */
> > > -       u8 data[8];
> > > +       union {
> > > +               u8 data[8];
> > > +               struct {
> > > +                       u8 status; /* CAN Controller Status */
> > > +                       u8 ecc;    /* Error Capture Register */
> > > +                       u8 rec;    /* RX Error Counter */
> > > +                       u8 tec;    /* TX Error Counter */
> > > +               } ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
> > > +       };
> > >  };
> > >=20
> > >  struct tx_msg {
> > > @@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_net=
_priv *priv,
> > >         u32 id =3D le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
> > >=20
> > >         if (id =3D=3D ESD_EV_CAN_ERROR_EXT) {
> > > -               u8 state =3D msg->msg.rx.data[0];
> > > -               u8 ecc =3D msg->msg.rx.data[1];
> > > -               u8 rxerr =3D msg->msg.rx.data[2];
> > > -               u8 txerr =3D msg->msg.rx.data[3];
> > > +               u8 state =3D msg->msg.rx.ev_can_err_ext.status;
> > > +               u8 ecc =3D msg->msg.rx.ev_can_err_ext.ecc;
> > > +               u8 rxerr =3D msg->msg.rx.ev_can_err_ext.rec;
> > > +               u8 txerr =3D msg->msg.rx.ev_can_err_ext.tec;
> >=20
> > I do not like how you have to write msg->msg.rx.something. I think it
> > would be better to make the union within struct esd_usb_msg anonymous:
> >=20
> >   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/usb/es=
d_usb.c#L169
>=20
> Or maybe just declare esd_usb_msg as an union instead of a struct:
>=20
>   union esd_usb_msg {
>           struct header_msg hdr;
>           struct version_msg version;
>           struct version_reply_msg version_reply;
>           struct rx_msg rx;
>           struct tx_msg tx;
>           struct tx_done_msg txdone;
>           struct set_baudrate_msg setbaud;
>           struct id_filter_msg filter;
>   };

Apart from the fact that this change would probably require several
dozen lines of code to be adjusted, I like the idea ;)
