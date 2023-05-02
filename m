Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77556F47AB
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbjEBPwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjEBPwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:05 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85CA10D;
        Tue,  2 May 2023 08:52:03 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-51f6461af24so2685500a12.2;
        Tue, 02 May 2023 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042723; x=1685634723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r3BdphdQsSlrJyN2tmOvEtvxXnrACn13kEWzmgAOb7s=;
        b=LQFy1IlxgdRy5PXfCvwSyegKhk78yjN8GWUMXMYe4nCtrqzKmuk2h08qxxhS5Y6Up1
         1lcE0s2s0ykwWU8FMkaW2dfJ+c3MmeCY1M8KhxCZvsIef/m8r+QxQi+ghug/Cuk0dmM2
         TTxhPj7ukKrmxY2iLsqxO+o6USCOdnd4wztyH+dnGw7Spu49eY7olYPJxRD1t6s5FyHX
         7Vj+i0SruzRmS6evBnvVa332kPrieZ0/K8892ijwboynKS1xdgkWNu4edKz5i6/a/Dl7
         qdRBXbBgVP5sVBeZnZKG/lAJuLZb6O4k96nGPpjT9+8c0GLrjxHgyWHQsN7FDdngNWd1
         8RUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042723; x=1685634723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3BdphdQsSlrJyN2tmOvEtvxXnrACn13kEWzmgAOb7s=;
        b=d7T3v0v7ncfvlNYsqUvAn33yx3rl389V6u1H7Q5eNBAkrI20Ek+S9fVcaZMKVUynW/
         mUhWe7bLIMJncnARVY4ooj/+9SaXYztGxjqbbqNljLFpGZ1cGsxNKUE/PpcVI1Tmor2S
         JcdbXsZWooMwXwTVPJATTSfWK5aZuoImntPA3oknG2cO4bWT5vhp1BA7lSvkCNR5uGVN
         p6rPhoLalt3sNqwY2fdaAIWROzEZ8Vmr+0GpKFgw8+rIrtc1DObXnx53Vt+mRkXly3+i
         loUvarFXIaqbxIFGa+Wic57PcDCeEq/Oe/Pf197rOkIeNic5Y7CBrCJLMBOaImLTPv8m
         V23A==
X-Gm-Message-State: AC+VfDyJs5EsBR5lnB/NegrwjEAo/7mKv3TyWgPiq1kk+QeLF5m/2Y3J
        q2I3SqKy/K5dFV0m2aJG8VV06Ian2Xw=
X-Google-Smtp-Source: ACHHUZ7umhNZ1gaFQ2/IEllFhJNZJ/Y2vfMV+ssaoFFtTSONwepayKo8zDbYXR63fKoWIjB63SjByQ==
X-Received: by 2002:a17:903:2310:b0:1a6:54ce:4311 with SMTP id d16-20020a170903231000b001a654ce4311mr22268130plh.43.1683042722877;
        Tue, 02 May 2023 08:52:02 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:02 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, cong.wang@bytedance.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 00/13] bpf sockmap fixes
Date:   Tue,  2 May 2023 08:51:46 -0700
Message-Id: <20230502155159.305437-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
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

This v7 iteration adds two new patches 3 and 4 all others are the same.

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

John Fastabend (11):
  bpf: sockmap, pass skb ownership through read_skb
  bpf: sockmap, convert schedule_work into delayed_work
  bpf: sockmap, improved check for empty queue
  bpf: sockmap, handle fin correctly
  bpf: sockmap, TCP data stall on recv before accept
  bpf: sockmap, wake up polling after data copy
  bpf: sockmap incorrectly handling copied_seq
  bpf: sockmap, pull socket helpers out of listen test for general use
  bpf: sockmap, build helper to create connected socket pair
  bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
  bpf: sockmap, test FIONREAD returns correct bytes in rx buffer

 include/linux/skmsg.h                         |   2 +-
 include/net/tcp.h                             |   1 +
 net/core/skmsg.c                              |  58 ++-
 net/core/sock_map.c                           |   3 +-
 net/ipv4/tcp.c                                |   9 -
 net/ipv4/tcp_bpf.c                            |  81 +++-
 net/ipv4/udp.c                                |   5 +-
 net/unix/af_unix.c                            |   5 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 119 +++++-
 .../bpf/prog_tests/sockmap_helpers.h          | 374 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 352 +----------------
 .../bpf/progs/test_sockmap_pass_prog.c        |  32 ++
 12 files changed, 659 insertions(+), 382 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

-- 
2.33.0

