Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3306C9E6D7
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfH0LeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:34:01 -0400
Received: from mail-eopbgr10072.outbound.protection.outlook.com ([40.107.1.72]:42754
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfH0LeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:34:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfUAa4sUQXQutHBznUWvMQs0JDkgre1aDnKsUDsy3xXhgJqT9LY9Nxb6q6zzCMy4t3YIv+Kjcr5bDDItPNPJ0r2SKERF2gbHoLuLA/c7Mn1QfJjgYt8hrk2+mLHZCt+/bWorn9WA6tikiFMxxVDTvDw6MYUBr0Py+Q/sy6rxdrAv7MaEoVwmBAHv5PMV8ooNxf5LqhTzzn0sL72RvEwL8AjS4mGtamt23EInB23oUsapV7yyR/cmW30xF7BrldWbYRSzr8okAZy1r6xrkSQqMZHhrg5ppTuGQwbWpkhdCbKbXdBsP27EJ5B9e+e2PWcvghAYPLxrNjoStCxuNDxuRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz6lgA0mOgsK0sOBo19L4y2s9EaT54T25PxnQzZelas=;
 b=BmF6QyR0ducU62WNZDCt4r0YEHfUJCt6vCRNti4hwYp5NsE+7okQYAm0n7o2XR0tEivv0Pu833p5KsbRAFQBO/wtXZHxhNb44tuben/SRm/m2dKRT+xgurNfizQbpkBAhHpSg7fYU8UgVNleQSBBVSttaSgtOfwnWCYqQpt1YoK1Klxwej5geKKvBbk+bEpwyWdDII81DWI8nzXVhgq0a2u/r1Cv6/Nq1O3r5AQ8lT6J9lv4PlcAJtZ55V2XTWv2728tq92uitywLaWQBJt1qVKAvL1B7mD8myBRRpjthhqGZyyIh6RU3p/8EXOJZJWSNJIxJ58Rm/558SJPtjdC6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz6lgA0mOgsK0sOBo19L4y2s9EaT54T25PxnQzZelas=;
 b=pxLNFhSC+rY2L+1NFE0L417jFqvbFsQWzY91sHO6lRDTaGgXZDXwI5bkfN8thShTXWD0WmNHMQquAlxochfOMHaOrFwYJf6BSqmnagDpybJPZZ2l5Tze72fAYjiLg/cKpzehzk0DYKYWy+ECAnwh4J4GgCEZi/OG7OOrJznkb84=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4275.eurprd05.prod.outlook.com (52.134.91.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 27 Aug 2019 11:33:54 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:33:54 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXE6sjQlIhIUUgkClKEYpCVnoRKcOypkAgAAMheCAAAQiAIAAAZ8Q
Date:   Tue, 27 Aug 2019 11:33:54 +0000
Message-ID: <AM0PR05MB4866CC932630ADD9BDA51371D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
        <20190827122428.37442fe1.cohuck@redhat.com>
        <AM0PR05MB4866B68C9E60E42359BE1F4DD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827132404.483a74ad.cohuck@redhat.com>
In-Reply-To: <20190827132404.483a74ad.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2e7be19-3cbf-4ec7-6ec3-08d72ae27105
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4275;
x-ms-traffictypediagnostic: AM0PR05MB4275:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4275C14D498E341229882F90D1A00@AM0PR05MB4275.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(189003)(13464003)(199004)(102836004)(53546011)(6506007)(2906002)(256004)(14444005)(4326008)(76176011)(3846002)(5660300002)(476003)(25786009)(99286004)(8676002)(81156014)(81166006)(52536014)(305945005)(54906003)(6116002)(7696005)(55236004)(7736002)(66066001)(14454004)(478600001)(66446008)(64756008)(76116006)(6436002)(66476007)(86362001)(74316002)(33656002)(9456002)(55016002)(316002)(9686003)(229853002)(11346002)(486006)(26005)(6916009)(446003)(53936002)(8936002)(71190400001)(71200400001)(6246003)(66556008)(66946007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4275;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xCyOmGQjQcANQy4UQ6SkASZ+3ahFF385x599ai/XjeVHBiLqhCRZ32I2xSJKbNo92YEghZaaxpu+iU/d4IzSATU41Ed4ujBKsXj5X35l3UGCQLtDvOHwuYRxNnNxuEO6j9bzGuzCVU8eGoo6kxx8UlhrBcWqvasroCgI+/y8crkSA7PkzYeRngvn2iJCpbpE/uE4+2CJlQa5YFZd8DrJdYwcMoF1iBRkd0IQkmrpFa8nUQtZVXCVwBixbgS3RHj28XJFL/N76XTdSkECAK37R7FaYKnsB0pMe9StWDE8ePy19u5411x+X82niutA7cFFnZNOxkuldSF7+NTV6ZBYs8aN13xS2/IBz7y8rIfnwdrv9qUTDKOJODUqEmll8w2wVlGl22qg2Mmu9SQn2QwGRiP7CS3EIUcROBim72jtmBo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e7be19-3cbf-4ec7-6ec3-08d72ae27105
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:33:54.2491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B4Cv4jvIGbnT/P0mXy0W4NDsZbO0RhqkHHl9metNoRqa/aw30vSDFbI7LoUZHWHJpfRqv7/8hS/IU+mFztKqyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4275
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 4:54 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
>=20
> On Tue, 27 Aug 2019 11:12:23 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Tuesday, August 27, 2019 3:54 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
> > >
> > > On Mon, 26 Aug 2019 15:41:16 -0500
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > Whenever a parent requests to generate mdev alias, generate a mdev
> > > > alias.
> > > > It is an optional attribute that parent can request to generate
> > > > for each of its child mdev.
> > > > mdev alias is generated using sha1 from the mdev name.
> > >
> > > Maybe add some motivation here as well?
> > >
> > > "Some vendor drivers want an identifier for an mdev device that is
> > > shorter than the uuid, due to length restrictions in the consumers of=
 that
> identifier.
> > >
> > > Add a callback that allows a vendor driver to request an alias of a
> > > specified length to be generated (via sha1) for an mdev device. If
> > > generated, that alias is checked for collisions."
> > >
> > I did described the motivation in the cover letter with example and thi=
s
> design discussion thread.
>=20
> Yes, but adding it to the patch description makes it available in the git=
 history.
>=20
Ok.

> > I will include above summary in v1.
> >
> > > What about:
> > >
> > > * @get_alias_length: optional callback to specify length of the alias=
 to
> create
> > > *                    Returns unsigned integer: length of the alias to=
 be created,
> > > *                                              0 to not create an ali=
as
> > >
> > Ack.
> >
> > > I also think it might be beneficial to add a device parameter here
> > > now (rather than later); that seems to be something that makes sense.
> > >
> > Without showing the use, it shouldn't be added.
>=20
> It just feels like an omission: Why should the vendor driver only be able=
 to
> return one value here, without knowing which device it is for?
> If a driver supports different devices, it may have different requirement=
s for
> them.
>=20
Sure. Lets first have this requirement to add it.
I am against adding this length field itself without an actual vendor use c=
ase, which is adding some complexity in code today.
But it was ok to have length field instead of bool.

Lets not further add "no-requirement futuristic knobs" which hasn't shown i=
ts need yet.
When a vendor driver needs it, there is nothing prevents such addition.

> >
> > > >   * Parent device that support mediated device should be
> > > > registered with
> > > mdev
> > > >   * module with mdev_parent_ops structure.
> > > >   **/
> > > > @@ -92,6 +95,7 @@ struct mdev_parent_ops {
> > > >  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> > > >  			 unsigned long arg);
> > > >  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct
> > > *vma);
> > > > +	unsigned int (*get_alias_length)(void);
> > > >  };
> > > >
> > > >  /* interface for exporting mdev supported type attributes */
> >

