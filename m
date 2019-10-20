Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199BDDE125
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 01:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfJTXZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 19:25:26 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:10723
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726571AbfJTXZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 19:25:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOYYHdEt9B03wMPEQU1g5Py6eIsXsJMzQ29+YAMrohQF4tvnbA2QSuLX35nle6NtD6ftB1IfwhuO6PWxFtePaQq1HvClgK6WTIVUT5la5kCUTYLPYJr0AgXCV/ULetBkLbT6LzBE7E7BrflQ5XLr3OOYQzgL+IIF8DNe43FfZQnzH6+dWveljXGxrEI60MOPAY7IKkuB2WDfbSMHNBW+UWLOv8vXY1a+ahi7bGUh01jNMdx2gRkdvc7G0XEoNLMFuxb75TSoB0SFIRZk990SxhDMNW08Se4iKj41L2ElxZkEUrmc+5SbnwI9io4EBQ/0o788rti/gbJsFLGD6dxpSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtsxWHowPY+SYyqBT5x37OPRU/hvFI0uduGFMCW4g5c=;
 b=KDfdvojgSWlWwYuJkESlPRddb2CD/kW9RkD0zdktp0nFe+s9aKNdTKZtTVX755EFQzLAivFSz1bg9CRX2fGrQ5P+NmXTFtO8DTDrZiY/b98JS0TTCJUa5o+D+VZDmWuQF8Uj+b3QBL7SjDZZcB5SwrMzlvUgsQRzWI3aB6UYHAkYCmoOLoK0Ob4N6uKUcmpk2kJidLfUOiNdtzpIBfom15UZjigjT3I5Kev3wN+mbro6+AFFOyXBkweDrdt9EH85RE1LWyQ9DAjwYsNo5jS8tJuD6z65MHThiiHQM23RPzs7EZ95laDtt7XyIKjl5eNAmCppOV3Ctdx8HiFqwsCNgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtsxWHowPY+SYyqBT5x37OPRU/hvFI0uduGFMCW4g5c=;
 b=qKpXLUQW2tph9WRVniLMjyUmL5r9+JFX1ca12E67B/KsYztNrcrWSJ4klS5Cnp72Bv+YlBFRWxu27q2Lqi1FfmnA/m9ICUslZ/RzWzL77Cg0XZiBTzbCr3tqfsi2eesRbSHED9RzhUnyD7wKqTGTfEmJi+SHogp1xIjGGx5UkTM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4690.eurprd05.prod.outlook.com (52.133.55.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Sun, 20 Oct 2019 23:25:17 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2347.028; Sun, 20 Oct 2019
 23:25:17 +0000
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
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>
Subject: RE: [PATCH V4 2/6] modpost: add support for mdev class id
Thread-Topic: [PATCH V4 2/6] modpost: add support for mdev class id
Thread-Index: AQHVhNi2EUWuA567NECmSzAAowpnoKdkMTEw
Date:   Sun, 20 Oct 2019 23:25:17 +0000
Message-ID: <AM0PR05MB4866D3AA8112529F0DD40FC8D16E0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
 <20191017104836.32464-3-jasowang@redhat.com>
In-Reply-To: <20191017104836.32464-3-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:4571:4eb1:2e3a:4d72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0483f3b-1aac-4987-af89-08d755b4c48f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM0PR05MB4690:|AM0PR05MB4690:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4690300D59D287DB93E5A4CED16E0@AM0PR05MB4690.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 0196A226D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(39850400004)(366004)(13464003)(199004)(189003)(86362001)(14454004)(33656002)(55016002)(2201001)(446003)(476003)(256004)(7406005)(316002)(7416002)(478600001)(11346002)(229853002)(486006)(9686003)(6436002)(74316002)(7736002)(305945005)(2501003)(110136005)(54906003)(71190400001)(71200400001)(5660300002)(102836004)(6506007)(53546011)(6116002)(66946007)(99286004)(8936002)(76176011)(7696005)(8676002)(25786009)(66556008)(46003)(52536014)(64756008)(66446008)(186003)(4326008)(66476007)(81166006)(6246003)(81156014)(2906002)(76116006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4690;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l7EEocA8BJNKWnBlIdikpBgOfGR7+8M7dMj+lIx8Lg6tkaFgMLUWmyg3fPjrTDD027hRIYpsYU/Bhtv5Hc7fY2BYWpMlmiotGpcaAfuVHT29xW3EbKQ5jb6trYGnz4hU35Lro3qxLrtCozm1zNY8s3BsjHRNUagroQONnyHB/xehh69His7EGM/SHmMODnmjDWUfJ/S5LRlZ+E9W7eY6T6p94oN/V/tYCpdx17bD0Lfy8fJzngRHiFrAfkED71+ZSLJXN0m2d1cUQUjdlYyAVAHkisYc9bvhQRgSiq1io8Vl1Lg0xN2fGFYx1JAUZqiJicM75WKgg1daDjf4vs+YZdyhA2ZoCRx4CjBHk7GKWhY8GQgH/rt++LAS9xcY75x5ipgFDUdkTKvv/BRG3IEq59FMWuR00er77uF6Kb22eK4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0483f3b-1aac-4987-af89-08d755b4c48f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2019 23:25:17.4500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZzQnSiU1LTyCD05KqrB0d9X7QDWDM4Be7GvI8BZvx/Af5JygSRUi7LRSztKgMjlWgTvGaddfwgfQxTLfhBwFQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4690
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Thursday, October 17, 2019 5:49 AM
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
> kevin.tian@intel.com; stefanha@redhat.com; Jason Wang
> <jasowang@redhat.com>
> Subject: [PATCH V4 2/6] modpost: add support for mdev class id
>=20
> Add support to parse mdev class id table.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c     |  2 ++
>  scripts/mod/devicetable-offsets.c |  3 +++
>  scripts/mod/file2alias.c          | 10 ++++++++++
>  3 files changed, 15 insertions(+)
>=20
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index 7b24ee9cb8dd..cb701cd646f0 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -125,6 +125,8 @@ static const struct mdev_class_id id_table[] =3D {
>  	{ 0 },
>  };
>=20
> +MODULE_DEVICE_TABLE(mdev, id_table);
> +
>  static struct mdev_driver vfio_mdev_driver =3D {
>  	.name	=3D "vfio_mdev",
>  	.probe	=3D vfio_mdev_probe,
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-
> offsets.c
> index 054405b90ba4..6cbb1062488a 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -231,5 +231,8 @@ int main(void)
>  	DEVID(wmi_device_id);
>  	DEVID_FIELD(wmi_device_id, guid_string);
>=20
> +	DEVID(mdev_class_id);
> +	DEVID_FIELD(mdev_class_id, id);
> +
>  	return 0;
>  }
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c index
> c91eba751804..d365dfe7c718 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -1335,6 +1335,15 @@ static int do_wmi_entry(const char *filename,
> void *symval, char *alias)
>  	return 1;
>  }
>=20
> +/* looks like: "mdev:cN" */
> +static int do_mdev_entry(const char *filename, void *symval, char
> +*alias) {
> +	DEF_FIELD(symval, mdev_class_id, id);
> +
> +	sprintf(alias, "mdev:c%02X", id);
> +	return 1;
> +}
> +
>  /* Does namelen bytes of name exactly match the symbol? */  static bool
> sym_is(const char *name, unsigned namelen, const char *symbol)  { @@ -
> 1407,6 +1416,7 @@ static const struct devtable devtable[] =3D {
>  	{"typec", SIZE_typec_device_id, do_typec_entry},
>  	{"tee", SIZE_tee_client_device_id, do_tee_entry},
>  	{"wmi", SIZE_wmi_device_id, do_wmi_entry},
> +	{"mdev", SIZE_mdev_class_id, do_mdev_entry},
>  };
>=20
>  /* Create MODULE_ALIAS() statements.
> --
> 2.19.1
Reviewed-by: Parav Pandit <parav@mellanox.com>
