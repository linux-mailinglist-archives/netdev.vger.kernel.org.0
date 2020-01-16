Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD2513DEFF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgAPPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:38:21 -0500
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:8450
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726552AbgAPPiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 10:38:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq8MsW3PXtBh00cQ/Hi0O4rvsciEg41BGXoYsCW2pLyuy7FoLxT9s95GtyV/P7bBRmJmms92bhnpsxVuZKbatfyv+XYtSVnmDqHc3gr+Ob00hv13ebdTxeP8azEcwEwe3bqEVwAaHqTprKXg2668Rpsmm2W3BYuPVcQxS+v4ft26saNnD3Z8eYDTRh8MVQss1ErH189o2RiwHi8Pn8WsmdEZ5xLUmiAhQ7kYEiIOoW4Z5/iy7KO6RnnebzVRBQHYoIOU9yirQUf2HqSkChxOAH6SQfXSkzD4acdtYvjmcV4mf2lcTKzCFR2vStBDVweaV45Qk1nVrcNS9aTqieFzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQWnHWL+1AjFKYFgrOxaSk0jpunMeufo9kA22IiyaVA=;
 b=f5bCn4n+xE5rQQ8WXDeNuGBfeoyZotF318vH4cZZg4e4x1TXHXO9JVXfKRrSubJqkChY94NpSX8inRc8XQVdSY5TrcQhNf0yU4nGzjwAh4bX6bew20NcrdS2X4II4+p7btuIbJ/IKY0JgiUJau2XuWQf4rCh8Okz0wWp86M1X2fM5R2pQsNj8SaYNSgK3BgbKidns1WThsI5xXYrBc6tQRyLqxQ1geDRe2ku/wWnggRO/+JRP9eISXJUfV0oaptz0qpAU+cVo9mDaAFbmos08TOQkp7rtUSc0ZAoygdmSk7eFflJq+7TtVXhBFoiuOGtQ1CWYCyffmZHADjlXT/TfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQWnHWL+1AjFKYFgrOxaSk0jpunMeufo9kA22IiyaVA=;
 b=ju6wUMA0NTEDDiycfs2relhXNusgwZFJyrvVDBGDA8Ju66X4QdaFviiWcSDjQAYEqWycShVSIxWwsZQIgFDYLE2oTWxVeA21OYAnw0NGSwuaPG6+8AKKH9OMtJMf8aJN/iGZVLBjEhTngI9dkrMhpmP7SshM9yojGsen8qBeXas=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3342.eurprd05.prod.outlook.com (10.170.238.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 16 Jan 2020 15:38:11 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 15:38:10 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR05CA0051.namprd05.prod.outlook.com (2603:10b6:208:236::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.6 via Frontend Transport; Thu, 16 Jan 2020 15:38:10 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1is7Dj-0005wO-2b; Thu, 16 Jan 2020 11:38:07 -0400
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
Subject: Re: [PATCH 4/5] virtio: introduce a vDPA based transport
Thread-Topic: [PATCH 4/5] virtio: introduce a vDPA based transport
Thread-Index: AQHVzGqemfN6NNb0GkCQ+wp4u+LCL6ftbRCA
Date:   Thu, 16 Jan 2020 15:38:10 +0000
Message-ID: <20200116153807.GI20978@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-5-jasowang@redhat.com>
In-Reply-To: <20200116124231.20253-5-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:208:236::20) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0171facf-827e-49a3-7ae2-08d79a9a176d
x-ms-traffictypediagnostic: VI1PR05MB3342:|VI1PR05MB3342:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3342E67171A18334ED4972B2CF360@VI1PR05MB3342.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(189003)(199004)(66946007)(8936002)(54906003)(186003)(7416002)(66446008)(64756008)(33656002)(1076003)(66556008)(2906002)(26005)(71200400001)(66476007)(81166006)(6666004)(478600001)(52116002)(81156014)(316002)(2616005)(6916009)(9786002)(36756003)(86362001)(9746002)(5660300002)(4326008)(8676002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3342;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /VvtQuf1Z1gybZmw/kykWwiYZMYYkJFWVhkXNqCn06GTz9BGmRY6U61SRHUTLGTP4jwwm02DsmV3ZHMhmqjMrwLVN7CjkuWdMmifpmNUs76hsMFWDqozrhsMGLFaImn45+fx1X/FzBnXRJqAyFH4ZsT+vFkRZG6VP9/YIzizLMkR6tcId1AVr0eYUyZGOmahRp+5G36YEnNpvbVQXYK8zIrnZzHxrVBytb3AEmfJoddpgWf9cVd1vttmf7ws7qzk8yxMBI+7DRgOECg11QXrcn0KtFDg0ldIP7W7NCqlsZAuLRazWtMLUuX5nflNquZ9y6ZsNxuMijbjy48RaoKdJvH8szNI8daoWe/QniOkZGNt/2EUVKwf+cvjFDeHZESnfmfbf+hkRQSEC/zauydKirayCltJ0fafeH5NCJzjl0OR4ZAbGas3e1mo+lwpDEnBBBe0IUmJCr12jFFOEZhPUPiydHZ0Zj4PQssHdMbw72xSbXNgR0TvEXp7EIWQlT31
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B77D5189ED7F654685FA38AA5ABB7868@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0171facf-827e-49a3-7ae2-08d79a9a176d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 15:38:10.7345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7t4Wu59azdYBuGQdFWBzZWgaEi99P+vEuKW0TJad5h4KR4A58P2kxS/K5uAg/s1I3U/TM/L8DqHmbl4fDIhIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3342
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 08:42:30PM +0800, Jason Wang wrote:
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> new file mode 100644
> index 000000000000..86936e5e7ec3
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -0,0 +1,400 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VIRTIO based driver for vDPA device
> + *
> + * Copyright (c) 2020, Red Hat. All rights reserved.
> + *     Author: Jason Wang <jasowang@redhat.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/uuid.h>
> +#include <linux/virtio.h>
> +#include <linux/vdpa.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_ring.h>
> +
> +#define MOD_VERSION  "0.1"
> +#define MOD_AUTHOR   "Jason Wang <jasowang@redhat.com>"
> +#define MOD_DESC     "vDPA bus driver for virtio devices"
> +#define MOD_LICENSE  "GPL v2"
> +
> +#define to_virtio_vdpa_device(dev) \
> +	container_of(dev, struct virtio_vdpa_device, vdev)

Should be a static function

> +struct virtio_vdpa_device {
> +	struct virtio_device vdev;
> +	struct vdpa_device *vdpa;
> +	u64 features;
> +
> +	/* The lock to protect virtqueue list */
> +	spinlock_t lock;
> +	/* List of virtio_vdpa_vq_info */
> +	struct list_head virtqueues;
> +};
> +
> +struct virtio_vdpa_vq_info {
> +	/* the actual virtqueue */
> +	struct virtqueue *vq;
> +
> +	/* the list node for the virtqueues list */
> +	struct list_head node;
> +};
> +
> +static struct vdpa_device *vd_get_vdpa(struct virtio_device *vdev)
> +{
> +	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
> +	struct vdpa_device *vdpa =3D vd_dev->vdpa;
> +
> +	return vdpa;

Bit of a long way to say

  return to_virtio_vdpa_device(vdev)->vdpa

?

> +err_vq:
> +	vring_del_virtqueue(vq);
> +error_new_virtqueue:
> +	ops->set_vq_ready(vdpa, index, 0);
> +	WARN_ON(ops->get_vq_ready(vdpa, index));

A warn_on during error unwind? Sketchy, deserves a comment I think

> +static void virtio_vdpa_release_dev(struct device *_d)
> +{
> +	struct virtio_device *vdev =3D
> +	       container_of(_d, struct virtio_device, dev);
> +	struct virtio_vdpa_device *vd_dev =3D
> +	       container_of(vdev, struct virtio_vdpa_device, vdev);
> +	struct vdpa_device *vdpa =3D vd_dev->vdpa;
> +
> +	devm_kfree(&vdpa->dev, vd_dev);
> +}

It is unusual for the release function to not be owned by the
subsystem, through the class. I'm not sure there are enough module ref
counts to ensure that this function is not unloaded?

Usually to make this all work sanely the subsytem provides some
allocation function

 vdpa_dev =3D vdpa_alloc_dev(parent, ops, sizeof(struct virtio_vdpa_device)=
)
 struct virtio_vdpa_device *priv =3D vdpa_priv(vdpa_dev)

Then the subsystem naturally owns all the memory.

Otherwise it gets tricky to ensure that the module doesn't unload
before all the krefs are put.

> +
> +static int virtio_vdpa_probe(struct device *dev)
> +{
> +	struct vdpa_device *vdpa =3D dev_to_vdpa(dev);

The probe function for a class should accept the classes type already,
no casting.

> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	struct virtio_vdpa_device *vd_dev;
> +	int rc;
> +
> +	vd_dev =3D devm_kzalloc(dev, sizeof(*vd_dev), GFP_KERNEL);
> +	if (!vd_dev)
> +		return -ENOMEM;

This is not right, the struct device lifetime is controled by a kref,
not via devm. If you want to use a devm unwind then the unwind is
put_device, not devm_kfree.

In this simple situation I don't see a reason to use devm.

> +	vd_dev->vdev.dev.parent =3D &vdpa->dev;
> +	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
> +	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
> +	vd_dev->vdpa =3D vdpa;
> +	INIT_LIST_HEAD(&vd_dev->virtqueues);
> +	spin_lock_init(&vd_dev->lock);
> +
> +	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
> +	if (vd_dev->vdev.id.device =3D=3D 0)
> +		return -ENODEV;
> +
> +	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
> +	rc =3D register_virtio_device(&vd_dev->vdev);
> +	if (rc)
> +		put_device(dev);

And a ugly unwind like this is why you want to have device_initialize()
exposed to the driver, so there is a clear pairing that calling
device_initialize() must be followed by put_device. This should also
use the goto unwind style

> +	else
> +		dev_set_drvdata(dev, vd_dev);
> +
> +	return rc;
> +}
> +
> +static void virtio_vdpa_remove(struct device *dev)
> +{

Remove should also already accept the right type

> +	struct virtio_vdpa_device *vd_dev =3D dev_get_drvdata(dev);
> +
> +	unregister_virtio_device(&vd_dev->vdev);
> +}
> +
> +static struct vdpa_driver virtio_vdpa_driver =3D {
> +	.drv =3D {
> +		.name	=3D "virtio_vdpa",
> +	},
> +	.probe	=3D virtio_vdpa_probe,
> +	.remove =3D virtio_vdpa_remove,
> +};

Still a little unclear on binding, is this supposed to bind to all
vdpa devices?

Where is the various THIS_MODULE's I expect to see in a scheme like
this?

All function pointers must be protected by a held module reference
count, ie the above probe/remove and all the pointers in ops.

> +static int __init virtio_vdpa_init(void)
> +{
> +	return register_vdpa_driver(&virtio_vdpa_driver);
> +}
> +
> +static void __exit virtio_vdpa_exit(void)
> +{
> +	unregister_vdpa_driver(&virtio_vdpa_driver);
> +}
> +
> +module_init(virtio_vdpa_init)
> +module_exit(virtio_vdpa_exit)

Best to provide the usual 'module_pci_driver' like scheme for this
boiler plate.

> +MODULE_VERSION(MOD_VERSION);
> +MODULE_LICENSE(MOD_LICENSE);
> +MODULE_AUTHOR(MOD_AUTHOR);
> +MODULE_DESCRIPTION(MOD_DESC);

Why the indirection with 2nd defines?

Jason
