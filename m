Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867533ABE02
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhFQVaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:30:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232079AbhFQVaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rxampRGzjcE7BXi+IGLmLgs/KjriV77RZF0FeFiCmCs=;
        b=Vcb48Q+7Dp5IAmoeUS6WVaJfEaEMIkc51kgRHbqkBNF7Lam891pg6KX+8AbnrEJrtPnVVA
        vsptNEt7zAgUy653WBlz7CL+KYeVksBHMpVYu7bjK+Nd1Ap77rBMV4QO3fUsXKe/amMGVT
        7r4PYDLXIO8if12b4BIEYvzSgTq5JPA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-8ukWC3dWOj6UensYVaI4ow-1; Thu, 17 Jun 2021 17:27:57 -0400
X-MC-Unique: 8ukWC3dWOj6UensYVaI4ow-1
Received: by mail-ej1-f72.google.com with SMTP id p5-20020a17090653c5b02903db1cfa514dso3014212ejo.13
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rxampRGzjcE7BXi+IGLmLgs/KjriV77RZF0FeFiCmCs=;
        b=iTrBVI25GZHyrN1b4Ai56poRVfmGjRg8omO/NwqK88pvs/t/3zzCpgKwxz2dCh9Q8E
         N/56uTfkIzvDYvswWg/XnDSjBUIartINIUHdhYCz5eWRKzaT2P/GG56GBAE7XAduCcAT
         2yyDN6vrVl031lg/KqGKi7/1a1VM/uw0MBCWvIdeXB61FE1Gsw8ERLtoaua2knhsFhzC
         HgodTvmRdNobQtqHeZkk6dYxaLgaEGVzBhw02sCj4EyrX3h7Imb7I595cg7ENPjVM5fE
         AoZvjV5n1xYgbdx3OQMBRLX6CfJahHwOE4eo9vDBBXzEak7LI3zQ3XUgKKkvcfrlN6dR
         I2JQ==
X-Gm-Message-State: AOAM530SLc7FXjCV6masSMh0X2cgAwlcCSxFQOV55hZYJpQoQOg92pTq
        0GPcpc0tNjSeZpwV5gb2XoYUitC62s1roCPUlJnt1ifTs8Rv4HoFguYxi7rq6LL8whJT9HZYFSZ
        /WF8qpxlMmIN+rX9c
X-Received: by 2002:a05:6402:1103:: with SMTP id u3mr470074edv.342.1623965275811;
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzM0kueSEDLWcIYuLGthw4ZqP5zUb8HNiqz9jdFgszpKXT8+imS4nr/anhF9YS+4qcNJaAvdw==
X-Received: by 2002:a05:6402:1103:: with SMTP id u3mr470051edv.342.1623965275581;
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g12sm2237113edb.80.2021.06.17.14.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 71900180350; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v3 00/16] Clean up and document RCU-based object protection for XDP_REDIRECT
Date:   Thu, 17 Jun 2021 23:27:32 +0200
Message-Id: <20210617212748.32456-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the discussion[0] of Hangbin's multicast patch series, Martin pointed out
that the lifetime of the RCU-protected  map entries used by XDP_REDIRECT is by
no means obvious. I promised to look into cleaning this up, and Paul helpfully
provided some hints and a new unrcu_pointer() helper to aid in this.

It seems[1] that back in the early days of XDP, local_bh_disable() did not
provide RCU protection, which is why the rcu_read_lock() calls were added
to drivers in the first place. But according to Paul[2], in recent kernels
a local_bh_disable()/local_bh_enable() pair functions as one big RCU
read-side section, so no further protection is needed. This even applies to
-rt kernels, which has an explicit rcu_read_lock() in place as part of the
local_bh_disable()[3].

This patch series is mostly a documentation exercise, cleaning up the
description of the lifetime expectations and adding __rcu annotations so
sparse and lockdep can help verify it.

Patches 1 and 2 are preparatory: Patch 1 adds Paul's unrcu_pointer()
helper (which has already been added to his tree), which we need for some
of the operations in devmap, and patch 2 adds bh context as a valid
condition for map lookups. Patch 3 is the main bit that adds the __rcu
annotations and updates documentation comments, and the rest are patches
updating the drivers, with one patch per distinct maintainer.

Unfortunately I don't have any hardware to test any of the driver patches;
Jesper helpfully verified that it doesn't break anything on i40e, but the rest
of the driver patches are only compile-tested.

[0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
[1] https://lore.kernel.org/bpf/c5192ab3-1c05-8679-79f2-59d98299095b@iogearbox.net/
[2] https://lore.kernel.org/bpf/20210417002301.GO4212@paulmck-ThinkPad-P17-Gen-1/
[3] https://lore.kernel.org/bpf/20210419165837.GA975577@paulmck-ThinkPad-P17-Gen-1/

Changelog:
v3:
  - Remove one other unnecessary change to hlist_for_each_entry_rcu()
  - Carry forward another ACK
v2:
  - Add a comment about RCU protection to the drivers where rcu_read_lock()
    is removed
  - Drop unnecessary patch 3 which changed dev_get_by_index_rcu()
  - Add some more text with the history to cover letter
  - Fix a few places where the wrong RCU checks were used in cpumap and
    xskmap code
  - Carry forward ACKs

Paul E. McKenney (1):
  rcu: Create an unrcu_pointer() to remove __rcu from a pointer

Toke Høiland-Jørgensen (15):
  bpf: allow RCU-protected lookups to happen from bh context
  xdp: add proper __rcu annotations to redirect map entries
  ena: remove rcu_read_lock() around XDP program invocation
  bnxt: remove rcu_read_lock() around XDP program invocation
  thunderx: remove rcu_read_lock() around XDP program invocation
  freescale: remove rcu_read_lock() around XDP program invocation
  net: intel: remove rcu_read_lock() around XDP program invocation
  marvell: remove rcu_read_lock() around XDP program invocation
  mlx4: remove rcu_read_lock() around XDP program invocation
  nfp: remove rcu_read_lock() around XDP program invocation
  qede: remove rcu_read_lock() around XDP program invocation
  sfc: remove rcu_read_lock() around XDP program invocation
  netsec: remove rcu_read_lock() around XDP program invocation
  stmmac: remove rcu_read_lock() around XDP program invocation
  net: ti: remove rcu_read_lock() around XDP program invocation

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  5 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  5 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 11 ++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  6 +--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 11 ++---
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 +--
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  6 +--
 drivers/net/ethernet/intel/igb/igb_main.c     |  5 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 10 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  9 ++--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  5 +-
 drivers/net/ethernet/marvell/mvneta.c         |  6 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 +--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  7 +--
 drivers/net/ethernet/sfc/rx.c                 | 12 ++---
 drivers/net/ethernet/socionext/netsec.c       |  7 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++---
 drivers/net/ethernet/ti/cpsw_priv.c           | 13 ++---
 include/linux/rcupdate.h                      | 14 ++++++
 include/net/xdp_sock.h                        |  2 +-
 kernel/bpf/cpumap.c                           | 13 +++--
 kernel/bpf/devmap.c                           | 49 ++++++++-----------
 kernel/bpf/hashtab.c                          | 21 +++++---
 kernel/bpf/helpers.c                          |  6 +--
 kernel/bpf/lpm_trie.c                         |  6 ++-
 net/core/filter.c                             | 28 +++++++++++
 net/xdp/xsk.c                                 |  4 +-
 net/xdp/xsk.h                                 |  4 +-
 net/xdp/xskmap.c                              | 29 ++++++-----
 34 files changed, 194 insertions(+), 157 deletions(-)

-- 
2.32.0

