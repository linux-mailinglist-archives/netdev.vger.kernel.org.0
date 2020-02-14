Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095E315D065
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 04:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgBNDXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 22:23:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21305 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728052AbgBNDXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 22:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581650632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiBwyrz6cX+xE4nXs+94fQKaFw5y/aQb69mQMK4gGl0=;
        b=W7uwClEemERc8oqUMk4qYGC2Cvjz/RryTBJnVU3EnnQVRa2yOJ6SxEKrWMy5cqe/REoQSl
        VaoifEFf3xu4qH0nlGRJvK4khLaVdG5AVIVbqIXqsBx+QdYoauKS0PFmBqJL5Nu+ujaOva
        36pXuM10anrv0L7OtFQJomoEyY/FK/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-fdAi4kdyMtWwFgGd05oe8Q-1; Thu, 13 Feb 2020 22:23:51 -0500
X-MC-Unique: fdAi4kdyMtWwFgGd05oe8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45C388017CC;
        Fri, 14 Feb 2020 03:23:48 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0CD338A;
        Fri, 14 Feb 2020 03:23:29 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8b3e6a9c-8bfd-fb3c-12a8-2d6a3879f1ae@redhat.com>
Date:   Fri, 14 Feb 2020 11:23:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200213150542.GW4271@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/13 =E4=B8=8B=E5=8D=8811:05, Jason Gunthorpe wrote:
> On Thu, Feb 13, 2020 at 10:58:44PM +0800, Jason Wang wrote:
>> On 2020/2/13 =E4=B8=8B=E5=8D=889:41, Jason Gunthorpe wrote:
>>> On Thu, Feb 13, 2020 at 11:34:10AM +0800, Jason Wang wrote:
>>>
>>>>>     You have dev, type or
>>>>> class to choose from. Type is rarely used and doesn't seem to be us=
ed
>>>>> by vdpa, so class seems the right choice
>>>>>
>>>>> Jason
>>>> Yes, but my understanding is class and bus are mutually exclusive. S=
o we
>>>> can't add a class to a device which is already attached on a bus.
>>> While I suppose there are variations, typically 'class' devices are
>>> user facing things and 'bus' devices are internal facing (ie like a
>>> PCI device)
>>
>> Though all vDPA devices have the same programming interface, but the
>> semantic is different. So it looks to me that use bus complies what
>> class.rst said:
>>
>> "
>>
>> Each device class defines a set of semantics and a programming interfa=
ce
>> that devices of that class adhere to. Device drivers are the
>> implementation of that programming interface for a particular device o=
n
>> a particular bus.
>>
>> "
> Here we are talking about the /dev/XX node that provides the
> programming interface.


I'm confused here, are you suggesting to use class to create char device=20
in vhost-vdpa? That's fine but the comment should go for vhost-vdpa patch=
.


> All the vdpa devices have the same basic
> chardev interface and discover any semantic variations 'in band'


That's not true, char interface is only used for vhost. Kernel virtio=20
driver does not need char dev but a device on the virtio bus.


>
>>> So why is this using a bus? VDPA is a user facing object, so the
>>> driver should create a class vhost_vdpa device directly, and that
>>> driver should live in the drivers/vhost/ directory.
>>  =20
>> This is because we want vDPA to be generic for being used by different
>> drivers which is not limited to vhost-vdpa. E.g in this series, it all=
ows
>> vDPA to be used by kernel virtio drivers. And in the future, we will
>> probably introduce more drivers in the future.
> I don't see how that connects with using a bus.


This is demonstrated in the virito-vdpa driver. So if you want to use=20
kernel virito driver for vDPA device, a bus is most straight forward.


>
> Every class of virtio traffic is going to need a special HW driver to
> enable VDPA, that special driver can create the correct vhost side
> class device.


Are you saying, e.g it's the charge of IFCVF driver to create vhost char=20
dev and other stuffs?


>
>>> For the PCI VF case this driver would bind to a PCI device like
>>> everything else
>>>
>>> For our future SF/ADI cases the driver would bind to some
>>> SF/ADI/whatever device on a bus.
>> All these driver will still be bound to their own bus (PCI or other). =
And
>> what the driver needs is to present a vDPA device to virtual vDPA bus =
on
>> top.
> Again, I can't see any reason to inject a 'vdpa virtual bus' on
> top. That seems like mis-using the driver core.


I don't think so. Vhost is not the only programming interface for vDPA.=20
We don't want a device that can only work for userspace drivers and only=20
have a single set of userspace APIs.

Thanks


>
> Jason
>

