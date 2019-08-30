Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3427A3AC7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfH3PqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:46:01 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:43854
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727926AbfH3PqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 11:46:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOdhYW27chN8dxlotY6X0Mb/ZaDrzep+Fvc7/QmF0/kio+eheLBAToIZVcaNNz8QtRPdlI9dhJxcv0/gbu4E6rxnIqAWyF1iZhvwsn4RXbxMUuX6puxHDppRMmkUqgl5t6/bFrPfHWwcByQOx9h3nhCnmImLBkdtye5gDJI5bp3pih+SKB1fUd1TlSUpWW6wbDEUO/BFFjvBZVJiQWXLWLOlRuJodnkxLvzLQkebhWdmVK2qhmk1J7g3DKZ6rTFtnRpt+a6QZ/kWbxlFT4SjsOkpBtfV2itPgW7/9Wp0pebU/N0nfDEV3B1cNeI220zLaZoTML3R3Hn70SwPtyvRpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jc1CaDtWbRSFPJOIhWmJwMrDNYcMA+l49BwcXnIZYBM=;
 b=IxUkYKttllNOqdSwNo7s3MLcbftc+HCAI66X5l9Rvdy+aEuSn9e8ZLbHiSqLoNTR+n6fjpL30uugyHJFdzUzK0g1UGxj3Tc5JHLLIjVIoFMTKiMBvkzd6p2Q6+nF97nbrdPpMvRHyHQqPjpQpYvvulpkBpQut1RM/zvcpPX63JzpFtjawrPOybcSAyslErvbO5fTTBq0PqZ+KJcDMnseySpsbs3bvMy02wDOLSSYXh5ZsfyLXduu6WiupS8BU13qRD1dPDUzwG2eL8urGW7eohi9hA6u68p4B9SYn3ilTHPy1kCEok0AwA96HXkGBS/OSXMaqWtDsyDNR+1Q0cq1Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jc1CaDtWbRSFPJOIhWmJwMrDNYcMA+l49BwcXnIZYBM=;
 b=UGDcPAKzK/ts1YoGbFHAK/yf4fYIdIY43VV6wdvS/UMm2NAS+RtfMIIIW8sjGHb74TLgU9aTfTn13gcX2OPKpDn4kLAhRQnsBIWnc85HodlFtMAgqaMW3i6t65n+HxfQOxOWKHvpgOlowWzL+DdGG9YvtsSh1jrmWtNcxeDVh2c=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4291.eurprd05.prod.outlook.com (52.134.91.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Fri, 30 Aug 2019 15:45:13 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 15:45:13 +0000
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
Thread-Index: AQHVXluia2ak8fbBtkW+HkGgDQ+zpacTarsAgAA0s9CAAAPGgIAAA/owgAATMoCAABuDUA==
Date:   Fri, 30 Aug 2019 15:45:13 +0000
Message-ID: <AM0PR05MB48661F9608F284AB5C9BAEB5D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
        <20190830111720.04aa54e9.cohuck@redhat.com>
        <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190830143927.163d13a7.cohuck@redhat.com>
        <AM0PR05MB486621283F935B673455DA63D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190830160223.332fd81f.cohuck@redhat.com>
In-Reply-To: <20190830160223.332fd81f.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86de96dd-214b-4fbf-8b67-08d72d610c48
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4291;
x-ms-traffictypediagnostic: AM0PR05MB4291:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4291AF03ADDD001C96DBE9BCD1BD0@AM0PR05MB4291.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(199004)(189003)(54534003)(13464003)(81156014)(446003)(66556008)(64756008)(8676002)(66446008)(66476007)(54906003)(66946007)(6436002)(55016002)(76116006)(11346002)(305945005)(476003)(6916009)(486006)(6506007)(99286004)(74316002)(26005)(52536014)(102836004)(55236004)(186003)(2906002)(53546011)(86362001)(76176011)(9686003)(7736002)(14444005)(316002)(71200400001)(14454004)(3846002)(6116002)(81166006)(7696005)(8936002)(5660300002)(25786009)(33656002)(508600001)(4326008)(9456002)(66066001)(6246003)(256004)(71190400001)(53936002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4291;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2/v3vvVdj8GqZyRYO9eZkf2FT/xy8eyLqNwdhmtPoD1ku1Tz/kTNrak9maKA5dP8iW4ZsV+s01efG5fNtzTnyXqogXCPdSOxUtxMdX1eAd59O/8KeYVe/e804oHyffF/JDbIclvGmoUYbUpacTqvPEo68z06bXYVRCjR1GBnvlt6nOiifSWUXvBFj8F44/betxeNqn+BRHwVIyKXwY28xFwdycB31Uqng9j6aZORjjjIm3L+tGDqvhSx854QziVRcP53v3Oqr2sSlnYvxm6zJTpnYX1YxB2d6X8p0zNq5UCJRbLpBpWSrJAYcfOtcZu+5G0tLjsyfVpZq5VpmBXe/ir8YebkT302Sz1CWREA5ZH6rDAFpbhcHyRRNS9J+JtOxFXVX06/v8aBA//q3zPNXV9kAXAjXas4F16oqyBwgMI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86de96dd-214b-4fbf-8b67-08d72d610c48
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 15:45:13.5953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PckDReLwRGDAdCFucYnwmWtRVeZjQzgl4xi9gtIbdLOXHF9dNDMCpGrPjZiwbB5RpjNIqXt0t+Fmo4lx5zVmNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, August 30, 2019 7:32 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
>=20
> On Fri, 30 Aug 2019 12:58:04 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Friday, August 30, 2019 6:09 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
> > >
> > > On Fri, 30 Aug 2019 12:33:22 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > Sent: Friday, August 30, 2019 2:47 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev
> > > > > alias
> > > > >
> > > > > On Thu, 29 Aug 2019 06:18:59 -0500 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >
> > > > > > Some vendor drivers want an identifier for an mdev device that
> > > > > > is shorter than the UUID, due to length restrictions in the
> > > > > > consumers of that identifier.
> > > > > >
> > > > > > Add a callback that allows a vendor driver to request an alias
> > > > > > of a specified length to be generated for an mdev device. If
> > > > > > generated, that alias is checked for collisions.
> > > > > >
> > > > > > It is an optional attribute.
> > > > > > mdev alias is generated using sha1 from the mdev name.
> > > > > >
> > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > >
> > > > > > ---
> > > > > > Changelog:
> > > > > > v1->v2:
> > > > > >  - Kept mdev_device naturally aligned
> > > > > >  - Added error checking for crypt_*() calls
> > > > > >  - Corrected a typo from 'and' to 'an'
> > > > > >  - Changed return type of generate_alias() from int to char*
> > > > > > v0->v1:
> > > > > >  - Moved alias length check outside of the parent lock
> > > > > >  - Moved alias and digest allocation from kvzalloc to kzalloc
> > > > > >  - &alias[0] changed to alias
> > > > > >  - alias_length check is nested under get_alias_length
> > > > > > callback check
> > > > > >  - Changed comments to start with an empty line
> > > > > >  - Fixed cleaunup of hash if mdev_bus_register() fails
> > > > > >  - Added comment where alias memory ownership is handed over
> > > > > > to mdev device
> > > > > >  - Updated commit log to indicate motivation for this feature
> > > > > > ---
> > > > > >  drivers/vfio/mdev/mdev_core.c    | 123
> > > > > ++++++++++++++++++++++++++++++-
> > > > > >  drivers/vfio/mdev/mdev_private.h |   5 +-
> > > > > >  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> > > > > >  include/linux/mdev.h             |   4 +
> > > > > >  4 files changed, 135 insertions(+), 10 deletions(-)
> > >
> > > > > ...and detached from the local variable here. Who is freeing it?
> > > > > The comment states that it is done by the mdev, but I don't see i=
t?
> > > > >
> > > > mdev_device_free() frees it.
> > >
> > > Ah yes, I overlooked the kfree().
> > >
> > > > once its assigned to mdev, mdev is the owner of it.
> > > >
> > > > > This detour via the local variable looks weird to me. Can you
> > > > > either create the alias directly in the mdev (would need to
> > > > > happen later in the function, but I'm not sure why you generate
> > > > > the alias before checking for duplicates anyway), or do an explic=
it copy?
> > > > Alias duplicate check is done after generating it, because
> > > > duplicate alias are
> > > not allowed.
> > > > The probability of collision is rare.
> > > > So it is speculatively generated without hold the lock, because
> > > > there is no
> > > need to hold the lock.
> > > > It is compared along with guid while mutex lock is held in single l=
oop.
> > > > And if it is duplicate, there is no need to allocate mdev.
> > > >
> > > > It will be sub optimal to run through the mdev list 2nd time after
> > > > mdev
> > > creation and after generating alias for duplicate check.
> > >
> > > Ok, but what about copying it? I find this "set local variable to
> > > NULL after ownership is transferred" pattern a bit unintuitive.
> > > Copying it to the mdev (and then unconditionally freeing it) looks mo=
re
> obvious to me.
> > Its not unconditionally freed.
>=20
> That's not what I have been saying :(
>=20
Ah I see. You want to allocate alias memory twice; once inside mdev device =
and another one in _create() function.
_create() one you want to free unconditionally.

Well, passing pointer is fine.
mdev_register_device() has similar little tricky pattern that makes parent =
=3D NULL on __find_parent_device() finds duplicate one.

Ownership transfer is more straight forward code.

It is similar to device_initialize(), device init sequence code, where once=
 device_initialize is done, freeing the device memory will be left to the p=
ut_device(), we don't call kfree() on mdev device.

> > Its freed in the error unwinding path.
> > I think its ok along with the comment that describes this error path ar=
ea.
>=20
> It is not wrong, but I'm not sure I like it.
Ok.
