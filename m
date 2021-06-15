Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0A33A72CE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhFOANZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFOANX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:13:23 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33B2C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:11:04 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 5so11154962qvf.1
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjFoSGDDyYzYZW5mh9Jyks0pSyoHbJXZIOLbiyAvgAo=;
        b=VceFz1WhCRsKKkM8DFbd6FyVM9buxc8XNmTgBKrZuPPuG9RDQ9RKve/efHLh5nHB96
         YLhJUx7XIvXPge8M04nJUfY9xmuQXGnJm0cy6QMviL1M3zxWieWiG4/U0ic47kSJu8HX
         ORMDv3QkMJVa2y+xl+k3mJ2xxeCr5ik4a5SjEGLqWqgZ/G6uywg3mcsyj56dfvmD+lnn
         OoXeumjC/uttjGTXJmyprcPm0u7DqMyoGD28w8+fFiS5DkTj7MLepZ8PUXFAPXy1pc7x
         HkXf7lA8JaBmRvWAL+OdH8pmzxu9/iQdp6j7Bv+SeuRtRjrHe6Vl+df/MN3fHqLHV38v
         XGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjFoSGDDyYzYZW5mh9Jyks0pSyoHbJXZIOLbiyAvgAo=;
        b=tEkxfYseQWaKR5beuu2iGxm5LEGxWRC6rmGG80b6K7QztKmzgtzoCioNwjv9t1JwpV
         zOLPx0K5iYNU+Vtm4gAIIrHK5qGre8W6amAeXbCD34XBh8E78eB/8cVNAKWHMQmK/wcQ
         T+ecjdXbXfpFjHnNYmaDDGS0hKhZ67verjo/5g9WETRgPV/TP8KifUqP+sdEsWJfuR0o
         F1bAA1j6D/4xDbzZDeYgk14Ba+lSg/nMnohG6jukqDQNVRzYCdXCJCa//ipfdUvFnYl8
         TDHgUzc2IXDKTDeWO05qXneLXyNp4MNNU/FyS1w+gwtuzuea76Fh2wsbTPyZeTATjiBm
         2A5A==
X-Gm-Message-State: AOAM530rh9E1DoWLZA6Hl88kI7NZOACS60sKAYnlJhzlzG8ECRvUu2jI
        qESHtQbVG6Obb6qy5dicXnU2Y4P7v30=
X-Google-Smtp-Source: ABdhPJz61Sb3AyztOTNF7RtRL+Jx12TvSSE0j8OacLUdeluFlUBFTXah9+oPPZVtyrgN5vugBa9N5g==
X-Received: by 2002:a0c:e387:: with SMTP id a7mr2001606qvl.36.1623715864034;
        Mon, 14 Jun 2021 17:11:04 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:592b:4d3c:3a31:b1fe])
        by smtp.gmail.com with ESMTPSA id e1sm11153087qti.27.2021.06.14.17.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:11:03 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v6 0/3] virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
Date:   Mon, 14 Jun 2021 20:10:57 -0400
Message-Id: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch extends the flow dissector BPF program type to accept
pointer to virtio-net header. 

Second patch uses this feature to add optional flow dissection in
virtio_net_hdr_to_skb(). This allows admins to define permitted
packets more strictly, for example dropping deprecated UDP_UFO
packets.

Third patch extends kselftest to cover this feature.

Tanner Love (3):
  net: flow_dissector: extend bpf flow dissector support with vnet hdr
  virtio_net: add optional flow dissection in virtio_net_hdr_to_skb
  selftests/net: amend bpf flow dissector prog to do vnet hdr validation

 drivers/net/bonding/bond_main.c               |   2 +-
 include/linux/bpf.h                           |   3 +
 include/linux/skbuff.h                        |  35 ++-
 include/linux/virtio_net.h                    |  25 ++-
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/verifier.c                         |  35 +--
 net/bpf/test_run.c                            |   2 +-
 net/core/filter.c                             |  56 +++++
 net/core/flow_dissector.c                     |  21 +-
 net/core/sysctl_net_core.c                    |   9 +
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 209 ++++++++++++++----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 14 files changed, 502 insertions(+), 99 deletions(-)

-- 
2.32.0.272.g935e593368-goog

