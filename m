Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D363C6C3CFF
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjCUVwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCUVwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4269C3B3F3;
        Tue, 21 Mar 2023 14:52:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso17302848pjb.3;
        Tue, 21 Mar 2023 14:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cYk+VTiKCOdjhdiIS1p70M1pqYxzTu1OUt2vaZGGAsM=;
        b=DuJ5gB+5QST29hKwu/1YXW0u6YB/Q/4GvO5Z2cr/vOy8sR9OXDqMPmdPrBMewuTRYw
         l/J3/k4+aJcrfipybmtfu9I4/wMkIFwrFz//qaBs1x3MSVaYS/AARCT2IXlVUxCVztgJ
         Kt8p0t2FeQtOBFcq/QCvyfmGTPSrYvk1n4ecixk1vU895YZ/cvGpmZBAD2shwSD/kONB
         tLbVZ+JTiSg9A89ikk8lCLECzH7KcRhZzzT/S+yXdLDeu2i+a4n4D9A47Y/Bd2/CZj4V
         4j6DTy4EwL2xRf/XebYRTgYoT2L31HarqasmPK5uQUpJilhAYIWA3yZUdoK/9loYy9gE
         IBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cYk+VTiKCOdjhdiIS1p70M1pqYxzTu1OUt2vaZGGAsM=;
        b=QRwyuy5JkwEWD6XiwrEIkwDHxeVQepRcc5qL9JGbcfQr3cUxqldXgApF/OgsenW466
         4ICKui8u0d85QjzPTJl6XoVYmYJ2sVDIJ/3v6nHN5Xd6hiOuiySeYi3SiO1ZdIeswopg
         4O+6XAdsBb6bzunAnY/DnvfJ+StT7CG8igYYRy5GdjzJ9SjqrQ6LLltgMmnZbAsc0NHl
         sNrb3posW8yuhquGYhJwcE/ma7Uv6Z0IpGFe6OraNUaiolaXHmiV3aeShDKqRFs1CmVC
         Lo1OmjbcesSs8xxOuKW0XkUdGX+JPPbwtR+S7/xvh5hzGlcwKHHNW4Z/m4yk6LdNzLKc
         opSw==
X-Gm-Message-State: AO0yUKUCVE2daqLpZFR/GTlTtKZ/yvi2i5GkqrGvm9oX8KGvW1htUqHX
        ZhRgWX6gE04ISTSIC6cXjkT0FuCF/Qg=
X-Google-Smtp-Source: AK7set82b+PbGCWZnn4J+2tXsUcpuAj8rhtED1olJyhFWGJsA29L8SBvs2LyQSxJFvx300O518HqlQ==
X-Received: by 2002:a05:6a20:2e13:b0:c7:6f26:ca0 with SMTP id be19-20020a056a202e1300b000c76f260ca0mr2732380pzb.54.1679435535681;
        Tue, 21 Mar 2023 14:52:15 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:15 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 00/11] bpf sockmap fixes
Date:   Tue, 21 Mar 2023 14:52:01 -0700
Message-Id: <20230321215212.525630-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Finally patches 10 and 11 add the new tests to ensure we handle
ioctl(FIONREAD) and shutdown correctly.

To test the series I ran the NGINX compliance tests and the sockmap
selftests.

There are some more things to be done here, but these 11 patches
stand on their own in my opionion and fix issues we are having in
CI now. For bpf-next we can fixup/improve selftests to use the
ASSERT_* in sockmap_helpers, streamline some of the testing, and
add more tests. We also still are debugging a few additional flakes
patches coming soon.

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

