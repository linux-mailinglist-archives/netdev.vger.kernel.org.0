Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5E75727CA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiGLUxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGLUxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:10 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBE2CC7B3;
        Tue, 12 Jul 2022 13:53:09 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so88346wmb.3;
        Tue, 12 Jul 2022 13:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ih7ca1XFNBvW21TmsDZ0YEYcVjZEuP7NxIbhOweV4rk=;
        b=lxi29WSGdHQoqv0SjQjxQ8+IMB/ajkiCtimvN5HUXXG2WcNqhBkwryqytnZydIdT9Y
         KRKGANu33s/wKerLt+1XH4pELJ+sTVOiDJB5e1FO1Bzbo/Wlnvy+hA+zYAtsfbf6O+lE
         FDzDM1AOUB3lWLex+OFbhVjAdRWSHdPpXLIuxpKW/oLiz8aTeO7NflAopH+xYYOPL+ua
         9unOgqz0bk6e6QUCutA6UXIKhx2nNMDM6o0Oh0TzKLrHtL7BCoAK6tUvNTEKJQtzfjbF
         azZi2DD9aOHiwzayjoaRzACDBNeiu7hdQjE1R2niSrcoCMgenDbvEu+KocwyeljheraO
         0Y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ih7ca1XFNBvW21TmsDZ0YEYcVjZEuP7NxIbhOweV4rk=;
        b=Y9tilrKXGCQYN3E//vx0l+dt+9nsaSmPf4l7QdHxmatLutDP+Se2zDGO8SbknGOn1f
         tw3/aKELKY/F84ZL6YOTGYfwNCNvAHPv8S/r9Z4AOr/1ygnekat6/WzPXPoahAEjbIvN
         XhZslxGn8ScYGu46JdWCwcsaMRHUqdhliy6JG6hqxHBRi9JBQkbtlhqwZxq0Wwdgzyf/
         VqjxuXNneb6XaVp4bXSM8QU9vnLfuGrm/DcUd7PrAxniELW6/Xr8RSNWGmJJOsQHNozA
         pJkUPQ64xPC0f+Rk3mHO7DH4K7FJBa3f3jS4scv7sqMK1Jf0+aVj4YckHlV2Srmuf+Uh
         LBkA==
X-Gm-Message-State: AJIora8fZS5QmXxC+FMBzkbgV+TXSS2RM8AFuB0du+AqDh4+HFHenjDr
        mE1iRaWQD6/qc8H4NTCexe4kpf/wJgU=
X-Google-Smtp-Source: AGRyM1vWJmFtv+VE6VELazo6TQh83iwIOKlpkHUxrD07MXd37jzlO+wacfgaQxajH6hV6x1Kj9kNfQ==
X-Received: by 2002:a1c:f607:0:b0:3a0:3dc9:c4db with SMTP id w7-20020a1cf607000000b003a03dc9c4dbmr6002742wmc.30.1657659187133;
        Tue, 12 Jul 2022 13:53:07 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 00/27] io_uring zerocopy send
Date:   Tue, 12 Jul 2022 21:52:24 +0100
Message-Id: <cover.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

NOTE: Not to be picked directly. After getting necessary acks, I'll be
      working out merging with Jakub and Jens.

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

Benchmarking UDP with an optimised version of the selftest (see [1]), which
sends a bunch of requests, waits for completions and repeats. "+ flush" column
posts one additional "buffer-free" notification per request, and just "zc"
doesn't post buffer notifications at all.

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
msg_zerocopy tool (see [3]), which is probably not super interesting. There
is also an additional bunch of refcounting optimisations that was omitted from
the series for simplicity and as they don't change the picture drastically,
they will be sent as follow up, as well as flushing optimisations closing the
performance gap b/w two last columns.

For TCP on localhost (with hacks enabling localhost zerocopy) and including
additional overhead for receive:

IO size | non-zc    | zc
1200    | 4174      | 4148
4096    | 7597      | 11228

Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
omitted optimisations will somewhat help, should look better for 4000,
but couldn't test properly because of setup problems.

Links:

  liburing (benchmark + tests):
  [1] https://github.com/isilence/liburing/tree/zc_v4

  kernel repo:
  [2] https://github.com/isilence/linux/tree/zc_v4

  RFC v1:
  [3] https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/

  RFC v2:
  https://lore.kernel.org/io-uring/cover.1640029579.git.asml.silence@gmail.com/

  Net patches based:
  git@github.com:isilence/linux.git zc_v4-net-base
  or
  https://github.com/isilence/linux/tree/zc_v4-net-base

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

  v4 -> v5
    remove ubuf_info checks from custom iov_iter callbacks to
    avoid disabling the page refs optimisations for TCP

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
2.37.0

