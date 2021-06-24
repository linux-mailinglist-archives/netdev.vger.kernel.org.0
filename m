Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C96D3B273F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhFXGQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhFXGQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624515229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FLS11hRbN6jtTVRdLFJy3st1ahgHrTdLG5t3IR+EcEw=;
        b=OqaElnQfZDLdYngXmb+hm8qsM4t7u52sLYxfLCSZJfTacxirkkp/NqKoqy4SJhmlMTaTdm
        2cHBgttggROYVMQ+7mc96ho/Ti9WQKgbGS+YGn8q1vyvq72lkmWZu2Gh+RRUaIAUJDGRvn
        1dQmBwbYs1PBHQ/ycuzRDA4+MYp1IKM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-tpgjRPMeOBaTh2XCWw-X8Q-1; Thu, 24 Jun 2021 02:13:47 -0400
X-MC-Unique: tpgjRPMeOBaTh2XCWw-X8Q-1
Received: by mail-pl1-f197.google.com with SMTP id k6-20020a1709027606b0290104f319bb01so1788116pll.13
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FLS11hRbN6jtTVRdLFJy3st1ahgHrTdLG5t3IR+EcEw=;
        b=lEpgwnBj0vItRRQG28YAZm3FGOrgiLkp8/6+I5li5GgVHZLC1eVuaxwxe0suviU0zS
         swm1ACV/drlR7dWe1VEDLJ19YnUuHrUd5j6DZ5t4UzE2vZpNWv6oiCLU1Y8V3JYVRSSH
         CtHx8HfJkIU35+6t8Lt0SzesNbylfOKn4Quk0H8Dj4Mi8dHicZ5TAjIYcBn7Sw4TRmWX
         GShWkJmJepyF9AWGl3Z6mrst9cSRqRX13vkyJJu/N5sTZXTx9UOQft76GM5XX05y7Qq4
         M9tnF3YJHkHpLHXE+n/45PHq3l67hq9HKg8148fa9gkYpVAOuJx7g5bQ/X5D/iZvtRpA
         m0ow==
X-Gm-Message-State: AOAM533OoGKXMoaeYY9RXkyS2OQ9kLB7HYGsqdOli9IpA2TWzlR9+YP+
        447KlKMuK2pN+npgMMrwuz5VWCYi4aGSwNYKnRc5tI8nLlq+hovv58BMaN6O//BjvCSSP85LcL0
        J9FATtv4MBiveLL79
X-Received: by 2002:a17:90a:ff08:: with SMTP id ce8mr3562785pjb.167.1624515226326;
        Wed, 23 Jun 2021 23:13:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsnh3epeYYHij64wpNThRl30zLmy9KFvFW3Ho9YO1jJrQXIs7FBWFYX+AYezY+siFXnt1iUQ==
X-Received: by 2002:a17:90a:ff08:: with SMTP id ce8mr3562761pjb.167.1624515226100;
        Wed, 23 Jun 2021 23:13:46 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b18sm7170475pjq.2.2021.06.23.23.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 23:13:43 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] vhost_net: Add self test with tun device
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <20210622161533.1214662-4-dwmw2@infradead.org>
 <85e55d53-4ef2-0b61-234e-4b5f30909efa@redhat.com>
 <d6ad85649fd56d3e12e59085836326a09885593b.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4a5c6e49-ee50-3c0c-c8e6-04d85137cfb1@redhat.com>
Date:   Thu, 24 Jun 2021 14:12:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d6ad85649fd56d3e12e59085836326a09885593b.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/24 上午12:12, David Woodhouse 写道:
> On Wed, 2021-06-23 at 12:02 +0800, Jason Wang wrote:
>> 在 2021/6/23 上午12:15, David Woodhouse 写道:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> This creates a tun device and brings it up, then finds out the link-local
>>> address the kernel automatically assigns to it.
>>>
>>> It sends a ping to that address, from a fake LL address of its own, and
>>> then waits for a response.
>>>
>>> If the virtio_net_hdr stuff is all working correctly, it gets a response
>>> and manages to understand it.
>>
>> I wonder whether it worth to bother the dependency like ipv6 or kernel
>> networking stack.
>>
>> How about simply use packet socket that is bound to tun to receive and
>> send packets?
>>
> I pondered that but figured that using the kernel's network stack
> wasn't too much of an additional dependency. We *could* use an
> AF_PACKET socket on the tun device and then drive both ends, but given
> that the kernel *automatically* assigns a link-local address when we
> bring the device up anyway, it seemed simple enough just to use ICMP.
> I also happened to have the ICMP generation/checking code lying around
> anyway in the same emacs instance, so it was reduced to a previously
> solved problem.


Ok.


>
> We *should* eventually expand this test case to attach an AF_PACKET
> device to the vhost-net, instead of using a tun device as the back end.
> (Although I don't really see *why* vhost is limited to AF_PACKET. Why
> *can't* I attach anything else, like an AF_UNIX socket, to vhost-net?)


It's just because nobody wrote the code. And we're lacking the real use 
case.

Vhost_net is bascially used for accepting packet from userspace to the 
kernel networking stack.

Using AF_UNIX makes it looks more like a case of inter process 
communication (without vnet header it won't be used efficiently by VM). 
In this case, using io_uring is much more suitable.

Or thinking in another way, instead of depending on the vhost_net, we 
can expose TUN/TAP socket to userspace then io_uring could be used for 
the OpenConnect case as well?


>
>
>>> +	/*
>>> +	 * I just want to map the *whole* of userspace address space. But
>>> +	 * from userspace I don't know what that is. On x86_64 it would be:
>>> +	 *
>>> +	 * vmem->regions[0].guest_phys_addr = 4096;
>>> +	 * vmem->regions[0].memory_size = 0x7fffffffe000;
>>> +	 * vmem->regions[0].userspace_addr = 4096;
>>> +	 *
>>> +	 * For now, just ensure we put everything inside a single BSS region.
>>> +	 */
>>> +	vmem->regions[0].guest_phys_addr = (uint64_t)&rings;
>>> +	vmem->regions[0].userspace_addr = (uint64_t)&rings;
>>> +	vmem->regions[0].memory_size = sizeof(rings);
>>
>> Instead of doing tricks like this, we can do it in another way:
>>
>> 1) enable device IOTLB
>> 2) wait for the IOTLB miss request (iova, len) and update identity
>> mapping accordingly
>>
>> This should work for all the archs (with some performance hit).
> Ick. For my actual application (OpenConnect) I'm either going to suck
> it up and put in the arch-specific limits like in the comment above, or
> I'll fix things to do the VHOST_F_IDENTITY_MAPPING thing we're talking
> about elsewhere.


The feature could be useful for the case of vhost-vDPA as well.


>   (Probably the former, since if I'm requiring kernel
> changes then I have grander plans around extending AF_TLS to do DTLS,
> then hooking that directly up to the tun socket via BPF and a sockmap
> without the data frames ever going to userspace at all.)


Ok, I guess we need to make sockmap works for tun socket.


>
> For this test case, a hard-coded single address range in BSS is fine.
>
> I've now added !IFF_NO_PI support to the test case, but as noted it
> fails just like the other ones I'd already marked with #if 0, which is
> because vhost-net pulls some value for 'sock_hlen' out of its posterior
> based on some assumption around the vhost features. And then expects
> sock_recvmsg() to return precisely that number of bytes more than the
> value it peeks in the skb at the head of the sock's queue.
>
> I think I can fix *all* those test cases by making tun_get_socket()
> take an extra 'int *' argument, and use that to return the *actual*
> value of sock_hlen. Here's the updated test case in the meantime:


It would be better if you can post a new version of the whole series to 
ease the reviewing.

Thanks


