Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF86A376E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 15:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfH3M75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:59:57 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:64494
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727522AbfH3M75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:59:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfpA1C3nRECZCZE6td0lZtzro2O4/h9/QfzobNocBUff8wUC7BC4ERFXOLiTALjAJqtNPb/vyVqGwdhWpD2vY2z5FJamndIXh8uaZKvKxk8Th1d8+5uBAeLHv/SmrnoRUuOVrp7oSNYaNAoQYqnRZhZkXEDQBWv6VMiV7su1wvphbFxAp8Eywu/i9GGEwEMvNkFp56KgsqkspbI9TOK8molCDujroMOt+H6ZbGyP4RXSt4g0ItiuD7xRPgPpuxcGJWZk1zuSY8+28wg2Y0S4vx2LNMbWXxUgAjq27+ONAPQ7SsJ+Ca5/FDayyzsSSk6yzzHFvuH9LI8X6Jt/51GnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KNvjGEJsO0wUPqkpErGC6infHvjao2A4OObnXJ0yPM=;
 b=ga7m1WLgdGMmy6TdJmI6+t8h0xDYeTAMuGB/Gka6b7t5qQwVGjAmLFqFlm1BSx7ZZ5ZKO27GREmeRRZx1Ci73Wkltqsho9xNb+qx4uHqmbyA0T6inZz5gGSKC8WAO/7z4K+NbXDWQBwd6a9z2dh7qmllKrmWfnYTj4NUyumf5GB4EopTZ8TNjho5YKtfLHu9wsYhkBlsf+gTFH9guxjFc1U8FztyNKGw+xfacJLaVSgQGpfum/70O66fdWGpjh+oycmj6u4eny/7EbZSRcNQ3qdRUbW5JNE2vCc7W+rpIvo/8JEyxALLy7Kn5ggLaWXjapy0FvML3ge4jNx/62DnVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KNvjGEJsO0wUPqkpErGC6infHvjao2A4OObnXJ0yPM=;
 b=EvI7EYyCQ16X6jztFNY9QSgWmjJMXRQtH4O+XbiaLqNImRp9FpZ6f9gGVdAa7o2YO8dLmL/pVBXIH+s6dvUwdVPgitokwP3USCAE9wJ/x4FDFT70vydUp0xqCNlgTQYKHy5tNsyyT89zGgUK0q8ifzZnNcnlFCnO/J/G2+KWmr0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5073.eurprd05.prod.outlook.com (20.177.41.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Fri, 30 Aug 2019 12:59:49 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 12:59:49 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 2/6] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH v2 2/6] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXluj2Coi5xiSw0C4zJLLU40uracTo5kAgAAE2sA=
Date:   Fri, 30 Aug 2019 12:59:49 +0000
Message-ID: <AM0PR05MB4866DAABF1711069899FEC67D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-3-parav@mellanox.com>
 <20190830144052.11d23ec3.cohuck@redhat.com>
In-Reply-To: <20190830144052.11d23ec3.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05224749-e52d-4d01-b76e-08d72d49f0ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5073;
x-ms-traffictypediagnostic: AM0PR05MB5073:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5073B2918A93544521FE935FD1BD0@AM0PR05MB5073.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(199004)(189003)(13464003)(54534003)(256004)(4326008)(66556008)(66476007)(64756008)(76116006)(66946007)(6246003)(2906002)(86362001)(508600001)(66066001)(76176011)(71190400001)(71200400001)(25786009)(102836004)(66446008)(229853002)(186003)(5660300002)(7696005)(6916009)(6506007)(53936002)(476003)(9686003)(6436002)(11346002)(53546011)(446003)(55016002)(486006)(55236004)(316002)(305945005)(99286004)(14454004)(52536014)(26005)(81166006)(74316002)(3846002)(9456002)(6116002)(81156014)(8676002)(14444005)(7736002)(54906003)(8936002)(33656002)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5073;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g71Uf4eoUZT+9hRC4heqNwK73PZanUIZ4AF5dXvRFBrnQ6piGtTFFgAOUQmjaQEslbJnlArGHOpRcuSDp5RpycxM13oPw2FkQxLsiKU9ZQy1msMVyrAEr6gXUXgHt26gHcifkKAEZ68rAyzY1ziHg5UY2gcebD8oj7+rYUYGSGcLvc2IOSvheY/MC0XeXN/+4xfLqF+6b3tXjhqRMqTFa2eXpFYiWz6w3hbjJA1fPsYA/QNAhI5N//LDeoaLDXdK6Nf57+j4uyzfN89Y+vSSql2HmrK+KYRwXrF3WuLBGKCFMbugvseKpBcEi6szhEQg4t7MCapkf0NXEN98OVsc91Df0SSJN3Dm9sCAbzt8pph2PqdsssVC4LrFsA9hPPGCuN4yiA8+21rlkupBOmxuDZBXIxrDy/LUADP5pDzJq0zufavP/Fv4QI7XzkKvH7sQwElw6e2Tu3BZOIV72btXYQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05224749-e52d-4d01-b76e-08d72d49f0ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:59:49.1876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nBxe0JYrypFK71JGjdufEPIuSK3uZztKMBTM5tiUR4+ht+mmIqQYVl68Tc1+l5hYrThB2uJP6CL7V2q2G2KZQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, August 30, 2019 6:11 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 2/6] mdev: Make mdev alias unique among all mdevs
>=20
> On Thu, 29 Aug 2019 06:19:00 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Mdev alias should be unique among all the mdevs, so that when such
> > alias is used by the mdev users to derive other objects, there is no
> > collision in a given system.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> >
> > ---
> > Changelog:
> > v1->v2:
> >  - Moved alias NULL check at beginning
> > v0->v1:
> >  - Fixed inclusiong of alias for NULL check
> >  - Added ratelimited debug print for sha1 hash collision error
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index 3bdff0469607..c9bf2ac362b9
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -388,6 +388,13 @@ int mdev_device_create(struct kobject *kobj, struc=
t
> device *dev,
> >  			ret =3D -EEXIST;
> >  			goto mdev_fail;
> >  		}
> > +		if (alias && tmp->alias && strcmp(alias, tmp->alias) =3D=3D 0) {
> > +			mutex_unlock(&mdev_list_lock);
> > +			ret =3D -EEXIST;
> > +			dev_dbg_ratelimited(dev, "Hash collision in alias
> creation for UUID %pUl\n",
> > +					    uuid);
> > +			goto mdev_fail;
> > +		}
> >  	}
> >
> >  	mdev =3D kzalloc(sizeof(*mdev), GFP_KERNEL);
>=20
> Any reason not to merge this into the first patch?
No. It surely can be merged. Its easy to start with smaller patches instead=
 of splitting. :-)
Doing uniqueness comparison was easy to split as independent functionality,=
 so did as 2nd patch.
But either way is ok.

