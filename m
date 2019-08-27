Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF29E716
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbfH0Lwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:52:38 -0400
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:31143
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbfH0Lwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:52:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akbilN6U9n5vBe/uGSZE+3vYzZhsArdsa+fXB3FzHYf7Jh1iR1c/C9vqtWTqAZcA3FtModDWL+fRLnImEXsR/GlThzdHpquQIafChmbKteKCIlY3WLuF9C/zXENznKR7WQTzH21hZ49IJ5lyp7ov2B2++ge+SOJ1H2a0B+ig+sby0hGjzgDEvCaR00JK0XTXDFHiiJdmiB2q2m0WsYyh46mucpVnEOz1jCh8Pwn9tY4ko10EU0lvWaczvNrCPYW2CTu8iW4umQuRlsc1BT1v/BVD9ERUkVe9j1NlKGFY75zrAA5W8tZgQtRd7VwvZXsK0iIAqq3kABUnAf8Gu28Jrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clbdMe6Sll5sBuO1hvA3R04IO+XXp7Taf1k7IZnKAb0=;
 b=Ath6zzR4ZAyzNf4J3d/69SDkxsi/AS3fw1iA+GqWeu8apOu849u6rrXfB6Sfd4KuOy7Sb+JzDU5vGnyDwCtcrvmPzJDXk8/D+fxeedHxhyiYjWjIjbtZKjdEhAvkjvPVnDZzX/mNNGxWcfjqFx2vjttNp2dgEZ7VeQJq36dHrhTk9UfHOP/O3sN/AsbRWixN2pYkdOlBZQVZM+NSM1e4fuFAB9YAUnks8w1+KAC4vF34Oiqj2Z8hoqlfAfL1eVBfnu+X8QWhYJTtYk+sH8yf2CbjMSb9G44h4nWFuFGGltZBTvEFzStu04v8qHzm6z+0x2a/QBly4Z2XjiSMJPL/lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clbdMe6Sll5sBuO1hvA3R04IO+XXp7Taf1k7IZnKAb0=;
 b=Zo0SwtxLg5kfOdKd2bsLgDkUoreIUaP5ydQOKveATsl6DXf00h9fpJe2ap68kCL681PBIMgyA7RSccNy1eZKdI2S7SvP3IHUaPXz3KjHtjQxWWZae/h3QhNFXgBQE+/Re4BwEcq41zzl+BQXHrWBcHQb7Ln9OND/cJkSNJp78BY=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4291.eurprd05.prod.outlook.com (52.134.91.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Tue, 27 Aug 2019 11:52:21 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:52:21 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Thread-Topic: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
Thread-Index: AQHVXE6v3Mg2zMVvBUG6schRq+9Lx6cO0OsAgAADYqCAAAnfAIAABFHg
Date:   Tue, 27 Aug 2019 11:52:21 +0000
Message-ID: <AM0PR05MB4866FD2DB357C5EB4A7A75ADD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com>
        <20190827124706.7e726794.cohuck@redhat.com>
        <AM0PR05MB4866BDA002F2C6566492244ED1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827133432.156f7db3.cohuck@redhat.com>
In-Reply-To: <20190827133432.156f7db3.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6ad6fcc-cf5b-4377-55f3-08d72ae504e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB4291;
x-ms-traffictypediagnostic: AM0PR05MB4291:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4291108F579B735D531E27B0D1A00@AM0PR05MB4291.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(13464003)(14454004)(55236004)(53936002)(3846002)(71200400001)(81166006)(71190400001)(6506007)(486006)(74316002)(81156014)(7736002)(316002)(25786009)(7696005)(55016002)(52536014)(9456002)(33656002)(54906003)(11346002)(99286004)(5660300002)(6916009)(229853002)(476003)(6246003)(9686003)(66066001)(305945005)(478600001)(256004)(186003)(8936002)(76116006)(66556008)(26005)(6436002)(6116002)(8676002)(66946007)(66446008)(66476007)(64756008)(53546011)(446003)(2906002)(86362001)(4326008)(102836004)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4291;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9OHYhJkUQgNJawcyqwBBHwf2Itt/etHiW8timGaeKz0vFDf82PwGuYdzJeBWSuuf9uAuUN3kcpWasSI7pxQQV9ZJkrcz/qHs2rC0xW83tfmLqan+mkkTvUjC9OWTryWps/Mls0m72SIKQKWdFkBjmjK8sDOUZPrj880Iwf3Fe6O6VksqIyU55LqGGo99pIg4g6Y4VIlkIhUPPePiTMfsKngGClJ44Mc3gm5GP3U7ymlsrNRO1+R0R4tIE3LW9JkoeMc5dhrAGr7/O1a+IiEf3g0mFV7utwsIFVi5vsGEzm+vWFh8UdPDbsAEcy8bNSxxqwpWC11xlLnKM7mDhI8JC0uPa3WsBOMd79Z7iCV6Dqbl3AtMx0grpcRFhjgzF/v418uXGg6mtrfen+4AkzBMz1lPflYZDm1tbRkP4Q63xko=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ad6fcc-cf5b-4377-55f3-08d72ae504e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:52:21.0890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 59vPDxOBg50jziQeAhHdSy4ksQXdaWOfKh+g/ZqQW7CRxNiqUJ07sMa28pOQCpYpdMoyZTqTHAhvx410r0Sspw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 5:05 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
>=20
> On Tue, 27 Aug 2019 11:07:37 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Tuesday, August 27, 2019 4:17 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
> > >
> > > On Mon, 26 Aug 2019 15:41:18 -0500
> > > Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > > +static ssize_t alias_show(struct device *device,
> > > > +			  struct device_attribute *attr, char *buf) {
> > > > +	struct mdev_device *dev =3D mdev_from_dev(device);
> > > > +
> > > > +	if (!dev->alias)
> > > > +		return -EOPNOTSUPP;
> > >
> > > I'm wondering how to make this consumable by userspace in the easiest
> way.
> > > - As you do now (userspace gets an error when trying to read)?
> > > - Returning an empty value (nothing to see here, move along)?
> > No. This is confusing, to return empty value, because it says that ther=
e is an
> alias but it is some weird empty string.
> > If there is alias, it shows exactly what it is.
> > If no alias it returns an error code =3D unsupported -> inline with oth=
er widely
> used subsystem.
> >
> > > - Or not creating the attribute at all? That would match what userspa=
ce
> > >   sees on older kernels, so it needs to be able to deal with that
> > New sysfs files can appear. Tool cannot say that I was not expecting th=
is file
> here.
> > User space is supposed to work with the file they are off interest.
> > Mdev interface has option to specify vendor specific files, though in u=
sual
> manner it's not recommended.
> > So there is no old user space, new kernel issue here.
>=20
> I'm not talking about old userspace/new kernel, but new userspace/old ker=
nel.
> Code that wants to consume this attribute needs to be able to cope with i=
ts
> absence anyway.
>=20
Old kernel doesn't have alias file.
If some tool tries to read this file it will fail to open non existing file=
; open() system call is already taking care of it.
