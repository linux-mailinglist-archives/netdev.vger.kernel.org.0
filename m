Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E33DFD5A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 10:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhHDIy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 04:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236762AbhHDIy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 04:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628067254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JEJS6wNFWZnl108KgJLIgK1xlv8/2mIWHkixRJuOciE=;
        b=WDsLGIXcQBI4Ril5/9VQX1fkPJ/grCepT7vlIrTdAtQ4UOEBu7b11hn2L6Brgxjp06R5YM
        NH3mWRnF7KhWaX7EJFxj0aardBJ2gCIl/2quHVxREqQghsfd+uNtMO+YrJBk9Dn+k+U8Ch
        o2LLrPScCMILps+Y3Dyl5BMovQI6ifU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-2ta5E3yvOueKUAqjnje4iQ-1; Wed, 04 Aug 2021 04:54:12 -0400
X-MC-Unique: 2ta5E3yvOueKUAqjnje4iQ-1
Received: by mail-pl1-f200.google.com with SMTP id l16-20020a170902f690b029012cb82f15afso1649603plg.10
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 01:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JEJS6wNFWZnl108KgJLIgK1xlv8/2mIWHkixRJuOciE=;
        b=sZMf+uQAw0ok/YYFCrMo5uMFsBupHHK1xNEB+Af2Q7qvMvzTmEFQWQ+Ni+Cz9rzoZr
         E2ROlVw6FLGUXfdIycHCQn3CF0kU/jKPakanZKXhrhqi463R9j8S9lcKyC7n9xpnAAFH
         B2KUsV9iHOoUG5jx5PIXkVQDLMYkRL/cYMSXNlA/5cLkXMM3WGrg0NWCuuxwtrL9W5S4
         uBrpef1jLzkB/lfd48sLcjKdj6jK4Bhpl/MThAGbJFCcrsw7Num0DcVm7BZ9Kv5agC5f
         KVob26gtpPvQTeTASRjt58uYhEAKumUd8ZmwTrCDYw1/pWOcb816A4gyzSuxOwEUgW+w
         5VPA==
X-Gm-Message-State: AOAM532dbwU7DaR4m4fe8BM/Ppz8HmQdks5y2MbGnMIHGhACuRW7cqMC
        dZhAZh1cAcTGgT1VhFxOTQj0Vq/KhtRhC9wEG7gXxKOGQ4i4lBXqdO83MSsP07qFyyvvg0Rpyo/
        J+SL3ezislltVBiku
X-Received: by 2002:a17:90a:f486:: with SMTP id bx6mr26967684pjb.26.1628067251872;
        Wed, 04 Aug 2021 01:54:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdg7DPc1fVvfeRYsMAj9zuHXHxH4WMFyt0BnuNiFR52VmL83Bg8evPgUiXWSZNAPGcbnx9HQ==
X-Received: by 2002:a17:90a:f486:: with SMTP id bx6mr26967649pjb.26.1628067251626;
        Wed, 04 Aug 2021 01:54:11 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 6sm1963202pfg.108.2021.08.04.01.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 01:54:11 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bd48ec76-0d5c-2efb-8406-894286b28f6b@redhat.com>
Date:   Wed, 4 Aug 2021 16:54:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3v0EQVrv_A1K1bKmiYu0q5aFE=t+0yRaWKC7T3_H3oB-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/8/4 下午4:50, Yongji Xie 写道:
> On Wed, Aug 4, 2021 at 4:32 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/8/3 下午5:38, Yongji Xie 写道:
>>> On Tue, Aug 3, 2021 at 4:09 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>>>> The device reset may fail in virtio-vdpa case now, so add checks to
>>>>> its return value and fail the register_virtio_device().
>>>> So the reset() would be called by the driver during remove as well, or
>>>> is it sufficient to deal only with the reset during probe?
>>>>
>>> Actually there is no way to handle failure during removal. And it
>>> should be safe with the protection of software IOTLB even if the
>>> reset() fails.
>>>
>>> Thanks,
>>> Yongji
>>
>> If this is true, does it mean we don't even need to care about reset
>> failure?
>>
> But we need to handle the failure in the vhost-vdpa case, isn't it?


Yes, but:

- This patch is for virtio not for vhost, if we don't care virtio, we 
can avoid the changes
- For vhost, there could be two ways probably:

1) let the set_status to report error
2) require userspace to re-read for status

It looks to me you want to go with 1) and I'm not sure whether or not 
it's too late to go with 2).

Thanks


>
> Thanks,
> Yongji
>

