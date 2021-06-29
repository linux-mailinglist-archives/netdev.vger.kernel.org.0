Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129AE3B6D56
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 06:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhF2ENi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 00:13:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhF2ENh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 00:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624939870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=artctqxsXOBji6dZlUYYfDDilnt3HH/T60QvobzscDY=;
        b=YZT/4XRl066ZtTOCcetvTRH9LwohOJpfd4shwpKM0VTYBTXcCScIKnrwgUy+kzeVtbY7Ar
        2csefGi1IonOv2ZsmOy+L2m2xhnuRPCXzS3YYQtD4qZpW5nAendl6W6krnd+jjTkS2NTKj
        MBbn3FdDQpP1lIuXtAU/Q6ezLC4Pqdw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-7uUHsGt0OEKMqkMKWIuj8g-1; Tue, 29 Jun 2021 00:11:05 -0400
X-MC-Unique: 7uUHsGt0OEKMqkMKWIuj8g-1
Received: by mail-pf1-f197.google.com with SMTP id y29-20020a056a00181db02903062cdadd92so10672824pfa.3
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 21:11:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=artctqxsXOBji6dZlUYYfDDilnt3HH/T60QvobzscDY=;
        b=Kghw7GZv0L4UA/4umEOYWPqNe1JL2UDgBDojsH+H/rawx7hG4akwk7TdB+d8H1Wkus
         avk0UacrSFuSZJPPbbQ6aFBSQLtHb56oroLzgxYIJXOUWdw18vezdNpjHXkjbvhAIfZM
         AvGc8yybtSE16wo0SngWghk657NuDiLAS3uoxUGgK/2B6+g1RvDMNtsWjzjrt+YXzgwA
         PjTHtCy2vOQVt7RiqlM2E90+5l+uPY4jD55mmq6yq1OpNG4xvQ8UXwLBG63fEj17CrMc
         aByNDEaTf+adKmCdw+0yxEM70MhGK72vXfciLMWrE0fWsoBUJM5ftE/0fZeiFrgX/BZ9
         iZSQ==
X-Gm-Message-State: AOAM532xFsuTNINA9kzFOyRuQm33+jITay1ru8b+SrDdjXjLZid3//vA
        xigijgiMRUogjFBk5tcHHjjIdTmhFTKWRP1qINx13j0O/FqKdtxJxP0DZV6T1CV57c/iapXtTQ0
        p/cgu1M7a06Q+bZVm
X-Received: by 2002:a62:b616:0:b029:303:aa7b:b2e0 with SMTP id j22-20020a62b6160000b0290303aa7bb2e0mr28469459pff.21.1624939864874;
        Mon, 28 Jun 2021 21:11:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEtTsRWTzX+1HKlyYauA7LaEp1VCLZNHRfy5MStjoYEhho4d0zuZ1s0SoSqwSCB7kvsITcEw==
X-Received: by 2002:a62:b616:0:b029:303:aa7b:b2e0 with SMTP id j22-20020a62b6160000b0290303aa7bb2e0mr28469429pff.21.1624939864605;
        Mon, 28 Jun 2021 21:11:04 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cs1sm1085868pjb.56.2021.06.28.21.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 21:11:04 -0700 (PDT)
Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
To:     "Liu, Xiaodong" <xiaodong.liu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "parav@nvidia.com" <parav@nvidia.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "christian.brauner@canonical.com" <christian.brauner@canonical.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mika.penttila@nextfour.com" <mika.penttila@nextfour.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210628103309.GA205554@storage2.sh.intel.com>
 <bdbe3a79-e5ce-c3a5-4c68-c11c65857377@redhat.com>
 <BYAPR11MB2662FFF6140A4C634648BB2E8C039@BYAPR11MB2662.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <41cc419e-48b5-6755-0cb0-9033bd1310e4@redhat.com>
Date:   Tue, 29 Jun 2021 12:10:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <BYAPR11MB2662FFF6140A4C634648BB2E8C039@BYAPR11MB2662.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/28 下午1:54, Liu, Xiaodong 写道:
>> Several issues:
>>
>> - VDUSE needs to limit the total size of the bounce buffers (64M if I was not
>> wrong). Does it work for SPDK?
> Yes, Jason. It is enough and works for SPDK.
> Since it's a kind of bounce buffer mainly for in-flight IO, so limited size like
> 64MB is enough.


Ok.


>
>> - VDUSE can use hugepages but I'm not sure we can mandate hugepages (or we
>> need introduce new flags for supporting this)
> Same with your worry, I'm afraid too that it is a hard for a kernel module
> to directly preallocate hugepage internal.
> What I tried is that:
> 1. A simple agent daemon (represents for one device)  `preallocates` and maps
>      dozens of 2MB hugepages (like 64MB) for one device.
> 2. The daemon passes its mapping addr&len and hugepage fd to kernel
>      module through created IOCTL.
> 3. Kernel module remaps the hugepages inside kernel.


Such model should work, but the main "issue" is that it introduce  
overheads in the case of vhost-vDPA.

Note that in the case of vhost-vDPA, we don't use bounce buffer, the  
userspace pages were shared directly.

And since DMA is not done per page, it prevents us from using tricks  
like vm_insert_page() in those cases.


> 4. Vhost user target gets and maps hugepage fd from kernel module
>      in vhost-user msg through Unix Domain Socket cmsg.
> Then kernel module and target map on the same hugepage based
> bounce buffer for in-flight IO.
>
> If there is one option in VDUSE to map userspace preallocated memory, then
> VDUSE should be able to mandate it even it is hugepage based.
>

As above, this requires some kind of re-design since VDUSE depends on  
the model of mmap(MAP_SHARED) instead of umem registering.

Thanks

