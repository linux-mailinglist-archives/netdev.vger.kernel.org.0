Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 391F6ADFFE
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 22:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391669AbfIIUmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 16:42:37 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:22880
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbfIIUmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 16:42:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Of5wiJRSnRu69dWDE6T2FiwWPu2L/b74jqHsdr2+r3Qr5dtdqj3hqSX+QRx0B4qMThcu0OIK/xwF0B5z6VUDG2+X0/kEbR20680ERwprKgRia2iyLfHAYeUF0/Uah6IKoUuq90Zwv+Ov6oCkv93G7UcFXjYKSgrNUeiTTpT805Yg0XYkpYApB37nQS6NiCzy/OLDNal2C1kk6pJD01Zb4qf+zNHa1Ft+SGOh1D6maZxyXj+HY3e7uYxb/Avhb8Roq0UWaOCNFagibFgllTtTm11TCfF16gPU6fjCquTx2SJM/JcpIKtCDcLhOVLGSVnYkjqAi4XJzZBtvq2MB3+xTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dKr1AO0grJB8AxRgyb/O5MW2ARTdDyzCakbAxP9+z8=;
 b=KPcYS0jSh5NLn4juRdEa+KBz49dfpQlDKmTgEvEVxd6HZifHkGat/a2wY9EBO05kqLuKH+LmrPjs2lvHa3mYVbhtlZOAUDnbaF0aOM+ffuvYBXbYU8Em2WaRvZBvo/ybpoJtC5hiBV/fD9bjIhtWxLL6ReuyxnB7Re3i3vrN5PJn6BFy0A5ULmVTVtXIYKmiBVcpuqzJOokYBDtidJpigDjhy34t10Qmbb7ysb7rwyDEJblhlm/EdWDQvQ0K3+BW3FW6C3o5825gNblxMAe2chdXTr7GHp2RBzUMHqaf+C59bcZ4xYoUBPtoxsMnECX89y/GOMI865rNgkJg0IRhxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dKr1AO0grJB8AxRgyb/O5MW2ARTdDyzCakbAxP9+z8=;
 b=SPRvP4dmMui9LQPJs4GvDkx6dKVoARZvxPF4E4r8w01+8+2ioMX11TvQmNkQSANej73SOl+on+/R2oGBgRESYGp1PFQrw/Y5cB+pWAgbmE2DY7ZKw11E3sbA0QNiPZwFsjy5OXXZX/EYf4/TFvojlHlpMvRzm10acNCeKkHwjLc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6834.eurprd05.prod.outlook.com (10.186.175.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 20:42:32 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 20:42:32 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Topic: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Index: AQHVYUZdAS6KYIr8SUO1vQ8myuXcNacjy68w
Date:   Mon, 9 Sep 2019 20:42:32 +0000
Message-ID: <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190902042436.23294-1-parav@mellanox.com>
In-Reply-To: <20190902042436.23294-1-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f24a7783-26d0-4dae-8590-08d735663cee
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6834;
x-ms-traffictypediagnostic: AM0PR05MB6834:|AM0PR05MB6834:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6834CF117498E9CE49A2EC51D1B70@AM0PR05MB6834.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(54534003)(13464003)(199004)(189003)(74316002)(7736002)(316002)(8676002)(6116002)(81156014)(81166006)(66946007)(7696005)(54906003)(476003)(76116006)(6506007)(53546011)(66446008)(52536014)(486006)(256004)(305945005)(26005)(55016002)(5660300002)(76176011)(2906002)(186003)(446003)(8936002)(66476007)(102836004)(11346002)(66556008)(64756008)(478600001)(6436002)(25786009)(2201001)(229853002)(14454004)(86362001)(3846002)(14444005)(71190400001)(53376002)(4326008)(110136005)(66066001)(71200400001)(6246003)(53936002)(33656002)(6306002)(9686003)(99286004)(2501003)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6834;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4jMwMwZzCXAXPXK0ewsJkJFKoMBME4ZVv1G7K7EPBMm7zyspCZiT3cP4SsLv0ZixzBM4uZuSDJYLY45vumdwG4jv2qMaB9SbQEhnCayBxCEU3AH9J8KsywYlSg7J9klgyn+lnlraQQdpp5x9yZZevgDwq5cGrcPOy9jy/81bslQ7W0FPDOxGzQXGs3LI93WnUcLL5JAhMoM2Cukp6gh4OWpbGyAs5Sqgel6QSTDJ0MOHYW4zwau4YGPXYO6mysl9WcTX8SbcUWtDVIODaTKhS5UpgE4efR7+KEGu47uLyxgXnf3jZAtXhOaFm47doB6wz+RIJiGUE0Xq3Z407yjZ4dMxnw+uxIrNf40FF8ij+BjKHOOofX0KgoOhpQucBN1pbPdulWOuE5hFoIhUGExf/lNMbzi4xTWNC910r7e29UA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24a7783-26d0-4dae-8590-08d735663cee
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 20:42:32.0286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oz6F+l4MJII7ZdkMacB0qNtr7FeKksE0szZ6Cc9stWcHHrMc3hcQLp1ZOnjH9wEF8t5pBowS6Z4QkcxvSb8ppw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6834
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: Parav Pandit <parav@mellanox.com>
> Sent: Sunday, September 1, 2019 11:25 PM
> To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> Subject: [PATCH v3 0/5] Introduce variable length mdev alias
>=20
> To have consistent naming for the netdevice of a mdev and to have consist=
ent
> naming of the devlink port [1] of a mdev, which is formed using
> phys_port_name of the devlink port, current UUID is not usable because UU=
ID
> is too long.
>=20
> UUID in string format is 36-characters long and in binary 128-bit.
> Both formats are not able to fit within 15 characters limit of netdev nam=
e.
>=20
> It is desired to have mdev device naming consistent using UUID.
> So that widely used user space framework such as ovs [2] can make use of
> mdev representor in similar way as PCIe SR-IOV VF and PF representors.
>=20
> Hence,
> (a) mdev alias is created which is derived using sha1 from the mdev name.
> (b) Vendor driver describes how long an alias should be for the child mde=
v
> created for a given parent.
> (c) Mdev aliases are unique at system level.
> (d) alias is created optionally whenever parent requested.
> This ensures that non networking mdev parents can function without alias
> creation overhead.
>=20
> This design is discussed at [3].
>=20
> An example systemd/udev extension will have,
>=20
> 1. netdev name created using mdev alias available in sysfs.
>=20
> mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> mdev 12 character alias=3Dcd5b146a80a5
>=20
> netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethernet link m =
=3D
> mediated device
>=20
> 2. devlink port phys_port_name created using mdev alias.
> devlink phys_port_name=3Dpcd5b146a80a5
>=20
> This patchset enables mdev core to maintain unique alias for a mdev.
>=20
> Patch-1 Introduces mdev alias using sha1.
> Patch-2 Ensures that mdev alias is unique in a system.
> Patch-3 Exposes mdev alias in a sysfs hirerchy, update Documentation
> Patch-4 Introduces mdev_alias() API.
> Patch-5 Extends mtty driver to optionally provide alias generation.
> This also enables to test UUID based sha1 collision and trigger error han=
dling
> for duplicate sha1 results.
>=20
> [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> [3] https://patchwork.kernel.org/cover/11084231/
>=20
> ---
> Changelog:
> v2->v3:
>  - Addressed comment from Yunsheng Lin
>  - Changed strcmp() =3D=3D0 to !strcmp()
>  - Addressed comment from Cornelia Hunk
>  - Merged sysfs Documentation patch with syfs patch
>  - Added more description for alias return value

Did you get a chance review this updated series?
I addressed Cornelia's and yours comment.
I do not think allocating alias memory twice, once for comparison and once =
for storing is good idea or moving alias generation logic inside the mdev_l=
ist_lock(). So I didn't address that suggestion of Cornelia.
=20
> v1->v2:
>  - Corrected a typo from 'and' to 'an'
>  - Addressed comments from Alex Williamson
>  - Kept mdev_device naturally aligned
>  - Added error checking for crypt_*() calls
>  - Moved alias NULL check at beginning
>  - Added mdev_alias() API
>  - Updated mtty driver to show example mdev_alias() usage
>  - Changed return type of generate_alias() from int to char*
> v0->v1:
>  - Addressed comments from Alex Williamson, Cornelia Hunk and Mark Bloch
>  - Moved alias length check outside of the parent lock
>  - Moved alias and digest allocation from kvzalloc to kzalloc
>  - &alias[0] changed to alias
>  - alias_length check is nested under get_alias_length callback check
>  - Changed comments to start with an empty line
>  - Added comment where alias memory ownership is handed over to mdev
> device
>  - Fixed cleaunup of hash if mdev_bus_register() fails
>  - Updated documentation for new sysfs alias file
>  - Improved commit logs to make description more clear
>  - Fixed inclusiong of alias for NULL check
>  - Added ratelimited debug print for sha1 hash collision error
>=20
> Parav Pandit (5):
>   mdev: Introduce sha1 based mdev alias
>   mdev: Make mdev alias unique among all mdevs
>   mdev: Expose mdev alias in sysfs tree
>   mdev: Introduce an API mdev_alias
>   mtty: Optionally support mtty alias
>=20
>  .../driver-api/vfio-mediated-device.rst       |   9 ++
>  drivers/vfio/mdev/mdev_core.c                 | 142 +++++++++++++++++-
>  drivers/vfio/mdev/mdev_private.h              |   5 +-
>  drivers/vfio/mdev/mdev_sysfs.c                |  26 +++-
>  include/linux/mdev.h                          |   5 +
>  samples/vfio-mdev/mtty.c                      |  13 ++
>  6 files changed, 190 insertions(+), 10 deletions(-)
>=20
> --
> 2.19.2

