Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0AF507B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKHQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:03:18 -0500
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:58086
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfKHQDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:03:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNAc1zOjaWq0JOq4nWgyLROCoKCgManWs1AmiXSu2pQSttqbFDJfWcwbceZjqbOJjn+M2SMA8Ie4IlkbdiTgHs82UjiQsbqAwJdw2rGzMrX4lszFfXwHq4PitRyKgf4BIcM0hwU9KmJUsWyBoxUtR4wQFKYR7h1OsnyVOk5isd5s/L9eD61CtilcijJS3SZtok9H/MU/psmVc93YE82f8lH1Y7nX56kZxBgmVjEX1LG4F3yHhjG8L/8YzHPfCbWt2pufvTvuk5wfeVBQYYLA1xyTwj+6541ljvLBlvUZuYlVOXsxox6PQ7ES7FQlE9YTjcKomQqom0jYWZRYH8SvJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mvkNmKMIIDiUn3UKJ4UyDlPAaiz2p5y8IxmsepSBak=;
 b=CZXhqZ/kSM3K1jKkWqSPsvcneHZnWQfMP+IVaNOZenX5PN0ILwtXjhp8rTRn/v7dsJ4iGLTIg/yl2VDT60H/9NI/vr7a59pTRADVBjcX5H9ujxU26Ho/nb1ECqAs/Vl8o02XxnXBS/NjPEPNs5gbvh88JDG0btaPJ/kax37te/hn4k2HAuWMjuu6u5hAtz1gvtBingfL4iFIJLhOkEOcNYYcKWStzyoSqPOo/3/IylJ/0wC8t3OQgKPcf2HHkga+BE1Zy8KyLHi12sAvM7IFiNvfs/yoqxojoufUKB4LQXIXWtC059lr8ihKSPxw6/B2k5Tz3jXYat1rmReBy9JhkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mvkNmKMIIDiUn3UKJ4UyDlPAaiz2p5y8IxmsepSBak=;
 b=ZJWODvi8hogDnK3Rg0ZwcccQaJzzVm2SxTPqdpj79Q7qktisTEEe9gtN3XhcgumwNn2qkiEYEe0qEwSPdQ5gJOZsDiFyj/Egg8cIoHtBdQPVkD20Xggui0cRqlEcghw0j+76sf8LrtkmWWnS1dg1Cb6YNML3x9BpGSoo9kKof58=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4129.eurprd05.prod.outlook.com (52.134.125.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 16:03:13 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 16:03:13 +0000
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
Thread-Index: AQHVlYWxPB2tLfSvAEa4v60P1JBDkKeBFLCAgABbf8A=
Date:   Fri, 8 Nov 2019 16:03:13 +0000
Message-ID: <AM0PR05MB486609CBD40E1E26BB18C6B3D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-6-parav@mellanox.com>
 <20191108103249.GE6990@nanopsycho>
In-Reply-To: <20191108103249.GE6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e635dff1-7790-496a-c3d9-08d764652901
x-ms-traffictypediagnostic: AM0PR05MB4129:|AM0PR05MB4129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4129CB62E4B3BF458A1A0A0ED17B0@AM0PR05MB4129.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(199004)(189003)(13464003)(71190400001)(52536014)(71200400001)(6916009)(14454004)(2906002)(25786009)(229853002)(316002)(99286004)(66446008)(54906003)(6436002)(66946007)(64756008)(66556008)(66476007)(76116006)(74316002)(8676002)(5660300002)(46003)(81156014)(476003)(81166006)(8936002)(6116002)(486006)(107886003)(53546011)(55016002)(6246003)(6506007)(7736002)(33656002)(9686003)(76176011)(102836004)(7696005)(305945005)(4326008)(86362001)(446003)(11346002)(256004)(186003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4129;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dRqMwL2DTldZpAlICJbFusZ5qdMEJPABLFi+NXhVFujtHNRVLIcYGsH9Dy1NuLRSdQ2zxyWIsLtD4brygJYax3RyjpHtPPaa+T+VoqqxgxM9eje63YhUb0aN7+W0W2sGZLimGK5PBCdkXNAyXYNbJcOiRucbY7/Sw4ZaTuU4f7sCFmjVB2FKuV8A1vyexF64R6YX+7NzsxD5FZ9hlt5CBBlWP8OPKUHg3tl8Ig78ac6+Wd5sxrNnNO2m31JBOXnqcMniNDLwCtFy6ffkmGFdEbNqIcyWZIwZiNiMLIn/yuKXA0fqqzkkFcHCqRdU+wi+t/YBhHtVAgG0tE7ztXa/xLNA0X3oDr7KeMH8DwGjjs6HzbXhtPIvV+Z0d0QjCd2yXpvsh9+YoU8bLx2Eeg4awQntPCzW47iDShnWKbC47DORupcchnIiRBn48n9pH/O
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e635dff1-7790-496a-c3d9-08d764652901
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 16:03:13.7771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r1j4XjcxqwaFeJCMt+7YBs+err8ZhuSwmCH0RpqdMM6BvgjmoKSiPHeot1QDU4ieCIrGp3kdlI5Lob1H4iJ47A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 4:33 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org; Vu Pham <vuhuong@mellanox.com>
> Subject: Re: [PATCH net-next 06/19] net/mlx5: Add support for mediated
> devices in switchdev mode
>=20
> Thu, Nov 07, 2019 at 05:08:21PM CET, parav@mellanox.com wrote:
> >From: Vu Pham <vuhuong@mellanox.com>
>=20
> [...]
>=20
>=20
> >+static ssize_t
> >+max_mdevs_show(struct kobject *kobj, struct device *dev, char *buf) {
> >+	struct pci_dev *pdev =3D to_pci_dev(dev);
> >+	struct mlx5_core_dev *coredev;
> >+	struct mlx5_mdev_table *table;
> >+	u16 max_sfs;
> >+
> >+	coredev =3D pci_get_drvdata(pdev);
> >+	table =3D coredev->priv.eswitch->mdev_table;
> >+	max_sfs =3D mlx5_core_max_sfs(coredev, &table->sf_table);
> >+
> >+	return sprintf(buf, "%d\n", max_sfs); } static
> >+MDEV_TYPE_ATTR_RO(max_mdevs);
> >+
> >+static ssize_t
> >+available_instances_show(struct kobject *kobj, struct device *dev,
> >+char *buf) {
> >+	struct pci_dev *pdev =3D to_pci_dev(dev);
> >+	struct mlx5_core_dev *coredev;
> >+	struct mlx5_mdev_table *table;
> >+	u16 free_sfs;
> >+
> >+	coredev =3D pci_get_drvdata(pdev);
> >+	table =3D coredev->priv.eswitch->mdev_table;
> >+	free_sfs =3D mlx5_get_free_sfs(coredev, &table->sf_table);
> >+	return sprintf(buf, "%d\n", free_sfs); } static
> >+MDEV_TYPE_ATTR_RO(available_instances);
>=20
> These 2 arbitrary sysfs files are showing resource size/usage for the who=
le
> eswitch/asic. That is a job for "devlink resource". Please implement that=
.
>
Jiri,
This series is already too long. I will implement it as follow on. It is al=
ready in plan.
However, available_instances file is needed regardless of devlink resource,=
 as its read by the userspace for all mdev drivers.
=20
>=20
> >+
> >+static struct attribute *mdev_dev_attrs[] =3D {
> >+	&mdev_type_attr_max_mdevs.attr,
> >+	&mdev_type_attr_available_instances.attr,
> >+	NULL,
> >+};
> >+
> >+static struct attribute_group mdev_mgmt_group =3D {
> >+	.name  =3D "local",
> >+	.attrs =3D mdev_dev_attrs,
> >+};
> >+
> >+static struct attribute_group *mlx5_meddev_groups[] =3D {
> >+	&mdev_mgmt_group,
> >+	NULL,
> >+};
>=20
> [...]
