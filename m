Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB36995E6
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjBPNez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjBPNer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E3B2A6F7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676554438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OetQt5uGyLhSCIV8UdYOQXsoqtjF7/4ZQkjZbBPYyoU=;
        b=ZLFNi1DyY47qRWxO5YYrX4o6VkfB062BvMjhPZ8d4CLXoUhv1/hnx1SWa0RBIOBMrrVA0O
        OJNjKbVXb/4PWYe0FVzGuGxQncLOij/haaCMqNAgUkGw3lWLcqkcKG5lCQ3OwOSFSaGh9L
        g8/MLnXcur4o6Sj/tgdq1arL3klLP4Q=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-Q1IH4KwIMZm2bw6Xq8NroQ-1; Thu, 16 Feb 2023 08:33:57 -0500
X-MC-Unique: Q1IH4KwIMZm2bw6Xq8NroQ-1
Received: by mail-qk1-f199.google.com with SMTP id g6-20020ae9e106000000b00720f9e6e3e2so1192585qkm.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:33:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OetQt5uGyLhSCIV8UdYOQXsoqtjF7/4ZQkjZbBPYyoU=;
        b=6xIcf4b1/vZxJCAEGvc4YnUuHOIAXzDj7PqOzteGybRh+AAyTMbu4RfvjsSD+A0H8N
         9Rj2Pw8ANYC49hgMiqNWJuvCMt7d1//CLqbM+9nQR4sv+h77CWPLHF4Zem8jsaBo/ylN
         V1UbhlaKyOu51fK+xdYJugaaxU90juX/gwz3Pw23FSN84h9k8kojFBDZELyMRCXRGuky
         2/fzzlchf02pHdYzwujRJyuPdN6VD61J1jotHBpoaCFeXGc8K1zQ0uiMnN96zRXzf0bR
         luqcpOWddkTHjQJMsmbuHgg0dzKEePgHLMjIWPWkb8UJYuID2Wk4Awkg3iYlPDlUj7eT
         wwBg==
X-Gm-Message-State: AO0yUKXgSFiYPNVyZHvGtmcs4Wz2toZBbAxo+fCWuQZTwehMGuyr0rAf
        KEijBAQxX94b7Wc5lAqO1e6a4OEDonPkqAVAfrxuyL5tU7r078733/2e2KtLi3ScVmdMZhcaL9C
        eiNmvYVn6d68kGQXm
X-Received: by 2002:a05:622a:1786:b0:3b8:6b3c:a37 with SMTP id s6-20020a05622a178600b003b86b3c0a37mr11028177qtk.6.1676554436527;
        Thu, 16 Feb 2023 05:33:56 -0800 (PST)
X-Google-Smtp-Source: AK7set8NnCVdNgCMq5QUVzOHPfa2MBD8BZRILDqkWgODavjhTOxrUrt141RJr3LqALny8+rcZt/3HA==
X-Received: by 2002:a05:622a:1786:b0:3b8:6b3c:a37 with SMTP id s6-20020a05622a178600b003b86b3c0a37mr11028140qtk.6.1676554436174;
        Thu, 16 Feb 2023 05:33:56 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id j1-20020ac85c41000000b003bd16200d6esm18886qtj.46.2023.02.16.05.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:33:55 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:33:50 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 00/12] vsock: MSG_ZEROCOPY flag support
Message-ID: <20230216133350.nmutrel7s5fjpkwm@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,
sorry for the delay, but I was offline.

On Mon, Feb 06, 2023 at 06:51:55AM +0000, Arseniy Krasnov wrote:
>Hello,
>
>                           DESCRIPTION
>
>this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
>current implementation for TCP as much as possible:
>
>1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>   flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>   flag will be ignored (e.g. without completion).
>
>2) Kernel uses completions from socket's error queue. Single completion
>   for single tx syscall (or it can merge several completions to single
>   one). I used already implemented logic for MSG_ZEROCOPY support:
>   'msg_zerocopy_realloc()' etc.

I will review for the vsock point of view. Hope some net maintainers can
comment about SO_ZEROCOPY.

Anyway I think is a good idea to keep it as close as possible to the TCP
implementation.

>
>Difference with copy way is not significant. During packet allocation,
>non-linear skb is created, then I call 'get_user_pages()' for each page
>from user's iov iterator (I think i don't need 'pin_user_pages()' as

Are these pages exposed to the host via virtqueues? If so, I think we
should pin them. What happens if the host accesses them but these pages
have been unmapped?

>there is no backing storage for these pages) and add each returned page
>to the skb as fragment. There are also some updates for vhost and guest
>parts of transport - in both cases i've added handling of non-linear skb
>for virtio part. vhost copies data from such skb to the guest's rx virtio
>buffers. In the guest, virtio transport fills virtio queue with pages
>from skb.
>
>I think doc in Documentation/networking/msg_zerocopy.rst could be also
>updated in next versions.

Yep, good idea.

>
>This version has several limits/problems:
>
>1) As this feature totally depends on transport, there is no way (or it
>   is difficult) to check whether transport is able to handle it or not
>   during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>   setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>   leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>   are not considered to be called from each other. So in current version
>   SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>   AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>   tx routine will fail with EOPNOTSUPP.

I'll take a look, but if we have no alternative, I think it's okay to
make tx fail.

>
>2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>   one completion. In each completion there is flag which shows how tx
>   was performed: zerocopy or copy. This leads that whole message must
>   be send in zerocopy or copy way - we can't send part of message with
>   copying and rest of message with zerocopy mode (or vice versa). Now,
>   we need to account vsock credit logic, e.g. we can't send whole data
>   once - only allowed number of bytes could sent at any moment. In case
>   of copying way there is no problem as in worst case we can send single
>   bytes, but zerocopy is more complex because smallest transmission
>   unit is single page. So if there is not enough space at peer's side
>   to send integer number of pages (at least one) - we will wait, thus
>   stalling tx side. To overcome this problem i've added simple rule -
>   zerocopy is possible only when there is enough space at another side
>   for whole message (to check, that current 'msghdr' was already used
>   in previous tx iterations i use 'iov_offset' field of it's iov iter).

I see the problem and I think your approach is the right one.

>
>3) loopback transport is not supported, because it requires to implement
>   non-linear skb handling in dequeue logic (as we "send" fragged skb
>   and "receive" it from the same queue). I'm going to implement it in
>   next versions.

loopback is useful for testing and debugging, so it would be great to
have the support, but if it's too complicated, we can do it later.

>
>4) Current implementation sets max length of packet to 64KB. IIUC this
>   is due to 'kmalloc()' allocated data buffers. I think, in case of

Yep, I think so.
When I started touching this code, the limit was already there.
As you said, I think it was introduced to have a limit on (host/device
side?) allocation, but buf_alloc might be enough, so maybe we could
also remove it for copy mode.
The only problem I see is compatibility with old devices/drivers, so
maybe we need a feature in the spec to say the limit is gone, or have a
field in the virtio config space where the device specifies its limit
(for the driver, the limit is implicitly that of the buffer allocated
and put in the virtqueue).

This reminded me that Laura had proposed something similar before,
maybe we should take it up again:
https://markmail.org/message/3el4ckeakfilg5wo

>   MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>   not touched for data - user space pages are used as buffers. Also
>   this limit trims every message which is > 64KB, thus such messages
>   will be send in copy mode due to 'iov_offset' check in 2).

The host still needs to allocate and copy, so maybe the limitation
could be to avoid large allocations in the host, but actually the host
can use vmalloc because it doesn't need them to be contiguous.

>
>                            PERFORMANCE
>
>Performance: it is a little bit tricky to compare performance between
>copy and zerocopy transmissions. In zerocopy way we need to wait when
>user buffers will be released by kernel, so it something like synchronous
>path (wait until device driver will process it), while in copy way we
>can feed data to kernel as many as we want, don't care about device
>driver. So I compared only time which we spend in 'sendmsg()' syscall.
>Also there is limit from 4) above so max buffer size is 64KB. I've
>tested this patchset in the nested VM, but i think for V1 it is not a
>big deal.
>
>Sender:
>./vsock_perf --sender <CID> --buf-size <buf size> --bytes 60M [--zc]
>
>Receiver:
>./vsock_perf --vsk-size 256M
>
>Number in cell is seconds which senders spends inside tx syscall.
>
>Guest to host transmission:
>
>*-------------------------------*
>|          |         |          |
>| buf size |   copy  | zerocopy |
>|          |         |          |
>*-------------------------------*
>|   4KB    |  0.26   |   0.042  |
>*-------------------------------*
>|   16KB   |  0.11   |   0.014  |
>*-------------------------------*
>|   32KB   |  0.05   |   0.009  |
>*-------------------------------*
>|   64KB   |  0.04   |   0.005  |
>*-------------------------------*
>
>Host to guest transmission:
>
>*--------------------------------*
>|          |          |          |
>| buf size |   copy   | zerocopy |
>|          |          |          |
>*--------------------------------*
>|   4KB    |   0.049  |   0.034  |
>*--------------------------------*
>|   16KB   |   0.03   |   0.024  |
>*--------------------------------*
>|   32KB   |   0.025  |   0.01   |
>*--------------------------------*
>|   64KB   |   0.028  |   0.01   |
>*--------------------------------*
>
>If host fails to send data with "Cannot allocate memory", check value
>/proc/sys/net/core/optmem_max - it is accounted during completion skb
>allocation.
>
>Zerocopy is faster than classic copy mode, but of course it requires
>specific architecture of application due to user pages pinning, buffer
>size and alignment. In next versions i'm going to fix 64KB barrier to
>perform tests with bigger buffer sizes.

Yep, I see.
Adjusting vsock_perf to compare also Gbps (can io_uring helps in this
case to have more requests in-flight?) would be great.

>
>                            TESTING
>
>This patchset includes set of tests for MSG_ZEROCOPY feature. I tried to
>cover new code as much as possible so there are different cases for
>MSG_ZEROCOPY transmissions: with disabled SO_ZEROCOPY and several io
>vector types (different sizes, alignments, with unmapped pages).

Great! Thanks for adding the tests!

I'll go through the patches between today and Monday.
Sorry again for taking so long!

Thanks,
Stefano

