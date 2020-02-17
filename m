Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736AA160A3A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 07:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgBQGIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 01:08:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgBQGIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 01:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581919712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhhQHDShnd+KbggLHB4NhxmgV88eVkpntzyZ9x/aC1Y=;
        b=OQf4Ri/jr2s5lAJCiPhj6s1Lx2JIGCdxCzLIYqWvt0mzXLr48zMUD7PkFr7tDdeRcOhEP+
        hSgVFyOIm0dqntnJKMmT4PCTVEBetDLBCPZQpJ98PpFesZhidQQ6X8oxODW5BQvNqq9ZOB
        AZU75P4+B8jVaDAj1tCdNJ/qFohoyCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-AdituZYSOqeZ40wGvdePjQ-1; Mon, 17 Feb 2020 01:08:26 -0500
X-MC-Unique: AdituZYSOqeZ40wGvdePjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77805800D50;
        Mon, 17 Feb 2020 06:08:23 +0000 (UTC)
Received: from [10.72.12.250] (ovpn-12-250.pek2.redhat.com [10.72.12.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0783787B12;
        Mon, 17 Feb 2020 06:08:04 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <8b3e6a9c-8bfd-fb3c-12a8-2d6a3879f1ae@redhat.com>
 <20200214135232.GB4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <01c86ebb-cf4b-691f-e682-2d6f93ddbcf7@redhat.com>
Date:   Mon, 17 Feb 2020 14:08:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200214135232.GB4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/14 =E4=B8=8B=E5=8D=889:52, Jason Gunthorpe wrote:
> On Fri, Feb 14, 2020 at 11:23:27AM +0800, Jason Wang wrote:
>
>>>> Though all vDPA devices have the same programming interface, but the
>>>> semantic is different. So it looks to me that use bus complies what
>>>> class.rst said:
>>>>
>>>> "
>>>>
>>>> Each device class defines a set of semantics and a programming inter=
face
>>>> that devices of that class adhere to. Device drivers are the
>>>> implementation of that programming interface for a particular device=
 on
>>>> a particular bus.
>>>>
>>>> "
>>> Here we are talking about the /dev/XX node that provides the
>>> programming interface.
>>
>> I'm confused here, are you suggesting to use class to create char devi=
ce in
>> vhost-vdpa? That's fine but the comment should go for vhost-vdpa patch=
.
> Certainly yes, something creating many char devs should have a
> class. That makes the sysfs work as expected
>
> I suppose this is vhost user?


Actually not.

Vhost-user is the vhost protocol that is used for userspace vhost=20
backend (usually though a UNIX domain socket).

What's being done in the vhost-vpda is a new type of the vhost in kernel.


> I admit I don't really see how this
> vhost stuff works, all I see are global misc devices? Very unusual for
> a new subsystem to be using global misc devices..


Vhost is not a subsystem right now, e.g for it's net implementation, it=20
was loosely coupled with a socket.

I thought you were copied in the patch [1], maybe we can move vhost=20
related discussion there to avoid confusion.

[1] https://lwn.net/Articles/811210/


>
> I would have expected that a single VDPA device comes out as a single
> char dev linked to only that VDPA device.
>
>>> All the vdpa devices have the same basic
>>> chardev interface and discover any semantic variations 'in band'
>> That's not true, char interface is only used for vhost. Kernel virtio =
driver
>> does not need char dev but a device on the virtio bus.
> Okay, this is fine, but why do you need two busses to accomplish this?


The reasons are:

- vDPA ops is designed to be functional as a software assisted transport=20
(control path) for virtio, so it's fit for a new transport driver but=20
not directly into virtio bus. VOP use similar design.
- virtio bus is designed for kernel drivers but not userspace, and it=20
can not be easily extended to support userspace driver but requires some=20
major refactoring. E.g the virtio bus operations requires the virtqueue=20
to be allocated by the transport driver.

So it's cheaper and simpler to introduce a new bus instead of=20
refactoring a well known bus and API where brunches of drivers and=20
devices had been implemented for years.


>
> Shouldn't the 'struct virito_device' be the plug in point for HW
> drivers I was talking about - and from there a vhost-user can connect
> to the struct virtio_device to give it a char dev or a kernel driver
> can connect to link it to another subsystem?


 From vhost point of view, it would only need to connect vDPA bus, no=20
need to go for virtio bus. Vhost device talks to vDPA device through=20
vDPA bus. Virito device talks to vDPA device through a new vDPA=20
transport driver.


>
> It is easy to see something is going wrong with this design because
> the drivers/virtio/virtio_vdpa.c mainly contains a bunch of trampoline
> functions reflecting identical calls from one ops struct to a
> different ops struct.


That's pretty normal, since part of the virtio ops could be 1:1 mapped=20
to some device function. If you see MMIO and PCI transport, you can see=20
something similar. The only difference is that in the case of VDPA the=20
function is assisted or emulated by hardware vDPA driver.


>   This suggests the 'vdpa' is some subclass of
> 'virtio' and it is possibly better to model it by extending 'struct
> virito_device' to include the vdpa specific stuff.


Going for such kind of modeling, virtio-pci and virtio-mmio could be=20
also treated as a subclass of virtio as well, they were all implemented=20
via a dedicated transport driver.


>
> Where does the vhost-user char dev get invovled in with the v2 series?
> Is that included?


We're working on the a new version, but for the bus/driver part it=20
should be the same as version 1.

Thanks


>
>>> Every class of virtio traffic is going to need a special HW driver to
>>> enable VDPA, that special driver can create the correct vhost side
>>> class device.
>> Are you saying, e.g it's the charge of IFCVF driver to create vhost ch=
ar dev
>> and other stuffs?
> No.
>
> Jason
>

