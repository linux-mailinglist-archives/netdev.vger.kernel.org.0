Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC493A21FA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 03:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhFJBxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 21:53:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJBxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 21:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623289872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vz0jGs3iC3Z2zxb/bDk+em2UI3NrnLgN9D+cOWfKhFk=;
        b=Yrzytv6PKW21b4rht+4QPtuF61AOvPhNi4KhJR5Mr3HdZzNN+5a65++AVo6PPiJuSVtZgp
        fLV2Yz9hn8Q4Kxr+ZKwlAX4gt7fSlqGObUUwKqUg4w6JXFH7FXzTUfZbdzXpQt/M8mb5cK
        LAYdEB6LlfOOaffJ+TO6CdqRSp8Yp5c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-vmG_L3ZEPPuf772LZnZjSQ-1; Wed, 09 Jun 2021 21:51:10 -0400
X-MC-Unique: vmG_L3ZEPPuf772LZnZjSQ-1
Received: by mail-pl1-f197.google.com with SMTP id d1-20020a1709027281b0290112c70b86f1so171512pll.12
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 18:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Vz0jGs3iC3Z2zxb/bDk+em2UI3NrnLgN9D+cOWfKhFk=;
        b=rIV99mCShIpncC3GC11DVWvqtbVHnectjoB4zf80Cg1DaQvYHO7UgWM7koRzzY+w55
         UEVqIFzpi0/rRX+bX9M7pfEgFVfRL7rM7ZNYvpao0pgR1Yut+aVh55pGEYzrWnDkvFM1
         pPeVweEbcTlawM1txmyD/REuRSK7QWtd4Y226A1dpl22LR0/DxBSr2NwR1MomDcWfS9B
         H1uvYaKy8jREJIqQ+P3TU9vVwoEkjhGGHCIFfHg6wY3E/qm+83Gy0tG2e45kUjngKQ8z
         cKAAx6LFk6f6N/rq5qzxFn+3YM73IqLSVe2ANP0kKK92Nn/LkAhzL6XiR6VdoQTD8WMa
         1Jpg==
X-Gm-Message-State: AOAM532Qz1x/AMybB42IkXiozEAWO3QexHEIQIvLUqZZGQqUa5HkCGzf
        DhZv4JXttujtbhUojJPVs0YMJM/M2PLYLdY5TPA2DQIRAhv/cvU8/CIeO6X+FJkDwxIBPGLOFlm
        IFFoIhAeY+0Ytrqx4
X-Received: by 2002:a63:1f57:: with SMTP id q23mr2540923pgm.398.1623289869841;
        Wed, 09 Jun 2021 18:51:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTPUVSAZdPB8Qre6f3DbTbUGZcOx/a9zlBz8i8IQXThi6iMQgKG/iGcFooiYctC9c43+Gg/Q==
X-Received: by 2002:a63:1f57:: with SMTP id q23mr2540893pgm.398.1623289869521;
        Wed, 09 Jun 2021 18:51:09 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3sm846806pgb.77.2021.06.09.18.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 18:51:09 -0700 (PDT)
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
To:     Jiang Wang <jiang.wang@bytedance.com>, sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com>
Date:   Thu, 10 Jun 2021 09:50:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210609232501.171257-1-jiang.wang@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 上午7:24, Jiang Wang 写道:
> This patchset implements support of SOCK_DGRAM for virtio
> transport.
>
> Datagram sockets are connectionless and unreliable. To avoid unfair contention
> with stream and other sockets, add two more virtqueues and
> a new feature bit to indicate if those two new queues exist or not.
>
> Dgram does not use the existing credit update mechanism for
> stream sockets. When sending from the guest/driver, sending packets
> synchronously, so the sender will get an error when the virtqueue is full.
> When sending from the host/device, send packets asynchronously
> because the descriptor memory belongs to the corresponding QEMU
> process.


What's the use case for the datagram vsock?


>
> The virtio spec patch is here:
> https://www.spinics.net/lists/linux-virtualization/msg50027.html


Have a quick glance, I suggest to split mergeable rx buffer into an 
separate patch.

But I think it's time to revisit the idea of unifying the virtio-net and 
virtio-vsock. Otherwise we're duplicating features and bugs.

Thanks


>
> For those who prefer git repo, here is the link for the linux kernel：
> https://github.com/Jiang1155/linux/tree/vsock-dgram-v1
>
> qemu patch link:
> https://github.com/Jiang1155/qemu/tree/vsock-dgram-v1
>
>
> To do:
> 1. use skb when receiving packets
> 2. support multiple transport
> 3. support mergeable rx buffer
>
>
> Jiang Wang (6):
>    virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>    virtio/vsock: add support for virtio datagram
>    vhost/vsock: add support for vhost dgram.
>    vsock_test: add tests for vsock dgram
>    vhost/vsock: add kconfig for vhost dgram support
>    virtio/vsock: add sysfs for rx buf len for dgram
>
>   drivers/vhost/Kconfig                              |   8 +
>   drivers/vhost/vsock.c                              | 207 ++++++++--
>   include/linux/virtio_vsock.h                       |   9 +
>   include/net/af_vsock.h                             |   1 +
>   .../trace/events/vsock_virtio_transport_common.h   |   5 +-
>   include/uapi/linux/virtio_vsock.h                  |   4 +
>   net/vmw_vsock/af_vsock.c                           |  12 +
>   net/vmw_vsock/virtio_transport.c                   | 433 ++++++++++++++++++---
>   net/vmw_vsock/virtio_transport_common.c            | 184 ++++++++-
>   tools/testing/vsock/util.c                         | 105 +++++
>   tools/testing/vsock/util.h                         |   4 +
>   tools/testing/vsock/vsock_test.c                   | 195 ++++++++++
>   12 files changed, 1070 insertions(+), 97 deletions(-)
>

