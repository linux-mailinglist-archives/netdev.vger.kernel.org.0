Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB99160A36
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 07:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgBQGH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 01:07:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37388 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgBQGH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 01:07:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581919677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/cqI+LSxY34TQ3+ihtn4jspo5SVW6zxs0OHLcGP5gA=;
        b=eCdLG92YnqReiEKXsigYGDouOnBcdMbIvkcsprkjE5Nw13WgQbuV0UM95yXUwcfVfUX+RE
        qSpKGAb8pRBvQrZ9l0tCI1jUvO9PP9k01udRT7bSOYzzLAhpT0lmR79NPKd6YHlvs40Aam
        P6hFPPgx4pAop2rjP70EusSeGM0dWls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-9Hm3h3wJNHmQEKu_SaHKxQ-1; Mon, 17 Feb 2020 01:07:56 -0500
X-MC-Unique: 9Hm3h3wJNHmQEKu_SaHKxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31A19107ACC9;
        Mon, 17 Feb 2020 06:07:53 +0000 (UTC)
Received: from [10.72.12.250] (ovpn-12-250.pek2.redhat.com [10.72.12.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EA9C87B12;
        Mon, 17 Feb 2020 06:07:36 +0000 (UTC)
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
 <20200213105425-mutt-send-email-mst@kernel.org>
 <20200213162407.GZ4271@mellanox.com>
 <5625f971-0455-6463-2c0a-cbca6a1f8271@redhat.com>
 <20200214140446.GD4271@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <312c3a04-4cc5-650c-48bc-ffbc7c765c22@redhat.com>
Date:   Mon, 17 Feb 2020 14:07:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200214140446.GD4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/14 =E4=B8=8B=E5=8D=8810:04, Jason Gunthorpe wrote:
> On Fri, Feb 14, 2020 at 12:05:32PM +0800, Jason Wang wrote:
>
>>> The standard driver model is a 'bus' driver provides the HW access
>>> (think PCI level things), and a 'hw driver' attaches to the bus
>>> device,
>> This is not true, kernel had already had plenty virtual bus where virt=
ual
>> devices and drivers could be attached, besides mdev and virtio, you ca=
n see
>> vop, rpmsg, visorbus etc.
> Sure, but those are not connecting HW into the kernel..


Well the virtual devices are normally implemented via a real HW driver.=20
E.g for virio bus, its transport driver could be driver of real hardware=20
(e.g PCI).


>  =20
>>> and instantiates a 'subsystem device' (think netdev, rdma,
>>> etc) using some per-subsystem XXX_register().
>>
>> Well, if you go through virtio spec, we support ~20 types of different
>> devices. Classes like netdev and rdma are correct since they have a cl=
ear
>> set of semantics their own. But grouping network and scsi into a singl=
e
>> class looks wrong, that's the work of a virtual bus.
> rdma also has about 20 different types of things it supports on top of
> the generic ib_device.
>
> The central point in RDMA is the 'struct ib_device' which is a device
> class. You can discover all RDMA devices by looking in /sys/class/infin=
iband/
>
> It has an internal bus like thing (which probably should have been an
> actual bus, but this was done 15 years ago) which allows other
> subsystems to have drivers to match and bind their own drivers to the
> struct ib_device.


Right.


>
> So you'd have a chain like:
>
> struct pci_device -> struct ib_device -> [ib client bus thing] -> struc=
t net_device


So for vDPA we want to have:

kernel datapath:

struct pci_device -> struct vDPA device -> [ vDPA bus] -> struct=20
virtio_device -> [virtio bus] -> struct net_device

userspace datapath:

struct pci_device -> struct vDPA device -> [ vDPA bus] -> struct=20
vhost_device -> UAPI -> userspace driver


>
> And the various char devs are created by clients connecting to the
> ib_device and creating char devs on their own classes.
>
> Since ib_devices are multi-queue we can have all 20 devices running
> concurrently and there are various schemes to manage when the various
> things are created.
>
>>> The 'hw driver' pulls in
>>> functions from the 'subsystem' using a combination of callbacks and
>>> library-style calls so there is no code duplication.
>> The point is we want vDPA devices to be used by different subsystems, =
not
>> only vhost, but also netdev, blk, crypto (every subsystem that can use
>> virtio devices). That's why we introduce vDPA bus and introduce differ=
ent
>> drivers on top.
> See the other mail, it seems struct virtio_device serves this purpose
> already, confused why a struct vdpa_device and another bus is being
> introduced
>
>> There're several examples that a bus is needed on top.
>>
>> A good example is Mellanox TmFIFO driver which is a platform device dr=
iver
>> but register itself as a virtio device in order to be used by virito-c=
onsole
>> driver on the virtio bus.
> How is that another bus? The platform bus is the HW bus, the TmFIFO is
> the HW driver, and virtio_device is the subsystem.
>
> This seems reasonable/normal so far..


Yes, that's reasonable. This example is to answer the question why bus=20
is used instead of class here.


>
>> But it's a pity that the device can not be used by userspace driver du=
e to
>> the limitation of virito bus which is designed for kernel driver. That=
's why
>> vDPA bus is introduced which abstract the common requirements of both =
kernel
>> and userspace drivers which allow the a single HW driver to be used by
>> kernel drivers (and the subsystems on top) and userspace drivers.
> Ah! Maybe this is the source of all this strangeness - the userspace
> driver is something parallel to the struct virtio_device instead of
> being a consumer of it??


userspace driver is not parallel to virtio_device. The vhost_device is=20
parallel to virtio_device actually.


>   That certianly would mess up the driver model
> quite a lot.
>
> Then you want to add another bus to switch between vhost and struct
> virtio_device? But only for vdpa?


Still, vhost works on top of vDPA bus directly (see the reply above).


>
> But as you point out something like TmFIFO is left hanging. Seems like
> the wrong abstraction point..


You know, even refactoring virtio-bus is not for free, TmFIFO driver=20
needs changes anyhow.

Thanks


>
> Jason
>

