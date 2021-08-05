Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4493E0EF7
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhHEHNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:13:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237556AbhHEHNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 03:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628147571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n0VxlG+I9DtspBlzYcgwvjsV5zD4hYtPEcF5uDUSb8k=;
        b=WnKShFfOo6rJV5EhQ9lb/uy7ktJQ7UGiYB787gx3g1QbQjDkMN2WZaPNV3i6eIIRfd7lWW
        xpPS6on/6Pslm66W77lCqGMyNUHz/W8xC7Pt8oXhPyihmDUVYm0crXhsdApFNo91BKeQti
        nD3m68uyx3SX8yz1rQkutZ6tX+65Omw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-grOnNDXJPWqGW_MGqhvIKQ-1; Thu, 05 Aug 2021 03:12:49 -0400
X-MC-Unique: grOnNDXJPWqGW_MGqhvIKQ-1
Received: by mail-pl1-f197.google.com with SMTP id p5-20020a170902a405b029012cbb4fcc03so4083075plq.19
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 00:12:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=n0VxlG+I9DtspBlzYcgwvjsV5zD4hYtPEcF5uDUSb8k=;
        b=P7kw25gKQj/plrphuIggJdsQkd+7Nx0vzONhAitai5Tq7EX4GIUtUMDVfTeIdH8w7R
         i83QDef/rx4qj/Al/Rj3KxMFTy846/W3HJqN1pfSHifKtz5W9YiIO2RGjxUqV31icp8a
         93G4rnFc7MEqwAU78ftHkyYvOCmJyslWWSXabbCVd1L2rc4a0pDf3WrgdOHJ+kNNi899
         xY7J+Z1HCJYyXyDKfC7c0rqpCPMAB4ZXeMN5+fs72OwextmYlXa/+aBgFrxr3kCHn/KB
         19mBqk38QpnxpLuIjP+DQ1iwznovRnT6+Z64F6I/6Nhf9cRCLeJBnx6wnLoGi9wjSU6Z
         NRBg==
X-Gm-Message-State: AOAM533boLteGJkzMbiCjsq0hbeiVRmAQdynSG6opW2Q4Y1ter1GyB24
        fYb0/7i/FeG3/R2F7L2WxS2nnPPqzV1XmfsruTVTOFnqbnNQW9pFh7xqdZyaLj3EVWg65cd0QCz
        pffO1JgM1h5Cn2nVV
X-Received: by 2002:a63:190b:: with SMTP id z11mr654562pgl.320.1628147568773;
        Thu, 05 Aug 2021 00:12:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUfHRxG/dXx9YH24cRrMopBNWNIkigiB28PNmXNoiyFNr8yDY8zBJY64Y2tGLqmxO/3wI2WA==
X-Received: by 2002:a63:190b:: with SMTP id z11mr654537pgl.320.1628147568588;
        Thu, 05 Aug 2021 00:12:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k8sm5028086pfu.116.2021.08.05.00.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 00:12:48 -0700 (PDT)
Subject: Re: [PATCH v10 10/17] virtio: Handle device reset failure in
 register_virtio_device()
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-11-xieyongji@bytedance.com>
 <6bb6c689-e6dd-cfa2-094b-a0ca4258aded@redhat.com>
 <CACycT3v7BHxYY0OFYJRFU41Bz1=_v8iMRwzYKgX6cJM-SiNH+A@mail.gmail.com>
 <fdcb0224-11f9-caf2-a44e-e6406087fd50@redhat.com>
 <CACycT3v0EQVrv_A1K1bKmiYu0q5aFE=t+0yRaWKC7T3_H3oB-Q@mail.gmail.com>
 <bd48ec76-0d5c-2efb-8406-894286b28f6b@redhat.com>
 <CACycT3tUwJXUV24PK7OvzPrHYYeQ5Q3qUW_vbuFMjwig0dBw2g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ae529e8a-67a2-b235-1404-4623d57031d6@redhat.com>
Date:   Thu, 5 Aug 2021 15:12:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3tUwJXUV24PK7OvzPrHYYeQ5Q3qUW_vbuFMjwig0dBw2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/8/4 下午5:07, Yongji Xie 写道:
> On Wed, Aug 4, 2021 at 4:54 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/8/4 下午4:50, Yongji Xie 写道:
>>> On Wed, Aug 4, 2021 at 4:32 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/8/3 下午5:38, Yongji Xie 写道:
>>>>> On Tue, Aug 3, 2021 at 4:09 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>>>>>> The device reset may fail in virtio-vdpa case now, so add checks to
>>>>>>> its return value and fail the register_virtio_device().
>>>>>> So the reset() would be called by the driver during remove as well, or
>>>>>> is it sufficient to deal only with the reset during probe?
>>>>>>
>>>>> Actually there is no way to handle failure during removal. And it
>>>>> should be safe with the protection of software IOTLB even if the
>>>>> reset() fails.
>>>>>
>>>>> Thanks,
>>>>> Yongji
>>>> If this is true, does it mean we don't even need to care about reset
>>>> failure?
>>>>
>>> But we need to handle the failure in the vhost-vdpa case, isn't it?
>>
>> Yes, but:
>>
>> - This patch is for virtio not for vhost, if we don't care virtio, we
>> can avoid the changes
>> - For vhost, there could be two ways probably:
>>
>> 1) let the set_status to report error
>> 2) require userspace to re-read for status
>>
>> It looks to me you want to go with 1) and I'm not sure whether or not
>> it's too late to go with 2).
>>
> Looks like 2) can't work if reset failure happens in
> vhost_vdpa_release() and vhost_vdpa_open().


Yes, you're right.

Thanks


>
> Thanks,
> Yongji
>

