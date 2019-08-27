Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF629DC6A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfH0EYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:24:22 -0400
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:24134
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbfH0EYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 00:24:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jM2PpZEr8h/+1Iztac2wzwycOJUFyRP/NAHgGuEE5ZI9jT1fFq6mBFnneu/rJi2aY0EvNJlKwcaYVKAztBcPz51pQx1bEHeZ8aQIaT4gW7jTKhriaH35RZZDHT3owoE8z5NixiopswH39g/Qhb0zgWfL3AeQJMekHMl38o1xSC+o/D22+kVf1JRYAaWjPFQTjmt4k/tdBmlW7wktVKQ0ms7oKO+U8gdP5FFIdMJOp5EBJCWbGUDI71zUwQYCNMho4VEr8bKdgyfCqDb1IGoQHq7qECVj3dox5PXkvQYSYPRIyj4mbUog9kIjMPgtXjn395BcMkC64zaHH8YFwTIdNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOaSjvHP+LHU0gXmwtF1Z1ejwvGH8+BxuOUWMu/BS1g=;
 b=DKpOXtiZZ8Uy2CG5sG83rycleBJHpue7yUceznvsCIVZYpjKVdMqic02C3k/9KOq3U937pR+Fhd2Ai4iO5PYf0h6ecgGhNVmrV+kNgVGfiset/TVY1d8rCsgsJO3xvA24XoZ1qusq3SEN4TYBcld6Z30+yormPHoOYgJjsCua1SB/s62mH0TXyK/1RqCTbTCeq/o8iZrMwKNLDeLegBcYZvbJNW6JwbpgZyVoNfYx22fa31y1CcZuvKG4VmZXEpdejHac5pI5MBUaHgpNCPSZkcl7q8qpemddi4Kc+UJnotmcOipWTQkzP+Oti9bz8sQ3Nxt6cnvgquIxYs8Y71uEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOaSjvHP+LHU0gXmwtF1Z1ejwvGH8+BxuOUWMu/BS1g=;
 b=DQOJ83epAbIPg+pE8/9MXaHAJq80oveKKDH/aMJlGL1J730m6apBHQasCRnQ97h7mxreP3nZFOmzvksESQk3ZNPKXO6TC6d7g/utuCMCMDXT/EMpX7Z68YLqF5WDItvHXhU2E2Jv97p3FLE0JmwG5O115p++l4iLllqY/HMu7CU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4532.eurprd05.prod.outlook.com (52.133.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 04:24:16 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 04:24:16 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXE6sjQlIhIUUgkClKEYpCVnoRKcOOXEAgAAlFCA=
Date:   Tue, 27 Aug 2019 04:24:16 +0000
Message-ID: <AM0PR05MB4866CC8FD2A1C52C9B2CD483D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com> <20190826194456.6edef7d1@x1.home>
In-Reply-To: <20190826194456.6edef7d1@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61849c4e-209c-49ed-2d06-08d72aa66c34
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4532;
x-ms-traffictypediagnostic: AM0PR05MB4532:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4532344EC08F547A297923E2D1A00@AM0PR05MB4532.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(199004)(13464003)(189003)(25786009)(476003)(26005)(102836004)(446003)(76176011)(2906002)(6246003)(486006)(66476007)(7736002)(316002)(256004)(478600001)(53546011)(53936002)(6916009)(4326008)(99286004)(14454004)(11346002)(229853002)(74316002)(14444005)(305945005)(55236004)(54906003)(52536014)(66446008)(66556008)(66946007)(76116006)(6116002)(71200400001)(55016002)(66066001)(6436002)(6506007)(71190400001)(9456002)(8676002)(5660300002)(81166006)(81156014)(86362001)(186003)(9686003)(7696005)(3846002)(8936002)(33656002)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4532;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0j/Xg0ZjzkT2mHwqaO1at2BmbExG/KgBEH7+ss0KiglMMegSqfON3jWhw5rJDlvsaD/oI4ihPi2e9TqIQchXDM7WqX8aDmJDgN7Z/3INOjN0wXRql2m6trW5VdwtlpYNu6yZWXll8cCiJwdBvFB++2Dpa3VitfD37AVLRMIKYQ0DiorjFNuphGgckN24kQ1fylZxJApadaqbOdDoH3LSp4UIqEeljN+VedOG+6nKHW32szuTIzLtwbVAiqjbaBN3lt4Mi7zfVrLSigVAoKptcDX5wo/xFIryCkJLsBq7Vh34VkKgWM9rQ7Wm1/5rY9CdQauSOndGLqXYbyzAWYo6PnJ/PCf3HJeSXiMBLQ+a51BwvgmTMTAbg412qbgZY2mW2gFtu+fB8XmG7V1V38KznXPXrBwQapo4+KoZmB1EotE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61849c4e-209c-49ed-2d06-08d72aa66c34
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 04:24:16.3251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2+KK0k4RU1rbWZoR8F8PFTPltxc89389ou81DaKcR6H1shlPlRSVrCf5ZZ+IGA0RGqvtjfEFbEjUWw3tcKLeBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4532
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 27, 2019 7:15 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
>=20
> On Mon, 26 Aug 2019 15:41:16 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Whenever a parent requests to generate mdev alias, generate a mdev
> > alias.
> > It is an optional attribute that parent can request to generate for
> > each of its child mdev.
> > mdev alias is generated using sha1 from the mdev name.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 98
> +++++++++++++++++++++++++++++++-
> >  drivers/vfio/mdev/mdev_private.h |  5 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   | 13 +++--
> >  include/linux/mdev.h             |  4 ++
> >  4 files changed, 111 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index b558d4cfd082..e825ff38b037
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -10,9 +10,11 @@
> >  #include <linux/module.h>
> >  #include <linux/device.h>
> >  #include <linux/slab.h>
> > +#include <linux/mm.h>
> >  #include <linux/uuid.h>
> >  #include <linux/sysfs.h>
> >  #include <linux/mdev.h>
> > +#include <crypto/hash.h>
> >
> >  #include "mdev_private.h"
> >
> > @@ -27,6 +29,8 @@ static struct class_compat *mdev_bus_compat_class;
> > static LIST_HEAD(mdev_list);  static DEFINE_MUTEX(mdev_list_lock);
> >
> > +static struct crypto_shash *alias_hash;
> > +
> >  struct device *mdev_parent_dev(struct mdev_device *mdev)  {
> >  	return mdev->parent->dev;
> > @@ -164,6 +168,18 @@ int mdev_register_device(struct device *dev, const
> struct mdev_parent_ops *ops)
> >  		goto add_dev_err;
> >  	}
> >
> > +	if (ops->get_alias_length) {
> > +		unsigned int digest_size;
> > +		unsigned int aligned_len;
> > +
> > +		aligned_len =3D roundup(ops->get_alias_length(), 2);
> > +		digest_size =3D crypto_shash_digestsize(alias_hash);
> > +		if (aligned_len / 2 > digest_size) {
> > +			ret =3D -EINVAL;
> > +			goto add_dev_err;
> > +		}
> > +	}
>=20
> This looks like a sanity check, it could be done outside of the
> parent_list_lock, even before we get a parent device reference.
>
Yes.
=20
> I think we're using a callback for get_alias_length() rather than a fixed=
 field
> to support the mtty module option added in patch 4, right?
Right.
I will move the check outside.

> Its utility is rather limited with no args.  I could imagine that if a pa=
rent
> wanted to generate an alias that could be incorporated into a string with=
 the
> parent device name that it would be useful to call this with the parent
> device as an arg.  I guess we can save that until a user comes along thou=
gh.
>
Right. We save until user arrives.
I suggest you review the extra complexity I added here for vendor driven al=
ias length, which I think we should do when an actual user comes along.

 > There doesn't seem to be anything serializing use of alias_hash.
>=20
Each sha1 calculation is happening on the new descriptor allocated and init=
ialized using crypto_shash_init().
So it appears to me that each hash calculation can occur in parallel on the=
 individual desc.

> > +
> >  	parent =3D kzalloc(sizeof(*parent), GFP_KERNEL);
> >  	if (!parent) {
> >  		ret =3D -ENOMEM;
> > @@ -259,6 +275,7 @@ static void mdev_device_free(struct mdev_device
> *mdev)
> >  	mutex_unlock(&mdev_list_lock);
> >
> >  	dev_dbg(&mdev->dev, "MDEV: destroying\n");
> > +	kvfree(mdev->alias);
> >  	kfree(mdev);
> >  }
> >
> > @@ -269,18 +286,86 @@ static void mdev_device_release(struct device
> *dev)
> >  	mdev_device_free(mdev);
> >  }
> >
> > -int mdev_device_create(struct kobject *kobj,
> > -		       struct device *dev, const guid_t *uuid)
> > +static const char *
> > +generate_alias(const char *uuid, unsigned int max_alias_len) {
> > +	struct shash_desc *hash_desc;
> > +	unsigned int digest_size;
> > +	unsigned char *digest;
> > +	unsigned int alias_len;
> > +	char *alias;
> > +	int ret =3D 0;
> > +
> > +	/* Align to multiple of 2 as bin2hex will generate
> > +	 * even number of bytes.
> > +	 */
>=20
> Comment style for non-networking code please.
Ack.

>=20
> > +	alias_len =3D roundup(max_alias_len, 2);
> > +	alias =3D kvzalloc(alias_len + 1, GFP_KERNEL);
>=20
> The size we're generating here should be small enough to just use kzalloc=
(),
Ack.

> probably below too.
>=20
Descriptor size is 96 bytes long. kvzalloc is more optimal.

> > +	if (!alias)
> > +		return NULL;
> > +
> > +	/* Allocate and init descriptor */
> > +	hash_desc =3D kvzalloc(sizeof(*hash_desc) +
> > +			     crypto_shash_descsize(alias_hash),
> > +			     GFP_KERNEL);
> > +	if (!hash_desc)
> > +		goto desc_err;
> > +
> > +	hash_desc->tfm =3D alias_hash;
> > +
> > +	digest_size =3D crypto_shash_digestsize(alias_hash);
> > +
> > +	digest =3D kvzalloc(digest_size, GFP_KERNEL);
> > +	if (!digest) {
> > +		ret =3D -ENOMEM;
> > +		goto digest_err;
> > +	}
> > +	crypto_shash_init(hash_desc);
> > +	crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
> > +	crypto_shash_final(hash_desc, digest);
> > +	bin2hex(&alias[0], digest,
>=20
> &alias[0], ie. alias
Ack.

>=20
> > +		min_t(unsigned int, digest_size, alias_len / 2));
> > +	/* When alias length is odd, zero out and additional last byte
> > +	 * that bin2hex has copied.
> > +	 */
> > +	if (max_alias_len % 2)
> > +		alias[max_alias_len] =3D 0;
>=20
> Doesn't this give us a null terminated string for odd numbers but not eve=
n
> numbers?  Probably best to define that we always provide a null terminate=
d
> string then we could do this unconditionally.
>=20
> > +
> > +	kvfree(digest);
> > +	kvfree(hash_desc);
> > +	return alias;
> > +
> > +digest_err:
> > +	kvfree(hash_desc);
> > +desc_err:
> > +	kvfree(alias);
> > +	return NULL;
> > +}
> > +
> > +int mdev_device_create(struct kobject *kobj, struct device *dev,
> > +		       const char *uuid_str, const guid_t *uuid)
> >  {
> >  	int ret;
> >  	struct mdev_device *mdev, *tmp;
> >  	struct mdev_parent *parent;
> >  	struct mdev_type *type =3D to_mdev_type(kobj);
> > +	unsigned int alias_len =3D 0;
> > +	const char *alias =3D NULL;
> >
> >  	parent =3D mdev_get_parent(type->parent);
> >  	if (!parent)
> >  		return -EINVAL;
> >
> > +	if (parent->ops->get_alias_length)
> > +		alias_len =3D parent->ops->get_alias_length();
> > +	if (alias_len) {
>=20
> Why isn't this nested into the branch above?
>
I will nest it. No specific reason to not nest it.
=20
> > +		alias =3D generate_alias(uuid_str, alias_len);
> > +		if (!alias) {
> > +			ret =3D -ENOMEM;
>=20
> Could use an ERR_PTR and propagate an errno.
>=20
generate_alias() only returns one error type ENOMEM.
When we add more error types, ERR_PTR is useful.
=20
> > +			goto alias_fail;
> > +		}
> > +	}
> > +
> >  	mutex_lock(&mdev_list_lock);
> >
> >  	/* Check for duplicate */
> > @@ -300,6 +385,8 @@ int mdev_device_create(struct kobject *kobj,
> >  	}
> >
> >  	guid_copy(&mdev->uuid, uuid);
> > +	mdev->alias =3D alias;
> > +	alias =3D NULL;
>=20
> A comment justifying this null'ing might help prevent it getting culled a=
s
> some point.  It appears arbitrary at first look.  Thanks,
>
Ack. I will add it.
=20
> Alex
