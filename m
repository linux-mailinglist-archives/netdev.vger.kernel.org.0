Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA24B3B31A4
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhFXOnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:43:15 -0400
Received: from mail-eopbgr1410113.outbound.protection.outlook.com ([40.107.141.113]:27476
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232348AbhFXOnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 10:43:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjtlrONPKEzds1I4WW4B1qqv3JPURT7Mw/xeRZm8BKS5qql1FtpLGm/DXBG1YaK27fNThdk+9+20wuCFXznzFseBJ/Cj1JCHN35cUfjC/Ut80Vty+EuArnzjNB6JDkpoSq8yJQkFQT2FobfO2kUDMu8Rr1R4PWAlAwlHaNeaWcWCxOu0emjwLqJjhCKzYrdgFeUi9nD+2MjlLJj8CiGsCHbd8oyg/HdMxZRjXStEwhaa6xmrpP5ZPH6u/ZN71g34NaX25BIr2XV9GnXP55ZQcc9tWWIw4ZR6/1iFJeMzZ/yuQR/Pqdrpc4yJV4EqpTuum6zYJtikHIqdYanZgsOHFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSW7PlHW4yLNY/4HzT77tetTSmpgXMfrIikG909s7hY=;
 b=IEEPIi2CJxxaPi3pi7SAV5hQ9CFtOsdEDs9QnU10J2sauBB3Ij8rSR4OYI7erKPp6ZnVrgf1XnED5KXDWnctYRDmWuO1dIcnzfJ0OHz4D1bE2c5OOvEhYY0RLeHdXIEt2eODAZc0Ni9hUD5WdrE8CqF6P1O0rHk1vr/zjrkAU7Ck74YGXbvdz9QuFkOss6VUNIB3/C1wKul4nDDsP7J7qGiO3liJUyXreNK6cQo29txSa0Hkr6uEezEJKJsudt6Ho8+ywmrpS7Q3DBT2Bt3c9/tmSlMrNjUJ2wAY1zi+AR+Rn293H852xtkKtV2DEKBZ3yJTe5XadVPurm2AS/9rfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSW7PlHW4yLNY/4HzT77tetTSmpgXMfrIikG909s7hY=;
 b=Ntl4RNh690CbJbgtb/Rm0YyeKZeAITVuVIn75UAo4xQAqsgLJ+GwPN4fbOVWzP2Bg0VLEuLDNUhNVi9pn+BPaUrrUzOi5wNmt9/LLB0fTAoftCDj9Co0SHSFMLMcSc5gubnMAuFNw39vzYUIanrv0oZWAt9YIEe0hhzPX3eHT6Q=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB6854.jpnprd01.prod.outlook.com (2603:1096:604:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 24 Jun
 2021 14:40:52 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a53c:198f:9145:903b]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a53c:198f:9145:903b%8]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 14:40:52 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Topic: [PATCH net 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Index: AQHXaD6jW0RQwXJIB0KjGLrs4I9VGasihcSAgAC3BgA=
Date:   Thu, 24 Jun 2021 14:40:52 +0000
Message-ID: <OS3PR01MB659335F4857D1FD1E8977C24BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <1624459585-31233-2-git-send-email-min.li.xe@renesas.com>
 <20210624034343.GB6853@hoboy.vegasvil.org>
In-Reply-To: <20210624034343.GB6853@hoboy.vegasvil.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [72.140.114.230]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f22586da-25df-4585-ea15-08d9371e1140
x-ms-traffictypediagnostic: OS3PR01MB6854:
x-microsoft-antispam-prvs: <OS3PR01MB6854A40290365F928BC5082BBA079@OS3PR01MB6854.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cUOnlxRv5TQcpo3iOvBjOjM2D34k7QUS5WHzUmNIBUBrLDYy8DyygToNqlY9yXDQ6SrpQ8LTIZqvug9Dr/P/vpQWvIsSppqFnI4YAAY47xlIP6/EsTdfmKbe9BMOb33kmFSD9B/DeJQBtIilfuq8wTRiWQwquxZkFYoD5EWOPh+wOl4VLCkq2SfEJB2Z2A6SLIylUJrBukxDsZR5c8dB6GLV3xNl573LzEguuGzBocxt3caIDRQ3UbDKtOglE1pnqftFyNOYPh40CuJviS4tbxxGRvJ3aaigtM4QsR9D7CWx26VrnctfggD6vAfzXjQ9ih25NoJa75tPbktFBXWk0UG0rMMtUGzyBQj2G9RTBBmTGZNf7BUssKOvfebqWDH8eFW05P4hG7Bn+kclhzTj1RHCi0oiKcImnROvWQDP+kIsrngKlIFQXpF7OLPvtOzIqzPqa0VrTiC4rddyjJpAAxKAFnYI8zBwl5fB+C2rOXnQlI2T8DCB2c+qfLLWxSUzNF3WPqlhZkY3sIKTmlHqxbV5FXoKC+6yyu3TCy/0vhv9W6DMesr5PWdlNTSNecyxgYf2y6AvRmc56074sAHPVKcxBU2JrBQVOciCWrneelbt3kVamD7o8ELWmPd285aL/HSCtScPoFjujdMZg+9qfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(83380400001)(6916009)(8676002)(26005)(38100700002)(186003)(6506007)(53546011)(316002)(2906002)(7696005)(54906003)(478600001)(76116006)(122000001)(9686003)(55016002)(71200400001)(4744005)(4326008)(86362001)(5660300002)(8936002)(66446008)(66556008)(66946007)(52536014)(64756008)(33656002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QkLT41SyKaoUVtruE9kRmOWswdqp9JMwu/HVsjKvtEYT5RuNAkdbxKdGVsCZ?=
 =?us-ascii?Q?g4KfuPC1b8ZEC5iCsRLsxYNLGCL33WkgXwzL4y/8gWPZM1PBGx/nA9JWfjaW?=
 =?us-ascii?Q?G+U4MVqa1PxZIUxv1+FNZS4tyweKy9eWKsrBYVkt7dKA/GQwTPmR1e0Y0IWX?=
 =?us-ascii?Q?+I8cj72+THtZ4ue3e3j5BceUku7ELQ/hkJILrkJHaFee5ib4jEQ3N9A9psIL?=
 =?us-ascii?Q?+reiMnKLQ4xHhhGBv/lDlj/3XE8Xd0WwuYrInJ8XRIxhLbSA0Bh3CFoiu880?=
 =?us-ascii?Q?qrQGaBC2VsbegToZDQJTaUMTb3MYhQ8jYEvTWqRgzOXa96ffE3IVr574po10?=
 =?us-ascii?Q?nbbP7nNOJUB4wfh5/dvpHKJhjc9NQTyw+EsG0LIIGpOX3MV7N+774YT/vk3Q?=
 =?us-ascii?Q?M7/cuHAxSSwX2Ml/4MfSOE6QGf3YJykdR4n4mY1Vx5KtOLQxTvNrADsw53CR?=
 =?us-ascii?Q?DCHwS1fqfLkuPZfAout9aULYbBl0NxApA2sRerTm6Q4DuSL56fTXMHqcVgTk?=
 =?us-ascii?Q?0tW5ckZ+DaCrOqGdEl34UNrJHMvcw7xsjWxLQAVe8UlxoHgYh+ZKrlSG4Iay?=
 =?us-ascii?Q?U00wz9DZ1nuoefNBFHtnBkEQhRb+/7G2N+kvcRXTX2ObpQvs95nsGEdZD4HE?=
 =?us-ascii?Q?2X76rq0uSpVg3+cW0D/L8lY3CKXrrbXcjMOl9P22b5ImZv+AvU4Vg6BCloOr?=
 =?us-ascii?Q?LW/pP/cRbBmneANebtz2TbIAzSTfDNqUu6MwnGhGt/M4uwsustyCKGW3NXDk?=
 =?us-ascii?Q?NtSxYguOgID/Mh/kblQ5lM+adgTe1tXp9h1uiZkYCgjGw69wALDonn+Na+e2?=
 =?us-ascii?Q?DJ65Ghp6XQKoEevJZlOrwxKD5NKiIrH0IEqB0ZYR3iYPQRjGSs79Q01ue2dR?=
 =?us-ascii?Q?5ty2LQeLA57UGvUOv/K3LCT+kr/nPH8z051UOMt6xMNmaKbu4m6CB75ioarh?=
 =?us-ascii?Q?7PvIhDpI+CkMdSe+3EEwmdGm4JZq6Wt63OK+zLOMeAjHFadZDp0cEe7oRL0C?=
 =?us-ascii?Q?u96gEXLQCIghsVJO5NXIoWyZ/7sUE1m2zj1MWJkPuSwmWRkQha5BbcNdMLT3?=
 =?us-ascii?Q?xpIJBxouQyZrvv/De/6lNYaC34p/0IxC/lZ6qwVsJK62cKUEwCaSE+hJWc5V?=
 =?us-ascii?Q?T5+9sj8gCWKmFG9iJj9gRqd3/gfIvUgQl8SyOEZ//fIoEunWKZzo5V3kcd6i?=
 =?us-ascii?Q?3CMXs40cdJxZozs/5x8ft4WMtP+2VfK3HaxAnf/j4hEqGDYJcdPACChRuYYt?=
 =?us-ascii?Q?nApG0wb5LxLlDjTjHf0eeZ4ealEC6eymq8W1xnAgUX9beQDwMajmmEwpOpng?=
 =?us-ascii?Q?AWnLuF8GhrIQ/R3lOe5lmYmS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22586da-25df-4585-ea15-08d9371e1140
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 14:40:52.6285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P8D7cvneR6Xl3EYYWPWuoOqyJWpJSxh3GCaeHxYwLUoFHJhEDVNlTUQMnXyH3oJyi9V7bhUQdC6CR7XiiEsAZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: June 23, 2021 11:44 PM
> To: Min Li <min.li.xe@renesas.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net 2/2] ptp: idt82p33: implement double dco time
> correction
>=20
> On Wed, Jun 23, 2021 at 10:46:25AM -0400, min.li.xe@renesas.com wrote:
> > +static int idt82p33_start_ddco(struct idt82p33_channel *channel, s32
> > +delta_ns) {
> > +	s32 current_ppm =3D channel->current_freq;
> > +	u32 duration_ms =3D MSEC_PER_SEC;
>=20
> What happens if user space makes a new adjustment before this completes?
>=20
> After all, some PTP profiles update the clock several times per second.
>=20
> Thanks,
> Richard

Hi Richard

In that case, adjtime would simply return without doing anything as in

@@ -848,11 +914,15 @@ static int idt82p33_adjtime(struct ptp_clock_info *pt=
p, s64 delta_ns)
 	struct idt82p33 *idt82p33 =3D channel->idt82p33;
 	int err;
=20
+	if (channel->ddco =3D=3D true)
+		return 0;
+
