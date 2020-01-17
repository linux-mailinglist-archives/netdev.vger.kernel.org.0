Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 882DD140617
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgAQJc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:32:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726553AbgAQJc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:32:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579253576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjodTc+NxXpXZK3ZFiQXvOKJvfATQRwDI15WnbNFZWs=;
        b=Bun+1DGxMtQJfpxe5pzM5vzfgQLvL0cx4U50Z+73bHnw03xdZlkIvKRGRJTtyL6K4qmSub
        CpUhCBR/GxA0wCRw3mY0rhbvP9YzLUQbDxQizRrnD+vrwelzkqo5JBtPIvniC2YlYA4zOP
        hk2ozEYWusWN18Bg8cTrNqUrU+jsXko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-_HQSAA8RM6efHyvV5nrALA-1; Fri, 17 Jan 2020 04:32:55 -0500
X-MC-Unique: _HQSAA8RM6efHyvV5nrALA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9BDD477;
        Fri, 17 Jan 2020 09:32:52 +0000 (UTC)
Received: from [10.72.12.168] (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD49738B;
        Fri, 17 Jan 2020 09:32:36 +0000 (UTC)
Subject: Re: [PATCH 4/5] virtio: introduce a vDPA based transport
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
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
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-5-jasowang@redhat.com>
 <20200116153807.GI20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8e8aa4b7-4948-5719-9618-e28daffba1a5@redhat.com>
Date:   Fri, 17 Jan 2020 17:32:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200116153807.GI20978@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/16 =E4=B8=8B=E5=8D=8811:38, Jason Gunthorpe wrote:
> On Thu, Jan 16, 2020 at 08:42:30PM +0800, Jason Wang wrote:
>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa=
.c
>> new file mode 100644
>> index 000000000000..86936e5e7ec3
>> +++ b/drivers/virtio/virtio_vdpa.c
>> @@ -0,0 +1,400 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * VIRTIO based driver for vDPA device
>> + *
>> + * Copyright (c) 2020, Red Hat. All rights reserved.
>> + *     Author: Jason Wang <jasowang@redhat.com>
>> + *
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/device.h>
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/uuid.h>
>> +#include <linux/virtio.h>
>> +#include <linux/vdpa.h>
>> +#include <linux/virtio_config.h>
>> +#include <linux/virtio_ring.h>
>> +
>> +#define MOD_VERSION  "0.1"
>> +#define MOD_AUTHOR   "Jason Wang <jasowang@redhat.com>"
>> +#define MOD_DESC     "vDPA bus driver for virtio devices"
>> +#define MOD_LICENSE  "GPL v2"
>> +
>> +#define to_virtio_vdpa_device(dev) \
>> +	container_of(dev, struct virtio_vdpa_device, vdev)
> Should be a static function


Ok.


>
>> +struct virtio_vdpa_device {
>> +	struct virtio_device vdev;
>> +	struct vdpa_device *vdpa;
>> +	u64 features;
>> +
>> +	/* The lock to protect virtqueue list */
>> +	spinlock_t lock;
>> +	/* List of virtio_vdpa_vq_info */
>> +	struct list_head virtqueues;
>> +};
>> +
>> +struct virtio_vdpa_vq_info {
>> +	/* the actual virtqueue */
>> +	struct virtqueue *vq;
>> +
>> +	/* the list node for the virtqueues list */
>> +	struct list_head node;
>> +};
>> +
>> +static struct vdpa_device *vd_get_vdpa(struct virtio_device *vdev)
>> +{
>> +	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
>> +	struct vdpa_device *vdpa =3D vd_dev->vdpa;
>> +
>> +	return vdpa;
> Bit of a long way to say
>
>    return to_virtio_vdpa_device(vdev)->vdpa
>
> ?


Right.


>
>> +err_vq:
>> +	vring_del_virtqueue(vq);
>> +error_new_virtqueue:
>> +	ops->set_vq_ready(vdpa, index, 0);
>> +	WARN_ON(ops->get_vq_ready(vdpa, index));
> A warn_on during error unwind? Sketchy, deserves a comment I think


Yes, it's a hint of bug in the vDPA driver. Will add a comment.


>
>> +static void virtio_vdpa_release_dev(struct device *_d)
>> +{
>> +	struct virtio_device *vdev =3D
>> +	       container_of(_d, struct virtio_device, dev);
>> +	struct virtio_vdpa_device *vd_dev =3D
>> +	       container_of(vdev, struct virtio_vdpa_device, vdev);
>> +	struct vdpa_device *vdpa =3D vd_dev->vdpa;
>> +
>> +	devm_kfree(&vdpa->dev, vd_dev);
>> +}
> It is unusual for the release function to not be owned by the
> subsystem, through the class.


This is how virtio_pci and virtio_mmio work now. Virtio devices may have=20
different transports which require different release functions. I think=20
this is the reason why virtio


> I'm not sure there are enough module ref
> counts to ensure that this function is not unloaded?


Let me double check this.


>
> Usually to make this all work sanely the subsytem provides some
> allocation function
>
>   vdpa_dev =3D vdpa_alloc_dev(parent, ops, sizeof(struct virtio_vdpa_de=
vice))
>   struct virtio_vdpa_device *priv =3D vdpa_priv(vdpa_dev)
>
> Then the subsystem naturally owns all the memory.
>
> Otherwise it gets tricky to ensure that the module doesn't unload
> before all the krefs are put.


I see.


>
>> +
>> +static int virtio_vdpa_probe(struct device *dev)
>> +{
>> +	struct vdpa_device *vdpa =3D dev_to_vdpa(dev);
> The probe function for a class should accept the classes type already,
> no casting.


Right.


>
>> +	const struct vdpa_config_ops *ops =3D vdpa->config;
>> +	struct virtio_vdpa_device *vd_dev;
>> +	int rc;
>> +
>> +	vd_dev =3D devm_kzalloc(dev, sizeof(*vd_dev), GFP_KERNEL);
>> +	if (!vd_dev)
>> +		return -ENOMEM;
> This is not right, the struct device lifetime is controled by a kref,
> not via devm. If you want to use a devm unwind then the unwind is
> put_device, not devm_kfree.


I'm not sure I get the point here. The lifetime is bound to underlying=20
vDPA device and devres allow to be freed before the vpda device is=20
released. But I agree using devres of underlying vdpa device looks wired.


>
> In this simple situation I don't see a reason to use devm.
>
>> +	vd_dev->vdev.dev.parent =3D &vdpa->dev;
>> +	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
>> +	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
>> +	vd_dev->vdpa =3D vdpa;
>> +	INIT_LIST_HEAD(&vd_dev->virtqueues);
>> +	spin_lock_init(&vd_dev->lock);
>> +
>> +	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
>> +	if (vd_dev->vdev.id.device =3D=3D 0)
>> +		return -ENODEV;
>> +
>> +	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
>> +	rc =3D register_virtio_device(&vd_dev->vdev);
>> +	if (rc)
>> +		put_device(dev);
> And a ugly unwind like this is why you want to have device_initialize()
> exposed to the driver,


In this context, which "driver" did you mean here? (Note, virtio-vdpa is=20
the driver for vDPA bus here).


>   so there is a clear pairing that calling
> device_initialize() must be followed by put_device. This should also
> use the goto unwind style
>
>> +	else
>> +		dev_set_drvdata(dev, vd_dev);
>> +
>> +	return rc;
>> +}
>> +
>> +static void virtio_vdpa_remove(struct device *dev)
>> +{
> Remove should also already accept the right type


Yes.


>
>> +	struct virtio_vdpa_device *vd_dev =3D dev_get_drvdata(dev);
>> +
>> +	unregister_virtio_device(&vd_dev->vdev);
>> +}
>> +
>> +static struct vdpa_driver virtio_vdpa_driver =3D {
>> +	.drv =3D {
>> +		.name	=3D "virtio_vdpa",
>> +	},
>> +	.probe	=3D virtio_vdpa_probe,
>> +	.remove =3D virtio_vdpa_remove,
>> +};
> Still a little unclear on binding, is this supposed to bind to all
> vdpa devices?


Yes, it expected to drive all vDPA devices.


>
> Where is the various THIS_MODULE's I expect to see in a scheme like
> this?
>
> All function pointers must be protected by a held module reference
> count, ie the above probe/remove and all the pointers in ops.


Will double check, since I don't see this in other virtio transport=20
drivers (PCI or MMIO).


>
>> +static int __init virtio_vdpa_init(void)
>> +{
>> +	return register_vdpa_driver(&virtio_vdpa_driver);
>> +}
>> +
>> +static void __exit virtio_vdpa_exit(void)
>> +{
>> +	unregister_vdpa_driver(&virtio_vdpa_driver);
>> +}
>> +
>> +module_init(virtio_vdpa_init)
>> +module_exit(virtio_vdpa_exit)
> Best to provide the usual 'module_pci_driver' like scheme for this
> boiler plate.


Ok.


>
>> +MODULE_VERSION(MOD_VERSION);
>> +MODULE_LICENSE(MOD_LICENSE);
>> +MODULE_AUTHOR(MOD_AUTHOR);
>> +MODULE_DESCRIPTION(MOD_DESC);
> Why the indirection with 2nd defines?


Will fix.

Thanks


>
> Jason
>

