Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FEA142482
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgATHwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:52:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48559 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgATHwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:52:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579506754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Xx+mxni9g3kJmMk8VLxLFhFg3PBDXCnjO5BOpqt3H0=;
        b=UA1QDNUVQly7XoDuWJlN9R3A3004NmgXsvNVRyerM/t6Z5+8e9aD1BJe+lvBDEOo6r6H0H
        E5TPJ6x/WD4jmIIqt65sUtMeO2vvljTkHEeDE8Ns6oHAOopUA5GztR6RvdjD7RdHG1OHzY
        oow/bWze2nCLiOGke4V/54kVvtAPCSE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-Qvj0d9jqMumidG240IG4qw-1; Mon, 20 Jan 2020 02:52:33 -0500
X-MC-Unique: Qvj0d9jqMumidG240IG4qw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8ABE10054E3;
        Mon, 20 Jan 2020 07:52:30 +0000 (UTC)
Received: from [10.72.12.173] (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 901428BE07;
        Mon, 20 Jan 2020 07:52:13 +0000 (UTC)
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
 <8e8aa4b7-4948-5719-9618-e28daffba1a5@redhat.com>
 <20200117140013.GV20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bff37791-9640-39e0-5e93-c905ebfb5d2b@redhat.com>
Date:   Mon, 20 Jan 2020 15:52:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200117140013.GV20978@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=8810:00, Jason Gunthorpe wrote:
> On Fri, Jan 17, 2020 at 05:32:35PM +0800, Jason Wang wrote:
>>>> +	const struct vdpa_config_ops *ops =3D vdpa->config;
>>>> +	struct virtio_vdpa_device *vd_dev;
>>>> +	int rc;
>>>> +
>>>> +	vd_dev =3D devm_kzalloc(dev, sizeof(*vd_dev), GFP_KERNEL);
>>>> +	if (!vd_dev)
>>>> +		return -ENOMEM;
>>> This is not right, the struct device lifetime is controled by a kref,
>>> not via devm. If you want to use a devm unwind then the unwind is
>>> put_device, not devm_kfree.
>> I'm not sure I get the point here. The lifetime is bound to underlying=
 vDPA
>> device and devres allow to be freed before the vpda device is released=
. But
>> I agree using devres of underlying vdpa device looks wired.
> Once device_initialize is called the only way to free a struct device
> is via put_device, while here you have a devm trigger that will
> unconditionally do kfree on a struct device without respecting the
> reference count.
>
> reference counted memory must never be allocated with devm.


Right, fixed.


>
>>>> +	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
>>>> +	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
>>>> +	vd_dev->vdpa =3D vdpa;
>>>> +	INIT_LIST_HEAD(&vd_dev->virtqueues);
>>>> +	spin_lock_init(&vd_dev->lock);
>>>> +
>>>> +	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
>>>> +	if (vd_dev->vdev.id.device =3D=3D 0)
>>>> +		return -ENODEV;
>>>> +
>>>> +	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
>>>> +	rc =3D register_virtio_device(&vd_dev->vdev);
>>>> +	if (rc)
>>>> +		put_device(dev);
>>> And a ugly unwind like this is why you want to have device_initialize=
()
>>> exposed to the driver,
>> In this context, which "driver" did you mean here? (Note, virtio-vdpa =
is the
>> driver for vDPA bus here).
> 'driver' is the thing using the 'core' library calls to implement a
> device, so here the 'vd_dev' is the driver and
> 'register_virtio_device' is the core


Ok.


>
>>> Where is the various THIS_MODULE's I expect to see in a scheme like
>>> this?
>>>
>>> All function pointers must be protected by a held module reference
>>> count, ie the above probe/remove and all the pointers in ops.
>> Will double check, since I don't see this in other virtio transport dr=
ivers
>> (PCI or MMIO).
> pci_register_driver is a macro that provides a THIS_MODULE, and the
> pci core code sets driver.owner, then the rest of the stuff related to
> driver ops is supposed to work against that to protect the driver ops.
>
> For the device module refcounting you either need to ensure that
> 'unregister' is a strong fence and guanentees that no device ops are
> called past unregister (noting that this is impossible for release),
> or you need to hold the module lock until release.
>
> It is common to see non-core subsystems get this stuff wrong.
>
> Jason


Ok. I see.

Thanks

