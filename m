Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADED152734
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 08:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgBEHvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 02:51:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39627 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725468AbgBEHvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 02:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580889061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YQLo/Dujelpm0XrehqZm62mCFlSLkIvoH/a0QZl9D2s=;
        b=Q99F0HvUrenx935z7sUnwylWNIvHETMvhBqHcQfA5QSeLFP0CivbbCxdWAu86vlMc8HtFB
        if9r9jUFq5/rKmxd6ngkh/5fUCitC6fr8vRDslnrMJqvA7I4uZH+3H+Eb7XcVFb73Dzzql
        lArdzsLIhSUG19TjBT6RGs9f34c7wP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-GBTihHV3M3uxJzsoVeentg-1; Wed, 05 Feb 2020 02:50:59 -0500
X-MC-Unique: GBTihHV3M3uxJzsoVeentg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 826968010EF;
        Wed,  5 Feb 2020 07:50:56 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8648C7792A;
        Wed,  5 Feb 2020 07:50:23 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
Date:   Wed, 5 Feb 2020 15:50:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=883:15, Shahaf Shuler wrote:
> Wednesday, February 5, 2020 4:03 AM, Tiwei Bie:
>> Subject: Re: [PATCH] vhost: introduce vDPA based backend
>>
>> On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
>>> On 2020/1/31 =E4=B8=8A=E5=8D=8811:36, Tiwei Bie wrote:
>>>> This patch introduces a vDPA based vhost backend. This backend is
>>>> built on top of the same interface defined in virtio-vDPA and
>>>> provides a generic vhost interface for userspace to accelerate the
>>>> virtio devices in guest.
>>>>
>>>> This backend is implemented as a vDPA device driver on top of the
>>>> same ops used in virtio-vDPA. It will create char device entry named
>>>> vhost-vdpa/$vdpa_device_index for userspace to use. Userspace can
>>>> use vhost ioctls on top of this char device to setup the backend.
>>>>
>>>> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> [...]
>
>>>> +static long vhost_vdpa_do_dma_mapping(struct vhost_vdpa *v) {
>>>> +	/* TODO: fix this */
>>>
>>> Before trying to do this it looks to me we need the following during
>>> the probe
>>>
>>> 1) if set_map() is not supported by the vDPA device probe the IOMMU
>>> that is supported by the vDPA device
>>> 2) allocate IOMMU domain
>>>
>>> And then:
>>>
>>> 3) pin pages through GUP and do proper accounting
>>> 4) store GPA->HPA mapping in the umem
>>> 5) generate diffs of memory table and using IOMMU API to setup the dm=
a
>>> mapping in this method
>>>
>>> For 1), I'm not sure parent is sufficient for to doing this or need t=
o
>>> introduce new API like iommu_device in mdev.
>> Agree. We may also need to introduce something like the iommu_device.
>>
> Would it be better for the map/umnap logic to happen inside each device=
 ?
> Devices that needs the IOMMU will call iommu APIs from inside the drive=
r callback.


Technically, this can work. But if it can be done by vhost-vpda it will=20
make the vDPA driver more compact and easier to be implemented.


> Devices that has other ways to do the DMA mapping will call the proprie=
tary APIs.


To confirm, do you prefer:

1) map/unmap

or

2) pass all maps at one time?

Thanks


>

