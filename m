Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6B8567216
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiGEPIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiGEPHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:07:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCA92183E;
        Tue,  5 Jul 2022 08:04:51 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k129so7234758wme.0;
        Tue, 05 Jul 2022 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vcTGHPsojIuSD0qPE2WGEv7v1zdhzV1iq4Dm3FYehrs=;
        b=aswheMVgu1xjvVbYqWJk4cJN3VTXbs0v+RNobdlHr9qHeOPYmfgU2LXiGkCl32eOMx
         Lat26/0MIy50rPFZeP27aBYWJoN5aI1bRE+/b/riowsrkH0rLQaILNrV4o4D7LhX8FR/
         Y8BsES8JllyFmbT86I3+m0OgaLug0towponIhslZ7IxYr2eG9uipD0tRelF142phbKON
         v8doRISyhK8f2xEj7IhBkjBw/32AXbW2sVdqwkR39waRNFCuumZVuJIPJwDgQVdf2MW5
         DPR1fgLimHX+lfjKYtxBXmvNUUxCiYyowxYjLdS1GZowIiqY78nuCd1buWock4yvkeb+
         6wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vcTGHPsojIuSD0qPE2WGEv7v1zdhzV1iq4Dm3FYehrs=;
        b=R6fbMOWQqYLSV8q5mhN4qCVq9Q7I50r6jo5sOsBIoM2FT20xt+Lj4krerxzwefd2Ua
         zThi37WGqEiiHnOfQpIS4ucMJEj1TT26wHwnOh9PTJ7JGb6hJXwJ+D3qBVJ3QMoUfPbh
         W+xhqecOZqWPOLxp2U/RJvX2vFZ5Zha0w/vYISmZnDodIVPvcFd3EYkyw5FQmDBf2IJ8
         dU7OPpYh6W0HNyMgNizz4732vTuXsOZOwFkzSQWaq0+CsIzTbu0YrNgv1nfNAbAqatAs
         3cgX2r/MYORTRY4VWIAKkhgA2DSLTpS2qLB6WKrzP6t4a6jhKGnWFwitGmMo4AdeJvSK
         vNIw==
X-Gm-Message-State: AJIora8awhSWu7dFLWpPSnmAFq/kBIB9zl7LUnKDArZgHgsEphMVQVlM
        VEerkgmtgdi2wsjN86RIyI5Wwxv3MThQBw==
X-Google-Smtp-Source: AGRyM1uwRimjKyKfrQHEVc+kP+TyyPmpOQXigJqsmpJtp8lThL7J6d9ddJ5zgnwEu5LqKKsWSjkX4w==
X-Received: by 2002:a05:600c:1548:b0:3a1:95fc:aa42 with SMTP id f8-20020a05600c154800b003a195fcaa42mr19092956wmg.189.1657033489229;
        Tue, 05 Jul 2022 08:04:49 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a1-20020a05600c348100b003a03be22f9fsm17854421wmq.18.2022.07.05.08.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 08:04:48 -0700 (PDT)
Message-ID: <15cff5cd-52d5-68af-75c1-32be28137773@gmail.com>
Date:   Tue, 5 Jul 2022 16:04:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 00/25] io_uring zerocopy send
Content-Language: en-US
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
References: <cover.1656318994.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/22 16:01, Pavel Begunkov wrote:

NOTE: This is not be picked directly due to cross-subsystem merge problems.
After finding a consensus and getting necessary acks, I'll work out merging
with Jakub and Jens.


> The patchset implements io_uring zerocopy send. It works with both registered
> and normal buffers, mixing is allowed but not recommended. Apart from usual
> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
> the userspace when buffers are freed and can be reused (see API design below),
> which is delivered into io_uring's Completion Queue. Those "buffer-free"
> notifications are not necessarily per request, but the userspace has control
> over it and should explicitly attaching a number of requests to a single
> notification. The series also adds some internal optimisations when used with
> registered buffers like removing page referencing.
> 
>  From the kernel networking perspective there are two main changes. The first
> one is passing ubuf_info into the network layer from io_uring (inside of an
> in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
> caching on the io_uring side, but also helps to avoid cross-referencing
> and synchronisation problems. The second part is an optional optimisation
> removing page referencing for requests with registered buffers.
> 
> Benchmarking with an optimised version of the selftest (see [1]), which in a
> loop sends a bunch of requests and then waits for their completions. "+ flush"
> column posts one additional "buffer-free" notification per request, and
> just "zc" doesn't post buffer notifications at all.
> 
> NIC (requests / second):
> IO size | non-zc    | zc             | zc + flush
> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
> 
> dummy (requests / second):
> IO size | non-zc    | zc             | zc + flush
> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
> 
> Previously it also brought a massive performance speedup compared to the
> msg_zerocopy tool (see [3]), which is probably not super interesting.
> 
> There is an additional bunch of refcounting optimisations that was omitted from
> the series for simplicity and as they don't change the picture drastically,
> they will be sent as follow up, as well as flushing optimisations closing the
> performance gap b/w two last columns.
> 
> Note: the series is based on net-next + for-5.20/io_uring, but as vanilla
> net-next fails for me the repo (see [2]) is on top of for-5.20/io_uring.
> 
> Links:
> 
>    liburing (benchmark + some tests):
>    [1] https://github.com/isilence/liburing/tree/zc_v3
> 
>    kernel repo:
>    [2] https://github.com/isilence/linux/tree/zc_v3
> 
>    RFC v1:
>    [3] https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/
> 
>    RFC v2:
>    https://lore.kernel.org/io-uring/cover.1640029579.git.asml.silence@gmail.com/
> 
> API design overview:
> 
>    The series introduces an io_uring concept of notifactors. From the userspace
>    perspective it's an entity to which it can bind one or more requests and then
>    requesting to flush it. Flushing a notifier makes it impossible to attach new
>    requests to it, and instructs the notifier to post a completion once all
>    requests attached to it are completed and the kernel doesn't need the buffers
>    anymore.
> 
>    Notifications are stored in notification slots, which should be registered as
>    an array in io_uring. Each slot stores only one notifier at any particular
>    moment. Flushing removes it from the slot and the slot automatically replaces
>    it with a new notifier. All operations with notifiers are done by specifying
>    an index of a slot it's currently in.
> 
>    When registering a notification the userspace specifies a u64 tag for each
>    slot, which will be copied in notification completion entries as
>    cqe::user_data. cqe::res is 0 and cqe::flags is equal to wrap around u32
>    sequence number counting notifiers of a slot.
> 
> Changelog:
> 
>    RFC v2 -> v3:
>      mem accounting for non-registered buffers
>      allow mixing registered and normal requests per notifier
>      notification flushing via IORING_OP_RSRC_UPDATE
>      TCP support
>      fix buffer indexing
>      fix io-wq ->uring_lock locking
>      fix bugs when mixing with MSG_ZEROCOPY
>      fix managed refs bugs in skbuff.c
> 
>    RFC -> RFC v2:
>      remove additional overhead for non-zc from skb_release_data()
>      avoid msg propagation, hide extra bits of non-zc overhead
>      task_work based "buffer free" notifications
>      improve io_uring's notification refcounting
>      added 5/19, (no pfmemalloc tracking)
>      added 8/19 and 9/19 preventing small copies with zc
>      misc small changes
> 
> Pavel Begunkov (25):
>    ipv4: avoid partial copy for zc
>    ipv6: avoid partial copy for zc
>    skbuff: add SKBFL_DONT_ORPHAN flag
>    skbuff: carry external ubuf_info in msghdr
>    net: bvec specific path in zerocopy_sg_from_iter
>    net: optimise bvec-based zc page referencing
>    net: don't track pfmemalloc for managed frags
>    skbuff: don't mix ubuf_info of different types
>    ipv4/udp: support zc with managed data
>    ipv6/udp: support zc with managed data
>    tcp: support zc with managed data
>    io_uring: add zc notification infrastructure
>    io_uring: export task put
>    io_uring: cache struct io_notif
>    io_uring: complete notifiers in tw
>    io_uring: add notification slot registration
>    io_uring: wire send zc request type
>    io_uring: account locked pages for non-fixed zc
>    io_uring: allow to pass addr into sendzc
>    io_uring: add rsrc referencing for notifiers
>    io_uring: sendzc with fixed buffers
>    io_uring: flush notifiers after sendzc
>    io_uring: rename IORING_OP_FILES_UPDATE
>    io_uring: add zc notification flush requests
>    selftests/io_uring: test zerocopy send
> 
>   include/linux/io_uring_types.h                |  37 ++
>   include/linux/skbuff.h                        |  59 +-
>   include/linux/socket.h                        |   7 +
>   include/uapi/linux/io_uring.h                 |  43 +-
>   io_uring/Makefile                             |   2 +-
>   io_uring/io_uring.c                           |  40 +-
>   io_uring/io_uring.h                           |  21 +
>   io_uring/net.c                                | 134 ++++
>   io_uring/net.h                                |   4 +
>   io_uring/notif.c                              | 215 +++++++
>   io_uring/notif.h                              |  87 +++
>   io_uring/opdef.c                              |  24 +-
>   io_uring/rsrc.c                               |  55 +-
>   io_uring/rsrc.h                               |  16 +-
>   io_uring/tctx.h                               |  26 -
>   net/compat.c                                  |   2 +
>   net/core/datagram.c                           |  53 +-
>   net/core/skbuff.c                             |  35 +-
>   net/ipv4/ip_output.c                          |  63 +-
>   net/ipv4/tcp.c                                |  52 +-
>   net/ipv6/ip6_output.c                         |  62 +-
>   net/socket.c                                  |   6 +
>   tools/testing/selftests/net/Makefile          |   1 +
>   .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
>   .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
>   25 files changed, 1652 insertions(+), 128 deletions(-)
>   create mode 100644 io_uring/notif.c
>   create mode 100644 io_uring/notif.h
>   create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
>   create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> 

-- 
Pavel Begunkov
