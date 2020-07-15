Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3312207A7
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgGOInS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:43:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53158 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729503AbgGOInR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594802596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3ATeHeFF1J37NbSRujlNcK6+iTDVTNL3b6nVYG9gNI=;
        b=BdCsp6n4x6lml+v1/P0NIfy4epVqOnRGmryBJDQYcrkTzngcy0PkdV/sP3ZFTgI26R2zV8
        jfJOT09/hSkw9a6JaHQV0RqPTooqGlECq3YTRpZvxEXw4Lh7AqCejgu9E5uMV5SSYPqxRd
        ZRPSO5beS5puYTu/ihXOMitk4AS4yEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-k8z0oujvNH-_u1V4kBvS-Q-1; Wed, 15 Jul 2020 04:43:14 -0400
X-MC-Unique: k8z0oujvNH-_u1V4kBvS-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5FC100CCC1;
        Wed, 15 Jul 2020 08:43:13 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F7D66FEF4;
        Wed, 15 Jul 2020 08:43:06 +0000 (UTC)
Subject: Re: [PATCH 5/7] virtio_vdpa: init IRQ offloading function pointers to
 NULL.
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-5-git-send-email-lingshan.zhu@intel.com>
 <276bf939-8e12-e28a-64f7-1767851e0db5@redhat.com>
 <ba1ea94c-b0ae-8bd8-8425-64b096512d3d@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d5b12368-7d78-6c0b-e593-289594d11985@redhat.com>
Date:   Wed, 15 Jul 2020 16:43:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ba1ea94c-b0ae-8bd8-8425-64b096512d3d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/13 下午6:20, Zhu, Lingshan wrote:
>
>
> On 7/13/2020 4:28 PM, Jason Wang wrote:
>>
>> On 2020/7/12 下午10:49, Zhu Lingshan wrote:
>>> This commit initialize IRQ offloading function pointers in
>>> virtio_vdpa_driver to NULL. Becasue irq offloading only focus
>>> on VMs for vhost_vdpa.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/virtio/virtio_vdpa.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/virtio/virtio_vdpa.c 
>>> b/drivers/virtio/virtio_vdpa.c
>>> index c30eb55..1e8acb9 100644
>>> --- a/drivers/virtio/virtio_vdpa.c
>>> +++ b/drivers/virtio/virtio_vdpa.c
>>> @@ -386,6 +386,8 @@ static void virtio_vdpa_remove(struct 
>>> vdpa_device *vdpa)
>>>       },
>>>       .probe    = virtio_vdpa_probe,
>>>       .remove = virtio_vdpa_remove,
>>> +    .setup_vq_irq = NULL,
>>> +    .unsetup_vq_irq = NULL,
>>>   };
>>
>>
>> Is this really needed consider the it's static?
>>
>> Thanks
> This is for readability, to show they are NULL, so virtio_vdpa would not go through irq forwarding / offloading.
>
> Does this make sense?


Probably not, please refer what is done by other subsystems.

Thanks


>
> Thanks,
> BR
> Zhu Lingshan
>>
>>
>>> module_vdpa_driver(virtio_vdpa_driver);
>>

