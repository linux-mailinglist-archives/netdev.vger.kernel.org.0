Return-Path: <netdev+bounces-3799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D552C708E8A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5E99281B0F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B438639;
	Fri, 19 May 2023 04:07:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10889633;
	Fri, 19 May 2023 04:07:04 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB4E10CF;
	Thu, 18 May 2023 21:07:03 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d2a613ec4so694280b3a.1;
        Thu, 18 May 2023 21:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469223; x=1687061223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Re4+GROEMOOBGWemxWaQLdyEbL6oJm1334MkHSEPjG4=;
        b=MWkk/VzNUYO2HDUm4PrEL0309HwmB484A0xi/efpDEAYE1II7DYr9j/pPz3+irqQTu
         8oR0ZXVndEbrUDeI2FYzQbyMx7hft3+bEqQFve5bDo2fgAmy8qFcVbd/ecwb/q8MYhjJ
         AmCAxeQACSmkHSIx8FdmLP5/6m5FlVriTO/NHmNCXwE7VeCcO9bEu7v/nCqitV7CM4Vp
         6m4i9gm4jVG2mXi47gA5M2a6ekWJppzAiTgEeEanjj0FI9uQWcKmhUXKlfisvLkmB+sl
         0kiBqgLInAMNhHBUcgRCAlA0gG4NC74eOsc/A0Dm2Nj2rELcrBPpig9THUR/y9n4KQV6
         sccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469223; x=1687061223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Re4+GROEMOOBGWemxWaQLdyEbL6oJm1334MkHSEPjG4=;
        b=MlHAz16YuGWFFCDcnLTKTZYzeh/Tm0CmQl/6/yjm727JBVGaSgJkUzvUecv0lCCOyg
         VWtvUnnLC7sorTPQpO+riecYyl7htFB4G5DarnxIHQHtIw0qnixwxK4JUIhgCO+Sldrp
         /VGFMPYPL9OPMO5eWmcxuPd1uCHYmFYJlzehc3L01WJr9AO9/+QSIflm4ka6kHBf7eoS
         OnbVV4J0enhfHiuRCVfBXI2rqI2j+UxDldhe+vRr0oeUUUKCpVqeww4FFKROonhIMTK7
         fa5LH8UQTrQF3HsgrDDWsIuM75vE2nFdFv2QOCNsIux4SlMKJSyXZi0Riq820YLHDB0u
         1WHA==
X-Gm-Message-State: AC+VfDzbcN1sbhZ9XpYqYAY+p2Al7MbFoDjux5k1MM1FBEJPx2OpyR1w
	8iP9VT257+iwB3LIl3H7KDc=
X-Google-Smtp-Source: ACHHUZ5qEbtFVUyuMhwQ/jO/+5oz7ZEY/rWcWGi0CPiZvcZFV4gOOBslZXdJGGRZzmxeD3f9BjJ1zA==
X-Received: by 2002:a05:6a20:a591:b0:104:98ea:48d5 with SMTP id bc17-20020a056a20a59100b0010498ea48d5mr762179pzb.36.1684469222419;
        Thu, 18 May 2023 21:07:02 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:01 -0700 (PDT)
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
Subject: [PATCH bpf v9 00/14] bpf sockmap fixes
Date: Thu, 18 May 2023 21:06:45 -0700
Message-Id: <20230519040659.670644-1-john.fastabend@gmail.com>
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

v9, rebased which resulted in two additions needed. Patch 14
to resolve an introduced verifier error. I'll try to dig into
exactly what happened but the fix was easy to get test_sockmap
running again. And then in vsock needed similar fix to the
the protocols so I folded that into the first patch.

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

v9: rebase and fixup test_sockmap verifier error and vsock
    that was introduced recently.


John Fastabend (14):
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
  bpf: sockmap, test progs verifier error with latest clang

 include/linux/skmsg.h                         |   3 +-
 include/net/tcp.h                             |  10 +
 net/core/skmsg.c                              |  81 ++--
 net/core/sock_map.c                           |   3 +-
 net/ipv4/tcp.c                                |  11 +-
 net/ipv4/tcp_bpf.c                            |  79 +++-
 net/ipv4/udp.c                                |   7 +-
 net/unix/af_unix.c                            |   7 +-
 net/vmw_vsock/virtio_transport_common.c       |   5 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 131 ++++++
 .../bpf/prog_tests/sockmap_helpers.h          | 385 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 365 +----------------
 .../bpf/progs/test_sockmap_drop_prog.c        |  32 ++
 .../selftests/bpf/progs/test_sockmap_kern.h   |  12 +-
 .../bpf/progs/test_sockmap_pass_prog.c        |  32 ++
 15 files changed, 726 insertions(+), 437 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

-- 
2.33.0


