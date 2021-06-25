Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030F63B3B00
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 04:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhFYC5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 22:57:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233041AbhFYC5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 22:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624589724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9yj4eSc9jJBjhPQapLz6/aNyXNCzXnAi8nNQMXFQ28=;
        b=ImY1d+vEzsNXrfe0Z5ACdwlR2/yuk7gvURayTcydBGaQKM5dY80J3L7EdIBBOfwrn1cUZi
        ncDvXUiTGz8BVZBOPxhuNF1fvNJC2/1nFr8vf6cT/ZOLa6eIVpMoXzZzIXRss1ybyGtfNv
        guVLnCCPW5mpktr+N+YzD8XPjuBYY18=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-zo4TXMkxNOunkew3u5DnuQ-1; Thu, 24 Jun 2021 22:55:23 -0400
X-MC-Unique: zo4TXMkxNOunkew3u5DnuQ-1
Received: by mail-pl1-f197.google.com with SMTP id x15-20020a170902e04fb02900f5295925dbso2991488plx.9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 19:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=c9yj4eSc9jJBjhPQapLz6/aNyXNCzXnAi8nNQMXFQ28=;
        b=t/ymFEuPEeFXEoB8zlISd3wr/zmRiCotKneOpBTLODkNVtAq3FaO5oSA8aAdGni3pI
         mJEShB/HYcgoQ3qSDZyNdnhqxqovSr7Qvdg8xcr2U3jh4SKDEVnDJOaE5sZsABVaWVy2
         OE01wcaAEx/vZg0jQElSC3emXE+D419JellzTr3GMwi3zY6mUoxxugEZT7pSJTeN0/UZ
         VVrB3aoE2q1XfnEaJRq/h6d6XpyU3bhaoSYluYfZSjBvtsEXs7Q4+G0UH2u/h5oaNW5f
         j1eWIgWLSmjyFLc61PdhmRxGZBZ0tMc7C8QIB6tISbGbJGCWygUOyPzClyiN2laB7KMZ
         ZJfw==
X-Gm-Message-State: AOAM532xviHjffnSw+FYv/Vt+H6yEpnXpSqRy+/VB4hwSPVP95zTr/Y/
        aR3rCMbiI6iH8as74yKXNUryDvGbqsGT+quAecEI1mShZRRikb6zzzn01/fE27UAsxgL5JJOSng
        40VMmCSnEGp8g4gW1
X-Received: by 2002:a17:90a:2ec7:: with SMTP id h7mr18566894pjs.126.1624589722261;
        Thu, 24 Jun 2021 19:55:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzg5oy3ywyCUD+Qc+xNpmVx5IFBrSex9MrV4wl+EkhG5QGDsMxsujbsuWWu9PA7DPx+52Y9IA==
X-Received: by 2002:a17:90a:2ec7:: with SMTP id h7mr18566873pjs.126.1624589721995;
        Thu, 24 Jun 2021 19:55:21 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q125sm4019636pfb.193.2021.06.24.19.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 19:55:21 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] vhost_net: Add self test with tun device
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <20210622161533.1214662-4-dwmw2@infradead.org>
 <85e55d53-4ef2-0b61-234e-4b5f30909efa@redhat.com>
 <d6ad85649fd56d3e12e59085836326a09885593b.camel@infradead.org>
 <4a5c6e49-ee50-3c0c-c8e6-04d85137cfb1@redhat.com>
 <3a5bf6b8a05a1bf6393abe4f3d2c7b0e8086c3df.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <20fd6dcc-d9dc-2979-c6ab-1cdf04de57b8@redhat.com>
Date:   Fri, 25 Jun 2021 10:55:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3a5bf6b8a05a1bf6393abe4f3d2c7b0e8086c3df.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/24 下午6:42, David Woodhouse 写道:
> On Thu, 2021-06-24 at 14:12 +0800, Jason Wang wrote:
>> 在 2021/6/24 上午12:12, David Woodhouse 写道:
>>> We *should* eventually expand this test case to attach an AF_PACKET
>>> device to the vhost-net, instead of using a tun device as the back end.
>>> (Although I don't really see *why* vhost is limited to AF_PACKET. Why
>>> *can't* I attach anything else, like an AF_UNIX socket, to vhost-net?)
>>
>> It's just because nobody wrote the code. And we're lacking the real use
>> case.
> Hm, what code?


The codes to support AF_UNIX.


>   For AF_PACKET I haven't actually spotted that there *is*
> any.


Vhost_net has this support for more than 10 years. It's hard to say 
there's no user for that.


>
> As I've been refactoring the interaction between vhost and tun/tap, and
> fixing it up for different vhdr lengths, PI, and (just now) frowning in
> horror at the concept that tun and vhost can have *different*
> endiannesses, I hadn't spotted that there was anything special on the
> packet socket.


Vnet header support.


>   For that case, sock_hlen is just zero and we
> send/receive plain packets... or so I thought? Did I miss something?


With vnet header, it can have GSO and csum offload.


>
> As far as I was aware, that ought to have worked with any datagram
> socket. I was pondering not just AF_UNIX but also UDP (since that's my
> main transport for VPN data, at least in the case where I care about
> performance).


My understanding is that vhost_net designed for accelerating virtio 
datapath which is mainly used for VM (L2 traffic). So all kinds of TAPs 
(tuntap,macvtap or packet socket) are the main users. If you check git 
history, vhost can only be enabled without KVM until sometime last year. 
So I confess it can serve as a more general use case, and we had already 
has some discussions. But it's hard to say it's worth to do that since 
it became a re-invention of io_uring?

Another interesting thing is that, the copy done by vhost 
(copy_from/to_user()) will be much more slower than io_uring (GUP) 
because userspace copy may suffer from the performance hit caused by SMAP.


>
> An interesting use case for a non-packet socket might be to establish a
> tunnel. A guest's virtio-net device is just connected to a UDP socket
> on the host, and that tunnels all their packets to/from a remote
> endpoint which is where that guest is logically connected to the
> network. It might be useful for live migration cases, perhaps?


So kernel has already had supported on tunnels like L2 over L4 which 
were all done at netdevice level (e.g vxlan). If you want to build a 
customized tunnel which is not supported by the kernel, you need to 
redirect the traffic back to the userspace. vhost-user is probably the 
best choice in that case.


>
> I don't have an overriding desire to *make* it work, mind you; I just
> wanted to make sure I understand *why* it doesn't, if indeed it
> doesn't. As far as I could tell, it *should* work if we just dropped
> the check?


I'm not sure. It requires careful thought.

For the case of L2/VM, we care more about the performance which can be 
done via vnet header.

For the case of L3(TUN) or above, we can do that via io_uring.

So it looks to me it's not worth to bother.


>
>> Vhost_net is bascially used for accepting packet from userspace to the
>> kernel networking stack.
>>
>> Using AF_UNIX makes it looks more like a case of inter process
>> communication (without vnet header it won't be used efficiently by VM).
>> In this case, using io_uring is much more suitable.
>>
>> Or thinking in another way, instead of depending on the vhost_net, we
>> can expose TUN/TAP socket to userspace then io_uring could be used for
>> the OpenConnect case as well?
> That would work, I suppose. Although as noted, I *can* use vhost_net
> with tun today from userspace as long as I disable XDP and PI, and use
> a virtio_net_hdr that I don't really want. (And pull a value for
> TASK_SIZE out of my posterior; qv.)
>
> So I *can* ship a version of OpenConnect that works on existing
> production kernels with those workarounds, and I'm fixing up the other
> permutations of vhost/tun stuff in the kernel just because I figured we
> *should*.
>
> If I'm going to *require* new kernel support for OpenConnect then I
> might as well go straight to the AF_TLS/DTLS + BPF + sockmap plan and
> have the data packets never go to userspace in the first place.


Note that BPF have some limitations:

1) requires capabilities like CAP_BPF
2) may need userspace fallback


>
>
>>>
>>>>> +	/*
>>>>> +	 * I just want to map the *whole* of userspace address space. But
>>>>> +	 * from userspace I don't know what that is. On x86_64 it would be:
>>>>> +	 *
>>>>> +	 * vmem->regions[0].guest_phys_addr = 4096;
>>>>> +	 * vmem->regions[0].memory_size = 0x7fffffffe000;
>>>>> +	 * vmem->regions[0].userspace_addr = 4096;
>>>>> +	 *
>>>>> +	 * For now, just ensure we put everything inside a single BSS region.
>>>>> +	 */
>>>>> +	vmem->regions[0].guest_phys_addr = (uint64_t)&rings;
>>>>> +	vmem->regions[0].userspace_addr = (uint64_t)&rings;
>>>>> +	vmem->regions[0].memory_size = sizeof(rings);
>>>> Instead of doing tricks like this, we can do it in another way:
>>>>
>>>> 1) enable device IOTLB
>>>> 2) wait for the IOTLB miss request (iova, len) and update identity
>>>> mapping accordingly
>>>>
>>>> This should work for all the archs (with some performance hit).
>>> Ick. For my actual application (OpenConnect) I'm either going to suck
>>> it up and put in the arch-specific limits like in the comment above, or
>>> I'll fix things to do the VHOST_F_IDENTITY_MAPPING thing we're talking
>>> about elsewhere.
>>
>> The feature could be useful for the case of vhost-vDPA as well.
>>
>>
>>>    (Probably the former, since if I'm requiring kernel
>>> changes then I have grander plans around extending AF_TLS to do DTLS,
>>> then hooking that directly up to the tun socket via BPF and a sockmap
>>> without the data frames ever going to userspace at all.)
>>
>> Ok, I guess we need to make sockmap works for tun socket.
> Hm, I need to work out the ideal data flow here. I don't know if
> sendmsg() / recvmsg() on the tun socket are even what I want, for full
> zero-copy.


Zerocopy could be done via vhost_net. But due the HOL issue we disabled 
it by default.


>
> In the case where the NIC supports encryption, we want true zero-copy
> from the moment the "encrypted" packet arrives over UDP on the public
> network, through the DTLS processing and seqno checking, to being
> processed as netif_receive_skb() on the tun device.
>
> Likewise skbs from tun_net_xmit() should have the appropriate DTLS and
> IP/UDP headers prepended to them and that *same* skb (or at least the
> same frags) should be handed to the NIC to encrypt and send.
>
> In the case where we have software crypto in the kernel, we can
> tolerate precisely *one* copy because the crypto doesn't have to be
> done in-place, so moving from the input to the output crypto buffers
> can be that one "copy", and we can use it to move data around (from the
> incoming skb to the outgoing skb) if we need to.


I'm not familiar withe encryption, but it looks like what you want is 
the TLS offload support in TUN/TAP.


>
> Ultimately I think we want udp_sendmsg() and tun_sendmsg() to support
> being *given* ownership of the buffers, rather than copying from them.
> Or just being given a skb and pushing/pulling their headers.


It looks more like you want to add sendpage() support for TUN? The first 
step as discussed would be the codes to expose TUN socket to userspace.


>
> I'm looking at skb_send_sock() and it *doesn't* seem to support "just
> steal the frags from the initial skb and give them to the new one", but
> there may be ways to make that work.


I don't know. Last time I check sockmap only support TCP socket. But I 
saw some work that is proposed by Wang Cong to make it work for UDP 
probably.

Thanks


>
>>> I think I can fix *all* those test cases by making tun_get_socket()
>>> take an extra 'int *' argument, and use that to return the *actual*
>>> value of sock_hlen. Here's the updated test case in the meantime:
>>
>> It would be better if you can post a new version of the whole series to
>> ease the reviewing.
> Yep. I was working on that... until I got even more distracted by
> looking at how we can do the true in-kernel zero-copy option ;)
>

