Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE3D3C81DE
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbhGNJpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:45:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238481AbhGNJpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626255729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZplaldvdPUqWqjFHRQy6XqAYb6B2IbOETrAj7lOt6Jc=;
        b=U/iYW3aw5IvGT0aLmnDGEgbNSbd3zFCuMNZvKUaU6vdvh/QQ3wHtRhFO8uI/3Yie8wQicU
        A0VzkvKIq4XVYe2Pz89y/TfGPrHHYaqbLAtkTA32Rg5QWVy+NaiLybW60HuUIXYIm1eYq7
        IR5D4ADt9M7YDgtgA9PJudwghn9bWfk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-GVOVLMMpP72esaGWk9kIOA-1; Wed, 14 Jul 2021 05:42:08 -0400
X-MC-Unique: GVOVLMMpP72esaGWk9kIOA-1
Received: by mail-pj1-f72.google.com with SMTP id x2-20020a17090ab002b029016e8b858193so1156112pjq.3
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZplaldvdPUqWqjFHRQy6XqAYb6B2IbOETrAj7lOt6Jc=;
        b=cQw9fuLBav3OvnBIdVNFxigilgjIzunxU8D90+Q9dX97xhEx7PT+Z4BUcmnJPhkIXD
         M7rSAnrsrH+ibR56U19vmZM8es2U5CW0iJgNT7VlUuZaFOLHEsgLIf2d2S0NRyU8WU4d
         ENn3NoQoJu0Ca72WAe38sh0viigD3AnGcWGqIlsHVIaOfKDUSbzEIwsIuy/Ckvurb7Ju
         glC10tX35dQqnwbYZQYPs32NGiDjbfkRn86/DSw4lAom8ZFkQLO3+wYkQnLbdx4etNXI
         slczkwX2kkRPEkzYaxiC2UylG9iTxFOPKUvA5nI4gBoupZGulsVAvBk1Nbvq3vIpfyaO
         laVg==
X-Gm-Message-State: AOAM530zxne6pMTfeq/2mIG9p0Q1spH89jDrw+/livN/Lae4r0FYHKDu
        CxbdV9R8pu1suE9Dt0z1+eKs4yWGCd8uUaXaqLOZDR/7+NDjdHrYkwHVVR8zNMc1BpTjM3TIoJj
        vAA1UTPJvCqqNCxuC
X-Received: by 2002:a17:90a:7a86:: with SMTP id q6mr3009916pjf.141.1626255727203;
        Wed, 14 Jul 2021 02:42:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzB8iUML1glTVs5bknbuEkym014DDJoi+0qmllMveSYsw48CwsnGAccGqgHSeXUC5btvXZSoA==
X-Received: by 2002:a17:90a:7a86:: with SMTP id q6mr3009902pjf.141.1626255726913;
        Wed, 14 Jul 2021 02:42:06 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p5sm2075572pfn.46.2021.07.14.02.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 02:42:06 -0700 (PDT)
Subject: Re: [PATCH v9 13/17] vdpa: factor out vhost_vdpa_pa_map() and
 vhost_vdpa_pa_unmap()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-14-xieyongji@bytedance.com> <20210713113114.GL1954@kadam>
 <20e75b53-0dce-2f2d-b717-f78553bddcd8@redhat.com>
 <20210714080512.GW1954@kadam>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <db02315d-0ffe-f4a2-da67-5a014060fa4a@redhat.com>
Date:   Wed, 14 Jul 2021 17:41:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714080512.GW1954@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/14 下午4:05, Dan Carpenter 写道:
> On Wed, Jul 14, 2021 at 10:14:32AM +0800, Jason Wang wrote:
>> 在 2021/7/13 下午7:31, Dan Carpenter 写道:
>>> On Tue, Jul 13, 2021 at 04:46:52PM +0800, Xie Yongji wrote:
>>>> @@ -613,37 +618,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>>>>    	}
>>>>    }
>>>> -static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>>>> -					   struct vhost_iotlb_msg *msg)
>>>> +static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
>>>> +			     u64 iova, u64 size, u64 uaddr, u32 perm)
>>>>    {
>>>>    	struct vhost_dev *dev = &v->vdev;
>>>> -	struct vhost_iotlb *iotlb = dev->iotlb;
>>>>    	struct page **page_list;
>>>>    	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>>>>    	unsigned int gup_flags = FOLL_LONGTERM;
>>>>    	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
>>>>    	unsigned long lock_limit, sz2pin, nchunks, i;
>>>> -	u64 iova = msg->iova;
>>>> +	u64 start = iova;
>>>>    	long pinned;
>>>>    	int ret = 0;
>>>> -	if (msg->iova < v->range.first ||
>>>> -	    msg->iova + msg->size - 1 > v->range.last)
>>>> -		return -EINVAL;
>>> This is not related to your patch, but can the "msg->iova + msg->size"
>>> addition can have an integer overflow.  From looking at the callers it
>>> seems like it can.  msg comes from:
>>>     vhost_chr_write_iter()
>>>     --> dev->msg_handler(dev, &msg);
>>>         --> vhost_vdpa_process_iotlb_msg()
>>>            --> vhost_vdpa_process_iotlb_update()
>>
>> Yes.
>>
>>
>>> If I'm thinking of the right thing then these are allowed to overflow to
>>> 0 because of the " - 1" but not further than that.  I believe the check
>>> needs to be something like:
>>>
>>> 	if (msg->iova < v->range.first ||
>>> 	    msg->iova - 1 > U64_MAX - msg->size ||
>>
>> I guess we don't need - 1 here?
> The - 1 is important.  The highest address is 0xffffffff.  So it goes
> start + size = 0 and then start + size - 1 == 0xffffffff.


Right, so actually

msg->iova = 0xfffffffe, msg->size=2 is valid.

Thanks


>
> I guess we could move the - 1 to the other side?
>
> 	msg->iova > U64_MAX - msg->size + 1 ||
>
> regards,
> dan carpenter
>
>

