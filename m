Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375BCF6C9B
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 03:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfKKCTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 21:19:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26157 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726734AbfKKCTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 21:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573438792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TeoYXuf+oFqFCktCDolOS7Y5kKTl7vEKyx5nLQaehgc=;
        b=Ne4u0pxEg2GAivEGiHaWv2wdk2KUzX/zlBVGWhdw2z9aSTdI4jTBwUukk6mq63nnEWkaIQ
        p0lEgCNF1zE5dcXCnyMyDwdANhCi001isRodA0uFC2UDllz2MSOKUa+5mZrdzKSFkIY5ta
        PI/Lu7iXgp2TaYfmLHlrgcmyXPdtIsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-wNLGTRscNhKXoR8seBYvjA-1; Sun, 10 Nov 2019 21:19:49 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF91801FA1;
        Mon, 11 Nov 2019 02:19:46 +0000 (UTC)
Received: from [10.72.12.227] (ovpn-12-227.pek2.redhat.com [10.72.12.227])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A97B5DD64;
        Mon, 11 Nov 2019 02:19:24 +0000 (UTC)
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho> <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba> <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home> <20191108210545.GG10956@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <30d00588-cc19-fdc8-330e-d98b8611a75e@redhat.com>
Date:   Mon, 11 Nov 2019 10:19:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108210545.GG10956@ziepe.ca>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: wNLGTRscNhKXoR8seBYvjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/9 =E4=B8=8A=E5=8D=885:05, Jason Gunthorpe wrote:
> On Fri, Nov 08, 2019 at 01:34:35PM -0700, Alex Williamson wrote:
>> On Fri, 8 Nov 2019 16:12:53 -0400
>> Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>
>>> On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote:
>>>> On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:
>>>>>> The new intel driver has been having a very similar discussion about=
 how to
>>>>>> model their 'multi function device' ie to bind RDMA and other driver=
s to a
>>>>>> shared PCI function, and I think that discussion settled on adding a=
 new bus?
>>>>>>
>>>>>> Really these things are all very similar, it would be nice to have a=
 clear
>>>>>> methodology on how to use the device core if a single PCI device is =
split by
>>>>>> software into multiple different functional units and attached to di=
fferent
>>>>>> driver instances.
>>>>>>
>>>>>> Currently there is alot of hacking in this area.. And a consistent s=
cheme
>>>>>> might resolve the ugliness with the dma_ops wrappers.
>>>>>>
>>>>>> We already have the 'mfd' stuff to support splitting platform device=
s, maybe
>>>>>> we need to create a 'pci-mfd' to support splitting PCI devices?
>>>>>>
>>>>>> I'm not really clear how mfd and mdev relate, I always thought mdev =
was
>>>>>> strongly linked to vfio.
>>>>>>  =20
>>>>> Mdev at beginning was strongly linked to vfio, but as I mentioned
>>>>> above it is addressing more use case.
>>>>>
>>>>> I observed that discussion, but was not sure of extending mdev furthe=
r.
>>>>>
>>>>> One way to do for Intel drivers to do is after series [9].
>>>>> Where PCI driver says, MDEV_CLASS_ID_I40_FOO
>>>>> RDMA driver mdev_register_driver(), matches on it and does the probe(=
).
>>>> Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
>>>> muddying the purpose of mdevs is not a clear trade off.
>>> IMHO, mdev has amdev_parent_ops structure clearly intended to link it
>>> to vfio, so using a mdev for something not related to vfio seems like
>>> a poor choice.
>> Unless there's some opposition, I'm intended to queue this for v5.5:
>>
>> https://www.spinics.net/lists/kvm/msg199613.html
>>
>> mdev has started out as tied to vfio, but at it's core, it's just a
>> device life cycle infrastructure with callbacks between bus drivers
>> and vendor devices.  If virtio is on the wrong path with the above
>> series, please speak up.  Thanks,
> Well, I think Greg just objected pretty strongly.
>
> IMHO it is wrong to turn mdev into some API multiplexor. That is what
> the driver core already does and AFAIK your bus type is supposed to
> represent your API contract to your drivers.
>
> Since the bus type is ABI, 'mdev' is really all about vfio I guess?
>
> Maybe mdev should grow by factoring the special GUID life cycle stuff
> into a helper library that can make it simpler to build proper API
> specific bus's using that lifecycle model? ie the virtio I saw
> proposed should probably be a mdev-virtio bus type providing this new
> virtio API contract using a 'struct mdev_virtio'?


Yes, and probably just decouple the vfio a little bit more from mdev,=20
and allow mdev to register multiple types of buses. Vfio-mdev still go=20
for mdev bus, but for virtio and other they will go their own.

Thanks


>
> I only looked briefly but mdev seems like an unusual way to use the
> driver core. *generally* I would expect that if a driver wants to
> provide a foo_device (on a foo bus, providing the foo API contract) it
> looks very broadly like:
>
>    struct foo_device {
>         struct device dev;
>         const struct foo_ops *ops;
>    };
>    struct my_foo_device {
>        struct foo_device fdev;
>    };
>
>    foo_device_register(&mydev->fdev);
>
> Which means we can use normal container_of() patterns, while mdev
> seems to want to allocate all the structs internally.. I guess this is
> because of how the lifecycle stuff works? From a device core view it
> looks quite unnatural.
>
> Jason

