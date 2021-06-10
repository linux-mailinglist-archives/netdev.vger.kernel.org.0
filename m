Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11063A2305
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 06:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJEEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 00:04:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbhFJEEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 00:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623297771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXvZ6tuoPkEIoxHMDeEeqKamN/QqFwtdpQS3VL200LM=;
        b=anlLlpn7xbZZyoP5l93owSI0ZdMFSAvPB9zG3OQycsRkmQg7KkFew0MDl02L5qOpnQxM/x
        UpANjbfZiLW23LECy4DOKaDFE4pdOJCJAb5kYuFvAYpfpws3hmH7IqC9RCbW/fWoQPnfzn
        f+me0GUjJQgt2ZgVqHWemOMjoWQo4zk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-pnfzIZ_fMj-tSgMUw0wFQQ-1; Thu, 10 Jun 2021 00:02:49 -0400
X-MC-Unique: pnfzIZ_fMj-tSgMUw0wFQQ-1
Received: by mail-pl1-f200.google.com with SMTP id e19-20020a170902ed93b0290110a7ccff51so319726plj.20
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 21:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SXvZ6tuoPkEIoxHMDeEeqKamN/QqFwtdpQS3VL200LM=;
        b=HE2e4xu7kV0iNhfACNLFhGlr9l26QzjkLXi7QeeiVhNfz2kX/wvWtNnk1leAe6W2vg
         Wj72eCR1h+e4QRuNzSvn20jaBjYbAdU9b2SrZ6rroXG6YwKVaMR7ngch0Hg4Z050en8s
         Jzp+ongF9Duxw+zbtkk0hpZojhO5HbMuI7PWC+24eCgr+QxmAWUAouliGcSsKcv1YMtj
         mkWbdcvd6+zeb50ttFNHn++FvF6F/Rr7S8CbpMUHq4OAKwGJuV10ErTtnVzpDDvxE9oR
         XU7a9d+Ix2p7Xh0wTSgz4dJins15QdXAVuZws8lrHALkxJS6qy+h9B5jXEuhuiViZGpn
         oPsQ==
X-Gm-Message-State: AOAM533I28b15OopAfhsoezEbiPEbwhKgy8q1e2XcOxpJ91GdL4UGcye
        zJTQYI/n4k/voG/XnmDpls96SZgSeKvbLq+ClMQyPwuZ1d24GirrSpDzgCvPmEE7TTyugZuTrbh
        w2MtetDhJLWJt6zV1
X-Received: by 2002:a62:30c2:0:b029:289:116c:ec81 with SMTP id w185-20020a6230c20000b0290289116cec81mr1068667pfw.42.1623297768742;
        Wed, 09 Jun 2021 21:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVU961zRB+Y9SorZKkIgfJPcbM10PZ2K2e5HZSOxfr9z+jedPA7qXZVldVdXfDjt/JlhuXbA==
X-Received: by 2002:a62:30c2:0:b029:289:116c:ec81 with SMTP id w185-20020a6230c20000b0290289116cec81mr1068621pfw.42.1623297768474;
        Wed, 09 Jun 2021 21:02:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j7sm6490106pjf.0.2021.06.09.21.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 21:02:48 -0700 (PDT)
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
To:     "Jiang Wang ." <jiang.wang@bytedance.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com>
 <CAP_N_Z_VDd+JUJ_Y-peOEc7FgwNGB8O3uZpVumQT_DbW62Jpjw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ac0c241c-1013-1304-036f-504d0edc5fd7@redhat.com>
Date:   Thu, 10 Jun 2021 12:02:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAP_N_Z_VDd+JUJ_Y-peOEc7FgwNGB8O3uZpVumQT_DbW62Jpjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 上午11:43, Jiang Wang . 写道:
> On Wed, Jun 9, 2021 at 6:51 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/10 上午7:24, Jiang Wang 写道:
>>> This patchset implements support of SOCK_DGRAM for virtio
>>> transport.
>>>
>>> Datagram sockets are connectionless and unreliable. To avoid unfair contention
>>> with stream and other sockets, add two more virtqueues and
>>> a new feature bit to indicate if those two new queues exist or not.
>>>
>>> Dgram does not use the existing credit update mechanism for
>>> stream sockets. When sending from the guest/driver, sending packets
>>> synchronously, so the sender will get an error when the virtqueue is full.
>>> When sending from the host/device, send packets asynchronously
>>> because the descriptor memory belongs to the corresponding QEMU
>>> process.
>>
>> What's the use case for the datagram vsock?
>>
> One use case is for non critical info logging from the guest
> to the host, such as the performance data of some applications.


Anything that prevents you from using the stream socket?


>
> It can also be used to replace UDP communications between
> the guest and the host.


Any advantage for VSOCK in this case? Is it for performance (I guess not 
since I don't exepct vsock will be faster).

An obvious drawback is that it breaks the migration. Using UDP you can 
have a very rich features support from the kernel where vsock can't.


>
>>> The virtio spec patch is here:
>>> https://www.spinics.net/lists/linux-virtualization/msg50027.html
>>
>> Have a quick glance, I suggest to split mergeable rx buffer into an
>> separate patch.
> Sure.
>
>> But I think it's time to revisit the idea of unifying the virtio-net and
>> virtio-vsock. Otherwise we're duplicating features and bugs.
> For mergeable rxbuf related code, I think a set of common helper
> functions can be used by both virtio-net and virtio-vsock. For other
> parts, that may not be very beneficial. I will think about more.
>
> If there is a previous email discussion about this topic, could you send me
> some links? I did a quick web search but did not find any related
> info. Thanks.


We had a lot:

[1] 
https://patchwork.kernel.org/project/kvm/patch/5BDFF537.3050806@huawei.com/
[2] 
https://lists.linuxfoundation.org/pipermail/virtualization/2018-November/039798.html
[3] https://www.lkml.org/lkml/2020/1/16/2043

Thanks

>
>> Thanks
>>
>>
>>> For those who prefer git repo, here is the link for the linux kernel：
>>> https://github.com/Jiang1155/linux/tree/vsock-dgram-v1
>>>
>>> qemu patch link:
>>> https://github.com/Jiang1155/qemu/tree/vsock-dgram-v1
>>>
>>>
>>> To do:
>>> 1. use skb when receiving packets
>>> 2. support multiple transport
>>> 3. support mergeable rx buffer
>>>
>>>
>>> Jiang Wang (6):
>>>     virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>>>     virtio/vsock: add support for virtio datagram
>>>     vhost/vsock: add support for vhost dgram.
>>>     vsock_test: add tests for vsock dgram
>>>     vhost/vsock: add kconfig for vhost dgram support
>>>     virtio/vsock: add sysfs for rx buf len for dgram
>>>
>>>    drivers/vhost/Kconfig                              |   8 +
>>>    drivers/vhost/vsock.c                              | 207 ++++++++--
>>>    include/linux/virtio_vsock.h                       |   9 +
>>>    include/net/af_vsock.h                             |   1 +
>>>    .../trace/events/vsock_virtio_transport_common.h   |   5 +-
>>>    include/uapi/linux/virtio_vsock.h                  |   4 +
>>>    net/vmw_vsock/af_vsock.c                           |  12 +
>>>    net/vmw_vsock/virtio_transport.c                   | 433 ++++++++++++++++++---
>>>    net/vmw_vsock/virtio_transport_common.c            | 184 ++++++++-
>>>    tools/testing/vsock/util.c                         | 105 +++++
>>>    tools/testing/vsock/util.h                         |   4 +
>>>    tools/testing/vsock/vsock_test.c                   | 195 ++++++++++
>>>    12 files changed, 1070 insertions(+), 97 deletions(-)
>>>

