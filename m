Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0FF511F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfKHQaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:30:02 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:58665
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfKHQaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:30:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibpyiTNJ+gHAI2Pth8ttX4/gGwUr6+ZkJqyV7vdp8p5MiYJsvAThnxcqkVZI5rcs9XTHffnCcaDGFYsmW3c7d33LTVNQEwaWEICrgTIHiwV0D7djGxOfKOXGNR8O8FnuqO2yyLna/4X2+6DFUKi+l3zpZXT9GBZ+GCpKzebrK+UhNrih/p1j/myveZP9AHEkgRp6CHaeaafOwdxdB+97BkZgeay/ABzjiqp3nJKv18S1YrpgIIlzch79rd39mSXgtgA4kQCgO6FFtFf5nEOaxS8pfMPWXwtf/Ri4fDjhN92rGN73JKyQ/BnqIqV5ffZet0hYp8Y5hbc5Z7+RkSkguw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4e6LYIVLmpDPg4ZGnxr/k3Y8vcjc1eEt7HfZnSlEQg=;
 b=ZmwV1D0+X7GmnUYkl+RbKw55E0VxuMUp/TSp5QbJ8ehmlqZR3zor8g6wD+joULet+tgbkE8Qsm8Iapf45YACMPlit6nZtL1IB8WWyBCMc5qO+mI4uIgrSeeOuxIdGZ6t0PyU+Sh8vD/Lu8v6VcW6AydHSAUt45x8nabATCq+YMNYgO31h7L6xyiUq6bBl9RhruGoyuDLFJ+SkFzEvkCsoDNXQEuhdXy5PbKwJH+AwM5qjoofFs3cDiXnwwATEWH39FKEDAbNefRXj5vodUpMLwYrH4wJ9BxltQIIItzJWktXQyGt7MZ4FPIA1M123LQK72U94dkFqQqpkSZ/3c3Flg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4e6LYIVLmpDPg4ZGnxr/k3Y8vcjc1eEt7HfZnSlEQg=;
 b=EYeOSuWFzHTy/eFdz+zKlfF1ymwZDamnGpGFXs0seXom+1XkIelVmOjbZX6kyS5kRBRMX0qgNUzrIzki/CSzerKIcwKjHfV+Im0mpCzppO/GtQAF21T/DXu1bj9+qAjllou4Qc8nMdRIz4KKsyDK0fPsvb334HTVBGU93ZU5eTs=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6129.eurprd05.prod.outlook.com (20.178.117.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 16:29:56 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 16:29:56 +0000
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
Thread-Index: AQHVlYWxPB2tLfSvAEa4v60P1JBDkKeBFLCAgABbf8CAAAZHAIAAATbQ
Date:   Fri, 8 Nov 2019 16:29:56 +0000
Message-ID: <AM0PR05MB48665096F40059F63B0895C6D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-6-parav@mellanox.com>
 <20191108103249.GE6990@nanopsycho>
 <AM0PR05MB486609CBD40E1E26BB18C6B3D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108162246.GN6990@nanopsycho>
In-Reply-To: <20191108162246.GN6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ebc8cad6-2396-4c14-4695-08d76468e46d
x-ms-traffictypediagnostic: AM0PR05MB6129:|AM0PR05MB6129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB612950B94713DA776DD3DE36D17B0@AM0PR05MB6129.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(199004)(189003)(13464003)(476003)(186003)(305945005)(74316002)(52536014)(66946007)(478600001)(66476007)(66556008)(64756008)(66446008)(76116006)(7736002)(14454004)(99286004)(5660300002)(4326008)(7696005)(446003)(6436002)(81156014)(81166006)(8676002)(6246003)(256004)(55016002)(86362001)(54906003)(316002)(11346002)(6506007)(53546011)(102836004)(71190400001)(71200400001)(2906002)(229853002)(46003)(8936002)(33656002)(486006)(107886003)(9686003)(76176011)(25786009)(6916009)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6129;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: geK7eUFV/6HxNrqJ+BgjKSVdHMMjLeBBuZ97SJ0SX4pY6zgLGQFgaMK/XmI+Lne/K9zD5+11UemafkL9HK31m9fC/V+TgKKhRXlUrq3O1wFKcqo/jnGV4RU+3k5VivRY9tPon8DzheKnOUqLyXzHg/HMtLt9enS6IxIW5e4a8tUzKjcjx5+R9CHodsLckEnEK921CYPQlyBDTLYM4i7PEdg2+bUwkv1qfJ1T5lNvYfcQ4ndMhmaj2VFKmGMiCrEBvjSsZaOY7m5OjLmej3qNScP3XWoKmw11UNBX3HSYCrstT29e58/QfXmn6UqB0SSQaR8H9QvsZw9ei2UHQQa7EVBNVDFd711fnWF2Lr440VFsjCfKTUyO1vU1ClKKnkRQsQP5rc65IeLIP2opptNGz1m9xDw3nV03dIcHVOm1fRBJb2+dTSvIKQQyeiDimzQj
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc8cad6-2396-4c14-4695-08d76468e46d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 16:29:56.6448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8G9nmeshNsDx9crkd7uneQ1J6TlpjGl1h7PfwZt8n300u/iVUf5HVX15r/MxDeRGizinuVYw/VSo3y2BeISwSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 10:23 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org; Vu Pham <vuhuong@mellanox.com>
> Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for mediated
> devices in switchdev mode
>=20
> Fri, Nov 08, 2019 at 05:03:13PM CET, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Friday, November 8, 2019 4:33 AM
> >> To: Parav Pandit <parav@mellanox.com>
> >> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> >> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> >> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> >> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> >> rdma@vger.kernel.org; Vu Pham <vuhuong@mellanox.com>
> >> Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for
> >> mediated devices in switchdev mode
> >>
> >> Thu, Nov 07, 2019 at 05:08:21PM CET, parav@mellanox.com wrote:
> >> >From: Vu Pham <vuhuong@mellanox.com>
> >>
> >> [...]
> >>
> >>
> >> >+static ssize_t
> >> >+max_mdevs_show(struct kobject *kobj, struct device *dev, char *buf) =
{
> >> >+	struct pci_dev *pdev =3D to_pci_dev(dev);
> >> >+	struct mlx5_core_dev *coredev;
> >> >+	struct mlx5_mdev_table *table;
> >> >+	u16 max_sfs;
> >> >+
> >> >+	coredev =3D pci_get_drvdata(pdev);
> >> >+	table =3D coredev->priv.eswitch->mdev_table;
> >> >+	max_sfs =3D mlx5_core_max_sfs(coredev, &table->sf_table);
> >> >+
> >> >+	return sprintf(buf, "%d\n", max_sfs); } static
> >> >+MDEV_TYPE_ATTR_RO(max_mdevs);
> >> >+
> >> >+static ssize_t
> >> >+available_instances_show(struct kobject *kobj, struct device *dev,
> >> >+char *buf) {
> >> >+	struct pci_dev *pdev =3D to_pci_dev(dev);
> >> >+	struct mlx5_core_dev *coredev;
> >> >+	struct mlx5_mdev_table *table;
> >> >+	u16 free_sfs;
> >> >+
> >> >+	coredev =3D pci_get_drvdata(pdev);
> >> >+	table =3D coredev->priv.eswitch->mdev_table;
> >> >+	free_sfs =3D mlx5_get_free_sfs(coredev, &table->sf_table);
> >> >+	return sprintf(buf, "%d\n", free_sfs); } static
> >> >+MDEV_TYPE_ATTR_RO(available_instances);
> >>
> >> These 2 arbitrary sysfs files are showing resource size/usage for the
> >> whole eswitch/asic. That is a job for "devlink resource". Please imple=
ment
> that.
> >>
> >Jiri,
> >This series is already too long. I will implement it as follow on. It is=
 already
> in plan.
> >However, available_instances file is needed regardless of devlink resour=
ce,
> as its read by the userspace for all mdev drivers.
>=20
> If that is the case, why isn't that implemented in mdev code rather than
> individual drivers? I don't understand.
>
It should be. It isn't yet.
It is similar to how phys_port_name preparation was done in legacy way in i=
ndividual drivers and later on moved to devlink.c
So some other time, can move this to mdev core.

=20
>=20
> >
> >>
> >> >+
> >> >+static struct attribute *mdev_dev_attrs[] =3D {
> >> >+	&mdev_type_attr_max_mdevs.attr,
> >> >+	&mdev_type_attr_available_instances.attr,
> >> >+	NULL,
> >> >+};
> >> >+
> >> >+static struct attribute_group mdev_mgmt_group =3D {
> >> >+	.name  =3D "local",
> >> >+	.attrs =3D mdev_dev_attrs,
> >> >+};
> >> >+
> >> >+static struct attribute_group *mlx5_meddev_groups[] =3D {
> >> >+	&mdev_mgmt_group,
> >> >+	NULL,
> >> >+};
> >>
> >> [...]
