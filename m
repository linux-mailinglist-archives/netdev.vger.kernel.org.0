Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8210AF5070
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKHP77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:59:59 -0500
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:58631
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbfKHP77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:59:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLtXpJo7bqlhZHAHQpIIpL8Oawor2P34yAo3qPlWfTRqfRxWaLqX0J8Z+QSUVYA4GKr/LmC2QHXX1d5hCBJls9hs6jV6tOEWXiC24YUl8UGt8W+Fq5NwLJlcz+ix/eoPEvb2dne0AUSmKOoGUiJERQnkrPVQ/9eo06ispsRUfdCfJnLaZMJUgynby//9DkepyP7tA11mkvTFiQqZAQBvGYJJXVCnBrGm9bhyiFTZ6Qi4YkvV1hS29Momgyr8cphQNgs08gM6Jz07GrXOntYZwmLM8VyLTeVocUitHgDujCMYBWbojk4C3Ec7MNO0xW3iF5TXbuaUu1417q/DeR4t8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJgRauDTcALnJgxWWjagZXJKgoK3+gZr50a9OED1nC4=;
 b=VglrKTkx+ZEkiTwAsl5BhA3f3R1nbkPsojvKgreqOK/XMAoU/THddsMS5wXr9ak/qTpTvkpXqRCO3Rsm+gA10ouFah75pVrXQ/88aM8zu/E5prWbchSAR1nDoH9V9cVreaagIF018nJ4hFWMiME2IvfOF7vqJuzJ/ErRZET3uGjOCONHJqLhvLUSrAdyyxnEgqAkg1IHaA5VO8qd92rJvsLYMt43/osasWjNEHRLwj7vHW3WulsdQcyuHtuwmjHIzmST0cAuRNMm9A2h005ORP1M/j7bPkltUwmT0g1brL6Lu6j3QfFqkZ7xYeio/YnIMmFTz0NgndZ5KPcbRvXEgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJgRauDTcALnJgxWWjagZXJKgoK3+gZr50a9OED1nC4=;
 b=CNyGPGvakv30dDfb7otCDd8fdVpDHp6qDI95L0fZOeXOqQJnAeRVnLtqL36MWwKsJCO8fMzVNfb/clwg+xZHBlsS31UOaom/YgJperK7lP2r1+8EimelXOUwuejdOmSg8z41RctEtenmDRl8D6p7N9lRzYovyf23OSKqirhiYtk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4610.eurprd05.prod.outlook.com (52.133.58.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 15:59:54 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:59:54 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev
 alias
Thread-Index: AQHVlYW2T1JUwVGvlESLvW+hfB15XaeBHakAgABRajA=
Date:   Fri, 8 Nov 2019 15:59:53 +0000
Message-ID: <AM0PR05MB48667AF9F6EACF0CE1688262D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-7-parav@mellanox.com>
 <20191108110456.GH6990@nanopsycho>
In-Reply-To: <20191108110456.GH6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e39baa78-3cec-41ff-6848-08d76464b1f4
x-ms-traffictypediagnostic: AM0PR05MB4610:|AM0PR05MB4610:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4610534F222B1B86D4FC9233D17B0@AM0PR05MB4610.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(13464003)(446003)(476003)(14444005)(256004)(74316002)(81166006)(81156014)(8676002)(25786009)(86362001)(8936002)(11346002)(186003)(2906002)(102836004)(7696005)(71190400001)(66556008)(76176011)(66446008)(6916009)(6506007)(71200400001)(9686003)(55016002)(66476007)(64756008)(66946007)(4326008)(99286004)(76116006)(6246003)(478600001)(33656002)(54906003)(14454004)(229853002)(53546011)(5660300002)(305945005)(7736002)(46003)(52536014)(486006)(6436002)(6116002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4610;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y4CXIisSEex9tDLiRAlw7XP57UEJalvaDec9UXuwJOWMZoIKx/8SHRks1FTQYji2JhHiouX8RG+APvXQeh22qK8YL7TvMVrVwNUQYuC4qbBgfDUirxwI1ThD+PX3xqRgjqjYhR6PSaxHGJ9z2GnyleB55fAVW7+5MpTqxFSS2sPnEvrkC1+/gNlLjsOx+M6M+O4Mr7ZAjNDBFID3wgJI9RTp050rOJIOLvWSThKT1PySuHRLp8VMD5Ot6GiXrh6WXafSXd/3MoV0Of0YBtRW5lPYTL25RT7FYclLxR68tS1StgvqJvsGmX+dzFCgHBWuQ5U1OmpLJQJO3pCWSGSlDXwqMLng7t3MwzqOl6kcPoG6PCm/PD5czqadShImg3T2DlHvnyDaT+rGBRK8BvzmCnNCuzihf6FjrUVwUUQJA1snib8PuMHxshnh60m13G2p
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39baa78-3cec-41ff-6848-08d76464b1f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:59:53.9867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dpl8D7UF1MFUorobaWJYCmZvO2+mPJZkI5mTwP3bIQH04psRW4tOiAc7lgBa6OifgKvTVCP3iZ3l6/Unb6Vuug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4610
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 5:05 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 07/19] vfio/mdev: Introduce sha1 based mdev
> alias
>=20
> Thu, Nov 07, 2019 at 05:08:22PM CET, parav@mellanox.com wrote:
> >Some vendor drivers want an identifier for an mdev device that is
> >shorter than the UUID, due to length restrictions in the consumers of
> >that identifier.
> >
> >Add a callback that allows a vendor driver to request an alias of a
> >specified length to be generated for an mdev device. If generated, that
> >alias is checked for collisions.
> >
> >It is an optional attribute.
> >mdev alias is generated using sha1 from the mdev name.
> >
> >Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> >Signed-off-by: Parav Pandit <parav@mellanox.com>
> >---
> > drivers/vfio/mdev/mdev_core.c    | 123
> ++++++++++++++++++++++++++++++-
> > drivers/vfio/mdev/mdev_private.h |   5 +-
> > drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> > include/linux/mdev.h             |   4 +
> > 4 files changed, 135 insertions(+), 10 deletions(-)
> >
> >diff --git a/drivers/vfio/mdev/mdev_core.c
> >b/drivers/vfio/mdev/mdev_core.c index b558d4cfd082..3bdff0469607
> 100644
> >--- a/drivers/vfio/mdev/mdev_core.c
> >+++ b/drivers/vfio/mdev/mdev_core.c
> >@@ -10,9 +10,11 @@
>=20
> [...]
>=20
>=20
> >-int mdev_device_create(struct kobject *kobj,
> >-		       struct device *dev, const guid_t *uuid)
> >+static const char *
> >+generate_alias(const char *uuid, unsigned int max_alias_len) {
> >+	struct shash_desc *hash_desc;
> >+	unsigned int digest_size;
> >+	unsigned char *digest;
> >+	unsigned int alias_len;
> >+	char *alias;
> >+	int ret;
> >+
> >+	/*
> >+	 * Align to multiple of 2 as bin2hex will generate
> >+	 * even number of bytes.
> >+	 */
> >+	alias_len =3D roundup(max_alias_len, 2);
>=20
> This is odd, see below.
>=20
>=20
> >+	alias =3D kzalloc(alias_len + 1, GFP_KERNEL);
> >+	if (!alias)
> >+		return ERR_PTR(-ENOMEM);
> >+
> >+	/* Allocate and init descriptor */
> >+	hash_desc =3D kvzalloc(sizeof(*hash_desc) +
> >+			     crypto_shash_descsize(alias_hash),
> >+			     GFP_KERNEL);
> >+	if (!hash_desc) {
> >+		ret =3D -ENOMEM;
> >+		goto desc_err;
> >+	}
> >+
> >+	hash_desc->tfm =3D alias_hash;
> >+
> >+	digest_size =3D crypto_shash_digestsize(alias_hash);
> >+
> >+	digest =3D kzalloc(digest_size, GFP_KERNEL);
> >+	if (!digest) {
> >+		ret =3D -ENOMEM;
> >+		goto digest_err;
> >+	}
> >+	ret =3D crypto_shash_init(hash_desc);
> >+	if (ret)
> >+		goto hash_err;
> >+
> >+	ret =3D crypto_shash_update(hash_desc, uuid, UUID_STRING_LEN);
> >+	if (ret)
> >+		goto hash_err;
> >+
> >+	ret =3D crypto_shash_final(hash_desc, digest);
> >+	if (ret)
> >+		goto hash_err;
> >+
> >+	bin2hex(alias, digest, min_t(unsigned int, digest_size, alias_len / 2)=
);
> >+	/*
> >+	 * When alias length is odd, zero out an additional last byte
> >+	 * that bin2hex has copied.
> >+	 */
> >+	if (max_alias_len % 2)
> >+		alias[max_alias_len] =3D 0;
> >+
> >+	kfree(digest);
> >+	kvfree(hash_desc);
> >+	return alias;
> >+
> >+hash_err:
> >+	kfree(digest);
> >+digest_err:
> >+	kvfree(hash_desc);
> >+desc_err:
> >+	kfree(alias);
> >+	return ERR_PTR(ret);
> >+}
> >+
> >+int mdev_device_create(struct kobject *kobj, struct device *dev,
> >+		       const char *uuid_str, const guid_t *uuid)
> > {
> > 	int ret;
> > 	struct mdev_device *mdev, *tmp;
> > 	struct mdev_parent *parent;
> > 	struct mdev_type *type =3D to_mdev_type(kobj);
> >+	const char *alias =3D NULL;
> >
> > 	parent =3D mdev_get_parent(type->parent);
> > 	if (!parent)
> > 		return -EINVAL;
> >
> >+	if (parent->ops->get_alias_length) {
> >+		unsigned int alias_len;
> >+
> >+		alias_len =3D parent->ops->get_alias_length();
> >+		if (alias_len) {
>=20
> I think this should be with WARN_ON. Driver should not never return such
> 0 and if it does, it's a bug.
>
Ok. will add it.
=20
> Also I think this check should be extended by checking value is multiple =
of 2.
Do you mean driver must set alias length as always multiple of 2? Why?

> Then you can avoid the roundup() above. No need to allow even len.
Did you mean "no need to allow odd"? or?=20
=20
>=20
> [...]
>=20
> >diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> >b/drivers/vfio/mdev/mdev_sysfs.c index 7570c7602ab4..43afe0e80b76
> >100644
> >--- a/drivers/vfio/mdev/mdev_sysfs.c
> >+++ b/drivers/vfio/mdev/mdev_sysfs.c
> >@@ -63,15 +63,18 @@ static ssize_t create_store(struct kobject *kobj,
> struct device *dev,
> > 		return -ENOMEM;
> >
> > 	ret =3D guid_parse(str, &uuid);
> >-	kfree(str);
> > 	if (ret)
> >-		return ret;
> >+		goto err;
> >
> >-	ret =3D mdev_device_create(kobj, dev, &uuid);
> >+	ret =3D mdev_device_create(kobj, dev, str, &uuid);
>=20
> Why to pass the same thing twice? Move the guid_parse() call to the
> beginning of mdev_device_create() function.
>
Because alias should be unique and need to hold the lock while searching fo=
r duplicate.
So it is not done twice, and moving guid_parse() won't help due to need of =
lock.
=20
>=20
> > 	if (ret)
> >-		return ret;
> >+		goto err;
> >
> >-	return count;
> >+	ret =3D count;
> >+
> >+err:
> >+	kfree(str);
> >+	return ret;
> > }
> >
> > MDEV_TYPE_ATTR_WO(create);
>=20
> [...]
