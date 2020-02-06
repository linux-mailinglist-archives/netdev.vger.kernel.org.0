Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA529153D41
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 04:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgBFDIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 22:08:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45906 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727703AbgBFDIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 22:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580958498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ofht4rTASrG2snsF2udWXLpOAWyq8ZOtG/BsyPM5Yj4=;
        b=DfArRHpeiitC+7vYkkFUGizFqN0yjhjgtOufVxW9kTUXbCB/Om5SjKbw6MIc5udWzDfsjo
        39fgfqEZwnYNlVM0YuY8rYXZLgzFWkYdEOXa9CiW4fBTL5T6l7yT5DrxAE50/l78kRInPV
        2X07vFi2LJ0rLLX3n/vNDtlAvi3x6ws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-X7uWwfe4On2D9cXt6zrN6w-1; Wed, 05 Feb 2020 22:08:17 -0500
X-MC-Unique: X7uWwfe4On2D9cXt6zrN6w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8894A107BAA4;
        Thu,  6 Feb 2020 03:08:14 +0000 (UTC)
Received: from [10.72.13.85] (ovpn-13-85.pek2.redhat.com [10.72.13.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 361F060C18;
        Thu,  6 Feb 2020 03:07:56 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
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
 <20200205042259-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7519cde6-2c79-6867-d72d-05be73d947a6@redhat.com>
Date:   Thu, 6 Feb 2020 11:07:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200205042259-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=885:23, Michael S. Tsirkin wrote:
> On Wed, Feb 05, 2020 at 03:50:14PM +0800, Jason Wang wrote:
>> On 2020/2/5 =C3=A4=C2=B8=E2=80=B9=C3=A5=C2=8D=CB=863:15, Shahaf Shuler=
 wrote:
>>> Wednesday, February 5, 2020 4:03 AM, Tiwei Bie:
>>>> Subject: Re: [PATCH] vhost: introduce vDPA based backend
>>>>
>>>> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>>>>> On 2020/1/31 =C3=A4=C2=B8=C5=A0=C3=A5=C2=8D=CB=8611:36, Tiwei Bie w=
rote:
>>>>>> This patch introduces a vDPA based vhost backend. This backend is
>>>>>> built on top of the same interface defined in virtio-vDPA and
>>>>>> provides a generic vhost interface for userspace to accelerate the
>>>>>> virtio devices in guest.
>>>>>>
>>>>>> This backend is implemented as a vDPA device driver on top of the
>>>>>> same ops used in virtio-vDPA. It will create char device entry nam=
ed
>>>>>> vhost-vdpa/$vdpa_device_index for userspace to use. Userspace can
>>>>>> use vhost ioctls on top of this char device to setup the backend.
>>>>>>
>>>>>> Signed-off-by: Tiwei Bie<tiwei.bie@intel.com>
>>> [...]
>>>
>>>>>> +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v) {
>>>>>> +	/* TODO: fix this */
>>>>> Before trying to do this it looks to me we need the following durin=
g
>>>>> the probe
>>>>>
>>>>> 1) if set_map() is not supported by the vDPA device probe the IOMMU
>>>>> that is supported by the vDPA device
>>>>> 2) allocate IOMMU domain
>>>>>
>>>>> And then:
>>>>>
>>>>> 3) pin pages through GUP and do proper accounting
>>>>> 4) store GPA->HPA mapping in the umem
>>>>> 5) generate diffs of memory table and using IOMMU API to setup the =
dma
>>>>> mapping in this method
>>>>>
>>>>> For 1), I'm not sure parent is sufficient for to doing this or need=
 to
>>>>> introduce new API like iommu_device in mdev.
>>>> Agree. We may also need to introduce something like the iommu_device=
.
>>>>
>>> Would it be better for the map/umnap logic to happen inside each devi=
ce ?
>>> Devices that needs the IOMMU will call iommu APIs from inside the dri=
ver callback.
>> Technically, this can work. But if it can be done by vhost-vpda it wil=
l make
>> the vDPA driver more compact and easier to be implemented.
>>
>>
>>> Devices that has other ways to do the DMA mapping will call the propr=
ietary APIs.
>> To confirm, do you prefer:
>>
>> 1) map/unmap
>>
>> or
>>
>> 2) pass all maps at one time?
>>
>> Thanks
>>
>>
> I mean we really already have both right? ATM 1 is used with an iommu
> and 2 without. I guess we can also have drivers ask for either or both
> ...


Yes, that looks better.

Thanks

