Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E342F3A25C5
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFJHtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:49:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229845AbhFJHtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 03:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623311233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loF5cb29gw2Qr4WX1KQpGHzr7ki9z/ToQpTxS3i6VWU=;
        b=M5ctXOVP1oSvIgYF1KSfIBTTIh0uBkrT+p/jqdsYlgXdrwh1ezgU2Awc2zzhsO0xh4tBWV
        6dJQZftu44rpYVA/gQqKEZ0jGzaAXpA0ovndTX8+jeuyJGgqJyXauJveV3TYsRecqckz3/
        TTgc0OPT7JX4v2htHtZ0t9Cb31ORo1s=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-C0E1bRhtP9yP7edGC6Uueg-1; Thu, 10 Jun 2021 03:47:11 -0400
X-MC-Unique: C0E1bRhtP9yP7edGC6Uueg-1
Received: by mail-pf1-f199.google.com with SMTP id e19-20020aa78c530000b02902e9ca53899dso781949pfd.22
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 00:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=loF5cb29gw2Qr4WX1KQpGHzr7ki9z/ToQpTxS3i6VWU=;
        b=YzEBBFVjtzf/FP9mzJoHegvHUZGdwgVB/om2zr4xZ1g/rajQfCbnJeI1A1xngagKrx
         Rkiw8ZPLqMRdXdwfDKHqoyLXsKxMBZVCAaSejpMWUQEeitV+1S63d08CqNCWJpgp3wnB
         fYN3Q2hKQqcn3CkhmAORrhJT6/yaK4tEkTRr7/2Y8P1A/mCDGInHIjww3ABjIAq6ddui
         NPTltTO2fyruIbmsiSsEKhGQxewS06qOyQ3i3qio+WXhe1YKUWl6hJM/to7SlJs+OcOr
         BrMqr4Gs+DWD3f8PzHIqqEPjor7Of/Cnj3NvmknsYXaYM6YejypSR/71P/VYE5ZEAzIy
         U4MQ==
X-Gm-Message-State: AOAM533TBoLrApsCMOOGQsF0uaXtjX57Z2zJXW72qG3S5xS8BA8bDV6H
        EnNLlyJwyLBjlxx8o5fnk9rMGbvW11APGal/2dkyoAOLOq9z96pvfPY6LuhZjnYmcEj0f+ueLDg
        xkNkElLed7IEWqnCS
X-Received: by 2002:a62:6805:0:b029:2e9:a7c9:2503 with SMTP id d5-20020a6268050000b02902e9a7c92503mr1763805pfc.26.1623311230728;
        Thu, 10 Jun 2021 00:47:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqrvDw/tkXuYDtQELqf02BdCoSYQh21xwSXFSnN/JVfuMs/MqAAlU+YEIkeQA3no0RJlH3gQ==
X-Received: by 2002:a62:6805:0:b029:2e9:a7c9:2503 with SMTP id d5-20020a6268050000b02902e9a7c92503mr1763775pfc.26.1623311230441;
        Thu, 10 Jun 2021 00:47:10 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n37sm1570183pfv.47.2021.06.10.00.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 00:47:09 -0700 (PDT)
Subject: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Jiang Wang ." <jiang.wang@bytedance.com>,
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
 <ac0c241c-1013-1304-036f-504d0edc5fd7@redhat.com>
 <20210610072358.3fuvsahxec2sht4y@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <47ce307b-f95e-25c7-ed58-9cd1cbff5b57@redhat.com>
Date:   Thu, 10 Jun 2021 15:46:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610072358.3fuvsahxec2sht4y@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/10 下午3:23, Stefano Garzarella 写道:
> On Thu, Jun 10, 2021 at 12:02:35PM +0800, Jason Wang wrote:
>>
>> 在 2021/6/10 上午11:43, Jiang Wang . 写道:
>>> On Wed, Jun 9, 2021 at 6:51 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>
>>>> 在 2021/6/10 上午7:24, Jiang Wang 写道:
>>>>> This patchset implements support of SOCK_DGRAM for virtio
>>>>> transport.
>>>>>
>>>>> Datagram sockets are connectionless and unreliable. To avoid 
>>>>> unfair contention
>>>>> with stream and other sockets, add two more virtqueues and
>>>>> a new feature bit to indicate if those two new queues exist or not.
>>>>>
>>>>> Dgram does not use the existing credit update mechanism for
>>>>> stream sockets. When sending from the guest/driver, sending packets
>>>>> synchronously, so the sender will get an error when the virtqueue 
>>>>> is full.
>>>>> When sending from the host/device, send packets asynchronously
>>>>> because the descriptor memory belongs to the corresponding QEMU
>>>>> process.
>>>>
>>>> What's the use case for the datagram vsock?
>>>>
>>> One use case is for non critical info logging from the guest
>>> to the host, such as the performance data of some applications.
>>
>>
>> Anything that prevents you from using the stream socket?
>>
>>
>>>
>>> It can also be used to replace UDP communications between
>>> the guest and the host.
>>
>>
>> Any advantage for VSOCK in this case? Is it for performance (I guess 
>> not since I don't exepct vsock will be faster).
>
> I think the general advantage to using vsock are for the guest agents 
> that potentially don't need any configuration.


Right, I wonder if we really need datagram consider the host to guest 
communication is reliable.

(Note that I don't object it since vsock has already supported that, 
just wonder its use cases)


>
>>
>> An obvious drawback is that it breaks the migration. Using UDP you 
>> can have a very rich features support from the kernel where vsock can't.
>>
>
> Thanks for bringing this up!
> What features does UDP support and datagram on vsock could not support?


E.g the sendpage() and busy polling. And using UDP means qdiscs and eBPF 
can work.


>
>>
>>>
>>>>> The virtio spec patch is here:
>>>>> https://www.spinics.net/lists/linux-virtualization/msg50027.html
>>>>
>>>> Have a quick glance, I suggest to split mergeable rx buffer into an
>>>> separate patch.
>>> Sure.
>>>
>>>> But I think it's time to revisit the idea of unifying the 
>>>> virtio-net and
>>>> virtio-vsock. Otherwise we're duplicating features and bugs.
>>> For mergeable rxbuf related code, I think a set of common helper
>>> functions can be used by both virtio-net and virtio-vsock. For other
>>> parts, that may not be very beneficial. I will think about more.
>>>
>>> If there is a previous email discussion about this topic, could you 
>>> send me
>>> some links? I did a quick web search but did not find any related
>>> info. Thanks.
>>
>>
>> We had a lot:
>>
>> [1] 
>> https://patchwork.kernel.org/project/kvm/patch/5BDFF537.3050806@huawei.com/
>> [2] 
>> https://lists.linuxfoundation.org/pipermail/virtualization/2018-November/039798.html
>> [3] https://www.lkml.org/lkml/2020/1/16/2043
>>
>
> When I tried it, the biggest problem that blocked me were all the 
> features strictly related to TCP/IP stack and ethernet devices that 
> vsock device doesn't know how to handle: TSO, GSO, checksums, MAC, 
> napi, xdp, min ethernet frame size, MTU, etc.


It depends on which level we want to share:

1) sharing codes
2) sharing devices
3) make vsock a protocol that is understood by the network core

We can start from 1), the low level tx/rx logic can be shared at both 
virtio-net and vhost-net. For 2) we probably need some work on the spec, 
probably with a new feature bit to demonstrate that it's a vsock device 
not a ethernet device. Then if it is probed as a vsock device we won't 
let packet to be delivered in the TCP/IP stack. For 3), it would be even 
harder and I'm not sure it's worth to do that.


>
> So in my opinion to unify them is not so simple, because vsock is not 
> really an ethernet device, but simply a socket.


We can start from sharing codes.


>
> But I fully agree that we shouldn't duplicate functionality and code, 
> so maybe we could find those common parts and create helpers to be 
> used by both.


Yes.

Thanks


>
> Thanks,
> Stefano
>

