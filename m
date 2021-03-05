Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB1732DFF6
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCEDL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:11:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhCEDL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614913916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRNOpSLwFJxiZfQagzjze9iaWCzAF8OGRLFEB+wT6tI=;
        b=YLBOzpRPG48V4uJOGoqmgAXQorKLf8zVDRI7jORLxFKJ4/cTfXTwsGUuwTmN3qVUKwWUbE
        n5ZsXEwtq9UcySHQQOtSIOOSjBLmRs+RKov3FjPz9Wq+i8JKRJuw7jqo+8jMiLDX9w35nS
        ZptaHUjUvD8GqtKyuKBYTSco13dRlDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-ZMZ_vDNzMG6EOd8-U9krxA-1; Thu, 04 Mar 2021 22:11:54 -0500
X-MC-Unique: ZMZ_vDNzMG6EOd8-U9krxA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E081107465F;
        Fri,  5 Mar 2021 03:11:52 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66B4A6268B;
        Fri,  5 Mar 2021 03:11:40 +0000 (UTC)
Subject: Re: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-12-xieyongji@bytedance.com>
 <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com>
 <CACycT3uaOU5ybwojfiSL0kSpW9GUnh82ZeDH7drdkfK72iP8bg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <86af7b84-23f0-dca7-183b-e4d586cbcea6@redhat.com>
Date:   Fri, 5 Mar 2021 11:11:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uaOU5ybwojfiSL0kSpW9GUnh82ZeDH7drdkfK72iP8bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/4 4:19 下午, Yongji Xie wrote:
> On Thu, Mar 4, 2021 at 3:30 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/2/23 7:50 下午, Xie Yongji wrote:
>>> Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
>>> injecting virtqueue's interrupt to the specified cpu.
>>
>> How userspace know which CPU is this irq for? It looks to me we need to
>> do it at different level.
>>
>> E.g introduce some API in sys to allow admin to tune for that.
>>
>> But I think we can do that in antoher patch on top of this series.
>>
> OK. I will think more about it.


It should be soemthing like 
/sys/class/vduse/$dev_name/vq/0/irq_affinity. Also need to make sure 
eventfd could not be reused.

Thanks


>
> Thanks,
> Yongji
>

