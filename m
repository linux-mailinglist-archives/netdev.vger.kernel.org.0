Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C17213DEAA
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAPPWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:22:17 -0500
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:43217
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbgAPPWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 10:22:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6mCaLfU0wivgp8sKJANYROLtNpfswyW4i4fhxR+11BJAckQhMZzcz1g6ysf5nkUDaN5yy2MVJVw1TujiuWtKFYxK+JDakOBbG9Etbr9ZN5DUta9m4a+a9VfYRvLqEOTf4SSX1xOgTv2IzFaTzglvKVPYTjxI7UKblOU9Yg7WBXkWBY94ayVZ/PywqvFQMMSwT7ldjJLQ6F7x9ikCIjC9J1x2bI2tywncHWC21Iq+p5hYcMzq3r6ccj4LFGBXbERc/CuU+zbTE53YiDUYGkWkMos6d5WtunzcBPEjsz0C4LDUtgx+4UpDqigwY69jwV3ChjQtrWIEwd3OTfvHY7Fvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUrxsts3paAh+K7ZNfpj6JIHdNvRmGe7stdH5seGYr0=;
 b=Yk/iwmMV/cuDmFVIZQ4aUXsj1OWvOrSkh9LFAxDYOAgrutHnBLOYRYQn699enuTNiVzw3fAXSuFm1lNXNPwZIppo8aD+PVW/OC8NENkeyEG5IcNZr6rdZpKzefFCslG/Naurvx4x5MqUqSeeCaFSxBZTJuWBYMq+Bkeiru/pJKfK+zwO0bSOi2vjkupjQe1cj/XHRsCZujr26A8PvZk3HnA25iuP52KTFz272f+WLkAT+GQBTkXL1nJocOyzibXduclC/Iyk4Rqrv6ae0CkR3riGVEuIBeve1jFZkV1g+agRhFE1pCzOB709ckSVmrxhgaFF+xTZKvAyZldUdzAuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUrxsts3paAh+K7ZNfpj6JIHdNvRmGe7stdH5seGYr0=;
 b=cS9r9RiNBcwrwITnqko156U1SljxmV8eWkIMg5WKyNM5fQE7yD0H27YaJIIj9uKB8HTo5/M4hULDtqdPSAd8ODihJdY3rXz/35jxZqlpGDuONH/BM4XNmT5Dkghi+cUU0mIkhcd6B1lCVno02DfK8nICFYZB2r+t1ZF+bx0IgOw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4672.eurprd05.prod.outlook.com (20.176.7.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Thu, 16 Jan 2020 15:22:13 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 15:22:13 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR14CA0018.namprd14.prod.outlook.com (2603:10b6:208:23e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 16 Jan 2020 15:22:12 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1is6yH-0005cJ-Kf; Thu, 16 Jan 2020 11:22:09 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqUgTlkW8H4N0+zRVK4Lh0XAKftaJqA
Date:   Thu, 16 Jan 2020 15:22:12 +0000
Message-ID: <20200116152209.GH20978@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
In-Reply-To: <20200116124231.20253-4-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR14CA0018.namprd14.prod.outlook.com
 (2603:10b6:208:23e::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2bb7f725-6a53-4627-299e-08d79a97dc78
x-ms-traffictypediagnostic: VI1PR05MB4672:|VI1PR05MB4672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB467220B344972E3D56BF53E7CF360@VI1PR05MB4672.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(199004)(189003)(86362001)(66446008)(54906003)(66946007)(5660300002)(9746002)(4326008)(316002)(66556008)(33656002)(64756008)(36756003)(71200400001)(2616005)(8936002)(26005)(81166006)(6666004)(81156014)(186003)(6916009)(1076003)(2906002)(52116002)(7416002)(9786002)(478600001)(8676002)(66476007)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4672;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LEZjD8mBedcmyZdfu5ZK7O9nmIyyuBfEipKziYJM/lEt5t4g7qhdHvoRR2sl8NykjWPuCAXtTEHuid9B+JewKFsvwEt6/UARk/UWq0XFaqo8O0Up5F2q065mJcW/2fxUMoK2ugxGCdMkGGY7AlHWrKA7zsuStl6S5lDAoAFzlZpgpEg7HnNUOTZD2w0hTiXS9Qfuhtid35ORyBfgiQuTEnEJsM8MYYGCLCVdS5bvIjL+TE4VuR7wunqwLWO+vCnkVI0RFQZYNeu8Su/trlMSIcr+ll/UYtOXL5pssT8wyEiTW611VpeFF+ExwNtjKTqaTL5If2vhDRUcxtXDQwU+O/ekwDJwvtRGAa7Zi32UL/2gzkSL98LRcz9g2+5aZ7s6SUA4WqcMyN9u5iuYx4gSf2oyirVmimvMTiVvF6hiO/MJoKK38pXWiMMMkxh8onhrCpcP1+63d9G+bYDH//UfgT/vDq8FbyBXdqcvk9dtJzbkEtfn8jGbDqIhqXW+PUf4
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20CB0C9B575F27429AFD01BABED3A9C5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb7f725-6a53-4627-299e-08d79a97dc78
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 15:22:12.8434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6xt20MfOs+vFPWMh78+DoIVCiHSlKInLIUkS7D+osczidBCZDm/xCiLEzBKaxDm+CqhF3EWDZ1pUiXQlbYQmJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 08:42:29PM +0800, Jason Wang wrote:
> vDPA device is a device that uses a datapath which complies with the
> virtio specifications with vendor specific control path. vDPA devices
> can be both physically located on the hardware or emulated by
> software. vDPA hardware devices are usually implemented through PCIE
> with the following types:
>=20
> - PF (Physical Function) - A single Physical Function
> - VF (Virtual Function) - Device that supports single root I/O
>   virtualization (SR-IOV). Its Virtual Function (VF) represents a
>   virtualized instance of the device that can be assigned to different
>   partitions

> - VDEV (Virtual Device) - With technologies such as Intel Scalable
>   IOV, a virtual device composed by host OS utilizing one or more
>   ADIs.
> - SF (Sub function) - Vendor specific interface to slice the Physical
>   Function to multiple sub functions that can be assigned to different
>   partitions as virtual devices.

I really hope we don't end up with two different ways to spell this
same thing.

> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0
> +obj-$(CONFIG_VDPA) +=3D vdpa.o
> diff --git a/drivers/virtio/vdpa/vdpa.c b/drivers/virtio/vdpa/vdpa.c
> new file mode 100644
> index 000000000000..2b0e4a9f105d
> +++ b/drivers/virtio/vdpa/vdpa.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vDPA bus.
> + *
> + * Copyright (c) 2019, Red Hat. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>

2020 tests days

> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/idr.h>
> +#include <linux/vdpa.h>
> +
> +#define MOD_VERSION  "0.1"

I think module versions are discouraged these days

> +#define MOD_DESC     "vDPA bus"
> +#define MOD_AUTHOR   "Jason Wang <jasowang@redhat.com>"
> +#define MOD_LICENSE  "GPL v2"
> +
> +static DEFINE_IDA(vdpa_index_ida);
> +
> +struct device *vdpa_get_parent(struct vdpa_device *vdpa)
> +{
> +	return vdpa->dev.parent;
> +}
> +EXPORT_SYMBOL(vdpa_get_parent);
> +
> +void vdpa_set_parent(struct vdpa_device *vdpa, struct device *parent)
> +{
> +	vdpa->dev.parent =3D parent;
> +}
> +EXPORT_SYMBOL(vdpa_set_parent);
> +
> +struct vdpa_device *dev_to_vdpa(struct device *_dev)
> +{
> +	return container_of(_dev, struct vdpa_device, dev);
> +}
> +EXPORT_SYMBOL_GPL(dev_to_vdpa);
> +
> +struct device *vdpa_to_dev(struct vdpa_device *vdpa)
> +{
> +	return &vdpa->dev;
> +}
> +EXPORT_SYMBOL_GPL(vdpa_to_dev);

Why these trivial assessors? Seems unnecessary, or should at least be
static inlines in a header

> +int register_vdpa_device(struct vdpa_device *vdpa)
> +{

Usually we want to see symbols consistently prefixed with vdpa_*, is
there a reason why register/unregister are swapped?

> +	int err;
> +
> +	if (!vdpa_get_parent(vdpa))
> +		return -EINVAL;
> +
> +	if (!vdpa->config)
> +		return -EINVAL;
> +
> +	err =3D ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
> +	if (err < 0)
> +		return -EFAULT;
> +
> +	vdpa->dev.bus =3D &vdpa_bus;
> +	device_initialize(&vdpa->dev);

IMHO device_initialize should not be called inside something called
register, toooften we find out that the caller drivers need the device
to be initialized earlier, ie to use the kref, or something.

I find the best flow is to have some init function that does the
device_initialize and sets the device_name that the driver can call
early.

Shouldn't there be a device/driver matching process of some kind?

Jason
