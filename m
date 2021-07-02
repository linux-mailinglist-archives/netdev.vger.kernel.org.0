Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344343B9FAC
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhGBLWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhGBLWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:22:51 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01F4C061762;
        Fri,  2 Jul 2021 04:20:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g22so9214671pgl.7;
        Fri, 02 Jul 2021 04:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1J4tnBHmswuqlMbQoq1PIAsnJcPKSPayGpcomhoqA/4=;
        b=RnA1AIBUIjPPRVOaMdFBbznR1iZHyruKzUQ0D4eWShfMuLSxA1wWNJx24zED6Ukc+c
         uALJQX7Lyr1dnn3r2j1OFnnuYvu23kkATIxngWSPnGPX3uNqtQ7sECceSoJILgx9nouB
         A0IRIf5XokGbTq+fL6Ae3xJOtCAcsWKjipDnp5fk5xhQlU/qfzh/UyG7BeQivxtAU8KF
         1qpetsRFRmxKlqeJQT+G9eYIR8CaqRtRlZP3OolswMVm7MrwPkH8lyvQrUgBvXVEF8kE
         KPzO9pNLxDmr1VIL0ofbGU9vr9Dcj3OWwyoyU346wQ+w5Q36sOplBBeYlxyxYplUiZvd
         QYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1J4tnBHmswuqlMbQoq1PIAsnJcPKSPayGpcomhoqA/4=;
        b=BoPFUlPFFvoxWDZl/rmBNpVewwrQT9cSkZN2iRAihRf7LOPm2SW6W67SmCBashq3o/
         8Fa4lUrJj3PXzDHk8p7VsPYKPcqf+X4v+OiK+zqgGEoJOv98cNkw1hsDETyYkbE+6H7i
         jCEHsjXGWLT9FX01gMgTlPLSfGIi3hS4MdnjjM63nUqkZjgjyva0rr4npBoDKgvi93Lh
         mBIbl4gvsBtctGMw2CTzTcXDiP2YdQO32SyjVoQE6Ccte3q6d7or0MEWB2k2oPV7K3rT
         tX9g+EXqAPfLm89g8Dn2kS6D7SzoJ/i4dzGci7ZcXBEbg6EWWFJX3om3zzioFNQGKDvF
         tBEg==
X-Gm-Message-State: AOAM530ofaeq9TLU0zC2GMOZYJywHbDjEauXN6wrDPliQCgvQMUayDab
        meTNEIqosuSPgMEJHsdPyOvsPdhUxKM=
X-Google-Smtp-Source: ABdhPJzSfPsVc/DKdnJDZ1tuTdHsVN6yJj+D8MZYOrxzM/+ItI5tHmZvys7QEB8a4H2Yqn88e1fJiw==
X-Received: by 2002:a65:6a45:: with SMTP id o5mr161712pgu.409.1625224818747;
        Fri, 02 Jul 2021 04:20:18 -0700 (PDT)
Received: from localhost ([2409:4063:4d83:c0b5:70cd:e919:ab0c:33ce])
        by smtp.gmail.com with ESMTPSA id i10sm2830165pjm.51.2021.07.02.04.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 04:20:18 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>, bpf@vger.kernel.org
Subject: [PATCH net-next v6 0/5] Generic XDP improvements
Date:   Fri,  2 Jul 2021 16:48:20 +0530
Message-Id: <20210702111825.491065-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series makes some improvements to generic XDP mode and brings it
closer to native XDP. Patch 1 splits out generic XDP processing into reusable
parts, patch 2 adds pointer friendly wrappers for bitops (not have to cast back
and forth the address of local pointer to unsigned long *), patch 3 implements
generic cpumap support (details in commit) and patch 4 allows devmap bpf prog
execution before generic_xdp_tx is called.

Patch 5 just updates a couple of selftests to adapt to changes in behavior (in
that specifying devmap/cpumap prog fd in generic mode is now allowed).

Changelog:
----------
v5 -> v6
v5: https://lore.kernel.org/bpf/20210701002759.381983-1-memxor@gmail.com
 * Put rcpu->prog check before RCU-bh section to avoid do_softirq (Jesper)

v4 -> v5
v4: https://lore.kernel.org/bpf/20210628114746.129669-1-memxor@gmail.com
 * Add comments and examples for new bitops macros (Alexei)

v3 -> v4
v3: https://lore.kernel.org/bpf/20210622202835.1151230-1-memxor@gmail.com
 * Add detach now that attach of XDP program succeeds (Toke)
 * Clean up the test to use new ASSERT macros

v2 -> v3
v2: https://lore.kernel.org/bpf/20210622195527.1110497-1-memxor@gmail.com
 * list_for_each_entry -> list_for_each_entry_safe (due to deletion of skb)

v1 -> v2
v1: https://lore.kernel.org/bpf/20210620233200.855534-1-memxor@gmail.com
 * Move __ptr_{set,clear,test}_bit to bitops.h (Toke)
   Also changed argument order to match the bit op they wrap.
 * Remove map value size checking functions for cpumap/devmap (Toke)
 * Rework prog run for skb in cpu_map_kthread_run (Toke)
 * Set skb->dev to dst->dev after devmap prog has run
 * Don't set xdp rxq that will be overwritten in cpumap prog run

Kumar Kartikeya Dwivedi (5):
  net: core: split out code to run generic XDP prog
  bitops: add non-atomic bitops for pointers
  bpf: cpumap: implement generic cpumap
  bpf: devmap: implement devmap prog execution for generic XDP
  bpf: tidy xdp attach selftests

 include/linux/bitops.h                        |  50 ++++++++
 include/linux/bpf.h                           |  10 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  10 +-
 include/linux/typecheck.h                     |   9 ++
 kernel/bpf/cpumap.c                           | 116 +++++++++++++++---
 kernel/bpf/devmap.c                           |  49 ++++++--
 net/core/dev.c                                | 103 ++++++++--------
 net/core/filter.c                             |   6 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  43 +++----
 .../bpf/prog_tests/xdp_devmap_attach.c        |  39 +++---
 11 files changed, 298 insertions(+), 139 deletions(-)

-- 
2.31.1

