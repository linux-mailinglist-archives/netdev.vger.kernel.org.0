Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA68815D0DE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 05:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgBNEGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 23:06:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56335 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728642AbgBNEGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 23:06:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581653160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1xIK/TCy6JocWI9iXEP20gpQgUBQR0k0L01ueOgMC6U=;
        b=BrBGfJDy5faiWxvswhMKFePTV0mc5DB46hzVA2A4dPoqJcJMelz/tgu+tKCVsYMRUwE5br
        xxGPttUtWZ9f1meM0NZv3qfqfH93zHurM9tilT3CHCtJHpoBHsxc1pQcuDEHvPovviyeHy
        sP0KfnzUqLj5UQAdUFYV3WDzfHTEACs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-6SAUathIOGSb9suc0ErvHg-1; Thu, 13 Feb 2020 23:05:56 -0500
X-MC-Unique: 6SAUathIOGSb9suc0ErvHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2715800D41;
        Fri, 14 Feb 2020 04:05:53 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 327E55DA83;
        Fri, 14 Feb 2020 04:05:33 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
 <20200213105425-mutt-send-email-mst@kernel.org>
 <20200213162407.GZ4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5625f971-0455-6463-2c0a-cbca6a1f8271@redhat.com>
Date:   Fri, 14 Feb 2020 12:05:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200213162407.GZ4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/14 =E4=B8=8A=E5=8D=8812:24, Jason Gunthorpe wrote:
> On Thu, Feb 13, 2020 at 10:56:00AM -0500, Michael S. Tsirkin wrote:
>> On Thu, Feb 13, 2020 at 11:51:54AM -0400, Jason Gunthorpe wrote:
>>>> That bus is exactly what Greg KH proposed. There are other ways
>>>> to solve this I guess but this bikeshedding is getting tiring.
>>> This discussion was for a different goal, IMHO.
>> Hmm couldn't find it anymore. What was the goal there in your opinion?
> I think it was largely talking about how to model things like
> ADI/SF/etc, plus stuff got very confused when the discussion tried to
> explain what mdev's role was vs the driver core.
>
> The standard driver model is a 'bus' driver provides the HW access
> (think PCI level things), and a 'hw driver' attaches to the bus
> device,


This is not true, kernel had already had plenty virtual bus where=20
virtual devices and drivers could be attached, besides mdev and virtio,=20
you can see vop, rpmsg, visorbus etc.


> and instantiates a 'subsystem device' (think netdev, rdma,
> etc) using some per-subsystem XXX_register().


Well, if you go through virtio spec, we support ~20 types of different=20
devices. Classes like netdev and rdma are correct since they have a=20
clear set of semantics their own. But grouping network and scsi into a=20
single class looks wrong, that's the work of a virtual bus.

The class should be done on top of vDPA device instead of vDPA device=20
itself:

- For kernel driver, netdev, blk dev could be done on top
- For userspace driver, the class could be done by the drivers inside VM=20
or userspace (dpdk)


> The 'hw driver' pulls in
> functions from the 'subsystem' using a combination of callbacks and
> library-style calls so there is no code duplication.


The point is we want vDPA devices to be used by different subsystems,=20
not only vhost, but also netdev, blk, crypto (every subsystem that can=20
use virtio devices). That's why we introduce vDPA bus and introduce=20
different drivers on top.


>
> As a subsystem, vhost&vdpa should expect its 'HW driver' to bind to
> devices on busses, for instance I would expect:
>
>   - A future SF/ADI/'virtual bus' as a child of multi-functional PCI de=
vice
>     Exactly how this works is still under active discussion and is
>     one place where Greg said 'use a bus'.


That's ok but it's something that is not directly related to vDPA which=20
can be implemented by any kinds of devices/buses:

struct XXX_device {
struct vdpa_device vdpa;
struct adi_device/pci_device *lowerdev;
}
...


>   - An existing PCI, platform, or other bus and device. No need for an
>     extra bus here, PCI is the bus.


There're several examples that a bus is needed on top.

A good example is Mellanox TmFIFO driver which is a platform device=20
driver but register itself as a virtio device in order to be used by=20
virito-console driver on the virtio bus.

But it's a pity that the device can not be used by userspace driver due=20
to the limitation of virito bus which is designed for kernel driver.=20
That's why vDPA bus is introduced which abstract the common requirements=20
of both kernel and userspace drivers which allow the a single HW driver=20
to be used by kernel drivers (and the subsystems on top) and userspace=20
drivers.


>   - No bus, ie for a simulator or binding to a netdev. (existing vhost?=
)


Note, simulator can have its own class (sysfs etc.).


>
> They point is that the HW driver's job is to adapt from the bus level
> interfaces (eg readl/writel) to the subsystem level (eg something like
> the vdpa_ops).
>
> For instance that Intel driver should be a pci_driver to bind to a
> struct pci_device for its VF and then call some 'vhost&vdpa'
> _register() function to pass its ops to the subsystem which in turn
> creates the struct device of the subsystem calls, common char devices,
> sysfs, etc and calls the driver's ops in response to uAPI calls.
>
> This is already almost how things were setup in v2 of the patches,
> near as I can see, just that a bus was inserted somehow instead of
> having only the vhost class.


Well the series (plus mdev part) uses a bus since day 0. It's not=20
something new.

Thanks


>   So it iwas confusing and the lifetime
> model becomes too complicated to implement correctly...
>
> Jason
>

