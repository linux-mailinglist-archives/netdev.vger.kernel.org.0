Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D870C3B0DE3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhFVT7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhFVT7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:59:21 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9B0C061574;
        Tue, 22 Jun 2021 12:57:04 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t9so17973110pgn.4;
        Tue, 22 Jun 2021 12:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BjP+wzaseaUOe1ggq04UZ8G/+2+UGtC+qFFQZ8Dfhn8=;
        b=PizTu9gSV7Zxo3j2xdPos1be0hS9WYJwXrlVCqMsTRw0xxlUUTj4ya6EFg1SINyPiT
         VI6EtRMes9bqD1MD6qCmiFW3vE982Hxg08Itv4oRNNzELv99ncT+dlMKYRHFLp/3lDi9
         iBsou9GtYxJme7SZn5VrwaUW7ru1PH02eux0GATiNPyKPOCx0l+UynwZRhKmYKLIrHpy
         chikaXRLgsSKgDwfafwHF3tIzXzDuqKDkaW1aJ0HCK5v93XqVcdGi+z9N3j+haNLBT7O
         OTKt4rB9Q4D195kpkgiZd5wXJpHbguwIFUxVmPnZZO+vbX8l6mH7gwDMh8lzKCo7d8KJ
         24bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BjP+wzaseaUOe1ggq04UZ8G/+2+UGtC+qFFQZ8Dfhn8=;
        b=mR7hM/J9iNQi5FJc0G3pMsXESKEwJlDI/Ctz932lGxWKGPfAXhTzBG9eCNCA52pDb9
         bSrLZ7l9OlPwNwH4e8pzB7CewAYvvS6FtlgnB9c2xWVcVeduLtkDGjORWQszYR+dz1qy
         5FliLEXuLOwf2jV+pufCp8EuMRcm5NyRFFjl4cUpJrCPmBMEOBDNUZABOkjLhWG+/Byq
         E7rph/K0oggczbZS/tVaEcgMOHPb3ASDx9ouFHW8ycJgNZbIqRp3xeck3c/wsSRhl62g
         QHtLpSdjh1Q6zKvJ5lAxearsR3PUvSc43R3el1X+TedFEY73k5zn9SGSshodBjUiEAoM
         AGlQ==
X-Gm-Message-State: AOAM53307OWpP734EGxdIxjAhtgqcXR8TlLXob5d5uZ43dUu7td+VKxN
        w7liE6f1UW/pv3jFd42Wd8krDhpFDWg=
X-Google-Smtp-Source: ABdhPJyP6e30fGihEOvch4g334ZZxQnaCDi7vpVd038NkQvnjoaVKz8FHyEKBwuI/Up07C4kIFB4tg==
X-Received: by 2002:aa7:9562:0:b029:305:5d37:7622 with SMTP id x2-20020aa795620000b02903055d377622mr4768556pfq.2.1624391824080;
        Tue, 22 Jun 2021 12:57:04 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id m18sm157770pff.88.2021.06.22.12.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:57:03 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v2 0/5] Generic XDP improvements
Date:   Wed, 23 Jun 2021 01:25:22 +0530
Message-Id: <20210622195527.1110497-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series makes some improvements to generic XDP mode and brings it
closer to native XDP. Patch 1 splits out generic XDP processing into reusable
parts, patch 2 implements generic cpumap support (details in commit) and patch 3
allows devmap bpf prog execution before generic_xdp_tx is called.

Patch 4 just updates a couple of selftests to adapt to changes in behavior (in
that specifying devmap/cpumap prog fd in generic mode is now allowed).

Changelog:
----------
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
  bpf: update XDP selftests to not fail with generic XDP

 include/linux/bitops.h                        |  19 +++
 include/linux/bpf.h                           |  10 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |  10 +-
 include/linux/typecheck.h                     |  10 ++
 kernel/bpf/cpumap.c                           | 115 +++++++++++++++---
 kernel/bpf/devmap.c                           |  49 ++++++--
 net/core/dev.c                                | 103 ++++++++--------
 net/core/filter.c                             |   6 +-
 .../bpf/prog_tests/xdp_cpumap_attach.c        |   4 +-
 .../bpf/prog_tests/xdp_devmap_attach.c        |   4 +-
 11 files changed, 241 insertions(+), 91 deletions(-)

-- 
2.31.1

