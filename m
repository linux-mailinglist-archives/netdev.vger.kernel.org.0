Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5713C3B5818
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 06:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhF1EZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 00:25:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhF1EY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 00:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624854152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zaNDQgLkPOFEQMegxTd5WQPgSMFhYbN5H2/rZYJiFQc=;
        b=IYXRybpTrGqBhMgvTomR7nZb9jU/Pu/vuGhsPtxzc3rur/OCt37vXz0EfJyBoSj1lTHAa0
        yD1ySBLn17OUvaPONmQgxd2fY+qDnpDLX/6Z//ZmCnoGPiq/IIt3IDC6FU+gdo4gkLwVxs
        vT3sQPC/VFI7nN6+bl3VjHEuOSpNorg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-jVKSPnZEMKu2BSzbL2IXfA-1; Mon, 28 Jun 2021 00:22:29 -0400
X-MC-Unique: jVKSPnZEMKu2BSzbL2IXfA-1
Received: by mail-pj1-f72.google.com with SMTP id g19-20020a17090adb13b029016f4a877b4fso13702486pjv.8
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 21:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zaNDQgLkPOFEQMegxTd5WQPgSMFhYbN5H2/rZYJiFQc=;
        b=Z08gCydwp7t6ilS1oIgvGHdFNFIletoTP1nD6p1iSN7igYtAwHKaxa7qU4+qcMObVh
         +rE3dfnz0BoBwihAHsSj6kXf6iFBKkFXei87hb5uYKBTUlcyS2HroSGQ4A672vAVv/yE
         SrrRR8htqWjW1DKsSDI6ZqeHb4j+VQrzi8ze6Ou34P6szAxi5veFza+eCir6mxYwGs7/
         YTGKSLI0gXYYLUa+0HK6ZTxEvUGvEeF8oKnSsK/cgATMtgoQFJcMIfPNxYRPtJkwD7Bl
         PhOQLb2JeHp4xqoVCiHr/8tap7NBDvV2sDG0UyXkh6/qDxA+MigYNGbmQuAE6+TeEyIT
         RD5w==
X-Gm-Message-State: AOAM532JKMxgkorvlWXRNa4luXtw4oUQ+3Q0cA6kNWHRI1IRGI8Jtt+6
        yKqPp1aiwa0RIoHmEe5v04fnZvFq8F/fkeexVv20qgABkSgl2acR2wP8TrMAH29Y12bmYwD1jiY
        3QkOL+H8yEj1fr6wU
X-Received: by 2002:a65:6210:: with SMTP id d16mr5448077pgv.50.1624854148843;
        Sun, 27 Jun 2021 21:22:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlRF2UY49h0arm4byMPGGOWqoGWy74IPN5tDSjKJ3XtpypcltGbrUB91ZOYAcbNITzbsvolA==
X-Received: by 2002:a65:6210:: with SMTP id d16mr5448045pgv.50.1624854148589;
        Sun, 27 Jun 2021 21:22:28 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q27sm12872703pfg.63.2021.06.27.21.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 21:22:28 -0700 (PDT)
Subject: Re: [PATCH v3 1/5] net: add header len parameter to tun_get_socket(),
 tap_get_socket()
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <8bc0d9b7-b3d8-ddbb-bcdc-e0169fac7111@redhat.com>
 <4b33ed9ac98c28e8980043d482cc3549acfba799.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8b274bbf-56d8-554e-3aac-077883245e7f@redhat.com>
Date:   Mon, 28 Jun 2021 12:22:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4b33ed9ac98c28e8980043d482cc3549acfba799.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/25 下午4:23, David Woodhouse 写道:
> On Fri, 2021-06-25 at 13:00 +0800, Jason Wang wrote:
>> 在 2021/6/24 下午8:30, David Woodhouse 写道:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> The vhost-net driver was making wild assumptions about the header length
>>> of the underlying tun/tap socket.
>>
>> It's by design to depend on the userspace to co-ordinate the vnet header
>> setting with the underlying sockets.
>>
>>
>>>    Then it was discarding packets if
>>> the number of bytes it got from sock_recvmsg() didn't precisely match
>>> its guess.
>>
>> Anything that is broken by this? The failure is a hint for the userspace
>> that something is wrong during the coordination.
> I am not a fan of this approach. I firmly believe that for a given
> configuration, the kernel should either *work* or it should gracefully
> refuse to set it up that way. And the requirements should be clearly
> documented.


That works only if all the logic were implemented in the same module but 
not the case in the e.g networking stack that a packet need to iterate 
several modules.

E.g in this case, the vnet header size of the TAP could be changed at 
anytime via TUNSETVNETHDRSZ, and tuntap is unaware of the existence of 
vhost_net. This makes it impossible to do refuse in the case of setup 
(SET_BACKEND).


>
> Having been on the receiving end of this "hint" of which you speak, I
> found it distinctly suboptimal as a user interface. I was left
> scrabbling around trying to find a set of options which *would* work,
> and it was only through debugging the kernel that I managed to work out
> that I:
>
>    • MUST set IFF_NO_PI
>    • MUST use TUNSETSNDBUF to reduce the sndbuf from INT_MAX
>    • MUST use a virtio_net_hdr that I don't want
>
> If my application failed to do any of those things, I got a silent
> failure to transport any packets.


Yes, this is because the bug when using vhost_net + PI/TUN. And I guess 
the reason is that nobody tries to use that combination in the past.

I'm not even sure if it's a valid setup since vhost-net is a virtio-net 
kernel server which is not expected to handle L3 packets or PI header 
(which is Linux specific and out of the scope virtio spec).


>   The only thing I could do *without*
> debugging the kernel was tcpdump on the 'tun0' interface and see if the
> TX packets I put into the ring were even making it to the interface,
> and what they looked like if they did. (Losing the first 14 bytes and
> having the *next* 14 bytes scribbled on by an Ethernet header was a fun
> one.)


The tricky part is that, the networking stack thinks the packet is 
successfully received but it was actually dropped by vhost-net.

And there's no obvious userspace API to report such dropping as 
statistics counters or trace-points. Maybe we can tweak the vhost for a 
better logging in this case.


>
>
>
>
>
>>> Fix it to get the correct information along with the socket itself.
>>
>> I'm not sure what is fixed by this. It looks to me it tires to let
>> packet go even if the userspace set the wrong attributes to tap or
>> vhost. This is even sub-optimal than failing explicitly fail the RX.
> I'm OK with explicit failure. But once I'd let it *get* the information
> from the underlying socket in order to decide whether it should fail or
> not, it turned out to be easy enough just to make those configs work
> anyway.


The problem is that this change may make some wrong configuration 
"works" silently at the level of vhost or TAP. When using this for VM, 
it would make the debugging even harder.


>
> The main case where that "easy enough" is stretched a little (IMO) was
> when there's a tun_pi header. I have one more of your emails to reply
> to after this, and I'll address that there.
>
>
>>> As a side-effect, this means that tun_get_socket() won't work if the
>>> tun file isn't actually connected to a device, since there's no 'tun'
>>> yet in that case to get the information from.
>>
>> This may break the existing application. Vhost-net is tied to the socket
>> instead of the device that the socket is loosely coupled.
> Hm. Perhaps the PI and vnet hdr should be considered an option of the
> *socket* (which is tied to the tfile), not purely an option of the
> underlying device?


Though this is how it is done in macvtap. It's probably too late to 
change tuntap.


>
> Or maybe it's sufficient just to get the flags from *either* tfile->tun
> or tfile->detached, so that it works when the queue is detached. I'll
> take a look.
>
> I suppose we could even have a fallback that makes stuff up like we do
> today. If the user attempts to attach a tun file descriptor to vhost
> without ever calling TUNSETIFF on it first, *then* we make the same
> assumptions we do today?


Then I would rather keep the using the assumption:

1) the value get from get_socket() might not be correct
2) the complexity or risk for bring a very little improvement of the 
debug-ability (which is still suspicious).


>
>>> --- a/drivers/vhost/net.c
>>> +++ b/drivers/vhost/net.c
>>> @@ -1143,7 +1143,8 @@ static void handle_rx(struct vhost_net *net)
>>>    
>>>    	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
>>>    		vq->log : NULL;
>>> -	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
>>> +	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF) &&
>>> +		(vhost_hlen || sock_hlen >= sizeof(num_buffers));
>>
>> So this change the behavior. When mergeable buffer is enabled, userspace
>> expects the vhost to merge buffers. If the feature is disabled silently,
>> it violates virtio spec.
>>
>> If anything wrong in the setup, userspace just breaks itself.
>>
>> E.g if sock_hlen is less that struct virtio_net_hdr_mrg_buf. The packet
>> header might be overwrote by the vnet header.
> This wasn't intended to change the behaviour of any code path that is
> already working today. If *either* vhost or the underlying device have
> provided a vnet header, we still merge.
>
> If *neither* provide a vnet hdr, there's nowhere to put num_buffers and
> we can't merge.
>
> That code path doesn't work at all today, but does after my patches.


It looks to me it's a bug that userspace can keep working in this case. 
After mrg rx buffer is negotiated, userspace should always assumes the 
vhost-net to provide num_buffers.

> But you're right, we should explicitly refuse to negotiate
> VIRITO_NET_F_MSG_RXBUF in that case.


This would be very hard:

1) VHOST_SET_FEATURES and VHOST_NET_SET_BACKEND are two different ioctls
2) vhost_net is not tightly coupled with tuntap, vnet header size could 
be changed by userspace at any time


>
>>>    
>>>    	do {
>>>    		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
>>> @@ -1213,9 +1214,10 @@ static void handle_rx(struct vhost_net *net)
>>>    			}
>>>    		} else {
>>>    			/* Header came from socket; we'll need to patch
>>> -			 * ->num_buffers over if VIRTIO_NET_F_MRG_RXBUF
>>> +			 * ->num_buffers over the last two bytes if
>>> +			 * VIRTIO_NET_F_MRG_RXBUF is enabled.
>>>    			 */
>>> -			iov_iter_advance(&fixup, sizeof(hdr));
>>> +			iov_iter_advance(&fixup, sock_hlen - 2);
>>
>> I'm not sure what did the above code want to fix. It doesn't change
>> anything if vnet header is set correctly in TUN. It only prevents the
>> the packet header from being rewrote.
>>
> It fixes the case where the virtio_net_hdr isn't at the start of the
> tun header, because the tun actually puts the tun_pi struct *first*,
> and *then* the virtio_net_hdr.


Right.


> The num_buffers field needs to go at the *end* of sock_hlen. Not at a
> fixed offset from the *start* of it.
>
> At least, that's true unless we want to just declare that we *only*
> support TUN with the IFF_NO_PI flag. (qv).


Yes, that's a good question. This is probably a hint that "vhost-net is 
never designed to work of PI", and even if it's not true, I'm not sure 
if it's too late to fix.

Thanks

