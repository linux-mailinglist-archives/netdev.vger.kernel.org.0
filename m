Return-Path: <netdev+bounces-4489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4AC70D1D3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91C712810F3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952D05387;
	Tue, 23 May 2023 02:56:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780DC5383;
	Tue, 23 May 2023 02:56:23 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FB0CA;
	Mon, 22 May 2023 19:56:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ae4baa77b2so49069225ad.2;
        Mon, 22 May 2023 19:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684810581; x=1687402581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HEh+zzOHQCo+TnWqwjXnzV0aEWaUm7osvJcR0/JH4oA=;
        b=VxxB6plF+UrheFY0L4Zw2Vivmf4caxJ0ihELp9Krsn14s+Edlep+YHwNXKMwHPOo61
         zXHfRWzHjbIU4yad+wNrANrSnDhxmstoWoRgXAevyJ/rskS/F05nm1eudcIknERlD/rv
         QdLcxOd0x5Lk01uUe0fnDgjPsr6F96rWeq+JrHeYwXuSm8y01yz74kp0MnmRYGaLeQZr
         aKgufOOehM9qwQqow3PBx+0Mm5G6Osa7x8nQxBbrZuaxFabdFikmQIuUoSqTI06uR3Oe
         M1Y+PhXrXUQcDjOeL6pyWgzVPGvfja8FrKwPyDJnNzmRj7cqIM38n18mkBq3bDqrKTLx
         BGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684810581; x=1687402581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HEh+zzOHQCo+TnWqwjXnzV0aEWaUm7osvJcR0/JH4oA=;
        b=dOJ3+uHCZIJaAoW90PL7cPyK24nhRkvPuX96TRADNeaCoMh/ViHi8q8fLVlmlFreN+
         0ZALe5pQviupgg+ATT+KR/mIlIn0iI+4F2QDFCL+3F9w2bVH/EcgzhXcRi3xZFgPutMS
         hEI1d/81Ywh5OSp5jrrI9wETh5Q+01Xlj9qq1ZAzjAHPFLkfGmCVdVFqJbkN27o+4PHv
         rd+HYGSJI88+TzT/7dorPsvHw1gbhwjFLVnJEKZ4erPCF5pWTfCKOL0E5fbXUTLhTaiN
         fOVq7mdwazgty2yHM5dAI3bslDrGuthTtiD3PA+MYVL/HWBU0n7CqqIPHCH3QmMV+Oo2
         8igg==
X-Gm-Message-State: AC+VfDwkv+jgZ8XTam+4hUKAezkYY+E4R7oWjsGtdqdG/munc6L83L9r
	0wJ3rLBhjKkNLH1caMcxdfI=
X-Google-Smtp-Source: ACHHUZ79Sn+U84no5jQVqdlDZxVAxrXy2Ml+G9RTfc51sKsYk6FZKLprVeDbA0URSDQ2pD2HRvtvOg==
X-Received: by 2002:a17:902:dac1:b0:1af:cbdf:8e73 with SMTP id q1-20020a170902dac100b001afcbdf8e73mr1009101plx.8.1684810581195;
        Mon, 22 May 2023 19:56:21 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:82a6:5b19:9c99:3aad])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001a67759f9f8sm5508285pll.106.2023.05.22.19.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 19:56:20 -0700 (PDT)
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
Subject: [PATCH bpf v10 00/14]  bpf sockmap fixes
Date: Mon, 22 May 2023 19:56:04 -0700
Message-Id: <20230523025618.113937-1-john.fastabend@gmail.com>
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

v10, CI noticed build error with old headers.

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

v10: CI picked up build error when system headers are missing
     ifdef.


*** BLURB HERE ***

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
 .../bpf/prog_tests/sockmap_helpers.h          | 390 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 370 +----------------
 .../bpf/progs/test_sockmap_drop_prog.c        |  32 ++
 .../selftests/bpf/progs/test_sockmap_kern.h   |  12 +-
 .../bpf/progs/test_sockmap_pass_prog.c        |  32 ++
 15 files changed, 731 insertions(+), 442 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_drop_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

-- 
2.33.0


