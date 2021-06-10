Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAAF3A28BF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 11:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhFJJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 05:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230083AbhFJJxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 05:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623318717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTD4X05DmvXZmZ+nk5ppfERwzEcj05YeBZi3dJeI59Y=;
        b=dwN0DjL7WDETRz5J28mxzglzhx/S/CgI1gn4PFDTvpCqgC6j8AlGP6aulF/YP4h4hzpVmK
        WLeJ6sRhLY31QEF9UgRfxvX51pRfpg9dOAdzGMcDYML48cpqfjKhmimTVg9u4T1GwY48XC
        AlPb9x50mRsETCDyGGus4eQT6E84xaQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-LUzszHCgO8yGMfu3sG9HFw-1; Thu, 10 Jun 2021 05:51:56 -0400
X-MC-Unique: LUzszHCgO8yGMfu3sG9HFw-1
Received: by mail-ed1-f71.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso13968360edu.18
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 02:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oTD4X05DmvXZmZ+nk5ppfERwzEcj05YeBZi3dJeI59Y=;
        b=uHzQka6ZC1nGTUWqI9AD2qaLFI7kmW+Zqee0ptgISp2R9i3Tr66OB++EKDNG+S7pGq
         DCHYweHmFlR1jeX+ysg/CIp2Jj/kVC/9YJWCrPE2t+nsPLAC+sfhksk5k4/6eHVf960z
         HGeQz9Z5Jm94aAOdFOSlHqn1eCSTyp49cBOZP8rSmEnouy4+NRqj65rfF69B1QBU7JoX
         tgyU8HgsV2g/E//0r/wLDyCAN8P89+IcQw849dT2OxlEQqnxkT2cfHtxnBSpGF3CGwwF
         +IKLZ3ClRGq//uxvRYBTKwcwPHxRHVdIqtp3T//87S18/7U5bAwqEx9yCg42auOd0R67
         CkTw==
X-Gm-Message-State: AOAM533GJSBgtHlvKc7M1qcr4Qc9d9A2Q2yEOZyYHS8Y9mS+aIJHIbYo
        yg8d4nEcuokv2FFHxKl/lFyrLWpu+NP30Qdw1gMdk5/DigCwpDtaTiJuU8MLJDkb/1S2eyuY8Zq
        JcaYA0hxI3RTl7Mj8
X-Received: by 2002:a17:906:546:: with SMTP id k6mr3667863eja.53.1623318714861;
        Thu, 10 Jun 2021 02:51:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAt+GEShJ3nyodJQl9prURDNMT3FZNtNtpzfzWl5Wsj4as49iUo+FaYaGvMJnyLT6U5H9b0g==
X-Received: by 2002:a17:906:546:: with SMTP id k6mr3667844eja.53.1623318714647;
        Thu, 10 Jun 2021 02:51:54 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id h19sm804248ejy.82.2021.06.10.02.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:51:54 -0700 (PDT)
Date:   Thu, 10 Jun 2021 11:51:51 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Jiang Wang ." <jiang.wang@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?utf-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
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
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
Message-ID: <20210610095151.2cpyny56kbotzppp@steredhat>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com>
 <CAP_N_Z_VDd+JUJ_Y-peOEc7FgwNGB8O3uZpVumQT_DbW62Jpjw@mail.gmail.com>
 <ac0c241c-1013-1304-036f-504d0edc5fd7@redhat.com>
 <20210610072358.3fuvsahxec2sht4y@steredhat>
 <47ce307b-f95e-25c7-ed58-9cd1cbff5b57@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47ce307b-f95e-25c7-ed58-9cd1cbff5b57@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 03:46:55PM +0800, Jason Wang wrote:
>
>在 2021/6/10 下午3:23, Stefano Garzarella 写道:
>>On Thu, Jun 10, 2021 at 12:02:35PM +0800, Jason Wang wrote:
>>>
>>>在 2021/6/10 上午11:43, Jiang Wang . 写道:
>>>>On Wed, Jun 9, 2021 at 6:51 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>
>>>>>在 2021/6/10 上午7:24, Jiang Wang 写道:
>>>>>>This patchset implements support of SOCK_DGRAM for virtio
>>>>>>transport.
>>>>>>
>>>>>>Datagram sockets are connectionless and unreliable. To avoid 
>>>>>>unfair contention
>>>>>>with stream and other sockets, add two more virtqueues and
>>>>>>a new feature bit to indicate if those two new queues exist or not.
>>>>>>
>>>>>>Dgram does not use the existing credit update mechanism for
>>>>>>stream sockets. When sending from the guest/driver, sending packets
>>>>>>synchronously, so the sender will get an error when the 
>>>>>>virtqueue is full.
>>>>>>When sending from the host/device, send packets asynchronously
>>>>>>because the descriptor memory belongs to the corresponding QEMU
>>>>>>process.
>>>>>
>>>>>What's the use case for the datagram vsock?
>>>>>
>>>>One use case is for non critical info logging from the guest
>>>>to the host, such as the performance data of some applications.
>>>
>>>
>>>Anything that prevents you from using the stream socket?
>>>
>>>
>>>>
>>>>It can also be used to replace UDP communications between
>>>>the guest and the host.
>>>
>>>
>>>Any advantage for VSOCK in this case? Is it for performance (I 
>>>guess not since I don't exepct vsock will be faster).
>>
>>I think the general advantage to using vsock are for the guest 
>>agents that potentially don't need any configuration.
>
>
>Right, I wonder if we really need datagram consider the host to guest 
>communication is reliable.
>
>(Note that I don't object it since vsock has already supported that, 
>just wonder its use cases)

Yep, it was the same concern I had :-)
Also because we're now adding SEQPACKET, which provides reliable 
datagram support.

But IIUC the use case is the logging where you don't need a reliable 
communication and you want to avoid to keep more open connections with 
different guests.

So the server in the host can be pretty simple and doesn't have to 
handle connections. It just waits for datagrams on a port.

>
>
>>
>>>
>>>An obvious drawback is that it breaks the migration. Using UDP you 
>>>can have a very rich features support from the kernel where vsock 
>>>can't.
>>>
>>
>>Thanks for bringing this up!
>>What features does UDP support and datagram on vsock could not support?
>
>
>E.g the sendpage() and busy polling. And using UDP means qdiscs and 
>eBPF can work.

Thanks, I see!

>
>
>>
>>>
>>>>
>>>>>>The virtio spec patch is here:
>>>>>>https://www.spinics.net/lists/linux-virtualization/msg50027.html
>>>>>
>>>>>Have a quick glance, I suggest to split mergeable rx buffer into an
>>>>>separate patch.
>>>>Sure.
>>>>
>>>>>But I think it's time to revisit the idea of unifying the 
>>>>>virtio-net and
>>>>>virtio-vsock. Otherwise we're duplicating features and bugs.
>>>>For mergeable rxbuf related code, I think a set of common helper
>>>>functions can be used by both virtio-net and virtio-vsock. For other
>>>>parts, that may not be very beneficial. I will think about more.
>>>>
>>>>If there is a previous email discussion about this topic, could 
>>>>you send me
>>>>some links? I did a quick web search but did not find any related
>>>>info. Thanks.
>>>
>>>
>>>We had a lot:
>>>
>>>[1] https://patchwork.kernel.org/project/kvm/patch/5BDFF537.3050806@huawei.com/
>>>[2] https://lists.linuxfoundation.org/pipermail/virtualization/2018-November/039798.html
>>>[3] https://www.lkml.org/lkml/2020/1/16/2043
>>>
>>
>>When I tried it, the biggest problem that blocked me were all the 
>>features strictly related to TCP/IP stack and ethernet devices that 
>>vsock device doesn't know how to handle: TSO, GSO, checksums, MAC, 
>>napi, xdp, min ethernet frame size, MTU, etc.
>
>
>It depends on which level we want to share:
>
>1) sharing codes
>2) sharing devices
>3) make vsock a protocol that is understood by the network core
>
>We can start from 1), the low level tx/rx logic can be shared at both 
>virtio-net and vhost-net. For 2) we probably need some work on the 
>spec, probably with a new feature bit to demonstrate that it's a vsock 
>device not a ethernet device. Then if it is probed as a vsock device we 
>won't let packet to be delivered in the TCP/IP stack. For 3), it would 
>be even harder and I'm not sure it's worth to do that.
>
>
>>
>>So in my opinion to unify them is not so simple, because vsock is not 
>>really an ethernet device, but simply a socket.
>
>
>We can start from sharing codes.

Yep, I agree, and maybe the mergeable buffer is a good starting point to 
share code!

@Jiang, do you want to take a look of this possibility?

Thanks,
Stefano

