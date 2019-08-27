Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71229E673
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfH0LHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:07:44 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:58909
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbfH0LHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:07:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWZ+Cb5ndBihBx7PkZSoa3hWOpk5KUTC51Ttp7749GwDfU9UNeGq67AXU4Ek8OCJNbACfpj11yGbEWaoZTBrAsFYmxZKIiGC0EyC52IoTqjUXdfb3nWabb9dVXyLCYrm3CY0+s18KQeYe9e6AVzind7r/jUrg55M/2YutDQ1DlEN/51Rxe7/gh9MQ2oejBDwoPIJ0ppPlLsITIspnjkfXu5ElyON2/K+2DLj24xzmbwKnqhHH8ZYzkiyqIWuzG0aEOfYUOoLRyXR11pyjV8wKwU/cCzUdAACxfWnOywNcJXbLKnWPbLUU2B3kbfUND385K5rVxGqjHPyhd9iaSx6UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xH1AJFnxKPCkY8v1U0WREwsXpyJ/ATUr02WiF3gcuc=;
 b=bSvh32BaYMmjbHMVBOT1Xg/aDAYMEpwnvKiCUX6Y1jfAw/uWiB9bF6hWV18yrB7C1mRPbYvp3VGemqf+yajstOBimTmFkSrD0CrmvPofH301KAN4zh7oeVtdEJXj0rgkIkyxj0PvKOJDgvWmnVxIhPiOtQMjmucqqbIQOzZmTFp4FKkRvumGjrePT/v7i3Wknd22OMLRf2O2MGHnc87O0ivjCZTrxJ+u+t9RhoVDqjfBomEjkTHQZON+7Gh2Nf83BKIB7r+M2uBGYFvIuHuj6yD4y4Wm8fNL6wJRrVpY+/SZEXYjrNedHX9FlnjgaL86qfy+8DyMHCgGZMX0hDdnMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xH1AJFnxKPCkY8v1U0WREwsXpyJ/ATUr02WiF3gcuc=;
 b=YWdEpBvOwU8qIgxsKGt9hA+/EFdcoU1XVSwlVOFn+TRf48E8ET+pasb0M8zSS4Qx+hNTVFda2cqzMQQpS7XbxnD2V1xH5za/xIAq6EPotV5x90i4nzLOfl7PDenQSLpg1hOeGHPNXUUDO4XhUWHiBP4F6UpMQD4Qo/QPHYpuoXU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4161.eurprd05.prod.outlook.com (52.134.91.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 11:07:37 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:07:37 +0000
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
Thread-Index: AQHVXE6v3Mg2zMVvBUG6schRq+9Lx6cO0OsAgAADYqA=
Date:   Tue, 27 Aug 2019 11:07:37 +0000
Message-ID: <AM0PR05MB4866BDA002F2C6566492244ED1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com>
 <20190827124706.7e726794.cohuck@redhat.com>
In-Reply-To: <20190827124706.7e726794.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5556892f-a1f4-47ab-a094-08d72adec557
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4161;
x-ms-traffictypediagnostic: AM0PR05MB4161:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4161D6E86E47BAF73C5F78D2D1A00@AM0PR05MB4161.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(13464003)(199004)(189003)(486006)(305945005)(446003)(11346002)(52536014)(66476007)(66556008)(64756008)(66446008)(66946007)(476003)(53546011)(71200400001)(76116006)(6506007)(71190400001)(26005)(66066001)(55016002)(9686003)(76176011)(86362001)(7736002)(6436002)(7696005)(74316002)(5660300002)(99286004)(478600001)(33656002)(256004)(102836004)(14454004)(55236004)(54906003)(6116002)(6916009)(4326008)(186003)(53936002)(6246003)(8936002)(81156014)(8676002)(81166006)(9456002)(229853002)(2906002)(316002)(25786009)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4161;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0G+y+z3NBeoR7YNkbTXoowf3yq67wyFTuYm+jaTtUDu9QHuc1FWzRg8ziOa+rcnqxE02lM83rpg4018KfCXzqIScZNDoslVD0+lrwkbny0zb/8xwtkBaKok4QF4Q5b7T+u6mpTKl9mo4cg2pd3xwdewt/sDNxAmO4iHzAf4vGhWaV9VsyC8wNA5T3emXTpoy3tRWikyAe1KEbS7JHh/NhZVvFV3YC0KZxlX97qhRDHHPozsqVzRQDbvPjoheIFpldlsL0bxHKlLqTxGIXTeiR33uCaeg2Q4pb4KAOuCkeRs7rVcG9Qvz6Qu46ffnRyKveoeLfZQQL+HOp5/zRWgeao2lAYH7bmJDWjXnqWrh15FW4vM4oCdh6Hxfe7TM9oIHw+dklq8dabgCUoQRlcLb4TI6D130Fwu5JJEU4+sy8UI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5556892f-a1f4-47ab-a094-08d72adec557
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:07:37.7315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gMkHqIWT7VWd931RprbzlvnRRInXkrghuADpYRQ2PFNGYeI0EOhLE7E+z7HTXvp15hjhVGWJXLpws7arHi7gxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 4:17 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
>=20
> On Mon, 26 Aug 2019 15:41:18 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Expose mdev alias as string in a sysfs tree so that such attribute can
> > be used to generate netdevice name by systemd/udev or can be used to
> > match other kernel objects based on the alias of the mdev.
>=20
> What about
>=20
> "Expose the optional alias for an mdev device as a sysfs attribute.
> This way, userspace tools such as udev may make use of the alias, for exa=
mple
> to create a netdevice name for the mdev."
>=20
Ok. I will change it.

> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_sysfs.c | 13 +++++++++++++
>=20
> I think the documentation should be updated as well.
>=20
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> > b/drivers/vfio/mdev/mdev_sysfs.c index 43afe0e80b76..59f4e3cc5233
> > 100644
> > --- a/drivers/vfio/mdev/mdev_sysfs.c
> > +++ b/drivers/vfio/mdev/mdev_sysfs.c
> > @@ -246,7 +246,20 @@ static ssize_t remove_store(struct device *dev,
> > struct device_attribute *attr,
> >
> >  static DEVICE_ATTR_WO(remove);
> >
> > +static ssize_t alias_show(struct device *device,
> > +			  struct device_attribute *attr, char *buf) {
> > +	struct mdev_device *dev =3D mdev_from_dev(device);
> > +
> > +	if (!dev->alias)
> > +		return -EOPNOTSUPP;
>=20
> I'm wondering how to make this consumable by userspace in the easiest way=
.
> - As you do now (userspace gets an error when trying to read)?
> - Returning an empty value (nothing to see here, move along)?
No. This is confusing, to return empty value, because it says that there is=
 an alias but it is some weird empty string.
If there is alias, it shows exactly what it is.
If no alias it returns an error code =3D unsupported -> inline with other w=
idely used subsystem.

> - Or not creating the attribute at all? That would match what userspace
>   sees on older kernels, so it needs to be able to deal with that
New sysfs files can appear. Tool cannot say that I was not expecting this f=
ile here.
User space is supposed to work with the file they are off interest.
Mdev interface has option to specify vendor specific files, though in usual=
 manner it's not recommended.
So there is no old user space, new kernel issue here.

>   anyway.
>=20
> > +
> > +	return sprintf(buf, "%s\n", dev->alias); } static
> > +DEVICE_ATTR_RO(alias);
> > +
> >  static const struct attribute *mdev_device_attrs[] =3D {
> > +	&dev_attr_alias.attr,
> >  	&dev_attr_remove.attr,
> >  	NULL,
> >  };

