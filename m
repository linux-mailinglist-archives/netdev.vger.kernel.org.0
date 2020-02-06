Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF799153D4B
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 04:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBFDKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 22:10:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42968 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727577AbgBFDKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 22:10:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580958603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1TczXbUHB/A1ibG/DqEE8S0FtOzhIhbj3hz2btGu3s=;
        b=KU7FRVlHo5RI4RPTb4LiQ6cjsxX5XWoFuoDzUGJLHOqyGJwuCookEZfahYqxuhLzhbeWyJ
        5nHk6rw8i4IVH/nLGWeIuhdNBHLCETc+gLiQroV+xWmgnMx+stYvsIYtbuWOXogHkND9DE
        SZw3WeZGTb0E9b229CKOxtKVigYzv6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-i1UTngbRMf-R7FlrhRD3mg-1; Wed, 05 Feb 2020 22:10:01 -0500
X-MC-Unique: i1UTngbRMf-R7FlrhRD3mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABA228018A7;
        Thu,  6 Feb 2020 03:09:58 +0000 (UTC)
Received: from [10.72.13.85] (ovpn-13-85.pek2.redhat.com [10.72.13.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 400941A7E3;
        Thu,  6 Feb 2020 03:09:43 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Shahaf Shuler <shahafs@mellanox.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
 <AM0PR0502MB3795AD42233D69F350402A8AC3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200205053129-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <80b4a5f9-8cc0-326a-a133-07a0ae3c7909@redhat.com>
Date:   Thu, 6 Feb 2020 11:09:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200205053129-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=886:33, Michael S. Tsirkin wrote:
> On Wed, Feb 05, 2020 at 09:30:14AM +0000, Shahaf Shuler wrote:
>> Wednesday, February 5, 2020 9:50 AM, Jason Wang:
>>> Subject: Re: [PATCH] vhost: introduce vDPA based backend
>>> On 2020/2/5 =E4=B8=8B=E5=8D=883:15, Shahaf Shuler wrote:
>>>> Wednesday, February 5, 2020 4:03 AM, Tiwei Bie:
>>>>> Subject: Re: [PATCH] vhost: introduce vDPA based backend
>>>>>
>>>>> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>>>>>> On 2020/1/31 =E4=B8=8A=E5=8D=8811:36, Tiwei Bie wrote:
>>>>>>> This patch introduces a vDPA based vhost backend. This backend is
>>>>>>> built on top of the same interface defined in virtio-vDPA and
>>>>>>> provides a generic vhost interface for userspace to accelerate th=
e
>>>>>>> virtio devices in guest.
>>>>>>>
>>>>>>> This backend is implemented as a vDPA device driver on top of the
>>>>>>> same ops used in virtio-vDPA. It will create char device entry
>>>>>>> named vhost-vdpa/$vdpa_device_index for userspace to use.
>>> Userspace
>>>>>>> can use vhost ioctls on top of this char device to setup the back=
end.
>>>>>>>
>>>>>>> Signed-off-by: Tiwei Bie<tiwei.bie@intel.com>
>>>> [...]
>>>>
>>>>>>> +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v) {
>>>>>>> +	/* TODO: fix this */
>>>>>> Before trying to do this it looks to me we need the following duri=
ng
>>>>>> the probe
>>>>>>
>>>>>> 1) if set_map() is not supported by the vDPA device probe the IOMM=
U
>>>>>> that is supported by the vDPA device
>>>>>> 2) allocate IOMMU domain
>>>>>>
>>>>>> And then:
>>>>>>
>>>>>> 3) pin pages through GUP and do proper accounting
>>>>>> 4) store GPA->HPA mapping in the umem
>>>>>> 5) generate diffs of memory table and using IOMMU API to setup the
>>>>>> dma mapping in this method
>>>>>>
>>>>>> For 1), I'm not sure parent is sufficient for to doing this or nee=
d
>>>>>> to introduce new API like iommu_device in mdev.
>>>>> Agree. We may also need to introduce something like the iommu_devic=
e.
>>>>>
>>>> Would it be better for the map/umnap logic to happen inside each dev=
ice ?
>>>> Devices that needs the IOMMU will call iommu APIs from inside the dr=
iver
>>> callback.
>>>
>>>
>>> Technically, this can work. But if it can be done by vhost-vpda it wi=
ll make the
>>> vDPA driver more compact and easier to be implemented.
>> Need to see the layering of such proposal but am not sure.
>> Vhost-vdpa is generic framework, while the DMA mapping is vendor speci=
fic.
>> Maybe vhost-vdpa can have some shared code needed to operate on iommu,=
 so drivers can re-use it.  to me it seems simpler than exposing a new io=
mmu device.
>>
>>>> Devices that has other ways to do the DMA mapping will call the
>>> proprietary APIs.
>>>
>>>
>>> To confirm, do you prefer:
>>>
>>> 1) map/unmap
>> It is not only that. AFAIR there also flush and invalidate calls, righ=
t?
>>
>>> or
>>>
>>> 2) pass all maps at one time?
>> To me this seems more straight forward.
>> It is correct that under hotplug and large number of memory segments
>> the driver will need to understand the diff (or not and just reload
>> the new configuration).
>> However, my assumption here is that memory
>> hotplug is heavy flow anyway, and the driver extra cycles will not be
>> that visible
> I think we can just allow both, after all vhost already has both interf=
aces ...
> We just need a flag that tells userspace whether it needs to
> update all maps aggressively or can wait for a fault.


It looks to me such flag is not a must and we can introduce it later=20
when device support page fault.

Thanks


