Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2518F1012A9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKSEvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:51:36 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:17282
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726647AbfKSEvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 23:51:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9Yj0e4T3fd1zwFTugX9vkFRfIjgsKWjIyNTAQOVe3xwNHpDD32Z4/jNP9gILIsFfEOoaQc9fE5GQqZuCH3sJafRCBLV5PTxvi/VQpQySKKDD0DGiRLeB+0Hcy/TYqInjTcuTpifT4XUQ2sYCHgB+Rh95qGZ2WYYfdChJE1ZLGjMcBOJezFehpOVzbv1oZEDEpI3G4Gg9VBfYLkSXiXTA9a7s0zX1Ugt2CQQQ2dNeluNMyyLwtK2LNcHxIHMGmnTieHCzuMCbAZZXGbZyzByPwzIZS7PdBNa0rUuokjuL9xr0f4O6e9zM/B28v/UF5nJbmdalmJXP/OdQg9V0cqf4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnfP1WYU9neVb57sU6jI0pdHz6pUoZoSScZYLqhdSHM=;
 b=ZGp4EcnFL9nY+wP3OFmWZZBWJHx+BZUG9LkJwKvMQIg+R3WIFiZ0GMi2nWU/SnVugwuHOJj3mLj6kuMqWTmzDeMR1ztbmvW/5nE+zhetovOvr+8Gv8I4hJutW6vdE45o8la5HvQAqVozc40iKHrw6vTRrXqNQNd0RymUcLf/JuT67Ij9X/HysFFtAg/FmYyHhJ/f6Wh8psioiDkX4BFSR8Qqcc8ODYIMLzrCIg5OekbEwjBnmobMvDznYJGKx7Zacdbs84kW7pbPUmveuSlW2f3J9x0/SRcvdiZJepNhlI1Tidm6UI2lT+8Q1eAxaUVkNeJjuIVi3OJNkhtITHQn3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnfP1WYU9neVb57sU6jI0pdHz6pUoZoSScZYLqhdSHM=;
 b=PPRP0qIR8mDAWSTvk8tEXfI9kP0QN+1ryryepeYxWdX65N9VnzoPWJrcwHnuRTv3hAx6yqAG3+V8lx9h3f+n32AC4rf2LmBZQgm7fMYMvez+N3RmbtWQDRN/Axp939Ke/nbruDWjiddekqdur+Yuk7gzg3y4vHZ5RUyzIVs7dMk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6275.eurprd05.prod.outlook.com (20.179.34.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 19 Nov 2019 04:51:30 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Tue, 19 Nov 2019
 04:51:30 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAABhCAgAAItYCAAAz4AIAABs2QgAAs4QCAAsNGMIABQQUAgAAKJkCAAAN0gIAL5o8w
Date:   Tue, 19 Nov 2019 04:51:30 +0000
Message-ID: <AM0PR05MB4866E8110B24AEDB7750751FD14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191108111238.578f44f1@cakuba> <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home> <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191109005708.GC31761@ziepe.ca>
 <AM0PR05MB48660E49342EC2CD6AB825F8D1750@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191111141732.GB2202@nanopsycho>
 <AM0PR05MB4866A5F11AED9ABA70FAE7EED1740@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191111150613.GD2202@nanopsycho>
In-Reply-To: <20191111150613.GD2202@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16a8c213-26b1-4d11-c248-08d76cac24c5
x-ms-traffictypediagnostic: AM0PR05MB6275:|AM0PR05MB6275:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6275B8DFECE4B57D27FA0AD0D14C0@AM0PR05MB6275.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(53754006)(189003)(199004)(13464003)(76176011)(229853002)(26005)(2906002)(8676002)(55016002)(76116006)(256004)(14444005)(66476007)(4326008)(7416002)(66946007)(66556008)(81166006)(81156014)(305945005)(9686003)(7736002)(25786009)(6436002)(476003)(446003)(486006)(478600001)(11346002)(102836004)(66066001)(71200400001)(52536014)(186003)(14454004)(74316002)(71190400001)(64756008)(6506007)(8936002)(66446008)(316002)(6116002)(3846002)(6916009)(86362001)(33656002)(99286004)(7696005)(54906003)(6246003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6275;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8i0wgt20h6GWoV4kN0BnH1+2Ni95p9rFotNlxgmKE/RS9dgzm40cD1ptpItLFTP1JtlC/w01JI2VMjJLrE71dMl2q8kxoByWHLXpudIRSn3yi0aiTe0nsu9/a8KjyiDNov31JP9be7rx8clzim22hrHWDoN4Gnj79dIFOF2Uf4riKjWL8G7zMpb+TV1cqSywAAfNolQ7V+CII9qc3wR3PipS2KLlgRd9qU/5CYMt9s6Vq8Xm6J9ZlC6GNm1A2HSEBDkQoy0kx7wR7KCgZjQhSVf3/oIEGS6TFnFeFqbm7wn/J7LDvGJy7Owo0UkvIOTWXeseFZhf9LUwXM3VVL28MwhMZTSL39nOShln7yk5MgQvma546Fjf/K72i6AAUZnLQUs3Znoq1eFAsBSBkoR14LAh9iLsarjO+r25r26R+7xnmBMwmXvv3llLgU4yAaIg
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a8c213-26b1-4d11-c248-08d76cac24c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 04:51:30.2339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4uwDDqtZhe0E8BIf5zQHeCUoj2/ZNO9OoB3wZUTeVPryzJb7IZ56HPAXPsd1AQbsP40RlHa278PoCI8DVnUu6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6275
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Monday, November 11, 2019 9:06 AM
>=20
> Mon, Nov 11, 2019 at 03:58:18PM CET, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Monday, November 11, 2019 8:18 AM Sun, Nov 10, 2019 at
> >> 08:48:31PM CET, parav@mellanox.com wrote:
> >> >
> >> >> From: Jason Gunthorpe <jgg@ziepe.ca>
> >> >> Sent: Friday, November 8, 2019 6:57 PM
> >> >> > We should be creating 3 different buses, instead of mdev bus
> >> >> > being
> >> >> > de-
> >> >> multiplexer of that?
> >> >> >
> >> >> > Hence, depending the device flavour specified, create such
> >> >> > device on right
> >> >> bus?
> >> >> >
> >> >> > For example,
> >> >> > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo
> >> >> > subdev_id 1 $ devlink create subdev pci/0000:05:00.0 flavour
> >> >> > mdev <uuid> subdev_id 2 $ devlink create subdev pci/0000:05:00.0
> >> >> > flavour
> >> >> > mlx5 id 1 subdev_id 3
> >> >>
> >> >> I like the idea of specifying what kind of interface you want at
> >> >> sub device creation time. It fits the driver model pretty well and
> >> >> doesn't require abusing the vfio mdev for binding to a netdev drive=
r.
> >> >>
> >> >> > $ devlink subdev pci/0000:05:00.0/<subdev_id> config <params> $
> >> >> > echo <respective_device_id> <sysfs_path>/bind
> >> >>
> >> >> Is explicit binding really needed?
> >> >No.
> >> >
> >> >> If you specify a vfio flavour why shouldn't the vfio driver
> >> >> autoload and bind to it right away? That is kind of the point of
> >> >> the driver model...
> >> >>
> >> >It some configuration is needed that cannot be passed at device
> >> >creation
> >> time, explicit bind later can be used.
> >> >
> >> >> (kind of related, but I don't get while all that GUID and
> >> >> lifecycle stuff in mdev should apply for something like a SF)
> >> >>
> >> >GUID is just the name of the device.
> >> >But lets park this aside for a moment.
> >> >
> >> >> > Implement power management callbacks also on all above 3 buses?
> >> >> > Abstract out mlx5_bus into more generic virtual bus (vdev bus?)
> >> >> > so that multiple vendors can reuse?
> >> >>
> >> >> In this specific case, why does the SF in mlx5 mode even need a bus=
?
> >> >> Is it only because of devlink? That would be unfortunate
> >> >>
> >> >Devlink is one part due to identifying using bus/dev.
> >> >How do we refer to its devlink instance of SF without bus/device?
> >>
> >> Question is, why to have devlink instance for SF itself. Same as VF,
> >> you don't
> >mlx5_core has devlink instance for PF and VF for long time now.
> >Health report, txq/rxq dumps etc all anchored to this devlink instance e=
ven for
> VF. (similar to PF).
> >And so, SF same framework should work for SF.
>=20
> Right, for health it makes sense.
>=20
> >
> >> need devlink instance. You only need devlink_port (or
> >> devlink_subdev) instance on the PF devlink parent for it.
> >>
> >Devlink_port or devlink_subdev are still on eswitch or mgmt side.
> >They are not present on the side where devlink instance exist on side wh=
ere
> txq/rxq/eq etc exist.
> >
>=20
> Got it.

I am working on the revised v1 version of these series to address below con=
cerns to achieve all the requirements captured in this cover letter.

1. Avoid mdev bus abuse (Jason's and Greg's input)
2. Avoid dma_ops overload (Christoph's comment)
3. Update cover letter for devlink examples (Jakub's comment)
4. Update cover letter to describe rdma persistent naming scheme (Leon's co=
mment)
5. Jiri's few comments on code restructure
