Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5344EF5373
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbfKHSVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:21:06 -0500
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:7297
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbfKHSVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 13:21:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lY3PIWAvSiMAThp+kSdHGtvBBAJx2kMexaol5zX0DZzY3HHMJpEqH5Bd2At+pi4SWQs0zPsewXwRchPMLXrVklEIngw9kLyoSFoHTZ3Y/n4A4TRKjnT10Jc+kst/7JheF226G5lUU23hdXH4OE8tcACZlApLNxd5OzBXO5fOV3b7CoXSA52E2pZaV3mdyUbCaLJ9Jv7NWavMrv3Q8txy6nG+X78U7XDaG7QecHGO5fyMXfceRbQLDVsPfKcTanzh5a00bB3Qmx6fm6cMednblKDoLtjKySd/Nlti+BodSg7V3hUJkbwBjveWMlkGHBNTlRFNVD05YHem1MrTGBofAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APbkRU01k+xyrmVBS+QSq7cjBU2v0qiK2TfOrXynO2Q=;
 b=EP2+6sE4uLUG2PfQdLQWY3I2eFJFWdYoBxJ1iuiJ2r9YIqdnBfgGsq67rprqfbrKbkdrkc9XEwRtVqBiYUWsVgwvUKirqkEQ5xkqzO5XLSm2hkbVFco60lsmDwk9ylFHbRlyU0QJCoV/BOGpyp9ZRbRfeji4ILDWmM4gE12sIOyg3TvVRDHRuRifPKXwyut6hrLPE+/fWnEbjKIPez6jceeYjbH0c0CdIlqxBHLivtMsc74QRJsLyhKJ6OP6wgs5uwd16TKq25Op+K0/Vi6lx0dSGPjWWyOQSgE3EjFXaB15z+DmgZqXUUOA1WQ1DJZsKztzTSdVnYUw9UddHYGNEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APbkRU01k+xyrmVBS+QSq7cjBU2v0qiK2TfOrXynO2Q=;
 b=OjVp6b31Lpc2aye3Kx2vO+6Tml9lVL1T3eU9c4W8Iyx6i/V9YKDK/P5k7nN1GUyafmrkVazt0PkzfNN5uOMFQOjezkL2am4NaY+AGO19YoHmxHsQhsT5K7ljNmniTepsH0XsvzDge3ob/nafUwmRih6cxmjUTaFRS1QFyjz4H8c=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5025.eurprd05.prod.outlook.com (52.134.89.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 18:21:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:21:02 +0000
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
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>
Subject: RE: [PATCH net-next 06/19] net/mlx5: Add support for mediated devices
 in switchdev mode
Thread-Topic: [PATCH net-next 06/19] net/mlx5: Add support for mediated
 devices in switchdev mode
Thread-Index: AQHVlYWxPB2tLfSvAEa4v60P1JBDkKeBFLCAgABbf8CAAAZHAIAAATbQgAAbNoCAAAOzYA==
Date:   Fri, 8 Nov 2019 18:21:02 +0000
Message-ID: <AM0PR05MB4866D17AAB3DD59D7E7E84D9D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-6-parav@mellanox.com>
 <20191108103249.GE6990@nanopsycho>
 <AM0PR05MB486609CBD40E1E26BB18C6B3D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108162246.GN6990@nanopsycho>
 <AM0PR05MB48665096F40059F63B0895C6D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108180429.GS6990@nanopsycho>
In-Reply-To: <20191108180429.GS6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dcac853c-274e-46f4-bb04-08d7647869a7
x-ms-traffictypediagnostic: AM0PR05MB5025:|AM0PR05MB5025:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB502517033DDBF610F9F18782D17B0@AM0PR05MB5025.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(189003)(199004)(13464003)(33656002)(55016002)(229853002)(478600001)(186003)(14454004)(25786009)(8936002)(6916009)(4326008)(66066001)(99286004)(6116002)(316002)(2906002)(3846002)(26005)(256004)(7736002)(81156014)(66476007)(11346002)(476003)(76176011)(8676002)(86362001)(66446008)(52536014)(54906003)(76116006)(66946007)(5660300002)(6506007)(66556008)(74316002)(81166006)(102836004)(6246003)(9686003)(7696005)(446003)(71190400001)(6436002)(305945005)(71200400001)(486006)(64756008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5025;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3mAmqPSAdm84IAnjdOk38uZS9STF0qaZlVEvlAnDl5JksBPMrdSwwDJ6Mc/TWkW6QW3q8qR7ycIml0jvufND+sylvoa+F+oYol/Qusc87UOjqWduXKB0SZUjRwdQxWVVicPo/MzfytziZoEjYkpBib0NqPaP7/LrmfHkaMV+FNyJxjUgPw76w7hhpL1QxcCbWT58DZPu2gNpiHrW3AZtxUUeei1kpH0GxpZ4X637E562+1n/o/62NUBEXaW+zn3iAJjDi6pQ9sI3UqcbNx79izQN6ewIJNLp4TQrQafaRQM5nzrCNVgrIW9M7EwcTCA6rYoLtvI+M+Hz3ltpTYgOatJGiXghwDZdqCHsMpIXtVkXF2rucj3XwS8kyYXS9Pw4P0PjROYhpGcsS5Pq/VXfgTVgWTvPw/2NrkgjoaB/FBybvf5hvM6UJqpT/ZgJIwXj
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcac853c-274e-46f4-bb04-08d7647869a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:21:02.6028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Hz6N8HBXsc49Gs5BBDNYw7wppTCI+SdBnuGvxp05jqLy6i7KK/Pe/KQJeFUv4pH693XRSvxg64qzQ8D0XipJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5025
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>

[..]

> >It should be. It isn't yet.
> >It is similar to how phys_port_name preparation was done in legacy way
> >in individual drivers and later on moved to devlink.c So some other time=
, can
> move this to mdev core.
>=20
> Btw, Documentation/driver-api/vfio-mediated-device.rst says:
>   "[<type-id>], device_api, and available_instances are mandatory attribu=
tes
>    that should be provided by vendor driver."
>=20
> Why don't you implement "device_api" as well?
Because currently device_api definitions are not central to mdev_core. It s=
hould be in mdev core and not in include/uapi/linux/vfio.h.
So, it needs to refactored.
Additionally, current mlx5 mdev are not going to be bound to vfio framework=
.
So, it is not breaking anything.
+ class_id is getting implemented to have more appropriate binding method.
Hence it is not implemented.
>=20
>=20
> >
> >
> >>
> >> >
> >> >>
> >> >> >+
> >> >> >+static struct attribute *mdev_dev_attrs[] =3D {
> >> >> >+	&mdev_type_attr_max_mdevs.attr,
> >> >> >+	&mdev_type_attr_available_instances.attr,
> >> >> >+	NULL,
> >> >> >+};
> >> >> >+
> >> >> >+static struct attribute_group mdev_mgmt_group =3D {
> >> >> >+	.name  =3D "local",
>=20
> This local name is "type-id"?
Yes.

> Why "local?
Local to this system.

>=20
>=20
>=20
>=20
>=20
> >> >> >+	.attrs =3D mdev_dev_attrs,
> >> >> >+};
> >> >> >+
> >> >> >+static struct attribute_group *mlx5_meddev_groups[] =3D {
> >> >> >+	&mdev_mgmt_group,
> >> >> >+	NULL,
> >> >> >+};
> >> >>
> >> >> [...]
