Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D08CD87BB
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfJPFGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:06:42 -0400
Received: from mail-eopbgr10081.outbound.protection.outlook.com ([40.107.1.81]:60463
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726769AbfJPFGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 01:06:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Abu3erMAXd7b4z8WE/GaxpLEnRjVNhveU0bZ0l3KECtpgAy5tpnDVg4qtjMcygZL4pGQ08YDa5Dh+TxHzs1ywAbnOawLtJ6gowx9wf31VBX9tVDK5Bmxq0+vBRMJs9qm6ZnryzRUWphF+PwTWLo86ECLIe4FId3S7w5pqyeijRntLJuyIakXaYRKwP8PES/V5SMQYfrju7oDHaAoLyC4NdA5UFijOHsH0bQjPoJDZZA8PRlm3aTxtHJ8iQ8JDNjPG+uboAmBzW8chdqlZM+EnDMFfGtDZ/I/z70iDXUvcsAbo6VVWXM/5mdjpsH5Y4EJ9Ou9BKnGoWklaWKbB1WoZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLf88dwV5MRfS3kbM/mBtnId8rOybPvLeTH0Qk2kKV0=;
 b=K2+P4huq0X+Zctfkl+Ml+Na5NcfS7rf3gyuPXwhXp/6IY0ChJf6QSrzKV0Xii00F+fOKceULsng1SOOsMElP/kuhOcSQnrltrx81K6nqeJWUFQT6xlM9MzWYpd9xsrQQuRsulCKRd2ek7eFSYk//GfGym0WWyUQc5fN75KxcrZnP06LlXGN2EQvtj+YaKwCqgorcS3LCdQfdR4FHs7i8CZEbTJhetBNX+US2SXuY2F5ufe4m0E2ErHnMuqDPAlGnZyYjNcyKAIWfD+sXVNX85pofxIUMrxYlaj4mJqUBqhYaIPHXBj9bGveyGqIg4/P6vH244Gh5M5YKbphsSWnWrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLf88dwV5MRfS3kbM/mBtnId8rOybPvLeTH0Qk2kKV0=;
 b=WBaJWJawB0JCjkQf9JKoLD/jS/kMTpyqqCNrliJKYJ1req2eORc1fxV0DVR6LI9L+VUPhojCFYTSHDBT8w8T0IZZeL4dZKyL999CsjGSm1dq/tJcgbV0VSCivBgQXffUEEZkHQNn6NtfXnIYH7zdTO7cfH0v3H+fs6mYj67PMhk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5300.eurprd05.prod.outlook.com (20.178.18.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 05:06:35 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2347.021; Wed, 16 Oct 2019
 05:06:35 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "rodrigo.vivi@intel.com" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        Ido Shamay <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "christophe.de.dinechin@gmail.com" <christophe.de.dinechin@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH V3 2/7] mdev: bus uevent support
Thread-Topic: [PATCH V3 2/7] mdev: bus uevent support
Thread-Index: AQHVgAxwOTFv76h8okS/5uHJAhcVf6dcvsLQ
Date:   Wed, 16 Oct 2019 05:06:34 +0000
Message-ID: <AM0PR05MB4866CEC5CB9CFB6B7B409029D1920@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191011081557.28302-1-jasowang@redhat.com>
 <20191011081557.28302-3-jasowang@redhat.com>
In-Reply-To: <20191011081557.28302-3-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:8ddb:1e36:fbf6:de3d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb5026e1-4fb9-4c8d-151e-08d751f69df9
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM0PR05MB5300:|AM0PR05MB5300:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB530000C90970E79C5BB7BAE0D1920@AM0PR05MB5300.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(199004)(189003)(13464003)(476003)(446003)(52536014)(25786009)(81156014)(14454004)(81166006)(71190400001)(71200400001)(229853002)(316002)(110136005)(6436002)(486006)(54906003)(9686003)(7406005)(46003)(7416002)(55016002)(6246003)(76176011)(7736002)(186003)(6116002)(86362001)(33656002)(2906002)(2201001)(8676002)(11346002)(4326008)(74316002)(14444005)(53546011)(6506007)(305945005)(99286004)(5660300002)(478600001)(2501003)(66476007)(76116006)(102836004)(66446008)(66946007)(66556008)(64756008)(256004)(8936002)(7696005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5300;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: USIRKK135hjZiy2cR1Bcfs3XaJblthnntREI6dRe6tx649KkaMuwce4btTp3QScRb7met2r2oeyuT82vVYd7w7neNcXQraTgBv3UlnBJr1WePvL4fJ+ruDutKNtrMJwhKU1VEABR6ElbveeHx5cMlXolg1TLxPZLVPpobumVa0gvmCiXdPpQeI3KFDMUgoXu5D/ylZIiKp3BKp0BY5PxjOALWSxaah+oYy1CkY2Zugp8yUFbwRtj3EdNCQP8/9GgmCzRBAKucq4mL44+Z6AAHCzyEMP98n75b/2xBcEpJwIICR30BsZCqHUcdZPgzxNaWGku0czF40Xv69M8a4aKEetU5xDZV5q2TqTdLEbLY2sVmJeoK8qAvwxF2IyXPvii99ugp7CDSvE8v1cChl+NalKZlYSIAPj4bLIRApfQcWg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb5026e1-4fb9-4c8d-151e-08d751f69df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 05:06:34.9806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zAfA9QKeKHVoDH630fM+A9ja9s0fJAyNVfJkE5sOmnURj8/TzfFm4Fm7Um2rAYefjgWET88I0d2Lq4lS+6I9xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Friday, October 11, 2019 3:16 AM
> To: kvm@vger.kernel.org; linux-s390@vger.kernel.org; linux-
> kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; intel-
> gfx@lists.freedesktop.org; intel-gvt-dev@lists.freedesktop.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; mst@redhat.com;
> tiwei.bie@intel.com
> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org;
> cohuck@redhat.com; maxime.coquelin@redhat.com;
> cunming.liang@intel.com; zhihong.wang@intel.com;
> rob.miller@broadcom.com; xiao.w.wang@intel.com;
> haotian.wang@sifive.com; zhenyuw@linux.intel.com; zhi.a.wang@intel.com;
> jani.nikula@linux.intel.com; joonas.lahtinen@linux.intel.com;
> rodrigo.vivi@intel.com; airlied@linux.ie; daniel@ffwll.ch;
> farman@linux.ibm.com; pasic@linux.ibm.com; sebott@linux.ibm.com;
> oberpar@linux.ibm.com; heiko.carstens@de.ibm.com; gor@linux.ibm.com;
> borntraeger@de.ibm.com; akrowiak@linux.ibm.com; freude@linux.ibm.com;
> lingshan.zhu@intel.com; Ido Shamay <idos@mellanox.com>;
> eperezma@redhat.com; lulu@redhat.com; Parav Pandit
> <parav@mellanox.com>; christophe.de.dinechin@gmail.com;
> kevin.tian@intel.com; Jason Wang <jasowang@redhat.com>
> Subject: [PATCH V3 2/7] mdev: bus uevent support
>=20
> This patch adds bus uevent support for mdev bus in order to allow
> cooperation with userspace.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vfio/mdev/mdev_driver.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c index b7c40ce86ee3..319d886ffaf7
> 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -82,9 +82,17 @@ static int mdev_match(struct device *dev, struct
> device_driver *drv)
>  	return 0;
>  }
>=20
> +static int mdev_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	struct mdev_device *mdev =3D to_mdev_device(dev);
> +
> +	return add_uevent_var(env, "MODALIAS=3Dmdev:c%02X", mdev-
> >class_id); }
> +
>  struct bus_type mdev_bus_type =3D {
>  	.name		=3D "mdev",
>  	.match		=3D mdev_match,
> +	.uevent		=3D mdev_uevent,
>  	.probe		=3D mdev_probe,
>  	.remove		=3D mdev_remove,
>  };
> --
> 2.19.1
Reviewed-by: Parav Pandit <parav@mellanox.com>

