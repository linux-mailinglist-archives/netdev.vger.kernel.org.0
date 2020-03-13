Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57537184AD5
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 16:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgCMPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 11:35:00 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:6132
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgCMPe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 11:34:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBpUja6u9YtOEpIogQu36NBpoRZFCqToRoLdDCdMC+oHr/dcRfnwEyV0/23YSAKVYRBKVx7KoB9A0uaPWLaAKTLVYsLvXq0mFZvYhzpAcqFWqzAlY1MpicJZoh6kTAaxHUS5iV/x2SP+wlr6rmejZ168d5Um0epafGj3iWQVuPsjzJkh7Du8MlYObsQEDiWxx+pzXYhlDE/XxQG1lAO+rAybH2vvz/j/mdthpGG3remmOXl/90t4iJj2BoTWYfU0ISMSjnPH9mBraxJ/IOFD2xYFjFo6kCcIM+m3LiI69Jq8pUg4J4kvas/xuwQW+ztZjGl3IVuSIi9PGSfCQUD7bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QrJXH34Af3wy3eOaPZ8mFRizX/izUQ397oGXnT4LNc=;
 b=AoLkyIDOBUP47bi/60h6ou6ySxQVPTxhP1qHPSp6EevqvyJl5smFHkV5Dlmp2Gp/tPKMMaYOw9p1Dufq0fCc/pXt6xUJJGw5h6r/OPkHyjZ6VUvKMkJyf9lG0qDnAf0s86Z7T/Wp77v0AiXgVPY0N7SWjFdordakt/9eHdbqVnOLJ+Y87Dma3K1fw2NPp0cdbIBrnnALzSxK1FFGuhaTuHUSHvB075x3+3gF3KfTE7ledla6woVho362FQabd2xXFQ0rNFKpepFpA00kfg5VKeZ1EaxsH0Kf8ZWnmLVGeX32Yo0uVSP6JfCDBlaxvzQcqSeXPSIAYcpaSLfqS0Icqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QrJXH34Af3wy3eOaPZ8mFRizX/izUQ397oGXnT4LNc=;
 b=hhG9YDXAhCx9iWmRGbE6g46Dxwz5C/+4pRZXwwWZ5DkaPZSdm3b0x0V7+b3JKsV2FRGGbApo3hxT3yw+xAE1xlKf34LpIYUDrPhFt+7T5Qwg+FCcV0PxtcBjPhwR1sTULuio0+4jBQ9wv9/xqL4tTqwcq8nZf3f6rdW2eUShSl0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3550.namprd11.prod.outlook.com (2603:10b6:208:ee::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 13 Mar
 2020 15:34:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 15:34:43 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 3/5] staging: wfx: make warning about pending frame less
 scary
Thread-Topic: [PATCH 3/5] staging: wfx: make warning about pending frame less
 scary
Thread-Index: AQHV9sSohBK2XnsHaUKZ+zJWfUL/nqhFB/mAgAGkUgA=
Date:   Fri, 13 Mar 2020 15:34:43 +0000
Message-ID: <6287924.ghGFUMk3OD@pc-42>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
 <20200310101356.182818-4-Jerome.Pouiller@silabs.com>
 <20200312143019.GN11561@kadam>
In-Reply-To: <20200312143019.GN11561@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b3fa763-bf0c-469d-3911-08d7c7640dce
x-ms-traffictypediagnostic: MN2PR11MB3550:
x-microsoft-antispam-prvs: <MN2PR11MB35508EA16C5337AEFC184BA993FA0@MN2PR11MB3550.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:206;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(396003)(39850400004)(136003)(346002)(376002)(199004)(186003)(81166006)(8936002)(71200400001)(26005)(54906003)(316002)(2906002)(8676002)(4326008)(478600001)(81156014)(64756008)(6916009)(6506007)(6486002)(91956017)(76116006)(66446008)(66476007)(6512007)(66574012)(33716001)(9686003)(66946007)(5660300002)(66556008)(86362001)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3550;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KeC1LVAD8/qlYhyNhaOUUhCqk0Qc0pmYWhiXpyGAGS7wkE2/ykWOmfNqMQv7ofFF+3ZT5PjWd4b+LBaQ5jwJx6Rmp+AyAy9ChJAcWJafvc4sBdIHD622aSnxb+U5hAdcO5gi77reTkmIFZz2C0BXqP35wnADOBW8/InXqeR1c0y09LnGycH38cmzi1v9eUA0J4V4dD8GdI/LescuIy14SE5hxhuRD4qUntQUgutCojLtNbO/vwXX1tgaA5wQz47C9+MYcggltJ+d0X71CB+X4Y8+AEESxqB9Vm3W/mjdducLnCKIlksU/o6Q0Yns4UgdnOgPiyhzXZpy+l8e1mxkYpLMoQuzQ73IrUvwXvRXErqYmJUrJbHt6dqpVa/VX3nQuBS//PCKUeAJXPOqhza5MvSIpJO4w9GeKdWDkd7C0SpRpCI50Ia6CpFZrHUXmd0tJdPbtg0SNGGgTq0HUGsNnWgo4PUCYhIC/O6OqLK5IztGkQWhICNZ8qjXpHY+5W3E
x-ms-exchange-antispam-messagedata: HAJtEkw55bCDqxWPYO8URB915Y2BB5R6hkTGiMViiMBjXh+xymQyqu6yKuNe8s+Yy1GtjruX5LZbs3AuMrGt99Axvp/lc873tP4zJemSKH/aLE2xnrm4IojEtkRCP1rKNMAHIEKMexV9HawCz0fV5w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <6C67A06F0BF48A49A32F1DC4F83F5FCB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3fa763-bf0c-469d-3911-08d7c7640dce
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 15:34:43.6451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cg0qYDQrOFu3VX4FyV//cEciTGTtF4voQG5B3NxdK99t1nOPuZX1JLrT79t+0b/FsCiso/sHCZPe2/mf4fGeAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3550
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 12 March 2020 15:30:19 CET Dan Carpenter wrote:
> On Tue, Mar 10, 2020 at 11:13:54AM +0100, Jerome Pouiller wrote:
[...]
> So it really helps me if the commit message restates the subject.  The
> truth is that I don't really even like the advice that Josh wrote in
> the howto about patch descriptions.  I normally start by explaining the
> problem then how I solved it.  But I try not to be a pedant, so long as
> I can understand the problem and the patch that's fine.  So how I would
> write this commit message is:
>=20
>     The warning message about releasing a station while Tx is in
>     progress will trigger a stack trace, possibly a reboot depending
>     on the configuration, and a syzbot email.  It's not necessarily
>     a big deal that transmission is still in process so let's make the
>     warning less scary.

Indeed, my idea was the reviewers start by reading subjects and then read
the body of the commit. I will care now.


> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/sta.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > index 03d0f224ffdb..010e13bcd33e 100644
> > --- a/drivers/staging/wfx/sta.c
> > +++ b/drivers/staging/wfx/sta.c
> > @@ -605,7 +605,9 @@ int wfx_sta_remove(struct ieee80211_hw *hw, struct =
ieee80211_vif *vif,
> >       int i;
> >
> >       for (i =3D 0; i < ARRAY_SIZE(sta_priv->buffered); i++)
> > -             WARN(sta_priv->buffered[i], "release station while Tx is =
in progress");
> > +             if (sta_priv->buffered[i])
> > +                     dev_warn(wvif->wdev->dev, "release station while =
%d pending frame on queue %d",
> > +                              sta_priv->buffered[i], i);
>=20
> Why print a warning message at all if this is a normal situation?  Just
> delete the whole thing.

I saw cases where it happened and it seems harmless. In add, this code
is going to be released with 5.6. So, the WARN have to be removed.

However, I think it is not normal. Even if it is harmless, it is the
symptom of something unclean.

So, I think that dev_warn() is the correct level of notification.

(I should have included that in the commit log)

--=20
J=E9r=F4me Pouiller

