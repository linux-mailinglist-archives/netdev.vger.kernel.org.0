Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688233B6CEE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhF2DYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:24:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231717AbhF2DYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:24:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624936895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k9DMsfqCEOoB4SDyMe+7Xbm8oTpDgY9ht42DFeLEsl0=;
        b=LqZKQv/EMmOSLWNIFszWfLwR5wiR5EUtFL8cvgqKqAhyzm4dLfw8oxAf9Htf+UYi9Jd4lS
        dDDXDvwmJzTeoUyfKb5Xjy+eRotBzXfQxQ+GTQtJcFIiC/1q3pdAA2JyD/89zyf+pGEViy
        2S065Rent17k/DV86FVawSszU/Npkok=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-zjApuTIBOoab1e-QpP-vyQ-1; Mon, 28 Jun 2021 23:21:34 -0400
X-MC-Unique: zjApuTIBOoab1e-QpP-vyQ-1
Received: by mail-pf1-f199.google.com with SMTP id k196-20020a6284cd0000b0290301abd2c063so10552247pfd.14
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=k9DMsfqCEOoB4SDyMe+7Xbm8oTpDgY9ht42DFeLEsl0=;
        b=mqInxlsZP+xVdnV8TW7uisIW8cFxRxnNdiFpOEVLGpzst+qN3+1Shjb/Fdoun2DF9E
         zQxFKp2oUXGjKIEFznGfQC+Nea3PWH0Nlu3CMi+kwikGuGkTS7L+/atkA5oKw6FPZiSB
         IBGw7hVE8xF+DGrDJgN3aodwTaBjc4antNBm0slVZx5EBWxdZ6zOhdD28sgpsWf51qdJ
         7PRa91R4oAMPyP4BMQUK6MimMmhElQBeYS4W/7CWKybNPAOt01nrzMbVu+rubjRn2scw
         zPtov/kCq3sVvLYXS0+bm8jo71nfBSifjSoYuPVgh5lEarWkfo/UjsQzpqGXAyMoXZ3l
         baMw==
X-Gm-Message-State: AOAM530VRv2go+Cg1MF9bNDsCNHnhyxglpGGGPKO+xpPhIUrdT4AQG1x
        D9703fACUNPc0k9Iq3FLzTsaTxvpdiy2NFHoFFdvzz4y+t96oOvQPvBgGQ/qkQlodu6mniMZCpe
        KIo7OZ988tco6RTfM
X-Received: by 2002:a17:902:bc88:b029:121:146b:3bf9 with SMTP id bb8-20020a170902bc88b0290121146b3bf9mr25520338plb.15.1624936893031;
        Mon, 28 Jun 2021 20:21:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/PQ9t41kxIOhr6dYdeW0/hyx5IPhfpH6IghGvQkkLFPmJUHpp83e8iXHAl4ZF/6m54O0pIg==
X-Received: by 2002:a17:902:bc88:b029:121:146b:3bf9 with SMTP id bb8-20020a170902bc88b0290121146b3bf9mr25520325plb.15.1624936892758;
        Mon, 28 Jun 2021 20:21:32 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z22sm16479515pfa.157.2021.06.28.20.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 20:21:32 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
 <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2902f3b1-752b-e720-6662-24b2f580a716@redhat.com>
Date:   Tue, 29 Jun 2021 11:21:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/28 下午7:23, David Woodhouse 写道:
> On Mon, 2021-06-28 at 12:23 +0800, Jason Wang wrote:
>> 在 2021/6/25 下午4:37, David Woodhouse 写道:
>>> On Fri, 2021-06-25 at 15:33 +0800, Jason Wang wrote:
>>>> 在 2021/6/24 下午8:30, David Woodhouse 写道:
>>>>> From: David Woodhouse<dwmw@amazon.co.uk>
>>>>>
>>>>> When the underlying socket isn't configured with a virtio_net_hdr, the
>>>>> existing code in vhost_net_build_xdp() would attempt to validate
>>>>> uninitialised data, by copying zero bytes (sock_hlen) into the local
>>>>> copy of the header and then trying to validate that.
>>>>>
>>>>> Fixing it is somewhat non-trivial because the tun device might put a
>>>>> struct tun_pi*before*  the virtio_net_hdr, which makes it hard to find.
>>>>> So just stop messing with someone else's data in vhost_net_build_xdp(),
>>>>> and let tap and tun validate it for themselves, as they do in the
>>>>> non-XDP case anyway.
>>>> Thinking in another way. All XDP stuffs for vhost is prepared for TAP.
>>>> XDP is not expected to work for TUN.
>>>>
>>>> So we can simply let's vhost doesn't go with XDP path is the underlayer
>>>> socket is TUN.
>>> Actually, IFF_TUN mode per se isn't that complex. It's fixed purely on
>>> the tun side by that first patch I posted, which I later expanded a
>>> little to factor out tun_skb_set_protocol().
>>>
>>> The next two patches in my original set were fixing up the fact that
>>> XDP currently assumes that the *socket* will be doing the vhdr, not
>>> vhost. Those two weren't tun-specific at all.
>>>
>>> It's supporting the PI header (which tun puts *before* the virtio
>>> header as I just said) which introduces a tiny bit more complexity.
>>
>> This reminds me we need to fix tun_put_user_xdp(),
> Good point; thanks.
>
>> but as we've discussed, we need first figure out if PI is worth to
>> support for vhost-net.
> FWIW I certainly don't care about PI support. The only time anyone
> would want PI support is if they need to support protocols *other* than
> IPv6 and Legacy IP, over tun mode.
>
> I'm fixing this stuff because when I tried to use vhost-tun + tun for
> *sensible* use cases, I ended up having to flounder around trying to
> find a combination of settings that actually worked. And that offended
> me :)
>
> So I wrote a test case to iterate over various possible combinations of
> settings, and then kept typing until that all worked.
>
> The only thing I do feel quite strongly about is that stuff should
> either *work*, or *explicitly* fail if it's unsupported.


I fully agree, but I suspect this may only work when we invent something 
new, otherwise I'm not sure if it's too late to fix where it may break 
the existing application.


>
> At this point, although I have no actual use for it myself, I'd
> probably just about come down on the side of supporting PI. On the
> basis that:
>
>   • I've basically made it work already.
>
>   • It allows those code paths like tun_skb_set_protocol() to be
>     consolidated as both calling code paths need the same thing.
>
>   • Even in the kernel, and even when modules are as incestuously
>     intertwined as vhost-net and tun already are, I'm a strong
>     believer in *not* making assumptions about someone else's data,
>     so letting *tun* handle its own headers without making those
>     assumptions seems like the right thing to do.
>
>
>
> If we want to support PI, I need to go fix tun_put_user_xdp() as you
> noted (and work out how to add that to the test case). And resolve the
> fact that configuration might change after tun_get_socket() is called —
> and indeed that there might not *be* a configuration at all when
> tun_get_socket() is called.


Yes, but I tend to leave the code as is PI part consider no one is 
interested in that. (vhost_net + PI).


>
>
> If we *don't* want to support PI, well, the *interesting* part of the
> above needs fixing anyway. Because I strongly believe we should
> *prevent* it if we don't support it, and we *still* have the case you
> point out of the tun vhdr_size being changed at runtime.


As discussed in another thread, it looks me to it's sufficient to have 
some statics counters/API in vhost_net. Or simply use msg_control to 
reuse tx_errors of TUN/TAP or macvtap.


>
> I'll take a look at whether can pass the socklen back from tun to
> vhost-net on *every* packet. Is there a MSG_XXX flag we can abuse and
> somewhere in the msghdr that could return the header length used for
> *this* packet?


msg_control is probably the best place to do this.


>   Or could we make vhost_net_rx_peek_head_len() call
> explicitly into the tun device instead of making stuff up in
> peek_head_len()?


They're working at skb/xdp level which is unaware of PI stuffs.

But again, I think it should be much more cheaper to just add error 
reporting in this case. And it should be sufficient.


>
>
> To be clear: from the point of view of my *application* I don't care
> about any of this; my only motivation here is to clean up the kernel
> behaviour and make life easier for potential future users.


Yes, thanks a lot for having a look at this.

Though I'm not quite sure vhost_net is designed to work on those setups 
but let's ask for Michael (author of vhost/net) for his idea:

Michael, do you think it's worth to support

1) vhost_net + TUN
2) vhost_net + PI

?


> I have found
> a setup that works in today's kernels (even though I have to disable
> XDP, and have to use a virtio header that I don't want), and will stick
> with that for now, if I actually commit it to my master branch at all:
> https://gitlab.com/openconnect/openconnect/-/commit/0da4fe43b886403e6


Yes, but unfortunately it needs some tricks for avoid hitting bugs in 
the kernel.


>
> I might yet abandon it because I haven't *yet* seen it go any faster
> than the code which just does read()/write() on the tun device from
> userspace. And without XDP or zerocopy it's not clear that it could
> ever give me any benefit that I couldn't achieve purely in userspace by
> having a separate thread to do tun device I/O. But we'll see...


Ok.

Thanks.

