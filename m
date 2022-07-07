Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5061156A1A3
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiGGLvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiGGLvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:50 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC584F1AE;
        Thu,  7 Jul 2022 04:51:48 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u12-20020a05600c210c00b003a02b16d2b8so10565596wml.2;
        Thu, 07 Jul 2022 04:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ogkoMPpbqUpUeQsCWCgDb8e2gSa/FEdLqVBOJmxNJ7Y=;
        b=WTXWzzSqMW2xUPWKSm2FY6juWE54kahXBN/lxg32iKLQMfyWor4CnlQTpFrSuExssu
         azRfkuijKbfrqi0c9j9Wuow372d78XDjEnKwhRyJtzpxiQtp2sy9KitOgLwVRjwvOvO3
         6ryhleJyeBbRFZgXLpCSyvVVQXIqtJ/tMvfSVDrruvF75Ba3kz593P6mXNWNHA4hKLsl
         fjjqJdjYlr7n6VKhK61RkafmK/aRPPP/lhBS/uHu9ehZ7uuTi4atY5OZT6Cfo/2Kh7Zt
         oIbvCZhT8xmzHnUU8QpUcpK3JTOlfV7RmjBIJqQpmBmzQroMKiwt/5ItGgcqw4wq+npT
         e1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ogkoMPpbqUpUeQsCWCgDb8e2gSa/FEdLqVBOJmxNJ7Y=;
        b=f7bVcgysf3287wBTEWASR4X+2u5iVXRKnQ6uwVenQQVwgskZl/XCsHBirXwwGaeoof
         nZkKn0IYrJ3dhb7U0yUZv2QxVhb8W4WMjYur62pxE+z2y/hPeoehxZHXfvUQL0vcLmc7
         F/P2BqTnWauJGCJ314kmJT8cdRqHQN/slJFG7YAQK71IEE39FufdvDOhf0YTcbQj7ies
         SsXUa7qqpbegW5mpeR0GhqWM84mEijr8Hsk/lSGWPmqQ0mCKCwBTTV9AECA5XIWhpknn
         W1M+QkDAIj5Pzkv+H+j0DwFZOX0Kz/5jlNp22KjdXeCTeGreTUJkY5Y5/YKpSnjX4g7M
         9mwQ==
X-Gm-Message-State: AJIora8Z75NCqMcsrJblspQFVGHwkJKb5Hn9agtV7aPhUKemLQZBkTDG
        /zVfqe8IeZrBpEOQ4pQ/AV/bYTGamBZd5R4fXco=
X-Google-Smtp-Source: AGRyM1sAH+mtKXEWcPCw/5qvsn9M3uN7o3s/XIhWb8Y5mjr/W5j62chBWusjy49VfVTbCBGeZoiC6A==
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr4061663wmp.97.1657194706784;
        Thu, 07 Jul 2022 04:51:46 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 00/27] io_uring zerocopy send
Date:   Thu,  7 Jul 2022 12:49:31 +0100
Message-Id: <cover.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NOTE: Not be picked directly. After getting necessary acks, I'll be working
      out merging with Jakub and Jens.

The patchset implements io_uring zerocopy send. It works with both registered
and normal buffers, mixing is allowed but not recommended. Apart from usual
request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
the userspace when buffers are freed and can be reused (see API design below),
which is delivered into io_uring's Completion Queue. Those "buffer-free"
notifications are not necessarily per request, but the userspace has control
over it and should explicitly attaching a number of requests to a single
notification. The series also adds some internal optimisations when used with
registered buffers like removing page referencing.

From the kernel networking perspective there are two main changes. The first
one is passing ubuf_info into the network layer from io_uring (inside of an
in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
caching on the io_uring side, but also helps to avoid cross-referencing
and synchronisation problems. The second part is an optional optimisation
removing page referencing for requests with registered buffers.

Benchmarking with an optimised version of the selftest (see [1]), which sends
a bunch of requests, waits for completions and repeats. "+ flush" column posts
one additional "buffer-free" notification per request, and just "zc" doesn't
post buffer notifications at all.

NIC (requests / second):
IO size | non-zc    | zc             | zc + flush
4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)

dummy (requests / second):
IO size | non-zc    | zc             | zc + flush
8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)

Previously it also brought a massive performance speedup compared to the
msg_zerocopy tool (see [3]), which is probably not super interesting.

There is an additional bunch of refcounting optimisations that was omitted from
the series for simplicity and as they don't change the picture drastically,
they will be sent as follow up, as well as flushing optimisations closing the
performance gap b/w two last columns.

Note: the series is based on net-next + for-5.20/io_uring, but as vanilla
net-next fails for me the repo (see [2]) is on top of for-5.20/io_uring.

Links:

  liburing (benchmark + tests):
  [1] https://github.com/isilence/liburing/tree/zc_v4

  kernel repo:
  [2] https://github.com/isilence/linux/tree/zc_v4

  RFC v1:
  [3] https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/

  RFC v2:
  https://lore.kernel.org/io-uring/cover.1640029579.git.asml.silence@gmail.com/

  Net patches based
  git@github.com:isilence/linux.git zc_v4-net-base

API design overview:

  The series introduces an io_uring concept of notifactors. From the userspace
  perspective it's an entity to which it can bind one or more requests and then
  requesting to flush it. Flushing a notifier makes it impossible to attach new
  requests to it, and instructs the notifier to post a completion once all
  requests attached to it are completed and the kernel doesn't need the buffers
  anymore.

  Notifications are stored in notification slots, which should be registered as
  an array in io_uring. Each slot stores only one notifier at any particular
  moment. Flushing removes it from the slot and the slot automatically replaces
  it with a new notifier. All operations with notifiers are done by specifying
  an index of a slot it's currently in.

  When registering a notification the userspace specifies a u64 tag for each
  slot, which will be copied in notification completion entries as
  cqe::user_data. cqe::res is 0 and cqe::flags is equal to wrap around u32
  sequence number counting notifiers of a slot.

Changelog:

  v3 -> v4
    custom iov_iter handling

  RFC v2 -> v3:
    mem accounting for non-registered buffers
    allow mixing registered and normal requests per notifier
    notification flushing via IORING_OP_RSRC_UPDATE
    TCP support
    fix buffer indexing
    fix io-wq ->uring_lock locking
    fix bugs when mixing with MSG_ZEROCOPY
    fix managed refs bugs in skbuff.c

  RFC -> RFC v2:
    remove additional overhead for non-zc from skb_release_data()
    avoid msg propagation, hide extra bits of non-zc overhead
    task_work based "buffer free" notifications
    improve io_uring's notification refcounting
    added 5/19, (no pfmemalloc tracking)
    added 8/19 and 9/19 preventing small copies with zc
    misc small changes

David Ahern (1):
  net: Allow custom iter handler in msghdr

Pavel Begunkov (26):
  ipv4: avoid partial copy for zc
  ipv6: avoid partial copy for zc
  skbuff: don't mix ubuf_info from different sources
  skbuff: add SKBFL_DONT_ORPHAN flag
  skbuff: carry external ubuf_info in msghdr
  net: introduce managed frags infrastructure
  net: introduce __skb_fill_page_desc_noacc
  ipv4/udp: support externally provided ubufs
  ipv6/udp: support externally provided ubufs
  tcp: support externally provided ubufs
  io_uring: initialise msghdr::msg_ubuf
  io_uring: export io_put_task()
  io_uring: add zc notification infrastructure
  io_uring: cache struct io_notif
  io_uring: complete notifiers in tw
  io_uring: add rsrc referencing for notifiers
  io_uring: add notification slot registration
  io_uring: wire send zc request type
  io_uring: account locked pages for non-fixed zc
  io_uring: allow to pass addr into sendzc
  io_uring: sendzc with fixed buffers
  io_uring: flush notifiers after sendzc
  io_uring: rename IORING_OP_FILES_UPDATE
  io_uring: add zc notification flush requests
  io_uring: enable managed frags with register buffers
  selftests/io_uring: test zerocopy send

 include/linux/io_uring_types.h                |  37 ++
 include/linux/skbuff.h                        |  66 +-
 include/linux/socket.h                        |   5 +
 include/uapi/linux/io_uring.h                 |  45 +-
 io_uring/Makefile                             |   2 +-
 io_uring/io_uring.c                           |  42 +-
 io_uring/io_uring.h                           |  22 +
 io_uring/net.c                                | 187 ++++++
 io_uring/net.h                                |   4 +
 io_uring/notif.c                              | 215 +++++++
 io_uring/notif.h                              |  87 +++
 io_uring/opdef.c                              |  24 +-
 io_uring/rsrc.c                               |  55 +-
 io_uring/rsrc.h                               |  16 +-
 io_uring/tctx.h                               |  26 -
 net/compat.c                                  |   1 +
 net/core/datagram.c                           |  14 +-
 net/core/skbuff.c                             |  37 +-
 net/ipv4/ip_output.c                          |  50 +-
 net/ipv4/tcp.c                                |  32 +-
 net/ipv6/ip6_output.c                         |  49 +-
 net/socket.c                                  |   3 +
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
 .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
 25 files changed, 1628 insertions(+), 128 deletions(-)
 create mode 100644 io_uring/notif.c
 create mode 100644 io_uring/notif.h
 create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
 create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh

-- 
2.36.1

