Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D09EFE1
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbfH0QNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:13:34 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:54759
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729852AbfH0QNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:13:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6TngGc4Srqj7RI+U0xjcqBPofcnagnwLPCd9YWm7B+0krWQ7+/+N2U79FIvUTNWn8vMuz+qwy4zzM5EwY2itBQVmhRo8RHc0XyOB3E8sGsR5XT2E0arSR1On7pJcjp7BoyxAIgWupGoR0JKPEbbVZ5RejmcVat1tiyTJKxchgKmBrdu8QFot3gwNxw26sbqUz4AwC22jUP7DwyF9gLZG/DGEnVwUGwRsjKaaVUY8jG6ltL9zl4xnoYMPLNlerAyuT0q20ghtZuNJbDq5ePpY+BbfypDHlWk0sZLCsF6fM9SBTFrEA8AgSjHpltaBiWx56+gGs6azu3mStOkGY5l3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcbLam+KjfMfSv7WowGPiQY+m1fdu8EoBt2aG5Z195M=;
 b=RBHGskpOgtSKA6QAAYxvV6TZK7pw293S7GqyYReibcGLQ/YQMzMM9bV9Z9K7waXmtEOZECSInMZC5DBbk2HGbp2/63twsj5tSe037y3nE631JlybrYumNsv2t+WvOHXY6Ft9PXtvoodZ6GFp7gATURsLfe8IOlmA8t2pdq+uAo6alrvthKJchFFprgKNMnEIxDYqQqlK1csmhEvZXR35Dco79DVc18cpaqkZzC8d8ZWG0J8rFZZndpbS4tNUYX8GY6FFLtyOajOQHRri6614z7a155Fx3pP/EKYkZZeNRz0MmhxLQy4vzZyoQ+jO0uHnDcnzcta3Vd3W4TCsgnvJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcbLam+KjfMfSv7WowGPiQY+m1fdu8EoBt2aG5Z195M=;
 b=r+iZy9ef32TyVZXyD+tI7/dSIsx+RKVFmYDjIUY6BzC/szNodmpezNoYIMGY/lv3hJBrng9IxOacLR12csACzh4M1FLXUcJeiyYkSrBFDgTVafgveCaefDkXbptzA/CmL3luYkUrDRd4cRyPFM+rusrRiYy26iAFeIiluptEABU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5859.eurprd05.prod.outlook.com (20.178.117.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 16:13:28 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 16:13:28 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXE627FcLaFBgXUa8jSc95m92WKcOy/4AgAAKv2CAAAYaAIAAQtGAgAAMQNA=
Date:   Tue, 27 Aug 2019 16:13:27 +0000
Message-ID: <AM0PR05MB486671BB1CD562D070F0C0F2D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
        <20190827122928.752e763b.cohuck@redhat.com>
        <AM0PR05MB486621458EC71973378CD5A0D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190827132946.0b92d259.cohuck@redhat.com> <20190827092855.29702347@x1.home>
In-Reply-To: <20190827092855.29702347@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11d33b6d-5616-4e8b-ef79-08d72b097f41
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB5859;
x-ms-traffictypediagnostic: AM0PR05MB5859:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5859DE16C9A362115B568C37D1A00@AM0PR05MB5859.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(13464003)(199004)(189003)(2906002)(55016002)(52536014)(5660300002)(6246003)(86362001)(6436002)(478600001)(26005)(81166006)(81156014)(186003)(76116006)(9456002)(256004)(14444005)(8676002)(3846002)(66946007)(66446008)(64756008)(66476007)(66556008)(9686003)(6116002)(476003)(66066001)(486006)(446003)(11346002)(110136005)(76176011)(25786009)(7736002)(305945005)(316002)(229853002)(53936002)(99286004)(7696005)(6506007)(14454004)(53546011)(55236004)(71190400001)(8936002)(71200400001)(4326008)(54906003)(102836004)(33656002)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5859;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h0wkPqLyF3YCufdgWpXJ5fmeJPYCw8bRdlZh6JVerDA/cy6Zcl0IpYtmqFz6V3yoscwXhYg22hTni0VacBNaoXmD0BWGM1Bx+PXVuKdzth3jrFBDvvcK7iV/6TmlNith6U0GMc1n5nkQKSo3pDtpWA97bkx8N31uPo11Y1GbkYkJpNSb2L4to2kA9AgndcmwAa2w9OUAgc8R3jnzIhonzmQ0k9S+SctceG7EMqqX0ffRK590WzgqK2490JVjDPOfWijNNudn6kmS4satrvXqcEdGT214Lu77ag+54z35YYXcC071SbV8eCKeYqXluflcvCCYu5Exmq4vNGBHi5XQFajocR3aMiLiEmwoY2dotJGc0mxoRIQsXpl8PVCcALqvaoOsP0JFMXVT69vrmLf4HOVKVH6A8z35CsqlZP30f7k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d33b6d-5616-4e8b-ef79-08d72b097f41
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 16:13:28.2843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jo4GlrF7z6EYVqMeramNFCgWIC9iGwOT7/GrlVFp0AoIXAvOsxNFA82bQgR+/mNaFXWG2vlF4Ogpr53Slbu30Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5859
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 27, 2019 8:59 PM
> To: Cornelia Huck <cohuck@redhat.com>
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
>=20
> On Tue, 27 Aug 2019 13:29:46 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>=20
> > On Tue, 27 Aug 2019 11:08:59 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >
> > > > -----Original Message-----
> > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > Sent: Tuesday, August 27, 2019 3:59 PM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all
> > > > mdevs
> > > >
> > > > On Mon, 26 Aug 2019 15:41:17 -0500 Parav Pandit
> > > > <parav@mellanox.com> wrote:
> > > >
> > > > > Mdev alias should be unique among all the mdevs, so that when
> > > > > such alias is used by the mdev users to derive other objects,
> > > > > there is no collision in a given system.
> > > > >
> > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > ---
> > > > >  drivers/vfio/mdev/mdev_core.c | 5 +++++
> > > > >  1 file changed, 5 insertions(+)
> > > > >
> > > > > diff --git a/drivers/vfio/mdev/mdev_core.c
> > > > > b/drivers/vfio/mdev/mdev_core.c index e825ff38b037..6eb37f0c6369
> > > > > 100644
> > > > > --- a/drivers/vfio/mdev/mdev_core.c
> > > > > +++ b/drivers/vfio/mdev/mdev_core.c
> > > > > @@ -375,6 +375,11 @@ int mdev_device_create(struct kobject *kobj,
> struct
> > > > device *dev,
> > > > >  			ret =3D -EEXIST;
> > > > >  			goto mdev_fail;
> > > > >  		}
> > > > > +		if (tmp->alias && strcmp(tmp->alias, alias) =3D=3D 0) {
> > > >
> > > > Any way we can relay to the caller that the uuid was fine, but
> > > > that we had a hash collision? Duplicate uuids are much more obvious=
 than
> a collision here.
> > > >
> > > How do you want to relay this rare event?
> > > Netlink interface has way to return the error message back, but sysfs=
 is
> limited due to its error code based interface.
> >
> > I don't know, that's why I asked :)
> >
> > The problem is that "uuid already used" and "hash collision" are
> > indistinguishable. While "use a different uuid" will probably work in
> > both cases, "increase alias length" might be a good alternative in
> > some cases.
> >
> > But if there is no good way to relay the problem, we can live with it.
>=20
> It's a rare event, maybe just dev_dbg(dev, "Hash collision creating alias=
 \"%s\"
> for mdev device %pUl\n",...
>=20
Ok.
dev_dbg_once() to avoid message flood.

> Thanks,
> Alex
>=20
> > > > > +			mutex_unlock(&mdev_list_lock);
> > > > > +			ret =3D -EEXIST;
> > > > > +			goto mdev_fail;
> > > > > +		}
> > > > >  	}
> > > > >
> > > > >  	mdev =3D kzalloc(sizeof(*mdev), GFP_KERNEL);
> > >
> >

