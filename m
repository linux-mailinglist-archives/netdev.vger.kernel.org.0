Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E1DA36DC
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfH3MfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:35:08 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:20421
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727595AbfH3MfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:35:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rvm2DAwnalmhJ3RrDdKTF8i+KYLoX0bQuAR88tgvFY7QAaafsraqK9O63NvvLhiyaoUktTq0Gh1Bv5tkk2hTemnQ3nvXZD3kbmG90mJftNmbdcrfHNPsZuuEDo2aoIn+0FdFPAnC9pPNYNZE/06oIlVmx8n69gIrTkokDvFWwGxbtEo3Bvp8CcVtN+pSoDgHG3yRz4/sb5x8fc2+n7pkWy86eJ/wCo3lg1Sqkc+Jz2KJs52C1Vi05uXw91vfem80E1i8nEuJTxPs16YzFR2TywiPtZMgtrb1AYc0ikFO58LH1t8dnv3j6JzWHWe0D+TQ0tcWwCB1+O1Xjm2OVZIr5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdX37xGidISmglrmzMJPhlohclo9OF05oPjPkZkoMyQ=;
 b=QwMD4LlHoJ/q6JkgC/P0+EePZXhyVOKGIQwK/oyVFVeS/cgVVbMXr8xWHNIYdponzBFagSS9id5X63lyz3mrmW9ZlOOTrmTXMHioUGCWBNBQMul708Ni3Ef6AtN/v3rzvRmI0F/Lbq2eE292hgNK3nJnrUvyWtN++8ml0jWPc5r9YQTwnf5yfNV0sifZ1vcNfQVMl0wgvyG2cFo5l/VxutqpozB5VEvavHq+edhv2GG/i0VDqUn2HkyR7+j6BFPtx6co3fESaLxbqsgVYGp36qon3+5LFqYBr5sqVkzu/Qo8xM0Itu9Kahk1jVllDHByCtYz5nTaPJ0i5XkFrrXa4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdX37xGidISmglrmzMJPhlohclo9OF05oPjPkZkoMyQ=;
 b=nRJJ/YwNcEplsy/GK1UEz2Z2J7gbq+IesbrzZQA3dj0s2PV7cUblqgwvhQAYz4Adis3tJt7ic7g1ptxfUVs6x0TdyZQ4RgSUEKwDS9tiBgyS1mq68ww0kGmYG5H1UDF6oU+h/lKfAnWsbeITa2xsY4zFmlRdBcOYh79xhfrhqAk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6577.eurprd05.prod.outlook.com (20.179.33.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Fri, 30 Aug 2019 12:33:22 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Fri, 30 Aug 2019
 12:33:22 +0000
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
Thread-Index: AQHVXluia2ak8fbBtkW+HkGgDQ+zpacTarsAgAA0s9A=
Date:   Fri, 30 Aug 2019 12:33:22 +0000
Message-ID: <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
 <20190830111720.04aa54e9.cohuck@redhat.com>
In-Reply-To: <20190830111720.04aa54e9.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b732da52-04c3-4037-23d3-08d72d463f08
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6577;
x-ms-traffictypediagnostic: AM0PR05MB6577:|AM0PR05MB6577:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB65770A98E0AAFE5FD9F0A6BDD1BD0@AM0PR05MB6577.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(13464003)(189003)(199004)(54534003)(7696005)(76116006)(81166006)(33656002)(66946007)(66476007)(229853002)(86362001)(2906002)(66066001)(81156014)(8676002)(52536014)(6246003)(66556008)(64756008)(66446008)(53936002)(25786009)(4326008)(9686003)(55016002)(5660300002)(14454004)(508600001)(186003)(53546011)(6506007)(55236004)(102836004)(6916009)(486006)(446003)(14444005)(71200400001)(71190400001)(256004)(26005)(11346002)(6436002)(54906003)(99286004)(316002)(8936002)(9456002)(74316002)(305945005)(76176011)(6116002)(476003)(7736002)(3846002)(79990200002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6577;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /TTA5SVqz0DSiAtaSzz+zP6AirrGu4fUJNreqQPR0sJYhCGSrm3kAv05mIo2gd1hcGiTwU+6bwFJhhQVbfPCMl5es6CVFLOqz/sgA3MI+llWNT1vQp5VmFcCjzbXUoh1kKHSMiXqe0hOxr03BDJ7H8avdjJe8uRzTxe1mZde6q/WCtitxQhUrTjQ3wtsH+vmn1s7CKxBxR+oHlafcu0L9BFpOkT5YUq0QJlgKA67Lt6LY97vT4klcoEgGy0WQtjAVDu2wGwS+pSwE9CZO8MhuQDzvC0t+koLKSRTeLHoN3mteNM1VQLhExdduE8mZLn+sLop1ovO+DL3v3DhW62qXE0S6uVs7pp1yjFm6iYW5l8+IcM9Cl8AQ98ZkVwzPvu27TDRG/ntA/lGtAlQAc7nzYdPNd5GpZDhrXrTLRVfr+7BbKCrhvgQTMBGL5+l1eFRcuNfmudDo2rSVeu5wyasKg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b732da52-04c3-4037-23d3-08d72d463f08
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 12:33:22.2914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D3WxN3nPHWf9iRsldXtLrY99jTZWegTo9JYD6F/6gBfWLIzWugzdIONQHS6dHQ+v9pHZ3cmJ5ZmHrYADk2UfHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6577
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, August 30, 2019 2:47 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
>=20
> On Thu, 29 Aug 2019 06:18:59 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Some vendor drivers want an identifier for an mdev device that is
> > shorter than the UUID, due to length restrictions in the consumers of
> > that identifier.
> >
> > Add a callback that allows a vendor driver to request an alias of a
> > specified length to be generated for an mdev device. If generated,
> > that alias is checked for collisions.
> >
> > It is an optional attribute.
> > mdev alias is generated using sha1 from the mdev name.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> >
> > ---
> > Changelog:
> > v1->v2:
> >  - Kept mdev_device naturally aligned
> >  - Added error checking for crypt_*() calls
> >  - Corrected a typo from 'and' to 'an'
> >  - Changed return type of generate_alias() from int to char*
> > v0->v1:
> >  - Moved alias length check outside of the parent lock
> >  - Moved alias and digest allocation from kvzalloc to kzalloc
> >  - &alias[0] changed to alias
> >  - alias_length check is nested under get_alias_length callback check
> >  - Changed comments to start with an empty line
> >  - Fixed cleaunup of hash if mdev_bus_register() fails
> >  - Added comment where alias memory ownership is handed over to mdev
> > device
> >  - Updated commit log to indicate motivation for this feature
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 123
> ++++++++++++++++++++++++++++++-
> >  drivers/vfio/mdev/mdev_private.h |   5 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> >  include/linux/mdev.h             |   4 +
> >  4 files changed, 135 insertions(+), 10 deletions(-)
> >
>=20
> (...)
>=20
> > +static const char *
> > +generate_alias(const char *uuid, unsigned int max_alias_len) {
> > +	struct shash_desc *hash_desc;
> > +	unsigned int digest_size;
> > +	unsigned char *digest;
> > +	unsigned int alias_len;
> > +	char *alias;
> > +	int ret;
> > +
> > +	/*
> > +	 * Align to multiple of 2 as bin2hex will generate
> > +	 * even number of bytes.
> > +	 */
> > +	alias_len =3D roundup(max_alias_len, 2);
> > +	alias =3D kzalloc(alias_len + 1, GFP_KERNEL);
>=20
> This function allocates alias...
>=20
> > +	if (!alias)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	/* Allocate and init descriptor */
> > +	hash_desc =3D kvzalloc(sizeof(*hash_desc) +
> > +			     crypto_shash_descsize(alias_hash),
> > +			     GFP_KERNEL);
> > +	if (!hash_desc) {
> > +		ret =3D -ENOMEM;
> > +		goto desc_err;
> > +	}
> > +
> > +	hash_desc->tfm =3D alias_hash;
> > +
> > +	digest_size =3D crypto_shash_digestsize(alias_hash);
> > +
> > +	digest =3D kzalloc(digest_size, GFP_KERNEL);
> > +	if (!digest) {
> > +		ret =3D -ENOMEM;
> > +		goto digest_err;
> > +	}
> > +	ret =3D crypto_shash_init(hash_desc);
> > +	if (ret)
> > +		goto hash_err;
> > +
> > +	ret =3D crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
> > +	if (ret)
> > +		goto hash_err;
> > +
> > +	ret =3D crypto_shash_final(hash_desc, digest);
> > +	if (ret)
> > +		goto hash_err;
> > +
> > +	bin2hex(alias, digest, min_t(unsigned int, digest_size, alias_len / 2=
));
> > +	/*
> > +	 * When alias length is odd, zero out an additional last byte
> > +	 * that bin2hex has copied.
> > +	 */
> > +	if (max_alias_len % 2)
> > +		alias[max_alias_len] =3D 0;
> > +
> > +	kfree(digest);
> > +	kvfree(hash_desc);
> > +	return alias;
>=20
> ...and returns it here on success...
>=20
> > +
> > +hash_err:
> > +	kfree(digest);
> > +digest_err:
> > +	kvfree(hash_desc);
> > +desc_err:
> > +	kfree(alias);
> > +	return ERR_PTR(ret);
> > +}
> > +
> > +int mdev_device_create(struct kobject *kobj, struct device *dev,
> > +		       const char *uuid_str, const guid_t *uuid)
> >  {
> >  	int ret;
> >  	struct mdev_device *mdev, *tmp;
> >  	struct mdev_parent *parent;
> >  	struct mdev_type *type =3D to_mdev_type(kobj);
> > +	const char *alias =3D NULL;
> >
> >  	parent =3D mdev_get_parent(type->parent);
> >  	if (!parent)
> >  		return -EINVAL;
> >
> > +	if (parent->ops->get_alias_length) {
> > +		unsigned int alias_len;
> > +
> > +		alias_len =3D parent->ops->get_alias_length();
> > +		if (alias_len) {
> > +			alias =3D generate_alias(uuid_str, alias_len);
>=20
> ...to be saved into a local variable here...
>=20
> > +			if (IS_ERR(alias)) {
> > +				ret =3D PTR_ERR(alias);
> > +				goto alias_fail;
> > +			}
> > +		}
> > +	}
> >  	mutex_lock(&mdev_list_lock);
> >
> >  	/* Check for duplicate */
> > @@ -300,6 +398,12 @@ int mdev_device_create(struct kobject *kobj,
> >  	}
> >
> >  	guid_copy(&mdev->uuid, uuid);
> > +	mdev->alias =3D alias;
>=20
> ...and reassigned to the mdev member here...
>=20
> > +	/*
> > +	 * At this point alias memory is owned by the mdev.
> > +	 * Mark it NULL, so that only mdev can free it.
> > +	 */
> > +	alias =3D NULL;
>=20
> ...and detached from the local variable here. Who is freeing it? The comm=
ent
> states that it is done by the mdev, but I don't see it?
>=20
mdev_device_free() frees it.
once its assigned to mdev, mdev is the owner of it.

> This detour via the local variable looks weird to me. Can you either crea=
te the
> alias directly in the mdev (would need to happen later in the function, b=
ut I'm
> not sure why you generate the alias before checking for duplicates anyway=
), or
> do an explicit copy?
Alias duplicate check is done after generating it, because duplicate alias =
are not allowed.
The probability of collision is rare.
So it is speculatively generated without hold the lock, because there is no=
 need to hold the lock.
It is compared along with guid while mutex lock is held in single loop.
And if it is duplicate, there is no need to allocate mdev.

It will be sub optimal to run through the mdev list 2nd time after mdev cre=
ation and after generating alias for duplicate check.

>=20
> >  	list_add(&mdev->next, &mdev_list);
> >  	mutex_unlock(&mdev_list_lock);
> >
> > @@ -346,6 +450,8 @@ int mdev_device_create(struct kobject *kobj,
> >  	up_read(&parent->unreg_sem);
> >  	put_device(&mdev->dev);
> >  mdev_fail:
> > +	kfree(alias);
> > +alias_fail:
> >  	mdev_put_parent(parent);
> >  	return ret;
> >  }
>=20
> (...)
