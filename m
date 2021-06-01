Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886EE396BE8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 05:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhFADdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 23:33:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232592AbhFADdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 23:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622518323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wO/Ymt4rFpB9aPVUx2fOwYVlvuO0/tOHoU+BNz8BFGU=;
        b=TCjyoQyUBQENuXLQqlpGtdEZvf4/uz13Ok7dtJaPdw7gRXvUJuYdCrc0CvjtgWaq6P5+1/
        44LS9nfEuThdtwXH7yQTU3Wgwz/0aLx2eyuK6E/vgQ8d1Rtv6eshFR+Mf+eEmj554KdIqi
        7pC7sko7/4b+EanxHsg519iFSX56jUk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-GQTcvo-GOO242XM9os6wDQ-1; Mon, 31 May 2021 23:32:02 -0400
X-MC-Unique: GQTcvo-GOO242XM9os6wDQ-1
Received: by mail-pj1-f72.google.com with SMTP id kk5-20020a17090b4a05b029016102a8423cso766936pjb.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 20:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wO/Ymt4rFpB9aPVUx2fOwYVlvuO0/tOHoU+BNz8BFGU=;
        b=ZJKpJM1SBPi8IjDWICdy28ffefKAUbslR5buo6bLpnCoN8p1e4BTybgil+hsTFbxA0
         uVnuRzkKLc2EaycGuuAG+A7y2emM4dWKK5cyKiehLck2X2aCcDecplpn8PPVSFMhOlcL
         EbEUCY2UnMIvuDzSkyG+MSfIXSzjt99tXvVawMyQywt9kjgQqrcTqBACbqFbbJTHIL78
         RZOcBVAZc1CWaaH9/iEa4LyuC4G5GfREDXFyZT2CVEs+USxjmP6zvaHoujGTpUvoGKfN
         vjowLRd7vnuxKKhcIILJJParXml91YLol3h6BG1ECOf6TPeliDseE/oo/arkQGlWuk1K
         IkDg==
X-Gm-Message-State: AOAM530x+NSYwa4RBtTUcyFNDn3ykvGZlK3UTceGE+hqLlKuc+60+xv6
        O6iZZN9+NxmsKM+HskQP86AE9U0WZXDWvDJG6smFgVuR6eANlWEuARLJsEaa0TydSmZTH2zampO
        mCvCXLPhgLe33I5u2
X-Received: by 2002:a62:860b:0:b029:28e:d45b:4d2e with SMTP id x11-20020a62860b0000b029028ed45b4d2emr20061988pfd.70.1622518321021;
        Mon, 31 May 2021 20:32:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzz8tloqg4mNdNJcuGsMq7jMbGxC3NTMB3AeEEmzuoOAB9HUW4bJISV/+kfES7ueUEZ0B+d1A==
X-Received: by 2002:a62:860b:0:b029:28e:d45b:4d2e with SMTP id x11-20020a62860b0000b029028ed45b4d2emr20061973pfd.70.1622518320807;
        Mon, 31 May 2021 20:32:00 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r11sm12553574pgl.34.2021.05.31.20.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 20:32:00 -0700 (PDT)
Subject: Re: [PATCH V2 RESEND 2/2] vDPA/ifcvf: implement doorbell mapping for
 ifcvf
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210531073316.363655-1-lingshan.zhu@intel.com>
 <20210531073316.363655-3-lingshan.zhu@intel.com>
 <f3c28e92-3e8d-2a8a-ec5a-fc64f2098678@redhat.com>
 <5dbdc6a5-1510-9411-6b85-d947d091089c@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <91c64c0c-7b78-4c41-a6d7-6d9f084c7cc5@redhat.com>
Date:   Tue, 1 Jun 2021 11:31:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <5dbdc6a5-1510-9411-6b85-d947d091089c@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/1 上午11:27, Zhu, Lingshan 写道:
>
>
> On 5/31/2021 3:56 PM, Jason Wang wrote:
>>
>> 在 2021/5/31 下午3:33, Zhu Lingshan 写道:
>>> This commit implements doorbell mapping feature for ifcvf.
>>> This feature maps the notify page to userspace, to eliminate
>>> vmexit when kick a vq.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 17 +++++++++++++++++
>>>   1 file changed, 17 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index ab0ab5cf0f6e..effb0e549135 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -413,6 +413,22 @@ static int ifcvf_vdpa_get_vq_irq(struct 
>>> vdpa_device *vdpa_dev,
>>>       return vf->vring[qid].irq;
>>>   }
>>>   +static struct vdpa_notification_area 
>>> ifcvf_get_vq_notification(struct vdpa_device *vdpa_dev,
>>> +                                   u16 idx)
>>> +{
>>> +    struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
>>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>>> +    struct pci_dev *pdev = adapter->pdev;
>>> +    struct vdpa_notification_area area;
>>> +
>>> +    area.addr = vf->vring[idx].notify_pa;
>>> +    area.size = PAGE_SIZE;
>>> +    if (area.addr % PAGE_SIZE)
>>> +        IFCVF_DBG(pdev, "vq %u doorbell address is not PAGE_SIZE 
>>> aligned\n", idx);
>>
>>
>> Let's leave the decision to upper layer by: (see 
>> vp_vdpa_get_vq_notification)
>>
>> area.addr = notify_pa;
>> area.size = notify_offset_multiplier;
>>
>> Thanks
>
> Hi Jason,
>
> notify_offset_multiplier can be zero, means vqs share the same 
> doorbell address, distinguished by qid.
> and in vdpa.c:
>
>         if (vma->vm_end - vma->vm_start != notify.size)
>                 return -ENOTSUPP;
>
> so a zero size would cause this feature failure.
> mmap should work on at least a page, so if we really want "area.size = 
> notify_offset_multiplier;"
> I think we should add some code in vdpa.c, like:
>
> if(!notify.size)
>     notify.size = PAGE_SIZE;
>
> sounds good?


It's the responsibility of the driver to report a correct one. So I 
think it's better to tweak it as:

area.size = notify_offset_multiplier ?: PAGE_SIZE;

Thanks


>
> Thanks
> Zhu Lingshan
>>
>>
>>> +
>>> +    return area;
>>> +}
>>> +
>>>   /*
>>>    * IFCVF currently does't have on-chip IOMMU, so not
>>>    * implemented set_map()/dma_map()/dma_unmap()
>>> @@ -440,6 +456,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops 
>>> = {
>>>       .get_config    = ifcvf_vdpa_get_config,
>>>       .set_config    = ifcvf_vdpa_set_config,
>>>       .set_config_cb  = ifcvf_vdpa_set_config_cb,
>>> +    .get_vq_notification = ifcvf_get_vq_notification,
>>>   };
>>>     static int ifcvf_probe(struct pci_dev *pdev, const struct 
>>> pci_device_id *id)
>>
>

