Return-Path: <netdev+bounces-10190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 666B072CC47
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:21:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4D871C20B7C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C145C1C749;
	Mon, 12 Jun 2023 17:20:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37007474
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:20:56 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E441FB2;
	Mon, 12 Jun 2023 10:20:54 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-650bacd6250so3610641b3a.2;
        Mon, 12 Jun 2023 10:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686590454; x=1689182454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c935zS2u11RmvZtrD599JYGUH77y0v+EuJrHvFVjSP0=;
        b=D2voveb7+DkukujDqdVKp1BMV/vc2x1i+0b/CV1IumlkRxULqM84XqZBgrzeCCRks3
         2OfcbVGlmw/XPVq99OID0D6rA6fOOfByrenMOYttKXRiWO/tzed5tk5URqCWJwsFyusz
         5gLzhbr7PGpmSqGEG3E0ZMkeVRuFn8vioBMfNSQcPYYiwyAAWo6sLi3zYoqghzlgRRuT
         6JcVnjYtBO/JAKRdscMLO0Bl6T9+1LQ0MKkgsCQk7Nv3DfgWOyiz4pSUWcm/IXNPFyMo
         zlNafLQrdrHjwlVj5U/lyeiR5f364SiBZyBDQf4exbJu6dYIquZQvHLIjkr+EH5o+da6
         aWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590454; x=1689182454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c935zS2u11RmvZtrD599JYGUH77y0v+EuJrHvFVjSP0=;
        b=dhx02H3tFFcfhNLxAriCqioLOk3GhSq5yj7OsDVTwxsN/SYFp+0XfNcDMnCCWLh9vc
         Cn7+4jc1eVBhEM9Pz4PmNV24NzMSJyfNLuyIP4KlE4Wc6mV/mA2tGBpxpzl/LunbBR5t
         iHclq8mWd4KHMkiOiNmLlmQqvNTg5oukiZ3Fd+AzUEch05nNp09bp4FGmbBDF97w8CJb
         qsu5F5U473O+55mGw07m4s0aU64mSJsJ3pQIbOfFf1oNrWTmRRzyQHE/jANJ21ySp6/N
         hvCCrL/TXzFyfH7wKscqKaTMZSNIOWBUd/nk8dS5/2/HqrkZE51RQeNNJlqVIk+C9oTJ
         REqw==
X-Gm-Message-State: AC+VfDxCMUMd6CN4W+Y5PkYyJ6TARuUpKL9E6XIOhxfKad44f51szbLP
	HUse5UGWZ6aRi4yMOyskR40=
X-Google-Smtp-Source: ACHHUZ4tubqI7H1NlOUgrQX3N2/YtpgIm+eaN88xHWQVrcVLqYA6r4BP4CCWbgd7hMvvBfX7AZbPAQ==
X-Received: by 2002:a05:6a00:ad6:b0:64c:c453:244f with SMTP id c22-20020a056a000ad600b0064cc453244fmr12917404pfl.15.1686590454107;
        Mon, 12 Jun 2023 10:20:54 -0700 (PDT)
Received: from localhost (c-67-166-91-86.hsd1.wa.comcast.net. [67.166.91.86])
        by smtp.gmail.com with ESMTPSA id z24-20020a63c058000000b0051ba9d772f9sm7824190pgi.59.2023.06.12.10.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 10:20:53 -0700 (PDT)
Date: Mon, 12 Jun 2023 17:20:52 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 00/17] vsock: MSG_ZEROCOPY flag support
Message-ID: <ZIdT9Ei9C5wkHXNe@bullseye>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hey Arseniy,

Thanks for this series, very good stuff!

On Sat, Jun 03, 2023 at 11:49:22PM +0300, Arseniy Krasnov wrote:
> Hello,
> 
>                            DESCRIPTION
> 
> this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
> current implementation for TCP as much as possible:
> 
> 1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>    flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>    flag will be ignored (e.g. without completion).
> 
> 2) Kernel uses completions from socket's error queue. Single completion
>    for single tx syscall (or it can merge several completions to single
>    one). I used already implemented logic for MSG_ZEROCOPY support:
>    'msg_zerocopy_realloc()' etc.
> 
> Difference with copy way is not significant. During packet allocation,
> non-linear skb is created and filled with pinned user pages.
> There are also some updates for vhost and guest parts of transport - in
> both cases i've added handling of non-linear skb for virtio part. vhost
> copies data from such skb to the guest's rx virtio buffers. In the guest,
> virtio transport fills tx virtio queue with pages from skb.
> 
> Head of this patchset is:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b
> 
> 
> This version has several limits/problems:
> 
> 1) As this feature totally depends on transport, there is no way (or it
>    is difficult) to check whether transport is able to handle it or not
>    during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>    setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>    leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>    are not considered to be called from each other. So in current version
>    SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>    AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>    tx routine will fail with EOPNOTSUPP.
> 
>    ^^^
>    This is still no resolved :(
> 

I think to get around this you could use set SOCK_CUSTOM_SOCKOPT in the
vsock create function, handle SO_ZEROCOPY in the vsock handler, but pass
the rest of the common options to sock_setsockopt().

I think the next issue you would run into though is that users may call
setsockopt() before connect(), and so the transport will still be
unknown (except for dgrams, which are weird for reasons).

What do you think about EOPNOTSUPP being returned when the user selects
an incompatible transport with connect() instead of returning it later
in the tx path?

> 2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>    one completion. In each completion there is flag which shows how tx
>    was performed: zerocopy or copy. This leads that whole message must
>    be send in zerocopy or copy way - we can't send part of message with
>    copying and rest of message with zerocopy mode (or vice versa). Now,
>    we need to account vsock credit logic, e.g. we can't send whole data
>    once - only allowed number of bytes could sent at any moment. In case
>    of copying way there is no problem as in worst case we can send single
>    bytes, but zerocopy is more complex because smallest transmission
>    unit is single page. So if there is not enough space at peer's side
>    to send integer number of pages (at least one) - we will wait, thus
>    stalling tx side. To overcome this problem i've added simple rule -
>    zerocopy is possible only when there is enough space at another side
>    for whole message (to check, that current 'msghdr' was already used
>    in previous tx iterations i use 'iov_offset' field of it's iov iter).
> 
>    ^^^
>    Discussed as ok during v2. Link:
>    https://lore.kernel.org/netdev/23guh3txkghxpgcrcjx7h62qsoj3xgjhfzgtbmqp2slrz3rxr4@zya2z7kwt75l/
> 
> 3) loopback transport is not supported, because it requires to implement
>    non-linear skb handling in dequeue logic (as we "send" fragged skb
>    and "receive" it from the same queue). I'm going to implement it in
>    next versions.
> 
>    ^^^ fixed in v2
> 
> 4) Current implementation sets max length of packet to 64KB. IIUC this
>    is due to 'kmalloc()' allocated data buffers. I think, in case of
>    MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>    not touched for data - user space pages are used as buffers. Also
>    this limit trims every message which is > 64KB, thus such messages
>    will be send in copy mode due to 'iov_offset' check in 2).
> 
>    ^^^ fixed in v2
> 
>                          PATCHSET STRUCTURE
> 
> Patchset has the following structure:
> 1) Handle non-linear skbuff on receive in virtio/vhost.
> 2) Handle non-linear skbuff on send in virtio/vhost.
> 3) Updates for AF_VSOCK.
> 4) Enable MSG_ZEROCOPY support on transports.
> 5) Tests/tools/docs updates.
> 
>                             PERFORMANCE
> 
> Performance: it is a little bit tricky to compare performance between
> copy and zerocopy transmissions. In zerocopy way we need to wait when
> user buffers will be released by kernel, so it is like synchronous
> path (wait until device driver will process it), while in copy way we
> can feed data to kernel as many as we want, don't care about device
> driver. So I compared only time which we spend in the 'send()' syscall.
> Then if this value will be combined with total number of transmitted
> bytes, we can get Gbit/s parameter. Also to avoid tx stalls due to not
> enough credit, receiver allocates same amount of space as sender needs.
> 
> Sender:
> ./vsock_perf --sender <CID> --buf-size <buf size> --bytes 256M [--zc]
> 
> Receiver:
> ./vsock_perf --vsk-size 256M
> 
> I run tests on two setups: desktop with Core i7 - I use this PC for
> development and in this case guest is nested guest, and host is normal
> guest. Another hardware is some embedded board with Atom - here I don't
> have nested virtualization - host runs on hw, and guest is normal guest.
> 
> G2H transmission (values are Gbit/s):
> 
>    Core i7 with nested guest.            Atom with normal guest.
> 
> *-------------------------------*   *-------------------------------*
> |          |         |          |   |          |         |          |
> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
> |          |         |          |   |          |         |          |
> *-------------------------------*   *-------------------------------*
> |   4KB    |    3    |    10    |   |   4KB    |   0.8   |   1.9    |
> *-------------------------------*   *-------------------------------*
> |   32KB   |   20    |    61    |   |   32KB   |   6.8   |   20.2   |
> *-------------------------------*   *-------------------------------*
> |   256KB  |   33    |   244    |   |   256KB  |   7.8   |   55     |
> *-------------------------------*   *-------------------------------*
> |    1M    |   30    |   373    |   |    1M    |   7     |   95     |
> *-------------------------------*   *-------------------------------*
> |    8M    |   22    |   475    |   |    8M    |   7     |   114    |
> *-------------------------------*   *-------------------------------*
> 
> H2G:
> 
>    Core i7 with nested guest.            Atom with normal guest.
> 
> *-------------------------------*   *-------------------------------*
> |          |         |          |   |          |         |          |
> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
> |          |         |          |   |          |         |          |
> *-------------------------------*   *-------------------------------*
> |   4KB    |   20    |    10    |   |   4KB    |   4.37  |    3     |
> *-------------------------------*   *-------------------------------*
> |   32KB   |   37    |    75    |   |   32KB   |   11    |   18     |
> *-------------------------------*   *-------------------------------*
> |   256KB  |   44    |   299    |   |   256KB  |   11    |   62     |
> *-------------------------------*   *-------------------------------*
> |    1M    |   28    |   335    |   |    1M    |   9     |   77     |
> *-------------------------------*   *-------------------------------*
> |    8M    |   27    |   417    |   |    8M    |  9.35   |  115     |
> *-------------------------------*   *-------------------------------*
> 

Nice!


[...]

Thanks,
Bobby

