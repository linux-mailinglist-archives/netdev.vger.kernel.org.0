Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD833B0EBF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhFVUdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFVUdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:33:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61028C061574;
        Tue, 22 Jun 2021 13:30:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w71so492555pfd.4;
        Tue, 22 Jun 2021 13:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gmOirJqOCVETUPV1FbZFByNJhYz+YUYcI9+VcLfRUoc=;
        b=jUcGd8jnaoO2YIM2z1ipRLJKeDUK//EOVXBPejtVYqF4azm05uFodHEo6iF3Pif3JV
         OK/jAKqcqLjLnjrhCWJ6fPPrwryY5sFdvRqsZBLIKe+Fc1PHnN8IrCioX1NCLirIL71O
         mJKheywpcDGOgeJi1oyGE1NTB8WISrpacCWirFMzXLuc6R42MGLt3MN+I+rpoyUv5/A+
         +iVr0p0MFdWrk8RPNiOHJAhEv1XM/YjVmXXx0HHmt9+upwohcZCyNgYPQIBmoXpQJ6Hc
         vjx1dsBRlS5j26Z4DxHKO/h6DRpoGsoe5yOnx5T3Ee6gyWNk/lMTA7Mx9zYgXZlk0FuT
         dCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gmOirJqOCVETUPV1FbZFByNJhYz+YUYcI9+VcLfRUoc=;
        b=HUZ2vKAvCt4IqzF0v4IxTlbgnwdacWSW1Iy59VV5T9UcGfVY65xzkjYZr3BvCp7a9g
         rJNPAwERmGAQjTDB5UuDvtYuh7z0gwd1NykypeMrAwuWmK13LGh4DV13onYgVgs2u7fi
         feL2Cwb1yr15A92TNPOoZ7maM34w3jjTYcE5GFFv4Bh3AIr1dwZThYXkuNtbIowtu7QV
         DpfnBOKVdHqyi/NOIgW9XR8J23pJeKLmdCCGPhpOmRwjqnoyPlSZq1PjCxvjZTXuxvKf
         hMZhnAMEHo40u5mwUBfZnmo+Qkuu6yEUk/tKOt1G1V8kYw5tOvFhxHtgKWS+jTIw/WZw
         NSLQ==
X-Gm-Message-State: AOAM532I0bLKm8v2l4T7wwFiPU6JozNUIU/4EKSVOwZYs1C6yauNG2wX
        EaxwFxgyt/5ieXm5MtzoO9Aevgb4NXE=
X-Google-Smtp-Source: ABdhPJwwlFT2XjRWwEHaPAG5p8BmNn+9fA9/kK419rjV4LLQzGHZKDtY+rzUVz+68KqZowDNLXHXVg==
X-Received: by 2002:aa7:9729:0:b029:2ff:1e52:e284 with SMTP id k9-20020aa797290000b02902ff1e52e284mr5292021pfg.71.1624393852687;
        Tue, 22 Jun 2021 13:30:52 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id k9sm20994029pgq.27.2021.06.22.13.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:30:52 -0700 (PDT)
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
Subject: [PATCH net-next v3 0/5] Generic XDP improvements
Date:   Wed, 23 Jun 2021 01:58:30 +0530
Message-Id: <20210622202835.1151230-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

