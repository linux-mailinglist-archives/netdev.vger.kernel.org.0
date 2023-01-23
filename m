Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72005678054
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjAWPrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjAWPra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:47:30 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2138.outbound.protection.outlook.com [40.107.7.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7B74EEF;
        Mon, 23 Jan 2023 07:47:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWPx5NilOaiSEhQxMpsEoKbZvzxe4mW6HONQvorU4jVid4mJZ6owJH+OjyPGSFmw223+tG2QEK3UKHYhcgJhkPbQUYCs6EtZmnKdC9Z+kVXZ7ffV0zW/DNwqIlnny48fnckFELFvCK9lGUDZQOLbJQSGxp1PfE1fDJvv6y0RWNpwbWrSjKYU7ZxmjDoLqlkKNgf7rfi53/Y0dc0upqBUv6RHj4MnB3ZKm+4g4A8+7jdRL9qefJoEimGinLXbgYHBphDKRIvx5jh2Ysh2VWKTh4PZK8KvSA/WtMjaHqPh8H/sHxt0DtLKTq3EfuX2B7WoV7vtwOl8sQb+UIjkW+gEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6NgBuvsSzBT/JttAFKC8x08IXVWK5AJEJRSxPOlVLw=;
 b=oZlXeydgSewqfadc404/fwtNIOW3Zxmp9evBtvVZRnPo4NrVci+YGtPbZlHbpaog1M46omNB3D5RaTQ1ge5ZqPEpnLJGc11TsZndSLsUkalfw54i4IwxKFccmkLrWwiFhOTrbMYxx2GlGfi/cir5SD4EdJGh9sKxJYnUHsVLgKcKsHV65idqosPa3M5S+/f9e8NUzbmJVKgJs9fnkDoeETFP+VY+PP/oB17CELH5F2Nv6j+W/ov7GF684Dt3gf6yIp/gUfpros9YmtQCGEfwyjeJkrrU/in6Y4HcYFYkUIAqW4aglpecwudZjY9faVjGCS0kPKnI1/zYMU8cBmTjoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6NgBuvsSzBT/JttAFKC8x08IXVWK5AJEJRSxPOlVLw=;
 b=fPrWBlUu4evb+Gq9ntTmIvUsjInzujp2cdwm2RLkTgge4L5DBHU0g1M3iym4RrA6+BE9Wd5T1lNUzFa46uvvqf3nQUoPWWzIFnv2u0zMK3enKPQKRqIM74F1TBsuFRj5Ua7wO1TYyCeudidkAfS6jezjNNMvSSRThzLnPHdiiK8=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 GV1PR03MB8814.eurprd03.prod.outlook.com (2603:10a6:150:a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Mon, 23 Jan 2023 15:47:23 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::acef:56e7:b5cf:317d%3]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 15:47:22 +0000
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
Thread-Index: AQHZE/C1wQWkeZ5g50Kutho7W0eaTK52RcWAgAJmpACAAIPzAIAzK7iA
Date:   Mon, 23 Jan 2023 15:47:22 +0000
Message-ID: <786db8fae65a2ed415b5dd0c3001b4dfc8c7112b.camel@esd.eu>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
         <CAMZ6RqKAmrgQUKLehUZx+hiSk3jD+o44uGtzrRFk+RBk8Bt81A@mail.gmail.com>
         <a1d253bacdf296947a45fb069a0fd64eabb7e117.camel@esd.eu>
         <CAMZ6RqLeHNzZyKdCmqXDDtd5GZC8KZ0Y1hESYyPaaMbFe=ryYQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqLeHNzZyKdCmqXDDtd5GZC8KZ0Y1hESYyPaaMbFe=ryYQ@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GVXPR03MB8426:EE_|GV1PR03MB8814:EE_
x-ms-office365-filtering-correlation-id: 40df591a-c2f3-4cb9-5f0d-08dafd591e4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 68qym4weGdXe45ogo7PvnP5tjt4oiRlgfl1K5NIC/CIY+LGTiRJb2EFF7E6x13yD9df39eXy3zrkLV6dMT/niyrx49bXaCeDO91T0vC1QNewSY2p/poiQfBm4dr9oQAffLWH+UqQpdiAnMeY/GpB0HAcXOJ2+yt2s4Yi8tVfg/3I+FXy1UyOcHpwU61qtfUbU5kFMvrRmhKg9sGlUK6MNhKj4ZxsO3TF6mQOsalCTthr+Q/j3kKI9KMvLvDHoGoNC1ECKLywZCMLYfzdXk2IDvRrbTZ6SonVnsm796bMwD4LY28WI/COBjDTMlSK7fG4He6R22tPMxhBrzchmNVymZnIM3rQcnRXeSvTbTGW8TFxkUhfsLb2GPaDOzbPAsmMlATqxSal5EMeoAkSCVLSH+/Eqd8xtHVV4i8hNIvWai3h1mI5agOrRoEEBGmG6TxUPg/uyvT+94Vsr5dEPtY3DY3Mtz1uZ5UcOYaXypW1/stxk4OaIt4qd5U5zH/84yj/mV/gFCOPcvMtu4WWkGeQAig1soXO6ZpACeuOrFaowS/7bflfzmeYutzNmWT+C20U+a55lrJE0JMvwlh9XS2yOd9ej+w0G+5YZis+wwD3agskUqVKKQBD6QP6Xm4sWYQUIYrksWTe80hp4cDrr8fhMgIOJniRqZs9emA0PEFcmLBtughrhZvwstfVuEU2iU9mEoh3OvCM6mK0EORzgZCvLX1etK9VzERpS0NKRXs/5mE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(451199015)(83380400001)(38100700002)(122000001)(38070700005)(41300700001)(86362001)(4001150100001)(2906002)(8936002)(5660300002)(4326008)(26005)(8676002)(6916009)(186003)(6512007)(6506007)(66556008)(66476007)(316002)(76116006)(54906003)(64756008)(2616005)(66446008)(66946007)(478600001)(91956017)(966005)(6486002)(71200400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Ft9CwtxTLKaVdFYkDOwsCDIylCChbVrGs6eQEKymMkQqxRBVhwgT/tZaG?=
 =?iso-8859-15?Q?/5hmiwaNPg53yfCrf83YiGbdTP51L6vPQC3WGRZ/BMyAGssFs2hQL06Hv?=
 =?iso-8859-15?Q?TY0jHpGbFScsI4O8lwkik4RTYj8Ei+6wnJ4+/6weuvMbpYmGsZTjYskNG?=
 =?iso-8859-15?Q?x3cmE98hydRAMGFCudGhWj5jZonJ9jIUrpWiTjf+HNTYNEaBEJtqCOaj3?=
 =?iso-8859-15?Q?w3GhfZtKSYyIMjXS5gXnKDLIYUpL6u0APqWzwl7pY1bh3CPQf4DDyKAdd?=
 =?iso-8859-15?Q?9CIfjKnSZZcjj4xqzLrdj0+Faskkmh1ZTNiBQvwb4PiL3upNlqF7L/56e?=
 =?iso-8859-15?Q?tGPWvYI89KbHlCgJfvgR6YtYndTBhBNdhDEU0/v1dlRlfUu0zD/2kv2gr?=
 =?iso-8859-15?Q?5NWGItB5JUcqQ8kRpXgpGrJHKtKsOmfilXYFLvaRR1LlTI/jnFQlbp7mm?=
 =?iso-8859-15?Q?shZmzmci+D9TJHAvCwr1oq+Rb0DSbcfdytRiXyBB15hn6k/bbQWJoKTUH?=
 =?iso-8859-15?Q?kwwc1v+6v4Y2sfUcjef/xcHLGPgmzk44UqaTUC596eZhxrrYWCMTuFarA?=
 =?iso-8859-15?Q?yQblWRsGjk13rJXVLZ2exD7PlDkkSLxWUAi3d/YYeF5zSqKWYUApAsdn9?=
 =?iso-8859-15?Q?2qTRyIrPZsgpI/MqchReAyTrHUHV6ruGDPXh2k2P5J1u+u8PAYu7Q4mY2?=
 =?iso-8859-15?Q?8xtEs3vXDWoMtW/n0kEdbVRtaOYeR6BwJWKI3TRqaPOxMj6y+uu4dUA+b?=
 =?iso-8859-15?Q?ZYM8u5kjBrwksRxKO5L5AekVKT3qW1IM8PIjqBGxf2fb02DBTtQwW4nP0?=
 =?iso-8859-15?Q?y7neutpqXcId0poUrnHh826+ZXPL/o7VXJ/z0Zb96zEGvZqrK8LtLRCow?=
 =?iso-8859-15?Q?BlHvzRCDM51qVrouJoggREmLIy2F8vjoIipHYqwb7Nr4tUo3cu5++pP3K?=
 =?iso-8859-15?Q?sNHCZisDv5M1xMlWf2IP1gdDwnMh8A1IAqrPkz+ZEgq1iuu5+uNqa5PRH?=
 =?iso-8859-15?Q?7t5wXfvBnV+Ba4Qx9kj2t6N15Y/jQweVM1UbeOUW7p+hdYvT4nOwBCfxK?=
 =?iso-8859-15?Q?BWp3Y58s7KKf+nDXh6tKMUxvNK8GhJ3sBiWAC75XWUfEOWC5wID0EF5T7?=
 =?iso-8859-15?Q?7KxFwQyDw/oa9VV3yy5PgWM5tOuQ9djcdsb6LbCXA0IjldQ0nTLeQSKGf?=
 =?iso-8859-15?Q?8UdBMz2qx4l8nM0AwmEsatuwYsLjHnBo4vHQWl3yV+oiZU0FT6MZ30s99?=
 =?iso-8859-15?Q?wJ+nrKMW/CUZ/b6D5sBcJrhoMp1CSUV94alk3Nc4aZGX6pu905pM/zxVB?=
 =?iso-8859-15?Q?MpZXvxqzaNYo0QXWF+Pf6kK6UjYToRiUnUNyI0SIm4LNWegGqizyyMtBd?=
 =?iso-8859-15?Q?+3KMiTwCF4TnZGlorWGmS/I+rIFZkNhHoS+hf/beTgO5Z1diH4vk8jqWP?=
 =?iso-8859-15?Q?QQKqADcDXgrzFPn563JEWRE+4Ht8crXT6lhKJxZA6aK24JWSNT2DUSIWK?=
 =?iso-8859-15?Q?4wWgJHQPJAH++6i/yYCfA+if02smWBGItELfu/2LehxrfbYSjK9OUpQoJ?=
 =?iso-8859-15?Q?RHZTQSRNMjC+DKg3JS2cf5To6AlGhxguq6hlXfA57QwfxYwgml8wrTP/v?=
 =?iso-8859-15?Q?aak3XArPa8OG3iUwvFF8EmJPPtUeBFnpZolvUk1iFAB83Jm86nwShM2Te?=
 =?iso-8859-15?Q?Wm3SDEMHMOgwnBSR71UWutHe+g=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <3ECE6E63C956C7418A4C93F61B3461F5@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40df591a-c2f3-4cb9-5f0d-08dafd591e4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 15:47:22.8116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DgVWi4nWz2qf/8BJZPGcPBHESWq3EHkvrxdy11Pyu8Y+L7JTNf3R/OVWomqdxJflL4AuT3vfTAWMswtuZkX/vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8814
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-12-22 at 11:21 +0900, Vincent MAILHOL wrote:
> On Thu. 22 Dec. 2022 at 03:42, Frank Jungclaus <Frank.Jungclaus@esd.eu> w=
rote:
> > On Tue, 2022-12-20 at 14:49 +0900, Vincent MAILHOL wrote:
> > > On Tue. 20 Dec. 2022 at 06:29, Frank Jungclaus <frank.jungclaus@esd.e=
u> wrote:
> > > > Started a rework initiated by Vincents remarks "You should not repo=
rt
> > > > the greatest of txerr and rxerr but the one which actually increase=
d."
> > > > [1]
> > >=20
> > > I do not see this comment being addressed. You are still assigning th=
e
> > > flags depending on the highest value, not the one which actually
> > > changed.
> >=20
> >=20
> > Yes, I'm assigning depending on the highest value, but from my point of
> > view doing so is analogue to what is done by can_change_state().
>=20
> On the surface, it may look similar. But if you look into details,
> can_change_state() is only called when there is a change on enum
> can_state. enum can_state is the global state and does not
> differentiate the RX and TX.
>=20
> I will give an example. Imagine that:
>=20
>   - txerr is 128 (ERROR_PASSIVE)
>   - rxerr is 95 (ERROR_ACTIVE)
>=20
> Imagine that rxerr then increases to 96. If you call
> can_change_state() under this condition, the old state:
> can_priv->state is still equal to the new one: max(tx_state, rx_state)
> and you would get the oops message:
>=20
>   https://elixir.bootlin.com/linux/latest/source/drivers/net/can/dev/dev.=
c#L100
>=20
> So can_change_state() is indeed correct because it excludes the case
> when the smallest err counter changed.
>=20
> > And
> > it should be fine, because e.g. my "case ESD_BUSSTATE_WARN:" is reached
> > exactly once while the transition from ERROR_ACTIVE to
> > ERROR_WARN. Than one of rec or tec is responsible for this
> > transition.
> > There is no second pass for "case ESD_BUSSTATE_WARN:"
> > when e.g. rec is already on WARN (or above) and now tec also reaches
> > WARN.
> > Man, this is even difficult to explain in German language ;)
>=20
> OK. This is new information. I agree that it should work. But I am
> still puzzled because the code doesn't make this limitation apparent.
>=20
> Also, as long as you have the rxerr and txerr value, you should still
> be able to set the correct flag by comparing the err counters instead
> of relying on your device events.
>=20

I agree, this would be an option. But I dislike the fact that then
- beside the USB firmware - there is a second instance which decides on
the bus state. I'll send a reworked patch which makes use of
can_change_state(). Hopefully that will address your concerns ;)=A0
This also will fix the imperfection, that our current code e.g. does
an error_warning++ when going back in direction of ERROR_ACTIVE ...

> I am thinking of something like this:
>=20
>=20
>   enum can_state can_get_state_from_err_cnt(u16 berr_counter)
>   {
>           if (berr_counter >=3D CAN_BUS_OFF_THRESHOLD)
>                   return CAN_STATE_BUS_OFF;
>=20
>           if (berr_counter >=3D CAN_ERROR_PASSIVE_THRESHOLD)
>                   return CAN_STATE_ERROR_PASSIVE;
>=20
>           if (berr_counter >=3D CAN_ERROR_WARNING_THRESHOLD)
>                   return CAN_STATE_ERROR_WARNING;
>=20
>           return CAN_STATE_ERROR_ACTIVE;
>   }
>   EXPORT_SYMBOL_GPL(can_get_state_from_err_cnt);
>=20
>   void can_frame_set_error_status(struct net_device *dev, struct can_fram=
e *cf,
>                                   struct can_berr_counter *old_ctr,
>                                   struct can_berr_counter *new_ctr)
>   {
>           enum can_state old_state, new_state;
>=20
>           /* TX err cnt */
>           old_state =3D can_get_state_from_err_cnt(old_ctr->txerr);
>           new_state =3D can_get_state_from_err_cnt(new_ctr->txerr);
>           if (old_state !=3D new_state)
>                   cf->data[1] |=3D can_tx_state_to_frame(dev, new_state);
>=20
>           /* RX err cnt */
>           old_state =3D can_get_state_from_err_cnt(old_ctr->rxerr);
>           new_state =3D can_get_state_from_err_cnt(new_ctr->rxerr);
>           if (old_state !=3D new_state)
>                   cf->data[1] |=3D can_rx_state_to_frame(dev, new_state);
>   }
>   EXPORT_SYMBOL_GPL(can_set_error_status);
>=20
>=20
> If this looks good to you, I can put this in a patch (N.B. code not
> tested! But should be enough for you to get the idea).
>=20
> > >=20
> > > > and "As far as I understand, those flags should be set only when
> > > > the threshold is *reached*" [2] .
> > > >=20
> > > > Now setting the flags for CAN_ERR_CRTL_[RT]X_WARNING and
> > > > CAN_ERR_CRTL_[RT]X_PASSIVE regarding REC and TEC, when the
> > > > appropriate threshold is reached.
> > > >=20
> > > > Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
> > > > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > > > Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg9=
9GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
> > > > Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-Rz=
ZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
> > > > ---
> > > >  drivers/net/can/usb/esd_usb.c | 14 ++++++++------
> > > >  1 file changed, 8 insertions(+), 6 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/es=
d_usb.c
> > > > index 5e182fadd875..09745751f168 100644
> > > > --- a/drivers/net/can/usb/esd_usb.c
> > > > +++ b/drivers/net/can/usb/esd_usb.c
> > > > @@ -255,10 +255,18 @@ static void esd_usb_rx_event(struct esd_usb_n=
et_priv *priv,
> > > >                                 can_bus_off(priv->netdev);
> > > >                                 break;
> > > >                         case ESD_BUSSTATE_WARN:
> > > > +                               cf->can_id |=3D CAN_ERR_CRTL;
> > > > +                               cf->data[1] =3D (txerr > rxerr) ?
> > > > +                                               CAN_ERR_CRTL_TX_WAR=
NING :
> > > > +                                               CAN_ERR_CRTL_RX_WAR=
NING;
> > >=20
> > > Nitpick: when a ternary operator is too long to fit on one line,
> > > prefer an if/else.
> >=20
> > AFAIR line length up to 120 chars is tolerated nowadays. So putting
> > this on a single line might also be an option!(?)
> > How will this be handled in the CAN sub tree?
>=20
> Correct. The 120 is tolerated but the recommendation remains the 80
> characters. I am not supportive of squeezing things and making this a
> ~120 characters line.
>=20
> Also, this is a nitpick. I will not fight for you to change it. Just
> be aware that there are often comments on the mailing list asking not
> to use ternary operators (and I will not do an archivist job to find
> such messages).
>=20
> > >=20
> > > >                                 priv->can.state =3D CAN_STATE_ERROR=
_WARNING;
> > > >                                 priv->can.can_stats.error_warning++=
;
> > > >                                 break;
> > > >                         case ESD_BUSSTATE_ERRPASSIVE:
> > > > +                               cf->can_id |=3D CAN_ERR_CRTL;
> > > > +                               cf->data[1] =3D (txerr > rxerr) ?
> > > > +                                               CAN_ERR_CRTL_TX_PAS=
SIVE :
> > > > +                                               CAN_ERR_CRTL_RX_PAS=
SIVE;
> > >=20
> > > Same.
> > >=20
> > > >                                 priv->can.state =3D CAN_STATE_ERROR=
_PASSIVE;
> > > >                                 priv->can.can_stats.error_passive++=
;
> > > >                                 break;
> > > > @@ -296,12 +304,6 @@ static void esd_usb_rx_event(struct esd_usb_ne=
t_priv *priv,
> > > >                         /* Bit stream position in CAN frame as the =
error was detected */
> > > >                         cf->data[3] =3D ecc & SJA1000_ECC_SEG;
> > > >=20
> > > > -                       if (priv->can.state =3D=3D CAN_STATE_ERROR_=
WARNING ||
> > > > -                           priv->can.state =3D=3D CAN_STATE_ERROR_=
PASSIVE) {
> > > > -                               cf->data[1] =3D (txerr > rxerr) ?
> > > > -                                       CAN_ERR_CRTL_TX_PASSIVE :
> > > > -                                       CAN_ERR_CRTL_RX_PASSIVE;
> > > > -                       }
> > > >                         cf->data[6] =3D txerr;
> > > >                         cf->data[7] =3D rxerr;
> > > >                 }
> > >=20
> > > Yours sincerely,
> > > Vincent Mailhol

