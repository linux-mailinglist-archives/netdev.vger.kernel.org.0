Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1817BA5FE1
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 05:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfICDrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 23:47:40 -0400
Received: from mail-eopbgr20086.outbound.protection.outlook.com ([40.107.2.86]:43526
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfICDrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 23:47:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akY6Ht57UaLe9mUHB89fqEwsPpFuthlc0smCtVKADDGqrFMqslYo6zcs07t2LU7XVisHtMh5NRKUrX7QMRatmy7t0c5PiydBPQl6qNALXElDmO1QLbHKLdYi5lfiLwWRGT7tSuqET05QPCcAFUJ7CopBsleE3NiuLotg+ePWAyjoXXtyjR6nCZ4VdDZK4pf4xs/xuSqwb7+3I10D1Jwn8oedU3eJsfGcwdOlnDUDtuqSg7DVC4qowPPX2s4oMOgdYE6DCKMKhsnyRAaoikpLXkxlE/fm8XTGB//mfym8HTd98wzik5z3CSEYIG7FZG6M6nDRCnJrGqMrUbGzO3QVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWhQXdv/lsPLcFVXdKKkPX7qk52sHE5hAZxR+rcE7nY=;
 b=RlLtj/cWwRyl8cLvuU+88Oi1XpqVnwwzQH8ovroq+Q8dDxx8nqvkaL5EdMpSHcdxX/BvQDBvrAgxewT0SkTdrXJIrmRJ2vDDGhUA9/lTABcUU7C9sdpwO5c9w/T0EucbeMmkgnir2/LvOKRJJ9uJzGbJ+HLmAftOBXwv+IyHvl73Cf2o6Tq/YVmGgOvR8Wge2l1Tf5ONMjWrDc528IHtBDj5AdEQy3NZ39HaxalDUFlRLQBfYjQk/TgjI72373OTokGm/YyC8CzRp6qvEXNGtNI17341lVZhbV3LS+krhhc3ZJhz+HWkZ1KUrtlqAJZPjO1tXIi0DOLSJCoFiw2sEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWhQXdv/lsPLcFVXdKKkPX7qk52sHE5hAZxR+rcE7nY=;
 b=Jiu2bgyKmMEOf5fFkGqdT8tmNVc9qvu1LWXCiNLD1bH7N7EN0NPMy8h5wnKitmgAGurYUkNoXof5ITSpZ8NDuqA7swlCkkvmIVaSOFWwFt6Ik0TNoXzSp3nNVtFaWIxMiQKWXVF3ldoCCQHh+S0JxmRleZWGkpr5n24zx7n2S34=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4161.eurprd05.prod.outlook.com (52.134.91.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Tue, 3 Sep 2019 03:47:35 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2220.022; Tue, 3 Sep 2019
 03:47:35 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXluia2ak8fbBtkW+HkGgDQ+zpacTarsAgAA0s9CAAAPGgIAAA/owgAATMoCAABuDUIAEp7AAgADYuGA=
Date:   Tue, 3 Sep 2019 03:47:35 +0000
Message-ID: <AM0PR05MB4866B62A2EDFE341AC4EA1B5D1B90@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
        <20190830111720.04aa54e9.cohuck@redhat.com>
        <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190830143927.163d13a7.cohuck@redhat.com>
        <AM0PR05MB486621283F935B673455DA63D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190830160223.332fd81f.cohuck@redhat.com>
        <AM0PR05MB48661F9608F284AB5C9BAEB5D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190902164604.1d04614f.cohuck@redhat.com>
In-Reply-To: <20190902164604.1d04614f.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0ec3a94-1851-42fd-bdd3-08d73021751f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4161;
x-ms-traffictypediagnostic: AM0PR05MB4161:|AM0PR05MB4161:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4161022081014823305F6C92D1B90@AM0PR05MB4161.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(13464003)(189003)(199004)(6916009)(71190400001)(71200400001)(66066001)(53936002)(11346002)(52536014)(486006)(476003)(6436002)(6246003)(5660300002)(446003)(6116002)(14444005)(256004)(55016002)(55236004)(86362001)(76116006)(102836004)(478600001)(26005)(66556008)(66476007)(64756008)(66446008)(9686003)(53546011)(6506007)(74316002)(316002)(3846002)(186003)(9456002)(99286004)(2906002)(8936002)(7736002)(76176011)(305945005)(33656002)(229853002)(54906003)(4326008)(8676002)(66946007)(7696005)(25786009)(81166006)(81156014)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4161;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kO1uJPcuA2vgGWiyUsjiJ31l7bGKDBUpLj+3ElhFo3SzHg2s7eoR2GSQFU0i4j+MaYj/v3TUuPLriq3doaGVhPy+5wxW5zF1PS5x1px+lxLKRkYUtXxWVPF3CvS+/LUBmglZEW4efy5C478oGgHg3MqwHZceGa0YVK9Z/eFDhs7Dpnor0EQDDWQI8u0WSjraIZfmlToAaIlBiNFpokqMHHDM5SpA+yLvZThd3RgLPqr7lrtSb+xs+/VhqJvGRZ7xSl7eI0TaNVFU6N645uoOjecVyEcxxcdCDnZLQ4nRf3uVmxErVglBOGkooM7SeKdn+9CFskGlc6VqX5wk9Smtoru4H0OQQuTSBPNLF0Q1pteVn3ArU67lIOljJVGynj7cx0nfu1JpkhpNt5fxqPW04ajAHV2TgwMsE1ER2OpejnE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ec3a94-1851-42fd-bdd3-08d73021751f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 03:47:35.1783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S03fps6uhwNC9+ZOM8j+Gb28xIf2kkCa/OZDDBXrJtLRKBLH+Mn1DJlvxzk27eZuuBNfNftFhu9Gi1pW/OjgZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, September 2, 2019 8:16 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
>=20
> On Fri, 30 Aug 2019 15:45:13 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > > > > > This detour via the local variable looks weird to me. Can
> > > > > > > you either create the alias directly in the mdev (would need
> > > > > > > to happen later in the function, but I'm not sure why you
> > > > > > > generate the alias before checking for duplicates anyway), or=
 do
> an explicit copy?
> > > > > > Alias duplicate check is done after generating it, because
> > > > > > duplicate alias are
> > > > > not allowed.
> > > > > > The probability of collision is rare.
> > > > > > So it is speculatively generated without hold the lock,
> > > > > > because there is no
> > > > > need to hold the lock.
> > > > > > It is compared along with guid while mutex lock is held in sing=
le
> loop.
> > > > > > And if it is duplicate, there is no need to allocate mdev.
> > > > > >
> > > > > > It will be sub optimal to run through the mdev list 2nd time
> > > > > > after mdev
> > > > > creation and after generating alias for duplicate check.
> > > > >
> > > > > Ok, but what about copying it? I find this "set local variable
> > > > > to NULL after ownership is transferred" pattern a bit unintuitive=
.
> > > > > Copying it to the mdev (and then unconditionally freeing it)
> > > > > looks more
> > > obvious to me.
> > > > Its not unconditionally freed.
> > >
> > > That's not what I have been saying :(
> > >
> > Ah I see. You want to allocate alias memory twice; once inside mdev dev=
ice
> and another one in _create() function.
> > _create() one you want to free unconditionally.
> >
> > Well, passing pointer is fine.
>=20
> It's not that it doesn't work, but it feels fragile due to its non-obviou=
sness.
And its well commented as Alex asked.

>=20
> > mdev_register_device() has similar little tricky pattern that makes par=
ent =3D
> NULL on __find_parent_device() finds duplicate one.
>=20
> I don't think that the two are comparable.
>
They are very similar.
Why parent should be marked null otherwise.

 > >
> > Ownership transfer is more straight forward code.
>=20
> I have to disagree here.
>
Ok. It is better than allocating memory twice. So I prefer to stick to this=
 method.
=20
> >
> > It is similar to device_initialize(), device init sequence code, where =
once
> device_initialize is done, freeing the device memory will be left to the
> put_device(), we don't call kfree() on mdev device.
>=20
> This does not really look similar to me: devices are refcounted structure=
s,
> while strings aren't; you transfer a local pointer to a refcounted struct=
ure
> and then discard the local reference.
