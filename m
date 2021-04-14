Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF735F3BB
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350913AbhDNM0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhDNM0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 08:26:49 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0783C061574;
        Wed, 14 Apr 2021 05:26:26 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d124so13599801pfa.13;
        Wed, 14 Apr 2021 05:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXm7Nsf/+kF5TXyO3HTYCc/j/jomLFgBYAu9Lm7ANxg=;
        b=WXugl8pH+V5t+/jybk1o+VTybzouz3N/uwjEzigo9AVRObw0lpb8HFTBfFWXHbpqka
         KorcDigvWy82XK5WLadhH/WMXMUo20OwLGYIBt12YIQRxRsbqAPluno4GiCDa6IcpTRK
         gnBPkmTHl4Lc7ij9cbE0J6iktKXyMmmJufUh2gkFyDEmF1TIfH9IC6y9jYp+BEu8kkXa
         dpP91cEKtC+Adnczqx/cATbd/75242VrQeF7yzZLdpoFns2e9QvckdDx3FhuKQOab7ca
         XrJ50If7EE53iv3dHUiJKaPWbRZrHW08jkVlcH3nDsDA5xbU4p5C7Ypkd2Z35VJbiyN7
         ZMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXm7Nsf/+kF5TXyO3HTYCc/j/jomLFgBYAu9Lm7ANxg=;
        b=kzmDFmK5n6oeIKbK5e8MsUAvy/mgJpesywC8jzFvkRK9JAmeR5hB3+07XBMzQY6V5v
         l7vfFoQ1E91TOX9g5Xl04x/7oPgD3uuOKhxExeQ0utJA5g2zI16cvxpnzHqR8QtheKQq
         S4HZVcEKanBfy7XvLBoqaaE9vKryO6VqkmsdVuQ49xAtDQthbDPDY6FEwU7BrmrSW1PR
         ptso1x7KO+TJiltVjPfnpUbfw4w8zv4PLI+m++NCp52KnQ0m/2s6qujgAhDURTyyC6+e
         kAxLSvMhFMFjSBSq/L3QbQf3KNEsGlX0XndHlaAg+wxIvc3mdCwnAZMUyoU1tiu2ua8u
         YIKQ==
X-Gm-Message-State: AOAM531JVLZmmtNu1XuboXvTJ4rKR511MOOO3k5Qn2hMMLhnCKHgFMXj
        TnRkme53IXEa92T44vcQGIXbeXpRiMU4xQ==
X-Google-Smtp-Source: ABdhPJyPvbuJli0TfMvC2IopF76q7UsdgFppQ653PgOppOxeszEmXiw1kctQaYVwiqLJmOB94Q+fzQ==
X-Received: by 2002:a63:5508:: with SMTP id j8mr1392779pgb.36.1618403186056;
        Wed, 14 Apr 2021 05:26:26 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b23sm4789308pju.0.2021.04.14.05.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:26:25 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv7 bpf-next 0/4] xdp: extend xdp_redirect_map with broadcast support
Date:   Wed, 14 Apr 2021 20:26:06 +0800
Message-Id: <20210414122610.4037085-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset is a new implementation for XDP multicast support based
on my previous 2 maps implementation[1]. The reason is that Daniel think
the exclude map implementation is missing proper bond support in XDP
context. And there is a plan to add native XDP bonding support. Adding a
exclude map in the helper also increase the complex of verifier and has
draw back of performace.

The new implementation just add two new flags BPF_F_BROADCAST and
BPF_F_EXCLUDE_INGRESS to extend xdp_redirect_map for broadcast support.

With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
excluded when do broadcasting.

The patchv6 link is here[2].

[1] https://lore.kernel.org/bpf/20210223125809.1376577-1-liuhangbin@gmail.com
[2] https://lore.kernel.org/bpf/20210414012341.3992365-1-liuhangbin@gmail.com

v7: No need to free xdpf in dev_map_enqueue_clone() if xdpf_clone failed.
v6: Fix a skb leak in the error path for generic XDP
v5: Just walk the map directly to get interfaces as get_next_key() of devmap
    hash may restart looping from the first key if the device get removed.
    After update the performace has improved 10% compired with v4.
v4: Fix flags never cleared issue in patch 02. Update selftest to cover this.
v3: Rebase the code based on latest bpf-next
v2: fix flag renaming issue in patch 02

Hangbin Liu (3):
  xdp: extend xdp_redirect_map with broadcast support
  sample/bpf: add xdp_redirect_map_multi for redirect_map broadcast test
  selftests/bpf: add xdp_redirect_multi test

Jesper Dangaard Brouer (1):
  bpf: run devmap xdp_prog on flush instead of bulk enqueue

 include/linux/bpf.h                           |  20 ++
 include/linux/filter.h                        |  18 +-
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  17 +-
 kernel/bpf/cpumap.c                           |   3 +-
 kernel/bpf/devmap.c                           | 304 +++++++++++++++---
 net/core/filter.c                             |  33 +-
 net/core/xdp.c                                |  29 ++
 net/xdp/xskmap.c                              |   3 +-
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 302 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  17 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  99 ++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 205 ++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 236 ++++++++++++++
 17 files changed, 1316 insertions(+), 64 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.26.3

