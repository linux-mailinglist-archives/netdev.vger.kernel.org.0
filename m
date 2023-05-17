Return-Path: <netdev+bounces-3192-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01545705F2B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1969281479
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E985238;
	Wed, 17 May 2023 05:22:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78A3210D;
	Wed, 17 May 2023 05:22:59 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B974215;
	Tue, 16 May 2023 22:22:49 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-24e16918323so341337a91.2;
        Tue, 16 May 2023 22:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300968; x=1686892968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BDkJ42HQy5+j1cZC2g7c/JXDUzmvh0G977avAEaYTh0=;
        b=eQtNpr9ZDYvMtNOnHtImpznC/2tbu/uH2RaKoYI20neadD2PPwQHPyzCYbqw8rMCdt
         nqGU73yDaTHRKR8kwAWrEbZYkWjHhcgNpwBxi+N05VcYICUee8ylPEY/z9u4RAPHweMC
         DQgAsbV1lX9lLzEZoaI1KVEfz2FFkXclZQzFctbKjTbTKACh8ymJfPNbMNV+xZJ0GuBw
         kQUh7+lisdeoQT23DQuS5yVRJrM2IJjkjQ7uoQVyuroxpsTA/902d4rsa/ZGBswRqGn1
         rF+SjGdAGLx11ZFQhIuyq41aAJc6KgSxsGK/LWj9zh3dSt8QQZ0+xk8itECvjey1QU/H
         bM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300968; x=1686892968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BDkJ42HQy5+j1cZC2g7c/JXDUzmvh0G977avAEaYTh0=;
        b=NZzoWTkgdrsT4Bx9IpVZDFPH9TrImyKf5kee2VkhWNUZjYLMd87zXt2/bGpRSFBPao
         rhB2smuIxv9WjwZoHoXfPo7xKxxfei6kBw4f1v0h1tUk4aGPzTicKRBWmhUdDN5kvJ2S
         lUgCro8lvFYmae+m2Ew6YJ0B5Evg02DQDk6kjd5rPaH+Mj5SI1ZNMxOWpr2ViMUpnoeL
         MrQa+aJ99xn7KjV97KhV9ap6TW9yFanGBj7zyqPe/2Tpkl1WAim6PfBNwJUPeXRowCzx
         z6wwDek3wXi8MB6YnXcGR9rZpVfFoTuIMVMvc4yS9U7EMn/xpHvujcLO0t8HlMcuvPLC
         KUJg==
X-Gm-Message-State: AC+VfDywq1WhtHHb5JDf3ylljIiZezKbkN8yFXJxhoTpA2sH0QMVYi7x
	cjpBmT3mw0SAzTW3Coc/pMc=
X-Google-Smtp-Source: ACHHUZ4RZHR+Y7u4duFyU3TcT1kuNotP9evHybbvT8vcJv+ArLfEADZyqDSlbNBKV40r+KWMiS01BA==
X-Received: by 2002:a17:90a:31c6:b0:24d:ec21:b83c with SMTP id j6-20020a17090a31c600b0024dec21b83cmr39407178pjf.16.1684300968385;
        Tue, 16 May 2023 22:22:48 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:22:47 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v8 00/13] bpf sockmap fixes
Date: Tue, 16 May 2023 22:22:31 -0700
Message-Id: <20230517052244.294755-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This v8 iteration adds another fix suggested by Jakub to always
check the enable bit is set before rescheduling to avoid trying
to reschedule backlog queue handler while trying to tear down
a socket. Also cleaned up one of the tests as suggested by Jakub
to avoid creating unused pair of sockets.

Fixes for sockmap running against NGINX TCP tests and also on an
underprovisioned VM so that we hit error (ENOMEM) cases regularly.

The first 3 patches fix cases related to ENOMEM that were either
causing splats or data hangs.

Then 4-7 resolved cases found when running NGINX with its sockets
assigned to sockmap. These mostly have to do with handling fin/shutdown
incorrectly and ensuring epoll_wait works as expected.

Patches 8 and 9 extract some of the logic used for sockmap_listen tests
so that we can use it in other tests because it didn't make much
sense to me to add tests to the sockmap_listen cases when here we
are testing send/recv *basic* cases.

Finally patches 10, 11 and 12 add the new tests to ensure we handle
ioctl(FIONREAD) and shutdown correctly.

To test the series I ran the NGINX compliance tests and the sockmap
selftests. For now our compliance test just runs with SK_PASS.

There are some more things to be done here, but these 11 patches
stand on their own in my opionion and fix issues we are having in
CI now. For bpf-next we can fixup/improve selftests to use the
ASSERT_* in sockmap_helpers, streamline some of the testing, and
add more tests. We also still are debugging a few additional flakes
patches coming soon.

v2: use skb_queue_empty instead of *_empty_lockless (Eric)
    oops incorrectly updated copied_seq on DROP case (Eric)
    added test for drop case copied_seq update

v3: Fix up comment to use /**/ formatting and update commit
    message to capture discussion about previous fix attempt
    for hanging backlog being imcomplete.

v4: build error sockmap things are behind NET_SKMSG not in
    BPF_SYSCALL otherwise you can build the .c file but not
    have correct headers.

v5: typo with mispelled SOCKMAP_HELPERS

v6: fix to build without INET enabled for the other sockmap
    types e.g. af_unix.

v7: We can not protect backlog queue with a mutex because in
    some cases we call this with sock lock held. Instead do
    as Jakub suggested and peek the queue and only pop the
    skb when its been correctly processed.

v8: Only schedule backlog when still enabled and cleanup test
    to not create unused sockets.


John Fastabend (13):
  bpf: sockmap, pass skb ownership through read_skb
  bpf: sockmap, convert schedule_work into delayed_work
  bpf: sockmap, reschedule is now done through backlog
  bpf: sockmap, improved check for empty queue
  bpf: sockmap, handle fin correctly
  bpf: sockmap, TCP data stall on recv before accept
  bpf: sockmap, wake up polling after data copy
  bpf: sockmap, incorrectly handling copied_seq
  bpf: sockmap, pull socket helpers out of listen test for general use
  bpf: sockmap, build helper to create connected socket pair
  bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
  bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
  bpf: sockmap, test FIONREAD returns correct bytes in rx buffer with
    drops

 include/linux/skmsg.h                         |   3 +-
 include/net/tcp.h                             |  10 +
 net/core/skmsg.c                              |  81 ++--
 net/core/sock_map.c                           |   3 +-
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_bpf.c                            |  79 +++-
 net/ipv4/udp.c                                |   7 +-
 net/unix/af_unix.c                            |   7 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 131 +++++++
 .../bpf/prog_tests/sockmap_helpers.h          | 367 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 352 +----------------
 .../bpf/progs/test_sockmap_drop_prog.c        |  32 ++
 .../bpf/progs/test_sockmap_pass_prog.c        |  32 ++
 13 files changed, 702 insertions(+), 413 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

-- 
2.33.0


