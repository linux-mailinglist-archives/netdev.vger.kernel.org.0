Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6E9E73F
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 14:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfH0MAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 08:00:40 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:42801
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728807AbfH0MAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 08:00:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haRprdXiQVAn0X2zlhGgQqqFH7YocA7rEGei3qbI3olIwJEj74so0KbAbZ5m4bbGHr1is0/kZwN3Vpkep7YRzWuZOZAK1aKSa/Pkm1/wr0fUMlN7W/rdXvfU4XWnDkZg+gc17IjosGQ1Vtbak2qI3bjI/5iP8XzTmArhV/+TlLapC7IKzF82tgw9F0wUaaFTud0KlINoksWI6HNQ6wyLMbqNRgFTOU9Oh7DidCAzzwHmw3SbI4W8jKd/18xhy5bVzByrE4B8WV8hDrGnZra0lF0mtSaNpTNV8/W3oVHW6qs4EyO+Sd0At1aL866OQuWA16y4OWukPdnbyVzm7OIZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj/u6NagFVY2FxCshVAZbyh5dZkpAoB26+lNMa19BRc=;
 b=QW7a6rQ5GfKunraPwVvGWBz6jk55K7PBi7kcwPO9fDF8MVNxZK7ZEttvnsh8CsaKnCEOloMGETe4l4HT8NEforavfjGnJoUMOjI88hehLXUXTbBpRFQsiOuevWAvkG4iGDQrC/s3WTW0zCpYLY5ruuGSZ7emUTjDnIiFm1HOPBFLTwdPCMLwDx8CtagNte+GvRUYH2Qf3xD4qMd/ALSIF3LP47Fl9gvkQfORU/5Xw/3yeKVYvKzXXYKTsUIbowVsoJYXX9fN+kCE0agIvp8IWybkL23/7vyOU1PxSh8SAhC34RZ/JscO0rVa61UkOALrxLXpegMT9NA43heEEzRXGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj/u6NagFVY2FxCshVAZbyh5dZkpAoB26+lNMa19BRc=;
 b=aAC2v3/IG5WBscgBH+XQKZ5uT3WlHQ26kjvxSP1i+zMBr9+2YtwzvdNKQba1svVWNiQpc/32BmfdY4TbaF/NoO6aOKe2B4SiAQW808QkO3SfOYr3DwYoleFKZoDrGhRfswDutOcLM0/b0lf3OHxygip4lq2nTk9L31dfaxr2sAU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6723.eurprd05.prod.outlook.com (10.186.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 12:00:34 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 12:00:34 +0000
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
Thread-Index: AQHVXE6v3Mg2zMVvBUG6schRq+9Lx6cO0OsAgAADYqCAAAnfAIAABFHggAABh4CAAAC7kA==
Date:   Tue, 27 Aug 2019 12:00:34 +0000
Message-ID: <AM0PR05MB4866E222E33DBD4C40A7EA9CD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-4-parav@mellanox.com>
        <20190827124706.7e726794.cohuck@redhat.com>
        <AM0PR05MB4866BDA002F2C6566492244ED1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190827133432.156f7db3.cohuck@redhat.com>
        <AM0PR05MB4866FD2DB357C5EB4A7A75ADD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827135527.7c9d3940.cohuck@redhat.com>
In-Reply-To: <20190827135527.7c9d3940.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5612809c-fc47-42cc-c16e-08d72ae62acb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6723;
x-ms-traffictypediagnostic: AM0PR05MB6723:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6723310ECBEF63CDB72B72D3D1A00@AM0PR05MB6723.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(199004)(13464003)(189003)(71190400001)(71200400001)(66946007)(66446008)(66476007)(64756008)(66556008)(52536014)(2906002)(5660300002)(54906003)(256004)(76116006)(14454004)(305945005)(33656002)(66066001)(74316002)(7736002)(478600001)(26005)(53936002)(9686003)(446003)(486006)(11346002)(476003)(86362001)(6436002)(81166006)(4326008)(55016002)(99286004)(8936002)(7696005)(6116002)(76176011)(102836004)(55236004)(6506007)(229853002)(53546011)(25786009)(9456002)(6246003)(8676002)(316002)(6916009)(186003)(3846002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6723;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1rZmT1YRi8z1aZ23bsP83EGRXLj8ezbl5/kDYP8kpQsSI0Cab3s/XMyVFhZHFXo/bmnD1Z8k8SJKZGS7KYvcHqaYOQKPLkngM5Xw64FcAud2be81cmoKamPrO/y4XEgUc7RyvENpYOCI/iGEobxayGiEF1KWr9v6m8uhTfheXsSKkiHfD5qot46RQ3qhtvsPkOf09zNhb/TokL8YaTmI+GM6E219h4yAJ8JifoYslJLQadOjjjZwt6fJuE8PXxNGxQQAJwT+YeDrjjGnXoV+MSgBbs8gM9+oIsz0ecKE54YGndbjKfKLIu4KzFEuIF8wcnu78fqfEDZb8EJ34m1iPkfsbwNj+glxBBYd1RcwmCyDNJe0ls7P6oox5a9Tr5vs9hZ8xqZx6ZhEgyuJ0Jca6QhLZ2xNLNsULIw8lRTyDZs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5612809c-fc47-42cc-c16e-08d72ae62acb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 12:00:34.4256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jja7uYs026N8z9mkKdZwoxLCsOgyEr7WCviC5i8Dbogu+++vx0edG47TBwOHTlj+6U/X5FQVU45XHp7KJtTSsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6723
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 5:25 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
>=20
> On Tue, 27 Aug 2019 11:52:21 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Tuesday, August 27, 2019 5:05 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
> > >
> > > On Tue, 27 Aug 2019 11:07:37 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > Sent: Tuesday, August 27, 2019 4:17 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH 3/4] mdev: Expose mdev alias in sysfs tree
> > > > >
> > > > > On Mon, 26 Aug 2019 15:41:18 -0500 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > >
> > > > > > +static ssize_t alias_show(struct device *device,
> > > > > > +			  struct device_attribute *attr, char *buf) {
> > > > > > +	struct mdev_device *dev =3D mdev_from_dev(device);
> > > > > > +
> > > > > > +	if (!dev->alias)
> > > > > > +		return -EOPNOTSUPP;
> > > > >
> > > > > I'm wondering how to make this consumable by userspace in the
> > > > > easiest
> > > way.
> > > > > - As you do now (userspace gets an error when trying to read)?
> > > > > - Returning an empty value (nothing to see here, move along)?
> > > > No. This is confusing, to return empty value, because it says that
> > > > there is an
> > > alias but it is some weird empty string.
> > > > If there is alias, it shows exactly what it is.
> > > > If no alias it returns an error code =3D unsupported -> inline with
> > > > other widely
> > > used subsystem.
> > > >
> > > > > - Or not creating the attribute at all? That would match what use=
rspace
> > > > >   sees on older kernels, so it needs to be able to deal with
> > > > > that
> > > > New sysfs files can appear. Tool cannot say that I was not
> > > > expecting this file
> > > here.
> > > > User space is supposed to work with the file they are off interest.
> > > > Mdev interface has option to specify vendor specific files, though
> > > > in usual
> > > manner it's not recommended.
> > > > So there is no old user space, new kernel issue here.
> > >
> > > I'm not talking about old userspace/new kernel, but new userspace/old
> kernel.
> > > Code that wants to consume this attribute needs to be able to cope
> > > with its absence anyway.
> > >
> > Old kernel doesn't have alias file.
> > If some tool tries to read this file it will fail to open non existing =
file; open()
> system call is already taking care of it.
>=20
> Yes, that was exactly my argument?
I misunderstood probably.
I re-read all 3 options you posted.
I do not see any issue in reporting error code similar to other widely used=
 netdev subsystem, hence propose what is posted in the patch.

