Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0456D51B7
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjDCUBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjDCUBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:01:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14012105;
        Mon,  3 Apr 2023 13:01:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d13so28347367pjh.0;
        Mon, 03 Apr 2023 13:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680552101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qOThgaaa7S8qO3VwVDyKmqLOKj0S6AZVxif7/iapvH0=;
        b=fjtPuA2ADhsAl+aqIS24eIFPpSc8R0tZSVGMumA+DnBaPeKc5NuBvnodD0TCrvvU7p
         2Lxs3RX+6rKVfRAaOZBbVbSuM0dLdfI3KA1ayQbi8I+yh96qBQgw+EsvlJPQWhZ0o9eo
         vImLnZsYJqnu8gcusQoT9Yq8z97MYiJ5K4lFmKPT9dK65vKPIwJRwj9YHbbAD0buTdj0
         /IMK98M/wEEfwqfU/fodgNMdUyobOPzDoR7ZEYP+kb6Rr/h3OQbunXt+4Jt+CHZWdXtG
         1CzZDgSWx339hYDM348zsDtN4CMl3W0XFIk/6uxlKdBIV0dh2UdnlNl3dBNC5xnbzIPp
         RC0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qOThgaaa7S8qO3VwVDyKmqLOKj0S6AZVxif7/iapvH0=;
        b=EwHc8KCc/eo4MYbC7kj0F9f2Ce7fuB90decGbT6ZY86zB13FOZtqDI7DcPkGDRxrk/
         LstmuawUTbEI6fP0qNaz+lr7DqCCxdIiU21on4KEJjLgC0fkPE7tPsz0+uvg3PfL6KV5
         slekzKYGCB16b/I7c1PAisSRpXMYjvrM31wmjuhkM8Lt1WxmFA8WuhRn5hAUoNVMrb6F
         ktWgnO46hDSPvFQMjCzt78ULpzxaxBrJ+YLAe1b2Skm82OGf5zfU/xUrxp+FedwWpxie
         Nz3/uYYHGSqYIvQMa4aSXGBij1pTxht4DMbVoEVLeAvsUokv9rTIGzKI9x0Y9Jy9+NbC
         FYzg==
X-Gm-Message-State: AAQBX9ff+HLBZ+YEJ0UGaZs3s8XCQCd3msLgvz0UrdjeOBVd1JHGWSJR
        li8D6hPkEh0DeFTWYOxQqFU=
X-Google-Smtp-Source: AKy350Y/kf+sDc+jZy+4/K4/aJ9BCk96JCWCx+Pz0dWPltGO5nSPIBRtos8wBAFQTnnTDIT48W6DkA==
X-Received: by 2002:a17:902:e5c2:b0:19d:1674:c04d with SMTP id u2-20020a170902e5c200b0019d1674c04dmr158870plf.61.1680552100979;
        Mon, 03 Apr 2023 13:01:40 -0700 (PDT)
Received: from localhost.localdomain ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0019c2b1c4db1sm6948835plo.239.2023.04.03.13.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:01:40 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v3 00/12] bpf sockmap fixes
Date:   Mon,  3 Apr 2023 13:01:26 -0700
Message-Id: <20230403200138.937569-1-john.fastabend@gmail.com>
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

