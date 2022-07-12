Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70F257205B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiGLQI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiGLQIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:08:23 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150138.outbound.protection.outlook.com [40.107.15.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCA5C84C5;
        Tue, 12 Jul 2022 09:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJQT6CiACq53SeL3IraEXcjFTZ3u9xt5Dj0dNCte6znUPdjpJkJZ6uoAPbf38goHbyeBi3Uw5NBsQSId4WHh0Rom9cwjbbTsjf0P9Ut6Z4LhIaATsroM/V1TLSXYupMv+wV6aReUsTpxE6H6kSqFqJZJIHJ0B5mFPMNscWs9HMLg72CyQ/ACjwgJhDLFTLM5+6s6Ik7bWEPaq9WKY4/swgKktoZk2JqdmPct/Kss67cLFyM6RXdN+e47ssMyyML+8ds/wFq238w7f1WT6VuxoXypMsa1Z5qAcODgp0C1iDo0UzwwobF3Gc8Sb/k325QQgVhs1Q3KQUpBiGBYK+XA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6NabXQN/2kH9MlOpr6/iJDks2zW2WFmSGRoPbzFzjFk=;
 b=GOA+rnAYJ9JeWzfxIgf8GTdAYK6aY2oF+yGbHuZWo/U2e20okIWjDHRjr2fwyOXj/jCAWIup/iLQfXyT72gYAxJzRBr97OzsiUQDbGtg7B4w7G2QvkQ4o3OW5uGol93X74LpvDjFUM5AY9U5ela/VMKk4+ktJIKai18y/t+x32dUqUx17p+C9ywlx72JFAPHIGmeXBQNodeKJiSmYARwh6H16a+++8OVkCH/YE6PDNXlFJHA+AkeGJ64BnRWOLXJv6S4ZoBG+GLefn5c7GAo7u6bnGHKGY6xcUrpp1jc0tXHw+h0l4dKcDfDc7Jh5Qn7X+O6h8Fm6xcQM1G1JTT4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NabXQN/2kH9MlOpr6/iJDks2zW2WFmSGRoPbzFzjFk=;
 b=B8yN+qPwd02OulGe7vgvv7hdaeGNA+9RwBv52a7bKrk7eafadVEcEtFVyG30ijttR72H3ober3JRG8nDjtZASCOoq9dMJuarXE+wjUGgu1E3+7pKkbXBLA+K5lB8qO5tUNVvwB8tcO0PL7JkOfTAgyPijAPqnO39stmu+Tv9JAU=
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com (2603:10a6:150:4::9) by
 DB9PR03MB7466.eurprd03.prod.outlook.com (2603:10a6:10:229::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.26; Tue, 12 Jul 2022 16:08:16 +0000
Received: from GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::d57a:7f6b:776b:481a]) by GVXPR03MB8426.eurprd03.prod.outlook.com
 ([fe80::d57a:7f6b:776b:481a%3]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 16:08:16 +0000
From:   Frank Jungclaus <Frank.Jungclaus@esd.eu>
To:     "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
CC:     =?iso-8859-15?Q?Stefan_M=E4tje?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (3)
Thread-Topic: [PATCH 4/6] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT
 event (3)
Thread-Index: AQHYkvZ8KbGCPl11OkK12FCtHi0K+q161HMAgAAYz4A=
Date:   Tue, 12 Jul 2022 16:08:16 +0000
Message-ID: <ec95c96b761df49ae19ff333aad9857c5ec498e0.camel@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
         <20220708181235.4104943-5-frank.jungclaus@esd.eu>
         <CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com>
Accept-Language: en-001, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5585e240-abcb-45dd-eed8-08da6420bb24
x-ms-traffictypediagnostic: DB9PR03MB7466:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XK97+xeONXoiVG38N7uuBWmwmbLa3FE2MQCHYfW8cDjxiDpyMb2V8NPRxhnhuVp3Hj8YDTB0ETKORiKkP6ana7SHbjBUTdZ9uW/b6Wq8DDotrMmWI7AN9nJTwv1RJN0gQA4VxQlNWuRXcmoXKj3wDUr1QnlYkgvMif8hpbqAGPDFDVjhPyEzaCnG2NCZBl70ZD01AydPhbxNYgZWbeR0E+XUvF1Rm2uoY3BsjwJQ0+qmgG5wnbrX1w8YmWtO7NT6ZS37EloD4YIE3Ns0+sI26Nstyu+Mm4NAgwJ8rOT192NuRXutM4058LaWbxT+uT5LOfaE0bh1/iW5riG2zMtYMS5+n6nszO6ivcSO3bVZ4das7JD+okrgt4N8c12I+keo2qPoLbRqczPTNcp3jdyqSi6aba0lgTlgiL4YorrjQQx43UVgMmrsqIfpcpzwpNKd2XNxmcLXgFSZRg2fpggLtU7d1wryZrmjToo3mDD8R3Cbw2Bjm8C3WJUIpoYxNJX1sbozFzn5Iq6Zks+6A1+D3UzZflKP0hUv/72GVmbU8YqOr+89dPFUr/8Z6NbeXL1Qf9dVPALaDleTC6tQ6rDPl5GG9kcDuUv6Bb8AOhj/QSCz7yHApSG547naOz50LpRl8Xk4/BhldsdRt1gct0tSFDM9X77vIyZEsp7UrLmwukc4vghNPj3xXXAVrfCf4N/h6byVOhwLXGECuv0XpVI2KFDWsDBRUfBP+C7Addr6PxBr6kLKjjSErgAUQona1npvMaJDV8UmVTV58fqJj3N6TF73OhtcDztBKOKVK3iMc2PBohgWQzaGHIhSYWEFLe/I3JZVWGIo1bRhCCMQwccQgYl5ZIU3svgfIHRnwTCd2EA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR03MB8426.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(376002)(366004)(346002)(396003)(136003)(66476007)(91956017)(186003)(64756008)(8676002)(86362001)(66446008)(76116006)(38100700002)(66556008)(4326008)(2906002)(66946007)(2616005)(8936002)(83380400001)(122000001)(41300700001)(6916009)(5660300002)(54906003)(38070700005)(316002)(26005)(36756003)(6486002)(478600001)(966005)(6512007)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?UrF+KVzUT1655OsS/vPutfhjmM6+zxYnlZXJjtSHhIy+P/NtX+DHNWrTT?=
 =?iso-8859-15?Q?GeZarq1w3NwKHxR6AcmUgCSVQOkJn+yaqjT1UFF4KdwBKMG6InoltrTcP?=
 =?iso-8859-15?Q?kBvL5OqJOi80GJHl4CYBVfKhh1DwVJt0aB/sbwZTq140QT7sWpDussjvo?=
 =?iso-8859-15?Q?2x6ZyKGOk9sj4k4dQ9S7f65P/ZOe8wN565lk58aWvP6apFRPT9pQboHug?=
 =?iso-8859-15?Q?VOhjE4wzi+Hx7Pyr3omfHxbjOwQBhZJmmIyr3mEl6lpKcvpLrrUfQe3yq?=
 =?iso-8859-15?Q?66nOcxZQWpash05ZvIHqX9LwcD0huilCqBlfa8SC57ermf5JN0KxSrgUg?=
 =?iso-8859-15?Q?oxi+8eZpUPlEG4QQb4mKjHjeDlPaXsRmr3WzOVPBD1Evuth/GZetkbg6e?=
 =?iso-8859-15?Q?4cqmXcZwkFvKtZIaKC/LjK6CdqvAFVqfaay1VIL6OyioUMPZaMsAB/h3F?=
 =?iso-8859-15?Q?g3Pfox/mOW8wmpUM+63QIpCoJKeVP58JeWkpQ/DQirR5QtHmBr45aC4YM?=
 =?iso-8859-15?Q?C/1MNNwXsBIURGmE5agGkaCvUL9joLuKvaAJAB8/85IPHxhJUz1B3mJSN?=
 =?iso-8859-15?Q?T1D3k6vdqI4ab6LbMzV4VkJvr+WOuWg3bh0evTMZgYGcnmHLKLR49AY6S?=
 =?iso-8859-15?Q?saeWUPn0XJ+4HBv4O30s5JbLbnF55z7SZvMU61gznTzG4DBSxCB2zWIvs?=
 =?iso-8859-15?Q?1027CuJmF5GwDabRMjQ4XvZN5cWkbP9D7NUZlGO4ovEM1gR/RXQGtGKwt?=
 =?iso-8859-15?Q?1aca/3ErlhZmMVvbkpM+s1hVeG6qPxvy66ltCe4VsdEKU/gMW+bXZM4Zk?=
 =?iso-8859-15?Q?3zL43AO8vlbBLFgqT894ZcOxx90bNmuWfxHsNwbMt47jw2DHe6aOrt20u?=
 =?iso-8859-15?Q?A771VTy18Vl1+T91ua/61T65UD/W/EuINdpmnX4AJvf2IyZJMkyzp8eAy?=
 =?iso-8859-15?Q?PF1gmyuZrEeU1/y0YiIxZZPUJ8U8IvqlAlEop+czpzlf5jKEguLLoSGwa?=
 =?iso-8859-15?Q?FZlr/Id1GvCn4wapVLDlrvX82XI21zNVKngOLedY+iMCFIWfJ1rEqexJI?=
 =?iso-8859-15?Q?BaGOJbeX/NNXeZKEht9l7wkRVFyje9jylLxlVCih9evdk2nmMpKrJ1XS/?=
 =?iso-8859-15?Q?2vJQHkiwy5sVYATqVvy8IXX+1tAb34M8/XDljSWGugRFX9jRldh+tPWbM?=
 =?iso-8859-15?Q?EIovh8ElnuyGQ6jNEDeXM7md6ONk2ZpEyt1R2aluPhEa62ybbpuODJsU1?=
 =?iso-8859-15?Q?z3t6ETbzuWm70tt9mIws5SIVzezfRfbu3xMr8IuUXlOrnAwwIz7tiwb2R?=
 =?iso-8859-15?Q?BsxHQZP2IEt7O4TV+KAf5O+JKmqt7BQrj/MKazt1C7xwjE89+KGi58EDA?=
 =?iso-8859-15?Q?fwzyh1OQmKDIRMfl99I12rVGf8610mJG8aoM54qQGjgN7G8TodMMwbcdR?=
 =?iso-8859-15?Q?YEpRDzTKYNg1DQuJCwUhjBiVQPY0Mdjhc7saHZH62b+PA9BkERxouuHqt?=
 =?iso-8859-15?Q?snBUAc+A+4qUphUpdDYx5XPUm0XsDO2HMzCJ/7LVZL+AuVoigTL5N3ChF?=
 =?iso-8859-15?Q?M+5WPhPB3ofk0ZtpBviVVdiFe1mbFn9aOD5qIWmiFN68SyVKqIIQWWsHQ?=
 =?iso-8859-15?Q?7uPkY7Sj3A38UrjlC55CvW7yHjpNCegqDazpp/TPQoWl89/uO8LeSqlnt?=
 =?iso-8859-15?Q?ymnDLlTOI+pcHUrRvab/JiAeqQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <3A87BDDDCB67374D97058DE907675E99@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GVXPR03MB8426.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5585e240-abcb-45dd-eed8-08da6420bb24
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 16:08:16.7524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ePjwdwJv6owaOdgY6L4eSY5gesL1W8Hl4tvvB9ERnBVbqLkQ8ZvppfeGdp9+88fyjYoma1sKBCKXmQALIElAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7466
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 23:39 +0900, Vincent MAILHOL wrote:
> On Tue. 9 Jul. 2022 at 03:15, Frank Jungclaus <frank.jungclaus@esd.eu> wr=
ote:
> > Started a rework initiated by Vincents remark about "You should not
> > report the greatest of txerr and rxerr but the one which actually
> > increased." Now setting CAN_ERR_CRTL_[RT]X_WARNING and
> > CAN_ERR_CRTL_[RT]X_PASSIVE depending on REC and TEC
> >=20
> > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> > ---
> >  drivers/net/can/usb/esd_usb.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_us=
b.c
> > index 0a402a23d7ac..588caba1453b 100644
> > --- a/drivers/net/can/usb/esd_usb.c
> > +++ b/drivers/net/can/usb/esd_usb.c
> > @@ -304,11 +304,17 @@ static void esd_usb_rx_event(struct esd_usb_net_p=
riv *priv,
> >                         /* Store error in CAN protocol (location) in da=
ta[3] */
> >                         cf->data[3] =3D ecc & SJA1000_ECC_SEG;
> >=20
> > -                       if (priv->can.state =3D=3D CAN_STATE_ERROR_WARN=
ING ||
> > -                           priv->can.state =3D=3D CAN_STATE_ERROR_PASS=
IVE) {
> > -                               cf->data[1] =3D (txerr > rxerr) ?
> > -                                       CAN_ERR_CRTL_TX_PASSIVE :
> > -                                       CAN_ERR_CRTL_RX_PASSIVE;
> > +                       /* Store error status of CAN-controller in data=
[1] */
> > +                       if (priv->can.state =3D=3D CAN_STATE_ERROR_WARN=
ING) {
> > +                               if (txerr >=3D 96)
> > +                                       cf->data[1] |=3D CAN_ERR_CRTL_T=
X_WARNING;
>=20
> As far as I understand, those flags should be set only when the
> threshold is *reached*:
> https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/err=
or.h#L69
>=20
> I don't think you should set it if the error state does not change.
>=20
> Here, you probably want to compare the new value  with the previous
> one (stored in struct can_berr_counter) to decide whether or not the
> flags should be set.

Hi Vincent, I didn't interpret the comments given to data[1] in error.h
in that way (obviously). But after checking some other drivers, I see
they all seem to handle it the way you proposed it ...
So, I'll try to rework and resend patch 4/6, too.

Best regards,=20
Frank

>=20
>=20
> > +                               if (rxerr >=3D 96)
> > +                                       cf->data[1] |=3D CAN_ERR_CRTL_R=
X_WARNING;
> > +                       } else if (priv->can.state =3D=3D CAN_STATE_ERR=
OR_PASSIVE) {
> > +                               if (txerr >=3D 128)
> > +                                       cf->data[1] |=3D CAN_ERR_CRTL_T=
X_PASSIVE;
> > +                               if (rxerr >=3D 128)
> > +                                       cf->data[1] |=3D CAN_ERR_CRTL_R=
X_PASSIVE;
> >                         }
> >=20
> >                         cf->data[6] =3D txerr;
> > --
> > 2.25.1
> >=20
