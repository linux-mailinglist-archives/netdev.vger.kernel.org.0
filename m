Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 959EA9F2BA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbfH0SyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:54:21 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:64679
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbfH0SyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 14:54:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD+P/843vnlcE7Nk5BIa2/xnLfFJPkWUq6IsGP0PvkuoKMaf/fLIQTY1X00orwxvMgC+Q+e3ss7C9y685k+ovoHub2cy23GOLyyZZJy0xAQPtyoEp8re6b+LZkpsfcMnNRYO2WqSzvIAxxp1umt5XneOJZ+PJn+jFwAcEZsuQP3+sBepOko8530wmDXNysMJNCem8vxsE/dYUjdSJ20ORZZuOfc1v7nS6xdS7+4l2yPxu5EffZuEDcM+ELIKER/6sL21l4ksu/LjecuY5EHclAqW1z+jNf+RALirUr0XkubZfyZ7YztiWsF6ODLSqLrUUPdVJ171oQ4KXyFt3jElOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXcqgDOgotYwMgYoj93UjZFHnCinMA44xEdTZnLZeR0=;
 b=HnJFfnTjXEa4k0GUNxj8lOrXbxkai78RPhwdQhMf8DXDZxorwbvhf9cQT826+M3jt7aFJV2tMqxfut48xENtJDbfUbc0R2sxoH+udwgwp3TsFqcLjxgt3O9tPr3sSoDj3m57f+aHiGhzgactbqr3orRSNBiprfWrnSYwexpaeoZ7OUxsgsPzBKok82xbEhH/ajiI52lk6VLqiT7LQNcsMHZDZjpcuDFFQ72Cte/e9WEEWCIeNIe7TrNW8s77WpWdCEMVENUloPhYaqOoFqvuXy3bTiNXPvX/nMjg9g4lZOJCV8yQrky5Ug1hSuDDySCk6fioqjcc+bTmtR7pB9IkdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXcqgDOgotYwMgYoj93UjZFHnCinMA44xEdTZnLZeR0=;
 b=iah81Adk8y1ShCltwG+yxk6WGmDU4hwuiC9umtPHM5IqqBeR46jQ2RPEkfqxMG7QBEQXawBfICdcJsg7J7pWx8K5aIGEBuXG/FyinE/Tb4TID4v6Rad2vs3fToMLkYbu8xZ6CbcS8yRIPugH1jaCDUuZrwHcx9CJM2zI23R7b0U=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5922.eurprd05.prod.outlook.com (20.178.119.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 18:54:08 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 18:54:07 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXE627FcLaFBgXUa8jSc95m92WKcOy/4AgAAKv2CAAAYaAIAAQtGAgAAMQNCAAANOgIAAKbIQ
Date:   Tue, 27 Aug 2019 18:54:07 +0000
Message-ID: <AM0PR05MB48669AA6561A70AECEC8A1CFD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
        <20190827122928.752e763b.cohuck@redhat.com>
        <AM0PR05MB486621458EC71973378CD5A0D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190827132946.0b92d259.cohuck@redhat.com>     <20190827092855.29702347@x1.home>
        <AM0PR05MB486671BB1CD562D070F0C0F2D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827102435.7bd30ef3@x1.home>
In-Reply-To: <20190827102435.7bd30ef3@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a429c88b-3c58-4481-5db9-08d72b1ff0c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB5922;
x-ms-traffictypediagnostic: AM0PR05MB5922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5922128E2030B55A6944CDCCD1A00@AM0PR05MB5922.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(189003)(199004)(13464003)(3846002)(86362001)(256004)(14444005)(7736002)(14454004)(486006)(476003)(6916009)(66066001)(66946007)(64756008)(66476007)(66556008)(66446008)(53936002)(4326008)(6246003)(81166006)(81156014)(8676002)(8936002)(71190400001)(54906003)(99286004)(33656002)(26005)(2906002)(76116006)(186003)(5660300002)(305945005)(25786009)(446003)(9456002)(478600001)(55016002)(229853002)(6436002)(11346002)(9686003)(102836004)(316002)(76176011)(52536014)(71200400001)(7696005)(55236004)(53546011)(6506007)(74316002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5922;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SmnCnVty3ze4OWNY0srslW8qb6+c0PFTBkTbm1lSRUaJsOpJzwrF5teTU4Jw3AzUftldUs2tLOwtQVAVr0lio29ouLFGatwZnDVh/+/EhvCsVyvsB7OBWnQn8Hi/m8JEXBq7sViO1xmwqlIPl4aYBBHGT7yevfNCH8p8mfs5A3p8RaTFs3Zn4lkPPihzPzL3kqyxhDD/mBDB+WhstV0YxdJo4w+Fhiwkf7YdRCRopAZCwMT4DMlhmP2cCryUgB6LMaAjpsOg8lXE/PoYJNiTGk5N3KjCpn9fZ4jqJmZXxGB+DbyZfVrYorCcVsPBXmGfyLU6lqEvj3KbwbbeeaeAoYABhr0Gd2w3an5la4pIkm3vpdr2l98cABynjZo2q9P4KeNvnMiaxCbAcHtm2DrfA//TrY+6NGlcf+2IlmT1tto=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a429c88b-3c58-4481-5db9-08d72b1ff0c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 18:54:07.7655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JNm5L616CEL7KdWA/+RFsTLbZ+s9jaO9pNLVRdjHv3D1GkzWJ29ywE+D8AWMXLfG5DxdyT96G7MUocOzurGn4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5922
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 27, 2019 9:55 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
>=20
> On Tue, 27 Aug 2019 16:13:27 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, August 27, 2019 8:59 PM
> > > To: Cornelia Huck <cohuck@redhat.com>
> > > Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko
> > > <jiri@mellanox.com>; kwankhede@nvidia.com; davem@davemloft.net;
> > > kvm@vger.kernel.org; linux- kernel@vger.kernel.org;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all
> > > mdevs
> > >
> > > On Tue, 27 Aug 2019 13:29:46 +0200
> > > Cornelia Huck <cohuck@redhat.com> wrote:
> > >
> > > > On Tue, 27 Aug 2019 11:08:59 +0000 Parav Pandit
> > > > <parav@mellanox.com> wrote:
> > > >
> > > > > > -----Original Message-----
> > > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > > Sent: Tuesday, August 27, 2019 3:59 PM
> > > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > > Cc: alex.williamson@redhat.com; Jiri Pirko
> > > > > > <jiri@mellanox.com>; kwankhede@nvidia.com;
> > > > > > davem@davemloft.net; kvm@vger.kernel.org;
> > > > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > > > Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among
> > > > > > all mdevs
> > > > > >
> > > > > > On Mon, 26 Aug 2019 15:41:17 -0500 Parav Pandit
> > > > > > <parav@mellanox.com> wrote:
> > > > > >
> > > > > > > Mdev alias should be unique among all the mdevs, so that
> > > > > > > when such alias is used by the mdev users to derive other
> > > > > > > objects, there is no collision in a given system.
> > > > > > >
> > > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > > > ---
> > > > > > >  drivers/vfio/mdev/mdev_core.c | 5 +++++
> > > > > > >  1 file changed, 5 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/vfio/mdev/mdev_core.c
> > > > > > > b/drivers/vfio/mdev/mdev_core.c index
> > > > > > > e825ff38b037..6eb37f0c6369
> > > > > > > 100644
> > > > > > > --- a/drivers/vfio/mdev/mdev_core.c
> > > > > > > +++ b/drivers/vfio/mdev/mdev_core.c
> > > > > > > @@ -375,6 +375,11 @@ int mdev_device_create(struct kobject
> > > > > > > *kobj,
> > > struct
> > > > > > device *dev,
> > > > > > >  			ret =3D -EEXIST;
> > > > > > >  			goto mdev_fail;
> > > > > > >  		}
> > > > > > > +		if (tmp->alias && strcmp(tmp->alias, alias) =3D=3D 0) {
> > > > > >
> > > > > > Any way we can relay to the caller that the uuid was fine, but
> > > > > > that we had a hash collision? Duplicate uuids are much more
> > > > > > obvious than
> > > a collision here.
> > > > > >
> > > > > How do you want to relay this rare event?
> > > > > Netlink interface has way to return the error message back, but
> > > > > sysfs is
> > > limited due to its error code based interface.
> > > >
> > > > I don't know, that's why I asked :)
> > > >
> > > > The problem is that "uuid already used" and "hash collision" are
> > > > indistinguishable. While "use a different uuid" will probably work
> > > > in both cases, "increase alias length" might be a good alternative
> > > > in some cases.
> > > >
> > > > But if there is no good way to relay the problem, we can live with =
it.
> > >
> > > It's a rare event, maybe just dev_dbg(dev, "Hash collision creating a=
lias
> \"%s\"
> > > for mdev device %pUl\n",...
> > >
> > Ok.
> > dev_dbg_once() to avoid message flood.
>=20
> I'd suggest a rate-limit rather than a once.  The fact that the kernel ma=
y have
> experienced a collision at some time in the past does not help someone
> debug why they can't create a device now.  The only way we're going to ge=
t a
> flood is if a user sufficiently privileged to create mdev devices stumble=
s onto
> a collision and continues to repeat the same operation.  That falls into
> shoot-yourself-in-the-foot behavior imo.
> Thanks,
>=20
Ok. Will do.
