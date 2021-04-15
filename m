Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223B3360539
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhDOJFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:05:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232100AbhDOJFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618477520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzvjiFIzYZkBsqCDMlTdrOnRQkd+YTOFRqgYIvls9tY=;
        b=fFd3c37bP+BWcU0aJCTiNx6s3JrvAQpvKaPDcOwoH/0coUqOPGXrgCoIZkUQFNf3NqJ7uM
        cbMq+virOGipEOCutOapwe7GcgzlTuuz6ZJHfvVq20PtYvR6FJxP2YUOb9bFppWcC3vtih
        Oh7lcBhV3voVSBYWFCVKnNejj7zyj4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-3fh0e0aYPsqfmelJdH-0Dw-1; Thu, 15 Apr 2021 05:05:16 -0400
X-MC-Unique: 3fh0e0aYPsqfmelJdH-0Dw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3B056D59B;
        Thu, 15 Apr 2021 09:05:13 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEDAE610FE;
        Thu, 15 Apr 2021 09:04:59 +0000 (UTC)
Subject: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
From:   Jason Wang <jasowang@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain>
 <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain>
 <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
Message-ID: <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com>
Date:   Thu, 15 Apr 2021 17:04:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/15 下午4:36, Jason Wang 写道:
>>>
>> Please state this explicitly at the start of the document. Existing
>> interfaces like FUSE are designed to avoid trusting userspace.
>
>
> There're some subtle difference here. VDUSE present a device to kernel 
> which means IOMMU is probably the only thing to prevent a malicous 
> device.
>
>
>> Therefore
>> people might think the same is the case here. It's critical that people
>> are aware of this before deploying VDUSE with virtio-vdpa.
>>
>> We should probably pause here and think about whether it's possible to
>> avoid trusting userspace. Even if it takes some effort and costs some
>> performance it would probably be worthwhile.
>
>
> Since the bounce buffer is used the only attack surface is the 
> coherent area, if we want to enforce stronger isolation we need to use 
> shadow virtqueue (which is proposed in earlier version by me) in this 
> case. But I'm not sure it's worth to do that.



So this reminds me the discussion in the end of last year. We need to 
make sure we don't suffer from the same issues for VDUSE at least

https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b

Or we can solve it at virtio level, e.g remember the dma address instead 
of depending on the addr in the descriptor ring

Thanks


>
>
>>
>> Is the security situation different with vhost-vdpa? In that case it
>> seems more likely that the host kernel doesn't need to trust the
>> userspace VDUSE device.

